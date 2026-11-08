#ifndef CPSSI_INTERNAL_H
#define CPSSI_INTERNAL_H
#include "include/CPSSIReference.h"
#include "stm32h7rsxx_hal_def.h"
#include <assert.h>
#include <string.h>
#define PSSI 1
#define HAL_DMA_MODULE_ENABLED
#define USE_HAL_PSSI_REGISTER_CALLBACKS 1
#include "Upstream/PSSIBits.h"
typedef struct { uint32_t LinkRegisters[8]; } DMA_NodeTypeDef;
typedef struct { DMA_NodeTypeDef *Head; } DMA_QListTypeDef;
typedef struct DMA_HandleTypeDef DMA_HandleTypeDef;
struct DMA_HandleTypeDef {
 struct { uint32_t SrcDataWidth,DestDataWidth; } Init;
 uint32_t Mode;
 DMA_QListTypeDef *LinkedListQueue;
 void *Parent;
 void (*XferCpltCallback)(DMA_HandleTypeDef *);
 void (*XferHalfCpltCallback)(DMA_HandleTypeDef *);
 void (*XferErrorCallback)(DMA_HandleTypeDef *);
 void (*XferAbortCallback)(DMA_HandleTypeDef *);
};
#include "Upstream/stm32h7rsxx_hal_pssi.h"
struct CPSSIState {
 PSSI_TypeDef regs; PSSI_HandleTypeDef h; DMA_HandleTypeDef dma[2];
 DMA_QListTypeDef queues[2]; DMA_NodeTypeDef nodes[2];
 uint32_t mode,dmaEnabled,control[12],tick,tickCalls,meta[2][15],calls[8],traceCount,trace[32][128];
 _Alignas(4) uint8_t data[256];
};
extern CPSSIState *CPSSI_Active;
pPSSI_CallbackTypeDef CPSSI_CallbackPointer(uint32_t,uint32_t);
uint32_t CPSSI00_Run(CPSSIState *,uint32_t,uint32_t,uint32_t,uint32_t);
void CPSSI00_SetDMA(CPSSIState *,uint32_t,uint32_t,uint32_t);
uint32_t CPSSI00_GetDMA(CPSSIState *,uint32_t,uint32_t);
uint32_t CPSSI01_Run(CPSSIState *,uint32_t,uint32_t,uint32_t,uint32_t);
void CPSSI01_SetDMA(CPSSIState *,uint32_t,uint32_t,uint32_t);
uint32_t CPSSI01_GetDMA(CPSSIState *,uint32_t,uint32_t);
uint32_t CPSSI10_Run(CPSSIState *,uint32_t,uint32_t,uint32_t,uint32_t);
void CPSSI10_SetDMA(CPSSIState *,uint32_t,uint32_t,uint32_t);
uint32_t CPSSI10_GetDMA(CPSSIState *,uint32_t,uint32_t);
uint32_t CPSSI11_Run(CPSSIState *,uint32_t,uint32_t,uint32_t,uint32_t);
void CPSSI11_SetDMA(CPSSIState *,uint32_t,uint32_t,uint32_t);
uint32_t CPSSI11_GetDMA(CPSSIState *,uint32_t,uint32_t);

#endif
