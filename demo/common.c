#include <conio.h>
#include "addr.h"
#include "common.h"

extern const unsigned char fonts[];

void
uart_output_char(unsigned char c)
{
    while (1) {
        unsigned char st = inp(UART_STAT);
        if ((st & 8) == 0) {
            break;
        }
    }

    outp(UART_TX, c);
}

void
uart_output_str(const char *p)
{
    while (*p) {
        uart_output_char(*p);
        p++;
    }
}


void
delay(int n)
{
    int i;
    for (i=0; i<n; i++) {
        _asm {
            nop;
        }
    }
}


const unsigned char display_init_sequence[] = {
    0xae,
    0xd5, 0x80,
    0xa8, 0x3f,
    0xd3, 0x00,
    0x40,
    0x8d, 0x14,
    0x20, 0x00,
    0xa1,
    0xc8,
    0xda, 0x12,
    0x81, 0xcf,
    0xd9, 0xf1,
    0xd8, 0x40,
    0xa4,
    0xa6,
    0xaf
};

void
spi_display_out(unsigned char b)
{
    while (1) {
        unsigned char sr = inp(SPI_SR0);
        if ((sr & 8) == 0) {
            break;
        }
    }

    outp(SPI_DTR, b);
}

void
spi_display_set_cursor(unsigned char x, unsigned char line)
{
    spi_display_out(0x21);
    spi_display_out(x);
    spi_display_out(127);

    spi_display_out(0x22);
    spi_display_out(line);
    spi_display_out(7);
}



static void
spi_display_out_bytes(const unsigned char *data, int len)
{
    int i;
    for (i=0; i<len; i++) {
        spi_display_out(data[i]);
    }
}

void
spi_display_init(void)
{
    outp(GPIO0, 2);             /* rst hi */
    delay(0x100);
    outp(GPIO0, 0);             /* rst lo */
    delay(0x100);
    outp(GPIO0, 2);             /* rst lo & dc=c */

    outp(SPI_SRR, 0);           /* reset SPI */
    outp(SPI_CR, 0x2 | 0x4);    /* enable & master mode */

    spi_display_out_bytes(display_init_sequence, sizeof(display_init_sequence));
}

void
spi_display_disp_char(unsigned char c)
{
    int i;
    const unsigned char *p;
    if (! isprint(c)) {
        return;
    }

    p = &fonts[(c-' ') * 6];

    spi_display_to_data();
    for (i=0; i<6; i++) {
        spi_display_out(p[i]);
    }
    spi_display_out(0);
    spi_display_out(0);
    spi_display_to_command();
}

int isprint(int c)
{
    return (c >= 0x20) && (c <= 0x7e);
}

void
spi_display_to_data()
{
    outp(GPIO0, 3);              /* data */
}

void
spi_display_to_command()
{
    outp(GPIO0, 2);              /* command */
}

