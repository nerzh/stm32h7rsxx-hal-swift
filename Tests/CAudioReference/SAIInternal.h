#ifndef CSAI_INTERNAL_H
#define CSAI_INTERNAL_H
#include "AudioDefinitions.h"
#include "include/CAudioReference.h"
#include <assert.h>
#include <string.h>
struct CSAIState {
 SAI_HandleTypeDef h;
 SAI_Block_TypeDef regs[4];
 SAI_TypeDef global[2];
 uint32_t control[64];
 uint32_t buffers[2][1024];
 DMA_HandleTypeDef dma[2];DMA_Channel_TypeDef dmaRegs[2];DMA_QListTypeDef queue[2];DMA_NodeTypeDef node[2];
 uint32_t settings[2][16];uint32_t trace[1024],dmaTrace[1024];
};
#if defined(__arm__) || defined(__thumb__)
#define CAUDIO_THREAD_LOCAL
#else
#define CAUDIO_THREAD_LOCAL _Thread_local
#endif
extern CAUDIO_THREAD_LOCAL CSAIState *CSAI_Active;
uint32_t CSAI_Tick(void);uint32_t CSAI_Clock(uint32_t);
HAL_StatusTypeDef CSAI_DMAStart(DMA_HandleTypeDef *,uint32_t,uint32_t,uint32_t);
HAL_StatusTypeDef CSAI_DMAList(DMA_HandleTypeDef *);
HAL_StatusTypeDef CSAI_DMAAbort(DMA_HandleTypeDef *);
HAL_StatusTypeDef CSAI_DMAAbortIT(DMA_HandleTypeDef *);
uint32_t CSAI0_Run(CSAIState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSAI0_GetWord(CSAIState *,uint32_t);
void CSAI0_SetWord(CSAIState *,uint32_t,uint32_t);
uint32_t CSAI0_GetDMA(CSAIState *,uint32_t,uint32_t);
void CSAI0_SetDMA(CSAIState *,uint32_t,uint32_t,uint32_t);
uint32_t CSAI1_Run(CSAIState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSAI1_GetWord(CSAIState *,uint32_t);
void CSAI1_SetWord(CSAIState *,uint32_t,uint32_t);
uint32_t CSAI1_GetDMA(CSAIState *,uint32_t,uint32_t);
void CSAI1_SetDMA(CSAIState *,uint32_t,uint32_t,uint32_t);
#endif
