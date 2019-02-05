/*
*
*	CP/M-68K table driven file search module
*	========================================
*

*	GLOBALS
*/


	.globl load_tbl		/* loader table  */
	.globl load68k			/* default load program */
	.globl init_tbl			/* initializes table on COLD BOOT */

	.text
/*************************************************************************
*									*
*	This is the DUAL PROCESSOR,ROMABLE version of CP/M-68K		*
*	======================================================		*
*									*
*	(c) Copyright Digital Research 1983				*
*	all rights reserved						*
*									*
*************************************************************************

*
*	The following code allows CP/M-68K to be ROM-able.
*	-------------------------------------------------
*
*/

init_tbl:
	move.l	#typ1,typ1p
	move.l	#typ2,typ2p		/* init the pointers to the filetypes*/
	move.l	#typ3,typ3p
	move.l	#null,typ4p

	move.l	#load68k,pgld1
	move.l	#load68k,pgld2		/* init the pointers to the loaders */
	move.l	#load68k,pgld3
	move.l	#load68k,pgld4

	rts
	.bss
	.even
/*************************************************************************
*									*
*			  CP/M-68K LOADER TABLE				*
*			  =====================				*
*									*
*-----------------------------------------------------------------------*
*									*
*	STRUCTURE OF A LOADER TABLE ENTRY:				*
*	=================================				*
*									*
*	(1)  LONG WORD pointer to a filetype				*
*	(2)  LONG WORD address of the program loader for the above type *
*	(3)  BYTE flag #1						*
*	(4)  BYTE flag #2						*
*									*
*************************************************************************
*/


load_tbl:
typ1p:	.ds.l	1
pgld1:	.ds.l	1
	.ds.b	1
	.ds.b	1
typ2p:	.ds.l	1
pgld2:	.ds.l	1
	.ds.b	1
	.ds.b	1
typ3p:	.ds.l	1
pgld3:	.ds.l	1
	.ds.b	1
	.ds.b	1
typ4p:	.ds.l	1
pgld4:	.ds.l	1
	.ds.b	1
	.ds.b	1


/*****************************************
*					*
*	     FILETYPE TABLE		*
*	     ==============		*
*					*
*****************************************
*/

	.data
	.even
typ1:	.ascii	"68K\0"
	.even
typ2:	.ascii	"   \0"
	.even
typ3:	.ascii	"SUB\0"
	.even
null:	.dc.l	0
	.end








