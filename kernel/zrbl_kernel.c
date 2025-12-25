// Copyright (C) 2025 ZRBL v2025.5.0.0 - Licensed under GPLv2
#include "../common/zrbl_common.h"

void kernel_main() {
    arch_puts("ZRBL Micro-Kernel v2025.5.0.0 Initialized.\n");
    
    // Auto-detect systems
    scan_partitions();

    // Check for CTRL+i (Simplified logic)
    arch_puts("Press CTRL+i for ISO Menu (20s timeout)...\n");

    // Load Default Theme (User Mode)
    load_gui(THEME_USER);
}

void load_gui(zrbl_theme_t theme) {
    switch(theme) {
        case THEME_USER: arch_puts("Loading Theme: User [/boot/zrbl/img/user.bmp]\n"); break;
        case THEME_DEV:  arch_puts("Loading Theme: Dev  [/boot/zrbl/img/dev.bmp]\n"); break;
        case THEME_KIDS: arch_puts("Loading Theme: Kids [/boot/zrbl/img/kids.bmp]\n"); break;
    }
}
