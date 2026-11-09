#pragma once
#include <stdint.h>
typedef struct CL53State CL53State;
typedef struct { uint32_t index, value, kind; } CL53Access;
CL53State *CL53_Create(void);
void CL53_Destroy(CL53State *s);
void CL53_Reset(CL53State *s,uint32_t seed,uint32_t salt,uint32_t instance,uint32_t stopAt,uint32_t disableAt);
uint32_t CL53_Run(CL53State *s,uint32_t op,const uint32_t *args);
uint32_t *CL53_GetCells(CL53State *s);
const CL53Access *CL53_GetTrace(CL53State *s);
uint32_t CL53_GetTraceCount(CL53State *s);
uint32_t CL53_Constant(uint32_t i);
