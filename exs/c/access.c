//
// access.c -- direct dc access
//

#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "..\..\inc\ugl.h"

#define xRes 320*2
#define yRes 200*2
#define cFmt UGL_8BIT

void ExitError ( char *msg );

//:::
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
