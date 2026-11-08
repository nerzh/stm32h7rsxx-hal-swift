#ifndef CI2C_INTERNAL_H
#define CI2C_INTERNAL_H
#include "I2CDefinitions.h"
#include "include/CI2CReference.h"
#include <assert.h>
#include <string.h>
struct CI2CState {
 I2C_HandleTypeDef h;
 I2C_TypeDef regs;
 uint32_t control[64];
 uint8_t buffer[4096];
 DMA_HandleTypeDef dma[2];
 DMA_Channel_TypeDef dmaRegs[2];
 DMA_QListTypeDef queue[2];
 DMA_NodeTypeDef node[2];
 uint32_t settings[2][16];
 uint32_t trace[1024],dmaTrace[1024];
};
#if defined(__arm__) || defined(__thumb__)
#define CI2C_THREAD_LOCAL
#else
#define CI2C_THREAD_LOCAL _Thread_local
#endif
extern CI2C_THREAD_LOCAL CI2CState *CI2C_Active;
uint32_t CI2C_Tick(void);
HAL_StatusTypeDef CI2C_DMAStart(DMA_HandleTypeDef *,uint32_t,uint32_t,uint32_t);
HAL_StatusTypeDef CI2C_DMAList(DMA_HandleTypeDef *);
HAL_StatusTypeDef CI2C_DMAAbortIT(DMA_HandleTypeDef *);
uint32_t CI2C_DMAFIFO(DMA_HandleTypeDef *);
uint32_t CI2C0_Run(CI2CState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CI2C0_GetWord(CI2CState *,uint32_t);
void CI2C0_SetWord(CI2CState *,uint32_t,uint32_t);
uint32_t CI2C0_GetDMA(CI2CState *,uint32_t,uint32_t);
void CI2C0_SetDMA(CI2CState *,uint32_t,uint32_t,uint32_t);
uint32_t CI2C1_Run(CI2CState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CI2C1_GetWord(CI2CState *,uint32_t);
void CI2C1_SetWord(CI2CState *,uint32_t,uint32_t);
uint32_t CI2C1_GetDMA(CI2CState *,uint32_t,uint32_t);
void CI2C1_SetDMA(CI2CState *,uint32_t,uint32_t,uint32_t);
#endif
