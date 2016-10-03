
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <math.h>
#include "..\..\inc\ugl.h"
#include "..\..\inc\kbd.h"

#define XRES (320*1)
#define YRES (200*1)
#define CFMT UGL_16BIT
#define PAGES 2
#define DEG2RAD (3.14159F / 180.0F)

typedef struct _ENVIRONMENT {
    PDC         video;
    int         workPg;
    int         viewPg;
    PDC         tex;
    KBD         kbd;
} ENVIRONMENT;

void doMain      ( void );
void doInit      ( void );
void doTerminate ( void );
void ExitError   ( char *msg );
void rotateX     ( vector3f *pOut, float sinp, float cosp, vector3f *pIn );
void rotateY     ( vector3f *pOut, float sinp, float cosp, vector3f *pIn );
void rotateZ     ( vector3f *pOut, float sinp, float cosp, vector3f *pIn );

/* *** globals *** */
ENVIRONMENT env;
vector3f    hx[8], hxt[8];

//:::
int main ( void )
{
#define xr2 (XRES / 2)
#define yr2 (YRES / 2)
#define xr3 (XRES / 3)
#define yr3 (YRES / 3)

    hx[0].x = 0-0;    hx[0].y = 0-0;    hx[0].z = 1000;
    hx[1].x = 0-0;    hx[1].y = -yr2-0; hx[1].z = 1000;
    hx[2].x = +xr2-0; hx[2].y = -yr3-0; hx[2].z = 1000;
    hx[3].x = +xr2-0; hx[3].y = +yr3-0; hx[3].z = 1000;
    hx[4].x = 0-0;    hx[4].y = +yr2-0; hx[4].z = 1000;
    hx[5].x = -xr2-0; hx[5].y = +yr3-0; hx[5].z = 1000;
    hx[6].x = -xr2-0; hx[6].y = -yr3-0; hx[6].z = 1000;
    hx[7].x = 0-0;    hx[7].y = -yr2-0; hx[7].z = 1000;

    doInit( );
    doMain( );
    doTerminate( );

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

//:::
void makeTex( PDC tex )
{
    int     x, y, r, g, b;
    FBUFF   fb;

    for ( y = 0; y < tex->yRes; y++ )
    {
        fb = uglDCAccessWr( tex, y );

        switch ( tex->fmt )
        {
            case UGL_8BIT:
                for ( x = 0; x < tex->xRes; x++ )
                {
                    r = ((y & x) << 2) & 255;
                    g = ((x & y) << 2) & 255;
                    b = ((y + x) << 2) & 255;
                    *((FBUFF8)fb)++ = uglColor( tex->fmt, r, g, b );
                }
            break;

            case UGL_15BIT:
            break;

            case UGL_16BIT:
                for ( x = 0; x < tex->xRes; x++ )
                {
                    r = ((y & x) << 2) & 255;
                    g = ((x & y) << 2) & 255;
                    b = ((y + x) << 2) & 255;
                    *((FBUFF16)fb)++ = uglColor( tex->fmt, r, g, b );
                }
            break;

            case UGL_32BIT:
            break;
        }
    }
}

//:::
void doInit ( void )
{
	// initialize
    if ( !uglInit( ) ) ExitError( "Init" );
    
    // Set video mode with x pages
    env.video = uglSetVideoDC( CFMT, XRES, YRES, PAGES );
    if ( env.video == 0 ) ExitError( "SetVideoDC" );
    
    env.viewPg = 0;
    env.workPg = 1;
    uglSetVisPage( env.viewPg );
    uglSetWrkPage( env.workPg );

    // Init keyboard handler
    kbdInit( &env.kbd );

    env.tex = uglNew( UGL_MEM, CFMT, 64, 64 );
    makeTex( env.tex );
    
}

//:::
void doTerminate ( void )
{
    // Terminate UGL
    kbdEnd( );
    uglRestore( );
    uglEnd( );
}

//:::
void rotateX ( vector3f *pOut, float sinp, float cosp, vector3f *pIn )
{
    float   nx, ny, nz;
    
    ny = pIn->y*cosp - pIn->z*sinp;
    nz = pIn->z*cosp + pIn->y*sinp;
    
    pOut->x = pIn->x;
    pOut->y = ny;
    pOut->z = nz;
}

//:::
void rotateY ( vector3f *pOut, float sinp, float cosp, vector3f *pIn )
{
    float   nx, ny, nz;
    
    nz = pIn->z*cosp - pIn->x*sinp;
    nx = pIn->x*cosp + pIn->z*sinp;
    
    pOut->x = nx;
    pOut->y = pIn->y;
    pOut->z = nz;
}

//:::
void rotateZ ( vector3f *pOut, float sinp, float cosp, vector3f *pIn )
{
    float   nx, ny, nz;
    
    nx = pIn->x*cosp - pIn->y*sinp;
    ny = pIn->y*cosp + pIn->x*sinp;
    
    pOut->x = nx;
    pOut->y = ny;
    pOut->z = pIn->z;
}

//:::
void doMain ( void )
{
    float   x1, y1;
    float   x2, y2; 
    float   x3, y3;
    float   cx, cy;
    TriType tri;
    float   zoom, angz, zcosp, zsinp, ooz;
    int     i;
    long    color;

    cx = XRES / 2;
    cy = YRES / 2;
    zoom = 1.0;
    
#define INC 0.1F

    tri.v1.u = 0.0F; tri.v1.v = 0.0F; tri.v1.r = 0.0; tri.v1.g = 0.0; tri.v1.b = 0.0;
    tri.v2.u = 1.0F; tri.v2.v = 1.0F; tri.v2.r = 0.5; tri.v2.g = 0.5; tri.v2.b = 0.5;
    tri.v3.u = 0.0F; tri.v3.v = 1.0F; tri.v3.r = 1.0; tri.v3.g = 1.0; tri.v3.b = 1.0;

    do
    {
        // Clear screen 
        uglClear( env.video, uglColor( CFMT, 128, 128, 128 ) );
        
        if ( env.kbd.left )
            cx -= INC;
        else if ( env.kbd.right )
            cx += INC;

        if ( env.kbd.up )
            cy -= INC;
        else if ( env.kbd.down )
            cy += INC;

        if ( env.kbd.r )
        {
            angz += INC;
            if ( angz > 360.0 ) angz -= 360.0;
        }
        else if ( env.kbd.e )
        {
            angz -= INC;
            if ( angz < 0.0 ) angz += 360.0;
        }

        if ( env.kbd.pgup )
            zoom += INC;
        else if ( env.kbd.pgdw )
        {
            zoom -= INC;
            if ( zoom < 0.01F ) zoom = 0.01F;
        }
        
        zcosp = cos( angz * DEG2RAD );
        zsinp = sin( angz * DEG2RAD );
        for (i = 0; i < 8; i++ )
        {
			rotateZ( &hxt[i], zsinp, zcosp, &hx[i] );

            ooz = (zoom / hxt[i].z) * 256.0;
            hxt[i].x = cx + (hxt[i].x * ooz);
            hxt[i].y = cy + (hxt[i].y * ooz);
        }
                
        color = 0xF2;
        for ( i = 1; i < 7; i++ )
        {
            tri.v1.x = hxt[i+0].x; tri.v1.y = hxt[i+0].y;
            tri.v2.x = hxt[i+1].x; tri.v2.y = hxt[i+1].y;
            tri.v3.x = hxt[0].x;   tri.v3.y = hxt[0].y;
            //uglTriF( env.video, &tri, color );
            //color += 2;
            //uglTriG( env.video, &tri );
            uglTriT( env.video, &tri, UGL_MASK_FALSE, env.tex );
        }

        env.viewPg = env.workPg;
        env.workPg = ( env.workPg + 1 ) % PAGES;
        uglSetVisPage( env.viewPg );
        uglSetWrkPage( env.workPg );

    } while ( !env.kbd.esc );
}
