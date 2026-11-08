// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// IRDA operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

HAL_StatusTypeDef HAL_IRDA_Init(IRDA_HandleTypeDef *hirda)
{
  /* Check the IRDA handle allocation */
  if (hirda == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the USART/UART associated to the IRDA handle */
  assert_param(IS_IRDA_INSTANCE(hirda->Instance));

  if (hirda->gState == HAL_IRDA_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    hirda->Lock = HAL_UNLOCKED;

#if USE_HAL_IRDA_REGISTER_CALLBACKS == 1
    IRDA_InitCallbacksToDefault(hirda);

    if (hirda->MspInitCallback == NULL)
    {
      hirda->MspInitCallback = HAL_IRDA_MspInit;
    }

    /* Init the low level hardware */
    hirda->MspInitCallback(hirda);
#else
    /* Init the low level hardware : GPIO, CLOCK */
    HAL_IRDA_MspInit(hirda);
#endif /* USE_HAL_IRDA_REGISTER_CALLBACKS */
  }

  hirda->gState = HAL_IRDA_STATE_BUSY;

  /* Disable the Peripheral to update the configuration registers */
  __HAL_IRDA_DISABLE(hirda);

  /* Set the IRDA Communication parameters */
  if (IRDA_SetConfig(hirda) == HAL_ERROR)
  {
    return HAL_ERROR;
  }

  /* In IRDA mode, the following bits must be kept cleared:
  - LINEN, STOP and CLKEN bits in the USART_CR2 register,
  - SCEN and HDSEL bits in the USART_CR3 register.*/
  CLEAR_BIT(hirda->Instance->CR2, (USART_CR2_LINEN | USART_CR2_CLKEN | USART_CR2_STOP));
  CLEAR_BIT(hirda->Instance->CR3, (USART_CR3_SCEN | USART_CR3_HDSEL));

  /* set the UART/USART in IRDA mode */
  hirda->Instance->CR3 |= USART_CR3_IREN;

  /* Enable the Peripheral */
  __HAL_IRDA_ENABLE(hirda);

  /* TEACK and/or REACK to check before moving hirda->gState and hirda->RxState to Ready */
  return (IRDA_CheckIdleState(hirda));
}

HAL_StatusTypeDef HAL_IRDA_DeInit(IRDA_HandleTypeDef *hirda)
{
  /* Check the IRDA handle allocation */
  if (hirda == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the USART/UART associated to the IRDA handle */
  assert_param(IS_IRDA_INSTANCE(hirda->Instance));

  hirda->gState = HAL_IRDA_STATE_BUSY;

  /* DeInit the low level hardware */
#if USE_HAL_IRDA_REGISTER_CALLBACKS == 1
  if (hirda->MspDeInitCallback == NULL)
  {
    hirda->MspDeInitCallback = HAL_IRDA_MspDeInit;
  }
  /* DeInit the low level hardware */
  hirda->MspDeInitCallback(hirda);
#else
  HAL_IRDA_MspDeInit(hirda);
#endif /* USE_HAL_IRDA_REGISTER_CALLBACKS */
  /* Disable the Peripheral */
  __HAL_IRDA_DISABLE(hirda);

  hirda->ErrorCode = HAL_IRDA_ERROR_NONE;
  hirda->gState    = HAL_IRDA_STATE_RESET;
  hirda->RxState   = HAL_IRDA_STATE_RESET;

  /* Process Unlock */
  __HAL_UNLOCK(hirda);

  return HAL_OK;
}

#if F_MODE
HAL_StatusTypeDef HAL_IRDA_RegisterCallback(IRDA_HandleTypeDef *hirda, HAL_IRDA_CallbackIDTypeDef CallbackID,
                                            pIRDA_CallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hirda->ErrorCode |= HAL_IRDA_ERROR_INVALID_CALLBACK;

    return HAL_ERROR;
  }

  if (hirda->gState == HAL_IRDA_STATE_READY)
  {
    switch (CallbackID)
    {
      case HAL_IRDA_TX_HALFCOMPLETE_CB_ID :
        hirda->TxHalfCpltCallback = pCallback;
        break;

      case HAL_IRDA_TX_COMPLETE_CB_ID :
        hirda->TxCpltCallback = pCallback;
        break;

      case HAL_IRDA_RX_HALFCOMPLETE_CB_ID :
        hirda->RxHalfCpltCallback = pCallback;
        break;

      case HAL_IRDA_RX_COMPLETE_CB_ID :
        hirda->RxCpltCallback = pCallback;
        break;

      case HAL_IRDA_ERROR_CB_ID :
        hirda->ErrorCallback = pCallback;
        break;

      case HAL_IRDA_ABORT_COMPLETE_CB_ID :
        hirda->AbortCpltCallback = pCallback;
        break;

      case HAL_IRDA_ABORT_TRANSMIT_COMPLETE_CB_ID :
        hirda->AbortTransmitCpltCallback = pCallback;
        break;

      case HAL_IRDA_ABORT_RECEIVE_COMPLETE_CB_ID :
        hirda->AbortReceiveCpltCallback = pCallback;
        break;

      case HAL_IRDA_MSPINIT_CB_ID :
        hirda->MspInitCallback = pCallback;
        break;

      case HAL_IRDA_MSPDEINIT_CB_ID :
        hirda->MspDeInitCallback = pCallback;
        break;

      default :
        /* Update the error code */
        hirda->ErrorCode |= HAL_IRDA_ERROR_INVALID_CALLBACK;

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (hirda->gState == HAL_IRDA_STATE_RESET)
  {
    switch (CallbackID)
    {
      case HAL_IRDA_MSPINIT_CB_ID :
        hirda->MspInitCallback = pCallback;
        break;

      case HAL_IRDA_MSPDEINIT_CB_ID :
        hirda->MspDeInitCallback = pCallback;
        break;

      default :
        /* Update the error code */
        hirda->ErrorCode |= HAL_IRDA_ERROR_INVALID_CALLBACK;

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hirda->ErrorCode |= HAL_IRDA_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif

#if F_MODE
HAL_StatusTypeDef HAL_IRDA_UnRegisterCallback(IRDA_HandleTypeDef *hirda, HAL_IRDA_CallbackIDTypeDef CallbackID)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (HAL_IRDA_STATE_READY == hirda->gState)
  {
    switch (CallbackID)
    {
      case HAL_IRDA_TX_HALFCOMPLETE_CB_ID :
        hirda->TxHalfCpltCallback = HAL_IRDA_TxHalfCpltCallback;               /* Legacy weak  TxHalfCpltCallback    */
        break;

      case HAL_IRDA_TX_COMPLETE_CB_ID :
        hirda->TxCpltCallback = HAL_IRDA_TxCpltCallback;                       /* Legacy weak TxCpltCallback         */
        break;

      case HAL_IRDA_RX_HALFCOMPLETE_CB_ID :
        hirda->RxHalfCpltCallback = HAL_IRDA_RxHalfCpltCallback;               /* Legacy weak RxHalfCpltCallback     */
        break;

      case HAL_IRDA_RX_COMPLETE_CB_ID :
        hirda->RxCpltCallback = HAL_IRDA_RxCpltCallback;                       /* Legacy weak RxCpltCallback         */
        break;

      case HAL_IRDA_ERROR_CB_ID :
        hirda->ErrorCallback = HAL_IRDA_ErrorCallback;                         /* Legacy weak ErrorCallback          */
        break;

      case HAL_IRDA_ABORT_COMPLETE_CB_ID :
        hirda->AbortCpltCallback = HAL_IRDA_AbortCpltCallback;                 /* Legacy weak AbortCpltCallback      */
        break;

      case HAL_IRDA_ABORT_TRANSMIT_COMPLETE_CB_ID :
        hirda->AbortTransmitCpltCallback = HAL_IRDA_AbortTransmitCpltCallback; /* Legacy weak
                                                                                  AbortTransmitCpltCallback          */
        break;

      case HAL_IRDA_ABORT_RECEIVE_COMPLETE_CB_ID :
        hirda->AbortReceiveCpltCallback = HAL_IRDA_AbortReceiveCpltCallback;   /* Legacy weak
                                                                                  AbortReceiveCpltCallback           */
        break;

      case HAL_IRDA_MSPINIT_CB_ID :
        hirda->MspInitCallback = HAL_IRDA_MspInit;                             /* Legacy weak MspInitCallback        */
        break;

      case HAL_IRDA_MSPDEINIT_CB_ID :
        hirda->MspDeInitCallback = HAL_IRDA_MspDeInit;                         /* Legacy weak MspDeInitCallback      */
        break;

      default :
        /* Update the error code */
        hirda->ErrorCode |= HAL_IRDA_ERROR_INVALID_CALLBACK;

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (HAL_IRDA_STATE_RESET == hirda->gState)
  {
    switch (CallbackID)
    {
      case HAL_IRDA_MSPINIT_CB_ID :
        hirda->MspInitCallback = HAL_IRDA_MspInit;
        break;

      case HAL_IRDA_MSPDEINIT_CB_ID :
        hirda->MspDeInitCallback = HAL_IRDA_MspDeInit;
        break;

      default :
        /* Update the error code */
        hirda->ErrorCode |= HAL_IRDA_ERROR_INVALID_CALLBACK;

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hirda->ErrorCode |= HAL_IRDA_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif

HAL_StatusTypeDef HAL_IRDA_Transmit(IRDA_HandleTypeDef *hirda, const uint8_t *pData, uint16_t Size, uint32_t Timeout)
{
  const uint8_t  *pdata8bits;
  const uint16_t *pdata16bits;
  uint32_t tickstart;

  /* Check that a Tx process is not already ongoing */
  if (hirda->gState == HAL_IRDA_STATE_READY)
  {
    if ((pData == NULL) || (Size == 0U))
    {
      return  HAL_ERROR;
    }

    /* Process Locked */
    __HAL_LOCK(hirda);

    hirda->ErrorCode = HAL_IRDA_ERROR_NONE;
    hirda->gState = HAL_IRDA_STATE_BUSY_TX;

    /* Init tickstart for timeout management */
    tickstart = HAL_GetTick();

    hirda->TxXferSize = Size;
    hirda->TxXferCount = Size;

    /* In case of 9bits/No Parity transfer, pData needs to be handled as a uint16_t pointer */
    if ((hirda->Init.WordLength == IRDA_WORDLENGTH_9B) && (hirda->Init.Parity == IRDA_PARITY_NONE))
    {
      pdata8bits  = NULL;
      pdata16bits = (const uint16_t *) pData; /* Derogation R.11.3 */
    }
    else
    {
      pdata8bits  = pData;
      pdata16bits = NULL;
    }

    while (hirda->TxXferCount > 0U)
    {
      hirda->TxXferCount--;

      if (IRDA_WaitOnFlagUntilTimeout(hirda, IRDA_FLAG_TXE, RESET, tickstart, Timeout) != HAL_OK)
      {
        return HAL_TIMEOUT;
      }
      if (pdata8bits == NULL)
      {
        hirda->Instance->TDR = (uint16_t)(*pdata16bits & 0x01FFU);
        pdata16bits++;
      }
      else
      {
        hirda->Instance->TDR = (uint8_t)(*pdata8bits & 0xFFU);
        pdata8bits++;
      }
    }

    if (IRDA_WaitOnFlagUntilTimeout(hirda, IRDA_FLAG_TC, RESET, tickstart, Timeout) != HAL_OK)
    {
      return HAL_TIMEOUT;
    }

    /* At end of Tx process, restore hirda->gState to Ready */
    hirda->gState = HAL_IRDA_STATE_READY;

    /* Process Unlocked */
    __HAL_UNLOCK(hirda);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}

HAL_StatusTypeDef HAL_IRDA_Receive(IRDA_HandleTypeDef *hirda, uint8_t *pData, uint16_t Size, uint32_t Timeout)
{
  uint8_t  *pdata8bits;
  uint16_t *pdata16bits;
  uint16_t uhMask;
  uint32_t tickstart;

  /* Check that a Rx process is not already ongoing */
  if (hirda->RxState == HAL_IRDA_STATE_READY)
  {
    if ((pData == NULL) || (Size == 0U))
    {
      return  HAL_ERROR;
    }

    /* Process Locked */
    __HAL_LOCK(hirda);

    hirda->ErrorCode = HAL_IRDA_ERROR_NONE;
    hirda->RxState = HAL_IRDA_STATE_BUSY_RX;

    /* Init tickstart for timeout management */
    tickstart = HAL_GetTick();

    hirda->RxXferSize = Size;
    hirda->RxXferCount = Size;

    /* Computation of the mask to apply to RDR register
       of the UART associated to the IRDA */
    IRDA_MASK_COMPUTATION(hirda);
    uhMask = hirda->Mask;

    /* In case of 9bits/No Parity transfer, pRxData needs to be handled as a uint16_t pointer */
    if ((hirda->Init.WordLength == IRDA_WORDLENGTH_9B) && (hirda->Init.Parity == IRDA_PARITY_NONE))
    {
      pdata8bits  = NULL;
      pdata16bits = (uint16_t *) pData; /* Derogation R.11.3 */
    }
    else
    {
      pdata8bits  = pData;
      pdata16bits = NULL;
    }

    /* Check data remaining to be received */
    while (hirda->RxXferCount > 0U)
    {
      hirda->RxXferCount--;

      if (IRDA_WaitOnFlagUntilTimeout(hirda, IRDA_FLAG_RXNE, RESET, tickstart, Timeout) != HAL_OK)
      {
        return HAL_TIMEOUT;
      }
      if (pdata8bits == NULL)
      {
        *pdata16bits = (uint16_t)(hirda->Instance->RDR & uhMask);
        pdata16bits++;
      }
      else
      {
        *pdata8bits = (uint8_t)(hirda->Instance->RDR & (uint8_t)uhMask);
        pdata8bits++;
      }
    }

    /* At end of Rx process, restore hirda->RxState to Ready */
    hirda->RxState = HAL_IRDA_STATE_READY;

    /* Process Unlocked */
    __HAL_UNLOCK(hirda);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}

HAL_StatusTypeDef HAL_IRDA_Transmit_IT(IRDA_HandleTypeDef *hirda, const uint8_t *pData, uint16_t Size)
{
  /* Check that a Tx process is not already ongoing */
  if (hirda->gState == HAL_IRDA_STATE_READY)
  {
    if ((pData == NULL) || (Size == 0U))
    {
      return HAL_ERROR;
    }

    /* Process Locked */
    __HAL_LOCK(hirda);

    hirda->pTxBuffPtr = pData;
    hirda->TxXferSize = Size;
    hirda->TxXferCount = Size;

    hirda->ErrorCode = HAL_IRDA_ERROR_NONE;
    hirda->gState = HAL_IRDA_STATE_BUSY_TX;

    /* Process Unlocked */
    __HAL_UNLOCK(hirda);

    /* Enable the IRDA Transmit Data Register Empty Interrupt */
    SET_BIT(hirda->Instance->CR1, USART_CR1_TXEIE_TXFNFIE);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}

HAL_StatusTypeDef HAL_IRDA_Receive_IT(IRDA_HandleTypeDef *hirda, uint8_t *pData, uint16_t Size)
{
  /* Check that a Rx process is not already ongoing */
  if (hirda->RxState == HAL_IRDA_STATE_READY)
  {
    if ((pData == NULL) || (Size == 0U))
    {
      return HAL_ERROR;
    }

    /* Process Locked */
    __HAL_LOCK(hirda);

    hirda->pRxBuffPtr = pData;
    hirda->RxXferSize = Size;
    hirda->RxXferCount = Size;

    /* Computation of the mask to apply to the RDR register
       of the UART associated to the IRDA */
    IRDA_MASK_COMPUTATION(hirda);

    hirda->ErrorCode = HAL_IRDA_ERROR_NONE;
    hirda->RxState = HAL_IRDA_STATE_BUSY_RX;

    /* Process Unlocked */
    __HAL_UNLOCK(hirda);

    if (hirda->Init.Parity != IRDA_PARITY_NONE)
    {
      /* Enable the IRDA Parity Error and Data Register not empty Interrupts */
      SET_BIT(hirda->Instance->CR1, USART_CR1_PEIE | USART_CR1_RXNEIE_RXFNEIE);
    }
    else
    {
      /* Enable the IRDA Data Register not empty Interrupts */
      SET_BIT(hirda->Instance->CR1, USART_CR1_RXNEIE_RXFNEIE);
    }

    /* Enable the IRDA Error Interrupt: (Frame error, noise error, overrun error) */
    SET_BIT(hirda->Instance->CR3, USART_CR3_EIE);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}

HAL_StatusTypeDef HAL_IRDA_Transmit_DMA(IRDA_HandleTypeDef *hirda, const uint8_t *pData, uint16_t Size)
{
  HAL_StatusTypeDef status;
  uint16_t nbByte = Size;

  /* Check that a Tx process is not already ongoing */
  if (hirda->gState == HAL_IRDA_STATE_READY)
  {
    if ((pData == NULL) || (Size == 0U))
    {
      return HAL_ERROR;
    }

    /* Process Locked */
    __HAL_LOCK(hirda);

    hirda->pTxBuffPtr = pData;
    hirda->TxXferSize = Size;
    hirda->TxXferCount = Size;

    hirda->ErrorCode = HAL_IRDA_ERROR_NONE;
    hirda->gState = HAL_IRDA_STATE_BUSY_TX;

    /* Set the IRDA DMA transfer complete callback */
    hirda->hdmatx->XferCpltCallback = IRDA_DMATransmitCplt;

    /* Set the IRDA DMA half transfer complete callback */
    hirda->hdmatx->XferHalfCpltCallback = IRDA_DMATransmitHalfCplt;

    /* Set the DMA error callback */
    hirda->hdmatx->XferErrorCallback = IRDA_DMAError;

    /* Set the DMA abort callback */
    hirda->hdmatx->XferAbortCallback = NULL;

    /* In case of 9bits/No Parity transfer, pData buffer provided as input parameter
       should be aligned on a u16 frontier, so nbByte should be equal to Size multiplied by 2 */
    if ((hirda->Init.WordLength == IRDA_WORDLENGTH_9B) && (hirda->Init.Parity == IRDA_PARITY_NONE))
    {
      nbByte = Size * 2U;
    }

    /* Check linked list mode */
    if ((hirda->hdmatx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
    {
      if ((hirda->hdmatx->LinkedListQueue != NULL) && (hirda->hdmatx->LinkedListQueue->Head != NULL))
      {
        /* Set DMA data size */
        hirda->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = nbByte;

        /* Set DMA source address */
        hirda->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] =
          (uint32_t)hirda->pTxBuffPtr;

        /* Set DMA destination address */
        hirda->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] =
          (uint32_t)&hirda->Instance->TDR;

        /* Enable the IRDA transmit DMA channel */
        status = HAL_DMAEx_List_Start_IT(hirda->hdmatx);
      }
      else
      {
        /* Update status */
        status = HAL_ERROR;
      }
    }
    else
    {
      /* Enable the IRDA transmit DMA channel */
      status = HAL_DMA_Start_IT(hirda->hdmatx, (uint32_t)hirda->pTxBuffPtr, (uint32_t)&hirda->Instance->TDR, nbByte);
    }

    if (status == HAL_OK)
    {
      /* Clear the TC flag in the ICR register */
      __HAL_IRDA_CLEAR_FLAG(hirda, IRDA_CLEAR_TCF);

      /* Process Unlocked */
      __HAL_UNLOCK(hirda);

      /* Enable the DMA transfer for transmit request by setting the DMAT bit
         in the USART CR3 register */
      SET_BIT(hirda->Instance->CR3, USART_CR3_DMAT);

      return HAL_OK;
    }
    else
    {
      /* Set error code to DMA */
      hirda->ErrorCode = HAL_IRDA_ERROR_DMA;

      /* Process Unlocked */
      __HAL_UNLOCK(hirda);

      /* Restore hirda->gState to ready */
      hirda->gState = HAL_IRDA_STATE_READY;

      return HAL_ERROR;
    }
  }
  else
  {
    return HAL_BUSY;
  }
}

HAL_StatusTypeDef HAL_IRDA_Receive_DMA(IRDA_HandleTypeDef *hirda, uint8_t *pData, uint16_t Size)
{
  HAL_StatusTypeDef status;
  uint16_t nbByte = Size;

  /* Check that a Rx process is not already ongoing */
  if (hirda->RxState == HAL_IRDA_STATE_READY)
  {
    if ((pData == NULL) || (Size == 0U))
    {
      return HAL_ERROR;
    }

    /* Process Locked */
    __HAL_LOCK(hirda);

    hirda->pRxBuffPtr = pData;
    hirda->RxXferSize = Size;

    hirda->ErrorCode = HAL_IRDA_ERROR_NONE;
    hirda->RxState = HAL_IRDA_STATE_BUSY_RX;

    /* Set the IRDA DMA transfer complete callback */
    hirda->hdmarx->XferCpltCallback = IRDA_DMAReceiveCplt;

    /* Set the IRDA DMA half transfer complete callback */
    hirda->hdmarx->XferHalfCpltCallback = IRDA_DMAReceiveHalfCplt;

    /* Set the DMA error callback */
    hirda->hdmarx->XferErrorCallback = IRDA_DMAError;

    /* Set the DMA abort callback */
    hirda->hdmarx->XferAbortCallback = NULL;

    /* In case of 9bits/No Parity transfer, pData buffer provided as input parameter
       should be aligned on a u16 frontier, so nbByte should be equal to Size multiplied by 2 */
    if ((hirda->Init.WordLength == IRDA_WORDLENGTH_9B) && (hirda->Init.Parity == IRDA_PARITY_NONE))
    {
      nbByte = Size * 2U;
    }

    /* Check linked list mode */
    if ((hirda->hdmarx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
    {
      if ((hirda->hdmarx->LinkedListQueue != NULL) && (hirda->hdmarx->LinkedListQueue->Head != NULL))
      {
        /* Set DMA data size */
        hirda->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = nbByte;

        /* Set DMA source address */
        hirda->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] =
          (uint32_t)&hirda->Instance->RDR;

        /* Set DMA destination address */
        hirda->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = (uint32_t)hirda->pRxBuffPtr;

        /* Enable the DMA channel */
        status = HAL_DMAEx_List_Start_IT(hirda->hdmarx);
      }
      else
      {
        /* Update status */
        status = HAL_ERROR;
      }
    }
    else
    {
      /* Enable the DMA channel */
      status = HAL_DMA_Start_IT(hirda->hdmarx, (uint32_t)&hirda->Instance->RDR, (uint32_t)hirda->pRxBuffPtr, nbByte);
    }

    if (status == HAL_OK)
    {
      /* Process Unlocked */
      __HAL_UNLOCK(hirda);

      if (hirda->Init.Parity != IRDA_PARITY_NONE)
      {
        /* Enable the UART Parity Error Interrupt */
        SET_BIT(hirda->Instance->CR1, USART_CR1_PEIE);
      }

      /* Enable the UART Error Interrupt: (Frame error, noise error, overrun error) */
      SET_BIT(hirda->Instance->CR3, USART_CR3_EIE);

      /* Enable the DMA transfer for the receiver request by setting the DMAR bit
         in the USART CR3 register */
      SET_BIT(hirda->Instance->CR3, USART_CR3_DMAR);

      return HAL_OK;
    }
    else
    {
      /* Set error code to DMA */
      hirda->ErrorCode = HAL_IRDA_ERROR_DMA;

      /* Process Unlocked */
      __HAL_UNLOCK(hirda);

      /* Restore hirda->RxState to ready */
      hirda->RxState = HAL_IRDA_STATE_READY;

      return HAL_ERROR;
    }
  }
  else
  {
    return HAL_BUSY;
  }
}

HAL_StatusTypeDef HAL_IRDA_DMAPause(IRDA_HandleTypeDef *hirda)
{
  /* Process Locked */
  __HAL_LOCK(hirda);

  if (hirda->gState == HAL_IRDA_STATE_BUSY_TX)
  {
    if (HAL_IS_BIT_SET(hirda->Instance->CR3, USART_CR3_DMAT))
    {
      /* Disable the IRDA DMA Tx request */
      CLEAR_BIT(hirda->Instance->CR3, USART_CR3_DMAT);
    }
  }
  if (hirda->RxState == HAL_IRDA_STATE_BUSY_RX)
  {
    if (HAL_IS_BIT_SET(hirda->Instance->CR3, USART_CR3_DMAR))
    {
      /* Disable PE and ERR (Frame error, noise error, overrun error) interrupts */
      CLEAR_BIT(hirda->Instance->CR1, USART_CR1_PEIE);
      CLEAR_BIT(hirda->Instance->CR3, USART_CR3_EIE);

      /* Disable the IRDA DMA Rx request */
      CLEAR_BIT(hirda->Instance->CR3, USART_CR3_DMAR);
    }
  }

  /* Process Unlocked */
  __HAL_UNLOCK(hirda);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_IRDA_DMAResume(IRDA_HandleTypeDef *hirda)
{
  /* Process Locked */
  __HAL_LOCK(hirda);

  if (hirda->gState == HAL_IRDA_STATE_BUSY_TX)
  {
    /* Enable the IRDA DMA Tx request */
    SET_BIT(hirda->Instance->CR3, USART_CR3_DMAT);
  }
  if (hirda->RxState == HAL_IRDA_STATE_BUSY_RX)
  {
    /* Clear the Overrun flag before resuming the Rx transfer*/
    __HAL_IRDA_CLEAR_OREFLAG(hirda);

    /* Re-enable PE and ERR (Frame error, noise error, overrun error) interrupts */
    if (hirda->Init.Parity != IRDA_PARITY_NONE)
    {
      SET_BIT(hirda->Instance->CR1, USART_CR1_PEIE);
    }
    SET_BIT(hirda->Instance->CR3, USART_CR3_EIE);

    /* Enable the IRDA DMA Rx request */
    SET_BIT(hirda->Instance->CR3, USART_CR3_DMAR);
  }

  /* Process Unlocked */
  __HAL_UNLOCK(hirda);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_IRDA_DMAStop(IRDA_HandleTypeDef *hirda)
{
  /* The Lock is not implemented on this API to allow the user application
     to call the HAL IRDA API under callbacks HAL_IRDA_TxCpltCallback() / HAL_IRDA_RxCpltCallback() /
     HAL_IRDA_TxHalfCpltCallback / HAL_IRDA_RxHalfCpltCallback:
     indeed, when HAL_DMA_Abort() API is called, the DMA TX/RX Transfer or Half Transfer complete
     interrupt is generated if the DMA transfer interruption occurs at the middle or at the end of
     the stream and the corresponding call back is executed. */

  /* Stop IRDA DMA Tx request if ongoing */
  if (hirda->gState == HAL_IRDA_STATE_BUSY_TX)
  {
    if (HAL_IS_BIT_SET(hirda->Instance->CR3, USART_CR3_DMAT))
    {
      CLEAR_BIT(hirda->Instance->CR3, USART_CR3_DMAT);

      /* Abort the IRDA DMA Tx channel */
      if (hirda->hdmatx != NULL)
      {
        if (HAL_DMA_Abort(hirda->hdmatx) != HAL_OK)
        {
          if (HAL_DMA_GetError(hirda->hdmatx) == HAL_DMA_ERROR_TIMEOUT)
          {
            /* Set error code to DMA */
            hirda->ErrorCode = HAL_IRDA_ERROR_DMA;

            return HAL_TIMEOUT;
          }
        }
      }

      IRDA_EndTxTransfer(hirda);
    }
  }

  /* Stop IRDA DMA Rx request if ongoing */
  if (hirda->RxState == HAL_IRDA_STATE_BUSY_RX)
  {
    if (HAL_IS_BIT_SET(hirda->Instance->CR3, USART_CR3_DMAR))
    {
      CLEAR_BIT(hirda->Instance->CR3, USART_CR3_DMAR);

      /* Abort the IRDA DMA Rx channel */
      if (hirda->hdmarx != NULL)
      {
        if (HAL_DMA_Abort(hirda->hdmarx) != HAL_OK)
        {
          if (HAL_DMA_GetError(hirda->hdmarx) == HAL_DMA_ERROR_TIMEOUT)
          {
            /* Set error code to DMA */
            hirda->ErrorCode = HAL_IRDA_ERROR_DMA;

            return HAL_TIMEOUT;
          }
        }
      }

      IRDA_EndRxTransfer(hirda);
    }
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_IRDA_Abort(IRDA_HandleTypeDef *hirda)
{
  /* Disable TXEIE, TCIE, RXNE, PE and ERR (Frame error, noise error, overrun error) interrupts */
  CLEAR_BIT(hirda->Instance->CR1, (USART_CR1_RXNEIE_RXFNEIE | USART_CR1_PEIE | \
                                   USART_CR1_TXEIE_TXFNFIE | USART_CR1_TCIE));
  CLEAR_BIT(hirda->Instance->CR3, USART_CR3_EIE);

#if defined(HAL_DMA_MODULE_ENABLED)
  /* Disable the IRDA DMA Tx request if enabled */
  if (HAL_IS_BIT_SET(hirda->Instance->CR3, USART_CR3_DMAT))
  {
    CLEAR_BIT(hirda->Instance->CR3, USART_CR3_DMAT);

    /* Abort the IRDA DMA Tx channel : use blocking DMA Abort API (no callback) */
    if (hirda->hdmatx != NULL)
    {
      /* Set the IRDA DMA Abort callback to Null.
         No call back execution at end of DMA abort procedure */
      hirda->hdmatx->XferAbortCallback = NULL;

      if (HAL_DMA_Abort(hirda->hdmatx) != HAL_OK)
      {
        if (HAL_DMA_GetError(hirda->hdmatx) == HAL_DMA_ERROR_TIMEOUT)
        {
          /* Set error code to DMA */
          hirda->ErrorCode = HAL_IRDA_ERROR_DMA;

          return HAL_TIMEOUT;
        }
      }
    }
  }

  /* Disable the IRDA DMA Rx request if enabled */
  if (HAL_IS_BIT_SET(hirda->Instance->CR3, USART_CR3_DMAR))
  {
    CLEAR_BIT(hirda->Instance->CR3, USART_CR3_DMAR);

    /* Abort the IRDA DMA Rx channel : use blocking DMA Abort API (no callback) */
    if (hirda->hdmarx != NULL)
    {
      /* Set the IRDA DMA Abort callback to Null.
         No call back execution at end of DMA abort procedure */
      hirda->hdmarx->XferAbortCallback = NULL;

      if (HAL_DMA_Abort(hirda->hdmarx) != HAL_OK)
      {
        if (HAL_DMA_GetError(hirda->hdmarx) == HAL_DMA_ERROR_TIMEOUT)
        {
          /* Set error code to DMA */
          hirda->ErrorCode = HAL_IRDA_ERROR_DMA;

          return HAL_TIMEOUT;
        }
      }
    }
  }
#endif /* HAL_DMA_MODULE_ENABLED */

  /* Reset Tx and Rx transfer counters */
  hirda->TxXferCount = 0U;
  hirda->RxXferCount = 0U;

  /* Clear the Error flags in the ICR register */
  __HAL_IRDA_CLEAR_FLAG(hirda, IRDA_CLEAR_OREF | IRDA_CLEAR_NEF | IRDA_CLEAR_PEF | IRDA_CLEAR_FEF);

  /* Restore hirda->gState and hirda->RxState to Ready */
  hirda->gState  = HAL_IRDA_STATE_READY;
  hirda->RxState = HAL_IRDA_STATE_READY;

  /* Reset Handle ErrorCode to No Error */
  hirda->ErrorCode = HAL_IRDA_ERROR_NONE;

  return HAL_OK;
}

HAL_StatusTypeDef HAL_IRDA_AbortTransmit(IRDA_HandleTypeDef *hirda)
{
  /* Disable TXEIE and TCIE interrupts */
  CLEAR_BIT(hirda->Instance->CR1, (USART_CR1_TXEIE_TXFNFIE | USART_CR1_TCIE));

#if defined(HAL_DMA_MODULE_ENABLED)
  /* Disable the IRDA DMA Tx request if enabled */
  if (HAL_IS_BIT_SET(hirda->Instance->CR3, USART_CR3_DMAT))
  {
    CLEAR_BIT(hirda->Instance->CR3, USART_CR3_DMAT);

    /* Abort the IRDA DMA Tx channel : use blocking DMA Abort API (no callback) */
    if (hirda->hdmatx != NULL)
    {
      /* Set the IRDA DMA Abort callback to Null.
         No call back execution at end of DMA abort procedure */
      hirda->hdmatx->XferAbortCallback = NULL;

      if (HAL_DMA_Abort(hirda->hdmatx) != HAL_OK)
      {
        if (HAL_DMA_GetError(hirda->hdmatx) == HAL_DMA_ERROR_TIMEOUT)
        {
          /* Set error code to DMA */
          hirda->ErrorCode = HAL_IRDA_ERROR_DMA;

          return HAL_TIMEOUT;
        }
      }
    }
  }
#endif /* HAL_DMA_MODULE_ENABLED */

  /* Reset Tx transfer counter */
  hirda->TxXferCount = 0U;

  /* Restore hirda->gState to Ready */
  hirda->gState = HAL_IRDA_STATE_READY;

  return HAL_OK;
}

HAL_StatusTypeDef HAL_IRDA_AbortReceive(IRDA_HandleTypeDef *hirda)
{
  /* Disable RXNE, PE and ERR (Frame error, noise error, overrun error) interrupts */
  CLEAR_BIT(hirda->Instance->CR1, (USART_CR1_RXNEIE_RXFNEIE | USART_CR1_PEIE));
  CLEAR_BIT(hirda->Instance->CR3, USART_CR3_EIE);

#if defined(HAL_DMA_MODULE_ENABLED)
  /* Disable the IRDA DMA Rx request if enabled */
  if (HAL_IS_BIT_SET(hirda->Instance->CR3, USART_CR3_DMAR))
  {
    CLEAR_BIT(hirda->Instance->CR3, USART_CR3_DMAR);

    /* Abort the IRDA DMA Rx channel : use blocking DMA Abort API (no callback) */
    if (hirda->hdmarx != NULL)
    {
      /* Set the IRDA DMA Abort callback to Null.
         No call back execution at end of DMA abort procedure */
      hirda->hdmarx->XferAbortCallback = NULL;

      if (HAL_DMA_Abort(hirda->hdmarx) != HAL_OK)
      {
        if (HAL_DMA_GetError(hirda->hdmarx) == HAL_DMA_ERROR_TIMEOUT)
        {
          /* Set error code to DMA */
          hirda->ErrorCode = HAL_IRDA_ERROR_DMA;

          return HAL_TIMEOUT;
        }
      }
    }
  }
#endif /* HAL_DMA_MODULE_ENABLED */

  /* Reset Rx transfer counter */
  hirda->RxXferCount = 0U;

  /* Clear the Error flags in the ICR register */
  __HAL_IRDA_CLEAR_FLAG(hirda, IRDA_CLEAR_OREF | IRDA_CLEAR_NEF | IRDA_CLEAR_PEF | IRDA_CLEAR_FEF);

  /* Restore hirda->RxState to Ready */
  hirda->RxState = HAL_IRDA_STATE_READY;

  return HAL_OK;
}

HAL_StatusTypeDef HAL_IRDA_Abort_IT(IRDA_HandleTypeDef *hirda)
{
  uint32_t abortcplt = 1U;

  /* Disable TXEIE, TCIE, RXNE, PE and ERR (Frame error, noise error, overrun error) interrupts */
  CLEAR_BIT(hirda->Instance->CR1, (USART_CR1_RXNEIE_RXFNEIE | USART_CR1_PEIE | \
                                   USART_CR1_TXEIE_TXFNFIE | USART_CR1_TCIE));
  CLEAR_BIT(hirda->Instance->CR3, USART_CR3_EIE);

#if defined(HAL_DMA_MODULE_ENABLED)
  /* If DMA Tx and/or DMA Rx Handles are associated to IRDA Handle, DMA Abort complete callbacks should be initialised
     before any call to DMA Abort functions */
  /* DMA Tx Handle is valid */
  if (hirda->hdmatx != NULL)
  {
    /* Set DMA Abort Complete callback if IRDA DMA Tx request if enabled.
       Otherwise, set it to NULL */
    if (HAL_IS_BIT_SET(hirda->Instance->CR3, USART_CR3_DMAT))
    {
      hirda->hdmatx->XferAbortCallback = IRDA_DMATxAbortCallback;
    }
    else
    {
      hirda->hdmatx->XferAbortCallback = NULL;
    }
  }
  /* DMA Rx Handle is valid */
  if (hirda->hdmarx != NULL)
  {
    /* Set DMA Abort Complete callback if IRDA DMA Rx request if enabled.
       Otherwise, set it to NULL */
    if (HAL_IS_BIT_SET(hirda->Instance->CR3, USART_CR3_DMAR))
    {
      hirda->hdmarx->XferAbortCallback = IRDA_DMARxAbortCallback;
    }
    else
    {
      hirda->hdmarx->XferAbortCallback = NULL;
    }
  }

  /* Disable the IRDA DMA Tx request if enabled */
  if (HAL_IS_BIT_SET(hirda->Instance->CR3, USART_CR3_DMAT))
  {
    /* Disable DMA Tx at UART level */
    CLEAR_BIT(hirda->Instance->CR3, USART_CR3_DMAT);

    /* Abort the IRDA DMA Tx channel : use non blocking DMA Abort API (callback) */
    if (hirda->hdmatx != NULL)
    {
      /* IRDA Tx DMA Abort callback has already been initialised :
         will lead to call HAL_IRDA_AbortCpltCallback() at end of DMA abort procedure */

      /* Abort DMA TX */
      if (HAL_DMA_Abort_IT(hirda->hdmatx) != HAL_OK)
      {
        hirda->hdmatx->XferAbortCallback = NULL;
      }
      else
      {
        abortcplt = 0U;
      }
    }
  }

  /* Disable the IRDA DMA Rx request if enabled */
  if (HAL_IS_BIT_SET(hirda->Instance->CR3, USART_CR3_DMAR))
  {
    CLEAR_BIT(hirda->Instance->CR3, USART_CR3_DMAR);

    /* Abort the IRDA DMA Rx channel : use non blocking DMA Abort API (callback) */
    if (hirda->hdmarx != NULL)
    {
      /* IRDA Rx DMA Abort callback has already been initialised :
         will lead to call HAL_IRDA_AbortCpltCallback() at end of DMA abort procedure */

      /* Abort DMA RX */
      if (HAL_DMA_Abort_IT(hirda->hdmarx) != HAL_OK)
      {
        hirda->hdmarx->XferAbortCallback = NULL;
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
    hirda->TxXferCount = 0U;
    hirda->RxXferCount = 0U;

    /* Reset errorCode */
    hirda->ErrorCode = HAL_IRDA_ERROR_NONE;

    /* Clear the Error flags in the ICR register */
    __HAL_IRDA_CLEAR_FLAG(hirda, IRDA_CLEAR_OREF | IRDA_CLEAR_NEF | IRDA_CLEAR_PEF | IRDA_CLEAR_FEF);

    /* Restore hirda->gState and hirda->RxState to Ready */
    hirda->gState  = HAL_IRDA_STATE_READY;
    hirda->RxState = HAL_IRDA_STATE_READY;

    /* As no DMA to be aborted, call directly user Abort complete callback */
#if (USE_HAL_IRDA_REGISTER_CALLBACKS == 1)
    /* Call registered Abort complete callback */
    hirda->AbortCpltCallback(hirda);
#else
    /* Call legacy weak Abort complete callback */
    HAL_IRDA_AbortCpltCallback(hirda);
#endif /* USE_HAL_IRDA_REGISTER_CALLBACK */
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_IRDA_AbortTransmit_IT(IRDA_HandleTypeDef *hirda)
{
  /* Disable TXEIE and TCIE interrupts */
  CLEAR_BIT(hirda->Instance->CR1, (USART_CR1_TXEIE_TXFNFIE | USART_CR1_TCIE));

#if defined(HAL_DMA_MODULE_ENABLED)
  /* Disable the IRDA DMA Tx request if enabled */
  if (HAL_IS_BIT_SET(hirda->Instance->CR3, USART_CR3_DMAT))
  {
    CLEAR_BIT(hirda->Instance->CR3, USART_CR3_DMAT);

    /* Abort the IRDA DMA Tx channel : use non blocking DMA Abort API (callback) */
    if (hirda->hdmatx != NULL)
    {
      /* Set the IRDA DMA Abort callback :
         will lead to call HAL_IRDA_AbortCpltCallback() at end of DMA abort procedure */
      hirda->hdmatx->XferAbortCallback = IRDA_DMATxOnlyAbortCallback;

      /* Abort DMA TX */
      if (HAL_DMA_Abort_IT(hirda->hdmatx) != HAL_OK)
      {
        /* Call Directly hirda->hdmatx->XferAbortCallback function in case of error */
        hirda->hdmatx->XferAbortCallback(hirda->hdmatx);
      }
    }
    else
    {
      /* Reset Tx transfer counter */
      hirda->TxXferCount = 0U;

      /* Restore hirda->gState to Ready */
      hirda->gState = HAL_IRDA_STATE_READY;

      /* As no DMA to be aborted, call directly user Abort complete callback */
#if (USE_HAL_IRDA_REGISTER_CALLBACKS == 1)
      /* Call registered Abort Transmit Complete Callback */
      hirda->AbortTransmitCpltCallback(hirda);
#else
      /* Call legacy weak Abort Transmit Complete Callback */
      HAL_IRDA_AbortTransmitCpltCallback(hirda);
#endif /* USE_HAL_IRDA_REGISTER_CALLBACK */
    }
  }
  else
#endif /* HAL_DMA_MODULE_ENABLED */
  {
    /* Reset Tx transfer counter */
    hirda->TxXferCount = 0U;

    /* Restore hirda->gState to Ready */
    hirda->gState = HAL_IRDA_STATE_READY;

    /* As no DMA to be aborted, call directly user Abort complete callback */
#if (USE_HAL_IRDA_REGISTER_CALLBACKS == 1)
    /* Call registered Abort Transmit Complete Callback */
    hirda->AbortTransmitCpltCallback(hirda);
#else
    /* Call legacy weak Abort Transmit Complete Callback */
    HAL_IRDA_AbortTransmitCpltCallback(hirda);
#endif /* USE_HAL_IRDA_REGISTER_CALLBACK */
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_IRDA_AbortReceive_IT(IRDA_HandleTypeDef *hirda)
{
  /* Disable RXNE, PE and ERR (Frame error, noise error, overrun error) interrupts */
  CLEAR_BIT(hirda->Instance->CR1, (USART_CR1_RXNEIE_RXFNEIE | USART_CR1_PEIE));
  CLEAR_BIT(hirda->Instance->CR3, USART_CR3_EIE);

#if defined(HAL_DMA_MODULE_ENABLED)
  /* Disable the IRDA DMA Rx request if enabled */
  if (HAL_IS_BIT_SET(hirda->Instance->CR3, USART_CR3_DMAR))
  {
    CLEAR_BIT(hirda->Instance->CR3, USART_CR3_DMAR);

    /* Abort the IRDA DMA Rx channel : use non blocking DMA Abort API (callback) */
    if (hirda->hdmarx != NULL)
    {
      /* Set the IRDA DMA Abort callback :
         will lead to call HAL_IRDA_AbortCpltCallback() at end of DMA abort procedure */
      hirda->hdmarx->XferAbortCallback = IRDA_DMARxOnlyAbortCallback;

      /* Abort DMA RX */
      if (HAL_DMA_Abort_IT(hirda->hdmarx) != HAL_OK)
      {
        /* Call Directly hirda->hdmarx->XferAbortCallback function in case of error */
        hirda->hdmarx->XferAbortCallback(hirda->hdmarx);
      }
    }
    else
    {
      /* Reset Rx transfer counter */
      hirda->RxXferCount = 0U;

      /* Clear the Error flags in the ICR register */
      __HAL_IRDA_CLEAR_FLAG(hirda, IRDA_CLEAR_OREF | IRDA_CLEAR_NEF | IRDA_CLEAR_PEF | IRDA_CLEAR_FEF);

      /* Restore hirda->RxState to Ready */
      hirda->RxState = HAL_IRDA_STATE_READY;

      /* As no DMA to be aborted, call directly user Abort complete callback */
#if (USE_HAL_IRDA_REGISTER_CALLBACKS == 1)
      /* Call registered Abort Receive Complete Callback */
      hirda->AbortReceiveCpltCallback(hirda);
#else
      /* Call legacy weak Abort Receive Complete Callback */
      HAL_IRDA_AbortReceiveCpltCallback(hirda);
#endif /* USE_HAL_IRDA_REGISTER_CALLBACK */
    }
  }
  else
#endif /* HAL_DMA_MODULE_ENABLED */
  {
    /* Reset Rx transfer counter */
    hirda->RxXferCount = 0U;

    /* Clear the Error flags in the ICR register */
    __HAL_IRDA_CLEAR_FLAG(hirda, IRDA_CLEAR_OREF | IRDA_CLEAR_NEF | IRDA_CLEAR_PEF | IRDA_CLEAR_FEF);

    /* Restore hirda->RxState to Ready */
    hirda->RxState = HAL_IRDA_STATE_READY;

    /* As no DMA to be aborted, call directly user Abort complete callback */
#if (USE_HAL_IRDA_REGISTER_CALLBACKS == 1)
    /* Call registered Abort Receive Complete Callback */
    hirda->AbortReceiveCpltCallback(hirda);
#else
    /* Call legacy weak Abort Receive Complete Callback */
    HAL_IRDA_AbortReceiveCpltCallback(hirda);
#endif /* USE_HAL_IRDA_REGISTER_CALLBACK */
  }

  return HAL_OK;
}

void HAL_IRDA_IRQHandler(IRDA_HandleTypeDef *hirda)
{
  uint32_t isrflags   = READ_REG(hirda->Instance->ISR);
  uint32_t cr1its     = READ_REG(hirda->Instance->CR1);
  uint32_t cr3its;
  uint32_t errorflags;
  uint32_t errorcode;

  /* If no error occurs */
  errorflags = (isrflags & (uint32_t)(USART_ISR_PE | USART_ISR_FE | USART_ISR_ORE | USART_ISR_NE));
  if (errorflags == 0U)
  {
    /* IRDA in mode Receiver ---------------------------------------------------*/
    if (((isrflags & USART_ISR_RXNE_RXFNE) != 0U) && ((cr1its & USART_CR1_RXNEIE_RXFNEIE) != 0U))
    {
      IRDA_Receive_IT(hirda);
      return;
    }
  }

  /* If some errors occur */
  cr3its = READ_REG(hirda->Instance->CR3);
  if ((errorflags != 0U)
      && (((cr3its & USART_CR3_EIE) != 0U)
          || ((cr1its & (USART_CR1_RXNEIE_RXFNEIE | USART_CR1_PEIE)) != 0U)))
  {
    /* IRDA parity error interrupt occurred -------------------------------------*/
    if (((isrflags & USART_ISR_PE) != 0U) && ((cr1its & USART_CR1_PEIE) != 0U))
    {
      __HAL_IRDA_CLEAR_IT(hirda, IRDA_CLEAR_PEF);

      hirda->ErrorCode |= HAL_IRDA_ERROR_PE;
    }

    /* IRDA frame error interrupt occurred --------------------------------------*/
    if (((isrflags & USART_ISR_FE) != 0U) && ((cr3its & USART_CR3_EIE) != 0U))
    {
      __HAL_IRDA_CLEAR_IT(hirda, IRDA_CLEAR_FEF);

      hirda->ErrorCode |= HAL_IRDA_ERROR_FE;
    }

    /* IRDA noise error interrupt occurred --------------------------------------*/
    if (((isrflags & USART_ISR_NE) != 0U) && ((cr3its & USART_CR3_EIE) != 0U))
    {
      __HAL_IRDA_CLEAR_IT(hirda, IRDA_CLEAR_NEF);

      hirda->ErrorCode |= HAL_IRDA_ERROR_NE;
    }

    /* IRDA Over-Run interrupt occurred -----------------------------------------*/
    if (((isrflags & USART_ISR_ORE) != 0U) &&
        (((cr1its & USART_CR1_RXNEIE_RXFNEIE) != 0U) || ((cr3its & USART_CR3_EIE) != 0U)))
    {
      __HAL_IRDA_CLEAR_IT(hirda, IRDA_CLEAR_OREF);

      hirda->ErrorCode |= HAL_IRDA_ERROR_ORE;
    }

    /* Call IRDA Error Call back function if need be --------------------------*/
    if (hirda->ErrorCode != HAL_IRDA_ERROR_NONE)
    {
      /* IRDA in mode Receiver ---------------------------------------------------*/
      if (((isrflags & USART_ISR_RXNE_RXFNE) != 0U) && ((cr1its & USART_CR1_RXNEIE_RXFNEIE) != 0U))
      {
        IRDA_Receive_IT(hirda);
      }

      /* If Overrun error occurs, or if any error occurs in DMA mode reception,
         consider error as blocking */
      errorcode = hirda->ErrorCode;
      if ((HAL_IS_BIT_SET(hirda->Instance->CR3, USART_CR3_DMAR)) ||
          ((errorcode & HAL_IRDA_ERROR_ORE) != 0U))
      {
        /* Blocking error : transfer is aborted
           Set the IRDA state ready to be able to start again the process,
           Disable Rx Interrupts, and disable Rx DMA request, if ongoing */
        IRDA_EndRxTransfer(hirda);

#if defined(HAL_DMA_MODULE_ENABLED)
        /* Disable the IRDA DMA Rx request if enabled */
        if (HAL_IS_BIT_SET(hirda->Instance->CR3, USART_CR3_DMAR))
        {
          CLEAR_BIT(hirda->Instance->CR3, USART_CR3_DMAR);

          /* Abort the IRDA DMA Rx channel */
          if (hirda->hdmarx != NULL)
          {
            /* Set the IRDA DMA Abort callback :
               will lead to call HAL_IRDA_ErrorCallback() at end of DMA abort procedure */
            hirda->hdmarx->XferAbortCallback = IRDA_DMAAbortOnError;

            /* Abort DMA RX */
            if (HAL_DMA_Abort_IT(hirda->hdmarx) != HAL_OK)
            {
              /* Call Directly hirda->hdmarx->XferAbortCallback function in case of error */
              hirda->hdmarx->XferAbortCallback(hirda->hdmarx);
            }
          }
          else
          {
#if (USE_HAL_IRDA_REGISTER_CALLBACKS == 1)
            /* Call registered user error callback */
            hirda->ErrorCallback(hirda);
#else
            /* Call legacy weak user error callback */
            HAL_IRDA_ErrorCallback(hirda);
#endif /* USE_HAL_IRDA_REGISTER_CALLBACK */
          }
        }
        else
#endif /* HAL_DMA_MODULE_ENABLED */
        {
#if (USE_HAL_IRDA_REGISTER_CALLBACKS == 1)
          /* Call registered user error callback */
          hirda->ErrorCallback(hirda);
#else
          /* Call legacy weak user error callback */
          HAL_IRDA_ErrorCallback(hirda);
#endif /* USE_HAL_IRDA_REGISTER_CALLBACK */
        }
      }
      else
      {
        /* Non Blocking error : transfer could go on.
           Error is notified to user through user error callback */
#if (USE_HAL_IRDA_REGISTER_CALLBACKS == 1)
        /* Call registered user error callback */
        hirda->ErrorCallback(hirda);
#else
        /* Call legacy weak user error callback */
        HAL_IRDA_ErrorCallback(hirda);
#endif /* USE_HAL_IRDA_REGISTER_CALLBACK */
        hirda->ErrorCode = HAL_IRDA_ERROR_NONE;
      }
    }
    return;

  } /* End if some error occurs */

  /* IRDA in mode Transmitter ------------------------------------------------*/
  if (((isrflags & USART_ISR_TXE_TXFNF) != 0U) && ((cr1its & USART_CR1_TXEIE_TXFNFIE) != 0U))
  {
    IRDA_Transmit_IT(hirda);
    return;
  }

  /* IRDA in mode Transmitter (transmission end) -----------------------------*/
  if (((isrflags & USART_ISR_TC) != 0U) && ((cr1its & USART_CR1_TCIE) != 0U))
  {
    IRDA_EndTransmit_IT(hirda);
    return;
  }

}

HAL_IRDA_StateTypeDef HAL_IRDA_GetState(const IRDA_HandleTypeDef *hirda)
{
  /* Return IRDA handle state */
  uint32_t temp1;
  uint32_t temp2;
  temp1 = (uint32_t)hirda->gState;
  temp2 = (uint32_t)hirda->RxState;

  return (HAL_IRDA_StateTypeDef)(temp1 | temp2);
}

uint32_t HAL_IRDA_GetError(const IRDA_HandleTypeDef *hirda)
{
  return hirda->ErrorCode;
}

#if F_MODE
void IRDA_InitCallbacksToDefault(IRDA_HandleTypeDef *hirda)
{
  /* Init the IRDA Callback settings */
  hirda->TxHalfCpltCallback        = HAL_IRDA_TxHalfCpltCallback;        /* Legacy weak TxHalfCpltCallback        */
  hirda->TxCpltCallback            = HAL_IRDA_TxCpltCallback;            /* Legacy weak TxCpltCallback            */
  hirda->RxHalfCpltCallback        = HAL_IRDA_RxHalfCpltCallback;        /* Legacy weak RxHalfCpltCallback        */
  hirda->RxCpltCallback            = HAL_IRDA_RxCpltCallback;            /* Legacy weak RxCpltCallback            */
  hirda->ErrorCallback             = HAL_IRDA_ErrorCallback;             /* Legacy weak ErrorCallback             */
  hirda->AbortCpltCallback         = HAL_IRDA_AbortCpltCallback;         /* Legacy weak AbortCpltCallback         */
  hirda->AbortTransmitCpltCallback = HAL_IRDA_AbortTransmitCpltCallback; /* Legacy weak AbortTransmitCpltCallback */
  hirda->AbortReceiveCpltCallback  = HAL_IRDA_AbortReceiveCpltCallback;  /* Legacy weak AbortReceiveCpltCallback  */

}
#endif

static HAL_StatusTypeDef IRDA_SetConfig(IRDA_HandleTypeDef *hirda)
{
  uint32_t tmpreg;
  IRDA_ClockSourceTypeDef clocksource;
  HAL_StatusTypeDef ret = HAL_OK;
  static const uint16_t IRDAPrescTable[12] = {1U, 2U, 4U, 6U, 8U, 10U, 12U, 16U, 32U, 64U, 128U, 256U};
  uint32_t pclk;

  /* Check the communication parameters */
  assert_param(IS_IRDA_BAUDRATE(hirda->Init.BaudRate));
  assert_param(IS_IRDA_WORD_LENGTH(hirda->Init.WordLength));
  assert_param(IS_IRDA_PARITY(hirda->Init.Parity));
  assert_param(IS_IRDA_TX_RX_MODE(hirda->Init.Mode));
  assert_param(IS_IRDA_PRESCALER(hirda->Init.Prescaler));
  assert_param(IS_IRDA_POWERMODE(hirda->Init.PowerMode));
  assert_param(IS_IRDA_CLOCKPRESCALER(hirda->Init.ClockPrescaler));

  /*-------------------------- USART CR1 Configuration -----------------------*/
  /* Configure the IRDA Word Length, Parity and transfer Mode:
     Set the M bits according to hirda->Init.WordLength value
     Set PCE and PS bits according to hirda->Init.Parity value
     Set TE and RE bits according to hirda->Init.Mode value */
  tmpreg = (uint32_t)hirda->Init.WordLength | hirda->Init.Parity | hirda->Init.Mode ;

  MODIFY_REG(hirda->Instance->CR1, IRDA_CR1_FIELDS, tmpreg);

  /*-------------------------- USART CR3 Configuration -----------------------*/
  MODIFY_REG(hirda->Instance->CR3, USART_CR3_IRLP, hirda->Init.PowerMode);

  /*--------------------- USART clock PRESC Configuration ----------------*/
  /* Configure
  * - IRDA Clock Prescaler: set PRESCALER according to hirda->Init.ClockPrescaler value */
  MODIFY_REG(hirda->Instance->PRESC, USART_PRESC_PRESCALER, hirda->Init.ClockPrescaler);

  /*-------------------------- USART GTPR Configuration ----------------------*/
  MODIFY_REG(hirda->Instance->GTPR, (uint16_t)USART_GTPR_PSC, (uint16_t)hirda->Init.Prescaler);

  /*-------------------------- USART BRR Configuration -----------------------*/
  IRDA_GETCLOCKSOURCE(hirda, clocksource);
  tmpreg =   0U;
  switch (clocksource)
  {
    case IRDA_CLOCKSOURCE_PLL2Q:
      pclk = HAL_RCC_GetPLL2QFreq();
      tmpreg = (uint32_t)(IRDA_DIV_SAMPLING16(pclk, hirda->Init.BaudRate, hirda->Init.ClockPrescaler));
      break;
    case IRDA_CLOCKSOURCE_PLL3Q:
      pclk = HAL_RCC_GetPLL3QFreq();
      tmpreg = (uint32_t)(IRDA_DIV_SAMPLING16(pclk, hirda->Init.BaudRate, hirda->Init.ClockPrescaler));
      break;
    case IRDA_CLOCKSOURCE_CSI:
      tmpreg = (uint32_t)(IRDA_DIV_SAMPLING16(CSI_VALUE, hirda->Init.BaudRate, hirda->Init.ClockPrescaler));
      break;
    case IRDA_CLOCKSOURCE_PCLK1:
      pclk = HAL_RCC_GetPCLK1Freq();
      tmpreg = (uint32_t)(IRDA_DIV_SAMPLING16(pclk, hirda->Init.BaudRate, hirda->Init.ClockPrescaler));
      break;
    case IRDA_CLOCKSOURCE_PCLK2:
      pclk = HAL_RCC_GetPCLK2Freq();
      tmpreg = (uint32_t)(IRDA_DIV_SAMPLING16(pclk, hirda->Init.BaudRate, hirda->Init.ClockPrescaler));
      break;
    case IRDA_CLOCKSOURCE_HSI:
      tmpreg = (uint32_t)(IRDA_DIV_SAMPLING16(HSI_VALUE, hirda->Init.BaudRate, hirda->Init.ClockPrescaler));
      break;
    case IRDA_CLOCKSOURCE_LSE:
      tmpreg = (uint32_t)(IRDA_DIV_SAMPLING16((uint32_t)LSE_VALUE, hirda->Init.BaudRate, hirda->Init.ClockPrescaler));
      break;
    default:
      ret = HAL_ERROR;
      break;
  }

  /* USARTDIV must be greater than or equal to 0d16 */
  if ((tmpreg >= USART_BRR_MIN) && (tmpreg <= USART_BRR_MAX))
  {
    hirda->Instance->BRR = (uint16_t)tmpreg;
  }
  else
  {
    ret = HAL_ERROR;
  }

  return ret;
}

static HAL_StatusTypeDef IRDA_CheckIdleState(IRDA_HandleTypeDef *hirda)
{
  uint32_t tickstart;

  /* Initialize the IRDA ErrorCode */
  hirda->ErrorCode = HAL_IRDA_ERROR_NONE;

  /* Init tickstart for timeout management */
  tickstart = HAL_GetTick();

  /* Check if the Transmitter is enabled */
  if ((hirda->Instance->CR1 & USART_CR1_TE) == USART_CR1_TE)
  {
    /* Wait until TEACK flag is set */
    if (IRDA_WaitOnFlagUntilTimeout(hirda, USART_ISR_TEACK, RESET, tickstart, IRDA_TEACK_REACK_TIMEOUT) != HAL_OK)
    {
      /* Timeout occurred */
      return HAL_TIMEOUT;
    }
  }
  /* Check if the Receiver is enabled */
  if ((hirda->Instance->CR1 & USART_CR1_RE) == USART_CR1_RE)
  {
    /* Wait until REACK flag is set */
    if (IRDA_WaitOnFlagUntilTimeout(hirda, USART_ISR_REACK, RESET, tickstart, IRDA_TEACK_REACK_TIMEOUT) != HAL_OK)
    {
      /* Timeout occurred */
      return HAL_TIMEOUT;
    }
  }

  /* Initialize the IRDA state*/
  hirda->gState  = HAL_IRDA_STATE_READY;
  hirda->RxState = HAL_IRDA_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(hirda);

  return HAL_OK;
}

static HAL_StatusTypeDef IRDA_WaitOnFlagUntilTimeout(IRDA_HandleTypeDef *hirda, uint32_t Flag, FlagStatus Status,
                                                     uint32_t Tickstart, uint32_t Timeout)
{
  /* Wait until flag is set */
  while ((__HAL_IRDA_GET_FLAG(hirda, Flag) ? SET : RESET) == Status)
  {
    /* Check for the Timeout */
    if (Timeout != HAL_MAX_DELAY)
    {
      if (((HAL_GetTick() - Tickstart) > Timeout) || (Timeout == 0U))
      {
        /* Disable TXE, RXNE, PE and ERR (Frame error, noise error, overrun error)
           interrupts for the interrupt process */
        CLEAR_BIT(hirda->Instance->CR1, (USART_CR1_RXNEIE_RXFNEIE | USART_CR1_PEIE | USART_CR1_TXEIE_TXFNFIE));
        CLEAR_BIT(hirda->Instance->CR3, USART_CR3_EIE);

        hirda->gState  = HAL_IRDA_STATE_READY;
        hirda->RxState = HAL_IRDA_STATE_READY;

        /* Process Unlocked */
        __HAL_UNLOCK(hirda);
        return HAL_TIMEOUT;
      }
    }
  }
  return HAL_OK;
}

static void IRDA_EndTxTransfer(IRDA_HandleTypeDef *hirda)
{
  /* Disable TXEIE and TCIE interrupts */
  CLEAR_BIT(hirda->Instance->CR1, (USART_CR1_TXEIE_TXFNFIE | USART_CR1_TCIE));

  /* At end of Tx process, restore hirda->gState to Ready */
  hirda->gState = HAL_IRDA_STATE_READY;
}

static void IRDA_EndRxTransfer(IRDA_HandleTypeDef *hirda)
{
  /* Disable RXNE, PE and ERR (Frame error, noise error, overrun error) interrupts */
  CLEAR_BIT(hirda->Instance->CR1, (USART_CR1_RXNEIE_RXFNEIE | USART_CR1_PEIE));
  CLEAR_BIT(hirda->Instance->CR3, USART_CR3_EIE);

  /* At end of Rx process, restore hirda->RxState to Ready */
  hirda->RxState = HAL_IRDA_STATE_READY;
}

static void IRDA_DMATransmitCplt(DMA_HandleTypeDef *hdma)
{
  IRDA_HandleTypeDef *hirda = (IRDA_HandleTypeDef *)(hdma->Parent);

  /* DMA Normal mode */
  if (hdma->Mode != DMA_LINKEDLIST_CIRCULAR)
  {
    hirda->TxXferCount = 0U;

    /* Disable the DMA transfer for transmit request by resetting the DMAT bit
       in the IRDA CR3 register */
    CLEAR_BIT(hirda->Instance->CR3, USART_CR3_DMAT);

    /* Enable the IRDA Transmit Complete Interrupt */
    SET_BIT(hirda->Instance->CR1, USART_CR1_TCIE);
  }
  /* DMA Circular mode */
  else
  {
#if (USE_HAL_IRDA_REGISTER_CALLBACKS == 1)
    /* Call registered Tx complete callback */
    hirda->TxCpltCallback(hirda);
#else
    /* Call legacy weak Tx complete callback */
    HAL_IRDA_TxCpltCallback(hirda);
#endif /* USE_HAL_IRDA_REGISTER_CALLBACK */
  }

}

static void IRDA_DMATransmitHalfCplt(DMA_HandleTypeDef *hdma)
{
  IRDA_HandleTypeDef *hirda = (IRDA_HandleTypeDef *)(hdma->Parent);

#if (USE_HAL_IRDA_REGISTER_CALLBACKS == 1)
  /* Call registered Tx Half complete callback */
  hirda->TxHalfCpltCallback(hirda);
#else
  /* Call legacy weak Tx complete callback */
  HAL_IRDA_TxHalfCpltCallback(hirda);
#endif /* USE_HAL_IRDA_REGISTER_CALLBACK */
}

static void IRDA_DMAReceiveCplt(DMA_HandleTypeDef *hdma)
{
  IRDA_HandleTypeDef *hirda = (IRDA_HandleTypeDef *)(hdma->Parent);

  /* DMA Normal mode */
  if (hdma->Mode != DMA_LINKEDLIST_CIRCULAR)
  {
    hirda->RxXferCount = 0U;

    /* Disable PE and ERR (Frame error, noise error, overrun error) interrupts */
    CLEAR_BIT(hirda->Instance->CR1, USART_CR1_PEIE);
    CLEAR_BIT(hirda->Instance->CR3, USART_CR3_EIE);

    /* Disable the DMA transfer for the receiver request by resetting the DMAR bit
       in the IRDA CR3 register */
    CLEAR_BIT(hirda->Instance->CR3, USART_CR3_DMAR);

    /* At end of Rx process, restore hirda->RxState to Ready */
    hirda->RxState = HAL_IRDA_STATE_READY;
  }

#if (USE_HAL_IRDA_REGISTER_CALLBACKS == 1)
  /* Call registered Rx complete callback */
  hirda->RxCpltCallback(hirda);
#else
  /* Call legacy weak Rx complete callback */
  HAL_IRDA_RxCpltCallback(hirda);
#endif /* USE_HAL_IRDA_REGISTER_CALLBACKS */
}

static void IRDA_DMAReceiveHalfCplt(DMA_HandleTypeDef *hdma)
{
  IRDA_HandleTypeDef *hirda = (IRDA_HandleTypeDef *)(hdma->Parent);

#if (USE_HAL_IRDA_REGISTER_CALLBACKS == 1)
  /*Call registered Rx Half complete callback*/
  hirda->RxHalfCpltCallback(hirda);
#else
  /* Call legacy weak Rx Half complete callback */
  HAL_IRDA_RxHalfCpltCallback(hirda);
#endif /* USE_HAL_IRDA_REGISTER_CALLBACK */
}

static void IRDA_DMAError(DMA_HandleTypeDef *hdma)
{
  IRDA_HandleTypeDef *hirda = (IRDA_HandleTypeDef *)(hdma->Parent);

  /* Stop IRDA DMA Tx request if ongoing */
  if (hirda->gState == HAL_IRDA_STATE_BUSY_TX)
  {
    if (HAL_IS_BIT_SET(hirda->Instance->CR3, USART_CR3_DMAT))
    {
      hirda->TxXferCount = 0U;
      IRDA_EndTxTransfer(hirda);
    }
  }

  /* Stop IRDA DMA Rx request if ongoing */
  if (hirda->RxState == HAL_IRDA_STATE_BUSY_RX)
  {
    if (HAL_IS_BIT_SET(hirda->Instance->CR3, USART_CR3_DMAR))
    {
      hirda->RxXferCount = 0U;
      IRDA_EndRxTransfer(hirda);
    }
  }

  hirda->ErrorCode |= HAL_IRDA_ERROR_DMA;
#if (USE_HAL_IRDA_REGISTER_CALLBACKS == 1)
  /* Call registered user error callback */
  hirda->ErrorCallback(hirda);
#else
  /* Call legacy weak user error callback */
  HAL_IRDA_ErrorCallback(hirda);
#endif /* USE_HAL_IRDA_REGISTER_CALLBACK */
}

static void IRDA_DMAAbortOnError(DMA_HandleTypeDef *hdma)
{
  IRDA_HandleTypeDef *hirda = (IRDA_HandleTypeDef *)(hdma->Parent);
  hirda->RxXferCount = 0U;
  hirda->TxXferCount = 0U;

#if (USE_HAL_IRDA_REGISTER_CALLBACKS == 1)
  /* Call registered user error callback */
  hirda->ErrorCallback(hirda);
#else
  /* Call legacy weak user error callback */
  HAL_IRDA_ErrorCallback(hirda);
#endif /* USE_HAL_IRDA_REGISTER_CALLBACK */
}

static void IRDA_DMATxAbortCallback(DMA_HandleTypeDef *hdma)
{
  IRDA_HandleTypeDef *hirda = (IRDA_HandleTypeDef *)(hdma->Parent);

  hirda->hdmatx->XferAbortCallback = NULL;

  /* Check if an Abort process is still ongoing */
  if (hirda->hdmarx != NULL)
  {
    if (hirda->hdmarx->XferAbortCallback != NULL)
    {
      return;
    }
  }

  /* No Abort process still ongoing : All DMA channels are aborted, call user Abort Complete callback */
  hirda->TxXferCount = 0U;
  hirda->RxXferCount = 0U;

  /* Reset errorCode */
  hirda->ErrorCode = HAL_IRDA_ERROR_NONE;

  /* Clear the Error flags in the ICR register */
  __HAL_IRDA_CLEAR_FLAG(hirda, IRDA_CLEAR_OREF | IRDA_CLEAR_NEF | IRDA_CLEAR_PEF | IRDA_CLEAR_FEF);

  /* Restore hirda->gState and hirda->RxState to Ready */
  hirda->gState  = HAL_IRDA_STATE_READY;
  hirda->RxState = HAL_IRDA_STATE_READY;

  /* Call user Abort complete callback */
#if (USE_HAL_IRDA_REGISTER_CALLBACKS == 1)
  /* Call registered Abort complete callback */
  hirda->AbortCpltCallback(hirda);
#else
  /* Call legacy weak Abort complete callback */
  HAL_IRDA_AbortCpltCallback(hirda);
#endif /* USE_HAL_IRDA_REGISTER_CALLBACK */
}

static void IRDA_DMARxAbortCallback(DMA_HandleTypeDef *hdma)
{
  IRDA_HandleTypeDef *hirda = (IRDA_HandleTypeDef *)(hdma->Parent);

  hirda->hdmarx->XferAbortCallback = NULL;

  /* Check if an Abort process is still ongoing */
  if (hirda->hdmatx != NULL)
  {
    if (hirda->hdmatx->XferAbortCallback != NULL)
    {
      return;
    }
  }

  /* No Abort process still ongoing : All DMA channels are aborted, call user Abort Complete callback */
  hirda->TxXferCount = 0U;
  hirda->RxXferCount = 0U;

  /* Reset errorCode */
  hirda->ErrorCode = HAL_IRDA_ERROR_NONE;

  /* Clear the Error flags in the ICR register */
  __HAL_IRDA_CLEAR_FLAG(hirda, IRDA_CLEAR_OREF | IRDA_CLEAR_NEF | IRDA_CLEAR_PEF | IRDA_CLEAR_FEF);

  /* Restore hirda->gState and hirda->RxState to Ready */
  hirda->gState  = HAL_IRDA_STATE_READY;
  hirda->RxState = HAL_IRDA_STATE_READY;

  /* Call user Abort complete callback */
#if (USE_HAL_IRDA_REGISTER_CALLBACKS == 1)
  /* Call registered Abort complete callback */
  hirda->AbortCpltCallback(hirda);
#else
  /* Call legacy weak Abort complete callback */
  HAL_IRDA_AbortCpltCallback(hirda);
#endif /* USE_HAL_IRDA_REGISTER_CALLBACK */
}

static void IRDA_DMATxOnlyAbortCallback(DMA_HandleTypeDef *hdma)
{
  IRDA_HandleTypeDef *hirda = (IRDA_HandleTypeDef *)(hdma->Parent);

  hirda->TxXferCount = 0U;

  /* Restore hirda->gState to Ready */
  hirda->gState = HAL_IRDA_STATE_READY;

  /* Call user Abort complete callback */
#if (USE_HAL_IRDA_REGISTER_CALLBACKS == 1)
  /* Call registered Abort Transmit Complete Callback */
  hirda->AbortTransmitCpltCallback(hirda);
#else
  /* Call legacy weak Abort Transmit Complete Callback */
  HAL_IRDA_AbortTransmitCpltCallback(hirda);
#endif /* USE_HAL_IRDA_REGISTER_CALLBACK */
}

static void IRDA_DMARxOnlyAbortCallback(DMA_HandleTypeDef *hdma)
{
  IRDA_HandleTypeDef *hirda = (IRDA_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  hirda->RxXferCount = 0U;

  /* Clear the Error flags in the ICR register */
  __HAL_IRDA_CLEAR_FLAG(hirda, IRDA_CLEAR_OREF | IRDA_CLEAR_NEF | IRDA_CLEAR_PEF | IRDA_CLEAR_FEF);

  /* Restore hirda->RxState to Ready */
  hirda->RxState = HAL_IRDA_STATE_READY;

  /* Call user Abort complete callback */
#if (USE_HAL_IRDA_REGISTER_CALLBACKS == 1)
  /* Call registered Abort Receive Complete Callback */
  hirda->AbortReceiveCpltCallback(hirda);
#else
  /* Call legacy weak Abort Receive Complete Callback */
  HAL_IRDA_AbortReceiveCpltCallback(hirda);
#endif /* USE_HAL_IRDA_REGISTER_CALLBACK */
}

static void IRDA_Transmit_IT(IRDA_HandleTypeDef *hirda)
{
  const uint16_t *tmp;

  /* Check that a Tx process is ongoing */
  if (hirda->gState == HAL_IRDA_STATE_BUSY_TX)
  {
    if (hirda->TxXferCount == 0U)
    {
      /* Disable the IRDA Transmit Data Register Empty Interrupt */
      CLEAR_BIT(hirda->Instance->CR1, USART_CR1_TXEIE_TXFNFIE);

      /* Enable the IRDA Transmit Complete Interrupt */
      SET_BIT(hirda->Instance->CR1, USART_CR1_TCIE);
    }
    else
    {
      if ((hirda->Init.WordLength == IRDA_WORDLENGTH_9B) && (hirda->Init.Parity == IRDA_PARITY_NONE))
      {
        tmp = (const uint16_t *) hirda->pTxBuffPtr; /* Derogation R.11.3 */
        hirda->Instance->TDR = (uint16_t)(*tmp & 0x01FFU);
        hirda->pTxBuffPtr += 2U;
      }
      else
      {
        hirda->Instance->TDR = (uint8_t)(*hirda->pTxBuffPtr & 0xFFU);
        hirda->pTxBuffPtr++;
      }
      hirda->TxXferCount--;
    }
  }
}

static void IRDA_EndTransmit_IT(IRDA_HandleTypeDef *hirda)
{
  /* Disable the IRDA Transmit Complete Interrupt */
  CLEAR_BIT(hirda->Instance->CR1, USART_CR1_TCIE);

  /* Tx process is ended, restore hirda->gState to Ready */
  hirda->gState = HAL_IRDA_STATE_READY;

#if (USE_HAL_IRDA_REGISTER_CALLBACKS == 1)
  /* Call registered Tx complete callback */
  hirda->TxCpltCallback(hirda);
#else
  /* Call legacy weak Tx complete callback */
  HAL_IRDA_TxCpltCallback(hirda);
#endif /* USE_HAL_IRDA_REGISTER_CALLBACK */
}

static void IRDA_Receive_IT(IRDA_HandleTypeDef *hirda)
{
  uint16_t *tmp;
  uint16_t  uhMask = hirda->Mask;
  uint16_t  uhdata;

  /* Check that a Rx process is ongoing */
  if (hirda->RxState == HAL_IRDA_STATE_BUSY_RX)
  {
    uhdata = (uint16_t) READ_REG(hirda->Instance->RDR);
    if ((hirda->Init.WordLength == IRDA_WORDLENGTH_9B) && (hirda->Init.Parity == IRDA_PARITY_NONE))
    {
      tmp = (uint16_t *) hirda->pRxBuffPtr; /* Derogation R.11.3 */
      *tmp = (uint16_t)(uhdata & uhMask);
      hirda->pRxBuffPtr  += 2U;
    }
    else
    {
      *hirda->pRxBuffPtr = (uint8_t)(uhdata & (uint8_t)uhMask);
      hirda->pRxBuffPtr++;
    }

    hirda->RxXferCount--;
    if (hirda->RxXferCount == 0U)
    {
      /* Disable the IRDA Parity Error Interrupt and RXNE interrupt */
      CLEAR_BIT(hirda->Instance->CR1, (USART_CR1_RXNEIE_RXFNEIE | USART_CR1_PEIE));

      /* Disable the IRDA Error Interrupt: (Frame error, noise error, overrun error) */
      CLEAR_BIT(hirda->Instance->CR3, USART_CR3_EIE);

      /* Rx process is completed, restore hirda->RxState to Ready */
      hirda->RxState = HAL_IRDA_STATE_READY;

#if (USE_HAL_IRDA_REGISTER_CALLBACKS == 1)
      /* Call registered Rx complete callback */
      hirda->RxCpltCallback(hirda);
#else
      /* Call legacy weak Rx complete callback */
      HAL_IRDA_RxCpltCallback(hirda);
#endif /* USE_HAL_IRDA_REGISTER_CALLBACKS */
    }
  }
  else
  {
    /* Clear RXNE interrupt flag */
    __HAL_IRDA_SEND_REQ(hirda, IRDA_RXDATA_FLUSH_REQUEST);
  }
}
