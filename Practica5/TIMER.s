.include "p30F4013.inc"
.GLOBAL _enLPOSC
    
_enLPOSC:
    PUSH	W0
    PUSH	W1
    PUSH	W2
    MOV		#0X46,		W0
    MOV		#0X57,		W1
    MOV		#OSCCONL,	W2
    MOV.B	W0,		[W2]
    MOV.B	W1,		[W2]
    BSET	OSCCONL,	#LPOSCEN
    POP		W2
    POP		W1
    POP		W0
    
    RETURN


