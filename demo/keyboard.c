#include <conio.h>
#include "keyboard.h"
#include "addr.h"
#include "common.h"

/* {default, with_e0, with_shift, with_shift_e0} */
static unsigned char tbl[][4] = {
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 0
{KS_F9,KS_UNKNOWN,KS_F9,KS_UNKNOWN},// 1
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 2
{KS_F5,KS_UNKNOWN,KS_F5,KS_UNKNOWN},// 3
{KS_F3,KS_UNKNOWN,KS_F3,KS_UNKNOWN},// 4
{KS_F1,KS_UNKNOWN,KS_F1,KS_UNKNOWN},// 5
{KS_F2,KS_UNKNOWN,KS_F2,KS_UNKNOWN},// 6
{KS_F12,KS_UNKNOWN,KS_F12,KS_UNKNOWN},// 7
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 8
{KS_F10,KS_UNKNOWN,KS_F10,KS_UNKNOWN},// 9
{KS_F8,KS_UNKNOWN,KS_F8,KS_UNKNOWN},// 10
{KS_F6,KS_UNKNOWN,KS_F6,KS_UNKNOWN},// 11
{KS_F4,KS_UNKNOWN,KS_F4,KS_UNKNOWN},// 12
{KS_TAB,KS_UNKNOWN,KS_TAB,KS_UNKNOWN},// 13
{'`',KS_UNKNOWN,'~',KS_UNKNOWN},// 14
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 15
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 16
{KS_LALT,KS_RALT,KS_LALT,KS_RALT},// 17
{KS_LSHIFT,KS_UNKNOWN,KS_LSHIFT,KS_UNKNOWN},// 18
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 19
{KS_LCTRL,KS_RCTRL,KS_LCTRL,KS_RCTRL},// 20
{'q',KS_UNKNOWN,'Q',KS_UNKNOWN},// 21
{'1',KS_UNKNOWN,'!',KS_UNKNOWN},// 22
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 23
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 24
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 25
{'z',KS_UNKNOWN,'Z',KS_UNKNOWN},// 26
{'s',KS_UNKNOWN,'S',KS_UNKNOWN},// 27
{'a',KS_UNKNOWN,'A',KS_UNKNOWN},// 28
{'w',KS_UNKNOWN,'W',KS_UNKNOWN},// 29
{'2',KS_UNKNOWN,'@',KS_UNKNOWN},// 30
{KS_UNKNOWN,KS_WIN,KS_UNKNOWN,KS_WIN},// 31
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 32
{'c',KS_UNKNOWN,'C',KS_UNKNOWN},// 33
{'x',KS_UNKNOWN,'X',KS_UNKNOWN},// 34
{'d',KS_UNKNOWN,'D',KS_UNKNOWN},// 35
{'e',KS_UNKNOWN,'E',KS_UNKNOWN},// 36
{'4',KS_UNKNOWN,'$',KS_UNKNOWN},// 37
{'3',KS_UNKNOWN,'#',KS_UNKNOWN},// 38
{KS_UNKNOWN,KS_WIN,KS_UNKNOWN,KS_WIN},// 39
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 40
{' ',KS_UNKNOWN,' ',KS_UNKNOWN},// 41
{'v',KS_UNKNOWN,'V',KS_UNKNOWN},// 42
{'f',KS_UNKNOWN,'F',KS_UNKNOWN},// 43
{'t',KS_UNKNOWN,'T',KS_UNKNOWN},// 44
{'r',KS_UNKNOWN,'R',KS_UNKNOWN},// 45
{'5',KS_UNKNOWN,'%',KS_UNKNOWN},// 46
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 47
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 48
{'n',KS_UNKNOWN,'N',KS_UNKNOWN},// 49
{'b',KS_UNKNOWN,'B',KS_UNKNOWN},// 50
{'h',KS_UNKNOWN,'H',KS_UNKNOWN},// 51
{'g',KS_UNKNOWN,'G',KS_UNKNOWN},// 52
{'y',KS_UNKNOWN,'Y',KS_UNKNOWN},// 53
{'6',KS_UNKNOWN,'^',KS_UNKNOWN},// 54
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 55
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 56
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 57
{'m',KS_UNKNOWN,'M',KS_UNKNOWN},// 58
{'j',KS_UNKNOWN,'J',KS_UNKNOWN},// 59
{'u',KS_UNKNOWN,'U',KS_UNKNOWN},// 60
{'7',KS_UNKNOWN,'&',KS_UNKNOWN},// 61
{'8',KS_UNKNOWN,'*',KS_UNKNOWN},// 62
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 63
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 64
{',',KS_UNKNOWN,'<',KS_UNKNOWN},// 65
{'k',KS_UNKNOWN,'K',KS_UNKNOWN},// 66
{'i',KS_UNKNOWN,'I',KS_UNKNOWN},// 67
{'o',KS_UNKNOWN,'O',KS_UNKNOWN},// 68
{'0',KS_UNKNOWN,')',KS_UNKNOWN},// 69
{'9',KS_UNKNOWN,'(',KS_UNKNOWN},// 70
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 71
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 72
{'.',KS_UNKNOWN,'>',KS_UNKNOWN},// 73
{'/',KS_UNKNOWN,'?',KS_UNKNOWN},// 74
{'l',KS_UNKNOWN,'L',KS_UNKNOWN},// 75
{';',KS_UNKNOWN,':',KS_UNKNOWN},// 76
{'p',KS_UNKNOWN,'P',KS_UNKNOWN},// 77
{'-',KS_UNKNOWN,'_',KS_UNKNOWN},// 78
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 79
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 80
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 81
{'\'',KS_UNKNOWN,'"',KS_UNKNOWN},// 82
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 83
{'[',KS_UNKNOWN,'{',KS_UNKNOWN},// 84
{'=',KS_UNKNOWN,'+',KS_UNKNOWN},// 85
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 86
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 87
{KS_CAPSLOCK,KS_UNKNOWN,KS_CAPSLOCK,KS_UNKNOWN},// 88
{KS_RSHIFT,KS_UNKNOWN,KS_RSHIFT,KS_UNKNOWN},// 89
{KS_ENTER,KS_ENTER,KS_ENTER,KS_ENTER},// 90
{']',KS_UNKNOWN,'}',KS_UNKNOWN},// 91
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 92
{'\\',KS_UNKNOWN,'|',KS_UNKNOWN},// 93
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 94
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 95
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 96
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 97
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 98
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 99
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 100
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 101
{KS_BACKSPACE,KS_UNKNOWN,KS_BACKSPACE,KS_UNKNOWN},// 102
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 103
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 104
{'1',KS_END,'1',KS_END},// 105
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 106
{'4',KS_LEFT,'4',KS_LEFT},// 107
{'7',KS_HOME,'7',KS_HOME},// 108
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 109
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 110
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 111
{'0',KS_INSERT,'0',KS_INSERT},// 112
{'.',KS_DELETE,'.',KS_DELETE},// 113
{'2',KS_DOWN,'2',KS_DOWN},// 114
{'5',KS_UNKNOWN,'5',KS_UNKNOWN},// 115
{'6',KS_RIGHT,'6',KS_RIGHT},// 116
{'8',KS_UP,'8',KS_UP},// 117
{KS_ESCAPE,KS_UNKNOWN,KS_ESCAPE,KS_UNKNOWN},// 118
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 119
{KS_F11,KS_UNKNOWN,KS_F11,KS_UNKNOWN},// 120
{'+',KS_UNKNOWN,'+',KS_UNKNOWN},// 121
{'3',KS_PAGE_DOWN,'3',KS_PAGE_DOWN},// 122
{'-',KS_UNKNOWN,'-',KS_UNKNOWN},// 123
{'*',KS_UNKNOWN,'*',KS_UNKNOWN},// 124
{'9',KS_PAGE_UP,'9',KS_PAGE_UP},// 125
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 126
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 127
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 128
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 129
{KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN,KS_UNKNOWN},// 130
{KS_F7,KS_UNKNOWN,KS_F7,KS_UNKNOWN},// 131
};


#define NSYM (sizeof(tbl)/sizeof(tbl[0]))

void
init_keyboard_driver(struct keyboard_driver *drv)
{
    drv->state = 0;
}

int
read_next_keyevent(struct keyevent *ev, struct keyboard_driver *drv)
{
    unsigned char st, c;
top:
    st = inp(PS2_STATE);

    if (st & 1) {
        /* empty */
        return 0;
    }

    c = inp(PS2_RX);

    if (c == 0xf0) {
        drv->state |= KBD_STATE_F0;
    } else if (c == 0xe0) {
        drv->state |= KBD_STATE_E0;
    } else {
        if (drv->state & KBD_STATE_F0) {
            ev->press = 0;
        } else {
            ev->press = 1;
        }

        if (c < NSYM) {
            if (drv->state & KBD_STATE_E0) {
                if (drv->state & KBD_STATE_EITHER_SHIFT) {
                    /* e0 + shift */
                    ev->keysym = tbl[c][4];
                } else {
                    /* e0 */
                    ev->keysym = tbl[c][1];
                }
            } else {
                if (drv->state & KBD_STATE_EITHER_SHIFT) {
                    /* e0 + shift */
                    ev->keysym = tbl[c][2];
                } else {
                    /* e0 */
                    ev->keysym = tbl[c][0];
                }
            }
        } else {
            ev->keysym = KS_UNKNOWN;
        }

        if (ev->press) {
            if (ev->keysym == KS_LSHIFT) {
                drv->state |= KBD_STATE_LSHIFT;
            } else if (ev->keysym == KS_RSHIFT) {
                drv->state |= KBD_STATE_RSHIFT;
            }
        } else {
            if (ev->keysym == KS_LSHIFT) {
                drv->state &= ~KBD_STATE_LSHIFT;
            } else if (ev->keysym == KS_RSHIFT) {
                drv->state &= ~KBD_STATE_RSHIFT;
            }
        }

        drv->state &= ~(KBD_STATE_F0 | KBD_STATE_E0);

        return 1;
    }

    goto top;
}
