#ifndef CUSART_INTERNAL_H
#define CUSART_INTERNAL_H
#include "USARTDefinitions.h"
#include "include/CUSARTReference.h"
#include <assert.h>
struct CUSARTState {
    USART_HandleTypeDef h;
    USART_TypeDef regs;
    uint32_t control[32];
    uint32_t buffers[2][128];
    DMA_HandleTypeDef dma[2];
    DMA_Channel_TypeDef dmaRegs[2];
    DMA_QListTypeDef queue[2];
    DMA_NodeTypeDef node[2];
    uint32_t settings[2][16];
    uint32_t callbackTrace[1024];
    uint32_t dmaTrace[1024];
};
extern _Thread_local CUSARTState *CUSART_Active;
USART_TypeDef *CUSART_Instance(uint32_t);
uint32_t CUSART_Tick(void);
HAL_StatusTypeDef CUSART_DMAStart(DMA_HandleTypeDef *,uint32_t,uint32_t,uint32_t);
HAL_StatusTypeDef CUSART_DMAList(DMA_HandleTypeDef *);
HAL_StatusTypeDef CUSART_DMAAbort(DMA_HandleTypeDef *);
HAL_StatusTypeDef CUSART_DMAAbortIT(DMA_HandleTypeDef *);
HAL_StatusTypeDef CUSART_DMASuspend(DMA_HandleTypeDef *);
HAL_StatusTypeDef CUSART_DMAResume(DMA_HandleTypeDef *);
pUSART_CallbackTypeDef CUSART_CallbackPointer(uint32_t,uint32_t);
#endif
