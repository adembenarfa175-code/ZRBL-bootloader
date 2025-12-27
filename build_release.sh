#!/bin/bash
# ZRBL v2025.6.0.0 - Stable Release Build
# Last Update: 2025-12-26

set -e

COMPILER="x86_64-linux-gnu-clang"
ASSEMBLER="nasm"
LINKER="x86_64-linux-gnu-ld"
OBJCOPY="x86_64-linux-gnu-objcopy"
CFLAGS="-std=c99 -m32 -Wall -Wextra -Werror -fno-stack-protector -nostdlib -ffreestanding -O2"
LDFLAGS="-m elf_i386 -T linker.ld"

mkdir -p build/boot-driver
mkdir -p common
mkdir -p arch/x86/mbr

# 1. Header Synchronization
cat <<EOF > boot-driver/zrbl_common.h
#ifndef ZRBL_COMMON_H
#define ZRBL_COMMON_H
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long long uint64_t;
typedef uint32_t size_t;
size_t zrbl_strlen(const char* s);
void* zrbl_memset(void* s, int c, size_t n);
void zrbl_puts(const char* s);
void zrbl_secure_clear_memory(void* s, size_t z);
void zrbl_main(void);
#endif
EOF

cp boot-driver/zrbl_common.h common/zrbl_common.h

# 2. C Core Logic (VGA & Memory Safety)
cat <<EOF > boot-driver/zrbl_util.c
#include "zrbl_common.h"
size_t zrbl_strlen(const char* s) { size_t l=0; while(s[l]) l++; return l; }
void* zrbl_memset(void* s, int c, size_t n) {
    unsigned char* p=(unsigned char*)s; while(n--) *p++=(unsigned char)c; return s;
}
void zrbl_puts(const char* s) {
    unsigned short* vga = (unsigned short*)0xB8000;
    static int pos = 0;
    for (int i = 0; s[i] != '\0'; i++) {
        vga[pos++] = (unsigned short)s[i] | (0x0F << 8);
    }
}
void zrbl_secure_clear_memory(void* s, size_t z) {
    if(s==0 || z==0) return;
    zrbl_memset(s, 0, z);
    zrbl_puts("[MEM_CLEARED] ");
}
EOF

cat <<EOF > common/zrbl_main.c
#include "zrbl_common.h"
void zrbl_main(void) {
    zrbl_puts("ZRBL_V2025.6_LOADED_SUCCESSFULLY ");
    zrbl_secure_clear_memory((void*)0x100000, 0x1000);
    while(1);
}
EOF

# 3. Assembly Stages (Stage 1 & Stage 2)
cat <<EOF > arch/x86/mbr/boot.asm
[bits 16]
[org 0x7c00]
_start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    mov [boot_drive], dl
    mov bx, 0x8000
    mov ah, 0x02
    mov al, 20
    mov ch, 0x00
    mov dh, 0x00
    mov cl, 0x02
    mov dl, [boot_drive]
    int 0x13
    jc error
    jmp 0x0000:0x8000
error:
    hlt
    jmp error
boot_drive: db 0
times 510-(\$-\$\$) db 0
dw 0xaa55
EOF

cat <<EOF > arch/x86/mbr/boot2.asm
[bits 16]
section .text
extern zrbl_main
global _start
_start:
    call zrbl_main
    hlt
EOF

# 4. Linker Configuration
cat <<EOF > linker.ld
ENTRY(_start)
SECTIONS
{
    . = 0x8000;
    .text : { *(.text) }
    .data : { *(.data) }
    .bss  : { *(.bss)  }
}
EOF

# 5. Build Execution
rm -rf build && mkdir -p build/boot-driver
$ASSEMBLER -f bin arch/x86/mbr/boot.asm -o build/zrbl1-boot.bin
$ASSEMBLER -f elf32 arch/x86/mbr/boot2.asm -o build/boot2.o
$COMPILER $CFLAGS -c boot-driver/zrbl_util.c -o build/boot-driver/zrbl_util.o
$COMPILER $CFLAGS -c common/zrbl_main.c -o build/zrbl_main.o
$LINKER $LDFLAGS -o build/zrbl_core.elf build/boot2.o build/zrbl_main.o build/boot-driver/*.o
$OBJCOPY -O binary build/zrbl_core.elf build/zrbl2-core-boot23.bin

# 6. Disk Image Creation
dd if=/dev/zero of=build/zrbl_disk.img bs=512 count=2880 status=none
dd if=build/zrbl1-boot.bin of=build/zrbl_disk.img conv=notrunc status=none
dd if=build/zrbl2-core-boot23.bin of=build/zrbl_disk.img seek=1 conv=notrunc status=none

echo "------------------------------------------------"
echo "ZRBL BUILD SUCCESSFUL - VERSION 2025.6.0.0"
echo "READY FOR TESTING ON 2025/12/27"
echo "------------------------------------------------"

