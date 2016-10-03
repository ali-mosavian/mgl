/*
**
** tmrclbk.c - Timer callback test
** 
**
**
*/
#include <stdio.h>
#include "..\..\inc\ugl.h"
#include "..\..\inc\tmr.h"


TMR mytimer[2] = {0};
unsigned long timesCalledA = 0; 
unsigned long timesCalledB = 0;


// :::::::::::::
// name: callbkA 
// desc: A test callback
//
//
// :::::::::::::
void TCALLBK callbkA ( void )
{
    timesCalledA++;
}


// :::::::::::::
// name: callbkB
// desc: A test callback
//
//
// :::::::::::::
void TCALLBK callbkB ( void )
{
    timesCalledB++;
}



// :::::::::::::
// name: main
// desc: Entry point
//
//
// :::::::::::::
void main ( void ) 
{
    
    //
    // Init UGL
    //
    if ( uglInit() == UGL_FALSE )
    {
        printf( "Error: 0x0000, Could not init UGL...\n" );
        return;
    }
    
    //
    // Init the timer module
    //
    tmrInit();
    
    
    //
    // Set the timer callbacks and start the timers
    //
    tmrCallbkSet( &mytimer[0], callbkA ); 
    tmrCallbkSet( &mytimer[1], callbkB ); 
    
    tmrNew( &mytimer[0], TMR_AUTOINIT, tmrMs2Freq( 20 )   );
    tmrNew( &mytimer[1], TMR_AUTOINIT, tmrMs2Freq( 1000 ) );
    

    //
    // Wait for input then quit
    //
    printf( "Timers are now running, press any key to quit\n");     
    while ( mytimer[1].counter < 1 );
    uglEnd();
    
    printf( "callbkA() was called %lu times\n", timesCalledA );
    printf( "callbkB() was called %lu times\n", timesCalledB );
}