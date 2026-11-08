// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SRAM operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

HAL_StatusTypeDef HAL_SRAM_Init(SRAM_HandleTypeDef *hsram, FMC_NORSRAM_TimingTypeDef *Timing,
                                FMC_NORSRAM_TimingTypeDef *ExtTiming)
{
  /* Check the SRAM handle parameter */
  if (hsram == NULL)
  {
    return HAL_ERROR;
  }

  if (hsram->State == HAL_SRAM_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    hsram->Lock = HAL_UNLOCKED;

#if (USE_HAL_SRAM_REGISTER_CALLBACKS == 1)
    if (hsram->MspInitCallback == NULL)
    {
      hsram->MspInitCallback = HAL_SRAM_MspInit;
    }
    hsram->DmaXferCpltCallback = HAL_SRAM_DMA_XferCpltCallback;
    hsram->DmaXferErrorCallback = HAL_SRAM_DMA_XferErrorCallback;

    /* Init the low level hardware */
    hsram->MspInitCallback(hsram);
#else
    /* Initialize the low level hardware (MSP) */
    HAL_SRAM_MspInit(hsram);
#endif /* USE_HAL_SRAM_REGISTER_CALLBACKS */
  }

  /* Initialize SRAM control Interface */
  (void)FMC_NORSRAM_Init(hsram->Instance, &(hsram->Init));

  /* Initialize SRAM timing Interface */
  (void)FMC_NORSRAM_Timing_Init(hsram->Instance, Timing, hsram->Init.NSBank);

  /* Initialize SRAM extended mode timing Interface */
  (void)FMC_NORSRAM_Extended_Timing_Init(hsram->Extended, ExtTiming, hsram->Init.NSBank,
                                         hsram->Init.ExtendedMode);

  /* Enable the NORSRAM device */
  __FMC_NORSRAM_ENABLE(hsram->Instance, hsram->Init.NSBank);

  /* Enable FMC Peripheral */
  __FMC_ENABLE();

  /* Initialize the SRAM controller state */
  hsram->State = HAL_SRAM_STATE_READY;

  return HAL_OK;
}

HAL_StatusTypeDef HAL_SRAM_DeInit(SRAM_HandleTypeDef *hsram)
{
#if (USE_HAL_SRAM_REGISTER_CALLBACKS == 1)
  if (hsram->MspDeInitCallback == NULL)
  {
    hsram->MspDeInitCallback = HAL_SRAM_MspDeInit;
  }

  /* DeInit the low level hardware */
  hsram->MspDeInitCallback(hsram);
#else
  /* De-Initialize the low level hardware (MSP) */
  HAL_SRAM_MspDeInit(hsram);
#endif /* USE_HAL_SRAM_REGISTER_CALLBACKS */

  /* Configure the SRAM registers with their reset values */
  (void)FMC_NORSRAM_DeInit(hsram->Instance, hsram->Extended, hsram->Init.NSBank);

  /* Reset the SRAM controller state */
  hsram->State = HAL_SRAM_STATE_RESET;

  /* Release Lock */
  __HAL_UNLOCK(hsram);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_SRAM_Read_8b(SRAM_HandleTypeDef *hsram, uint32_t *pAddress, uint8_t *pDstBuffer,
                                   uint32_t BufferSize)
{
  uint32_t size;
  __IO uint8_t *psramaddress = (uint8_t *)pAddress;
  uint8_t *pdestbuff = pDstBuffer;
  HAL_SRAM_StateTypeDef state = hsram->State;

  /* Check the SRAM controller state */
  if ((state == HAL_SRAM_STATE_READY) || (state == HAL_SRAM_STATE_PROTECTED))
  {
    /* Process Locked */
    __HAL_LOCK(hsram);

    /* Update the SRAM controller state */
    hsram->State = HAL_SRAM_STATE_BUSY;

    /* Read data from memory */
    for (size = BufferSize; size != 0U; size--)
    {
      *pdestbuff = FMC_MEMORY_READ8(psramaddress);
      pdestbuff++;
      psramaddress++;
    }

    /* Update the SRAM controller state */
    hsram->State = state;

    /* Process unlocked */
    __HAL_UNLOCK(hsram);
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_SRAM_Write_8b(SRAM_HandleTypeDef *hsram, uint32_t *pAddress, uint8_t *pSrcBuffer,
                                    uint32_t BufferSize)
{
  uint32_t size;
  __IO uint8_t *psramaddress = (uint8_t *)pAddress;
  uint8_t *psrcbuff = pSrcBuffer;

  /* Check the SRAM controller state */
  if (hsram->State == HAL_SRAM_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hsram);

    /* Update the SRAM controller state */
    hsram->State = HAL_SRAM_STATE_BUSY;

    /* Write data to memory */
    for (size = BufferSize; size != 0U; size--)
    {
      FMC_MEMORY_WRITE8(psramaddress, *psrcbuff);
      psrcbuff++;
      psramaddress++;
    }

    /* Update the SRAM controller state */
    hsram->State = HAL_SRAM_STATE_READY;

    /* Process unlocked */
    __HAL_UNLOCK(hsram);
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_SRAM_Read_16b(SRAM_HandleTypeDef *hsram, uint32_t *pAddress, uint16_t *pDstBuffer,
                                    uint32_t BufferSize)
{
  uint32_t size;
  __IO uint32_t *psramaddress = pAddress;
  uint16_t *pdestbuff = pDstBuffer;
  uint8_t limit;
  HAL_SRAM_StateTypeDef state = hsram->State;

  /* Check the SRAM controller state */
  if ((state == HAL_SRAM_STATE_READY) || (state == HAL_SRAM_STATE_PROTECTED))
  {
    /* Process Locked */
    __HAL_LOCK(hsram);

    /* Update the SRAM controller state */
    hsram->State = HAL_SRAM_STATE_BUSY;

    /* Check if the size is a 32-bits multiple */
    limit = (((BufferSize % 2U) != 0U) ? 1U : 0U);

    /* Read data from memory */
    for (size = BufferSize; size != limit; size -= 2U)
    {
      *pdestbuff = (uint16_t)((FMC_MEMORY_READ32(psramaddress)) & 0x0000FFFFU);
      pdestbuff++;
      *pdestbuff = (uint16_t)(((FMC_MEMORY_READ32(psramaddress)) & 0xFFFF0000U) >> 16U);
      pdestbuff++;
      psramaddress++;
    }

    /* Read last 16-bits if size is not 32-bits multiple */
    if (limit != 0U)
    {
      *pdestbuff = (uint16_t)((FMC_MEMORY_READ32(psramaddress)) & 0x0000FFFFU);
    }

    /* Update the SRAM controller state */
    hsram->State = state;

    /* Process unlocked */
    __HAL_UNLOCK(hsram);
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_SRAM_Write_16b(SRAM_HandleTypeDef *hsram, uint32_t *pAddress, uint16_t *pSrcBuffer,
                                     uint32_t BufferSize)
{
  uint32_t size;
  __IO uint32_t *psramaddress = pAddress;
  uint16_t *psrcbuff = pSrcBuffer;
  uint8_t limit;

  /* Check the SRAM controller state */
  if (hsram->State == HAL_SRAM_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hsram);

    /* Update the SRAM controller state */
    hsram->State = HAL_SRAM_STATE_BUSY;

    /* Check if the size is a 32-bits multiple */
    limit = (((BufferSize % 2U) != 0U) ? 1U : 0U);

    /* Write data to memory */
    for (size = BufferSize; size != limit; size -= 2U)
    {
      FMC_MEMORY_WRITE32(psramaddress, (uint32_t)(*psrcbuff));
      psrcbuff++;
      FMC_MEMORY_WRITE32(psramaddress, (FMC_MEMORY_READ32(psramaddress) | (((uint32_t)(*psrcbuff) << 16U))));
      psrcbuff++;
      psramaddress++;
    }

    /* Write last 16-bits if size is not 32-bits multiple */
    if (limit != 0U)
    {
      FMC_MEMORY_WRITE32(psramaddress, ((uint32_t)(*psrcbuff) & 0x0000FFFFU) | ((FMC_MEMORY_READ32(psramaddress)) & 0xFFFF0000U));
    }

    /* Update the SRAM controller state */
    hsram->State = HAL_SRAM_STATE_READY;

    /* Process unlocked */
    __HAL_UNLOCK(hsram);
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_SRAM_Read_32b(SRAM_HandleTypeDef *hsram, uint32_t *pAddress, uint32_t *pDstBuffer,
                                    uint32_t BufferSize)
{
  uint32_t size;
  __IO uint32_t *psramaddress = pAddress;
  uint32_t *pdestbuff = pDstBuffer;
  HAL_SRAM_StateTypeDef state = hsram->State;

  /* Check the SRAM controller state */
  if ((state == HAL_SRAM_STATE_READY) || (state == HAL_SRAM_STATE_PROTECTED))
  {
    /* Process Locked */
    __HAL_LOCK(hsram);

    /* Update the SRAM controller state */
    hsram->State = HAL_SRAM_STATE_BUSY;

    /* Read data from memory */
    for (size = BufferSize; size != 0U; size--)
    {
      *pdestbuff = FMC_MEMORY_READ32(psramaddress);
      pdestbuff++;
      psramaddress++;
    }

    /* Update the SRAM controller state */
    hsram->State = state;

    /* Process unlocked */
    __HAL_UNLOCK(hsram);
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_SRAM_Write_32b(SRAM_HandleTypeDef *hsram, uint32_t *pAddress, uint32_t *pSrcBuffer,
                                     uint32_t BufferSize)
{
  uint32_t size;
  __IO uint32_t *psramaddress = pAddress;
  uint32_t *psrcbuff = pSrcBuffer;

  /* Check the SRAM controller state */
  if (hsram->State == HAL_SRAM_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hsram);

    /* Update the SRAM controller state */
    hsram->State = HAL_SRAM_STATE_BUSY;

    /* Write data to memory */
    for (size = BufferSize; size != 0U; size--)
    {
      FMC_MEMORY_WRITE32(psramaddress, *psrcbuff);
      psrcbuff++;
      psramaddress++;
    }

    /* Update the SRAM controller state */
    hsram->State = HAL_SRAM_STATE_READY;

    /* Process unlocked */
    __HAL_UNLOCK(hsram);
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_SRAM_Read_DMA(SRAM_HandleTypeDef *hsram, uint32_t *pAddress, uint32_t *pDstBuffer,
                                    uint32_t BufferSize)
{
  HAL_StatusTypeDef status;
  HAL_SRAM_StateTypeDef state = hsram->State;
  uint32_t size;
  uint32_t data_width;

  /* Check the SRAM controller state */
  if ((state == HAL_SRAM_STATE_READY) || (state == HAL_SRAM_STATE_PROTECTED))
  {
    /* Process Locked */
    __HAL_LOCK(hsram);

    /* Update the SRAM controller state */
    hsram->State = HAL_SRAM_STATE_BUSY;

    /* Configure DMA user callbacks */
    if (state == HAL_SRAM_STATE_READY)
    {
      hsram->hdma->XferCpltCallback = SRAM_DMACplt;
    }
    else
    {
      hsram->hdma->XferCpltCallback = SRAM_DMACpltProt;
    }
    hsram->hdma->XferErrorCallback = SRAM_DMAError;

    if ((hsram->hdma->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
    {
      if ((hsram->hdma->LinkedListQueue != 0U) && (hsram->hdma->LinkedListQueue->Head != 0U))
      {
        /* Check destination data width and set the size to be transferred */
        data_width = hsram->hdma->LinkedListQueue->Head->LinkRegisters[NODE_CTR1_DEFAULT_OFFSET] & DMA_CTR1_DDW_LOG2;

        if (data_width == DMA_DEST_DATAWIDTH_WORD)
        {
          size = (BufferSize * 4U);
        }
        else if (data_width == DMA_DEST_DATAWIDTH_HALFWORD)
        {
          size = (BufferSize * 2U);
        }
        else
        {
          size = (BufferSize);
        }
        /* Set Source , destination , buffer size */
        /* Set DMA data size */
        hsram->hdma->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = size;
        /* Set DMA source address */
        hsram->hdma->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = (uint32_t)(uintptr_t)pAddress;
        /* Set DMA destination address */
        hsram->hdma->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = (uint32_t)(uintptr_t)pDstBuffer;

        /* Enable the DMA Stream */
        status = HAL_DMAEx_List_Start_IT(hsram->hdma);
      }
      else
      {
        /* Change SRAM state */
        hsram->State = HAL_SRAM_STATE_READY;

        __HAL_UNLOCK(hsram);

        status = HAL_ERROR;
      }
    }
    else
    {
      /* Check destination data width and set the size to be transferred */
      data_width = hsram->hdma->Init.DestDataWidth;

      if (data_width == DMA_DEST_DATAWIDTH_WORD)
      {
        size = (BufferSize * 4U);
      }
      else if (data_width == DMA_DEST_DATAWIDTH_HALFWORD)
      {
        size = (BufferSize * 2U);
      }
      else
      {
        size = (BufferSize);
      }

      /* Enable the DMA Stream */
      status = HAL_DMA_Start_IT(hsram->hdma, (uint32_t)(uintptr_t)pAddress, (uint32_t)(uintptr_t)pDstBuffer, size);
    }

    /* Process unlocked */
    __HAL_UNLOCK(hsram);
  }
  else
  {
    status = HAL_ERROR;
  }

  return status;
}

HAL_StatusTypeDef HAL_SRAM_Write_DMA(SRAM_HandleTypeDef *hsram, uint32_t *pAddress, uint32_t *pSrcBuffer,
                                     uint32_t BufferSize)
{
  HAL_StatusTypeDef status;
  uint32_t size;
  uint32_t data_width;

  /* Check the SRAM controller state */
  if (hsram->State == HAL_SRAM_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hsram);

    /* Update the SRAM controller state */
    hsram->State = HAL_SRAM_STATE_BUSY;

    /* Configure DMA user callbacks */
    hsram->hdma->XferCpltCallback = SRAM_DMACplt;
    hsram->hdma->XferErrorCallback = SRAM_DMAError;

    if ((hsram->hdma->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
    {
      if ((hsram->hdma->LinkedListQueue != 0U) && (hsram->hdma->LinkedListQueue->Head != 0U))
      {
        /* Check destination data width and set the size to be transferred */
        data_width = hsram->hdma->LinkedListQueue->Head->LinkRegisters[NODE_CTR1_DEFAULT_OFFSET] & DMA_CTR1_DDW_LOG2;

        if (data_width == DMA_DEST_DATAWIDTH_WORD)
        {
          size = (BufferSize * 4U);
        }
        else if (data_width == DMA_DEST_DATAWIDTH_HALFWORD)
        {
          size = (BufferSize * 2U);
        }
        else
        {
          size = (BufferSize);
        }
        /* Set Source , destination , buffer size */
        /* Set DMA data size */
        hsram->hdma->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = size;
        /* Set DMA source address */
        hsram->hdma->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = (uint32_t)(uintptr_t)pSrcBuffer;
        /* Set DMA destination address */
        hsram->hdma->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = (uint32_t)(uintptr_t)pAddress;
        /* Enable the DMA Stream */
        status = HAL_DMAEx_List_Start_IT(hsram->hdma);
      }
      else
      {
        /* Change SRAM state */
        hsram->State = HAL_SRAM_STATE_READY;

        __HAL_UNLOCK(hsram);

        status = HAL_ERROR;
      }
    }
    else
    {
      /* Check destination data width and set the size to be transferred */
      data_width = hsram->hdma->Init.DestDataWidth;

      if (data_width == DMA_DEST_DATAWIDTH_WORD)
      {
        size = (BufferSize * 4U);
      }
      else if (data_width == DMA_DEST_DATAWIDTH_HALFWORD)
      {
        size = (BufferSize * 2U);
      }
      else
      {
        size = (BufferSize);
      }

      /* Enable the DMA Stream */
      status = HAL_DMA_Start_IT(hsram->hdma, (uint32_t)(uintptr_t)pSrcBuffer, (uint32_t)(uintptr_t)pAddress, size);
    }

    /* Process unlocked */
    __HAL_UNLOCK(hsram);
  }
  else
  {
    status = HAL_ERROR;
  }

  return status;
}

#if USE_HAL_SRAM_REGISTER_CALLBACKS
HAL_StatusTypeDef HAL_SRAM_RegisterCallback(SRAM_HandleTypeDef *hsram, HAL_SRAM_CallbackIDTypeDef CallbackId,
                                            pSRAM_CallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;
  HAL_SRAM_StateTypeDef state;

  if (pCallback == NULL)
  {
    return HAL_ERROR;
  }

  state = hsram->State;
  if ((state == HAL_SRAM_STATE_READY) || (state == HAL_SRAM_STATE_RESET) || (state == HAL_SRAM_STATE_PROTECTED))
  {
    switch (CallbackId)
    {
      case HAL_SRAM_MSP_INIT_CB_ID :
        hsram->MspInitCallback = pCallback;
        break;
      case HAL_SRAM_MSP_DEINIT_CB_ID :
        hsram->MspDeInitCallback = pCallback;
        break;
      default :
        /* update return status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* update return status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif

#if USE_HAL_SRAM_REGISTER_CALLBACKS
HAL_StatusTypeDef HAL_SRAM_UnRegisterCallback(SRAM_HandleTypeDef *hsram, HAL_SRAM_CallbackIDTypeDef CallbackId)
{
  HAL_StatusTypeDef status = HAL_OK;
  HAL_SRAM_StateTypeDef state;

  state = hsram->State;
  if ((state == HAL_SRAM_STATE_READY) || (state == HAL_SRAM_STATE_PROTECTED))
  {
    switch (CallbackId)
    {
      case HAL_SRAM_MSP_INIT_CB_ID :
        hsram->MspInitCallback = HAL_SRAM_MspInit;
        break;
      case HAL_SRAM_MSP_DEINIT_CB_ID :
        hsram->MspDeInitCallback = HAL_SRAM_MspDeInit;
        break;
      case HAL_SRAM_DMA_XFER_CPLT_CB_ID :
        hsram->DmaXferCpltCallback = HAL_SRAM_DMA_XferCpltCallback;
        break;
      case HAL_SRAM_DMA_XFER_ERR_CB_ID :
        hsram->DmaXferErrorCallback = HAL_SRAM_DMA_XferErrorCallback;
        break;
      default :
        /* update return status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (state == HAL_SRAM_STATE_RESET)
  {
    switch (CallbackId)
    {
      case HAL_SRAM_MSP_INIT_CB_ID :
        hsram->MspInitCallback = HAL_SRAM_MspInit;
        break;
      case HAL_SRAM_MSP_DEINIT_CB_ID :
        hsram->MspDeInitCallback = HAL_SRAM_MspDeInit;
        break;
      default :
        /* update return status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* update return status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif

#if USE_HAL_SRAM_REGISTER_CALLBACKS
HAL_StatusTypeDef HAL_SRAM_RegisterDmaCallback(SRAM_HandleTypeDef *hsram, HAL_SRAM_CallbackIDTypeDef CallbackId,
                                               pSRAM_DmaCallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;
  HAL_SRAM_StateTypeDef state;

  if (pCallback == NULL)
  {
    return HAL_ERROR;
  }

  /* Process locked */
  __HAL_LOCK(hsram);

  state = hsram->State;
  if ((state == HAL_SRAM_STATE_READY) || (state == HAL_SRAM_STATE_PROTECTED))
  {
    switch (CallbackId)
    {
      case HAL_SRAM_DMA_XFER_CPLT_CB_ID :
        hsram->DmaXferCpltCallback = pCallback;
        break;
      case HAL_SRAM_DMA_XFER_ERR_CB_ID :
        hsram->DmaXferErrorCallback = pCallback;
        break;
      default :
        /* update return status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* update return status */
    status =  HAL_ERROR;
  }

  /* Release Lock */
  __HAL_UNLOCK(hsram);
  return status;
}
#endif

HAL_StatusTypeDef HAL_SRAM_WriteOperation_Enable(SRAM_HandleTypeDef *hsram)
{
  /* Check the SRAM controller state */
  if (hsram->State == HAL_SRAM_STATE_PROTECTED)
  {
    /* Process Locked */
    __HAL_LOCK(hsram);

    /* Update the SRAM controller state */
    hsram->State = HAL_SRAM_STATE_BUSY;

    /* Enable write operation */
    (void)FMC_NORSRAM_WriteOperation_Enable(hsram->Instance, hsram->Init.NSBank);

    /* Update the SRAM controller state */
    hsram->State = HAL_SRAM_STATE_READY;

    /* Process unlocked */
    __HAL_UNLOCK(hsram);
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_SRAM_WriteOperation_Disable(SRAM_HandleTypeDef *hsram)
{
  /* Check the SRAM controller state */
  if (hsram->State == HAL_SRAM_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hsram);

    /* Update the SRAM controller state */
    hsram->State = HAL_SRAM_STATE_BUSY;

    /* Disable write operation */
    (void)FMC_NORSRAM_WriteOperation_Disable(hsram->Instance, hsram->Init.NSBank);

    /* Update the SRAM controller state */
    hsram->State = HAL_SRAM_STATE_PROTECTED;

    /* Process unlocked */
    __HAL_UNLOCK(hsram);
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_SRAM_StateTypeDef HAL_SRAM_GetState(const SRAM_HandleTypeDef *hsram)
{
  return hsram->State;
}

static void SRAM_DMACplt(DMA_HandleTypeDef *hdma)
{
  /* Derogation MISRAC2012-Rule-11.5 */
  SRAM_HandleTypeDef *hsram = (SRAM_HandleTypeDef *)(hdma->Parent);

  /* Disable the DMA channel */
  __HAL_DMA_DISABLE(hdma);

  /* Update the SRAM controller state */
  hsram->State = HAL_SRAM_STATE_READY;

#if (USE_HAL_SRAM_REGISTER_CALLBACKS == 1)
  hsram->DmaXferCpltCallback(hdma);
#else
  HAL_SRAM_DMA_XferCpltCallback(hdma);
#endif /* USE_HAL_SRAM_REGISTER_CALLBACKS */
}

static void SRAM_DMACpltProt(DMA_HandleTypeDef *hdma)
{
  /* Derogation MISRAC2012-Rule-11.5 */
  SRAM_HandleTypeDef *hsram = (SRAM_HandleTypeDef *)(hdma->Parent);

  /* Disable the DMA channel */
  __HAL_DMA_DISABLE(hdma);

  /* Update the SRAM controller state */
  hsram->State = HAL_SRAM_STATE_PROTECTED;

#if (USE_HAL_SRAM_REGISTER_CALLBACKS == 1)
  hsram->DmaXferCpltCallback(hdma);
#else
  HAL_SRAM_DMA_XferCpltCallback(hdma);
#endif /* USE_HAL_SRAM_REGISTER_CALLBACKS */
}

static void SRAM_DMAError(DMA_HandleTypeDef *hdma)
{
  /* Derogation MISRAC2012-Rule-11.5 */
  SRAM_HandleTypeDef *hsram = (SRAM_HandleTypeDef *)(hdma->Parent);

  /* Disable the DMA channel */
  __HAL_DMA_DISABLE(hdma);

  /* Update the SRAM controller state */
  hsram->State = HAL_SRAM_STATE_ERROR;

#if (USE_HAL_SRAM_REGISTER_CALLBACKS == 1)
  hsram->DmaXferErrorCallback(hdma);
#else
  HAL_SRAM_DMA_XferErrorCallback(hdma);
#endif /* USE_HAL_SRAM_REGISTER_CALLBACKS */
}
