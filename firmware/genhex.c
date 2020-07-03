#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

static void
flush(uint32_t buf)
{
    printf("%02x\n",
           buf);
}

int main(int argc, char **argv)
{
    int max_size = 64*1024;

    if (argc >= 2) {
        max_size = atoi(argv[1]);
    }

    uint32_t cur = 0;
    int cur_sz = 0;
    int sz = 0;

    while (1) {

        int c = getchar();
        if (c == EOF) {
            if (cur_sz) {
                flush(cur);
            }
            break;
        }

        if (sz >= max_size) {
            fputs("too large file\n",stderr);
            return 1;
        }

        cur |= c<<(cur_sz*8);
        cur_sz++;

        if (cur_sz==1) {
            flush(cur);
            cur = 0;
            cur_sz = 0;
        }

        sz++;
    }

    return 0;
}