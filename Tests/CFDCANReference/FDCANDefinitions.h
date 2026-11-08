#ifndef CFDCAN_DEFINITIONS_H
#define CFDCAN_DEFINITIONS_H
#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include "stm32h7rsxx_hal_def.h"
#include "Upstream/FDCANBits.h"
extern FDCAN_GlobalTypeDef *CFDCAN_Instances[2];
extern FDCAN_Config_TypeDef *CFDCAN_Config;
extern uint32_t *CFDCAN_RAM;
#define FDCAN1 CFDCAN_Instances[0]
#define FDCAN2 CFDCAN_Instances[1]
#define FDCAN_CONFIG CFDCAN_Config
#define SRAMCAN_BASE ((uintptr_t)CFDCAN_RAM)
#define USE_HAL_FDCAN_REGISTER_CALLBACKS 1
#if UINTPTR_MAX > UINT32_MAX
#include "FDCANHostHeader.h"
#else
#include "Upstream/stm32h7rsxx_hal_fdcan.h"
#endif
#endif
