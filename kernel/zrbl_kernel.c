#include "../common/zrbl_common.h"
void zrbl_kernel_main() {
    zrbl_log("Kernel Initialized v2025.6.3");
    __asm__ volatile("and $0xfffffff0, %%esp" : : : "esp");
    while(1);
}
