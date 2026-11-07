/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Unchanged declarations/functions/macros from STM32H7RS HAL at
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748. Host bindings are in the shim.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
HAL_StatusTypeDef HAL_RCCEx_PeriphCLKConfig(const RCC_PeriphCLKInitTypeDef  *PeriphClkInit)
{
  uint32_t tmpreg;
  uint32_t tickstart;
  HAL_StatusTypeDef ret = HAL_OK;      /* Intermediate status */
  HAL_StatusTypeDef status = HAL_OK;   /* Final status */

  /* Check the parameters */
  assert_param(IS_RCC_PERIPHCLOCK(PeriphClkInit->PeriphClockSelection));

  /*---------------------------- RTC configuration -------------------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_RTC) == RCC_PERIPHCLK_RTC)
  {
    /* check for RTC Parameters used to output RTCCLK */
    assert_param(IS_RCC_RTCCLKSOURCE(PeriphClkInit->RTCClockSelection));

    /* As the RTC clock source selection can be changed only if the Backup Domain is reset */
    /* reset the Backup domain only if the RTC Clock source selection is modified from default reset value */
    tmpreg = READ_BIT(RCC->BDCR, RCC_BDCR_RTCSEL);

    if ((tmpreg != RCC_RTCCLKSOURCE_DISABLE) && (tmpreg != (PeriphClkInit->RTCClockSelection & RCC_BDCR_RTCSEL)))
    {
      /* Enable write access to Backup domain */
      SET_BIT(PWR->CR1, PWR_CR1_DBP);

      /* Read back to check Backup domain enabled */
      if (READ_BIT(PWR->CR1, PWR_CR1_DBP) == 0U)
      {
        ret = HAL_ERROR;
      }
      else
      {
        /* Store the content of BDCR register before the reset of Backup Domain */
        /* excepted the RTC clock source selection that will be changed */
        tmpreg = READ_BIT(RCC->BDCR, ~(RCC_BDCR_RTCSEL));
        __HAL_RCC_BACKUPRESET_FORCE();
        __HAL_RCC_BACKUPRESET_RELEASE();
        /* Restore the content of BDCR register */
        WRITE_REG(RCC->BDCR, tmpreg);
      }
    }

    if (ret == HAL_OK)
    {
      /* If LSE is selected as RTC clock source (and enabled prior to Backup Domain reset), wait for LSE reactivation */
      if (PeriphClkInit->RTCClockSelection == RCC_RTCCLKSOURCE_LSE)
      {
        /* Get Start Tick*/
        tickstart = HAL_GetTick();

        /* Wait till LSE is ready */
        while (READ_BIT(RCC->BDCR, RCC_BDCR_LSERDY) == 0U)
        {
          if ((HAL_GetTick() - tickstart) > RCC_LSE_TIMEOUT_VALUE)
          {
            ret = HAL_TIMEOUT;
            break;
          }
        }
      }

      if (ret == HAL_OK)
      {
        __HAL_RCC_RTC_CONFIG(PeriphClkInit->RTCClockSelection);
        __HAL_RCC_RTC_ENABLE();
      }
      else
      {
        /* set overall return value */
        status = ret;
      }
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*---------------------------- FMC configuration -------------------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_FMC) == RCC_PERIPHCLK_FMC)
  {
    /* Check the parameters */
    assert_param(IS_RCC_FMCCLKSOURCE(PeriphClkInit->FmcClockSelection));

    switch (PeriphClkInit->FmcClockSelection)
    {
      case RCC_FMCCLKSOURCE_HCLK:   /* HCLK  clock selected as FMC kernel peripheral clock */
        break;

      case RCC_FMCCLKSOURCE_PLL1Q:  /* PLL1_Q is used as clock source for FMC kernel */
        /* Enable FMC kernel clock output generated form System PLL . */
        __HAL_RCC_PLL1CLKOUT_ENABLE(RCC_PLL_QCLK);
        /* FMC kernel clock source configuration done later after clock selection check */
        break;

      case RCC_FMCCLKSOURCE_PLL2R:  /* PLL2_R is used as clock source for FMC kernel */
        __HAL_RCC_PLL2CLKOUT_ENABLE(RCC_PLL_RCLK);
        /* FMC kernel clock source configuration done later after clock selection check */
        break;

      case RCC_FMCCLKSOURCE_HSI:   /* HSI oscillator is used as clock source for FMC kernel */
        /* FMC kernel clock source configuration done later after clock selection check */
        break;

      default:
        ret = HAL_ERROR;
        break;
    }

    if (ret == HAL_OK)
    {
      /* Set the source of FMC kernel clock*/
      __HAL_RCC_FMC_CONFIG(PeriphClkInit->FmcClockSelection);
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*-------------------------- XSPI1 clock source configuration ----------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_XSPI1) == RCC_PERIPHCLK_XSPI1)
  {
    /* Check the parameters */
    assert_param(IS_RCC_XSPI1CLKSOURCE(PeriphClkInit->Xspi1ClockSelection));

    switch (PeriphClkInit->Xspi1ClockSelection)
    {
      case RCC_XSPI1CLKSOURCE_HCLK:   /* HCLK is used as clock source for Xspi1 */
        /* Nothing to do */
        break;

      case RCC_XSPI1CLKSOURCE_PLL2S:  /* PLL2_S is used as clock source for Xspi1 */
        __HAL_RCC_PLL2CLKOUT_ENABLE(RCC_PLL_SCLK);
        /* XSPI1 clock source configuration done later after clock selection check */
        break;

      case RCC_XSPI1CLKSOURCE_PLL2T:  /* PLL2_T is used as clock source for Xspi1 */
        __HAL_RCC_PLL2CLKOUT_ENABLE(RCC_PLL_TCLK);
        /* XSPI1 clock source configuration done later after clock selection check */
        break;

      default:
        ret = HAL_ERROR;
        break;
    }

    if (ret == HAL_OK)
    {
      /* Configure the XSPI1 clock source */
      __HAL_RCC_XSPI1_CONFIG(PeriphClkInit->Xspi1ClockSelection);
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*-------------------------- XSPI2 clock source configuration ----------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_XSPI2) == RCC_PERIPHCLK_XSPI2)
  {
    /* Check the parameters */
    assert_param(IS_RCC_XSPI2CLKSOURCE(PeriphClkInit->Xspi2ClockSelection));

    switch (PeriphClkInit->Xspi2ClockSelection)
    {
      case RCC_XSPI2CLKSOURCE_HCLK:   /* HCLK is used as clock source for Xspi2 */
        /* Nothing to do */
        break;

      case RCC_XSPI2CLKSOURCE_PLL2S:  /* PLL2_S is used as clock source for Xspi2 */
        __HAL_RCC_PLL2CLKOUT_ENABLE(RCC_PLL_SCLK);
        /* XSPI2 clock source configuration done later after clock selection check */
        break;

      case RCC_XSPI2CLKSOURCE_PLL2T:  /* PLL2_T is used as clock source for Xspi2 */
        __HAL_RCC_PLL2CLKOUT_ENABLE(RCC_PLL_TCLK);
        /* XSPI2 clock source configuration done later after clock selection check */
        break;

      default:
        ret = HAL_ERROR;
        break;
    }

    if (ret == HAL_OK)
    {
      /* Configure the XSPI2 clock source */
      __HAL_RCC_XSPI2_CONFIG(PeriphClkInit->Xspi2ClockSelection);
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*------------------------------------ CKPER configuration --------------------------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_CKPER) == RCC_PERIPHCLK_CKPER)
  {
    /* Check the parameters */
    assert_param(IS_RCC_CKPERCLKSOURCE(PeriphClkInit->CkperClockSelection));

    /* Configure the CKPER clock source */
    __HAL_RCC_CLKP_CONFIG(PeriphClkInit->CkperClockSelection);
  }

  /*------------------------------------- SDMMC12 Configuration ------------------------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_SDMMC12) == RCC_PERIPHCLK_SDMMC12)
  {
    /* Check the parameters */
    assert_param(IS_RCC_SDMMC12CLKSOURCE(PeriphClkInit->Sdmmc12ClockSelection));

    switch (PeriphClkInit->Sdmmc12ClockSelection)
    {
      case RCC_SDMMC12CLKSOURCE_PLL2S:  /* PLL2_S is used as clock source for SDMMC12 kernel */
        __HAL_RCC_PLL2CLKOUT_ENABLE(RCC_PLL_SCLK);
        /* SDMMC12 kernel clock source configuration done later after clock selection check */
        break;

      case RCC_SDMMC12CLKSOURCE_PLL2T:  /* PLL2_T is used as clock source for SDMMC12 kernel */
        __HAL_RCC_PLL2CLKOUT_ENABLE(RCC_PLL_TCLK);
        /* SDMMC12 kernel clock source configuration done later after clock selection check */
        break;

      default:
        ret = HAL_ERROR;
        break;
    }

    if (ret == HAL_OK)
    {
      /* Set the source of SDMMC12 clock*/
      __HAL_RCC_SDMMC12_CONFIG(PeriphClkInit->Sdmmc12ClockSelection);
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*---------------------------- ADC configuration -------------------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_ADC) == RCC_PERIPHCLK_ADC)
  {
    /* Check the parameters */
    assert_param(IS_RCC_ADCCLKSOURCE(PeriphClkInit->AdcClockSelection));

    switch (PeriphClkInit->AdcClockSelection)
    {

      case RCC_ADCCLKSOURCE_PLL2P: /* PLL2_P is used as clock source for ADC */
        __HAL_RCC_PLL2CLKOUT_ENABLE(RCC_PLL_PCLK);
        /* ADC clock source configuration done later after clock selection check */
        break;

      case RCC_ADCCLKSOURCE_PLL3R: /* PLL3_R is used as clock source for ADC */
        __HAL_RCC_PLL3CLKOUT_ENABLE(RCC_PLL_RCLK);
        /* ADC clock source configuration done later after clock selection check */
        break;

      case RCC_ADCCLKSOURCE_CLKP:
        /* HSI, HSE, or CSI oscillator is used as source of ADC clock */
        /* ADC clock source configuration done later after clock selection check */
        break;

      default:
        ret = HAL_ERROR;
        break;
    }

    if (ret == HAL_OK)
    {
      /* Set the source of ADC clock*/
      __HAL_RCC_ADC_CONFIG(PeriphClkInit->AdcClockSelection);
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*---------------------------- ADF1 configuration --------------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_ADF1) == RCC_PERIPHCLK_ADF1)
  {
    /* Check the parameters */
    assert_param(IS_RCC_ADF1CLKSOURCE(PeriphClkInit->Adf1ClockSelection));

    switch (PeriphClkInit->Adf1ClockSelection)
    {
      case RCC_ADF1CLKSOURCE_PLL2P:  /* PLL2_P is used as clock source for ADF1 */
        __HAL_RCC_PLL2CLKOUT_ENABLE(RCC_PLL_PCLK);
        /* ADF1 clock source configuration done later after clock selection check */
        break;

      case RCC_ADF1CLKSOURCE_PLL3P:  /* PLL3_P is used as clock source for ADF1 */
        __HAL_RCC_PLL3CLKOUT_ENABLE(RCC_PLL_PCLK);
        /* ADF1 clock source configuration done later after clock selection check */
        break;

      case RCC_ADF1CLKSOURCE_HCLK:   /* HCLK is used as clock source for ADF1 */
      case RCC_ADF1CLKSOURCE_PIN:    /* External I2S_CKIN is used as clock source for ADF1 */
      case RCC_ADF1CLKSOURCE_CSI:    /* CSI is used as clock source for ADF1 */
      case RCC_ADF1CLKSOURCE_HSI:    /* HSI is used as clock source for ADF1 */
        /* ADF1 clock source configuration done later after clock selection check */
        break;

      default:
        ret = HAL_ERROR;
        break;
    }

    if (ret == HAL_OK)
    {
      /* Set the source of ADF1 clock*/
      __HAL_RCC_ADF1_CONFIG(PeriphClkInit->Adf1ClockSelection);
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*---------------------- CEC configuration ---------------------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_CEC) == RCC_PERIPHCLK_CEC)
  {
    /* Check the parameters */
    assert_param(IS_RCC_CECCLKSOURCE(PeriphClkInit->CecClockSelection));

    /* Configure the CEC clock source */
    __HAL_RCC_CEC_CONFIG(PeriphClkInit->CecClockSelection);
  }

  /*---------------------- ETH1 REF configuration --------------------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_ETH1REF) == RCC_PERIPHCLK_ETH1REF)
  {
    /* Check the parameters */
    assert_param(IS_RCC_ETH1REFCLKSOURCE(PeriphClkInit->Eth1RefClockSelection));

    /* Configure the ETH1 REF clock source */
    __HAL_RCC_ETH1REF_CONFIG(PeriphClkInit->Eth1RefClockSelection);
  }

  /*---------------------- ETH1PHY configuration --------------------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_ETH1PHY) == RCC_PERIPHCLK_ETH1PHY)
  {
    /* Check the parameters */
    assert_param(IS_RCC_ETH1PHYCLKSOURCE(PeriphClkInit->Eth1PhyClockSelection));

    switch (PeriphClkInit->Eth1PhyClockSelection)
    {
      case RCC_ETH1PHYCLKSOURCE_HSE:    /* HSE is used as clock source for ETH PHY */
        /* ETH PHY clock source configuration done later after clock selection check */
        break;

      case RCC_ETH1PHYCLKSOURCE_PLL3S:  /* PLL3_S is used as clock source for ETH PHY */
        __HAL_RCC_PLL3CLKOUT_ENABLE(RCC_PLL_SCLK);
        /* ETH PHY clock source configuration done later after clock selection check */
        break;

      default:
        ret = HAL_ERROR;
        break;
    }

    if (ret == HAL_OK)
    {
      /* Set the source of ETH PHY clock*/
      __HAL_RCC_ETH1PHY_CONFIG(PeriphClkInit->Eth1PhyClockSelection);
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*---------------------- FDCAN configuration -------------------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_FDCAN) == RCC_PERIPHCLK_FDCAN)
  {
    /* Check the parameters */
    assert_param(IS_RCC_FDCANCLKSOURCE(PeriphClkInit->FdcanClockSelection));

    switch (PeriphClkInit->FdcanClockSelection)
    {
      case RCC_FDCANCLKSOURCE_PLL1Q: /* PLL1_Q is used as clock source for FDCAN kernel */
        /* Enable FDCAN Clock output generated form System PLL . */
        __HAL_RCC_PLL1CLKOUT_ENABLE(RCC_PLL_QCLK);
        /* FDCAN clock source configuration done later after clock selection check */
        break;

      case RCC_FDCANCLKSOURCE_PLL2P: /* PLL2_P is used as clock source for FDCAN kernel */
        __HAL_RCC_PLL2CLKOUT_ENABLE(RCC_PLL_PCLK);
        /* FDCAN clock source configuration done later after clock selection check */
        break;

      case RCC_FDCANCLKSOURCE_HSE:   /* HSE is used as clock source for FDCAN kernel */
        /* FDCAN clock source configuration done later after clock selection check */
        break;

      default:
        ret = HAL_ERROR;
        break;
    }

    if (ret == HAL_OK)
    {
      /* Set the source of FDCAN clock*/
      __HAL_RCC_FDCAN_CONFIG(PeriphClkInit->FdcanClockSelection);
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*------------------------------ I2C1/I3C1 Configuration ------------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_I2C1_I3C1) == RCC_PERIPHCLK_I2C1_I3C1)
  {
    /* Check the parameters */
    assert_param(IS_RCC_I2C1_I3C1CLKSOURCE(PeriphClkInit->I2c1_I3c1ClockSelection));

    switch (PeriphClkInit->I2c1_I3c1ClockSelection)
    {
      case RCC_I2C1_I3C1CLKSOURCE_PLL3R:   /* PLL3_R is used as clock source for I2C1/I3C1*/
        __HAL_RCC_PLL3CLKOUT_ENABLE(RCC_PLL_RCLK);
        /* I2C1/I3C1 clock source configuration done later after clock selection check */
        break;

      case RCC_I2C1_I3C1CLKSOURCE_PCLK1:   /* PCLK1 is used as clock source for I2C1/I3C1*/
      case RCC_I2C1_I3C1CLKSOURCE_HSI:     /* HSI is used as clock source for I2C1/I3C1*/
      case RCC_I2C1_I3C1CLKSOURCE_CSI:     /* CSI is used as clock source for I2C1/I3C1*/
        /* I2C1/I3C1 clock source configuration done later after clock selection check */
        break;

      default:
        ret = HAL_ERROR;
        break;
    }

    if (ret == HAL_OK)
    {
      /* Set the source of I2C1/I3C1 clock*/
      __HAL_RCC_I2C1_I3C1_CONFIG(PeriphClkInit->I2c1_I3c1ClockSelection);
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*------------------------------ I2C2/I2C3 Configuration -------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_I2C23) == RCC_PERIPHCLK_I2C23)
  {
    /* Check the parameters */
    assert_param(IS_RCC_I2C23CLKSOURCE(PeriphClkInit->I2c23ClockSelection));

    switch (PeriphClkInit->I2c23ClockSelection)
    {
      case RCC_I2C23CLKSOURCE_PLL3R:   /* PLL3_R is used as clock source for I2C2/I2C3 */
        __HAL_RCC_PLL3CLKOUT_ENABLE(RCC_PLL_RCLK);
        /* I2C2/I2C3 clock source configuration done later after clock selection check */
        break;

      case RCC_I2C23CLKSOURCE_PCLK1:   /* PCLK1 is used as clock source for I2C2/I2C3 */
      case RCC_I2C23CLKSOURCE_HSI:     /* HSI is used as clock source for I2C2/I2C3 */
      case RCC_I2C23CLKSOURCE_CSI:     /* CSI is used as clock source for I2C2/I2C3 */
        /* I2C2/I2C3 clock source configuration done later after clock selection check */
        break;

      default:
        ret = HAL_ERROR;
        break;
    }

    if (ret == HAL_OK)
    {
      /* Set the source of I2C2/I2C3 clock*/
      __HAL_RCC_I2C23_CONFIG(PeriphClkInit->I2c23ClockSelection);
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*---------------------------- LPTIM1 configuration -------------------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_LPTIM1) == RCC_PERIPHCLK_LPTIM1)
  {
    /* Check the parameters */
    assert_param(IS_RCC_LPTIM1CLKSOURCE(PeriphClkInit->Lptim1ClockSelection));

    switch (PeriphClkInit->Lptim1ClockSelection)
    {
      case RCC_LPTIM1CLKSOURCE_PCLK1: /* PCLK1 as clock source for LPTIM1 */
        /* LPTIM1 clock source configuration done later after clock selection check */
        break;

      case RCC_LPTIM1CLKSOURCE_PLL2P: /* PLL2_P is used as clock source for LPTIM1 */
        __HAL_RCC_PLL2CLKOUT_ENABLE(RCC_PLL_PCLK);
        /* LPTIM1 clock source configuration done later after clock selection check */
        break;

      case RCC_LPTIM1CLKSOURCE_PLL3R:  /* PLL3_R is used as clock source for LPTIM1 */
        __HAL_RCC_PLL3CLKOUT_ENABLE(RCC_PLL_RCLK);
        /* LPTIM1 clock source configuration done later after clock selection check */
        break;

      case RCC_LPTIM1CLKSOURCE_LSE:
        /* External low speed OSC clock is used as clock source for LPTIM1 */
        /* LPTIM1 clock source configuration done later after clock selection check */
        break;

      case RCC_LPTIM1CLKSOURCE_LSI:
        /* Internal  low speed OSC clock is used as clock source for LPTIM1 */
        /* LPTIM1 clock source configuration done later after clock selection check */
        break;

      case RCC_LPTIM1CLKSOURCE_CLKP:
        /* HSI, HSE, or CSI oscillator is used as clock source for LPTIM1 */
        /* LPTIM1 clock source configuration done later after clock selection check */
        break;

      default:
        ret = HAL_ERROR;
        break;
    }

    if (ret == HAL_OK)
    {
      /* Set the source of LPTIM1 clock*/
      __HAL_RCC_LPTIM1_CONFIG(PeriphClkInit->Lptim1ClockSelection);
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*---------------------------- LPTIM2/LPTIM3 configuration -----------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_LPTIM23) == RCC_PERIPHCLK_LPTIM23)
  {
    switch (PeriphClkInit->Lptim23ClockSelection)
    {
      case RCC_LPTIM23CLKSOURCE_PCLK4: /* PCLK4 as clock source for LPTIM2/LPTIM3 */
        /* LPTIM2/LPTIM3 clock source configuration done later after clock selection check */
        break;

      case RCC_LPTIM23CLKSOURCE_PLL2P: /* PLL2_P is used as clock source for LPTIM2/LPTIM3 */
        __HAL_RCC_PLL2CLKOUT_ENABLE(RCC_PLL_PCLK);
        /* LPTIM2/LPTIM3 clock source configuration done later after clock selection check */
        break;

      case RCC_LPTIM23CLKSOURCE_PLL3R: /* PLL3_R is used as clock source for LPTIM2/LPTIM3 */
        __HAL_RCC_PLL3CLKOUT_ENABLE(RCC_PLL_RCLK);
        /* LPTIM2/LPTIM3 clock source configuration done later after clock selection check */
        break;

      case RCC_LPTIM23CLKSOURCE_LSE:
        /* External low speed OSC clock is used as clock source for LPTIM2/LPTIM3 */
        /* LPTIM2/LPTIM3 clock source configuration done later after clock selection check */
        break;

      case RCC_LPTIM23CLKSOURCE_LSI:
        /* Internal  low speed OSC clock is used as clock source for LPTIM2/LPTIM3 */
        /* LPTIM2/LPTIM3 clock source configuration done later after clock selection check */
        break;

      case RCC_LPTIM23CLKSOURCE_CLKP:
        /* HSI, HSE, or CSI oscillator is used as source of LPTIM2 clock */
        /* LPTIM2/LPTIM3 clock source configuration done later after clock selection check */
        break;

      default:
        ret = HAL_ERROR;
        break;
    }

    if (ret == HAL_OK)
    {
      /* Set the source of LPTIM2/LPTIM3 clock*/
      __HAL_RCC_LPTIM23_CONFIG(PeriphClkInit->Lptim23ClockSelection);
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*---------------------------- LPTIM4/LPTIM5 configuration -----------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_LPTIM45) == RCC_PERIPHCLK_LPTIM45)
  {
    switch (PeriphClkInit->Lptim45ClockSelection)
    {
      case RCC_LPTIM45CLKSOURCE_PCLK4:  /* PCLK4 as clock source for LPTIM4/LPTIM5 */
        /* LPTIM4/LPTIM5 clock source configuration done later after clock selection check */
        break;

      case RCC_LPTIM45CLKSOURCE_PLL2P: /* PLL2 is used as clock source for LPTIM4/LPTIM5 */
        __HAL_RCC_PLL2CLKOUT_ENABLE(RCC_PLL_PCLK);
        /* LPTIM4/LPTIM5 clock source configuration done later after clock selection check */
        break;

      case RCC_LPTIM45CLKSOURCE_PLL3R:  /* PLL3 is used as clock source for LPTIM4/LPTIM5 */
        __HAL_RCC_PLL3CLKOUT_ENABLE(RCC_PLL_RCLK);
        /* LPTIM4/LPTIM5 clock source configuration done later after clock selection check */
        break;

      case RCC_LPTIM45CLKSOURCE_LSE:
        /* External low speed OSC clock is used as source of LPTIM4/LPTIM5 clock */
        /* LPTIM4/LPTIM5 clock source configuration done later after clock selection check */
        break;

      case RCC_LPTIM45CLKSOURCE_LSI:
        /* Internal  low speed OSC clock is used  as source of LPTIM4/LPTIM5 clock */
        /* LPTIM4/LPTIM5 clock source configuration done later after clock selection check */
        break;

      case RCC_LPTIM45CLKSOURCE_CLKP:
        /* HSI, HSE, or CSI oscillator is used as source of LPTIM4/LPTIM5 clock */
        /* LPTIM4/LPTIM5 clock source configuration done later after clock selection check */
        break;

      default:
        ret = HAL_ERROR;
        break;
    }

    if (ret == HAL_OK)
    {
      /* Set the source of LPTIM4/LPTIM5 clock */
      __HAL_RCC_LPTIM45_CONFIG(PeriphClkInit->Lptim45ClockSelection);
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*-------------------------- LPUART1 Configuration -------------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_LPUART1) == RCC_PERIPHCLK_LPUART1)
  {
    /* Check the parameters */
    assert_param(IS_RCC_LPUART1CLKSOURCE(PeriphClkInit->Lpuart1ClockSelection));

    switch (PeriphClkInit->Lpuart1ClockSelection)
    {
      case RCC_LPUART1CLKSOURCE_PCLK4: /* PCLK4 selected as clock source for LPUART1 */
        /* LPUART1 clock source configuration done later after clock selection check */
        break;

      case RCC_LPUART1CLKSOURCE_PLL2Q: /* PLL2_Q is used as clock source for LPUART1 */
        __HAL_RCC_PLL2CLKOUT_ENABLE(RCC_PLL_QCLK);
        /* LPUART1 clock source configuration done later after clock selection check */
        break;

      case RCC_LPUART1CLKSOURCE_PLL3Q: /* PLL3_Q is used as clock source for LPUART1 */
        __HAL_RCC_PLL3CLKOUT_ENABLE(RCC_PLL_QCLK);
        /* LPUART1 clock source configuration done later after clock selection check */
        break;

      case RCC_LPUART1CLKSOURCE_HSI:
        /* HSI oscillator clock is used as source of LPUART1 clock */
        /* LPUART1 clock source configuration done later after clock selection check */
        break;

      case RCC_LPUART1CLKSOURCE_CSI:
        /* CSI oscillator clock is used as source of LPUART1 clock */
        /* LPUART1 clock source configuration done later after clock selection check */
        break;

      case RCC_LPUART1CLKSOURCE_LSE:
        /* LSE,  oscillator is used as source of LPUART1 clock */
        /* LPUART1 clock source configuration done later after clock selection check */
        break;

      default:
        ret = HAL_ERROR;
        break;
    }

    if (ret == HAL_OK)
    {
      /* Set the source of LPUART1 clock */
      __HAL_RCC_LPUART1_CONFIG(PeriphClkInit->Lpuart1ClockSelection);
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*-------------------------- LTDC Configuration ----------------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_LTDC) == RCC_PERIPHCLK_LTDC)
  {
    /* LTDC internally connected to PLL3_R output clock */
    __HAL_RCC_PLL3CLKOUT_ENABLE(RCC_PLL_RCLK);
  }

  /*---------------------------- PSSI configuration --------------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_PSSI) == RCC_PERIPHCLK_PSSI)
  {
    /* Check the parameters */
    assert_param(IS_RCC_PSSICLKSOURCE(PeriphClkInit->PssiClockSelection));

    switch (PeriphClkInit->PssiClockSelection)
    {
      case RCC_PSSICLKSOURCE_PLL3R:  /* PLL3_R is used as clock source for PSSI */
        __HAL_RCC_PLL3CLKOUT_ENABLE(RCC_PLL_RCLK);
        /* PSSI clock source configuration done later after clock selection check */
        break;

      case RCC_PSSICLKSOURCE_CLKP:
        /* HSI, HSE, or CSI oscillator is used as source of PSSI clock */
        /* PSSI clock source configuration done later after clock selection check */
        break;

      default:
        ret = HAL_ERROR;
        break;
    }

    if (ret == HAL_OK)
    {
      /* Set the source of PSSI clock*/
      __HAL_RCC_PSSI_CONFIG(PeriphClkInit->PssiClockSelection);
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*---------------------------- SAI1 configuration --------------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_SAI1) == RCC_PERIPHCLK_SAI1)
  {
    /* Check the parameters */
    assert_param(IS_RCC_SAI1CLKSOURCE(PeriphClkInit->Sai1ClockSelection));

    switch (PeriphClkInit->Sai1ClockSelection)
    {
      case RCC_SAI1CLKSOURCE_PLL1Q:  /* PLL1_Q is used as clock source for SAI1 */
        /* Enable SAI Clock output generated form System PLL . */
        __HAL_RCC_PLL1CLKOUT_ENABLE(RCC_PLL_QCLK);
        /* SAI1 clock source configuration done later after clock selection check */
        break;

      case RCC_SAI1CLKSOURCE_PLL2P:  /* PLL2_P is used as clock source for SAI1 */
        __HAL_RCC_PLL2CLKOUT_ENABLE(RCC_PLL_PCLK);
        /* SAI1 clock source configuration done later after clock selection check */
        break;

      case RCC_SAI1CLKSOURCE_PLL3P:  /* PLL3_P is used as clock source for SAI1 */
        __HAL_RCC_PLL3CLKOUT_ENABLE(RCC_PLL_PCLK);
        /* SAI1 clock source configuration done later after clock selection check */
        break;

      case RCC_SAI1CLKSOURCE_PIN:   /* External clock is used as source of SAI1 clock */
        /* SAI1 clock source configuration done later after clock selection check */
        break;

      case RCC_SAI1CLKSOURCE_CLKP:
        /* HSI, HSE, or CSI oscillator is used as source of SAI1 clock */
        /* SAI1 clock source configuration done later after clock selection check */
        break;

      default:
        ret = HAL_ERROR;
        break;
    }

    if (ret == HAL_OK)
    {
      /* Set the source of SAI1 clock*/
      __HAL_RCC_SAI1_CONFIG(PeriphClkInit->Sai1ClockSelection);
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*---------------------------- SAI2 configuration --------------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_SAI2) == RCC_PERIPHCLK_SAI2)
  {
    /* Check the parameters */
    assert_param(IS_RCC_SAI2CLKSOURCE(PeriphClkInit->Sai2ClockSelection));

    switch (PeriphClkInit->Sai2ClockSelection)
    {
      case RCC_SAI2CLKSOURCE_PLL1Q:  /* PLL1_Q is used as clock source for SAI2 */
        /* Enable SAI Clock output generated form System PLL . */
        __HAL_RCC_PLL1CLKOUT_ENABLE(RCC_PLL_QCLK);
        /* SAI2 clock source configuration done later after clock selection check */
        break;

      case RCC_SAI2CLKSOURCE_PLL2P:  /* PLL2_P is used as clock source for SAI2 */
        __HAL_RCC_PLL2CLKOUT_ENABLE(RCC_PLL_PCLK);
        /* SAI2 clock source configuration done later after clock selection check */
        break;

      case RCC_SAI2CLKSOURCE_PLL3P:  /* PLL3_P is used as clock source for SAI2 */
        __HAL_RCC_PLL3CLKOUT_ENABLE(RCC_PLL_PCLK);
        /* SAI2 clock source configuration done later after clock selection check */
        break;

      case RCC_SAI2CLKSOURCE_PIN:   /* External clock is used as source of SAI2 clock */
        /* SAI2 clock source configuration done later after clock selection check */
        break;

      case RCC_SAI2CLKSOURCE_CLKP:
        /* HSI, HSE, or CSI oscillator is used as source of SAI2 clock */
        /* SAI2 clock source configuration done later after clock selection check */
        break;

      case RCC_SAI2CLKSOURCE_SPDIF: /* SPDIF clock is used as source of SAI2 clock */
        /* SAI2 clock source configuration done later after clock selection check */
        break;

      default:
        ret = HAL_ERROR;
        break;
    }

    if (ret == HAL_OK)
    {
      /* Set the source of SAI2 clock*/
      __HAL_RCC_SAI2_CONFIG(PeriphClkInit->Sai2ClockSelection);
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*---------------------------- SPDIFRX configuration -------------------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_SPDIFRX) == RCC_PERIPHCLK_SPDIFRX)
  {
    /* Check the parameters */
    assert_param(IS_RCC_SPDIFRXCLKSOURCE(PeriphClkInit->SpdifrxClockSelection));

    switch (PeriphClkInit->SpdifrxClockSelection)
    {
      case RCC_SPDIFRXCLKSOURCE_PLL1Q: /* PLL1_Q is used as clock source for SPDIFRX */
        /* Enable PLL1Q Clock output generated form System PLL . */
        __HAL_RCC_PLL1CLKOUT_ENABLE(RCC_PLL_QCLK);
        /* SPDIFRX clock source configuration done later after clock selection check */
        break;

      case RCC_SPDIFRXCLKSOURCE_PLL2R: /* PLL2_R is used as clock source for SPDIFRX */
        __HAL_RCC_PLL2CLKOUT_ENABLE(RCC_PLL_RCLK);
        /* SPDIFRX clock source configuration done later after clock selection check */
        break;

      case RCC_SPDIFRXCLKSOURCE_PLL3R:  /* PLL3_R is used as clock source for SPDIFRX */
        __HAL_RCC_PLL3CLKOUT_ENABLE(RCC_PLL_RCLK);
        /* SPDIFRX clock source configuration done later after clock selection check */
        break;

      case RCC_SPDIFRXCLKSOURCE_HSI:
        /* Internal OSC clock is used as source of SPDIFRX clock*/
        /* SPDIFRX clock source configuration done later after clock selection check */
        break;

      default:
        ret = HAL_ERROR;
        break;
    }

    if (ret == HAL_OK)
    {
      /* Set the source of SPDIFRX clock */
      __HAL_RCC_SPDIFRX_CONFIG(PeriphClkInit->SpdifrxClockSelection);
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*---------------------------- SPI1 configuration --------------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_SPI1) == RCC_PERIPHCLK_SPI1)
  {
    /* Check the parameters */
    assert_param(IS_RCC_SPI1CLKSOURCE(PeriphClkInit->Spi1ClockSelection));

    switch (PeriphClkInit->Spi1ClockSelection)
    {
      case RCC_SPI1CLKSOURCE_PLL1Q:  /* PLL1_Q is used as clock source for SPI1 */
        /* Enable SPI Clock output generated form System PLL . */
        __HAL_RCC_PLL1CLKOUT_ENABLE(RCC_PLL_QCLK);
        /* SPI1 clock source configuration done later after clock selection check */
        break;

      case RCC_SPI1CLKSOURCE_PLL2P:  /* PLL2_P is used as clock source for SPI1 */
        __HAL_RCC_PLL2CLKOUT_ENABLE(RCC_PLL_PCLK);
        /* SPI1 clock source configuration done later after clock selection check */
        break;

      case RCC_SPI1CLKSOURCE_PLL3P:  /* PLL3_P is used as clock source for SPI1 */
        __HAL_RCC_PLL3CLKOUT_ENABLE(RCC_PLL_PCLK);
        /* SPI1 clock source configuration done later after clock selection check */
        break;

      case RCC_SPI1CLKSOURCE_PIN:   /* External I2S_CKIN is used as clock source for SPI1 */
        /* SPI1 clock source configuration done later after clock selection check */
        break;

      case RCC_SPI1CLKSOURCE_CLKP:  /* HSI, HSE, or CSI oscillator is used as source of SPI1 clock */
        /* SPI1 clock source configuration done later after clock selection check */
        break;

      default:
        ret = HAL_ERROR;
        break;
    }

    if (ret == HAL_OK)
    {
      /* Set the source of SPI1 clock*/
      __HAL_RCC_SPI1_CONFIG(PeriphClkInit->Spi1ClockSelection);
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*---------------------------- SPI2/SPI3 configuration ---------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_SPI23) == RCC_PERIPHCLK_SPI23)
  {
    /* Check the parameters */
    assert_param(IS_RCC_SPI23CLKSOURCE(PeriphClkInit->Spi23ClockSelection));

    switch (PeriphClkInit->Spi23ClockSelection)
    {
      case RCC_SPI23CLKSOURCE_PLL1Q:  /* PLL1_Q is used as clock source for SPI2/SPI3 */
        /* Enable SPI Clock output generated form System PLL . */
        __HAL_RCC_PLL1CLKOUT_ENABLE(RCC_PLL_QCLK);
        /* SPI2/SPI3 clock source configuration done later after clock selection check */
        break;

      case RCC_SPI23CLKSOURCE_PLL2P:  /* PLL2_P is used as clock source for SPI2/SPI3 */
        __HAL_RCC_PLL2CLKOUT_ENABLE(RCC_PLL_PCLK);
        /* SPI2/SPI3 clock source configuration done later after clock selection check */
        break;

      case RCC_SPI23CLKSOURCE_PLL3P:  /* PLL3_P is used as clock source for SPI2/SPI3 */
        __HAL_RCC_PLL3CLKOUT_ENABLE(RCC_PLL_PCLK);
        /* SPI2/SPI3 clock source configuration done later after clock selection check */
        break;

      case RCC_SPI23CLKSOURCE_PIN:   /* External clock I2S_CKIN is used as clock source for SPI2/SPI3 */
        /* SPI2/SPI3 clock source configuration done later after clock selection check */
        break;

      case RCC_SPI23CLKSOURCE_CLKP:  /* HSI, HSE, or CSI oscillator is used as source of SPI2/SPI3 clock */
        /* SPI2/SPI3 clock source configuration done later after clock selection check */
        break;

      default:
        ret = HAL_ERROR;
        break;
    }

    if (ret == HAL_OK)
    {
      /* Set the source of SPI2/SPI3 clock*/
      __HAL_RCC_SPI23_CONFIG(PeriphClkInit->Spi23ClockSelection);
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*---------------------------- SPI4/5 configuration -------------------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_SPI45) == RCC_PERIPHCLK_SPI45)
  {
    /* Check the parameters */
    assert_param(IS_RCC_SPI45CLKSOURCE(PeriphClkInit->Spi45ClockSelection));

    switch (PeriphClkInit->Spi45ClockSelection)
    {
      case RCC_SPI45CLKSOURCE_PCLK2:  /* PCLK2 as clock source for SPI4/SPI5 */
        /* SPI4/SPI5 clock source configuration done later after clock selection check */
        break;

      case RCC_SPI45CLKSOURCE_PLL2Q:  /* PLL2_Q is used as clock source for SPI4/SPI5 */
        __HAL_RCC_PLL2CLKOUT_ENABLE(RCC_PLL_QCLK);
        /* SPI4/SPI5 clock source configuration done later after clock selection check */
        break;

      case RCC_SPI45CLKSOURCE_PLL3Q:  /* PLL3_Q is used as clock source for SPI4/SPI5 */
        __HAL_RCC_PLL3CLKOUT_ENABLE(RCC_PLL_QCLK);
        /* SPI4/SPI5 clock source configuration done later after clock selection check */
        break;

      case RCC_SPI45CLKSOURCE_HSI: /* HSI oscillator clock is used as source of SPI4/SPI5 */
        /* SPI4/SPI5 clock source configuration done later after clock selection check */
        break;

      case RCC_SPI45CLKSOURCE_CSI: /* CSI oscillator clock is used as source of SPI4/SPI5 */
        /* SPI4/SPI5 clock source configuration done later after clock selection check */
        break;

      case RCC_SPI45CLKSOURCE_HSE: /* HSE oscillator clock is used as source of SPI4/SPI5 */
        /* SPI4/SPI5 clock source configuration done later after clock selection check */
        break;

      default:
        ret = HAL_ERROR;
        break;
    }

    if (ret == HAL_OK)
    {
      /* Set the source of SPI4/SPI5 clock */
      __HAL_RCC_SPI45_CONFIG(PeriphClkInit->Spi45ClockSelection);
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*---------------------------- SPI6 configuration --------------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_SPI6) == RCC_PERIPHCLK_SPI6)
  {
    /* Check the parameters */
    assert_param(IS_RCC_SPI6CLKSOURCE(PeriphClkInit->Spi6ClockSelection));

    switch (PeriphClkInit->Spi6ClockSelection)
    {
      case RCC_SPI6CLKSOURCE_PCLK4: /* PCLK4 as clock source for SPI6 */
        /* SPI6 clock source configuration done later after clock selection check */
        break;

      case RCC_SPI6CLKSOURCE_PLL2Q:  /* PLL2_Q is used as clock source for SPI6 */
        __HAL_RCC_PLL2CLKOUT_ENABLE(RCC_PLL_QCLK);
        /* SPI6 clock source configuration done later after clock selection check */
        break;

      case RCC_SPI6CLKSOURCE_PLL3Q:  /* PLL3_Q is used as clock source for SPI6 */
        __HAL_RCC_PLL3CLKOUT_ENABLE(RCC_PLL_QCLK);
        /* SPI6 clock source configuration done later after clock selection check */
        break;

      case RCC_SPI6CLKSOURCE_HSI: /* HSI oscillator clock is used as source for SPI6 */
        /* SPI6 clock source configuration done later after clock selection check */
        break;

      case RCC_SPI6CLKSOURCE_CSI: /* CSI oscillator clock is used as source for SPI6 */
        /* SPI6 clock source configuration done later after clock selection check */
        break;

      case RCC_SPI6CLKSOURCE_HSE: /* HSE oscillator is used as source for SPI6 */
        /* SPI6 clock source configuration done later after clock selection check */
        break;

      default:
        ret = HAL_ERROR;
        break;
    }

    if (ret == HAL_OK)
    {
      /* Set the source of SPI6 clock*/
      __HAL_RCC_SPI6_CONFIG(PeriphClkInit->Spi6ClockSelection);
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*-------------------------- USART1 configuration --------------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_USART1) == RCC_PERIPHCLK_USART1)
  {
    /* Check the parameters */
    assert_param(IS_RCC_USART1CLKSOURCE(PeriphClkInit->Usart1ClockSelection));

    switch (PeriphClkInit->Usart1ClockSelection)
    {
      case RCC_USART1CLKSOURCE_PCLK2: /* PCLK2 as clock source for USART1 */
        /* USART1 clock source configuration done later after clock selection check */
        break;

      case RCC_USART1CLKSOURCE_PLL2Q: /* PLL2_Q is used as clock source for USART1 */
        __HAL_RCC_PLL2CLKOUT_ENABLE(RCC_PLL_QCLK);
        /* USART1 clock source configuration done later after clock selection check */
        break;

      case RCC_USART1CLKSOURCE_PLL3Q: /* PLL3_Q is used as clock source for USART1 */
        __HAL_RCC_PLL3CLKOUT_ENABLE(RCC_PLL_QCLK);
        /* USART1 clock source configuration done later after clock selection check */
        break;

      case RCC_USART1CLKSOURCE_HSI: /* HSI oscillator clock is used as source for USART1 */
        /* USART1 clock source configuration done later after clock selection check */
        break;

      case RCC_USART1CLKSOURCE_CSI: /* CSI oscillator clock is used as source for USART1 */
        /* USART1 clock source configuration done later after clock selection check */
        break;

      case RCC_USART1CLKSOURCE_LSE: /* LSE oscillator is used as source for USART1 */
        /* USART1 clock source configuration done later after clock selection check */
        break;

      default:
        ret = HAL_ERROR;
        break;
    }

    if (ret == HAL_OK)
    {
      /* Set the source of USART1 clock */
      __HAL_RCC_USART1_CONFIG(PeriphClkInit->Usart1ClockSelection);
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*------------- USART2/USART3/UART4/UART5/UART7/UART8 Configuration --------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_USART234578) == RCC_PERIPHCLK_USART234578)
  {
    /* Check the parameters */
    assert_param(IS_RCC_USART234578CLKSOURCE(PeriphClkInit->Usart234578ClockSelection));

    switch (PeriphClkInit->Usart234578ClockSelection)
    {
      case RCC_USART234578CLKSOURCE_PCLK1: /* PCLK1 as clock source for USART2/USART3/UART4/UART5/UART7/UART8 */
        /* USART2/USART3/UART4/UART5/UART7/UART8 clock source configuration done later after clock selection check */
        break;

      case RCC_USART234578CLKSOURCE_PLL2Q: /* PLL2_Q is used as clock source for USART2/USART3/UART4/UART5/UART7/UART8 */
        __HAL_RCC_PLL2CLKOUT_ENABLE(RCC_PLL_QCLK);
        /* USART2/USART3/UART4/UART5/UART7/UART8 clock source configuration done later after clock selection check */
        break;

      case RCC_USART234578CLKSOURCE_PLL3Q: /* PLL3_Q is used as clock source for USART2/USART3/UART4/UART5/UART7/UART8 */
        __HAL_RCC_PLL3CLKOUT_ENABLE(RCC_PLL_QCLK);
        /* USART2/USART3/UART4/UART5/UART7/UART8 clock source configuration done later after clock selection check */
        break;

      case RCC_USART234578CLKSOURCE_HSI:
        /* HSI oscillator clock is used as source of USART2/USART3/UART4/UART5/UART7/UART8 clock */
        /* USART2/USART3/UART4/UART5/UART7/UART8 clock source configuration done later after clock selection check */
        break;

      case RCC_USART234578CLKSOURCE_CSI:
        /* CSI oscillator clock is used as source of USART2/USART3/UART4/UART5/UART7/UART8 clock */
        /* USART2/USART3/UART4/UART5/UART7/UART8 clock source configuration done later after clock selection check */
        break;

      case RCC_USART234578CLKSOURCE_LSE:
        /* LSE,  oscillator is used as source of USART2/USART3/UART4/UART5/UART7/UART8 clock */
        /* USART2/USART3/UART4/UART5/UART7/UART8 clock source configuration done later after clock selection check */
        break;

      default:
        ret = HAL_ERROR;
        break;
    }

    if (ret == HAL_OK)
    {
      /* Set the source of USART2/USART3/UART4/UART5/UART7/UART8 clock */
      __HAL_RCC_USART234578_CONFIG(PeriphClkInit->Usart234578ClockSelection);
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*------------------------------ USBPHYC Configuration ---------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_USBPHYC) == RCC_PERIPHCLK_USBPHYC)
  {
    /* Check the parameters */
    assert_param(IS_RCC_USBPHYCCLKSOURCE(PeriphClkInit->UsbPhycClockSelection));
    switch (PeriphClkInit->UsbPhycClockSelection)
    {
      case RCC_USBPHYCCLKSOURCE_PLL3Q: /* PLL3_Q is used as clock source for USBPHYC */
        __HAL_RCC_PLL3CLKOUT_ENABLE(RCC_PLL_QCLK);
        /* USBPHYC clock source configuration done later after clock selection check */
        break;

      case RCC_USBPHYCCLKSOURCE_HSE:      /* HSE is used as clock source for USBPHYC */
      case RCC_USBPHYCCLKSOURCE_HSE_DIV2: /* HSE divided by 2 is used as clock source for USBPHYC */
        /* USBPHYC clock source configuration done later after clock selection check */
        break;

      default:
        ret = HAL_ERROR;
        break;
    }

    if (ret == HAL_OK)
    {
      /* Set the source of USBPHYC clock*/
      __HAL_RCC_USBPHYC_CONFIG(PeriphClkInit->UsbPhycClockSelection);
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*------------------------------ USBOTGFS Configuration ---------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_USBOTGFS) == RCC_PERIPHCLK_USBOTGFS)
  {
    /* Check the parameters */
    assert_param(IS_RCC_USBOTGFSCLKSOURCE(PeriphClkInit->UsbOtgFsClockSelection));

    switch (PeriphClkInit->UsbOtgFsClockSelection)
    {
      case RCC_USBOTGFSCLKSOURCE_PLL3Q: /* PLL3_Q is used as clock source for USB OTG FS */
        __HAL_RCC_PLL3CLKOUT_ENABLE(RCC_PLL_QCLK);
        /* USB OTG FS clock source configuration done later after clock selection check */
        break;

      case RCC_USBOTGFSCLKSOURCE_HSI48: /* HSI48 is used as clock source for USB OTG FS */
      case RCC_USBOTGFSCLKSOURCE_HSE:   /* HSE is used as clock source for USB OTG FS */
      case RCC_USBOTGFSCLKSOURCE_CLK48: /* USBPHYC CLK48 is used as clock source for USB OTG FS */
        /* USB OTG FS clock source configuration done later after clock selection check */
        break;

      default:
        ret = HAL_ERROR;
        break;
    }

    if (ret == HAL_OK)
    {
      /* Set the source of USBPHYC clock*/
      __HAL_RCC_USBOTGFS_CONFIG(PeriphClkInit->UsbOtgFsClockSelection);
    }
    else
    {
      /* set overall return value */
      status = ret;
    }
  }

  /*------------------------------------ TIM configuration --------------------------------------*/
  if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_TIM) == RCC_PERIPHCLK_TIM)
  {
    /* Check the parameters */
    assert_param(IS_RCC_TIMCLKPRESCALER(PeriphClkInit->TIMPresSelection));

    /* Configure Timer Prescaler */
    __HAL_RCC_TIMCLKPRESCALER_CONFIG(PeriphClkInit->TIMPresSelection);
  }

  /*---------------------- USB REF configuration --------------------------------*/
 if ((PeriphClkInit->PeriphClockSelection & RCC_PERIPHCLK_USBREF) == RCC_PERIPHCLK_USBREF)
  {
    /* Check the parameters */
    assert_param(IS_RCC_USBREFCLKSOURCE(PeriphClkInit->UsbRefClockSelection));

    /* Set USB REF clock frequency*/
    __HAL_RCC_USBREF_CONFIG(PeriphClkInit->UsbRefClockSelection);
  }

  if (status == HAL_OK)
  {
    return HAL_OK;
  }
  return HAL_ERROR;
}

void HAL_RCCEx_GetPeriphCLKConfig(RCC_PeriphCLKInitTypeDef  *PeriphClkInit)
{
  /* Set all possible values for the extended clock type parameter------------*/
  PeriphClkInit->PeriphClockSelection = RCC_PERIPHCLK_ADC     | RCC_PERIPHCLK_ADF1     | RCC_PERIPHCLK_CEC         | \
                                        RCC_PERIPHCLK_CKPER   | RCC_PERIPHCLK_ETH1REF  | RCC_PERIPHCLK_ETH1PHY     | \
                                        RCC_PERIPHCLK_FDCAN   | RCC_PERIPHCLK_FMC      | RCC_PERIPHCLK_I2C1_I3C1   | \
                                        RCC_PERIPHCLK_I2C23   | RCC_PERIPHCLK_LPTIM1   | RCC_PERIPHCLK_LPTIM23     | \
                                        RCC_PERIPHCLK_LPTIM45 | RCC_PERIPHCLK_LTDC     | RCC_PERIPHCLK_LPUART1     | \
                                        RCC_PERIPHCLK_XSPI1   | RCC_PERIPHCLK_XSPI2    | RCC_PERIPHCLK_PSSI        | \
                                        RCC_PERIPHCLK_RTC     | RCC_PERIPHCLK_SAI1     | RCC_PERIPHCLK_SAI2        | \
                                        RCC_PERIPHCLK_SDMMC12 | RCC_PERIPHCLK_SPDIFRX  | RCC_PERIPHCLK_SPI1        | \
                                        RCC_PERIPHCLK_SPI23   | RCC_PERIPHCLK_SPI45    | RCC_PERIPHCLK_SPI6        | \
                                        RCC_PERIPHCLK_TIM     | RCC_PERIPHCLK_USART1   | RCC_PERIPHCLK_USART234578 | \
                                        RCC_PERIPHCLK_USBPHYC | RCC_PERIPHCLK_USBOTGFS | RCC_PERIPHCLK_USBREF;

  /* Get the ADC clock source ------------------------------------------------*/
  PeriphClkInit->AdcClockSelection          = __HAL_RCC_GET_ADC_SOURCE();
  /* Get the ADF1 clock source -----------------------------------------------*/
  PeriphClkInit->Adf1ClockSelection         = __HAL_RCC_GET_ADF1_SOURCE();
  /* Get the CEC clock source ------------------------------------------------*/
  PeriphClkInit->CecClockSelection          = __HAL_RCC_GET_CEC_SOURCE();
  /* Get the CKPER clock source ----------------------------------------------*/
  PeriphClkInit->CkperClockSelection        = __HAL_RCC_GET_CLKP_SOURCE();
  /* Get the ETH1 clock source ----------------------------------------------*/
  PeriphClkInit->Eth1RefClockSelection      = __HAL_RCC_GET_ETH1REF_SOURCE();
  /* Get the ETH1PHY clock source ----------------------------------------------*/
  PeriphClkInit->Eth1PhyClockSelection      = __HAL_RCC_GET_ETH1PHY_SOURCE();
  /* Get the FDCAN kernel clock source ---------------------------------------*/
  PeriphClkInit->FdcanClockSelection        = __HAL_RCC_GET_FDCAN_SOURCE();
  /* Get the FMC kernel clock source -----------------------------------------*/
  PeriphClkInit->FmcClockSelection          = __HAL_RCC_GET_FMC_SOURCE();
  /* Get the I2C1 clock source -----------------------------------------------*/
  PeriphClkInit->I2c1_I3c1ClockSelection    = __HAL_RCC_GET_I2C1_I3C1_SOURCE();
  /* Get the I2C2/I2C3 clock source ------------------------------------------*/
  PeriphClkInit->I2c23ClockSelection        = __HAL_RCC_GET_I2C23_SOURCE();
  /* Get the LPTIM1 clock source ---------------------------------------------*/
  PeriphClkInit->Lptim1ClockSelection       = __HAL_RCC_GET_LPTIM1_SOURCE();
  /* Get the LPTIM2/LPTIM3 clock source --------------------------------------*/
  PeriphClkInit->Lptim23ClockSelection      = __HAL_RCC_GET_LPTIM23_SOURCE();
  /* Get the LPTIM4/LPTIM5 clock source --------------------------------------*/
  PeriphClkInit->Lptim45ClockSelection      = __HAL_RCC_GET_LPTIM45_SOURCE();
  /* Get the LPUART1 clock source --------------------------------------------*/
  PeriphClkInit->Lpuart1ClockSelection      = __HAL_RCC_GET_LPUART1_SOURCE();
  /* Get the LTDC clock source -----------------------------------------------*/
  PeriphClkInit->LtdcClockSelection         = __HAL_RCC_GET_LTDC_SOURCE();
  /* Get the XSPI1 clock source -----------------------------------------------*/
  PeriphClkInit->Xspi1ClockSelection        = __HAL_RCC_GET_XSPI1_SOURCE();
  /* Get the XSPI2 clock source -----------------------------------------------*/
  PeriphClkInit->Xspi2ClockSelection        = __HAL_RCC_GET_XSPI2_SOURCE();
  /* Get the PSSI clock source -----------------------------------------------*/
  PeriphClkInit->PssiClockSelection         = __HAL_RCC_GET_PSSI_SOURCE();
  /* Get the RTC clock source -----------------------------------------------*/
  PeriphClkInit->RTCClockSelection          = __HAL_RCC_GET_RTC_SOURCE();
  /* Get the SAI1 clock source -----------------------------------------------*/
  PeriphClkInit->Sai1ClockSelection         = __HAL_RCC_GET_SAI1_SOURCE();
  /* Get the SAI2 clock source -----------------------------------------------*/
  PeriphClkInit->Sai2ClockSelection         = __HAL_RCC_GET_SAI2_SOURCE();
  /* Get the SDMMC clock source ----------------------------------------------*/
  PeriphClkInit->Sdmmc12ClockSelection      = __HAL_RCC_GET_SDMMC12_SOURCE();
  /* Get the SPDIFRX clock source --------------------------------------------*/
  PeriphClkInit->SpdifrxClockSelection      = __HAL_RCC_GET_SPDIFRX_SOURCE();
  /* Get the SPI1 clock source -----------------------------------------------*/
  PeriphClkInit->Spi1ClockSelection         = __HAL_RCC_GET_SPI1_SOURCE();
  /* Get the SPI2/SPI3 clock source ------------------------------------------*/
  PeriphClkInit->Spi23ClockSelection        = __HAL_RCC_GET_SPI23_SOURCE();
  /* Get the SPI4/SPI5 clock source ------------------------------------------*/
  PeriphClkInit->Spi45ClockSelection        = __HAL_RCC_GET_SPI45_SOURCE();
  /* Get the SPI6 clock source -----------------------------------------------*/
  PeriphClkInit->Spi6ClockSelection         = __HAL_RCC_GET_SPI6_SOURCE();
  /* Get the TIM Prescaler configuration -------------------------------------*/
  if ((RCC->CFGR & RCC_CFGR_TIMPRE) == 0U)
  {
    PeriphClkInit->TIMPresSelection = RCC_TIMPRES_DISABLE;
  }
  else
  {
    PeriphClkInit->TIMPresSelection = RCC_TIMPRES_ENABLE;
  }
  /* Get the USART1 configuration --------------------------------------------*/
  PeriphClkInit->Usart1ClockSelection       = __HAL_RCC_GET_USART1_SOURCE();
  /* Get the USART2/USART3/UART4/UART5/UART7/UART8 clock source --------------*/
  PeriphClkInit->Usart234578ClockSelection  = __HAL_RCC_GET_USART234578_SOURCE();
  /* Get the USBPHYC clock source --------------------------------------------*/
  PeriphClkInit->UsbPhycClockSelection      = __HAL_RCC_GET_USBPHYC_SOURCE();
  /* Get the USB OTG FS clock source -----------------------------------------*/
  PeriphClkInit->UsbOtgFsClockSelection     = __HAL_RCC_GET_USBOTGFS_SOURCE();
  /* Get the USB REF clock frequency -----------------------------------------*/
  PeriphClkInit->UsbRefClockSelection       = __HAL_RCC_GET_USBREF_SOURCE();
}

uint32_t HAL_RCCEx_GetPeriphCLKFreq(uint32_t PeriphClk)
{
  uint32_t frequency = 0; /* Set to 0 for returned value if no source clock */
  uint32_t clocksource;
  uint32_t ethclocksource;
  uint32_t prescaler;

  switch (PeriphClk)
  {
    case RCC_PERIPHCLK_FMC:
      clocksource = __HAL_RCC_GET_FMC_SOURCE();

      switch (clocksource)
      {
        case RCC_FMCCLKSOURCE_HCLK: /* HCLK is the clock source for FMC kernel peripheral clock */
          frequency = HAL_RCC_GetHCLKFreq();
          break;
        case RCC_FMCCLKSOURCE_PLL1Q: /* PLL1 'Q' is the clock source for FMC kernel peripheral clock */
          if (__HAL_RCC_GET_PLL1CLKOUT_CONFIG(RCC_PLL_QCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL1QFreq();
          }
          break;
        case RCC_FMCCLKSOURCE_PLL2R: /* PLL2 'R' is the clock source for FMC kernel peripheral clock */
          if (__HAL_RCC_GET_PLL2CLKOUT_CONFIG(RCC_PLL_RCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL2RFreq();
          }
          break;
        case RCC_FMCCLKSOURCE_HSI: /* HSI is the clock source for FMC kernel peripheral clock */
          if (READ_BIT(RCC->CR, RCC_CR_HSIRDY) != 0U)
          {
            if (READ_BIT(RCC->CR, RCC_CR_HSIDIVF) != 0U)
            {
              frequency = (HSI_VALUE >> (__HAL_RCC_GET_HSI_DIVIDER() >> RCC_CR_HSIDIV_Pos));
            }
            else
            {
              /* Can't retrieve HSIDIV value */
            }
          }
          break;
        case RCC_FMCCLKSOURCE_HCLK_DIV4: /* HCLK/4 is the clock source for FMC kernel peripheral clock */
          frequency = (HAL_RCC_GetHCLKFreq() / 4U);
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_XSPI1:
      clocksource = __HAL_RCC_GET_XSPI1_SOURCE();

      switch (clocksource)
      {
        case RCC_XSPI1CLKSOURCE_HCLK: /* HCLK is the clock source for XSPI1 kernel peripheral clock */
          frequency = HAL_RCC_GetHCLKFreq();
          break;
        case RCC_XSPI1CLKSOURCE_PLL2S: /* PLL2 'S' is the clock source for XSPI1 kernel peripheral clock */
          if (__HAL_RCC_GET_PLL2CLKOUT_CONFIG(RCC_PLL_SCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL2SFreq();
          }
          break;
        case RCC_XSPI1CLKSOURCE_PLL2T: /* PLL2 'T' is the clock source for XSPI1 kernel peripheral clock */
          if (__HAL_RCC_GET_PLL2CLKOUT_CONFIG(RCC_PLL_TCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL2TFreq();
          }
          break;
        case RCC_XSPI1CLKSOURCE_HCLK_DIV4: /* HCLK/4 is the clock source for XSPI1 kernel peripheral clock */
          frequency = (HAL_RCC_GetHCLKFreq() / 4U);
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_XSPI2:
      clocksource = __HAL_RCC_GET_XSPI2_SOURCE();

      switch (clocksource)
      {
        case RCC_XSPI2CLKSOURCE_HCLK: /* HCLK is the clock source for XSPI2 kernel peripheral clock */
          frequency = HAL_RCC_GetHCLKFreq();
          break;
        case RCC_XSPI2CLKSOURCE_PLL2S: /* PLL2 'S' is the clock source for XSPI2 kernel peripheral clock */
          if (__HAL_RCC_GET_PLL2CLKOUT_CONFIG(RCC_PLL_SCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL2SFreq();
          }
          break;
        case RCC_XSPI2CLKSOURCE_PLL2T: /* PLL2 'T' is the clock source for XSPI2 kernel peripheral clock */
          if (__HAL_RCC_GET_PLL2CLKOUT_CONFIG(RCC_PLL_TCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL2TFreq();
          }
          break;
        case RCC_XSPI2CLKSOURCE_HCLK_DIV4: /* HCLK/4 is the clock source for XSPI2 kernel peripheral clock */
          frequency = (HAL_RCC_GetHCLKFreq() / 4U);
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_CKPER:
      clocksource = __HAL_RCC_GET_CLKP_SOURCE();

      switch (clocksource)
      {
        case RCC_CLKPSOURCE_HSI: /* HSI is the clock source for CKPER */
          if (READ_BIT(RCC->CR, RCC_CR_HSIRDY) != 0U)
          {
            if (READ_BIT(RCC->CR, RCC_CR_HSIDIVF) != 0U)
            {
              frequency = (HSI_VALUE >> (__HAL_RCC_GET_HSI_DIVIDER() >> RCC_CR_HSIDIV_Pos));
            }
            else
            {
              /* Can't retrieve HSIDIV value */
            }
          }
          break;
        case RCC_CLKPSOURCE_CSI: /* CSI is the clock source for CKPER */
          if (READ_BIT(RCC->CR, RCC_CR_CSIRDY) != 0U)
          {
            frequency = CSI_VALUE;
          }
          break;
        case RCC_CLKPSOURCE_HSE: /* HSE is the clock source for CKPER */
          if (READ_BIT(RCC->CR, RCC_CR_HSERDY) != 0U)
          {
            frequency = HSE_VALUE;
          }
          break;

        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_ADC:
      clocksource = __HAL_RCC_GET_ADC_SOURCE();

      switch (clocksource)
      {
        case RCC_ADCCLKSOURCE_PLL2P: /* PLL2 'P' is the clock source for ADC */
          if (__HAL_RCC_GET_PLL2CLKOUT_CONFIG(RCC_PLL_PCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL2PFreq();
          }
          break;
        case RCC_ADCCLKSOURCE_PLL3R: /* PLL3 'R' is the clock source for ADC */
          if (__HAL_RCC_GET_PLL3CLKOUT_CONFIG(RCC_PLL_RCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL3RFreq();
          }
          break;
        case RCC_ADCCLKSOURCE_CLKP: /* CKPER is the clock source for ADC */
          frequency = RCC_GetCLKPFreq();
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_ADF1:
      clocksource = __HAL_RCC_GET_ADF1_SOURCE();

      switch (clocksource)
      {
        case RCC_ADF1CLKSOURCE_HCLK: /* HCLK is the clock source for ADF1 */
          frequency = HAL_RCC_GetHCLKFreq();
          break;
        case RCC_ADF1CLKSOURCE_PLL2P: /* PLL2 'P' is the clock source for ADF1 */
          if (__HAL_RCC_GET_PLL2CLKOUT_CONFIG(RCC_PLL_PCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL2PFreq();
          }
          break;
        case RCC_ADF1CLKSOURCE_PLL3P: /* PLL3 'P' is the clock source for ADF1 */
          if (__HAL_RCC_GET_PLL3CLKOUT_CONFIG(RCC_PLL_PCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL3PFreq();
          }
          break;
        case RCC_ADF1CLKSOURCE_PIN: /* External I2S_CKIN is used as clock source for ADF1 */
          frequency = EXTERNAL_CLOCK_VALUE;
          break;
        case RCC_ADF1CLKSOURCE_CSI: /* CSI is the clock source for ADF1 */
          if (READ_BIT(RCC->CR, RCC_CR_CSIRDY) != 0U)
          {
            frequency = CSI_VALUE;
          }
          break;
        case RCC_ADF1CLKSOURCE_HSI: /* HSI is the clock source for ADF1 */
          if (READ_BIT(RCC->CR, RCC_CR_HSIRDY) != 0U)
          {
            if (READ_BIT(RCC->CR, RCC_CR_HSIDIVF) != 0U)
            {
              frequency = (HSI_VALUE >> (__HAL_RCC_GET_HSI_DIVIDER() >> RCC_CR_HSIDIV_Pos));
            }
            else
            {
              /* Can't retrieve HSIDIV value */
            }
          }
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_CEC:
      clocksource = __HAL_RCC_GET_CEC_SOURCE();

      switch (clocksource)
      {
        case RCC_CECCLKSOURCE_LSE: /* LSE is the clock source for CEC */
          if (READ_BIT(RCC->BDCR, RCC_BDCR_LSERDY) != 0U)
          {
            frequency = LSE_VALUE;
          }
          break;
        case RCC_CECCLKSOURCE_LSI: /* LSI is the clock source for CEC */
          if (READ_BIT(RCC->CSR, RCC_CSR_LSIRDY) != 0U)
          {
            frequency = LSI_VALUE;
          }
          break;
        case RCC_CECCLKSOURCE_CSI: /* CSI is the clock source for CEC */
          if (READ_BIT(RCC->CR, RCC_CR_CSIRDY) != 0U)
          {
            frequency = CSI_VALUE;
          }
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_ETH1REF:
      clocksource = __HAL_RCC_GET_ETH1REF_SOURCE();

      switch (clocksource)
      {
        case RCC_ETH1REFCLKSOURCE_PHY: /* PHY is the clock source for ETH1REF */
          /* Can't retrieve this source's frequency, it is by default set to 0 */
          break;
        case RCC_ETH1REFCLKSOURCE_HSE: /* HSE is the clock source for ETH1REF */
          if (READ_BIT(RCC->CR, RCC_CR_HSERDY) != 0U)
          {
            frequency = HSE_VALUE;
          }
          break;
        case RCC_ETH1REFCLKSOURCE_ETH: /* ETH is the clock source for ETH1REF */
          ethclocksource = __HAL_RCC_GET_ETH1PHY_SOURCE();

          switch (ethclocksource)
          {
            case RCC_ETH1PHYCLKSOURCE_HSE:
              if (READ_BIT(RCC->CR, RCC_CR_HSERDY) != 0U)
              {
                frequency = HSE_VALUE;
              }
              break;
            case RCC_ETH1PHYCLKSOURCE_PLL3S:
              if (__HAL_RCC_GET_PLL3CLKOUT_CONFIG(RCC_PLL_SCLK) != 0U)
              {
                frequency = HAL_RCC_GetPLL3SFreq();
              }
              break;
            default:
              /* Nothing to do, frequency is by default set to 0 */
              break;
          }
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_ETH1PHY:
      clocksource = __HAL_RCC_GET_ETH1PHY_SOURCE();

      switch (clocksource)
      {
        case RCC_ETH1PHYCLKSOURCE_HSE:
          if (READ_BIT(RCC->CR, RCC_CR_HSERDY) != 0U)
          {
            frequency = HSE_VALUE;
          }
          break;
        case RCC_ETH1PHYCLKSOURCE_PLL3S:
          if (__HAL_RCC_GET_PLL3CLKOUT_CONFIG(RCC_PLL_SCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL3SFreq();
          }
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_FDCAN:
      clocksource = __HAL_RCC_GET_FDCAN_SOURCE();

      switch (clocksource)
      {
        case RCC_FDCANCLKSOURCE_HSE: /*!< HSE is the clock source for FDCAN */
          if (READ_BIT(RCC->CR, RCC_CR_HSERDY) != 0U)
          {
            frequency = HSE_VALUE;
          }
          break;
        case RCC_FDCANCLKSOURCE_PLL1Q: /*!< PLL1 'Q' ois the clock source for FDCAN */
          if (__HAL_RCC_GET_PLL1CLKOUT_CONFIG(RCC_PLL_QCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL1QFreq();
          }
          break;
        case RCC_FDCANCLKSOURCE_PLL2P: /*!< PLL2 'P' is the clock source for FDCAN */
          if (__HAL_RCC_GET_PLL2CLKOUT_CONFIG(RCC_PLL_PCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL2PFreq();
          }
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_I2C23:
      clocksource = __HAL_RCC_GET_I2C23_SOURCE();

      switch (clocksource)
      {
        case RCC_I2C23CLKSOURCE_PCLK1: /*!< PCLK1 is the clock source for I2C23 */
          frequency = HAL_RCC_GetPCLK1Freq();
          break;
        case RCC_I2C23CLKSOURCE_PLL3R: /*!< PLL3R is the clock source for I2C23 */
          if (__HAL_RCC_GET_PLL3CLKOUT_CONFIG(RCC_PLL_RCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL3RFreq();
          }
          break;
        case RCC_I2C23CLKSOURCE_HSI: /*!< HSI is the clock source for I2C23 */
          if (READ_BIT(RCC->CR, RCC_CR_HSIRDY) != 0U)
          {
            if (READ_BIT(RCC->CR, RCC_CR_HSIDIVF) != 0U)
            {
              frequency = (HSI_VALUE >> (__HAL_RCC_GET_HSI_DIVIDER() >> RCC_CR_HSIDIV_Pos));
            }
            else
            {
              /* Can't retrieve HSIDIV value */
            }
          }
          break;
        case RCC_I2C23CLKSOURCE_CSI: /*!< CSI is the clock source for I2C23 */
          if (READ_BIT(RCC->CR, RCC_CR_CSIRDY) != 0U)
          {
            frequency = CSI_VALUE;
          }
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_I2C1_I3C1:
      clocksource = __HAL_RCC_GET_I2C1_I3C1_SOURCE();

      switch (clocksource)
      {
        case RCC_I2C1_I3C1CLKSOURCE_PCLK1: /*!< PCLK1 is the clock source for I2C1/I3C1 */
          frequency = HAL_RCC_GetPCLK1Freq();
          break;
        case RCC_I2C1_I3C1CLKSOURCE_PLL3R: /*!< PLL3 'R' is the clock source for I2C1/I3C1 */
          if (__HAL_RCC_GET_PLL3CLKOUT_CONFIG(RCC_PLL_RCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL3RFreq();
          }
          break;
        case RCC_I2C1_I3C1CLKSOURCE_HSI: /*!< HSI is the clock source for I2C1/I3C1 */
          if (READ_BIT(RCC->CR, RCC_CR_HSIRDY) != 0U)
          {
            if (READ_BIT(RCC->CR, RCC_CR_HSIDIVF) != 0U)
            {
              frequency = (HSI_VALUE >> (__HAL_RCC_GET_HSI_DIVIDER() >> RCC_CR_HSIDIV_Pos));
            }
            else
            {
              /* Can't retrieve HSIDIV value */
            }
          }
          break;
        case RCC_I2C1_I3C1CLKSOURCE_CSI: /*!< CSI is the clock source for I2C1/I3C1 */
          if (READ_BIT(RCC->CR, RCC_CR_CSIRDY) != 0U)
          {
            frequency = CSI_VALUE;
          }
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_LPTIM1:
      clocksource = __HAL_RCC_GET_LPTIM1_SOURCE();

      switch (clocksource)
      {
        case RCC_LPTIM1CLKSOURCE_PCLK1: /* PCLK1 is the clock source for LPTIM1 */
          frequency = HAL_RCC_GetPCLK1Freq();
          break;
        case RCC_LPTIM1CLKSOURCE_PLL2P: /* PLL2 'P' is the clock source for LPTIM1 */
          if (__HAL_RCC_GET_PLL2CLKOUT_CONFIG(RCC_PLL_PCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL2PFreq();
          }
          break;
        case RCC_LPTIM1CLKSOURCE_PLL3R: /* PLL3 'R' is the clock source for LPTIM1 */
          if (__HAL_RCC_GET_PLL3CLKOUT_CONFIG(RCC_PLL_RCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL3RFreq();
          }
          break;
        case RCC_LPTIM1CLKSOURCE_LSE: /* LSE is the clock source for LPTIM1 */
          if (READ_BIT(RCC->BDCR, RCC_BDCR_LSERDY) != 0U)
          {
            frequency = LSE_VALUE;
          }
          break;
        case RCC_LPTIM1CLKSOURCE_LSI: /* LSI is the clock source for LPTIM1 */
          if (READ_BIT(RCC->CSR, RCC_CSR_LSIRDY) != 0U)
          {
            frequency = LSI_VALUE;
          }
          break;
        case RCC_LPTIM1CLKSOURCE_CLKP: /* CKPER is the clock source for LPTIM1 */
          frequency = RCC_GetCLKPFreq();
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_LPTIM23:
      clocksource = __HAL_RCC_GET_LPTIM23_SOURCE();

      switch (clocksource)
      {
        case RCC_LPTIM23CLKSOURCE_PCLK4: /* PCLK4 is the clock source for LPTIM2/LPTIM3 */
          frequency = HAL_RCC_GetPCLK4Freq();
          break;
        case RCC_LPTIM23CLKSOURCE_PLL2P: /* PLL2 'P' is the clock source for LPTIM2/LPTIM3 */
          if (__HAL_RCC_GET_PLL2CLKOUT_CONFIG(RCC_PLL_PCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL2PFreq();
          }
          break;
        case RCC_LPTIM23CLKSOURCE_PLL3R: /* PLL3 'R' is the clock source for LPTIM2/LPTIM3 */
          if (__HAL_RCC_GET_PLL3CLKOUT_CONFIG(RCC_PLL_RCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL3RFreq();
          }
          break;
        case RCC_LPTIM23CLKSOURCE_LSE: /* LSE is the clock source for LPTIM2/LPTIM3 */
          if (READ_BIT(RCC->BDCR, RCC_BDCR_LSERDY) != 0U)
          {
            frequency = LSE_VALUE;
          }
          break;
        case RCC_LPTIM23CLKSOURCE_LSI: /* LSI is the clock source for LPTIM2/LPTIM3 */
          if (READ_BIT(RCC->CSR, RCC_CSR_LSIRDY) != 0U)
          {
            frequency = LSI_VALUE;
          }
          break;
        case RCC_LPTIM23CLKSOURCE_CLKP: /* CKPER is the clock source for LPTIM2/LPTIM3 */
          frequency = RCC_GetCLKPFreq();
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_LPTIM45:
      clocksource = __HAL_RCC_GET_LPTIM45_SOURCE();

      switch (clocksource)
      {
        case RCC_LPTIM45CLKSOURCE_PCLK4: /* PCLK4 is the clock source for LPTIM4/LPTIM5 */
          frequency = HAL_RCC_GetPCLK4Freq();
          break;
        case RCC_LPTIM45CLKSOURCE_PLL2P: /* PLL2 'P' is the clock source for LPTIM4/LPTIM5 */
          if (__HAL_RCC_GET_PLL2CLKOUT_CONFIG(RCC_PLL_PCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL2PFreq();
          }
          break;
        case RCC_LPTIM45CLKSOURCE_PLL3R: /* PLL3 'R' is the clock source for LPTIM4/LPTIM5 */
          if (__HAL_RCC_GET_PLL3CLKOUT_CONFIG(RCC_PLL_RCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL3RFreq();
          }
          break;
        case RCC_LPTIM45CLKSOURCE_LSE: /* LSE is the clock source for LPTIM4/LPTIM5 */
          if (READ_BIT(RCC->BDCR, RCC_BDCR_LSERDY) != 0U)
          {
            frequency = LSE_VALUE;
          }
          break;
        case RCC_LPTIM45CLKSOURCE_LSI: /* LSI is the clock source for LPTIM4/LPTIM5 */
          if (READ_BIT(RCC->CSR, RCC_CSR_LSIRDY) != 0U)
          {
            frequency = LSI_VALUE;
          }
          break;
        case RCC_LPTIM45CLKSOURCE_CLKP: /* CKPER is the clock source for LPTIM4/LPTIM5 */
          frequency = RCC_GetCLKPFreq();
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_LPUART1:
      clocksource = __HAL_RCC_GET_LPUART1_SOURCE();

      switch (clocksource)
      {
        case RCC_LPUART1CLKSOURCE_PCLK4: /*!< PCLK4 is the clock source for LPUART1 */
          frequency = HAL_RCC_GetPCLK4Freq();
          break;
        case RCC_LPUART1CLKSOURCE_PLL2Q: /*!< PLL2 'Q' is the clock source for LPUART1 */
          if (__HAL_RCC_GET_PLL2CLKOUT_CONFIG(RCC_PLL_QCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL2QFreq();
          }
          break;
        case RCC_LPUART1CLKSOURCE_PLL3Q: /*!< PLL3 'Q' is the clock source for LPUART1 */
          if (__HAL_RCC_GET_PLL3CLKOUT_CONFIG(RCC_PLL_QCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL3QFreq();
          }
          break;
        case RCC_LPUART1CLKSOURCE_HSI: /*!< HSI is the clock source for LPUART1 */
          if (READ_BIT(RCC->CR, RCC_CR_HSIRDY) != 0U)
          {
            if (READ_BIT(RCC->CR, RCC_CR_HSIDIVF) != 0U)
            {
              frequency = (HSI_VALUE >> (__HAL_RCC_GET_HSI_DIVIDER() >> RCC_CR_HSIDIV_Pos));
            }
            else
            {
              /* Can't retrieve HSIDIV value */
            }
          }
          break;
        case RCC_LPUART1CLKSOURCE_CSI: /*!< CSI is the clock source for LPUART1 */
          if (READ_BIT(RCC->CR, RCC_CR_CSIRDY) != 0U)
          {
            frequency = CSI_VALUE;
          }
          break;
        case RCC_LPUART1CLKSOURCE_LSE: /*!< LSE is the clock source for LPUART1 */
          if (READ_BIT(RCC->BDCR, RCC_BDCR_LSERDY) != 0U)
          {
            frequency = LSE_VALUE;
          }
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_LTDC:
      /* Unique PLL3 'R' clock source */
      if (__HAL_RCC_GET_PLL3CLKOUT_CONFIG(RCC_PLL_RCLK) != 0U)
      {
        frequency = HAL_RCC_GetPLL3RFreq();
      }
      break;

    case RCC_PERIPHCLK_PSSI:
      clocksource = __HAL_RCC_GET_PSSI_SOURCE();

      switch (clocksource)
      {
        case RCC_PSSICLKSOURCE_PLL3R: /*!< PLL3 'R' is the clock source for PSSI */
          if (__HAL_RCC_GET_PLL3CLKOUT_CONFIG(RCC_PLL_RCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL3RFreq();
          }
          break;
        case RCC_PSSICLKSOURCE_CLKP: /*!< CLKP is the clock source for PSSI */
          frequency = RCC_GetCLKPFreq();
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_RTC:
      clocksource = __HAL_RCC_GET_RTC_SOURCE();

      switch (clocksource)
      {
        case RCC_RTCCLKSOURCE_DISABLE:
          /* Nothing to do, frequency is by default set to 0 */
          break;
        case RCC_RTCCLKSOURCE_LSE: /*!< LSE is the clock source for RTC */
          if (READ_BIT(RCC->BDCR, RCC_BDCR_LSERDY) != 0U)
          {
            frequency = LSE_VALUE;
          }
          break;
        case RCC_RTCCLKSOURCE_LSI: /*!< LSI is the clock source for RTC */
          if (READ_BIT(RCC->CSR, RCC_CSR_LSIRDY) != 0U)
          {
            frequency = LSI_VALUE;
          }
          break;
        default:
          if (READ_BIT(RCC->BDCR, RCC_BDCR_RTCSEL) == RCC_BDCR_RTCSEL) /*!< HSE is the clock source for RTC */
          {
            if (READ_BIT(RCC->CR, RCC_CR_HSERDY) != 0U)
            {
              prescaler = READ_BIT(RCC->CFGR, RCC_CFGR_RTCPRE) >> RCC_CFGR_RTCPRE_Pos;
              if (prescaler > 1U)
              {
                frequency = HSE_VALUE / prescaler;
              }
            }
          }
          else
          {
            /* Nothing to do, frequency is by default set to 0 */
          }
          break;
      }
      break;

    case RCC_PERIPHCLK_SAI1:
      clocksource = __HAL_RCC_GET_SAI1_SOURCE();

      switch (clocksource)
      {
        case RCC_SAI1CLKSOURCE_PLL1Q: /* PLL1 'Q' is the clock source for SAI1 */
          if (__HAL_RCC_GET_PLL1CLKOUT_CONFIG(RCC_PLL_QCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL1QFreq();
          }
          break;
        case RCC_SAI1CLKSOURCE_PLL2P: /* PLL2 'P' is the clock source for SAI1 */
          if (__HAL_RCC_GET_PLL2CLKOUT_CONFIG(RCC_PLL_PCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL2PFreq();
          }
          break;
        case RCC_SAI1CLKSOURCE_PLL3P: /* PLL3 'P' is the clock source for SAI1 */
          if (__HAL_RCC_GET_PLL3CLKOUT_CONFIG(RCC_PLL_PCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL3PFreq();
          }
          break;
        case RCC_SAI1CLKSOURCE_CLKP: /* CKPER is the clock source for SAI1 */
          frequency = RCC_GetCLKPFreq();
          break;
        case RCC_SAI1CLKSOURCE_PIN: /* External clock is the clock source for SAI1 */
          frequency = EXTERNAL_CLOCK_VALUE;
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_SAI2:
      clocksource = __HAL_RCC_GET_SAI2_SOURCE();

      switch (clocksource)
      {
        case RCC_SAI2CLKSOURCE_PLL1Q: /* PLL1 'Q' is the clock source for SAI2 */
          if (__HAL_RCC_GET_PLL1CLKOUT_CONFIG(RCC_PLL_QCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL1QFreq();
          }
          break;
        case RCC_SAI2CLKSOURCE_PLL2P: /* PLL2 'P' is the clock source for SAI2 */
          if (__HAL_RCC_GET_PLL2CLKOUT_CONFIG(RCC_PLL_PCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL2PFreq();
          }
          break;
        case RCC_SAI2CLKSOURCE_PLL3P: /* PLL3 'P' is the clock source for SAI2 */
          if (__HAL_RCC_GET_PLL3CLKOUT_CONFIG(RCC_PLL_PCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL3PFreq();
          }
          break;
        case RCC_SAI2CLKSOURCE_CLKP: /* CKPER is the clock source for SAI2 */
          frequency = RCC_GetCLKPFreq();
          break;
        case RCC_SAI2CLKSOURCE_SPDIF:
          /* Can't retrieve this source's frequency, it is by default set to 0 */
          break;
        case RCC_SAI2CLKSOURCE_PIN: /* External clock is the clock source for SAI2 */
          frequency = EXTERNAL_CLOCK_VALUE;
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_SDMMC12: /* SDMMC1 and SDMMC2 */

      clocksource = __HAL_RCC_GET_SDMMC12_SOURCE();

      if (clocksource ==
          RCC_SDMMC12CLKSOURCE_PLL2S) /* PLL2 'S' is the clock source for SDMMC1 and SDMMC2 kernel peripheral clock */
      {
        if (__HAL_RCC_GET_PLL2CLKOUT_CONFIG(RCC_PLL_SCLK) != 0U)
        {
          frequency = HAL_RCC_GetPLL2SFreq();
        }
      }
      else /* PLL2 'T' is the clock source for SDMMC1 and SDMMC2 kernel peripheral clock */
      {
        if (__HAL_RCC_GET_PLL2CLKOUT_CONFIG(RCC_PLL_TCLK) != 0U)
        {
          frequency = HAL_RCC_GetPLL2TFreq();
        }
      }
      break;

    case RCC_PERIPHCLK_SPDIFRX:
      clocksource = __HAL_RCC_GET_SPDIFRX_SOURCE();

      switch (clocksource)
      {
        case RCC_SPDIFRXCLKSOURCE_PLL1Q: /* PLL1 'Q' is the clock source for SPDIFRX */
          if (__HAL_RCC_GET_PLL1CLKOUT_CONFIG(RCC_PLL_QCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL1QFreq();
          }
          break;
        case RCC_SPDIFRXCLKSOURCE_PLL2R: /* PLL2 'R' is the clock source for SPDIFRX */
          if (__HAL_RCC_GET_PLL2CLKOUT_CONFIG(RCC_PLL_RCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL2RFreq();
          }
          break;
        case RCC_SPDIFRXCLKSOURCE_PLL3R: /* PLL3 'R' is the clock source for SPDIFRX */
          if (__HAL_RCC_GET_PLL3CLKOUT_CONFIG(RCC_PLL_RCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL3RFreq();
          }
          break;
        case RCC_SPDIFRXCLKSOURCE_HSI: /* HSI is the clock source for SPDIFRX */
          if (READ_BIT(RCC->CR, RCC_CR_HSIRDY) != 0U)
          {
            if (READ_BIT(RCC->CR, RCC_CR_HSIDIVF) != 0U)
            {
              frequency = (HSI_VALUE >> (__HAL_RCC_GET_HSI_DIVIDER() >> RCC_CR_HSIDIV_Pos));
            }
            else
            {
              /* Can't retrieve HSIDIV value */
            }
          }
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_SPI1:
      clocksource = __HAL_RCC_GET_SPI1_SOURCE();

      switch (clocksource)
      {
        case RCC_SPI1CLKSOURCE_PLL1Q: /* PLL1 'Q' is the clock source for SPI1 */
          if (__HAL_RCC_GET_PLL1CLKOUT_CONFIG(RCC_PLL_QCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL1QFreq();
          }
          break;
        case RCC_SPI1CLKSOURCE_PLL2P: /* PLL2 'P' is the clock source for SPI1 */
          if (__HAL_RCC_GET_PLL2CLKOUT_CONFIG(RCC_PLL_PCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL2PFreq();
          }
          break;
        case RCC_SPI1CLKSOURCE_PLL3P: /* PLL3 'P' is the clock source for SPI1 */
          if (__HAL_RCC_GET_PLL3CLKOUT_CONFIG(RCC_PLL_PCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL3PFreq();
          }
          break;
        case RCC_SPI1CLKSOURCE_CLKP: /* CKPER is the clock source for SPI1 */
          frequency = RCC_GetCLKPFreq();
          break;
        case RCC_SPI1CLKSOURCE_PIN: /* External I2S_CKIN is used as clock source for SPI1 */
          frequency = EXTERNAL_CLOCK_VALUE;
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_SPI23:
      clocksource = __HAL_RCC_GET_SPI23_SOURCE();

      switch (clocksource)
      {
        case RCC_SPI23CLKSOURCE_PLL1Q: /* PLL1 'Q' is the clock source for SPI2/SPI3 */
          if (__HAL_RCC_GET_PLL1CLKOUT_CONFIG(RCC_PLL_QCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL1QFreq();
          }
          break;
        case RCC_SPI23CLKSOURCE_PLL2P: /* PLL2 'P' is the clock source for SPI2/SPI3 */
          if (__HAL_RCC_GET_PLL2CLKOUT_CONFIG(RCC_PLL_PCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL2PFreq();
          }
          break;
        case RCC_SPI23CLKSOURCE_PLL3P: /* PLL3 'P' is the clock source for SPI2/SPI3 */
          if (__HAL_RCC_GET_PLL3CLKOUT_CONFIG(RCC_PLL_PCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL3PFreq();
          }
          break;
        case RCC_SPI23CLKSOURCE_CLKP: /* CKPER is the clock source for SPI2/SPI3 */
          frequency = RCC_GetCLKPFreq();
          break;
        case RCC_SPI23CLKSOURCE_PIN: /* External I2S_CKIN is used as clock source for SPI2/SPI3 */
          frequency = EXTERNAL_CLOCK_VALUE;
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_SPI45:
      clocksource = __HAL_RCC_GET_SPI45_SOURCE();

      switch (clocksource)
      {
        case RCC_SPI45CLKSOURCE_PCLK2: /* PCLK2 is the clock source for SPI4/SPI5 */
          frequency = HAL_RCC_GetPCLK2Freq();
          break;
        case RCC_SPI45CLKSOURCE_PLL2Q: /* PLL2 'Q' is the clock source for SPI4/SPI5 */
          if (__HAL_RCC_GET_PLL2CLKOUT_CONFIG(RCC_PLL_QCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL2QFreq();
          }
          break;
        case RCC_SPI45CLKSOURCE_PLL3Q: /* PLL3 'Q' is the clock source for SPI4/SPI5 */
          if (__HAL_RCC_GET_PLL3CLKOUT_CONFIG(RCC_PLL_QCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL3QFreq();
          }
          break;
        case RCC_SPI45CLKSOURCE_HSI: /* HSI is the clock source for SPI4/SPI5 */
          if (READ_BIT(RCC->CR, RCC_CR_HSIRDY) != 0U)
          {
            if (READ_BIT(RCC->CR, RCC_CR_HSIDIVF) != 0U)
            {
              frequency = (HSI_VALUE >> (__HAL_RCC_GET_HSI_DIVIDER() >> RCC_CR_HSIDIV_Pos));
            }
            else
            {
              /* Can't retrieve HSIDIV value */
            }
          }
          break;
        case RCC_SPI45CLKSOURCE_CSI: /* CSI is the clock source for SPI4/SPI5 */
          if (READ_BIT(RCC->CR, RCC_CR_CSIRDY) != 0U)
          {
            frequency = CSI_VALUE;
          }
          break;
        case RCC_SPI45CLKSOURCE_HSE: /* HSE is the clock source for SPI4/SPI5 */
          if (READ_BIT(RCC->CR, RCC_CR_HSERDY) != 0U)
          {
            frequency = HSE_VALUE;
          }
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_SPI6:
      clocksource = __HAL_RCC_GET_SPI6_SOURCE();

      switch (clocksource)
      {
        case RCC_SPI6CLKSOURCE_PCLK4: /* PCLK4 is the clock source for SPI6 */
          frequency = HAL_RCC_GetPCLK4Freq();
          break;
        case RCC_SPI6CLKSOURCE_PLL2Q: /* PLL2 'Q' is the clock source for SPI6 */
          if (__HAL_RCC_GET_PLL2CLKOUT_CONFIG(RCC_PLL_QCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL2QFreq();
          }
          break;
        case RCC_SPI6CLKSOURCE_PLL3Q: /* PLL3 'Q' is the clock source for SPI6 */
          if (__HAL_RCC_GET_PLL3CLKOUT_CONFIG(RCC_PLL_QCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL3QFreq();
          }
          break;
        case RCC_SPI6CLKSOURCE_HSI: /* HSI is the clock source for SPI6 */
          if (READ_BIT(RCC->CR, RCC_CR_HSIRDY) != 0U)
          {
            if (READ_BIT(RCC->CR, RCC_CR_HSIDIVF) != 0U)
            {
              frequency = (HSI_VALUE >> (__HAL_RCC_GET_HSI_DIVIDER() >> RCC_CR_HSIDIV_Pos));
            }
            else
            {
              /* Can't retrieve HSIDIV value */
            }
          }
          break;
        case RCC_SPI6CLKSOURCE_CSI: /* CSI is the clock source for SPI6 */
          if (READ_BIT(RCC->CR, RCC_CR_CSIRDY) != 0U)
          {
            frequency = CSI_VALUE;
          }
          break;
        case RCC_SPI6CLKSOURCE_HSE: /* HSE is the clock source for SPI6 */
          if (READ_BIT(RCC->CR, RCC_CR_HSERDY) != 0U)
          {
            frequency = HSE_VALUE;
          }
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_USART1:
      clocksource = __HAL_RCC_GET_USART1_SOURCE();

      switch (clocksource)
      {
        case RCC_USART1CLKSOURCE_PCLK2: /*!< PCLK2 is the clock source for USART1 */
          frequency = HAL_RCC_GetPCLK2Freq();
          break;
        case RCC_USART1CLKSOURCE_PLL2Q: /*!< PLL2 'Q' is the clock source for USART1 */
          if (__HAL_RCC_GET_PLL2CLKOUT_CONFIG(RCC_PLL_QCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL2QFreq();
          }
          break;
        case RCC_USART1CLKSOURCE_PLL3Q: /*!< PLL3 'Q' is the clock source for USART1 */
          if (__HAL_RCC_GET_PLL3CLKOUT_CONFIG(RCC_PLL_QCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL3QFreq();
          }
          break;
        case RCC_USART1CLKSOURCE_HSI: /*!< HSI is the clock source for USART1 */
          if (READ_BIT(RCC->CR, RCC_CR_HSIRDY) != 0U)
          {
            if (READ_BIT(RCC->CR, RCC_CR_HSIDIVF) != 0U)
            {
              frequency = (HSI_VALUE >> (__HAL_RCC_GET_HSI_DIVIDER() >> RCC_CR_HSIDIV_Pos));
            }
            else
            {
              /* Can't retrieve HSIDIV value */
            }
          }
          break;
        case RCC_USART1CLKSOURCE_CSI: /*!< CSI is the clock source for USART1 */
          if (READ_BIT(RCC->CR, RCC_CR_CSIRDY) != 0U)
          {
            frequency = CSI_VALUE;
          }
          break;
        case RCC_USART1CLKSOURCE_LSE: /*!< LSE is the clock source for USART1 */
          if (READ_BIT(RCC->BDCR, RCC_BDCR_LSERDY) != 0U)
          {
            frequency = LSE_VALUE;
          }
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_USART234578:
      clocksource = __HAL_RCC_GET_USART234578_SOURCE();

      switch (clocksource)
      {
        case RCC_USART234578CLKSOURCE_PCLK1: /*!< PCLK2 is the clock source for USART234578 */
          frequency = HAL_RCC_GetPCLK1Freq();
          break;
        case RCC_USART234578CLKSOURCE_PLL2Q: /*!< PLL2 'Q' is the clock source for USART234578 */
          if (__HAL_RCC_GET_PLL2CLKOUT_CONFIG(RCC_PLL_QCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL2QFreq();
          }
          break;
        case RCC_USART234578CLKSOURCE_PLL3Q: /*!< PLL3 'Q' is the clock source for USART234578 */
          if (__HAL_RCC_GET_PLL3CLKOUT_CONFIG(RCC_PLL_QCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL3QFreq();
          }
          break;
        case RCC_USART234578CLKSOURCE_HSI: /*!< HSI is the clock source for USART234578 */
          if (READ_BIT(RCC->CR, RCC_CR_HSIRDY) != 0U)
          {
            if (READ_BIT(RCC->CR, RCC_CR_HSIDIVF) != 0U)
            {
              frequency = (HSI_VALUE >> (__HAL_RCC_GET_HSI_DIVIDER() >> RCC_CR_HSIDIV_Pos));
            }
            else
            {
              /* Can't retrieve HSIDIV value */
            }
          }
          break;
        case RCC_USART234578CLKSOURCE_CSI: /*!< CSI is the clock source for USART234578 */
          if (READ_BIT(RCC->CR, RCC_CR_CSIRDY) != 0U)
          {
            frequency = CSI_VALUE;
          }
          break;
        case RCC_USART234578CLKSOURCE_LSE: /*!< LSE is the clock source for USART234578 */
          if (READ_BIT(RCC->BDCR, RCC_BDCR_LSERDY) != 0U)
          {
            frequency = LSE_VALUE;
          }
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_USBPHYC:
      clocksource = __HAL_RCC_GET_USBPHYC_SOURCE();

      switch (clocksource)
      {
        case RCC_USBPHYCCLKSOURCE_HSE: /*!< HSE is the clock source for USBPHYC */
          if (READ_BIT(RCC->CR, RCC_CR_HSERDY) != 0U)
          {
            frequency = HSE_VALUE;
          }
          break;
        case RCC_USBPHYCCLKSOURCE_HSE_DIV2: /*!< HSE/2 is the clock source for USBPHYC */
          if (READ_BIT(RCC->CR, RCC_CR_HSERDY) != 0U)
          {
            frequency = (HSE_VALUE >> 1UL);
          }
          break;
        case RCC_USBPHYCCLKSOURCE_PLL3Q: /*!< PLL3Q is the clock source for USBPHYC */
          if (__HAL_RCC_GET_PLL3CLKOUT_CONFIG(RCC_PLL_QCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL3QFreq();
          }
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    case RCC_PERIPHCLK_USBOTGFS:
      clocksource = __HAL_RCC_GET_USBOTGFS_SOURCE();

      switch (clocksource)
      {
        case RCC_USBOTGFSCLKSOURCE_HSI48: /*!< HSI48 is the clock source for USBOTGFS */
          if (READ_BIT(RCC->CR, RCC_CR_HSI48RDY) != 0U)
          {
            frequency = HSI48_VALUE;
          }
          break;
        case RCC_USBOTGFSCLKSOURCE_PLL3Q: /*!< PLL3Q is the clock source for USBOTGFS */
          if (__HAL_RCC_GET_PLL3CLKOUT_CONFIG(RCC_PLL_QCLK) != 0U)
          {
            frequency = HAL_RCC_GetPLL3QFreq();
          }
          break;
        case RCC_USBOTGFSCLKSOURCE_HSE: /*!< HSE is the clock source for USBOTGFS */
          if (READ_BIT(RCC->CR, RCC_CR_HSERDY) != 0U)
          {
            frequency = HSE_VALUE;
          }
          break;
        case RCC_USBOTGFSCLKSOURCE_CLK48: /*!< CLK48 is the clock source for USBOTGFS */
          /* Can't retrieve this source's frequency, it is by default set to 0 */
          break;
        default:
          /* Nothing to do, frequency is by default set to 0 */
          break;
      }
      break;

    default:
      /* Nothing to do, frequency is by default set to 0 */
      break;
  }

  return frequency;
}

void HAL_RCCEx_EnableClockProtection(uint32_t ProtectClk)
{
  /* Check the parameter */
  assert_param(IS_RCC_CLOCKPROTECTION(ProtectClk));

  SET_BIT(RCC->CKPROTR, ProtectClk);
}

void HAL_RCCEx_DisableClockProtection(uint32_t ProtectClk)
{
  /* Check the parameter */
  assert_param(IS_RCC_CLOCKPROTECTION(ProtectClk));

  CLEAR_BIT(RCC->CKPROTR, ProtectClk);
}

void HAL_RCCEx_EnableLSECSS(void)
{
  SET_BIT(RCC->BDCR, RCC_BDCR_LSECSSON) ;
}

void HAL_RCCEx_DisableLSECSS(void)
{
  CLEAR_BIT(RCC->BDCR, RCC_BDCR_LSECSSON) ;
  /* Disable LSE CSS IT if any */
  __HAL_RCC_DISABLE_IT(RCC_IT_LSECSS);
}

void HAL_RCCEx_EnableLSECSS_IT(void)
{
  /* Enable LSE CSS */
  SET_BIT(RCC->BDCR, RCC_BDCR_LSECSSON) ;

  /* Enable LSE CSS IT */
  __HAL_RCC_ENABLE_IT(RCC_IT_LSECSS);

  /* Enable IT on EXTI Line 18 */
  __HAL_RCC_LSECSS_EXTI_ENABLE_RISING_EDGE();
  __HAL_RCC_LSECSS_EXTI_ENABLE_IT();
}

void HAL_RCCEx_WakeUpStopCLKConfig(uint32_t WakeUpClk)
{
  assert_param(IS_RCC_STOP_WAKEUPCLOCK(WakeUpClk));

  __HAL_RCC_WAKEUPSTOP_CLK_CONFIG(WakeUpClk);
}

void HAL_RCCEx_KerWakeUpStopCLKConfig(uint32_t WakeUpClk)
{
  assert_param(IS_RCC_STOP_KERWAKEUPCLOCK(WakeUpClk));

  __HAL_RCC_KERWAKEUPSTOP_CLK_CONFIG(WakeUpClk);
}

void HAL_RCCEx_LSECSS_IRQHandler(void)
{
  /* Check RCC LSE CSSF flag  */
  if (__HAL_RCC_GET_IT(RCC_IT_LSECSS))
  {
    /* Clear RCC LSE CSS pending bit */
    __HAL_RCC_CLEAR_IT(RCC_IT_LSECSS);

    /* RCC LSE Clock Security System interrupt user callback */
    HAL_RCCEx_LSECSS_Callback();
  }
}

__weak void HAL_RCCEx_LSECSS_Callback(void)
{
  /* NOTE : This function should not be modified, when the callback is needed,
            the @ref HAL_RCCEx_LSECSS_Callback should be implemented in the user file
  */
}

void HAL_RCCEx_CRSConfig(const RCC_CRSInitTypeDef *pInit)
{
  uint32_t value;

  /* Check the parameters */
  assert_param(IS_RCC_CRS_SYNC_DIV(pInit->Prescaler));
  assert_param(IS_RCC_CRS_SYNC_SOURCE(pInit->Source));
  assert_param(IS_RCC_CRS_SYNC_POLARITY(pInit->Polarity));
  assert_param(IS_RCC_CRS_RELOADVALUE(pInit->ReloadValue));
  assert_param(IS_RCC_CRS_ERRORLIMIT(pInit->ErrorLimitValue));
  assert_param(IS_RCC_CRS_HSI48CALIBRATION(pInit->HSI48CalibrationValue));

  /* CONFIGURATION */

  /* Before configuration, reset CRS registers to their default values*/
  __HAL_RCC_CRS_FORCE_RESET();
  __HAL_RCC_CRS_RELEASE_RESET();

  /* Set the SYNCDIV[2:0] bits according to Prescaler value */
  /* Set the SYNCSRC[1:0] bits according to Source value */
  /* Set the SYNCSPOL bit according to Polarity value */
  value = (pInit->Prescaler | pInit->Source | pInit->Polarity);
  /* Set the RELOAD[15:0] bits according to ReloadValue value */
  value |= pInit->ReloadValue;
  /* Set the FELIM[7:0] bits according to ErrorLimitValue value */
  value |= (pInit->ErrorLimitValue << CRS_CFGR_FELIM_Pos);
  WRITE_REG(CRS->CFGR, value);

  /* Adjust HSI48 oscillator smooth trimming */
  /* Set the TRIM[5:0] bits according to HSI48CalibrationValue value */
  MODIFY_REG(CRS->CR, CRS_CR_TRIM, (pInit->HSI48CalibrationValue << CRS_CR_TRIM_Pos));

  /* START AUTOMATIC SYNCHRONIZATION*/

  /* Enable Automatic trimming & Frequency error counter */
  SET_BIT(CRS->CR, CRS_CR_AUTOTRIMEN | CRS_CR_CEN);
}

void HAL_RCCEx_CRSSoftwareSynchronizationGenerate(void)
{
  SET_BIT(CRS->CR, CRS_CR_SWSYNC);
}

void HAL_RCCEx_CRSGetSynchronizationInfo(RCC_CRSSynchroInfoTypeDef *pSynchroInfo)
{
  /* Check the parameter */
  assert_param(pSynchroInfo != (void *)NULL);

  /* Get the reload value */
  pSynchroInfo->ReloadValue = (uint32_t)(READ_BIT(CRS->CFGR, CRS_CFGR_RELOAD));

  /* Get HSI48 oscillator smooth trimming */
  pSynchroInfo->HSI48CalibrationValue = (uint32_t)(READ_BIT(CRS->CR, CRS_CR_TRIM) >> CRS_CR_TRIM_Pos);

  /* Get Frequency error capture */
  pSynchroInfo->FreqErrorCapture = (uint32_t)(READ_BIT(CRS->ISR, CRS_ISR_FECAP) >> CRS_ISR_FECAP_Pos);

  /* Get Frequency error direction */
  pSynchroInfo->FreqErrorDirection = (uint32_t)(READ_BIT(CRS->ISR, CRS_ISR_FEDIR));
}

uint32_t HAL_RCCEx_CRSWaitSynchronization(uint32_t Timeout)
{
  uint32_t crsstatus = RCC_CRS_NONE;
  uint32_t tickstart;

  /* Get timeout */
  tickstart = HAL_GetTick();

  /* Wait for CRS flag or timeout detection */
  do
  {
    if (Timeout != HAL_MAX_DELAY)
    {
      if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
      {
        crsstatus = RCC_CRS_TIMEOUT;
      }
    }
    /* Check CRS SYNCOK flag  */
    if (__HAL_RCC_CRS_GET_FLAG(RCC_CRS_FLAG_SYNCOK))
    {
      /* CRS SYNC event OK */
      crsstatus |= RCC_CRS_SYNCOK;

      /* Clear CRS SYNC event OK bit */
      __HAL_RCC_CRS_CLEAR_FLAG(RCC_CRS_FLAG_SYNCOK);
    }

    /* Check CRS SYNCWARN flag  */
    if (__HAL_RCC_CRS_GET_FLAG(RCC_CRS_FLAG_SYNCWARN))
    {
      /* CRS SYNC warning */
      crsstatus |= RCC_CRS_SYNCWARN;

      /* Clear CRS SYNCWARN bit */
      __HAL_RCC_CRS_CLEAR_FLAG(RCC_CRS_FLAG_SYNCWARN);
    }

    /* Check CRS TRIM overflow flag  */
    if (__HAL_RCC_CRS_GET_FLAG(RCC_CRS_FLAG_TRIMOVF))
    {
      /* CRS SYNC Error */
      crsstatus |= RCC_CRS_TRIMOVF;

      /* Clear CRS Error bit */
      __HAL_RCC_CRS_CLEAR_FLAG(RCC_CRS_FLAG_TRIMOVF);
    }

    /* Check CRS Error flag  */
    if (__HAL_RCC_CRS_GET_FLAG(RCC_CRS_FLAG_SYNCERR))
    {
      /* CRS SYNC Error */
      crsstatus |= RCC_CRS_SYNCERR;

      /* Clear CRS Error bit */
      __HAL_RCC_CRS_CLEAR_FLAG(RCC_CRS_FLAG_SYNCERR);
    }

    /* Check CRS SYNC Missed flag  */
    if (__HAL_RCC_CRS_GET_FLAG(RCC_CRS_FLAG_SYNCMISS))
    {
      /* CRS SYNC Missed */
      crsstatus |= RCC_CRS_SYNCMISS;

      /* Clear CRS SYNC Missed bit */
      __HAL_RCC_CRS_CLEAR_FLAG(RCC_CRS_FLAG_SYNCMISS);
    }

    /* Check CRS Expected SYNC flag  */
    if (__HAL_RCC_CRS_GET_FLAG(RCC_CRS_FLAG_ESYNC))
    {
      /* frequency error counter reached a zero value */
      __HAL_RCC_CRS_CLEAR_FLAG(RCC_CRS_FLAG_ESYNC);
    }
  } while (RCC_CRS_NONE == crsstatus);

  return crsstatus;
}

void HAL_RCCEx_CRS_IRQHandler(void)
{
  uint32_t crserror = RCC_CRS_NONE;
  /* Get current IT flags and IT sources values */
  uint32_t itflags = READ_REG(CRS->ISR);
  uint32_t itsources = READ_REG(CRS->CR);

  /* Check CRS SYNCOK flag  */
  if (((itflags & RCC_CRS_FLAG_SYNCOK) != 0U) && ((itsources & RCC_CRS_IT_SYNCOK) != 0U))
  {
    /* Clear CRS SYNC event OK flag */
    WRITE_REG(CRS->ICR, CRS_ICR_SYNCOKC);

    /* user callback */
    HAL_RCCEx_CRS_SyncOkCallback();
  }
  /* Check CRS SYNCWARN flag  */
  else if (((itflags & RCC_CRS_FLAG_SYNCWARN) != 0U) && ((itsources & RCC_CRS_IT_SYNCWARN) != 0U))
  {
    /* Clear CRS SYNCWARN flag */
    WRITE_REG(CRS->ICR, CRS_ICR_SYNCWARNC);

    /* user callback */
    HAL_RCCEx_CRS_SyncWarnCallback();
  }
  /* Check CRS Expected SYNC flag  */
  else if (((itflags & RCC_CRS_FLAG_ESYNC) != 0U) && ((itsources & RCC_CRS_IT_ESYNC) != 0U))
  {
    /* frequency error counter reached a zero value */
    WRITE_REG(CRS->ICR, CRS_ICR_ESYNCC);

    /* user callback */
    HAL_RCCEx_CRS_ExpectedSyncCallback();
  }
  /* Check CRS Error flags  */
  else
  {
    if (((itflags & RCC_CRS_FLAG_ERR) != 0U) && ((itsources & RCC_CRS_IT_ERR) != 0U))
    {
      if ((itflags & RCC_CRS_FLAG_SYNCERR) != 0U)
      {
        crserror |= RCC_CRS_SYNCERR;
      }
      if ((itflags & RCC_CRS_FLAG_SYNCMISS) != 0U)
      {
        crserror |= RCC_CRS_SYNCMISS;
      }
      if ((itflags & RCC_CRS_FLAG_TRIMOVF) != 0U)
      {
        crserror |= RCC_CRS_TRIMOVF;
      }

      /* Clear CRS Error flags */
      WRITE_REG(CRS->ICR, CRS_ICR_ERRC);

      /* user error callback */
      HAL_RCCEx_CRS_ErrorCallback(crserror);
    }
  }
}

__weak void HAL_RCCEx_CRS_SyncOkCallback(void)
{
  /* NOTE : This function should not be modified, when the callback is needed,
            the @ref HAL_RCCEx_CRS_SyncOkCallback should be implemented in the user file
   */
}

__weak void HAL_RCCEx_CRS_SyncWarnCallback(void)
{
  /* NOTE : This function should not be modified, when the callback is needed,
            the @ref HAL_RCCEx_CRS_SyncWarnCallback should be implemented in the user file
   */
}

__weak void HAL_RCCEx_CRS_ExpectedSyncCallback(void)
{
  /* NOTE : This function should not be modified, when the callback is needed,
            the @ref HAL_RCCEx_CRS_ExpectedSyncCallback should be implemented in the user file
   */
}

__weak void HAL_RCCEx_CRS_ErrorCallback(uint32_t Error)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(Error);

  /* NOTE : This function should not be modified, when the callback is needed,
            the @ref HAL_RCCEx_CRS_ErrorCallback should be implemented in the user file
   */
}

static uint32_t RCC_GetCLKPFreq(void)
{
  uint32_t frequency = 0U;
  uint32_t ckpclocksource;

  ckpclocksource = __HAL_RCC_GET_CLKP_SOURCE();

  if (ckpclocksource == RCC_CLKPSOURCE_HSI)
  {
    if (READ_BIT(RCC->CR, RCC_CR_HSIRDY) != 0U)
    {
      if (READ_BIT(RCC->CR, RCC_CR_HSIDIVF) != 0U)
      {
        frequency = (HSI_VALUE >> (__HAL_RCC_GET_HSI_DIVIDER() >> RCC_CR_HSIDIV_Pos));
      }
      else
      {
        /* Can't retrieve HSIDIV value */
      }
    }
  }
  else if (ckpclocksource == RCC_CLKPSOURCE_CSI)
  {
    if (READ_BIT(RCC->CR, RCC_CR_CSIRDY) != 0U)
    {
      frequency = CSI_VALUE;
    }
  }
  else if (ckpclocksource == RCC_CLKPSOURCE_HSE)
  {
    if (READ_BIT(RCC->CR, RCC_CR_HSERDY) != 0U)
    {
      frequency = HSE_VALUE;
    }
  }
  else
  {
    /* Nothing to do, case the CKPER is disabled */
    /* frequency is by default set to 0          */
  }

  return frequency;
}
