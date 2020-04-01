.include "p30F4013.inc"
.GLOBAL	_funcion1
.GLOBAL _funcion2
.GLOBAL _funcion3
.GLOBAL _funcion4
.GLOBAL _var		    ;Compartiendo la variable entre C y ensamblador
    
;** @brief: funcion1
;*  @param: ninguno
;*  @return: ninguno
_funcion1:
    PUSH    W2
    MOV	    _var,	w2
    ADD	    w2,		#3,	    w2
    POP	    W2
    return

;** @brief: funcion2
;*  @param: ninguno
;*  @return: W0, la suma entre W1 y W2
_funcion2:
    PUSH    W1
    MOV	    #8,		W0
    MOV	    #10,	W1
    ADD	    W0,		W1,	    W0	
    ;El primer registro de la arquitectura es el que se retorna por defecto 
    POP	    W1
    return

;** @brief: funcion3
;*  @param: W0, n1 a sumar
;*  @param: W1, n2 a sumar
;*  @return: W0, la suma entre n1 y n2
_funcion3:
    PUSH    W1
    ADD	    W0,		W1,	    W0
    POP	    W1
    return

;** @brief: funcion3
;*  @param: W0, direccion del primer elemento deL arreglo
;*  @return: W0, tamaño de la cadena
_funcion4:
    PUSH    W1
    PUSH    W2 
    CLR	    W2
    CICLO:
    MOV.B   [W0++],	W1
    CP0.B   W1			;Comparando con NULO
    BRA	    Z,		FIN	
    INC	    W2,		W2
    GOTO    CICLO
FIN:
    MOV	    W2,		W0
    POP	    W2
    POP	    W1
    return 

