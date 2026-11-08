/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Exact extracts from STM32H7RS HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
HAL_StatusTypeDef HAL_LPTIM_Init(LPTIM_HandleTypeDef *hlptim)
{
  uint32_t tmpcfgr;

  /* Check the LPTIM handle allocation */
  if (hlptim == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_LPTIM_INSTANCE(hlptim->Instance));
  assert_param(IS_LPTIM_PERIOD(hlptim->Init.Period));

  assert_param(IS_LPTIM_CLOCK_SOURCE(hlptim->Init.Clock.Source));
  assert_param(IS_LPTIM_CLOCK_PRESCALER(hlptim->Init.Clock.Prescaler));
  if ((hlptim->Init.Clock.Source == LPTIM_CLOCKSOURCE_ULPTIM)
      || (hlptim->Init.CounterSource == LPTIM_COUNTERSOURCE_EXTERNAL))
  {
    assert_param(IS_LPTIM_CLOCK_POLARITY(hlptim->Init.UltraLowPowerClock.Polarity));
    assert_param(IS_LPTIM_CLOCK_SAMPLE_TIME(hlptim->Init.UltraLowPowerClock.SampleTime));
  }
  assert_param(IS_LPTIM_TRG_SOURCE(hlptim->Init.Trigger.Source));
  if (hlptim->Init.Trigger.Source != LPTIM_TRIGSOURCE_SOFTWARE)
  {
    assert_param(IS_LPTIM_EXT_TRG_POLARITY(hlptim->Init.Trigger.ActiveEdge));
    assert_param(IS_LPTIM_TRIG_SAMPLE_TIME(hlptim->Init.Trigger.SampleTime));
  }
  assert_param(IS_LPTIM_UPDATE_MODE(hlptim->Init.UpdateMode));
  assert_param(IS_LPTIM_COUNTER_SOURCE(hlptim->Init.CounterSource));
  assert_param(IS_LPTIM_REPETITION(hlptim->Init.RepetitionCounter));

  if (hlptim->State == HAL_LPTIM_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    hlptim->Lock = HAL_UNLOCKED;

#if (USE_HAL_LPTIM_REGISTER_CALLBACKS == 1)
    /* Reset interrupt callbacks to legacy weak callbacks */
    LPTIM_ResetCallback(hlptim);

    if (hlptim->MspInitCallback == NULL)
    {
      hlptim->MspInitCallback = HAL_LPTIM_MspInit;
    }

    /* Init the low level hardware : GPIO, CLOCK, NVIC */
    hlptim->MspInitCallback(hlptim);
#else
    /* Init the low level hardware : GPIO, CLOCK, NVIC */
    HAL_LPTIM_MspInit(hlptim);
#endif /* USE_HAL_LPTIM_REGISTER_CALLBACKS */
  }

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Enable the Peripheral */
  __HAL_LPTIM_ENABLE(hlptim);

  /* Clear flag */
  __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_REPOK);

  /* Set the repetition counter */
  __HAL_LPTIM_REPETITIONCOUNTER_SET(hlptim, hlptim->Init.RepetitionCounter);

  /* Wait for the completion of the write operation to the LPTIM_RCR register */
  if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_REPOK) == HAL_TIMEOUT)
  {
    return HAL_TIMEOUT;
  }


  /* Clear flag */
  __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_ARROK);

  /* Set LPTIM Period */
  __HAL_LPTIM_AUTORELOAD_SET(hlptim, hlptim->Init.Period);

  /* Wait for the completion of the write operation to the LPTIM_ARR register */
  if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_ARROK) == HAL_TIMEOUT)
  {
    return HAL_TIMEOUT;
  }

  /* Disable the Peripheral */
  __HAL_LPTIM_DISABLE(hlptim);

  /* Get the LPTIMx CFGR value */
  tmpcfgr = hlptim->Instance->CFGR;

  if ((hlptim->Init.Clock.Source == LPTIM_CLOCKSOURCE_ULPTIM)
      || (hlptim->Init.CounterSource == LPTIM_COUNTERSOURCE_EXTERNAL))
  {
    tmpcfgr &= (uint32_t)(~(LPTIM_CFGR_CKPOL | LPTIM_CFGR_CKFLT));
  }
  if (hlptim->Init.Trigger.Source != LPTIM_TRIGSOURCE_SOFTWARE)
  {
    tmpcfgr &= (uint32_t)(~(LPTIM_CFGR_TRGFLT | LPTIM_CFGR_TRIGSEL));
  }

  /* Clear CKSEL, PRESC, TRIGEN, TRGFLT, WAVPOL, PRELOAD & COUNTMODE bits */
  tmpcfgr &= (uint32_t)(~(LPTIM_CFGR_CKSEL | LPTIM_CFGR_TRIGEN | LPTIM_CFGR_PRELOAD |
                          LPTIM_CFGR_PRESC | LPTIM_CFGR_COUNTMODE));

  /* Set initialization parameters */
  tmpcfgr |= (hlptim->Init.Clock.Source    |
              hlptim->Init.Clock.Prescaler |
              hlptim->Init.UpdateMode      |
              hlptim->Init.CounterSource);

  /* Glitch filters for internal triggers and  external inputs are configured
   * only if an internal clock source is provided to the LPTIM
   */
  if (hlptim->Init.Clock.Source == LPTIM_CLOCKSOURCE_APBCLOCK_LPOSC)
  {
    tmpcfgr |= (hlptim->Init.Trigger.SampleTime |
                hlptim->Init.UltraLowPowerClock.SampleTime);
  }

  /* Configure LPTIM external clock polarity and digital filter */
  if ((hlptim->Init.Clock.Source == LPTIM_CLOCKSOURCE_ULPTIM)
      || (hlptim->Init.CounterSource == LPTIM_COUNTERSOURCE_EXTERNAL))
  {
    tmpcfgr |= (hlptim->Init.UltraLowPowerClock.Polarity |
                hlptim->Init.UltraLowPowerClock.SampleTime);
  }

  /* Configure LPTIM external trigger */
  if (hlptim->Init.Trigger.Source != LPTIM_TRIGSOURCE_SOFTWARE)
  {
    /* Enable External trigger and set the trigger source */
    tmpcfgr |= (hlptim->Init.Trigger.Source     |
                hlptim->Init.Trigger.ActiveEdge |
                hlptim->Init.Trigger.SampleTime);
  }

  /* Write to LPTIMx CFGR */
  hlptim->Instance->CFGR = tmpcfgr;

  /* Configure LPTIM input sources */
  if ((hlptim->Instance == LPTIM1) || (hlptim->Instance == LPTIM2))
  {
    /* Check LPTIM Input1 and Input2 sources */
    assert_param(IS_LPTIM_INPUT1_SOURCE(hlptim->Instance, hlptim->Init.Input1Source));
    assert_param(IS_LPTIM_INPUT2_SOURCE(hlptim->Instance, hlptim->Init.Input2Source));

    /* Configure LPTIM Input1 and Input2 sources */
    hlptim->Instance->CFGR2 = (hlptim->Init.Input1Source | hlptim->Init.Input2Source);
  }
  else
  {
    if (hlptim->Instance == LPTIM3)
    {
      /* Check LPTIM3 Input1 source */
      assert_param(IS_LPTIM_INPUT1_SOURCE(hlptim->Instance, hlptim->Init.Input1Source));

      /* Configure LPTIM3 Input1 source */
      hlptim->Instance->CFGR2 = hlptim->Init.Input1Source;
    }
  }

  /* Initialize the LPTIM channels state */
  LPTIM_CHANNEL_STATE_SET_ALL(hlptim, HAL_LPTIM_CHANNEL_STATE_READY);

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_DeInit(LPTIM_HandleTypeDef *hlptim)
{
  /* Check the LPTIM handle allocation */
  if (hlptim == NULL)
  {
    return HAL_ERROR;
  }

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  __HAL_LPTIM_ENABLE(hlptim);
  if (IS_LPTIM_CC2_INSTANCE(hlptim->Instance))
  {
    hlptim->Instance->CCMR1 = 0;
  }

  /* Clear flag */
  __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_CMP1OK);

  __HAL_LPTIM_COMPARE_SET(hlptim, LPTIM_CHANNEL_1, 0);
  /* Wait for the completion of the write operation to the LPTIM_CCR1 register */
  if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_CMP1OK) == HAL_TIMEOUT)
  {
    return HAL_TIMEOUT;
  }

  if (IS_LPTIM_CC2_INSTANCE(hlptim->Instance))
  {
    /* Clear flag */
    __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_CMP2OK);

    __HAL_LPTIM_COMPARE_SET(hlptim, LPTIM_CHANNEL_2, 0);
    /* Wait for the completion of the write operation to the LPTIM_CCR2 register */
    if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_CMP2OK) == HAL_TIMEOUT)
    {
      return HAL_TIMEOUT;
    }
  }

  /* Clear flag */
  __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_ARROK);

  __HAL_LPTIM_AUTORELOAD_SET(hlptim, 0);

  /* Wait for the completion of the write operation to the LPTIM_ARR register */
  if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_ARROK) == HAL_TIMEOUT)
  {
    return HAL_TIMEOUT;
  }

  /* Disable the LPTIM Peripheral Clock */
  __HAL_LPTIM_DISABLE(hlptim);

  hlptim->Instance->CFGR = 0;
  hlptim->Instance->CFGR2 = 0;

#if (USE_HAL_LPTIM_REGISTER_CALLBACKS == 1)
  if (hlptim->MspDeInitCallback == NULL)
  {
    hlptim->MspDeInitCallback = HAL_LPTIM_MspDeInit;
  }

  /* DeInit the low level hardware: CLOCK, NVIC.*/
  hlptim->MspDeInitCallback(hlptim);
#else
  /* DeInit the low level hardware: CLOCK, NVIC.*/
  HAL_LPTIM_MspDeInit(hlptim);
#endif /* USE_HAL_LPTIM_REGISTER_CALLBACKS */

  /* Change the LPTIM channels state */
  LPTIM_CHANNEL_STATE_SET_ALL(hlptim, HAL_LPTIM_CHANNEL_STATE_RESET);

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_RESET;

  /* Release Lock */
  __HAL_UNLOCK(hlptim);

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_PWM_Start(LPTIM_HandleTypeDef *hlptim, uint32_t Channel)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_CCX_INSTANCE(hlptim->Instance, Channel));

  /* Check LPTIM channel state */
  if (LPTIM_CHANNEL_STATE_GET(hlptim, Channel) != HAL_LPTIM_CHANNEL_STATE_READY)
  {
    return HAL_ERROR;
  }

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Set the LPTIM channel state */
  LPTIM_CHANNEL_STATE_SET(hlptim, Channel, HAL_LPTIM_CHANNEL_STATE_BUSY);

  /* Reset WAVE bit to set PWM mode */
  hlptim->Instance->CFGR &= ~LPTIM_CFGR_WAVE;

  /* Enable the Peripheral */
  __HAL_LPTIM_ENABLE(hlptim);

  /* Enable LPTIM signal on the corresponding output pin */
  __HAL_LPTIM_CAPTURE_COMPARE_ENABLE(hlptim, Channel);

  /* Start timer in continuous mode */
  __HAL_LPTIM_START_CONTINUOUS(hlptim);

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_PWM_Stop(LPTIM_HandleTypeDef *hlptim, uint32_t Channel)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_CCX_INSTANCE(hlptim->Instance, Channel));

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Disable LPTIM signal from the corresponding output pin */
  __HAL_LPTIM_CAPTURE_COMPARE_DISABLE(hlptim, Channel);

  /* Disable the Peripheral */
  __HAL_LPTIM_DISABLE(hlptim);

  /* Set the LPTIM channel state */
  LPTIM_CHANNEL_STATE_SET(hlptim, Channel, HAL_LPTIM_CHANNEL_STATE_READY);

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_PWM_Start_IT(LPTIM_HandleTypeDef *hlptim, uint32_t Channel)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_CCX_INSTANCE(hlptim->Instance, Channel));

  /* Check LPTIM channel state */
  if (LPTIM_CHANNEL_STATE_GET(hlptim, Channel) != HAL_LPTIM_CHANNEL_STATE_READY)
  {
    return HAL_ERROR;
  }

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Set the LPTIM channel state */
  LPTIM_CHANNEL_STATE_SET(hlptim, Channel, HAL_LPTIM_CHANNEL_STATE_BUSY);

  /* Reset WAVE bit to set PWM mode */
  hlptim->Instance->CFGR &= ~LPTIM_CFGR_WAVE;

  /* Enable the Peripheral */
  __HAL_LPTIM_ENABLE(hlptim);
  /* Clear flag */
  __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_DIEROK);

  switch (Channel)
  {
    case LPTIM_CHANNEL_1:
      /* Enable interrupt */
      __HAL_LPTIM_ENABLE_IT(hlptim, LPTIM_IT_CMP1OK | LPTIM_IT_CC1 | LPTIM_IT_ARROK | LPTIM_IT_ARRM | LPTIM_IT_REPOK |
                            LPTIM_IT_UPDATE);
      break;
    case LPTIM_CHANNEL_2:
      /* Enable interrupt */
      __HAL_LPTIM_ENABLE_IT(hlptim, LPTIM_IT_CMP2OK | LPTIM_IT_CC2 | LPTIM_IT_ARROK | LPTIM_IT_ARRM | LPTIM_IT_REPOK |
                            LPTIM_IT_UPDATE);
      break;
    default:
      break;
  }

  /* Wait for the completion of the write operation to the LPTIM_DIER register */
  if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_DIEROK) == HAL_TIMEOUT)
  {
    return HAL_TIMEOUT;
  }

  /* If external trigger source is used, then enable external trigger interrupt */
  if ((hlptim->Init.Trigger.Source) != LPTIM_TRIGSOURCE_SOFTWARE)
  {
    /* Clear flag */
    __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_DIEROK);

    /* Enable external trigger interrupt */
    __HAL_LPTIM_ENABLE_IT(hlptim, LPTIM_IT_EXTTRIG);

    /* Wait for the completion of the write operation to the LPTIM_DIER register */
    if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_DIEROK) == HAL_TIMEOUT)
    {
      return HAL_TIMEOUT;
    }
  }

  __HAL_LPTIM_CAPTURE_COMPARE_ENABLE(hlptim, Channel);

  /* Start timer in continuous mode */
  __HAL_LPTIM_START_CONTINUOUS(hlptim);

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_PWM_Stop_IT(LPTIM_HandleTypeDef *hlptim, uint32_t Channel)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_CCX_INSTANCE(hlptim->Instance, Channel));

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Disable LPTIM signal from the corresponding output pin */
  __HAL_LPTIM_CAPTURE_COMPARE_DISABLE(hlptim, Channel);

  /* Disable the Peripheral */
  __HAL_LPTIM_DISABLE(hlptim);

  /* Enable the Peripheral */
  __HAL_LPTIM_ENABLE(hlptim);

  /* Clear flag */
  __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_DIEROK);

  switch (Channel)
  {
    case LPTIM_CHANNEL_1:
      /* Disable interrupt */
      __HAL_LPTIM_DISABLE_IT(hlptim, LPTIM_IT_CMP1OK | LPTIM_IT_CC1 | LPTIM_IT_ARROK | LPTIM_IT_ARRM | LPTIM_IT_REPOK |
                             LPTIM_IT_UPDATE);
      break;
    case LPTIM_CHANNEL_2:
      /* Disable interrupt */
      __HAL_LPTIM_DISABLE_IT(hlptim, LPTIM_IT_CMP2OK | LPTIM_IT_CC2 | LPTIM_IT_ARROK | LPTIM_IT_ARRM | LPTIM_IT_REPOK |
                             LPTIM_IT_UPDATE);
      break;
    default:
      break;
  }

  /* Wait for the completion of the write operation to the LPTIM_DIER register */
  if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_DIEROK) == HAL_TIMEOUT)
  {
    return HAL_TIMEOUT;
  }

  /* If external trigger source is used, then enable external trigger interrupt */
  if ((hlptim->Init.Trigger.Source) != LPTIM_TRIGSOURCE_SOFTWARE)
  {
    /* Clear flag */
    __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_DIEROK);

    /* Enable external trigger interrupt */
    __HAL_LPTIM_DISABLE_IT(hlptim, LPTIM_IT_EXTTRIG);

    /* Wait for the completion of the write operation to the LPTIM_DIER register */
    if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_DIEROK) == HAL_TIMEOUT)
    {
      return HAL_TIMEOUT;
    }
  }

  /* Disable the Peripheral */
  __HAL_LPTIM_DISABLE(hlptim);

  /* Set the LPTIM channel state */
  LPTIM_CHANNEL_STATE_SET(hlptim, Channel, HAL_LPTIM_CHANNEL_STATE_READY);

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_PWM_Start_DMA(LPTIM_HandleTypeDef *hlptim, uint32_t Channel, const uint32_t *pData,
                                          uint32_t Length)
{
  DMA_HandleTypeDef *hdma;

  /* Check the parameters */
  assert_param(IS_LPTIM_DMA_INSTANCE(hlptim->Instance));
  assert_param(IS_LPTIM_CCX_INSTANCE(hlptim->Instance, Channel));

  if ((pData == NULL) || (Length == 0U))
  {
    return HAL_ERROR;
  }

  /* Check LPTIM channel state */
  if (LPTIM_CHANNEL_STATE_GET(hlptim, Channel) != HAL_LPTIM_CHANNEL_STATE_READY)
  {
    return HAL_ERROR;
  }

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Set the LPTIM channel state */
  LPTIM_CHANNEL_STATE_SET(hlptim, Channel, HAL_LPTIM_CHANNEL_STATE_BUSY);

  /* Reset WAVE bit to set PWM mode */
  hlptim->Instance->CFGR &= ~LPTIM_CFGR_WAVE;

  /* Enable the Peripheral */
  __HAL_LPTIM_ENABLE(hlptim);

  /* Enable update event DMA request */
  __HAL_LPTIM_ENABLE_DMA(hlptim, LPTIM_DMA_UPDATE);

  /* Wait for the completion of the write operation to the LPTIM_DIER register */
  if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_DIEROK) == HAL_TIMEOUT)
  {
    return HAL_TIMEOUT;
  }

  switch (Channel)
  {
    case LPTIM_CHANNEL_1:
      /* Set the DMA update event callbacks */
      hlptim->hdma[LPTIM_DMA_ID_CC1]->XferCpltCallback = LPTIM_DMAUpdateEventCplt;
      hlptim->hdma[LPTIM_DMA_ID_CC1]->XferHalfCpltCallback = LPTIM_DMAUpdateEventHalfCplt;

      /* Set the DMA error callback */
      hlptim->hdma[LPTIM_DMA_ID_CC1]->XferErrorCallback = LPTIM_DMAError;

      /* Enable the DMA Channel */
      hdma = hlptim->hdma[LPTIM_DMA_ID_CC1];
      if (LPTIM_DMA_Start_IT(hdma, (uint32_t)pData, (uint32_t)&hlptim->Instance->CCR1, Length) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      break;
    case LPTIM_CHANNEL_2:
      /* Set the DMA update event callbacks */
      hlptim->hdma[LPTIM_DMA_ID_CC2]->XferCpltCallback = LPTIM_DMAUpdateEventCplt;
      hlptim->hdma[LPTIM_DMA_ID_CC2]->XferHalfCpltCallback = LPTIM_DMAUpdateEventHalfCplt;

      /* Set the DMA error callback */
      hlptim->hdma[LPTIM_DMA_ID_CC2]->XferErrorCallback = LPTIM_DMAError;

      /* Enable the DMA Channel */
      hdma = hlptim->hdma[LPTIM_DMA_ID_CC2];
      if (LPTIM_DMA_Start_IT(hdma, (uint32_t)pData, (uint32_t)&hlptim->Instance->CCR2, Length) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      break;
    default:
      break;
  }

  /* Enable LPTIM signal on the corresponding output pin */
  __HAL_LPTIM_CAPTURE_COMPARE_ENABLE(hlptim, Channel);

  /* Start timer in continuous mode */
  __HAL_LPTIM_START_CONTINUOUS(hlptim);

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_PWM_Stop_DMA(LPTIM_HandleTypeDef *hlptim, uint32_t Channel)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_DMA_INSTANCE(hlptim->Instance));
  assert_param(IS_LPTIM_CCX_INSTANCE(hlptim->Instance, Channel));

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Disable update event DMA request */
  __HAL_LPTIM_DISABLE_DMA(hlptim, LPTIM_DMA_UPDATE);

  switch (Channel)
  {
    case LPTIM_CHANNEL_1:
      /* Disable update event DMA request */
      (void)HAL_DMA_Abort_IT(hlptim->hdma[LPTIM_DMA_ID_CC1]);
      break;
    case LPTIM_CHANNEL_2:
      /* Disable update event DMA request */
      (void)HAL_DMA_Abort_IT(hlptim->hdma[LPTIM_DMA_ID_CC2]);
      break;
    default:
      break;
  }

  /* Disable LPTIM signal from the corresponding output pin */
  __HAL_LPTIM_CAPTURE_COMPARE_DISABLE(hlptim, Channel);

  /* Disable the Peripheral */
  __HAL_LPTIM_DISABLE(hlptim);

  /* Set the LPTIM channel state */
  LPTIM_CHANNEL_STATE_SET(hlptim, Channel, HAL_LPTIM_CHANNEL_STATE_READY);

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_OnePulse_Start(LPTIM_HandleTypeDef *hlptim, uint32_t Channel)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_CCX_INSTANCE(hlptim->Instance, Channel));

  /* Check LPTIM channel state */
  if (LPTIM_CHANNEL_STATE_GET(hlptim, Channel) != HAL_LPTIM_CHANNEL_STATE_READY)
  {
    return HAL_ERROR;
  }

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Set the LPTIM channel state */
  LPTIM_CHANNEL_STATE_SET(hlptim, Channel, HAL_LPTIM_CHANNEL_STATE_BUSY);

  /* Reset WAVE bit to set one pulse mode */
  hlptim->Instance->CFGR &= ~LPTIM_CFGR_WAVE;

  /* Enable the Peripheral */
  __HAL_LPTIM_ENABLE(hlptim);

  /* Enable LPTIM signal on the corresponding output pin */
  __HAL_LPTIM_CAPTURE_COMPARE_ENABLE(hlptim, Channel);

  /* Start timer in single (one shot) mode */
  __HAL_LPTIM_START_SINGLE(hlptim);

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_OnePulse_Stop(LPTIM_HandleTypeDef *hlptim, uint32_t Channel)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_CCX_INSTANCE(hlptim->Instance, Channel));

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Disable LPTIM signal on the corresponding output pin */
  __HAL_LPTIM_CAPTURE_COMPARE_DISABLE(hlptim, Channel);

  /* Disable the Peripheral */
  __HAL_LPTIM_DISABLE(hlptim);

  /* Set the LPTIM channel state */
  LPTIM_CHANNEL_STATE_SET(hlptim, Channel, HAL_LPTIM_CHANNEL_STATE_READY);

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_OnePulse_Start_IT(LPTIM_HandleTypeDef *hlptim, uint32_t Channel)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_CCX_INSTANCE(hlptim->Instance, Channel));

  /* Check LPTIM channel state */
  if (LPTIM_CHANNEL_STATE_GET(hlptim, Channel) != HAL_LPTIM_CHANNEL_STATE_READY)
  {
    return HAL_ERROR;
  }

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Set the LPTIM channel state */
  LPTIM_CHANNEL_STATE_SET(hlptim, Channel, HAL_LPTIM_CHANNEL_STATE_BUSY);

  /* Reset WAVE bit to set one pulse mode */
  hlptim->Instance->CFGR &= ~LPTIM_CFGR_WAVE;

  /* Enable the Peripheral */
  __HAL_LPTIM_ENABLE(hlptim);

  /* Clear flag */
  __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_DIEROK);

  switch (Channel)
  {
    case LPTIM_CHANNEL_1:
      /* Enable  interrupt */
      __HAL_LPTIM_ENABLE_IT(hlptim, LPTIM_IT_CMP1OK | LPTIM_IT_CC1 | LPTIM_IT_ARROK | LPTIM_IT_ARRM | LPTIM_IT_REPOK |
                            LPTIM_IT_UPDATE);
      break;
    case LPTIM_CHANNEL_2:
      /* Enable interrupt */
      __HAL_LPTIM_ENABLE_IT(hlptim, LPTIM_IT_CMP2OK | LPTIM_IT_CC2 | LPTIM_IT_ARROK | LPTIM_IT_ARRM | LPTIM_IT_REPOK |
                            LPTIM_IT_UPDATE);
      break;
    default:
      break;
  }

  /* Wait for the completion of the write operation to the LPTIM_DIER register */
  if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_DIEROK) == HAL_TIMEOUT)
  {
    return HAL_TIMEOUT;
  }

  /* If external trigger source is used, then enable external trigger interrupt */
  if ((hlptim->Init.Trigger.Source) != LPTIM_TRIGSOURCE_SOFTWARE)
  {
    /* Clear flag */
    __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_DIEROK);
    /* Enable external trigger interrupt */
    __HAL_LPTIM_ENABLE_IT(hlptim, LPTIM_IT_EXTTRIG);
    /* Wait for the completion of the write operation to the LPTIM_DIER register */
    if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_DIEROK) == HAL_TIMEOUT)
    {
      return HAL_TIMEOUT;
    }
  }

  /* Enable LPTIM signal on the corresponding output pin */
  __HAL_LPTIM_CAPTURE_COMPARE_ENABLE(hlptim, Channel);

  /* Start timer in single (one shot) mode */
  __HAL_LPTIM_START_SINGLE(hlptim);

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_OnePulse_Stop_IT(LPTIM_HandleTypeDef *hlptim, uint32_t Channel)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_CCX_INSTANCE(hlptim->Instance, Channel));

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Disable LPTIM signal on the corresponding output pin */
  __HAL_LPTIM_CAPTURE_COMPARE_DISABLE(hlptim, Channel);

  /* Disable the Peripheral */
  __HAL_LPTIM_DISABLE(hlptim);


  /* Enable the Peripheral */
  __HAL_LPTIM_ENABLE(hlptim);

  /* Clear flag */
  __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_DIEROK);

  switch (Channel)
  {
    case LPTIM_CHANNEL_1:
      /* Disable interrupt */
      __HAL_LPTIM_DISABLE_IT(hlptim, LPTIM_IT_CMP1OK | LPTIM_IT_CC1 | LPTIM_IT_ARROK | LPTIM_IT_ARRM | LPTIM_IT_REPOK |
                             LPTIM_IT_UPDATE);
      break;
    case LPTIM_CHANNEL_2:
      /* Disable interrupt */
      __HAL_LPTIM_DISABLE_IT(hlptim, LPTIM_IT_CMP2OK | LPTIM_IT_CC2 | LPTIM_IT_ARROK | LPTIM_IT_ARRM | LPTIM_IT_REPOK |
                             LPTIM_IT_UPDATE);
      break;
    default:
      break;
  }

  /* Wait for the completion of the write operation to the LPTIM_DIER register */
  if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_DIEROK) == HAL_TIMEOUT)
  {
    return HAL_TIMEOUT;
  }

  /* If external trigger source is used, then enable external trigger interrupt */
  if ((hlptim->Init.Trigger.Source) != LPTIM_TRIGSOURCE_SOFTWARE)
  {
    /* Clear flag */
    __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_DIEROK);
    /* Enable external trigger interrupt */
    __HAL_LPTIM_DISABLE_IT(hlptim, LPTIM_IT_EXTTRIG);
    /* Wait for the completion of the write operation to the LPTIM_DIER register */
    if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_DIEROK) == HAL_TIMEOUT)
    {
      return HAL_TIMEOUT;
    }
  }

  /* Disable the Peripheral */
  __HAL_LPTIM_DISABLE(hlptim);

  /* Set the LPTIM channel state */
  LPTIM_CHANNEL_STATE_SET(hlptim, Channel, HAL_LPTIM_CHANNEL_STATE_READY);

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_SetOnce_Start(LPTIM_HandleTypeDef *hlptim, uint32_t Channel)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_CCX_INSTANCE(hlptim->Instance, Channel));

  /* Check LPTIM channel state */
  if (LPTIM_CHANNEL_STATE_GET(hlptim, Channel) != HAL_LPTIM_CHANNEL_STATE_READY)
  {
    return HAL_ERROR;
  }

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Set the LPTIM channel state */
  LPTIM_CHANNEL_STATE_SET(hlptim, Channel, HAL_LPTIM_CHANNEL_STATE_BUSY);

  /* Set WAVE bit to enable the set once mode */
  hlptim->Instance->CFGR |= LPTIM_CFGR_WAVE;

  /* Enable the Peripheral */
  __HAL_LPTIM_ENABLE(hlptim);

  /* Enable LPTIM signal on the corresponding output pin */
  __HAL_LPTIM_CAPTURE_COMPARE_ENABLE(hlptim, Channel);

  /* Start timer in single (one shot) mode */
  __HAL_LPTIM_START_SINGLE(hlptim);

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_SetOnce_Stop(LPTIM_HandleTypeDef *hlptim, uint32_t Channel)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_CCX_INSTANCE(hlptim->Instance, Channel));

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Disable LPTIM signal on the corresponding output pin */
  __HAL_LPTIM_CAPTURE_COMPARE_DISABLE(hlptim, Channel);

  /* Disable the Peripheral */
  __HAL_LPTIM_DISABLE(hlptim);

  /* Set the LPTIM channel state */
  LPTIM_CHANNEL_STATE_SET(hlptim, Channel, HAL_LPTIM_CHANNEL_STATE_READY);

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_SetOnce_Start_IT(LPTIM_HandleTypeDef *hlptim, uint32_t Channel)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_CCX_INSTANCE(hlptim->Instance, Channel));

  /* Check LPTIM channel state */
  if (LPTIM_CHANNEL_STATE_GET(hlptim, Channel) != HAL_LPTIM_CHANNEL_STATE_READY)
  {
    return HAL_ERROR;
  }

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Set the LPTIM channel state */
  LPTIM_CHANNEL_STATE_SET(hlptim, Channel, HAL_LPTIM_CHANNEL_STATE_BUSY);

  /* Set WAVE bit to enable the set once mode */
  hlptim->Instance->CFGR |= LPTIM_CFGR_WAVE;

  /* Enable the Peripheral */
  __HAL_LPTIM_ENABLE(hlptim);

  /* Clear flag */
  __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_DIEROK);

  switch (Channel)
  {
    case LPTIM_CHANNEL_1:
      /* Enable interrupt */
      __HAL_LPTIM_ENABLE_IT(hlptim, LPTIM_IT_CMP1OK | LPTIM_IT_CC1 | LPTIM_IT_ARROK | LPTIM_IT_ARRM | LPTIM_IT_UPDATE);
      break;
    case LPTIM_CHANNEL_2:
      /* Enable interrupt */
      __HAL_LPTIM_ENABLE_IT(hlptim, LPTIM_IT_CMP2OK | LPTIM_IT_CC2 | LPTIM_IT_ARROK | LPTIM_IT_ARRM | LPTIM_IT_UPDATE);
      break;
    default:
      break;
  }

  /* Wait for the completion of the write operation to the LPTIM_DIER register */
  if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_DIEROK) == HAL_TIMEOUT)
  {
    return HAL_TIMEOUT;
  }

  /* If external trigger source is used, then enable external trigger interrupt */
  if ((hlptim->Init.Trigger.Source) != LPTIM_TRIGSOURCE_SOFTWARE)
  {
    /* Clear flag */
    __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_DIEROK);
    /* Enable external trigger interrupt */
    __HAL_LPTIM_ENABLE_IT(hlptim, LPTIM_IT_EXTTRIG);
    /* Wait for the completion of the write operation to the LPTIM_DIER register */
    if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_DIEROK) == HAL_TIMEOUT)
    {
      return HAL_TIMEOUT;
    }
  }

  /* Enable LPTIM signal on the corresponding output pin */
  __HAL_LPTIM_CAPTURE_COMPARE_ENABLE(hlptim, Channel);

  /* Start timer in single (one shot) mode */
  __HAL_LPTIM_START_SINGLE(hlptim);

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_SetOnce_Stop_IT(LPTIM_HandleTypeDef *hlptim, uint32_t Channel)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_CCX_INSTANCE(hlptim->Instance, Channel));

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Disable LPTIM signal on the corresponding output pin */
  __HAL_LPTIM_CAPTURE_COMPARE_DISABLE(hlptim, Channel);

  /* Disable the Peripheral */
  __HAL_LPTIM_DISABLE(hlptim);

  /* Enable the Peripheral */
  __HAL_LPTIM_ENABLE(hlptim);

  /* Clear flag */
  __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_DIEROK);

  switch (Channel)
  {
    case LPTIM_CHANNEL_1:
      /* Disable interrupt */
      __HAL_LPTIM_DISABLE_IT(hlptim, LPTIM_IT_CMP1OK | LPTIM_IT_CC1 | LPTIM_IT_ARROK | LPTIM_IT_ARRM);
      break;
    case LPTIM_CHANNEL_2:
      /* Disable interrupt */
      __HAL_LPTIM_DISABLE_IT(hlptim, LPTIM_IT_CMP2OK | LPTIM_IT_CC2 | LPTIM_IT_ARROK | LPTIM_IT_ARRM);
      break;
    default:
      break;
  }

  /* Wait for the completion of the write operation to the LPTIM_DIER register */
  if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_DIEROK) == HAL_TIMEOUT)
  {
    return HAL_TIMEOUT;
  }

  /* If external trigger source is used, then enable external trigger interrupt */
  if ((hlptim->Init.Trigger.Source) != LPTIM_TRIGSOURCE_SOFTWARE)
  {
    /* Clear flag */
    __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_DIEROK);
    /* Enable external trigger interrupt */
    __HAL_LPTIM_DISABLE_IT(hlptim, LPTIM_IT_EXTTRIG);

    /* Wait for the completion of the write operation to the LPTIM_DIER register */
    if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_DIEROK) == HAL_TIMEOUT)
    {
      return HAL_TIMEOUT;
    }
  }

  /* Disable the Peripheral */
  __HAL_LPTIM_DISABLE(hlptim);

  /* Set the LPTIM channel state */
  LPTIM_CHANNEL_STATE_SET(hlptim, Channel, HAL_LPTIM_CHANNEL_STATE_READY);

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_Encoder_Start(LPTIM_HandleTypeDef *hlptim)
{
  uint32_t          tmpcfgr;

  /* Check the parameters */
  assert_param(IS_LPTIM_ENCODER_INTERFACE_INSTANCE(hlptim->Instance));
  assert_param(hlptim->Init.Clock.Source == LPTIM_CLOCKSOURCE_APBCLOCK_LPOSC);
  assert_param(hlptim->Init.Clock.Prescaler == LPTIM_PRESCALER_DIV1);
  assert_param(IS_LPTIM_CLOCK_POLARITY(hlptim->Init.UltraLowPowerClock.Polarity));

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Get the LPTIMx CFGR value */
  tmpcfgr = hlptim->Instance->CFGR;

  /* Clear CKPOL bits */
  tmpcfgr &= (uint32_t)(~LPTIM_CFGR_CKPOL);

  /* Set Input polarity */
  tmpcfgr |=  hlptim->Init.UltraLowPowerClock.Polarity;

  /* Write to LPTIMx CFGR */
  hlptim->Instance->CFGR = tmpcfgr;

  /* Set ENC bit to enable the encoder interface */
  hlptim->Instance->CFGR |= LPTIM_CFGR_ENC;

  /* Enable the Peripheral */
  __HAL_LPTIM_ENABLE(hlptim);

  /* Start timer in continuous mode */
  __HAL_LPTIM_START_CONTINUOUS(hlptim);

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_Encoder_Stop(LPTIM_HandleTypeDef *hlptim)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_ENCODER_INTERFACE_INSTANCE(hlptim->Instance));

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Disable the Peripheral */
  __HAL_LPTIM_DISABLE(hlptim);

  /* Reset ENC bit to disable the encoder interface */
  hlptim->Instance->CFGR &= ~LPTIM_CFGR_ENC;

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_Encoder_Start_IT(LPTIM_HandleTypeDef *hlptim)
{
  uint32_t          tmpcfgr;

  /* Check the parameters */
  assert_param(IS_LPTIM_ENCODER_INTERFACE_INSTANCE(hlptim->Instance));
  assert_param(hlptim->Init.Clock.Source == LPTIM_CLOCKSOURCE_APBCLOCK_LPOSC);
  assert_param(hlptim->Init.Clock.Prescaler == LPTIM_PRESCALER_DIV1);
  assert_param(IS_LPTIM_CLOCK_POLARITY(hlptim->Init.UltraLowPowerClock.Polarity));

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Configure edge sensitivity for encoder mode */
  /* Get the LPTIMx CFGR value */
  tmpcfgr = hlptim->Instance->CFGR;

  /* Clear CKPOL bits */
  tmpcfgr &= (uint32_t)(~LPTIM_CFGR_CKPOL);

  /* Set Input polarity */
  tmpcfgr |=  hlptim->Init.UltraLowPowerClock.Polarity;

  /* Write to LPTIMx CFGR */
  hlptim->Instance->CFGR = tmpcfgr;

  /* Set ENC bit to enable the encoder interface */
  hlptim->Instance->CFGR |= LPTIM_CFGR_ENC;

  /* Enable the Peripheral */
  __HAL_LPTIM_ENABLE(hlptim);

  /* Clear flag */
  __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_DIEROK);

  /* Enable "switch to up/down direction" interrupt */
  __HAL_LPTIM_ENABLE_IT(hlptim, LPTIM_IT_UP | LPTIM_IT_DOWN);

  /* Wait for the completion of the write operation to the LPTIM_DIER register */
  if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_DIEROK) == HAL_TIMEOUT)
  {
    return HAL_TIMEOUT;
  }


  /* Start timer in continuous mode */
  __HAL_LPTIM_START_CONTINUOUS(hlptim);

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_Encoder_Stop_IT(LPTIM_HandleTypeDef *hlptim)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_ENCODER_INTERFACE_INSTANCE(hlptim->Instance));

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Disable the Peripheral */
  __HAL_LPTIM_DISABLE(hlptim);

  /* Reset ENC bit to disable the encoder interface */
  hlptim->Instance->CFGR &= ~LPTIM_CFGR_ENC;
  /* Enable the Peripheral */
  __HAL_LPTIM_ENABLE(hlptim);

  /* Clear flag */
  __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_DIEROK);

  /* Disable "switch to down/up direction" interrupt */
  __HAL_LPTIM_DISABLE_IT(hlptim, LPTIM_IT_UP | LPTIM_IT_DOWN);

  /* Wait for the completion of the write operation to the LPTIM_DIER register */
  if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_DIEROK) == HAL_TIMEOUT)
  {
    return HAL_TIMEOUT;
  }

  /* Disable the Peripheral */
  __HAL_LPTIM_DISABLE(hlptim);

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_TimeOut_Start(LPTIM_HandleTypeDef *hlptim, uint32_t Timeout)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_INSTANCE(hlptim->Instance));
  assert_param(IS_LPTIM_PULSE(Timeout));

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Set TIMOUT bit to enable the timeout function */
  hlptim->Instance->CFGR |= LPTIM_CFGR_TIMOUT;

  /* Enable the Peripheral */
  __HAL_LPTIM_ENABLE(hlptim);

  /* Clear flag */
  __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_CMP1OK);

  /* Load the Timeout value in the compare register */
  __HAL_LPTIM_COMPARE_SET(hlptim, LPTIM_CHANNEL_1, Timeout);

  /* Wait for the completion of the write operation to the LPTIM_CCR1 register */
  if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_CMP1OK) == HAL_TIMEOUT)
  {
    return HAL_TIMEOUT;
  }

  /* Start timer in continuous mode */
  __HAL_LPTIM_START_CONTINUOUS(hlptim);

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_TimeOut_Stop(LPTIM_HandleTypeDef *hlptim)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_INSTANCE(hlptim->Instance));

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Disable the Peripheral */
  __HAL_LPTIM_DISABLE(hlptim);

  /* Reset TIMOUT bit to enable the timeout function */
  hlptim->Instance->CFGR &= ~LPTIM_CFGR_TIMOUT;

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_TimeOut_Start_IT(LPTIM_HandleTypeDef *hlptim, uint32_t Timeout)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_INSTANCE(hlptim->Instance));
  assert_param(IS_LPTIM_PULSE(Timeout));

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Enable EXTI Line interrupt on the LPTIM Wake-up Timer */
  __HAL_LPTIM_WAKEUPTIMER_EXTI_ENABLE_IT(hlptim->Instance);

  /* Set TIMOUT bit to enable the timeout function */
  hlptim->Instance->CFGR |= LPTIM_CFGR_TIMOUT;

  /* Enable the Peripheral */
  __HAL_LPTIM_ENABLE(hlptim);

  /* Clear flag */
  __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_DIEROK);

  /* Enable Compare match CH1 interrupt */
  __HAL_LPTIM_ENABLE_IT(hlptim, LPTIM_IT_CC1);

  /* Wait for the completion of the write operation to the LPTIM_DIER register */
  if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_DIEROK) == HAL_TIMEOUT)
  {
    return HAL_TIMEOUT;
  }

  /* Clear flag */
  __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_CMP1OK);

  /* Load the Timeout value in the compare register */
  __HAL_LPTIM_COMPARE_SET(hlptim, LPTIM_CHANNEL_1, Timeout);

  /* Wait for the completion of the write operation to the LPTIM_CCR1 register */
  if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_CMP1OK) == HAL_TIMEOUT)
  {
    return HAL_TIMEOUT;
  }

  /* Start timer in continuous mode */
  __HAL_LPTIM_START_CONTINUOUS(hlptim);

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_TimeOut_Stop_IT(LPTIM_HandleTypeDef *hlptim)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_INSTANCE(hlptim->Instance));


  /* Disable EXTI Line interrupt on the LPTIM Wake-up Timer */
  __HAL_LPTIM_WAKEUPTIMER_EXTI_DISABLE_IT(hlptim->Instance);

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Disable the Peripheral */
  __HAL_LPTIM_DISABLE(hlptim);

  /* Reset TIMOUT bit to enable the timeout function */
  hlptim->Instance->CFGR &= ~LPTIM_CFGR_TIMOUT;

  /* Enable the Peripheral */
  __HAL_LPTIM_ENABLE(hlptim);

  /* Clear flag */
  __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_DIEROK);

  /* Disable Compare match CH1 interrupt */
  __HAL_LPTIM_DISABLE_IT(hlptim, LPTIM_IT_CC1);

  /* Wait for the completion of the write operation to the LPTIM_DIER register */
  if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_DIEROK) == HAL_TIMEOUT)
  {
    return HAL_TIMEOUT;
  }

  /* Disable the Peripheral */
  __HAL_LPTIM_DISABLE(hlptim);

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_Counter_Start(LPTIM_HandleTypeDef *hlptim)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_INSTANCE(hlptim->Instance));

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* If clock source is not ULPTIM clock and counter source is external, then it must not be prescaled */
  if ((hlptim->Init.Clock.Source != LPTIM_CLOCKSOURCE_ULPTIM)
      && (hlptim->Init.CounterSource == LPTIM_COUNTERSOURCE_EXTERNAL))
  {
    /* Check if clock is prescaled */
    assert_param(IS_LPTIM_CLOCK_PRESCALERDIV1(hlptim->Init.Clock.Prescaler));
    /* Set clock prescaler to 0 */
    hlptim->Instance->CFGR &= ~LPTIM_CFGR_PRESC;
  }

  /* Enable the Peripheral */
  __HAL_LPTIM_ENABLE(hlptim);

  /* Start timer in continuous mode */
  __HAL_LPTIM_START_CONTINUOUS(hlptim);

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_Counter_Stop(LPTIM_HandleTypeDef *hlptim)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_INSTANCE(hlptim->Instance));

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Disable the Peripheral */
  __HAL_LPTIM_DISABLE(hlptim);

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_Counter_Start_IT(LPTIM_HandleTypeDef *hlptim)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_INSTANCE(hlptim->Instance));

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Enable EXTI Line interrupt on the LPTIM Wake-up Timer */
  __HAL_LPTIM_WAKEUPTIMER_EXTI_ENABLE_IT(hlptim->Instance);

  /* If clock source is not ULPTIM clock and counter source is external, then it must not be prescaled */
  if ((hlptim->Init.Clock.Source != LPTIM_CLOCKSOURCE_ULPTIM)
      && (hlptim->Init.CounterSource == LPTIM_COUNTERSOURCE_EXTERNAL))
  {
    /* Check if clock is prescaled */
    assert_param(IS_LPTIM_CLOCK_PRESCALERDIV1(hlptim->Init.Clock.Prescaler));
    /* Set clock prescaler to 0 */
    hlptim->Instance->CFGR &= ~LPTIM_CFGR_PRESC;
  }

  /* Enable the Peripheral */
  __HAL_LPTIM_ENABLE(hlptim);

  /* Clear flag */
  __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_DIEROK);

  /* Enable interrupt */
  __HAL_LPTIM_ENABLE_IT(hlptim, LPTIM_IT_ARROK | LPTIM_IT_ARRM | LPTIM_IT_REPOK | LPTIM_IT_UPDATE);

  /* Wait for the completion of the write operation to the LPTIM_DIER register */
  if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_DIEROK) == HAL_TIMEOUT)
  {
    return HAL_TIMEOUT;
  }

  /* Start timer in continuous mode */
  __HAL_LPTIM_START_CONTINUOUS(hlptim);

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_Counter_Stop_IT(LPTIM_HandleTypeDef *hlptim)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_INSTANCE(hlptim->Instance));


  /* Disable EXTI Line interrupt on the LPTIM Wake-up Timer */
  __HAL_LPTIM_WAKEUPTIMER_EXTI_DISABLE_IT(hlptim->Instance);

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Disable the Peripheral */
  __HAL_LPTIM_DISABLE(hlptim);


  /* Enable the Peripheral */
  __HAL_LPTIM_ENABLE(hlptim);

  /* Clear flag */
  __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_DIEROK);

  /* Disable interrupt */
  __HAL_LPTIM_DISABLE_IT(hlptim, LPTIM_IT_ARROK | LPTIM_IT_ARRM | LPTIM_IT_REPOK | LPTIM_IT_UPDATE);

  /* Wait for the completion of the write operation to the LPTIM_DIER register */
  if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_DIEROK) == HAL_TIMEOUT)
  {
    return HAL_TIMEOUT;
  }

  /* Disable the Peripheral */
  __HAL_LPTIM_DISABLE(hlptim);

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_IC_Start(LPTIM_HandleTypeDef *hlptim, uint32_t Channel)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_INPUT_CAPTURE_INSTANCE(hlptim->Instance));
  assert_param(IS_LPTIM_CCX_INSTANCE(hlptim->Instance, Channel));

  /* Check LPTIM channel state */
  if (LPTIM_CHANNEL_STATE_GET(hlptim, Channel) != HAL_LPTIM_CHANNEL_STATE_READY)
  {
    return HAL_ERROR;
  }

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Set the LPTIM channel state */
  LPTIM_CHANNEL_STATE_SET(hlptim, Channel, HAL_LPTIM_CHANNEL_STATE_BUSY);

  /* Enable the Peripheral */
  __HAL_LPTIM_ENABLE(hlptim);

  /* Start timer in continuous mode */
  __HAL_LPTIM_START_CONTINUOUS(hlptim);

  /* Enable capture */
  __HAL_LPTIM_CAPTURE_COMPARE_ENABLE(hlptim, Channel);

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_IC_Stop(LPTIM_HandleTypeDef *hlptim, uint32_t Channel)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_INPUT_CAPTURE_INSTANCE(hlptim->Instance));
  assert_param(IS_LPTIM_CCX_INSTANCE(hlptim->Instance, Channel));

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Disable capture */
  __HAL_LPTIM_CAPTURE_COMPARE_DISABLE(hlptim, Channel);

  /* Disable the Peripheral */
  __HAL_LPTIM_DISABLE(hlptim);

  /* Set the LPTIM channel state */
  LPTIM_CHANNEL_STATE_SET(hlptim, Channel, HAL_LPTIM_CHANNEL_STATE_READY);

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_IC_Start_IT(LPTIM_HandleTypeDef *hlptim, uint32_t Channel)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_INPUT_CAPTURE_INSTANCE(hlptim->Instance));
  assert_param(IS_LPTIM_CCX_INSTANCE(hlptim->Instance, Channel));

  /* Check LPTIM channel state */
  if (LPTIM_CHANNEL_STATE_GET(hlptim, Channel) != HAL_LPTIM_CHANNEL_STATE_READY)
  {
    return HAL_ERROR;
  }

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Set the LPTIM channel state */
  LPTIM_CHANNEL_STATE_SET(hlptim, Channel, HAL_LPTIM_CHANNEL_STATE_BUSY);

  /* Enable the Peripheral */
  __HAL_LPTIM_ENABLE(hlptim);

  switch (Channel)
  {
    case LPTIM_CHANNEL_1:
      /* Enable Capture/Compare 1 interrupt */
      __HAL_LPTIM_ENABLE_IT(hlptim, LPTIM_IT_CC1);
      break;
    case LPTIM_CHANNEL_2:
      /* Disable Capture/Compare 2 interrupt */
      __HAL_LPTIM_ENABLE_IT(hlptim, LPTIM_IT_CC2);
      break;
    default:
      break;
  }

  /* Wait for the completion of the write operation to the LPTIM_DIER register */
  if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_DIEROK) == HAL_TIMEOUT)
  {
    return HAL_TIMEOUT;
  }

  /* Start timer in continuous mode */
  __HAL_LPTIM_START_CONTINUOUS(hlptim);

  /* Enable capture */
  __HAL_LPTIM_CAPTURE_COMPARE_ENABLE(hlptim, Channel);

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_IC_Stop_IT(LPTIM_HandleTypeDef *hlptim, uint32_t Channel)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_INPUT_CAPTURE_INSTANCE(hlptim->Instance));
  assert_param(IS_LPTIM_CCX_INSTANCE(hlptim->Instance, Channel));

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  switch (Channel)
  {
    case LPTIM_CHANNEL_1:
      /* Disable Capture/Compare 1 interrupt */
      __HAL_LPTIM_DISABLE_IT(hlptim, LPTIM_IT_CC1);
      break;
    case LPTIM_CHANNEL_2:
      /* Disable Capture/Compare 2 interrupt */
      __HAL_LPTIM_DISABLE_IT(hlptim, LPTIM_IT_CC2);
      break;
    default:
      return HAL_ERROR;
      break;
  }
  /* Disable capture */
  __HAL_LPTIM_CAPTURE_COMPARE_DISABLE(hlptim, Channel);

  /* Disable the Peripheral */
  __HAL_LPTIM_DISABLE(hlptim);

  /* Set the LPTIM channel state */
  LPTIM_CHANNEL_STATE_SET(hlptim, Channel, HAL_LPTIM_CHANNEL_STATE_READY);

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_IC_Start_DMA(LPTIM_HandleTypeDef *hlptim, uint32_t Channel, uint32_t *pData,
                                         uint32_t Length)
{
  DMA_HandleTypeDef *hdma;

  /* Check the parameters */
  assert_param(IS_LPTIM_DMA_INSTANCE(hlptim->Instance));
  assert_param(IS_LPTIM_CCX_INSTANCE(hlptim->Instance, Channel));

  if ((pData == NULL) || (Length == 0U))
  {
    return HAL_ERROR;
  }

  /* Check LPTIM channel state */
  if (LPTIM_CHANNEL_STATE_GET(hlptim, Channel) != HAL_LPTIM_CHANNEL_STATE_READY)
  {
    return HAL_ERROR;
  }

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  /* Set the LPTIM channel state */
  LPTIM_CHANNEL_STATE_SET(hlptim, Channel, HAL_LPTIM_CHANNEL_STATE_BUSY);

  /* Enable the Peripheral */
  __HAL_LPTIM_ENABLE(hlptim);

  switch (Channel)
  {
    case LPTIM_CHANNEL_1:
      /* Set the DMA capture callbacks */
      hlptim->hdma[LPTIM_DMA_ID_CC1]->XferCpltCallback = LPTIM_DMACaptureCplt;
      hlptim->hdma[LPTIM_DMA_ID_CC1]->XferHalfCpltCallback = LPTIM_DMACaptureHalfCplt;

      /* Set the DMA error callback */
      hlptim->hdma[LPTIM_DMA_ID_CC1]->XferErrorCallback = LPTIM_DMAError;

      /* Enable the DMA Channel */
      hdma = hlptim->hdma[LPTIM_DMA_ID_CC1];
      if (LPTIM_DMA_Start_IT(hdma, (uint32_t)&hlptim->Instance->CCR1, (uint32_t)pData, Length) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }

      /* Enable Capture/Compare 1 DMA request */
      __HAL_LPTIM_ENABLE_DMA(hlptim, LPTIM_DMA_CC1);
      break;

    case LPTIM_CHANNEL_2:
      /* Set the DMA capture callbacks */
      hlptim->hdma[LPTIM_DMA_ID_CC2]->XferCpltCallback = LPTIM_DMACaptureCplt;
      hlptim->hdma[LPTIM_DMA_ID_CC2]->XferHalfCpltCallback = LPTIM_DMACaptureHalfCplt;

      /* Set the DMA error callback */
      hlptim->hdma[LPTIM_DMA_ID_CC2]->XferErrorCallback = LPTIM_DMAError;

      /* Enable the DMA Channel */
      hdma = hlptim->hdma[LPTIM_DMA_ID_CC2];
      if (LPTIM_DMA_Start_IT(hdma, (uint32_t)&hlptim->Instance->CCR2, (uint32_t)pData, Length) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }

      /* Enable Capture/Compare 2 DMA request */
      __HAL_LPTIM_ENABLE_DMA(hlptim, LPTIM_DMA_CC2);
      break;

    default:
      break;
  }

  /* Wait for the completion of the write operation to the LPTIM_DIER register */
  if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_DIEROK) == HAL_TIMEOUT)
  {
    return HAL_TIMEOUT;
  }

  /* Start timer in continuous mode */
  __HAL_LPTIM_START_CONTINUOUS(hlptim);

  /* Enable capture */
  __HAL_LPTIM_CAPTURE_COMPARE_ENABLE(hlptim, Channel);

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_IC_Stop_DMA(LPTIM_HandleTypeDef *hlptim, uint32_t Channel)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_DMA_INSTANCE(hlptim->Instance));
  assert_param(IS_LPTIM_CCX_INSTANCE(hlptim->Instance, Channel));

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_BUSY;

  switch (Channel)
  {
    case LPTIM_CHANNEL_1:
      /* Disable Capture/Compare 1 DMA request */
      __HAL_LPTIM_DISABLE_DMA(hlptim, LPTIM_DMA_CC1);
      (void)HAL_DMA_Abort_IT(hlptim->hdma[LPTIM_DMA_ID_CC1]);
      break;

    case LPTIM_CHANNEL_2:
      /* Disable Capture/Compare 2 DMA request */
      __HAL_LPTIM_DISABLE_DMA(hlptim, LPTIM_DMA_CC2);
      (void)HAL_DMA_Abort_IT(hlptim->hdma[LPTIM_DMA_ID_CC2]);
      break;
    default:
      return HAL_ERROR;
      break;
  }

  /* Disable capture */
  __HAL_LPTIM_CAPTURE_COMPARE_DISABLE(hlptim, Channel);

  /* Disable the Peripheral */
  __HAL_LPTIM_DISABLE(hlptim);

  /* Set the LPTIM channel state */
  LPTIM_CHANNEL_STATE_SET(hlptim, Channel, HAL_LPTIM_CHANNEL_STATE_READY);

  /* Set the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
uint32_t HAL_LPTIM_ReadCounter(const LPTIM_HandleTypeDef *hlptim)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_INSTANCE(hlptim->Instance));

  return (hlptim->Instance->CNT);
}
uint32_t HAL_LPTIM_ReadAutoReload(const LPTIM_HandleTypeDef *hlptim)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_INSTANCE(hlptim->Instance));

  return (hlptim->Instance->ARR);
}
uint32_t HAL_LPTIM_ReadCapturedValue(const LPTIM_HandleTypeDef *hlptim, uint32_t Channel)
{
  uint32_t tmpccr;

  /* Check the parameters */
  assert_param(IS_LPTIM_CCX_INSTANCE(hlptim->Instance, Channel));

  switch (Channel)
  {
    case LPTIM_CHANNEL_1:
      tmpccr = hlptim->Instance->CCR1;
      break;
    case LPTIM_CHANNEL_2:
      tmpccr = hlptim->Instance->CCR2;
      break;
    default:
      tmpccr = 0;
      break;
  }
  return tmpccr;
}
uint8_t HAL_LPTIM_IC_GetOffset(const LPTIM_HandleTypeDef *hlptim, uint32_t Channel)
{

  uint8_t offset ;
  uint32_t prescaler;
  uint32_t filter ;

  /* Get prescaler value */
  prescaler = LL_LPTIM_GetPrescaler(hlptim->Instance);

  /* Get filter value */
  filter = LL_LPTIM_IC_GetFilter(hlptim->Instance, Channel);

  /* Get offset value */
  offset = LL_LPTIM_IC_GET_OFFSET(prescaler, filter);

  /* return offset value */
  return offset;
}
HAL_StatusTypeDef HAL_LPTIM_OC_ConfigChannel(LPTIM_HandleTypeDef *hlptim, const LPTIM_OC_ConfigTypeDef *sConfig,
                                             uint32_t Channel)
{
  HAL_StatusTypeDef status;
  /* Check the parameters */
  assert_param(IS_LPTIM_CCX_INSTANCE(hlptim->Instance, Channel));
  assert_param(IS_LPTIM_OC_POLARITY(sConfig->OCPolarity));
  assert_param(IS_LPTIM_PULSE(sConfig->Pulse));

  hlptim->State = HAL_LPTIM_STATE_BUSY;

  switch (Channel)
  {
    case LPTIM_CHANNEL_1:
    {
      /* Check the parameters */
      assert_param(IS_LPTIM_CC1_INSTANCE(hlptim->Instance));

      /* Configure the LPTIM Channel 1 in Output Compare */
      status = LPTIM_OC1_SetConfig(hlptim, sConfig);
      if (status != HAL_OK)
      {
        return status;
      }
      break;
    }
    case LPTIM_CHANNEL_2:
    {
      /* Check the parameters */
      assert_param(IS_LPTIM_CC2_INSTANCE(hlptim->Instance));

      /* Configure the LPTIM Channel 2 in Output Compare */
      status = LPTIM_OC2_SetConfig(hlptim, sConfig);
      if (status != HAL_OK)
      {
        return status;
      }
      break;
    }
    default:
      break;
  }

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
HAL_StatusTypeDef HAL_LPTIM_IC_ConfigChannel(LPTIM_HandleTypeDef *hlptim, const LPTIM_IC_ConfigTypeDef *sConfig,
                                             uint32_t Channel)
{
  /* Check the parameters */
  assert_param(IS_LPTIM_CCX_INSTANCE(hlptim->Instance, Channel));
  assert_param(IS_LPTIM_IC_PRESCALER(sConfig->ICPrescaler));
  assert_param(IS_LPTIM_IC_POLARITY(sConfig->ICPolarity));
  assert_param(IS_LPTIM_IC_FILTER(sConfig->ICFilter));

  hlptim->State = HAL_LPTIM_STATE_BUSY;

  switch (Channel)
  {
    case LPTIM_CHANNEL_1:
    {
      /* Check the parameters */
      assert_param(IS_LPTIM_CC1_INSTANCE(hlptim->Instance));
      assert_param(IS_LPTIM_IC1_SOURCE(hlptim->Instance, sConfig->ICInputSource));

      /* Configure the LPTIM Channel 1 in Input Capture */
      LPTIM_IC1_SetConfig(hlptim, sConfig);
      break;
    }
    case LPTIM_CHANNEL_2:
    {
      /* Check the parameters */
      assert_param(IS_LPTIM_CC2_INSTANCE(hlptim->Instance));
      assert_param(IS_LPTIM_IC2_SOURCE(hlptim->Instance, sConfig->ICInputSource));

      /* Configure the LPTIM Channel 2 in Input Capture */
      LPTIM_IC2_SetConfig(hlptim, sConfig);
      break;
    }
    default:
      break;
  }

  /* Change the LPTIM state */
  hlptim->State = HAL_LPTIM_STATE_READY;
  /* Return function status */
  return HAL_OK;
}
void HAL_LPTIM_IRQHandler(LPTIM_HandleTypeDef *hlptim)
{
  /* Capture Compare 1 interrupt */
  if (__HAL_LPTIM_GET_FLAG(hlptim, LPTIM_FLAG_CC1) != RESET)
  {
    if (__HAL_LPTIM_GET_IT_SOURCE(hlptim, LPTIM_FLAG_CC1) != RESET)
    {
      __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_CC1);
      hlptim->Channel = HAL_LPTIM_ACTIVE_CHANNEL_1;

      /* Input capture event */
      if ((hlptim->Instance->CCMR1 & LPTIM_CCMR1_CC1SEL) != 0x00U)
      {
#if (USE_HAL_LPTIM_REGISTER_CALLBACKS == 1)
        hlptim->IC_CaptureCallback(hlptim);
#else
        HAL_LPTIM_IC_CaptureCallback(hlptim);
#endif /* USE_HAL_LPTIM_REGISTER_CALLBACKS */
      }
      /* Output compare event */
      else
      {
#if (USE_HAL_LPTIM_REGISTER_CALLBACKS == 1)
        hlptim->CompareMatchCallback(hlptim);
#else
        HAL_LPTIM_CompareMatchCallback(hlptim);
#endif /* USE_HAL_LPTIM_REGISTER_CALLBACKS */
      }
      hlptim->Channel = HAL_LPTIM_ACTIVE_CHANNEL_CLEARED;
    }
  }

  /* Capture Compare 2 interrupt */
  if (__HAL_LPTIM_GET_FLAG(hlptim, LPTIM_FLAG_CC2) != RESET)
  {
    if (__HAL_LPTIM_GET_IT_SOURCE(hlptim, LPTIM_FLAG_CC2) != RESET)
    {
      __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_CC2);
      hlptim->Channel = HAL_LPTIM_ACTIVE_CHANNEL_2;

      /* Input capture event */
      if ((hlptim->Instance->CCMR1 & LPTIM_CCMR1_CC2SEL) != 0x00U)
      {
#if (USE_HAL_LPTIM_REGISTER_CALLBACKS == 1)
        hlptim->IC_CaptureCallback(hlptim);
#else
        HAL_LPTIM_IC_CaptureCallback(hlptim);
#endif /* USE_HAL_LPTIM_REGISTER_CALLBACKS */
      }
      /* Output compare event */
      else
      {
#if (USE_HAL_LPTIM_REGISTER_CALLBACKS == 1)
        hlptim->CompareMatchCallback(hlptim);
#else
        HAL_LPTIM_CompareMatchCallback(hlptim);
#endif /* USE_HAL_LPTIM_REGISTER_CALLBACKS */
      }
      hlptim->Channel = HAL_LPTIM_ACTIVE_CHANNEL_CLEARED;
    }
  }

  /* Over Capture 1 interrupt */
  if (__HAL_LPTIM_GET_FLAG(hlptim, LPTIM_FLAG_CC1O) != RESET)
  {
    if (__HAL_LPTIM_GET_IT_SOURCE(hlptim, LPTIM_FLAG_CC1O) != RESET)
    {
      __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_CC1O);
      hlptim->Channel = HAL_LPTIM_ACTIVE_CHANNEL_1;

      /* Over capture event */
#if (USE_HAL_LPTIM_REGISTER_CALLBACKS == 1)
      hlptim->IC_OverCaptureCallback(hlptim);
#else
      HAL_LPTIM_IC_OverCaptureCallback(hlptim);
#endif /* USE_HAL_LPTIM_REGISTER_CALLBACKS */
      hlptim->Channel = HAL_LPTIM_ACTIVE_CHANNEL_CLEARED;
    }
  }

  /* Over Capture 2 interrupt */
  if (__HAL_LPTIM_GET_FLAG(hlptim, LPTIM_FLAG_CC2O) != RESET)
  {
    if (__HAL_LPTIM_GET_IT_SOURCE(hlptim, LPTIM_FLAG_CC2O) != RESET)
    {
      __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_CC2O);
      hlptim->Channel = HAL_LPTIM_ACTIVE_CHANNEL_2;

      /* Over capture event */
#if (USE_HAL_LPTIM_REGISTER_CALLBACKS == 1)
      hlptim->IC_OverCaptureCallback(hlptim);
#else
      HAL_LPTIM_IC_OverCaptureCallback(hlptim);
#endif /* USE_HAL_LPTIM_REGISTER_CALLBACKS */
      hlptim->Channel = HAL_LPTIM_ACTIVE_CHANNEL_CLEARED;
    }
  }

  /* Autoreload match interrupt */
  if (__HAL_LPTIM_GET_FLAG(hlptim, LPTIM_FLAG_ARRM) != RESET)
  {
    if (__HAL_LPTIM_GET_IT_SOURCE(hlptim, LPTIM_IT_ARRM) != RESET)
    {
      /* Clear Autoreload match flag */
      __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_ARRM);

      /* Autoreload match Callback */
#if (USE_HAL_LPTIM_REGISTER_CALLBACKS == 1)
      hlptim->AutoReloadMatchCallback(hlptim);
#else
      HAL_LPTIM_AutoReloadMatchCallback(hlptim);
#endif /* USE_HAL_LPTIM_REGISTER_CALLBACKS */
    }
  }

  /* Trigger detected interrupt */
  if (__HAL_LPTIM_GET_FLAG(hlptim, LPTIM_FLAG_EXTTRIG) != RESET)
  {
    if (__HAL_LPTIM_GET_IT_SOURCE(hlptim, LPTIM_IT_EXTTRIG) != RESET)
    {
      /* Clear Trigger detected flag */
      __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_EXTTRIG);

      /* Trigger detected callback */
#if (USE_HAL_LPTIM_REGISTER_CALLBACKS == 1)
      hlptim->TriggerCallback(hlptim);
#else
      HAL_LPTIM_TriggerCallback(hlptim);
#endif /* USE_HAL_LPTIM_REGISTER_CALLBACKS */
    }
  }

  /* Compare write interrupt */
  if (__HAL_LPTIM_GET_FLAG(hlptim, LPTIM_FLAG_CMP1OK) != RESET)
  {
    if (__HAL_LPTIM_GET_IT_SOURCE(hlptim, LPTIM_IT_CMP1OK) != RESET)
    {
      /* Clear Compare write flag */
      __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_CMP1OK);
      hlptim->Channel = HAL_LPTIM_ACTIVE_CHANNEL_1;
      /* Compare write Callback */
#if (USE_HAL_LPTIM_REGISTER_CALLBACKS == 1)
      hlptim->CompareWriteCallback(hlptim);
#else
      HAL_LPTIM_CompareWriteCallback(hlptim);
#endif /* USE_HAL_LPTIM_REGISTER_CALLBACKS */
    }
  }

  /* Compare write interrupt */
  if (__HAL_LPTIM_GET_FLAG(hlptim, LPTIM_FLAG_CMP2OK) != RESET)
  {
    if (__HAL_LPTIM_GET_IT_SOURCE(hlptim, LPTIM_IT_CMP2OK) != RESET)
    {
      /* Clear Compare write flag */
      __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_CMP2OK);
      hlptim->Channel = HAL_LPTIM_ACTIVE_CHANNEL_2;
      /* Compare write Callback */
#if (USE_HAL_LPTIM_REGISTER_CALLBACKS == 1)
      hlptim->CompareWriteCallback(hlptim);
#else
      HAL_LPTIM_CompareWriteCallback(hlptim);
#endif /* USE_HAL_LPTIM_REGISTER_CALLBACKS */
    }
  }

  /* Autoreload write interrupt */
  if (__HAL_LPTIM_GET_FLAG(hlptim, LPTIM_FLAG_ARROK) != RESET)
  {
    if (__HAL_LPTIM_GET_IT_SOURCE(hlptim, LPTIM_IT_ARROK) != RESET)
    {
      /* Clear Autoreload write flag */
      __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_ARROK);

      /* Autoreload write Callback */
#if (USE_HAL_LPTIM_REGISTER_CALLBACKS == 1)
      hlptim->AutoReloadWriteCallback(hlptim);
#else
      HAL_LPTIM_AutoReloadWriteCallback(hlptim);
#endif /* USE_HAL_LPTIM_REGISTER_CALLBACKS */
    }
  }

  /* Direction counter changed from Down to Up interrupt */
  if (__HAL_LPTIM_GET_FLAG(hlptim, LPTIM_FLAG_UP) != RESET)
  {
    if (__HAL_LPTIM_GET_IT_SOURCE(hlptim, LPTIM_IT_UP) != RESET)
    {
      /* Clear Direction counter changed from Down to Up flag */
      __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_UP);

      /* Direction counter changed from Down to Up Callback */
#if (USE_HAL_LPTIM_REGISTER_CALLBACKS == 1)
      hlptim->DirectionUpCallback(hlptim);
#else
      HAL_LPTIM_DirectionUpCallback(hlptim);
#endif /* USE_HAL_LPTIM_REGISTER_CALLBACKS */
    }
  }

  /* Direction counter changed from Up to Down interrupt */
  if (__HAL_LPTIM_GET_FLAG(hlptim, LPTIM_FLAG_DOWN) != RESET)
  {
    if (__HAL_LPTIM_GET_IT_SOURCE(hlptim, LPTIM_IT_DOWN) != RESET)
    {
      /* Clear Direction counter changed from Up to Down flag */
      __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_DOWN);

      /* Direction counter changed from Up to Down Callback */
#if (USE_HAL_LPTIM_REGISTER_CALLBACKS == 1)
      hlptim->DirectionDownCallback(hlptim);
#else
      HAL_LPTIM_DirectionDownCallback(hlptim);
#endif /* USE_HAL_LPTIM_REGISTER_CALLBACKS */
    }
  }

  /* Repetition counter underflowed (or contains zero) and the LPTIM counter
     overflowed */
  if (__HAL_LPTIM_GET_FLAG(hlptim, LPTIM_FLAG_UPDATE) != RESET)
  {
    if (__HAL_LPTIM_GET_IT_SOURCE(hlptim, LPTIM_IT_UPDATE) != RESET)
    {
      /* Clear update event flag */
      __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_UPDATE);

      /* Update event Callback */
#if (USE_HAL_LPTIM_REGISTER_CALLBACKS == 1)
      hlptim->UpdateEventCallback(hlptim);
#else
      HAL_LPTIM_UpdateEventCallback(hlptim);
#endif /* USE_HAL_LPTIM_REGISTER_CALLBACKS */
    }
  }

  /* Successful APB bus write to repetition counter register */
  if (__HAL_LPTIM_GET_FLAG(hlptim, LPTIM_FLAG_REPOK) != RESET)
  {
    if (__HAL_LPTIM_GET_IT_SOURCE(hlptim, LPTIM_IT_REPOK) != RESET)
    {
      /* Clear successful APB bus write to repetition counter flag */
      __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_REPOK);

      /* Successful APB bus write to repetition counter Callback */
#if (USE_HAL_LPTIM_REGISTER_CALLBACKS == 1)
      hlptim->RepCounterWriteCallback(hlptim);
#else
      HAL_LPTIM_RepCounterWriteCallback(hlptim);
#endif /* USE_HAL_LPTIM_REGISTER_CALLBACKS */
    }
  }
}
#if CP_MODE
HAL_StatusTypeDef HAL_LPTIM_RegisterCallback(LPTIM_HandleTypeDef        *hlptim,
                                             HAL_LPTIM_CallbackIDTypeDef CallbackID,
                                             pLPTIM_CallbackTypeDef      pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    return HAL_ERROR;
  }

  if (hlptim->State == HAL_LPTIM_STATE_READY)
  {
    switch (CallbackID)
    {
      case HAL_LPTIM_MSPINIT_CB_ID :
        hlptim->MspInitCallback = pCallback;
        break;

      case HAL_LPTIM_MSPDEINIT_CB_ID :
        hlptim->MspDeInitCallback = pCallback;
        break;

      case HAL_LPTIM_COMPARE_MATCH_CB_ID :
        hlptim->CompareMatchCallback = pCallback;
        break;

      case HAL_LPTIM_AUTORELOAD_MATCH_CB_ID :
        hlptim->AutoReloadMatchCallback = pCallback;
        break;

      case HAL_LPTIM_TRIGGER_CB_ID :
        hlptim->TriggerCallback = pCallback;
        break;

      case HAL_LPTIM_COMPARE_WRITE_CB_ID :
        hlptim->CompareWriteCallback = pCallback;
        break;

      case HAL_LPTIM_AUTORELOAD_WRITE_CB_ID :
        hlptim->AutoReloadWriteCallback = pCallback;
        break;

      case HAL_LPTIM_DIRECTION_UP_CB_ID :
        hlptim->DirectionUpCallback = pCallback;
        break;

      case HAL_LPTIM_DIRECTION_DOWN_CB_ID :
        hlptim->DirectionDownCallback = pCallback;
        break;

      case HAL_LPTIM_UPDATE_EVENT_CB_ID :
        hlptim->UpdateEventCallback = pCallback;
        break;

      case HAL_LPTIM_REP_COUNTER_WRITE_CB_ID :
        hlptim->RepCounterWriteCallback = pCallback;
        break;

      case HAL_LPTIM_UPDATE_EVENT_HALF_CB_ID :
        hlptim->UpdateEventHalfCpltCallback = pCallback;
        break;

      case HAL_LPTIM_ERROR_CB_ID :
        hlptim->ErrorCallback = pCallback;
        break;

      case HAL_LPTIM_IC_CAPTURE_CB_ID :
        hlptim->IC_CaptureCallback = pCallback;
        break;

      case HAL_LPTIM_IC_CAPTURE_HALF_CB_ID :
        hlptim->IC_CaptureHalfCpltCallback = pCallback;
        break;

      case HAL_LPTIM_OVER_CAPTURE_CB_ID :
        hlptim->IC_OverCaptureCallback = pCallback;
        break;

      default :
        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (hlptim->State == HAL_LPTIM_STATE_RESET)
  {
    switch (CallbackID)
    {
      case HAL_LPTIM_MSPINIT_CB_ID :
        hlptim->MspInitCallback = pCallback;
        break;

      case HAL_LPTIM_MSPDEINIT_CB_ID :
        hlptim->MspDeInitCallback = pCallback;
        break;

      default :
        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif
#if CP_MODE
HAL_StatusTypeDef HAL_LPTIM_UnRegisterCallback(LPTIM_HandleTypeDef        *hlptim,
                                               HAL_LPTIM_CallbackIDTypeDef CallbackID)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (hlptim->State == HAL_LPTIM_STATE_READY)
  {
    switch (CallbackID)
    {
      case HAL_LPTIM_MSPINIT_CB_ID :
        /* Legacy weak MspInit Callback */
        hlptim->MspInitCallback = HAL_LPTIM_MspInit;
        break;

      case HAL_LPTIM_MSPDEINIT_CB_ID :
        /* Legacy weak Msp DeInit Callback */
        hlptim->MspDeInitCallback = HAL_LPTIM_MspDeInit;
        break;

      case HAL_LPTIM_COMPARE_MATCH_CB_ID :
        /* Legacy weak Compare match Callback */
        hlptim->CompareMatchCallback = HAL_LPTIM_CompareMatchCallback;
        break;

      case HAL_LPTIM_AUTORELOAD_MATCH_CB_ID :
        /* Legacy weak Auto-reload match Callback */
        hlptim->AutoReloadMatchCallback = HAL_LPTIM_AutoReloadMatchCallback;
        break;

      case HAL_LPTIM_TRIGGER_CB_ID :
        /* Legacy weak External trigger event detection Callback */
        hlptim->TriggerCallback = HAL_LPTIM_TriggerCallback;
        break;

      case HAL_LPTIM_COMPARE_WRITE_CB_ID :
        /* Legacy weak Compare register write complete Callback */
        hlptim->CompareWriteCallback = HAL_LPTIM_CompareWriteCallback;
        break;

      case HAL_LPTIM_AUTORELOAD_WRITE_CB_ID :
        /* Legacy weak Auto-reload register write complete Callback */
        hlptim->AutoReloadWriteCallback = HAL_LPTIM_AutoReloadWriteCallback;
        break;

      case HAL_LPTIM_DIRECTION_UP_CB_ID :
        /* Legacy weak Up-counting direction change Callback */
        hlptim->DirectionUpCallback = HAL_LPTIM_DirectionUpCallback;
        break;

      case HAL_LPTIM_DIRECTION_DOWN_CB_ID :
        /* Legacy weak Down-counting direction change Callback */
        hlptim->DirectionDownCallback = HAL_LPTIM_DirectionDownCallback;
        break;

      case HAL_LPTIM_UPDATE_EVENT_CB_ID :
        /* Legacy weak Update event detection Callback */
        hlptim->UpdateEventCallback = HAL_LPTIM_UpdateEventCallback;
        break;

      case HAL_LPTIM_REP_COUNTER_WRITE_CB_ID :
        /* Legacy weak Repetition counter register write complete Callback */
        hlptim->RepCounterWriteCallback = HAL_LPTIM_RepCounterWriteCallback;
        break;

      case HAL_LPTIM_UPDATE_EVENT_HALF_CB_ID :
        /* Legacy weak Update event half complete detection Callback */
        hlptim->UpdateEventHalfCpltCallback = HAL_LPTIM_UpdateEventHalfCpltCallback;
        break;

      case HAL_LPTIM_ERROR_CB_ID :
        /* Legacy weak error Callback */
        hlptim->ErrorCallback = HAL_LPTIM_ErrorCallback;
        break;

      case HAL_LPTIM_IC_CAPTURE_CB_ID :
        /* Legacy weak IC Capture Callback */
        hlptim->IC_CaptureCallback = HAL_LPTIM_IC_CaptureCallback;
        break;

      case HAL_LPTIM_IC_CAPTURE_HALF_CB_ID :
        /* Legacy weak IC Capture half complete Callback */
        hlptim->IC_CaptureHalfCpltCallback = HAL_LPTIM_IC_CaptureHalfCpltCallback;
        break;

      case HAL_LPTIM_OVER_CAPTURE_CB_ID :
        /* Legacy weak IC over capture Callback */
        hlptim->IC_OverCaptureCallback = HAL_LPTIM_IC_OverCaptureCallback;
        break;

      default :
        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (hlptim->State == HAL_LPTIM_STATE_RESET)
  {
    switch (CallbackID)
    {
      case HAL_LPTIM_MSPINIT_CB_ID :
        /* Legacy weak MspInit Callback */
        hlptim->MspInitCallback = HAL_LPTIM_MspInit;
        break;

      case HAL_LPTIM_MSPDEINIT_CB_ID :
        /* Legacy weak Msp DeInit Callback */
        hlptim->MspDeInitCallback = HAL_LPTIM_MspDeInit;
        break;

      default :
        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif
HAL_LPTIM_StateTypeDef HAL_LPTIM_GetState(const LPTIM_HandleTypeDef *hlptim)
{
  /* Return LPTIM handle state */
  return hlptim->State;
}
#if CP_MODE
static void LPTIM_ResetCallback(LPTIM_HandleTypeDef *lptim)
{
  /* Reset the LPTIM callback to the legacy weak callbacks */
  lptim->CompareMatchCallback    = HAL_LPTIM_CompareMatchCallback;
  lptim->AutoReloadMatchCallback = HAL_LPTIM_AutoReloadMatchCallback;
  lptim->TriggerCallback         = HAL_LPTIM_TriggerCallback;
  lptim->CompareWriteCallback    = HAL_LPTIM_CompareWriteCallback;
  lptim->AutoReloadWriteCallback = HAL_LPTIM_AutoReloadWriteCallback;
  lptim->DirectionUpCallback     = HAL_LPTIM_DirectionUpCallback;
  lptim->DirectionDownCallback   = HAL_LPTIM_DirectionDownCallback;
  lptim->UpdateEventCallback = HAL_LPTIM_UpdateEventCallback;
  lptim->RepCounterWriteCallback = HAL_LPTIM_RepCounterWriteCallback;
  lptim->UpdateEventHalfCpltCallback = HAL_LPTIM_UpdateEventHalfCpltCallback;
  lptim->IC_CaptureCallback      = HAL_LPTIM_IC_CaptureCallback;
  lptim->IC_CaptureHalfCpltCallback = HAL_LPTIM_IC_CaptureHalfCpltCallback;
  lptim->IC_OverCaptureCallback  = HAL_LPTIM_IC_OverCaptureCallback;
  lptim->ErrorCallback           = HAL_LPTIM_ErrorCallback;
}
#endif
static HAL_StatusTypeDef LPTIM_WaitForFlag(const LPTIM_HandleTypeDef *hlptim, uint32_t flag)
{
  HAL_StatusTypeDef result = HAL_OK;
  uint32_t count = TIMEOUT * (SystemCoreClock / 20UL / 1000UL);
  do
  {
    count--;
    if (count == 0UL)
    {
      result = HAL_TIMEOUT;
    }
  } while ((!(__HAL_LPTIM_GET_FLAG((hlptim), (flag)))) && (count != 0UL));

  return result;
}
void LPTIM_DMAError(DMA_HandleTypeDef *hdma)
{
  LPTIM_HandleTypeDef *hlptim = (LPTIM_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  hlptim->State = HAL_LPTIM_STATE_READY;

#if (USE_HAL_LPTIM_REGISTER_CALLBACKS == 1)
  hlptim->ErrorCallback(hlptim);
#else
  HAL_LPTIM_ErrorCallback(hlptim);
#endif /* USE_HAL_LPTIM_REGISTER_CALLBACKS */
}
void LPTIM_DMACaptureCplt(DMA_HandleTypeDef *hdma)
{
  LPTIM_HandleTypeDef *hlptim = (LPTIM_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  hlptim->State = HAL_LPTIM_STATE_READY;

  if (hdma == hlptim->hdma[LPTIM_DMA_ID_CC1])
  {
    hlptim->Channel = HAL_LPTIM_ACTIVE_CHANNEL_1;
  }
  else if (hdma == hlptim->hdma[LPTIM_DMA_ID_CC2])
  {
    hlptim->Channel = HAL_LPTIM_ACTIVE_CHANNEL_2;
  }
  else
  {
    /* nothing to do */
  }

#if (USE_HAL_LPTIM_REGISTER_CALLBACKS == 1)
  hlptim->IC_CaptureCallback(hlptim);
#else
  HAL_LPTIM_IC_CaptureCallback(hlptim);
#endif /* USE_HAL_LPTIM_REGISTER_CALLBACKS */

  hlptim->Channel = HAL_LPTIM_ACTIVE_CHANNEL_CLEARED;
}
void LPTIM_DMACaptureHalfCplt(DMA_HandleTypeDef *hdma)
{
  LPTIM_HandleTypeDef *hlptim = (LPTIM_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  hlptim->State = HAL_LPTIM_STATE_READY;

  if (hdma == hlptim->hdma[LPTIM_DMA_ID_CC1])
  {
    hlptim->Channel = HAL_LPTIM_ACTIVE_CHANNEL_1;
  }
  else if (hdma == hlptim->hdma[LPTIM_DMA_ID_CC2])
  {
    hlptim->Channel = HAL_LPTIM_ACTIVE_CHANNEL_2;
  }
  else
  {
    /* nothing to do */
  }

#if (USE_HAL_LPTIM_REGISTER_CALLBACKS == 1)
  hlptim->IC_CaptureHalfCpltCallback(hlptim);
#else
  HAL_LPTIM_IC_CaptureHalfCpltCallback(hlptim);
#endif /* USE_HAL_LPTIM_REGISTER_CALLBACKS */

  hlptim->Channel = HAL_LPTIM_ACTIVE_CHANNEL_CLEARED;
}
void LPTIM_DMAUpdateEventCplt(DMA_HandleTypeDef *hdma)
{
  LPTIM_HandleTypeDef *hlptim = (LPTIM_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  hlptim->State = HAL_LPTIM_STATE_READY;

  if (hdma == hlptim->hdma[LPTIM_DMA_ID_CC1])
  {
    hlptim->Channel = HAL_LPTIM_ACTIVE_CHANNEL_1;
  }
  else if (hdma == hlptim->hdma[LPTIM_DMA_ID_CC2])
  {
    hlptim->Channel = HAL_LPTIM_ACTIVE_CHANNEL_2;
  }
  else
  {
    /* nothing to do */
  }

#if (USE_HAL_LPTIM_REGISTER_CALLBACKS == 1)
  hlptim->UpdateEventCallback(hlptim);
#else
  HAL_LPTIM_UpdateEventCallback(hlptim);
#endif /* USE_HAL_LPTIM_REGISTER_CALLBACKS */

  hlptim->Channel = HAL_LPTIM_ACTIVE_CHANNEL_CLEARED;
}
void LPTIM_DMAUpdateEventHalfCplt(DMA_HandleTypeDef *hdma)
{
  LPTIM_HandleTypeDef *hlptim = (LPTIM_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  hlptim->State = HAL_LPTIM_STATE_READY;

  if (hdma == hlptim->hdma[LPTIM_DMA_ID_CC1])
  {
    hlptim->Channel = HAL_LPTIM_ACTIVE_CHANNEL_1;
  }
  else if (hdma == hlptim->hdma[LPTIM_DMA_ID_CC2])
  {
    hlptim->Channel = HAL_LPTIM_ACTIVE_CHANNEL_2;
  }
  else
  {
    /* nothing to do */
  }

#if (USE_HAL_LPTIM_REGISTER_CALLBACKS == 1)
  hlptim->UpdateEventHalfCpltCallback(hlptim);
#else
  HAL_LPTIM_UpdateEventHalfCpltCallback(hlptim);
#endif /* USE_HAL_LPTIM_REGISTER_CALLBACKS */

  hlptim->Channel = HAL_LPTIM_ACTIVE_CHANNEL_CLEARED;
}
static HAL_StatusTypeDef LPTIM_OC1_SetConfig(LPTIM_HandleTypeDef *hlptim, const LPTIM_OC_ConfigTypeDef *sConfig)
{
  uint32_t tmpccmr1;
  uint32_t tmpcfgr;

  tmpccmr1 = hlptim->Instance->CCMR1;
  tmpccmr1 &= ~(LPTIM_CCMR1_CC1P_Msk | LPTIM_CCMR1_CC1SEL_Msk);

  if ((hlptim->Instance == LPTIM4) || (hlptim->Instance == LPTIM5))
  {
    tmpcfgr = hlptim->Instance->CFGR;
    tmpcfgr &= ~LPTIM_CFGR_WAVPOL_Msk;
    tmpcfgr |= sConfig->OCPolarity << LPTIM_CFGR_WAVPOL_Pos;

    /* Write to CFGR register */
    hlptim->Instance->CFGR = tmpcfgr;
  }
  else
  {
    tmpccmr1 |= sConfig->OCPolarity << LPTIM_CCMR1_CC1P_Pos;
  }

  /* Enable the Peripheral */
  __HAL_LPTIM_ENABLE(hlptim);

  /* Clear flag */
  __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_CMP1OK);

  /* Write to CCR1 register */
  __HAL_LPTIM_COMPARE_SET(hlptim, LPTIM_CHANNEL_1, sConfig->Pulse);

  /* Wait for the completion of the write operation to the LPTIM_CCR1 register */
  if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_CMP1OK) == HAL_TIMEOUT)
  {
    return HAL_TIMEOUT;
  }

  /* Disable the Peripheral */
  __HAL_LPTIM_DISABLE(hlptim);

  /* Write to CCMR1 register */
  hlptim->Instance->CCMR1 = tmpccmr1;

  return HAL_OK;
}
static HAL_StatusTypeDef LPTIM_OC2_SetConfig(LPTIM_HandleTypeDef *hlptim, const LPTIM_OC_ConfigTypeDef *sConfig)
{
  uint32_t tmpccmr1;

  tmpccmr1 = hlptim->Instance->CCMR1;
  tmpccmr1 &= ~(LPTIM_CCMR1_CC2P_Msk | LPTIM_CCMR1_CC2SEL_Msk);
  tmpccmr1 |= sConfig->OCPolarity << LPTIM_CCMR1_CC2P_Pos;

  /* Enable the Peripheral */
  __HAL_LPTIM_ENABLE(hlptim);

  /* Clear flag */
  __HAL_LPTIM_CLEAR_FLAG(hlptim, LPTIM_FLAG_CMP2OK);

  /* Write to CCR2 register */
  __HAL_LPTIM_COMPARE_SET(hlptim, LPTIM_CHANNEL_2, sConfig->Pulse);

  /* Wait for the completion of the write operation to the LPTIM_CCR2 register */
  if (LPTIM_WaitForFlag(hlptim, LPTIM_FLAG_CMP2OK) != HAL_OK)
  {
    return HAL_TIMEOUT;
  }

  /* Disable the Peripheral */
  __HAL_LPTIM_DISABLE(hlptim);

  /* Write to CCMR1 register */
  hlptim->Instance->CCMR1 = tmpccmr1;

  return HAL_OK;
}
static void LPTIM_IC1_SetConfig(LPTIM_HandleTypeDef *hlptim, const LPTIM_IC_ConfigTypeDef *sConfig)
{
  uint32_t tmpccmr1;
  uint32_t tmpcfgr2;

  tmpccmr1 = hlptim->Instance->CCMR1;
  tmpccmr1 &= ~(LPTIM_CCMR1_IC1PSC_Msk | LPTIM_CCMR1_CC1P_Msk | LPTIM_CCMR1_IC1F_Msk);
  tmpccmr1 |= sConfig->ICPrescaler |
              sConfig->ICPolarity |
              sConfig->ICFilter |
              LPTIM_CCMR1_CC1SEL;

  tmpcfgr2 = hlptim->Instance->CFGR2;
  tmpcfgr2 &= ~(LPTIM_CFGR2_IC1SEL_Msk);
  tmpcfgr2 |= sConfig->ICInputSource;

  /* Write to CCMR1 register */
  hlptim->Instance->CCMR1 = tmpccmr1;

  /* Write to CFGR2 register */
  hlptim->Instance->CFGR2 = tmpcfgr2;
}
static void LPTIM_IC2_SetConfig(LPTIM_HandleTypeDef *hlptim, const LPTIM_IC_ConfigTypeDef *sConfig)
{
  uint32_t tmpccmr1;
  uint32_t tmpcfgr2;

  tmpccmr1 = hlptim->Instance->CCMR1;
  tmpccmr1 &= ~(LPTIM_CCMR1_IC2PSC_Msk | LPTIM_CCMR1_CC2P_Msk | LPTIM_CCMR1_IC2F_Msk);
  tmpccmr1 |= (sConfig->ICPrescaler << (LPTIM_CCMR1_IC2PSC_Pos - LPTIM_CCMR1_IC1PSC_Pos)) |
              (sConfig->ICPolarity << (LPTIM_CCMR1_CC2P_Pos - LPTIM_CCMR1_CC1P_Pos)) |
              (sConfig->ICFilter << (LPTIM_CCMR1_IC2F_Pos - LPTIM_CCMR1_IC1F_Pos)) |
              LPTIM_CCMR1_CC2SEL;

  tmpcfgr2 = hlptim->Instance->CFGR2;
  tmpcfgr2 &= ~(LPTIM_CFGR2_IC2SEL_Msk);
  tmpcfgr2 |= sConfig->ICInputSource;

  /* Write to CCMR1 register */
  hlptim->Instance->CCMR1 = tmpccmr1;

  /* Write to CFGR2 register */
  hlptim->Instance->CFGR2 = tmpcfgr2;
}
HAL_StatusTypeDef LPTIM_DMA_Start_IT(DMA_HandleTypeDef *hdma, uint32_t src, uint32_t dst,
                                     uint32_t length)
{
  HAL_StatusTypeDef status;

  /* Enable the DMA channel */
  if ((hdma->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
  {
    if ((hdma->LinkedListQueue != 0U) && (hdma->LinkedListQueue->Head != 0U))
    {
      /* Enable the DMA channel */
      hdma->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = length;
      hdma->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = (uint32_t)src;
      hdma->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = (uint32_t)dst;

      status = HAL_DMAEx_List_Start_IT(hdma);
    }
    else
    {
      status = HAL_ERROR;
    }
  }
  else
  {
    status =  HAL_DMA_Start_IT(hdma, src, dst, length);
  }

  return status;
}
