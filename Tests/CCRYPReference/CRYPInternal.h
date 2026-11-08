#ifndef CCRYP_INTERNAL_H
#define CCRYP_INTERNAL_H
#include "include/CCRYPReference.h"
#include "CRYPDefinitions.h"
#include <assert.h>
#if defined(__arm__) || defined(__thumb__)
#define CCRYP_THREAD_LOCAL
#else
#define CCRYP_THREAD_LOCAL _Thread_local
#endif
struct CCRYPState {
    CRYP_HandleTypeDef h;
    CRYP_ConfigTypeDef configuration;
    uint32_t registers[196];
    uint32_t buffers[8][256];
    DMA_HandleTypeDef dma[2];
    DMA_Channel_TypeDef channels[2];
    DMA_QListTypeDef queues[2];
    DMA_NodeTypeDef nodes[2];
    uint32_t control[64];
    uint32_t trace[1024];
    uint32_t events[32][4];
};
extern CCRYP_THREAD_LOCAL CCRYPState *CCRYP_Active;
uint32_t CCRYP_Tick(void);
HAL_StatusTypeDef CCRYP_DMAStart(DMA_HandleTypeDef *,uint32_t,uint32_t,uint32_t);
HAL_StatusTypeDef CCRYP_DMAList(DMA_HandleTypeDef *);
HAL_StatusTypeDef CCRYP_DMAAbort(DMA_HandleTypeDef *);
pCRYP_CallbackTypeDef CCRYP_CallbackPointer(uint32_t,uint32_t);
uint32_t CCRYP000_Run(CCRYPState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CCRYP001_Run(CCRYPState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CCRYP002_Run(CCRYPState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CCRYP010_Run(CCRYPState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CCRYP011_Run(CCRYPState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CCRYP012_Run(CCRYPState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CCRYP100_Run(CCRYPState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CCRYP101_Run(CCRYPState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CCRYP102_Run(CCRYPState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CCRYP110_Run(CCRYPState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CCRYP111_Run(CCRYPState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CCRYP112_Run(CCRYPState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CCRYP000_GetDMACallback(CCRYPState *,uint32_t,uint32_t);
void CCRYP000_SetDMACallback(CCRYPState *,uint32_t,uint32_t,uint32_t);
uint32_t CCRYP001_GetDMACallback(CCRYPState *,uint32_t,uint32_t);
void CCRYP001_SetDMACallback(CCRYPState *,uint32_t,uint32_t,uint32_t);
uint32_t CCRYP002_GetDMACallback(CCRYPState *,uint32_t,uint32_t);
void CCRYP002_SetDMACallback(CCRYPState *,uint32_t,uint32_t,uint32_t);
uint32_t CCRYP010_GetDMACallback(CCRYPState *,uint32_t,uint32_t);
void CCRYP010_SetDMACallback(CCRYPState *,uint32_t,uint32_t,uint32_t);
uint32_t CCRYP011_GetDMACallback(CCRYPState *,uint32_t,uint32_t);
void CCRYP011_SetDMACallback(CCRYPState *,uint32_t,uint32_t,uint32_t);
uint32_t CCRYP012_GetDMACallback(CCRYPState *,uint32_t,uint32_t);
void CCRYP012_SetDMACallback(CCRYPState *,uint32_t,uint32_t,uint32_t);
uint32_t CCRYP100_GetDMACallback(CCRYPState *,uint32_t,uint32_t);
void CCRYP100_SetDMACallback(CCRYPState *,uint32_t,uint32_t,uint32_t);
uint32_t CCRYP101_GetDMACallback(CCRYPState *,uint32_t,uint32_t);
void CCRYP101_SetDMACallback(CCRYPState *,uint32_t,uint32_t,uint32_t);
uint32_t CCRYP102_GetDMACallback(CCRYPState *,uint32_t,uint32_t);
void CCRYP102_SetDMACallback(CCRYPState *,uint32_t,uint32_t,uint32_t);
uint32_t CCRYP110_GetDMACallback(CCRYPState *,uint32_t,uint32_t);
void CCRYP110_SetDMACallback(CCRYPState *,uint32_t,uint32_t,uint32_t);
uint32_t CCRYP111_GetDMACallback(CCRYPState *,uint32_t,uint32_t);
void CCRYP111_SetDMACallback(CCRYPState *,uint32_t,uint32_t,uint32_t);
uint32_t CCRYP112_GetDMACallback(CCRYPState *,uint32_t,uint32_t);
void CCRYP112_SetDMACallback(CCRYPState *,uint32_t,uint32_t,uint32_t);
#endif
