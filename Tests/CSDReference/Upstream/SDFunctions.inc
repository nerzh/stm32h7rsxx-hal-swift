// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SD/SDEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.


#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_Init(SD_HandleTypeDef *hsd)
{
  HAL_SD_CardStatusTypeDef CardStatus;
  uint32_t speedgrade;
  uint32_t unitsize;
  uint32_t tickstart;

  /* Check the SD handle allocation */
  if (hsd == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_SDMMC_ALL_INSTANCE(hsd->Instance));
  assert_param(IS_SDMMC_CLOCK_EDGE(hsd->Init.ClockEdge));
  assert_param(IS_SDMMC_CLOCK_POWER_SAVE(hsd->Init.ClockPowerSave));
  assert_param(IS_SDMMC_BUS_WIDE(hsd->Init.BusWide));
  assert_param(IS_SDMMC_HARDWARE_FLOW_CONTROL(hsd->Init.HardwareFlowControl));
  assert_param(IS_SDMMC_CLKDIV(hsd->Init.ClockDiv));

  if (hsd->State == HAL_SD_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    hsd->Lock = HAL_UNLOCKED;

#if (USE_SD_TRANSCEIVER != 0U)
    /* Force  SDMMC_TRANSCEIVER_PRESENT for Legacy usage */
    if (hsd->Init.TranceiverPresent == SDMMC_TRANSCEIVER_UNKNOWN)
    {
      hsd->Init.TranceiverPresent = SDMMC_TRANSCEIVER_PRESENT;
    }
#endif /*USE_SD_TRANSCEIVER */
#if defined (USE_HAL_SD_REGISTER_CALLBACKS) && (USE_HAL_SD_REGISTER_CALLBACKS == 1U)
    /* Reset Callback pointers in HAL_SD_STATE_RESET only */
    hsd->TxCpltCallback    = HAL_SD_TxCpltCallback;
    hsd->RxCpltCallback    = HAL_SD_RxCpltCallback;
    hsd->ErrorCallback     = HAL_SD_ErrorCallback;
    hsd->AbortCpltCallback = HAL_SD_AbortCallback;
    hsd->Read_DMALnkLstBufCpltCallback  = HAL_SDEx_Read_DMALnkLstBufCpltCallback;
    hsd->Write_DMALnkLstBufCpltCallback = HAL_SDEx_Write_DMALnkLstBufCpltCallback;
#if (USE_SD_TRANSCEIVER != 0U)
    if (hsd->Init.TranceiverPresent == SDMMC_TRANSCEIVER_PRESENT)
    {
      hsd->DriveTransceiver_1_8V_Callback = HAL_SD_DriveTransceiver_1_8V_Callback;
    }
#endif /* USE_SD_TRANSCEIVER */

    if (hsd->MspInitCallback == NULL)
    {
      hsd->MspInitCallback = HAL_SD_MspInit;
    }

    /* Init the low level hardware */
    hsd->MspInitCallback(hsd);
#else
    /* Init the low level hardware : GPIO, CLOCK, CORTEX...etc */
    HAL_SD_MspInit(hsd);
#endif /* USE_HAL_SD_REGISTER_CALLBACKS */
  }

  hsd->State = HAL_SD_STATE_PROGRAMMING;

  /* Initialize the Card parameters */
  if (HAL_SD_InitCard(hsd) != HAL_OK)
  {
    return HAL_ERROR;
  }

  if (HAL_SD_GetCardStatus(hsd, &CardStatus) != HAL_OK)
  {
    return HAL_ERROR;
  }
  /* Get Initial Card Speed from Card Status*/
  speedgrade = CardStatus.UhsSpeedGrade;
  unitsize = CardStatus.UhsAllocationUnitSize;
  if ((hsd->SdCard.CardType == CARD_SDHC_SDXC) && ((speedgrade != 0U) || (unitsize != 0U)))
  {
    hsd->SdCard.CardSpeed = CARD_ULTRA_HIGH_SPEED;
  }
  else
  {
    if (hsd->SdCard.CardType == CARD_SDHC_SDXC)
    {
      hsd->SdCard.CardSpeed  = CARD_HIGH_SPEED;
    }
    else
    {
      hsd->SdCard.CardSpeed  = CARD_NORMAL_SPEED;
    }

  }
  /* Configure the bus wide */
  if (HAL_SD_ConfigWideBusOperation(hsd, hsd->Init.BusWide) != HAL_OK)
  {
    return HAL_ERROR;
  }

  /* Verify that SD card is ready to use after Initialization */
  tickstart = HAL_GetTick();
  while ((HAL_SD_GetCardState(hsd) != HAL_SD_CARD_TRANSFER))
  {
    if ((HAL_GetTick() - tickstart) >=  SDMMC_SWDATATIMEOUT)
    {
      hsd->ErrorCode = HAL_SD_ERROR_TIMEOUT;
      hsd->State = HAL_SD_STATE_READY;
      return HAL_TIMEOUT;
    }
  }

  /* Initialize the error code */
  hsd->ErrorCode = HAL_SD_ERROR_NONE;

  /* Initialize the SD operation */
  hsd->Context = SD_CONTEXT_NONE;

  /* Initialize the SD state */
  hsd->State = HAL_SD_STATE_READY;

  return HAL_OK;
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_InitCard(SD_HandleTypeDef *hsd)
{
  uint32_t errorstate;
  SD_InitTypeDef Init = {0U};
  uint32_t sdmmc_clk;

  /* Default SDMMC peripheral configuration for SD card initialization */
  Init.ClockEdge           = SDMMC_CLOCK_EDGE_RISING;
  Init.ClockPowerSave      = SDMMC_CLOCK_POWER_SAVE_DISABLE;
  Init.BusWide             = SDMMC_BUS_WIDE_1B;
  Init.HardwareFlowControl = SDMMC_HARDWARE_FLOW_CONTROL_DISABLE;

  /* Init Clock should be less or equal to 400Khz*/
  sdmmc_clk = HAL_RCCEx_GetPeriphCLKFreq(RCC_PERIPHCLK_SDMMC12);
  if (sdmmc_clk == 0U)
  {
    hsd->State = HAL_SD_STATE_READY;
    hsd->ErrorCode = SDMMC_ERROR_INVALID_PARAMETER;
    return HAL_ERROR;
  }
  Init.ClockDiv = sdmmc_clk / (2U * SD_INIT_FREQ);

#if (USE_SD_TRANSCEIVER != 0U)
  Init.TranceiverPresent = hsd->Init.TranceiverPresent;

  if (hsd->Init.TranceiverPresent == SDMMC_TRANSCEIVER_PRESENT)
  {
    /* Set Transceiver polarity */
    hsd->Instance->POWER |= SDMMC_POWER_DIRPOL;
  }
#elif defined (USE_SD_DIRPOL)
  /* Set Transceiver polarity */
  hsd->Instance->POWER |= SDMMC_POWER_DIRPOL;
#endif /* USE_SD_TRANSCEIVER  */

  /* Initialize SDMMC peripheral interface with default configuration */
  (void)SDMMC_Init(hsd->Instance, Init);

  /* Set Power State to ON */
  (void)SDMMC_PowerState_ON(hsd->Instance);

  /* wait 74 Cycles: required power up waiting time before starting
     the SD initialization sequence */
  if (Init.ClockDiv != 0U)
  {
    sdmmc_clk = sdmmc_clk / (2U * Init.ClockDiv);
  }

  if (sdmmc_clk != 0U)
  {
    HAL_Delay(1U + (74U * 1000U / (sdmmc_clk)));
  }

  /* Identify card operating voltage */
  errorstate = SD_PowerON(hsd);
  if (errorstate != HAL_SD_ERROR_NONE)
  {
    hsd->State = HAL_SD_STATE_READY;
    hsd->ErrorCode |= errorstate;
    return HAL_ERROR;
  }

  /* Card initialization */
  errorstate = SD_InitCard(hsd);
  if (errorstate != HAL_SD_ERROR_NONE)
  {
    hsd->State = HAL_SD_STATE_READY;
    hsd->ErrorCode |= errorstate;
    return HAL_ERROR;
  }

  /* Set Block Size for Card */
  errorstate = SDMMC_CmdBlockLength(hsd->Instance, BLOCKSIZE);
  if (errorstate != HAL_SD_ERROR_NONE)
  {
    /* Clear all the static flags */
    __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
    hsd->ErrorCode |= errorstate;
    hsd->State = HAL_SD_STATE_READY;
    return HAL_ERROR;
  }

  return HAL_OK;
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_DeInit(SD_HandleTypeDef *hsd)
{
  /* Check the SD handle allocation */
  if (hsd == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_SDMMC_ALL_INSTANCE(hsd->Instance));

  hsd->State = HAL_SD_STATE_BUSY;

#if (USE_SD_TRANSCEIVER != 0U)
  /* Deactivate the 1.8V Mode */
  if (hsd->Init.TranceiverPresent == SDMMC_TRANSCEIVER_PRESENT)
  {
#if defined (USE_HAL_SD_REGISTER_CALLBACKS) && (USE_HAL_SD_REGISTER_CALLBACKS == 1U)
    if (hsd->DriveTransceiver_1_8V_Callback == NULL)
    {
      hsd->DriveTransceiver_1_8V_Callback = HAL_SD_DriveTransceiver_1_8V_Callback;
    }
    hsd->DriveTransceiver_1_8V_Callback(RESET);
#else
    HAL_SD_DriveTransceiver_1_8V_Callback(RESET);
#endif /* USE_HAL_SD_REGISTER_CALLBACKS */
  }
#endif /* USE_SD_TRANSCEIVER   */

  /* Set SD power state to off */
  SD_PowerOFF(hsd);

#if defined (USE_HAL_SD_REGISTER_CALLBACKS) && (USE_HAL_SD_REGISTER_CALLBACKS == 1U)
  if (hsd->MspDeInitCallback == NULL)
  {
    hsd->MspDeInitCallback = HAL_SD_MspDeInit;
  }

  /* DeInit the low level hardware */
  hsd->MspDeInitCallback(hsd);
#else
  /* De-Initialize the MSP layer */
  HAL_SD_MspDeInit(hsd);
#endif /* USE_HAL_SD_REGISTER_CALLBACKS */

  hsd->ErrorCode = HAL_SD_ERROR_NONE;
  hsd->State = HAL_SD_STATE_RESET;

  return HAL_OK;
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_ReadBlocks(SD_HandleTypeDef *hsd, uint8_t *pData, uint32_t BlockAdd, uint32_t NumberOfBlocks,
                                    uint32_t Timeout)
{
  SDMMC_DataInitTypeDef config;
  uint32_t errorstate;
  uint32_t tickstart = HAL_GetTick();
  uint32_t count;
  uint32_t data;
  uint32_t dataremaining;
  uint32_t add = BlockAdd;
  uint8_t *tempbuff = pData;

  if (NULL == pData)
  {
    hsd->ErrorCode |= HAL_SD_ERROR_PARAM;
    return HAL_ERROR;
  }

  if (hsd->State == HAL_SD_STATE_READY)
  {
    hsd->ErrorCode = HAL_SD_ERROR_NONE;

    if ((add + NumberOfBlocks) > (hsd->SdCard.LogBlockNbr))
    {
      hsd->ErrorCode |= HAL_SD_ERROR_ADDR_OUT_OF_RANGE;
      return HAL_ERROR;
    }

    hsd->State = HAL_SD_STATE_BUSY;

    /* Initialize data control register */
    hsd->Instance->DCTRL = 0U;

    if (hsd->SdCard.CardType != CARD_SDHC_SDXC)
    {
      add *= BLOCKSIZE;
    }

    /* Configure the SD DPSM (Data Path State Machine) */
    config.DataTimeOut   = SDMMC_DATATIMEOUT;
    config.DataLength    = NumberOfBlocks * BLOCKSIZE;
    config.DataBlockSize = SDMMC_DATABLOCK_SIZE_512B;
    config.TransferDir   = SDMMC_TRANSFER_DIR_TO_SDMMC;
    config.TransferMode  = SDMMC_TRANSFER_MODE_BLOCK;
    config.DPSM          = SDMMC_DPSM_DISABLE;
    (void)SDMMC_ConfigData(hsd->Instance, &config);
    __SDMMC_CMDTRANS_ENABLE(hsd->Instance);

    /* Read block(s) in polling mode */
    if (NumberOfBlocks > 1U)
    {
      hsd->Context = SD_CONTEXT_READ_MULTIPLE_BLOCK;

      /* Read Multi Block command */
      errorstate = SDMMC_CmdReadMultiBlock(hsd->Instance, add);
    }
    else
    {
      hsd->Context = SD_CONTEXT_READ_SINGLE_BLOCK;

      /* Read Single Block command */
      errorstate = SDMMC_CmdReadSingleBlock(hsd->Instance, add);
    }
    if (errorstate != HAL_SD_ERROR_NONE)
    {
      /* Clear all the static flags */
      __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
      hsd->ErrorCode |= errorstate;
      hsd->State = HAL_SD_STATE_READY;
      hsd->Context = SD_CONTEXT_NONE;
      return HAL_ERROR;
    }

    /* Poll on SDMMC flags */
    dataremaining = config.DataLength;
    while (!__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_RXOVERR | SDMMC_FLAG_DCRCFAIL | SDMMC_FLAG_DTIMEOUT | SDMMC_FLAG_DATAEND))
    {
      if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_RXFIFOHF) && (dataremaining >= SDMMC_FIFO_SIZE))
      {
        /* Read data from SDMMC Rx FIFO */
        for (count = 0U; count < (SDMMC_FIFO_SIZE / 4U); count++)
        {
          data = SDMMC_ReadFIFO(hsd->Instance);
          *tempbuff = (uint8_t)(data & 0xFFU);
          tempbuff++;
          *tempbuff = (uint8_t)((data >> 8U) & 0xFFU);
          tempbuff++;
          *tempbuff = (uint8_t)((data >> 16U) & 0xFFU);
          tempbuff++;
          *tempbuff = (uint8_t)((data >> 24U) & 0xFFU);
          tempbuff++;
        }
        dataremaining -= SDMMC_FIFO_SIZE;
      }

      if (((HAL_GetTick() - tickstart) >=  Timeout) || (Timeout == 0U))
      {
        /* Clear all the static flags */
        __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
        hsd->ErrorCode |= HAL_SD_ERROR_TIMEOUT;
        hsd->State = HAL_SD_STATE_READY;
        hsd->Context = SD_CONTEXT_NONE;
        return HAL_TIMEOUT;
      }
    }
    __SDMMC_CMDTRANS_DISABLE(hsd->Instance);

    /* Send stop transmission command in case of multiblock read */
    if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_DATAEND) && (NumberOfBlocks > 1U))
    {
      if (hsd->SdCard.CardType != CARD_SECURED)
      {
        /* Send stop transmission command */
        errorstate = SDMMC_CmdStopTransfer(hsd->Instance);
        if (errorstate != HAL_SD_ERROR_NONE)
        {
          /* Clear all the static flags */
          __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
          hsd->ErrorCode |= errorstate;
          hsd->State = HAL_SD_STATE_READY;
          hsd->Context = SD_CONTEXT_NONE;
          return HAL_ERROR;
        }
      }
    }

    /* Get error state */
    if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_DTIMEOUT))
    {
      /* Clear all the static flags */
      __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
      hsd->ErrorCode |= HAL_SD_ERROR_DATA_TIMEOUT;
      hsd->State = HAL_SD_STATE_READY;
      hsd->Context = SD_CONTEXT_NONE;
      return HAL_ERROR;
    }
    else if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_DCRCFAIL))
    {
      /* Clear all the static flags */
      __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
      hsd->ErrorCode |= HAL_SD_ERROR_DATA_CRC_FAIL;
      hsd->State = HAL_SD_STATE_READY;
      hsd->Context = SD_CONTEXT_NONE;
      return HAL_ERROR;
    }
    else if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_RXOVERR))
    {
      /* Clear all the static flags */
      __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
      hsd->ErrorCode |= HAL_SD_ERROR_RX_OVERRUN;
      hsd->State = HAL_SD_STATE_READY;
      hsd->Context = SD_CONTEXT_NONE;
      return HAL_ERROR;
    }
    else
    {
      /* Nothing to do */
    }

    /* Clear all the static flags */
    __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_DATA_FLAGS);

    hsd->State = HAL_SD_STATE_READY;

    return HAL_OK;
  }
  else
  {
    hsd->ErrorCode |= HAL_SD_ERROR_BUSY;
    return HAL_ERROR;
  }
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_WriteBlocks(SD_HandleTypeDef *hsd, const uint8_t *pData, uint32_t BlockAdd,
                                     uint32_t NumberOfBlocks, uint32_t Timeout)
{
  SDMMC_DataInitTypeDef config;
  uint32_t errorstate;
  uint32_t tickstart = HAL_GetTick();
  uint32_t count;
  uint32_t data;
  uint32_t dataremaining;
  uint32_t add = BlockAdd;
  const uint8_t *tempbuff = pData;

  if (NULL == pData)
  {
    hsd->ErrorCode |= HAL_SD_ERROR_PARAM;
    return HAL_ERROR;
  }

  if (hsd->State == HAL_SD_STATE_READY)
  {
    hsd->ErrorCode = HAL_SD_ERROR_NONE;

    if ((add + NumberOfBlocks) > (hsd->SdCard.LogBlockNbr))
    {
      hsd->ErrorCode |= HAL_SD_ERROR_ADDR_OUT_OF_RANGE;
      return HAL_ERROR;
    }

    hsd->State = HAL_SD_STATE_BUSY;

    /* Initialize data control register */
    hsd->Instance->DCTRL = 0U;

    if (hsd->SdCard.CardType != CARD_SDHC_SDXC)
    {
      add *= BLOCKSIZE;
    }

    /* Configure the SD DPSM (Data Path State Machine) */
    config.DataTimeOut   = SDMMC_DATATIMEOUT;
    config.DataLength    = NumberOfBlocks * BLOCKSIZE;
    config.DataBlockSize = SDMMC_DATABLOCK_SIZE_512B;
    config.TransferDir   = SDMMC_TRANSFER_DIR_TO_CARD;
    config.TransferMode  = SDMMC_TRANSFER_MODE_BLOCK;
    config.DPSM          = SDMMC_DPSM_DISABLE;
    (void)SDMMC_ConfigData(hsd->Instance, &config);
    __SDMMC_CMDTRANS_ENABLE(hsd->Instance);

    /* Write Blocks in Polling mode */
    if (NumberOfBlocks > 1U)
    {
      hsd->Context = SD_CONTEXT_WRITE_MULTIPLE_BLOCK;

      /* Write Multi Block command */
      errorstate = SDMMC_CmdWriteMultiBlock(hsd->Instance, add);
    }
    else
    {
      hsd->Context = SD_CONTEXT_WRITE_SINGLE_BLOCK;

      /* Write Single Block command */
      errorstate = SDMMC_CmdWriteSingleBlock(hsd->Instance, add);
    }
    if (errorstate != HAL_SD_ERROR_NONE)
    {
      /* Clear all the static flags */
      __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
      hsd->ErrorCode |= errorstate;
      hsd->State = HAL_SD_STATE_READY;
      hsd->Context = SD_CONTEXT_NONE;
      return HAL_ERROR;
    }

    /* Write block(s) in polling mode */
    dataremaining = config.DataLength;
    while (!__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_TXUNDERR | SDMMC_FLAG_DCRCFAIL | SDMMC_FLAG_DTIMEOUT |
                              SDMMC_FLAG_DATAEND))
    {
      if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_TXFIFOHE) && (dataremaining >= SDMMC_FIFO_SIZE))
      {
        /* Write data to SDMMC Tx FIFO */
        for (count = 0U; count < (SDMMC_FIFO_SIZE / 4U); count++)
        {
          data = (uint32_t)(*tempbuff);
          tempbuff++;
          data |= ((uint32_t)(*tempbuff) << 8U);
          tempbuff++;
          data |= ((uint32_t)(*tempbuff) << 16U);
          tempbuff++;
          data |= ((uint32_t)(*tempbuff) << 24U);
          tempbuff++;
          (void)SDMMC_WriteFIFO(hsd->Instance, &data);
        }
        dataremaining -= SDMMC_FIFO_SIZE;
      }

      if (((HAL_GetTick() - tickstart) >=  Timeout) || (Timeout == 0U))
      {
        /* Clear all the static flags */
        __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
        hsd->ErrorCode |= errorstate;
        hsd->State = HAL_SD_STATE_READY;
        hsd->Context = SD_CONTEXT_NONE;
        return HAL_TIMEOUT;
      }
    }
    __SDMMC_CMDTRANS_DISABLE(hsd->Instance);

    /* Send stop transmission command in case of multiblock write */
    if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_DATAEND) && (NumberOfBlocks > 1U))
    {
      if (hsd->SdCard.CardType != CARD_SECURED)
      {
        /* Send stop transmission command */
        errorstate = SDMMC_CmdStopTransfer(hsd->Instance);
        if (errorstate != HAL_SD_ERROR_NONE)
        {
          /* Clear all the static flags */
          __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
          hsd->ErrorCode |= errorstate;
          hsd->State = HAL_SD_STATE_READY;
          hsd->Context = SD_CONTEXT_NONE;
          return HAL_ERROR;
        }
      }
    }

    /* Get error state */
    if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_DTIMEOUT))
    {
      /* Clear all the static flags */
      __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
      hsd->ErrorCode |= HAL_SD_ERROR_DATA_TIMEOUT;
      hsd->State = HAL_SD_STATE_READY;
      hsd->Context = SD_CONTEXT_NONE;
      return HAL_ERROR;
    }
    else if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_DCRCFAIL))
    {
      /* Clear all the static flags */
      __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
      hsd->ErrorCode |= HAL_SD_ERROR_DATA_CRC_FAIL;
      hsd->State = HAL_SD_STATE_READY;
      hsd->Context = SD_CONTEXT_NONE;
      return HAL_ERROR;
    }
    else if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_TXUNDERR))
    {
      /* Clear all the static flags */
      __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
      hsd->ErrorCode |= HAL_SD_ERROR_TX_UNDERRUN;
      hsd->State = HAL_SD_STATE_READY;
      hsd->Context = SD_CONTEXT_NONE;
      return HAL_ERROR;
    }
    else
    {
      /* Nothing to do */
    }

    /* Clear all the static flags */
    __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_DATA_FLAGS);

    hsd->State = HAL_SD_STATE_READY;

    return HAL_OK;
  }
  else
  {
    hsd->ErrorCode |= HAL_SD_ERROR_BUSY;
    return HAL_ERROR;
  }
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_ReadBlocks_IT(SD_HandleTypeDef *hsd, uint8_t *pData, uint32_t BlockAdd,
                                       uint32_t NumberOfBlocks)
{
  SDMMC_DataInitTypeDef config;
  uint32_t errorstate;
  uint32_t add = BlockAdd;

  if (NULL == pData)
  {
    hsd->ErrorCode |= HAL_SD_ERROR_PARAM;
    return HAL_ERROR;
  }

  if (hsd->State == HAL_SD_STATE_READY)
  {
    hsd->ErrorCode = HAL_SD_ERROR_NONE;

    if ((add + NumberOfBlocks) > (hsd->SdCard.LogBlockNbr))
    {
      hsd->ErrorCode |= HAL_SD_ERROR_ADDR_OUT_OF_RANGE;
      return HAL_ERROR;
    }

    hsd->State = HAL_SD_STATE_BUSY;

    /* Initialize data control register */
    hsd->Instance->DCTRL = 0U;

    hsd->pRxBuffPtr = pData;
    hsd->RxXferSize = BLOCKSIZE * NumberOfBlocks;

    if (hsd->SdCard.CardType != CARD_SDHC_SDXC)
    {
      add *= BLOCKSIZE;
    }

    /* Configure the SD DPSM (Data Path State Machine) */
    config.DataTimeOut   = SDMMC_DATATIMEOUT;
    config.DataLength    = BLOCKSIZE * NumberOfBlocks;
    config.DataBlockSize = SDMMC_DATABLOCK_SIZE_512B;
    config.TransferDir   = SDMMC_TRANSFER_DIR_TO_SDMMC;
    config.TransferMode  = SDMMC_TRANSFER_MODE_BLOCK;
    config.DPSM          = SDMMC_DPSM_DISABLE;
    (void)SDMMC_ConfigData(hsd->Instance, &config);
    __SDMMC_CMDTRANS_ENABLE(hsd->Instance);

    /* Read Blocks in IT mode */
    if (NumberOfBlocks > 1U)
    {
      hsd->Context = (SD_CONTEXT_READ_MULTIPLE_BLOCK | SD_CONTEXT_IT);

      /* Read Multi Block command */
      errorstate = SDMMC_CmdReadMultiBlock(hsd->Instance, add);
    }
    else
    {
      hsd->Context = (SD_CONTEXT_READ_SINGLE_BLOCK | SD_CONTEXT_IT);

      /* Read Single Block command */
      errorstate = SDMMC_CmdReadSingleBlock(hsd->Instance, add);
    }
    if (errorstate != HAL_SD_ERROR_NONE)
    {
      /* Clear all the static flags */
      __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
      hsd->ErrorCode |= errorstate;
      hsd->State = HAL_SD_STATE_READY;
      hsd->Context = SD_CONTEXT_NONE;
      return HAL_ERROR;
    }

    __HAL_SD_ENABLE_IT(hsd, (SDMMC_IT_DCRCFAIL | SDMMC_IT_DTIMEOUT | SDMMC_IT_RXOVERR | SDMMC_IT_DATAEND |
                             SDMMC_FLAG_RXFIFOHF));

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_WriteBlocks_IT(SD_HandleTypeDef *hsd, const uint8_t *pData, uint32_t BlockAdd,
                                        uint32_t NumberOfBlocks)
{
  SDMMC_DataInitTypeDef config;
  uint32_t errorstate;
  uint32_t add = BlockAdd;

  if (NULL == pData)
  {
    hsd->ErrorCode |= HAL_SD_ERROR_PARAM;
    return HAL_ERROR;
  }

  if (hsd->State == HAL_SD_STATE_READY)
  {
    hsd->ErrorCode = HAL_SD_ERROR_NONE;

    if ((add + NumberOfBlocks) > (hsd->SdCard.LogBlockNbr))
    {
      hsd->ErrorCode |= HAL_SD_ERROR_ADDR_OUT_OF_RANGE;
      return HAL_ERROR;
    }

    hsd->State = HAL_SD_STATE_BUSY;

    /* Initialize data control register */
    hsd->Instance->DCTRL = 0U;

    hsd->pTxBuffPtr = pData;
    hsd->TxXferSize = BLOCKSIZE * NumberOfBlocks;

    if (hsd->SdCard.CardType != CARD_SDHC_SDXC)
    {
      add *= BLOCKSIZE;
    }

    /* Configure the SD DPSM (Data Path State Machine) */
    config.DataTimeOut   = SDMMC_DATATIMEOUT;
    config.DataLength    = BLOCKSIZE * NumberOfBlocks;
    config.DataBlockSize = SDMMC_DATABLOCK_SIZE_512B;
    config.TransferDir   = SDMMC_TRANSFER_DIR_TO_CARD;
    config.TransferMode  = SDMMC_TRANSFER_MODE_BLOCK;
    config.DPSM          = SDMMC_DPSM_DISABLE;
    (void)SDMMC_ConfigData(hsd->Instance, &config);

    __SDMMC_CMDTRANS_ENABLE(hsd->Instance);

    /* Write Blocks in Polling mode */
    if (NumberOfBlocks > 1U)
    {
      hsd->Context = (SD_CONTEXT_WRITE_MULTIPLE_BLOCK | SD_CONTEXT_IT);

      /* Write Multi Block command */
      errorstate = SDMMC_CmdWriteMultiBlock(hsd->Instance, add);
    }
    else
    {
      hsd->Context = (SD_CONTEXT_WRITE_SINGLE_BLOCK | SD_CONTEXT_IT);

      /* Write Single Block command */
      errorstate = SDMMC_CmdWriteSingleBlock(hsd->Instance, add);
    }
    if (errorstate != HAL_SD_ERROR_NONE)
    {
      /* Clear all the static flags */
      __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
      hsd->ErrorCode |= errorstate;
      hsd->State = HAL_SD_STATE_READY;
      hsd->Context = SD_CONTEXT_NONE;
      return HAL_ERROR;
    }

    /* Enable transfer interrupts */
    __HAL_SD_ENABLE_IT(hsd, (SDMMC_IT_DCRCFAIL | SDMMC_IT_DTIMEOUT | SDMMC_IT_TXUNDERR | SDMMC_IT_DATAEND |
                             SDMMC_FLAG_TXFIFOHE));

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_ReadBlocks_DMA(SD_HandleTypeDef *hsd, uint8_t *pData, uint32_t BlockAdd,
                                        uint32_t NumberOfBlocks)
{
  SDMMC_DataInitTypeDef config;
  uint32_t errorstate;
  uint32_t add = BlockAdd;

  if (NULL == pData)
  {
    hsd->ErrorCode |= HAL_SD_ERROR_PARAM;
    return HAL_ERROR;
  }

  if (hsd->State == HAL_SD_STATE_READY)
  {
    hsd->ErrorCode = HAL_SD_ERROR_NONE;

    if ((add + NumberOfBlocks) > (hsd->SdCard.LogBlockNbr))
    {
      hsd->ErrorCode |= HAL_SD_ERROR_ADDR_OUT_OF_RANGE;
      return HAL_ERROR;
    }

    hsd->State = HAL_SD_STATE_BUSY;

    /* Initialize data control register */
    hsd->Instance->DCTRL = 0U;

    hsd->pRxBuffPtr = pData;
    hsd->RxXferSize = BLOCKSIZE * NumberOfBlocks;

    if (hsd->SdCard.CardType != CARD_SDHC_SDXC)
    {
      add *= BLOCKSIZE;
    }

    /* Configure the SD DPSM (Data Path State Machine) */
    config.DataTimeOut   = SDMMC_DATATIMEOUT;
    config.DataLength    = BLOCKSIZE * NumberOfBlocks;
    config.DataBlockSize = SDMMC_DATABLOCK_SIZE_512B;
    config.TransferDir   = SDMMC_TRANSFER_DIR_TO_SDMMC;
    config.TransferMode  = SDMMC_TRANSFER_MODE_BLOCK;
    config.DPSM          = SDMMC_DPSM_DISABLE;
    (void)SDMMC_ConfigData(hsd->Instance, &config);

    __SDMMC_CMDTRANS_ENABLE(hsd->Instance);
    hsd->Instance->IDMABASER = (uint32_t) pData ;
    hsd->Instance->IDMACTRL  = SDMMC_ENABLE_IDMA_SINGLE_BUFF;

    /* Read Blocks in DMA mode */
    if (NumberOfBlocks > 1U)
    {
      hsd->Context = (SD_CONTEXT_READ_MULTIPLE_BLOCK | SD_CONTEXT_DMA);

      /* Read Multi Block command */
      errorstate = SDMMC_CmdReadMultiBlock(hsd->Instance, add);
    }
    else
    {
      hsd->Context = (SD_CONTEXT_READ_SINGLE_BLOCK | SD_CONTEXT_DMA);

      /* Read Single Block command */
      errorstate = SDMMC_CmdReadSingleBlock(hsd->Instance, add);
    }
    if (errorstate != HAL_SD_ERROR_NONE)
    {
      /* Clear all the static flags */
      __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
      hsd->ErrorCode |= errorstate;
      hsd->State = HAL_SD_STATE_READY;
      hsd->Context = SD_CONTEXT_NONE;
      return HAL_ERROR;
    }

    /* Enable transfer interrupts */
    __HAL_SD_ENABLE_IT(hsd, (SDMMC_IT_DCRCFAIL | SDMMC_IT_DTIMEOUT | SDMMC_IT_RXOVERR | SDMMC_IT_DATAEND));

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_WriteBlocks_DMA(SD_HandleTypeDef *hsd, const uint8_t *pData, uint32_t BlockAdd,
                                         uint32_t NumberOfBlocks)
{
  SDMMC_DataInitTypeDef config;
  uint32_t errorstate;
  uint32_t add = BlockAdd;

  if (NULL == pData)
  {
    hsd->ErrorCode |= HAL_SD_ERROR_PARAM;
    return HAL_ERROR;
  }

  if (hsd->State == HAL_SD_STATE_READY)
  {
    hsd->ErrorCode = HAL_SD_ERROR_NONE;

    if ((add + NumberOfBlocks) > (hsd->SdCard.LogBlockNbr))
    {
      hsd->ErrorCode |= HAL_SD_ERROR_ADDR_OUT_OF_RANGE;
      return HAL_ERROR;
    }

    hsd->State = HAL_SD_STATE_BUSY;

    /* Initialize data control register */
    hsd->Instance->DCTRL = 0U;

    hsd->pTxBuffPtr = pData;
    hsd->TxXferSize = BLOCKSIZE * NumberOfBlocks;

    if (hsd->SdCard.CardType != CARD_SDHC_SDXC)
    {
      add *= BLOCKSIZE;
    }

    /* Configure the SD DPSM (Data Path State Machine) */
    config.DataTimeOut   = SDMMC_DATATIMEOUT;
    config.DataLength    = BLOCKSIZE * NumberOfBlocks;
    config.DataBlockSize = SDMMC_DATABLOCK_SIZE_512B;
    config.TransferDir   = SDMMC_TRANSFER_DIR_TO_CARD;
    config.TransferMode  = SDMMC_TRANSFER_MODE_BLOCK;
    config.DPSM          = SDMMC_DPSM_DISABLE;
    (void)SDMMC_ConfigData(hsd->Instance, &config);

    __SDMMC_CMDTRANS_ENABLE(hsd->Instance);

    hsd->Instance->IDMABASER = (uint32_t) pData ;
    hsd->Instance->IDMACTRL  = SDMMC_ENABLE_IDMA_SINGLE_BUFF;

    /* Write Blocks in Polling mode */
    if (NumberOfBlocks > 1U)
    {
      hsd->Context = (SD_CONTEXT_WRITE_MULTIPLE_BLOCK | SD_CONTEXT_DMA);

      /* Write Multi Block command */
      errorstate = SDMMC_CmdWriteMultiBlock(hsd->Instance, add);
    }
    else
    {
      hsd->Context = (SD_CONTEXT_WRITE_SINGLE_BLOCK | SD_CONTEXT_DMA);

      /* Write Single Block command */
      errorstate = SDMMC_CmdWriteSingleBlock(hsd->Instance, add);
    }
    if (errorstate != HAL_SD_ERROR_NONE)
    {
      /* Clear all the static flags */
      __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
      hsd->ErrorCode |= errorstate;
      hsd->State = HAL_SD_STATE_READY;
      hsd->Context = SD_CONTEXT_NONE;
      return HAL_ERROR;
    }

    /* Enable transfer interrupts */
    __HAL_SD_ENABLE_IT(hsd, (SDMMC_IT_DCRCFAIL | SDMMC_IT_DTIMEOUT | SDMMC_IT_TXUNDERR | SDMMC_IT_DATAEND));

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_Erase(SD_HandleTypeDef *hsd, uint32_t BlockStartAdd, uint32_t BlockEndAdd)
{
  uint32_t errorstate;
  uint32_t start_add = BlockStartAdd;
  uint32_t end_add = BlockEndAdd;

  if (hsd->State == HAL_SD_STATE_READY)
  {
    hsd->ErrorCode = HAL_SD_ERROR_NONE;

    if (end_add < start_add)
    {
      hsd->ErrorCode |= HAL_SD_ERROR_PARAM;
      return HAL_ERROR;
    }

    if (end_add > (hsd->SdCard.LogBlockNbr))
    {
      hsd->ErrorCode |= HAL_SD_ERROR_ADDR_OUT_OF_RANGE;
      return HAL_ERROR;
    }

    hsd->State = HAL_SD_STATE_BUSY;

    /* Check if the card command class supports erase command */
    if (((hsd->SdCard.Class) & SDMMC_CCCC_ERASE) == 0U)
    {
      /* Clear all the static flags */
      __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
      hsd->ErrorCode |= HAL_SD_ERROR_REQUEST_NOT_APPLICABLE;
      hsd->State = HAL_SD_STATE_READY;
      return HAL_ERROR;
    }

    if ((SDMMC_GetResponse(hsd->Instance, SDMMC_RESP1) & SDMMC_CARD_LOCKED) == SDMMC_CARD_LOCKED)
    {
      /* Clear all the static flags */
      __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
      hsd->ErrorCode |= HAL_SD_ERROR_LOCK_UNLOCK_FAILED;
      hsd->State = HAL_SD_STATE_READY;
      return HAL_ERROR;
    }

    /* Get start and end block for high capacity cards */
    if (hsd->SdCard.CardType != CARD_SDHC_SDXC)
    {
      start_add *= BLOCKSIZE;
      end_add   *= BLOCKSIZE;
    }

    /* According to sd-card spec 1.0 ERASE_GROUP_START (CMD32) and erase_group_end(CMD33) */
    if (hsd->SdCard.CardType != CARD_SECURED)
    {
      /* Send CMD32 SD_ERASE_GRP_START with argument as addr  */
      errorstate = SDMMC_CmdSDEraseStartAdd(hsd->Instance, start_add);
      if (errorstate != HAL_SD_ERROR_NONE)
      {
        /* Clear all the static flags */
        __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
        hsd->ErrorCode |= errorstate;
        hsd->State = HAL_SD_STATE_READY;
        return HAL_ERROR;
      }

      /* Send CMD33 SD_ERASE_GRP_END with argument as addr  */
      errorstate = SDMMC_CmdSDEraseEndAdd(hsd->Instance, end_add);
      if (errorstate != HAL_SD_ERROR_NONE)
      {
        /* Clear all the static flags */
        __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
        hsd->ErrorCode |= errorstate;
        hsd->State = HAL_SD_STATE_READY;
        return HAL_ERROR;
      }
    }

    /* Send CMD38 ERASE */
    errorstate = SDMMC_CmdErase(hsd->Instance, 0UL);
    if (errorstate != HAL_SD_ERROR_NONE)
    {
      /* Clear all the static flags */
      __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
      hsd->ErrorCode |= errorstate;
      hsd->State = HAL_SD_STATE_READY;
      return HAL_ERROR;
    }

    hsd->State = HAL_SD_STATE_READY;

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
void HAL_SD_IRQHandler(SD_HandleTypeDef *hsd)
{
  uint32_t errorstate;
  uint32_t context = hsd->Context;

  /* Check for SDMMC interrupt flags */
  if ((__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_RXFIFOHF) != RESET) && ((context & SD_CONTEXT_IT) != 0U))
  {
    SD_Read_IT(hsd);
  }

  else if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_DATAEND) != RESET)
  {
    __HAL_SD_CLEAR_FLAG(hsd, SDMMC_FLAG_DATAEND);

    __HAL_SD_DISABLE_IT(hsd, SDMMC_IT_DATAEND  | SDMMC_IT_DCRCFAIL | SDMMC_IT_DTIMEOUT | \
                        SDMMC_IT_TXUNDERR | SDMMC_IT_RXOVERR  | SDMMC_IT_TXFIFOHE | \
                        SDMMC_IT_RXFIFOHF);

    __HAL_SD_DISABLE_IT(hsd, SDMMC_IT_IDMABTC);
    __SDMMC_CMDTRANS_DISABLE(hsd->Instance);

    if ((context & SD_CONTEXT_IT) != 0U)
    {
      if (((context & SD_CONTEXT_READ_MULTIPLE_BLOCK) != 0U) || ((context & SD_CONTEXT_WRITE_MULTIPLE_BLOCK) != 0U))
      {
        errorstate = SDMMC_CmdStopTransfer(hsd->Instance);
        if (errorstate != HAL_SD_ERROR_NONE)
        {
          hsd->ErrorCode |= errorstate;
#if defined (USE_HAL_SD_REGISTER_CALLBACKS) && (USE_HAL_SD_REGISTER_CALLBACKS == 1U)
          hsd->ErrorCallback(hsd);
#else
          HAL_SD_ErrorCallback(hsd);
#endif /* USE_HAL_SD_REGISTER_CALLBACKS */
        }
      }

      /* Clear all the static flags */
      __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_DATA_FLAGS);

      hsd->State = HAL_SD_STATE_READY;
      hsd->Context = SD_CONTEXT_NONE;
      if (((context & SD_CONTEXT_READ_SINGLE_BLOCK) != 0U) || ((context & SD_CONTEXT_READ_MULTIPLE_BLOCK) != 0U))
      {
#if defined (USE_HAL_SD_REGISTER_CALLBACKS) && (USE_HAL_SD_REGISTER_CALLBACKS == 1U)
        hsd->RxCpltCallback(hsd);
#else
        HAL_SD_RxCpltCallback(hsd);
#endif /* USE_HAL_SD_REGISTER_CALLBACKS */
      }
      else
      {
#if defined (USE_HAL_SD_REGISTER_CALLBACKS) && (USE_HAL_SD_REGISTER_CALLBACKS == 1U)
        hsd->TxCpltCallback(hsd);
#else
        HAL_SD_TxCpltCallback(hsd);
#endif /* USE_HAL_SD_REGISTER_CALLBACKS */
      }
    }
    else if ((context & SD_CONTEXT_DMA) != 0U)
    {
      hsd->Instance->DLEN = 0;
      hsd->Instance->DCTRL = 0;
      hsd->Instance->IDMACTRL = SDMMC_DISABLE_IDMA;

      /* Stop Transfer for Write Multi blocks or Read Multi blocks */
      if (((context & SD_CONTEXT_READ_MULTIPLE_BLOCK) != 0U) || ((context & SD_CONTEXT_WRITE_MULTIPLE_BLOCK) != 0U))
      {
        errorstate = SDMMC_CmdStopTransfer(hsd->Instance);
        if (errorstate != HAL_SD_ERROR_NONE)
        {
          hsd->ErrorCode |= errorstate;
#if defined (USE_HAL_SD_REGISTER_CALLBACKS) && (USE_HAL_SD_REGISTER_CALLBACKS == 1U)
          hsd->ErrorCallback(hsd);
#else
          HAL_SD_ErrorCallback(hsd);
#endif /* USE_HAL_SD_REGISTER_CALLBACKS */
        }
      }

      hsd->State = HAL_SD_STATE_READY;
      hsd->Context = SD_CONTEXT_NONE;
      if (((context & SD_CONTEXT_WRITE_SINGLE_BLOCK) != 0U) || ((context & SD_CONTEXT_WRITE_MULTIPLE_BLOCK) != 0U))
      {
#if defined (USE_HAL_SD_REGISTER_CALLBACKS) && (USE_HAL_SD_REGISTER_CALLBACKS == 1U)
        hsd->TxCpltCallback(hsd);
#else
        HAL_SD_TxCpltCallback(hsd);
#endif /* USE_HAL_SD_REGISTER_CALLBACKS */
      }
      if (((context & SD_CONTEXT_READ_SINGLE_BLOCK) != 0U) || ((context & SD_CONTEXT_READ_MULTIPLE_BLOCK) != 0U))
      {
#if defined (USE_HAL_SD_REGISTER_CALLBACKS) && (USE_HAL_SD_REGISTER_CALLBACKS == 1U)
        hsd->RxCpltCallback(hsd);
#else
        HAL_SD_RxCpltCallback(hsd);
#endif /* USE_HAL_SD_REGISTER_CALLBACKS */
      }
    }
    else
    {
      /* Nothing to do */
    }
  }

  else if ((__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_TXFIFOHE) != RESET) && ((context & SD_CONTEXT_IT) != 0U))
  {
    SD_Write_IT(hsd);
  }

  else if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_DCRCFAIL | SDMMC_FLAG_DTIMEOUT | SDMMC_FLAG_RXOVERR |
                             SDMMC_FLAG_TXUNDERR) != RESET)
  {
    /* Set Error code */
    if (__HAL_SD_GET_FLAG(hsd, SDMMC_IT_DCRCFAIL) != RESET)
    {
      hsd->ErrorCode |= HAL_SD_ERROR_DATA_CRC_FAIL;
    }
    if (__HAL_SD_GET_FLAG(hsd, SDMMC_IT_DTIMEOUT) != RESET)
    {
      hsd->ErrorCode |= HAL_SD_ERROR_DATA_TIMEOUT;
    }
    if (__HAL_SD_GET_FLAG(hsd, SDMMC_IT_RXOVERR) != RESET)
    {
      hsd->ErrorCode |= HAL_SD_ERROR_RX_OVERRUN;
    }
    if (__HAL_SD_GET_FLAG(hsd, SDMMC_IT_TXUNDERR) != RESET)
    {
      hsd->ErrorCode |= HAL_SD_ERROR_TX_UNDERRUN;
    }

    /* Clear All flags */
    __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_DATA_FLAGS);

    /* Disable all interrupts */
    __HAL_SD_DISABLE_IT(hsd, SDMMC_IT_DATAEND | SDMMC_IT_DCRCFAIL | SDMMC_IT_DTIMEOUT | \
                        SDMMC_IT_TXUNDERR | SDMMC_IT_RXOVERR);

    __SDMMC_CMDTRANS_DISABLE(hsd->Instance);
    hsd->Instance->DCTRL |= SDMMC_DCTRL_FIFORST;
    WRITE_REG(hsd->Instance->CMD, hsd->Instance->CMD | SDMMC_CMD_CMDSTOP);
    hsd->ErrorCode |= SDMMC_CmdStopTransfer(hsd->Instance);
    WRITE_REG(hsd->Instance->CMD, hsd->Instance->CMD & ~(SDMMC_CMD_CMDSTOP));
    __HAL_SD_CLEAR_FLAG(hsd, SDMMC_FLAG_DABORT);

    if ((context & SD_CONTEXT_IT) != 0U)
    {
      /* Set the SD state to ready to be able to start again the process */
      hsd->State = HAL_SD_STATE_READY;
      hsd->Context = SD_CONTEXT_NONE;
#if defined (USE_HAL_SD_REGISTER_CALLBACKS) && (USE_HAL_SD_REGISTER_CALLBACKS == 1U)
      hsd->ErrorCallback(hsd);
#else
      HAL_SD_ErrorCallback(hsd);
#endif /* USE_HAL_SD_REGISTER_CALLBACKS */
    }
    else if ((context & SD_CONTEXT_DMA) != 0U)
    {
      if (hsd->ErrorCode != HAL_SD_ERROR_NONE)
      {
        /* Disable Internal DMA */
        __HAL_SD_DISABLE_IT(hsd, SDMMC_IT_IDMABTC);
        hsd->Instance->IDMACTRL = SDMMC_DISABLE_IDMA;

        /* Set the SD state to ready to be able to start again the process */
        hsd->State = HAL_SD_STATE_READY;
#if defined (USE_HAL_SD_REGISTER_CALLBACKS) && (USE_HAL_SD_REGISTER_CALLBACKS == 1U)
        hsd->ErrorCallback(hsd);
#else
        HAL_SD_ErrorCallback(hsd);
#endif /* USE_HAL_SD_REGISTER_CALLBACKS */
      }
    }
    else
    {
      /* Nothing to do */
    }
  }

  else if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_IDMABTC) != RESET)
  {
    __HAL_SD_CLEAR_FLAG(hsd, SDMMC_FLAG_IDMABTC);

    if ((context & SD_CONTEXT_WRITE_MULTIPLE_BLOCK) != 0U)
    {
#if defined (USE_HAL_SD_REGISTER_CALLBACKS) && (USE_HAL_SD_REGISTER_CALLBACKS == 1U)
      hsd->Write_DMALnkLstBufCpltCallback(hsd);
#else
      HAL_SDEx_Write_DMALnkLstBufCpltCallback(hsd);
#endif /* USE_HAL_SD_REGISTER_CALLBACKS */
    }
    else /* SD_CONTEXT_READ_MULTIPLE_BLOCK */
    {
#if defined (USE_HAL_SD_REGISTER_CALLBACKS) && (USE_HAL_SD_REGISTER_CALLBACKS == 1U)
      hsd->Read_DMALnkLstBufCpltCallback(hsd);
#else
      HAL_SDEx_Read_DMALnkLstBufCpltCallback(hsd);
#endif /* USE_HAL_SD_REGISTER_CALLBACKS */
    }
  }
  else
  {
    /* Nothing to do */
  }
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_SD_StateTypeDef HAL_SD_GetState(const SD_HandleTypeDef *hsd)
{
  return hsd->State;
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
uint32_t HAL_SD_GetError(const SD_HandleTypeDef *hsd)
{
  return hsd->ErrorCode;
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
#if defined (USE_HAL_SD_REGISTER_CALLBACKS) && (USE_HAL_SD_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_SD_RegisterCallback(SD_HandleTypeDef *hsd, HAL_SD_CallbackIDTypeDef CallbackID,
                                          pSD_CallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hsd->ErrorCode |= HAL_SD_ERROR_INVALID_CALLBACK;
    return HAL_ERROR;
  }

  if (hsd->State == HAL_SD_STATE_READY)
  {
    switch (CallbackID)
    {
      case HAL_SD_TX_CPLT_CB_ID :
        hsd->TxCpltCallback = pCallback;
        break;
      case HAL_SD_RX_CPLT_CB_ID :
        hsd->RxCpltCallback = pCallback;
        break;
      case HAL_SD_ERROR_CB_ID :
        hsd->ErrorCallback = pCallback;
        break;
      case HAL_SD_ABORT_CB_ID :
        hsd->AbortCpltCallback = pCallback;
        break;
      case HAL_SD_READ_DMA_LNKLST_BUF_CPLT_CB_ID :
        hsd->Read_DMALnkLstBufCpltCallback = pCallback;
        break;
      case HAL_SD_WRITE_DMA_LNKLST_BUF_CPLT_CB_ID :
        hsd->Write_DMALnkLstBufCpltCallback = pCallback;
        break;
      case HAL_SD_MSP_INIT_CB_ID :
        hsd->MspInitCallback = pCallback;
        break;
      case HAL_SD_MSP_DEINIT_CB_ID :
        hsd->MspDeInitCallback = pCallback;
        break;
      default :
        /* Update the error code */
        hsd->ErrorCode |= HAL_SD_ERROR_INVALID_CALLBACK;
        /* update return status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (hsd->State == HAL_SD_STATE_RESET)
  {
    switch (CallbackID)
    {
      case HAL_SD_MSP_INIT_CB_ID :
        hsd->MspInitCallback = pCallback;
        break;
      case HAL_SD_MSP_DEINIT_CB_ID :
        hsd->MspDeInitCallback = pCallback;
        break;
      default :
        /* Update the error code */
        hsd->ErrorCode |= HAL_SD_ERROR_INVALID_CALLBACK;
        /* update return status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hsd->ErrorCode |= HAL_SD_ERROR_INVALID_CALLBACK;
    /* update return status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
#if defined (USE_HAL_SD_REGISTER_CALLBACKS) && (USE_HAL_SD_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_SD_UnRegisterCallback(SD_HandleTypeDef *hsd, HAL_SD_CallbackIDTypeDef CallbackID)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (hsd->State == HAL_SD_STATE_READY)
  {
    switch (CallbackID)
    {
      case HAL_SD_TX_CPLT_CB_ID :
        hsd->TxCpltCallback = HAL_SD_TxCpltCallback;
        break;
      case HAL_SD_RX_CPLT_CB_ID :
        hsd->RxCpltCallback = HAL_SD_RxCpltCallback;
        break;
      case HAL_SD_ERROR_CB_ID :
        hsd->ErrorCallback = HAL_SD_ErrorCallback;
        break;
      case HAL_SD_ABORT_CB_ID :
        hsd->AbortCpltCallback = HAL_SD_AbortCallback;
        break;
      case HAL_SD_READ_DMA_LNKLST_BUF_CPLT_CB_ID :
        hsd->Read_DMALnkLstBufCpltCallback = HAL_SDEx_Read_DMALnkLstBufCpltCallback;
        break;
      case HAL_SD_WRITE_DMA_LNKLST_BUF_CPLT_CB_ID :
        hsd->Write_DMALnkLstBufCpltCallback = HAL_SDEx_Write_DMALnkLstBufCpltCallback;
        break;
      case HAL_SD_MSP_INIT_CB_ID :
        hsd->MspInitCallback = HAL_SD_MspInit;
        break;
      case HAL_SD_MSP_DEINIT_CB_ID :
        hsd->MspDeInitCallback = HAL_SD_MspDeInit;
        break;
      default :
        /* Update the error code */
        hsd->ErrorCode |= HAL_SD_ERROR_INVALID_CALLBACK;
        /* update return status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (hsd->State == HAL_SD_STATE_RESET)
  {
    switch (CallbackID)
    {
      case HAL_SD_MSP_INIT_CB_ID :
        hsd->MspInitCallback = HAL_SD_MspInit;
        break;
      case HAL_SD_MSP_DEINIT_CB_ID :
        hsd->MspDeInitCallback = HAL_SD_MspDeInit;
        break;
      default :
        /* Update the error code */
        hsd->ErrorCode |= HAL_SD_ERROR_INVALID_CALLBACK;
        /* update return status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hsd->ErrorCode |= HAL_SD_ERROR_INVALID_CALLBACK;
    /* update return status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
#if defined (USE_HAL_SD_REGISTER_CALLBACKS) && (USE_HAL_SD_REGISTER_CALLBACKS == 1U)
#if (USE_SD_TRANSCEIVER != 0U)
HAL_StatusTypeDef HAL_SD_RegisterTransceiverCallback(SD_HandleTypeDef *hsd, pSD_TransceiverCallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hsd->ErrorCode |= HAL_SD_ERROR_INVALID_CALLBACK;
    return HAL_ERROR;
  }

  /* Process locked */
  __HAL_LOCK(hsd);

  if (hsd->State == HAL_SD_STATE_READY)
  {
    hsd->DriveTransceiver_1_8V_Callback = pCallback;
  }
  else
  {
    /* Update the error code */
    hsd->ErrorCode |= HAL_SD_ERROR_INVALID_CALLBACK;
    /* update return status */
    status =  HAL_ERROR;
  }

  /* Release Lock */
  __HAL_UNLOCK(hsd);
  return status;
}
#endif
#endif
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
#if defined (USE_HAL_SD_REGISTER_CALLBACKS) && (USE_HAL_SD_REGISTER_CALLBACKS == 1U)
#if (USE_SD_TRANSCEIVER != 0U)
HAL_StatusTypeDef HAL_SD_UnRegisterTransceiverCallback(SD_HandleTypeDef *hsd)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Process locked */
  __HAL_LOCK(hsd);

  if (hsd->State == HAL_SD_STATE_READY)
  {
    hsd->DriveTransceiver_1_8V_Callback = HAL_SD_DriveTransceiver_1_8V_Callback;
  }
  else
  {
    /* Update the error code */
    hsd->ErrorCode |= HAL_SD_ERROR_INVALID_CALLBACK;
    /* update return status */
    status =  HAL_ERROR;
  }

  /* Release Lock */
  __HAL_UNLOCK(hsd);
  return status;
}
#endif
#endif
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_GetCardCID(const SD_HandleTypeDef *hsd, HAL_SD_CardCIDTypeDef *pCID)
{
  pCID->ManufacturerID = (uint8_t)((hsd->CID[0] & 0xFF000000U) >> 24U);

  pCID->OEM_AppliID = (uint16_t)((hsd->CID[0] & 0x00FFFF00U) >> 8U);

  pCID->ProdName1 = (((hsd->CID[0] & 0x000000FFU) << 24U) | ((hsd->CID[1] & 0xFFFFFF00U) >> 8U));

  pCID->ProdName2 = (uint8_t)(hsd->CID[1] & 0x000000FFU);

  pCID->ProdRev = (uint8_t)((hsd->CID[2] & 0xFF000000U) >> 24U);

  pCID->ProdSN = (((hsd->CID[2] & 0x00FFFFFFU) << 8U) | ((hsd->CID[3] & 0xFF000000U) >> 24U));

  pCID->Reserved1 = (uint8_t)((hsd->CID[3] & 0x00F00000U) >> 20U);

  pCID->ManufactDate = (uint16_t)((hsd->CID[3] & 0x000FFF00U) >> 8U);

  pCID->CID_CRC = (uint8_t)((hsd->CID[3] & 0x000000FEU) >> 1U);

  pCID->Reserved2 = 1U;

  return HAL_OK;
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_GetCardCSD(SD_HandleTypeDef *hsd, HAL_SD_CardCSDTypeDef *pCSD)
{
  pCSD->CSDStruct = (uint8_t)((hsd->CSD[0] & 0xC0000000U) >> 30U);

  pCSD->SysSpecVersion = (uint8_t)((hsd->CSD[0] & 0x3C000000U) >> 26U);

  pCSD->Reserved1 = (uint8_t)((hsd->CSD[0] & 0x03000000U) >> 24U);

  pCSD->TAAC = (uint8_t)((hsd->CSD[0] & 0x00FF0000U) >> 16U);

  pCSD->NSAC = (uint8_t)((hsd->CSD[0] & 0x0000FF00U) >> 8U);

  pCSD->MaxBusClkFrec = (uint8_t)(hsd->CSD[0] & 0x000000FFU);

  pCSD->CardComdClasses = (uint16_t)((hsd->CSD[1] & 0xFFF00000U) >> 20U);

  pCSD->RdBlockLen = (uint8_t)((hsd->CSD[1] & 0x000F0000U) >> 16U);

  pCSD->PartBlockRead   = (uint8_t)((hsd->CSD[1] & 0x00008000U) >> 15U);

  pCSD->WrBlockMisalign = (uint8_t)((hsd->CSD[1] & 0x00004000U) >> 14U);

  pCSD->RdBlockMisalign = (uint8_t)((hsd->CSD[1] & 0x00002000U) >> 13U);

  pCSD->DSRImpl = (uint8_t)((hsd->CSD[1] & 0x00001000U) >> 12U);

  pCSD->Reserved2 = 0U; /*!< Reserved */

  if (hsd->SdCard.CardType == CARD_SDSC)
  {
    pCSD->DeviceSize = (((hsd->CSD[1] & 0x000003FFU) << 2U) | ((hsd->CSD[2] & 0xC0000000U) >> 30U));

    pCSD->MaxRdCurrentVDDMin = (uint8_t)((hsd->CSD[2] & 0x38000000U) >> 27U);

    pCSD->MaxRdCurrentVDDMax = (uint8_t)((hsd->CSD[2] & 0x07000000U) >> 24U);

    pCSD->MaxWrCurrentVDDMin = (uint8_t)((hsd->CSD[2] & 0x00E00000U) >> 21U);

    pCSD->MaxWrCurrentVDDMax = (uint8_t)((hsd->CSD[2] & 0x001C0000U) >> 18U);

    pCSD->DeviceSizeMul = (uint8_t)((hsd->CSD[2] & 0x00038000U) >> 15U);

    hsd->SdCard.BlockNbr  = (pCSD->DeviceSize + 1U) ;
    hsd->SdCard.BlockNbr *= (1UL << ((pCSD->DeviceSizeMul & 0x07U) + 2U));
    hsd->SdCard.BlockSize = (1UL << (pCSD->RdBlockLen & 0x0FU));

    hsd->SdCard.LogBlockNbr = (hsd->SdCard.BlockNbr) * ((hsd->SdCard.BlockSize) / BLOCKSIZE);
    hsd->SdCard.LogBlockSize = BLOCKSIZE;
  }
  else if (hsd->SdCard.CardType == CARD_SDHC_SDXC)
  {
    /* Byte 7 */
    pCSD->DeviceSize = (((hsd->CSD[1] & 0x0000003FU) << 16U) | ((hsd->CSD[2] & 0xFFFF0000U) >> 16U));

    hsd->SdCard.BlockNbr = ((pCSD->DeviceSize + 1U) * 1024U);
    hsd->SdCard.LogBlockNbr = hsd->SdCard.BlockNbr;
    hsd->SdCard.BlockSize = BLOCKSIZE;
    hsd->SdCard.LogBlockSize = hsd->SdCard.BlockSize;
  }
  else
  {
    /* Clear all the static flags */
    __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
    hsd->ErrorCode |= HAL_SD_ERROR_UNSUPPORTED_FEATURE;
    hsd->State = HAL_SD_STATE_READY;
    return HAL_ERROR;
  }

  pCSD->EraseGrSize = (uint8_t)((hsd->CSD[2] & 0x00004000U) >> 14U);

  pCSD->EraseGrMul = (uint8_t)((hsd->CSD[2] & 0x00003F80U) >> 7U);

  pCSD->WrProtectGrSize = (uint8_t)(hsd->CSD[2] & 0x0000007FU);

  pCSD->WrProtectGrEnable = (uint8_t)((hsd->CSD[3] & 0x80000000U) >> 31U);

  pCSD->ManDeflECC = (uint8_t)((hsd->CSD[3] & 0x60000000U) >> 29U);

  pCSD->WrSpeedFact = (uint8_t)((hsd->CSD[3] & 0x1C000000U) >> 26U);

  pCSD->MaxWrBlockLen = (uint8_t)((hsd->CSD[3] & 0x03C00000U) >> 22U);

  pCSD->WriteBlockPaPartial = (uint8_t)((hsd->CSD[3] & 0x00200000U) >> 21U);

  pCSD->Reserved3 = 0;

  pCSD->ContentProtectAppli = (uint8_t)((hsd->CSD[3] & 0x00010000U) >> 16U);

  pCSD->FileFormatGroup = (uint8_t)((hsd->CSD[3] & 0x00008000U) >> 15U);

  pCSD->CopyFlag = (uint8_t)((hsd->CSD[3] & 0x00004000U) >> 14U);

  pCSD->PermWrProtect = (uint8_t)((hsd->CSD[3] & 0x00002000U) >> 13U);

  pCSD->TempWrProtect = (uint8_t)((hsd->CSD[3] & 0x00001000U) >> 12U);

  pCSD->FileFormat = (uint8_t)((hsd->CSD[3] & 0x00000C00U) >> 10U);

  pCSD->ECC = (uint8_t)((hsd->CSD[3] & 0x00000300U) >> 8U);

  pCSD->CSD_CRC = (uint8_t)((hsd->CSD[3] & 0x000000FEU) >> 1U);

  pCSD->Reserved4 = 1;

  return HAL_OK;
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_GetCardStatus(SD_HandleTypeDef *hsd, HAL_SD_CardStatusTypeDef *pStatus)
{
  uint32_t sd_status[16];
  uint32_t errorstate;
  HAL_StatusTypeDef status = HAL_OK;

  if (hsd->State == HAL_SD_STATE_BUSY)
  {
    return HAL_ERROR;
  }

  errorstate = SD_SendSDStatus(hsd, sd_status);
  if (errorstate != HAL_SD_ERROR_NONE)
  {
    /* Clear all the static flags */
    __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
    hsd->ErrorCode |= errorstate;
    hsd->State = HAL_SD_STATE_READY;
    status = HAL_ERROR;
  }
  else
  {
    pStatus->DataBusWidth = (uint8_t)((sd_status[0] & 0xC0U) >> 6U);

    pStatus->SecuredMode = (uint8_t)((sd_status[0] & 0x20U) >> 5U);

    pStatus->CardType = (uint16_t)(((sd_status[0] & 0x00FF0000U) >> 8U) | ((sd_status[0] & 0xFF000000U) >> 24U));

    pStatus->ProtectedAreaSize = (((sd_status[1] & 0xFFU) << 24U)    | ((sd_status[1] & 0xFF00U) << 8U) |
                                  ((sd_status[1] & 0xFF0000U) >> 8U) | ((sd_status[1] & 0xFF000000U) >> 24U));

    pStatus->SpeedClass = (uint8_t)(sd_status[2] & 0xFFU);

    pStatus->PerformanceMove = (uint8_t)((sd_status[2] & 0xFF00U) >> 8U);

    pStatus->AllocationUnitSize = (uint8_t)((sd_status[2] & 0xF00000U) >> 20U);

    pStatus->EraseSize = (uint16_t)(((sd_status[2] & 0xFF000000U) >> 16U) | (sd_status[3] & 0xFFU));

    pStatus->EraseTimeout = (uint8_t)((sd_status[3] & 0xFC00U) >> 10U);

    pStatus->EraseOffset = (uint8_t)((sd_status[3] & 0x0300U) >> 8U);

    pStatus->UhsSpeedGrade = (uint8_t)((sd_status[3] & 0x00F0U) >> 4U);
    pStatus->UhsAllocationUnitSize = (uint8_t)(sd_status[3] & 0x000FU) ;
    pStatus->VideoSpeedClass = (uint8_t)((sd_status[4] & 0xFF000000U) >> 24U);
  }

  /* Set Block Size for Card */
  errorstate = SDMMC_CmdBlockLength(hsd->Instance, BLOCKSIZE);
  if (errorstate != HAL_SD_ERROR_NONE)
  {
    /* Clear all the static flags */
    __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
    hsd->ErrorCode = errorstate;
    hsd->State = HAL_SD_STATE_READY;
    status = HAL_ERROR;
  }

  return status;
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_GetCardInfo(const SD_HandleTypeDef *hsd, HAL_SD_CardInfoTypeDef *pCardInfo)
{
  pCardInfo->CardType     = (uint32_t)(hsd->SdCard.CardType);
  pCardInfo->CardVersion  = (uint32_t)(hsd->SdCard.CardVersion);
  pCardInfo->Class        = (uint32_t)(hsd->SdCard.Class);
  pCardInfo->RelCardAdd   = (uint32_t)(hsd->SdCard.RelCardAdd);
  pCardInfo->BlockNbr     = (uint32_t)(hsd->SdCard.BlockNbr);
  pCardInfo->BlockSize    = (uint32_t)(hsd->SdCard.BlockSize);
  pCardInfo->LogBlockNbr  = (uint32_t)(hsd->SdCard.LogBlockNbr);
  pCardInfo->LogBlockSize = (uint32_t)(hsd->SdCard.LogBlockSize);

  return HAL_OK;
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_ConfigWideBusOperation(SD_HandleTypeDef *hsd, uint32_t WideMode)
{
  SDMMC_InitTypeDef Init;
  uint32_t errorstate;
  uint32_t sdmmc_clk;

  HAL_StatusTypeDef status = HAL_OK;

  /* Check the parameters */
  assert_param(IS_SDMMC_BUS_WIDE(WideMode));

  /* Change State */
  hsd->State = HAL_SD_STATE_BUSY;

  if (hsd->SdCard.CardType != CARD_SECURED)
  {
    if (WideMode == SDMMC_BUS_WIDE_8B)
    {
      hsd->ErrorCode |= HAL_SD_ERROR_UNSUPPORTED_FEATURE;
    }
    else if (WideMode == SDMMC_BUS_WIDE_4B)
    {
      errorstate = SD_WideBus_Enable(hsd);

      hsd->ErrorCode |= errorstate;
    }
    else if (WideMode == SDMMC_BUS_WIDE_1B)
    {
      errorstate = SD_WideBus_Disable(hsd);

      hsd->ErrorCode |= errorstate;
    }
    else
    {
      /* WideMode is not a valid argument*/
      hsd->ErrorCode |= HAL_SD_ERROR_PARAM;
    }
  }
  else
  {
    /* SD Card does not support this feature */
    hsd->ErrorCode |= HAL_SD_ERROR_UNSUPPORTED_FEATURE;
  }

  if (hsd->ErrorCode != HAL_SD_ERROR_NONE)
  {
    /* Clear all the static flags */
    __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
    status = HAL_ERROR;
  }
  else
  {
    sdmmc_clk = HAL_RCCEx_GetPeriphCLKFreq(RCC_PERIPHCLK_SDMMC12);
    if (sdmmc_clk != 0U)
    {
      /* Configure the SDMMC peripheral */
      Init.ClockEdge           = hsd->Init.ClockEdge;
      Init.ClockPowerSave      = hsd->Init.ClockPowerSave;
      Init.BusWide             = WideMode;
      Init.HardwareFlowControl = hsd->Init.HardwareFlowControl;

      /* Check if user Clock div < Normal speed 25Mhz, no change in Clockdiv */
      if (hsd->Init.ClockDiv >= (sdmmc_clk / (2U * SD_NORMAL_SPEED_FREQ)))
      {
        Init.ClockDiv = hsd->Init.ClockDiv;
      }
      else if (hsd->SdCard.CardSpeed == CARD_ULTRA_HIGH_SPEED)
      {
        /* UltraHigh speed SD card,user Clock div */
        Init.ClockDiv = hsd->Init.ClockDiv;
      }
      else if (hsd->SdCard.CardSpeed == CARD_HIGH_SPEED)
      {
        /* High speed SD card, Max Frequency = 50Mhz */
        if (hsd->Init.ClockDiv == 0U)
        {
          if (sdmmc_clk > SD_HIGH_SPEED_FREQ)
          {
            Init.ClockDiv = sdmmc_clk / (2U * SD_HIGH_SPEED_FREQ);
          }
          else
          {
            Init.ClockDiv = hsd->Init.ClockDiv;
          }
        }
        else
        {
          if ((sdmmc_clk / (2U * hsd->Init.ClockDiv)) > SD_HIGH_SPEED_FREQ)
          {
            Init.ClockDiv = sdmmc_clk / (2U * SD_HIGH_SPEED_FREQ);
          }
          else
          {
            Init.ClockDiv = hsd->Init.ClockDiv;
          }
        }
      }
      else
      {
        /* No High speed SD card, Max Frequency = 25Mhz */
        if (hsd->Init.ClockDiv == 0U)
        {
          if (sdmmc_clk > SD_NORMAL_SPEED_FREQ)
          {
            Init.ClockDiv = sdmmc_clk / (2U * SD_NORMAL_SPEED_FREQ);
          }
          else
          {
            Init.ClockDiv = hsd->Init.ClockDiv;
          }
        }
        else
        {
          if ((sdmmc_clk / (2U * hsd->Init.ClockDiv)) > SD_NORMAL_SPEED_FREQ)
          {
            Init.ClockDiv = sdmmc_clk / (2U * SD_NORMAL_SPEED_FREQ);
          }
          else
          {
            Init.ClockDiv = hsd->Init.ClockDiv;
          }
        }
      }

#if (USE_SD_TRANSCEIVER != 0U)
      Init.TranceiverPresent = hsd->Init.TranceiverPresent;
#endif /* USE_SD_TRANSCEIVER */

      (void)SDMMC_Init(hsd->Instance, Init);
    }
    else
    {
      hsd->ErrorCode |= SDMMC_ERROR_INVALID_PARAMETER;
      status = HAL_ERROR;
    }
  }

  /* Set Block Size for Card */
  errorstate = SDMMC_CmdBlockLength(hsd->Instance, BLOCKSIZE);
  if (errorstate != HAL_SD_ERROR_NONE)
  {
    /* Clear all the static flags */
    __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
    hsd->ErrorCode |= errorstate;
    status = HAL_ERROR;
  }

  /* Change State */
  hsd->State = HAL_SD_STATE_READY;

  return status;
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_ConfigSpeedBusOperation(SD_HandleTypeDef *hsd, uint32_t SpeedMode)
{
  uint32_t tickstart;
  uint32_t errorstate;
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the parameters */
  assert_param(IS_SDMMC_SPEED_MODE(SpeedMode));
  /* Change State */
  hsd->State = HAL_SD_STATE_BUSY;

#if (USE_SD_TRANSCEIVER != 0U)
  if (hsd->Init.TranceiverPresent == SDMMC_TRANSCEIVER_PRESENT)
  {
    switch (SpeedMode)
    {
      case SDMMC_SPEED_MODE_AUTO:
      {
        if ((hsd->SdCard.CardSpeed  == CARD_ULTRA_HIGH_SPEED) ||
            (hsd->SdCard.CardType == CARD_SDHC_SDXC))
        {
          hsd->Instance->CLKCR |= SDMMC_CLKCR_BUSSPEED;
          /* Enable Ultra High Speed */
          if (SD_UltraHighSpeed(hsd, SDMMC_SDR104_SWITCH_PATTERN) != HAL_SD_ERROR_NONE)
          {
            if (SD_SwitchSpeed(hsd, SDMMC_SDR25_SWITCH_PATTERN) != HAL_SD_ERROR_NONE)
            {
              hsd->ErrorCode |= HAL_SD_ERROR_UNSUPPORTED_FEATURE;
              status = HAL_ERROR;
            }
          }
        }
        else if (hsd->SdCard.CardSpeed  == CARD_HIGH_SPEED)
        {
          /* Enable High Speed */
          if (SD_SwitchSpeed(hsd, SDMMC_SDR25_SWITCH_PATTERN) != HAL_SD_ERROR_NONE)
          {
            hsd->ErrorCode |= HAL_SD_ERROR_UNSUPPORTED_FEATURE;
            status = HAL_ERROR;
          }
        }
        else
        {
          /*Nothing to do, Use defaultSpeed */
        }
        break;
      }
      case SDMMC_SPEED_MODE_ULTRA_SDR104:
      {
        if ((hsd->SdCard.CardSpeed  == CARD_ULTRA_HIGH_SPEED) ||
            (hsd->SdCard.CardType == CARD_SDHC_SDXC))
        {
          /* Enable UltraHigh Speed */
          if (SD_UltraHighSpeed(hsd, SDMMC_SDR104_SWITCH_PATTERN) != HAL_SD_ERROR_NONE)
          {
            hsd->ErrorCode |= HAL_SD_ERROR_UNSUPPORTED_FEATURE;
            status = HAL_ERROR;
          }
          hsd->Instance->CLKCR |= SDMMC_CLKCR_BUSSPEED;
        }
        else
        {
          hsd->ErrorCode |= HAL_SD_ERROR_UNSUPPORTED_FEATURE;
          status = HAL_ERROR;
        }
        break;
      }
      case SDMMC_SPEED_MODE_ULTRA_SDR50:
      {
        if ((hsd->SdCard.CardSpeed  == CARD_ULTRA_HIGH_SPEED) ||
            (hsd->SdCard.CardType == CARD_SDHC_SDXC))
        {
          /* Enable UltraHigh Speed */
          if (SD_UltraHighSpeed(hsd, SDMMC_SDR50_SWITCH_PATTERN) != HAL_SD_ERROR_NONE)
          {
            hsd->ErrorCode |= HAL_SD_ERROR_UNSUPPORTED_FEATURE;
            status = HAL_ERROR;
          }
          hsd->Instance->CLKCR |= SDMMC_CLKCR_BUSSPEED;
        }
        else
        {
          hsd->ErrorCode |= HAL_SD_ERROR_UNSUPPORTED_FEATURE;
          status = HAL_ERROR;
        }
        break;
      }
      case SDMMC_SPEED_MODE_DDR:
      {
        if ((hsd->SdCard.CardSpeed  == CARD_ULTRA_HIGH_SPEED) ||
            (hsd->SdCard.CardType == CARD_SDHC_SDXC))
        {
          /* Enable DDR Mode*/
          if (SD_DDR_Mode(hsd) != HAL_SD_ERROR_NONE)
          {
            hsd->ErrorCode |= HAL_SD_ERROR_UNSUPPORTED_FEATURE;
            status = HAL_ERROR;
          }
          hsd->Instance->CLKCR |=  SDMMC_CLKCR_BUSSPEED | SDMMC_CLKCR_DDR;
        }
        else
        {
          hsd->ErrorCode |= HAL_SD_ERROR_UNSUPPORTED_FEATURE;
          status = HAL_ERROR;
        }
        break;
      }
      case SDMMC_SPEED_MODE_HIGH:
      {
        if ((hsd->SdCard.CardSpeed  == CARD_ULTRA_HIGH_SPEED) ||
            (hsd->SdCard.CardSpeed  == CARD_HIGH_SPEED) ||
            (hsd->SdCard.CardType == CARD_SDHC_SDXC))
        {
          /* Enable High Speed */
          if (SD_SwitchSpeed(hsd, SDMMC_SDR25_SWITCH_PATTERN) != HAL_SD_ERROR_NONE)
          {
            hsd->ErrorCode |= HAL_SD_ERROR_UNSUPPORTED_FEATURE;
            status = HAL_ERROR;
          }
        }
        else
        {
          hsd->ErrorCode |= HAL_SD_ERROR_UNSUPPORTED_FEATURE;
          status = HAL_ERROR;
        }
        break;
      }
      case SDMMC_SPEED_MODE_DEFAULT:
      {
        /* Switch to default Speed */
        if (SD_SwitchSpeed(hsd, SDMMC_SDR12_SWITCH_PATTERN) != HAL_SD_ERROR_NONE)
        {
          hsd->ErrorCode |= HAL_SD_ERROR_UNSUPPORTED_FEATURE;
          status = HAL_ERROR;
        }

        break;
      }
      default:
        hsd->ErrorCode |= HAL_SD_ERROR_PARAM;
        status = HAL_ERROR;
        break;
    }
  }
  else
  {
    switch (SpeedMode)
    {
      case SDMMC_SPEED_MODE_AUTO:
      {
        if ((hsd->SdCard.CardSpeed  == CARD_ULTRA_HIGH_SPEED) ||
            (hsd->SdCard.CardSpeed  == CARD_HIGH_SPEED) ||
            (hsd->SdCard.CardType == CARD_SDHC_SDXC))
        {
          /* Enable High Speed */
          if (SD_SwitchSpeed(hsd, SDMMC_SDR25_SWITCH_PATTERN) != HAL_SD_ERROR_NONE)
          {
            hsd->ErrorCode |= HAL_SD_ERROR_UNSUPPORTED_FEATURE;
            status = HAL_ERROR;
          }
        }
        else
        {
          /*Nothing to do, Use defaultSpeed */
        }
        break;
      }
      case SDMMC_SPEED_MODE_HIGH:
      {
        if ((hsd->SdCard.CardSpeed  == CARD_ULTRA_HIGH_SPEED) ||
            (hsd->SdCard.CardSpeed  == CARD_HIGH_SPEED) ||
            (hsd->SdCard.CardType == CARD_SDHC_SDXC))
        {
          /* Enable High Speed */
          if (SD_SwitchSpeed(hsd, SDMMC_SDR25_SWITCH_PATTERN) != HAL_SD_ERROR_NONE)
          {
            hsd->ErrorCode |= HAL_SD_ERROR_UNSUPPORTED_FEATURE;
            status = HAL_ERROR;
          }
        }
        else
        {
          hsd->ErrorCode |= HAL_SD_ERROR_UNSUPPORTED_FEATURE;
          status = HAL_ERROR;
        }
        break;
      }
      case SDMMC_SPEED_MODE_DEFAULT:
      {
        /* Switch to default Speed */
        if (SD_SwitchSpeed(hsd, SDMMC_SDR12_SWITCH_PATTERN) != HAL_SD_ERROR_NONE)
        {
          hsd->ErrorCode |= HAL_SD_ERROR_UNSUPPORTED_FEATURE;
          status = HAL_ERROR;
        }

        break;
      }
      case SDMMC_SPEED_MODE_ULTRA: /*not valid without transceiver*/
      default:
        hsd->ErrorCode |= HAL_SD_ERROR_PARAM;
        status = HAL_ERROR;
        break;
    }
  }
#else
  switch (SpeedMode)
  {
    case SDMMC_SPEED_MODE_AUTO:
    {
      if ((hsd->SdCard.CardSpeed  == CARD_ULTRA_HIGH_SPEED) ||
          (hsd->SdCard.CardSpeed  == CARD_HIGH_SPEED) ||
          (hsd->SdCard.CardType == CARD_SDHC_SDXC))
      {
        /* Enable High Speed */
        if (SD_SwitchSpeed(hsd, SDMMC_SDR25_SWITCH_PATTERN) != HAL_SD_ERROR_NONE)
        {
          hsd->ErrorCode |= HAL_SD_ERROR_UNSUPPORTED_FEATURE;
          status = HAL_ERROR;
        }
      }
      else
      {
        /*Nothing to do, Use defaultSpeed */
      }
      break;
    }
    case SDMMC_SPEED_MODE_HIGH:
    {
      if ((hsd->SdCard.CardSpeed  == CARD_ULTRA_HIGH_SPEED) ||
          (hsd->SdCard.CardSpeed  == CARD_HIGH_SPEED) ||
          (hsd->SdCard.CardType == CARD_SDHC_SDXC))
      {
        /* Enable High Speed */
        if (SD_SwitchSpeed(hsd, SDMMC_SDR25_SWITCH_PATTERN) != HAL_SD_ERROR_NONE)
        {
          hsd->ErrorCode |= HAL_SD_ERROR_UNSUPPORTED_FEATURE;
          status = HAL_ERROR;
        }
      }
      else
      {
        hsd->ErrorCode |= HAL_SD_ERROR_UNSUPPORTED_FEATURE;
        status = HAL_ERROR;
      }
      break;
    }
    case SDMMC_SPEED_MODE_DEFAULT:
    {
      /* Switch to default Speed */
      if (SD_SwitchSpeed(hsd, SDMMC_SDR12_SWITCH_PATTERN) != HAL_SD_ERROR_NONE)
      {
        hsd->ErrorCode |= HAL_SD_ERROR_UNSUPPORTED_FEATURE;
        status = HAL_ERROR;
      }

      break;
    }
    case SDMMC_SPEED_MODE_ULTRA: /*not valid without transceiver*/
    default:
      hsd->ErrorCode |= HAL_SD_ERROR_PARAM;
      status = HAL_ERROR;
      break;
  }
#endif /* USE_SD_TRANSCEIVER */

  /* Verify that SD card is ready to use after Speed mode switch*/
  tickstart = HAL_GetTick();
  while ((HAL_SD_GetCardState(hsd) != HAL_SD_CARD_TRANSFER))
  {
    if ((HAL_GetTick() - tickstart) >=  SDMMC_SWDATATIMEOUT)
    {
      hsd->ErrorCode = HAL_SD_ERROR_TIMEOUT;
      hsd->State = HAL_SD_STATE_READY;
      return HAL_TIMEOUT;
    }
  }

  /* Set Block Size for Card */
  errorstate = SDMMC_CmdBlockLength(hsd->Instance, BLOCKSIZE);
  if (errorstate != HAL_SD_ERROR_NONE)
  {
    /* Clear all the static flags */
    __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_FLAGS);
    hsd->ErrorCode |= errorstate;
    status = HAL_ERROR;
  }

  /* Change State */
  hsd->State = HAL_SD_STATE_READY;
  return status;
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_SD_CardStateTypeDef HAL_SD_GetCardState(SD_HandleTypeDef *hsd)
{
  uint32_t cardstate;
  uint32_t errorstate;
  uint32_t resp1 = 0;

  errorstate = SD_SendStatus(hsd, &resp1);
  if (errorstate != HAL_SD_ERROR_NONE)
  {
    hsd->ErrorCode |= errorstate;
  }

  cardstate = ((resp1 >> 9U) & 0x0FU);

  return (HAL_SD_CardStateTypeDef)cardstate;
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_Abort(SD_HandleTypeDef *hsd)
{
  uint32_t error_code;
  uint32_t tickstart;

  if (hsd->State == HAL_SD_STATE_BUSY)
  {
    /* DIsable All interrupts */
    __HAL_SD_DISABLE_IT(hsd, SDMMC_IT_DATAEND | SDMMC_IT_DCRCFAIL | SDMMC_IT_DTIMEOUT | \
                        SDMMC_IT_TXUNDERR | SDMMC_IT_RXOVERR);
    __SDMMC_CMDTRANS_DISABLE(hsd->Instance);

    /*we will send the CMD12 in all cases in order to stop the data transfers*/
    /*In case the data transfer just finished , the external memory will not respond
      and will return HAL_SD_ERROR_CMD_RSP_TIMEOUT*/
    /*In case the data transfer aborted , the external memory will respond and will return HAL_SD_ERROR_NONE*/
    /*Other scenario will return HAL_ERROR*/

    hsd->ErrorCode = SDMMC_CmdStopTransfer(hsd->Instance);
    error_code = hsd->ErrorCode;
    if ((error_code != HAL_SD_ERROR_NONE) && (error_code != HAL_SD_ERROR_CMD_RSP_TIMEOUT))
    {
      return HAL_ERROR;
    }

    tickstart = HAL_GetTick();
    if ((hsd->Instance->DCTRL & SDMMC_DCTRL_DTDIR) == SDMMC_TRANSFER_DIR_TO_CARD)
    {
      if (hsd->ErrorCode == HAL_SD_ERROR_NONE)
      {
        while (!__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_DABORT | SDMMC_FLAG_BUSYD0END))
        {
          if ((HAL_GetTick() - tickstart) >=  SDMMC_SWDATATIMEOUT)
          {
            hsd->ErrorCode = HAL_SD_ERROR_TIMEOUT;
            hsd->State = HAL_SD_STATE_READY;
            return HAL_TIMEOUT;
          }
        }
      }

      if (hsd->ErrorCode == HAL_SD_ERROR_CMD_RSP_TIMEOUT)
      {
        while (!__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_DATAEND))
        {
          if ((HAL_GetTick() - tickstart) >=  SDMMC_SWDATATIMEOUT)
          {
            hsd->ErrorCode = HAL_SD_ERROR_TIMEOUT;
            hsd->State = HAL_SD_STATE_READY;
            return HAL_TIMEOUT;
          }
        }
      }
    }
    else if ((hsd->Instance->DCTRL & SDMMC_DCTRL_DTDIR) == SDMMC_TRANSFER_DIR_TO_SDMMC)
    {
      while (!__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_DABORT | SDMMC_FLAG_DATAEND))
      {
        if ((HAL_GetTick() - tickstart) >=  SDMMC_SWDATATIMEOUT)
        {
          hsd->ErrorCode = HAL_SD_ERROR_TIMEOUT;
          hsd->State = HAL_SD_STATE_READY;
          return HAL_TIMEOUT;
        }
      }
    }
    else
    {
      /* Nothing to do*/
    }

    /*The reason of all these while conditions previously is that we need to wait the SDMMC and clear
      the appropriate flags that will be set depending of the abort/non abort of the memory */
    /*Not waiting the SDMMC flags will cause the next SDMMC_DISABLE_IDMA to not get cleared
      and will result in next SDMMC read/write operation to fail */

    /*SDMMC ready for clear data flags*/
    __HAL_SD_CLEAR_FLAG(hsd, SDMMC_FLAG_BUSYD0END);
    __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_DATA_FLAGS);
    /* If IDMA Context, disable Internal DMA */
    hsd->Instance->IDMACTRL = SDMMC_DISABLE_IDMA;

    hsd->State = HAL_SD_STATE_READY;

    /* Initialize the SD operation */
    hsd->Context = SD_CONTEXT_NONE;
  }
  return HAL_OK;
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_Abort_IT(SD_HandleTypeDef *hsd)
{
  HAL_SD_CardStateTypeDef CardState;

  /* Disable All interrupts */
  __HAL_SD_DISABLE_IT(hsd, SDMMC_IT_DATAEND | SDMMC_IT_DCRCFAIL | SDMMC_IT_DTIMEOUT | \
                      SDMMC_IT_TXUNDERR | SDMMC_IT_RXOVERR);

  /* If IDMA Context, disable Internal DMA */
  hsd->Instance->IDMACTRL = SDMMC_DISABLE_IDMA;

  /* Clear All flags */
  __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_DATA_FLAGS);

  CardState = HAL_SD_GetCardState(hsd);
  hsd->State = HAL_SD_STATE_READY;

  if ((CardState == HAL_SD_CARD_RECEIVING) || (CardState == HAL_SD_CARD_SENDING))
  {
    hsd->ErrorCode = SDMMC_CmdStopTransfer(hsd->Instance);
  }

  if (hsd->ErrorCode != HAL_SD_ERROR_NONE)
  {
    return HAL_ERROR;
  }
  else
  {
#if defined (USE_HAL_SD_REGISTER_CALLBACKS) && (USE_HAL_SD_REGISTER_CALLBACKS == 1U)
    hsd->AbortCpltCallback(hsd);
#else
    HAL_SD_AbortCallback(hsd);
#endif /* USE_HAL_SD_REGISTER_CALLBACKS */
  }

  return HAL_OK;
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
static uint32_t SD_InitCard(SD_HandleTypeDef *hsd)
{
  HAL_SD_CardCSDTypeDef CSD;
  uint32_t errorstate;
  uint16_t sd_rca = 0U;
  uint32_t tickstart = HAL_GetTick();

  /* Check the power State */
  if (SDMMC_GetPowerState(hsd->Instance) == 0U)
  {
    /* Power off */
    return HAL_SD_ERROR_REQUEST_NOT_APPLICABLE;
  }

  if (hsd->SdCard.CardType != CARD_SECURED)
  {
    /* Send CMD2 ALL_SEND_CID */
    errorstate = SDMMC_CmdSendCID(hsd->Instance);
    if (errorstate != HAL_SD_ERROR_NONE)
    {
      return errorstate;
    }
    else
    {
      /* Get Card identification number data */
      hsd->CID[0U] = SDMMC_GetResponse(hsd->Instance, SDMMC_RESP1);
      hsd->CID[1U] = SDMMC_GetResponse(hsd->Instance, SDMMC_RESP2);
      hsd->CID[2U] = SDMMC_GetResponse(hsd->Instance, SDMMC_RESP3);
      hsd->CID[3U] = SDMMC_GetResponse(hsd->Instance, SDMMC_RESP4);
    }
  }

  if (hsd->SdCard.CardType != CARD_SECURED)
  {
    /* Send CMD3 SET_REL_ADDR with argument 0 */
    /* SD Card publishes its RCA. */
    while (sd_rca == 0U)
    {
      errorstate = SDMMC_CmdSetRelAdd(hsd->Instance, &sd_rca);
      if (errorstate != HAL_SD_ERROR_NONE)
      {
        return errorstate;
      }
      if ((HAL_GetTick() - tickstart) >=  SDMMC_CMDTIMEOUT)
      {
        return HAL_SD_ERROR_TIMEOUT;
      }
    }
  }
  if (hsd->SdCard.CardType != CARD_SECURED)
  {
    /* Get the SD card RCA */
    hsd->SdCard.RelCardAdd = sd_rca;

    /* Send CMD9 SEND_CSD with argument as card's RCA */
    errorstate = SDMMC_CmdSendCSD(hsd->Instance, (uint32_t)(hsd->SdCard.RelCardAdd << 16U));
    if (errorstate != HAL_SD_ERROR_NONE)
    {
      return errorstate;
    }
    else
    {
      /* Get Card Specific Data */
      hsd->CSD[0U] = SDMMC_GetResponse(hsd->Instance, SDMMC_RESP1);
      hsd->CSD[1U] = SDMMC_GetResponse(hsd->Instance, SDMMC_RESP2);
      hsd->CSD[2U] = SDMMC_GetResponse(hsd->Instance, SDMMC_RESP3);
      hsd->CSD[3U] = SDMMC_GetResponse(hsd->Instance, SDMMC_RESP4);
    }
  }

  /* Get the Card Class */
  hsd->SdCard.Class = (SDMMC_GetResponse(hsd->Instance, SDMMC_RESP2) >> 20U);

  /* Get CSD parameters */
  if (HAL_SD_GetCardCSD(hsd, &CSD) != HAL_OK)
  {
    return HAL_SD_ERROR_UNSUPPORTED_FEATURE;
  }

  /* Select the Card */
  errorstate = SDMMC_CmdSelDesel(hsd->Instance, (uint32_t)(((uint32_t)hsd->SdCard.RelCardAdd) << 16U));
  if (errorstate != HAL_SD_ERROR_NONE)
  {
    return errorstate;
  }

  /* All cards are initialized */
  return HAL_SD_ERROR_NONE;
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
static uint32_t SD_PowerON(SD_HandleTypeDef *hsd)
{
  __IO uint32_t count = 0U;
  uint32_t response = 0U;
  uint32_t validvoltage = 0U;
  uint32_t errorstate;
#if (USE_SD_TRANSCEIVER != 0U)
  uint32_t tickstart = HAL_GetTick();
#endif /* USE_SD_TRANSCEIVER  */

  /* CMD0: GO_IDLE_STATE */
  errorstate = SDMMC_CmdGoIdleState(hsd->Instance);
  if (errorstate != HAL_SD_ERROR_NONE)
  {
    return errorstate;
  }

  /* CMD8: SEND_IF_COND: Command available only on V2.0 cards */
  errorstate = SDMMC_CmdOperCond(hsd->Instance);
  if (errorstate == SDMMC_ERROR_CMD_RSP_TIMEOUT) /* No response to CMD8 */
  {
    hsd->SdCard.CardVersion = CARD_V1_X;
    /* CMD0: GO_IDLE_STATE */
    errorstate = SDMMC_CmdGoIdleState(hsd->Instance);
    if (errorstate != HAL_SD_ERROR_NONE)
    {
      return errorstate;
    }

  }
  else
  {
    hsd->SdCard.CardVersion = CARD_V2_X;
  }

  if (hsd->SdCard.CardVersion == CARD_V2_X)
  {
    /* SEND CMD55 APP_CMD with RCA as 0 */
    errorstate = SDMMC_CmdAppCommand(hsd->Instance, 0);
    if (errorstate != HAL_SD_ERROR_NONE)
    {
      return HAL_SD_ERROR_UNSUPPORTED_FEATURE;
    }
  }
  /* SD CARD */
  /* Send ACMD41 SD_APP_OP_COND with Argument 0x80100000 */
  while ((count < SDMMC_MAX_VOLT_TRIAL) && (validvoltage == 0U))
  {
    /* SEND CMD55 APP_CMD with RCA as 0 */
    errorstate = SDMMC_CmdAppCommand(hsd->Instance, 0);
    if (errorstate != HAL_SD_ERROR_NONE)
    {
      return errorstate;
    }

    /* Send CMD41 */
    errorstate = SDMMC_CmdAppOperCommand(hsd->Instance, SDMMC_VOLTAGE_WINDOW_SD | SDMMC_HIGH_CAPACITY |
                                         SD_SWITCH_1_8V_CAPACITY);
    if (errorstate != HAL_SD_ERROR_NONE)
    {
      return HAL_SD_ERROR_UNSUPPORTED_FEATURE;
    }

    /* Get command response */
    response = SDMMC_GetResponse(hsd->Instance, SDMMC_RESP1);

    /* Get operating voltage*/
    validvoltage = (((response >> 31U) == 1U) ? 1U : 0U);

    count++;
  }

  if (count >= SDMMC_MAX_VOLT_TRIAL)
  {
    return HAL_SD_ERROR_INVALID_VOLTRANGE;
  }

  /* Set default card type */
  hsd->SdCard.CardType = CARD_SDSC;

  if ((response & SDMMC_HIGH_CAPACITY) == SDMMC_HIGH_CAPACITY)
  {
    hsd->SdCard.CardType = CARD_SDHC_SDXC;
#if (USE_SD_TRANSCEIVER != 0U)
    if (hsd->Init.TranceiverPresent == SDMMC_TRANSCEIVER_PRESENT)
    {
      if ((response & SD_SWITCH_1_8V_CAPACITY) == SD_SWITCH_1_8V_CAPACITY)
      {
        hsd->SdCard.CardSpeed = CARD_ULTRA_HIGH_SPEED;

        /* Start switching procedue */
        hsd->Instance->POWER |= SDMMC_POWER_VSWITCHEN;

        /* Send CMD11 to switch 1.8V mode */
        errorstate = SDMMC_CmdVoltageSwitch(hsd->Instance);
        if (errorstate != HAL_SD_ERROR_NONE)
        {
          return errorstate;
        }

        /* Check to CKSTOP */
        while ((hsd->Instance->STA & SDMMC_FLAG_CKSTOP) != SDMMC_FLAG_CKSTOP)
        {
          if ((HAL_GetTick() - tickstart) >=  SDMMC_SWDATATIMEOUT)
          {
            return HAL_SD_ERROR_TIMEOUT;
          }
        }

        /* Clear CKSTOP Flag */
        hsd->Instance->ICR = SDMMC_FLAG_CKSTOP;

        /* Check to BusyD0 */
        if ((hsd->Instance->STA & SDMMC_FLAG_BUSYD0) != SDMMC_FLAG_BUSYD0)
        {
          /* Error when activate Voltage Switch in SDMMC Peripheral */
          return SDMMC_ERROR_UNSUPPORTED_FEATURE;
        }
        else
        {
          /* Enable Transceiver Switch PIN */
#if defined (USE_HAL_SD_REGISTER_CALLBACKS) && (USE_HAL_SD_REGISTER_CALLBACKS == 1U)
          hsd->DriveTransceiver_1_8V_Callback(SET);
#else
          HAL_SD_DriveTransceiver_1_8V_Callback(SET);
#endif /* USE_HAL_SD_REGISTER_CALLBACKS */

          /* Switch ready */
          hsd->Instance->POWER |= SDMMC_POWER_VSWITCH;

          /* Check VSWEND Flag */
          while ((hsd->Instance->STA & SDMMC_FLAG_VSWEND) != SDMMC_FLAG_VSWEND)
          {
            if ((HAL_GetTick() - tickstart) >=  SDMMC_SWDATATIMEOUT)
            {
              return HAL_SD_ERROR_TIMEOUT;
            }
          }

          /* Clear VSWEND Flag */
          hsd->Instance->ICR = SDMMC_FLAG_VSWEND;

          /* Check BusyD0 status */
          if ((hsd->Instance->STA & SDMMC_FLAG_BUSYD0) == SDMMC_FLAG_BUSYD0)
          {
            /* Error when enabling 1.8V mode */
            return HAL_SD_ERROR_INVALID_VOLTRANGE;
          }
          /* Switch to 1.8V OK */

          /* Disable VSWITCH FLAG from SDMMC Peripheral */
          hsd->Instance->POWER = 0x13U;

          /* Clean Status flags */
          hsd->Instance->ICR = 0xFFFFFFFFU;
        }
      }
    }
#endif /* USE_SD_TRANSCEIVER  */
  }

  return HAL_SD_ERROR_NONE;
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
static void SD_PowerOFF(SD_HandleTypeDef *hsd)
{
  /* Set Power State to OFF */
  (void)SDMMC_PowerState_OFF(hsd->Instance);
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
static uint32_t SD_SendSDStatus(SD_HandleTypeDef *hsd, uint32_t *pSDstatus)
{
  SDMMC_DataInitTypeDef config;
  uint32_t errorstate;
  uint32_t tickstart = HAL_GetTick();
  uint32_t count;
  uint32_t *pData = pSDstatus;

  /* Check SD response */
  if ((SDMMC_GetResponse(hsd->Instance, SDMMC_RESP1) & SDMMC_CARD_LOCKED) == SDMMC_CARD_LOCKED)
  {
    return HAL_SD_ERROR_LOCK_UNLOCK_FAILED;
  }

  /* Set block size for card if it is not equal to current block size for card */
  errorstate = SDMMC_CmdBlockLength(hsd->Instance, 64U);
  if (errorstate != HAL_SD_ERROR_NONE)
  {
    hsd->ErrorCode |= HAL_SD_ERROR_NONE;
    return errorstate;
  }

  /* Send CMD55 */
  errorstate = SDMMC_CmdAppCommand(hsd->Instance, (uint32_t)(hsd->SdCard.RelCardAdd << 16U));
  if (errorstate != HAL_SD_ERROR_NONE)
  {
    hsd->ErrorCode |= HAL_SD_ERROR_NONE;
    return errorstate;
  }

  /* Configure the SD DPSM (Data Path State Machine) */
  config.DataTimeOut   = SDMMC_DATATIMEOUT;
  config.DataLength    = 64U;
  config.DataBlockSize = SDMMC_DATABLOCK_SIZE_64B;
  config.TransferDir   = SDMMC_TRANSFER_DIR_TO_SDMMC;
  config.TransferMode  = SDMMC_TRANSFER_MODE_BLOCK;
  config.DPSM          = SDMMC_DPSM_ENABLE;
  (void)SDMMC_ConfigData(hsd->Instance, &config);

  /* Send ACMD13 (SD_APP_STAUS)  with argument as card's RCA */
  errorstate = SDMMC_CmdStatusRegister(hsd->Instance);
  if (errorstate != HAL_SD_ERROR_NONE)
  {
    hsd->ErrorCode |= HAL_SD_ERROR_NONE;
    return errorstate;
  }

  /* Get status data */
  while (!__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_RXOVERR | SDMMC_FLAG_DCRCFAIL | SDMMC_FLAG_DTIMEOUT | SDMMC_FLAG_DATAEND))
  {
    if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_RXFIFOHF))
    {
      for (count = 0U; count < 8U; count++)
      {
        *pData = SDMMC_ReadFIFO(hsd->Instance);
        pData++;
      }
    }

    if ((HAL_GetTick() - tickstart) >=  SDMMC_SWDATATIMEOUT)
    {
      return HAL_SD_ERROR_TIMEOUT;
    }
  }

  if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_DTIMEOUT))
  {
    return HAL_SD_ERROR_DATA_TIMEOUT;
  }
  else if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_DCRCFAIL))
  {
    return HAL_SD_ERROR_DATA_CRC_FAIL;
  }
  else if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_RXOVERR))
  {
    return HAL_SD_ERROR_RX_OVERRUN;
  }
  else
  {
    /* Nothing to do */
  }

  while ((__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_DPSMACT)))
  {
    *pData = SDMMC_ReadFIFO(hsd->Instance);
    pData++;

    if ((HAL_GetTick() - tickstart) >=  SDMMC_SWDATATIMEOUT)
    {
      return HAL_SD_ERROR_TIMEOUT;
    }
  }

  /* Clear all the static status flags*/
  __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_DATA_FLAGS);

  return HAL_SD_ERROR_NONE;
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
static uint32_t SD_SendStatus(SD_HandleTypeDef *hsd, uint32_t *pCardStatus)
{
  uint32_t errorstate;

  if (pCardStatus == NULL)
  {
    return HAL_SD_ERROR_PARAM;
  }

  /* Send Status command */
  errorstate = SDMMC_CmdSendStatus(hsd->Instance, (uint32_t)(hsd->SdCard.RelCardAdd << 16U));
  if (errorstate != HAL_SD_ERROR_NONE)
  {
    return errorstate;
  }

  /* Get SD card status */
  *pCardStatus = SDMMC_GetResponse(hsd->Instance, SDMMC_RESP1);

  return HAL_SD_ERROR_NONE;
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
static uint32_t SD_WideBus_Enable(SD_HandleTypeDef *hsd)
{
  uint32_t scr[2U] = {0UL, 0UL};
  uint32_t errorstate;

  if ((SDMMC_GetResponse(hsd->Instance, SDMMC_RESP1) & SDMMC_CARD_LOCKED) == SDMMC_CARD_LOCKED)
  {
    return HAL_SD_ERROR_LOCK_UNLOCK_FAILED;
  }

  /* Get SCR Register */
  errorstate = SD_FindSCR(hsd, scr);
  if (errorstate != HAL_SD_ERROR_NONE)
  {
    return errorstate;
  }

  /* If requested card supports wide bus operation */
  if ((scr[1U] & SDMMC_WIDE_BUS_SUPPORT) != SDMMC_ALLZERO)
  {
    /* Send CMD55 APP_CMD with argument as card's RCA.*/
    errorstate = SDMMC_CmdAppCommand(hsd->Instance, (uint32_t)(hsd->SdCard.RelCardAdd << 16U));
    if (errorstate != HAL_SD_ERROR_NONE)
    {
      return errorstate;
    }

    /* Send ACMD6 APP_CMD with argument as 2 for wide bus mode */
    errorstate = SDMMC_CmdBusWidth(hsd->Instance, 2U);
    if (errorstate != HAL_SD_ERROR_NONE)
    {
      return errorstate;
    }

    return HAL_SD_ERROR_NONE;
  }
  else
  {
    return HAL_SD_ERROR_REQUEST_NOT_APPLICABLE;
  }
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
static uint32_t SD_WideBus_Disable(SD_HandleTypeDef *hsd)
{
  uint32_t scr[2U] = {0UL, 0UL};
  uint32_t errorstate;

  if ((SDMMC_GetResponse(hsd->Instance, SDMMC_RESP1) & SDMMC_CARD_LOCKED) == SDMMC_CARD_LOCKED)
  {
    return HAL_SD_ERROR_LOCK_UNLOCK_FAILED;
  }

  /* Get SCR Register */
  errorstate = SD_FindSCR(hsd, scr);
  if (errorstate != HAL_SD_ERROR_NONE)
  {
    return errorstate;
  }

  /* If requested card supports 1 bit mode operation */
  if ((scr[1U] & SDMMC_SINGLE_BUS_SUPPORT) != SDMMC_ALLZERO)
  {
    /* Send CMD55 APP_CMD with argument as card's RCA */
    errorstate = SDMMC_CmdAppCommand(hsd->Instance, (uint32_t)(hsd->SdCard.RelCardAdd << 16U));
    if (errorstate != HAL_SD_ERROR_NONE)
    {
      return errorstate;
    }

    /* Send ACMD6 APP_CMD with argument as 0 for single bus mode */
    errorstate = SDMMC_CmdBusWidth(hsd->Instance, 0U);
    if (errorstate != HAL_SD_ERROR_NONE)
    {
      return errorstate;
    }

    return HAL_SD_ERROR_NONE;
  }
  else
  {
    return HAL_SD_ERROR_REQUEST_NOT_APPLICABLE;
  }
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
static uint32_t SD_FindSCR(SD_HandleTypeDef *hsd, uint32_t *pSCR)
{
  SDMMC_DataInitTypeDef config;
  uint32_t errorstate;
  uint32_t tickstart = HAL_GetTick();
  uint32_t index = 0U;
  uint32_t tempscr[2U] = {0UL, 0UL};
  uint32_t *scr = pSCR;

  /* Set Block Size To 8 Bytes */
  errorstate = SDMMC_CmdBlockLength(hsd->Instance, 8U);
  if (errorstate != HAL_SD_ERROR_NONE)
  {
    return errorstate;
  }

  /* Send CMD55 APP_CMD with argument as card's RCA */
  errorstate = SDMMC_CmdAppCommand(hsd->Instance, (uint32_t)((hsd->SdCard.RelCardAdd) << 16U));
  if (errorstate != HAL_SD_ERROR_NONE)
  {
    return errorstate;
  }

  config.DataTimeOut   = SDMMC_DATATIMEOUT;
  config.DataLength    = 8U;
  config.DataBlockSize = SDMMC_DATABLOCK_SIZE_8B;
  config.TransferDir   = SDMMC_TRANSFER_DIR_TO_SDMMC;
  config.TransferMode  = SDMMC_TRANSFER_MODE_BLOCK;
  config.DPSM          = SDMMC_DPSM_ENABLE;
  (void)SDMMC_ConfigData(hsd->Instance, &config);

  /* Send ACMD51 SD_APP_SEND_SCR with argument as 0 */
  errorstate = SDMMC_CmdSendSCR(hsd->Instance);
  if (errorstate != HAL_SD_ERROR_NONE)
  {
    return errorstate;
  }

  while (!__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_RXOVERR | SDMMC_FLAG_DCRCFAIL | SDMMC_FLAG_DTIMEOUT | SDMMC_FLAG_DBCKEND |
                            SDMMC_FLAG_DATAEND))
  {
    if ((!__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_RXFIFOE)) && (index == 0U))
    {
      tempscr[0] = SDMMC_ReadFIFO(hsd->Instance);
      tempscr[1] = SDMMC_ReadFIFO(hsd->Instance);
      index++;
    }

    if ((HAL_GetTick() - tickstart) >=  SDMMC_SWDATATIMEOUT)
    {
      return HAL_SD_ERROR_TIMEOUT;
    }
  }

  if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_DTIMEOUT))
  {
    __HAL_SD_CLEAR_FLAG(hsd, SDMMC_FLAG_DTIMEOUT);

    return HAL_SD_ERROR_DATA_TIMEOUT;
  }
  else if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_DCRCFAIL))
  {
    __HAL_SD_CLEAR_FLAG(hsd, SDMMC_FLAG_DCRCFAIL);

    return HAL_SD_ERROR_DATA_CRC_FAIL;
  }
  else if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_RXOVERR))
  {
    __HAL_SD_CLEAR_FLAG(hsd, SDMMC_FLAG_RXOVERR);

    return HAL_SD_ERROR_RX_OVERRUN;
  }
  else
  {
    /* No error flag set */
    /* Clear all the static flags */
    __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_DATA_FLAGS);

    *scr = (((tempscr[1] & SDMMC_0TO7BITS) << 24U)  | ((tempscr[1] & SDMMC_8TO15BITS) << 8U) | \
            ((tempscr[1] & SDMMC_16TO23BITS) >> 8U) | ((tempscr[1] & SDMMC_24TO31BITS) >> 24U));
    scr++;
    *scr = (((tempscr[0] & SDMMC_0TO7BITS) << 24U)  | ((tempscr[0] & SDMMC_8TO15BITS) << 8U) | \
            ((tempscr[0] & SDMMC_16TO23BITS) >> 8U) | ((tempscr[0] & SDMMC_24TO31BITS) >> 24U));

  }

  return HAL_SD_ERROR_NONE;
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
static void SD_Read_IT(SD_HandleTypeDef *hsd)
{
  uint32_t count;
  uint32_t data;
  uint8_t *tmp;

  tmp = hsd->pRxBuffPtr;

  if (hsd->RxXferSize >= SDMMC_FIFO_SIZE)
  {
    /* Read data from SDMMC Rx FIFO */
    for (count = 0U; count < (SDMMC_FIFO_SIZE / 4U); count++)
    {
      data = SDMMC_ReadFIFO(hsd->Instance);
      *tmp = (uint8_t)(data & 0xFFU);
      tmp++;
      *tmp = (uint8_t)((data >> 8U) & 0xFFU);
      tmp++;
      *tmp = (uint8_t)((data >> 16U) & 0xFFU);
      tmp++;
      *tmp = (uint8_t)((data >> 24U) & 0xFFU);
      tmp++;
    }

    hsd->pRxBuffPtr = tmp;
    hsd->RxXferSize -= SDMMC_FIFO_SIZE;
  }
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
static void SD_Write_IT(SD_HandleTypeDef *hsd)
{
  uint32_t count;
  uint32_t data;
  const uint8_t *tmp;

  tmp = hsd->pTxBuffPtr;

  if (hsd->TxXferSize >= SDMMC_FIFO_SIZE)
  {
    /* Write data to SDMMC Tx FIFO */
    for (count = 0U; count < (SDMMC_FIFO_SIZE / 4U); count++)
    {
      data = (uint32_t)(*tmp);
      tmp++;
      data |= ((uint32_t)(*tmp) << 8U);
      tmp++;
      data |= ((uint32_t)(*tmp) << 16U);
      tmp++;
      data |= ((uint32_t)(*tmp) << 24U);
      tmp++;
      (void)SDMMC_WriteFIFO(hsd->Instance, &data);
    }

    hsd->pTxBuffPtr = tmp;
    hsd->TxXferSize -= SDMMC_FIFO_SIZE;
  }
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
uint32_t SD_SwitchSpeed(SD_HandleTypeDef *hsd, uint32_t SwitchSpeedMode)
{
  uint32_t errorstate = HAL_SD_ERROR_NONE;
  SDMMC_DataInitTypeDef sdmmc_datainitstructure;
  uint32_t SD_hs[16]  = {0};
  uint32_t count;
  uint32_t loop = 0 ;
  uint32_t Timeout = HAL_GetTick();

  if (hsd->SdCard.CardSpeed == CARD_NORMAL_SPEED)
  {
    /* Standard Speed Card <= 12.5Mhz  */
    return HAL_SD_ERROR_REQUEST_NOT_APPLICABLE;
  }

  if (hsd->SdCard.CardSpeed >= CARD_HIGH_SPEED)
  {
    /* Initialize the Data control register */
    hsd->Instance->DCTRL = 0;
    errorstate = SDMMC_CmdBlockLength(hsd->Instance, 64U);

    if (errorstate != HAL_SD_ERROR_NONE)
    {
      return errorstate;
    }

    /* Configure the SD DPSM (Data Path State Machine) */
    sdmmc_datainitstructure.DataTimeOut   = SDMMC_DATATIMEOUT;
    sdmmc_datainitstructure.DataLength    = 64U;
    sdmmc_datainitstructure.DataBlockSize = SDMMC_DATABLOCK_SIZE_64B ;
    sdmmc_datainitstructure.TransferDir   = SDMMC_TRANSFER_DIR_TO_SDMMC;
    sdmmc_datainitstructure.TransferMode  = SDMMC_TRANSFER_MODE_BLOCK;
    sdmmc_datainitstructure.DPSM          = SDMMC_DPSM_ENABLE;

    (void)SDMMC_ConfigData(hsd->Instance, &sdmmc_datainitstructure);

    errorstate = SDMMC_CmdSwitch(hsd->Instance, SwitchSpeedMode);
    if (errorstate != HAL_SD_ERROR_NONE)
    {
      return errorstate;
    }

    while (!__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_RXOVERR | SDMMC_FLAG_DCRCFAIL | SDMMC_FLAG_DTIMEOUT | SDMMC_FLAG_DBCKEND |
                              SDMMC_FLAG_DATAEND))
    {
      if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_RXFIFOHF))
      {
        for (count = 0U; count < 8U; count++)
        {
          SD_hs[(8U * loop) + count]  = SDMMC_ReadFIFO(hsd->Instance);
        }
        loop ++;
      }
      if ((HAL_GetTick() - Timeout) >=  SDMMC_SWDATATIMEOUT)
      {
        hsd->ErrorCode = HAL_SD_ERROR_TIMEOUT;
        hsd->State = HAL_SD_STATE_READY;
        return HAL_SD_ERROR_TIMEOUT;
      }
    }

    if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_DTIMEOUT))
    {
      __HAL_SD_CLEAR_FLAG(hsd, SDMMC_FLAG_DTIMEOUT);

      return errorstate;
    }
    else if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_DCRCFAIL))
    {
      __HAL_SD_CLEAR_FLAG(hsd, SDMMC_FLAG_DCRCFAIL);

      errorstate = SDMMC_ERROR_DATA_CRC_FAIL;

      return errorstate;
    }
    else if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_RXOVERR))
    {
      __HAL_SD_CLEAR_FLAG(hsd, SDMMC_FLAG_RXOVERR);

      errorstate = SDMMC_ERROR_RX_OVERRUN;

      return errorstate;
    }
    else
    {
      /* No error flag set */
    }

    /* Clear all the static flags */
    __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_DATA_FLAGS);

    /* Test if the switch mode HS is ok */
    if ((((uint8_t *)SD_hs)[13] & 2U) != 2U)
    {
      errorstate = SDMMC_ERROR_UNSUPPORTED_FEATURE;
    }

  }

  return errorstate;
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
#if (USE_SD_TRANSCEIVER != 0U)
static uint32_t SD_UltraHighSpeed(SD_HandleTypeDef *hsd, uint32_t UltraHighSpeedMode)
{
  uint32_t errorstate = HAL_SD_ERROR_NONE;
  SDMMC_DataInitTypeDef sdmmc_datainitstructure;
  uint32_t SD_hs[16]  = {0};
  uint32_t count;
  uint32_t loop = 0 ;
  uint32_t Timeout = HAL_GetTick();

  if (hsd->SdCard.CardSpeed == CARD_NORMAL_SPEED)
  {
    /* Standard Speed Card <= 12.5Mhz  */
    return HAL_SD_ERROR_REQUEST_NOT_APPLICABLE;
  }

  if (hsd->SdCard.CardSpeed == CARD_ULTRA_HIGH_SPEED)
  {
    /* Initialize the Data control register */
    hsd->Instance->DCTRL = 0;
    errorstate = SDMMC_CmdBlockLength(hsd->Instance, 64U);

    if (errorstate != HAL_SD_ERROR_NONE)
    {
      return errorstate;
    }

    /* Configure the SD DPSM (Data Path State Machine) */
    sdmmc_datainitstructure.DataTimeOut   = SDMMC_DATATIMEOUT;
    sdmmc_datainitstructure.DataLength    = 64U;
    sdmmc_datainitstructure.DataBlockSize = SDMMC_DATABLOCK_SIZE_64B ;
    sdmmc_datainitstructure.TransferDir   = SDMMC_TRANSFER_DIR_TO_SDMMC;
    sdmmc_datainitstructure.TransferMode  = SDMMC_TRANSFER_MODE_BLOCK;
    sdmmc_datainitstructure.DPSM          = SDMMC_DPSM_ENABLE;

    if (SDMMC_ConfigData(hsd->Instance, &sdmmc_datainitstructure) != HAL_OK)
    {
      return (HAL_SD_ERROR_GENERAL_UNKNOWN_ERR);
    }

    errorstate = SDMMC_CmdSwitch(hsd->Instance, UltraHighSpeedMode);
    if (errorstate != HAL_SD_ERROR_NONE)
    {
      return errorstate;
    }

    while (!__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_RXOVERR | SDMMC_FLAG_DCRCFAIL | SDMMC_FLAG_DTIMEOUT | SDMMC_FLAG_DBCKEND |
                              SDMMC_FLAG_DATAEND))
    {
      if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_RXFIFOHF))
      {
        for (count = 0U; count < 8U; count++)
        {
          SD_hs[(8U * loop) + count]  = SDMMC_ReadFIFO(hsd->Instance);
        }
        loop ++;
      }

      if ((HAL_GetTick() - Timeout) >=  SDMMC_SWDATATIMEOUT)
      {
        hsd->ErrorCode = HAL_SD_ERROR_TIMEOUT;
        hsd->State = HAL_SD_STATE_READY;
        return HAL_SD_ERROR_TIMEOUT;
      }
    }

    if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_DTIMEOUT))
    {
      __HAL_SD_CLEAR_FLAG(hsd, SDMMC_FLAG_DTIMEOUT);

      return errorstate;
    }
    else if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_DCRCFAIL))
    {
      __HAL_SD_CLEAR_FLAG(hsd, SDMMC_FLAG_DCRCFAIL);

      errorstate = SDMMC_ERROR_DATA_CRC_FAIL;

      return errorstate;
    }
    else if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_RXOVERR))
    {
      __HAL_SD_CLEAR_FLAG(hsd, SDMMC_FLAG_RXOVERR);

      errorstate = SDMMC_ERROR_RX_OVERRUN;

      return errorstate;
    }
    else
    {
      /* No error flag set */
    }

    /* Clear all the static flags */
    __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_DATA_FLAGS);

    /* Test if the switch mode HS is ok */
    if ((((uint8_t *)SD_hs)[13] & 2U) != 2U)
    {
      errorstate = SDMMC_ERROR_UNSUPPORTED_FEATURE;
    }
    else
    {
#if defined (USE_HAL_SD_REGISTER_CALLBACKS) && (USE_HAL_SD_REGISTER_CALLBACKS == 1U)
      hsd->DriveTransceiver_1_8V_Callback(SET);
#else
      HAL_SD_DriveTransceiver_1_8V_Callback(SET);
#endif /* USE_HAL_SD_REGISTER_CALLBACKS */
#if defined (DLYB_SDMMC1) || defined (DLYB_SDMMC2)
      /* Enable DelayBlock Peripheral */
      /* SDMMC_FB_CLK tuned feedback clock selected as receive clock, for SDR104 */
      MODIFY_REG(hsd->Instance->CLKCR, SDMMC_CLKCR_SELCLKRX, SDMMC_CLKCR_SELCLKRX_1);
      LL_DLYB_Enable(SD_GET_DLYB_INSTANCE(hsd->Instance));
#endif /* (DLYB_SDMMC1) || (DLYB_SDMMC2) */
    }
  }

  return errorstate;
}
#endif
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
#if (USE_SD_TRANSCEIVER != 0U)
static uint32_t SD_DDR_Mode(SD_HandleTypeDef *hsd)
{
  uint32_t errorstate = HAL_SD_ERROR_NONE;
  SDMMC_DataInitTypeDef sdmmc_datainitstructure;
  uint32_t SD_hs[16]  = {0};
  uint32_t count;
  uint32_t loop = 0 ;
  uint32_t Timeout = HAL_GetTick();

  if (hsd->SdCard.CardSpeed == CARD_NORMAL_SPEED)
  {
    /* Standard Speed Card <= 12.5Mhz  */
    return HAL_SD_ERROR_REQUEST_NOT_APPLICABLE;
  }

  if (hsd->SdCard.CardSpeed == CARD_ULTRA_HIGH_SPEED)
  {
    /* Initialize the Data control register */
    hsd->Instance->DCTRL = 0;
    errorstate = SDMMC_CmdBlockLength(hsd->Instance, 64U);

    if (errorstate != HAL_SD_ERROR_NONE)
    {
      return errorstate;
    }

    /* Configure the SD DPSM (Data Path State Machine) */
    sdmmc_datainitstructure.DataTimeOut   = SDMMC_DATATIMEOUT;
    sdmmc_datainitstructure.DataLength    = 64U;
    sdmmc_datainitstructure.DataBlockSize = SDMMC_DATABLOCK_SIZE_64B ;
    sdmmc_datainitstructure.TransferDir   = SDMMC_TRANSFER_DIR_TO_SDMMC;
    sdmmc_datainitstructure.TransferMode  = SDMMC_TRANSFER_MODE_BLOCK;
    sdmmc_datainitstructure.DPSM          = SDMMC_DPSM_ENABLE;

    if (SDMMC_ConfigData(hsd->Instance, &sdmmc_datainitstructure) != HAL_OK)
    {
      return (HAL_SD_ERROR_GENERAL_UNKNOWN_ERR);
    }

    errorstate = SDMMC_CmdSwitch(hsd->Instance, SDMMC_DDR50_SWITCH_PATTERN);
    if (errorstate != HAL_SD_ERROR_NONE)
    {
      return errorstate;
    }

    while (!__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_RXOVERR | SDMMC_FLAG_DCRCFAIL | SDMMC_FLAG_DTIMEOUT | SDMMC_FLAG_DBCKEND |
                              SDMMC_FLAG_DATAEND))
    {
      if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_RXFIFOHF))
      {
        for (count = 0U; count < 8U; count++)
        {
          SD_hs[(8U * loop) + count]  = SDMMC_ReadFIFO(hsd->Instance);
        }
        loop ++;
      }

      if ((HAL_GetTick() - Timeout) >=  SDMMC_SWDATATIMEOUT)
      {
        hsd->ErrorCode = HAL_SD_ERROR_TIMEOUT;
        hsd->State = HAL_SD_STATE_READY;
        return HAL_SD_ERROR_TIMEOUT;
      }
    }

    if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_DTIMEOUT))
    {
      __HAL_SD_CLEAR_FLAG(hsd, SDMMC_FLAG_DTIMEOUT);

      return errorstate;
    }
    else if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_DCRCFAIL))
    {
      __HAL_SD_CLEAR_FLAG(hsd, SDMMC_FLAG_DCRCFAIL);

      errorstate = SDMMC_ERROR_DATA_CRC_FAIL;

      return errorstate;
    }
    else if (__HAL_SD_GET_FLAG(hsd, SDMMC_FLAG_RXOVERR))
    {
      __HAL_SD_CLEAR_FLAG(hsd, SDMMC_FLAG_RXOVERR);

      errorstate = SDMMC_ERROR_RX_OVERRUN;

      return errorstate;
    }
    else
    {
      /* No error flag set */
    }

    /* Clear all the static flags */
    __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_DATA_FLAGS);

    /* Test if the switch mode  is ok */
    if ((((uint8_t *)SD_hs)[13] & 2U) != 2U)
    {
      errorstate = SDMMC_ERROR_UNSUPPORTED_FEATURE;
    }
    else
    {
#if defined (USE_HAL_SD_REGISTER_CALLBACKS) && (USE_HAL_SD_REGISTER_CALLBACKS == 1U)
      hsd->DriveTransceiver_1_8V_Callback(SET);
#else
      HAL_SD_DriveTransceiver_1_8V_Callback(SET);
#endif /* USE_HAL_SD_REGISTER_CALLBACKS */
#if defined (DLYB_SDMMC1) || defined (DLYB_SDMMC2)
      /* Enable DelayBlock Peripheral */
      /* SDMMC_CKin feedback clock selected as receive clock, for DDR50 */
      MODIFY_REG(hsd->Instance->CLKCR, SDMMC_CLKCR_SELCLKRX, SDMMC_CLKCR_SELCLKRX_0);
      LL_DLYB_Enable(SD_GET_DLYB_INSTANCE(hsd->Instance));
#endif /* (DLYB_SDMMC1) || (DLYB_SDMMC2) */
    }
  }

  return errorstate;
}
#endif
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDEx_DMALinkedList_BuildNode(SD_DMALinkNodeTypeDef *pNode, SD_DMALinkNodeConfTypeDef *pNodeConf)
{

  (void)SDMMC_DMALinkedList_BuildNode(pNode, pNodeConf);

  return (HAL_OK);

}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDEx_DMALinkedList_InsertNode(SD_DMALinkedListTypeDef *pLinkedList,
                                                    SD_DMALinkNodeTypeDef *pPrevNode, SD_DMALinkNodeTypeDef *pNewNode)
{

  (void)SDMMC_DMALinkedList_InsertNode(pLinkedList, pPrevNode, pNewNode);

  return (HAL_OK);

}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDEx_DMALinkedList_RemoveNode(SD_DMALinkedListTypeDef *pLinkedList, SD_DMALinkNodeTypeDef *pNode)
{

  if (SDMMC_DMALinkedList_RemoveNode(pLinkedList, pNode) != SDMMC_ERROR_NONE)
  {
    return HAL_ERROR;
  }
  else
  {
    return HAL_OK;
  }
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDEx_DMALinkedList_LockNode(SD_DMALinkNodeTypeDef *pNode)
{

  if (SDMMC_DMALinkedList_LockNode(pNode) != SDMMC_ERROR_NONE)
  {
    return HAL_ERROR;
  }
  else
  {
    return HAL_OK;
  }
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDEx_DMALinkedList_UnlockNode(SD_DMALinkNodeTypeDef *pNode)
{

  if (SDMMC_DMALinkedList_UnlockNode(pNode) != SDMMC_ERROR_NONE)
  {
    return HAL_ERROR;
  }
  else
  {
    return HAL_OK;
  }
}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDEx_DMALinkedList_EnableCircularMode(SD_DMALinkedListTypeDef *pLinkedList)
{

  (void)SDMMC_DMALinkedList_EnableCircularMode(pLinkedList);

  return HAL_OK;

}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDEx_DMALinkedList_DisableCircularMode(SD_DMALinkedListTypeDef *pLinkedList)
{

  (void)SDMMC_DMALinkedList_DisableCircularMode(pLinkedList);

  return HAL_OK;

}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDEx_DMALinkedList_ReadBlocks(SD_HandleTypeDef *hsd,
                                                    const SDMMC_DMALinkedListTypeDef *pLinkedList,
                                                    uint32_t BlockAdd, uint32_t NumberOfBlocks)
{
  SDMMC_DataInitTypeDef config;
  uint32_t errorstate;
  uint32_t DmaBase0_reg;
  uint32_t DmaBase1_reg;
  uint32_t add = BlockAdd;

  if (hsd->State == HAL_SD_STATE_READY)
  {
    if ((add + NumberOfBlocks) > (hsd->SdCard.LogBlockNbr))
    {
      hsd->ErrorCode |= HAL_SD_ERROR_ADDR_OUT_OF_RANGE;
      return HAL_ERROR;
    }

    hsd->Instance->IDMABASER = (uint32_t) pLinkedList->pHeadNode->IDMABASER;
    hsd->Instance->IDMABSIZE = (uint32_t) pLinkedList->pHeadNode->IDMABSIZE;

    hsd->Instance->IDMABAR   = (uint32_t) pLinkedList->pHeadNode;
    hsd->Instance->IDMALAR   = (uint32_t) SDMMC_IDMALAR_ABR | SDMMC_IDMALAR_ULS | SDMMC_IDMALAR_ULA |
                               sizeof(SDMMC_DMALinkNodeTypeDef) ; /* Initial configuration */

    DmaBase0_reg = hsd->Instance->IDMABASER;
    DmaBase1_reg = hsd->Instance->IDMABAR;

    if ((hsd->Instance->IDMABSIZE == 0U) || (DmaBase0_reg == 0U) || (DmaBase1_reg == 0U))
    {
      hsd->ErrorCode = HAL_SD_ERROR_ADDR_OUT_OF_RANGE;
      return HAL_ERROR;
    }

    /* Initialize data control register */
    hsd->Instance->DCTRL = 0;
    /* Clear old Flags*/
    __HAL_SD_CLEAR_FLAG(hsd, SDMMC_STATIC_DATA_FLAGS);

    hsd->ErrorCode = HAL_SD_ERROR_NONE;
    hsd->State = HAL_SD_STATE_BUSY;

    if (hsd->SdCard.CardType != CARD_SDHC_SDXC)
    {
      add *= 512U;
    }

    /* Configure the SD DPSM (Data Path State Machine) */
    config.DataTimeOut   = SDMMC_DATATIMEOUT;
    config.DataLength    = BLOCKSIZE * NumberOfBlocks;
    config.DataBlockSize = SDMMC_DATABLOCK_SIZE_512B;
    config.TransferDir   = SDMMC_TRANSFER_DIR_TO_SDMMC;
    config.TransferMode  = SDMMC_TRANSFER_MODE_BLOCK;
    config.DPSM          = SDMMC_DPSM_DISABLE;
    (void)SDMMC_ConfigData(hsd->Instance, &config);

    hsd->Instance->DCTRL |= SDMMC_DCTRL_FIFORST;

    __SDMMC_CMDTRANS_ENABLE(hsd->Instance);

    hsd->Instance->IDMACTRL = SDMMC_ENABLE_IDMA_DOUBLE_BUFF0;

    /* Read Blocks in DMA mode */
    hsd->Context = (SD_CONTEXT_READ_MULTIPLE_BLOCK | SD_CONTEXT_DMA);

    /* Read Multi Block command */
    errorstate = SDMMC_CmdReadMultiBlock(hsd->Instance, add);
    if (errorstate != HAL_SD_ERROR_NONE)
    {
      hsd->State = HAL_SD_STATE_READY;
      hsd->ErrorCode |= errorstate;
      return HAL_ERROR;
    }

    __HAL_SD_ENABLE_IT(hsd, (SDMMC_IT_DCRCFAIL | SDMMC_IT_DTIMEOUT | SDMMC_IT_RXOVERR | SDMMC_IT_DATAEND |
                             SDMMC_IT_IDMABTC));

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }

}
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDEx_DMALinkedList_WriteBlocks(SD_HandleTypeDef *hsd,
                                                     const SDMMC_DMALinkedListTypeDef *pLinkedList,
                                                     uint32_t BlockAdd, uint32_t NumberOfBlocks)

{
  SDMMC_DataInitTypeDef config;
  uint32_t errorstate;
  uint32_t DmaBase0_reg;
  uint32_t DmaBase1_reg;
  uint32_t add = BlockAdd;

  if (hsd->State == HAL_SD_STATE_READY)
  {
    if ((add + NumberOfBlocks) > (hsd->SdCard.LogBlockNbr))
    {
      hsd->ErrorCode |= HAL_SD_ERROR_ADDR_OUT_OF_RANGE;
      return HAL_ERROR;
    }

    hsd->Instance->IDMABASER = (uint32_t) pLinkedList->pHeadNode->IDMABASER;
    hsd->Instance->IDMABSIZE = (uint32_t) pLinkedList->pHeadNode->IDMABSIZE;

    hsd->Instance->IDMABAR = (uint32_t)  pLinkedList->pHeadNode;
    hsd->Instance->IDMALAR = (uint32_t)  SDMMC_IDMALAR_ABR | SDMMC_IDMALAR_ULS | SDMMC_IDMALAR_ULA |
                             sizeof(SDMMC_DMALinkNodeTypeDef) ; /* Initial configuration */

    DmaBase0_reg = hsd->Instance->IDMABASER;
    DmaBase1_reg = hsd->Instance->IDMABAR;

    if ((hsd->Instance->IDMABSIZE == 0U) || (DmaBase0_reg == 0U) || (DmaBase1_reg == 0U))
    {
      hsd->ErrorCode = HAL_SD_ERROR_ADDR_OUT_OF_RANGE;
      return HAL_ERROR;
    }

    /* Initialize data control register */
    hsd->Instance->DCTRL = 0;

    hsd->ErrorCode = HAL_SD_ERROR_NONE;

    hsd->State = HAL_SD_STATE_BUSY;

    if (hsd->SdCard.CardType != CARD_SDHC_SDXC)
    {
      add *= 512U;
    }

    /* Configure the SD DPSM (Data Path State Machine) */
    config.DataTimeOut   = SDMMC_DATATIMEOUT;
    config.DataLength    = BLOCKSIZE * NumberOfBlocks;
    config.DataBlockSize = SDMMC_DATABLOCK_SIZE_512B;
    config.TransferDir   = SDMMC_TRANSFER_DIR_TO_CARD;
    config.TransferMode  = SDMMC_TRANSFER_MODE_BLOCK;
    config.DPSM          = SDMMC_DPSM_DISABLE;
    (void)SDMMC_ConfigData(hsd->Instance, &config);

    __SDMMC_CMDTRANS_ENABLE(hsd->Instance);

    hsd->Instance->IDMACTRL = SDMMC_ENABLE_IDMA_DOUBLE_BUFF0;

    /* Write Blocks in DMA mode */
    hsd->Context = (SD_CONTEXT_WRITE_MULTIPLE_BLOCK | SD_CONTEXT_DMA);

    /* Write Multi Block command */
    errorstate = SDMMC_CmdWriteMultiBlock(hsd->Instance, add);
    if (errorstate != HAL_SD_ERROR_NONE)
    {
      hsd->State = HAL_SD_STATE_READY;
      hsd->ErrorCode |= errorstate;
      return HAL_ERROR;
    }

    __HAL_SD_ENABLE_IT(hsd, (SDMMC_IT_DCRCFAIL | SDMMC_IT_DTIMEOUT | SDMMC_IT_TXUNDERR | SDMMC_IT_DATAEND |
                             SDMMC_IT_IDMABTC));

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif
#endif
