#ifndef CI3C_INTERNAL_H
#define CI3C_INTERNAL_H
#include "I3CDefinitions.h"
#include "include/CI3CReference.h"
#include <assert.h>
#include <string.h>
struct CI3CState {
I3C_HandleTypeDef h;
I3C_TypeDef regs;
uint32_t control[64], buffers[8][256];
DMA_HandleTypeDef dma[3];
DMA_Channel_TypeDef dmaRegs[3];
uint32_t settings[3][16];
uint32_t trace[1024], dmaTrace[1024], accessTrace[4096];
LL_I3C_CtrlBusConfTypeDef controllerBus;
LL_I3C_TgtBusConfTypeDef targetBus;
I3C_FifoConfTypeDef fifo;
I3C_CtrlConfTypeDef controller;
I3C_TgtConfTypeDef target;
I3C_DeviceConfTypeDef devices[4];
I3C_CCCInfoTypeDef cccInfo;
I3C_ENTDAAPayloadTypeDef payload;
I3C_CCCTypeDef ccc[8];
I3C_PrivateTypeDef private[8];
I3C_XferTypeDef transfer;
uint64_t outputPayload;
uint32_t outputReset;
uint8_t outputAddress;
};
#if defined(__arm__) || defined(__thumb__)
#define CI3C_THREAD_LOCAL
#else
#define CI3C_THREAD_LOCAL _Thread_local
#endif
extern CI3C_THREAD_LOCAL CI3CState *CI3C_Active;
uint32_t CI3C_Tick(void);
HAL_StatusTypeDef CI3C_DMAStart(DMA_HandleTypeDef *,uint32_t,uint32_t,uint32_t);
HAL_StatusTypeDef CI3C_DMAAbort(DMA_HandleTypeDef *);
HAL_StatusTypeDef CI3C_DMAAbortIT(DMA_HandleTypeDef *);
uint32_t CI3C_DMACounter(DMA_HandleTypeDef *);
uint32_t CI3C_DMAFIFO(DMA_HandleTypeDef *);
uint32_t CI3C_DMAState(DMA_HandleTypeDef *);
uint32_t CI3C0_Run(CI3CState *,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CI3C0_GetWord(CI3CState *,uint32_t);
void CI3C0_SetWord(CI3CState *,uint32_t,uint32_t);
uint32_t CI3C0_GetDMA(CI3CState *,uint32_t,uint32_t);
void CI3C0_SetDMA(CI3CState *,uint32_t,uint32_t,uint32_t);
uint32_t CI3C1_Run(CI3CState *,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CI3C1_GetWord(CI3CState *,uint32_t);
void CI3C1_SetWord(CI3CState *,uint32_t,uint32_t);
uint32_t CI3C1_GetDMA(CI3CState *,uint32_t,uint32_t);
void CI3C1_SetDMA(CI3CState *,uint32_t,uint32_t,uint32_t);
#endif
