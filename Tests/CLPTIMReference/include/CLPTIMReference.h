#ifndef CLPTIM_REFERENCE_H
#define CLPTIM_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CLPTIMState CLPTIMState;
size_t CLPTIM_Size(void);
void CLPTIM_Reset(CLPTIMState *,uint32_t mode,uint32_t instance);
uint32_t CLPTIM_Get(CLPTIMState *,uint32_t area,uint32_t index);
void CLPTIM_Set(CLPTIMState *,uint32_t area,uint32_t index,uint32_t value);
uint32_t CLPTIM_ReadISR(CLPTIMState *);
uint32_t CLPTIM_Clock(CLPTIMState *);
uint32_t CLPTIM_Address(CLPTIMState *,uint32_t offset);
void CLPTIM_Callback(CLPTIMState *,uint32_t id,uint32_t token);
void CLPTIM_SetCallback(CLPTIMState *,uint32_t id,uint32_t token);
uint32_t CLPTIM_GetCallback(CLPTIMState *,uint32_t id);
void CLPTIM_SetDMACallback(CLPTIMState *,uint32_t ch,uint32_t id,uint32_t token);
uint32_t CLPTIM_GetDMACallback(CLPTIMState *,uint32_t ch,uint32_t id);
uint32_t CLPTIM_DMAStart(CLPTIMState *,uint32_t ch,uint32_t src,uint32_t dst,uint32_t length,uint32_t linked);
uint32_t CLPTIM_DMAAbort(CLPTIMState *,uint32_t ch);
uint32_t CLPTIM_Run(CLPTIMState *,uint32_t op,uint32_t a,uint32_t b,uint32_t c);
uint32_t CLPTIM_TraceCount(CLPTIMState *);
uint32_t CLPTIM_TraceWord(CLPTIMState *,uint32_t event,uint32_t word);
uint32_t CLPTIM_ConstantCount(void);
uint32_t CLPTIM_Constant(uint32_t index);
#endif
