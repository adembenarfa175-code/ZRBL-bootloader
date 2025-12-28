# ZRBL Bootloader (Zahra Boot Loader) - Secure, Multi-Arch, and Hardened

![GitHub Status](https://img.shields.io/badge/Status-Actively%20Developed-brightgreen)
![License](https://img.shields.io/badge/License-GPL%20v3.0-blue)
![Architecture](https://img.shields.io/badge/Arch-i386%20%7C%20amd64%20%7C%20arm64-orange)
![Latest Version](https://img.shields.io/badge/Version-2025.6.8--mobile-red)

ZRBL is a modern, high-performance bootloader designed for **Memory Hardening** and **Security Minimization**. Moving beyond legacy complexity, ZRBL provides a unified booting experience across PC (x86) and Mobile (ARM64) platforms.

---

## I. Supported Architectures & Platforms

| Architecture | Platform | Mode | Status |
| :--- | :--- | :--- | :--- |
| **i386** | Legacy PC | 32-bit Protected Mode | Stable |
| **amd64** | Modern PC | 64-bit Long Mode | Stable (LTS) |
| **arm64** | Mobile / SBC | AArch64 (Exception Levels) | **Active (v2025.6.8)** |

---

## II. Key Architectural Features (Focus on Hardening)

### 1. Hardened File System Access (FAT)
* **Boundaries Validation:** Every file read strictly validates buffer sizes to prevent **Out-of-Bounds (OOB)** corruption.
* **Integrity Checks:** Cluster traversal is monitored to prevent disk-based attacks.

### 2. Multi-Arch Boot Engine
* **PC Boot:** Securely transitions from Real Mode to Long Mode with verified GDT/IDT.
* **Mobile Boot:** Optimized for ARM64 Exception Levels and Direct UART communication.

### 3. Secure Core Utilities
* **Hardened Mem-Ops:** Custom implementations of `zrbl_strncpy` and `zrbl_memset` with mandatory boundary checking.
* **Anti-Bomb Logic:** Prevents decompression resource exhaustion during kernel loading.

---

## III. Build and Installation

### Requirements
You must install the cross-compiler for your target architecture:

```bash
# For x86/amd64
apt install binutils-i686-elf nasm

# For ARM64 (Mobile)
apt install binutils-aarch64-linux-gnu gcc-aarch64-linux-gnu

