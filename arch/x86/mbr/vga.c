#include "../../common/zrbl_common.h"

#ifdef ARCH_X86
void arch_puts(const char* s) {
    char* video_mem = (char*)0xB8000;
    static int offset = 0;
    while (*s) {
        video_mem[offset++] = *s++;
        video_mem[offset++] = 0x07; // Light gray
    }
}
#endif
