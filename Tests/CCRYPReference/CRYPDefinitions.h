#ifndef CCRYP_DEFINITIONS_H
#define CCRYP_DEFINITIONS_H
#include <string.h>
#include "stm32h7rsxx_hal_def.h"
#define __IO volatile
#include "Upstream/CRYPRegisterTypes.h"
#define AHB3PERIPH_BASE 0x48020000UL
#include "Upstream/CRYPBits.h"
#include "../CUARTReference/Upstream/DMABits.h"
#include "../CUARTReference/Upstream/DMAMacros.h"
#include "../CUARTReference/Upstream/DMA_EXMacros.h"
#define HAL_CRYP_MODULE_ENABLED
#define USE_HAL_CRYP_REGISTER_CALLBACKS 1
#define USE_HAL_CRYP_SUSPEND_RESUME 1
#ifndef CRYP
#define CRYP ((CRYP_TypeDef *)0x48020800U)
#endif
#ifndef SAES
#define SAES ((SAES_TypeDef *)0x48021000U)
#endif
#include "Upstream/stm32h7rsxx_hal_cryp.h"
#endif
