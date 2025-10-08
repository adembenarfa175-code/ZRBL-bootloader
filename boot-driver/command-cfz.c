// boot-driver/command-cfz.c - The main C function for ZRBL

#include "zrbl_common.h"

// Define global variables
uint32_t g_partition_start_lba = 0;
uint8_t g_active_drive = 0x80; 
boot_mode_t g_boot_mode = BOOT_MODE_UNKNOWN; 

void zrbl_main() {
    zrbl_puts("ZRBL Bootloader - Version 2025.3.1.0 (Secure)\n");
    
    if (g_boot_mode == BOOT_MODE_BIOS) {
        zrbl_puts("INFO: Running in BIOS/Legacy Mode.\n");
    } else if (g_boot_mode == BOOT_MODE_UEFI) {
        zrbl_puts("INFO: Running in UEFI Mode (Future Support).\n");
    }

    // 1. Initialize File System (FAT)
    fat_init(g_active_drive, g_partition_start_lba);
    
    // 2. Search for configuration file (BOOT.CFZ)
    FAT_DirEntry* boot_config = fat_find_file("BOOT.CFZ");
    
    if (boot_config != NULL) {
        zrbl_puts("INFO: BOOT.CFZ found securely.\n");
    } else {
        zrbl_puts("ERROR: BOOT.CFZ not found or invalid.\n");
    }
    
    while (1) { /* Halt */ }
}
