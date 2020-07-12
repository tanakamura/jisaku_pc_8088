%include 'addr.asm'

%macro	spi_send 1
	mov	al, %1
	call	spi_out
%endmacro	
	

	org	0

	mov	ax, cs
	mov	ds, ax

	mov	si, start_str
	call	print

	mov	al, 2		;rst hi
	out	(GPIO0), al
	mov	cx, 0x100
	call	delay

	mov	al, 0		;rst lo
	out	(GPIO0), al
	mov	cx, 0x100
	call	delay

	mov	al, 2		;rst hi && dc lo
	out	(GPIO0), al
	mov	cx, 0x100
	call	delay


	out	(SPI_SRR), al	;reset SPI
	mov	al, 0x2 | 0x4
	out	(SPI_CR), al	;enable & master mode

	mov	si, display_initial_sequence
	mov	cx, display_initial_sequence_length
	call	spi_out_sequence

	mov	ax, 0xaa

loop:
	out	(128), al
	xor	al, 0xff
	mov	cx, 0x1000
	call	delay
	jmp	loop

delay:
	dec	cx
	jnz	delay
	ret


print:
	mov	dl, [si]
	cmp	dl, 0
	je	.end

.tx_full:
	in	al, (UART_STAT)
	test	al, 0x8
	jnz	.tx_full

	mov	al, dl
	out	(UART_TX), al
	inc	si
	loop	print

.end:
	ret


	;si = data addr
	;cx = data length
spi_out_sequence:
	mov	al, [si]
	call	spi_out
	inc	si
	dec	cx
	jnz	spi_out_sequence
	ret

spi_out:
	push	ax

.tx_full:
	in	al, (SPI_SR0)
	test	al, 0x8
	jnz	.tx_full

	pop	ax

	out	(SPI_DTR), al
	ret

	start_str db 'hello world!', 0x0d, 0x0a, 0x00

	display_initial_sequence db 0xae, 0x8d, 0x14, 0xaf
	display_initial_sequence_length  equ $ - display_initial_sequence

