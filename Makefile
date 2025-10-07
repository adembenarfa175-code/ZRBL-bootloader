# ----------------------------------------------------------------------
# Makefile لـ ZRBL Bootloader - لإنشاء ملف /boot/zrbl/boot.img
# ----------------------------------------------------------------------

# المجلدات والمخرجات
SRCDIR := boot-driver
BUILDDIR := build
BINDIR := /boot/zrbl

# الأسماء النهائية للملفات
STAGE1_ASM := $(SRCDIR)/boot.asm
STAGE2_C := $(SRCDIR)/command-cfz.c
FAT_C := $(SRCDIR)/fat.c
EXT4_C := $(SRCDIR)/ext4.c

# الصورة النهائية للمرحلة الثانية
FINAL_IMG := $(BINDIR)/boot.img

# ملفات الكائن (Object Files)
OBJS := $(BUILDDIR)/boot.o $(BUILDDIR)/command-cfz.o $(BUILDDIR)/fat.o $(BUILDDIR)/ext4.o

# مُصرّف C (يجب أن يكون مُصرّفاً متبادلاً لـ i386-elf إذا كنت لا تعمل على Linux)
CC := gcc
AS := nasm
LD := ld

# أعلام التجميع المتبادل (Crucial for a freestanding environment)
CFLAGS := -m32 -ffreestanding -nostdlib -Wall -Wextra -g

# -----------------
# الأهداف الرئيسية
# -----------------

.PHONY: all clean install

all: $(FINAL_IMG)

# الهدف لتثبيت ملف الإقلاع (يجب أن يتم تنفيذه بصلاحيات Root)
install: $(FINAL_IMG)
	@mkdir -p $(BINDIR)
	@cp $(FINAL_IMG) $(BINDIR)/
	@echo "ZRBL boot.img copied to $(BINDIR)/"
	@echo "NOTE: You still need to configure GRUB to chainload this image."

# هدف الصورة النهائية (boot.img)
$(FINAL_IMG): $(OBJS)
	@mkdir -p $(BUILDDIR)
	@echo "Linking ZRBL Stage 2 image..."
	# يتم هنا ربط جميع الملفات الكائنية في ملف ثنائي واحد قابل للتحميل
	$(LD) -m elf_i386 -T linker.ld -o $(FINAL_IMG) $^

# -----------------
# قواعد التجميع (Compilation Rules)
# -----------------

# تجميع ملفات C
$(BUILDDIR)/%.o: $(SRCDIR)/%.c
	@mkdir -p $(BUILDDIR)
	@echo "Compiling C: $<"
	$(CC) $(CFLAGS) -c $< -o $@

# تجميع ملف التجميع (Stage 1)
$(BUILDDIR)/boot.o: $(STAGE1_ASM)
	@mkdir -p $(BUILDDIR)
	@echo "Assembling Stage 1: $<"
	$(AS) -f elf $< -o $@

# -----------------
# التنظيف
# -----------------

clean:
	@echo "Cleaning up build and output directories..."
	@rm -rf $(BUILDDIR)
	@rm -f $(FINAL_IMG)

