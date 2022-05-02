/* Yeah we can import our function also in c
   To compile the code is easy
   
   "clang stat1_in_c.c stat1.o"
   
 */
#include <stdio.h>

/* basically we need to do our delcaration like this
   Its important to write the function as c do because
   if you didn't write it it doesn't work 
 */
extern void stat1(int arr[], int len, int *sum, int *ave);

/* Now we are going to export another asm function
   So yeah just like this we can create our own functions in asm
   when we want to get some very very fast
 */
extern int charToInt(char string[]);


int main()
{
    /* Lets test our function */
    int arr[] = {1, -2, 3, -4, 5, 7, 9, 11};
    int len = 8, sum, ave;

    sum = ave = 0;
    stat1(arr, len, &sum, &ave);

    printf("sum: %i | ave: %i\n", sum, ave);

    /* Now lets test charToInt function */
    sum = charToInt("4000");
    printf("res: %i\n", sum);
    
    return 0;
}


