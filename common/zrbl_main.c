#include "zrbl_common.h"
void zrbl_main(void) {
    zrbl_puts("ZRBL_V2025.6_LOADED_SUCCESSFULLY ");
    zrbl_secure_clear_memory((void*)0x100000, 0x1000);
    while(1);
}
