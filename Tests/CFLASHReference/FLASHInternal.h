#ifndef C_FLASH_INTERNAL_H
#define C_FLASH_INTERNAL_H
#include "include/CFLASHReference.h"
#if defined(CFLASH_REFERENCE_ARM)
extern CFLASHState *CFLASH_Active;
#else
extern _Thread_local CFLASHState *CFLASH_Active;
#endif
uint32_t CFLASH_ReadAddress(volatile uint32_t *);
void CFLASH_WriteAddress(volatile uint32_t *, uint32_t);
void CFLASH_DispatchCallback(uint32_t id, uint32_t argument);
#endif
