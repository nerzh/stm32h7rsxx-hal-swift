#pragma once
#include "DeviceDefinitions.h"
#include <float.h>
#define __STATIC_INLINE static inline
#define USE_FULL_LL_DRIVER
extern _Thread_local uint32_t *CL54_Cells;
uint32_t CL54_Read(volatile const uint32_t *p);
void CL54_Write(volatile uint32_t *p, uint32_t value);
uint32_t CL54_Address(volatile const uint32_t *p);
uint32_t CL54_LoadExclusive(volatile uint32_t *p);
uint32_t CL54_StoreExclusive(uint32_t value, volatile uint32_t *p);
uint32_t CL54_Oscillator(uint32_t index);
#define __LDREXW(p) CL54_LoadExclusive(p)
#define __STREXW(v,p) CL54_StoreExclusive(v,p)
#define READ_REG(reg) CL54_Read(&(reg))
#define WRITE_REG(reg, value) CL54_Write(&(reg), (value))
#define READ_BIT(reg, mask) (READ_REG(reg) & (mask))
#define SET_BIT(reg, mask) WRITE_REG(reg, READ_REG(reg) | (mask))
#define CLEAR_BIT(reg, mask) WRITE_REG(reg, READ_REG(reg) & ~(mask))
#define CLEAR_REG(reg) WRITE_REG(reg, 0U)
#define MODIFY_REG(reg, clear, set) WRITE_REG(reg, (READ_REG(reg) & ~(clear)) | (set))
#define POSITION_VAL(v) ((v) == 0 ? 32U : (uint32_t)__builtin_ctz(v))
#define RCC ((RCC_TypeDef *)(CL54_Cells + 256))
#define FLASH ((FLASH_TypeDef *)(CL54_Cells + 768))
#define HSI_VALUE CL54_Oscillator(0)
#define CSI_VALUE CL54_Oscillator(1)
#define HSE_VALUE CL54_Oscillator(2)
#define LSE_VALUE CL54_Oscillator(3)
#define LSI_VALUE CL54_Oscillator(4)
#define HSI48_VALUE CL54_Oscillator(5)
#define EXTERNAL_CLOCK_VALUE CL54_Oscillator(6)
#define CRYP 1
#define SAES 1
#define GPU2D 1
#define LTDC 1
_Static_assert(FLT_EVAL_METHOD == 0,"RCC requires binary32 float evaluation");
#define USART1 ((USART_TypeDef *)(CL54_Cells + 0))
#define USART2 ((USART_TypeDef *)(CL54_Cells + 16))
#define USART3 ((USART_TypeDef *)(CL54_Cells + 32))
#define UART4 ((USART_TypeDef *)(CL54_Cells + 48))
#define UART5 ((USART_TypeDef *)(CL54_Cells + 64))
#define UART7 ((USART_TypeDef *)(CL54_Cells + 80))
#define UART8 ((USART_TypeDef *)(CL54_Cells + 96))
#define LPUART1 ((USART_TypeDef *)(CL54_Cells + 112))
