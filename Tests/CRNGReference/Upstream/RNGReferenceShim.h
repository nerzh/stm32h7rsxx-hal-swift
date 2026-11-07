/* Host-only access substitutions; extracted HAL function bodies stay intact. */
#ifndef C_RNG_REFERENCE_SHIM_H
#define C_RNG_REFERENCE_SHIM_H
#include "../include/CRNGReference.h"
#include "RNGBits.h"
#include <assert.h>
#include <stddef.h>

_Static_assert(offsetof(RNG_TypeDef, CR) == 0, "RNG CR offset");
_Static_assert(offsetof(RNG_TypeDef, SR) == 4, "RNG SR offset");
_Static_assert(offsetof(RNG_TypeDef, DR) == 8, "RNG DR offset");
_Static_assert(offsetof(RNG_TypeDef, HTCR) == 16, "RNG HTCR offset");
_Static_assert(sizeof(RNG_TypeDef) == 20, "RNG CMSIS layout size");
_Static_assert(sizeof(((RNG_TypeDef *)0)->DR) == sizeof(uint32_t), "RNG DR access width");

extern _Thread_local CRNGReferenceState *CRNGReference_Current;
uint32_t CRNGReference_ReadAddress(volatile uint32_t *address);
void CRNGReference_WriteAddress(volatile uint32_t *address, uint32_t value);
uint32_t CRNGReference_HardwareTick(void);
uint32_t CRNGReference_PrepareDataRead(void);

#define __IO volatile
#undef __weak
#define __weak __attribute__((weak))
#define UNUSED(value) ((void)(value))
#define RESET 0U
#define SET 1U
#define assert_param(expression) assert(expression)
#define IS_RNG_ALL_INSTANCE(instance) ((instance) == &CRNGReference_Current->registers)
#define READ_REG(reg) CRNGReference_ReadAddress(&(reg))
/* A peripheral write converts the expression to its 32-bit register type.
 * Make that conversion explicit on LP64 hosts, where CMSIS UL masks are wider. */
#define WRITE_REG(reg, value) CRNGReference_WriteAddress(&(reg), (uint32_t)(value))
#define READ_BIT(reg, mask) (READ_REG(reg) & (mask))
#define SET_BIT(reg, mask) WRITE_REG(reg, READ_REG(reg) | (mask))
#define CLEAR_BIT(reg, mask) WRITE_REG(reg, READ_REG(reg) & ~(mask))
#define MODIFY_REG(reg, clear, set) WRITE_REG(reg, (READ_REG(reg) & ~(clear)) | (set))
#define HAL_IS_BIT_SET(reg, mask) ((READ_REG(reg) & (mask)) == (mask))
#define HAL_GetTick CRNGReference_HardwareTick
#define __HAL_LOCK(handle) do { if ((handle)->Lock == HAL_LOCKED) { return HAL_BUSY; } else { (handle)->Lock = HAL_LOCKED; } } while (0U)
#define __HAL_UNLOCK(handle) do { (handle)->Lock = HAL_UNLOCKED; } while (0U)
#define __HAL_RNG_ENABLE(handle) SET_BIT((handle)->Instance->CR, RNG_CR_RNGEN)
#define __HAL_RNG_DISABLE(handle) CLEAR_BIT((handle)->Instance->CR, RNG_CR_RNGEN)
#define __HAL_RNG_ENABLE_IT(handle) SET_BIT((handle)->Instance->CR, RNG_CR_IE)
#define __HAL_RNG_DISABLE_IT(handle) CLEAR_BIT((handle)->Instance->CR, RNG_CR_IE)
#define __HAL_RNG_GET_FLAG(handle, flag) ((READ_REG((handle)->Instance->SR) & (flag)) == (flag))
#define __HAL_RNG_GET_IT(handle, flag) ((READ_REG((handle)->Instance->SR) & (flag)) == (flag))
#define __HAL_RNG_CLEAR_IT(handle, flag) WRITE_REG((handle)->Instance->SR, ~(flag))

#include "RNGNamespace.h"
#include "RNGPrototypes.inc"
#include "RNG_exPrototypes.inc"
/* Only DR has a test-only declaration adaptation. The index function returns
 * zero after supplying the scripted value and data-read side effects. The
 * subsequent volatile array-element read remains the original C expression. */
#define DR DR[CRNGReference_PrepareDataRead()]
#endif
