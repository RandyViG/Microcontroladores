.include "p30F4013.inc"
.GLOBAL _INT1Interrupt
    
_INT1Interrupt:
    PUSH	W0
    INC.B	_uni
    MOV		#10,	    W0
    CP.B	_uni
    BRA		NZ,	    FIN_ISR_INT1    ;Si z no es 0
    CLR.B	_uni
    
    INC.B	_dece
    CP.B	_dece
    BRA		NZ,	    FIN_ISR_INT1
    CLR.B	_dece
    
    INC.B	_cen
    CP.B	_cen
    BRA		NZ,	    FIN_ISR_INT1
    CLR.B	_cen
    
    INC.B	_umi
    CP.B	_umi
    BRA		NZ,	    FIN_ISR_INT1
    CLR.B	_umi
    
FIN_ISR_INT1:
    BCLR	IFS1,	    #INT1IF
    POP		W0
    RETFIE ;Restaura el sistema de interrupciones





