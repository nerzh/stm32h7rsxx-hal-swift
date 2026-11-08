#ifndef CSDIO_REFERENCE_H
#define CSDIO_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CSDIOState CSDIOState;
size_t CSDIO_Size(void);
void CSDIO_Reset(CSDIOState *,uint32_t);
void CSDIO_Activate(CSDIOState *);
uint32_t CSDIO_Get(CSDIOState *,uint32_t,uint32_t);
void CSDIO_Set(CSDIOState *,uint32_t,uint32_t,uint32_t);
uint32_t CSDIO_Run(CSDIOState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSDIO_Compare(CSDIOState *,CSDIOState *);
uint32_t CSDIO_Read(CSDIOState *,uint32_t);
void CSDIO_Write(CSDIOState *,uint32_t,uint32_t);
uint32_t CSDIO_ReadMemory(CSDIOState *,uint32_t);
void CSDIO_WriteMemory(CSDIOState *,uint32_t,uint32_t);
uint32_t CSDIO_ClockFor(CSDIOState *);
uint32_t CSDIO_TickFor(CSDIOState *);
uint32_t CSDIO_FrequencyFor(CSDIOState *,uint32_t);
void CSDIO_DelayFor(CSDIOState *,uint32_t);
uint8_t *CSDIO_Buffer(CSDIOState *,uint32_t);
uintptr_t CSDIO_GetPointer(CSDIOState *,uint32_t);
void CSDIO_SetPointer(CSDIOState *,uint32_t,uintptr_t);
uintptr_t CSDIO_GetCallback(CSDIOState *,uint32_t);
void CSDIO_SetCallback(CSDIOState *,uint32_t,uintptr_t);
uintptr_t CSDIO_Callback(uint32_t,uint32_t);
uint32_t CSDIO_Constant(uint32_t);
uintptr_t CSDIO_DefaultIdentify(uint32_t);
uint32_t CSDIO_GetHandleRaw(CSDIOState *,uint32_t);
#endif
