#ifndef CSMARTCARD_REFERENCE_H
#define CSMARTCARD_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CSMARTCARDState CSMARTCARDState;
size_t CSMARTCARD_Size(void);
void CSMARTCARD_Reset(CSMARTCARDState *,uint32_t);
uint32_t CSMARTCARD_Get(CSMARTCARDState *,uint32_t,uint32_t);
void CSMARTCARD_Set(CSMARTCARDState *,uint32_t,uint32_t,uint32_t);
void *CSMARTCARD_Buffer(CSMARTCARDState *,uint32_t);
void *CSMARTCARD_GetPointer(CSMARTCARDState *,uint32_t);
void CSMARTCARD_SetPointer(CSMARTCARDState *,uint32_t,void *);
uint32_t CSMARTCARD_Run(CSMARTCARDState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSMARTCARD_TickFor(CSMARTCARDState *);
uint32_t CSMARTCARD_GetCallback(CSMARTCARDState *,uint32_t);
void CSMARTCARD_SetCallback(CSMARTCARDState *,uint32_t,uint32_t);
void CSMARTCARD_Callback(CSMARTCARDState *,uint32_t,uint32_t);
uint32_t CSMARTCARD_GetDMACallback(CSMARTCARDState *,uint32_t,uint32_t);
void CSMARTCARD_SetDMACallback(CSMARTCARDState *,uint32_t,uint32_t,uint32_t);
uint32_t CSMARTCARD_DMAAction(CSMARTCARDState *,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSMARTCARD_Normalize(CSMARTCARDState *,uint32_t);
uint32_t CSMARTCARD_Constant(uint32_t);
#endif
