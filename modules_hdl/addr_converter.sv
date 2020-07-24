`default_nettype none


module mem_addr_converter
  #(parameter integer ADDR_WIDTH = 20,
    parameter integer IS_Z80 = 1)
    (
     input wire [ADDR_WIDTH-1:0] A,
     output var [2:0] addr_type,
     output var [31:0] A32);

`include "addr_map.svh"

    generate 
        if (IS_Z80 == 1) begin
            always_comb begin
                if (A[ADDR_WIDTH-1] == 1) begin
                    // 0b1xxxx_xxxx dram
                    A32 = { {(32-(ADDR_WIDTH-1)){1'b0}}, A[ADDR_WIDTH-2:0]} | AXI_ADDR32_DRAM_BASE;
                    addr_type = ADDR_TYPE_AXI;
                end else if (A[ADDR_WIDTH-2] == 1) begin
                    // 0b01xx_xxxx flash
                    A32 = { {(32-(ADDR_WIDTH-2)){1'b0}}, A[ADDR_WIDTH-3:0]} | (AXI_ADDR32_FLASH_XIP_BASE+32'h0080_0000);
                    addr_type = ADDR_TYPE_AXI;
                end else begin
                    case (A[15:12])
                      default:
                        begin
                            A32 = {20'd0, A[11:0]};
                            addr_type = ADDR_TYPE_INTERNAL_ROM;
                        end

                      4'b0001:
                        begin
                            A32 = {20'd0, A[11:0]};
                            addr_type = ADDR_TYPE_INTERNAL_RAM;
                        end
                    endcase
                end
            end
        end else begin
            always_comb begin
                if (A[19:8] == 12'hfff) begin
                    addr_type = ADDR_TYPE_INTERNAL_ROM;
                    A32 = {24'd0, A[7:0]};
                end else begin
                    A32 = {12'd0, A[ADDR_WIDTH-1:0]} | AXI_ADDR32_DRAM_BASE;
                    addr_type = ADDR_TYPE_AXI;
                end
            end
        end
    endgenerate

endmodule


module addr_converter
  #(parameter integer ADDR_WIDTH = 20,
    parameter integer IS_Z80 = 1)
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

    wire [31:0] mem_A32;
    wire [2:0] mem_addr_type;

    mem_addr_converter#(.ADDR_WIDTH(ADDR_WIDTH), .IS_Z80(IS_Z80))
    ma(.A(A),
       .A32(mem_A32),
       .addr_type(mem_addr_type));

    always_comb
    begin
        case ({IO,MEM,RD,WR})
          4'b1010:
            begin
                // io read
                is_read = 1;
                wstrb = 0;
                D32 = 0;

                if (A[7:7] == 1) begin
                    addr_type = ADDR_TYPE_INTERNAL_PERIPHERAL;
                    A32 = 0;
                end else begin
                    case (A[6:0])
                      7'd0: begin
                          addr_type = ADDR_TYPE_AXI;
                          A32 = AXI_ADDR32_UART_RX;
                      end
                      7'd2: begin 
                          addr_type = ADDR_TYPE_AXI;
                          A32 = AXI_ADDR32_UART_STAT;
                      end

                      7'd8: begin
                          addr_type = ADDR_TYPE_AXI;
                          A32 = AXI_ADDR32_SPI_BASE + 32'h64 + 0; // SR
                      end
                      7'd9: begin
                          addr_type = ADDR_TYPE_AXI;
                          A32 = AXI_ADDR32_SPI_BASE + 32'h64 + 1; // SR + 1
                      end
                      7'd10: begin
                          addr_type = ADDR_TYPE_AXI;
                          A32 = AXI_ADDR32_SPI_BASE + 32'h6C; // DRR
                      end
                      7'd11: begin
                          addr_type = ADDR_TYPE_AXI;
                          A32 = AXI_ADDR32_SPI_BASE + 32'h70; // SSR
                      end

                      7'd12: begin
                          addr_type = ADDR_TYPE_AXI;
                          A32 = AXI_ADDR32_SPI_FLASH_BASE + 32'h64 + 0; // SR
                      end
                      7'd13: begin
                          addr_type = ADDR_TYPE_AXI;
                          A32 = AXI_ADDR32_SPI_FLASH_BASE + 32'h64 + 1; // SR + 1
                      end
                      7'd14: begin
                          addr_type = ADDR_TYPE_AXI;
                          A32 = AXI_ADDR32_SPI_FLASH_BASE + 32'h6C; // DRR
                      end
                      7'd15: begin
                          addr_type = ADDR_TYPE_AXI;
                          A32 = AXI_ADDR32_SPI_FLASH_BASE + 32'h70; // SSR
                      end

                      default: begin
                          addr_type = ADDR_TYPE_UNKNOWN;
                          A32 = 0;
                      end
                    endcase
                end
            end

          4'b0110:
            begin
                // mem read
                is_read = 1;
                wstrb = 0;
                D32 = 0;

                addr_type = mem_addr_type;
                A32 = mem_A32;
            end

          4'b1001: begin
              // io write
              is_read = 0;

              if (A[7:7] == 1) begin
                  wstrb = 0;
                  A32 = 0;
                  D32 = 32'd0;
                  addr_type = ADDR_TYPE_INTERNAL_PERIPHERAL;
              end else begin
                  case (A[6:0])
                    7'd1: begin
                        wstrb = 1;
                        A32 = AXI_ADDR32_UART_TX;
                        D32 = {24'd0, D[7:0]};
                        addr_type = ADDR_TYPE_AXI;
                    end

                    7'd8: begin     // SRR
                        wstrb = 4'b1111;
                        A32 = AXI_ADDR32_SPI_BASE + 32'h40 + 0; // SRR+0,SRR+1,SRR+2,SRR+3
                        D32 = 32'h0000_000a;
                        addr_type = ADDR_TYPE_AXI;
                    end
                    7'd9: begin     // CR
                        wstrb = 4'b1111;
                        A32 = AXI_ADDR32_SPI_BASE + 32'h60 + 0; // CR+0, CR+1
                        D32 = {24'd0, D[7:0]};
                        addr_type = ADDR_TYPE_AXI;
                    end
                    7'd10: begin    // DTR
                        wstrb = 4'b0001;
                        A32 = AXI_ADDR32_SPI_BASE + 32'h68 + 0; // DTR+0
                        D32 = {24'd0, D[7:0]};
                        addr_type = ADDR_TYPE_AXI;
                    end
                    7'd11: begin    // SSR
                        wstrb = 4'b0001;
                        A32 = AXI_ADDR32_SPI_BASE + 32'h70 + 0; // SSR+0
                        D32 = {24'd0, D[7:0]};
                        addr_type = ADDR_TYPE_AXI;
                    end

                    7'd12: begin     // SRR
                        wstrb = 4'b1111;
                        A32 = AXI_ADDR32_SPI_FLASH_BASE + 32'h40 + 0; // SRR+0,SRR+1,SRR+2,SRR+3
                        D32 = 32'h0000_000a;
                        addr_type = ADDR_TYPE_AXI;
                    end
                    7'd13: begin     // CR
                        wstrb = 4'b1111;
                        A32 = AXI_ADDR32_SPI_FLASH_BASE + 32'h60 + 0; // CR+0, CR+1
                        D32 = {24'd0, D[7:0]};
                        addr_type = ADDR_TYPE_AXI;
                    end
                    7'd14: begin    // DTR
                        wstrb = 4'b0001;
                        A32 = AXI_ADDR32_SPI_FLASH_BASE + 32'h68 + 0; // DTR+0
                        D32 = {24'd0, D[7:0]};
                        addr_type = ADDR_TYPE_AXI;
                    end
                    7'd15: begin    // SSR
                        wstrb = 4'b0001;
                        A32 = AXI_ADDR32_SPI_FLASH_BASE + 32'h70 + 0; // SSR+0
                        D32 = {24'd0, D[7:0]};
                        addr_type = ADDR_TYPE_AXI;
                    end

                    default: begin
                        wstrb = 0;
                        A32 = 0;
                        D32 = 0;
                        addr_type = ADDR_TYPE_UNKNOWN;
                    end
                  endcase
              end
          end

          4'b0101:  begin
              // mem write
              is_read = 0;
              D32 = {4{D[7:0]}};

              case (A32[1:0])
                2'b00: wstrb = 4'b0001;
                2'b01: wstrb = 4'b0010;
                2'b10: wstrb = 4'b0100;
                2'b11: wstrb = 4'b1000;
              endcase

              addr_type = mem_addr_type;
              A32 = mem_A32;
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