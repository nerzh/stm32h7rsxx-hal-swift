#ifndef CCRYP_REFERENCE_H
#define CCRYP_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CCRYPState CCRYPState;
size_t CCRYP_Size(void);
void CCRYP_Reset(CCRYPState *,uint32_t registered,uint32_t suspend,uint32_t engines,uint32_t instance);
uint32_t CCRYP_Run(CCRYPState *,uint32_t op,uint32_t a,uint32_t b,uint32_t c);
uint32_t CCRYP_GetWord(CCRYPState *,uint32_t index);
void CCRYP_SetWord(CCRYPState *,uint32_t index,uint32_t value);
void *CCRYP_GetPointer(CCRYPState *,uint32_t index);
void CCRYP_SetPointer(CCRYPState *,uint32_t index,void *value);
uint32_t *CCRYP_SavedWords(CCRYPState *,uint32_t index);
uint32_t CCRYP_GetRegister(CCRYPState *,uint32_t offset);
void CCRYP_SetRegister(CCRYPState *,uint32_t offset,uint32_t value);
uint32_t *CCRYP_Buffer(CCRYPState *,uint32_t index);
uint32_t *CCRYP_Control(CCRYPState *);
uint32_t *CCRYP_Trace(CCRYPState *);
uint32_t CCRYP_GetCallback(CCRYPState *,uint32_t id);
void CCRYP_SetCallback(CCRYPState *,uint32_t id,uint32_t value);
void CCRYP_Invoke(CCRYPState *,uint32_t id,uint32_t value);
uint32_t CCRYP_TickFor(CCRYPState *);
void CCRYP_Event(CCRYPState *,uint32_t index,uint32_t due,uint32_t offset,uint32_t value);
uint32_t CCRYP_Constant(uint32_t index);
uint32_t CCRYP_Normalize(CCRYPState *,uintptr_t value);
uint32_t CCRYP_GetConfigurationWord(CCRYPState *,uint32_t);
void CCRYP_SetConfigurationWord(CCRYPState *,uint32_t,uint32_t);
void *CCRYP_GetConfigurationPointer(CCRYPState *,uint32_t);
void CCRYP_SetConfigurationPointer(CCRYPState *,uint32_t,void *);
uint32_t CCRYP_GetDMA(CCRYPState *,uint32_t,uint32_t);
void CCRYP_SetDMA(CCRYPState *,uint32_t,uint32_t,uint32_t);
uint32_t CCRYP_GetNode(CCRYPState *,uint32_t,uint32_t);
void CCRYP_SetNode(CCRYPState *,uint32_t,uint32_t,uint32_t);
uint32_t CCRYP_GetDMACallback(CCRYPState *,uint32_t,uint32_t);
void CCRYP_SetDMACallback(CCRYPState *,uint32_t,uint32_t,uint32_t);
uint32_t CCRYP_DMAOperation(CCRYPState *,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
#endif
