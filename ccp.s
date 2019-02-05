#NO_APP
	.globl	_cmd_tbl
	.text
.LC0:
	.ascii "DIR\0"
.LC1:
	.ascii "DIRS\0"
.LC2:
	.ascii "TYPE\0"
.LC3:
	.ascii "REN\0"
.LC4:
	.ascii "ERA\0"
.LC5:
	.ascii "USER\0"
.LC6:
	.ascii "SUBMIT\0"
	.data
	.even
_cmd_tbl:
	.long	.LC0
	.long	0
	.long	.LC1
	.long	9
	.long	.LC2
	.long	1
	.long	.LC3
	.long	2
	.long	.LC4
	.long	3
	.long	.LC5
	.long	4
	.long	.LC6
	.long	6
	.long	0
	.long	-1
	.globl	_msg
_msg:
	.ascii "NON-SYSTEM FILE(S) EXIST$\0"
	.globl	_msg2
_msg2:
	.ascii "Enter Filename: $\0"
	.globl	_msg3
_msg3:
	.ascii "Enter Old Name: $\0"
	.globl	_msg4
_msg4:
	.ascii "Enter New Name: $\0"
	.globl	_msg5
_msg5:
	.ascii "File already exists$\0"
	.globl	_msg6
_msg6:
	.ascii "No file$\0"
	.globl	_msg7
_msg7:
	.ascii "No wildcard filenames$\0"
	.globl	_msg8
_msg8:
	.ascii "Syntax: REN Newfile=Oldfile$\0"
	.globl	_msg9
_msg9:
	.ascii "Confirm(Y/N)? $\0"
	.globl	_msg10
_msg10:
	.ascii "Enter User No: $\0"
	.globl	_msg11
_msg11:
	.ascii ".SUB file not found$\0"
	.globl	_msg12
_msg12:
	.ascii "User # range is [0-15]$\0"
	.globl	_msg13
_msg13:
	.ascii "Too many arguments: $\0"
	.globl	_lderr1
_lderr1:
	.ascii "insufficient memory or bad file header$\0"
	.globl	_lderr2
_lderr2:
	.ascii "read error on program load$\0"
	.globl	_lderr3
_lderr3:
	.ascii "bad relocation information bits$\0"
	.globl	_lderror
_lderror:
	.ascii "program load error$\0"
.comm _load_try,2
.comm _first_sub,2
.comm _chain_sub,2
.comm _end_of_file,2
.comm _dirflag,2
.comm _subprompt,2
.comm _sub_index,4
.comm _index,4
.comm _sub_user,4
.comm _user,4
.comm _cur_disk,4
.comm _subcom,130
.comm _subdma,128
.comm _user_ptr,4
.comm _glb_index,4
.comm _save_sub,130
.comm _subfcb,36
.comm _cmdfcb,36
.comm _tail,4
.comm _autorom,2
.comm _dma,132
.comm _parm,104
	.globl	_del
_del:
	.byte	62
	.byte	60
	.byte	46
	.byte	44
	.byte	61
	.byte	91
	.byte	93
	.byte	59
	.byte	124
	.byte	38
	.byte	47
	.byte	40
	.byte	41
	.byte	43
	.byte	45
	.byte	92
	.text
	.even
	.globl	_cr_lf
_cr_lf:
	link.w %fp,#0
	pea 13.w
	pea 2.w
	jsr _bdos
	addq.l #8,%sp
	pea 10.w
	pea 2.w
	jsr _bdos
	addq.l #8,%sp
	unlk %fp
	rts
	.even
	.globl	_cpy
_cpy:
	link.w %fp,#0
	move.l 8(%fp),%a0
	move.l 12(%fp),%d0
	nop
.L3:
	move.b (%a0),%d1
	move.l %d0,%a1
	move.b %d1,(%a1)
	move.l %d0,%a1
	move.b (%a1),%d1
	tst.b %d1
	sne %d1
	neg.b %d1
	addq.l #1,%d0
	addq.l #1,%a0
	tst.b %d1
	jne .L3
	unlk %fp
	rts
	.even
	.globl	_strcmp
_strcmp:
	link.w %fp,#0
	movem.l #12320,-(%sp)
	move.l 8(%fp),%d1
	move.l 12(%fp),%d0
	jra .L5
.L9:
	move.l %d1,%a0
	move.b (%a0),%d2
	move.w %d2,%a1
	move.l %d0,%a2
	move.b (%a2),%d2
	move.w %d2,%a0
	move.w %a1,%d2
	move.w %a0,%d3
	cmp.b %d2,%d3
	jge .L6
	moveq #1,%d0
	jra .L7
.L6:
	move.l %d1,%a0
	move.b (%a0),%d2
	move.w %d2,%a1
	move.l %d0,%a2
	move.b (%a2),%d2
	move.w %d2,%a0
	move.w %a1,%d2
	move.w %a0,%d3
	cmp.b %d2,%d3
	jle .L8
	moveq #-1,%d0
	jra .L7
.L8:
	addq.l #1,%d1
	addq.l #1,%d0
.L5:
	move.l %d1,%a1
	move.b (%a1),%d2
	move.w %d2,%a0
	move.w %a0,%d2
	tst.b %d2
	jne .L9
	move.l %d0,%a0
	move.b (%a0),%d0
	tst.b %d0
	jne .L10
	moveq #0,%d0
	jra .L11
.L10:
	moveq #-1,%d0
.L11:
.L7:
	movem.l (%sp)+,#1036
	unlk %fp
	rts
	.even
	.globl	_copy_cmd
_copy_cmd:
	link.w %fp,#0
	move.l %d3,-(%sp)
	move.l %d2,-(%sp)
	move.l 8(%fp),%d0
	move.l #_save_sub,%d2
	move.b _subprompt,%d1
	tst.b %d1
	jeq .L19
	move.l #_parm,%d3
	jra .L14
.L15:
	move.l %d3,%a0
	move.b (%a0),%d1
	move.l %d2,%a0
	move.b %d1,(%a0)
	addq.l #1,%d2
	addq.l #1,%d3
.L14:
	move.l %d3,%a0
	move.b (%a0),%d1
	tst.b %d1
	jne .L15
	move.l %d2,%a0
	move.b #32,(%a0)
	addq.l #1,%d2
	clr.b _subprompt
	jra .L19
.L18:
	move.l %d0,%a0
	move.b (%a0),%d1
	move.l %d2,%a0
	move.b %d1,(%a0)
	addq.l #1,%d2
	addq.l #1,%d0
	jra .L16
.L19:
	nop
.L16:
	move.l %d0,%a0
	move.b (%a0),%d1
	tst.b %d1
	jeq .L17
	move.l %d0,%a0
	move.b (%a0),%d1
	cmp.b #33,%d1
	jne .L18
.L17:
	move.l %d2,%a0
	clr.b (%a0)
	move.l (%sp)+,%d2
	move.l (%sp)+,%d3
	unlk %fp
	rts
	.even
	.globl	_prompt
_prompt:
	link.w %fp,#-4
	move.l %d3,-(%sp)
	move.l %d2,-(%sp)
	pea 255.w
	pea 32.w
	jsr _bdos
	addq.l #8,%sp
	move.l %d0,%d2
	clr.l -(%sp)
	pea 25.w
	jsr _bdos
	addq.l #8,%sp
	move.l %d0,%d3
	moveq #65,%d0
	add.l %d0,%d3
	jsr _cr_lf
	tst.l %d2
	jeq .L21
	moveq #9,%d0
	cmp.l %d2,%d0
	jcc .L22
	move.b #49,-3(%fp)
	move.b %d2,%d0
	add.b #38,%d0
	move.b %d0,-2(%fp)
	move.b #36,-1(%fp)
	jra .L23
.L22:
	move.b %d2,%d0
	add.b #48,%d0
	move.b %d0,-3(%fp)
	move.b #36,-2(%fp)
.L23:
	move.l %fp,%d0
	subq.l #3,%d0
	move.l %d0,-(%sp)
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
.L21:
	move.l %d3,%d0
	move.l %d0,-(%sp)
	pea 2.w
	jsr _bdos
	addq.l #8,%sp
	pea 62.w
	pea 2.w
	jsr _bdos
	addq.l #8,%sp
	move.l -12(%fp),%d2
	move.l -8(%fp),%d3
	unlk %fp
	rts
	.even
	.globl	_echo_cmd
_echo_cmd:
	link.w %fp,#0
	move.l %d3,-(%sp)
	move.l %d2,-(%sp)
	move.l 8(%fp),%d2
	move.l 12(%fp),%d3
	moveq #1,%d0
	cmp.l %d3,%d0
	jne .L33
	move.b _autost,%d0
	tst.b %d0
	jeq .L26
	move.b _autorom,%d0
	tst.b %d0
	jne .L33
.L26:
	jsr _prompt
	jra .L33
.L29:
	move.l %d2,%a0
	move.b (%a0),%d0
	ext.w %d0
	ext.l %d0
	addq.l #1,%d2
	move.l %d0,-(%sp)
	pea 2.w
	jsr _bdos
	addq.l #8,%sp
	jra .L27
.L33:
	nop
.L27:
	move.l %d2,%a0
	move.b (%a0),%d0
	tst.b %d0
	jeq .L28
	move.l %d2,%a0
	move.b (%a0),%d0
	cmp.b #33,%d0
	jne .L29
.L28:
	tst.l %d3
	jne .L30
	pea 63.w
	pea 2.w
	jsr _bdos
	addq.l #8,%sp
	jra .L32
.L30:
	jsr _cr_lf
.L32:
	move.l -8(%fp),%d2
	move.l -4(%fp),%d3
	unlk %fp
	rts
	.even
	.globl	_decode
_decode:
	link.w %fp,#0
	move.l %d3,-(%sp)
	move.l %d2,-(%sp)
	move.l 8(%fp),%d3
	moveq #0,%d2
	jra .L35
.L38:
	move.l %d2,%d1
	lsl.l #3,%d1
	move.l #_cmd_tbl,%d0
	move.l %d1,%a0
	move.l (%a0,%d0.l),%d0
	move.l %d0,-(%sp)
	move.l %d3,-(%sp)
	jsr _strcmp
	addq.l #8,%sp
	tst.l %d0
	jne .L36
	move.l %d2,%d1
	lsl.l #3,%d1
	move.l #_cmd_tbl+4,%d0
	move.l %d1,%a0
	move.l (%a0,%d0.l),%d0
	jra .L37
.L36:
	addq.l #1,%d2
.L35:
	moveq #6,%d0
	cmp.l %d2,%d0
	jcc .L38
	moveq #0,%d2
	jra .L39
.L41:
	addq.l #1,%d2
.L39:
	moveq #24,%d0
	cmp.l %d2,%d0
	jcs .L40
	move.l #_parm,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #58,%d0
	jne .L41
.L40:
	moveq #1,%d0
	cmp.l %d2,%d0
	jne .L42
	move.b _parm+2,%d0
	tst.b %d0
	jne .L42
	move.b _parm+26,%d0
	tst.b %d0
	jne .L42
	move.b _parm,%d0
	cmp.b #64,%d0
	jle .L42
	move.b _parm,%d0
	cmp.b #80,%d0
	jgt .L42
	moveq #5,%d0
	jra .L37
.L42:
	moveq #1,%d0
	cmp.l %d2,%d0
	jne .L43
	move.b _parm,%d0
	cmp.b #64,%d0
	jle .L44
	move.b _parm,%d0
	cmp.b #80,%d0
	jle .L43
.L44:
	moveq #-1,%d0
	jra .L37
.L43:
	moveq #1,%d0
	cmp.l %d2,%d0
	jeq .L45
	move.l #_parm,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #58,%d0
	jne .L45
	moveq #-1,%d0
	jra .L37
.L45:
	pea _cmdfcb
	clr.l -(%sp)
	jsr _fill_fcb
	addq.l #8,%sp
	tst.l %d0
	jeq .L46
	moveq #-1,%d0
	jra .L37
.L46:
	moveq #1,%d0
	cmp.l %d2,%d0
	jne .L47
	moveq #2,%d2
	jra .L48
.L47:
	moveq #0,%d2
.L48:
	move.l %d2,%d0
	add.l #_parm,%d0
	move.l %d0,-(%sp)
	jsr _delim
	addq.l #4,%sp
	tst.l %d0
	jeq .L49
	moveq #-1,%d0
	jra .L37
.L49:
	moveq #0,%d2
	jra .L50
.L53:
	move.l #_parm,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #31,%d0
	jgt .L51
	moveq #-1,%d0
	jra .L37
.L51:
	addq.l #1,%d2
.L50:
	moveq #24,%d0
	cmp.l %d2,%d0
	jcs .L52
	move.l #_parm,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	tst.b %d0
	jne .L53
.L52:
	moveq #8,%d0
.L37:
	move.l -8(%fp),%d2
	move.l -4(%fp),%d3
	unlk %fp
	rts
	.even
	.globl	_check_cmd
_check_cmd:
	link.w %fp,#0
	move.l 8(%fp),%d0
	jra .L55
.L57:
	addq.l #1,%d0
.L55:
	move.l %d0,%a0
	move.b (%a0),%d1
	tst.b %d1
	jeq .L56
	move.l %d0,%a0
	move.b (%a0),%d1
	cmp.b #33,%d1
	jne .L57
.L56:
	move.l %d0,%a0
	move.b (%a0),%d1
	cmp.b #33,%d1
	seq %d1
	neg.b %d1
	addq.l #1,%d0
	tst.b %d1
	jeq .L58
	move.l %d0,%a0
	move.b (%a0),%d1
	tst.b %d1
	jeq .L58
	move.b #1,_morecmds
	jra .L59
.L60:
	addq.l #1,%d0
.L59:
	move.l %d0,%a0
	move.b (%a0),%d1
	cmp.b #32,%d1
	jeq .L60
	move.l %d0,_user_ptr
	jra .L64
.L58:
	move.b _submit,%d0
	tst.b %d0
	jeq .L62
	move.b _end_of_file,%d0
	tst.b %d0
	jne .L63
	move.b #1,_morecmds
	jra .L64
.L63:
	clr.b _submit
	move.l _user_ptr,%d0
	move.l %d0,%a0
	move.b (%a0),%d0
	tst.b %d0
	jeq .L64
	move.b #1,_morecmds
	jra .L64
.L62:
	clr.b _morecmds
.L64:
	unlk %fp
	rts
	.even
	.globl	_get_cmd
_get_cmd:
	link.w %fp,#0
	movem.l #14336,-(%sp)
	move.l 8(%fp),%d3
	move.l 12(%fp),%d4
	move.l %d4,%d0
	subq.l #1,%d0
	add.l %d3,%d0
	move.l %d0,%d4
	move.b #-128,_dma
	pea _dma
	pea 10.w
	jsr _bdos
	addq.l #8,%sp
	move.b _dma+1,%d0
	tst.b %d0
	jeq .L66
	move.b _dma+2,%d0
	cmp.b #59,%d0
	jeq .L66
	jsr _cr_lf
.L66:
	move.b _dma+1,%d0
	ext.w %d0
	ext.l %d0
	moveq #0,%d1
	not.b %d1
	and.l %d1,%d0
	addq.l #2,%d0
	move.l #_dma,%d1
	move.l %d0,%a0
	move.b #10,(%a0,%d1.l)
	move.b _dma+2,%d0
	cmp.b #59,%d0
	jne .L67
	move.b #10,_dma+2
.L67:
	move.l #_dma+2,%d2
	jra .L68
.L69:
	addq.l #1,%d2
.L68:
	move.l %d2,%a0
	move.b (%a0),%d0
	cmp.b #32,%d0
	jeq .L69
	move.l %d2,%a0
	move.b (%a0),%d0
	cmp.b #9,%d0
	jeq .L69
	jra .L70
.L77:
	move.l %d2,%a0
	move.b (%a0),%d0
	cmp.b #96,%d0
	jle .L71
	move.l %d2,%a0
	move.b (%a0),%d0
	cmp.b #122,%d0
	jgt .L71
	move.l %d2,%a0
	move.b (%a0),%d0
	add.b #-32,%d0
	jra .L72
.L71:
	move.l %d2,%a0
	move.b (%a0),%d0
.L72:
	move.l %d3,%a0
	move.b %d0,(%a0)
	addq.l #1,%d3
	move.l %d2,%a0
	move.b (%a0),%d0
	cmp.b #32,%d0
	jeq .L75
	move.l %d2,%a0
	move.b (%a0),%d0
	cmp.b #9,%d0
	jne .L74
.L75:
	addq.l #1,%d2
	move.l %d2,%a0
	move.b (%a0),%d0
	cmp.b #32,%d0
	jeq .L75
	move.l %d2,%a0
	move.b (%a0),%d0
	cmp.b #9,%d0
	jeq .L75
	jra .L70
.L74:
	addq.l #1,%d2
.L70:
	move.l %d2,%a0
	move.b (%a0),%d0
	cmp.b #10,%d0
	jeq .L76
	move.l %d4,%d0
	cmp.l %d0,%d3
	jcs .L77
.L76:
	move.l %d3,%a0
	clr.b (%a0)
	movem.l -12(%fp),#28
	unlk %fp
	rts
	.even
	.globl	_scan_cmd
_scan_cmd:
	link.w %fp,#0
	move.l 8(%fp),%d0
	jra .L79
.L81:
	addq.l #1,%d0
.L79:
	move.l %d0,%a0
	move.b (%a0),%d1
	cmp.b #33,%d1
	jeq .L84
	move.l %d0,%a0
	move.b (%a0),%d1
	tst.b %d1
	jne .L81
	jra .L84
.L83:
	addq.l #1,%d0
	jra .L82
.L84:
	nop
.L82:
	move.l %d0,%a0
	move.b (%a0),%d1
	cmp.b #33,%d1
	jeq .L83
	move.l %d0,%a0
	move.b (%a0),%d1
	cmp.b #32,%d1
	jeq .L83
	move.l %d0,%a0
	move.b (%a0),%d1
	cmp.b #9,%d1
	jeq .L83
	unlk %fp
	rts
	.even
	.globl	_get_parms
_get_parms:
	link.w %fp,#0
	movem.l #14336,-(%sp)
	move.l 8(%fp),%d0
	move.l #_parm,%d3
	moveq #0,%d2
	jra .L86
.L87:
	move.l %d3,%a0
	clr.b (%a0)
	addq.l #1,%d3
	addq.l #1,%d2
.L86:
	moveq #103,%d1
	cmp.l %d2,%d1
	jcc .L87
	moveq #0,%d2
	jra .L88
.L96:
	moveq #0,%d3
	jra .L89
.L92:
	moveq #24,%d4
	cmp.l %d3,%d4
	jcs .L90
	move.l %d0,%a1
	move.b (%a1),%d1
	move.w %d1,%a0
	move.l %d2,%d1
	add.l %d1,%d1
	add.l %d2,%d1
	add.l %d1,%d1
	add.l %d1,%d1
	add.l %d2,%d1
	add.l %d1,%d1
	add.l %d3,%d1
	add.l #_parm,%d1
	move.w %a0,%d4
	move.l %d1,%a1
	move.b %d4,(%a1)
	addq.l #1,%d3
.L90:
	addq.l #1,%d0
.L89:
	move.l %d0,%a0
	move.b (%a0),%d1
	cmp.b #33,%d1
	jeq .L91
	move.l %d0,%a1
	move.b (%a1),%d1
	cmp.b #32,%d1
	jeq .L91
	move.l %d0,%a0
	move.b (%a0),%d1
	cmp.b #9,%d1
	jeq .L91
	move.l %d0,%a1
	move.b (%a1),%d1
	tst.b %d1
	jne .L92
.L91:
	move.l %d2,%d1
	add.l %d1,%d1
	add.l %d2,%d1
	add.l %d1,%d1
	add.l %d1,%d1
	add.l %d2,%d1
	add.l %d1,%d1
	add.l %d3,%d1
	add.l #_parm,%d1
	move.l %d1,%a0
	clr.b (%a0)
	addq.l #1,%d2
	move.l %d0,%a1
	move.b (%a1),%d1
	cmp.b #32,%d1
	jeq .L93
	move.l %d0,%a0
	move.b (%a0),%d1
	cmp.b #9,%d1
	jne .L94
.L93:
	addq.l #1,%d0
.L94:
	moveq #1,%d1
	cmp.l %d2,%d1
	jne .L88
	move.l %d0,_tail
.L88:
	move.l %d0,%a0
	move.b (%a0),%d1
	tst.b %d1
	jeq .L97
	move.l %d0,%a1
	move.b (%a1),%d1
	cmp.b #33,%d1
	jeq .L97
	moveq #3,%d1
	cmp.l %d2,%d1
	jcc .L96
.L97:
	movem.l (%sp)+,#28
	unlk %fp
	rts
	.even
	.globl	_delim
_delim:
	link.w %fp,#0
	move.l %d3,-(%sp)
	move.l %d2,-(%sp)
	move.l 8(%fp),%d0
	move.l %d0,%a0
	move.b (%a0),%d1
	cmp.b #32,%d1
	jgt .L99
	moveq #1,%d0
	jra .L100
.L99:
	moveq #0,%d2
	jra .L101
.L103:
	move.l %d0,%a1
	move.b (%a1),%d1
	move.w %d1,%a0
	move.l #_del,%d1
	move.l %d2,%a1
	move.b (%a1,%d1.l),%d1
	move.w %a0,%d3
	cmp.b %d3,%d1
	jne .L102
	moveq #1,%d0
	jra .L100
.L102:
	addq.l #1,%d2
.L101:
	moveq #15,%d1
	cmp.l %d2,%d1
	jcc .L103
	moveq #0,%d0
.L100:
	move.l (%sp)+,%d2
	move.l (%sp)+,%d3
	unlk %fp
	rts
	.even
	.globl	_true_char
_true_char:
	link.w %fp,#0
	move.l %d2,-(%sp)
	move.l 8(%fp),%d2
	move.l %d2,%a0
	move.b (%a0),%d0
	cmp.b #42,%d0
	jne .L105
	moveq #63,%d0
	jra .L106
.L105:
	move.l %d2,-(%sp)
	jsr _delim
	addq.l #4,%sp
	tst.l %d0
	jne .L107
	move.l _index,%d0
	addq.l #1,%d0
	move.l %d0,_index
	move.l %d2,%a0
	move.b (%a0),%d0
	jra .L106
.L107:
	moveq #32,%d0
.L106:
	move.l -4(%fp),%d2
	unlk %fp
	rts
	.even
	.globl	_fill_fcb
_fill_fcb:
	link.w %fp,#0
	movem.l #15872,-(%sp)
	move.l 8(%fp),%d4
	move.l 12(%fp),%d5
	move.l %d5,%a0
	clr.b (%a0)
	moveq #12,%d3
	jra .L109
.L110:
	move.l %d5,%d0
	add.l %d3,%d0
	move.l %d0,%a0
	clr.b (%a0)
	addq.l #1,%d3
.L109:
	moveq #35,%d0
	cmp.l %d3,%d0
	jcc .L110
	moveq #1,%d3
	jra .L111
.L112:
	move.l %d5,%d0
	add.l %d3,%d0
	move.l %d0,%a0
	move.b #32,(%a0)
	addq.l #1,%d3
.L111:
	moveq #11,%d0
	cmp.l %d3,%d0
	jcc .L112
	move.b _dirflag,%d0
	tst.b %d0
	jeq .L113
	moveq #63,%d6
	jra .L114
.L113:
	moveq #32,%d6
.L114:
	clr.l _index
	move.l %d5,%d3
	move.l _index,%d1
	move.l %d4,%d0
	add.l %d0,%d0
	add.l %d4,%d0
	add.l %d0,%d0
	add.l %d0,%d0
	add.l %d4,%d0
	add.l %d0,%d0
	add.l %d1,%d0
	add.l #_parm,%d0
	move.l %d0,%a0
	move.b (%a0),%d0
	tst.b %d0
	jne .L115
	addq.l #1,%d3
	moveq #1,%d2
	jra .L116
.L117:
	move.l %d3,%a0
	move.b %d6,(%a0)
	addq.l #1,%d3
	addq.l #1,%d2
.L116:
	moveq #11,%d0
	cmp.l %d2,%d0
	jcc .L117
	clr.l -(%sp)
	pea 25.w
	jsr _bdos
	addq.l #8,%sp
	move.b %d0,%d0
	addq.b #1,%d0
	move.l %d5,%a0
	move.b %d0,(%a0)
	move.b _dirflag,%d0
	tst.b %d0
	jeq .L118
	moveq #11,%d0
	jra .L119
.L118:
	moveq #0,%d0
	jra .L119
.L115:
	move.l _index,%d0
	move.l %d0,%d1
	addq.l #1,%d1
	move.l %d4,%d0
	add.l %d0,%d0
	add.l %d4,%d0
	add.l %d0,%d0
	add.l %d0,%d0
	add.l %d4,%d0
	add.l %d0,%d0
	add.l %d1,%d0
	add.l #_parm,%d0
	move.l %d0,%a0
	move.b (%a0),%d0
	cmp.b #58,%d0
	jne .L120
	move.l _index,%d1
	move.l %d4,%d0
	add.l %d0,%d0
	add.l %d4,%d0
	add.l %d0,%d0
	add.l %d0,%d0
	add.l %d4,%d0
	add.l %d0,%d0
	add.l %d1,%d0
	add.l #_parm,%d0
	move.l %d0,%a0
	move.b (%a0),%d0
	add.b #-64,%d0
	move.l %d3,%a0
	move.b %d0,(%a0)
	move.l _index,%d0
	addq.l #2,%d0
	move.l %d0,_index
	move.l _index,%d1
	move.l %d4,%d0
	add.l %d0,%d0
	add.l %d4,%d0
	add.l %d0,%d0
	add.l %d0,%d0
	add.l %d4,%d0
	add.l %d0,%d0
	add.l %d1,%d0
	add.l #_parm,%d0
	move.l %d0,%a0
	move.b (%a0),%d0
	tst.b %d0
	jne .L121
	move.l %d5,%d3
	addq.l #1,%d3
	moveq #1,%d2
	jra .L122
.L123:
	move.l %d3,%a0
	move.b %d6,(%a0)
	addq.l #1,%d3
	addq.l #1,%d2
.L122:
	moveq #11,%d0
	cmp.l %d2,%d0
	jcc .L123
	move.b _dirflag,%d0
	tst.b %d0
	jeq .L124
	moveq #11,%d0
	jra .L119
.L124:
	moveq #0,%d0
	jra .L119
.L120:
	clr.l -(%sp)
	pea 25.w
	jsr _bdos
	addq.l #8,%sp
	move.b %d0,%d0
	addq.b #1,%d0
	move.l %d5,%a0
	move.b %d0,(%a0)
.L121:
	move.l %d5,%d3
	addq.l #1,%d3
	moveq #1,%d2
	jra .L125
.L126:
	move.l %d4,%d0
	add.l %d0,%d0
	add.l %d4,%d0
	add.l %d0,%d0
	add.l %d0,%d0
	add.l %d4,%d0
	add.l %d0,%d0
	move.l %d0,%d1
	move.l _index,%d0
	add.l %d1,%d0
	add.l #_parm,%d0
	move.l %d0,-(%sp)
	jsr _true_char
	addq.l #4,%sp
	move.l %d3,%a0
	move.b %d0,(%a0)
	addq.l #1,%d3
	addq.l #1,%d2
.L125:
	moveq #8,%d0
	cmp.l %d2,%d0
	jcc .L126
	jra .L127
.L128:
	move.l _index,%d0
	addq.l #1,%d0
	move.l %d0,_index
.L127:
	move.l %d4,%d0
	add.l %d0,%d0
	add.l %d4,%d0
	add.l %d0,%d0
	add.l %d0,%d0
	add.l %d4,%d0
	add.l %d0,%d0
	move.l %d0,%d1
	move.l _index,%d0
	add.l %d1,%d0
	add.l #_parm,%d0
	move.l %d0,-(%sp)
	jsr _delim
	addq.l #4,%sp
	tst.l %d0
	jeq .L128
	move.l _index,%d1
	move.l %d4,%d0
	add.l %d0,%d0
	add.l %d4,%d0
	add.l %d0,%d0
	add.l %d0,%d0
	add.l %d4,%d0
	add.l %d0,%d0
	add.l %d1,%d0
	add.l #_parm,%d0
	move.l %d0,%a0
	move.b (%a0),%d0
	cmp.b #46,%d0
	jne .L129
	move.l _index,%d0
	addq.l #1,%d0
	move.l %d0,_index
	moveq #1,%d2
	jra .L130
.L131:
	move.l %d4,%d0
	add.l %d0,%d0
	add.l %d4,%d0
	add.l %d0,%d0
	add.l %d0,%d0
	add.l %d4,%d0
	add.l %d0,%d0
	move.l %d0,%d1
	move.l _index,%d0
	add.l %d1,%d0
	add.l #_parm,%d0
	move.l %d0,-(%sp)
	jsr _true_char
	addq.l #4,%sp
	move.l %d3,%a0
	move.b %d0,(%a0)
	addq.l #1,%d3
	addq.l #1,%d2
.L130:
	moveq #3,%d0
	cmp.l %d2,%d0
	jcc .L131
.L129:
	moveq #0,%d3
	moveq #1,%d2
	jra .L132
.L134:
	move.l %d5,%d0
	add.l %d2,%d0
	move.l %d0,%a0
	move.b (%a0),%d0
	cmp.b #63,%d0
	jne .L133
	addq.l #1,%d3
.L133:
	addq.l #1,%d2
.L132:
	moveq #11,%d0
	cmp.l %d2,%d0
	jcc .L134
	move.l %d3,%d0
.L119:
	movem.l -20(%fp),#124
	unlk %fp
	rts
	.even
	.globl	_too_many
_too_many:
	link.w %fp,#0
	move.b _parm+52,%d0
	tst.b %d0
	jeq .L136
	pea _msg13
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
	clr.l -(%sp)
	pea _parm+52
	jsr _echo_cmd
	addq.l #8,%sp
	moveq #1,%d0
	jra .L137
.L136:
	moveq #0,%d0
.L137:
	unlk %fp
	rts
	.even
	.globl	_find_colon
_find_colon:
	link.w %fp,#0
	move.l %d2,-(%sp)
	moveq #0,%d2
	jra .L139
.L141:
	addq.l #1,%d2
.L139:
	move.l #_parm+26,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	tst.b %d0
	jeq .L140
	move.l #_parm+26,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #58,%d0
	jne .L141
.L140:
	move.l %d2,%d0
	move.l (%sp)+,%d2
	unlk %fp
	rts
	.even
	.globl	_chk_colon
_chk_colon:
	link.w %fp,#0
	move.l 8(%fp),%d0
	add.l #_parm+26,%d0
	move.l %d0,%a0
	move.b (%a0),%d0
	cmp.b #58,%d0
	jne .L143
	moveq #1,%d0
	cmp.l 8(%fp),%d0
	jne .L144
	move.b _parm+26,%d0
	cmp.b #64,%d0
	jle .L144
	move.b _parm+26,%d0
	cmp.b #80,%d0
	jle .L143
.L144:
	clr.l -(%sp)
	pea _parm+26
	jsr _echo_cmd
	addq.l #8,%sp
	moveq #0,%d0
	jra .L145
.L143:
	moveq #1,%d0
.L145:
	unlk %fp
	rts
	.even
	.globl	_dir_cmd
_dir_cmd:
	link.w %fp,#-4
	movem.l #16128,-(%sp)
	move.l 8(%fp),%d5
	moveq #0,%d6
	clr.b -1(%fp)
	jsr _too_many
	tst.l %d0
	jne .L169
.L147:
	jsr _find_colon
	move.l %d0,%d3
	move.l %d3,-(%sp)
	jsr _chk_colon
	addq.l #4,%sp
	tst.l %d0
	jeq .L170
.L149:
	pea _cmdfcb
	pea 1.w
	jsr _fill_fcb
	addq.l #8,%sp
	move.b _cmdfcb,%d0
	ext.w %d0
	ext.l %d0
	moveq #64,%d1
	add.l %d1,%d0
	move.l %d0,%d7
	pea _cmdfcb
	pea 17.w
	jsr _bdos
	addq.l #8,%sp
	move.l %d0,%d2
	cmp.l #255,%d2
	jne .L150
	pea _msg6
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
.L150:
	move.l %d2,%d0
	lsl.l #5,%d0
	move.l %d0,%d3
	addq.l #1,%d3
	moveq #0,%d4
	jra .L151
.L166:
	tst.l %d5
	jeq .L152
	moveq #9,%d0
	add.l %d3,%d0
	move.l #_dma,%d1
	move.l %d0,%a0
	move.b (%a0,%d1.l),%d0
	tst.b %d0
	jlt .L153
.L152:
	tst.l %d5
	jne .L154
	moveq #9,%d0
	add.l %d3,%d0
	move.l #_dma,%d1
	move.l %d0,%a0
	move.b (%a0,%d1.l),%d0
	tst.b %d0
	jlt .L154
.L153:
	tst.b -1(%fp)
	jeq .L155
	jsr _cr_lf
	clr.b -1(%fp)
.L155:
	tst.l %d4
	jne .L157
	move.l %d7,%d0
	move.l %d0,-(%sp)
	pea 2.w
	jsr _bdos
	addq.l #8,%sp
	jra .L157
.L154:
	moveq #1,%d6
	pea 18.w
	jsr _bdos
	addq.l #4,%sp
	move.l %d0,%d2
	move.l %d2,%d0
	lsl.l #5,%d0
	move.l %d0,%d3
	addq.l #1,%d3
	jra .L151
.L157:
	move.l %d2,%d0
	lsl.l #5,%d0
	move.l %d0,%d2
	addq.l #1,%d2
	pea 58.w
	pea 2.w
	jsr _bdos
	addq.l #8,%sp
	pea 32.w
	pea 2.w
	jsr _bdos
	addq.l #8,%sp
	moveq #1,%d3
	jra .L158
.L160:
	moveq #9,%d0
	cmp.l %d3,%d0
	jne .L159
	pea 32.w
	pea 2.w
	jsr _bdos
	addq.l #8,%sp
.L159:
	move.l #_dma,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	ext.w %d0
	ext.l %d0
	moveq #127,%d1
	and.l %d1,%d0
	addq.l #1,%d2
	move.l %d0,-(%sp)
	pea 2.w
	jsr _bdos
	addq.l #8,%sp
	addq.l #1,%d3
.L158:
	moveq #11,%d0
	cmp.l %d3,%d0
	jcc .L160
	pea 32.w
	pea 2.w
	jsr _bdos
	addq.l #8,%sp
	pea 18.w
	jsr _bdos
	addq.l #4,%sp
	move.l %d0,%d2
	cmp.l #255,%d2
	jeq .L171
.L161:
	addq.l #1,%d4
	move.l %d2,%d0
	lsl.l #5,%d0
	move.l %d0,%d3
	addq.l #1,%d3
	moveq #5,%d1
	cmp.l %d4,%d1
	jne .L151
	moveq #0,%d4
	tst.l %d5
	jeq .L163
	moveq #9,%d0
	add.l %d3,%d0
	move.l #_dma,%d1
	move.l %d0,%a0
	move.b (%a0,%d1.l),%d0
	tst.b %d0
	jlt .L164
.L163:
	tst.l %d5
	jne .L165
	moveq #9,%d0
	add.l %d3,%d0
	move.l #_dma,%d1
	move.l %d0,%a0
	move.b (%a0,%d1.l),%d0
	tst.b %d0
	jlt .L165
.L164:
	jsr _cr_lf
	jra .L151
.L165:
	move.b #1,-1(%fp)
.L151:
	cmp.l #255,%d2
	jne .L166
	jra .L162
.L171:
	nop
.L162:
	tst.l %d6
	jeq .L168
	jsr _cr_lf
	tst.l %d5
	jeq .L167
	pea _msg
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
	jra .L168
.L167:
	pea _msg+4
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
	jra .L168
.L169:
	nop
	jra .L168
.L170:
	nop
.L168:
	movem.l -28(%fp),#252
	unlk %fp
	rts
	.even
	.globl	_type_cmd
_type_cmd:
	link.w %fp,#0
	move.l %d2,-(%sp)
	move.b _parm+26,%d0
	tst.b %d0
	jne .L173
	pea _msg2
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
	pea 25.w
	pea _parm+26
	jsr _get_cmd
	addq.l #8,%sp
.L173:
	jsr _too_many
	tst.l %d0
	jne .L185
.L174:
	jsr _find_colon
	move.l %d0,%d2
	move.l %d2,-(%sp)
	jsr _chk_colon
	addq.l #4,%sp
	tst.l %d0
	jeq .L186
.L176:
	pea _cmdfcb
	pea 1.w
	jsr _fill_fcb
	addq.l #8,%sp
	move.l %d0,%d2
	tst.l %d2
	jne .L177
	move.b _parm+26,%d0
	tst.b %d0
	jeq .L177
	pea _cmdfcb
	pea 15.w
	jsr _bdos
	addq.l #8,%sp
	moveq #3,%d1
	cmp.l %d0,%d1
	jcs .L177
	jra .L178
.L182:
	moveq #0,%d2
	jra .L179
.L181:
	move.l #_dma,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #26,%d0
	jeq .L187
	move.l #_dma,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	ext.w %d0
	ext.l %d0
	move.l %d0,-(%sp)
	pea 2.w
	jsr _bdos
	addq.l #8,%sp
	addq.l #1,%d2
.L179:
	moveq #127,%d0
	cmp.l %d2,%d0
	jcc .L181
	jra .L178
.L187:
	nop
.L178:
	pea _cmdfcb
	pea 20.w
	jsr _bdos
	addq.l #8,%sp
	tst.l %d0
	jeq .L182
	move.b _cmdfcb,%d0
	ext.w %d0
	ext.l %d0
	move.l %d0,-(%sp)
	pea 37.w
	jsr _bdos
	addq.l #8,%sp
	jra .L184
.L177:
	move.b _parm+26,%d0
	tst.b %d0
	jeq .L184
	tst.l %d2
	jeq .L183
	pea _msg7
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
	jra .L184
.L183:
	pea _msg6
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
	jra .L184
.L185:
	nop
	jra .L184
.L186:
	nop
.L184:
	move.l -4(%fp),%d2
	unlk %fp
	rts
	.even
	.globl	_ren_cmd
_ren_cmd:
	link.w %fp,#-36
	movem.l #15360,-(%sp)
	moveq #0,%d4
	move.b _parm+26,%d0
	tst.b %d0
	jne .L189
	pea _msg3
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
	pea 25.w
	pea _parm+78
	jsr _get_cmd
	addq.l #8,%sp
	move.b _parm+78,%d0
	tst.b %d0
	jeq .L224
.L190:
	pea _msg4
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
	pea 25.w
	pea _parm+26
	jsr _get_cmd
	addq.l #8,%sp
	move.b #61,_parm+52
	jra .L192
.L189:
	moveq #0,%d2
	jra .L193
.L195:
	addq.l #1,%d2
.L193:
	move.l #_parm+26,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #61,%d0
	jeq .L194
	move.l #_parm+26,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	tst.b %d0
	jne .L195
.L194:
	move.l #_parm+26,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #61,%d0
	jne .L196
	tst.l %d2
	jeq .L197
	move.l %d2,%d0
	addq.l #1,%d0
	move.l #_parm+26,%d1
	move.l %d0,%a0
	move.b (%a0,%d1.l),%d0
	tst.b %d0
	jeq .L197
	move.b _parm+52,%d0
	tst.b %d0
	jeq .L198
.L197:
	moveq #1,%d4
	jra .L198
.L196:
	move.b _parm+52,%d0
	cmp.b #61,%d0
	jne .L199
	move.b _parm+53,%d0
	tst.b %d0
	jne .L199
	move.b _parm+78,%d0
	tst.b %d0
	jne .L198
.L199:
	moveq #1,%d4
.L198:
	tst.l %d4
	jne .L192
	move.l #_parm+26,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #61,%d0
	jne .L192
	move.l #_parm+26,%d0
	move.l %d2,%a0
	clr.b (%a0,%d0.l)
	addq.l #1,%d2
	moveq #0,%d3
	nop
.L200:
	move.l #_parm+26,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d1
	move.l #_parm+78,%d0
	move.l %d3,%a0
	move.b %d1,(%a0,%d0.l)
	move.l #_parm+78,%d0
	move.l %d3,%a0
	move.b (%a0,%d0.l),%d0
	tst.b %d0
	sne %d0
	neg.b %d0
	addq.l #1,%d3
	addq.l #1,%d2
	tst.b %d0
	jne .L200
	move.b #61,_parm+52
.L192:
	moveq #1,%d3
	jra .L201
.L209:
	moveq #0,%d5
	jra .L202
.L204:
	addq.l #1,%d5
.L202:
	move.l %d3,%d0
	add.l %d0,%d0
	add.l %d3,%d0
	add.l %d0,%d0
	add.l %d0,%d0
	add.l %d3,%d0
	add.l %d0,%d0
	add.l %d5,%d0
	add.l #_parm,%d0
	move.l %d0,%a0
	move.b (%a0),%d0
	cmp.b #58,%d0
	jeq .L203
	move.l %d3,%d0
	add.l %d0,%d0
	add.l %d3,%d0
	add.l %d0,%d0
	add.l %d0,%d0
	add.l %d3,%d0
	add.l %d0,%d0
	add.l %d5,%d0
	add.l #_parm,%d0
	move.l %d0,%a0
	move.b (%a0),%d0
	tst.b %d0
	jne .L204
.L203:
	moveq #1,%d0
	cmp.l %d5,%d0
	jcc .L205
	move.l %d3,%d0
	add.l %d0,%d0
	add.l %d3,%d0
	add.l %d0,%d0
	add.l %d0,%d0
	add.l %d3,%d0
	add.l %d0,%d0
	add.l %d5,%d0
	add.l #_parm,%d0
	move.l %d0,%a0
	move.b (%a0),%d0
	cmp.b #58,%d0
	jne .L205
	moveq #1,%d4
.L205:
	moveq #0,%d2
	jra .L206
.L208:
	move.l %d3,%d0
	add.l %d0,%d0
	add.l %d3,%d0
	add.l %d0,%d0
	add.l %d0,%d0
	add.l %d3,%d0
	add.l %d0,%d0
	move.l #_parm,%d1
	move.l %d0,%a0
	move.b (%a0,%d1.l),%d1
	move.l #_del,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b %d1,%d0
	jne .L207
	move.l %d3,%d0
	add.l %d0,%d0
	add.l %d3,%d0
	add.l %d0,%d0
	add.l %d0,%d0
	add.l %d3,%d0
	add.l %d0,%d0
	add.l #_parm,%d0
	clr.l -(%sp)
	move.l %d0,-(%sp)
	jsr _echo_cmd
	addq.l #8,%sp
	jra .L223
.L207:
	addq.l #1,%d2
.L206:
	moveq #15,%d0
	cmp.l %d2,%d0
	jcc .L208
	addq.l #2,%d3
.L201:
	moveq #3,%d0
	cmp.l %d3,%d0
	jcc .L209
	tst.l %d4
	jne .L210
	move.b _parm+26,%d0
	tst.b %d0
	jeq .L210
	move.b _parm+78,%d0
	tst.b %d0
	jeq .L210
	moveq #-36,%d0
	add.l %fp,%d0
	move.l %d0,-(%sp)
	pea 1.w
	jsr _fill_fcb
	addq.l #8,%sp
	move.l %d0,%d2
	pea _cmdfcb
	pea 3.w
	jsr _fill_fcb
	addq.l #8,%sp
	move.l %d0,%d3
	tst.l %d2
	jne .L211
	tst.l %d3
	jne .L211
	move.b -36(%fp),%d1
	move.b _cmdfcb,%d0
	cmp.b %d1,%d0
	jeq .L212
	move.b _parm+27,%d0
	cmp.b #58,%d0
	jne .L213
	move.b _parm+79,%d0
	cmp.b #58,%d0
	jeq .L213
	move.b -36(%fp),%d0
	move.b %d0,_cmdfcb
	jra .L212
.L213:
	move.b _parm+27,%d0
	cmp.b #58,%d0
	jeq .L214
	move.b _parm+79,%d0
	cmp.b #58,%d0
	jne .L214
	move.b _cmdfcb,%d0
	move.b %d0,-36(%fp)
	jra .L212
.L214:
	moveq #1,%d4
.L212:
	move.b -36(%fp),%d0
	tst.b %d0
	jle .L215
	move.b -36(%fp),%d0
	cmp.b #16,%d0
	jle .L216
.L215:
	moveq #1,%d4
.L216:
	tst.l %d4
	jne .L217
	moveq #-36,%d0
	add.l %fp,%d0
	move.l %d0,-(%sp)
	pea 17.w
	jsr _bdos
	addq.l #8,%sp
	cmp.l #255,%d0
	jeq .L217
	pea _msg5
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
	jra .L225
.L217:
	moveq #0,%d5
	moveq #16,%d2
	jra .L219
.L220:
	move.b -36(%fp,%d5.l),%d1
	move.l #_cmdfcb,%d0
	move.l %d2,%a0
	move.b %d1,(%a0,%d0.l)
	addq.l #1,%d5
	addq.l #1,%d2
.L219:
	moveq #35,%d0
	cmp.l %d2,%d0
	jcc .L220
	move.b _cmdfcb,%d0
	tst.b %d0
	jlt .L221
	move.b _cmdfcb,%d0
	cmp.b #15,%d0
	jle .L222
.L221:
	moveq #1,%d4
.L222:
	tst.l %d4
	jne .L225
	pea _cmdfcb
	pea 23.w
	jsr _bdos
	addq.l #8,%sp
	tst.l %d0
	jeq .L225
	pea _msg6
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
	jra .L225
.L211:
	pea _msg7
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
	jra .L210
.L225:
	nop
.L210:
	tst.l %d4
	jeq .L223
	pea _msg8
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
	jra .L223
.L224:
	nop
.L223:
	movem.l -52(%fp),#60
	unlk %fp
	rts
	.even
	.globl	_era_cmd
_era_cmd:
	link.w %fp,#0
	move.l %d2,-(%sp)
	move.b _parm+26,%d0
	tst.b %d0
	jne .L227
	pea _msg2
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
	pea 25.w
	pea _parm+26
	jsr _get_cmd
	addq.l #8,%sp
.L227:
	move.b _parm+26,%d0
	tst.b %d0
	jeq .L237
.L228:
	jsr _too_many
	tst.l %d0
	jne .L238
.L230:
	jsr _find_colon
	move.l %d0,%d2
	move.l %d2,-(%sp)
	jsr _chk_colon
	addq.l #4,%sp
	tst.l %d0
	jeq .L239
.L231:
	move.b _parm+27,%d0
	cmp.b #58,%d0
	jne .L232
	move.b _parm+28,%d0
	tst.b %d0
	jne .L232
	clr.l -(%sp)
	pea _parm+26
	jsr _echo_cmd
	addq.l #8,%sp
	jra .L236
.L232:
	pea _cmdfcb
	pea 1.w
	jsr _fill_fcb
	addq.l #8,%sp
	move.l %d0,%d2
	tst.l %d2
	jeq .L233
	move.b _submit,%d0
	tst.b %d0
	jne .L233
	pea _msg9
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
	clr.l -(%sp)
	pea 1.w
	jsr _bdos
	addq.l #8,%sp
	move.b %d0,%d0
	move.b %d0,_parm+52
	move.b _parm+52,%d0
	cmp.b #96,%d0
	jle .L234
	move.b _parm+52,%d0
	cmp.b #122,%d0
	jgt .L234
	move.b _parm+52,%d0
	add.b #-32,%d0
	jra .L235
.L234:
	move.b _parm+52,%d0
.L235:
	move.b %d0,_parm+52
	jsr _cr_lf
	move.b _parm+52,%d0
	cmp.b #78,%d0
	jeq .L233
	move.b _parm+52,%d0
	cmp.b #89,%d0
	jne .L240
.L233:
	move.b _parm+52,%d0
	cmp.b #78,%d0
	jeq .L236
	pea _cmdfcb
	pea 19.w
	jsr _bdos
	addq.l #8,%sp
	tst.l %d0
	jeq .L236
	pea _msg6
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
	jra .L236
.L237:
	nop
	jra .L236
.L238:
	nop
	jra .L236
.L239:
	nop
	jra .L236
.L240:
	nop
.L236:
	move.l -4(%fp),%d2
	unlk %fp
	rts
	.even
	.globl	_user_cmd
_user_cmd:
	link.w %fp,#0
	move.l %d2,-(%sp)
	move.b _parm+26,%d0
	tst.b %d0
	jne .L242
	pea _msg10
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
	pea 25.w
	pea _parm+26
	jsr _get_cmd
	addq.l #8,%sp
.L242:
	move.b _parm+26,%d0
	tst.b %d0
	jne .L243
	moveq #1,%d0
	jra .L244
.L243:
	jsr _too_many
	tst.l %d0
	jeq .L245
	moveq #1,%d0
	jra .L244
.L245:
	move.b _parm+26,%d0
	cmp.b #47,%d0
	jle .L246
	move.b _parm+26,%d0
	cmp.b #57,%d0
	jle .L247
.L246:
	moveq #0,%d0
	jra .L244
.L247:
	move.b _parm+26,%d0
	ext.w %d0
	ext.l %d0
	moveq #-48,%d1
	add.l %d1,%d0
	move.l %d0,%d2
	moveq #9,%d0
	cmp.l %d2,%d0
	jcc .L248
	moveq #0,%d0
	jra .L244
.L248:
	move.b _parm+27,%d0
	tst.b %d0
	jeq .L249
	move.l %d2,%d0
	add.l %d0,%d0
	add.l %d0,%d0
	add.l %d2,%d0
	add.l %d0,%d0
	move.l %d0,%d1
	move.b _parm+27,%d0
	ext.w %d0
	ext.l %d0
	add.l %d1,%d0
	moveq #-48,%d2
	add.l %d0,%d2
.L249:
	moveq #15,%d1
	cmp.l %d2,%d1
	jcs .L250
	move.b _parm+28,%d0
	tst.b %d0
	jne .L250
	move.l %d2,%d0
	move.l %d0,-(%sp)
	pea 32.w
	jsr _bdos
	addq.l #8,%sp
	moveq #1,%d0
	jra .L244
.L250:
	moveq #0,%d0
.L244:
	move.l -4(%fp),%d2
	unlk %fp
	rts
.LC7:
	.ascii "SUB\0"
	.even
	.globl	_cmd_file
_cmd_file:
	link.w %fp,#-8
	movem.l #15360,-(%sp)
	clr.b _dirflag
	move.b #1,_load_try
	clr.b -1(%fp)
	clr.b -4(%fp)
	clr.b -3(%fp)
	clr.b -2(%fp)
	pea 255.w
	pea 32.w
	jsr _bdos
	addq.l #8,%sp
	move.l %d0,_user
	clr.l -(%sp)
	pea 25.w
	jsr _bdos
	addq.l #8,%sp
	move.l %d0,_cur_disk
	moveq #10,%d0
	cmp.l 8(%fp),%d0
	jne .L252
	moveq #0,%d3
	jra .L253
.L252:
	moveq #1,%d3
.L253:
	pea _cmdfcb
	move.l %d3,-(%sp)
	jsr _fill_fcb
	addq.l #8,%sp
	move.l %d0,%d3
	tst.l %d3
	jeq .L254
	pea _msg7
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
	moveq #0,%d0
	jra .L255
.L254:
	move.l #_load_tbl,%d2
	move.l %d2,%a0
	move.l (%a0),%d5
	move.b _cmdfcb+9,%d0
	cmp.b #32,%d0
	jne .L256
	jra .L257
.L258:
	move.l %d2,%a1
	clr.b 9(%a1)
	move.l %d2,%a0
	move.b 9(%a0),%d0
	move.l %d2,%a1
	move.b %d0,8(%a1)
	moveq #10,%d0
	add.l %d0,%d2
.L257:
	move.l %d2,%a0
	move.l (%a0),%d0
	move.l %d0,%a1
	move.b (%a1),%d0
	tst.b %d0
	jne .L258
	move.b _cmdfcb,%d0
	ext.w %d0
	ext.l %d0
	subq.l #1,%d0
	move.l %d0,-(%sp)
	pea 14.w
	jsr _bdos
	addq.l #8,%sp
	move.b #63,_cmdfcb
	clr.b _cmdfcb+12
	pea _cmdfcb
	pea 17.w
	jsr _bdos
	addq.l #8,%sp
	move.l %d0,%d3
	jra .L259
.L270:
	lsl.l #5,%d3
	move.l #_dma,%d0
	move.l %d3,%a0
	move.b (%a0,%d0.l),%d0
	tst.b %d0
	jeq .L260
	move.l #_dma,%d0
	move.l %d3,%a1
	move.b (%a1,%d0.l),%d0
	ext.w %d0
	ext.l %d0
	move.l _user,%d1
	cmp.l %d0,%d1
	jne .L261
.L260:
	moveq #9,%d4
	jra .L262
.L263:
	move.l %d3,%d0
	add.l %d4,%d0
	move.l %d3,%d1
	add.l %d4,%d1
	lea _dma,%a0
	move.b (%a0,%d1.l),%d1
	move.b %d1,%d2
	and.b #127,%d2
	move.w %d2,%a0
	move.l #_dma,%d1
	move.w %a0,%d2
	move.l %d0,%a1
	move.b %d2,(%a1,%d1.l)
	addq.l #1,%d4
.L262:
	moveq #11,%d0
	cmp.l %d4,%d0
	jcc .L263
	moveq #12,%d0
	add.l %d3,%d0
	move.l #_dma,%d1
	move.l %d0,%a0
	clr.b (%a0,%d1.l)
	move.l #_load_tbl,%d2
	jra .L264
.L268:
	move.l %d2,%a1
	move.l (%a1),%d0
	pea _cmdfcb+9
	move.l %d0,-(%sp)
	jsr _cpy
	addq.l #8,%sp
	move.l %d3,%d0
	addq.l #1,%d0
	add.l #_dma,%d0
	move.l %d0,-(%sp)
	pea _cmdfcb+1
	jsr _strcmp
	addq.l #8,%sp
	tst.l %d0
	jne .L265
	move.b #1,-4(%fp)
	move.l #_dma,%d0
	move.l %d3,%a0
	move.b (%a0,%d0.l),%d0
	ext.w %d0
	ext.l %d0
	move.l _user,%d1
	cmp.l %d0,%d1
	jne .L266
	move.l %d2,%a1
	move.b #1,8(%a1)
	jra .L267
.L266:
	move.l %d2,%a0
	move.b #1,9(%a0)
.L267:
	moveq #10,%d0
	cmp.l 8(%fp),%d0
	jne .L265
	move.l %d2,%a0
	move.l (%a0),%d0
	move.l %d5,-(%sp)
	move.l %d0,-(%sp)
	jsr _strcmp
	addq.l #8,%sp
	tst.l %d0
	jne .L265
	move.l %d2,%a1
	move.b 8(%a1),%d0
	tst.b %d0
	jeq .L265
	move.b #1,-1(%fp)
.L265:
	moveq #10,%d0
	add.l %d0,%d2
.L264:
	move.l %d2,%a0
	move.l (%a0),%d0
	move.l %d0,%a1
	move.b (%a1),%d0
	tst.b %d0
	jne .L268
.L261:
	pea 18.w
	jsr _bdos
	addq.l #4,%sp
	move.l %d0,%d3
.L259:
	cmp.l #255,%d3
	jeq .L269
	tst.b -1(%fp)
	jeq .L270
.L269:
	tst.b -4(%fp)
	jne .L271
	moveq #7,%d0
	cmp.l 8(%fp),%d0
	jne .L272
	pea _msg11
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
.L272:
	move.b #1,_dirflag
	clr.b _load_try
	move.l _cur_disk,%d0
	move.l %d0,-(%sp)
	pea 14.w
	jsr _bdos
	addq.l #8,%sp
	moveq #0,%d0
	jra .L255
.L271:
	moveq #10,%d1
	cmp.l 8(%fp),%d1
	jne .L273
	pea _cmdfcb
	clr.l -(%sp)
	jsr _fill_fcb
	addq.l #8,%sp
	jra .L274
.L273:
	pea _cmdfcb
	pea 1.w
	jsr _fill_fcb
	addq.l #8,%sp
.L274:
	move.l #_load_tbl,%d2
	jra .L275
.L280:
	move.l %d2,%a0
	move.b 8(%a0),%d0
	tst.b %d0
	jne .L276
	move.l %d2,%a1
	move.b 9(%a1),%d0
	tst.b %d0
	jeq .L277
.L276:
	moveq #10,%d0
	cmp.l 8(%fp),%d0
	jeq .L311
.L278:
	move.l %d2,%a0
	move.l (%a0),%d0
	pea .LC7
	move.l %d0,-(%sp)
	jsr _strcmp
	addq.l #8,%sp
	tst.l %d0
	jeq .L312
.L277:
	moveq #10,%d0
	add.l %d0,%d2
.L275:
	move.l %d2,%a0
	move.l (%a0),%d0
	move.l %d0,%a1
	move.b (%a1),%d0
	tst.b %d0
	jne .L280
	jra .L279
.L311:
	nop
	jra .L279
.L312:
	nop
.L279:
	move.l %d2,%a0
	move.l (%a0),%d0
	move.l %d0,%a1
	move.b (%a1),%d0
	tst.b %d0
	jeq .L256
	move.l %d2,%a0
	move.b 8(%a0),%d0
	tst.b %d0
	jne .L281
	clr.l -(%sp)
	pea 32.w
	jsr _bdos
	addq.l #8,%sp
.L281:
	move.l %d2,%a1
	move.l (%a1),%d0
	pea _cmdfcb+9
	move.l %d0,-(%sp)
	jsr _cpy
	addq.l #8,%sp
.L256:
	move.l _cur_disk,%d0
	move.l %d0,-(%sp)
	pea 14.w
	jsr _bdos
	addq.l #8,%sp
.L294:
	pea _cmdfcb
	pea 15.w
	jsr _bdos
	addq.l #8,%sp
	moveq #3,%d1
	cmp.l %d0,%d1
	jcs .L282
	moveq #9,%d4
	jra .L283
.L284:
	move.l #_cmdfcb,%d0
	move.l %d4,%a0
	move.b (%a0,%d0.l),%d0
	move.b %d0,%d1
	and.b #127,%d1
	move.l #_cmdfcb,%d0
	move.l %d4,%a1
	move.b %d1,(%a1,%d0.l)
	addq.l #1,%d4
.L283:
	moveq #11,%d0
	cmp.l %d4,%d0
	jcc .L284
	move.b _cmdfcb+9,%d0
	cmp.b #83,%d0
	jne .L285
	move.b _cmdfcb+10,%d0
	cmp.b #85,%d0
	jne .L285
	move.b _cmdfcb+11,%d0
	cmp.b #66,%d0
	jne .L285
	move.b #1,-3(%fp)
	pea 255.w
	pea 32.w
	jsr _bdos
	addq.l #8,%sp
	move.l %d0,_sub_user
	move.b _submit,%d0
	tst.b %d0
	jeq .L286
	move.b #1,_chain_sub
	jra .L287
.L286:
	move.b #1,_first_sub
.L287:
	moveq #0,%d3
	jra .L288
.L289:
	move.l #_cmdfcb,%d0
	move.l %d3,%a0
	move.b (%a0,%d0.l),%d1
	move.l #_subfcb,%d0
	move.l %d3,%a1
	move.b %d1,(%a1,%d0.l)
	addq.l #1,%d3
.L288:
	moveq #35,%d0
	cmp.l %d3,%d0
	jcc .L289
	moveq #10,%d1
	cmp.l 8(%fp),%d1
	jne .L290
	clr.b _subprompt
.L290:
	move.b #1,_submit
	clr.b _end_of_file
	jra .L313
.L285:
	moveq #7,%d0
	cmp.l 8(%fp),%d0
	jeq .L313
	move.b #1,-2(%fp)
	jra .L313
.L282:
	pea 255.w
	pea 32.w
	jsr _bdos
	addq.l #8,%sp
	tst.l %d0
	jeq .L314
.L293:
	clr.l -(%sp)
	pea 32.w
	jsr _bdos
	addq.l #8,%sp
	jra .L294
.L313:
	nop
	jra .L292
.L314:
	nop
.L292:
	tst.b -2(%fp)
	jeq .L295
	move.l _glb_index,%d0
	move.l %d0,-(%sp)
	jsr _check_cmd
	addq.l #4,%sp
	tst.b -4(%fp)
	jne .L296
	move.l #_load_tbl,%d2
	jra .L297
.L299:
	move.l %d2,%a0
	move.l (%a0),%d0
	pea _cmdfcb+9
	move.l %d0,-(%sp)
	jsr _strcmp
	addq.l #8,%sp
	tst.l %d0
	jeq .L315
.L298:
	moveq #10,%d0
	add.l %d0,%d2
.L297:
	move.l %d2,%a0
	move.l (%a0),%d0
	move.l %d0,%a1
	move.b (%a1),%d0
	tst.b %d0
	jne .L299
	jra .L296
.L315:
	nop
.L296:
	move.l %d2,%a0
	move.l (%a0),%d0
	move.l %d0,%a1
	move.b (%a1),%d0
	tst.b %d0
	jeq .L300
	move.l %d2,%a0
	move.l 4(%a0),-8(%fp)
	jra .L301
.L300:
	move.l #_load68k,-8(%fp)
.L301:
	move.l _glb_index,%d0
	move.l %d0,-(%sp)
	move.l -8(%fp),%d0
	move.l %d0,%a1
	jsr (%a1)
	addq.l #4,%sp
	moveq #2,%d1
	cmp.l %d0,%d1
	jeq .L304
	moveq #3,%d2
	cmp.l %d0,%d2
	jeq .L305
	moveq #1,%d1
	cmp.l %d0,%d1
	jne .L310
.L303:
	pea _lderr1
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
	jra .L295
.L304:
	pea _lderr2
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
	jra .L295
.L305:
	pea _lderr3
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
	jra .L295
.L310:
	pea _lderror
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
.L295:
	tst.b -3(%fp)
	jne .L306
	moveq #7,%d2
	cmp.l 8(%fp),%d2
	jne .L306
	pea _msg11
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
.L306:
	move.l _user,%d0
	move.l %d0,-(%sp)
	pea 32.w
	jsr _bdos
	addq.l #8,%sp
	move.b #1,_dirflag
	clr.b _load_try
	clr.b _morecmds
	tst.b -3(%fp)
	jne .L307
	tst.b -2(%fp)
	jeq .L308
.L307:
	moveq #1,%d0
	jra .L309
.L308:
	moveq #0,%d0
.L309:
.L255:
	movem.l -24(%fp),#60
	unlk %fp
	rts
	.even
	.globl	_sub_read
_sub_read:
	link.w %fp,#0
	pea _subfcb
	pea 20.w
	jsr _bdos
	addq.l #8,%sp
	tst.l %d0
	jeq .L317
	move.b #1,_end_of_file
	moveq #0,%d0
	jra .L318
.L317:
	moveq #1,%d0
.L318:
	unlk %fp
	rts
	.even
	.globl	_dollar
_dollar:
	link.w %fp,#0
	movem.l #16128,-(%sp)
	move.l 8(%fp),%d3
	move.l 12(%fp),%d7
	move.l 16(%fp),%d5
	move.l _sub_index,%d4
	moveq #127,%d0
	cmp.l %d3,%d0
	jcc .L320
	moveq #0,%d3
	jsr _sub_read
	tst.l %d0
	jne .L320
	move.l %d3,%d0
	jra .L321
.L320:
	move.l #_subdma,%d0
	move.l %d3,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #47,%d0
	jle .L322
	move.l #_subdma,%d0
	move.l %d3,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #57,%d0
	jgt .L322
	move.l #_subdma,%d0
	move.l %d3,%a0
	move.b (%a0,%d0.l),%d0
	ext.w %d0
	ext.l %d0
	moveq #-48,%d1
	add.l %d1,%d0
	move.l %d0,%d6
	move.l %d5,%d2
	move.l %d2,%a0
	move.b (%a0),%d0
	cmp.b #83,%d0
	seq %d0
	neg.b %d0
	addq.l #1,%d2
	tst.b %d0
	jeq .L323
	move.l %d2,%a0
	move.b (%a0),%d0
	cmp.b #85,%d0
	seq %d0
	neg.b %d0
	addq.l #1,%d2
	tst.b %d0
	jeq .L323
	move.l %d2,%a0
	move.b (%a0),%d0
	cmp.b #66,%d0
	seq %d0
	neg.b %d0
	addq.l #1,%d2
	tst.b %d0
	jeq .L323
	move.l %d2,%a0
	move.b (%a0),%d0
	cmp.b #77,%d0
	seq %d0
	neg.b %d0
	addq.l #1,%d2
	tst.b %d0
	jeq .L323
	move.l %d2,%a0
	move.b (%a0),%d0
	cmp.b #73,%d0
	seq %d0
	neg.b %d0
	addq.l #1,%d2
	tst.b %d0
	jeq .L323
	move.l %d2,%a0
	move.b (%a0),%d0
	cmp.b #84,%d0
	seq %d0
	neg.b %d0
	addq.l #1,%d2
	tst.b %d0
	jeq .L323
	move.l %d2,%a0
	move.b (%a0),%d0
	cmp.b #32,%d0
	jne .L323
	addq.l #1,%d6
.L323:
	move.l %d5,%d2
	moveq #1,%d5
	jra .L324
.L327:
	addq.l #1,%d2
	jra .L325
.L338:
	nop
.L325:
	move.l %d2,%a0
	move.b (%a0),%d0
	cmp.b #32,%d0
	jeq .L326
	move.l %d2,%a0
	move.b (%a0),%d0
	tst.b %d0
	jne .L327
.L326:
	move.l %d2,%a0
	move.b (%a0),%d0
	cmp.b #32,%d0
	jne .L328
	addq.l #1,%d2
.L328:
	addq.l #1,%d5
.L324:
	cmp.l %d5,%d6
	jcc .L338
	jra .L330
.L333:
	moveq #1,%d0
	cmp.l %d7,%d0
	jne .L331
	move.l %d2,%a0
	move.b (%a0),%d1
	move.l #_subcom,%d0
	move.l %d4,%a0
	move.b %d1,(%a0,%d0.l)
	addq.l #1,%d4
	addq.l #1,%d2
	jra .L330
.L331:
	move.l %d2,%a0
	move.b (%a0),%d0
	ext.w %d0
	ext.l %d0
	addq.l #1,%d2
	move.l %d0,-(%sp)
	pea 2.w
	jsr _bdos
	addq.l #8,%sp
.L330:
	move.l %d2,%a0
	move.b (%a0),%d0
	cmp.b #32,%d0
	jeq .L332
	move.l %d2,%a0
	move.b (%a0),%d0
	tst.b %d0
	jeq .L332
	moveq #127,%d0
	cmp.l %d4,%d0
	jcc .L333
.L332:
	addq.l #1,%d3
	jra .L334
.L322:
	moveq #1,%d1
	cmp.l %d7,%d1
	jne .L335
	move.l #_subcom,%d0
	move.l %d4,%a0
	move.b #36,(%a0,%d0.l)
	addq.l #1,%d4
	jra .L336
.L335:
	pea 36.w
	pea 2.w
	jsr _bdos
	addq.l #8,%sp
.L336:
	move.l #_subdma,%d0
	move.l %d3,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #36,%d0
	jne .L334
	addq.l #1,%d3
.L334:
	move.l %d4,_sub_index
	moveq #127,%d0
	cmp.l %d3,%d0
	jcc .L337
	moveq #0,%d3
	jsr _sub_read
.L337:
	move.l %d3,%d0
.L321:
	movem.l -24(%fp),#252
	unlk %fp
	rts
	.even
	.globl	_comments
_comments:
	link.w %fp,#0
	movem.l #14336,-(%sp)
	move.l 8(%fp),%d2
	move.l 12(%fp),%d4
	moveq #0,%d3
	jsr _prompt
	jra .L340
.L343:
	move.l #_subdma,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #36,%d0
	jne .L341
	addq.l #1,%d2
	move.l %d4,-(%sp)
	clr.l -(%sp)
	move.l %d2,-(%sp)
	jsr _dollar
	lea (12,%sp),%sp
	move.l %d0,%d2
	jra .L340
.L341:
	move.l #_subdma,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	ext.w %d0
	ext.l %d0
	addq.l #1,%d2
	move.l %d0,-(%sp)
	pea 2.w
	jsr _bdos
	addq.l #8,%sp
.L340:
	moveq #127,%d0
	cmp.l %d2,%d0
	jcs .L342
	move.l #_subdma,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #26,%d0
	jeq .L342
	move.l #_subdma,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #13,%d0
	jne .L343
.L342:
	cmp.l #128,%d2
	jne .L344
	move.l #_subdma,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #26,%d0
	jeq .L344
	move.l #_subdma,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #13,%d0
	jeq .L344
	moveq #0,%d2
	jsr _sub_read
	tst.l %d0
	jne .L346
	moveq #1,%d3
	jra .L346
.L344:
	move.l #_subdma,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #13,%d0
	jne .L347
	addq.l #2,%d2
	moveq #127,%d0
	cmp.l %d2,%d0
	jcc .L348
	moveq #0,%d2
	jsr _sub_read
	jra .L348
.L347:
	move.b #1,_end_of_file
.L348:
	moveq #1,%d3
.L346:
	tst.l %d3
	jeq .L340
	move.l %d2,%d0
	movem.l -12(%fp),#28
	unlk %fp
	rts
	.even
	.globl	_translate
_translate:
	link.w %fp,#0
	movem.l #14336,-(%sp)
	move.l 8(%fp),%d4
	moveq #0,%d3
	move.l _sub_index,%d2
	jra .L351
.L366:
	move.l #_subdma,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	ext.w %d0
	ext.l %d0
	moveq #-9,%d1
	add.l %d1,%d0
	moveq #50,%d1
	cmp.l %d0,%d1
	jcs .L352
	add.l %d0,%d0
	move.w .L358(%pc,%d0.l),%d0
	jmp %pc@(2,%d0:w)
.L358:
	.word .L353-.L358
	.word .L354-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L355-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L353-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L356-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L352-.L358
	.word .L357-.L358
.L357:
	move.l %d4,-(%sp)
	move.l %d2,-(%sp)
	jsr _comments
	addq.l #8,%sp
	move.l %d0,%d2
	jra .L351
.L353:
	tst.l %d3
	jeq .L360
	move.l #_subdma,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d1
	move.l #_subcom,%d0
	move.l %d3,%a0
	move.b %d1,(%a0,%d0.l)
	addq.l #1,%d3
	addq.l #1,%d2
	jra .L360
.L375:
.L359:
	jra .L360
.L362:
	addq.l #1,%d2
.L360:
	moveq #127,%d0
	cmp.l %d2,%d0
	jcs .L361
	move.l #_subdma,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #32,%d0
	jeq .L362
	move.l #_subdma,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #9,%d0
	jeq .L362
.L361:
	moveq #127,%d0
	cmp.l %d2,%d0
	jcc .L376
	moveq #0,%d2
	jsr _sub_read
	tst.l %d0
	jeq .L376
	jra .L375
.L356:
	addq.l #1,%d2
	move.l %d3,_sub_index
	move.l %d4,-(%sp)
	pea 1.w
	move.l %d2,-(%sp)
	jsr _dollar
	lea (12,%sp),%sp
	move.l %d0,%d2
	move.l _sub_index,%d3
	jra .L351
.L354:
	addq.l #1,%d2
	moveq #127,%d1
	cmp.l %d2,%d1
	jcc .L377
	moveq #0,%d2
	jsr _sub_read
	jra .L377
.L355:
	move.b #1,_end_of_file
	jra .L351
.L352:
	move.l #_subdma,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d1
	move.l #_subcom,%d0
	move.l %d3,%a0
	move.b %d1,(%a0,%d0.l)
	addq.l #1,%d3
	addq.l #1,%d2
	moveq #127,%d0
	cmp.l %d2,%d0
	jcc .L351
	moveq #0,%d2
	jsr _sub_read
	jra .L351
.L376:
	nop
	jra .L351
.L377:
	nop
.L351:
	move.b _end_of_file,%d0
	tst.b %d0
	jne .L365
	moveq #127,%d1
	cmp.l %d3,%d1
	jcs .L365
	move.l #_subdma,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #13,%d0
	jeq .L365
	move.l #_subdma,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #33,%d0
	jne .L366
.L365:
	move.l #_subdma,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #13,%d0
	jeq .L369
	move.l #_subdma,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #33,%d0
	jne .L368
	jra .L369
.L378:
	nop
.L367:
	jra .L369
.L371:
	addq.l #1,%d2
.L369:
	moveq #127,%d0
	cmp.l %d2,%d0
	jcs .L370
	move.l #_subdma,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #13,%d0
	jeq .L371
	move.l #_subdma,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #10,%d0
	jeq .L371
	move.l #_subdma,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #33,%d0
	jeq .L371
.L370:
	cmp.l #128,%d2
	jne .L372
	moveq #0,%d2
	jsr _sub_read
	tst.l %d0
	jne .L378
	jra .L368
.L372:
	move.l #_subdma,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #26,%d0
	jne .L379
	move.b #1,_end_of_file
.L379:
	nop
.L368:
	move.l %d2,_sub_index
	movem.l -12(%fp),#28
	unlk %fp
	rts
	.even
	.globl	_submit_cmd
_submit_cmd:
	link.w %fp,#0
	movem.l #14336,-(%sp)
	move.l 8(%fp),%d4
	moveq #0,%d2
	jra .L381
.L382:
	move.l #_subcom,%d0
	move.l %d2,%a0
	clr.b (%a0,%d0.l)
	addq.l #1,%d2
.L381:
	cmp.l #128,%d2
	jls .L382
	pea 255.w
	pea 32.w
	jsr _bdos
	addq.l #8,%sp
	move.l %d0,%d3
	move.l _sub_user,%d0
	move.l %d0,-(%sp)
	pea 32.w
	jsr _bdos
	addq.l #8,%sp
	pea _subdma
	pea 26.w
	jsr _bdos
	addq.l #8,%sp
	move.b _first_sub,%d0
	tst.b %d0
	jne .L383
	move.b _chain_sub,%d0
	tst.b %d0
	jeq .L384
.L383:
	moveq #0,%d2
	jra .L385
.L386:
	move.l #_subdma,%d0
	move.l %d2,%a0
	clr.b (%a0,%d0.l)
	addq.l #1,%d2
.L385:
	moveq #127,%d0
	cmp.l %d2,%d0
	jcc .L386
	jsr _sub_read
	clr.l _sub_index
.L384:
	move.b _end_of_file,%d0
	tst.b %d0
	jne .L387
	move.l %d4,-(%sp)
	jsr _translate
	addq.l #4,%sp
.L387:
	moveq #0,%d2
	jra .L388
.L391:
	move.l #_subcom,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #96,%d0
	jle .L389
	move.l #_subcom,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #122,%d0
	jgt .L389
	move.l #_subcom,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	add.b #-32,%d0
	jra .L390
.L389:
	move.l #_subcom,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
.L390:
	move.l #_subcom,%d1
	move.l %d2,%a0
	move.b %d0,(%a0,%d1.l)
	addq.l #1,%d2
.L388:
	moveq #127,%d0
	cmp.l %d2,%d0
	jcc .L391
	pea _dma
	pea 26.w
	jsr _bdos
	addq.l #8,%sp
	move.l %d3,%d0
	move.l %d0,-(%sp)
	pea 32.w
	jsr _bdos
	addq.l #8,%sp
	movem.l -12(%fp),#28
	unlk %fp
	rts
	.even
	.globl	_execute_cmd
_execute_cmd:
	link.w %fp,#0
	move.l %d3,-(%sp)
	move.l %d2,-(%sp)
	move.l 8(%fp),%d0
	move.l %d0,-(%sp)
	jsr _decode
	addq.l #4,%sp
	moveq #9,%d1
	cmp.l %d0,%d1
	jcs .L393
	add.l %d0,%d0
	move.w .L403(%pc,%d0.l),%d0
	jmp %pc@(2,%d0:w)
.L403:
	.word .L394-.L403
	.word .L395-.L403
	.word .L396-.L403
	.word .L397-.L403
	.word .L398-.L403
	.word .L399-.L403
	.word .L400-.L403
	.word .L393-.L403
	.word .L401-.L403
	.word .L402-.L403
.L394:
	clr.l -(%sp)
	jsr _dir_cmd
	addq.l #4,%sp
	jra .L414
.L402:
	pea 1.w
	jsr _dir_cmd
	addq.l #4,%sp
	jra .L414
.L395:
	jsr _type_cmd
	jra .L414
.L396:
	jsr _ren_cmd
	jra .L414
.L397:
	jsr _era_cmd
	jra .L414
.L398:
	jsr _user_cmd
	tst.l %d0
	jne .L415
	pea _msg12
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
	jra .L415
.L399:
	move.b _parm,%d0
	ext.w %d0
	ext.l %d0
	moveq #-65,%d1
	add.l %d1,%d0
	move.l %d0,-(%sp)
	pea 14.w
	jsr _bdos
	addq.l #8,%sp
	jra .L414
.L400:
	moveq #7,%d3
	move.b _parm+26,%d0
	tst.b %d0
	jne .L406
	pea _msg2
	pea 9.w
	jsr _bdos
	addq.l #8,%sp
	pea 127.w
	pea _subdma
	jsr _get_cmd
	addq.l #8,%sp
	moveq #0,%d2
	jra .L407
.L409:
	move.l #_subdma,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d1
	move.l #_parm+26,%d0
	move.l %d2,%a0
	move.b %d1,(%a0,%d0.l)
	addq.l #1,%d2
.L407:
	move.l #_subdma,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #32,%d0
	jeq .L408
	move.l #_subdma,%d0
	move.l %d2,%a0
	move.b (%a0,%d0.l),%d0
	tst.b %d0
	jeq .L408
	moveq #24,%d0
	cmp.l %d2,%d0
	jcc .L409
.L408:
	move.l #_parm+26,%d0
	move.l %d2,%a0
	clr.b (%a0,%d0.l)
	tst.l %d2
	jeq .L416
	move.b #1,_subprompt
	jra .L412
.L406:
	clr.b _subprompt
	jra .L412
.L401:
	moveq #10,%d3
.L412:
	move.l %d3,-(%sp)
	jsr _cmd_file
	addq.l #4,%sp
	tst.l %d0
	jne .L417
.L413:
	moveq #7,%d0
	cmp.l %d3,%d0
	jeq .L418
.L393:
	clr.l -(%sp)
	pea _parm
	jsr _echo_cmd
	addq.l #8,%sp
	jra .L414
.L415:
	nop
	jra .L414
.L416:
	nop
	jra .L414
.L417:
	nop
	jra .L414
.L418:
	nop
.L414:
	move.l -8(%fp),%d2
	move.l -4(%fp),%d3
	unlk %fp
	rts
	.even
	.globl	_main
_main:
	link.w %fp,#0
	move.l %d2,-(%sp)
	jsr ___main
	move.b #1,_dirflag
	pea _dma
	pea 26.w
	jsr _bdos
	addq.l #8,%sp
	move.b _load_try,%d0
	tst.b %d0
	jeq .L420
	move.l _cur_disk,%d0
	move.l %d0,-(%sp)
	pea 14.w
	jsr _bdos
	addq.l #8,%sp
	move.l _user,%d0
	move.l %d0,-(%sp)
	pea 32.w
	jsr _bdos
	addq.l #8,%sp
	clr.b _load_try
.L420:
	move.b _morecmds,%d0
	tst.b %d0
	jeq .L421
	move.b _submit,%d0
	tst.b %d0
	jeq .L422
	move.l #_subcom,%d2
	pea _save_sub
	jsr _submit_cmd
	addq.l #4,%sp
	jra .L423
.L426:
	move.b _end_of_file,%d0
	tst.b %d0
	jeq .L424
	move.l _user_ptr,%d2
	clr.b _submit
	nop
	jra .L427
.L424:
	pea _save_sub
	jsr _submit_cmd
	addq.l #4,%sp
.L423:
	move.l %d2,%a0
	move.b (%a0),%d0
	tst.b %d0
	jeq .L426
	jra .L427
.L422:
	move.l _user_ptr,%d2
.L427:
	clr.b _morecmds
	move.l %d2,%a0
	move.b (%a0),%d0
	tst.b %d0
	jeq .L444
	pea 1.w
	move.l %d2,-(%sp)
	jsr _echo_cmd
	addq.l #8,%sp
	jra .L444
.L421:
	jsr _prompt
	move.l #_usercmd,%d2
	move.b _autost,%d0
	tst.b %d0
	jeq .L429
	move.b _autorom,%d0
	tst.b %d0
	jeq .L429
	pea 1.w
	pea _usercmd
	jsr _echo_cmd
	addq.l #8,%sp
	clr.b _autorom
	jra .L444
.L429:
	pea 128.w
	pea _usercmd
	jsr _get_cmd
	addq.l #8,%sp
	jra .L444
.L443:
	move.l %d2,_glb_index
	move.l %d2,-(%sp)
	jsr _get_parms
	addq.l #4,%sp
	move.b _parm,%d0
	tst.b %d0
	jeq .L431
	move.b _parm,%d0
	cmp.b #59,%d0
	jeq .L431
	pea _parm
	jsr _execute_cmd
	addq.l #4,%sp
.L431:
	move.b _submit,%d0
	tst.b %d0
	jne .L432
	move.l %d2,-(%sp)
	jsr _scan_cmd
	addq.l #4,%sp
	move.l %d0,%d2
	jra .L433
.L432:
	move.l #_subcom,%d2
	move.b _first_sub,%d0
	tst.b %d0
	jne .L434
	move.b _chain_sub,%d0
	tst.b %d0
	jeq .L435
.L434:
	move.b _subprompt,%d0
	tst.b %d0
	jeq .L436
	pea _subdma
	jsr _copy_cmd
	addq.l #4,%sp
	jra .L437
.L436:
	move.l _glb_index,%d0
	move.l %d0,-(%sp)
	jsr _copy_cmd
	addq.l #4,%sp
.L437:
	move.b _first_sub,%d0
	tst.b %d0
	jeq .L438
	move.l _glb_index,%d0
	move.l %d0,-(%sp)
	jsr _scan_cmd
	addq.l #4,%sp
	move.l %d0,_user_ptr
.L438:
	pea _save_sub
	jsr _submit_cmd
	addq.l #4,%sp
	clr.b _chain_sub
	move.b _chain_sub,%d0
	move.b %d0,_first_sub
	jra .L440
.L435:
	move.l %d2,%a0
	clr.b (%a0)
	jra .L440
.L442:
	move.b _end_of_file,%d0
	tst.b %d0
	jeq .L441
	move.l _user_ptr,%d2
	clr.b _submit
	jra .L433
.L441:
	pea _save_sub
	jsr _submit_cmd
	addq.l #4,%sp
.L440:
	move.l %d2,%a0
	move.b (%a0),%d0
	tst.b %d0
	jeq .L442
.L433:
	move.l %d2,%a0
	move.b (%a0),%d0
	tst.b %d0
	jeq .L430
	pea 1.w
	move.l %d2,-(%sp)
	jsr _echo_cmd
	addq.l #8,%sp
	jra .L430
.L444:
	nop
.L430:
	move.l %d2,%a0
	move.b (%a0),%d0
	tst.b %d0
	jne .L443
	move.l -4(%fp),%d2
	unlk %fp
	rts
