#ifndef CIRDA_REFERENCE_H
#define CIRDA_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CIRDAState CIRDAState;
size_t CIRDA_Size(void);
void CIRDA_Reset(CIRDAState *,uint32_t);
uint32_t CIRDA_Get(CIRDAState *,uint32_t,uint32_t);
void CIRDA_Set(CIRDAState *,uint32_t,uint32_t,uint32_t);
void *CIRDA_Buffer(CIRDAState *,uint32_t);
void *CIRDA_GetPointer(CIRDAState *,uint32_t);
void CIRDA_SetPointer(CIRDAState *,uint32_t,void *);
uint32_t CIRDA_Run(CIRDAState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CIRDA_TickFor(CIRDAState *);
uint32_t CIRDA_GetCallback(CIRDAState *,uint32_t);
void CIRDA_SetCallback(CIRDAState *,uint32_t,uint32_t);
void CIRDA_Callback(CIRDAState *,uint32_t,uint32_t);
uint32_t CIRDA_GetDMACallback(CIRDAState *,uint32_t,uint32_t);
void CIRDA_SetDMACallback(CIRDAState *,uint32_t,uint32_t,uint32_t);
uint32_t CIRDA_DMAAction(CIRDAState *,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CIRDA_Normalize(CIRDAState *,uint32_t);
uint32_t CIRDA_Constant(uint32_t);
#endif
