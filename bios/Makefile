include make.inc

SRC = lapp2.s main.c biosa.s bios.c printf.c doprnt.c getc.s strlen.c string.c ctype_.c vsprintf.c memchr.c memcmp.c ide.c
#SRC = test.s task.c
#
OBJ = lapp2.o main.o biosa.o bios.o printf.o doprnt.o getc.o strlen.o string.o ctype_.o vsprintf.o memchr.o memcmp.o ide.o
#OBJ = test.o task.o

#SRC = test2.s 
#OBJ = test2.o 

.c.s:
	$(CC) $(CFLAGS) -S $< -o $@

.c.o:
	$(CC) $(CFLAGS) -I. -c $< -o $@

.S.o:
	$(CC) -o $@ $<

.s.o:
	$(AS) -o $@ $<

all:	$(OBJ)
#	$(LD) -o cur.exe $(OBJ) -Ttext 0x81000 -L./debug -ldebug -L./lib -lc
#	$(LD) -o cur20.exe $(OBJ) -T link.cmd -L./libc  -L./waba/vm -lwaba -lc
#	$(CC)  -o cur20.srec $(OBJ) -T link2.cmd -L./libc -L./fs -L./fs/ext2 -L./fs/isofs -lfs -lext2 -lisofs -lc
#	$(LD)  -o cur21.elf $(OBJ) -T link2.cmd -L./libc -L./debug -L./fs -L./fs/ext2 -lfs -lext2 -ldebug -lc -L/mnt/romanp/oldlap/m68k/gcc-3.3.2/gcc -lgcc
#	$(LD)  -o cur21.exec $(OBJ) -T link2.cmd -L./libc -L./debug -L./fs -L./fs/ext2 -lfs -lext2 -ldebug -lc -L/usr/local/lib/gcc/m68k-atari-mint/4.6.4/ 
	$(LD)  -o cur21.exec $(OBJ) -T link2.cmd -L../ -lcpm 
#	$(LD)  -o cur21.exec $(OBJ)  -L./libc -L./debug -L./fs -L./fs/ext2 -lfs -lext2 -ldebug -lc -L/usr/local/lib/gcc/m68k-atari-mint/4.6.4/ 
#	$(LD)  -o cur20.elf $(OBJ) -T link2.cmd -L./libc -lc 
#	$(LD) -o cur20.coff $(OBJ) -Ttext 0x81000
#	$(EXEC) cur.exe >out
#	$(CC) -S -m68040 -O3 -ffast-math VTrans.c

#$(OBJ):	$(SRC)

libc:		libc/libc.a
		make -C libc


clean:	
	rm $(OBJ) libc.a 
