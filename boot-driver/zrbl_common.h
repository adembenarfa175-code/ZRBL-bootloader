// boot-driver/zrbl_common.h - الدوال المساعدة وأنواع البيانات
#ifndef ZRBL_COMMON_H
#define ZRBL_COMMON_H

#include <stddef.h> // لتعريف size_t

// تعريفات أنواع البيانات الأساسية لبيئة البوتلودر
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long long uint64_t;

// دوال الذاكرة والسلاسل النصية الآمنة (يتم تنفيذها في zrbl_util.c)
void* zrbl_memcpy(void* dest, const void* src, size_t n);
void* zrbl_memset(void* s, int c, size_t n);
int zrbl_strcmp(const char* s1, const char* s2);
size_t zrbl_strlen(const char* s);
char* zrbl_strncpy(char* dest, const char* src, size_t n);

// دالة الطباعة (تعتمد على Assembly)
void zrbl_puts(const char* s);

// متغيرات عامة سيتم تهيئتها في command-cfz.c
extern uint32_t g_partition_start_lba;
extern uint8_t g_active_drive;

#endif // ZRBL_COMMON_H
