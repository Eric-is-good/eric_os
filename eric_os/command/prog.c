#include "stdio.h"
#include "syscall.h"

void han(int n, int from, int to, int temp)
{
    if (n == 1)
    {
        putch(from);
        putch(45);
        putch(62);
        putch(to);
        putch(10);
    }
    else
    {
        han(n - 1, from, temp, to);
        putch(from);
        putch(45);
        putch(62);
        putch(to);
        putch(10);
        han(n - 1, temp, to, from);
    }
}

int main()
{
    int n = getint();
    han(n, 65, 66, 67);
    return 0;
    exit(0);
}
