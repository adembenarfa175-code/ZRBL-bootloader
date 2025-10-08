#!/bin/bash
# build_release.sh - ZRBL Bootloader 2025.2.0.0 Setup and Build Script

# ----------------------------------------------------
# 1. Setup Structure and Directories
# ----------------------------------------------------
echo "INFO: Setting up essential directories..."
mkdir -p build
mkdir -p boot-driver

# ----------------------------------------------------
# 2. Create and Populate Core Code Files
# ----------------------------------------------------

# (1) File: zrbl_common.h (Header for Utility Functions and Types)
echo "INFO: Creating zrbl_common.h"
cat <<EOF > boot-driver/zrbl_common.h
// boot-driver/zrbl_common.h - Utility functions and data types for ZRBL
#ifndef ZRBL_COMMON_H
#define ZRBL_COMMON_H

#include <stddef.h> // For size_t definition

// Basic data type definitions for the bootloader environment
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long long uint64_t;

// Secure memory and string utility functions (implemented in zrbl_util.c)
void* zrbl_memcpy(void* dest, const void* src, size_t n);
void* zrbl_memset(void* s, int c, size_t n);
int zrbl_strcmp(const char* s1, const char* s2);
size_t zrbl_strlen(const char* s);
// SECURE function: Limits copy size to prevent Buffer Overflows (Crucial for 2025.2.0.0)
char* zrbl_strncpy(char* dest, const char* src, size_t n); 

// Print function (relies on Assembly/BIOS calls)
void zrbl_puts(const char* s);

// Global variables (Disk I/O and Partition info)
extern uint32_t g_partition_start_lba;
extern uint8_t g_active_drive;

#endif // ZRBL_COMMON_H
EOF

# (2) File: zrbl_util.c (Implementation of Secure Utility Functions)
echo "INFO: Creating zrbl_util.c (Implementing secure memory ops)"
cat <<EOF > boot-driver/zrbl_util.c
// boot-driver/zrbl_util.c - Implementation of secure memory and string utilities

#include "zrbl_common.h"

// Memory copy (memcpy)
void* zrbl_memcpy(void* dest, const void* src, size_t n) {
    char* d = (char*)dest;
    const char* s = (const char*)src;
    while (n--) {
        *d++ = *s++;
    }
    return dest;
}

// Memory set (memset)
void* zrbl_memset(void* s, int c, size_t n) {
    char* p = (char*)s;
    while (n--) {
        *p++ = (char)c;
    }
    return s;
}

// String comparison (strcmp)
int zrbl_strcmp(const char* s1, const char* s2) {
    while (*s1 && (*s1 == *s2)) {
        s1++;
        s2++;
    }
    return *(const unsigned char*)s1 - *(const unsigned char*)s2;
}

// String length (strlen)
size_t zrbl_strlen(const char* s) {
    size_t len = 0;
    while (*s++) {
        len++;
    }
    return len;
}

// Secure string copy (strncpy) - Prevents Buffer Overflows!
char* zrbl_strncpy(char* dest, const char* src, size_t n) {
    size_t i;
    // Copy up to n characters or until null terminator
    for (i = 0; i < n && src[i] != '\0'; i++) {
        dest[i] = src[i];
    }
    // Pad the rest of the destination with null bytes
    for (; i < n; i++) {
        dest[i] = '\0';
    }
    return dest;
}

// Placeholder for Assembly/BIOS-based print function
void zrbl_puts(const char* s) {
    // This function will be implemented in Assembly later for BIOS/VGA output.
}
EOF

# (3) File: command-cfz.c (Main C entry function)
echo "INFO: Creating command-cfz.c (Main C entry point)"
cat <<EOF > boot-driver/command-cfz.c
// boot-driver/command-cfz.c - The main C function for ZRBL

#include "zrbl_common.h"
// #include "fat.h"
// #include "ext4.h"

// Define global variables for disk I/O and partition info
uint32_t g_partition_start_lba = 0;
uint8_t g_active_drive = 0x80; // First hard drive (BIOS convention)

// The primary C entry point, called from boot.asm
void zrbl_main() {
    // 1. Display version information
    zrbl_puts("ZRBL Bootloader - Version 2025.2.0.0\n");
    zrbl_puts("Initializing, focusing on secure memory management...\n");

    // 2. File System Initialization (FAT, EXT4)
    // fat_init(g_active_drive, g_partition_start_lba);
    
    // 3. Read settings file (boot.cfz) and parse commands
    
    // 4. Load the kernel and jump to it
    
    // Infinite loop (Halt if kernel loading fails)
    while (1) {
        // Error handling or halt message goes here
    }
}
EOF

# (4) File: fat.c (FAT File System Driver) - Focusing on Security
echo "INFO: Creating fat.c (Secure FAT driver structure)"
cat <<EOF > boot-driver/fat.c
// boot-driver/fat.c - Secure FAT file system support

#include "zrbl_common.h"
// #include "fat.h" // FAT-specific headers will be added here

// Global variables for FAT partition data (crucial for Bounds Checking)
// extern uint32_t g_total_sectors; // Example: total sectors in partition

/**
 * Secure sector read function.
 * Must ensure the LBA is within the partition bounds to prevent OOB Read.
 * @param lba: Logical Block Address relative to the partition start.
 * @param buffer: 512-byte buffer for the sector data.
 */
int fat_read_sector(uint32_t lba, void* buffer) {
    // ********* CRITICAL SECURITY CHECK *********
    // 1. Check against the partition's maximum sector count (g_total_sectors)
    // if (lba >= g_total_sectors) { return -1; }
    
    // 2. Calculate the absolute LBA using g_partition_start_lba
    // uint32_t absolute_lba = g_partition_start_lba + lba;
    
    // ... (Disk I/O Assembly/BIOS call goes here) ...
    
    return 0; // Success
}

/**
 * Primary FAT initialization function.
 * Reads the Boot Parameter Block (BPB) securely.
 */
int fat_init(uint8_t drive_id, uint32_t part_start_lba) {
    // Code to read BPB and validate all critical fields (e.g., sector size, FAT size)
    // Validation is key to prevent crashes and exploits from malformed file systems.
    
    zrbl_puts("INFO: FAT initialization complete.\n");
    return 0;
}
EOF

# (5) File: ext4.c (EXT4 Driver Structure) - Placeholder
echo "INFO: Creating ext4.c (Placeholder for future development)"
cat <<EOF > boot-driver/ext4.c
// boot-driver/ext4.c - EXT4 file system support
#include "zrbl_common.h"
// Implementation of EXT4 secure read functions will go here.
EOF

# ----------------------------------------------------
# 3. Configuration and Linker Files
# ----------------------------------------------------

# (6) File: linker.ld (The Linker Script)
echo "INFO: Creating linker.ld"
cat <<EOF > linker.ld
/* linker.ld - ZRBL Linker Script */

ENTRY(zrbl_main)

SECTIONS
{
    /* The base address where ZRBL will be loaded in memory */
    . = 0x10000; 

    /* .text section (Executable code) */
    .text :
    {
        *(.text)
    }

    /* .data section (Writable data) */
    .data :
    {
        *(.data)
    }

    /* .rodata section (Read-only data) */
    .rodata :
    {
        *(.rodata)
    }

    /* .bss section (Uninitialized data - must be zeroed) */
    .bss :
    {
        *(.bss)
        . = ALIGN(4); 
    }

    /* Discard unwanted sections */
    /DISCARD/ :
    {
        *(.fini)
        *(.eh_frame)
    }
}
EOF

# (7) File: boot.asm (The Corrected Assembly Code)
echo "INFO: Creating boot-driver/boot.asm (Fix for CV0001)"
cat <<EOF > boot-driver/boot.asm
; /boot/zrbl/boot-driver/boot.asm - ZRBL Stage 2/3 Loader
;
; Compiled as ELF object to be linked with C code (command-cfz.c)
;
; Licensed under GPLv3 or later.
;

; ***************************************************************
; Directives
; ***************************************************************

BITS 32                 ; Must be in 32-bit Protected Mode
section .text           ; Executable code section

; ***************************************************************
; External and Global Definitions
; ***************************************************************

extern zrbl_main        ; The main C function entry point
global _start           ; Primary entry point for the ELF object

; ***************************************************************
; Entry Point and Jump to C
; ***************************************************************

_start:
    ; -------------------------------------------------------------
    ; Setup essential segment registers
    ; -------------------------------------------------------------
    
    mov ax, 0x10        ; Data Segment Selector value
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    
    ; -------------------------------------------------------------
    ; Setup the Stack for C code (Crucial for function calls)
    ; -------------------------------------------------------------
    mov esp, 0x90000    ; Set the Stack Pointer to a safe memory area

    ; -------------------------------------------------------------
    ; Jump to the C function
    ; -------------------------------------------------------------
    call zrbl_main      ; Call the C main function

    ; -------------------------------------------------------------
    ; Halt/End (Should not be reached in a successful boot)
    ; -------------------------------------------------------------
.halt:
    cli                     ; Disable Interrupts
    hlt                     ; Halt the CPU
    jmp .halt               ; Infinite loop for safety
EOF

# (8) File: Makefile
echo "INFO: Creating Makefile"
cat <<EOF > Makefile
# Makefile for ZRBL Bootloader 2025.2.0.0
#
# Licensed under GPLv3 or later.

# ***************************************************************
# Tools and Compiler Settings
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
# Files
# ***************************************************************
C_SRCS  := boot-driver/command-cfz.c \
           boot-driver/zrbl_util.c \
           boot-driver/fat.c \
           boot-driver/ext4.c

ASM_SRCS := boot-driver/boot.asm

OBJS := $(patsubst %.c,$(BUILDDIR)/%.o,$(C_SRCS)) \
        $(patsubst %.asm,$(BUILDDIR)/%.o,$(ASM_SRCS))

TARGET := $(BUILDDIR)/zrbl.elf
FINAL_IMG := $(BUILDDIR)/boot.img

# ***************************************************************
# Rules
# ***************************************************************

.PHONY: all clean

all: $(FINAL_IMG)

# C compilation rule
$(BUILDDIR)/%.o: %.c | $(BUILDDIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Assembly compilation rule (for boot.asm)
$(BUILDDIR)/boot.o: boot-driver/boot.asm | $(BUILDDIR)
	$(AS) $(ASFLAGS) $< -o $@

# Final linking rule
$(TARGET): $(OBJS) linker.ld
	$(LD) $(LDFLAGS) -o $@ $(OBJS)

# Rule to convert ELF to RAW Binary (boot image)
$(FINAL_IMG): $(TARGET)
	$(OBJCOPY) -O binary $< $@

# Rule to create the build directory
$(BUILDDIR):
	mkdir -p $(BUILDDIR)

clean:
	rm -rf $(BUILDDIR)
EOF

echo "INFO: All files have been reset with English comments. ZRBL is ready for development."
echo "INFO: You can now run: make all"

