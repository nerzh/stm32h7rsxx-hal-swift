#pragma once
#include "DeviceDefinitions.h"
#define __STATIC_INLINE static inline
#define USE_FULL_LL_DRIVER
#define HAL_SD_MODULE_ENABLED
extern _Thread_local uint32_t *CL59_Cells;
uint32_t CL59_Read(volatile const uint32_t *p);
void CL59_Write(volatile uint32_t *p,uint32_t value);
uint32_t CL59_Tick(void);
#define READ_REG(reg) CL59_Read(&(reg))
#define WRITE_REG(reg,value) CL59_Write(&(reg),(value))
#define READ_BIT(reg,mask) (READ_REG(reg)&(mask))
#define SET_BIT(reg,mask) WRITE_REG(reg,READ_REG(reg)|(mask))
#define CLEAR_BIT(reg,mask) WRITE_REG(reg,READ_REG(reg)&~(mask))
#define CLEAR_REG(reg) WRITE_REG(reg,0U)
#define MODIFY_REG(reg,clear,set) WRITE_REG(reg,(READ_REG(reg)&~(clear))|(set))
#define POSITION_VAL(v) ((v)==0?32U:(uint32_t)__builtin_ctz(v))
#define UNUSED(v) ((void)(v))
#define RCC ((RCC_TypeDef *)(CL59_Cells+256))
#define UCPD1 ((UCPD_TypeDef *)(CL59_Cells+0))
#define DLYB_SDMMC1 ((DLYB_TypeDef *)(CL59_Cells+32))
#define DLYB_SDMMC2 ((DLYB_TypeDef *)(CL59_Cells+48))
