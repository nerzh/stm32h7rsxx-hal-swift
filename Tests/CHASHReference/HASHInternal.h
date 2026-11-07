/* Internal namespace and adapter declarations for the C reference. */
#ifndef C_HASH_INTERNAL_H
#define C_HASH_INTERNAL_H
#include "include/CHASHReference.h"
#if defined(__arm__) || defined(__thumb__)
#define CHASH_THREAD_LOCAL
#else
#define CHASH_THREAD_LOCAL _Thread_local
#endif
extern CHASH_THREAD_LOCAL CHASHState *CHASH_Active;
void *CHASH_Handle(const CHASHState *,uint32_t);
uint32_t CHASH_ReadAddress(volatile uint32_t *);
void CHASH_WriteAddress(volatile uint32_t *,uint32_t);
void CHASH_DispatchCallback(const void *,uint32_t,uint32_t);
HAL_StatusTypeDef CHASH_DMAStart(DMA_HandleTypeDef *,uint32_t,uint32_t,uint32_t);
HAL_StatusTypeDef CHASH_DMAListStart(DMA_HandleTypeDef *);
HAL_StatusTypeDef CHASH_DMAAbort(DMA_HandleTypeDef *);
#define CHASH_DECLARE(v,h) \
uint32_t v##_RunInternal(h *,CHASHOperation,uint32_t,uint32_t,uint32_t,uint32_t); \
uint32_t v##_GetWordInternal(const CHASHState *,const h *,uint32_t); \
void v##_SetWordInternal(CHASHState *,h *,uint32_t,uint32_t); \
uint32_t v##_GetCallbackInternal(const h *,uint32_t); \
void v##_SetCallbackInternal(h *,uint32_t,uint32_t); \
uint32_t v##_GetDMACallbackInternal(const DMA_HandleTypeDef *,uint32_t); \
void v##_SetDMACallbackInternal(DMA_HandleTypeDef *,uint32_t,uint32_t); \
void v##_InvokeDMAInternal(DMA_HandleTypeDef *,uint32_t)
CHASH_DECLARE(CHASH00,CHASH00Handle);
CHASH_DECLARE(CHASH01,CHASH01Handle);
CHASH_DECLARE(CHASH10,CHASH10Handle);
CHASH_DECLARE(CHASH11,CHASH11Handle);
#endif
