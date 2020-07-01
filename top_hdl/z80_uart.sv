`default_nettype none
module z80_uart_top(
                    CLK100MHZ,
                    usb_uart_rxd,
                    usb_uart_txd,
                    ck_rst,
                    led
                    );

    input wire CLK100MHZ;
    input wire usb_uart_rxd;
    input wire ck_rst;
    output wire usb_uart_txd;
    output [3:0] led;

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

    reg [3:0] div_cnt;
    wire clk_5mhz_log;
    wire clk_5mhz;
    assign clk_5mhz_log = div_cnt[3];

    BUFR clk_div(.CE(1),
                 .CLR(0),
                 .I(clk_5mhz_log),
                 .O(clk_5mhz));

    always @(posedge CLK100MHZ) begin
        div_cnt <= div_cnt + 1;
    end

    wire generated_resetn;

    z80_cpu z80(.*,
                .RESETN(generated_resetn),
                .Z80_CLK(clk_5mhz),
                .LED(led),
                .AXI_CLK(CLK100MHZ)
                );

    simple_uart_wrapper axi_uart(.*,
                                 .aclk(CLK100MHZ),
                                 .aresetn(ck_rst),
                                 .usb_uart_rxd(usb_uart_rxd),
                                 .usb_uart_txd(usb_uart_txd),

                                 .GENERATED_RESETN(generated_resetn)
                                 );


endmodule
`default_nettype wire
