
/*
 *	$Id: varargs.h,v 1.1 1992/11/10 18:22:01 johnr Exp $
 */
#ifndef _sys_varargs_h
#define _sys_varargs_h

typedef char *va_list;
#define va_dcl int va_alist;
#define va_start(list) list = (char *) &va_alist
#define va_end(list)
/*
#if defined(__BUILTIN_VA_ARG_INCR) && !defined(lint)
#define va_arg(list,mode) ((mode*)__builtin_va_arg_incr((mode *)list))[0]
#else 
#define va_arg(list,mode) ((mode *)(list += sizeof(mode)))[-1]
#endif */


#define va_arg(list,mode) ((mode *)(list += sizeof(mode)))[-1]


#endif /*!_sys_varargs_h*/

/*
 *	$Log: varargs.h,v $
 * Revision 1.1  1992/11/10  18:22:01  johnr
 * JR: Initial entry for this file.
 *
 *
 */
