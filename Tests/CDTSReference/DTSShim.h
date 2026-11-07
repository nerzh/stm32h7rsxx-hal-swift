/* Test-only hardware, time and clock bindings; source bodies stay unchanged. */
#include "DTSInternal.h"
#include <assert.h>
#define CDTS_JOIN_INNER(a,b) a##b
#define CDTS_JOIN(a,b) CDTS_JOIN_INNER(a,b)
#include "Upstream/DTSNamespace.h"
#define USE_HAL_DTS_REGISTER_CALLBACKS CDTS_CALLBACK_MODE
#ifdef __weak
#undef __weak
#endif
#define __weak __attribute__((weak))
#define assert_param(expression) assert(expression)
#define RESET 0U
#define SET 1U
#define DTS (&CDTS_Active->registers)
#define EXTI (&CDTS_Active->exti)
#define READ_REG(reg) CDTS_ReadAddress(&(reg))
#define WRITE_REG(reg,value) CDTS_WriteAddress(&(reg),(uint32_t)(value))
#define CLEAR_REG(reg) WRITE_REG(reg,0)
#define READ_BIT(reg,mask) (READ_REG(reg) & (mask))
#define SET_BIT(reg,mask) WRITE_REG(reg,READ_REG(reg) | (mask))
#define CLEAR_BIT(reg,mask) WRITE_REG(reg,READ_REG(reg) & ~(mask))
#define MODIFY_REG(reg,clear,set) WRITE_REG(reg,(READ_REG(reg) & ~(clear)) | (set))
#define HAL_GetTick() CDTS_Tick(CDTS_Active)
#define HAL_Delay(duration) CDTS_Delay(CDTS_Active,duration)
#define HAL_RCC_GetPCLK1Freq() (CDTS_Active->pclk1)
/* uint32_t matches the original Cortex-M unsigned long expression width. */
#define LSE_VALUE (CDTS_Active->lse)
#include "Upstream/DTSHALMacros.h"
#include "Upstream/DTSBits.h"
#include "Upstream/DTSMacros.h"
typedef void (*pDTS_CallbackTypeDef)(DTS_HandleTypeDef *);
#include "Upstream/DTSPrototypes.inc"
