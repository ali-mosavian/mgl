#include <memory.h>
#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#include <dos.h>
#include "..\..\inc\ugl.h"

typedef struct _Env {
   PDC          video;
   int          xRes;
   int          yRes;
   int          cFmt;
   float        xScl;
   float        yScl;
} Env;

#define ResCount 6
int res[ResCount*3] = {320, 200, UGL_16BIT,
                          320, 240, UGL_16BIT,
                          512, 384, UGL_16BIT,
                          320, 200, UGL_8BIT,
                          320, 240, UGL_8BIT,
                          512, 384, UGL_8BIT};

void ExitError ( char *msg );

int main ( void )
{
    Env env = { 0 };
    int i = 0, ok = 0;
    int x, y, c1, c2;
    float rgb[3], s1, s2;
    long clr;

    if ( !uglInit( ) ) ExitError( "Init" );

    printf ( "uglInit succsessfull, press any key to find the best working screen mode..\n");
    getch ( );

    clr = -1;
    for( ; i < ResCount*3; i+=3 )
    {
        env.video = uglSetVideoDC( res[i+2], res[i+0], res[i+1], 1 );

        if ( env.video != NULL )
        {
            env.xRes = res[i+0];
            env.yRes = res[i+1];
            env.cFmt = res[i+2];

            uglSetVisPage ( 0 );
            uglSetWrkPage ( 0 );

            //uglPSet ( env.video, 160, 100, -1 );
            uglRectF ( env.video, 0, 0, 319, 199, clr );
            clr -= 10;

            getch ( );
        }
    }

    uglRestore( );

    return 0;
}

void ExitError ( char *msg )
{
    uglRestore( );
    uglEnd( );

    printf( "ERROR! %s\n", msg );
    exit( 1 );
}
