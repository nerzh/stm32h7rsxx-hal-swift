#ifndef CPKA_INTERNAL_H
#define CPKA_INTERNAL_H
#include "include/CPKAReference.h"
#include "PKADefinitions.h"
#include <assert.h>
struct CPKAState {
 PKA_TypeDef regs; PKA_HandleTypeDef h;
 uint32_t params[20][20],buffers[20][128],control[12];
 uint32_t tick,tickCalls,mode,traceCount,trace[32][12];
};
extern CPKAState *CPKA_Active;
pPKA_CallbackTypeDef CPKA_CallbackPointer(uint32_t,uint32_t);
uint32_t CPKA0_Run(CPKAState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CPKA1_Run(CPKAState *,uint32_t,uint32_t,uint32_t,uint32_t);
void CPKA_DefaultMSP(CPKAState *);
#endif
