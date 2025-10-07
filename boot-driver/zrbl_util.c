// boot-driver/zrbl_util.c - تنفيذ دوال الذاكرة والسلاسل الآمنة

#include "zrbl_common.h"

// ملء الذاكرة (memcpy)
void* zrbl_memcpy(void* dest, const void* src, size_t n) {
    char* d = (char*)dest;
    const char* s = (const char*)src;
    while (n--) {
        *d++ = *s++;
    }
    return dest;
}

// ملء الذاكرة بقيمة ثابتة (memset)
void* zrbl_memset(void* s, int c, size_t n) {
    char* p = (char*)s;
    while (n--) {
        *p++ = (char)c;
    }
    return s;
}

// مقارنة سلسلة نصية (strcmp)
int zrbl_strcmp(const char* s1, const char* s2) {
    while (*s1 && (*s1 == *s2)) {
        s1++;
        s2++;
    }
    return *(const unsigned char*)s1 - *(const unsigned char*)s2;
}

// إيجاد طول السلسلة (strlen)
size_t zrbl_strlen(const char* s) {
    size_t len = 0;
    while (*s++) {
        len++;
    }
    return len;
}

// نسخ سلسلة نصية بأمان (strncpy) - مهم لمنع Buffer Overflows
char* zrbl_strncpy(char* dest, const char* src, size_t n) {
    size_t i;
    for (i = 0; i < n && src[i] != '\0'; i++) {
        dest[i] = src[i];
    }
    for (; i < n; i++) {
        dest[i] = '\0';
    }
    return dest;
}

// تنفيذ دالة الطباعة (يجب أن يتم ربطها لاحقًا بكود Assembly)
void zrbl_puts(const char* s) {
    // هذه الدالة تعتمد على كود Assembly للوصول إلى BIOS/VGA
    // سيتم تنفيذها لاحقاً في ملف Assembly منفصل.
}
