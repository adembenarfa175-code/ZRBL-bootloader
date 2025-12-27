[bits 16]
[org 0x8000]
extern zrbl_main
entry:
    call zrbl_main
    hlt
