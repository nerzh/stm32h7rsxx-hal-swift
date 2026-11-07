// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Unchanged C DCMIPP function bodies from stm32h7rsxx_hal_dcmipp.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

HAL_StatusTypeDef HAL_DCMIPP_Init(DCMIPP_HandleTypeDef *hdcmipp)
{
  uint32_t pipe_index;

  /* Check pointer validity */
  if (hdcmipp == NULL)
  {
    return HAL_ERROR;
  }

  /* Check function parameters */
  assert_param(IS_DCMIPP_ALL_INSTANCE(hdcmipp->Instance));

  if (hdcmipp->State == HAL_DCMIPP_STATE_RESET)
  {
    /* Init the DCMIPP Callback settings */
#if (USE_HAL_DCMIPP_REGISTER_CALLBACKS == 1)
    /* Reset callback pointers to the weak predefined callbacks */
    hdcmipp->PIPE_FrameEventCallback = HAL_DCMIPP_PIPE_FrameEventCallback;
    hdcmipp->PIPE_VsyncEventCallback = HAL_DCMIPP_PIPE_VsyncEventCallback;
    hdcmipp->PIPE_LineEventCallback  = HAL_DCMIPP_PIPE_LineEventCallback;
    hdcmipp->PIPE_LimitEventCallback = HAL_DCMIPP_PIPE_LimitEventCallback;
    hdcmipp->PIPE_ErrorCallback      = HAL_DCMIPP_PIPE_ErrorCallback;
    hdcmipp->ErrorCallback           = HAL_DCMIPP_ErrorCallback;
    if (hdcmipp->MspInitCallback == NULL)
    {
      /* Legacy weak MspInit Callback        */
      hdcmipp->MspInitCallback = HAL_DCMIPP_MspInit;
    }
    /* Initialize the low level hardware (MSP) */
    hdcmipp->MspInitCallback(hdcmipp);
#else
    /* Init the low level hardware : GPIO, CLOCK, NVIC and DMA */
    HAL_DCMIPP_MspInit(hdcmipp);
#endif /* (USE_HAL_DCMIPP_REGISTER_CALLBACKS) */
  }

  /* Change the DCMIPP state */
  hdcmipp->State = HAL_DCMIPP_STATE_BUSY;

  /* Reset DCMIPP Pipe state */
  for (pipe_index = 0U; pipe_index < DCMIPP_NUM_OF_PIPES; pipe_index++)
  {
    hdcmipp->PipeState[pipe_index] = HAL_DCMIPP_PIPE_STATE_RESET;
  }

  /* Update error code */
  hdcmipp->ErrorCode = HAL_DCMIPP_ERROR_NONE;

  /* Update the DCMIPP state*/
  hdcmipp->State = HAL_DCMIPP_STATE_INIT;

  return HAL_OK;
}

HAL_StatusTypeDef HAL_DCMIPP_DeInit(DCMIPP_HandleTypeDef *hdcmipp)
{
  uint32_t pipe_index;

  /* Check pointer validity */
  if (hdcmipp == NULL)
  {
    return HAL_ERROR;
  }

  /* Disable the Parallel Interface */
  hdcmipp->Instance->PRCR &= ~DCMIPP_PRCR_ENABLE;

  /* Reset flow selection configuration register for the Pipe0 */
  hdcmipp->Instance->P0FSCR = 0;

#if (USE_HAL_DCMIPP_REGISTER_CALLBACKS == 1)
  if (hdcmipp->MspDeInitCallback == NULL)
  {
    hdcmipp->MspDeInitCallback = HAL_DCMIPP_MspDeInit;
  }

  /* DeInit the low level hardware */
  hdcmipp->MspDeInitCallback(hdcmipp);
#else
  /* DeInit the low level hardware */
  HAL_DCMIPP_MspDeInit(hdcmipp);
#endif /* USE_HAL_DCMIPP_REGISTER_CALLBACKS */

  /* Update error code */
  hdcmipp->ErrorCode = HAL_DCMIPP_ERROR_NONE;

  /* Initialize the DCMIPP state*/
  hdcmipp->State = HAL_DCMIPP_STATE_RESET;

  /* Reset DCMIPP Pipe state */
  for (pipe_index = 0U; pipe_index < DCMIPP_NUM_OF_PIPES; pipe_index++)
  {
    hdcmipp->PipeState[pipe_index] = HAL_DCMIPP_PIPE_STATE_RESET;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_DCMIPP_PARALLEL_SetConfig(DCMIPP_HandleTypeDef *hdcmipp,
                                                const DCMIPP_ParallelConfTypeDef *pParallelConfig)
{
  uint32_t prcr_reg;
  uint32_t prescr_reg;

  /* Check parameters */
  if ((hdcmipp == NULL) || (pParallelConfig == NULL))
  {
    return HAL_ERROR;
  }

  /* Check function parameters */
  assert_param(IS_DCMIPP_FORMAT(pParallelConfig->Format));
  assert_param(IS_DCMIPP_VSPOLARITY(pParallelConfig->VSPolarity));
  assert_param(IS_DCMIPP_HSPOLARITY(pParallelConfig->HSPolarity));
  assert_param(IS_DCMIPP_PCKPOLARITY(pParallelConfig->PCKPolarity));
  assert_param(IS_DCMIPP_EXTENDED_DATA_MODE(pParallelConfig->ExtendedDataMode));
  assert_param(IS_DCMIPP_SYNC_MODE(pParallelConfig->SynchroMode));
  assert_param(IS_DCMIPP_SWAP_BITS(pParallelConfig->SwapBits));
  assert_param(IS_DCMIPP_SWAP_CYCLES(pParallelConfig->SwapCycles));

  /* Check DCMIPP state */
  if (hdcmipp->State != HAL_DCMIPP_STATE_INIT)
  {
    return HAL_ERROR;
  }
  else
  {
    /* Configures the Format, VS, HS, PCK polarity, ExtendedDataMode, SynchronisationMode, Swap Cycles and bits */
    prcr_reg  = ((pParallelConfig->Format)           | \
                 (pParallelConfig->VSPolarity)       | \
                 (pParallelConfig->HSPolarity)       | \
                 (pParallelConfig->PCKPolarity)      | \
                 (pParallelConfig->ExtendedDataMode) | \
                 (pParallelConfig->SynchroMode)      | \
                 (pParallelConfig->SwapCycles)       | \
                 (pParallelConfig->SwapBits));

    WRITE_REG(hdcmipp->Instance->PRCR, prcr_reg);

    if (pParallelConfig->SynchroMode == DCMIPP_SYNCHRO_EMBEDDED)
    {
      /* Set Embedded Sync codes */
      prescr_reg = (((uint32_t)pParallelConfig->SynchroCodes.FrameEndCode << DCMIPP_PRESCR_FEC_Pos)   | \
                    ((uint32_t)pParallelConfig->SynchroCodes.LineEndCode << DCMIPP_PRESCR_LEC_Pos)    | \
                    ((uint32_t)pParallelConfig->SynchroCodes.FrameStartCode << DCMIPP_PRESCR_FSC_Pos) | \
                    ((uint32_t)pParallelConfig->SynchroCodes.LineStartCode << DCMIPP_PRESCR_LSC_Pos));

      WRITE_REG(hdcmipp->Instance->PRESCR, prescr_reg);

      /* Set Embedded Sync Unmask codes : All codes are unmasked */
      WRITE_REG(hdcmipp->Instance->PRESUR, 0xFFFFFFFFU);
    }

    /* Enable the Synchronization error interrupt on parallel interface */
    __HAL_DCMIPP_ENABLE_IT(hdcmipp, DCMIPP_IT_PARALLEL_SYNC_ERROR);

    /* Enable Parallel interface */
    SET_BIT(hdcmipp->Instance->PRCR, DCMIPP_PRCR_ENABLE);

  }

  /* Update the DCMIPP state */
  hdcmipp->State = HAL_DCMIPP_STATE_READY;

  return HAL_OK;
}

HAL_StatusTypeDef HAL_DCMIPP_PIPE_SetConfig(DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe,
                                            const DCMIPP_PipeConfTypeDef *pPipeConfig)
{
  HAL_DCMIPP_PipeStateTypeDef pipe_state;

  /* Check the DCMIPP peripheral handle parameter and pPipeConfig parameter */
  if ((hdcmipp == NULL) || (pPipeConfig == NULL))
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_DCMIPP_ALL_INSTANCE(hdcmipp->Instance));
  assert_param(IS_DCMIPP_PIPE(Pipe));
  assert_param(IS_DCMIPP_FRAME_RATE(pPipeConfig->FrameRate));
  /* Get Pipe State */
  pipe_state = hdcmipp->PipeState[Pipe];

  if (hdcmipp->State == HAL_DCMIPP_STATE_READY)
  {
    if ((pipe_state == HAL_DCMIPP_PIPE_STATE_READY) || (pipe_state == HAL_DCMIPP_PIPE_STATE_RESET) ||
        (pipe_state == HAL_DCMIPP_PIPE_STATE_ERROR))
    {
      /* Update the DCMIPP PIPE state */
      hdcmipp->PipeState[Pipe] = HAL_DCMIPP_PIPE_STATE_BUSY;

      /* Initialize the DCMIPP Pipe registers */
      Pipe_Config(hdcmipp, Pipe, pPipeConfig);

      /* Update the DCMIPP pipe state */
      hdcmipp->PipeState[Pipe] = HAL_DCMIPP_PIPE_STATE_READY;
    }
    else
    {
      return HAL_ERROR;
    }
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_DCMIPP_SetIPPlugConfig(DCMIPP_HandleTypeDef *hdcmipp,
                                             const DCMIPP_IPPlugConfTypeDef *pIPPlugConfig)
{
  uint32_t tickstart;

  /* Check handle validity */
  if ((hdcmipp == NULL) || (pIPPlugConfig == NULL))
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_DCMIPP_CLIENT(pIPPlugConfig->Client));
  assert_param(IS_DCMIPP_DPREG_END(pIPPlugConfig->DPREGEnd));
  assert_param(IS_DCMIPP_DPREG_START(pIPPlugConfig->DPREGStart));
  assert_param(IS_DCMIPP_MAX_OUTSTANDING_TRANSACTIONS(pIPPlugConfig->MaxOutstandingTransactions));
  assert_param(IS_DCMIPP_MEMORY_PAGE_SIZE(pIPPlugConfig->MemoryPageSize));
  assert_param(IS_DCMIPP_TRAFFIC(pIPPlugConfig->Traffic));
  assert_param(IS_DCMIPP_WLRU_RATIO(pIPPlugConfig->WLRURatio));


  if (hdcmipp->State != HAL_DCMIPP_STATE_RESET)
  {
    /* Request to lock the IP-Plug, to allow reconfiguration */
    SET_BIT(hdcmipp->Instance->IPGR2, DCMIPP_IPGR2_PSTART);

    tickstart = HAL_GetTick();
    do
    {
      if ((HAL_GetTick() - tickstart) > DCMIPP_TIMEOUT)
      {
        return HAL_ERROR;
      }
    } while ((hdcmipp->Instance->IPGR3 & DCMIPP_IPGR3_IDLE) != DCMIPP_IPGR3_IDLE);
  }
  else
  {
    return HAL_ERROR;
  }

  /* IP-Plug is currently locked and can be reconfigured */

  /* Set Memory page size */
  hdcmipp->Instance->IPGR1 = (pIPPlugConfig->MemoryPageSize);

  /* IP-PLUG Client1 configuration */
  switch (pIPPlugConfig->Client)
  {
    case DCMIPP_CLIENT1:
    {
      /* Set Traffic : Burst size and Maximum Outstanding transactions */
      hdcmipp->Instance->IPC1R1 = (pIPPlugConfig->Traffic |
                                   (pIPPlugConfig->MaxOutstandingTransactions << DCMIPP_IPC1R1_OTR_Pos));

      /* Set Ratio arbitration */
      hdcmipp->Instance->IPC1R2 = (pIPPlugConfig->WLRURatio << DCMIPP_IPC1R2_WLRU_Pos);

      /* Set End word and Start Word of the FIFO of the Clientx */
      hdcmipp->Instance->IPC1R3 = ((pIPPlugConfig->DPREGStart << DCMIPP_IPC1R3_DPREGSTART_Pos) |
                                   (pIPPlugConfig->DPREGEnd << DCMIPP_IPC1R3_DPREGEND_Pos));
      break;
    }
    default:
      break;
  }

  /* No lock requested, IP-Plug runs on demand by background HW */
  CLEAR_BIT(hdcmipp->Instance->IPGR2, DCMIPP_IPGR2_PSTART);

  /* Enable DCMIPP_IT_AXI_TRANSFER_ERR */
  __HAL_DCMIPP_ENABLE_IT(hdcmipp, DCMIPP_IT_AXI_TRANSFER_ERROR);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_DCMIPP_PIPE_Start(DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe, uint32_t DstAddress,
                                        uint32_t CaptureMode)
{
  assert_param(IS_DCMIPP_PIPE(Pipe));
  assert_param(IS_DCMIPP_CAPTURE_MODE(CaptureMode));

  /* Check pointer validity */
  if ((hdcmipp == NULL) || ((DstAddress & 0xFU) != 0U))
  {
    return HAL_ERROR;
  }

  if (hdcmipp->PipeState[Pipe] != HAL_DCMIPP_PIPE_STATE_READY)
  {
    return HAL_ERROR;
  }

  /* Set Capture Mode and Destination address for the selected pipe */
  DCMIPP_SetConfig(hdcmipp, Pipe, DstAddress, CaptureMode);

  /* Enable Capture for the selected Pipe */
  DCMIPP_EnableCapture(hdcmipp, Pipe);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_DCMIPP_PIPE_DoubleBufferStart(DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe, uint32_t DstAddress0,
                                                    uint32_t DstAddress1, uint32_t CaptureMode)
{
  assert_param(IS_DCMIPP_PIPE(Pipe));
  assert_param(IS_DCMIPP_CAPTURE_MODE(CaptureMode));

  /* Check pointer validity */
  if ((hdcmipp == NULL) || ((DstAddress0 & 0xFU) != 0U) || ((DstAddress1 & 0xFU) != 0U))
  {
    return HAL_ERROR;
  }

  if (hdcmipp->PipeState[Pipe] != HAL_DCMIPP_PIPE_STATE_READY)
  {
    return HAL_ERROR;
  }

  /* Set Capture Mode and Destination addresses for the selected pipe */
  DCMIPP_SetDBMConfig(hdcmipp, Pipe, DstAddress0, DstAddress1, CaptureMode);

  /* Enable Capture for the selected Pipe */
  DCMIPP_EnableCapture(hdcmipp, Pipe);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_DCMIPP_PIPE_Stop(DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe)
{
  HAL_DCMIPP_PipeStateTypeDef pipe_state;

  assert_param(IS_DCMIPP_PIPE(Pipe));

  /* Check pointer validity */
  if (hdcmipp == NULL)
  {
    return HAL_ERROR;
  }

  /* Get Pipe State */
  pipe_state = hdcmipp->PipeState[Pipe];

  /* Check DCMIPP Pipe state */
  if (pipe_state != HAL_DCMIPP_PIPE_STATE_RESET)
  {
    if (DCMIPP_Stop(hdcmipp, Pipe) != HAL_OK)
    {
      return HAL_ERROR;
    }

    /* Update the DCMIPP pipe State */
    hdcmipp->PipeState[Pipe] = HAL_DCMIPP_PIPE_STATE_READY;
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_DCMIPP_PIPE_Suspend(DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe)
{
  HAL_DCMIPP_PipeStateTypeDef pipe_state;
  uint32_t tickstart;

  assert_param(IS_DCMIPP_PIPE(Pipe));

  if (hdcmipp == NULL)
  {
    /* Return Function Status */
    return HAL_ERROR;
  }

  pipe_state = hdcmipp->PipeState[Pipe];

  if (Pipe == DCMIPP_PIPE0)
  {
    /* Check Pipe0 State */
    if (pipe_state == HAL_DCMIPP_PIPE_STATE_BUSY)
    {
      /* Disable Capture Request */
      CLEAR_BIT(hdcmipp->Instance->P0FCTCR, DCMIPP_P0FCTCR_CPTREQ);

      /* Change Pipe State */
      hdcmipp->PipeState[0] = HAL_DCMIPP_PIPE_STATE_SUSPEND;

      /* Poll CPTACT status till No capture currently active */
      tickstart = HAL_GetTick();
      do
      {
        if ((HAL_GetTick() - tickstart) > DCMIPP_TIMEOUT)
        {
          /* Change Pipe State */
          hdcmipp->PipeState[Pipe] = HAL_DCMIPP_PIPE_STATE_ERROR;

          return HAL_ERROR;
        }
      } while ((hdcmipp->Instance->CMSR1 & DCMIPP_CMSR1_P0CPTACT) != 0U);
    }
    else
    {
      /* Return Function Status */
      return HAL_ERROR;
    }
  }
  else
  {
    return HAL_ERROR;
  }

  /* Return Function Status */
  return HAL_OK;
}

HAL_StatusTypeDef HAL_DCMIPP_PIPE_Resume(DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe)
{
  HAL_DCMIPP_PipeStateTypeDef pipe_state ;

  assert_param(IS_DCMIPP_PIPE(Pipe));

  if (hdcmipp == NULL)
  {
    return HAL_ERROR;
  }

  pipe_state = hdcmipp->PipeState[Pipe];

  if (Pipe == DCMIPP_PIPE0)
  {
    /* Check Pipe0 State */
    if (pipe_state == HAL_DCMIPP_PIPE_STATE_SUSPEND)
    {
      /* Enable Capture Request */
      SET_BIT(hdcmipp->Instance->P0FCTCR, DCMIPP_P0FCTCR_CPTREQ);

      /* Change Pipe State */
      hdcmipp->PipeState[0] = HAL_DCMIPP_PIPE_STATE_BUSY;
    }
    else
    {
      return HAL_ERROR;
    }
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

void HAL_DCMIPP_IRQHandler(DCMIPP_HandleTypeDef *hdcmipp)
{
  uint32_t cmsr2flags = READ_REG(hdcmipp->Instance->CMSR2);
  uint32_t cmierflags = READ_REG(hdcmipp->Instance->CMIER);

  /* ========================= PIPE0 INTERRUPTS ==================== */
  /* Limit error on the PIPE0 ********************************************/
  if ((cmsr2flags & DCMIPP_FLAG_PIPE0_LIMIT) != 0U)
  {
    if ((cmierflags & DCMIPP_IT_PIPE0_LIMIT) != 0U)
    {
      /* Disable Limit error Interrupt for pipe0 */
      __HAL_DCMIPP_DISABLE_IT(hdcmipp, DCMIPP_IT_PIPE0_LIMIT);

      /* Update error code */
      hdcmipp->ErrorCode |= HAL_DCMIPP_ERROR_PIPE0_LIMIT;

      /* Clear the Limit error flag */
      __HAL_DCMIPP_CLEAR_FLAG(hdcmipp, DCMIPP_FLAG_PIPE0_LIMIT);

      /* LIMIT Callback */
#if (USE_HAL_DCMIPP_REGISTER_CALLBACKS == 1)
      hdcmipp->PIPE_LimitEventCallback(hdcmipp, DCMIPP_PIPE0);
#else
      HAL_DCMIPP_PIPE_LimitEventCallback(hdcmipp, DCMIPP_PIPE0);
#endif /* USE_HAL_DCMIPP_REGISTER_CALLBACKS */
    }
  }

  /* VSYNC interrupt management **********************************************/
  if ((cmsr2flags & DCMIPP_FLAG_PIPE0_VSYNC) != 0U)
  {
    if ((cmierflags & DCMIPP_IT_PIPE0_VSYNC) != 0U)
    {
      /* Clear the VSYNC flag for pipe0 */
      __HAL_DCMIPP_CLEAR_FLAG(hdcmipp, DCMIPP_FLAG_PIPE0_VSYNC);

      /* VSYNC Callback */
#if (USE_HAL_DCMIPP_REGISTER_CALLBACKS == 1)
      hdcmipp->PIPE_VsyncEventCallback(hdcmipp, DCMIPP_PIPE0);
#else
      HAL_DCMIPP_PIPE_VsyncEventCallback(hdcmipp, DCMIPP_PIPE0);
#endif /* USE_HAL_DCMIPP_REGISTER_CALLBACKS */
    }
  }

  /* FRAME interrupt management ****************************/
  if ((cmsr2flags & DCMIPP_FLAG_PIPE0_FRAME) != 0U)
  {
    if ((cmierflags & DCMIPP_IT_PIPE0_FRAME) != 0U)
    {
      /* When snapshot mode, disable Vsync, Error and Overrun interrupts */
      if ((hdcmipp->Instance->P0FCTCR & DCMIPP_P0FCTCR_CPTMODE) == DCMIPP_MODE_SNAPSHOT)
      {
        __HAL_DCMIPP_DISABLE_IT(hdcmipp, DCMIPP_IT_PIPE0_FRAME | DCMIPP_IT_PIPE0_VSYNC | DCMIPP_IT_PIPE0_OVR);

        /* Update Pipe State */
        hdcmipp->PipeState[0] = HAL_DCMIPP_PIPE_STATE_READY;
      }

      /* Clear the End of Frame flag */
      __HAL_DCMIPP_CLEAR_FLAG(hdcmipp, DCMIPP_FLAG_PIPE0_FRAME);

      /* Frame Callback */
#if (USE_HAL_DCMIPP_REGISTER_CALLBACKS == 1)
      hdcmipp->PIPE_FrameEventCallback(hdcmipp, DCMIPP_PIPE0);
#else
      HAL_DCMIPP_PIPE_FrameEventCallback(hdcmipp, DCMIPP_PIPE0);
#endif /* USE_HAL_DCMIPP_REGISTER_CALLBACKS */
    }
  }

  /* LINE interrupt management **********************************************/
  if ((cmsr2flags & DCMIPP_FLAG_PIPE0_LINE) != 0U)
  {
    if ((cmierflags & DCMIPP_IT_PIPE0_LINE) != 0U)
    {
      /* Clear the LINE flag */
      __HAL_DCMIPP_CLEAR_FLAG(hdcmipp, DCMIPP_FLAG_PIPE0_LINE);

      /* LINE Callback */
#if (USE_HAL_DCMIPP_REGISTER_CALLBACKS == 1)
      hdcmipp->PIPE_LineEventCallback(hdcmipp, DCMIPP_PIPE0);
#else
      HAL_DCMIPP_PIPE_LineEventCallback(hdcmipp, DCMIPP_PIPE0);
#endif /* USE_HAL_DCMIPP_REGISTER_CALLBACKS */
    }
  }

  /* Overrun error interrupt for Pipe0 ***************************************/
  if ((cmsr2flags & DCMIPP_FLAG_PIPE0_OVR) != 0U)
  {
    if ((cmierflags & DCMIPP_IT_PIPE0_OVR) != 0U)
    {
      /* Disable Overrun Error Interrupt for pipe0 */
      __HAL_DCMIPP_DISABLE_IT(hdcmipp, DCMIPP_IT_PIPE0_OVR);

      /* Update error code */
      hdcmipp->ErrorCode |= HAL_DCMIPP_ERROR_PIPE0_OVR;

      /* Clear the overrun error flag */
      __HAL_DCMIPP_CLEAR_FLAG(hdcmipp, DCMIPP_FLAG_PIPE0_OVR);

      /* Change DCMIPP Pipe state */
      hdcmipp->PipeState[0] = HAL_DCMIPP_PIPE_STATE_ERROR;

      /* Error Callback */
#if (USE_HAL_DCMIPP_REGISTER_CALLBACKS == 1)
      hdcmipp->PIPE_ErrorCallback(hdcmipp, DCMIPP_PIPE0);
#else
      HAL_DCMIPP_PIPE_ErrorCallback(hdcmipp, DCMIPP_PIPE0);
#endif /* USE_HAL_DCMIPP_REGISTER_CALLBACKS */
    }
  }


  /* Synchronization Error Interrupt on the parallel interface  **************/
  if ((cmsr2flags & DCMIPP_FLAG_PARALLEL_SYNC_ERROR) != 0U)
  {
    if ((cmierflags & DCMIPP_IT_PARALLEL_SYNC_ERROR) != 0U)
    {
      /* Disable Synchronization error interrupt on parallel interface */
      __HAL_DCMIPP_DISABLE_IT(hdcmipp, DCMIPP_IT_PARALLEL_SYNC_ERROR);

      /* Update error code */
      hdcmipp->ErrorCode |= HAL_DCMIPP_ERROR_PARALLEL_SYNC;

      /* Clear the synchronization error flag */
      __HAL_DCMIPP_CLEAR_FLAG(hdcmipp, DCMIPP_FLAG_PARALLEL_SYNC_ERROR);

      /* Change DCMIPP state */
      hdcmipp->State = HAL_DCMIPP_STATE_ERROR;

      /* Error Callback */
#if (USE_HAL_DCMIPP_REGISTER_CALLBACKS == 1)
      hdcmipp->ErrorCallback(hdcmipp);
#else
      HAL_DCMIPP_ErrorCallback(hdcmipp);
#endif /* USE_HAL_DCMIPP_REGISTER_CALLBACKS */
    }
  }

  /* IPPLUG AXI transfer Error Interrupt     *********************************/
  if ((cmsr2flags & DCMIPP_FLAG_AXI_TRANSFER_ERROR) != 0U)
  {
    if ((cmierflags & DCMIPP_IT_AXI_TRANSFER_ERROR) != 0U)
    {
      /* Disable IPPLUG AXI transfer Error Interrupt */
      __HAL_DCMIPP_DISABLE_IT(hdcmipp, DCMIPP_IT_AXI_TRANSFER_ERROR);

      /* Update error code */
      hdcmipp->ErrorCode |= HAL_DCMIPP_ERROR_AXI_TRANSFER;

      /* Clear the AXI transfer error flag */
      __HAL_DCMIPP_CLEAR_FLAG(hdcmipp, DCMIPP_FLAG_AXI_TRANSFER_ERROR);

      /* Change DCMIPP state */
      hdcmipp->State = HAL_DCMIPP_STATE_ERROR;

      /* Error Callback */
#if (USE_HAL_DCMIPP_REGISTER_CALLBACKS == 1)
      hdcmipp->ErrorCallback(hdcmipp);
#else
      HAL_DCMIPP_ErrorCallback(hdcmipp);
#endif /* USE_HAL_DCMIPP_REGISTER_CALLBACKS */
    }
  }
}

#if CP_MODE
HAL_StatusTypeDef HAL_DCMIPP_RegisterCallback(DCMIPP_HandleTypeDef *hdcmipp, HAL_DCMIPP_CallbackIDTypeDef CallbackID,
                                              pDCMIPP_CallbackTypeDef pCallback)
{

  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hdcmipp->ErrorCode |= HAL_DCMIPP_ERROR_INVALID_CALLBACK;
    return HAL_ERROR;
  }

  if (hdcmipp->State == HAL_DCMIPP_STATE_READY)
  {
    switch (CallbackID)
    {
      case HAL_DCMIPP_MSPINIT_CB_ID :
        hdcmipp->MspInitCallback = pCallback;
        break;

      case HAL_DCMIPP_MSPDEINIT_CB_ID :
        hdcmipp->MspDeInitCallback = pCallback;
        break;

      case HAL_DCMIPP_ERROR_CB_ID :
        hdcmipp->ErrorCallback = pCallback;
        break;

      default :
        /* Update the error code */
        hdcmipp->ErrorCode |= HAL_DCMIPP_ERROR_INVALID_CALLBACK;
        /* update return status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (hdcmipp->State == HAL_DCMIPP_STATE_RESET)
  {
    switch (CallbackID)
    {
      case HAL_DCMIPP_MSPINIT_CB_ID :
        hdcmipp->MspInitCallback = pCallback;
        break;

      case HAL_DCMIPP_MSPDEINIT_CB_ID :
        hdcmipp->MspDeInitCallback = pCallback;
        break;

      default :
        /* Update the error code */
        hdcmipp->ErrorCode |= HAL_DCMIPP_ERROR_INVALID_CALLBACK;
        /* update return status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hdcmipp->ErrorCode |= HAL_DCMIPP_ERROR_INVALID_CALLBACK;
    /* update return status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif

#if CP_MODE
HAL_StatusTypeDef HAL_DCMIPP_UnRegisterCallback(DCMIPP_HandleTypeDef *hdcmipp, HAL_DCMIPP_CallbackIDTypeDef CallbackID)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (hdcmipp->State == HAL_DCMIPP_STATE_READY)
  {
    switch (CallbackID)
    {
      case HAL_DCMIPP_MSPINIT_CB_ID :
        hdcmipp->MspInitCallback = HAL_DCMIPP_MspInit; /* Legacy weak (surcharged) Msp Init */
        break;

      case HAL_DCMIPP_MSPDEINIT_CB_ID :
        hdcmipp->MspDeInitCallback = HAL_DCMIPP_MspDeInit; /* Legacy weak (surcharged) Msp DeInit */
        break;

      default :
        /* Update the error code */
        hdcmipp->ErrorCode |= HAL_DCMIPP_ERROR_INVALID_CALLBACK;
        /* update return status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (hdcmipp->State == HAL_DCMIPP_STATE_RESET)
  {
    switch (CallbackID)
    {
      case HAL_DCMIPP_MSPINIT_CB_ID :
        hdcmipp->MspInitCallback = HAL_DCMIPP_MspInit;   /* Legacy weak (surcharged) Msp Init */
        break;

      case HAL_DCMIPP_MSPDEINIT_CB_ID :
        hdcmipp->MspDeInitCallback = HAL_DCMIPP_MspDeInit;  /* Legacy weak (surcharged) Msp DeInit */
        break;

      default :
        /* Update the error code */
        hdcmipp->ErrorCode |= HAL_DCMIPP_ERROR_INVALID_CALLBACK;
        /* update return status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hdcmipp->ErrorCode |= HAL_DCMIPP_ERROR_INVALID_CALLBACK;
    /* update return status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif

#if CP_MODE
HAL_StatusTypeDef HAL_DCMIPP_PIPE_RegisterCallback(DCMIPP_HandleTypeDef *hdcmipp,
                                                   HAL_DCMIPP_PIPE_CallbackIDTypeDef CallbackID,
                                                   pDCMIPP_PIPE_CallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hdcmipp->ErrorCode |= HAL_DCMIPP_ERROR_INVALID_CALLBACK;
    return HAL_ERROR;
  }

  if (hdcmipp->State == HAL_DCMIPP_STATE_READY)
  {
    switch (CallbackID)
    {
      case HAL_DCMIPP_PIPE_FRAME_EVENT_CB_ID :
        hdcmipp->PIPE_FrameEventCallback = pCallback;
        break;

      case HAL_DCMIPP_PIPE_VSYNC_EVENT_CB_ID :
        hdcmipp->PIPE_VsyncEventCallback = pCallback;
        break;

      case HAL_DCMIPP_PIPE_LINE_EVENT_CB_ID :
        hdcmipp->PIPE_LineEventCallback = pCallback;
        break;

      case HAL_DCMIPP_PIPE_LIMIT_EVENT_CB_ID :
        hdcmipp->PIPE_LimitEventCallback = pCallback;
        break;

      case HAL_DCMIPP_PIPE_ERROR_CB_ID :
        hdcmipp->PIPE_ErrorCallback = pCallback;
        break;

      default :
        /* Update the error code */
        hdcmipp->ErrorCode |= HAL_DCMIPP_ERROR_INVALID_CALLBACK;
        /* update return status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hdcmipp->ErrorCode |= HAL_DCMIPP_ERROR_INVALID_CALLBACK;
    /* update return status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif

#if CP_MODE
HAL_StatusTypeDef HAL_DCMIPP_PIPE_UnRegisterCallback(DCMIPP_HandleTypeDef *hdcmipp,
                                                     HAL_DCMIPP_PIPE_CallbackIDTypeDef CallbackID)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (hdcmipp->State == HAL_DCMIPP_STATE_READY)
  {
    switch (CallbackID)
    {
      case HAL_DCMIPP_PIPE_FRAME_EVENT_CB_ID :
        hdcmipp->PIPE_FrameEventCallback = HAL_DCMIPP_PIPE_FrameEventCallback;
        break;

      case HAL_DCMIPP_PIPE_VSYNC_EVENT_CB_ID :
        hdcmipp->PIPE_VsyncEventCallback = HAL_DCMIPP_PIPE_VsyncEventCallback;
        break;

      case HAL_DCMIPP_PIPE_LINE_EVENT_CB_ID :
        hdcmipp->PIPE_LineEventCallback = HAL_DCMIPP_PIPE_LineEventCallback;
        break;

      case HAL_DCMIPP_PIPE_LIMIT_EVENT_CB_ID :
        hdcmipp->PIPE_LimitEventCallback = HAL_DCMIPP_PIPE_LimitEventCallback;
        break;

      case HAL_DCMIPP_PIPE_ERROR_CB_ID :
        hdcmipp->PIPE_ErrorCallback = HAL_DCMIPP_PIPE_ErrorCallback;
        break;

      default :
        /* Update the error code */
        hdcmipp->ErrorCode |= HAL_DCMIPP_ERROR_INVALID_CALLBACK;
        /* update return status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hdcmipp->ErrorCode |= HAL_DCMIPP_ERROR_INVALID_CALLBACK;
    /* update return status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif

HAL_StatusTypeDef HAL_DCMIPP_PIPE_SetCropConfig(DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe,
                                                const DCMIPP_CropConfTypeDef *pCropConfig)
{
  uint32_t tmp;

  /* Check handle validity */
  if ((hdcmipp == NULL) || (pCropConfig == NULL))
  {
    return HAL_ERROR;
  }

  assert_param(IS_DCMIPP_PIPE(Pipe));
  assert_param(IS_DCMIPP_PIPE_CROP_AREA(pCropConfig->PipeArea));
  assert_param(IS_DCMIPP_PIPE_CROP_HSTART(pCropConfig->HStart));
  assert_param(IS_DCMIPP_PIPE_CROP_HSIZE(pCropConfig->HSize));
  assert_param(IS_DCMIPP_PIPE_CROP_VSIZE(pCropConfig->VSize));
  assert_param(IS_DCMIPP_PIPE_CROP_VSTART(pCropConfig->VStart));

  /* Check the DCMIPP State */
  if (hdcmipp->State == HAL_DCMIPP_STATE_READY)
  {

    if (Pipe == DCMIPP_PIPE0)
    {
      tmp = READ_REG(hdcmipp->Instance->PRCR);

      /* Verify for parallel mode with jpeg format , no Line Crop enable  */
      if (((tmp & DCMIPP_PRCR_ENABLE) == DCMIPP_PRCR_ENABLE) && ((tmp & DCMIPP_PRCR_FORMAT) == DCMIPP_FORMAT_BYTE))
      {
        return HAL_ERROR;
      }
      else
      {
        /* Set Cropping horizontal and vertical start for Pipe0 */
        MODIFY_REG(hdcmipp->Instance->P0SCSTR, DCMIPP_P0SCSTR_HSTART | DCMIPP_P0SCSTR_VSTART,
                   (pCropConfig->HStart << DCMIPP_P0SCSTR_HSTART_Pos) |
                   (pCropConfig->VStart << DCMIPP_P0SCSTR_VSTART_Pos));

        /* Set Cropping horizontal and vertical width for Pipe0 */
        /* Set crop Area (Inner or outer) for Pipe0 */
        MODIFY_REG(hdcmipp->Instance->P0SCSZR, DCMIPP_P0SCSZR_HSIZE | DCMIPP_P0SCSZR_VSIZE | DCMIPP_P0SCSZR_POSNEG,
                   (pCropConfig->HSize << DCMIPP_P0SCSZR_HSIZE_Pos) | (pCropConfig->VSize << DCMIPP_P0SCSZR_VSIZE_Pos) |
                   (pCropConfig->PipeArea));
      }
    }
    else
    {
      return HAL_ERROR;
    }
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_DCMIPP_PIPE_EnableCrop(DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe)
{
  uint32_t tmp;

  assert_param(IS_DCMIPP_PIPE(Pipe));

  /* Check handle validity */
  if (hdcmipp == NULL)
  {
    return HAL_ERROR;
  }

  if (hdcmipp->State == HAL_DCMIPP_STATE_READY)
  {
    if (Pipe == DCMIPP_PIPE0)
    {
      /* This bit must be kept cleared if the input format is JPEG */
      /* Verify for parallel mode with jpeg format , no Line Crop enable  */

      tmp = READ_REG(hdcmipp->Instance->PRCR);

      if (((tmp & DCMIPP_PRCR_ENABLE) == DCMIPP_PRCR_ENABLE) && ((tmp & DCMIPP_PRCR_FORMAT) == DCMIPP_FORMAT_BYTE))
      {
        return HAL_ERROR;
      }
      else
      {
        SET_BIT(hdcmipp->Instance->P0SCSZR, DCMIPP_P0SCSZR_ENABLE);
      }
    }
    else
    {
      return HAL_ERROR;
    }
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_DCMIPP_PIPE_DisableCrop(DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe)
{
  assert_param(IS_DCMIPP_PIPE(Pipe));

  /* Check handle validity */
  if (hdcmipp == NULL)
  {
    return HAL_ERROR;
  }

  if (Pipe == DCMIPP_PIPE0)
  {
    CLEAR_BIT(hdcmipp->Instance->P0SCSZR, DCMIPP_P0SCSZR_ENABLE);
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_DCMIPP_PIPE_SetBytesDecimationConfig(DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe,
                                                           uint32_t SelectStart, uint32_t SelectMode)
{
  uint32_t tmp;

  assert_param(IS_DCMIPP_PIPE(Pipe));
  assert_param(IS_DCMIPP_BYTE_SELECT_START(SelectStart));
  assert_param(IS_DCMIPP_BYTE_SELECT_MODE(SelectMode));

  /* Check handle validity */
  if (hdcmipp == NULL)
  {
    return HAL_ERROR;
  }

  if (Pipe == DCMIPP_PIPE0)
  {
    /* OEBS : This bit works in conjunction with BSM field (BSM != 00) */
    /* Modes 10 and 11 work only with EDM [2:0] = 000 into the DCMIPP_PRCR */
    tmp = (hdcmipp->Instance->PRCR & DCMIPP_PRCR_EDM);

    if (((SelectStart  == DCMIPP_OEBS_EVEN) && (SelectMode > DCMIPP_BSM_ALL)) || \
        ((SelectMode > DCMIPP_BSM_DATA_OUT_2) && (tmp != DCMIPP_INTERFACE_8BITS)))
    {
      return HAL_ERROR;
    }
    else
    {
      /* Set Bytes select Start and Bytes select Mode */
      MODIFY_REG(hdcmipp->Instance->P0PPCR, DCMIPP_P0PPCR_BSM | DCMIPP_P0PPCR_OEBS, (SelectStart | SelectMode));
    }
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_DCMIPP_PIPE_SetLinesDecimationConfig(DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe,
                                                           uint32_t SelectStart, uint32_t SelectMode)
{
  assert_param(IS_DCMIPP_PIPE(Pipe));
  assert_param(IS_DCMIPP_LINE_SELECT_MODE(SelectMode));
  assert_param(IS_DCMIPP_LINE_SELECT_START(SelectStart));

  /* Check handle validity */
  if (hdcmipp == NULL)
  {
    return HAL_ERROR;
  }

  if (Pipe == DCMIPP_PIPE0)
  {
    /* This bit works in conjunction with LSM field (LSM = 1) */
    if ((SelectStart == DCMIPP_OELS_EVEN) && (SelectMode == DCMIPP_LSM_ALTERNATE_2))
    {
      return HAL_ERROR;
    }
    else
    {
      /* Set Lines select Start and Bytes select Mode */
      MODIFY_REG(hdcmipp->Instance->P0PPCR, DCMIPP_P0PPCR_LSM | DCMIPP_P0PPCR_OELS, (SelectStart | SelectMode));
    }
  }
  else
  {
    return HAL_ERROR;
  }
  return HAL_OK;
}

HAL_StatusTypeDef HAL_DCMIPP_PIPE_EnableLimitEvent(DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe, uint32_t Limit)
{
  assert_param(IS_DCMIPP_PIPE(Pipe));
  assert_param(IS_DCMIPP_DATA_LIMIT(Limit));

  /* Check Parameters */
  if (hdcmipp == NULL)
  {
    return HAL_ERROR;
  }

  if (Pipe == DCMIPP_PIPE0)
  {
    /* Set and enable data limit on Pipe 0 */
    WRITE_REG(hdcmipp->Instance->P0DCLMTR, (Limit << DCMIPP_P0DCLMTR_LIMIT_Pos) | DCMIPP_P0DCLMTR_ENABLE);

    /* Enable Limit Interrupt for pipe0 */
    __HAL_DCMIPP_ENABLE_IT(hdcmipp, DCMIPP_IT_PIPE0_LIMIT);
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_DCMIPP_PIPE_DisableLimitEvent(DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe)
{
  assert_param(IS_DCMIPP_PIPE(Pipe));

  /* Check Parameters */
  if (hdcmipp == NULL)
  {
    return HAL_ERROR;
  }

  if (Pipe == DCMIPP_PIPE0)
  {
    /* Disable data limit on Pipe 0 */
    CLEAR_BIT(hdcmipp->Instance->P0DCLMTR, DCMIPP_P0DCLMTR_ENABLE);

    /* Disable Limit Interrupt for pipe0 */
    __HAL_DCMIPP_DISABLE_IT(hdcmipp, DCMIPP_IT_PIPE0_LIMIT);
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_DCMIPP_PIPE_SetFrameRate(DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe, uint32_t FrameRate)
{
  /* Check Parameters */
  if (hdcmipp == NULL)
  {
    return HAL_ERROR;
  }

  /* Check parameters */
  assert_param(IS_DCMIPP_PIPE(Pipe));
  assert_param(IS_DCMIPP_FRAME_RATE(FrameRate));

  /* Set Frame Rate for the Pipe */
  if (Pipe == DCMIPP_PIPE0)
  {
    MODIFY_REG(hdcmipp->Instance->P0FCTCR, DCMIPP_P0FCTCR_FRATE, FrameRate);
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_DCMIPP_PIPE_SetCaptureMode(DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe, uint32_t CaptureMode)
{
  /* Check Parameters */
  if (hdcmipp == NULL)
  {
    return HAL_ERROR;
  }

  assert_param(IS_DCMIPP_PIPE(Pipe));
  assert_param(IS_DCMIPP_CAPTURE_MODE(CaptureMode));


  /* Set Capture Mode */
  if (Pipe == DCMIPP_PIPE0)
  {
    MODIFY_REG(hdcmipp->Instance->P0FCTCR, DCMIPP_P0FCTCR_CPTMODE, CaptureMode);
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_DCMIPP_PIPE_EnableCapture(DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe)
{
  /* Check Parameters */
  if (hdcmipp == NULL)
  {
    return HAL_ERROR;
  }

  /* Request Capture for the chosen Pipe */

  if (Pipe == DCMIPP_PIPE0)
  {
    SET_BIT(hdcmipp->Instance->P0FCTCR, DCMIPP_P0FCTCR_CPTREQ);
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_DCMIPP_PIPE_SetMemoryAddress(DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe, uint32_t Memory,
                                                   uint32_t DstAddress)
{
  /* Check Parameters */
  if (hdcmipp == NULL)
  {
    return HAL_ERROR;
  }

  assert_param(IS_DCMIPP_PIPE(Pipe));
  assert_param(IS_DCMIPP_MEMORY_ADDRESS(Memory));

  /* Request Capture for the chosen Pipe */

  if (Pipe == DCMIPP_PIPE0)
  {
    if (Memory == DCMIPP_MEMORY_ADDRESS_0)
    {
      /* Set Memory0 destination addresses for pipe0 */
      WRITE_REG(hdcmipp->Instance->P0PPM0AR1, DstAddress);
    }
    else
    {
      if ((hdcmipp->Instance->P0PPCR & DCMIPP_P0PPCR_DBM) == DCMIPP_P0PPCR_DBM)
      {
        /* Set Memory1 destination addresses for pipe0 */
        WRITE_REG(hdcmipp->Instance->P0PPM0AR2, DstAddress);
      }
      else
      {
        return HAL_ERROR;
      }
    }
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;

}

HAL_StatusTypeDef HAL_DCMIPP_PIPE_PARALLEL_SetInputPixelFormat(DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe,
                                                               uint32_t InputPixelFormat)
{
  assert_param(IS_DCMIPP_PIPE(Pipe));
  assert_param(IS_DCMIPP_FORMAT(InputPixelFormat));

  if (hdcmipp == NULL)
  {
    return HAL_ERROR;
  }

  if (Pipe == DCMIPP_PIPE0)
  {
    /* Set Frame Rate */
    MODIFY_REG(hdcmipp->Instance->PRCR, DCMIPP_PRCR_FORMAT, InputPixelFormat);
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_DCMIPP_PARALLEL_SetSyncUnmask(DCMIPP_HandleTypeDef *hdcmipp,
                                                    const DCMIPP_EmbeddedSyncUnmaskTypeDef *SyncUnmask)
{
  uint32_t presur_reg;
  uint32_t prcr_reg;

  /* Check pointer validity */
  if ((hdcmipp == NULL) || (SyncUnmask == NULL))
  {
    return HAL_ERROR;
  }

  /* Check the DCMIPP State */
  if (hdcmipp->State == HAL_DCMIPP_STATE_READY)
  {
    prcr_reg = hdcmipp->Instance->PRCR;
    /* Check that Embedded synchronisation mode is configured */
    if ((prcr_reg & DCMIPP_PRCR_ESS) == DCMIPP_SYNCHRO_EMBEDDED)
    {
      /* Configure DCMIPP embedded synchronization unmask register */
      presur_reg = (((uint32_t)SyncUnmask->FrameStartUnmask << DCMIPP_PRESUR_FSU_Pos) | \
                    ((uint32_t)SyncUnmask->LineStartUnmask << DCMIPP_PRESUR_LSU_Pos)  | \
                    ((uint32_t)SyncUnmask->LineEndUnmask << DCMIPP_PRESUR_LEU_Pos)    | \
                    ((uint32_t)SyncUnmask->FrameEndUnmask << DCMIPP_PRESUR_FEU_Pos));

      WRITE_REG(hdcmipp->Instance->PRESUR, presur_reg);
    }
    else
    {
      return HAL_ERROR;
    }
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_DCMIPP_PIPE_EnableLineEvent(DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe, uint32_t Line)
{
  assert_param(IS_DCMIPP_PIPE(Pipe));
  assert_param(IS_DCMIPP_PIPE_MULTILINE(Line));

  if (Pipe == DCMIPP_PIPE0)
  {
    /* Set MultiLine configuration */
    MODIFY_REG(hdcmipp->Instance->P0PPCR, DCMIPP_P0PPCR_LINEMULT, Line);

    /* Enable Multiline Interrupt */
    __HAL_DCMIPP_ENABLE_IT(hdcmipp, DCMIPP_IT_PIPE0_LINE);
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_DCMIPP_PIPE_DisableLineEvent(DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe)
{
  assert_param(IS_DCMIPP_PIPE(Pipe));

  /* Disable Multiline Interrupt */
  if (Pipe == DCMIPP_PIPE0)
  {
    __HAL_DCMIPP_DISABLE_IT(hdcmipp, DCMIPP_IT_PIPE0_LINE);
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_DCMIPP_PIPE_ResetFrameCounter(DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe)
{

  /* Check pointer validity */
  if (hdcmipp == NULL)
  {
    return HAL_ERROR;
  }

  /* Prevent unused argument(s) compilation warning */
  UNUSED(Pipe);
  /* Check parameters */
  assert_param(IS_DCMIPP_PIPE(Pipe));

  /* Check the DCMIPP State */
  if (hdcmipp->State == HAL_DCMIPP_STATE_READY)
  {
    /* Clear Frame counter */
    SET_BIT(hdcmipp->Instance->CMCR, DCMIPP_CMCR_CFC);
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_DCMIPP_PIPE_ReadFrameCounter(const DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe,
                                                   uint32_t *pCounter)
{

  /* Check parameters */
  assert_param(IS_DCMIPP_PIPE(Pipe));

  /* Prevent unused argument(s) compilation warning */
  UNUSED(Pipe);
  /* Check pointer validity */
  if ((hdcmipp == NULL) || (pCounter == NULL))
  {
    return HAL_ERROR;
  }

  /* Check the DCMIPP State */
  if (hdcmipp->State == HAL_DCMIPP_STATE_READY)
  {
    /* Read frame counter */
    *pCounter = READ_REG(hdcmipp->Instance->CMFRCR);
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_DCMIPP_PIPE_GetDataCounter(const DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe,
                                                 uint32_t *pCounter)
{
  /* Check parameters */
  assert_param(IS_DCMIPP_PIPE(Pipe));

  /* Prevent unused argument(s) compilation warning */
  UNUSED(Pipe);
  /* Check pointer validity */
  if ((hdcmipp == NULL) || (pCounter == NULL))
  {
    return HAL_ERROR;
  }

  /* Check the DCMIPP State */
  if (hdcmipp->State == HAL_DCMIPP_STATE_READY)
  {
    /* Read  Pipe0 dump counter register */
    *pCounter = READ_REG(hdcmipp->Instance->P0DCCNTR);
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_DCMIPP_StateTypeDef HAL_DCMIPP_GetState(const DCMIPP_HandleTypeDef *hdcmipp)
{
  return hdcmipp->State;
}

uint32_t HAL_DCMIPP_GetError(const DCMIPP_HandleTypeDef *hdcmipp)
{
  return hdcmipp->ErrorCode;
}

HAL_DCMIPP_PipeStateTypeDef HAL_DCMIPP_PIPE_GetState(const DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe)
{
  /* Check Parameters */
  assert_param(IS_DCMIPP_PIPE(Pipe));

  return hdcmipp->PipeState[Pipe];
}

static void Pipe_Config(DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe, const DCMIPP_PipeConfTypeDef *pPipeConfig)
{
  if (Pipe == DCMIPP_PIPE0)
  {
    /* Configure Pipe0 */
    /* Configure Frame Rate */
    MODIFY_REG(hdcmipp->Instance->P0FCTCR, DCMIPP_P0FCTCR_FRATE, pPipeConfig->FrameRate);
  }
}

static void DCMIPP_SetConfig(DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe, uint32_t DstAddress, uint32_t CaptureMode)
{
  if (Pipe == DCMIPP_PIPE0)
  {
    /* Update the DCMIPP pipe State */
    hdcmipp->PipeState[Pipe] = HAL_DCMIPP_PIPE_STATE_BUSY;

    /* Set the capture mode */
    hdcmipp->Instance->P0FCTCR |= CaptureMode;

    /* Set the destination address */
    WRITE_REG(hdcmipp->Instance->P0PPM0AR1, DstAddress);

    /* Enable all required interrupts lines for the PIPE0 */
    __HAL_DCMIPP_ENABLE_IT(hdcmipp, DCMIPP_IT_PIPE0_FRAME | DCMIPP_IT_PIPE0_VSYNC | DCMIPP_IT_PIPE0_OVR |
                           DCMIPP_IT_AXI_TRANSFER_ERROR);
  }
}

static void DCMIPP_SetDBMConfig(DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe, uint32_t DstAddress0,
                                uint32_t DstAddress1, uint32_t CaptureMode)
{
  if (Pipe == DCMIPP_PIPE0)
  {
    /* Update the DCMIPP pipe State */
    hdcmipp->PipeState[Pipe] = HAL_DCMIPP_PIPE_STATE_BUSY;

    /* Set the capture mode */
    hdcmipp->Instance->P0FCTCR |= CaptureMode;

    /* Set the destination address */
    WRITE_REG(hdcmipp->Instance->P0PPM0AR1, DstAddress0);

    /* Set the second destination address */
    WRITE_REG(hdcmipp->Instance->P0PPM0AR2, DstAddress1);

    /* Enable Double buffering Mode */
    SET_BIT(hdcmipp->Instance->P0PPCR, DCMIPP_P0PPCR_DBM);

    /* Enable all required interrupts lines for the Pipe0 */
    __HAL_DCMIPP_ENABLE_IT(hdcmipp, DCMIPP_IT_PIPE0_FRAME | DCMIPP_IT_PIPE0_VSYNC | DCMIPP_IT_PIPE0_OVR);
  }
}

static void DCMIPP_EnableCapture(DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe)
{
  if (Pipe == DCMIPP_PIPE0)
  {
    /* Activate the Pipe */
    SET_BIT(hdcmipp->Instance->P0FSCR, DCMIPP_P0FSCR_PIPEN);

    /* Start the capture */
    SET_BIT(hdcmipp->Instance->P0FCTCR, DCMIPP_P0FCTCR_CPTREQ);
  }
}

static HAL_StatusTypeDef DCMIPP_Stop(DCMIPP_HandleTypeDef *hdcmipp, uint32_t Pipe)
{
  uint32_t tickstart;

  if (Pipe == DCMIPP_PIPE0)
  {
    /* Stop the capture */
    CLEAR_BIT(hdcmipp->Instance->P0FCTCR, DCMIPP_P0FCTCR_CPTREQ);

    /* Poll CPTACT status till No capture currently active */
    tickstart = HAL_GetTick();
    do
    {
      if ((HAL_GetTick() - tickstart) > DCMIPP_TIMEOUT)
      {
        return HAL_ERROR;
      }
    } while ((hdcmipp->Instance->CMSR1 & DCMIPP_CMSR1_P0CPTACT) != 0U);

    /* Disable DBM when enabled */
    if ((hdcmipp->Instance->P0PPCR & DCMIPP_P0PPCR_DBM) == DCMIPP_P0PPCR_DBM)
    {
      CLEAR_BIT(hdcmipp->Instance->P0PPCR, DCMIPP_P0PPCR_DBM);
    }

    /* Disable the pipe */
    CLEAR_BIT(hdcmipp->Instance->P0FSCR, DCMIPP_P0FSCR_PIPEN);

    /* Disable all interrupts for this pipe */
    __HAL_DCMIPP_DISABLE_IT(hdcmipp, DCMIPP_IT_PIPE0_FRAME | DCMIPP_IT_PIPE0_VSYNC | DCMIPP_IT_PIPE0_LINE | \
                            DCMIPP_IT_PIPE0_LIMIT | DCMIPP_IT_PIPE0_OVR);

  }

  return HAL_OK;
}
