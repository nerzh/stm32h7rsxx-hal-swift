/* Test-only register bindings and CPU bit-operation equivalents. */
#ifndef C_SYSTEM_SHIM_H
#define C_SYSTEM_SHIM_H
#include "include/CSystemReference.h"
#include <assert.h>
extern _Thread_local CSystemState *CSystem_Active;
uint32_t CSystem_ReadAddress(volatile uint32_t *);
void CSystem_WriteAddress(volatile uint32_t *,uint32_t);
#include "Upstream/SystemNamespace.h"
#include "Upstream/SystemBits.h"
#include "Upstream/SystemMacros.h"
#define assert_param(expression) assert(expression)
#define SBS (&CSystem_Active->sbs)
#define VREFBUF (&CSystem_Active->vref)
#define FMC_Bank1_R (&CSystem_Active->fmc)
#define AXIM_ASIB_1 (&CSystem_Active->asib[0])
#define AXIM_ASIB_2 (&CSystem_Active->asib[1])
#define AXIM_ASIB_3 (&CSystem_Active->asib[2])
#define AXIM_ASIB_4 (&CSystem_Active->asib[3])
#define AXIM_ASIB_5 (&CSystem_Active->asib[4])
#define AXIM_ASIB_6 (&CSystem_Active->asib[5])
#define AXIM_ASIB_7 (&CSystem_Active->asib[6])
#define AXIM_ASIB_8 (&CSystem_Active->asib[7])
#define AXIM_ASIB_9 (&CSystem_Active->asib[8])
#define AXIM_ASIB_10 (&CSystem_Active->asib[9])
#define AXIM_ASIB_11 (&CSystem_Active->asib[10])
#define AXIM_AMIB_1 (&CSystem_Active->amib[0])
#define AXIM_AMIB_2 (&CSystem_Active->amib[1])
#define AXIM_AMIB_3 (&CSystem_Active->amib[2])
#define AXIM_AMIB_4 (&CSystem_Active->amib[3])
#define AXIM_AMIB_5 (&CSystem_Active->amib[4])
#define AXIM_AMIB_6 (&CSystem_Active->amib[5])
#define AXIM_AMIB_7 (&CSystem_Active->amib[6])
#define AXIM_AMIB_8 (&CSystem_Active->amib[7])
#define AXIM_AMIB_9 (&CSystem_Active->amib[8])
#define AXIM_AMIB_10 (&CSystem_Active->amib[9])
#undef READ_REG
#undef WRITE_REG
#undef READ_BIT
#undef SET_BIT
#undef CLEAR_BIT
#undef MODIFY_REG
#define READ_REG(reg) CSystem_ReadAddress(&(reg))
#define WRITE_REG(reg,value) CSystem_WriteAddress(&(reg),(uint32_t)(value))
#define READ_BIT(reg,mask) (READ_REG(reg) & (mask))
#define SET_BIT(reg,mask) WRITE_REG(reg,READ_REG(reg) | (mask))
#define CLEAR_BIT(reg,mask) WRITE_REG(reg,READ_REG(reg) & ~(mask))
#define MODIFY_REG(reg,clear,set) WRITE_REG(reg,(READ_REG(reg) & ~(clear)) | (set))
#define HAL_GetTick() CSystem_Tick(CSystem_Active)
#define __RBIT(value) __builtin_bitreverse32((uint32_t)(value))
#define __CLZ(value) ((uint32_t)(value) == 0U ? 32U : (uint32_t)__builtin_clz((uint32_t)(value)))
#include "Upstream/SystemPrototypes.inc"
#endif
