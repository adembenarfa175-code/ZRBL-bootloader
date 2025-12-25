# ZRBL v2025.5.0.0 Makefile
ARCH ?= x86
dir-install ?= .

CC = i686-elf-gcc
OBJCOPY = i686-elf-objcopy
CFLAGS = -std=c99 -Wall -ffreestanding -nostdlib -O2 -Icommon

# Component Source
SRCS = common/*.c kernel/*.c arch/$(ARCH)/mbr/*.c

all: clean build_all

build_all:
	@mkdir -p build
	nasm -f bin arch/x86/mbr/boot.asm -o build/zrbl1.bin
	$(CC) $(CFLAGS) $(SRCS) -o build/kernel.elf
	$(OBJCOPY) -O binary build/kernel.elf build/zrbl2.bin

install: build_all
	@if [ -z "$(dir-install)" ] || [ "$(dir-install)" = "." ]; then echo "Error: Set dir-install!"; exit 1; fi
	mkdir -p $(dir-install)/boot/zrbl/img
	cp build/zrbl1.bin build/zrbl2.bin $(dir-install)/boot/zrbl/
	cp -r img/* $(dir-install)/boot/zrbl/img/
	@echo "ZRBL v2025.5.0.0 Installed Successfully to $(dir-install)"

clean:
	rm -rf build/*
