// boot-driver/zrbl_common.h - Utility functions and data types for ZRBL
#ifndef ZRBL_COMMON_H
#define ZRBL_COMMON_H

#include <stddef.h> // For size_t definition

// Basic data type definitions for the bootloader environment
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long long uint64_t;

// Secure memory and string utility functions (implemented in zrbl_util.c)
void* zrbl_memcpy(void* dest, const void* src, size_t n);
void* zrbl_memset(void* s, int c, size_t n);
int zrbl_strcmp(const char* s1, const char* s2);
size_t zrbl_strlen(const char* s);
// SECURE function: Limits copy size to prevent Buffer Overflows (Crucial for 2025.2.0.0)
char* zrbl_strncpy(char* dest, const char* src, size_t n); 

// Print function (relies on Assembly/BIOS calls)
void zrbl_puts(const char* s);

// Global variables (Disk I/O and Partition info)
extern uint32_t g_partition_start_lba;
extern uint8_t g_active_drive;

#endif // ZRBL_COMMON_H
