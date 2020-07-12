all : blink_led.bin ram_access.bin button_led.bin display.bin

%.bin: %.s
	nasm -l $<.lst -o $@ $<
