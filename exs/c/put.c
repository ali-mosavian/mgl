//
// put.c -- bitmap drawing ex
//

#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "..\..\inc\ugl.h"

#define xRes 320
#define yRes 200
#define cFmt UGL_8BIT

#define BMPS 64
#define bmpW 32
#define bmpH 32

void ExitError ( char *msg );

//:::
int main ( void )
{
    PDC     video;
    PDC     bmp[BMPS];
    long    colors;
    int     i, y;

    // initialize
    if ( !uglInit( ) ) ExitError( "Init" );

    // change video-mode
    video = uglSetVideoDC( cFmt, xRes, yRes, 1 );
    if (video == 0) ExitError( "SetVideoDC" );

    // allocate the bitmaps
    if ( !uglNewMult( &bmp[0], BMPS, UGL_MEM, cFmt, bmpW, bmpH ) )
        ExitError( "New bmps" );

	colors = uglColors( cFmt );

    // fill the bitmaps
    for ( i = 0; i < BMPS; i++ )
    {
        for ( y = 0; y < bmpH; y++ )
            uglHLine( bmp[i], 0, y, bmpW-1, random( colors ) );

        uglRect( bmp[i], 0, 0, bmpW-1, bmpH-1, random( colors ) );
    }

    uglClear( video, -1 );

    while ( !kbhit( ) )
    {
        for ( i = 0; i < 256; i++ )
            uglPut( video,
                    -bmpW/2 + random( xRes+bmpW/2 ),
                    -bmpH/2 + random( yRes+bmpH/2 ),
                    bmp[random( BMPS-1 )] );
    }

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
