// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// XSPI/XSPIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_Init(XSPI_HandleTypeDef *hxspi)
{
  HAL_StatusTypeDef status = HAL_OK;
  uint32_t tickstart = HAL_GetTick();

  /* Check the XSPI handle allocation */
  if (hxspi == NULL)
  {
    status = HAL_ERROR;
    /* No error code can be set set as the handler is null */
  }
  else
  {
    /* Check the parameters of the initialization structure */
    assert_param(IS_XSPI_MEMORY_MODE(hxspi->Init.MemoryMode));
    assert_param(IS_XSPI_MEMORY_TYPE(hxspi->Init.MemoryType));
    assert_param(IS_XSPI_MEMORY_SIZE(hxspi->Init.MemorySize));
    assert_param(IS_XSPI_CS_HIGH_TIME_CYCLE(hxspi->Init.ChipSelectHighTimeCycle));
    assert_param(IS_XSPI_FREE_RUN_CLK(hxspi->Init.FreeRunningClock));
    assert_param(IS_XSPI_CLOCK_MODE(hxspi->Init.ClockMode));
    assert_param(IS_XSPI_WRAP_SIZE(hxspi->Init.WrapSize));
    assert_param(IS_XSPI_CLK_PRESCALER(hxspi->Init.ClockPrescaler));
    assert_param(IS_XSPI_SAMPLE_SHIFTING(hxspi->Init.SampleShifting));
    assert_param(IS_XSPI_CS_BOUND(hxspi->Init.ChipSelectBoundary));
    assert_param(IS_XSPI_FIFO_THRESHOLD_BYTE(hxspi->Init.FifoThresholdByte));
    assert_param(IS_XSPI_MAXTRAN(hxspi->Init.MaxTran));
    assert_param(IS_XSPI_CSSEL(hxspi->Init.MemorySelect));
    /* Initialize error code */
    hxspi->ErrorCode = HAL_XSPI_ERROR_NONE;

    /* Check if the state is the reset state */
    if (hxspi->State == HAL_XSPI_STATE_RESET)
    {
#if defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U)
      /* Reset Callback pointers in HAL_XSPI_STATE_RESET only */
      hxspi->ErrorCallback         = HAL_XSPI_ErrorCallback;
      hxspi->AbortCpltCallback     = HAL_XSPI_AbortCpltCallback;
      hxspi->FifoThresholdCallback = HAL_XSPI_FifoThresholdCallback;
      hxspi->CmdCpltCallback       = HAL_XSPI_CmdCpltCallback;
      hxspi->RxCpltCallback        = HAL_XSPI_RxCpltCallback;
      hxspi->TxCpltCallback        = HAL_XSPI_TxCpltCallback;
      hxspi->RxHalfCpltCallback    = HAL_XSPI_RxHalfCpltCallback;
      hxspi->TxHalfCpltCallback    = HAL_XSPI_TxHalfCpltCallback;
      hxspi->StatusMatchCallback   = HAL_XSPI_StatusMatchCallback;
      hxspi->TimeOutCallback       = HAL_XSPI_TimeOutCallback;

      if (hxspi->MspInitCallback == NULL)
      {
        hxspi->MspInitCallback = HAL_XSPI_MspInit;
      }

      /* Init the low level hardware */
      hxspi->MspInitCallback(hxspi);
#else
      /* Initialization of the low level hardware */
      HAL_XSPI_MspInit(hxspi);
#endif /* defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U) */

      /* Configure the default timeout for the XSPI memory access */
      (void)HAL_XSPI_SetTimeout(hxspi, HAL_XSPI_TIMEOUT_DEFAULT_VALUE);

      /* Configure memory type, device size, chip select high time, free running clock, clock mode */
      MODIFY_REG(hxspi->Instance->DCR1,
                 (XSPI_DCR1_MTYP | XSPI_DCR1_DEVSIZE | XSPI_DCR1_CSHT | XSPI_DCR1_FRCK | XSPI_DCR1_CKMODE),
                 (hxspi->Init.MemoryType | ((hxspi->Init.MemorySize) << XSPI_DCR1_DEVSIZE_Pos) |
                  ((hxspi->Init.ChipSelectHighTimeCycle - 1U) << XSPI_DCR1_CSHT_Pos) | hxspi->Init.ClockMode));

      /* Configure wrap size */
      MODIFY_REG(hxspi->Instance->DCR2, XSPI_DCR2_WRAPSIZE, hxspi->Init.WrapSize);

      /* Configure chip select boundary */
      MODIFY_REG(hxspi->Instance->DCR3, XSPI_DCR3_CSBOUND, (hxspi->Init.ChipSelectBoundary << XSPI_DCR3_CSBOUND_Pos));

      /* Configure maximum transfer */
      MODIFY_REG(hxspi->Instance->DCR3, XSPI_DCR3_MAXTRAN, \
                 (hxspi->Init.MaxTran << XSPI_DCR3_MAXTRAN_Pos));

      /* Configure refresh */
      hxspi->Instance->DCR4 = hxspi->Init.Refresh;

      /* Configure FIFO threshold */
      MODIFY_REG(hxspi->Instance->CR, XSPI_CR_FTHRES, ((hxspi->Init.FifoThresholdByte - 1U) << XSPI_CR_FTHRES_Pos));

      /* Wait till busy flag is reset */
      status = XSPI_WaitFlagStateUntilTimeout(hxspi, HAL_XSPI_FLAG_BUSY, RESET, tickstart, hxspi->Timeout);

      if (status == HAL_OK)
      {
        /* Configure clock prescaler */
        MODIFY_REG(hxspi->Instance->DCR2, XSPI_DCR2_PRESCALER,
                   ((hxspi->Init.ClockPrescaler) << XSPI_DCR2_PRESCALER_Pos));

        if (IS_XSPI_ALL_INSTANCE(hxspi->Instance))
        {
          /* The configuration of clock prescaler trigger automatically a calibration process.
          So it is necessary to wait the calibration is complete */
          status = XSPI_WaitFlagStateUntilTimeout(hxspi, HAL_XSPI_FLAG_BUSY, RESET, tickstart, hxspi->Timeout);
          if (status != HAL_OK)
          {
            return status;
          }
        }
        /* Configure Dual Memory mode and CS Selection */
        MODIFY_REG(hxspi->Instance->CR, (XSPI_CR_DMM | XSPI_CR_CSSEL),
                   (hxspi->Init.MemoryMode | hxspi->Init.MemorySelect));

        /* Configure sample shifting */
        MODIFY_REG(hxspi->Instance->TCR, (XSPI_TCR_SSHIFT), hxspi->Init.SampleShifting);

        /* Enable XSPI */
        HAL_XSPI_ENABLE(hxspi);

        /* Enable free running clock if needed : must be done after XSPI enable */
        if (hxspi->Init.FreeRunningClock == HAL_XSPI_FREERUNCLK_ENABLE)
        {
          SET_BIT(hxspi->Instance->DCR1, XSPI_DCR1_FRCK);
        }

        /* Initialize the XSPI state */
        if (hxspi->Init.MemoryType == HAL_XSPI_MEMTYPE_HYPERBUS)
        {
          hxspi->State = HAL_XSPI_STATE_HYPERBUS_INIT;
        }
        else
        {
          hxspi->State = HAL_XSPI_STATE_READY;
        }
      }
    }
  }
  return status;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_DeInit(XSPI_HandleTypeDef *hxspi)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the XSPI handle allocation */
  if (hxspi == NULL)
  {
    status = HAL_ERROR;
    /* No error code can be set as the handler is null */
  }
  else
  {
    /* Disable XSPI */
    HAL_XSPI_DISABLE(hxspi);

    /* Disable free running clock if needed : must be done after XSPI disable */
    CLEAR_BIT(hxspi->Instance->DCR1, XSPI_DCR1_FRCK);

#if defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U)
    if (hxspi->MspDeInitCallback == NULL)
    {
      hxspi->MspDeInitCallback = HAL_XSPI_MspDeInit;
    }

    /* De-initialize the low level hardware */
    hxspi->MspDeInitCallback(hxspi);
#else
    /* De-initialize the low-level hardware */
    HAL_XSPI_MspDeInit(hxspi);
#endif /* (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U) */

    /* Reset the driver state */
    hxspi->State = HAL_XSPI_STATE_RESET;
  }

  return status;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
void HAL_XSPI_IRQHandler(XSPI_HandleTypeDef *hxspi)
{
  __IO uint32_t *data_reg = &hxspi->Instance->DR;
  uint32_t flag           = hxspi->Instance->SR;
  uint32_t itsource       = hxspi->Instance->CR;
  uint32_t currentstate   = hxspi->State;

  /* XSPI fifo threshold interrupt occurred -------------------------------*/
  if (((flag & HAL_XSPI_FLAG_FT) != 0U) && ((itsource & HAL_XSPI_IT_FT) != 0U))
  {
    if (currentstate == HAL_XSPI_STATE_BUSY_TX)
    {
      /* Write a data in the fifo */
      *((__IO uint8_t *)data_reg) = *hxspi->pBuffPtr;
      hxspi->pBuffPtr++;
      hxspi->XferCount--;
    }
    else if (currentstate == HAL_XSPI_STATE_BUSY_RX)
    {
      /* Read a data from the fifo */
      *hxspi->pBuffPtr = *((__IO uint8_t *)data_reg);
      hxspi->pBuffPtr++;
      hxspi->XferCount--;
    }
    else
    {
      /* Nothing to do */
    }

    if (hxspi->XferCount == 0U)
    {
      /* All data have been received or transmitted for the transfer */
      /* Disable fifo threshold interrupt */
      HAL_XSPI_DISABLE_IT(hxspi, HAL_XSPI_IT_FT);
    }

    /* Fifo threshold callback */
#if defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U)
    hxspi->FifoThresholdCallback(hxspi);
#else
    HAL_XSPI_FifoThresholdCallback(hxspi);
#endif /* (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U) */
  }
  /* XSPI transfer complete interrupt occurred ----------------------------*/
  else if (((flag & HAL_XSPI_FLAG_TC) != 0U) && ((itsource & HAL_XSPI_IT_TC) != 0U))
  {
    if (currentstate == HAL_XSPI_STATE_BUSY_RX)
    {
      if ((hxspi->XferCount > 0U) && ((flag & XSPI_SR_FLEVEL) != 0U))
      {
        /* Read the last data received in the fifo */
        *hxspi->pBuffPtr = *((__IO uint8_t *)data_reg);
        hxspi->pBuffPtr++;
        hxspi->XferCount--;
      }
      else if (hxspi->XferCount == 0U)
      {
        /* Clear flag */
        hxspi->Instance->FCR = HAL_XSPI_FLAG_TC;

        /* Disable the interrupts */
        HAL_XSPI_DISABLE_IT(hxspi, HAL_XSPI_IT_TC | HAL_XSPI_IT_FT | HAL_XSPI_IT_TE);

        hxspi->State = HAL_XSPI_STATE_READY;

        /* RX complete callback */
#if defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U)
        hxspi->RxCpltCallback(hxspi);
#else
        HAL_XSPI_RxCpltCallback(hxspi);
#endif /* (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U) */
      }
      else
      {
        /* Nothing to do */
      }
    }
    else
    {
      /* Clear flag */
      hxspi->Instance->FCR = HAL_XSPI_FLAG_TC;

      /* Disable the interrupts */
      HAL_XSPI_DISABLE_IT(hxspi, HAL_XSPI_IT_TC | HAL_XSPI_IT_FT | HAL_XSPI_IT_TE);

      hxspi->State = HAL_XSPI_STATE_READY;

      if (currentstate == HAL_XSPI_STATE_BUSY_TX)
      {
        /* TX complete callback */
#if defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U)
        hxspi->TxCpltCallback(hxspi);
#else
        HAL_XSPI_TxCpltCallback(hxspi);
#endif /* (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U) */
      }
      else if (currentstate == HAL_XSPI_STATE_BUSY_CMD)
      {
        /* Command complete callback */
#if defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U)
        hxspi->CmdCpltCallback(hxspi);
#else
        HAL_XSPI_CmdCpltCallback(hxspi);
#endif /* (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U) */
      }
      else if (currentstate == HAL_XSPI_STATE_ABORT)
      {
        if (hxspi->ErrorCode == HAL_XSPI_ERROR_NONE)
        {
          /* Abort called by the user */
          /* Abort complete callback */
#if defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U)
          hxspi->AbortCpltCallback(hxspi);
#else
          HAL_XSPI_AbortCpltCallback(hxspi);
#endif /* (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U) */
        }
        else
        {
          /* Abort due to an error (eg : DMA error) */
          /* Error callback */
#if defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U)
          hxspi->ErrorCallback(hxspi);
#else
          HAL_XSPI_ErrorCallback(hxspi);
#endif /* (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U) */
        }
      }
      else
      {
        /* Nothing to do */
      }
    }
  }
  /* XSPI status match interrupt occurred ---------------------------------*/
  else if (((flag & HAL_XSPI_FLAG_SM) != 0U) && ((itsource & HAL_XSPI_IT_SM) != 0U))
  {
    /* Clear flag */
    hxspi->Instance->FCR = HAL_XSPI_FLAG_SM;

    /* Check if automatic poll mode stop is activated */
    if ((hxspi->Instance->CR & XSPI_CR_APMS) != 0U)
    {
      /* Disable the interrupts */
      HAL_XSPI_DISABLE_IT(hxspi, HAL_XSPI_IT_SM | HAL_XSPI_IT_TE);

      hxspi->State = HAL_XSPI_STATE_READY;
    }

    /* Status match callback */
#if defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U)
    hxspi->StatusMatchCallback(hxspi);
#else
    HAL_XSPI_StatusMatchCallback(hxspi);
#endif /* (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U) */
  }
  /* XSPI transfer error interrupt occurred -------------------------------*/
  else if (((flag & HAL_XSPI_FLAG_TE) != 0U) && ((itsource & HAL_XSPI_IT_TE) != 0U))
  {
    /* Clear flag */
    hxspi->Instance->FCR = HAL_XSPI_FLAG_TE;

    /* Disable all interrupts */
    HAL_XSPI_DISABLE_IT(hxspi, (HAL_XSPI_IT_TO | HAL_XSPI_IT_SM | HAL_XSPI_IT_FT | HAL_XSPI_IT_TC | HAL_XSPI_IT_TE));

    /* Set error code */
    hxspi->ErrorCode = HAL_XSPI_ERROR_TRANSFER;

    /* Check if the DMA is enabled */
    if ((hxspi->Instance->CR & XSPI_CR_DMAEN) != 0U)
    {
      /* Disable the DMA transfer on the XSPI side */
      CLEAR_BIT(hxspi->Instance->CR, XSPI_CR_DMAEN);

      /* Disable the DMA transmit on the DMA side */
      hxspi->hdmatx->XferAbortCallback = XSPI_DMAAbortCplt;
      if (HAL_DMA_Abort_IT(hxspi->hdmatx) != HAL_OK)
      {
        hxspi->State = HAL_XSPI_STATE_READY;

        /* Error callback */
#if defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U)
        hxspi->ErrorCallback(hxspi);
#else
        HAL_XSPI_ErrorCallback(hxspi);
#endif /* (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U) */
      }

      /* Disable the DMA receive on the DMA side */
      hxspi->hdmarx->XferAbortCallback = XSPI_DMAAbortCplt;
      if (HAL_DMA_Abort_IT(hxspi->hdmarx) != HAL_OK)
      {
        hxspi->State = HAL_XSPI_STATE_READY;

        /* Error callback */
#if defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U)
        hxspi->ErrorCallback(hxspi);
#else
        HAL_XSPI_ErrorCallback(hxspi);
#endif /* (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U) */
      }
    }
    else
    {
      hxspi->State = HAL_XSPI_STATE_READY;

      /* Error callback */
#if defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U)
      hxspi->ErrorCallback(hxspi);
#else
      HAL_XSPI_ErrorCallback(hxspi);
#endif /* (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U) */
    }
  }
  /* XSPI timeout interrupt occurred --------------------------------------*/
  else if (((flag & HAL_XSPI_FLAG_TO) != 0U) && ((itsource & HAL_XSPI_IT_TO) != 0U))
  {
    /* Clear flag */
    hxspi->Instance->FCR = HAL_XSPI_FLAG_TO;

    /* Timeout callback */
#if defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U)
    hxspi->TimeOutCallback(hxspi);
#else
    HAL_XSPI_TimeOutCallback(hxspi);
#endif /* (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U) */
  }
  else
  {
    /* Nothing to do */
  }
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_Command(XSPI_HandleTypeDef *hxspi, const XSPI_RegularCmdTypeDef *pCmd, uint32_t Timeout)
{
  HAL_StatusTypeDef status;
  uint32_t state;
  uint32_t tickstart = HAL_GetTick();

  /* Check the parameters of the command structure */
  assert_param(IS_XSPI_OPERATION_TYPE(pCmd->OperationType));
  if (hxspi->Init.MemoryMode == HAL_XSPI_SINGLE_MEM)
  {
    assert_param(IS_XSPI_IO_SELECT(pCmd->IOSelect));
  }

  assert_param(IS_XSPI_INSTRUCTION_MODE(pCmd->InstructionMode));
  if (pCmd->InstructionMode != HAL_XSPI_INSTRUCTION_NONE)
  {
    assert_param(IS_XSPI_INSTRUCTION_WIDTH(pCmd->InstructionWidth));
    assert_param(IS_XSPI_INSTRUCTION_DTR_MODE(pCmd->InstructionDTRMode));
  }

  assert_param(IS_XSPI_ADDRESS_MODE(pCmd->AddressMode));
  if (pCmd->AddressMode != HAL_XSPI_ADDRESS_NONE)
  {
    assert_param(IS_XSPI_ADDRESS_WIDTH(pCmd->AddressWidth));
    assert_param(IS_XSPI_ADDRESS_DTR_MODE(pCmd->AddressDTRMode));
  }

  assert_param(IS_XSPI_ALT_BYTES_MODE(pCmd->AlternateBytesMode));
  if (pCmd->AlternateBytesMode != HAL_XSPI_ALT_BYTES_NONE)
  {
    assert_param(IS_XSPI_ALT_BYTES_WIDTH(pCmd->AlternateBytesWidth));
    assert_param(IS_XSPI_ALT_BYTES_DTR_MODE(pCmd->AlternateBytesDTRMode));
  }

  assert_param(IS_XSPI_DATA_MODE(hxspi->Init.MemoryType, pCmd->DataMode));

  if (pCmd->DataMode != HAL_XSPI_DATA_NONE)
  {
    if (pCmd->OperationType == HAL_XSPI_OPTYPE_COMMON_CFG)
    {
      assert_param(IS_XSPI_DATA_LENGTH(pCmd->DataLength));
    }
    assert_param(IS_XSPI_DATA_DTR_MODE(pCmd->DataDTRMode));
    assert_param(IS_XSPI_DUMMY_CYCLES(pCmd->DummyCycles));
  }

  assert_param(IS_XSPI_DQS_MODE(pCmd->DQSMode));

  /* Check the state of the driver */
  state = hxspi->State;
  if (((state == HAL_XSPI_STATE_READY)         && (hxspi->Init.MemoryType != HAL_XSPI_MEMTYPE_HYPERBUS)) ||
      ((state == HAL_XSPI_STATE_READ_CMD_CFG)  && ((pCmd->OperationType == HAL_XSPI_OPTYPE_WRITE_CFG) ||
                                                   (pCmd->OperationType == HAL_XSPI_OPTYPE_WRAP_CFG))) ||
      ((state == HAL_XSPI_STATE_WRITE_CMD_CFG) &&
       ((pCmd->OperationType == HAL_XSPI_OPTYPE_READ_CFG)  ||
        (pCmd->OperationType == HAL_XSPI_OPTYPE_WRAP_CFG))))
  {
    /* Wait till busy flag is reset */
    status = XSPI_WaitFlagStateUntilTimeout(hxspi, HAL_XSPI_FLAG_BUSY, RESET, tickstart, Timeout);

    if (status == HAL_OK)
    {
      /* Initialize error code */
      hxspi->ErrorCode = HAL_XSPI_ERROR_NONE;

      /* Configure the registers */
      status = XSPI_ConfigCmd(hxspi, pCmd);

      if (status == HAL_OK)
      {
        if (pCmd->DataMode == HAL_XSPI_DATA_NONE)
        {
          /* When there is no data phase, the transfer start as soon as the configuration is done
             so wait until BUSY flag is reset to go back in idle state. */
          status = XSPI_WaitFlagStateUntilTimeout(hxspi, HAL_XSPI_FLAG_BUSY, RESET, tickstart, Timeout);

          /* Clear TC flag */
          HAL_XSPI_CLEAR_FLAG(hxspi, HAL_XSPI_FLAG_TC);
        }
        else
        {
          /* Update the state */
          if (pCmd->OperationType == HAL_XSPI_OPTYPE_COMMON_CFG)
          {
            hxspi->State = HAL_XSPI_STATE_CMD_CFG;
          }
          else if (pCmd->OperationType == HAL_XSPI_OPTYPE_READ_CFG)
          {
            if (hxspi->State == HAL_XSPI_STATE_WRITE_CMD_CFG)
            {
              hxspi->State = HAL_XSPI_STATE_CMD_CFG;
            }
            else
            {
              hxspi->State = HAL_XSPI_STATE_READ_CMD_CFG;
            }
          }
          else if (pCmd->OperationType == HAL_XSPI_OPTYPE_WRITE_CFG)
          {
            if (hxspi->State == HAL_XSPI_STATE_READ_CMD_CFG)
            {
              hxspi->State = HAL_XSPI_STATE_CMD_CFG;
            }
            else
            {
              hxspi->State = HAL_XSPI_STATE_WRITE_CMD_CFG;
            }
          }
          else
          {
            /* Wrap configuration, no state change */
          }
        }
      }
    }
    else
    {
      status = HAL_BUSY;
    }
  }
  else
  {
    status = HAL_ERROR;
    hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_SEQUENCE;
  }

  return status;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_Command_IT(XSPI_HandleTypeDef *hxspi, const XSPI_RegularCmdTypeDef *pCmd)
{
  HAL_StatusTypeDef status;
  uint32_t tickstart = HAL_GetTick();

  /* Check the parameters of the command structure */
  assert_param(IS_XSPI_OPERATION_TYPE(pCmd->OperationType));

  if (hxspi->Init.MemoryMode == HAL_XSPI_SINGLE_MEM)
  {
    assert_param(IS_XSPI_IO_SELECT(pCmd->IOSelect));
  }

  assert_param(IS_XSPI_INSTRUCTION_MODE(pCmd->InstructionMode));
  if (pCmd->InstructionMode != HAL_XSPI_INSTRUCTION_NONE)
  {
    assert_param(IS_XSPI_INSTRUCTION_WIDTH(pCmd->InstructionWidth));
    assert_param(IS_XSPI_INSTRUCTION_DTR_MODE(pCmd->InstructionDTRMode));
  }

  assert_param(IS_XSPI_ADDRESS_MODE(pCmd->AddressMode));
  if (pCmd->AddressMode != HAL_XSPI_ADDRESS_NONE)
  {
    assert_param(IS_XSPI_ADDRESS_WIDTH(pCmd->AddressWidth));
    assert_param(IS_XSPI_ADDRESS_DTR_MODE(pCmd->AddressDTRMode));
  }

  assert_param(IS_XSPI_ALT_BYTES_MODE(pCmd->AlternateBytesMode));
  if (pCmd->AlternateBytesMode != HAL_XSPI_ALT_BYTES_NONE)
  {
    assert_param(IS_XSPI_ALT_BYTES_WIDTH(pCmd->AlternateBytesWidth));
    assert_param(IS_XSPI_ALT_BYTES_DTR_MODE(pCmd->AlternateBytesDTRMode));
  }

  assert_param(IS_XSPI_DATA_MODE(hxspi->Init.MemoryType, pCmd->DataMode));

  if (pCmd->DataMode != HAL_XSPI_DATA_NONE)
  {
    assert_param(IS_XSPI_DATA_LENGTH(pCmd->DataLength));
    assert_param(IS_XSPI_DATA_DTR_MODE(pCmd->DataDTRMode));
    assert_param(IS_XSPI_DUMMY_CYCLES(pCmd->DummyCycles));
  }

  assert_param(IS_XSPI_DQS_MODE(pCmd->DQSMode));

  /* Check the state of the driver */
  if ((hxspi->State  == HAL_XSPI_STATE_READY) && (pCmd->OperationType     == HAL_XSPI_OPTYPE_COMMON_CFG) &&
      (pCmd->DataMode == HAL_XSPI_DATA_NONE)   && (hxspi->Init.MemoryType != HAL_XSPI_MEMTYPE_HYPERBUS))
  {
    /* Wait till busy flag is reset */
    status = XSPI_WaitFlagStateUntilTimeout(hxspi, HAL_XSPI_FLAG_BUSY, RESET, tickstart, hxspi->Timeout);

    if (status == HAL_OK)
    {
      /* Initialize error code */
      hxspi->ErrorCode = HAL_XSPI_ERROR_NONE;

      /* Clear flags related to interrupt */
      HAL_XSPI_CLEAR_FLAG(hxspi, HAL_XSPI_FLAG_TE | HAL_XSPI_FLAG_TC);

      /* Configure the registers */
      status = XSPI_ConfigCmd(hxspi, pCmd);

      if (status == HAL_OK)
      {
        /* Update the state */
        hxspi->State = HAL_XSPI_STATE_BUSY_CMD;

        /* Enable the transfer complete and transfer error interrupts */
        HAL_XSPI_ENABLE_IT(hxspi, HAL_XSPI_IT_TC | HAL_XSPI_IT_TE);
      }
    }
  }
  else
  {
    status = HAL_ERROR;
    hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_SEQUENCE;
  }

  return status;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_HyperbusCfg(XSPI_HandleTypeDef *hxspi, const XSPI_HyperbusCfgTypeDef *pCfg,
                                       uint32_t Timeout)
{
  HAL_StatusTypeDef status;
  uint32_t state;
  uint32_t tickstart = HAL_GetTick();

  /* Check the parameters of the hyperbus configuration structure */
  assert_param(IS_XSPI_RW_RECOVERY_TIME_CYCLE(pCfg->RWRecoveryTimeCycle));
  assert_param(IS_XSPI_ACCESS_TIME_CYCLE(pCfg->AccessTimeCycle));
  assert_param(IS_XSPI_WRITE_ZERO_LATENCY(pCfg->WriteZeroLatency));
  assert_param(IS_XSPI_LATENCY_MODE(pCfg->LatencyMode));

  /* Check the state of the driver */
  state = hxspi->State;
  if ((state == HAL_XSPI_STATE_HYPERBUS_INIT) || (state == HAL_XSPI_STATE_READY))
  {
    /* Wait till busy flag is reset */
    status = XSPI_WaitFlagStateUntilTimeout(hxspi, HAL_XSPI_FLAG_BUSY, RESET, tickstart, Timeout);

    if (status == HAL_OK)
    {
      /* Configure Hyperbus configuration Latency register */
      WRITE_REG(hxspi->Instance->HLCR, ((pCfg->RWRecoveryTimeCycle << XSPI_HLCR_TRWR_Pos) |
                                        (pCfg->AccessTimeCycle << XSPI_HLCR_TACC_Pos)     |
                                        pCfg->WriteZeroLatency | pCfg->LatencyMode));

      /* Update the state */
      hxspi->State = HAL_XSPI_STATE_READY;
    }
    else
    {
      status = HAL_BUSY;
    }
  }
  else
  {
    status = HAL_ERROR;
    hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_SEQUENCE;
  }

  return status;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_HyperbusCmd(XSPI_HandleTypeDef *hxspi, const XSPI_HyperbusCmdTypeDef *pCmd,
                                       uint32_t Timeout)
{
  HAL_StatusTypeDef status;
  uint32_t tickstart = HAL_GetTick();

  /* Check the parameters of the hyperbus command structure */
  assert_param(IS_XSPI_ADDRESS_SPACE(pCmd->AddressSpace));
  assert_param(IS_XSPI_ADDRESS_WIDTH(pCmd->AddressWidth));
  assert_param(IS_XSPI_DATA_LENGTH(pCmd->DataLength));
  assert_param(IS_XSPI_DQS_MODE(pCmd->DQSMode));
  assert_param(IS_XSPI_DATA_MODE(hxspi->Init.MemoryType, pCmd->DataMode));

  /* Check the state of the driver */
  if ((hxspi->State == HAL_XSPI_STATE_READY) && (hxspi->Init.MemoryType == HAL_XSPI_MEMTYPE_HYPERBUS))
  {
    /* Wait till busy flag is reset */
    status = XSPI_WaitFlagStateUntilTimeout(hxspi, HAL_XSPI_FLAG_BUSY, RESET, tickstart, Timeout);

    if (status == HAL_OK)
    {
      /* Re-initialize the value of the functional mode */
      MODIFY_REG(hxspi->Instance->CR, XSPI_CR_FMODE, 0U);

      /* Configure the address space in the DCR1 register */
      MODIFY_REG(hxspi->Instance->DCR1, XSPI_DCR1_MTYP_0, pCmd->AddressSpace);

      /* Configure the CCR and WCCR registers with the address size and the following configuration :
         - DQS signal enabled (used as RWDS)
         - DTR mode enabled on address and data */
      /* - address and data on 8 or 16 lines */
      WRITE_REG(hxspi->Instance->CCR, (pCmd->DQSMode | XSPI_CCR_DDTR | pCmd->DataMode |
                                       pCmd->AddressWidth | XSPI_CCR_ADDTR | XSPI_CCR_ADMODE_2));
      WRITE_REG(hxspi->Instance->WCCR, (pCmd->DQSMode | XSPI_WCCR_DDTR | pCmd->DataMode |
                                        pCmd->AddressWidth | XSPI_WCCR_ADDTR | XSPI_WCCR_ADMODE_2));

      /* Configure the DLR register with the number of data */
      WRITE_REG(hxspi->Instance->DLR, (pCmd->DataLength - 1U));

      /* Configure the AR register with the address value */
      WRITE_REG(hxspi->Instance->AR, pCmd->Address);

      /* Update the state */
      hxspi->State = HAL_XSPI_STATE_CMD_CFG;
    }
    else
    {
      status = HAL_BUSY;
    }
  }
  else
  {
    status = HAL_ERROR;
    hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_SEQUENCE;
  }

  return status;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_Transmit(XSPI_HandleTypeDef *hxspi, const uint8_t *pData, uint32_t Timeout)
{
  HAL_StatusTypeDef status;
  uint32_t tickstart = HAL_GetTick();
  __IO uint32_t *data_reg = &hxspi->Instance->DR;

  /* Check the data pointer allocation */
  if (pData == NULL)
  {
    status = HAL_ERROR;
    hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_PARAM;
  }
  else
  {
    /* Check the state */
    if (hxspi->State == HAL_XSPI_STATE_CMD_CFG)
    {
      /* Configure counters and size */
      hxspi->XferCount = READ_REG(hxspi->Instance->DLR) + 1U;
      hxspi->XferSize  = hxspi->XferCount;
      hxspi->pBuffPtr  = (uint8_t *)pData;

      /* Configure CR register with functional mode as indirect write */
      MODIFY_REG(hxspi->Instance->CR, XSPI_CR_FMODE, XSPI_FUNCTIONAL_MODE_INDIRECT_WRITE);

      do
      {
        /* Wait till fifo threshold flag is set to send data */
        status = XSPI_WaitFlagStateUntilTimeout(hxspi, HAL_XSPI_FLAG_FT, SET, tickstart, Timeout);

        if (status != HAL_OK)
        {
          break;
        }

        *((__IO uint8_t *)data_reg) = *hxspi->pBuffPtr;
        hxspi->pBuffPtr++;
        hxspi->XferCount--;
      } while (hxspi->XferCount > 0U);

      if (status == HAL_OK)
      {
        /* Wait till transfer complete flag is set to go back in idle state */
        status = XSPI_WaitFlagStateUntilTimeout(hxspi, HAL_XSPI_FLAG_TC, SET, tickstart, Timeout);

        if (status == HAL_OK)
        {
          /* Clear transfer complete flag */
          HAL_XSPI_CLEAR_FLAG(hxspi, HAL_XSPI_FLAG_TC);

          hxspi->State = HAL_XSPI_STATE_READY;
        }
      }
    }
    else
    {
      status = HAL_ERROR;
      hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_SEQUENCE;
    }
  }

  return status;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_Receive(XSPI_HandleTypeDef *hxspi, uint8_t *pData, uint32_t Timeout)
{
  HAL_StatusTypeDef status;
  uint32_t tickstart = HAL_GetTick();
  __IO uint32_t *data_reg = &hxspi->Instance->DR;
  uint32_t addr_reg = hxspi->Instance->AR;
  uint32_t ir_reg = hxspi->Instance->IR;

  /* Check the data pointer allocation */
  if (pData == NULL)
  {
    status = HAL_ERROR;
    hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_PARAM;
  }
  else
  {
    /* Check the state */
    if (hxspi->State == HAL_XSPI_STATE_CMD_CFG)
    {
      /* Configure counters and size */
      hxspi->XferCount = READ_REG(hxspi->Instance->DLR) + 1U;
      hxspi->XferSize  = hxspi->XferCount;
      hxspi->pBuffPtr  = pData;

      /* Configure CR register with functional mode as indirect read */
      MODIFY_REG(hxspi->Instance->CR, XSPI_CR_FMODE, XSPI_FUNCTIONAL_MODE_INDIRECT_READ);

      /* Trig the transfer by re-writing address or instruction register */
      if (hxspi->Init.MemoryType == HAL_XSPI_MEMTYPE_HYPERBUS)
      {
        WRITE_REG(hxspi->Instance->AR, addr_reg);
      }
      else
      {
        if (READ_BIT(hxspi->Instance->CCR, XSPI_CCR_ADMODE) != HAL_XSPI_ADDRESS_NONE)
        {
          WRITE_REG(hxspi->Instance->AR, addr_reg);
        }
        else
        {
          WRITE_REG(hxspi->Instance->IR, ir_reg);
        }
      }

      do
      {
        /* Wait till fifo threshold or transfer complete flags are set to read received data */
        status = XSPI_WaitFlagStateUntilTimeout(hxspi, (HAL_XSPI_FLAG_FT | HAL_XSPI_FLAG_TC), SET, tickstart, Timeout);

        if (status != HAL_OK)
        {
          break;
        }

        *hxspi->pBuffPtr = *((__IO uint8_t *)data_reg);
        hxspi->pBuffPtr++;
        hxspi->XferCount--;
      } while (hxspi->XferCount > 0U);

      if (status == HAL_OK)
      {
        /* Wait till transfer complete flag is set to go back in idle state */
        status = XSPI_WaitFlagStateUntilTimeout(hxspi, HAL_XSPI_FLAG_TC, SET, tickstart, Timeout);

        if (status == HAL_OK)
        {
          /* Clear transfer complete flag */
          HAL_XSPI_CLEAR_FLAG(hxspi, HAL_XSPI_FLAG_TC);

          hxspi->State = HAL_XSPI_STATE_READY;
        }
      }
    }
    else
    {
      status = HAL_ERROR;
      hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_SEQUENCE;
    }
  }

  return status;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_Transmit_IT(XSPI_HandleTypeDef *hxspi, const uint8_t *pData)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the data pointer allocation */
  if (pData == NULL)
  {
    status = HAL_ERROR;
    hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_PARAM;
  }
  else
  {
    /* Check the state */
    if (hxspi->State == HAL_XSPI_STATE_CMD_CFG)
    {
      /* Configure counters and size */
      hxspi->XferCount = READ_REG(hxspi->Instance->DLR) + 1U;
      hxspi->XferSize  = hxspi->XferCount;
      hxspi->pBuffPtr  = (uint8_t *)pData;

      /* Configure CR register with functional mode as indirect write */
      MODIFY_REG(hxspi->Instance->CR, XSPI_CR_FMODE, XSPI_FUNCTIONAL_MODE_INDIRECT_WRITE);

      /* Clear flags related to interrupt */
      HAL_XSPI_CLEAR_FLAG(hxspi, HAL_XSPI_FLAG_TE | HAL_XSPI_FLAG_TC);

      /* Update the state */
      hxspi->State = HAL_XSPI_STATE_BUSY_TX;

      /* Enable the transfer complete, fifo threshold and transfer error interrupts */
      HAL_XSPI_ENABLE_IT(hxspi, HAL_XSPI_IT_TC | HAL_XSPI_IT_FT | HAL_XSPI_IT_TE);
    }
    else
    {
      status = HAL_ERROR;
      hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_SEQUENCE;
    }
  }

  return status;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_Receive_IT(XSPI_HandleTypeDef *hxspi, uint8_t *pData)
{
  HAL_StatusTypeDef status = HAL_OK;
  uint32_t addr_reg = hxspi->Instance->AR;
  uint32_t ir_reg = hxspi->Instance->IR;

  /* Check the data pointer allocation */
  if (pData == NULL)
  {
    status = HAL_ERROR;
    hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_PARAM;
  }
  else
  {
    /* Check the state */
    if (hxspi->State == HAL_XSPI_STATE_CMD_CFG)
    {
      /* Configure counters and size */
      hxspi->XferCount = READ_REG(hxspi->Instance->DLR) + 1U;
      hxspi->XferSize  = hxspi->XferCount;
      hxspi->pBuffPtr  = pData;

      /* Configure CR register with functional mode as indirect read */
      MODIFY_REG(hxspi->Instance->CR, XSPI_CR_FMODE, XSPI_FUNCTIONAL_MODE_INDIRECT_READ);

      /* Clear flags related to interrupt */
      HAL_XSPI_CLEAR_FLAG(hxspi, HAL_XSPI_FLAG_TE | HAL_XSPI_FLAG_TC);

      /* Update the state */
      hxspi->State = HAL_XSPI_STATE_BUSY_RX;

      /* Enable the transfer complete, fifo threshold and transfer error interrupts */
      HAL_XSPI_ENABLE_IT(hxspi, HAL_XSPI_IT_TC | HAL_XSPI_IT_FT | HAL_XSPI_IT_TE);

      /* Trig the transfer by re-writing address or instruction register */
      if (hxspi->Init.MemoryType == HAL_XSPI_MEMTYPE_HYPERBUS)
      {
        WRITE_REG(hxspi->Instance->AR, addr_reg);
      }
      else
      {
        if (READ_BIT(hxspi->Instance->CCR, XSPI_CCR_ADMODE) != HAL_XSPI_ADDRESS_NONE)
        {
          WRITE_REG(hxspi->Instance->AR, addr_reg);
        }
        else
        {
          WRITE_REG(hxspi->Instance->IR, ir_reg);
        }
      }
    }
    else
    {
      status = HAL_ERROR;
      hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_SEQUENCE;
    }
  }

  return status;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_Transmit_DMA(XSPI_HandleTypeDef *hxspi, const uint8_t *pData)
{
  HAL_StatusTypeDef status = HAL_OK;
  uint32_t data_size = hxspi->Instance->DLR + 1U;
  DMA_QListTypeDef *p_queue = {NULL};
  uint32_t data_width = DMA_DEST_DATAWIDTH_BYTE;

  /* Check the data pointer allocation */
  if (pData == NULL)
  {
    status = HAL_ERROR;
    hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_PARAM;
  }
  else
  {
    /* Check the state */
    if (hxspi->State == HAL_XSPI_STATE_CMD_CFG)
    {
      if ((hxspi->hdmatx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
      {
        p_queue = hxspi->hdmatx->LinkedListQueue;
        if ((p_queue != NULL) && (p_queue->Head != NULL))
        {
          data_width = p_queue->Head->LinkRegisters[NODE_CTR1_DEFAULT_OFFSET] & DMA_CTR1_DDW_LOG2;
        }
        else
        {
          /* Set Error Code function status  */
          hxspi->ErrorCode = HAL_XSPI_ERROR_DMA;

          /* Return function status */
          status = HAL_ERROR;
        }
      }
      else
      {
        data_width = hxspi->hdmatx->Init.DestDataWidth;
      }
      /* Configure counters and size */
      if (data_width == DMA_DEST_DATAWIDTH_BYTE)
      {
        hxspi->XferCount = data_size;
      }
      else if (data_width == DMA_DEST_DATAWIDTH_HALFWORD)
      {
        if (((data_size % 2U) != 0U) || ((hxspi->Init.FifoThresholdByte % 2U) != 0U))
        {
          /* The number of data or the fifo threshold is not aligned on halfword
          => no transfer possible with DMA peripheral access configured as halfword */
          hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_PARAM;
          status = HAL_ERROR;
        }
        else
        {
          hxspi->XferCount = data_size;
        }
      }
      else if (data_width == DMA_DEST_DATAWIDTH_WORD)
      {
        if (((data_size % 4U) != 0U) || ((hxspi->Init.FifoThresholdByte % 4U) != 0U))
        {
          /* The number of data or the fifo threshold is not aligned on word
          => no transfer possible with DMA peripheral access configured as word */
          hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_PARAM;
          status = HAL_ERROR;
        }
        else
        {
          hxspi->XferCount = data_size;
        }
      }
      else
      {
        /* Nothing to do */
      }

      if (status == HAL_OK)
      {
        hxspi->XferSize = hxspi->XferCount;
        hxspi->pBuffPtr = (uint8_t *)pData;

        /* Configure CR register with functional mode as indirect write */
        MODIFY_REG(hxspi->Instance->CR, XSPI_CR_FMODE, XSPI_FUNCTIONAL_MODE_INDIRECT_WRITE);

        /* Clear flags related to interrupt */
        HAL_XSPI_CLEAR_FLAG(hxspi, HAL_XSPI_FLAG_TE | HAL_XSPI_FLAG_TC);

        /* Update the state */
        hxspi->State = HAL_XSPI_STATE_BUSY_TX;

        /* Set the DMA transfer complete callback */
        hxspi->hdmatx->XferCpltCallback = XSPI_DMACplt;

        /* Set the DMA Half transfer complete callback */
        hxspi->hdmatx->XferHalfCpltCallback = XSPI_DMAHalfCplt;

        /* Set the DMA error callback */
        hxspi->hdmatx->XferErrorCallback = XSPI_DMAError;

        /* Clear the DMA abort callback */
        hxspi->hdmatx->XferAbortCallback = NULL;

        /* Enable the transmit DMA Channel */
        if ((hxspi->hdmatx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
        {
          if (hxspi->hdmatx->LinkedListQueue != NULL)
          {
            /* Enable the DMA channel */
            MODIFY_REG(p_queue->Head->LinkRegisters[NODE_CTR1_DEFAULT_OFFSET], \
                       (DMA_CTR1_SINC | DMA_CTR1_DINC), (DMA_SINC_INCREMENTED | DMA_DINC_FIXED));
            MODIFY_REG(p_queue->Head->LinkRegisters[NODE_CTR2_DEFAULT_OFFSET], \
                       DMA_CTR2_DREQ, DMA_MEMORY_TO_PERIPH);
            /* Set DMA data size*/
            p_queue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = hxspi->XferSize;
            /* Set DMA source address */
            p_queue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = (uint32_t)pData;
            /* Set DMA destination address */
            p_queue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = (uint32_t)&hxspi->Instance->DR;

            status = HAL_DMAEx_List_Start_IT(hxspi->hdmatx);
          }
          else
          {
            /* Set Error Code */
            hxspi->ErrorCode = HAL_XSPI_ERROR_DMA;

            hxspi->State = HAL_XSPI_STATE_READY;

            /* Return function status */
            status = HAL_ERROR;
          }
        }
        else
        {
          if ((hxspi->hdmatx->Init.Direction == DMA_MEMORY_TO_PERIPH) &&
              (hxspi->hdmatx->Init.SrcInc == DMA_SINC_INCREMENTED) && (hxspi->hdmatx->Init.DestInc == DMA_DINC_FIXED))
          {
            status = HAL_DMA_Start_IT(hxspi->hdmatx, (uint32_t)pData, (uint32_t)&hxspi->Instance->DR, hxspi->XferSize);
          }
          else
          {
            /* no transmit possible with DMA peripheral, invalid configuration */
            hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_PARAM;
            status = HAL_ERROR;
          }
        }
        if (status == HAL_OK)
        {
          /* Enable the transfer error interrupt */
          HAL_XSPI_ENABLE_IT(hxspi, HAL_XSPI_IT_TE);

          /* Enable the DMA transfer by setting the DMAEN bit  */
          SET_BIT(hxspi->Instance->CR, XSPI_CR_DMAEN);
        }
        else
        {
          status = HAL_ERROR;
          hxspi->ErrorCode = HAL_XSPI_ERROR_DMA;
          hxspi->State = HAL_XSPI_STATE_READY;
        }
      }
    }
    else
    {
      status = HAL_ERROR;
      hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_SEQUENCE;
    }
  }

  return status;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_Receive_DMA(XSPI_HandleTypeDef *hxspi, uint8_t *pData)
{
  HAL_StatusTypeDef status = HAL_OK;
  uint32_t data_size = hxspi->Instance->DLR + 1U;
  uint32_t addr_reg = hxspi->Instance->AR;
  uint32_t ir_reg = hxspi->Instance->IR;
  DMA_QListTypeDef *p_queue = {NULL};
  uint32_t data_width = DMA_DEST_DATAWIDTH_BYTE;

  /* Check the data pointer allocation */
  if (pData == NULL)
  {
    status = HAL_ERROR;
    hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_PARAM;
  }
  else
  {
    /* Check the state */
    if (hxspi->State == HAL_XSPI_STATE_CMD_CFG)
    {
      if ((hxspi->hdmarx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
      {
        p_queue = hxspi->hdmarx->LinkedListQueue;
        if ((p_queue != NULL) && (p_queue->Head != NULL))
        {
          data_width = p_queue->Head->LinkRegisters[NODE_CTR1_DEFAULT_OFFSET] & DMA_CTR1_DDW_LOG2;
        }
        else
        {
          /* Set Error Code */
          hxspi->ErrorCode = HAL_XSPI_ERROR_DMA;

          /* Return function status */
          status = HAL_ERROR;
        }
      }
      else
      {
        data_width = hxspi->hdmarx->Init.DestDataWidth;
      }

      /* Configure counters and size */
      if (data_width == DMA_DEST_DATAWIDTH_BYTE)
      {
        hxspi->XferCount = data_size;
      }
      else if (data_width == DMA_DEST_DATAWIDTH_HALFWORD)
      {
        if (((data_size % 2U) != 0U) || ((hxspi->Init.FifoThresholdByte % 2U) != 0U))
        {
          /* The number of data or the fifo threshold is not aligned on halfword
          => no transfer possible with DMA peripheral access configured as halfword */
          hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_PARAM;
          status = HAL_ERROR;
        }
        else
        {
          hxspi->XferCount = data_size;
        }
      }
      else if (data_width == DMA_DEST_DATAWIDTH_WORD)
      {
        if (((data_size % 4U) != 0U) || ((hxspi->Init.FifoThresholdByte % 4U) != 0U))
        {
          /* The number of data or the fifo threshold is not aligned on word
          => no transfer possible with DMA peripheral access configured as word */
          hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_PARAM;
          status = HAL_ERROR;
        }
        else
        {
          hxspi->XferCount = data_size;
        }
      }
      else
      {
        /* Nothing to do */
      }

      if (status == HAL_OK)
      {
        hxspi->XferSize  = hxspi->XferCount;
        hxspi->pBuffPtr  = pData;

        /* Configure CR register with functional mode as indirect read */
        MODIFY_REG(hxspi->Instance->CR, XSPI_CR_FMODE, XSPI_FUNCTIONAL_MODE_INDIRECT_READ);

        /* Clear flags related to interrupt */
        HAL_XSPI_CLEAR_FLAG(hxspi, HAL_XSPI_FLAG_TE | HAL_XSPI_FLAG_TC);

        /* Update the state */
        hxspi->State = HAL_XSPI_STATE_BUSY_RX;

        /* Set the DMA transfer complete callback */
        hxspi->hdmarx->XferCpltCallback = XSPI_DMACplt;

        /* Set the DMA Half transfer complete callback */
        hxspi->hdmarx->XferHalfCpltCallback = XSPI_DMAHalfCplt;

        /* Set the DMA error callback */
        hxspi->hdmarx->XferErrorCallback = XSPI_DMAError;

        /* Clear the DMA abort callback */
        hxspi->hdmarx->XferAbortCallback = NULL;

        /* Enable the receive DMA Channel */
        if ((hxspi->hdmarx->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
        {
          if (hxspi->hdmarx->LinkedListQueue != NULL)
          {
            /* Enable the DMA channel */
            MODIFY_REG(p_queue->Head->LinkRegisters[NODE_CTR1_DEFAULT_OFFSET], \
                       (DMA_CTR1_SINC | DMA_CTR1_DINC), (DMA_SINC_FIXED | DMA_DINC_INCREMENTED));
            MODIFY_REG(p_queue->Head->LinkRegisters[NODE_CTR2_DEFAULT_OFFSET], \
                       DMA_CTR2_DREQ, DMA_PERIPH_TO_MEMORY);
            /* Set DMA data size */
            p_queue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = hxspi->XferSize;
            /* Set DMA source address */
            p_queue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = (uint32_t)&hxspi->Instance->DR;
            /* Set DMA destination address */
            p_queue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = (uint32_t)pData;

            status = HAL_DMAEx_List_Start_IT(hxspi->hdmarx);
          }
          else
          {
            /* Set Error Code */
            hxspi->ErrorCode = HAL_XSPI_ERROR_DMA;

            hxspi->State = HAL_XSPI_STATE_READY;

            /* Return function status */
            status = HAL_ERROR;
          }
        }
        else
        {
          if ((hxspi->hdmarx->Init.Direction == DMA_PERIPH_TO_MEMORY) && (hxspi->hdmarx->Init.SrcInc == DMA_SINC_FIXED)
              && (hxspi->hdmarx->Init.DestInc == DMA_DINC_INCREMENTED))
          {
            status = HAL_DMA_Start_IT(hxspi->hdmarx, (uint32_t)&hxspi->Instance->DR, (uint32_t)pData, hxspi->XferSize);
          }
          else
          {
            /* no receive possible with DMA peripheral, invalid configuration */
            hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_PARAM;
            status = HAL_ERROR;
          }
        }
        if (status == HAL_OK)
        {
          /* Enable the transfer error interrupt */
          HAL_XSPI_ENABLE_IT(hxspi, HAL_XSPI_IT_TE);

          /* Trig the transfer by re-writing address or instruction register */
          if (hxspi->Init.MemoryType == HAL_XSPI_MEMTYPE_HYPERBUS)
          {
            WRITE_REG(hxspi->Instance->AR, addr_reg);
          }
          else
          {
            if (READ_BIT(hxspi->Instance->CCR, XSPI_CCR_ADMODE) != HAL_XSPI_ADDRESS_NONE)
            {
              WRITE_REG(hxspi->Instance->AR, addr_reg);
            }
            else
            {
              WRITE_REG(hxspi->Instance->IR, ir_reg);
            }
          }

          /* Enable the DMA transfer by setting the DMAEN bit  */
          SET_BIT(hxspi->Instance->CR, XSPI_CR_DMAEN);
        }
        else
        {
          status = HAL_ERROR;
          hxspi->ErrorCode = HAL_XSPI_ERROR_DMA;
          hxspi->State = HAL_XSPI_STATE_READY;
        }
      }
    }
    else
    {
      status = HAL_ERROR;
      hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_SEQUENCE;
    }
  }

  return status;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_AutoPolling(XSPI_HandleTypeDef *hxspi, const XSPI_AutoPollingTypeDef *pCfg,
                                       uint32_t Timeout)
{
  HAL_StatusTypeDef status;
  uint32_t tickstart = HAL_GetTick();
  uint32_t addr_reg = hxspi->Instance->AR;
  uint32_t ir_reg = hxspi->Instance->IR;
#ifdef USE_FULL_ASSERT
  uint32_t dlr_reg = hxspi->Instance->DLR;
#endif /* USE_FULL_ASSERT */

  /* Check the parameters of the autopolling configuration structure */
  assert_param(IS_XSPI_MATCH_MODE(pCfg->MatchMode));
  assert_param(IS_XSPI_AUTOMATIC_STOP(pCfg->AutomaticStop));
  assert_param(IS_XSPI_INTERVAL(pCfg->IntervalTime));
  assert_param(IS_XSPI_STATUS_BYTES_SIZE(dlr_reg + 1U));

  /* Check the state */
  if ((hxspi->State == HAL_XSPI_STATE_CMD_CFG) && (pCfg->AutomaticStop == HAL_XSPI_AUTOMATIC_STOP_ENABLE))
  {
    /* Wait till busy flag is reset */
    status = XSPI_WaitFlagStateUntilTimeout(hxspi, HAL_XSPI_FLAG_BUSY, RESET, tickstart, Timeout);

    if (status == HAL_OK)
    {
      /* Configure registers */
      WRITE_REG(hxspi->Instance->PSMAR, pCfg->MatchValue);
      WRITE_REG(hxspi->Instance->PSMKR, pCfg->MatchMask);
      WRITE_REG(hxspi->Instance->PIR,   pCfg->IntervalTime);
      MODIFY_REG(hxspi->Instance->CR, (XSPI_CR_PMM | XSPI_CR_APMS | XSPI_CR_FMODE),
                 (pCfg->MatchMode | pCfg->AutomaticStop | XSPI_FUNCTIONAL_MODE_AUTO_POLLING));

      /* Trig the transfer by re-writing address or instruction register */
      if (hxspi->Init.MemoryType == HAL_XSPI_MEMTYPE_HYPERBUS)
      {
        WRITE_REG(hxspi->Instance->AR, addr_reg);
      }
      else
      {
        if (READ_BIT(hxspi->Instance->CCR, XSPI_CCR_ADMODE) != HAL_XSPI_ADDRESS_NONE)
        {
          WRITE_REG(hxspi->Instance->AR, addr_reg);
        }
        else
        {
          WRITE_REG(hxspi->Instance->IR, ir_reg);
        }
      }

      /* Wait till status match flag is set to go back in idle state */
      status = XSPI_WaitFlagStateUntilTimeout(hxspi, HAL_XSPI_FLAG_SM, SET, tickstart, Timeout);

      if (status == HAL_OK)
      {
        /* Clear status match flag */
        HAL_XSPI_CLEAR_FLAG(hxspi, HAL_XSPI_FLAG_SM);

        hxspi->State = HAL_XSPI_STATE_READY;
      }
    }
    else
    {
      status = HAL_BUSY;
    }
  }
  else
  {
    status = HAL_ERROR;
    hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_SEQUENCE;
  }

  return status;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_AutoPolling_IT(XSPI_HandleTypeDef *hxspi, const XSPI_AutoPollingTypeDef *pCfg)
{
  HAL_StatusTypeDef status;
  uint32_t tickstart = HAL_GetTick();
  uint32_t addr_reg = hxspi->Instance->AR;
  uint32_t ir_reg = hxspi->Instance->IR;
#ifdef USE_FULL_ASSERT
  uint32_t dlr_reg = hxspi->Instance->DLR;
#endif /* USE_FULL_ASSERT */

  /* Check the parameters of the autopolling configuration structure */
  assert_param(IS_XSPI_MATCH_MODE(pCfg->MatchMode));
  assert_param(IS_XSPI_AUTOMATIC_STOP(pCfg->AutomaticStop));
  assert_param(IS_XSPI_INTERVAL(pCfg->IntervalTime));
  assert_param(IS_XSPI_STATUS_BYTES_SIZE(dlr_reg + 1U));

  /* Check the state */
  if (hxspi->State == HAL_XSPI_STATE_CMD_CFG)
  {
    /* Wait till busy flag is reset */
    status = XSPI_WaitFlagStateUntilTimeout(hxspi, HAL_XSPI_FLAG_BUSY, RESET, tickstart, hxspi->Timeout);

    if (status == HAL_OK)
    {
      /* Configure registers */
      WRITE_REG(hxspi->Instance->PSMAR, pCfg->MatchValue);
      WRITE_REG(hxspi->Instance->PSMKR, pCfg->MatchMask);
      WRITE_REG(hxspi->Instance->PIR,   pCfg->IntervalTime);
      MODIFY_REG(hxspi->Instance->CR, (XSPI_CR_PMM | XSPI_CR_APMS | XSPI_CR_FMODE),
                 (pCfg->MatchMode | pCfg->AutomaticStop | XSPI_FUNCTIONAL_MODE_AUTO_POLLING));

      /* Clear flags related to interrupt */
      HAL_XSPI_CLEAR_FLAG(hxspi, HAL_XSPI_FLAG_TE | HAL_XSPI_FLAG_SM);

      hxspi->State = HAL_XSPI_STATE_BUSY_AUTO_POLLING;

      /* Enable the status match and transfer error interrupts */
      HAL_XSPI_ENABLE_IT(hxspi, HAL_XSPI_IT_SM | HAL_XSPI_IT_TE);

      /* Trig the transfer by re-writing address or instruction register */
      if (hxspi->Init.MemoryType == HAL_XSPI_MEMTYPE_HYPERBUS)
      {
        WRITE_REG(hxspi->Instance->AR, addr_reg);
      }
      else
      {
        if (READ_BIT(hxspi->Instance->CCR, XSPI_CCR_ADMODE) != HAL_XSPI_ADDRESS_NONE)
        {
          WRITE_REG(hxspi->Instance->AR, addr_reg);
        }
        else
        {
          WRITE_REG(hxspi->Instance->IR, ir_reg);
        }
      }
    }
  }
  else
  {
    status = HAL_ERROR;
    hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_SEQUENCE;
  }

  return status;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_MemoryMapped(XSPI_HandleTypeDef *hxspi, const XSPI_MemoryMappedTypeDef *pCfg)
{
  HAL_StatusTypeDef status;
  uint32_t tickstart = HAL_GetTick();

  /* Check the parameters of the memory-mapped configuration structure */
  assert_param(IS_XSPI_TIMEOUT_ACTIVATION(pCfg->TimeOutActivation));

  /* Check the state */
  if (hxspi->State == HAL_XSPI_STATE_CMD_CFG)
  {
    /* Wait till busy flag is reset */
    status = XSPI_WaitFlagStateUntilTimeout(hxspi, HAL_XSPI_FLAG_BUSY, RESET, tickstart, hxspi->Timeout);

    if (status == HAL_OK)
    {
      hxspi->State = HAL_XSPI_STATE_BUSY_MEM_MAPPED;

      if (pCfg->TimeOutActivation == HAL_XSPI_TIMEOUT_COUNTER_ENABLE)
      {
        assert_param(IS_XSPI_TIMEOUT_PERIOD(pCfg->TimeoutPeriodClock));

        /* Configure register */
        WRITE_REG(hxspi->Instance->LPTR, pCfg->TimeoutPeriodClock);

        /* Clear flags related to interrupt */
        HAL_XSPI_CLEAR_FLAG(hxspi, HAL_XSPI_FLAG_TO);

        /* Enable the timeout interrupt */
        HAL_XSPI_ENABLE_IT(hxspi, HAL_XSPI_IT_TO);
      }

      /* Configure CR register with functional mode as memory-mapped */
      MODIFY_REG(hxspi->Instance->CR, (XSPI_CR_TCEN | XSPI_CR_FMODE),
                 (pCfg->TimeOutActivation | XSPI_FUNCTIONAL_MODE_MEMORY_MAPPED));
    }
  }
  else
  {
    status = HAL_ERROR;
    hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_SEQUENCE;
  }

  return status;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
uint32_t HAL_XSPI_IsMemoryMapped(XSPI_HandleTypeDef *hxspi)
{
  /* Check the XSPI handle allocation */
  if (hxspi == NULL)
  {
    return (0UL);
  }
  /* Check if driver is in Reset state */
  else if (hxspi->State == HAL_XSPI_STATE_RESET)
  {
    return (0UL);
  }
  else
  {
    return ((READ_BIT(hxspi->Instance->CR, XSPI_CR_FMODE) == XSPI_CR_FMODE) ? 1UL : 0UL);
  }
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
#if defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_XSPI_RegisterCallback(XSPI_HandleTypeDef *hxspi, HAL_XSPI_CallbackIDTypeDef CallbackID,
                                            pXSPI_CallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hxspi->ErrorCode |= HAL_XSPI_ERROR_INVALID_CALLBACK;
    return HAL_ERROR;
  }

  if (hxspi->State == HAL_XSPI_STATE_READY)
  {
    switch (CallbackID)
    {
      case  HAL_XSPI_ERROR_CB_ID :
        hxspi->ErrorCallback = pCallback;
        break;
      case HAL_XSPI_ABORT_CB_ID :
        hxspi->AbortCpltCallback = pCallback;
        break;
      case HAL_XSPI_FIFO_THRESHOLD_CB_ID :
        hxspi->FifoThresholdCallback = pCallback;
        break;
      case HAL_XSPI_CMD_CPLT_CB_ID :
        hxspi->CmdCpltCallback = pCallback;
        break;
      case HAL_XSPI_RX_CPLT_CB_ID :
        hxspi->RxCpltCallback = pCallback;
        break;
      case HAL_XSPI_TX_CPLT_CB_ID :
        hxspi->TxCpltCallback = pCallback;
        break;
      case HAL_XSPI_RX_HALF_CPLT_CB_ID :
        hxspi->RxHalfCpltCallback = pCallback;
        break;
      case HAL_XSPI_TX_HALF_CPLT_CB_ID :
        hxspi->TxHalfCpltCallback = pCallback;
        break;
      case HAL_XSPI_STATUS_MATCH_CB_ID :
        hxspi->StatusMatchCallback = pCallback;
        break;
      case HAL_XSPI_TIMEOUT_CB_ID :
        hxspi->TimeOutCallback = pCallback;
        break;
      case HAL_XSPI_MSP_INIT_CB_ID :
        hxspi->MspInitCallback = pCallback;
        break;
      case HAL_XSPI_MSP_DEINIT_CB_ID :
        hxspi->MspDeInitCallback = pCallback;
        break;
      default :
        /* Update the error code */
        hxspi->ErrorCode |= HAL_XSPI_ERROR_INVALID_CALLBACK;
        /* update return status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (hxspi->State == HAL_XSPI_STATE_RESET)
  {
    switch (CallbackID)
    {
      case HAL_XSPI_MSP_INIT_CB_ID :
        hxspi->MspInitCallback = pCallback;
        break;
      case HAL_XSPI_MSP_DEINIT_CB_ID :
        hxspi->MspDeInitCallback = pCallback;
        break;
      default :
        /* Update the error code */
        hxspi->ErrorCode |= HAL_XSPI_ERROR_INVALID_CALLBACK;
        /* update return status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hxspi->ErrorCode |= HAL_XSPI_ERROR_INVALID_CALLBACK;
    /* update return status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
#if defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_XSPI_UnRegisterCallback(XSPI_HandleTypeDef *hxspi, HAL_XSPI_CallbackIDTypeDef CallbackID)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (hxspi->State == HAL_XSPI_STATE_READY)
  {
    switch (CallbackID)
    {
      case  HAL_XSPI_ERROR_CB_ID :
        hxspi->ErrorCallback = HAL_XSPI_ErrorCallback;
        break;
      case HAL_XSPI_ABORT_CB_ID :
        hxspi->AbortCpltCallback = HAL_XSPI_AbortCpltCallback;
        break;
      case HAL_XSPI_FIFO_THRESHOLD_CB_ID :
        hxspi->FifoThresholdCallback = HAL_XSPI_FifoThresholdCallback;
        break;
      case HAL_XSPI_CMD_CPLT_CB_ID :
        hxspi->CmdCpltCallback = HAL_XSPI_CmdCpltCallback;
        break;
      case HAL_XSPI_RX_CPLT_CB_ID :
        hxspi->RxCpltCallback = HAL_XSPI_RxCpltCallback;
        break;
      case HAL_XSPI_TX_CPLT_CB_ID :
        hxspi->TxCpltCallback = HAL_XSPI_TxCpltCallback;
        break;
      case HAL_XSPI_RX_HALF_CPLT_CB_ID :
        hxspi->RxHalfCpltCallback = HAL_XSPI_RxHalfCpltCallback;
        break;
      case HAL_XSPI_TX_HALF_CPLT_CB_ID :
        hxspi->TxHalfCpltCallback = HAL_XSPI_TxHalfCpltCallback;
        break;
      case HAL_XSPI_STATUS_MATCH_CB_ID :
        hxspi->StatusMatchCallback = HAL_XSPI_StatusMatchCallback;
        break;
      case HAL_XSPI_TIMEOUT_CB_ID :
        hxspi->TimeOutCallback = HAL_XSPI_TimeOutCallback;
        break;
      case HAL_XSPI_MSP_INIT_CB_ID :
        hxspi->MspInitCallback = HAL_XSPI_MspInit;
        break;
      case HAL_XSPI_MSP_DEINIT_CB_ID :
        hxspi->MspDeInitCallback = HAL_XSPI_MspDeInit;
        break;
      default :
        /* Update the error code */
        hxspi->ErrorCode |= HAL_XSPI_ERROR_INVALID_CALLBACK;
        /* update return status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (hxspi->State == HAL_XSPI_STATE_RESET)
  {
    switch (CallbackID)
    {
      case HAL_XSPI_MSP_INIT_CB_ID :
        hxspi->MspInitCallback = HAL_XSPI_MspInit;
        break;
      case HAL_XSPI_MSP_DEINIT_CB_ID :
        hxspi->MspDeInitCallback = HAL_XSPI_MspDeInit;
        break;
      default :
        /* Update the error code */
        hxspi->ErrorCode |= HAL_XSPI_ERROR_INVALID_CALLBACK;
        /* update return status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hxspi->ErrorCode |= HAL_XSPI_ERROR_INVALID_CALLBACK;
    /* update return status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_Abort(XSPI_HandleTypeDef *hxspi)
{
  HAL_StatusTypeDef status = HAL_OK;
  uint32_t tickstart = HAL_GetTick();

  /* Check if the state is not in reset state */
  if (hxspi->State != HAL_XSPI_STATE_RESET)
  {
    /* Check if the DMA is enabled */
    if ((hxspi->Instance->CR & XSPI_CR_DMAEN) != 0U)
    {
      /* Disable the DMA transfer on the XSPI side */
      CLEAR_BIT(hxspi->Instance->CR, XSPI_CR_DMAEN);

      /* Disable the DMA transmit on the DMA side */
      status = HAL_DMA_Abort(hxspi->hdmatx);
      if (status != HAL_OK)
      {
        hxspi->ErrorCode = HAL_XSPI_ERROR_DMA;
      }

      /* Disable the DMA receive on the DMA side */
      status = HAL_DMA_Abort(hxspi->hdmarx);
      if (status != HAL_OK)
      {
        hxspi->ErrorCode = HAL_XSPI_ERROR_DMA;
      }
    }

    if (HAL_XSPI_GET_FLAG(hxspi, HAL_XSPI_FLAG_BUSY) != RESET)
    {
      /* Perform an abort of the XSPI */
      SET_BIT(hxspi->Instance->CR, XSPI_CR_ABORT);

      /* Wait until the transfer complete flag is set to go back in idle state */
      status = XSPI_WaitFlagStateUntilTimeout(hxspi, HAL_XSPI_FLAG_TC, SET, tickstart, hxspi->Timeout);

      if (status == HAL_OK)
      {
        /* Clear transfer complete flag */
        HAL_XSPI_CLEAR_FLAG(hxspi, HAL_XSPI_FLAG_TC);

        /* Wait until the busy flag is reset to go back in idle state */
        status = XSPI_WaitFlagStateUntilTimeout(hxspi, HAL_XSPI_FLAG_BUSY, RESET, tickstart, hxspi->Timeout);

        if (status == HAL_OK)
        {
          /* Return to indirect mode */
          CLEAR_BIT(hxspi->Instance->CR, XSPI_CR_FMODE);

          hxspi->State = HAL_XSPI_STATE_READY;
        }
      }
    }
    else
    {
      /* Return to indirect mode */
      CLEAR_BIT(hxspi->Instance->CR, XSPI_CR_FMODE);

      hxspi->State = HAL_XSPI_STATE_READY;
    }
  }
  else
  {
    status = HAL_ERROR;
    hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_SEQUENCE;
  }

  return status;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_Abort_IT(XSPI_HandleTypeDef *hxspi)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check if the state is not in reset state */
  if (hxspi->State != HAL_XSPI_STATE_RESET)
  {
    /* Disable all interrupts */
    HAL_XSPI_DISABLE_IT(hxspi, (HAL_XSPI_IT_TO | HAL_XSPI_IT_SM | HAL_XSPI_IT_FT | HAL_XSPI_IT_TC | HAL_XSPI_IT_TE));

    hxspi->State = HAL_XSPI_STATE_ABORT;

    /* Check if the DMA is enabled */
    if ((hxspi->Instance->CR & XSPI_CR_DMAEN) != 0U)
    {
      /* Disable the DMA transfer on the XSPI side */
      CLEAR_BIT(hxspi->Instance->CR, XSPI_CR_DMAEN);

      /* Disable the DMA transmit on the DMA side */
      hxspi->hdmatx->XferAbortCallback = XSPI_DMAAbortCplt;
      if (HAL_DMA_Abort_IT(hxspi->hdmatx) != HAL_OK)
      {
        hxspi->State = HAL_XSPI_STATE_READY;

        /* Abort callback */
#if defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U)
        hxspi->AbortCpltCallback(hxspi);
#else
        HAL_XSPI_AbortCpltCallback(hxspi);
#endif /* (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U) */
      }

      /* Disable the DMA receive on the DMA side */
      hxspi->hdmarx->XferAbortCallback = XSPI_DMAAbortCplt;
      if (HAL_DMA_Abort_IT(hxspi->hdmarx) != HAL_OK)
      {
        hxspi->State = HAL_XSPI_STATE_READY;

        /* Abort callback */
#if defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U)
        hxspi->AbortCpltCallback(hxspi);
#else
        HAL_XSPI_AbortCpltCallback(hxspi);
#endif /* (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U) */
      }
    }
    else
    {
      if (HAL_XSPI_GET_FLAG(hxspi, HAL_XSPI_FLAG_BUSY) != RESET)
      {
        /* Clear transfer complete flag */
        HAL_XSPI_CLEAR_FLAG(hxspi, HAL_XSPI_FLAG_TC);

        /* Enable the transfer complete interrupts */
        HAL_XSPI_ENABLE_IT(hxspi, HAL_XSPI_IT_TC);

        /* Perform an abort of the XSPI */
        SET_BIT(hxspi->Instance->CR, XSPI_CR_ABORT);

        /* Return to indirect mode */
        CLEAR_BIT(hxspi->Instance->CR, XSPI_CR_FMODE);
      }
      else
      {
        /* Return to indirect mode */
        CLEAR_BIT(hxspi->Instance->CR, XSPI_CR_FMODE);

        hxspi->State = HAL_XSPI_STATE_READY;

        /* Abort callback */
#if defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U)
        hxspi->AbortCpltCallback(hxspi);
#else
        HAL_XSPI_AbortCpltCallback(hxspi);
#endif /* (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U) */
      }
    }
  }
  else
  {
    status = HAL_ERROR;
    hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_SEQUENCE;
  }

  return status;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_SetFifoThreshold(XSPI_HandleTypeDef *hxspi, uint32_t Threshold)
{
  HAL_StatusTypeDef status = HAL_OK;

  assert_param(IS_XSPI_FIFO_THRESHOLD_BYTE(Threshold));

  /* Check the state */
  if ((hxspi->State & XSPI_BUSY_STATE_MASK) == 0U)
  {
    /* Synchronize initialization structure with the new fifo threshold value */
    hxspi->Init.FifoThresholdByte = Threshold;

    /* Configure new fifo threshold */
    MODIFY_REG(hxspi->Instance->CR, XSPI_CR_FTHRES, ((hxspi->Init.FifoThresholdByte - 1U) << XSPI_CR_FTHRES_Pos));

  }
  else
  {
    status = HAL_ERROR;
    hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_SEQUENCE;
  }

  return status;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
uint32_t HAL_XSPI_GetFifoThreshold(const XSPI_HandleTypeDef *hxspi)
{
  return ((READ_BIT(hxspi->Instance->CR, XSPI_CR_FTHRES) >> XSPI_CR_FTHRES_Pos) + 1U);
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_SetMemoryType(XSPI_HandleTypeDef *hxspi, uint32_t Type)
{
  HAL_StatusTypeDef status = HAL_OK;

  assert_param(IS_XSPI_MEMORY_TYPE(Type));

  /* Check the state */
  if ((hxspi->State & XSPI_BUSY_STATE_MASK) == 0U)
  {
    /* Synchronize initialization structure with the new memory type value */
    hxspi->Init.MemoryType = Type;

    /* Configure new memory type */
    MODIFY_REG(hxspi->Instance->DCR1, XSPI_DCR1_MTYP, hxspi->Init.MemoryType);
  }
  else
  {
    status = HAL_ERROR;
    hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_SEQUENCE;
  }

  return status;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_SetDeviceSize(XSPI_HandleTypeDef *hxspi, uint32_t Size)
{
  HAL_StatusTypeDef status = HAL_OK;

  assert_param(IS_XSPI_MEMORY_SIZE(Size));

  /* Check the state */
  if ((hxspi->State & XSPI_BUSY_STATE_MASK) == 0U)
  {
    /* Synchronize initialization structure with the new device size value */
    hxspi->Init.MemorySize = Size;

    /* Configure new device size */
    MODIFY_REG(hxspi->Instance->DCR1, XSPI_DCR1_DEVSIZE,
               (hxspi->Init.MemorySize << XSPI_DCR1_DEVSIZE_Pos));
  }
  else
  {
    status = HAL_ERROR;
    hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_SEQUENCE;
  }

  return status;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_SetClockPrescaler(XSPI_HandleTypeDef *hxspi, uint32_t Prescaler)
{
  HAL_StatusTypeDef status = HAL_OK;
  assert_param(IS_XSPI_CLK_PRESCALER(Prescaler));

  /* Check the state */
  if ((hxspi->State & XSPI_BUSY_STATE_MASK) == 0U)
  {
    /* Synchronize initialization structure with the new clock prescaler value */
    hxspi->Init.ClockPrescaler = Prescaler;

    /* Configure clock prescaler */
    MODIFY_REG(hxspi->Instance->DCR2, XSPI_DCR2_PRESCALER,
               ((hxspi->Init.ClockPrescaler) << XSPI_DCR2_PRESCALER_Pos));
  }
  else
  {
    status = HAL_ERROR;
    hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_SEQUENCE;
  }

  return status;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_SetTimeout(XSPI_HandleTypeDef *hxspi, uint32_t Timeout)
{
  hxspi->Timeout = Timeout;
  return HAL_OK;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
uint32_t HAL_XSPI_GetError(const XSPI_HandleTypeDef *hxspi)
{
  return hxspi->ErrorCode;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
uint32_t HAL_XSPI_GetState(const XSPI_HandleTypeDef *hxspi)
{
  /* Return XSPI handle state */
  return hxspi->State;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPIM_Config(XSPI_HandleTypeDef *hxspi, const XSPIM_CfgTypeDef *pCfg, uint32_t Timeout)
{
  HAL_StatusTypeDef status = HAL_OK;
  uint8_t index;
  uint8_t xspi_enabled = 0U;

  XSPIM_CfgTypeDef IOM_cfg[XSPI_NB_INSTANCE] = {0};

  /* Prevent unused argument(s) compilation warning */
  UNUSED(Timeout);

  /* Check the parameters of the XSPI IO Manager configuration structure */
  assert_param(IS_XSPIM_NCS_OVR(pCfg->nCSOverride));
  assert_param(IS_XSPIM_IO_PORT(pCfg->IOPort));
  assert_param(IS_XSPIM_REQ2ACKTIME(pCfg->Req2AckTime));

  /**************** Get current configuration of the instances ****************/
  for (index = 0U; index < XSPI_NB_INSTANCE; index++)
  {
    XSPIM_GetConfig(index + 1U, &(IOM_cfg[index]));
  }

  /********** Disable both XSPI to configure XSPI IO Manager *****************/
  if ((XSPI1->CR & XSPI_CR_EN) != 0U)
  {
    CLEAR_BIT(XSPI1->CR, XSPI_CR_EN);
    xspi_enabled |= 0x1U;
  }
  if ((XSPI2->CR & XSPI_CR_EN) != 0U)
  {
    CLEAR_BIT(XSPI2->CR, XSPI_CR_EN);
    xspi_enabled |= 0x2U;
  }

  /***************** Store Port assignment ***********************************/
  if (hxspi->Instance == XSPI1)
  {
    IOM_cfg[0].IOPort = pCfg->IOPort ;
  }
  else if (hxspi->Instance == XSPI2)
  {
    IOM_cfg[1].IOPort = pCfg->IOPort ;
  }
  else
  {
    hxspi->ErrorCode |= HAL_XSPI_ERROR_INVALID_PARAM;
    return HAL_ERROR;
  }

  /******************** Store CSSEL_OVR settings before configuration ********/
  uint32_t reg = XSPIM->CR;
  uint32_t ovr_xspi1;
  uint32_t ovr_xspi2;
  if ((reg & XSPIM_CR_CSSEL_OVR_EN) == XSPIM_CR_CSSEL_OVR_EN)
  {
    if ((reg & XSPIM_CR_CSSEL_OVR_O1) == XSPIM_CR_CSSEL_OVR_O1)
    {
      ovr_xspi1 = HAL_XSPI_CSSEL_OVR_NCS2;
    }
    else
    {
      ovr_xspi1 = HAL_XSPI_CSSEL_OVR_NCS1;
    }
    if ((reg & XSPIM_CR_CSSEL_OVR_O2) == XSPIM_CR_CSSEL_OVR_O2)
    {
      ovr_xspi2 = HAL_XSPI_CSSEL_OVR_NCS2;
    }
    else
    {
      ovr_xspi2 = HAL_XSPI_CSSEL_OVR_NCS1;
    }
  }
  else
  {
    ovr_xspi1 = HAL_XSPI_CSSEL_OVR_DISABLED;
    ovr_xspi2 = HAL_XSPI_CSSEL_OVR_DISABLED;
  }

  /***************** Reset of previous configuration *************************/
  CLEAR_REG(XSPIM->CR);

  /******************** Activation of new configuration **********************/
  MODIFY_REG(XSPIM->CR, XSPIM_CR_REQ2ACK_TIME, ((pCfg->Req2AckTime - 1U) << XSPIM_CR_REQ2ACK_TIME_Pos));

  /******************** CSSEL_OVR management *********************************/
  if (hxspi->Instance == XSPI1)
  {
    ovr_xspi1 = pCfg->nCSOverride;
  }
  else if (hxspi->Instance == XSPI2)
  {
    ovr_xspi2 = pCfg->nCSOverride;
  }
  else
  {
    /* Nothing to do */
  }

  uint32_t ovr_en = 0U;
  if ((ovr_xspi1 != HAL_XSPI_CSSEL_OVR_DISABLED) || (ovr_xspi2 != HAL_XSPI_CSSEL_OVR_DISABLED))
  {
    ovr_en = XSPIM_CR_CSSEL_OVR_EN;
  }
  else
  {
    ovr_xspi1 = HAL_XSPI_CSSEL_OVR_NCS1;
    ovr_xspi2 = HAL_XSPI_CSSEL_OVR_NCS1;
  }

  reg &= ~(XSPIM_CR_CSSEL_OVR_EN | XSPIM_CR_CSSEL_OVR_O1 | XSPIM_CR_CSSEL_OVR_O2);
  if (ovr_en == XSPIM_CR_CSSEL_OVR_EN)
  {
    reg |= XSPIM_CR_CSSEL_OVR_EN;
  }
  if (ovr_xspi1 == HAL_XSPI_CSSEL_OVR_NCS2)
  {
    reg |= XSPIM_CR_CSSEL_OVR_O1;
  }
  if (ovr_xspi2 == HAL_XSPI_CSSEL_OVR_NCS2)
  {
    reg |= XSPIM_CR_CSSEL_OVR_O2;
  }

  MODIFY_REG(XSPIM->CR, (XSPIM_CR_CSSEL_OVR_EN | XSPIM_CR_CSSEL_OVR_O1 | XSPIM_CR_CSSEL_OVR_O2),
             (reg & (XSPIM_CR_CSSEL_OVR_EN | XSPIM_CR_CSSEL_OVR_O1 | XSPIM_CR_CSSEL_OVR_O2)));

  /******************** Management of MUXEN and MODE *************************/
  for (index = 0U; index < (XSPI_NB_INSTANCE - 1U); index++)
  {
    if (IOM_cfg[index].IOPort == IOM_cfg[index + 1U].IOPort)
    {
      /*Mux*/
      SET_BIT(XSPIM->CR, XSPIM_CR_MUXEN);
    }
    else
    {
      /* Nothing to do */
    }
    if (IOM_cfg[0].IOPort == HAL_XSPIM_IOPORT_2)
    {
      /*Mode*/
      SET_BIT(XSPIM->CR, XSPIM_CR_MODE);
    }
    else
    {
      /* Nothing to do */
    }
  }

  /******* Re-enable both XSPI after configure XSPI IO Manager ***************/
  if ((xspi_enabled & 0x1U) != 0U)
  {
    SET_BIT(XSPI1->CR, XSPI_CR_EN);
  }
  if ((xspi_enabled & 0x2U) != 0U)
  {
    SET_BIT(XSPI2->CR, XSPI_CR_EN);
  }

  return status;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_GetDelayValue(XSPI_HandleTypeDef *hxspi, XSPI_HSCalTypeDef *pCfg)
{
  HAL_StatusTypeDef status = HAL_OK;
  __IO uint32_t reg = 0;

  if (IS_XSPI_ALL_INSTANCE(hxspi->Instance))
  {
    /* Check the parameter specified in the structure */
    assert_param(IS_XSPI_DELAY_TYPE(pCfg->DelayValueType));

    switch (pCfg->DelayValueType)
    {
      case HAL_XSPI_CAL_FULL_CYCLE_DELAY:
        reg = hxspi->Instance->CALFCR;
        pCfg->MaxCalibration = (reg & XSPI_CALFCR_CALMAX);
        break;
      case HAL_XSPI_CAL_FEEDBACK_CLK_DELAY:
        reg = hxspi->Instance->CALMR;
        break;
      case HAL_XSPI_CAL_DATA_OUTPUT_DELAY:
        reg = hxspi->Instance->CALSOR;
        break;
      case HAL_XSPI_CAL_DQS_INPUT_DELAY:
        reg = hxspi->Instance->CALSIR;
        break;
      default:
        status = HAL_ERROR;
        hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_PARAM;
        break;
    }

    if (status == HAL_OK)
    {
      pCfg->FineCalibrationUnit = (reg & XSPI_CALFCR_FINE);
      pCfg->CoarseCalibrationUnit = ((reg & XSPI_CALFCR_COARSE) >> XSPI_CALFCR_COARSE_Pos);
    }
  }
  else
  {
    status = HAL_ERROR;
    hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_PARAM;
  }

  return status;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_SetDelayValue(XSPI_HandleTypeDef *hxspi, const XSPI_HSCalTypeDef *pCfg)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (IS_XSPI_ALL_INSTANCE(hxspi->Instance))
  {
    /* Check the parameter specified in the structure */
    assert_param(IS_XSPI_DELAY_TYPE(pCfg->DelayValueType));
    assert_param(IS_XSPI_FINECAL_VALUE(pCfg->FineCalibrationUnit));
    assert_param(IS_XSPI_COARSECAL_VALUE(pCfg->CoarseCalibrationUnit));

    /* Check if the state isn't in one of the busy states */
    if ((hxspi->State & XSPI_BUSY_STATE_MASK) == 0U)
    {
      switch (pCfg->DelayValueType)
      {
        case HAL_XSPI_CAL_FEEDBACK_CLK_DELAY:
          MODIFY_REG(hxspi->Instance->CALMR, (XSPI_CALMR_COARSE |  XSPI_CALMR_FINE),
                     (pCfg->FineCalibrationUnit | (pCfg->CoarseCalibrationUnit << XSPI_CALMR_COARSE_Pos)));
          break;
        case HAL_XSPI_CAL_DATA_OUTPUT_DELAY:
          MODIFY_REG(hxspi->Instance->CALSOR, (XSPI_CALSOR_COARSE | XSPI_CALSOR_FINE),
                     (pCfg->FineCalibrationUnit | (pCfg->CoarseCalibrationUnit << XSPI_CALSOR_COARSE_Pos)));
          break;
        case HAL_XSPI_CAL_DQS_INPUT_DELAY:
          MODIFY_REG(hxspi->Instance->CALSIR, (XSPI_CALSIR_COARSE | XSPI_CALSIR_FINE),
                     (pCfg->FineCalibrationUnit | (pCfg->CoarseCalibrationUnit << XSPI_CALSIR_COARSE_Pos)));
          break;
        default:
          status = HAL_ERROR;
          hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_PARAM;
          break;
      }
    }
    else
    {
      status = HAL_ERROR;
      hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_SEQUENCE;
    }
  }
  else
  {
    status = HAL_ERROR;
    hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_PARAM;
  }

  return status;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
static void XSPI_DMACplt(DMA_HandleTypeDef *hdma)
{
  XSPI_HandleTypeDef *hxspi = (XSPI_HandleTypeDef *)(hdma->Parent);
  hxspi->XferCount = 0;

  /* Disable the DMA transfer on the XSPI side */
  CLEAR_BIT(hxspi->Instance->CR, XSPI_CR_DMAEN);

  /* Enable the XSPI transfer complete Interrupt */
  HAL_XSPI_ENABLE_IT(hxspi, HAL_XSPI_IT_TC);
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
static void XSPI_DMAHalfCplt(DMA_HandleTypeDef *hdma)
{
  XSPI_HandleTypeDef *hxspi = (XSPI_HandleTypeDef *)(hdma->Parent);
  hxspi->XferCount = (hxspi->XferCount >> 1);

  if (hxspi->State == HAL_XSPI_STATE_BUSY_RX)
  {
#if defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U)
    hxspi->RxHalfCpltCallback(hxspi);
#else
    HAL_XSPI_RxHalfCpltCallback(hxspi);
#endif /* (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U) */
  }
  else
  {
#if defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U)
    hxspi->TxHalfCpltCallback(hxspi);
#else
    HAL_XSPI_TxHalfCpltCallback(hxspi);
#endif /* (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U) */
  }
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
static void XSPI_DMAError(DMA_HandleTypeDef *hdma)
{
  XSPI_HandleTypeDef *hxspi = (XSPI_HandleTypeDef *)(hdma->Parent);
  hxspi->XferCount = 0;
  hxspi->ErrorCode = HAL_XSPI_ERROR_DMA;

  /* Disable the DMA transfer on the XSPI side */
  CLEAR_BIT(hxspi->Instance->CR, XSPI_CR_DMAEN);

  /* Abort the XSPI */
  if (HAL_XSPI_Abort_IT(hxspi) != HAL_OK)
  {
    /* Disable the interrupts */
    HAL_XSPI_DISABLE_IT(hxspi, HAL_XSPI_IT_TC | HAL_XSPI_IT_FT | HAL_XSPI_IT_TE);

    hxspi->State = HAL_XSPI_STATE_READY;

    /* Error callback */
#if defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U)
    hxspi->ErrorCallback(hxspi);
#else
    HAL_XSPI_ErrorCallback(hxspi);
#endif /* (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U) */
  }
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
static void XSPI_DMAAbortCplt(DMA_HandleTypeDef *hdma)
{
  XSPI_HandleTypeDef *hxspi = (XSPI_HandleTypeDef *)(hdma->Parent);
  hxspi->XferCount = 0;

  /* Check the state */
  if (hxspi->State == HAL_XSPI_STATE_ABORT)
  {
    /* DMA abort called by XSPI abort */
    if (HAL_XSPI_GET_FLAG(hxspi, HAL_XSPI_FLAG_BUSY) != RESET)
    {
      /* Clear transfer complete flag */
      HAL_XSPI_CLEAR_FLAG(hxspi, HAL_XSPI_FLAG_TC);

      /* Enable the transfer complete interrupts */
      HAL_XSPI_ENABLE_IT(hxspi, HAL_XSPI_IT_TC);

      /* Perform an abort of the XSPI */
      SET_BIT(hxspi->Instance->CR, XSPI_CR_ABORT);
    }
    else
    {
      hxspi->State = HAL_XSPI_STATE_READY;

      /* Abort callback */
#if defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U)
      hxspi->AbortCpltCallback(hxspi);
#else
      HAL_XSPI_AbortCpltCallback(hxspi);
#endif /* (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U) */
    }
  }
  else
  {
    /* DMA abort called due to a transfer error interrupt */
    hxspi->State = HAL_XSPI_STATE_READY;

    /* Error callback */
#if defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U)
    hxspi->ErrorCallback(hxspi);
#else
    HAL_XSPI_ErrorCallback(hxspi);
#endif /* defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U) */
  }
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
static HAL_StatusTypeDef XSPI_WaitFlagStateUntilTimeout(XSPI_HandleTypeDef *hxspi, uint32_t Flag,
                                                        FlagStatus State, uint32_t Tickstart, uint32_t Timeout)
{
  /* Wait until flag is in expected state */
  while ((HAL_XSPI_GET_FLAG(hxspi, Flag)) != State)
  {
    /* Check for the Timeout */
    if (Timeout != HAL_MAX_DELAY)
    {
      if (((HAL_GetTick() - Tickstart) > Timeout) || (Timeout == 0U))
      {
        hxspi->State     = HAL_XSPI_STATE_READY;
        hxspi->ErrorCode |= HAL_XSPI_ERROR_TIMEOUT;

        return HAL_TIMEOUT;
      }
    }
  }
  return HAL_OK;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
static HAL_StatusTypeDef XSPI_ConfigCmd(XSPI_HandleTypeDef *hxspi, const XSPI_RegularCmdTypeDef *pCmd)
{
  HAL_StatusTypeDef status = HAL_OK;
  __IO uint32_t *ccr_reg;
  __IO uint32_t *tcr_reg;
  __IO uint32_t *ir_reg;
  __IO uint32_t *abr_reg;

  /* Re-initialize the value of the functional mode */
  MODIFY_REG(hxspi->Instance->CR, XSPI_CR_FMODE, 0U);

  if (hxspi->Init.MemoryMode == HAL_XSPI_SINGLE_MEM)
  {
    assert_param(IS_XSPI_IO_SELECT(pCmd->IOSelect));
    MODIFY_REG(hxspi->Instance->CR, XSPI_CR_MSEL, pCmd->IOSelect);
  }

  if (pCmd->OperationType == HAL_XSPI_OPTYPE_WRITE_CFG)
  {
    ccr_reg = &(hxspi->Instance->WCCR);
    tcr_reg = &(hxspi->Instance->WTCR);
    ir_reg  = &(hxspi->Instance->WIR);
    abr_reg = &(hxspi->Instance->WABR);
  }
  else if (pCmd->OperationType == HAL_XSPI_OPTYPE_WRAP_CFG)
  {
    ccr_reg = &(hxspi->Instance->WPCCR);
    tcr_reg = &(hxspi->Instance->WPTCR);
    ir_reg  = &(hxspi->Instance->WPIR);
    abr_reg = &(hxspi->Instance->WPABR);
  }
  else
  {
    ccr_reg = &(hxspi->Instance->CCR);
    tcr_reg = &(hxspi->Instance->TCR);
    ir_reg  = &(hxspi->Instance->IR);
    abr_reg = &(hxspi->Instance->ABR);
  }

  /* Configure the CCR register with DQS mode */
  *ccr_reg = pCmd->DQSMode;

  if (pCmd->AlternateBytesMode != HAL_XSPI_ALT_BYTES_NONE)
  {
    /* Configure the ABR register with alternate bytes value */
    *abr_reg = pCmd->AlternateBytes;

    /* Configure the CCR register with alternate bytes communication parameters */
    MODIFY_REG((*ccr_reg), (XSPI_CCR_ABMODE | XSPI_CCR_ABDTR | XSPI_CCR_ABSIZE),
               (pCmd->AlternateBytesMode | pCmd->AlternateBytesDTRMode | pCmd->AlternateBytesWidth));
  }

  /* Configure the TCR register with the number of dummy cycles */
  MODIFY_REG((*tcr_reg), XSPI_TCR_DCYC, pCmd->DummyCycles);

  if (pCmd->DataMode != HAL_XSPI_DATA_NONE)
  {
    if (pCmd->OperationType == HAL_XSPI_OPTYPE_COMMON_CFG)
    {
      /* Configure the DLR register with the number of data */
      hxspi->Instance->DLR = (pCmd->DataLength - 1U);
    }
  }

  /* Configure SSHIFT register to handle SDR/DTR data transfer */
  if (pCmd->DataMode != HAL_XSPI_DATA_NONE)
  {
    if (pCmd->DataDTRMode == HAL_XSPI_DATA_DTR_ENABLE)
    {
      /* Deactivate sample shifting when receiving data in DTR mode (DDTR=1) */
      CLEAR_BIT(hxspi->Instance->TCR, XSPI_TCR_SSHIFT);
    }
    else if (hxspi->Init.SampleShifting == HAL_XSPI_SAMPLE_SHIFT_HALFCYCLE)
    {
      /* Configure sample shifting */
      SET_BIT(hxspi->Instance->TCR, XSPI_TCR_SSHIFT);
    }
    else
    {
      /* Do nothing */
    }
  }

  if (pCmd->InstructionMode != HAL_XSPI_INSTRUCTION_NONE)
  {
    if (pCmd->AddressMode != HAL_XSPI_ADDRESS_NONE)
    {
      if (pCmd->DataMode != HAL_XSPI_DATA_NONE)
      {
        /* ---- Command with instruction, address and data ---- */

        /* Configure the CCR register with all communication parameters */
        MODIFY_REG((*ccr_reg), (XSPI_CCR_IMODE  | XSPI_CCR_IDTR  | XSPI_CCR_ISIZE  |
                                XSPI_CCR_ADMODE | XSPI_CCR_ADDTR | XSPI_CCR_ADSIZE |
                                XSPI_CCR_DMODE  | XSPI_CCR_DDTR),
                   (pCmd->InstructionMode | pCmd->InstructionDTRMode | pCmd->InstructionWidth |
                    pCmd->AddressMode     | pCmd->AddressDTRMode     | pCmd->AddressWidth     |
                    pCmd->DataMode        | pCmd->DataDTRMode));
      }
      else
      {
        /* ---- Command with instruction and address ---- */

        /* Configure the CCR register with all communication parameters */
        MODIFY_REG((*ccr_reg), (XSPI_CCR_IMODE  | XSPI_CCR_IDTR  | XSPI_CCR_ISIZE  |
                                XSPI_CCR_ADMODE | XSPI_CCR_ADDTR | XSPI_CCR_ADSIZE),
                   (pCmd->InstructionMode | pCmd->InstructionDTRMode | pCmd->InstructionWidth |
                    pCmd->AddressMode     | pCmd->AddressDTRMode     | pCmd->AddressWidth));
      }
      /* Configure the IR register with the instruction value */
      *ir_reg = pCmd->Instruction;

      /* Configure the AR register with the address value */
      hxspi->Instance->AR = pCmd->Address;

      if (pCmd->OperationType == HAL_XSPI_OPTYPE_COMMON_CFG)
      {
        /* Verify if programmed address fit with requirement of Reference Manual 28.5 chapter */
        assert_param(IS_XSPI_PROG_ADDR(hxspi->Instance->AR, pCmd->Address));
      }
    }
    else
    {
      if (pCmd->DataMode != HAL_XSPI_DATA_NONE)
      {
        /* ---- Command with instruction and data ---- */

        /* Configure the CCR register with all communication parameters */
        MODIFY_REG((*ccr_reg), (XSPI_CCR_IMODE | XSPI_CCR_IDTR | XSPI_CCR_ISIZE |
                                XSPI_CCR_DMODE | XSPI_CCR_DDTR),
                   (pCmd->InstructionMode | pCmd->InstructionDTRMode | pCmd->InstructionWidth |
                    pCmd->DataMode        | pCmd->DataDTRMode));
      }
      else
      {
        /* ---- Command with only instruction ---- */

        /* Configure the CCR register with all communication parameters */
        MODIFY_REG((*ccr_reg), (XSPI_CCR_IMODE | XSPI_CCR_IDTR | XSPI_CCR_ISIZE),
                   (pCmd->InstructionMode | pCmd->InstructionDTRMode | pCmd->InstructionWidth));
      }

      /* Configure the IR register with the instruction value */
      *ir_reg = pCmd->Instruction;

    }
  }
  else
  {
    if (pCmd->AddressMode != HAL_XSPI_ADDRESS_NONE)
    {
      if (pCmd->DataMode != HAL_XSPI_DATA_NONE)
      {
        /* ---- Command with address and data ---- */

        /* Configure the CCR register with all communication parameters */
        MODIFY_REG((*ccr_reg), (XSPI_CCR_ADMODE | XSPI_CCR_ADDTR | XSPI_CCR_ADSIZE |
                                XSPI_CCR_DMODE  | XSPI_CCR_DDTR),
                   (pCmd->AddressMode | pCmd->AddressDTRMode | pCmd->AddressWidth     |
                    pCmd->DataMode    | pCmd->DataDTRMode));
      }
      else
      {
        /* ---- Command with only address ---- */

        /* Configure the CCR register with all communication parameters */
        MODIFY_REG((*ccr_reg), (XSPI_CCR_ADMODE | XSPI_CCR_ADDTR | XSPI_CCR_ADSIZE),
                   (pCmd->AddressMode | pCmd->AddressDTRMode | pCmd->AddressWidth));
      }

      /* Configure the AR register with the instruction value */
      hxspi->Instance->AR = pCmd->Address;

      if (pCmd->OperationType == HAL_XSPI_OPTYPE_COMMON_CFG)
      {
        /* Verify if programmed address fit with requirement of Reference Manual 28.5 chapter */
        assert_param(IS_XSPI_PROG_ADDR(hxspi->Instance->AR, pCmd->Address));
      }
    }
    else
    {
      /* ---- Invalid command configuration (no instruction, no address) ---- */
      status = HAL_ERROR;
      hxspi->ErrorCode = HAL_XSPI_ERROR_INVALID_PARAM;
    }
  }

  if (pCmd->DataMode != HAL_XSPI_DATA_NONE)
  {
    if (pCmd->OperationType == HAL_XSPI_OPTYPE_COMMON_CFG)
    {
      /* Configure the DLR register with the number of data */
      hxspi->Instance->DLR = (pCmd->DataLength - 1U);

      /* Verify if programmed data fit with requirement of Reference Manual 28.5 chapter */
      assert_param(IS_XSPI_PROG_DATA(hxspi->Instance->DLR, (pCmd->DataLength - 1U)));
    }
  }

  return status;
}
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
static void XSPIM_GetConfig(uint8_t instance_nb, XSPIM_CfgTypeDef *pCfg)
{
  uint32_t mux;
  uint32_t mode;

  if (instance_nb == 1U)
  {
    if ((XSPIM->CR & XSPIM_CR_MODE) == 0U)
    {
      pCfg->IOPort = HAL_XSPIM_IOPORT_1;
    }
    else
    {
      pCfg->IOPort = HAL_XSPIM_IOPORT_2;
    }

    if ((XSPIM->CR & XSPIM_CR_CSSEL_OVR_EN) != XSPIM_CR_CSSEL_OVR_EN)
    {
      pCfg->nCSOverride = HAL_XSPI_CSSEL_OVR_DISABLED;
    }
    else if ((XSPIM->CR & XSPIM_CR_CSSEL_OVR_O1) == XSPIM_CR_CSSEL_OVR_O1)
    {
      pCfg->nCSOverride = HAL_XSPI_CSSEL_OVR_NCS2;
    }
    else
    {
      pCfg->nCSOverride = HAL_XSPI_CSSEL_OVR_NCS1;
    }
  }
  else
  {
    mux = (XSPIM->CR & XSPIM_CR_MUXEN);
    mode = ((XSPIM->CR & XSPIM_CR_MODE) >> XSPIM_CR_MODE_Pos);
    if (mux != mode)
    {
      pCfg->IOPort = HAL_XSPIM_IOPORT_1;
    }
    else
    {
      pCfg->IOPort = HAL_XSPIM_IOPORT_2;
    }
    if ((XSPIM->CR & XSPIM_CR_CSSEL_OVR_EN) != XSPIM_CR_CSSEL_OVR_EN)
    {
      pCfg->nCSOverride = HAL_XSPI_CSSEL_OVR_DISABLED;
    }
    else if ((XSPIM->CR & XSPIM_CR_CSSEL_OVR_O2) == XSPIM_CR_CSSEL_OVR_O2)
    {
      pCfg->nCSOverride = HAL_XSPI_CSSEL_OVR_NCS2;
    }
    else
    {
      pCfg->nCSOverride = HAL_XSPI_CSSEL_OVR_NCS1;
    }
  }
}
#endif
#endif
