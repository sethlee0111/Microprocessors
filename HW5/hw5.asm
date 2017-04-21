; SKKU embedded systems LAB.
; modified by Seth Lee

	.global __stack
__stack:

;Inside the Interrupt Handler function, is it okay to query GPIODATA?(stale data)
;oxoo Error, why?
;Warnings. How to fix them?
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
GPIOIBE				.equ	0x408

SW_UP				.equ	0x1E ; 00011110
SW_DOWN				.equ	0x1D
SW_LEFT				.equ	0x1B
SW_RIGHT			.equ	0x17
SW_CLEAR			.equ	0x0F

TIMER0_1632			.equ	0x30000
;--------------------------------------------------

;------------------------------------------------------------------------------
            			 ; Interrupt Vectors
;------------------------------------------------------------------------------
						.sect	".intvecs"
						.align	4
						.field	IntDefaultHandler,32		; g_pfnVectors[0] @ 0
						.field	IntDefaultHandler,32		; g_pfnVectors[1] @ 32
						.field	IntDefaultHandler,32		; g_pfnVectors[2] @ 64
						.field	IntDefaultHandler,32		; g_pfnVectors[3] @ 96
						.field	IntDefaultHandler,32		; g_pfnVectors[4] @ 128
						.field	IntDefaultHandler,32		; g_pfnVectors[5] @ 160
						.field	IntDefaultHandler,32		; g_pfnVectors[6] @ 192
						.field	0,32			; g_pfnVectors[7] @ 224
						.field	0,32			; g_pfnVectors[8] @ 256
						.field	0,32			; g_pfnVectors[9] @ 288
						.field	0,32			; g_pfnVectors[10] @ 320
						.field	IntDefaultHandler,32		; g_pfnVectors[11] @ 352
						.field	IntDefaultHandler,32		; g_pfnVectors[12] @ 384
						.field	0,32			; g_pfnVectors[13] @ 416
						.field	IntDefaultHandler,32		; g_pfnVectors[14] @ 448
						.field	IntDefaultHandler,32		; g_pfnVectors[15] @ 480
						.field	IntDefaultHandler,32		; g_pfnVectors[16] @ 512
						.field	IntDefaultHandler,32		; g_pfnVectors[17] @ 544
						.field	IntDefaultHandler,32		; g_pfnVectors[18] @ 576
						.field	IntDefaultHandler,32		; g_pfnVectors[19] @ 608
						.field	IntDefaultHandler,32		; g_pfnVectors[20] @ 640
						.field	IntDefaultHandler,32		; g_pfnVectors[21] @ 672
						.field	IntDefaultHandler,32		; g_pfnVectors[22] @ 704
						.field	IntDefaultHandler,32		; g_pfnVectors[23] @ 736
						.field	IntDefaultHandler,32		; g_pfnVectors[24] @ 768
						.field	IntDefaultHandler,32		; g_pfnVectors[25] @ 800
						.field	IntDefaultHandler,32		; g_pfnVectors[26] @ 832
						.field	IntDefaultHandler,32		; g_pfnVectors[27] @ 864
						.field	IntDefaultHandler,32		; g_pfnVectors[28] @ 896
						.field	IntDefaultHandler,32		; g_pfnVectors[29] @ 928
						.field	IntDefaultHandler,32		; g_pfnVectors[30] @ 960
						.field	IntDefaultHandler,32		; g_pfnVectors[31] @ 992
						.field	IntDefaultHandler,32		; g_pfnVectors[32] @ 1024
						.field	IntDefaultHandler,32		; g_pfnVectors[33] @ 1056
						.field	IntDefaultHandler,32		; g_pfnVectors[34] @ 1088
						.field	IntTimer0AHandler,32		; g_pfnVectors[35] @ 1120
						.field	IntDefaultHandler,32		; g_pfnVectors[36] @ 1152
						.field	IntDefaultHandler,32		; g_pfnVectors[37] @ 1184
						.field	IntDefaultHandler,32		; g_pfnVectors[38] @ 1216
						.field	IntDefaultHandler,32		; g_pfnVectors[39] @ 1248
						.field	IntDefaultHandler,32		; g_pfnVectors[40] @ 1280
						.field	IntDefaultHandler,32		; g_pfnVectors[41] @ 1312
						.field	IntDefaultHandler,32		; g_pfnVectors[42] @ 1344
						.field	IntDefaultHandler,32		; g_pfnVectors[43] @ 1376
						.field	IntDefaultHandler,32		; g_pfnVectors[44] @ 1408
						.field	IntDefaultHandler,32		; g_pfnVectors[45] @ 1440
						.field	IntDefaultHandler,32		; g_pfnVectors[46] @ 1472
						.field	IntDefaultHandler,32		; g_pfnVectors[47] @ 1504
						.field	IntDefaultHandler,32		; g_pfnVectors[48] @ 1536
						.field	IntDefaultHandler,32		; g_pfnVectors[49] @ 1568
						.field	IntDefaultHandler,32		; g_pfnVectors[50] @ 1600
						.field	IntDefaultHandler,32		; g_pfnVectors[51] @ 1632
						.field	IntDefaultHandler,32		; g_pfnVectors[52] @ 1664
						.field	IntDefaultHandler,32		; g_pfnVectors[53] @ 1696
						.field	IntDefaultHandler,32		; g_pfnVectors[54] @ 1728
						.field	IntDefaultHandler,32		; g_pfnVectors[55] @ 1760
						.field	IntDefaultHandler,32		; g_pfnVectors[56] @ 1792
						.field	IntDefaultHandler,32		; g_pfnVectors[57] @ 1824
						.field	0,32			; g_pfnVectors[58] @ 1856
						.field	IntDefaultHandler,32		; g_pfnVectors[59] @ 1888
						.field	IntDefaultHandler,32		; g_pfnVectors[60] @ 1920
						.field	IntDefaultHandler,32		; g_pfnVectors[61] @ 1952
						.field	IntDefaultHandler,32		; g_pfnVectors[62] @ 1984
						.field	IntDefaultHandler,32		; g_pfnVectors[63] @ 2016
						.field	IntDefaultHandler,32		; g_pfnVectors[64] @ 2048
						.field	IntDefaultHandler,32		; g_pfnVectors[65] @ 2080
						.field	IntDefaultHandler,32		; g_pfnVectors[66] @ 2112
						.field	IntDefaultHandler,32		; g_pfnVectors[67] @ 2144
						.field	0,32			; g_pfnVectors[68] @ 2176
						.field	0,32			; g_pfnVectors[69] @ 2208
						.field	IntDefaultHandler,32		; g_pfnVectors[70] @ 2240
						.field	IntDefaultHandler,32		; g_pfnVectors[71] @ 2272
						.field	IntDefaultHandler,32		; g_pfnVectors[72] @ 2304
						.field	IntDefaultHandler,32		; g_pfnVectors[73] @ 2336
						.field	IntDefaultHandler,32		; g_pfnVectors[74] @ 2368
						.field	IntDefaultHandler,32		; g_pfnVectors[75] @ 2400
						.field	IntDefaultHandler,32		; g_pfnVectors[76] @ 2432
						.field	IntDefaultHandler,32		; g_pfnVectors[77] @ 2464
						.field	IntDefaultHandler,32		; g_pfnVectors[78] @ 2496
						.field	IntDefaultHandler,32		; g_pfnVectors[79] @ 2528
						.field	0,32			; g_pfnVectors[80] @ 2560
						.field	0,32			; g_pfnVectors[81] @ 2592
						.field	0,32			; g_pfnVectors[82] @ 2624
						.field	0,32			; g_pfnVectors[83] @ 2656
						.field	IntDefaultHandler,32		; g_pfnVectors[84] @ 2688
						.field	IntDefaultHandler,32		; g_pfnVectors[85] @ 2720
						.field	IntDefaultHandler,32		; g_pfnVectors[86] @ 2752
						.field	IntDefaultHandler,32		; g_pfnVectors[87] @ 2784
						.field	0,32			; g_pfnVectors[88] @ 2816
						.field	0,32			; g_pfnVectors[89] @ 2848
						.field	0,32			; g_pfnVectors[90] @ 2880
						.field	0,32			; g_pfnVectors[91] @ 2912
						.field	0,32			; g_pfnVectors[92] @ 2944
						.field	0,32			; g_pfnVectors[93] @ 2976
						.field	0,32			; g_pfnVectors[94] @ 3008
						.field	0,32			; g_pfnVectors[95] @ 3040
						.field	0,32			; g_pfnVectors[96] @ 3072
						.field	0,32			; g_pfnVectors[97] @ 3104
						.field	0,32			; g_pfnVectors[98] @ 3136
						.field	0,32			; g_pfnVectors[99] @ 3168
						.field	0,32			; g_pfnVectors[100] @ 3200
						.field	0,32			; g_pfnVectors[101] @ 3232
						.field	0,32			; g_pfnVectors[102] @ 3264
						.field	0,32			; g_pfnVectors[103] @ 3296
						.field	0,32			; g_pfnVectors[104] @ 3328
						.field	0,32			; g_pfnVectors[105] @ 3360
						.field	0,32			; g_pfnVectors[106] @ 3392
						.field	0,32			; g_pfnVectors[107] @ 3424
						.field	IntDefaultHandler,32		; g_pfnVectors[108] @ 3456
						.field	IntDefaultHandler,32		; g_pfnVectors[109] @ 3488
						.field	IntDefaultHandler,32		; g_pfnVectors[110] @ 3520
						.field	IntDefaultHandler,32		; g_pfnVectors[111] @ 3552
						.field	IntDefaultHandler,32		; g_pfnVectors[112] @ 3584
						.field	IntDefaultHandler,32		; g_pfnVectors[113] @ 3616
						.field	IntDefaultHandler,32		; g_pfnVectors[114] @ 3648
						.field	IntDefaultHandler,32		; g_pfnVectors[115] @ 3680
						.field	IntDefaultHandler,32		; g_pfnVectors[116] @ 3712
						.field	IntDefaultHandler,32		; g_pfnVectors[117] @ 3744
						.field	IntDefaultHandler,32		; g_pfnVectors[118] @ 3776
						.field	IntDefaultHandler,32		; g_pfnVectors[119] @ 3808
						.field	IntDefaultHandler,32		; g_pfnVectors[120] @ 3840
						.field	IntDefaultHandler,32		; g_pfnVectors[121] @ 3872
						.field	IntDefaultHandler,32		; g_pfnVectors[122] @ 3904
						.field	0,32			; g_pfnVectors[123] @ 3936
						.field	0,32			; g_pfnVectors[124] @ 3968
						.field	IntDefaultHandler,32		; g_pfnVectors[125] @ 4000
						.field	IntDefaultHandler,32		; g_pfnVectors[126] @ 4032
						.field	IntGPIOm,32		; g_pfnVectors[127] @ 4064
						.field	IntDefaultHandler,32		; g_pfnVectors[128] @ 4096
						.field	IntDefaultHandler,32		; g_pfnVectors[129] @ 4128
						.field	0,32			; g_pfnVectors[130] @ 4160
						.field	0,32			; g_pfnVectors[131] @ 4192
						.field	IntDefaultHandler,32		; g_pfnVectors[132] @ 4224
						.field	IntDefaultHandler,32		; g_pfnVectors[133] @ 4256
						.field	IntDefaultHandler,32		; g_pfnVectors[134] @ 4288
						.field	IntDefaultHandler,32		; g_pfnVectors[135] @ 4320
						.field	IntDefaultHandler,32		; g_pfnVectors[136] @ 4352
						.field	IntDefaultHandler,32		; g_pfnVectors[137] @ 4384
						.field	IntDefaultHandler,32		; g_pfnVectors[138] @ 4416
						.field	IntDefaultHandler,32		; g_pfnVectors[139] @ 4448
						.field	IntDefaultHandler,32		; g_pfnVectors[140] @ 4480
						.field	IntDefaultHandler,32		; g_pfnVectors[141] @ 4512
						.field	IntDefaultHandler,32		; g_pfnVectors[142] @ 4544
						.field	IntDefaultHandler,32		; g_pfnVectors[143] @ 4576
						.field	IntDefaultHandler,32		; g_pfnVectors[144] @ 4608
						.field	IntDefaultHandler,32		; g_pfnVectors[145] @ 4640
						.field	IntDefaultHandler,32		; g_pfnVectors[146] @ 4672
						.field	IntDefaultHandler,32		; g_pfnVectors[147] @ 4704
						.field	IntDefaultHandler,32		; g_pfnVectors[148] @ 4736
						.field	IntDefaultHandler,32		; g_pfnVectors[149] @ 4768
						.field	IntDefaultHandler,32		; g_pfnVectors[150] @ 4800
						.field	IntDefaultHandler,32		; g_pfnVectors[151] @ 4832
						.field	IntDefaultHandler,32		; g_pfnVectors[152] @ 4864
						.field	IntDefaultHandler,32		; g_pfnVectors[153] @ 4896
						.field	IntDefaultHandler,32		; g_pfnVectors[154] @ 4928

             .text                           ; Program Start
             .global RESET                   ; Define entry point
             .align	4
			 .sect ".text"

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

		;GPIO m both edges
		mov r0, #GPIO_BASE	;CR
		mov r1, #0x63000
		add r1, r1, r0
		mov r0, #GPIOIBE
		add r1, r1, r0

		ldr r0, [r1]
		mov r2, #0x10
		orr r0, r0, r2  ; PM5 IBE Enable
		str r0, [r1]

PORTM_Interrupt:
;int127 enable
INTEN:
		mov r0, #0xE0000000
		mov r1, #0xE100
		add r1, r1, r0
		mov r0, #0x0C
		add r1, r1, r0

		ldr r0, [r1]
		mov r2, #0x8000
		orr r0, r0, r2
		str r0, [r1]

;portm interrupt unmasking
UNMSK:
		mov r0, #GPIO_BASE
		mov r1, #0x63000
		add r1, r1, r0
		mov r0, #0x410
		add r1, r1, r0

		ldr r0, [r1]
		mov r2, #0xFF
		orr r0, r0, r2
		str r0, [r1]

Timer_Configure:

		;RCGCTIMER : timer clock power on
		mov r0, #GPIO_BASE
		mov r1, #0xFE000
		add r1, r1, r0
		mov r0, #0x604
		add r1, r1, r0

		ldr r0, [r1]
		mov r2, #0x01
		orr r0, r0, r2
		str r0, [r1]

		;GPTMTAMR : timer mode - Periodic
		; do not change this part if timer is on(TAEN is set at GPTMCTL)
		mov r0, #GPIO_BASE
		mov r1, #TIMER0_1632
		add r1, r1, r0
		mov r0, #0x004
		add r1, r1, r0

		ldr r0, [r1]
		bic r0, #0x03 ; clear last 2 bits
		mov r2, #0x02 ; Periodic Timer mode
		orr r0, r0, r2
		str r0, [r1]

		;GPIOMTAILR - GPTM Timer A interval load value configure
		mov r0, #GPIO_BASE
		mov r1, #TIMER0_1632
		add r1, r1, r0
		mov r0, #0x028
		add r1, r1, r0

		mov r4, #0x01
		mov r2, #0xF0000 ; Initial load
		str r2, [r1]

		;GPTMCTL : timer on!
		mov r0, #GPIO_BASE
		mov r1, #TIMER0_1632
		add r1, r1, r0
		mov r0, #0x00C
		add r1, r1, r0

		ldr r0, [r1]
		mov r2, #0x01
		orr r0, r0, r2
		str r0, [r1]

		;GPTMCFG 32bit enable
		mov r0, #GPIO_BASE
		mov r1, #TIMER0_1632
		add r1, r1, r0
		;offset #0x000

		ldr r0, [r1]
		mov r2, #0x07
		bic r0, r0, r2  ;clear last 3 bits
		str r0, [r1]

Timer_Interrupt_Enable:
		;EN1 : interrupt 19 enable
		mov r0, #0xE0000000
		mov r1, #0xE100
		add r1, r1, r0

		ldr r0, [r1]
		mov r2, #0x80000
		orr r0, r0, r2
		str r0, [r1]

		;GPTMIMR
		mov r0, #GPIO_BASE
		mov r1, #TIMER0_1632
		add r1, r1, r0
		mov r0, #0x018
		add r1, r1, r0

		ldr r0, [r1]
		mov r2, #0x01
		orr r0, r0, r2  ;Time-out Interrupt Unmask
		str r0, [r1]

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

		mov r10, #0x01 ; Led On flag
;idle loop
loop
	B loop

IntDefaultHandler:
iLoop
	B iLoop

IntTimer0AHandler:	.asmfunc
		;interrupt clear
		mov r0, #GPIO_BASE
		mov r1, #TIMER0_1632
		add r1, r1, r0
		mov r0, #0x024
		add r1, r1, r0

		ldr r0, [r1]
		mov r2, #0xFF
		orr r0, r0, r2
		str r0, [r1]

		;LED Blink if ON then OFF else ON
		CMP r10, #0x01 ; if on
		BEQ Led_Off
		BNE Led_On
INTOUT:

	BX LR
	.endasmfunc

IntGPIOm:	.asmfunc
		STMFD sp!, {a1-a4, LR}

		mov r7, #GPIO_BASE
		mov r1, #0x63000
		add r1, r1, r7
		mov r7, #0x7C ; 01-11 11/00
		add r1, r1, r7

		ldr r7, [r1]

		cmp r7, #SW_UP
		BEQ Led_Faster

		cmp r7, #SW_DOWN
		BEQ Led_Slower

;portm interrupt clear
ICL:
		mov r0, #GPIO_BASE
		mov r1, #0x63000
		add r1, r1, r0
		mov r0, #0x410
		add r1, r1, r0
		mov r0, #0xC
		add r1, r1, r0

		ldr r0, [r1]
		mov r2, #0xFF
		orr r0, r0, r2
		str r0, [r1]

	LDMFD sp!, {a1-a4, LR}
	BX LR
	.endasmfunc


Led_Faster:
		;GPIOMTAILR - GPTM Timer A interval load value configure
		mov r0, #GPIO_BASE
		mov r1, #TIMER0_1632
		add r1, r1, r0
		mov r0, #0x028
		add r1, r1, r0

		ldr r0, [r1]
		LSR r0, #1
		str r0, [r1]

		B ICL

Led_Slower:
		;GPIOMTAILR - GPTM Timer A interval load value configure
		mov r0, #GPIO_BASE
		mov r1, #TIMER0_1632
		add r1, r1, r0
		mov r0, #0x028
		add r1, r1, r0

		ldr r0, [r1]
		LSL r0, #1
		str r0, [r1]

		B ICL

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

		mov r10, #0 ;flag off

		b INTOUT

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

		mov r10, #1 ; flag on

		b INTOUT


			.retain
			.retainrefs
