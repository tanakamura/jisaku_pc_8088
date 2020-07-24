#include "Vps2_keyboard.h"
#include <verilated_vcd_c.h>
#include <assert.h>

static uint64_t cur_tick;

double
sc_time_stamp()
{
    return cur_tick;
}

struct Clock {
};

static void
busclock(Clock *clk, Vps2_keyboard *top, VerilatedVcdC *tfp)
{
    top->busclk = 1;
    top->eval();
    tfp->dump(cur_tick);
    cur_tick += 5;

    top->busclk = 0;
    top->eval();
    tfp->dump(cur_tick);
    cur_tick += 5;
}

static void
ps2clk(Clock *clk, Vps2_keyboard *top, VerilatedVcdC *tfp)
{
    top->clk = 0;

    /* 100MHz / 10Khz = 10000 */

    for (int i=0; i<5000; i++) {
        busclock(clk, top, tfp);
    }

    top->clk = 1;

    for (int i=0; i<5000; i++) {
        busclock(clk, top, tfp);
    }
}

static void
recv_from_keyboard(Clock *clk, Vps2_keyboard *top, VerilatedVcdC *tfp, unsigned char c, int start=0, int parity=1, int stop=1)
{
    // start
    top->data = start;
    ps2clk(clk, top, tfp);

    // data
    for (int i=0; i<8; i++) {
        int d = (c>>i)&1;
        top->data = d;
        ps2clk(clk, top, tfp);
        parity ^= d;
    }

    top->data = parity;
    ps2clk(clk, top, tfp);

    // stop
    top->data = stop;
    ps2clk(clk, top, tfp);

    for (int i=0; i<5000*2; i++) {
        busclock(clk, top, tfp);
    }

}

static void
reset_ps2(Clock *clk, Vps2_keyboard *top, VerilatedVcdC *tfp)
{
    top->rst = 1;
    for (int i=0; i<2; i++) {
        busclock(clk, top, tfp);
    }
    top->rst = 0;
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

    Vps2_keyboard *top = new Vps2_keyboard;
    top->trace(tfp, 1);
    tfp->open("ps2keyboard.vcd");

    top->pop = 0;
    reset_ps2(&C, top, tfp);

    for (int i=0; i<5000; i++) {
        busclock(&C, top, tfp);
    }
    assert(top->rx_empty == 1);

    for (int i=0; i<15; i++) {
        recv_from_keyboard(&C, top, tfp, i);
    }

    assert(top->rx_overflow == 0);
    recv_from_keyboard(&C, top, tfp, 99);
    recv_from_keyboard(&C, top, tfp, 99);
    for (int i=0; i<500; i++) {
        busclock(&C, top, tfp);
    }

    assert(top->rx_overflow == 1);

    reset_ps2(&C, top, tfp);

    recv_from_keyboard(&C, top, tfp, 1, 1);
    for (int i=0; i<5000; i++) {
        busclock(&C, top, tfp);
    }
    assert(top->frame_error == 1);

    reset_ps2(&C, top, tfp);


//    top->pop = 1;
//    busclock(&C, top, tfp);
//    top->pop = 0;
//
//    for (int i=0; i<100000; i++) {
//        busclock(&C, top, tfp);
//    }


    for (int i=0; i<32; i++) {
        recv_from_keyboard(&C, top, tfp, i, 0);
        assert(top->rx_empty == 0);
        assert(top->fifo_top == i);

        top->pop = 1;
        busclock(&C, top, tfp);
        top->pop = 0;
        assert(top->rx_empty == 1);
    }


    top->final();
    tfp->close();

    return 0;

}