;-------------------------------------------------------------------------------
;
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
         bis.w #GIE,SR

        ;mov.w #1832, R15           ; load R15 with value for delay
        ;mov.b #00000000b,&P1SEL    ; select GPIO
         mov.b #01000001b,&P1DIR    ; Set bit0 and bit6 in port1 as output
         mov.b #11111111b,&P1OUT    ; Set Pullup
         mov.b #10111100b,&P1REN    ; Enable pullup or pulldown resistor || turn on green led



start:      and.b #00001000b,&P1IN  ;Mask off bit3
            ;bic.b #01000000b, &P1OUT
            bic.b #00000001b,&P1OUT ; clear bit0
            bis.b #01000000b,&P1OUT ; set bit6
            jz press
            jmp start

press:
            bic.b #008h,&P1IFG      ;IFG cleared
            bic.b #01000000b,&P1OUT ; clear bit6
            bis.b #00000001b,&P1OUT ; set bit0


Loop        dec.w   R15                     ; decrease R15 value
            jnz     Loop                    ; if R15 is not zero jump to Loop
            jmp     start





;--------------------------------------------------------------------
; UNEXPECTED_ISR - default handler for unhandled interrupt
;--------------------------------------------------------------------
;UNEXPECTED_ISR:
 ;reti                    ; cycles: 5
;-------------------------------------------------------------------------------
; Stack Pointer definition
;------------------------------------------------------------  -------------------
            .global __STACK_END
            .sect   .stack

;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            .sect   ".int02"
            .short  press
            .end
