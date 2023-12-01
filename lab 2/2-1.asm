List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00

	MOVLB 0x01
	MOVLW 0x15
	MOVWF 0x00, 1; put 0x03 in 0x100
	MOVLW 0x12
	MOVWF 0x01, 1; put 0x08 in 0x101
	LFSR 0, 0x100; set pointer_0 to 100
	LFSR 1, 0x101; set pointer_1 to 101
	
	loop:
	    MOVF POSTINC1, 0; copy value in address pointer_1 to WREG, and than pointer_1++, ex: WREG is now value of 101, which is 8, and 101 is now 102
	    BTFSC FSR1L, 0; check if pointer_1 is even. ex: skip if 102 is even
	    GOTO is_odd
       ;is_even:
	    ADDWF POSTINC0, 0; add value in loc of pointer_0 to WERG, ex: 100 is now 101
	    GOTO check_loop
	is_odd:
	    MOVWF 0x00, 0
	    MOVF POSTINC0, 0; move 100 to WREG, so we can use SUBWF
	    SUBWF 0x00, 0
	    ;I dont know why SUBFWB POSTINC0, 0 always subtract 1 more when 2 operands are with same signs
	    ;so i used SUBWF
	check_loop:
	    MOVWF INDF1; move the calculated value to 102
	    BTFSS FSR1L, 3; if FSR1L == 0100 we stop, cuz that means FSR=00000001 00000100=0x108
	    GOTO loop  
	end

