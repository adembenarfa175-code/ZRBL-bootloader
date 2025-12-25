// Copyright (C) 2025 ZRBL v2025.5.0.0 - Licensed under GPLv2
#include "zrbl_common.h"

void zrbl_main() {
    arch_puts("ZRBL Graphic Engine Starting...\n");
    
    // Check for user input during countdown
    // If CTRL+i is pressed:
    // handle_iso_list();

    // Default: Load User Image
    init_graphics(0x13); // Start VGA 320x200 256 Colors
    draw_background(IMG_USER);

    arch_puts("\n[1] Debian  [2] Windows  [3] Android\n");
    
    while(1);
}
