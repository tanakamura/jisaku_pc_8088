`default_nettype none

module z80_cpu
    (AXI_araddr,
     AXI_arprot,
     AXI_arready,
     AXI_arvalid,

     AXI_rdata,
     AXI_rready,
     AXI_rresp,
     AXI_rvalid,

     AXI_awaddr,
     AXI_awprot,
     AXI_awready,
     AXI_awvalid,

     AXI_wdata,
     AXI_wready,
     AXI_wstrb,
     AXI_wvalid,

     AXI_bready,
     AXI_bresp,
     AXI_bvalid,

     Z80_CLK,

     LED,

     RESETN);

`include "addr_map.svh"
    parameter UART_BASE = 0;

    output [31:0] AXI_araddr;
    output [2:0] AXI_arprot;
    input wire AXI_arready;
    output [0:0] AXI_arvalid;
    output [31:0] AXI_awaddr;
    output [2:0] AXI_awprot;
    input wire AXI_awready;
    output [0:0] AXI_awvalid;
    output [0:0] AXI_bready;
    input [1:0] AXI_bresp;
    input wire AXI_bvalid;
    input [31:0] AXI_rdata;
    output wire AXI_rready;
    input [1:0] AXI_rresp;
    input wire AXI_rvalid;
    output [31:0] AXI_wdata;
    input wire AXI_wready;
    output [3:0] AXI_wstrb;
    output wire AXI_wvalid;

    output [3:0] LED;

    input wire Z80_CLK;
    input wire RESETN;

    parameter ROM_BIT_WIDTH = 12;
    parameter ROM_SIZE = 1<<ROM_BIT_WIDTH;

    reg [7:0] D_reg;

    wire [15:0] A;
    wire [7:0] D;
    wire nBUSRQ;

    reg nWAIT;

    reg io_bus;
    reg [7:0] io_addr;
    reg [7:0] io_data;

    reg [31:0] io_addr_converted;
    reg [3:0] io_wstrb_converted;
    reg [31:0] io_wdata_converted;

    reg axi_rready;
    reg axi_arvalid;
    reg [7:0] axi_readdata;
    reg axi_awvalid;
    reg axi_wvalid;

    assign AXI_araddr = io_addr_converted;
    assign AXI_awaddr = io_addr_converted;
    assign AXI_rready = axi_rready;
    assign AXI_wdata = io_wdata_converted;
    assign AXI_wstrb = io_wstrb_converted;
    assign AXI_arvalid = axi_arvalid;
    assign AXI_wvalid = axi_wvalid;
    assign AXI_awvalid = axi_awvalid;

    assign AXI_bready = 1;
    assign AXI_arprot = 3'b000;
    assign AXI_awprot = 3'b000;

    wire nM1;
    wire nMREQ;
    wire nIORQ;
    wire nWR;
    wire nRD;
    wire nRFSH;
    wire nHALT;
    wire nBUSACK;
    wire nINT;
    wire nNMI;

    z80_top_direct_n z80(.nRESET(RESETN),
                         .CLK(Z80_CLK),
                         .*
                         );
    assign D = ! nRD ? D_reg : {8{1'bz}};

    assign nBUSRQ = 1;

    wire [11:0] rom_addr;
    wire [7:0] rom_data;

    z80_rom rom(.ADDR(A32[11:0]),
                .DATA(rom_data));

    reg [7:0] ram [0:4096-1];

    assign rom_addr = A[11:0];

    reg [3:0] LED_reg;

    assign LED = LED_reg; 

    wire is_io;
    wire is_read;
    wire [31:0] A32;
    wire [31:0] D32;
    wire [3:0] wstrb;
    wire [2:0] addr_type;

    reg wr_ack;
    reg rd_ack;

    addr_converter#(.ADDR_WIDTH(16))
    addr_conv
      (.IO(! nIORQ),
       .MEM(! nMREQ),
       .RD(! nRD),
       .WR(! nWR),
        
       .A(A),
       .D(D),

       .is_read(is_read),
       .A32(A32),
       .D32(D32),
       .wstrb(wstrb),

       .addr_type(addr_type)
       );

    always @(posedge Z80_CLK) begin
        if (!RESETN) begin
            nWAIT <= 1;
            axi_awvalid <= 0;
            axi_arvalid <= 0;
            axi_wvalid <= 0;
            axi_rready <= 0;
            LED_reg <= 0;
            wr_ack <= 0;
            rd_ack <= 0;
        end else if (nHALT) begin
            if (addr_type == ADDR_TYPE_INTERNAL_ROM) begin
                if (is_read) begin
                    D_reg <= rom_data;
                end else begin
                    /* nop */
                end
            end else if (addr_type == ADDR_TYPE_INTERNAL_RAM) begin
                if (is_read) begin
                    D_reg <= ram[A32[11:0]];
                end else begin
                    ram[A32[11:0]] <= D_reg;
                end
            end else begin
            end

//            if (nWR) begin
//                wr_ack <= 0;
//            end
//
//            if (nRD) begin
//                rd_ack <= 0;
//            end
//
//            case (cur_op)
//              4'b1010:
//
//                if (wr_ack == 0 && axi_wvalid == 0 && axi_awvalid == 0) begin
//                    // io write
//                    if (A[7:0] == 8'd128) begin
//                        LED_reg <= D[3:0];
//                    end else begin
//                        // axi write
//                        io_addr <= A[7:0];
//                        io_bus <= 1;
//                        io_data <= D[7:0];
//                        axi_wvalid <= 1;
//                        axi_awvalid <= 1;
//                    end
//                    wr_ack <= 1;
//                end
//
//              4'b1001:
//                if (rd_ack == 0 && axi_rready == 0 && axi_arvalid == 0) begin
//                    // io read
//                    io_addr <= A[7:0];
//                    io_bus <= 1;
//                    axi_rready <= 1;
//                    axi_arvalid <= 1;
//                    nWAIT <= 0;
//                    rd_ack <= 1;
//                end
//
//
//              4'b0110:
//                if (wr_ack == 0) begin
//                    // mem write
//                    case (addr_region)
//                      REGION_RAM: ram[A[11:0]] <= D;
//                    endcase
//                    wr_ack <= 1;
//                end
//
//
//              4'b0101:
//                if (rd_ack == 0) begin
//                    // mem read
//                    case (addr_region)
//                      REGION_ROM: begin
//                          D_reg[7:0] <= rom_data;
//                      end
//                      REGION_RAM: begin
//                          D_reg[7:0] <= ram[A[11:0]];
//                      end
//
//                      REGION_AXI: begin
//                          D_reg[7:0] <= 8'b00000000;
//                      end
//                    endcase
//
//                    valid_D <= 1;
//                    rd_ack <= 1;
//                end
//
//              default:
//                valid_D <= 0;
        end

        if (axi_awvalid && AXI_awready) begin
            axi_awvalid <= 0;
        end

        if (axi_wvalid && AXI_wready) begin
            axi_wvalid <= 0;
        end

        if (AXI_bvalid) begin
        end

        if (axi_arvalid && AXI_arready) begin
            axi_arvalid <= 0;
        end

        if (axi_rready & AXI_rvalid) begin
            nWAIT <= 1;
            axi_rready <= 0;
            case (io_addr[1:0])
              2'b00: D_reg <= AXI_rdata[7:0];
              2'b01: D_reg <= AXI_rdata[15:8];
              2'b10: D_reg <= AXI_rdata[23:16];
              2'b11: D_reg <= AXI_rdata[31:24];
            endcase
        end
    end

    always @*
    begin
        if (io_bus)
          case (io_addr[1:0])
            2'd0: begin            // uart rx
                io_wstrb_converted = 4'b0001;
                io_addr_converted = UART_BASE | 0;
                io_wdata_converted = {24'd0, io_data};
            end
            2'd1: begin            // uart tx
                io_wstrb_converted = 4'b0001;
                io_addr_converted = UART_BASE | 4;
                io_wdata_converted = {24'd0, io_data};
            end
            2'd2: begin            // uart start
                io_wstrb_converted = 4'b0001;
                io_addr_converted = UART_BASE | 8;
                io_wdata_converted = {24'd0, io_data};
            end
            2'd3: begin            // uart ctrl
                io_wstrb_converted = 4'b0001;
                io_addr_converted = UART_BASE | 12;
                io_wdata_converted = {24'd0, io_data};
            end

            default begin
                io_addr_converted = 32'd0;
                io_wstrb_converted = 4'd0;
                io_wdata_converted = 32'd0;
            end
          endcase
        else begin
            io_addr_converted = 32'd0;
            io_wstrb_converted = 4'd0;
            io_wdata_converted = 32'd0;
        end
    end
endmodule

`default_nettype wire