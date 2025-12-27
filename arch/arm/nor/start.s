.section .text
.global _start
_start:
    ldr sp, =0x40000000
    bl main_loop
halt: b halt
