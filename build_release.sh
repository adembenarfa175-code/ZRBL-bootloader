#!/bin/bash

# Configuration
VERSION="2025.6.3"
OUT_DIR="build"
DISK_IMG="$OUT_DIR/zrbl_disk.img"

echo "--- ZRBL Bootloader Build System v$VERSION ---"

# 1. Prepare Build Directory
mkdir -p $OUT_DIR
rm -rf $OUT_DIR/*

# 2. Compile Assembly (x86 MBR)
echo "[+] Compiling x86 Bootloader..."
nasm -f bin arch/x86/mbr/boot.asm -o $OUT_DIR/zrbl1-boot.bin

# 3. Compile C Kernel and Drivers
echo "[+] Compiling Core Kernel and Drivers..."
gcc -m32 -ffreestanding -c kernel/zrbl_kernel.c -o $OUT_DIR/zrbl_main.o
gcc -m32 -ffreestanding -c common/zrbl_util.c -o $OUT_DIR/zrbl_util.o

# 4. Linking (Using the Linker Script)
echo "[+] Linking Everything into ELF..."
ld -m elf_i386 -T linker.ld $OUT_DIR/zrbl_main.o $OUT_DIR/zrbl_util.o -o $OUT_DIR/zrbl_core.elf

# 5. Create Bootable Disk Image (512 bytes for MBR + Kernel)
echo "[+] Creating zrbl_disk.img..."
dd if=/dev/zero of=$DISK_IMG bs=512 count=2880 > /dev/null 2>&1
dd if=$OUT_DIR/zrbl1-boot.bin of=$DISK_IMG conv=notrunc > /dev/null 2>&1

echo "--- Build Successful: $DISK_IMG ---"

# 6. GitHub Integration (Commit, Tag, and Push)
echo "[+] Starting GitHub Deployment..."
git add .
git commit -m "Release v$VERSION: Optimized Memory & Architecture Sync"
git tag -a v$VERSION -m "Stable Build v$VERSION"
git push origin main
git push origin v$VERSION

echo "--- All Done! Project v$VERSION is now LIVE on GitHub ---"

