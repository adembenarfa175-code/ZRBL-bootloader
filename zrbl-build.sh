#!/bin/zsh
# ZRBL 2026.1.0.0 - Professional Build Script

echo "\033[1;34m[*] Building ZRBL Core with Clang...\033[0m"
mkdir -p build

# بناء النواة باستخدام المترجم الذي حددته يا Professional
# لنسخة x86_64
x86_64-linux-gnu-clang -ffreestanding -nostdlib -O2 -c arch/x86/efi/main_efi.c -o build/main_x64.o

echo "\033[1;35m[*] Compiling GTK4/Libadwaita Installer...\033[0m"
# بناء المثبت باستخدام clang العادي المتوفر في Termux/Linker64
clang installation/main.c $(pkg-config --cflags --libs gtk4 libadwaita-1) -o build/zrbl-installer

if [ $? -eq 0 ]; then
    echo "\033[1;32m[+] Installer built successfully: build/zrbl-installer\033[0m"
else
    echo "\033[1;31m[!] Build failed. Check the errors above.\033[0m"
fi
