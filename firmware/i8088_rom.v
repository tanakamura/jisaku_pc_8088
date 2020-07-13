module i8088_rom
  #(
    parameter integer ADDR_WIDTH=8,
    parameter integer ROM_SIZE=1<<ADDR_WIDTH
    )
    (
     ADDR,
     DATA
     );

    input [ADDR_WIDTH-1:0] ADDR;
    output [7:0] DATA;

    firmware_rom#(.ADDR_WIDTH(ADDR_WIDTH), 
                  .ROM_SIZE(ROM_SIZE),
                  .PATH("8088_firmware_hex.dat"))
    rom(.ADDR(ADDR),
        .DATA(DATA));
endmodule
