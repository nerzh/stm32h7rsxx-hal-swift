// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// TIM/TIMEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Base_Init(TIM_HandleTypeDef *htim)
{
  /* Check the TIM handle allocation */
  if (htim == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_TIM_INSTANCE(htim->Instance));
  assert_param(IS_TIM_COUNTER_MODE(htim->Init.CounterMode));
  assert_param(IS_TIM_CLOCKDIVISION_DIV(htim->Init.ClockDivision));
  assert_param(IS_TIM_PERIOD(htim, htim->Init.Period));
  assert_param(IS_TIM_AUTORELOAD_PRELOAD(htim->Init.AutoReloadPreload));

  if (htim->State == HAL_TIM_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    htim->Lock = HAL_UNLOCKED;

#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
    /* Reset interrupt callbacks to legacy weak callbacks */
    TIM_ResetCallback(htim);

    if (htim->Base_MspInitCallback == NULL)
    {
      htim->Base_MspInitCallback = HAL_TIM_Base_MspInit;
    }
    /* Init the low level hardware : GPIO, CLOCK, NVIC */
    htim->Base_MspInitCallback(htim);
#else
    /* Init the low level hardware : GPIO, CLOCK, NVIC */
    HAL_TIM_Base_MspInit(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
  }

  /* Set the TIM state */
  htim->State = HAL_TIM_STATE_BUSY;

  /* Set the Time Base configuration */
  TIM_Base_SetConfig(htim->Instance, &htim->Init);

  /* Initialize the DMA burst operation state */
  htim->DMABurstState = HAL_DMA_BURST_STATE_READY;

  /* Initialize the TIM channels state */
  TIM_CHANNEL_STATE_SET_ALL(htim, HAL_TIM_CHANNEL_STATE_READY);
  TIM_CHANNEL_N_STATE_SET_ALL(htim, HAL_TIM_CHANNEL_STATE_READY);

  /* Initialize the TIM state*/
  htim->State = HAL_TIM_STATE_READY;

  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Base_DeInit(TIM_HandleTypeDef *htim)
{
  /* Check the parameters */
  assert_param(IS_TIM_INSTANCE(htim->Instance));

  htim->State = HAL_TIM_STATE_BUSY;

  /* Disable the TIM Peripheral Clock */
  __HAL_TIM_DISABLE(htim);

#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
  if (htim->Base_MspDeInitCallback == NULL)
  {
    htim->Base_MspDeInitCallback = HAL_TIM_Base_MspDeInit;
  }
  /* DeInit the low level hardware */
  htim->Base_MspDeInitCallback(htim);
#else
  /* DeInit the low level hardware: GPIO, CLOCK, NVIC */
  HAL_TIM_Base_MspDeInit(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */

  /* Change the DMA burst operation state */
  htim->DMABurstState = HAL_DMA_BURST_STATE_RESET;

  /* Change the TIM channels state */
  TIM_CHANNEL_STATE_SET_ALL(htim, HAL_TIM_CHANNEL_STATE_RESET);
  TIM_CHANNEL_N_STATE_SET_ALL(htim, HAL_TIM_CHANNEL_STATE_RESET);

  /* Change TIM state */
  htim->State = HAL_TIM_STATE_RESET;

  /* Release Lock */
  __HAL_UNLOCK(htim);

  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Base_Start(TIM_HandleTypeDef *htim)
{
  uint32_t tmpsmcr;

  /* Check the parameters */
  assert_param(IS_TIM_INSTANCE(htim->Instance));

  /* Check the TIM state */
  if (htim->State != HAL_TIM_STATE_READY)
  {
    return HAL_ERROR;
  }

  /* Set the TIM state */
  htim->State = HAL_TIM_STATE_BUSY;

  /* Enable the Peripheral, except in trigger mode where enable is automatically done with trigger */
  if (IS_TIM_SLAVE_INSTANCE(htim->Instance))
  {
    tmpsmcr = htim->Instance->SMCR & TIM_SMCR_SMS;
    if (!IS_TIM_SLAVEMODE_TRIGGER_ENABLED(tmpsmcr))
    {
      __HAL_TIM_ENABLE(htim);
    }
  }
  else
  {
    __HAL_TIM_ENABLE(htim);
  }

  /* Return function status */
  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Base_Stop(TIM_HandleTypeDef *htim)
{
  /* Check the parameters */
  assert_param(IS_TIM_INSTANCE(htim->Instance));

  /* Disable the Peripheral */
  __HAL_TIM_DISABLE(htim);

  /* Set the TIM state */
  htim->State = HAL_TIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Base_Start_IT(TIM_HandleTypeDef *htim)
{
  uint32_t tmpsmcr;

  /* Check the parameters */
  assert_param(IS_TIM_INSTANCE(htim->Instance));

  /* Check the TIM state */
  if (htim->State != HAL_TIM_STATE_READY)
  {
    return HAL_ERROR;
  }

  /* Set the TIM state */
  htim->State = HAL_TIM_STATE_BUSY;

  /* Enable the TIM Update interrupt */
  __HAL_TIM_ENABLE_IT(htim, TIM_IT_UPDATE);

  /* Enable the Peripheral, except in trigger mode where enable is automatically done with trigger */
  if (IS_TIM_SLAVE_INSTANCE(htim->Instance))
  {
    tmpsmcr = htim->Instance->SMCR & TIM_SMCR_SMS;
    if (!IS_TIM_SLAVEMODE_TRIGGER_ENABLED(tmpsmcr))
    {
      __HAL_TIM_ENABLE(htim);
    }
  }
  else
  {
    __HAL_TIM_ENABLE(htim);
  }

  /* Return function status */
  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Base_Stop_IT(TIM_HandleTypeDef *htim)
{
  /* Check the parameters */
  assert_param(IS_TIM_INSTANCE(htim->Instance));

  /* Disable the TIM Update interrupt */
  __HAL_TIM_DISABLE_IT(htim, TIM_IT_UPDATE);

  /* Disable the Peripheral */
  __HAL_TIM_DISABLE(htim);

  /* Set the TIM state */
  htim->State = HAL_TIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Base_Start_DMA(TIM_HandleTypeDef *htim, const uint32_t *pData, uint16_t Length)
{
  uint32_t tmpsmcr;

  /* Check the parameters */
  assert_param(IS_TIM_DMA_INSTANCE(htim->Instance));

  /* Set the TIM state */
  if (htim->State == HAL_TIM_STATE_BUSY)
  {
    return HAL_BUSY;
  }
  else if (htim->State == HAL_TIM_STATE_READY)
  {
    if ((pData == NULL) || (Length == 0U))
    {
      return HAL_ERROR;
    }
    else
    {
      htim->State = HAL_TIM_STATE_BUSY;
    }
  }
  else
  {
    return HAL_ERROR;
  }

  /* Set the DMA Period elapsed callbacks */
  htim->hdma[TIM_DMA_ID_UPDATE]->XferCpltCallback = TIM_DMAPeriodElapsedCplt;
  htim->hdma[TIM_DMA_ID_UPDATE]->XferHalfCpltCallback = TIM_DMAPeriodElapsedHalfCplt;

  /* Set the DMA error callback */
  htim->hdma[TIM_DMA_ID_UPDATE]->XferErrorCallback = TIM_DMAError ;

  /* Enable the DMA channel */
  if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_UPDATE], (uint32_t)pData, (uint32_t)&htim->Instance->ARR,
                       Length) != HAL_OK)
  {
    /* Return error status */
    return HAL_ERROR;
  }

  /* Enable the TIM Update DMA request */
  __HAL_TIM_ENABLE_DMA(htim, TIM_DMA_UPDATE);

  /* Enable the Peripheral, except in trigger mode where enable is automatically done with trigger */
  if (IS_TIM_SLAVE_INSTANCE(htim->Instance))
  {
    tmpsmcr = htim->Instance->SMCR & TIM_SMCR_SMS;
    if (!IS_TIM_SLAVEMODE_TRIGGER_ENABLED(tmpsmcr))
    {
      __HAL_TIM_ENABLE(htim);
    }
  }
  else
  {
    __HAL_TIM_ENABLE(htim);
  }

  /* Return function status */
  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Base_Stop_DMA(TIM_HandleTypeDef *htim)
{
  /* Check the parameters */
  assert_param(IS_TIM_DMA_INSTANCE(htim->Instance));

  /* Disable the TIM Update DMA request */
  __HAL_TIM_DISABLE_DMA(htim, TIM_DMA_UPDATE);

  (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_UPDATE]);

  /* Disable the Peripheral */
  __HAL_TIM_DISABLE(htim);

  /* Set the TIM state */
  htim->State = HAL_TIM_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OC_Init(TIM_HandleTypeDef *htim)
{
  /* Check the TIM handle allocation */
  if (htim == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_TIM_INSTANCE(htim->Instance));
  assert_param(IS_TIM_COUNTER_MODE(htim->Init.CounterMode));
  assert_param(IS_TIM_CLOCKDIVISION_DIV(htim->Init.ClockDivision));
  assert_param(IS_TIM_PERIOD(htim, htim->Init.Period));
  assert_param(IS_TIM_AUTORELOAD_PRELOAD(htim->Init.AutoReloadPreload));

  if (htim->State == HAL_TIM_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    htim->Lock = HAL_UNLOCKED;

#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
    /* Reset interrupt callbacks to legacy weak callbacks */
    TIM_ResetCallback(htim);

    if (htim->OC_MspInitCallback == NULL)
    {
      htim->OC_MspInitCallback = HAL_TIM_OC_MspInit;
    }
    /* Init the low level hardware : GPIO, CLOCK, NVIC */
    htim->OC_MspInitCallback(htim);
#else
    /* Init the low level hardware : GPIO, CLOCK, NVIC and DMA */
    HAL_TIM_OC_MspInit(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
  }

  /* Set the TIM state */
  htim->State = HAL_TIM_STATE_BUSY;

  /* Init the base time for the Output Compare */
  TIM_Base_SetConfig(htim->Instance,  &htim->Init);

  /* Initialize the DMA burst operation state */
  htim->DMABurstState = HAL_DMA_BURST_STATE_READY;

  /* Initialize the TIM channels state */
  TIM_CHANNEL_STATE_SET_ALL(htim, HAL_TIM_CHANNEL_STATE_READY);
  TIM_CHANNEL_N_STATE_SET_ALL(htim, HAL_TIM_CHANNEL_STATE_READY);

  /* Initialize the TIM state*/
  htim->State = HAL_TIM_STATE_READY;

  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OC_DeInit(TIM_HandleTypeDef *htim)
{
  /* Check the parameters */
  assert_param(IS_TIM_INSTANCE(htim->Instance));

  htim->State = HAL_TIM_STATE_BUSY;

  /* Disable the TIM Peripheral Clock */
  __HAL_TIM_DISABLE(htim);

#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
  if (htim->OC_MspDeInitCallback == NULL)
  {
    htim->OC_MspDeInitCallback = HAL_TIM_OC_MspDeInit;
  }
  /* DeInit the low level hardware */
  htim->OC_MspDeInitCallback(htim);
#else
  /* DeInit the low level hardware: GPIO, CLOCK, NVIC and DMA */
  HAL_TIM_OC_MspDeInit(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */

  /* Change the DMA burst operation state */
  htim->DMABurstState = HAL_DMA_BURST_STATE_RESET;

  /* Change the TIM channels state */
  TIM_CHANNEL_STATE_SET_ALL(htim, HAL_TIM_CHANNEL_STATE_RESET);
  TIM_CHANNEL_N_STATE_SET_ALL(htim, HAL_TIM_CHANNEL_STATE_RESET);

  /* Change TIM state */
  htim->State = HAL_TIM_STATE_RESET;

  /* Release Lock */
  __HAL_UNLOCK(htim);

  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OC_Start(TIM_HandleTypeDef *htim, uint32_t Channel)
{
  uint32_t tmpsmcr;

  /* Check the parameters */
  assert_param(IS_TIM_CCX_INSTANCE(htim->Instance, Channel));

  /* Check the TIM channel state */
  if (TIM_CHANNEL_STATE_GET(htim, Channel) != HAL_TIM_CHANNEL_STATE_READY)
  {
    return HAL_ERROR;
  }

  /* Set the TIM channel state */
  TIM_CHANNEL_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_BUSY);

  /* Enable the Output compare channel */
  TIM_CCxChannelCmd(htim->Instance, Channel, TIM_CCx_ENABLE);

  if (IS_TIM_BREAK_INSTANCE(htim->Instance) != RESET)
  {
    /* Enable the main output */
    __HAL_TIM_MOE_ENABLE(htim);
  }

  /* Enable the Peripheral, except in trigger mode where enable is automatically done with trigger */
  if (IS_TIM_SLAVE_INSTANCE(htim->Instance))
  {
    tmpsmcr = htim->Instance->SMCR & TIM_SMCR_SMS;
    if (!IS_TIM_SLAVEMODE_TRIGGER_ENABLED(tmpsmcr))
    {
      __HAL_TIM_ENABLE(htim);
    }
  }
  else
  {
    __HAL_TIM_ENABLE(htim);
  }

  /* Return function status */
  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OC_Stop(TIM_HandleTypeDef *htim, uint32_t Channel)
{
  /* Check the parameters */
  assert_param(IS_TIM_CCX_INSTANCE(htim->Instance, Channel));

  /* Disable the Output compare channel */
  TIM_CCxChannelCmd(htim->Instance, Channel, TIM_CCx_DISABLE);

  if (IS_TIM_BREAK_INSTANCE(htim->Instance) != RESET)
  {
    /* Disable the Main Output */
    __HAL_TIM_MOE_DISABLE(htim);
  }

  /* Disable the Peripheral */
  __HAL_TIM_DISABLE(htim);

  /* Set the TIM channel state */
  TIM_CHANNEL_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_READY);

  /* Return function status */
  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OC_Start_IT(TIM_HandleTypeDef *htim, uint32_t Channel)
{
  HAL_StatusTypeDef status = HAL_OK;
  uint32_t tmpsmcr;

  /* Check the parameters */
  assert_param(IS_TIM_CCX_CHANNEL(htim->Instance, Channel));

  /* Check the TIM channel state */
  if (TIM_CHANNEL_STATE_GET(htim, Channel) != HAL_TIM_CHANNEL_STATE_READY)
  {
    return HAL_ERROR;
  }

  /* Set the TIM channel state */
  TIM_CHANNEL_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_BUSY);

  switch (Channel)
  {
    case TIM_CHANNEL_1:
    {
      /* Enable the TIM Capture/Compare 1 interrupt */
      __HAL_TIM_ENABLE_IT(htim, TIM_IT_CC1);
      break;
    }

    case TIM_CHANNEL_2:
    {
      /* Enable the TIM Capture/Compare 2 interrupt */
      __HAL_TIM_ENABLE_IT(htim, TIM_IT_CC2);
      break;
    }

    case TIM_CHANNEL_3:
    {
      /* Enable the TIM Capture/Compare 3 interrupt */
      __HAL_TIM_ENABLE_IT(htim, TIM_IT_CC3);
      break;
    }

    case TIM_CHANNEL_4:
    {
      /* Enable the TIM Capture/Compare 4 interrupt */
      __HAL_TIM_ENABLE_IT(htim, TIM_IT_CC4);
      break;
    }

    default:
      status = HAL_ERROR;
      break;
  }

  if (status == HAL_OK)
  {
    /* Enable the Output compare channel */
    TIM_CCxChannelCmd(htim->Instance, Channel, TIM_CCx_ENABLE);

    if (IS_TIM_BREAK_INSTANCE(htim->Instance) != RESET)
    {
      /* Enable the main output */
      __HAL_TIM_MOE_ENABLE(htim);
    }

    /* Enable the Peripheral, except in trigger mode where enable is automatically done with trigger */
    if (IS_TIM_SLAVE_INSTANCE(htim->Instance))
    {
      tmpsmcr = htim->Instance->SMCR & TIM_SMCR_SMS;
      if (!IS_TIM_SLAVEMODE_TRIGGER_ENABLED(tmpsmcr))
      {
        __HAL_TIM_ENABLE(htim);
      }
    }
    else
    {
      __HAL_TIM_ENABLE(htim);
    }
  }

  /* Return function status */
  return status;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OC_Stop_IT(TIM_HandleTypeDef *htim, uint32_t Channel)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the parameters */
  assert_param(IS_TIM_CCX_CHANNEL(htim->Instance, Channel));

  switch (Channel)
  {
    case TIM_CHANNEL_1:
    {
      /* Disable the TIM Capture/Compare 1 interrupt */
      __HAL_TIM_DISABLE_IT(htim, TIM_IT_CC1);
      break;
    }

    case TIM_CHANNEL_2:
    {
      /* Disable the TIM Capture/Compare 2 interrupt */
      __HAL_TIM_DISABLE_IT(htim, TIM_IT_CC2);
      break;
    }

    case TIM_CHANNEL_3:
    {
      /* Disable the TIM Capture/Compare 3 interrupt */
      __HAL_TIM_DISABLE_IT(htim, TIM_IT_CC3);
      break;
    }

    case TIM_CHANNEL_4:
    {
      /* Disable the TIM Capture/Compare 4 interrupt */
      __HAL_TIM_DISABLE_IT(htim, TIM_IT_CC4);
      break;
    }

    default:
      status = HAL_ERROR;
      break;
  }

  if (status == HAL_OK)
  {
    /* Disable the Output compare channel */
    TIM_CCxChannelCmd(htim->Instance, Channel, TIM_CCx_DISABLE);

    if (IS_TIM_BREAK_INSTANCE(htim->Instance) != RESET)
    {
      /* Disable the Main Output */
      __HAL_TIM_MOE_DISABLE(htim);
    }

    /* Disable the Peripheral */
    __HAL_TIM_DISABLE(htim);

    /* Set the TIM channel state */
    TIM_CHANNEL_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_READY);
  }

  /* Return function status */
  return status;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OC_Start_DMA(TIM_HandleTypeDef *htim, uint32_t Channel, const uint32_t *pData,
                                       uint16_t Length)
{
  HAL_StatusTypeDef status = HAL_OK;
  uint32_t tmpsmcr;

  /* Check the parameters */
  assert_param(IS_TIM_CCX_CHANNEL(htim->Instance, Channel));

  /* Set the TIM channel state */
  if (TIM_CHANNEL_STATE_GET(htim, Channel) == HAL_TIM_CHANNEL_STATE_BUSY)
  {
    return HAL_BUSY;
  }
  else if (TIM_CHANNEL_STATE_GET(htim, Channel) == HAL_TIM_CHANNEL_STATE_READY)
  {
    if ((pData == NULL) || (Length == 0U))
    {
      return HAL_ERROR;
    }
    else
    {
      TIM_CHANNEL_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_BUSY);
    }
  }
  else
  {
    return HAL_ERROR;
  }

  switch (Channel)
  {
    case TIM_CHANNEL_1:
    {
      /* Set the DMA compare callbacks */
      htim->hdma[TIM_DMA_ID_CC1]->XferCpltCallback = TIM_DMADelayPulseCplt;
      htim->hdma[TIM_DMA_ID_CC1]->XferHalfCpltCallback = TIM_DMADelayPulseHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_CC1]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_CC1], (uint32_t)pData, (uint32_t)&htim->Instance->CCR1,
                           Length) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }

      /* Enable the TIM Capture/Compare 1 DMA request */
      __HAL_TIM_ENABLE_DMA(htim, TIM_DMA_CC1);
      break;
    }

    case TIM_CHANNEL_2:
    {
      /* Set the DMA compare callbacks */
      htim->hdma[TIM_DMA_ID_CC2]->XferCpltCallback = TIM_DMADelayPulseCplt;
      htim->hdma[TIM_DMA_ID_CC2]->XferHalfCpltCallback = TIM_DMADelayPulseHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_CC2]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_CC2], (uint32_t)pData, (uint32_t)&htim->Instance->CCR2,
                           Length) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }

      /* Enable the TIM Capture/Compare 2 DMA request */
      __HAL_TIM_ENABLE_DMA(htim, TIM_DMA_CC2);
      break;
    }

    case TIM_CHANNEL_3:
    {
      /* Set the DMA compare callbacks */
      htim->hdma[TIM_DMA_ID_CC3]->XferCpltCallback = TIM_DMADelayPulseCplt;
      htim->hdma[TIM_DMA_ID_CC3]->XferHalfCpltCallback = TIM_DMADelayPulseHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_CC3]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_CC3], (uint32_t)pData, (uint32_t)&htim->Instance->CCR3,
                           Length) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      /* Enable the TIM Capture/Compare 3 DMA request */
      __HAL_TIM_ENABLE_DMA(htim, TIM_DMA_CC3);
      break;
    }

    case TIM_CHANNEL_4:
    {
      /* Set the DMA compare callbacks */
      htim->hdma[TIM_DMA_ID_CC4]->XferCpltCallback = TIM_DMADelayPulseCplt;
      htim->hdma[TIM_DMA_ID_CC4]->XferHalfCpltCallback = TIM_DMADelayPulseHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_CC4]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_CC4], (uint32_t)pData, (uint32_t)&htim->Instance->CCR4,
                           Length) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      /* Enable the TIM Capture/Compare 4 DMA request */
      __HAL_TIM_ENABLE_DMA(htim, TIM_DMA_CC4);
      break;
    }

    default:
      status = HAL_ERROR;
      break;
  }

  if (status == HAL_OK)
  {
    /* Enable the Output compare channel */
    TIM_CCxChannelCmd(htim->Instance, Channel, TIM_CCx_ENABLE);

    if (IS_TIM_BREAK_INSTANCE(htim->Instance) != RESET)
    {
      /* Enable the main output */
      __HAL_TIM_MOE_ENABLE(htim);
    }

    /* Enable the Peripheral, except in trigger mode where enable is automatically done with trigger */
    if (IS_TIM_SLAVE_INSTANCE(htim->Instance))
    {
      tmpsmcr = htim->Instance->SMCR & TIM_SMCR_SMS;
      if (!IS_TIM_SLAVEMODE_TRIGGER_ENABLED(tmpsmcr))
      {
        __HAL_TIM_ENABLE(htim);
      }
    }
    else
    {
      __HAL_TIM_ENABLE(htim);
    }
  }

  /* Return function status */
  return status;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OC_Stop_DMA(TIM_HandleTypeDef *htim, uint32_t Channel)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the parameters */
  assert_param(IS_TIM_CCX_CHANNEL(htim->Instance, Channel));

  switch (Channel)
  {
    case TIM_CHANNEL_1:
    {
      /* Disable the TIM Capture/Compare 1 DMA request */
      __HAL_TIM_DISABLE_DMA(htim, TIM_DMA_CC1);
      (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_CC1]);
      break;
    }

    case TIM_CHANNEL_2:
    {
      /* Disable the TIM Capture/Compare 2 DMA request */
      __HAL_TIM_DISABLE_DMA(htim, TIM_DMA_CC2);
      (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_CC2]);
      break;
    }

    case TIM_CHANNEL_3:
    {
      /* Disable the TIM Capture/Compare 3 DMA request */
      __HAL_TIM_DISABLE_DMA(htim, TIM_DMA_CC3);
      (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_CC3]);
      break;
    }

    case TIM_CHANNEL_4:
    {
      /* Disable the TIM Capture/Compare 4 interrupt */
      __HAL_TIM_DISABLE_DMA(htim, TIM_DMA_CC4);
      (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_CC4]);
      break;
    }

    default:
      status = HAL_ERROR;
      break;
  }

  if (status == HAL_OK)
  {
    /* Disable the Output compare channel */
    TIM_CCxChannelCmd(htim->Instance, Channel, TIM_CCx_DISABLE);

    if (IS_TIM_BREAK_INSTANCE(htim->Instance) != RESET)
    {
      /* Disable the Main Output */
      __HAL_TIM_MOE_DISABLE(htim);
    }

    /* Disable the Peripheral */
    __HAL_TIM_DISABLE(htim);

    /* Set the TIM channel state */
    TIM_CHANNEL_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_READY);
  }

  /* Return function status */
  return status;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_PWM_Init(TIM_HandleTypeDef *htim)
{
  /* Check the TIM handle allocation */
  if (htim == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_TIM_INSTANCE(htim->Instance));
  assert_param(IS_TIM_COUNTER_MODE(htim->Init.CounterMode));
  assert_param(IS_TIM_CLOCKDIVISION_DIV(htim->Init.ClockDivision));
  assert_param(IS_TIM_PERIOD(htim, htim->Init.Period));
  assert_param(IS_TIM_AUTORELOAD_PRELOAD(htim->Init.AutoReloadPreload));

  if (htim->State == HAL_TIM_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    htim->Lock = HAL_UNLOCKED;

#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
    /* Reset interrupt callbacks to legacy weak callbacks */
    TIM_ResetCallback(htim);

    if (htim->PWM_MspInitCallback == NULL)
    {
      htim->PWM_MspInitCallback = HAL_TIM_PWM_MspInit;
    }
    /* Init the low level hardware : GPIO, CLOCK, NVIC */
    htim->PWM_MspInitCallback(htim);
#else
    /* Init the low level hardware : GPIO, CLOCK, NVIC and DMA */
    HAL_TIM_PWM_MspInit(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
  }

  /* Set the TIM state */
  htim->State = HAL_TIM_STATE_BUSY;

  /* Init the base time for the PWM */
  TIM_Base_SetConfig(htim->Instance, &htim->Init);

  /* Initialize the DMA burst operation state */
  htim->DMABurstState = HAL_DMA_BURST_STATE_READY;

  /* Initialize the TIM channels state */
  TIM_CHANNEL_STATE_SET_ALL(htim, HAL_TIM_CHANNEL_STATE_READY);
  TIM_CHANNEL_N_STATE_SET_ALL(htim, HAL_TIM_CHANNEL_STATE_READY);

  /* Initialize the TIM state*/
  htim->State = HAL_TIM_STATE_READY;

  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_PWM_DeInit(TIM_HandleTypeDef *htim)
{
  /* Check the parameters */
  assert_param(IS_TIM_INSTANCE(htim->Instance));

  htim->State = HAL_TIM_STATE_BUSY;

  /* Disable the TIM Peripheral Clock */
  __HAL_TIM_DISABLE(htim);

#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
  if (htim->PWM_MspDeInitCallback == NULL)
  {
    htim->PWM_MspDeInitCallback = HAL_TIM_PWM_MspDeInit;
  }
  /* DeInit the low level hardware */
  htim->PWM_MspDeInitCallback(htim);
#else
  /* DeInit the low level hardware: GPIO, CLOCK, NVIC and DMA */
  HAL_TIM_PWM_MspDeInit(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */

  /* Change the DMA burst operation state */
  htim->DMABurstState = HAL_DMA_BURST_STATE_RESET;

  /* Change the TIM channels state */
  TIM_CHANNEL_STATE_SET_ALL(htim, HAL_TIM_CHANNEL_STATE_RESET);
  TIM_CHANNEL_N_STATE_SET_ALL(htim, HAL_TIM_CHANNEL_STATE_RESET);

  /* Change TIM state */
  htim->State = HAL_TIM_STATE_RESET;

  /* Release Lock */
  __HAL_UNLOCK(htim);

  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_PWM_Start(TIM_HandleTypeDef *htim, uint32_t Channel)
{
  uint32_t tmpsmcr;

  /* Check the parameters */
  assert_param(IS_TIM_CCX_INSTANCE(htim->Instance, Channel));

  /* Check the TIM channel state */
  if (TIM_CHANNEL_STATE_GET(htim, Channel) != HAL_TIM_CHANNEL_STATE_READY)
  {
    return HAL_ERROR;
  }

  /* Set the TIM channel state */
  TIM_CHANNEL_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_BUSY);

  /* Enable the Capture compare channel */
  TIM_CCxChannelCmd(htim->Instance, Channel, TIM_CCx_ENABLE);

  if (IS_TIM_BREAK_INSTANCE(htim->Instance) != RESET)
  {
    /* Enable the main output */
    __HAL_TIM_MOE_ENABLE(htim);
  }

  /* Enable the Peripheral, except in trigger mode where enable is automatically done with trigger */
  if (IS_TIM_SLAVE_INSTANCE(htim->Instance))
  {
    tmpsmcr = htim->Instance->SMCR & TIM_SMCR_SMS;
    if (!IS_TIM_SLAVEMODE_TRIGGER_ENABLED(tmpsmcr))
    {
      __HAL_TIM_ENABLE(htim);
    }
  }
  else
  {
    __HAL_TIM_ENABLE(htim);
  }

  /* Return function status */
  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_PWM_Stop(TIM_HandleTypeDef *htim, uint32_t Channel)
{
  /* Check the parameters */
  assert_param(IS_TIM_CCX_INSTANCE(htim->Instance, Channel));

  /* Disable the Capture compare channel */
  TIM_CCxChannelCmd(htim->Instance, Channel, TIM_CCx_DISABLE);

  if (IS_TIM_BREAK_INSTANCE(htim->Instance) != RESET)
  {
    /* Disable the Main Output */
    __HAL_TIM_MOE_DISABLE(htim);
  }

  /* Disable the Peripheral */
  __HAL_TIM_DISABLE(htim);

  /* Set the TIM channel state */
  TIM_CHANNEL_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_READY);

  /* Return function status */
  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_PWM_Start_IT(TIM_HandleTypeDef *htim, uint32_t Channel)
{
  HAL_StatusTypeDef status = HAL_OK;
  uint32_t tmpsmcr;

  /* Check the parameters */
  assert_param(IS_TIM_CCX_CHANNEL(htim->Instance, Channel));

  /* Check the TIM channel state */
  if (TIM_CHANNEL_STATE_GET(htim, Channel) != HAL_TIM_CHANNEL_STATE_READY)
  {
    return HAL_ERROR;
  }

  /* Set the TIM channel state */
  TIM_CHANNEL_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_BUSY);

  switch (Channel)
  {
    case TIM_CHANNEL_1:
    {
      /* Enable the TIM Capture/Compare 1 interrupt */
      __HAL_TIM_ENABLE_IT(htim, TIM_IT_CC1);
      break;
    }

    case TIM_CHANNEL_2:
    {
      /* Enable the TIM Capture/Compare 2 interrupt */
      __HAL_TIM_ENABLE_IT(htim, TIM_IT_CC2);
      break;
    }

    case TIM_CHANNEL_3:
    {
      /* Enable the TIM Capture/Compare 3 interrupt */
      __HAL_TIM_ENABLE_IT(htim, TIM_IT_CC3);
      break;
    }

    case TIM_CHANNEL_4:
    {
      /* Enable the TIM Capture/Compare 4 interrupt */
      __HAL_TIM_ENABLE_IT(htim, TIM_IT_CC4);
      break;
    }

    default:
      status = HAL_ERROR;
      break;
  }

  if (status == HAL_OK)
  {
    /* Enable the Capture compare channel */
    TIM_CCxChannelCmd(htim->Instance, Channel, TIM_CCx_ENABLE);

    if (IS_TIM_BREAK_INSTANCE(htim->Instance) != RESET)
    {
      /* Enable the main output */
      __HAL_TIM_MOE_ENABLE(htim);
    }

    /* Enable the Peripheral, except in trigger mode where enable is automatically done with trigger */
    if (IS_TIM_SLAVE_INSTANCE(htim->Instance))
    {
      tmpsmcr = htim->Instance->SMCR & TIM_SMCR_SMS;
      if (!IS_TIM_SLAVEMODE_TRIGGER_ENABLED(tmpsmcr))
      {
        __HAL_TIM_ENABLE(htim);
      }
    }
    else
    {
      __HAL_TIM_ENABLE(htim);
    }
  }

  /* Return function status */
  return status;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_PWM_Stop_IT(TIM_HandleTypeDef *htim, uint32_t Channel)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the parameters */
  assert_param(IS_TIM_CCX_CHANNEL(htim->Instance, Channel));

  switch (Channel)
  {
    case TIM_CHANNEL_1:
    {
      /* Disable the TIM Capture/Compare 1 interrupt */
      __HAL_TIM_DISABLE_IT(htim, TIM_IT_CC1);
      break;
    }

    case TIM_CHANNEL_2:
    {
      /* Disable the TIM Capture/Compare 2 interrupt */
      __HAL_TIM_DISABLE_IT(htim, TIM_IT_CC2);
      break;
    }

    case TIM_CHANNEL_3:
    {
      /* Disable the TIM Capture/Compare 3 interrupt */
      __HAL_TIM_DISABLE_IT(htim, TIM_IT_CC3);
      break;
    }

    case TIM_CHANNEL_4:
    {
      /* Disable the TIM Capture/Compare 4 interrupt */
      __HAL_TIM_DISABLE_IT(htim, TIM_IT_CC4);
      break;
    }

    default:
      status = HAL_ERROR;
      break;
  }

  if (status == HAL_OK)
  {
    /* Disable the Capture compare channel */
    TIM_CCxChannelCmd(htim->Instance, Channel, TIM_CCx_DISABLE);

    if (IS_TIM_BREAK_INSTANCE(htim->Instance) != RESET)
    {
      /* Disable the Main Output */
      __HAL_TIM_MOE_DISABLE(htim);
    }

    /* Disable the Peripheral */
    __HAL_TIM_DISABLE(htim);

    /* Set the TIM channel state */
    TIM_CHANNEL_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_READY);
  }

  /* Return function status */
  return status;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_PWM_Start_DMA(TIM_HandleTypeDef *htim, uint32_t Channel, const uint32_t *pData,
                                        uint16_t Length)
{
  HAL_StatusTypeDef status = HAL_OK;
  uint32_t tmpsmcr;

  /* Check the parameters */
  assert_param(IS_TIM_CCX_CHANNEL(htim->Instance, Channel));

  /* Set the TIM channel state */
  if (TIM_CHANNEL_STATE_GET(htim, Channel) == HAL_TIM_CHANNEL_STATE_BUSY)
  {
    return HAL_BUSY;
  }
  else if (TIM_CHANNEL_STATE_GET(htim, Channel) == HAL_TIM_CHANNEL_STATE_READY)
  {
    if ((pData == NULL) || (Length == 0U))
    {
      return HAL_ERROR;
    }
    else
    {
      TIM_CHANNEL_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_BUSY);
    }
  }
  else
  {
    return HAL_ERROR;
  }

  switch (Channel)
  {
    case TIM_CHANNEL_1:
    {
      /* Set the DMA compare callbacks */
      htim->hdma[TIM_DMA_ID_CC1]->XferCpltCallback = TIM_DMADelayPulseCplt;
      htim->hdma[TIM_DMA_ID_CC1]->XferHalfCpltCallback = TIM_DMADelayPulseHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_CC1]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_CC1], (uint32_t)pData, (uint32_t)&htim->Instance->CCR1,
                           Length) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }

      /* Enable the TIM Capture/Compare 1 DMA request */
      __HAL_TIM_ENABLE_DMA(htim, TIM_DMA_CC1);
      break;
    }

    case TIM_CHANNEL_2:
    {
      /* Set the DMA compare callbacks */
      htim->hdma[TIM_DMA_ID_CC2]->XferCpltCallback = TIM_DMADelayPulseCplt;
      htim->hdma[TIM_DMA_ID_CC2]->XferHalfCpltCallback = TIM_DMADelayPulseHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_CC2]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_CC2], (uint32_t)pData, (uint32_t)&htim->Instance->CCR2,
                           Length) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      /* Enable the TIM Capture/Compare 2 DMA request */
      __HAL_TIM_ENABLE_DMA(htim, TIM_DMA_CC2);
      break;
    }

    case TIM_CHANNEL_3:
    {
      /* Set the DMA compare callbacks */
      htim->hdma[TIM_DMA_ID_CC3]->XferCpltCallback = TIM_DMADelayPulseCplt;
      htim->hdma[TIM_DMA_ID_CC3]->XferHalfCpltCallback = TIM_DMADelayPulseHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_CC3]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_CC3], (uint32_t)pData, (uint32_t)&htim->Instance->CCR3,
                           Length) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      /* Enable the TIM Output Capture/Compare 3 request */
      __HAL_TIM_ENABLE_DMA(htim, TIM_DMA_CC3);
      break;
    }

    case TIM_CHANNEL_4:
    {
      /* Set the DMA compare callbacks */
      htim->hdma[TIM_DMA_ID_CC4]->XferCpltCallback = TIM_DMADelayPulseCplt;
      htim->hdma[TIM_DMA_ID_CC4]->XferHalfCpltCallback = TIM_DMADelayPulseHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_CC4]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_CC4], (uint32_t)pData, (uint32_t)&htim->Instance->CCR4,
                           Length) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      /* Enable the TIM Capture/Compare 4 DMA request */
      __HAL_TIM_ENABLE_DMA(htim, TIM_DMA_CC4);
      break;
    }

    default:
      status = HAL_ERROR;
      break;
  }

  if (status == HAL_OK)
  {
    /* Enable the Capture compare channel */
    TIM_CCxChannelCmd(htim->Instance, Channel, TIM_CCx_ENABLE);

    if (IS_TIM_BREAK_INSTANCE(htim->Instance) != RESET)
    {
      /* Enable the main output */
      __HAL_TIM_MOE_ENABLE(htim);
    }

    /* Enable the Peripheral, except in trigger mode where enable is automatically done with trigger */
    if (IS_TIM_SLAVE_INSTANCE(htim->Instance))
    {
      tmpsmcr = htim->Instance->SMCR & TIM_SMCR_SMS;
      if (!IS_TIM_SLAVEMODE_TRIGGER_ENABLED(tmpsmcr))
      {
        __HAL_TIM_ENABLE(htim);
      }
    }
    else
    {
      __HAL_TIM_ENABLE(htim);
    }
  }

  /* Return function status */
  return status;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_PWM_Stop_DMA(TIM_HandleTypeDef *htim, uint32_t Channel)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the parameters */
  assert_param(IS_TIM_CCX_CHANNEL(htim->Instance, Channel));

  switch (Channel)
  {
    case TIM_CHANNEL_1:
    {
      /* Disable the TIM Capture/Compare 1 DMA request */
      __HAL_TIM_DISABLE_DMA(htim, TIM_DMA_CC1);
      (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_CC1]);
      break;
    }

    case TIM_CHANNEL_2:
    {
      /* Disable the TIM Capture/Compare 2 DMA request */
      __HAL_TIM_DISABLE_DMA(htim, TIM_DMA_CC2);
      (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_CC2]);
      break;
    }

    case TIM_CHANNEL_3:
    {
      /* Disable the TIM Capture/Compare 3 DMA request */
      __HAL_TIM_DISABLE_DMA(htim, TIM_DMA_CC3);
      (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_CC3]);
      break;
    }

    case TIM_CHANNEL_4:
    {
      /* Disable the TIM Capture/Compare 4 interrupt */
      __HAL_TIM_DISABLE_DMA(htim, TIM_DMA_CC4);
      (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_CC4]);
      break;
    }

    default:
      status = HAL_ERROR;
      break;
  }

  if (status == HAL_OK)
  {
    /* Disable the Capture compare channel */
    TIM_CCxChannelCmd(htim->Instance, Channel, TIM_CCx_DISABLE);

    if (IS_TIM_BREAK_INSTANCE(htim->Instance) != RESET)
    {
      /* Disable the Main Output */
      __HAL_TIM_MOE_DISABLE(htim);
    }

    /* Disable the Peripheral */
    __HAL_TIM_DISABLE(htim);

    /* Set the TIM channel state */
    TIM_CHANNEL_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_READY);
  }

  /* Return function status */
  return status;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_IC_Init(TIM_HandleTypeDef *htim)
{
  /* Check the TIM handle allocation */
  if (htim == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_TIM_INSTANCE(htim->Instance));
  assert_param(IS_TIM_COUNTER_MODE(htim->Init.CounterMode));
  assert_param(IS_TIM_CLOCKDIVISION_DIV(htim->Init.ClockDivision));
  assert_param(IS_TIM_PERIOD(htim, htim->Init.Period));
  assert_param(IS_TIM_AUTORELOAD_PRELOAD(htim->Init.AutoReloadPreload));

  if (htim->State == HAL_TIM_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    htim->Lock = HAL_UNLOCKED;

#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
    /* Reset interrupt callbacks to legacy weak callbacks */
    TIM_ResetCallback(htim);

    if (htim->IC_MspInitCallback == NULL)
    {
      htim->IC_MspInitCallback = HAL_TIM_IC_MspInit;
    }
    /* Init the low level hardware : GPIO, CLOCK, NVIC */
    htim->IC_MspInitCallback(htim);
#else
    /* Init the low level hardware : GPIO, CLOCK, NVIC and DMA */
    HAL_TIM_IC_MspInit(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
  }

  /* Set the TIM state */
  htim->State = HAL_TIM_STATE_BUSY;

  /* Init the base time for the input capture */
  TIM_Base_SetConfig(htim->Instance, &htim->Init);

  /* Initialize the DMA burst operation state */
  htim->DMABurstState = HAL_DMA_BURST_STATE_READY;

  /* Initialize the TIM channels state */
  TIM_CHANNEL_STATE_SET_ALL(htim, HAL_TIM_CHANNEL_STATE_READY);
  TIM_CHANNEL_N_STATE_SET_ALL(htim, HAL_TIM_CHANNEL_STATE_READY);

  /* Initialize the TIM state*/
  htim->State = HAL_TIM_STATE_READY;

  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_IC_DeInit(TIM_HandleTypeDef *htim)
{
  /* Check the parameters */
  assert_param(IS_TIM_INSTANCE(htim->Instance));

  htim->State = HAL_TIM_STATE_BUSY;

  /* Disable the TIM Peripheral Clock */
  __HAL_TIM_DISABLE(htim);

#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
  if (htim->IC_MspDeInitCallback == NULL)
  {
    htim->IC_MspDeInitCallback = HAL_TIM_IC_MspDeInit;
  }
  /* DeInit the low level hardware */
  htim->IC_MspDeInitCallback(htim);
#else
  /* DeInit the low level hardware: GPIO, CLOCK, NVIC and DMA */
  HAL_TIM_IC_MspDeInit(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */

  /* Change the DMA burst operation state */
  htim->DMABurstState = HAL_DMA_BURST_STATE_RESET;

  /* Change the TIM channels state */
  TIM_CHANNEL_STATE_SET_ALL(htim, HAL_TIM_CHANNEL_STATE_RESET);
  TIM_CHANNEL_N_STATE_SET_ALL(htim, HAL_TIM_CHANNEL_STATE_RESET);

  /* Change TIM state */
  htim->State = HAL_TIM_STATE_RESET;

  /* Release Lock */
  __HAL_UNLOCK(htim);

  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_IC_Start(TIM_HandleTypeDef *htim, uint32_t Channel)
{
  uint32_t tmpsmcr;
  HAL_TIM_ChannelStateTypeDef channel_state = TIM_CHANNEL_STATE_GET(htim, Channel);
  HAL_TIM_ChannelStateTypeDef complementary_channel_state = TIM_CHANNEL_N_STATE_GET(htim, Channel);

  /* Check the parameters */
  assert_param(IS_TIM_CCX_CHANNEL(htim->Instance, Channel));

  /* Check the TIM channel state */
  if ((channel_state != HAL_TIM_CHANNEL_STATE_READY)
      || (complementary_channel_state != HAL_TIM_CHANNEL_STATE_READY))
  {
    return HAL_ERROR;
  }

  /* Set the TIM channel state */
  TIM_CHANNEL_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_BUSY);
  TIM_CHANNEL_N_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_BUSY);

  /* Enable the Input Capture channel */
  TIM_CCxChannelCmd(htim->Instance, Channel, TIM_CCx_ENABLE);

  /* Enable the Peripheral, except in trigger mode where enable is automatically done with trigger */
  if (IS_TIM_SLAVE_INSTANCE(htim->Instance))
  {
    tmpsmcr = htim->Instance->SMCR & TIM_SMCR_SMS;
    if (!IS_TIM_SLAVEMODE_TRIGGER_ENABLED(tmpsmcr))
    {
      __HAL_TIM_ENABLE(htim);
    }
  }
  else
  {
    __HAL_TIM_ENABLE(htim);
  }

  /* Return function status */
  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_IC_Stop(TIM_HandleTypeDef *htim, uint32_t Channel)
{
  /* Check the parameters */
  assert_param(IS_TIM_CCX_CHANNEL(htim->Instance, Channel));

  /* Disable the Input Capture channel */
  TIM_CCxChannelCmd(htim->Instance, Channel, TIM_CCx_DISABLE);

  /* Disable the Peripheral */
  __HAL_TIM_DISABLE(htim);

  /* Set the TIM channel state */
  TIM_CHANNEL_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_READY);
  TIM_CHANNEL_N_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_READY);

  /* Return function status */
  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_IC_Start_IT(TIM_HandleTypeDef *htim, uint32_t Channel)
{
  HAL_StatusTypeDef status = HAL_OK;
  uint32_t tmpsmcr;

  HAL_TIM_ChannelStateTypeDef channel_state = TIM_CHANNEL_STATE_GET(htim, Channel);
  HAL_TIM_ChannelStateTypeDef complementary_channel_state = TIM_CHANNEL_N_STATE_GET(htim, Channel);

  /* Check the parameters */
  assert_param(IS_TIM_CCX_CHANNEL(htim->Instance, Channel));

  /* Check the TIM channel state */
  if ((channel_state != HAL_TIM_CHANNEL_STATE_READY)
      || (complementary_channel_state != HAL_TIM_CHANNEL_STATE_READY))
  {
    return HAL_ERROR;
  }

  /* Set the TIM channel state */
  TIM_CHANNEL_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_BUSY);
  TIM_CHANNEL_N_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_BUSY);

  switch (Channel)
  {
    case TIM_CHANNEL_1:
    {
      /* Enable the TIM Capture/Compare 1 interrupt */
      __HAL_TIM_ENABLE_IT(htim, TIM_IT_CC1);
      break;
    }

    case TIM_CHANNEL_2:
    {
      /* Enable the TIM Capture/Compare 2 interrupt */
      __HAL_TIM_ENABLE_IT(htim, TIM_IT_CC2);
      break;
    }

    case TIM_CHANNEL_3:
    {
      /* Enable the TIM Capture/Compare 3 interrupt */
      __HAL_TIM_ENABLE_IT(htim, TIM_IT_CC3);
      break;
    }

    case TIM_CHANNEL_4:
    {
      /* Enable the TIM Capture/Compare 4 interrupt */
      __HAL_TIM_ENABLE_IT(htim, TIM_IT_CC4);
      break;
    }

    default:
      status = HAL_ERROR;
      break;
  }

  if (status == HAL_OK)
  {
    /* Enable the Input Capture channel */
    TIM_CCxChannelCmd(htim->Instance, Channel, TIM_CCx_ENABLE);

    /* Enable the Peripheral, except in trigger mode where enable is automatically done with trigger */
    if (IS_TIM_SLAVE_INSTANCE(htim->Instance))
    {
      tmpsmcr = htim->Instance->SMCR & TIM_SMCR_SMS;
      if (!IS_TIM_SLAVEMODE_TRIGGER_ENABLED(tmpsmcr))
      {
        __HAL_TIM_ENABLE(htim);
      }
    }
    else
    {
      __HAL_TIM_ENABLE(htim);
    }
  }

  /* Return function status */
  return status;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_IC_Stop_IT(TIM_HandleTypeDef *htim, uint32_t Channel)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the parameters */
  assert_param(IS_TIM_CCX_CHANNEL(htim->Instance, Channel));

  switch (Channel)
  {
    case TIM_CHANNEL_1:
    {
      /* Disable the TIM Capture/Compare 1 interrupt */
      __HAL_TIM_DISABLE_IT(htim, TIM_IT_CC1);
      break;
    }

    case TIM_CHANNEL_2:
    {
      /* Disable the TIM Capture/Compare 2 interrupt */
      __HAL_TIM_DISABLE_IT(htim, TIM_IT_CC2);
      break;
    }

    case TIM_CHANNEL_3:
    {
      /* Disable the TIM Capture/Compare 3 interrupt */
      __HAL_TIM_DISABLE_IT(htim, TIM_IT_CC3);
      break;
    }

    case TIM_CHANNEL_4:
    {
      /* Disable the TIM Capture/Compare 4 interrupt */
      __HAL_TIM_DISABLE_IT(htim, TIM_IT_CC4);
      break;
    }

    default:
      status = HAL_ERROR;
      break;
  }

  if (status == HAL_OK)
  {
    /* Disable the Input Capture channel */
    TIM_CCxChannelCmd(htim->Instance, Channel, TIM_CCx_DISABLE);

    /* Disable the Peripheral */
    __HAL_TIM_DISABLE(htim);

    /* Set the TIM channel state */
    TIM_CHANNEL_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_READY);
    TIM_CHANNEL_N_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_READY);
  }

  /* Return function status */
  return status;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_IC_Start_DMA(TIM_HandleTypeDef *htim, uint32_t Channel, uint32_t *pData, uint16_t Length)
{
  HAL_StatusTypeDef status = HAL_OK;
  uint32_t tmpsmcr;

  HAL_TIM_ChannelStateTypeDef channel_state = TIM_CHANNEL_STATE_GET(htim, Channel);
  HAL_TIM_ChannelStateTypeDef complementary_channel_state = TIM_CHANNEL_N_STATE_GET(htim, Channel);

  /* Check the parameters */
  assert_param(IS_TIM_CCX_CHANNEL(htim->Instance, Channel));
  assert_param(IS_TIM_DMA_CC_INSTANCE(htim->Instance));

  /* Set the TIM channel state */
  if ((channel_state == HAL_TIM_CHANNEL_STATE_BUSY)
      || (complementary_channel_state == HAL_TIM_CHANNEL_STATE_BUSY))
  {
    return HAL_BUSY;
  }
  else if ((channel_state == HAL_TIM_CHANNEL_STATE_READY)
           && (complementary_channel_state == HAL_TIM_CHANNEL_STATE_READY))
  {
    if ((pData == NULL) || (Length == 0U))
    {
      return HAL_ERROR;
    }
    else
    {
      TIM_CHANNEL_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_BUSY);
      TIM_CHANNEL_N_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_BUSY);
    }
  }
  else
  {
    return HAL_ERROR;
  }

  /* Enable the Input Capture channel */
  TIM_CCxChannelCmd(htim->Instance, Channel, TIM_CCx_ENABLE);

  switch (Channel)
  {
    case TIM_CHANNEL_1:
    {
      /* Set the DMA capture callbacks */
      htim->hdma[TIM_DMA_ID_CC1]->XferCpltCallback = TIM_DMACaptureCplt;
      htim->hdma[TIM_DMA_ID_CC1]->XferHalfCpltCallback = TIM_DMACaptureHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_CC1]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_CC1], (uint32_t)&htim->Instance->CCR1, (uint32_t)pData,
                           Length) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      /* Enable the TIM Capture/Compare 1 DMA request */
      __HAL_TIM_ENABLE_DMA(htim, TIM_DMA_CC1);
      break;
    }

    case TIM_CHANNEL_2:
    {
      /* Set the DMA capture callbacks */
      htim->hdma[TIM_DMA_ID_CC2]->XferCpltCallback = TIM_DMACaptureCplt;
      htim->hdma[TIM_DMA_ID_CC2]->XferHalfCpltCallback = TIM_DMACaptureHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_CC2]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_CC2], (uint32_t)&htim->Instance->CCR2, (uint32_t)pData,
                           Length) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      /* Enable the TIM Capture/Compare 2  DMA request */
      __HAL_TIM_ENABLE_DMA(htim, TIM_DMA_CC2);
      break;
    }

    case TIM_CHANNEL_3:
    {
      /* Set the DMA capture callbacks */
      htim->hdma[TIM_DMA_ID_CC3]->XferCpltCallback = TIM_DMACaptureCplt;
      htim->hdma[TIM_DMA_ID_CC3]->XferHalfCpltCallback = TIM_DMACaptureHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_CC3]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_CC3], (uint32_t)&htim->Instance->CCR3, (uint32_t)pData,
                           Length) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      /* Enable the TIM Capture/Compare 3  DMA request */
      __HAL_TIM_ENABLE_DMA(htim, TIM_DMA_CC3);
      break;
    }

    case TIM_CHANNEL_4:
    {
      /* Set the DMA capture callbacks */
      htim->hdma[TIM_DMA_ID_CC4]->XferCpltCallback = TIM_DMACaptureCplt;
      htim->hdma[TIM_DMA_ID_CC4]->XferHalfCpltCallback = TIM_DMACaptureHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_CC4]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_CC4], (uint32_t)&htim->Instance->CCR4, (uint32_t)pData,
                           Length) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      /* Enable the TIM Capture/Compare 4  DMA request */
      __HAL_TIM_ENABLE_DMA(htim, TIM_DMA_CC4);
      break;
    }

    default:
      status = HAL_ERROR;
      break;
  }

  /* Enable the Peripheral, except in trigger mode where enable is automatically done with trigger */
  if (IS_TIM_SLAVE_INSTANCE(htim->Instance))
  {
    tmpsmcr = htim->Instance->SMCR & TIM_SMCR_SMS;
    if (!IS_TIM_SLAVEMODE_TRIGGER_ENABLED(tmpsmcr))
    {
      __HAL_TIM_ENABLE(htim);
    }
  }
  else
  {
    __HAL_TIM_ENABLE(htim);
  }

  /* Return function status */
  return status;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_IC_Stop_DMA(TIM_HandleTypeDef *htim, uint32_t Channel)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the parameters */
  assert_param(IS_TIM_CCX_CHANNEL(htim->Instance, Channel));
  assert_param(IS_TIM_DMA_CC_INSTANCE(htim->Instance));

  /* Disable the Input Capture channel */
  TIM_CCxChannelCmd(htim->Instance, Channel, TIM_CCx_DISABLE);

  switch (Channel)
  {
    case TIM_CHANNEL_1:
    {
      /* Disable the TIM Capture/Compare 1 DMA request */
      __HAL_TIM_DISABLE_DMA(htim, TIM_DMA_CC1);
      (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_CC1]);
      break;
    }

    case TIM_CHANNEL_2:
    {
      /* Disable the TIM Capture/Compare 2 DMA request */
      __HAL_TIM_DISABLE_DMA(htim, TIM_DMA_CC2);
      (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_CC2]);
      break;
    }

    case TIM_CHANNEL_3:
    {
      /* Disable the TIM Capture/Compare 3  DMA request */
      __HAL_TIM_DISABLE_DMA(htim, TIM_DMA_CC3);
      (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_CC3]);
      break;
    }

    case TIM_CHANNEL_4:
    {
      /* Disable the TIM Capture/Compare 4  DMA request */
      __HAL_TIM_DISABLE_DMA(htim, TIM_DMA_CC4);
      (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_CC4]);
      break;
    }

    default:
      status = HAL_ERROR;
      break;
  }

  if (status == HAL_OK)
  {
    /* Disable the Peripheral */
    __HAL_TIM_DISABLE(htim);

    /* Set the TIM channel state */
    TIM_CHANNEL_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_READY);
    TIM_CHANNEL_N_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_READY);
  }

  /* Return function status */
  return status;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OnePulse_Init(TIM_HandleTypeDef *htim, uint32_t OnePulseMode)
{
  /* Check the TIM handle allocation */
  if (htim == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_TIM_INSTANCE(htim->Instance));
  assert_param(IS_TIM_COUNTER_MODE(htim->Init.CounterMode));
  assert_param(IS_TIM_CLOCKDIVISION_DIV(htim->Init.ClockDivision));
  assert_param(IS_TIM_OPM_MODE(OnePulseMode));
  assert_param(IS_TIM_PERIOD(htim, htim->Init.Period));
  assert_param(IS_TIM_AUTORELOAD_PRELOAD(htim->Init.AutoReloadPreload));

  if (htim->State == HAL_TIM_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    htim->Lock = HAL_UNLOCKED;

#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
    /* Reset interrupt callbacks to legacy weak callbacks */
    TIM_ResetCallback(htim);

    if (htim->OnePulse_MspInitCallback == NULL)
    {
      htim->OnePulse_MspInitCallback = HAL_TIM_OnePulse_MspInit;
    }
    /* Init the low level hardware : GPIO, CLOCK, NVIC */
    htim->OnePulse_MspInitCallback(htim);
#else
    /* Init the low level hardware : GPIO, CLOCK, NVIC and DMA */
    HAL_TIM_OnePulse_MspInit(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
  }

  /* Set the TIM state */
  htim->State = HAL_TIM_STATE_BUSY;

  /* Configure the Time base in the One Pulse Mode */
  TIM_Base_SetConfig(htim->Instance, &htim->Init);

  /* Reset the OPM Bit */
  htim->Instance->CR1 &= ~TIM_CR1_OPM;

  /* Configure the OPM Mode */
  htim->Instance->CR1 |= OnePulseMode;

  /* Initialize the DMA burst operation state */
  htim->DMABurstState = HAL_DMA_BURST_STATE_READY;

  /* Initialize the TIM channels state */
  TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_READY);
  TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_READY);
  TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_READY);
  TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_READY);

  /* Initialize the TIM state*/
  htim->State = HAL_TIM_STATE_READY;

  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OnePulse_DeInit(TIM_HandleTypeDef *htim)
{
  /* Check the parameters */
  assert_param(IS_TIM_INSTANCE(htim->Instance));

  htim->State = HAL_TIM_STATE_BUSY;

  /* Disable the TIM Peripheral Clock */
  __HAL_TIM_DISABLE(htim);

#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
  if (htim->OnePulse_MspDeInitCallback == NULL)
  {
    htim->OnePulse_MspDeInitCallback = HAL_TIM_OnePulse_MspDeInit;
  }
  /* DeInit the low level hardware */
  htim->OnePulse_MspDeInitCallback(htim);
#else
  /* DeInit the low level hardware: GPIO, CLOCK, NVIC */
  HAL_TIM_OnePulse_MspDeInit(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */

  /* Change the DMA burst operation state */
  htim->DMABurstState = HAL_DMA_BURST_STATE_RESET;

  /* Set the TIM channel state */
  TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_RESET);
  TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_RESET);
  TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_RESET);
  TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_RESET);

  /* Change TIM state */
  htim->State = HAL_TIM_STATE_RESET;

  /* Release Lock */
  __HAL_UNLOCK(htim);

  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OnePulse_Start(TIM_HandleTypeDef *htim, uint32_t OutputChannel)
{
  HAL_TIM_ChannelStateTypeDef channel_1_state = TIM_CHANNEL_STATE_GET(htim, TIM_CHANNEL_1);
  HAL_TIM_ChannelStateTypeDef channel_2_state = TIM_CHANNEL_STATE_GET(htim, TIM_CHANNEL_2);
  HAL_TIM_ChannelStateTypeDef complementary_channel_1_state = TIM_CHANNEL_N_STATE_GET(htim, TIM_CHANNEL_1);
  HAL_TIM_ChannelStateTypeDef complementary_channel_2_state = TIM_CHANNEL_N_STATE_GET(htim, TIM_CHANNEL_2);

  /* Prevent unused argument(s) compilation warning */
  UNUSED(OutputChannel);

  /* Check the TIM channels state */
  if ((channel_1_state != HAL_TIM_CHANNEL_STATE_READY)
      || (channel_2_state != HAL_TIM_CHANNEL_STATE_READY)
      || (complementary_channel_1_state != HAL_TIM_CHANNEL_STATE_READY)
      || (complementary_channel_2_state != HAL_TIM_CHANNEL_STATE_READY))
  {
    return HAL_ERROR;
  }

  /* Set the TIM channels state */
  TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_BUSY);
  TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_BUSY);
  TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_BUSY);
  TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_BUSY);

  /* Enable the Capture compare and the Input Capture channels
    (in the OPM Mode the two possible channels that can be used are TIM_CHANNEL_1 and TIM_CHANNEL_2)
    if TIM_CHANNEL_1 is used as output, the TIM_CHANNEL_2 will be used as input and
    if TIM_CHANNEL_1 is used as input, the TIM_CHANNEL_2 will be used as output
    whatever the combination, the TIM_CHANNEL_1 and TIM_CHANNEL_2 should be enabled together

    No need to enable the counter, it's enabled automatically by hardware
    (the counter starts in response to a stimulus and generate a pulse */

  TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_1, TIM_CCx_ENABLE);
  TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_2, TIM_CCx_ENABLE);

  if (IS_TIM_BREAK_INSTANCE(htim->Instance) != RESET)
  {
    /* Enable the main output */
    __HAL_TIM_MOE_ENABLE(htim);
  }

  /* Return function status */
  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OnePulse_Stop(TIM_HandleTypeDef *htim, uint32_t OutputChannel)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(OutputChannel);

  /* Disable the Capture compare and the Input Capture channels
  (in the OPM Mode the two possible channels that can be used are TIM_CHANNEL_1 and TIM_CHANNEL_2)
  if TIM_CHANNEL_1 is used as output, the TIM_CHANNEL_2 will be used as input and
  if TIM_CHANNEL_1 is used as input, the TIM_CHANNEL_2 will be used as output
  whatever the combination, the TIM_CHANNEL_1 and TIM_CHANNEL_2 should be disabled together */

  TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_1, TIM_CCx_DISABLE);
  TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_2, TIM_CCx_DISABLE);

  if (IS_TIM_BREAK_INSTANCE(htim->Instance) != RESET)
  {
    /* Disable the Main Output */
    __HAL_TIM_MOE_DISABLE(htim);
  }

  /* Disable the Peripheral */
  __HAL_TIM_DISABLE(htim);

  /* Set the TIM channels state */
  TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_READY);
  TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_READY);
  TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_READY);
  TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_READY);

  /* Return function status */
  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OnePulse_Start_IT(TIM_HandleTypeDef *htim, uint32_t OutputChannel)
{
  HAL_TIM_ChannelStateTypeDef channel_1_state = TIM_CHANNEL_STATE_GET(htim, TIM_CHANNEL_1);
  HAL_TIM_ChannelStateTypeDef channel_2_state = TIM_CHANNEL_STATE_GET(htim, TIM_CHANNEL_2);
  HAL_TIM_ChannelStateTypeDef complementary_channel_1_state = TIM_CHANNEL_N_STATE_GET(htim, TIM_CHANNEL_1);
  HAL_TIM_ChannelStateTypeDef complementary_channel_2_state = TIM_CHANNEL_N_STATE_GET(htim, TIM_CHANNEL_2);

  /* Prevent unused argument(s) compilation warning */
  UNUSED(OutputChannel);

  /* Check the TIM channels state */
  if ((channel_1_state != HAL_TIM_CHANNEL_STATE_READY)
      || (channel_2_state != HAL_TIM_CHANNEL_STATE_READY)
      || (complementary_channel_1_state != HAL_TIM_CHANNEL_STATE_READY)
      || (complementary_channel_2_state != HAL_TIM_CHANNEL_STATE_READY))
  {
    return HAL_ERROR;
  }

  /* Set the TIM channels state */
  TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_BUSY);
  TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_BUSY);
  TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_BUSY);
  TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_BUSY);

  /* Enable the Capture compare and the Input Capture channels
    (in the OPM Mode the two possible channels that can be used are TIM_CHANNEL_1 and TIM_CHANNEL_2)
    if TIM_CHANNEL_1 is used as output, the TIM_CHANNEL_2 will be used as input and
    if TIM_CHANNEL_1 is used as input, the TIM_CHANNEL_2 will be used as output
    whatever the combination, the TIM_CHANNEL_1 and TIM_CHANNEL_2 should be enabled together

    No need to enable the counter, it's enabled automatically by hardware
    (the counter starts in response to a stimulus and generate a pulse */

  /* Enable the TIM Capture/Compare 1 interrupt */
  __HAL_TIM_ENABLE_IT(htim, TIM_IT_CC1);

  /* Enable the TIM Capture/Compare 2 interrupt */
  __HAL_TIM_ENABLE_IT(htim, TIM_IT_CC2);

  TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_1, TIM_CCx_ENABLE);
  TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_2, TIM_CCx_ENABLE);

  if (IS_TIM_BREAK_INSTANCE(htim->Instance) != RESET)
  {
    /* Enable the main output */
    __HAL_TIM_MOE_ENABLE(htim);
  }

  /* Return function status */
  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OnePulse_Stop_IT(TIM_HandleTypeDef *htim, uint32_t OutputChannel)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(OutputChannel);

  /* Disable the TIM Capture/Compare 1 interrupt */
  __HAL_TIM_DISABLE_IT(htim, TIM_IT_CC1);

  /* Disable the TIM Capture/Compare 2 interrupt */
  __HAL_TIM_DISABLE_IT(htim, TIM_IT_CC2);

  /* Disable the Capture compare and the Input Capture channels
  (in the OPM Mode the two possible channels that can be used are TIM_CHANNEL_1 and TIM_CHANNEL_2)
  if TIM_CHANNEL_1 is used as output, the TIM_CHANNEL_2 will be used as input and
  if TIM_CHANNEL_1 is used as input, the TIM_CHANNEL_2 will be used as output
  whatever the combination, the TIM_CHANNEL_1 and TIM_CHANNEL_2 should be disabled together */
  TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_1, TIM_CCx_DISABLE);
  TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_2, TIM_CCx_DISABLE);

  if (IS_TIM_BREAK_INSTANCE(htim->Instance) != RESET)
  {
    /* Disable the Main Output */
    __HAL_TIM_MOE_DISABLE(htim);
  }

  /* Disable the Peripheral */
  __HAL_TIM_DISABLE(htim);

  /* Set the TIM channels state */
  TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_READY);
  TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_READY);
  TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_READY);
  TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_READY);

  /* Return function status */
  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Encoder_Init(TIM_HandleTypeDef *htim, const TIM_Encoder_InitTypeDef *sConfig)
{
  uint32_t tmpsmcr;
  uint32_t tmpccmr1;
  uint32_t tmpccer;

  /* Check the TIM handle allocation */
  if (htim == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_TIM_ENCODER_INTERFACE_INSTANCE(htim->Instance));
  assert_param(IS_TIM_COUNTER_MODE(htim->Init.CounterMode));
  assert_param(IS_TIM_CLOCKDIVISION_DIV(htim->Init.ClockDivision));
  assert_param(IS_TIM_AUTORELOAD_PRELOAD(htim->Init.AutoReloadPreload));
  assert_param(IS_TIM_ENCODER_MODE(sConfig->EncoderMode));
  assert_param(IS_TIM_IC_SELECTION(sConfig->IC1Selection));
  assert_param(IS_TIM_IC_SELECTION(sConfig->IC2Selection));
  assert_param(IS_TIM_ENCODERINPUT_POLARITY(sConfig->IC1Polarity));
  assert_param(IS_TIM_ENCODERINPUT_POLARITY(sConfig->IC2Polarity));
  assert_param(IS_TIM_IC_PRESCALER(sConfig->IC1Prescaler));
  assert_param(IS_TIM_IC_PRESCALER(sConfig->IC2Prescaler));
  assert_param(IS_TIM_IC_FILTER(sConfig->IC1Filter));
  assert_param(IS_TIM_IC_FILTER(sConfig->IC2Filter));
  assert_param(IS_TIM_PERIOD(htim, htim->Init.Period));

  if (htim->State == HAL_TIM_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    htim->Lock = HAL_UNLOCKED;

#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
    /* Reset interrupt callbacks to legacy weak callbacks */
    TIM_ResetCallback(htim);

    if (htim->Encoder_MspInitCallback == NULL)
    {
      htim->Encoder_MspInitCallback = HAL_TIM_Encoder_MspInit;
    }
    /* Init the low level hardware : GPIO, CLOCK, NVIC */
    htim->Encoder_MspInitCallback(htim);
#else
    /* Init the low level hardware : GPIO, CLOCK, NVIC and DMA */
    HAL_TIM_Encoder_MspInit(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
  }

  /* Set the TIM state */
  htim->State = HAL_TIM_STATE_BUSY;

  /* Reset the SMS and ECE bits */
  htim->Instance->SMCR &= ~(TIM_SMCR_SMS | TIM_SMCR_ECE);

  /* Configure the Time base in the Encoder Mode */
  TIM_Base_SetConfig(htim->Instance, &htim->Init);

  /* Get the TIMx SMCR register value */
  tmpsmcr = htim->Instance->SMCR;

  /* Get the TIMx CCMR1 register value */
  tmpccmr1 = htim->Instance->CCMR1;

  /* Get the TIMx CCER register value */
  tmpccer = htim->Instance->CCER;

  /* Set the encoder Mode */
  tmpsmcr |= sConfig->EncoderMode;

  /* Select the Capture Compare 1 and the Capture Compare 2 as input */
  tmpccmr1 &= ~(TIM_CCMR1_CC1S | TIM_CCMR1_CC2S);
  tmpccmr1 |= (sConfig->IC1Selection | (sConfig->IC2Selection << 8U));

  /* Set the Capture Compare 1 and the Capture Compare 2 prescalers and filters */
  tmpccmr1 &= ~(TIM_CCMR1_IC1PSC | TIM_CCMR1_IC2PSC);
  tmpccmr1 &= ~(TIM_CCMR1_IC1F | TIM_CCMR1_IC2F);
  tmpccmr1 |= sConfig->IC1Prescaler | (sConfig->IC2Prescaler << 8U);
  tmpccmr1 |= (sConfig->IC1Filter << 4U) | (sConfig->IC2Filter << 12U);

  /* Set the TI1 and the TI2 Polarities */
  tmpccer &= ~(TIM_CCER_CC1P | TIM_CCER_CC2P);
  tmpccer &= ~(TIM_CCER_CC1NP | TIM_CCER_CC2NP);
  tmpccer |= sConfig->IC1Polarity | (sConfig->IC2Polarity << 4U);

  /* Write to TIMx SMCR */
  htim->Instance->SMCR = tmpsmcr;

  /* Write to TIMx CCMR1 */
  htim->Instance->CCMR1 = tmpccmr1;

  /* Write to TIMx CCER */
  htim->Instance->CCER = tmpccer;

  /* Initialize the DMA burst operation state */
  htim->DMABurstState = HAL_DMA_BURST_STATE_READY;

  /* Set the TIM channels state */
  TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_READY);
  TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_READY);
  TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_READY);
  TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_READY);

  /* Initialize the TIM state*/
  htim->State = HAL_TIM_STATE_READY;

  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Encoder_DeInit(TIM_HandleTypeDef *htim)
{
  /* Check the parameters */
  assert_param(IS_TIM_INSTANCE(htim->Instance));

  htim->State = HAL_TIM_STATE_BUSY;

  /* Disable the TIM Peripheral Clock */
  __HAL_TIM_DISABLE(htim);

#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
  if (htim->Encoder_MspDeInitCallback == NULL)
  {
    htim->Encoder_MspDeInitCallback = HAL_TIM_Encoder_MspDeInit;
  }
  /* DeInit the low level hardware */
  htim->Encoder_MspDeInitCallback(htim);
#else
  /* DeInit the low level hardware: GPIO, CLOCK, NVIC */
  HAL_TIM_Encoder_MspDeInit(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */

  /* Change the DMA burst operation state */
  htim->DMABurstState = HAL_DMA_BURST_STATE_RESET;

  /* Set the TIM channels state */
  TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_RESET);
  TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_RESET);
  TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_RESET);
  TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_RESET);

  /* Change TIM state */
  htim->State = HAL_TIM_STATE_RESET;

  /* Release Lock */
  __HAL_UNLOCK(htim);

  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Encoder_Start(TIM_HandleTypeDef *htim, uint32_t Channel)
{
  HAL_TIM_ChannelStateTypeDef channel_1_state = TIM_CHANNEL_STATE_GET(htim, TIM_CHANNEL_1);
  HAL_TIM_ChannelStateTypeDef channel_2_state = TIM_CHANNEL_STATE_GET(htim, TIM_CHANNEL_2);
  HAL_TIM_ChannelStateTypeDef complementary_channel_1_state = TIM_CHANNEL_N_STATE_GET(htim, TIM_CHANNEL_1);
  HAL_TIM_ChannelStateTypeDef complementary_channel_2_state = TIM_CHANNEL_N_STATE_GET(htim, TIM_CHANNEL_2);

  /* Check the parameters */
  assert_param(IS_TIM_ENCODER_INTERFACE_INSTANCE(htim->Instance));

  /* Set the TIM channel(s) state */
  if (Channel == TIM_CHANNEL_1)
  {
    if ((channel_1_state != HAL_TIM_CHANNEL_STATE_READY)
        || (complementary_channel_1_state != HAL_TIM_CHANNEL_STATE_READY))
    {
      return HAL_ERROR;
    }
    else
    {
      TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_BUSY);
      TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_BUSY);
    }
  }
  else if (Channel == TIM_CHANNEL_2)
  {
    if ((channel_2_state != HAL_TIM_CHANNEL_STATE_READY)
        || (complementary_channel_2_state != HAL_TIM_CHANNEL_STATE_READY))
    {
      return HAL_ERROR;
    }
    else
    {
      TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_BUSY);
      TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_BUSY);
    }
  }
  else
  {
    if ((channel_1_state != HAL_TIM_CHANNEL_STATE_READY)
        || (channel_2_state != HAL_TIM_CHANNEL_STATE_READY)
        || (complementary_channel_1_state != HAL_TIM_CHANNEL_STATE_READY)
        || (complementary_channel_2_state != HAL_TIM_CHANNEL_STATE_READY))
    {
      return HAL_ERROR;
    }
    else
    {
      TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_BUSY);
      TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_BUSY);
      TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_BUSY);
      TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_BUSY);
    }
  }

  /* Enable the encoder interface channels */
  switch (Channel)
  {
    case TIM_CHANNEL_1:
    {
      TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_1, TIM_CCx_ENABLE);
      break;
    }

    case TIM_CHANNEL_2:
    {
      TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_2, TIM_CCx_ENABLE);
      break;
    }

    default :
    {
      TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_1, TIM_CCx_ENABLE);
      TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_2, TIM_CCx_ENABLE);
      break;
    }
  }
  /* Enable the Peripheral */
  __HAL_TIM_ENABLE(htim);

  /* Return function status */
  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Encoder_Stop(TIM_HandleTypeDef *htim, uint32_t Channel)
{
  /* Check the parameters */
  assert_param(IS_TIM_ENCODER_INTERFACE_INSTANCE(htim->Instance));

  /* Disable the Input Capture channels 1 and 2
    (in the EncoderInterface the two possible channels that can be used are TIM_CHANNEL_1 and TIM_CHANNEL_2) */
  switch (Channel)
  {
    case TIM_CHANNEL_1:
    {
      TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_1, TIM_CCx_DISABLE);
      break;
    }

    case TIM_CHANNEL_2:
    {
      TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_2, TIM_CCx_DISABLE);
      break;
    }

    default :
    {
      TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_1, TIM_CCx_DISABLE);
      TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_2, TIM_CCx_DISABLE);
      break;
    }
  }

  /* Disable the Peripheral */
  __HAL_TIM_DISABLE(htim);

  /* Set the TIM channel(s) state */
  if ((Channel == TIM_CHANNEL_1) || (Channel == TIM_CHANNEL_2))
  {
    TIM_CHANNEL_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_READY);
    TIM_CHANNEL_N_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_READY);
  }
  else
  {
    TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_READY);
    TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_READY);
    TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_READY);
    TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_READY);
  }

  /* Return function status */
  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Encoder_Start_IT(TIM_HandleTypeDef *htim, uint32_t Channel)
{
  HAL_TIM_ChannelStateTypeDef channel_1_state = TIM_CHANNEL_STATE_GET(htim, TIM_CHANNEL_1);
  HAL_TIM_ChannelStateTypeDef channel_2_state = TIM_CHANNEL_STATE_GET(htim, TIM_CHANNEL_2);
  HAL_TIM_ChannelStateTypeDef complementary_channel_1_state = TIM_CHANNEL_N_STATE_GET(htim, TIM_CHANNEL_1);
  HAL_TIM_ChannelStateTypeDef complementary_channel_2_state = TIM_CHANNEL_N_STATE_GET(htim, TIM_CHANNEL_2);

  /* Check the parameters */
  assert_param(IS_TIM_ENCODER_INTERFACE_INSTANCE(htim->Instance));

  /* Set the TIM channel(s) state */
  if (Channel == TIM_CHANNEL_1)
  {
    if ((channel_1_state != HAL_TIM_CHANNEL_STATE_READY)
        || (complementary_channel_1_state != HAL_TIM_CHANNEL_STATE_READY))
    {
      return HAL_ERROR;
    }
    else
    {
      TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_BUSY);
      TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_BUSY);
    }
  }
  else if (Channel == TIM_CHANNEL_2)
  {
    if ((channel_2_state != HAL_TIM_CHANNEL_STATE_READY)
        || (complementary_channel_2_state != HAL_TIM_CHANNEL_STATE_READY))
    {
      return HAL_ERROR;
    }
    else
    {
      TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_BUSY);
      TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_BUSY);
    }
  }
  else
  {
    if ((channel_1_state != HAL_TIM_CHANNEL_STATE_READY)
        || (channel_2_state != HAL_TIM_CHANNEL_STATE_READY)
        || (complementary_channel_1_state != HAL_TIM_CHANNEL_STATE_READY)
        || (complementary_channel_2_state != HAL_TIM_CHANNEL_STATE_READY))
    {
      return HAL_ERROR;
    }
    else
    {
      TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_BUSY);
      TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_BUSY);
      TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_BUSY);
      TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_BUSY);
    }
  }

  /* Enable the encoder interface channels */
  /* Enable the capture compare Interrupts 1 and/or 2 */
  switch (Channel)
  {
    case TIM_CHANNEL_1:
    {
      TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_1, TIM_CCx_ENABLE);
      __HAL_TIM_ENABLE_IT(htim, TIM_IT_CC1);
      break;
    }

    case TIM_CHANNEL_2:
    {
      TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_2, TIM_CCx_ENABLE);
      __HAL_TIM_ENABLE_IT(htim, TIM_IT_CC2);
      break;
    }

    default :
    {
      TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_1, TIM_CCx_ENABLE);
      TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_2, TIM_CCx_ENABLE);
      __HAL_TIM_ENABLE_IT(htim, TIM_IT_CC1);
      __HAL_TIM_ENABLE_IT(htim, TIM_IT_CC2);
      break;
    }
  }

  /* Enable the Peripheral */
  __HAL_TIM_ENABLE(htim);

  /* Return function status */
  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Encoder_Stop_IT(TIM_HandleTypeDef *htim, uint32_t Channel)
{
  /* Check the parameters */
  assert_param(IS_TIM_ENCODER_INTERFACE_INSTANCE(htim->Instance));

  /* Disable the Input Capture channels 1 and 2
    (in the EncoderInterface the two possible channels that can be used are TIM_CHANNEL_1 and TIM_CHANNEL_2) */
  if (Channel == TIM_CHANNEL_1)
  {
    TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_1, TIM_CCx_DISABLE);

    /* Disable the capture compare Interrupts 1 */
    __HAL_TIM_DISABLE_IT(htim, TIM_IT_CC1);
  }
  else if (Channel == TIM_CHANNEL_2)
  {
    TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_2, TIM_CCx_DISABLE);

    /* Disable the capture compare Interrupts 2 */
    __HAL_TIM_DISABLE_IT(htim, TIM_IT_CC2);
  }
  else
  {
    TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_1, TIM_CCx_DISABLE);
    TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_2, TIM_CCx_DISABLE);

    /* Disable the capture compare Interrupts 1 and 2 */
    __HAL_TIM_DISABLE_IT(htim, TIM_IT_CC1);
    __HAL_TIM_DISABLE_IT(htim, TIM_IT_CC2);
  }

  /* Disable the Peripheral */
  __HAL_TIM_DISABLE(htim);

  /* Set the TIM channel(s) state */
  if ((Channel == TIM_CHANNEL_1) || (Channel == TIM_CHANNEL_2))
  {
    TIM_CHANNEL_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_READY);
    TIM_CHANNEL_N_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_READY);
  }
  else
  {
    TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_READY);
    TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_READY);
    TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_READY);
    TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_READY);
  }

  /* Return function status */
  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Encoder_Start_DMA(TIM_HandleTypeDef *htim, uint32_t Channel, uint32_t *pData1,
                                            uint32_t *pData2, uint16_t Length)
{
  HAL_TIM_ChannelStateTypeDef channel_1_state = TIM_CHANNEL_STATE_GET(htim, TIM_CHANNEL_1);
  HAL_TIM_ChannelStateTypeDef channel_2_state = TIM_CHANNEL_STATE_GET(htim, TIM_CHANNEL_2);
  HAL_TIM_ChannelStateTypeDef complementary_channel_1_state = TIM_CHANNEL_N_STATE_GET(htim, TIM_CHANNEL_1);
  HAL_TIM_ChannelStateTypeDef complementary_channel_2_state = TIM_CHANNEL_N_STATE_GET(htim, TIM_CHANNEL_2);

  /* Check the parameters */
  assert_param(IS_TIM_ENCODER_INTERFACE_INSTANCE(htim->Instance));

  /* Set the TIM channel(s) state */
  if (Channel == TIM_CHANNEL_1)
  {
    if ((channel_1_state == HAL_TIM_CHANNEL_STATE_BUSY)
        || (complementary_channel_1_state == HAL_TIM_CHANNEL_STATE_BUSY))
    {
      return HAL_BUSY;
    }
    else if ((channel_1_state == HAL_TIM_CHANNEL_STATE_READY)
             && (complementary_channel_1_state == HAL_TIM_CHANNEL_STATE_READY))
    {
      if ((pData1 == NULL) || (Length == 0U))
      {
        return HAL_ERROR;
      }
      else
      {
        TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_BUSY);
        TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_BUSY);
      }
    }
    else
    {
      return HAL_ERROR;
    }
  }
  else if (Channel == TIM_CHANNEL_2)
  {
    if ((channel_2_state == HAL_TIM_CHANNEL_STATE_BUSY)
        || (complementary_channel_2_state == HAL_TIM_CHANNEL_STATE_BUSY))
    {
      return HAL_BUSY;
    }
    else if ((channel_2_state == HAL_TIM_CHANNEL_STATE_READY)
             && (complementary_channel_2_state == HAL_TIM_CHANNEL_STATE_READY))
    {
      if ((pData2 == NULL) || (Length == 0U))
      {
        return HAL_ERROR;
      }
      else
      {
        TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_BUSY);
        TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_BUSY);
      }
    }
    else
    {
      return HAL_ERROR;
    }
  }
  else
  {
    if ((channel_1_state == HAL_TIM_CHANNEL_STATE_BUSY)
        || (channel_2_state == HAL_TIM_CHANNEL_STATE_BUSY)
        || (complementary_channel_1_state == HAL_TIM_CHANNEL_STATE_BUSY)
        || (complementary_channel_2_state == HAL_TIM_CHANNEL_STATE_BUSY))
    {
      return HAL_BUSY;
    }
    else if ((channel_1_state == HAL_TIM_CHANNEL_STATE_READY)
             && (channel_2_state == HAL_TIM_CHANNEL_STATE_READY)
             && (complementary_channel_1_state == HAL_TIM_CHANNEL_STATE_READY)
             && (complementary_channel_2_state == HAL_TIM_CHANNEL_STATE_READY))
    {
      if ((((pData1 == NULL) || (pData2 == NULL))) || (Length == 0U))
      {
        return HAL_ERROR;
      }
      else
      {
        TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_BUSY);
        TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_BUSY);
        TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_BUSY);
        TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_BUSY);
      }
    }
    else
    {
      return HAL_ERROR;
    }
  }

  switch (Channel)
  {
    case TIM_CHANNEL_1:
    {
      /* Set the DMA capture callbacks */
      htim->hdma[TIM_DMA_ID_CC1]->XferCpltCallback = TIM_DMACaptureCplt;
      htim->hdma[TIM_DMA_ID_CC1]->XferHalfCpltCallback = TIM_DMACaptureHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_CC1]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_CC1], (uint32_t)&htim->Instance->CCR1, (uint32_t)pData1,
                           Length) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      /* Enable the TIM Input Capture DMA request */
      __HAL_TIM_ENABLE_DMA(htim, TIM_DMA_CC1);

      /* Enable the Capture compare channel */
      TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_1, TIM_CCx_ENABLE);

      /* Enable the Peripheral */
      __HAL_TIM_ENABLE(htim);

      break;
    }

    case TIM_CHANNEL_2:
    {
      /* Set the DMA capture callbacks */
      htim->hdma[TIM_DMA_ID_CC2]->XferCpltCallback = TIM_DMACaptureCplt;
      htim->hdma[TIM_DMA_ID_CC2]->XferHalfCpltCallback = TIM_DMACaptureHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_CC2]->XferErrorCallback = TIM_DMAError;
      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_CC2], (uint32_t)&htim->Instance->CCR2, (uint32_t)pData2,
                           Length) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      /* Enable the TIM Input Capture  DMA request */
      __HAL_TIM_ENABLE_DMA(htim, TIM_DMA_CC2);

      /* Enable the Capture compare channel */
      TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_2, TIM_CCx_ENABLE);

      /* Enable the Peripheral */
      __HAL_TIM_ENABLE(htim);

      break;
    }

    default:
    {
      /* Set the DMA capture callbacks */
      htim->hdma[TIM_DMA_ID_CC1]->XferCpltCallback = TIM_DMACaptureCplt;
      htim->hdma[TIM_DMA_ID_CC1]->XferHalfCpltCallback = TIM_DMACaptureHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_CC1]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_CC1], (uint32_t)&htim->Instance->CCR1, (uint32_t)pData1,
                           Length) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }

      /* Set the DMA capture callbacks */
      htim->hdma[TIM_DMA_ID_CC2]->XferCpltCallback = TIM_DMACaptureCplt;
      htim->hdma[TIM_DMA_ID_CC2]->XferHalfCpltCallback = TIM_DMACaptureHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_CC2]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_CC2], (uint32_t)&htim->Instance->CCR2, (uint32_t)pData2,
                           Length) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }

      /* Enable the TIM Input Capture  DMA request */
      __HAL_TIM_ENABLE_DMA(htim, TIM_DMA_CC1);
      /* Enable the TIM Input Capture  DMA request */
      __HAL_TIM_ENABLE_DMA(htim, TIM_DMA_CC2);

      /* Enable the Capture compare channel */
      TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_1, TIM_CCx_ENABLE);
      TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_2, TIM_CCx_ENABLE);

      /* Enable the Peripheral */
      __HAL_TIM_ENABLE(htim);

      break;
    }
  }

  /* Return function status */
  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Encoder_Stop_DMA(TIM_HandleTypeDef *htim, uint32_t Channel)
{
  /* Check the parameters */
  assert_param(IS_TIM_ENCODER_INTERFACE_INSTANCE(htim->Instance));

  /* Disable the Input Capture channels 1 and 2
    (in the EncoderInterface the two possible channels that can be used are TIM_CHANNEL_1 and TIM_CHANNEL_2) */
  if (Channel == TIM_CHANNEL_1)
  {
    TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_1, TIM_CCx_DISABLE);

    /* Disable the capture compare DMA Request 1 */
    __HAL_TIM_DISABLE_DMA(htim, TIM_DMA_CC1);
    (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_CC1]);
  }
  else if (Channel == TIM_CHANNEL_2)
  {
    TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_2, TIM_CCx_DISABLE);

    /* Disable the capture compare DMA Request 2 */
    __HAL_TIM_DISABLE_DMA(htim, TIM_DMA_CC2);
    (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_CC2]);
  }
  else
  {
    TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_1, TIM_CCx_DISABLE);
    TIM_CCxChannelCmd(htim->Instance, TIM_CHANNEL_2, TIM_CCx_DISABLE);

    /* Disable the capture compare DMA Request 1 and 2 */
    __HAL_TIM_DISABLE_DMA(htim, TIM_DMA_CC1);
    __HAL_TIM_DISABLE_DMA(htim, TIM_DMA_CC2);
    (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_CC1]);
    (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_CC2]);
  }

  /* Disable the Peripheral */
  __HAL_TIM_DISABLE(htim);

  /* Set the TIM channel(s) state */
  if ((Channel == TIM_CHANNEL_1) || (Channel == TIM_CHANNEL_2))
  {
    TIM_CHANNEL_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_READY);
    TIM_CHANNEL_N_STATE_SET(htim, Channel, HAL_TIM_CHANNEL_STATE_READY);
  }
  else
  {
    TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_READY);
    TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_READY);
    TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_READY);
    TIM_CHANNEL_N_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_READY);
  }

  /* Return function status */
  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
void HAL_TIM_IRQHandler(TIM_HandleTypeDef *htim)
{
  uint32_t itsource = htim->Instance->DIER;
  uint32_t itflag   = htim->Instance->SR;

  /* Capture compare 1 event */
  if ((itflag & (TIM_FLAG_CC1)) == (TIM_FLAG_CC1))
  {
    if ((itsource & (TIM_IT_CC1)) == (TIM_IT_CC1))
    {
      {
        __HAL_TIM_CLEAR_FLAG(htim, TIM_FLAG_CC1);
        htim->Channel = HAL_TIM_ACTIVE_CHANNEL_1;

        /* Input capture event */
        if ((htim->Instance->CCMR1 & TIM_CCMR1_CC1S) != 0x00U)
        {
#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
          htim->IC_CaptureCallback(htim);
#else
          HAL_TIM_IC_CaptureCallback(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
        }
        /* Output compare event */
        else
        {
#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
          htim->OC_DelayElapsedCallback(htim);
          htim->PWM_PulseFinishedCallback(htim);
#else
          HAL_TIM_OC_DelayElapsedCallback(htim);
          HAL_TIM_PWM_PulseFinishedCallback(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
        }
        htim->Channel = HAL_TIM_ACTIVE_CHANNEL_CLEARED;
      }
    }
  }
  /* Capture compare 2 event */
  if ((itflag & (TIM_FLAG_CC2)) == (TIM_FLAG_CC2))
  {
    if ((itsource & (TIM_IT_CC2)) == (TIM_IT_CC2))
    {
      __HAL_TIM_CLEAR_FLAG(htim, TIM_FLAG_CC2);
      htim->Channel = HAL_TIM_ACTIVE_CHANNEL_2;
      /* Input capture event */
      if ((htim->Instance->CCMR1 & TIM_CCMR1_CC2S) != 0x00U)
      {
#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
        htim->IC_CaptureCallback(htim);
#else
        HAL_TIM_IC_CaptureCallback(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
      }
      /* Output compare event */
      else
      {
#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
        htim->OC_DelayElapsedCallback(htim);
        htim->PWM_PulseFinishedCallback(htim);
#else
        HAL_TIM_OC_DelayElapsedCallback(htim);
        HAL_TIM_PWM_PulseFinishedCallback(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
      }
      htim->Channel = HAL_TIM_ACTIVE_CHANNEL_CLEARED;
    }
  }
  /* Capture compare 3 event */
  if ((itflag & (TIM_FLAG_CC3)) == (TIM_FLAG_CC3))
  {
    if ((itsource & (TIM_IT_CC3)) == (TIM_IT_CC3))
    {
      __HAL_TIM_CLEAR_FLAG(htim, TIM_FLAG_CC3);
      htim->Channel = HAL_TIM_ACTIVE_CHANNEL_3;
      /* Input capture event */
      if ((htim->Instance->CCMR2 & TIM_CCMR2_CC3S) != 0x00U)
      {
#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
        htim->IC_CaptureCallback(htim);
#else
        HAL_TIM_IC_CaptureCallback(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
      }
      /* Output compare event */
      else
      {
#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
        htim->OC_DelayElapsedCallback(htim);
        htim->PWM_PulseFinishedCallback(htim);
#else
        HAL_TIM_OC_DelayElapsedCallback(htim);
        HAL_TIM_PWM_PulseFinishedCallback(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
      }
      htim->Channel = HAL_TIM_ACTIVE_CHANNEL_CLEARED;
    }
  }
  /* Capture compare 4 event */
  if ((itflag & (TIM_FLAG_CC4)) == (TIM_FLAG_CC4))
  {
    if ((itsource & (TIM_IT_CC4)) == (TIM_IT_CC4))
    {
      __HAL_TIM_CLEAR_FLAG(htim, TIM_FLAG_CC4);
      htim->Channel = HAL_TIM_ACTIVE_CHANNEL_4;
      /* Input capture event */
      if ((htim->Instance->CCMR2 & TIM_CCMR2_CC4S) != 0x00U)
      {
#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
        htim->IC_CaptureCallback(htim);
#else
        HAL_TIM_IC_CaptureCallback(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
      }
      /* Output compare event */
      else
      {
#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
        htim->OC_DelayElapsedCallback(htim);
        htim->PWM_PulseFinishedCallback(htim);
#else
        HAL_TIM_OC_DelayElapsedCallback(htim);
        HAL_TIM_PWM_PulseFinishedCallback(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
      }
      htim->Channel = HAL_TIM_ACTIVE_CHANNEL_CLEARED;
    }
  }
  /* TIM Update event */
  if ((itflag & (TIM_FLAG_UPDATE)) == (TIM_FLAG_UPDATE))
  {
    if ((itsource & (TIM_IT_UPDATE)) == (TIM_IT_UPDATE))
    {
      __HAL_TIM_CLEAR_FLAG(htim, TIM_FLAG_UPDATE);
#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
      htim->PeriodElapsedCallback(htim);
#else
      HAL_TIM_PeriodElapsedCallback(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
    }
  }
  /* TIM Break input event */
  if (((itflag & (TIM_FLAG_BREAK)) == (TIM_FLAG_BREAK)) || \
      ((itflag & (TIM_FLAG_SYSTEM_BREAK)) == (TIM_FLAG_SYSTEM_BREAK)))
  {
    if ((itsource & (TIM_IT_BREAK)) == (TIM_IT_BREAK))
    {
      __HAL_TIM_CLEAR_FLAG(htim, TIM_FLAG_BREAK | TIM_FLAG_SYSTEM_BREAK);
#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
      htim->BreakCallback(htim);
#else
      HAL_TIMEx_BreakCallback(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
    }
  }
  /* TIM Break2 input event */
  if ((itflag & (TIM_FLAG_BREAK2)) == (TIM_FLAG_BREAK2))
  {
    if ((itsource & (TIM_IT_BREAK)) == (TIM_IT_BREAK))
    {
      __HAL_TIM_CLEAR_FLAG(htim, TIM_FLAG_BREAK2);
#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
      htim->Break2Callback(htim);
#else
      HAL_TIMEx_Break2Callback(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
    }
  }
  /* TIM Trigger detection event */
  if ((itflag & (TIM_FLAG_TRIGGER)) == (TIM_FLAG_TRIGGER))
  {
    if ((itsource & (TIM_IT_TRIGGER)) == (TIM_IT_TRIGGER))
    {
      __HAL_TIM_CLEAR_FLAG(htim, TIM_FLAG_TRIGGER);
#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
      htim->TriggerCallback(htim);
#else
      HAL_TIM_TriggerCallback(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
    }
  }
  /* TIM commutation event */
  if ((itflag & (TIM_FLAG_COM)) == (TIM_FLAG_COM))
  {
    if ((itsource & (TIM_IT_COM)) == (TIM_IT_COM))
    {
      __HAL_TIM_CLEAR_FLAG(htim, TIM_FLAG_COM);
#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
      htim->CommutationCallback(htim);
#else
      HAL_TIMEx_CommutCallback(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
    }
  }
  /* TIM Encoder index event */
  if ((itflag & (TIM_FLAG_IDX)) == (TIM_FLAG_IDX))
  {
    if ((itsource & (TIM_IT_IDX)) == (TIM_IT_IDX))
    {
      __HAL_TIM_CLEAR_FLAG(htim, TIM_FLAG_IDX);
#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
      htim->EncoderIndexCallback(htim);
#else
      HAL_TIMEx_EncoderIndexCallback(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
    }
  }
  /* TIM Direction change event */
  if ((itflag & (TIM_FLAG_DIR)) == (TIM_FLAG_DIR))
  {
    if ((itsource & (TIM_IT_DIR)) == (TIM_IT_DIR))
    {
      __HAL_TIM_CLEAR_FLAG(htim, TIM_FLAG_DIR);
#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
      htim->DirectionChangeCallback(htim);
#else
      HAL_TIMEx_DirectionChangeCallback(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
    }
  }
  /* TIM Index error event */
  if ((itflag & (TIM_FLAG_IERR)) == (TIM_FLAG_IERR))
  {
    if ((itsource & (TIM_IT_IERR)) == (TIM_IT_IERR))
    {
      __HAL_TIM_CLEAR_FLAG(htim, TIM_FLAG_IERR);
#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
      htim->IndexErrorCallback(htim);
#else
      HAL_TIMEx_IndexErrorCallback(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
    }
  }
  /* TIM Transition error event */
  if ((itflag & (TIM_FLAG_TERR)) == (TIM_FLAG_TERR))
  {
    if ((itsource & (TIM_IT_TERR)) == (TIM_IT_TERR))
    {
      __HAL_TIM_CLEAR_FLAG(htim, TIM_FLAG_TERR);
#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
      htim->TransitionErrorCallback(htim);
#else
      HAL_TIMEx_TransitionErrorCallback(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
    }
  }
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OC_ConfigChannel(TIM_HandleTypeDef *htim,
                                           const TIM_OC_InitTypeDef *sConfig,
                                           uint32_t Channel)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the parameters */
  assert_param(IS_TIM_CHANNELS(Channel));
  assert_param(IS_TIM_OC_CHANNEL_MODE(sConfig->OCMode, Channel));
  assert_param(IS_TIM_OC_POLARITY(sConfig->OCPolarity));

  /* Process Locked */
  __HAL_LOCK(htim);

  switch (Channel)
  {
    case TIM_CHANNEL_1:
    {
      /* Check the parameters */
      assert_param(IS_TIM_CC1_INSTANCE(htim->Instance));

      /* Configure the TIM Channel 1 in Output Compare */
      TIM_OC1_SetConfig(htim->Instance, sConfig);
      break;
    }

    case TIM_CHANNEL_2:
    {
      /* Check the parameters */
      assert_param(IS_TIM_CC2_INSTANCE(htim->Instance));

      /* Configure the TIM Channel 2 in Output Compare */
      TIM_OC2_SetConfig(htim->Instance, sConfig);
      break;
    }

    case TIM_CHANNEL_3:
    {
      /* Check the parameters */
      assert_param(IS_TIM_CC3_INSTANCE(htim->Instance));

      /* Configure the TIM Channel 3 in Output Compare */
      TIM_OC3_SetConfig(htim->Instance, sConfig);
      break;
    }

    case TIM_CHANNEL_4:
    {
      /* Check the parameters */
      assert_param(IS_TIM_CC4_INSTANCE(htim->Instance));

      /* Configure the TIM Channel 4 in Output Compare */
      TIM_OC4_SetConfig(htim->Instance, sConfig);
      break;
    }

    case TIM_CHANNEL_5:
    {
      /* Check the parameters */
      assert_param(IS_TIM_CC5_INSTANCE(htim->Instance));

      /* Configure the TIM Channel 5 in Output Compare */
      TIM_OC5_SetConfig(htim->Instance, sConfig);
      break;
    }

    case TIM_CHANNEL_6:
    {
      /* Check the parameters */
      assert_param(IS_TIM_CC6_INSTANCE(htim->Instance));

      /* Configure the TIM Channel 6 in Output Compare */
      TIM_OC6_SetConfig(htim->Instance, sConfig);
      break;
    }

    default:
      status = HAL_ERROR;
      break;
  }

  __HAL_UNLOCK(htim);

  return status;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_IC_ConfigChannel(TIM_HandleTypeDef *htim, const TIM_IC_InitTypeDef *sConfig, uint32_t Channel)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the parameters */
  assert_param(IS_TIM_CC1_INSTANCE(htim->Instance));
  assert_param(IS_TIM_IC_POLARITY(sConfig->ICPolarity));
  assert_param(IS_TIM_IC_SELECTION(sConfig->ICSelection));
  assert_param(IS_TIM_IC_PRESCALER(sConfig->ICPrescaler));
  assert_param(IS_TIM_IC_FILTER(sConfig->ICFilter));

  /* Process Locked */
  __HAL_LOCK(htim);

  if (Channel == TIM_CHANNEL_1)
  {
    /* TI1 Configuration */
    TIM_TI1_SetConfig(htim->Instance,
                      sConfig->ICPolarity,
                      sConfig->ICSelection,
                      sConfig->ICFilter);

    /* Reset the IC1PSC Bits */
    htim->Instance->CCMR1 &= ~TIM_CCMR1_IC1PSC;

    /* Set the IC1PSC value */
    htim->Instance->CCMR1 |= sConfig->ICPrescaler;
  }
  else if (Channel == TIM_CHANNEL_2)
  {
    /* TI2 Configuration */
    assert_param(IS_TIM_CC2_INSTANCE(htim->Instance));

    TIM_TI2_SetConfig(htim->Instance,
                      sConfig->ICPolarity,
                      sConfig->ICSelection,
                      sConfig->ICFilter);

    /* Reset the IC2PSC Bits */
    htim->Instance->CCMR1 &= ~TIM_CCMR1_IC2PSC;

    /* Set the IC2PSC value */
    htim->Instance->CCMR1 |= (sConfig->ICPrescaler << 8U);
  }
  else if (Channel == TIM_CHANNEL_3)
  {
    /* TI3 Configuration */
    assert_param(IS_TIM_CC3_INSTANCE(htim->Instance));

    TIM_TI3_SetConfig(htim->Instance,
                      sConfig->ICPolarity,
                      sConfig->ICSelection,
                      sConfig->ICFilter);

    /* Reset the IC3PSC Bits */
    htim->Instance->CCMR2 &= ~TIM_CCMR2_IC3PSC;

    /* Set the IC3PSC value */
    htim->Instance->CCMR2 |= sConfig->ICPrescaler;
  }
  else if (Channel == TIM_CHANNEL_4)
  {
    /* TI4 Configuration */
    assert_param(IS_TIM_CC4_INSTANCE(htim->Instance));

    TIM_TI4_SetConfig(htim->Instance,
                      sConfig->ICPolarity,
                      sConfig->ICSelection,
                      sConfig->ICFilter);

    /* Reset the IC4PSC Bits */
    htim->Instance->CCMR2 &= ~TIM_CCMR2_IC4PSC;

    /* Set the IC4PSC value */
    htim->Instance->CCMR2 |= (sConfig->ICPrescaler << 8U);
  }
  else
  {
    status = HAL_ERROR;
  }

  __HAL_UNLOCK(htim);

  return status;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_PWM_ConfigChannel(TIM_HandleTypeDef *htim,
                                            const TIM_OC_InitTypeDef *sConfig,
                                            uint32_t Channel)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the parameters */
  assert_param(IS_TIM_CHANNELS(Channel));
  assert_param(IS_TIM_PWM_MODE(sConfig->OCMode));
  assert_param(IS_TIM_OC_POLARITY(sConfig->OCPolarity));
  assert_param(IS_TIM_FAST_STATE(sConfig->OCFastMode));

  /* Process Locked */
  __HAL_LOCK(htim);

  switch (Channel)
  {
    case TIM_CHANNEL_1:
    {
      /* Check the parameters */
      assert_param(IS_TIM_CC1_INSTANCE(htim->Instance));

      /* Configure the Channel 1 in PWM mode */
      TIM_OC1_SetConfig(htim->Instance, sConfig);

      /* Set the Preload enable bit for channel1 */
      htim->Instance->CCMR1 |= TIM_CCMR1_OC1PE;

      /* Configure the Output Fast mode */
      htim->Instance->CCMR1 &= ~TIM_CCMR1_OC1FE;
      htim->Instance->CCMR1 |= sConfig->OCFastMode;
      break;
    }

    case TIM_CHANNEL_2:
    {
      /* Check the parameters */
      assert_param(IS_TIM_CC2_INSTANCE(htim->Instance));

      /* Configure the Channel 2 in PWM mode */
      TIM_OC2_SetConfig(htim->Instance, sConfig);

      /* Set the Preload enable bit for channel2 */
      htim->Instance->CCMR1 |= TIM_CCMR1_OC2PE;

      /* Configure the Output Fast mode */
      htim->Instance->CCMR1 &= ~TIM_CCMR1_OC2FE;
      htim->Instance->CCMR1 |= sConfig->OCFastMode << 8U;
      break;
    }

    case TIM_CHANNEL_3:
    {
      /* Check the parameters */
      assert_param(IS_TIM_CC3_INSTANCE(htim->Instance));

      /* Configure the Channel 3 in PWM mode */
      TIM_OC3_SetConfig(htim->Instance, sConfig);

      /* Set the Preload enable bit for channel3 */
      htim->Instance->CCMR2 |= TIM_CCMR2_OC3PE;

      /* Configure the Output Fast mode */
      htim->Instance->CCMR2 &= ~TIM_CCMR2_OC3FE;
      htim->Instance->CCMR2 |= sConfig->OCFastMode;
      break;
    }

    case TIM_CHANNEL_4:
    {
      /* Check the parameters */
      assert_param(IS_TIM_CC4_INSTANCE(htim->Instance));

      /* Configure the Channel 4 in PWM mode */
      TIM_OC4_SetConfig(htim->Instance, sConfig);

      /* Set the Preload enable bit for channel4 */
      htim->Instance->CCMR2 |= TIM_CCMR2_OC4PE;

      /* Configure the Output Fast mode */
      htim->Instance->CCMR2 &= ~TIM_CCMR2_OC4FE;
      htim->Instance->CCMR2 |= sConfig->OCFastMode << 8U;
      break;
    }

    case TIM_CHANNEL_5:
    {
      /* Check the parameters */
      assert_param(IS_TIM_CC5_INSTANCE(htim->Instance));

      /* Configure the Channel 5 in PWM mode */
      TIM_OC5_SetConfig(htim->Instance, sConfig);

      /* Set the Preload enable bit for channel5*/
      htim->Instance->CCMR3 |= TIM_CCMR3_OC5PE;

      /* Configure the Output Fast mode */
      htim->Instance->CCMR3 &= ~TIM_CCMR3_OC5FE;
      htim->Instance->CCMR3 |= sConfig->OCFastMode;
      break;
    }

    case TIM_CHANNEL_6:
    {
      /* Check the parameters */
      assert_param(IS_TIM_CC6_INSTANCE(htim->Instance));

      /* Configure the Channel 6 in PWM mode */
      TIM_OC6_SetConfig(htim->Instance, sConfig);

      /* Set the Preload enable bit for channel6 */
      htim->Instance->CCMR3 |= TIM_CCMR3_OC6PE;

      /* Configure the Output Fast mode */
      htim->Instance->CCMR3 &= ~TIM_CCMR3_OC6FE;
      htim->Instance->CCMR3 |= sConfig->OCFastMode << 8U;
      break;
    }

    default:
      status = HAL_ERROR;
      break;
  }

  __HAL_UNLOCK(htim);

  return status;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OnePulse_ConfigChannel(TIM_HandleTypeDef *htim,  TIM_OnePulse_InitTypeDef *sConfig,
                                                 uint32_t OutputChannel,  uint32_t InputChannel)
{
  HAL_StatusTypeDef status = HAL_OK;
  TIM_OC_InitTypeDef temp1;

  /* Check the parameters */
  assert_param(IS_TIM_OPM_CHANNELS(OutputChannel));
  assert_param(IS_TIM_OPM_CHANNELS(InputChannel));

  if (OutputChannel != InputChannel)
  {
    /* Process Locked */
    __HAL_LOCK(htim);

    htim->State = HAL_TIM_STATE_BUSY;

    /* Extract the Output compare configuration from sConfig structure */
    temp1.OCMode = sConfig->OCMode;
    temp1.Pulse = sConfig->Pulse;
    temp1.OCPolarity = sConfig->OCPolarity;
    temp1.OCNPolarity = sConfig->OCNPolarity;
    temp1.OCIdleState = sConfig->OCIdleState;
    temp1.OCNIdleState = sConfig->OCNIdleState;

    switch (OutputChannel)
    {
      case TIM_CHANNEL_1:
      {
        assert_param(IS_TIM_CC1_INSTANCE(htim->Instance));

        TIM_OC1_SetConfig(htim->Instance, &temp1);
        break;
      }

      case TIM_CHANNEL_2:
      {
        assert_param(IS_TIM_CC2_INSTANCE(htim->Instance));

        TIM_OC2_SetConfig(htim->Instance, &temp1);
        break;
      }

      default:
        status = HAL_ERROR;
        break;
    }

    if (status == HAL_OK)
    {
      switch (InputChannel)
      {
        case TIM_CHANNEL_1:
        {
          assert_param(IS_TIM_CC1_INSTANCE(htim->Instance));

          TIM_TI1_SetConfig(htim->Instance, sConfig->ICPolarity,
                            sConfig->ICSelection, sConfig->ICFilter);

          /* Reset the IC1PSC Bits */
          htim->Instance->CCMR1 &= ~TIM_CCMR1_IC1PSC;

          /* Select the Trigger source */
          htim->Instance->SMCR &= ~TIM_SMCR_TS;
          htim->Instance->SMCR |= TIM_TS_TI1FP1;

          /* Select the Slave Mode */
          htim->Instance->SMCR &= ~TIM_SMCR_SMS;
          htim->Instance->SMCR |= TIM_SLAVEMODE_TRIGGER;
          break;
        }

        case TIM_CHANNEL_2:
        {
          assert_param(IS_TIM_CC2_INSTANCE(htim->Instance));

          TIM_TI2_SetConfig(htim->Instance, sConfig->ICPolarity,
                            sConfig->ICSelection, sConfig->ICFilter);

          /* Reset the IC2PSC Bits */
          htim->Instance->CCMR1 &= ~TIM_CCMR1_IC2PSC;

          /* Select the Trigger source */
          htim->Instance->SMCR &= ~TIM_SMCR_TS;
          htim->Instance->SMCR |= TIM_TS_TI2FP2;

          /* Select the Slave Mode */
          htim->Instance->SMCR &= ~TIM_SMCR_SMS;
          htim->Instance->SMCR |= TIM_SLAVEMODE_TRIGGER;
          break;
        }

        default:
          status = HAL_ERROR;
          break;
      }
    }

    htim->State = HAL_TIM_STATE_READY;

    __HAL_UNLOCK(htim);

    return status;
  }
  else
  {
    return HAL_ERROR;
  }
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_DMABurst_WriteStart(TIM_HandleTypeDef *htim, uint32_t BurstBaseAddress,
                                              uint32_t BurstRequestSrc, const uint32_t *BurstBuffer,
                                              uint32_t  BurstLength)
{
  HAL_StatusTypeDef status = HAL_OK;
  uint32_t BlockDataLength = 0;
  uint32_t data_width;
  const DMA_HandleTypeDef *hdma = NULL;

  assert_param(IS_TIM_DMA_SOURCE(BurstRequestSrc));

  switch (BurstRequestSrc)
  {
    case TIM_DMA_UPDATE:
    {
      hdma = htim->hdma[TIM_DMA_ID_UPDATE];
      break;
    }
    case TIM_DMA_CC1:
    {
      hdma = htim->hdma[TIM_DMA_ID_CC1];
      break;
    }
    case TIM_DMA_CC2:
    {
      hdma = htim->hdma[TIM_DMA_ID_CC2];
      break;
    }
    case TIM_DMA_CC3:
    {
      hdma = htim->hdma[TIM_DMA_ID_CC3];
      break;
    }
    case TIM_DMA_CC4:
    {
      hdma = htim->hdma[TIM_DMA_ID_CC4];
      break;
    }
    case TIM_DMA_COM:
    {
      hdma = htim->hdma[TIM_DMA_ID_COMMUTATION];
      break;
    }
    case TIM_DMA_TRIGGER:
    {
      hdma = htim->hdma[TIM_DMA_ID_TRIGGER];
      break;
    }
    default:
      status = HAL_ERROR;
      break;
  }

  if (hdma != NULL)
  {

    if (((hdma->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST) && (hdma->LinkedListQueue != 0U)
        && (hdma->LinkedListQueue->Head != 0U))
    {
      data_width = hdma->LinkedListQueue->Head->LinkRegisters[0] & DMA_CTR1_SDW_LOG2;
    }
    else
    {
      data_width = hdma->Init.SrcDataWidth;
    }

    switch (data_width)
    {
      case DMA_SRC_DATAWIDTH_BYTE:
      {
        BlockDataLength = (BurstLength >> TIM_DCR_DBL_Pos) + 1UL;
        break;
      }
      case DMA_SRC_DATAWIDTH_HALFWORD:
      {
        BlockDataLength = ((BurstLength >> TIM_DCR_DBL_Pos) + 1UL) * 2UL;
        break;
      }
      case DMA_SRC_DATAWIDTH_WORD:
      {
        BlockDataLength = ((BurstLength >> TIM_DCR_DBL_Pos) + 1UL) * 4UL;
        break;
      }
      default:
        status = HAL_ERROR;
        break;
    }

    if (status == HAL_OK)
    {
      status = HAL_TIM_DMABurst_MultiWriteStart(htim, BurstBaseAddress, BurstRequestSrc, BurstBuffer, BurstLength,
                                                BlockDataLength);
    }
  }


  return status;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_DMABurst_MultiWriteStart(TIM_HandleTypeDef *htim, uint32_t BurstBaseAddress,
                                                   uint32_t BurstRequestSrc, const uint32_t *BurstBuffer,
                                                   uint32_t  BurstLength,  uint32_t  DataLength)
{
  HAL_StatusTypeDef status = HAL_OK;
  uint32_t tmpDBSS = 0;

  /* Check the parameters */
  assert_param(IS_TIM_DMABURST_INSTANCE(htim->Instance));
  assert_param(IS_TIM_DMA_BASE(BurstBaseAddress));
  assert_param(IS_TIM_DMA_SOURCE(BurstRequestSrc));
  assert_param(IS_TIM_DMA_LENGTH(BurstLength));
  assert_param(IS_TIM_DMA_DATA_LENGTH(DataLength));

  if (htim->DMABurstState == HAL_DMA_BURST_STATE_BUSY)
  {
    return HAL_BUSY;
  }
  else if (htim->DMABurstState == HAL_DMA_BURST_STATE_READY)
  {
    if ((BurstBuffer == NULL) && (BurstLength > 0U))
    {
      return HAL_ERROR;
    }
    else
    {
      htim->DMABurstState = HAL_DMA_BURST_STATE_BUSY;
    }
  }
  else
  {
    /* nothing to do */
  }

  switch (BurstRequestSrc)
  {
    case TIM_DMA_UPDATE:
    {
      /* Set the DMA Period elapsed callbacks */
      htim->hdma[TIM_DMA_ID_UPDATE]->XferCpltCallback = TIM_DMAPeriodElapsedCplt;
      htim->hdma[TIM_DMA_ID_UPDATE]->XferHalfCpltCallback = TIM_DMAPeriodElapsedHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_UPDATE]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_UPDATE], (uint32_t)BurstBuffer,
                           (uint32_t)&htim->Instance->DMAR, DataLength) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      /* Configure the DMA Burst Source Selection */
      tmpDBSS = TIM_DCR_DBSS_0;
      break;
    }
    case TIM_DMA_CC1:
    {
      /* Set the DMA compare callbacks */
      htim->hdma[TIM_DMA_ID_CC1]->XferCpltCallback = TIM_DMADelayPulseCplt;
      htim->hdma[TIM_DMA_ID_CC1]->XferHalfCpltCallback = TIM_DMADelayPulseHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_CC1]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_CC1], (uint32_t)BurstBuffer,
                           (uint32_t)&htim->Instance->DMAR, DataLength) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      /* Configure the DMA Burst Source Selection */
      tmpDBSS = TIM_DCR_DBSS_1;
      break;
    }
    case TIM_DMA_CC2:
    {
      /* Set the DMA compare callbacks */
      htim->hdma[TIM_DMA_ID_CC2]->XferCpltCallback = TIM_DMADelayPulseCplt;
      htim->hdma[TIM_DMA_ID_CC2]->XferHalfCpltCallback = TIM_DMADelayPulseHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_CC2]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_CC2], (uint32_t)BurstBuffer,
                           (uint32_t)&htim->Instance->DMAR, DataLength) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      /* Configure the DMA Burst Source Selection */
      tmpDBSS = (TIM_DCR_DBSS_1 | TIM_DCR_DBSS_0);
      break;
    }
    case TIM_DMA_CC3:
    {
      /* Set the DMA compare callbacks */
      htim->hdma[TIM_DMA_ID_CC3]->XferCpltCallback = TIM_DMADelayPulseCplt;
      htim->hdma[TIM_DMA_ID_CC3]->XferHalfCpltCallback = TIM_DMADelayPulseHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_CC3]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_CC3], (uint32_t)BurstBuffer,
                           (uint32_t)&htim->Instance->DMAR, DataLength) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      /* Configure the DMA Burst Source Selection */
      tmpDBSS = TIM_DCR_DBSS_2;
      break;
    }
    case TIM_DMA_CC4:
    {
      /* Set the DMA compare callbacks */
      htim->hdma[TIM_DMA_ID_CC4]->XferCpltCallback = TIM_DMADelayPulseCplt;
      htim->hdma[TIM_DMA_ID_CC4]->XferHalfCpltCallback = TIM_DMADelayPulseHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_CC4]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_CC4], (uint32_t)BurstBuffer,
                           (uint32_t)&htim->Instance->DMAR, DataLength) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      /* Configure the DMA Burst Source Selection */
      tmpDBSS = (TIM_DCR_DBSS_2 | TIM_DCR_DBSS_0);
      break;
    }
    case TIM_DMA_COM:
    {
      /* Set the DMA commutation callbacks */
      htim->hdma[TIM_DMA_ID_COMMUTATION]->XferCpltCallback =  TIMEx_DMACommutationCplt;
      htim->hdma[TIM_DMA_ID_COMMUTATION]->XferHalfCpltCallback =  TIMEx_DMACommutationHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_COMMUTATION]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_COMMUTATION], (uint32_t)BurstBuffer,
                           (uint32_t)&htim->Instance->DMAR, DataLength) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      /* Configure the DMA Burst Source Selection */
      tmpDBSS = (TIM_DCR_DBSS_2 | TIM_DCR_DBSS_1);
      break;
    }
    case TIM_DMA_TRIGGER:
    {
      /* Set the DMA trigger callbacks */
      htim->hdma[TIM_DMA_ID_TRIGGER]->XferCpltCallback = TIM_DMATriggerCplt;
      htim->hdma[TIM_DMA_ID_TRIGGER]->XferHalfCpltCallback = TIM_DMATriggerHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_TRIGGER]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_TRIGGER], (uint32_t)BurstBuffer,
                           (uint32_t)&htim->Instance->DMAR, DataLength) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      /* Configure the DMA Burst Source Selection */
      tmpDBSS = (TIM_DCR_DBSS_2 | TIM_DCR_DBSS_1 | TIM_DCR_DBSS_0);
      break;
    }
    default:
      status = HAL_ERROR;
      break;
  }

  if (status == HAL_OK)
  {
    /* Configure the DMA Burst Mode */
    htim->Instance->DCR = (BurstBaseAddress | BurstLength | tmpDBSS);
    /* Enable the TIM DMA Request */
    __HAL_TIM_ENABLE_DMA(htim, BurstRequestSrc);
  }

  /* Return function status */
  return status;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_DMABurst_WriteStop(TIM_HandleTypeDef *htim, uint32_t BurstRequestSrc)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the parameters */
  assert_param(IS_TIM_DMA_SOURCE(BurstRequestSrc));

  /* Abort the DMA transfer (at least disable the DMA channel) */
  switch (BurstRequestSrc)
  {
    case TIM_DMA_UPDATE:
    {
      (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_UPDATE]);
      break;
    }
    case TIM_DMA_CC1:
    {
      (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_CC1]);
      break;
    }
    case TIM_DMA_CC2:
    {
      (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_CC2]);
      break;
    }
    case TIM_DMA_CC3:
    {
      (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_CC3]);
      break;
    }
    case TIM_DMA_CC4:
    {
      (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_CC4]);
      break;
    }
    case TIM_DMA_COM:
    {
      (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_COMMUTATION]);
      break;
    }
    case TIM_DMA_TRIGGER:
    {
      (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_TRIGGER]);
      break;
    }
    default:
      status = HAL_ERROR;
      break;
  }

  if (status == HAL_OK)
  {
    /* Disable the TIM Update DMA request */
    __HAL_TIM_DISABLE_DMA(htim, BurstRequestSrc);

    /* Change the DMA burst operation state */
    htim->DMABurstState = HAL_DMA_BURST_STATE_READY;
  }

  /* Return function status */
  return status;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_DMABurst_ReadStart(TIM_HandleTypeDef *htim, uint32_t BurstBaseAddress,
                                             uint32_t BurstRequestSrc, uint32_t  *BurstBuffer, uint32_t  BurstLength)
{
  HAL_StatusTypeDef status = HAL_OK;
  uint32_t BlockDataLength = 0;
  uint32_t data_width;
  const DMA_HandleTypeDef *hdma = NULL;

  assert_param(IS_TIM_DMA_SOURCE(BurstRequestSrc));

  switch (BurstRequestSrc)
  {
    case TIM_DMA_UPDATE:
    {
      hdma = htim->hdma[TIM_DMA_ID_UPDATE];
      break;
    }
    case TIM_DMA_CC1:
    {
      hdma = htim->hdma[TIM_DMA_ID_CC1];
      break;
    }
    case TIM_DMA_CC2:
    {
      hdma = htim->hdma[TIM_DMA_ID_CC2];
      break;
    }
    case TIM_DMA_CC3:
    {
      hdma = htim->hdma[TIM_DMA_ID_CC3];
      break;
    }
    case TIM_DMA_CC4:
    {
      hdma = htim->hdma[TIM_DMA_ID_CC4];
      break;
    }
    case TIM_DMA_COM:
    {
      hdma = htim->hdma[TIM_DMA_ID_COMMUTATION];
      break;
    }
    case TIM_DMA_TRIGGER:
    {
      hdma = htim->hdma[TIM_DMA_ID_TRIGGER];
      break;
    }
    default:
      status = HAL_ERROR;
      break;
  }

  if (hdma != NULL)
  {

    if (((hdma->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST) && (hdma->LinkedListQueue != 0U)
        && (hdma->LinkedListQueue->Head != 0U))
    {
      data_width = hdma->LinkedListQueue->Head->LinkRegisters[0] & DMA_CTR1_SDW_LOG2;
    }
    else
    {
      data_width = hdma->Init.SrcDataWidth;
    }

    switch (data_width)

    {
      case DMA_SRC_DATAWIDTH_BYTE:
      {
        BlockDataLength = ((BurstLength) >> TIM_DCR_DBL_Pos) + 1UL;
        break;
      }
      case DMA_SRC_DATAWIDTH_HALFWORD:
      {
        BlockDataLength = ((BurstLength >> TIM_DCR_DBL_Pos) + 1UL) * 2UL;
        break;
      }
      case DMA_SRC_DATAWIDTH_WORD:
      {
        BlockDataLength = ((BurstLength >> TIM_DCR_DBL_Pos) + 1UL) * 4UL;
        break;
      }
      default:
        status = HAL_ERROR;
        break;
    }

    if (status == HAL_OK)
    {
      status = HAL_TIM_DMABurst_MultiReadStart(htim, BurstBaseAddress, BurstRequestSrc, BurstBuffer, BurstLength,
                                               BlockDataLength);
    }
  }

  return status;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_DMABurst_MultiReadStart(TIM_HandleTypeDef *htim, uint32_t BurstBaseAddress,
                                                  uint32_t BurstRequestSrc, uint32_t  *BurstBuffer,
                                                  uint32_t  BurstLength, uint32_t  DataLength)
{
  HAL_StatusTypeDef status = HAL_OK;
  uint32_t tmpDBSS = 0;

  /* Check the parameters */
  assert_param(IS_TIM_DMABURST_INSTANCE(htim->Instance));
  assert_param(IS_TIM_DMA_BASE(BurstBaseAddress));
  assert_param(IS_TIM_DMA_SOURCE(BurstRequestSrc));
  assert_param(IS_TIM_DMA_LENGTH(BurstLength));
  assert_param(IS_TIM_DMA_DATA_LENGTH(DataLength));

  if (htim->DMABurstState == HAL_DMA_BURST_STATE_BUSY)
  {
    return HAL_BUSY;
  }
  else if (htim->DMABurstState == HAL_DMA_BURST_STATE_READY)
  {
    if ((BurstBuffer == NULL) && (BurstLength > 0U))
    {
      return HAL_ERROR;
    }
    else
    {
      htim->DMABurstState = HAL_DMA_BURST_STATE_BUSY;
    }
  }
  else
  {
    /* nothing to do */
  }
  switch (BurstRequestSrc)
  {
    case TIM_DMA_UPDATE:
    {
      /* Set the DMA Period elapsed callbacks */
      htim->hdma[TIM_DMA_ID_UPDATE]->XferCpltCallback = TIM_DMAPeriodElapsedCplt;
      htim->hdma[TIM_DMA_ID_UPDATE]->XferHalfCpltCallback = TIM_DMAPeriodElapsedHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_UPDATE]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_UPDATE], (uint32_t)&htim->Instance->DMAR, (uint32_t)BurstBuffer,
                           DataLength) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      /* Configure the DMA Burst Source Selection */
      tmpDBSS = TIM_DCR_DBSS_0;
      break;
    }
    case TIM_DMA_CC1:
    {
      /* Set the DMA capture callbacks */
      htim->hdma[TIM_DMA_ID_CC1]->XferCpltCallback = TIM_DMACaptureCplt;
      htim->hdma[TIM_DMA_ID_CC1]->XferHalfCpltCallback = TIM_DMACaptureHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_CC1]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_CC1], (uint32_t)&htim->Instance->DMAR, (uint32_t)BurstBuffer,
                           DataLength) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      /* Configure the DMA Burst Source Selection */
      tmpDBSS =  TIM_DCR_DBSS_1;
      break;
    }
    case TIM_DMA_CC2:
    {
      /* Set the DMA capture callbacks */
      htim->hdma[TIM_DMA_ID_CC2]->XferCpltCallback = TIM_DMACaptureCplt;
      htim->hdma[TIM_DMA_ID_CC2]->XferHalfCpltCallback = TIM_DMACaptureHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_CC2]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_CC2], (uint32_t)&htim->Instance->DMAR, (uint32_t)BurstBuffer,
                           DataLength) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      /* Configure the DMA Burst Source Selection */
      tmpDBSS = (TIM_DCR_DBSS_1 | TIM_DCR_DBSS_0);
      break;
    }
    case TIM_DMA_CC3:
    {
      /* Set the DMA capture callbacks */
      htim->hdma[TIM_DMA_ID_CC3]->XferCpltCallback = TIM_DMACaptureCplt;
      htim->hdma[TIM_DMA_ID_CC3]->XferHalfCpltCallback = TIM_DMACaptureHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_CC3]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_CC3], (uint32_t)&htim->Instance->DMAR, (uint32_t)BurstBuffer,
                           DataLength) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      /* Configure the DMA Burst Source Selection */
      tmpDBSS = TIM_DCR_DBSS_2;
      break;
    }
    case TIM_DMA_CC4:
    {
      /* Set the DMA capture callbacks */
      htim->hdma[TIM_DMA_ID_CC4]->XferCpltCallback = TIM_DMACaptureCplt;
      htim->hdma[TIM_DMA_ID_CC4]->XferHalfCpltCallback = TIM_DMACaptureHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_CC4]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_CC4], (uint32_t)&htim->Instance->DMAR, (uint32_t)BurstBuffer,
                           DataLength) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      /* Configure the DMA Burst Source Selection */
      tmpDBSS = (TIM_DCR_DBSS_2 | TIM_DCR_DBSS_0);
      break;
    }
    case TIM_DMA_COM:
    {
      /* Set the DMA commutation callbacks */
      htim->hdma[TIM_DMA_ID_COMMUTATION]->XferCpltCallback =  TIMEx_DMACommutationCplt;
      htim->hdma[TIM_DMA_ID_COMMUTATION]->XferHalfCpltCallback =  TIMEx_DMACommutationHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_COMMUTATION]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_COMMUTATION], (uint32_t)&htim->Instance->DMAR, (uint32_t)BurstBuffer,
                           DataLength) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      /* Configure the DMA Burst Source Selection */
      tmpDBSS = (TIM_DCR_DBSS_2 | TIM_DCR_DBSS_1);
      break;
    }
    case TIM_DMA_TRIGGER:
    {
      /* Set the DMA trigger callbacks */
      htim->hdma[TIM_DMA_ID_TRIGGER]->XferCpltCallback = TIM_DMATriggerCplt;
      htim->hdma[TIM_DMA_ID_TRIGGER]->XferHalfCpltCallback = TIM_DMATriggerHalfCplt;

      /* Set the DMA error callback */
      htim->hdma[TIM_DMA_ID_TRIGGER]->XferErrorCallback = TIM_DMAError ;

      /* Enable the DMA channel */
      if (TIM_DMA_Start_IT(htim->hdma[TIM_DMA_ID_TRIGGER], (uint32_t)&htim->Instance->DMAR, (uint32_t)BurstBuffer,
                           DataLength) != HAL_OK)
      {
        /* Return error status */
        return HAL_ERROR;
      }
      /* Configure the DMA Burst Source Selection */
      tmpDBSS = (TIM_DCR_DBSS_2 | TIM_DCR_DBSS_1 | TIM_DCR_DBSS_0);
      break;
    }
    default:
      status = HAL_ERROR;
      break;
  }

  if (status == HAL_OK)
  {
    /* Configure the DMA Burst Mode */
    htim->Instance->DCR = (BurstBaseAddress | BurstLength | tmpDBSS);

    /* Enable the TIM DMA Request */
    __HAL_TIM_ENABLE_DMA(htim, BurstRequestSrc);
  }

  /* Return function status */
  return status;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_DMABurst_ReadStop(TIM_HandleTypeDef *htim, uint32_t BurstRequestSrc)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the parameters */
  assert_param(IS_TIM_DMA_SOURCE(BurstRequestSrc));

  /* Abort the DMA transfer (at least disable the DMA channel) */
  switch (BurstRequestSrc)
  {
    case TIM_DMA_UPDATE:
    {
      (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_UPDATE]);
      break;
    }
    case TIM_DMA_CC1:
    {
      (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_CC1]);
      break;
    }
    case TIM_DMA_CC2:
    {
      (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_CC2]);
      break;
    }
    case TIM_DMA_CC3:
    {
      (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_CC3]);
      break;
    }
    case TIM_DMA_CC4:
    {
      (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_CC4]);
      break;
    }
    case TIM_DMA_COM:
    {
      (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_COMMUTATION]);
      break;
    }
    case TIM_DMA_TRIGGER:
    {
      (void)HAL_DMA_Abort_IT(htim->hdma[TIM_DMA_ID_TRIGGER]);
      break;
    }
    default:
      status = HAL_ERROR;
      break;
  }

  if (status == HAL_OK)
  {
    /* Disable the TIM Update DMA request */
    __HAL_TIM_DISABLE_DMA(htim, BurstRequestSrc);

    /* Change the DMA burst operation state */
    htim->DMABurstState = HAL_DMA_BURST_STATE_READY;
  }

  /* Return function status */
  return status;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_GenerateEvent(TIM_HandleTypeDef *htim, uint32_t EventSource)
{
  /* Check the parameters */
  assert_param(IS_TIM_INSTANCE(htim->Instance));
  assert_param(IS_TIM_EVENT_SOURCE(EventSource));

  /* Process Locked */
  __HAL_LOCK(htim);

  /* Change the TIM state */
  htim->State = HAL_TIM_STATE_BUSY;

  /* Set the event sources */
  htim->Instance->EGR = EventSource;

  /* Change the TIM state */
  htim->State = HAL_TIM_STATE_READY;

  __HAL_UNLOCK(htim);

  /* Return function status */
  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_ConfigOCrefClear(TIM_HandleTypeDef *htim,
                                           const TIM_ClearInputConfigTypeDef *sClearInputConfig,
                                           uint32_t Channel)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the parameters */
  assert_param(IS_TIM_OCXREF_CLEAR_INSTANCE(htim->Instance));
  assert_param(IS_TIM_CLEARINPUT_SOURCE(sClearInputConfig->ClearInputSource));

  /* Process Locked */
  __HAL_LOCK(htim);

  htim->State = HAL_TIM_STATE_BUSY;

  switch (sClearInputConfig->ClearInputSource)
  {
    case TIM_CLEARINPUTSOURCE_NONE:
    {
      /* Clear the OCREF clear selection bit and the the ETR Bits */
      CLEAR_BIT(htim->Instance->SMCR, (TIM_SMCR_ETF | TIM_SMCR_ETPS | TIM_SMCR_ECE | TIM_SMCR_ETP));
      break;
    }

    case TIM_CLEARINPUTSOURCE_ETR:
    {
      /* Check the parameters */
      assert_param(IS_TIM_CLEARINPUT_POLARITY(sClearInputConfig->ClearInputPolarity));
      assert_param(IS_TIM_CLEARINPUT_PRESCALER(sClearInputConfig->ClearInputPrescaler));
      assert_param(IS_TIM_CLEARINPUT_FILTER(sClearInputConfig->ClearInputFilter));

      /* When OCRef clear feature is used with ETR source, ETR prescaler must be off */
      if (sClearInputConfig->ClearInputPrescaler != TIM_CLEARINPUTPRESCALER_DIV1)
      {
        htim->State = HAL_TIM_STATE_READY;
        __HAL_UNLOCK(htim);
        return HAL_ERROR;
      }

      TIM_ETR_SetConfig(htim->Instance,
                        sClearInputConfig->ClearInputPrescaler,
                        sClearInputConfig->ClearInputPolarity,
                        sClearInputConfig->ClearInputFilter);
      break;
    }

    default:
      status = HAL_ERROR;
      break;
  }

  if (status == HAL_OK)
  {
    switch (Channel)
    {
      case TIM_CHANNEL_1:
      {
        if (sClearInputConfig->ClearInputState != (uint32_t)DISABLE)
        {
          /* Enable the OCREF clear feature for Channel 1 */
          SET_BIT(htim->Instance->CCMR1, TIM_CCMR1_OC1CE);
        }
        else
        {
          /* Disable the OCREF clear feature for Channel 1 */
          CLEAR_BIT(htim->Instance->CCMR1, TIM_CCMR1_OC1CE);
        }
        break;
      }
      case TIM_CHANNEL_2:
      {
        if (sClearInputConfig->ClearInputState != (uint32_t)DISABLE)
        {
          /* Enable the OCREF clear feature for Channel 2 */
          SET_BIT(htim->Instance->CCMR1, TIM_CCMR1_OC2CE);
        }
        else
        {
          /* Disable the OCREF clear feature for Channel 2 */
          CLEAR_BIT(htim->Instance->CCMR1, TIM_CCMR1_OC2CE);
        }
        break;
      }
      case TIM_CHANNEL_3:
      {
        if (sClearInputConfig->ClearInputState != (uint32_t)DISABLE)
        {
          /* Enable the OCREF clear feature for Channel 3 */
          SET_BIT(htim->Instance->CCMR2, TIM_CCMR2_OC3CE);
        }
        else
        {
          /* Disable the OCREF clear feature for Channel 3 */
          CLEAR_BIT(htim->Instance->CCMR2, TIM_CCMR2_OC3CE);
        }
        break;
      }
      case TIM_CHANNEL_4:
      {
        if (sClearInputConfig->ClearInputState != (uint32_t)DISABLE)
        {
          /* Enable the OCREF clear feature for Channel 4 */
          SET_BIT(htim->Instance->CCMR2, TIM_CCMR2_OC4CE);
        }
        else
        {
          /* Disable the OCREF clear feature for Channel 4 */
          CLEAR_BIT(htim->Instance->CCMR2, TIM_CCMR2_OC4CE);
        }
        break;
      }
      case TIM_CHANNEL_5:
      {
        if (sClearInputConfig->ClearInputState != (uint32_t)DISABLE)
        {
          /* Enable the OCREF clear feature for Channel 5 */
          SET_BIT(htim->Instance->CCMR3, TIM_CCMR3_OC5CE);
        }
        else
        {
          /* Disable the OCREF clear feature for Channel 5 */
          CLEAR_BIT(htim->Instance->CCMR3, TIM_CCMR3_OC5CE);
        }
        break;
      }
      case TIM_CHANNEL_6:
      {
        if (sClearInputConfig->ClearInputState != (uint32_t)DISABLE)
        {
          /* Enable the OCREF clear feature for Channel 6 */
          SET_BIT(htim->Instance->CCMR3, TIM_CCMR3_OC6CE);
        }
        else
        {
          /* Disable the OCREF clear feature for Channel 6 */
          CLEAR_BIT(htim->Instance->CCMR3, TIM_CCMR3_OC6CE);
        }
        break;
      }
      default:
        break;
    }
  }

  htim->State = HAL_TIM_STATE_READY;

  __HAL_UNLOCK(htim);

  return status;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_ConfigClockSource(TIM_HandleTypeDef *htim, const TIM_ClockConfigTypeDef *sClockSourceConfig)
{
  HAL_StatusTypeDef status = HAL_OK;
  uint32_t tmpsmcr;

  /* Process Locked */
  __HAL_LOCK(htim);

  htim->State = HAL_TIM_STATE_BUSY;

  /* Check the parameters */
  assert_param(IS_TIM_CLOCKSOURCE(sClockSourceConfig->ClockSource));

  /* Reset the SMS, TS, ECE, ETPS and ETRF bits */
  tmpsmcr = htim->Instance->SMCR;
  tmpsmcr &= ~(TIM_SMCR_SMS | TIM_SMCR_TS);
  tmpsmcr &= ~(TIM_SMCR_ETF | TIM_SMCR_ETPS | TIM_SMCR_ECE | TIM_SMCR_ETP);
  htim->Instance->SMCR = tmpsmcr;

  switch (sClockSourceConfig->ClockSource)
  {
    case TIM_CLOCKSOURCE_INTERNAL:
    {
      assert_param(IS_TIM_INSTANCE(htim->Instance));
      break;
    }

    case TIM_CLOCKSOURCE_ETRMODE1:
    {
      /* Check whether or not the timer instance supports external trigger input mode 1 (ETRF)*/
      assert_param(IS_TIM_CLOCKSOURCE_ETRMODE1_INSTANCE(htim->Instance));

      /* Check ETR input conditioning related parameters */
      assert_param(IS_TIM_CLOCKPRESCALER(sClockSourceConfig->ClockPrescaler));
      assert_param(IS_TIM_CLOCKPOLARITY(sClockSourceConfig->ClockPolarity));
      assert_param(IS_TIM_CLOCKFILTER(sClockSourceConfig->ClockFilter));

      /* Configure the ETR Clock source */
      TIM_ETR_SetConfig(htim->Instance,
                        sClockSourceConfig->ClockPrescaler,
                        sClockSourceConfig->ClockPolarity,
                        sClockSourceConfig->ClockFilter);

      /* Select the External clock mode1 and the ETRF trigger */
      tmpsmcr = htim->Instance->SMCR;
      tmpsmcr |= (TIM_SLAVEMODE_EXTERNAL1 | TIM_CLOCKSOURCE_ETRMODE1);
      /* Write to TIMx SMCR */
      htim->Instance->SMCR = tmpsmcr;
      break;
    }

    case TIM_CLOCKSOURCE_ETRMODE2:
    {
      /* Check whether or not the timer instance supports external trigger input mode 2 (ETRF)*/
      assert_param(IS_TIM_CLOCKSOURCE_ETRMODE2_INSTANCE(htim->Instance));

      /* Check ETR input conditioning related parameters */
      assert_param(IS_TIM_CLOCKPRESCALER(sClockSourceConfig->ClockPrescaler));
      assert_param(IS_TIM_CLOCKPOLARITY(sClockSourceConfig->ClockPolarity));
      assert_param(IS_TIM_CLOCKFILTER(sClockSourceConfig->ClockFilter));

      /* Configure the ETR Clock source */
      TIM_ETR_SetConfig(htim->Instance,
                        sClockSourceConfig->ClockPrescaler,
                        sClockSourceConfig->ClockPolarity,
                        sClockSourceConfig->ClockFilter);
      /* Enable the External clock mode2 */
      htim->Instance->SMCR |= TIM_SMCR_ECE;
      break;
    }

    case TIM_CLOCKSOURCE_TI1:
    {
      /* Check whether or not the timer instance supports external clock mode 1 */
      assert_param(IS_TIM_CLOCKSOURCE_TIX_INSTANCE(htim->Instance));

      /* Check TI1 input conditioning related parameters */
      assert_param(IS_TIM_CLOCKPOLARITY(sClockSourceConfig->ClockPolarity));
      assert_param(IS_TIM_CLOCKFILTER(sClockSourceConfig->ClockFilter));

      TIM_TI1_ConfigInputStage(htim->Instance,
                               sClockSourceConfig->ClockPolarity,
                               sClockSourceConfig->ClockFilter);
      TIM_ITRx_SetConfig(htim->Instance, TIM_CLOCKSOURCE_TI1);
      break;
    }

    case TIM_CLOCKSOURCE_TI2:
    {
      /* Check whether or not the timer instance supports external clock mode 1 (ETRF)*/
      assert_param(IS_TIM_CLOCKSOURCE_TIX_INSTANCE(htim->Instance));

      /* Check TI2 input conditioning related parameters */
      assert_param(IS_TIM_CLOCKPOLARITY(sClockSourceConfig->ClockPolarity));
      assert_param(IS_TIM_CLOCKFILTER(sClockSourceConfig->ClockFilter));

      TIM_TI2_ConfigInputStage(htim->Instance,
                               sClockSourceConfig->ClockPolarity,
                               sClockSourceConfig->ClockFilter);
      TIM_ITRx_SetConfig(htim->Instance, TIM_CLOCKSOURCE_TI2);
      break;
    }

    case TIM_CLOCKSOURCE_TI1ED:
    {
      /* Check whether or not the timer instance supports external clock mode 1 */
      assert_param(IS_TIM_CLOCKSOURCE_TIX_INSTANCE(htim->Instance));

      /* Check TI1 input conditioning related parameters */
      assert_param(IS_TIM_CLOCKPOLARITY(sClockSourceConfig->ClockPolarity));
      assert_param(IS_TIM_CLOCKFILTER(sClockSourceConfig->ClockFilter));

      TIM_TI1_ConfigInputStage(htim->Instance,
                               sClockSourceConfig->ClockPolarity,
                               sClockSourceConfig->ClockFilter);
      TIM_ITRx_SetConfig(htim->Instance, TIM_CLOCKSOURCE_TI1ED);
      break;
    }

    case TIM_CLOCKSOURCE_ITR0:
    case TIM_CLOCKSOURCE_ITR1:
    case TIM_CLOCKSOURCE_ITR2:
    case TIM_CLOCKSOURCE_ITR3:
    case TIM_CLOCKSOURCE_ITR4:
    case TIM_CLOCKSOURCE_ITR5:
    case TIM_CLOCKSOURCE_ITR6:
    case TIM_CLOCKSOURCE_ITR7:
    case TIM_CLOCKSOURCE_ITR8:
    case TIM_CLOCKSOURCE_ITR9:
    case TIM_CLOCKSOURCE_ITR10:
    case TIM_CLOCKSOURCE_ITR11:
    case TIM_CLOCKSOURCE_ITR13:
    case TIM_CLOCKSOURCE_ITR14:
    {
      /* Check whether or not the timer instance supports internal trigger input */
      assert_param(IS_TIM_CLOCKSOURCE_INSTANCE((htim->Instance), sClockSourceConfig->ClockSource));

      TIM_ITRx_SetConfig(htim->Instance, sClockSourceConfig->ClockSource);
      break;
    }

    default:
      status = HAL_ERROR;
      break;
  }
  htim->State = HAL_TIM_STATE_READY;

  __HAL_UNLOCK(htim);

  return status;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_ConfigTI1Input(TIM_HandleTypeDef *htim, uint32_t TI1_Selection)
{
  uint32_t tmpcr2;

  /* Check the parameters */
  assert_param(IS_TIM_XOR_INSTANCE(htim->Instance));
  assert_param(IS_TIM_TI1SELECTION(TI1_Selection));

  /* Get the TIMx CR2 register value */
  tmpcr2 = htim->Instance->CR2;

  /* Reset the TI1 selection */
  tmpcr2 &= ~TIM_CR2_TI1S;

  /* Set the TI1 selection */
  tmpcr2 |= TI1_Selection;

  /* Write to TIMxCR2 */
  htim->Instance->CR2 = tmpcr2;

  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_SlaveConfigSynchro(TIM_HandleTypeDef *htim, const TIM_SlaveConfigTypeDef *sSlaveConfig)
{
  /* Check the parameters */
  assert_param(IS_TIM_SLAVE_INSTANCE(htim->Instance));
  assert_param(IS_TIM_SLAVE_MODE(sSlaveConfig->SlaveMode));
  assert_param(IS_TIM_TRIGGER_INSTANCE(htim->Instance, sSlaveConfig->InputTrigger));

  __HAL_LOCK(htim);

  htim->State = HAL_TIM_STATE_BUSY;

  if (TIM_SlaveTimer_SetConfig(htim, sSlaveConfig) != HAL_OK)
  {
    htim->State = HAL_TIM_STATE_READY;
    __HAL_UNLOCK(htim);
    return HAL_ERROR;
  }

  /* Disable Trigger Interrupt */
  __HAL_TIM_DISABLE_IT(htim, TIM_IT_TRIGGER);

  /* Disable Trigger DMA request */
  __HAL_TIM_DISABLE_DMA(htim, TIM_DMA_TRIGGER);

  htim->State = HAL_TIM_STATE_READY;

  __HAL_UNLOCK(htim);

  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_SlaveConfigSynchro_IT(TIM_HandleTypeDef *htim,
                                                const TIM_SlaveConfigTypeDef *sSlaveConfig)
{
  /* Check the parameters */
  assert_param(IS_TIM_SLAVE_INSTANCE(htim->Instance));
  assert_param(IS_TIM_SLAVE_MODE(sSlaveConfig->SlaveMode));
  assert_param(IS_TIM_TRIGGER_INSTANCE(htim->Instance, sSlaveConfig->InputTrigger));

  __HAL_LOCK(htim);

  htim->State = HAL_TIM_STATE_BUSY;

  if (TIM_SlaveTimer_SetConfig(htim, sSlaveConfig) != HAL_OK)
  {
    htim->State = HAL_TIM_STATE_READY;
    __HAL_UNLOCK(htim);
    return HAL_ERROR;
  }

  /* Enable Trigger Interrupt */
  __HAL_TIM_ENABLE_IT(htim, TIM_IT_TRIGGER);

  /* Disable Trigger DMA request */
  __HAL_TIM_DISABLE_DMA(htim, TIM_DMA_TRIGGER);

  htim->State = HAL_TIM_STATE_READY;

  __HAL_UNLOCK(htim);

  return HAL_OK;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
uint32_t HAL_TIM_ReadCapturedValue(const TIM_HandleTypeDef *htim, uint32_t Channel)
{
  uint32_t tmpreg = 0U;

  switch (Channel)
  {
    case TIM_CHANNEL_1:
    {
      /* Check the parameters */
      assert_param(IS_TIM_CC1_INSTANCE(htim->Instance));

      /* Return the capture 1 value */
      tmpreg =  htim->Instance->CCR1;

      break;
    }
    case TIM_CHANNEL_2:
    {
      /* Check the parameters */
      assert_param(IS_TIM_CC2_INSTANCE(htim->Instance));

      /* Return the capture 2 value */
      tmpreg =   htim->Instance->CCR2;

      break;
    }

    case TIM_CHANNEL_3:
    {
      /* Check the parameters */
      assert_param(IS_TIM_CC3_INSTANCE(htim->Instance));

      /* Return the capture 3 value */
      tmpreg =   htim->Instance->CCR3;

      break;
    }

    case TIM_CHANNEL_4:
    {
      /* Check the parameters */
      assert_param(IS_TIM_CC4_INSTANCE(htim->Instance));

      /* Return the capture 4 value */
      tmpreg =   htim->Instance->CCR4;

      break;
    }

    default:
      break;
  }

  return tmpreg;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef TIM_DMA_Start_IT(DMA_HandleTypeDef *hdma, uint32_t src, uint32_t dst,
                                   uint32_t length)
{
  HAL_StatusTypeDef status ;

  /* Enable the DMA channel */
  if ((hdma->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
  {
    if ((hdma->LinkedListQueue != 0U) && (hdma->LinkedListQueue->Head != 0U))
    {
      /* Enable the DMA channel */
      hdma->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = length;
      hdma->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = src;
      hdma->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = dst;

      status = HAL_DMAEx_List_Start_IT(hdma);
    }
    else
    {
      status = HAL_ERROR;
    }
  }
  else
  {
    status = HAL_DMA_Start_IT(hdma, src, dst, length);
  }

  return status;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_TIM_RegisterCallback(TIM_HandleTypeDef *htim, HAL_TIM_CallbackIDTypeDef CallbackID,
                                           pTIM_CallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    return HAL_ERROR;
  }

  if (htim->State == HAL_TIM_STATE_READY)
  {
    switch (CallbackID)
    {
      case HAL_TIM_BASE_MSPINIT_CB_ID :
        htim->Base_MspInitCallback                 = pCallback;
        break;

      case HAL_TIM_BASE_MSPDEINIT_CB_ID :
        htim->Base_MspDeInitCallback               = pCallback;
        break;

      case HAL_TIM_IC_MSPINIT_CB_ID :
        htim->IC_MspInitCallback                   = pCallback;
        break;

      case HAL_TIM_IC_MSPDEINIT_CB_ID :
        htim->IC_MspDeInitCallback                 = pCallback;
        break;

      case HAL_TIM_OC_MSPINIT_CB_ID :
        htim->OC_MspInitCallback                   = pCallback;
        break;

      case HAL_TIM_OC_MSPDEINIT_CB_ID :
        htim->OC_MspDeInitCallback                 = pCallback;
        break;

      case HAL_TIM_PWM_MSPINIT_CB_ID :
        htim->PWM_MspInitCallback                  = pCallback;
        break;

      case HAL_TIM_PWM_MSPDEINIT_CB_ID :
        htim->PWM_MspDeInitCallback                = pCallback;
        break;

      case HAL_TIM_ONE_PULSE_MSPINIT_CB_ID :
        htim->OnePulse_MspInitCallback             = pCallback;
        break;

      case HAL_TIM_ONE_PULSE_MSPDEINIT_CB_ID :
        htim->OnePulse_MspDeInitCallback           = pCallback;
        break;

      case HAL_TIM_ENCODER_MSPINIT_CB_ID :
        htim->Encoder_MspInitCallback              = pCallback;
        break;

      case HAL_TIM_ENCODER_MSPDEINIT_CB_ID :
        htim->Encoder_MspDeInitCallback            = pCallback;
        break;

      case HAL_TIM_HALL_SENSOR_MSPINIT_CB_ID :
        htim->HallSensor_MspInitCallback           = pCallback;
        break;

      case HAL_TIM_HALL_SENSOR_MSPDEINIT_CB_ID :
        htim->HallSensor_MspDeInitCallback         = pCallback;
        break;

      case HAL_TIM_PERIOD_ELAPSED_CB_ID :
        htim->PeriodElapsedCallback                = pCallback;
        break;

      case HAL_TIM_PERIOD_ELAPSED_HALF_CB_ID :
        htim->PeriodElapsedHalfCpltCallback        = pCallback;
        break;

      case HAL_TIM_TRIGGER_CB_ID :
        htim->TriggerCallback                      = pCallback;
        break;

      case HAL_TIM_TRIGGER_HALF_CB_ID :
        htim->TriggerHalfCpltCallback              = pCallback;
        break;

      case HAL_TIM_IC_CAPTURE_CB_ID :
        htim->IC_CaptureCallback                   = pCallback;
        break;

      case HAL_TIM_IC_CAPTURE_HALF_CB_ID :
        htim->IC_CaptureHalfCpltCallback           = pCallback;
        break;

      case HAL_TIM_OC_DELAY_ELAPSED_CB_ID :
        htim->OC_DelayElapsedCallback              = pCallback;
        break;

      case HAL_TIM_PWM_PULSE_FINISHED_CB_ID :
        htim->PWM_PulseFinishedCallback            = pCallback;
        break;

      case HAL_TIM_PWM_PULSE_FINISHED_HALF_CB_ID :
        htim->PWM_PulseFinishedHalfCpltCallback    = pCallback;
        break;

      case HAL_TIM_ERROR_CB_ID :
        htim->ErrorCallback                        = pCallback;
        break;

      case HAL_TIM_COMMUTATION_CB_ID :
        htim->CommutationCallback                  = pCallback;
        break;

      case HAL_TIM_COMMUTATION_HALF_CB_ID :
        htim->CommutationHalfCpltCallback          = pCallback;
        break;

      case HAL_TIM_BREAK_CB_ID :
        htim->BreakCallback                        = pCallback;
        break;

      case HAL_TIM_BREAK2_CB_ID :
        htim->Break2Callback                       = pCallback;
        break;

      case HAL_TIM_ENCODER_INDEX_CB_ID :
        htim->EncoderIndexCallback                 = pCallback;
        break;

      case HAL_TIM_DIRECTION_CHANGE_CB_ID :
        htim->DirectionChangeCallback              = pCallback;
        break;

      case HAL_TIM_INDEX_ERROR_CB_ID :
        htim->IndexErrorCallback                   = pCallback;
        break;

      case HAL_TIM_TRANSITION_ERROR_CB_ID :
        htim->TransitionErrorCallback              = pCallback;
        break;

      default :
        /* Return error status */
        status = HAL_ERROR;
        break;
    }
  }
  else if (htim->State == HAL_TIM_STATE_RESET)
  {
    switch (CallbackID)
    {
      case HAL_TIM_BASE_MSPINIT_CB_ID :
        htim->Base_MspInitCallback         = pCallback;
        break;

      case HAL_TIM_BASE_MSPDEINIT_CB_ID :
        htim->Base_MspDeInitCallback       = pCallback;
        break;

      case HAL_TIM_IC_MSPINIT_CB_ID :
        htim->IC_MspInitCallback           = pCallback;
        break;

      case HAL_TIM_IC_MSPDEINIT_CB_ID :
        htim->IC_MspDeInitCallback         = pCallback;
        break;

      case HAL_TIM_OC_MSPINIT_CB_ID :
        htim->OC_MspInitCallback           = pCallback;
        break;

      case HAL_TIM_OC_MSPDEINIT_CB_ID :
        htim->OC_MspDeInitCallback         = pCallback;
        break;

      case HAL_TIM_PWM_MSPINIT_CB_ID :
        htim->PWM_MspInitCallback          = pCallback;
        break;

      case HAL_TIM_PWM_MSPDEINIT_CB_ID :
        htim->PWM_MspDeInitCallback        = pCallback;
        break;

      case HAL_TIM_ONE_PULSE_MSPINIT_CB_ID :
        htim->OnePulse_MspInitCallback     = pCallback;
        break;

      case HAL_TIM_ONE_PULSE_MSPDEINIT_CB_ID :
        htim->OnePulse_MspDeInitCallback   = pCallback;
        break;

      case HAL_TIM_ENCODER_MSPINIT_CB_ID :
        htim->Encoder_MspInitCallback      = pCallback;
        break;

      case HAL_TIM_ENCODER_MSPDEINIT_CB_ID :
        htim->Encoder_MspDeInitCallback    = pCallback;
        break;

      case HAL_TIM_HALL_SENSOR_MSPINIT_CB_ID :
        htim->HallSensor_MspInitCallback   = pCallback;
        break;

      case HAL_TIM_HALL_SENSOR_MSPDEINIT_CB_ID :
        htim->HallSensor_MspDeInitCallback = pCallback;
        break;

      default :
        /* Return error status */
        status = HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Return error status */
    status = HAL_ERROR;
  }

  return status;
}
#endif
#endif

#ifdef HAL_TIM_MODULE_ENABLED
#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_TIM_UnRegisterCallback(TIM_HandleTypeDef *htim, HAL_TIM_CallbackIDTypeDef CallbackID)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (htim->State == HAL_TIM_STATE_READY)
  {
    switch (CallbackID)
    {
      case HAL_TIM_BASE_MSPINIT_CB_ID :
        /* Legacy weak Base MspInit Callback */
        htim->Base_MspInitCallback              = HAL_TIM_Base_MspInit;
        break;

      case HAL_TIM_BASE_MSPDEINIT_CB_ID :
        /* Legacy weak Base Msp DeInit Callback */
        htim->Base_MspDeInitCallback            = HAL_TIM_Base_MspDeInit;
        break;

      case HAL_TIM_IC_MSPINIT_CB_ID :
        /* Legacy weak IC Msp Init Callback */
        htim->IC_MspInitCallback                = HAL_TIM_IC_MspInit;
        break;

      case HAL_TIM_IC_MSPDEINIT_CB_ID :
        /* Legacy weak IC Msp DeInit Callback */
        htim->IC_MspDeInitCallback              = HAL_TIM_IC_MspDeInit;
        break;

      case HAL_TIM_OC_MSPINIT_CB_ID :
        /* Legacy weak OC Msp Init Callback */
        htim->OC_MspInitCallback                = HAL_TIM_OC_MspInit;
        break;

      case HAL_TIM_OC_MSPDEINIT_CB_ID :
        /* Legacy weak OC Msp DeInit Callback */
        htim->OC_MspDeInitCallback              = HAL_TIM_OC_MspDeInit;
        break;

      case HAL_TIM_PWM_MSPINIT_CB_ID :
        /* Legacy weak PWM Msp Init Callback */
        htim->PWM_MspInitCallback               = HAL_TIM_PWM_MspInit;
        break;

      case HAL_TIM_PWM_MSPDEINIT_CB_ID :
        /* Legacy weak PWM Msp DeInit Callback */
        htim->PWM_MspDeInitCallback             = HAL_TIM_PWM_MspDeInit;
        break;

      case HAL_TIM_ONE_PULSE_MSPINIT_CB_ID :
        /* Legacy weak One Pulse Msp Init Callback */
        htim->OnePulse_MspInitCallback          = HAL_TIM_OnePulse_MspInit;
        break;

      case HAL_TIM_ONE_PULSE_MSPDEINIT_CB_ID :
        /* Legacy weak One Pulse Msp DeInit Callback */
        htim->OnePulse_MspDeInitCallback        = HAL_TIM_OnePulse_MspDeInit;
        break;

      case HAL_TIM_ENCODER_MSPINIT_CB_ID :
        /* Legacy weak Encoder Msp Init Callback */
        htim->Encoder_MspInitCallback           = HAL_TIM_Encoder_MspInit;
        break;

      case HAL_TIM_ENCODER_MSPDEINIT_CB_ID :
        /* Legacy weak Encoder Msp DeInit Callback */
        htim->Encoder_MspDeInitCallback         = HAL_TIM_Encoder_MspDeInit;
        break;

      case HAL_TIM_HALL_SENSOR_MSPINIT_CB_ID :
        /* Legacy weak Hall Sensor Msp Init Callback */
        htim->HallSensor_MspInitCallback        = HAL_TIMEx_HallSensor_MspInit;
        break;

      case HAL_TIM_HALL_SENSOR_MSPDEINIT_CB_ID :
        /* Legacy weak Hall Sensor Msp DeInit Callback */
        htim->HallSensor_MspDeInitCallback      = HAL_TIMEx_HallSensor_MspDeInit;
        break;

      case HAL_TIM_PERIOD_ELAPSED_CB_ID :
        /* Legacy weak Period Elapsed Callback */
        htim->PeriodElapsedCallback             = HAL_TIM_PeriodElapsedCallback;
        break;

      case HAL_TIM_PERIOD_ELAPSED_HALF_CB_ID :
        /* Legacy weak Period Elapsed half complete Callback */
        htim->PeriodElapsedHalfCpltCallback     = HAL_TIM_PeriodElapsedHalfCpltCallback;
        break;

      case HAL_TIM_TRIGGER_CB_ID :
        /* Legacy weak Trigger Callback */
        htim->TriggerCallback                   = HAL_TIM_TriggerCallback;
        break;

      case HAL_TIM_TRIGGER_HALF_CB_ID :
        /* Legacy weak Trigger half complete Callback */
        htim->TriggerHalfCpltCallback           = HAL_TIM_TriggerHalfCpltCallback;
        break;

      case HAL_TIM_IC_CAPTURE_CB_ID :
        /* Legacy weak IC Capture Callback */
        htim->IC_CaptureCallback                = HAL_TIM_IC_CaptureCallback;
        break;

      case HAL_TIM_IC_CAPTURE_HALF_CB_ID :
        /* Legacy weak IC Capture half complete Callback */
        htim->IC_CaptureHalfCpltCallback        = HAL_TIM_IC_CaptureHalfCpltCallback;
        break;

      case HAL_TIM_OC_DELAY_ELAPSED_CB_ID :
        /* Legacy weak OC Delay Elapsed Callback */
        htim->OC_DelayElapsedCallback           = HAL_TIM_OC_DelayElapsedCallback;
        break;

      case HAL_TIM_PWM_PULSE_FINISHED_CB_ID :
        /* Legacy weak PWM Pulse Finished Callback */
        htim->PWM_PulseFinishedCallback         = HAL_TIM_PWM_PulseFinishedCallback;
        break;

      case HAL_TIM_PWM_PULSE_FINISHED_HALF_CB_ID :
        /* Legacy weak PWM Pulse Finished half complete Callback */
        htim->PWM_PulseFinishedHalfCpltCallback = HAL_TIM_PWM_PulseFinishedHalfCpltCallback;
        break;

      case HAL_TIM_ERROR_CB_ID :
        /* Legacy weak Error Callback */
        htim->ErrorCallback                     = HAL_TIM_ErrorCallback;
        break;

      case HAL_TIM_COMMUTATION_CB_ID :
        /* Legacy weak Commutation Callback */
        htim->CommutationCallback               = HAL_TIMEx_CommutCallback;
        break;

      case HAL_TIM_COMMUTATION_HALF_CB_ID :
        /* Legacy weak Commutation half complete Callback */
        htim->CommutationHalfCpltCallback       = HAL_TIMEx_CommutHalfCpltCallback;
        break;

      case HAL_TIM_BREAK_CB_ID :
        /* Legacy weak Break Callback */
        htim->BreakCallback                     = HAL_TIMEx_BreakCallback;
        break;

      case HAL_TIM_BREAK2_CB_ID :
        /* Legacy weak Break2 Callback */
        htim->Break2Callback                    = HAL_TIMEx_Break2Callback;
        break;

      case HAL_TIM_ENCODER_INDEX_CB_ID :
        /* Legacy weak Encoder Index Callback */
        htim->EncoderIndexCallback              = HAL_TIMEx_EncoderIndexCallback;
        break;

      case HAL_TIM_DIRECTION_CHANGE_CB_ID :
        /* Legacy weak Direction Change Callback */
        htim->DirectionChangeCallback           = HAL_TIMEx_DirectionChangeCallback;
        break;

      case HAL_TIM_INDEX_ERROR_CB_ID :
        /* Legacy weak Index Error Callback */
        htim->IndexErrorCallback                = HAL_TIMEx_IndexErrorCallback;
        break;

      case HAL_TIM_TRANSITION_ERROR_CB_ID :
        /* Legacy weak Transition Error Callback */
        htim->TransitionErrorCallback           = HAL_TIMEx_TransitionErrorCallback;
        break;

      default :
        /* Return error status */
        status = HAL_ERROR;
        break;
    }
  }
  else if (htim->State == HAL_TIM_STATE_RESET)
  {
    switch (CallbackID)
    {
      case HAL_TIM_BASE_MSPINIT_CB_ID :
        /* Legacy weak Base MspInit Callback */
        htim->Base_MspInitCallback         = HAL_TIM_Base_MspInit;
        break;

      case HAL_TIM_BASE_MSPDEINIT_CB_ID :
        /* Legacy weak Base Msp DeInit Callback */
        htim->Base_MspDeInitCallback       = HAL_TIM_Base_MspDeInit;
        break;

      case HAL_TIM_IC_MSPINIT_CB_ID :
        /* Legacy weak IC Msp Init Callback */
        htim->IC_MspInitCallback           = HAL_TIM_IC_MspInit;
        break;

      case HAL_TIM_IC_MSPDEINIT_CB_ID :
        /* Legacy weak IC Msp DeInit Callback */
        htim->IC_MspDeInitCallback         = HAL_TIM_IC_MspDeInit;
        break;

      case HAL_TIM_OC_MSPINIT_CB_ID :
        /* Legacy weak OC Msp Init Callback */
        htim->OC_MspInitCallback           = HAL_TIM_OC_MspInit;
        break;

      case HAL_TIM_OC_MSPDEINIT_CB_ID :
        /* Legacy weak OC Msp DeInit Callback */
        htim->OC_MspDeInitCallback         = HAL_TIM_OC_MspDeInit;
        break;

      case HAL_TIM_PWM_MSPINIT_CB_ID :
        /* Legacy weak PWM Msp Init Callback */
        htim->PWM_MspInitCallback          = HAL_TIM_PWM_MspInit;
        break;

      case HAL_TIM_PWM_MSPDEINIT_CB_ID :
        /* Legacy weak PWM Msp DeInit Callback */
        htim->PWM_MspDeInitCallback        = HAL_TIM_PWM_MspDeInit;
        break;

      case HAL_TIM_ONE_PULSE_MSPINIT_CB_ID :
        /* Legacy weak One Pulse Msp Init Callback */
        htim->OnePulse_MspInitCallback     = HAL_TIM_OnePulse_MspInit;
        break;

      case HAL_TIM_ONE_PULSE_MSPDEINIT_CB_ID :
        /* Legacy weak One Pulse Msp DeInit Callback */
        htim->OnePulse_MspDeInitCallback   = HAL_TIM_OnePulse_MspDeInit;
        break;

      case HAL_TIM_ENCODER_MSPINIT_CB_ID :
        /* Legacy weak Encoder Msp Init Callback */
        htim->Encoder_MspInitCallback      = HAL_TIM_Encoder_MspInit;
        break;

      case HAL_TIM_ENCODER_MSPDEINIT_CB_ID :
        /* Legacy weak Encoder Msp DeInit Callback */
        htim->Encoder_MspDeInitCallback    = HAL_TIM_Encoder_MspDeInit;
        break;

      case HAL_TIM_HALL_SENSOR_MSPINIT_CB_ID :
        /* Legacy weak Hall Sensor Msp Init Callback */
        htim->HallSensor_MspInitCallback   = HAL_TIMEx_HallSensor_MspInit;
        break;

      case HAL_TIM_HALL_SENSOR_MSPDEINIT_CB_ID :
        /* Legacy weak Hall Sensor Msp DeInit Callback */
        htim->HallSensor_MspDeInitCallback = HAL_TIMEx_HallSensor_MspDeInit;
        break;

      default :
        /* Return error status */
        status = HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Return error status */
    status = HAL_ERROR;
  }

  return status;
}
#endif
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_TIM_StateTypeDef HAL_TIM_Base_GetState(const TIM_HandleTypeDef *htim)
{
  return htim->State;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_TIM_StateTypeDef HAL_TIM_OC_GetState(const TIM_HandleTypeDef *htim)
{
  return htim->State;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_TIM_StateTypeDef HAL_TIM_PWM_GetState(const TIM_HandleTypeDef *htim)
{
  return htim->State;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_TIM_StateTypeDef HAL_TIM_IC_GetState(const TIM_HandleTypeDef *htim)
{
  return htim->State;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_TIM_StateTypeDef HAL_TIM_OnePulse_GetState(const TIM_HandleTypeDef *htim)
{
  return htim->State;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_TIM_StateTypeDef HAL_TIM_Encoder_GetState(const TIM_HandleTypeDef *htim)
{
  return htim->State;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_TIM_ActiveChannel HAL_TIM_GetActiveChannel(const TIM_HandleTypeDef *htim)
{
  return htim->Channel;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_TIM_ChannelStateTypeDef HAL_TIM_GetChannelState(const TIM_HandleTypeDef *htim,  uint32_t Channel)
{
  HAL_TIM_ChannelStateTypeDef channel_state;

  /* Check the parameters */
  assert_param(IS_TIM_CCX_INSTANCE(htim->Instance, Channel));

  channel_state = TIM_CHANNEL_STATE_GET(htim, Channel);

  return channel_state;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_TIM_DMABurstStateTypeDef HAL_TIM_DMABurstState(const TIM_HandleTypeDef *htim)
{
  /* Check the parameters */
  assert_param(IS_TIM_DMABURST_INSTANCE(htim->Instance));

  return htim->DMABurstState;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
void TIM_DMAError(DMA_HandleTypeDef *hdma)
{
  TIM_HandleTypeDef *htim = (TIM_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  if (hdma == htim->hdma[TIM_DMA_ID_CC1])
  {
    htim->Channel = HAL_TIM_ACTIVE_CHANNEL_1;
    TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_1, HAL_TIM_CHANNEL_STATE_READY);
  }
  else if (hdma == htim->hdma[TIM_DMA_ID_CC2])
  {
    htim->Channel = HAL_TIM_ACTIVE_CHANNEL_2;
    TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_2, HAL_TIM_CHANNEL_STATE_READY);
  }
  else if (hdma == htim->hdma[TIM_DMA_ID_CC3])
  {
    htim->Channel = HAL_TIM_ACTIVE_CHANNEL_3;
    TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_3, HAL_TIM_CHANNEL_STATE_READY);
  }
  else if (hdma == htim->hdma[TIM_DMA_ID_CC4])
  {
    htim->Channel = HAL_TIM_ACTIVE_CHANNEL_4;
    TIM_CHANNEL_STATE_SET(htim, TIM_CHANNEL_4, HAL_TIM_CHANNEL_STATE_READY);
  }
  else
  {
    htim->State = HAL_TIM_STATE_READY;
  }

#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
  htim->ErrorCallback(htim);
#else
  HAL_TIM_ErrorCallback(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */

  htim->Channel = HAL_TIM_ACTIVE_CHANNEL_CLEARED;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_DMADelayPulseCplt(DMA_HandleTypeDef *hdma)
{
  TIM_HandleTypeDef *htim = (TIM_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  if (hdma == htim->hdma[TIM_DMA_ID_CC1])
  {
    htim->Channel = HAL_TIM_ACTIVE_CHANNEL_1;
  }
  else if (hdma == htim->hdma[TIM_DMA_ID_CC2])
  {
    htim->Channel = HAL_TIM_ACTIVE_CHANNEL_2;
  }
  else if (hdma == htim->hdma[TIM_DMA_ID_CC3])
  {
    htim->Channel = HAL_TIM_ACTIVE_CHANNEL_3;
  }
  else if (hdma == htim->hdma[TIM_DMA_ID_CC4])
  {
    htim->Channel = HAL_TIM_ACTIVE_CHANNEL_4;
  }
  else
  {
    /* nothing to do */
  }

#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
  htim->PWM_PulseFinishedCallback(htim);
#else
  HAL_TIM_PWM_PulseFinishedCallback(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */

  htim->Channel = HAL_TIM_ACTIVE_CHANNEL_CLEARED;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
void TIM_DMADelayPulseHalfCplt(DMA_HandleTypeDef *hdma)
{
  TIM_HandleTypeDef *htim = (TIM_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  if (hdma == htim->hdma[TIM_DMA_ID_CC1])
  {
    htim->Channel = HAL_TIM_ACTIVE_CHANNEL_1;
  }
  else if (hdma == htim->hdma[TIM_DMA_ID_CC2])
  {
    htim->Channel = HAL_TIM_ACTIVE_CHANNEL_2;
  }
  else if (hdma == htim->hdma[TIM_DMA_ID_CC3])
  {
    htim->Channel = HAL_TIM_ACTIVE_CHANNEL_3;
  }
  else if (hdma == htim->hdma[TIM_DMA_ID_CC4])
  {
    htim->Channel = HAL_TIM_ACTIVE_CHANNEL_4;
  }
  else
  {
    /* nothing to do */
  }

#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
  htim->PWM_PulseFinishedHalfCpltCallback(htim);
#else
  HAL_TIM_PWM_PulseFinishedHalfCpltCallback(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */

  htim->Channel = HAL_TIM_ACTIVE_CHANNEL_CLEARED;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
void TIM_DMACaptureCplt(DMA_HandleTypeDef *hdma)
{
  TIM_HandleTypeDef *htim = (TIM_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  if (hdma == htim->hdma[TIM_DMA_ID_CC1])
  {
    htim->Channel = HAL_TIM_ACTIVE_CHANNEL_1;
  }
  else if (hdma == htim->hdma[TIM_DMA_ID_CC2])
  {
    htim->Channel = HAL_TIM_ACTIVE_CHANNEL_2;
  }
  else if (hdma == htim->hdma[TIM_DMA_ID_CC3])
  {
    htim->Channel = HAL_TIM_ACTIVE_CHANNEL_3;
  }
  else if (hdma == htim->hdma[TIM_DMA_ID_CC4])
  {
    htim->Channel = HAL_TIM_ACTIVE_CHANNEL_4;
  }
  else
  {
    /* nothing to do */
  }

#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
  htim->IC_CaptureCallback(htim);
#else
  HAL_TIM_IC_CaptureCallback(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */

  htim->Channel = HAL_TIM_ACTIVE_CHANNEL_CLEARED;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
void TIM_DMACaptureHalfCplt(DMA_HandleTypeDef *hdma)
{
  TIM_HandleTypeDef *htim = (TIM_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  if (hdma == htim->hdma[TIM_DMA_ID_CC1])
  {
    htim->Channel = HAL_TIM_ACTIVE_CHANNEL_1;
  }
  else if (hdma == htim->hdma[TIM_DMA_ID_CC2])
  {
    htim->Channel = HAL_TIM_ACTIVE_CHANNEL_2;
  }
  else if (hdma == htim->hdma[TIM_DMA_ID_CC3])
  {
    htim->Channel = HAL_TIM_ACTIVE_CHANNEL_3;
  }
  else if (hdma == htim->hdma[TIM_DMA_ID_CC4])
  {
    htim->Channel = HAL_TIM_ACTIVE_CHANNEL_4;
  }
  else
  {
    /* nothing to do */
  }

#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
  htim->IC_CaptureHalfCpltCallback(htim);
#else
  HAL_TIM_IC_CaptureHalfCpltCallback(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */

  htim->Channel = HAL_TIM_ACTIVE_CHANNEL_CLEARED;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_DMAPeriodElapsedCplt(DMA_HandleTypeDef *hdma)
{
  TIM_HandleTypeDef *htim = (TIM_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
  htim->PeriodElapsedCallback(htim);
#else
  HAL_TIM_PeriodElapsedCallback(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_DMAPeriodElapsedHalfCplt(DMA_HandleTypeDef *hdma)
{
  TIM_HandleTypeDef *htim = (TIM_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
  htim->PeriodElapsedHalfCpltCallback(htim);
#else
  HAL_TIM_PeriodElapsedHalfCpltCallback(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_DMATriggerCplt(DMA_HandleTypeDef *hdma)
{
  TIM_HandleTypeDef *htim = (TIM_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
  htim->TriggerCallback(htim);
#else
  HAL_TIM_TriggerCallback(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_DMATriggerHalfCplt(DMA_HandleTypeDef *hdma)
{
  TIM_HandleTypeDef *htim = (TIM_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
  htim->TriggerHalfCpltCallback(htim);
#else
  HAL_TIM_TriggerHalfCpltCallback(htim);
#endif /* USE_HAL_TIM_REGISTER_CALLBACKS */
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
void TIM_Base_SetConfig(TIM_TypeDef *TIMx, const TIM_Base_InitTypeDef *Structure)
{
  uint32_t tmpcr1;
  tmpcr1 = TIMx->CR1;

  /* Set TIM Time Base Unit parameters ---------------------------------------*/
  if (IS_TIM_COUNTER_MODE_SELECT_INSTANCE(TIMx))
  {
    /* Select the Counter Mode */
    tmpcr1 &= ~(TIM_CR1_DIR | TIM_CR1_CMS);
    tmpcr1 |= Structure->CounterMode;
  }

  if (IS_TIM_CLOCK_DIVISION_INSTANCE(TIMx))
  {
    /* Set the clock division */
    tmpcr1 &= ~TIM_CR1_CKD;
    tmpcr1 |= (uint32_t)Structure->ClockDivision;
  }

  /* Set the auto-reload preload */
  MODIFY_REG(tmpcr1, TIM_CR1_ARPE, Structure->AutoReloadPreload);

  /* Set the Autoreload value */
  TIMx->ARR = (uint32_t)Structure->Period ;

  /* Set the Prescaler value */
  TIMx->PSC = Structure->Prescaler;

  if (IS_TIM_REPETITION_COUNTER_INSTANCE(TIMx))
  {
    /* Set the Repetition Counter value */
    TIMx->RCR = Structure->RepetitionCounter;
  }

  /* Disable Update Event (UEV) with Update Generation (UG)
     by changing Update Request Source (URS) to avoid Update flag (UIF) */
  SET_BIT(TIMx->CR1, TIM_CR1_URS);

  /* Generate an update event to reload the Prescaler
     and the repetition counter (only for advanced timer) value immediately */
  TIMx->EGR = TIM_EGR_UG;

  TIMx->CR1 = tmpcr1;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_OC1_SetConfig(TIM_TypeDef *TIMx, const TIM_OC_InitTypeDef *OC_Config)
{
  uint32_t tmpccmrx;
  uint32_t tmpccer;
  uint32_t tmpcr2;

  /* Get the TIMx CCER register value */
  tmpccer = TIMx->CCER;

  /* Disable the Channel 1: Reset the CC1E Bit */
  TIMx->CCER &= ~TIM_CCER_CC1E;

  /* Get the TIMx CR2 register value */
  tmpcr2 =  TIMx->CR2;

  /* Get the TIMx CCMR1 register value */
  tmpccmrx = TIMx->CCMR1;

  /* Reset the Output Compare Mode Bits */
  tmpccmrx &= ~TIM_CCMR1_OC1M;
  tmpccmrx &= ~TIM_CCMR1_CC1S;
  /* Select the Output Compare Mode */
  tmpccmrx |= OC_Config->OCMode;

  /* Reset the Output Polarity level */
  tmpccer &= ~TIM_CCER_CC1P;
  /* Set the Output Compare Polarity */
  tmpccer |= OC_Config->OCPolarity;

  if (IS_TIM_CCXN_INSTANCE(TIMx, TIM_CHANNEL_1))
  {
    /* Check parameters */
    assert_param(IS_TIM_OCN_POLARITY(OC_Config->OCNPolarity));

    /* Disable the Channel 1N: Reset the CC1NE Bit */
    TIMx->CCER &= ~TIM_CCER_CC1NE;

    /* Reset the Output N Polarity level */
    tmpccer &= ~TIM_CCER_CC1NP;
    /* Set the Output N Polarity */
    tmpccer |= OC_Config->OCNPolarity;
  }

  if (IS_TIM_BREAK_INSTANCE(TIMx))
  {
    /* Check parameters */
    assert_param(IS_TIM_OCNIDLE_STATE(OC_Config->OCNIdleState));
    assert_param(IS_TIM_OCIDLE_STATE(OC_Config->OCIdleState));

    /* Reset the Output Compare and Output Compare N IDLE State */
    tmpcr2 &= ~TIM_CR2_OIS1;
    tmpcr2 &= ~TIM_CR2_OIS1N;
    /* Set the Output Idle state */
    tmpcr2 |= OC_Config->OCIdleState;
    /* Set the Output N Idle state */
    tmpcr2 |= OC_Config->OCNIdleState;
  }

  /* Write to TIMx CR2 */
  TIMx->CR2 = tmpcr2;

  /* Write to TIMx CCMR1 */
  TIMx->CCMR1 = tmpccmrx;

  /* Set the Capture Compare Register value */
  TIMx->CCR1 = OC_Config->Pulse;

  /* Write to TIMx CCER */
  TIMx->CCER = tmpccer;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
void TIM_OC2_SetConfig(TIM_TypeDef *TIMx, const TIM_OC_InitTypeDef *OC_Config)
{
  uint32_t tmpccmrx;
  uint32_t tmpccer;
  uint32_t tmpcr2;

  /* Get the TIMx CCER register value */
  tmpccer = TIMx->CCER;

  /* Disable the Channel 2: Reset the CC2E Bit */
  TIMx->CCER &= ~TIM_CCER_CC2E;

  /* Get the TIMx CR2 register value */
  tmpcr2 =  TIMx->CR2;

  /* Get the TIMx CCMR1 register value */
  tmpccmrx = TIMx->CCMR1;

  /* Reset the Output Compare mode and Capture/Compare selection Bits */
  tmpccmrx &= ~TIM_CCMR1_OC2M;
  tmpccmrx &= ~TIM_CCMR1_CC2S;

  /* Select the Output Compare Mode */
  tmpccmrx |= (OC_Config->OCMode << 8U);

  /* Reset the Output Polarity level */
  tmpccer &= ~TIM_CCER_CC2P;
  /* Set the Output Compare Polarity */
  tmpccer |= (OC_Config->OCPolarity << 4U);

  if (IS_TIM_CCXN_INSTANCE(TIMx, TIM_CHANNEL_2))
  {
    assert_param(IS_TIM_OCN_POLARITY(OC_Config->OCNPolarity));

    /* Disable the Channel 2N: Reset the CC2NE Bit */
    TIMx->CCER &= ~TIM_CCER_CC2NE;

    /* Reset the Output N Polarity level */
    tmpccer &= ~TIM_CCER_CC2NP;
    /* Set the Output N Polarity */
    tmpccer |= (OC_Config->OCNPolarity << 4U);
  }

  if (IS_TIM_BREAK_INSTANCE(TIMx))
  {
    /* Check parameters */
    assert_param(IS_TIM_OCNIDLE_STATE(OC_Config->OCNIdleState));
    assert_param(IS_TIM_OCIDLE_STATE(OC_Config->OCIdleState));

    /* Reset the Output Compare and Output Compare N IDLE State */
    tmpcr2 &= ~TIM_CR2_OIS2;
    tmpcr2 &= ~TIM_CR2_OIS2N;
    /* Set the Output Idle state */
    tmpcr2 |= (OC_Config->OCIdleState << 2U);
    /* Set the Output N Idle state */
    tmpcr2 |= (OC_Config->OCNIdleState << 2U);
  }

  /* Write to TIMx CR2 */
  TIMx->CR2 = tmpcr2;

  /* Write to TIMx CCMR1 */
  TIMx->CCMR1 = tmpccmrx;

  /* Set the Capture Compare Register value */
  TIMx->CCR2 = OC_Config->Pulse;

  /* Write to TIMx CCER */
  TIMx->CCER = tmpccer;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_OC3_SetConfig(TIM_TypeDef *TIMx, const TIM_OC_InitTypeDef *OC_Config)
{
  uint32_t tmpccmrx;
  uint32_t tmpccer;
  uint32_t tmpcr2;

  /* Get the TIMx CCER register value */
  tmpccer = TIMx->CCER;

  /* Disable the Channel 3: Reset the CC2E Bit */
  TIMx->CCER &= ~TIM_CCER_CC3E;

  /* Get the TIMx CR2 register value */
  tmpcr2 =  TIMx->CR2;

  /* Get the TIMx CCMR2 register value */
  tmpccmrx = TIMx->CCMR2;

  /* Reset the Output Compare mode and Capture/Compare selection Bits */
  tmpccmrx &= ~TIM_CCMR2_OC3M;
  tmpccmrx &= ~TIM_CCMR2_CC3S;
  /* Select the Output Compare Mode */
  tmpccmrx |= OC_Config->OCMode;

  /* Reset the Output Polarity level */
  tmpccer &= ~TIM_CCER_CC3P;
  /* Set the Output Compare Polarity */
  tmpccer |= (OC_Config->OCPolarity << 8U);

  if (IS_TIM_CCXN_INSTANCE(TIMx, TIM_CHANNEL_3))
  {
    assert_param(IS_TIM_OCN_POLARITY(OC_Config->OCNPolarity));

    /* Disable the Channel 3N: Reset the CC3NE Bit */
    TIMx->CCER &= ~TIM_CCER_CC3NE;

    /* Reset the Output N Polarity level */
    tmpccer &= ~TIM_CCER_CC3NP;
    /* Set the Output N Polarity */
    tmpccer |= (OC_Config->OCNPolarity << 8U);
  }

  if (IS_TIM_BREAK_INSTANCE(TIMx))
  {
    /* Check parameters */
    assert_param(IS_TIM_OCNIDLE_STATE(OC_Config->OCNIdleState));
    assert_param(IS_TIM_OCIDLE_STATE(OC_Config->OCIdleState));

    /* Reset the Output Compare and Output Compare N IDLE State */
    tmpcr2 &= ~TIM_CR2_OIS3;
    tmpcr2 &= ~TIM_CR2_OIS3N;
    /* Set the Output Idle state */
    tmpcr2 |= (OC_Config->OCIdleState << 4U);
    /* Set the Output N Idle state */
    tmpcr2 |= (OC_Config->OCNIdleState << 4U);
  }

  /* Write to TIMx CR2 */
  TIMx->CR2 = tmpcr2;

  /* Write to TIMx CCMR2 */
  TIMx->CCMR2 = tmpccmrx;

  /* Set the Capture Compare Register value */
  TIMx->CCR3 = OC_Config->Pulse;

  /* Write to TIMx CCER */
  TIMx->CCER = tmpccer;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_OC4_SetConfig(TIM_TypeDef *TIMx, const TIM_OC_InitTypeDef *OC_Config)
{
  uint32_t tmpccmrx;
  uint32_t tmpccer;
  uint32_t tmpcr2;

  /* Get the TIMx CCER register value */
  tmpccer = TIMx->CCER;

  /* Disable the Channel 4: Reset the CC4E Bit */
  TIMx->CCER &= ~TIM_CCER_CC4E;

  /* Get the TIMx CR2 register value */
  tmpcr2 =  TIMx->CR2;

  /* Get the TIMx CCMR2 register value */
  tmpccmrx = TIMx->CCMR2;

  /* Reset the Output Compare mode and Capture/Compare selection Bits */
  tmpccmrx &= ~TIM_CCMR2_OC4M;
  tmpccmrx &= ~TIM_CCMR2_CC4S;

  /* Select the Output Compare Mode */
  tmpccmrx |= (OC_Config->OCMode << 8U);

  /* Reset the Output Polarity level */
  tmpccer &= ~TIM_CCER_CC4P;
  /* Set the Output Compare Polarity */
  tmpccer |= (OC_Config->OCPolarity << 12U);

  if (IS_TIM_CCXN_INSTANCE(TIMx, TIM_CHANNEL_4))
  {
    assert_param(IS_TIM_OCN_POLARITY(OC_Config->OCNPolarity));

    /* Disable the Channel 4N: Reset the CC4NE Bit */
    TIMx->CCER &= ~TIM_CCER_CC4NE;

    /* Reset the Output N Polarity level */
    tmpccer &= ~TIM_CCER_CC4NP;
    /* Set the Output N Polarity */
    tmpccer |= (OC_Config->OCNPolarity << 12U);
  }

  if (IS_TIM_BREAK_INSTANCE(TIMx))
  {
    /* Check parameters */
    assert_param(IS_TIM_OCNIDLE_STATE(OC_Config->OCNIdleState));
    assert_param(IS_TIM_OCIDLE_STATE(OC_Config->OCIdleState));

    /* Reset the Output Compare IDLE State */
    tmpcr2 &= ~TIM_CR2_OIS4;
    /* Reset the Output Compare N IDLE State */
    tmpcr2 &= ~TIM_CR2_OIS4N;

    /* Set the Output Idle state */
    tmpcr2 |= (OC_Config->OCIdleState << 6U);
    /* Set the Output N Idle state */
    tmpcr2 |= (OC_Config->OCNIdleState << 6U);
  }

  /* Write to TIMx CR2 */
  TIMx->CR2 = tmpcr2;

  /* Write to TIMx CCMR2 */
  TIMx->CCMR2 = tmpccmrx;

  /* Set the Capture Compare Register value */
  TIMx->CCR4 = OC_Config->Pulse;

  /* Write to TIMx CCER */
  TIMx->CCER = tmpccer;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_OC5_SetConfig(TIM_TypeDef *TIMx,
                              const TIM_OC_InitTypeDef *OC_Config)
{
  uint32_t tmpccmrx;
  uint32_t tmpccer;
  uint32_t tmpcr2;

  /* Get the TIMx CCER register value */
  tmpccer = TIMx->CCER;

  /* Disable the output: Reset the CCxE Bit */
  TIMx->CCER &= ~TIM_CCER_CC5E;

  /* Get the TIMx CR2 register value */
  tmpcr2 =  TIMx->CR2;
  /* Get the TIMx CCMR1 register value */
  tmpccmrx = TIMx->CCMR3;

  /* Reset the Output Compare Mode Bits */
  tmpccmrx &= ~(TIM_CCMR3_OC5M);
  /* Select the Output Compare Mode */
  tmpccmrx |= OC_Config->OCMode;

  /* Reset the Output Polarity level */
  tmpccer &= ~TIM_CCER_CC5P;
  /* Set the Output Compare Polarity */
  tmpccer |= (OC_Config->OCPolarity << 16U);

  if (IS_TIM_BREAK_INSTANCE(TIMx))
  {
    /* Reset the Output Compare IDLE State */
    tmpcr2 &= ~TIM_CR2_OIS5;
    /* Set the Output Idle state */
    tmpcr2 |= (OC_Config->OCIdleState << 8U);
  }
  /* Write to TIMx CR2 */
  TIMx->CR2 = tmpcr2;

  /* Write to TIMx CCMR3 */
  TIMx->CCMR3 = tmpccmrx;

  /* Set the Capture Compare Register value */
  TIMx->CCR5 = OC_Config->Pulse;

  /* Write to TIMx CCER */
  TIMx->CCER = tmpccer;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_OC6_SetConfig(TIM_TypeDef *TIMx,
                              const TIM_OC_InitTypeDef *OC_Config)
{
  uint32_t tmpccmrx;
  uint32_t tmpccer;
  uint32_t tmpcr2;

  /* Get the TIMx CCER register value */
  tmpccer = TIMx->CCER;

  /* Disable the output: Reset the CCxE Bit */
  TIMx->CCER &= ~TIM_CCER_CC6E;

  /* Get the TIMx CR2 register value */
  tmpcr2 =  TIMx->CR2;
  /* Get the TIMx CCMR1 register value */
  tmpccmrx = TIMx->CCMR3;

  /* Reset the Output Compare Mode Bits */
  tmpccmrx &= ~(TIM_CCMR3_OC6M);
  /* Select the Output Compare Mode */
  tmpccmrx |= (OC_Config->OCMode << 8U);

  /* Reset the Output Polarity level */
  tmpccer &= (uint32_t)~TIM_CCER_CC6P;
  /* Set the Output Compare Polarity */
  tmpccer |= (OC_Config->OCPolarity << 20U);

  if (IS_TIM_BREAK_INSTANCE(TIMx))
  {
    /* Reset the Output Compare IDLE State */
    tmpcr2 &= ~TIM_CR2_OIS6;
    /* Set the Output Idle state */
    tmpcr2 |= (OC_Config->OCIdleState << 10U);
  }

  /* Write to TIMx CR2 */
  TIMx->CR2 = tmpcr2;

  /* Write to TIMx CCMR3 */
  TIMx->CCMR3 = tmpccmrx;

  /* Set the Capture Compare Register value */
  TIMx->CCR6 = OC_Config->Pulse;

  /* Write to TIMx CCER */
  TIMx->CCER = tmpccer;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static HAL_StatusTypeDef TIM_SlaveTimer_SetConfig(TIM_HandleTypeDef *htim,
                                                  const TIM_SlaveConfigTypeDef *sSlaveConfig)
{
  HAL_StatusTypeDef status = HAL_OK;
  uint32_t tmpsmcr;
  uint32_t tmpccmr1;
  uint32_t tmpccer;

  /* Get the TIMx SMCR register value */
  tmpsmcr = htim->Instance->SMCR;

  /* Reset the Trigger Selection Bits */
  tmpsmcr &= ~TIM_SMCR_TS;
  /* Set the Input Trigger source */
  tmpsmcr |= sSlaveConfig->InputTrigger;

  /* Reset the slave mode Bits */
  tmpsmcr &= ~TIM_SMCR_SMS;
  /* Set the slave mode */
  tmpsmcr |= sSlaveConfig->SlaveMode;

  /* Write to TIMx SMCR */
  htim->Instance->SMCR = tmpsmcr;

  /* Configure the trigger prescaler, filter, and polarity */
  switch (sSlaveConfig->InputTrigger)
  {
    case TIM_TS_ETRF:
    {
      /* Check the parameters */
      assert_param(IS_TIM_CLOCKSOURCE_ETRMODE1_INSTANCE(htim->Instance));
      assert_param(IS_TIM_TRIGGERPRESCALER(sSlaveConfig->TriggerPrescaler));
      assert_param(IS_TIM_TRIGGERPOLARITY(sSlaveConfig->TriggerPolarity));
      assert_param(IS_TIM_TRIGGERFILTER(sSlaveConfig->TriggerFilter));
      /* Configure the ETR Trigger source */
      TIM_ETR_SetConfig(htim->Instance,
                        sSlaveConfig->TriggerPrescaler,
                        sSlaveConfig->TriggerPolarity,
                        sSlaveConfig->TriggerFilter);
      break;
    }

    case TIM_TS_TI1F_ED:
    {
      /* Check the parameters */
      assert_param(IS_TIM_CC1_INSTANCE(htim->Instance));
      assert_param(IS_TIM_TRIGGERFILTER(sSlaveConfig->TriggerFilter));

      if ((sSlaveConfig->SlaveMode == TIM_SLAVEMODE_GATED) || \
          (sSlaveConfig->SlaveMode == TIM_SLAVEMODE_COMBINED_GATEDRESET))
      {
        return HAL_ERROR;
      }

      /* Disable the Channel 1: Reset the CC1E Bit */
      tmpccer = htim->Instance->CCER;
      htim->Instance->CCER &= ~TIM_CCER_CC1E;
      tmpccmr1 = htim->Instance->CCMR1;

      /* Set the filter */
      tmpccmr1 &= ~TIM_CCMR1_IC1F;
      tmpccmr1 |= ((sSlaveConfig->TriggerFilter) << 4U);

      /* Write to TIMx CCMR1 and CCER registers */
      htim->Instance->CCMR1 = tmpccmr1;
      htim->Instance->CCER = tmpccer;
      break;
    }

    case TIM_TS_TI1FP1:
    {
      /* Check the parameters */
      assert_param(IS_TIM_CC1_INSTANCE(htim->Instance));
      assert_param(IS_TIM_TRIGGERPOLARITY(sSlaveConfig->TriggerPolarity));
      assert_param(IS_TIM_TRIGGERFILTER(sSlaveConfig->TriggerFilter));

      /* Configure TI1 Filter and Polarity */
      TIM_TI1_ConfigInputStage(htim->Instance,
                               sSlaveConfig->TriggerPolarity,
                               sSlaveConfig->TriggerFilter);
      break;
    }

    case TIM_TS_TI2FP2:
    {
      /* Check the parameters */
      assert_param(IS_TIM_CC2_INSTANCE(htim->Instance));
      assert_param(IS_TIM_TRIGGERPOLARITY(sSlaveConfig->TriggerPolarity));
      assert_param(IS_TIM_TRIGGERFILTER(sSlaveConfig->TriggerFilter));

      /* Configure TI2 Filter and Polarity */
      TIM_TI2_ConfigInputStage(htim->Instance,
                               sSlaveConfig->TriggerPolarity,
                               sSlaveConfig->TriggerFilter);
      break;
    }

    case TIM_TS_ITR0:
    case TIM_TS_ITR1:
    case TIM_TS_ITR2:
    case TIM_TS_ITR3:
    case TIM_TS_ITR4:
    case TIM_TS_ITR5:
    case TIM_TS_ITR6:
    case TIM_TS_ITR7:
    case TIM_TS_ITR8:
    case TIM_TS_ITR9:
    case TIM_TS_ITR10:
    case TIM_TS_ITR11:
    case TIM_TS_ITR13:
    case TIM_TS_ITR14:
    {
      /* Check the parameter */
      assert_param(IS_TIM_INTERNAL_TRIGGEREVENT_INSTANCE((htim->Instance), sSlaveConfig->InputTrigger));
      break;
    }

    default:
      status = HAL_ERROR;
      break;
  }

  return status;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
void TIM_TI1_SetConfig(TIM_TypeDef *TIMx, uint32_t TIM_ICPolarity, uint32_t TIM_ICSelection,
                       uint32_t TIM_ICFilter)
{
  uint32_t tmpccmr1;
  uint32_t tmpccer;

  /* Get the TIMx CCER register value */
  tmpccer = TIMx->CCER;

  /* Disable the Channel 1: Reset the CC1E Bit */
  TIMx->CCER &= ~TIM_CCER_CC1E;
  /* Disable the Channel 1N: Reset the CC1NE Bit */
  if (IS_TIM_CCXN_INSTANCE(TIMx, TIM_CHANNEL_1))
  {
    TIMx->CCER &= ~TIM_CCER_CC1NE;
  }

  /* Get the TIMx CCMR1 register value */
  tmpccmr1 = TIMx->CCMR1;

  /* Select the Input */
  if (IS_TIM_CC2_INSTANCE(TIMx) != RESET)
  {
    tmpccmr1 &= ~TIM_CCMR1_CC1S;
    tmpccmr1 |= TIM_ICSelection;
  }
  else
  {
    tmpccmr1 |= TIM_CCMR1_CC1S_0;
  }

  /* Set the filter */
  tmpccmr1 &= ~TIM_CCMR1_IC1F;
  tmpccmr1 |= ((TIM_ICFilter << 4U) & TIM_CCMR1_IC1F);

  /* Select the Polarity and set the CC1E Bit */
  tmpccer &= ~(TIM_CCER_CC1P | TIM_CCER_CC1NP);
  tmpccer |= (TIM_ICPolarity & (TIM_CCER_CC1P | TIM_CCER_CC1NP));

  /* Write to TIMx CCMR1 and CCER registers */
  TIMx->CCMR1 = tmpccmr1;
  TIMx->CCER = tmpccer;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_TI1_ConfigInputStage(TIM_TypeDef *TIMx, uint32_t TIM_ICPolarity, uint32_t TIM_ICFilter)
{
  uint32_t tmpccmr1;
  uint32_t tmpccer;

  /* Get the TIMx CCER register value */
  tmpccer = TIMx->CCER;

  /* Disable the Channel 1: Reset the CC1E Bit */
  TIMx->CCER &= ~TIM_CCER_CC1E;
  /* Disable the Channel 1N: Reset the CC1NE Bit */
  if (IS_TIM_CCXN_INSTANCE(TIMx, TIM_CHANNEL_1))
  {
    TIMx->CCER &= ~TIM_CCER_CC1NE;
  }

  /* Get the TIMx CCMR1 register value */
  tmpccmr1 = TIMx->CCMR1;

  /* Set the filter */
  tmpccmr1 &= ~TIM_CCMR1_IC1F;
  tmpccmr1 |= (TIM_ICFilter << 4U);

  /* Select the Polarity and set the CC1E Bit */
  tmpccer &= ~(TIM_CCER_CC1P | TIM_CCER_CC1NP);
  tmpccer |= TIM_ICPolarity;

  /* Write to TIMx CCMR1 and CCER registers */
  TIMx->CCMR1 = tmpccmr1;
  TIMx->CCER = tmpccer;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_TI2_SetConfig(TIM_TypeDef *TIMx, uint32_t TIM_ICPolarity, uint32_t TIM_ICSelection,
                              uint32_t TIM_ICFilter)
{
  uint32_t tmpccmr1;
  uint32_t tmpccer;

  /* Get the TIMx CCER register value */
  tmpccer = TIMx->CCER;

  /* Disable the Channel 2: Reset the CC2E Bit */
  TIMx->CCER &= ~TIM_CCER_CC2E;
  /* Disable the Channel 2N: Reset the CC2NE Bit */
  if (IS_TIM_CCXN_INSTANCE(TIMx, TIM_CHANNEL_2))
  {
    TIMx->CCER &= ~TIM_CCER_CC2NE;
  }

  /* Get the TIMx CCMR1 register value */
  tmpccmr1 = TIMx->CCMR1;

  /* Select the Input */
  tmpccmr1 &= ~TIM_CCMR1_CC2S;
  tmpccmr1 |= (TIM_ICSelection << 8U);

  /* Set the filter */
  tmpccmr1 &= ~TIM_CCMR1_IC2F;
  tmpccmr1 |= ((TIM_ICFilter << 12U) & TIM_CCMR1_IC2F);

  /* Select the Polarity and set the CC2E Bit */
  tmpccer &= ~(TIM_CCER_CC2P | TIM_CCER_CC2NP);
  tmpccer |= ((TIM_ICPolarity << 4U) & (TIM_CCER_CC2P | TIM_CCER_CC2NP));

  /* Write to TIMx CCMR1 and CCER registers */
  TIMx->CCMR1 = tmpccmr1 ;
  TIMx->CCER = tmpccer;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_TI2_ConfigInputStage(TIM_TypeDef *TIMx, uint32_t TIM_ICPolarity, uint32_t TIM_ICFilter)
{
  uint32_t tmpccmr1;
  uint32_t tmpccer;

  /* Get the TIMx CCER register value */
  tmpccer = TIMx->CCER;

  /* Disable the Channel 2: Reset the CC2E Bit */
  TIMx->CCER &= ~TIM_CCER_CC2E;
  /* Disable the Channel 2N: Reset the CC2NE Bit */
  if (IS_TIM_CCXN_INSTANCE(TIMx, TIM_CHANNEL_2))
  {
    TIMx->CCER &= ~TIM_CCER_CC2NE;
  }

  /* Get the TIMx CCMR1 register value */
  tmpccmr1 = TIMx->CCMR1;

  /* Set the filter */
  tmpccmr1 &= ~TIM_CCMR1_IC2F;
  tmpccmr1 |= (TIM_ICFilter << 12U);

  /* Select the Polarity and set the CC2E Bit */
  tmpccer &= ~(TIM_CCER_CC2P | TIM_CCER_CC2NP);
  tmpccer |= (TIM_ICPolarity << 4U);

  /* Write to TIMx CCMR1 and CCER registers */
  TIMx->CCMR1 = tmpccmr1 ;
  TIMx->CCER = tmpccer;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_TI3_SetConfig(TIM_TypeDef *TIMx, uint32_t TIM_ICPolarity, uint32_t TIM_ICSelection,
                              uint32_t TIM_ICFilter)
{
  uint32_t tmpccmr2;
  uint32_t tmpccer;

  /* Get the TIMx CCER register value */
  tmpccer = TIMx->CCER;

  /* Disable the Channel 3: Reset the CC3E Bit */
  TIMx->CCER &= ~TIM_CCER_CC3E;
  /* Disable the Channel 3N: Reset the CC3NE Bit */
  if (IS_TIM_CCXN_INSTANCE(TIMx, TIM_CHANNEL_3))
  {
    TIMx->CCER &= ~TIM_CCER_CC3NE;
  }

  /* Get the TIMx CCMR2 register value */
  tmpccmr2 = TIMx->CCMR2;

  /* Select the Input */
  tmpccmr2 &= ~TIM_CCMR2_CC3S;
  tmpccmr2 |= TIM_ICSelection;

  /* Set the filter */
  tmpccmr2 &= ~TIM_CCMR2_IC3F;
  tmpccmr2 |= ((TIM_ICFilter << 4U) & TIM_CCMR2_IC3F);

  /* Select the Polarity and set the CC3E Bit */
  tmpccer &= ~(TIM_CCER_CC3P | TIM_CCER_CC3NP);
  tmpccer |= ((TIM_ICPolarity << 8U) & (TIM_CCER_CC3P | TIM_CCER_CC3NP));

  /* Write to TIMx CCMR2 and CCER registers */
  TIMx->CCMR2 = tmpccmr2;
  TIMx->CCER = tmpccer;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_TI4_SetConfig(TIM_TypeDef *TIMx, uint32_t TIM_ICPolarity, uint32_t TIM_ICSelection,
                              uint32_t TIM_ICFilter)
{
  uint32_t tmpccmr2;
  uint32_t tmpccer;

  /* Get the TIMx CCER register value */
  tmpccer = TIMx->CCER;

  /* Disable the Channel 4: Reset the CC4E Bit */
  TIMx->CCER &= ~TIM_CCER_CC4E;
  /* Disable the Channel 4N: Reset the CC4NE Bit */
  if (IS_TIM_CCXN_INSTANCE(TIMx, TIM_CHANNEL_4))
  {
    TIMx->CCER &= ~TIM_CCER_CC4NE;
  }

  /* Get the TIMx CCMR2 register value */
  tmpccmr2 = TIMx->CCMR2;

  /* Select the Input */
  tmpccmr2 &= ~TIM_CCMR2_CC4S;
  tmpccmr2 |= (TIM_ICSelection << 8U);

  /* Set the filter */
  tmpccmr2 &= ~TIM_CCMR2_IC4F;
  tmpccmr2 |= ((TIM_ICFilter << 12U) & TIM_CCMR2_IC4F);

  /* Select the Polarity and set the CC4E Bit */
  tmpccer &= ~(TIM_CCER_CC4P | TIM_CCER_CC4NP);
  tmpccer |= ((TIM_ICPolarity << 12U) & (TIM_CCER_CC4P | TIM_CCER_CC4NP));

  /* Write to TIMx CCMR2 and CCER registers */
  TIMx->CCMR2 = tmpccmr2;
  TIMx->CCER = tmpccer ;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_ITRx_SetConfig(TIM_TypeDef *TIMx, uint32_t InputTriggerSource)
{
  uint32_t tmpsmcr;

  /* Get the TIMx SMCR register value */
  tmpsmcr = TIMx->SMCR;
  /* Reset the TS Bits */
  tmpsmcr &= ~TIM_SMCR_TS;
  /* Set the Input Trigger source and the slave mode*/
  tmpsmcr |= (InputTriggerSource | TIM_SLAVEMODE_EXTERNAL1);
  /* Write to TIMx SMCR */
  TIMx->SMCR = tmpsmcr;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
void TIM_ETR_SetConfig(TIM_TypeDef *TIMx, uint32_t TIM_ExtTRGPrescaler,
                       uint32_t TIM_ExtTRGPolarity, uint32_t ExtTRGFilter)
{
  uint32_t tmpsmcr;

  tmpsmcr = TIMx->SMCR;

  /* Reset the ETR Bits */
  tmpsmcr &= ~(TIM_SMCR_ETF | TIM_SMCR_ETPS | TIM_SMCR_ECE | TIM_SMCR_ETP);

  /* Set the Prescaler, the Filter value and the Polarity */
  tmpsmcr |= (uint32_t)(TIM_ExtTRGPrescaler | (TIM_ExtTRGPolarity | (ExtTRGFilter << 8U)));

  /* Write to TIMx SMCR */
  TIMx->SMCR = tmpsmcr;
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
void TIM_CCxChannelCmd(TIM_TypeDef *TIMx, uint32_t Channel, uint32_t ChannelState)
{
  uint32_t tmp;

  /* Check the parameters */
  assert_param(IS_TIM_CC1_INSTANCE(TIMx));
  assert_param(IS_TIM_CHANNELS(Channel));

  tmp = TIM_CCER_CC1E << (Channel & 0x1FU); /* 0x1FU = 31 bits max shift */

  /* Reset the CCxE Bit */
  TIMx->CCER &= ~tmp;

  /* Set or reset the CCxE Bit */
  TIMx->CCER |= (uint32_t)(ChannelState << (Channel & 0x1FU)); /* 0x1FU = 31 bits max shift */
}
#endif

#ifdef HAL_TIM_MODULE_ENABLED
#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
void TIM_ResetCallback(TIM_HandleTypeDef *htim)
{
  /* Reset the TIM callback to the legacy weak callbacks */
  htim->PeriodElapsedCallback             = HAL_TIM_PeriodElapsedCallback;
  htim->PeriodElapsedHalfCpltCallback     = HAL_TIM_PeriodElapsedHalfCpltCallback;
  htim->TriggerCallback                   = HAL_TIM_TriggerCallback;
  htim->TriggerHalfCpltCallback           = HAL_TIM_TriggerHalfCpltCallback;
  htim->IC_CaptureCallback                = HAL_TIM_IC_CaptureCallback;
  htim->IC_CaptureHalfCpltCallback        = HAL_TIM_IC_CaptureHalfCpltCallback;
  htim->OC_DelayElapsedCallback           = HAL_TIM_OC_DelayElapsedCallback;
  htim->PWM_PulseFinishedCallback         = HAL_TIM_PWM_PulseFinishedCallback;
  htim->PWM_PulseFinishedHalfCpltCallback = HAL_TIM_PWM_PulseFinishedHalfCpltCallback;
  htim->ErrorCallback                     = HAL_TIM_ErrorCallback;
  htim->CommutationCallback               = HAL_TIMEx_CommutCallback;
  htim->CommutationHalfCpltCallback       = HAL_TIMEx_CommutHalfCpltCallback;
  htim->BreakCallback                     = HAL_TIMEx_BreakCallback;
  htim->Break2Callback                    = HAL_TIMEx_Break2Callback;
  htim->EncoderIndexCallback              = HAL_TIMEx_EncoderIndexCallback;
  htim->DirectionChangeCallback           = HAL_TIMEx_DirectionChangeCallback;
  htim->IndexErrorCallback                = HAL_TIMEx_IndexErrorCallback;
  htim->TransitionErrorCallback           = HAL_TIMEx_TransitionErrorCallback;
}
#endif
#endif
