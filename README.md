# ZRBL Bootloader - Version 2025.3.1.0 (Secure Memory Foundation)

ZRBL (Zahra Boot Loader) is an ambitious open-source project designed to provide a secure, minimal, and dual-mode (UEFI/BIOS) boot solution. Our primary focus is on **Memory Hardening** to prevent critical vulnerabilities in the early boot stage.

---

## 🚀 Quick Start: Building the Bootloader

To make building and contributing easier for enthusiasts and Linux educators, you only need the main build script and standard cross-compilation tools.

**Prerequisites:** You need an i686-elf cross-compiler toolchain installed on your Linux environment.

### Option 1: Minimal Build (For rapid testing/YouTube tutorials)

If you only need the build script to compile the current source code, use this command to fetch only the essential file:

```bash
# Downloads the build script directly from the main branch
curl -o build_release.sh [https://raw.githubusercontent.com/adembenarfa175-code/ZRBL-bootloader/main/build_release.sh](https://raw.githubusercontent.com/adembenarfa175-code/ZRBL-bootloader/main/build_release.sh)
# Make it executable
chmod +x build_release.sh
# Run the script to generate the final binary (build/zrbl_bootloader.bin)
./build_release.sh

