	org	0x0

start:

	xor	ax, ax
	mov	ds, ax
	mov	ss, ax
	mov	sp, ax

	jmp	0xfff0:0000	; FFF00 = 1MB - 256
