#include <xc.h>
#include<stdio.h>
#include<stdlib.h>
#include <time.h>
#define _XTAL_FREQ 1000000


#pragma config OSC = INTIO67  //OSCILLATOR SELECTION BITS (INTERNAL OSCILLATOR BLOCK, PORT FUNCTION ON RA6 AND RA7)
#pragma config WDT = OFF      //Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PWRT = OFF     //Power-up Timer Enable bit (PWRT disabled)
#pragma config BOREN = ON     //Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
#pragma config PBADEN = OFF   //PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LVP = OFF      //Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
#pragma config CPD = OFF      //Data EEPROM Code Protection bit (Data EEPROM not code-protected)

void __interrupt(high_priority)H_ISR(){
    
    //step4
    int value = (ADRESH<<2)|(ADRESL>>6) ;
    value = (int)(value/(1024/8));
    switch (value)
    {
        case 0: LATC=7;
                break;
        case 1: LATC=4;
                break;
        case 2: LATC=1;
                break;
        case 3: LATC=0;
                break;
        case 4: LATC=6;
                break;
        case 5: LATC=2;
                break;
        case 6: LATC=4;
                break;
        case 7: LATC=6;
                break;
        default: LATC=0;
                break;
    }
//    __delay_ms(1000);
    //do things
    
    
    //clear flag bit
    PIR1bits.ADIF = 0;
    
    ADCON0bits.GO = 1;
    
    //step5 & go back step3
    /*
    delay at least 2tad
    ADCON0bits.GO = 1;
    */
    
    return;
}

void main(void) 
{
    //configure OSC and port
    OSCCONbits.IRCF = 0b100; //1MHz
    TRISAbits.RA0 = 1;       //analog input port
    
    //step1
    ADCON1bits.VCFG0 = 0;
    ADCON1bits.VCFG1 = 0;
    ADCON1bits.PCFG = 0b1110; //AN0 ?analog input,???? digital
    ADCON0bits.CHS = 0b0000;  //AN0 ?? analog input
    ADCON2bits.ADCS = 0b100;  //????000(1Mhz < 2.86Mhz)
    ADCON2bits.ACQT = 0b010;  //Tad = 2 us acquisition time?2Tad = 4 > 2.4
    ADCON0bits.ADON = 1; //enable A/D
    ADCON2bits.ADFM = 0;    //left justified 
    
    
    //step2
    PIE1bits.ADIE = 1; //enable A/D interrupt
    PIR1bits.ADIF = 0; //clear A/D interrupt bit
    INTCONbits.PEIE = 1; //enable peripheral interrupt
    INTCONbits.GIE = 1; //enable interrupt


    //step3
    ADCON0bits.GO = 1; //set go/done bit
    
    TRISC = 0;
    LATC = 0;
    
    while(1);
    
    return;
}