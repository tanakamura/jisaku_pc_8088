	org	0x0

start:

	xor	ax, ax
	mov	ds, ax
	mov	ss, ax
	; mov	sp, ax

	mov	al, 0x3
	out	(128), al

	jmp	0x1000:0000
