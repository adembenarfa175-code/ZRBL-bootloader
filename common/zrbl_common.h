#ifndef ZRBL_COMMON_H
#define ZRBL_COMMON_H

#include <stdint.h>
#define ZRBL_VERSION "2025.6.7-LTS"
#define ZRBL_IS_LTS 1
#define MEM_ALIGN_CHECK 1

// LTS Stability: Strict Memory Boundaries
#define STACK_BASE 0x90000
#define KERNEL_LOAD 0x100000

/* Forward Declaration for Safety */
void zrbl_kernel_main(void);
void zrbl_log(const char* msg);

#endif
