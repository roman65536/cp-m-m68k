/* ctype.h - isalpha, isupper, islower, isdigit, isspace, ispunct,	*/
/*		isalnum, isprshort, isprint, iscntrl, toupper, tolower,	*/
/*		toascii							*/

#define	_U	0001
#define	_L	0002
#define	_N	0004
#define	_S	0010
#define _P	0020
#define _C	0040
#define	_X	0100

extern	char	_ctype_[]; /* in {Xinu-directory}/src/libc/gen/ctype_.h	*/

#define	isalpha(c)	((_ctype_+1)[c]&(_U|_L))
#define	isupper(c)	((_ctype_+1)[c]&_U)
#define	islower(c)	((_ctype_+1)[c]&_L)
#define	isdigit(c)	((_ctype_+1)[c]&_N)
#define	isxdigit(c)	((_ctype_+1)[c]&(_N|_X))
#define	isspace(c)	((_ctype_+1)[c]&_S)
#define ispunct(c)	((_ctype_+1)[c]&_P)
#define isalnum(c)	((_ctype_+1)[c]&(_U|_L|_N))
#define isprshort(c)	((_ctype_+1)[c]&(_P|_U|_L|_N))
#define isprint(c)	((_ctype_+1)[c]&(_P|_U|_L|_N|_S))
#define iscntrl(c)	((_ctype_+1)[c]&_C)
#define isascii(c)	((unsigned)(c)<=0177)
#define toupper(c)	((c)-'a'+'A')
#define tolower(c)	((c)-'A'+'a')
#define toascii(c)	((c)&0177)

#define NULL (0)

typedef int size_t;
