#ifndef ZRBL_GLOBAL_H
#define ZRBL_GLOBAL_H
#include <stdint.h>
#define ZRBL_VERSION "2025.6.3"
#define MEM_BASE 0x100000
#define MAX_FILES 64
typedef struct {
    uint64_t total_mem;
    uint32_t boot_drive;
    uint32_t status;
} zrbl_state_t;
void zrbl_log(const char* msg);
#endif
