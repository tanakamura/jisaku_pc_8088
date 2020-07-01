`default_nettype none

module addr_converter
  #(parameter integer ADDR_WIDTH = 20)
    (
     input wire IO,
     input wire MEM,
     input wire RD,
     input wire WR,
     input wire [ADDR_WIDTH-1:0] A,

     input wire [7:0] D,

     output var [31:0] A32,
     output var [31:0] D32,       // valid when WR (use with wstrb)
     output var [3:0] wstrb,

     output var is_read,
     output var [2:0] addr_type

     );

`include "addr_map.svh"

    always_comb
    begin
        case ({IO,MEM,RD,WR})
          4'b1010:
            begin
                // io read
                is_read = 1;
                wstrb = 0;
                D32 = 0;
                addr_type = ADDR_TYPE_AXI;

                case (A[7:0])
                  8'd0: A32 = AXI_ADDR32_UART_RX;
                  8'd2: A32 = AXI_ADDR32_UART_STAT;
                endcase
            end

          4'b0110:
            begin
                // mem read
                is_read = 1;
                wstrb = 0;
                case (A[15:12])
                  0'b0000:
                    begin
                        A32 = {20'd0, A[11:0]};
                        D32 = 0;
                        addr_type = ADDR_TYPE_INTERNAL_ROM;
                    end
                  0'b0001:
                    begin
                        A32 = {20'd0, A[11:0]};
                        D32 = 0;
                        addr_type = ADDR_TYPE_INTERNAL_RAM;
                    end

                  default:
                    begin
                        A32 = { {(32-ADDR_WIDTH){1'b0}}, A[ADDR_WIDTH-1:2], 2'b00} | AXI_ADDR32_DRAM_BASE;
                        D32 = 0;
                        addr_type = ADDR_TYPE_AXI;
                    end
                endcase
            end

          4'b1001: begin
              // io write
              is_read = 0;

              case (A[7:0])
                8'd1: begin
                    wstrb = 1;
                    A32 = AXI_ADDR32_UART_TX;
                    D32 = {24'd0, D[7:0]};
                    addr_type = ADDR_TYPE_AXI;
                end

                8'd128: begin
                    wstrb = 0;
                    A32 = 0;
                    D32 = 32'd0;
                    addr_type = ADDR_TYPE_INTERNAL_LED;
                end

                default: begin
                    wstrb = 1;
                    A32 = 0;
                    D32 = 0;
                    addr_type = ADDR_TYPE_UNKNOWN;
                end
              endcase
          end

          4'b0101:  begin
              // mem write

              is_read = 0;
              case (A[15:12])
                0'b0001: begin
                    wstrb = 0;
                    A32 = {20'd0, A[11:0]};
                    D32 = 0;
                    addr_type = ADDR_TYPE_INTERNAL_RAM;
                end

                default: begin
                    A32 = { {(32-ADDR_WIDTH){1'b0}}, A[ADDR_WIDTH-1:2], 2'd0 } | AXI_ADDR32_DRAM_BASE;
                    addr_type = ADDR_TYPE_AXI;

                    case (A[1:0]) 
                      2'b00: begin
                          D32 = { 24'd0, D };
                          wstrb = 4'b0001;
                      end

                      2'b01: begin
                          D32 = { 16'd0, D, 8'd0 };
                          wstrb = 4'b0010;
                      end

                      2'b10: begin
                          D32 = { 8'd0, D, 16'd0 };
                          wstrb = 4'b0100;
                      end

                      2'b11: begin
                          D32 = { D, 24'd0 };
                          wstrb = 4'b1000;
                      end
                    endcase
                end
              endcase
          end

          default: begin
              is_read = 0;
              A32 = 0;
              D32 = 0;
              wstrb = 0;
              addr_type = ADDR_TYPE_NOT_OP;
          end
        endcase
    end
endmodule

`default_nettype wire