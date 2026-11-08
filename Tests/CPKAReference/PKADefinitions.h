#ifndef CPKA_DEFINITIONS_H
#define CPKA_DEFINITIONS_H
#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include "stm32h7rsxx_hal_def.h"
#include "Upstream/PKABits.h"
#define PKA ((PKA_TypeDef *)0)
#define HAL_PKA_MODULE_ENABLED
#define USE_HAL_PKA_REGISTER_CALLBACKS 1
#include "Upstream/stm32h7rsxx_hal_pka.h"
#endif
