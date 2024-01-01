#include <xc.h>
    //setting TX/RX
#define _XTAL_FREQ 4000000
char mystring[20];
int lenStr = 0;

void UART_Initialize() {
           
    /*       TODObasic   
           Serial Setting      
        1.   Setting Baud rate
        2.   choose sync/async mode 
        3.   enable Serial port (configures RX/DT and TX/CK pins as serial port pins)
        3.5  enable Tx, Rx Interrupt(optional)
        4.   Enable Tx & RX
    */
           
    TRISCbits.TRISC6 = 1; //pic18 to computer
    TRISCbits.TRISC7 = 1; //computer to pic18
    
    //  Setting baud rate
    TXSTAbits.SYNC = 0; //0 = use async mode
    TXSTAbits.BRGH = 0; //high baud rate select bit
    BAUDCONbits.BRG16 = 0; //choose 8or16 bits for baud rate generator 8:SPBRG, 16:SPBRGH|SPBRG
    SPBRG = 51; //controls period of free-running timer
    
   //   Serial enable
    RCSTAbits.SPEN = 1; //enable async serial port
    PIR1bits.TXIF = 1; //set when TXREG is empty
    PIE1bits.TXIE = 1; //enable interrupt, when TXIE&TXIF => interrupt will occur
    PIR1bits.RCIF = 0; //set when receive complete            
    PIE1bits.RCIE = 1; //enable interrupt, when RCIE&RCIF => interrput will occur
    TXSTAbits.TXEN = 1; //enable transmission
    RCSTAbits.CREN = 1; //enable continuous receive
//    IPR1bits.TXIP = ;              
//    IPR1bits.RCIP = ;    
    // TSR = the 8bits we are transmitting
    // TRMT TXSTA<7> = 1 when TSR is empty
    // TXREG = the next 8bits to be transmitted
    // TXIF PIR1<4> = 1 when TXREG is empty
    }

void UART_Write(unsigned char data)  // Output on Terminal
{
    while(!TXSTAbits.TRMT);
    TXREG = data;              //write to TXREG will send data 
}

void UART_Write_Text(char* text) { // Output on Terminal, limit:10 chars
    for(int i=0;text[i]!='\0';i++)
        UART_Write(text[i]);
}

void ClearBuffer(){
    for(int i = 0; i < 10 ; i++)
        mystring[i] = '\0';
    lenStr = 0;
}

int first_press = 0; // for fuck's sack i cannot compile will my power connected, so i need to check first press to initialize bulbs to 0;
void MyusartRead()
{
    /* TODObasic: try to use UART_Write to finish this function */
    if (RCREG=='\r') UART_Write('\n');
    UART_Write(RCREG);
    if (RCREG=='!') {
        first_press=1;
        LATC=-1;
    }
    return ;
}

char *GetString(){
    return mystring;
}

// void interrupt low_priority Lo_ISR(void)
void __interrupt(high_priority)  H_ISR(void)
{
    if(RCIF)
    {
        if(RCSTAbits.OERR)
        {
            CREN = 0;
            Nop();
            CREN = 1;
        }
        MyusartRead();
    }
    if(TXIF&first_press){
        UART_Write((char)('0'+(int)(LATC>=10)));
        UART_Write((char)('0'+LATC%10));
        UART_Write('\n');
        UART_Write('\r');
    }
    if(INT0IF&first_press){
        INT0IE = 0;
        LATC = (LATC+1)%16;
        __delay_ms(100);
        INT0IF = 0;
        INT0IE = 1;
    }
   // process other interrupt sources here, if required
    return;
}