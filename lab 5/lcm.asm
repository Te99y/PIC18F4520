#include"xc.inC"
GLOBAL _lcm

PSECT mytext, local, class=CODE, reloc=2

_lcm:
    MOVFF 0x01, 0x11; copy a to 0x11
    MOVFF 0x03, 0x13; copy b to 0x13
    TSTFSZ 0x01; if a=0 or b=0 just goto end
    GOTO compare_high
    GOTO zero_case
    TSTFSZ 0x03
    GOTO compare_high
    GOTO zeros_case
    compare_high:
	MOVF 0x02, 0
	CPFSLT 0x04; if 0x04<0x02 goto add b
	GOTO equal_1
	GOTO add_b
	equal_1:
	    CPFSEQ 0x04; skip if 0x04=0x02
	    GOTO add_a; this means 0x04>0x02
    compare_low:
	MOVF 0x01, 0
	CPFSLT 0x03; if 0x03<0x01 goto add b
	GOTO equal_2
	GOTO add_b
	equal_2:
	    CPFSEQ 0x03; skip if 0x03=0x01
	    GOTO add_a; this means 0x03>0x01
	    RETURN
    add_b:
	MOVF 0x14, 0
	ADDWF 0x04, 1
	MOVF 0x13, 0
	ADDWF 0x03, 1
	BTFSC STATUS, 0
	INCF 0x04
	GOTO compare_high
    add_a:
	MOVF 0x12, 0
	ADDWF 0x02, 1
	MOVF 0x11, 0
	ADDWF 0x01, 1
	BTFSC STATUS, 0
	INCF 0x02
	GOTO compare_high
    zero_case:
	CLRF 0x01
	RETURN
	