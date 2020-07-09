	org	0

	mov	ax, 0x1000
	mov	ss, ax
	mov	al, 0x33

loop:

	out	(128), al
	;xor	al, 0xff
	ror	al, 1
	mov	cx, 30000

wait0:	
	dec	cx
	jnz	wait0

	jmp	loop
	
