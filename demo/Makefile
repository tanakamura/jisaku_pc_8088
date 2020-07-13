all : blink_led.bin ram_access.bin button_led.bin display.bin

%.com: %.s
	nasm -l $<.lst -o $@ $<

pack_file: pack_file.c

%.bin: %.com pack_file
	./pack_file $< $@

clean:
	rm -f *.com *.bin pack_file
