#ifndef CLTDC_INTERNAL_H
#define CLTDC_INTERNAL_H
#include "include/CLTDCReference.h"
#include "stm32h7rsxx_hal_def.h"
#include <assert.h>
#include <string.h>
#define LTDC ((LTDC_TypeDef *)CLTDC_Active->registers)
#define LTDC_Layer2_BASE 0x50001104U
#define USE_HAL_LTDC_REGISTER_CALLBACKS 1
#include "Upstream/LTDCBits.h"
#include "Upstream/stm32h7rsxx_hal_ltdc.h"
struct CLTDCState {
    uint32_t registers[128];
    LTDC_HandleTypeDef handle;
    LTDC_LayerCfgTypeDef configuration;
    uint32_t mode,control[6],colors[512],traceCount,trace[128][184];
};
extern CLTDCState *CLTDC_Active;
uint32_t CLTDC0_Run(CLTDCState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CLTDC1_Run(CLTDCState *,uint32_t,uint32_t,uint32_t,uint32_t);
pLTDC_CallbackTypeDef CLTDC_CallbackPointer(uint32_t id,uint32_t token);
#endif
