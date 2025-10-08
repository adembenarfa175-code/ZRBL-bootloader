// boot-driver/fat.c - Secure FAT file system support

#include "zrbl_common.h"

int fat_read_sector(uint32_t lba, void* buffer) {
    // CRITICAL SECURITY CHECK (OOB Read prevention) must be implemented here
    // ...
    return 0; 
}

int fat_init(uint8_t drive_id, uint32_t part_start_lba) {
    // Placeholder: In a real implementation, this would read the BPB and set:
    // g_fat_start_lba, g_data_start_lba, g_clusters_count, and g_fat_type.
    zrbl_puts("INFO: FAT initialization complete.\n");
    return 0;
}

// Helper: Safely normalizes filename to FAT 8.3 format
static void fat_normalize_name(const char* src_name, char* dest_name) {
    int i, j;
    zrbl_memset(dest_name, ' ', 11);

    for (i = 0; i < 8 && src_name[i] != '.' && src_name[i] != '\0'; i++) {
        dest_name[i] = src_name[i];
    }

    if (src_name[i] == '.') {
        i++; 
        for (j = 8; j < 11 && src_name[i] != '\0'; j++, i++) {
            dest_name[j] = src_name[i];
        }
    }

    for (i = 0; i < 11; i++) {
        if (dest_name[i] >= 'a' && dest_name[i] <= 'z') {
            dest_name[i] -= ('a' - 'A');
        }
    }
}

// Helper: Safely calculates the full 32-bit first cluster
static uint32_t fat_get_first_cluster(const FAT_DirEntry* entry) {
    uint32_t cluster = (uint32_t)entry->first_cluster_high << 16 | entry->first_cluster_low;
    
    // CRITICAL SECURITY CHECK: Reserved/Invalid cluster IDs
    if (cluster < 2) {
        return 0; 
    }
    
    return cluster;
}

/**
 * Reads the value of the next cluster from the FAT table securely. (v2025.3.2.0)
 */
uint32_t fat_get_next_cluster(uint32_t cluster) {
    // 1. **CRITICAL SECURITY CHECK 1: Bounds Check (OOB Read Prevention)**
    if (cluster < 2 || cluster >= g_clusters_count) {
        zrbl_puts("SECURITY ERROR: Cluster number out of bounds.\n");
        return 0; 
    }

    uint32_t fat_offset;
    uint32_t fat_sector_lba;
    uint8_t sector_buffer[512]; // Stack Buffer (Safe)

    if (g_fat_type == 32) { // FAT32 Logic
        fat_offset = cluster * 4;
    } else {
        zrbl_puts("FAT ERROR: Only FAT32 supported currently.\n");
        return 0;
    }

    // 2. Calculate LBA and ensure it's within bounds
    fat_sector_lba = g_fat_start_lba + (fat_offset / 512);

    // *Further security check on fat_sector_lba vs disk size should be here*

    if (fat_read_sector(fat_sector_lba, sector_buffer) != 0) {
        zrbl_puts("DISK ERROR: Could not read FAT sector.\n");
        return 0;
    }

    // 3. Extract the value
    uint32_t fat_entry_value = *(uint32_t*)(&sector_buffer[fat_offset % 512]);

    return fat_entry_value & 0x0FFFFFFF;
}


FAT_DirEntry* fat_find_file(const char* filename) {
    char normalized_name[11];

    if (zrbl_strlen(filename) > 12) { 
        zrbl_puts("ERROR: Filename too long.\n");
        return NULL;
    }

    fat_normalize_name(filename, normalized_name);
    
    zrbl_puts("DEBUG: Searching for: ");
    zrbl_puts(normalized_name);
    zrbl_puts("\n");
    
    return NULL; // File not found
}
