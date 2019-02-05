#NO_APP
	.file	"test.c"
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	link.w %fp,#-4
	move.l %fp,%d0
	subq.l #4,%d0
	move.l %d0,-(%sp)
	pea 2.w
	pea 10.w
	jsr udiv
	lea (12,%sp),%sp
	unlk %fp
	rts
	.size	main, .-main
	.ident	"GCC: (GNU) 4.6.4"
