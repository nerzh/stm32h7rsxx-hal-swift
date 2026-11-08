// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2C/I2CEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Init(I2C_HandleTypeDef *hi2c)
{
  /* Check the I2C handle allocation */
  if (hi2c == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_I2C_ALL_INSTANCE(hi2c->Instance));
  assert_param(IS_I2C_OWN_ADDRESS1(hi2c->Init.OwnAddress1));
  assert_param(IS_I2C_ADDRESSING_MODE(hi2c->Init.AddressingMode));
  assert_param(IS_I2C_DUAL_ADDRESS(hi2c->Init.DualAddressMode));
  assert_param(IS_I2C_OWN_ADDRESS2(hi2c->Init.OwnAddress2));
  assert_param(IS_I2C_OWN_ADDRESS2_MASK(hi2c->Init.OwnAddress2Masks));
  assert_param(IS_I2C_GENERAL_CALL(hi2c->Init.GeneralCallMode));
  assert_param(IS_I2C_NO_STRETCH(hi2c->Init.NoStretchMode));

  if (hi2c->State == HAL_I2C_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    hi2c->Lock = HAL_UNLOCKED;

#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
    /* Init the I2C Callback settings */
    hi2c->MasterTxCpltCallback = HAL_I2C_MasterTxCpltCallback; /* Legacy weak MasterTxCpltCallback */
    hi2c->MasterRxCpltCallback = HAL_I2C_MasterRxCpltCallback; /* Legacy weak MasterRxCpltCallback */
    hi2c->SlaveTxCpltCallback  = HAL_I2C_SlaveTxCpltCallback;  /* Legacy weak SlaveTxCpltCallback  */
    hi2c->SlaveRxCpltCallback  = HAL_I2C_SlaveRxCpltCallback;  /* Legacy weak SlaveRxCpltCallback  */
    hi2c->ListenCpltCallback   = HAL_I2C_ListenCpltCallback;   /* Legacy weak ListenCpltCallback   */
    hi2c->MemTxCpltCallback    = HAL_I2C_MemTxCpltCallback;    /* Legacy weak MemTxCpltCallback    */
    hi2c->MemRxCpltCallback    = HAL_I2C_MemRxCpltCallback;    /* Legacy weak MemRxCpltCallback    */
    hi2c->ErrorCallback        = HAL_I2C_ErrorCallback;        /* Legacy weak ErrorCallback        */
    hi2c->AbortCpltCallback    = HAL_I2C_AbortCpltCallback;    /* Legacy weak AbortCpltCallback    */
    hi2c->AddrCallback         = HAL_I2C_AddrCallback;         /* Legacy weak AddrCallback         */

    if (hi2c->MspInitCallback == NULL)
    {
      hi2c->MspInitCallback = HAL_I2C_MspInit; /* Legacy weak MspInit  */
    }

    /* Init the low level hardware : GPIO, CLOCK, CORTEX...etc */
    hi2c->MspInitCallback(hi2c);
#else
    /* Init the low level hardware : GPIO, CLOCK, CORTEX...etc */
    HAL_I2C_MspInit(hi2c);
#endif /* USE_HAL_I2C_REGISTER_CALLBACKS */
  }

  hi2c->State = HAL_I2C_STATE_BUSY;

  /* Disable the selected I2C peripheral */
  __HAL_I2C_DISABLE(hi2c);

  /*---------------------------- I2Cx TIMINGR Configuration ------------------*/
  /* Configure I2Cx: Frequency range */
  hi2c->Instance->TIMINGR = hi2c->Init.Timing & TIMING_CLEAR_MASK;

  /*---------------------------- I2Cx OAR1 Configuration ---------------------*/
  /* Disable Own Address1 before set the Own Address1 configuration */
  hi2c->Instance->OAR1 &= ~I2C_OAR1_OA1EN;

  /* Configure I2Cx: Own Address1 and ack own address1 mode */
  if (hi2c->Init.AddressingMode == I2C_ADDRESSINGMODE_7BIT)
  {
    hi2c->Instance->OAR1 = (I2C_OAR1_OA1EN | hi2c->Init.OwnAddress1);
  }
  else /* I2C_ADDRESSINGMODE_10BIT */
  {
    hi2c->Instance->OAR1 = (I2C_OAR1_OA1EN | I2C_OAR1_OA1MODE | hi2c->Init.OwnAddress1);
  }

  /*---------------------------- I2Cx CR2 Configuration ----------------------*/
  /* Configure I2Cx: Addressing Master mode */
  if (hi2c->Init.AddressingMode == I2C_ADDRESSINGMODE_10BIT)
  {
    SET_BIT(hi2c->Instance->CR2, I2C_CR2_ADD10);
  }
  else
  {
    /* Clear the I2C ADD10 bit */
    CLEAR_BIT(hi2c->Instance->CR2, I2C_CR2_ADD10);
  }
  /* Enable the AUTOEND by default, and enable NACK (should be disable only during Slave process */
  hi2c->Instance->CR2 |= (I2C_CR2_AUTOEND | I2C_CR2_NACK);

  /*---------------------------- I2Cx OAR2 Configuration ---------------------*/
  /* Disable Own Address2 before set the Own Address2 configuration */
  hi2c->Instance->OAR2 &= ~I2C_DUALADDRESS_ENABLE;

  /* Configure I2Cx: Dual mode and Own Address2 */
  hi2c->Instance->OAR2 = (hi2c->Init.DualAddressMode | hi2c->Init.OwnAddress2 | \
                          (hi2c->Init.OwnAddress2Masks << 8));

  /*---------------------------- I2Cx CR1 Configuration ----------------------*/
  /* Configure I2Cx: Generalcall and NoStretch mode */
  hi2c->Instance->CR1 = (hi2c->Init.GeneralCallMode | hi2c->Init.NoStretchMode);

  /* Enable the selected I2C peripheral */
  __HAL_I2C_ENABLE(hi2c);

  hi2c->ErrorCode = HAL_I2C_ERROR_NONE;
  hi2c->State = HAL_I2C_STATE_READY;
  hi2c->PreviousState = I2C_STATE_NONE;
  hi2c->Mode = HAL_I2C_MODE_NONE;

  return HAL_OK;
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_DeInit(I2C_HandleTypeDef *hi2c)
{
  /* Check the I2C handle allocation */
  if (hi2c == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_I2C_ALL_INSTANCE(hi2c->Instance));

  hi2c->State = HAL_I2C_STATE_BUSY;

  /* Disable the I2C Peripheral Clock */
  __HAL_I2C_DISABLE(hi2c);

#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
  if (hi2c->MspDeInitCallback == NULL)
  {
    hi2c->MspDeInitCallback = HAL_I2C_MspDeInit; /* Legacy weak MspDeInit  */
  }

  /* DeInit the low level hardware: GPIO, CLOCK, NVIC */
  hi2c->MspDeInitCallback(hi2c);
#else
  /* DeInit the low level hardware: GPIO, CLOCK, NVIC */
  HAL_I2C_MspDeInit(hi2c);
#endif /* USE_HAL_I2C_REGISTER_CALLBACKS */

  hi2c->ErrorCode = HAL_I2C_ERROR_NONE;
  hi2c->State = HAL_I2C_STATE_RESET;
  hi2c->PreviousState = I2C_STATE_NONE;
  hi2c->Mode = HAL_I2C_MODE_NONE;

  /* Release Lock */
  __HAL_UNLOCK(hi2c);

  return HAL_OK;
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_I2C_RegisterCallback(I2C_HandleTypeDef *hi2c, HAL_I2C_CallbackIDTypeDef CallbackID,
                                           pI2C_CallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hi2c->ErrorCode |= HAL_I2C_ERROR_INVALID_CALLBACK;

    return HAL_ERROR;
  }

  if (HAL_I2C_STATE_READY == hi2c->State)
  {
    switch (CallbackID)
    {
      case HAL_I2C_MASTER_TX_COMPLETE_CB_ID :
        hi2c->MasterTxCpltCallback = pCallback;
        break;

      case HAL_I2C_MASTER_RX_COMPLETE_CB_ID :
        hi2c->MasterRxCpltCallback = pCallback;
        break;

      case HAL_I2C_SLAVE_TX_COMPLETE_CB_ID :
        hi2c->SlaveTxCpltCallback = pCallback;
        break;

      case HAL_I2C_SLAVE_RX_COMPLETE_CB_ID :
        hi2c->SlaveRxCpltCallback = pCallback;
        break;

      case HAL_I2C_LISTEN_COMPLETE_CB_ID :
        hi2c->ListenCpltCallback = pCallback;
        break;

      case HAL_I2C_MEM_TX_COMPLETE_CB_ID :
        hi2c->MemTxCpltCallback = pCallback;
        break;

      case HAL_I2C_MEM_RX_COMPLETE_CB_ID :
        hi2c->MemRxCpltCallback = pCallback;
        break;

      case HAL_I2C_ERROR_CB_ID :
        hi2c->ErrorCallback = pCallback;
        break;

      case HAL_I2C_ABORT_CB_ID :
        hi2c->AbortCpltCallback = pCallback;
        break;

      case HAL_I2C_MSPINIT_CB_ID :
        hi2c->MspInitCallback = pCallback;
        break;

      case HAL_I2C_MSPDEINIT_CB_ID :
        hi2c->MspDeInitCallback = pCallback;
        break;

      default :
        /* Update the error code */
        hi2c->ErrorCode |= HAL_I2C_ERROR_INVALID_CALLBACK;

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (HAL_I2C_STATE_RESET == hi2c->State)
  {
    switch (CallbackID)
    {
      case HAL_I2C_MSPINIT_CB_ID :
        hi2c->MspInitCallback = pCallback;
        break;

      case HAL_I2C_MSPDEINIT_CB_ID :
        hi2c->MspDeInitCallback = pCallback;
        break;

      default :
        /* Update the error code */
        hi2c->ErrorCode |= HAL_I2C_ERROR_INVALID_CALLBACK;

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hi2c->ErrorCode |= HAL_I2C_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_I2C_UnRegisterCallback(I2C_HandleTypeDef *hi2c, HAL_I2C_CallbackIDTypeDef CallbackID)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (HAL_I2C_STATE_READY == hi2c->State)
  {
    switch (CallbackID)
    {
      case HAL_I2C_MASTER_TX_COMPLETE_CB_ID :
        hi2c->MasterTxCpltCallback = HAL_I2C_MasterTxCpltCallback; /* Legacy weak MasterTxCpltCallback */
        break;

      case HAL_I2C_MASTER_RX_COMPLETE_CB_ID :
        hi2c->MasterRxCpltCallback = HAL_I2C_MasterRxCpltCallback; /* Legacy weak MasterRxCpltCallback */
        break;

      case HAL_I2C_SLAVE_TX_COMPLETE_CB_ID :
        hi2c->SlaveTxCpltCallback = HAL_I2C_SlaveTxCpltCallback;   /* Legacy weak SlaveTxCpltCallback  */
        break;

      case HAL_I2C_SLAVE_RX_COMPLETE_CB_ID :
        hi2c->SlaveRxCpltCallback = HAL_I2C_SlaveRxCpltCallback;   /* Legacy weak SlaveRxCpltCallback  */
        break;

      case HAL_I2C_LISTEN_COMPLETE_CB_ID :
        hi2c->ListenCpltCallback = HAL_I2C_ListenCpltCallback;     /* Legacy weak ListenCpltCallback   */
        break;

      case HAL_I2C_MEM_TX_COMPLETE_CB_ID :
        hi2c->MemTxCpltCallback = HAL_I2C_MemTxCpltCallback;       /* Legacy weak MemTxCpltCallback    */
        break;

      case HAL_I2C_MEM_RX_COMPLETE_CB_ID :
        hi2c->MemRxCpltCallback = HAL_I2C_MemRxCpltCallback;       /* Legacy weak MemRxCpltCallback    */
        break;

      case HAL_I2C_ERROR_CB_ID :
        hi2c->ErrorCallback = HAL_I2C_ErrorCallback;               /* Legacy weak ErrorCallback        */
        break;

      case HAL_I2C_ABORT_CB_ID :
        hi2c->AbortCpltCallback = HAL_I2C_AbortCpltCallback;       /* Legacy weak AbortCpltCallback    */
        break;

      case HAL_I2C_MSPINIT_CB_ID :
        hi2c->MspInitCallback = HAL_I2C_MspInit;                   /* Legacy weak MspInit              */
        break;

      case HAL_I2C_MSPDEINIT_CB_ID :
        hi2c->MspDeInitCallback = HAL_I2C_MspDeInit;               /* Legacy weak MspDeInit            */
        break;

      default :
        /* Update the error code */
        hi2c->ErrorCode |= HAL_I2C_ERROR_INVALID_CALLBACK;

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (HAL_I2C_STATE_RESET == hi2c->State)
  {
    switch (CallbackID)
    {
      case HAL_I2C_MSPINIT_CB_ID :
        hi2c->MspInitCallback = HAL_I2C_MspInit;                   /* Legacy weak MspInit              */
        break;

      case HAL_I2C_MSPDEINIT_CB_ID :
        hi2c->MspDeInitCallback = HAL_I2C_MspDeInit;               /* Legacy weak MspDeInit            */
        break;

      default :
        /* Update the error code */
        hi2c->ErrorCode |= HAL_I2C_ERROR_INVALID_CALLBACK;

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hi2c->ErrorCode |= HAL_I2C_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_I2C_RegisterAddrCallback(I2C_HandleTypeDef *hi2c, pI2C_AddrCallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hi2c->ErrorCode |= HAL_I2C_ERROR_INVALID_CALLBACK;

    return HAL_ERROR;
  }

  if (HAL_I2C_STATE_READY == hi2c->State)
  {
    hi2c->AddrCallback = pCallback;
  }
  else
  {
    /* Update the error code */
    hi2c->ErrorCode |= HAL_I2C_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_I2C_UnRegisterAddrCallback(I2C_HandleTypeDef *hi2c)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (HAL_I2C_STATE_READY == hi2c->State)
  {
    hi2c->AddrCallback = HAL_I2C_AddrCallback; /* Legacy weak AddrCallback  */
  }
  else
  {
    /* Update the error code */
    hi2c->ErrorCode |= HAL_I2C_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Master_Transmit(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint8_t *pData,
                                          uint16_t Size, uint32_t Timeout)
{
  uint32_t tickstart;

  if (hi2c->State == HAL_I2C_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hi2c);

    /* Init tickstart for timeout management*/
    tickstart = HAL_GetTick();

    if (I2C_WaitOnFlagUntilTimeout(hi2c, I2C_FLAG_BUSY, SET, I2C_TIMEOUT_BUSY, tickstart) != HAL_OK)
    {
      return HAL_ERROR;
    }

    hi2c->State     = HAL_I2C_STATE_BUSY_TX;
    hi2c->Mode      = HAL_I2C_MODE_MASTER;
    hi2c->ErrorCode = HAL_I2C_ERROR_NONE;

    /* Prepare transfer parameters */
    hi2c->pBuffPtr  = pData;
    hi2c->XferCount = Size;
    hi2c->XferISR   = NULL;

    /* Send Slave Address */
    /* Set NBYTES to write and reload if hi2c->XferCount > MAX_NBYTE_SIZE and generate RESTART */
    if (hi2c->XferCount > MAX_NBYTE_SIZE)
    {
      hi2c->XferSize = MAX_NBYTE_SIZE;
      I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, I2C_RELOAD_MODE,
                         I2C_GENERATE_START_WRITE);
    }
    else
    {
      hi2c->XferSize = hi2c->XferCount;
      I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, I2C_AUTOEND_MODE,
                         I2C_GENERATE_START_WRITE);
    }

    while (hi2c->XferCount > 0U)
    {
      /* Wait until TXIS flag is set */
      if (I2C_WaitOnTXISFlagUntilTimeout(hi2c, Timeout, tickstart) != HAL_OK)
      {
        return HAL_ERROR;
      }
      /* Write data to TXDR */
      hi2c->Instance->TXDR = *hi2c->pBuffPtr;

      /* Increment Buffer pointer */
      hi2c->pBuffPtr++;

      hi2c->XferCount--;
      hi2c->XferSize--;

      if ((hi2c->XferCount != 0U) && (hi2c->XferSize == 0U))
      {
        /* Wait until TCR flag is set */
        if (I2C_WaitOnFlagUntilTimeout(hi2c, I2C_FLAG_TCR, RESET, Timeout, tickstart) != HAL_OK)
        {
          return HAL_ERROR;
        }

        if (hi2c->XferCount > MAX_NBYTE_SIZE)
        {
          hi2c->XferSize = MAX_NBYTE_SIZE;
          I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, I2C_RELOAD_MODE,
                             I2C_NO_STARTSTOP);
        }
        else
        {
          hi2c->XferSize = hi2c->XferCount;
          I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, I2C_AUTOEND_MODE,
                             I2C_NO_STARTSTOP);
        }
      }
    }

    /* No need to Check TC flag, with AUTOEND mode the stop is automatically generated */
    /* Wait until STOPF flag is set */
    if (I2C_WaitOnSTOPFlagUntilTimeout(hi2c, Timeout, tickstart) != HAL_OK)
    {
      return HAL_ERROR;
    }

    /* Clear STOP Flag */
    __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_STOPF);

    /* Clear Configuration Register 2 */
    I2C_RESET_CR2(hi2c);

    hi2c->State = HAL_I2C_STATE_READY;
    hi2c->Mode  = HAL_I2C_MODE_NONE;

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Master_Receive(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint8_t *pData,
                                         uint16_t Size, uint32_t Timeout)
{
  uint32_t tickstart;

  if (hi2c->State == HAL_I2C_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hi2c);

    /* Init tickstart for timeout management*/
    tickstart = HAL_GetTick();

    if (I2C_WaitOnFlagUntilTimeout(hi2c, I2C_FLAG_BUSY, SET, I2C_TIMEOUT_BUSY, tickstart) != HAL_OK)
    {
      return HAL_ERROR;
    }

    hi2c->State     = HAL_I2C_STATE_BUSY_RX;
    hi2c->Mode      = HAL_I2C_MODE_MASTER;
    hi2c->ErrorCode = HAL_I2C_ERROR_NONE;

    /* Prepare transfer parameters */
    hi2c->pBuffPtr  = pData;
    hi2c->XferCount = Size;
    hi2c->XferISR   = NULL;

    /* Send Slave Address */
    /* Set NBYTES to write and reload if hi2c->XferCount > MAX_NBYTE_SIZE and generate RESTART */
    if (hi2c->XferCount > MAX_NBYTE_SIZE)
    {
      hi2c->XferSize = MAX_NBYTE_SIZE;
      I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, I2C_RELOAD_MODE,
                         I2C_GENERATE_START_READ);
    }
    else
    {
      hi2c->XferSize = hi2c->XferCount;
      I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, I2C_AUTOEND_MODE,
                         I2C_GENERATE_START_READ);
    }

    while (hi2c->XferCount > 0U)
    {
      /* Wait until RXNE flag is set */
      if (I2C_WaitOnRXNEFlagUntilTimeout(hi2c, Timeout, tickstart) != HAL_OK)
      {
        return HAL_ERROR;
      }

      /* Read data from RXDR */
      *hi2c->pBuffPtr = (uint8_t)hi2c->Instance->RXDR;

      /* Increment Buffer pointer */
      hi2c->pBuffPtr++;

      hi2c->XferSize--;
      hi2c->XferCount--;

      if ((hi2c->XferCount != 0U) && (hi2c->XferSize == 0U))
      {
        /* Wait until TCR flag is set */
        if (I2C_WaitOnFlagUntilTimeout(hi2c, I2C_FLAG_TCR, RESET, Timeout, tickstart) != HAL_OK)
        {
          return HAL_ERROR;
        }

        if (hi2c->XferCount > MAX_NBYTE_SIZE)
        {
          hi2c->XferSize = MAX_NBYTE_SIZE;
          I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, I2C_RELOAD_MODE,
                             I2C_NO_STARTSTOP);
        }
        else
        {
          hi2c->XferSize = hi2c->XferCount;
          I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, I2C_AUTOEND_MODE,
                             I2C_NO_STARTSTOP);
        }
      }
    }

    /* No need to Check TC flag, with AUTOEND mode the stop is automatically generated */
    /* Wait until STOPF flag is set */
    if (I2C_WaitOnSTOPFlagUntilTimeout(hi2c, Timeout, tickstart) != HAL_OK)
    {
      return HAL_ERROR;
    }

    /* Clear STOP Flag */
    __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_STOPF);

    /* Clear Configuration Register 2 */
    I2C_RESET_CR2(hi2c);

    hi2c->State = HAL_I2C_STATE_READY;
    hi2c->Mode  = HAL_I2C_MODE_NONE;

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Slave_Transmit(I2C_HandleTypeDef *hi2c, uint8_t *pData, uint16_t Size,
                                         uint32_t Timeout)
{
  uint32_t tickstart;
  uint16_t tmpXferCount;
  HAL_StatusTypeDef error;

  if (hi2c->State == HAL_I2C_STATE_READY)
  {
    if ((pData == NULL) || (Size == 0U))
    {
      hi2c->ErrorCode = HAL_I2C_ERROR_INVALID_PARAM;
      return  HAL_ERROR;
    }
    /* Process Locked */
    __HAL_LOCK(hi2c);

    /* Init tickstart for timeout management*/
    tickstart = HAL_GetTick();

    hi2c->State     = HAL_I2C_STATE_BUSY_TX;
    hi2c->Mode      = HAL_I2C_MODE_SLAVE;
    hi2c->ErrorCode = HAL_I2C_ERROR_NONE;

    /* Prepare transfer parameters */
    hi2c->pBuffPtr  = pData;
    hi2c->XferCount = Size;
    hi2c->XferISR   = NULL;

    /* Enable Address Acknowledge */
    hi2c->Instance->CR2 &= ~I2C_CR2_NACK;

    /* Preload TX data if no stretch enable */
    if (hi2c->Init.NoStretchMode == I2C_NOSTRETCH_ENABLE)
    {
      /* Preload TX register */
      /* Write data to TXDR */
      hi2c->Instance->TXDR = *hi2c->pBuffPtr;

      /* Increment Buffer pointer */
      hi2c->pBuffPtr++;

      hi2c->XferCount--;
    }

    /* Wait until ADDR flag is set */
    if (I2C_WaitOnFlagUntilTimeout(hi2c, I2C_FLAG_ADDR, RESET, Timeout, tickstart) != HAL_OK)
    {
      /* Disable Address Acknowledge */
      hi2c->Instance->CR2 |= I2C_CR2_NACK;

      /* Flush TX register */
      I2C_Flush_TXDR(hi2c);

      return HAL_ERROR;
    }

    /* Clear ADDR flag */
    __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_ADDR);

    /* If 10bit addressing mode is selected */
    if (hi2c->Init.AddressingMode == I2C_ADDRESSINGMODE_10BIT)
    {
      /* Wait until ADDR flag is set */
      if (I2C_WaitOnFlagUntilTimeout(hi2c, I2C_FLAG_ADDR, RESET, Timeout, tickstart) != HAL_OK)
      {
        /* Disable Address Acknowledge */
        hi2c->Instance->CR2 |= I2C_CR2_NACK;

        /* Flush TX register */
        I2C_Flush_TXDR(hi2c);

        return HAL_ERROR;
      }

      /* Clear ADDR flag */
      __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_ADDR);
    }

    /* Wait until DIR flag is set Transmitter mode */
    if (I2C_WaitOnFlagUntilTimeout(hi2c, I2C_FLAG_DIR, RESET, Timeout, tickstart) != HAL_OK)
    {
      /* Disable Address Acknowledge */
      hi2c->Instance->CR2 |= I2C_CR2_NACK;

      /* Flush TX register */
      I2C_Flush_TXDR(hi2c);

      return HAL_ERROR;
    }

    while (hi2c->XferCount > 0U)
    {
      /* Wait until TXIS flag is set */
      if (I2C_WaitOnTXISFlagUntilTimeout(hi2c, Timeout, tickstart) != HAL_OK)
      {
        /* Disable Address Acknowledge */
        hi2c->Instance->CR2 |= I2C_CR2_NACK;
        return HAL_ERROR;
      }

      /* Write data to TXDR */
      hi2c->Instance->TXDR = *hi2c->pBuffPtr;

      /* Increment Buffer pointer */
      hi2c->pBuffPtr++;

      hi2c->XferCount--;
    }

    /* Wait until AF flag is set */
    error = I2C_WaitOnFlagUntilTimeout(hi2c, I2C_FLAG_AF, RESET, Timeout, tickstart);

    if (error != HAL_OK)
    {
      /* Check that I2C transfer finished */
      /* if yes, normal use case, a NACK is sent by the MASTER when Transfer is finished */
      /* Mean XferCount == 0 */

      tmpXferCount = hi2c->XferCount;
      if ((hi2c->ErrorCode == HAL_I2C_ERROR_AF) && (tmpXferCount == 0U))
      {
        /* Reset ErrorCode to NONE */
        hi2c->ErrorCode = HAL_I2C_ERROR_NONE;
      }
      else
      {
        /* Disable Address Acknowledge */
        hi2c->Instance->CR2 |= I2C_CR2_NACK;
        return HAL_ERROR;
      }
    }
    else
    {
      /* Flush TX register */
      I2C_Flush_TXDR(hi2c);

      /* Clear AF flag */
      __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_AF);

      /* Wait until STOP flag is set */
      if (I2C_WaitOnSTOPFlagUntilTimeout(hi2c, Timeout, tickstart) != HAL_OK)
      {
        /* Disable Address Acknowledge */
        hi2c->Instance->CR2 |= I2C_CR2_NACK;

        return HAL_ERROR;
      }

      /* Clear STOP flag */
      __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_STOPF);
    }

    /* Wait until BUSY flag is reset */
    if (I2C_WaitOnFlagUntilTimeout(hi2c, I2C_FLAG_BUSY, SET, Timeout, tickstart) != HAL_OK)
    {
      /* Disable Address Acknowledge */
      hi2c->Instance->CR2 |= I2C_CR2_NACK;
      return HAL_ERROR;
    }

    /* Disable Address Acknowledge */
    hi2c->Instance->CR2 |= I2C_CR2_NACK;

    hi2c->State = HAL_I2C_STATE_READY;
    hi2c->Mode  = HAL_I2C_MODE_NONE;

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Slave_Receive(I2C_HandleTypeDef *hi2c, uint8_t *pData, uint16_t Size,
                                        uint32_t Timeout)
{
  uint32_t tickstart;

  if (hi2c->State == HAL_I2C_STATE_READY)
  {
    if ((pData == NULL) || (Size == 0U))
    {
      hi2c->ErrorCode = HAL_I2C_ERROR_INVALID_PARAM;
      return  HAL_ERROR;
    }
    /* Process Locked */
    __HAL_LOCK(hi2c);

    /* Init tickstart for timeout management*/
    tickstart = HAL_GetTick();

    hi2c->State     = HAL_I2C_STATE_BUSY_RX;
    hi2c->Mode      = HAL_I2C_MODE_SLAVE;
    hi2c->ErrorCode = HAL_I2C_ERROR_NONE;

    /* Prepare transfer parameters */
    hi2c->pBuffPtr  = pData;
    hi2c->XferCount = Size;
    hi2c->XferSize = hi2c->XferCount;
    hi2c->XferISR   = NULL;

    /* Enable Address Acknowledge */
    hi2c->Instance->CR2 &= ~I2C_CR2_NACK;

    /* Wait until ADDR flag is set */
    if (I2C_WaitOnFlagUntilTimeout(hi2c, I2C_FLAG_ADDR, RESET, Timeout, tickstart) != HAL_OK)
    {
      /* Disable Address Acknowledge */
      hi2c->Instance->CR2 |= I2C_CR2_NACK;
      return HAL_ERROR;
    }

    /* Clear ADDR flag */
    __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_ADDR);

    /* Wait until DIR flag is reset Receiver mode */
    if (I2C_WaitOnFlagUntilTimeout(hi2c, I2C_FLAG_DIR, SET, Timeout, tickstart) != HAL_OK)
    {
      /* Disable Address Acknowledge */
      hi2c->Instance->CR2 |= I2C_CR2_NACK;
      return HAL_ERROR;
    }

    while (hi2c->XferCount > 0U)
    {
      /* Wait until RXNE flag is set */
      if (I2C_WaitOnRXNEFlagUntilTimeout(hi2c, Timeout, tickstart) != HAL_OK)
      {
        /* Disable Address Acknowledge */
        hi2c->Instance->CR2 |= I2C_CR2_NACK;

        /* Store Last receive data if any */
        if (__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_RXNE) == SET)
        {
          /* Read data from RXDR */
          *hi2c->pBuffPtr = (uint8_t)hi2c->Instance->RXDR;

          /* Increment Buffer pointer */
          hi2c->pBuffPtr++;

          hi2c->XferCount--;
          hi2c->XferSize--;
        }

        return HAL_ERROR;
      }

      /* Read data from RXDR */
      *hi2c->pBuffPtr = (uint8_t)hi2c->Instance->RXDR;

      /* Increment Buffer pointer */
      hi2c->pBuffPtr++;

      hi2c->XferCount--;
      hi2c->XferSize--;
    }

    /* Wait until STOP flag is set */
    if (I2C_WaitOnSTOPFlagUntilTimeout(hi2c, Timeout, tickstart) != HAL_OK)
    {
      /* Disable Address Acknowledge */
      hi2c->Instance->CR2 |= I2C_CR2_NACK;
      return HAL_ERROR;
    }

    /* Clear STOP flag */
    __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_STOPF);

    /* Wait until BUSY flag is reset */
    if (I2C_WaitOnFlagUntilTimeout(hi2c, I2C_FLAG_BUSY, SET, Timeout, tickstart) != HAL_OK)
    {
      /* Disable Address Acknowledge */
      hi2c->Instance->CR2 |= I2C_CR2_NACK;
      return HAL_ERROR;
    }

    /* Disable Address Acknowledge */
    hi2c->Instance->CR2 |= I2C_CR2_NACK;

    hi2c->State = HAL_I2C_STATE_READY;
    hi2c->Mode  = HAL_I2C_MODE_NONE;

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Master_Transmit_IT(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint8_t *pData,
                                             uint16_t Size)
{
  uint32_t xfermode;

  if (hi2c->State == HAL_I2C_STATE_READY)
  {
    if (__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_BUSY) == SET)
    {
      return HAL_BUSY;
    }

    /* Process Locked */
    __HAL_LOCK(hi2c);

    hi2c->State       = HAL_I2C_STATE_BUSY_TX;
    hi2c->Mode        = HAL_I2C_MODE_MASTER;
    hi2c->ErrorCode   = HAL_I2C_ERROR_NONE;

    /* Prepare transfer parameters */
    hi2c->pBuffPtr    = pData;
    hi2c->XferCount   = Size;
    hi2c->XferOptions = I2C_NO_OPTION_FRAME;
    hi2c->XferISR     = I2C_Master_ISR_IT;

    if (hi2c->XferCount > MAX_NBYTE_SIZE)
    {
      hi2c->XferSize = MAX_NBYTE_SIZE;
      xfermode = I2C_RELOAD_MODE;
    }
    else
    {
      hi2c->XferSize = hi2c->XferCount;
      xfermode = I2C_AUTOEND_MODE;
    }

    /* Send Slave Address */
    /* Set NBYTES to write and reload if hi2c->XferCount > MAX_NBYTE_SIZE */
    I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, xfermode, I2C_GENERATE_START_WRITE);

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    /* Note : The I2C interrupts must be enabled after unlocking current process
              to avoid the risk of I2C interrupt handle execution before current
              process unlock */

    /* Enable ERR, TC, STOP, NACK, TXI interrupt */
    /* possible to enable all of these */
    /* I2C_IT_ERRI | I2C_IT_TCI | I2C_IT_STOPI | I2C_IT_NACKI |
      I2C_IT_ADDRI | I2C_IT_RXI | I2C_IT_TXI */
    I2C_Enable_IRQ(hi2c, I2C_XFER_TX_IT);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Master_Receive_IT(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint8_t *pData,
                                            uint16_t Size)
{
  uint32_t xfermode;

  if (hi2c->State == HAL_I2C_STATE_READY)
  {
    if (__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_BUSY) == SET)
    {
      return HAL_BUSY;
    }

    /* Process Locked */
    __HAL_LOCK(hi2c);

    hi2c->State       = HAL_I2C_STATE_BUSY_RX;
    hi2c->Mode        = HAL_I2C_MODE_MASTER;
    hi2c->ErrorCode   = HAL_I2C_ERROR_NONE;

    /* Prepare transfer parameters */
    hi2c->pBuffPtr    = pData;
    hi2c->XferCount   = Size;
    hi2c->XferOptions = I2C_NO_OPTION_FRAME;
    hi2c->XferISR     = I2C_Master_ISR_IT;

    if (hi2c->XferCount > MAX_NBYTE_SIZE)
    {
      hi2c->XferSize = MAX_NBYTE_SIZE;
      xfermode = I2C_RELOAD_MODE;
    }
    else
    {
      hi2c->XferSize = hi2c->XferCount;
      xfermode = I2C_AUTOEND_MODE;
    }

    /* Send Slave Address */
    /* Set NBYTES to write and reload if hi2c->XferCount > MAX_NBYTE_SIZE */
    I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, xfermode, I2C_GENERATE_START_READ);

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    /* Note : The I2C interrupts must be enabled after unlocking current process
              to avoid the risk of I2C interrupt handle execution before current
              process unlock */

    /* Enable ERR, TC, STOP, NACK, RXI interrupt */
    /* possible to enable all of these */
    /* I2C_IT_ERRI | I2C_IT_TCI | I2C_IT_STOPI | I2C_IT_NACKI |
      I2C_IT_ADDRI | I2C_IT_RXI | I2C_IT_TXI */
    I2C_Enable_IRQ(hi2c, I2C_XFER_RX_IT);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Slave_Transmit_IT(I2C_HandleTypeDef *hi2c, uint8_t *pData, uint16_t Size)
{
  if (hi2c->State == HAL_I2C_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hi2c);

    hi2c->State       = HAL_I2C_STATE_BUSY_TX;
    hi2c->Mode        = HAL_I2C_MODE_SLAVE;
    hi2c->ErrorCode   = HAL_I2C_ERROR_NONE;

    /* Enable Address Acknowledge */
    hi2c->Instance->CR2 &= ~I2C_CR2_NACK;

    /* Prepare transfer parameters */
    hi2c->pBuffPtr    = pData;
    hi2c->XferCount   = Size;
    hi2c->XferSize    = hi2c->XferCount;
    hi2c->XferOptions = I2C_NO_OPTION_FRAME;
    hi2c->XferISR     = I2C_Slave_ISR_IT;

    /* Preload TX data if no stretch enable */
    if (hi2c->Init.NoStretchMode == I2C_NOSTRETCH_ENABLE)
    {
      /* Preload TX register */
      /* Write data to TXDR */
      hi2c->Instance->TXDR = *hi2c->pBuffPtr;

      /* Increment Buffer pointer */
      hi2c->pBuffPtr++;

      hi2c->XferCount--;
      hi2c->XferSize--;
    }

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    /* Note : The I2C interrupts must be enabled after unlocking current process
              to avoid the risk of I2C interrupt handle execution before current
              process unlock */

    /* Enable ERR, TC, STOP, NACK, TXI interrupt */
    /* possible to enable all of these */
    /* I2C_IT_ERRI | I2C_IT_TCI | I2C_IT_STOPI | I2C_IT_NACKI |
      I2C_IT_ADDRI | I2C_IT_RXI | I2C_IT_TXI */
    I2C_Enable_IRQ(hi2c, I2C_XFER_TX_IT | I2C_XFER_LISTEN_IT);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Slave_Receive_IT(I2C_HandleTypeDef *hi2c, uint8_t *pData, uint16_t Size)
{
  if (hi2c->State == HAL_I2C_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hi2c);

    hi2c->State       = HAL_I2C_STATE_BUSY_RX;
    hi2c->Mode        = HAL_I2C_MODE_SLAVE;
    hi2c->ErrorCode   = HAL_I2C_ERROR_NONE;

    /* Enable Address Acknowledge */
    hi2c->Instance->CR2 &= ~I2C_CR2_NACK;

    /* Prepare transfer parameters */
    hi2c->pBuffPtr    = pData;
    hi2c->XferCount   = Size;
    hi2c->XferSize    = hi2c->XferCount;
    hi2c->XferOptions = I2C_NO_OPTION_FRAME;
    hi2c->XferISR     = I2C_Slave_ISR_IT;

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    /* Note : The I2C interrupts must be enabled after unlocking current process
              to avoid the risk of I2C interrupt handle execution before current
              process unlock */

    /* Enable ERR, TC, STOP, NACK, RXI interrupt */
    /* possible to enable all of these */
    /* I2C_IT_ERRI | I2C_IT_TCI | I2C_IT_STOPI | I2C_IT_NACKI |
      I2C_IT_ADDRI | I2C_IT_RXI | I2C_IT_TXI */
    I2C_Enable_IRQ(hi2c, I2C_XFER_RX_IT | I2C_XFER_LISTEN_IT);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I2C_Master_Transmit_DMA(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint8_t *pData,
                                              uint16_t Size)
{
  uint32_t xfermode;
  HAL_StatusTypeDef dmaxferstatus;

  if (hi2c->State == HAL_I2C_STATE_READY)
  {
    if (__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_BUSY) == SET)
    {
      return HAL_BUSY;
    }

    /* Process Locked */
    __HAL_LOCK(hi2c);

    hi2c->State       = HAL_I2C_STATE_BUSY_TX;
    hi2c->Mode        = HAL_I2C_MODE_MASTER;
    hi2c->ErrorCode   = HAL_I2C_ERROR_NONE;

    /* Prepare transfer parameters */
    hi2c->pBuffPtr    = pData;
    hi2c->XferCount   = Size;
    hi2c->XferOptions = I2C_NO_OPTION_FRAME;
    hi2c->XferISR     = I2C_Master_ISR_DMA;

    if (hi2c->XferCount > MAX_NBYTE_SIZE)
    {
      hi2c->XferSize = MAX_NBYTE_SIZE;
      xfermode = I2C_RELOAD_MODE;
    }
    else
    {
      hi2c->XferSize = hi2c->XferCount;
      xfermode = I2C_AUTOEND_MODE;
    }

    if (hi2c->XferSize > 0U)
    {
      if (hi2c->hdmatx != NULL)
      {
        /* Set the I2C DMA transfer complete callback */
        hi2c->hdmatx->XferCpltCallback = I2C_DMAMasterTransmitCplt;

        /* Set the DMA error callback */
        hi2c->hdmatx->XferErrorCallback = I2C_DMAError;

        /* Set the unused DMA callbacks to NULL */
        hi2c->hdmatx->XferHalfCpltCallback = NULL;
        hi2c->hdmatx->XferAbortCallback = NULL;

        /* Enable the DMA channel */
        if ((hi2c->hdmatx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
        {
          if (hi2c->hdmatx->LinkedListQueue != NULL)
          {
            /* Set DMA data size */
            hi2c->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = hi2c->XferSize;

            /* Set DMA source address */
            hi2c->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = (uint32_t)pData;

            /* Set DMA destination address */
            hi2c->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] \
              = (uint32_t)&hi2c->Instance->TXDR;

            dmaxferstatus = HAL_DMAEx_List_Start_IT(hi2c->hdmatx);
          }
          else
          {
            /* Update I2C state */
            hi2c->State     = HAL_I2C_STATE_READY;
            hi2c->Mode      = HAL_I2C_MODE_NONE;

            /* Update I2C error code */
            hi2c->ErrorCode |= HAL_I2C_ERROR_DMA_PARAM;

            /* Process Unlocked */
            __HAL_UNLOCK(hi2c);

            return HAL_ERROR;
          }
        }
        else
        {
          dmaxferstatus = HAL_DMA_Start_IT(hi2c->hdmatx, (uint32_t)pData, (uint32_t)&hi2c->Instance->TXDR,
                                           hi2c->XferSize);
        }
      }
      else
      {
        /* Update I2C state */
        hi2c->State     = HAL_I2C_STATE_READY;
        hi2c->Mode      = HAL_I2C_MODE_NONE;

        /* Update I2C error code */
        hi2c->ErrorCode |= HAL_I2C_ERROR_DMA_PARAM;

        /* Process Unlocked */
        __HAL_UNLOCK(hi2c);

        return HAL_ERROR;
      }

      if (dmaxferstatus == HAL_OK)
      {
        /* Send Slave Address */
        /* Set NBYTES to write and reload if hi2c->XferCount > MAX_NBYTE_SIZE and generate RESTART */
        I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, xfermode, I2C_GENERATE_START_WRITE);

        /* Update XferCount value */
        hi2c->XferCount -= hi2c->XferSize;

        /* Process Unlocked */
        __HAL_UNLOCK(hi2c);

        /* Note : The I2C interrupts must be enabled after unlocking current process
                  to avoid the risk of I2C interrupt handle execution before current
                  process unlock */
        /* Enable ERR and NACK interrupts */
        I2C_Enable_IRQ(hi2c, I2C_XFER_ERROR_IT);

        /* Enable DMA Request */
        hi2c->Instance->CR1 |= I2C_CR1_TXDMAEN;
      }
      else
      {
        /* Update I2C state */
        hi2c->State     = HAL_I2C_STATE_READY;
        hi2c->Mode      = HAL_I2C_MODE_NONE;

        /* Update I2C error code */
        hi2c->ErrorCode |= HAL_I2C_ERROR_DMA;

        /* Process Unlocked */
        __HAL_UNLOCK(hi2c);

        return HAL_ERROR;
      }
    }
    else
    {
      /* Update Transfer ISR function pointer */
      hi2c->XferISR = I2C_Master_ISR_IT;

      /* Send Slave Address */
      /* Set NBYTES to write and generate START condition */
      I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, I2C_AUTOEND_MODE,
                         I2C_GENERATE_START_WRITE);

      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);

      /* Note : The I2C interrupts must be enabled after unlocking current process
                to avoid the risk of I2C interrupt handle execution before current
                process unlock */
      /* Enable ERR, TC, STOP, NACK, TXI interrupt */
      /* possible to enable all of these */
      /* I2C_IT_ERRI | I2C_IT_TCI | I2C_IT_STOPI | I2C_IT_NACKI |
        I2C_IT_ADDRI | I2C_IT_RXI | I2C_IT_TXI */
      I2C_Enable_IRQ(hi2c, I2C_XFER_TX_IT);
    }

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I2C_Master_Receive_DMA(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint8_t *pData,
                                             uint16_t Size)
{
  uint32_t xfermode;
  HAL_StatusTypeDef dmaxferstatus;

  if (hi2c->State == HAL_I2C_STATE_READY)
  {
    if (__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_BUSY) == SET)
    {
      return HAL_BUSY;
    }

    /* Process Locked */
    __HAL_LOCK(hi2c);

    hi2c->State       = HAL_I2C_STATE_BUSY_RX;
    hi2c->Mode        = HAL_I2C_MODE_MASTER;
    hi2c->ErrorCode   = HAL_I2C_ERROR_NONE;

    /* Prepare transfer parameters */
    hi2c->pBuffPtr    = pData;
    hi2c->XferCount   = Size;
    hi2c->XferOptions = I2C_NO_OPTION_FRAME;
    hi2c->XferISR     = I2C_Master_ISR_DMA;

    if (hi2c->XferCount > MAX_NBYTE_SIZE)
    {
      hi2c->XferSize = MAX_NBYTE_SIZE;
      xfermode = I2C_RELOAD_MODE;
    }
    else
    {
      hi2c->XferSize = hi2c->XferCount;
      xfermode = I2C_AUTOEND_MODE;
    }

    if (hi2c->XferSize > 0U)
    {
      if (hi2c->hdmarx != NULL)
      {
        /* Set the I2C DMA transfer complete callback */
        hi2c->hdmarx->XferCpltCallback = I2C_DMAMasterReceiveCplt;

        /* Set the DMA error callback */
        hi2c->hdmarx->XferErrorCallback = I2C_DMAError;

        /* Set the unused DMA callbacks to NULL */
        hi2c->hdmarx->XferHalfCpltCallback = NULL;
        hi2c->hdmarx->XferAbortCallback = NULL;

        /* Enable the DMA channel */
        if ((hi2c->hdmarx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
        {
          if (hi2c->hdmarx->LinkedListQueue != NULL)
          {
            /* Set DMA data size */
            hi2c->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = hi2c->XferSize;

            /* Set DMA source address */
            hi2c->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] \
              = (uint32_t)&hi2c->Instance->RXDR;

            /* Set DMA destination address */
            hi2c->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = (uint32_t)pData;

            dmaxferstatus = HAL_DMAEx_List_Start_IT(hi2c->hdmarx);
          }
          else
          {
            /* Update I2C state */
            hi2c->State     = HAL_I2C_STATE_READY;
            hi2c->Mode      = HAL_I2C_MODE_NONE;

            /* Update I2C error code */
            hi2c->ErrorCode |= HAL_I2C_ERROR_DMA_PARAM;

            /* Process Unlocked */
            __HAL_UNLOCK(hi2c);

            return HAL_ERROR;
          }
        }
        else
        {
          dmaxferstatus = HAL_DMA_Start_IT(hi2c->hdmarx, (uint32_t)&hi2c->Instance->RXDR, (uint32_t)pData,
                                           hi2c->XferSize);
        }
      }
      else
      {
        /* Update I2C state */
        hi2c->State     = HAL_I2C_STATE_READY;
        hi2c->Mode      = HAL_I2C_MODE_NONE;

        /* Update I2C error code */
        hi2c->ErrorCode |= HAL_I2C_ERROR_DMA_PARAM;

        /* Process Unlocked */
        __HAL_UNLOCK(hi2c);

        return HAL_ERROR;
      }

      if (dmaxferstatus == HAL_OK)
      {
        /* Send Slave Address */
        /* Set NBYTES to read and reload if hi2c->XferCount > MAX_NBYTE_SIZE and generate RESTART */
        I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, xfermode, I2C_GENERATE_START_READ);

        /* Update XferCount value */
        hi2c->XferCount -= hi2c->XferSize;

        /* Process Unlocked */
        __HAL_UNLOCK(hi2c);

        /* Note : The I2C interrupts must be enabled after unlocking current process
                  to avoid the risk of I2C interrupt handle execution before current
                  process unlock */
        /* Enable ERR and NACK interrupts */
        I2C_Enable_IRQ(hi2c, I2C_XFER_ERROR_IT);

        /* Enable DMA Request */
        hi2c->Instance->CR1 |= I2C_CR1_RXDMAEN;
      }
      else
      {
        /* Update I2C state */
        hi2c->State     = HAL_I2C_STATE_READY;
        hi2c->Mode      = HAL_I2C_MODE_NONE;

        /* Update I2C error code */
        hi2c->ErrorCode |= HAL_I2C_ERROR_DMA;

        /* Process Unlocked */
        __HAL_UNLOCK(hi2c);

        return HAL_ERROR;
      }
    }
    else
    {
      /* Update Transfer ISR function pointer */
      hi2c->XferISR = I2C_Master_ISR_IT;

      /* Send Slave Address */
      /* Set NBYTES to read and generate START condition */
      I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, I2C_AUTOEND_MODE,
                         I2C_GENERATE_START_READ);

      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);

      /* Note : The I2C interrupts must be enabled after unlocking current process
                to avoid the risk of I2C interrupt handle execution before current
                process unlock */
      /* Enable ERR, TC, STOP, NACK, RXI interrupt */
      /* possible to enable all of these */
      /* I2C_IT_ERRI | I2C_IT_TCI | I2C_IT_STOPI | I2C_IT_NACKI |
        I2C_IT_ADDRI | I2C_IT_RXI | I2C_IT_TXI */
      I2C_Enable_IRQ(hi2c, I2C_XFER_RX_IT);
    }

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I2C_Slave_Transmit_DMA(I2C_HandleTypeDef *hi2c, uint8_t *pData, uint16_t Size)
{
  HAL_StatusTypeDef dmaxferstatus;

  if (hi2c->State == HAL_I2C_STATE_READY)
  {
    if ((pData == NULL) || (Size == 0U))
    {
      hi2c->ErrorCode = HAL_I2C_ERROR_INVALID_PARAM;
      return  HAL_ERROR;
    }
    /* Process Locked */
    __HAL_LOCK(hi2c);

    hi2c->State       = HAL_I2C_STATE_BUSY_TX;
    hi2c->Mode        = HAL_I2C_MODE_SLAVE;
    hi2c->ErrorCode   = HAL_I2C_ERROR_NONE;

    /* Prepare transfer parameters */
    hi2c->pBuffPtr    = pData;
    hi2c->XferCount   = Size;
    hi2c->XferSize    = hi2c->XferCount;
    hi2c->XferOptions = I2C_NO_OPTION_FRAME;
    hi2c->XferISR     = I2C_Slave_ISR_DMA;

    /* Preload TX data if no stretch enable */
    if (hi2c->Init.NoStretchMode == I2C_NOSTRETCH_ENABLE)
    {
      /* Preload TX register */
      /* Write data to TXDR */
      hi2c->Instance->TXDR = *hi2c->pBuffPtr;

      /* Increment Buffer pointer */
      hi2c->pBuffPtr++;

      hi2c->XferCount--;
      hi2c->XferSize--;
    }

    if (hi2c->XferCount != 0U)
    {
      if (hi2c->hdmatx != NULL)
      {
        /* Set the I2C DMA transfer complete callback */
        hi2c->hdmatx->XferCpltCallback = I2C_DMASlaveTransmitCplt;

        /* Set the DMA error callback */
        hi2c->hdmatx->XferErrorCallback = I2C_DMAError;

        /* Set the unused DMA callbacks to NULL */
        hi2c->hdmatx->XferHalfCpltCallback = NULL;
        hi2c->hdmatx->XferAbortCallback = NULL;

        /* Enable the DMA channel */
        if ((hi2c->hdmatx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
        {
          if (hi2c->hdmatx->LinkedListQueue != NULL)
          {
            /* Set DMA data size */
            hi2c->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = hi2c->XferSize;

            /* Set DMA source address */
            hi2c->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = (uint32_t)hi2c->pBuffPtr;

            /* Set DMA destination address */
            hi2c->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] \
              = (uint32_t)&hi2c->Instance->TXDR;

            dmaxferstatus = HAL_DMAEx_List_Start_IT(hi2c->hdmatx);
          }
          else
          {
            /* Update I2C state */
            hi2c->State     = HAL_I2C_STATE_LISTEN;
            hi2c->Mode      = HAL_I2C_MODE_NONE;

            /* Update I2C error code */
            hi2c->ErrorCode |= HAL_I2C_ERROR_DMA_PARAM;

            /* Process Unlocked */
            __HAL_UNLOCK(hi2c);

            return HAL_ERROR;
          }
        }
        else
        {
          dmaxferstatus = HAL_DMA_Start_IT(hi2c->hdmatx,
                                           (uint32_t)hi2c->pBuffPtr, (uint32_t)&hi2c->Instance->TXDR,
                                           hi2c->XferSize);
        }
      }
      else
      {
        /* Update I2C state */
        hi2c->State     = HAL_I2C_STATE_LISTEN;
        hi2c->Mode      = HAL_I2C_MODE_NONE;

        /* Update I2C error code */
        hi2c->ErrorCode |= HAL_I2C_ERROR_DMA_PARAM;

        /* Process Unlocked */
        __HAL_UNLOCK(hi2c);

        return HAL_ERROR;
      }

      if (dmaxferstatus == HAL_OK)
      {
        /* Enable Address Acknowledge */
        hi2c->Instance->CR2 &= ~I2C_CR2_NACK;

        /* Process Unlocked */
        __HAL_UNLOCK(hi2c);

        /* Note : The I2C interrupts must be enabled after unlocking current process
                  to avoid the risk of I2C interrupt handle execution before current
                  process unlock */
        /* Enable ERR, STOP, NACK, ADDR interrupts */
        I2C_Enable_IRQ(hi2c, I2C_XFER_LISTEN_IT);

        /* Enable DMA Request */
        hi2c->Instance->CR1 |= I2C_CR1_TXDMAEN;
      }
      else
      {
        /* Update I2C state */
        hi2c->State     = HAL_I2C_STATE_LISTEN;
        hi2c->Mode      = HAL_I2C_MODE_NONE;

        /* Update I2C error code */
        hi2c->ErrorCode |= HAL_I2C_ERROR_DMA;

        /* Process Unlocked */
        __HAL_UNLOCK(hi2c);

        return HAL_ERROR;
      }
    }
    else
    {
      /* Enable Address Acknowledge */
      hi2c->Instance->CR2 &= ~I2C_CR2_NACK;

      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);

      /* Note : The I2C interrupts must be enabled after unlocking current process
      to avoid the risk of I2C interrupt handle execution before current
      process unlock */
      /* Enable ERR, STOP, NACK, ADDR interrupts */
      I2C_Enable_IRQ(hi2c, I2C_XFER_LISTEN_IT);
    }

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I2C_Slave_Receive_DMA(I2C_HandleTypeDef *hi2c, uint8_t *pData, uint16_t Size)
{
  HAL_StatusTypeDef dmaxferstatus;

  if (hi2c->State == HAL_I2C_STATE_READY)
  {
    if ((pData == NULL) || (Size == 0U))
    {
      hi2c->ErrorCode = HAL_I2C_ERROR_INVALID_PARAM;
      return  HAL_ERROR;
    }
    /* Process Locked */
    __HAL_LOCK(hi2c);

    hi2c->State       = HAL_I2C_STATE_BUSY_RX;
    hi2c->Mode        = HAL_I2C_MODE_SLAVE;
    hi2c->ErrorCode   = HAL_I2C_ERROR_NONE;

    /* Prepare transfer parameters */
    hi2c->pBuffPtr    = pData;
    hi2c->XferCount   = Size;
    hi2c->XferSize    = hi2c->XferCount;
    hi2c->XferOptions = I2C_NO_OPTION_FRAME;
    hi2c->XferISR     = I2C_Slave_ISR_DMA;

    if (hi2c->hdmarx != NULL)
    {
      /* Set the I2C DMA transfer complete callback */
      hi2c->hdmarx->XferCpltCallback = I2C_DMASlaveReceiveCplt;

      /* Set the DMA error callback */
      hi2c->hdmarx->XferErrorCallback = I2C_DMAError;

      /* Set the unused DMA callbacks to NULL */
      hi2c->hdmarx->XferHalfCpltCallback = NULL;
      hi2c->hdmarx->XferAbortCallback = NULL;

      /* Enable the DMA channel */
      if ((hi2c->hdmarx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
      {
        if (hi2c->hdmarx->LinkedListQueue != NULL)
        {
          /* Set DMA data size */
          hi2c->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = hi2c->XferSize;

          /* Set DMA source address */
          hi2c->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] \
            = (uint32_t)&hi2c->Instance->RXDR;

          /* Set DMA destination address */
          hi2c->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = (uint32_t)pData;

          dmaxferstatus = HAL_DMAEx_List_Start_IT(hi2c->hdmarx);
        }
        else
        {
          /* Update I2C state */
          hi2c->State     = HAL_I2C_STATE_LISTEN;
          hi2c->Mode      = HAL_I2C_MODE_NONE;

          /* Update I2C error code */
          hi2c->ErrorCode |= HAL_I2C_ERROR_DMA_PARAM;

          /* Process Unlocked */
          __HAL_UNLOCK(hi2c);

          return HAL_ERROR;
        }
      }
      else
      {
        dmaxferstatus = HAL_DMA_Start_IT(hi2c->hdmarx, (uint32_t)&hi2c->Instance->RXDR, (uint32_t)pData,
                                         hi2c->XferSize);
      }
    }
    else
    {
      /* Update I2C state */
      hi2c->State     = HAL_I2C_STATE_LISTEN;
      hi2c->Mode      = HAL_I2C_MODE_NONE;

      /* Update I2C error code */
      hi2c->ErrorCode |= HAL_I2C_ERROR_DMA_PARAM;

      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);

      return HAL_ERROR;
    }

    if (dmaxferstatus == HAL_OK)
    {
      /* Enable Address Acknowledge */
      hi2c->Instance->CR2 &= ~I2C_CR2_NACK;

      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);

      /* Note : The I2C interrupts must be enabled after unlocking current process
                to avoid the risk of I2C interrupt handle execution before current
                process unlock */
      /* Enable ERR, STOP, NACK, ADDR interrupts */
      I2C_Enable_IRQ(hi2c, I2C_XFER_LISTEN_IT);

      /* Enable DMA Request */
      hi2c->Instance->CR1 |= I2C_CR1_RXDMAEN;
    }
    else
    {
      /* Update I2C state */
      hi2c->State     = HAL_I2C_STATE_LISTEN;
      hi2c->Mode      = HAL_I2C_MODE_NONE;

      /* Update I2C error code */
      hi2c->ErrorCode |= HAL_I2C_ERROR_DMA;

      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);

      return HAL_ERROR;
    }

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Mem_Write(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint16_t MemAddress,
                                    uint16_t MemAddSize, uint8_t *pData, uint16_t Size, uint32_t Timeout)
{
  uint32_t tickstart;

  /* Check the parameters */
  assert_param(IS_I2C_MEMADD_SIZE(MemAddSize));

  if (hi2c->State == HAL_I2C_STATE_READY)
  {
    if ((pData == NULL) || (Size == 0U))
    {
      hi2c->ErrorCode = HAL_I2C_ERROR_INVALID_PARAM;
      return  HAL_ERROR;
    }

    /* Process Locked */
    __HAL_LOCK(hi2c);

    /* Init tickstart for timeout management*/
    tickstart = HAL_GetTick();

    if (I2C_WaitOnFlagUntilTimeout(hi2c, I2C_FLAG_BUSY, SET, I2C_TIMEOUT_BUSY, tickstart) != HAL_OK)
    {
      return HAL_ERROR;
    }

    hi2c->State     = HAL_I2C_STATE_BUSY_TX;
    hi2c->Mode      = HAL_I2C_MODE_MEM;
    hi2c->ErrorCode = HAL_I2C_ERROR_NONE;

    /* Prepare transfer parameters */
    hi2c->pBuffPtr  = pData;
    hi2c->XferCount = Size;
    hi2c->XferISR   = NULL;

    /* Send Slave Address and Memory Address */
    if (I2C_RequestMemoryWrite(hi2c, DevAddress, MemAddress, MemAddSize, Timeout, tickstart) != HAL_OK)
    {
      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);
      return HAL_ERROR;
    }

    /* Set NBYTES to write and reload if hi2c->XferCount > MAX_NBYTE_SIZE */
    if (hi2c->XferCount > MAX_NBYTE_SIZE)
    {
      hi2c->XferSize = MAX_NBYTE_SIZE;
      I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, I2C_RELOAD_MODE, I2C_NO_STARTSTOP);
    }
    else
    {
      hi2c->XferSize = hi2c->XferCount;
      I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, I2C_AUTOEND_MODE, I2C_NO_STARTSTOP);
    }

    do
    {
      /* Wait until TXIS flag is set */
      if (I2C_WaitOnTXISFlagUntilTimeout(hi2c, Timeout, tickstart) != HAL_OK)
      {
        return HAL_ERROR;
      }

      /* Write data to TXDR */
      hi2c->Instance->TXDR = *hi2c->pBuffPtr;

      /* Increment Buffer pointer */
      hi2c->pBuffPtr++;

      hi2c->XferCount--;
      hi2c->XferSize--;

      if ((hi2c->XferCount != 0U) && (hi2c->XferSize == 0U))
      {
        /* Wait until TCR flag is set */
        if (I2C_WaitOnFlagUntilTimeout(hi2c, I2C_FLAG_TCR, RESET, Timeout, tickstart) != HAL_OK)
        {
          return HAL_ERROR;
        }

        if (hi2c->XferCount > MAX_NBYTE_SIZE)
        {
          hi2c->XferSize = MAX_NBYTE_SIZE;
          I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, I2C_RELOAD_MODE,
                             I2C_NO_STARTSTOP);
        }
        else
        {
          hi2c->XferSize = hi2c->XferCount;
          I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, I2C_AUTOEND_MODE,
                             I2C_NO_STARTSTOP);
        }
      }

    } while (hi2c->XferCount > 0U);

    /* No need to Check TC flag, with AUTOEND mode the stop is automatically generated */
    /* Wait until STOPF flag is reset */
    if (I2C_WaitOnSTOPFlagUntilTimeout(hi2c, Timeout, tickstart) != HAL_OK)
    {
      return HAL_ERROR;
    }

    /* Clear STOP Flag */
    __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_STOPF);

    /* Clear Configuration Register 2 */
    I2C_RESET_CR2(hi2c);

    hi2c->State = HAL_I2C_STATE_READY;
    hi2c->Mode  = HAL_I2C_MODE_NONE;

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Mem_Read(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint16_t MemAddress,
                                   uint16_t MemAddSize, uint8_t *pData, uint16_t Size, uint32_t Timeout)
{
  uint32_t tickstart;

  /* Check the parameters */
  assert_param(IS_I2C_MEMADD_SIZE(MemAddSize));

  if (hi2c->State == HAL_I2C_STATE_READY)
  {
    if ((pData == NULL) || (Size == 0U))
    {
      hi2c->ErrorCode = HAL_I2C_ERROR_INVALID_PARAM;
      return  HAL_ERROR;
    }

    /* Process Locked */
    __HAL_LOCK(hi2c);

    /* Init tickstart for timeout management*/
    tickstart = HAL_GetTick();

    if (I2C_WaitOnFlagUntilTimeout(hi2c, I2C_FLAG_BUSY, SET, I2C_TIMEOUT_BUSY, tickstart) != HAL_OK)
    {
      return HAL_ERROR;
    }

    hi2c->State     = HAL_I2C_STATE_BUSY_RX;
    hi2c->Mode      = HAL_I2C_MODE_MEM;
    hi2c->ErrorCode = HAL_I2C_ERROR_NONE;

    /* Prepare transfer parameters */
    hi2c->pBuffPtr  = pData;
    hi2c->XferCount = Size;
    hi2c->XferISR   = NULL;

    /* Send Slave Address and Memory Address */
    if (I2C_RequestMemoryRead(hi2c, DevAddress, MemAddress, MemAddSize, Timeout, tickstart) != HAL_OK)
    {
      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);
      return HAL_ERROR;
    }

    /* Send Slave Address */
    /* Set NBYTES to write and reload if hi2c->XferCount > MAX_NBYTE_SIZE and generate RESTART */
    if (hi2c->XferCount > MAX_NBYTE_SIZE)
    {
      hi2c->XferSize = MAX_NBYTE_SIZE;
      I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, I2C_RELOAD_MODE,
                         I2C_GENERATE_START_READ);
    }
    else
    {
      hi2c->XferSize = hi2c->XferCount;
      I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, I2C_AUTOEND_MODE,
                         I2C_GENERATE_START_READ);
    }

    do
    {
      /* Wait until RXNE flag is set */
      if (I2C_WaitOnFlagUntilTimeout(hi2c, I2C_FLAG_RXNE, RESET, Timeout, tickstart) != HAL_OK)
      {
        return HAL_ERROR;
      }

      /* Read data from RXDR */
      *hi2c->pBuffPtr = (uint8_t)hi2c->Instance->RXDR;

      /* Increment Buffer pointer */
      hi2c->pBuffPtr++;

      hi2c->XferSize--;
      hi2c->XferCount--;

      if ((hi2c->XferCount != 0U) && (hi2c->XferSize == 0U))
      {
        /* Wait until TCR flag is set */
        if (I2C_WaitOnFlagUntilTimeout(hi2c, I2C_FLAG_TCR, RESET, Timeout, tickstart) != HAL_OK)
        {
          return HAL_ERROR;
        }

        if (hi2c->XferCount > MAX_NBYTE_SIZE)
        {
          hi2c->XferSize = MAX_NBYTE_SIZE;
          I2C_TransferConfig(hi2c, DevAddress, (uint8_t) hi2c->XferSize, I2C_RELOAD_MODE,
                             I2C_NO_STARTSTOP);
        }
        else
        {
          hi2c->XferSize = hi2c->XferCount;
          I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, I2C_AUTOEND_MODE,
                             I2C_NO_STARTSTOP);
        }
      }
    } while (hi2c->XferCount > 0U);

    /* No need to Check TC flag, with AUTOEND mode the stop is automatically generated */
    /* Wait until STOPF flag is reset */
    if (I2C_WaitOnSTOPFlagUntilTimeout(hi2c, Timeout, tickstart) != HAL_OK)
    {
      return HAL_ERROR;
    }

    /* Clear STOP Flag */
    __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_STOPF);

    /* Clear Configuration Register 2 */
    I2C_RESET_CR2(hi2c);

    hi2c->State = HAL_I2C_STATE_READY;
    hi2c->Mode  = HAL_I2C_MODE_NONE;

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Mem_Write_IT(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint16_t MemAddress,
                                       uint16_t MemAddSize, uint8_t *pData, uint16_t Size)
{
  /* Check the parameters */
  assert_param(IS_I2C_MEMADD_SIZE(MemAddSize));

  if (hi2c->State == HAL_I2C_STATE_READY)
  {
    if ((pData == NULL) || (Size == 0U))
    {
      hi2c->ErrorCode = HAL_I2C_ERROR_INVALID_PARAM;
      return  HAL_ERROR;
    }

    if (__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_BUSY) == SET)
    {
      return HAL_BUSY;
    }

    /* Process Locked */
    __HAL_LOCK(hi2c);

    hi2c->State       = HAL_I2C_STATE_BUSY_TX;
    hi2c->Mode        = HAL_I2C_MODE_MEM;
    hi2c->ErrorCode   = HAL_I2C_ERROR_NONE;

    /* Prepare transfer parameters */
    hi2c->XferSize    = 0U;
    hi2c->pBuffPtr    = pData;
    hi2c->XferCount   = Size;
    hi2c->XferOptions = I2C_NO_OPTION_FRAME;
    hi2c->XferISR     = I2C_Mem_ISR_IT;
    hi2c->Devaddress  = DevAddress;

    /* If Memory address size is 8Bit */
    if (MemAddSize == I2C_MEMADD_SIZE_8BIT)
    {
      /* Prefetch Memory Address */
      hi2c->Instance->TXDR = I2C_MEM_ADD_LSB(MemAddress);

      /* Reset Memaddress content */
      hi2c->Memaddress = 0xFFFFFFFFU;
    }
    /* If Memory address size is 16Bit */
    else
    {
      /* Prefetch Memory Address (MSB part, LSB will be manage through interrupt) */
      hi2c->Instance->TXDR = I2C_MEM_ADD_MSB(MemAddress);

      /* Prepare Memaddress buffer for LSB part */
      hi2c->Memaddress = I2C_MEM_ADD_LSB(MemAddress);
    }
    /* Send Slave Address and Memory Address */
    I2C_TransferConfig(hi2c, DevAddress, (uint8_t)MemAddSize, I2C_RELOAD_MODE, I2C_GENERATE_START_WRITE);

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    /* Note : The I2C interrupts must be enabled after unlocking current process
              to avoid the risk of I2C interrupt handle execution before current
              process unlock */

    /* Enable ERR, TC, STOP, NACK, TXI interrupt */
    /* possible to enable all of these */
    /* I2C_IT_ERRI | I2C_IT_TCI | I2C_IT_STOPI | I2C_IT_NACKI |
      I2C_IT_ADDRI | I2C_IT_RXI | I2C_IT_TXI */
    I2C_Enable_IRQ(hi2c, I2C_XFER_TX_IT);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Mem_Read_IT(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint16_t MemAddress,
                                      uint16_t MemAddSize, uint8_t *pData, uint16_t Size)
{
  /* Check the parameters */
  assert_param(IS_I2C_MEMADD_SIZE(MemAddSize));

  if (hi2c->State == HAL_I2C_STATE_READY)
  {
    if ((pData == NULL) || (Size == 0U))
    {
      hi2c->ErrorCode = HAL_I2C_ERROR_INVALID_PARAM;
      return  HAL_ERROR;
    }

    if (__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_BUSY) == SET)
    {
      return HAL_BUSY;
    }

    /* Process Locked */
    __HAL_LOCK(hi2c);

    hi2c->State       = HAL_I2C_STATE_BUSY_RX;
    hi2c->Mode        = HAL_I2C_MODE_MEM;
    hi2c->ErrorCode   = HAL_I2C_ERROR_NONE;

    /* Prepare transfer parameters */
    hi2c->pBuffPtr    = pData;
    hi2c->XferCount   = Size;
    hi2c->XferOptions = I2C_NO_OPTION_FRAME;
    hi2c->XferISR     = I2C_Mem_ISR_IT;
    hi2c->Devaddress  = DevAddress;

    /* If Memory address size is 8Bit */
    if (MemAddSize == I2C_MEMADD_SIZE_8BIT)
    {
      /* Prefetch Memory Address */
      hi2c->Instance->TXDR = I2C_MEM_ADD_LSB(MemAddress);

      /* Reset Memaddress content */
      hi2c->Memaddress = 0xFFFFFFFFU;
    }
    /* If Memory address size is 16Bit */
    else
    {
      /* Prefetch Memory Address (MSB part, LSB will be manage through interrupt) */
      hi2c->Instance->TXDR = I2C_MEM_ADD_MSB(MemAddress);

      /* Prepare Memaddress buffer for LSB part */
      hi2c->Memaddress = I2C_MEM_ADD_LSB(MemAddress);
    }
    /* Send Slave Address and Memory Address */
    I2C_TransferConfig(hi2c, DevAddress, (uint8_t)MemAddSize, I2C_SOFTEND_MODE, I2C_GENERATE_START_WRITE);

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    /* Note : The I2C interrupts must be enabled after unlocking current process
              to avoid the risk of I2C interrupt handle execution before current
              process unlock */

    /* Enable ERR, TC, STOP, NACK, TXI interrupt */
    /* possible to enable all of these */
    /* I2C_IT_ERRI | I2C_IT_TCI | I2C_IT_STOPI | I2C_IT_NACKI |
      I2C_IT_ADDRI | I2C_IT_RXI | I2C_IT_TXI */
    I2C_Enable_IRQ(hi2c, I2C_XFER_TX_IT);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I2C_Mem_Write_DMA(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint16_t MemAddress,
                                        uint16_t MemAddSize, uint8_t *pData, uint16_t Size)
{
  HAL_StatusTypeDef dmaxferstatus;

  /* Check the parameters */
  assert_param(IS_I2C_MEMADD_SIZE(MemAddSize));

  if (hi2c->State == HAL_I2C_STATE_READY)
  {
    if ((pData == NULL) || (Size == 0U))
    {
      hi2c->ErrorCode = HAL_I2C_ERROR_INVALID_PARAM;
      return  HAL_ERROR;
    }

    if (__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_BUSY) == SET)
    {
      return HAL_BUSY;
    }

    /* Process Locked */
    __HAL_LOCK(hi2c);

    hi2c->State       = HAL_I2C_STATE_BUSY_TX;
    hi2c->Mode        = HAL_I2C_MODE_MEM;
    hi2c->ErrorCode   = HAL_I2C_ERROR_NONE;

    /* Prepare transfer parameters */
    hi2c->pBuffPtr    = pData;
    hi2c->XferCount   = Size;
    hi2c->XferOptions = I2C_NO_OPTION_FRAME;
    hi2c->XferISR     = I2C_Mem_ISR_DMA;
    hi2c->Devaddress  = DevAddress;

    if (hi2c->XferCount > MAX_NBYTE_SIZE)
    {
      hi2c->XferSize = MAX_NBYTE_SIZE;
    }
    else
    {
      hi2c->XferSize = hi2c->XferCount;
    }

    /* If Memory address size is 8Bit */
    if (MemAddSize == I2C_MEMADD_SIZE_8BIT)
    {
      /* Prefetch Memory Address */
      hi2c->Instance->TXDR = I2C_MEM_ADD_LSB(MemAddress);

      /* Reset Memaddress content */
      hi2c->Memaddress = 0xFFFFFFFFU;
    }
    /* If Memory address size is 16Bit */
    else
    {
      /* Prefetch Memory Address (MSB part, LSB will be manage through interrupt) */
      hi2c->Instance->TXDR = I2C_MEM_ADD_MSB(MemAddress);

      /* Prepare Memaddress buffer for LSB part */
      hi2c->Memaddress = I2C_MEM_ADD_LSB(MemAddress);
    }

    if (hi2c->hdmatx != NULL)
    {
      /* Set the I2C DMA transfer complete callback */
      hi2c->hdmatx->XferCpltCallback = I2C_DMAMasterTransmitCplt;

      /* Set the DMA error callback */
      hi2c->hdmatx->XferErrorCallback = I2C_DMAError;

      /* Set the unused DMA callbacks to NULL */
      hi2c->hdmatx->XferHalfCpltCallback = NULL;
      hi2c->hdmatx->XferAbortCallback = NULL;

      /* Enable the DMA channel */
      if ((hi2c->hdmatx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
      {
        if (hi2c->hdmatx->LinkedListQueue != NULL)
        {
          /* Set DMA data size */
          hi2c->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = hi2c->XferSize;

          /* Set DMA source address */
          hi2c->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = (uint32_t)pData;

          /* Set DMA destination address */
          hi2c->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] \
            = (uint32_t)&hi2c->Instance->TXDR;

          dmaxferstatus = HAL_DMAEx_List_Start_IT(hi2c->hdmatx);
        }
        else
        {
          /* Update I2C state */
          hi2c->State     = HAL_I2C_STATE_READY;
          hi2c->Mode      = HAL_I2C_MODE_NONE;

          /* Update I2C error code */
          hi2c->ErrorCode |= HAL_I2C_ERROR_DMA_PARAM;

          /* Process Unlocked */
          __HAL_UNLOCK(hi2c);

          return HAL_ERROR;
        }
      }
      else
      {
        dmaxferstatus = HAL_DMA_Start_IT(hi2c->hdmatx, (uint32_t)pData, (uint32_t)&hi2c->Instance->TXDR,
                                         hi2c->XferSize);
      }
    }
    else
    {
      /* Update I2C state */
      hi2c->State     = HAL_I2C_STATE_READY;
      hi2c->Mode      = HAL_I2C_MODE_NONE;

      /* Update I2C error code */
      hi2c->ErrorCode |= HAL_I2C_ERROR_DMA_PARAM;

      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);

      return HAL_ERROR;
    }

    if (dmaxferstatus == HAL_OK)
    {
      /* Send Slave Address and Memory Address */
      I2C_TransferConfig(hi2c, DevAddress, (uint8_t)MemAddSize, I2C_RELOAD_MODE, I2C_GENERATE_START_WRITE);

      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);

      /* Note : The I2C interrupts must be enabled after unlocking current process
                to avoid the risk of I2C interrupt handle execution before current
                process unlock */
      /* Enable ERR, TC, STOP, NACK, TXI interrupt */
      /* possible to enable all of these */
      /* I2C_IT_ERRI | I2C_IT_TCI | I2C_IT_STOPI | I2C_IT_NACKI |
        I2C_IT_ADDRI | I2C_IT_RXI | I2C_IT_TXI */
      I2C_Enable_IRQ(hi2c, I2C_XFER_TX_IT);
    }
    else
    {
      /* Update I2C state */
      hi2c->State     = HAL_I2C_STATE_READY;
      hi2c->Mode      = HAL_I2C_MODE_NONE;

      /* Update I2C error code */
      hi2c->ErrorCode |= HAL_I2C_ERROR_DMA;

      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);

      return HAL_ERROR;
    }

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I2C_Mem_Read_DMA(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint16_t MemAddress,
                                       uint16_t MemAddSize, uint8_t *pData, uint16_t Size)
{
  HAL_StatusTypeDef dmaxferstatus;

  /* Check the parameters */
  assert_param(IS_I2C_MEMADD_SIZE(MemAddSize));

  if (hi2c->State == HAL_I2C_STATE_READY)
  {
    if ((pData == NULL) || (Size == 0U))
    {
      hi2c->ErrorCode = HAL_I2C_ERROR_INVALID_PARAM;
      return  HAL_ERROR;
    }

    if (__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_BUSY) == SET)
    {
      return HAL_BUSY;
    }

    /* Process Locked */
    __HAL_LOCK(hi2c);

    hi2c->State       = HAL_I2C_STATE_BUSY_RX;
    hi2c->Mode        = HAL_I2C_MODE_MEM;
    hi2c->ErrorCode   = HAL_I2C_ERROR_NONE;

    /* Prepare transfer parameters */
    hi2c->pBuffPtr    = pData;
    hi2c->XferCount   = Size;
    hi2c->XferOptions = I2C_NO_OPTION_FRAME;
    hi2c->XferISR     = I2C_Mem_ISR_DMA;
    hi2c->Devaddress  = DevAddress;

    if (hi2c->XferCount > MAX_NBYTE_SIZE)
    {
      hi2c->XferSize = MAX_NBYTE_SIZE;
    }
    else
    {
      hi2c->XferSize = hi2c->XferCount;
    }

    /* If Memory address size is 8Bit */
    if (MemAddSize == I2C_MEMADD_SIZE_8BIT)
    {
      /* Prefetch Memory Address */
      hi2c->Instance->TXDR = I2C_MEM_ADD_LSB(MemAddress);

      /* Reset Memaddress content */
      hi2c->Memaddress = 0xFFFFFFFFU;
    }
    /* If Memory address size is 16Bit */
    else
    {
      /* Prefetch Memory Address (MSB part, LSB will be manage through interrupt) */
      hi2c->Instance->TXDR = I2C_MEM_ADD_MSB(MemAddress);

      /* Prepare Memaddress buffer for LSB part */
      hi2c->Memaddress = I2C_MEM_ADD_LSB(MemAddress);
    }

    if (hi2c->hdmarx != NULL)
    {
      /* Set the I2C DMA transfer complete callback */
      hi2c->hdmarx->XferCpltCallback = I2C_DMAMasterReceiveCplt;

      /* Set the DMA error callback */
      hi2c->hdmarx->XferErrorCallback = I2C_DMAError;

      /* Set the unused DMA callbacks to NULL */
      hi2c->hdmarx->XferHalfCpltCallback = NULL;
      hi2c->hdmarx->XferAbortCallback = NULL;

      /* Enable the DMA channel */
      if ((hi2c->hdmarx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
      {
        if (hi2c->hdmarx->LinkedListQueue != NULL)
        {
          /* Set DMA data size */
          hi2c->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = hi2c->XferSize;

          /* Set DMA source address */
          hi2c->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] \
            = (uint32_t)&hi2c->Instance->RXDR;

          /* Set DMA destination address */
          hi2c->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = (uint32_t)pData;

          dmaxferstatus = HAL_DMAEx_List_Start_IT(hi2c->hdmarx);
        }
        else
        {
          /* Update I2C state */
          hi2c->State     = HAL_I2C_STATE_READY;
          hi2c->Mode      = HAL_I2C_MODE_NONE;

          /* Update I2C error code */
          hi2c->ErrorCode |= HAL_I2C_ERROR_DMA_PARAM;

          /* Process Unlocked */
          __HAL_UNLOCK(hi2c);

          return HAL_ERROR;
        }
      }
      else
      {
        dmaxferstatus = HAL_DMA_Start_IT(hi2c->hdmarx, (uint32_t)&hi2c->Instance->RXDR, (uint32_t)pData,
                                         hi2c->XferSize);
      }
    }
    else
    {
      /* Update I2C state */
      hi2c->State     = HAL_I2C_STATE_READY;
      hi2c->Mode      = HAL_I2C_MODE_NONE;

      /* Update I2C error code */
      hi2c->ErrorCode |= HAL_I2C_ERROR_DMA_PARAM;

      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);

      return HAL_ERROR;
    }

    if (dmaxferstatus == HAL_OK)
    {
      /* Send Slave Address and Memory Address */
      I2C_TransferConfig(hi2c, DevAddress, (uint8_t)MemAddSize, I2C_SOFTEND_MODE, I2C_GENERATE_START_WRITE);

      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);

      /* Note : The I2C interrupts must be enabled after unlocking current process
                to avoid the risk of I2C interrupt handle execution before current
                process unlock */
      /* Enable ERR, TC, STOP, NACK, TXI interrupt */
      /* possible to enable all of these */
      /* I2C_IT_ERRI | I2C_IT_TCI | I2C_IT_STOPI | I2C_IT_NACKI |
        I2C_IT_ADDRI | I2C_IT_RXI | I2C_IT_TXI */
      I2C_Enable_IRQ(hi2c, I2C_XFER_TX_IT);
    }
    else
    {
      /* Update I2C state */
      hi2c->State     = HAL_I2C_STATE_READY;
      hi2c->Mode      = HAL_I2C_MODE_NONE;

      /* Update I2C error code */
      hi2c->ErrorCode |= HAL_I2C_ERROR_DMA;

      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);

      return HAL_ERROR;
    }

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_IsDeviceReady(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint32_t Trials,
                                        uint32_t Timeout)
{
  uint32_t tickstart;

  __IO uint32_t I2C_Trials = 0UL;

  FlagStatus tmp1;
  FlagStatus tmp2;

  if (hi2c->State == HAL_I2C_STATE_READY)
  {
    if (__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_BUSY) == SET)
    {
      return HAL_BUSY;
    }

    /* Process Locked */
    __HAL_LOCK(hi2c);

    hi2c->State = HAL_I2C_STATE_BUSY;
    hi2c->ErrorCode = HAL_I2C_ERROR_NONE;

    do
    {
      /* Generate Start */
      hi2c->Instance->CR2 = I2C_GENERATE_START(hi2c->Init.AddressingMode, DevAddress);

      /* No need to Check TC flag, with AUTOEND mode the stop is automatically generated */
      /* Wait until STOPF flag is set or a NACK flag is set*/
      tickstart = HAL_GetTick();

      tmp1 = __HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_STOPF);
      tmp2 = __HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_AF);

      while ((tmp1 == RESET) && (tmp2 == RESET))
      {
        if (Timeout != HAL_MAX_DELAY)
        {
          if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
          {
            /* Update I2C state */
            hi2c->State = HAL_I2C_STATE_READY;

            /* Update I2C error code */
            hi2c->ErrorCode |= HAL_I2C_ERROR_TIMEOUT;

            /* Process Unlocked */
            __HAL_UNLOCK(hi2c);

            return HAL_ERROR;
          }
        }

        tmp1 = __HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_STOPF);
        tmp2 = __HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_AF);
      }

      /* Check if the NACKF flag has not been set */
      if (__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_AF) == RESET)
      {
        /* Wait until STOPF flag is reset */
        if (I2C_WaitOnFlagUntilTimeout(hi2c, I2C_FLAG_STOPF, RESET, Timeout, tickstart) != HAL_OK)
        {
          /* A non acknowledge appear during STOP Flag waiting process, a new trial must be performed */
          if (hi2c->ErrorCode == HAL_I2C_ERROR_AF)
          {
            /* Clear STOP Flag */
            __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_STOPF);

            /* Reset the error code for next trial */
            hi2c->ErrorCode = HAL_I2C_ERROR_NONE;
          }
        }
        else
        {
          /* A acknowledge appear during STOP Flag waiting process, this mean that device respond to its address */

          /* Clear STOP Flag */
          __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_STOPF);

          /* Device is ready */
          hi2c->State = HAL_I2C_STATE_READY;

          /* Process Unlocked */
          __HAL_UNLOCK(hi2c);

          return HAL_OK;
        }
      }
      else
      {
        /* A non acknowledge is detected, this mean that device not respond to its address,
           a new trial must be performed */

        /* Clear NACK Flag */
        __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_AF);

        /* Wait until STOPF flag is reset */
        if (I2C_WaitOnFlagUntilTimeout(hi2c, I2C_FLAG_STOPF, RESET, Timeout, tickstart) == HAL_OK)
        {
          /* Clear STOP Flag, auto generated with autoend*/
          __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_STOPF);
        }
      }

      /* Increment Trials */
      I2C_Trials++;
    } while (I2C_Trials < Trials);

    /* Update I2C state */
    hi2c->State = HAL_I2C_STATE_READY;

    /* Update I2C error code */
    hi2c->ErrorCode |= HAL_I2C_ERROR_TIMEOUT;

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    return HAL_ERROR;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Master_Seq_Transmit_IT(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint8_t *pData,
                                                 uint16_t Size, uint32_t XferOptions)
{
  uint32_t xfermode;
  uint32_t xferrequest = I2C_GENERATE_START_WRITE;

  /* Check the parameters */
  assert_param(IS_I2C_TRANSFER_OPTIONS_REQUEST(XferOptions));

  if (hi2c->State == HAL_I2C_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hi2c);

    hi2c->State     = HAL_I2C_STATE_BUSY_TX;
    hi2c->Mode      = HAL_I2C_MODE_MASTER;
    hi2c->ErrorCode = HAL_I2C_ERROR_NONE;

    /* Prepare transfer parameters */
    hi2c->pBuffPtr    = pData;
    hi2c->XferCount   = Size;
    hi2c->XferOptions = XferOptions;
    hi2c->XferISR     = I2C_Master_ISR_IT;

    /* If hi2c->XferCount > MAX_NBYTE_SIZE, use reload mode */
    if (hi2c->XferCount > MAX_NBYTE_SIZE)
    {
      hi2c->XferSize = MAX_NBYTE_SIZE;
      xfermode = I2C_RELOAD_MODE;
    }
    else
    {
      hi2c->XferSize = hi2c->XferCount;
      xfermode = hi2c->XferOptions;
    }

    /* If transfer direction not change and there is no request to start another frame,
       do not generate Restart Condition */
    /* Mean Previous state is same as current state */
    if ((hi2c->PreviousState == I2C_STATE_MASTER_BUSY_TX) && \
        (IS_I2C_TRANSFER_OTHER_OPTIONS_REQUEST(XferOptions) == 0))
    {
      xferrequest = I2C_NO_STARTSTOP;
    }
    else
    {
      /* Convert OTHER_xxx XferOptions if any */
      I2C_ConvertOtherXferOptions(hi2c);

      /* Update xfermode accordingly if no reload is necessary */
      if (hi2c->XferCount <= MAX_NBYTE_SIZE)
      {
        xfermode = hi2c->XferOptions;
      }
    }

    /* Send Slave Address and set NBYTES to write */
    I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, xfermode, xferrequest);

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    /* Note : The I2C interrupts must be enabled after unlocking current process
              to avoid the risk of I2C interrupt handle execution before current
              process unlock */
    /* Enable ERR, TC, STOP, NACK, TXI interrupt */
    /* possible to enable all of these */
    /* I2C_IT_ERRI | I2C_IT_TCI | I2C_IT_STOPI | I2C_IT_NACKI |
       I2C_IT_ADDRI | I2C_IT_RXI | I2C_IT_TXI */
    I2C_Enable_IRQ(hi2c, I2C_XFER_TX_IT);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I2C_Master_Seq_Transmit_DMA(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint8_t *pData,
                                                  uint16_t Size, uint32_t XferOptions)
{
  uint32_t xfermode;
  uint32_t xferrequest = I2C_GENERATE_START_WRITE;
  HAL_StatusTypeDef dmaxferstatus;

  /* Check the parameters */
  assert_param(IS_I2C_TRANSFER_OPTIONS_REQUEST(XferOptions));

  if (hi2c->State == HAL_I2C_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hi2c);

    hi2c->State     = HAL_I2C_STATE_BUSY_TX;
    hi2c->Mode      = HAL_I2C_MODE_MASTER;
    hi2c->ErrorCode = HAL_I2C_ERROR_NONE;

    /* Prepare transfer parameters */
    hi2c->pBuffPtr    = pData;
    hi2c->XferCount   = Size;
    hi2c->XferOptions = XferOptions;
    hi2c->XferISR     = I2C_Master_ISR_DMA;

    /* If hi2c->XferCount > MAX_NBYTE_SIZE, use reload mode */
    if (hi2c->XferCount > MAX_NBYTE_SIZE)
    {
      hi2c->XferSize = MAX_NBYTE_SIZE;
      xfermode = I2C_RELOAD_MODE;
    }
    else
    {
      hi2c->XferSize = hi2c->XferCount;
      xfermode = hi2c->XferOptions;
    }

    /* If transfer direction not change and there is no request to start another frame,
       do not generate Restart Condition */
    /* Mean Previous state is same as current state */
    if ((hi2c->PreviousState == I2C_STATE_MASTER_BUSY_TX) && \
        (IS_I2C_TRANSFER_OTHER_OPTIONS_REQUEST(XferOptions) == 0))
    {
      xferrequest = I2C_NO_STARTSTOP;
    }
    else
    {
      /* Convert OTHER_xxx XferOptions if any */
      I2C_ConvertOtherXferOptions(hi2c);

      /* Update xfermode accordingly if no reload is necessary */
      if (hi2c->XferCount <= MAX_NBYTE_SIZE)
      {
        xfermode = hi2c->XferOptions;
      }
    }

    if (hi2c->XferSize > 0U)
    {
      if (hi2c->hdmatx != NULL)
      {
        /* Set the I2C DMA transfer complete callback */
        hi2c->hdmatx->XferCpltCallback = I2C_DMAMasterTransmitCplt;

        /* Set the DMA error callback */
        hi2c->hdmatx->XferErrorCallback = I2C_DMAError;

        /* Set the unused DMA callbacks to NULL */
        hi2c->hdmatx->XferHalfCpltCallback = NULL;
        hi2c->hdmatx->XferAbortCallback = NULL;

        /* Enable the DMA channel */
        if ((hi2c->hdmatx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
        {
          if (hi2c->hdmatx->LinkedListQueue != NULL)
          {
            /* Set DMA data size */
            hi2c->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = hi2c->XferSize;

            /* Set DMA source address */
            hi2c->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = (uint32_t)pData;

            /* Set DMA destination address */
            hi2c->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] \
              = (uint32_t)&hi2c->Instance->TXDR;

            dmaxferstatus = HAL_DMAEx_List_Start_IT(hi2c->hdmatx);
          }
          else
          {
            /* Update I2C state */
            hi2c->State     = HAL_I2C_STATE_READY;
            hi2c->Mode      = HAL_I2C_MODE_NONE;

            /* Update I2C error code */
            hi2c->ErrorCode |= HAL_I2C_ERROR_DMA_PARAM;

            /* Process Unlocked */
            __HAL_UNLOCK(hi2c);

            return HAL_ERROR;
          }
        }
        else
        {
          dmaxferstatus = HAL_DMA_Start_IT(hi2c->hdmatx, (uint32_t)pData, (uint32_t)&hi2c->Instance->TXDR,
                                           hi2c->XferSize);
        }
      }
      else
      {
        /* Update I2C state */
        hi2c->State     = HAL_I2C_STATE_READY;
        hi2c->Mode      = HAL_I2C_MODE_NONE;

        /* Update I2C error code */
        hi2c->ErrorCode |= HAL_I2C_ERROR_DMA_PARAM;

        /* Process Unlocked */
        __HAL_UNLOCK(hi2c);

        return HAL_ERROR;
      }

      if (dmaxferstatus == HAL_OK)
      {
        /* Send Slave Address and set NBYTES to write */
        I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, xfermode, xferrequest);

        /* Update XferCount value */
        hi2c->XferCount -= hi2c->XferSize;

        /* Process Unlocked */
        __HAL_UNLOCK(hi2c);

        /* Note : The I2C interrupts must be enabled after unlocking current process
                  to avoid the risk of I2C interrupt handle execution before current
                  process unlock */
        /* Enable ERR and NACK interrupts */
        I2C_Enable_IRQ(hi2c, I2C_XFER_ERROR_IT);

        /* Enable DMA Request */
        hi2c->Instance->CR1 |= I2C_CR1_TXDMAEN;
      }
      else
      {
        /* Update I2C state */
        hi2c->State     = HAL_I2C_STATE_READY;
        hi2c->Mode      = HAL_I2C_MODE_NONE;

        /* Update I2C error code */
        hi2c->ErrorCode |= HAL_I2C_ERROR_DMA;

        /* Process Unlocked */
        __HAL_UNLOCK(hi2c);

        return HAL_ERROR;
      }
    }
    else
    {
      /* Update Transfer ISR function pointer */
      hi2c->XferISR = I2C_Master_ISR_IT;

      /* Send Slave Address */
      /* Set NBYTES to write and generate START condition */
      I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, I2C_AUTOEND_MODE,
                         I2C_GENERATE_START_WRITE);

      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);

      /* Note : The I2C interrupts must be enabled after unlocking current process
                to avoid the risk of I2C interrupt handle execution before current
                process unlock */
      /* Enable ERR, TC, STOP, NACK, TXI interrupt */
      /* possible to enable all of these */
      /* I2C_IT_ERRI | I2C_IT_TCI | I2C_IT_STOPI | I2C_IT_NACKI |
        I2C_IT_ADDRI | I2C_IT_RXI | I2C_IT_TXI */
      I2C_Enable_IRQ(hi2c, I2C_XFER_TX_IT);
    }

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Master_Seq_Receive_IT(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint8_t *pData,
                                                uint16_t Size, uint32_t XferOptions)
{
  uint32_t xfermode;
  uint32_t xferrequest = I2C_GENERATE_START_READ;

  /* Check the parameters */
  assert_param(IS_I2C_TRANSFER_OPTIONS_REQUEST(XferOptions));

  if (hi2c->State == HAL_I2C_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hi2c);

    hi2c->State     = HAL_I2C_STATE_BUSY_RX;
    hi2c->Mode      = HAL_I2C_MODE_MASTER;
    hi2c->ErrorCode = HAL_I2C_ERROR_NONE;

    /* Prepare transfer parameters */
    hi2c->pBuffPtr    = pData;
    hi2c->XferCount   = Size;
    hi2c->XferOptions = XferOptions;
    hi2c->XferISR     = I2C_Master_ISR_IT;

    /* If hi2c->XferCount > MAX_NBYTE_SIZE, use reload mode */
    if (hi2c->XferCount > MAX_NBYTE_SIZE)
    {
      hi2c->XferSize = MAX_NBYTE_SIZE;
      xfermode = I2C_RELOAD_MODE;
    }
    else
    {
      hi2c->XferSize = hi2c->XferCount;
      xfermode = hi2c->XferOptions;
    }

    /* If transfer direction not change and there is no request to start another frame,
       do not generate Restart Condition */
    /* Mean Previous state is same as current state */
    if ((hi2c->PreviousState == I2C_STATE_MASTER_BUSY_RX) && \
        (IS_I2C_TRANSFER_OTHER_OPTIONS_REQUEST(XferOptions) == 0))
    {
      xferrequest = I2C_NO_STARTSTOP;
    }
    else
    {
      /* Convert OTHER_xxx XferOptions if any */
      I2C_ConvertOtherXferOptions(hi2c);

      /* Update xfermode accordingly if no reload is necessary */
      if (hi2c->XferCount <= MAX_NBYTE_SIZE)
      {
        xfermode = hi2c->XferOptions;
      }
    }

    /* Send Slave Address and set NBYTES to read */
    I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, xfermode, xferrequest);

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    /* Note : The I2C interrupts must be enabled after unlocking current process
              to avoid the risk of I2C interrupt handle execution before current
              process unlock */
    I2C_Enable_IRQ(hi2c, I2C_XFER_RX_IT);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I2C_Master_Seq_Receive_DMA(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint8_t *pData,
                                                 uint16_t Size, uint32_t XferOptions)
{
  uint32_t xfermode;
  uint32_t xferrequest = I2C_GENERATE_START_READ;
  HAL_StatusTypeDef dmaxferstatus;

  /* Check the parameters */
  assert_param(IS_I2C_TRANSFER_OPTIONS_REQUEST(XferOptions));

  if (hi2c->State == HAL_I2C_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hi2c);

    hi2c->State     = HAL_I2C_STATE_BUSY_RX;
    hi2c->Mode      = HAL_I2C_MODE_MASTER;
    hi2c->ErrorCode = HAL_I2C_ERROR_NONE;

    /* Prepare transfer parameters */
    hi2c->pBuffPtr    = pData;
    hi2c->XferCount   = Size;
    hi2c->XferOptions = XferOptions;
    hi2c->XferISR     = I2C_Master_ISR_DMA;

    /* If hi2c->XferCount > MAX_NBYTE_SIZE, use reload mode */
    if (hi2c->XferCount > MAX_NBYTE_SIZE)
    {
      hi2c->XferSize = MAX_NBYTE_SIZE;
      xfermode = I2C_RELOAD_MODE;
    }
    else
    {
      hi2c->XferSize = hi2c->XferCount;
      xfermode = hi2c->XferOptions;
    }

    /* If transfer direction not change and there is no request to start another frame,
       do not generate Restart Condition */
    /* Mean Previous state is same as current state */
    if ((hi2c->PreviousState == I2C_STATE_MASTER_BUSY_RX) && \
        (IS_I2C_TRANSFER_OTHER_OPTIONS_REQUEST(XferOptions) == 0))
    {
      xferrequest = I2C_NO_STARTSTOP;
    }
    else
    {
      /* Convert OTHER_xxx XferOptions if any */
      I2C_ConvertOtherXferOptions(hi2c);

      /* Update xfermode accordingly if no reload is necessary */
      if (hi2c->XferCount <= MAX_NBYTE_SIZE)
      {
        xfermode = hi2c->XferOptions;
      }
    }

    if (hi2c->XferSize > 0U)
    {
      if (hi2c->hdmarx != NULL)
      {
        /* Set the I2C DMA transfer complete callback */
        hi2c->hdmarx->XferCpltCallback = I2C_DMAMasterReceiveCplt;

        /* Set the DMA error callback */
        hi2c->hdmarx->XferErrorCallback = I2C_DMAError;

        /* Set the unused DMA callbacks to NULL */
        hi2c->hdmarx->XferHalfCpltCallback = NULL;
        hi2c->hdmarx->XferAbortCallback = NULL;

        /* Enable the DMA channel */
        if ((hi2c->hdmarx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
        {
          if (hi2c->hdmarx->LinkedListQueue != NULL)
          {
            /* Set DMA data size */
            hi2c->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = hi2c->XferSize;

            /* Set DMA source address */
            hi2c->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] \
              = (uint32_t)&hi2c->Instance->RXDR;

            /* Set DMA destination address */
            hi2c->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = (uint32_t)pData;

            dmaxferstatus = HAL_DMAEx_List_Start_IT(hi2c->hdmarx);
          }
          else
          {
            hi2c->State     = HAL_I2C_STATE_READY;
            hi2c->Mode      = HAL_I2C_MODE_NONE;

            /* Update I2C error code */
            hi2c->ErrorCode |= HAL_I2C_ERROR_DMA_PARAM;

            /* Process Unlocked */
            __HAL_UNLOCK(hi2c);

            return HAL_ERROR;
          }
        }
        else
        {
          dmaxferstatus = HAL_DMA_Start_IT(hi2c->hdmarx, (uint32_t)&hi2c->Instance->RXDR, (uint32_t)pData,
                                           hi2c->XferSize);
        }
      }
      else
      {
        /* Update I2C state */
        hi2c->State     = HAL_I2C_STATE_READY;
        hi2c->Mode      = HAL_I2C_MODE_NONE;

        /* Update I2C error code */
        hi2c->ErrorCode |= HAL_I2C_ERROR_DMA_PARAM;

        /* Process Unlocked */
        __HAL_UNLOCK(hi2c);

        return HAL_ERROR;
      }

      if (dmaxferstatus == HAL_OK)
      {
        /* Send Slave Address and set NBYTES to read */
        I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, xfermode, xferrequest);

        /* Update XferCount value */
        hi2c->XferCount -= hi2c->XferSize;

        /* Process Unlocked */
        __HAL_UNLOCK(hi2c);

        /* Note : The I2C interrupts must be enabled after unlocking current process
                  to avoid the risk of I2C interrupt handle execution before current
                  process unlock */
        /* Enable ERR and NACK interrupts */
        I2C_Enable_IRQ(hi2c, I2C_XFER_ERROR_IT);

        /* Enable DMA Request */
        hi2c->Instance->CR1 |= I2C_CR1_RXDMAEN;
      }
      else
      {
        /* Update I2C state */
        hi2c->State     = HAL_I2C_STATE_READY;
        hi2c->Mode      = HAL_I2C_MODE_NONE;

        /* Update I2C error code */
        hi2c->ErrorCode |= HAL_I2C_ERROR_DMA;

        /* Process Unlocked */
        __HAL_UNLOCK(hi2c);

        return HAL_ERROR;
      }
    }
    else
    {
      /* Update Transfer ISR function pointer */
      hi2c->XferISR = I2C_Master_ISR_IT;

      /* Send Slave Address */
      /* Set NBYTES to read and generate START condition */
      I2C_TransferConfig(hi2c, DevAddress, (uint8_t)hi2c->XferSize, I2C_AUTOEND_MODE,
                         I2C_GENERATE_START_READ);

      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);

      /* Note : The I2C interrupts must be enabled after unlocking current process
                to avoid the risk of I2C interrupt handle execution before current
                process unlock */
      /* Enable ERR, TC, STOP, NACK, RXI interrupt */
      /* possible to enable all of these */
      /* I2C_IT_ERRI | I2C_IT_TCI | I2C_IT_STOPI | I2C_IT_NACKI |
        I2C_IT_ADDRI | I2C_IT_RXI | I2C_IT_TXI */
      I2C_Enable_IRQ(hi2c, I2C_XFER_RX_IT);
    }

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Slave_Seq_Transmit_IT(I2C_HandleTypeDef *hi2c, uint8_t *pData, uint16_t Size,
                                                uint32_t XferOptions)
{
  /* Declaration of tmp to prevent undefined behavior of volatile usage */
  FlagStatus tmp;

  /* Check the parameters */
  assert_param(IS_I2C_TRANSFER_OPTIONS_REQUEST(XferOptions));

  if (((uint32_t)hi2c->State & (uint32_t)HAL_I2C_STATE_LISTEN) == (uint32_t)HAL_I2C_STATE_LISTEN)
  {
    if ((pData == NULL) || (Size == 0U))
    {
      hi2c->ErrorCode = HAL_I2C_ERROR_INVALID_PARAM;
      return  HAL_ERROR;
    }

    /* Disable Interrupts, to prevent preemption during treatment in case of multicall */
    I2C_Disable_IRQ(hi2c, I2C_XFER_LISTEN_IT | I2C_XFER_TX_IT);

    /* Process Locked */
    __HAL_LOCK(hi2c);

    /* I2C cannot manage full duplex exchange so disable previous IT enabled if any */
    /* and then toggle the HAL slave RX state to TX state */
    if (hi2c->State == HAL_I2C_STATE_BUSY_RX_LISTEN)
    {
      /* Disable associated Interrupts */
      I2C_Disable_IRQ(hi2c, I2C_XFER_RX_IT);

#if defined(HAL_DMA_MODULE_ENABLED)
      /* Abort DMA Xfer if any */
      if ((hi2c->Instance->CR1 & I2C_CR1_RXDMAEN) == I2C_CR1_RXDMAEN)
      {
        hi2c->Instance->CR1 &= ~I2C_CR1_RXDMAEN;

        if (hi2c->hdmarx != NULL)
        {
          /* Set the I2C DMA Abort callback :
           will lead to call HAL_I2C_ErrorCallback() at end of DMA abort procedure */
          hi2c->hdmarx->XferAbortCallback = I2C_DMAAbort;

          /* Abort DMA RX */
          if (HAL_DMA_Abort_IT(hi2c->hdmarx) != HAL_OK)
          {
            /* Call Directly XferAbortCallback function in case of error */
            hi2c->hdmarx->XferAbortCallback(hi2c->hdmarx);
          }
        }
      }
#endif /* HAL_DMA_MODULE_ENABLED */
    }

    hi2c->State     = HAL_I2C_STATE_BUSY_TX_LISTEN;
    hi2c->Mode      = HAL_I2C_MODE_SLAVE;
    hi2c->ErrorCode = HAL_I2C_ERROR_NONE;

    /* Enable Address Acknowledge */
    hi2c->Instance->CR2 &= ~I2C_CR2_NACK;

    /* Prepare transfer parameters */
    hi2c->pBuffPtr    = pData;
    hi2c->XferCount   = Size;
    hi2c->XferSize    = hi2c->XferCount;
    hi2c->XferOptions = XferOptions;
    hi2c->XferISR     = I2C_Slave_ISR_IT;

    tmp = __HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_ADDR);
    if ((I2C_GET_DIR(hi2c) == I2C_DIRECTION_RECEIVE) && (tmp != RESET))
    {
      /* Clear ADDR flag after prepare the transfer parameters */
      /* This action will generate an acknowledge to the Master */
      __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_ADDR);
    }

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    /* Note : The I2C interrupts must be enabled after unlocking current process
    to avoid the risk of I2C interrupt handle execution before current
    process unlock */
    /* REnable ADDR interrupt */
    I2C_Enable_IRQ(hi2c, I2C_XFER_TX_IT | I2C_XFER_LISTEN_IT);

    return HAL_OK;
  }
  else
  {
    return HAL_ERROR;
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I2C_Slave_Seq_Transmit_DMA(I2C_HandleTypeDef *hi2c, uint8_t *pData, uint16_t Size,
                                                 uint32_t XferOptions)
{
  /* Declaration of tmp to prevent undefined behavior of volatile usage */
  FlagStatus tmp;
  HAL_StatusTypeDef dmaxferstatus;

  /* Check the parameters */
  assert_param(IS_I2C_TRANSFER_OPTIONS_REQUEST(XferOptions));

  if (((uint32_t)hi2c->State & (uint32_t)HAL_I2C_STATE_LISTEN) == (uint32_t)HAL_I2C_STATE_LISTEN)
  {
    if ((pData == NULL) || (Size == 0U))
    {
      hi2c->ErrorCode = HAL_I2C_ERROR_INVALID_PARAM;
      return  HAL_ERROR;
    }

    /* Process Locked */
    __HAL_LOCK(hi2c);

    /* Disable Interrupts, to prevent preemption during treatment in case of multicall */
    I2C_Disable_IRQ(hi2c, I2C_XFER_LISTEN_IT | I2C_XFER_TX_IT);

    /* I2C cannot manage full duplex exchange so disable previous IT enabled if any */
    /* and then toggle the HAL slave RX state to TX state */
    if (hi2c->State == HAL_I2C_STATE_BUSY_RX_LISTEN)
    {
      /* Disable associated Interrupts */
      I2C_Disable_IRQ(hi2c, I2C_XFER_RX_IT);

      if ((hi2c->Instance->CR1 & I2C_CR1_RXDMAEN) == I2C_CR1_RXDMAEN)
      {
        /* Abort DMA Xfer if any */
        if (hi2c->hdmarx != NULL)
        {
          hi2c->Instance->CR1 &= ~I2C_CR1_RXDMAEN;

          /* Set the I2C DMA Abort callback :
          will lead to call HAL_I2C_ErrorCallback() at end of DMA abort procedure */
          hi2c->hdmarx->XferAbortCallback = I2C_DMAAbort;

          /* Abort DMA RX */
          if (HAL_DMA_Abort_IT(hi2c->hdmarx) != HAL_OK)
          {
            /* Call Directly XferAbortCallback function in case of error */
            hi2c->hdmarx->XferAbortCallback(hi2c->hdmarx);
          }
        }
      }
    }
    else if (hi2c->State == HAL_I2C_STATE_BUSY_TX_LISTEN)
    {
      if ((hi2c->Instance->CR1 & I2C_CR1_TXDMAEN) == I2C_CR1_TXDMAEN)
      {
        hi2c->Instance->CR1 &= ~I2C_CR1_TXDMAEN;

        /* Abort DMA Xfer if any */
        if (hi2c->hdmatx != NULL)
        {
          /* Set the I2C DMA Abort callback :
          will lead to call HAL_I2C_ErrorCallback() at end of DMA abort procedure */
          hi2c->hdmatx->XferAbortCallback = I2C_DMAAbort;

          /* Abort DMA TX */
          if (HAL_DMA_Abort_IT(hi2c->hdmatx) != HAL_OK)
          {
            /* Call Directly XferAbortCallback function in case of error */
            hi2c->hdmatx->XferAbortCallback(hi2c->hdmatx);
          }
        }
      }
    }
    else
    {
      /* Nothing to do */
    }

    hi2c->State     = HAL_I2C_STATE_BUSY_TX_LISTEN;
    hi2c->Mode      = HAL_I2C_MODE_SLAVE;
    hi2c->ErrorCode = HAL_I2C_ERROR_NONE;

    /* Enable Address Acknowledge */
    hi2c->Instance->CR2 &= ~I2C_CR2_NACK;

    /* Prepare transfer parameters */
    hi2c->pBuffPtr    = pData;
    hi2c->XferCount   = Size;
    hi2c->XferSize    = hi2c->XferCount;
    hi2c->XferOptions = XferOptions;
    hi2c->XferISR     = I2C_Slave_ISR_DMA;

    if (hi2c->hdmatx != NULL)
    {
      /* Set the I2C DMA transfer complete callback */
      hi2c->hdmatx->XferCpltCallback = I2C_DMASlaveTransmitCplt;

      /* Set the DMA error callback */
      hi2c->hdmatx->XferErrorCallback = I2C_DMAError;

      /* Set the unused DMA callbacks to NULL */
      hi2c->hdmatx->XferHalfCpltCallback = NULL;
      hi2c->hdmatx->XferAbortCallback = NULL;

      /* Enable the DMA channel */
      if ((hi2c->hdmatx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
      {
        if (hi2c->hdmatx->LinkedListQueue != NULL)
        {
          /* Set DMA data size */
          hi2c->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = hi2c->XferSize;

          /* Set DMA source address */
          hi2c->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = (uint32_t)pData;

          /* Set DMA destination address */
          hi2c->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] \
            = (uint32_t)&hi2c->Instance->TXDR;

          dmaxferstatus = HAL_DMAEx_List_Start_IT(hi2c->hdmatx);
        }
        else
        {
          /* Update I2C state */
          hi2c->State     = HAL_I2C_STATE_LISTEN;
          hi2c->Mode      = HAL_I2C_MODE_NONE;

          /* Update I2C error code */
          hi2c->ErrorCode |= HAL_I2C_ERROR_DMA_PARAM;

          /* Process Unlocked */
          __HAL_UNLOCK(hi2c);

          return HAL_ERROR;
        }
      }
      else
      {
        dmaxferstatus = HAL_DMA_Start_IT(hi2c->hdmatx, (uint32_t)pData, (uint32_t)&hi2c->Instance->TXDR,
                                         hi2c->XferSize);
      }
    }
    else
    {
      /* Update I2C state */
      hi2c->State     = HAL_I2C_STATE_LISTEN;
      hi2c->Mode      = HAL_I2C_MODE_NONE;

      /* Update I2C error code */
      hi2c->ErrorCode |= HAL_I2C_ERROR_DMA_PARAM;

      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);

      return HAL_ERROR;
    }

    if (dmaxferstatus == HAL_OK)
    {
      /* Update XferCount value */
      hi2c->XferCount -= hi2c->XferSize;

      /* Reset XferSize */
      hi2c->XferSize = 0;
    }
    else
    {
      /* Update I2C state */
      hi2c->State     = HAL_I2C_STATE_LISTEN;
      hi2c->Mode      = HAL_I2C_MODE_NONE;

      /* Update I2C error code */
      hi2c->ErrorCode |= HAL_I2C_ERROR_DMA;

      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);

      return HAL_ERROR;
    }

    tmp = __HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_ADDR);
    if ((I2C_GET_DIR(hi2c) == I2C_DIRECTION_RECEIVE) && (tmp != RESET))
    {
      /* Clear ADDR flag after prepare the transfer parameters */
      /* This action will generate an acknowledge to the Master */
      __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_ADDR);
    }

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    /* Enable DMA Request */
    hi2c->Instance->CR1 |= I2C_CR1_TXDMAEN;

    /* Note : The I2C interrupts must be enabled after unlocking current process
    to avoid the risk of I2C interrupt handle execution before current
    process unlock */
    /* Enable ERR, STOP, NACK, ADDR interrupts */
    I2C_Enable_IRQ(hi2c, I2C_XFER_LISTEN_IT);

    return HAL_OK;
  }
  else
  {
    return HAL_ERROR;
  }
}
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Slave_Seq_Receive_IT(I2C_HandleTypeDef *hi2c, uint8_t *pData, uint16_t Size,
                                               uint32_t XferOptions)
{
  /* Declaration of tmp to prevent undefined behavior of volatile usage */
  FlagStatus tmp;

  /* Check the parameters */
  assert_param(IS_I2C_TRANSFER_OPTIONS_REQUEST(XferOptions));

  if (((uint32_t)hi2c->State & (uint32_t)HAL_I2C_STATE_LISTEN) == (uint32_t)HAL_I2C_STATE_LISTEN)
  {
    if ((pData == NULL) || (Size == 0U))
    {
      hi2c->ErrorCode = HAL_I2C_ERROR_INVALID_PARAM;
      return  HAL_ERROR;
    }

    /* Disable Interrupts, to prevent preemption during treatment in case of multicall */
    I2C_Disable_IRQ(hi2c, I2C_XFER_LISTEN_IT | I2C_XFER_RX_IT);

    /* Process Locked */
    __HAL_LOCK(hi2c);

    /* I2C cannot manage full duplex exchange so disable previous IT enabled if any */
    /* and then toggle the HAL slave TX state to RX state */
    if (hi2c->State == HAL_I2C_STATE_BUSY_TX_LISTEN)
    {
      /* Disable associated Interrupts */
      I2C_Disable_IRQ(hi2c, I2C_XFER_TX_IT);

#if defined(HAL_DMA_MODULE_ENABLED)
      if ((hi2c->Instance->CR1 & I2C_CR1_TXDMAEN) == I2C_CR1_TXDMAEN)
      {
        hi2c->Instance->CR1 &= ~I2C_CR1_TXDMAEN;

        /* Abort DMA Xfer if any */
        if (hi2c->hdmatx != NULL)
        {
          /* Set the I2C DMA Abort callback :
           will lead to call HAL_I2C_ErrorCallback() at end of DMA abort procedure */
          hi2c->hdmatx->XferAbortCallback = I2C_DMAAbort;

          /* Abort DMA TX */
          if (HAL_DMA_Abort_IT(hi2c->hdmatx) != HAL_OK)
          {
            /* Call Directly XferAbortCallback function in case of error */
            hi2c->hdmatx->XferAbortCallback(hi2c->hdmatx);
          }
        }
      }
#endif /* HAL_DMA_MODULE_ENABLED */
    }

    hi2c->State     = HAL_I2C_STATE_BUSY_RX_LISTEN;
    hi2c->Mode      = HAL_I2C_MODE_SLAVE;
    hi2c->ErrorCode = HAL_I2C_ERROR_NONE;

    /* Enable Address Acknowledge */
    hi2c->Instance->CR2 &= ~I2C_CR2_NACK;

    /* Prepare transfer parameters */
    hi2c->pBuffPtr    = pData;
    hi2c->XferCount   = Size;
    hi2c->XferSize    = hi2c->XferCount;
    hi2c->XferOptions = XferOptions;
    hi2c->XferISR     = I2C_Slave_ISR_IT;

    tmp = __HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_ADDR);
    if ((I2C_GET_DIR(hi2c) == I2C_DIRECTION_TRANSMIT) && (tmp != RESET))
    {
      /* Clear ADDR flag after prepare the transfer parameters */
      /* This action will generate an acknowledge to the Master */
      __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_ADDR);
    }

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    /* Note : The I2C interrupts must be enabled after unlocking current process
    to avoid the risk of I2C interrupt handle execution before current
    process unlock */
    /* REnable ADDR interrupt */
    I2C_Enable_IRQ(hi2c, I2C_XFER_RX_IT | I2C_XFER_LISTEN_IT);

    return HAL_OK;
  }
  else
  {
    return HAL_ERROR;
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I2C_Slave_Seq_Receive_DMA(I2C_HandleTypeDef *hi2c, uint8_t *pData, uint16_t Size,
                                                uint32_t XferOptions)
{
  /* Declaration of tmp to prevent undefined behavior of volatile usage */
  FlagStatus tmp;
  HAL_StatusTypeDef dmaxferstatus;

  /* Check the parameters */
  assert_param(IS_I2C_TRANSFER_OPTIONS_REQUEST(XferOptions));

  if (((uint32_t)hi2c->State & (uint32_t)HAL_I2C_STATE_LISTEN) == (uint32_t)HAL_I2C_STATE_LISTEN)
  {
    if ((pData == NULL) || (Size == 0U))
    {
      hi2c->ErrorCode = HAL_I2C_ERROR_INVALID_PARAM;
      return  HAL_ERROR;
    }

    /* Disable Interrupts, to prevent preemption during treatment in case of multicall */
    I2C_Disable_IRQ(hi2c, I2C_XFER_LISTEN_IT | I2C_XFER_RX_IT);

    /* Process Locked */
    __HAL_LOCK(hi2c);

    /* I2C cannot manage full duplex exchange so disable previous IT enabled if any */
    /* and then toggle the HAL slave TX state to RX state */
    if (hi2c->State == HAL_I2C_STATE_BUSY_TX_LISTEN)
    {
      /* Disable associated Interrupts */
      I2C_Disable_IRQ(hi2c, I2C_XFER_TX_IT);

      if ((hi2c->Instance->CR1 & I2C_CR1_TXDMAEN) == I2C_CR1_TXDMAEN)
      {
        /* Abort DMA Xfer if any */
        if (hi2c->hdmatx != NULL)
        {
          hi2c->Instance->CR1 &= ~I2C_CR1_TXDMAEN;

          /* Set the I2C DMA Abort callback :
           will lead to call HAL_I2C_ErrorCallback() at end of DMA abort procedure */
          hi2c->hdmatx->XferAbortCallback = I2C_DMAAbort;

          /* Abort DMA TX */
          if (HAL_DMA_Abort_IT(hi2c->hdmatx) != HAL_OK)
          {
            /* Call Directly XferAbortCallback function in case of error */
            hi2c->hdmatx->XferAbortCallback(hi2c->hdmatx);
          }
        }
      }
    }
    else if (hi2c->State == HAL_I2C_STATE_BUSY_RX_LISTEN)
    {
      if ((hi2c->Instance->CR1 & I2C_CR1_RXDMAEN) == I2C_CR1_RXDMAEN)
      {
        hi2c->Instance->CR1 &= ~I2C_CR1_RXDMAEN;

        /* Abort DMA Xfer if any */
        if (hi2c->hdmarx != NULL)
        {
          /* Set the I2C DMA Abort callback :
           will lead to call HAL_I2C_ErrorCallback() at end of DMA abort procedure */
          hi2c->hdmarx->XferAbortCallback = I2C_DMAAbort;

          /* Abort DMA RX */
          if (HAL_DMA_Abort_IT(hi2c->hdmarx) != HAL_OK)
          {
            /* Call Directly XferAbortCallback function in case of error */
            hi2c->hdmarx->XferAbortCallback(hi2c->hdmarx);
          }
        }
      }
    }
    else
    {
      /* Nothing to do */
    }

    hi2c->State     = HAL_I2C_STATE_BUSY_RX_LISTEN;
    hi2c->Mode      = HAL_I2C_MODE_SLAVE;
    hi2c->ErrorCode = HAL_I2C_ERROR_NONE;

    /* Enable Address Acknowledge */
    hi2c->Instance->CR2 &= ~I2C_CR2_NACK;

    /* Prepare transfer parameters */
    hi2c->pBuffPtr    = pData;
    hi2c->XferCount   = Size;
    hi2c->XferSize    = hi2c->XferCount;
    hi2c->XferOptions = XferOptions;
    hi2c->XferISR     = I2C_Slave_ISR_DMA;

    if (hi2c->hdmarx != NULL)
    {
      /* Set the I2C DMA transfer complete callback */
      hi2c->hdmarx->XferCpltCallback = I2C_DMASlaveReceiveCplt;

      /* Set the DMA error callback */
      hi2c->hdmarx->XferErrorCallback = I2C_DMAError;

      /* Set the unused DMA callbacks to NULL */
      hi2c->hdmarx->XferHalfCpltCallback = NULL;
      hi2c->hdmarx->XferAbortCallback = NULL;

      /* Enable the DMA channel */
      if ((hi2c->hdmarx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
      {
        if (hi2c->hdmarx->LinkedListQueue != NULL)
        {
          /* Set DMA data size */
          hi2c->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = hi2c->XferSize;

          /* Set DMA source address */
          hi2c->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] \
            = (uint32_t)&hi2c->Instance->RXDR;

          /* Set DMA destination address */
          hi2c->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = (uint32_t)pData;

          dmaxferstatus = HAL_DMAEx_List_Start_IT(hi2c->hdmarx);
        }
        else
        {
          /* Update I2C state */
          hi2c->State     = HAL_I2C_STATE_LISTEN;
          hi2c->Mode      = HAL_I2C_MODE_NONE;

          /* Update I2C error code */
          hi2c->ErrorCode |= HAL_I2C_ERROR_DMA_PARAM;

          /* Process Unlocked */
          __HAL_UNLOCK(hi2c);

          return HAL_ERROR;
        }
      }
      else
      {
        dmaxferstatus = HAL_DMA_Start_IT(hi2c->hdmarx, (uint32_t)&hi2c->Instance->RXDR, (uint32_t)pData,
                                         hi2c->XferSize);
      }
    }
    else
    {
      /* Update I2C state */
      hi2c->State     = HAL_I2C_STATE_LISTEN;
      hi2c->Mode      = HAL_I2C_MODE_NONE;

      /* Update I2C error code */
      hi2c->ErrorCode |= HAL_I2C_ERROR_DMA_PARAM;

      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);

      return HAL_ERROR;
    }

    if (dmaxferstatus == HAL_OK)
    {
      /* Update XferCount value */
      hi2c->XferCount -= hi2c->XferSize;

      /* Reset XferSize */
      hi2c->XferSize = 0;
    }
    else
    {
      /* Update I2C state */
      hi2c->State     = HAL_I2C_STATE_LISTEN;
      hi2c->Mode      = HAL_I2C_MODE_NONE;

      /* Update I2C error code */
      hi2c->ErrorCode |= HAL_I2C_ERROR_DMA;

      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);

      return HAL_ERROR;
    }

    tmp = __HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_ADDR);
    if ((I2C_GET_DIR(hi2c) == I2C_DIRECTION_TRANSMIT) && (tmp != RESET))
    {
      /* Clear ADDR flag after prepare the transfer parameters */
      /* This action will generate an acknowledge to the Master */
      __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_ADDR);
    }

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    /* Enable DMA Request */
    hi2c->Instance->CR1 |= I2C_CR1_RXDMAEN;

    /* Note : The I2C interrupts must be enabled after unlocking current process
    to avoid the risk of I2C interrupt handle execution before current
    process unlock */
    /* REnable ADDR interrupt */
    I2C_Enable_IRQ(hi2c, I2C_XFER_RX_IT | I2C_XFER_LISTEN_IT);

    return HAL_OK;
  }
  else
  {
    return HAL_ERROR;
  }
}
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_EnableListen_IT(I2C_HandleTypeDef *hi2c)
{
  if (hi2c->State == HAL_I2C_STATE_READY)
  {
    hi2c->State = HAL_I2C_STATE_LISTEN;
    hi2c->XferISR = I2C_Slave_ISR_IT;

    /* Enable the Address Match interrupt */
    I2C_Enable_IRQ(hi2c, I2C_XFER_LISTEN_IT);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_DisableListen_IT(I2C_HandleTypeDef *hi2c)
{
  /* Declaration of tmp to prevent undefined behavior of volatile usage */
  uint32_t tmp;

  /* Disable Address listen mode only if a transfer is not ongoing */
  if (hi2c->State == HAL_I2C_STATE_LISTEN)
  {
    tmp = (uint32_t)(hi2c->State) & I2C_STATE_MSK;
    hi2c->PreviousState = tmp | (uint32_t)(hi2c->Mode);
    hi2c->State = HAL_I2C_STATE_READY;
    hi2c->Mode = HAL_I2C_MODE_NONE;
    hi2c->XferISR = NULL;

    /* Disable the Address Match interrupt */
    I2C_Disable_IRQ(hi2c, I2C_XFER_LISTEN_IT);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Master_Abort_IT(I2C_HandleTypeDef *hi2c, uint16_t DevAddress)
{
  HAL_I2C_ModeTypeDef tmp_mode = hi2c->Mode;

  if ((tmp_mode == HAL_I2C_MODE_MASTER) || (tmp_mode == HAL_I2C_MODE_MEM))
  {
    /* Process Locked */
    __HAL_LOCK(hi2c);

    /* Disable Interrupts and Store Previous state */
    if (hi2c->State == HAL_I2C_STATE_BUSY_TX)
    {
      I2C_Disable_IRQ(hi2c, I2C_XFER_TX_IT);
      hi2c->PreviousState = I2C_STATE_MASTER_BUSY_TX;
    }
    else if (hi2c->State == HAL_I2C_STATE_BUSY_RX)
    {
      I2C_Disable_IRQ(hi2c, I2C_XFER_RX_IT);
      hi2c->PreviousState = I2C_STATE_MASTER_BUSY_RX;
    }
    else
    {
      /* Do nothing */
    }

    /* Set State at HAL_I2C_STATE_ABORT */
    hi2c->State = HAL_I2C_STATE_ABORT;

    /* Set NBYTES to 1 to generate a dummy read on I2C peripheral */
    /* Set AUTOEND mode, this will generate a NACK then STOP condition to abort the current transfer */
    I2C_TransferConfig(hi2c, DevAddress, 1, I2C_AUTOEND_MODE, I2C_GENERATE_STOP);

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    /* Note : The I2C interrupts must be enabled after unlocking current process
              to avoid the risk of I2C interrupt handle execution before current
              process unlock */
    I2C_Enable_IRQ(hi2c, I2C_XFER_CPLT_IT);

    return HAL_OK;
  }
  else
  {
    /* Wrong usage of abort function */
    /* This function should be used only in case of abort monitored by master device */
    return HAL_ERROR;
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
void HAL_I2C_EV_IRQHandler(I2C_HandleTypeDef *hi2c) /* Derogation MISRAC2012-Rule-8.13 */
{
  /* Get current IT Flags and IT sources value */
  uint32_t itflags   = READ_REG(hi2c->Instance->ISR);
  uint32_t itsources = READ_REG(hi2c->Instance->CR1);

  /* I2C events treatment -------------------------------------*/
  if (hi2c->XferISR != NULL)
  {
    hi2c->XferISR(hi2c, itflags, itsources);
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
void HAL_I2C_ER_IRQHandler(I2C_HandleTypeDef *hi2c)
{
  uint32_t itflags   = READ_REG(hi2c->Instance->ISR);
  uint32_t itsources = READ_REG(hi2c->Instance->CR1);
  uint32_t tmperror;

  /* I2C Bus error interrupt occurred ------------------------------------*/
  if ((I2C_CHECK_FLAG(itflags, I2C_FLAG_BERR) != RESET) && \
      (I2C_CHECK_IT_SOURCE(itsources, I2C_IT_ERRI) != RESET))
  {
    hi2c->ErrorCode |= HAL_I2C_ERROR_BERR;

    /* Clear BERR flag */
    __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_BERR);
  }

  /* I2C Over-Run/Under-Run interrupt occurred ----------------------------------------*/
  if ((I2C_CHECK_FLAG(itflags, I2C_FLAG_OVR) != RESET) && \
      (I2C_CHECK_IT_SOURCE(itsources, I2C_IT_ERRI) != RESET))
  {
    hi2c->ErrorCode |= HAL_I2C_ERROR_OVR;

    /* Clear OVR flag */
    __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_OVR);
  }

  /* I2C Arbitration Loss error interrupt occurred -------------------------------------*/
  if ((I2C_CHECK_FLAG(itflags, I2C_FLAG_ARLO) != RESET) && \
      (I2C_CHECK_IT_SOURCE(itsources, I2C_IT_ERRI) != RESET))
  {
    hi2c->ErrorCode |= HAL_I2C_ERROR_ARLO;

    /* Clear ARLO flag */
    __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_ARLO);
  }

  /* Store current volatile hi2c->ErrorCode, misra rule */
  tmperror = hi2c->ErrorCode;

  /* Call the Error Callback in case of Error detected */
  if ((tmperror & (HAL_I2C_ERROR_BERR | HAL_I2C_ERROR_OVR | HAL_I2C_ERROR_ARLO)) !=  HAL_I2C_ERROR_NONE)
  {
    I2C_ITError(hi2c, tmperror);
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_I2C_StateTypeDef HAL_I2C_GetState(const I2C_HandleTypeDef *hi2c)
{
  /* Return I2C handle state */
  return hi2c->State;
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_I2C_ModeTypeDef HAL_I2C_GetMode(const I2C_HandleTypeDef *hi2c)
{
  return hi2c->Mode;
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
uint32_t HAL_I2C_GetError(const I2C_HandleTypeDef *hi2c)
{
  return hi2c->ErrorCode;
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static HAL_StatusTypeDef I2C_Master_ISR_IT(struct __I2C_HandleTypeDef *hi2c, uint32_t ITFlags,
                                           uint32_t ITSources)
{
  uint16_t devaddress;
  uint32_t tmpITFlags = ITFlags;

  /* Process Locked */
  __HAL_LOCK(hi2c);

  if ((I2C_CHECK_FLAG(tmpITFlags, I2C_FLAG_AF) != RESET) && \
      (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_NACKI) != RESET))
  {
    /* Clear NACK Flag */
    __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_AF);

    /* Set corresponding Error Code */
    /* No need to generate STOP, it is automatically done */
    /* Error callback will be send during stop flag treatment */
    hi2c->ErrorCode |= HAL_I2C_ERROR_AF;

    /* Flush TX register */
    I2C_Flush_TXDR(hi2c);
  }
  else if ((I2C_CHECK_FLAG(tmpITFlags, I2C_FLAG_RXNE) != RESET) && \
           (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_RXI) != RESET))
  {
    /* Remove RXNE flag on temporary variable as read done */
    tmpITFlags &= ~I2C_FLAG_RXNE;

    /* Read data from RXDR */
    *hi2c->pBuffPtr = (uint8_t)hi2c->Instance->RXDR;

    /* Increment Buffer pointer */
    hi2c->pBuffPtr++;

    hi2c->XferSize--;
    hi2c->XferCount--;
  }
  else if ((I2C_CHECK_FLAG(tmpITFlags, I2C_FLAG_TXIS) != RESET) && \
           (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_TXI) != RESET))
  {
    /* Write data to TXDR */
    hi2c->Instance->TXDR = *hi2c->pBuffPtr;

    /* Increment Buffer pointer */
    hi2c->pBuffPtr++;

    hi2c->XferSize--;
    hi2c->XferCount--;
  }
  else if ((I2C_CHECK_FLAG(tmpITFlags, I2C_FLAG_TCR) != RESET) && \
           (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_TCI) != RESET))
  {
    if ((hi2c->XferCount != 0U) && (hi2c->XferSize == 0U))
    {
      devaddress = (uint16_t)(hi2c->Instance->CR2 & I2C_CR2_SADD);

      if (hi2c->XferCount > MAX_NBYTE_SIZE)
      {
        hi2c->XferSize = MAX_NBYTE_SIZE;
        I2C_TransferConfig(hi2c, devaddress, (uint8_t)hi2c->XferSize, I2C_RELOAD_MODE, I2C_NO_STARTSTOP);
      }
      else
      {
        hi2c->XferSize = hi2c->XferCount;
        if (hi2c->XferOptions != I2C_NO_OPTION_FRAME)
        {
          I2C_TransferConfig(hi2c, devaddress, (uint8_t)hi2c->XferSize,
                             hi2c->XferOptions, I2C_NO_STARTSTOP);
        }
        else
        {
          I2C_TransferConfig(hi2c, devaddress, (uint8_t)hi2c->XferSize,
                             I2C_AUTOEND_MODE, I2C_NO_STARTSTOP);
        }
      }
    }
    else
    {
      /* Call TxCpltCallback() if no stop mode is set */
      if (I2C_GET_STOP_MODE(hi2c) != I2C_AUTOEND_MODE)
      {
        /* Call I2C Master Sequential complete process */
        I2C_ITMasterSeqCplt(hi2c);
      }
      else
      {
        /* Wrong size Status regarding TCR flag event */
        /* Call the corresponding callback to inform upper layer of End of Transfer */
        I2C_ITError(hi2c, HAL_I2C_ERROR_SIZE);
      }
    }
  }
  else if ((I2C_CHECK_FLAG(tmpITFlags, I2C_FLAG_TC) != RESET) && \
           (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_TCI) != RESET))
  {
    if (hi2c->XferCount == 0U)
    {
      if (I2C_GET_STOP_MODE(hi2c) != I2C_AUTOEND_MODE)
      {
        /* Generate a stop condition in case of no transfer option */
        if (hi2c->XferOptions == I2C_NO_OPTION_FRAME)
        {
          /* Generate Stop */
          hi2c->Instance->CR2 |= I2C_CR2_STOP;
        }
        else
        {
          /* Call I2C Master Sequential complete process */
          I2C_ITMasterSeqCplt(hi2c);
        }
      }
    }
    else
    {
      /* Wrong size Status regarding TC flag event */
      /* Call the corresponding callback to inform upper layer of End of Transfer */
      I2C_ITError(hi2c, HAL_I2C_ERROR_SIZE);
    }
  }
  else
  {
    /* Nothing to do */
  }

  if ((I2C_CHECK_FLAG(tmpITFlags, I2C_FLAG_STOPF) != RESET) && \
      (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_STOPI) != RESET))
  {
    /* Call I2C Master complete process */
    I2C_ITMasterCplt(hi2c, tmpITFlags);
  }

  /* Process Unlocked */
  __HAL_UNLOCK(hi2c);

  return HAL_OK;
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static HAL_StatusTypeDef I2C_Mem_ISR_IT(struct __I2C_HandleTypeDef *hi2c, uint32_t ITFlags,
                                        uint32_t ITSources)
{
  uint32_t direction = I2C_GENERATE_START_WRITE;
  uint32_t tmpITFlags = ITFlags;

  /* Process Locked */
  __HAL_LOCK(hi2c);

  if ((I2C_CHECK_FLAG(tmpITFlags, I2C_FLAG_AF) != RESET) && \
      (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_NACKI) != RESET))
  {
    /* Clear NACK Flag */
    __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_AF);

    /* Set corresponding Error Code */
    /* No need to generate STOP, it is automatically done */
    /* Error callback will be send during stop flag treatment */
    hi2c->ErrorCode |= HAL_I2C_ERROR_AF;

    /* Flush TX register */
    I2C_Flush_TXDR(hi2c);
  }
  else if ((I2C_CHECK_FLAG(tmpITFlags, I2C_FLAG_RXNE) != RESET) && \
           (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_RXI) != RESET))
  {
    /* Remove RXNE flag on temporary variable as read done */
    tmpITFlags &= ~I2C_FLAG_RXNE;

    /* Read data from RXDR */
    *hi2c->pBuffPtr = (uint8_t)hi2c->Instance->RXDR;

    /* Increment Buffer pointer */
    hi2c->pBuffPtr++;

    hi2c->XferSize--;
    hi2c->XferCount--;
  }
  else if ((I2C_CHECK_FLAG(tmpITFlags, I2C_FLAG_TXIS) != RESET) && \
           (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_TXI) != RESET))
  {
    if (hi2c->Memaddress == 0xFFFFFFFFU)
    {
      /* Write data to TXDR */
      hi2c->Instance->TXDR = *hi2c->pBuffPtr;

      /* Increment Buffer pointer */
      hi2c->pBuffPtr++;

      hi2c->XferSize--;
      hi2c->XferCount--;
    }
    else
    {
      /* Write LSB part of Memory Address */
      hi2c->Instance->TXDR = hi2c->Memaddress;

      /* Reset Memaddress content */
      hi2c->Memaddress = 0xFFFFFFFFU;
    }
  }
  else if ((I2C_CHECK_FLAG(tmpITFlags, I2C_FLAG_TCR) != RESET) && \
           (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_TCI) != RESET))
  {
    if ((hi2c->XferCount != 0U) && (hi2c->XferSize == 0U))
    {
      if (hi2c->XferCount > MAX_NBYTE_SIZE)
      {
        hi2c->XferSize = MAX_NBYTE_SIZE;
        I2C_TransferConfig(hi2c, (uint16_t)hi2c->Devaddress, (uint8_t)hi2c->XferSize,
                           I2C_RELOAD_MODE, I2C_NO_STARTSTOP);
      }
      else
      {
        hi2c->XferSize = hi2c->XferCount;
        I2C_TransferConfig(hi2c, (uint16_t)hi2c->Devaddress, (uint8_t)hi2c->XferSize,
                           I2C_AUTOEND_MODE, I2C_NO_STARTSTOP);
      }
    }
    else
    {
      /* Wrong size Status regarding TCR flag event */
      /* Call the corresponding callback to inform upper layer of End of Transfer */
      I2C_ITError(hi2c, HAL_I2C_ERROR_SIZE);
    }
  }
  else if ((I2C_CHECK_FLAG(tmpITFlags, I2C_FLAG_TC) != RESET) && \
           (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_TCI) != RESET))
  {
    /* Disable Interrupt related to address step */
    I2C_Disable_IRQ(hi2c, I2C_XFER_TX_IT);

    /* Enable ERR, TC, STOP, NACK and RXI interrupts */
    I2C_Enable_IRQ(hi2c, I2C_XFER_RX_IT);

    if (hi2c->State == HAL_I2C_STATE_BUSY_RX)
    {
      direction = I2C_GENERATE_START_READ;
    }

    if (hi2c->XferCount > MAX_NBYTE_SIZE)
    {
      hi2c->XferSize = MAX_NBYTE_SIZE;

      /* Set NBYTES to write and reload if hi2c->XferCount > MAX_NBYTE_SIZE and generate RESTART */
      I2C_TransferConfig(hi2c, (uint16_t)hi2c->Devaddress, (uint8_t)hi2c->XferSize,
                         I2C_RELOAD_MODE, direction);
    }
    else
    {
      hi2c->XferSize = hi2c->XferCount;

      /* Set NBYTES to write and generate RESTART */
      I2C_TransferConfig(hi2c, (uint16_t)hi2c->Devaddress, (uint8_t)hi2c->XferSize,
                         I2C_AUTOEND_MODE, direction);
    }
  }
  else
  {
    /* Nothing to do */
  }

  if ((I2C_CHECK_FLAG(tmpITFlags, I2C_FLAG_STOPF) != RESET) && \
      (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_STOPI) != RESET))
  {
    /* Call I2C Master complete process */
    I2C_ITMasterCplt(hi2c, tmpITFlags);
  }

  /* Process Unlocked */
  __HAL_UNLOCK(hi2c);

  return HAL_OK;
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static HAL_StatusTypeDef I2C_Slave_ISR_IT(struct __I2C_HandleTypeDef *hi2c, uint32_t ITFlags,
                                          uint32_t ITSources)
{
  uint32_t tmpoptions = hi2c->XferOptions;
  uint32_t tmpITFlags = ITFlags;

  /* Process locked */
  __HAL_LOCK(hi2c);

  /* Check if STOPF is set */
  if ((I2C_CHECK_FLAG(tmpITFlags, I2C_FLAG_STOPF) != RESET) && \
      (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_STOPI) != RESET))
  {
    /* Call I2C Slave complete process */
    I2C_ITSlaveCplt(hi2c, tmpITFlags);
  }
  else if ((I2C_CHECK_FLAG(tmpITFlags, I2C_FLAG_AF) != RESET) && \
           (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_NACKI) != RESET))
  {
    /* Check that I2C transfer finished */
    /* if yes, normal use case, a NACK is sent by the MASTER when Transfer is finished */
    /* Mean XferCount == 0*/
    /* So clear Flag NACKF only */
    if (hi2c->XferCount == 0U)
    {
      if ((hi2c->State == HAL_I2C_STATE_LISTEN) && (tmpoptions == I2C_FIRST_AND_LAST_FRAME))
        /* Same action must be done for (tmpoptions == I2C_LAST_FRAME) which removed for
           Warning[Pa134]: left and right operands are identical */
      {
        /* Call I2C Listen complete process */
        I2C_ITListenCplt(hi2c, tmpITFlags);
      }
      else if ((hi2c->State == HAL_I2C_STATE_BUSY_TX_LISTEN) && (tmpoptions != I2C_NO_OPTION_FRAME))
      {
        /* Clear NACK Flag */
        __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_AF);

        /* Flush TX register */
        I2C_Flush_TXDR(hi2c);

        /* Last Byte is Transmitted */
        /* Call I2C Slave Sequential complete process */
        I2C_ITSlaveSeqCplt(hi2c);
      }
      else
      {
        /* Clear NACK Flag */
        __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_AF);
      }
    }
    else
    {
      /* if no, error use case, a Non-Acknowledge of last Data is generated by the MASTER*/
      /* Clear NACK Flag */
      __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_AF);

      /* Set ErrorCode corresponding to a Non-Acknowledge */
      hi2c->ErrorCode |= HAL_I2C_ERROR_AF;

      if ((tmpoptions == I2C_FIRST_FRAME) || (tmpoptions == I2C_NEXT_FRAME))
      {
        /* Call the corresponding callback to inform upper layer of End of Transfer */
        I2C_ITError(hi2c, hi2c->ErrorCode);
      }
    }
  }
  else if ((I2C_CHECK_FLAG(tmpITFlags, I2C_FLAG_RXNE) != RESET) && \
           (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_RXI) != RESET))
  {
    if (hi2c->XferCount > 0U)
    {
      /* Read data from RXDR */
      *hi2c->pBuffPtr = (uint8_t)hi2c->Instance->RXDR;

      /* Increment Buffer pointer */
      hi2c->pBuffPtr++;

      hi2c->XferSize--;
      hi2c->XferCount--;
    }

    if ((hi2c->XferCount == 0U) && \
        (tmpoptions != I2C_NO_OPTION_FRAME))
    {
      /* Call I2C Slave Sequential complete process */
      I2C_ITSlaveSeqCplt(hi2c);
    }
  }
  else if ((I2C_CHECK_FLAG(tmpITFlags, I2C_FLAG_ADDR) != RESET) && \
           (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_ADDRI) != RESET))
  {
    I2C_ITAddrCplt(hi2c, tmpITFlags);
  }
  else if ((I2C_CHECK_FLAG(tmpITFlags, I2C_FLAG_TXIS) != RESET) && \
           (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_TXI) != RESET))
  {
    /* Write data to TXDR only if XferCount not reach "0" */
    /* A TXIS flag can be set, during STOP treatment      */
    /* Check if all Data have already been sent */
    /* If it is the case, this last write in TXDR is not sent, correspond to a dummy TXIS event */
    if (hi2c->XferCount > 0U)
    {
      /* Write data to TXDR */
      hi2c->Instance->TXDR = *hi2c->pBuffPtr;

      /* Increment Buffer pointer */
      hi2c->pBuffPtr++;

      hi2c->XferCount--;
      hi2c->XferSize--;
    }
    else
    {
      if ((tmpoptions == I2C_NEXT_FRAME) || (tmpoptions == I2C_FIRST_FRAME))
      {
        /* Last Byte is Transmitted */
        /* Call I2C Slave Sequential complete process */
        I2C_ITSlaveSeqCplt(hi2c);
      }
    }
  }
  else
  {
    /* Nothing to do */
  }

  /* Process Unlocked */
  __HAL_UNLOCK(hi2c);

  return HAL_OK;
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static HAL_StatusTypeDef I2C_Master_ISR_DMA(struct __I2C_HandleTypeDef *hi2c, uint32_t ITFlags,
                                            uint32_t ITSources)
{
  uint16_t devaddress;
  uint32_t xfermode;

  /* Process Locked */
  __HAL_LOCK(hi2c);

  if ((I2C_CHECK_FLAG(ITFlags, I2C_FLAG_AF) != RESET) && \
      (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_NACKI) != RESET))
  {
    /* Clear NACK Flag */
    __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_AF);

    /* Set corresponding Error Code */
    hi2c->ErrorCode |= HAL_I2C_ERROR_AF;

    /* No need to generate STOP, it is automatically done */
    /* But enable STOP interrupt, to treat it */
    /* Error callback will be send during stop flag treatment */
    I2C_Enable_IRQ(hi2c, I2C_XFER_CPLT_IT);

    /* Flush TX register */
    I2C_Flush_TXDR(hi2c);
  }
  else if ((I2C_CHECK_FLAG(ITFlags, I2C_FLAG_TCR) != RESET) && \
           (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_TCI) != RESET))
  {
    /* Disable TC interrupt */
    __HAL_I2C_DISABLE_IT(hi2c, I2C_IT_TCI);

    if (hi2c->XferCount != 0U)
    {
      /* Recover Slave address */
      devaddress = (uint16_t)(hi2c->Instance->CR2 & I2C_CR2_SADD);

      /* Prepare the new XferSize to transfer */
      if (hi2c->XferCount > MAX_NBYTE_SIZE)
      {
        hi2c->XferSize = MAX_NBYTE_SIZE;
        xfermode = I2C_RELOAD_MODE;
      }
      else
      {
        hi2c->XferSize = hi2c->XferCount;
        if (hi2c->XferOptions != I2C_NO_OPTION_FRAME)
        {
          xfermode = hi2c->XferOptions;
        }
        else
        {
          xfermode = I2C_AUTOEND_MODE;
        }
      }

      /* Set the new XferSize in Nbytes register */
      I2C_TransferConfig(hi2c, devaddress, (uint8_t)hi2c->XferSize, xfermode, I2C_NO_STARTSTOP);

      /* Update XferCount value */
      hi2c->XferCount -= hi2c->XferSize;

      /* Enable DMA Request */
      if (hi2c->State == HAL_I2C_STATE_BUSY_RX)
      {
        hi2c->Instance->CR1 |= I2C_CR1_RXDMAEN;
      }
      else
      {
        hi2c->Instance->CR1 |= I2C_CR1_TXDMAEN;
      }
    }
    else
    {
      /* Call TxCpltCallback() if no stop mode is set */
      if (I2C_GET_STOP_MODE(hi2c) != I2C_AUTOEND_MODE)
      {
        /* Call I2C Master Sequential complete process */
        I2C_ITMasterSeqCplt(hi2c);
      }
      else
      {
        /* Wrong size Status regarding TCR flag event */
        /* Call the corresponding callback to inform upper layer of End of Transfer */
        I2C_ITError(hi2c, HAL_I2C_ERROR_SIZE);
      }
    }
  }
  else if ((I2C_CHECK_FLAG(ITFlags, I2C_FLAG_TC) != RESET) && \
           (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_TCI) != RESET))
  {
    if (hi2c->XferCount == 0U)
    {
      if (I2C_GET_STOP_MODE(hi2c) != I2C_AUTOEND_MODE)
      {
        /* Generate a stop condition in case of no transfer option */
        if (hi2c->XferOptions == I2C_NO_OPTION_FRAME)
        {
          /* Generate Stop */
          hi2c->Instance->CR2 |= I2C_CR2_STOP;
        }
        else
        {
          /* Call I2C Master Sequential complete process */
          I2C_ITMasterSeqCplt(hi2c);
        }
      }
    }
    else
    {
      /* Wrong size Status regarding TC flag event */
      /* Call the corresponding callback to inform upper layer of End of Transfer */
      I2C_ITError(hi2c, HAL_I2C_ERROR_SIZE);
    }
  }
  else if ((I2C_CHECK_FLAG(ITFlags, I2C_FLAG_STOPF) != RESET) && \
           (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_STOPI) != RESET))
  {
    /* Call I2C Master complete process */
    I2C_ITMasterCplt(hi2c, ITFlags);
  }
  else
  {
    /* Nothing to do */
  }

  /* Process Unlocked */
  __HAL_UNLOCK(hi2c);

  return HAL_OK;
}
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static HAL_StatusTypeDef I2C_Mem_ISR_DMA(struct __I2C_HandleTypeDef *hi2c, uint32_t ITFlags,
                                         uint32_t ITSources)
{
  uint32_t direction = I2C_GENERATE_START_WRITE;

  /* Process Locked */
  __HAL_LOCK(hi2c);

  if ((I2C_CHECK_FLAG(ITFlags, I2C_FLAG_AF) != RESET) && \
      (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_NACKI) != RESET))
  {
    /* Clear NACK Flag */
    __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_AF);

    /* Set corresponding Error Code */
    hi2c->ErrorCode |= HAL_I2C_ERROR_AF;

    /* No need to generate STOP, it is automatically done */
    /* But enable STOP interrupt, to treat it */
    /* Error callback will be send during stop flag treatment */
    I2C_Enable_IRQ(hi2c, I2C_XFER_CPLT_IT);

    /* Flush TX register */
    I2C_Flush_TXDR(hi2c);
  }
  else if ((I2C_CHECK_FLAG(ITFlags, I2C_FLAG_TXIS) != RESET) && \
           (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_TXI) != RESET))
  {
    /* Write LSB part of Memory Address */
    hi2c->Instance->TXDR = hi2c->Memaddress;

    /* Reset Memaddress content */
    hi2c->Memaddress = 0xFFFFFFFFU;
  }
  else if ((I2C_CHECK_FLAG(ITFlags, I2C_FLAG_TCR) != RESET) && \
           (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_TCI) != RESET))
  {
    /* Disable Interrupt related to address step */
    I2C_Disable_IRQ(hi2c, I2C_XFER_TX_IT);

    /* Enable only Error interrupt */
    I2C_Enable_IRQ(hi2c, I2C_XFER_ERROR_IT);

    if (hi2c->XferCount != 0U)
    {
      /* Prepare the new XferSize to transfer */
      if (hi2c->XferCount > MAX_NBYTE_SIZE)
      {
        hi2c->XferSize = MAX_NBYTE_SIZE;
        I2C_TransferConfig(hi2c, (uint16_t)hi2c->Devaddress, (uint8_t)hi2c->XferSize,
                           I2C_RELOAD_MODE, I2C_NO_STARTSTOP);
      }
      else
      {
        hi2c->XferSize = hi2c->XferCount;
        I2C_TransferConfig(hi2c, (uint16_t)hi2c->Devaddress, (uint8_t)hi2c->XferSize,
                           I2C_AUTOEND_MODE, I2C_NO_STARTSTOP);
      }

      /* Update XferCount value */
      hi2c->XferCount -= hi2c->XferSize;

      /* Enable DMA Request */
      if (hi2c->State == HAL_I2C_STATE_BUSY_RX)
      {
        hi2c->Instance->CR1 |= I2C_CR1_RXDMAEN;
      }
      else
      {
        hi2c->Instance->CR1 |= I2C_CR1_TXDMAEN;
      }
    }
    else
    {
      /* Wrong size Status regarding TCR flag event */
      /* Call the corresponding callback to inform upper layer of End of Transfer */
      I2C_ITError(hi2c, HAL_I2C_ERROR_SIZE);
    }
  }
  else if ((I2C_CHECK_FLAG(ITFlags, I2C_FLAG_TC) != RESET) && \
           (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_TCI) != RESET))
  {
    /* Disable Interrupt related to address step */
    I2C_Disable_IRQ(hi2c, I2C_XFER_TX_IT);

    /* Enable only Error and NACK interrupt for data transfer */
    I2C_Enable_IRQ(hi2c, I2C_XFER_ERROR_IT);

    if (hi2c->State == HAL_I2C_STATE_BUSY_RX)
    {
      direction = I2C_GENERATE_START_READ;
    }

    if (hi2c->XferCount > MAX_NBYTE_SIZE)
    {
      hi2c->XferSize = MAX_NBYTE_SIZE;

      /* Set NBYTES to write and reload if hi2c->XferCount > MAX_NBYTE_SIZE and generate RESTART */
      I2C_TransferConfig(hi2c, (uint16_t)hi2c->Devaddress, (uint8_t)hi2c->XferSize,
                         I2C_RELOAD_MODE, direction);
    }
    else
    {
      hi2c->XferSize = hi2c->XferCount;

      /* Set NBYTES to write and generate RESTART */
      I2C_TransferConfig(hi2c, (uint16_t)hi2c->Devaddress, (uint8_t)hi2c->XferSize,
                         I2C_AUTOEND_MODE, direction);
    }

    /* Update XferCount value */
    hi2c->XferCount -= hi2c->XferSize;

    /* Enable DMA Request */
    if (hi2c->State == HAL_I2C_STATE_BUSY_RX)
    {
      hi2c->Instance->CR1 |= I2C_CR1_RXDMAEN;
    }
    else
    {
      hi2c->Instance->CR1 |= I2C_CR1_TXDMAEN;
    }
  }
  else if ((I2C_CHECK_FLAG(ITFlags, I2C_FLAG_STOPF) != RESET) && \
           (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_STOPI) != RESET))
  {
    /* Call I2C Master complete process */
    I2C_ITMasterCplt(hi2c, ITFlags);
  }
  else
  {
    /* Nothing to do */
  }

  /* Process Unlocked */
  __HAL_UNLOCK(hi2c);

  return HAL_OK;
}
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static HAL_StatusTypeDef I2C_Slave_ISR_DMA(struct __I2C_HandleTypeDef *hi2c, uint32_t ITFlags,
                                           uint32_t ITSources)
{
  uint32_t tmpoptions = hi2c->XferOptions;
  uint32_t treatdmanack = 0U;
  HAL_I2C_StateTypeDef tmpstate;

  /* Process locked */
  __HAL_LOCK(hi2c);

  /* Check if STOPF is set */
  if ((I2C_CHECK_FLAG(ITFlags, I2C_FLAG_STOPF) != RESET) && \
      (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_STOPI) != RESET))
  {
    /* Call I2C Slave complete process */
    I2C_ITSlaveCplt(hi2c, ITFlags);
  }
  else if ((I2C_CHECK_FLAG(ITFlags, I2C_FLAG_AF) != RESET) && \
           (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_NACKI) != RESET))
  {
    /* Check that I2C transfer finished */
    /* if yes, normal use case, a NACK is sent by the MASTER when Transfer is finished */
    /* Mean XferCount == 0 */
    /* So clear Flag NACKF only */
    if ((I2C_CHECK_IT_SOURCE(ITSources, I2C_CR1_TXDMAEN) != RESET) ||
        (I2C_CHECK_IT_SOURCE(ITSources, I2C_CR1_RXDMAEN) != RESET))
    {
      /* Split check of hdmarx, for MISRA compliance */
      if (hi2c->hdmarx != NULL)
      {
        if (I2C_CHECK_IT_SOURCE(ITSources, I2C_CR1_RXDMAEN) != RESET)
        {
          if (I2C_GET_DMA_REMAIN_DATA(hi2c->hdmarx) == 0U)
          {
            treatdmanack = 1U;
          }
        }
      }

      /* Split check of hdmatx, for MISRA compliance  */
      if (hi2c->hdmatx != NULL)
      {
        if (I2C_CHECK_IT_SOURCE(ITSources, I2C_CR1_TXDMAEN) != RESET)
        {
          if (I2C_GET_DMA_REMAIN_DATA(hi2c->hdmatx) == 0U)
          {
            treatdmanack = 1U;
          }
        }
      }

      if (treatdmanack == 1U)
      {
        if ((hi2c->State == HAL_I2C_STATE_LISTEN) && (tmpoptions == I2C_FIRST_AND_LAST_FRAME))
          /* Same action must be done for (tmpoptions == I2C_LAST_FRAME) which removed for
             Warning[Pa134]: left and right operands are identical */
        {
          /* Call I2C Listen complete process */
          I2C_ITListenCplt(hi2c, ITFlags);
        }
        else if ((hi2c->State == HAL_I2C_STATE_BUSY_TX_LISTEN) && (tmpoptions != I2C_NO_OPTION_FRAME))
        {
          /* Clear NACK Flag */
          __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_AF);

          /* Flush TX register */
          I2C_Flush_TXDR(hi2c);

          /* Last Byte is Transmitted */
          /* Call I2C Slave Sequential complete process */
          I2C_ITSlaveSeqCplt(hi2c);
        }
        else
        {
          /* Clear NACK Flag */
          __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_AF);
        }
      }
      else
      {
        /* if no, error use case, a Non-Acknowledge of last Data is generated by the MASTER*/
        /* Clear NACK Flag */
        __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_AF);

        /* Set ErrorCode corresponding to a Non-Acknowledge */
        hi2c->ErrorCode |= HAL_I2C_ERROR_AF;

        /* Store current hi2c->State, solve MISRA2012-Rule-13.5 */
        tmpstate = hi2c->State;

        if ((tmpoptions == I2C_FIRST_FRAME) || (tmpoptions == I2C_NEXT_FRAME))
        {
          if ((tmpstate == HAL_I2C_STATE_BUSY_TX) || (tmpstate == HAL_I2C_STATE_BUSY_TX_LISTEN))
          {
            hi2c->PreviousState = I2C_STATE_SLAVE_BUSY_TX;
          }
          else if ((tmpstate == HAL_I2C_STATE_BUSY_RX) || (tmpstate == HAL_I2C_STATE_BUSY_RX_LISTEN))
          {
            hi2c->PreviousState = I2C_STATE_SLAVE_BUSY_RX;
          }
          else
          {
            /* Do nothing */
          }

          /* Call the corresponding callback to inform upper layer of End of Transfer */
          I2C_ITError(hi2c, hi2c->ErrorCode);
        }
      }
    }
    else
    {
      /* Only Clear NACK Flag, no DMA treatment is pending */
      __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_AF);
    }
  }
  else if ((I2C_CHECK_FLAG(ITFlags, I2C_FLAG_ADDR) != RESET) && \
           (I2C_CHECK_IT_SOURCE(ITSources, I2C_IT_ADDRI) != RESET))
  {
    I2C_ITAddrCplt(hi2c, ITFlags);
  }
  else
  {
    /* Nothing to do */
  }

  /* Process Unlocked */
  __HAL_UNLOCK(hi2c);

  return HAL_OK;
}
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static HAL_StatusTypeDef I2C_RequestMemoryWrite(I2C_HandleTypeDef *hi2c, uint16_t DevAddress,
                                                uint16_t MemAddress, uint16_t MemAddSize, uint32_t Timeout,
                                                uint32_t Tickstart)
{
  I2C_TransferConfig(hi2c, DevAddress, (uint8_t)MemAddSize, I2C_RELOAD_MODE, I2C_GENERATE_START_WRITE);

  /* Wait until TXIS flag is set */
  if (I2C_WaitOnTXISFlagUntilTimeout(hi2c, Timeout, Tickstart) != HAL_OK)
  {
    return HAL_ERROR;
  }

  /* If Memory address size is 8Bit */
  if (MemAddSize == I2C_MEMADD_SIZE_8BIT)
  {
    /* Send Memory Address */
    hi2c->Instance->TXDR = I2C_MEM_ADD_LSB(MemAddress);
  }
  /* If Memory address size is 16Bit */
  else
  {
    /* Send MSB of Memory Address */
    hi2c->Instance->TXDR = I2C_MEM_ADD_MSB(MemAddress);

    /* Wait until TXIS flag is set */
    if (I2C_WaitOnTXISFlagUntilTimeout(hi2c, Timeout, Tickstart) != HAL_OK)
    {
      return HAL_ERROR;
    }

    /* Send LSB of Memory Address */
    hi2c->Instance->TXDR = I2C_MEM_ADD_LSB(MemAddress);
  }

  /* Wait until TCR flag is set */
  if (I2C_WaitOnFlagUntilTimeout(hi2c, I2C_FLAG_TCR, RESET, Timeout, Tickstart) != HAL_OK)
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static HAL_StatusTypeDef I2C_RequestMemoryRead(I2C_HandleTypeDef *hi2c, uint16_t DevAddress,
                                               uint16_t MemAddress, uint16_t MemAddSize, uint32_t Timeout,
                                               uint32_t Tickstart)
{
  I2C_TransferConfig(hi2c, DevAddress, (uint8_t)MemAddSize, I2C_SOFTEND_MODE, I2C_GENERATE_START_WRITE);

  /* Wait until TXIS flag is set */
  if (I2C_WaitOnTXISFlagUntilTimeout(hi2c, Timeout, Tickstart) != HAL_OK)
  {
    return HAL_ERROR;
  }

  /* If Memory address size is 8Bit */
  if (MemAddSize == I2C_MEMADD_SIZE_8BIT)
  {
    /* Send Memory Address */
    hi2c->Instance->TXDR = I2C_MEM_ADD_LSB(MemAddress);
  }
  /* If Memory address size is 16Bit */
  else
  {
    /* Send MSB of Memory Address */
    hi2c->Instance->TXDR = I2C_MEM_ADD_MSB(MemAddress);

    /* Wait until TXIS flag is set */
    if (I2C_WaitOnTXISFlagUntilTimeout(hi2c, Timeout, Tickstart) != HAL_OK)
    {
      return HAL_ERROR;
    }

    /* Send LSB of Memory Address */
    hi2c->Instance->TXDR = I2C_MEM_ADD_LSB(MemAddress);
  }

  /* Wait until TC flag is set */
  if (I2C_WaitOnFlagUntilTimeout(hi2c, I2C_FLAG_TC, RESET, Timeout, Tickstart) != HAL_OK)
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static void I2C_ITAddrCplt(I2C_HandleTypeDef *hi2c, uint32_t ITFlags)
{
  uint8_t transferdirection;
  uint16_t slaveaddrcode;
  uint16_t ownadd1code;
  uint16_t ownadd2code;

  /* Prevent unused argument(s) compilation warning */
  UNUSED(ITFlags);

  /* In case of Listen state, need to inform upper layer of address match code event */
  if (((uint32_t)hi2c->State & (uint32_t)HAL_I2C_STATE_LISTEN) == (uint32_t)HAL_I2C_STATE_LISTEN)
  {
    transferdirection = I2C_GET_DIR(hi2c);
    slaveaddrcode     = I2C_GET_ADDR_MATCH(hi2c);
    ownadd1code       = I2C_GET_OWN_ADDRESS1(hi2c);
    ownadd2code       = I2C_GET_OWN_ADDRESS2(hi2c);

    /* If 10bits addressing mode is selected */
    if (hi2c->Init.AddressingMode == I2C_ADDRESSINGMODE_10BIT)
    {
      if ((slaveaddrcode & SLAVE_ADDR_MSK) == ((ownadd1code >> SLAVE_ADDR_SHIFT) & SLAVE_ADDR_MSK))
      {
        slaveaddrcode = ownadd1code;
        hi2c->AddrEventCount++;
        if (hi2c->AddrEventCount == 2U)
        {
          /* Reset Address Event counter */
          hi2c->AddrEventCount = 0U;

          /* Clear ADDR flag */
          __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_ADDR);

          /* Process Unlocked */
          __HAL_UNLOCK(hi2c);

          /* Call Slave Addr callback */
#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
          hi2c->AddrCallback(hi2c, transferdirection, slaveaddrcode);
#else
          HAL_I2C_AddrCallback(hi2c, transferdirection, slaveaddrcode);
#endif /* USE_HAL_I2C_REGISTER_CALLBACKS */
        }
      }
      else
      {
        slaveaddrcode = ownadd2code;

        /* Disable ADDR Interrupts */
        I2C_Disable_IRQ(hi2c, I2C_XFER_LISTEN_IT);

        /* Process Unlocked */
        __HAL_UNLOCK(hi2c);

        /* Call Slave Addr callback */
#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
        hi2c->AddrCallback(hi2c, transferdirection, slaveaddrcode);
#else
        HAL_I2C_AddrCallback(hi2c, transferdirection, slaveaddrcode);
#endif /* USE_HAL_I2C_REGISTER_CALLBACKS */
      }
    }
    /* else 7 bits addressing mode is selected */
    else
    {
      /* Disable ADDR Interrupts */
      I2C_Disable_IRQ(hi2c, I2C_XFER_LISTEN_IT);

      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);

      /* Call Slave Addr callback */
#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
      hi2c->AddrCallback(hi2c, transferdirection, slaveaddrcode);
#else
      HAL_I2C_AddrCallback(hi2c, transferdirection, slaveaddrcode);
#endif /* USE_HAL_I2C_REGISTER_CALLBACKS */
    }
  }
  /* Else clear address flag only */
  else
  {
    /* Clear ADDR flag */
    __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_ADDR);

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static void I2C_ITMasterSeqCplt(I2C_HandleTypeDef *hi2c)
{
  /* Reset I2C handle mode */
  hi2c->Mode = HAL_I2C_MODE_NONE;

  /* No Generate Stop, to permit restart mode */
  /* The stop will be done at the end of transfer, when I2C_AUTOEND_MODE enable */
  if (hi2c->State == HAL_I2C_STATE_BUSY_TX)
  {
    hi2c->State         = HAL_I2C_STATE_READY;
    hi2c->PreviousState = I2C_STATE_MASTER_BUSY_TX;
    hi2c->XferISR       = NULL;

    /* Disable Interrupts */
    I2C_Disable_IRQ(hi2c, I2C_XFER_TX_IT);

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
    hi2c->MasterTxCpltCallback(hi2c);
#else
    HAL_I2C_MasterTxCpltCallback(hi2c);
#endif /* USE_HAL_I2C_REGISTER_CALLBACKS */
  }
  /* hi2c->State == HAL_I2C_STATE_BUSY_RX */
  else
  {
    hi2c->State         = HAL_I2C_STATE_READY;
    hi2c->PreviousState = I2C_STATE_MASTER_BUSY_RX;
    hi2c->XferISR       = NULL;

    /* Disable Interrupts */
    I2C_Disable_IRQ(hi2c, I2C_XFER_RX_IT);

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
    hi2c->MasterRxCpltCallback(hi2c);
#else
    HAL_I2C_MasterRxCpltCallback(hi2c);
#endif /* USE_HAL_I2C_REGISTER_CALLBACKS */
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static void I2C_ITSlaveSeqCplt(I2C_HandleTypeDef *hi2c)
{
  uint32_t tmpcr1value = READ_REG(hi2c->Instance->CR1);

  /* Reset I2C handle mode */
  hi2c->Mode = HAL_I2C_MODE_NONE;

#if defined(HAL_DMA_MODULE_ENABLED)
  /* If a DMA is ongoing, Update handle size context */
  if (I2C_CHECK_IT_SOURCE(tmpcr1value, I2C_CR1_TXDMAEN) != RESET)
  {
    /* Disable DMA Request */
    hi2c->Instance->CR1 &= ~I2C_CR1_TXDMAEN;
  }
  else if (I2C_CHECK_IT_SOURCE(tmpcr1value, I2C_CR1_RXDMAEN) != RESET)
  {
    /* Disable DMA Request */
    hi2c->Instance->CR1 &= ~I2C_CR1_RXDMAEN;
  }
  else
  {
    /* Do nothing */
  }
#endif /* HAL_DMA_MODULE_ENABLED */

  if (hi2c->State == HAL_I2C_STATE_BUSY_TX_LISTEN)
  {
    /* Remove HAL_I2C_STATE_SLAVE_BUSY_TX, keep only HAL_I2C_STATE_LISTEN */
    hi2c->State         = HAL_I2C_STATE_LISTEN;
    hi2c->PreviousState = I2C_STATE_SLAVE_BUSY_TX;

    /* Disable Interrupts */
    I2C_Disable_IRQ(hi2c, I2C_XFER_TX_IT);

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
    hi2c->SlaveTxCpltCallback(hi2c);
#else
    HAL_I2C_SlaveTxCpltCallback(hi2c);
#endif /* USE_HAL_I2C_REGISTER_CALLBACKS */
  }

  else if (hi2c->State == HAL_I2C_STATE_BUSY_RX_LISTEN)
  {
    /* Remove HAL_I2C_STATE_SLAVE_BUSY_RX, keep only HAL_I2C_STATE_LISTEN */
    hi2c->State         = HAL_I2C_STATE_LISTEN;
    hi2c->PreviousState = I2C_STATE_SLAVE_BUSY_RX;

    /* Disable Interrupts */
    I2C_Disable_IRQ(hi2c, I2C_XFER_RX_IT);

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
    hi2c->SlaveRxCpltCallback(hi2c);
#else
    HAL_I2C_SlaveRxCpltCallback(hi2c);
#endif /* USE_HAL_I2C_REGISTER_CALLBACKS */
  }
  else
  {
    /* Nothing to do */
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static void I2C_ITMasterCplt(I2C_HandleTypeDef *hi2c, uint32_t ITFlags)
{
  uint32_t tmperror;
  uint32_t tmpITFlags = ITFlags;
  __IO uint32_t tmpreg;

  /* Clear STOP Flag */
  __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_STOPF);

  /* Disable Interrupts and Store Previous state */
  if (hi2c->State == HAL_I2C_STATE_BUSY_TX)
  {
    I2C_Disable_IRQ(hi2c, I2C_XFER_TX_IT);
    hi2c->PreviousState = I2C_STATE_MASTER_BUSY_TX;
  }
  else if (hi2c->State == HAL_I2C_STATE_BUSY_RX)
  {
    I2C_Disable_IRQ(hi2c, I2C_XFER_RX_IT);
    hi2c->PreviousState = I2C_STATE_MASTER_BUSY_RX;
  }
  else
  {
    /* Do nothing */
  }

  /* Clear Configuration Register 2 */
  I2C_RESET_CR2(hi2c);

  /* Reset handle parameters */
  hi2c->XferISR       = NULL;
  hi2c->XferOptions   = I2C_NO_OPTION_FRAME;

  if (I2C_CHECK_FLAG(tmpITFlags, I2C_FLAG_AF) != RESET)
  {
    /* Clear NACK Flag */
    __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_AF);

    /* Set acknowledge error code */
    hi2c->ErrorCode |= HAL_I2C_ERROR_AF;
  }

  /* Fetch Last receive data if any */
  if ((hi2c->State == HAL_I2C_STATE_ABORT) && (I2C_CHECK_FLAG(tmpITFlags, I2C_FLAG_RXNE) != RESET))
  {
    /* Read data from RXDR */
    tmpreg = (uint8_t)hi2c->Instance->RXDR;
    UNUSED(tmpreg);
  }

  /* Flush TX register */
  I2C_Flush_TXDR(hi2c);

  /* Store current volatile hi2c->ErrorCode, misra rule */
  tmperror = hi2c->ErrorCode;

  /* Call the corresponding callback to inform upper layer of End of Transfer */
  if ((hi2c->State == HAL_I2C_STATE_ABORT) || (tmperror != HAL_I2C_ERROR_NONE))
  {
    /* Call the corresponding callback to inform upper layer of End of Transfer */
    I2C_ITError(hi2c, hi2c->ErrorCode);
  }
  /* hi2c->State == HAL_I2C_STATE_BUSY_TX */
  else if (hi2c->State == HAL_I2C_STATE_BUSY_TX)
  {
    hi2c->State = HAL_I2C_STATE_READY;
    hi2c->PreviousState = I2C_STATE_NONE;

    if (hi2c->Mode == HAL_I2C_MODE_MEM)
    {
      hi2c->Mode = HAL_I2C_MODE_NONE;

      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);

      /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
      hi2c->MemTxCpltCallback(hi2c);
#else
      HAL_I2C_MemTxCpltCallback(hi2c);
#endif /* USE_HAL_I2C_REGISTER_CALLBACKS */
    }
    else
    {
      hi2c->Mode = HAL_I2C_MODE_NONE;

      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);

      /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
      hi2c->MasterTxCpltCallback(hi2c);
#else
      HAL_I2C_MasterTxCpltCallback(hi2c);
#endif /* USE_HAL_I2C_REGISTER_CALLBACKS */
    }
  }
  /* hi2c->State == HAL_I2C_STATE_BUSY_RX */
  else if (hi2c->State == HAL_I2C_STATE_BUSY_RX)
  {
    hi2c->State = HAL_I2C_STATE_READY;
    hi2c->PreviousState = I2C_STATE_NONE;

    if (hi2c->Mode == HAL_I2C_MODE_MEM)
    {
      hi2c->Mode = HAL_I2C_MODE_NONE;

      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);

      /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
      hi2c->MemRxCpltCallback(hi2c);
#else
      HAL_I2C_MemRxCpltCallback(hi2c);
#endif /* USE_HAL_I2C_REGISTER_CALLBACKS */
    }
    else
    {
      hi2c->Mode = HAL_I2C_MODE_NONE;

      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);

      /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
      hi2c->MasterRxCpltCallback(hi2c);
#else
      HAL_I2C_MasterRxCpltCallback(hi2c);
#endif /* USE_HAL_I2C_REGISTER_CALLBACKS */
    }
  }
  else
  {
    /* Nothing to do */
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static void I2C_ITSlaveCplt(I2C_HandleTypeDef *hi2c, uint32_t ITFlags)
{
  uint32_t tmpcr1value = READ_REG(hi2c->Instance->CR1);
  uint32_t tmpITFlags = ITFlags;
  uint32_t tmpoptions = hi2c->XferOptions;
  HAL_I2C_StateTypeDef tmpstate = hi2c->State;

  /* Clear STOP Flag */
  __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_STOPF);

  /* Disable Interrupts and Store Previous state */
  if ((tmpstate == HAL_I2C_STATE_BUSY_TX) || (tmpstate == HAL_I2C_STATE_BUSY_TX_LISTEN))
  {
    I2C_Disable_IRQ(hi2c, I2C_XFER_LISTEN_IT | I2C_XFER_TX_IT);
    hi2c->PreviousState = I2C_STATE_SLAVE_BUSY_TX;
  }
  else if ((tmpstate == HAL_I2C_STATE_BUSY_RX) || (tmpstate == HAL_I2C_STATE_BUSY_RX_LISTEN))
  {
    I2C_Disable_IRQ(hi2c, I2C_XFER_LISTEN_IT | I2C_XFER_RX_IT);
    hi2c->PreviousState = I2C_STATE_SLAVE_BUSY_RX;
  }
  else if (tmpstate == HAL_I2C_STATE_LISTEN)
  {
    I2C_Disable_IRQ(hi2c, I2C_XFER_LISTEN_IT | I2C_XFER_TX_IT | I2C_XFER_RX_IT);
    hi2c->PreviousState = I2C_STATE_NONE;
  }
  else
  {
    /* Do nothing */
  }

  /* Disable Address Acknowledge */
  hi2c->Instance->CR2 |= I2C_CR2_NACK;

  /* Clear Configuration Register 2 */
  I2C_RESET_CR2(hi2c);

  /* Flush TX register */
  I2C_Flush_TXDR(hi2c);

#if defined(HAL_DMA_MODULE_ENABLED)
  /* If a DMA is ongoing, Update handle size context */
  if (I2C_CHECK_IT_SOURCE(tmpcr1value, I2C_CR1_TXDMAEN) != RESET)
  {
    /* Disable DMA Request */
    hi2c->Instance->CR1 &= ~I2C_CR1_TXDMAEN;

    if (hi2c->hdmatx != NULL)
    {
      hi2c->XferCount = (uint16_t)I2C_GET_DMA_REMAIN_DATA(hi2c->hdmatx);
    }
  }
  else if (I2C_CHECK_IT_SOURCE(tmpcr1value, I2C_CR1_RXDMAEN) != RESET)
  {
    /* Disable DMA Request */
    hi2c->Instance->CR1 &= ~I2C_CR1_RXDMAEN;

    if (hi2c->hdmarx != NULL)
    {
      hi2c->XferCount = (uint16_t)I2C_GET_DMA_REMAIN_DATA(hi2c->hdmarx);
    }
  }
  else
  {
    /* Do nothing */
  }
#endif /* HAL_DMA_MODULE_ENABLED */

  /* Store Last receive data if any */
  if (I2C_CHECK_FLAG(tmpITFlags, I2C_FLAG_RXNE) != RESET)
  {
    /* Remove RXNE flag on temporary variable as read done */
    tmpITFlags &= ~I2C_FLAG_RXNE;

    /* Read data from RXDR */
    *hi2c->pBuffPtr = (uint8_t)hi2c->Instance->RXDR;

    /* Increment Buffer pointer */
    hi2c->pBuffPtr++;

    if (hi2c->XferSize > 0U)
    {
      hi2c->XferSize--;
      hi2c->XferCount--;
    }
  }

  /* All data are not transferred, so set error code accordingly */
  if (hi2c->XferCount != 0U)
  {
    /* Set ErrorCode corresponding to a Non-Acknowledge */
    hi2c->ErrorCode |= HAL_I2C_ERROR_AF;
  }

  if ((I2C_CHECK_FLAG(tmpITFlags, I2C_FLAG_AF) != RESET) && \
      (I2C_CHECK_IT_SOURCE(tmpcr1value, I2C_IT_NACKI) != RESET))
  {
    /* Check that I2C transfer finished */
    /* if yes, normal use case, a NACK is sent by the MASTER when Transfer is finished */
    /* Mean XferCount == 0*/
    /* So clear Flag NACKF only */
    if (hi2c->XferCount == 0U)
    {
      if ((hi2c->State == HAL_I2C_STATE_LISTEN) && (tmpoptions == I2C_FIRST_AND_LAST_FRAME))
        /* Same action must be done for (tmpoptions == I2C_LAST_FRAME) which removed for
           Warning[Pa134]: left and right operands are identical */
      {
        /* Call I2C Listen complete process */
        I2C_ITListenCplt(hi2c, tmpITFlags);
      }
      else if ((hi2c->State == HAL_I2C_STATE_BUSY_TX_LISTEN) && (tmpoptions != I2C_NO_OPTION_FRAME))
      {
        /* Clear NACK Flag */
        __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_AF);

        /* Flush TX register */
        I2C_Flush_TXDR(hi2c);

        /* Last Byte is Transmitted */
        /* Call I2C Slave Sequential complete process */
        I2C_ITSlaveSeqCplt(hi2c);
      }
      else
      {
        /* Clear NACK Flag */
        __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_AF);
      }
    }
    else
    {
      /* if no, error use case, a Non-Acknowledge of last Data is generated by the MASTER*/
      /* Clear NACK Flag */
      __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_AF);

      /* Set ErrorCode corresponding to a Non-Acknowledge */
      hi2c->ErrorCode |= HAL_I2C_ERROR_AF;

      if ((tmpoptions == I2C_FIRST_FRAME) || (tmpoptions == I2C_NEXT_FRAME))
      {
        /* Call the corresponding callback to inform upper layer of End of Transfer */
        I2C_ITError(hi2c, hi2c->ErrorCode);
      }
    }
  }

  hi2c->Mode = HAL_I2C_MODE_NONE;
  hi2c->XferISR = NULL;

  if (hi2c->ErrorCode != HAL_I2C_ERROR_NONE)
  {
    /* Call the corresponding callback to inform upper layer of End of Transfer */
    I2C_ITError(hi2c, hi2c->ErrorCode);

    /* Call the Listen Complete callback, to inform upper layer of the end of Listen usecase */
    if (hi2c->State == HAL_I2C_STATE_LISTEN)
    {
      /* Call I2C Listen complete process */
      I2C_ITListenCplt(hi2c, tmpITFlags);
    }
  }
  else if (hi2c->XferOptions != I2C_NO_OPTION_FRAME)
  {
    /* Call the Sequential Complete callback, to inform upper layer of the end of Transfer */
    I2C_ITSlaveSeqCplt(hi2c);

    hi2c->XferOptions = I2C_NO_OPTION_FRAME;
    hi2c->State = HAL_I2C_STATE_READY;
    hi2c->PreviousState = I2C_STATE_NONE;

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    /* Call the Listen Complete callback, to inform upper layer of the end of Listen usecase */
#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
    hi2c->ListenCpltCallback(hi2c);
#else
    HAL_I2C_ListenCpltCallback(hi2c);
#endif /* USE_HAL_I2C_REGISTER_CALLBACKS */
  }
  /* Call the corresponding callback to inform upper layer of End of Transfer */
  else if (hi2c->State == HAL_I2C_STATE_BUSY_RX)
  {
    hi2c->State = HAL_I2C_STATE_READY;
    hi2c->PreviousState = I2C_STATE_NONE;

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
    hi2c->SlaveRxCpltCallback(hi2c);
#else
    HAL_I2C_SlaveRxCpltCallback(hi2c);
#endif /* USE_HAL_I2C_REGISTER_CALLBACKS */
  }
  else
  {
    hi2c->State = HAL_I2C_STATE_READY;
    hi2c->PreviousState = I2C_STATE_NONE;

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
    hi2c->SlaveTxCpltCallback(hi2c);
#else
    HAL_I2C_SlaveTxCpltCallback(hi2c);
#endif /* USE_HAL_I2C_REGISTER_CALLBACKS */
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static void I2C_ITListenCplt(I2C_HandleTypeDef *hi2c, uint32_t ITFlags)
{
  /* Reset handle parameters */
  hi2c->XferOptions = I2C_NO_OPTION_FRAME;
  hi2c->PreviousState = I2C_STATE_NONE;
  hi2c->State = HAL_I2C_STATE_READY;
  hi2c->Mode = HAL_I2C_MODE_NONE;
  hi2c->XferISR = NULL;

  /* Store Last receive data if any */
  if (I2C_CHECK_FLAG(ITFlags, I2C_FLAG_RXNE) != RESET)
  {
    /* Read data from RXDR */
    *hi2c->pBuffPtr = (uint8_t)hi2c->Instance->RXDR;

    /* Increment Buffer pointer */
    hi2c->pBuffPtr++;

    if (hi2c->XferSize > 0U)
    {
      hi2c->XferSize--;
      hi2c->XferCount--;

      /* Set ErrorCode corresponding to a Non-Acknowledge */
      hi2c->ErrorCode |= HAL_I2C_ERROR_AF;
    }
  }

  /* Disable all Interrupts*/
  I2C_Disable_IRQ(hi2c, I2C_XFER_LISTEN_IT | I2C_XFER_RX_IT | I2C_XFER_TX_IT);

  /* Clear NACK Flag */
  __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_AF);

  /* Process Unlocked */
  __HAL_UNLOCK(hi2c);

  /* Call the Listen Complete callback, to inform upper layer of the end of Listen usecase */
#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
  hi2c->ListenCpltCallback(hi2c);
#else
  HAL_I2C_ListenCpltCallback(hi2c);
#endif /* USE_HAL_I2C_REGISTER_CALLBACKS */
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static void I2C_ITError(I2C_HandleTypeDef *hi2c, uint32_t ErrorCode)
{
  HAL_I2C_StateTypeDef tmpstate = hi2c->State;

#if defined(HAL_DMA_MODULE_ENABLED)
  uint32_t tmppreviousstate;
#endif /* HAL_DMA_MODULE_ENABLED */

  /* Reset handle parameters */
  hi2c->Mode          = HAL_I2C_MODE_NONE;
  hi2c->XferOptions   = I2C_NO_OPTION_FRAME;
  hi2c->XferCount     = 0U;

  /* Set new error code */
  hi2c->ErrorCode |= ErrorCode;

  /* Disable Interrupts */
  if ((tmpstate == HAL_I2C_STATE_LISTEN)         ||
      (tmpstate == HAL_I2C_STATE_BUSY_TX_LISTEN) ||
      (tmpstate == HAL_I2C_STATE_BUSY_RX_LISTEN))
  {
    /* Disable all interrupts, except interrupts related to LISTEN state */
    I2C_Disable_IRQ(hi2c, I2C_XFER_RX_IT | I2C_XFER_TX_IT);

    /* keep HAL_I2C_STATE_LISTEN if set */
    hi2c->State         = HAL_I2C_STATE_LISTEN;
    hi2c->XferISR       = I2C_Slave_ISR_IT;
  }
  else
  {
    /* Disable all interrupts */
    I2C_Disable_IRQ(hi2c, I2C_XFER_LISTEN_IT | I2C_XFER_RX_IT | I2C_XFER_TX_IT);

    /* Flush TX register */
    I2C_Flush_TXDR(hi2c);

    /* If state is an abort treatment on going, don't change state */
    /* This change will be do later */
    if (hi2c->State != HAL_I2C_STATE_ABORT)
    {
      /* Set HAL_I2C_STATE_READY */
      hi2c->State         = HAL_I2C_STATE_READY;

      /* Check if a STOPF is detected */
      if (__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_STOPF) == SET)
      {
        if (__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_AF) == SET)
        {
          __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_AF);
          hi2c->ErrorCode |= HAL_I2C_ERROR_AF;
        }

        /* Clear STOP Flag */
        __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_STOPF);
      }

    }
    hi2c->XferISR       = NULL;
  }

#if defined(HAL_DMA_MODULE_ENABLED)
  /* Abort DMA TX transfer if any */
  tmppreviousstate = hi2c->PreviousState;

  if ((hi2c->hdmatx != NULL) && ((tmppreviousstate == I2C_STATE_MASTER_BUSY_TX) || \
                                 (tmppreviousstate == I2C_STATE_SLAVE_BUSY_TX)))
  {
    if ((hi2c->Instance->CR1 & I2C_CR1_TXDMAEN) == I2C_CR1_TXDMAEN)
    {
      hi2c->Instance->CR1 &= ~I2C_CR1_TXDMAEN;
    }

    if (HAL_DMA_GetState(hi2c->hdmatx) != HAL_DMA_STATE_READY)
    {
      /* Set the I2C DMA Abort callback :
       will lead to call HAL_I2C_ErrorCallback() at end of DMA abort procedure */
      hi2c->hdmatx->XferAbortCallback = I2C_DMAAbort;

      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);

      /* Abort DMA TX */
      if (HAL_DMA_Abort_IT(hi2c->hdmatx) != HAL_OK)
      {
        /* Call Directly XferAbortCallback function in case of error */
        hi2c->hdmatx->XferAbortCallback(hi2c->hdmatx);
      }
    }
    else
    {
      I2C_TreatErrorCallback(hi2c);
    }
  }
  /* Abort DMA RX transfer if any */
  else if ((hi2c->hdmarx != NULL) && ((tmppreviousstate == I2C_STATE_MASTER_BUSY_RX) || \
                                      (tmppreviousstate == I2C_STATE_SLAVE_BUSY_RX)))
  {
    if ((hi2c->Instance->CR1 & I2C_CR1_RXDMAEN) == I2C_CR1_RXDMAEN)
    {
      hi2c->Instance->CR1 &= ~I2C_CR1_RXDMAEN;
    }

    if (HAL_DMA_GetState(hi2c->hdmarx) != HAL_DMA_STATE_READY)
    {
      /* Set the I2C DMA Abort callback :
        will lead to call HAL_I2C_ErrorCallback() at end of DMA abort procedure */
      hi2c->hdmarx->XferAbortCallback = I2C_DMAAbort;

      /* Process Unlocked */
      __HAL_UNLOCK(hi2c);

      /* Abort DMA RX */
      if (HAL_DMA_Abort_IT(hi2c->hdmarx) != HAL_OK)
      {
        /* Call Directly hi2c->hdmarx->XferAbortCallback function in case of error */
        hi2c->hdmarx->XferAbortCallback(hi2c->hdmarx);
      }
    }
    else
    {
      I2C_TreatErrorCallback(hi2c);
    }
  }
  else
#endif /* HAL_DMA_MODULE_ENABLED */
  {
    I2C_TreatErrorCallback(hi2c);
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static void I2C_TreatErrorCallback(I2C_HandleTypeDef *hi2c)
{
  if (hi2c->State == HAL_I2C_STATE_ABORT)
  {
    hi2c->State = HAL_I2C_STATE_READY;
    hi2c->PreviousState = I2C_STATE_NONE;

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
    hi2c->AbortCpltCallback(hi2c);
#else
    HAL_I2C_AbortCpltCallback(hi2c);
#endif /* USE_HAL_I2C_REGISTER_CALLBACKS */
  }
  else
  {
    hi2c->PreviousState = I2C_STATE_NONE;

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);

    /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
    hi2c->ErrorCallback(hi2c);
#else
    HAL_I2C_ErrorCallback(hi2c);
#endif /* USE_HAL_I2C_REGISTER_CALLBACKS */
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static void I2C_Flush_TXDR(I2C_HandleTypeDef *hi2c)
{
  /* If a pending TXIS flag is set */
  /* Write a dummy data in TXDR to clear it */
  if (__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_TXIS) != RESET)
  {
    hi2c->Instance->TXDR = 0x00U;
  }

  /* Flush TX register if not empty */
  if (__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_TXE) == RESET)
  {
    __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_TXE);
  }
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static void I2C_DMAMasterTransmitCplt(DMA_HandleTypeDef *hdma)
{
  HAL_StatusTypeDef dmaxferstatus = HAL_OK;
  /* Derogation MISRAC2012-Rule-11.5 */
  I2C_HandleTypeDef *hi2c = (I2C_HandleTypeDef *)(((DMA_HandleTypeDef *)hdma)->Parent);

  /* Disable DMA Request */
  hi2c->Instance->CR1 &= ~I2C_CR1_TXDMAEN;

  /* If last transfer, enable STOP interrupt */
  if (hi2c->XferCount == 0U)
  {
    /* Enable STOP interrupt */
    I2C_Enable_IRQ(hi2c, I2C_XFER_CPLT_IT);
  }
  /* else prepare a new DMA transfer and enable TCReload interrupt */
  else
  {
    /* Update Buffer pointer */
    hi2c->pBuffPtr += hi2c->XferSize;

    /* Set the XferSize to transfer */
    if (hi2c->XferCount > MAX_NBYTE_SIZE)
    {
      hi2c->XferSize = MAX_NBYTE_SIZE;
    }
    else
    {
      hi2c->XferSize = hi2c->XferCount;
    }

    /* Enable the DMA channel */
    if ((hi2c->hdmatx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
    {
      if (hi2c->hdmatx->LinkedListQueue != NULL)
      {
        /* Set DMA data size */
        hi2c->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = hi2c->XferSize;

        /* Set DMA source address */
        hi2c->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = (uint32_t)hi2c->pBuffPtr;

        /* Set DMA destination address */
        hi2c->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = (uint32_t)&hi2c->Instance->TXDR;

        dmaxferstatus = HAL_DMAEx_List_Start_IT(hi2c->hdmatx);
      }
      else
      {
        /* Call the corresponding callback to inform upper layer of End of Transfer */
        I2C_ITError(hi2c, HAL_I2C_ERROR_DMA);
      }
    }
    else
    {
      dmaxferstatus = HAL_DMA_Start_IT(hi2c->hdmatx, (uint32_t)hi2c->pBuffPtr, (uint32_t)&hi2c->Instance->TXDR,
                                       hi2c->XferSize);
    }

    if (dmaxferstatus != HAL_OK)
    {
      /* Call the corresponding callback to inform upper layer of End of Transfer */
      I2C_ITError(hi2c, HAL_I2C_ERROR_DMA);
    }
    else
    {
      /* Enable TC interrupts */
      I2C_Enable_IRQ(hi2c, I2C_XFER_RELOAD_IT);
    }
  }
}
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static void I2C_DMASlaveTransmitCplt(DMA_HandleTypeDef *hdma)
{
  /* Derogation MISRAC2012-Rule-11.5 */
  I2C_HandleTypeDef *hi2c = (I2C_HandleTypeDef *)(((DMA_HandleTypeDef *)hdma)->Parent);
  uint32_t tmpoptions = hi2c->XferOptions;

  if ((tmpoptions == I2C_NEXT_FRAME) || (tmpoptions == I2C_FIRST_FRAME))
  {
    /* Disable DMA Request */
    hi2c->Instance->CR1 &= ~I2C_CR1_TXDMAEN;

    /* Last Byte is Transmitted */
    /* Call I2C Slave Sequential complete process */
    I2C_ITSlaveSeqCplt(hi2c);
  }
  else
  {
    /* No specific action, Master fully manage the generation of STOP condition */
    /* Mean that this generation can arrive at any time, at the end or during DMA process */
    /* So STOP condition should be manage through Interrupt treatment */
  }
}
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static void I2C_DMAMasterReceiveCplt(DMA_HandleTypeDef *hdma)
{
  HAL_StatusTypeDef dmaxferstatus = HAL_OK;
  /* Derogation MISRAC2012-Rule-11.5 */
  I2C_HandleTypeDef *hi2c = (I2C_HandleTypeDef *)(((DMA_HandleTypeDef *)hdma)->Parent);

  /* Disable DMA Request */
  hi2c->Instance->CR1 &= ~I2C_CR1_RXDMAEN;

  /* If last transfer, enable STOP interrupt */
  if (hi2c->XferCount == 0U)
  {
    /* Enable STOP interrupt */
    I2C_Enable_IRQ(hi2c, I2C_XFER_CPLT_IT);
  }
  /* else prepare a new DMA transfer and enable TCReload interrupt */
  else
  {
    /* Update Buffer pointer */
    hi2c->pBuffPtr += hi2c->XferSize;

    /* Set the XferSize to transfer */
    if (hi2c->XferCount > MAX_NBYTE_SIZE)
    {
      hi2c->XferSize = MAX_NBYTE_SIZE;
    }
    else
    {
      hi2c->XferSize = hi2c->XferCount;
    }

    /* Enable the DMA channel */
    if ((hi2c->hdmarx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
    {
      if (hi2c->hdmarx->LinkedListQueue != NULL)
      {
        /* Set DMA data size */
        hi2c->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = hi2c->XferSize;

        /* Set DMA source address */
        hi2c->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = (uint32_t)&hi2c->Instance->RXDR;

        /* Set DMA destination address */
        hi2c->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = (uint32_t)hi2c->pBuffPtr;

        dmaxferstatus = HAL_DMAEx_List_Start_IT(hi2c->hdmarx);
      }
      else
      {
        /* Call the corresponding callback to inform upper layer of End of Transfer */
        I2C_ITError(hi2c, HAL_I2C_ERROR_DMA);
      }
    }
    else
    {
      dmaxferstatus = HAL_DMA_Start_IT(hi2c->hdmarx, (uint32_t)&hi2c->Instance->RXDR, (uint32_t)hi2c->pBuffPtr,
                                       hi2c->XferSize);
    }

    if (dmaxferstatus != HAL_OK)
    {
      /* Call the corresponding callback to inform upper layer of End of Transfer */
      I2C_ITError(hi2c, HAL_I2C_ERROR_DMA);
    }
    else
    {
      /* Enable TC interrupts */
      I2C_Enable_IRQ(hi2c, I2C_XFER_RELOAD_IT);
    }
  }
}
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static void I2C_DMASlaveReceiveCplt(DMA_HandleTypeDef *hdma)
{
  /* Derogation MISRAC2012-Rule-11.5 */
  I2C_HandleTypeDef *hi2c = (I2C_HandleTypeDef *)(((DMA_HandleTypeDef *)hdma)->Parent);
  uint32_t tmpoptions = hi2c->XferOptions;

  if ((I2C_GET_DMA_REMAIN_DATA(hi2c->hdmarx) == 0U) && \
      (tmpoptions != I2C_NO_OPTION_FRAME))
  {
    /* Disable DMA Request */
    hi2c->Instance->CR1 &= ~I2C_CR1_RXDMAEN;

    /* Call I2C Slave Sequential complete process */
    I2C_ITSlaveSeqCplt(hi2c);
  }
  else
  {
    /* No specific action, Master fully manage the generation of STOP condition */
    /* Mean that this generation can arrive at any time, at the end or during DMA process */
    /* So STOP condition should be manage through Interrupt treatment */
  }
}
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static void I2C_DMAError(DMA_HandleTypeDef *hdma)
{
  /* Derogation MISRAC2012-Rule-11.5 */
  I2C_HandleTypeDef *hi2c = (I2C_HandleTypeDef *)(((DMA_HandleTypeDef *)hdma)->Parent);

  /* Disable Acknowledge */
  hi2c->Instance->CR2 |= I2C_CR2_NACK;

  /* Call the corresponding callback to inform upper layer of End of Transfer */
  I2C_ITError(hi2c, HAL_I2C_ERROR_DMA);
}
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static void I2C_DMAAbort(DMA_HandleTypeDef *hdma)
{
  /* Derogation MISRAC2012-Rule-11.5 */
  I2C_HandleTypeDef *hi2c = (I2C_HandleTypeDef *)(((DMA_HandleTypeDef *)hdma)->Parent);

  /* Reset AbortCpltCallback */
  if (hi2c->hdmatx != NULL)
  {
    hi2c->hdmatx->XferAbortCallback = NULL;
  }
  if (hi2c->hdmarx != NULL)
  {
    hi2c->hdmarx->XferAbortCallback = NULL;
  }

  I2C_TreatErrorCallback(hi2c);
}
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static HAL_StatusTypeDef I2C_WaitOnFlagUntilTimeout(I2C_HandleTypeDef *hi2c, uint32_t Flag, FlagStatus Status,
                                                    uint32_t Timeout, uint32_t Tickstart)
{
  while (__HAL_I2C_GET_FLAG(hi2c, Flag) == Status)
  {
    /* Check if an error is detected */
    if (I2C_IsErrorOccurred(hi2c, Timeout, Tickstart) != HAL_OK)
    {
      return HAL_ERROR;
    }

    /* Check for the Timeout */
    if (Timeout != HAL_MAX_DELAY)
    {
      if (((HAL_GetTick() - Tickstart) > Timeout) || (Timeout == 0U))
      {
        if (__HAL_I2C_GET_FLAG(hi2c, Flag) == Status)
        {
          hi2c->ErrorCode |= HAL_I2C_ERROR_TIMEOUT;
          hi2c->State = HAL_I2C_STATE_READY;
          hi2c->Mode = HAL_I2C_MODE_NONE;

          /* Process Unlocked */
          __HAL_UNLOCK(hi2c);
          return HAL_ERROR;
        }
      }
    }
  }
  return HAL_OK;
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static HAL_StatusTypeDef I2C_WaitOnTXISFlagUntilTimeout(I2C_HandleTypeDef *hi2c, uint32_t Timeout,
                                                        uint32_t Tickstart)
{
  while (__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_TXIS) == RESET)
  {
    /* Check if an error is detected */
    if (I2C_IsErrorOccurred(hi2c, Timeout, Tickstart) != HAL_OK)
    {
      return HAL_ERROR;
    }

    /* Check for the Timeout */
    if (Timeout != HAL_MAX_DELAY)
    {
      if (((HAL_GetTick() - Tickstart) > Timeout) || (Timeout == 0U))
      {
        if (__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_TXIS) == RESET)
        {
          hi2c->ErrorCode |= HAL_I2C_ERROR_TIMEOUT;
          hi2c->State = HAL_I2C_STATE_READY;
          hi2c->Mode = HAL_I2C_MODE_NONE;

          /* Process Unlocked */
          __HAL_UNLOCK(hi2c);

          return HAL_ERROR;
        }
      }
    }
  }
  return HAL_OK;
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static HAL_StatusTypeDef I2C_WaitOnSTOPFlagUntilTimeout(I2C_HandleTypeDef *hi2c, uint32_t Timeout,
                                                        uint32_t Tickstart)
{
  while (__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_STOPF) == RESET)
  {
    /* Check if an error is detected */
    if (I2C_IsErrorOccurred(hi2c, Timeout, Tickstart) != HAL_OK)
    {
      return HAL_ERROR;
    }

    /* Check for the Timeout */
    if (((HAL_GetTick() - Tickstart) > Timeout) || (Timeout == 0U))
    {
      if (__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_STOPF) == RESET)
      {
        hi2c->ErrorCode |= HAL_I2C_ERROR_TIMEOUT;
        hi2c->State = HAL_I2C_STATE_READY;
        hi2c->Mode = HAL_I2C_MODE_NONE;

        /* Process Unlocked */
        __HAL_UNLOCK(hi2c);

        return HAL_ERROR;
      }
    }
  }
  return HAL_OK;
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static HAL_StatusTypeDef I2C_WaitOnRXNEFlagUntilTimeout(I2C_HandleTypeDef *hi2c, uint32_t Timeout,
                                                        uint32_t Tickstart)
{
  HAL_StatusTypeDef status = HAL_OK;

  while ((__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_RXNE) == RESET) && (status == HAL_OK))
  {
    /* Check if an error is detected */
    if (I2C_IsErrorOccurred(hi2c, Timeout, Tickstart) != HAL_OK)
    {
      status = HAL_ERROR;
    }

    /* Check if a STOPF is detected */
    if ((__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_STOPF) == SET) && (status == HAL_OK))
    {
      /* Check if an RXNE is pending */
      /* Store Last receive data if any */
      if ((__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_RXNE) == SET) && (hi2c->XferSize > 0U))
      {
        /* Return HAL_OK */
        /* The Reading of data from RXDR will be done in caller function */
        status = HAL_OK;
      }

      /* Check a no-acknowledge have been detected */
      if (__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_AF) == SET)
      {
        __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_AF);
        hi2c->ErrorCode = HAL_I2C_ERROR_AF;

        /* Clear STOP Flag */
        __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_STOPF);

        /* Clear Configuration Register 2 */
        I2C_RESET_CR2(hi2c);

        hi2c->State = HAL_I2C_STATE_READY;
        hi2c->Mode = HAL_I2C_MODE_NONE;

        /* Process Unlocked */
        __HAL_UNLOCK(hi2c);

        status = HAL_ERROR;
      }
      else
      {
        hi2c->ErrorCode = HAL_I2C_ERROR_NONE;
      }
    }

    /* Check for the Timeout */
    if ((((HAL_GetTick() - Tickstart) > Timeout) || (Timeout == 0U)) && (status == HAL_OK))
    {
      if (__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_RXNE) == RESET)
      {
        hi2c->ErrorCode |= HAL_I2C_ERROR_TIMEOUT;
        hi2c->State = HAL_I2C_STATE_READY;

        /* Process Unlocked */
        __HAL_UNLOCK(hi2c);

        status = HAL_ERROR;
      }
    }
  }
  return status;
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static HAL_StatusTypeDef I2C_IsErrorOccurred(I2C_HandleTypeDef *hi2c, uint32_t Timeout, uint32_t Tickstart)
{
  HAL_StatusTypeDef status = HAL_OK;
  uint32_t itflag   = hi2c->Instance->ISR;
  uint32_t error_code = 0;
  uint32_t tickstart = Tickstart;
  uint32_t tmp1;
  HAL_I2C_ModeTypeDef tmp2;

  if (HAL_IS_BIT_SET(itflag, I2C_FLAG_AF))
  {
    /* Clear NACKF Flag */
    __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_AF);

    /* Wait until STOP Flag is set or timeout occurred */
    /* AutoEnd should be initiate after AF */
    while ((__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_STOPF) == RESET) && (status == HAL_OK))
    {
      /* Check for the Timeout */
      if (Timeout != HAL_MAX_DELAY)
      {
        if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
        {
          tmp1 = (uint32_t)(hi2c->Instance->CR2 & I2C_CR2_STOP);
          tmp2 = hi2c->Mode;

          /* In case of I2C still busy, try to regenerate a STOP manually */
          if ((__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_BUSY) != RESET) && \
              (tmp1 != I2C_CR2_STOP) && \
              (tmp2 != HAL_I2C_MODE_SLAVE))
          {
            /* Generate Stop */
            hi2c->Instance->CR2 |= I2C_CR2_STOP;

            /* Update Tick with new reference */
            tickstart = HAL_GetTick();
          }

          while (__HAL_I2C_GET_FLAG(hi2c, I2C_FLAG_STOPF) == RESET)
          {
            /* Check for the Timeout */
            if ((HAL_GetTick() - tickstart) > I2C_TIMEOUT_STOPF)
            {
              error_code |= HAL_I2C_ERROR_TIMEOUT;

              status = HAL_ERROR;

              break;
            }
          }
        }
      }
    }

    /* In case STOP Flag is detected, clear it */
    if (status == HAL_OK)
    {
      /* Clear STOP Flag */
      __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_STOPF);
    }

    error_code |= HAL_I2C_ERROR_AF;

    status = HAL_ERROR;
  }

  /* Refresh Content of Status register */
  itflag = hi2c->Instance->ISR;

  /* Then verify if an additional errors occurs */
  /* Check if a Bus error occurred */
  if (HAL_IS_BIT_SET(itflag, I2C_FLAG_BERR))
  {
    error_code |= HAL_I2C_ERROR_BERR;

    /* Clear BERR flag */
    __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_BERR);

    status = HAL_ERROR;
  }

  /* Check if an Over-Run/Under-Run error occurred */
  if (HAL_IS_BIT_SET(itflag, I2C_FLAG_OVR))
  {
    error_code |= HAL_I2C_ERROR_OVR;

    /* Clear OVR flag */
    __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_OVR);

    status = HAL_ERROR;
  }

  /* Check if an Arbitration Loss error occurred */
  if (HAL_IS_BIT_SET(itflag, I2C_FLAG_ARLO))
  {
    error_code |= HAL_I2C_ERROR_ARLO;

    /* Clear ARLO flag */
    __HAL_I2C_CLEAR_FLAG(hi2c, I2C_FLAG_ARLO);

    status = HAL_ERROR;
  }

  if (status != HAL_OK)
  {
    /* Flush TX register */
    I2C_Flush_TXDR(hi2c);

    /* Clear Configuration Register 2 */
    I2C_RESET_CR2(hi2c);

    hi2c->ErrorCode |= error_code;
    hi2c->State = HAL_I2C_STATE_READY;
    hi2c->Mode = HAL_I2C_MODE_NONE;

    /* Process Unlocked */
    __HAL_UNLOCK(hi2c);
  }

  return status;
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static void I2C_TransferConfig(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint8_t Size, uint32_t Mode,
                               uint32_t Request)
{
  uint32_t tmp;

  /* Check the parameters */
  assert_param(IS_I2C_ALL_INSTANCE(hi2c->Instance));
  assert_param(IS_TRANSFER_MODE(Mode));
  assert_param(IS_TRANSFER_REQUEST(Request));

  /* Declaration of tmp to prevent undefined behavior of volatile usage */
  tmp = ((uint32_t)(((uint32_t)DevAddress & I2C_CR2_SADD) | \
                    (((uint32_t)Size << I2C_CR2_NBYTES_Pos) & I2C_CR2_NBYTES) | \
                    (uint32_t)Mode | (uint32_t)Request) & (~0x80000000U));

  /* update CR2 register */
  MODIFY_REG(hi2c->Instance->CR2, \
             ((I2C_CR2_SADD | I2C_CR2_NBYTES | I2C_CR2_RELOAD | I2C_CR2_AUTOEND | \
               (I2C_CR2_RD_WRN & (uint32_t)(Request >> (31U - I2C_CR2_RD_WRN_Pos))) | \
               I2C_CR2_START | I2C_CR2_STOP)), tmp);
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static void I2C_Enable_IRQ(I2C_HandleTypeDef *hi2c, uint16_t InterruptRequest)
{
  uint32_t tmpisr = 0U;

#if defined(HAL_DMA_MODULE_ENABLED)
  if ((hi2c->XferISR != I2C_Master_ISR_DMA) && \
      (hi2c->XferISR != I2C_Slave_ISR_DMA) && \
      (hi2c->XferISR != I2C_Mem_ISR_DMA))
#endif /* HAL_DMA_MODULE_ENABLED */
  {
    if ((InterruptRequest & I2C_XFER_LISTEN_IT) == I2C_XFER_LISTEN_IT)
    {
      /* Enable ERR, STOP, NACK and ADDR interrupts */
      tmpisr |= I2C_IT_ADDRI | I2C_IT_STOPI | I2C_IT_NACKI | I2C_IT_ERRI;
    }

    if ((InterruptRequest & I2C_XFER_TX_IT) == I2C_XFER_TX_IT)
    {
      /* Enable ERR, TC, STOP, NACK and TXI interrupts */
      tmpisr |= I2C_IT_ERRI | I2C_IT_TCI | I2C_IT_STOPI | I2C_IT_NACKI | I2C_IT_TXI;
    }

    if ((InterruptRequest & I2C_XFER_RX_IT) == I2C_XFER_RX_IT)
    {
      /* Enable ERR, TC, STOP, NACK and RXI interrupts */
      tmpisr |= I2C_IT_ERRI | I2C_IT_TCI | I2C_IT_STOPI | I2C_IT_NACKI | I2C_IT_RXI;
    }

    if (InterruptRequest == I2C_XFER_ERROR_IT)
    {
      /* Enable ERR and NACK interrupts */
      tmpisr |= I2C_IT_ERRI | I2C_IT_NACKI;
    }

    if (InterruptRequest == I2C_XFER_CPLT_IT)
    {
      /* Enable STOP interrupts */
      tmpisr |= I2C_IT_STOPI;
    }
  }

#if defined(HAL_DMA_MODULE_ENABLED)
  else
  {
    if ((InterruptRequest & I2C_XFER_LISTEN_IT) == I2C_XFER_LISTEN_IT)
    {
      /* Enable ERR, STOP, NACK and ADDR interrupts */
      tmpisr |= I2C_IT_ADDRI | I2C_IT_STOPI | I2C_IT_NACKI | I2C_IT_ERRI;
    }

    if ((InterruptRequest & I2C_XFER_TX_IT) == I2C_XFER_TX_IT)
    {
      /* Enable ERR, TC, STOP, NACK and TXI interrupts */
      tmpisr |= I2C_IT_ERRI | I2C_IT_TCI | I2C_IT_STOPI | I2C_IT_NACKI | I2C_IT_TXI;
    }

    if ((InterruptRequest & I2C_XFER_RX_IT) == I2C_XFER_RX_IT)
    {
      /* Enable ERR, TC, STOP, NACK and RXI interrupts */
      tmpisr |= I2C_IT_ERRI | I2C_IT_TCI | I2C_IT_STOPI | I2C_IT_NACKI | I2C_IT_RXI;
    }

    if (InterruptRequest == I2C_XFER_ERROR_IT)
    {
      /* Enable ERR and NACK interrupts */
      tmpisr |= I2C_IT_ERRI | I2C_IT_NACKI;
    }

    if (InterruptRequest == I2C_XFER_CPLT_IT)
    {
      /* Enable STOP interrupts */
      tmpisr |= (I2C_IT_STOPI | I2C_IT_TCI);
    }

    if (InterruptRequest == I2C_XFER_RELOAD_IT)
    {
      /* Enable TC interrupts */
      tmpisr |= I2C_IT_TCI;
    }
  }
#endif /* HAL_DMA_MODULE_ENABLED */

  /* Enable interrupts only at the end */
  /* to avoid the risk of I2C interrupt handle execution before */
  /* all interrupts requested done */
  __HAL_I2C_ENABLE_IT(hi2c, tmpisr);
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static void I2C_Disable_IRQ(I2C_HandleTypeDef *hi2c, uint16_t InterruptRequest)
{
  uint32_t tmpisr = 0U;

  if ((InterruptRequest & I2C_XFER_TX_IT) == I2C_XFER_TX_IT)
  {
    /* Disable TC and TXI interrupts */
    tmpisr |= I2C_IT_TCI | I2C_IT_TXI;

    if (((uint32_t)hi2c->State & (uint32_t)HAL_I2C_STATE_LISTEN) != (uint32_t)HAL_I2C_STATE_LISTEN)
    {
      /* Disable NACK and STOP interrupts */
      tmpisr |= I2C_IT_STOPI | I2C_IT_NACKI | I2C_IT_ERRI;
    }
  }

  if ((InterruptRequest & I2C_XFER_RX_IT) == I2C_XFER_RX_IT)
  {
    /* Disable TC and RXI interrupts */
    tmpisr |= I2C_IT_TCI | I2C_IT_RXI;

    if (((uint32_t)hi2c->State & (uint32_t)HAL_I2C_STATE_LISTEN) != (uint32_t)HAL_I2C_STATE_LISTEN)
    {
      /* Disable NACK and STOP interrupts */
      tmpisr |= I2C_IT_STOPI | I2C_IT_NACKI | I2C_IT_ERRI;
    }
  }

  if ((InterruptRequest & I2C_XFER_LISTEN_IT) == I2C_XFER_LISTEN_IT)
  {
    /* Disable ADDR, NACK and STOP interrupts */
    tmpisr |= I2C_IT_ADDRI | I2C_IT_STOPI | I2C_IT_NACKI | I2C_IT_ERRI;
  }

  if (InterruptRequest == I2C_XFER_ERROR_IT)
  {
    /* Enable ERR and NACK interrupts */
    tmpisr |= I2C_IT_ERRI | I2C_IT_NACKI;
  }

  if (InterruptRequest == I2C_XFER_CPLT_IT)
  {
    /* Enable STOP interrupts */
    tmpisr |= I2C_IT_STOPI;
  }

  if (InterruptRequest == I2C_XFER_RELOAD_IT)
  {
    /* Enable TC interrupts */
    tmpisr |= I2C_IT_TCI;
  }

  /* Disable interrupts only at the end */
  /* to avoid a breaking situation like at "t" time */
  /* all disable interrupts request are not done */
  __HAL_I2C_DISABLE_IT(hi2c, tmpisr);
}
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static void I2C_ConvertOtherXferOptions(I2C_HandleTypeDef *hi2c)
{
  /* if user set XferOptions to I2C_OTHER_FRAME            */
  /* it request implicitly to generate a restart condition */
  /* set XferOptions to I2C_FIRST_FRAME                    */
  if (hi2c->XferOptions == I2C_OTHER_FRAME)
  {
    hi2c->XferOptions = I2C_FIRST_FRAME;
  }
  /* else if user set XferOptions to I2C_OTHER_AND_LAST_FRAME */
  /* it request implicitly to generate a restart condition    */
  /* then generate a stop condition at the end of transfer    */
  /* set XferOptions to I2C_FIRST_AND_LAST_FRAME              */
  else if (hi2c->XferOptions == I2C_OTHER_AND_LAST_FRAME)
  {
    hi2c->XferOptions = I2C_FIRST_AND_LAST_FRAME;
  }
  else
  {
    /* Nothing to do */
  }
}
#endif
