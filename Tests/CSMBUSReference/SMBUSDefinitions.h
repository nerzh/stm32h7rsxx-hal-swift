#ifndef CSMBUS_DEFINITIONS_H
#define CSMBUS_DEFINITIONS_H
#include "stm32h7rsxx_hal_def.h"
#define __IO volatile
#include "Upstream/SMBUSRegisterType.h"
#include "Upstream/SMBUSBits.h"
#define HAL_SMBUS_MODULE_ENABLED
#define USE_HAL_SMBUS_REGISTER_CALLBACKS 1
#include "Upstream/stm32h7rsxx_hal_smbus.h"
#include "SMBUSPrivate.h"
#endif
