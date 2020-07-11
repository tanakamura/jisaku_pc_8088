`timescale 1ns / 1ps
`default_nettype none

`define den2048Mb

module top_sim(

    );
    
    reg clk = 0;
    reg resetn = 0;

    always #5
        clk = !clk;

    wire [13:0] ddr3_addr;
    wire [2:0] ddr3_ba;
    wire ddr3_cas_n;
    wire ddr3_ck_n;
    wire ddr3_ck_p;
    wire ddr3_cke;
    wire ddr3_cs_n;
    wire [1:0]ddr3_dm;
    wire [15:0] ddr3_dq;
    wire [1:0] ddr3_dqs_n;
    wire [1:0] ddr3_dqs_p;
    wire ddr3_odt;
    wire ddr3_ras_n;
    wire ddr3_reset_n;
    wire ddr3_we_n;


    wire ck_scl;  // DIR
    wire ck_sda;  // A15
    wire ck_ioa;  // A14
    wire ck_io13; // A13
    wire ck_io12; // A12

    wire ck_io11; // A11
    wire ck_io10; // A10
    wire ck_io9;  // A9
    wire ck_io8;  // A8

    wire ck_io41; // AD7
    wire ck_io40; // AD6
    wire ck_io39; // AD5
    wire ck_io38; // AD4

    wire ck_io37; // AD3
    wire ck_io36; // AD2
    wire ck_io35; // AD1
    wire ck_io34; // AD0

    wire ck_io33; // A16

    wire ck_io32; // nSSO
    var nRD;
    wire ck_io31 = nRD; // nRD
    var nWR;
    wire ck_io30 = nWR; // nWR

    var IO_nM;
    wire ck_io29 = IO_nM; // IO/nM

    var DT_nR;
    wire ck_io28 = DT_nR; // DT/nR

    var nDEN;
    wire ck_io27 = nDEN; // nDEN

    var ALE;
    wire ck_io26 = ALE; // ALE

    wire ck_io7; // READY
    wire ck_io6; // CLK
    wire ck_io5; // RESET

    wire READY = ck_io7;

    wire [3:0] led;
    wire [3:0] btn;
    wire qspi_flash_io0_io;
    wire qspi_flash_io1_io;
    wire qspi_flash_io2_io;
    wire qspi_flash_io3_io;
    wire qspi_flash_sck_io;
    wire qspi_flash_ss_io;

    wire usb_uart_rxd;
    wire usb_uart_txd;


    wire [10:0] A17_8;
    wire [7:0] AD7_0_in;

    reg [19:0] A20;
    reg [7:0] D8;

    assign A17_8 = A20[18:8];
    assign AD7_0_in = ALE ? A20[7:0] : D8[7:0];

    assign { ck_io32, ck_io33,
             ck_sda, ck_ioa, ck_io13, ck_io12,
             ck_io11, ck_io10, ck_io9, ck_io8 } = A17_8;

    assign ALE = 1;
    assign DT_nR = 0;
    assign IO_nM = 0;

    wire cpu_to_bus = (ALE | nRD);

    wire [7:0] to_bus_val8 = cpu_to_bus ? AD7_0_in : 8'bzzzzzzzz;
    assign {ck_io41, ck_io40, ck_io39, ck_io38,
            ck_io37, ck_io36, ck_io35, ck_io34 } = to_bus_val8;

    wire [7:0] D_from_bus = cpu_to_bus
               ?8'bzzzzzzzz
               :{ck_io41, ck_io40, ck_io39, ck_io38,
                 ck_io37, ck_io36, ck_io35, ck_io34 }
               ;
        
    jisaku_pc_top top(.CLK100MHZ(clk),
                      .ck_rst(resetn),
                      .*
    );

    initial begin
        nRD <= 1;
        nWR <= 1;
        nDEN <= 1;
        DT_nR <= 1;
        ALE <= 0;
        IO_nM <= 0;

        A20 <= 20'hffff0;

        resetn = 0;
        repeat (128) @(posedge clk);
        resetn = 1;
        repeat (256) @(posedge clk);

//        nRD <= 1;
//        DT_nR <= 0;
//        ALE <= 1;
//        IO_nM <= 0;
//
//        repeat (128) @(posedge clk);
//
//        nRD <= 0;
//        ALE <= 0;
//
//        repeat (128) @(posedge clk);
//
//        A20 <= 20'hffff1;
//        nRD <= 1;
//        ALE <= 1;
//
//        repeat (128) @(posedge clk);
//
//        ALE <= 0;
//
//        repeat (128) @(posedge clk);
//
//        IO_nM <= 1;
//        A20 <= 20'h00080;
//        D8 <= 3;
//        DT_nR <= 1;
//        nWR <= 1;
//        nRD <= 1;
//        ALE <= 1;
//
//        repeat (128) @(posedge clk);
//
//        nWR <= 0;
//        ALE <= 0;
//
//        repeat (128) @(posedge clk);
//
//        IO_nM <= 0;
//        nRD <= 1;
//        nWR <= 1;
//        ALE <= 1;
//        A20 <= 20'h00008;
//        repeat (128) @(posedge clk);
//        ALE <= 0;
//        nWR <= 0;
//        D8 <= 8'ha5;
//        repeat (128) @(posedge clk);
//
//
//        IO_nM <= 0;
//        nRD <= 1;
//        nWR <= 1;
//        ALE <= 1;
//        A20 <= 20'h00000;
//        repeat (128) @(posedge clk);
//        ALE <= 0;
//        nWR <= 0;
//        D8 <= 8'h5a;
//        repeat (128) @(posedge clk);
//
//
//        IO_nM <= 0;
//        nRD <= 1;
//        nWR <= 1;
//        ALE <= 1;
//        A20 <= 20'h00000;
//        repeat (128) @(posedge clk);
//
//        ALE <= 0;
//        nRD <= 0;
//        repeat (128) @(posedge clk);
//        $display("read 0 = %x\n", D_from_bus);
//
//
//        IO_nM <= 0;
//        nRD <= 1;
//        nWR <= 1;
//        ALE <= 1;
//        A20 <= 20'h00008;
//        repeat (128) @(posedge clk);
//
//        ALE <= 0;
//        nRD <= 0;
//        repeat (128) @(posedge clk);
//        $display("read 8 = %x\n", D_from_bus);

        IO_nM <= 0;
        nRD <= 1;
        nWR <= 1;
        ALE <= 1;
        A20 <= 20'h20000;
        repeat (128) @(posedge clk);

        ALE <= 0;
        nWR <= 0;
        D8 <= 9;
        $display("write DDR\n");

        fork : wait_for_write
            begin
                @(posedge READY);
                disable wait_for_write;
            end
        join

        $display("write done\n");

        IO_nM <= 0;
        nRD <= 1;
        nWR <= 1;
        ALE <= 1;
        A20 <= 20'h20000;
        repeat (128) @(posedge clk);

        ALE <= 0;
        nRD <= 0;

        fork : wait_for_read
            begin
                @(posedge READY);
                disable wait_for_read;
            end
        join

        $display("read DDR = %x\n", D_from_bus);

        $stop;
    end

    ddr3 dram(
              .rst_n(ddr3_reset_n),
              .ck(ddr3_ck_p),
              .ck_n(ddr3_ck_n),
              .cke(ddr3_cke),
              .cs_n(ddr3_cs_n),
              .ras_n(ddr3_ras_n),
              .cas_n(ddr3_cas_n),
              .we_n(ddr3_we_n),
              .dm_tdqs(ddr3_dm),
              .ba(ddr3_ba),
              .addr(ddr3_addr),
              .dq(ddr3_dq),
              .dqs(ddr3_dqs_p),
              .dqs_n(ddr3_dqs_n),
              //.tdqs_n(0,
              .odt(ddr3_odt)
              );

endmodule

`default_nettype wire
