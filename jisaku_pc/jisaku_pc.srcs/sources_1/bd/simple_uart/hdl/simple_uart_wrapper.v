//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
//Date        : Wed Jul  8 04:33:46 2020
//Host        : skylake running 64-bit Arch Linux
//Command     : generate_target simple_uart_wrapper.bd
//Design      : simple_uart_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module simple_uart_wrapper
   (AXI_araddr,
    AXI_arready,
    AXI_arvalid,
    AXI_awaddr,
    AXI_awready,
    AXI_awvalid,
    AXI_bready,
    AXI_bresp,
    AXI_bvalid,
    AXI_rdata,
    AXI_rready,
    AXI_rresp,
    AXI_rvalid,
    AXI_wdata,
    AXI_wready,
    AXI_wstrb,
    AXI_wvalid,
    CPU_RESET,
    GENERATED_BUSCLK83,
    PERIPHERAL_RESETN,
    aclk,
    aresetn,
    ddr3_sdram_addr,
    ddr3_sdram_ba,
    ddr3_sdram_cas_n,
    ddr3_sdram_ck_n,
    ddr3_sdram_ck_p,
    ddr3_sdram_cke,
    ddr3_sdram_cs_n,
    ddr3_sdram_dm,
    ddr3_sdram_dq,
    ddr3_sdram_dqs_n,
    ddr3_sdram_dqs_p,
    ddr3_sdram_odt,
    ddr3_sdram_ras_n,
    ddr3_sdram_reset_n,
    ddr3_sdram_we_n,
    qspi_flash_io0_io,
    qspi_flash_io1_io,
    qspi_flash_io2_io,
    qspi_flash_io3_io,
    qspi_flash_sck_io,
    qspi_flash_ss_io,
    spi_clk,
    usb_uart_rxd,
    usb_uart_txd);
  input [32:0]AXI_araddr;
  output AXI_arready;
  input AXI_arvalid;
  input [32:0]AXI_awaddr;
  output AXI_awready;
  input AXI_awvalid;
  input AXI_bready;
  output [1:0]AXI_bresp;
  output AXI_bvalid;
  output [31:0]AXI_rdata;
  input AXI_rready;
  output [1:0]AXI_rresp;
  output AXI_rvalid;
  input [31:0]AXI_wdata;
  output AXI_wready;
  input [3:0]AXI_wstrb;
  input AXI_wvalid;
  output [0:0]CPU_RESET;
  output GENERATED_BUSCLK83;
  output [0:0]PERIPHERAL_RESETN;
  input aclk;
  input aresetn;
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
  inout qspi_flash_io0_io;
  inout qspi_flash_io1_io;
  inout qspi_flash_io2_io;
  inout qspi_flash_io3_io;
  inout qspi_flash_sck_io;
  inout qspi_flash_ss_io;
  input spi_clk;
  input usb_uart_rxd;
  output usb_uart_txd;

  wire [32:0]AXI_araddr;
  wire AXI_arready;
  wire AXI_arvalid;
  wire [32:0]AXI_awaddr;
  wire AXI_awready;
  wire AXI_awvalid;
  wire AXI_bready;
  wire [1:0]AXI_bresp;
  wire AXI_bvalid;
  wire [31:0]AXI_rdata;
  wire AXI_rready;
  wire [1:0]AXI_rresp;
  wire AXI_rvalid;
  wire [31:0]AXI_wdata;
  wire AXI_wready;
  wire [3:0]AXI_wstrb;
  wire AXI_wvalid;
  wire [0:0]CPU_RESET;
  wire GENERATED_BUSCLK83;
  wire [0:0]PERIPHERAL_RESETN;
  wire aclk;
  wire aresetn;
  wire [13:0]ddr3_sdram_addr;
  wire [2:0]ddr3_sdram_ba;
  wire ddr3_sdram_cas_n;
  wire [0:0]ddr3_sdram_ck_n;
  wire [0:0]ddr3_sdram_ck_p;
  wire [0:0]ddr3_sdram_cke;
  wire [0:0]ddr3_sdram_cs_n;
  wire [1:0]ddr3_sdram_dm;
  wire [15:0]ddr3_sdram_dq;
  wire [1:0]ddr3_sdram_dqs_n;
  wire [1:0]ddr3_sdram_dqs_p;
  wire [0:0]ddr3_sdram_odt;
  wire ddr3_sdram_ras_n;
  wire ddr3_sdram_reset_n;
  wire ddr3_sdram_we_n;
  wire qspi_flash_io0_i;
  wire qspi_flash_io0_io;
  wire qspi_flash_io0_o;
  wire qspi_flash_io0_t;
  wire qspi_flash_io1_i;
  wire qspi_flash_io1_io;
  wire qspi_flash_io1_o;
  wire qspi_flash_io1_t;
  wire qspi_flash_io2_i;
  wire qspi_flash_io2_io;
  wire qspi_flash_io2_o;
  wire qspi_flash_io2_t;
  wire qspi_flash_io3_i;
  wire qspi_flash_io3_io;
  wire qspi_flash_io3_o;
  wire qspi_flash_io3_t;
  wire qspi_flash_sck_i;
  wire qspi_flash_sck_io;
  wire qspi_flash_sck_o;
  wire qspi_flash_sck_t;
  wire qspi_flash_ss_i;
  wire qspi_flash_ss_io;
  wire qspi_flash_ss_o;
  wire qspi_flash_ss_t;
  wire spi_clk;
  wire usb_uart_rxd;
  wire usb_uart_txd;

  IOBUF qspi_flash_io0_iobuf
       (.I(qspi_flash_io0_o),
        .IO(qspi_flash_io0_io),
        .O(qspi_flash_io0_i),
        .T(qspi_flash_io0_t));
  IOBUF qspi_flash_io1_iobuf
       (.I(qspi_flash_io1_o),
        .IO(qspi_flash_io1_io),
        .O(qspi_flash_io1_i),
        .T(qspi_flash_io1_t));
  IOBUF qspi_flash_io2_iobuf
       (.I(qspi_flash_io2_o),
        .IO(qspi_flash_io2_io),
        .O(qspi_flash_io2_i),
        .T(qspi_flash_io2_t));
  IOBUF qspi_flash_io3_iobuf
       (.I(qspi_flash_io3_o),
        .IO(qspi_flash_io3_io),
        .O(qspi_flash_io3_i),
        .T(qspi_flash_io3_t));
  IOBUF qspi_flash_sck_iobuf
       (.I(qspi_flash_sck_o),
        .IO(qspi_flash_sck_io),
        .O(qspi_flash_sck_i),
        .T(qspi_flash_sck_t));
  IOBUF qspi_flash_ss_iobuf
       (.I(qspi_flash_ss_o),
        .IO(qspi_flash_ss_io),
        .O(qspi_flash_ss_i),
        .T(qspi_flash_ss_t));
  simple_uart simple_uart_i
       (.AXI_araddr(AXI_araddr),
        .AXI_arready(AXI_arready),
        .AXI_arvalid(AXI_arvalid),
        .AXI_awaddr(AXI_awaddr),
        .AXI_awready(AXI_awready),
        .AXI_awvalid(AXI_awvalid),
        .AXI_bready(AXI_bready),
        .AXI_bresp(AXI_bresp),
        .AXI_bvalid(AXI_bvalid),
        .AXI_rdata(AXI_rdata),
        .AXI_rready(AXI_rready),
        .AXI_rresp(AXI_rresp),
        .AXI_rvalid(AXI_rvalid),
        .AXI_wdata(AXI_wdata),
        .AXI_wready(AXI_wready),
        .AXI_wstrb(AXI_wstrb),
        .AXI_wvalid(AXI_wvalid),
        .CPU_RESET(CPU_RESET),
        .GENERATED_BUSCLK83(GENERATED_BUSCLK83),
        .PERIPHERAL_RESETN(PERIPHERAL_RESETN),
        .aclk(aclk),
        .aresetn(aresetn),
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
        .qspi_flash_io0_i(qspi_flash_io0_i),
        .qspi_flash_io0_o(qspi_flash_io0_o),
        .qspi_flash_io0_t(qspi_flash_io0_t),
        .qspi_flash_io1_i(qspi_flash_io1_i),
        .qspi_flash_io1_o(qspi_flash_io1_o),
        .qspi_flash_io1_t(qspi_flash_io1_t),
        .qspi_flash_io2_i(qspi_flash_io2_i),
        .qspi_flash_io2_o(qspi_flash_io2_o),
        .qspi_flash_io2_t(qspi_flash_io2_t),
        .qspi_flash_io3_i(qspi_flash_io3_i),
        .qspi_flash_io3_o(qspi_flash_io3_o),
        .qspi_flash_io3_t(qspi_flash_io3_t),
        .qspi_flash_sck_i(qspi_flash_sck_i),
        .qspi_flash_sck_o(qspi_flash_sck_o),
        .qspi_flash_sck_t(qspi_flash_sck_t),
        .qspi_flash_ss_i(qspi_flash_ss_i),
        .qspi_flash_ss_o(qspi_flash_ss_o),
        .qspi_flash_ss_t(qspi_flash_ss_t),
        .spi_clk(spi_clk),
        .usb_uart_rxd(usb_uart_rxd),
        .usb_uart_txd(usb_uart_txd));
endmodule
