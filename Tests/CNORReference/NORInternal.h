#ifndef CNOR_INTERNAL_H
#define CNOR_INTERNAL_H
#include "NORDefinitions.h"
#include "../CFMCReference/FMCInternal.h"
#include "include/CNORReference.h"
struct CNORState {
NOR_HandleTypeDef h;
CFMCState fmc;
FMC_NORSRAM_TimingTypeDef timing[2];
NOR_IDTypeDef id;
NOR_CFITypeDef cfi;
uint32_t control[32], script[256], trace[2048][4], sharedWidth;
uint16_t buffer[256];
uint32_t *shared;
};
void CNOR_Trace(CNORState *,uint32_t,uint32_t,uint32_t);
CNORState *CNOR_Active(void);
#endif
