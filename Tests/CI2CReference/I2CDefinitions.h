#ifndef CI2C_DEFINITIONS_H
#define CI2C_DEFINITIONS_H
#include "stm32h7rsxx_hal_def.h"
#define __IO volatile
#include "Upstream/I2CRegisterType.h"
#include "Upstream/I2CBits.h"
#include "../CUARTReference/Upstream/DMABits.h"
#include "../CUARTReference/Upstream/DMAMacros.h"
#include "../CUARTReference/Upstream/DMA_EXMacros.h"
#define HAL_I2C_MODULE_ENABLED
#define HAL_DMA_MODULE_ENABLED
#define USE_HAL_I2C_REGISTER_CALLBACKS 1
#include "Upstream/stm32h7rsxx_hal_i2c.h"
#include "I2CPrivate.h"
#endif
