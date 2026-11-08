#ifndef CSMARTCARD_INTERNAL_H
#define CSMARTCARD_INTERNAL_H
#include "SMARTCARDDefinitions.h"
#include "include/CSMARTCARDReference.h"
#include <assert.h>
struct CSMARTCARDState {
    SMARTCARD_HandleTypeDef h;
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
extern _Thread_local CSMARTCARDState *CSMARTCARD_Active;
USART_TypeDef *CSMARTCARD_Instance(uint32_t);
uint32_t CSMARTCARD_Tick(void);
HAL_StatusTypeDef CSMARTCARD_DMAStart(DMA_HandleTypeDef *,uint32_t,uint32_t,uint32_t);
HAL_StatusTypeDef CSMARTCARD_DMAList(DMA_HandleTypeDef *);
HAL_StatusTypeDef CSMARTCARD_DMAAbort(DMA_HandleTypeDef *);
HAL_StatusTypeDef CSMARTCARD_DMAAbortIT(DMA_HandleTypeDef *);
HAL_StatusTypeDef CSMARTCARD_DMASuspend(DMA_HandleTypeDef *);
HAL_StatusTypeDef CSMARTCARD_DMAResume(DMA_HandleTypeDef *);
pSMARTCARD_CallbackTypeDef CSMARTCARD_CallbackPointer(uint32_t,uint32_t);
#endif
