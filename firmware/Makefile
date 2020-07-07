all: z80_firmware_hex.dat z80_main 8088_firmware_hex.dat

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

8088_firmware: 8088_firmware.s
	nasm -l $@.lst $< -o $@

8088_firmware_hex.dat: 8088_firmware
	./genhex 16 < $< > $@

.DELETE_ON_ERROR: