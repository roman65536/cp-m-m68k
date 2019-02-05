

char *
memchr(s, c, n)
	register char *s;
	register c, n;
{
	while (--n >= 0)
		if (*s++ == c)
			return (--s);
	return (0);
}

void * memcpy ( void * dest, void * src , int size)
{
 char *tmp=(char *)dest, *s= (char *) src;

 while( size --)
     *tmp++=*s++;
 
 return dest;
}
