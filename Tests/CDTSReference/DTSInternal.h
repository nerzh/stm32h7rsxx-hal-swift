#ifndef C_DTS_INTERNAL_H
#define C_DTS_INTERNAL_H
#include "include/CDTSReference.h"
extern _Thread_local CDTSState *CDTS_Active;
uint32_t CDTS_ReadAddress(volatile uint32_t *);
void CDTS_WriteAddress(volatile uint32_t *, uint32_t);
void CDTS_DispatchCallback(uint32_t id, uint32_t implementation);
#define CDTS_DECLARE_VARIANT(v,h) \
uint32_t v##_RunInternal(h *,CDTSOperation,uint32_t,uint32_t); \
uint32_t v##_GetWordInternal(const h *,uint32_t); \
void v##_SetWordInternal(h *,uint32_t,uint32_t); \
uint32_t v##_GetCallbackInternal(const h *,uint32_t); \
void v##_SetCallbackInternal(h *,uint32_t,uint32_t)
CDTS_DECLARE_VARIANT(CDTS0,CDTS0Handle);
CDTS_DECLARE_VARIANT(CDTS1,CDTS1Handle);
#endif
