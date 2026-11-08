#ifndef CNAND_REFERENCE_H
#define CNAND_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CNANDState CNANDState;
size_t CNAND_Size(void);
void CNAND_Reset(CNANDState *);
void CNAND_Activate(CNANDState *);
uint32_t CNAND_Get(CNANDState *,uint32_t,uint32_t);
void CNAND_Set(CNANDState *,uint32_t,uint32_t,uint32_t);
uint32_t CNAND_ReadRegister(CNANDState *,uint32_t);
void CNAND_WriteRegister(CNANDState *,uint32_t,uint32_t);
uint32_t CNAND_TickFor(CNANDState *);
uint32_t CNAND_ReadMemory(CNANDState *,uint32_t,uint32_t);
void CNAND_WriteMemory(CNANDState *,uint32_t,uint32_t,uint32_t);
void CNAND_Barrier(CNANDState *);
void *CNAND_Buffer(CNANDState *);
void *CNAND_Value(CNANDState *,uint32_t);
void *CNAND_Callback(uint32_t,uint32_t);
void *CNAND_GetCallback(CNANDState *,uint32_t);
void CNAND_SetCallback(CNANDState *,uint32_t,void *);
void CNAND_CallbackEvent(CNANDState *,uint32_t,uint32_t);
uint32_t CNAND_Run(CNANDState *,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CNAND_Compare(CNANDState *,CNANDState *);
uint32_t CNAND_Constant(uint32_t);
#endif
