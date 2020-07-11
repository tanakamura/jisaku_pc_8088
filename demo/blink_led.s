	org	0

	

	mov	ax, 0x2000
	mov	es, ax
	mov	al, 0x33

loop:
	inc	byte [es:0]
	mov	al, [es:0]

	out	(128), al
	;xor	al, 0xff
	ror	al, 1
	mov	cx, 3000

wait0:	
	dec	cx
	jnz	wait0

	jmp	loop
	
