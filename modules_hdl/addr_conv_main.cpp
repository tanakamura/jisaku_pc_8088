#include "Vaddr_converter.h"
#include <stdint.h>

constexpr int ADDR_TYPE_INTERNAL_ROM = 0;
constexpr int ADDR_TYPE_INTERNAL_RAM = 1;
constexpr int ADDR_TYPE_INTERNAL_LED = 2;
constexpr int ADDR_TYPE_AXI = 3;
constexpr int ADDR_TYPE_INTERNAL_UNKNOWN = 4;
constexpr int ADDR_TYPE_INTERNAL_NOT_OP = 5;

void check(const char *tag,
           uint32_t expect,
           uint32_t actual,
           const char *path,
           int lineno)
{
    if (expect != actual) {
        fprintf(stderr,
                "%s:%d:%s expect {0x%x != 0x%x} actual\n",
                path, lineno, tag, expect, actual);
        exit(1);
    }
}

#define CHECK(a,b,c) check(a,b,c, __FILE__, __LINE__)

int
main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);

    Vaddr_converter *top = new Vaddr_converter();

    top->IO = 1;
    top->WR = 1;
    top->RD = 0;
    top->MEM = 0;

    top->A = 0x0;
    top->D = 9;

    top->eval();

    CHECK("iowr_addr_type", top->addr_type, ADDR_TYPE_AXI);

    top->IO = 0;
    top->WR = 0;
    top->RD = 1;
    top->MEM = 1;

    top->A = 0x8001;
    top->D = 9;
    top->eval();

    CHECK("memrd_addr_type", top->addr_type, ADDR_TYPE_AXI);


    top->A = 0x1000;
    top->D = 9;
    top->eval();
    CHECK("memrd_addr_type", top->addr_type, ADDR_TYPE_INTERNAL_RAM);

    top->A = 0x900;
    top->D = 9;
    top->eval();
    CHECK("memrd_addr_type", top->addr_type, ADDR_TYPE_INTERNAL_ROM);

    top->IO = 0;
    top->WR = 1;
    top->RD = 0;
    top->MEM = 1;

    top->A = 0x8003;
    top->D = 9;
    top->eval();
    CHECK("memrd_addr_type", top->addr_type, ADDR_TYPE_AXI);
    CHECK("axi_mem_write_wstrb", top->wstrb, 1<<3);

    top->final();

    puts("OK");

    return 0;
}