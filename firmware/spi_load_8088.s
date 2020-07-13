	SPI_SR0	equ	0xc
	SPI_SR1	equ	0xd
	SPI_DRR	equ	0xe

	SPI_SRR	equ	0xc
	SPI_CR	equ	0xd
	SPI_DTR	equ	0xe
	SPI_SSR	equ	0xf


	LED	equ	128

	org	0x0

start:
	xor	ax, ax
	mov	ss, ax
	mov	es, ax
	mov	sp, ax
	mov	di, ax

	mov	al, 0xa
	out	(LED), al

	out	(SPI_SRR), al	;reset SPI
	mov	al, 0x2 | 0x4 | 0x80
	out	(SPI_CR), al	;enable & master mode & manual slave select

	mov	al, 0
	out	(SPI_SSR), al	;select slave

	mov	al, 0x0b	;fast read
	out	(SPI_DTR), al

	;addr = 0x00800000
	mov	al, 0x80
	out	(SPI_DTR), al
	xor	ax, ax
	out	(SPI_DTR), al
	out	(SPI_DTR), al
	out	(SPI_DTR), al   ; dummy

	mov	cx, 5
read_dummy:
	call	read_1byte
	loop	read_dummy

	;read signature
	call	transfer_1byte
	cmp	al, 0x5a

	jne	sig_fail

	;read length
	call	transfer_1byte
	mov	cl, al
	out	(LED), al
	call	transfer_1byte
	mov	ch, al


read_contents:
	call	transfer_1byte
	mov	[es:di], al
	inc	di
	loop	read_contents

	mov	al, 0xff
	out	(LED), al

	jmp	0x0000:0000
	

transfer_1byte:
	out	(SPI_DTR), al

	;; fall throught


read_1byte:
wait_for_read_not_empty:
	in	al, (SPI_SR0)
	test	al, 1
	jnz	wait_for_read_not_empty

	in	al, (SPI_DRR)
	ret

sig_fail:
	mov	cx, 0x8000
	call 	delay
	xor	ax, ax
	dec	ax
	out	(LED), al
	mov	cx, 0x8000
	call 	delay
	xor	ax, ax
	out	(LED), al
	jmp	sig_fail

delay:
	dec	cx
	jnz	delay
	ret
