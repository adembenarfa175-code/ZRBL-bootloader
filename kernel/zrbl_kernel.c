#include "../common/zrbl_common.h"

void zrbl_kernel_main() {
    zrbl_log("Kernel Initialized v2025.6.5");
    
    /* Global stack alignment fix for x86 targets */
    #ifdef __i386__
    __asm__ volatile("and $0xfffffff0, %%esp" : : : "memory");
    #endif

    while(1);
}
