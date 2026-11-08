#ifndef CTIM_INTERNAL_H
#define CTIM_INTERNAL_H
#include "TIMDefinitions.h"
#include "include/CTIMReference.h"
#include <assert.h>
#include <string.h>
struct CTIMState {
 TIM_HandleTypeDef h; TIM_TypeDef regs[14];
 uint32_t control[64],configuration[16],buffers[2][128];
 DMA_HandleTypeDef dma[8];DMA_Channel_TypeDef dmaRegs[8];DMA_QListTypeDef queue[8];DMA_NodeTypeDef node[8];
 uint32_t settings[8][16],trace[2048],dmaTrace[1024],access[2048];
};
#if defined(__arm__) || defined(__thumb__)
#define CTIM_THREAD_LOCAL
#else
#define CTIM_THREAD_LOCAL _Thread_local
#endif
extern CTIM_THREAD_LOCAL CTIMState *CTIM_Active;
uint32_t CTIM_Tick(void);
uint32_t CTIM_ReadAddress(const volatile uint32_t *);
void CTIM_WriteAddress(volatile uint32_t *,uint32_t);
HAL_StatusTypeDef CTIM_DMAStart(DMA_HandleTypeDef *,uint32_t,uint32_t,uint32_t);
HAL_StatusTypeDef CTIM_DMAList(DMA_HandleTypeDef *);
HAL_StatusTypeDef CTIM_DMAAbortIT(DMA_HandleTypeDef *);
uint32_t CTIM0_Run(CTIMState *,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CTIM0_GetDMACallback(CTIMState *,uint32_t,uint32_t);
void CTIM0_SetDMACallback(CTIMState *,uint32_t,uint32_t,uint32_t);
uint32_t CTIM1_Run(CTIMState *,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CTIM1_GetDMACallback(CTIMState *,uint32_t,uint32_t);
void CTIM1_SetDMACallback(CTIMState *,uint32_t,uint32_t,uint32_t);
#endif
