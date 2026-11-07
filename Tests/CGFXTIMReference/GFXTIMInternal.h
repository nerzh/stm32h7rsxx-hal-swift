#ifndef CGFXTIM_INTERNAL_H
#define CGFXTIM_INTERNAL_H
#include "include/CGFXTIMReference.h"
#include "stm32h7rsxx_hal_def.h"
#include <assert.h>
#include <string.h>
#define USE_HAL_GFXTIM_REGISTER_CALLBACKS 1
#define GFXTIM 1
#include "Upstream/GFXTIMBits.h"
#include "Upstream/stm32h7rsxx_hal_gfxtim.h"
struct CGFXTIMState {
    GFXTIM_TypeDef registers;
    GFXTIM_HandleTypeDef handle;
    uint32_t configuration[10], output, mode, action, traceCount, trace[64][12];
};
extern CGFXTIMState *CGFXTIM_Active;
uint32_t CGFXTIM_ReadAddress(volatile uint32_t *);
void CGFXTIM_WriteAddress(volatile uint32_t *, uint32_t);
uint32_t CGFXTIM0_Run(CGFXTIMState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CGFXTIM1_Run(CGFXTIMState *,uint32_t,uint32_t,uint32_t,uint32_t);
pGFXTIM_CallbackTypeDef CGFXTIM_CallbackPointer(uint32_t id,uint32_t token);
#endif
