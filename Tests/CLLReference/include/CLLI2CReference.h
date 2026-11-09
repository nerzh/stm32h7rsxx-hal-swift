#pragma once
#include <stdint.h>
typedef struct CL56State CL56State;
typedef struct {uint32_t index,value,kind;} CL56Access;
CL56State *CL56_Create(void);
void CL56_Destroy(CL56State *s);
void CL56_Reset(CL56State *s,uint32_t seed,uint32_t salt,uint32_t instance);
uint32_t CL56_Run(CL56State *s,uint32_t op,const uint32_t *args);
uint32_t *CL56_GetCells(CL56State *s);
const CL56Access *CL56_GetTrace(CL56State *s);
uint32_t CL56_GetTraceCount(CL56State *s);
uint32_t CL56_Constant(uint32_t index);
