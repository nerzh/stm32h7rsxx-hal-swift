#ifndef C_UART_INTERNAL_H
#define C_UART_INTERNAL_H
#include "include/CUARTReference.h"
extern _Thread_local CUARTState *CUART_Active;
USART_TypeDef *CUART_InstanceAddress(uint32_t address);
uint32_t CUART_ReadAddress(volatile uint32_t *address);
void CUART_WriteAddress(volatile uint32_t *address, uint32_t value);
uint32_t CUART_ExclusiveLoad(volatile uint32_t *address);
uint32_t CUART_ExclusiveStore(uint32_t value, volatile uint32_t *address);
uint32_t CUART_FindUART(const void *handle);
uint32_t CUART_FindDMA(const DMA_HandleTypeDef *handle);
void CUART_DispatchCallback(const void *handle, uint32_t callbackID, uint32_t implementation, uint32_t position);
HAL_StatusTypeDef CUART_DMAStart(DMA_HandleTypeDef *, uint32_t, uint32_t, uint32_t);
HAL_StatusTypeDef CUART_DMAListStart(DMA_HandleTypeDef *);
HAL_StatusTypeDef CUART_DMAAbortCall(DMA_HandleTypeDef *);
HAL_StatusTypeDef CUART_DMAAbortITCall(DMA_HandleTypeDef *);
HAL_StatusTypeDef CUART_DMASuspendCall(DMA_HandleTypeDef *);
HAL_StatusTypeDef CUART_DMAResumeCall(DMA_HandleTypeDef *);
uint32_t CUART_DMAGetError(DMA_HandleTypeDef *);
#define CUART_DECLARE_VARIANT(v, h) \
uint32_t v##_CallInternal(h *, CUARTOperation, uint32_t, uint32_t, uint32_t, uint32_t); \
uint32_t v##_GetWordInternal(const h *, uint32_t); \
void v##_SetWordInternal(h *, uint32_t, uint32_t); \
uint32_t v##_GetCallbackInternal(const h *, uint32_t); \
void v##_SetCallbackInternal(h *, uint32_t, uint32_t); \
void v##_InvokeDMAInternal(DMA_HandleTypeDef *, uint32_t); \
uint32_t v##_GetDMACallbackInternal(const DMA_HandleTypeDef *, uint32_t); \
void v##_SetDMACallbackInternal(DMA_HandleTypeDef *, uint32_t, uint32_t)
CUART_DECLARE_VARIANT(CUART0, CUART0Handle);
CUART_DECLARE_VARIANT(CUART1, CUART1Handle);
#endif
