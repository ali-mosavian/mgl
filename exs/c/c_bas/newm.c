#define __BASLIB__

#include "..\..\..\inc\ugl.h"

#define xRes 320
#define yRes 200
#define cFmt UGL_16BIT

#define BMPS 64
#define bmpW 32
#define bmpH 32

typedef struct _BASARRAY {
	void		far *farptr;
	short		next_dsc;
	short		next_dsc_size;
	char		dimensions;
	char		type_storage;		// 1=far,2=huge,64=static,128=string
	short		adjs_offset;
	short		element_len;
	short		last_dim_elemts;
	short		last_dim_first;
} BASARRAY;

BASARRAY qad;
PDC     bmp[BMPS];

//:::
int far pascal allocDCs ( )
{
    int i;

    qad.farptr = &bmp[0];

    // allocate the bitmaps
    if ( !uglNewMult( &qad, BMPS, UGL_MEM, cFmt, bmpW, bmpH ) )
        return 0;

    // fill the bitmaps
    for ( i = 0; i < BMPS; i++ )
        uglRectF( bmp[i], 0, 0, bmpW-1, bmpH-1, i << 2 );

    return -1;
}

//:::
void far pascal showDCs ( PDC video )
{
    int     i;
    
    for ( i = 0; i < BMPS; i++ )
         uglPut( video, (i << 2) % xRes,
                        (i << 2) % yRes, bmp[i] );
}
