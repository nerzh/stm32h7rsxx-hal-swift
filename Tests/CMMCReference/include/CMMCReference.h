#ifndef CMMC_REFERENCE_H
#define CMMC_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CMMCState CMMCState;
size_t CMMC_Size(void);
void CMMC_Reset(CMMCState *,uint32_t);
void CMMC_Activate(CMMCState *);
uint32_t CMMC_Get(CMMCState *,uint32_t,uint32_t);
void CMMC_Set(CMMCState *,uint32_t,uint32_t,uint32_t);
uint32_t CMMC_Run(CMMCState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CMMC_Compare(CMMCState *,CMMCState *);
uint32_t CMMC_Read(CMMCState *,uint32_t);
void CMMC_Write(CMMCState *,uint32_t,uint32_t);
uint32_t CMMC_ReadMemory(CMMCState *,uint32_t);
void CMMC_WriteMemory(CMMCState *,uint32_t,uint32_t);
uint32_t CMMC_ClockFor(CMMCState *);
uint32_t CMMC_TickFor(CMMCState *);
uint32_t CMMC_FrequencyFor(CMMCState *,uint32_t);
void CMMC_DelayFor(CMMCState *,uint32_t);
uint8_t *CMMC_Buffer(CMMCState *,uint32_t);
uintptr_t CMMC_GetPointer(CMMCState *,uint32_t);
void CMMC_SetPointer(CMMCState *,uint32_t,uintptr_t);
uint32_t *CMMC_ExtendedCSD(CMMCState *);
uint32_t *CMMC_Output(CMMCState *,uint32_t);
uintptr_t CMMC_GetCallback(CMMCState *,uint32_t);
void CMMC_SetCallback(CMMCState *,uint32_t,uintptr_t);
uintptr_t CMMC_Callback(uint32_t,uint32_t);
uint32_t CMMC_Constant(uint32_t);
#endif
