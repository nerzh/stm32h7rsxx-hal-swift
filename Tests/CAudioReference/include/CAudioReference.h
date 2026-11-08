#ifndef CAUDIO_REFERENCE_H
#define CAUDIO_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CI2SState CI2SState;
size_t CI2S_Size(void);
void CI2S_Reset(CI2SState *,uint32_t);
uint32_t CI2S_Get(CI2SState *,uint32_t,uint32_t);
void CI2S_Set(CI2SState *,uint32_t,uint32_t,uint32_t);
uint8_t *CI2S_Buffer(CI2SState *,uint32_t);
uintptr_t CI2S_GetPointer(CI2SState *,uint32_t);
void CI2S_SetPointer(CI2SState *,uint32_t,uintptr_t);
uintptr_t CI2S_Callback(uint32_t,uint32_t);
uintptr_t CI2S_GetCallback(CI2SState *,uint32_t);
void CI2S_SetCallback(CI2SState *,uint32_t,uintptr_t);
uint32_t CI2S_Run(CI2SState *,uint32_t,uint32_t,uint32_t,uint32_t);
void CI2S_Activate(CI2SState *);
uint32_t CI2S_TickFor(CI2SState *);
uint32_t CI2S_ClockFor(CI2SState *,uint32_t);
uint32_t CI2S_RecordDMA(CI2SState *,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CI2S_Compare(CI2SState *,CI2SState *);
uint32_t CI2S_Constant(uint32_t);
typedef struct CSAIState CSAIState;
size_t CSAI_Size(void);
void CSAI_Reset(CSAIState *,uint32_t);
uint32_t CSAI_Get(CSAIState *,uint32_t,uint32_t);
void CSAI_Set(CSAIState *,uint32_t,uint32_t,uint32_t);
uint8_t *CSAI_Buffer(CSAIState *,uint32_t);
uintptr_t CSAI_GetPointer(CSAIState *,uint32_t);
void CSAI_SetPointer(CSAIState *,uint32_t,uintptr_t);
uintptr_t CSAI_Callback(uint32_t,uint32_t);
uintptr_t CSAI_GetCallback(CSAIState *,uint32_t);
void CSAI_SetCallback(CSAIState *,uint32_t,uintptr_t);
uint32_t CSAI_Run(CSAIState *,uint32_t,uint32_t,uint32_t,uint32_t);
void CSAI_Activate(CSAIState *);
uint32_t CSAI_TickFor(CSAIState *);
uint32_t CSAI_ClockFor(CSAIState *,uint32_t);
uint32_t CSAI_RecordDMA(CSAIState *,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSAI_Compare(CSAIState *,CSAIState *);
uint32_t CSAI_Constant(uint32_t);
#endif
