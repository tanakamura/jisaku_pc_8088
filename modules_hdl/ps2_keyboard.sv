`timescale 1ns/1ps
`default_nettype none

module ps2_keyboard
  #(parameter integer FIFO_DEPTH_BITS = 4)
    (input wire rstn,
     input wire ps2_clk,
     input wire ps2_data,
//     output wire clk_out,
//     output wire data_out,

     input wire busclk,
     input wire pop,
     output wire [7:0] fifo_top,
     output wire rx_empty,
     output wire frame_error,
     output wire parity_error,
     output wire rx_overflow
     );

    reg [6:0] current;
    reg [3:0] pos;
    reg [7:0] fifo [0:(1<<FIFO_DEPTH_BITS)-1];
    reg [FIFO_DEPTH_BITS-1:0] r_fifo_head;
    reg [FIFO_DEPTH_BITS-1:0] r_fifo_tail;

    reg parity;
    reg r_frame_error;
    reg r_parity_error;
    reg r_rx_overflow;

    // output
    assign frame_error = r_frame_error;
    assign parity_error = r_parity_error;
    assign rx_overflow = r_rx_overflow;
    assign rx_empty = (r_fifo_head == r_fifo_tail);
    assign fifo_top = fifo[r_fifo_tail];

    wire [FIFO_DEPTH_BITS-1:0] next_head = r_fifo_head + 1;
    wire rx_full = (next_head == r_fifo_tail);

    reg clk_prev;

    reg [2:0] r_buf_cnt;
    reg [7:0] clk_buf;

    wire clk_stable = |clk_buf;

    always @(posedge busclk) begin
        if (!rstn) begin
            pos <= 4'd0;
            current <= 7'd0;
            r_frame_error <= 0;
            r_parity_error <= 0;
            r_rx_overflow <= 0;
            r_fifo_head <= 0;
            r_fifo_tail <= 0;
            r_buf_cnt <= 0;
            clk_prev <= 1;
        end else begin
            if (clk_prev == 1 && clk_stable == 0) begin // clk : fall to zero
                case (pos)
                  4'd0:                 // start
                    if (ps2_data == 0) begin
                        pos <= 4'd12;
                        parity <= 0;
                    end else begin
                        /* frame error */
                        r_frame_error <= 1;
                    end

                  4'd12: begin           // d0
                      current[0:0] <= ps2_data;
                      parity <= parity ^ ps2_data;
                      pos <= 4'd2;
                  end

                  4'd2: begin           // d1
                      current[1:1] <= ps2_data;
                      parity <= parity ^ ps2_data;
                      pos <= 4'd3;
                  end
                  4'd3: begin           // d2
                      current[2:2] <= ps2_data;
                      parity <= parity ^ ps2_data;
                      pos <= 4'd4;
                  end
                  4'd4: begin           // d3
                      current[3:3] <= ps2_data;
                      parity <= parity ^ ps2_data;
                      pos <= 4'd5;
                  end
                  4'd5: begin           // d4
                      current[4:4] <= ps2_data;
                      parity <= parity ^ ps2_data;
                      pos <= 4'd6;
                  end
                  4'd6: begin           // d5
                      current[5:5] <= ps2_data;
                      parity <= parity ^ ps2_data;
                      pos <= 4'd7;
                  end
                  4'd7: begin           // d6
                      current[6:6] <= ps2_data;
                      parity <= parity ^ ps2_data;
                      pos <= 4'd8;
                  end
                  4'd8: begin           // d7
                      parity <= parity ^ ps2_data;
                      pos <= 4'd9;

                      if (rx_full) begin
                          r_rx_overflow <= 1;
                      end else begin
                          fifo[r_fifo_head][7:0] <= {ps2_data, current[6:0]};
                          r_fifo_head <= next_head;
                      end
                  end

                  4'd9: begin           // parity
                      if ((parity ^ ps2_data) != 1) begin
                          r_parity_error <= 1;
                      end
                      pos <= 4'd10;
                  end

                  4'd10: begin          // stop
                      if (ps2_data != 1) begin
                          r_frame_error <= 1;
                      end
                      pos <= 4'd0;
                  end

                  default:
                    ;
                endcase
            end

            clk_prev <= clk_stable;

            clk_buf[r_buf_cnt] <= ps2_clk;
            r_buf_cnt <= r_buf_cnt + 1;

            if (pop & !rx_empty) begin
                r_fifo_tail <= r_fifo_tail+1;
            end
        end
    end
endmodule


`default_nettype wire
