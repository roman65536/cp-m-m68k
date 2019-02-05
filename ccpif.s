/*************************************************************************
*									*
*                    CPM68K INTERFACE MODULE FOR			*
*		     THE CONSOLE COMMAND PROCESSOR			*
*									*
*	    THIS IS THE DUAL-PROCESSOR,ROMABLE CP/M-68K SYSTEM		*
*	    ==================================================		*
*									*
*       (C) Copyright Digital Research 1983 all rights reserved		*
*									*
*************************************************************************/


	.globl  bios1
	.globl  _bdos
	.globl  load68k
	.globl  load_tbl
	.globl	init_tbl
	.globl	load_try
	.globl  autorom
	.globl	flags
	.globl	TPAB
	.globl  stack
	.globl	bdosinit
	.globl  main
	.globl  submit
	.globl  morecmds
	.globl  autost
	.globl  usercmd
	.globl	_init
	.globl	ccp
	.globl  _patch
	.globl  cpm

	.text
cpm:	
	jmp.l	ccpstart	/* start ccp with possible initial command */
	jmp.l   ccpclear	/* clear auto start flag */



	.bss
autost:  ds.b  1		/* autostart command flag */
usercmd: ds.b  130		/* user command buffer */

	.text
copy:	 .ascii  "COPYRIGHT (C) 1982, Digital Research"
	 .byte 0 


	.text
	.even
ccpclear:
	clr.b	autost		/* clear the autostart flag */

ccpstart:
	lea	stack,%sp	/* set up the stack pointer */
	clr.b   autost		/* clear the auto start flag */
	jsr	_init		/* call bios init */
	move.w	%d0,dskuser	/* save user # & disk */
/*
*
*	ROM SYSTEM INITIALIZATION
*	OF BSS VARIABLES
*
*
*/

	clr.b	load_try	
	clr.b	submit
	clr.b	morecmds
	move.b  #1,autorom
	clr.w	flags
	clr.w	TPAB
	jsr	init_tbl



	jsr	bdosinit	/* do bdos init */
	move.w  #32,%d0		/* get user bdos func # */
	clr.l	%d1		/* clear out d1 */
	move.b  dskuser,%d1	/* get the user # */
	trap	#2		/* set the user number */
	clr.l	%d0		/* clear d0 */
	move.w  #14,%d0		/* select function */
	clr.l	%d1		/* clear d1 */
	move.w	dskuser,%d1	/* get disk to be selected */
	andi    #0x0ff,%d1	/* mask off the user # */
	trap	#2		/* select the disk */

ccp:
	lea	stack,%sp	/* set up the stack pointer */
	jsr	main		/* call the CCP */
	bra	ccp

	.bss
	.even

dskuser: ds.w  1
	.even
submit: ds.b  1
	.even
morecmds: ds.b 1
	.even
_patch:	ds.l	25
	.end










