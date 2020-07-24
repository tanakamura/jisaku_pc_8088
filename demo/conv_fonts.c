#include <stdio.h>
#include <stdlib.h>

struct font {
    char data[7][6];
};

#define NUM_GLYPHS ('~' - ' ' + 1)

struct font glyphs[NUM_GLYPHS];

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

        if (y == 0) {
            c = fgetc(fp);
            if (c != cc) {
                printf("3:char mismatch '%c' != '%c'\n", cc, c);
                exit(1);
            }
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

    for (int i=0; i<NUM_GLYPHS; i++) {
        read_font(fp, &glyphs[i], i+' ');
    }

    FILE *out = fopen("fonts.asm", "wb");
    FILE *c_out = fopen("cfonts.c", "wb");

    fprintf(c_out, "const unsigned char fonts[] = {\n");
    fprintf(out, "fonts:\n");

    for (int i=0; i<NUM_GLYPHS; i++) {
        fprintf(out, "	db ");
        for (int x=0; x<6; x++) {
            int byte = 0;
            for (int y=0; y<7; y++) {
                if (glyphs[i].data[y][x]) {
                    byte |= 1 << (y+1);
                }
            }

            fprintf(out, "0x%02x, ", byte);
            fprintf(c_out, "0x%02x, ", byte);
        }
        fprintf(out, "\n");
        fprintf(c_out, "\n");
    }

    fprintf(c_out, "};\n");

}
