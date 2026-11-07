/* Test-only access/time substitution; direct volatile accesses remain direct. */
#ifndef C_ICACHE_REFERENCE_SHIM_H
#define C_ICACHE_REFERENCE_SHIM_H
#include "../include/CICacheReference.h"
#include "ICacheBits.h"
#include <assert.h>
#include <stddef.h>

extern _Thread_local CICacheState *CICache_Current;
uint32_t CICache_ReadAddress(volatile uint32_t *address);
void CICache_WriteAddress(volatile uint32_t *address, uint32_t value);
uint32_t CICache_HardwareTick(void);
#define ICACHE (&CICache_Current->registers)
#undef __weak
#define __weak __attribute__((weak))
#define assert_param(expression) assert(expression)
#define READ_REG(reg) CICache_ReadAddress(&(reg))
/* Keep the original volatile uint32_t assignment conversion on LP64 hosts. */
#define WRITE_REG(reg, value) CICache_WriteAddress(&(reg), (uint32_t)(value))
#define READ_BIT(reg, mask) (READ_REG(reg) & (mask))
#define SET_BIT(reg, mask) WRITE_REG(reg, READ_REG(reg) | (mask))
#define CLEAR_BIT(reg, mask) WRITE_REG(reg, READ_REG(reg) & ~(mask))
#define MODIFY_REG(reg, clear, set) WRITE_REG(reg, (READ_REG(reg) & ~(clear)) | (set))
#define HAL_GetTick CICache_HardwareTick
_Static_assert(sizeof(ICACHE_TypeDef) == 24, "ICACHE exact CMSIS size");
_Static_assert(offsetof(ICACHE_TypeDef, MMONR) == 20, "ICACHE MMONR offset");
#endif
