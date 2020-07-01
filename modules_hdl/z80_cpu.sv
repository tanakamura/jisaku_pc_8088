`timescale 1ns/1ps
`default_nettype none

module z80_cpu
    (output wire [31:0] AXI_araddr,
     output wire [2:0] AXI_arprot,
     input wire AXI_arready,
     output wire AXI_arvalid,

     input wire [31:0] AXI_rdata,
     output wire AXI_rready,
     input wire [1:0]  AXI_rresp,
     input wire AXI_rvalid,

     output wire [31:0] AXI_awaddr,
     output wire [2:0] AXI_awprot,
     input wire AXI_awready,
     output wire AXI_awvalid,

     output wire [31:0] AXI_wdata,
     input wire AXI_wready,
     output wire [3:0] AXI_wstrb,
     output wire AXI_wvalid,

     output wire AXI_bready,
     input wire [1:0] AXI_bresp,
     input wire AXI_bvalid,

     input wire Z80_CLK,
     input wire AXI_CLK,

     output wire [3:0] LED,

     input wire RESETN);

`include "addr_map.svh"
    parameter UART_BASE = 0;

    parameter ROM_BIT_WIDTH = 12;
    parameter ROM_SIZE = 1<<ROM_BIT_WIDTH;

    wire [15:0] A;
    wire nBUSRQ;

    wire is_read;
    wire [31:0] A32;
    reg [31:0] r_A32;
    wire [31:0] D32;
    wire [3:0] wstrb;
    wire [2:0] addr_type;
    reg [2:0] r_addr_type;

    wire nM1;
    wire nMREQ;
    wire nIORQ;
    wire nWR;
    wire nRD;
    wire nRFSH;
    wire nHALT;
    wire nBUSACK;
    wire nINT;
    wire nNMI;

    assign AXI_arprot = 3'b000;
    assign AXI_awprot = 3'b000;

    wire [7:0] D_from_cpu;

    tv80s z80(.reset_n(RESETN),
              .clk(Z80_CLK),
              .A(A),
              .wait_n(nWAIT),
              .int_n(1),
              .nmi_n(1),
              .busrq_n(1),
              .iorq_n(nIORQ),
              .rd_n(nRD),
              .wr_n(nWR),
              .halt_n(nHALT),
              .di(D_to_cpu),
              .do_(D_from_cpu),
              .mreq_n(nMREQ),
              .m1_n(nM1),
              .rfsh_n(nRFSH),
              .busak_n(nBUSACK)
              );

    assign nBUSRQ = 1;

    wire [11:0] rom_addr;
    wire [7:0] rom_data;
    wire axi_busy;
    wire [7:0] axi_read_data;

    axi_capture axi_cap(.A(r_A32),
                        .D(D32),
                        .axi_busy(axi_busy),
                        .read_data(axi_read_data),
                        .rdaddr_fetch(rdaddr_fetch & (addr_type == ADDR_TYPE_AXI)),
                        .wraddr_fetch(wraddr_fetch & (addr_type == ADDR_TYPE_AXI)),
                        .wrdata_fetch(wrdata_fetch & (addr_type == ADDR_TYPE_AXI)),
                        .BUS_CLK(Z80_CLK),
                        .AXI_CLK(AXI_CLK),
                        .RESETN(RESETN),
                        .*

                        );

    z80_rom rom(.ADDR(A32[11:0]),
                .DATA(rom_data));

    reg [7:0] ram [0:4096-1];

    assign rom_addr = A[11:0];

    reg [3:0] LED_reg;

    assign LED = LED_reg; 

    var nrd_prev;
    var nwr_prev;
    var rdaddr_fetch;
    var wraddr_fetch;
    var wrdata_fetch;

    addr_converter#(.ADDR_WIDTH(16))
    addr_conv
      (.IO(! nIORQ),
       .MEM(! nMREQ),
       .RD(! nRD),
       .WR(! nWR),
        
       .A(A),
       .D(D_from_cpu),

       .is_read(is_read),
       .A32(A32),
       .D32(D32),
       .wstrb(wstrb),

       .addr_type(addr_type)
       );

    wire nWAIT = (! axi_busy);

    var [7:0] D_to_cpu_from_internal;
    wire [7:0] D_to_cpu = (addr_type == ADDR_TYPE_AXI) ? axi_read_data : D_to_cpu_from_internal;

    always_comb begin
        if (addr_type == ADDR_TYPE_INTERNAL_ROM) begin
            D_to_cpu_from_internal = rom_data;
        end else if (addr_type == ADDR_TYPE_INTERNAL_RAM) begin
            D_to_cpu_from_internal = ram[A32[11:0]];
        end else begin
            D_to_cpu_from_internal = 0;
        end
    end

    always @(posedge Z80_CLK) begin
        if (!RESETN) begin
            LED_reg <= 0;
            wrdata_fetch <= 0;
            wraddr_fetch <= 0;
            rdaddr_fetch <= 0;
            nwr_prev <= 1;
            nrd_prev <= 1;
        end else if (nHALT) begin
            if (rdaddr_fetch) begin
                rdaddr_fetch <= 0;
            end else begin
                if (nrd_prev == 1 && nRD == 0) begin
                    rdaddr_fetch <= 1;
                    r_addr_type <= addr_type;
                    r_A32 <= A32;
                end
            end

            if (wraddr_fetch) begin
                wraddr_fetch <= 0;
            end else begin
                if (nwr_prev == 1 && nWR == 0) begin
                    r_A32 <= A32;
                    r_addr_type <= addr_type;
                    wraddr_fetch <= 1;
                end
            end

            if (wrdata_fetch) begin
                wrdata_fetch <= 0;
            end else begin
                if (nwr_prev == 1 && nWR == 0) begin
                    wrdata_fetch <= 1;

                    if (addr_type == ADDR_TYPE_INTERNAL_ROM) begin
                        ram[A32[11:0]] <= D_from_cpu;
                    end

                    if (addr_type == ADDR_TYPE_INTERNAL_LED) begin
                        LED_reg <= D_from_cpu[3:0];
                    end
                end
            end

            nrd_prev <= nRD;
            nwr_prev <= nWR;

        end
    end
endmodule

`default_nettype wire
