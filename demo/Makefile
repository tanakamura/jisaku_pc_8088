all : blink_led.bin ram_access.bin button_led.bin display.bin cmain.bin keyboard_dump.bin

%.com: %.s
	nasm -l $<.lst -o $@ $<

pack_file: pack_file.c

%.bin: %.com pack_file
	./pack_file $< $@

%.o: %.asm
	wasm -c -mt -fo=$@ $<

%.o: %.c
	wcl -inline-functions -0 -ms -ox -s -c -fo=$@ $<

conv_fonts: conv_fonts.c

cfonts.c: fonts.dat conv_fonts
	./conv_fonts

cmain.exe: c_start.o cmain.o cfonts.o
	wlink debug all op symfile format dos option map,statics,verbose F { $^ } N $@
cmain.com: cmain.exe
	exe2bin -l=cs -h $< $@ 


keyboard_dump.exe: c_start.o keyboard_dump.c cfonts.o
	wlink debug all op symfile format dos option map,statics,verbose F { $^ } N $@
keyboard_dump.com: cmain.exe
	exe2bin -l=cs -h $< $@ 


clean:
	rm -f *.com *.bin pack_file

