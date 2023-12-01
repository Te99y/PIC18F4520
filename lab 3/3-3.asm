List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
;	MOVLW 0x08
;	MOVWF TRISA
;	SWAPF TRISA; mov to higher bits so i can add it to TRISC, since the value is 0x0? i can just swap 0 and ?
;	MOVLW 0x0B
;	MOVWF TRISB
;	MOVWF TRISC; optimized, so actually there's no reason to use 3 regs
	
	MOVLW 0x03
	MOVWF TRISA
	SWAPF TRISA; mov to higher bits so i can add it to TRISC, since the value is 0x0? i can just swap 0 and ?
	MOVLW 0x0F
	MOVWF TRISB
	MOVWF TRISC; optimized, so actually there's no reason to use 3 regs
	
	
	
	
	
	LFSR 0, 0x05; use as counter, we need to run 4 times
	loop:
	    MOVF TRISA, 0; mov TRISA to WREG
	    DCFSNZ FSR0L, 1; stop when we run 4 times
	    BRA fin
	    BTFSC TRISC, 0; check last bit in TRISC, skip if 0
	    ADDWF TRISC, 1; add TRISA to TRISC
	    BTFSS STATUS, C; if the previous add overflew, we get the missing one back by right shift
	    BCF TRISC, 0; clear last bit before right shift
	    BCF STATUS, C; clear carry bit
	    RRNCF TRISC; right shift
	    BRA loop
	fin:
	    SWAPF TRISA
	end
