/* Copyright (c) 2009-2025 Arm Limited. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 * Instruction wrappers adapted from CMSIS_6 cmsis_gcc.h and
 * m-profile/cmsis_gcc_m.h at
 * 3c860f7a5810a34205bdbadb84b6d5f78f1cb322.
 * See LICENSES/NOTICE.txt and LICENSES/ARM-CMSIS-Apache-2.0.txt.
 */
#ifndef C_CORTEX_HAL_SUPPORT_H
#define C_CORTEX_HAL_SUPPORT_H

#include <stdint.h>

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

static inline void hal_cortex_set_primask(uint32_t value) {
#if defined(__arm__) || defined(__thumb__)
    __asm__ volatile("msr primask, %0" :: "r"(value) : "memory");
#else
    (void)value;
    __builtin_trap();
#endif
}

/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * Atomic register loop from cmsis-device-h7rs stm32h7rsxx.h at
 * 7e6e213ddc397c76622a0aca2f623ccc3b34c010 (Apache-2.0).
 * LDREXW/STREXW operands follow the Arm CMSIS intrinsics cited above.
 */
static inline void hal_cortex_atomic_modify32(volatile uint32_t *address,
                                             uint32_t clear_mask, uint32_t set_mask) {
#if defined(__arm__) || defined(__thumb__)
    uint32_t value, status;
    do {
        __asm__ volatile("ldrex %0, %1" : "=r"(value) : "Q"(*address));
        value = (value & ~clear_mask) | set_mask;
        __asm__ volatile("strex %0, %2, %1" : "=&r"(status), "=Q"(*address) : "r"(value));
    } while (status != 0U);
#else
    (void)address; (void)clear_mask; (void)set_mask;
    __builtin_trap();
#endif
}

#endif
