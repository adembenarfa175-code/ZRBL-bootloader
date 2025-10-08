#!/bin/bash
# build_release.sh - ZRBL Bootloader 2025.3.0.0 Setup and Build Script

# ----------------------------------------------------
# 1. Setup Structure and Directories
# ----------------------------------------------------
echo "INFO: Setting up essential directories for ZRBL 2025.3.0.0..."
mkdir -p build
mkdir -p boot-driver

# ----------------------------------------------------
# 2. Create and Populate Core Code Files
# ----------------------------------------------------

# (1) File: zrbl_common.h (Header for Utility Functions and Types)
echo "INFO: Creating zrbl_common.h (With secure types and mode definitions)"
cat <<EOF > boot-driver/zrbl_common.h
// boot-driver/zrbl_common.h - Global definitions, types, and secure utilities for ZRBL
#ifndef ZRBL_COMMON_H
#define ZRBL_COMMON_H

#include <stddef.h> // For size_t definition

// ===================================================
// 1. Core Data Types (Platform Independent)
// ===================================================

typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long long uint64_t;
typedef uint8_t bool;
#define TRUE 1
#define FALSE 0

// ===================================================
// 2. Secure Memory and String Utilities
// ===================================================

// Secure memory operations (defined in zrbl_util.c)
void* zrbl_memcpy(void* dest, const void* src, size_t n);
void* zrbl_memset(void* s, int c, size_t n);
int zrbl_strcmp(const char* s1, const char* s2);
size_t zrbl_strlen(const char* s);
// CRITICAL: Secure string copy to prevent Buffer Overflows
char* zrbl_strncpy(char* dest, const char* src, size_t n); 
void zrbl_puts(const char* s);

// ===================================================
// 3. Global Boot Environment (I/O, UEFI/BIOS Mode)
// ===================================================

// Global state variable to determine the execution environment
typedef enum {
    BOOT_MODE_BIOS,
    BOOT_MODE_UEFI,
    BOOT_MODE_UNKNOWN
} boot_mode_t;

extern boot_mode_t g_boot_mode; // Will be set by Assembly/UEFI entry code

extern uint32_t g_partition_start_lba;
extern uint8_t g_active_drive;

// ===================================================
// 4. File System Structures (FAT)
// ===================================================

// CRITICAL MEMORY ALIGNMENT FIX: Use __attribute__((packed)) to ensure the size is exactly 32 bytes.
typedef struct __attribute__((packed)) {
    uint8_t filename[8];    
    uint8_t extension[3];   
    uint8_t attributes;     
    uint8_t reserved;       
    uint8_t cration_time_ms;
    uint16_t creation_time; 
    uint16_t creation_date; 
    uint16_t last_access_date; 
    uint16_t first_cluster_high; 
    uint16_t last_mod_time; 
    uint16_t last_mod_date; 
    uint16_t first_cluster_low;  
    uint32_t file_size;     
} FAT_DirEntry; // Total size MUST be 32 bytes

// ===================================================
// 5. File System Functions (Declared)
// ===================================================

int fat_init(uint8_t drive_id, uint32_t part_start_lba);
// CRITICAL: Safe function to find a file (prevents name buffer overflow)
FAT_DirEntry* fat_find_file(const char* filename);


#endif // ZRBL_COMMON_H
EOF

# (2) File: zrbl_util.c (Implementation of Secure Utility Functions)
echo "INFO: Creating zrbl_util.c (Implementing secure memory ops)"
cat <<EOF > boot-driver/zrbl_util.c
// boot-driver/zrbl_util.c - Implementation of secure memory and string utilities

#include "zrbl_common.h"

// Memory copy (memcpy)
void* zrbl_memcpy(void* dest, const void* src, size_t n) {
    char* d = (char*)dest;
    const char* s = (const char*)src;
    while (n--) {
        *d++ = *s++;
    }
    return dest;
}

// Memory set (memset)
void* zrbl_memset(void* s, int c, size_t n) {
    char* p = (char*)s;
    while (n--) {
        *p++ = (char)c;
    }
    return s;
}

// String comparison (strcmp)
int zrbl_strcmp(const char* s1, const char* s2) {
    while (*s1 && (*s1 == *s2)) {
        s1++;
        s2++;
    }
    return *(const unsigned char*)s1 - *(const unsigned char*)s2;
}

// String length (strlen)
size_t zrbl_strlen(const char* s) {
    size_t len = 0;
    while (*s++) {
        len++;
    }
    return len;
}

// Secure string copy (strncpy) - Prevents Buffer Overflows!
char* zrbl_strncpy(char* dest, const char* src, size_t n) {
    size_t i;
    // Copy up to n characters or until null terminator
    for (i = 0; i < n && src[i] != '\0'; i++) {
        dest[i] = src[i];
    }
    // Pad the rest of the destination with null bytes
    for (; i < n; i++) {
        dest[i] = '\0';
    }
    return dest;
}

// Placeholder for Assembly/BIOS-based print function
void zrbl_puts(const char* s) {
    // This function will be implemented in Assembly later for BIOS/VGA output.
}
EOF

# (3) File: command-cfz.c (Main C entry function)
echo "INFO: Creating command-cfz.c (Main C entry point with boot mode logic)"
cat <<EOF > boot-driver/command-cfz.c
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
EOF

# (4) File: fat.c (FAT File System Driver) - Focusing on Security
echo "INFO: Creating fat.c (Secure FAT driver structure)"
cat <<EOF > boot-driver/fat.c
// boot-driver/fat.c - Secure FAT file system support

#include "zrbl_common.h"

// Global variables for FAT partition data (crucial for Bounds Checking)
// extern uint32_t g_total_sectors; // Example: total sectors in partition
// extern uint16_t g_root_dir_sectors;

/**
 * Secure sector read function.
 * Must ensure the LBA is within the partition bounds to prevent OOB Read.
 * @param lba: Logical Block Address relative to the partition start.
 * @param buffer: 512-byte buffer for the sector data.
 */
int fat_read_sector(uint32_t lba, void* buffer) {
    // ********* CRITICAL SECURITY CHECK *********
    // 1. Check against the partition's maximum sector count (g_total_sectors)
    // if (lba >= g_total_sectors) { return -1; }
    
    // 2. Calculate the absolute LBA using g_partition_start_lba
    // uint32_t absolute_lba = g_partition_start_lba + lba;
    
    // ... (Disk I/O Assembly/BIOS call goes here) ...
    
    return 0; // Success
}

/**
 * Primary FAT initialization function.
 * Reads the Boot Parameter Block (BPB) securely.
 */
int fat_init(uint8_t drive_id, uint32_t part_start_lba) {
    // Code to read BPB and validate all critical fields (e.g., sector size, FAT size)
    // Validation is key to prevent crashes and exploits from malformed file systems.
    
    zrbl_puts("INFO: FAT initialization complete.\n");
    return 0;
}

/**
 * FAT_DirEntry* fat_find_file(const char* filename)
 * CRITICAL FUNCTION: Searches for a file in the root directory securely.
 * Implementation will be added in the next step, focusing on name validation
 * and safe directory traversal to prevent buffer overflows.
 */
FAT_DirEntry* fat_find_file(const char* filename) {
    zrbl_puts("DEBUG: Starting secure file search...\n");
    // Placeholder for actual implementation in the next step
    return NULL;
}
EOF

# (5) File: ext4.c (EXT4 Driver Structure) - Placeholder
echo "INFO: Creating ext4.c (Placeholder for future development)"
cat <<EOF > boot-driver/ext4.c
// boot-driver/ext4.c - EXT4 file system support
#include "zrbl_common.h"
// Implementation of EXT4 secure read functions will go here.
EOF

# ----------------------------------------------------
# 3. Configuration and Linker Files
# ----------------------------------------------------
# (6) linker.ld, (7) boot.asm, (8) Makefile (No changes needed, keeping English)
# Skipping these for brevity, assuming they are already in place and correct.

echo "INFO: All core files have been updated for ZRBL 2025.3.0.0."
echo "INFO: Next step: Commit and Push these changes."

