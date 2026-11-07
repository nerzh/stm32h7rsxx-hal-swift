/* Test-only instance validation. All original register accesses remain direct.
 * This model uses ordinary RAM registers: it does not claim physical ECC or
 * emulate hardware flag generation. The HAL's SR read-modify-write is literal. */
#ifndef C_RAMECC_SHIM_H
#define C_RAMECC_SHIM_H
#include "../include/CRAMECCReference.h"
#include "RAMECCBits.h"
#include "RAMECCMacros.h"
#include <stddef.h>
#define __IO volatile
#undef __weak
#define __weak __attribute__((weak))
#define UNUSED(value) ((void)(value))
#define RESET 0U
#define SET 1U
#define READ_REG(reg) (reg)
#define WRITE_REG(reg, value) ((reg) = (value))
#define READ_BIT(reg, mask) ((reg) & (mask))
#define SET_BIT(reg, mask) ((reg) |= (mask))
#define CLEAR_BIT(reg, mask) ((reg) &= ~(mask))
#define MODIFY_REG(reg, clear, set) ((reg) = (((reg) & ~(clear)) | (set)))
#define assert_param(expression) do { if (!(expression)) __builtin_trap(); } while (0)
RAMECC_MonitorTypeDef *CRAMECC_CurrentMonitor(void);
#define IS_RAMECC_MONITOR_ALL_INSTANCE(instance) ((instance) == CRAMECC_CurrentMonitor())
_Static_assert(sizeof(void *) == 4, "Unchanged RAMECC source requires 32-bit pointers");
_Static_assert(sizeof(RAMECC_MonitorTypeDef) == 24, "CMSIS monitor size");
_Static_assert(sizeof(RAMECC_TypeDef) == 4, "CMSIS global IER size");
_Static_assert(offsetof(RAMECC_MonitorTypeDef, SR) == 4, "CMSIS SR offset");
_Static_assert(offsetof(RAMECC_MonitorTypeDef, FECR) == 20, "CMSIS FECR offset");
_Static_assert(offsetof(CRAMECC0Handle, ErrorCode) == offsetof(CRAMECC0Handle, State) + 4, "State words contiguous");
_Static_assert(offsetof(CRAMECC1Handle, ErrorCode) == offsetof(CRAMECC1Handle, State) + 4, "State words contiguous");
#endif
