#pragma once
#include "DeviceDefinitions.h"
#define __STATIC_INLINE static inline
#define USE_FULL_LL_DRIVER
extern _Thread_local uint32_t *CL53_Cells;
uint32_t CL53_Read(volatile const uint32_t *p);
void CL53_Write(volatile uint32_t *p, uint32_t value);
uint32_t CL53_Address(volatile const uint32_t *p);
uint16_t CL53_Factory(uint32_t index);
#define READ_REG(reg) CL53_Read(&(reg))
#define WRITE_REG(reg, value) CL53_Write(&(reg), (value))
#define READ_BIT(reg, mask) (READ_REG(reg) & (mask))
#define SET_BIT(reg, mask) WRITE_REG(reg, READ_REG(reg) | (mask))
#define CLEAR_BIT(reg, mask) WRITE_REG(reg, READ_REG(reg) & ~(mask))
#define CLEAR_REG(reg) WRITE_REG(reg, 0U)
#define MODIFY_REG(reg, clear, set) WRITE_REG(reg, (READ_REG(reg) & ~(clear)) | (set))
#define POSITION_VAL(v) ((v) == 0 ? 32U : (uint32_t)__builtin_ctz(v))
#define RCC ((RCC_TypeDef *)(CL53_Cells + 256))
#define ADC1 ((ADC_TypeDef *)CL53_Cells)
#define ADC2 ((ADC_TypeDef *)(CL53_Cells + 64))
#define ADC12_COMMON ((ADC_Common_TypeDef *)(CL53_Cells + 192))
