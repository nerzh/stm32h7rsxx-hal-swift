#ifndef CI2C_REFERENCE_H
#define CI2C_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CI2CState CI2CState;
size_t CI2C_Size(void);
void CI2C_Reset(CI2CState *,uint32_t);
uint32_t CI2C_Get(CI2CState *,uint32_t,uint32_t);
void CI2C_Set(CI2CState *,uint32_t,uint32_t,uint32_t);
uint8_t *CI2C_Buffer(CI2CState *);
uint8_t *CI2C_GetBuffer(CI2CState *);
void CI2C_SetBuffer(CI2CState *,uint8_t *);
uint32_t CI2C_TickFor(CI2CState *);
uint32_t CI2C_Run(CI2CState *,uint32_t,uint32_t,uint32_t,uint32_t);
uintptr_t CI2C_GetCallback(CI2CState *,uint32_t);
void CI2C_SetCallback(CI2CState *,uint32_t,uintptr_t);
uintptr_t CI2C_Callback(uint32_t,uint32_t);
uint32_t CI2C_Constant(uint32_t);
uint32_t CI2C_Compare(CI2CState *,CI2CState *);
uint32_t CI2C_RecordDMA(CI2CState *,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
#endif
