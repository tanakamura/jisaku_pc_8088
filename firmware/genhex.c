#include <stdio.h>
#include <stdint.h>

static void
flush(uint32_t buf)
{
    printf("%02x\n",
           buf);
}

int main()
{
    uint32_t cur = 0;
    int cur_sz = 0;

    while (1) {
        int c = getchar();
        if (c == EOF) {
            if (cur_sz) {
                flush(cur);
            }
            break;
        }

        cur |= c<<(cur_sz*8);
        cur_sz++;

        if (cur_sz==1) {
            flush(cur);
            cur = 0;
            cur_sz = 0;
        }
    }

    return 0;
}