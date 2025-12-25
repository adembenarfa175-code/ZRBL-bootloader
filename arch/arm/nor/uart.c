#include "../../common/zrbl_common.h"

#ifdef ARCH_ARM
void arch_puts(const char* s) {
    // Assuming PL011 UART for ARM (e.g. Raspberry Pi)
    volatile unsigned int *UART0_DR = (unsigned int *)0x3F201000;
    while (*s) {
        *UART0_DR = (unsigned int)(*s++);
    }
}
#endif
