#ifndef _MEM_H
#define _MEM_H

#include "types.h"


#define PAGESIZE 4096
#define PAGEOFF  12

#ifndef NULL
#define NULL ((void *) 0)
#endif

#define PTE_V (1L << 0) // valid
#define PTE_R (1L << 1)
#define PTE_W (1L << 2)
#define PTE_X (1L << 3)
#define PTE_U (1L << 4) // 1 -> user can access

typedef struct free_pages_list {
	struct free_pages_list *next;
} free_pages_list;

typedef uint64_t  page_directory;
typedef uint64_t *page_directorys;

void mem_init();
void *get_free_page();
void free_page(void *p);

#endif // _MEM_H