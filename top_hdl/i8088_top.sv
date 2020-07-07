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
                     //input wire [3:0] btn,

                     inout wire qspi_flash_io0_io,
                     inout wire qspi_flash_io1_io,
                     inout wire qspi_flash_io2_io,
                     inout wire qspi_flash_io3_io,
                     inout wire qspi_flash_sck_io,
                     inout wire qspi_flash_ss_io,

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
    wire RESET;
    assign ck_io5 = RESET;
    wire bus_DIR;
    assign ck_scl = bus_DIR;

    wire [31:0] AXI_araddr;
    wire [2:0] AXI_arprot;
    wire AXI_arready;
    wire AXI_arvalid;
    wire [31:0] AXI_awaddr;
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

    reg [1:0] div_cnt_25mhz;
    reg [4:0] div18_counter;

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
        div18_counter = 0;
    end

    always @(posedge CLK100MHZ) begin
        div_cnt_25mhz <= div_cnt_25mhz + 1;
    end


    always @(posedge CLK100MHZ) begin
        if (div18_counter < 5'd17) begin
            div18_counter <= div18_counter + 1;
        end else begin
            div18_counter <= 0;
        end
    end

    assign CPU_CLK = div18_counter < 5'd6;
    wire generated_resetn;

`ifdef GENERATE_VERILATOR

`else
    simple_uart_wrapper axi_uart(.*,
                                 .aclk(CLK100MHZ),
                                 .aresetn(ck_rst),
                                 .usb_uart_rxd(usb_uart_rxd),
                                 .usb_uart_txd(usb_uart_txd),
                                 .spi_clk(clk_25mhz),

                                 .GENERATED_RESETN(generated_resetn)
                                 );
`endif

    assign RESET = ! generated_resetn;

    wire INTR;
    wire NMI;

    i8088_cpu cpu(.*,           // AXI
                  .I8088_CLK(CPU_CLK),
                  .AXI_CLK(CLK100MHZ),
                  .LED(led),
                  .RESETN(generated_resetn),
                  .A_19_8_cpu(A19_8),
                  .AD8_in_cpu(AD7_0_in),
                  .AD8_out_cpu(AD7_0_out),
                  .AD8_enout_cpu(AD7_0_enout),
                  .nRD_cpu(nRD),
                  .nWR_cpu(nWR),
                  .IO_nM_cpu(IO_nM),
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
