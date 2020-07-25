#ifndef SCANCODE_TO_ASCII_H
#define SCANCODE_TO_ASCII_H


#define KS_CONTROL (0x80)
#define KS_CONTROL_TYPE_MASK (0xf0)

#define KS_CONTROL_MISC (0x80)
#define KS_CONTROL_CTRL (0x90)
#define KS_CONTROL_SHIFT (0xA0)
#define KS_CONTROL_ALT (0xB0)

#define KS_BACKSPACE (KS_CONTROL_MISC | 0x1)
#define KS_CAPSLOCK (KS_CONTROL_MISC | 0x2)
#define KS_ESCAPE (KS_CONTROL_MISC | 0x3)
#define KS_ENTER (KS_CONTROL_MISC | 0x4)
#define KS_TAB (KS_CONTROL_MISC | 0x5)
#define KS_WIN (KS_CONTROL_MISC | 0x6)
#define KS_HOME (KS_CONTROL_MISC | 0x7)
#define KS_END (KS_CONTROL_MISC | 0x8)
#define KS_PAGE_UP (KS_CONTROL_MISC | 0x9)
#define KS_PAGE_DOWN (KS_CONTROL_MISC | 0xa)
#define KS_INSERT (KS_CONTROL_MISC | 0xb)
#define KS_DELETE (KS_CONTROL_MISC | 0xc)

#define KS_UNKNOWN (0xff)

#define KS_F1 (KS_CONTROL_MISC | 0x10)
#define KS_F2 (KS_CONTROL_MISC | 0x11)
#define KS_F3 (KS_CONTROL_MISC | 0x12)
#define KS_F4 (KS_CONTROL_MISC | 0x13)
#define KS_F5 (KS_CONTROL_MISC | 0x14)
#define KS_F6 (KS_CONTROL_MISC | 0x15)
#define KS_F7 (KS_CONTROL_MISC | 0x16)
#define KS_F8 (KS_CONTROL_MISC | 0x17)
#define KS_F9 (KS_CONTROL_MISC | 0x18)
#define KS_F10 (KS_CONTROL_MISC | 0x19)
#define KS_F11 (KS_CONTROL_MISC | 0x1a)
#define KS_F12 (KS_CONTROL_MISC | 0x1b)

#define KS_UP (KS_CONTROL_MISC | 0x5)
#define KS_LEFT (KS_CONTROL_MISC | 0x6)
#define KS_RIGHT (KS_CONTROL_MISC | 0x7)
#define KS_DOWN (KS_CONTROL_MISC | 0x8)

#define KS_LSHIFT (KS_CONTROL_SHIFT | 0x0)
#define KS_RSHIFT (KS_CONTROL_SHIFT | 0x1)

#define KS_LCTRL (KS_CONTROL_CTRL | 0x0)
#define KS_RCTRL (KS_CONTROL_CTRL | 0x1)

#define KS_LALT (KS_CONTROL_ALT | 0x0)
#define KS_RALT (KS_CONTROL_ALT | 0x1)

struct keyevent {
    unsigned char press;        // 0 when release
    unsigned char keysym;
};


#define KBD_STATE_F0 0x1
#define KBD_STATE_E0 0x2
#define KBD_STATE_LSHIFT 0x4
#define KBD_STATE_RSHIFT 0x8
#define KBD_STATE_EITHER_SHIFT 0xc

struct keyboard_driver {
    unsigned char state;
};

void init_keyboard_driver(struct keyboard_driver *drv);

int read_next_keyevent(struct keyevent *ev,
                       struct keyboard_driver *drv);

#endif

