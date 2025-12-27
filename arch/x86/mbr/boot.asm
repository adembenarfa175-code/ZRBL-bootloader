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
fill: times 510-($-$$) db 0
dw 0xaa55
