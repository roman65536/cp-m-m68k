EXE  = cur.exe
OUT  = out
#OSHOME=/home/romanp/MyProgram/prg/m68k/20_dram_fs
CFLAGS = -m68020 -Os  -finline-functions -fno-builtin -nostdinc 

#MYBIN   = /home/roman/5200
MYBIN   = m68k-elf-
#MYBIN   = m68k-atari-mint-

CC      = $(MYBIN)gcc
LD      = $(MYBIN)ld
AR      = $(MYBIN)ar
AS      = $(MYBIN)as -m68020 --register-prefix-optional
GS      = m68k-coff-gasp
RM      = rm
 
