#include <stdio.h>
#include <sys/fcntl.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdlib.h>

int
main(int argc, char **argv)
{
    int fd = open(argv[1], O_RDONLY);
    if (fd < 0) {
        perror(argv[1]);
        return 1;
    }

    struct stat st;
    fstat(fd, &st);

    size_t sz = st.st_size;

    unsigned char *buffer = malloc(sz + 3);
    buffer[0] = 0x5a;           /* sig */
    buffer[1] = (unsigned char)(sz); /* length */
    buffer[2] = (unsigned char)(sz>>8); /* length */

    read(fd, buffer+3, sz);

    FILE *fp = fopen(argv[2], "wb");
    fwrite(buffer, 1, sz+3, fp);
    fclose(fp);
    return 0;
}