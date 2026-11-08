#ifndef CFMC_REFERENCE_H
#define CFMC_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CFMCState CFMCState;
size_t CFMC_Size(void);
void CFMC_Reset(CFMCState *);
void CFMC_Activate(CFMCState *);
uint32_t CFMC_Get(CFMCState *,uint32_t,uint32_t);
void CFMC_Set(CFMCState *,uint32_t,uint32_t,uint32_t);
uint32_t CFMC_Read(CFMCState *,uint32_t);
void CFMC_Write(CFMCState *,uint32_t,uint32_t);
uint32_t CFMC_TickFor(CFMCState *);
uint32_t *CFMC_Output(CFMCState *);
uint32_t CFMC_Run(CFMCState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CFMC_Compare(CFMCState *,CFMCState *);
uint32_t CFMC_Constant(uint32_t);
#endif
