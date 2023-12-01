List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	MOVLW 0x0A
	MOVWF 0x00; head
	MOVLW 0x03
	MOVWF 0x18; tail
	LFSR 0, 0x00
	LFSR 1, 0x18
	
	loop:
	    MOVF POSTDEC1, 0; put INDF1=0x02 in WREG, and FSR1--0x17
	    MOVFF POSTINC0, INDF1; put INDF0=5 in FSR1=0x17, and FSR0--0x01
	    SUBWF INDF1, 1; put 5-2 in FSR1=0x17
	    MOVFF INDF1, INDF0; move 3 to FSR0=0x01
	    ADDWF INDF0, 1
	    ADDWF INDF0, 1; we need 5+2, we have 5-2 in INDF0, so we add WREG twice
	    BTFSS FSR0L, 3;  stop if FSR0 = 00000000 00001000
	    GOTO loop
	end
	    
	
	

	