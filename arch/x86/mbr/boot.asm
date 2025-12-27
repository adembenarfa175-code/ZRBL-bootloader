[bits 16]
[org 0x7c00]
jmp short start
nop
db "ZRBL6.3 " ; OEM ID
start:
    cli
    xor ax, ax
    mov ds, ax
    mov ss, ax
    mov sp, 0x7c00
    sti
    mov si, stage2_msg
    call print
    jmp 0x0800:0000
print: lodsb | or al, al | jz .d | mov ah, 0x0e | int 0x10 | jmp print
.d: ret
stage2_msg db "ZRBL v2025.6.3 x86 MBR OK", 0
times 510-($-$$) db 0
dw 0xaa55
