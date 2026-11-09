#pragma once
#include <stdint.h>
typedef struct CL59State CL59State;
typedef struct {uint32_t index,value,kind;} CL59Access;
CL59State *CL59_Create(void);
void CL59_Destroy(CL59State *s);
void CL59_Reset(CL59State *s,uint32_t seed,uint32_t salt,uint32_t instance);
uint32_t CL59_Run(CL59State *s,uint32_t op,const uint32_t *args);
uint32_t *CL59_GetCells(CL59State *s);
const CL59Access *CL59_GetTrace(CL59State *s);
uint32_t CL59_GetTraceCount(CL59State *s);
uint32_t CL59_Constant(uint32_t index);
