.include "p30F4013.inc"
.GLOBAL __U1RXInterrupt
.GLOBAL _dato
.GLOBAL _drcv
    
;** @brief: Recibe un Dato 
;*  @param: W0 tiene el dato recibido
;*  @return: ninguno ( void )
__U1RXInterrupt:
    PUSH    W0
    CLR	    W0
    MOV	    U1RXREG,	    W0
    MOV.B   WREG,	    _dato
    MOV	    #1,		    _drcv
    BCLR    IFSO,	    #U1RXIF
    POP	    W0
    
    RETFIE
    
    
