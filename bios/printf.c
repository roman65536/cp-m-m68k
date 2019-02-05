/* $Id: printf.c,v 1.1 1992/11/10 18:04:07 johnr Exp $ */
/* printf.c - printf */
#include "varargs.h"

#define	XC_CONSOLE	0


int		putc();
int 		putcon();
/*------------------------------------------------------------------------
 *  printf  --  write formatted output on CONSOLE 
 *------------------------------------------------------------------------
 */
#if 0
mprintf( va_alist )
va_dcl
{
	va_list		arg;
	int			v;
	const char	*fmt;

	va_start(arg);
	fmt = va_arg(arg, const char *);
	v = mdoprnt(putc,fmt,arg,XC_CONSOLE);
	va_end(arg);
	return(v);
}


printf( va_alist )
va_dcl
{
       va_list         arg;
       int                     v;
       const char      *fmt;
       va_start(arg);
       fmt = va_arg(arg, const char *);
       v = mdoprnt(putcon,fmt,arg,XC_CONSOLE);
      va_end(arg);
       return(v);
 }
#endif

int printf(int va_alist, ...)
{
        va_list args;
        const char *fmt;
        char buff[160];
        char *buf;
        char ch;
        int i;

        va_start(args);
        fmt = va_arg(args, const char *);
        i=vsprintf(buff,fmt,args);
        va_end(args);
        buf=&buff[0];
        while((ch=*buf++) != 0) if (ch == '\n') { putc(ch) ; putc('\r');} 
				  else putc(ch);
        return i;
}


puts(char * str)
{
char ch;
while((ch=*str++) != 0) putc(ch);
}

