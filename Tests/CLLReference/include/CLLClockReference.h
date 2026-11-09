#pragma once
#include <stdint.h>
typedef struct CL50State CL50State;
typedef struct { uint32_t index, value, kind; } CL50Access;
CL50State *CL50_Create(void);
void CL50_Destroy(CL50State *s);
void CL50_Reset(CL50State *s, uint32_t seed, uint32_t salt, uint32_t mode);
uint32_t CL50_Run(CL50State *s, uint32_t operation, const uint32_t *args);
uint32_t *CL50_GetCells(CL50State *s);
const CL50Access *CL50_GetTrace(CL50State *s);
uint32_t CL50_GetTraceCount(CL50State *s);
uint32_t CL50_Constant(uint32_t index);
