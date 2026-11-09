#pragma once
#include "DeviceDefinitions.h"
#define __STATIC_INLINE static inline
#define USE_FULL_LL_DRIVER
extern _Thread_local uint32_t *CL49_Cells;
uint32_t CL49_Read(volatile const uint32_t *p);
void CL49_Write(volatile uint32_t *p, uint32_t value);
void CL49_Instruction(uint32_t instruction);
#define READ_REG(reg) CL49_Read(&(reg))
#define WRITE_REG(reg, value) CL49_Write(&(reg), (value))
#define READ_BIT(reg, mask) (READ_REG(reg) & (mask))
#define SET_BIT(reg, mask) WRITE_REG(reg, READ_REG(reg) | (mask))
#define CLEAR_BIT(reg, mask) WRITE_REG(reg, READ_REG(reg) & ~(mask))
#define MODIFY_REG(reg, clear, set) WRITE_REG(reg, (READ_REG(reg) & ~(clear)) | (set))
/* CMSIS CLZ(RBIT(0)) returns 32; the PWR shifts explicitly mask the count. */
#define POSITION_VAL(value) ((uint32_t)(value) ? (uint32_t)__builtin_ctz((uint32_t)(value)) : 32U)
#define __DMB() CL49_Instruction(1)
#define __DSB() CL49_Instruction(2)
#define __ISB() CL49_Instruction(3)
#define __SEV() CL49_Instruction(4)
#define __WFE() CL49_Instruction(5)
#define PWR ((PWR_TypeDef *)(CL49_Cells + 0))
#define SBS ((SBS_TypeDef *)(CL49_Cells + 256))
#define DBGMCU ((DBGMCU_TypeDef *)(CL49_Cells + 512))
#define VREFBUF ((VREFBUF_TypeDef *)(CL49_Cells + 768))
#define FLASH ((FLASH_TypeDef *)(CL49_Cells + 1024))
#define SCB ((SCB_Type *)(CL49_Cells + 1280))
#define SysTick ((SysTick_Type *)(CL49_Cells + 1536))
#define MPU ((MPU_Type *)(CL49_Cells + 1792))
