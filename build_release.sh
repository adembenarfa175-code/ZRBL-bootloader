#!/bin/bash
VERSION="2025.6.5.1"
OUT_DIR="build"
DISK_IMG="$OUT_DIR/zrbl_disk.img"

# Paths to your specific x86_64 toolchain
TOOLCHAIN_BIN="$HOME/../usr/tdt-toolchain/x86_64-linux-gnu/bin"
CC="$TOOLCHAIN_BIN/x86_64-linux-gnu-clang"
LD="$TOOLCHAIN_BIN/x86_64-linux-gnu-ld"
OBJCOPY="$TOOLCHAIN_BIN/x86_64-linux-gnu-objcopy"

echo "--- Building ZRBL v$VERSION (Cross-Compiling for x86) ---"
mkdir -p $OUT_DIR

# 1. Compile Assembly (MBR)
nasm -f bin arch/x86/mbr/boot.asm -o $OUT_DIR/zrbl1-boot.bin

# 2. Compile C Files (Using Cross-Clang)
# We use -m32 because the bootloader starts in 32-bit mode
$CC -target i386-pc-linux-gnu -m32 -ffreestanding -fno-stack-protector -c kernel/zrbl_kernel.c -o $OUT_DIR/zrbl_main.o
$CC -target i386-pc-linux-gnu -m32 -ffreestanding -fno-stack-protector -c common/zrbl_util.c -o $OUT_DIR/zrbl_util.o

# 3. Linking (Using Cross-LD)
$LD -m elf_i386 -T linker.ld $OUT_DIR/zrbl_main.o $OUT_DIR/zrbl_util.o -o $OUT_DIR/zrbl_core.elf

# 4. Create Disk Image
dd if=/dev/zero of=$DISK_IMG bs=512 count=2880 status=none
dd if=$OUT_DIR/zrbl1-boot.bin of=$DISK_IMG conv=notrunc status=none

# 5. GitHub Update
git add .
git commit -m "Fix v$VERSION: Integrated x86_64-linux-gnu Toolchain"
git tag -a v$VERSION -m "Stable Build v$VERSION"
git push origin main
git push origin v$VERSION
