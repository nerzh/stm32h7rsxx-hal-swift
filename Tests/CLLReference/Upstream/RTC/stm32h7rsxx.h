#pragma once
#include "DeviceDefinitions.h"
#define __STATIC_INLINE static inline
#define USE_FULL_LL_DRIVER
extern _Thread_local uint32_t *CL57_Cells;
uint32_t CL57_Read(volatile const uint32_t *p);
void CL57_Write(volatile uint32_t *p,uint32_t value);
#define READ_REG(reg) CL57_Read(&(reg))
#define WRITE_REG(reg,value) CL57_Write(&(reg),(value))
#define READ_BIT(reg,mask) (READ_REG(reg)&(mask))
#define SET_BIT(reg,mask) WRITE_REG(reg,READ_REG(reg)|(mask))
#define CLEAR_BIT(reg,mask) WRITE_REG(reg,READ_REG(reg)&~(mask))
#define CLEAR_REG(reg) WRITE_REG(reg,0U)
#define MODIFY_REG(reg,clear,set) WRITE_REG(reg,(READ_REG(reg)&~(clear))|(set))
#define POSITION_VAL(v) ((v)==0?32U:(uint32_t)__builtin_ctz(v))
#define UNUSED(v) ((void)(v))
#define RTC ((RTC_TypeDef *)(CL57_Cells+0))
#define TAMP ((TAMP_TypeDef *)(CL57_Cells+64))
#define IWDG ((IWDG_TypeDef *)(CL57_Cells+192))
#define WWDG ((WWDG_TypeDef *)(CL57_Cells+208))
