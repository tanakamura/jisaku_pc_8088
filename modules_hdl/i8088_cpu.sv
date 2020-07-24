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

     input wire I8088_CLK,
     input wire AXI_CLK,

     output wire [3:0] LED,
     output wire [4:0] GPIO,
     input wire [3:0] PUSH_BUTTON,

     input wire ps2_clk,
     input wire ps2_data,

     input wire RESETN,

     input wire [19:0] A_cpu,
     input wire [7:0] AD8_in_cpu,
     output wire [7:0] AD8_out_cpu,
     output wire AD8_enout_cpu,
     input wire nRD_cpu,
     input wire nWR_cpu,
     input wire IO_nM_cpu,
     input wire ALE_cpu,
     //input wire DT_nR_cpu,
     //input wire nDEN_cpu,
     //input wire nSSO_cpu,
     output wire INTR_cpu,
     output wire NMI_cpu,

     output wire READY_cpu,
     output wire dbus_DIR
     );

`include "addr_map.svh"
    wire is_read_busclk;
    wire [31:0] A32_busclk;
    wire [31:0] D32_busclk;
    wire [3:0] wstrb_busclk;
    wire [2:0] addr_type_busclk;

    wire [7:0] D_from_cpu = AD8_in_cpu;

    assign AXI_arprot = 3'b000;
    assign AXI_awprot = 3'b000;

    wire nIORQ_cpu = ! IO_nM_cpu;
    wire nMREQ_cpu = IO_nM_cpu;

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
    assign dbus_DIR = ALE_cpu | nRD_cpu;

    reg nRD_prev;
    reg nMREQ_prev;
    reg nWR_prev;
    reg nIORQ_prev;
    reg [19:0] A_prev;
    reg [7:0] D_from_cpu_prev;

    reg nRD_busclk;
    reg nMREQ_busclk;
    reg nWR_busclk;
    reg nIORQ_busclk;
    reg [19:0] A_busclk;
    reg [7:0] r_D_from_cpu_busclk;
    wire [7:0] D_from_cpu_busclk;

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
            r_D_from_cpu_busclk <= D_from_cpu_valid;
        end

        nRD_prev <= nRD_cpu;
        nWR_prev <= nWR_cpu;
        nMREQ_prev <= nMREQ_cpu;
        nIORQ_prev <= nIORQ_cpu;
        A_prev <= A_cpu;
        D_from_cpu_prev <= D_from_cpu_valid;
    end

    assign D_from_cpu_busclk = from_cpu_match ? D_from_cpu : r_D_from_cpu_busclk;
    //assign D_from_cpu_busclk = r_D_from_cpu_busclk;
    wire [31:0] AXI_araddr;
    wire [31:0] AXI_awaddr;

    assign AXI_araddr33 = {1'b0, AXI_araddr};
    assign AXI_awaddr33 = {1'b0, AXI_awaddr};

    axi_capture#(.ADDR_WIDTH(32))
    axi_cap(.A(A32_busclk),
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

    i8088_rom rom(.ADDR(A32_busclk[7:0]),
                  .DATA(rom_data));

    reg [7:0] ram [0:65536-1];

    reg [3:0] LED_reg;
    reg [4:0] GPIO_reg;

    assign LED = LED_reg; 
    assign GPIO = GPIO_reg;

    var nrd_prev;
    var nwr_prev;
    var rdaddr_fetch;
    var wraddr_fetch;
    var wrdata_fetch;

    addr_converter#(.ADDR_WIDTH(20), .IS_Z80(0))
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

    wire READY_busclk = (! axi_busy);

    reg r_key_pop_cnt;
    reg [1:0] r_key_rst_cnt;
    reg r_READY_cpu;
    assign READY_cpu = (r_READY_cpu & READY_busclk & (r_key_pop_cnt == 1'd0) & (r_key_rst_cnt == 2'd0));

    always @(posedge I8088_CLK) begin
        if (!RESETN) begin
            r_READY_cpu <= 0;
        end else begin
            r_READY_cpu <= READY_busclk;
        end
    end

    reg [7:0] D_to_cpu_from_internal;
    wire [7:0] D_to_cpu = (addr_type_busclk == ADDR_TYPE_AXI) ? axi_read_data : D_to_cpu_from_internal;

    reg [7:0] ram_data;

    always @(posedge AXI_CLK) begin
        ram_data = ram[A32_busclk[15:0]];
    end

    wire [7:0] kbd_fifo_top;
    wire kbd_rx_empty;
    wire kbd_frame_error;
    wire kbd_parity_error;
    wire kbd_rx_overflow;

    //ps2_keyboard ps2_keyboard(.rstn(RESETN),// & (r_key_rst_cnt == 0)),
    //                          .ps2_clk(ps2_clk),
    //                          .ps2_data(ps2_data),
    //
    //                          .busclk(AXI_CLK),
    //                          .pop(r_key_pop_cnt),
    //                          .fifo_top(kbd_fifo_top),
    //
    //                          .rx_empty(kbd_rx_empty),
    //                          .frame_error(kbd_frame_error),
    //                          .parity_error(kbd_parity_error),
    //                          .rx_overflow(kbd_rx_overflow)
    //                          );

    always_comb begin
        if (addr_type_busclk == ADDR_TYPE_INTERNAL_ROM) begin
            D_to_cpu_from_internal = rom_data;
        end else if (addr_type_busclk == ADDR_TYPE_INTERNAL_RAM) begin
            D_to_cpu_from_internal = ram_data;
        end else if (addr_type_busclk == ADDR_TYPE_INTERNAL_PERIPHERAL) begin
            case (A_busclk[7:0])
              8'd128: D_to_cpu_from_internal = {4'd0, PUSH_BUTTON}; // button
              8'd129: D_to_cpu_from_internal = {4'd0, // keyboard status
                                                kbd_frame_error,
                                                kbd_parity_error,
                                                kbd_rx_overflow,
                                                kbd_rx_empty};
              8'd130: begin 
                  D_to_cpu_from_internal = kbd_fifo_top;
              end
              default: D_to_cpu_from_internal = 8'd0;
            endcase
        end else begin
            D_to_cpu_from_internal = 0;
        end
    end

    assign AD8_out_cpu = D_to_cpu;
    assign AD8_enout_cpu = !ALE_cpu && !nRD_cpu;

    assign INTR_cpu = 0;
    assign NMI_cpu = 0;


    reg [6:0] current;
    reg [3:0] pos;
    reg [7:0] fifo [0:(1<<FIFO_DEPTH_BITS)-1];
    reg [FIFO_DEPTH_BITS-1:0] r_fifo_head;
    reg [FIFO_DEPTH_BITS-1:0] r_fifo_tail;
    reg [7:0] r_fifo_top;

    reg parity;
    reg r_frame_error;
    reg r_parity_error;
    reg r_rx_overflow;

    // output
    assign kbd_frame_error = r_frame_error;
    assign kbd_parity_error = r_parity_error;
    assign kbd_rx_overflow = r_rx_overflow;
    assign kbd_rx_empty = (r_fifo_head == r_fifo_tail);
    assign kbd_fifo_top = r_fifo_top;

    wire [FIFO_DEPTH_BITS-1:0] next_head = r_fifo_head + 1;
    wire rx_full = (next_head == r_fifo_tail);

    reg r_clk_prev;

    always @(posedge AXI_CLK) begin
        if (!RESETN) begin
            LED_reg <= 0;
            GPIO_reg <= 0;
            wrdata_fetch <= 0;
            wraddr_fetch <= 0;
            rdaddr_fetch <= 0;
            nwr_prev <= 1;
            nrd_prev <= 1;
            r_key_pop_cnt <= 0;
            r_key_rst_cnt <= 0;

            /* kbd */
            pos <= 4'd0;
            current <= 7'd0;
            r_frame_error <= 0;
            r_parity_error <= 0;
            r_rx_overflow <= 0;
            r_fifo_head <= 0;
            r_fifo_tail <= 0;
            r_fifo_top <= 0;
            r_clk_prev <= 1;
        end else begin
            if (rdaddr_fetch) begin
                rdaddr_fetch <= 0;
            end else begin
                if (nrd_prev == 1 && nRD_busclk == 0) begin
                    rdaddr_fetch <= 1;

                    if (addr_type_busclk == ADDR_TYPE_INTERNAL_PERIPHERAL) begin
                        case (A_busclk[7:0]) 
                          8'd130: begin
                              r_key_pop_cnt <= 1;
                          end

                          default: ;
                        endcase
                    end
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
                        ram[A32_busclk[15:0]] <= D_from_cpu_busclk;
                    end

                    if (addr_type_busclk == ADDR_TYPE_INTERNAL_PERIPHERAL) begin
                        case (A_busclk[7:0])
                          8'd128:LED_reg <= D_from_cpu_busclk[3:0];
                          8'd129:GPIO_reg <= D_from_cpu_busclk[4:0];
                          8'd130:r_key_rst_cnt <= 1;
                          default: ;
                        endcase 
                    end
                end
            end

            nrd_prev <= nRD_busclk;
            nwr_prev <= nWR_busclk;

            if (r_key_pop_cnt == 1) begin
                r_key_pop_cnt <= 0;
            end

            if (r_key_rst_cnt != 0) begin
                r_key_rst_cnt <= r_key_rst_cnt + 1;
            end

            r_fifo_tail <= r_fifo_tail + 1;
        end
    end
endmodule

`default_nettype wire
