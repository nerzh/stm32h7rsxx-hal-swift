#ifndef CSD_REFERENCE_H
#define CSD_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CSDState CSDState;
size_t CSD_Size(void);
void CSD_Reset(CSDState *,uint32_t);
void CSD_Activate(CSDState *);
uint32_t CSD_Get(CSDState *,uint32_t,uint32_t);
void CSD_Set(CSDState *,uint32_t,uint32_t,uint32_t);
uint32_t CSD_Run(CSDState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSD_Compare(CSDState *,CSDState *);
uint32_t CSD_Read(CSDState *,uint32_t);
void CSD_Write(CSDState *,uint32_t,uint32_t);
uint32_t CSD_ReadMemory(CSDState *,uint32_t);
void CSD_WriteMemory(CSDState *,uint32_t,uint32_t);
uint32_t CSD_ClockFor(CSDState *);
uint32_t CSD_TickFor(CSDState *);
uint32_t CSD_FrequencyFor(CSDState *,uint32_t);
void CSD_DelayFor(CSDState *,uint32_t);
uint8_t *CSD_Buffer(CSDState *,uint32_t);
uintptr_t CSD_GetPointer(CSDState *,uint32_t);
void CSD_SetPointer(CSDState *,uint32_t,uintptr_t);
uintptr_t CSD_GetCallback(CSDState *,uint32_t);
void CSD_SetCallback(CSDState *,uint32_t,uintptr_t);
uintptr_t CSD_Callback(uint32_t,uint32_t);
uint32_t CSD_Constant(uint32_t);
#endif
