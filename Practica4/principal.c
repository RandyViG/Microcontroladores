/**@brief: Este programa muestra el uso del sensor de efecto Hall mediante
 * interrupciones, para contar cuantas veces se activa el sensor y mostrar 
 * el resultado en LCD.
 * @device: DSPIC30F4013
 * @oscillator: FRC, 7.3728MHz
 */
#include "p30F4013.h"
/********************************************************************************/
/* 						BITS DE CONFIGURACI?N									*/	
/********************************************************************************/
/* SE DESACTIVA EL CLOCK SWITCHING Y EL FAIL-SAFE CLOCK MONITOR (FSCM) Y SE 	*/
/* ACTIVA EL OSCILADOR INTERNO (FAST RC) PARA TRABAJAR							*/
/* FSCM: PERMITE AL DISPOSITIVO CONTINUAR OPERANDO AUN CUANDO OCURRA UNA FALLA 	*/
/* EN EL OSCILADOR. CUANDO OCURRE UNA FALLA EN EL OSCILADOR SE GENERA UNA 		*/
/* TRAMPA Y SE CAMBIA EL RELOJ AL OSCILADOR FRC  								*/
/********************************************************************************/
//_FOSC(CSW_FSCM_OFF & FRC); 
#pragma config FOSFPR = FRC             // Oscillator (Internal Fast RC (No change to Primary Osc Mode bits))
#pragma config FCKSMEN = CSW_FSCM_OFF   // Clock Switching and Monitor (Sw Disabled, Mon Disabled)/********************************************************************************/
/* SE DESACTIVA EL WATCHDOG														*/
/********************************************************************************/
//_FWDT(WDT_OFF); 
#pragma config WDT = WDT_OFF            // Watchdog Timer (Disabled)
/********************************************************************************/
/* SE ACTIVA EL POWER ON RESET (POR), BROWN OUT RESET (BOR), 					*/	
/* POWER UP TIMER (PWRT) Y EL MASTER CLEAR (MCLR)								*/
/* POR: AL MOMENTO DE ALIMENTAR EL DSPIC OCURRE UN RESET CUANDO EL VOLTAJE DE 	*/	
/* ALIMENTACI?N ALCANZA UN VOLTAJE DE UMBRAL (VPOR), EL CUAL ES 1.85V			*/
/* BOR: ESTE MODULO GENERA UN RESET CUANDO EL VOLTAJE DE ALIMENTACI?N DECAE		*/
/* POR DEBAJO DE UN CIERTO UMBRAL ESTABLECIDO (2.7V) 							*/
/* PWRT: MANTIENE AL DSPIC EN RESET POR UN CIERTO TIEMPO ESTABLECIDO, ESTO 		*/
/* AYUDA A ASEGURAR QUE EL VOLTAJE DE ALIMENTACI?N SE HA ESTABILIZADO (16ms) 	*/
/********************************************************************************/
//_FBORPOR( PBOR_ON & BORV27 & PWRT_16 & MCLR_EN ); 
// FBORPOR
#pragma config FPWRT  = PWRT_16          // POR Timer Value (16ms)
#pragma config BODENV = BORV20           // Brown Out Voltage (2.7V)
#pragma config BOREN  = PBOR_ON          // PBOR Enable (Enabled)
#pragma config MCLRE  = MCLR_EN          // Master Clear Enable (Enabled)
/********************************************************************************/
/*SE DESACTIVA EL C?DIGO DE PROTECCI?N											*/
/********************************************************************************/
//_FGS(CODE_PROT_OFF);      
// FGS
#pragma config GWRP = GWRP_OFF          // General Code Segment Write Protect (Disabled)
#pragma config GCP = CODE_PROT_OFF      // General Segment Code Protection (Disabled)

/********************************************************************************/
/* SECCI?N DE DECLARACI?N DE CONSTANTES CON DEFINE								*/
/********************************************************************************/
#define EVER 1
#define MUESTRAS 64

/********************************************************************************/
/* DECLARACIONES GLOBALES														*/
/********************************************************************************/
/*DECLARACI?N DE LA ISR DEL TIMER 1 USANDO __attribute__						*/
/********************************************************************************/
void __attribute__((__interrupt__)) _T1Interrupt( void );

/********************************************************************************/
/* CONSTANTES ALMACENADAS EN EL ESPACIO DE LA MEMORIA DE PROGRAMA				*/
/********************************************************************************/
int ps_coeff __attribute__ ((aligned (2), space(prog)));
/********************************************************************************/
/* VARIABLES NO INICIALIZADAS EN EL ESPACIO X DE LA MEMORIA DE DATOS			*/
/********************************************************************************/
int x_input[MUESTRAS] __attribute__ ((space(xmemory)));
/********************************************************************************/
/* VARIABLES NO INICIALIZADAS EN EL ESPACIO Y DE LA MEMORIA DE DATOS			*/
/********************************************************************************/
int y_input[MUESTRAS] __attribute__ ((space(ymemory)));
/********************************************************************************/
/* VARIABLES NO INICIALIZADAS LA MEMORIA DE DATOS CERCANA (NEAR), LOCALIZADA	*/
/* EN LOS PRIMEROS 8KB DE RAM													*/
/********************************************************************************/
int var1 __attribute__ ((near));

void iniPerifericos( void );
void iniInterrupciones( void );
void RETARDO1s( void );
void datoLCD( char );
void initLCD8bits( void );
void BFLCD( void );
void comandoLCD( short int );
char umi,cen,dece,uni;

int main (void){
    umi = 0;
    cen = 0;
    dece = 0;
    uni = 0;
    iniPerifericos();
    initLCD8bits();
    iniInterrupciones();
    
    for( ; EVER ; ){
        BFLCD();
        comandoLCD( 0x86 );     //Posición del cursor
        BFLCD();
        datoLCD( umi + 0x30 );
        BFLCD();
        datoLCD( cen + 0x30 );
        BFLCD();
        datoLCD( dece + 0x30 );
        BFLCD();
        datoLCD( uni + 0x30 );
        asm("nop");
    }
    
    return 0;
}
/****************************************************************************/
/* DESCRICION:	ESTA RUTINA INICIALIZA LAS INTERRPCIONES    				*/
/* PARAMETROS: NINGUNO                                                      */
/* RETORNO: NINGUNO															*/
/****************************************************************************/
void iniInterrupciones( void ){
    //Habilitacion de interrupcion del perif?rico 1
    //Sensor de efecto hall
    IFS1bits.INT1IF = 0;     //Apagando la bandera de la interrupción
    INTCON2bits.INT1EP = 0;  //Configurando detección de Flanco de subida
    IEC1bits.INT1IE = 1;     //Habilitando Interrupción
    //Habilitacion de interrupcion del perif?rico 2
    //Habilitacion de interrupcion del perif?rico 3
}
/****************************************************************************/
/* DESCRICION:	ESTA RUTINA INICIALIZA LOS PERIFERICOS						*/
/* PARAMETROS: NINGUNO                                                      */
/* RETORNO: NINGUNO															*/
/****************************************************************************/
void iniPerifericos( void ){
    PORTB = 0;
    asm("nop");
    LATB = 0;
    asm("nop");
    TRISB = 0;
    asm("nop");
    ADPCFG = 0XFFFF;
    
    PORTD = 0;
    asm("nop");
    LATD = 0;
    asm("nop");
    TRISD = 0;
    asm("nop");
    TRISDbits.TRISD8 = 1;   //sensor
}

/********************************************************************************/
/* DESCRICION:	ISR (INTERRUPT SERVICE ROUTINE) DEL TIMER 1						*/
/* LA RUTINA TIENE QUE SER GLOBAL PARA SER UNA ISR								*/	
/* SE USA PUSH.S PARA GUARDAR LOS REGISTROS W0, W1, W2, W3, C, Z, N Y DC EN LOS */
/* REGISTROS SOMBRA																*/
/********************************************************************************/
void __attribute__( (__interrupt__, no_auto_psv) ) _T1Interrupt( void ){
        IFS0bits.T1IF = 0;    //SE LIMPIA LA BANDERA DE INTERRUPCION DEL TIMER 1                      
}
