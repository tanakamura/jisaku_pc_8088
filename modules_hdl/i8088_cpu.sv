`timescale 1ns/1ps
`default_nettype none

module i8088_cpu
  #(
    integer FIFO_DEPTH_BITS = 4
    )


    (output wire [32:0] AXI_araddr33,
     output wire [2:0] AXI_arprot,
     input wire AXI_arready,
     output wire AXI_arvalid,

     input wire [31:0] AXI_rdata,
     output wire AXI_rready,
     input wire [1:0]  AXI_rresp,
     input wire AXI_rvalid,

     output wire [32:0] AXI_awaddr33,
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

     input wire I8088_CLK_RISE,
     input wire AXI_CLK,

     output wire [3:0] LED,
     output wire [4:0] GPIO,
     input wire [3:0] PUSH_BUTTON,

     input wire ps2_clk,
     input wire ps2_data,

     input wire RESETN,

     input wire [19:0] A,
     input wire [7:0] AD8_in,
     output wire [7:0] AD8_out,
     output wire AD8_enout,
     input wire nRD,
     input wire nWR,
     input wire IO_nM,
     input wire ALE,
     //input wire DT_nR,
     //input wire nDEN,
     //input wire nSSO,
     output wire INTR,
     output wire NMI,

     output wire READY,
     output wire dbus_DIR
     );

`include "addr_map.svh"
    wire req_is_read;
    wire [31:0] A32_converted;
    wire [31:0] D32_converted;
    wire [3:0] wstrb_converted;
    wire [2:0] addr_type;

    wire [7:0] D_from = AD8_in;

    assign AXI_arprot = 3'b000;
    assign AXI_awprot = 3'b000;

    wire nIORQ = ! IO_nM;
    wire nMREQ = IO_nM;

    wire [7:0] rom_data;
    wire axi_busy;
    wire [7:0] axi_read_data;

    // DT nR
    // high で 8088 to Artix
    // lo で Artix to 8088

    // high で 8088 to Artix
    // lo で Artix to 8088
    //
    // A が 5V
    // B が 3.3V
    // DIR    A        B
    //  L   Output   Input
    //  H   Input    Output
    //

    //   ALE   nRD
    //    L     L     => Artix to 8088 (L)
    //    L     H     => 8088 to Artix (H)
    //    H     L     => 8088 to Aritx (H)
    //    H     H     => 8088 to Artix (H)
    assign dbus_DIR = ALE | nRD;

    reg r_nRD_prev;
    reg r_nWR_prev;

    reg r_rdaddr_fetch;
    reg r_wraddr_fetch;
    reg r_wrdata_fetch;

    wire [31:0] AXI_araddr;
    wire [31:0] AXI_awaddr;

    assign AXI_araddr33 = {1'b0, AXI_araddr};
    assign AXI_awaddr33 = {1'b0, AXI_awaddr};

    addr_converter#(.ADDR_WIDTH(20), .IS_Z80(0))
    addr_conv
      (.IO(! nIORQ),
       .MEM(! nMREQ),
       .RD(! nRD),
       .WR(! nWR),
        
       .A(A),
       .D(AD8_in),

       .A32(A32_converted),
       .D32(D32_converted),
       .wstrb(wstrb_converted),

       .is_read(req_is_read),
       .addr_type(addr_type)
       );

    axi_capture#(.ADDR_WIDTH(32))
    axi_cap(.A(A32_converted),
            .D(D32_converted),
            .axi_busy(axi_busy),
            .read_data(axi_read_data),
            .rdaddr_fetch(r_rdaddr_fetch & (addr_type == ADDR_TYPE_AXI)),
            .wraddr_fetch(r_wraddr_fetch & (addr_type == ADDR_TYPE_AXI)),
            .wrdata_fetch(r_wrdata_fetch & (addr_type == ADDR_TYPE_AXI)),
            .AXI_CLK(AXI_CLK),
            .RESETN(RESETN),
            .wstrb(wstrb_converted),
            .*

            );

    i8088_rom rom(.ADDR(A32_converted[7:0]),
                  .DATA(rom_data));

    reg [3:0] LED_reg;
    reg [4:0] GPIO_reg;

    assign LED = LED_reg; 
    assign GPIO = GPIO_reg;

    wire AXI_READY = (! axi_busy);

    reg r_key_pop_cnt;
    reg [1:0] r_key_rst_cnt;
    reg r_READY_cpu;
    assign READY = (r_READY_cpu & AXI_READY & (r_key_pop_cnt == 1'd0) & (r_key_rst_cnt == 2'd0));

    always @(posedge AXI_CLK) begin
        if (!RESETN) begin
            r_READY_cpu <= 0;
        end else if (I8088_CLK_RISE) begin
            r_READY_cpu <= AXI_READY;
        end
    end

    reg [7:0] D_to_cpu_from_internal;
    wire [7:0] D_to_cpu = (addr_type == ADDR_TYPE_AXI) ? axi_read_data : D_to_cpu_from_internal;

    wire [7:0] kbd_fifo_top;
    reg [7:0] r_kbd_fifo_top;

    wire kbd_rx_empty;
    wire kbd_frame_error;
    wire kbd_parity_error;
    wire kbd_rx_overflow;

    ps2_keyboard ps2_keyboard(.rstn(RESETN),// & (r_key_rst_cnt == 0)),
                              .ps2_clk(ps2_clk),
                              .ps2_data(ps2_data),
    
                              .busclk(AXI_CLK),
                              .pop(r_key_pop_cnt),
                              .fifo_top(kbd_fifo_top),
    
                              .rx_empty(kbd_rx_empty),
                              .frame_error(kbd_frame_error),
                              .parity_error(kbd_parity_error),
                              .rx_overflow(kbd_rx_overflow)
                              );

    always_comb begin
        if (addr_type == ADDR_TYPE_INTERNAL_ROM) begin
            D_to_cpu_from_internal = rom_data;
        end else if (addr_type == ADDR_TYPE_INTERNAL_RAM) begin
            D_to_cpu_from_internal = 0;
        end else if (addr_type == ADDR_TYPE_INTERNAL_PERIPHERAL) begin
            case (A[7:0])
              8'd128: D_to_cpu_from_internal = {4'd0, PUSH_BUTTON}; // button
              8'd129: D_to_cpu_from_internal = {4'd0, // keyboard status
                                                kbd_frame_error,
                                                kbd_parity_error,
                                                kbd_rx_overflow,
                                                kbd_rx_empty};
              8'd130: begin 
                  D_to_cpu_from_internal = r_kbd_fifo_top;
              end
              default: D_to_cpu_from_internal = 8'd0;
            endcase
        end else begin
            D_to_cpu_from_internal = 0;
        end
    end

    assign AD8_out = D_to_cpu;
    assign AD8_enout = !ALE && !nRD;

    assign INTR = 0;
    assign NMI = 0;

    always @(posedge AXI_CLK) begin
        if (!RESETN) begin
            LED_reg <= 0;
            GPIO_reg <= 0;
            r_wrdata_fetch <= 0;
            r_wraddr_fetch <= 0;
            r_rdaddr_fetch <= 0;
            r_nWR_prev <= 1;
            r_nRD_prev <= 1;
            r_key_pop_cnt <= 0;
            r_key_rst_cnt <= 0;
        end else begin
            if (r_rdaddr_fetch) begin
                r_rdaddr_fetch <= 0;
            end else begin
                if (r_nRD_prev == 1 && nRD == 0) begin
                    r_rdaddr_fetch <= 1;

                    if (addr_type == ADDR_TYPE_INTERNAL_PERIPHERAL) begin
                        case (A[7:0]) 
                          8'd130: begin
                              r_kbd_fifo_top <= kbd_fifo_top;
                              r_key_pop_cnt <= 1;
                          end

                          default: ;
                        endcase
                    end
                end
            end

            if (r_wraddr_fetch) begin
                r_wraddr_fetch <= 0;
            end else begin
                if (r_nWR_prev == 1 && nWR == 0) begin
                    r_wraddr_fetch <= 1;
                end
            end

            if (r_wrdata_fetch) begin
                r_wrdata_fetch <= 0;
            end else begin
                if (r_nWR_prev == 1 && nWR == 0) begin
                    r_wrdata_fetch <= 1;

                    if (addr_type == ADDR_TYPE_INTERNAL_PERIPHERAL) begin
                        case (A[7:0])
                          8'd128:LED_reg <= AD8_in[3:0];
                          8'd129:GPIO_reg <= AD8_in[4:0];
                          8'd130:r_key_rst_cnt <= 1;
                          default: ;
                        endcase 
                    end
                end
            end

            r_nRD_prev <= nRD;
            r_nWR_prev <= nWR;

            if (r_key_pop_cnt == 1) begin
                r_key_pop_cnt <= 0;
            end

            if (r_key_rst_cnt != 0) begin
                r_key_rst_cnt <= r_key_rst_cnt + 1;
            end
        end
    end
endmodule

`default_nettype wire
