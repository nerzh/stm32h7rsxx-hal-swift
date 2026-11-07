/* Host-only bindings. Function bodies and selected upstream macros are intact. */
#ifndef C_RCC_EXTENDED_SHIM_H
#define C_RCC_EXTENDED_SHIM_H
#include "../include/CRCCExtendedReference.h"
#include <assert.h>
#include <float.h>
#include <math.h>
#include <stddef.h>
#include "RCCExtendedBits.h"
#include "RCCExtendedMacros.h"

_Static_assert(FLT_EVAL_METHOD == 0, "RCC oracle requires binary32 evaluation");
_Static_assert(sizeof(float_t) == sizeof(float), "RCC float_t must be binary32");
_Static_assert(offsetof(RCC_TypeDef, PLL2DIVR1) - offsetof(RCC_TypeDef, PLL1DIVR1) == 8, "PLL DIVR1 stride");
_Static_assert(offsetof(RCC_TypeDef, PLL3DIVR1) - offsetof(RCC_TypeDef, PLL1DIVR1) == 16, "PLL3 DIVR1 stride");
_Static_assert(offsetof(RCC_TypeDef, PLL2FRACR) - offsetof(RCC_TypeDef, PLL1FRACR) == 8, "PLL FRACR stride");
_Static_assert(offsetof(RCC_TypeDef, PLL3FRACR) - offsetof(RCC_TypeDef, PLL1FRACR) == 16, "PLL3 FRACR stride");
_Static_assert(offsetof(RCC_TypeDef, PLL2DIVR2) - offsetof(RCC_TypeDef, PLL1DIVR2) == 4, "PLL DIVR2 stride");
_Static_assert(offsetof(RCC_TypeDef, PLL3DIVR2) - offsetof(RCC_TypeDef, PLL1DIVR2) == 8, "PLL3 DIVR2 stride");
_Static_assert(offsetof(RCC_TypeDef, CCIPR1) == 0x4C && offsetof(RCC_TypeDef, CCIPR2) == 0x50, "RCC CCIPR1/2 offsets");
_Static_assert(offsetof(RCC_TypeDef, CCIPR3) == 0x54 && offsetof(RCC_TypeDef, CCIPR4) == 0x58, "RCC CCIPR3/4 offsets");
_Static_assert(offsetof(RCC_TypeDef, CKPROTR) == 0x100, "RCC clock protection offset");
_Static_assert(offsetof(RCC_TypeDef, APB1RSTR2) == 0x94 && offsetof(RCC_TypeDef, BDCR) == 0x70, "RCC reset/backup offsets");
_Static_assert(offsetof(PWR_TypeDef, CR1) == 0, "PWR backup access offset");
_Static_assert(offsetof(EXTI_TypeDef, RTSR1) == 0 && offsetof(EXTI_TypeDef, IMR1) == 0x80, "H7RS EXTI offsets");
_Static_assert(offsetof(CRS_TypeDef, CR) == 0 && offsetof(CRS_TypeDef, CFGR) == 4, "CRS control offsets");
_Static_assert(offsetof(CRS_TypeDef, ISR) == 8 && offsetof(CRS_TypeDef, ICR) == 12, "CRS status offsets");

extern _Thread_local CRCCExtendedState *CRCCExtended_Current;
uint32_t CRCCExtended_ReadAddress(volatile uint32_t *address);
void CRCCExtended_WriteAddress(volatile uint32_t *address, uint32_t value);
uint32_t CRCCExtended_HardwareTick(void);

#define RCC (&CRCCExtended_Current->rcc)
#define PWR (&CRCCExtended_Current->pwr)
#define EXTI (&CRCCExtended_Current->exti)
#define CRS (&CRCCExtended_Current->crs)
#define HSI_VALUE (CRCCExtended_Current->hsi)
#define CSI_VALUE (CRCCExtended_Current->csi)
#define HSE_VALUE (CRCCExtended_Current->hse)
#define HSI48_VALUE (CRCCExtended_Current->hsi48)
#define LSE_VALUE (CRCCExtended_Current->lse)
#define LSI_VALUE (CRCCExtended_Current->lsi)
#define EXTERNAL_CLOCK_VALUE (CRCCExtended_Current->externalClock)
#define LSE_STARTUP_TIMEOUT (CRCCExtended_Current->lseStartupTimeout)
#define HAL_GetTick CRCCExtended_HardwareTick
#define HAL_MAX_DELAY UINT32_MAX
#define assert_param(expression) assert(expression)
#define READ_REG(reg) CRCCExtended_ReadAddress(&(reg))
/* Match assignment to a uint32_t peripheral even when host unsigned long is 64 bits. */
#define WRITE_REG(reg, value) CRCCExtended_WriteAddress(&(reg), (uint32_t)(value))
#define READ_BIT(reg, mask) (READ_REG(reg) & (mask))
#define SET_BIT(reg, mask) WRITE_REG(reg, READ_REG(reg) | (mask))
#define CLEAR_BIT(reg, mask) WRITE_REG(reg, READ_REG(reg) & ~(mask))
#define MODIFY_REG(reg, clear, set) WRITE_REG(reg, (READ_REG(reg) & ~(clear)) | (set))
#define CLEAR_REG(reg) WRITE_REG(reg, 0U)
#define RESET 0U
#define SET 1U
#define UNUSED(value) ((void)(value))
#undef __weak
#define __weak __attribute__((weak))
typedef enum { HAL_OK = 0, HAL_ERROR = 1, HAL_BUSY = 2, HAL_TIMEOUT = 3 } HAL_StatusTypeDef;
#include "RCCExtendedNamespace.h"
#include "RCCExtendedPrototypes.h"
#endif
