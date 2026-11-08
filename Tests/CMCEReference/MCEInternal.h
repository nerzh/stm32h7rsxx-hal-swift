#ifndef CMCE_INTERNAL_H
#define CMCE_INTERNAL_H
#include "include/CMCEReference.h"
#include "stm32h7rsxx_hal_def.h"
#include <assert.h>
#include <string.h>
#define USE_HAL_MCE_REGISTER_CALLBACKS 1
#define MCE1 1
#include "Upstream/MCEBits.h"
#include "Upstream/stm32h7rsxx_hal_mce.h"
struct CMCEState {
 uint32_t regs[192]; MCE_HandleTypeDef h;
 uint32_t mode,instance,control[8],config[10],key[4],tick,tickCalls,traceCount,trace[64][208];
};
extern CMCEState *CMCE_Active;
uint32_t CMCE0_Run(CMCEState *,uint32_t,uint32_t,uint32_t);
uint32_t CMCE1_Run(CMCEState *,uint32_t,uint32_t,uint32_t);
#endif
