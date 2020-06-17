.include "p30F4013.inc"
.GLOBAL _RETARDO1s
.GLOBAL _RETARDO15ms
    
;/**@brief: ESTA RUTINA GENERA UN RETARDO APROXIMADO DE 1S
;/* @param: No recibe parametos
;/* @return: No retorna nada  
;/*
_RETARDO1s:
	PUSH	W0
	PUSH	W1
	MOV	#9,		W1

CICLO2_1S:				;REALIZA 6535 VECES
	CLR	W0			;PONE EN 0 PARA QUE EL DEC SEA -1 Y SEA EL REG  EN F

CICLO1_1S:	
	DEC	W0,		W0
	BRA	NZ,		CICLO1_1S

	DEC	W1,		W1
	BRA	NZ,		CICLO2_1S

	POP	W1
	POP	W0
	RETURN
	
;/**@brief ESTA RUTINA GENERA UN RETARDO APROXIMADO DE 15ms
;/* @param: No recibe parametos
;/* @return: No retorna nada  
;/*	
_RETARDO15ms:
	PUSH	W0
	PUSH	W1
	MOV	#9,		w1

.CICLO2_1S:
	CLR	W0

.CICLO1_1S:	
	DEC	W0,		W0
	BRA	NZ,		.CICLO1_1S

	DEC	W1,		W1
	BRA	NZ,		.CICLO2_1S

	POP	W1
	POP	W0
	RETURN





