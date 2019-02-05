CC=m68k-elf-gcc
AS=m68k-elf-as

CFLAGS= -m68020 -Os  -finline-functions -fno-builtin -nostdinc 


SRC= bdosmain.c  bdosmisc.c	bdosrw.c  ccp.c  conbdos.c  dskutil.c  fileio.c  iosys.c bdosif.s  ccpbdos.s  ccpif.s  ccpload.s  exceptn.s  filetyps.s  pgmld2.s  stack.s

OBJ= bdosmain.o  bdosmisc.o	bdosrw.o  ccp.o  conbdos.o  dskutil.o  fileio.o  iosys.o bdosif.o  ccpbdos.o  ccpif.o  ccpload.o  exceptn.o  filetyps.o  pgmld2.o  stack.o


.c.o:
	$(CC) $(CFLAGS) -c $< -o $@


.s.o:
	$(AS) -o $@ $<


$(OBJ):		$(SRC)

all:	$(OBJ)
	m68k-elf-ar ru libcpm.a $(OBJ)
