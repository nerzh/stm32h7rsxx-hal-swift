#pragma once
#include "DeviceDefinitions.h"
#include <float.h>
#define __STATIC_INLINE static inline
#define USE_FULL_LL_DRIVER
extern _Thread_local uint32_t *CL50_Cells;
uint32_t CL50_Read(volatile const uint32_t *p);
void CL50_Write(volatile uint32_t *p, uint32_t value);
uint32_t CL50_Oscillator(uint32_t index);
uint32_t *CL50_CoreClockPointer(void);
uint32_t CL50_ReadCoreClock(void);
void CL50_WriteCoreClock(uint32_t value);
#define SystemCoreClock (*CL50_CoreClockPointer())
#define READ_REG(reg) CL50_Read(&(reg))
#define WRITE_REG(reg, value) CL50_Write(&(reg), (value))
#define READ_BIT(reg, mask) (READ_REG(reg) & (mask))
#define SET_BIT(reg, mask) WRITE_REG(reg, READ_REG(reg) | (mask))
#define CLEAR_BIT(reg, mask) WRITE_REG(reg, READ_REG(reg) & ~(mask))
#define CLEAR_REG(reg) WRITE_REG(reg, 0U)
#define MODIFY_REG(reg, clear, set) WRITE_REG(reg, (READ_REG(reg) & ~(clear)) | (set))
#define POSITION_VAL(value) ((uint32_t)(value) ? (uint32_t)__builtin_ctz((uint32_t)(value)) : 32U)
#define HSI_VALUE CL50_Oscillator(0)
#define CSI_VALUE CL50_Oscillator(1)
#define HSE_VALUE CL50_Oscillator(2)
#define LSE_VALUE CL50_Oscillator(3)
#define LSI_VALUE CL50_Oscillator(4)
#define HSI48_VALUE CL50_Oscillator(5)
#define EXTERNAL_CLOCK_VALUE CL50_Oscillator(6)
#define UID_BASE ((uintptr_t)(CL50_Cells + 2048))
#define PACKAGE_BASE ((uintptr_t)(CL50_Cells + 2051))
#define CRYP 1
#define SAES 1
#define GPU2D 1
#define LTDC 1
_Static_assert(FLT_EVAL_METHOD == 0, "LL RCC requires binary32 float evaluation");
#define RCC ((RCC_TypeDef *)(CL50_Cells + 0))
#define CRS ((CRS_TypeDef *)(CL50_Cells + 256))
#define FLASH ((FLASH_TypeDef *)(CL50_Cells + 512))
#define PWR ((PWR_TypeDef *)(CL50_Cells + 768))
#define SysTick ((SysTick_Type *)(CL50_Cells + 1024))
#define SBS ((SBS_TypeDef *)(CL50_Cells + 1280))
#define DBGMCU ((DBGMCU_TypeDef *)(CL50_Cells + 1536))
#define VREFBUF ((VREFBUF_TypeDef *)(CL50_Cells + 1792))
