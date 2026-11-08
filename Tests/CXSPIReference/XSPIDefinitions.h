#ifndef CXSPI_DEFINITIONS_H
#define CXSPI_DEFINITIONS_H
#include "stm32h7rsxx_hal_def.h"
#define __IO volatile
#include "Upstream/XSPIRegisterType.h"
#include "Upstream/XSPIBits.h"
#include "../CUARTReference/Upstream/DMABits.h"
#include "../CUARTReference/Upstream/DMAMacros.h"
#include "../CUARTReference/Upstream/DMA_EXMacros.h"
#define HAL_DMA_MODULE_ENABLED
#define XSPI1 ((XSPI_TypeDef *)0x52005000U)
#define XSPI2 ((XSPI_TypeDef *)0x5200A000U)
#define XSPIM ((XSPIM_TypeDef *)0x5200B400U)
#define HAL_XSPI_MODULE_ENABLED
#define USE_HAL_XSPI_REGISTER_CALLBACKS 1
#include "Upstream/stm32h7rsxx_hal_xspi.h"
#include "XSPIPrivate.h"
#endif
