#ifndef CADC_INTERNAL_H
#define CADC_INTERNAL_H
#include "include/CADCReference.h"
#include "ADCDefinitions.h"
#include <assert.h>
struct CADCState {
 ADC_TypeDef regs[2]; ADC_Common_TypeDef common; ADC_HandleTypeDef h;
 DMA_HandleTypeDef dma; DMA_QListTypeDef queue; DMA_NodeTypeDef node;
 uint32_t params[3][20],control[16],nodeWidth;
 uint32_t instance,mode,tick,tickCalls,traceCount,calibrationReads,trace[32][16];
};
extern CADCState *CADC_Active;
pADC_CallbackTypeDef CADC_CallbackPointer(uint32_t,uint32_t);
uint32_t CADC0_Run(CADCState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CADC1_Run(CADCState *,uint32_t,uint32_t,uint32_t,uint32_t);
#endif
