#!/bin/bash
# build_release.sh - سكريبت إعداد وبناء ZRBL Bootloader 2025.2.0.0

# ----------------------------------------------------
# 1. إعداد الهيكل والمجلدات
# ----------------------------------------------------
echo "INFO: إعداد هيكل المجلدات الأساسية..."
mkdir -p build
mkdir -p boot-driver

# ----------------------------------------------------
# 2. إنشاء وتعبئة ملفات الكود الأساسية
# ----------------------------------------------------

# (1) ملف: zrbl_common.h (رأس الدوال المساعدة والأنواع)
echo "INFO: إنشاء zrbl_common.h"
cat <<EOF > boot-driver/zrbl_common.h
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
EOF

# (2) ملف: zrbl_util.c (تنفيذ الدوال المساعدة الآمنة)
echo "INFO: إنشاء zrbl_util.c (تجنب أخطاء الذاكرة)"
cat <<EOF > boot-driver/zrbl_util.c
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
EOF

# (3) ملف: command-cfz.c (الدالة الرئيسية لكود C)
echo "INFO: إنشاء command-cfz.c (الدالة الرئيسية)"
cat <<EOF > boot-driver/command-cfz.c
// boot-driver/command-cfz.c - الدالة الرئيسية C لـ ZRBL

#include "zrbl_common.h"
// #include "fat.h"
// #include "ext4.h"

// تعريف المتغيرات العامة (مهمة لدوال I/O للقرص)
uint32_t g_partition_start_lba = 0;
uint8_t g_active_drive = 0x80; // القرص الصلب الأول

// نقطة الدخول الرئيسية لكود C
void zrbl_main() {
    // 1. الترحيب بالإصدار
    zrbl_puts("ZRBL Bootloader - Version 2025.2.0.0\n");
    zrbl_puts("Initializing, focused on secure memory management...\n");

    // 2. هنا سيتم تهيئة أنظمة الملفات (fat_init, ext4_init)
    
    // 3. هنا سيتم قراءة ملف الإعدادات (boot.cfz) وتحليل الأوامر
    
    // 4. هنا سيتم تحميل النواة والقفز إليها
    
    // حلقة لا نهائية (للتوقف إذا لم يتم تحميل النواة)
    while (1) {
        // يمكنك هنا عرض رسالة خطأ
    }
}
EOF

# (4) ملف: fat.c (دوال FAT) - سنضع الهيكل الأساسي الآمن الآن
echo "INFO: إنشاء fat.c (الهيكل الأساسي الآمن)"
cat <<EOF > boot-driver/fat.c
// boot-driver/fat.c - دعم قراءة نظام ملفات FAT الآمن

#include "zrbl_common.h"
// #include "fat.h" // سيتم إنشاء ملف الرأس لاحقاً

// متغيرات FAT العامة لضمان التحقق من الحدود (Bounds Checking)
// uint32_t g_total_sectors; // مثال: لحفظ عدد القطاعات الكلي للقسم

// دالة القراءة الآمنة للقطاعات (مثال للتحقق الأمني)
int fat_read_sector(uint32_t lba, void* buffer) {
    // *** هنا يجب إضافة التحقق من أن LBA لا يتجاوز g_total_sectors ***
    // if (lba >= g_total_sectors) { return -1; }
    
    // حالياً، سنفترض أن هذه الدالة تستدعي دالة قراءة منخفضة المستوى (Assembly/BIOS)
    
    return 0;
}

// دالة التهيئة الأساسية لـ FAT
int fat_init(uint8_t drive_id, uint32_t part_start_lba) {
    // ... يتم هنا قراءة BPB والتحقق من صحة جميع القيم
    // هذه العملية يجب أن تكون آمنة ضد قراءة البيانات خارج النطاق (OOB Read)
    
    zrbl_puts("INFO: FAT initialization complete.\n");
    return 0;
}
EOF

# (5) ملف: ext4.c (دوال EXT4) - هيكل فارغ
echo "INFO: إنشاء ext4.c (هيكل فارغ)"
cat <<EOF > boot-driver/ext4.c
// boot-driver/ext4.c - دعم قراءة نظام ملفات EXT4
#include "zrbl_common.h"
// سيتم تنفيذ الدوال لاحقاً
EOF

# ----------------------------------------------------
# 3. ملفات الإعداد والربط
# ----------------------------------------------------

# (6) ملف: linker.ld (سكريبت الرابط)
echo "INFO: إنشاء linker.ld"
cat <<EOF > linker.ld
/* linker.ld - ZRBL Linker Script */

ENTRY(zrbl_main)

SECTIONS
{
    /* العنوان الأساسي الذي سيبدأ عنده تحميل ZRBL في الذاكرة */
    . = 0x10000; 

    /* قسم النص (الكود القابل للتنفيذ) */
    .text :
    {
        *(.text)
    }

    /* قسم البيانات القابلة للتعديل */
    .data :
    {
        *(.data)
    }

    /* قسم البيانات الثابتة (للقراءة فقط) */
    .rodata :
    {
        *(.rodata)
    }

    /* قسم .bss للبيانات غير المهيئة (يجب تصفيره في البداية) */
    .bss :
    {
        *(.bss)
        . = ALIGN(4); /* ضمان المحاذاة */
    }

    /* نهاية البرنامج */
    /DISCARD/ :
    {
        *(.fini)
        *(.eh_frame)
    }
}
EOF

# (7) ملف: boot.asm (كود التجميع المصحح)
echo "INFO: إنشاء boot-driver/boot.asm (مصدر خطأ CV0001)"
cat <<EOF > boot-driver/boot.asm
; /boot/zrbl/boot-driver/boot.asm - ZRBL Stage 2/3 Loader
;
; يتم تجميع هذا الملف بصيغة ELF ليتم ربطه مع كود C (command-cfz.c)
;
; مرخص بموجب رخصة جنو العمومية (GPLv3 أو أي إصدار لاحق).
;

; ***************************************************************
; التوجيهات الأساسية
; ***************************************************************

BITS 32                 ; يجب أن نكون في وضع 32-بت (Protected Mode)
section .text           ; قسم الكود القابل للتنفيذ

; ***************************************************************
; تعريفات خارجية وداخلية
; ***************************************************************

extern zrbl_main        ; دالة C الرئيسية (نقطة الدخول الفعلية)
global _start           ; نقطة الدخول الأساسية لملف ELF

; ***************************************************************
; نقطة الدخول والقفز إلى C
; ***************************************************************

_start:
    ; -------------------------------------------------------------
    ; إعداد مقاطع الذاكرة الأساسية (Segments)
    ; -------------------------------------------------------------
    
    mov ax, 0x10        ; قيمة محدد مقطع البيانات (D-Segment Selector)
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    
    ; -------------------------------------------------------------
    ; إعداد المكدس (Stack) لكود C
    ; -------------------------------------------------------------
    mov esp, 0x90000    ; تعيين رأس المكدس (Stack Pointer)

    ; -------------------------------------------------------------
    ; القفز إلى دالة C
    ; -------------------------------------------------------------
    call zrbl_main      ; استدعاء الدالة الرئيسية في command-cfz.c

    ; -------------------------------------------------------------
    ; النهاية
    ; -------------------------------------------------------------
.halt:
    cli                     ; إيقاف المقاطعات (Disable Interrupts)
    hlt                     ; إيقاف المعالج (Halt)
    jmp .halt               ; حلقة لا نهائية
EOF

# (8) ملف: Makefile
echo "INFO: إنشاء Makefile"
cat <<EOF > Makefile
# Makefile لـ ZRBL Bootloader 2025.2.0.0
#
# مرخص بموجب رخصة جنو العمومية (GPLv3 أو أي إصدار لاحق).

# ***************************************************************
# الأدوات والمترجمات
# ***************************************************************
CC       := gcc
LD       := ld
AS       := nasm
OBJCOPY  := objcopy
CFLAGS   := -m32 -nostdinc -nostdlib -fno-stack-protector -fPIC -Wall -Wextra -std=c99
LDFLAGS  := -melf_i386 -T linker.ld
ASFLAGS  := -f elf
BUILDDIR := build

# ***************************************************************
# الملفات
# ***************************************************************
C_SRCS  := boot-driver/command-cfz.c \
           boot-driver/zrbl_util.c \
           boot-driver/fat.c \
           boot-driver/ext4.c

ASM_SRCS := boot-driver/boot.asm

OBJS := $(patsubst %.c,$(BUILDDIR)/%.o,$(C_SRCS)) \
        $(patsubst %.asm,$(BUILDDIR)/%.o,$(ASM_SRCS))

TARGET := $(BUILDDIR)/zrbl.elf
FINAL_IMG := $(BUILDDIR)/boot.img

# ***************************************************************
# القواعد
# ***************************************************************

.PHONY: all clean

all: $(FINAL_IMG)

# قاعدة لتجميع ملفات C
$(BUILDDIR)/%.o: %.c | $(BUILDDIR)
	$(CC) $(CFLAGS) -c $< -o $@

# قاعدة لتجميع ملفات Assembly (حل خطأ CV0001)
$(BUILDDIR)/boot.o: boot-driver/boot.asm | $(BUILDDIR)
	$(AS) $(ASFLAGS) $< -o $@

# قاعدة الربط النهائية لإنشاء ملف ELF
$(TARGET): $(OBJS) linker.ld
	$(LD) $(LDFLAGS) -o $@ $(OBJS)

# قاعدة التحويل إلى صورة ثنائية خام (RAW Binary)
$(FINAL_IMG): $(TARGET)
	$(OBJCOPY) -O binary $< $@

# قاعدة إنشاء مجلد البناء
$(BUILDDIR):
	mkdir -p $(BUILDDIR)

clean:
	rm -rf $(BUILDDIR)
EOF

echo "INFO: تم إعداد جميع الملفات بنجاح. يمكنك الآن استخدام make للبناء."
echo "INFO: نفذ الأمر: make all"

