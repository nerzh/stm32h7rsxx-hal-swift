#ifndef CI3C_DEFINITIONS_H
#define CI3C_DEFINITIONS_H
#include "stm32h7rsxx.h"
#include "../CUARTReference/Upstream/DMABits.h"
#include "../CUARTReference/Upstream/DMAMacros.h"
#include "../CUARTReference/Upstream/DMA_EXMacros.h"
#define HAL_I3C_MODULE_ENABLED
#define HAL_DMA_MODULE_ENABLED
#ifndef USE_HAL_I3C_REGISTER_CALLBACKS
#define USE_HAL_I3C_REGISTER_CALLBACKS 1
#endif
#include "Upstream/stm32h7rsxx_hal_i3c.h"
#include "I3CPrivate.h"
#endif
