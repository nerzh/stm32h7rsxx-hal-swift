/* Hardware/DMA bindings; original C bodies and pointer casts stay unchanged. */
#include "CORDICInternal.h"
#include <assert.h>
#define CCORDIC_JOIN_INNER(a,b) a##b
#define CCORDIC_JOIN(a,b) CCORDIC_JOIN_INNER(a,b)
#define USE_HAL_CORDIC_REGISTER_CALLBACKS CCORDIC_CALLBACK_MODE
#define CORDIC_HandleTypeDef CCORDIC_JOIN(CCORDIC_VARIANT,Handle)
#include "Upstream/CORDICNamespace.h"
#include "Upstream/CORDICBits.h"
#include "Upstream/CORDICMacros.h"
#include "Upstream/CORDICHALMacros.h"
#ifdef __weak
#undef __weak
#endif
#define __weak __attribute__((weak))
#define assert_param(expression) assert(expression)
#define RESET 0U
#define SET 1U
#define CORDIC (&CCORDIC_Active->registers)
#define READ_REG(reg) CCORDIC_ReadAddress(&(reg))
#define WRITE_REG(reg,value) CCORDIC_WriteAddress(&(reg),(uint32_t)(value))
#define READ_BIT(reg,mask) (READ_REG(reg) & (mask))
#define SET_BIT(reg,mask) WRITE_REG(reg,READ_REG(reg) | (mask))
#define CLEAR_BIT(reg,mask) WRITE_REG(reg,READ_REG(reg) & ~(mask))
#define MODIFY_REG(reg,clear,set) WRITE_REG(reg,(READ_REG(reg) & ~(clear)) | (set))
#define HAL_GetTick() CCORDIC_Tick(CCORDIC_Active)
#define HAL_DMA_Start_IT CCORDIC_DMAStart
#include "Upstream/CORDICPrototypes.inc"
