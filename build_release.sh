#!/bin/bash
VERSION="2025.6.5"
OUT_DIR="build"
DISK_IMG="$OUT_DIR/zrbl_disk.img"

echo "--- Building ZRBL v$VERSION ---"
mkdir -p $OUT_DIR

# Compile Assembly
nasm -f bin arch/x86/mbr/boot.asm -o $OUT_DIR/zrbl1-boot.bin

# Compile C (Adding flags to ignore host arch mismatch)
gcc -m32 -ffreestanding -fno-stack-protector -c kernel/zrbl_kernel.c -o $OUT_DIR/zrbl_main.o
gcc -m32 -ffreestanding -fno-stack-protector -c common/zrbl_util.c -o $OUT_DIR/zrbl_util.o

# Linking
ld -m elf_i386 -T linker.ld $OUT_DIR/zrbl_main.o $OUT_DIR/zrbl_util.o -o $OUT_DIR/zrbl_core.elf

# Disk Image Creation
dd if=/dev/zero of=$DISK_IMG bs=512 count=2880 status=none
dd if=$OUT_DIR/zrbl1-boot.bin of=$DISK_IMG conv=notrunc status=none

# GitHub Update
git add .
git commit -m "Fix v$VERSION: Register mismatch and build stability"
git tag -a v$VERSION -m "Stable Build v$VERSION"
git push origin main
git push origin v$VERSION
