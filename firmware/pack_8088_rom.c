#include <stdio.h>
#include <sys/fcntl.h>
#include <unistd.h>
#include <sys/stat.h>

char data[256];

int main(int argc ,char **argv)
{
    int fd = open("spi_load_8088", O_RDONLY);
    if (fd < 0) {
        perror("xx");
        return 1;
    }
    struct stat st;
    fstat(fd, &st);
    if (st.st_size >= 256-16) {
        puts("too large");
        return 1;
    }

    int fd2 = open("por_8088", O_RDONLY);
    if (fd2 < 0) {
        perror("xx");
        return 1;
    }
    fstat(fd2, &st);
    if (st.st_size >= 16) {
        puts("too large");
        return 1;
    }

    read(fd, data, 256-16);
    read(fd2, data+256-16, 16);

    FILE *fp = fopen(argv[1], "wb");
    fwrite(data, 1, 256, fp);
    fclose(fp);
}