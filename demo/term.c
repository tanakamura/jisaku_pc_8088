#include <conio.h>
#include "keyboard.h"
#include "common.h"
#include "addr.h"

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

void cmain()
{
    int i,y,x;
    struct keyboard_driver drv;

    spi_display_init();
    spi_display_set_cursor(0,0);

    spi_display_to_data();
    for (i=0; i<128*8; i++) {
        spi_display_out(0);
    }
    spi_display_to_command();

    spi_display_set_cursor(0,0);

    init_keyboard_driver(&drv);

    while (1) {
        struct keyevent ke;
        int k = read_next_keyevent(&ke, &drv);

        if (k == 0) {
            continue;
        }

        if (ke.press && isprint(ke.keysym)) {
            spi_display_disp_char(ke.keysym);
        }
    }
}
