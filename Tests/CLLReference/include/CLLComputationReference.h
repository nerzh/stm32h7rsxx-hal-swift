#pragma once
#include <stdint.h>
typedef struct CL58State CL58State;
typedef struct {uint32_t index,value,kind;} CL58Access;
CL58State *CL58_Create(void);
void CL58_Destroy(CL58State *s);
void CL58_Reset(CL58State *s,uint32_t seed,uint32_t salt,uint32_t instance);
uint32_t CL58_Run(CL58State *s,uint32_t op,const uint32_t *args);
uint32_t *CL58_GetCells(CL58State *s);
const CL58Access *CL58_GetTrace(CL58State *s);
uint32_t CL58_GetTraceCount(CL58State *s);
uint32_t CL58_Constant(uint32_t index);
