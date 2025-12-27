#include "zrbl_common.h"
int fat_read_sector(uint32_t l, void* b) { (void)l; (void)b; return 0; }
int fat_init(uint8_t d, uint32_t p) { (void)d; (void)p; return 1; }
FAT_DirEntry* fat_find_file(const char* f) { (void)f; return (FAT_DirEntry*)0; }
