.include "p30F4013.inc"
.GLOBAL __T1Interrupt
.GLOBAL _uSeg
.GLOBAL _dSeg
.GLOBAL _uMin
.GLOBAL _dMin
.GLOBAL _uHr
.GLOBAL _dHr
    
__T1Interrupt:
    PUSH	W0
    INC.B	_uSeg
    MOV		#10,	    W0
    CP.B	_uSeg
    BRA		NZ,	    FIN_ISR_INT1    ;Si z no es 0
    CLR.B	_uSeg
    
    INC.B	_dSeg
    MOV		#6,	    W0
    CP.B	_dSeg
    BRA		NZ,	    FIN_ISR_INT1
    CLR.B	_dSeg
    
    INC.B	_uMin
    MOV		#10,	    W0
    CP.B	_uMin
    BRA		NZ,	    FIN_ISR_INT1
    CLR.B	_uMin
    
    INC.B	_dMin
    MOV		#6,	    W0
    CP.B	_dMin
    BRA		NZ,	    FIN_ISR_INT1
    CLR.B	_dMin
    
    MOV		#2,	    W0
    CP.B	_dHr
    BRA		Z,	    HR_FINAL
        
    INC.B	_uHr
    MOV		#10,	    W0
    CP.B	_uHr
    BRA		NZ,	    FIN_ISR_INT1
    CLR.B	_uHr
    
    INC.B	_dHr
    
    
FIN_ISR_INT1:
    BCLR	IFS0,	    #T1IF
    POP		W0
    
    RETFIE

HR_FINAL:
    INC.B	_uHr
    MOV		#4,	    W0
    CP.B	_uHr
    BRA		NZ,	    FIN_ISR_INT1
    CLR.B	_uHr
    CLR.B	_dHr
    GOTO	FIN_ISR_INT1

