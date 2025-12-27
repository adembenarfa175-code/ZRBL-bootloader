[bits 16]
[org 0x7c00]

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti

    mov si, stage2_msg
    call print_string

    ; Jump to Stage 2
    jmp 0x0800:0x0000

print_string:
    lodsb
    test al, al
    jz .done
    mov ah, 0x0e
    int 0x10
    jmp print_string
.done:
    ret

stage2_msg db "ZRBL v2025.6.5 Booting...", 0

times 510-($-$$) db 0
dw 0xaa55
