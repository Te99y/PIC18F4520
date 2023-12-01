#include"xc.inC"
GLOBAL _is_square

PSECT mytext, local, class=CODE, reloc=2

_is_square:
    LFSR 0, 0x00; as counter from 1 to 16
    MOVWF 0x01; move input from WREG to 0x01
    loop:
	INCF FSR0L
	BTFSC FSR0L, 4; 16*16 > 255, dont need further checking
	RETLW 0xFF; return false when we reach the end, FSR0L=16
	MOVF FSR0L, 0
	MULWF FSR0L; calculate square of FRS0L in WREG
	MOVF PRODL, 0
	CPFSEQ 0x01
	GOTO loop
    RETLW 0x01