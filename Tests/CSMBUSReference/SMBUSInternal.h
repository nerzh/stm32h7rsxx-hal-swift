#ifndef CSMBUS_INTERNAL_H
#define CSMBUS_INTERNAL_H
#include "SMBUSDefinitions.h"
#include "include/CSMBUSReference.h"
#include <assert.h>
#include <string.h>
struct CSMBUSState {
 SMBUS_HandleTypeDef h;
 I2C_TypeDef regs;
 uint32_t control[64];
 uint8_t buffer[4096];
 uint32_t trace[1024];
};
#if defined(__arm__) || defined(__thumb__)
#define CSMBUS_THREAD_LOCAL
#else
#define CSMBUS_THREAD_LOCAL _Thread_local
#endif
extern CSMBUS_THREAD_LOCAL CSMBUSState *CSMBUS_Active;
uint32_t CSMBUS_Tick(void);
uint32_t CSMBUS0_Run(CSMBUSState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSMBUS1_Run(CSMBUSState *,uint32_t,uint32_t,uint32_t,uint32_t);
#endif
