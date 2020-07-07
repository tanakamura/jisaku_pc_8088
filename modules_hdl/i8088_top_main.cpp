#include "Vi8088_top.h"
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
clock(Clock *clk, Vi8088_top *top, VerilatedVcdC *tfp)
{
    int i = clk->cur;

    top->CLK100MHZ = 1;
    top->eval();
    tfp->dump(cur_tick);
    cur_tick += 5;

    top->CLK100MHZ = 0;
    top->eval();
    tfp->dump(cur_tick);
    cur_tick += 5;

    clk->cur++;

    if (clk->cur == 15) {
        clk->cur = 0;
    }
}

int
main()
{
    VerilatedVcdC* tfp = new VerilatedVcdC;

    Clock C = {};

    Verilated::randReset(5);

    tfp->set_time_unit("1ns");
    tfp->set_time_resolution("1ns");

    Verilated::traceEverOn(true);
    Verilated::timeunit(-9);
    Verilated::timeprecision(-9);

    int clk;
    Vi8088_top *top = new Vi8088_top;
    top->trace(tfp, 1);
    tfp->open("i8088_top.vcd");

    top->ck_rst = 0;

    top->ck_io31 = 1;           // nrd
    top->ck_io30 = 1;           // nwr
    top->ck_io29 = 1;           // io/nm
    top->ck_io27 = 1;           // dt/nr
    top->ck_io26 = 0;           // ale

    for (int i=0; i<8*30; i++) {
        clock(&C, top, tfp);
    }

    top->ck_rst = 1;

    top->ck_io31 = 0;           // nrd
    top->ck_io30 = 1;           // nwr
    top->ck_io29 = 0;           // io/nm
    top->ck_io27 = 0;           // dt/nr
    top->ck_io26 = 1;           // ale

    top->ck_io36 = 0;
    top->ck_io35 = 1;
    top->ck_io34 = 1;

    top->ck_io33 = 0;
    top->ck_sda = 0;
    top->ck_ioa = 0;
    top->ck_io13 = 0;
    top->ck_io12 = 0;
    top->ck_io11 = 0;
    top->ck_io10 = 0;
    top->ck_io9 = 0;
    top->ck_io8 = 0;

    clock(&C, top, tfp);

    for (int i=0; i<10000; i++) {
        clock(&C, top, tfp);
    }

    top->final();
    tfp->close();

    return 0;
}

