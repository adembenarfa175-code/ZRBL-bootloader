#include "../common/zrbl_common.h"
void zrbl_kernel_main() {
    zrbl_log("Kernel Initialized v2025.6.3");
    // Memory fix: verify stack alignment
    asm volatile("and $0xfffffff0, %esp");
    while(1);
}
