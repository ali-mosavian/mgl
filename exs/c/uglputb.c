//
// access.c -- direct dc access
//
#include "..\..\inc\ugl.h"


typedef signed char         sint8;
typedef signed short        sint16;
typedef signed long         sint32;
typedef unsigned char       uint8;
typedef unsigned short      uint16;
typedef unsigned long       uint32;



void uglPutB ( PDC dst, int xd, int yd, int a, PDC src ) 
{   
    sint32  alfa; 
    uint16  x, y;
    FBUFF   fbdst;
    FBUFF   fbsrc;
    
    RECT    srcp;    
    uint16  dstsx, dstsy;
    uint16  dstlx, dstly;
    uint16  srcsx, srcsy;
    
    sint32 dstr, dstg, dstb;
    sint32 finr, fing, finb;
    sint32 srcr, srcg, srcb;
    
    
    //
    // Check format 
    //
    if ( src->bpp != dst->bpp )
        return;
        
    alfa = a;    
    scrp.x1 = src.cr.xMin+xd;
    scrp.y1 = src.cr.yMin+yd;    
    scrp.x2 = src.cr.xMax+xd;
    scrp.y2 = src.cr.yMax+yd;
    
    //
    // Clip
    //
    dstsx = 0; dstsy = 0;
    srcsx = 0; srcsy = 0;    
    srclx = srcp.x2-srcp.x1;
    srcly = srcp.y2-srcp.y1;
    
    //
    // Select innerloop
    //
    switch ( src->bpp )
    {
        //
        // 32 bpp
        //
        case 32:
            for ( y = 0; <= srcly; y++ )
            {                
                for ( x = 0; <= srclx; x++ )
                {
                    srcr =  ((FBUFF32)fbsrc) >> 24L;                    
                    dstr =  ((FBUFF32)fbdst) >> 24L;
                    srcg = (((FBUFF32)fbsrc) >> 16L) & 0x000000ff;
                    dstg = (((FBUFF32)fbdst) >> 16L) & 0x000000ff;
                    srcb =  ((FBUFF32)fbsrc) & 0x000000ff;
                    dstb =  ((FBUFF32)fbdst) & 0x000000ff;
                    
                    finr = dstr + alfa*(srcr-dstr)>>8L;
                    fing = dstg + alfa*(srcg-dstg)>>8L;
                    finb = dstb + alfa*(srcb-dstb)>>8L;
                    
                    
                }
            }
        break;
    }

    
}

int main ( void )
{
    PDC     video;
    FBUFF8  fb;
    int     x, y;
    long    c;

    // initialize
    if ( !uglInit( ) ) ExitError( "Init" );

    // change video-mode
    video = uglSetVideoDC( cFmt, xRes, yRes, 1 );
    if ( video == 0 ) ExitError( "SetVideoDC" );

    for ( y = 0; y < yRes; y++ )
    {
        c = random( uglColors( cFmt ) );
        fb = (FBUFF8)uglDCAccessWr( video, y );
        for ( x = 0; x < xRes; x++ )
            *fb++ = c;
    }

    while ( !kbhit( ) ) ;
    getch( );

    uglRestore( );
    return 0;
}

//:::
void ExitError ( char *msg )
{
    uglRestore( );
    uglEnd( );
    printf( "ERROR! %s\n", msg );
    exit( 1 );
}
