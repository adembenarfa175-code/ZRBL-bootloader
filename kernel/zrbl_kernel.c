#include "../common/zrbl_common.h"

// Define the entry point for the linker
void _start() {
    zrbl_kernel_main();
}

void zrbl_kernel_main() {
    zrbl_log("ZRBL Kernel Active v2025.6.5.2");
    while(1);
}
