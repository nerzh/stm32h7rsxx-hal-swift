#ifndef CI3C_REFERENCE_H
#define CI3C_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CI3CState CI3CState;
size_t CI3C_Size(void);
void CI3C_Reset(CI3CState *,uint32_t);
void CI3C_Activate(CI3CState *);
uint32_t CI3C_Get(CI3CState *,uint32_t,uint32_t);
void CI3C_Set(CI3CState *,uint32_t,uint32_t,uint32_t);
uint8_t *CI3C_Buffer(CI3CState *,uint32_t);
uint32_t CI3C_Normalize(CI3CState *,uintptr_t);
uintptr_t CI3C_Decode(CI3CState *,uint32_t);
uintptr_t CI3C_GetCallback(CI3CState *,uint32_t);
void CI3C_SetCallback(CI3CState *,uint32_t,uintptr_t);
uintptr_t CI3C_Callback(uint32_t,uint32_t);
uint32_t CI3C_GetPointer(CI3CState *,uint32_t);
void CI3C_SetPointer(CI3CState *,uint32_t,uint32_t);
uint32_t CI3C_Run(CI3CState *,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CI3C_TickFor(CI3CState *);
uint32_t CI3C_Read(CI3CState *,uint32_t);
void CI3C_Write(CI3CState *,uint32_t,uint32_t);
uint32_t CI3C_RecordDMA(CI3CState *,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CI3C_Constant(uint32_t);
uint32_t CI3C_Compare(CI3CState *,CI3CState *);
#endif
