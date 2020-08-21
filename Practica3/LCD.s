.include "p30F4013.inc"
.GLOBAL	_datoLCD
.GLOBAL	_comandoLCD
.GLOBAL _BFLCD
.GLOBAL _initLCD8bits
    
.EQU	RS_LCD,	    RD0
.EQU	RW_LCD,	    RD1	    
.EQU	E_LCD,	    RD2
.EQU	BF_LCD,	    RB7
    
;** @brief: Manda un dato al LCD
;*  @param: W0 tiene el dato a enviar
;*  @return: ninguno ( void )
_datoLCD:
    BSET	PORTD,		#RS_LCD
    NOP
    BCLR	PORTD,		#RW_LCD
    NOP
    BSET	PORTD,		#E_LCD
    NOP
    MOV.B	WREG,		PORTB
    NOP
    BCLR	PORTD,		#E_LCD
    NOP
    
    RETURN	
    
;/**@brief: Esta rutina manda un comando en W0 al LCD
;/* @param: No recibe parametos
;/* @return: No retorna nada  
_comandoLCD:
    BSET	PORTD,		#RS_LCD
    BCLR	PORTD,		#RW_LCD
    NOP
    BSET	PORTD,		#E_LCD
    NOP
    MOV.B	WREG,		PORTB
    BCLR	PORTD,		#E_LCD
    
    RETURN

;/**@brief Esta rutina pregunta por el valor de busy flag
;/* @param: No recibe parametos
;/* @return: No retorna nada  
_BFLCD:
    PUSH	W1
    PUSH	W2
    MOV		#0X00FF,	W1
    MOV		TRISB,		W2
    IOR		W2,		W1,	    W2
    MOV		W2,		TRISB
    NOP
    BCLR	PORTD,		#RS_LCD
    NOP
    BSET	PORTD,		#RW_LCD
    NOP
    BSET	PORTD,		#E_LCD
    NOP

BUSY:
    BTSC	PORTB,		#BF_LCD
    GOTO	BUSY
    
    BCLR	PORTD,		#E_LCD
    BCLR	PORTD,		#RW_LCD
    MOV		#0XFF00,	W1
    MOV		TRISB,		W2
    NOP
    AND		W1,		W2,	    W1
    POP		W2
    POP		W1
    
    RETURN

;/**@brief Eesta rutina inicializa el LCD en 8 bits
;/* @param: No recibe parametos
;/* @return: No retorna nada  
_initLCD8bits:
    PUSH	W0
    CALL	_RETARDO15ms
    MOV		#0X30,		W0
    CALL	_comandoLCD
    CALL	_RETARDO15ms
    MOV		#0X30,		W0
    CALL	_comandoLCD
    CALL	_RETARDO15ms
    MOV		#0X30,		W0
    CALL	_comandoLCD
    CALL	_BFLCD
    MOV		#0X38,		W0
    CALL	_comandoLCD
    CALL	_BFLCD
    MOV		#0X08,		W0
    CALL	_comandoLCD
    CALL	_BFLCD
    MOV		#0X01,		W0
    CALL	_comandoLCD
    CALL	_BFLCD
    MOV		#0X06,		W0
    CALL	_comandoLCD
    CALL	_BFLCD
    MOV		#0X0F,		W0
    CALL	_comandoLCD
    POP		W0
    
    RETURN
    
