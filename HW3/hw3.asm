	.global __stack
__stack:
	.text

	MOV R0, #8
	MOV R1, #0
	SUB R1, #8
	MOV R2, #3
	MOV R3, #0
	SUB R3, #3

	SDIV R4, R0, R2 ; 2
	SDIV R5, R0, R3 ; -2
	SDIV R6, R1, R2 ; -3

	UDIV R7, R0, R3 ; UNSIGNED: WHAT IS DE-SIGNED?
	UDIV R8, R1, R3
	UDIV R9, R1, R2


	B __stack

	.retain
	.retainrefs
