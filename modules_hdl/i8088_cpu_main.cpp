#include "Vi8088_cpu.h"
#include <verilated_vcd_c.h>

constexpr uint32_t AXI_ADDR32_UART_RX = 0x00000000;
constexpr uint32_t AXI_ADDR32_UART_TX = 0x00000004;
constexpr uint32_t AXI_ADDR32_UART_STAT = 0x00000008;
constexpr uint32_t AXI_ADDR32_FLASH_XIP_BASE = 0x00010000;
constexpr uint32_t AXI_ADDR32_DRAM_BASE = 0x80000000;

static uint64_t cur_tick;

double
sc_time_stamp()
{
    return cur_tick;
}

struct Clock {
    int cur;
};

static void
clock(Clock *clk, Vi8088_cpu *top, VerilatedVcdC *tfp)
{
    int i = clk->cur;
    if (i < 5) {
        top->I8088_CLK = 1;
    } else {
        top->I8088_CLK = 0;
    }

    top->AXI_CLK = 1;
    top->eval();
    tfp->dump(cur_tick);
    cur_tick += 5;

    top->AXI_CLK = 0;
    top->eval();
    tfp->dump(cur_tick);
    cur_tick += 5;

    clk->cur++;

    if (clk->cur == 15) {
        clk->cur = 0;
    }
}

struct AXI_State {
    uint32_t rd_axi_addr;
    int rd_delay_cur;

    uint32_t wr_axi_addr;
    int wr_delay_cur;
};

static uint32_t dram[1024*1024];
const static uint32_t xip_rom[1024*32] = {0x11223344,0x55667788};

static void
handle_axi_wr(AXI_State *as, Vi8088_cpu *top)
{
    if (top->AXI_awvalid) {
        top->AXI_awready = 1;

        if (top->AXI_awaddr >= AXI_ADDR32_DRAM_BASE) {
            printf("AXI write addr, addr=0x%08x, range=DRAM\n",
                   top->AXI_awaddr);
        } else {
            printf("AXI write addr, addr=0x%08x, range=UNKNOWN\n",
                   top->AXI_awaddr);
        }
        as->wr_axi_addr = top->AXI_awaddr;
    } else {
        top->AXI_awready = 0;
    }

    if (top->AXI_wvalid) {
        top->AXI_wready = 1;
        printf("AXI write data, val=0x%08x, wstrb=%1x\n",
               top->AXI_wdata,
               top->AXI_wstrb);

        as->wr_delay_cur = 50;
    }

    top->AXI_bresp = 0;
    top->AXI_bvalid = 0;

    if (as->wr_delay_cur) {
        as->wr_delay_cur--;
        if (as->wr_delay_cur == 0) {
            top->AXI_bvalid = 1;
        }
    }
}

static void
handle_axi_rd(AXI_State *as, Vi8088_cpu *top)
{
    if (top->AXI_arvalid) {
        top->AXI_arready = 1;
        if (top->AXI_araddr >= AXI_ADDR32_DRAM_BASE) {
            printf("AXI read addr, addr=0x%08x, range=DRAM\n",
                   top->AXI_araddr);
        } else if (top->AXI_araddr >= AXI_ADDR32_FLASH_XIP_BASE) {
            printf("AXI read addr, addr=0x%08x, range=spi\n",
                   top->AXI_araddr);
        } else if (top->AXI_araddr == AXI_ADDR32_UART_STAT) {
            printf("AXI read addr, addr=0x%08x, range=uart stat\n",
                   top->AXI_araddr);
        } else {
            printf("AXI read addr, addr=0x%08x, range=UNKNOWN\n",
                   top->AXI_araddr);
        }

    } else {
        top->AXI_arready = 0;
    }

    if (top->AXI_rready) {
        if (as->rd_delay_cur==0) {
            as->rd_delay_cur = 10;
        }
    } else {
        top->AXI_rvalid = 0;
    }

    if (as->rd_delay_cur) {
        as->rd_delay_cur--;

        if (as->rd_delay_cur == 0) {
            top->AXI_rvalid = 1;
            top->AXI_rdata = 0x11223344;
        }
    }
}

int
main()
{
    VerilatedVcdC* tfp = new VerilatedVcdC;

    Clock C = {};

    tfp->set_time_unit("1ns");
    tfp->set_time_resolution("1ns");

    Verilated::traceEverOn(true);
    Verilated::timeunit(-9);
    Verilated::timeprecision(-9);

    int clk;
    Vi8088_cpu *top = new Vi8088_cpu;
    top->trace(tfp, 1);
    tfp->open("i8088_cpu.vcd");

    top->RESETN = 0;

    for (int i=0; i<8*30; i++) {
        clock(&C, top, tfp);
    }

    top->nDEN_cpu = 1;
    top->DT_nR_cpu = 1;
    top->RESETN = 1;

    AXI_State axi = {};

    clock(&C, top, tfp);

    

    for (int i=0; i<100000; i++) {
        clock(&C, top, tfp);

        handle_axi_wr(&axi,top);
        handle_axi_rd(&axi,top);
    }

    top->final();
    tfp->close();

    return 0;
}

