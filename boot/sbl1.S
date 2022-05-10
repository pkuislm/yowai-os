#include "../include/platform.h"
	# size of each hart's stack is 4096 bytes
	.equ	STACK_SIZE, 4096

	.global	_start
    .global start_kernel

	.text
_start:
	.option push
	.option norelax
	la gp, __global_pointer$
	.option pop
	# park harts with id != 0
	csrr	t0, mhartid
	mv	tp, t0
	bnez	t0, park

	# SATP should be 0 Supervisor Address Translation and Protection
	csrw satp, zero

	li   t0, (0b01 << 11) | (1 << 7) | (1 << 3)
    csrw mstatus, t0
	li   t3, (1 << 3) | (1 << 7) | (1 << 11)
    csrw mie, t3

	la  a0, _bss_start
    la  a1, _bss_end
    bgeu a0, a1, finish_bss_fill

fill_bss:
    sd   zero, (a0)
    addi a0, a0, 8
    bltu a0, a1, fill_bss

finish_bss_fill:
	la   t2, mtrap_vector
    csrw mtvec, t2

    # Setup the stack temporarily
	slli	t0, t0, 10
	la	sp, stacks + STACK_SIZE
	add	sp, sp, t0
    
	la   t1, start_kernel
    csrw mepc, t1
	la   ra, park
    mret

park:
	wfi
	j	park

stacks:
	.skip	STACK_SIZE * MAXNUM_CPU # allocate space for all the harts stacks

	.end				# End of file
