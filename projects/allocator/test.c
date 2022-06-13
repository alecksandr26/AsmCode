/* These are simple unit tests of my module of alloc in asm
   You need to compile it with -no-pie flag
 */

#include <stdio.h>

extern void *alloc(unsigned amount_bytes);
extern void free(void *addr);

int main()
{
    void *addr1, *addr2, *addr3;
    
    addr2 = alloc(10);
    free(addr2);

    addr1 = alloc(15);
    free(addr1);

    addr3 = alloc(5);

    
    return 0;
}





