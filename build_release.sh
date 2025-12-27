#!/bin/bash
VERSION="2025.6.7-LTS"
OUT_DIR="build"
DISK_IMG="$OUT_DIR/zrbl_disk.img"
TOOLCHAIN_BIN="$HOME/../usr/tdt-toolchain/x86_64-linux-gnu/bin"
CC="$TOOLCHAIN_BIN/x86_64-linux-gnu-clang"
LD="$TOOLCHAIN_BIN/x86_64-linux-gnu-ld"

echo "--- Building ZRBL v$VERSION (C Syntax Fix) ---"
mkdir -p $OUT_DIR

nasm -f bin arch/x86/mbr/boot.asm -o $OUT_DIR/zrbl1-boot.bin
$CC -target i386-pc-linux-gnu -m32 -ffreestanding -fno-stack-protector -c kernel/zrbl_kernel.c -o $OUT_DIR/zrbl_main.o
$CC -target i386-pc-linux-gnu -m32 -ffreestanding -fno-stack-protector -c common/zrbl_util.c -o $OUT_DIR/zrbl_util.o

$LD -m elf_i386 -T linker.ld $OUT_DIR/zrbl_main.o $OUT_DIR/zrbl_util.o -o $OUT_DIR/zrbl_core.elf

dd if=/dev/zero of=$DISK_IMG bs=512 count=2880 status=none
dd if=$OUT_DIR/zrbl1-boot.bin of=$DISK_IMG conv=notrunc status=none

git add .
git commit -m "Fix v$VERSION: Resolved implicit function declaration"
git tag -a v$VERSION -m "Stable Build v$VERSION"
git push origin main
git push origin v$VERSION
