// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// FDCAN operations and definitions from stm32h7rsxx_hal_fdcan.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

HAL_StatusTypeDef HAL_FDCAN_Init(FDCAN_HandleTypeDef *hfdcan)
{
  uint32_t tickstart;

  /* Check FDCAN handle */
  if (hfdcan == NULL)
  {
    return HAL_ERROR;
  }

  /* Check function parameters */
  assert_param(IS_FDCAN_ALL_INSTANCE(hfdcan->Instance));
  if (hfdcan->Instance == FDCAN1)
  {
    assert_param(IS_FDCAN_CKDIV(hfdcan->Init.ClockDivider));
  }
  assert_param(IS_FDCAN_FRAME_FORMAT(hfdcan->Init.FrameFormat));
  assert_param(IS_FDCAN_MODE(hfdcan->Init.Mode));
  assert_param(IS_FUNCTIONAL_STATE(hfdcan->Init.AutoRetransmission));
  assert_param(IS_FUNCTIONAL_STATE(hfdcan->Init.TransmitPause));
  assert_param(IS_FUNCTIONAL_STATE(hfdcan->Init.ProtocolException));
  assert_param(IS_FDCAN_NOMINAL_PRESCALER(hfdcan->Init.NominalPrescaler));
  assert_param(IS_FDCAN_NOMINAL_SJW(hfdcan->Init.NominalSyncJumpWidth));
  assert_param(IS_FDCAN_NOMINAL_TSEG1(hfdcan->Init.NominalTimeSeg1));
  assert_param(IS_FDCAN_NOMINAL_TSEG2(hfdcan->Init.NominalTimeSeg2));
  if (hfdcan->Init.FrameFormat == FDCAN_FRAME_FD_BRS)
  {
    assert_param(IS_FDCAN_DATA_PRESCALER(hfdcan->Init.DataPrescaler));
    assert_param(IS_FDCAN_DATA_SJW(hfdcan->Init.DataSyncJumpWidth));
    assert_param(IS_FDCAN_DATA_TSEG1(hfdcan->Init.DataTimeSeg1));
    assert_param(IS_FDCAN_DATA_TSEG2(hfdcan->Init.DataTimeSeg2));
  }
  assert_param(IS_FDCAN_MAX_VALUE(hfdcan->Init.StdFiltersNbr, SRAMCAN_FLS_NBR));
  assert_param(IS_FDCAN_MAX_VALUE(hfdcan->Init.ExtFiltersNbr, SRAMCAN_FLE_NBR));
  assert_param(IS_FDCAN_TX_FIFO_QUEUE_MODE(hfdcan->Init.TxFifoQueueMode));

#if USE_HAL_FDCAN_REGISTER_CALLBACKS == 1
  if (hfdcan->State == HAL_FDCAN_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    hfdcan->Lock = HAL_UNLOCKED;

    /* Reset callbacks to legacy functions */
    hfdcan->TxEventFifoCallback         = HAL_FDCAN_TxEventFifoCallback;         /* TxEventFifoCallback */
    hfdcan->RxFifo0Callback             = HAL_FDCAN_RxFifo0Callback;             /* RxFifo0Callback     */
    hfdcan->RxFifo1Callback             = HAL_FDCAN_RxFifo1Callback;             /* RxFifo1Callback     */
    hfdcan->TxFifoEmptyCallback         = HAL_FDCAN_TxFifoEmptyCallback;         /* TxFifoEmptyCallback */
    hfdcan->TxBufferCompleteCallback    = HAL_FDCAN_TxBufferCompleteCallback;    /* TxBufferCompleteCallback        */
    hfdcan->TxBufferAbortCallback       = HAL_FDCAN_TxBufferAbortCallback;       /* TxBufferAbortCallback           */
    hfdcan->HighPriorityMessageCallback = HAL_FDCAN_HighPriorityMessageCallback; /* HighPriorityMessageCallback     */
    hfdcan->TimestampWraparoundCallback = HAL_FDCAN_TimestampWraparoundCallback; /* TimestampWraparoundCallback     */
    hfdcan->TimeoutOccurredCallback     = HAL_FDCAN_TimeoutOccurredCallback;     /* TimeoutOccurredCallback         */
    hfdcan->ErrorCallback               = HAL_FDCAN_ErrorCallback;               /* ErrorCallback       */
    hfdcan->ErrorStatusCallback         = HAL_FDCAN_ErrorStatusCallback;         /* ErrorStatusCallback */

    if (hfdcan->MspInitCallback == NULL)
    {
      hfdcan->MspInitCallback = HAL_FDCAN_MspInit;  /* Legacy weak MspInit */
    }

    /* Init the low level hardware: CLOCK, NVIC */
    hfdcan->MspInitCallback(hfdcan);
  }
#else
  if (hfdcan->State == HAL_FDCAN_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    hfdcan->Lock = HAL_UNLOCKED;

    /* Init the low level hardware: CLOCK, NVIC */
    HAL_FDCAN_MspInit(hfdcan);
  }
#endif /* USE_HAL_FDCAN_REGISTER_CALLBACKS */

  /* Exit from Sleep mode */
  CLEAR_BIT(hfdcan->Instance->CCCR, FDCAN_CCCR_CSR);

  /* Get tick */
  tickstart = HAL_GetTick();

  /* Check Sleep mode acknowledge */
  while ((hfdcan->Instance->CCCR & FDCAN_CCCR_CSA) == FDCAN_CCCR_CSA)
  {
    if ((HAL_GetTick() - tickstart) > FDCAN_TIMEOUT_VALUE)
    {
      /* Update error code */
      hfdcan->ErrorCode |= HAL_FDCAN_ERROR_TIMEOUT;

      /* Change FDCAN state */
      hfdcan->State = HAL_FDCAN_STATE_ERROR;

      return HAL_ERROR;
    }
  }

  /* Request initialisation */
  SET_BIT(hfdcan->Instance->CCCR, FDCAN_CCCR_INIT);

  /* Get tick */
  tickstart = HAL_GetTick();

  /* Wait until the INIT bit into CCCR register is set */
  while ((hfdcan->Instance->CCCR & FDCAN_CCCR_INIT) == 0U)
  {
    /* Check for the Timeout */
    if ((HAL_GetTick() - tickstart) > FDCAN_TIMEOUT_VALUE)
    {
      /* Update error code */
      hfdcan->ErrorCode |= HAL_FDCAN_ERROR_TIMEOUT;

      /* Change FDCAN state */
      hfdcan->State = HAL_FDCAN_STATE_ERROR;

      return HAL_ERROR;
    }
  }

  /* Enable configuration change */
  SET_BIT(hfdcan->Instance->CCCR, FDCAN_CCCR_CCE);

  /* Check FDCAN instance */
  if (hfdcan->Instance == FDCAN1)
  {
    /* Configure Clock divider */
    FDCAN_CONFIG->CKDIV = hfdcan->Init.ClockDivider;
  }

  /* Set the no automatic retransmission */
  if (hfdcan->Init.AutoRetransmission == ENABLE)
  {
    CLEAR_BIT(hfdcan->Instance->CCCR, FDCAN_CCCR_DAR);
  }
  else
  {
    SET_BIT(hfdcan->Instance->CCCR, FDCAN_CCCR_DAR);
  }

  /* Set the transmit pause feature */
  if (hfdcan->Init.TransmitPause == ENABLE)
  {
    SET_BIT(hfdcan->Instance->CCCR, FDCAN_CCCR_TXP);
  }
  else
  {
    CLEAR_BIT(hfdcan->Instance->CCCR, FDCAN_CCCR_TXP);
  }

  /* Set the Protocol Exception Handling */
  if (hfdcan->Init.ProtocolException == ENABLE)
  {
    CLEAR_BIT(hfdcan->Instance->CCCR, FDCAN_CCCR_PXHD);
  }
  else
  {
    SET_BIT(hfdcan->Instance->CCCR, FDCAN_CCCR_PXHD);
  }

  /* Set FDCAN Frame Format */
  MODIFY_REG(hfdcan->Instance->CCCR, FDCAN_FRAME_FD_BRS, hfdcan->Init.FrameFormat);

  /* Reset FDCAN Operation Mode */
  CLEAR_BIT(hfdcan->Instance->CCCR, (FDCAN_CCCR_TEST | FDCAN_CCCR_MON | FDCAN_CCCR_ASM));
  CLEAR_BIT(hfdcan->Instance->TEST, FDCAN_TEST_LBCK);

  /* Set FDCAN Operating Mode:
               | Normal | Restricted |    Bus     | Internal | External
               |        | Operation  | Monitoring | LoopBack | LoopBack
     CCCR.TEST |   0    |     0      |     0      |    1     |    1
     CCCR.MON  |   0    |     0      |     1      |    1     |    0
     TEST.LBCK |   0    |     0      |     0      |    1     |    1
     CCCR.ASM  |   0    |     1      |     0      |    0     |    0
  */
  if (hfdcan->Init.Mode == FDCAN_MODE_RESTRICTED_OPERATION)
  {
    /* Enable Restricted Operation mode */
    SET_BIT(hfdcan->Instance->CCCR, FDCAN_CCCR_ASM);
  }
  else if (hfdcan->Init.Mode != FDCAN_MODE_NORMAL)
  {
    if (hfdcan->Init.Mode != FDCAN_MODE_BUS_MONITORING)
    {
      /* Enable write access to TEST register */
      SET_BIT(hfdcan->Instance->CCCR, FDCAN_CCCR_TEST);

      /* Enable LoopBack mode */
      SET_BIT(hfdcan->Instance->TEST, FDCAN_TEST_LBCK);

      if (hfdcan->Init.Mode == FDCAN_MODE_INTERNAL_LOOPBACK)
      {
        SET_BIT(hfdcan->Instance->CCCR, FDCAN_CCCR_MON);
      }
    }
    else
    {
      /* Enable bus monitoring mode */
      SET_BIT(hfdcan->Instance->CCCR, FDCAN_CCCR_MON);
    }
  }
  else
  {
    /* Nothing to do: normal mode */
  }

  /* Set the nominal bit timing register */
  hfdcan->Instance->NBTP = ((((uint32_t)hfdcan->Init.NominalSyncJumpWidth - 1U) << FDCAN_NBTP_NSJW_Pos) | \
                            (((uint32_t)hfdcan->Init.NominalTimeSeg1 - 1U) << FDCAN_NBTP_NTSEG1_Pos)    | \
                            (((uint32_t)hfdcan->Init.NominalTimeSeg2 - 1U) << FDCAN_NBTP_NTSEG2_Pos)    | \
                            (((uint32_t)hfdcan->Init.NominalPrescaler - 1U) << FDCAN_NBTP_NBRP_Pos));

  /* If FD operation with BRS is selected, set the data bit timing register */
  if (hfdcan->Init.FrameFormat == FDCAN_FRAME_FD_BRS)
  {
    hfdcan->Instance->DBTP = ((((uint32_t)hfdcan->Init.DataSyncJumpWidth - 1U) << FDCAN_DBTP_DSJW_Pos)  | \
                              (((uint32_t)hfdcan->Init.DataTimeSeg1 - 1U) << FDCAN_DBTP_DTSEG1_Pos)     | \
                              (((uint32_t)hfdcan->Init.DataTimeSeg2 - 1U) << FDCAN_DBTP_DTSEG2_Pos)     | \
                              (((uint32_t)hfdcan->Init.DataPrescaler - 1U) << FDCAN_DBTP_DBRP_Pos));
  }

  /* Select between Tx FIFO and Tx Queue operation modes */
  SET_BIT(hfdcan->Instance->TXBC, hfdcan->Init.TxFifoQueueMode);

  /* Calculate each RAM block address */
  FDCAN_CalcultateRamBlockAddresses(hfdcan);

  /* Initialize the Latest Tx request buffer index */
  hfdcan->LatestTxFifoQRequest = 0U;

  /* Initialize the error code */
  hfdcan->ErrorCode = HAL_FDCAN_ERROR_NONE;

  /* Initialize the FDCAN state */
  hfdcan->State = HAL_FDCAN_STATE_READY;

  /* Return function status */
  return HAL_OK;
}

HAL_StatusTypeDef HAL_FDCAN_DeInit(FDCAN_HandleTypeDef *hfdcan)
{
  /* Check FDCAN handle */
  if (hfdcan == NULL)
  {
    return HAL_ERROR;
  }

  /* Check function parameters */
  assert_param(IS_FDCAN_ALL_INSTANCE(hfdcan->Instance));

  /* Stop the FDCAN module: return value is voluntary ignored */
  (void)HAL_FDCAN_Stop(hfdcan);

  /* Disable Interrupt lines */
  CLEAR_BIT(hfdcan->Instance->ILE, (FDCAN_INTERRUPT_LINE0 | FDCAN_INTERRUPT_LINE1));

#if USE_HAL_FDCAN_REGISTER_CALLBACKS == 1
  if (hfdcan->MspDeInitCallback == NULL)
  {
    hfdcan->MspDeInitCallback = HAL_FDCAN_MspDeInit; /* Legacy weak MspDeInit */
  }

  /* DeInit the low level hardware: CLOCK, NVIC */
  hfdcan->MspDeInitCallback(hfdcan);
#else
  /* DeInit the low level hardware: CLOCK, NVIC */
  HAL_FDCAN_MspDeInit(hfdcan);
#endif /* USE_HAL_FDCAN_REGISTER_CALLBACKS */

  /* Reset the FDCAN ErrorCode */
  hfdcan->ErrorCode = HAL_FDCAN_ERROR_NONE;

  /* Change FDCAN state */
  hfdcan->State = HAL_FDCAN_STATE_RESET;

  /* Return function status */
  return HAL_OK;
}

HAL_StatusTypeDef HAL_FDCAN_EnterPowerDownMode(FDCAN_HandleTypeDef *hfdcan)
{
  uint32_t tickstart;

  /* Request clock stop */
  SET_BIT(hfdcan->Instance->CCCR, FDCAN_CCCR_CSR);

  /* Get tick */
  tickstart = HAL_GetTick();

  /* Wait until FDCAN is ready for power down */
  while ((hfdcan->Instance->CCCR & FDCAN_CCCR_CSA) == 0U)
  {
    if ((HAL_GetTick() - tickstart) > FDCAN_TIMEOUT_VALUE)
    {
      /* Update error code */
      hfdcan->ErrorCode |= HAL_FDCAN_ERROR_TIMEOUT;

      /* Change FDCAN state */
      hfdcan->State = HAL_FDCAN_STATE_ERROR;

      return HAL_ERROR;
    }
  }

  /* Return function status */
  return HAL_OK;
}

HAL_StatusTypeDef HAL_FDCAN_ExitPowerDownMode(FDCAN_HandleTypeDef *hfdcan)
{
  uint32_t tickstart;

  /* Reset clock stop request */
  CLEAR_BIT(hfdcan->Instance->CCCR, FDCAN_CCCR_CSR);

  /* Get tick */
  tickstart = HAL_GetTick();

  /* Wait until FDCAN exits sleep mode */
  while ((hfdcan->Instance->CCCR & FDCAN_CCCR_CSA) == FDCAN_CCCR_CSA)
  {
    if ((HAL_GetTick() - tickstart) > FDCAN_TIMEOUT_VALUE)
    {
      /* Update error code */
      hfdcan->ErrorCode |= HAL_FDCAN_ERROR_TIMEOUT;

      /* Change FDCAN state */
      hfdcan->State = HAL_FDCAN_STATE_ERROR;

      return HAL_ERROR;
    }
  }

  /* Enter normal operation */
  CLEAR_BIT(hfdcan->Instance->CCCR, FDCAN_CCCR_INIT);

  /* Return function status */
  return HAL_OK;
}

#if F_MODE
HAL_StatusTypeDef HAL_FDCAN_RegisterCallback(FDCAN_HandleTypeDef *hfdcan, HAL_FDCAN_CallbackIDTypeDef CallbackID,
                                             void (* pCallback)(FDCAN_HandleTypeDef *_hFDCAN))
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_INVALID_CALLBACK;

    return HAL_ERROR;
  }

  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    switch (CallbackID)
    {
      case HAL_FDCAN_TX_FIFO_EMPTY_CB_ID :
        hfdcan->TxFifoEmptyCallback = pCallback;
        break;

      case HAL_FDCAN_HIGH_PRIO_MESSAGE_CB_ID :
        hfdcan->HighPriorityMessageCallback = pCallback;
        break;

      case HAL_FDCAN_TIMESTAMP_WRAPAROUND_CB_ID :
        hfdcan->TimestampWraparoundCallback = pCallback;
        break;

      case HAL_FDCAN_TIMEOUT_OCCURRED_CB_ID :
        hfdcan->TimeoutOccurredCallback = pCallback;
        break;

      case HAL_FDCAN_ERROR_CALLBACK_CB_ID :
        hfdcan->ErrorCallback = pCallback;
        break;

      case HAL_FDCAN_MSPINIT_CB_ID :
        hfdcan->MspInitCallback = pCallback;
        break;

      case HAL_FDCAN_MSPDEINIT_CB_ID :
        hfdcan->MspDeInitCallback = pCallback;
        break;

      default :
        /* Update the error code */
        hfdcan->ErrorCode |= HAL_FDCAN_ERROR_INVALID_CALLBACK;

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (hfdcan->State == HAL_FDCAN_STATE_RESET)
  {
    switch (CallbackID)
    {
      case HAL_FDCAN_MSPINIT_CB_ID :
        hfdcan->MspInitCallback = pCallback;
        break;

      case HAL_FDCAN_MSPDEINIT_CB_ID :
        hfdcan->MspDeInitCallback = pCallback;
        break;

      default :
        /* Update the error code */
        hfdcan->ErrorCode |= HAL_FDCAN_ERROR_INVALID_CALLBACK;

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif

#if F_MODE
HAL_StatusTypeDef HAL_FDCAN_UnRegisterCallback(FDCAN_HandleTypeDef *hfdcan, HAL_FDCAN_CallbackIDTypeDef CallbackID)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    switch (CallbackID)
    {
      case HAL_FDCAN_TX_FIFO_EMPTY_CB_ID :
        hfdcan->TxFifoEmptyCallback = HAL_FDCAN_TxFifoEmptyCallback;
        break;

      case HAL_FDCAN_HIGH_PRIO_MESSAGE_CB_ID :
        hfdcan->HighPriorityMessageCallback = HAL_FDCAN_HighPriorityMessageCallback;
        break;

      case HAL_FDCAN_TIMESTAMP_WRAPAROUND_CB_ID :
        hfdcan->TimestampWraparoundCallback = HAL_FDCAN_TimestampWraparoundCallback;
        break;

      case HAL_FDCAN_TIMEOUT_OCCURRED_CB_ID :
        hfdcan->TimeoutOccurredCallback = HAL_FDCAN_TimeoutOccurredCallback;
        break;

      case HAL_FDCAN_ERROR_CALLBACK_CB_ID :
        hfdcan->ErrorCallback = HAL_FDCAN_ErrorCallback;
        break;

      case HAL_FDCAN_MSPINIT_CB_ID :
        hfdcan->MspInitCallback = HAL_FDCAN_MspInit;
        break;

      case HAL_FDCAN_MSPDEINIT_CB_ID :
        hfdcan->MspDeInitCallback = HAL_FDCAN_MspDeInit;
        break;

      default :
        /* Update the error code */
        hfdcan->ErrorCode |= HAL_FDCAN_ERROR_INVALID_CALLBACK;

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (hfdcan->State == HAL_FDCAN_STATE_RESET)
  {
    switch (CallbackID)
    {
      case HAL_FDCAN_MSPINIT_CB_ID :
        hfdcan->MspInitCallback = HAL_FDCAN_MspInit;
        break;

      case HAL_FDCAN_MSPDEINIT_CB_ID :
        hfdcan->MspDeInitCallback = HAL_FDCAN_MspDeInit;
        break;

      default :
        /* Update the error code */
        hfdcan->ErrorCode |= HAL_FDCAN_ERROR_INVALID_CALLBACK;

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif

#if F_MODE
HAL_StatusTypeDef HAL_FDCAN_RegisterTxEventFifoCallback(FDCAN_HandleTypeDef *hfdcan,
                                                        pFDCAN_TxEventFifoCallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_INVALID_CALLBACK;
    return HAL_ERROR;
  }

  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    hfdcan->TxEventFifoCallback = pCallback;
  }
  else
  {
    /* Update the error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif

#if F_MODE
HAL_StatusTypeDef HAL_FDCAN_UnRegisterTxEventFifoCallback(FDCAN_HandleTypeDef *hfdcan)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    hfdcan->TxEventFifoCallback = HAL_FDCAN_TxEventFifoCallback; /* Legacy weak TxEventFifoCallback  */
  }
  else
  {
    /* Update the error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif

#if F_MODE
HAL_StatusTypeDef HAL_FDCAN_RegisterRxFifo0Callback(FDCAN_HandleTypeDef *hfdcan,
                                                    pFDCAN_RxFifo0CallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_INVALID_CALLBACK;
    return HAL_ERROR;
  }

  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    hfdcan->RxFifo0Callback = pCallback;
  }
  else
  {
    /* Update the error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif

#if F_MODE
HAL_StatusTypeDef HAL_FDCAN_UnRegisterRxFifo0Callback(FDCAN_HandleTypeDef *hfdcan)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    hfdcan->RxFifo0Callback = HAL_FDCAN_RxFifo0Callback; /* Legacy weak RxFifo0Callback  */
  }
  else
  {
    /* Update the error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif

#if F_MODE
HAL_StatusTypeDef HAL_FDCAN_RegisterRxFifo1Callback(FDCAN_HandleTypeDef *hfdcan,
                                                    pFDCAN_RxFifo1CallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_INVALID_CALLBACK;
    return HAL_ERROR;
  }

  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    hfdcan->RxFifo1Callback = pCallback;
  }
  else
  {
    /* Update the error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif

#if F_MODE
HAL_StatusTypeDef HAL_FDCAN_UnRegisterRxFifo1Callback(FDCAN_HandleTypeDef *hfdcan)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    hfdcan->RxFifo1Callback = HAL_FDCAN_RxFifo1Callback; /* Legacy weak RxFifo1Callback  */
  }
  else
  {
    /* Update the error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif

#if F_MODE
HAL_StatusTypeDef HAL_FDCAN_RegisterTxBufferCompleteCallback(FDCAN_HandleTypeDef *hfdcan,
                                                             pFDCAN_TxBufferCompleteCallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_INVALID_CALLBACK;
    return HAL_ERROR;
  }

  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    hfdcan->TxBufferCompleteCallback = pCallback;
  }
  else
  {
    /* Update the error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif

#if F_MODE
HAL_StatusTypeDef HAL_FDCAN_UnRegisterTxBufferCompleteCallback(FDCAN_HandleTypeDef *hfdcan)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    hfdcan->TxBufferCompleteCallback = HAL_FDCAN_TxBufferCompleteCallback; /* Legacy weak TxBufferCompleteCallback  */
  }
  else
  {
    /* Update the error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif

#if F_MODE
HAL_StatusTypeDef HAL_FDCAN_RegisterTxBufferAbortCallback(FDCAN_HandleTypeDef *hfdcan,
                                                          pFDCAN_TxBufferAbortCallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_INVALID_CALLBACK;
    return HAL_ERROR;
  }

  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    hfdcan->TxBufferAbortCallback = pCallback;
  }
  else
  {
    /* Update the error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif

#if F_MODE
HAL_StatusTypeDef HAL_FDCAN_UnRegisterTxBufferAbortCallback(FDCAN_HandleTypeDef *hfdcan)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    hfdcan->TxBufferAbortCallback = HAL_FDCAN_TxBufferAbortCallback; /* Legacy weak TxBufferAbortCallback  */
  }
  else
  {
    /* Update the error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif

#if F_MODE
HAL_StatusTypeDef HAL_FDCAN_RegisterErrorStatusCallback(FDCAN_HandleTypeDef *hfdcan,
                                                        pFDCAN_ErrorStatusCallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_INVALID_CALLBACK;
    return HAL_ERROR;
  }

  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    hfdcan->ErrorStatusCallback = pCallback;
  }
  else
  {
    /* Update the error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif

#if F_MODE
HAL_StatusTypeDef HAL_FDCAN_UnRegisterErrorStatusCallback(FDCAN_HandleTypeDef *hfdcan)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    hfdcan->ErrorStatusCallback = HAL_FDCAN_ErrorStatusCallback; /* Legacy weak ErrorStatusCallback  */
  }
  else
  {
    /* Update the error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif

HAL_StatusTypeDef HAL_FDCAN_ConfigFilter(FDCAN_HandleTypeDef *hfdcan, const FDCAN_FilterTypeDef *sFilterConfig)
{
  uint32_t FilterElementW1;
  uint32_t FilterElementW2;
  uint32_t *FilterAddress;
  HAL_FDCAN_StateTypeDef state = hfdcan->State;

  if ((state == HAL_FDCAN_STATE_READY) || (state == HAL_FDCAN_STATE_BUSY))
  {
    /* Check function parameters */
    assert_param(IS_FDCAN_ID_TYPE(sFilterConfig->IdType));
    assert_param(IS_FDCAN_FILTER_CFG(sFilterConfig->FilterConfig));

    if (sFilterConfig->IdType == FDCAN_STANDARD_ID)
    {
      /* Check function parameters */
      assert_param(IS_FDCAN_MAX_VALUE((sFilterConfig->FilterIndex + 1U), hfdcan->Init.StdFiltersNbr));
      assert_param(IS_FDCAN_MAX_VALUE(sFilterConfig->FilterID1, 0x7FFU));
      assert_param(IS_FDCAN_MAX_VALUE(sFilterConfig->FilterID2, 0x7FFU));
      assert_param(IS_FDCAN_STD_FILTER_TYPE(sFilterConfig->FilterType));

      /* Build filter element */
      FilterElementW1 = ((sFilterConfig->FilterType << 30U)   |
                         (sFilterConfig->FilterConfig << 27U) |
                         (sFilterConfig->FilterID1 << 16U)    |
                         sFilterConfig->FilterID2);

      /* Calculate filter address */
      FilterAddress = (uint32_t *)(hfdcan->msgRam.StandardFilterSA + (sFilterConfig->FilterIndex * SRAMCAN_FLS_SIZE));

      /* Write filter element to the message RAM */
      *FilterAddress = FilterElementW1;
    }
    else /* sFilterConfig->IdType == FDCAN_EXTENDED_ID */
    {
      /* Check function parameters */
      assert_param(IS_FDCAN_MAX_VALUE((sFilterConfig->FilterIndex + 1U), hfdcan->Init.ExtFiltersNbr));
      assert_param(IS_FDCAN_MAX_VALUE(sFilterConfig->FilterID1, 0x1FFFFFFFU));
      assert_param(IS_FDCAN_MAX_VALUE(sFilterConfig->FilterID2, 0x1FFFFFFFU));
      assert_param(IS_FDCAN_EXT_FILTER_TYPE(sFilterConfig->FilterType));

      /* Build first word of filter element */
      FilterElementW1 = ((sFilterConfig->FilterConfig << 29U) | sFilterConfig->FilterID1);

      /* Build second word of filter element */
      FilterElementW2 = ((sFilterConfig->FilterType << 30U) | sFilterConfig->FilterID2);

      /* Calculate filter address */
      FilterAddress = (uint32_t *)(hfdcan->msgRam.ExtendedFilterSA + (sFilterConfig->FilterIndex * SRAMCAN_FLE_SIZE));

      /* Write filter element to the message RAM */
      *FilterAddress = FilterElementW1;
      FilterAddress++;
      *FilterAddress = FilterElementW2;
    }

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_INITIALIZED;

    return HAL_ERROR;
  }
}

HAL_StatusTypeDef HAL_FDCAN_ConfigGlobalFilter(FDCAN_HandleTypeDef *hfdcan,
                                               uint32_t NonMatchingStd,
                                               uint32_t NonMatchingExt,
                                               uint32_t RejectRemoteStd,
                                               uint32_t RejectRemoteExt)
{
  /* Check function parameters */
  assert_param(IS_FDCAN_NON_MATCHING(NonMatchingStd));
  assert_param(IS_FDCAN_NON_MATCHING(NonMatchingExt));
  assert_param(IS_FDCAN_REJECT_REMOTE(RejectRemoteStd));
  assert_param(IS_FDCAN_REJECT_REMOTE(RejectRemoteExt));

  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    /* Configure global filter */
    MODIFY_REG(hfdcan->Instance->RXGFC, (FDCAN_RXGFC_ANFS |
                                         FDCAN_RXGFC_ANFE |
                                         FDCAN_RXGFC_RRFS |
                                         FDCAN_RXGFC_RRFE),
               ((NonMatchingStd << FDCAN_RXGFC_ANFS_Pos)  |
                (NonMatchingExt << FDCAN_RXGFC_ANFE_Pos)  |
                (RejectRemoteStd << FDCAN_RXGFC_RRFS_Pos) |
                (RejectRemoteExt << FDCAN_RXGFC_RRFE_Pos)));

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_READY;

    return HAL_ERROR;
  }
}

HAL_StatusTypeDef HAL_FDCAN_ConfigExtendedIdMask(FDCAN_HandleTypeDef *hfdcan, uint32_t Mask)
{
  /* Check function parameters */
  assert_param(IS_FDCAN_MAX_VALUE(Mask, 0x1FFFFFFFU));

  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    /* Configure the extended ID mask */
    hfdcan->Instance->XIDAM = Mask;

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_READY;

    return HAL_ERROR;
  }
}

HAL_StatusTypeDef HAL_FDCAN_ConfigRxFifoOverwrite(FDCAN_HandleTypeDef *hfdcan, uint32_t RxFifo, uint32_t OperationMode)
{
  /* Check function parameters */
  assert_param(IS_FDCAN_RX_FIFO(RxFifo));
  assert_param(IS_FDCAN_RX_FIFO_MODE(OperationMode));

  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    if (RxFifo == FDCAN_RX_FIFO0)
    {
      /* Select FIFO 0 Operation Mode */
      MODIFY_REG(hfdcan->Instance->RXGFC, FDCAN_RXGFC_F0OM, (OperationMode << FDCAN_RXGFC_F0OM_Pos));
    }
    else /* RxFifo == FDCAN_RX_FIFO1 */
    {
      /* Select FIFO 1 Operation Mode */
      MODIFY_REG(hfdcan->Instance->RXGFC, FDCAN_RXGFC_F1OM, (OperationMode << FDCAN_RXGFC_F1OM_Pos));
    }

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_READY;

    return HAL_ERROR;
  }
}

HAL_StatusTypeDef HAL_FDCAN_ConfigRamWatchdog(FDCAN_HandleTypeDef *hfdcan, uint32_t CounterStartValue)
{
  /* Check function parameters */
  assert_param(IS_FDCAN_MAX_VALUE(CounterStartValue, 0xFFU));

  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    /* Configure the RAM watchdog counter start value */
    MODIFY_REG(hfdcan->Instance->RWD, FDCAN_RWD_WDC, CounterStartValue);

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_READY;

    return HAL_ERROR;
  }
}

HAL_StatusTypeDef HAL_FDCAN_ConfigTimestampCounter(FDCAN_HandleTypeDef *hfdcan, uint32_t TimestampPrescaler)
{
  /* Check function parameters */
  assert_param(IS_FDCAN_TIMESTAMP_PRESCALER(TimestampPrescaler));

  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    /* Configure prescaler */
    MODIFY_REG(hfdcan->Instance->TSCC, FDCAN_TSCC_TCP, TimestampPrescaler);

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_READY;

    return HAL_ERROR;
  }
}

HAL_StatusTypeDef HAL_FDCAN_EnableTimestampCounter(FDCAN_HandleTypeDef *hfdcan, uint32_t TimestampOperation)
{
  /* Check function parameters */
  assert_param(IS_FDCAN_TIMESTAMP(TimestampOperation));

  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    /* Enable timestamp counter */
    MODIFY_REG(hfdcan->Instance->TSCC, FDCAN_TSCC_TSS, TimestampOperation);

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_READY;

    return HAL_ERROR;
  }
}

HAL_StatusTypeDef HAL_FDCAN_DisableTimestampCounter(FDCAN_HandleTypeDef *hfdcan)
{
  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    /* Disable timestamp counter */
    CLEAR_BIT(hfdcan->Instance->TSCC, FDCAN_TSCC_TSS);

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_READY;

    return HAL_ERROR;
  }
}

uint16_t HAL_FDCAN_GetTimestampCounter(const FDCAN_HandleTypeDef *hfdcan)
{
  return (uint16_t)(hfdcan->Instance->TSCV);
}

HAL_StatusTypeDef HAL_FDCAN_ResetTimestampCounter(FDCAN_HandleTypeDef *hfdcan)
{
  if ((hfdcan->Instance->TSCC & FDCAN_TSCC_TSS) != FDCAN_TIMESTAMP_EXTERNAL)
  {
    /* Reset timestamp counter.
       Actually any write operation to TSCV clears the counter */
    CLEAR_REG(hfdcan->Instance->TSCV);
  }
  else
  {
    /* Update error code.
       Unable to reset external counter */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_SUPPORTED;

    return HAL_ERROR;
  }

  /* Return function status */
  return HAL_OK;
}

HAL_StatusTypeDef HAL_FDCAN_ConfigTimeoutCounter(FDCAN_HandleTypeDef *hfdcan, uint32_t TimeoutOperation,
                                                 uint32_t TimeoutPeriod)
{
  /* Check function parameters */
  assert_param(IS_FDCAN_TIMEOUT(TimeoutOperation));
  assert_param(IS_FDCAN_MAX_VALUE(TimeoutPeriod, 0xFFFFU));

  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    /* Select timeout operation and configure period */
    MODIFY_REG(hfdcan->Instance->TOCC,
               (FDCAN_TOCC_TOS | FDCAN_TOCC_TOP), (TimeoutOperation | (TimeoutPeriod << FDCAN_TOCC_TOP_Pos)));

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_READY;

    return HAL_ERROR;
  }
}

HAL_StatusTypeDef HAL_FDCAN_EnableTimeoutCounter(FDCAN_HandleTypeDef *hfdcan)
{
  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    /* Enable timeout counter */
    SET_BIT(hfdcan->Instance->TOCC, FDCAN_TOCC_ETOC);

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_READY;

    return HAL_ERROR;
  }
}

HAL_StatusTypeDef HAL_FDCAN_DisableTimeoutCounter(FDCAN_HandleTypeDef *hfdcan)
{
  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    /* Disable timeout counter */
    CLEAR_BIT(hfdcan->Instance->TOCC, FDCAN_TOCC_ETOC);

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_READY;

    return HAL_ERROR;
  }
}

uint16_t HAL_FDCAN_GetTimeoutCounter(const FDCAN_HandleTypeDef *hfdcan)
{
  return (uint16_t)(hfdcan->Instance->TOCV);
}

HAL_StatusTypeDef HAL_FDCAN_ResetTimeoutCounter(FDCAN_HandleTypeDef *hfdcan)
{
  if ((hfdcan->Instance->TOCC & FDCAN_TOCC_TOS) == FDCAN_TIMEOUT_CONTINUOUS)
  {
    /* Reset timeout counter to start value */
    CLEAR_REG(hfdcan->Instance->TOCV);

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code.
       Unable to reset counter: controlled only by FIFO empty state */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_SUPPORTED;

    return HAL_ERROR;
  }
}

HAL_StatusTypeDef HAL_FDCAN_ConfigTxDelayCompensation(FDCAN_HandleTypeDef *hfdcan, uint32_t TdcOffset,
                                                      uint32_t TdcFilter)
{
  /* Check function parameters */
  assert_param(IS_FDCAN_MAX_VALUE(TdcOffset, 0x7FU));
  assert_param(IS_FDCAN_MAX_VALUE(TdcFilter, 0x7FU));

  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    /* Configure TDC offset and filter window */
    hfdcan->Instance->TDCR = ((TdcFilter << FDCAN_TDCR_TDCF_Pos) | (TdcOffset << FDCAN_TDCR_TDCO_Pos));

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_READY;

    return HAL_ERROR;
  }
}

HAL_StatusTypeDef HAL_FDCAN_EnableTxDelayCompensation(FDCAN_HandleTypeDef *hfdcan)
{
  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    /* Enable transmitter delay compensation */
    SET_BIT(hfdcan->Instance->DBTP, FDCAN_DBTP_TDC);

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_READY;

    return HAL_ERROR;
  }
}

HAL_StatusTypeDef HAL_FDCAN_DisableTxDelayCompensation(FDCAN_HandleTypeDef *hfdcan)
{
  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    /* Disable transmitter delay compensation */
    CLEAR_BIT(hfdcan->Instance->DBTP, FDCAN_DBTP_TDC);

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_READY;

    return HAL_ERROR;
  }
}

HAL_StatusTypeDef HAL_FDCAN_EnableISOMode(FDCAN_HandleTypeDef *hfdcan)
{
  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    /* Disable Non ISO protocol mode */
    CLEAR_BIT(hfdcan->Instance->CCCR, FDCAN_CCCR_NISO);

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_READY;

    return HAL_ERROR;
  }
}

HAL_StatusTypeDef HAL_FDCAN_DisableISOMode(FDCAN_HandleTypeDef *hfdcan)
{
  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    /* Enable Non ISO protocol mode */
    SET_BIT(hfdcan->Instance->CCCR, FDCAN_CCCR_NISO);

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_READY;

    return HAL_ERROR;
  }
}

HAL_StatusTypeDef HAL_FDCAN_EnableEdgeFiltering(FDCAN_HandleTypeDef *hfdcan)
{
  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    /* Enable edge filtering */
    SET_BIT(hfdcan->Instance->CCCR, FDCAN_CCCR_EFBI);

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_READY;

    return HAL_ERROR;
  }
}

HAL_StatusTypeDef HAL_FDCAN_DisableEdgeFiltering(FDCAN_HandleTypeDef *hfdcan)
{
  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    /* Disable edge filtering */
    CLEAR_BIT(hfdcan->Instance->CCCR, FDCAN_CCCR_EFBI);

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_READY;

    return HAL_ERROR;
  }
}

HAL_StatusTypeDef HAL_FDCAN_Start(FDCAN_HandleTypeDef *hfdcan)
{
  if (hfdcan->State == HAL_FDCAN_STATE_READY)
  {
    /* Change FDCAN peripheral state */
    hfdcan->State = HAL_FDCAN_STATE_BUSY;

    /* Request leave initialisation */
    CLEAR_BIT(hfdcan->Instance->CCCR, FDCAN_CCCR_INIT);

    /* Reset the FDCAN ErrorCode */
    hfdcan->ErrorCode = HAL_FDCAN_ERROR_NONE;

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_READY;

    return HAL_ERROR;
  }
}

HAL_StatusTypeDef HAL_FDCAN_Stop(FDCAN_HandleTypeDef *hfdcan)
{
  uint32_t Counter = 0U;

  if (hfdcan->State == HAL_FDCAN_STATE_BUSY)
  {
    /* Request initialisation */
    SET_BIT(hfdcan->Instance->CCCR, FDCAN_CCCR_INIT);

    /* Wait until the INIT bit into CCCR register is set */
    while ((hfdcan->Instance->CCCR & FDCAN_CCCR_INIT) == 0U)
    {
      /* Check for the Timeout */
      if (Counter > FDCAN_TIMEOUT_VALUE)
      {
        /* Update error code */
        hfdcan->ErrorCode |= HAL_FDCAN_ERROR_TIMEOUT;

        /* Change FDCAN state */
        hfdcan->State = HAL_FDCAN_STATE_ERROR;

        return HAL_ERROR;
      }

      /* Increment counter */
      Counter++;
    }

    /* Reset counter */
    Counter = 0U;

    /* Exit from Sleep mode */
    CLEAR_BIT(hfdcan->Instance->CCCR, FDCAN_CCCR_CSR);

    /* Wait until FDCAN exits sleep mode */
    while ((hfdcan->Instance->CCCR & FDCAN_CCCR_CSA) == FDCAN_CCCR_CSA)
    {
      /* Check for the Timeout */
      if (Counter > FDCAN_TIMEOUT_VALUE)
      {
        /* Update error code */
        hfdcan->ErrorCode |= HAL_FDCAN_ERROR_TIMEOUT;

        /* Change FDCAN state */
        hfdcan->State = HAL_FDCAN_STATE_ERROR;

        return HAL_ERROR;
      }

      /* Increment counter */
      Counter++;
    }

    /* Enable configuration change */
    SET_BIT(hfdcan->Instance->CCCR, FDCAN_CCCR_CCE);

    /* Reset Latest Tx FIFO/Queue Request Buffer Index */
    hfdcan->LatestTxFifoQRequest = 0U;

    /* Change FDCAN peripheral state */
    hfdcan->State = HAL_FDCAN_STATE_READY;

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_STARTED;

    return HAL_ERROR;
  }
}

HAL_StatusTypeDef HAL_FDCAN_AddMessageToTxFifoQ(FDCAN_HandleTypeDef *hfdcan, const FDCAN_TxHeaderTypeDef *pTxHeader,
                                                const uint8_t *pTxData)
{
  uint32_t PutIndex;

  /* Check function parameters */
  assert_param(IS_FDCAN_ID_TYPE(pTxHeader->IdType));
  if (pTxHeader->IdType == FDCAN_STANDARD_ID)
  {
    assert_param(IS_FDCAN_MAX_VALUE(pTxHeader->Identifier, 0x7FFU));
  }
  else /* pTxHeader->IdType == FDCAN_EXTENDED_ID */
  {
    assert_param(IS_FDCAN_MAX_VALUE(pTxHeader->Identifier, 0x1FFFFFFFU));
  }
  assert_param(IS_FDCAN_FRAME_TYPE(pTxHeader->TxFrameType));
  assert_param(IS_FDCAN_DLC(pTxHeader->DataLength));
  assert_param(IS_FDCAN_ESI(pTxHeader->ErrorStateIndicator));
  assert_param(IS_FDCAN_BRS(pTxHeader->BitRateSwitch));
  assert_param(IS_FDCAN_FDF(pTxHeader->FDFormat));
  assert_param(IS_FDCAN_EFC(pTxHeader->TxEventFifoControl));
  assert_param(IS_FDCAN_MAX_VALUE(pTxHeader->MessageMarker, 0xFFU));

  if (hfdcan->State == HAL_FDCAN_STATE_BUSY)
  {
    /* Check that the Tx FIFO/Queue is not full */
    if ((hfdcan->Instance->TXFQS & FDCAN_TXFQS_TFQF) != 0U)
    {
      /* Update error code */
      hfdcan->ErrorCode |= HAL_FDCAN_ERROR_FIFO_FULL;

      return HAL_ERROR;
    }
    else
    {
      /* Retrieve the Tx FIFO PutIndex */
      PutIndex = ((hfdcan->Instance->TXFQS & FDCAN_TXFQS_TFQPI) >> FDCAN_TXFQS_TFQPI_Pos);

      /* Add the message to the Tx FIFO/Queue */
      FDCAN_CopyMessageToRAM(hfdcan, pTxHeader, pTxData, PutIndex);

      /* Activate the corresponding transmission request */
      hfdcan->Instance->TXBAR = ((uint32_t)1 << PutIndex);

      /* Store the Latest Tx FIFO/Queue Request Buffer Index */
      hfdcan->LatestTxFifoQRequest = ((uint32_t)1 << PutIndex);
    }

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_STARTED;

    return HAL_ERROR;
  }
}

uint32_t HAL_FDCAN_GetLatestTxFifoQRequestBuffer(const FDCAN_HandleTypeDef *hfdcan)
{
  /* Return Last Tx FIFO/Queue Request Buffer */
  return hfdcan->LatestTxFifoQRequest;
}

HAL_StatusTypeDef HAL_FDCAN_AbortTxRequest(FDCAN_HandleTypeDef *hfdcan, uint32_t BufferIndex)
{
  /* Check function parameters */
  assert_param(IS_FDCAN_TX_LOCATION_LIST(BufferIndex));

  if (hfdcan->State == HAL_FDCAN_STATE_BUSY)
  {
    /* Add cancellation request */
    hfdcan->Instance->TXBCR = BufferIndex;

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_STARTED;

    return HAL_ERROR;
  }
}

HAL_StatusTypeDef HAL_FDCAN_GetRxMessage(FDCAN_HandleTypeDef *hfdcan, uint32_t RxLocation,
                                         FDCAN_RxHeaderTypeDef *pRxHeader, uint8_t *pRxData)
{
  uint32_t *RxAddress;
  uint8_t  *pData;
  uint32_t ByteCounter;
  uint32_t GetIndex = 0;
  HAL_FDCAN_StateTypeDef state = hfdcan->State;

  /* Check function parameters */
  assert_param(IS_FDCAN_RX_FIFO(RxLocation));

  if (state == HAL_FDCAN_STATE_BUSY)
  {
    if (RxLocation == FDCAN_RX_FIFO0) /* Rx element is assigned to the Rx FIFO 0 */
    {
      /* Check that the Rx FIFO 0 is not empty */
      if ((hfdcan->Instance->RXF0S & FDCAN_RXF0S_F0FL) == 0U)
      {
        /* Update error code */
        hfdcan->ErrorCode |= HAL_FDCAN_ERROR_FIFO_EMPTY;

        return HAL_ERROR;
      }
      else
      {
        /* Calculate Rx FIFO 0 element index */
        GetIndex = ((hfdcan->Instance->RXF0S & FDCAN_RXF0S_F0GI) >> FDCAN_RXF0S_F0GI_Pos);

        /* Check that the Rx FIFO 0 is full & overwrite mode is on */
        if (((hfdcan->Instance->RXF0S & FDCAN_RXF0S_F0F) >> FDCAN_RXF0S_F0F_Pos) == 1U)
        {
          if (((hfdcan->Instance->RXGFC & FDCAN_RXGFC_F0OM) >> FDCAN_RXGFC_F0OM_Pos) == FDCAN_RX_FIFO_OVERWRITE)
          {
            /* When overwrite status is on discard first message in FIFO */
            /* GetIndex is incremented by one and wraps to 0 in case it overflows the FIFO size */
            GetIndex = (GetIndex + 1U) & SRAMCAN_RF0_NBR;
          }
        }

        /* Calculate Rx FIFO 0 element address */
        RxAddress = (uint32_t *)(hfdcan->msgRam.RxFIFO0SA + (GetIndex * SRAMCAN_RF0_SIZE));
      }
    }
    else /* Rx element is assigned to the Rx FIFO 1 */
    {
      /* Check that the Rx FIFO 1 is not empty */
      if ((hfdcan->Instance->RXF1S & FDCAN_RXF1S_F1FL) == 0U)
      {
        /* Update error code */
        hfdcan->ErrorCode |= HAL_FDCAN_ERROR_FIFO_EMPTY;

        return HAL_ERROR;
      }
      else
      {
        /* Calculate Rx FIFO 1 element index */
        GetIndex = ((hfdcan->Instance->RXF1S & FDCAN_RXF1S_F1GI) >> FDCAN_RXF1S_F1GI_Pos);

        /* Check that the Rx FIFO 1 is full & overwrite mode is on */
        if (((hfdcan->Instance->RXF1S & FDCAN_RXF1S_F1F) >> FDCAN_RXF1S_F1F_Pos) == 1U)
        {
          if (((hfdcan->Instance->RXGFC & FDCAN_RXGFC_F1OM) >> FDCAN_RXGFC_F1OM_Pos) == FDCAN_RX_FIFO_OVERWRITE)
          {
            /* When overwrite status is on discard first message in FIFO */
            /* GetIndex is incremented by one and wraps to 0 in case it overflows the FIFO size */
            GetIndex = (GetIndex + 1U) & SRAMCAN_RF1_NBR;
          }
        }

        /* Calculate Rx FIFO 1 element address */
        RxAddress = (uint32_t *)(hfdcan->msgRam.RxFIFO1SA + (GetIndex * SRAMCAN_RF1_SIZE));
      }
    }

    /* Retrieve IdType */
    pRxHeader->IdType = *RxAddress & FDCAN_ELEMENT_MASK_XTD;

    /* Retrieve Identifier */
    if (pRxHeader->IdType == FDCAN_STANDARD_ID) /* Standard ID element */
    {
      pRxHeader->Identifier = ((*RxAddress & FDCAN_ELEMENT_MASK_STDID) >> 18U);
    }
    else /* Extended ID element */
    {
      pRxHeader->Identifier = (*RxAddress & FDCAN_ELEMENT_MASK_EXTID);
    }

    /* Retrieve RxFrameType */
    pRxHeader->RxFrameType = (*RxAddress & FDCAN_ELEMENT_MASK_RTR);

    /* Retrieve ErrorStateIndicator */
    pRxHeader->ErrorStateIndicator = (*RxAddress & FDCAN_ELEMENT_MASK_ESI);

    /* Increment RxAddress pointer to second word of Rx FIFO element */
    RxAddress++;

    /* Retrieve RxTimestamp */
    pRxHeader->RxTimestamp = (*RxAddress & FDCAN_ELEMENT_MASK_TS);

    /* Retrieve DataLength */
    pRxHeader->DataLength = ((*RxAddress & FDCAN_ELEMENT_MASK_DLC) >> 16U);

    /* Retrieve BitRateSwitch */
    pRxHeader->BitRateSwitch = (*RxAddress & FDCAN_ELEMENT_MASK_BRS);

    /* Retrieve FDFormat */
    pRxHeader->FDFormat = (*RxAddress & FDCAN_ELEMENT_MASK_FDF);

    /* Retrieve FilterIndex */
    pRxHeader->FilterIndex = ((*RxAddress & FDCAN_ELEMENT_MASK_FIDX) >> 24U);

    /* Retrieve NonMatchingFrame */
    pRxHeader->IsFilterMatchingFrame = ((*RxAddress & FDCAN_ELEMENT_MASK_ANMF) >> 31U);

    /* Increment RxAddress pointer to payload of Rx FIFO element */
    RxAddress++;

    /* Retrieve Rx payload */
    pData = (uint8_t *)RxAddress;
    for (ByteCounter = 0; ByteCounter < DLCtoBytes[pRxHeader->DataLength]; ByteCounter++)
    {
      pRxData[ByteCounter] = pData[ByteCounter];
    }

    if (RxLocation == FDCAN_RX_FIFO0) /* Rx element is assigned to the Rx FIFO 0 */
    {
      /* Acknowledge the Rx FIFO 0 that the oldest element is read so that it increments the GetIndex */
      hfdcan->Instance->RXF0A = GetIndex;
    }
    else /* Rx element is assigned to the Rx FIFO 1 */
    {
      /* Acknowledge the Rx FIFO 1 that the oldest element is read so that it increments the GetIndex */
      hfdcan->Instance->RXF1A = GetIndex;
    }

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_STARTED;

    return HAL_ERROR;
  }
}

HAL_StatusTypeDef HAL_FDCAN_GetTxEvent(FDCAN_HandleTypeDef *hfdcan, FDCAN_TxEventFifoTypeDef *pTxEvent)
{
  uint32_t *TxEventAddress;
  uint32_t GetIndex;
  HAL_FDCAN_StateTypeDef state = hfdcan->State;

  if (state == HAL_FDCAN_STATE_BUSY)
  {
    /* Check that the Tx event FIFO is not empty */
    if ((hfdcan->Instance->TXEFS & FDCAN_TXEFS_EFFL) == 0U)
    {
      /* Update error code */
      hfdcan->ErrorCode |= HAL_FDCAN_ERROR_FIFO_EMPTY;

      return HAL_ERROR;
    }

    /* Calculate Tx event FIFO element address */
    GetIndex = ((hfdcan->Instance->TXEFS & FDCAN_TXEFS_EFGI) >> FDCAN_TXEFS_EFGI_Pos);
    TxEventAddress = (uint32_t *)(hfdcan->msgRam.TxEventFIFOSA + (GetIndex * SRAMCAN_TEF_SIZE));

    /* Retrieve IdType */
    pTxEvent->IdType = *TxEventAddress & FDCAN_ELEMENT_MASK_XTD;

    /* Retrieve Identifier */
    if (pTxEvent->IdType == FDCAN_STANDARD_ID) /* Standard ID element */
    {
      pTxEvent->Identifier = ((*TxEventAddress & FDCAN_ELEMENT_MASK_STDID) >> 18U);
    }
    else /* Extended ID element */
    {
      pTxEvent->Identifier = (*TxEventAddress & FDCAN_ELEMENT_MASK_EXTID);
    }

    /* Retrieve TxFrameType */
    pTxEvent->TxFrameType = (*TxEventAddress & FDCAN_ELEMENT_MASK_RTR);

    /* Retrieve ErrorStateIndicator */
    pTxEvent->ErrorStateIndicator = (*TxEventAddress & FDCAN_ELEMENT_MASK_ESI);

    /* Increment TxEventAddress pointer to second word of Tx Event FIFO element */
    TxEventAddress++;

    /* Retrieve TxTimestamp */
    pTxEvent->TxTimestamp = (*TxEventAddress & FDCAN_ELEMENT_MASK_TS);

    /* Retrieve DataLength */
    pTxEvent->DataLength = ((*TxEventAddress & FDCAN_ELEMENT_MASK_DLC) >> 16U);

    /* Retrieve BitRateSwitch */
    pTxEvent->BitRateSwitch = (*TxEventAddress & FDCAN_ELEMENT_MASK_BRS);

    /* Retrieve FDFormat */
    pTxEvent->FDFormat = (*TxEventAddress & FDCAN_ELEMENT_MASK_FDF);

    /* Retrieve EventType */
    pTxEvent->EventType = (*TxEventAddress & FDCAN_ELEMENT_MASK_ET);

    /* Retrieve MessageMarker */
    pTxEvent->MessageMarker = ((*TxEventAddress & FDCAN_ELEMENT_MASK_MM) >> 24U);

    /* Acknowledge the Tx Event FIFO that the oldest element is read so that it increments the GetIndex */
    hfdcan->Instance->TXEFA = GetIndex;

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_STARTED;

    return HAL_ERROR;
  }
}

HAL_StatusTypeDef HAL_FDCAN_GetHighPriorityMessageStatus(const FDCAN_HandleTypeDef *hfdcan,
                                                         FDCAN_HpMsgStatusTypeDef *HpMsgStatus)
{
  HpMsgStatus->FilterList = ((hfdcan->Instance->HPMS & FDCAN_HPMS_FLST) >> FDCAN_HPMS_FLST_Pos);
  HpMsgStatus->FilterIndex = ((hfdcan->Instance->HPMS & FDCAN_HPMS_FIDX) >> FDCAN_HPMS_FIDX_Pos);
  HpMsgStatus->MessageStorage = (hfdcan->Instance->HPMS & FDCAN_HPMS_MSI);
  HpMsgStatus->MessageIndex = (hfdcan->Instance->HPMS & FDCAN_HPMS_BIDX);

  /* Return function status */
  return HAL_OK;
}

HAL_StatusTypeDef HAL_FDCAN_GetProtocolStatus(const FDCAN_HandleTypeDef *hfdcan,
                                              FDCAN_ProtocolStatusTypeDef *ProtocolStatus)
{
  uint32_t StatusReg;

  /* Read the protocol status register */
  StatusReg = READ_REG(hfdcan->Instance->PSR);

  /* Fill the protocol status structure */
  ProtocolStatus->LastErrorCode = (StatusReg & FDCAN_PSR_LEC);
  ProtocolStatus->DataLastErrorCode = ((StatusReg & FDCAN_PSR_DLEC) >> FDCAN_PSR_DLEC_Pos);
  ProtocolStatus->Activity = (StatusReg & FDCAN_PSR_ACT);
  ProtocolStatus->ErrorPassive = ((StatusReg & FDCAN_PSR_EP) >> FDCAN_PSR_EP_Pos);
  ProtocolStatus->Warning = ((StatusReg & FDCAN_PSR_EW) >> FDCAN_PSR_EW_Pos);
  ProtocolStatus->BusOff = ((StatusReg & FDCAN_PSR_BO) >> FDCAN_PSR_BO_Pos);
  ProtocolStatus->RxESIflag = ((StatusReg & FDCAN_PSR_RESI) >> FDCAN_PSR_RESI_Pos);
  ProtocolStatus->RxBRSflag = ((StatusReg & FDCAN_PSR_RBRS) >> FDCAN_PSR_RBRS_Pos);
  ProtocolStatus->RxFDFflag = ((StatusReg & FDCAN_PSR_REDL) >> FDCAN_PSR_REDL_Pos);
  ProtocolStatus->ProtocolException = ((StatusReg & FDCAN_PSR_PXE) >> FDCAN_PSR_PXE_Pos);
  ProtocolStatus->TDCvalue = ((StatusReg & FDCAN_PSR_TDCV) >> FDCAN_PSR_TDCV_Pos);

  /* Return function status */
  return HAL_OK;
}

HAL_StatusTypeDef HAL_FDCAN_GetErrorCounters(const FDCAN_HandleTypeDef *hfdcan,
                                             FDCAN_ErrorCountersTypeDef *ErrorCounters)
{
  uint32_t CountersReg;

  /* Read the error counters register */
  CountersReg = READ_REG(hfdcan->Instance->ECR);

  /* Fill the error counters structure */
  ErrorCounters->TxErrorCnt = ((CountersReg & FDCAN_ECR_TEC) >> FDCAN_ECR_TEC_Pos);
  ErrorCounters->RxErrorCnt = ((CountersReg & FDCAN_ECR_REC) >> FDCAN_ECR_REC_Pos);
  ErrorCounters->RxErrorPassive = ((CountersReg & FDCAN_ECR_RP) >> FDCAN_ECR_RP_Pos);
  ErrorCounters->ErrorLogging = ((CountersReg & FDCAN_ECR_CEL) >> FDCAN_ECR_CEL_Pos);

  /* Return function status */
  return HAL_OK;
}

uint32_t HAL_FDCAN_IsTxBufferMessagePending(const FDCAN_HandleTypeDef *hfdcan, uint32_t TxBufferIndex)
{
  /* Check function parameters */
  assert_param(IS_FDCAN_TX_LOCATION_LIST(TxBufferIndex));

  /* Check pending transmission request on the selected buffer */
  if ((hfdcan->Instance->TXBRP & TxBufferIndex) == 0U)
  {
    return 0;
  }
  return 1;
}

uint32_t HAL_FDCAN_GetRxFifoFillLevel(const FDCAN_HandleTypeDef *hfdcan, uint32_t RxFifo)
{
  uint32_t FillLevel;

  /* Check function parameters */
  assert_param(IS_FDCAN_RX_FIFO(RxFifo));

  if (RxFifo == FDCAN_RX_FIFO0)
  {
    FillLevel = hfdcan->Instance->RXF0S & FDCAN_RXF0S_F0FL;
  }
  else /* RxFifo == FDCAN_RX_FIFO1 */
  {
    FillLevel = hfdcan->Instance->RXF1S & FDCAN_RXF1S_F1FL;
  }

  /* Return Rx FIFO fill level */
  return FillLevel;
}

uint32_t HAL_FDCAN_GetTxFifoFreeLevel(const FDCAN_HandleTypeDef *hfdcan)
{
  uint32_t FreeLevel;

  FreeLevel = hfdcan->Instance->TXFQS & FDCAN_TXFQS_TFFL;

  /* Return Tx FIFO free level */
  return FreeLevel;
}

uint32_t HAL_FDCAN_IsRestrictedOperationMode(const FDCAN_HandleTypeDef *hfdcan)
{
  uint32_t OperationMode;

  /* Get Operation Mode */
  OperationMode = ((hfdcan->Instance->CCCR & FDCAN_CCCR_ASM) >> FDCAN_CCCR_ASM_Pos);

  return OperationMode;
}

HAL_StatusTypeDef HAL_FDCAN_ExitRestrictedOperationMode(FDCAN_HandleTypeDef *hfdcan)
{
  HAL_FDCAN_StateTypeDef state = hfdcan->State;

  if ((state == HAL_FDCAN_STATE_READY) || (state == HAL_FDCAN_STATE_BUSY))
  {
    /* Exit Restricted Operation mode */
    CLEAR_BIT(hfdcan->Instance->CCCR, FDCAN_CCCR_ASM);

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_INITIALIZED;

    return HAL_ERROR;
  }
}

HAL_StatusTypeDef HAL_FDCAN_ConfigInterruptLines(FDCAN_HandleTypeDef *hfdcan, uint32_t ITList, uint32_t InterruptLine)
{
  HAL_FDCAN_StateTypeDef state = hfdcan->State;

  /* Check function parameters */
  assert_param(IS_FDCAN_IT_GROUP(ITList));
  assert_param(IS_FDCAN_IT_LINE(InterruptLine));

  if ((state == HAL_FDCAN_STATE_READY) || (state == HAL_FDCAN_STATE_BUSY))
  {
    /* Assign list of interrupts to the selected line */
    if (InterruptLine == FDCAN_INTERRUPT_LINE0)
    {
      CLEAR_BIT(hfdcan->Instance->ILS, ITList);
    }
    else /* InterruptLine == FDCAN_INTERRUPT_LINE1 */
    {
      SET_BIT(hfdcan->Instance->ILS, ITList);
    }

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_INITIALIZED;

    return HAL_ERROR;
  }
}

HAL_StatusTypeDef HAL_FDCAN_ActivateNotification(FDCAN_HandleTypeDef *hfdcan, uint32_t ActiveITs,
                                                 uint32_t BufferIndexes)
{
  HAL_FDCAN_StateTypeDef state = hfdcan->State;
  uint32_t ITs_lines_selection;

  /* Check function parameters */
  assert_param(IS_FDCAN_IT(ActiveITs));
  if ((ActiveITs & (FDCAN_IT_TX_COMPLETE | FDCAN_IT_TX_ABORT_COMPLETE)) != 0U)
  {
    assert_param(IS_FDCAN_TX_LOCATION_LIST(BufferIndexes));
  }

  if ((state == HAL_FDCAN_STATE_READY) || (state == HAL_FDCAN_STATE_BUSY))
  {
    /* Get interrupts line selection */
    ITs_lines_selection = hfdcan->Instance->ILS;

    /* Enable Interrupt lines */
    if ((((ActiveITs & FDCAN_IT_LIST_RX_FIFO0) != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_RX_FIFO0) == 0U)) || \
        (((ActiveITs & FDCAN_IT_LIST_RX_FIFO1)       != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_RX_FIFO1) == 0U)) || \
        (((ActiveITs & FDCAN_IT_LIST_SMSG)           != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_SMSG)     == 0U)) || \
        (((ActiveITs & FDCAN_IT_LIST_TX_FIFO_ERROR)  != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_TX_FIFO_ERROR)  == 0U)) || \
        (((ActiveITs & FDCAN_IT_LIST_MISC)           != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_MISC)           == 0U)) || \
        (((ActiveITs & FDCAN_IT_LIST_BIT_LINE_ERROR) != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_BIT_LINE_ERROR) == 0U)) || \
        (((ActiveITs & FDCAN_IT_LIST_PROTOCOL_ERROR) != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_PROTOCOL_ERROR) == 0U)))
    {
      /* Enable Interrupt line 0 */
      SET_BIT(hfdcan->Instance->ILE, FDCAN_INTERRUPT_LINE0);
    }
    if ((((ActiveITs & FDCAN_IT_LIST_RX_FIFO0)       != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_RX_FIFO0)      != 0U)) || \
        (((ActiveITs & FDCAN_IT_LIST_RX_FIFO1)       != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_RX_FIFO1)       != 0U)) || \
        (((ActiveITs & FDCAN_IT_LIST_SMSG)           != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_SMSG)           != 0U)) || \
        (((ActiveITs & FDCAN_IT_LIST_TX_FIFO_ERROR)  != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_TX_FIFO_ERROR)  != 0U)) || \
        (((ActiveITs & FDCAN_IT_LIST_MISC)           != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_MISC)           != 0U)) || \
        (((ActiveITs & FDCAN_IT_LIST_BIT_LINE_ERROR) != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_BIT_LINE_ERROR) != 0U)) || \
        (((ActiveITs & FDCAN_IT_LIST_PROTOCOL_ERROR) != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_PROTOCOL_ERROR) != 0U)))
    {
      /* Enable Interrupt line 1 */
      SET_BIT(hfdcan->Instance->ILE, FDCAN_INTERRUPT_LINE1);
    }

    if ((ActiveITs & FDCAN_IT_TX_COMPLETE) != 0U)
    {
      /* Enable Tx Buffer Transmission Interrupt to set TC flag in IR register,
         but interrupt will only occur if TC is enabled in IE register */
      SET_BIT(hfdcan->Instance->TXBTIE, BufferIndexes);
    }

    if ((ActiveITs & FDCAN_IT_TX_ABORT_COMPLETE) != 0U)
    {
      /* Enable Tx Buffer Cancellation Finished Interrupt to set TCF flag in IR register,
         but interrupt will only occur if TCF is enabled in IE register */
      SET_BIT(hfdcan->Instance->TXBCIE, BufferIndexes);
    }

    /* Enable the selected interrupts */
    __HAL_FDCAN_ENABLE_IT(hfdcan, ActiveITs);

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_INITIALIZED;

    return HAL_ERROR;
  }
}

HAL_StatusTypeDef HAL_FDCAN_DeactivateNotification(FDCAN_HandleTypeDef *hfdcan, uint32_t InactiveITs)
{
  HAL_FDCAN_StateTypeDef state = hfdcan->State;
  uint32_t ITs_enabled;
  uint32_t ITs_lines_selection;

  /* Check function parameters */
  assert_param(IS_FDCAN_IT(InactiveITs));

  if ((state == HAL_FDCAN_STATE_READY) || (state == HAL_FDCAN_STATE_BUSY))
  {
    /* Disable the selected interrupts */
    __HAL_FDCAN_DISABLE_IT(hfdcan, InactiveITs);

    if ((InactiveITs & FDCAN_IT_TX_COMPLETE) != 0U)
    {
      /* Disable Tx Buffer Transmission Interrupts */
      CLEAR_REG(hfdcan->Instance->TXBTIE);
    }

    if ((InactiveITs & FDCAN_IT_TX_ABORT_COMPLETE) != 0U)
    {
      /* Disable Tx Buffer Cancellation Finished Interrupt */
      CLEAR_REG(hfdcan->Instance->TXBCIE);
    }

    /* Get interrupts enabled and interrupts line selection */
    ITs_enabled = hfdcan->Instance->IE;
    ITs_lines_selection = hfdcan->Instance->ILS;

    /* Check if some interrupts are still enabled on interrupt line 0 */
    if ((((ITs_enabled & FDCAN_IT_LIST_RX_FIFO0)       != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_RX_FIFO0)       == 0U)) || \
        (((ITs_enabled & FDCAN_IT_LIST_RX_FIFO1)       != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_RX_FIFO1)       == 0U)) || \
        (((ITs_enabled & FDCAN_IT_LIST_SMSG)           != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_SMSG)           == 0U)) || \
        (((ITs_enabled & FDCAN_IT_LIST_TX_FIFO_ERROR)  != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_TX_FIFO_ERROR)  == 0U)) || \
        (((ITs_enabled & FDCAN_IT_LIST_MISC)           != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_MISC)           == 0U)) || \
        (((ITs_enabled & FDCAN_IT_LIST_BIT_LINE_ERROR) != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_BIT_LINE_ERROR) == 0U)) || \
        (((ITs_enabled & FDCAN_IT_LIST_PROTOCOL_ERROR) != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_PROTOCOL_ERROR) == 0U)))
    {
      /* Do nothing */
    }
    else /* no more interrupts enabled on interrupt line 0 */
    {
      /* Disable interrupt line 0 */
      CLEAR_BIT(hfdcan->Instance->ILE, FDCAN_INTERRUPT_LINE0);
    }

    /* Check if some interrupts are still enabled on interrupt line 1 */
    if ((((ITs_enabled & FDCAN_IT_LIST_RX_FIFO0)       != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_RX_FIFO0)       != 0U)) || \
        (((ITs_enabled & FDCAN_IT_LIST_RX_FIFO1)       != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_RX_FIFO1)       != 0U)) || \
        (((ITs_enabled & FDCAN_IT_LIST_SMSG)           != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_SMSG)           != 0U)) || \
        (((ITs_enabled & FDCAN_IT_LIST_TX_FIFO_ERROR)  != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_TX_FIFO_ERROR)  != 0U)) || \
        (((ITs_enabled & FDCAN_IT_LIST_MISC)           != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_MISC)           != 0U)) || \
        (((ITs_enabled & FDCAN_IT_LIST_BIT_LINE_ERROR) != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_BIT_LINE_ERROR) != 0U)) || \
        (((ITs_enabled & FDCAN_IT_LIST_PROTOCOL_ERROR) != 0U)
         && (((ITs_lines_selection) & FDCAN_IT_GROUP_PROTOCOL_ERROR) != 0U)))
    {
      /* Do nothing */
    }
    else /* no more interrupts enabled on interrupt line 1 */
    {
      /* Disable interrupt line 1 */
      CLEAR_BIT(hfdcan->Instance->ILE, FDCAN_INTERRUPT_LINE1);
    }

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Update error code */
    hfdcan->ErrorCode |= HAL_FDCAN_ERROR_NOT_INITIALIZED;

    return HAL_ERROR;
  }
}

void HAL_FDCAN_IRQHandler(FDCAN_HandleTypeDef *hfdcan)
{
  uint32_t TxEventFifoITs;
  uint32_t RxFifo0ITs;
  uint32_t RxFifo1ITs;
  uint32_t Errors;
  uint32_t ErrorStatusITs;
  uint32_t TransmittedBuffers;
  uint32_t AbortedBuffers;
  uint32_t itsource;
  uint32_t itflag;

  TxEventFifoITs = hfdcan->Instance->IR & FDCAN_TX_EVENT_FIFO_MASK;
  TxEventFifoITs &= hfdcan->Instance->IE;
  RxFifo0ITs = hfdcan->Instance->IR & FDCAN_RX_FIFO0_MASK;
  RxFifo0ITs &= hfdcan->Instance->IE;
  RxFifo1ITs = hfdcan->Instance->IR & FDCAN_RX_FIFO1_MASK;
  RxFifo1ITs &= hfdcan->Instance->IE;
  Errors = hfdcan->Instance->IR & FDCAN_ERROR_MASK;
  Errors &= hfdcan->Instance->IE;
  ErrorStatusITs = hfdcan->Instance->IR & FDCAN_ERROR_STATUS_MASK;
  ErrorStatusITs &= hfdcan->Instance->IE;
  itsource = hfdcan->Instance->IE;
  itflag = hfdcan->Instance->IR;

  /* High Priority Message interrupt management *******************************/
  if (FDCAN_CHECK_FLAG(itflag, FDCAN_FLAG_RX_HIGH_PRIORITY_MSG) != RESET)
  {
    if (FDCAN_CHECK_IT_SOURCE(itsource, FDCAN_IT_RX_HIGH_PRIORITY_MSG) != RESET)
    {
      /* Clear the High Priority Message flag */
      __HAL_FDCAN_CLEAR_FLAG(hfdcan, FDCAN_FLAG_RX_HIGH_PRIORITY_MSG);

#if USE_HAL_FDCAN_REGISTER_CALLBACKS == 1
      /* Call registered callback*/
      hfdcan->HighPriorityMessageCallback(hfdcan);
#else
      /* High Priority Message Callback */
      HAL_FDCAN_HighPriorityMessageCallback(hfdcan);
#endif /* USE_HAL_FDCAN_REGISTER_CALLBACKS */
    }
  }

  /* Transmission Abort interrupt management **********************************/
  if (FDCAN_CHECK_FLAG(itflag, FDCAN_FLAG_TX_ABORT_COMPLETE) != RESET)
  {
    if (FDCAN_CHECK_IT_SOURCE(itsource, FDCAN_IT_TX_ABORT_COMPLETE) != RESET)
    {
      /* List of aborted monitored buffers */
      AbortedBuffers = hfdcan->Instance->TXBCF;
      AbortedBuffers &= hfdcan->Instance->TXBCIE;

      /* Clear the Transmission Cancellation flag */
      __HAL_FDCAN_CLEAR_FLAG(hfdcan, FDCAN_FLAG_TX_ABORT_COMPLETE);

#if USE_HAL_FDCAN_REGISTER_CALLBACKS == 1
      /* Call registered callback*/
      hfdcan->TxBufferAbortCallback(hfdcan, AbortedBuffers);
#else
      /* Transmission Cancellation Callback */
      HAL_FDCAN_TxBufferAbortCallback(hfdcan, AbortedBuffers);
#endif /* USE_HAL_FDCAN_REGISTER_CALLBACKS */
    }
  }

  /* Tx event FIFO interrupts management **************************************/
  if (TxEventFifoITs != 0U)
  {
    /* Clear the Tx Event FIFO flags */
    __HAL_FDCAN_CLEAR_FLAG(hfdcan, TxEventFifoITs);

#if USE_HAL_FDCAN_REGISTER_CALLBACKS == 1
    /* Call registered callback*/
    hfdcan->TxEventFifoCallback(hfdcan, TxEventFifoITs);
#else
    /* Tx Event FIFO Callback */
    HAL_FDCAN_TxEventFifoCallback(hfdcan, TxEventFifoITs);
#endif /* USE_HAL_FDCAN_REGISTER_CALLBACKS */
  }

  /* Rx FIFO 0 interrupts management ******************************************/
  if (RxFifo0ITs != 0U)
  {
    /* Clear the Rx FIFO 0 flags */
    __HAL_FDCAN_CLEAR_FLAG(hfdcan, RxFifo0ITs);

#if USE_HAL_FDCAN_REGISTER_CALLBACKS == 1
    /* Call registered callback*/
    hfdcan->RxFifo0Callback(hfdcan, RxFifo0ITs);
#else
    /* Rx FIFO 0 Callback */
    HAL_FDCAN_RxFifo0Callback(hfdcan, RxFifo0ITs);
#endif /* USE_HAL_FDCAN_REGISTER_CALLBACKS */
  }

  /* Rx FIFO 1 interrupts management ******************************************/
  if (RxFifo1ITs != 0U)
  {
    /* Clear the Rx FIFO 1 flags */
    __HAL_FDCAN_CLEAR_FLAG(hfdcan, RxFifo1ITs);

#if USE_HAL_FDCAN_REGISTER_CALLBACKS == 1
    /* Call registered callback*/
    hfdcan->RxFifo1Callback(hfdcan, RxFifo1ITs);
#else
    /* Rx FIFO 1 Callback */
    HAL_FDCAN_RxFifo1Callback(hfdcan, RxFifo1ITs);
#endif /* USE_HAL_FDCAN_REGISTER_CALLBACKS */
  }

  /* Tx FIFO empty interrupt management ***************************************/
  if (FDCAN_CHECK_FLAG(itflag, FDCAN_FLAG_TX_FIFO_EMPTY) != RESET)
  {
    if (FDCAN_CHECK_IT_SOURCE(itsource, FDCAN_IT_TX_FIFO_EMPTY) != RESET)
    {
      /* Clear the Tx FIFO empty flag */
      __HAL_FDCAN_CLEAR_FLAG(hfdcan, FDCAN_FLAG_TX_FIFO_EMPTY);

#if USE_HAL_FDCAN_REGISTER_CALLBACKS == 1
      /* Call registered callback*/
      hfdcan->TxFifoEmptyCallback(hfdcan);
#else
      /* Tx FIFO empty Callback */
      HAL_FDCAN_TxFifoEmptyCallback(hfdcan);
#endif /* USE_HAL_FDCAN_REGISTER_CALLBACKS */
    }
  }

  /* Transmission Complete interrupt management *******************************/
  if (FDCAN_CHECK_FLAG(itflag, FDCAN_FLAG_TX_COMPLETE) != RESET)
  {
    if (FDCAN_CHECK_IT_SOURCE(itsource, FDCAN_IT_TX_COMPLETE) != RESET)
    {
      /* List of transmitted monitored buffers */
      TransmittedBuffers = hfdcan->Instance->TXBTO;
      TransmittedBuffers &= hfdcan->Instance->TXBTIE;

      /* Clear the Transmission Complete flag */
      __HAL_FDCAN_CLEAR_FLAG(hfdcan, FDCAN_FLAG_TX_COMPLETE);

#if USE_HAL_FDCAN_REGISTER_CALLBACKS == 1
      /* Call registered callback*/
      hfdcan->TxBufferCompleteCallback(hfdcan, TransmittedBuffers);
#else
      /* Transmission Complete Callback */
      HAL_FDCAN_TxBufferCompleteCallback(hfdcan, TransmittedBuffers);
#endif /* USE_HAL_FDCAN_REGISTER_CALLBACKS */
    }
  }

  /* Timestamp Wraparound interrupt management ********************************/
  if (FDCAN_CHECK_FLAG(itflag, FDCAN_FLAG_TIMESTAMP_WRAPAROUND) != RESET)
  {
    if (FDCAN_CHECK_IT_SOURCE(itsource, FDCAN_IT_TIMESTAMP_WRAPAROUND) != RESET)
    {
      /* Clear the Timestamp Wraparound flag */
      __HAL_FDCAN_CLEAR_FLAG(hfdcan, FDCAN_FLAG_TIMESTAMP_WRAPAROUND);

#if USE_HAL_FDCAN_REGISTER_CALLBACKS == 1
      /* Call registered callback*/
      hfdcan->TimestampWraparoundCallback(hfdcan);
#else
      /* Timestamp Wraparound Callback */
      HAL_FDCAN_TimestampWraparoundCallback(hfdcan);
#endif /* USE_HAL_FDCAN_REGISTER_CALLBACKS */
    }
  }

  /* Timeout Occurred interrupt management ************************************/
  if (FDCAN_CHECK_FLAG(itflag, FDCAN_FLAG_TIMEOUT_OCCURRED) != RESET)
  {
    if (FDCAN_CHECK_IT_SOURCE(itsource, FDCAN_IT_TIMEOUT_OCCURRED) != RESET)
    {
      /* Clear the Timeout Occurred flag */
      __HAL_FDCAN_CLEAR_FLAG(hfdcan, FDCAN_FLAG_TIMEOUT_OCCURRED);

#if USE_HAL_FDCAN_REGISTER_CALLBACKS == 1
      /* Call registered callback*/
      hfdcan->TimeoutOccurredCallback(hfdcan);
#else
      /* Timeout Occurred Callback */
      HAL_FDCAN_TimeoutOccurredCallback(hfdcan);
#endif /* USE_HAL_FDCAN_REGISTER_CALLBACKS */
    }
  }

  /* Message RAM access failure interrupt management **************************/
  if (FDCAN_CHECK_FLAG(itflag, FDCAN_FLAG_RAM_ACCESS_FAILURE) != RESET)
  {
    if (FDCAN_CHECK_IT_SOURCE(itsource, FDCAN_IT_RAM_ACCESS_FAILURE) != RESET)
    {
      /* Clear the Message RAM access failure flag */
      __HAL_FDCAN_CLEAR_FLAG(hfdcan, FDCAN_FLAG_RAM_ACCESS_FAILURE);

      /* Update error code */
      hfdcan->ErrorCode |= HAL_FDCAN_ERROR_RAM_ACCESS;
    }
  }

  /* Error Status interrupts management ***************************************/
  if (ErrorStatusITs != 0U)
  {
    /* Clear the Error flags */
    __HAL_FDCAN_CLEAR_FLAG(hfdcan, ErrorStatusITs);

#if USE_HAL_FDCAN_REGISTER_CALLBACKS == 1
    /* Call registered callback*/
    hfdcan->ErrorStatusCallback(hfdcan, ErrorStatusITs);
#else
    /* Error Status Callback */
    HAL_FDCAN_ErrorStatusCallback(hfdcan, ErrorStatusITs);
#endif /* USE_HAL_FDCAN_REGISTER_CALLBACKS */
  }

  /* Error interrupts management **********************************************/
  if (Errors != 0U)
  {
    /* Clear the Error flags */
    __HAL_FDCAN_CLEAR_FLAG(hfdcan, Errors);

    /* Update error code */
    hfdcan->ErrorCode |= Errors;
  }

  if (hfdcan->ErrorCode != HAL_FDCAN_ERROR_NONE)
  {
#if USE_HAL_FDCAN_REGISTER_CALLBACKS == 1
    /* Call registered callback*/
    hfdcan->ErrorCallback(hfdcan);
#else
    /* Error Callback */
    HAL_FDCAN_ErrorCallback(hfdcan);
#endif /* USE_HAL_FDCAN_REGISTER_CALLBACKS */
  }
}

HAL_FDCAN_StateTypeDef HAL_FDCAN_GetState(const FDCAN_HandleTypeDef *hfdcan)
{
  /* Return FDCAN state */
  return hfdcan->State;
}

uint32_t HAL_FDCAN_GetError(const FDCAN_HandleTypeDef *hfdcan)
{
  /* Return FDCAN error code */
  return hfdcan->ErrorCode;
}

#if UINTPTR_MAX > UINT32_MAX
#include "FDCANHostRamAddresses.inc"
#else
#include "Upstream/FDCANRamAddresses.inc"
#endif

static void FDCAN_CopyMessageToRAM(const FDCAN_HandleTypeDef *hfdcan, const FDCAN_TxHeaderTypeDef *pTxHeader,
                                   const uint8_t *pTxData, uint32_t BufferIndex)
{
  uint32_t TxElementW1;
  uint32_t TxElementW2;
  uint32_t *TxAddress;
  uint32_t ByteCounter;

  /* Build first word of Tx header element */
  if (pTxHeader->IdType == FDCAN_STANDARD_ID)
  {
    TxElementW1 = (pTxHeader->ErrorStateIndicator |
                   FDCAN_STANDARD_ID |
                   pTxHeader->TxFrameType |
                   (pTxHeader->Identifier << 18U));
  }
  else /* pTxHeader->IdType == FDCAN_EXTENDED_ID */
  {
    TxElementW1 = (pTxHeader->ErrorStateIndicator |
                   FDCAN_EXTENDED_ID |
                   pTxHeader->TxFrameType |
                   pTxHeader->Identifier);
  }

  /* Build second word of Tx header element */
  TxElementW2 = ((pTxHeader->MessageMarker << 24U) |
                 pTxHeader->TxEventFifoControl |
                 pTxHeader->FDFormat |
                 pTxHeader->BitRateSwitch |
                 (pTxHeader->DataLength << 16U));

  /* Calculate Tx element address */
  TxAddress = (uint32_t *)(hfdcan->msgRam.TxFIFOQSA + (BufferIndex * SRAMCAN_TFQ_SIZE));

  /* Write Tx element header to the message RAM */
  *TxAddress = TxElementW1;
  TxAddress++;
  *TxAddress = TxElementW2;
  TxAddress++;

  /* Write Tx payload to the message RAM */
  for (ByteCounter = 0; ByteCounter < DLCtoBytes[pTxHeader->DataLength]; ByteCounter += 4U)
  {
    *TxAddress = (((uint32_t)pTxData[ByteCounter + 3U] << 24U) |
                  ((uint32_t)pTxData[ByteCounter + 2U] << 16U) |
                  ((uint32_t)pTxData[ByteCounter + 1U] << 8U)  |
                  (uint32_t)pTxData[ByteCounter]);
    TxAddress++;
  }
}
