// Copyright (C) 2025 ZRBL v2025.5.0.0 - Licensed under GPLv2
#ifndef ZRBL_VHD_H
#define ZRBL_VHD_H

#include "zrbl_common.h"

typedef struct __attribute__((packed)) {
    char cookie[8];       // Must be "conectix"
    uint32_t features;
    uint32_t version;
    uint64_t next_offset;
    uint32_t timestamp;
    uint32_t creator_app;
    uint32_t creator_ver;
    uint32_t creator_os;
    uint64_t current_size;
    uint64_t max_size;
    // ... other fields
} VHD_Footer;

int mount_vhd(const char* path);
void read_vhd_sector(uint64_t lba, void* buffer);

#endif
