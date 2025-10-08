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
