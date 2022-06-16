/* These are simple unit tests of my module of alloc in asm
   You need to compile it with -no-pie flag
 */

#include <stdio.h>

extern void *alloc(unsigned amount_bytes);
extern void free(void *addr);

int main()
{
    void *addr1, *addr2, *addr3, *addr4, *addr5;
    
    addr2 = alloc(10);
    free(addr2);

    addr1 = alloc(15);
    free(addr1);

    addr4 = alloc(20);
    free(addr4);


    addr5 = alloc(25);
    free(addr5);

    addr3 = alloc(5);
    printf("%p\n", addr3);

    
    return 0;
}





