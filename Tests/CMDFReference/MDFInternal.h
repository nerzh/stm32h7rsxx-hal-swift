#ifndef CMDF_INTERNAL_H
#define CMDF_INTERNAL_H
#include "include/CMDFReference.h"
#include "stm32h7rsxx_hal_def.h"
#include <assert.h>
#include <string.h>
#define USE_HAL_MDF_REGISTER_CALLBACKS 1
#include "Upstream/MDFBits.h"
typedef struct { uint32_t LinkRegisters[8]; } DMA_NodeTypeDef;
typedef struct { DMA_NodeTypeDef *Head; } DMA_QListTypeDef;
typedef struct DMA_HandleTypeDef DMA_HandleTypeDef;
struct DMA_HandleTypeDef {
 uint32_t Mode; DMA_QListTypeDef *LinkedListQueue; void *Parent;
 void (*XferCpltCallback)(DMA_HandleTypeDef *);
 void (*XferHalfCpltCallback)(DMA_HandleTypeDef *);
 void (*XferErrorCallback)(DMA_HandleTypeDef *);
};
#include "Upstream/stm32h7rsxx_hal_mdf.h"
struct CMDFState {
 uint32_t regs[64]; MDF_HandleTypeDef h,other,*owner;
 MDF_FilterConfigTypeDef config; MDF_DmaConfigTypeDef dmaConfig;
 DMA_HandleTypeDef dma; DMA_QListTypeDef queue; DMA_NodeTypeDef node;
 uint32_t mode,control[12],meta[9],calls[6],output[3],tick,tickCalls,traceCount,trace[32][160];
};
extern CMDFState *CMDF_Active;
pMDF_CallbackTypeDef CMDF_CallbackPointer(uint32_t,uint32_t);
pMDF_SndLvlCallbackTypeDef CMDF_SoundPointer(uint32_t);
uint32_t CMDF0_Run(CMDFState *,uint32_t,uint32_t,uint32_t);
uint32_t CMDF1_Run(CMDFState *,uint32_t,uint32_t,uint32_t);
void CMDF0_SetDMA(CMDFState *,uint32_t,uint32_t);
void CMDF1_SetDMA(CMDFState *,uint32_t,uint32_t);
uint32_t CMDF0_GetDMA(CMDFState *,uint32_t);
uint32_t CMDF1_GetDMA(CMDFState *,uint32_t);
#endif
