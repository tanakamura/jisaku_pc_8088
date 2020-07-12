	org	0x0

start:

	xor	ax, ax
	mov	ds, ax
	mov	ss, ax
	mov	sp, ax

	jmp	0x1000:0000
