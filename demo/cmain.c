#include <conio.h>
#include "addr.h"

extern const unsigned char fonts[];

static void
spi_out(unsigned char b)
{
    while (1) {
        unsigned char sr = inp(SPI_SR0);
        if ((sr & 8) == 0) {
            break;
        }
    }

    outp(SPI_DTR, b);
}


static void delay(int n)
{
    int i;
    for (i=0; i<n; i++) {
        _asm {
            nop;
        }
    }
}

static inline void
to_data()
{
    outp(GPIO0, 3);              /* data */
}

static inline void
to_command()
{
    outp(GPIO0, 2);              /* command */
}

static void
disp_char(unsigned char c)
{
    int i;
    const unsigned char *p;
    if ((c < ' ') || (c > '~')) {
        return;
    }

    p = &fonts[(c-' ') * 6];

    to_data();
    for (i=0; i<6; i++) {
        spi_out(p[i]);
    }
    spi_out(0);
    spi_out(0);
    to_command();
}
static void
disp_str(unsigned char *p)
{
    while (*p) {
        disp_char(*(p++));
    }
}

static void
set_cursor(unsigned char x, unsigned char line)
{
    spi_out(0x21);
    spi_out(x);
    spi_out(127);

    spi_out(0x22);
    spi_out(line);
    spi_out(7);
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

static void
output_char(unsigned char c)
{
    while (1) {
        unsigned char st = inp(UART_STAT);
        if ((st & 8) == 0) {
            break;
        }
    }

    outp(UART_TX, c);
}

static void
output_str(const char *p)
{
    while (*p) {
        output_char(*p);
        p++;
    }
}

static void
spi_out_bytes(const unsigned char *data, int len)
{
    int i;
    for (i=0; i<len; i++) {
        spi_out(data[i]);
    }
}

void cmain()
{
    int i;

   outp(GPIO0, 2);             /* rst hi */
   delay(0x100);
   outp(GPIO0, 0);             /* rst lo */
   delay(0x100);
   outp(GPIO0, 2);             /* rst lo & dc=c */

   outp(SPI_SRR, 0);           /* reset SPI */
   outp(SPI_CR, 0x2 | 0x4);    /* enable & master mode */

   spi_out_bytes(display_init_sequence, sizeof(display_init_sequence));

   set_cursor(0,0);

   to_data();
   for (i=0; i<128*8; i++) {
       spi_out(0);
   }
   to_command();

   set_cursor(0,0);
   disp_str("Hello World.");

   while (1) {
       int st;

       st = inp(UART_STAT);
       if (st & 1) {
           unsigned char data = inp(UART_RX);
           disp_char(data);
           output_char(data);
       }
   }

}