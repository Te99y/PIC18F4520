#include <xc.h>

//extern unsigned char is_square(unsigned int a);
//extern unsigned int multi_signed(unsigned char a, unsigned char b);
extern unsigned int lcm(unsigned int a, unsigned int b);

void main(void) {
    
//    volatile unsigned char ans = is_square(9);
//    volatile  unsigned int ans = multi_signed(-30, 4);
    volatile  unsigned int ans = lcm(40, 140);
    
    while(1);
    return;
}
