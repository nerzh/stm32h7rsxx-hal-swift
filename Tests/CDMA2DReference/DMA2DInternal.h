#ifndef CDMA2D_INTERNAL_H
#define CDMA2D_INTERNAL_H
#include "include/CDMA2DReference.h"
#include "stm32h7rsxx_hal_def.h"
#include <assert.h>
#include <string.h>
#define DMA2D 1
#define USE_HAL_DMA2D_REGISTER_CALLBACKS 1
#include "Upstream/DMA2DBits.h"
#include "Upstream/stm32h7rsxx_hal_dma2d.h"
struct CDMA2DState {
    DMA2D_TypeDef registers;
    DMA2D_HandleTypeDef handle;
    uint32_t mode,control[12],traceCount,trace[64][56];
};
extern CDMA2DState *CDMA2D_Active;
uint32_t CDMA2D0_Run(CDMA2DState *,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CDMA2D1_Run(CDMA2DState *,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
void CDMA2D_WriteAddress(volatile uint32_t *,uint32_t);
pDMA2D_CallbackTypeDef CDMA2D_CallbackPointer(uint32_t id,uint32_t token);
#endif
