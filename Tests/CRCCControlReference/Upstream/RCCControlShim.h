/* Host-only hardware substitutions for the unmodified pinned STM32 C bodies. */
#ifndef C_RCC_CONTROL_SHIM_H
#define C_RCC_CONTROL_SHIM_H
#include "../include/CRCCControlReference.h"
#include <assert.h>
#include <float.h>
#include <math.h>
#include <stddef.h>
#include "stm32h7rsxx_control_bits.h"
#include "stm32h7rsxx_control_macros.h"

/* Original dependency closure includes physical-address aliases and the
 * configuration-template assert switch. Host bindings must be applied last. */
#undef RCC
#undef PWR
#undef FLASH
#undef assert_param

_Static_assert(FLT_EVAL_METHOD == 0, "RCC oracle requires binary32 float evaluation");
_Static_assert(sizeof(float_t) == sizeof(float), "RCC float_t must be binary32");
_Static_assert(offsetof(RCC_TypeDef, PLL2DIVR1) - offsetof(RCC_TypeDef, PLL1DIVR1) == 8, "PLL DIVR1 stride");
_Static_assert(offsetof(RCC_TypeDef, PLL3DIVR1) - offsetof(RCC_TypeDef, PLL1DIVR1) == 16, "PLL3 DIVR1 stride");
_Static_assert(offsetof(RCC_TypeDef, PLL2FRACR) - offsetof(RCC_TypeDef, PLL1FRACR) == 8, "PLL FRACR stride");
_Static_assert(offsetof(RCC_TypeDef, PLL2DIVR2) - offsetof(RCC_TypeDef, PLL1DIVR2) == 4, "PLL DIVR2 stride");
_Static_assert(offsetof(RCC_TypeDef, PLL3DIVR2) - offsetof(RCC_TypeDef, PLL1DIVR2) == 8, "PLL3 DIVR2 stride");

extern _Thread_local CRCCControlState *CRCCControl_Current;
uint32_t CRCCControl_Read(volatile uint32_t *address);
void CRCCControl_HardwareWrite(volatile uint32_t *address, uint32_t value);
uint32_t CRCCControl_HardwareTick(void);
uint32_t CRCCControl_HardwareInitTick(uint32_t priority);
void CRCCControl_HSECSSCallback(void);
uint32_t CRCCControl_CallPLL(uint32_t index, const RCC_PLLInitTypeDef *configuration);

#define RCC (&CRCCControl_Current->rcc)
#define PWR (&CRCCControl_Current->pwr)
#define FLASH (&CRCCControl_Current->flash)
#define HSI_VALUE (CRCCControl_Current->hsi)
#define CSI_VALUE (CRCCControl_Current->csi)
#define HSE_VALUE (CRCCControl_Current->hse)
#define SystemCoreClock (CRCCControl_Current->systemCoreClock)
#define uwTickPrio (CRCCControl_Current->tickPriority)
#define HAL_GetTick CRCCControl_HardwareTick
#define HAL_InitTick CRCCControl_HardwareInitTick
#define HAL_RCC_HSECSSCallback CRCCControl_HSECSSCallback
#define assert_param(expression) assert(expression)
#define READ_REG(reg) CRCCControl_Read(&(reg))
#define WRITE_REG(reg, value) CRCCControl_HardwareWrite(&(reg), (value))
#define READ_BIT(reg, mask) (READ_REG(reg) & (mask))
#define SET_BIT(reg, mask) WRITE_REG(reg, READ_REG(reg) | (mask))
#define CLEAR_BIT(reg, mask) WRITE_REG(reg, READ_REG(reg) & ~(mask))
#define MODIFY_REG(reg, clear, set) WRITE_REG(reg, (READ_REG(reg) & ~(clear)) | (set))
#define CLEAR_REG(reg) WRITE_REG(reg, 0U)

typedef enum { HAL_OK = 0, HAL_ERROR = 1, HAL_BUSY = 2, HAL_TIMEOUT = 3 } HAL_StatusTypeDef;
#define RESET 0U
#define SET 1U
#include "RCCControlGPIOType.h"
#define HAL_GPIO_MODULE_ENABLED
#define HAL_GPIO_Init CRCCControl_GPIOInit
void CRCCControl_GPIOInit(GPIO_TypeDef *port, GPIO_InitTypeDef *configuration);
#include "RCCControlFunctions.h"
#endif
