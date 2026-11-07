/* Test-only access/time substitutions; original direct accesses stay direct. */
#ifndef C_WATCHDOG_REFERENCE_SHIM_H
#define C_WATCHDOG_REFERENCE_SHIM_H
#include "../include/CWatchdogReference.h"
#include "WatchdogBits.h"
#include <assert.h>
#include <stddef.h>

extern _Thread_local CWatchdogState *CWatchdog_Current;
uint32_t CWatchdog_ReadAddress(volatile uint32_t *address);
void CWatchdog_WriteAddress(volatile uint32_t *address, uint32_t value);
uint32_t CWatchdog_HardwareTick(void);
#define __IO volatile
#undef __weak
#define __weak __attribute__((weak))
#define UNUSED(value) ((void)(value))
#define RESET 0U
#define SET 1U
#define assert_param(expression) assert(expression)
#define IS_IWDG_ALL_INSTANCE(instance) ((instance) == &CWatchdog_Current->iwdg)
#define IS_WWDG_ALL_INSTANCE(instance) ((instance) == &CWatchdog_Current->wwdg)
#define READ_REG(reg) CWatchdog_ReadAddress(&(reg))
/* Preserve the implicit 32-bit volatile assignment conversion on LP64 hosts. */
#define WRITE_REG(reg, value) CWatchdog_WriteAddress(&(reg), (uint32_t)(value))
#define READ_BIT(reg, mask) (READ_REG(reg) & (mask))
#define SET_BIT(reg, mask) WRITE_REG(reg, READ_REG(reg) | (mask))
#define CLEAR_BIT(reg, mask) WRITE_REG(reg, READ_REG(reg) & ~(mask))
#define MODIFY_REG(reg, clear, set) WRITE_REG(reg, (READ_REG(reg) & ~(clear)) | (set))
#define HAL_GetTick CWatchdog_HardwareTick
#define LSI_VALUE (CWatchdog_Current->lsi)
#define LSI_STARTUP_TIME (CWatchdog_Current->lsiStartupTime)
#define CWATCHDOG_JOIN_(a, b) a##b
#define CWATCHDOG_JOIN(a, b) CWATCHDOG_JOIN_(a, b)

_Static_assert(sizeof(IWDG_TypeDef) == 24, "IWDG exact CMSIS size");
_Static_assert(offsetof(IWDG_TypeDef, EWCR) == 20, "IWDG EWCR offset");
_Static_assert(sizeof(WWDG_TypeDef) == 12, "WWDG exact CMSIS size");
_Static_assert(offsetof(WWDG_TypeDef, SR) == 8, "WWDG SR offset");
#endif
