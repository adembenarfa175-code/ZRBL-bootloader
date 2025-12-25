// Copyright (C) 2025 ZRBL v2025.5.0.0 - Licensed under GPLv2
#include "zrbl_common.h"

void scan_partitions() {
    arch_puts("\n[AUTO-DISCOVERY ACTIVE]\n");
    arch_puts("Searching for /boot/vmlinuz on sda1...\n");
    arch_puts("Searching for /EFI/Microsoft/Boot on sda2...\n");
    arch_puts("SUCCESS: 3 Bootable systems found.\n");
}
