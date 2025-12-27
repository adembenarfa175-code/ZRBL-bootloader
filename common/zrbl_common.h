#ifndef ZRBL_COMMON_H
#define ZRBL_COMMON_H

typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long long uint64_t;
typedef uint32_t size_t;

typedef struct {
    uint8_t name[11];
    uint8_t attr;
    uint8_t reserved;
    uint32_t size;
    uint16_t first_cluster;
} FAT_DirEntry;

size_t zrbl_strlen(const char* s);
char* zrbl_strncpy(char* d, const char* s, size_t n);
void* zrbl_memset(void* s, int c, size_t n);
void zrbl_puts(const char* s);
void zrbl_secure_clear_memory(void* s, size_t z);

int fat_init(uint8_t d, uint32_t p);
FAT_DirEntry* fat_find_file(const char* f);
int zrbl_decompress_kernel(void* s, void* d);
void zrbl_main(void);

#endif
