#ifndef CAUDIO_DEFINITIONS_H
#define CAUDIO_DEFINITIONS_H
#include "stm32h7rsxx_hal_def.h"
#define __IO volatile
#include "Upstream/AudioRegisterTypes.h"
#include "Upstream/AudioBits.h"
#include "../CUARTReference/Upstream/DMABits.h"
#include "../CUARTReference/Upstream/DMAMacros.h"
#include "../CUARTReference/Upstream/DMA_EXMacros.h"
#define HAL_I2S_MODULE_ENABLED
#define HAL_SAI_MODULE_ENABLED
#define HAL_DMA_MODULE_ENABLED
#define USE_HAL_I2S_REGISTER_CALLBACKS 1
#define USE_HAL_SAI_REGISTER_CALLBACKS 1
#include "Upstream/stm32h7rsxx_hal_i2s.h"
#include "Upstream/stm32h7rsxx_hal_sai.h"
#include "I2SPrivate.h"
#include "SAIPrivate.h"
#define RCC_PERIPHCLK_SAI1         ((uint64_t)(0x00080000U))
#define RCC_PERIPHCLK_SAI2         ((uint64_t)(0x00100000U))
#define RCC_PERIPHCLK_SPI1         ((uint64_t)(0x00800000U))
#define RCC_PERIPHCLK_SPI23        ((uint64_t)(0x01000000U))
#define RCC_PERIPHCLK_SPI6         ((uint64_t)(0x04000000U))
#endif
