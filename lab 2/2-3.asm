List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	LFSR 0, 0x100
	MOVLW 0x10
	MOVWF POSTINC0
	MOVLW 0x02 
	MOVWF POSTINC0
	MOVLW 0x04
	MOVWF POSTINC0
	MOVLW 0x58 
	MOVWF POSTINC0
	MOVLW 0x2C
	MOVWF POSTINC0
	MOVLW 0x5D
	MOVWF INDF0
	
	LFSR 0, 0x100
	LFSR 1, 0x100
	LFSR 2, 0x105
	
	
	from_left:
	    MOVF POSTINC1, 0; move INDF1 to WREG, FSR0--0x101
	    CPFSGT INDF1; skip if WREG < INDF0 (no need to swap)
	    GOTO swap_from_left
	check_from_left:
	    MOVF FSR2L, 0; move right end to WREG, ex: 0x105
	    CPFSEQ FSR1L; skip if right end reached, ex:FSR1=0x105
	    GOTO from_left
	    DECF FSR2L; the right-- in source code
	    MOVF FSR0L, 0; load left end to WREG
	    CPFSGT FSR2L; compare left end and right end, if right <= left than stop
	    GOTO stop
	from_right:
	    MOVF POSTDEC1, 0; move INDF1 to WREG, FSR1--0x104
	    CPFSLT INDF1; skip if INDF1 < WREG
	    GOTO swap_from_right
	check_from_right:
	    MOVF FSR0L, 0; move left end to WREG
	    CPFSEQ FSR1L; skip if left end reached, ex:FSR1==0x101
	    GOTO from_right
	    INCF FSR0L; the left++ in source code
	    MOVF FSR2L, 0; move right end to WREG
	    CPFSLT FSR0L; if left < right nothing happends
	    GOTO stop
	    GOTO from_left
	swap_from_left:
	    MOVFF POSTDEC1, 0x00; save 101.v in temp and go back to 100
	    MOVF INDF1, 0; move 100.v to WREG
	    MOVFF 0x00, POSTINC1; move 0x00.v to 100 and FSR1 go to 101
	    MOVWF INDF1, 0; move WREG.v to 101
	    GOTO check_from_left
	swap_from_right:
	    MOVFF POSTINC1, 0x00
	    MOVF INDF1, 0
	    MOVFF 0x00, POSTDEC1
	    MOVWF INDF1, 0
	    GOTO check_from_right
	stop: ; needed to save those numbers in 0x110 not 0x100
	    MOVFF 0x100, 0x110
	    MOVFF 0x101, 0x111
	    MOVFF 0x102, 0x112
	    MOVFF 0x103, 0x113
	    MOVFF 0x104, 0x114
	    MOVFF 0x105, 0x115
	end
	