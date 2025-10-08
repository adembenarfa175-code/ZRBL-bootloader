; boot.asm - The very first stage, sets up stack and calls zrbl_main()

[bits 32] ; We run in 32-bit protected mode

extern zrbl_main  ; Entry point in command-cfz.c

section .text
global _start

_start:
    ; Set up a minimal stack
    mov esp, 0x90000 ; Stack starts high in memory
    
    ; Setup global variables (simulating BIOS boot)
    ; mov [g_boot_mode], 0x0 ; BOOT_MODE_BIOS
    ; mov [g_active_drive], 0x80
    
    ; Call the main C function
    call zrbl_main
    
.halt:
    cli
    hlt

section .bss
; Global variable declarations (to be linked with C code)
global g_partition_start_lba
global g_active_drive
global g_boot_mode

g_partition_start_lba: resd 1
g_active_drive: resb 1
g_boot_mode: resb 1
