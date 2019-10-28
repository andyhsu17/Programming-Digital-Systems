	.include "address_map_nios2.s"
	.include "globals.s"
	.extern	PATTERN					# externally defined variables
	.extern	SHIFT_DIR
	.extern	SHIFT_EN
/*******************************************************************************
 * Pushbutton - Interrupt Service Routine
 *
 * This routine checks which KEY has been pressed and updates the global
 * variables as required.
 ******************************************************************************/
	.global	PUSHBUTTON_ISR
PUSHBUTTON_ISR:
	subi	sp, sp, 20				# reserve space on the stack
	stw		ra, 0(sp)
	stw		r10, 4(sp)
	stw		r11, 8(sp)
	stw		r12, 12(sp)
	stw		r13, 16(sp)

	movia	r10, KEY_BASE			# base address of pushbutton KEY parallel port
	ldwio	r11, 0xC(r10)			# read edge capture register
	stwio	r11, 0xC(r10)			# clear the interrupt	  

CHECK_KEY0:
	andi	r13, r11, 0b0001		# check KEY0
	beq		r13, zero, CHECK_KEY1	#if key0 not pressed check key1
	
	movi	r8, 6
	bge 	r7, r8, END_PUSHBUTTON_ISR

	movia	r16, TIMER_BASE		# interval timer base address
	/* retrieve current interval timer */
	ldhio	r12, 8(r16)
	andi	r12, r12, 0x0000FFFF
	ldhio	r15, 0xC(r16)
	andi	r15, r15, 0x0000FFFF
	slli	r15, r15, 16
	or		r12, r15, r12
	
	movia	r9, 6000000
	sub		r12, r12, r9	#subtract current interval by 
	
	sthio	r12, 8(r16)			# store the low half word of counter start value
	srli	r12, r12, 16
	sthio	r12, 0xC(r16)		# high half word of counter start value

	/* start interval timer, enable its interrupts */
	movi	r15, 0b0111			# START = 1, CONT = 1, ITO = 1
	sthio	r15, 4(r16)
	
	addi	r7, r7, 1	#increase 1 to speed

CHECK_KEY1:
	andi	r13, r11, 0b0010		# check KEY1
	beq		r13, zero, END_PUSHBUTTON_ISR	#if nothing is pressed, end
	
	movi	r8, 0
	ble		r7, r8, END_PUSHBUTTON_ISR 	#if at slowest speed, dont do anything

	movia	r16, TIMER_BASE		# interval timer base address
	/* retrieve current interval timer */
	ldhio	r12, 8(r16)
	andi	r12, r12, 0x0000FFFF
	ldhio	r15, 0xC(r16)
	andi	r15, r15, 0x0000FFFF
	slli	r15, r15, 16
	or		r12, r15, r12
	
	movia	r9, 6000000	#increase interval by x
	add		r12, r12, r9
	
	sthio	r12, 8(r16)			# store the low half word of counter start value
	srli	r12, r12, 16
	sthio	r12, 0xC(r16)		# high half word of counter start value

	/* start interval timer, enable its interrupts */
	movi	r15, 0b0111			# START = 1, CONT = 1, ITO = 1
	sthio	r15, 4(r16)

	subi	r7, r7, 1


END_PUSHBUTTON_ISR:
	ldw		ra,  0(sp)				# Restore all used register to previous
	ldw		r10, 4(sp)
	ldw		r11, 8(sp)
	ldw		r12, 12(sp)
	ldw		r13, 16(sp)
	addi	sp,  sp, 20

	ret
	.end	
