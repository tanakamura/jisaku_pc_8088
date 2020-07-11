	org	0

	nop
	nop
	nop
	nop
	nop
	nop
	

	mov	ax, 0x2000
	mov	es, ax
	mov	si, 0
	mov	al, 0xa5

	mov	[es:si], al
loop:	
	mov	al, [es:8]
	inc	si
	jmp	loop
	jmp	loop
	jmp	loop
	jmp	loop
	jmp	loop

	