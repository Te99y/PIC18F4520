List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	; every time we multiply whats in 0xF1, 0xF2, 0xF3 and 0xF4
	; and put that in FSR 0
	MOVLW 0x25; a1
	MOVWF 0xA1;
	MOVWF 0xF0;
	MOVLW 0x1F; a2
	MOVWF 0xA2;
	MOVWF 0xF2;
	MOVLW 0x1D; a3
	MOVWF 0xA3;
	MOVLW 0x30; a4
	MOVWF 0xA4;
	MOVLW 0x04; b1
	MOVWF 0xB1;
	MOVWF 0xF1;
	MOVLW 0x03; b2
	MOVWF 0xB2;
	MOVLW 0x02; b3
	MOVWF 0xB3;
	MOVWF 0xF3;
	MOVLW 1; b4
	MOVWF 0xB4;
	LFSR 0, 0x00;
	
	; calculate C1
	RCALL multiply
	; calculate C2
	MOVFF 0xA1, 0xF0
	MOVFF 0xB2, 0xF1
	MOVFF 0xA2, 0xF2
	MOVFF 0xB4, 0xF3
	RCALL multiply
	; calculate C3
	MOVFF 0xA3, 0xF0
	MOVFF 0xB1, 0xF1
	MOVFF 0xA4, 0xF2
	MOVFF 0xB3, 0xF3
	RCALL multiply
	; calculate C4
	MOVFF 0xA3, 0XF0
	MOVFF 0xB2, 0xF1
	MOVFF 0xA4, 0xF2
	MOVFF 0xB4, 0xF3
	RCALL multiply
	goto fin
	
	multiply:
	    MOVF 0xF0, 0
	    MULWF 0xF1
	    MOVFF PRODL, 0xF1; save first mul in 0xF1
	    MOVF 0xF2, 0
	    MULWF 0xF3
	    MOVFF PRODL, WREG; save in WREG since we'll add previous mul right away
	    ADDWF 0xF1, 0
	    MOVWF POSTINC0; put that in c matrix
	    RETURN
	fin:
	end


