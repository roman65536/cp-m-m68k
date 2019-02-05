/* Linker-Commandfile for SH7000 GNU Linker 
   P.Graf 1996
*/ 

/*OUTPUT_FORMAT(binary) */
/* OUTPUT_FORMAT(srec)  */

ENTRY(start)

MEMORY
{
  ROM :  org = 0x00000000 , l = 128K   /* ROM 27C1024   */
  RAM :  org = 0xff001000 , l = 2048K /* DRAM SIMM 4MB */
}

/* Section Names
     .vector  Vectortable
     .text    Instructions and read-only data
     .data    initialized writable assembler data
     .bss     global and static variables
     .stack   System Stack
     
   Expressions
     *(section) Refer to all input files
     >region    Assign to region defined with MEMORY 
*/


SECTIONS
{


  .text : 
    { _text_start = .; 
	KEEP(*(.text*)); 
	*(.rodata*); 
	*(.rodata1*); 
	*(.init); 
	*(.fini); 
	*(.eh_frame); 
 	KEEP (*crtbegin*.o(.ctors))
	KEEP (*(EXCLUDE_FILE (*crtend*.o ) .ctors))
	KEEP (*(SORT(.ctors.*)))
	KEEP (*(.ctors))
	KEEP (*crtbegin*.o(.dtors))
	KEEP (*(EXCLUDE_FILE (*crtend*.o ) .dtors))
	KEEP (*(SORT(.dtors.*)))
	KEEP (*(.dtors))

	*(.jcr);  . = ALIGN(4); _text_end = .; }  >ROM




/*
  .rodata :
    { *(.rodata*); . = ALIGN(4) ; } >ROM
  .rodata1 :
    { *(.rodata1*); . = ALIGN(4) ; } >ROM

  .mdata :  AT ( ADDR(.text) + SIZEOF( .text))
    { _data_start = .; *(.data); . = ALIGN(4); _data_end = .; } >RAM
*/

 
  .mdata :  AT (_text_end )
    { _data_start = .; *(.data); . = ALIGN(4); _data_end = .; } >RAM

  .bss (NOLOAD) :          
    { _bss_start = .; *(.bss); *(COMMON); . = ALIGN(4); _bss_end = .; } >RAM

  .stack (NOLOAD) :
    { _stack_start = .; . += 16384; *(.stack); _stack_end = .; } >RAM
}
