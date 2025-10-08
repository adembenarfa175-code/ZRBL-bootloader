// boot-driver/command-cfz.c - The main C function for ZRBL

#include "zrbl_common.h"
// #include "fat.h"
// #include "ext4.h"

// Define global variables (required by zrbl_common.h)
uint32_t g_partition_start_lba = 0;
uint8_t g_active_drive = 0x80; // First hard drive (BIOS convention)

// Global state variable for boot environment
// Must be initialized by Assembly/UEFI entry code
boot_mode_t g_boot_mode = BOOT_MODE_UNKNOWN; 

// The primary C entry point, called from boot.asm or UEFI code
void zrbl_main() {
    // 1. Display version information
    zrbl_puts("ZRBL Bootloader - Version 2025.3.0.0 (Secure Init)\n");
    zrbl_puts("Initializing, focusing on secure memory and dual boot mode...\n");

    // 2. Check and report the boot mode
    if (g_boot_mode == BOOT_MODE_BIOS) {
        zrbl_puts("INFO: Running in BIOS/Legacy Mode.\n");
    } else if (g_boot_mode == BOOT_MODE_UEFI) {
        zrbl_puts("INFO: Running in UEFI Mode (Future Support).\n");
    } else {
        zrbl_puts("WARN: Boot Mode UNKNOWN. Proceeding with caution.\n");
    }

    // 3. File System Initialization
    // fat_init(g_active_drive, g_partition_start_lba);
    
    // 4. Critical File Search (e.g., "boot.cfz")
    // FAT_DirEntry* boot_config = fat_find_file("BOOT.CFZ");

    // Infinite loop (Halt if kernel loading fails)
    while (1) {
        // ...
    }
}
