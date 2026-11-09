#pragma once
#include "DeviceDefinitions.h"
#define __STATIC_INLINE static inline
#define USE_FULL_LL_DRIVER
extern _Thread_local uint32_t *CLL_Cells;
extern _Thread_local uint32_t CLL_Port;
uint32_t CLL_Read(volatile const uint32_t *p);
void CLL_Write(volatile uint32_t *p, uint32_t value);
#define RCC ((RCC_TypeDef *)(CLL_Cells + 256))
#define EXTI ((EXTI_TypeDef *)(CLL_Cells + 512))
#define READ_REG(reg) CLL_Read(&(reg))
#define WRITE_REG(reg, value) CLL_Write(&(reg), (value))
#define READ_BIT(reg, mask) (READ_REG(reg) & (mask))
#define SET_BIT(reg, mask) WRITE_REG(reg, READ_REG(reg) | (mask))
#define CLEAR_BIT(reg, mask) WRITE_REG(reg, READ_REG(reg) & ~(mask))
#define MODIFY_REG(reg, clear, set) WRITE_REG(reg, (READ_REG(reg) & ~(clear)) | (set))
#define POSITION_VAL(value) ((uint32_t)__builtin_ctz((uint32_t)(value)))
/* Presence guards expose the family-wide constant set, never physical accesses. */
#define CRYP 1
#define SAES 1
#define GPU2D 1
#define LTDC 1
#define GPIOA ((GPIO_TypeDef *)(CLL_Cells + (CLL_Port == 0 ? 0 : 768 + 0 * 16)))
#define GPIOB ((GPIO_TypeDef *)(CLL_Cells + (CLL_Port == 1 ? 0 : 768 + 1 * 16)))
#define GPIOC ((GPIO_TypeDef *)(CLL_Cells + (CLL_Port == 2 ? 0 : 768 + 2 * 16)))
#define GPIOD ((GPIO_TypeDef *)(CLL_Cells + (CLL_Port == 3 ? 0 : 768 + 3 * 16)))
#define GPIOE ((GPIO_TypeDef *)(CLL_Cells + (CLL_Port == 4 ? 0 : 768 + 4 * 16)))
#define GPIOF ((GPIO_TypeDef *)(CLL_Cells + (CLL_Port == 5 ? 0 : 768 + 5 * 16)))
#define GPIOG ((GPIO_TypeDef *)(CLL_Cells + (CLL_Port == 6 ? 0 : 768 + 6 * 16)))
#define GPIOH ((GPIO_TypeDef *)(CLL_Cells + (CLL_Port == 7 ? 0 : 768 + 7 * 16)))
#define GPIOM ((GPIO_TypeDef *)(CLL_Cells + (CLL_Port == 12 ? 0 : 768 + 12 * 16)))
#define GPION ((GPIO_TypeDef *)(CLL_Cells + (CLL_Port == 13 ? 0 : 768 + 13 * 16)))
#define GPIOO ((GPIO_TypeDef *)(CLL_Cells + (CLL_Port == 14 ? 0 : 768 + 14 * 16)))
#define GPIOP ((GPIO_TypeDef *)(CLL_Cells + (CLL_Port == 15 ? 0 : 768 + 15 * 16)))
