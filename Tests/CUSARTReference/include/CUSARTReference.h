#ifndef CUSART_REFERENCE_H
#define CUSART_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CUSARTState CUSARTState;
size_t CUSART_Size(void);
void CUSART_Reset(CUSARTState *,uint32_t);
uint32_t CUSART_Get(CUSARTState *,uint32_t,uint32_t);
void CUSART_Set(CUSARTState *,uint32_t,uint32_t,uint32_t);
void *CUSART_Buffer(CUSARTState *,uint32_t);
void *CUSART_GetPointer(CUSARTState *,uint32_t);
void CUSART_SetPointer(CUSARTState *,uint32_t,void *);
uint32_t CUSART_Run(CUSARTState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CUSART_TickFor(CUSARTState *);
uint32_t CUSART_GetCallback(CUSARTState *,uint32_t);
void CUSART_SetCallback(CUSARTState *,uint32_t,uint32_t);
void CUSART_Callback(CUSARTState *,uint32_t,uint32_t);
uint32_t CUSART_GetDMACallback(CUSARTState *,uint32_t,uint32_t);
void CUSART_SetDMACallback(CUSARTState *,uint32_t,uint32_t,uint32_t);
uint32_t CUSART_DMAAction(CUSARTState *,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CUSART_Normalize(CUSARTState *,uint32_t);
uint32_t CUSART_Constant(uint32_t);
#endif
