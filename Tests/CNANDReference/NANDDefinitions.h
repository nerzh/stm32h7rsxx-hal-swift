#ifndef CNAND_DEFINITIONS_H
#define CNAND_DEFINITIONS_H
#include "../CFMCReference/FMCDefinitions.h"
typedef enum {DISABLE=0, ENABLE=1} FunctionalState;
#define HAL_NAND_MODULE_ENABLED
#define USE_HAL_NAND_REGISTER_CALLBACKS 1
#include "Upstream/stm32h7rsxx_hal_nand.h"
#endif
