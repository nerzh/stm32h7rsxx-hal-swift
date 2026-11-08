#ifndef CSDMMC_REFERENCE_H
#define CSDMMC_REFERENCE_H
#include <stdint.h>
#include <stddef.h>
typedef struct CSDMMCState CSDMMCState;
size_t CSDMMC_Size(void);
void CSDMMC_Reset(CSDMMCState *);
uint32_t CSDMMC_Get(CSDMMCState *,uint32_t,uint32_t);
void CSDMMC_Set(CSDMMCState *,uint32_t,uint32_t,uint32_t);
uint32_t CSDMMC_Run(CSDMMCState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CSDMMC_Compare(CSDMMCState *,CSDMMCState *);
uint32_t CSDMMC_Read(CSDMMCState *,uint32_t);
void CSDMMC_Write(CSDMMCState *,uint32_t,uint32_t);
uint32_t CSDMMC_ReadMemory(CSDMMCState *,uint32_t);
void CSDMMC_WriteMemory(CSDMMCState *,uint32_t,uint32_t);
uint32_t CSDMMC_ClockFor(CSDMMCState *);
uint32_t CSDMMC_Constant(uint32_t);
#endif
