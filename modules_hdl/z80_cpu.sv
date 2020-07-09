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

    wire [15:0] A_cpu;
    wire nBUSRQ;

    wire is_read_busclk;
    wire [31:0] A32_busclk;
    wire [31:0] D32_busclk;
    wire [3:0] wstrb_busclk;
    wire [2:0] addr_type_busclk;

    wire nM1;
    wire nMREQ_cpu;
    wire nIORQ_cpu;
    wire nWR_cpu;
    wire nRD_cpu;
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
              .A(A_cpu),
              .wait_n(nWAIT),
              .int_n(1),
              .nmi_n(1),
              .busrq_n(1),
              .iorq_n(nIORQ_cpu),
              .rd_n(nRD_cpu),
              .wr_n(nWR_cpu),
              .halt_n(nHALT),
              .di(D_to_cpu),
              .do_(D_from_cpu),
              .mreq_n(nMREQ_cpu),
              .m1_n(nM1),
              .rfsh_n(nRFSH),
              .busak_n(nBUSACK)
              );

    assign nBUSRQ = 1;

    wire [7:0] rom_data;
    wire axi_busy;
    wire [7:0] axi_read_data;

    reg nRD_prev;
    reg nMREQ_prev;
    reg nWR_prev;
    reg nIORQ_prev;
    reg [15:0] A_prev;
    reg [7:0] D_from_cpu_prev;

    reg nRD_busclk;
    reg nMREQ_busclk;
    reg nWR_busclk;
    reg nIORQ_busclk;
    reg [15:0] A_busclk;
    reg [7:0] D_from_cpu_busclk;

    wire [7:0] D_from_cpu_valid = (! nWR_cpu)?D_from_cpu:0;
    wire from_cpu_match = (nRD_prev == nRD_cpu &&
                           nWR_prev == nWR_cpu &&
                           nMREQ_prev == nMREQ_cpu &&
                           nIORQ_prev == nIORQ_cpu &&
                           A_prev == A_cpu &&
                           D_from_cpu_prev == D_from_cpu_valid);

    always @(posedge AXI_CLK) begin
        if (from_cpu_match)
        begin
            nRD_busclk <= nRD_cpu;
            nWR_busclk <= nWR_cpu;
            nMREQ_busclk <= nMREQ_cpu;
            nIORQ_busclk <= nIORQ_cpu;
            A_busclk <= A_cpu;
            D_from_cpu_busclk <= D_from_cpu_valid;
        end

        nRD_prev <= nRD_cpu;
        nWR_prev <= nWR_cpu;
        nMREQ_prev <= nMREQ_cpu;
        nIORQ_prev <= nIORQ_cpu;
        A_prev <= A_cpu;
        D_from_cpu_prev <= D_from_cpu_valid;
    end

    axi_capture axi_cap(.A(A32_busclk),
                        .D(D32_busclk),
                        .axi_busy(axi_busy),
                        .read_data(axi_read_data),
                        .rdaddr_fetch(rdaddr_fetch & (addr_type_busclk == ADDR_TYPE_AXI)),
                        .wraddr_fetch(wraddr_fetch & (addr_type_busclk == ADDR_TYPE_AXI)),
                        .wrdata_fetch(wrdata_fetch & (addr_type_busclk == ADDR_TYPE_AXI)),
                        .AXI_CLK(AXI_CLK),
                        .RESETN(RESETN),
                        .wstrb(wstrb_busclk),
                        .*

                        );

    z80_rom rom(.ADDR(A_busclk[11:0]),
                .DATA(rom_data));

    reg [7:0] ram [0:4096-1];

    reg [3:0] LED_reg;

    assign LED = LED_reg; 

    var nrd_prev;
    var nwr_prev;
    var rdaddr_fetch;
    var wraddr_fetch;
    var wrdata_fetch;

    addr_converter#(.ADDR_WIDTH(16))
    addr_conv
      (.IO(! nIORQ_busclk),
       .MEM(! nMREQ_busclk),
       .RD(! nRD_busclk),
       .WR(! nWR_busclk),
        
       .A(A_busclk),
       .D(D_from_cpu_busclk),

       .is_read(is_read_busclk),
       .A32(A32_busclk),
       .D32(D32_busclk),
       .wstrb(wstrb_busclk),

       .addr_type(addr_type_busclk)
       );

    wire nWAIT = (! axi_busy);

    var [7:0] D_to_cpu_from_internal;
    wire [7:0] D_to_cpu = (addr_type_busclk == ADDR_TYPE_AXI) ? axi_read_data : D_to_cpu_from_internal;

    reg [7:0] ram_data;

    always @(posedge AXI_CLK) begin
        ram_data = ram[A32_busclk[15:0]];
    end

    always_comb begin
        if (addr_type_busclk == ADDR_TYPE_INTERNAL_ROM) begin
            D_to_cpu_from_internal = rom_data;
        end else if (addr_type_busclk == ADDR_TYPE_INTERNAL_RAM) begin
            D_to_cpu_from_internal = ram_data;
        end else begin
            D_to_cpu_from_internal = 0;
        end
    end

    always @(posedge AXI_CLK) begin
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
                if (nrd_prev == 1 && nRD_busclk == 0) begin
                    rdaddr_fetch <= 1;
                end
            end

            if (wraddr_fetch) begin
                wraddr_fetch <= 0;
            end else begin
                if (nwr_prev == 1 && nWR_busclk == 0) begin
                    wraddr_fetch <= 1;
                end
            end

            if (wrdata_fetch) begin
                wrdata_fetch <= 0;
            end else begin
                if (nwr_prev == 1 && nWR_busclk == 0) begin
                    wrdata_fetch <= 1;

                    if (addr_type_busclk == ADDR_TYPE_INTERNAL_RAM) begin
                        ram[A32_busclk[11:0]] <= D_from_cpu_busclk;
                    end

                    if (addr_type_busclk == ADDR_TYPE_INTERNAL_LED) begin
                        LED_reg <= D_from_cpu_busclk[3:0];
                    end
                end
            end

            nrd_prev <= nRD_busclk;
            nwr_prev <= nWR_busclk;

        end
    end
endmodule

`default_nettype wire
