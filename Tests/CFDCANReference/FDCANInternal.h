#ifndef CFDCAN_INTERNAL_H
#define CFDCAN_INTERNAL_H
#include "FDCANDefinitions.h"
#include "include/CFDCANReference.h"
struct CFDCANState {
 FDCAN_GlobalTypeDef regs[2]; FDCAN_Config_TypeDef common; FDCAN_HandleTypeDef h;
 uint32_t ram[448],params[7][20],control[8],meta[5],trace[32][8]; uint8_t data[2][80];
};
void *CFDCAN_CallbackPointer(uint32_t id,uint32_t token);
#endif
