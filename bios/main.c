

extern void * _bss_end;
extern void * _bss_start;
extern void * _text_end;
extern void * _data_end;
extern void * _data_start;

mmain()
{
 int  a;
 int b;
 int x,y;
 int xi=1;
 int yi=1;
 void * end=(char *) 0xb0000;
 int len ;

 char *src = & _text_end;
 char *dst = & _data_start;
 printf("\n\r Copy data src: %x dst : %x data_end: %x ",src,dst,&_data_end);
 while ( dst < & _data_end)
  *dst++=*src++;

printf("\n\r Cleaning bss  %x %x", & _bss_start,&_bss_end);
 for(dst= & _bss_start; dst < & _bss_end; dst++)
  *dst=0;

//_init();
cpm();
}




