#include "../common/zrbl_common.h"

/* Forward declaration for v2025.6.5.3 */
void zrbl_kernel_main(void);

void _start(void) {
    zrbl_kernel_main();
}

void zrbl_kernel_main(void) {
    zrbl_log("ZRBL Kernel Active v2025.6.7-LTS");
    while(1);
}
