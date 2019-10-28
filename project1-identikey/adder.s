	.text
	.equ	LEDs,		0xFF200000
	.equ	SWITCHES,	0xFF200040
	.global _start
_start:
	movia	r2, LEDs		# Address of LEDs         
	movia	r3, SWITCHES	# Address of switches
	
LOOP:
	ldwio	r4, (r3)		# Read the state of switches
	srai	r5, r4, 5		# right shift LEDs into r5
	andi	r6, r4, 0x0000001F # and switches into 
	add		r4, r6, r5		# add two numbers together store in r4
	stwio	r4, (r2)		# Display the state on LEDs
	br		LOOP

	.end
