parameter AXI_ADDR32_UART_RX = 32'h4060_0000;
parameter AXI_ADDR32_UART_TX = 32'h4060_0004;
parameter AXI_ADDR32_UART_STAT = 32'h4060_0008;
parameter AXI_ADDR32_DRAM_BASE = 32'h8000_0000;
parameter AXI_ADDR32_SPI_BASE = 32'h44a1_0000;
parameter AXI_ADDR32_FLASH_XIP_BASE = 32'h0100_0000;

parameter integer ADDR_TYPE_NBIT = 3;

parameter ADDR_TYPE_INTERNAL_ROM = 3'b000;
parameter ADDR_TYPE_INTERNAL_RAM = 3'b001;
parameter ADDR_TYPE_INTERNAL_LED = 3'b010;
parameter ADDR_TYPE_INTERNAL_BUTTON = 3'b011;
parameter ADDR_TYPE_INTERNAL_GPIO = 3'b100;

parameter ADDR_TYPE_AXI = 3'b101;
parameter ADDR_TYPE_UNKNOWN = 3'b110;
parameter ADDR_TYPE_NOT_OP = 3'b111;


