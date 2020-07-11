`timescale 1ns/1ps
`default_nettype none

module jisaku_pc_top(
                     input wire CLK100MHZ,
                     input wire ck_rst,

                     output wire ck_scl,  // DIR
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
                     input wire ck_io32, // nSSO -> A17
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

                     inout wire qspi_flash_io0_io,
                     inout wire qspi_flash_io1_io,
                     inout wire qspi_flash_io2_io,
                     inout wire qspi_flash_io3_io,
                     inout wire qspi_flash_sck_io,
                     inout wire qspi_flash_ss_io,

                     output wire [13:0] ddr3_addr,
                     output wire [2:0] ddr3_ba,
                     output wire ddr3_cas_n,
                     output wire ddr3_ck_n,
                     output wire ddr3_ck_p,
                     output wire ddr3_cke,
                     output wire ddr3_cs_n,
                     output wire [1:0] ddr3_dm,
                     inout wire [15:0] ddr3_dq,
                     inout wire [1:0] ddr3_dqs_n,
                     inout wire [1:0] ddr3_dqs_p,
                     output wire ddr3_odt,
                     output wire ddr3_ras_n,
                     output wire ddr3_reset_n,
                     output wire ddr3_we_n,


                     //inout wire spi_io0_io,
                     //inout wire spi_io1_io,
                     //inout wire spi_sck_io,
                     //inout wire spi_ss_io,

                     input wire usb_uart_rxd,
                     output wire usb_uart_txd
                     );

    wire [11:0] A19_8 = { 1'b1, 1'b1, ck_io32, ck_io33,
                          ck_sda, ck_ioa, ck_io13, ck_io12,
                          ck_io11, ck_io10, ck_io9, ck_io8 };

    wire [7:0] AD7_0_in = {ck_io41, ck_io40, ck_io39, ck_io38,
                           ck_io37, ck_io36, ck_io35, ck_io34 };


    wire AD7_0_enout;
    wire [7:0] AD7_0_out;

    pullup(ck_io41);
    pullup(ck_io40);
    pullup(ck_io39);
    pullup(ck_io38);
    pullup(ck_io37);
    pullup(ck_io36);
    pullup(ck_io35);
    pullup(ck_io34);

    assign ck_io41 = AD7_0_enout ? AD7_0_out[7] : 1'bz;
    assign ck_io40 = AD7_0_enout ? AD7_0_out[6] : 1'bz;
    assign ck_io39 = AD7_0_enout ? AD7_0_out[5] : 1'bz;
    assign ck_io38 = AD7_0_enout ? AD7_0_out[4] : 1'bz;
    assign ck_io37 = AD7_0_enout ? AD7_0_out[3] : 1'bz;
    assign ck_io36 = AD7_0_enout ? AD7_0_out[2] : 1'bz;
    assign ck_io35 = AD7_0_enout ? AD7_0_out[1] : 1'bz;
    assign ck_io34 = AD7_0_enout ? AD7_0_out[0] : 1'bz;

    wire nRD = ck_io31;
    wire nWR = ck_io30;
    wire IO_nM = ck_io29;
    wire DT_nR = ck_io28;
    wire nDEN = ck_io27;
    wire ALE = ck_io26;

    wire READY;
    assign ck_io7 = READY;
    wire CPU_CLK;
    assign ck_io6 = CPU_CLK;
    wire CPU_RESET;
    wire CPU_RESET_32;
    assign ck_io5 = CPU_RESET_32;
    wire bus_DIR;
    assign ck_scl = bus_DIR;

    wire [32:0] AXI_araddr33;
    wire [2:0] AXI_arprot;
    wire AXI_arready;
    wire AXI_arvalid;
    wire [32:0] AXI_awaddr33;
    wire [2:0] AXI_awprot;
    wire AXI_awready;
    wire AXI_awvalid;
    wire AXI_bready;
    wire [1:0] AXI_bresp;
    wire AXI_bvalid;
    wire [31:0] AXI_rdata;
    wire AXI_rready;
    wire [1:0] AXI_rresp;
    wire AXI_rvalid;
    wire [31:0] AXI_wdata;
    wire AXI_wready;
    wire [3:0] AXI_wstrb;
    wire AXI_wvalid;

    reg [1:0] div_cnt_25mhz;    // 41.666
    reg [4:0] div15_counter;
    reg [4:0] reset_counter;

    wire clk_25mhz_logic;
    assign clk_25mhz_logic = div_cnt_25mhz[1];
    wire clk_25mhz;

`ifdef GENERATE_VERILATOR
    assign clk_25mhz = clk_25mhz_logic;
`else
    BUFR clk_div_25(.CE(1),
                    .CLR(0),
                    .I(clk_25mhz_logic),
                    .O(clk_25mhz));
`endif
    initial begin
        div_cnt_25mhz = 0;
    end

    wire clk_83mhz;

    always @(posedge clk_83mhz) begin
        div_cnt_25mhz <= div_cnt_25mhz + 1;
    end

    wire PERIPHERAL_RESETN;

`ifdef GENERATE_VERILATOR

`else
    simple_uart_wrapper axi_uart(.*,
                                 .AXI_araddr(AXI_araddr33),
                                 .AXI_awaddr(AXI_awaddr33),
                                 .aclk(CLK100MHZ),
                                 .aresetn(ck_rst),
                                 .spi_clk(clk_25mhz),

                                 .CPU_RESET(CPU_RESET),
                                 .PERIPHERAL_RESETN(PERIPHERAL_RESETN),
                                 .GENERATED_BUSCLK83(clk_83mhz),

                                 .ddr3_sdram_addr(ddr3_addr),
                                 .ddr3_sdram_ba(ddr3_ba),
                                 .ddr3_sdram_cas_n(ddr3_cas_n),
                                 .ddr3_sdram_ck_n(ddr3_ck_n),
                                 .ddr3_sdram_ck_p(ddr3_ck_p),
                                 .ddr3_sdram_cke(ddr3_cke),
                                 .ddr3_sdram_cs_n(ddr3_cs_n),
                                 .ddr3_sdram_dm(ddr3_dm),
                                 .ddr3_sdram_dq(ddr3_dq),
                                 .ddr3_sdram_dqs_n(ddr3_dqs_n),
                                 .ddr3_sdram_dqs_p(ddr3_dqs_p),
                                 .ddr3_sdram_odt(ddr3_odt),
                                 .ddr3_sdram_ras_n(ddr3_ras_n),
                                 .ddr3_sdram_reset_n(ddr3_reset_n),
                                 .ddr3_sdram_we_n(ddr3_we_n)
                                 );
`endif
    always @(posedge clk_83mhz) begin
        if (CPU_RESET) begin
            div15_counter <= 0;
        end else begin 
            if (div15_counter < 5'd14) begin
                div15_counter <= div15_counter + 1;
            end else begin
                div15_counter <= 0;
            end
        end
    end
    assign CPU_CLK = div15_counter < 5'd5;

    always @(posedge CPU_CLK) begin // hold 31cycle
        if (CPU_RESET) begin
            reset_counter <= 0;
        end else begin
            if (reset_counter != 5'b11111) begin
                reset_counter <= reset_counter + 1;
            end
        end
    end

    assign CPU_RESET_32 = reset_counter != 5'b11111;

    wire INTR;
    wire NMI;

    reg r_nRD_cpu;
    reg r_nWR_cpu;
    reg [7:0] r_AD8_cpu;
    reg r_IO_nM_cpu;

    reg [19:0] r_A_cpu;

    always @(posedge CPU_CLK) begin
        r_nRD_cpu <= nRD;
        r_nWR_cpu <= nWR;
        r_AD8_cpu <= AD7_0_in;
        r_IO_nM_cpu <= IO_nM;

        if (ALE) begin
            r_A_cpu <= {A19_8, AD7_0_in};
        end
    end

    i8088_cpu cpu(.*,           // AXI
                  .PUSH_BUTTON(btn),
                  .I8088_CLK(CPU_CLK),
                  .AXI_CLK(clk_83mhz),
                  .LED(led),
                  .RESETN(PERIPHERAL_RESETN),
                  .A_cpu(r_A_cpu),
                  .AD8_in_cpu(r_AD8_cpu),
                  .AD8_out_cpu(AD7_0_out),
                  .AD8_enout_cpu(AD7_0_enout),
                  .nRD_cpu(r_nRD_cpu),
                  .nWR_cpu(r_nWR_cpu),
                  .IO_nM_cpu(r_IO_nM_cpu),
                  .ALE_cpu(ALE),
                  //.DT_nR_cpu(DT_nR),
                  //.nDEN_cpu(nDEN),
                  //.nSSO_cpu(nSSO),
                  .INTR_cpu(INTR),
                  .NMI_cpu(NMI),
                  .READY_cpu(READY),
                  .dbus_DIR(bus_DIR));

endmodule

`default_nettype wire
