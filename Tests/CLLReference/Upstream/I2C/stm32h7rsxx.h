#pragma once
#include "DeviceDefinitions.h"
#define __STATIC_INLINE static inline
#define USE_FULL_LL_DRIVER
extern _Thread_local uint32_t *CL56_Cells;
uint32_t CL56_Read(volatile const uint32_t *p);
void CL56_Write(volatile uint32_t *p,uint32_t value);
uint32_t CL56_Address(volatile const uint32_t *p);
#define READ_REG(reg) CL56_Read(&(reg))
#define WRITE_REG(reg,value) CL56_Write(&(reg),(value))
#define READ_BIT(reg,mask) (READ_REG(reg)&(mask))
#define SET_BIT(reg,mask) WRITE_REG(reg,READ_REG(reg)|(mask))
#define CLEAR_BIT(reg,mask) WRITE_REG(reg,READ_REG(reg)&~(mask))
#define CLEAR_REG(reg) WRITE_REG(reg,0U)
#define MODIFY_REG(reg,clear,set) WRITE_REG(reg,(READ_REG(reg)&~(clear))|(set))
#define POSITION_VAL(v) ((v)==0?32U:(uint32_t)__builtin_ctz(v))
#define UNUSED(v) ((void)(v))
#define RCC ((RCC_TypeDef *)(CL56_Cells+256))
#define I2C1 ((I2C_TypeDef *)(CL56_Cells+0))
#define I2C2 ((I2C_TypeDef *)(CL56_Cells+16))
#define I2C3 ((I2C_TypeDef *)(CL56_Cells+32))
#define I3C1 ((I3C_TypeDef *)(CL56_Cells+64))
