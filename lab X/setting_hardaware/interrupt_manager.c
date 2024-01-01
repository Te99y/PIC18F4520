#include <xc.h>

void INTERRUPT_Initialize (void)
{
    TRISBbits.RB0 = 1;
    RCONbits.IPEN = 1;      //enable Interrupt Priority mode
//    INTCONbits.GIEH = 1;    //enable high priority interrupt
//    INTCONbits.GIEL = 1;     //disable low priority interrupt
    INTCON2bits.INTEDG0 = 1;
    INT0IF = 0;
    INT0IE = 1;	
    GIE = 1;
}

