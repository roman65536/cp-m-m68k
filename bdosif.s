
/*****************************************************************
*								*
*	CP/M-68K Basic Disk Operating System interface module	*
*		For "C" version of CP/M-68K    			*
*								*
*	Copyright (c) 1982 Digital Research, Inc.		*
*								*
*	Version 0.2 -- September 22, 1982			*
*								*
*****************************************************************/

*  Declare Public Routines

	.globl	bios1		/* 6 BIOS entry points from BDOS */
	.globl	bios2
	.globl	bios3
	.globl	bios4
	.globl	bios5
	.globl	bios6
	.globl	traphndl	/* trap #2 handler */
	.globl	swap		/* byte swapper */
	.globl	udiv		/* unsigned divide routine */

/* Declare external routines */
	.globl	bdos		/* BDOS entry point in bdosmain */

/* The following external references were put in just to make sure that all
*	the BDOS modules were referenced, so we could put them in a library */
	.globl	_constat	/* references conbdos.o */
	.globl	_dirscan	/* references dskutil.o */
	.globl	_create		/* references fileio.o */
	.globl	_bdosrw		/* references bdosrw.o */

	biosf	= 50
	setsupf	= 62

traphndl:
/*
*	first save the registers and
*	check for functions handled by assembly language routines
* */
	cmpi	#setsupf,%d0
	beq	setsup
	movem.l %d1-%d7/%a0-%a6,-(%sp)
	cmpi	#biosf,%d0
	beq	bioscall
/*
*	function number is passed in D0
*	byte and word pararmeters are passed in D1.W
*	address parameters are passed in D1.L
*/
	move.l	%d1,-(%a7)
	move.l	%d1,-(%a7)
	move.l	%d0,-(%a7)
	jsr	_bdos			/* call BDOS */
/*
*	now restore the regs
*/
	ext.l	%d0
	add.l	#12,%sp			/* fix up the stack */
bdone:
	movem.l	(%sp)+,%a0-%a6/%d1-%d7
	rte				/* return from trap call */

/*
* direct BIOS call function
*/
bioscall:
	move.l	%d1,%a0		/* get address of CPB */
	move.w	(%a0)+,%d0
	movem.l	(%a0)+,%d1-%d2
	trap	#3
	bra	bdone

/*
* Set supervisor mode procedure
*/
setsup:
	ori	#0x2000,(%sp)	/* turn on supervisor bit in SR*/
	rte

/*
* BIOS Interface Routines
*
*
*  Note - there are 6 BIOS entry points from the BDOS, labelled BIOS1 -
*    BIOS6, depending on the parameters passed.
*/
bios5:
bios4:
/* For BIOS functions sectran and set exception vector 
* Has function number and 2 parameters, a word followed by a long word */
	move.l  %d2,-(%sp) 
	move.l	16(%sp),%d2	/* get 2nd parameter (long word) */
	move.l  12(%sp),%d1
	move.l	8(%sp),%d0	/* get function number */
	movem.l	%d3-%d7/%a3-%a6,-(%sp)
/*				* save C register variables */
	trap	#3		/* do BIOS call */
/*				* returns value in d0 */
	movem.l	(%sp)+,%d3-%d7/%a3-%a6
	move.l (%sp)+,%d2
	rts 


bios3:
/* For BIOS function set dma
* Has function number followed by 1 long parameter
*/
	move.l	8(%sp),%d1	/* get long word parameter */
	bra	bios1		/* join common routine */

bios2:
/* For all BIOS functions with a word parameter
* Word parameter follows function number
*/
	move.l	8(%sp),%d1	/* get 1st parameter (word) */

bios6:
bios1:
/* For all BIOS functions that have no parameter other than function number */
	move.l	4(%sp),%d0	/* get function number */
	movem.l	%d3-%d7/%a3-%a6,-(%sp)
/*				* save C register variables */
	trap	#3		/* do BIOS call */
/*				* returns value in d0 */
	movem.l	(%sp)+,%d3-%d7/%a3-%a6
	rts

/*
*  Utility Subroutines
*
*/

swap:
/* Swap bytes of a word, return swapped value in d0			*/
	move.b	5(%sp),%d0
	lsl	#8,%d0
	move.b	4(%sp),%d0
	rts

udiv:
/* Unsigned divide routine
* returns unsigned quotient in D0.W

*   UWORD udiv( divisor, dividend, remp )
*
*   REG LONG divisor;
*   UWORD    dividend;
*   UWORD    *remp		 pointer to remainder (returned) */

	move.l	4(%sp), %d0	/* get dividend */
	divu	8(%sp), %d0	/* do the divide */
	movea.l	10(%sp),%a0
	swap	%d0
	move.w	%d0, (%a0)	/* store remainder */
	clr.w	%d0
	swap	%d0		/* word quotient in d0 */
	rts

.bss
d2:	ds.l 
	.end
