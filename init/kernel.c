#include "../include/types.h"
#include "../include/memory.h"
#include "../include/printf.h"

extern void uart_init(void);

//extern void mem_init();
void page_test()
{
	void* p = get_free_page();
	printf("GetMalloc: %p\n", p);
	free_page(p);
	p = get_free_page();
	void *p2 = get_free_page();
	printf("GetMalloc2: %p, %p\n", p, p2);
	free_page(p);
	free_page(p2);
}

void start_kernel(void)
{
	//Init Uart_Communication
	uart_init();
	//Init memory and open paging
	mem_init();
	//Setup traps?
	printf("Hello World!\n");

	page_test();

	while (1) 
	{
		__asm("wfi");
        // Hanging here
    };
}

