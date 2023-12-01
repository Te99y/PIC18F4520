List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	CLRF 0x00
	CLRF 0x02
	MOVLW b'11101010' ;0x00
	MOVWF 0x00
	MOVFF 0x00, 0x10
	MOVFF 0x00, 0x11
	MOVLW 0x20 ;0x02
	MOVWF 0x02
	
	loop:
	    MOVLW b'00000001'
	    ANDWF 0x00, 1, 0
	    CPFSEQ 0x00 ; skip if is odd
	    GOTO is_even
	    DECF 0x02, 1, 0
	    GOTO check_same
	    is_even:
		INCF 0x02, 1, 0
	    check_same:
		MOVFF 0x10, 0x00
		RRNCF 0x00, 1, 0
		MOVFF 0x00, 0x10
		MOVF 0x00, 0, 0
		CPFSEQ 0x11 ; skip if is original
		GOTO loop
		NOP
	end


