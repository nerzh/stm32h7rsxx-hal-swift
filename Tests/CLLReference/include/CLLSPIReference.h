#pragma once
#include <stdint.h>
typedef struct CL55State CL55State;
typedef struct {uint32_t index,value,kind;} CL55Access;
CL55State *CL55_Create(void);
void CL55_Destroy(CL55State *s);
void CL55_Reset(CL55State *s,uint32_t seed,uint32_t salt,uint32_t instance,uint32_t failures,uint32_t mode);
uint32_t CL55_Run(CL55State *s,uint32_t op,const uint32_t *args);
uint32_t *CL55_GetCells(CL55State *s);
const CL55Access *CL55_GetTrace(CL55State *s);
uint32_t CL55_GetTraceCount(CL55State *s);
uint32_t CL55_Constant(uint32_t index);
