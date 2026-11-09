#pragma once
#include <stdint.h>
typedef struct CL51State CL51State;
typedef struct { uint32_t index, value, kind; } CL51Access;
CL51State *CL51_Create(void);
void CL51_Destroy(CL51State *s);
void CL51_Reset(CL51State *s, uint32_t seed, uint32_t salt, uint32_t controller);
uint32_t CL51_Run(CL51State *s, uint32_t operation, const uint32_t *args);
uint32_t *CL51_GetCells(CL51State *s);
const CL51Access *CL51_GetTrace(CL51State *s);
uint32_t CL51_GetTraceCount(CL51State *s);
uint32_t CL51_Constant(uint32_t index);
