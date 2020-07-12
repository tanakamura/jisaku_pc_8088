%include 'addr.asm'

	WIDTH	equ	128
	HEIGHT	equ	64

%macro	spi_send 1
	mov	al, %1
	call	spi_out
%endmacro

%macro disp_command 0
	mov	al, 2		;rst hi && dc lo
	out	(GPIO0), al
%endmacro

%macro disp_data 0
	mov	al, 3		;rst hi && dc hi
	out	(GPIO0), al
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

	spi_send 0x21
	spi_send 0
	spi_send 127	

	spi_send 0x22
	spi_send 0
	spi_send 7

	disp_data

	mov	cx, 1024
	mov	al, 0x0
clear_loop:
	call	spi_out
	loop	clear_loop

	disp_command


	mov	ch, 0
vert:
	mov	cl, 0
	call	set_position
	mov	dl, 'A'

horiz:
	push	dx
	call	disp_alphabet
	pop	dx
	inc	dl
	cmp	dl, 'R'
	jnz	horiz

	inc	ch

	cmp	ch, 7
	jne	vert


	mov	ax, 0x0

loop:
	out	(128), al
	inc	al
	mov	cx, 0x1000

;	push	ax
;	test	al, 1
;	jz	.blink_on
;	spi_send 0xa7
;	jmp	blink_end
;.blink_on:	
;	spi_send 0xa6
;blink_end:
;	pop	ax
	

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

	display_initial_sequence db 0xae, \
	0xd5, 0x80, \
	0xa8, 0x3f, \
	0xd3, 0x00, \
	0x40, \
	0x8d, 0x14, \
	0x20, 0x00, \
	0xa1, \
	0xc8, \
	0xda, 0x12, \
	0x81, 0xcf, \
	0xd9, 0xf1, \
	0xd8, 0x40, \
	0xa4, \
	0xa6,\
	0xaf
	

	display_initial_sequence_length  equ $ - display_initial_sequence


	; ax : clobber
	; dl : char
	; cl : x (dot)
	; ch : y (page)
set_position:
	spi_send 0x21
	mov	al, cl
	call	spi_out
	spi_send 127

	spi_send 0x22
	mov	al, ch
	call	spi_out
	spi_send 7

	ret


	; ax : clobber
	; dl : char, clobber
disp_alphabet:
	mov	si, alphabet_A
	sub	dl, 'A'
	jmp	disp_alphanum

	; ax : clobber
	; dl : char, clobber
disp_number:
	mov	si, number_0
	sub	dl, '0'

disp_alphanum:	
	disp_data

	mov	al, 6
	mul	dl
	add	si, ax

	mov	al, [si]
	call	spi_out
	mov	al, [si+1]
	call	spi_out
	mov	al, [si+2]
	call	spi_out
	mov	al, [si+3]
	call	spi_out
	mov	al, [si+4]
	call	spi_out
	mov	al, [si+5]
	call	spi_out
	mov	al, 0
	call	spi_out

	disp_command

	ret

%include 'fonts.asm'