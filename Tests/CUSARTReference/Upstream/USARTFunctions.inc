// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USART/USARTEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

HAL_StatusTypeDef HAL_USART_Init(USART_HandleTypeDef *husart)
{
  /* Check the USART handle allocation */
  if (husart == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_USART_INSTANCE(husart->Instance));

  if (husart->State == HAL_USART_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    husart->Lock = HAL_UNLOCKED;

#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
    USART_InitCallbacksToDefault(husart);

    if (husart->MspInitCallback == NULL)
    {
      husart->MspInitCallback = HAL_USART_MspInit;
    }

    /* Init the low level hardware */
    husart->MspInitCallback(husart);
#else
    /* Init the low level hardware : GPIO, CLOCK */
    HAL_USART_MspInit(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
  }

  husart->State = HAL_USART_STATE_BUSY;

  /* Disable the Peripheral */
  __HAL_USART_DISABLE(husart);

  /* Set the Usart Communication parameters */
  if (USART_SetConfig(husart) == HAL_ERROR)
  {
    return HAL_ERROR;
  }

  /* In Synchronous SPI mode, the following bits must be kept cleared:
  - LINEN bit in the USART_CR2 register
  - HDSEL, SCEN and IREN bits in the USART_CR3 register.
  */
  husart->Instance->CR2 &= ~USART_CR2_LINEN;
  husart->Instance->CR3 &= ~(USART_CR3_SCEN | USART_CR3_HDSEL | USART_CR3_IREN);

  /* Enable the Peripheral */
  __HAL_USART_ENABLE(husart);

  /* TEACK and/or REACK to check before moving husart->State to Ready */
  return (USART_CheckIdleState(husart));
}

HAL_StatusTypeDef HAL_USART_DeInit(USART_HandleTypeDef *husart)
{
  /* Check the USART handle allocation */
  if (husart == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_USART_INSTANCE(husart->Instance));

  husart->State = HAL_USART_STATE_BUSY;

  husart->Instance->CR1 = 0x0U;
  husart->Instance->CR2 = 0x0U;
  husart->Instance->CR3 = 0x0U;

#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
  if (husart->MspDeInitCallback == NULL)
  {
    husart->MspDeInitCallback = HAL_USART_MspDeInit;
  }
  /* DeInit the low level hardware */
  husart->MspDeInitCallback(husart);
#else
  /* DeInit the low level hardware */
  HAL_USART_MspDeInit(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */

  husart->ErrorCode = HAL_USART_ERROR_NONE;
  husart->State = HAL_USART_STATE_RESET;

  /* Process Unlock */
  __HAL_UNLOCK(husart);

  return HAL_OK;
}

#if F_MODE
HAL_StatusTypeDef HAL_USART_RegisterCallback(USART_HandleTypeDef *husart, HAL_USART_CallbackIDTypeDef CallbackID,
                                             pUSART_CallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    husart->ErrorCode |= HAL_USART_ERROR_INVALID_CALLBACK;

    return HAL_ERROR;
  }

  if (husart->State == HAL_USART_STATE_READY)
  {
    switch (CallbackID)
    {
      case HAL_USART_TX_HALFCOMPLETE_CB_ID :
        husart->TxHalfCpltCallback = pCallback;
        break;

      case HAL_USART_TX_COMPLETE_CB_ID :
        husart->TxCpltCallback = pCallback;
        break;

      case HAL_USART_RX_HALFCOMPLETE_CB_ID :
        husart->RxHalfCpltCallback = pCallback;
        break;

      case HAL_USART_RX_COMPLETE_CB_ID :
        husart->RxCpltCallback = pCallback;
        break;

      case HAL_USART_TX_RX_COMPLETE_CB_ID :
        husart->TxRxCpltCallback = pCallback;
        break;

      case HAL_USART_ERROR_CB_ID :
        husart->ErrorCallback = pCallback;
        break;

      case HAL_USART_ABORT_COMPLETE_CB_ID :
        husart->AbortCpltCallback = pCallback;
        break;

      case HAL_USART_RX_FIFO_FULL_CB_ID :
        husart->RxFifoFullCallback = pCallback;
        break;

      case HAL_USART_TX_FIFO_EMPTY_CB_ID :
        husart->TxFifoEmptyCallback = pCallback;
        break;

      case HAL_USART_MSPINIT_CB_ID :
        husart->MspInitCallback = pCallback;
        break;

      case HAL_USART_MSPDEINIT_CB_ID :
        husart->MspDeInitCallback = pCallback;
        break;

      default :
        /* Update the error code */
        husart->ErrorCode |= HAL_USART_ERROR_INVALID_CALLBACK;

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (husart->State == HAL_USART_STATE_RESET)
  {
    switch (CallbackID)
    {
      case HAL_USART_MSPINIT_CB_ID :
        husart->MspInitCallback = pCallback;
        break;

      case HAL_USART_MSPDEINIT_CB_ID :
        husart->MspDeInitCallback = pCallback;
        break;

      default :
        /* Update the error code */
        husart->ErrorCode |= HAL_USART_ERROR_INVALID_CALLBACK;

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    husart->ErrorCode |= HAL_USART_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif

#if F_MODE
HAL_StatusTypeDef HAL_USART_UnRegisterCallback(USART_HandleTypeDef *husart, HAL_USART_CallbackIDTypeDef CallbackID)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (HAL_USART_STATE_READY == husart->State)
  {
    switch (CallbackID)
    {
      case HAL_USART_TX_HALFCOMPLETE_CB_ID :
        husart->TxHalfCpltCallback = HAL_USART_TxHalfCpltCallback;               /* Legacy weak  TxHalfCpltCallback  */
        break;

      case HAL_USART_TX_COMPLETE_CB_ID :
        husart->TxCpltCallback = HAL_USART_TxCpltCallback;                       /* Legacy weak TxCpltCallback       */
        break;

      case HAL_USART_RX_HALFCOMPLETE_CB_ID :
        husart->RxHalfCpltCallback = HAL_USART_RxHalfCpltCallback;               /* Legacy weak RxHalfCpltCallback   */
        break;

      case HAL_USART_RX_COMPLETE_CB_ID :
        husart->RxCpltCallback = HAL_USART_RxCpltCallback;                       /* Legacy weak RxCpltCallback       */
        break;

      case HAL_USART_TX_RX_COMPLETE_CB_ID :
        husart->TxRxCpltCallback = HAL_USART_TxRxCpltCallback;                   /* Legacy weak TxRxCpltCallback     */
        break;

      case HAL_USART_ERROR_CB_ID :
        husart->ErrorCallback = HAL_USART_ErrorCallback;                         /* Legacy weak ErrorCallback        */
        break;

      case HAL_USART_ABORT_COMPLETE_CB_ID :
        husart->AbortCpltCallback = HAL_USART_AbortCpltCallback;                 /* Legacy weak AbortCpltCallback    */
        break;

      case HAL_USART_RX_FIFO_FULL_CB_ID :
        husart->RxFifoFullCallback = HAL_USARTEx_RxFifoFullCallback;             /* Legacy weak RxFifoFullCallback   */
        break;

      case HAL_USART_TX_FIFO_EMPTY_CB_ID :
        husart->TxFifoEmptyCallback = HAL_USARTEx_TxFifoEmptyCallback;           /* Legacy weak TxFifoEmptyCallback  */
        break;

      case HAL_USART_MSPINIT_CB_ID :
        husart->MspInitCallback = HAL_USART_MspInit;                             /* Legacy weak MspInitCallback      */
        break;

      case HAL_USART_MSPDEINIT_CB_ID :
        husart->MspDeInitCallback = HAL_USART_MspDeInit;                         /* Legacy weak MspDeInitCallback    */
        break;

      default :
        /* Update the error code */
        husart->ErrorCode |= HAL_USART_ERROR_INVALID_CALLBACK;

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (HAL_USART_STATE_RESET == husart->State)
  {
    switch (CallbackID)
    {
      case HAL_USART_MSPINIT_CB_ID :
        husart->MspInitCallback = HAL_USART_MspInit;
        break;

      case HAL_USART_MSPDEINIT_CB_ID :
        husart->MspDeInitCallback = HAL_USART_MspDeInit;
        break;

      default :
        /* Update the error code */
        husart->ErrorCode |= HAL_USART_ERROR_INVALID_CALLBACK;

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    husart->ErrorCode |= HAL_USART_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif

HAL_StatusTypeDef HAL_USART_Transmit(USART_HandleTypeDef *husart, const uint8_t *pTxData, uint16_t Size,
                                     uint32_t Timeout)
{
  const uint8_t  *ptxdata8bits;
  const uint16_t *ptxdata16bits;
  uint32_t tickstart;

  if (husart->State == HAL_USART_STATE_READY)
  {
    if ((pTxData == NULL) || (Size == 0U))
    {
      return  HAL_ERROR;
    }

    /* Process Locked */
    __HAL_LOCK(husart);

    husart->ErrorCode = HAL_USART_ERROR_NONE;
    husart->State = HAL_USART_STATE_BUSY_TX;

    /* Init tickstart for timeout management */
    tickstart = HAL_GetTick();

    husart->TxXferSize = Size;
    husart->TxXferCount = Size;

    /* In case of 9bits/No Parity transfer, pTxData needs to be handled as a uint16_t pointer */
    if ((husart->Init.WordLength == USART_WORDLENGTH_9B) && (husart->Init.Parity == USART_PARITY_NONE))
    {
      ptxdata8bits  = NULL;
      ptxdata16bits = (const uint16_t *) pTxData;
    }
    else
    {
      ptxdata8bits  = pTxData;
      ptxdata16bits = NULL;
    }

    /* Check the remaining data to be sent */
    while (husart->TxXferCount > 0U)
    {
      if (USART_WaitOnFlagUntilTimeout(husart, USART_FLAG_TXE, RESET, tickstart, Timeout) != HAL_OK)
      {
        return HAL_TIMEOUT;
      }
      if (ptxdata8bits == NULL)
      {
        husart->Instance->TDR = (uint16_t)(*ptxdata16bits & 0x01FFU);
        ptxdata16bits++;
      }
      else
      {
        husart->Instance->TDR = (uint8_t)(*ptxdata8bits & 0xFFU);
        ptxdata8bits++;
      }

      husart->TxXferCount--;
    }

    if (USART_WaitOnFlagUntilTimeout(husart, USART_FLAG_TC, RESET, tickstart, Timeout) != HAL_OK)
    {
      return HAL_TIMEOUT;
    }

    /* Clear Transmission Complete Flag */
    __HAL_USART_CLEAR_FLAG(husart, USART_CLEAR_TCF);

    /* Clear overrun flag and discard the received data */
    __HAL_USART_CLEAR_OREFLAG(husart);
    __HAL_USART_SEND_REQ(husart, USART_RXDATA_FLUSH_REQUEST);
    __HAL_USART_SEND_REQ(husart, USART_TXDATA_FLUSH_REQUEST);

    /* At end of Tx process, restore husart->State to Ready */
    husart->State = HAL_USART_STATE_READY;

    /* Process Unlocked */
    __HAL_UNLOCK(husart);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}

HAL_StatusTypeDef HAL_USART_Receive(USART_HandleTypeDef *husart, uint8_t *pRxData, uint16_t Size, uint32_t Timeout)
{
  uint8_t  *prxdata8bits;
  uint16_t *prxdata16bits;
  uint16_t uhMask;
  uint32_t tickstart;

  if (husart->State == HAL_USART_STATE_READY)
  {
    if ((pRxData == NULL) || (Size == 0U))
    {
      return  HAL_ERROR;
    }

    /* Process Locked */
    __HAL_LOCK(husart);

    husart->ErrorCode = HAL_USART_ERROR_NONE;
    husart->State = HAL_USART_STATE_BUSY_RX;

    /* Init tickstart for timeout management */
    tickstart = HAL_GetTick();

    husart->RxXferSize = Size;
    husart->RxXferCount = Size;

    /* Computation of USART mask to apply to RDR register */
    USART_MASK_COMPUTATION(husart);
    uhMask = husart->Mask;

    /* In case of 9bits/No Parity transfer, pRxData needs to be handled as a uint16_t pointer */
    if ((husart->Init.WordLength == USART_WORDLENGTH_9B) && (husart->Init.Parity == USART_PARITY_NONE))
    {
      prxdata8bits  = NULL;
      prxdata16bits = (uint16_t *) pRxData;
    }
    else
    {
      prxdata8bits  = pRxData;
      prxdata16bits = NULL;
    }

    /* as long as data have to be received */
    while (husart->RxXferCount > 0U)
    {
      if (husart->SlaveMode == USART_SLAVEMODE_DISABLE)
      {
        /* Wait until TXE flag is set to send dummy byte in order to generate the
        * clock for the slave to send data.
        * Whatever the frame length (7, 8 or 9-bit long), the same dummy value
        * can be written for all the cases. */
        if (USART_WaitOnFlagUntilTimeout(husart, USART_FLAG_TXE, RESET, tickstart, Timeout) != HAL_OK)
        {
          return HAL_TIMEOUT;
        }
        husart->Instance->TDR = (USART_DUMMY_DATA & (uint16_t)0x0FF);
      }

      /* Wait for RXNE Flag */
      if (USART_WaitOnFlagUntilTimeout(husart, USART_FLAG_RXNE, RESET, tickstart, Timeout) != HAL_OK)
      {
        return HAL_TIMEOUT;
      }

      if (prxdata8bits == NULL)
      {
        *prxdata16bits = (uint16_t)(husart->Instance->RDR & uhMask);
        prxdata16bits++;
      }
      else
      {
        *prxdata8bits = (uint8_t)(husart->Instance->RDR & (uint8_t)(uhMask & 0xFFU));
        prxdata8bits++;
      }

      husart->RxXferCount--;

    }

    /* Clear SPI slave underrun flag and discard transmit data */
    if (husart->SlaveMode == USART_SLAVEMODE_ENABLE)
    {
      __HAL_USART_CLEAR_UDRFLAG(husart);
      __HAL_USART_SEND_REQ(husart, USART_TXDATA_FLUSH_REQUEST);
    }

    /* At end of Rx process, restore husart->State to Ready */
    husart->State = HAL_USART_STATE_READY;

    /* Process Unlocked */
    __HAL_UNLOCK(husart);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}

HAL_StatusTypeDef HAL_USART_TransmitReceive(USART_HandleTypeDef *husart, const uint8_t *pTxData, uint8_t *pRxData,
                                            uint16_t Size, uint32_t Timeout)
{
  uint8_t  *prxdata8bits;
  uint16_t *prxdata16bits;
  const uint8_t  *ptxdata8bits;
  const uint16_t *ptxdata16bits;
  uint16_t uhMask;
  uint16_t rxdatacount;
  uint32_t tickstart;

  if (husart->State == HAL_USART_STATE_READY)
  {
    if ((pTxData == NULL) || (pRxData == NULL) || (Size == 0U))
    {
      return  HAL_ERROR;
    }

    /* Process Locked */
    __HAL_LOCK(husart);

    husart->ErrorCode = HAL_USART_ERROR_NONE;
    husart->State = HAL_USART_STATE_BUSY_RX;

    /* Init tickstart for timeout management */
    tickstart = HAL_GetTick();

    husart->RxXferSize = Size;
    husart->TxXferSize = Size;
    husart->TxXferCount = Size;
    husart->RxXferCount = Size;

    /* Computation of USART mask to apply to RDR register */
    USART_MASK_COMPUTATION(husart);
    uhMask = husart->Mask;

    /* In case of 9bits/No Parity transfer, pRxData needs to be handled as a uint16_t pointer */
    if ((husart->Init.WordLength == USART_WORDLENGTH_9B) && (husart->Init.Parity == USART_PARITY_NONE))
    {
      prxdata8bits  = NULL;
      ptxdata8bits  = NULL;
      ptxdata16bits = (const uint16_t *) pTxData;
      prxdata16bits = (uint16_t *) pRxData;
    }
    else
    {
      prxdata8bits  = pRxData;
      ptxdata8bits  = pTxData;
      ptxdata16bits = NULL;
      prxdata16bits = NULL;
    }

    if ((husart->TxXferCount == 0x01U) || (husart->SlaveMode == USART_SLAVEMODE_ENABLE))
    {
      /* Wait until TXE flag is set to send data */
      if (USART_WaitOnFlagUntilTimeout(husart, USART_FLAG_TXE, RESET, tickstart, Timeout) != HAL_OK)
      {
        return HAL_TIMEOUT;
      }
      if (ptxdata8bits == NULL)
      {
        husart->Instance->TDR = (uint16_t)(*ptxdata16bits & uhMask);
        ptxdata16bits++;
      }
      else
      {
        husart->Instance->TDR = (uint8_t)(*ptxdata8bits & (uint8_t)(uhMask & 0xFFU));
        ptxdata8bits++;
      }

      husart->TxXferCount--;
    }

    /* Check the remain data to be sent */
    /* rxdatacount is a temporary variable for MISRAC2012-Rule-13.5 */
    rxdatacount = husart->RxXferCount;
    while ((husart->TxXferCount > 0U) || (rxdatacount > 0U))
    {
      if (husart->TxXferCount > 0U)
      {
        /* Wait until TXE flag is set to send data */
        if (USART_WaitOnFlagUntilTimeout(husart, USART_FLAG_TXE, RESET, tickstart, Timeout) != HAL_OK)
        {
          return HAL_TIMEOUT;
        }
        if (ptxdata8bits == NULL)
        {
          husart->Instance->TDR = (uint16_t)(*ptxdata16bits & uhMask);
          ptxdata16bits++;
        }
        else
        {
          husart->Instance->TDR = (uint8_t)(*ptxdata8bits & (uint8_t)(uhMask & 0xFFU));
          ptxdata8bits++;
        }

        husart->TxXferCount--;
      }

      if (husart->RxXferCount > 0U)
      {
        /* Wait for RXNE Flag */
        if (USART_WaitOnFlagUntilTimeout(husart, USART_FLAG_RXNE, RESET, tickstart, Timeout) != HAL_OK)
        {
          return HAL_TIMEOUT;
        }

        if (prxdata8bits == NULL)
        {
          *prxdata16bits = (uint16_t)(husart->Instance->RDR & uhMask);
          prxdata16bits++;
        }
        else
        {
          *prxdata8bits = (uint8_t)(husart->Instance->RDR & (uint8_t)(uhMask & 0xFFU));
          prxdata8bits++;
        }

        husart->RxXferCount--;
      }
      rxdatacount = husart->RxXferCount;
    }

    /* At end of TxRx process, restore husart->State to Ready */
    husart->State = HAL_USART_STATE_READY;

    /* Process Unlocked */
    __HAL_UNLOCK(husart);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}

HAL_StatusTypeDef HAL_USART_Transmit_IT(USART_HandleTypeDef *husart, const uint8_t *pTxData, uint16_t Size)
{
  if (husart->State == HAL_USART_STATE_READY)
  {
    if ((pTxData == NULL) || (Size == 0U))
    {
      return HAL_ERROR;
    }

    /* Process Locked */
    __HAL_LOCK(husart);

    husart->pTxBuffPtr  = pTxData;
    husart->TxXferSize  = Size;
    husart->TxXferCount = Size;
    husart->TxISR       = NULL;

    husart->ErrorCode = HAL_USART_ERROR_NONE;
    husart->State     = HAL_USART_STATE_BUSY_TX;

    /* The USART Error Interrupts: (Frame error, noise error, overrun error)
    are not managed by the USART Transmit Process to avoid the overrun interrupt
    when the usart mode is configured for transmit and receive "USART_MODE_TX_RX"
    to benefit for the frame error and noise interrupts the usart mode should be
    configured only for transmit "USART_MODE_TX" */

    /* Configure Tx interrupt processing */
    if (husart->FifoMode == USART_FIFOMODE_ENABLE)
    {
      /* Set the Tx ISR function pointer according to the data word length */
      if ((husart->Init.WordLength == USART_WORDLENGTH_9B) && (husart->Init.Parity == USART_PARITY_NONE))
      {
        husart->TxISR = USART_TxISR_16BIT_FIFOEN;
      }
      else
      {
        husart->TxISR = USART_TxISR_8BIT_FIFOEN;
      }

      /* Process Unlocked */
      __HAL_UNLOCK(husart);

      /* Enable the TX FIFO threshold interrupt */
      __HAL_USART_ENABLE_IT(husart, USART_IT_TXFT);
    }
    else
    {
      /* Set the Tx ISR function pointer according to the data word length */
      if ((husart->Init.WordLength == USART_WORDLENGTH_9B) && (husart->Init.Parity == USART_PARITY_NONE))
      {
        husart->TxISR = USART_TxISR_16BIT;
      }
      else
      {
        husart->TxISR = USART_TxISR_8BIT;
      }

      /* Process Unlocked */
      __HAL_UNLOCK(husart);

      /* Enable the USART Transmit Data Register Empty Interrupt */
      __HAL_USART_ENABLE_IT(husart, USART_IT_TXE);
    }

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}

HAL_StatusTypeDef HAL_USART_Receive_IT(USART_HandleTypeDef *husart, uint8_t *pRxData, uint16_t Size)
{
  uint16_t nb_dummy_data;

  if (husart->State == HAL_USART_STATE_READY)
  {
    if ((pRxData == NULL) || (Size == 0U))
    {
      return HAL_ERROR;
    }

    /* Process Locked */
    __HAL_LOCK(husart);

    husart->pRxBuffPtr  = pRxData;
    husart->RxXferSize  = Size;
    husart->RxXferCount = Size;
    husart->RxISR       = NULL;

    USART_MASK_COMPUTATION(husart);

    husart->ErrorCode = HAL_USART_ERROR_NONE;
    husart->State = HAL_USART_STATE_BUSY_RX;

    /* Enable the USART Error Interrupt: (Frame error, noise error, overrun error) */
    SET_BIT(husart->Instance->CR3, USART_CR3_EIE);

    /* Configure Rx interrupt processing */
    if ((husart->FifoMode == USART_FIFOMODE_ENABLE) && (Size >= husart->NbRxDataToProcess))
    {
      /* Set the Rx ISR function pointer according to the data word length */
      if ((husart->Init.WordLength == USART_WORDLENGTH_9B) && (husart->Init.Parity == USART_PARITY_NONE))
      {
        husart->RxISR = USART_RxISR_16BIT_FIFOEN;
      }
      else
      {
        husart->RxISR = USART_RxISR_8BIT_FIFOEN;
      }

      /* Process Unlocked */
      __HAL_UNLOCK(husart);

      /* Enable the USART Parity Error interrupt and RX FIFO Threshold interrupt */
      if (husart->Init.Parity != USART_PARITY_NONE)
      {
        SET_BIT(husart->Instance->CR1, USART_CR1_PEIE);
      }
      SET_BIT(husart->Instance->CR3, USART_CR3_RXFTIE);
    }
    else
    {
      /* Set the Rx ISR function pointer according to the data word length */
      if ((husart->Init.WordLength == USART_WORDLENGTH_9B) && (husart->Init.Parity == USART_PARITY_NONE))
      {
        husart->RxISR = USART_RxISR_16BIT;
      }
      else
      {
        husart->RxISR = USART_RxISR_8BIT;
      }

      /* Process Unlocked */
      __HAL_UNLOCK(husart);

      /* Enable the USART Parity Error and Data Register not empty Interrupts */
      if (husart->Init.Parity != USART_PARITY_NONE)
      {
        SET_BIT(husart->Instance->CR1, USART_CR1_PEIE | USART_CR1_RXNEIE_RXFNEIE);
      }
      else
      {
        SET_BIT(husart->Instance->CR1, USART_CR1_RXNEIE_RXFNEIE);
      }
    }

    if (husart->SlaveMode == USART_SLAVEMODE_DISABLE)
    {
      /* Send dummy data in order to generate the clock for the Slave to send the next data.
         When FIFO mode is disabled only one data must be transferred.
         When FIFO mode is enabled data must be transmitted until the RX FIFO reaches its threshold.
      */
      if ((husart->FifoMode == USART_FIFOMODE_ENABLE) && (Size >= husart->NbRxDataToProcess))
      {
        for (nb_dummy_data = husart->NbRxDataToProcess ; nb_dummy_data > 0U ; nb_dummy_data--)
        {
          husart->Instance->TDR = (USART_DUMMY_DATA & (uint16_t)0x00FF);
        }
      }
      else
      {
        husart->Instance->TDR = (USART_DUMMY_DATA & (uint16_t)0x00FF);
      }
    }

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}

HAL_StatusTypeDef HAL_USART_TransmitReceive_IT(USART_HandleTypeDef *husart, const uint8_t *pTxData, uint8_t *pRxData,
                                               uint16_t Size)
{

  if (husart->State == HAL_USART_STATE_READY)
  {
    if ((pTxData == NULL) || (pRxData == NULL) || (Size == 0U))
    {
      return HAL_ERROR;
    }

    /* Process Locked */
    __HAL_LOCK(husart);

    husart->pRxBuffPtr = pRxData;
    husart->RxXferSize = Size;
    husart->RxXferCount = Size;
    husart->pTxBuffPtr = pTxData;
    husart->TxXferSize = Size;
    husart->TxXferCount = Size;

    /* Computation of USART mask to apply to RDR register */
    USART_MASK_COMPUTATION(husart);

    husart->ErrorCode = HAL_USART_ERROR_NONE;
    husart->State = HAL_USART_STATE_BUSY_TX_RX;

    /* Configure TxRx interrupt processing */
    if ((husart->FifoMode == USART_FIFOMODE_ENABLE) && (Size >= husart->NbRxDataToProcess))
    {
      /* Set the Rx ISR function pointer according to the data word length */
      if ((husart->Init.WordLength == USART_WORDLENGTH_9B) && (husart->Init.Parity == USART_PARITY_NONE))
      {
        husart->TxISR = USART_TxISR_16BIT_FIFOEN;
        husart->RxISR = USART_RxISR_16BIT_FIFOEN;
      }
      else
      {
        husart->TxISR = USART_TxISR_8BIT_FIFOEN;
        husart->RxISR = USART_RxISR_8BIT_FIFOEN;
      }

      /* Process Locked */
      __HAL_UNLOCK(husart);

      /* Enable the USART Error Interrupt: (Frame error, noise error, overrun error) */
      SET_BIT(husart->Instance->CR3, USART_CR3_EIE);

      if (husart->Init.Parity != USART_PARITY_NONE)
      {
        /* Enable the USART Parity Error interrupt  */
        SET_BIT(husart->Instance->CR1, USART_CR1_PEIE);
      }

      /* Enable the TX and  RX FIFO Threshold interrupts */
      SET_BIT(husart->Instance->CR3, (USART_CR3_TXFTIE | USART_CR3_RXFTIE));
    }
    else
    {
      if ((husart->Init.WordLength == USART_WORDLENGTH_9B) && (husart->Init.Parity == USART_PARITY_NONE))
      {
        husart->TxISR = USART_TxISR_16BIT;
        husart->RxISR = USART_RxISR_16BIT;
      }
      else
      {
        husart->TxISR = USART_TxISR_8BIT;
        husart->RxISR = USART_RxISR_8BIT;
      }

      /* Process Locked */
      __HAL_UNLOCK(husart);

      /* Enable the USART Error Interrupt: (Frame error, noise error, overrun error) */
      SET_BIT(husart->Instance->CR3, USART_CR3_EIE);

      /* Enable the USART Parity Error and USART Data Register not empty Interrupts */
      if (husart->Init.Parity != USART_PARITY_NONE)
      {
        SET_BIT(husart->Instance->CR1, USART_CR1_PEIE | USART_CR1_RXNEIE_RXFNEIE);
      }
      else
      {
        SET_BIT(husart->Instance->CR1, USART_CR1_RXNEIE_RXFNEIE);
      }

      /* Enable the USART Transmit Data Register Empty Interrupt */
      SET_BIT(husart->Instance->CR1, USART_CR1_TXEIE_TXFNFIE);
    }

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}

HAL_StatusTypeDef HAL_USART_Transmit_DMA(USART_HandleTypeDef *husart, const uint8_t *pTxData, uint16_t Size)
{
  HAL_StatusTypeDef status = HAL_OK;
  const uint32_t *tmp;
  uint16_t nbByte = Size;

  if (husart->State == HAL_USART_STATE_READY)
  {
    if ((pTxData == NULL) || (Size == 0U))
    {
      return HAL_ERROR;
    }

    /* Process Locked */
    __HAL_LOCK(husart);

    husart->pTxBuffPtr = pTxData;
    husart->TxXferSize = Size;
    husart->TxXferCount = Size;

    husart->ErrorCode = HAL_USART_ERROR_NONE;
    husart->State = HAL_USART_STATE_BUSY_TX;

    if (husart->hdmatx != NULL)
    {
      /* Set the USART DMA transfer complete callback */
      husart->hdmatx->XferCpltCallback = USART_DMATransmitCplt;

      /* Set the USART DMA Half transfer complete callback */
      husart->hdmatx->XferHalfCpltCallback = USART_DMATxHalfCplt;

      /* Set the DMA error callback */
      husart->hdmatx->XferErrorCallback = USART_DMAError;

      /* In case of 9bits/No Parity transfer, pTxData buffer provided as input parameter
         should be aligned on a u16 frontier, so nbByte should be equal to Size multiplied by 2 */
      if ((husart->Init.WordLength == USART_WORDLENGTH_9B) && (husart->Init.Parity == USART_PARITY_NONE))
      {
        nbByte = Size * 2U;
      }

      tmp = (const uint32_t *)&pTxData;

      /* Check linked list mode */
      if ((husart->hdmatx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
      {
        if ((husart->hdmatx->LinkedListQueue != NULL) && (husart->hdmatx->LinkedListQueue->Head != NULL))
        {
          /* Set DMA data size */
          husart->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = nbByte;

          /* Set DMA source address */
          husart->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = *(const uint32_t *)tmp;

          /* Set DMA destination address */
          husart->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] =
            (uint32_t)&husart->Instance->TDR;

          /* Enable the USART transmit DMA channel */
          status = HAL_DMAEx_List_Start_IT(husart->hdmatx);
        }
        else
        {
          /* Update status */
          status = HAL_ERROR;
        }
      }
      else
      {
        /* Enable the USART transmit DMA channel */
        status = HAL_DMA_Start_IT(husart->hdmatx, *(const uint32_t *)tmp, (uint32_t)&husart->Instance->TDR, nbByte);
      }
    }

    if (status == HAL_OK)
    {
      /* Clear the TC flag in the ICR register */
      __HAL_USART_CLEAR_FLAG(husart, USART_CLEAR_TCF);

      /* Process Unlocked */
      __HAL_UNLOCK(husart);

      /* Enable the DMA transfer for transmit request by setting the DMAT bit
         in the USART CR3 register */
      SET_BIT(husart->Instance->CR3, USART_CR3_DMAT);

      return HAL_OK;
    }
    else
    {
      /* Set error code to DMA */
      husart->ErrorCode = HAL_USART_ERROR_DMA;

      /* Process Unlocked */
      __HAL_UNLOCK(husart);

      /* Restore husart->State to ready */
      husart->State = HAL_USART_STATE_READY;

      return HAL_ERROR;
    }
  }
  else
  {
    return HAL_BUSY;
  }
}

HAL_StatusTypeDef HAL_USART_Receive_DMA(USART_HandleTypeDef *husart, uint8_t *pRxData, uint16_t Size)
{
  HAL_StatusTypeDef status = HAL_OK;
  uint32_t *tmp = (uint32_t *)&pRxData;
  uint16_t nbByte = Size;

  /* Check that a Rx process is not already ongoing */
  if (husart->State == HAL_USART_STATE_READY)
  {
    if ((pRxData == NULL) || (Size == 0U))
    {
      return HAL_ERROR;
    }

    /* Process Locked */
    __HAL_LOCK(husart);

    husart->pRxBuffPtr = pRxData;
    husart->RxXferSize = Size;
    husart->pTxBuffPtr = pRxData;
    husart->TxXferSize = Size;

    husart->ErrorCode = HAL_USART_ERROR_NONE;
    husart->State = HAL_USART_STATE_BUSY_RX;

    if (husart->hdmarx != NULL)
    {
      /* Set the USART DMA Rx transfer complete callback */
      husart->hdmarx->XferCpltCallback = USART_DMAReceiveCplt;

      /* Set the USART DMA Half transfer complete callback */
      husart->hdmarx->XferHalfCpltCallback = USART_DMARxHalfCplt;

      /* Set the USART DMA Rx transfer error callback */
      husart->hdmarx->XferErrorCallback = USART_DMAError;

      /* In case of 9bits/No Parity transfer, pTxData buffer provided as input parameter
         should be aligned on a u16 frontier, so nbByte should be equal to Size multiplied by 2 */
      if ((husart->Init.WordLength == USART_WORDLENGTH_9B) && (husart->Init.Parity == USART_PARITY_NONE))
      {
        nbByte = Size * 2U;
      }

      /* Check linked list mode */
      if ((husart->hdmarx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
      {
        if ((husart->hdmarx->LinkedListQueue != NULL) && (husart->hdmarx->LinkedListQueue->Head != NULL))
        {
          /* Set DMA data size */
          husart->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = nbByte;

          /* Set DMA source address */
          husart->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] =
            (uint32_t)&husart->Instance->RDR;

          /* Set DMA destination address */
          husart->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = *(uint32_t *)tmp;

          /* Enable the USART receive DMA channel */
          status = HAL_DMAEx_List_Start_IT(husart->hdmarx);
        }
        else
        {
          /* Update status */
          status = HAL_ERROR;
        }
      }
      else
      {
        /* Enable the USART receive DMA channel */
        status = HAL_DMA_Start_IT(husart->hdmarx, (uint32_t)&husart->Instance->RDR, *(uint32_t *)tmp, nbByte);
      }
    }

    if ((status == HAL_OK) &&
        (husart->SlaveMode == USART_SLAVEMODE_DISABLE))
    {
      /* Enable the USART transmit DMA channel: the transmit channel is used in order
         to generate in the non-blocking mode the clock to the slave device,
         this mode isn't a simplex receive mode but a full-duplex receive mode */

      /* Set the USART DMA Tx Complete and Error callback to Null */
      if (husart->hdmatx != NULL)
      {
        husart->hdmatx->XferErrorCallback = NULL;
        husart->hdmatx->XferHalfCpltCallback = NULL;
        husart->hdmatx->XferCpltCallback = NULL;

        /* Check linked list mode */
        if ((husart->hdmatx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
        {
          if ((husart->hdmatx->LinkedListQueue != NULL) && (husart->hdmatx->LinkedListQueue->Head != NULL))
          {
            /* Set DMA data size */
            husart->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = nbByte;

            /* Set DMA source address */
            husart->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = *(uint32_t *)tmp;

            /* Set DMA destination address */
            husart->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] =
              (uint32_t)&husart->Instance->TDR;

            /* Enable the USART transmit DMA channel */
            status = HAL_DMAEx_List_Start_IT(husart->hdmatx);
          }
          else
          {
            /* Update status */
            status = HAL_ERROR;
          }
        }
        else
        {
          status = HAL_DMA_Start_IT(husart->hdmatx, *(uint32_t *)tmp, (uint32_t)&husart->Instance->TDR, nbByte);
        }
      }
    }

    if (status == HAL_OK)
    {
      /* Process Unlocked */
      __HAL_UNLOCK(husart);

      if (husart->Init.Parity != USART_PARITY_NONE)
      {
        /* Enable the USART Parity Error Interrupt */
        SET_BIT(husart->Instance->CR1, USART_CR1_PEIE);
      }

      /* Enable the USART Error Interrupt: (Frame error, noise error, overrun error) */
      SET_BIT(husart->Instance->CR3, USART_CR3_EIE);

      /* Enable the DMA transfer for the receiver request by setting the DMAR bit
         in the USART CR3 register */
      SET_BIT(husart->Instance->CR3, USART_CR3_DMAR);

      /* Enable the DMA transfer for transmit request by setting the DMAT bit
         in the USART CR3 register */
      SET_BIT(husart->Instance->CR3, USART_CR3_DMAT);

      return HAL_OK;
    }
    else
    {
      if ((husart->hdmarx != NULL) && ((husart->hdmarx->Mode & DMA_LINKEDLIST) != DMA_LINKEDLIST))
      {
        status = HAL_DMA_Abort(husart->hdmarx);
      }

      /* No need to check on error code */
      UNUSED(status);

      /* Set error code to DMA */
      husart->ErrorCode = HAL_USART_ERROR_DMA;

      /* Process Unlocked */
      __HAL_UNLOCK(husart);

      /* Restore husart->State to ready */
      husart->State = HAL_USART_STATE_READY;

      return HAL_ERROR;
    }
  }
  else
  {
    return HAL_BUSY;
  }
}

HAL_StatusTypeDef HAL_USART_TransmitReceive_DMA(USART_HandleTypeDef *husart, const uint8_t *pTxData, uint8_t *pRxData,
                                                uint16_t Size)
{
  HAL_StatusTypeDef status;
  const uint32_t *tmp;
  uint16_t nbByte = Size;

  if (husart->State == HAL_USART_STATE_READY)
  {
    if ((pTxData == NULL) || (pRxData == NULL) || (Size == 0U))
    {
      return HAL_ERROR;
    }

    /* Process Locked */
    __HAL_LOCK(husart);

    husart->pRxBuffPtr = pRxData;
    husart->RxXferSize = Size;
    husart->pTxBuffPtr = pTxData;
    husart->TxXferSize = Size;

    husart->ErrorCode = HAL_USART_ERROR_NONE;
    husart->State = HAL_USART_STATE_BUSY_TX_RX;

    if ((husart->hdmarx != NULL) && (husart->hdmatx != NULL))
    {
      /* Set the USART DMA Rx transfer complete callback */
      husart->hdmarx->XferCpltCallback = USART_DMAReceiveCplt;

      /* Set the USART DMA Half transfer complete callback */
      husart->hdmarx->XferHalfCpltCallback = USART_DMARxHalfCplt;

      /* Set the USART DMA Tx transfer complete callback */
      husart->hdmatx->XferCpltCallback = USART_DMATransmitCplt;

      /* Set the USART DMA Half transfer complete callback */
      husart->hdmatx->XferHalfCpltCallback = USART_DMATxHalfCplt;

      /* Set the USART DMA Tx transfer error callback */
      husart->hdmatx->XferErrorCallback = USART_DMAError;

      /* Set the USART DMA Rx transfer error callback */
      husart->hdmarx->XferErrorCallback = USART_DMAError;

      /* In case of 9bits/No Parity transfer, pTxData buffer provided as input parameter
         should be aligned on a u16 frontier, so nbByte should be equal to Size multiplied by 2 */
      if ((husart->Init.WordLength == USART_WORDLENGTH_9B) && (husart->Init.Parity == USART_PARITY_NONE))
      {
        nbByte = Size * 2U;
      }

      /* Check linked list mode */
      tmp = (uint32_t *)&pRxData;
      if ((husart->hdmarx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
      {
        if ((husart->hdmarx->LinkedListQueue != NULL) && (husart->hdmarx->LinkedListQueue->Head != NULL))
        {
          /* Set DMA data size */
          husart->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = nbByte;

          /* Set DMA source address */
          husart->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] =
            (uint32_t)&husart->Instance->RDR;

          /* Set DMA destination address */
          husart->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = *(const uint32_t *)tmp;

          /* Enable the USART receive DMA channel */
          status = HAL_DMAEx_List_Start_IT(husart->hdmarx);
        }
        else
        {
          /* Update status */
          status = HAL_ERROR;
        }
      }
      else
      {
        /* Enable the USART receive DMA channel */
        status = HAL_DMA_Start_IT(husart->hdmarx, (uint32_t)&husart->Instance->RDR, *(const uint32_t *)tmp, nbByte);
      }

      /* Enable the USART transmit DMA channel */
      if (status == HAL_OK)
      {
        tmp = (const uint32_t *)&pTxData;

        /* Check linked list mode */
        if ((husart->hdmatx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
        {
          if ((husart->hdmatx->LinkedListQueue != NULL) && (husart->hdmatx->LinkedListQueue->Head != NULL))
          {
            /* Set DMA data size */
            husart->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = nbByte;

            /* Set DMA source address */
            husart->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = *(const uint32_t *)tmp;

            /* Set DMA destination address */
            husart->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] =
              (uint32_t)&husart->Instance->TDR;

            /* Enable the USART transmit DMA channel */
            status = HAL_DMAEx_List_Start_IT(husart->hdmatx);
          }
          else
          {
            /* Update status */
            status = HAL_ERROR;
          }
        }
        else
        {
          status = HAL_DMA_Start_IT(husart->hdmatx, *(const uint32_t *)tmp, (uint32_t)&husart->Instance->TDR, nbByte);
        }
      }
    }
    else
    {
      status = HAL_ERROR;
    }

    if (status == HAL_OK)
    {
      /* Process Unlocked */
      __HAL_UNLOCK(husart);

      if (husart->Init.Parity != USART_PARITY_NONE)
      {
        /* Enable the USART Parity Error Interrupt */
        SET_BIT(husart->Instance->CR1, USART_CR1_PEIE);
      }

      /* Enable the USART Error Interrupt: (Frame error, noise error, overrun error) */
      SET_BIT(husart->Instance->CR3, USART_CR3_EIE);

      /* Clear the TC flag in the ICR register */
      __HAL_USART_CLEAR_FLAG(husart, USART_CLEAR_TCF);

      /* Enable the DMA transfer for the receiver request by setting the DMAR bit
         in the USART CR3 register */
      SET_BIT(husart->Instance->CR3, USART_CR3_DMAR);

      /* Enable the DMA transfer for transmit request by setting the DMAT bit
         in the USART CR3 register */
      SET_BIT(husart->Instance->CR3, USART_CR3_DMAT);

      return HAL_OK;
    }
    else
    {
      if ((husart->hdmarx != NULL) && ((husart->hdmarx->Mode & DMA_LINKEDLIST) != DMA_LINKEDLIST))
      {
        status = HAL_DMA_Abort(husart->hdmarx);
      }

      /* No need to check on error code */
      UNUSED(status);

      /* Set error code to DMA */
      husart->ErrorCode = HAL_USART_ERROR_DMA;

      /* Process Unlocked */
      __HAL_UNLOCK(husart);

      /* Restore husart->State to ready */
      husart->State = HAL_USART_STATE_READY;

      return HAL_ERROR;
    }
  }
  else
  {
    return HAL_BUSY;
  }
}

HAL_StatusTypeDef HAL_USART_DMAPause(USART_HandleTypeDef *husart)
{
  const HAL_USART_StateTypeDef state = husart->State;

  /* Process Locked */
  __HAL_LOCK(husart);

  if ((HAL_IS_BIT_SET(husart->Instance->CR3, USART_CR3_DMAT)) &&
      (state == HAL_USART_STATE_BUSY_TX))
  {
    /* Suspend the USART DMA Tx channel : use blocking DMA Suspend API (no callback) */
    if (husart->hdmatx != NULL)
    {
      /* Set the USART DMA Suspend callback to Null.
         No call back execution at end of DMA Suspend procedure */
      husart->hdmatx->XferSuspendCallback = NULL;

      if (HAL_DMAEx_Suspend(husart->hdmatx) != HAL_OK)
      {
        if (HAL_DMA_GetError(husart->hdmatx) == HAL_DMA_ERROR_TIMEOUT)
        {
          /* Set error code to DMA */
          husart->ErrorCode = HAL_USART_ERROR_DMA;

          return HAL_TIMEOUT;
        }
      }
    }
  }
  else if ((state == HAL_USART_STATE_BUSY_RX) ||
           (state == HAL_USART_STATE_BUSY_TX_RX))
  {
    /* Disable PE and ERR (Frame error, noise error, overrun error) interrupts */
    CLEAR_BIT(husart->Instance->CR1, USART_CR1_PEIE);
    CLEAR_BIT(husart->Instance->CR3, USART_CR3_EIE);

    /* Set the USART DMA Suspend callback to Null.
    No call back execution at end of DMA Suspend procedure */
    husart->hdmarx->XferSuspendCallback = NULL;

    if (HAL_DMAEx_Suspend(husart->hdmarx) != HAL_OK)
    {
      if (HAL_DMA_GetError(husart->hdmarx) == HAL_DMA_ERROR_TIMEOUT)
      {
        /* Set error code to DMA */
        husart->ErrorCode = HAL_USART_ERROR_DMA;

        return HAL_TIMEOUT;
      }
    }

    if (state == HAL_USART_STATE_BUSY_TX_RX)
    {
      /* Set the USART DMA Suspend callback to Null.
      No call back execution at end of DMA Suspend procedure */
      husart->hdmatx->XferSuspendCallback = NULL;

      if (HAL_DMAEx_Suspend(husart->hdmatx) != HAL_OK)
      {
        if (HAL_DMA_GetError(husart->hdmatx) == HAL_DMA_ERROR_TIMEOUT)
        {
          /* Set error code to DMA */
          husart->ErrorCode = HAL_USART_ERROR_DMA;

          return HAL_TIMEOUT;
        }
      }
    }
  }
  else
  {
    /* Nothing to do */
  }

  /* Process Unlocked */
  __HAL_UNLOCK(husart);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_USART_DMAResume(USART_HandleTypeDef *husart)
{
  const HAL_USART_StateTypeDef state = husart->State;

  /* Process Locked */
  __HAL_LOCK(husart);

  if (state == HAL_USART_STATE_BUSY_TX)
  {
    /* Resume the USART DMA Tx channel */
    if (husart->hdmatx != NULL)
    {
      if (HAL_DMAEx_Resume(husart->hdmatx) != HAL_OK)
      {
        /* Set error code to DMA */
        husart->ErrorCode = HAL_USART_ERROR_DMA;

        return HAL_ERROR;
      }
    }
  }
  else if ((state == HAL_USART_STATE_BUSY_RX) ||
           (state == HAL_USART_STATE_BUSY_TX_RX))
  {
    /* Clear the Overrun flag before resuming the Rx transfer*/
    __HAL_USART_CLEAR_FLAG(husart, USART_CLEAR_OREF);

    /* Re-enable PE and ERR (Frame error, noise error, overrun error) interrupts */
    if (husart->Init.Parity != USART_PARITY_NONE)
    {
      SET_BIT(husart->Instance->CR1, USART_CR1_PEIE);
    }
    SET_BIT(husart->Instance->CR3, USART_CR3_EIE);

    /* Resume the USART DMA Rx channel */
    if (husart->hdmarx != NULL)
    {
      if (HAL_DMAEx_Resume(husart->hdmarx) != HAL_OK)
      {
        /* Set error code to DMA */
        husart->ErrorCode = HAL_USART_ERROR_DMA;

        return HAL_ERROR;
      }
    }

    if (state == HAL_USART_STATE_BUSY_TX_RX)
    {
      /* Resume the USART DMA Tx channel */
      if (husart->hdmatx != NULL)
      {
        if (HAL_DMAEx_Resume(husart->hdmatx) != HAL_OK)
        {
          /* Set error code to DMA */
          husart->ErrorCode = HAL_USART_ERROR_DMA;

          return HAL_ERROR;
        }
      }
    }
  }
  else
  {
    /* Nothing to do */
  }

  /* Process Unlocked */
  __HAL_UNLOCK(husart);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_USART_DMAStop(USART_HandleTypeDef *husart)
{
  /* The Lock is not implemented on this API to allow the user application
     to call the HAL USART API under callbacks HAL_USART_TxCpltCallback() / HAL_USART_RxCpltCallback() /
     HAL_USART_TxHalfCpltCallback / HAL_USART_RxHalfCpltCallback:
     indeed, when HAL_DMA_Abort() API is called, the DMA TX/RX Transfer or Half Transfer complete
     interrupt is generated if the DMA transfer interruption occurs at the middle or at the end of
     the stream and the corresponding call back is executed. */

  /* Disable the USART Tx/Rx DMA requests */
  CLEAR_BIT(husart->Instance->CR3, USART_CR3_DMAT);
  CLEAR_BIT(husart->Instance->CR3, USART_CR3_DMAR);

  /* Abort the USART DMA tx channel */
  if (husart->hdmatx != NULL)
  {
    if (HAL_DMA_Abort(husart->hdmatx) != HAL_OK)
    {
      if (HAL_DMA_GetError(husart->hdmatx) == HAL_DMA_ERROR_TIMEOUT)
      {
        /* Set error code to DMA */
        husart->ErrorCode = HAL_USART_ERROR_DMA;

        return HAL_TIMEOUT;
      }
    }
  }
  /* Abort the USART DMA rx channel */
  if (husart->hdmarx != NULL)
  {
    if (HAL_DMA_Abort(husart->hdmarx) != HAL_OK)
    {
      if (HAL_DMA_GetError(husart->hdmarx) == HAL_DMA_ERROR_TIMEOUT)
      {
        /* Set error code to DMA */
        husart->ErrorCode = HAL_USART_ERROR_DMA;

        return HAL_TIMEOUT;
      }
    }
  }

  USART_EndTransfer(husart);
  husart->State = HAL_USART_STATE_READY;

  return HAL_OK;
}

HAL_StatusTypeDef HAL_USART_Abort(USART_HandleTypeDef *husart)
{
  /* Disable TXEIE, TCIE, RXNE, RXFT, TXFT, PE and ERR (Frame error, noise error, overrun error) interrupts */
  CLEAR_BIT(husart->Instance->CR1, (USART_CR1_RXNEIE_RXFNEIE | USART_CR1_PEIE | USART_CR1_TXEIE_TXFNFIE |
                                    USART_CR1_TCIE));
  CLEAR_BIT(husart->Instance->CR3, (USART_CR3_EIE | USART_CR3_RXFTIE | USART_CR3_TXFTIE));

#if defined(HAL_DMA_MODULE_ENABLED)
  /* Abort the USART DMA Tx channel if enabled */
  if (HAL_IS_BIT_SET(husart->Instance->CR3, USART_CR3_DMAT))
  {
    /* Disable the USART DMA Tx request if enabled */
    CLEAR_BIT(husart->Instance->CR3, USART_CR3_DMAT);

    /* Abort the USART DMA Tx channel : use blocking DMA Abort API (no callback) */
    if (husart->hdmatx != NULL)
    {
      /* Set the USART DMA Abort callback to Null.
         No call back execution at end of DMA abort procedure */
      husart->hdmatx->XferAbortCallback = NULL;

      if (HAL_DMA_Abort(husart->hdmatx) != HAL_OK)
      {
        if (HAL_DMA_GetError(husart->hdmatx) == HAL_DMA_ERROR_TIMEOUT)
        {
          /* Set error code to DMA */
          husart->ErrorCode = HAL_USART_ERROR_DMA;

          return HAL_TIMEOUT;
        }
      }
    }
  }

  /* Abort the USART DMA Rx channel if enabled */
  if (HAL_IS_BIT_SET(husart->Instance->CR3, USART_CR3_DMAR))
  {
    /* Disable the USART DMA Rx request if enabled */
    CLEAR_BIT(husart->Instance->CR3, USART_CR3_DMAR);

    /* Abort the USART DMA Rx channel : use blocking DMA Abort API (no callback) */
    if (husart->hdmarx != NULL)
    {
      /* Set the USART DMA Abort callback to Null.
         No call back execution at end of DMA abort procedure */
      husart->hdmarx->XferAbortCallback = NULL;

      if (HAL_DMA_Abort(husart->hdmarx) != HAL_OK)
      {
        if (HAL_DMA_GetError(husart->hdmarx) == HAL_DMA_ERROR_TIMEOUT)
        {
          /* Set error code to DMA */
          husart->ErrorCode = HAL_USART_ERROR_DMA;

          return HAL_TIMEOUT;
        }
      }
    }
  }
#endif /* HAL_DMA_MODULE_ENABLED */

  /* Reset Tx and Rx transfer counters */
  husart->TxXferCount = 0U;
  husart->RxXferCount = 0U;

  /* Clear the Error flags in the ICR register */
  __HAL_USART_CLEAR_FLAG(husart, USART_CLEAR_OREF | USART_CLEAR_NEF | USART_CLEAR_PEF | USART_CLEAR_FEF);

  /* Flush the whole TX FIFO (if needed) */
  if (husart->FifoMode == USART_FIFOMODE_ENABLE)
  {
    __HAL_USART_SEND_REQ(husart, USART_TXDATA_FLUSH_REQUEST);
  }

  /* Discard the received data */
  __HAL_USART_SEND_REQ(husart, USART_RXDATA_FLUSH_REQUEST);

  /* Restore husart->State to Ready */
  husart->State  = HAL_USART_STATE_READY;

  /* Reset Handle ErrorCode to No Error */
  husart->ErrorCode = HAL_USART_ERROR_NONE;

  return HAL_OK;
}

HAL_StatusTypeDef HAL_USART_Abort_IT(USART_HandleTypeDef *husart)
{
  uint32_t abortcplt = 1U;

  /* Disable TXEIE, TCIE, RXNE, RXFT, TXFT, PE and ERR (Frame error, noise error, overrun error) interrupts */
  CLEAR_BIT(husart->Instance->CR1, (USART_CR1_RXNEIE_RXFNEIE | USART_CR1_PEIE | USART_CR1_TXEIE_TXFNFIE |
                                    USART_CR1_TCIE));
  CLEAR_BIT(husart->Instance->CR3, (USART_CR3_EIE | USART_CR3_RXFTIE | USART_CR3_TXFTIE));

#if defined(HAL_DMA_MODULE_ENABLED)
  /* If DMA Tx and/or DMA Rx Handles are associated to USART Handle, DMA Abort complete callbacks should be initialised
     before any call to DMA Abort functions */
  /* DMA Tx Handle is valid */
  if (husart->hdmatx != NULL)
  {
    /* Set DMA Abort Complete callback if USART DMA Tx request if enabled.
       Otherwise, set it to NULL */
    if (HAL_IS_BIT_SET(husart->Instance->CR3, USART_CR3_DMAT))
    {
      husart->hdmatx->XferAbortCallback = USART_DMATxAbortCallback;
    }
    else
    {
      husart->hdmatx->XferAbortCallback = NULL;
    }
  }
  /* DMA Rx Handle is valid */
  if (husart->hdmarx != NULL)
  {
    /* Set DMA Abort Complete callback if USART DMA Rx request if enabled.
       Otherwise, set it to NULL */
    if (HAL_IS_BIT_SET(husart->Instance->CR3, USART_CR3_DMAR))
    {
      husart->hdmarx->XferAbortCallback = USART_DMARxAbortCallback;
    }
    else
    {
      husart->hdmarx->XferAbortCallback = NULL;
    }
  }

  /* Abort the USART DMA Tx channel if enabled */
  if (HAL_IS_BIT_SET(husart->Instance->CR3, USART_CR3_DMAT))
  {
    /* Disable DMA Tx at USART level */
    CLEAR_BIT(husart->Instance->CR3, USART_CR3_DMAT);

    /* Abort the USART DMA Tx channel : use non blocking DMA Abort API (callback) */
    if (husart->hdmatx != NULL)
    {
      /* USART Tx DMA Abort callback has already been initialised :
         will lead to call HAL_USART_AbortCpltCallback() at end of DMA abort procedure */

      /* Abort DMA TX */
      if (HAL_DMA_Abort_IT(husart->hdmatx) != HAL_OK)
      {
        husart->hdmatx->XferAbortCallback = NULL;
      }
      else
      {
        abortcplt = 0U;
      }
    }
  }

  /* Abort the USART DMA Rx channel if enabled */
  if (HAL_IS_BIT_SET(husart->Instance->CR3, USART_CR3_DMAR))
  {
    /* Disable the USART DMA Rx request if enabled */
    CLEAR_BIT(husart->Instance->CR3, USART_CR3_DMAR);

    /* Abort the USART DMA Rx channel : use non blocking DMA Abort API (callback) */
    if (husart->hdmarx != NULL)
    {
      /* USART Rx DMA Abort callback has already been initialised :
         will lead to call HAL_USART_AbortCpltCallback() at end of DMA abort procedure */

      /* Abort DMA RX */
      if (HAL_DMA_Abort_IT(husart->hdmarx) != HAL_OK)
      {
        husart->hdmarx->XferAbortCallback = NULL;
        abortcplt = 1U;
      }
      else
      {
        abortcplt = 0U;
      }
    }
  }
#endif /* HAL_DMA_MODULE_ENABLED */

  /* if no DMA abort complete callback execution is required => call user Abort Complete callback */
  if (abortcplt == 1U)
  {
    /* Reset Tx and Rx transfer counters */
    husart->TxXferCount = 0U;
    husart->RxXferCount = 0U;

    /* Reset errorCode */
    husart->ErrorCode = HAL_USART_ERROR_NONE;

    /* Clear the Error flags in the ICR register */
    __HAL_USART_CLEAR_FLAG(husart, USART_CLEAR_OREF | USART_CLEAR_NEF | USART_CLEAR_PEF | USART_CLEAR_FEF);

    /* Flush the whole TX FIFO (if needed) */
    if (husart->FifoMode == USART_FIFOMODE_ENABLE)
    {
      __HAL_USART_SEND_REQ(husart, USART_TXDATA_FLUSH_REQUEST);
    }

    /* Discard the received data */
    __HAL_USART_SEND_REQ(husart, USART_RXDATA_FLUSH_REQUEST);

    /* Restore husart->State to Ready */
    husart->State  = HAL_USART_STATE_READY;

    /* As no DMA to be aborted, call directly user Abort complete callback */
#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
    /* Call registered Abort Complete Callback */
    husart->AbortCpltCallback(husart);
#else
    /* Call legacy weak Abort Complete Callback */
    HAL_USART_AbortCpltCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
  }

  return HAL_OK;
}

void HAL_USART_IRQHandler(USART_HandleTypeDef *husart)
{
  uint32_t isrflags   = READ_REG(husart->Instance->ISR);
  uint32_t cr1its     = READ_REG(husart->Instance->CR1);
  uint32_t cr3its     = READ_REG(husart->Instance->CR3);

  uint32_t errorflags;
  uint32_t errorcode;

  /* If no error occurs */
  errorflags = (isrflags & (uint32_t)(USART_ISR_PE | USART_ISR_FE | USART_ISR_ORE | USART_ISR_NE | USART_ISR_RTOF |
                                      USART_ISR_UDR));
  if (errorflags == 0U)
  {
    /* USART in mode Receiver ---------------------------------------------------*/
    if (((isrflags & USART_ISR_RXNE_RXFNE) != 0U)
        && (((cr1its & USART_CR1_RXNEIE_RXFNEIE) != 0U)
            || ((cr3its & USART_CR3_RXFTIE) != 0U)))
    {
      if (husart->RxISR != NULL)
      {
        husart->RxISR(husart);
      }
      return;
    }
  }

  /* If some errors occur */
  if ((errorflags != 0U)
      && (((cr3its & (USART_CR3_RXFTIE | USART_CR3_EIE)) != 0U)
          || ((cr1its & (USART_CR1_RXNEIE_RXFNEIE | USART_CR1_PEIE)) != 0U)))
  {
    /* USART parity error interrupt occurred -------------------------------------*/
    if (((isrflags & USART_ISR_PE) != 0U) && ((cr1its & USART_CR1_PEIE) != 0U))
    {
      __HAL_USART_CLEAR_IT(husart, USART_CLEAR_PEF);

      husart->ErrorCode |= HAL_USART_ERROR_PE;
    }

    /* USART frame error interrupt occurred --------------------------------------*/
    if (((isrflags & USART_ISR_FE) != 0U) && ((cr3its & USART_CR3_EIE) != 0U))
    {
      __HAL_USART_CLEAR_IT(husart, USART_CLEAR_FEF);

      husart->ErrorCode |= HAL_USART_ERROR_FE;
    }

    /* USART noise error interrupt occurred --------------------------------------*/
    if (((isrflags & USART_ISR_NE) != 0U) && ((cr3its & USART_CR3_EIE) != 0U))
    {
      __HAL_USART_CLEAR_IT(husart, USART_CLEAR_NEF);

      husart->ErrorCode |= HAL_USART_ERROR_NE;
    }

    /* USART Over-Run interrupt occurred -----------------------------------------*/
    if (((isrflags & USART_ISR_ORE) != 0U)
        && (((cr1its & USART_CR1_RXNEIE_RXFNEIE) != 0U) ||
            ((cr3its & (USART_CR3_RXFTIE | USART_CR3_EIE)) != 0U)))
    {
      __HAL_USART_CLEAR_IT(husart, USART_CLEAR_OREF);

      husart->ErrorCode |= HAL_USART_ERROR_ORE;
    }

    /* USART Receiver Timeout interrupt occurred ---------------------------------*/
    if (((isrflags & USART_ISR_RTOF) != 0U) && ((cr1its & USART_CR1_RTOIE) != 0U))
    {
      __HAL_USART_CLEAR_IT(husart, USART_CLEAR_RTOF);

      husart->ErrorCode |= HAL_USART_ERROR_RTO;
    }

    /* USART SPI slave underrun error interrupt occurred -------------------------*/
    if (((isrflags & USART_ISR_UDR) != 0U) && ((cr3its & USART_CR3_EIE) != 0U))
    {
      /* Ignore SPI slave underrun errors when reception is going on */
      if (husart->State == HAL_USART_STATE_BUSY_RX)
      {
        __HAL_USART_CLEAR_UDRFLAG(husart);
        return;
      }
      else
      {
        __HAL_USART_CLEAR_UDRFLAG(husart);
        husart->ErrorCode |= HAL_USART_ERROR_UDR;
      }
    }

    /* Call USART Error Call back function if need be --------------------------*/
    if (husart->ErrorCode != HAL_USART_ERROR_NONE)
    {
      /* USART in mode Receiver ---------------------------------------------------*/
      if (((isrflags & USART_ISR_RXNE_RXFNE) != 0U)
          && (((cr1its & USART_CR1_RXNEIE_RXFNEIE) != 0U)
              || ((cr3its & USART_CR3_RXFTIE) != 0U)))
      {
        if (husart->RxISR != NULL)
        {
          husart->RxISR(husart);
        }
      }

      /* If Overrun error occurs, or if any error occurs in DMA mode reception,
         consider error as blocking */
      errorcode = husart->ErrorCode & HAL_USART_ERROR_ORE;
      if ((HAL_IS_BIT_SET(husart->Instance->CR3, USART_CR3_DMAR)) ||
          (errorcode != 0U))
      {
        /* Blocking error : transfer is aborted
           Set the USART state ready to be able to start again the process,
           Disable Interrupts, and disable DMA requests, if ongoing */
        USART_EndTransfer(husart);

#if defined(HAL_DMA_MODULE_ENABLED)
        /* Abort the USART DMA Rx channel if enabled */
        if (HAL_IS_BIT_SET(husart->Instance->CR3, USART_CR3_DMAR))
        {
          /* Disable the USART DMA Rx request if enabled */
          CLEAR_BIT(husart->Instance->CR3, USART_CR3_DMAR | USART_CR3_DMAR);

          /* Abort the USART DMA Tx channel */
          if (husart->hdmatx != NULL)
          {
            /* Set the USART Tx DMA Abort callback to NULL : no callback
               executed at end of DMA abort procedure */
            husart->hdmatx->XferAbortCallback = NULL;

            /* Abort DMA TX */
            (void)HAL_DMA_Abort_IT(husart->hdmatx);
          }

          /* Abort the USART DMA Rx channel */
          if (husart->hdmarx != NULL)
          {
            /* Set the USART Rx DMA Abort callback :
               will lead to call HAL_USART_ErrorCallback() at end of DMA abort procedure */
            husart->hdmarx->XferAbortCallback = USART_DMAAbortOnError;

            /* Abort DMA RX */
            if (HAL_DMA_Abort_IT(husart->hdmarx) != HAL_OK)
            {
              /* Call Directly husart->hdmarx->XferAbortCallback function in case of error */
              husart->hdmarx->XferAbortCallback(husart->hdmarx);
            }
          }
          else
          {
            /* Call user error callback */
#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
            /* Call registered Error Callback */
            husart->ErrorCallback(husart);
#else
            /* Call legacy weak Error Callback */
            HAL_USART_ErrorCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
          }
        }
        else
#endif /* HAL_DMA_MODULE_ENABLED */
        {
          /* Call user error callback */
#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
          /* Call registered Error Callback */
          husart->ErrorCallback(husart);
#else
          /* Call legacy weak Error Callback */
          HAL_USART_ErrorCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
        }
      }
      else
      {
        /* Non Blocking error : transfer could go on.
           Error is notified to user through user error callback */
#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
        /* Call registered Error Callback */
        husart->ErrorCallback(husart);
#else
        /* Call legacy weak Error Callback */
        HAL_USART_ErrorCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
        husart->ErrorCode = HAL_USART_ERROR_NONE;
      }
    }
    return;

  } /* End if some error occurs */


  /* USART in mode Transmitter ------------------------------------------------*/
  if (((isrflags & USART_ISR_TXE_TXFNF) != 0U)
      && (((cr1its & USART_CR1_TXEIE_TXFNFIE) != 0U)
          || ((cr3its & USART_CR3_TXFTIE) != 0U)))
  {
    if (husart->TxISR != NULL)
    {
      husart->TxISR(husart);
    }
    return;
  }

  /* USART in mode Transmitter (transmission end) -----------------------------*/
  if (((isrflags & USART_ISR_TC) != 0U) && ((cr1its & USART_CR1_TCIE) != 0U))
  {
    USART_EndTransmit_IT(husart);
    return;
  }

  /* USART TX Fifo Empty occurred ----------------------------------------------*/
  if (((isrflags & USART_ISR_TXFE) != 0U) && ((cr1its & USART_CR1_TXFEIE) != 0U))
  {
#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
    /* Call registered Tx Fifo Empty Callback */
    husart->TxFifoEmptyCallback(husart);
#else
    /* Call legacy weak Tx Fifo Empty Callback */
    HAL_USARTEx_TxFifoEmptyCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
    return;
  }

  /* USART RX Fifo Full occurred ----------------------------------------------*/
  if (((isrflags & USART_ISR_RXFF) != 0U) && ((cr1its & USART_CR1_RXFFIE) != 0U))
  {
#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
    /* Call registered Rx Fifo Full Callback */
    husart->RxFifoFullCallback(husart);
#else
    /* Call legacy weak Rx Fifo Full Callback */
    HAL_USARTEx_RxFifoFullCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
    return;
  }
}

HAL_USART_StateTypeDef HAL_USART_GetState(const USART_HandleTypeDef *husart)
{
  return husart->State;
}

uint32_t HAL_USART_GetError(const USART_HandleTypeDef *husart)
{
  return husart->ErrorCode;
}

#if F_MODE
void USART_InitCallbacksToDefault(USART_HandleTypeDef *husart)
{
  /* Init the USART Callback settings */
  husart->TxHalfCpltCallback        = HAL_USART_TxHalfCpltCallback;        /* Legacy weak TxHalfCpltCallback        */
  husart->TxCpltCallback            = HAL_USART_TxCpltCallback;            /* Legacy weak TxCpltCallback            */
  husart->RxHalfCpltCallback        = HAL_USART_RxHalfCpltCallback;        /* Legacy weak RxHalfCpltCallback        */
  husart->RxCpltCallback            = HAL_USART_RxCpltCallback;            /* Legacy weak RxCpltCallback            */
  husart->TxRxCpltCallback          = HAL_USART_TxRxCpltCallback;          /* Legacy weak TxRxCpltCallback          */
  husart->ErrorCallback             = HAL_USART_ErrorCallback;             /* Legacy weak ErrorCallback             */
  husart->AbortCpltCallback         = HAL_USART_AbortCpltCallback;         /* Legacy weak AbortCpltCallback         */
  husart->RxFifoFullCallback        = HAL_USARTEx_RxFifoFullCallback;      /* Legacy weak RxFifoFullCallback        */
  husart->TxFifoEmptyCallback       = HAL_USARTEx_TxFifoEmptyCallback;     /* Legacy weak TxFifoEmptyCallback       */
}
#endif

static void USART_EndTransfer(USART_HandleTypeDef *husart)
{
  /* Disable TXEIE, TCIE, RXNE, RXFT, TXFT, PE and ERR (Frame error, noise error, overrun error) interrupts */
  CLEAR_BIT(husart->Instance->CR1, (USART_CR1_RXNEIE_RXFNEIE | USART_CR1_PEIE | USART_CR1_TXEIE_TXFNFIE |
                                    USART_CR1_TCIE));
  CLEAR_BIT(husart->Instance->CR3, (USART_CR3_EIE | USART_CR3_RXFTIE | USART_CR3_TXFTIE));

  /* At end of process, restore husart->State to Ready */
  husart->State = HAL_USART_STATE_READY;
}

static void USART_DMATransmitCplt(DMA_HandleTypeDef *hdma)
{
  USART_HandleTypeDef *husart = (USART_HandleTypeDef *)(hdma->Parent);

  /* Check if DMA in circular mode */
  if (hdma->Mode != DMA_LINKEDLIST_CIRCULAR)
  {
    husart->TxXferCount = 0U;

    if (husart->State == HAL_USART_STATE_BUSY_TX)
    {
      /* Disable the DMA transfer for transmit request by resetting the DMAT bit
         in the USART CR3 register */
      CLEAR_BIT(husart->Instance->CR3, USART_CR3_DMAT);

      /* Enable the USART Transmit Complete Interrupt */
      __HAL_USART_ENABLE_IT(husart, USART_IT_TC);
    }
  }
  /* DMA Circular mode */
  else
  {
    if (husart->State == HAL_USART_STATE_BUSY_TX)
    {
#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
      /* Call registered Tx Complete Callback */
      husart->TxCpltCallback(husart);
#else
      /* Call legacy weak Tx Complete Callback */
      HAL_USART_TxCpltCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
    }
  }
}

static void USART_DMATxHalfCplt(DMA_HandleTypeDef *hdma)
{
  USART_HandleTypeDef *husart = (USART_HandleTypeDef *)(hdma->Parent);

#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
  /* Call registered Tx Half Complete Callback */
  husart->TxHalfCpltCallback(husart);
#else
  /* Call legacy weak Tx Half Complete Callback */
  HAL_USART_TxHalfCpltCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
}

static void USART_DMAReceiveCplt(DMA_HandleTypeDef *hdma)
{
  USART_HandleTypeDef *husart = (USART_HandleTypeDef *)(hdma->Parent);

  /* Check if DMA in circular mode*/
  if (hdma->Mode != DMA_LINKEDLIST_CIRCULAR)
  {
    husart->RxXferCount = 0U;

    /* Disable PE and ERR (Frame error, noise error, overrun error) interrupts */
    CLEAR_BIT(husart->Instance->CR1, USART_CR1_PEIE);
    CLEAR_BIT(husart->Instance->CR3, USART_CR3_EIE);

    /* Disable the DMA RX transfer for the receiver request by resetting the DMAR bit
       in USART CR3 register */
    CLEAR_BIT(husart->Instance->CR3, USART_CR3_DMAR);
    /* similarly, disable the DMA TX transfer that was started to provide the
       clock to the slave device */
    CLEAR_BIT(husart->Instance->CR3, USART_CR3_DMAT);

    if (husart->State == HAL_USART_STATE_BUSY_RX)
    {
#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
      /* Call registered Rx Complete Callback */
      husart->RxCpltCallback(husart);
#else
      /* Call legacy weak Rx Complete Callback */
      HAL_USART_RxCpltCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
    }
    /* The USART state is HAL_USART_STATE_BUSY_TX_RX */
    else
    {
#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
      /* Call registered Tx Rx Complete Callback */
      husart->TxRxCpltCallback(husart);
#else
      /* Call legacy weak Tx Rx Complete Callback */
      HAL_USART_TxRxCpltCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
    }
    husart->State = HAL_USART_STATE_READY;
  }
  /* DMA circular mode */
  else
  {
    if (husart->State == HAL_USART_STATE_BUSY_RX)
    {
#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
      /* Call registered Rx Complete Callback */
      husart->RxCpltCallback(husart);
#else
      /* Call legacy weak Rx Complete Callback */
      HAL_USART_RxCpltCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
    }
    /* The USART state is HAL_USART_STATE_BUSY_TX_RX */
    else
    {
#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
      /* Call registered Tx Rx Complete Callback */
      husart->TxRxCpltCallback(husart);
#else
      /* Call legacy weak Tx Rx Complete Callback */
      HAL_USART_TxRxCpltCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
    }
  }
}

static void USART_DMARxHalfCplt(DMA_HandleTypeDef *hdma)
{
  USART_HandleTypeDef *husart = (USART_HandleTypeDef *)(hdma->Parent);

#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
  /* Call registered Rx Half Complete Callback */
  husart->RxHalfCpltCallback(husart);
#else
  /* Call legacy weak Rx Half Complete Callback */
  HAL_USART_RxHalfCpltCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
}

static void USART_DMAError(DMA_HandleTypeDef *hdma)
{
  USART_HandleTypeDef *husart = (USART_HandleTypeDef *)(hdma->Parent);

  husart->RxXferCount = 0U;
  husart->TxXferCount = 0U;
  USART_EndTransfer(husart);

  husart->ErrorCode |= HAL_USART_ERROR_DMA;
  husart->State = HAL_USART_STATE_READY;

#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
  /* Call registered Error Callback */
  husart->ErrorCallback(husart);
#else
  /* Call legacy weak Error Callback */
  HAL_USART_ErrorCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
}

static void USART_DMAAbortOnError(DMA_HandleTypeDef *hdma)
{
  USART_HandleTypeDef *husart = (USART_HandleTypeDef *)(hdma->Parent);
  husart->RxXferCount = 0U;
  husart->TxXferCount = 0U;

#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
  /* Call registered Error Callback */
  husart->ErrorCallback(husart);
#else
  /* Call legacy weak Error Callback */
  HAL_USART_ErrorCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
}

static void USART_DMATxAbortCallback(DMA_HandleTypeDef *hdma)
{
  USART_HandleTypeDef *husart = (USART_HandleTypeDef *)(hdma->Parent);

  husart->hdmatx->XferAbortCallback = NULL;

  /* Check if an Abort process is still ongoing */
  if (husart->hdmarx != NULL)
  {
    if (husart->hdmarx->XferAbortCallback != NULL)
    {
      return;
    }
  }

  /* No Abort process still ongoing : All DMA channels are aborted, call user Abort Complete callback */
  husart->TxXferCount = 0U;
  husart->RxXferCount = 0U;

  /* Reset errorCode */
  husart->ErrorCode = HAL_USART_ERROR_NONE;

  /* Clear the Error flags in the ICR register */
  __HAL_USART_CLEAR_FLAG(husart, USART_CLEAR_OREF | USART_CLEAR_NEF | USART_CLEAR_PEF | USART_CLEAR_FEF);

  /* Restore husart->State to Ready */
  husart->State = HAL_USART_STATE_READY;

  /* Call user Abort complete callback */
#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
  /* Call registered Abort Complete Callback */
  husart->AbortCpltCallback(husart);
#else
  /* Call legacy weak Abort Complete Callback */
  HAL_USART_AbortCpltCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */

}

static void USART_DMARxAbortCallback(DMA_HandleTypeDef *hdma)
{
  USART_HandleTypeDef *husart = (USART_HandleTypeDef *)(hdma->Parent);

  husart->hdmarx->XferAbortCallback = NULL;

  /* Check if an Abort process is still ongoing */
  if (husart->hdmatx != NULL)
  {
    if (husart->hdmatx->XferAbortCallback != NULL)
    {
      return;
    }
  }

  /* No Abort process still ongoing : All DMA channels are aborted, call user Abort Complete callback */
  husart->TxXferCount = 0U;
  husart->RxXferCount = 0U;

  /* Reset errorCode */
  husart->ErrorCode = HAL_USART_ERROR_NONE;

  /* Clear the Error flags in the ICR register */
  __HAL_USART_CLEAR_FLAG(husart, USART_CLEAR_OREF | USART_CLEAR_NEF | USART_CLEAR_PEF | USART_CLEAR_FEF);

  /* Restore husart->State to Ready */
  husart->State  = HAL_USART_STATE_READY;

  /* Call user Abort complete callback */
#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
  /* Call registered Abort Complete Callback */
  husart->AbortCpltCallback(husart);
#else
  /* Call legacy weak Abort Complete Callback */
  HAL_USART_AbortCpltCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
}

static HAL_StatusTypeDef USART_WaitOnFlagUntilTimeout(USART_HandleTypeDef *husart, uint32_t Flag, FlagStatus Status,
                                                      uint32_t Tickstart, uint32_t Timeout)
{
  /* Wait until flag is set */
  while ((__HAL_USART_GET_FLAG(husart, Flag) ? SET : RESET) == Status)
  {
    /* Check for the Timeout */
    if (Timeout != HAL_MAX_DELAY)
    {
      if (((HAL_GetTick() - Tickstart) > Timeout) || (Timeout == 0U))
      {
        husart->State = HAL_USART_STATE_READY;

        /* Process Unlocked */
        __HAL_UNLOCK(husart);

        return HAL_TIMEOUT;
      }
    }
  }
  return HAL_OK;
}

static HAL_StatusTypeDef USART_SetConfig(USART_HandleTypeDef *husart)
{
  uint32_t tmpreg;
  USART_ClockSourceTypeDef clocksource;
  HAL_StatusTypeDef ret                = HAL_OK;
  uint16_t brrtemp;
  uint32_t usartdiv                    = 0x00000000;
  uint32_t pclk;

  /* Check the parameters */
  assert_param(IS_USART_POLARITY(husart->Init.CLKPolarity));
  assert_param(IS_USART_PHASE(husart->Init.CLKPhase));
  assert_param(IS_USART_LASTBIT(husart->Init.CLKLastBit));
  assert_param(IS_USART_BAUDRATE(husart->Init.BaudRate));
  assert_param(IS_USART_WORD_LENGTH(husart->Init.WordLength));
  assert_param(IS_USART_STOPBITS(husart->Init.StopBits));
  assert_param(IS_USART_PARITY(husart->Init.Parity));
  assert_param(IS_USART_MODE(husart->Init.Mode));
  assert_param(IS_USART_PRESCALER(husart->Init.ClockPrescaler));

  /*-------------------------- USART CR1 Configuration -----------------------*/
  /* Clear M, PCE, PS, TE and RE bits and configure
  *  the USART Word Length, Parity and Mode:
  *  set the M bits according to husart->Init.WordLength value
  *  set PCE and PS bits according to husart->Init.Parity value
  *  set TE and RE bits according to husart->Init.Mode value
  *  force OVER8 to 1 to allow to reach the maximum speed (Fclock/8) */
  tmpreg = (uint32_t)husart->Init.WordLength | husart->Init.Parity | husart->Init.Mode | USART_CR1_OVER8;
  MODIFY_REG(husart->Instance->CR1, USART_CR1_FIELDS, tmpreg);

  /*---------------------------- USART CR2 Configuration ---------------------*/
  /* Clear and configure the USART Clock, CPOL, CPHA, LBCL STOP and SLVEN bits:
   * set CPOL bit according to husart->Init.CLKPolarity value
   * set CPHA bit according to husart->Init.CLKPhase value
   * set LBCL bit according to husart->Init.CLKLastBit value (used in USART Synchronous SPI master mode only)
   * set STOP[13:12] bits according to husart->Init.StopBits value */
  tmpreg = (uint32_t)(USART_CLOCK_ENABLE);
  tmpreg |= (uint32_t)husart->Init.CLKLastBit;
  tmpreg |= ((uint32_t)husart->Init.CLKPolarity | (uint32_t)husart->Init.CLKPhase);
  tmpreg |= (uint32_t)husart->Init.StopBits;
  MODIFY_REG(husart->Instance->CR2, USART_CR2_FIELDS, tmpreg);

  /*-------------------------- USART PRESC Configuration -----------------------*/
  /* Configure
   * - USART Clock Prescaler : set PRESCALER according to husart->Init.ClockPrescaler value */
  MODIFY_REG(husart->Instance->PRESC, USART_PRESC_PRESCALER, husart->Init.ClockPrescaler);

  /*-------------------------- USART BRR Configuration -----------------------*/
  /* BRR is filled-up according to OVER8 bit setting which is forced to 1     */
  USART_GETCLOCKSOURCE(husart, clocksource);

  switch (clocksource)
  {
    case USART_CLOCKSOURCE_PCLK1:
      pclk = HAL_RCC_GetPCLK1Freq();
      usartdiv = (uint32_t)(USART_DIV_SAMPLING8(pclk, husart->Init.BaudRate, husart->Init.ClockPrescaler));
      break;
    case USART_CLOCKSOURCE_PCLK2:
      pclk = HAL_RCC_GetPCLK2Freq();
      usartdiv = (uint32_t)(USART_DIV_SAMPLING8(pclk, husart->Init.BaudRate, husart->Init.ClockPrescaler));
      break;
    case USART_CLOCKSOURCE_PLL2Q:
      pclk = HAL_RCC_GetPLL2QFreq();
      usartdiv = (uint32_t)(USART_DIV_SAMPLING8(pclk, husart->Init.BaudRate, husart->Init.ClockPrescaler));
      break;
    case USART_CLOCKSOURCE_PLL3Q:
      pclk = HAL_RCC_GetPLL3QFreq();
      usartdiv = (uint32_t)(USART_DIV_SAMPLING8(pclk, husart->Init.BaudRate, husart->Init.ClockPrescaler));
      break;
    case USART_CLOCKSOURCE_HSI:
      if (__HAL_RCC_GET_FLAG(RCC_FLAG_HSIDIV) != 0U)
      {
        usartdiv = (uint32_t)(USART_DIV_SAMPLING8((HSI_VALUE >> (__HAL_RCC_GET_HSI_DIVIDER() >> 3U)),
                                                  husart->Init.BaudRate, husart->Init.ClockPrescaler));
      }
      else
      {
        usartdiv = (uint32_t)(USART_DIV_SAMPLING8(HSI_VALUE, husart->Init.BaudRate, husart->Init.ClockPrescaler));
      }
      break;
    case USART_CLOCKSOURCE_CSI:
      usartdiv = (uint32_t)(USART_DIV_SAMPLING8(CSI_VALUE, husart->Init.BaudRate, husart->Init.ClockPrescaler));
      break;
    case USART_CLOCKSOURCE_LSE:
      usartdiv = (uint32_t)(USART_DIV_SAMPLING8(LSE_VALUE, husart->Init.BaudRate, husart->Init.ClockPrescaler));
      break;
    default:
      ret = HAL_ERROR;
      break;
  }

  /* USARTDIV must be greater than or equal to 0d16 and smaller than or equal to ffff */
  if ((usartdiv >= USART_BRR_MIN) && (usartdiv <= USART_BRR_MAX))
  {
    brrtemp = (uint16_t)(usartdiv & 0xFFF0U);
    brrtemp |= (uint16_t)((usartdiv & (uint16_t)0x000FU) >> 1U);
    husart->Instance->BRR = brrtemp;
  }
  else
  {
    ret = HAL_ERROR;
  }

  /* Initialize the number of data to process during RX/TX ISR execution */
  husart->NbTxDataToProcess = 1U;
  husart->NbRxDataToProcess = 1U;

  /* Clear ISR function pointers */
  husart->RxISR   = NULL;
  husart->TxISR   = NULL;

  return ret;
}

static HAL_StatusTypeDef USART_CheckIdleState(USART_HandleTypeDef *husart)
{
  uint32_t tickstart;

  /* Initialize the USART ErrorCode */
  husart->ErrorCode = HAL_USART_ERROR_NONE;

  /* Init tickstart for timeout management */
  tickstart = HAL_GetTick();

  /* Check if the Transmitter is enabled */
  if ((husart->Instance->CR1 & USART_CR1_TE) == USART_CR1_TE)
  {
    /* Wait until TEACK flag is set */
    if (USART_WaitOnFlagUntilTimeout(husart, USART_ISR_TEACK, RESET, tickstart, USART_TEACK_REACK_TIMEOUT) != HAL_OK)
    {
      /* Timeout occurred */
      return HAL_TIMEOUT;
    }
  }
  /* Check if the Receiver is enabled */
  if ((husart->Instance->CR1 & USART_CR1_RE) == USART_CR1_RE)
  {
    /* Wait until REACK flag is set */
    if (USART_WaitOnFlagUntilTimeout(husart, USART_ISR_REACK, RESET, tickstart, USART_TEACK_REACK_TIMEOUT) != HAL_OK)
    {
      /* Timeout occurred */
      return HAL_TIMEOUT;
    }
  }

  /* Initialize the USART state*/
  husart->State = HAL_USART_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(husart);

  return HAL_OK;
}

static void USART_TxISR_8BIT(USART_HandleTypeDef *husart)
{
  const HAL_USART_StateTypeDef state = husart->State;

  /* Check that a Tx process is ongoing */
  if ((state == HAL_USART_STATE_BUSY_TX) ||
      (state == HAL_USART_STATE_BUSY_TX_RX))
  {
    if (husart->TxXferCount == 0U)
    {
      /* Disable the USART Transmit data register empty interrupt */
      __HAL_USART_DISABLE_IT(husart, USART_IT_TXE);

      /* Enable the USART Transmit Complete Interrupt */
      __HAL_USART_ENABLE_IT(husart, USART_IT_TC);
    }
    else
    {
      husart->Instance->TDR = (uint8_t)(*husart->pTxBuffPtr & (uint8_t)0xFF);
      husart->pTxBuffPtr++;
      husart->TxXferCount--;
    }
  }
}

static void USART_TxISR_16BIT(USART_HandleTypeDef *husart)
{
  const HAL_USART_StateTypeDef state = husart->State;
  const uint16_t *tmp;

  if ((state == HAL_USART_STATE_BUSY_TX) ||
      (state == HAL_USART_STATE_BUSY_TX_RX))
  {
    if (husart->TxXferCount == 0U)
    {
      /* Disable the USART Transmit data register empty interrupt */
      __HAL_USART_DISABLE_IT(husart, USART_IT_TXE);

      /* Enable the USART Transmit Complete Interrupt */
      __HAL_USART_ENABLE_IT(husart, USART_IT_TC);
    }
    else
    {
      tmp = (const uint16_t *) husart->pTxBuffPtr;
      husart->Instance->TDR = (uint16_t)(*tmp & 0x01FFU);
      husart->pTxBuffPtr += 2U;
      husart->TxXferCount--;
    }
  }
}

static void USART_TxISR_8BIT_FIFOEN(USART_HandleTypeDef *husart)
{
  const HAL_USART_StateTypeDef state = husart->State;
  uint16_t  nb_tx_data;

  /* Check that a Tx process is ongoing */
  if ((state == HAL_USART_STATE_BUSY_TX) ||
      (state == HAL_USART_STATE_BUSY_TX_RX))
  {
    for (nb_tx_data = husart->NbTxDataToProcess ; nb_tx_data > 0U ; nb_tx_data--)
    {
      if (husart->TxXferCount == 0U)
      {
        /* Disable the TX FIFO threshold interrupt */
        __HAL_USART_DISABLE_IT(husart, USART_IT_TXFT);

        /* Enable the USART Transmit Complete Interrupt */
        __HAL_USART_ENABLE_IT(husart, USART_IT_TC);

        break; /* force exit loop */
      }
      else if (__HAL_USART_GET_FLAG(husart, USART_FLAG_TXFNF) == SET)
      {
        husart->Instance->TDR = (uint8_t)(*husart->pTxBuffPtr & (uint8_t)0xFF);
        husart->pTxBuffPtr++;
        husart->TxXferCount--;
      }
      else
      {
        /* Nothing to do */
      }
    }
  }
}

static void USART_TxISR_16BIT_FIFOEN(USART_HandleTypeDef *husart)
{
  const HAL_USART_StateTypeDef state = husart->State;
  const uint16_t *tmp;
  uint16_t  nb_tx_data;

  /* Check that a Tx process is ongoing */
  if ((state == HAL_USART_STATE_BUSY_TX) ||
      (state == HAL_USART_STATE_BUSY_TX_RX))
  {
    for (nb_tx_data = husart->NbTxDataToProcess ; nb_tx_data > 0U ; nb_tx_data--)
    {
      if (husart->TxXferCount == 0U)
      {
        /* Disable the TX FIFO threshold interrupt */
        __HAL_USART_DISABLE_IT(husart, USART_IT_TXFT);

        /* Enable the USART Transmit Complete Interrupt */
        __HAL_USART_ENABLE_IT(husart, USART_IT_TC);

        break; /* force exit loop */
      }
      else if (__HAL_USART_GET_FLAG(husart, USART_FLAG_TXFNF) == SET)
      {
        tmp = (const uint16_t *) husart->pTxBuffPtr;
        husart->Instance->TDR = (uint16_t)(*tmp & 0x01FFU);
        husart->pTxBuffPtr += 2U;
        husart->TxXferCount--;
      }
      else
      {
        /* Nothing to do */
      }
    }
  }
}

static void USART_EndTransmit_IT(USART_HandleTypeDef *husart)
{
  /* Disable the USART Transmit Complete Interrupt */
  __HAL_USART_DISABLE_IT(husart, USART_IT_TC);

  /* Disable the USART Error Interrupt: (Frame error, noise error, overrun error) */
  __HAL_USART_DISABLE_IT(husart, USART_IT_ERR);

  /* Clear TxISR function pointer */
  husart->TxISR = NULL;

  if (husart->State == HAL_USART_STATE_BUSY_TX)
  {
    /* Clear overrun flag and discard the received data */
    __HAL_USART_CLEAR_OREFLAG(husart);
    __HAL_USART_SEND_REQ(husart, USART_RXDATA_FLUSH_REQUEST);

    /* Tx process is completed, restore husart->State to Ready */
    husart->State = HAL_USART_STATE_READY;

#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
    /* Call registered Tx Complete Callback */
    husart->TxCpltCallback(husart);
#else
    /* Call legacy weak Tx Complete Callback */
    HAL_USART_TxCpltCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
  }
  else if (husart->RxXferCount == 0U)
  {
    /* TxRx process is completed, restore husart->State to Ready */
    husart->State = HAL_USART_STATE_READY;

#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
    /* Call registered Tx Rx Complete Callback */
    husart->TxRxCpltCallback(husart);
#else
    /* Call legacy weak Tx Rx Complete Callback */
    HAL_USART_TxRxCpltCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
  }
  else
  {
    /* Nothing to do */
  }
}

static void USART_RxISR_8BIT(USART_HandleTypeDef *husart)
{
  const HAL_USART_StateTypeDef state = husart->State;
  uint16_t txdatacount;
  uint16_t uhMask = husart->Mask;
  uint32_t txftie;

  if ((state == HAL_USART_STATE_BUSY_RX) ||
      (state == HAL_USART_STATE_BUSY_TX_RX))
  {
    *husart->pRxBuffPtr = (uint8_t)(husart->Instance->RDR & (uint8_t)uhMask);
    husart->pRxBuffPtr++;
    husart->RxXferCount--;

    if (husart->RxXferCount == 0U)
    {
      /* Disable the USART Parity Error Interrupt and RXNE interrupt*/
      CLEAR_BIT(husart->Instance->CR1, (USART_CR1_RXNEIE_RXFNEIE | USART_CR1_PEIE));

      /* Disable the USART Error Interrupt: (Frame error, noise error, overrun error) */
      CLEAR_BIT(husart->Instance->CR3, USART_CR3_EIE);

      /* Clear RxISR function pointer */
      husart->RxISR = NULL;

      /* txftie and txdatacount are temporary variables for MISRAC2012-Rule-13.5 */
      txftie = READ_BIT(husart->Instance->CR3, USART_CR3_TXFTIE);
      txdatacount = husart->TxXferCount;

      if (state == HAL_USART_STATE_BUSY_RX)
      {
        /* Clear SPI slave underrun flag and discard transmit data */
        if (husart->SlaveMode == USART_SLAVEMODE_ENABLE)
        {
          __HAL_USART_CLEAR_UDRFLAG(husart);
          __HAL_USART_SEND_REQ(husart, USART_TXDATA_FLUSH_REQUEST);
        }

        /* Rx process is completed, restore husart->State to Ready */
        husart->State = HAL_USART_STATE_READY;

#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
        /* Call registered Rx Complete Callback */
        husart->RxCpltCallback(husart);
#else
        /* Call legacy weak Rx Complete Callback */
        HAL_USART_RxCpltCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
      }
      else if ((READ_BIT(husart->Instance->CR1, USART_CR1_TCIE) != USART_CR1_TCIE) &&
               (txftie != USART_CR3_TXFTIE) &&
               (txdatacount == 0U))
      {
        /* TxRx process is completed, restore husart->State to Ready */
        husart->State = HAL_USART_STATE_READY;

#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
        /* Call registered Tx Rx Complete Callback */
        husart->TxRxCpltCallback(husart);
#else
        /* Call legacy weak Tx Rx Complete Callback */
        HAL_USART_TxRxCpltCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
      }
      else
      {
        /* Nothing to do */
      }
    }
    else if ((state == HAL_USART_STATE_BUSY_RX) &&
             (husart->SlaveMode == USART_SLAVEMODE_DISABLE))
    {
      /* Send dummy byte in order to generate the clock for the Slave to Send the next data */
      husart->Instance->TDR = (USART_DUMMY_DATA & (uint16_t)0x00FF);
    }
    else
    {
      /* Nothing to do */
    }
  }
}

static void USART_RxISR_16BIT(USART_HandleTypeDef *husart)
{
  const HAL_USART_StateTypeDef state = husart->State;
  uint16_t txdatacount;
  uint16_t *tmp;
  uint16_t uhMask = husart->Mask;
  uint32_t txftie;

  if ((state == HAL_USART_STATE_BUSY_RX) ||
      (state == HAL_USART_STATE_BUSY_TX_RX))
  {
    tmp = (uint16_t *) husart->pRxBuffPtr;
    *tmp = (uint16_t)(husart->Instance->RDR & uhMask);
    husart->pRxBuffPtr += 2U;
    husart->RxXferCount--;

    if (husart->RxXferCount == 0U)
    {
      /* Disable the USART Parity Error Interrupt and RXNE interrupt*/
      CLEAR_BIT(husart->Instance->CR1, (USART_CR1_RXNEIE_RXFNEIE | USART_CR1_PEIE));

      /* Disable the USART Error Interrupt: (Frame error, noise error, overrun error) */
      CLEAR_BIT(husart->Instance->CR3, USART_CR3_EIE);

      /* Clear RxISR function pointer */
      husart->RxISR = NULL;

      /* txftie and txdatacount are temporary variables for MISRAC2012-Rule-13.5 */
      txftie = READ_BIT(husart->Instance->CR3, USART_CR3_TXFTIE);
      txdatacount = husart->TxXferCount;

      if (state == HAL_USART_STATE_BUSY_RX)
      {
        /* Clear SPI slave underrun flag and discard transmit data */
        if (husart->SlaveMode == USART_SLAVEMODE_ENABLE)
        {
          __HAL_USART_CLEAR_UDRFLAG(husart);
          __HAL_USART_SEND_REQ(husart, USART_TXDATA_FLUSH_REQUEST);
        }

        /* Rx process is completed, restore husart->State to Ready */
        husart->State = HAL_USART_STATE_READY;

#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
        /* Call registered Rx Complete Callback */
        husart->RxCpltCallback(husart);
#else
        /* Call legacy weak Rx Complete Callback */
        HAL_USART_RxCpltCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
      }
      else if ((READ_BIT(husart->Instance->CR1, USART_CR1_TCIE) != USART_CR1_TCIE) &&
               (txftie != USART_CR3_TXFTIE) &&
               (txdatacount == 0U))
      {
        /* TxRx process is completed, restore husart->State to Ready */
        husart->State = HAL_USART_STATE_READY;

#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
        /* Call registered Tx Rx Complete Callback */
        husart->TxRxCpltCallback(husart);
#else
        /* Call legacy weak Tx Rx Complete Callback */
        HAL_USART_TxRxCpltCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
      }
      else
      {
        /* Nothing to do */
      }
    }
    else if ((state == HAL_USART_STATE_BUSY_RX) &&
             (husart->SlaveMode == USART_SLAVEMODE_DISABLE))
    {
      /* Send dummy byte in order to generate the clock for the Slave to Send the next data */
      husart->Instance->TDR = (USART_DUMMY_DATA & (uint16_t)0x00FF);
    }
    else
    {
      /* Nothing to do */
    }
  }
}

static void USART_RxISR_8BIT_FIFOEN(USART_HandleTypeDef *husart)
{
  HAL_USART_StateTypeDef state = husart->State;
  uint16_t txdatacount;
  uint16_t rxdatacount;
  uint16_t uhMask = husart->Mask;
  uint16_t nb_rx_data;
  uint32_t txftie;

  /* Check that a Rx process is ongoing */
  if ((state == HAL_USART_STATE_BUSY_RX) ||
      (state == HAL_USART_STATE_BUSY_TX_RX))
  {
    for (nb_rx_data = husart->NbRxDataToProcess ; nb_rx_data > 0U ; nb_rx_data--)
    {
      if (__HAL_USART_GET_FLAG(husart, USART_FLAG_RXFNE) == SET)
      {
        *husart->pRxBuffPtr = (uint8_t)(husart->Instance->RDR & (uint8_t)(uhMask & 0xFFU));
        husart->pRxBuffPtr++;
        husart->RxXferCount--;

        if (husart->RxXferCount == 0U)
        {
          /* Disable the USART Parity Error Interrupt */
          CLEAR_BIT(husart->Instance->CR1, USART_CR1_PEIE);

          /* Disable the USART Error Interrupt: (Frame error, noise error, overrun error)
             and RX FIFO Threshold interrupt */
          CLEAR_BIT(husart->Instance->CR3, (USART_CR3_EIE | USART_CR3_RXFTIE));

          /* Clear RxISR function pointer */
          husart->RxISR = NULL;

          /* txftie and txdatacount are temporary variables for MISRAC2012-Rule-13.5 */
          txftie = READ_BIT(husart->Instance->CR3, USART_CR3_TXFTIE);
          txdatacount = husart->TxXferCount;

          if (state == HAL_USART_STATE_BUSY_RX)
          {
            /* Clear SPI slave underrun flag and discard transmit data */
            if (husart->SlaveMode == USART_SLAVEMODE_ENABLE)
            {
              __HAL_USART_CLEAR_UDRFLAG(husart);
              __HAL_USART_SEND_REQ(husart, USART_TXDATA_FLUSH_REQUEST);
            }

            /* Rx process is completed, restore husart->State to Ready */
            husart->State = HAL_USART_STATE_READY;
            state = HAL_USART_STATE_READY;

#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
            /* Call registered Rx Complete Callback */
            husart->RxCpltCallback(husart);
#else
            /* Call legacy weak Rx Complete Callback */
            HAL_USART_RxCpltCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
          }
          else if ((READ_BIT(husart->Instance->CR1, USART_CR1_TCIE) != USART_CR1_TCIE) &&
                   (txftie != USART_CR3_TXFTIE) &&
                   (txdatacount == 0U))
          {
            /* TxRx process is completed, restore husart->State to Ready */
            husart->State = HAL_USART_STATE_READY;
            state = HAL_USART_STATE_READY;

#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
            /* Call registered Tx Rx Complete Callback */
            husart->TxRxCpltCallback(husart);
#else
            /* Call legacy weak Tx Rx Complete Callback */
            HAL_USART_TxRxCpltCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
          }
          else
          {
            /* Nothing to do */
          }
        }
        else if ((state == HAL_USART_STATE_BUSY_RX) &&
                 (husart->SlaveMode == USART_SLAVEMODE_DISABLE))
        {
          /* Send dummy byte in order to generate the clock for the Slave to Send the next data */
          husart->Instance->TDR = (USART_DUMMY_DATA & (uint16_t)0x00FF);
        }
        else
        {
          /* Nothing to do */
        }
      }
    }

    /* When remaining number of bytes to receive is less than the RX FIFO
    threshold, next incoming frames are processed as if FIFO mode was
    disabled (i.e. one interrupt per received frame).
    */
    rxdatacount = husart->RxXferCount;
    if (((rxdatacount != 0U)) && (rxdatacount < husart->NbRxDataToProcess))
    {
      /* Disable the USART RXFT interrupt*/
      CLEAR_BIT(husart->Instance->CR3, USART_CR3_RXFTIE);

      /* Update the RxISR function pointer */
      husart->RxISR = USART_RxISR_8BIT;

      /* Enable the USART Data Register Not Empty interrupt */
      SET_BIT(husart->Instance->CR1, USART_CR1_RXNEIE_RXFNEIE);

      if ((husart->TxXferCount == 0U) &&
          (state == HAL_USART_STATE_BUSY_TX_RX) &&
          (husart->SlaveMode == USART_SLAVEMODE_DISABLE))
      {
        /* Send dummy byte in order to generate the clock for the Slave to Send the next data */
        husart->Instance->TDR = (USART_DUMMY_DATA & (uint16_t)0x00FF);
      }
    }
  }
  else
  {
    /* Clear RXNE interrupt flag */
    __HAL_USART_SEND_REQ(husart, USART_RXDATA_FLUSH_REQUEST);
  }
}

static void USART_RxISR_16BIT_FIFOEN(USART_HandleTypeDef *husart)
{
  HAL_USART_StateTypeDef state = husart->State;
  uint16_t txdatacount;
  uint16_t rxdatacount;
  uint16_t *tmp;
  uint16_t uhMask = husart->Mask;
  uint16_t nb_rx_data;
  uint32_t txftie;

  /* Check that a Tx process is ongoing */
  if ((state == HAL_USART_STATE_BUSY_RX) ||
      (state == HAL_USART_STATE_BUSY_TX_RX))
  {
    for (nb_rx_data = husart->NbRxDataToProcess ; nb_rx_data > 0U ; nb_rx_data--)
    {
      if (__HAL_USART_GET_FLAG(husart, USART_FLAG_RXFNE) == SET)
      {
        tmp = (uint16_t *) husart->pRxBuffPtr;
        *tmp = (uint16_t)(husart->Instance->RDR & uhMask);
        husart->pRxBuffPtr += 2U;
        husart->RxXferCount--;

        if (husart->RxXferCount == 0U)
        {
          /* Disable the USART Parity Error Interrupt */
          CLEAR_BIT(husart->Instance->CR1, USART_CR1_PEIE);

          /* Disable the USART Error Interrupt: (Frame error, noise error, overrun error)
             and RX FIFO Threshold interrupt */
          CLEAR_BIT(husart->Instance->CR3, (USART_CR3_EIE | USART_CR3_RXFTIE));

          /* Clear RxISR function pointer */
          husart->RxISR = NULL;

          /* txftie and txdatacount are temporary variables for MISRAC2012-Rule-13.5 */
          txftie = READ_BIT(husart->Instance->CR3, USART_CR3_TXFTIE);
          txdatacount = husart->TxXferCount;

          if (state == HAL_USART_STATE_BUSY_RX)
          {
            /* Clear SPI slave underrun flag and discard transmit data */
            if (husart->SlaveMode == USART_SLAVEMODE_ENABLE)
            {
              __HAL_USART_CLEAR_UDRFLAG(husart);
              __HAL_USART_SEND_REQ(husart, USART_TXDATA_FLUSH_REQUEST);
            }

            /* Rx process is completed, restore husart->State to Ready */
            husart->State = HAL_USART_STATE_READY;
            state = HAL_USART_STATE_READY;

#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
            /* Call registered Rx Complete Callback */
            husart->RxCpltCallback(husart);
#else
            /* Call legacy weak Rx Complete Callback */
            HAL_USART_RxCpltCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
          }
          else if ((READ_BIT(husart->Instance->CR1, USART_CR1_TCIE) != USART_CR1_TCIE) &&
                   (txftie != USART_CR3_TXFTIE) &&
                   (txdatacount == 0U))
          {
            /* TxRx process is completed, restore husart->State to Ready */
            husart->State = HAL_USART_STATE_READY;
            state = HAL_USART_STATE_READY;

#if (USE_HAL_USART_REGISTER_CALLBACKS == 1)
            /* Call registered Tx Rx Complete Callback */
            husart->TxRxCpltCallback(husart);
#else
            /* Call legacy weak Tx Rx Complete Callback */
            HAL_USART_TxRxCpltCallback(husart);
#endif /* USE_HAL_USART_REGISTER_CALLBACKS */
          }
          else
          {
            /* Nothing to do */
          }
        }
        else if ((state == HAL_USART_STATE_BUSY_RX) &&
                 (husart->SlaveMode == USART_SLAVEMODE_DISABLE))
        {
          /* Send dummy byte in order to generate the clock for the Slave to Send the next data */
          husart->Instance->TDR = (USART_DUMMY_DATA & (uint16_t)0x00FF);
        }
        else
        {
          /* Nothing to do */
        }
      }
    }

    /* When remaining number of bytes to receive is less than the RX FIFO
    threshold, next incoming frames are processed as if FIFO mode was
    disabled (i.e. one interrupt per received frame).
    */
    rxdatacount = husart->RxXferCount;
    if (((rxdatacount != 0U)) && (rxdatacount < husart->NbRxDataToProcess))
    {
      /* Disable the USART RXFT interrupt*/
      CLEAR_BIT(husart->Instance->CR3, USART_CR3_RXFTIE);

      /* Update the RxISR function pointer */
      husart->RxISR = USART_RxISR_16BIT;

      /* Enable the USART Data Register Not Empty interrupt */
      SET_BIT(husart->Instance->CR1, USART_CR1_RXNEIE_RXFNEIE);

      if ((husart->TxXferCount == 0U) &&
          (state == HAL_USART_STATE_BUSY_TX_RX) &&
          (husart->SlaveMode == USART_SLAVEMODE_DISABLE))
      {
        /* Send dummy byte in order to generate the clock for the Slave to Send the next data */
        husart->Instance->TDR = (USART_DUMMY_DATA & (uint16_t)0x00FF);
      }
    }
  }
  else
  {
    /* Clear RXNE interrupt flag */
    __HAL_USART_SEND_REQ(husart, USART_RXDATA_FLUSH_REQUEST);
  }
}
