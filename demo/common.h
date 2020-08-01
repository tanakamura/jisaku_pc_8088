#ifndef COMMON_H
#define COMMON_H

void uart_output_char(unsigned char c);
void uart_output_str(const char *p);

void delay(int n);
void memset(void *dst, unsigned char val, unsigned int length);

void spi_display_init(void);
void spi_display_to_data();
void spi_display_to_command();
void spi_display_set_cursor(unsigned char x, unsigned char line);
void spi_display_disp_char(unsigned char c);
void spi_display_out(unsigned char c);

int isprint(int c);
extern const char hextbl[];
extern const unsigned char fonts[];


#endif
