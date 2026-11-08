#ifndef CI2S_INTERNAL_H
#define CI2S_INTERNAL_H
#include "AudioDefinitions.h"
#include "include/CAudioReference.h"
#include <assert.h>
#include <string.h>
struct CI2SState {
 I2S_HandleTypeDef h;
 SPI_TypeDef regs[4];
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
extern CAUDIO_THREAD_LOCAL CI2SState *CI2S_Active;
uint32_t CI2S_Tick(void);uint32_t CI2S_Clock(uint32_t);
HAL_StatusTypeDef CI2S_DMAStart(DMA_HandleTypeDef *,uint32_t,uint32_t,uint32_t);
HAL_StatusTypeDef CI2S_DMAList(DMA_HandleTypeDef *);
HAL_StatusTypeDef CI2S_DMAAbort(DMA_HandleTypeDef *);
HAL_StatusTypeDef CI2S_DMAAbortIT(DMA_HandleTypeDef *);
uint32_t CI2S0_Run(CI2SState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CI2S0_GetWord(CI2SState *,uint32_t);
void CI2S0_SetWord(CI2SState *,uint32_t,uint32_t);
uint32_t CI2S0_GetDMA(CI2SState *,uint32_t,uint32_t);
void CI2S0_SetDMA(CI2SState *,uint32_t,uint32_t,uint32_t);
uint32_t CI2S1_Run(CI2SState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CI2S1_GetWord(CI2SState *,uint32_t);
void CI2S1_SetWord(CI2SState *,uint32_t,uint32_t);
uint32_t CI2S1_GetDMA(CI2SState *,uint32_t,uint32_t);
void CI2S1_SetDMA(CI2SState *,uint32_t,uint32_t,uint32_t);
#endif
