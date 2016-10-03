//
// c.c -- C side (helper lib)
//

#define __BASLIB__                      // <-- the only difference

#include "..\..\..\inc\ugl.h"

//:::
void pascal far cClear ( PDC dc, long color )
{
    FBUFF   fb;
    int     x, y;

    for ( y = 0; y < dc->yRes; y++ )
    {
        fb = uglDCAccessWr( dc, y );

        switch ( dc->fmt )
        {
            case UGL_8BIT:
                for ( x = 0; x < dc->xRes; x++ )
                    *((FBUFF8)fb)++ = color;
            break;

            case UGL_15BIT:
                for ( x = 0; x < dc->xRes; x++ )
                    *((FBUFF15)fb)++ = color;
            break;

            case UGL_16BIT:
                for ( x = 0; x < dc->xRes; x++ )
                    *((FBUFF16)fb)++ = color;
            break;

            case UGL_32BIT:
                for ( x = 0; x < dc->xRes; x++ )
                    *((FBUFF32)fb)++ = color;
            break;
        }
    }
}
