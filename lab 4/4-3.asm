List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
;	MOVLW 0x03; n
;	MOVWF 0x0A
;	MOVLW 0x03; k
;	MOVWF 0x0B
;	LFSR 0, 0x0A
;	LFSR 1, 0x0B
;	RCALL Fact
;	GOTO fin
;	Fact:
;	    MOVLW 1
;	    CPFSGT INDF1; if k is no greater then 1 that means k=0 or 1, which is when we should stop
;	    GOTO endcase_0
;	    MOVF INDF0, 0; check if k=n
;	    CPFSEQ INDF1; goto iter if not, goto endcase_n if k=n
;	    GOTO iter
;	    GOTO endcase_n
;	endcase_0:
;	    TSTFSZ INDF1; if k=0, stay, else, move to other cases
;	    GOTO endcase_1
;	    INCF 0x00
;	    RETURN
;	endcase_1:
;	    MOVF INDF0, 0
;	    ADDWF 0x00, 1
;	    RCALL pop_both
;	    RETURN
;	endcase_n:
;	    INCF 0x00
;	    RCALL pop_both
;	    RETURN
;	iter:
;	    ; left child
;	    RCALL push_n; push n in stack and -1 for next iter
;	    DECF INDF0
;	    RCALL push_k; push k in stack and -1 for next iter
;	    DECF INDF1
;	    RCALL Fact
;	    ; right child
;	    RCALL push_n
;	    DECF INDF0
;	    RCALL push_k
;	    RCALL Fact
;	    RCALL pop_both
;	    RETURN
;	push_n:
;	    MOVF INDF0, 0; push n in stack
;	    INCF FSR0L
;	    INCF FSR0L
;	    MOVWF INDF0
;	    RETURN
;	push_k:
;	    MOVF INDF1, 0; push k in stack
;	    INCF FSR1L
;	    INCF FSR1L
;	    MOVWF INDF1
;	    RETURN
;	pop_both:
;	    DECF FSR0L
;	    DECF FSR0L
;	    DECF FSR1L
;	    DECF FSR1L
;	    RETURN
;	fin:
;	    NOP
;	end
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; before push-pop bacame a subroutine ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	LFSR 0, 0x0A
	LFSR 1, 0x0B
	BTFSS 0xDC, 0
	MOVLW 0x03; n
	MOVWF 0x0A
	MOVLW 0x03; k
	MOVWF 0x0B
	
	
;	ORG 0x20
;	DW 0702H, 123FH, 1110H, 2021H
;	MOVLW 1
;	MOVWF 0x00
;	NEGF 0x00
;	MOVWF 0x01
;	ADDWF 0x00, 1
	
	RCALL Fact
	goto fin
	
	Fact:
	    MOVLW 1
	    CPFSGT INDF1; if k is no greater then 1 that means k=0 or 1, which is when we should stop
	    GOTO endcase_0
	    MOVF INDF0, 0; check if k=n
	    CPFSEQ INDF1; goto iter if not, goto endcase_n if k=n
	    GOTO iter
	    GOTO endcase_n
	endcase_0:
	    TSTFSZ INDF1; if k=0, stay, else, move to other cases
	    GOTO endcase_1
	    INCF 0x00; 0x00
	    RETURN
	endcase_1:
	    MOVF INDF0, 0
	    ADDWF 0x00, 1; 0x00
	    DECF FSR0L
	    DECF FSR0L
	    DECF FSR1L
	    DECF FSR1L
	    RETURN
	endcase_n:
	    INCF 0x00; 0x00
	    DECF FSR0L
	    DECF FSR0L
	    DECF FSR1L
	    DECF FSR1L
	    RETURN
	iter:
	    ; left child
	    MOVF INDF0, 0; push n in stack and -1 for next iter
	    INCF FSR0L
	    INCF FSR0L
	    MOVWF INDF0
	    DECF INDF0
	    MOVF INDF1, 0; push k in stack and -1 for next iter
	    INCF FSR1L
	    INCF FSR1L
	    MOVWF INDF1
	    DECF INDF1
	    RCALL Fact
	    ; right child
	    MOVF INDF0, 0; push n in stack and -1
	    INCF FSR0L
	    INCF FSR0L
	    MOVWF INDF0
	    DECF INDF0
	    MOVF INDF1, 0; push k in stack
	    INCF FSR1L
	    INCF FSR1L
	    MOVWF INDF1
	    RCALL Fact
	    DECF FSR0L
	    DECF FSR0L
	    DECF FSR1L
	    DECF FSR1L
	    RETURN
	fin: 
	end
	