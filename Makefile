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
C_SRCS  := boot-driver/command-cfz.c            boot-driver/zrbl_util.c            boot-driver/fat.c            boot-driver/ext4.c

ASM_SRCS := boot-driver/boot.asm

OBJS :=          

TARGET := /zrbl.elf
FINAL_IMG := /boot.img

# ***************************************************************
# القواعد
# ***************************************************************

.PHONY: all clean

all: 

# قاعدة لتجميع ملفات C
/%.o: %.c | 
	  -c $< -o 

# قاعدة لتجميع ملفات Assembly (حل خطأ CV0001)
/boot.o: boot-driver/boot.asm | 
	  $< -o 

# قاعدة الربط النهائية لإنشاء ملف ELF
:  linker.ld
	  -o  

# قاعدة التحويل إلى صورة ثنائية خام (RAW Binary)
: 
	 -O binary $< 

# قاعدة إنشاء مجلد البناء
:
	mkdir -p 

clean:
	rm -rf 
