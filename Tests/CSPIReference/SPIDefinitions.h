#ifndef CSPI_DEFINITIONS_H
#define CSPI_DEFINITIONS_H
#include "stm32h7rsxx_hal_def.h"
#define __IO volatile
#include "Upstream/SPIRegisterType.h"
#include "Upstream/SPIBits.h"
#include "../CUARTReference/Upstream/DMABits.h"
#include "../CUARTReference/Upstream/DMAMacros.h"
#include "../CUARTReference/Upstream/DMA_EXMacros.h"
#define HAL_DMA_MODULE_ENABLED
#define USE_SPI_CRC 1
#define HAL_SPI_MODULE_ENABLED
#define USE_HAL_SPI_REGISTER_CALLBACKS 1
#include "Upstream/stm32h7rsxx_hal_spi.h"
#include "SPIPrivate.h"
#endif
