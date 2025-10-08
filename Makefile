# Makefile for ZRBL Bootloader v2025.3.3.0

# Configuration
COMPILER = i686-elf-gcc
ASSEMBLER = nasm
LD = i686-elf-ld
CFLAGS = -std=c99 -Wall -Wextra -Werror -fno-stack-protector -nostdlib -ffreestanding -O2 -g
ASFLAGS = -f bin

# UPDATED: Added boot-driver/cfz_parser.c
C_FILES = boot-driver/command-cfz.c boot-driver/zrbl_util.c boot-driver/fat.c boot-driver/ext4.c boot-driver/cfz_parser.c
OBJ_FILES = $(patsubst %.c, build/%.o, $(C_FILES)) build/boot.o

TARGET = build/zrbl_bootloader.bin

all: $(TARGET)

build/%.o: %.c boot-driver/zrbl_common.h
	$(COMPILER) $(CFLAGS) -c $< -o $@

build/boot.o: boot.asm
	$(ASSEMBLER) $(ASFLAGS) $< -o $@

$(TARGET): $(OBJ_FILES) linker.ld
	$(LD) -n -T linker.ld -o build/zrbl_kernel.elf $(OBJ_FILES)
	objcopy -O binary build/zrbl_kernel.elf $(TARGET)

.PHONY: clean run

clean:
	rm -rf build/
	
run: all
	echo "Ready to run the binary: $(TARGET)"
	# qemu-system-i386 -fda $(TARGET)
