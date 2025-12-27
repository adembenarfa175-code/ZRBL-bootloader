#!/bin/bash
VERSION="2025.6.4"
OUT_DIR="build"
DISK_IMG="$OUT_DIR/zrbl_disk.img"
mkdir -p $OUT_DIR
rm -rf $OUT_DIR/*
nasm -f bin arch/x86/mbr/boot.asm -o $OUT_DIR/zrbl1-boot.bin
gcc -m32 -ffreestanding -c kernel/zrbl_kernel.c -o $OUT_DIR/zrbl_main.o
gcc -m32 -ffreestanding -c common/zrbl_util.c -o $OUT_DIR/zrbl_util.o
ld -m elf_i386 -T linker.ld $OUT_DIR/zrbl_main.o $OUT_DIR/zrbl_util.o -o $OUT_DIR/zrbl_core.elf
dd if=/dev/zero of=$DISK_IMG bs=512 count=2880 > /dev/null 2>&1
dd if=$OUT_DIR/zrbl1-boot.bin of=$DISK_IMG conv=notrunc > /dev/null 2>&1
git add .
git commit -m "Fix v$VERSION: Assembly syntax and stack alignment"
git tag -a v$VERSION -m "Stable Build v$VERSION"
git push origin main
git push origin v$VERSION
