#include <conio.h>
#include "addr.h"
#include "common.h"

static void
disp_str(unsigned char *p)
{
    while (*p) {
        spi_display_disp_char(*(p++));
    }
}
static void
disp_hex(unsigned char c)
{
    if (c <= 9) {
        spi_display_disp_char('0' + c);
    } else if (c < 16) {
        spi_display_disp_char('a' + (c - 10));
    }
}


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

void cmain()
{
    int i,y,x;

    spi_display_init();

    spi_display_set_cursor(0,0);

    spi_display_to_data();
    for (i=0; i<128*8; i++) {
        spi_display_out(0);
    }
    spi_display_to_command();

    spi_display_set_cursor(0,0);
    disp_str("Hello World.");

    spi_display_set_cursor(0,0);
    disp_hex(0x89);

    x = 0;
    y = 0;

    while (1) {
        unsigned char st, c, dh, dl;
        st = inp(PS2_STATE);
        if (st & 1) {
            continue;
        }

        c = inp(PS2_RX);

        dh = (c >> 4) & 0xf;
        dl = (c >> 0) & 0xf;

        disp_hex(dh);
        disp_hex(dl);
        spi_display_disp_char(' ');

        x++;
        if (x == 5) {
            y++;
            spi_display_set_cursor(0,y&7);
            x = 0;
        }
    }

    while (1);

//   while (1) {
//       int st;
//
//       st = inp(UART_STAT);
//       if (st & 1) {
//           unsigned char data = inp(UART_RX);
//           disp_char(data);
//       }
//   }

}