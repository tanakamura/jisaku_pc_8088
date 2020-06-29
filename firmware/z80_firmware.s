	org	0

	SECTION	.text

	LD	A, 0x5
	OUT	(128), A

	LD	IX, DATA
loop:
	LD	A, (IX+0)
	CP	0
	JP	Z,END
	INC	IX
	OUT	(1), A
	JP	loop

END:
	LD	A, 0xa
	OUT	(128), A

	HALT
	JP	END

DATA:
	defb	"HELLO World",0x0d,0x0a,0x00,0xff

	SECTION .bss
BSS_START:
	org	0x1000
hoge:	defs	64
