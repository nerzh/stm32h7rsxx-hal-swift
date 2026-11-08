#ifndef CPKA_REFERENCE_H
#define CPKA_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CPKAState CPKAState;
size_t CPKA_Size(void);
void CPKA_Reset(CPKAState *,uint32_t,uint32_t);
uint32_t CPKA_Get(CPKAState *,uint32_t,uint32_t);
void CPKA_Set(CPKAState *,uint32_t,uint32_t,uint32_t);
uint32_t *CPKA_Buffer(CPKAState *,uint32_t);
uint32_t CPKA_GetCallback(CPKAState *,uint32_t);
void CPKA_SetCallback(CPKAState *,uint32_t,uint32_t);
void CPKA_Callback(CPKAState *,uint32_t,uint32_t);
void CPKA_System(CPKAState *,uint32_t);
uint32_t CPKA_TickFor(CPKAState *);
uint32_t CPKA_Run(CPKAState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CPKA_Constant(uint32_t);
#endif
