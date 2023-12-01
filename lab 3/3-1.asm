List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	MOVLW b'11110000'
	MOVWF TRISA
	
	RRCF TRISA; mov right
	RRCF TRISA; mov right and clear first bit
	BCF TRISA, 7
	end