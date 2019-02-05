/****************************************************************
*								*
*		CP/M-68K BDOS Disk I/O System Module		*
*								*
*	This module translates from the packet oriented I/O	*
*	passed from the other BDOS modules into BIOS calls.	*
*								*
*	It includes only one external entry point:
*		do_phio()   - do physical i/o			*
*								*
*								*
*	Configured for Alcyon C on the VAX			*
*								*
****************************************************************/

#include "bdosinc.h"		/* Standard I/O declarations */

#include "bdosdef.h"		/* Type and structure declarations for BDOS */

#include "pktio.h"		/* Packet I/O definitions */

#include "biosdef.h"		/* Declarations for BIOS entry points */

EXTERN	udiv(int, short,  short *);			/* Assembly language unsigned divide routine */
				/* in bdosif.s.  It's used because Alcyon C  */
				/* can't do / or % without an external */
unsigned short int cpm_udiv(
  signed long int dividend,
  unsigned short int divisor,
  unsigned short int *remainder ) ;

/************************
*  do_phio entry point	*
************************/

UWORD do_phio(iop)

struct iopb *iop;		/* iop is a pointer to a i/o parameter block */

{
    MLOCAL UBYTE last_dsk;  	/* static variable to tell which disk
				     was last used, to avoid disk selects */
    REG struct dph *hdrp;	  /* pointer to disk parameter header	*/
    REG struct dpb *dparmp;	  /* pointer to disk parameter block	*/
    REG UWORD	rtn;		  /* return parameter			*/
    UWORD	iosect;		  /* sector number returned from divide rtn */
    WORD tmp;

    LOCK		/* lock the disk system while doing physical i/o */

    rtn = 0;
    switch (iop->iofcn)
    {
	case sel_info:	
		last_dsk = iop->devnum;
//		printf("%sa: %x  \n\r",__FUNCTION__, iop );
		iop->infop = (struct dph *) bseldsk(last_dsk, iop->ioflags);
//		printf("%sb: %x %x \n\r",__FUNCTION__, iop, iop->infop->dpbp);
//		dump(iop->infop);
//		dump(iop->infop->dpbp);
		break;

	case read:
	case write:
		if (last_dsk != iop->devnum)
		    bseldsk((last_dsk = iop->devnum), 0);
		    /* guaranteed disk is logged on, because temp_sel in
			BDOSMAIN does it	*/
		hdrp = iop->infop;
		dparmp = hdrp->dpbp;
//		printf("%s1: %d %d\n\r",__FUNCTION__,iop->devadr,dparmp->spt);

		bsettrk( cpm_udiv( iop->devadr, dparmp->spt, &iosect )
				 + dparmp->trk_off );
		 //tmp=iop->devadr/dparmp->spt;
	         //iosect=iop->devadr%dparmp->spt;
//		printf("%s2: %d %d %d %d \n\r",__FUNCTION__,iop->devadr,dparmp->spt, tmp, iosect);
		//bsettrk(tmp+ dparmp->trk_off );
		bsetsec( bsectrn( iosect, hdrp->xlt ) );
		bsetdma(iop->xferadr);
		if ((iop->iofcn) == read) rtn = bread();
		else rtn = bwrite(iop->ioflags);
		break;

	case flush:
		rtn = bflush();
    }

    UNLOCK
    return(rtn);
}
