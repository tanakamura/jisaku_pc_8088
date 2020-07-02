all: z80_firmware_hex.dat z80_main

AS=z80-as
Z80_LDFLAGS=-b coff-z80
LINK.o=z80-ld $(Z80_LDFLAGS) --oformat binary

%: %.s
	z80asm -l $< -o $@

z80_firmware: z80_firmware.s

z80_main: z80_main.s

z80_firmware_hex.dat: z80_firmware genhex
	./genhex < $< > $@

genhex:genhex.c

clean:
	rm -f *_hex.dat *.dat *.o z80_firmware genhex *~

flash: z80_main
	openocd -f flash.tcl -c ""