#ifndef CNOR_REFERENCE_H
#define CNOR_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CNORState CNORState;
size_t CNOR_Size(void);
void CNOR_Reset(CNORState *);
void CNOR_Activate(CNORState *);
uint32_t CNOR_Get(CNORState *,uint32_t,uint32_t);
void CNOR_Set(CNORState *,uint32_t,uint32_t,uint32_t);
uint32_t CNOR_ReadRegister(CNORState *,uint32_t);
void CNOR_WriteRegister(CNORState *,uint32_t,uint32_t);
uint32_t CNOR_TickFor(CNORState *);
uint32_t CNOR_ReadMemory(CNORState *,uint32_t,uint32_t);
void CNOR_WriteMemory(CNORState *,uint32_t,uint32_t,uint32_t);
void CNOR_Barrier(CNORState *);
void *CNOR_Buffer(CNORState *);
void *CNOR_Value(CNORState *,uint32_t);
uint32_t CNOR_ReadShared(CNORState *);
void CNOR_WriteShared(CNORState *,uint32_t);
void CNOR_Share(CNORState *,CNORState *);
void CNOR_Wait(CNORState *,uint32_t);
void *CNOR_Callback(uint32_t,uint32_t);
void *CNOR_GetCallback(CNORState *,uint32_t);
void CNOR_SetCallback(CNORState *,uint32_t,void *);
void CNOR_CallbackEvent(CNORState *,uint32_t,uint32_t);
uint32_t CNOR_Run(CNORState *,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CNOR_Compare(CNORState *,CNORState *);
uint32_t CNOR_Constant(uint32_t);
#endif
