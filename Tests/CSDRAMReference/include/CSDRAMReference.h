#ifndef CSDRAM_REFERENCE_H
#define CSDRAM_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CSDRAMState CSDRAMState;
size_t CSDRAM_Size(void);
void CSDRAM_Reset(CSDRAMState *);
void CSDRAM_Activate(CSDRAMState *);
uint32_t CSDRAM_Get(CSDRAMState *,uint32_t,uint32_t);
void CSDRAM_Set(CSDRAMState *,uint32_t,uint32_t,uint32_t);
uint32_t CSDRAM_ReadRegister(CSDRAMState *,uint32_t);
void CSDRAM_WriteRegister(CSDRAMState *,uint32_t,uint32_t);
uint32_t CSDRAM_ReadMemory(CSDRAMState *,uint32_t,uint32_t);
void CSDRAM_WriteMemory(CSDRAMState *,uint32_t,uint32_t,uint32_t);
void *CSDRAM_Buffer(CSDRAMState *);
void *CSDRAM_Callback(uint32_t,uint32_t);
void *CSDRAM_GetCallback(CSDRAMState *,uint32_t);
void CSDRAM_SetCallback(CSDRAMState *,uint32_t,void *);
void CSDRAM_CallbackEvent(CSDRAMState *,uint32_t,uint32_t,void *);
void *CSDRAM_DMAContext(CSDRAMState *,uint32_t);
void CSDRAM_SetParent(CSDRAMState *,uint32_t,CSDRAMState *);
void *CSDRAM_GetParent(void *);
uint32_t CSDRAM_DMARead(CSDRAMState *,uint32_t,uint32_t);
void CSDRAM_DMAWrite(CSDRAMState *,uint32_t,uint32_t,uint32_t);
uint32_t CSDRAM_DMAReadMemory(CSDRAMState *,uint32_t);
void CSDRAM_DMAWriteMemory(CSDRAMState *,uint32_t,uint32_t);
void *CSDRAM_DMACallback(uint32_t,uint32_t);
uint32_t CSDRAM_DMACallbackKind(void *);
void *CSDRAM_DMAGetCallback(CSDRAMState *,uint32_t,uint32_t);
void CSDRAM_DMASetCallback(CSDRAMState *,uint32_t,uint32_t,void *);
uint32_t CSDRAM_Start(CSDRAMState *,uint32_t,uint32_t,uint32_t,uint32_t);
void CSDRAM_DisableDMA(void *);
uint32_t CSDRAM_Run(CSDRAMState *,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSDRAM_Compare(CSDRAMState *,CSDRAMState *);
uint32_t CSDRAM_Constant(uint32_t);
#endif
