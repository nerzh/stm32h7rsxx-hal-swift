#ifndef CXSPI_INTERNAL_H
#define CXSPI_INTERNAL_H
#include "XSPIDefinitions.h"
#include "include/CXSPIReference.h"
#include <assert.h>
#include <string.h>
struct CXSPIState {
 XSPI_HandleTypeDef h;
 XSPI_TypeDef regs[2];
 uint32_t global[38];
 uint32_t control[64];
 uint32_t buffers[2][1024];
 DMA_HandleTypeDef dma[2];DMA_Channel_TypeDef dmaRegs[2];DMA_QListTypeDef queue[2];DMA_NodeTypeDef node[2];
 uint32_t settings[2][20];uint32_t trace[1024],dmaTrace[1024],access[2048];
};
#if defined(__arm__) || defined(__thumb__)
#define CXSPI_THREAD_LOCAL
#else
#define CXSPI_THREAD_LOCAL _Thread_local
#endif
extern CXSPI_THREAD_LOCAL CXSPIState *CXSPI_Active;
uint32_t CXSPI_Tick(void);uint32_t CXSPI_Clock(uint32_t);
HAL_StatusTypeDef CXSPI_DMAStart(DMA_HandleTypeDef *,uint32_t,uint32_t,uint32_t);
HAL_StatusTypeDef CXSPI_DMAList(DMA_HandleTypeDef *);
HAL_StatusTypeDef CXSPI_DMAAbort(DMA_HandleTypeDef *);
HAL_StatusTypeDef CXSPI_DMAAbortIT(DMA_HandleTypeDef *);
uint32_t CXSPI0_Run(CXSPIState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CXSPI0_GetWord(CXSPIState *,uint32_t);
void CXSPI0_SetWord(CXSPIState *,uint32_t,uint32_t);
uint32_t CXSPI0_GetDMA(CXSPIState *,uint32_t,uint32_t);
void CXSPI0_SetDMA(CXSPIState *,uint32_t,uint32_t,uint32_t);
uint32_t CXSPI1_Run(CXSPIState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CXSPI1_GetWord(CXSPIState *,uint32_t);
void CXSPI1_SetWord(CXSPIState *,uint32_t,uint32_t);
uint32_t CXSPI1_GetDMA(CXSPIState *,uint32_t,uint32_t);
void CXSPI1_SetDMA(CXSPIState *,uint32_t,uint32_t,uint32_t);
uint32_t CXSPI_ReadAddress(const volatile void *,uint32_t);
void CXSPI_WriteAddress(volatile void *,uint32_t,uint32_t);
#endif
