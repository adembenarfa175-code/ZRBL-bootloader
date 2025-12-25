.section .text
.global _start
_start:
    ldr sp, =0x80000  @ Set stack pointer
    bl zrbl_main      @ Branch to C code
halt:
    wfi               @ Wait for interrupt
    b halt
