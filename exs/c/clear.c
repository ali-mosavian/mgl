//
// clear.c -- dc clearing (oh, it's soooo complicated :D) ex
//

#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "..\..\inc\ugl.h"

#define xRes 320
#define yRes 200
#define cFmt UGL_8BIT

void ExitError ( char *msg );

//:::
int main ( void )
{
	PDC video;

	// initialize
    if ( !uglInit( ) ) ExitError( "Init" );

	// change video-mode
    video = uglSetVideoDC( cFmt, xRes, yRes, 1 );
    if ( video == 0 ) ExitError( "SetVideoDC" );

    uglClear( video, uglColor( cFmt, 0, 255, 0 ) );

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
