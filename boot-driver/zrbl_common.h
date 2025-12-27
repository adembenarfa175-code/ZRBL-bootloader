#ifndef ZRBL_COMMON_H
#define ZRBL_COMMON_H
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long long uint64_t;
typedef uint32_t size_t;
size_t zrbl_strlen(const char* s);
void* zrbl_memset(void* s, int c, size_t n);
void zrbl_puts(const char* s);
void zrbl_secure_clear_memory(void* s, size_t z);
void zrbl_main(void);
#endif
