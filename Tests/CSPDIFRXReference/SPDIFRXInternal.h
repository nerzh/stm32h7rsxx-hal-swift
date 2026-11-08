#ifndef CSPDIFRX_INTERNAL_H
#define CSPDIFRX_INTERNAL_H
#include "include/CSPDIFRXReference.h"
#include "stm32h7rsxx_hal_def.h"
#include <assert.h>
#include <string.h>
#define SPDIFRX 1
#define USE_HAL_SPDIFRX_REGISTER_CALLBACKS 1
#include "Upstream/SPDIFRXBits.h"
typedef struct { uint32_t LinkRegisters[8]; } DMA_NodeTypeDef;
typedef struct { DMA_NodeTypeDef *Head; } DMA_QListTypeDef;
typedef struct DMA_HandleTypeDef DMA_HandleTypeDef;
struct DMA_HandleTypeDef {
 uint32_t Mode; DMA_QListTypeDef *LinkedListQueue; void *Parent;
 void (*XferCpltCallback)(DMA_HandleTypeDef *);
 void (*XferHalfCpltCallback)(DMA_HandleTypeDef *);
 void (*XferErrorCallback)(DMA_HandleTypeDef *);
 void (*XferAbortCallback)(DMA_HandleTypeDef *);
};
#include "Upstream/stm32h7rsxx_hal_spdifrx.h"
struct CSPDIFRXState {
 SPDIFRX_TypeDef regs,global; SPDIFRX_HandleTypeDef h;
 DMA_HandleTypeDef dma[2]; DMA_QListTypeDef queue[2]; DMA_NodeTypeDef node[2];
 uint32_t mode,control[12],format[6],data[128],meta[2][13],calls[8],tick,tickCalls,traceCount,trace[32][224];
};
extern CSPDIFRXState *CSPDIFRX_Active;
pSPDIFRX_CallbackTypeDef CSPDIFRX_CallbackPointer(uint32_t,uint32_t);
uint32_t CSPDIFRX0_Run(CSPDIFRXState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSPDIFRX1_Run(CSPDIFRXState *,uint32_t,uint32_t,uint32_t,uint32_t);
void CSPDIFRX0_SetDMA(CSPDIFRXState *,uint32_t,uint32_t,uint32_t);
void CSPDIFRX1_SetDMA(CSPDIFRXState *,uint32_t,uint32_t,uint32_t);
uint32_t CSPDIFRX0_GetDMA(CSPDIFRXState *,uint32_t,uint32_t);
uint32_t CSPDIFRX1_GetDMA(CSPDIFRXState *,uint32_t,uint32_t);
#endif
