#include "zrbl_common.h"
void zrbl_main(void) {
    zrbl_puts("ZRBL CORE V2025.6.0.0 STARTED ");
    zrbl_secure_clear_memory((void*)0x100000, 0x1000);
    while(1);
}
