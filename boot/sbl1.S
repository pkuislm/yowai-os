#include "../include/platform.h"
	# size of each hart's stack is 1024 bytes
	.equ	STACK_SIZE, 4096

	.global	_start
    .global start_kernel

	.text
_start:
	# park harts with id != 0
	csrr	t0, mhartid
	mv	tp, t0
	bnez	t0, park
    # Setup the stack temporarily
	slli	t0, t0, 10
	la	sp, stacks + STACK_SIZE
	add	sp, sp, t0
    
	j	start_kernel		# jump to c

park:
	wfi
	j	park

stacks:
	.skip	STACK_SIZE * MAXNUM_CPU # allocate space for all the harts stacks

	.end				# End of file
