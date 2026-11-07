#ifndef C_CORDIC_INTERNAL_H
#define C_CORDIC_INTERNAL_H
#include "include/CCORDICReference.h"
extern _Thread_local CCORDICState *CCORDIC_Active;
uint32_t CCORDIC_ReadAddress(volatile uint32_t *);
void CCORDIC_WriteAddress(volatile uint32_t *,uint32_t);
void CCORDIC_DispatchCallback(const void *,uint32_t,uint32_t);
HAL_StatusTypeDef CCORDIC_DMAStart(DMA_HandleTypeDef *,uint32_t,uint32_t,uint32_t);
#define CCORDIC_DECLARE(v,h) \
uint32_t v##_RunInternal(h *,CCORDICOperation,uint32_t,uint32_t,uint32_t,uint32_t); \
uint32_t v##_GetWordInternal(const h *,uint32_t); \
void v##_SetWordInternal(h *,uint32_t,uint32_t); \
uint32_t v##_GetCallbackInternal(const h *,uint32_t); \
void v##_SetCallbackInternal(h *,uint32_t,uint32_t); \
uint32_t v##_GetDMACallbackInternal(const DMA_HandleTypeDef *,uint32_t); \
void v##_SetDMACallbackInternal(DMA_HandleTypeDef *,uint32_t,uint32_t); \
void v##_InvokeDMAInternal(DMA_HandleTypeDef *,uint32_t)
CCORDIC_DECLARE(CCORDIC0,CCORDIC0Handle);
CCORDIC_DECLARE(CCORDIC1,CCORDIC1Handle);
#endif
