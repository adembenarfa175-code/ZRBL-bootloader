; boot.asm - The very first stage, sets up stack and calls zrbl_main()

[bits 32] 

extern zrbl_main  

section .text
global _start

_start:
    mov esp, 0x90000 
    
    call zrbl_main
    
.halt:
    cli
    hlt

section .bss
; Global variable declarations (must match C code)
global g_partition_start_lba
global g_active_drive
global g_boot_mode
global g_fat_start_lba
global g_data_start_lba
global g_clusters_count
global g_fat_type

g_partition_start_lba: resd 1
g_active_drive: resb 1
g_boot_mode: resb 1
g_fat_start_lba: resd 1
g_data_start_lba: resd 1
g_clusters_count: resd 1
g_fat_type: resb 1
