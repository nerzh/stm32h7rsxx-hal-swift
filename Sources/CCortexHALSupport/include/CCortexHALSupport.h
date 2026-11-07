/* Copyright (c) 2009-2025 Arm Limited. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 * Instruction wrappers adapted from CMSIS_6 cmsis_gcc.h at
 * 3c860f7a5810a34205bdbadb84b6d5f78f1cb322.
 * See LICENSES/NOTICE.txt and LICENSES/ARM-CMSIS-Apache-2.0.txt.
 */
#ifndef C_CORTEX_HAL_SUPPORT_H
#define C_CORTEX_HAL_SUPPORT_H

static inline void hal_cortex_compiler_barrier(void) {
    __asm__ volatile("" ::: "memory");
}

static inline void hal_cortex_dmb(void) {
#if defined(__arm__) || defined(__thumb__)
    __asm__ volatile("dmb 0xF" ::: "memory");
#else
    __builtin_trap();
#endif
}

static inline void hal_cortex_sev(void) {
#if defined(__arm__) || defined(__thumb__)
    __asm__ volatile("sev");
#else
    __builtin_trap();
#endif
}

static inline void hal_cortex_wfe(void) {
#if defined(__arm__) || defined(__thumb__)
    __asm__ volatile("wfe" ::: "memory");
#else
    __builtin_trap();
#endif
}

static inline void hal_cortex_nop(void) {
#if defined(__arm__) || defined(__thumb__)
    __asm__ volatile("nop");
#else
    __builtin_trap();
#endif
}

#endif
