#ifndef CETH_DEFINITIONS_H
#define CETH_DEFINITIONS_H
#include "stm32h7rsxx_hal_def.h"
#define HAL_MAX_DELAY UINT32_MAX
#define ETH_TX_DESC_CNT 8U
#define ETH_RX_DESC_CNT 8U
#define HAL_ETH_MODULE_ENABLED
#define USE_HAL_ETH_REGISTER_CALLBACKS 1
#define HAL_ETH_USE_PTP
#define ETH ((ETH_TypeDef *)0x40028000U)
#include "Upstream/ETHRegisterTypes.h"
#include "Upstream/ETHBits.h"
#include "Upstream/stm32h7rsxx_hal_eth.h"
#include "Upstream/stm32h7rsxx_hal_eth_ex.h"
#endif
