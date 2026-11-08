#ifndef CNAND_INTERNAL_H
#define CNAND_INTERNAL_H
#include "NANDDefinitions.h"
#include "../CFMCReference/FMCInternal.h"
#include "include/CNANDReference.h"
#ifndef CNAND_TRACE_CAPACITY
#define CNAND_TRACE_CAPACITY 32768
#endif
struct CNANDState {
NAND_HandleTypeDef h;
CFMCState fmc;
FMC_NAND_PCC_TimingTypeDef timing[2];
NAND_DeviceConfigTypeDef device;
NAND_AddressTypeDef address;
NAND_IDTypeDef id;
uint32_t control[32], buffer[4096], script[256], trace[CNAND_TRACE_CAPACITY][4], output;
};
void CNAND_Trace(CNANDState *,uint32_t,uint32_t,uint32_t);
CNANDState *CNAND_Active(void);
#endif
