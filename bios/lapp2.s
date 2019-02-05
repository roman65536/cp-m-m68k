# 1 "lapp2.S"
# 1 "<built-in>"
# 1 "<command line>"
# 1 "lapp2.S"
# 11 "lapp2.S"

.globl mmain , _chbo , _chbi,_chbt

Rom = 0x00000


RAM	= 0xff000000
Duart 	= 0x40000000
duart = Duart
io 	= 0x80000000


.text
               .long 0xff0ffff2
               .long start
		ds.l 1024

.globl start
start: 	
		moveal #RAM,a0
		moveb #0x55,RAM
		moveb #0xaa,RAM+1
		nop
		movel (a0)+,d0
		movel (a0)+,d0
		movel (a0)+,d0
		movel (a0)+,d0
		movel (a0)+,d0
		movel (a0)+,d0
		movel (a0)+,d0
		movel (a0)+,d0
		movel (a0)+,d0
		nop
		nop
		nop
		movel #1,d0
		movec d0,cacr
#		bra loop

ram_test:
		moveal #RAM,a0
ram_loop:	cmpal #0xff1ffc00,a0
		beq loop
		movel #0xa55aa55a,(a0)
		movel (a0),d0
		cmpil #0xa55aa55a,d0
		bne ram_fail
		addql #4,a0
		bra ram_loop
ram_fail:	moveb #1,0x4000000e
		moveb #1,0x4000000f
		addql #1,a0
		bra ram_loop
			

loop:
               moveal #RAM,a0
               .word 0x4e7b
               .word 0x8801             /* movec vbr */
		bsr _dinit
		moveal #mte2,a0
                bsr ztext
		jsr  mmain
		bral  loop




_dinit:        moveal #duart,a0
               moveb #0,a0@(0x4)
               moveb #0xcc,d0
dine:          moveb d0,a0@(0x09)   /*Rate-> baud chB */
               moveb #0x13,a0@(0x8)  /*8 bit  */
               moveb #0x0f,a0@(0x8)  /*2 stop bit */
               moveb #0x15,a0@(0xa)      /*reset mr to mr1 */

               moveb #0xcc,a0@(0x01) /*receive 300 transmit 9600 */
               moveb #0x13,a0@        /*8 bit */
               moveb #0x0f,a0@        /*2 stop bit */
               moveb #0x15,a0@(0x02)       /*enable tr. + rc. */
               rts


_chbo:         moveml a0,a7@-
               moveal #duart,a0
chbtst:        
	       btst #2,a0@(0x09)
               beq chbtst
               moveb d0,a0@(0xb)
               moveml a7@+,a0
               rts

_chbi:         moveml a0,a7@-
               moveal #duart,a0
chbits:        btst #0,a0@(0x09)
               beq chbits
               moveb a0@(0xb),d0
               moveml a7@+,a0
               rts

_chbt:         moveml a0,a7@-
               moveal #duart,a0
               btst #0,a0@(0x09)
               seq d0                  /*if not ready 0xff in d0 */
               moveml a7@+,a0
               rts

_chao:         moveml a0,a7@-
               moveal #duart,a0
chatst:        btst #2,a0@(0x1)
               beq chatst
               moveb d0,a0@(0x03)
               moveml a7@+,a0
               rts

_chai:         moveml a0,a7@-
               moveal #duart,a0
chaits:        btst #0,a0@(0x1)
               beq chaits
               moveb a0@(0x03),d0
               andib #0x7f,d0
               moveml a7@+,a0
               rts

_chat:         moveml a0,a7@-
               moveal #duart,a0
               btst #0,a0@(0x01)
               seq d0
               moveml a7@+,a0
               rts

ztext:         moveb a0@+,d0
               cmpb #0,d0
               beq zend
               bsr _chbo
               bra ztext

zend:          rts






mte2:     .byte 0x0a,0x0d
         .ascii  "Pollak Software c2005 68020 Dram"
         .byte  0x0a,0x0d,0x00

mte3:	.ascii "Trap #0 \n\r"
	.byte 0x00

.even

