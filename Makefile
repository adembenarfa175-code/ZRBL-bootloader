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
C_SRCS  := boot-driver/command-cfz.c            boot-driver/zrbl_util.c            boot-driver/fat.c            boot-driver/ext4.c

ASM_SRCS := boot-driver/boot.asm

OBJS :=          

TARGET := /zrbl.elf
FINAL_IMG := /boot.img

# ***************************************************************
# Rules
# ***************************************************************

.PHONY: all clean

all: 

# C compilation rule
/%.o: %.c | 
	  -c $< -o 

# Assembly compilation rule (for boot.asm)
/boot.o: boot-driver/boot.asm | 
	  $< -o 

# Final linking rule
:  linker.ld
	  -o  

# Rule to convert ELF to RAW Binary (boot image)
: 
	 -O binary $< 

# Rule to create the build directory
:
	mkdir -p 

clean:
	rm -rf 
