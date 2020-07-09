`timescale 1ns / 1ps
`default_nettype none

module z80_test_top();
    reg clk_100mhz = 0;
    wire clk_5mhz;

    reg [3:0] div_cnt;

    initial begin
        clk_100mhz <= 0;
        div_cnt <= 0;
    end

    always #5
      clk_100mhz <= ~clk_100mhz;

    always @(posedge clk_100mhz) begin
        div_cnt <= div_cnt + 1;
    end

    wire clk_5mhz_log;
    assign clk_5mhz_log = div_cnt[3];

    BUFR clk_div(.CE(1),
                 .CLR(0),
                 .I(clk_5mhz_log),
                 .O(clk_5mhz));

    wire clk_25mhz_logic;
    assign clk_25mhz_logic = div_cnt[1];
    wire clk_25mhz;

    BUFR clk_div_25(.CE(1),
                    .CLR(0),
                    .I(clk_25mhz_logic),
                    .O(clk_25mhz));


    reg resetn;

    initial begin
        resetn = 0;
        repeat (32) @(posedge clk_5mhz);
        resetn = 1;
        repeat (1024) @(posedge clk_5mhz);
        $stop;
    end

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
    wire [0:0] AXI_wvalid;

    wire uart_rx;
    wire uart_tx;
    wire generated_resetn;

    assign uart_rx = 0;

    simple_uart_wrapper axi_uart(.AXI_araddr(AXI_araddr),
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

                                 .spi_clk(clk_25mhz),

                                 .aclk(clk_100mhz),
                                 .aresetn(resetn),
                                 .usb_uart_rxd(uart_rx),
                                 .usb_uart_txd(uart_tx),

                                 .GENERATED_RESETN(generated_resetn)
                                 );

    z80_cpu z80(.AXI_araddr(AXI_araddr),
                .AXI_arprot(AXI_arprot),
                .AXI_arready(AXI_arready),
                .AXI_arvalid(AXI_arvalid),
                .AXI_awaddr(AXI_awaddr),
                .AXI_awprot(AXI_awprot),
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

                .RESETN(generated_resetn),
                .Z80_CLK(clk_5mhz),
                .AXI_CLK(clk_100mhz)
                );

endmodule

`default_nettype wire
