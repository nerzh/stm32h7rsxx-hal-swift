#ifndef CSRAM_REFERENCE_H
#define CSRAM_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CSRAMState CSRAMState;
size_t CSRAM_Size(void);
void CSRAM_Reset(CSRAMState *);
void CSRAM_Activate(CSRAMState *);
uint32_t CSRAM_Get(CSRAMState *,uint32_t,uint32_t);
void CSRAM_Set(CSRAMState *,uint32_t,uint32_t,uint32_t);
uint32_t CSRAM_ReadRegister(CSRAMState *,uint32_t);
void CSRAM_WriteRegister(CSRAMState *,uint32_t,uint32_t);
uint32_t CSRAM_ReadMemory(CSRAMState *,uint32_t,uint32_t);
void CSRAM_WriteMemory(CSRAMState *,uint32_t,uint32_t,uint32_t);
void *CSRAM_Buffer(CSRAMState *);
void *CSRAM_Callback(uint32_t,uint32_t);
void *CSRAM_GetCallback(CSRAMState *,uint32_t);
void CSRAM_SetCallback(CSRAMState *,uint32_t,void *);
void CSRAM_CallbackEvent(CSRAMState *,uint32_t,uint32_t,void *);
void *CSRAM_DMAContext(CSRAMState *,uint32_t);
void CSRAM_SetParent(CSRAMState *,uint32_t,CSRAMState *);
void *CSRAM_GetParent(void *);
uint32_t CSRAM_DMARead(CSRAMState *,uint32_t,uint32_t);
void CSRAM_DMAWrite(CSRAMState *,uint32_t,uint32_t,uint32_t);
uint32_t CSRAM_DMAReadMemory(CSRAMState *,uint32_t);
void CSRAM_DMAWriteMemory(CSRAMState *,uint32_t,uint32_t);
void *CSRAM_DMACallback(uint32_t,uint32_t);
uint32_t CSRAM_DMACallbackKind(void *);
void *CSRAM_DMAGetCallback(CSRAMState *,uint32_t,uint32_t);
void CSRAM_DMASetCallback(CSRAMState *,uint32_t,uint32_t,void *);
uint32_t CSRAM_Start(CSRAMState *,uint32_t,uint32_t,uint32_t,uint32_t);
void CSRAM_DisableDMA(void *);
uint32_t CSRAM_Run(CSRAMState *,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSRAM_Compare(CSRAMState *,CSRAMState *);
uint32_t CSRAM_Constant(uint32_t);
#endif
