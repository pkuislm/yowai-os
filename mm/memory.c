#include "../include/memory.h"
#include "../include/platform.h"
#include "../include/printf.h"

extern uint64_t MEM_END;
extern uint64_t PAGE_START;
extern uint64_t TEXT_END;
free_pages_list* free_pages;
page_directorys kpd;

void memset(void* const src, char num, uint64_t size){
    char* p = src;
	while (size--)
		*p++ = num;
}


void bulid_free_pages(){
    printf("StartInitMem\n");
    printf("+kernel_end: %x\n+img_end: %x\n", TEXT_END, PAGE_START);
    uint64_t start = PAGE_START + (0x1000 - (PAGE_START & 0xfff));
    printf("+PagingStart:0x%x\n", start);
    free_pages = (free_pages_list *)start;
    free_pages_list* cfp = free_pages;
    uint64_t cur = start + PAGESIZE;
    int count = 0;
    while(cur <= MEM_END){
        count++;
        if(cur == MEM_END){
            cfp->next = NULL;
            break;
        }
        cfp->next = (free_pages_list *)cur;
        cfp = cfp->next;
        cur += PAGESIZE;
    }
    printf("Page bulid complete.\nFound pages: %d, Total: %d bytes avaliable.\n", count, count*4096);
}

void* get_free_page(){
    free_pages_list *fp = free_pages;
    if(fp){
        free_pages = free_pages->next;
        return (void*)fp;
    }else{
        return NULL;
    }
}

void free_page(void* p){
    free_pages_list *fp = (free_pages_list *)p;
    memset(fp, 0, PAGESIZE);
    fp->next = free_pages;
    free_pages = fp;
}

void mem_init(){
    bulid_free_pages();
    kpd = get_free_page();
}
