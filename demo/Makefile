all : blink_led.bin ram_access.bin button_led.bin display.bin cmain.bin keyboard_dump.bin term.bin pong.bin

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

cmain.exe: c_start.o cmain.o cfonts.o common.o
	wlink debug all op symfile format dos option map,statics,verbose F { $^ } N $@
cmain.com: cmain.exe
	exe2bin -l=cs -h $< $@ 


keyboard_dump.exe: c_start.o keyboard_dump.o cfonts.o common.o
	wlink debug all op symfile format dos option map,statics,verbose F { $^ } N $@

%.com: %.exe
	exe2bin -l=cs -h $< $@

term.exe: c_start.o term.o cfonts.o keyboard.o common.o
	wlink debug all op symfile format dos option map,statics,verbose F { $^ } N $@

pong.exe: c_start.o pong.o cfonts.o keyboard.o common.o
	wlink debug all op symfile format dos option map,statics,verbose F { $^ } N $@


clean:
	rm -f *.com *.bin pack_file

