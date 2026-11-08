// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SMBUS/SMBUSEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_Init(SMBUS_HandleTypeDef *hsmbus)
{
  /* Check the SMBUS handle allocation */
  if (hsmbus == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_SMBUS_ALL_INSTANCE(hsmbus->Instance));
  assert_param(IS_SMBUS_ANALOG_FILTER(hsmbus->Init.AnalogFilter));
  assert_param(IS_SMBUS_OWN_ADDRESS1(hsmbus->Init.OwnAddress1));
  assert_param(IS_SMBUS_ADDRESSING_MODE(hsmbus->Init.AddressingMode));
  assert_param(IS_SMBUS_DUAL_ADDRESS(hsmbus->Init.DualAddressMode));
  assert_param(IS_SMBUS_OWN_ADDRESS2(hsmbus->Init.OwnAddress2));
  assert_param(IS_SMBUS_OWN_ADDRESS2_MASK(hsmbus->Init.OwnAddress2Masks));
  assert_param(IS_SMBUS_GENERAL_CALL(hsmbus->Init.GeneralCallMode));
  assert_param(IS_SMBUS_NO_STRETCH(hsmbus->Init.NoStretchMode));
  assert_param(IS_SMBUS_PEC(hsmbus->Init.PacketErrorCheckMode));
  assert_param(IS_SMBUS_PERIPHERAL_MODE(hsmbus->Init.PeripheralMode));

  if (hsmbus->State == HAL_SMBUS_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    hsmbus->Lock = HAL_UNLOCKED;

#if (USE_HAL_SMBUS_REGISTER_CALLBACKS == 1)
    hsmbus->MasterTxCpltCallback = HAL_SMBUS_MasterTxCpltCallback; /* Legacy weak MasterTxCpltCallback */
    hsmbus->MasterRxCpltCallback = HAL_SMBUS_MasterRxCpltCallback; /* Legacy weak MasterRxCpltCallback */
    hsmbus->SlaveTxCpltCallback  = HAL_SMBUS_SlaveTxCpltCallback;  /* Legacy weak SlaveTxCpltCallback  */
    hsmbus->SlaveRxCpltCallback  = HAL_SMBUS_SlaveRxCpltCallback;  /* Legacy weak SlaveRxCpltCallback  */
    hsmbus->ListenCpltCallback   = HAL_SMBUS_ListenCpltCallback;   /* Legacy weak ListenCpltCallback   */
    hsmbus->ErrorCallback        = HAL_SMBUS_ErrorCallback;        /* Legacy weak ErrorCallback        */
    hsmbus->AddrCallback         = HAL_SMBUS_AddrCallback;         /* Legacy weak AddrCallback         */

    if (hsmbus->MspInitCallback == NULL)
    {
      hsmbus->MspInitCallback = HAL_SMBUS_MspInit; /* Legacy weak MspInit  */
    }

    /* Init the low level hardware : GPIO, CLOCK, CORTEX...etc */
    hsmbus->MspInitCallback(hsmbus);
#else
    /* Init the low level hardware : GPIO, CLOCK, NVIC */
    HAL_SMBUS_MspInit(hsmbus);
#endif /* USE_HAL_SMBUS_REGISTER_CALLBACKS */
  }

  hsmbus->State = HAL_SMBUS_STATE_BUSY;

  /* Disable the selected SMBUS peripheral */
  __HAL_SMBUS_DISABLE(hsmbus);

  /*---------------------------- SMBUSx TIMINGR Configuration ------------------------*/
  /* Configure SMBUSx: Frequency range */
  hsmbus->Instance->TIMINGR = hsmbus->Init.Timing & TIMING_CLEAR_MASK;

  /*---------------------------- SMBUSx TIMEOUTR Configuration ------------------------*/
  /* Configure SMBUSx: Bus Timeout  */
  hsmbus->Instance->TIMEOUTR &= ~I2C_TIMEOUTR_TIMOUTEN;
  hsmbus->Instance->TIMEOUTR &= ~I2C_TIMEOUTR_TEXTEN;
  hsmbus->Instance->TIMEOUTR = hsmbus->Init.SMBusTimeout;

  /*---------------------------- SMBUSx OAR1 Configuration -----------------------*/
  /* Configure SMBUSx: Own Address1 and ack own address1 mode */
  hsmbus->Instance->OAR1 &= ~I2C_OAR1_OA1EN;

  if (hsmbus->Init.OwnAddress1 != 0UL)
  {
    if (hsmbus->Init.AddressingMode == SMBUS_ADDRESSINGMODE_7BIT)
    {
      hsmbus->Instance->OAR1 = (I2C_OAR1_OA1EN | hsmbus->Init.OwnAddress1);
    }
  }

  /*---------------------------- SMBUSx CR2 Configuration ------------------------*/
  /* Enable the AUTOEND by default, and enable NACK (should be disable only during Slave process) */
  /* AUTOEND and NACK bit will be manage during Transfer process */
  hsmbus->Instance->CR2 |= (I2C_CR2_AUTOEND | I2C_CR2_NACK);

  /*---------------------------- SMBUSx OAR2 Configuration -----------------------*/
  /* Configure SMBUSx: Dual mode and Own Address2 */
  hsmbus->Instance->OAR2 = (hsmbus->Init.DualAddressMode | hsmbus->Init.OwnAddress2 | \
                            (hsmbus->Init.OwnAddress2Masks << 8U));

  /*---------------------------- SMBUSx CR1 Configuration ------------------------*/
  /* Configure SMBUSx: Generalcall and NoStretch mode */
  hsmbus->Instance->CR1 = (hsmbus->Init.GeneralCallMode | hsmbus->Init.NoStretchMode | \
                           hsmbus->Init.PacketErrorCheckMode | hsmbus->Init.PeripheralMode | \
                           hsmbus->Init.AnalogFilter);

  /* Enable Slave Byte Control only in case of Packet Error Check is enabled
     and SMBUS Peripheral is set in Slave mode */
  if ((hsmbus->Init.PacketErrorCheckMode == SMBUS_PEC_ENABLE) && \
      ((hsmbus->Init.PeripheralMode == SMBUS_PERIPHERAL_MODE_SMBUS_SLAVE) || \
       (hsmbus->Init.PeripheralMode == SMBUS_PERIPHERAL_MODE_SMBUS_SLAVE_ARP)))
  {
    hsmbus->Instance->CR1 |= I2C_CR1_SBC;
  }

  /* Enable the selected SMBUS peripheral */
  __HAL_SMBUS_ENABLE(hsmbus);

  hsmbus->ErrorCode = HAL_SMBUS_ERROR_NONE;
  hsmbus->PreviousState = HAL_SMBUS_STATE_READY;
  hsmbus->State = HAL_SMBUS_STATE_READY;

  return HAL_OK;
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_DeInit(SMBUS_HandleTypeDef *hsmbus)
{
  /* Check the SMBUS handle allocation */
  if (hsmbus == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_SMBUS_ALL_INSTANCE(hsmbus->Instance));

  hsmbus->State = HAL_SMBUS_STATE_BUSY;

  /* Disable the SMBUS Peripheral Clock */
  __HAL_SMBUS_DISABLE(hsmbus);

#if (USE_HAL_SMBUS_REGISTER_CALLBACKS == 1)
  if (hsmbus->MspDeInitCallback == NULL)
  {
    hsmbus->MspDeInitCallback = HAL_SMBUS_MspDeInit; /* Legacy weak MspDeInit  */
  }

  /* DeInit the low level hardware: GPIO, CLOCK, NVIC */
  hsmbus->MspDeInitCallback(hsmbus);
#else
  /* DeInit the low level hardware: GPIO, CLOCK, NVIC */
  HAL_SMBUS_MspDeInit(hsmbus);
#endif /* USE_HAL_SMBUS_REGISTER_CALLBACKS */

  hsmbus->ErrorCode = HAL_SMBUS_ERROR_NONE;
  hsmbus->PreviousState =  HAL_SMBUS_STATE_RESET;
  hsmbus->State = HAL_SMBUS_STATE_RESET;

  /* Release Lock */
  __HAL_UNLOCK(hsmbus);

  return HAL_OK;
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_ConfigAnalogFilter(SMBUS_HandleTypeDef *hsmbus, uint32_t AnalogFilter)
{
  /* Check the parameters */
  assert_param(IS_SMBUS_ALL_INSTANCE(hsmbus->Instance));
  assert_param(IS_SMBUS_ANALOG_FILTER(AnalogFilter));

  if (hsmbus->State == HAL_SMBUS_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hsmbus);

    hsmbus->State = HAL_SMBUS_STATE_BUSY;

    /* Disable the selected SMBUS peripheral */
    __HAL_SMBUS_DISABLE(hsmbus);

    /* Reset ANOFF bit */
    hsmbus->Instance->CR1 &= ~(I2C_CR1_ANFOFF);

    /* Set analog filter bit*/
    hsmbus->Instance->CR1 |= AnalogFilter;

    __HAL_SMBUS_ENABLE(hsmbus);

    hsmbus->State = HAL_SMBUS_STATE_READY;

    /* Process Unlocked */
    __HAL_UNLOCK(hsmbus);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_ConfigDigitalFilter(SMBUS_HandleTypeDef *hsmbus, uint32_t DigitalFilter)
{
  uint32_t tmpreg;

  /* Check the parameters */
  assert_param(IS_SMBUS_ALL_INSTANCE(hsmbus->Instance));
  assert_param(IS_SMBUS_DIGITAL_FILTER(DigitalFilter));

  if (hsmbus->State == HAL_SMBUS_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hsmbus);

    hsmbus->State = HAL_SMBUS_STATE_BUSY;

    /* Disable the selected SMBUS peripheral */
    __HAL_SMBUS_DISABLE(hsmbus);

    /* Get the old register value */
    tmpreg = hsmbus->Instance->CR1;

    /* Reset I2C DNF bits [11:8] */
    tmpreg &= ~(I2C_CR1_DNF);

    /* Set I2Cx DNF coefficient */
    tmpreg |= DigitalFilter << I2C_CR1_DNF_Pos;

    /* Store the new register value */
    hsmbus->Instance->CR1 = tmpreg;

    __HAL_SMBUS_ENABLE(hsmbus);

    hsmbus->State = HAL_SMBUS_STATE_READY;

    /* Process Unlocked */
    __HAL_UNLOCK(hsmbus);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
#if (USE_HAL_SMBUS_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_SMBUS_RegisterCallback(SMBUS_HandleTypeDef *hsmbus,
                                             HAL_SMBUS_CallbackIDTypeDef CallbackID,
                                             pSMBUS_CallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hsmbus->ErrorCode |= HAL_SMBUS_ERROR_INVALID_CALLBACK;

    return HAL_ERROR;
  }

  if (HAL_SMBUS_STATE_READY == hsmbus->State)
  {
    switch (CallbackID)
    {
      case HAL_SMBUS_MASTER_TX_COMPLETE_CB_ID :
        hsmbus->MasterTxCpltCallback = pCallback;
        break;

      case HAL_SMBUS_MASTER_RX_COMPLETE_CB_ID :
        hsmbus->MasterRxCpltCallback = pCallback;
        break;

      case HAL_SMBUS_SLAVE_TX_COMPLETE_CB_ID :
        hsmbus->SlaveTxCpltCallback = pCallback;
        break;

      case HAL_SMBUS_SLAVE_RX_COMPLETE_CB_ID :
        hsmbus->SlaveRxCpltCallback = pCallback;
        break;

      case HAL_SMBUS_LISTEN_COMPLETE_CB_ID :
        hsmbus->ListenCpltCallback = pCallback;
        break;

      case HAL_SMBUS_ERROR_CB_ID :
        hsmbus->ErrorCallback = pCallback;
        break;

      case HAL_SMBUS_MSPINIT_CB_ID :
        hsmbus->MspInitCallback = pCallback;
        break;

      case HAL_SMBUS_MSPDEINIT_CB_ID :
        hsmbus->MspDeInitCallback = pCallback;
        break;

      default :
        /* Update the error code */
        hsmbus->ErrorCode |= HAL_SMBUS_ERROR_INVALID_CALLBACK;

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (HAL_SMBUS_STATE_RESET == hsmbus->State)
  {
    switch (CallbackID)
    {
      case HAL_SMBUS_MSPINIT_CB_ID :
        hsmbus->MspInitCallback = pCallback;
        break;

      case HAL_SMBUS_MSPDEINIT_CB_ID :
        hsmbus->MspDeInitCallback = pCallback;
        break;

      default :
        /* Update the error code */
        hsmbus->ErrorCode |= HAL_SMBUS_ERROR_INVALID_CALLBACK;

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hsmbus->ErrorCode |= HAL_SMBUS_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
#if (USE_HAL_SMBUS_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_SMBUS_UnRegisterCallback(SMBUS_HandleTypeDef *hsmbus,
                                               HAL_SMBUS_CallbackIDTypeDef CallbackID)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (HAL_SMBUS_STATE_READY == hsmbus->State)
  {
    switch (CallbackID)
    {
      case HAL_SMBUS_MASTER_TX_COMPLETE_CB_ID :
        hsmbus->MasterTxCpltCallback = HAL_SMBUS_MasterTxCpltCallback; /* Legacy weak MasterTxCpltCallback */
        break;

      case HAL_SMBUS_MASTER_RX_COMPLETE_CB_ID :
        hsmbus->MasterRxCpltCallback = HAL_SMBUS_MasterRxCpltCallback; /* Legacy weak MasterRxCpltCallback */
        break;

      case HAL_SMBUS_SLAVE_TX_COMPLETE_CB_ID :
        hsmbus->SlaveTxCpltCallback = HAL_SMBUS_SlaveTxCpltCallback;   /* Legacy weak SlaveTxCpltCallback  */
        break;

      case HAL_SMBUS_SLAVE_RX_COMPLETE_CB_ID :
        hsmbus->SlaveRxCpltCallback = HAL_SMBUS_SlaveRxCpltCallback;   /* Legacy weak SlaveRxCpltCallback  */
        break;

      case HAL_SMBUS_LISTEN_COMPLETE_CB_ID :
        hsmbus->ListenCpltCallback = HAL_SMBUS_ListenCpltCallback;     /* Legacy weak ListenCpltCallback   */
        break;

      case HAL_SMBUS_ERROR_CB_ID :
        hsmbus->ErrorCallback = HAL_SMBUS_ErrorCallback;               /* Legacy weak ErrorCallback        */
        break;

      case HAL_SMBUS_MSPINIT_CB_ID :
        hsmbus->MspInitCallback = HAL_SMBUS_MspInit;                   /* Legacy weak MspInit              */
        break;

      case HAL_SMBUS_MSPDEINIT_CB_ID :
        hsmbus->MspDeInitCallback = HAL_SMBUS_MspDeInit;               /* Legacy weak MspDeInit            */
        break;

      default :
        /* Update the error code */
        hsmbus->ErrorCode |= HAL_SMBUS_ERROR_INVALID_CALLBACK;

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (HAL_SMBUS_STATE_RESET == hsmbus->State)
  {
    switch (CallbackID)
    {
      case HAL_SMBUS_MSPINIT_CB_ID :
        hsmbus->MspInitCallback = HAL_SMBUS_MspInit;                   /* Legacy weak MspInit              */
        break;

      case HAL_SMBUS_MSPDEINIT_CB_ID :
        hsmbus->MspDeInitCallback = HAL_SMBUS_MspDeInit;               /* Legacy weak MspDeInit            */
        break;

      default :
        /* Update the error code */
        hsmbus->ErrorCode |= HAL_SMBUS_ERROR_INVALID_CALLBACK;

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hsmbus->ErrorCode |= HAL_SMBUS_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
#if (USE_HAL_SMBUS_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_SMBUS_RegisterAddrCallback(SMBUS_HandleTypeDef *hsmbus,
                                                 pSMBUS_AddrCallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hsmbus->ErrorCode |= HAL_SMBUS_ERROR_INVALID_CALLBACK;

    return HAL_ERROR;
  }

  if (HAL_SMBUS_STATE_READY == hsmbus->State)
  {
    hsmbus->AddrCallback = pCallback;
  }
  else
  {
    /* Update the error code */
    hsmbus->ErrorCode |= HAL_SMBUS_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
#if (USE_HAL_SMBUS_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_SMBUS_UnRegisterAddrCallback(SMBUS_HandleTypeDef *hsmbus)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (HAL_SMBUS_STATE_READY == hsmbus->State)
  {
    hsmbus->AddrCallback = HAL_SMBUS_AddrCallback; /* Legacy weak AddrCallback  */
  }
  else
  {
    /* Update the error code */
    hsmbus->ErrorCode |= HAL_SMBUS_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_Master_Transmit_IT(SMBUS_HandleTypeDef *hsmbus, uint16_t DevAddress,
                                               uint8_t *pData, uint16_t Size, uint32_t XferOptions)
{
  uint32_t tmp;

  /* Check the parameters */
  assert_param(IS_SMBUS_TRANSFER_OPTIONS_REQUEST(XferOptions));

  if (hsmbus->State == HAL_SMBUS_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hsmbus);

    hsmbus->State = HAL_SMBUS_STATE_MASTER_BUSY_TX;
    hsmbus->ErrorCode = HAL_SMBUS_ERROR_NONE;
    /* Prepare transfer parameters */
    hsmbus->pBuffPtr = pData;
    hsmbus->XferCount = Size;
    hsmbus->XferOptions = XferOptions;

    /* In case of Quick command, remove autoend mode */
    /* Manage the stop generation by software */
    if (hsmbus->pBuffPtr == NULL)
    {
      hsmbus->XferOptions &= ~SMBUS_AUTOEND_MODE;
    }

    if (Size > MAX_NBYTE_SIZE)
    {
      hsmbus->XferSize = MAX_NBYTE_SIZE;
    }
    else
    {
      hsmbus->XferSize = Size;
    }

    /* Send Slave Address */
    /* Set NBYTES to write and reload if size > MAX_NBYTE_SIZE and generate RESTART */
    if ((hsmbus->XferSize < hsmbus->XferCount) && (hsmbus->XferSize == MAX_NBYTE_SIZE))
    {
      SMBUS_TransferConfig(hsmbus, DevAddress, (uint8_t)hsmbus->XferSize,
                           SMBUS_RELOAD_MODE | (hsmbus->XferOptions & SMBUS_SENDPEC_MODE),
                           SMBUS_GENERATE_START_WRITE);
    }
    else
    {
      /* If transfer direction not change, do not generate Restart Condition */
      /* Mean Previous state is same as current state */

      /* Store current volatile XferOptions, misra rule */
      tmp = hsmbus->XferOptions;

      if ((hsmbus->PreviousState == HAL_SMBUS_STATE_MASTER_BUSY_TX) && \
          (IS_SMBUS_TRANSFER_OTHER_OPTIONS_REQUEST(tmp) == 0))
      {
        SMBUS_TransferConfig(hsmbus, DevAddress, (uint8_t)hsmbus->XferSize, hsmbus->XferOptions,
                             SMBUS_NO_STARTSTOP);
      }
      /* Else transfer direction change, so generate Restart with new transfer direction */
      else
      {
        /* Convert OTHER_xxx XferOptions if any */
        SMBUS_ConvertOtherXferOptions(hsmbus);

        /* Handle Transfer */
        SMBUS_TransferConfig(hsmbus, DevAddress, (uint8_t)hsmbus->XferSize,
                             hsmbus->XferOptions,
                             SMBUS_GENERATE_START_WRITE);
      }

      /* If PEC mode is enable, size to transmit manage by SW part should be Size-1 byte, corresponding to PEC byte */
      /* PEC byte is automatically sent by HW block, no need to manage it in Transmit process */
      if (SMBUS_GET_PEC_MODE(hsmbus) != 0UL)
      {
        if (hsmbus->XferSize > 0U)
        {
          hsmbus->XferSize--;
          hsmbus->XferCount--;
        }
        else
        {
          return HAL_ERROR;
        }
      }
    }

    /* Process Unlocked */
    __HAL_UNLOCK(hsmbus);

    /* Note : The SMBUS interrupts must be enabled after unlocking current process
              to avoid the risk of SMBUS interrupt handle execution before current
              process unlock */
    SMBUS_Enable_IRQ(hsmbus, SMBUS_IT_TX);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_Master_Receive_IT(SMBUS_HandleTypeDef *hsmbus, uint16_t DevAddress, uint8_t *pData,
                                              uint16_t Size, uint32_t XferOptions)
{
  uint32_t tmp;

  /* Check the parameters */
  assert_param(IS_SMBUS_TRANSFER_OPTIONS_REQUEST(XferOptions));

  if (hsmbus->State == HAL_SMBUS_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hsmbus);

    hsmbus->State = HAL_SMBUS_STATE_MASTER_BUSY_RX;
    hsmbus->ErrorCode = HAL_SMBUS_ERROR_NONE;

    /* Prepare transfer parameters */
    hsmbus->pBuffPtr = pData;
    hsmbus->XferCount = Size;
    hsmbus->XferOptions = XferOptions;

    /* In case of Quick command, remove autoend mode */
    /* Manage the stop generation by software */
    if (hsmbus->pBuffPtr == NULL)
    {
      hsmbus->XferOptions &= ~SMBUS_AUTOEND_MODE;
    }

    if (Size > MAX_NBYTE_SIZE)
    {
      hsmbus->XferSize = MAX_NBYTE_SIZE;
    }
    else
    {
      hsmbus->XferSize = Size;
    }

    /* Send Slave Address */
    /* Set NBYTES to write and reload if size > MAX_NBYTE_SIZE and generate RESTART */
    if ((hsmbus->XferSize < hsmbus->XferCount) && (hsmbus->XferSize == MAX_NBYTE_SIZE))
    {
      SMBUS_TransferConfig(hsmbus, DevAddress, (uint8_t)hsmbus->XferSize,
                           SMBUS_RELOAD_MODE  | (hsmbus->XferOptions & SMBUS_SENDPEC_MODE),
                           SMBUS_GENERATE_START_READ);
    }
    else
    {
      /* If transfer direction not change, do not generate Restart Condition */
      /* Mean Previous state is same as current state */

      /* Store current volatile XferOptions, Misra rule */
      tmp = hsmbus->XferOptions;

      if ((hsmbus->PreviousState == HAL_SMBUS_STATE_MASTER_BUSY_RX) && \
          (IS_SMBUS_TRANSFER_OTHER_OPTIONS_REQUEST(tmp) == 0))
      {
        SMBUS_TransferConfig(hsmbus, DevAddress, (uint8_t)hsmbus->XferSize, hsmbus->XferOptions,
                             SMBUS_NO_STARTSTOP);
      }
      /* Else transfer direction change, so generate Restart with new transfer direction */
      else
      {
        /* Convert OTHER_xxx XferOptions if any */
        SMBUS_ConvertOtherXferOptions(hsmbus);

        /* Handle Transfer */
        SMBUS_TransferConfig(hsmbus, DevAddress, (uint8_t)hsmbus->XferSize,
                             hsmbus->XferOptions,
                             SMBUS_GENERATE_START_READ);
      }
    }

    /* Process Unlocked */
    __HAL_UNLOCK(hsmbus);

    /* Note : The SMBUS interrupts must be enabled after unlocking current process
              to avoid the risk of SMBUS interrupt handle execution before current
              process unlock */
    SMBUS_Enable_IRQ(hsmbus, SMBUS_IT_RX);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_Master_Abort_IT(SMBUS_HandleTypeDef *hsmbus, uint16_t DevAddress)
{
  if (hsmbus->State == HAL_SMBUS_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hsmbus);

    /* Keep the same state as previous */
    /* to perform as well the call of the corresponding end of transfer callback */
    if (hsmbus->PreviousState == HAL_SMBUS_STATE_MASTER_BUSY_TX)
    {
      hsmbus->State = HAL_SMBUS_STATE_MASTER_BUSY_TX;
    }
    else if (hsmbus->PreviousState == HAL_SMBUS_STATE_MASTER_BUSY_RX)
    {
      hsmbus->State = HAL_SMBUS_STATE_MASTER_BUSY_RX;
    }
    else
    {
      /* Wrong usage of abort function */
      /* This function should be used only in case of abort monitored by master device */
      return HAL_ERROR;
    }
    hsmbus->ErrorCode = HAL_SMBUS_ERROR_NONE;

    /* Set NBYTES to 1 to generate a dummy read on SMBUS peripheral */
    /* Set AUTOEND mode, this will generate a NACK then STOP condition to abort the current transfer */
    SMBUS_TransferConfig(hsmbus, DevAddress, 1, SMBUS_AUTOEND_MODE, SMBUS_NO_STARTSTOP);

    /* Process Unlocked */
    __HAL_UNLOCK(hsmbus);

    /* Note : The SMBUS interrupts must be enabled after unlocking current process
              to avoid the risk of SMBUS interrupt handle execution before current
              process unlock */
    if (hsmbus->State == HAL_SMBUS_STATE_MASTER_BUSY_TX)
    {
      SMBUS_Enable_IRQ(hsmbus, SMBUS_IT_TX);
    }
    else if (hsmbus->State == HAL_SMBUS_STATE_MASTER_BUSY_RX)
    {
      SMBUS_Enable_IRQ(hsmbus, SMBUS_IT_RX);
    }
    else
    {
      /* Nothing to do */
    }

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_Slave_Transmit_IT(SMBUS_HandleTypeDef *hsmbus, uint8_t *pData, uint16_t Size,
                                              uint32_t XferOptions)
{
  /* Check the parameters */
  assert_param(IS_SMBUS_TRANSFER_OPTIONS_REQUEST(XferOptions));

  if ((hsmbus->State & HAL_SMBUS_STATE_LISTEN) == HAL_SMBUS_STATE_LISTEN)
  {
    if ((pData == NULL) || (Size == 0UL))
    {
      hsmbus->ErrorCode = HAL_SMBUS_ERROR_INVALID_PARAM;
      return HAL_ERROR;
    }

    /* Disable Interrupts, to prevent preemption during treatment in case of multicall */
    SMBUS_Disable_IRQ(hsmbus, SMBUS_IT_ADDR | SMBUS_IT_TX);

    /* Process Locked */
    __HAL_LOCK(hsmbus);

    hsmbus->State = (HAL_SMBUS_STATE_SLAVE_BUSY_TX | HAL_SMBUS_STATE_LISTEN);
    hsmbus->ErrorCode = HAL_SMBUS_ERROR_NONE;

    /* Set SBC bit to manage Acknowledge at each bit */
    hsmbus->Instance->CR1 |= I2C_CR1_SBC;

    /* Enable Address Acknowledge */
    hsmbus->Instance->CR2 &= ~I2C_CR2_NACK;

    /* Prepare transfer parameters */
    hsmbus->pBuffPtr = pData;
    hsmbus->XferCount = Size;
    hsmbus->XferOptions = XferOptions;

    /* Convert OTHER_xxx XferOptions if any */
    SMBUS_ConvertOtherXferOptions(hsmbus);

    if (Size > MAX_NBYTE_SIZE)
    {
      hsmbus->XferSize = MAX_NBYTE_SIZE;
    }
    else
    {
      hsmbus->XferSize = Size;
    }

    /* Set NBYTES to write and reload if size > MAX_NBYTE_SIZE and generate RESTART */
    if ((hsmbus->XferSize < hsmbus->XferCount) && (hsmbus->XferSize == MAX_NBYTE_SIZE))
    {
      SMBUS_TransferConfig(hsmbus, 0, (uint8_t)hsmbus->XferSize,
                           SMBUS_RELOAD_MODE | (hsmbus->XferOptions & SMBUS_SENDPEC_MODE),
                           SMBUS_NO_STARTSTOP);
    }
    else
    {
      /* Set NBYTE to transmit */
      SMBUS_TransferConfig(hsmbus, 0, (uint8_t)hsmbus->XferSize, hsmbus->XferOptions,
                           SMBUS_NO_STARTSTOP);

      /* If PEC mode is enable, size to transmit should be Size-1 byte, corresponding to PEC byte */
      /* PEC byte is automatically sent by HW block, no need to manage it in Transmit process */
      if (SMBUS_GET_PEC_MODE(hsmbus) != 0UL)
      {
        hsmbus->XferSize--;
        hsmbus->XferCount--;
      }
    }

    /* Clear ADDR flag after prepare the transfer parameters */
    /* This action will generate an acknowledge to the HOST */
    __HAL_SMBUS_CLEAR_FLAG(hsmbus, SMBUS_FLAG_ADDR);

    /* Process Unlocked */
    __HAL_UNLOCK(hsmbus);

    /* Note : The SMBUS interrupts must be enabled after unlocking current process
              to avoid the risk of SMBUS interrupt handle execution before current
              process unlock */
    /* REnable ADDR interrupt */
    SMBUS_Enable_IRQ(hsmbus, SMBUS_IT_TX | SMBUS_IT_ADDR);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_Slave_Receive_IT(SMBUS_HandleTypeDef *hsmbus, uint8_t *pData, uint16_t Size,
                                             uint32_t XferOptions)
{
  /* Check the parameters */
  assert_param(IS_SMBUS_TRANSFER_OPTIONS_REQUEST(XferOptions));

  if ((hsmbus->State & HAL_SMBUS_STATE_LISTEN) == HAL_SMBUS_STATE_LISTEN)
  {
    if ((pData == NULL) || (Size == 0UL))
    {
      hsmbus->ErrorCode = HAL_SMBUS_ERROR_INVALID_PARAM;
      return HAL_ERROR;
    }

    /* Disable Interrupts, to prevent preemption during treatment in case of multicall */
    SMBUS_Disable_IRQ(hsmbus, SMBUS_IT_ADDR | SMBUS_IT_RX);

    /* Process Locked */
    __HAL_LOCK(hsmbus);

    hsmbus->State = (HAL_SMBUS_STATE_SLAVE_BUSY_RX | HAL_SMBUS_STATE_LISTEN);
    hsmbus->ErrorCode = HAL_SMBUS_ERROR_NONE;

    /* Set SBC bit to manage Acknowledge at each bit */
    hsmbus->Instance->CR1 |= I2C_CR1_SBC;

    /* Enable Address Acknowledge */
    hsmbus->Instance->CR2 &= ~I2C_CR2_NACK;

    /* Prepare transfer parameters */
    hsmbus->pBuffPtr = pData;
    hsmbus->XferSize = Size;
    hsmbus->XferCount = Size;
    hsmbus->XferOptions = XferOptions;

    /* Convert OTHER_xxx XferOptions if any */
    SMBUS_ConvertOtherXferOptions(hsmbus);

    /* Set NBYTE to receive */
    /* If XferSize equal "1", or XferSize equal "2" with PEC requested (mean 1 data byte + 1 PEC byte */
    /* no need to set RELOAD bit mode, a ACK will be automatically generated in that case */
    /* else need to set RELOAD bit mode to generate an automatic ACK at each byte Received */
    /* This RELOAD bit will be reset for last BYTE to be receive in SMBUS_Slave_ISR */
    if (((SMBUS_GET_PEC_MODE(hsmbus) != 0UL) && (hsmbus->XferSize == 2U)) || (hsmbus->XferSize == 1U))
    {
      SMBUS_TransferConfig(hsmbus, 0, (uint8_t)hsmbus->XferSize, hsmbus->XferOptions,
                           SMBUS_NO_STARTSTOP);
    }
    else
    {
      SMBUS_TransferConfig(hsmbus, 0, 1, hsmbus->XferOptions | SMBUS_RELOAD_MODE, SMBUS_NO_STARTSTOP);
    }

    /* Clear ADDR flag after prepare the transfer parameters */
    /* This action will generate an acknowledge to the HOST */
    __HAL_SMBUS_CLEAR_FLAG(hsmbus, SMBUS_FLAG_ADDR);

    /* Process Unlocked */
    __HAL_UNLOCK(hsmbus);

    /* Note : The SMBUS interrupts must be enabled after unlocking current process
              to avoid the risk of SMBUS interrupt handle execution before current
              process unlock */
    /* REnable ADDR interrupt */
    SMBUS_Enable_IRQ(hsmbus, SMBUS_IT_RX | SMBUS_IT_ADDR);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_EnableListen_IT(SMBUS_HandleTypeDef *hsmbus)
{
  hsmbus->State = HAL_SMBUS_STATE_LISTEN;

  /* Enable the Address Match interrupt */
  SMBUS_Enable_IRQ(hsmbus, SMBUS_IT_ADDR);

  return HAL_OK;
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_DisableListen_IT(SMBUS_HandleTypeDef *hsmbus)
{
  /* Disable Address listen mode only if a transfer is not ongoing */
  if (hsmbus->State == HAL_SMBUS_STATE_LISTEN)
  {
    hsmbus->State = HAL_SMBUS_STATE_READY;

    /* Disable the Address Match interrupt */
    SMBUS_Disable_IRQ(hsmbus, SMBUS_IT_ADDR);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_EnableAlert_IT(SMBUS_HandleTypeDef *hsmbus)
{
  /* Enable SMBus alert */
  hsmbus->Instance->CR1 |= I2C_CR1_ALERTEN;

  /* Clear ALERT flag */
  __HAL_SMBUS_CLEAR_FLAG(hsmbus, SMBUS_FLAG_ALERT);

  /* Enable Alert Interrupt */
  SMBUS_Enable_IRQ(hsmbus, SMBUS_IT_ALERT);

  return HAL_OK;
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_DisableAlert_IT(SMBUS_HandleTypeDef *hsmbus)
{
  /* Enable SMBus alert */
  hsmbus->Instance->CR1 &= ~I2C_CR1_ALERTEN;

  /* Disable Alert Interrupt */
  SMBUS_Disable_IRQ(hsmbus, SMBUS_IT_ALERT);

  return HAL_OK;
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_IsDeviceReady(SMBUS_HandleTypeDef *hsmbus, uint16_t DevAddress, uint32_t Trials,
                                          uint32_t Timeout)
{
  uint32_t tickstart;

  __IO uint32_t SMBUS_Trials = 0UL;

  FlagStatus tmp1;
  FlagStatus tmp2;

  if (hsmbus->State == HAL_SMBUS_STATE_READY)
  {
    if (__HAL_SMBUS_GET_FLAG(hsmbus, SMBUS_FLAG_BUSY) != RESET)
    {
      return HAL_BUSY;
    }

    /* Process Locked */
    __HAL_LOCK(hsmbus);

    hsmbus->State = HAL_SMBUS_STATE_BUSY;
    hsmbus->ErrorCode = HAL_SMBUS_ERROR_NONE;

    do
    {
      /* Generate Start */
      hsmbus->Instance->CR2 = SMBUS_GENERATE_START(hsmbus->Init.AddressingMode, DevAddress);

      /* No need to Check TC flag, with AUTOEND mode the stop is automatically generated */
      /* Wait until STOPF flag is set or a NACK flag is set*/
      tickstart = HAL_GetTick();

      tmp1 = __HAL_SMBUS_GET_FLAG(hsmbus, SMBUS_FLAG_STOPF);
      tmp2 = __HAL_SMBUS_GET_FLAG(hsmbus, SMBUS_FLAG_AF);

      while ((tmp1 == RESET) && (tmp2 == RESET))
      {
        if (Timeout != HAL_MAX_DELAY)
        {
          if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0UL))
          {
            /* Device is ready */
            hsmbus->State = HAL_SMBUS_STATE_READY;

            /* Update SMBUS error code */
            hsmbus->ErrorCode |= HAL_SMBUS_ERROR_HALTIMEOUT;

            /* Process Unlocked */
            __HAL_UNLOCK(hsmbus);
            return HAL_ERROR;
          }
        }

        tmp1 = __HAL_SMBUS_GET_FLAG(hsmbus, SMBUS_FLAG_STOPF);
        tmp2 = __HAL_SMBUS_GET_FLAG(hsmbus, SMBUS_FLAG_AF);
      }

      /* Check if the NACKF flag has not been set */
      if (__HAL_SMBUS_GET_FLAG(hsmbus, SMBUS_FLAG_AF) == RESET)
      {
        /* Wait until STOPF flag is reset */
        if (SMBUS_WaitOnFlagUntilTimeout(hsmbus, SMBUS_FLAG_STOPF, RESET, Timeout) != HAL_OK)
        {
          /* A non acknowledge appear during STOP Flag waiting process, a new trial must be performed */
          /* Clear STOP Flag */
          __HAL_SMBUS_CLEAR_FLAG(hsmbus, SMBUS_FLAG_STOPF);

          /* Reset the error code for next trial */
          hsmbus->ErrorCode = HAL_SMBUS_ERROR_NONE;
        }
        else
        {
          /* A acknowledge appear during STOP Flag waiting process, this mean that device respond to its address */

          /* Clear STOP Flag */
          __HAL_SMBUS_CLEAR_FLAG(hsmbus, SMBUS_FLAG_STOPF);

          /* Device is ready */
          hsmbus->State = HAL_SMBUS_STATE_READY;

          /* Process Unlocked */
          __HAL_UNLOCK(hsmbus);

          return HAL_OK;
        }
      }
      else
      {
        /* A non acknowledge is detected, this mean that device not respond to its address,
           a new trial must be performed */

        /* Clear NACK Flag */
        __HAL_SMBUS_CLEAR_FLAG(hsmbus, SMBUS_FLAG_AF);

        /* Wait until STOPF flag is reset */
        if (SMBUS_WaitOnFlagUntilTimeout(hsmbus, SMBUS_FLAG_STOPF, RESET, Timeout) == HAL_OK)
        {
          /* Clear STOP Flag, auto generated with autoend*/
          __HAL_SMBUS_CLEAR_FLAG(hsmbus, SMBUS_FLAG_STOPF);
        }
      }

      /* Increment Trials */
      SMBUS_Trials++;
    } while (SMBUS_Trials < Trials);

    /* Update SMBUS state */
    hsmbus->State = HAL_SMBUS_STATE_READY;

    /* Update SMBUS error code */
    hsmbus->ErrorCode |= HAL_SMBUS_ERROR_HALTIMEOUT;

    /* Process Unlocked */
    __HAL_UNLOCK(hsmbus);

    return HAL_ERROR;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
void HAL_SMBUS_EV_IRQHandler(SMBUS_HandleTypeDef *hsmbus)
{
  /* Use a local variable to store the current ISR flags */
  /* This action will avoid a wrong treatment due to ISR flags change during interrupt handler */
  uint32_t tmpisrvalue = READ_REG(hsmbus->Instance->ISR);
  uint32_t tmpcr1value = READ_REG(hsmbus->Instance->CR1);

  /* SMBUS in mode Transmitter ---------------------------------------------------*/
  if ((SMBUS_CHECK_IT_SOURCE(tmpcr1value, (SMBUS_IT_TCI | SMBUS_IT_STOPI |
                                           SMBUS_IT_NACKI | SMBUS_IT_TXI)) != RESET) &&
      ((SMBUS_CHECK_FLAG(tmpisrvalue, SMBUS_FLAG_TXIS) != RESET) ||
       (SMBUS_CHECK_FLAG(tmpisrvalue, SMBUS_FLAG_TCR) != RESET) ||
       (SMBUS_CHECK_FLAG(tmpisrvalue, SMBUS_FLAG_TC) != RESET) ||
       (SMBUS_CHECK_FLAG(tmpisrvalue, SMBUS_FLAG_STOPF) != RESET) ||
       (SMBUS_CHECK_FLAG(tmpisrvalue, SMBUS_FLAG_AF) != RESET)))
  {
    /* Slave mode selected */
    if ((hsmbus->State & HAL_SMBUS_STATE_SLAVE_BUSY_TX) == HAL_SMBUS_STATE_SLAVE_BUSY_TX)
    {
      (void)SMBUS_Slave_ISR(hsmbus, tmpisrvalue);
    }
    /* Master mode selected */
    else if ((hsmbus->State & HAL_SMBUS_STATE_MASTER_BUSY_TX) == HAL_SMBUS_STATE_MASTER_BUSY_TX)
    {
      (void)SMBUS_Master_ISR(hsmbus, tmpisrvalue);
    }
    else
    {
      /* Nothing to do */
    }
  }

  /* SMBUS in mode Receiver ----------------------------------------------------*/
  if ((SMBUS_CHECK_IT_SOURCE(tmpcr1value, (SMBUS_IT_TCI | SMBUS_IT_STOPI |
                                           SMBUS_IT_NACKI | SMBUS_IT_RXI)) != RESET) &&
      ((SMBUS_CHECK_FLAG(tmpisrvalue, SMBUS_FLAG_RXNE) != RESET) ||
       (SMBUS_CHECK_FLAG(tmpisrvalue, SMBUS_FLAG_TCR) != RESET) ||
       (SMBUS_CHECK_FLAG(tmpisrvalue, SMBUS_FLAG_TC) != RESET) ||
       (SMBUS_CHECK_FLAG(tmpisrvalue, SMBUS_FLAG_STOPF) != RESET) ||
       (SMBUS_CHECK_FLAG(tmpisrvalue, SMBUS_FLAG_AF) != RESET)))
  {
    /* Slave mode selected */
    if ((hsmbus->State & HAL_SMBUS_STATE_SLAVE_BUSY_RX) == HAL_SMBUS_STATE_SLAVE_BUSY_RX)
    {
      (void)SMBUS_Slave_ISR(hsmbus, tmpisrvalue);
    }
    /* Master mode selected */
    else if ((hsmbus->State & HAL_SMBUS_STATE_MASTER_BUSY_RX) == HAL_SMBUS_STATE_MASTER_BUSY_RX)
    {
      (void)SMBUS_Master_ISR(hsmbus, tmpisrvalue);
    }
    else
    {
      /* Nothing to do */
    }
  }

  /* SMBUS in mode Listener Only --------------------------------------------------*/
  if (((SMBUS_CHECK_IT_SOURCE(tmpcr1value, SMBUS_IT_ADDRI) != RESET) ||
       (SMBUS_CHECK_IT_SOURCE(tmpcr1value, SMBUS_IT_STOPI) != RESET) ||
       (SMBUS_CHECK_IT_SOURCE(tmpcr1value, SMBUS_IT_NACKI) != RESET)) &&
      ((SMBUS_CHECK_FLAG(tmpisrvalue, SMBUS_FLAG_ADDR) != RESET) ||
       (SMBUS_CHECK_FLAG(tmpisrvalue, SMBUS_FLAG_STOPF) != RESET) ||
       (SMBUS_CHECK_FLAG(tmpisrvalue, SMBUS_FLAG_AF) != RESET)))
  {
    if ((hsmbus->State & HAL_SMBUS_STATE_LISTEN) == HAL_SMBUS_STATE_LISTEN)
    {
      (void)SMBUS_Slave_ISR(hsmbus, tmpisrvalue);
    }
  }
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
void HAL_SMBUS_ER_IRQHandler(SMBUS_HandleTypeDef *hsmbus)
{
  SMBUS_ITErrorHandler(hsmbus);
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
uint32_t HAL_SMBUS_GetState(const SMBUS_HandleTypeDef *hsmbus)
{
  /* Return SMBUS handle state */
  return hsmbus->State;
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
uint32_t HAL_SMBUS_GetError(const SMBUS_HandleTypeDef *hsmbus)
{
  return hsmbus->ErrorCode;
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
static HAL_StatusTypeDef SMBUS_Master_ISR(SMBUS_HandleTypeDef *hsmbus, uint32_t StatusFlags)
{
  uint16_t DevAddress;

  /* Process Locked */
  __HAL_LOCK(hsmbus);

  if (SMBUS_CHECK_FLAG(StatusFlags, SMBUS_FLAG_AF) != RESET)
  {
    /* Clear NACK Flag */
    __HAL_SMBUS_CLEAR_FLAG(hsmbus, SMBUS_FLAG_AF);

    /* Set corresponding Error Code */
    /* No need to generate STOP, it is automatically done */
    hsmbus->ErrorCode |= HAL_SMBUS_ERROR_ACKF;

    /* Flush TX register */
    SMBUS_Flush_TXDR(hsmbus);

    /* Process Unlocked */
    __HAL_UNLOCK(hsmbus);

    /* Call the Error callback to inform upper layer */
#if (USE_HAL_SMBUS_REGISTER_CALLBACKS == 1)
    hsmbus->ErrorCallback(hsmbus);
#else
    HAL_SMBUS_ErrorCallback(hsmbus);
#endif /* USE_HAL_SMBUS_REGISTER_CALLBACKS */
  }
  else if (SMBUS_CHECK_FLAG(StatusFlags, SMBUS_FLAG_STOPF) != RESET)
  {
    /* Check and treat errors if errors occurs during STOP process */
    SMBUS_ITErrorHandler(hsmbus);

    /* Call the corresponding callback to inform upper layer of End of Transfer */
    if (hsmbus->State == HAL_SMBUS_STATE_MASTER_BUSY_TX)
    {
      /* Disable Interrupt */
      SMBUS_Disable_IRQ(hsmbus, SMBUS_IT_TX);

      /* Clear STOP Flag */
      __HAL_SMBUS_CLEAR_FLAG(hsmbus, SMBUS_FLAG_STOPF);

      /* Clear Configuration Register 2 */
      SMBUS_RESET_CR2(hsmbus);

      /* Flush remaining data in Fifo register in case of error occurs before TXEmpty */
      /* Disable the selected SMBUS peripheral */
      __HAL_SMBUS_DISABLE(hsmbus);

      hsmbus->PreviousState = HAL_SMBUS_STATE_READY;
      hsmbus->State = HAL_SMBUS_STATE_READY;

      /* Process Unlocked */
      __HAL_UNLOCK(hsmbus);

      /* Re-enable the selected SMBUS peripheral */
      __HAL_SMBUS_ENABLE(hsmbus);

      /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_SMBUS_REGISTER_CALLBACKS == 1)
      hsmbus->MasterTxCpltCallback(hsmbus);
#else
      HAL_SMBUS_MasterTxCpltCallback(hsmbus);
#endif /* USE_HAL_SMBUS_REGISTER_CALLBACKS */
    }
    else if (hsmbus->State == HAL_SMBUS_STATE_MASTER_BUSY_RX)
    {
      /* Store Last receive data if any */
      if (SMBUS_CHECK_FLAG(StatusFlags, SMBUS_FLAG_RXNE) != RESET)
      {
        /* Read data from RXDR */
        *hsmbus->pBuffPtr = (uint8_t)(hsmbus->Instance->RXDR);

        /* Increment Buffer pointer */
        hsmbus->pBuffPtr++;

        if (hsmbus->XferSize > 0U)
        {
          hsmbus->XferSize--;
          hsmbus->XferCount--;
        }
      }

      /* Disable Interrupt */
      SMBUS_Disable_IRQ(hsmbus, SMBUS_IT_RX);

      /* Clear STOP Flag */
      __HAL_SMBUS_CLEAR_FLAG(hsmbus, SMBUS_FLAG_STOPF);

      /* Clear Configuration Register 2 */
      SMBUS_RESET_CR2(hsmbus);

      hsmbus->PreviousState = HAL_SMBUS_STATE_READY;
      hsmbus->State = HAL_SMBUS_STATE_READY;

      /* Process Unlocked */
      __HAL_UNLOCK(hsmbus);

      /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_SMBUS_REGISTER_CALLBACKS == 1)
      hsmbus->MasterRxCpltCallback(hsmbus);
#else
      HAL_SMBUS_MasterRxCpltCallback(hsmbus);
#endif /* USE_HAL_SMBUS_REGISTER_CALLBACKS */
    }
    else
    {
      /* Nothing to do */
    }
  }
  else if (SMBUS_CHECK_FLAG(StatusFlags, SMBUS_FLAG_RXNE) != RESET)
  {
    /* Read data from RXDR */
    *hsmbus->pBuffPtr = (uint8_t)(hsmbus->Instance->RXDR);

    /* Increment Buffer pointer */
    hsmbus->pBuffPtr++;

    /* Increment Size counter */
    hsmbus->XferSize--;
    hsmbus->XferCount--;
  }
  else if (SMBUS_CHECK_FLAG(StatusFlags, SMBUS_FLAG_TXIS) != RESET)
  {
    /* Write data to TXDR */
    hsmbus->Instance->TXDR = *hsmbus->pBuffPtr;

    /* Increment Buffer pointer */
    hsmbus->pBuffPtr++;

    /* Increment Size counter */
    hsmbus->XferSize--;
    hsmbus->XferCount--;
  }
  else if (SMBUS_CHECK_FLAG(StatusFlags, SMBUS_FLAG_TCR) != RESET)
  {
    if ((hsmbus->XferCount != 0U) && (hsmbus->XferSize == 0U))
    {
      DevAddress = (uint16_t)(hsmbus->Instance->CR2 & I2C_CR2_SADD);

      if (hsmbus->XferCount > MAX_NBYTE_SIZE)
      {
        SMBUS_TransferConfig(hsmbus, DevAddress, MAX_NBYTE_SIZE,
                             (SMBUS_RELOAD_MODE | (hsmbus->XferOptions & SMBUS_SENDPEC_MODE)),
                             SMBUS_NO_STARTSTOP);
        hsmbus->XferSize = MAX_NBYTE_SIZE;
      }
      else
      {
        hsmbus->XferSize = hsmbus->XferCount;
        SMBUS_TransferConfig(hsmbus, DevAddress, (uint8_t)hsmbus->XferSize, hsmbus->XferOptions,
                             SMBUS_NO_STARTSTOP);
        /* If PEC mode is enable, size to transmit should be Size-1 byte, corresponding to PEC byte */
        /* PEC byte is automatically sent by HW block, no need to manage it in Transmit process */
        if (SMBUS_GET_PEC_MODE(hsmbus) != 0UL)
        {
          hsmbus->XferSize--;
          hsmbus->XferCount--;
        }
      }
    }
    else if ((hsmbus->XferCount == 0U) && (hsmbus->XferSize == 0U))
    {
      /* Call TxCpltCallback() if no stop mode is set */
      if (SMBUS_GET_STOP_MODE(hsmbus) != SMBUS_AUTOEND_MODE)
      {
        /* Call the corresponding callback to inform upper layer of End of Transfer */
        if (hsmbus->State == HAL_SMBUS_STATE_MASTER_BUSY_TX)
        {
          /* Disable Interrupt */
          SMBUS_Disable_IRQ(hsmbus, SMBUS_IT_TX);
          hsmbus->PreviousState = hsmbus->State;
          hsmbus->State = HAL_SMBUS_STATE_READY;

          /* Process Unlocked */
          __HAL_UNLOCK(hsmbus);

          /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_SMBUS_REGISTER_CALLBACKS == 1)
          hsmbus->MasterTxCpltCallback(hsmbus);
#else
          HAL_SMBUS_MasterTxCpltCallback(hsmbus);
#endif /* USE_HAL_SMBUS_REGISTER_CALLBACKS */
        }
        else if (hsmbus->State == HAL_SMBUS_STATE_MASTER_BUSY_RX)
        {
          SMBUS_Disable_IRQ(hsmbus, SMBUS_IT_RX);
          hsmbus->PreviousState = hsmbus->State;
          hsmbus->State = HAL_SMBUS_STATE_READY;

          /* Process Unlocked */
          __HAL_UNLOCK(hsmbus);

          /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_SMBUS_REGISTER_CALLBACKS == 1)
          hsmbus->MasterRxCpltCallback(hsmbus);
#else
          HAL_SMBUS_MasterRxCpltCallback(hsmbus);
#endif /* USE_HAL_SMBUS_REGISTER_CALLBACKS */
        }
        else
        {
          /* Nothing to do */
        }
      }
    }
    else
    {
      /* Nothing to do */
    }
  }
  else if (SMBUS_CHECK_FLAG(StatusFlags, SMBUS_FLAG_TC) != RESET)
  {
    if (hsmbus->XferCount == 0U)
    {
      /* Specific use case for Quick command */
      if (hsmbus->pBuffPtr == NULL)
      {
        /* Generate a Stop command */
        hsmbus->Instance->CR2 |= I2C_CR2_STOP;
      }
      /* Call TxCpltCallback() if no stop mode is set */
      else if (SMBUS_GET_STOP_MODE(hsmbus) != SMBUS_AUTOEND_MODE)
      {
        /* No Generate Stop, to permit restart mode */
        /* The stop will be done at the end of transfer, when SMBUS_AUTOEND_MODE enable */

        /* Call the corresponding callback to inform upper layer of End of Transfer */
        if (hsmbus->State == HAL_SMBUS_STATE_MASTER_BUSY_TX)
        {
          /* Disable Interrupt */
          SMBUS_Disable_IRQ(hsmbus, SMBUS_IT_TX);
          hsmbus->PreviousState = hsmbus->State;
          hsmbus->State = HAL_SMBUS_STATE_READY;

          /* Process Unlocked */
          __HAL_UNLOCK(hsmbus);

          /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_SMBUS_REGISTER_CALLBACKS == 1)
          hsmbus->MasterTxCpltCallback(hsmbus);
#else
          HAL_SMBUS_MasterTxCpltCallback(hsmbus);
#endif /* USE_HAL_SMBUS_REGISTER_CALLBACKS */
        }
        else if (hsmbus->State == HAL_SMBUS_STATE_MASTER_BUSY_RX)
        {
          SMBUS_Disable_IRQ(hsmbus, SMBUS_IT_RX);
          hsmbus->PreviousState = hsmbus->State;
          hsmbus->State = HAL_SMBUS_STATE_READY;

          /* Process Unlocked */
          __HAL_UNLOCK(hsmbus);

          /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_SMBUS_REGISTER_CALLBACKS == 1)
          hsmbus->MasterRxCpltCallback(hsmbus);
#else
          HAL_SMBUS_MasterRxCpltCallback(hsmbus);
#endif /* USE_HAL_SMBUS_REGISTER_CALLBACKS */
        }
        else
        {
          /* Nothing to do */
        }
      }
      else
      {
        /* Nothing to do */
      }
    }
  }
  else
  {
    /* Nothing to do */
  }

  /* Process Unlocked */
  __HAL_UNLOCK(hsmbus);

  return HAL_OK;
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
static HAL_StatusTypeDef SMBUS_Slave_ISR(SMBUS_HandleTypeDef *hsmbus, uint32_t StatusFlags)
{
  uint8_t TransferDirection;
  uint16_t SlaveAddrCode;

  /* Process Locked */
  __HAL_LOCK(hsmbus);

  if (SMBUS_CHECK_FLAG(StatusFlags, SMBUS_FLAG_AF) != RESET)
  {
    /* Check that SMBUS transfer finished */
    /* if yes, normal usecase, a NACK is sent by the HOST when Transfer is finished */
    /* Mean XferCount == 0*/
    /* So clear Flag NACKF only */
    if (hsmbus->XferCount == 0U)
    {
      /* Clear NACK Flag */
      __HAL_SMBUS_CLEAR_FLAG(hsmbus, SMBUS_FLAG_AF);

      /* Flush TX register */
      SMBUS_Flush_TXDR(hsmbus);

      /* Process Unlocked */
      __HAL_UNLOCK(hsmbus);
    }
    else
    {
      /* if no, error usecase, a Non-Acknowledge of last Data is generated by the HOST*/
      /* Clear NACK Flag */
      __HAL_SMBUS_CLEAR_FLAG(hsmbus, SMBUS_FLAG_AF);

      /* Set HAL State to "Idle" State, mean to LISTEN state */
      /* So reset Slave Busy state */
      hsmbus->PreviousState = hsmbus->State;
      hsmbus->State &= ~((uint32_t)HAL_SMBUS_STATE_SLAVE_BUSY_TX);
      hsmbus->State &= ~((uint32_t)HAL_SMBUS_STATE_SLAVE_BUSY_RX);

      /* Disable RX/TX Interrupts, keep only ADDR Interrupt */
      SMBUS_Disable_IRQ(hsmbus, SMBUS_IT_RX | SMBUS_IT_TX);

      /* Set ErrorCode corresponding to a Non-Acknowledge */
      hsmbus->ErrorCode |= HAL_SMBUS_ERROR_ACKF;

      /* Flush TX register */
      SMBUS_Flush_TXDR(hsmbus);

      /* Process Unlocked */
      __HAL_UNLOCK(hsmbus);

      /* Call the Error callback to inform upper layer */
#if (USE_HAL_SMBUS_REGISTER_CALLBACKS == 1)
      hsmbus->ErrorCallback(hsmbus);
#else
      HAL_SMBUS_ErrorCallback(hsmbus);
#endif /* USE_HAL_SMBUS_REGISTER_CALLBACKS */
    }
  }
  else if (SMBUS_CHECK_FLAG(StatusFlags, SMBUS_FLAG_ADDR) != RESET)
  {
    TransferDirection = (uint8_t)(SMBUS_GET_DIR(hsmbus));
    SlaveAddrCode = (uint16_t)(SMBUS_GET_ADDR_MATCH(hsmbus));

    /* Disable ADDR interrupt to prevent multiple ADDRInterrupt*/
    /* Other ADDRInterrupt will be treat in next Listen usecase */
    __HAL_SMBUS_DISABLE_IT(hsmbus, SMBUS_IT_ADDRI);

    /* Process Unlocked */
    __HAL_UNLOCK(hsmbus);

    /* Call Slave Addr callback */
#if (USE_HAL_SMBUS_REGISTER_CALLBACKS == 1)
    hsmbus->AddrCallback(hsmbus, TransferDirection, SlaveAddrCode);
#else
    HAL_SMBUS_AddrCallback(hsmbus, TransferDirection, SlaveAddrCode);
#endif /* USE_HAL_SMBUS_REGISTER_CALLBACKS */
  }
  else if ((SMBUS_CHECK_FLAG(StatusFlags, SMBUS_FLAG_RXNE) != RESET) ||
           (SMBUS_CHECK_FLAG(StatusFlags, SMBUS_FLAG_TCR) != RESET))
  {
    if ((hsmbus->State & HAL_SMBUS_STATE_SLAVE_BUSY_RX) == HAL_SMBUS_STATE_SLAVE_BUSY_RX)
    {
      /* Read data from RXDR */
      *hsmbus->pBuffPtr = (uint8_t)(hsmbus->Instance->RXDR);

      /* Increment Buffer pointer */
      hsmbus->pBuffPtr++;

      hsmbus->XferSize--;
      hsmbus->XferCount--;

      if (hsmbus->XferCount == 1U)
      {
        /* Receive last Byte, can be PEC byte in case of PEC BYTE enabled */
        /* or only the last Byte of Transfer */
        /* So reset the RELOAD bit mode */
        hsmbus->XferOptions &= ~SMBUS_RELOAD_MODE;
        SMBUS_TransferConfig(hsmbus, 0, 1, hsmbus->XferOptions, SMBUS_NO_STARTSTOP);
      }
      else if (hsmbus->XferCount == 0U)
      {
        /* Last Byte is received, disable Interrupt */
        SMBUS_Disable_IRQ(hsmbus, SMBUS_IT_RX);

        /* Remove HAL_SMBUS_STATE_SLAVE_BUSY_RX, keep only HAL_SMBUS_STATE_LISTEN */
        hsmbus->PreviousState = hsmbus->State;
        hsmbus->State &= ~((uint32_t)HAL_SMBUS_STATE_SLAVE_BUSY_RX);

        /* Process Unlocked */
        __HAL_UNLOCK(hsmbus);

        /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_SMBUS_REGISTER_CALLBACKS == 1)
        hsmbus->SlaveRxCpltCallback(hsmbus);
#else
        HAL_SMBUS_SlaveRxCpltCallback(hsmbus);
#endif /* USE_HAL_SMBUS_REGISTER_CALLBACKS */
      }
      else
      {
        /* Set Reload for next Bytes */
        SMBUS_TransferConfig(hsmbus, 0, 1,
                             SMBUS_RELOAD_MODE  | (hsmbus->XferOptions & SMBUS_SENDPEC_MODE),
                             SMBUS_NO_STARTSTOP);

        /* Ack last Byte Read */
        hsmbus->Instance->CR2 &= ~I2C_CR2_NACK;
      }
    }
    else if ((hsmbus->State & HAL_SMBUS_STATE_SLAVE_BUSY_TX) == HAL_SMBUS_STATE_SLAVE_BUSY_TX)
    {
      if ((hsmbus->XferCount != 0U) && (hsmbus->XferSize == 0U))
      {
        if (hsmbus->XferCount > MAX_NBYTE_SIZE)
        {
          SMBUS_TransferConfig(hsmbus, 0, MAX_NBYTE_SIZE,
                               (SMBUS_RELOAD_MODE | (hsmbus->XferOptions & SMBUS_SENDPEC_MODE)),
                               SMBUS_NO_STARTSTOP);
          hsmbus->XferSize = MAX_NBYTE_SIZE;
        }
        else
        {
          hsmbus->XferSize = hsmbus->XferCount;
          SMBUS_TransferConfig(hsmbus, 0, (uint8_t)hsmbus->XferSize, hsmbus->XferOptions,
                               SMBUS_NO_STARTSTOP);
          /* If PEC mode is enable, size to transmit should be Size-1 byte, corresponding to PEC byte */
          /* PEC byte is automatically sent by HW block, no need to manage it in Transmit process */
          if (SMBUS_GET_PEC_MODE(hsmbus) != 0UL)
          {
            hsmbus->XferSize--;
            hsmbus->XferCount--;
          }
        }
      }
    }
    else
    {
      /* Nothing to do */
    }
  }
  else if (SMBUS_CHECK_FLAG(StatusFlags, SMBUS_FLAG_TXIS) != RESET)
  {
    /* Write data to TXDR only if XferCount not reach "0" */
    /* A TXIS flag can be set, during STOP treatment      */
    /* Check if all Data have already been sent */
    /* If it is the case, this last write in TXDR is not sent, correspond to a dummy TXIS event */
    if (hsmbus->XferCount > 0U)
    {
      /* Write data to TXDR */
      hsmbus->Instance->TXDR = *hsmbus->pBuffPtr;

      /* Increment Buffer pointer */
      hsmbus->pBuffPtr++;

      hsmbus->XferCount--;
      hsmbus->XferSize--;
    }

    if (hsmbus->XferCount == 0U)
    {
      /* Last Byte is Transmitted */
      /* Remove HAL_SMBUS_STATE_SLAVE_BUSY_TX, keep only HAL_SMBUS_STATE_LISTEN */
      SMBUS_Disable_IRQ(hsmbus, SMBUS_IT_TX);
      hsmbus->PreviousState = hsmbus->State;
      hsmbus->State &= ~((uint32_t)HAL_SMBUS_STATE_SLAVE_BUSY_TX);

      /* Process Unlocked */
      __HAL_UNLOCK(hsmbus);

      /* Call the corresponding callback to inform upper layer of End of Transfer */
#if (USE_HAL_SMBUS_REGISTER_CALLBACKS == 1)
      hsmbus->SlaveTxCpltCallback(hsmbus);
#else
      HAL_SMBUS_SlaveTxCpltCallback(hsmbus);
#endif /* USE_HAL_SMBUS_REGISTER_CALLBACKS */
    }
  }
  else
  {
    /* Nothing to do */
  }

  /* Check if STOPF is set */
  if (SMBUS_CHECK_FLAG(StatusFlags, SMBUS_FLAG_STOPF) != RESET)
  {
    if ((hsmbus->State & HAL_SMBUS_STATE_LISTEN) == HAL_SMBUS_STATE_LISTEN)
    {
      /* Store Last receive data if any */
      if (__HAL_SMBUS_GET_FLAG(hsmbus, SMBUS_FLAG_RXNE) != RESET)
      {
        /* Read data from RXDR */
        *hsmbus->pBuffPtr = (uint8_t)(hsmbus->Instance->RXDR);

        /* Increment Buffer pointer */
        hsmbus->pBuffPtr++;

        if (hsmbus->XferSize > 0U)
        {
          hsmbus->XferSize--;
          hsmbus->XferCount--;
        }
      }

      /* Disable RX and TX Interrupts */
      SMBUS_Disable_IRQ(hsmbus, SMBUS_IT_RX | SMBUS_IT_TX);

      /* Disable ADDR Interrupt */
      SMBUS_Disable_IRQ(hsmbus, SMBUS_IT_ADDR);

      /* Disable Address Acknowledge */
      hsmbus->Instance->CR2 |= I2C_CR2_NACK;

      /* Clear Configuration Register 2 */
      SMBUS_RESET_CR2(hsmbus);

      /* Clear STOP Flag */
      __HAL_SMBUS_CLEAR_FLAG(hsmbus, SMBUS_FLAG_STOPF);

      /* Clear ADDR flag */
      __HAL_SMBUS_CLEAR_FLAG(hsmbus, SMBUS_FLAG_ADDR);

      hsmbus->XferOptions = 0;
      hsmbus->PreviousState = hsmbus->State;
      hsmbus->State = HAL_SMBUS_STATE_READY;

      /* Process Unlocked */
      __HAL_UNLOCK(hsmbus);

      /* Call the Listen Complete callback, to inform upper layer of the end of Listen usecase */
#if (USE_HAL_SMBUS_REGISTER_CALLBACKS == 1)
      hsmbus->ListenCpltCallback(hsmbus);
#else
      HAL_SMBUS_ListenCpltCallback(hsmbus);
#endif /* USE_HAL_SMBUS_REGISTER_CALLBACKS */
    }
  }

  /* Process Unlocked */
  __HAL_UNLOCK(hsmbus);

  return HAL_OK;
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
static void SMBUS_Enable_IRQ(SMBUS_HandleTypeDef *hsmbus, uint32_t InterruptRequest)
{
  uint32_t tmpisr = 0UL;

  if ((InterruptRequest & SMBUS_IT_ALERT) == SMBUS_IT_ALERT)
  {
    /* Enable ERR interrupt */
    tmpisr |= SMBUS_IT_ERRI;
  }

  if ((InterruptRequest & SMBUS_IT_ADDR) == SMBUS_IT_ADDR)
  {
    /* Enable ADDR, STOP interrupt */
    tmpisr |= SMBUS_IT_ADDRI | SMBUS_IT_STOPI | SMBUS_IT_NACKI | SMBUS_IT_ERRI;
  }

  if ((InterruptRequest & SMBUS_IT_TX) == SMBUS_IT_TX)
  {
    /* Enable ERR, TC, STOP, NACK, RXI interrupt */
    tmpisr |= SMBUS_IT_ERRI | SMBUS_IT_TCI | SMBUS_IT_STOPI | SMBUS_IT_NACKI | SMBUS_IT_TXI;
  }

  if ((InterruptRequest & SMBUS_IT_RX) == SMBUS_IT_RX)
  {
    /* Enable ERR, TC, STOP, NACK, TXI interrupt */
    tmpisr |= SMBUS_IT_ERRI | SMBUS_IT_TCI | SMBUS_IT_STOPI | SMBUS_IT_NACKI | SMBUS_IT_RXI;
  }

  /* Enable interrupts only at the end */
  /* to avoid the risk of SMBUS interrupt handle execution before */
  /* all interrupts requested done */
  __HAL_SMBUS_ENABLE_IT(hsmbus, tmpisr);
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
static void SMBUS_Disable_IRQ(SMBUS_HandleTypeDef *hsmbus, uint32_t InterruptRequest)
{
  uint32_t tmpisr = 0UL;
  uint32_t tmpstate = hsmbus->State;

  if ((tmpstate == HAL_SMBUS_STATE_READY) && ((InterruptRequest & SMBUS_IT_ALERT) == SMBUS_IT_ALERT))
  {
    /* Disable ERR interrupt */
    tmpisr |= SMBUS_IT_ERRI;
  }

  if ((InterruptRequest & SMBUS_IT_TX) == SMBUS_IT_TX)
  {
    /* Disable TC, STOP, NACK and TXI interrupt */
    tmpisr |= SMBUS_IT_TCI | SMBUS_IT_TXI;

    if ((SMBUS_GET_ALERT_ENABLED(hsmbus) == 0UL)
        && ((tmpstate & HAL_SMBUS_STATE_LISTEN) != HAL_SMBUS_STATE_LISTEN))
    {
      /* Disable ERR interrupt */
      tmpisr |= SMBUS_IT_ERRI;
    }

    if ((tmpstate & HAL_SMBUS_STATE_LISTEN) != HAL_SMBUS_STATE_LISTEN)
    {
      /* Disable STOP and NACK interrupt */
      tmpisr |= SMBUS_IT_STOPI | SMBUS_IT_NACKI;
    }
  }

  if ((InterruptRequest & SMBUS_IT_RX) == SMBUS_IT_RX)
  {
    /* Disable TC, STOP, NACK and RXI interrupt */
    tmpisr |= SMBUS_IT_TCI | SMBUS_IT_RXI;

    if ((SMBUS_GET_ALERT_ENABLED(hsmbus) == 0UL)
        && ((tmpstate & HAL_SMBUS_STATE_LISTEN) != HAL_SMBUS_STATE_LISTEN))
    {
      /* Disable ERR interrupt */
      tmpisr |= SMBUS_IT_ERRI;
    }

    if ((tmpstate & HAL_SMBUS_STATE_LISTEN) != HAL_SMBUS_STATE_LISTEN)
    {
      /* Disable STOP and NACK interrupt */
      tmpisr |= SMBUS_IT_STOPI | SMBUS_IT_NACKI;
    }
  }

  if ((InterruptRequest & SMBUS_IT_ADDR) == SMBUS_IT_ADDR)
  {
    /* Disable ADDR, STOP and NACK interrupt */
    tmpisr |= SMBUS_IT_ADDRI | SMBUS_IT_STOPI | SMBUS_IT_NACKI;

    if (SMBUS_GET_ALERT_ENABLED(hsmbus) == 0UL)
    {
      /* Disable ERR interrupt */
      tmpisr |= SMBUS_IT_ERRI;
    }
  }

  /* Disable interrupts only at the end */
  /* to avoid a breaking situation like at "t" time */
  /* all disable interrupts request are not done */
  __HAL_SMBUS_DISABLE_IT(hsmbus, tmpisr);
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
static void SMBUS_ITErrorHandler(SMBUS_HandleTypeDef *hsmbus)
{
  uint32_t itflags   = READ_REG(hsmbus->Instance->ISR);
  uint32_t itsources = READ_REG(hsmbus->Instance->CR1);
  uint32_t tmpstate;
  uint32_t tmperror;

  /* SMBUS Bus error interrupt occurred ------------------------------------*/
  if (((itflags & SMBUS_FLAG_BERR) == SMBUS_FLAG_BERR) && \
      ((itsources & SMBUS_IT_ERRI) == SMBUS_IT_ERRI))
  {
    hsmbus->ErrorCode |= HAL_SMBUS_ERROR_BERR;

    /* Clear BERR flag */
    __HAL_SMBUS_CLEAR_FLAG(hsmbus, SMBUS_FLAG_BERR);
  }

  /* SMBUS Over-Run/Under-Run interrupt occurred ----------------------------------------*/
  if (((itflags & SMBUS_FLAG_OVR) == SMBUS_FLAG_OVR) && \
      ((itsources & SMBUS_IT_ERRI) == SMBUS_IT_ERRI))
  {
    hsmbus->ErrorCode |= HAL_SMBUS_ERROR_OVR;

    /* Clear OVR flag */
    __HAL_SMBUS_CLEAR_FLAG(hsmbus, SMBUS_FLAG_OVR);
  }

  /* SMBUS Arbitration Loss error interrupt occurred ------------------------------------*/
  if (((itflags & SMBUS_FLAG_ARLO) == SMBUS_FLAG_ARLO) && \
      ((itsources & SMBUS_IT_ERRI) == SMBUS_IT_ERRI))
  {
    hsmbus->ErrorCode |= HAL_SMBUS_ERROR_ARLO;

    /* Clear ARLO flag */
    __HAL_SMBUS_CLEAR_FLAG(hsmbus, SMBUS_FLAG_ARLO);
  }

  /* SMBUS Timeout error interrupt occurred ---------------------------------------------*/
  if (((itflags & SMBUS_FLAG_TIMEOUT) == SMBUS_FLAG_TIMEOUT) && \
      ((itsources & SMBUS_IT_ERRI) == SMBUS_IT_ERRI))
  {
    hsmbus->ErrorCode |= HAL_SMBUS_ERROR_BUSTIMEOUT;

    /* Clear TIMEOUT flag */
    __HAL_SMBUS_CLEAR_FLAG(hsmbus, SMBUS_FLAG_TIMEOUT);
  }

  /* SMBUS Alert error interrupt occurred -----------------------------------------------*/
  if (((itflags & SMBUS_FLAG_ALERT) == SMBUS_FLAG_ALERT) && \
      ((itsources & SMBUS_IT_ERRI) == SMBUS_IT_ERRI))
  {
    hsmbus->ErrorCode |= HAL_SMBUS_ERROR_ALERT;

    /* Clear ALERT flag */
    __HAL_SMBUS_CLEAR_FLAG(hsmbus, SMBUS_FLAG_ALERT);
  }

  /* SMBUS Packet Error Check error interrupt occurred ----------------------------------*/
  if (((itflags & SMBUS_FLAG_PECERR) == SMBUS_FLAG_PECERR) && \
      ((itsources & SMBUS_IT_ERRI) == SMBUS_IT_ERRI))
  {
    hsmbus->ErrorCode |= HAL_SMBUS_ERROR_PECERR;

    /* Clear PEC error flag */
    __HAL_SMBUS_CLEAR_FLAG(hsmbus, SMBUS_FLAG_PECERR);
  }

  if (hsmbus->ErrorCode != HAL_SMBUS_ERROR_NONE)
  {
    /* Flush TX register */
    SMBUS_Flush_TXDR(hsmbus);
  }

  /* Store current volatile hsmbus->ErrorCode, misra rule */
  tmperror = hsmbus->ErrorCode;

  /* Call the Error Callback in case of Error detected */
  if ((tmperror != HAL_SMBUS_ERROR_NONE) && (tmperror != HAL_SMBUS_ERROR_ACKF))
  {
    /* Do not Reset the HAL state in case of ALERT error */
    if ((tmperror & HAL_SMBUS_ERROR_ALERT) != HAL_SMBUS_ERROR_ALERT)
    {
      /* Store current volatile hsmbus->State, misra rule */
      tmpstate = hsmbus->State;

      if (((tmpstate & HAL_SMBUS_STATE_SLAVE_BUSY_TX) == HAL_SMBUS_STATE_SLAVE_BUSY_TX)
          || ((tmpstate & HAL_SMBUS_STATE_SLAVE_BUSY_RX) == HAL_SMBUS_STATE_SLAVE_BUSY_RX))
      {
        /* Reset only HAL_SMBUS_STATE_SLAVE_BUSY_XX */
        /* keep HAL_SMBUS_STATE_LISTEN if set */
        hsmbus->PreviousState = HAL_SMBUS_STATE_READY;
        hsmbus->State = HAL_SMBUS_STATE_LISTEN;
      }
    }

    /* Call the Error callback to inform upper layer */
#if (USE_HAL_SMBUS_REGISTER_CALLBACKS == 1)
    hsmbus->ErrorCallback(hsmbus);
#else
    HAL_SMBUS_ErrorCallback(hsmbus);
#endif /* USE_HAL_SMBUS_REGISTER_CALLBACKS */
  }
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
static HAL_StatusTypeDef SMBUS_WaitOnFlagUntilTimeout(SMBUS_HandleTypeDef *hsmbus, uint32_t Flag,
                                                      FlagStatus Status, uint32_t Timeout)
{
  uint32_t tickstart = HAL_GetTick();

  /* Wait until flag is set */
  while ((FlagStatus)(__HAL_SMBUS_GET_FLAG(hsmbus, Flag)) == Status)
  {
    /* Check for the Timeout */
    if (Timeout != HAL_MAX_DELAY)
    {
      if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0UL))
      {
        hsmbus->PreviousState = hsmbus->State;
        hsmbus->State = HAL_SMBUS_STATE_READY;

        /* Update SMBUS error code */
        hsmbus->ErrorCode |= HAL_SMBUS_ERROR_HALTIMEOUT;

        /* Process Unlocked */
        __HAL_UNLOCK(hsmbus);

        return HAL_ERROR;
      }
    }
  }

  return HAL_OK;
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
static void SMBUS_Flush_TXDR(SMBUS_HandleTypeDef *hsmbus)
{
  /* If a pending TXIS flag is set */
  /* Write a dummy data in TXDR to clear it */
  if (__HAL_SMBUS_GET_FLAG(hsmbus, SMBUS_FLAG_TXIS) != RESET)
  {
    hsmbus->Instance->TXDR = 0x00U;
  }

  /* Flush TX register if not empty */
  if (__HAL_SMBUS_GET_FLAG(hsmbus, SMBUS_FLAG_TXE) == RESET)
  {
    __HAL_SMBUS_CLEAR_FLAG(hsmbus, SMBUS_FLAG_TXE);
  }
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
static void SMBUS_TransferConfig(SMBUS_HandleTypeDef *hsmbus,  uint16_t DevAddress, uint8_t Size,
                                 uint32_t Mode, uint32_t Request)
{
  /* Check the parameters */
  assert_param(IS_SMBUS_ALL_INSTANCE(hsmbus->Instance));
  assert_param(IS_SMBUS_TRANSFER_MODE(Mode));
  assert_param(IS_SMBUS_TRANSFER_REQUEST(Request));

  /* update CR2 register */
  MODIFY_REG(hsmbus->Instance->CR2,
             ((I2C_CR2_SADD | I2C_CR2_NBYTES | I2C_CR2_RELOAD | I2C_CR2_AUTOEND | \
               (I2C_CR2_RD_WRN & (uint32_t)(Request >> (31UL - I2C_CR2_RD_WRN_Pos))) | \
               I2C_CR2_START | I2C_CR2_STOP | I2C_CR2_PECBYTE)), \
             (uint32_t)(((uint32_t)DevAddress & I2C_CR2_SADD) | \
                        (((uint32_t)Size << I2C_CR2_NBYTES_Pos) & I2C_CR2_NBYTES) | \
                        (uint32_t)Mode | (uint32_t)Request));
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
static void SMBUS_ConvertOtherXferOptions(SMBUS_HandleTypeDef *hsmbus)
{
  /* if user set XferOptions to SMBUS_OTHER_FRAME_NO_PEC   */
  /* it request implicitly to generate a restart condition */
  /* set XferOptions to SMBUS_FIRST_FRAME                  */
  if (hsmbus->XferOptions == SMBUS_OTHER_FRAME_NO_PEC)
  {
    hsmbus->XferOptions = SMBUS_FIRST_FRAME;
  }
  /* else if user set XferOptions to SMBUS_OTHER_FRAME_WITH_PEC */
  /* it request implicitly to generate a restart condition      */
  /* set XferOptions to SMBUS_FIRST_FRAME | SMBUS_SENDPEC_MODE  */
  else if (hsmbus->XferOptions == SMBUS_OTHER_FRAME_WITH_PEC)
  {
    hsmbus->XferOptions = SMBUS_FIRST_FRAME | SMBUS_SENDPEC_MODE;
  }
  /* else if user set XferOptions to SMBUS_OTHER_AND_LAST_FRAME_NO_PEC */
  /* it request implicitly to generate a restart condition             */
  /* then generate a stop condition at the end of transfer             */
  /* set XferOptions to SMBUS_FIRST_AND_LAST_FRAME_NO_PEC              */
  else if (hsmbus->XferOptions == SMBUS_OTHER_AND_LAST_FRAME_NO_PEC)
  {
    hsmbus->XferOptions = SMBUS_FIRST_AND_LAST_FRAME_NO_PEC;
  }
  /* else if user set XferOptions to SMBUS_OTHER_AND_LAST_FRAME_WITH_PEC */
  /* it request implicitly to generate a restart condition               */
  /* then generate a stop condition at the end of transfer               */
  /* set XferOptions to SMBUS_FIRST_AND_LAST_FRAME_WITH_PEC              */
  else if (hsmbus->XferOptions == SMBUS_OTHER_AND_LAST_FRAME_WITH_PEC)
  {
    hsmbus->XferOptions = SMBUS_FIRST_AND_LAST_FRAME_WITH_PEC;
  }
  else
  {
    /* Nothing to do */
  }
}
#endif
