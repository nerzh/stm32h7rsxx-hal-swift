#pragma once
#include <stdint.h>
typedef struct CL49State CL49State;
typedef struct { uint32_t index, value, kind; } CL49Access;
CL49State *CL49_Create(void);
void CL49_Destroy(CL49State *s);
void CL49_Reset(CL49State *s, uint32_t seed, uint32_t salt);
uint32_t CL49_Run(CL49State *s, uint32_t operation, const uint32_t *args);
const uint32_t *CL49_GetCells(CL49State *s);
const CL49Access *CL49_GetTrace(CL49State *s);
uint32_t CL49_GetTraceCount(CL49State *s);
uint32_t CL49_Constant(uint32_t index);
