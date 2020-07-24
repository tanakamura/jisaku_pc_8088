`timescale 1ns/1ps
`default_nettype none

module ps2_keyboard
  #(parameter integer FIFO_DEPTH_BITS = 4)
    (input wire rst,
     input wire clk,
     input wire data,
     output wire clk_out,
     output wire data_out,

     input wire busclk,
     input wire pop,
     output wire [7:0] fifo_top,
     output wire rx_empty,
     output wire frame_error,
     output wire parity_error,
     output wire rx_overflow
     );

    // ps2 clk
    reg [6:0] current;
    reg [3:0] pos;
    reg [7:0] fifo [0:(1<<FIFO_DEPTH_BITS)-1];
    reg [FIFO_DEPTH_BITS-1:0] r_fifo_head_ps2clk;
    reg [FIFO_DEPTH_BITS-1:0] r_fifo_head_buf_ps2clk;
    reg [FIFO_DEPTH_BITS-1:0] r_fifo_tail_ps2clk;
    reg r_rst_seq;


    // bus clk
    reg [FIFO_DEPTH_BITS-1:0] r_fifo_tail_busclk;
    reg [FIFO_DEPTH_BITS-1:0] r_fifo_tail_buf_busclk;
    reg [FIFO_DEPTH_BITS-1:0] r_fifo_head_busclk;
    reg [7:0] r_top_buf_busclk;

    // single bit status
    reg parity;
    reg r_frame_error;
    reg r_parity_error;
    reg r_rx_overflow;

    wire head_ps2clk_match = (r_fifo_head_ps2clk == r_fifo_head_buf_ps2clk);
    wire tail_busclk_match = (r_fifo_tail_busclk == r_fifo_tail_buf_busclk);

    // comb
    var [FIFO_DEPTH_BITS-1:0] fifo_head_busclk;
    var [FIFO_DEPTH_BITS-1:0] fifo_tail_ps2clk;

    // comb
    always_comb begin
        if (head_ps2clk_match) begin
            fifo_head_busclk = r_fifo_head_ps2clk;
        end else begin
            fifo_head_busclk = r_fifo_head_busclk;
        end

        if (tail_busclk_match) begin
            fifo_tail_ps2clk = r_fifo_tail_busclk;
        end else begin
            fifo_tail_ps2clk = r_fifo_tail_ps2clk;
        end
    end

    // output
    assign frame_error = r_frame_error;
    assign parity_error = r_parity_error;
    assign rx_overflow = r_rx_overflow;
    assign rx_empty = (fifo_head_busclk == r_fifo_tail_busclk);
    assign fifo_top = fifo[r_fifo_tail_busclk][7:0];

    initial begin
        r_rst_seq = 0;
    end

    // busclk
    always @(posedge busclk) begin
        if (rst) begin
            r_rst_seq <= r_rst_seq+1;
            r_fifo_tail_busclk <= 0;
        end else begin
            if (head_ps2clk_match) begin
                r_fifo_head_busclk <= r_fifo_head_ps2clk;
            end

            if (pop) begin
                if (!rx_empty) begin
                    r_fifo_tail_busclk <= r_fifo_tail_busclk + 1;
                end
            end

            r_fifo_tail_buf_busclk <= r_fifo_tail_busclk;
        end
    end

    wire rst_seq = rst ? r_rst_seq : 1'b1;
    wire clk_or_rst = clk & (rst_seq != 0);
    wire [FIFO_DEPTH_BITS-1:0] next_head = r_fifo_head_ps2clk + 1;

    // ps2clk
    always @(negedge clk_or_rst) begin
        if (rst) begin
            pos <= 4'd0;
            r_frame_error <= 0;
            r_parity_error <= 0;
            r_rx_overflow <= 0;
            r_fifo_head_ps2clk <= 0;
            r_fifo_head_buf_ps2clk <= 0;
        end else begin
            case (pos)
              0'd0:                 // start
                if (data == 0) begin
                    pos <= 1;
                    parity <= 0;
                end else begin
                    /* frame error */
                    r_frame_error <= 1;
                end

              0'd1: begin           // d0
                  current[0:0] <= data;
                  parity <= parity ^ data;
                  pos <= 2;
              end
              0'd2: begin           // d1
                  current[1:1] <= data;
                  parity <= parity ^ data;
                  pos <= 3;
              end
              0'd3: begin           // d2
                  current[2:2] <= data;
                  parity <= parity ^ data;
                  pos <= 4;
              end
              0'd4: begin           // d3
                  current[3:3] <= data;
                  parity <= parity ^ data;
                  pos <= 5;
              end
              0'd5: begin           // d4
                  current[4:4] <= data;
                  parity <= parity ^ data;
                  pos <= 6;
              end
              0'd6: begin           // d5
                  current[5:5] <= data;
                  parity <= parity ^ data;
                  pos <= 7;
              end
              0'd7: begin           // d6
                  current[6:6] <= data;
                  parity <= parity ^ data;
                  pos <= 8;
              end
              0'd8: begin           // d7
                  parity <= parity ^ data;
                  pos <= 9;

                  if (next_head == fifo_tail_ps2clk) begin
                      r_rx_overflow <= 1;
                  end else begin
                      fifo[r_fifo_head_ps2clk][7:0] <= {data, current[6:0]};
                      r_fifo_head_ps2clk <= next_head;
                  end
              end

              0'd9: begin           // parity
                  if ((parity ^ data) != 1) begin
                      r_parity_error <= 1;
                  end
                  pos <= 10;

                  r_fifo_head_buf_ps2clk <= r_fifo_head_ps2clk;
              end

              0'd10: begin          // stop
                  if (data != 1) begin
                      r_frame_error <= 1;
                  end
                  pos <= 0;
              end
            endcase

            if (tail_busclk_match) begin
                r_fifo_tail_ps2clk <= r_fifo_tail_busclk;
            end
        end
    end
endmodule


`default_nettype wire
