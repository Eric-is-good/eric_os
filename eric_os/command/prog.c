#include "stdio.h"
#include "syscall.h"

// int main() {
//    printf("eric\n");
//    putint(666);
//    printf("\n");
//    putch(65);
//    printf("\n");
//    putfloat(123.12);
//    printf("\n");
//    exit(0);
// }

int main(){
   int a = getint();
   putint(a);

   int b = getch();
   putch(b);
   
   exit(0);
}
