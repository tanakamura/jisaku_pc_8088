module firmware_rom
  #(
    parameter PATH="dummy.dat",
    parameter integer ADDR_WIDTH=12,
    parameter integer ROM_SIZE=1<<ADDR_WIDTH
    )
    (
     ADDR,
     DATA
     );

    input [ADDR_WIDTH-1:0] ADDR;
    output [7:0] DATA;

    reg [7:0] rom [0:ROM_SIZE-1];

    initial begin
        $readmemh(PATH, rom);
    end

    assign DATA = rom[ADDR];
endmodule
