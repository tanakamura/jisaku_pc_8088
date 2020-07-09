`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/21 02:42:54
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module jisaku_pc_top#(
                      parameter integer SRAM_ADDR_WIDTH = 17, // 128KiB
                      parameter integer SRAM_SIZE = (1 << SRAM_ADDR_WIDTH),
                      parameter integer USE_Z80 = 1
                      )(
                        input wire CLK100MHZ,
                        input wire ck_rst,

                        input wire ck_scl,  // DIR
                        input wire ck_sda,  // A15
                        input wire ck_ioa,  // A14
                        input wire ck_io13, // A13
                        input wire ck_io12, // A12

                        input wire ck_io11, // A11
                        input wire ck_io10, // A10
                        input wire ck_io9,  // A9
                        input wire ck_io8,  // A8

                        inout wire ck_io41, // AD7
                        inout wire ck_io40, // AD6
                        inout wire ck_io39, // AD5
                        inout wire ck_io38, // AD4

                        inout wire ck_io37, // AD3
                        inout wire ck_io36, // AD2
                        inout wire ck_io35, // AD1
                        inout wire ck_io34, // AD0

                        input wire ck_io33, // A16
                        input wire ck_io32, // nSSO
                        input wire ck_io31, // nRD
                        input wire ck_io30, // nWR
                        
                        input wire ck_io29, // IO/nM
                        input wire ck_io28, // DT/nR
                        input wire ck_io27, // nDEN
                        input wire ck_io26, // ALE

                        output wire ck_io7, // READY
                        output wire ck_io6, // CLK
                        output wire ck_io5, // RESET
                        //output wire ck_io4,
                        //output wire ck_io3,
                        //output wire ck_io2,
                        //output wire ck_io1,
                        //output wire ck_io0,

                        output wire [3:0] led,
                        input wire [3:0] btn,

                        output wire [13:0] ddr3_sdram_addr,
                        output wire [2:0] ddr3_sdram_ba,
                        output wire ddr3_sdram_cas_n,
                        output wire ddr3_sdram_ck_n,
                        output wire ddr3_sdram_ck_p,
                        output wire ddr3_sdram_cke,
                        output wire ddr3_sdram_cs_n,
                        output wire ddr3_sdram_dm,
                        inout wire [15:0] ddr3_sdram_dq,
                        inout wire [1:0] ddr3_sdram_dqs_n,
                        inout wire [1:0] ddr3_sdram_dqs_p,
                        output wire ddr3_sdram_odt,
                        output wire ddr3_sdram_ras_n,
                        output wire ddr3_sdram_reset_n,
                        output wire ddr3_sdram_we_n,

                        qspi_flash_io0_io,
                        qspi_flash_io1_io,
                        qspi_flash_io2_io,
                        qspi_flash_io3_io,
                        qspi_flash_sck_io,
                        qspi_flash_ss_io,

                        spi_io0_io,
                        spi_io1_io,
                        spi_sck_io,
                        spi_ss_io,

                        usb_uart_rxd,
                        usb_uart_txd

                        );


    input CLK100MHZ;

    inout ck_io0;
    inout ck_io1;
    inout ck_io2;
    inout ck_io3;
    inout ck_io4;
    inout ck_io5;
    inout ck_io6;
    inout ck_io7;

    input ck_io8;
    input ck_io9;
    input ck_io10;
    input ck_io11;
    input ck_io12;
    input ck_io13;

    input ck_ioa;
    input ck_sda;
    input ck_scl;

    input ck_io26;
    input ck_io27;
    input ck_io28;

    input ck_rst;
    output ck_io29;
    output ck_io30;

    input  ck_io31;
    input  ck_io32;
    input  ck_io33;
    input  ck_io34;
    input  ck_io35;
    input  ck_io36;
    input  ck_io37;
    input  ck_io38;
    input  ck_io39;
    input  ck_io40;
    input  ck_io41;

    output led[3:0];
    input  btn[3:0];

    wire   cpu_resetn;
    wire   cpu_clk = ck_io30;

    wire   cpu_clk_30mhz;

    wire   [19:0] cpu_a = {ck_io28, ck_io27, ck_io26,

                           ck_scl, ck_sda, ck_ioa,

                           ck_io13, ck_io12,
                           ck_io11, ck_io10, ck_io9, ck_io8,
                           ck_io7, ck_io6, ck_io5, ck_io4,
                           ck_io3, ck_io2, ck_io1, ck_io0};

    output [13:0]ddr3_sdram_addr;
    output [2:0]ddr3_sdram_ba;
    output ddr3_sdram_cas_n;
    output [0:0]ddr3_sdram_ck_n;
    output [0:0]ddr3_sdram_ck_p;
    output [0:0]ddr3_sdram_cke;
    output [0:0]ddr3_sdram_cs_n;
    output [1:0]ddr3_sdram_dm;
    inout [15:0]ddr3_sdram_dq;
    inout [1:0]ddr3_sdram_dqs_n;
    inout [1:0]ddr3_sdram_dqs_p;
    output [0:0]ddr3_sdram_odt;
    output ddr3_sdram_ras_n;
    output ddr3_sdram_reset_n;
    output ddr3_sdram_we_n;

    output eth_mdio_mdc_mdc;
    inout eth_mdio_mdc_mdio_io;

    input eth_mii_col;
    input eth_mii_crs;
    output eth_mii_rst_n;
    input eth_mii_rx_clk;
    input eth_mii_rx_dv;
    input eth_mii_rx_er;
    input [3:0]eth_mii_rxd;
    input eth_mii_tx_clk;
    output eth_mii_tx_en;
    output [3:0]eth_mii_txd;
    output eth_ref_clk;

    inout spi_io0_io;
    inout spi_io1_io;
    inout spi_sck_io;
    inout spi_ss_io;

    inout qspi_flash_io0_io;
    inout qspi_flash_io1_io;
    inout qspi_flash_io2_io;
    inout qspi_flash_io3_io;
    inout qspi_flash_sck_io;
    inout qspi_flash_ss_io;

    input usb_uart_rxd;
    output usb_uart_txd;

    wire core_clk;
    wire peripheral_reset;

    //    reg [7:0] sram [SRAM_SIZE-1:0];
    //
    //    integer i;
    //    initial begin
    //        for (i=0; i<SRAM_SIZE; i++)
    //          sram [i] = i;
    //    end
    //
    //    // 30 / 5 = 6
    //    reg    [2:0] cpu_clk_div_counter;
    //
    //    always @(posedge cpu_clk_30mhz)
    //    begin
    //        if (!ck_rst) begin
    //            cpu_clk_div_counter <= 3'd0;
    //        end
    //        else begin
    //            if (cpu_clk_div_counter == 5)
    //              cpu_clk_div_counter <= 3'd0;
    //            else
    //              cpu_clk_div_counter <= cpu_clk_div_counter + 3'd1;
    //        end
    //    end
    //
    //    wire [7:0] cpu_d = {ck_io7, ck_io6, ck_io5, ck_io4,
    //                        ck_io3, ck_io2, ck_io1, ck_io0};
    //
    //    wire rdn = ck_io32;
    //
    //    assign cpu_d = (!rdn)?r_cpu_d : 8'bz;
    //
    //    reg [7:0] r_cpu_d;
    //    wire [19 - SRAM_ADDR_WIDTH:0] addr_hi;
    //    assign addr_hi = cpu_a[19:SRAM_ADDR_WIDTH];
    //
    //    always @(posedge cpu_clk_30mhz)
    //    begin
    //        if (addr_hi == 20'b0) begin
    //            r_cpu_d <= sram[cpu_a[SRAM_ADDR_WIDTH-1:0]];
    //        end else begin
    //            r_cpu_d <= 8'd0;
    //        end
    //    end
    //
    //    assign cpu_clk = (cpu_clk_div_counter >= 3'd4);
    //    assign ck_io29 = ! cpu_resetn;

    axi_devs_wrapper axi_devs(
                              .CLK_100MHZ(CLK100MHZ),
                              .RESET(ck_rst),

                              .ddr3_sdram_addr(ddr3_sdram_addr),
                              .ddr3_sdram_ba(ddr3_sdram_ba),
                              .ddr3_sdram_cas_n(ddr3_sdram_cas_n),
                              .ddr3_sdram_ck_n(ddr3_sdram_ck_n),
                              .ddr3_sdram_ck_p(ddr3_sdram_ck_p),
                              .ddr3_sdram_cke(ddr3_sdram_cke),
                              .ddr3_sdram_cs_n(ddr3_sdram_cs_n),
                              .ddr3_sdram_dm(ddr3_sdram_dm),
                              .ddr3_sdram_dq(ddr3_sdram_dq),
                              .ddr3_sdram_dqs_n(ddr3_sdram_dqs_n),
                              .ddr3_sdram_dqs_p(ddr3_sdram_dqs_p),
                              .ddr3_sdram_odt(ddr3_sdram_odt),
                              .ddr3_sdram_ras_n(ddr3_sdram_ras_n),
                              .ddr3_sdram_reset_n(ddr3_sdram_reset_n),
                              .ddr3_sdram_we_n(ddr3_sdram_we_n),

                              .eth_mdio_mdc_mdc(eth_mdio_mdc_mdc),
                              .eth_mdio_mdc_mdio_io(eth_mdio_mdc_mdio_io),
                              .eth_mii_col(eth_mii_col),
                              .eth_mii_crs(eth_mii_crs),
                              .eth_mii_rst_n(eth_mii_rst_n),
                              .eth_mii_rx_clk(eth_mii_rx_clk),
                              .eth_mii_rx_dv(eth_mii_rx_dv),
                              .eth_mii_rx_er(eth_mii_rx_er),
                              .eth_mii_rxd(eth_mii_rxd),
                              .eth_mii_tx_clk(eth_mii_tx_clk),
                              .eth_mii_tx_en(eth_mii_tx_en),
                              .eth_mii_txd(eth_mii_txd),
                              .eth_ref_clk(eth_ref_clk),

                              .qspi_flash_io0_io(qspi_flash_io0_io),
                              .qspi_flash_io1_io(qspi_flash_io1_io),
                              .qspi_flash_io2_io(qspi_flash_io2_io),
                              .qspi_flash_io3_io(qspi_flash_io3_io),
                              .qspi_flash_sck_io(qspi_flash_sck_io),
                              .qspi_flash_ss_io(qspi_flash_ss_io),

                              .spi_io0_io(spi_io0_io),
                              .spi_io1_io(spi_io1_io),
                              .spi_sck_io(spi_sck_io),
                              .spi_ss_io(spi_ss_io),
                              
                              .usb_uart_rxd(usb_uart_rxd),
                              .usb_uart_txd(usb_uart_txd),

                              .*,

                              .CLK_CORE(core_clk),
                              .peripheral_reset(peripheral_reset)
                              );

    generate
        if (USE_Z80) begin
            reg [2:0] z80_clk_div;
            reg clk_z80;

            always @(posedge core_clk) begin
                clk_z80 <= z80_clk_div[2];
                z80_clk_div <= z80_clk_div + 1;
            end

            z80_cpu z80(.RESETN(peripheral_reset),
                        .CORE_CLK(core_clk),
                        .Z80_CLK(clk_z80));
        end
    endgenerate

endmodule
