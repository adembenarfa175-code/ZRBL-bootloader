[bits 16]
section .text
extern zrbl_main
global _start
_start:
    call zrbl_main
    hlt
