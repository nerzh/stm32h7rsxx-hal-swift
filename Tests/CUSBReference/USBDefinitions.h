#ifndef CUSB_DEFINITIONS_H
#define CUSB_DEFINITIONS_H
#include "stm32h7rsxx_hal_def.h"
#define AHB1PERIPH_BASE 0x40020000UL
#define HAL_PCD_MODULE_ENABLED
#define HAL_HCD_MODULE_ENABLED
#define USE_HAL_PCD_REGISTER_CALLBACKS 1
#define USE_HAL_HCD_REGISTER_CALLBACKS 1
#include "Upstream/USBRegisterTypes.h"
#include "Upstream/USBBits.h"
#include "Upstream/stm32h7rsxx_ll_usb.h"
#include "Upstream/stm32h7rsxx_hal_pcd.h"
#include "Upstream/stm32h7rsxx_hal_hcd.h"
#include "USBPrivate.h"
#endif
