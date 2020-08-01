#include <conio.h>
#include "keyboard.h"
#include "common.h"

#define WIDTH 128
#define HEIGHT 64
#define BALL_POS_SHIFT 5
#define PAD_X 8
#define PAD_SIZE 8

struct Player {
    unsigned char x;
    unsigned char y;
    unsigned char score;
};

static struct Player p[2];

struct Ball {
    unsigned int x;
    unsigned int y;
    signed int dx;
    signed int dy;
};

static struct Ball ball;

struct KeyState {
    char up;
    char down;
};

static struct KeyState keys[2];
static struct keyboard_driver keyboard;

static unsigned char display_data[128 * 8];

#define P0_UP 'w'
#define P0_DOWN 's'

#define P1_UP KS_UP
#define P1_DOWN KS_DOWN

static void
update_display(unsigned char x, unsigned char y, unsigned char nx)
{
    int i;
    spi_display_set_cursor(x, y);
    spi_display_to_data();
    for (i=0; i<nx; i++) {
        spi_display_out(display_data[y*128 + x + i]);
    }
    spi_display_to_command();
}

static void
render_player(struct Player *p)
{
    unsigned char x = p->x;
    unsigned char disp_y = p->y / 8U;

    if ((p->y & 7) == 0) {
        /* aligned */
        display_data[disp_y*128 + x] ^= 0xff;

        update_display(x, disp_y, 1);
    } else {
        unsigned char ymod0 = p->y & 7;
        unsigned char ymod1 = 8-ymod0;
        unsigned char c0 = 0xff << ymod0;
        unsigned char c1 = 0xff >> ymod1;

        display_data[(disp_y+0)*128 + x] ^= c0;
        display_data[(disp_y+1)*128 + x] ^= c1;

        update_display(x, disp_y, 1);
        update_display(x, disp_y+1, 1);
    }
}

static void
render_ball(struct Ball *b)
{
    unsigned char x = b->x >> BALL_POS_SHIFT;
    unsigned char y = b->y >> BALL_POS_SHIFT;

    unsigned char disp_y = y / 8U;

    if ((y & 7) != 7) {
        /* aligned */
        unsigned char ymod = y & 7;
        unsigned char c0 = 0x3 << ymod;

        display_data[disp_y*128 + x+0] ^= c0;
        display_data[disp_y*128 + x+1] ^= c0;

        update_display(x, disp_y, 2);
    } else {
        unsigned char c0 = 0x80;
        unsigned char c1 = 0x01;

        display_data[(disp_y+0)*128 + x+0] ^= c0;
        display_data[(disp_y+0)*128 + x+1] ^= c0;

        display_data[(disp_y+1)*128 + x+0] ^= c1;
        display_data[(disp_y+1)*128 + x+1] ^= c1;

        update_display(x, disp_y+0, 2);
        update_display(x, disp_y+1, 2);
    }
}


static void
handle_keyboard()
{
    while (1) {
        struct keyevent ke;
        int update;
        int k = read_next_keyevent(&ke, &keyboard);
        if (k == 0) {
            break;
        }

        update = 0;

        if (ke.press) {
            update = 1;
        }

        switch (ke.keysym) {
        case P0_UP:
            keys[0].up = update;
            break;
        case P0_DOWN:
            keys[0].down = update;
            break;
        case P1_UP:
            keys[1].up = update;
            break;
        case P1_DOWN:
            keys[1].down = update;
            break;
        }
    }
}

static void
render_char(unsigned char x,
            unsigned char yline,
            unsigned char c)
{
    unsigned char *p = &display_data[yline*WIDTH + x];
    const unsigned char *fp = &fonts[(c - ' ') * 6];
    int i;

    p[0] ^= fp[0];
    p[1] ^= fp[1];
    p[2] ^= fp[2];
    p[3] ^= fp[3];
    p[4] ^= fp[4];
    p[5] ^= fp[5];
}

static void
render_digit3(unsigned char x,
              unsigned char yline,
              int val)
{
    if (val < 10) {
        render_char(x+8*2, yline, val+'0');
    } else if (val < 100) {
        render_char(x+8*1, yline, (val/10)+'0');
        render_char(x+8*2, yline, (val%10)+'0');
    } else {
        render_char(x    , yline, (val/100)+'0');
        render_char(x+8*1, yline, (val/10)%10+'0');
        render_char(x+8*2, yline, (val%10)+'0');
    }
}

static void
render_score()
{
    render_digit3(64-4 - 8*3, 1, p[0].score);
    render_char(64-4, 1, '-');
    render_digit3(64+4      , 1, p[1].score);

    update_display(64-4 - 8*3, 1, 8*7);
}

static void
init_ball(int dir)
{
    if (dir) {
        ball.dx = 1 << (BALL_POS_SHIFT - 2);
    } else {
        ball.dx = -(1 << (BALL_POS_SHIFT - 2));
    }
    ball.dy = 1 << (BALL_POS_SHIFT - 3);

    ball.x = 64 << BALL_POS_SHIFT;
    ball.y = 32 << BALL_POS_SHIFT;
}


static void
change_dy(int y)
{
    static const int dy_tbl[] = {-8, -4, -2, -1, 0, 0, 1, 2, 4, 8};
    int v = dy_tbl[y];

    ball.dy += v;
}

static void
next_step()
{
    int pi;
    int next_x, next_y;
    int ball_x, ball_y;

    for (pi=0; pi<2; pi++) {
        if (keys[pi].up && p[pi].y > 0) {
            render_player(&p[pi]);
            p[pi].y--;
            render_player(&p[pi]);
        }
        if (keys[pi].down && p[pi].y < HEIGHT-8) {
            render_player(&p[pi]);
            p[pi].y++;
            render_player(&p[pi]);
        }
    }

    render_ball(&ball);

    ball_x = ball.x >> BALL_POS_SHIFT;
    ball_y = ball.y >> BALL_POS_SHIFT;

    if (ball.dx < 0) {
        if ((ball_x == PAD_X) || (ball_x+1 == PAD_X)) {
            if ((ball_y >= p[0].y-1) && (ball_y <= p[0].y + PAD_SIZE)) {
                int hit_y = ball_y -(p[0].y-1);
                ball.dx = (-ball.dx) + 1;
                change_dy(hit_y);
            }
        }
    } else {
        if ((ball_x == WIDTH - PAD_X - 1) || (ball_x+1 == WIDTH - PAD_X - 1)) {
            if ((ball_y >= p[1].y-1) && (ball_y <= p[1].y + PAD_SIZE)) {
                int hit_y = ball_y - (p[1].y-1);
                ball.dx = (-ball.dx) - 1;
                change_dy(hit_y);
            }
        }
    }

    next_x = ball.x + ball.dx;
    next_y = ball.y + ball.dy;

    if (next_x < 0) {
        render_score();
        p[1].score ++;
        render_score();
        init_ball(1);
    }

    if (next_x >= ((WIDTH-1) << BALL_POS_SHIFT)) {
        render_score();
        p[0].score++;
        render_score();
        init_ball(0);
    }

    if ((next_y < 0) || next_y >= ((HEIGHT-1) << BALL_POS_SHIFT)) {
        ball.dy = -ball.dy;
    }

    ball.x += ball.dx;
    ball.y += ball.dy;
    render_ball(&ball);
}



void
cmain()
{
    int i, cnt;
    spi_display_init();
    spi_display_to_data();
    for (i=0; i<128*8; i++) {
        spi_display_out(0);
    }
    spi_display_to_command();

    init_keyboard_driver(&keyboard);

    memset(display_data, 0, 128*8);

    p[0].x = PAD_X;
    p[0].y = 0;
    p[0].score = 0;

    p[1].x = 127 - PAD_X;
    p[1].y = 0;
    p[1].score = 0;

    init_ball(0);

    keys[0].up = 0;
    keys[0].down = 0;
    keys[1].up = 0;
    keys[1].down = 0;

    render_player(&p[0]);
    render_player(&p[1]);
    render_score();
    render_ball(&ball);

    cnt = 0;
    while (1) {
        handle_keyboard();

        if ((cnt&0x3f) == 0) {
            next_step();
        }

        cnt++;
    }
}
