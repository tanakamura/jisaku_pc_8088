#include "Vz80_cpu.h"
#include <verilated_vcd_c.h>

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
clock(Clock *clk, Vz80_cpu *top, VerilatedVcdC *tfp)
{
    int i = clk->cur;
    if (i < 5) {
        top->Z80_CLK = 1;
    } else {
        top->Z80_CLK = 0;
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
    int rd_delay_cur;
    int wr_delay_cur;
};

static void
handle_axi_wr(AXI_State *as, Vz80_cpu *top)
{
    if (top->AXI_awvalid) {
        top->AXI_awready = 1;
        printf("AXI write addr, addr=0x%08x\n",
               top->AXI_awaddr);
    } else {
        top->AXI_awready = 0;
    }

    if (top->AXI_wvalid) {
        top->AXI_wready = 1;
        printf("AXI write date, val=0x%08x, wstrb=%1x\n",
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
handle_axi_rd(AXI_State *as, Vz80_cpu *top)
{
    if (top->AXI_arvalid) {
        top->AXI_arready = 1;
        printf("AXI read addr, addr=0x%08x\n",
               top->AXI_araddr);
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
            top->AXI_rdata = 0x04;
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
    Verilated::timeprecision(-12);

    int clk;
    Vz80_cpu *top = new Vz80_cpu;
    top->trace(tfp, 1);
    tfp->open("z80_cpu.vcd");

    top->RESETN = 0;

    for (int i=0; i<8*30; i++) {
        clock(&C, top, tfp);
    }

    top->RESETN = 1;

    AXI_State axi = {};

    for (int i=0; i<100000; i++) {
        clock(&C, top, tfp);

        handle_axi_wr(&axi,top);
        handle_axi_rd(&axi,top);
    }

    top->final();
    tfp->close();

    return 0;
}

