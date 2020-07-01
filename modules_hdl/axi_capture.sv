`timescale 1ns/1ps
`default_nettype none

module axi_capture#(
                    ADDR_WIDTH=32
                    )
    (
     // cpu clk
     input wire [ADDR_WIDTH-1:0] A,
     input wire [3:0] wstrb,
     input wire [31:0] D,
     input wire rdaddr_fetch,
     input wire wraddr_fetch,
     input wire wrdata_fetch,
     input wire BUS_CLK,

     output wire axi_busy,
     output wire [7:0] read_data,

     // axi clk
     input wire RESETN,

     output wire [ADDR_WIDTH-1:0] AXI_awaddr,
     output wire AXI_awvalid,
     input wire AXI_awready,

     output wire AXI_wvalid,
     output wire [3:0] AXI_wstrb,
     output wire [31:0] AXI_wdata,
     input wire AXI_wready,

     output wire [ADDR_WIDTH-1:0] AXI_araddr,
     output wire AXI_arvalid,
     input wire AXI_arready,
     output wire AXI_rready,
     input wire AXI_rvalid,
     input wire [31:0] AXI_rdata,

     output wire AXI_bready,
     input wire [1:0] AXI_bresp,
     input wire AXI_bvalid,

     input wire AXI_CLK
     );

`include "addr_map.svh"

    reg [ADDR_WIDTH-1:0] A_buf;
    reg [31:0] D_buf;

    var [ADDR_WIDTH-1:0] A_axi;
    var [31:0] D_axi;

    var [3:0] wstrb_buf;
    var [3:0] wstrb_axi;

    var wraddr_fetch_buf;
    var wrdata_fetch_buf;
    var rdaddr_fetch_buf;

    reg axi_rready;
    reg axi_arvalid;
    reg [7:0] axi_readdata;
    reg axi_awvalid;
    reg axi_wvalid;
    reg [3:0] axi_wstrb;
    reg [31:0] axi_wdata;
    reg [ADDR_WIDTH-1:0] axi_addr;

    var [7:0] read_data_buf;
    var [7:0] read_data_axi;

    var axi_busy_buf;

    var rdaddr_fetched;
    var wraddr_fetched;
    var wrdata_fetched;
    var bresp_wait;

    assign AXI_bready = 1;
    assign AXI_wvalid = axi_wvalid;
    assign AXI_wdata = axi_wdata;
    assign AXI_wstrb = axi_wstrb;
    assign AXI_rready = axi_rready;
    assign AXI_awvalid = axi_awvalid;
    assign AXI_awaddr = axi_addr;
    assign AXI_araddr = axi_addr;
    assign AXI_arvalid = axi_arvalid;
    assign read_data = read_data_buf;

    wire axi_busy_axi = axi_awvalid | axi_wvalid | axi_arvalid | axi_rready | bresp_wait;
    wire axi_to_bus_match = ((axi_busy_buf == axi_busy_axi) && (read_data_buf == read_data_axi));
    assign axi_busy = axi_busy_axi || ! axi_to_bus_match;

    always @(posedge AXI_CLK)
      if (!RESETN) begin
          axi_rready <= 0;
          axi_arvalid <= 0;
          axi_awvalid <= 0;
          axi_wvalid <= 0;
          bresp_wait <= 0;
          rdaddr_fetched <= 0;
          wraddr_fetched <= 0;
          wrdata_fetched <= 0;
          read_data_buf <= 0;
          read_data_axi <= 0;
      end else begin
          if (A_buf == A &&
              D_buf == D && 
              wrdata_fetch_buf == wrdata_fetch &&
              wraddr_fetch_buf == wraddr_fetch &&
              rdaddr_fetch_buf == rdaddr_fetch &&
              wstrb_buf == wstrb) 
          begin
              A_axi <= A;
              D_axi <= D;
              wstrb_axi <= wstrb;

              if ((!axi_busy) && (! rdaddr_fetched) && rdaddr_fetch) begin
                  axi_arvalid <= 1;
                  axi_rready <= 1;
                  axi_addr <= A;
                  rdaddr_fetched <= 1;
              end else if (! rdaddr_fetch) begin
                  rdaddr_fetched <= 0;
              end

              if ((!axi_busy) && (! wraddr_fetched) && (wraddr_fetch)) begin
                  axi_awvalid <= 1;
                  axi_addr <= A;
                  wraddr_fetched <= 1;
              end else if (! wraddr_fetch) begin
                  wraddr_fetched <= 0;
              end

              if ((!axi_busy) && (!wrdata_fetched) && wrdata_fetch) begin
                  axi_wvalid <= 1;
                  axi_wstrb <= wstrb_axi;
                  axi_wdata <= D;
                  bresp_wait <= 1;
                  wrdata_fetched <= 1;
              end else if (!wrdata_fetch) begin
                  wrdata_fetched <= 0;
              end
          end

          if (axi_awvalid && AXI_awready) begin
              axi_awvalid <= 0;
          end

          if (axi_wvalid && AXI_wready) begin
              axi_wvalid <= 0;
          end

          if (axi_arvalid && AXI_arready) begin
              axi_arvalid <= 0;
          end

          if (AXI_bvalid) begin
              bresp_wait <= 0;
          end

          if (axi_rready && AXI_rvalid) begin
              case (axi_addr[1:0])
                2'b00: read_data_axi <= AXI_rdata[7:0];
                2'b01: read_data_axi <= AXI_rdata[15:8];
                2'b10: read_data_axi <= AXI_rdata[23:16];
                2'b11: read_data_axi <= AXI_rdata[31:24];
              endcase

              axi_rready <= 0;
          end

          axi_busy_buf <= axi_busy_axi;
          read_data_buf <= read_data_axi;

          A_buf <= A;
          D_buf <= D;
          wraddr_fetch_buf <= wraddr_fetch;
          wrdata_fetch_buf <= wrdata_fetch;
          rdaddr_fetch_buf <= rdaddr_fetch;
          wstrb_buf <= wstrb;
      end
endmodule

`default_nettype wire
