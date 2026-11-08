#ifndef CSPI_INTERNAL_H
#define CSPI_INTERNAL_H
#include "SPIDefinitions.h"
#include "include/CSPIReference.h"
#include <assert.h>
#include <string.h>
struct CSPIState {
 SPI_HandleTypeDef h;
 SPI_TypeDef regs[6];
 uint32_t global[38];
 uint32_t control[64];
 uint32_t buffers[2][1024];
 DMA_HandleTypeDef dma[2];DMA_Channel_TypeDef dmaRegs[2];DMA_QListTypeDef queue[2];DMA_NodeTypeDef node[2];
 uint32_t settings[2][16];uint32_t trace[1024],dmaTrace[1024],access[2048];
};
#if defined(__arm__) || defined(__thumb__)
#define CSPI_THREAD_LOCAL
#else
#define CSPI_THREAD_LOCAL _Thread_local
#endif
extern CSPI_THREAD_LOCAL CSPIState *CSPI_Active;
uint32_t CSPI_Tick(void);uint32_t CSPI_Clock(uint32_t);
HAL_StatusTypeDef CSPI_DMAStart(DMA_HandleTypeDef *,uint32_t,uint32_t,uint32_t);
HAL_StatusTypeDef CSPI_DMAList(DMA_HandleTypeDef *);
HAL_StatusTypeDef CSPI_DMAAbort(DMA_HandleTypeDef *);
HAL_StatusTypeDef CSPI_DMAAbortIT(DMA_HandleTypeDef *);
uint32_t CSPI0_Run(CSPIState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSPI0_GetWord(CSPIState *,uint32_t);
void CSPI0_SetWord(CSPIState *,uint32_t,uint32_t);
uint32_t CSPI0_GetDMA(CSPIState *,uint32_t,uint32_t);
void CSPI0_SetDMA(CSPIState *,uint32_t,uint32_t,uint32_t);
uint32_t CSPI1_Run(CSPIState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSPI1_GetWord(CSPIState *,uint32_t);
void CSPI1_SetWord(CSPIState *,uint32_t,uint32_t);
uint32_t CSPI1_GetDMA(CSPIState *,uint32_t,uint32_t);
void CSPI1_SetDMA(CSPIState *,uint32_t,uint32_t,uint32_t);
uint32_t CSPI2_Run(CSPIState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSPI2_GetWord(CSPIState *,uint32_t);
void CSPI2_SetWord(CSPIState *,uint32_t,uint32_t);
uint32_t CSPI2_GetDMA(CSPIState *,uint32_t,uint32_t);
void CSPI2_SetDMA(CSPIState *,uint32_t,uint32_t,uint32_t);
uint32_t CSPI3_Run(CSPIState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSPI3_GetWord(CSPIState *,uint32_t);
void CSPI3_SetWord(CSPIState *,uint32_t,uint32_t);
uint32_t CSPI3_GetDMA(CSPIState *,uint32_t,uint32_t);
void CSPI3_SetDMA(CSPIState *,uint32_t,uint32_t,uint32_t);
uint32_t CSPI_ReadAddress(const volatile void *,uint32_t);
void CSPI_WriteAddress(volatile void *,uint32_t,uint32_t);
#endif
