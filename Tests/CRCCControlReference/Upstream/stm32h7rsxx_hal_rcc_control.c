/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Unchanged declarations/bodies/macros extracted from STM32H7RS HAL at
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748. Host substitutions are in the shim.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
#define CRCC_CONTROL_IMPLEMENTATION
#include "RCCControlShim.h"

HAL_StatusTypeDef HAL_RCC_DeInit(void)
{
  uint32_t tickstart;

  /* Get Start Tick */
  tickstart = HAL_GetTick();

  /* Set HSION bit */
  SET_BIT(RCC->CR, RCC_CR_HSION);

  /* Wait till HSI is ready */
  while (READ_BIT(RCC->CR, RCC_CR_HSIRDY) == 0U)
  {
    if ((HAL_GetTick() - tickstart) > RCC_HSI_TIMEOUT_VALUE)
    {
      return HAL_TIMEOUT;
    }
  }

  /* Set HSITRIM[6:0] bits to the reset value */
  SET_BIT(RCC->HSICFGR, RCC_HSICFGR_HSITRIM_6);

  if (HAL_RCC_GetHCLKFreq() > HSI_VALUE)
  {
    /* Reset CFGR register (HSI is selected as system clock source) */
    CLEAR_REG(RCC->CFGR);

    /* Update the SystemCoreClock global variables */
    SystemCoreClock = HSI_VALUE;

    /* Adapt Systick interrupt period */
    if (HAL_InitTick(uwTickPrio) != HAL_OK)
    {
      return HAL_ERROR;
    }

    /* Get Start Tick */
    tickstart = HAL_GetTick();

    /* Wait till clock switch is ready */
    while (READ_BIT(RCC->CFGR, RCC_CFGR_SWS) != 0U)
    {
      if ((HAL_GetTick() - tickstart) > RCC_CLOCKSWITCH_TIMEOUT_VALUE)
      {
        return HAL_TIMEOUT;
      }
    }

    /* Reduce flash latency */
    __HAL_FLASH_SET_LATENCY(FLASH_LATENCY_1);
  }
  else
  {
    /* Increase flash latency */
    __HAL_FLASH_SET_LATENCY(FLASH_LATENCY_1);

    /* Reset CFGR register (HSI is selected as system clock source) */
    CLEAR_REG(RCC->CFGR);

    /* Adapt Systick interrupt period */
    if (HAL_InitTick(uwTickPrio) != HAL_OK)
    {
      return HAL_ERROR;
    }

    /* Get Start Tick */
    tickstart = HAL_GetTick();

    /* Wait till clock switch is ready */
    while (READ_BIT(RCC->CFGR, RCC_CFGR_SWS) != 0U)
    {
      if ((HAL_GetTick() - tickstart) > RCC_CLOCKSWITCH_TIMEOUT_VALUE)
      {
        return HAL_TIMEOUT;
      }
    }
  }


  /* Get Start Tick */
  tickstart = HAL_GetTick();

  /* Reset CSION, CSIKERON, HSEON, HSI48ON, HSECSSON, HSIDIV bits */
  CLEAR_BIT(RCC->CR, RCC_CR_HSEON | RCC_CR_HSIKERON | RCC_CR_HSIDIV |  RCC_CR_CSION | RCC_CR_CSIKERON  \
            | RCC_CR_HSI48ON | RCC_CR_HSECSSON);

  /* Wait till HSE is disabled */
  while (READ_BIT(RCC->CR, RCC_CR_HSERDY) != 0U)
  {
    if ((HAL_GetTick() - tickstart) > RCC_HSE_TIMEOUT_VALUE)
    {
      return HAL_TIMEOUT;
    }
  }

  /* Get Start Tick */
  tickstart = HAL_GetTick();

  /* Clear PLLON bit */
  CLEAR_BIT(RCC->CR, RCC_CR_PLL1ON);

  /* Wait till PLL is disabled */
  while (READ_BIT(RCC->CR, RCC_CR_PLL1RDY) != 0U)
  {
    if ((HAL_GetTick() - tickstart) > RCC_PLL_TIMEOUT_VALUE)
    {
      return HAL_TIMEOUT;
    }
  }

  /* Get Start Tick */
  tickstart = HAL_GetTick();

  /* Reset PLL2ON bit */
  CLEAR_BIT(RCC->CR, RCC_CR_PLL2ON);

  /* Wait till PLL2 is disabled */
  while (READ_BIT(RCC->CR, RCC_CR_PLL2RDY) != 0U)
  {
    if ((HAL_GetTick() - tickstart) > RCC_PLL_TIMEOUT_VALUE)
    {
      return HAL_TIMEOUT;
    }
  }

  /* Get Start Tick */
  tickstart = HAL_GetTick();

  /* Reset PLL3 bit */
  CLEAR_BIT(RCC->CR, RCC_CR_PLL3ON);

  /* Wait till PLL3 is disabled */
  while (READ_BIT(RCC->CR, RCC_CR_PLL3RDY) != 0U)
  {
    if ((HAL_GetTick() - tickstart) > RCC_PLL_TIMEOUT_VALUE)
    {
      return HAL_TIMEOUT;
    }
  }

  /* Reset CDCFGR register */
  CLEAR_REG(RCC->CDCFGR);

  /* Reset BMCFGR register */
  CLEAR_REG(RCC->BMCFGR);

  /* Reset APBCFGR register */
  CLEAR_REG(RCC->APBCFGR);

  /* Reset PLLCKSELR register to default value */
  WRITE_REG(RCC->PLLCKSELR, 0x02020200U);

  /* Reset PLLCFGR register */
  CLEAR_REG(RCC->PLLCFGR);

  /* Reset PLL1DIVR1 register to default value */
  WRITE_REG(RCC->PLL1DIVR1, 0x01010280U);

  /* Reset PLL1DIVR2 register to default value */
  WRITE_REG(RCC->PLL1DIVR2, 0x00000101U);

  /* Reset PLL1FRACR register */
  CLEAR_REG(RCC->PLL1FRACR);

  /* Reset PLL2DIVR1 register to default value */
  WRITE_REG(RCC->PLL2DIVR1, 0x01010280U);

  /* Reset PLL2DIVR2 register to default value */
  WRITE_REG(RCC->PLL2DIVR2, 0x00000101U);

  /* Reset PLL2FRACR register */
  CLEAR_REG(RCC->PLL2FRACR);

  /* Reset PLL3DIVR1 register to default value */
  WRITE_REG(RCC->PLL3DIVR1, 0x01010280U);

  /* Reset PLL3DIVR2 register to default value */
  WRITE_REG(RCC->PLL3DIVR2, 0x00000101U);

  /* Reset PLL3FRACR register */
  CLEAR_REG(RCC->PLL3FRACR);

  /* Reset HSEBYP bit */
  CLEAR_BIT(RCC->CR, RCC_CR_HSEBYP);

  /* Disable all interrupts */
  CLEAR_REG(RCC->CIER);

  /* Clear all interrupts flags */
  WRITE_REG(RCC->CICR, 0xFFFFFFFFU);

  /* Reset all RSR flags */
  SET_BIT(RCC->RSR, RCC_RSR_RMVF);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RCC_OscConfig(RCC_OscInitTypeDef  *RCC_OscInitStruct)
{
  uint32_t tickstart;
  uint32_t sysclksrc;
  uint32_t pllsrc;
  uint32_t pllrdy;
  uint32_t tmpreg1;

  /* Check Null pointer */
  if (RCC_OscInitStruct == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_RCC_OSCILLATORTYPE(RCC_OscInitStruct->OscillatorType));

  sysclksrc = __HAL_RCC_GET_SYSCLK_SOURCE();
  pllsrc = __HAL_RCC_GET_PLL_OSCSOURCE();
  pllrdy = RCC->CR & (RCC_CR_PLL1RDY | RCC_CR_PLL2RDY | RCC_CR_PLL3RDY);

  /*------------------------------- HSE Configuration ------------------------*/
  if (((RCC_OscInitStruct->OscillatorType) & RCC_OSCILLATORTYPE_HSE) == RCC_OSCILLATORTYPE_HSE)
  {
    /* Check the parameters */
    assert_param(IS_RCC_HSE(RCC_OscInitStruct->HSEState));

    /* When the HSE is used as system clock or clock source for PLL in these cases HSE will not disabled */
    if ((sysclksrc == RCC_SYSCLKSOURCE_STATUS_HSE) ||
        ((pllrdy != 0U) && (pllsrc == RCC_PLLSOURCE_HSE)))
    {
      if (RCC_OscInitStruct->HSEState == RCC_HSE_OFF)
      {
        return HAL_ERROR;
      }
    }
    else
    {
      /* Set the new HSE configuration ---------------------------------------*/
      __HAL_RCC_HSE_CONFIG(RCC_OscInitStruct->HSEState);

      /* Get Start Tick*/
      tickstart = HAL_GetTick();

      /* Check the HSE State */
      if (RCC_OscInitStruct->HSEState != RCC_HSE_OFF)
      {
        /* Wait till HSE is ready */
        while (READ_BIT(RCC->CR, RCC_CR_HSERDY) == 0U)
        {
          if ((HAL_GetTick() - tickstart) > RCC_HSE_TIMEOUT_VALUE)
          {
            return HAL_TIMEOUT;
          }
        }
      }
      else
      {
        /* Wait till HSE is disabled */
        while (READ_BIT(RCC->CR, RCC_CR_HSERDY) != 0U)
        {
          if ((HAL_GetTick() - tickstart) > RCC_HSE_TIMEOUT_VALUE)
          {
            return HAL_TIMEOUT;
          }
        }
      }
    }
  }
  /*----------------------------- HSI Configuration --------------------------*/
  if (((RCC_OscInitStruct->OscillatorType) & RCC_OSCILLATORTYPE_HSI) == RCC_OSCILLATORTYPE_HSI)
  {
    /* Check the parameters */
    assert_param(IS_RCC_HSI(RCC_OscInitStruct->HSIState));
    assert_param(IS_RCC_HSICALIBRATION_VALUE(RCC_OscInitStruct->HSICalibrationValue));

    /* Check if HSI is used as system clock or as PLL1 source when PLL1 is selected as system clock */
    if ((sysclksrc == RCC_SYSCLKSOURCE_STATUS_HSI) ||
        ((pllrdy != 0U) && (pllsrc == RCC_PLLSOURCE_HSI)))
    {
      /* When HSI is used as system clock it will not be disabled */
      if (RCC_OscInitStruct->HSIState == RCC_HSI_OFF)
      {
        return HAL_ERROR;
      }
      /* Otherwise, calibration is allowed, divider update also unless used for any enabled PLL */
      else
      {
        /* HSI must not be used as reference clock for any enabled PLL clock source */
        tmpreg1 = (RCC->CR & RCC_CR_HSIDIV);
        if ((pllsrc == RCC_PLLSOURCE_HSI) && (pllrdy != 0U) && \
            (tmpreg1 != RCC_OscInitStruct->HSIDiv))
        {
          return HAL_ERROR;
        }

        assert_param(IS_RCC_HSIDIV(RCC_OscInitStruct->HSIDiv));

        /* Set the Internal High Speed oscillator new divider */
        __HAL_RCC_HSI_CONFIG(RCC_HSI_ON | RCC_OscInitStruct->HSIDiv);

        if (sysclksrc == RCC_SYSCLKSOURCE_STATUS_HSI)
        {
          SystemCoreClock = (HSI_VALUE / (1UL << ((READ_BIT(RCC->CR, RCC_CR_HSIDIV)) >> RCC_CR_HSIDIV_Pos)));
        }
        /* Adapt Systick interrupt period */
        if (HAL_InitTick(uwTickPrio) != HAL_OK)
        {
          return HAL_ERROR;
        }
      }
      /* Adjusts the Internal High Speed oscillator (HSI) calibration value.*/
      __HAL_RCC_HSI_CALIBRATIONVALUE_ADJUST(RCC_OscInitStruct->HSICalibrationValue);
    }
    else
    {
      /* Check the HSI State */
      if (RCC_OscInitStruct->HSIState != RCC_HSI_OFF)
      {
        /* Enable the Internal High Speed oscillator */
        __HAL_RCC_HSI_CONFIG(RCC_OscInitStruct->HSIState | RCC_OscInitStruct->HSIDiv);

        /* Adjusts the Internal High Speed oscillator (HSI) calibration value.*/
        __HAL_RCC_HSI_CALIBRATIONVALUE_ADJUST(RCC_OscInitStruct->HSICalibrationValue);

        /* Get Start Tick*/
        tickstart = HAL_GetTick();

        /* Wait till HSI is ready */
        while (READ_BIT(RCC->CR, RCC_CR_HSIRDY) == 0U)
        {
          if ((HAL_GetTick() - tickstart) > RCC_HSI_TIMEOUT_VALUE)
          {
            return HAL_TIMEOUT;
          }
        }
      }
      else
      {
        /* Disable the Internal High Speed oscillator (HSI). */
        __HAL_RCC_HSI_DISABLE();

        /* Get Start Tick*/
        tickstart = HAL_GetTick();

        /* Wait till HSI is disabled */
        while (READ_BIT(RCC->CR, RCC_CR_HSIRDY) != 0U)
        {
          if ((HAL_GetTick() - tickstart) > RCC_HSI_TIMEOUT_VALUE)
          {
            return HAL_TIMEOUT;
          }
        }
      }
    }
  }
  /*----------------------------- CSI Configuration --------------------------*/
  if (((RCC_OscInitStruct->OscillatorType) & RCC_OSCILLATORTYPE_CSI) == RCC_OSCILLATORTYPE_CSI)
  {
    /* Check the parameters */
    assert_param(IS_RCC_CSI(RCC_OscInitStruct->CSIState));

    /* When the CSI is used as system clock it will not disabled */
    if ((sysclksrc == RCC_SYSCLKSOURCE_STATUS_CSI) ||
        ((pllrdy != 0U) && (pllsrc == RCC_PLLSOURCE_CSI)))
    {
      /* When CSI is used as system clock it will not disabled */
      if (RCC_OscInitStruct->CSIState == RCC_CSI_OFF)
      {
        return HAL_ERROR;
      }
    }
    else
    {
      /* Check the CSI State */
      if ((RCC_OscInitStruct->CSIState) != RCC_CSI_OFF)
      {
        /* Enable the Internal High Speed oscillator (CSI). */
        __HAL_RCC_CSI_ENABLE();

        /* Get Start Tick*/
        tickstart = HAL_GetTick();

        /* Wait till CSI is ready */
        while (READ_BIT(RCC->CR, RCC_CR_CSIRDY) == 0U)
        {
          if ((HAL_GetTick() - tickstart) > RCC_CSI_TIMEOUT_VALUE)
          {
            return HAL_TIMEOUT;
          }
        }
      }
      else
      {
        /* Disable the Internal High Speed oscillator (CSI). */
        __HAL_RCC_CSI_DISABLE();

        /* Get Start Tick*/
        tickstart = HAL_GetTick();

        /* Wait till CSI is disabled */
        while (READ_BIT(RCC->CR, RCC_CR_CSIRDY) != 0U)
        {
          if ((HAL_GetTick() - tickstart) > RCC_CSI_TIMEOUT_VALUE)
          {
            return HAL_TIMEOUT;
          }
        }
      }
    }
  }
  /*------------------------------ LSI Configuration -------------------------*/
  if (((RCC_OscInitStruct->OscillatorType) & RCC_OSCILLATORTYPE_LSI) == RCC_OSCILLATORTYPE_LSI)
  {
    /* Check the parameters */
    assert_param(IS_RCC_LSI(RCC_OscInitStruct->LSIState));

    /* Check the LSI State */
    if ((RCC_OscInitStruct->LSIState) != RCC_LSI_OFF)
    {
      /* Enable the Internal Low Speed oscillator (LSI). */
      __HAL_RCC_LSI_ENABLE();

      /* Get Start Tick*/
      tickstart = HAL_GetTick();

      /* Wait till LSI is ready */
      while (READ_BIT(RCC->CSR, RCC_CSR_LSIRDY) == 0U)
      {
        if ((HAL_GetTick() - tickstart) > RCC_LSI_TIMEOUT_VALUE)
        {
          return HAL_TIMEOUT;
        }
      }
    }
    else
    {
      /* Disable the Internal Low Speed oscillator (LSI). */
      __HAL_RCC_LSI_DISABLE();

      /* Get Start Tick*/
      tickstart = HAL_GetTick();

      /* Wait till LSI is ready */
      while (READ_BIT(RCC->CSR, RCC_CSR_LSIRDY) != 0U)
      {
        if ((HAL_GetTick() - tickstart) > RCC_LSI_TIMEOUT_VALUE)
        {
          return HAL_TIMEOUT;
        }
      }
    }
  }

  /*------------------------------ HSI48 Configuration -------------------------*/
  if (((RCC_OscInitStruct->OscillatorType) & RCC_OSCILLATORTYPE_HSI48) == RCC_OSCILLATORTYPE_HSI48)
  {
    /* Check the parameters */
    assert_param(IS_RCC_HSI48(RCC_OscInitStruct->HSI48State));

    /* Check the HSI48 State */
    if ((RCC_OscInitStruct->HSI48State) != RCC_HSI48_OFF)
    {
      /* Enable the Internal Low Speed oscillator (HSI48). */
      __HAL_RCC_HSI48_ENABLE();

      /* Get time-out */
      tickstart = HAL_GetTick();

      /* Wait till HSI48 is ready */
      while (READ_BIT(RCC->CR, RCC_CR_HSI48RDY) == 0U)
      {
        if ((HAL_GetTick() - tickstart) > RCC_HSI48_TIMEOUT_VALUE)
        {
          return HAL_TIMEOUT;
        }
      }
    }
    else
    {
      /* Disable the Internal Low Speed oscillator (HSI48). */
      __HAL_RCC_HSI48_DISABLE();

      /* Get time-out */
      tickstart = HAL_GetTick();

      /* Wait till HSI48 is ready */
      while (READ_BIT(RCC->CR, RCC_CR_HSI48RDY) != 0U)
      {
        if ((HAL_GetTick() - tickstart) > RCC_HSI48_TIMEOUT_VALUE)
        {
          return HAL_TIMEOUT;
        }
      }
    }
  }
  /*------------------------------ LSE Configuration -------------------------*/
  if (((RCC_OscInitStruct->OscillatorType) & RCC_OSCILLATORTYPE_LSE) == RCC_OSCILLATORTYPE_LSE)
  {
    /* Check the parameters */
    assert_param(IS_RCC_LSE(RCC_OscInitStruct->LSEState));

    /* Enable write access to Backup domain */
    PWR->CR1 |= PWR_CR1_DBP;

    /* Set the new LSE configuration -----------------------------------------*/
    __HAL_RCC_LSE_CONFIG(RCC_OscInitStruct->LSEState);
    /* Check the LSE State */
    if ((RCC_OscInitStruct->LSEState) != RCC_LSE_OFF)
    {
      /* Get Start Tick*/
      tickstart = HAL_GetTick();

      /* Wait till LSE is ready */
      while (READ_BIT(RCC->BDCR, RCC_BDCR_LSERDY) == 0U)
      {
        if ((HAL_GetTick() - tickstart) > RCC_LSE_TIMEOUT_VALUE)
        {
          return HAL_TIMEOUT;
        }
      }
    }
    else
    {
      /* Get Start Tick*/
      tickstart = HAL_GetTick();

      /* Wait till LSE is disabled */
      while (READ_BIT(RCC->BDCR, RCC_BDCR_LSERDY) != 0U)
      {
        if ((HAL_GetTick() - tickstart) > RCC_LSE_TIMEOUT_VALUE)
        {
          return HAL_TIMEOUT;
        }
      }
    }
  }

  /*-------------------------------- PLL1 Configuration ----------------------*/
  /* Check the parameters */
  assert_param(IS_RCC_PLL(RCC_OscInitStruct->PLL1.PLLState));

  if (RCC_OscInitStruct->PLL1.PLLState != RCC_PLL_NONE)
  {
    /* Check if the PLL is used as system clock or not */
    if (sysclksrc == RCC_SYSCLKSOURCE_STATUS_PLLCLK)
    {
      /* No PLL off possible */
      if (RCC_OscInitStruct->PLL1.PLLState == RCC_PLL_OFF)
      {
        return HAL_ERROR;
      }
      else
      {
        /* Check if only fractional part needs to be updated  */
        tmpreg1 = ((RCC->PLL1FRACR & RCC_PLL1FRACR_FRACN) >> RCC_PLL1FRACR_FRACN_Pos);

        if (RCC_OscInitStruct->PLL1.PLLFractional != tmpreg1)
        {
          assert_param(IS_RCC_PLLFRACN_VALUE(RCC_OscInitStruct->PLL1.PLLFractional));

          /* Disable PLL1FRACLE */
          __HAL_RCC_PLL1_FRACN_DISABLE();

          /* Get Start Tick*/
          tickstart = HAL_GetTick();

          /* Wait at least 2 CK_REF (PLL input source divided by M) period to make sure next latched value will be taken into account. */
          while ((HAL_GetTick() - tickstart) < RCC_PLL_FRAC_WAIT_VALUE)
          {
            /* Do nothing */
          }

          /* Configure PLL1FRACN */
          __HAL_RCC_PLL1_FRACN_CONFIG(RCC_OscInitStruct->PLL1.PLLFractional);

          /* Enable PLL1FRACLE to latch new value . */
          __HAL_RCC_PLL1_FRACN_ENABLE();
        }
      }
    }
    else
    {
      /* Initialize PLL1T to 1 to use common PLL initialization function */
      RCC_OscInitStruct->PLL1.PLLT = 1U;
      if (RCC_PLL_Config(RCC_PLL1_CONFIG, &(RCC_OscInitStruct->PLL1)) != HAL_OK)
      {
        return HAL_ERROR;
      }
    }
  }

  /*-------------------------------- PLL2 Configuration ----------------------*/
  /* Check the parameters */
  assert_param(IS_RCC_PLL(RCC_OscInitStruct->PLL2.PLLState));

  if (RCC_OscInitStruct->PLL2.PLLState != RCC_PLL_NONE)
  {
    if (RCC_PLL_Config(RCC_PLL2_CONFIG, &(RCC_OscInitStruct->PLL2)) != HAL_OK)
    {
      return HAL_ERROR;
    }
  }

  /*-------------------------------- PLL3 Configuration ----------------------*/
  /* Check the parameters */
  assert_param(IS_RCC_PLL(RCC_OscInitStruct->PLL3.PLLState));

  if (RCC_OscInitStruct->PLL3.PLLState != RCC_PLL_NONE)
  {
    /* Initialize PLL3T to 1 to use common PLL initialization function */
    RCC_OscInitStruct->PLL3.PLLT = 1U;
    if (RCC_PLL_Config(RCC_PLL3_CONFIG, &(RCC_OscInitStruct->PLL3)) != HAL_OK)
    {
      return HAL_ERROR;
    }
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_RCC_ClockConfig(const RCC_ClkInitTypeDef  *RCC_ClkInitStruct, uint32_t FLatency)
{
  HAL_StatusTypeDef halstatus;
  uint32_t tickstart;

  /* Check Null pointer */
  if (RCC_ClkInitStruct == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_RCC_CLOCKTYPE(RCC_ClkInitStruct->ClockType));
  assert_param(IS_FLASH_LATENCY(FLatency));

  /* To correctly read data from FLASH memory, the number of wait states (LATENCY)
    must be correctly programmed according to the frequency of the CPU clock
    (HCLK) and the supply voltage of the device. */

  /* Increasing the CPU frequency */
  if (FLatency > __HAL_FLASH_GET_LATENCY())
  {
    /* Program the new number of wait states to the LATENCY bits in the FLASH_ACR register */
    __HAL_FLASH_SET_LATENCY(FLatency);

    /* Check that the new number of wait states is taken into account to access the Flash
    memory by reading the FLASH_ACR register */
    if (__HAL_FLASH_GET_LATENCY() != FLatency)
    {
      return HAL_ERROR;
    }

  }

  /* Increasing the BUS frequency divider ? */

  /*-------------------------- PCLK1 Configuration ---------------------------*/
  if (((RCC_ClkInitStruct->ClockType) & RCC_CLOCKTYPE_PCLK1) == RCC_CLOCKTYPE_PCLK1)
  {
    assert_param(IS_RCC_PCLK1(RCC_ClkInitStruct->APB1CLKDivider));
    if ((RCC_ClkInitStruct->APB1CLKDivider) > (RCC->APBCFGR & RCC_APBCFGR_PPRE1))
    {
      MODIFY_REG(RCC->APBCFGR, RCC_APBCFGR_PPRE1, (RCC_ClkInitStruct->APB1CLKDivider));
    }
  }

  /*-------------------------- PCLK2 Configuration ---------------------------*/
  if (((RCC_ClkInitStruct->ClockType) & RCC_CLOCKTYPE_PCLK2) == RCC_CLOCKTYPE_PCLK2)
  {
    assert_param(IS_RCC_PCLK2(RCC_ClkInitStruct->APB2CLKDivider));
    if ((RCC_ClkInitStruct->APB2CLKDivider) > (RCC->APBCFGR & RCC_APBCFGR_PPRE2))
    {
      MODIFY_REG(RCC->APBCFGR, RCC_APBCFGR_PPRE2, (RCC_ClkInitStruct->APB2CLKDivider));
    }
  }

  /*-------------------------- PCLK4 Configuration ---------------------------*/
  if (((RCC_ClkInitStruct->ClockType) & RCC_CLOCKTYPE_PCLK4) == RCC_CLOCKTYPE_PCLK4)
  {
    assert_param(IS_RCC_PCLK4(RCC_ClkInitStruct->APB4CLKDivider));
    if ((RCC_ClkInitStruct->APB4CLKDivider) > (RCC->APBCFGR & RCC_APBCFGR_PPRE4))
    {
      MODIFY_REG(RCC->APBCFGR, RCC_APBCFGR_PPRE4, (RCC_ClkInitStruct->APB4CLKDivider));
    }
  }

  /*-------------------------- PCLK5 Configuration ---------------------------*/
  if (((RCC_ClkInitStruct->ClockType) & RCC_CLOCKTYPE_PCLK5) == RCC_CLOCKTYPE_PCLK5)
  {
    assert_param(IS_RCC_PCLK5(RCC_ClkInitStruct->APB5CLKDivider));
    if ((RCC_ClkInitStruct->APB5CLKDivider) > (RCC->APBCFGR & RCC_APBCFGR_PPRE5))
    {
      MODIFY_REG(RCC->APBCFGR, RCC_APBCFGR_PPRE5, (RCC_ClkInitStruct->APB5CLKDivider));
    }
  }

  /*-------------------------- HCLK Configuration --------------------------*/
  if (((RCC_ClkInitStruct->ClockType) & RCC_CLOCKTYPE_HCLK) == RCC_CLOCKTYPE_HCLK)
  {
    assert_param(IS_RCC_HCLK(RCC_ClkInitStruct->AHBCLKDivider));
    if ((RCC_ClkInitStruct->AHBCLKDivider) > (RCC->BMCFGR & RCC_BMCFGR_BMPRE))
    {
      /* Set the new HCLK clock divider */
      MODIFY_REG(RCC->BMCFGR, RCC_BMCFGR_BMPRE, RCC_ClkInitStruct->AHBCLKDivider);
    }
  }

  /*------------------------- SYSCLK Configuration -------------------------*/
  if ((RCC_ClkInitStruct->ClockType & RCC_CLOCKTYPE_SYSCLK) == RCC_CLOCKTYPE_SYSCLK)
  {
    assert_param(IS_RCC_SYSCLKSOURCE(RCC_ClkInitStruct->SYSCLKSource));
    assert_param(IS_RCC_SYSCLK(RCC_ClkInitStruct->SYSCLKDivider));
    MODIFY_REG(RCC->CDCFGR, RCC_CDCFGR_CPRE, RCC_ClkInitStruct->SYSCLKDivider);

    /* HSE is selected as System Clock Source */
    if (RCC_ClkInitStruct->SYSCLKSource == RCC_SYSCLKSOURCE_HSE)
    {
      /* Check the HSE ready flag */
      if (READ_BIT(RCC->CR, RCC_CR_HSERDY) == 0U)
      {
        return HAL_ERROR;
      }
    }
    /* PLL is selected as System Clock Source */
    else if (RCC_ClkInitStruct->SYSCLKSource == RCC_SYSCLKSOURCE_PLLCLK)
    {
      /* Check the PLL ready flag */
      if (READ_BIT(RCC->CR, RCC_CR_PLL1RDY) == 0U)
      {
        return HAL_ERROR;
      }
    }
    /* CSI is selected as System Clock Source */
    else if (RCC_ClkInitStruct->SYSCLKSource == RCC_SYSCLKSOURCE_CSI)
    {
      /* Check the PLL ready flag */
      if (READ_BIT(RCC->CR, RCC_CR_CSIRDY) == 0U)
      {
        return HAL_ERROR;
      }
    }
    /* HSI is selected as System Clock Source */
    else
    {
      /* Check the HSI ready flag */
      if (READ_BIT(RCC->CR, RCC_CR_HSIRDY) == 0U)
      {
        return HAL_ERROR;
      }
    }
    MODIFY_REG(RCC->CFGR, RCC_CFGR_SW, RCC_ClkInitStruct->SYSCLKSource);

    /* Get Start Tick*/
    tickstart = HAL_GetTick();

    while (__HAL_RCC_GET_SYSCLK_SOURCE() != (RCC_ClkInitStruct->SYSCLKSource << RCC_CFGR_SWS_Pos))
    {
      if ((HAL_GetTick() - tickstart) > RCC_CLOCKSWITCH_TIMEOUT_VALUE)
      {
        return HAL_TIMEOUT;
      }
    }
  }

  /* Decreasing the BUS frequency divider ? */

  /*-------------------------- HCLK Configuration --------------------------*/
  if (((RCC_ClkInitStruct->ClockType) & RCC_CLOCKTYPE_HCLK) == RCC_CLOCKTYPE_HCLK)
  {
    assert_param(IS_RCC_HCLK(RCC_ClkInitStruct->AHBCLKDivider));
    if ((RCC_ClkInitStruct->AHBCLKDivider) < (RCC->BMCFGR & RCC_BMCFGR_BMPRE))
    {
      /* Set the new HCLK clock divider */
      MODIFY_REG(RCC->BMCFGR, RCC_BMCFGR_BMPRE, RCC_ClkInitStruct->AHBCLKDivider);
    }
  }

  /* Decreasing the number of wait states because of lower CPU frequency */
  if (FLatency < __HAL_FLASH_GET_LATENCY())
  {
    /* Program the new number of wait states to the LATENCY bits in the FLASH_ACR register */
    __HAL_FLASH_SET_LATENCY(FLatency);

    /* Check that the new number of wait states is taken into account to access the Flash
    memory by reading the FLASH_ACR register */
    if (__HAL_FLASH_GET_LATENCY() != FLatency)
    {
      return HAL_ERROR;
    }
  }

  /*-------------------------- PCLK1 Configuration ---------------------------*/
  if (((RCC_ClkInitStruct->ClockType) & RCC_CLOCKTYPE_PCLK1) == RCC_CLOCKTYPE_PCLK1)
  {
    assert_param(IS_RCC_PCLK1(RCC_ClkInitStruct->APB1CLKDivider));
    if ((RCC_ClkInitStruct->APB1CLKDivider) < (RCC->APBCFGR & RCC_APBCFGR_PPRE1))
    {
      MODIFY_REG(RCC->APBCFGR, RCC_APBCFGR_PPRE1, (RCC_ClkInitStruct->APB1CLKDivider));
    }
  }

  /*-------------------------- PCLK2 Configuration ---------------------------*/
  if (((RCC_ClkInitStruct->ClockType) & RCC_CLOCKTYPE_PCLK2) == RCC_CLOCKTYPE_PCLK2)
  {
    assert_param(IS_RCC_PCLK2(RCC_ClkInitStruct->APB2CLKDivider));
    if ((RCC_ClkInitStruct->APB2CLKDivider) < (RCC->APBCFGR & RCC_APBCFGR_PPRE2))
    {
      MODIFY_REG(RCC->APBCFGR, RCC_APBCFGR_PPRE2, (RCC_ClkInitStruct->APB2CLKDivider));
    }
  }

  /*-------------------------- PCLK4 Configuration ---------------------------*/
  if (((RCC_ClkInitStruct->ClockType) & RCC_CLOCKTYPE_PCLK4) == RCC_CLOCKTYPE_PCLK4)
  {
    assert_param(IS_RCC_PCLK4(RCC_ClkInitStruct->APB4CLKDivider));
    if ((RCC_ClkInitStruct->APB4CLKDivider) < (RCC->APBCFGR & RCC_APBCFGR_PPRE4))
    {
      MODIFY_REG(RCC->APBCFGR, RCC_APBCFGR_PPRE4, (RCC_ClkInitStruct->APB4CLKDivider));
    }
  }

  /*-------------------------- PCLK5 Configuration ---------------------------*/
  if (((RCC_ClkInitStruct->ClockType) & RCC_CLOCKTYPE_PCLK5) == RCC_CLOCKTYPE_PCLK5)
  {
    assert_param(IS_RCC_PCLK5(RCC_ClkInitStruct->APB5CLKDivider));
    if ((RCC_ClkInitStruct->APB5CLKDivider) < (RCC->APBCFGR & RCC_APBCFGR_PPRE5))
    {
      MODIFY_REG(RCC->APBCFGR, RCC_APBCFGR_PPRE5, (RCC_ClkInitStruct->APB5CLKDivider));
    }
  }

  /* Update the SystemCoreClock global variable with the System CPU clock */
  SystemCoreClock = HAL_RCC_GetSysClockFreq();

  /* Configure the source of time base considering new system clocks settings*/
  halstatus = HAL_InitTick(uwTickPrio);

  return halstatus;
}

void HAL_RCC_MCOConfig(uint32_t RCC_MCOx, uint32_t RCC_MCOSource, uint32_t RCC_MCODiv)
{
#if defined(HAL_GPIO_MODULE_ENABLED)
  GPIO_InitTypeDef GPIO_InitStruct;
  uint32_t mcoindex;
  uint32_t mco_gpio_index;
  GPIO_TypeDef *mco_gpio_port;

  /* Check the parameters */
  assert_param(IS_RCC_MCO(RCC_MCOx));

  /* Common GPIO init parameters */
  GPIO_InitStruct.Mode      = GPIO_MODE_AF_PP;
  GPIO_InitStruct.Speed     = GPIO_SPEED_FREQ_VERY_HIGH;
  GPIO_InitStruct.Pull      = GPIO_NOPULL;

  /* Get MCOx selection */
  mcoindex = RCC_MCOx & RCC_MCO_INDEX_MASK;

  /* Get MCOx GPIO Port */
  mco_gpio_port = (GPIO_TypeDef *) RCC_GET_MCO_GPIO_PORT(RCC_MCOx);

  /* MCOx Clock Enable */
  mco_gpio_index = RCC_GET_MCO_GPIO_INDEX(RCC_MCOx);
  SET_BIT(RCC->AHB4ENR, (1UL << mco_gpio_index));

  /* Configure the MCOx pin in alternate function mode */
  GPIO_InitStruct.Pin = RCC_GET_MCO_GPIO_PIN(RCC_MCOx);
  GPIO_InitStruct.Alternate = RCC_GET_MCO_GPIO_AF(RCC_MCOx);
  HAL_GPIO_Init(mco_gpio_port, &GPIO_InitStruct);

  if (mcoindex == RCC_MCO1_INDEX)
  {
    assert_param(IS_RCC_MCODIV(RCC_MCODiv));
    assert_param(IS_RCC_MCO1SOURCE(RCC_MCOSource));
    /* Mask MCOSEL[] and MCOPRE[] bits then set MCO clock source and prescaler */
    MODIFY_REG(RCC->CFGR, (RCC_CFGR_MCO1SEL | RCC_CFGR_MCO1PRE), (RCC_MCOSource | RCC_MCODiv));
  }
  else if (mcoindex == RCC_MCO2_INDEX)
  {
    assert_param(IS_RCC_MCODIV(RCC_MCODiv));
    assert_param(IS_RCC_MCO2SOURCE(RCC_MCOSource));
    /* Mask MCOSEL[] and MCOPRE[] bits then set MCO clock source and prescaler */
    MODIFY_REG(RCC->CFGR, (RCC_CFGR_MCO2SEL | RCC_CFGR_MCO2PRE), (RCC_MCOSource | (RCC_MCODiv << 7)));
  }
  else
  {
    /* Do nothing */
  }

#endif /* HAL_GPIO_MODULE_ENABLED */
}

void HAL_RCC_EnableCSS(void)
{
  SET_BIT(RCC->CR, RCC_CR_HSECSSON);
}

void HAL_RCC_DisableCSS(void)
{
  CLEAR_BIT(RCC->CR, RCC_CR_HSECSSON);
}

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

void HAL_RCC_GetOscConfig(RCC_OscInitTypeDef  *RCC_OscInitStruct)
{

  uint32_t regvalue;
  uint32_t mask;

  /* Check the parameters */
  assert_param(RCC_OscInitStruct != (void *)NULL);

  /* Set all possible values for the Oscillator type parameter ---------------*/
  RCC_OscInitStruct->OscillatorType = RCC_OSCILLATORTYPE_HSE | RCC_OSCILLATORTYPE_HSI | RCC_OSCILLATORTYPE_CSI | \
                                      RCC_OSCILLATORTYPE_LSE | RCC_OSCILLATORTYPE_LSI | RCC_OSCILLATORTYPE_HSI48;

  /* Get Backup Domain register  */
  regvalue = RCC->BDCR;

  /* Get the LSE configuration -----------------------------------------------*/
  mask = (RCC_BDCR_LSEBYP | RCC_BDCR_LSEEXT | RCC_BDCR_LSEON);
  RCC_OscInitStruct->LSEState = (regvalue & mask);

  /* Get RCC clock control and status register */
  regvalue = RCC->CSR;

  /* Get the LSI configuration -----------------------------------------------*/
  mask = RCC_CSR_LSION;
  RCC_OscInitStruct->LSIState = (regvalue & mask);

  /* Get Control register */
  regvalue = RCC->CR;

  /* Get the HSE configuration -----------------------------------------------*/
  mask = (RCC_CR_HSEBYP | RCC_CR_HSEEXT | RCC_CR_HSEON);
  RCC_OscInitStruct->HSEState = (regvalue & mask);

  /* Get the HSI configuration -----------------------------------------------*/
  mask = RCC_CR_HSION;
  RCC_OscInitStruct->HSIState = (regvalue & mask);
  RCC_OscInitStruct->HSIDiv = (regvalue & RCC_CR_HSIDIV);
  RCC_OscInitStruct->HSICalibrationValue = ((RCC->HSICFGR & RCC_HSICFGR_HSITRIM) >> RCC_HSICFGR_HSITRIM_Pos);

  /* Get the HSI48 configuration ---------------------------------------------*/
  mask = RCC_CR_HSI48ON;
  RCC_OscInitStruct->HSI48State = (regvalue & mask);

  /* Get the CSI configuration -----------------------------------------------*/
  mask = RCC_CR_CSION;
  RCC_OscInitStruct->CSIState = (regvalue & mask);

  /* Get the PLL1 configuration -----------------------------------------------*/
  if ((regvalue & RCC_CR_PLL1ON) == RCC_CR_PLL1ON)
  {
    RCC_OscInitStruct->PLL1.PLLState = RCC_PLL_ON;
  }
  else
  {
    RCC_OscInitStruct->PLL1.PLLState = RCC_PLL_OFF;
  }

  /* Get PLL1 configuration register */
  regvalue = RCC->PLLCKSELR;
  RCC_OscInitStruct->PLL1.PLLSource = (regvalue & RCC_PLLCKSELR_PLLSRC);
  RCC_OscInitStruct->PLL1.PLLM = ((regvalue & RCC_PLLCKSELR_DIVM1) >> RCC_PLLCKSELR_DIVM1_Pos);

  /* Check if fractional part is enable */
  regvalue = RCC->PLLCFGR;
  if ((regvalue & RCC_PLLCFGR_PLL1FRACEN) != 0x00u)
  {
    regvalue = (((RCC->PLL1FRACR & RCC_PLL1FRACR_FRACN) >> RCC_PLL1FRACR_FRACN_Pos));
  }
  else
  {
    regvalue = 0;
  }
  RCC_OscInitStruct->PLL1.PLLFractional = regvalue;

  /* Get PLL1 dividers register */
  regvalue = RCC->PLL1DIVR1;
  RCC_OscInitStruct->PLL1.PLLN = ((regvalue & RCC_PLL1DIVR1_DIVN) + 1U);
  RCC_OscInitStruct->PLL1.PLLR = (((regvalue & RCC_PLL1DIVR1_DIVR) >> RCC_PLL1DIVR1_DIVR_Pos) + 1U);
  RCC_OscInitStruct->PLL1.PLLP = (((regvalue & RCC_PLL1DIVR1_DIVP) >> RCC_PLL1DIVR1_DIVP_Pos) + 1U);
  RCC_OscInitStruct->PLL1.PLLQ = (((regvalue & RCC_PLL1DIVR1_DIVQ) >> RCC_PLL1DIVR1_DIVQ_Pos) + 1U);
  regvalue = RCC->PLL1DIVR2;
  RCC_OscInitStruct->PLL1.PLLS = (((regvalue & RCC_PLL1DIVR2_DIVS) >> RCC_PLL1DIVR2_DIVS_Pos) + 1U);
  RCC_OscInitStruct->PLL1.PLLT = 0;

  /* Get the PLL2 configuration -----------------------------------------------*/
  /* Get Control register */
  regvalue = RCC->CR;
  if ((regvalue & RCC_CR_PLL2ON) == RCC_CR_PLL2ON)
  {
    RCC_OscInitStruct->PLL2.PLLState = RCC_PLL_ON;
  }
  else
  {
    RCC_OscInitStruct->PLL2.PLLState = RCC_PLL_OFF;
  }

  /* Get PLL2 configuration register */
  regvalue = RCC->PLLCKSELR;
  RCC_OscInitStruct->PLL2.PLLSource = (regvalue & RCC_PLLCKSELR_PLLSRC);
  RCC_OscInitStruct->PLL2.PLLM = ((regvalue & RCC_PLLCKSELR_DIVM2) >> RCC_PLLCKSELR_DIVM2_Pos);

  /* Check if fractional part is enable */
  regvalue = RCC->PLLCFGR;
  if ((regvalue & RCC_PLLCFGR_PLL2FRACEN) != 0x00u)
  {
    regvalue = (((RCC->PLL2FRACR & RCC_PLL2FRACR_FRACN) >> RCC_PLL2FRACR_FRACN_Pos));
  }
  else
  {
    regvalue = 0;
  }
  RCC_OscInitStruct->PLL2.PLLFractional = regvalue;

  /* Get PLL2 dividers register */
  regvalue = RCC->PLL2DIVR1;
  RCC_OscInitStruct->PLL2.PLLN = ((regvalue & RCC_PLL2DIVR1_DIVN) + 1U);
  RCC_OscInitStruct->PLL2.PLLR = (((regvalue & RCC_PLL2DIVR1_DIVR) >> RCC_PLL2DIVR1_DIVR_Pos) + 1U);
  RCC_OscInitStruct->PLL2.PLLP = (((regvalue & RCC_PLL2DIVR1_DIVP) >> RCC_PLL2DIVR1_DIVP_Pos) + 1U);
  RCC_OscInitStruct->PLL2.PLLQ = (((regvalue & RCC_PLL2DIVR1_DIVQ) >> RCC_PLL2DIVR1_DIVQ_Pos) + 1U);
  regvalue = RCC->PLL2DIVR2;
  RCC_OscInitStruct->PLL2.PLLS = (((regvalue & RCC_PLL2DIVR2_DIVS) >> RCC_PLL2DIVR2_DIVS_Pos) + 1U);
  RCC_OscInitStruct->PLL2.PLLT = (((regvalue & RCC_PLL2DIVR2_DIVT) >> RCC_PLL2DIVR2_DIVT_Pos) + 1U);

  /* Get the PLL3 configuration -----------------------------------------------*/
  /* Get Control register */
  regvalue = RCC->CR;
  if ((regvalue & RCC_CR_PLL3ON) == RCC_CR_PLL3ON)
  {
    RCC_OscInitStruct->PLL3.PLLState = RCC_PLL_ON;
  }
  else
  {
    RCC_OscInitStruct->PLL3.PLLState = RCC_PLL_OFF;
  }

  /* Get PLL3 configuration register */
  regvalue = RCC->PLLCKSELR;
  RCC_OscInitStruct->PLL3.PLLSource = (regvalue & RCC_PLLCKSELR_PLLSRC);
  RCC_OscInitStruct->PLL3.PLLM = ((regvalue & RCC_PLLCKSELR_DIVM3) >> RCC_PLLCKSELR_DIVM3_Pos);


  /* Check if fractional part is enable */
  regvalue = RCC->PLLCFGR;
  if ((regvalue & RCC_PLLCFGR_PLL3FRACEN) != 0x00u)
  {
    regvalue = (((RCC->PLL3FRACR & RCC_PLL3FRACR_FRACN) >> RCC_PLL3FRACR_FRACN_Pos));
  }
  else
  {
    regvalue = 0;
  }
  RCC_OscInitStruct->PLL3.PLLFractional = regvalue;

  /* Get PLL3 dividers register */
  regvalue = RCC->PLL3DIVR1;
  RCC_OscInitStruct->PLL3.PLLN = ((regvalue & RCC_PLL3DIVR1_DIVN) + 1U);
  RCC_OscInitStruct->PLL3.PLLR = (((regvalue & RCC_PLL3DIVR1_DIVR) >> RCC_PLL3DIVR1_DIVR_Pos) + 1U);
  RCC_OscInitStruct->PLL3.PLLP = (((regvalue & RCC_PLL3DIVR1_DIVP) >> RCC_PLL3DIVR1_DIVP_Pos) + 1U);
  RCC_OscInitStruct->PLL3.PLLQ = (((regvalue & RCC_PLL3DIVR1_DIVQ) >> RCC_PLL3DIVR1_DIVQ_Pos) + 1U);
  regvalue = RCC->PLL3DIVR2;
  RCC_OscInitStruct->PLL3.PLLS = (((regvalue & RCC_PLL3DIVR2_DIVS) >> RCC_PLL3DIVR2_DIVS_Pos) + 1U);
  RCC_OscInitStruct->PLL3.PLLT = 0;

}

void HAL_RCC_GetClockConfig(RCC_ClkInitTypeDef  *RCC_ClkInitStruct, uint32_t *pFLatency)
{
  /* Set all possible values for the Clock type parameter --------------------*/
  RCC_ClkInitStruct->ClockType = RCC_CLOCKTYPE_SYSCLK | RCC_CLOCKTYPE_HCLK  | \
                                 RCC_CLOCKTYPE_PCLK1  | RCC_CLOCKTYPE_PCLK2 | \
                                 RCC_CLOCKTYPE_PCLK4  | RCC_CLOCKTYPE_PCLK5;

  /* Get the SYSCLK source ---------------------------------------------------*/
  RCC_ClkInitStruct->SYSCLKSource = READ_BIT(RCC->CFGR, RCC_CFGR_SW);

  /* Get the SYSCLK configuration---------------------------------------------*/
  RCC_ClkInitStruct->SYSCLKDivider = READ_BIT(RCC->CDCFGR, RCC_CDCFGR_CPRE);

  /* Get the HCLK configuration ----------------------------------------------*/
  RCC_ClkInitStruct->AHBCLKDivider = READ_BIT(RCC->BMCFGR, RCC_BMCFGR_BMPRE);

  /* Get the APB1 configuration ----------------------------------------------*/
  RCC_ClkInitStruct->APB1CLKDivider = READ_BIT(RCC->APBCFGR, RCC_APBCFGR_PPRE1);

  /* Get the APB2 configuration ----------------------------------------------*/
  RCC_ClkInitStruct->APB2CLKDivider = READ_BIT(RCC->APBCFGR, RCC_APBCFGR_PPRE2);

  /* Get the APB4 configuration ----------------------------------------------*/
  RCC_ClkInitStruct->APB4CLKDivider = READ_BIT(RCC->APBCFGR, RCC_APBCFGR_PPRE4);

  /* Get the APB5 configuration ----------------------------------------------*/
  RCC_ClkInitStruct->APB5CLKDivider = READ_BIT(RCC->APBCFGR, RCC_APBCFGR_PPRE5);

  /* Get the Flash Wait State (Latency) configuration ------------------------*/
  *pFLatency = __HAL_FLASH_GET_LATENCY();
}

void HAL_RCC_NMI_IRQHandler(void)
{
  /* Check RCC HSECSSF interrupt flag  */
  if (__HAL_RCC_GET_IT(RCC_IT_HSECSS))
  {
    /* Clear RCC HSE CSS pending bit */
    __HAL_RCC_CLEAR_IT(RCC_IT_HSECSS);

    /* RCC HSE Clock Security System interrupt user callback */
    HAL_RCC_HSECSSCallback();
  }
}

uint32_t HAL_RCC_GetResetSource(void)
{
  uint32_t reset;

  /* Get all reset flags */
  reset = RCC->RSR & RCC_RESET_FLAG_ALL;

  /* Clear Reset flags */
  RCC->RSR |= RCC_RSR_RMVF;

  return reset;
}

static HAL_StatusTypeDef RCC_PLL_Config(uint32_t PLLnumber, const RCC_PLLInitTypeDef *pPLLInit)
{
  __IO uint32_t *p_rcc_pll_divr1_reg;
  __IO uint32_t *p_rcc_pll_divr2_reg;
  __IO uint32_t *p_rcc_pll_fracr_reg;
  HAL_StatusTypeDef ret = HAL_OK;
  uint32_t tickstart;
  uint32_t pllsrc;
  uint32_t pllvco;

  p_rcc_pll_divr1_reg = &(RCC->PLL1DIVR1) + (((uint32_t)0x02) * PLLnumber);
  p_rcc_pll_divr2_reg = &(RCC->PLL1DIVR2) + (((uint32_t)0x01) * PLLnumber);

  /* Disable the post-dividers */
  CLEAR_BIT(RCC->PLLCFGR, (RCC_PLLCFGR_PLL1PEN | RCC_PLLCFGR_PLL1QEN | RCC_PLLCFGR_PLL1REN | RCC_PLLCFGR_PLL1SEN |
                           0x00000200U) /* Hardcoded because no definition in CMSIS */
            << ((RCC_PLLCFGR_PLL2PEN_Pos - RCC_PLLCFGR_PLL1PEN_Pos)*PLLnumber));

  /* Ensure PLLx is disabled */
  CLEAR_BIT(RCC->CR, RCC_CR_PLL1ON << ((RCC_CR_PLL2ON_Pos - RCC_CR_PLL1ON_Pos)*PLLnumber));

  /* Get Start Tick*/
  tickstart = HAL_GetTick();

  /* Wait till PLLx is disabled */
  while (READ_BIT(RCC->CR, (RCC_CR_PLL1RDY << ((RCC_CR_PLL2RDY_Pos - RCC_CR_PLL1RDY_Pos)*PLLnumber))) != 0U)
  {
    if ((HAL_GetTick() - tickstart) > RCC_PLL_TIMEOUT_VALUE)
    {
      return HAL_TIMEOUT;
    }
  }

  if (pPLLInit->PLLState == RCC_PLL_ON)
  {
    /* Check the parameters */
    assert_param(IS_RCC_PLLSOURCE(pPLLInit->PLLSource));
    assert_param(IS_RCC_PLLM_VALUE(pPLLInit->PLLM));
    assert_param(IS_RCC_PLLN_VALUE(pPLLInit->PLLN));
    assert_param(IS_RCC_PLLP_VALUE(pPLLInit->PLLP));
    assert_param(IS_RCC_PLLQ_VALUE(pPLLInit->PLLQ));
    assert_param(IS_RCC_PLLR_VALUE(pPLLInit->PLLR));
    assert_param(IS_RCC_PLLS_VALUE(pPLLInit->PLLS));
    assert_param(IS_RCC_PLLT_VALUE(pPLLInit->PLLT));

    pllsrc = pPLLInit->PLLSource;

    /* Compute VCO input frequency and define range accordingly. First check clock source frequency */
    if (pllsrc == RCC_PLLSOURCE_HSI)
    {
      /* Clock source is HSI or HSI/HSIDIV */
      pllvco = HSI_VALUE >> ((RCC->CR & RCC_CR_HSIDIV) >> RCC_CR_HSIDIV_Pos);
    }
    else if (pllsrc == RCC_PLLSOURCE_HSE)
    {
      /* Clock source is HSE */
      pllvco = HSE_VALUE;
    }
    else
    {
      /* Clock source is CSI */
      pllvco = CSI_VALUE;
    }

    /* Compute VCO input frequency depending on M divider */
    pllvco = (pllvco / pPLLInit->PLLM);
    assert_param(IS_RCC_PLL_VCOINPUTFREQ(pllvco));

    if (pllvco >= RCC_PLL_INPUTRANGE2_FREQMAX)
    {
      pllvco = RCC_PLL_VCOINPUT_RANGE3 | RCC_PLL_VCO_HIGH;
    }
    else if (pllvco >= RCC_PLL_INPUTRANGE1_FREQMAX)
    {
      pllvco = RCC_PLL_VCOINPUT_RANGE2 | RCC_PLL_VCO_HIGH;
    }
    else if (pllvco >= RCC_PLL_INPUTRANGE0_FREQMAX)
    {
      pllvco = RCC_PLL_VCOINPUT_RANGE1 | RCC_PLL_VCO_HIGH;
    }
    else
    {
      pllvco = RCC_PLL_VCOINPUT_RANGE0 | RCC_PLL_VCO_LOW;
    }

    pllvco = (pllvco << ((RCC_PLLCFGR_PLL2RGE_Pos - RCC_PLLCFGR_PLL1RGE_Pos) * PLLnumber));

    /* Configure PLL source and PLLM divider */
    MODIFY_REG(RCC->PLLCKSELR, (RCC_PLLCKSELR_PLLSRC | (RCC_PLLCKSELR_DIVM1 << ((RCC_PLLCKSELR_DIVM2_Pos - RCC_PLLCKSELR_DIVM1_Pos)*PLLnumber))), \
               pllsrc | (pPLLInit->PLLM << (RCC_PLLCKSELR_DIVM1_Pos + ((RCC_PLLCKSELR_DIVM2_Pos - RCC_PLLCKSELR_DIVM1_Pos)*PLLnumber))));

    if ((RCC->PLLCKSELR & RCC_PLLCKSELR_PLLSRC) != pllsrc)
    {
      /* There is another PLL activated with another source */
      return HAL_ERROR;
    }

    /* Configure VCO input range, VCO selection and clear FRACEN */
    MODIFY_REG(RCC->PLLCFGR, (RCC_PLLCFGR_PLL1RGE | RCC_PLLCFGR_PLL1VCOSEL | RCC_PLLCFGR_PLL1FRACEN) << (((RCC_PLLCFGR_PLL2RGE_Pos - RCC_PLLCFGR_PLL1RGE_Pos)*PLLnumber)), \
               pllvco);

    /* Configure PLLN, PLLP, PLLQ, PLLR, PLLS and PLLT dividers */
    WRITE_REG(*p_rcc_pll_divr1_reg, ((pPLLInit->PLLN - 1U) |
                                     ((pPLLInit->PLLP - 1U) << RCC_PLL1DIVR1_DIVP_Pos) |
                                     ((pPLLInit->PLLQ - 1U) << RCC_PLL1DIVR1_DIVQ_Pos) |
                                     ((pPLLInit->PLLR - 1U) << RCC_PLL1DIVR1_DIVR_Pos)));
    WRITE_REG(*p_rcc_pll_divr2_reg, ((pPLLInit->PLLS - 1U) |
                                     ((pPLLInit->PLLT - 1U) << RCC_PLL2DIVR2_DIVT_Pos)));

    if (PLLnumber == RCC_PLL1_CONFIG)
    {
      SET_BIT(RCC->PLLCFGR, RCC_PLLCFGR_PLL1PEN);
    }

    if (pPLLInit->PLLFractional != 0U)
    {
      assert_param(IS_RCC_PLLFRACN_VALUE(pPLLInit->PLLFractional));

      p_rcc_pll_fracr_reg = &(RCC->PLL1FRACR) + (((uint32_t)0x02) * PLLnumber);

      /* Configure PLLFRACN */
      MODIFY_REG(*p_rcc_pll_fracr_reg, RCC_PLL1FRACR_FRACN, pPLLInit->PLLFractional << RCC_PLL1FRACR_FRACN_Pos);

      /* Enable PLLFRACLE */
      SET_BIT(RCC->PLLCFGR, RCC_PLLCFGR_PLL1FRACEN << ((RCC_PLLCFGR_PLL2FRACEN_Pos - RCC_PLLCFGR_PLL1FRACEN_Pos)*PLLnumber));
    }

    /* Enable the PLLx */
    SET_BIT(RCC->CR, RCC_CR_PLL1ON << ((RCC_CR_PLL2ON_Pos - RCC_CR_PLL1ON_Pos)*PLLnumber));

    /* Get Start Tick*/
    tickstart = HAL_GetTick();

    /* Wait till PLLx is ready */
    while (READ_BIT(RCC->CR, RCC_CR_PLL1RDY << ((RCC_CR_PLL2RDY_Pos - RCC_CR_PLL1RDY_Pos)*PLLnumber)) == 0U)
    {
      if ((HAL_GetTick() - tickstart) > RCC_PLL_TIMEOUT_VALUE)
      {
        return HAL_TIMEOUT;
      }
    }
  }
  else
  {
    /* Disable outputs to save power when PLLx is off */
    MODIFY_REG(RCC->PLLCKSELR, ((RCC_PLLCKSELR_DIVM1 << (RCC_PLLCKSELR_DIVM1_Pos + ((RCC_PLLCKSELR_DIVM2_Pos - RCC_PLLCKSELR_DIVM1_Pos)*PLLnumber)))
                                | RCC_PLLCKSELR_PLLSRC), RCC_PLLSOURCE_NONE);
  }

  return ret;
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

uint32_t CRCCControl_CallPLL(uint32_t index, const RCC_PLLInitTypeDef *configuration) {
  return RCC_PLL_Config(index, configuration);
}
