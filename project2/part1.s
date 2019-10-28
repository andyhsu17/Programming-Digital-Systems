.text
.global sum_two
sum_two:
	add r2, r4, r5
	ret

.global op_three
op_three:
	addi 	sp, sp, -8
	stw		r6, 0(sp)
	stw		ra, 4(sp)
	call	op_two
	ldw		r5, 0(sp)
	movi	r4, r2
	call 	op_two
	addi	sp, sp, 8
	ret


.global fibonacci
fibonacci:
	movi	r10, 1
	addi 	sp, sp, -12
	blt		r4, r0, return0
	ble		r4, r10, returnN
	stw		r8, 0(sp)
	stw		r9, 4(sp)
	stw		ra, 8(sp)
	mov	 	r8, r4
	addi	r4, r8, -1
	call	fibonacci
	mov		r9, r2
	addi	r4, r8, -2
	call 	fibonacci
	add		r2, r2, r9
	br		done

	done:
		ldw		r8, 0(sp)
		ldw		r9, 4(sp)
		ldw		ra, 8(sp)
		addi	sp, sp, 12
		ret

	returnN:
		mov		r2, r4
		addi	sp, sp, 12
		ret

	return0:
		mov 	r2, r0
		addi	sp, sp, 12
		ret
