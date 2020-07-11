all : blink_led.bin ram_access.bin button_led.bin

%.bin: %.s
	nasm -o $@ $<
