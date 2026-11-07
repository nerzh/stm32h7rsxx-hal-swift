/**
  ******************************************************************************
  * @file    stm32h7rsxx_hal_rcc.c
  * @author  MCD Application Team
  * @brief   RCC HAL module driver.
  *          This file provides firmware functions to manage the following
  *          functionalities of the Reset and Clock Control (RCC) peripheral:
  *           + Initialization and de-initialization functions
  *           + Peripheral Control functions
  *
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2022 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  @verbatim
  ==============================================================================
                      ##### RCC specific features #####
  ==============================================================================
    [..]
      After reset the device is running from Internal High Speed oscillator
      (HSI 64MHz) with Flash 0 wait state,and all peripherals are off except
      internal SRAM, Flash, JTAG and PWR
      (+) There is no pre-scaler on High speed (AHB) and Low speed (APB) buses;
          all peripherals mapped on these buses are running at HSI speed.
      (+) The clock for all peripherals is switched off, except the SRAM and FLASH.
      (+) All GPIOs are in analogue mode , except the JTAG pins which
          are assigned to be used for debug purpose.

    [..]
      Once the device started from reset, the user application has to:
      (+) Configure the clock source to be used to drive the System clock
          (if the application needs higher frequency/performance)
      (+) Configure the System clock frequency and Flash settings
      (+) Configure the AHB and APB buses pre-scalers
      (+) Enable the clock for the peripheral(s) to be used
      (+) Configure the clock kernel source(s) for peripherals which clocks are not
          derived from the System clock.

                      ##### RCC Limitations #####
  ==============================================================================
    [..]
      A delay between an RCC peripheral clock enable and the effective peripheral
      enabling should be taken into account in order to manage the peripheral read/write
      from/to registers.
      (+) This delay depends on the peripheral mapping.
      (+) If peripheral is mapped on AHB: the delay is 2 AHB clock cycle
          after the clock enable bit is set on the hardware register
      (+) If peripheral is mapped on APB: the delay is 2 APB clock cycle
          after the clock enable bit is set on the hardware register

    [..]
      Implemented Workaround:
      (+) For AHB & APB peripherals, a dummy read to the peripheral register has been
          inserted in each __HAL_RCC_PPP_CLK_ENABLE() macro.

  @endverbatim
  */

/* Host oracle: exact, unchanged frequency-function extractions from
 * stm32h7rsxx_hal_rcc.c at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * Only surrounding includes, declarations, and unrelated functions are omitted.
 * SPDX-License-Identifier: BSD-3-Clause
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */

#include "RCCReferenceShim.h"

static uint32_t RCC_PLL1_GetVCOOutputFreq(void);
static uint32_t RCC_PLL2_GetVCOOutputFreq(void);
static uint32_t RCC_PLL3_GetVCOOutputFreq(void);

uint32_t HAL_RCC_GetSysClockFreq(void)
{
  uint32_t pllp;
  uint32_t pllsource;
  uint32_t pllm;
  uint32_t pllfracen;
  uint32_t hsivalue;
  float_t fracn1;
  float_t pllvco;
  uint32_t sysclockfreq;
  uint32_t prescaler;

  /* Get SYSCLK source -------------------------------------------------------*/

  switch (RCC->CFGR & RCC_CFGR_SWS)
  {
    case RCC_SYSCLKSOURCE_STATUS_HSI:  /* HSI used as system clock source */

      if (READ_BIT(RCC->CR, RCC_CR_HSIDIVF) != 0U)
      {
        sysclockfreq = (uint32_t)(HSI_VALUE >> (__HAL_RCC_GET_HSI_DIVIDER() >> RCC_CR_HSIDIV_Pos));
      }
      else
      {
        /* Can't retrieve HSIDIV value */
        sysclockfreq = 0U;
      }

      break;

    case RCC_SYSCLKSOURCE_STATUS_CSI:  /* CSI used as system clock  source */
      sysclockfreq = CSI_VALUE;
      break;

    case RCC_SYSCLKSOURCE_STATUS_HSE:  /* HSE used as system clock  source */
      sysclockfreq = HSE_VALUE;
      break;

    case RCC_SYSCLKSOURCE_STATUS_PLLCLK:  /* PLL1 used as system clock  source */

      /* PLL_VCO = (HSE_VALUE or HSI_VALUE or CSI_VALUE/ PLLM) * PLLN
      SYSCLK = PLL_VCO / PLLR
      */
      pllsource = (RCC->PLLCKSELR & RCC_PLLCKSELR_PLLSRC);
      pllm = ((RCC->PLLCKSELR & RCC_PLLCKSELR_DIVM1) >> RCC_PLLCKSELR_DIVM1_Pos)  ;
      pllfracen = ((RCC-> PLLCFGR & RCC_PLLCFGR_PLL1FRACEN) >> RCC_PLLCFGR_PLL1FRACEN_Pos);
      fracn1 = (float_t)(uint32_t)(pllfracen * ((RCC->PLL1FRACR & RCC_PLL1FRACR_FRACN) >> 3));

      if (pllm != 0U)
      {
        switch (pllsource)
        {
          case RCC_PLLSOURCE_HSI:  /* HSI used as PLL clock source */

            if (READ_BIT(RCC->CR, RCC_CR_HSIDIVF) != 0U)
            {
              hsivalue = (HSI_VALUE >> (__HAL_RCC_GET_HSI_DIVIDER() >> RCC_CR_HSIDIV_Pos));
              pllvco = ((float_t)hsivalue / (float_t)pllm) * ((float_t)(uint32_t)(RCC->PLL1DIVR1 & RCC_PLL1DIVR1_DIVN) + (fracn1 / (float_t)0x2000) + (float_t)1);
            }
            else
            {
              /* Can't retrieve HSIDIV value */
              pllvco = (float_t)0;
            }
            break;

          case RCC_PLLSOURCE_CSI:  /* CSI used as PLL clock source */
            pllvco = ((float_t)CSI_VALUE / (float_t)pllm) * ((float_t)(uint32_t)(RCC->PLL1DIVR1 & RCC_PLL1DIVR1_DIVN) + (fracn1 / (float_t)0x2000) + (float_t)1);
            break;

          case RCC_PLLSOURCE_HSE:  /* HSE used as PLL clock source */
            pllvco = ((float_t)HSE_VALUE / (float_t)pllm) * ((float_t)(uint32_t)(RCC->PLL1DIVR1 & RCC_PLL1DIVR1_DIVN) + (fracn1 / (float_t)0x2000) + (float_t)1);
            break;

          default:
            pllvco = ((float_t)CSI_VALUE / (float_t)pllm) * ((float_t)(uint32_t)(RCC->PLL1DIVR1 & RCC_PLL1DIVR1_DIVN) + (fracn1 / (float_t)0x2000) + (float_t)1);
            break;
        }
        pllp = (((RCC->PLL1DIVR1 & RCC_PLL1DIVR1_DIVP) >> RCC_PLL1DIVR1_DIVP_Pos) + 1U) ;
        sysclockfreq = (uint32_t)(float_t)(pllvco / (float_t)pllp);
      }
      else
      {
        sysclockfreq = 0U;
      }
      break;

    default:
      sysclockfreq = CSI_VALUE;
      break;
  }

  prescaler = RCC->CDCFGR & RCC_CDCFGR_CPRE;
  if (prescaler >= 8U)
  {
    sysclockfreq = sysclockfreq >> (prescaler - RCC_CDCFGR_CPRE_3 + 1U);
  }

  return sysclockfreq;
}

uint32_t HAL_RCC_GetHCLKFreq(void)
{
  uint32_t clock;
  uint32_t prescaler;
  const uint8_t AHBPrescTable[8] = {1U, 2U, 3U, 4U, 6U, 7U, 8U, 9U};

  /* SysClk */
  clock = HAL_RCC_GetSysClockFreq();
  /* Bus matrix divider */
  prescaler = (RCC->BMCFGR & RCC_BMCFGR_BMPRE) >> RCC_BMCFGR_BMPRE_Pos;
  if (prescaler >= 8U)
  {
    clock = clock >> AHBPrescTable[prescaler - 8U];
  }
  return (clock);
}

uint32_t HAL_RCC_GetPCLK1Freq(void)
{
  uint32_t clock;
  uint32_t prescaler;
  /* Get HCLK source and compute PCLK1 frequency ---------------------------*/
  clock = HAL_RCC_GetHCLKFreq();
  /* APB1 prescaler */
  prescaler = (RCC->APBCFGR & RCC_APBCFGR_PPRE1) >> RCC_APBCFGR_PPRE1_Pos;
  if (prescaler >= 4U)
  {
    clock = clock >> (prescaler - 3U);
  }
  return (clock);
}

uint32_t HAL_RCC_GetPCLK2Freq(void)
{
  uint32_t clock;
  uint32_t prescaler;
  /* Get HCLK source and compute PCLK2 frequency ---------------------------*/
  clock = HAL_RCC_GetHCLKFreq();
  /* APB2 prescaler */
  prescaler = (RCC->APBCFGR & RCC_APBCFGR_PPRE2) >> RCC_APBCFGR_PPRE2_Pos;
  if (prescaler >= 4U)
  {
    clock = clock >> (prescaler - 3U);
  }
  return (clock);
}

uint32_t HAL_RCC_GetPCLK4Freq(void)
{
  uint32_t clock;
  uint32_t prescaler;
  /* Get HCLK source and compute PCLK4 frequency ---------------------------*/
  clock = HAL_RCC_GetHCLKFreq();
  /* APB4 prescaler */
  prescaler = (RCC->APBCFGR & RCC_APBCFGR_PPRE4) >> RCC_APBCFGR_PPRE4_Pos;
  if (prescaler >= 4U)
  {
    clock = clock >> (prescaler - 3U);
  }
  return (clock);
}

uint32_t HAL_RCC_GetPCLK5Freq(void)
{
  uint32_t clock;
  uint32_t prescaler;
  /* Get HCLK source and compute PCLK5 frequency ---------------------------*/
  clock = HAL_RCC_GetHCLKFreq();
  /* APB5 prescaler */
  prescaler = (RCC->APBCFGR & RCC_APBCFGR_PPRE5) >> RCC_APBCFGR_PPRE5_Pos;
  if (prescaler >= 4U)
  {
    clock = clock >> (prescaler - 3U);
  }
  return (clock);
}

uint32_t HAL_RCC_GetPLL1PFreq(void)
{
  uint32_t pllp;

  /* PLL1P divider */
  pllp = ((RCC->PLL1DIVR1 & RCC_PLL1DIVR1_DIVP) >> RCC_PLL1DIVR1_DIVP_Pos) + 1U;

  /* Compute VCO output frequency and return PLL1P one */
  return ((uint32_t)RCC_PLL1_GetVCOOutputFreq() / pllp);
}

uint32_t HAL_RCC_GetPLL1QFreq(void)
{
  uint32_t pllq;

  /* PLL1Q divider */
  pllq = ((RCC->PLL1DIVR1 & RCC_PLL1DIVR1_DIVQ) >> RCC_PLL1DIVR1_DIVQ_Pos) + 1U;

  /* Compute VCO output frequency and return PLL1Q one */
  return ((uint32_t)RCC_PLL1_GetVCOOutputFreq() / pllq);
}

uint32_t HAL_RCC_GetPLL1RFreq(void)
{
  uint32_t pllr;

  /* PLL1R divider */
  pllr = ((RCC->PLL1DIVR1 & RCC_PLL1DIVR1_DIVR) >> RCC_PLL1DIVR1_DIVR_Pos) + 1U;

  /* Compute VCO output frequency and return PLL1R one */
  return ((uint32_t)RCC_PLL1_GetVCOOutputFreq() / pllr);
}

uint32_t HAL_RCC_GetPLL1SFreq(void)
{
  uint32_t plls;

  /* PLL1S divider */
  plls = ((RCC->PLL1DIVR2 & RCC_PLL1DIVR2_DIVS) >> RCC_PLL1DIVR2_DIVS_Pos) + 1U;

  /* Compute VCO output frequency and return PLL1S one */
  return ((uint32_t)RCC_PLL1_GetVCOOutputFreq() / plls);
}

uint32_t HAL_RCC_GetPLL2PFreq(void)
{
  uint32_t pllp;

  /* PLL2P divider */
  pllp = ((RCC->PLL2DIVR1 & RCC_PLL2DIVR1_DIVP) >> RCC_PLL2DIVR1_DIVP_Pos) + 1U;

  /* Compute VCO output frequency and return PLL2P one */
  return ((uint32_t)RCC_PLL2_GetVCOOutputFreq() / pllp);
}

uint32_t HAL_RCC_GetPLL2QFreq(void)
{
  uint32_t pllq;

  /* PLL2Q divider */
  pllq = ((RCC->PLL2DIVR1 & RCC_PLL2DIVR1_DIVQ) >> RCC_PLL2DIVR1_DIVQ_Pos) + 1U;

  /* Compute VCO output frequency and return PLL2Q one */
  return ((uint32_t)RCC_PLL2_GetVCOOutputFreq() / pllq);
}

uint32_t HAL_RCC_GetPLL2RFreq(void)
{
  uint32_t pllr;

  /* PLL2R divider */
  pllr = ((RCC->PLL2DIVR1 & RCC_PLL2DIVR1_DIVR) >> RCC_PLL2DIVR1_DIVR_Pos) + 1U;

  /* Compute VCO output frequency and return PLL2R one */
  return ((uint32_t)RCC_PLL2_GetVCOOutputFreq() / pllr);
}

uint32_t HAL_RCC_GetPLL2SFreq(void)
{
  uint32_t plls;

  /* PLL2S divider */
  plls = ((RCC->PLL2DIVR2 & RCC_PLL2DIVR2_DIVS) >> RCC_PLL2DIVR2_DIVS_Pos) + 1U;

  /* Compute VCO output frequency and return PLL2R one */
  return ((uint32_t)RCC_PLL2_GetVCOOutputFreq() / plls);
}

uint32_t HAL_RCC_GetPLL2TFreq(void)
{
  uint32_t pllt;

  /* PLL2T divider */
  pllt = ((RCC->PLL2DIVR2 & RCC_PLL2DIVR2_DIVT) >> RCC_PLL2DIVR2_DIVT_Pos) + 1U;

  /* Compute VCO output frequency and return PLL2T one */
  return ((uint32_t)RCC_PLL2_GetVCOOutputFreq() / pllt);
}

uint32_t HAL_RCC_GetPLL3PFreq(void)
{
  uint32_t pllp;

  /* PLL3P divider */
  pllp = ((RCC->PLL3DIVR1 & RCC_PLL3DIVR1_DIVP) >> RCC_PLL3DIVR1_DIVP_Pos) + 1U;

  /* Compute VCO output frequency and return PLL3P one */
  return ((uint32_t)RCC_PLL3_GetVCOOutputFreq() / pllp);
}

uint32_t HAL_RCC_GetPLL3QFreq(void)
{
  uint32_t pllq;

  /* PLL3Q divider */
  pllq = ((RCC->PLL3DIVR1 & RCC_PLL3DIVR1_DIVQ) >> RCC_PLL3DIVR1_DIVQ_Pos) + 1U;

  /* Compute VCO output frequency and return PLL3Q one */
  return ((uint32_t)RCC_PLL3_GetVCOOutputFreq() / pllq);
}

uint32_t HAL_RCC_GetPLL3RFreq(void)
{
  uint32_t pllr;

  /* PLL3R divider */
  pllr = ((RCC->PLL3DIVR1 & RCC_PLL3DIVR1_DIVR) >> RCC_PLL3DIVR1_DIVR_Pos) + 1U;

  /* Compute VCO output frequency and return PLL3R one */
  return ((uint32_t)RCC_PLL3_GetVCOOutputFreq() / pllr);
}

uint32_t HAL_RCC_GetPLL3SFreq(void)
{
  uint32_t plls;

  /* PLL3S divider */
  plls = ((RCC->PLL3DIVR2 & RCC_PLL3DIVR2_DIVS) >> RCC_PLL3DIVR2_DIVS_Pos) + 1U;

  /* Compute VCO output frequency and return PLL3S one */
  return ((uint32_t)RCC_PLL3_GetVCOOutputFreq() / plls);
}

static uint32_t RCC_PLL1_GetVCOOutputFreq(void)
{
  uint32_t tmpreg1;
  uint32_t tmpreg2;
  uint32_t pllsrc;
  uint32_t pllm;
  uint32_t plln;
  uint32_t pllfracn;
  float_t frequency;

  /* Get PLL1 CKSELR and DIVR register values */
  tmpreg1 = RCC->PLLCKSELR;
  tmpreg2 = RCC->PLL1DIVR1;

  /* Retrieve PLL1 multiplication factor and divider */
  pllm = (tmpreg1 & RCC_PLLCKSELR_DIVM1) >> RCC_PLLCKSELR_DIVM1_Pos;
  plln = (tmpreg2 & RCC_PLL1DIVR1_DIVN) + 1U;

  if (pllm == 0U)
  {
    /* Prescaler disabled */
    return 0U;
  }

  /* Check if fractional part is enable */
  if ((RCC->PLLCFGR & RCC_PLLCFGR_PLL1FRACEN) != 0U)
  {
    pllfracn = (RCC->PLL1FRACR & RCC_PLL1FRACR_FRACN) >> RCC_PLL1FRACR_FRACN_Pos;
  }
  else
  {
    pllfracn = 0U;
  }

  /* determine PLL source */
  switch (tmpreg1 & RCC_PLLCKSELR_PLLSRC)
  {
    /* HSI used as PLL1 clock source */
    case RCC_PLLSOURCE_HSI:
      if (READ_BIT(RCC->CR, RCC_CR_HSIDIVF) != 0U)
      {
        pllsrc = HSI_VALUE >> ((RCC->CR & RCC_CR_HSIDIV) >> RCC_CR_HSIDIV_Pos);
      }
      else
      {
        /* Can't retrieve HSIDIV value */
        pllsrc = 0U;
      }
      break;

    /* HSE used as PLL1 clock source */
    case RCC_PLLSOURCE_HSE:
      pllsrc = HSE_VALUE;
      break;

    /* CSI used as PLL1 clock source */
    case RCC_PLLSOURCE_CSI:
      pllsrc = CSI_VALUE;
      break;

    default:
      pllsrc = 0U;
      break;
  }
  
  /* Compute VCO output frequency */
  frequency = ((float_t)pllsrc / (float_t)pllm) * ((float_t)plln + ((float_t)pllfracn / (float_t)0x2000U));
  
  return (uint32_t)frequency;
}

static uint32_t RCC_PLL2_GetVCOOutputFreq(void)
{
  uint32_t tmpreg1;
  uint32_t tmpreg2;
  uint32_t pllsrc;
  uint32_t pllm;
  uint32_t plln;
  uint32_t pllfracn;
  float_t frequency;

  /* Get PLL2 CKSELR and DIVR register values */
  tmpreg1 = RCC->PLLCKSELR;
  tmpreg2 = RCC->PLL2DIVR1;

  /* Retrieve PLL2 multiplication factor and divider */
  pllm = (tmpreg1 & RCC_PLLCKSELR_DIVM2) >> RCC_PLLCKSELR_DIVM2_Pos;
  plln = (tmpreg2 & RCC_PLL2DIVR1_DIVN) + 1U;

  if (pllm == 0U)
  {
    /* Prescaler disabled */
    return 0U;
  }

  /* Check if fractional part is enable */
  if ((RCC->PLLCFGR & RCC_PLLCFGR_PLL2FRACEN) != 0U)
  {
    pllfracn = (RCC->PLL2FRACR & RCC_PLL2FRACR_FRACN) >> RCC_PLL2FRACR_FRACN_Pos;
  }
  else
  {
    pllfracn = 0U;
  }

  /* determine PLL source */
  switch (tmpreg1 & RCC_PLLCKSELR_PLLSRC)
  {
    /* HSI used as PLL2 clock source */
    case RCC_PLLSOURCE_HSI:
      if (READ_BIT(RCC->CR, RCC_CR_HSIDIVF) != 0U)
      {
        pllsrc = HSI_VALUE >> ((RCC->CR & RCC_CR_HSIDIV) >> RCC_CR_HSIDIV_Pos);
      }
      else
      {
        /* Can't retrieve HSIDIV value */
        pllsrc = 0U;
      }
      break;

    /* HSE used as PLL2 clock source */
    case RCC_PLLSOURCE_HSE:
      pllsrc = HSE_VALUE;
      break;

    /* CSI used as PLL2 clock source */
    case RCC_PLLSOURCE_CSI:
      pllsrc = CSI_VALUE;
      break;

    default:
      pllsrc = 0U;
      break;
  }

  /* Compute VCO output frequency */
  frequency = ((float_t)pllsrc / (float_t)pllm) * ((float_t)plln + ((float_t)pllfracn / (float_t)0x2000U));
  
  return (uint32_t)frequency;
}

static uint32_t RCC_PLL3_GetVCOOutputFreq(void)
{
  uint32_t tmpreg1;
  uint32_t tmpreg2;
  uint32_t pllsrc;
  uint32_t pllm;
  uint32_t plln;
  uint32_t pllfracn;
  float_t frequency;

  /* Get PLL3 CKSELR and DIVR register values */
  tmpreg1 = RCC->PLLCKSELR;
  tmpreg2 = RCC->PLL3DIVR1;

  /* Retrieve PLL3 multiplication factor and divider */
  pllm = (tmpreg1 & RCC_PLLCKSELR_DIVM3) >> RCC_PLLCKSELR_DIVM3_Pos;
  plln = (tmpreg2 & RCC_PLL3DIVR1_DIVN) + 1U;

  if (pllm == 0U)
  {
    /* Prescaler disabled */
    return 0U;
  }

  /* Check if fractional part is enable */
  if ((RCC->PLLCFGR & RCC_PLLCFGR_PLL3FRACEN) != 0U)
  {
    pllfracn = (RCC->PLL3FRACR & RCC_PLL3FRACR_FRACN) >> RCC_PLL3FRACR_FRACN_Pos;
  }
  else
  {
    pllfracn = 0U;
  }

  /* determine PLL source */
  switch (tmpreg1 & RCC_PLLCKSELR_PLLSRC)
  {
    /* HSI used as PLL3 clock source */
    case RCC_PLLSOURCE_HSI:
      if (READ_BIT(RCC->CR, RCC_CR_HSIDIVF) != 0U)
      {
        pllsrc = HSI_VALUE >> ((RCC->CR & RCC_CR_HSIDIV) >> RCC_CR_HSIDIV_Pos);
      }
      else
      {
        /* Can't retrieve HSIDIV value */
        pllsrc = 0U;
      }
      break;

    /* HSE used as PLL3 clock source */
    case RCC_PLLSOURCE_HSE:
      pllsrc = HSE_VALUE;
      break;

    /* CSI used as PLL3 clock source */
    case RCC_PLLSOURCE_CSI:
      pllsrc = CSI_VALUE;
      break;

    default:
      pllsrc = 0U;
      break;
  }

  /* Compute VCO output frequency */
  frequency = ((float_t)pllsrc / (float_t)pllm) * ((float_t)plln + ((float_t)pllfracn / (float_t)0x2000U));
  
  return (uint32_t)frequency;
}
