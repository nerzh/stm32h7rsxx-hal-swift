// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Unchanged function bodies from HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.

HAL_StatusTypeDef HAL_GFXMMU_Init(GFXMMU_HandleTypeDef *hgfxmmu)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check GFXMMU handle */
  if (hgfxmmu == NULL)
  {
    status = HAL_ERROR;
  }
  else
  {
    /* Check parameters */
    assert_param(IS_GFXMMU_ALL_INSTANCE(hgfxmmu->Instance));
    assert_param(IS_GFXMMU_BLOCK_SIZE(hgfxmmu->Init.BlockSize));
    assert_param(IS_FUNCTIONAL_STATE(hgfxmmu->Init.AddressTranslation));
    assert_param(IS_GFXMMU_BUFFER_ADDRESS(hgfxmmu->Init.Buffers.Buf0Address));
    assert_param(IS_GFXMMU_BUFFER_ADDRESS(hgfxmmu->Init.Buffers.Buf1Address));
    assert_param(IS_GFXMMU_BUFFER_ADDRESS(hgfxmmu->Init.Buffers.Buf2Address));
    assert_param(IS_GFXMMU_BUFFER_ADDRESS(hgfxmmu->Init.Buffers.Buf3Address));
    assert_param(IS_FUNCTIONAL_STATE(hgfxmmu->Init.Interrupts.Activation));

#if (USE_HAL_GFXMMU_REGISTER_CALLBACKS == 1)
    /* Reset callback pointers to the weak predefined callbacks */
    hgfxmmu->ErrorCallback = HAL_GFXMMU_ErrorCallback;

    /* Call GFXMMU MSP init function */
    if (hgfxmmu->MspInitCallback == NULL)
    {
      hgfxmmu->MspInitCallback = HAL_GFXMMU_MspInit;
    }
    hgfxmmu->MspInitCallback(hgfxmmu);
#else
    /* Call GFXMMU MSP init function */
    HAL_GFXMMU_MspInit(hgfxmmu);
#endif /* USE_HAL_GFXMMU_REGISTER_CALLBACKS == 1 */

    /* Configure GFXMMU_CR register */
    hgfxmmu->Instance->CR = 0U;
    hgfxmmu->Instance->CR |= (hgfxmmu->Init.BlockSize);
    if (hgfxmmu->Init.AddressTranslation == ENABLE)
    {
      hgfxmmu->Instance->CR |= GFXMMU_CR_ATE;
    }
    if (hgfxmmu->Init.Interrupts.Activation == ENABLE)
    {
      assert_param(IS_GFXMMU_INTERRUPTS(hgfxmmu->Init.Interrupts.UsedInterrupts));
      hgfxmmu->Instance->CR |= hgfxmmu->Init.Interrupts.UsedInterrupts;
    }

    /* Configure default value on GFXMMU_DVR register */
    hgfxmmu->Instance->DVR = hgfxmmu->Init.DefaultValue;

    /* Configure physical buffer addresses on GFXMMU_BxCR registers */
    hgfxmmu->Instance->B0CR = hgfxmmu->Init.Buffers.Buf0Address;
    hgfxmmu->Instance->B1CR = hgfxmmu->Init.Buffers.Buf1Address;
    hgfxmmu->Instance->B2CR = hgfxmmu->Init.Buffers.Buf2Address;
    hgfxmmu->Instance->B3CR = hgfxmmu->Init.Buffers.Buf3Address;

    /* Reset GFXMMU error code */
    hgfxmmu->ErrorCode = GFXMMU_ERROR_NONE;

    /* Set GFXMMU to ready state */
    hgfxmmu->State = HAL_GFXMMU_STATE_READY;
  }
  /* Return function status */
  return status;
}

HAL_StatusTypeDef HAL_GFXMMU_DeInit(GFXMMU_HandleTypeDef *hgfxmmu)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check GFXMMU handle */
  if (hgfxmmu == NULL)
  {
    status = HAL_ERROR;
  }
  else
  {
    /* Check parameters */
    assert_param(IS_GFXMMU_ALL_INSTANCE(hgfxmmu->Instance));

    /* Disable all interrupts on GFXMMU_CR register */
    hgfxmmu->Instance->CR &= ~(GFXMMU_CR_B0OIE | GFXMMU_CR_B1OIE | GFXMMU_CR_B2OIE | GFXMMU_CR_B3OIE |
                               GFXMMU_CR_AMEIE);

    /* Call GFXMMU MSP de-init function */
#if (USE_HAL_GFXMMU_REGISTER_CALLBACKS == 1)
    if (hgfxmmu->MspDeInitCallback == NULL)
    {
      hgfxmmu->MspDeInitCallback = HAL_GFXMMU_MspDeInit;
    }
    hgfxmmu->MspDeInitCallback(hgfxmmu);
#else
    HAL_GFXMMU_MspDeInit(hgfxmmu);
#endif /* USE_HAL_GFXMMU_REGISTER_CALLBACKS == 1 */

    /* Set GFXMMU to reset state */
    hgfxmmu->State = HAL_GFXMMU_STATE_RESET;
  }
  /* Return function status */
  return status;
}

#if USE_HAL_GFXMMU_REGISTER_CALLBACKS
HAL_StatusTypeDef HAL_GFXMMU_RegisterCallback(GFXMMU_HandleTypeDef        *hgfxmmu,
                                              HAL_GFXMMU_CallbackIDTypeDef CallbackID,
                                              pGFXMMU_CallbackTypeDef      pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* update the error code */
    hgfxmmu->ErrorCode |= GFXMMU_ERROR_INVALID_CALLBACK;
    /* update return status */
    status = HAL_ERROR;
  }
  else
  {
    if (HAL_GFXMMU_STATE_READY == hgfxmmu->State)
    {
      switch (CallbackID)
      {
        case HAL_GFXMMU_ERROR_CB_ID :
          hgfxmmu->ErrorCallback = pCallback;
          break;
        case HAL_GFXMMU_MSPINIT_CB_ID :
          hgfxmmu->MspInitCallback = pCallback;
          break;
        case HAL_GFXMMU_MSPDEINIT_CB_ID :
          hgfxmmu->MspDeInitCallback = pCallback;
          break;
        default :
          /* update the error code */
          hgfxmmu->ErrorCode |= GFXMMU_ERROR_INVALID_CALLBACK;
          /* update return status */
          status = HAL_ERROR;
          break;
      }
    }
    else if (HAL_GFXMMU_STATE_RESET == hgfxmmu->State)
    {
      switch (CallbackID)
      {
        case HAL_GFXMMU_MSPINIT_CB_ID :
          hgfxmmu->MspInitCallback = pCallback;
          break;
        case HAL_GFXMMU_MSPDEINIT_CB_ID :
          hgfxmmu->MspDeInitCallback = pCallback;
          break;
        default :
          /* update the error code */
          hgfxmmu->ErrorCode |= GFXMMU_ERROR_INVALID_CALLBACK;
          /* update return status */
          status = HAL_ERROR;
          break;
      }
    }
    else
    {
      /* update the error code */
      hgfxmmu->ErrorCode |= GFXMMU_ERROR_INVALID_CALLBACK;
      /* update return status */
      status = HAL_ERROR;
    }
  }
  return status;
}
#endif

#if USE_HAL_GFXMMU_REGISTER_CALLBACKS
HAL_StatusTypeDef HAL_GFXMMU_UnRegisterCallback(GFXMMU_HandleTypeDef        *hgfxmmu,
                                                HAL_GFXMMU_CallbackIDTypeDef CallbackID)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (HAL_GFXMMU_STATE_READY == hgfxmmu->State)
  {
    switch (CallbackID)
    {
      case HAL_GFXMMU_ERROR_CB_ID :
        hgfxmmu->ErrorCallback = HAL_GFXMMU_ErrorCallback;
        break;
      case HAL_GFXMMU_MSPINIT_CB_ID :
        hgfxmmu->MspInitCallback = HAL_GFXMMU_MspInit;
        break;
      case HAL_GFXMMU_MSPDEINIT_CB_ID :
        hgfxmmu->MspDeInitCallback = HAL_GFXMMU_MspDeInit;
        break;
      default :
        /* update the error code */
        hgfxmmu->ErrorCode |= GFXMMU_ERROR_INVALID_CALLBACK;
        /* update return status */
        status = HAL_ERROR;
        break;
    }
  }
  else if (HAL_GFXMMU_STATE_RESET == hgfxmmu->State)
  {
    switch (CallbackID)
    {
      case HAL_GFXMMU_MSPINIT_CB_ID :
        hgfxmmu->MspInitCallback = HAL_GFXMMU_MspInit;
        break;
      case HAL_GFXMMU_MSPDEINIT_CB_ID :
        hgfxmmu->MspDeInitCallback = HAL_GFXMMU_MspDeInit;
        break;
      default :
        /* update the error code */
        hgfxmmu->ErrorCode |= GFXMMU_ERROR_INVALID_CALLBACK;
        /* update return status */
        status = HAL_ERROR;
        break;
    }
  }
  else
  {
    /* update the error code */
    hgfxmmu->ErrorCode |= GFXMMU_ERROR_INVALID_CALLBACK;
    /* update return status */
    status = HAL_ERROR;
  }
  return status;
}
#endif

HAL_StatusTypeDef HAL_GFXMMU_ConfigLut(const GFXMMU_HandleTypeDef *hgfxmmu,
                                       uint32_t FirstLine,
                                       uint32_t LinesNumber,
                                       uint32_t Address)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check parameters */
  assert_param(IS_GFXMMU_ALL_INSTANCE(hgfxmmu->Instance));
  assert_param(IS_GFXMMU_LUT_LINE(FirstLine));
  assert_param(IS_GFXMMU_LUT_LINES_NUMBER(LinesNumber));

  /* Check GFXMMU state and coherent parameters */
  if ((hgfxmmu->State != HAL_GFXMMU_STATE_READY) || ((FirstLine + LinesNumber) > 1024U))
  {
    status = HAL_ERROR;
  }
  /* Check address translation status */
  else if ((hgfxmmu->Instance->CR & GFXMMU_CR_ATE) == 0U)
  {
    status = HAL_ERROR;
  }
  else
  {
    uint32_t current_address;
    uint32_t current_line;
    uint32_t lutxl_address;
    uint32_t lutxh_address;

    /* Initialize local variables */
    current_address = Address;
    current_line    = 0U;
    lutxl_address   = (uint32_t) &(hgfxmmu->Instance->LUT[2U * FirstLine]);
    lutxh_address   = (uint32_t) &(hgfxmmu->Instance->LUT[(2U * FirstLine) + 1U]);

    /* Copy LUT from flash to look up RAM */
    while (current_line < LinesNumber)
    {
      *((uint32_t *)lutxl_address) = *((uint32_t *)current_address);
      current_address += 4U;
      *((uint32_t *)lutxh_address) = *((uint32_t *)current_address);
      current_address += 4U;
      lutxl_address += 8U;
      lutxh_address += 8U;
      current_line++;
    }
  }
  /* Return function status */
  return status;
}

HAL_StatusTypeDef HAL_GFXMMU_DisableLutLines(const GFXMMU_HandleTypeDef *hgfxmmu,
                                             uint32_t FirstLine,
                                             uint32_t LinesNumber)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check parameters */
  assert_param(IS_GFXMMU_ALL_INSTANCE(hgfxmmu->Instance));
  assert_param(IS_GFXMMU_LUT_LINE(FirstLine));
  assert_param(IS_GFXMMU_LUT_LINES_NUMBER(LinesNumber));

  /* Check GFXMMU state and coherent parameters */
  if ((hgfxmmu->State != HAL_GFXMMU_STATE_READY) || ((FirstLine + LinesNumber) > 1024U))
  {
    status = HAL_ERROR;
  }
  /* Check address translation status */
  else if ((hgfxmmu->Instance->CR & GFXMMU_CR_ATE) == 0U)
  {
    status = HAL_ERROR;
  }
  else
  {
    uint32_t current_line;
    uint32_t lutxl_address;
    uint32_t lutxh_address;

    /* Initialize local variables */
    current_line    = 0U;
    lutxl_address   = (uint32_t) &(hgfxmmu->Instance->LUT[2U * FirstLine]);
    lutxh_address   = (uint32_t) &(hgfxmmu->Instance->LUT[(2U * FirstLine) + 1U]);

    /* Disable LUT lines */
    while (current_line < LinesNumber)
    {
      *((uint32_t *)lutxl_address) = 0U;
      *((uint32_t *)lutxh_address) = 0U;
      lutxl_address += 8U;
      lutxh_address += 8U;
      current_line++;
    }
  }
  /* Return function status */
  return status;
}

HAL_StatusTypeDef HAL_GFXMMU_ConfigLutLine(const GFXMMU_HandleTypeDef *hgfxmmu, const GFXMMU_LutLineTypeDef *lutLine)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check parameters */
  assert_param(IS_GFXMMU_ALL_INSTANCE(hgfxmmu->Instance));
  assert_param(IS_GFXMMU_LUT_LINE(lutLine->LineNumber));
  assert_param(IS_GFXMMU_LUT_LINE_STATUS(lutLine->LineStatus));
  assert_param(IS_GFXMMU_LUT_BLOCK(lutLine->FirstVisibleBlock));
  assert_param(IS_GFXMMU_LUT_BLOCK(lutLine->LastVisibleBlock));
  assert_param(IS_GFXMMU_LUT_LINE_OFFSET(lutLine->LineOffset));

  /* Check GFXMMU state */
  if (hgfxmmu->State != HAL_GFXMMU_STATE_READY)
  {
    status = HAL_ERROR;
  }
  /* Check address translation status */
  else if ((hgfxmmu->Instance->CR & GFXMMU_CR_ATE) == 0U)
  {
    status = HAL_ERROR;
  }
  else
  {
    uint32_t lutxl_address;
    uint32_t lutxh_address;

    /* Initialize local variables */
    lutxl_address   = (uint32_t) &(hgfxmmu->Instance->LUT[2U * lutLine->LineNumber]);
    lutxh_address   = (uint32_t) &(hgfxmmu->Instance->LUT[(2U * lutLine->LineNumber) + 1U]);

    /* Configure LUT line */
    if (lutLine->LineStatus == GFXMMU_LUT_LINE_ENABLE)
    {
      /* Enable and configure LUT line */
      *((uint32_t *)lutxl_address) = (lutLine->LineStatus |
                                      (lutLine->FirstVisibleBlock << GFXMMU_LUTXL_FVB_OFFSET) |
                                      (lutLine->LastVisibleBlock << GFXMMU_LUTXL_LVB_OFFSET));
      *((uint32_t *)lutxh_address) = (uint32_t) lutLine->LineOffset;
    }
    else
    {
      /* Disable LUT line */
      *((uint32_t *)lutxl_address) = 0U;
      *((uint32_t *)lutxh_address) = 0U;
    }
  }
  /* Return function status */
  return status;
}

HAL_StatusTypeDef HAL_GFXMMU_ModifyBuffers(GFXMMU_HandleTypeDef *hgfxmmu, const GFXMMU_BuffersTypeDef *Buffers)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check parameters */
  assert_param(IS_GFXMMU_ALL_INSTANCE(hgfxmmu->Instance));
  assert_param(IS_GFXMMU_BUFFER_ADDRESS(Buffers->Buf0Address));
  assert_param(IS_GFXMMU_BUFFER_ADDRESS(Buffers->Buf1Address));
  assert_param(IS_GFXMMU_BUFFER_ADDRESS(Buffers->Buf2Address));
  assert_param(IS_GFXMMU_BUFFER_ADDRESS(Buffers->Buf3Address));

  /* Check GFXMMU state */
  if (hgfxmmu->State != HAL_GFXMMU_STATE_READY)
  {
    status = HAL_ERROR;
  }
  else
  {
    /* Modify physical buffer addresses on GFXMMU_BxCR registers */
    hgfxmmu->Instance->B0CR = Buffers->Buf0Address;
    hgfxmmu->Instance->B1CR = Buffers->Buf1Address;
    hgfxmmu->Instance->B2CR = Buffers->Buf2Address;
    hgfxmmu->Instance->B3CR = Buffers->Buf3Address;
  }
  /* Return function status */
  return status;
}

HAL_StatusTypeDef HAL_GFXMMU_ConfigPacking(GFXMMU_HandleTypeDef *hgfxmmu, const GFXMMU_PackingTypeDef *pPacking)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check parameters */
  assert_param(IS_GFXMMU_ALL_INSTANCE(hgfxmmu->Instance));
  assert_param(IS_FUNCTIONAL_STATE(pPacking->Buffer0Activation));
  assert_param(IS_FUNCTIONAL_STATE(pPacking->Buffer1Activation));
  assert_param(IS_FUNCTIONAL_STATE(pPacking->Buffer2Activation));
  assert_param(IS_FUNCTIONAL_STATE(pPacking->Buffer3Activation));
  assert_param(IS_GFXMMU_PACKING_MODE(pPacking->Buffer0Mode));
  assert_param(IS_GFXMMU_PACKING_MODE(pPacking->Buffer1Mode));
  assert_param(IS_GFXMMU_PACKING_MODE(pPacking->Buffer2Mode));
  assert_param(IS_GFXMMU_PACKING_MODE(pPacking->Buffer3Mode));
  assert_param(IS_GFXMMU_DEFAULT_ALPHA_VALUE(pPacking->DefaultAlpha));

  /* Check GFXMMU state */
  if (hgfxmmu->State != HAL_GFXMMU_STATE_READY)
  {
    status = HAL_ERROR;
  }
  /* Check block size is set to 12-byte*/
  else if ((hgfxmmu->Instance->CR & GFXMMU_CR_BS) == 0U)
  {
    status = HAL_ERROR;
  }
  else
  {
    uint32_t reg_value = 0U;

    /* Configure packing for all buffers on GFXMMU_CR register */
    if (pPacking->Buffer0Activation == ENABLE)
    {
      reg_value |= ((pPacking->Buffer0Mode << GFXMMU_CR_B0PM_Pos) | GFXMMU_CR_B0PE);
    }
    if (pPacking->Buffer1Activation == ENABLE)
    {
      reg_value |= ((pPacking->Buffer1Mode << GFXMMU_CR_B1PM_Pos) | GFXMMU_CR_B1PE);
    }
    if (pPacking->Buffer2Activation == ENABLE)
    {
      reg_value |= ((pPacking->Buffer2Mode << GFXMMU_CR_B2PM_Pos) | GFXMMU_CR_B2PE);
    }
    if (pPacking->Buffer3Activation == ENABLE)
    {
      reg_value |= ((pPacking->Buffer3Mode << GFXMMU_CR_B3PM_Pos) | GFXMMU_CR_B3PE);
    }
    hgfxmmu->Instance->CR &= ~(GFXMMU_CR_B0PE_Msk | GFXMMU_CR_B0PM_Msk |
                               GFXMMU_CR_B1PE_Msk | GFXMMU_CR_B1PM_Msk |
                               GFXMMU_CR_B2PE_Msk | GFXMMU_CR_B2PM_Msk |
                               GFXMMU_CR_B3PE_Msk | GFXMMU_CR_B3PM_Msk);
    hgfxmmu->Instance->CR |= reg_value;

    /* Configure default alpha value on GFXMMU_DAR register */
    hgfxmmu->Instance->DAR = pPacking->DefaultAlpha;
  }
  /* Return function status */
  return status;
}

void HAL_GFXMMU_IRQHandler(GFXMMU_HandleTypeDef *hgfxmmu)
{
  uint32_t flags, interrupts, error;

  /* Read current flags and interrupts and determine which error occurs */
  flags = hgfxmmu->Instance->SR;
  interrupts = (hgfxmmu->Instance->CR & GFXMMU_CR_ITS_MASK);
  error = (flags & interrupts);

  if (error != 0U)
  {
    /* Clear flags on GFXMMU_FCR register */
    hgfxmmu->Instance->FCR = error;

    /* Update GFXMMU error code */
    hgfxmmu->ErrorCode |= error;

    /* Call GFXMMU error callback */
#if (USE_HAL_GFXMMU_REGISTER_CALLBACKS == 1)
    hgfxmmu->ErrorCallback(hgfxmmu);
#else
    HAL_GFXMMU_ErrorCallback(hgfxmmu);
#endif /* USE_HAL_GFXMMU_REGISTER_CALLBACKS == 1 */
  }
}

HAL_GFXMMU_StateTypeDef HAL_GFXMMU_GetState(const GFXMMU_HandleTypeDef *hgfxmmu)
{
  /* Return GFXMMU handle state */
  return hgfxmmu->State;
}

uint32_t HAL_GFXMMU_GetError(GFXMMU_HandleTypeDef *hgfxmmu)
{
  uint32_t error_code;
  uint32_t primask = __get_PRIMASK();

  /* Enter in critical section */
  __disable_irq();

  /* Store and reset GFXMMU error code */
  error_code = hgfxmmu->ErrorCode;
  hgfxmmu->ErrorCode = GFXMMU_ERROR_NONE;

  /* Exit from critical section */
  __set_PRIMASK(primask);

  /* Return GFXMMU error code */
  return error_code;
}
