#pragma once
#include <stdint.h>
typedef struct CL54State CL54State;
typedef struct {uint32_t index,value,kind;} CL54Access;
CL54State *CL54_Create(void);
void CL54_Destroy(CL54State *s);
void CL54_Reset(CL54State *s,uint32_t seed,uint32_t salt,uint32_t instance,uint32_t failures,uint32_t mode);
uint32_t CL54_Run(CL54State *s,uint32_t op,const uint32_t *args);
uint32_t *CL54_GetCells(CL54State *s);
const CL54Access *CL54_GetTrace(CL54State *s);
uint32_t CL54_GetTraceCount(CL54State *s);
uint32_t CL54_Constant(uint32_t index);
