// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SDRAM operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

HAL_StatusTypeDef HAL_SDRAM_Init(SDRAM_HandleTypeDef *hsdram, FMC_SDRAM_TimingTypeDef *Timing)
{
  /* Check the SDRAM handle parameter */
  if (hsdram == NULL)
  {
    return HAL_ERROR;
  }

  if (hsdram->State == HAL_SDRAM_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    hsdram->Lock = HAL_UNLOCKED;
#if (USE_HAL_SDRAM_REGISTER_CALLBACKS == 1)
    if (hsdram->MspInitCallback == NULL)
    {
      hsdram->MspInitCallback = HAL_SDRAM_MspInit;
    }
    hsdram->RefreshErrorCallback = HAL_SDRAM_RefreshErrorCallback;
    hsdram->DmaXferCpltCallback = HAL_SDRAM_DMA_XferCpltCallback;
    hsdram->DmaXferErrorCallback = HAL_SDRAM_DMA_XferErrorCallback;

    /* Init the low level hardware */
    hsdram->MspInitCallback(hsdram);
#else
    /* Initialize the low level hardware (MSP) */
    HAL_SDRAM_MspInit(hsdram);
#endif /* USE_HAL_SDRAM_REGISTER_CALLBACKS */
  }

  /* Initialize the SDRAM controller state */
  hsdram->State = HAL_SDRAM_STATE_BUSY;

  /* Initialize SDRAM control Interface */
  (void)FMC_SDRAM_Init(hsdram->Instance, &(hsdram->Init));

  /* Initialize SDRAM timing Interface */
  (void)FMC_SDRAM_Timing_Init(hsdram->Instance, Timing, hsdram->Init.SDBank);

  /* Enable FMC Peripheral */
  __FMC_ENABLE();
  /* Update the SDRAM controller state */
  hsdram->State = HAL_SDRAM_STATE_READY;

  return HAL_OK;
}

HAL_StatusTypeDef HAL_SDRAM_DeInit(SDRAM_HandleTypeDef *hsdram)
{
#if (USE_HAL_SDRAM_REGISTER_CALLBACKS == 1)
  if (hsdram->MspDeInitCallback == NULL)
  {
    hsdram->MspDeInitCallback = HAL_SDRAM_MspDeInit;
  }

  /* DeInit the low level hardware */
  hsdram->MspDeInitCallback(hsdram);
#else
  /* Initialize the low level hardware (MSP) */
  HAL_SDRAM_MspDeInit(hsdram);
#endif /* USE_HAL_SDRAM_REGISTER_CALLBACKS */

  /* Configure the SDRAM registers with their reset values */
  (void)FMC_SDRAM_DeInit(hsdram->Instance, hsdram->Init.SDBank);

  /* Reset the SDRAM controller state */
  hsdram->State = HAL_SDRAM_STATE_RESET;

  /* Release Lock */
  __HAL_UNLOCK(hsdram);

  return HAL_OK;
}

void HAL_SDRAM_IRQHandler(SDRAM_HandleTypeDef *hsdram)
{
  /* Check SDRAM interrupt Rising edge flag */
  if (__FMC_SDRAM_GET_FLAG(hsdram->Instance, FMC_SDRAM_FLAG_REFRESH_IT))
  {
    /* SDRAM refresh error interrupt callback */
#if (USE_HAL_SDRAM_REGISTER_CALLBACKS == 1)
    hsdram->RefreshErrorCallback(hsdram);
#else
    HAL_SDRAM_RefreshErrorCallback(hsdram);
#endif /* USE_HAL_SDRAM_REGISTER_CALLBACKS */

    /* Clear SDRAM refresh error interrupt pending bit */
    __FMC_SDRAM_CLEAR_FLAG(hsdram->Instance, FMC_SDRAM_FLAG_REFRESH_ERROR);
  }
}

HAL_StatusTypeDef HAL_SDRAM_Read_8b(SDRAM_HandleTypeDef *hsdram, uint32_t *pAddress, uint8_t *pDstBuffer,
                                    uint32_t BufferSize)
{
  uint32_t size;
  __IO uint8_t *pSdramAddress = (uint8_t *)pAddress;
  uint8_t *pdestbuff = pDstBuffer;
  HAL_SDRAM_StateTypeDef state = hsdram->State;

  /* Check the SDRAM controller state */
  if (state == HAL_SDRAM_STATE_BUSY)
  {
    return HAL_BUSY;
  }
  else if ((state == HAL_SDRAM_STATE_READY) || (state == HAL_SDRAM_STATE_WRITE_PROTECTED))
  {
    /* Process Locked */
    __HAL_LOCK(hsdram);

    /* Update the SDRAM controller state */
    hsdram->State = HAL_SDRAM_STATE_BUSY;

    /* Read data from source */
    for (size = BufferSize; size != 0U; size--)
    {
      *pdestbuff = FMC_MEMORY_READ8(pSdramAddress);
      pdestbuff++;
      pSdramAddress++;
    }

    /* Update the SDRAM controller state */
    hsdram->State = state;

    /* Process Unlocked */
    __HAL_UNLOCK(hsdram);
  }
  else
  {
    return  HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_SDRAM_Write_8b(SDRAM_HandleTypeDef *hsdram, uint32_t *pAddress, uint8_t *pSrcBuffer,
                                     uint32_t BufferSize)
{
  uint32_t size;
  __IO uint8_t *pSdramAddress = (uint8_t *)pAddress;
  uint8_t *psrcbuff = pSrcBuffer;

  /* Check the SDRAM controller state */
  if (hsdram->State == HAL_SDRAM_STATE_BUSY)
  {
    return HAL_BUSY;
  }
  else if (hsdram->State == HAL_SDRAM_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hsdram);

    /* Update the SDRAM controller state */
    hsdram->State = HAL_SDRAM_STATE_BUSY;

    /* Write data to memory */
    for (size = BufferSize; size != 0U; size--)
    {
      FMC_MEMORY_WRITE8(pSdramAddress, *psrcbuff);
      psrcbuff++;
      pSdramAddress++;
    }

    /* Update the SDRAM controller state */
    hsdram->State = HAL_SDRAM_STATE_READY;

    /* Process Unlocked */
    __HAL_UNLOCK(hsdram);
  }
  else
  {
    return  HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_SDRAM_Read_16b(SDRAM_HandleTypeDef *hsdram, uint32_t *pAddress, uint16_t *pDstBuffer,
                                     uint32_t BufferSize)
{
  uint32_t size;
  __IO uint32_t *pSdramAddress = pAddress;
  uint16_t *pdestbuff = pDstBuffer;
  HAL_SDRAM_StateTypeDef state = hsdram->State;

  /* Check the SDRAM controller state */
  if (state == HAL_SDRAM_STATE_BUSY)
  {
    return HAL_BUSY;
  }
  else if ((state == HAL_SDRAM_STATE_READY) || (state == HAL_SDRAM_STATE_WRITE_PROTECTED))
  {
    /* Process Locked */
    __HAL_LOCK(hsdram);

    /* Update the SDRAM controller state */
    hsdram->State = HAL_SDRAM_STATE_BUSY;

    /* Read data from memory */
    for (size = BufferSize; size >= 2U ; size -= 2U)
    {
      *pdestbuff = (uint16_t)((FMC_MEMORY_READ32(pSdramAddress)) & 0x0000FFFFU);
      pdestbuff++;
      *pdestbuff = (uint16_t)(((FMC_MEMORY_READ32(pSdramAddress)) & 0xFFFF0000U) >> 16U);
      pdestbuff++;
      pSdramAddress++;
    }

    /* Read last 16-bits if size is not 32-bits multiple */
    if ((BufferSize % 2U) != 0U)
    {
      *pdestbuff = (uint16_t)((FMC_MEMORY_READ32(pSdramAddress)) & 0x0000FFFFU);
    }

    /* Update the SDRAM controller state */
    hsdram->State = state;

    /* Process Unlocked */
    __HAL_UNLOCK(hsdram);
  }
  else
  {
    return  HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_SDRAM_Write_16b(SDRAM_HandleTypeDef *hsdram, uint32_t *pAddress, uint16_t *pSrcBuffer,
                                      uint32_t BufferSize)
{
  uint32_t size;
  __IO uint32_t *psdramaddress = pAddress;
  uint16_t *psrcbuff = pSrcBuffer;

  /* Check the SDRAM controller state */
  if (hsdram->State == HAL_SDRAM_STATE_BUSY)
  {
    return HAL_BUSY;
  }
  else if (hsdram->State == HAL_SDRAM_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hsdram);

    /* Update the SDRAM controller state */
    hsdram->State = HAL_SDRAM_STATE_BUSY;

    /* Write data to memory */
    for (size = BufferSize; size >= 2U ; size -= 2U)
    {
      FMC_MEMORY_WRITE32(psdramaddress, (uint32_t)(*psrcbuff));
      psrcbuff++;
      FMC_MEMORY_WRITE32(psdramaddress, (FMC_MEMORY_READ32(psdramaddress) | (((uint32_t)(*psrcbuff) << 16U))));
      psrcbuff++;
      psdramaddress++;
    }

    /* Write last 16-bits if size is not 32-bits multiple */
    if ((BufferSize % 2U) != 0U)
    {
      FMC_MEMORY_WRITE32(psdramaddress, ((uint32_t)(*psrcbuff) & 0x0000FFFFU) | ((FMC_MEMORY_READ32(psdramaddress)) & 0xFFFF0000U));
    }

    /* Update the SDRAM controller state */
    hsdram->State = HAL_SDRAM_STATE_READY;

    /* Process Unlocked */
    __HAL_UNLOCK(hsdram);
  }
  else
  {
    return  HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_SDRAM_Read_32b(SDRAM_HandleTypeDef *hsdram, uint32_t *pAddress, uint32_t *pDstBuffer,
                                     uint32_t BufferSize)
{
  uint32_t size;
  __IO uint32_t *pSdramAddress = (uint32_t *)pAddress;
  uint32_t *pdestbuff = pDstBuffer;
  HAL_SDRAM_StateTypeDef state = hsdram->State;

  /* Check the SDRAM controller state */
  if (state == HAL_SDRAM_STATE_BUSY)
  {
    return HAL_BUSY;
  }
  else if ((state == HAL_SDRAM_STATE_READY) || (state == HAL_SDRAM_STATE_WRITE_PROTECTED))
  {
    /* Process Locked */
    __HAL_LOCK(hsdram);

    /* Update the SDRAM controller state */
    hsdram->State = HAL_SDRAM_STATE_BUSY;

    /* Read data from source */
    for (size = BufferSize; size != 0U; size--)
    {
      *pdestbuff = FMC_MEMORY_READ32(pSdramAddress);
      pdestbuff++;
      pSdramAddress++;
    }

    /* Update the SDRAM controller state */
    hsdram->State = state;

    /* Process Unlocked */
    __HAL_UNLOCK(hsdram);
  }
  else
  {
    return  HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_SDRAM_Write_32b(SDRAM_HandleTypeDef *hsdram, uint32_t *pAddress, uint32_t *pSrcBuffer,
                                      uint32_t BufferSize)
{
  uint32_t size;
  __IO uint32_t *pSdramAddress = pAddress;
  uint32_t *psrcbuff = pSrcBuffer;

  /* Check the SDRAM controller state */
  if (hsdram->State == HAL_SDRAM_STATE_BUSY)
  {
    return HAL_BUSY;
  }
  else if (hsdram->State == HAL_SDRAM_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hsdram);

    /* Update the SDRAM controller state */
    hsdram->State = HAL_SDRAM_STATE_BUSY;

    /* Write data to memory */
    for (size = BufferSize; size != 0U; size--)
    {
      FMC_MEMORY_WRITE32(pSdramAddress, *psrcbuff);
      psrcbuff++;
      pSdramAddress++;
    }

    /* Update the SDRAM controller state */
    hsdram->State = HAL_SDRAM_STATE_READY;

    /* Process Unlocked */
    __HAL_UNLOCK(hsdram);
  }
  else
  {
    return  HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_SDRAM_Read_DMA(SDRAM_HandleTypeDef *hsdram, uint32_t *pAddress, uint32_t *pDstBuffer,
                                     uint32_t BufferSize)
{
  HAL_StatusTypeDef status;
  HAL_SDRAM_StateTypeDef state = hsdram->State;
  uint32_t size;
  uint32_t data_width;

  /* Check the SDRAM controller state */
  if (state == HAL_SDRAM_STATE_BUSY)
  {
    status = HAL_BUSY;
  }
  else if ((state == HAL_SDRAM_STATE_READY) || (state == HAL_SDRAM_STATE_WRITE_PROTECTED))
  {
    /* Process Locked */
    __HAL_LOCK(hsdram);

    /* Update the SDRAM controller state */
    hsdram->State = HAL_SDRAM_STATE_BUSY;

    /* Configure DMA user callbacks */
    if (state == HAL_SDRAM_STATE_READY)
    {
      hsdram->hdma->XferCpltCallback = SDRAM_DMACplt;
    }
    else
    {
      hsdram->hdma->XferCpltCallback = SDRAM_DMACpltProt;
    }
    hsdram->hdma->XferErrorCallback = SDRAM_DMAError;

    if ((hsdram->hdma->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
    {
      if ((hsdram->hdma->LinkedListQueue != 0U) && (hsdram->hdma->LinkedListQueue->Head != 0U))
      {
        /* Check destination data width and set the size to be transferred */
        data_width = hsdram->hdma->LinkedListQueue->Head->LinkRegisters[NODE_CTR1_DEFAULT_OFFSET] & DMA_CTR1_DDW_LOG2;

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
        hsdram->hdma->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = size;
        /* Set DMA source address */
        hsdram->hdma->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = (uint32_t)(uintptr_t)pAddress;
        /* Set DMA destination address */
        hsdram->hdma->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = (uint32_t)(uintptr_t)pDstBuffer;

        /* Enable the DMA Stream */
        status = HAL_DMAEx_List_Start_IT(hsdram->hdma);
      }
      else
      {
        /* Process Unlocked */
        __HAL_UNLOCK(hsdram);

        status = HAL_ERROR;
      }
    }
    else
    {
      /* Check destination data width and set the size to be transferred */
      data_width = hsdram->hdma->Init.DestDataWidth;

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
      status = HAL_DMA_Start_IT(hsdram->hdma, (uint32_t)(uintptr_t)pAddress, (uint32_t)(uintptr_t)pDstBuffer, size);
    }

    /* Process Unlocked */
    __HAL_UNLOCK(hsdram);
  }
  else
  {
    status = HAL_ERROR;
  }

  return status;
}

HAL_StatusTypeDef HAL_SDRAM_Write_DMA(SDRAM_HandleTypeDef *hsdram, uint32_t *pAddress, uint32_t *pSrcBuffer,
                                      uint32_t BufferSize)
{
  HAL_StatusTypeDef status;
  uint32_t size;
  uint32_t data_width;

  /* Check the SDRAM controller state */
  if (hsdram->State == HAL_SDRAM_STATE_BUSY)
  {
    status = HAL_BUSY;
  }
  else if (hsdram->State == HAL_SDRAM_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hsdram);

    /* Update the SDRAM controller state */
    hsdram->State = HAL_SDRAM_STATE_BUSY;

    /* Configure DMA user callbacks */
    hsdram->hdma->XferCpltCallback = SDRAM_DMACplt;
    hsdram->hdma->XferErrorCallback = SDRAM_DMAError;

    if ((hsdram->hdma->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
    {
      if ((hsdram->hdma->LinkedListQueue != 0U) && (hsdram->hdma->LinkedListQueue->Head != 0U))
      {
        /* Check destination data width and set the size to be transferred */
        data_width = hsdram->hdma->LinkedListQueue->Head->LinkRegisters[NODE_CTR1_DEFAULT_OFFSET] & DMA_CTR1_DDW_LOG2;

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
        hsdram->hdma->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = size;
        /* Set DMA source address */
        hsdram->hdma->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = (uint32_t)(uintptr_t)pSrcBuffer;
        /* Set DMA destination address */
        hsdram->hdma->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = (uint32_t)(uintptr_t)pAddress;

        /* Enable the DMA Stream */
        status = HAL_DMAEx_List_Start_IT(hsdram->hdma);
      }
      else
      {
        /* Process Unlocked */
        __HAL_UNLOCK(hsdram);

        status = HAL_ERROR;
      }
    }
    else
    {
      /* Check destination data width and set the size to be transferred */
      data_width = hsdram->hdma->Init.DestDataWidth;

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
      status = HAL_DMA_Start_IT(hsdram->hdma, (uint32_t)(uintptr_t)pSrcBuffer, (uint32_t)(uintptr_t)pAddress, size);
    }

    /* Process Unlocked */
    __HAL_UNLOCK(hsdram);
  }
  else
  {
    status = HAL_ERROR;
  }

  return status;
}

#if USE_HAL_SDRAM_REGISTER_CALLBACKS
HAL_StatusTypeDef HAL_SDRAM_RegisterCallback(SDRAM_HandleTypeDef *hsdram, HAL_SDRAM_CallbackIDTypeDef CallbackId,
                                             pSDRAM_CallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;
  HAL_SDRAM_StateTypeDef state;

  if (pCallback == NULL)
  {
    return HAL_ERROR;
  }

  state = hsdram->State;
  if ((state == HAL_SDRAM_STATE_READY) || (state == HAL_SDRAM_STATE_WRITE_PROTECTED))
  {
    switch (CallbackId)
    {
      case HAL_SDRAM_MSP_INIT_CB_ID :
        hsdram->MspInitCallback = pCallback;
        break;
      case HAL_SDRAM_MSP_DEINIT_CB_ID :
        hsdram->MspDeInitCallback = pCallback;
        break;
      case HAL_SDRAM_REFRESH_ERR_CB_ID :
        hsdram->RefreshErrorCallback = pCallback;
        break;
      default :
        /* update return status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (hsdram->State == HAL_SDRAM_STATE_RESET)
  {
    switch (CallbackId)
    {
      case HAL_SDRAM_MSP_INIT_CB_ID :
        hsdram->MspInitCallback = pCallback;
        break;
      case HAL_SDRAM_MSP_DEINIT_CB_ID :
        hsdram->MspDeInitCallback = pCallback;
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

#if USE_HAL_SDRAM_REGISTER_CALLBACKS
HAL_StatusTypeDef HAL_SDRAM_UnRegisterCallback(SDRAM_HandleTypeDef *hsdram, HAL_SDRAM_CallbackIDTypeDef CallbackId)
{
  HAL_StatusTypeDef status = HAL_OK;
  HAL_SDRAM_StateTypeDef state;

  state = hsdram->State;
  if ((state == HAL_SDRAM_STATE_READY) || (state == HAL_SDRAM_STATE_WRITE_PROTECTED))
  {
    switch (CallbackId)
    {
      case HAL_SDRAM_MSP_INIT_CB_ID :
        hsdram->MspInitCallback = HAL_SDRAM_MspInit;
        break;
      case HAL_SDRAM_MSP_DEINIT_CB_ID :
        hsdram->MspDeInitCallback = HAL_SDRAM_MspDeInit;
        break;
      case HAL_SDRAM_REFRESH_ERR_CB_ID :
        hsdram->RefreshErrorCallback = HAL_SDRAM_RefreshErrorCallback;
        break;
      case HAL_SDRAM_DMA_XFER_CPLT_CB_ID :
        hsdram->DmaXferCpltCallback = HAL_SDRAM_DMA_XferCpltCallback;
        break;
      case HAL_SDRAM_DMA_XFER_ERR_CB_ID :
        hsdram->DmaXferErrorCallback = HAL_SDRAM_DMA_XferErrorCallback;
        break;
      default :
        /* update return status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (hsdram->State == HAL_SDRAM_STATE_RESET)
  {
    switch (CallbackId)
    {
      case HAL_SDRAM_MSP_INIT_CB_ID :
        hsdram->MspInitCallback = HAL_SDRAM_MspInit;
        break;
      case HAL_SDRAM_MSP_DEINIT_CB_ID :
        hsdram->MspDeInitCallback = HAL_SDRAM_MspDeInit;
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

#if USE_HAL_SDRAM_REGISTER_CALLBACKS
HAL_StatusTypeDef HAL_SDRAM_RegisterDmaCallback(SDRAM_HandleTypeDef *hsdram, HAL_SDRAM_CallbackIDTypeDef CallbackId,
                                                pSDRAM_DmaCallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;
  HAL_SDRAM_StateTypeDef state;

  if (pCallback == NULL)
  {
    return HAL_ERROR;
  }

  /* Process locked */
  __HAL_LOCK(hsdram);

  state = hsdram->State;
  if ((state == HAL_SDRAM_STATE_READY) || (state == HAL_SDRAM_STATE_WRITE_PROTECTED))
  {
    switch (CallbackId)
    {
      case HAL_SDRAM_DMA_XFER_CPLT_CB_ID :
        hsdram->DmaXferCpltCallback = pCallback;
        break;
      case HAL_SDRAM_DMA_XFER_ERR_CB_ID :
        hsdram->DmaXferErrorCallback = pCallback;
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
  __HAL_UNLOCK(hsdram);
  return status;
}
#endif

HAL_StatusTypeDef HAL_SDRAM_WriteProtection_Enable(SDRAM_HandleTypeDef *hsdram)
{
  /* Check the SDRAM controller state */
  if (hsdram->State == HAL_SDRAM_STATE_BUSY)
  {
    return HAL_BUSY;
  }
  else if (hsdram->State == HAL_SDRAM_STATE_READY)
  {
    /* Update the SDRAM state */
    hsdram->State = HAL_SDRAM_STATE_BUSY;

    /* Enable write protection */
    (void)FMC_SDRAM_WriteProtection_Enable(hsdram->Instance, hsdram->Init.SDBank);

    /* Update the SDRAM state */
    hsdram->State = HAL_SDRAM_STATE_WRITE_PROTECTED;
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_SDRAM_WriteProtection_Disable(SDRAM_HandleTypeDef *hsdram)
{
  HAL_SDRAM_StateTypeDef state = hsdram->State;

  /* Check the SDRAM controller state */
  if (state == HAL_SDRAM_STATE_BUSY)
  {
    return HAL_BUSY;
  }
  else if (state == HAL_SDRAM_STATE_WRITE_PROTECTED)
  {
    /* Update the SDRAM state */
    hsdram->State = HAL_SDRAM_STATE_BUSY;

    /* Disable write protection */
    (void)FMC_SDRAM_WriteProtection_Disable(hsdram->Instance, hsdram->Init.SDBank);

    /* Update the SDRAM state */
    hsdram->State = HAL_SDRAM_STATE_READY;
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_SDRAM_SendCommand(SDRAM_HandleTypeDef *hsdram, FMC_SDRAM_CommandTypeDef *Command,
                                        uint32_t Timeout)
{
  HAL_SDRAM_StateTypeDef state = hsdram->State;

  /* Check the SDRAM controller state */
  if (state == HAL_SDRAM_STATE_BUSY)
  {
    return HAL_BUSY;
  }
  else if ((state == HAL_SDRAM_STATE_READY) || (state == HAL_SDRAM_STATE_PRECHARGED))
  {
    /* Update the SDRAM state */
    hsdram->State = HAL_SDRAM_STATE_BUSY;

    /* Send SDRAM command */
    (void)FMC_SDRAM_SendCommand(hsdram->Instance, Command, Timeout);

    /* Update the SDRAM controller state state */
    if (Command->CommandMode == FMC_SDRAM_CMD_PALL)
    {
      hsdram->State = HAL_SDRAM_STATE_PRECHARGED;
    }
    else
    {
      hsdram->State = HAL_SDRAM_STATE_READY;
    }
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_SDRAM_ProgramRefreshRate(SDRAM_HandleTypeDef *hsdram, uint32_t RefreshRate)
{
  /* Check the SDRAM controller state */
  if (hsdram->State == HAL_SDRAM_STATE_BUSY)
  {
    return HAL_BUSY;
  }
  else if (hsdram->State == HAL_SDRAM_STATE_READY)
  {
    /* Update the SDRAM state */
    hsdram->State = HAL_SDRAM_STATE_BUSY;

    /* Program the refresh rate */
    (void)FMC_SDRAM_ProgramRefreshRate(hsdram->Instance, RefreshRate);

    /* Update the SDRAM state */
    hsdram->State = HAL_SDRAM_STATE_READY;
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_SDRAM_SetAutoRefreshNumber(SDRAM_HandleTypeDef *hsdram, uint32_t AutoRefreshNumber)
{
  /* Check the SDRAM controller state */
  if (hsdram->State == HAL_SDRAM_STATE_BUSY)
  {
    return HAL_BUSY;
  }
  else if (hsdram->State == HAL_SDRAM_STATE_READY)
  {
    /* Update the SDRAM state */
    hsdram->State = HAL_SDRAM_STATE_BUSY;

    /* Set the Auto-Refresh number */
    (void)FMC_SDRAM_SetAutoRefreshNumber(hsdram->Instance, AutoRefreshNumber);

    /* Update the SDRAM state */
    hsdram->State = HAL_SDRAM_STATE_READY;
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

uint32_t HAL_SDRAM_GetModeStatus(SDRAM_HandleTypeDef *hsdram)
{
  /* Return the SDRAM memory current mode */
  return (FMC_SDRAM_GetModeStatus(hsdram->Instance, hsdram->Init.SDBank));
}

HAL_SDRAM_StateTypeDef HAL_SDRAM_GetState(const SDRAM_HandleTypeDef *hsdram)
{
  return hsdram->State;
}

static void SDRAM_DMACplt(DMA_HandleTypeDef *hdma)
{
  /* Derogation MISRAC2012-Rule-11.5 */
  SDRAM_HandleTypeDef *hsdram = (SDRAM_HandleTypeDef *)(hdma->Parent);

  /* Disable the DMA channel */
  __HAL_DMA_DISABLE(hdma);

  /* Update the SDRAM controller state */
  hsdram->State = HAL_SDRAM_STATE_READY;

#if (USE_HAL_SDRAM_REGISTER_CALLBACKS == 1)
  hsdram->DmaXferCpltCallback(hdma);
#else
  HAL_SDRAM_DMA_XferCpltCallback(hdma);
#endif /* USE_HAL_SDRAM_REGISTER_CALLBACKS */
}

static void SDRAM_DMACpltProt(DMA_HandleTypeDef *hdma)
{
  /* Derogation MISRAC2012-Rule-11.5 */
  SDRAM_HandleTypeDef *hsdram = (SDRAM_HandleTypeDef *)(hdma->Parent);

  /* Disable the DMA channel */
  __HAL_DMA_DISABLE(hdma);

  /* Update the SDRAM controller state */
  hsdram->State = HAL_SDRAM_STATE_WRITE_PROTECTED;

#if (USE_HAL_SDRAM_REGISTER_CALLBACKS == 1)
  hsdram->DmaXferCpltCallback(hdma);
#else
  HAL_SDRAM_DMA_XferCpltCallback(hdma);
#endif /* USE_HAL_SDRAM_REGISTER_CALLBACKS */
}

static void SDRAM_DMAError(DMA_HandleTypeDef *hdma)
{
  /* Derogation MISRAC2012-Rule-11.5 */
  SDRAM_HandleTypeDef *hsdram = (SDRAM_HandleTypeDef *)(hdma->Parent);

  /* Disable the DMA channel */
  __HAL_DMA_DISABLE(hdma);

  /* Update the SDRAM controller state */
  hsdram->State = HAL_SDRAM_STATE_ERROR;

#if (USE_HAL_SDRAM_REGISTER_CALLBACKS == 1)
  hsdram->DmaXferErrorCallback(hdma);
#else
  HAL_SDRAM_DMA_XferErrorCallback(hdma);
#endif /* USE_HAL_SDRAM_REGISTER_CALLBACKS */
}
