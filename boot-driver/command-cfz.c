// boot-driver/command-cfz.c - The main C function for ZRBL

#include "zrbl_common.h"

// Define global variables
uint32_t g_partition_start_lba = 0;
uint8_t g_active_drive = 0x80; 
boot_mode_t g_boot_mode = BOOT_MODE_UNKNOWN; 

// CRITICAL FAT GLOBALS 
uint32_t g_fat_start_lba = 0;
uint32_t g_data_start_lba = 0;
uint32_t g_clusters_count = 0; 
uint8_t g_fat_type = 0;

void zrbl_main() {
    zrbl_puts("ZRBL Bootloader - Version 2025.3.3.0 (Secure)\n");
    
    // Example usage of the new parser (v2025.3.3.0)
    char test_key[16];
    char test_val[CFG_MAX_VALUE_LEN];
    const char* test_line = "KERNEL_PATH=/boot/vmlinuz-void-musl";

    if (cfz_parse_line(test_line, test_key, test_val) == 0) {
        zrbl_puts("CFG PARSE SUCCESS: Key=");
        zrbl_puts(test_key);
        zrbl_puts(", Value=");
        zrbl_puts(test_val);
        zrbl_puts("\n");
    } else {
        zrbl_puts("CFG PARSE ERROR.\n");
    }

    while (1) { /* Halt */ }
}
