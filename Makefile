# Makefile for ZRBL Bootloader v2025.3.1.0

# Configuration from build_release.sh
COMPILER = i686-elf-gcc
ASSEMBLER = nasm
LD = i686-elf-ld
CFLAGS = -std=c99 -Wall -Wextra -Werror -fno-stack-protector -nostdlib -ffreestanding -O2
ASFLAGS = -f bin

C_FILES = boot-driver/command-cfz.c boot-driver/zrbl_util.c boot-driver/fat.c boot-driver/ext4.c
OBJ_FILES = $(patsubst %.c, build/%.o, $(C_FILES)) build/boot.o

TARGET = build/zrbl_bootloader.bin

all: $(TARGET)

# Rule for C compilation
build/%.o: %.c boot-driver/zrbl_common.h
	$(COMPILER) $(CFLAGS) -c $< -o $@

# Rule for Assembly compilation
build/boot.o: boot.asm
	$(ASSEMBLER) $(ASFLAGS) $< -o $@

# Rule for Linking
$(TARGET): $(OBJ_FILES) linker.ld
	$(LD) -n -T linker.ld -o build/zrbl_kernel.elf $(OBJ_FILES)
	# Extract the raw binary from the ELF file
	objcopy -O binary build/zrbl_kernel.elf $(TARGET)

.PHONY: clean run

clean:
	rm -rf build/
	
run: all
	# Placeholder for QEMU/VM execution command
	echo "Ready to run the binary: $(TARGET)"
	# qemu-system-i386 -fda $(TARGET)
