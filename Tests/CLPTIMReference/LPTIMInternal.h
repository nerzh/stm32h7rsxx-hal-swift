#ifndef CLPTIM_INTERNAL_H
#define CLPTIM_INTERNAL_H
#include "include/CLPTIMReference.h"
#include "stm32h7rsxx_hal_def.h"
#include <assert.h>
#include <string.h>
#define LPTIM1 (&CLPTIM_Active->registers[0])
#define LPTIM2 (&CLPTIM_Active->registers[1])
#define LPTIM3 (&CLPTIM_Active->registers[2])
#define LPTIM4 (&CLPTIM_Active->registers[3])
#define LPTIM5 (&CLPTIM_Active->registers[4])
#define USE_HAL_LPTIM_REGISTER_CALLBACKS 1
#include "Upstream/LPTIMBits.h"
#include "Upstream/stm32h7rsxx_hal_lptim.h"
struct CLPTIMState {
 LPTIM_TypeDef registers[5];
 LPTIM_HandleTypeDef handle;
 LPTIM_OC_ConfigTypeDef oc;
 LPTIM_IC_ConfigTypeDef ic;
 struct { uint32_t IMR2; } exti;
 DMA_HandleTypeDef dma[3]; DMA_QListTypeDef queues[3]; DMA_NodeTypeDef nodes[3];
 uint32_t mode,instance,control[10],traceCount,trace[32][96];
};
extern CLPTIMState *CLPTIM_Active;
uint32_t CLPTIM0_Run(CLPTIMState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CLPTIM1_Run(CLPTIMState *,uint32_t,uint32_t,uint32_t,uint32_t);
void (*CLPTIM0_DMACallback(uint32_t))(DMA_HandleTypeDef *);
void (*CLPTIM1_DMACallback(uint32_t))(DMA_HandleTypeDef *);
pLPTIM_CallbackTypeDef CLPTIM_CallbackPointer(uint32_t,uint32_t);
#endif
