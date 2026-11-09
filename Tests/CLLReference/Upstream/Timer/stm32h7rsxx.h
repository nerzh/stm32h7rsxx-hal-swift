#pragma once
#include "DeviceDefinitions.h"
#define __STATIC_INLINE static inline
#define USE_FULL_LL_DRIVER
extern _Thread_local uint32_t *CL52_Cells;
uint32_t CL52_Read(volatile const uint32_t *p);
void CL52_Write(volatile uint32_t *p, uint32_t value);
#define READ_REG(reg) CL52_Read(&(reg))
#define WRITE_REG(reg, value) CL52_Write(&(reg), (value))
#define READ_BIT(reg, mask) (READ_REG(reg) & (mask))
#define SET_BIT(reg, mask) WRITE_REG(reg, READ_REG(reg) | (mask))
#define CLEAR_BIT(reg, mask) WRITE_REG(reg, READ_REG(reg) & ~(mask))
#define CLEAR_REG(reg) WRITE_REG(reg, 0U)
#define MODIFY_REG(reg, clear, set) WRITE_REG(reg, (READ_REG(reg) & ~(clear)) | (set))
#define POSITION_VAL(v) ((v) == 0 ? 32U : (uint32_t)__builtin_ctz(v))
#define RCC ((RCC_TypeDef *)(CL52_Cells + 4096))
#define TIM1 ((TIM_TypeDef *)(CL52_Cells + 0))
#define TIM2 ((TIM_TypeDef *)(CL52_Cells + 256))
#define TIM3 ((TIM_TypeDef *)(CL52_Cells + 512))
#define TIM4 ((TIM_TypeDef *)(CL52_Cells + 768))
#define TIM5 ((TIM_TypeDef *)(CL52_Cells + 1024))
#define TIM6 ((TIM_TypeDef *)(CL52_Cells + 1280))
#define TIM7 ((TIM_TypeDef *)(CL52_Cells + 1536))
#define TIM9 ((TIM_TypeDef *)(CL52_Cells + 1792))
#define TIM12 ((TIM_TypeDef *)(CL52_Cells + 2048))
#define TIM13 ((TIM_TypeDef *)(CL52_Cells + 2304))
#define TIM14 ((TIM_TypeDef *)(CL52_Cells + 2560))
#define TIM15 ((TIM_TypeDef *)(CL52_Cells + 2816))
#define TIM16 ((TIM_TypeDef *)(CL52_Cells + 3072))
#define TIM17 ((TIM_TypeDef *)(CL52_Cells + 3328))
#define LPTIM1 ((LPTIM_TypeDef *)(CL52_Cells + 3584))
#define LPTIM2 ((LPTIM_TypeDef *)(CL52_Cells + 3600))
#define LPTIM3 ((LPTIM_TypeDef *)(CL52_Cells + 3616))
#define LPTIM4 ((LPTIM_TypeDef *)(CL52_Cells + 3632))
#define LPTIM5 ((LPTIM_TypeDef *)(CL52_Cells + 3648))
