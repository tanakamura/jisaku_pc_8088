	extrn	cmain_:near
	public	_small_code_

	.code
.startup
_small_code_:
	xor	ax, ax
	mov	sp, 0

	mov	ds, ax
	mov	ss, ax
	mov	es, ax

	call	cmain_

fini:
	hlt
	jmp	fini

	END