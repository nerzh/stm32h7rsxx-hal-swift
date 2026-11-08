#ifndef CSMBUS_REFERENCE_H
#define CSMBUS_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CSMBUSState CSMBUSState;
size_t CSMBUS_Size(void);
void CSMBUS_Reset(CSMBUSState *,uint32_t);
uint32_t CSMBUS_Get(CSMBUSState *,uint32_t,uint32_t);
void CSMBUS_Set(CSMBUSState *,uint32_t,uint32_t,uint32_t);
uint8_t *CSMBUS_Buffer(CSMBUSState *);
uint8_t *CSMBUS_GetBuffer(CSMBUSState *);
void CSMBUS_SetBuffer(CSMBUSState *,uint8_t *);
uint32_t CSMBUS_TickFor(CSMBUSState *);
uint32_t CSMBUS_Run(CSMBUSState *,uint32_t,uint32_t,uint32_t,uint32_t);
uintptr_t CSMBUS_GetCallback(CSMBUSState *,uint32_t);
void CSMBUS_SetCallback(CSMBUSState *,uint32_t,uintptr_t);
uintptr_t CSMBUS_Callback(uint32_t,uint32_t);
uint32_t CSMBUS_Constant(uint32_t);
uint32_t CSMBUS_Compare(CSMBUSState *,CSMBUSState *);
#endif
