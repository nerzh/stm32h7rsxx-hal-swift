#ifndef CSRAM_INTERNAL_H
#define CSRAM_INTERNAL_H
#include "SRAMDefinitions.h"
#include "../CFMCReference/FMCInternal.h"
#include "include/CSRAMReference.h"
typedef struct { DMA_HandleTypeDef h; CSRAMState *owner; uint32_t index, meta[4]; } CSRAMDMA;
struct CSRAMState {
SRAM_HandleTypeDef h;
CFMCState fmc;
FMC_NORSRAM_TimingTypeDef timing[2];
FMC_SDRAM_CommandTypeDef command;
CSRAMDMA dma[2];
DMA_Channel_TypeDef channels[2];
DMA_QListTypeDef queues[2];
DMA_NodeTypeDef nodes[2];
uint32_t control[32],buffer[256],memory[256],script[256],trace[2048][4];
};
void CSRAM_Trace(CSRAMState *,uint32_t,uint32_t,uint32_t);
CSRAMState *CSRAM_Active(void);
#endif
