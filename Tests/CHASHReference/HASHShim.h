/* Test-only hardware/DMA boundary; unchanged C bodies retain pointer casts. */
#include "HASHInternal.h"
#include <assert.h>
#define CHASH_JOIN_INNER(a,b) a##b
#define CHASH_JOIN(a,b) CHASH_JOIN_INNER(a,b)
#define USE_HAL_HASH_REGISTER_CALLBACKS CHASH_CALLBACK_MODE
#define USE_HAL_HASH_SUSPEND_RESUME CHASH_SUSPEND_MODE
#define HASH_HandleTypeDef CHASH_JOIN(CHASH_VARIANT,Handle)
typedef void (*pHASH_CallbackTypeDef)(HASH_HandleTypeDef *);
#include "Upstream/HASHNamespace.h"
#include "Upstream/HASHBits.h"
#undef __weak
#include "Upstream/HASHMacros.h"
#undef __weak
#define __weak __attribute__((weak))
#define assert_param(expression) assert(expression)
#define HASH (&CHASH_Active->registers)
#define HASH_DIGEST (&CHASH_Active->digest)
#undef READ_REG
#undef WRITE_REG
#undef READ_BIT
#undef SET_BIT
#undef CLEAR_BIT
#undef MODIFY_REG
#define READ_REG(reg) CHASH_ReadAddress(&(reg))
#define WRITE_REG(reg,value) CHASH_WriteAddress(&(reg),(uint32_t)(value))
#define READ_BIT(reg,mask) (READ_REG(reg) & (mask))
#define SET_BIT(reg,mask) WRITE_REG(reg,READ_REG(reg) | (mask))
#define CLEAR_BIT(reg,mask) WRITE_REG(reg,READ_REG(reg) & ~(mask))
#define MODIFY_REG(reg,clear,set) WRITE_REG(reg,(READ_REG(reg) & ~(clear)) | (set))
#define HAL_GetTick() CHASH_Tick(CHASH_Active)
#define HAL_DMA_Start_IT CHASH_DMAStart
#define HAL_DMAEx_List_Start_IT CHASH_DMAListStart
#define HAL_DMA_Abort CHASH_DMAAbort
#define __REV(value) __builtin_bswap32((uint32_t)(value))
#include "Upstream/HASHPrototypes.inc"
