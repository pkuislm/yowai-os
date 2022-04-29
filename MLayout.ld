OUTPUT_ARCH( "riscv" )

/* Entry of the image */
ENTRY( _start )

/* adjust this to fit the real hardware */
MEMORY
{
	ram   (wxa!ri) : ORIGIN = 0x80000000, LENGTH = 8M
}

/* Customize the mem layout, PROVIDE(label) is used to get the actual position */
SECTIONS
{
	.text : {
		PROVIDE(_text_start = .);
		*(.text .text.*)
		PROVIDE(_text_end = .);
	} >ram

	.rodata : {
		*(.rodata .rodata.*)
	} >ram

	.data : {
		. = ALIGN(4096);
		*(.sdata .sdata.*)
		*(.data .data.*)
	} >ram

	.bss :{
		*(.sbss .sbss.*)
		*(.bss .bss.*)
		*(COMMON)
		PROVIDE(_bss_end = .);
	} >ram

	PROVIDE(_memory_start = ORIGIN(ram));
	PROVIDE(_memory_end = ORIGIN(ram) + LENGTH(ram));

	PROVIDE(_page_start = _bss_end);
	PROVIDE(_page_size = _memory_end - _page_start);
}
