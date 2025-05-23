List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	MOVLW 0x76; x1H
	MOVWF 0x00
	MOVWF 0xA0
	MOVLW 0x12; x1L
	MOVWF 0x01
	MOVWF 0xA1
	MOVLW 0x44; x2H
	MOVWF 0x10
	MOVWF 0xB0
	MOVLW 0x93; x2L
	MOVWF 0x11
	MOVWF 0xB1
	
	LFSR 0, 0xA1
	LFSR 1, 0xB1
	LFSR 2, 0x21
	loop:
	    MOVF INDF1, 0; save B in WREG
	    XORWF INDF0, 1; save A XOR B in FSR0
	    COMF INDF0, 0; save negate XOR in WREG so we dont need extra reg to get A AND B
	    ANDWF INDF1, 1; save A AND B in FSR1
	    BTFSC INDF1, 7; check if we have DC from L to H
	    BSF 0xDC, 0; if we have DC, set DC to 1
	    BCF INDF1, 7; remove the DC from A and B
	    RLCF INDF1; we need to left shift caryy by 1
	    TSTFSZ INDF1; go back to loop if carry is not zero yet
	    GOTO loop
	    MOVFF INDF0, INDF2; move ans to 0x21 or 0x20
	    BTFSS FSR0L, 0; skip if we have not done High bits
	    GOTO fin
	    LFSR 0, 0xA0
	    LFSR 1, 0xB0
	    LFSR 2, 0x20
	    GOTO loop
	fin:
	    BTFSC 0xDC, 0
	    INCF 0x20
	end


