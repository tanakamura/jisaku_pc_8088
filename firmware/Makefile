all: 8088_firmware_hex.dat

AS=z80-as
Z80_LDFLAGS=-b coff-z80
LINK.o=z80-ld $(Z80_LDFLAGS) --oformat binary


z80_firmware: z80_firmware.s
	z80asm -l $< -o $@
z80_main: z80_main.s
	z80asm -l $< -o $@

z80_firmware_hex.dat: z80_firmware genhex
	./genhex 4096 < $< > $@

genhex:genhex.c

clean:
	rm -f *_hex.dat *.dat *.o z80_firmware genhex *~

flash: z80_main
	openocd -f flash.tcl -c ""

8088_firmware_hex.dat: 8088_firmware genhex
	./genhex 256 < $< > $@

spi_load_8088: spi_load_8088.s
	nasm -l $@.lst $< -o $@
por_8088: por_8088.s
	nasm -l $@.lst $< -o $@

pack_8088_rom: pack_8088_rom.c

8088_firmware: pack_8088_rom por_8088 spi_load_8088
	./pack_8088_rom $@

.DELETE_ON_ERROR: