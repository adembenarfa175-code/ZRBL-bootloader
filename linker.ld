ENTRY(_start)
SECTIONS
{
    . = 0x100000; /* Start at 1MB */
    .text : { *(.text) }
    .data : { *(.data) }
    .bss  : { *(.bss)  }
}
