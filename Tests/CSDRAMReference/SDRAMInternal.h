#ifndef CSDRAM_INTERNAL_H
#define CSDRAM_INTERNAL_H
#include "SDRAMDefinitions.h"
#include "../CFMCReference/FMCInternal.h"
#include "include/CSDRAMReference.h"
typedef struct { DMA_HandleTypeDef h; CSDRAMState *owner; uint32_t index, meta[4]; } CSDRAMDMA;
struct CSDRAMState {
SDRAM_HandleTypeDef h;
CFMCState fmc;
FMC_SDRAM_TimingTypeDef timing[2];
FMC_SDRAM_CommandTypeDef command;
CSDRAMDMA dma[2];
DMA_Channel_TypeDef channels[2];
DMA_QListTypeDef queues[2];
DMA_NodeTypeDef nodes[2];
uint32_t control[32],buffer[256],memory[256],script[256],trace[2048][4];
};
void CSDRAM_Trace(CSDRAMState *,uint32_t,uint32_t,uint32_t);
CSDRAMState *CSDRAM_Active(void);
#endif
