#ifndef CUSART_DEFINITIONS_H
#define CUSART_DEFINITIONS_H
#include <string.h>
#include "stm32h7rsxx_hal_def.h"
#define __IO volatile
#include "Upstream/USARTRegisterType.h"
#include "../CUARTReference/Upstream/UARTBits.h"
#include "../CUARTReference/Upstream/DMABits.h"
#include "../CUARTReference/Upstream/DMAMacros.h"
#include "../CUARTReference/Upstream/DMA_EXMacros.h"
#define HAL_DMA_MODULE_ENABLED
#define USE_HAL_USART_REGISTER_CALLBACKS 1
#include "Upstream/stm32h7rsxx_hal_usart.h"
#endif
