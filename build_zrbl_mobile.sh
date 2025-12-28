#!/bin/bash

# --- Configuration ---
PROJECT_NAME="ZRBL-Mobile"
VERSION="2025.6.8"
ARCH="aarch64-linux-gnu"
OUT_DIR="build_out"
LINKER_FILE="linker_mobile.ld"

# Create Output Directory
mkdir -p $OUT_DIR

echo "--- Starting Build for $PROJECT_NAME v$VERSION ---"

# 1. Create the Linker Script (Dynamic Generation)
cat <<EOF > $LINKER_FILE
ENTRY(_start)
SECTIONS
{
    . = 0x40000000;      /* Standard RAM entry for ARM Virt/Mobile */
    .text : {
        *(.text)         /* Core instructions */
    }
    .rodata : {
        *(.rodata)       /* Read-only data (strings) */
    }
    .data : {
        *(.data)         /* Global variables */
    }
    .bss : {
        __bss_start = .;
        *(.bss)          /* Uninitialized data */
        __bss_end = .;
    }
    . = ALIGN(8);
    stack_top = . + 0x10000; /* 64KB Stack */
}
EOF

echo "[1/4] Linker script generated."

# 2. Assemble Bootloader (AArch64)
$ARCH-as arch/arm/boot.S -o $OUT_DIR/boot.o
echo "[2/4] Assembly code compiled."

# 3. Compile Kernel (AArch64 C Code)
$ARCH-gcc -ffreestanding -c kernel/zrbl_mobile.c -o $OUT_DIR/kernel.o -O2
echo "[3/4] C Kernel compiled."

# 4. Linking and Binary Extraction
$ARCH-ld -T $LINKER_FILE $OUT_DIR/boot.o $OUT_DIR/kernel.o -o $OUT_DIR/zrbl_core.elf
$ARCH-objcopy -O binary $OUT_DIR/zrbl_core.elf zrbl_mobile.img

echo "[4/4] Final Binary Created: zrbl_mobile.img"
echo "------------------------------------------"
echo "Build Successful! Ready for Deployment."

