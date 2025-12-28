ENTRY(_start)
SECTIONS
{
    . = 0x40000000;      /* Standard RAM entry for ARM Virt/Mobile */
    .text : {
        *(.text)         /* Core instructions */
    }
    .rodata : {
        *(.rodata)       /* Read-only data (strings) */
    }
    .data : {
        *(.data)         /* Global variables */
    }
    .bss : {
        __bss_start = .;
        *(.bss)          /* Uninitialized data */
        __bss_end = .;
    }
    . = ALIGN(8);
    stack_top = . + 0x10000; /* 64KB Stack */
}
