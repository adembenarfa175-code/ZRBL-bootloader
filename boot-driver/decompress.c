#include "zrbl_common.h"
int zrbl_decompress_kernel(void* src, void* dst) {
    (void)src; (void)dst;
    uint32_t max = 0x4000000; (void)max;
    zrbl_puts("DECOMPRESS: Ready.");
    return 0;
}
