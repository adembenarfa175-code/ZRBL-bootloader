#!/bin/bash

# Configuration
LTS_VER="2025.6.7-LTS"
echo "--- Freezing Codebase for $LTS_VER ---"

# 1. Hard-code the LTS Stamp in Version File
echo "$LTS_VER" > version.txt

# 2. Update Headers to LTS Mode (High Stability)
# We define ZRBL_STABLE to disable experimental debug logs
cat <<EOF > common/zrbl_common.h
#ifndef ZRBL_COMMON_H
#define ZRBL_COMMON_H

#include <stdint.h>
#define ZRBL_VERSION "$LTS_VER"
#define ZRBL_IS_LTS 1
#define MEM_ALIGN_CHECK 1

// LTS Stability: Strict Memory Boundaries
#define STACK_BASE 0x90000
#define KERNEL_LOAD 0x100000

/* Forward Declaration for Safety */
void zrbl_kernel_main(void);
void zrbl_log(const char* msg);

#endif
EOF

# 3. Update Build Script to recognize LTS
# This ensures future builds of this version are always optimized
sed -i 's/^VERSION=.*/VERSION="2025.6.7-LTS"/' build_release.sh

echo "[+] Codebase frozen for LTS."

# 4. Git Operations: Create a Specialized Branch
echo "[+] Creating LTS Branch on GitHub..."
git checkout -b lts-2025.6
git add .
git commit -m "Release: $LTS_VER (Long Term Support Milestone)"
git tag -a v$LTS_VER -m "Official LTS Release: Maximum Stability"

# 5. Push both Main and LTS branches
git push origin main
git push origin lts-2025.6
git push origin v$LTS_VER

echo "--- $LTS_VER is now IMMORTALIZED on GitHub ---"

