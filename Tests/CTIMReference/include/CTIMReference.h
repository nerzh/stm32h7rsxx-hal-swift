#ifndef CTIM_REFERENCE_H
#define CTIM_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CTIMState CTIMState;
size_t CTIM_Size(void);
void CTIM_Reset(CTIMState *,uint32_t);
void CTIM_Activate(CTIMState *);
uint32_t CTIM_Get(CTIMState *,uint32_t,uint32_t);
void CTIM_Set(CTIMState *,uint32_t,uint32_t,uint32_t);
uint32_t *CTIM_Buffer(CTIMState *,uint32_t);
uintptr_t CTIM_Callback(uint32_t,uint32_t);
uintptr_t CTIM_GetCallback(CTIMState *,uint32_t);
void CTIM_SetCallback(CTIMState *,uint32_t,uintptr_t);
uintptr_t CTIM_DMAContext(CTIMState *,uint32_t);
uint32_t CTIM_AttachedDMA(CTIMState *,uint32_t);
void CTIM_AttachDMA(CTIMState *,uint32_t,uint32_t);
uint32_t CTIM_GetDMA(CTIMState *,uint32_t,uint32_t);
void CTIM_SetDMA(CTIMState *,uint32_t,uint32_t,uint32_t);
uint32_t CTIM_GetDMACallback(CTIMState *,uint32_t,uint32_t);
void CTIM_SetDMACallback(CTIMState *,uint32_t,uint32_t,uint32_t);
uint32_t CTIM_TickFor(CTIMState *);
uint32_t CTIM_ReadRegister(CTIMState *,uint32_t);
void CTIM_WriteRegister(CTIMState *,uint32_t,uint32_t);
uint32_t CTIM_RecordDMA(CTIMState *,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CTIM_Run(CTIMState *,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CTIM_Compare(CTIMState *,CTIMState *);
uint32_t CTIM_Constant(uint32_t);
#endif
