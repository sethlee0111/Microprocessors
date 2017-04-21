	.global __stack
__stack:

; why ADDR[9:2]
; is ff right for 8mA
;------------------------------------------------
;		.data
;------------------------------------------------
GPIO_BASE			.equ	0x40000000
NVIC_BASE			.equ	0xe0000000
RCGCGPIO			.equ	0x608
RCGC2				.equ	0x108
GPIOHBCTL			.equ	0x06C
GPIODIR				.equ	0x400
GPIOAFSEL			.equ	0x420
GPIOPUR				.equ	0x510
GPIODEN				.equ	0x51C
GPIOAMSEL			.equ	0x528
GPIOPCTL			.equ	0x52C
GPIOLOCK			.equ	0x520
GPIOCR				.equ	0x524

GPIODR8R			.equ	0x508

GPIODATA			.equ	0x000
EN3					.equ	0x10C
GPIOIM				.equ	0x410
GPIOICR				.equ	0x41C

SW_UP				.equ	0x1E ; 00011110
SW_DOWN				.equ	0x1D
SW_LEFT				.equ	0x1B
SW_RIGHT			.equ	0x17
SW_CLEAR			.equ	0x0F
;--------------------------------------------------
             .text                           ; Program Start
             .global RESET                   ; Define entry point
             .align	4
			 .sect ".text"
; SKKU embedded systems LAB.
; modified by Seth Lee
;------------------------------------------------
;			switch initializition
;------------------------------------------------

Switch_Init:

		mov r0, #GPIO_BASE	;RCGC : General-Purpose Input/Output Run Mode Clock Gating Control
		mov r1, #0xFE000 ; Base
		add r1, r1, r0
		mov r0, #RCGCGPIO ; Offset - RCGC2 instead of RCGCGPIO
		add r1, r1, r0

		ldr r0, [r1]
		orr r0, r0, #0x800 ; 1000 0100 0000 enable R11(GPIO Port M), enable R6(GPIO Port G)
		str r0, [r1]
		nop
		nop

		mov r0, #GPIO_BASE	;RCGC : General-Purpose Input/Output Run Mode Clock Gating Control
		mov r1, #0xFE000 ; Base
		add r1, r1, r0
		mov r0, #RCGC2 ; Offset - RCGC2 instead of RCGCGPIO
		add r1, r1, r0

		ldr r0, [r1]
		orr r0, r0, #0x040 ; 1000 0100 0000 enable R11(GPIO Port M), enable R6(GPIO Port G)
		str r0, [r1]
		nop
		nop

		mov r0, #GPIO_BASE	;HBCTL : High-Performance Bus Control
		mov r1, #0xFE000
		add r1, r1, r0
		mov r0, #GPIOHBCTL
		add r1, r1, r0

		mov r0, #0x800 ; 1000 0100 0000 enable R11(GPIO Port M), enable R6(GPIO Port G)
		str r0, [r1]
		nop
		nop

		; PORTM DATADIR SET
		mov r0, #GPIO_BASE	;DIR
		mov r1, #0x63000 ;PORT M
		add r1, r1, r0
		mov r0, #GPIODIR
		add r1, r1, r0

		ldr r0, [r1]
		bic r0, r0, #0x1f ; 0001 1111
		str r0, [r1]

		; PORTG DATADIR SET
		mov r0, #GPIO_BASE	;DIR
		mov r1, #0x26000 ;PORT G(APB)
		add r1, r1, r0
		mov r0, #GPIODIR
		add r1, r1, r0

		ldr r0, [r1]
		orr r0, r0, #0x04 ; 0000 0100 ORR (1: output)
		str r0, [r1]

		; PORT_M AFSEL
		mov r0, #GPIO_BASE	;AFSEL : Alternate Function Select
		mov r1, #0x63000
		add r1, r1, r0
		mov r0, #GPIOAFSEL
		add r1, r1, r0

		ldr r0, [r1]
		bic r0, r0, #0x1f ; turn off special functions
		str r0, [r1]

		;PORT_G AFSEL
		mov r0, #GPIO_BASE	;AFSEL : Alternate Function Select
		mov r1, #0x26000
		add r1, r1, r0
		mov r0, #GPIOAFSEL
		add r1, r1, r0

		ldr r0, [r1]
		bic r0, r0, #0x04 ; turn off special functions
		str r0, [r1]

		; PORTG GPIODR8R SET (8-mA Drive)
		mov r0, #GPIO_BASE	;DIR
		mov r1, #0x26000 ;PORT G(APB)
		add r1, r1, r0
		mov r0, #GPIODR8R
		add r1, r1, r0

		ldr r0, [r1]
		orr r0, r0, #0x00 ; 1111 1111 ORR
		str r0, [r1]


		mov r0, #GPIO_BASE	;PUR
		mov r1, #0x63000
		add r1, r1, r0
		mov r0, #GPIOPUR
		add r1, r1, r0

		ldr r0, [r1]
		orr r0, r0, #0x1f
		str r0, [r1]

		mov r0, #GPIO_BASE	;PUR
		mov r1, #0x26000
		add r1, r1, r0
		mov r0, #GPIOPUR
		add r1, r1, r0

		ldr r0, [r1]
		orr r0, r0, #0x04
		str r0, [r1]

		;PORT_M Data Enable
		mov r0, #GPIO_BASE	;DEN
		mov r1, #0x63000
		add r1, r1, r0
		mov r0, #GPIODEN
		add r1, r1, r0

		ldr r0, [r1]
		orr r0, r0, #0x1f
		str r0, [r1]

		;Port_G Data Enable
		mov r0, #GPIO_BASE	;DEN
		mov r1, #0x26000
		add r1, r1, r0
		mov r0, #GPIODEN
		add r1, r1, r0

		ldr r0, [r1]
		orr r0, r0, #0x04
		str r0, [r1]

		mov r0, #GPIO_BASE	;AMSEL : Analog Mode Select
		mov r1, #0x63000
		add r1, r1, r0
		mov r0, #GPIOAMSEL
		add r1, r1, r0

		mov r0, #0
		str r0, [r1]


		mov r0, #GPIO_BASE	;PCTL : Port Control
		mov r1, #0x63000
		add r1, r1, r0
		mov r0, #GPIOPCTL
		add r1, r1, r0

		ldr r0, [r1]
		orr r0, r0, #0x1f;#0x000f000f
		str r0, [r1]

		mov r0, #GPIO_BASE	;LOCK
		mov r1, #0x63000
		add r1, r1, r0
		mov r0, #GPIOLOCK
		add r1, r1, r0

		mov r0, #GPIO_BASE
		mov r2, #0xc400000
		add r2, r2, r0
		mov r0, #0xf4000
		add r2, r2, r0
		mov r0, #0x34b
		add r2, r2, r0

		ldr r0, [r1]
		orr r0, r0, r2
		str r0, [r1]


		mov r0, #GPIO_BASE	;CR
		mov r1, #0x63000
		add r1, r1, r0
		mov r0, #GPIOCR
		add r1, r1, r0

		ldr r0, [r1]
		mov r2, #0x00000000
		bic r0, r0, r2
		str r0, [r1]


Switch_Input:

		mov r7, #GPIO_BASE
		mov r1, #0x63000
		add r1, r1, r7
		mov r7, #0x7C ; 01-11 11/00
		add r1, r1, r7

		ldr r7, [r1]


Input_Loop:	MOV r3, #0xff
		LSL r3, #1

_DELAY_LOOP:
		CBZ r3,_DELAY_EXIT		;Compare and Branch on Zero
		sub r3,r3,#1
		B _DELAY_LOOP
_DELAY_EXIT:

		mov r7, #GPIO_BASE
		mov r1, #0x63000
		add r1, r1, r7
		mov r7, #0x7C ; 01-11 11/00
		add r1, r1, r7

		ldr r7, [r1]

		cmp r7, #SW_UP
		BEQ _up

		cmp r7, #SW_DOWN
		BEQ _down

		cmp r7, #SW_LEFT
		BEQ _left

		cmp r7, #SW_RIGHT
		BEQ _right

		;cmp r7, #SW_CLEAR
		;BEQ _clear

		b Input_Loop

_up:
		mov r6, #1
		bl Led_On
		b Input_Loop

_down:
		mov r6, #2
		bl Led_Off
		b Input_Loop

_left:
		mov r10, #5
		bl Slow_Blink
		b Input_Loop

_right:
		mov r10, #5
		bl Fast_Blink
		b Input_Loop

_clear:
		mov r6, #5
		b _EXIT

_EXIT:
		b Input_Loop

Led_Off:
		; LED off
		mov r3, #GPIO_BASE
		mov r1, #0x26000
		add r1, r1, r3
		mov r3, #GPIODATA
		add r1, r1, r3

		add r1, #0x10

		ldr r3, [r1]
		bic r3, r3, #0x04
		str r3, [r1]

		bx lr

Led_On:
		; LED on
		mov r3, #GPIO_BASE
		mov r1, #0x26000
		add r1, r1, r3
		mov r3, #GPIODATA
		add r1, r1, r3

		add r1, #0x10

		ldr r3, [r1]
		orr r3, r3, #0x04
		str r3, [r1]

		bx lr

Fast_Blink:
		SUB r10, #2 ; speed factor
Slow_Blink:

		PUSH {LR}
		cmp r6, #1
		BEQ FirstOff
BlinkStart:
		MOV r4, #0x06
Slow_Blink_Loop:
		SUB r4, #1
		CMP r4, #0
		BEQ Slow_Blink_EXIT
		bl Led_On
		b Slow_Delay
_Blink_Out:
		bl Led_Off
		b Slow_Delay2

Slow_Delay:
		MOV r5, #0xffff
		LSL r5, r10
Slow_Delay_Loop:
		sub r5,r5,#1
		CMP r5, #0		;Compare and Branch on Zero
		BEQ _Blink_Out
		B Slow_Delay_Loop

Slow_Delay2:
		MOV r5, #0xffff
		LSL r5, r10
Slow_Delay2_Loop:
		sub r5,r5,#1
		CMP r5, #0		;Compare and Branch on Zero
		BEQ Slow_Blink_Loop
		B Slow_Delay2_Loop

Slow_Blink_EXIT:
		POP {LR}
		bx lr

FirstOff:
		bl Led_Off
		MOV r5, #0xffff
		LSL r5, r10
delayLoop:
		sub r5,r5,#1
		CMP r5, #0		;Compare and Branch on Zero
		BEQ LoopOut
		B delayLoop
LoopOut:
		b BlinkStart


			.retain
			.retainrefs
