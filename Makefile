CROSS_COMPILE = ~/riscv64/bin/riscv64-unknown-elf-
CFLAGS = -nostdlib -fno-builtin -march=rv64gc -mabi=lp64 -g -Wall -mcmodel=medany

QEMU = ~/qemu-5.0.0/riscv64-softmmu/qemu-system-riscv64
QFLAGS = -nographic -smp 1 -machine virt -bios none

GDB = gdb-multiarch
CC = ${CROSS_COMPILE}gcc
OBJCOPY = ${CROSS_COMPILE}objcopy
OBJDUMP = ${CROSS_COMPILE}objdump

SRCS_ASM = \
	boot/sbl1.S \
	mm/mem.S\
	trap/trap.S\
	

SRCS_C = \
	init/kernel.c \
	lib/uart.c \
	lib/printf.c\
	mm/memory.c\


OBJS = $(SRCS_ASM:.S=.o)
OBJS += $(SRCS_C:.c=.o)

.DEFAULT_GOAL := all
all: os.elf


os.elf: ${OBJS}
	${CC} ${CFLAGS} -T MLayout.ld -o os.elf $^
	${OBJCOPY} -O binary os.elf os.bin

.o : .c
	${CC} ${CFLAGS} -c -o $@ $<

%.o : %.S
	${CC} ${CFLAGS} -c -o $@ $<

run: all
	@${QEMU} -M ? | grep virt >/dev/null || exit
	@echo "Press Ctrl-A and then X to exit QEMU"
	@echo "------------------------------------"
	@${QEMU} ${QFLAGS} -kernel os.elf

.PHONY : debug
debug: all
	@echo "Press Ctrl-C and then input 'quit' to exit GDB and QEMU"
	@echo "-------------------------------------------------------"
	@${QEMU} ${QFLAGS} -kernel os.elf -s -S &
	@${GDB} os.elf -q -x gdbinit

.PHONY : code
code: all
	@${OBJDUMP} -S os.elf | less

.PHONY : clean
clean:
	(cd mm;rm -rf *.o)
	(cd boot;rm -rf *.o)
	(cd init;rm -rf *.o)
	(cd lib;rm -rf *.o)
	(cd trap;rm -rf *.o)
	rm -rf *.bin *.elf

