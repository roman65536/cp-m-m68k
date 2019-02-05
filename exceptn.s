
/*************************************************
*						*
*	CP/M-68k Basic Disk Operating System 	*
*		Exception Handling Module	*
*						*
*	Version 0.0 -- July    21, 1982		*
*	Version 0.1 -- July    25, 1982		*
*	Version 0.2 -- October  6, 1982		*
*	Version 0.3 -- December 21, 1982	*
*						*
*************************************************/


	.globl	initexc
	.globl	tpa_lp
	.globl	tpa_hp

bgetseg = 18
bsetexc	= 22
buserr	= 2
spurious = 24
trap0	= 32
trap2	= 34
trap3	= 35
endvec	= 48

initexc:
/* Initialize Exception Vector Handlers
* It has 1 passed parameter: the address of the exception vector array
*/
	move	#bsetexc,%d0
	moveq	#2,%d1
	move.l	#exchndl,%d2
init1:
	movem.l	%d0-%d2,-(%sp)
	trap	#3		/* BIOS call to set exception vector*/
	movem.l	(%sp)+,%d0-%d2
init2:	addq	#1,%d1
	add.l	#4,%d2
	cmpi	#spurious,%d1
	bne	init3
	move	#trap0,%d1
init3:	cmpi	#trap2,%d1
	beq	init2		/* don't init trap 2 or trap 3*/
	cmpi	#trap3,%d1
	beq	init2
	cmpi	#endvec,%d1
	blt	init1
/*				initialize the exception vector array*/

	moveq	#bgetseg,%d0
	trap	#3		/* get the original TPA limits*/
	movea.l	%d0,%a0
	tst.w	(%a0)+
	move.l	(%a0)+,%d1	/* d1 = original low TPA limit*/
	move.l	%d1,%d2
	add.l	(%a0),%d2		/* d2 = original high TPA limit*/
	move.l	tpa_lp,%d3	/* d3 = new low TPA limit*/
	move.l	tpa_hp,%d4	/* d4 = new high TPA limit*/
	move	#17,%d0
	movea.l	4(%sp),%a0
	move.l	%a0,evec_adr	/* save exception vector address*/
init4:
	cmp.l	(%a0),%d1
	bhi	do_init		/* if old exception outside orig TPA, clear it*/
	cmp.l	(%a0),%d2
	bls	do_init
/* current exception array entry is in original TPA*/
	cmp.l	(%a0),%d3
	bhi	dontinit	/* if old exception in old TPA but outside new*/
	cmp.l	(%a0),%d4		/*	TPA, don't clear it*/
	bls	dontinit
do_init:
	clr.l	(%a0)
dontinit:
	tst.l	(%a0)+
	dbf	%d0,init4
	rts

exchndl:
	bsr.w	except    	| 2
excrtn0:
	bsr.w	except		| 3
	bsr.w	except		| 4	
	bsr.w	except		| 5
	bsr.w	except		| 6
	bsr.w	except		| 7	
	bsr.w	privviol		| 8
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except
	bsr.w	except


privviol:
        movem.l %d0/%a0,-(%sp)                     |       Save some regs
        move.l  0x0e(%sp),%a0                      |       A0 -> Instruction
        move.w  (%a0),%d0                         |       d0 =  Instruction
        andi.w  #0xFFC0,%d0                       |       Mask off <EA> field
        cmpi.w  #0x40C0,%d0                       |       Move from SR?
        bne     notsr                           |       No, handle normally
        ori.w   #0x0200,(%a0)                     |       Change to move from CCR
        movem.l (%sp)+,%d0/%a0                     |       Restore regs
        tst.l   (%sp)+                           |       Pop return address
        rte                                     |       Try it again
notsr:  movem.l (%sp)+,%d0/%a0                     |       Abandon hope, all ye ..

except:
	clr.w	-(%sp)
	movem.l	%a0/%d0,-(%sp)	/* 10 words now on stack in following order:*/
/*				 _______________________________
*				|____________D0.L_______________|
*				|____________A0.L_______________|
*				|____0000______|________________
*				|_______Handler Return__________|
*				If bus error, extra 2 longs are here
*				 ______________
*				|__Status Reg__|________________
*				|_____Exception Return__________|*/

	move.l	10(%sp),%d0	/* get return address from above array*/
	sub.l	#excrtn0,%d0	/* d0 now has 4 * (encoded excptn nmbr), where*/
/*				  encoded excptn nmbr is in [0..21,22..37]*/
*					      representing  [2..23,32..47]*/
	cmpi	#36,%d0		/* if d0/4 is in [0..9,22..29] then*/
	ble	chkredir	/*     the exception may be redirected*/
	cmpi	#88,%d0
	blt	dfltexc
	cmpi	#116,%d0
	bgt	dfltexc
/*				in range of redirected exceptions*/
	subi	#48,%d0		/* subtract 4*12 to normalize [0..9,22..29]*/
/*							into [0..9,10..17]*/
chkredir:
	movea.l	evec_adr,%a0
	adda	%d0,%a0		/* index into exception vector array*/
	tst.l	(%a0)		/* if 00000000, then not redirected*/
	bne	usrexc
/*				not redirected, do default handler*/
	cmpi	#40,%d0
	blt	dfltexc
	addi	#48,%d0		/* add 4*12 that was sub'd above*/
dfltexc:
	adda	#14,%sp		/* throw away 7 words that we added to stack*/
	asr	#2,%d0		/* divide d0 by 4*/
/*				now d0 is in [0..21,22..37]*/
/*				to represent [2..23,32..47]*/
	cmpi	#2,%d0		/* bus or address error?*/
	bge	nobusexc
	movem.l	(%sp)+,%a0-%a1	/* if yes, throw away 4 words from stack*/
nobusexc:
	tst.w	(%sp)+		/* throw away stacked SR*/
	addi	#2,%d0
	cmpi	#23,%d0		/* get back real excptn nmbr in [2..23,32..47]*/
	ble	lowexc
	addi	#8,%d0
lowexc:	move	%d0,-(%sp)	/* save excptn nmbr*/
	lea	excmsg1,%a0
	bsr	print		/* print default exception message*/
	move	(%sp)+,%d0
	bsr	prtbyte
	lea	excmsg2, %a0
	bsr	print
	move.l	(%sp)+,%d0
	bsr	prtlong
	lea	excmsg3, %a0
	bsr	print
	clr.l	%d0
	trap	#2		/* warm boot*/
	rte

usrexc:
/* Call user exception handler*/
/* make sure exception information is on his stack*/
	move.l	(%a0),10(%sp)	/* put user handler address on our stack*/
	move.l	%usp,%a0		/* user stack pointer to a0*/
	cmpi	#8,%d0		/* address or bus error?*/
	blt	addrexc		/* if yes, skip*/
	btst	#13,14(%sp)	/* exception occured in user state?*/
	bne	supstat1	/* if no, go to supervisor handler*/
	move.l	16(%sp),-(%a0)	/* put exception return on user stack*/
	move.w	14(%sp),-(%a0)	/* put SR on user stack*/
	move.l	%a0,%usp		/* update user stack pointer*/
	movem.l	(%sp)+,%a0/%d0	/* restore regs*/
	move.l	2(%sp),8(%sp)	/* move address of user handler to excptn rtn*/
	addq	#6,%sp		/* clear junk from stack*/
	andi	#0x7fff,(%sp)	/* clear trace bit*/
	rte			/* go to user handler*/
addrexc:
	btst	#13,22(%sp)	/* exception occured in user state?*/
	bne	supstat2	/* if no, go to supervisor handler*/
	move.l	24(%sp),-(%a0)	/* put exception return on user stack*/
	move.w	22(%sp),-(%a0)	/* put SR on user stack*/
	move.l	18(%sp),-(%a0)	/* put extra 2 longs on user stack*/
	move.l	14(%sp),-(%a0)
	move.l	%a0,%usp		/* update user stack pointer*/
	movem.l	(%sp)+,%a0/%d0	/* restore regs*/
	move.l	2(%sp),16(%sp)	/* move address of user handler to excptn rtn*/
	adda	#14,%sp		/* clear junk from stack*/
	andi	#0x7fff,(%sp)	/* clear trace bit*/
	rte			/* go to user handler*/

supstat1:
	move.w	14(%sp),8(%sp)	/* move SR to our exception return*/
	bra	supstat3
supstat2:
	move.w	22(%sp),8(%sp)
supstat3:
	movem.l	(%sp)+,%a0/%d0
	rte

/*
*  Subroutines
**/

print:
	clr.l	%d1
	move.b	(%a0)+, %d1
	beq	prtdone
	move	#2, %d0
	trap	#2
	bra	print
prtdone:
	rts

prtlong:
*  Print d0.l in hex format
	move	%d0,-(%sp)
	swap	%d0
	bsr	prtword
	move	(%sp)+,%d0

prtword:
*  Print d0.w in hex format
	move	%d0,-(%sp)
	lsr	#8,%d0
	bsr	prtbyte
	move	(%sp)+,%d0

prtbyte:
*  Print d0.b in hex format
	move	%d0,-(%sp)
	lsr	#4,%d0
	bsr	prtnib
	move	(%sp)+,%d0

prtnib:
	andi	#0xf,%d0
	cmpi	#10,%d0
	blt	lt10
	addi.b	#'A'-'9'-1,%d0
lt10:
	addi.b	#'0',%d0
	move	%d0,%d1
	move	#2,%d0
	trap	#2
	rts


	.data

excmsg1:
	dc.b	13,10,10
	.ascii "Exception $"	
	.byte 0

excmsg2:
	.ascii	" at user address $"
	.byte 0
excmsg3:
	.ascii	".  Aborted."
	.byte 0


	.bss

evec_adr:
	ds.l	1

	.end
