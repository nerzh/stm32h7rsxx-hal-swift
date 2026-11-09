#pragma once
#include "DeviceDefinitions.h"
#include <float.h>
#define __STATIC_INLINE static inline
#define USE_FULL_LL_DRIVER
extern _Thread_local uint32_t *CL55_Cells;
uint32_t CL55_Read(volatile const uint32_t *p);
void CL55_Write(volatile uint32_t *p, uint32_t value);
uint32_t CL55_Address(volatile const uint32_t *p);
uint32_t CL55_ReadN(volatile const void *p,uint32_t width);
void CL55_WriteN(volatile void *p,uint32_t value,uint32_t width);
uint32_t CL55_Oscillator(uint32_t index);
#define READ_REG(reg) CL55_Read(&(reg))
#define WRITE_REG(reg, value) CL55_Write(&(reg), (value))
#define READ_BIT(reg, mask) (READ_REG(reg) & (mask))
#define SET_BIT(reg, mask) WRITE_REG(reg, READ_REG(reg) | (mask))
#define CLEAR_BIT(reg, mask) WRITE_REG(reg, READ_REG(reg) & ~(mask))
#define CLEAR_REG(reg) WRITE_REG(reg, 0U)
#define MODIFY_REG(reg, clear, set) WRITE_REG(reg, (READ_REG(reg) & ~(clear)) | (set))
#define POSITION_VAL(v) ((v) == 0 ? 32U : (uint32_t)__builtin_ctz(v))
#define RCC ((RCC_TypeDef *)(CL55_Cells + 256))
#define FLASH ((FLASH_TypeDef *)(CL55_Cells + 768))
#define HSI_VALUE CL55_Oscillator(0)
#define CSI_VALUE CL55_Oscillator(1)
#define HSE_VALUE CL55_Oscillator(2)
#define LSE_VALUE CL55_Oscillator(3)
#define LSI_VALUE CL55_Oscillator(4)
#define HSI48_VALUE CL55_Oscillator(5)
#define EXTERNAL_CLOCK_VALUE CL55_Oscillator(6)
#define CRYP 1
#define SAES 1
#define GPU2D 1
#define LTDC 1
_Static_assert(FLT_EVAL_METHOD == 0,"RCC requires binary32 float evaluation");
#define SPI1 ((SPI_TypeDef *)(CL55_Cells + 0))
#define SPI2 ((SPI_TypeDef *)(CL55_Cells + 32))
#define SPI3 ((SPI_TypeDef *)(CL55_Cells + 64))
#define SPI4 ((SPI_TypeDef *)(CL55_Cells + 96))
#define SPI5 ((SPI_TypeDef *)(CL55_Cells + 128))
#define SPI6 ((SPI_TypeDef *)(CL55_Cells + 160))
