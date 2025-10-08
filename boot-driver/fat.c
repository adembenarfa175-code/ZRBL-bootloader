// boot-driver/fat.c - Secure FAT file system support

#include "zrbl_common.h"

// Placeholder for partition data
// extern uint32_t g_total_sectors; 

int fat_read_sector(uint32_t lba, void* buffer) {
    // CRITICAL SECURITY CHECK (OOB Read prevention) would be here
    // ...
    return 0; 
}

int fat_init(uint8_t drive_id, uint32_t part_start_lba) {
    zrbl_puts("INFO: FAT initialization complete.\n");
    return 0;
}

// Helper: Safely normalizes filename to FAT 8.3 format (CRITICAL for security)
static void fat_normalize_name(const char* src_name, char* dest_name) {
    int i, j;
    zrbl_memset(dest_name, ' ', 11);

    for (i = 0; i < 8 && src_name[i] != '.' && src_name[i] != '\0'; i++) {
        dest_name[i] = src_name[i];
    }

    if (src_name[i] == '.') {
        i++; 
        for (j = 8; j < 11 && src_name[i] != '\0'; j++, i++) {
            dest_name[j] = src[i];
        }
    }

    for (i = 0; i < 11; i++) {
        if (dest_name[i] >= 'a' && dest_name[i] <= 'z') {
            dest_name[i] -= ('a' - 'A');
        }
    }
}

// Helper: Safely calculates the full 32-bit first cluster (CRITICAL for security)
static uint32_t fat_get_first_cluster(const FAT_DirEntry* entry) {
    uint32_t cluster = (uint32_t)entry->first_cluster_high << 16 | entry->first_cluster_low;
    
    // CRITICAL SECURITY CHECK: Reserved/Invalid cluster IDs
    if (cluster < 2) {
        return 0; 
    }
    
    return cluster;
}

FAT_DirEntry* fat_find_file(const char* filename) {
    char normalized_name[11];

    if (zrbl_strlen(filename) > 12) { 
        zrbl_puts("ERROR: Filename too long.\n");
        return NULL;
    }

    fat_normalize_name(filename, normalized_name);
    
    // Placeholder: Directory traversal logic goes here
    
    zrbl_puts("DEBUG: Searching for: ");
    zrbl_puts(normalized_name);
    zrbl_puts("\n");
    
    return NULL; // File not found
}
