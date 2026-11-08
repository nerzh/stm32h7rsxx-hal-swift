#ifndef CIRDA_INTERNAL_H
#define CIRDA_INTERNAL_H
#include "IRDADefinitions.h"
#include "include/CIRDAReference.h"
#include <assert.h>
struct CIRDAState {
    IRDA_HandleTypeDef h;
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
extern _Thread_local CIRDAState *CIRDA_Active;
USART_TypeDef *CIRDA_Instance(uint32_t);
uint32_t CIRDA_Tick(void);
HAL_StatusTypeDef CIRDA_DMAStart(DMA_HandleTypeDef *,uint32_t,uint32_t,uint32_t);
HAL_StatusTypeDef CIRDA_DMAList(DMA_HandleTypeDef *);
HAL_StatusTypeDef CIRDA_DMAAbort(DMA_HandleTypeDef *);
HAL_StatusTypeDef CIRDA_DMAAbortIT(DMA_HandleTypeDef *);
HAL_StatusTypeDef CIRDA_DMASuspend(DMA_HandleTypeDef *);
HAL_StatusTypeDef CIRDA_DMAResume(DMA_HandleTypeDef *);
pIRDA_CallbackTypeDef CIRDA_CallbackPointer(uint32_t,uint32_t);
#endif
