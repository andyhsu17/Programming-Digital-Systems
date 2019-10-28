	.include "address_map_nios2.s"
	.include "globals.s"
	.extern	PATTERN					# externally defined variables
	.extern	SHIFT_DIR
	.extern	SHIFT_EN
/*******************************************************************************
 * Interval timer - Interrupt Service Routine
 *
 * Shifts a PATTERN being displayed. The shift direction is determined by the 
 * external variable SHIFT_DIR. Whether the shifting occurs or not is determined
 * by the external variable SHIFT_ON.
 ******************************************************************************/
	.global INTERVAL_TIMER_ISR
INTERVAL_TIMER_ISR:					
	subi	sp,  sp, 40				# reserve space on the stack
	stw		ra, 0(sp)
	stw		r4, 4(sp)
	stw		r5, 8(sp)
	stw		r6, 12(sp)
	stw		r8, 16(sp)
	stw		r10, 20(sp)
	stw		r20, 24(sp)
	stw		r21, 28(sp)
	stw		r22, 32(sp)
	stw		r23, 36(sp)

	movi	r8, 76	#array counter 19 * 4bytes
	movia	r23, 9000000	#timer counter

	movia	r10, TIMER_BASE			# interval timer base address
	sthio	r0,  0(r10)				# clear the interrupt

	movia	r20, HEX3_HEX0_BASE		# HEX3_HEX0 base address
	movia	r21, pattern1			# set up a pointer to the display pattern
	#movia	r22, SHIFT_DIR			# set up a pointer to the shift direction variable
	#movia	r23, SHIFT_EN			# set up a pointer to the shift enable variable


	add		r21, r21, r19	#add array index to pattern address
	bge		r19, r8, reset	#if array index is at the end, reset array index 

	ldw		r6, 0(r21)				# load the pattern
	stwio	r6, 0(r20)				# store to HEX3 ... HEX0
	
	
	addi	r19, r19, 4		#increment array index
	

	


END_INTERVAL_TIMER_ISR:
	ldw		ra, 0(sp)				# restore registers
	ldw		r4, 4(sp)
  	ldw		r5, 8(sp)
	ldw		r6, 12(sp)
	ldw		r8, 16(sp)
	ldw		r10, 20(sp)
	ldw		r20, 24(sp)
	ldw		r21, 28(sp)
	ldw		r22, 32(sp)
	ldw		r23, 36(sp)	
	addi	sp,  sp, 40				# release the reserved space on the stack

	ret

	


reset:
	movi	r19, 0
	movia	r21, pattern1
	eret


.end
###########################################


/*.text
	.equ	LEDs,		0xFF200020
	.global _start
_start:
	movia	r2, LEDs		# Address of LEDs         
	movia	r4, pattern1  #HELLOBUFFS----
	
	
	movi	r12, 19	#register 0
	
	

LOOP:
	
	beq 	r12, r0, reset
	subi	r12, r12, 1	#array counter register
	ldwio	r9, 0(r4)		# Move pattern into display register
	stwio	r9, 0(r2)		# Display the state on LEDs
	call 	delay

	addi 	r4, r4, 4	#increment counter by 4
	br 		LOOP
reset:
	movia	r4, pattern1
	movi	r12, 19
	br 		LOOP
	
delay:
	subi r10, r10, 1
	bge r10, r0, delay
	movia r10, 30000000
	ret

pattern1:
	.word	0x00000000, 0x00000076, 0x00007679, 0x00767906, 0x76790606, 0x7906065C, 0x06065C00, 0x065C007C, 0x5C007C3E,  0x007C3E71,  0x7C3E7171, 0x3E71716D, 0x71716D40, 0x716D4040, 0x6D404040 , 0x40404000,0x40400000,  0x40000000, 0x00000000
	.end
