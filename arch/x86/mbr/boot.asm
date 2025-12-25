[bits 32]
extern zrbl_main
global _start
_start:
    call zrbl_main
    hlt
