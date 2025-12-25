// Copyright (C) 2025 ZRBL v2025.5.0.0 - Licensed under GPLv2
#ifndef ZRBL_COMMON_H
#define ZRBL_COMMON_H

#include <stddef.h>

typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;

/* Partition & ISO Constants */
#define MBR_TABLE_OFFSET 0x1BE
#define ISO_MAGIC "CD001"
#define CTRL_I_KEY 0x09

/* GUI Themes */
typedef enum { THEME_USER, THEME_DEV, THEME_KIDS } zrbl_theme_t;

void kernel_main();
void scan_partitions();
void load_gui(zrbl_theme_t theme);
void mount_iso_loopback(const char* iso_path);

#endif
