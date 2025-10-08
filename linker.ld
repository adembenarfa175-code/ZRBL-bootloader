/* linker.ld - Linker script for the ZRBL Bootloader */

ENTRY(_start)
OUTPUT_FORMAT(elf32-i386)

SECTIONS {
    . = 0x7E00; /* Start address after the VBR (Volume Boot Record) */

    .text : {
        *(.text)
    }

    .data : {
        *(.data)
    }

    .rodata : {
        *(.rodata)
    }

    .bss : {
        *(.bss)
    }

    /DISCARD/ : {
        *(.eh_frame)
        *(.note.GNU-stack)
    }
}
