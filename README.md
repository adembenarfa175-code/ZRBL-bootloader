# ZRBL Bootloader (Zahra Boot Loader) - Secure, Minimal, and Hardened

![GitHub Status](https://img.shields.io/badge/Status-Actively%20Developed-brightgreen)
![License](https://img.shields.io/badge/License-GPL%20v3.0-blue)
![Architecture](https://img.shields.io/badge/Architecture-i686%2F%20x86__64-yellow)
![Latest Stable Version](https://img.shields.io/badge/Version-2025.3.3.2-red)

ZRBL is an ambitious, modern bootloader project designed from the ground up to prioritize **Memory Hardening** and **Security Minimization** over complexity. Unlike legacy bootloaders (like GRUB) which prioritize maximum flexibility, ZRBL focuses on securely loading a Linux kernel and ensuring the lowest possible attack surface during the critical pre-kernel boot phase.

**License:** This project is released under the **GNU General Public License v3.0 (GPLv3)**.

---

## II. Key Architectural Features (Focus on Hardening)

ZRBL's core strength lies in its compartmentalized structure and strict security protocols built directly into low-level C functions.

### 1. Hardened File System Access (FAT)
| Component | Security Feature | Purpose |
| :--- | :--- | :--- |
| **`boot-driver/fat.c`** | **CRITICAL Bounds Checking** | Every file read (`fat_read_file_to_memory`) strictly validates the file size against the allocated memory buffer size to prevent **Out-of-Bounds (OOB) memory corruption** during kernel loading. |
| **`fat_get_next_cluster`** | **FAT Integrity Check** | Verifies that the next cluster address is always within the known, safe limits of the file system partition (`g_clusters_count`), preventing malicious loop-backs or disk traversal attacks. |

### 2. Input Validation and Configuration Parsing
| Component | Security Feature | Purpose |
| :--- | :--- | :--- |
| **`boot-driver/cfz_parser.c`** | **Strict Input Validation** | Safely parses the primary configuration file (`boot.cfz`) using secure string functions (`zrbl_strncpy`), preventing **Buffer Overflow** attacks via excessively long kernel paths or boot parameters. |

### 3. Core Memory Safety Utilities
| Component | Security Feature | Purpose |
| :--- | :--- | :--- |
| **`boot-driver/zrbl_util.c`** | **Secure String/Memory Ops** | Provides hardened replacements for standard C functions (`zrbl_strncpy`, `zrbl_memset`) that include mandatory boundary checking, eliminating common vulnerability vectors found in standard library calls in a freestanding environment. |
| **`boot-driver/decompress.c`** | **Decompression Bomb Prevention** | Includes critical checks to limit the final decompressed size of the Linux kernel, mitigating resource exhaustion or **Decompression Bomb** attacks from malicious kernel images. |

---

## III. Versioning and Roadmap (202X)

ZRBL follows a strict Four-Segment Versioning Scheme (`202X.Major.Minor.Patch`), with **five major releases** (Major) planned per year to ensure continuous security and feature growth.

| Major Release | Timeframe (Approx.) | Primary Focus Area |
| :---: | :--- | :--- |
| **202X.1.0.0** | Jan - Feb | BIOS Foundations & Lower Memory Hardening. |
| **202X.2.0.0** | Mar - Apr | Core File System Hardening & Data Integrity. |
| **202X.3.0.0** | May - Jun | Kernel Loading, Decompression, and Boot Parameter Hardening. |
| **202X.4.0.0** | Jul - Aug | UEFI & Secure Boot Integration. |
| **202X.5.0.0** | Sep - Oct | Advanced Security Features (RAM Zeroing, SIMD Optimization). |

### Development Branches
* **`main`**: The primary branch, reserved for the latest stable, security-hardened release (e.g., `2025.3.3.0`).
* **`release/202X.M.x-distribution`**: Dedicated branches for distribution-specific compatibility work (e.g., `release/2025.4.x-debian13`).

---

## IV. Build and Installation

### Requirements
* **Cross-Compiler:** `i686-elf-gcc` (Mandatory for freestanding bootloader development)
* **Assembler:** `nasm`

### Building the Project
Use the automated build script to create the final binary:
```bash
sh build_release.sh

