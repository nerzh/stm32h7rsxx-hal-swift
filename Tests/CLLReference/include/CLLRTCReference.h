#pragma once
#include <stdint.h>
typedef struct CL57State CL57State;
typedef struct {uint32_t index,value,kind;} CL57Access;
CL57State *CL57_Create(void);
void CL57_Destroy(CL57State *s);
void CL57_Reset(CL57State *s,uint32_t seed,uint32_t salt,uint32_t instance);
uint32_t CL57_Run(CL57State *s,uint32_t op,const uint32_t *args);
uint32_t *CL57_GetCells(CL57State *s);
const CL57Access *CL57_GetTrace(CL57State *s);
uint32_t CL57_GetTraceCount(CL57State *s);
uint32_t CL57_Constant(uint32_t index);
