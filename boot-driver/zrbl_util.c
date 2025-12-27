#include "zrbl_common.h"
size_t zrbl_strlen(const char* s) { size_t l=0; while(s[l]) l++; return l; }
void* zrbl_memset(void* s, int c, size_t n) {
    unsigned char* p=(unsigned char*)s; while(n--) *p++=(unsigned char)c; return s;
}
void zrbl_puts(const char* s) {
    unsigned short* vga = (unsigned short*)0xB8000;
    static int pos = 0;
    for (int i = 0; s[i] != '\0'; i++) {
        vga[pos++] = (unsigned short)s[i] | (0x0F << 8);
    }
}
void zrbl_secure_clear_memory(void* s, size_t z) {
    if(s==0 || z==0) return;
    zrbl_memset(s, 0, z);
    zrbl_puts("[MEM_CLEARED] ");
}
