// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2S and SAI/SAIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2S_Init(I2S_HandleTypeDef *hi2s)
{
  uint32_t i2sdiv;
  uint32_t i2sodd;
  uint32_t packetlength;
  uint32_t tmp;
  uint32_t i2sclk;
  uint32_t ispcm;

  /* Check the I2S handle allocation */
  if (hi2s == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the I2S parameters */
  assert_param(IS_I2S_ALL_INSTANCE(hi2s->Instance));
  assert_param(IS_I2S_MODE(hi2s->Init.Mode));
  assert_param(IS_I2S_STANDARD(hi2s->Init.Standard));
  assert_param(IS_I2S_DATA_FORMAT(hi2s->Init.DataFormat));
  assert_param(IS_I2S_MCLK_OUTPUT(hi2s->Init.MCLKOutput));
  assert_param(IS_I2S_AUDIO_FREQ(hi2s->Init.AudioFreq));
  assert_param(IS_I2S_CPOL(hi2s->Init.CPOL));
  assert_param(IS_I2S_FIRST_BIT(hi2s->Init.FirstBit));
  assert_param(IS_I2S_WS_INVERSION(hi2s->Init.WSInversion));
  assert_param(IS_I2S_DATA_24BIT_ALIGNMENT(hi2s->Init.Data24BitAlignment));
  assert_param(IS_I2S_MASTER_KEEP_IO_STATE(hi2s->Init.MasterKeepIOState));

  if (hi2s->State == HAL_I2S_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    hi2s->Lock = HAL_UNLOCKED;

#if (USE_HAL_I2S_REGISTER_CALLBACKS == 1UL)
    /* Init the I2S Callback settings */
    hi2s->TxCpltCallback       = HAL_I2S_TxCpltCallback;          /* Legacy weak TxCpltCallback       */
    hi2s->RxCpltCallback       = HAL_I2S_RxCpltCallback;          /* Legacy weak RxCpltCallback       */
    hi2s->TxRxCpltCallback     = HAL_I2SEx_TxRxCpltCallback;      /* Legacy weak TxRxCpltCallback     */
    hi2s->TxHalfCpltCallback   = HAL_I2S_TxHalfCpltCallback;      /* Legacy weak TxHalfCpltCallback   */
    hi2s->RxHalfCpltCallback   = HAL_I2S_RxHalfCpltCallback;      /* Legacy weak RxHalfCpltCallback   */
    hi2s->TxRxHalfCpltCallback = HAL_I2SEx_TxRxHalfCpltCallback;  /* Legacy weak TxRxHalfCpltCallback */
    hi2s->ErrorCallback        = HAL_I2S_ErrorCallback;           /* Legacy weak ErrorCallback        */

    if (hi2s->MspInitCallback == NULL)
    {
      hi2s->MspInitCallback = HAL_I2S_MspInit; /* Legacy weak MspInit  */
    }

    /* Init the low level hardware : GPIO, CLOCK, NVIC... */
    hi2s->MspInitCallback(hi2s);
#else
    /* Init the low level hardware : GPIO, CLOCK, CORTEX...etc */
    HAL_I2S_MspInit(hi2s);
#endif /* USE_HAL_I2S_REGISTER_CALLBACKS */
  }

  hi2s->State = HAL_I2S_STATE_BUSY;

  /* Disable the selected I2S peripheral */
  if ((hi2s->Instance->CR1 & SPI_CR1_SPE) == SPI_CR1_SPE)
  {
    /* Disable I2S peripheral */
    __HAL_I2S_DISABLE(hi2s);
  }

  /* Clear I2S configuration register */
  CLEAR_REG(hi2s->Instance->I2SCFGR);

  if (IS_I2S_MASTER(hi2s->Init.Mode))
  {
    /*------------------------- I2SDIV and ODD Calculation ---------------------*/
    /* If the requested audio frequency is not the default, compute the prescaler */
    if (hi2s->Init.AudioFreq != I2S_AUDIOFREQ_DEFAULT)
    {
      /* Check the frame length (For the Prescaler computing) ********************/
      if (hi2s->Init.DataFormat != I2S_DATAFORMAT_16B)
      {
        /* Channel length is 32 bits */
        packetlength = 2UL;
      }
      else
      {
        /* Channel length is 16 bits */
        packetlength = 1UL;
      }

      /* Check if PCM standard is used */
      if ((hi2s->Init.Standard == I2S_STANDARD_PCM_SHORT) ||
          (hi2s->Init.Standard == I2S_STANDARD_PCM_LONG))
      {
        ispcm = 1UL;
      }
      else
      {
        ispcm = 0UL;
      }

      /* Get the source clock value: based on System Clock value */
      if (hi2s->Instance == SPI1)
      {
        i2sclk = HAL_RCCEx_GetPeriphCLKFreq(RCC_PERIPHCLK_SPI1);
      }
      else if ((hi2s->Instance == SPI2) || (hi2s->Instance == SPI3))
      {
        i2sclk = HAL_RCCEx_GetPeriphCLKFreq(RCC_PERIPHCLK_SPI23);
      }
      else /* SPI6 source clock */
      {
        i2sclk = HAL_RCCEx_GetPeriphCLKFreq(RCC_PERIPHCLK_SPI6);
      }

      /* Compute the Real divider depending on the MCLK output state, with a floating point */
      if (hi2s->Init.MCLKOutput == I2S_MCLKOUTPUT_ENABLE)
      {
        /* MCLK output is enabled */
        tmp = (uint32_t)((((i2sclk / (256UL >> ispcm)) * 10UL) / hi2s->Init.AudioFreq) + 5UL);
      }
      else
      {
        /* MCLK output is disabled */
        tmp = (uint32_t)((((i2sclk / ((32UL >> ispcm) * packetlength)) * 10UL) / hi2s->Init.AudioFreq) + 5UL);
      }

      /* Remove the flatting point */
      tmp = tmp / 10UL;

      /* Check the parity of the divider */
      i2sodd = (uint32_t)(tmp & (uint32_t)1UL);

      /* Compute the i2sdiv prescaler */
      i2sdiv = (uint32_t)((tmp - i2sodd) / 2UL);
    }
    else
    {
      /* Set the default values */
      i2sdiv = 2UL;
      i2sodd = 0UL;
    }

    /* Test if the obtain values are forbidden or out of range */
    if (((i2sodd == 1UL) && (i2sdiv == 1UL)) || (i2sdiv > 0xFFUL))
    {
      /* Set the error code */
      SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_PRESCALER);
      return  HAL_ERROR;
    }

    /* Force i2smod to 1 just to be sure that (2xi2sdiv + i2sodd) is always higher than 0 */
    if (i2sdiv == 0UL)
    {
      i2sodd = 1UL;
    }

    MODIFY_REG(hi2s->Instance->I2SCFGR, (SPI_I2SCFGR_I2SDIV                 | SPI_I2SCFGR_ODD),
               ((i2sdiv << SPI_I2SCFGR_I2SDIV_Pos) | (i2sodd << SPI_I2SCFGR_ODD_Pos)));
  }

  /*-------------------------- I2Sx I2SCFGR Configuration --------------------*/
  /* Configure I2SMOD, I2SCFG, I2SSTD, PCMSYNC, DATLEN ,CHLEN ,CKPOL, WSINV, DATAFMT, I2SDIV, ODD and MCKOE bits bits */
  /* And configure the I2S with the I2S_InitStruct values */
  MODIFY_REG(hi2s->Instance->I2SCFGR, (SPI_I2SCFGR_I2SMOD   | SPI_I2SCFGR_I2SCFG     | \
                                       SPI_I2SCFGR_I2SSTD   | SPI_I2SCFGR_PCMSYNC    | \
                                       SPI_I2SCFGR_DATLEN   | SPI_I2SCFGR_CHLEN      | \
                                       SPI_I2SCFGR_CKPOL    | SPI_I2SCFGR_WSINV      | \
                                       SPI_I2SCFGR_DATFMT   | SPI_I2SCFGR_MCKOE),
             (SPI_I2SCFGR_I2SMOD   | hi2s->Init.Mode        | \
              hi2s->Init.Standard  | hi2s->Init.DataFormat  | \
              hi2s->Init.CPOL      | hi2s->Init.WSInversion | \
              hi2s->Init.Data24BitAlignment | hi2s->Init.MCLKOutput));
  /*Clear status register*/
  WRITE_REG(hi2s->Instance->IFCR, 0x0FF8);

  /*---------------------------- I2Sx CFG2 Configuration ----------------------*/

  /* Unlock the AF configuration to configure CFG2 register*/
  CLEAR_BIT(hi2s->Instance->CR1, SPI_CR1_IOLOCK);

  MODIFY_REG(hi2s->Instance->CFG2, SPI_CFG2_LSBFRST, hi2s->Init.FirstBit);

  /* Insure that AFCNTR is managed only by Master */
  if (IS_I2S_MASTER(hi2s->Init.Mode))
  {
    /* Alternate function GPIOs control */
    MODIFY_REG(hi2s->Instance->CFG2, SPI_CFG2_AFCNTR, (hi2s->Init.MasterKeepIOState));
  }

  hi2s->ErrorCode = HAL_I2S_ERROR_NONE;
  hi2s->State     = HAL_I2S_STATE_READY;

  return HAL_OK;
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2S_DeInit(I2S_HandleTypeDef *hi2s)
{
  /* Check the I2S handle allocation */
  if (hi2s == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_I2S_ALL_INSTANCE(hi2s->Instance));

  hi2s->State = HAL_I2S_STATE_BUSY;

  /* Disable the I2S Peripheral Clock */
  __HAL_I2S_DISABLE(hi2s);

#if (USE_HAL_I2S_REGISTER_CALLBACKS == 1UL)
  if (hi2s->MspDeInitCallback == NULL)
  {
    hi2s->MspDeInitCallback = HAL_I2S_MspDeInit; /* Legacy weak MspDeInit  */
  }

  /* DeInit the low level hardware: GPIO, CLOCK, NVIC... */
  hi2s->MspDeInitCallback(hi2s);
#else
  /* DeInit the low level hardware: GPIO, CLOCK, NVIC... */
  HAL_I2S_MspDeInit(hi2s);
#endif /* USE_HAL_I2S_REGISTER_CALLBACKS */

  hi2s->ErrorCode = HAL_I2S_ERROR_NONE;
  hi2s->State     = HAL_I2S_STATE_RESET;

  /* Release Lock */
  __HAL_UNLOCK(hi2s);

  return HAL_OK;
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
#if (USE_HAL_I2S_REGISTER_CALLBACKS == 1UL)
HAL_StatusTypeDef HAL_I2S_RegisterCallback(I2S_HandleTypeDef *hi2s, HAL_I2S_CallbackIDTypeDef CallbackID,
                                           pI2S_CallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hi2s->ErrorCode |= HAL_I2S_ERROR_INVALID_CALLBACK;

    return HAL_ERROR;
  }

  if (HAL_I2S_STATE_READY == hi2s->State)
  {
    switch (CallbackID)
    {
      case HAL_I2S_TX_COMPLETE_CB_ID :
        hi2s->TxCpltCallback = pCallback;
        break;

      case HAL_I2S_RX_COMPLETE_CB_ID :
        hi2s->RxCpltCallback = pCallback;
        break;

      case HAL_I2S_TX_RX_COMPLETE_CB_ID :
        hi2s->TxRxCpltCallback = pCallback;
        break;

      case HAL_I2S_TX_HALF_COMPLETE_CB_ID :
        hi2s->TxHalfCpltCallback = pCallback;
        break;

      case HAL_I2S_RX_HALF_COMPLETE_CB_ID :
        hi2s->RxHalfCpltCallback = pCallback;
        break;


      case HAL_I2S_TX_RX_HALF_COMPLETE_CB_ID :
        hi2s->TxRxHalfCpltCallback = pCallback;
        break;

      case HAL_I2S_ERROR_CB_ID :
        hi2s->ErrorCallback = pCallback;
        break;

      case HAL_I2S_MSPINIT_CB_ID :
        hi2s->MspInitCallback = pCallback;
        break;

      case HAL_I2S_MSPDEINIT_CB_ID :
        hi2s->MspDeInitCallback = pCallback;
        break;

      default :
        /* Update the error code */
        SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_INVALID_CALLBACK);

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (HAL_I2S_STATE_RESET == hi2s->State)
  {
    switch (CallbackID)
    {
      case HAL_I2S_MSPINIT_CB_ID :
        hi2s->MspInitCallback = pCallback;
        break;

      case HAL_I2S_MSPDEINIT_CB_ID :
        hi2s->MspDeInitCallback = pCallback;
        break;

      default :
        /* Update the error code */
        SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_INVALID_CALLBACK);

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_INVALID_CALLBACK);

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif
#endif

#ifdef HAL_I2S_MODULE_ENABLED
#if (USE_HAL_I2S_REGISTER_CALLBACKS == 1UL)
HAL_StatusTypeDef HAL_I2S_UnRegisterCallback(I2S_HandleTypeDef *hi2s, HAL_I2S_CallbackIDTypeDef CallbackID)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (HAL_I2S_STATE_READY == hi2s->State)
  {
    switch (CallbackID)
    {
      case HAL_I2S_TX_COMPLETE_CB_ID :
        hi2s->TxCpltCallback = HAL_I2S_TxCpltCallback;                /* Legacy weak TxCpltCallback       */
        break;

      case HAL_I2S_RX_COMPLETE_CB_ID :
        hi2s->RxCpltCallback = HAL_I2S_RxCpltCallback;                /* Legacy weak RxCpltCallback       */
        break;

      case HAL_I2S_TX_RX_COMPLETE_CB_ID :
        hi2s->TxRxCpltCallback = HAL_I2SEx_TxRxCpltCallback;          /* Legacy weak TxRxCpltCallback     */
        break;

      case HAL_I2S_TX_HALF_COMPLETE_CB_ID :
        hi2s->TxHalfCpltCallback = HAL_I2S_TxHalfCpltCallback;        /* Legacy weak TxHalfCpltCallback   */
        break;

      case HAL_I2S_RX_HALF_COMPLETE_CB_ID :
        hi2s->RxHalfCpltCallback = HAL_I2S_RxHalfCpltCallback;        /* Legacy weak RxHalfCpltCallback   */
        break;

      case HAL_I2S_TX_RX_HALF_COMPLETE_CB_ID :
        hi2s->TxRxHalfCpltCallback = HAL_I2SEx_TxRxHalfCpltCallback;  /* Legacy weak TxRxHalfCpltCallback */
        break;

      case HAL_I2S_ERROR_CB_ID :
        hi2s->ErrorCallback = HAL_I2S_ErrorCallback;                  /* Legacy weak ErrorCallback        */
        break;

      case HAL_I2S_MSPINIT_CB_ID :
        hi2s->MspInitCallback = HAL_I2S_MspInit;                      /* Legacy weak MspInit              */
        break;

      case HAL_I2S_MSPDEINIT_CB_ID :
        hi2s->MspDeInitCallback = HAL_I2S_MspDeInit;                  /* Legacy weak MspDeInit            */
        break;

      default :
        /* Update the error code */
        SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_INVALID_CALLBACK);

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (HAL_I2S_STATE_RESET == hi2s->State)
  {
    switch (CallbackID)
    {
      case HAL_I2S_MSPINIT_CB_ID :
        hi2s->MspInitCallback = HAL_I2S_MspInit;                      /* Legacy weak MspInit              */
        break;

      case HAL_I2S_MSPDEINIT_CB_ID :
        hi2s->MspDeInitCallback = HAL_I2S_MspDeInit;                  /* Legacy weak MspDeInit            */
        break;

      default :
        /* Update the error code */
        SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_INVALID_CALLBACK);

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_INVALID_CALLBACK);

    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2S_Transmit(I2S_HandleTypeDef *hi2s, const uint16_t *pData, uint16_t Size, uint32_t Timeout)
{
#if defined (__GNUC__)
  __IO uint16_t *ptxdr_16bits = (__IO uint16_t *)(&(hi2s->Instance->TXDR));
#endif /* __GNUC__ */
  uint32_t tickstart;

  if ((pData == NULL) || (Size == 0UL))
  {
    return  HAL_ERROR;
  }

  if (hi2s->State != HAL_I2S_STATE_READY)
  {
    return HAL_BUSY;
  }

  /* Process Locked */
  __HAL_LOCK(hi2s);

  /* Init tickstart for timeout management*/
  tickstart = HAL_GetTick();

  /* Set state and reset error code */
  hi2s->State       = HAL_I2S_STATE_BUSY_TX;
  hi2s->ErrorCode   = HAL_I2S_ERROR_NONE;
  hi2s->pTxBuffPtr  = (const uint16_t *)pData;
  hi2s->TxXferSize  = Size;
  hi2s->TxXferCount = Size;

  /* Initialize fields not used in handle to zero */
  hi2s->pRxBuffPtr  = NULL;
  hi2s->RxXferSize  = (uint16_t) 0UL;
  hi2s->RxXferCount = (uint16_t) 0UL;

  /* Check if the I2S is already enabled */
  if ((hi2s->Instance->CR1 & SPI_CR1_SPE) != SPI_CR1_SPE)
  {
    /* Enable I2S peripheral */
    __HAL_I2S_ENABLE(hi2s);
  }

  /* Start the transfer */
  SET_BIT(hi2s->Instance->CR1, SPI_CR1_CSTART);


  /* Wait until TXP flag is set */
  if (I2S_WaitFlagStateUntilTimeout(hi2s, I2S_FLAG_TXP, SET, tickstart, Timeout) != HAL_OK)
  {
    /* Set the error code */
    SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_TIMEOUT);
    hi2s->State = HAL_I2S_STATE_READY;
    __HAL_UNLOCK(hi2s);
    return HAL_TIMEOUT;
  }

  while (hi2s->TxXferCount > 0UL)
  {
    if ((hi2s->Init.DataFormat == I2S_DATAFORMAT_24B) || (hi2s->Init.DataFormat == I2S_DATAFORMAT_32B))
    {
      /* Transmit data in 32 Bit mode */
      hi2s->Instance->TXDR = *((const uint32_t *)hi2s->pTxBuffPtr);
      hi2s->pTxBuffPtr += 2;
      hi2s->TxXferCount--;
    }
    else
    {
      /* Transmit data in 16 Bit mode */
#if defined (__GNUC__)
      *ptxdr_16bits = *((const uint16_t *)hi2s->pTxBuffPtr);
#else
      *((__IO uint16_t *)&hi2s->Instance->TXDR) = *((const uint16_t *)hi2s->pTxBuffPtr);
#endif /* __GNUC__ */

      hi2s->pTxBuffPtr++;
      hi2s->TxXferCount--;
    }

    /* Wait until TXP flag is set */
    if (I2S_WaitFlagStateUntilTimeout(hi2s, I2S_FLAG_TXP, SET, tickstart, Timeout) != HAL_OK)
    {
      /* Set the error code */
      SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_TIMEOUT);
      hi2s->State = HAL_I2S_STATE_READY;
      __HAL_UNLOCK(hi2s);
      return HAL_TIMEOUT;
    }

    /* Check if an underrun occurs */
    if (__HAL_I2S_GET_FLAG(hi2s, I2S_FLAG_UDR) == SET)
    {
      /* Clear underrun flag */
      __HAL_I2S_CLEAR_UDRFLAG(hi2s);

      /* Set the error code */
      SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_UDR);
    }
  }

  hi2s->State = HAL_I2S_STATE_READY;
  __HAL_UNLOCK(hi2s);
  return HAL_OK;
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2S_Receive(I2S_HandleTypeDef *hi2s, uint16_t *pData, uint16_t Size, uint32_t Timeout)
{
#if defined (__GNUC__)
  __IO uint16_t *prxdr_16bits = (__IO uint16_t *)(&(hi2s->Instance->RXDR));
#endif /* __GNUC__ */
  uint32_t tickstart;

  if ((pData == NULL) || (Size == 0UL))
  {
    return  HAL_ERROR;
  }

  if (hi2s->State != HAL_I2S_STATE_READY)
  {
    return HAL_BUSY;
  }

  /* Process Locked */
  __HAL_LOCK(hi2s);

  /* Init tickstart for timeout management*/
  tickstart = HAL_GetTick();

  /* Set state and reset error code */
  hi2s->State       = HAL_I2S_STATE_BUSY_RX;
  hi2s->ErrorCode   = HAL_I2S_ERROR_NONE;
  hi2s->pRxBuffPtr  = pData;
  hi2s->RxXferSize  = Size;
  hi2s->RxXferCount = Size;

  /* Initialize fields not used in handle to zero */
  hi2s->pTxBuffPtr  = NULL;
  hi2s->TxXferSize  = (uint16_t) 0UL;
  hi2s->TxXferCount = (uint16_t) 0UL;

  /* Check if the I2S is already enabled */
  if ((hi2s->Instance->CR1 & SPI_CR1_SPE) != SPI_CR1_SPE)
  {
    /* Enable I2S peripheral */
    __HAL_I2S_ENABLE(hi2s);
  }

  /* Start the transfer */
  SET_BIT(hi2s->Instance->CR1, SPI_CR1_CSTART);

  /* Receive data */
  while (hi2s->RxXferCount > 0UL)
  {
    /* Wait until RXP flag is set */
    if (I2S_WaitFlagStateUntilTimeout(hi2s, I2S_FLAG_RXP, SET, tickstart, Timeout) != HAL_OK)
    {
      /* Set the error code */
      SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_TIMEOUT);
      hi2s->State = HAL_I2S_STATE_READY;
      __HAL_UNLOCK(hi2s);
      return HAL_TIMEOUT;
    }

    if ((hi2s->Init.DataFormat == I2S_DATAFORMAT_24B) || (hi2s->Init.DataFormat == I2S_DATAFORMAT_32B))
    {
      /* Receive data in 32 Bit mode */
      *((uint32_t *)hi2s->pRxBuffPtr) = hi2s->Instance->RXDR;
      hi2s->pRxBuffPtr += 2;
      hi2s->RxXferCount--;
    }
    else
    {
      /* Receive data in 16 Bit mode */
#if defined (__GNUC__)
      *((uint16_t *)hi2s->pRxBuffPtr) = *prxdr_16bits;
#else
      *((uint16_t *)hi2s->pRxBuffPtr) = *((__IO uint16_t *)&hi2s->Instance->RXDR);
#endif /* __GNUC__ */
      hi2s->pRxBuffPtr++;
      hi2s->RxXferCount--;
    }

    /* Check if an overrun occurs */
    if (__HAL_I2S_GET_FLAG(hi2s, I2S_FLAG_OVR) == SET)
    {
      /* Clear overrun flag */
      __HAL_I2S_CLEAR_OVRFLAG(hi2s);

      /* Set the error code */
      SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_OVR);
    }
  }

  hi2s->State = HAL_I2S_STATE_READY;
  __HAL_UNLOCK(hi2s);
  return HAL_OK;
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2SEx_TransmitReceive(I2S_HandleTypeDef *hi2s, const uint16_t *pTxData, uint16_t *pRxData,
                                            uint16_t Size, uint32_t Timeout)
{
  uint32_t tmp_TxXferCount;
  uint32_t tmp_RxXferCount;
  uint32_t tickstart;

#if defined (__GNUC__)
  __IO uint16_t *ptxdr_16bits = (__IO uint16_t *)(&(hi2s->Instance->TXDR));
  __IO uint16_t *prxdr_16bits = (__IO uint16_t *)(&(hi2s->Instance->RXDR));
#endif /* __GNUC__ */

  if ((pTxData == NULL) || (pRxData == NULL) || (Size == 0U))
  {
    return  HAL_ERROR;
  }

  if (hi2s->State != HAL_I2S_STATE_READY)
  {
    return HAL_BUSY;
  }

  /* Process Locked */
  __HAL_LOCK(hi2s);

  /* Init tickstart for timeout management*/
  tickstart = HAL_GetTick();

  hi2s->TxXferSize  = Size;
  hi2s->TxXferCount = Size;
  hi2s->pTxBuffPtr  = (const uint16_t *)pTxData;
  hi2s->RxXferSize  = Size;
  hi2s->RxXferCount = Size;
  hi2s->pRxBuffPtr  = pRxData;

  tmp_TxXferCount = hi2s->TxXferCount;
  tmp_RxXferCount = hi2s->RxXferCount;

  /* Set state and reset error code */
  hi2s->ErrorCode = HAL_I2S_ERROR_NONE;
  hi2s->State = HAL_I2S_STATE_BUSY_TX_RX;

  /* Check if the I2S is already enabled */
  if ((hi2s->Instance->CR1 & SPI_CR1_SPE) != SPI_CR1_SPE)
  {
    /* Enable I2S peripheral */
    __HAL_I2S_ENABLE(hi2s);
  }

  /* Start the transfer */
  SET_BIT(hi2s->Instance->CR1, SPI_CR1_CSTART);

  while ((tmp_TxXferCount > 0UL) || (tmp_RxXferCount > 0UL))
  {
    if ((__HAL_I2S_GET_FLAG(hi2s, I2S_FLAG_TXP) == SET) && (tmp_TxXferCount != 0UL))
    {
      if ((hi2s->Init.DataFormat == I2S_DATAFORMAT_24B) || (hi2s->Init.DataFormat == I2S_DATAFORMAT_32B))
      {
        /* Transmit data in 32 Bit mode */
        hi2s->Instance->TXDR = *((const uint32_t *)hi2s->pTxBuffPtr);
        hi2s->pTxBuffPtr += 2;
        tmp_TxXferCount--;
      }
      else
      {
        /* Transmit data in 16 Bit mode */
#if defined (__GNUC__)
        *ptxdr_16bits = *((const uint16_t *)hi2s->pTxBuffPtr);
#else
        *((__IO uint16_t *)&hi2s->Instance->TXDR) = *((const uint16_t *)hi2s->pTxBuffPtr);
#endif /* __GNUC__ */

        hi2s->pTxBuffPtr++;
        tmp_TxXferCount--;
      }

      /* Check if an underrun occurs */
      if (__HAL_I2S_GET_FLAG(hi2s, I2S_FLAG_UDR) == SET)
      {
        /* Clear underrun flag */
        __HAL_I2S_CLEAR_UDRFLAG(hi2s);

        /* Set the error code */
        SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_UDR);
      }
    }

    if ((__HAL_I2S_GET_FLAG(hi2s, I2S_FLAG_RXP) == SET) && (tmp_RxXferCount != 0UL))
    {
      if ((hi2s->Init.DataFormat == I2S_DATAFORMAT_24B) || (hi2s->Init.DataFormat == I2S_DATAFORMAT_32B))
      {
        /* Receive data in 32 Bit mode */
        *((uint32_t *)hi2s->pRxBuffPtr) = hi2s->Instance->RXDR;
        hi2s->pRxBuffPtr += 2;
        tmp_RxXferCount--;
      }
      else
      {
        /* Receive data in 16 Bit mode */
#if defined (__GNUC__)
        *((uint16_t *)hi2s->pRxBuffPtr) = *prxdr_16bits;
#else
        *((uint16_t *)hi2s->pRxBuffPtr) = *((__IO uint16_t *)&hi2s->Instance->RXDR);
#endif /* __GNUC__ */
        hi2s->pRxBuffPtr++;
        tmp_RxXferCount--;
      }

      /* Check if an overrun occurs */
      if (__HAL_I2S_GET_FLAG(hi2s, I2S_FLAG_OVR) == SET)
      {
        /* Clear overrun flag */
        __HAL_I2S_CLEAR_OVRFLAG(hi2s);

        /* Set the error code */
        SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_OVR);
      }
    }

    /* Timeout management */
    if ((((HAL_GetTick() - tickstart) >=  Timeout) && (Timeout != HAL_MAX_DELAY)) || (Timeout == 0U))
    {
      /* Set the error code */
      SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_TIMEOUT);
      hi2s->State = HAL_I2S_STATE_READY;
      __HAL_UNLOCK(hi2s);
      return HAL_TIMEOUT;
    }
  }

  hi2s->State = HAL_I2S_STATE_READY;
  __HAL_UNLOCK(hi2s);
  return HAL_OK;
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2S_Transmit_IT(I2S_HandleTypeDef *hi2s, const uint16_t *pData, uint16_t Size)
{
  if ((pData == NULL) || (Size == 0UL))
  {
    return  HAL_ERROR;
  }

  if (hi2s->State != HAL_I2S_STATE_READY)
  {
    return HAL_BUSY;
  }

  /* Process Locked */
  __HAL_LOCK(hi2s);

  /* Set state and reset error code */
  hi2s->State       = HAL_I2S_STATE_BUSY_TX;
  hi2s->ErrorCode   = HAL_I2S_ERROR_NONE;
  hi2s->pTxBuffPtr  = (const uint16_t *)pData;
  hi2s->TxXferSize  = Size;
  hi2s->TxXferCount = Size;

  /* Initialize fields not used in handle to zero */
  hi2s->pRxBuffPtr  = NULL;
  hi2s->RxXferSize  = (uint16_t) 0UL;
  hi2s->RxXferCount = (uint16_t) 0UL;

  /* Set the function for IT treatment */
  if ((hi2s->Init.DataFormat == I2S_DATAFORMAT_24B) || (hi2s->Init.DataFormat == I2S_DATAFORMAT_32B))
  {
    hi2s->TxISR = I2S_Transmit_32Bit_IT;
  }
  else
  {
    hi2s->TxISR = I2S_Transmit_16Bit_IT;
  }

  /* Check if the I2S is already enabled */
  if ((hi2s->Instance->CR1 & SPI_CR1_SPE) != SPI_CR1_SPE)
  {
    /* Enable I2S peripheral */
    __HAL_I2S_ENABLE(hi2s);
  }

  /* Enable TXP and UDR interrupt */
  __HAL_I2S_ENABLE_IT(hi2s, (I2S_IT_TXP | I2S_IT_UDR));

  /* Enable TIFRE interrupt if the mode is Slave  */
  if (hi2s->Init.Mode == I2S_MODE_SLAVE_TX)
  {
    __HAL_I2S_ENABLE_IT(hi2s, I2S_IT_FRE);
  }

  /* Start the transfer */
  SET_BIT(hi2s->Instance->CR1, SPI_CR1_CSTART);

  __HAL_UNLOCK(hi2s);
  return HAL_OK;
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2S_Receive_IT(I2S_HandleTypeDef *hi2s, uint16_t *pData, uint16_t Size)
{
  if ((pData == NULL) || (Size == 0UL))
  {
    return  HAL_ERROR;
  }

  if (hi2s->State != HAL_I2S_STATE_READY)
  {
    return HAL_BUSY;
  }

  /* Process Locked */
  __HAL_LOCK(hi2s);

  /* Set state and reset error code */
  hi2s->State       = HAL_I2S_STATE_BUSY_RX;
  hi2s->ErrorCode   = HAL_I2S_ERROR_NONE;
  hi2s->pRxBuffPtr  = pData;
  hi2s->RxXferSize  = Size;
  hi2s->RxXferCount = Size;

  /* Initialize fields not used in handle to zero */
  hi2s->pTxBuffPtr  = NULL;
  hi2s->TxXferSize  = (uint16_t) 0UL;
  hi2s->TxXferCount = (uint16_t) 0UL;

  /* Set the function for IT treatment */
  if ((hi2s->Init.DataFormat == I2S_DATAFORMAT_24B) || (hi2s->Init.DataFormat == I2S_DATAFORMAT_32B))
  {
    hi2s->RxISR = I2S_Receive_32Bit_IT;
  }
  else
  {
    hi2s->RxISR = I2S_Receive_16Bit_IT;
  }

  /* Check if the I2S is already enabled */
  if ((hi2s->Instance->CR1 & SPI_CR1_SPE) != SPI_CR1_SPE)
  {
    /* Enable I2S peripheral */
    __HAL_I2S_ENABLE(hi2s);
  }
  /* Enable RXP and ERR interrupt */
  __HAL_I2S_ENABLE_IT(hi2s, (I2S_IT_RXP | I2S_IT_OVR));

  /* Enable TIFRE interrupt if the mode is Slave  */
  if (hi2s->Init.Mode == I2S_MODE_SLAVE_RX)
  {
    __HAL_I2S_ENABLE_IT(hi2s, I2S_IT_FRE);
  }

  /* Start the transfer */
  SET_BIT(hi2s->Instance->CR1, SPI_CR1_CSTART);

  __HAL_UNLOCK(hi2s);
  return HAL_OK;
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2SEx_TransmitReceive_IT(I2S_HandleTypeDef *hi2s, const uint16_t *pTxData, uint16_t *pRxData,
                                               uint16_t Size)
{
  if ((pTxData == NULL) || (pRxData == NULL) || (Size == 0U))
  {
    return  HAL_ERROR;
  }

  if (hi2s->State != HAL_I2S_STATE_READY)
  {
    return HAL_BUSY;
  }

  /* Process Locked */
  __HAL_LOCK(hi2s);

  hi2s->pTxBuffPtr  = (const uint16_t *)pTxData;
  hi2s->pRxBuffPtr  = pRxData;

  hi2s->TxXferSize  = Size;
  hi2s->TxXferCount = Size;
  hi2s->RxXferSize  = Size;
  hi2s->RxXferCount = Size;

  hi2s->ErrorCode = HAL_I2S_ERROR_NONE;
  hi2s->State     = HAL_I2S_STATE_BUSY_TX_RX;


  /* Set the function for IT treatment */
  if ((hi2s->Init.DataFormat == I2S_DATAFORMAT_24B) || (hi2s->Init.DataFormat == I2S_DATAFORMAT_32B))
  {
    hi2s->TxISR = I2S_Transmit_32Bit_IT;
    hi2s->RxISR = I2S_Receive_32Bit_IT;
  }
  else
  {
    hi2s->TxISR = I2S_Transmit_16Bit_IT;
    hi2s->RxISR = I2S_Receive_16Bit_IT;
  }

  /* Check if the I2S is already enabled */
  if ((hi2s->Instance->CR1 & SPI_CR1_SPE) != SPI_CR1_SPE)
  {
    /* Enable I2S peripheral */
    __HAL_I2S_ENABLE(hi2s);
  }

  /* Enable TXP, RXP, DXP, UDR, OVR interrupts */
  __HAL_I2S_ENABLE_IT(hi2s, (I2S_IT_TXP | I2S_IT_RXP | I2S_IT_DXP | I2S_IT_UDR | I2S_IT_OVR));

  /* Enable TIFRE interrupt if the mode is Slave  */
  if (hi2s->Init.Mode == I2S_MODE_SLAVE_FULLDUPLEX)
  {
    __HAL_I2S_ENABLE_IT(hi2s, I2S_IT_FRE);
  }

  /* Start the transfer */
  SET_BIT(hi2s->Instance->CR1, SPI_CR1_CSTART);

  __HAL_UNLOCK(hi2s);
  return HAL_OK;

}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2S_Transmit_DMA(I2S_HandleTypeDef *hi2s, const uint16_t *pData, uint16_t Size)
{
  HAL_StatusTypeDef errorcode;

  if ((pData == NULL) || (Size == 0UL))
  {
    return  HAL_ERROR;
  }

  if (hi2s->State != HAL_I2S_STATE_READY)
  {
    return HAL_BUSY;
  }

  /* Process Locked */
  __HAL_LOCK(hi2s);

  /* Set state and reset error code */
  hi2s->State       = HAL_I2S_STATE_BUSY_TX;
  hi2s->ErrorCode   = HAL_I2S_ERROR_NONE;
  hi2s->pTxBuffPtr  = (const uint16_t *)pData;
  hi2s->TxXferSize  = Size;
  hi2s->TxXferCount = Size;

  /* Init field not used in handle to zero */
  hi2s->pRxBuffPtr  = NULL;
  hi2s->RxXferSize  = (uint16_t)0UL;
  hi2s->RxXferCount = (uint16_t)0UL;

  /* Set the I2S Tx DMA Half transfer complete callback */
  hi2s->hdmatx->XferHalfCpltCallback = I2S_DMATxHalfCplt;

  /* Set the I2S Tx DMA transfer complete callback */
  hi2s->hdmatx->XferCpltCallback = I2S_DMATxCplt;

  /* Set the DMA error callback */
  hi2s->hdmatx->XferErrorCallback = I2S_DMAError;

  if ((hi2s->Init.DataFormat == I2S_DATAFORMAT_16B) || (hi2s->Init.DataFormat == I2S_DATAFORMAT_16B_EXTENDED))
  {
    hi2s->TxXferCount = Size * 2U;
  }
  else
  {
    hi2s->TxXferCount = Size * 4U;
  }

  /* Enable the Tx DMA Stream/Channel */
  if ((hi2s->hdmatx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
  {
    if (hi2s->hdmatx->LinkedListQueue != NULL)
    {
      /* Set DMA data size */
      hi2s->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = hi2s->TxXferCount;

      /* Set DMA source address */
      hi2s->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = (uint32_t)hi2s->pTxBuffPtr;

      /* Set DMA destination address */
      hi2s->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = (uint32_t)&hi2s->Instance->TXDR;

      errorcode = HAL_DMAEx_List_Start_IT(hi2s->hdmatx);
    }
    else
    {
      /* Update SPI error code */
      SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_DMA);

      /* Unlock the process */
      __HAL_UNLOCK(hi2s);

      hi2s->State = HAL_I2S_STATE_READY;
      errorcode = HAL_ERROR;
      return errorcode;
    }
  }
  else
  {
    errorcode = HAL_DMA_Start_IT(hi2s->hdmatx, (uint32_t)hi2s->pTxBuffPtr, (uint32_t)&hi2s->Instance->TXDR,
                                 hi2s->TxXferCount);
  }

  /* Check status */
  if (errorcode != HAL_OK)
  {
    /* Update I2S error code */
    SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_DMA);
    hi2s->State = HAL_I2S_STATE_READY;

    __HAL_UNLOCK(hi2s);
    errorcode = HAL_ERROR;
    return errorcode;
  }

  /* Check if the I2S Tx request is already enabled */
  if (HAL_IS_BIT_CLR(hi2s->Instance->CFG1, SPI_CFG1_TXDMAEN))
  {
    /* Enable Tx DMA Request */
    SET_BIT(hi2s->Instance->CFG1, SPI_CFG1_TXDMAEN);
  }

  /* Check if the I2S is already enabled */
  if (HAL_IS_BIT_CLR(hi2s->Instance->CR1, SPI_CR1_SPE))
  {
    /* Enable I2S peripheral */
    __HAL_I2S_ENABLE(hi2s);
  }

  /* Start the transfer */
  SET_BIT(hi2s->Instance->CR1, SPI_CR1_CSTART);

  __HAL_UNLOCK(hi2s);
  return errorcode;
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2S_Receive_DMA(I2S_HandleTypeDef *hi2s, uint16_t *pData, uint16_t Size)
{
  HAL_StatusTypeDef errorcode;

  if ((pData == NULL) || (Size == 0UL))
  {
    return HAL_ERROR;
  }

  if (hi2s->State != HAL_I2S_STATE_READY)
  {
    return HAL_BUSY;
  }

  /* Process Locked */
  __HAL_LOCK(hi2s);

  /* Set state and reset error code */
  hi2s->State       = HAL_I2S_STATE_BUSY_RX;
  hi2s->ErrorCode   = HAL_I2S_ERROR_NONE;
  hi2s->pRxBuffPtr  = pData;
  hi2s->RxXferSize  = Size;
  hi2s->RxXferCount = Size;

  /* Init field not used in handle to zero */
  hi2s->pTxBuffPtr  = NULL;
  hi2s->TxXferSize  = (uint16_t)0UL;
  hi2s->TxXferCount = (uint16_t)0UL;


  /* Set the I2S Rx DMA Half transfer complete callback */
  hi2s->hdmarx->XferHalfCpltCallback = I2S_DMARxHalfCplt;

  /* Set the I2S Rx DMA transfer complete callback */
  hi2s->hdmarx->XferCpltCallback = I2S_DMARxCplt;

  /* Set the DMA error callback */
  hi2s->hdmarx->XferErrorCallback = I2S_DMAError;

  if ((hi2s->Init.DataFormat == I2S_DATAFORMAT_16B) || (hi2s->Init.DataFormat == I2S_DATAFORMAT_16B_EXTENDED))
  {
    hi2s->RxXferCount = Size * 2U;
  }
  else
  {
    hi2s->RxXferCount = Size * 4U;
  }

  /* Enable the Rx DMA Stream/Channel */
  if ((hi2s->hdmarx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
  {
    if (hi2s->hdmarx->LinkedListQueue != NULL)
    {
      /* Set DMA data size */
      hi2s->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = hi2s->RxXferCount;

      /* Set DMA source address */
      hi2s->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = (uint32_t)&hi2s->Instance->RXDR;

      /* Set DMA destination address */
      hi2s->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = (uint32_t)hi2s->pRxBuffPtr;

      errorcode = HAL_DMAEx_List_Start_IT(hi2s->hdmarx);
    }
    else
    {
      /* Update SPI error code */
      SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_DMA);

      /* Unlock the process */
      __HAL_UNLOCK(hi2s);

      hi2s->State = HAL_I2S_STATE_READY;
      errorcode = HAL_ERROR;
      return errorcode;
    }
  }
  else
  {
    errorcode = HAL_DMA_Start_IT(hi2s->hdmarx, (uint32_t)&hi2s->Instance->RXDR, (uint32_t)hi2s->pRxBuffPtr,
                                 hi2s->RxXferCount);
  }

  /* Check status */
  if (errorcode != HAL_OK)
  {
    /* Update I2S error code */
    SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_DMA);
    hi2s->State = HAL_I2S_STATE_READY;
    errorcode = HAL_ERROR;
    __HAL_UNLOCK(hi2s);
    return errorcode;
  }

  /* Check if the I2S Rx request is already enabled */
  if (HAL_IS_BIT_CLR(hi2s->Instance->CFG1, SPI_CFG1_RXDMAEN))
  {
    /* Enable Rx DMA Request */
    SET_BIT(hi2s->Instance->CFG1, SPI_CFG1_RXDMAEN);
  }

  /* Check if the I2S is already enabled */
  if (HAL_IS_BIT_CLR(hi2s->Instance->CR1, SPI_CR1_SPE))
  {
    /* Enable I2S peripheral */
    __HAL_I2S_ENABLE(hi2s);
  }

  /* Start the transfer */
  SET_BIT(hi2s->Instance->CR1, SPI_CR1_CSTART);

  __HAL_UNLOCK(hi2s);
  return errorcode;
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2SEx_TransmitReceive_DMA(I2S_HandleTypeDef *hi2s, const uint16_t *pTxData, uint16_t *pRxData,
                                                uint16_t Size)
{
  HAL_StatusTypeDef errorcode;


  if ((pTxData == NULL) || (pRxData == NULL) || (Size == 0U))
  {
    return  HAL_ERROR;
  }

  if (hi2s->State != HAL_I2S_STATE_READY)
  {
    return HAL_BUSY;
  }

  /* Process Locked */
  __HAL_LOCK(hi2s);

  hi2s->pTxBuffPtr = (const uint16_t *)pTxData;
  hi2s->pRxBuffPtr = pRxData;

  hi2s->TxXferSize  = Size;
  hi2s->TxXferCount = Size;
  hi2s->RxXferSize  = Size;
  hi2s->RxXferCount = Size;

  hi2s->ErrorCode   = HAL_I2S_ERROR_NONE;
  hi2s->State       = HAL_I2S_STATE_BUSY_TX_RX;

  /* Reset the Tx/Rx DMA bits */
  CLEAR_BIT(hi2s->Instance->CFG1, SPI_CFG1_TXDMAEN | SPI_CFG1_RXDMAEN);

  /* Set the I2S Rx DMA Half transfer complete callback */
  hi2s->hdmarx->XferHalfCpltCallback = I2SEx_DMATxRxHalfCplt;

  /* Set the I2S Rx DMA transfer complete callback */
  hi2s->hdmarx->XferCpltCallback  = I2SEx_DMATxRxCplt;

  /* Set the I2S Rx DMA error callback */
  hi2s->hdmarx->XferErrorCallback = I2S_DMAError;
  if ((hi2s->Init.DataFormat == I2S_DATAFORMAT_16B) || (hi2s->Init.DataFormat == I2S_DATAFORMAT_16B_EXTENDED))
  {
    hi2s->TxXferCount = Size * 2U;
  }
  else
  {
    hi2s->TxXferCount = Size * 4U;
  }

  /* Enable the Tx DMA Stream/Channel */
  if ((hi2s->hdmatx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
  {
    if (hi2s->hdmatx->LinkedListQueue != NULL)
    {
      /* Set DMA data size */
      hi2s->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = hi2s->TxXferCount;

      /* Set DMA source address */
      hi2s->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = (uint32_t)hi2s->pTxBuffPtr;

      /* Set DMA destination address */
      hi2s->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = (uint32_t)&hi2s->Instance->TXDR;

      errorcode = HAL_DMAEx_List_Start_IT(hi2s->hdmatx);
    }
    else
    {
      /* Update SPI error code */
      SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_DMA);

      /* Unlock the process */
      __HAL_UNLOCK(hi2s);

      hi2s->State = HAL_I2S_STATE_READY;
      errorcode = HAL_ERROR;
      return errorcode;
    }
  }
  else
  {
    errorcode = HAL_DMA_Start_IT(hi2s->hdmatx, (uint32_t)hi2s->pTxBuffPtr, (uint32_t)&hi2s->Instance->TXDR,
                                 hi2s->TxXferCount);
  }

  /* Check status */
  if (errorcode != HAL_OK)
  {
    /* Update I2S error code */
    SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_DMA);
    hi2s->State = HAL_I2S_STATE_READY;

    __HAL_UNLOCK(hi2s);
    errorcode = HAL_ERROR;
    return errorcode;
  }

  /* Check if the I2S Tx request is already enabled */
  if (HAL_IS_BIT_CLR(hi2s->Instance->CFG1, SPI_CFG1_TXDMAEN))
  {
    /* Enable Tx DMA Request */
    SET_BIT(hi2s->Instance->CFG1, SPI_CFG1_TXDMAEN);
  }

  if ((hi2s->Init.DataFormat == I2S_DATAFORMAT_16B) || (hi2s->Init.DataFormat == I2S_DATAFORMAT_16B_EXTENDED))
  {
    hi2s->RxXferCount = Size * 2U;
  }
  else
  {
    hi2s->RxXferCount = Size * 4U;
  }

  /* Enable the Rx DMA Stream/Channel */
  if ((hi2s->hdmarx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
  {
    if (hi2s->hdmarx->LinkedListQueue != NULL)
    {
      /* Set DMA data size */
      hi2s->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = hi2s->RxXferCount;

      /* Set DMA source address */
      hi2s->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = (uint32_t)&hi2s->Instance->RXDR;

      /* Set DMA destination address */
      hi2s->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = (uint32_t)hi2s->pRxBuffPtr;

      errorcode = HAL_DMAEx_List_Start_IT(hi2s->hdmarx);
    }
    else
    {
      /* Update SPI error code */
      SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_DMA);

      /* Unlock the process */
      __HAL_UNLOCK(hi2s);

      hi2s->State = HAL_I2S_STATE_READY;
      errorcode = HAL_ERROR;
      return errorcode;
    }
  }
  else
  {
    errorcode = HAL_DMA_Start_IT(hi2s->hdmarx, (uint32_t)&hi2s->Instance->RXDR, (uint32_t)hi2s->pRxBuffPtr,
                                 hi2s->RxXferCount);
  }

  /* Check status */
  if (errorcode != HAL_OK)
  {
    /* Update I2S error code */
    SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_DMA);
    hi2s->State = HAL_I2S_STATE_READY;
    errorcode = HAL_ERROR;
    __HAL_UNLOCK(hi2s);
    return errorcode;
  }

  /* Check if the I2S Rx request is already enabled */
  if (HAL_IS_BIT_CLR(hi2s->Instance->CFG1, SPI_CFG1_RXDMAEN))
  {
    /* Enable Rx DMA Request */
    SET_BIT(hi2s->Instance->CFG1, SPI_CFG1_RXDMAEN);
  }

  /* Check if the I2S is already enabled */
  if (HAL_IS_BIT_CLR(hi2s->Instance->CR1, SPI_CR1_SPE))
  {
    /* Enable I2S peripheral */
    __HAL_I2S_ENABLE(hi2s);
  }

  /* Start the transfer */
  SET_BIT(hi2s->Instance->CR1, SPI_CR1_CSTART);

  __HAL_UNLOCK(hi2s);
  return errorcode;
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2S_DMAPause(I2S_HandleTypeDef *hi2s)
{
  /* Process Locked */
  __HAL_LOCK(hi2s);

  uint32_t tickstart;

  /* Get tick */
  tickstart = HAL_GetTick();


  /* Check if the I2S peripheral is in master mode */
  if (IS_I2S_MASTER(hi2s->Init.Mode))
  {
    /* Check if there is a transfer on-going */
    if (HAL_IS_BIT_SET(hi2s->Instance->CR1, SPI_CR1_CSTART) == 0UL)
    {
      /* Set error code to no on going transfer */
      SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_NO_OGT);
      hi2s->State = HAL_I2S_STATE_READY;

      __HAL_UNLOCK(hi2s);
      return HAL_ERROR;
    }

    SET_BIT(hi2s->Instance->CR1, SPI_CR1_CSUSP);

    while (HAL_IS_BIT_SET(hi2s->Instance->CR1, SPI_CR1_CSTART) != 0UL)
    {
      if ((((HAL_GetTick() - tickstart) >=  I2S_TIMEOUT) && (I2S_TIMEOUT != HAL_MAX_DELAY)) || (I2S_TIMEOUT == 0U))
      {
        /* Set the I2S State ready */
        hi2s->State = HAL_I2S_STATE_READY;

        /* Process Unlocked */
        __HAL_UNLOCK(hi2s);

        SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_TIMEOUT);
        hi2s->State = HAL_I2S_STATE_READY;
        return HAL_TIMEOUT;
      }
    }

    /* Disable I2S peripheral */
    __HAL_I2S_DISABLE(hi2s);

    hi2s->State = HAL_I2S_STATE_READY;

    /* Process Unlocked */
    __HAL_UNLOCK(hi2s);

    return HAL_OK;
  }
  else
  {
    /* Set error code to not supported */
    SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_NOT_SUPPORTED);
    hi2s->State = HAL_I2S_STATE_READY;

    /* Process Unlocked */
    __HAL_UNLOCK(hi2s);

    return HAL_ERROR;
  }
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2S_DMAResume(I2S_HandleTypeDef *hi2s)
{
  /* Process Locked */
  __HAL_LOCK(hi2s);

  if (hi2s->State != HAL_I2S_STATE_READY)
  {
    hi2s->State = HAL_I2S_STATE_READY;

    __HAL_UNLOCK(hi2s);
    return HAL_ERROR;
  }

  /* Set state and reset error code */
  hi2s->State       = HAL_I2S_STATE_BUSY;
  hi2s->ErrorCode   = HAL_I2S_ERROR_NONE;

  /* Enable I2S peripheral */
  __HAL_I2S_ENABLE(hi2s);

  /* Start the transfer */
  SET_BIT(hi2s->Instance->CR1, SPI_CR1_CSTART);

  /* Process Unlocked */
  __HAL_UNLOCK(hi2s);

  return HAL_OK;
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2S_DMAStop(I2S_HandleTypeDef *hi2s)
{
  HAL_StatusTypeDef errorcode = HAL_OK;
  /* The Lock is not implemented on this API to allow the user application
     to call the HAL I2S API under callbacks HAL_I2S_TxCpltCallback() or HAL_I2S_RxCpltCallback()
     when calling HAL_DMA_Abort() API the DMA TX or RX Transfer complete interrupt is generated
     and the correspond call back is executed HAL_I2S_TxCpltCallback() or HAL_I2S_RxCpltCallback()
     */

  /* Disable the I2S Tx/Rx DMA requests */
  CLEAR_BIT(hi2s->Instance->CFG1, SPI_CFG1_TXDMAEN);
  CLEAR_BIT(hi2s->Instance->CFG1, SPI_CFG1_RXDMAEN);

  /* Abort the I2S DMA tx Stream/Channel */
  if (hi2s->hdmatx != NULL)
  {
    /* Disable the I2S DMA tx Stream/Channel */
    if (HAL_OK != HAL_DMA_Abort(hi2s->hdmatx))
    {
      SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_DMA);
      errorcode = HAL_ERROR;
    }
  }

  /* Abort the I2S DMA rx Stream/Channel */
  if (hi2s->hdmarx != NULL)
  {
    /* Disable the I2S DMA rx Stream/Channel */
    if (HAL_OK != HAL_DMA_Abort(hi2s->hdmarx))
    {
      SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_DMA);
      errorcode = HAL_ERROR;
    }
  }

  /* Disable I2S peripheral */
  __HAL_I2S_DISABLE(hi2s);

  hi2s->State = HAL_I2S_STATE_READY;

  return errorcode;
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2S_EnableIOSwap(I2S_HandleTypeDef *hi2s)
{
  /* Check the I2S handle allocation */
  if (hi2s == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the global state */
  if (hi2s->State != HAL_I2S_STATE_READY)
  {
    return HAL_ERROR;
  }

  /* Check for IOLock */
  if (READ_BIT(hi2s->Instance->CR1, SPI_CR1_IOLOCK) == (SPI_CR1_IOLOCK))
  {
    return  HAL_ERROR;
  }

  /* Check if the I2S is already enabled */
  if ((hi2s->Instance->CR1 & SPI_CR1_SPE) == SPI_CR1_SPE)
  {
    /* Disable I2S peripheral */
    __HAL_I2S_DISABLE(hi2s);
  }

  /* Enable IO Swap feature */
  SET_BIT(hi2s->Instance->CFG2, SPI_CFG2_IOSWP);

  return HAL_OK;
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2S_DisableIOSwap(I2S_HandleTypeDef *hi2s)
{
  /* Check the I2S handle allocation */
  if (hi2s == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the global state */
  if (hi2s->State != HAL_I2S_STATE_READY)
  {
    return HAL_ERROR;
  }

  /* Check for IOLock */
  if (READ_BIT(hi2s->Instance->CR1, SPI_CR1_IOLOCK) == (SPI_CR1_IOLOCK))
  {
    return HAL_ERROR;
  }

  /* Check if the I2S is already enabled */
  if ((hi2s->Instance->CR1 & SPI_CR1_SPE) == SPI_CR1_SPE)
  {
    /* Disable I2S peripheral */
    __HAL_I2S_DISABLE(hi2s);
  }

  /* Disable the IO Swap feature */
  CLEAR_BIT(hi2s->Instance->CFG2, SPI_CFG2_IOSWP);

  return HAL_OK;
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
uint32_t HAL_I2S_IsEnabledIOSwap(const I2S_HandleTypeDef *hi2s)
{
  /* Check the I2S handle allocation */
  if (hi2s == NULL)
  {
    return 0;
  }

  return ((READ_BIT(hi2s->Instance->CFG2, SPI_CFG2_IOSWP) == (SPI_CFG2_IOSWP)) ? 1UL : 0UL);
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
void HAL_I2S_IRQHandler(I2S_HandleTypeDef *hi2s)
{
  uint32_t i2sier   = hi2s->Instance->IER;
  uint32_t i2ssr    = hi2s->Instance->SR;
  uint32_t trigger  = i2sier & i2ssr;

  if (hi2s->State == HAL_I2S_STATE_BUSY_RX)
  {
    /* I2S in mode Receiver ------------------------------------------------*/
    if (HAL_IS_BIT_SET(trigger, I2S_FLAG_RXP) && HAL_IS_BIT_CLR(trigger, I2S_FLAG_OVR))
    {
      hi2s->RxISR(hi2s);
    }

    /* I2S Overrun error interrupt occurred -------------------------------------*/
    if (HAL_IS_BIT_SET(trigger, I2S_FLAG_OVR))
    {
      /* Disable RXP and ERR interrupt */
      __HAL_I2S_DISABLE_IT(hi2s, (I2S_IT_RXP | I2S_IT_ERR));

      /* Clear Overrun flag */
      __HAL_I2S_CLEAR_OVRFLAG(hi2s);

      /* Set the I2S State ready */
      hi2s->State = HAL_I2S_STATE_READY;


      /* Set the error code and execute error callback*/
      SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_OVR);
      /* Call user error callback */
#if (USE_HAL_I2S_REGISTER_CALLBACKS == 1UL)
      hi2s->ErrorCallback(hi2s);
#else
      HAL_I2S_ErrorCallback(hi2s);
#endif /* USE_HAL_I2S_REGISTER_CALLBACKS */
    }
  }

  if (hi2s->State == HAL_I2S_STATE_BUSY_TX)
  {
    /* I2S in mode Transmitter -----------------------------------------------*/
    if (HAL_IS_BIT_SET(trigger, I2S_FLAG_TXP) && HAL_IS_BIT_CLR(trigger, I2S_FLAG_UDR))
    {
      hi2s->TxISR(hi2s);
    }

    /* I2S Underrun error interrupt occurred --------------------------------*/
    if (HAL_IS_BIT_SET(trigger, I2S_FLAG_UDR))
    {
      /* Disable TXP and ERR interrupt */
      __HAL_I2S_DISABLE_IT(hi2s, (I2S_IT_TXP | I2S_IT_ERR));

      /* Clear Underrun flag */
      __HAL_I2S_CLEAR_UDRFLAG(hi2s);

      /* Set the I2S State ready */
      hi2s->State = HAL_I2S_STATE_READY;

      /* Set the error code and execute error callback*/
      SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_UDR);
      /* Call user error callback */
#if (USE_HAL_I2S_REGISTER_CALLBACKS == 1UL)
      hi2s->ErrorCallback(hi2s);
#else
      HAL_I2S_ErrorCallback(hi2s);
#endif /* USE_HAL_I2S_REGISTER_CALLBACKS */
    }
  }
  if (hi2s->State == HAL_I2S_STATE_BUSY_TX_RX)
  {
    /* I2S in mode Transmitter -----------------------------------------------*/
    if (HAL_IS_BIT_SET(trigger, I2S_FLAG_DXP))
    {
      hi2s->TxISR(hi2s);
      hi2s->RxISR(hi2s);
    }
    /* I2S in mode Receiver ------------------------------------------------*/
    if (HAL_IS_BIT_SET(trigger, I2S_FLAG_RXP) && HAL_IS_BIT_CLR(trigger, I2S_FLAG_DXP))
    {
      hi2s->RxISR(hi2s);
    }
    /* I2S in mode Transmitter -----------------------------------------------*/
    if (HAL_IS_BIT_SET(trigger, I2S_FLAG_TXP) && HAL_IS_BIT_CLR(trigger, I2S_FLAG_DXP))
    {
      hi2s->TxISR(hi2s);
    }

    /* I2S Underrun error interrupt occurred --------------------------------*/
    if (HAL_IS_BIT_SET(trigger, I2S_FLAG_UDR))
    {
      /* Disable TXP, RXP and ERR interrupt */
      __HAL_I2S_DISABLE_IT(hi2s, (I2S_IT_TXP | I2S_IT_RXP | I2S_IT_ERR));

      /* Clear Underrun flag */
      __HAL_I2S_CLEAR_UDRFLAG(hi2s);

      /* Set the I2S State ready */
      hi2s->State = HAL_I2S_STATE_READY;

      /* Set the error code and execute error callback*/
      SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_UDR);
      /* Call user error callback */
#if (USE_HAL_I2S_REGISTER_CALLBACKS == 1UL)
      hi2s->ErrorCallback(hi2s);
#else
      HAL_I2S_ErrorCallback(hi2s);
#endif /* USE_HAL_I2S_REGISTER_CALLBACKS */
    }

    /* I2S Overrun error interrupt occurred -------------------------------------*/
    if (HAL_IS_BIT_SET(trigger, I2S_FLAG_OVR))
    {
      /* Disable TXP, RXP and ERR interrupt */
      __HAL_I2S_DISABLE_IT(hi2s, (I2S_IT_TXP | I2S_IT_RXP | I2S_IT_ERR));

      /* Clear Overrun flag */
      __HAL_I2S_CLEAR_OVRFLAG(hi2s);

      /* Set the I2S State ready */
      hi2s->State = HAL_I2S_STATE_READY;


      /* Set the error code and execute error callback*/
      SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_OVR);

      /* Call user error callback */
#if (USE_HAL_I2S_REGISTER_CALLBACKS == 1UL)
      hi2s->ErrorCallback(hi2s);
#else
      HAL_I2S_ErrorCallback(hi2s);
#endif /* USE_HAL_I2S_REGISTER_CALLBACKS */
    }
  }
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_I2S_StateTypeDef HAL_I2S_GetState(const I2S_HandleTypeDef *hi2s)
{
  return hi2s->State;
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
uint32_t HAL_I2S_GetError(const I2S_HandleTypeDef *hi2s)
{
  return hi2s->ErrorCode;
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
static void I2S_DMATxCplt(DMA_HandleTypeDef *hdma)
{
  /* Derogation MISRAC2012-Rule-11.5 */
  I2S_HandleTypeDef *hi2s = (I2S_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  /* if DMA is configured in DMA_NORMAL Mode */
  if (hdma->Init.Mode == DMA_NORMAL)
  {
    /* Disable Tx DMA Request */
    CLEAR_BIT(hi2s->Instance->CFG1, SPI_CFG1_TXDMAEN);

    hi2s->TxXferCount = (uint16_t) 0UL;
    hi2s->State = HAL_I2S_STATE_READY;
  }
  /* Call user Tx complete callback */
#if (USE_HAL_I2S_REGISTER_CALLBACKS == 1UL)
  hi2s->TxCpltCallback(hi2s);
#else
  HAL_I2S_TxCpltCallback(hi2s);
#endif /* USE_HAL_I2S_REGISTER_CALLBACKS */
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
static void I2S_DMATxHalfCplt(DMA_HandleTypeDef *hdma)
{
  /* Derogation MISRAC2012-Rule-11.5 */
  I2S_HandleTypeDef *hi2s = (I2S_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  /* Call user Tx half complete callback */
#if (USE_HAL_I2S_REGISTER_CALLBACKS == 1UL)
  hi2s->TxHalfCpltCallback(hi2s);
#else
  HAL_I2S_TxHalfCpltCallback(hi2s);
#endif /* USE_HAL_I2S_REGISTER_CALLBACKS */
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
static void I2S_DMARxCplt(DMA_HandleTypeDef *hdma)
{
  /* Derogation MISRAC2012-Rule-11.5 */
  I2S_HandleTypeDef *hi2s = (I2S_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  /* if DMA is configured in DMA_NORMAL Mode */
  if (hdma->Init.Mode == DMA_NORMAL)
  {
    /* Disable Rx DMA Request */
    CLEAR_BIT(hi2s->Instance->CFG1, SPI_CFG1_RXDMAEN);
    hi2s->RxXferCount = (uint16_t)0UL;
    hi2s->State = HAL_I2S_STATE_READY;
  }
  /* Call user Rx complete callback */
#if (USE_HAL_I2S_REGISTER_CALLBACKS == 1UL)
  hi2s->RxCpltCallback(hi2s);
#else
  HAL_I2S_RxCpltCallback(hi2s);
#endif /* USE_HAL_I2S_REGISTER_CALLBACKS */
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
static void I2S_DMARxHalfCplt(DMA_HandleTypeDef *hdma)
{
  /* Derogation MISRAC2012-Rule-11.5 */
  I2S_HandleTypeDef *hi2s = (I2S_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  /* Call user Rx half complete callback */
#if (USE_HAL_I2S_REGISTER_CALLBACKS == 1UL)
  hi2s->RxHalfCpltCallback(hi2s);
#else
  HAL_I2S_RxHalfCpltCallback(hi2s);
#endif /* USE_HAL_I2S_REGISTER_CALLBACKS */
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
static void I2SEx_DMATxRxCplt(DMA_HandleTypeDef *hdma)
{
  I2S_HandleTypeDef *hi2s = (I2S_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  /* if DMA is configured in DMA_NORMAL Mode */
  if (hdma->Init.Mode == DMA_NORMAL)
  {
    /* Disable Tx DMA Request */
    CLEAR_BIT(hi2s->Instance->CFG1, SPI_CFG1_TXDMAEN);
    hi2s->TxXferCount = (uint16_t) 0UL;

    /* Disable Rx DMA Request */
    CLEAR_BIT(hi2s->Instance->CFG1, SPI_CFG1_RXDMAEN);
    hi2s->RxXferCount = (uint16_t)0UL;

    /* Updated HAL State */
    hi2s->State = HAL_I2S_STATE_READY;
  }

  /* Call user TxRx complete callback */
#if (USE_HAL_I2S_REGISTER_CALLBACKS == 1U)
  hi2s->TxRxCpltCallback(hi2s);
#else
  HAL_I2SEx_TxRxCpltCallback(hi2s);
#endif /* USE_HAL_I2S_REGISTER_CALLBACKS */
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
static void I2SEx_DMATxRxHalfCplt(DMA_HandleTypeDef *hdma)
{
  I2S_HandleTypeDef *hi2s = (I2S_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  /* Call user TxRx Half complete callback */
#if (USE_HAL_I2S_REGISTER_CALLBACKS == 1U)
  hi2s->TxRxHalfCpltCallback(hi2s);
#else
  HAL_I2SEx_TxRxHalfCpltCallback(hi2s);
#endif /* USE_HAL_I2S_REGISTER_CALLBACKS */
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
static void I2S_DMAError(DMA_HandleTypeDef *hdma)
{
  /* Derogation MISRAC2012-Rule-11.5 */
  I2S_HandleTypeDef *hi2s = (I2S_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  /* Disable Rx and Tx DMA Request */
  CLEAR_BIT(hi2s->Instance->CFG1, (SPI_CFG1_RXDMAEN | SPI_CFG1_TXDMAEN));
  hi2s->TxXferCount = (uint16_t) 0UL;
  hi2s->RxXferCount = (uint16_t) 0UL;

  hi2s->State = HAL_I2S_STATE_READY;

  /* Set the error code and execute error callback*/
  SET_BIT(hi2s->ErrorCode, HAL_I2S_ERROR_DMA);
  /* Call user error callback */
#if (USE_HAL_I2S_REGISTER_CALLBACKS == 1UL)
  hi2s->ErrorCallback(hi2s);
#else
  HAL_I2S_ErrorCallback(hi2s);
#endif /* USE_HAL_I2S_REGISTER_CALLBACKS */
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
static void I2S_Transmit_16Bit_IT(I2S_HandleTypeDef *hi2s)
{
  /* Transmit data */
#if defined (__GNUC__)
  __IO uint16_t *ptxdr_16bits = (__IO uint16_t *)(&(hi2s->Instance->TXDR));

  *ptxdr_16bits = *((const uint16_t *)hi2s->pTxBuffPtr);
#else
  *((__IO uint16_t *)&hi2s->Instance->TXDR) = *((const uint16_t *)hi2s->pTxBuffPtr);
#endif /* __GNUC__ */
  hi2s->pTxBuffPtr++;
  hi2s->TxXferCount--;

  if (hi2s->TxXferCount == 0UL)
  {
    /* Disable TXP and ERR interrupt */
    __HAL_I2S_DISABLE_IT(hi2s, (I2S_IT_TXP | I2S_IT_ERR));

    if ((hi2s->Init.Mode == I2S_MODE_SLAVE_TX) || (hi2s->Init.Mode == I2S_MODE_MASTER_TX))
    {
      hi2s->State = HAL_I2S_STATE_READY;

      /* Call user Tx complete callback */
#if (USE_HAL_I2S_REGISTER_CALLBACKS == 1UL)
      hi2s->TxCpltCallback(hi2s);
#else
      HAL_I2S_TxCpltCallback(hi2s);
#endif /* USE_HAL_I2S_REGISTER_CALLBACKS */
    }
  }
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
static void I2S_Transmit_32Bit_IT(I2S_HandleTypeDef *hi2s)
{
  /* Transmit data */
  hi2s->Instance->TXDR = *((const uint32_t *)hi2s->pTxBuffPtr);
  hi2s->pTxBuffPtr += 2;
  hi2s->TxXferCount--;

  if (hi2s->TxXferCount == 0UL)
  {
    /* Disable TXP and ERR interrupt */
    __HAL_I2S_DISABLE_IT(hi2s, (I2S_IT_TXP | I2S_IT_ERR));

    if ((hi2s->Init.Mode == I2S_MODE_SLAVE_TX) || (hi2s->Init.Mode == I2S_MODE_MASTER_TX))
    {
      hi2s->State = HAL_I2S_STATE_READY;

      /* Call user Tx complete callback */
#if (USE_HAL_I2S_REGISTER_CALLBACKS == 1UL)
      hi2s->TxCpltCallback(hi2s);
#else
      HAL_I2S_TxCpltCallback(hi2s);
#endif /* USE_HAL_I2S_REGISTER_CALLBACKS */
    }
  }
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
static void I2S_Receive_16Bit_IT(I2S_HandleTypeDef *hi2s)
{
  /* Receive data */
#if defined (__GNUC__)
  __IO uint16_t *prxdr_16bits = (__IO uint16_t *)(&(hi2s->Instance->RXDR));

  *((uint16_t *)hi2s->pRxBuffPtr) = *prxdr_16bits;
#else
  *((uint16_t *)hi2s->pRxBuffPtr) = *((__IO uint16_t *)&hi2s->Instance->RXDR);
#endif /* __GNUC__ */
  hi2s->pRxBuffPtr++;
  hi2s->RxXferCount--;

  if (hi2s->RxXferCount == 0UL)
  {
    if (IS_I2S_FULLDUPLEX(hi2s->Init.Mode))
    {
      /* Disable TXP, RXP, DXP, ERR interrupts */
      __HAL_I2S_DISABLE_IT(hi2s, (I2S_IT_TXP | I2S_IT_RXP | I2S_IT_DXP | I2S_IT_ERR));
    }
    else
    {
      /* Disable RXP and ERR interrupt */
      __HAL_I2S_DISABLE_IT(hi2s, (I2S_IT_RXP | I2S_IT_ERR));
    }

    hi2s->State = HAL_I2S_STATE_READY;
    /* Call user Rx complete callback */
#if (USE_HAL_I2S_REGISTER_CALLBACKS == 1UL)
    if (IS_I2S_FULLDUPLEX(hi2s->Init.Mode))
    {
      hi2s->TxRxCpltCallback(hi2s);
    }
    else
    {
      hi2s->RxCpltCallback(hi2s);
    }
#else
    if (IS_I2S_FULLDUPLEX(hi2s->Init.Mode))
    {
      HAL_I2SEx_TxRxCpltCallback(hi2s);
    }
    else
    {
      HAL_I2S_RxCpltCallback(hi2s);
    }
#endif /* USE_HAL_I2S_REGISTER_CALLBACKS */
  }
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
static void I2S_Receive_32Bit_IT(I2S_HandleTypeDef *hi2s)
{
  /* Receive data */
  *((uint32_t *)hi2s->pRxBuffPtr) = hi2s->Instance->RXDR;
  hi2s->pRxBuffPtr += 2;
  hi2s->RxXferCount--;

  if (hi2s->RxXferCount == 0UL)
  {
    if (IS_I2S_FULLDUPLEX(hi2s->Init.Mode))
    {
      /* Disable TXP, RXP, DXP, ERR interrupts */
      __HAL_I2S_DISABLE_IT(hi2s, (I2S_IT_TXP | I2S_IT_RXP | I2S_IT_DXP | I2S_IT_ERR));
    }
    else
    {
      /* Disable RXP and ERR interrupt */
      __HAL_I2S_DISABLE_IT(hi2s, (I2S_IT_RXP | I2S_IT_ERR));
    }

    hi2s->State = HAL_I2S_STATE_READY;
    /* Call user Rx complete callback */
#if (USE_HAL_I2S_REGISTER_CALLBACKS == 1UL)
    if (IS_I2S_FULLDUPLEX(hi2s->Init.Mode))
    {
      hi2s->TxRxCpltCallback(hi2s);
    }
    else
    {
      hi2s->RxCpltCallback(hi2s);
    }
#else
    if (IS_I2S_FULLDUPLEX(hi2s->Init.Mode))
    {
      HAL_I2SEx_TxRxCpltCallback(hi2s);
    }
    else
    {
      HAL_I2S_RxCpltCallback(hi2s);
    }
#endif /* USE_HAL_I2S_REGISTER_CALLBACKS */
  }
}
#endif

#ifdef HAL_I2S_MODULE_ENABLED
static HAL_StatusTypeDef I2S_WaitFlagStateUntilTimeout(I2S_HandleTypeDef *hi2s, uint32_t Flag, FlagStatus State,
                                                       uint32_t Tickstart, uint32_t Timeout)
{
  /* Wait until flag is set to status*/
  while (((__HAL_I2S_GET_FLAG(hi2s, Flag)) ? SET : RESET) != State)
  {
    if (Timeout != HAL_MAX_DELAY)
    {
      if (((HAL_GetTick() - Tickstart) >= Timeout) || (Timeout == 0UL))
      {
        /* Set the I2S State ready */
        hi2s->State = HAL_I2S_STATE_READY;

        /* Process Unlocked */
        __HAL_UNLOCK(hi2s);

        return HAL_TIMEOUT;
      }
    }
  }
  return HAL_OK;
}
#endif
