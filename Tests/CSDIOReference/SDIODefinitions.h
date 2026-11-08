#ifndef CSDIO_DEFINITIONS_H
#define CSDIO_DEFINITIONS_H
#include "../CSDMMCReference/SDMMCDefinitions.h"
#define HAL_SDIO_MODULE_ENABLED
#define USE_HAL_SDIO_REGISTER_CALLBACKS 1
#define SDIO_MAX_IO_NUMBER 7U
#include "Upstream/stm32h7rsxx_hal_sdio.h"
#include "SDIOPrivate.h"
#endif
