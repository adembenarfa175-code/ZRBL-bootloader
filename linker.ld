/* linker.ld - ZRBL Linker Script */

ENTRY(zrbl_main)

SECTIONS
{
    /* The base address where ZRBL will be loaded in memory */
    . = 0x10000; 

    /* .text section (Executable code) */
    .text :
    {
        *(.text)
    }

    /* .data section (Writable data) */
    .data :
    {
        *(.data)
    }

    /* .rodata section (Read-only data) */
    .rodata :
    {
        *(.rodata)
    }

    /* .bss section (Uninitialized data - must be zeroed) */
    .bss :
    {
        *(.bss)
        . = ALIGN(4); 
    }

    /* Discard unwanted sections */
    /DISCARD/ :
    {
        *(.fini)
        *(.eh_frame)
    }
}
