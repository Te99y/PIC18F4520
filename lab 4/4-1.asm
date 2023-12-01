List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	Add_Mul macro xh,xl,yh,yl; these are literals
	    MOVLW xh; x1H
	    MOVWF 0xA0
	    MOVLW xl; x1L
	    MOVWF 0xA1
	    MOVLW yh; x2H
	    MOVWF 0xB0
	    MOVLW yl; x2L
	    MOVWF 0xB1
	    ; addition
	    ADDWF 0xA1, 0; low + low
	    MOVWF 0x01
	    BTFSC STATUS, DC
	    INCF 0xA0
	    MOVF 0xA0, 0
	    ADDWF 0xB0, 0; high + high
	    MOVWF 0x00
	    ; mul 0x00 and 0x01
	    MOVF 0x00, 0
	    MULWF 0x01
	    MOVFF PRODH, 0x10
	    MOVFF PRODL, 0x11
	    MOVF 0x01, 0
	    BTFSC 0x00, 7
	    SUBWF 0x10, 1
	    MOVF 0x00, 0
	    BTFSC 0x01, 7
	    SUBWF 0x10, 1
	    endm
	    Add_Mul 0xFF, 0xBA, 0xFF, 0xDD
	end

