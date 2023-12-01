LIST p=18f4520
#include<p18f4520.inc>
    CONFIG OSC = INTIO67 ; 1 MHZ
    CONFIG WDT = OFF
    CONFIG LVP = OFF

    L1	EQU 0x14
    L2	EQU 0x15
    org 0x00
	
; Total_cycles = 2 + (2 + 7 * num1 + 2) * num2 cycles
; num1 = 200, num2 = 180, Total_cycles = 252360
; Total_delay ~= Total_cycles/1M = 0.25s
PURE_DELAY macro num1, num2 
    local LOOP1         ; innerloop
    local LOOP2         ; outerloop
    MOVLW num2          ; 2 cycles
    MOVWF L2
    LOOP2:
	MOVLW num1          ; 2 cycles
	MOVWF L1
    LOOP1:
	NOP                 ; 7 cycles
	NOP
	NOP
	NOP
	NOP
	DECFSZ L1, 1
	BRA LOOP1
	DECFSZ L2, 1        ; 2 cycles
	BRA LOOP2
endm
DELAY macro num1, num2 
    local LOOP1         ; innerloop
    local LOOP2         ; outerloop
    MOVLW num2          ; 2 cycles
    MOVWF L2
    LOOP2:
	BTFSS PORTB, 0; check button before delay
	BRA change_state
	MOVLW num1          ; 2 cycles
	MOVWF L1
    LOOP1:
	BTFSS PORTB, 0; check button before delay
	BRA change_state
	NOP                 ; 7 cycles
	NOP
	NOP
	NOP
	NOP
	DECFSZ L1, 1
	BRA LOOP1
	DECFSZ L2, 1        ; 2 cycles
	BRA LOOP2
endm
start:
int:
; let pin can receive digital signal 
MOVLW 0x0f
MOVWF ADCON1            ;set digital IO
CLRF PORTB
BSF TRISB, 0            ;set RB0 as input TRISB = 0000 0001
CLRF LATA
BCF TRISA, 0            ;set TRISA as output = 0000 0000
BCF TRISA, 1            ;set TRISA as output = 0000 0000
BCF TRISA, 2            ;set TRISA as output = 0000 0000
BCF TRISA, 3            ;set TRISA as output = 0000 0000
BCF TRISA, 4            ;set TRISA as output = 0000 0000
;BSF STATUS, C

LFSR 0, 0x00; state one = 0000, two = 0001, three = 0010
; ckeck button
check_state:
    PURE_DELAY d'50', d'180' ;delay 0.5s
    BTFSC FSR0L, 1; FSR0L=0010, FSR0L can be 0, 1 or 2, representing the 3 states 
    BRA state_2
    BTFSC FSR0L, 0; FSR0L=0001
    BRA state_1
state_0:
    BTFSC PORTB, 0
    BRA state_0
    BRA change_state
change_state:
    CLRF LATA
    BTFSC FSR0L, 1
    BRA is_final_state; if FSR0L=0010, goto is_final_state
    INCF FSR0L
    BRA check_state
    is_final_state:
	CLRF FSR0L
	BRA check_state
state_1:
    BSF LATA, 0
    lightup_1:
	BTFSC LATA, 3; check if current state is last state
	BRA is_last_1; if it is, goto is_last
	DELAY d'100', d'180' ;delay 0.5s
	RLCF LATA; rotate left with carry
	BTFSS PORTB, 0; check button before delay
	BRA change_state
	BRA lightup_1
    is_last_1:
	DELAY d'100', d'180' ;delay 0.5s
	CLRF LATA
	BRA state_1
state_2:
    BSF LATA, 3
    lightup_2:
	BTFSC LATA, 0; check if current state is last state
	BRA is_last_2; if it is, goto is_last
        DELAY d'100', d'180' ;delay 0.5s
	RRCF LATA; rotate left with carry
	BTFSS PORTB, 0; check button before delay
	BRA change_state
	BRA lightup_2
    is_last_2:
	DELAY d'100', d'180' ;delay 0.5s
	CLRF LATA
	BRA state_2
end