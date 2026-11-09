#pragma once
#include "DeviceDefinitions.h"
#define __STATIC_INLINE static inline
#define USE_FULL_LL_DRIVER
extern _Thread_local uint32_t *CL58_Cells;
uint32_t CL58_Read(volatile const uint32_t *p);
void CL58_Write(volatile uint32_t *p,uint32_t value);
uint32_t CL58_Address(volatile const uint32_t *p);
#define READ_REG(reg) CL58_Read(&(reg))
#define WRITE_REG(reg,value) CL58_Write(&(reg),(value))
#define READ_BIT(reg,mask) (READ_REG(reg)&(mask))
#define SET_BIT(reg,mask) WRITE_REG(reg,READ_REG(reg)|(mask))
#define CLEAR_BIT(reg,mask) WRITE_REG(reg,READ_REG(reg)&~(mask))
#define CLEAR_REG(reg) WRITE_REG(reg,0U)
#define MODIFY_REG(reg,clear,set) WRITE_REG(reg,(READ_REG(reg)&~(clear))|(set))
#define POSITION_VAL(v) ((v)==0?32U:(uint32_t)__builtin_ctz(v))
#define UNUSED(v) ((void)(v))
#define RCC ((RCC_TypeDef *)(CL58_Cells+256))
#define CRC ((CRC_TypeDef *)(CL58_Cells+0))
#define CORDIC ((CORDIC_TypeDef *)(CL58_Cells+16))
#define RNG ((RNG_TypeDef *)(CL58_Cells+32))
#define PKA ((PKA_TypeDef *)(CL58_Cells+48))
#define ICACHE ((ICACHE_TypeDef *)(CL58_Cells+64))
void CL58_Write16(volatile uint16_t *p,uint16_t value);
void CL58_Write8(volatile uint8_t *p,uint8_t value);
