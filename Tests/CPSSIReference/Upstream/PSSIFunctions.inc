/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * STM32H7RS HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
HAL_StatusTypeDef HAL_PSSI_Init(PSSI_HandleTypeDef *hpssi)
{
  /* Check the PSSI handle allocation */
  if (hpssi == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_PSSI_ALL_INSTANCE(hpssi->Instance));
  assert_param(IS_PSSI_CONTROL_SIGNAL(hpssi->Init.ControlSignal));
  assert_param(IS_PSSI_BUSWIDTH(hpssi->Init.BusWidth));
  assert_param(IS_PSSI_CLOCK_POLARITY(hpssi->Init.ClockPolarity));
  assert_param(IS_PSSI_DE_POLARITY(hpssi->Init.DataEnablePolarity));
  assert_param(IS_PSSI_RDY_POLARITY(hpssi->Init.ReadyPolarity));

  if (hpssi->State == HAL_PSSI_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    hpssi->Lock = HAL_UNLOCKED;

#if (USE_HAL_PSSI_REGISTER_CALLBACKS == 1)
    /* Init the PSSI Callback settings */
    hpssi->TxCpltCallback = HAL_PSSI_TxCpltCallback; /* Legacy weak TxCpltCallback */
    hpssi->RxCpltCallback = HAL_PSSI_RxCpltCallback; /* Legacy weak RxCpltCallback */
    hpssi->ErrorCallback        = HAL_PSSI_ErrorCallback;        /* Legacy weak ErrorCallback        */
    hpssi->AbortCpltCallback    = HAL_PSSI_AbortCpltCallback;    /* Legacy weak AbortCpltCallback    */

    if (hpssi->MspInitCallback == NULL)
    {
      hpssi->MspInitCallback = HAL_PSSI_MspInit; /* Legacy weak MspInit  */
    }

    /* Init the low level hardware : GPIO, CLOCK, CORTEX...etc */
    hpssi->MspInitCallback(hpssi);
#else
    /* Init the low level hardware : GPIO, CLOCK, CORTEX...etc */
    HAL_PSSI_MspInit(hpssi);
#endif /*USE_HAL_PSSI_REGISTER_CALLBACKS*/
  }

  hpssi->State = HAL_PSSI_STATE_BUSY;

  /* Disable the selected PSSI peripheral */
  HAL_PSSI_DISABLE(hpssi);

  /*---------------------------- PSSIx CR Configuration ----------------------*/
  /* Configure PSSIx: Control Signal and Bus Width*/

  MODIFY_REG(hpssi->Instance->CR, PSSI_CR_DERDYCFG | PSSI_CR_EDM | PSSI_CR_DEPOL | PSSI_CR_RDYPOL,
             hpssi->Init.ControlSignal | hpssi->Init.DataEnablePolarity |
             hpssi->Init.ReadyPolarity | hpssi->Init.BusWidth);

  hpssi->ErrorCode = HAL_PSSI_ERROR_NONE;
  hpssi->State = HAL_PSSI_STATE_READY;

  return HAL_OK;
}
HAL_StatusTypeDef HAL_PSSI_DeInit(PSSI_HandleTypeDef *hpssi)
{
  /* Check the PSSI handle allocation */
  if (hpssi == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_PSSI_ALL_INSTANCE(hpssi->Instance));

  hpssi->State = HAL_PSSI_STATE_BUSY;

  /* Disable the PSSI Peripheral Clock */
  HAL_PSSI_DISABLE(hpssi);

#if (USE_HAL_PSSI_REGISTER_CALLBACKS == 1)
  if (hpssi->MspDeInitCallback == NULL)
  {
    hpssi->MspDeInitCallback = HAL_PSSI_MspDeInit; /* Legacy weak MspDeInit  */
  }

  /* DeInit the low level hardware: GPIO, CLOCK, NVIC */
  hpssi->MspDeInitCallback(hpssi);
#else
  /* DeInit the low level hardware: GPIO, CLOCK, NVIC */
  HAL_PSSI_MspDeInit(hpssi);
#endif /*USE_HAL_PSSI_REGISTER_CALLBACKS*/

  hpssi->ErrorCode = HAL_PSSI_ERROR_NONE;
  hpssi->State = HAL_PSSI_STATE_RESET;

  /* Release Lock */
  __HAL_UNLOCK(hpssi);

  return HAL_OK;
}
#if P_MODE
HAL_StatusTypeDef HAL_PSSI_RegisterCallback(PSSI_HandleTypeDef *hpssi, HAL_PSSI_CallbackIDTypeDef CallbackID,
                                            pPSSI_CallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hpssi->ErrorCode |= HAL_PSSI_ERROR_INVALID_CALLBACK;

    return HAL_ERROR;
  }

  if (HAL_PSSI_STATE_READY == hpssi->State)
  {
    switch (CallbackID)
    {
      case HAL_PSSI_TX_COMPLETE_CB_ID :
        hpssi->TxCpltCallback = pCallback;
        break;

      case HAL_PSSI_RX_COMPLETE_CB_ID :
        hpssi->RxCpltCallback = pCallback;
        break;

      case HAL_PSSI_ERROR_CB_ID :
        hpssi->ErrorCallback = pCallback;
        break;

      case HAL_PSSI_ABORT_CB_ID :
        hpssi->AbortCpltCallback = pCallback;
        break;

      case HAL_PSSI_MSPINIT_CB_ID :
        hpssi->MspInitCallback = pCallback;
        break;

      case HAL_PSSI_MSPDEINIT_CB_ID :
        hpssi->MspDeInitCallback = pCallback;
        break;

      default :
        /* Update the error code */
        hpssi->ErrorCode |= HAL_PSSI_ERROR_INVALID_CALLBACK;

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (HAL_PSSI_STATE_RESET == hpssi->State)
  {
    switch (CallbackID)
    {
      case HAL_PSSI_MSPINIT_CB_ID :
        hpssi->MspInitCallback = pCallback;
        break;

      case HAL_PSSI_MSPDEINIT_CB_ID :
        hpssi->MspDeInitCallback = pCallback;
        break;

      default :
        /* Update the error code */
        hpssi->ErrorCode |= HAL_PSSI_ERROR_INVALID_CALLBACK;

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hpssi->ErrorCode |= HAL_PSSI_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif
#if P_MODE
HAL_StatusTypeDef HAL_PSSI_UnRegisterCallback(PSSI_HandleTypeDef *hpssi, HAL_PSSI_CallbackIDTypeDef CallbackID)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (HAL_PSSI_STATE_READY == hpssi->State)
  {
    switch (CallbackID)
    {
      case HAL_PSSI_TX_COMPLETE_CB_ID :
        hpssi->TxCpltCallback = HAL_PSSI_TxCpltCallback;             /* Legacy weak TxCpltCallback     */
        break;

      case HAL_PSSI_RX_COMPLETE_CB_ID :
        hpssi->RxCpltCallback = HAL_PSSI_RxCpltCallback;             /* Legacy weak RxCpltCallback     */
        break;

      case HAL_PSSI_ERROR_CB_ID :
        hpssi->ErrorCallback = HAL_PSSI_ErrorCallback;               /* Legacy weak ErrorCallback      */
        break;

      case HAL_PSSI_ABORT_CB_ID :
        hpssi->AbortCpltCallback = HAL_PSSI_AbortCpltCallback;       /* Legacy weak AbortCpltCallback  */
        break;

      case HAL_PSSI_MSPINIT_CB_ID :
        hpssi->MspInitCallback = HAL_PSSI_MspInit;                   /* Legacy weak MspInit            */
        break;

      case HAL_PSSI_MSPDEINIT_CB_ID :
        hpssi->MspDeInitCallback = HAL_PSSI_MspDeInit;               /* Legacy weak MspDeInit          */
        break;

      default :
        /* Update the error code */
        hpssi->ErrorCode |= HAL_PSSI_ERROR_INVALID_CALLBACK;

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (HAL_PSSI_STATE_RESET == hpssi->State)
  {
    switch (CallbackID)
    {
      case HAL_PSSI_MSPINIT_CB_ID :
        hpssi->MspInitCallback = HAL_PSSI_MspInit;                   /* Legacy weak MspInit            */
        break;

      case HAL_PSSI_MSPDEINIT_CB_ID :
        hpssi->MspDeInitCallback = HAL_PSSI_MspDeInit;               /* Legacy weak MspDeInit          */
        break;

      default :
        /* Update the error code */
        hpssi->ErrorCode |= HAL_PSSI_ERROR_INVALID_CALLBACK;

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hpssi->ErrorCode |= HAL_PSSI_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif
HAL_StatusTypeDef HAL_PSSI_Transmit(PSSI_HandleTypeDef *hpssi, uint8_t *pData, uint32_t Size, uint32_t Timeout)
{
  uint32_t tickstart;
  uint32_t  transfer_size = Size;

  if (((hpssi->Init.DataWidth == HAL_PSSI_8BITS) && (hpssi->Init.BusWidth != HAL_PSSI_8LINES)) ||
      ((hpssi->Init.DataWidth == HAL_PSSI_16BITS) && ((Size % 2U) != 0U)) ||
      ((hpssi->Init.DataWidth == HAL_PSSI_32BITS) && ((Size % 4U) != 0U)))
  {
    hpssi->ErrorCode = HAL_PSSI_ERROR_NOT_SUPPORTED;
    return HAL_ERROR;
  }
  if (hpssi->State == HAL_PSSI_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hpssi);

    hpssi->State     = HAL_PSSI_STATE_BUSY;
    hpssi->ErrorCode = HAL_PSSI_ERROR_NONE;

    /* Disable the selected PSSI peripheral */
    HAL_PSSI_DISABLE(hpssi);

    /* Configure transfer parameters */
    MODIFY_REG(hpssi->Instance->CR, (PSSI_CR_OUTEN | PSSI_CR_CKPOL),
               (PSSI_CR_OUTEN_OUTPUT | ((hpssi->Init.ClockPolarity == HAL_PSSI_RISING_EDGE) ? 0U : PSSI_CR_CKPOL)));

#if defined(HAL_DMA_MODULE_ENABLED)
    /* DMA Disable */
    hpssi->Instance->CR &= PSSI_CR_DMA_DISABLE;
#endif /*HAL_DMA_MODULE_ENABLED*/

    /* Enable the selected PSSI peripheral */
    HAL_PSSI_ENABLE(hpssi);

    if (hpssi->Init.DataWidth == HAL_PSSI_8BITS)
    {
      uint8_t *pbuffer = pData;
      while (transfer_size > 0U)
      {
        /* Init tickstart for timeout management*/
        tickstart = HAL_GetTick();
        /* Wait until Fifo is ready to transfer one byte flag is set */
        if (PSSI_WaitOnStatusUntilTimeout(hpssi, PSSI_FLAG_RTT1B, RESET, Timeout, tickstart) != HAL_OK)
        {
          hpssi->ErrorCode = HAL_PSSI_ERROR_TIMEOUT;
          hpssi->State = HAL_PSSI_STATE_READY;
          /* Process Unlocked */
          __HAL_UNLOCK(hpssi);
          return HAL_ERROR;
        }
        /* Write data to DR */
        *(__IO uint8_t *)(&hpssi->Instance->DR) = *(uint8_t *)pbuffer;

        /* Increment Buffer pointer */
        pbuffer++;

        transfer_size--;
      }
    }
    else if (hpssi->Init.DataWidth == HAL_PSSI_16BITS)
    {
      uint16_t *pbuffer = (uint16_t *)pData;
      __IO uint16_t *dr = (__IO uint16_t *)(&hpssi->Instance->DR);

      while (transfer_size > 0U)
      {
        /* Init tickstart for timeout management*/
        tickstart = HAL_GetTick();
        /* Wait until Fifo is ready to transfer four bytes flag is set */
        if (PSSI_WaitOnStatusUntilTimeout(hpssi, PSSI_FLAG_RTT4B, RESET, Timeout, tickstart) != HAL_OK)
        {
          hpssi->ErrorCode = HAL_PSSI_ERROR_TIMEOUT;
          hpssi->State = HAL_PSSI_STATE_READY;
          /* Process Unlocked */
          __HAL_UNLOCK(hpssi);
          return HAL_ERROR;
        }
        /* Write data to DR */
        *dr = *pbuffer;

        /* Increment Buffer pointer */
        pbuffer++;
        transfer_size -= 2U;
      }
    }
    else if (hpssi->Init.DataWidth == HAL_PSSI_32BITS)
    {
      uint32_t *pbuffer = (uint32_t *)pData;
      while (transfer_size > 0U)
      {
        /* Init tickstart for timeout management*/
        tickstart = HAL_GetTick();
        /* Wait until Fifo is ready to transfer four bytes flag is set */
        if (PSSI_WaitOnStatusUntilTimeout(hpssi, PSSI_FLAG_RTT4B, RESET, Timeout, tickstart) != HAL_OK)
        {
          hpssi->ErrorCode = HAL_PSSI_ERROR_TIMEOUT;
          hpssi->State = HAL_PSSI_STATE_READY;
          /* Process Unlocked */
          __HAL_UNLOCK(hpssi);
          return HAL_ERROR;
        }
        /* Write data to DR */
        *(__IO uint32_t *)(&hpssi->Instance->DR) = *pbuffer;

        /* Increment Buffer pointer */
        pbuffer++;
        transfer_size -= 4U;
      }
    }
    else
    {
      hpssi->ErrorCode = HAL_PSSI_ERROR_NOT_SUPPORTED;
      hpssi->State = HAL_PSSI_STATE_READY;
      /* Process Unlocked */
      __HAL_UNLOCK(hpssi);
      return HAL_ERROR;
    }

    /* Check Errors Flags */
    if (HAL_PSSI_GET_FLAG(hpssi, PSSI_FLAG_OVR_RIS) != 0U)
    {
      HAL_PSSI_CLEAR_FLAG(hpssi, PSSI_FLAG_OVR_RIS);
      HAL_PSSI_DISABLE(hpssi);
      hpssi->ErrorCode = HAL_PSSI_ERROR_UNDER_RUN;
      hpssi->State = HAL_PSSI_STATE_READY;
      /* Process Unlocked */
      __HAL_UNLOCK(hpssi);
      return HAL_ERROR;
    }

    hpssi->State = HAL_PSSI_STATE_READY;

    /* Process Unlocked */
    __HAL_UNLOCK(hpssi);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
HAL_StatusTypeDef HAL_PSSI_Receive(PSSI_HandleTypeDef *hpssi, uint8_t *pData, uint32_t Size, uint32_t Timeout)
{
  uint32_t tickstart;
  uint32_t  transfer_size = Size;

  if (((hpssi->Init.DataWidth == HAL_PSSI_8BITS) && (hpssi->Init.BusWidth != HAL_PSSI_8LINES)) ||
      ((hpssi->Init.DataWidth == HAL_PSSI_16BITS) && ((Size % 2U) != 0U)) ||
      ((hpssi->Init.DataWidth == HAL_PSSI_32BITS) && ((Size % 4U) != 0U)))
  {
    hpssi->ErrorCode = HAL_PSSI_ERROR_NOT_SUPPORTED;
    return HAL_ERROR;
  }

  if (hpssi->State == HAL_PSSI_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hpssi);

    hpssi->State     = HAL_PSSI_STATE_BUSY;
    hpssi->ErrorCode = HAL_PSSI_ERROR_NONE;

    /* Disable the selected PSSI peripheral */
    HAL_PSSI_DISABLE(hpssi);
    /* Configure transfer parameters */
    MODIFY_REG(hpssi->Instance->CR, (PSSI_CR_OUTEN | PSSI_CR_CKPOL),
               (PSSI_CR_OUTEN_INPUT | ((hpssi->Init.ClockPolarity == HAL_PSSI_FALLING_EDGE) ? 0U : PSSI_CR_CKPOL)));

#if defined(HAL_DMA_MODULE_ENABLED)
    /* DMA Disable */
    hpssi->Instance->CR &= PSSI_CR_DMA_DISABLE;
#endif /*HAL_DMA_MODULE_ENABLED*/

    /* Enable the selected PSSI peripheral */
    HAL_PSSI_ENABLE(hpssi);
    if (hpssi->Init.DataWidth == HAL_PSSI_8BITS)
    {
      uint8_t *pbuffer = pData;

      while (transfer_size > 0U)
      {
        /* Init tickstart for timeout management*/
        tickstart = HAL_GetTick();
        /* Wait until Fifo is ready to receive one byte flag is set */
        if (PSSI_WaitOnStatusUntilTimeout(hpssi, PSSI_FLAG_RTT1B, RESET, Timeout, tickstart) != HAL_OK)
        {
          hpssi->ErrorCode = HAL_PSSI_ERROR_TIMEOUT;
          hpssi->State = HAL_PSSI_STATE_READY;
          /* Process Unlocked */
          __HAL_UNLOCK(hpssi);
          return HAL_ERROR;
        }
        /* Read data from DR */
        *pbuffer = *(__IO uint8_t *)(&hpssi->Instance->DR);
        pbuffer++;
        transfer_size--;
      }
    }
    else if (hpssi->Init.DataWidth == HAL_PSSI_16BITS)
    {
      uint16_t *pbuffer = (uint16_t *)pData;
      __IO uint16_t *dr = (__IO uint16_t *)(&hpssi->Instance->DR);

      while (transfer_size > 0U)
      {
        /* Init tickstart for timeout management*/
        tickstart = HAL_GetTick();
        /* Wait until Fifo is ready to receive four bytes flag is set */
        if (PSSI_WaitOnStatusUntilTimeout(hpssi, PSSI_FLAG_RTT4B, RESET, Timeout, tickstart) != HAL_OK)
        {
          hpssi->ErrorCode = HAL_PSSI_ERROR_TIMEOUT;
          hpssi->State = HAL_PSSI_STATE_READY;
          /* Process Unlocked */
          __HAL_UNLOCK(hpssi);
          return HAL_ERROR;
        }

        /* Read data from DR */
        *pbuffer = *dr;
        pbuffer++;
        transfer_size -= 2U;
      }
    }
    else if (hpssi->Init.DataWidth == HAL_PSSI_32BITS)
    {
      uint32_t *pbuffer = (uint32_t *)pData;

      while (transfer_size > 0U)
      {
        /* Init tickstart for timeout management*/
        tickstart = HAL_GetTick();
        /* Wait until Fifo is ready to receive four bytes flag is set */
        if (PSSI_WaitOnStatusUntilTimeout(hpssi, PSSI_FLAG_RTT4B, RESET, Timeout, tickstart) != HAL_OK)
        {
          hpssi->ErrorCode = HAL_PSSI_ERROR_TIMEOUT;
          hpssi->State = HAL_PSSI_STATE_READY;
          /* Process Unlocked */
          __HAL_UNLOCK(hpssi);
          return HAL_ERROR;
        }

        /* Read data from DR */
        *pbuffer = *(__IO uint32_t *)(&hpssi->Instance->DR);
        pbuffer++;
        transfer_size -= 4U;
      }
    }
    else
    {
      hpssi->ErrorCode = HAL_PSSI_ERROR_NOT_SUPPORTED;
      hpssi->State = HAL_PSSI_STATE_READY;
      /* Process Unlocked */
      __HAL_UNLOCK(hpssi);
      return HAL_ERROR;
    }
    /* Check Errors Flags */

    if (HAL_PSSI_GET_FLAG(hpssi, PSSI_FLAG_OVR_RIS) != 0U)
    {
      HAL_PSSI_CLEAR_FLAG(hpssi, PSSI_FLAG_OVR_RIS);
      hpssi->ErrorCode = HAL_PSSI_ERROR_OVER_RUN;
      __HAL_UNLOCK(hpssi);
      return HAL_ERROR;
    }

    hpssi->State = HAL_PSSI_STATE_READY;

    /* Process Unlocked */
    __HAL_UNLOCK(hpssi);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#if P_DMA
HAL_StatusTypeDef HAL_PSSI_Transmit_DMA(PSSI_HandleTypeDef *hpssi, uint32_t *pData, uint32_t Size)
{
  HAL_StatusTypeDef dmaxferstatus;

  if (hpssi->State == HAL_PSSI_STATE_READY)
  {

    /* Process Locked */
    __HAL_LOCK(hpssi);

    hpssi->State       = HAL_PSSI_STATE_BUSY_TX;
    hpssi->ErrorCode   = HAL_PSSI_ERROR_NONE;

    /* Disable the selected PSSI peripheral */
    HAL_PSSI_DISABLE(hpssi);

    /* Prepare transfer parameters */
    hpssi->pBuffPtr    = pData;
    hpssi->XferCount   = Size;

    if (hpssi->XferCount > PSSI_MAX_NBYTE_SIZE)
    {
      hpssi->XferSize = PSSI_MAX_NBYTE_SIZE;
    }
    else
    {
      hpssi->XferSize = hpssi->XferCount;
    }

    if (hpssi->XferSize > 0U)
    {
      if (hpssi->hdmatx != NULL)
      {

        /* Configure BusWidth */
        if (hpssi->hdmatx->Init.DestDataWidth == DMA_DEST_DATAWIDTH_BYTE)
        {
          MODIFY_REG(hpssi->Instance->CR, PSSI_CR_DMAEN | PSSI_CR_OUTEN | PSSI_CR_CKPOL,
                     PSSI_CR_DMA_ENABLE | PSSI_CR_OUTEN_OUTPUT |
                     ((hpssi->Init.ClockPolarity == HAL_PSSI_RISING_EDGE) ? 0U : PSSI_CR_CKPOL));
        }
        else
        {
          MODIFY_REG(hpssi->Instance->CR, PSSI_CR_DMAEN | PSSI_CR_OUTEN | PSSI_CR_CKPOL,
                     PSSI_CR_DMA_ENABLE | hpssi->Init.BusWidth | PSSI_CR_OUTEN_OUTPUT |
                     ((hpssi->Init.ClockPolarity == HAL_PSSI_RISING_EDGE) ? 0U : PSSI_CR_CKPOL));
        }

        /* Set the PSSI DMA transfer complete callback */
        hpssi->hdmatx->XferCpltCallback = PSSI_DMATransmitCplt;

        /* Set the DMA error callback */
        hpssi->hdmatx->XferErrorCallback = PSSI_DMAError;

        /* Set the unused DMA callbacks to NULL */
        hpssi->hdmatx->XferHalfCpltCallback = NULL;
        hpssi->hdmatx->XferAbortCallback = NULL;

        /* Enable the DMA  */
        if ((hpssi->hdmatx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
        {
          if (hpssi->hdmatx->LinkedListQueue != NULL)
          {
            /* Enable the DMA channel */
            /* Set DMA data size */
            hpssi->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = hpssi->XferSize;
            /* Set DMA source address */
            hpssi->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = (uint32_t)pData;
            /* Set DMA destination address */
            hpssi->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] =
              (uint32_t)&hpssi->Instance->DR;

            dmaxferstatus = HAL_DMAEx_List_Start_IT(hpssi->hdmatx);
          }
          else
          {
            /* Return error status */
            return HAL_ERROR;
          }
        }
        else
        {
          dmaxferstatus = HAL_DMA_Start_IT(hpssi->hdmatx, (uint32_t)pData, (uint32_t)&hpssi->Instance->DR,
                                           hpssi->XferSize);
        }
      }
      else
      {
        /* Update PSSI state */
        hpssi->State     = HAL_PSSI_STATE_READY;

        /* Update PSSI error code */
        hpssi->ErrorCode |= HAL_PSSI_ERROR_DMA;

        /* Process Unlocked */
        __HAL_UNLOCK(hpssi);

        return HAL_ERROR;
      }

      if (dmaxferstatus == HAL_OK)
      {
        /* Update XferCount value */
        hpssi->XferCount -= hpssi->XferSize;

        /* Process Unlocked */
        __HAL_UNLOCK(hpssi);

        /* Note : The PSSI interrupts must be enabled after unlocking current process
                  to avoid the risk of PSSI interrupt handle execution before current
                  process unlock */
        /* Enable ERR interrupt */
        HAL_PSSI_ENABLE_IT(hpssi, PSSI_FLAG_OVR_RIS);

        /* Enable DMA Request */
        hpssi->Instance->CR |= PSSI_CR_DMA_ENABLE;
        /* Enable the selected PSSI peripheral */
        HAL_PSSI_ENABLE(hpssi);
      }
      else
      {
        /* Update PSSI state */
        hpssi->State     = HAL_PSSI_STATE_READY;

        /* Update PSSI error code */
        hpssi->ErrorCode |= HAL_PSSI_ERROR_DMA;

        /* Process Unlocked */
        __HAL_UNLOCK(hpssi);

        return HAL_ERROR;
      }
    }
    else
    {
      /* Process Unlocked */
      __HAL_UNLOCK(hpssi);

      /* Note : The PSSI interrupts must be enabled after unlocking current process
                to avoid the risk of PSSI interrupt handle execution before current
                process unlock */
      /* Enable ERRinterrupt */
      /* possible to enable all of these */

      HAL_PSSI_ENABLE_IT(hpssi, PSSI_FLAG_OVR_RIS);
    }
    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif
#if P_DMA
HAL_StatusTypeDef HAL_PSSI_Receive_DMA(PSSI_HandleTypeDef *hpssi, uint32_t *pData, uint32_t Size)
{

  HAL_StatusTypeDef dmaxferstatus;

  if (hpssi->State == HAL_PSSI_STATE_READY)
  {

    /* Disable the selected PSSI peripheral */
    HAL_PSSI_DISABLE(hpssi);
    /* Process Locked */
    __HAL_LOCK(hpssi);

    hpssi->State       = HAL_PSSI_STATE_BUSY_RX;
    hpssi->ErrorCode   = HAL_PSSI_ERROR_NONE;

    /* Prepare transfer parameters */
    hpssi->pBuffPtr    = pData;
    hpssi->XferCount   = Size;

    if (hpssi->XferCount > PSSI_MAX_NBYTE_SIZE)
    {
      hpssi->XferSize = PSSI_MAX_NBYTE_SIZE;
    }
    else
    {
      hpssi->XferSize = hpssi->XferCount;
    }

    if (hpssi->XferSize > 0U)
    {
      if (hpssi->hdmarx != NULL)
      {
        /* Configure BusWidth */
        if (hpssi->hdmarx->Init.SrcDataWidth == DMA_SRC_DATAWIDTH_BYTE)
        {
          MODIFY_REG(hpssi->Instance->CR, PSSI_CR_DMAEN | PSSI_CR_OUTEN | PSSI_CR_CKPOL, PSSI_CR_DMA_ENABLE |
                     ((hpssi->Init.ClockPolarity == HAL_PSSI_RISING_EDGE) ? PSSI_CR_CKPOL : 0U));
        }
        else
        {
          MODIFY_REG(hpssi->Instance->CR, PSSI_CR_DMAEN | PSSI_CR_OUTEN | PSSI_CR_CKPOL,
                     PSSI_CR_DMA_ENABLE | hpssi->Init.BusWidth |
                     ((hpssi->Init.ClockPolarity == HAL_PSSI_RISING_EDGE) ? PSSI_CR_CKPOL : 0U));
        }

        /* Set the PSSI DMA transfer complete callback */
        hpssi->hdmarx->XferCpltCallback = PSSI_DMAReceiveCplt;

        /* Set the DMA error callback */
        hpssi->hdmarx->XferErrorCallback = PSSI_DMAError;

        /* Set the unused DMA callbacks to NULL */
        hpssi->hdmarx->XferHalfCpltCallback = NULL;
        hpssi->hdmarx->XferAbortCallback = NULL;

        /* Enable the DMA  */
        if ((hpssi->hdmarx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
        {
          if (hpssi->hdmarx->LinkedListQueue != NULL)
          {
            /* Enable the DMA channel */
            /* Set DMA data size */
            hpssi->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = hpssi->XferSize;
            /* Set DMA source address */
            hpssi->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] =
              (uint32_t)&hpssi->Instance->DR;
            /* Set DMA destination address */
            hpssi->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = (uint32_t)pData;

            dmaxferstatus = HAL_DMAEx_List_Start_IT(hpssi->hdmarx);
          }
          else
          {
            /* Return error status */
            return HAL_ERROR;
          }
        }
        else
        {
          dmaxferstatus = HAL_DMA_Start_IT(hpssi->hdmarx, (uint32_t)&hpssi->Instance->DR, (uint32_t)pData,
                                           hpssi->XferSize);
        }
      }
      else
      {
        /* Update PSSI state */
        hpssi->State     = HAL_PSSI_STATE_READY;

        /* Update PSSI error code */
        hpssi->ErrorCode |= HAL_PSSI_ERROR_DMA;

        /* Process Unlocked */
        __HAL_UNLOCK(hpssi);

        return HAL_ERROR;
      }

      if (dmaxferstatus == HAL_OK)
      {
        /* Update XferCount value */
        hpssi->XferCount -= hpssi->XferSize;

        /* Process Unlocked */
        __HAL_UNLOCK(hpssi);

        /* Note : The PSSI interrupts must be enabled after unlocking current process
                  to avoid the risk of PSSI interrupt handle execution before current
                  process unlock */
        /* Enable ERR  interrupt */
        HAL_PSSI_ENABLE_IT(hpssi, PSSI_FLAG_OVR_RIS);

        /* Enable DMA Request */
        hpssi->Instance->CR |= PSSI_CR_DMA_ENABLE;
        /* Enable the selected PSSI peripheral */
        HAL_PSSI_ENABLE(hpssi);
      }
      else
      {
        /* Update PSSI state */
        hpssi->State     = HAL_PSSI_STATE_READY;

        /* Update PSSI error code */
        hpssi->ErrorCode |= HAL_PSSI_ERROR_DMA;

        /* Process Unlocked */
        __HAL_UNLOCK(hpssi);

        return HAL_ERROR;
      }
    }
    else
    {
      /* Process Unlocked */
      __HAL_UNLOCK(hpssi);

      /* Enable ERR,interrupt */
      HAL_PSSI_ENABLE_IT(hpssi, PSSI_FLAG_OVR_RIS);
    }

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif
#if P_DMA
HAL_StatusTypeDef HAL_PSSI_Abort_DMA(PSSI_HandleTypeDef *hpssi)
{
  /* Process Locked */
  __HAL_LOCK(hpssi);

  /* Disable Interrupts */
  HAL_PSSI_DISABLE_IT(hpssi, PSSI_FLAG_OVR_RIS);

  /* Set State at HAL_PSSI_STATE_ABORT */
  hpssi->State = HAL_PSSI_STATE_ABORT;

  /* Abort DMA TX transfer if any */
  if ((hpssi->Instance->CR & PSSI_CR_DMAEN) == PSSI_CR_DMAEN)
  {
    if (hpssi->State == HAL_PSSI_STATE_BUSY_TX)
    {
      hpssi->Instance->CR &= ~PSSI_CR_DMAEN;

      if (hpssi->hdmatx != NULL)
      {
        /* Set the PSSI DMA Abort callback :
        will lead to call HAL_PSSI_ErrorCallback() at end of DMA abort procedure */
        hpssi->hdmatx->XferAbortCallback = PSSI_DMAAbort;

        /* Abort DMA TX */
        if (HAL_DMA_Abort_IT(hpssi->hdmatx) != HAL_OK)
        {
          /* Call Directly XferAbortCallback function in case of error */
          hpssi->hdmatx->XferAbortCallback(hpssi->hdmatx);
        }
      }
    }
    /* Abort DMA RX transfer if any */
    else if (hpssi->State == HAL_PSSI_STATE_BUSY_RX)
    {
      hpssi->Instance->CR &= ~PSSI_CR_DMAEN;

      if (hpssi->hdmarx != NULL)
      {
        /* Set the PSSI DMA Abort callback :
        will lead to call HAL_PSSI_ErrorCallback() at end of DMA abort procedure */
        hpssi->hdmarx->XferAbortCallback = PSSI_DMAAbort;

        /* Abort DMA RX */
        if (HAL_DMA_Abort_IT(hpssi->hdmarx) != HAL_OK)
        {
          /* Call Directly hpssi->hdma->XferAbortCallback function in case of error */
          hpssi->hdmarx->XferAbortCallback(hpssi->hdmarx);
        }
      }
    }
    else
    {

      /* Call the error callback */
#if (USE_HAL_PSSI_REGISTER_CALLBACKS == 1)
      hpssi->ErrorCallback(hpssi);
#else
      HAL_PSSI_ErrorCallback(hpssi);
#endif /* USE_HAL_PSSI_REGISTER_CALLBACKS */
    }
  }

  /* Process Unlocked */
  __HAL_UNLOCK(hpssi);

  /* Note : The PSSI interrupts must be enabled after unlocking current process
            to avoid the risk of PSSI interrupt handle execution before current
            process unlock */
  HAL_PSSI_ENABLE_IT(hpssi, PSSI_FLAG_OVR_RIS);

  return HAL_OK;
}
#endif
void HAL_PSSI_IRQHandler(PSSI_HandleTypeDef *hpssi)
{
  /* Overrun/ Underrun Errors */
  if (HAL_PSSI_GET_FLAG(hpssi, PSSI_FLAG_OVR_MIS) != 0U)
  {
    /* Reset handle parameters */
    hpssi->XferCount     = 0U;

    /* Disable all interrupts */
    HAL_PSSI_DISABLE_IT(hpssi, PSSI_FLAG_OVR_RIS);

#if defined(HAL_DMA_MODULE_ENABLED)
    /* Abort DMA TX transfer if any */
    if ((hpssi->Instance->CR & PSSI_CR_DMAEN) == PSSI_CR_DMAEN)
    {
      if (hpssi->State == HAL_PSSI_STATE_BUSY_TX)
      {
        /* Set new error code */
        hpssi->ErrorCode |= HAL_PSSI_ERROR_UNDER_RUN;

        hpssi->Instance->CR &= ~PSSI_CR_DMAEN;

        if (hpssi->hdmatx != NULL)
        {
          /* Set the PSSI DMA Abort callback :
          will lead to call HAL_PSSI_ErrorCallback() at end of DMA abort procedure */
          hpssi->hdmatx->XferAbortCallback = PSSI_DMAAbort;

          /* Process Unlocked */
          __HAL_UNLOCK(hpssi);

          /* Abort DMA TX */
          if (HAL_DMA_Abort_IT(hpssi->hdmatx) != HAL_OK)
          {
            /* Call Directly XferAbortCallback function in case of error */
            hpssi->hdmatx->XferAbortCallback(hpssi->hdmatx);
          }
        }
      }
      /* Abort DMA RX transfer if any */
      else if (hpssi->State == HAL_PSSI_STATE_BUSY_RX)
      {
        /* Set new error code */
        hpssi->ErrorCode |= HAL_PSSI_ERROR_OVER_RUN;

        hpssi->Instance->CR &= ~PSSI_CR_DMAEN;

        if (hpssi->hdmarx != NULL)
        {
          /* Set the PSSI DMA Abort callback :
          will lead to call HAL_PSSI_ErrorCallback() at end of DMA abort procedure */
          hpssi->hdmarx->XferAbortCallback = PSSI_DMAAbort;

          /* Process Unlocked */
          __HAL_UNLOCK(hpssi);

          /* Abort DMA RX */
          if (HAL_DMA_Abort_IT(hpssi->hdmarx) != HAL_OK)
          {
            /* Call Directly hpssi->hdma->XferAbortCallback function in case of error */
            hpssi->hdmarx->XferAbortCallback(hpssi->hdmarx);
          }
        }
      }
      else
      {
#if (USE_HAL_PSSI_REGISTER_CALLBACKS == 1)
        /* Call the corresponding callback to inform upper layer of the error */
        hpssi->ErrorCallback(hpssi);
#else
        HAL_PSSI_ErrorCallback(hpssi);
#endif /* USE_HAL_PSSI_REGISTER_CALLBACKS */
      }
    }
#endif /*HAL_DMA_MODULE_ENABLED*/

    /* If state is an abort treatment on going, don't change state */
    if (hpssi->State == HAL_PSSI_STATE_ABORT)
    {
      hpssi->State = HAL_PSSI_STATE_READY;

      /* Process Unlocked */
      __HAL_UNLOCK(hpssi);

#if (USE_HAL_PSSI_REGISTER_CALLBACKS == 1)
      /* Call the corresponding callback to inform upper layer of End of Transfer */
      hpssi->AbortCpltCallback(hpssi);
#else
      HAL_PSSI_AbortCpltCallback(hpssi);
#endif /* USE_HAL_PSSI_REGISTER_CALLBACKS */
    }
    else
    {
      /* Set HAL_PSSI_STATE_READY */
      hpssi->State         = HAL_PSSI_STATE_READY;
      /* Process Unlocked */
      __HAL_UNLOCK(hpssi);

#if (USE_HAL_PSSI_REGISTER_CALLBACKS == 1)
      /* Call the corresponding callback to inform upper layer of End of Transfer */
      hpssi->ErrorCallback(hpssi);
#else
      HAL_PSSI_ErrorCallback(hpssi);
#endif /* USE_HAL_PSSI_REGISTER_CALLBACKS */
    }
  }
}
HAL_PSSI_StateTypeDef HAL_PSSI_GetState(const PSSI_HandleTypeDef *hpssi)
{
  /* Return PSSI handle state */
  return hpssi->State;
}
uint32_t HAL_PSSI_GetError(const PSSI_HandleTypeDef *hpssi)
{
  return hpssi->ErrorCode;
}
HAL_StatusTypeDef HAL_PSSI_ClockConfig(PSSI_HandleTypeDef *hpssi, uint32_t ClockSource)
{
  /* Check the parameter */
  assert_param(IS_PSSI_CLOCK_SOURCE(ClockSource));

  if (hpssi->State == HAL_PSSI_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hpssi);

    HAL_PSSI_DISABLE(hpssi);

    /* Set CKSRC to ClockSource */
    MODIFY_REG(hpssi->Instance->CR, PSSI_CR_CKSRC, ClockSource);

    HAL_PSSI_ENABLE(hpssi);

    /* Process Unlocked */
    __HAL_UNLOCK(hpssi);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
static void PSSI_Error(PSSI_HandleTypeDef *hpssi, uint32_t ErrorCode)
{
  /* Reset handle parameters */
  hpssi->XferCount     = 0U;

  /* Set new error code */
  hpssi->ErrorCode |= ErrorCode;

  /* Disable all interrupts */
  HAL_PSSI_DISABLE_IT(hpssi, PSSI_FLAG_OVR_RIS);

#if defined(HAL_DMA_MODULE_ENABLED)
  /* Abort DMA TX transfer if any */
  if ((hpssi->Instance->CR & PSSI_CR_DMAEN) == PSSI_CR_DMAEN)
  {
    if (hpssi->State == HAL_PSSI_STATE_BUSY_TX)
    {
      hpssi->Instance->CR &= ~PSSI_CR_DMAEN;

      if (hpssi->hdmatx != NULL)
      {
        /* Set the PSSI DMA Abort callback :
        will lead to call HAL_PSSI_ErrorCallback() at end of DMA abort procedure */
        hpssi->hdmatx->XferAbortCallback = PSSI_DMAAbort;

        /* Process Unlocked */
        __HAL_UNLOCK(hpssi);

        /* Abort DMA TX */
        if (HAL_DMA_Abort_IT(hpssi->hdmatx) != HAL_OK)
        {
          /* Call Directly XferAbortCallback function in case of error */
          hpssi->hdmatx->XferAbortCallback(hpssi->hdmatx);
        }
      }
    }
    /* Abort DMA RX transfer if any */
    else if (hpssi->State == HAL_PSSI_STATE_BUSY_RX)
    {
      hpssi->Instance->CR &= ~PSSI_CR_DMAEN;

      if (hpssi->hdmarx != NULL)
      {
        /* Set the PSSI DMA Abort callback :
        will lead to call HAL_PSSI_ErrorCallback() at end of DMA abort procedure */
        hpssi->hdmarx->XferAbortCallback = PSSI_DMAAbort;

        /* Process Unlocked */
        __HAL_UNLOCK(hpssi);

        /* Abort DMA RX */
        if (HAL_DMA_Abort_IT(hpssi->hdmarx) != HAL_OK)
        {
          /* Call Directly hpssi->hdma->XferAbortCallback function in case of error */
          hpssi->hdmarx->XferAbortCallback(hpssi->hdmarx);
        }
      }
    }
    else
    {
      /*Nothing to do*/
    }
  }
#endif /*HAL_DMA_MODULE_ENABLED*/

  /* If state is an abort treatment on going, don't change state */
  if (hpssi->State == HAL_PSSI_STATE_ABORT)
  {
    hpssi->State = HAL_PSSI_STATE_READY;

    /* Process Unlocked */
    __HAL_UNLOCK(hpssi);

    /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_PSSI_REGISTER_CALLBACKS == 1)
    hpssi->AbortCpltCallback(hpssi);
#else
    HAL_PSSI_AbortCpltCallback(hpssi);
#endif /* USE_HAL_PSSI_REGISTER_CALLBACKS */
  }
  else
  {
    /* Set HAL_PSSI_STATE_READY */
    hpssi->State = HAL_PSSI_STATE_READY;

    /* Process Unlocked */
    __HAL_UNLOCK(hpssi);

    /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_PSSI_REGISTER_CALLBACKS == 1)
    hpssi->ErrorCallback(hpssi);
#else
    HAL_PSSI_ErrorCallback(hpssi);
#endif /* USE_HAL_PSSI_REGISTER_CALLBACKS */
  }
}
#if P_DMA
void PSSI_DMATransmitCplt(DMA_HandleTypeDef *hdma)
{
  /* Derogation MISRAC2012-Rule-11.5 */
  PSSI_HandleTypeDef *hpssi = (PSSI_HandleTypeDef *)(((DMA_HandleTypeDef *)hdma)->Parent);

  uint32_t tmperror;

  /* Disable Interrupts */
  HAL_PSSI_DISABLE_IT(hpssi, PSSI_FLAG_OVR_RIS);

  /* Store current volatile hpssi->ErrorCode, misra rule */
  tmperror = hpssi->ErrorCode;

  /* Call the corresponding callback to inform upper layer of End of Transfer */
  if ((hpssi->State == HAL_PSSI_STATE_ABORT) || (tmperror != HAL_PSSI_ERROR_NONE))
  {
    /* Call the corresponding callback to inform upper layer of End of Transfer */
    PSSI_Error(hpssi, hpssi->ErrorCode);
  }
  /* hpssi->State == HAL_PSSI_STATE_BUSY_TX */
  else
  {
    hpssi->State = HAL_PSSI_STATE_READY;

    /* Process Unlocked */
    __HAL_UNLOCK(hpssi);

    /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_PSSI_REGISTER_CALLBACKS == 1)
    hpssi->TxCpltCallback(hpssi);
#else
    HAL_PSSI_TxCpltCallback(hpssi);
#endif /* USE_HAL_PSSI_REGISTER_CALLBACKS */
  }
}
#endif
#if P_DMA
void PSSI_DMAReceiveCplt(DMA_HandleTypeDef *hdma)
{
  /* Derogation MISRAC2012-Rule-11.5 */
  PSSI_HandleTypeDef *hpssi = (PSSI_HandleTypeDef *)(((DMA_HandleTypeDef *)hdma)->Parent);

  uint32_t tmperror;

  /* Disable Interrupts */
  HAL_PSSI_DISABLE_IT(hpssi, PSSI_FLAG_OVR_RIS);

  /* Store current volatile hpssi->ErrorCode, misra rule */
  tmperror = hpssi->ErrorCode;

  /* Call the corresponding callback to inform upper layer of End of Transfer */
  if ((hpssi->State == HAL_PSSI_STATE_ABORT) || (tmperror != HAL_PSSI_ERROR_NONE))
  {
    /* Call the corresponding callback to inform upper layer of End of Transfer */
    PSSI_Error(hpssi, hpssi->ErrorCode);
  }
  /* hpssi->State == HAL_PSSI_STATE_BUSY_RX */
  else
  {
    hpssi->State = HAL_PSSI_STATE_READY;

    /* Process Unlocked */
    __HAL_UNLOCK(hpssi);

    /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_PSSI_REGISTER_CALLBACKS == 1)
    hpssi->RxCpltCallback(hpssi);
#else
    HAL_PSSI_RxCpltCallback(hpssi);
#endif /* USE_HAL_PSSI_REGISTER_CALLBACKS */
  }
}
#endif
#if P_DMA
void PSSI_DMAAbort(DMA_HandleTypeDef *hdma)
{
  /* Derogation MISRAC2012-Rule-11.5 */
  PSSI_HandleTypeDef *hpssi = (PSSI_HandleTypeDef *)(((DMA_HandleTypeDef *)hdma)->Parent);

  /* Reset AbortCpltCallback */
  hpssi->hdmatx->XferAbortCallback = NULL;
  hpssi->hdmarx->XferAbortCallback = NULL;

  /* Check if come from abort from user */
  if (hpssi->State == HAL_PSSI_STATE_ABORT)
  {
    hpssi->State = HAL_PSSI_STATE_READY;

    /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_PSSI_REGISTER_CALLBACKS == 1)
    hpssi->AbortCpltCallback(hpssi);
#else
    HAL_PSSI_AbortCpltCallback(hpssi);
#endif /* USE_HAL_PSSI_REGISTER_CALLBACKS */
  }
  else
  {
    /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_PSSI_REGISTER_CALLBACKS == 1)
    hpssi->ErrorCallback(hpssi);
#else
    HAL_PSSI_ErrorCallback(hpssi);
#endif /* USE_HAL_PSSI_REGISTER_CALLBACKS */
  }
}
#endif
static HAL_StatusTypeDef PSSI_WaitOnStatusUntilTimeout(PSSI_HandleTypeDef *hpssi, uint32_t Flag, FlagStatus Status,
                                                       uint32_t Timeout, uint32_t Tickstart)
{
  while ((HAL_PSSI_GET_STATUS(hpssi, Flag) & Flag) == (uint32_t)Status)
  {
    /* Check for the Timeout */
    if (Timeout != HAL_MAX_DELAY)
    {
      if (((HAL_GetTick() - Tickstart) > Timeout) || (Timeout == 0U))
      {
        hpssi->ErrorCode |= HAL_PSSI_ERROR_TIMEOUT;
        hpssi->State = HAL_PSSI_STATE_READY;

        /* Process Unlocked */
        __HAL_UNLOCK(hpssi);

        return HAL_ERROR;
      }
    }
  }
  return HAL_OK;
}
#if P_DMA
void PSSI_DMAError(DMA_HandleTypeDef *hdma)
{
  /* Derogation MISRAC2012-Rule-11.5 */
  PSSI_HandleTypeDef *hpssi = (PSSI_HandleTypeDef *)(((DMA_HandleTypeDef *)hdma)->Parent);

  uint32_t tmperror;

  /* Disable the selected PSSI peripheral */
  HAL_PSSI_DISABLE(hpssi);

  /* Disable Interrupts */
  HAL_PSSI_DISABLE_IT(hpssi, PSSI_FLAG_OVR_RIS);

  /* Store current volatile hpssi->ErrorCode, misra rule */
  tmperror = hpssi->ErrorCode;

  /* Call the corresponding callback to inform upper layer of End of Transfer */
  if ((hpssi->State == HAL_PSSI_STATE_ABORT) || (tmperror != HAL_PSSI_ERROR_NONE))
  {
    /* Call the corresponding callback to inform upper layer of End of Transfer */
    PSSI_Error(hpssi, hpssi->ErrorCode);
  }
  else
  {
    hpssi->State = HAL_PSSI_STATE_READY;

    /* Process Unlocked */
    __HAL_UNLOCK(hpssi);

    /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_PSSI_REGISTER_CALLBACKS == 1)
    hpssi->ErrorCallback(hpssi);
#else
    HAL_PSSI_ErrorCallback(hpssi);
#endif /* USE_HAL_PSSI_REGISTER_CALLBACKS */
  }
}
#endif
