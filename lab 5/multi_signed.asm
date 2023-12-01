#include"xc.inC"
GLOBAL _multi_signed

PSECT mytext, local, class=CODE, reloc=2

_multi_signed:
    MOVFF 0x01, 0x11; move multiplier to 0x11
    MOVWF 0x12; move  multiplicant to 0x12
    MOVFF 0x01, 0x13; make a copy of multiplier
    CLRF 0x01; output init = 0
    loop:
	TSTFSZ 0x11
	GOTO add
	GOTO fin
    add:
	DECF 0x11
	MOVF 0x12, 0
	ADDWF 0x01, 1
	BTFSC STATUS, 0
	INCF 0x02
	GOTO loop
    fin:
	MOVF 0x12, 0; subtract 0x12 from higher bits if 0x13 is negative
	BTFSC 0x13, 7
	SUBWF 0x02, 1
	MOVF 0x13, 0
	BTFSC 0x12, 7
	SUBWF 0x02, 1
	RETURN
 
 
	
	
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; for some reason i implemented another version ;
; where we change the signs first before adding ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;_multi_signed:
;    MOVFF 0x01, 0x11; move multiplier to 0x11
;    MOVFF 0x01, 0x21; make a copy of multiplier
;    MOVWF 0x12; move  multiplicant to 0x12
;    CLRF 0x01; output init = 0
;    BTFSS 0x11, 7; negate 0x12 and 0x11 if 0x11 is negative, we need 0x11>0
;    GOTO loop; if 0x11 is possitive just go to loop
;    NEGF 0x11, 1
;    NEGF 0x21, 1
;    NEGF 0x12, 1
;    loop:
;	TSTFSZ 0x11
;	GOTO add
;    check_sign:
;	MOVF 0x21, 0; only need to check if 0x12<0, since 0x11 must >=0
;	BTFSC 0x12, 7
;	SUBWF 0x02, 1
;	RETURN
;    add:
;	DECF 0x11
;	MOVF 0x12, 0
;	ADDWF 0x01, 1
;	BTFSC STATUS, 0
;	INCF 0x02
;	GOTO loop

