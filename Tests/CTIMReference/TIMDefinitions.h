#ifndef CTIM_DEFINITIONS_H
#define CTIM_DEFINITIONS_H
#include "stm32h7rsxx_hal_def.h"
#define __IO volatile
#include "Upstream/TIMRegisterType.h"
#include "Upstream/TIMBits.h"
#include "../CUARTReference/Upstream/DMABits.h"
#include "../CUARTReference/Upstream/DMAMacros.h"
#include "../CUARTReference/Upstream/DMA_EXMacros.h"
#define HAL_DMA_MODULE_ENABLED
#define HAL_TIM_MODULE_ENABLED
#define USE_HAL_TIM_REGISTER_CALLBACKS 1
#include "Upstream/stm32h7rsxx_hal_tim.h"
#include "TIMPrivate.h"
#endif
