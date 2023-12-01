List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	
	MOVLW b'10010000'
	MOVWF 0x00 ; put target in 0x00
	MOVWF 0x01 ; put answer in 0x00
	MOVWF 0x10 ; 1-bit
	MOVWF 0x11 ; 2-bit
	
	MOVLW b'10000000'
	MOVWF 0x12 ; mask
	ANDWF 0x01, 1, 0
	iter:
	    MOVF 0x12, 0
	    MOVFF 0x00, 0x10
	    MOVFF 0x00, 0x11
	    ANDWF 0x10, 1, 0 ; get 1st bit
	    RRNCF WREG
	    MOVWF 0x12, 1
	    ANDWF 0x11, 1, 0 ; get 2nd bit
	    RRNCF 0x10, 1, 0 ; right shift 1st bit
	    MOVFF 0x11, 0x21
	    MOVF 0x10, 0 ; prepare to get AND
	    ANDWF 0x21, 1 ; get AND in 0x21
	    COMF 0x21, 1 ; negate 0x21
	    MOVF 0x11, 0 ; prepare to get IOR
	    IORWF 0x10, 0 ; IOR in WREG
	    ANDWF 0x21, 0 ; save XOR in WREG
	    ADDWF 0x01, 1, 0
	    MOVLW b'00000001'
	    CPFSEQ 0x12, 0
	    GOTO iter
	end
	

