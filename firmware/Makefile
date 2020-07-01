all: z80_firmware_hex.dat

AS=z80-as
Z80_LDFLAGS=-b coff-z80
LINK.o=z80-ld $(Z80_LDFLAGS) --oformat binary

z80_firmware.o: z80_firmware.s
z80_firmware: z80_firmware.o
	z80-objdump -d z80_firmware.o
	z80-ld -Ttext=0 $< -o $@

z80_firmware_hex.dat: z80_firmware genhex
	./genhex < $< > $@

genhex:genhex.c

clean:
	rm -f *_hex.dat *.dat *.o z80_firmware genhex *~
