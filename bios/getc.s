.even
.text
.globl _con
.globl putc,_putc, _chbo
putc:	
_putc:
	link a6,#0
	moveml d0-a6,sp@-
	movel a6@(8),d0
	andl #0xff,d0
	jsr _chbo
	moveml sp@+,d0-a6
	unlk a6
	rts
	 	
.globl _main
_main:
	rts

.globl putcon, _putcon
putcon:
_putcon:
	link a6,#0
	moveml d0-a6,sp@-
	movl a6@(8),d0
	andl #0xff,d0
	jsr _chbo
	moveml sp@+,d0-a6
	unlk a6
	rts

