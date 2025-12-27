#ifndef ZRBL_COMMON_H
#define ZRBL_COMMON_H
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long long uint64_t;
typedef uint32_t size_t;
typedef struct { uint8_t n[11]; uint8_t a; uint32_t s; uint16_t c; } FAT_DirEntry;
size_t zrbl_strlen(const char* s);
void* zrbl_memset(void* s, int c, size_t n);
void zrbl_puts(const char* s);
void zrbl_secure_clear_memory(void* s, size_t z);
void zrbl_main(void);
#endif
