// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2S and SAI/SAIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_InitProtocol(SAI_HandleTypeDef *hsai, uint32_t protocol, uint32_t datasize, uint32_t nbslot)
{
  HAL_StatusTypeDef status;

  /* Check the parameters */
  assert_param(IS_SAI_SUPPORTED_PROTOCOL(protocol));
  assert_param(IS_SAI_PROTOCOL_DATASIZE(datasize));

  switch (protocol)
  {
    case SAI_I2S_STANDARD :
    case SAI_I2S_MSBJUSTIFIED :
    case SAI_I2S_LSBJUSTIFIED :
      status = SAI_InitI2S(hsai, protocol, datasize, nbslot);
      break;
    case SAI_PCM_LONG :
    case SAI_PCM_SHORT :
      status = SAI_InitPCM(hsai, protocol, datasize, nbslot);
      break;
    default :
      status = HAL_ERROR;
      break;
  }

  if (status == HAL_OK)
  {
    status = HAL_SAI_Init(hsai);
  }

  return status;
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_Init(SAI_HandleTypeDef *hsai)
{
  uint32_t tmpregisterGCR;
  uint32_t ckstr_bits;
  uint32_t syncen_bits;

  /* Check the SAI handle allocation */
  if (hsai == NULL)
  {
    return HAL_ERROR;
  }

  /* check the instance */
  assert_param(IS_SAI_ALL_INSTANCE(hsai->Instance));

  /* Check the SAI Block parameters */
  assert_param(IS_SAI_AUDIO_FREQUENCY(hsai->Init.AudioFrequency));
  assert_param(IS_SAI_BLOCK_PROTOCOL(hsai->Init.Protocol));
  assert_param(IS_SAI_BLOCK_MODE(hsai->Init.AudioMode));
  assert_param(IS_SAI_BLOCK_DATASIZE(hsai->Init.DataSize));
  assert_param(IS_SAI_BLOCK_FIRST_BIT(hsai->Init.FirstBit));
  assert_param(IS_SAI_BLOCK_CLOCK_STROBING(hsai->Init.ClockStrobing));
  assert_param(IS_SAI_BLOCK_SYNCHRO(hsai->Init.Synchro));
  assert_param(IS_SAI_BLOCK_MCK_OUTPUT(hsai->Init.MckOutput));
  assert_param(IS_SAI_BLOCK_OUTPUT_DRIVE(hsai->Init.OutputDrive));
  assert_param(IS_SAI_BLOCK_NODIVIDER(hsai->Init.NoDivider));
  assert_param(IS_SAI_BLOCK_FIFO_THRESHOLD(hsai->Init.FIFOThreshold));
  assert_param(IS_SAI_MONO_STEREO_MODE(hsai->Init.MonoStereoMode));
  assert_param(IS_SAI_BLOCK_COMPANDING_MODE(hsai->Init.CompandingMode));
  assert_param(IS_SAI_BLOCK_TRISTATE_MANAGEMENT(hsai->Init.TriState));
  assert_param(IS_SAI_BLOCK_SYNCEXT(hsai->Init.SynchroExt));
  assert_param(IS_SAI_BLOCK_MCK_OVERSAMPLING(hsai->Init.MckOverSampling));

  /* Check the SAI Block Frame parameters */
  assert_param(IS_SAI_BLOCK_FRAME_LENGTH(hsai->FrameInit.FrameLength));
  assert_param(IS_SAI_BLOCK_ACTIVE_FRAME(hsai->FrameInit.ActiveFrameLength));
  assert_param(IS_SAI_BLOCK_FS_DEFINITION(hsai->FrameInit.FSDefinition));
  assert_param(IS_SAI_BLOCK_FS_POLARITY(hsai->FrameInit.FSPolarity));
  assert_param(IS_SAI_BLOCK_FS_OFFSET(hsai->FrameInit.FSOffset));

  /* Check the SAI Block Slot parameters */
  assert_param(IS_SAI_BLOCK_FIRSTBIT_OFFSET(hsai->SlotInit.FirstBitOffset));
  assert_param(IS_SAI_BLOCK_SLOT_SIZE(hsai->SlotInit.SlotSize));
  assert_param(IS_SAI_BLOCK_SLOT_NUMBER(hsai->SlotInit.SlotNumber));
  assert_param(IS_SAI_SLOT_ACTIVE(hsai->SlotInit.SlotActive));

  /* Check the SAI PDM parameters */
  assert_param(IS_FUNCTIONAL_STATE(hsai->Init.PdmInit.Activation));
  if (hsai->Init.PdmInit.Activation == ENABLE)
  {
    assert_param(IS_SAI_PDM_MIC_PAIRS_NUMBER(hsai->Init.PdmInit.MicPairsNbr));
    assert_param(IS_SAI_PDM_CLOCK_ENABLE(hsai->Init.PdmInit.ClockEnable));
    /* Check that SAI sub-block is SAI1 sub-block A, in master RX mode with free protocol */
    if ((hsai->Instance != SAI1_Block_A) ||
        (hsai->Init.AudioMode != SAI_MODEMASTER_RX) ||
        (hsai->Init.Protocol != SAI_FREE_PROTOCOL))
    {
      return HAL_ERROR;
    }
  }

  if (hsai->State == HAL_SAI_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    hsai->Lock = HAL_UNLOCKED;

#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
    /* Reset callback pointers to the weak predefined callbacks */
    hsai->RxCpltCallback     = HAL_SAI_RxCpltCallback;
    hsai->RxHalfCpltCallback = HAL_SAI_RxHalfCpltCallback;
    hsai->TxCpltCallback     = HAL_SAI_TxCpltCallback;
    hsai->TxHalfCpltCallback = HAL_SAI_TxHalfCpltCallback;
    hsai->ErrorCallback      = HAL_SAI_ErrorCallback;

    /* Init the low level hardware : GPIO, CLOCK, NVIC and DMA */
    if (hsai->MspInitCallback == NULL)
    {
      hsai->MspInitCallback = HAL_SAI_MspInit;
    }
    hsai->MspInitCallback(hsai);
#else
    /* Init the low level hardware : GPIO, CLOCK, NVIC and DMA */
    HAL_SAI_MspInit(hsai);
#endif /* USE_HAL_SAI_REGISTER_CALLBACKS */
  }

  /* Disable the selected SAI peripheral */
  if (SAI_Disable(hsai) != HAL_OK)
  {
    return HAL_ERROR;
  }

  hsai->State = HAL_SAI_STATE_BUSY;

  /* SAI Block Synchro Configuration -----------------------------------------*/
  /* This setting must be done with both audio block (A & B) disabled         */
  switch (hsai->Init.SynchroExt)
  {
    case SAI_SYNCEXT_DISABLE :
      tmpregisterGCR = 0;
      break;
    case SAI_SYNCEXT_OUTBLOCKA_ENABLE :
      tmpregisterGCR = SAI_GCR_SYNCOUT_0;
      break;
    case SAI_SYNCEXT_OUTBLOCKB_ENABLE :
      tmpregisterGCR = SAI_GCR_SYNCOUT_1;
      break;
    default :
      tmpregisterGCR = 0;
      break;
  }

  switch (hsai->Init.Synchro)
  {
    case SAI_ASYNCHRONOUS :
      syncen_bits = 0;
      break;
    case SAI_SYNCHRONOUS :
      syncen_bits = SAI_xCR1_SYNCEN_0;
      break;
    case SAI_SYNCHRONOUS_EXT_SAI1 :
      syncen_bits = SAI_xCR1_SYNCEN_1;
      break;
    case SAI_SYNCHRONOUS_EXT_SAI2 :
      syncen_bits = SAI_xCR1_SYNCEN_1;
      tmpregisterGCR |= SAI_GCR_SYNCIN_0;
      break;
    default :
      syncen_bits = 0;
      break;
  }

  if ((hsai->Instance == SAI1_Block_A) || (hsai->Instance == SAI1_Block_B))
  {
    SAI1->GCR = tmpregisterGCR;
  }
  else
  {
    SAI2->GCR = tmpregisterGCR;
  }

  if (hsai->Init.AudioFrequency != SAI_AUDIO_FREQUENCY_MCKDIV)
  {
    uint32_t freq = 0;
    uint32_t tmpval;

    /* In this case, the MCKDIV value is calculated to get AudioFrequency */
    if ((hsai->Instance == SAI1_Block_A) || (hsai->Instance == SAI1_Block_B))
    {
      freq = HAL_RCCEx_GetPeriphCLKFreq(RCC_PERIPHCLK_SAI1);
    }
    if ((hsai->Instance == SAI2_Block_A) || (hsai->Instance == SAI2_Block_B))
    {
      freq = HAL_RCCEx_GetPeriphCLKFreq(RCC_PERIPHCLK_SAI2);
    }

    /* Configure Master Clock Divider using the following formula :
       - If NODIV = 1 :
         MCKDIV[5:0] = SAI_CK_x / (FS * (FRL + 1))
       - If NODIV = 0 :
         MCKDIV[5:0] = SAI_CK_x / (FS * (OSR + 1) * 256) */
    if (hsai->Init.NoDivider == SAI_MASTERDIVIDER_DISABLE)
    {
      /* NODIV = 1 */
      uint32_t tmpframelength;

      if (hsai->Init.Protocol == SAI_SPDIF_PROTOCOL)
      {
        /* For SPDIF protocol, frame length is set by hardware to 64 */
        tmpframelength = SAI_SPDIF_FRAME_LENGTH;
      }
      else if (hsai->Init.Protocol == SAI_AC97_PROTOCOL)
      {
        /* For AC97 protocol, frame length is set by hardware to 256 */
        tmpframelength = SAI_AC97_FRAME_LENGTH;
      }
      else
      {
        /* For free protocol, frame length is set by user */
        tmpframelength = hsai->FrameInit.FrameLength;
      }

      /* (freq x 10) to keep Significant digits */
      tmpval = (freq * 10U) / (hsai->Init.AudioFrequency * tmpframelength);
    }
    else
    {
      /* NODIV = 0 */
      uint32_t tmposr;
      tmposr = (hsai->Init.MckOverSampling == SAI_MCK_OVERSAMPLING_ENABLE) ? 2U : 1U;
      /* (freq x 10) to keep Significant digits */
      tmpval = (freq * 10U) / (hsai->Init.AudioFrequency * tmposr * 256U);
    }
    hsai->Init.Mckdiv = tmpval / 10U;

    /* Round result to the nearest integer */
    if ((tmpval % 10U) > 8U)
    {
      hsai->Init.Mckdiv += 1U;
    }

    /* For SPDIF protocol, SAI shall provide a bit clock twice faster the symbol-rate */
    if (hsai->Init.Protocol == SAI_SPDIF_PROTOCOL)
    {
      hsai->Init.Mckdiv = hsai->Init.Mckdiv >> 1;
    }
  }

  /* Check the SAI Block master clock divider parameter */
  assert_param(IS_SAI_BLOCK_MASTER_DIVIDER(hsai->Init.Mckdiv));

  /* Compute CKSTR bits of SAI CR1 according ClockStrobing and AudioMode */
  if ((hsai->Init.AudioMode == SAI_MODEMASTER_TX) || (hsai->Init.AudioMode == SAI_MODESLAVE_TX))
  {
    /* Transmit */
    ckstr_bits = (hsai->Init.ClockStrobing == SAI_CLOCKSTROBING_RISINGEDGE) ? 0U : SAI_xCR1_CKSTR;
  }
  else
  {
    /* Receive */
    ckstr_bits = (hsai->Init.ClockStrobing == SAI_CLOCKSTROBING_RISINGEDGE) ? SAI_xCR1_CKSTR : 0U;
  }

  /* SAI Block Configuration -------------------------------------------------*/
  /* SAI CR1 Configuration */
  hsai->Instance->CR1 &= ~(SAI_xCR1_MODE | SAI_xCR1_PRTCFG |  SAI_xCR1_DS |      \
                           SAI_xCR1_LSBFIRST | SAI_xCR1_CKSTR | SAI_xCR1_SYNCEN | \
                           SAI_xCR1_MONO | SAI_xCR1_OUTDRIV  | SAI_xCR1_DMAEN |  \
                           SAI_xCR1_NODIV | SAI_xCR1_MCKDIV | SAI_xCR1_OSR |     \
                           SAI_xCR1_MCKEN);

  hsai->Instance->CR1 |= (hsai->Init.AudioMode | hsai->Init.Protocol |           \
                          hsai->Init.DataSize | hsai->Init.FirstBit  |           \
                          ckstr_bits | syncen_bits |                             \
                          hsai->Init.MonoStereoMode | hsai->Init.OutputDrive |   \
                          hsai->Init.NoDivider | (hsai->Init.Mckdiv << 20) |     \
                          hsai->Init.MckOverSampling | hsai->Init.MckOutput);

  /* SAI CR2 Configuration */
  hsai->Instance->CR2 &= ~(SAI_xCR2_FTH | SAI_xCR2_FFLUSH | SAI_xCR2_COMP | SAI_xCR2_CPL);
  hsai->Instance->CR2 |= (hsai->Init.FIFOThreshold | hsai->Init.CompandingMode | hsai->Init.TriState);

  /* SAI Frame Configuration -----------------------------------------*/
  hsai->Instance->FRCR &= (~(SAI_xFRCR_FRL | SAI_xFRCR_FSALL | SAI_xFRCR_FSDEF | \
                             SAI_xFRCR_FSPOL | SAI_xFRCR_FSOFF));
  hsai->Instance->FRCR |= ((hsai->FrameInit.FrameLength - 1U) |
                           hsai->FrameInit.FSOffset |
                           hsai->FrameInit.FSDefinition |
                           hsai->FrameInit.FSPolarity   |
                           ((hsai->FrameInit.ActiveFrameLength - 1U) << 8));

  /* SAI Block_x SLOT Configuration ------------------------------------------*/
  /* This register has no meaning in AC 97 and SPDIF audio protocol */
  hsai->Instance->SLOTR &= (~(SAI_xSLOTR_FBOFF | SAI_xSLOTR_SLOTSZ |  \
                              SAI_xSLOTR_NBSLOT | SAI_xSLOTR_SLOTEN));

  hsai->Instance->SLOTR |= hsai->SlotInit.FirstBitOffset | hsai->SlotInit.SlotSize | \
                           (hsai->SlotInit.SlotActive << 16) | ((hsai->SlotInit.SlotNumber - 1U) <<  8);

  /* SAI PDM Configuration ---------------------------------------------------*/
  if (hsai->Instance == SAI1_Block_A)
  {
    /* Disable PDM interface */
    SAI1->PDMCR &= ~(SAI_PDMCR_PDMEN);
    if (hsai->Init.PdmInit.Activation == ENABLE)
    {
      /* Configure and enable PDM interface */
      SAI1->PDMCR = (hsai->Init.PdmInit.ClockEnable |
                     ((hsai->Init.PdmInit.MicPairsNbr - 1U) << SAI_PDMCR_MICNBR_Pos));
      SAI1->PDMCR |= SAI_PDMCR_PDMEN;
    }
  }

  /* Initialize the error code */
  hsai->ErrorCode = HAL_SAI_ERROR_NONE;

  /* Initialize the SAI state */
  hsai->State = HAL_SAI_STATE_READY;

  /* Release Lock */
  __HAL_UNLOCK(hsai);

  return HAL_OK;
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_DeInit(SAI_HandleTypeDef *hsai)
{
  /* Check the SAI handle allocation */
  if (hsai == NULL)
  {
    return HAL_ERROR;
  }

  hsai->State = HAL_SAI_STATE_BUSY;

  /* Disabled All interrupt and clear all the flag */
  hsai->Instance->IMR = 0;
  hsai->Instance->CLRFR = 0xFFFFFFFFU;

  /* Disable the SAI */
  if (SAI_Disable(hsai) != HAL_OK)
  {
    /* Reset SAI state to ready */
    hsai->State = HAL_SAI_STATE_READY;

    /* Release Lock */
    __HAL_UNLOCK(hsai);

    return HAL_ERROR;
  }

  /* Flush the fifo */
  SET_BIT(hsai->Instance->CR2, SAI_xCR2_FFLUSH);

  /* Disable SAI PDM interface */
  if (hsai->Instance == SAI1_Block_A)
  {
    /* Reset PDM delays */
    SAI1->PDMDLY = 0U;

    /* Disable PDM interface */
    SAI1->PDMCR &= ~(SAI_PDMCR_PDMEN);
  }

  /* DeInit the low level hardware: GPIO, CLOCK, NVIC and DMA */
#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
  if (hsai->MspDeInitCallback == NULL)
  {
    hsai->MspDeInitCallback = HAL_SAI_MspDeInit;
  }
  hsai->MspDeInitCallback(hsai);
#else
  HAL_SAI_MspDeInit(hsai);
#endif /* USE_HAL_SAI_REGISTER_CALLBACKS */

  /* Initialize the error code */
  hsai->ErrorCode = HAL_SAI_ERROR_NONE;

  /* Initialize the SAI state */
  hsai->State = HAL_SAI_STATE_RESET;

  /* Release Lock */
  __HAL_UNLOCK(hsai);

  return HAL_OK;
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_SAI_RegisterCallback(SAI_HandleTypeDef        *hsai,
                                           HAL_SAI_CallbackIDTypeDef CallbackID,
                                           pSAI_CallbackTypeDef      pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* update the error code */
    hsai->ErrorCode |= HAL_SAI_ERROR_INVALID_CALLBACK;
    /* update return status */
    status = HAL_ERROR;
  }
  else
  {
    if (HAL_SAI_STATE_READY == hsai->State)
    {
      switch (CallbackID)
      {
        case HAL_SAI_RX_COMPLETE_CB_ID :
          hsai->RxCpltCallback = pCallback;
          break;
        case HAL_SAI_RX_HALFCOMPLETE_CB_ID :
          hsai->RxHalfCpltCallback = pCallback;
          break;
        case HAL_SAI_TX_COMPLETE_CB_ID :
          hsai->TxCpltCallback = pCallback;
          break;
        case HAL_SAI_TX_HALFCOMPLETE_CB_ID :
          hsai->TxHalfCpltCallback = pCallback;
          break;
        case HAL_SAI_ERROR_CB_ID :
          hsai->ErrorCallback = pCallback;
          break;
        case HAL_SAI_MSPINIT_CB_ID :
          hsai->MspInitCallback = pCallback;
          break;
        case HAL_SAI_MSPDEINIT_CB_ID :
          hsai->MspDeInitCallback = pCallback;
          break;
        default :
          /* update the error code */
          hsai->ErrorCode |= HAL_SAI_ERROR_INVALID_CALLBACK;
          /* update return status */
          status = HAL_ERROR;
          break;
      }
    }
    else if (HAL_SAI_STATE_RESET == hsai->State)
    {
      switch (CallbackID)
      {
        case HAL_SAI_MSPINIT_CB_ID :
          hsai->MspInitCallback = pCallback;
          break;
        case HAL_SAI_MSPDEINIT_CB_ID :
          hsai->MspDeInitCallback = pCallback;
          break;
        default :
          /* update the error code */
          hsai->ErrorCode |= HAL_SAI_ERROR_INVALID_CALLBACK;
          /* update return status */
          status = HAL_ERROR;
          break;
      }
    }
    else
    {
      /* update the error code */
      hsai->ErrorCode |= HAL_SAI_ERROR_INVALID_CALLBACK;
      /* update return status */
      status = HAL_ERROR;
    }
  }
  return status;
}
#endif
#endif

#ifdef HAL_SAI_MODULE_ENABLED
#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_SAI_UnRegisterCallback(SAI_HandleTypeDef        *hsai,
                                             HAL_SAI_CallbackIDTypeDef CallbackID)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (HAL_SAI_STATE_READY == hsai->State)
  {
    switch (CallbackID)
    {
      case HAL_SAI_RX_COMPLETE_CB_ID :
        hsai->RxCpltCallback = HAL_SAI_RxCpltCallback;
        break;
      case HAL_SAI_RX_HALFCOMPLETE_CB_ID :
        hsai->RxHalfCpltCallback = HAL_SAI_RxHalfCpltCallback;
        break;
      case HAL_SAI_TX_COMPLETE_CB_ID :
        hsai->TxCpltCallback = HAL_SAI_TxCpltCallback;
        break;
      case HAL_SAI_TX_HALFCOMPLETE_CB_ID :
        hsai->TxHalfCpltCallback = HAL_SAI_TxHalfCpltCallback;
        break;
      case HAL_SAI_ERROR_CB_ID :
        hsai->ErrorCallback = HAL_SAI_ErrorCallback;
        break;
      case HAL_SAI_MSPINIT_CB_ID :
        hsai->MspInitCallback = HAL_SAI_MspInit;
        break;
      case HAL_SAI_MSPDEINIT_CB_ID :
        hsai->MspDeInitCallback = HAL_SAI_MspDeInit;
        break;
      default :
        /* update the error code */
        hsai->ErrorCode |= HAL_SAI_ERROR_INVALID_CALLBACK;
        /* update return status */
        status = HAL_ERROR;
        break;
    }
  }
  else if (HAL_SAI_STATE_RESET == hsai->State)
  {
    switch (CallbackID)
    {
      case HAL_SAI_MSPINIT_CB_ID :
        hsai->MspInitCallback = HAL_SAI_MspInit;
        break;
      case HAL_SAI_MSPDEINIT_CB_ID :
        hsai->MspDeInitCallback = HAL_SAI_MspDeInit;
        break;
      default :
        /* update the error code */
        hsai->ErrorCode |= HAL_SAI_ERROR_INVALID_CALLBACK;
        /* update return status */
        status = HAL_ERROR;
        break;
    }
  }
  else
  {
    /* update the error code */
    hsai->ErrorCode |= HAL_SAI_ERROR_INVALID_CALLBACK;
    /* update return status */
    status = HAL_ERROR;
  }
  return status;
}
#endif
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_Transmit(SAI_HandleTypeDef *hsai, uint8_t *pData, uint16_t Size, uint32_t Timeout)
{
  uint32_t tickstart = HAL_GetTick();
  uint32_t temp;

  if ((pData == NULL) || (Size == 0U))
  {
    return  HAL_ERROR;
  }

  if (hsai->State == HAL_SAI_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hsai);

    hsai->XferSize = Size;
    hsai->XferCount = Size;
    hsai->pBuffPtr = pData;
    hsai->State = HAL_SAI_STATE_BUSY_TX;
    hsai->ErrorCode = HAL_SAI_ERROR_NONE;

    /* Check if the SAI is already enabled */
    if ((hsai->Instance->CR1 & SAI_xCR1_SAIEN) == 0U)
    {
      /* fill the fifo with data before to enabled the SAI */
      SAI_FillFifo(hsai);
      /* Enable SAI peripheral */
      __HAL_SAI_ENABLE(hsai);
    }

    while (hsai->XferCount > 0U)
    {
      /* Write data if the FIFO is not full */
      if ((hsai->Instance->SR & SAI_xSR_FLVL) != SAI_FIFOSTATUS_FULL)
      {
        if ((hsai->Init.DataSize == SAI_DATASIZE_8) && (hsai->Init.CompandingMode == SAI_NOCOMPANDING))
        {
          hsai->Instance->DR = *hsai->pBuffPtr;
          hsai->pBuffPtr++;
        }
        else if (hsai->Init.DataSize <= SAI_DATASIZE_16)
        {
          temp = (uint32_t)(*hsai->pBuffPtr);
          hsai->pBuffPtr++;
          temp |= ((uint32_t)(*hsai->pBuffPtr) << 8);
          hsai->pBuffPtr++;
          hsai->Instance->DR = temp;
        }
        else
        {
          temp = (uint32_t)(*hsai->pBuffPtr);
          hsai->pBuffPtr++;
          temp |= ((uint32_t)(*hsai->pBuffPtr) << 8);
          hsai->pBuffPtr++;
          temp |= ((uint32_t)(*hsai->pBuffPtr) << 16);
          hsai->pBuffPtr++;
          temp |= ((uint32_t)(*hsai->pBuffPtr) << 24);
          hsai->pBuffPtr++;
          hsai->Instance->DR = temp;
        }
        hsai->XferCount--;
      }
      else
      {
        /* Check for the Timeout */
        if ((((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U)) && (Timeout != HAL_MAX_DELAY))
        {
          /* Update error code */
          hsai->ErrorCode |= HAL_SAI_ERROR_TIMEOUT;

          /* Clear all the flags */
          hsai->Instance->CLRFR = 0xFFFFFFFFU;

          /* Disable SAI peripheral */
          /* No need to check return value because state update, unlock and error return will be performed later */
          (void) SAI_Disable(hsai);

          /* Flush the fifo */
          SET_BIT(hsai->Instance->CR2, SAI_xCR2_FFLUSH);

          /* Change the SAI state */
          hsai->State = HAL_SAI_STATE_READY;

          /* Process Unlocked */
          __HAL_UNLOCK(hsai);

          return HAL_ERROR;
        }
      }
    }

    hsai->State = HAL_SAI_STATE_READY;

    /* Process Unlocked */
    __HAL_UNLOCK(hsai);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_Receive(SAI_HandleTypeDef *hsai, uint8_t *pData, uint16_t Size, uint32_t Timeout)
{
  uint32_t tickstart = HAL_GetTick();
  uint32_t temp;

  if ((pData == NULL) || (Size == 0U))
  {
    return  HAL_ERROR;
  }

  if (hsai->State == HAL_SAI_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hsai);

    hsai->pBuffPtr = pData;
    hsai->XferSize = Size;
    hsai->XferCount = Size;
    hsai->State = HAL_SAI_STATE_BUSY_RX;
    hsai->ErrorCode = HAL_SAI_ERROR_NONE;

    /* Check if the SAI is already enabled */
    if ((hsai->Instance->CR1 & SAI_xCR1_SAIEN) == 0U)
    {
      /* Enable SAI peripheral */
      __HAL_SAI_ENABLE(hsai);
    }

    /* Receive data */
    while (hsai->XferCount > 0U)
    {
      if ((hsai->Instance->SR & SAI_xSR_FLVL) != SAI_FIFOSTATUS_EMPTY)
      {
        if ((hsai->Init.DataSize == SAI_DATASIZE_8) && (hsai->Init.CompandingMode == SAI_NOCOMPANDING))
        {
          *hsai->pBuffPtr = (uint8_t)hsai->Instance->DR;
          hsai->pBuffPtr++;
        }
        else if (hsai->Init.DataSize <= SAI_DATASIZE_16)
        {
          temp = hsai->Instance->DR;
          *hsai->pBuffPtr = (uint8_t)temp;
          hsai->pBuffPtr++;
          *hsai->pBuffPtr = (uint8_t)(temp >> 8);
          hsai->pBuffPtr++;
        }
        else
        {
          temp = hsai->Instance->DR;
          *hsai->pBuffPtr = (uint8_t)temp;
          hsai->pBuffPtr++;
          *hsai->pBuffPtr = (uint8_t)(temp >> 8);
          hsai->pBuffPtr++;
          *hsai->pBuffPtr = (uint8_t)(temp >> 16);
          hsai->pBuffPtr++;
          *hsai->pBuffPtr = (uint8_t)(temp >> 24);
          hsai->pBuffPtr++;
        }
        hsai->XferCount--;
      }
      else
      {
        /* Check for the Timeout */
        if ((((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U)) && (Timeout != HAL_MAX_DELAY))
        {
          /* Update error code */
          hsai->ErrorCode |= HAL_SAI_ERROR_TIMEOUT;

          /* Clear all the flags */
          hsai->Instance->CLRFR = 0xFFFFFFFFU;

          /* Disable SAI peripheral */
          /* No need to check return value because state update, unlock and error return will be performed later */
          (void) SAI_Disable(hsai);

          /* Flush the fifo */
          SET_BIT(hsai->Instance->CR2, SAI_xCR2_FFLUSH);

          /* Change the SAI state */
          hsai->State = HAL_SAI_STATE_READY;

          /* Process Unlocked */
          __HAL_UNLOCK(hsai);

          return HAL_ERROR;
        }
      }
    }

    hsai->State = HAL_SAI_STATE_READY;

    /* Process Unlocked */
    __HAL_UNLOCK(hsai);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_Transmit_IT(SAI_HandleTypeDef *hsai, uint8_t *pData, uint16_t Size)
{
  if ((pData == NULL) || (Size == 0U))
  {
    return  HAL_ERROR;
  }

  if (hsai->State == HAL_SAI_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hsai);

    hsai->pBuffPtr = pData;
    hsai->XferSize = Size;
    hsai->XferCount = Size;
    hsai->ErrorCode = HAL_SAI_ERROR_NONE;
    hsai->State = HAL_SAI_STATE_BUSY_TX;

    if ((hsai->Init.DataSize == SAI_DATASIZE_8) && (hsai->Init.CompandingMode == SAI_NOCOMPANDING))
    {
      hsai->InterruptServiceRoutine = SAI_Transmit_IT8Bit;
    }
    else if (hsai->Init.DataSize <= SAI_DATASIZE_16)
    {
      hsai->InterruptServiceRoutine = SAI_Transmit_IT16Bit;
    }
    else
    {
      hsai->InterruptServiceRoutine = SAI_Transmit_IT32Bit;
    }

    /* Fill the fifo before starting the communication */
    SAI_FillFifo(hsai);

    /* Enable FRQ and OVRUDR interrupts */
    __HAL_SAI_ENABLE_IT(hsai, SAI_InterruptFlag(hsai, SAI_MODE_IT));

    /* Check if the SAI is already enabled */
    if ((hsai->Instance->CR1 & SAI_xCR1_SAIEN) == 0U)
    {
      /* Enable SAI peripheral */
      __HAL_SAI_ENABLE(hsai);
    }
    /* Process Unlocked */
    __HAL_UNLOCK(hsai);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_Receive_IT(SAI_HandleTypeDef *hsai, uint8_t *pData, uint16_t Size)
{
  if ((pData == NULL) || (Size == 0U))
  {
    return  HAL_ERROR;
  }

  if (hsai->State == HAL_SAI_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hsai);

    hsai->pBuffPtr = pData;
    hsai->XferSize = Size;
    hsai->XferCount = Size;
    hsai->ErrorCode = HAL_SAI_ERROR_NONE;
    hsai->State = HAL_SAI_STATE_BUSY_RX;

    if ((hsai->Init.DataSize == SAI_DATASIZE_8) && (hsai->Init.CompandingMode == SAI_NOCOMPANDING))
    {
      hsai->InterruptServiceRoutine = SAI_Receive_IT8Bit;
    }
    else if (hsai->Init.DataSize <= SAI_DATASIZE_16)
    {
      hsai->InterruptServiceRoutine = SAI_Receive_IT16Bit;
    }
    else
    {
      hsai->InterruptServiceRoutine = SAI_Receive_IT32Bit;
    }

    /* Enable TXE and OVRUDR interrupts */
    __HAL_SAI_ENABLE_IT(hsai, SAI_InterruptFlag(hsai, SAI_MODE_IT));

    /* Check if the SAI is already enabled */
    if ((hsai->Instance->CR1 & SAI_xCR1_SAIEN) == 0U)
    {
      /* Enable SAI peripheral */
      __HAL_SAI_ENABLE(hsai);
    }

    /* Process Unlocked */
    __HAL_UNLOCK(hsai);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_DMAPause(SAI_HandleTypeDef *hsai)
{
  /* Process Locked */
  __HAL_LOCK(hsai);

  /* Pause the audio file playing by disabling the SAI DMA requests */
  hsai->Instance->CR1 &= ~SAI_xCR1_DMAEN;

  /* Process Unlocked */
  __HAL_UNLOCK(hsai);

  return HAL_OK;
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_DMAResume(SAI_HandleTypeDef *hsai)
{
  /* Process Locked */
  __HAL_LOCK(hsai);

  /* Enable the SAI DMA requests */
  hsai->Instance->CR1 |= SAI_xCR1_DMAEN;

  /* If the SAI peripheral is still not enabled, enable it */
  if ((hsai->Instance->CR1 & SAI_xCR1_SAIEN) == 0U)
  {
    /* Enable SAI peripheral */
    __HAL_SAI_ENABLE(hsai);
  }

  /* Process Unlocked */
  __HAL_UNLOCK(hsai);

  return HAL_OK;
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_DMAStop(SAI_HandleTypeDef *hsai)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Process Locked */
  __HAL_LOCK(hsai);

  /* Disable SAI peripheral */
  if (SAI_Disable(hsai) != HAL_OK)
  {
    status = HAL_ERROR;
  }

  /* Disable the SAI DMA request */
  hsai->Instance->CR1 &= ~SAI_xCR1_DMAEN;

  /* Abort the SAI Tx DMA Stream */
  if ((hsai->State == HAL_SAI_STATE_BUSY_TX) && (hsai->hdmatx != NULL))
  {
    if (HAL_DMA_Abort(hsai->hdmatx) != HAL_OK)
    {
      /* If the DMA Tx errorCode is different from DMA No Transfer then return Error */
      if (hsai->hdmatx->ErrorCode != HAL_DMA_ERROR_NO_XFER)
      {
        status = HAL_ERROR;
        hsai->ErrorCode |= HAL_SAI_ERROR_DMA;
      }
    }
  }

  /* Abort the SAI Rx DMA Stream */
  if ((hsai->State == HAL_SAI_STATE_BUSY_RX) && (hsai->hdmarx != NULL))
  {
    if (HAL_DMA_Abort(hsai->hdmarx) != HAL_OK)
    {
      /* If the DMA Rx errorCode is different from DMA No Transfer then return Error */
      if (hsai->hdmarx->ErrorCode != HAL_DMA_ERROR_NO_XFER)
      {
        status = HAL_ERROR;
        hsai->ErrorCode |= HAL_SAI_ERROR_DMA;
      }
    }
  }

  /* Flush the fifo */
  SET_BIT(hsai->Instance->CR2, SAI_xCR2_FFLUSH);

  /* Set hsai state to ready */
  hsai->State = HAL_SAI_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(hsai);

  return status;
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_Abort(SAI_HandleTypeDef *hsai)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Process Locked */
  __HAL_LOCK(hsai);

  /* Disable SAI peripheral */
  if (SAI_Disable(hsai) != HAL_OK)
  {
    status = HAL_ERROR;
  }

  /* Check SAI DMA is enabled or not */
  if ((hsai->Instance->CR1 & SAI_xCR1_DMAEN) == SAI_xCR1_DMAEN)
  {
    /* Disable the SAI DMA request */
    hsai->Instance->CR1 &= ~SAI_xCR1_DMAEN;

    /* Abort the SAI Tx DMA Stream */
    if ((hsai->State == HAL_SAI_STATE_BUSY_TX) && (hsai->hdmatx != NULL))
    {
      if (HAL_DMA_Abort(hsai->hdmatx) != HAL_OK)
      {
        /* If the DMA Tx errorCode is different from DMA No Transfer then return Error */
        if (hsai->hdmatx->ErrorCode != HAL_DMA_ERROR_NO_XFER)
        {
          status = HAL_ERROR;
          hsai->ErrorCode |= HAL_SAI_ERROR_DMA;
        }
      }
    }

    /* Abort the SAI Rx DMA Stream */
    if ((hsai->State == HAL_SAI_STATE_BUSY_RX) && (hsai->hdmarx != NULL))
    {
      if (HAL_DMA_Abort(hsai->hdmarx) != HAL_OK)
      {
        /* If the DMA Rx errorCode is different from DMA No Transfer then return Error */
        if (hsai->hdmarx->ErrorCode != HAL_DMA_ERROR_NO_XFER)
        {
          status = HAL_ERROR;
          hsai->ErrorCode |= HAL_SAI_ERROR_DMA;
        }
      }
    }
  }

  /* Disabled All interrupt and clear all the flag */
  hsai->Instance->IMR = 0;
  hsai->Instance->CLRFR = 0xFFFFFFFFU;

  /* Flush the fifo */
  SET_BIT(hsai->Instance->CR2, SAI_xCR2_FFLUSH);

  /* Set hsai state to ready */
  hsai->State = HAL_SAI_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(hsai);

  return status;
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_Transmit_DMA(SAI_HandleTypeDef *hsai, uint8_t *pData, uint16_t Size)
{
  HAL_StatusTypeDef status;
  uint32_t tickstart = HAL_GetTick();

  if ((pData == NULL) || (Size == 0U))
  {
    return  HAL_ERROR;
  }

  if (hsai->State == HAL_SAI_STATE_READY)
  {
    uint32_t dmaSrcSize;

    /* Process Locked */
    __HAL_LOCK(hsai);

    hsai->pBuffPtr = pData;
    hsai->XferSize = Size;
    hsai->XferCount = Size;
    hsai->ErrorCode = HAL_SAI_ERROR_NONE;
    hsai->State = HAL_SAI_STATE_BUSY_TX;

    /* Set the SAI Tx DMA Half transfer complete callback */
    hsai->hdmatx->XferHalfCpltCallback = SAI_DMATxHalfCplt;

    /* Set the SAI TxDMA transfer complete callback */
    hsai->hdmatx->XferCpltCallback = SAI_DMATxCplt;

    /* Set the DMA error callback */
    hsai->hdmatx->XferErrorCallback = SAI_DMAError;

    /* Set the DMA Tx abort callback */
    hsai->hdmatx->XferAbortCallback = NULL;

    /* For transmission, the DMA source is data buffer.
       We have to compute DMA size of a source block transfer in bytes according SAI data size. */
    if ((hsai->Init.DataSize == SAI_DATASIZE_8) && (hsai->Init.CompandingMode == SAI_NOCOMPANDING))
    {
      dmaSrcSize = (uint32_t) Size;
    }
    else if (hsai->Init.DataSize <= SAI_DATASIZE_16)
    {
      dmaSrcSize = 2U * (uint32_t) Size;
    }
    else
    {
      dmaSrcSize = 4U * (uint32_t) Size;
    }

    /* Enable the Tx DMA Stream */
    if ((hsai->hdmatx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
    {
      if (hsai->hdmatx->LinkedListQueue != NULL)
      {
        /* Set DMA data size */
        hsai->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = dmaSrcSize;

        /* Set DMA source address */
        hsai->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = (uint32_t)hsai->pBuffPtr;

        /* Set DMA destination address */
        hsai->hdmatx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = (uint32_t)&hsai->Instance->DR;

        status = HAL_DMAEx_List_Start_IT(hsai->hdmatx);
      }
      else
      {
        __HAL_UNLOCK(hsai);
        return  HAL_ERROR;
      }
    }
    else
    {
      status = HAL_DMA_Start_IT(hsai->hdmatx, (uint32_t)hsai->pBuffPtr, (uint32_t)&hsai->Instance->DR, dmaSrcSize);
    }

    if (status != HAL_OK)
    {
      __HAL_UNLOCK(hsai);
      return  HAL_ERROR;
    }

    /* Enable the interrupts for error handling */
    __HAL_SAI_ENABLE_IT(hsai, SAI_InterruptFlag(hsai, SAI_MODE_DMA));

    /* Enable SAI Tx DMA Request */
    hsai->Instance->CR1 |= SAI_xCR1_DMAEN;

    /* Wait until FIFO is not empty */
    while ((hsai->Instance->SR & SAI_xSR_FLVL) == SAI_FIFOSTATUS_EMPTY)
    {
      /* Check for the Timeout */
      if ((HAL_GetTick() - tickstart) > SAI_LONG_TIMEOUT)
      {
        /* Update error code */
        hsai->ErrorCode |= HAL_SAI_ERROR_TIMEOUT;

        /* Process Unlocked */
        __HAL_UNLOCK(hsai);

        return HAL_TIMEOUT;
      }
    }

    /* Check if the SAI is already enabled */
    if ((hsai->Instance->CR1 & SAI_xCR1_SAIEN) == 0U)
    {
      /* Enable SAI peripheral */
      __HAL_SAI_ENABLE(hsai);
    }

    /* Process Unlocked */
    __HAL_UNLOCK(hsai);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_Receive_DMA(SAI_HandleTypeDef *hsai, uint8_t *pData, uint16_t Size)
{
  HAL_StatusTypeDef status;

  if ((pData == NULL) || (Size == 0U))
  {
    return  HAL_ERROR;
  }

  if (hsai->State == HAL_SAI_STATE_READY)
  {
    uint32_t dmaSrcSize;

    /* Process Locked */
    __HAL_LOCK(hsai);

    hsai->pBuffPtr = pData;
    hsai->XferSize = Size;
    hsai->XferCount = Size;
    hsai->ErrorCode = HAL_SAI_ERROR_NONE;
    hsai->State = HAL_SAI_STATE_BUSY_RX;

    /* Set the SAI Rx DMA Half transfer complete callback */
    hsai->hdmarx->XferHalfCpltCallback = SAI_DMARxHalfCplt;

    /* Set the SAI Rx DMA transfer complete callback */
    hsai->hdmarx->XferCpltCallback = SAI_DMARxCplt;

    /* Set the DMA error callback */
    hsai->hdmarx->XferErrorCallback = SAI_DMAError;

    /* Set the DMA Rx abort callback */
    hsai->hdmarx->XferAbortCallback = NULL;

    /* For reception, the DMA source is SAI DR register.
       We have to compute DMA size of a source block transfer in bytes according SAI data size. */
    if ((hsai->Init.DataSize == SAI_DATASIZE_8) && (hsai->Init.CompandingMode == SAI_NOCOMPANDING))
    {
      dmaSrcSize = (uint32_t) Size;
    }
    else if (hsai->Init.DataSize <= SAI_DATASIZE_16)
    {
      dmaSrcSize = 2U * (uint32_t) Size;
    }
    else
    {
      dmaSrcSize = 4U * (uint32_t) Size;
    }

    /* Enable the Rx DMA Stream */
    if ((hsai->hdmarx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
    {
      if (hsai->hdmarx->LinkedListQueue != NULL)
      {
        /* Set DMA data size */
        hsai->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = dmaSrcSize;

        /* Set DMA source address */
        hsai->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = (uint32_t)&hsai->Instance->DR;

        /* Set DMA destination address */
        hsai->hdmarx->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = (uint32_t)hsai->pBuffPtr;

        status = HAL_DMAEx_List_Start_IT(hsai->hdmarx);
      }
      else
      {
        __HAL_UNLOCK(hsai);
        return  HAL_ERROR;
      }
    }
    else
    {
      status = HAL_DMA_Start_IT(hsai->hdmarx, (uint32_t)&hsai->Instance->DR, (uint32_t)hsai->pBuffPtr, dmaSrcSize);
    }

    if (status != HAL_OK)
    {
      __HAL_UNLOCK(hsai);
      return  HAL_ERROR;
    }

    /* Enable the interrupts for error handling */
    __HAL_SAI_ENABLE_IT(hsai, SAI_InterruptFlag(hsai, SAI_MODE_DMA));

    /* Enable SAI Rx DMA Request */
    hsai->Instance->CR1 |= SAI_xCR1_DMAEN;

    /* Check if the SAI is already enabled */
    if ((hsai->Instance->CR1 & SAI_xCR1_SAIEN) == 0U)
    {
      /* Enable SAI peripheral */
      __HAL_SAI_ENABLE(hsai);
    }

    /* Process Unlocked */
    __HAL_UNLOCK(hsai);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_EnableTxMuteMode(SAI_HandleTypeDef *hsai, uint16_t val)
{
  assert_param(IS_SAI_BLOCK_MUTE_VALUE(val));

  if (hsai->State != HAL_SAI_STATE_RESET)
  {
    CLEAR_BIT(hsai->Instance->CR2, SAI_xCR2_MUTEVAL | SAI_xCR2_MUTE);
    SET_BIT(hsai->Instance->CR2, SAI_xCR2_MUTE | (uint32_t)val);
    return HAL_OK;
  }
  return HAL_ERROR;
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_DisableTxMuteMode(SAI_HandleTypeDef *hsai)
{
  if (hsai->State != HAL_SAI_STATE_RESET)
  {
    CLEAR_BIT(hsai->Instance->CR2, SAI_xCR2_MUTEVAL | SAI_xCR2_MUTE);
    return HAL_OK;
  }
  return HAL_ERROR;
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_EnableRxMuteMode(SAI_HandleTypeDef *hsai, SAIcallback callback, uint16_t counter)
{
  assert_param(IS_SAI_BLOCK_MUTE_COUNTER(counter));

  if (hsai->State != HAL_SAI_STATE_RESET)
  {
    /* set the mute counter */
    CLEAR_BIT(hsai->Instance->CR2, SAI_xCR2_MUTECNT);
    SET_BIT(hsai->Instance->CR2, (uint32_t)((uint32_t)counter << SAI_xCR2_MUTECNT_Pos));
    hsai->mutecallback = callback;
    /* enable the IT interrupt */
    __HAL_SAI_ENABLE_IT(hsai, SAI_IT_MUTEDET);
    return HAL_OK;
  }
  return HAL_ERROR;
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_DisableRxMuteMode(SAI_HandleTypeDef *hsai)
{
  if (hsai->State != HAL_SAI_STATE_RESET)
  {
    /* set the mutecallback to NULL */
    hsai->mutecallback = NULL;
    /* enable the IT interrupt */
    __HAL_SAI_DISABLE_IT(hsai, SAI_IT_MUTEDET);
    return HAL_OK;
  }
  return HAL_ERROR;
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
void HAL_SAI_IRQHandler(SAI_HandleTypeDef *hsai)
{
  if (hsai->State != HAL_SAI_STATE_RESET)
  {
    uint32_t itflags = hsai->Instance->SR;
    uint32_t itsources = hsai->Instance->IMR;
    uint32_t cr1config = hsai->Instance->CR1;
    uint32_t tmperror;

    /* SAI Fifo request interrupt occurred -----------------------------------*/
    if (((itflags & SAI_xSR_FREQ) == SAI_xSR_FREQ) && ((itsources & SAI_IT_FREQ) == SAI_IT_FREQ))
    {
      hsai->InterruptServiceRoutine(hsai);
    }
    /* SAI Overrun error interrupt occurred ----------------------------------*/
    else if (((itflags & SAI_FLAG_OVRUDR) == SAI_FLAG_OVRUDR) && ((itsources & SAI_IT_OVRUDR) == SAI_IT_OVRUDR))
    {
      /* Clear the SAI Overrun flag */
      __HAL_SAI_CLEAR_FLAG(hsai, SAI_FLAG_OVRUDR);
      /* Get the SAI error code */
      tmperror = ((hsai->State == HAL_SAI_STATE_BUSY_RX) ? HAL_SAI_ERROR_OVR : HAL_SAI_ERROR_UDR);
      /* Change the SAI error code */
      hsai->ErrorCode |= tmperror;
      /* the transfer is not stopped, we will forward the information to the user and we let
      the user decide what needs to be done */
#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
      hsai->ErrorCallback(hsai);
#else
      HAL_SAI_ErrorCallback(hsai);
#endif /* USE_HAL_SAI_REGISTER_CALLBACKS */
    }
    /* SAI mutedet interrupt occurred ----------------------------------*/
    else if (((itflags & SAI_FLAG_MUTEDET) == SAI_FLAG_MUTEDET) && ((itsources & SAI_IT_MUTEDET) == SAI_IT_MUTEDET))
    {
      /* Clear the SAI mutedet flag */
      __HAL_SAI_CLEAR_FLAG(hsai, SAI_FLAG_MUTEDET);
      /* call the call back function */
      if (hsai->mutecallback != NULL)
      {
        /* inform the user that an RX mute event has been detected */
        hsai->mutecallback();
      }
    }
    /* SAI AFSDET interrupt occurred ----------------------------------*/
    else if (((itflags & SAI_FLAG_AFSDET) == SAI_FLAG_AFSDET) && ((itsources & SAI_IT_AFSDET) == SAI_IT_AFSDET))
    {
      /* Clear the SAI AFSDET flag */
      __HAL_SAI_CLEAR_FLAG(hsai, SAI_FLAG_AFSDET);

      /* Change the SAI error code */
      hsai->ErrorCode |= HAL_SAI_ERROR_AFSDET;

      /* Check SAI DMA is enabled or not */
      if ((cr1config & SAI_xCR1_DMAEN) == SAI_xCR1_DMAEN)
      {
        /* Abort the SAI DMA Streams */
        if (hsai->hdmatx != NULL)
        {
          /* Set the DMA Tx abort callback */
          hsai->hdmatx->XferAbortCallback = SAI_DMAAbort;

          /* Abort DMA in IT mode */
          if (HAL_DMA_Abort_IT(hsai->hdmatx) != HAL_OK)
          {
            /* Update SAI error code */
            hsai->ErrorCode |= HAL_SAI_ERROR_DMA;

            /* Call SAI error callback */
#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
            hsai->ErrorCallback(hsai);
#else
            HAL_SAI_ErrorCallback(hsai);
#endif /* USE_HAL_SAI_REGISTER_CALLBACKS */
          }
        }
        if (hsai->hdmarx != NULL)
        {
          /* Set the DMA Rx abort callback */
          hsai->hdmarx->XferAbortCallback = SAI_DMAAbort;

          /* Abort DMA in IT mode */
          if (HAL_DMA_Abort_IT(hsai->hdmarx) != HAL_OK)
          {
            /* Update SAI error code */
            hsai->ErrorCode |= HAL_SAI_ERROR_DMA;

            /* Call SAI error callback */
#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
            hsai->ErrorCallback(hsai);
#else
            HAL_SAI_ErrorCallback(hsai);
#endif /* USE_HAL_SAI_REGISTER_CALLBACKS */
          }
        }
      }
      else
      {
        /* Abort SAI */
        /* No need to check return value because HAL_SAI_ErrorCallback will be called later */
        (void) HAL_SAI_Abort(hsai);

        /* Set error callback */
#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
        hsai->ErrorCallback(hsai);
#else
        HAL_SAI_ErrorCallback(hsai);
#endif /* USE_HAL_SAI_REGISTER_CALLBACKS */
      }
    }
    /* SAI LFSDET interrupt occurred ----------------------------------*/
    else if (((itflags & SAI_FLAG_LFSDET) == SAI_FLAG_LFSDET) && ((itsources & SAI_IT_LFSDET) == SAI_IT_LFSDET))
    {
      /* Clear the SAI LFSDET flag */
      __HAL_SAI_CLEAR_FLAG(hsai, SAI_FLAG_LFSDET);

      /* Change the SAI error code */
      hsai->ErrorCode |= HAL_SAI_ERROR_LFSDET;

      /* Check SAI DMA is enabled or not */
      if ((cr1config & SAI_xCR1_DMAEN) == SAI_xCR1_DMAEN)
      {
        /* Abort the SAI DMA Streams */
        if (hsai->hdmatx != NULL)
        {
          /* Set the DMA Tx abort callback */
          hsai->hdmatx->XferAbortCallback = SAI_DMAAbort;

          /* Abort DMA in IT mode */
          if (HAL_DMA_Abort_IT(hsai->hdmatx) != HAL_OK)
          {
            /* Update SAI error code */
            hsai->ErrorCode |= HAL_SAI_ERROR_DMA;

            /* Call SAI error callback */
#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
            hsai->ErrorCallback(hsai);
#else
            HAL_SAI_ErrorCallback(hsai);
#endif /* USE_HAL_SAI_REGISTER_CALLBACKS */
          }
        }
        if (hsai->hdmarx != NULL)
        {
          /* Set the DMA Rx abort callback */
          hsai->hdmarx->XferAbortCallback = SAI_DMAAbort;

          /* Abort DMA in IT mode */
          if (HAL_DMA_Abort_IT(hsai->hdmarx) != HAL_OK)
          {
            /* Update SAI error code */
            hsai->ErrorCode |= HAL_SAI_ERROR_DMA;

            /* Call SAI error callback */
#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
            hsai->ErrorCallback(hsai);
#else
            HAL_SAI_ErrorCallback(hsai);
#endif /* USE_HAL_SAI_REGISTER_CALLBACKS */
          }
        }
      }
      else
      {
        /* Abort SAI */
        /* No need to check return value because HAL_SAI_ErrorCallback will be called later */
        (void) HAL_SAI_Abort(hsai);

        /* Set error callback */
#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
        hsai->ErrorCallback(hsai);
#else
        HAL_SAI_ErrorCallback(hsai);
#endif /* USE_HAL_SAI_REGISTER_CALLBACKS */
      }
    }
    /* SAI WCKCFG interrupt occurred ----------------------------------*/
    else if (((itflags & SAI_FLAG_WCKCFG) == SAI_FLAG_WCKCFG) && ((itsources & SAI_IT_WCKCFG) == SAI_IT_WCKCFG))
    {
      /* Clear the SAI WCKCFG flag */
      __HAL_SAI_CLEAR_FLAG(hsai, SAI_FLAG_WCKCFG);

      /* Change the SAI error code */
      hsai->ErrorCode |= HAL_SAI_ERROR_WCKCFG;

      /* Check SAI DMA is enabled or not */
      if ((cr1config & SAI_xCR1_DMAEN) == SAI_xCR1_DMAEN)
      {
        /* Abort the SAI DMA Streams */
        if (hsai->hdmatx != NULL)
        {
          /* Set the DMA Tx abort callback */
          hsai->hdmatx->XferAbortCallback = SAI_DMAAbort;

          /* Abort DMA in IT mode */
          if (HAL_DMA_Abort_IT(hsai->hdmatx) != HAL_OK)
          {
            /* Update SAI error code */
            hsai->ErrorCode |= HAL_SAI_ERROR_DMA;

            /* Call SAI error callback */
#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
            hsai->ErrorCallback(hsai);
#else
            HAL_SAI_ErrorCallback(hsai);
#endif /* USE_HAL_SAI_REGISTER_CALLBACKS */
          }
        }
        if (hsai->hdmarx != NULL)
        {
          /* Set the DMA Rx abort callback */
          hsai->hdmarx->XferAbortCallback = SAI_DMAAbort;

          /* Abort DMA in IT mode */
          if (HAL_DMA_Abort_IT(hsai->hdmarx) != HAL_OK)
          {
            /* Update SAI error code */
            hsai->ErrorCode |= HAL_SAI_ERROR_DMA;

            /* Call SAI error callback */
#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
            hsai->ErrorCallback(hsai);
#else
            HAL_SAI_ErrorCallback(hsai);
#endif /* USE_HAL_SAI_REGISTER_CALLBACKS */
          }
        }
      }
      else
      {
        /* If WCKCFG occurs, SAI audio block is automatically disabled */
        /* Disable all interrupts and clear all flags */
        hsai->Instance->IMR = 0U;
        hsai->Instance->CLRFR = 0xFFFFFFFFU;
        /* Set the SAI state to ready to be able to start again the process */
        hsai->State = HAL_SAI_STATE_READY;

        /* Initialize XferCount */
        hsai->XferCount = 0U;

        /* SAI error callback */
#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
        hsai->ErrorCallback(hsai);
#else
        HAL_SAI_ErrorCallback(hsai);
#endif /* USE_HAL_SAI_REGISTER_CALLBACKS */
      }
    }
    /* SAI CNRDY interrupt occurred ----------------------------------*/
    else if (((itflags & SAI_FLAG_CNRDY) == SAI_FLAG_CNRDY) && ((itsources & SAI_IT_CNRDY) == SAI_IT_CNRDY))
    {
      /* Clear the SAI CNRDY flag */
      __HAL_SAI_CLEAR_FLAG(hsai, SAI_FLAG_CNRDY);
      /* Change the SAI error code */
      hsai->ErrorCode |= HAL_SAI_ERROR_CNREADY;
      /* the transfer is not stopped, we will forward the information to the user and we let
      the user decide what needs to be done */
#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
      hsai->ErrorCallback(hsai);
#else
      HAL_SAI_ErrorCallback(hsai);
#endif /* USE_HAL_SAI_REGISTER_CALLBACKS */
    }
    else
    {
      /* Nothing to do */
    }
  }
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_SAI_StateTypeDef HAL_SAI_GetState(const SAI_HandleTypeDef *hsai)
{
  return hsai->State;
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
uint32_t HAL_SAI_GetError(const SAI_HandleTypeDef *hsai)
{
  return hsai->ErrorCode;
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static HAL_StatusTypeDef SAI_InitI2S(SAI_HandleTypeDef *hsai, uint32_t protocol, uint32_t datasize, uint32_t nbslot)
{
  HAL_StatusTypeDef status = HAL_OK;

  hsai->Init.Protocol            = SAI_FREE_PROTOCOL;
  hsai->Init.FirstBit            = SAI_FIRSTBIT_MSB;
  /* Compute ClockStrobing according AudioMode */
  if ((hsai->Init.AudioMode == SAI_MODEMASTER_TX) || (hsai->Init.AudioMode == SAI_MODESLAVE_TX))
  {
    /* Transmit */
    hsai->Init.ClockStrobing     = SAI_CLOCKSTROBING_FALLINGEDGE;
  }
  else
  {
    /* Receive */
    hsai->Init.ClockStrobing     = SAI_CLOCKSTROBING_RISINGEDGE;
  }
  hsai->FrameInit.FSDefinition   = SAI_FS_CHANNEL_IDENTIFICATION;
  hsai->SlotInit.SlotActive      = SAI_SLOTACTIVE_ALL;
  hsai->SlotInit.FirstBitOffset  = 0;
  hsai->SlotInit.SlotNumber      = nbslot;

  /* in IS2 the number of slot must be even */
  if ((nbslot & 0x1U) != 0U)
  {
    return HAL_ERROR;
  }

  if (protocol == SAI_I2S_STANDARD)
  {
    hsai->FrameInit.FSPolarity = SAI_FS_ACTIVE_LOW;
    hsai->FrameInit.FSOffset   = SAI_FS_BEFOREFIRSTBIT;
  }
  else
  {
    /* SAI_I2S_MSBJUSTIFIED or SAI_I2S_LSBJUSTIFIED */
    hsai->FrameInit.FSPolarity = SAI_FS_ACTIVE_HIGH;
    hsai->FrameInit.FSOffset   = SAI_FS_FIRSTBIT;
  }

  /* Frame definition */
  switch (datasize)
  {
    case SAI_PROTOCOL_DATASIZE_16BIT:
      hsai->Init.DataSize = SAI_DATASIZE_16;
      hsai->FrameInit.FrameLength = 32U * (nbslot / 2U);
      hsai->FrameInit.ActiveFrameLength = 16U * (nbslot / 2U);
      hsai->SlotInit.SlotSize = SAI_SLOTSIZE_16B;
      break;
    case SAI_PROTOCOL_DATASIZE_16BITEXTENDED :
      hsai->Init.DataSize = SAI_DATASIZE_16;
      hsai->FrameInit.FrameLength = 64U * (nbslot / 2U);
      hsai->FrameInit.ActiveFrameLength = 32U * (nbslot / 2U);
      hsai->SlotInit.SlotSize = SAI_SLOTSIZE_32B;
      break;
    case SAI_PROTOCOL_DATASIZE_24BIT:
      hsai->Init.DataSize = SAI_DATASIZE_24;
      hsai->FrameInit.FrameLength = 64U * (nbslot / 2U);
      hsai->FrameInit.ActiveFrameLength = 32U * (nbslot / 2U);
      hsai->SlotInit.SlotSize = SAI_SLOTSIZE_32B;
      break;
    case SAI_PROTOCOL_DATASIZE_32BIT:
      hsai->Init.DataSize = SAI_DATASIZE_32;
      hsai->FrameInit.FrameLength = 64U * (nbslot / 2U);
      hsai->FrameInit.ActiveFrameLength = 32U * (nbslot / 2U);
      hsai->SlotInit.SlotSize = SAI_SLOTSIZE_32B;
      break;
    default :
      status = HAL_ERROR;
      break;
  }
  if (protocol == SAI_I2S_LSBJUSTIFIED)
  {
    if (datasize == SAI_PROTOCOL_DATASIZE_16BITEXTENDED)
    {
      hsai->SlotInit.FirstBitOffset = 16;
    }
    if (datasize == SAI_PROTOCOL_DATASIZE_24BIT)
    {
      hsai->SlotInit.FirstBitOffset = 8;
    }
  }
  return status;
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static HAL_StatusTypeDef SAI_InitPCM(SAI_HandleTypeDef *hsai, uint32_t protocol, uint32_t datasize, uint32_t nbslot)
{
  HAL_StatusTypeDef status = HAL_OK;

  hsai->Init.Protocol            = SAI_FREE_PROTOCOL;
  hsai->Init.FirstBit            = SAI_FIRSTBIT_MSB;
  /* Compute ClockStrobing according AudioMode */
  if ((hsai->Init.AudioMode == SAI_MODEMASTER_TX) || (hsai->Init.AudioMode == SAI_MODESLAVE_TX))
  {
    /* Transmit */
    hsai->Init.ClockStrobing     = SAI_CLOCKSTROBING_RISINGEDGE;
  }
  else
  {
    /* Receive */
    hsai->Init.ClockStrobing     = SAI_CLOCKSTROBING_FALLINGEDGE;
  }
  hsai->FrameInit.FSDefinition   = SAI_FS_STARTFRAME;
  hsai->FrameInit.FSPolarity     = SAI_FS_ACTIVE_HIGH;
  hsai->FrameInit.FSOffset       = SAI_FS_BEFOREFIRSTBIT;
  hsai->SlotInit.FirstBitOffset  = 0;
  hsai->SlotInit.SlotNumber      = nbslot;
  hsai->SlotInit.SlotActive      = SAI_SLOTACTIVE_ALL;

  if (protocol == SAI_PCM_SHORT)
  {
    hsai->FrameInit.ActiveFrameLength = 1;
  }
  else
  {
    /* SAI_PCM_LONG */
    hsai->FrameInit.ActiveFrameLength = 13;
  }

  switch (datasize)
  {
    case SAI_PROTOCOL_DATASIZE_16BIT:
      hsai->Init.DataSize = SAI_DATASIZE_16;
      hsai->FrameInit.FrameLength = 16U * nbslot;
      hsai->SlotInit.SlotSize = SAI_SLOTSIZE_16B;
      break;
    case SAI_PROTOCOL_DATASIZE_16BITEXTENDED :
      hsai->Init.DataSize = SAI_DATASIZE_16;
      hsai->FrameInit.FrameLength = 32U * nbslot;
      hsai->SlotInit.SlotSize = SAI_SLOTSIZE_32B;
      break;
    case SAI_PROTOCOL_DATASIZE_24BIT :
      hsai->Init.DataSize = SAI_DATASIZE_24;
      hsai->FrameInit.FrameLength = 32U * nbslot;
      hsai->SlotInit.SlotSize = SAI_SLOTSIZE_32B;
      break;
    case SAI_PROTOCOL_DATASIZE_32BIT:
      hsai->Init.DataSize = SAI_DATASIZE_32;
      hsai->FrameInit.FrameLength = 32U * nbslot;
      hsai->SlotInit.SlotSize = SAI_SLOTSIZE_32B;
      break;
    default :
      status = HAL_ERROR;
      break;
  }

  return status;
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static void SAI_FillFifo(SAI_HandleTypeDef *hsai)
{
  uint32_t temp;

  /* fill the fifo with data before to enabled the SAI */
  while (((hsai->Instance->SR & SAI_xSR_FLVL) != SAI_FIFOSTATUS_FULL) && (hsai->XferCount > 0U))
  {
    if ((hsai->Init.DataSize == SAI_DATASIZE_8) && (hsai->Init.CompandingMode == SAI_NOCOMPANDING))
    {
      hsai->Instance->DR = *hsai->pBuffPtr;
      hsai->pBuffPtr++;
    }
    else if (hsai->Init.DataSize <= SAI_DATASIZE_16)
    {
      temp = (uint32_t)(*hsai->pBuffPtr);
      hsai->pBuffPtr++;
      temp |= ((uint32_t)(*hsai->pBuffPtr) << 8);
      hsai->pBuffPtr++;
      hsai->Instance->DR = temp;
    }
    else
    {
      temp = (uint32_t)(*hsai->pBuffPtr);
      hsai->pBuffPtr++;
      temp |= ((uint32_t)(*hsai->pBuffPtr) << 8);
      hsai->pBuffPtr++;
      temp |= ((uint32_t)(*hsai->pBuffPtr) << 16);
      hsai->pBuffPtr++;
      temp |= ((uint32_t)(*hsai->pBuffPtr) << 24);
      hsai->pBuffPtr++;
      hsai->Instance->DR = temp;
    }
    hsai->XferCount--;
  }
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static uint32_t SAI_InterruptFlag(const SAI_HandleTypeDef *hsai, SAI_ModeTypedef mode)
{
  uint32_t tmpIT = SAI_IT_OVRUDR;

  if (mode == SAI_MODE_IT)
  {
    tmpIT |= SAI_IT_FREQ;
  }

  if ((hsai->Init.Protocol == SAI_AC97_PROTOCOL) &&
      ((hsai->Init.AudioMode == SAI_MODESLAVE_RX) || (hsai->Init.AudioMode == SAI_MODEMASTER_RX)))
  {
    tmpIT |= SAI_IT_CNRDY;
  }

  if ((hsai->Init.AudioMode == SAI_MODESLAVE_RX) || (hsai->Init.AudioMode == SAI_MODESLAVE_TX))
  {
    tmpIT |= SAI_IT_AFSDET | SAI_IT_LFSDET;
  }
  else
  {
    /* hsai has been configured in master mode */
    tmpIT |= SAI_IT_WCKCFG;
  }
  return tmpIT;
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static HAL_StatusTypeDef SAI_Disable(SAI_HandleTypeDef *hsai)
{
  uint32_t count = SAI_DEFAULT_TIMEOUT * (SystemCoreClock / 7U / 1000U);
  HAL_StatusTypeDef status = HAL_OK;

  /* Disable the SAI instance */
  __HAL_SAI_DISABLE(hsai);

  do
  {
    /* Check for the Timeout */
    if (count == 0U)
    {
      /* Update error code */
      hsai->ErrorCode |= HAL_SAI_ERROR_TIMEOUT;
      status = HAL_TIMEOUT;
      break;
    }
    count--;
  } while ((hsai->Instance->CR1 & SAI_xCR1_SAIEN) != 0U);

  return status;
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static void SAI_Transmit_IT8Bit(SAI_HandleTypeDef *hsai)
{
  if (hsai->XferCount == 0U)
  {
    /* Handle the end of the transmission */
    /* Disable FREQ and OVRUDR interrupts */
    __HAL_SAI_DISABLE_IT(hsai, SAI_InterruptFlag(hsai, SAI_MODE_IT));
    hsai->State = HAL_SAI_STATE_READY;
#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
    hsai->TxCpltCallback(hsai);
#else
    HAL_SAI_TxCpltCallback(hsai);
#endif /* USE_HAL_SAI_REGISTER_CALLBACKS */
  }
  else
  {
    /* Write data on DR register */
    hsai->Instance->DR = *hsai->pBuffPtr;
    hsai->pBuffPtr++;
    hsai->XferCount--;
  }
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static void SAI_Transmit_IT16Bit(SAI_HandleTypeDef *hsai)
{
  if (hsai->XferCount == 0U)
  {
    /* Handle the end of the transmission */
    /* Disable FREQ and OVRUDR interrupts */
    __HAL_SAI_DISABLE_IT(hsai, SAI_InterruptFlag(hsai, SAI_MODE_IT));
    hsai->State = HAL_SAI_STATE_READY;
#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
    hsai->TxCpltCallback(hsai);
#else
    HAL_SAI_TxCpltCallback(hsai);
#endif /* USE_HAL_SAI_REGISTER_CALLBACKS */
  }
  else
  {
    /* Write data on DR register */
    uint32_t temp;
    temp = (uint32_t)(*hsai->pBuffPtr);
    hsai->pBuffPtr++;
    temp |= ((uint32_t)(*hsai->pBuffPtr) << 8);
    hsai->pBuffPtr++;
    hsai->Instance->DR = temp;
    hsai->XferCount--;
  }
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static void SAI_Transmit_IT32Bit(SAI_HandleTypeDef *hsai)
{
  if (hsai->XferCount == 0U)
  {
    /* Handle the end of the transmission */
    /* Disable FREQ and OVRUDR interrupts */
    __HAL_SAI_DISABLE_IT(hsai, SAI_InterruptFlag(hsai, SAI_MODE_IT));
    hsai->State = HAL_SAI_STATE_READY;
#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
    hsai->TxCpltCallback(hsai);
#else
    HAL_SAI_TxCpltCallback(hsai);
#endif /* USE_HAL_SAI_REGISTER_CALLBACKS */
  }
  else
  {
    /* Write data on DR register */
    uint32_t temp;
    temp = (uint32_t)(*hsai->pBuffPtr);
    hsai->pBuffPtr++;
    temp |= ((uint32_t)(*hsai->pBuffPtr) << 8);
    hsai->pBuffPtr++;
    temp |= ((uint32_t)(*hsai->pBuffPtr) << 16);
    hsai->pBuffPtr++;
    temp |= ((uint32_t)(*hsai->pBuffPtr) << 24);
    hsai->pBuffPtr++;
    hsai->Instance->DR = temp;
    hsai->XferCount--;
  }
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static void SAI_Receive_IT8Bit(SAI_HandleTypeDef *hsai)
{
  /* Receive data */
  *hsai->pBuffPtr = (uint8_t)hsai->Instance->DR;
  hsai->pBuffPtr++;
  hsai->XferCount--;

  /* Check end of the transfer */
  if (hsai->XferCount == 0U)
  {
    /* Disable TXE and OVRUDR interrupts */
    __HAL_SAI_DISABLE_IT(hsai, SAI_InterruptFlag(hsai, SAI_MODE_IT));

    /* Clear the SAI Overrun flag */
    __HAL_SAI_CLEAR_FLAG(hsai, SAI_FLAG_OVRUDR);

    hsai->State = HAL_SAI_STATE_READY;
#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
    hsai->RxCpltCallback(hsai);
#else
    HAL_SAI_RxCpltCallback(hsai);
#endif /* USE_HAL_SAI_REGISTER_CALLBACKS */
  }
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static void SAI_Receive_IT16Bit(SAI_HandleTypeDef *hsai)
{
  uint32_t temp;

  /* Receive data */
  temp = hsai->Instance->DR;
  *hsai->pBuffPtr = (uint8_t)temp;
  hsai->pBuffPtr++;
  *hsai->pBuffPtr = (uint8_t)(temp >> 8);
  hsai->pBuffPtr++;
  hsai->XferCount--;

  /* Check end of the transfer */
  if (hsai->XferCount == 0U)
  {
    /* Disable TXE and OVRUDR interrupts */
    __HAL_SAI_DISABLE_IT(hsai, SAI_InterruptFlag(hsai, SAI_MODE_IT));

    /* Clear the SAI Overrun flag */
    __HAL_SAI_CLEAR_FLAG(hsai, SAI_FLAG_OVRUDR);

    hsai->State = HAL_SAI_STATE_READY;
#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
    hsai->RxCpltCallback(hsai);
#else
    HAL_SAI_RxCpltCallback(hsai);
#endif /* USE_HAL_SAI_REGISTER_CALLBACKS */
  }
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static void SAI_Receive_IT32Bit(SAI_HandleTypeDef *hsai)
{
  uint32_t temp;

  /* Receive data */
  temp = hsai->Instance->DR;
  *hsai->pBuffPtr = (uint8_t)temp;
  hsai->pBuffPtr++;
  *hsai->pBuffPtr = (uint8_t)(temp >> 8);
  hsai->pBuffPtr++;
  *hsai->pBuffPtr = (uint8_t)(temp >> 16);
  hsai->pBuffPtr++;
  *hsai->pBuffPtr = (uint8_t)(temp >> 24);
  hsai->pBuffPtr++;
  hsai->XferCount--;

  /* Check end of the transfer */
  if (hsai->XferCount == 0U)
  {
    /* Disable TXE and OVRUDR interrupts */
    __HAL_SAI_DISABLE_IT(hsai, SAI_InterruptFlag(hsai, SAI_MODE_IT));

    /* Clear the SAI Overrun flag */
    __HAL_SAI_CLEAR_FLAG(hsai, SAI_FLAG_OVRUDR);

    hsai->State = HAL_SAI_STATE_READY;
#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
    hsai->RxCpltCallback(hsai);
#else
    HAL_SAI_RxCpltCallback(hsai);
#endif /* USE_HAL_SAI_REGISTER_CALLBACKS */
  }
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static void SAI_DMATxCplt(DMA_HandleTypeDef *hdma)
{
  SAI_HandleTypeDef *hsai = (SAI_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  /* Check if DMA in circular mode */
  if (hdma->Mode != DMA_LINKEDLIST_CIRCULAR)
  {
    hsai->XferCount = 0;

    /* Disable SAI Tx DMA Request */
    hsai->Instance->CR1 &= (uint32_t)(~SAI_xCR1_DMAEN);

    /* Stop the interrupts error handling */
    __HAL_SAI_DISABLE_IT(hsai, SAI_InterruptFlag(hsai, SAI_MODE_DMA));

    hsai->State = HAL_SAI_STATE_READY;
  }

#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
  hsai->TxCpltCallback(hsai);
#else
  HAL_SAI_TxCpltCallback(hsai);
#endif /* USE_HAL_SAI_REGISTER_CALLBACKS */
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static void SAI_DMATxHalfCplt(DMA_HandleTypeDef *hdma)
{
  SAI_HandleTypeDef *hsai = (SAI_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
  hsai->TxHalfCpltCallback(hsai);
#else
  HAL_SAI_TxHalfCpltCallback(hsai);
#endif /* USE_HAL_SAI_REGISTER_CALLBACKS */
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static void SAI_DMARxCplt(DMA_HandleTypeDef *hdma)
{
  SAI_HandleTypeDef *hsai = (SAI_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  /* Check if DMA in circular mode*/
  if (hdma->Mode != DMA_LINKEDLIST_CIRCULAR)
  {
    /* Disable Rx DMA Request */
    hsai->Instance->CR1 &= (uint32_t)(~SAI_xCR1_DMAEN);
    hsai->XferCount = 0;

    /* Stop the interrupts error handling */
    __HAL_SAI_DISABLE_IT(hsai, SAI_InterruptFlag(hsai, SAI_MODE_DMA));

    hsai->State = HAL_SAI_STATE_READY;
  }

#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
  hsai->RxCpltCallback(hsai);
#else
  HAL_SAI_RxCpltCallback(hsai);
#endif /* USE_HAL_SAI_REGISTER_CALLBACKS */
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static void SAI_DMARxHalfCplt(DMA_HandleTypeDef *hdma)
{
  SAI_HandleTypeDef *hsai = (SAI_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
  hsai->RxHalfCpltCallback(hsai);
#else
  HAL_SAI_RxHalfCpltCallback(hsai);
#endif /* USE_HAL_SAI_REGISTER_CALLBACKS */
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static void SAI_DMAError(DMA_HandleTypeDef *hdma)
{
  SAI_HandleTypeDef *hsai = (SAI_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  /* Set SAI error code */
  hsai->ErrorCode |= HAL_SAI_ERROR_DMA;

  /* Disable the SAI DMA request */
  hsai->Instance->CR1 &= ~SAI_xCR1_DMAEN;

  /* Disable SAI peripheral */
  /* No need to check return value because state will be updated and HAL_SAI_ErrorCallback will be called later */
  (void) SAI_Disable(hsai);

  /* Set the SAI state ready to be able to start again the process */
  hsai->State = HAL_SAI_STATE_READY;

  /* Initialize XferCount */
  hsai->XferCount = 0U;

  /* SAI error Callback */
#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
  hsai->ErrorCallback(hsai);
#else
  HAL_SAI_ErrorCallback(hsai);
#endif /* USE_HAL_SAI_REGISTER_CALLBACKS */
}
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static void SAI_DMAAbort(DMA_HandleTypeDef *hdma)
{
  SAI_HandleTypeDef *hsai = (SAI_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  /* Disable DMA request */
  hsai->Instance->CR1 &= ~SAI_xCR1_DMAEN;

  /* Disable all interrupts and clear all flags */
  hsai->Instance->IMR = 0U;
  hsai->Instance->CLRFR = 0xFFFFFFFFU;

  if (hsai->ErrorCode != HAL_SAI_ERROR_WCKCFG)
  {
    /* Disable SAI peripheral */
    /* No need to check return value because state will be updated and HAL_SAI_ErrorCallback will be called later */
    (void) SAI_Disable(hsai);

    /* Flush the fifo */
    SET_BIT(hsai->Instance->CR2, SAI_xCR2_FFLUSH);
  }
  /* Set the SAI state to ready to be able to start again the process */
  hsai->State = HAL_SAI_STATE_READY;

  /* Initialize XferCount */
  hsai->XferCount = 0U;

  /* SAI error Callback */
#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
  hsai->ErrorCallback(hsai);
#else
  HAL_SAI_ErrorCallback(hsai);
#endif /* USE_HAL_SAI_REGISTER_CALLBACKS */
}
#endif
