/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Selected HAL constants below are unchanged from stm32h7rsxx_hal_rcc.h at
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * The host register and oscillator substitutions are test-only adaptations. */
#ifndef C_RCC_REFERENCE_SHIM_H
#define C_RCC_REFERENCE_SHIM_H
#include "../include/CRCCReference.h"
#include "stm32h7rsxx_frequency_bits.h"
#include <float.h>
#include <math.h>

_Static_assert(FLT_EVAL_METHOD == 0, "RCC oracle requires Cortex-M float evaluation");
_Static_assert(sizeof(float_t) == sizeof(float), "RCC float_t must be binary32");
extern _Thread_local CRCCReferenceState *CRCCReference_Current;
#define RCC (&CRCCReference_Current->registers)
#define HSI_VALUE (CRCCReference_Current->hsi)
#define CSI_VALUE (CRCCReference_Current->csi)
#define HSE_VALUE (CRCCReference_Current->hse)
#define READ_BIT(REG, BIT) ((REG) & (BIT))
#define __HAL_RCC_GET_HSI_DIVIDER() ((uint32_t)(READ_BIT(RCC->CR, RCC_CR_HSIDIV)))

#define RCC_PLLSOURCE_CSI              RCC_PLLCKSELR_PLLSRC_0 /*!< CSI clock selected as PLL entry clock source */
#define RCC_PLLSOURCE_HSE              RCC_PLLCKSELR_PLLSRC_1 /*!< HSE clock selected as PLL entry clock source */
#define RCC_PLLSOURCE_HSI              0U                     /*!< HSI clock selected as PLL entry clock source */
#define RCC_SYSCLKSOURCE_STATUS_CSI    RCC_CFGR_SWS_0      /*!< CSI used as system clock */
#define RCC_SYSCLKSOURCE_STATUS_HSE    RCC_CFGR_SWS_1      /*!< HSE used as system clock */
#define RCC_SYSCLKSOURCE_STATUS_HSI    0U                  /*!< HSI used as system clock */
#define RCC_SYSCLKSOURCE_STATUS_PLLCLK (RCC_CFGR_SWS_1 | RCC_CFGR_SWS_0) /*!< PLL1 used as system clock */

uint32_t HAL_RCC_GetSysClockFreq(void);
uint32_t HAL_RCC_GetHCLKFreq(void);
uint32_t HAL_RCC_GetPCLK1Freq(void);
uint32_t HAL_RCC_GetPCLK2Freq(void);
uint32_t HAL_RCC_GetPCLK4Freq(void);
uint32_t HAL_RCC_GetPCLK5Freq(void);
uint32_t HAL_RCC_GetPLL1PFreq(void);
uint32_t HAL_RCC_GetPLL1QFreq(void);
uint32_t HAL_RCC_GetPLL1RFreq(void);
uint32_t HAL_RCC_GetPLL1SFreq(void);
uint32_t HAL_RCC_GetPLL2PFreq(void);
uint32_t HAL_RCC_GetPLL2QFreq(void);
uint32_t HAL_RCC_GetPLL2RFreq(void);
uint32_t HAL_RCC_GetPLL2SFreq(void);
uint32_t HAL_RCC_GetPLL2TFreq(void);
uint32_t HAL_RCC_GetPLL3PFreq(void);
uint32_t HAL_RCC_GetPLL3QFreq(void);
uint32_t HAL_RCC_GetPLL3RFreq(void);
uint32_t HAL_RCC_GetPLL3SFreq(void);

#endif
