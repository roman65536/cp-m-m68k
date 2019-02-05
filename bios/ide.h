#define	HD	0x80000000
#define DATA	(HD+0x10)
#define ERR	(HD+0x02)
#define SECC	(HD+0x04)
#define SEC	(HD+0x06)
#define CYL	(HD+0x08)
#define CYH	(HD+0x0a)
#define HED	(HD+0x0c)
#define COM	(HD+0x0e)

#define WRITE_HD(a,b) *(volatile unsigned char *) a= (char )b
#define WRITE_HDDATA(a,b) *(volatile unsigned short *) a= (unsigned short) b
#define READ_HD(a)  *(volatile unsigned char *) a
#define READ_HDDATA(a)  *(volatile unsigned short *) a

#define HD_READ_COM	0x20
#define HD_WRITE_COM	0x30
#define HD_IDENT_COM	0xec
#define HD_SETMUL_COM	0xc6
#define HD_READM_COM	0xc4
#define HD_WRITEM_COM	0xc5
#define HD_DIAG_COM	0x90




