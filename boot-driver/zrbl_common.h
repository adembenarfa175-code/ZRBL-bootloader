// boot-driver/zrbl_common.h - Global definitions, types, and secure utilities for ZRBL
#ifndef ZRBL_COMMON_H
#define ZRBL_COMMON_H

#include <stddef.h> 

// ===================================================
// 1. Core Data Types
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

void* zrbl_memcpy(void* dest, const void* src, size_t n);
void* zrbl_memset(void* s, int c, size_t n);
int zrbl_strcmp(const char* s1, const char* s2);
size_t zrbl_strlen(const char* s);
char* zrbl_strncpy(char* dest, const char* src, size_t n); 
void zrbl_puts(const char* s);

// ===================================================
// 3. Global Boot Environment (UEFI/BIOS Mode & FAT Globals)
// ===================================================

typedef enum {
    BOOT_MODE_BIOS,
    BOOT_MODE_UEFI,
    BOOT_MODE_UNKNOWN
} boot_mode_t;

extern boot_mode_t g_boot_mode;
extern uint32_t g_partition_start_lba;
extern uint8_t g_active_drive;

// ** New FAT Global Declarations for Security (v2025.3.2.0) **
extern uint32_t g_fat_start_lba;
extern uint32_t g_data_start_lba;
extern uint32_t g_clusters_count; // CRITICAL for Bounds Checking
extern uint8_t g_fat_type;

// ===================================================
// 4. File System Structures (FAT) - With CRITICAL Security Fix
// ===================================================

// CRITICAL MEMORY ALIGNMENT FIX: __attribute__((packed))
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
} FAT_DirEntry;

// ===================================================
// 5. File System Functions
// ===================================================

int fat_init(uint8_t drive_id, uint32_t part_start_lba);
FAT_DirEntry* fat_find_file(const char* filename);
// New Function (v2025.3.2.0)
uint32_t fat_get_next_cluster(uint32_t cluster);

#endif // ZRBL_COMMON_H
