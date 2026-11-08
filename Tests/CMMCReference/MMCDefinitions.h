#ifndef CMMC_DEFINITIONS_H
#define CMMC_DEFINITIONS_H
#include "../CSDMMCReference/SDMMCDefinitions.h"
typedef enum {DISABLE=0,ENABLE=1} FunctionalState;
#define HAL_MMC_MODULE_ENABLED
#define USE_HAL_MMC_REGISTER_CALLBACKS 1
#include "Upstream/stm32h7rsxx_hal_mmc.h"
#include "Upstream/stm32h7rsxx_hal_mmc_ex.h"
#include "MMCPrivate.h"
#endif
