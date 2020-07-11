	org	0

	xor	si, si
	mov	ax, 0x2000
	mov	es, ax

	mov	word [es:si],0xf1f1

	xor	dl, dl
loop:
	in	al, (128)
	out	(128), al

	cmp	dl, al
	je	loop

	mov	dl, al
	mov	ax, [es:si]

	jmp	loop
	

	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	