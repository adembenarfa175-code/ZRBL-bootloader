// boot-driver/cfz_parser.c - Secure parser for the boot configuration file (boot.cfz)

#include "zrbl_common.h"

#define CFG_MAX_KEY_LEN 16

/**
 * Parses a single line of configuration in the format KEY=VALUE securely.
 */
int cfz_parse_line(const char* line, char* key, char* value) {
    size_t line_len = zrbl_strlen(line);
    size_t i = 0;
    size_t key_start = 0;
    size_t key_end = 0;
    size_t value_start = 0;

    // 1. Skip leading whitespace and comments
    while (line[i] == ' ' || line[i] == '\t') { i++; }
    if (line[i] == '#' || line[i] == '\0' || line[i] == '\n') {
        return -1; 
    }
    key_start = i;

    // 2. Find the '=' sign 
    while (line[i] != '=' && line[i] != '\0' && line[i] != '\n' && (i - key_start) < CFG_MAX_KEY_LEN) {
        i++;
    }
    key_end = i;

    // 3. SECURITY CHECK 1: Format and Key Length
    if (line[i] != '=' || key_end == key_start || (key_end - key_start) >= CFG_MAX_KEY_LEN) {
        zrbl_puts("CFG ERROR: Invalid format or key too long.\n");
        return -1; 
    }

    // 4. Extract Key Securely
    zrbl_strncpy(key, &line[key_start], key_end - key_start);
    key[key_end - key_start] = '\0'; 

    // 5. Find the start of the Value
    value_start = ++i; 

    // 6. Extract Value Securely 
    size_t value_len = line_len - value_start;
    
    // CRITICAL: Prevent value overflow
    if (value_len >= CFG_MAX_VALUE_LEN) {
        zrbl_puts("CFG ERROR: Value too long. Aborting.\n");
        return -1; 
    }
    
    // Copy the value using the secure function
    zrbl_strncpy(value, &line[value_start], value_len);
    
    // 7. Remove trailing newline/whitespace
    i = value_len;
    while (i > 0 && (value[i-1] == '\n' || value[i-1] == ' ' || value[i-1] == '\t')) {
        value[i-1] = '\0';
        i--;
    }

    return 0; 
}
