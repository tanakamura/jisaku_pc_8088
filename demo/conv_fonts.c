#include <stdio.h>
#include <stdlib.h>

struct font {
    char data[7][6];
};

struct font alphabet[26];
struct font number[10];

void
read_font(FILE *fp, struct font *f, char cc)
{
    for (int y=0; y<7; y++) {
        for (int x=0; x<6; x++) {
            int c = fgetc(fp);
            if (c == ' ') {
                f->data[y][x] = 0;
            } else if (c == 'o') {
                f->data[y][x] = 1;
            } else {
                printf("1:invalid char @ '%c'\n", cc);
                exit(1);
            }
        }

        int c = fgetc(fp);
        if (c != '.') {
            printf("2:invalid char @ '%c'\n", cc);
            exit(1);
        }

        c = fgetc(fp);
        if (c != '\n') {
            printf("3:invalid char @ '%c', y=%d\n", cc, y);
            exit(1);
        }
    }

    for (int x=0; x<7; x++) {
        int c = fgetc(fp);
        if (c != '.') {
            printf("4:invalid char @ '%c'\n", cc);
            exit(1);
        }

    }
    int c = fgetc(fp);
    if (c != '\n') {
        printf("5:invalid char @ '%c'\n", cc);
        exit(1);
    }

}

int main()
{
    FILE *fp = fopen("fonts.dat", "rb");

    for (int i=0; i<26; i++) {
        read_font(fp, &alphabet[i], 'A' + i);
    }

    for (int i=0; i<10; i++) {
        read_font(fp, &number[i], '0' + i);
    }

    FILE *out = fopen("fonts.asm", "wb");

    for (int i=0; i<26; i++) {
        fprintf(out, "alphabet_%c db ", 'A' + i);
        for (int x=0; x<6; x++) {
            int byte = 0;
            for (int y=0; y<7; y++) {
                if (alphabet[i].data[y][x]) {
                    byte |= 1 << (y+1);
                }
            }

            fprintf(out, "0x%02x, ", byte);
        }
        fprintf(out, "\n");
    }

    for (int i=0; i<10; i++) {
        fprintf(out, "number_%c db ", '0' + i);
        for (int x=0; x<6; x++) {
            int byte = 0;
            for (int y=0; y<7; y++) {
                if (number[i].data[y][x]) {
                    byte |= 1 << y;
                }
            }

            fprintf(out, "0x%02x, ", byte);
        }
        fprintf(out, "\n");
    }
    
}
