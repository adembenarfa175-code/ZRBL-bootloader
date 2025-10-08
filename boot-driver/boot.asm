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
