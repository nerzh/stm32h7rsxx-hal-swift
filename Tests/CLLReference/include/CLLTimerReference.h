#pragma once
#include <stdint.h>
typedef struct CL52State CL52State;
typedef struct { uint32_t index, value, kind; } CL52Access;
CL52State *CL52_Create(void);
void CL52_Destroy(CL52State *s);
void CL52_Reset(CL52State *s, uint32_t seed, uint32_t salt, uint32_t instance);
uint32_t CL52_Run(CL52State *s, uint32_t operation, const uint32_t *args);
uint32_t *CL52_GetCells(CL52State *s);
const CL52Access *CL52_GetTrace(CL52State *s);
uint32_t CL52_GetTraceCount(CL52State *s);
uint32_t CL52_Constant(uint32_t index);
