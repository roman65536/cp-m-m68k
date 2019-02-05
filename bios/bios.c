/*=======================================================================*/
/*/---------------------------------------------------------------------\*/
/*|									|*/
/*|     CP/M-68K(tm) BIOS for the EXORMACS 				|*/
/*|									|*/
/*|     Copyright 1983, Digital Research.				|*/
/*|									|*/
/*|	Modified 9/ 7/82 wbt						|*/
/*|		10/ 5/82 wbt						|*/
/*|		12/15/82 wbt						|*/
/*|		12/22/82 wbt						|*/
/*|		 1/28/83 wbt						|*/
/*|									|*/
/*\---------------------------------------------------------------------/*/
/*=======================================================================*/

#include "biostype.h"	/* defines LOADER : 0-> normal bios, 1->loader bios */
			/* also defines CTLTYPE 0 -> Universal Disk Cntrlr  */
			/*			1 -> Floppy Disk Controller */
			/* MEMDSK: 0 -> no memory disk			    */
			/*	   4 -> 384K memory disk		    */

#include "biostyps.h"	/* defines portable variable types */

char copyright[] = "Copyright 1983, Digital Research";

struct memb { BYTE byte; };	/* use for peeking and poking memory */
struct memw { WORD word; };
struct meml { LONG lword;};


/************************************************************************/ 
/*      I/O Device Definitions						*/
/************************************************************************/


/************************************************************************/ 
/*      Define the two serial ports on the DEBUG board			*/
/************************************************************************/

/* Port Addresses */

#define PORT1 0xFFEE011	/* console port */
#define PORT2 0xFFEE015 /* debug port   */
 
/* Port Offsets */

#define PORTCTRL 0	/* Control Register */
#define PORTSTAT 0	/* Status  Register */
#define PORTRDR  2	/* Read  Data Register */
#define PORTTDR  2	/* Write Data Register */

/* Port Control Functions */
 
#define PORTRSET 3	/* Port Reset */
#define PORTINIT 0x11	/* Port Initialize */

/* Port Status Values */
 
#define PORTRDRF 1	/* Read  Data Register Full */
#define PORTTDRE 2	/* Write Data Register Empty */
 

/************************************************************************/
/* Define Disk I/O Addresses and Related Constants			*/
/************************************************************************/

#define DSKIPC		0xFF0000	/* IPC Base Address */

#define DSKINTV		0x3FC		/* Address of Disk Interrupt Vector */

#define INTTOIPC	0xD		/* offsets in mem mapped io area */
#define RSTTOIPC	0xF
#define MSGTOIPC	0x101
#define ACKTOIPC	0x103
#define	PKTTOIPC	0x105
#define	MSGFMIPC	0x181
#define ACKFMIPC	0x183
#define PKTFMIPC	0x185

#define DSKREAD		0x10		/* disk commands */
#define DSKWRITE	0x20

/* Some characters used in disk controller packets */

#define	STX	0x02
#define ETX	0x03
#define	ACK	0x06
#define NAK	0x15

#define PKTSTX		0x0		/* offsets within a disk packet */
#define PKTID		0x1
#define PKTSZ		0x2
#define PKTDEV		0x3
#define PKTCHCOM	0x4
#define PKTSTCOM	0x5
#define	PKTSTVAL	0x6
#define PKTSTPRM	0x8
#define	STPKTSZ		0xf


/************************************************************************/
/* BIOS  Table Definitions						*/
/************************************************************************/

/* Disk Parameter Block Structure */

struct dpb
{
	UWORD	spt;
	UBYTE	bsh;
	UBYTE	blm;
	UBYTE	exm;
	UBYTE	dpbjunk;
	UWORD	dsm;
	UWORD	drm;
	UBYTE	al0;
	UBYTE	al1;
	UWORD	cks;
	UWORD	off;
};


/* Disk Parameter Header Structure */

struct dph
{
	UBYTE	*xltp;
  /*
	UWORD	 dphscr[3];
  */
        UWORD	hiwater;	/* high water mark for this disk	*/
	UWORD	dum1;		/* dummy (unused)			*/
	UWORD	dum2;
	UBYTE	*dirbufp;
struct	dpb	*dpbp;
	UBYTE	*csvp;
	UBYTE	*alvp;
};



/************************************************************************/
/*	Directory Buffer for use by the BDOS				*/
/************************************************************************/

BYTE dirbuf[128];

#if ! LOADER

/************************************************************************/
/*	CSV's								*/
/************************************************************************/

BYTE	csv0[1024];
BYTE	csv1[16];

#if ! CTLTYPE

BYTE	csv2[256];
BYTE	csv3[256];

#endif

#if	MEMDSK
BYTE	csv4[16];
#endif

/************************************************************************/
/*	ALV's								*/
/************************************************************************/

BYTE	alv0[1024];	/* (dsm0 / 8) + 1	*/
BYTE	alv1[32];	/* (dsm1 / 8) + 1	*/

#if ! CTLTYPE

BYTE	alv2[412];	/* (dsm2 / 8) + 1	*/
BYTE	alv3[412];	/* (dsm2 / 8) + 1	*/

#endif

#if	MEMDSK
BYTE	alv4[48];	/* (dsm4 / 8) + 1	*/
#endif

#endif
 
/************************************************************************/
/*	Disk Parameter Blocks						*/
/************************************************************************/

/* The following dpb definitions express the intent of the writer,	*/
/* unfortunately, due to a compiler bug, these lines cannot be used.	*/
/* Therefore, the obscure code following them has been inserted.	*/

/*************    spt, bsh, blm, exm, jnk,   dsm,  drm,  al0, al1, cks, off */

#ifdef BULLSHIT
struct dpb dpb0 = { 32,   5,   31,   0,   0,   242,   1023,    0,   0,  16,   1};

#if ! CTLTYPE
struct dpb dpb2 = { 32,   5,  31,   1,   0,  3288, 1023,     0,  0, 256,   4};
#endif

#if   MEMDSK
//struct dpb dpb3 = { 32,   4,  15,   0,   0,   191,   63,    0,   0,  0,   0};
#endif
#endif
/*********** end of readable definitions  *************/
/* The Alcyon C compiler assumes all structures are arrays of int, so 	*/
/* in the following definitions, adjacent pairs of chars have been 	*/
/* combined into int constants --- what a kludge!  **********************/
//struct dpb dpb0 = {  32,  775,   0,   242,   63, -16384,  16, 2 };

struct dpb dpb0 = { 4,   4,   15,   0,   0,   16384,   1023,    0,   0,  256,   1};

#if ! CTLTYPE
struct dpb dpb2 = {  32, 1311, 256,  3288, 1023, 0xFF00, 256, 4 };
#endif
#if   MEMDSK
struct dpb dpb3 = {  32, 1039,   0,   191,   63,      0,  0, 0 };
/*************** End of kludge *****************/
#endif

/************************************************************************/
/* Sector Translate Table for Floppy Disks				*/ 
/************************************************************************/


BYTE	xlt[26] = {  1,  7, 13, 19, 25,  5, 11, 17, 23,  3,  9, 15, 21,
		     2,  8, 14, 20, 26,  6, 12, 18, 24,  4, 10, 16, 22 };



 
/************************************************************************/
/* Disk Parameter Headers						*/
/*									*/
/* Four disks are defined : dsk a: diskno=0, (Motorola's #fd04)		*/
/* if CTLTYPE = 0	  : dsk b: diskno=1, (Motorola's #fd05)		*/
/*			  : dsk c: diskno=2, (Motorola's #hd00)		*/
/*			  : dsk d: diskno=3, (Motorola's #hd01)		*/
/*									*/
/* Two disks are defined  : dsk a: diskno=0, (Motorola's #fd00)		*/
/* if CTLTYPE = 1	  : dsk b: diskno=1, (Motorola's #fd01)		*/
/*									*/
/************************************************************************/

#if ! LOADER

/* Disk Parameter Headers */
struct dph dphtab[] =

		{ {0L, 0, 0, 0, dirbuf, &dpb0, csv0, alv0}, /*dsk a*/
		  {0L, 0, 0, 0, dirbuf, &dpb0, csv1, alv1}, /*dsk b*/
#if ! CTLTYPE
		  {  0L, 0, 0, 0, dirbuf, &dpb2, csv2, alv2}, /*dsk c*/
		  {  0L, 0, 0, 0, dirbuf, &dpb2, csv3, alv3}, /*dsk d*/
#endif

#if   MEMDSK
		  {  0L, 0, 0, 0, dirbuf, &dpb3, csv4, alv4}  /*dsk e*/
		};
#endif

#else

#if ! CTLTYPE
struct dph dphtab[4] =
#else
struct dph dphtab[2] =
#endif
		{ {&xlt, 0, 0, 0, &dirbuf, &dpb0,    0L,    0L}, /*dsk a*/
		  {&xlt, 0, 0, 0, &dirbuf, &dpb0,    0L,    0L}, /*dsk b*/
#if ! CTLTYPE
		  {  0L, 0, 0, 0, &dirbuf, &dpb2,    0L,    0L}, /*dsk c*/
		  {  0L, 0, 0, 0, &dirbuf, &dpb2,    0L,    0L}, /*dsk d*/
#endif
		};
#endif

/************************************************************************/
/*	Memory Region Table						*/
/************************************************************************/

struct mrt {	WORD count;
		LONG tpalow;
		LONG tpalen;
	   }
	memtab;				/* Initialized in BIOSA.S	*/


#if   MEMDSK
BYTE *memdsk;				/* Initialized in BIOSA.S	*/
#endif

#if ! LOADER

/************************************************************************/
/*	IOBYTE								*/
/************************************************************************/

WORD iobyte;	/* The I/O Byte is defined, but not used */

#endif


/************************************************************************/
/*	Currently Selected Disk Stuff					*/
/************************************************************************/

WORD settrk, setsec, setdsk;	/* Currently set track, sector, disk */
BYTE *setdma;			/* Currently set dma address */

dump(unsigned char * ptr)
{
  unsigned char * addr=ptr;
  unsigned char ch;
  int a,b;

  for(b=0;b < 8; b++)
  {
    printf("\n\r%08x: ", addr);
     for(a=0;a< 16;a ++)
       printf("%02x ", (*(addr+a) &0xff) );
     for(a=0;a< 16;a ++)
	{
	 ch=*(addr+a);
	 if((ch < ' ') || (ch > 0x7f)) ch='.';
         printf("%c", ch);
	}
    addr+=16;
   }


}


BYTE sector[512];


read()
{
  int part= setsec&3;
  unsigned int sec = setsec >>2;
  unsigned char *dst=setdma;
  int a,b;
  sec+=settrk;

 //printf("%s: part %d sec %d   setsec %d settrk %d \n\r",__FUNCTION__,part,sec, setsec, settrk );
  ide_readmulti(0,sec,sector,1);
  // printf("%s2: part %d sec %d   setsec %d settrk %d \n\r",__FUNCTION__,part,sec, setsec, settrk );
  b=128;
  for(a=part*128;b>0;a++,b--)
    *dst++=sector[a];
  
//  dump(setdma); 
  
  return 0;
}



write()
{}

format()
{}



flush()
{
return 0;
}

 
/************************************************************************/ 
/*      Error procedure for BIOS					*/
/************************************************************************/

#if ! LOADER

bioserr(errmsg)
REG BYTE *errmsg;
{
        printstr("\n\rBIOS ERROR -- ");
        printstr(errmsg);
        printstr(".\n\r");
}
 
printstr(s)     /* used by bioserr */
REG BYTE *s;
{ 
        while (*s) { s += 1; };
}

#else

bioserr()	/* minimal error procedure for loader BIOS */
{
	l : goto l;
}

#endif




/************************************************************************/
/*	BIOS Sector Translate Function					*/
/************************************************************************/

WORD sectran(s, xp)
REG WORD  s;
REG BYTE *xp;
{
	if (xp) return (WORD)xp[s];
	else	return (s+1);
}


/************************************************************************/
/*	BIOS Set Exception Vector Function				*/
/************************************************************************/

LONG setxvect(vnum, vval)
WORD vnum;
LONG vval;
{
	REG LONG  oldval;
	REG BYTE *vloc=0xff000000;

//	printf("%s: vloc %x vnum %x vval %x \n\r",__FUNCTION__,vloc,vnum, vval);
	vloc += (( (long)vnum ) << 2);
	oldval = * (LONG *)vloc;
//	printf("%s: vloc %x vnum %x vval %x \n\r",__FUNCTION__,vloc,vnum, vval);
	*(LONG *) vloc = vval;

	return(oldval);	

}


/************************************************************************/
/*	BIOS Select Disk Function					*/
/************************************************************************/

struct dph * slctdsk(dsk, logged)
REG BYTE dsk;
    BYTE logged;
{
	REG struct dph	*dphp;
	REG BYTE     st1, st2;
	BYTE	stpkt[STPKTSZ];

	setdsk = dsk;	/* Record the selected disk number */

//printf("%s1: dsk %d %x\n\r",__FUNCTION__,dsk,&dphtab[dsk]);

	dphp = &dphtab[dsk];

#if	MEMDSK
	if (setdsk == MEMDSK)
		return(dphp);
#endif


//	printf("%s: return %x \n\r",__FUNCTION__,dphp);
	return(dphp);
}




/************************************************************************/
/*									*/
/*	Bios initialization.  Must be done before any regular BIOS	*/
/*	calls are performed.						*/
/*									*/
/************************************************************************/

biosinit()
{
	//initprts();
	//initdsks();
}

initprts()
{
       
}

initdsks()
{
ide_init(0);
}
 


/************************************************************************/
/*									*/
/*      BIOS MAIN ENTRY -- Branch out to the various functions.		*/
/*									*/
/************************************************************************/

#define duart 0x40000000
 
LONG cbios(d0, d1, d2)
REG WORD	d0;
REG LONG	d1, d2;
{
//if (d0 > 7) 
//printf("cbios: d0: %x  d1: %x d2 : %x   ret: %x \n\r",d0,d1,d2,__builtin_return_address(0) );
	switch(d0)
	{
		case 0:	biosinit();			/* INIT		*/
			break;

#if ! LOADER
		case 1:	flush();			/* WBOOT	*/
			initdsks();
			wboot();
		     /* break; */
#endif
	case 2:
	  {
	  char tst;

	    if ((*(char *)(duart + 9 ) &0x1)==1)
	      tst=0xff;
	    else tst=0;
//printf("%s ret %x \n\r",__FUNCTION__,tst);
	         return( tst );	/* CONST	*/
		 /* break; */
	  }
		case 3:	
			do {
			}while((  ( *(volatile char *)(duart + 9 )) &0x1)==0)  ;
			return( *(char *) (duart + 0xb) );		/* CONIN	*/
		     /* break; */

		case 4:  *(char *) (duart+0xb)=  (char)d1;	/* CONOUT	*/
			break;

		case 5:	;				/* LIST		*/
		case 6: ;	/* PUNCH	*/
			break;

		case 7:	return(0);		/* READER	*/
		     /* break; */

		case 8:	settrk = 0;			/* HOME		*/
			break;

		case 9:	
                        setdsk=(int)d1;
                        return(slctdsk(setdsk,0));                           /* SELDSK	*/
		     /* break; */

		case 10: settrk = (int)d1;		/* SETTRK	*/
			 break;

		case 11: setsec = ((int)d1-1);		/* SETSEC	*/
			 break;

		case 12: setdma = d1;			/* SETDMA	*/
			 break;

		case 13: return(read());		/* READ		*/
		      /* break; */
#if ! LOADER
		case 14: return(write());	/* WRITE	*/
		      /* break; */

		case 15: if ( *(BYTE *)(PORT2 + PORTSTAT) & PORTTDRE )
				return ( 0x0ff );
			   else	return ( 0x000 );
		      /* break; */
#endif

		case 16: return(sectran((int)d1, d2));	/* SECTRAN	*/
		      /* break; */
#if ! LOADER
		case 18: 	
			return(&memtab);		/* GMRTA	*/
		      /* break; */

		case 19: return(iobyte);		/* GETIOB	*/
		      /* break; */

		case 20: iobyte = (int)d1;		/* SETIOB	*/
			 break;

		case 21: if (flush() == 0) return(0L);	/* FLUSH	*/
			 else	      return(0xffffL);
		      /* break; */
#endif
		case 22: return(setxvect((int)d1,d2));	/* SETXVECT	*/
		      /* break; */
#if ! LOADER
		/**********************************************************/
		/*       This function is not part of a standard BIOS.	  */
		/*	 It is included only for convenience, and will	  */
		/*	 not be supported in any way, nor will it	  */
		/* 	 necessarily be included in future versions of	  */
		/* 	 CP/M-68K					  */
		/**********************************************************/
		case 63: return( ! format((int)d1) );	/* Disk Formatter */
		      /* break; */
#endif
	
	 	default: return(0L);
			 break;

	} /* end switch */


} /* END OF BIOS */
 
 
 
/* End of C Bios */
