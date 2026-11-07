/* Test-only register, process, time and instruction bindings. */
#ifndef C_FLASH_SHIM_H
#define C_FLASH_SHIM_H
#include "FLASHInternal.h"
#include <assert.h>
#if defined(CFLASH_REFERENCE_ARM)
#undef assert
#define assert(expression) ((expression) ? (void)0 : __builtin_trap())
#endif
#include "Upstream/FLASHNamespace.h"
#include "Upstream/FLASHBits.h"
#include "Upstream/FLASHMacros.h"
#include "Upstream/FLASHExMacros.h"
#include "Upstream/FLASHHALMacros.h"
#ifdef __weak
#undef __weak
#endif
#define __weak __attribute__((weak))
#define assert_param(expression) assert(expression)
#define RESET 0U
#define SET 1U
#define FLASH (&CFLASH_Active->registers)
#define pFlash (CFLASH_Active->process)
#define READ_REG(reg) CFLASH_ReadAddress(&(reg))
#define WRITE_REG(reg,value) CFLASH_WriteAddress(&(reg),(uint32_t)(value))
#define CLEAR_REG(reg) WRITE_REG(reg,0)
#define READ_BIT(reg,mask) (READ_REG(reg) & (mask))
#define SET_BIT(reg,mask) WRITE_REG(reg,READ_REG(reg) | (mask))
#define CLEAR_BIT(reg,mask) WRITE_REG(reg,READ_REG(reg) & ~(mask))
#define MODIFY_REG(reg,clear,set) WRITE_REG(reg,(READ_REG(reg) & ~(clear)) | (set))
#define HAL_GetTick() CFLASH_Tick(CFLASH_Active)
#define __get_PRIMASK() CFLASH_Intrinsic(CFLASH_Active,0,0)
#define __disable_irq() ((void)CFLASH_Intrinsic(CFLASH_Active,1,0))
#define __ISB() ((void)CFLASH_Intrinsic(CFLASH_Active,2,0))
#define __DSB() ((void)CFLASH_Intrinsic(CFLASH_Active,3,0))
#define __set_PRIMASK(value) ((void)CFLASH_Intrinsic(CFLASH_Active,4,value))
#define SYSTEM_FLASH_SIZE 0x00020000UL
#if defined(CFLASH_REFERENCE_ARM)
_Static_assert(sizeof(void *) == 4, "Original program helpers require 32-bit pointers");
#undef FLASH_BASE
#undef FLASH_SIZE
#undef OTP_AREA_BASE
#define FLASH_BASE CFLASH_ARM_MAIN_BASE
#define FLASH_SIZE CFLASH_ARM_AREA_SIZE
#define OTP_AREA_BASE CFLASH_ARM_OTP_BASE
#endif
_Static_assert(sizeof(FLASH_TypeDef) == 0x270, "Exact CMSIS FLASH layout");
_Static_assert(offsetof(FLASH_TypeDef, OBKDR) == 0x118, "Exact key data layout");
_Static_assert(sizeof(FLASH_ProcessTypeDef) == 24, "Exact six-word process layout");
#include "Upstream/FLASHPublicPrototypes.inc"
#endif
