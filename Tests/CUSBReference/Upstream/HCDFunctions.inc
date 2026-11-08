// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USB, PCD and HCD operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_HCD_Init(HCD_HandleTypeDef *hhcd)
{
#if defined (USB_OTG_FS)
  const USB_OTG_GlobalTypeDef *USBx;
#endif /* defined (USB_OTG_FS) */

  /* Check the HCD handle allocation */
  if (hhcd == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_HCD_ALL_INSTANCE(hhcd->Instance));

#if defined (USB_OTG_FS)
  USBx = hhcd->Instance;
#endif /* defined (USB_OTG_FS) */

  if (hhcd->State == HAL_HCD_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    hhcd->Lock = HAL_UNLOCKED;

#if (USE_HAL_HCD_REGISTER_CALLBACKS == 1U)
    hhcd->SOFCallback = HAL_HCD_SOF_Callback;
    hhcd->ConnectCallback = HAL_HCD_Connect_Callback;
    hhcd->DisconnectCallback = HAL_HCD_Disconnect_Callback;
    hhcd->PortEnabledCallback = HAL_HCD_PortEnabled_Callback;
    hhcd->PortDisabledCallback = HAL_HCD_PortDisabled_Callback;
    hhcd->HC_NotifyURBChangeCallback = HAL_HCD_HC_NotifyURBChange_Callback;

    if (hhcd->MspInitCallback == NULL)
    {
      hhcd->MspInitCallback = HAL_HCD_MspInit;
    }

    /* Init the low level hardware */
    hhcd->MspInitCallback(hhcd);
#else
    /* Init the low level hardware : GPIO, CLOCK, NVIC... */
    HAL_HCD_MspInit(hhcd);
#endif /* (USE_HAL_HCD_REGISTER_CALLBACKS) */
  }

  hhcd->State = HAL_HCD_STATE_BUSY;

#if defined (USB_OTG_FS)
  /* Disable DMA mode for FS instance */
  if (USBx == USB_OTG_FS)
  {
    hhcd->Init.dma_enable = 0U;
  }
#endif /* defined (USB_OTG_FS) */

  /* Disable the Interrupts */
  __HAL_HCD_DISABLE(hhcd);

  /* Init the Core (common init.) */
  if (USB_CoreInit(hhcd->Instance, hhcd->Init) != HAL_OK)
  {
    hhcd->State = HAL_HCD_STATE_ERROR;
    return HAL_ERROR;
  }

  /* Force Host Mode */
  if (USB_SetCurrentMode(hhcd->Instance, USB_HOST_MODE) != HAL_OK)
  {
    hhcd->State = HAL_HCD_STATE_ERROR;
    return HAL_ERROR;
  }

  /* Init Host */
  if (USB_HostInit(hhcd->Instance, hhcd->Init) != HAL_OK)
  {
    hhcd->State = HAL_HCD_STATE_ERROR;
    return HAL_ERROR;
  }

  hhcd->State = HAL_HCD_STATE_READY;

  return HAL_OK;
}
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_HCD_HC_Init(HCD_HandleTypeDef *hhcd, uint8_t ch_num, uint8_t epnum,
                                  uint8_t dev_address, uint8_t speed, uint8_t ep_type, uint16_t mps)
{
  HAL_StatusTypeDef status;
  uint32_t HostCoreSpeed;
  uint32_t HCcharMps = mps;

  __HAL_LOCK(hhcd);
  hhcd->hc[ch_num].do_ping = 0U;
  hhcd->hc[ch_num].dev_addr = dev_address;
  hhcd->hc[ch_num].ch_num = ch_num;
  hhcd->hc[ch_num].ep_type = ep_type;
  hhcd->hc[ch_num].ep_num = epnum & 0x7FU;

  (void)HAL_HCD_HC_ClearHubInfo(hhcd, ch_num);

  if ((epnum & 0x80U) == 0x80U)
  {
    hhcd->hc[ch_num].ep_is_in = 1U;
  }
  else
  {
    hhcd->hc[ch_num].ep_is_in = 0U;
  }

  HostCoreSpeed = USB_GetHostSpeed(hhcd->Instance);

  if (ep_type == EP_TYPE_ISOC)
  {
    /* FS device plugged to HS HUB */
    if ((speed == HCD_DEVICE_SPEED_FULL) && (HostCoreSpeed == HPRT0_PRTSPD_HIGH_SPEED))
    {
      if (HCcharMps > ISO_SPLT_MPS)
      {
        /* ISO Max Packet Size for Split mode */
        HCcharMps = ISO_SPLT_MPS;
      }
    }
  }

  hhcd->hc[ch_num].speed = speed;
  hhcd->hc[ch_num].max_packet = (uint16_t)HCcharMps;

  status =  USB_HC_Init(hhcd->Instance, ch_num, epnum,
                        dev_address, speed, ep_type, (uint16_t)HCcharMps);

  __HAL_UNLOCK(hhcd);

  return status;
}
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_HCD_HC_Halt(HCD_HandleTypeDef *hhcd, uint8_t ch_num)
{
  HAL_StatusTypeDef status = HAL_OK;

  __HAL_LOCK(hhcd);
  (void)USB_HC_Halt(hhcd->Instance, ch_num);
  __HAL_UNLOCK(hhcd);

  return status;
}
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_HCD_DeInit(HCD_HandleTypeDef *hhcd)
{
  /* Check the HCD handle allocation */
  if (hhcd == NULL)
  {
    return HAL_ERROR;
  }

  hhcd->State = HAL_HCD_STATE_BUSY;

#if (USE_HAL_HCD_REGISTER_CALLBACKS == 1U)
  if (hhcd->MspDeInitCallback == NULL)
  {
    hhcd->MspDeInitCallback = HAL_HCD_MspDeInit; /* Legacy weak MspDeInit  */
  }

  /* DeInit the low level hardware */
  hhcd->MspDeInitCallback(hhcd);
#else
  /* DeInit the low level hardware: CLOCK, NVIC.*/
  HAL_HCD_MspDeInit(hhcd);
#endif /* USE_HAL_HCD_REGISTER_CALLBACKS */

  __HAL_HCD_DISABLE(hhcd);

  hhcd->State = HAL_HCD_STATE_RESET;

  return HAL_OK;
}
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_HCD_HC_SubmitRequest(HCD_HandleTypeDef *hhcd,
                                           uint8_t ch_num,
                                           uint8_t direction,
                                           uint8_t ep_type,
                                           uint8_t token,
                                           uint8_t *pbuff,
                                           uint16_t length,
                                           uint8_t do_ping)
{
  hhcd->hc[ch_num].ep_is_in = direction;
  hhcd->hc[ch_num].ep_type  = ep_type;

  if (token == 0U)
  {
    hhcd->hc[ch_num].data_pid = HC_PID_SETUP;
    hhcd->hc[ch_num].do_ping = do_ping;
  }
  else
  {
    hhcd->hc[ch_num].data_pid = HC_PID_DATA1;
  }

  /* Manage Data Toggle */
  switch (ep_type)
  {
    case EP_TYPE_CTRL:
      if (token == 1U) /* send data */
      {
        if (direction == 0U)
        {
          if (length == 0U)
          {
            /* For Status OUT stage, Length == 0U, Status Out PID = 1 */
            hhcd->hc[ch_num].toggle_out = 1U;
          }

          /* Set the Data Toggle bit as per the Flag */
          if (hhcd->hc[ch_num].toggle_out == 0U)
          {
            /* Put the PID 0 */
            hhcd->hc[ch_num].data_pid = HC_PID_DATA0;
          }
          else
          {
            /* Put the PID 1 */
            hhcd->hc[ch_num].data_pid = HC_PID_DATA1;
          }
        }
        else
        {
          if (hhcd->hc[ch_num].do_ssplit == 1U)
          {
            if (hhcd->hc[ch_num].toggle_in == 0U)
            {
              hhcd->hc[ch_num].data_pid = HC_PID_DATA0;
            }
            else
            {
              hhcd->hc[ch_num].data_pid = HC_PID_DATA1;
            }
          }
        }
      }
      break;

    case EP_TYPE_BULK:
      if (direction == 0U)
      {
        /* Set the Data Toggle bit as per the Flag */
        if (hhcd->hc[ch_num].toggle_out == 0U)
        {
          /* Put the PID 0 */
          hhcd->hc[ch_num].data_pid = HC_PID_DATA0;
        }
        else
        {
          /* Put the PID 1 */
          hhcd->hc[ch_num].data_pid = HC_PID_DATA1;
        }
      }
      else
      {
        if (hhcd->hc[ch_num].toggle_in == 0U)
        {
          hhcd->hc[ch_num].data_pid = HC_PID_DATA0;
        }
        else
        {
          hhcd->hc[ch_num].data_pid = HC_PID_DATA1;
        }
      }

      break;
    case EP_TYPE_INTR:
      if (direction == 0U)
      {
        /* Set the Data Toggle bit as per the Flag */
        if (hhcd->hc[ch_num].toggle_out == 0U)
        {
          /* Put the PID 0 */
          hhcd->hc[ch_num].data_pid = HC_PID_DATA0;
        }
        else
        {
          /* Put the PID 1 */
          hhcd->hc[ch_num].data_pid = HC_PID_DATA1;
        }
      }
      else
      {
        if (hhcd->hc[ch_num].toggle_in == 0U)
        {
          hhcd->hc[ch_num].data_pid = HC_PID_DATA0;
        }
        else
        {
          hhcd->hc[ch_num].data_pid = HC_PID_DATA1;
        }
      }
      break;

    case EP_TYPE_ISOC:
      hhcd->hc[ch_num].data_pid = HC_PID_DATA0;
      break;

    default:
      break;
  }

  hhcd->hc[ch_num].xfer_buff = pbuff;
  hhcd->hc[ch_num].xfer_len  = length;
  hhcd->hc[ch_num].urb_state = URB_IDLE;
  hhcd->hc[ch_num].xfer_count = 0U;
  hhcd->hc[ch_num].ch_num = ch_num;
  hhcd->hc[ch_num].state = HC_IDLE;

  return USB_HC_StartXfer(hhcd->Instance, &hhcd->hc[ch_num], (uint8_t)hhcd->Init.dma_enable);
}
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
void HAL_HCD_IRQHandler(HCD_HandleTypeDef *hhcd)
{
  USB_OTG_GlobalTypeDef *USBx = hhcd->Instance;
  uint32_t USBx_BASE = (uint32_t)USBx;
  uint32_t i;
  uint32_t interrupt;

  /* Ensure that we are in device mode */
  if (USB_GetMode(hhcd->Instance) == USB_OTG_MODE_HOST)
  {
    /* Avoid spurious interrupt */
    if (__HAL_HCD_IS_INVALID_INTERRUPT(hhcd))
    {
      return;
    }

    if (__HAL_HCD_GET_FLAG(hhcd, USB_OTG_GINTSTS_PXFR_INCOMPISOOUT))
    {
      /* Incorrect mode, acknowledge the interrupt */
      __HAL_HCD_CLEAR_FLAG(hhcd, USB_OTG_GINTSTS_PXFR_INCOMPISOOUT);
    }

    if (__HAL_HCD_GET_FLAG(hhcd, USB_OTG_GINTSTS_IISOIXFR))
    {
      /* Incorrect mode, acknowledge the interrupt */
      __HAL_HCD_CLEAR_FLAG(hhcd, USB_OTG_GINTSTS_IISOIXFR);
    }

    if (__HAL_HCD_GET_FLAG(hhcd, USB_OTG_GINTSTS_PTXFE))
    {
      /* Incorrect mode, acknowledge the interrupt */
      __HAL_HCD_CLEAR_FLAG(hhcd, USB_OTG_GINTSTS_PTXFE);
    }

    if (__HAL_HCD_GET_FLAG(hhcd, USB_OTG_GINTSTS_MMIS))
    {
      /* Incorrect mode, acknowledge the interrupt */
      __HAL_HCD_CLEAR_FLAG(hhcd, USB_OTG_GINTSTS_MMIS);
    }

    /* Handle Host Disconnect Interrupts */
    if (__HAL_HCD_GET_FLAG(hhcd, USB_OTG_GINTSTS_DISCINT))
    {
      __HAL_HCD_CLEAR_FLAG(hhcd, USB_OTG_GINTSTS_DISCINT);

      if ((USBx_HPRT0 & USB_OTG_HPRT_PCSTS) == 0U)
      {
        /* Flush USB Fifo */
        (void)USB_FlushTxFifo(USBx, 0x10U);
        (void)USB_FlushRxFifo(USBx);

        if (hhcd->Init.phy_itface == USB_OTG_EMBEDDED_PHY)
        {
          /* Restore FS Clock */
          (void)USB_InitFSLSPClkSel(hhcd->Instance, HCFG_48_MHZ);
        }

        /* Handle Host Port Disconnect Interrupt */
#if (USE_HAL_HCD_REGISTER_CALLBACKS == 1U)
        hhcd->DisconnectCallback(hhcd);
#else
        HAL_HCD_Disconnect_Callback(hhcd);
#endif /* USE_HAL_HCD_REGISTER_CALLBACKS */
      }
    }

    /* Handle Host Port Interrupts */
    if (__HAL_HCD_GET_FLAG(hhcd, USB_OTG_GINTSTS_HPRTINT))
    {
      HCD_Port_IRQHandler(hhcd);
    }

    /* Handle Host SOF Interrupt */
    if (__HAL_HCD_GET_FLAG(hhcd, USB_OTG_GINTSTS_SOF))
    {
#if (USE_HAL_HCD_REGISTER_CALLBACKS == 1U)
      hhcd->SOFCallback(hhcd);
#else
      HAL_HCD_SOF_Callback(hhcd);
#endif /* USE_HAL_HCD_REGISTER_CALLBACKS */

      __HAL_HCD_CLEAR_FLAG(hhcd, USB_OTG_GINTSTS_SOF);
    }

    /* Handle Host channel Interrupt */
    if (__HAL_HCD_GET_FLAG(hhcd, USB_OTG_GINTSTS_HCINT))
    {
      interrupt = USB_HC_ReadInterrupt(hhcd->Instance);
      for (i = 0U; i < hhcd->Init.Host_channels; i++)
      {
        if ((interrupt & (1UL << (i & 0xFU))) != 0U)
        {
          if ((USBx_HC(i)->HCCHAR & USB_OTG_HCCHAR_EPDIR) == USB_OTG_HCCHAR_EPDIR)
          {
            HCD_HC_IN_IRQHandler(hhcd, (uint8_t)i);
          }
          else
          {
            HCD_HC_OUT_IRQHandler(hhcd, (uint8_t)i);
          }
        }
      }
      __HAL_HCD_CLEAR_FLAG(hhcd, USB_OTG_GINTSTS_HCINT);
    }

    /* Handle Rx Queue Level Interrupts */
    if ((__HAL_HCD_GET_FLAG(hhcd, USB_OTG_GINTSTS_RXFLVL)) != 0U)
    {
      USB_MASK_INTERRUPT(hhcd->Instance, USB_OTG_GINTSTS_RXFLVL);

      HCD_RXQLVL_IRQHandler(hhcd);

      USB_UNMASK_INTERRUPT(hhcd->Instance, USB_OTG_GINTSTS_RXFLVL);
    }
  }
}
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if (USE_HAL_HCD_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_HCD_RegisterCallback(HCD_HandleTypeDef *hhcd,
                                           HAL_HCD_CallbackIDTypeDef CallbackID,
                                           pHCD_CallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hhcd->ErrorCode |= HAL_HCD_ERROR_INVALID_CALLBACK;
    return HAL_ERROR;
  }
  /* Process locked */
  __HAL_LOCK(hhcd);

  if (hhcd->State == HAL_HCD_STATE_READY)
  {
    switch (CallbackID)
    {
      case HAL_HCD_SOF_CB_ID :
        hhcd->SOFCallback = pCallback;
        break;

      case HAL_HCD_CONNECT_CB_ID :
        hhcd->ConnectCallback = pCallback;
        break;

      case HAL_HCD_DISCONNECT_CB_ID :
        hhcd->DisconnectCallback = pCallback;
        break;

      case HAL_HCD_PORT_ENABLED_CB_ID :
        hhcd->PortEnabledCallback = pCallback;
        break;

      case HAL_HCD_PORT_DISABLED_CB_ID :
        hhcd->PortDisabledCallback = pCallback;
        break;

      case HAL_HCD_MSPINIT_CB_ID :
        hhcd->MspInitCallback = pCallback;
        break;

      case HAL_HCD_MSPDEINIT_CB_ID :
        hhcd->MspDeInitCallback = pCallback;
        break;

      default :
        /* Update the error code */
        hhcd->ErrorCode |= HAL_HCD_ERROR_INVALID_CALLBACK;
        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (hhcd->State == HAL_HCD_STATE_RESET)
  {
    switch (CallbackID)
    {
      case HAL_HCD_MSPINIT_CB_ID :
        hhcd->MspInitCallback = pCallback;
        break;

      case HAL_HCD_MSPDEINIT_CB_ID :
        hhcd->MspDeInitCallback = pCallback;
        break;

      default :
        /* Update the error code */
        hhcd->ErrorCode |= HAL_HCD_ERROR_INVALID_CALLBACK;
        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hhcd->ErrorCode |= HAL_HCD_ERROR_INVALID_CALLBACK;
    /* Return error status */
    status =  HAL_ERROR;
  }

  /* Release Lock */
  __HAL_UNLOCK(hhcd);
  return status;
}
#endif
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if (USE_HAL_HCD_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_HCD_UnRegisterCallback(HCD_HandleTypeDef *hhcd, HAL_HCD_CallbackIDTypeDef CallbackID)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Process locked */
  __HAL_LOCK(hhcd);

  /* Setup Legacy weak Callbacks  */
  if (hhcd->State == HAL_HCD_STATE_READY)
  {
    switch (CallbackID)
    {
      case HAL_HCD_SOF_CB_ID :
        hhcd->SOFCallback = HAL_HCD_SOF_Callback;
        break;

      case HAL_HCD_CONNECT_CB_ID :
        hhcd->ConnectCallback = HAL_HCD_Connect_Callback;
        break;

      case HAL_HCD_DISCONNECT_CB_ID :
        hhcd->DisconnectCallback = HAL_HCD_Disconnect_Callback;
        break;

      case HAL_HCD_PORT_ENABLED_CB_ID :
        hhcd->PortEnabledCallback = HAL_HCD_PortEnabled_Callback;
        break;

      case HAL_HCD_PORT_DISABLED_CB_ID :
        hhcd->PortDisabledCallback = HAL_HCD_PortDisabled_Callback;
        break;

      case HAL_HCD_MSPINIT_CB_ID :
        hhcd->MspInitCallback = HAL_HCD_MspInit;
        break;

      case HAL_HCD_MSPDEINIT_CB_ID :
        hhcd->MspDeInitCallback = HAL_HCD_MspDeInit;
        break;

      default :
        /* Update the error code */
        hhcd->ErrorCode |= HAL_HCD_ERROR_INVALID_CALLBACK;

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (hhcd->State == HAL_HCD_STATE_RESET)
  {
    switch (CallbackID)
    {
      case HAL_HCD_MSPINIT_CB_ID :
        hhcd->MspInitCallback = HAL_HCD_MspInit;
        break;

      case HAL_HCD_MSPDEINIT_CB_ID :
        hhcd->MspDeInitCallback = HAL_HCD_MspDeInit;
        break;

      default :
        /* Update the error code */
        hhcd->ErrorCode |= HAL_HCD_ERROR_INVALID_CALLBACK;

        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hhcd->ErrorCode |= HAL_HCD_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  /* Release Lock */
  __HAL_UNLOCK(hhcd);
  return status;
}
#endif
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if (USE_HAL_HCD_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_HCD_RegisterHC_NotifyURBChangeCallback(HCD_HandleTypeDef *hhcd,
                                                             pHCD_HC_NotifyURBChangeCallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hhcd->ErrorCode |= HAL_HCD_ERROR_INVALID_CALLBACK;

    return HAL_ERROR;
  }

  /* Process locked */
  __HAL_LOCK(hhcd);

  if (hhcd->State == HAL_HCD_STATE_READY)
  {
    hhcd->HC_NotifyURBChangeCallback = pCallback;
  }
  else
  {
    /* Update the error code */
    hhcd->ErrorCode |= HAL_HCD_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  /* Release Lock */
  __HAL_UNLOCK(hhcd);

  return status;
}
#endif
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if (USE_HAL_HCD_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_HCD_UnRegisterHC_NotifyURBChangeCallback(HCD_HandleTypeDef *hhcd)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Process locked */
  __HAL_LOCK(hhcd);

  if (hhcd->State == HAL_HCD_STATE_READY)
  {
    hhcd->HC_NotifyURBChangeCallback = HAL_HCD_HC_NotifyURBChange_Callback; /* Legacy weak DataOutStageCallback  */
  }
  else
  {
    /* Update the error code */
    hhcd->ErrorCode |= HAL_HCD_ERROR_INVALID_CALLBACK;

    /* Return error status */
    status =  HAL_ERROR;
  }

  /* Release Lock */
  __HAL_UNLOCK(hhcd);

  return status;
}
#endif
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_HCD_Start(HCD_HandleTypeDef *hhcd)
{
  __HAL_LOCK(hhcd);
  /* Enable port power */
  (void)USB_DriveVbus(hhcd->Instance, 1U);

  /* Enable global interrupt */
  __HAL_HCD_ENABLE(hhcd);
  __HAL_UNLOCK(hhcd);

  return HAL_OK;
}
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_HCD_Stop(HCD_HandleTypeDef *hhcd)
{
  __HAL_LOCK(hhcd);
  (void)USB_StopHost(hhcd->Instance);
  __HAL_UNLOCK(hhcd);

  return HAL_OK;
}
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_HCD_ResetPort(HCD_HandleTypeDef *hhcd)
{
  return (USB_ResetPort(hhcd->Instance));
}
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HCD_StateTypeDef HAL_HCD_GetState(HCD_HandleTypeDef const *hhcd)
{
  return hhcd->State;
}
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HCD_URBStateTypeDef HAL_HCD_HC_GetURBState(HCD_HandleTypeDef const *hhcd, uint8_t chnum)
{
  return hhcd->hc[chnum].urb_state;
}
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
uint32_t HAL_HCD_HC_GetXferCount(HCD_HandleTypeDef const *hhcd, uint8_t chnum)
{
  return hhcd->hc[chnum].xfer_count;
}
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HCD_HCStateTypeDef  HAL_HCD_HC_GetState(HCD_HandleTypeDef const *hhcd, uint8_t chnum)
{
  return hhcd->hc[chnum].state;
}
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
uint32_t HAL_HCD_GetCurrentFrame(HCD_HandleTypeDef *hhcd)
{
  return (USB_GetCurrentFrame(hhcd->Instance));
}
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
uint32_t HAL_HCD_GetCurrentSpeed(HCD_HandleTypeDef *hhcd)
{
  return (USB_GetHostSpeed(hhcd->Instance));
}
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_HCD_HC_SetHubInfo(HCD_HandleTypeDef *hhcd, uint8_t ch_num,
                                        uint8_t addr, uint8_t PortNbr)
{
  uint32_t HostCoreSpeed = USB_GetHostSpeed(hhcd->Instance);

  /* LS/FS device plugged to HS HUB */
  if ((hhcd->hc[ch_num].speed != HCD_DEVICE_SPEED_HIGH) && (HostCoreSpeed == HPRT0_PRTSPD_HIGH_SPEED))
  {
    hhcd->hc[ch_num].do_ssplit = 1U;

    if ((hhcd->hc[ch_num].ep_type == EP_TYPE_CTRL) && (hhcd->hc[ch_num].ep_is_in != 0U))
    {
      hhcd->hc[ch_num].toggle_in = 1U;
    }
  }

  hhcd->hc[ch_num].hub_addr = addr;
  hhcd->hc[ch_num].hub_port_nbr = PortNbr;

  return HAL_OK;
}
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_HCD_HC_ClearHubInfo(HCD_HandleTypeDef *hhcd, uint8_t ch_num)
{
  hhcd->hc[ch_num].do_ssplit = 0U;
  hhcd->hc[ch_num].do_csplit = 0U;
  hhcd->hc[ch_num].hub_addr = 0U;
  hhcd->hc[ch_num].hub_port_nbr = 0U;

  return HAL_OK;
}
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_HCD_HC_Activate(HCD_HandleTypeDef *hhcd, uint8_t ch_num)
{
  HAL_StatusTypeDef status = HAL_OK;

  __HAL_LOCK(hhcd);
  (void)USB_HC_Activate(hhcd->Instance, (uint8_t)ch_num, hhcd->hc[ch_num].ch_dir);
  __HAL_UNLOCK(hhcd);

  return status;
}
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
static void HCD_HC_IN_IRQHandler(HCD_HandleTypeDef *hhcd, uint8_t chnum)
{
  const USB_OTG_GlobalTypeDef *USBx = hhcd->Instance;
  uint32_t USBx_BASE = (uint32_t)USBx;
  uint32_t tmpreg;

  if (__HAL_HCD_GET_CH_FLAG(hhcd, chnum, USB_OTG_HCINT_AHBERR))
  {
    __HAL_HCD_CLEAR_HC_INT(chnum, USB_OTG_HCINT_AHBERR);
    hhcd->hc[chnum].state = HC_XACTERR;
    (void)USB_HC_Halt(hhcd->Instance, chnum);
  }
  else if (__HAL_HCD_GET_CH_FLAG(hhcd, chnum, USB_OTG_HCINT_BBERR))
  {
    __HAL_HCD_CLEAR_HC_INT(chnum, USB_OTG_HCINT_BBERR);
    hhcd->hc[chnum].state = HC_BBLERR;
    (void)USB_HC_Halt(hhcd->Instance, chnum);
  }
  else if (__HAL_HCD_GET_CH_FLAG(hhcd, chnum, USB_OTG_HCINT_STALL))
  {
    __HAL_HCD_CLEAR_HC_INT(chnum, USB_OTG_HCINT_STALL);
    hhcd->hc[chnum].state = HC_STALL;
    (void)USB_HC_Halt(hhcd->Instance, chnum);
  }
  else if (__HAL_HCD_GET_CH_FLAG(hhcd, chnum, USB_OTG_HCINT_DTERR))
  {
    __HAL_HCD_CLEAR_HC_INT(chnum, USB_OTG_HCINT_DTERR);
    hhcd->hc[chnum].state = HC_DATATGLERR;
    (void)USB_HC_Halt(hhcd->Instance, chnum);
  }
  else if (__HAL_HCD_GET_CH_FLAG(hhcd, chnum, USB_OTG_HCINT_TXERR))
  {
    __HAL_HCD_CLEAR_HC_INT(chnum, USB_OTG_HCINT_TXERR);
    hhcd->hc[chnum].state = HC_XACTERR;
    (void)USB_HC_Halt(hhcd->Instance, chnum);
  }
  else
  {
    /* ... */
  }

  if (__HAL_HCD_GET_CH_FLAG(hhcd, chnum, USB_OTG_HCINT_FRMOR))
  {
    (void)USB_HC_Halt(hhcd->Instance, chnum);
    __HAL_HCD_CLEAR_HC_INT(chnum, USB_OTG_HCINT_FRMOR);
  }
  else if (__HAL_HCD_GET_CH_FLAG(hhcd, chnum, USB_OTG_HCINT_XFRC))
  {
    /* Clear any pending ACK IT */
    __HAL_HCD_CLEAR_HC_INT(chnum, USB_OTG_HCINT_ACK);

    if (hhcd->hc[chnum].do_csplit == 1U)
    {
      hhcd->hc[chnum].do_csplit = 0U;
      __HAL_HCD_CLEAR_HC_CSPLT(chnum);
    }

    if (hhcd->Init.dma_enable != 0U)
    {
      hhcd->hc[chnum].xfer_count = hhcd->hc[chnum].XferSize - (USBx_HC(chnum)->HCTSIZ & USB_OTG_HCTSIZ_XFRSIZ);
    }

    hhcd->hc[chnum].state = HC_XFRC;
    hhcd->hc[chnum].ErrCnt = 0U;
    __HAL_HCD_CLEAR_HC_INT(chnum, USB_OTG_HCINT_XFRC);

    if ((hhcd->hc[chnum].ep_type == EP_TYPE_CTRL) ||
        (hhcd->hc[chnum].ep_type == EP_TYPE_BULK))
    {
      (void)USB_HC_Halt(hhcd->Instance, chnum);
      __HAL_HCD_CLEAR_HC_INT(chnum, USB_OTG_HCINT_NAK);
    }
    else if ((hhcd->hc[chnum].ep_type == EP_TYPE_INTR) ||
             (hhcd->hc[chnum].ep_type == EP_TYPE_ISOC))
    {
      USBx_HC(chnum)->HCCHAR |= USB_OTG_HCCHAR_ODDFRM;
      hhcd->hc[chnum].urb_state = URB_DONE;

#if (USE_HAL_HCD_REGISTER_CALLBACKS == 1U)
      hhcd->HC_NotifyURBChangeCallback(hhcd, chnum, hhcd->hc[chnum].urb_state);
#else
      HAL_HCD_HC_NotifyURBChange_Callback(hhcd, chnum, hhcd->hc[chnum].urb_state);
#endif /* USE_HAL_HCD_REGISTER_CALLBACKS */
    }
    else
    {
      /* ... */
    }

    if (hhcd->Init.dma_enable == 1U)
    {
      if ((((hhcd->hc[chnum].xfer_count + hhcd->hc[chnum].max_packet - 1U) / hhcd->hc[chnum].max_packet) & 1U) != 0U)
      {
        hhcd->hc[chnum].toggle_in ^= 1U;
      }
    }
    else
    {
      hhcd->hc[chnum].toggle_in ^= 1U;
    }
  }
  else if (__HAL_HCD_GET_CH_FLAG(hhcd, chnum, USB_OTG_HCINT_ACK))
  {
    __HAL_HCD_CLEAR_HC_INT(chnum, USB_OTG_HCINT_ACK);

    hhcd->hc[chnum].NakCnt = 0U;

    if (hhcd->hc[chnum].do_ssplit == 1U)
    {
      hhcd->hc[chnum].do_csplit = 1U;
      hhcd->hc[chnum].state = HC_ACK;

      (void)USB_HC_Halt(hhcd->Instance, chnum);
    }
  }
  else if (__HAL_HCD_GET_CH_FLAG(hhcd, chnum, USB_OTG_HCINT_CHH))
  {
    __HAL_HCD_CLEAR_HC_INT(chnum, USB_OTG_HCINT_CHH);

    tmpreg = USBx_HC(chnum)->HCCHAR;

    if ((tmpreg & USB_OTG_HCCHAR_CHDIS) != 0U)
    {
      /* Halt received while channel disable still in progress */
      return;
    }

    if (hhcd->hc[chnum].state == HC_XFRC)
    {
      hhcd->hc[chnum].state = HC_HALTED;
      hhcd->hc[chnum].urb_state = URB_DONE;
    }
    else if (hhcd->hc[chnum].state == HC_STALL)
    {
      hhcd->hc[chnum].state = HC_HALTED;
      hhcd->hc[chnum].urb_state = URB_STALL;
    }
    else if ((hhcd->hc[chnum].state == HC_XACTERR) ||
             (hhcd->hc[chnum].state == HC_DATATGLERR))
    {
      hhcd->hc[chnum].state = HC_HALTED;

      if (hhcd->Init.dma_enable == 0U)
      {
        hhcd->hc[chnum].ErrCnt++;

        if (hhcd->hc[chnum].ErrCnt > 2U)
        {
          hhcd->hc[chnum].ErrCnt = 0U;

          if (hhcd->hc[chnum].do_ssplit == 1U)
          {
            hhcd->hc[chnum].do_csplit = 0U;
            hhcd->hc[chnum].ep_ss_schedule = 0U;
            __HAL_HCD_CLEAR_HC_CSPLT(chnum);
          }

          hhcd->hc[chnum].urb_state = URB_ERROR;
        }
        else
        {
          hhcd->hc[chnum].urb_state = URB_NOTREADY;

          if ((hhcd->hc[chnum].ep_type == EP_TYPE_CTRL) ||
              (hhcd->hc[chnum].ep_type == EP_TYPE_BULK))
          {
            /* re-activate the channel */
            tmpreg = USBx_HC(chnum)->HCCHAR;
            tmpreg &= ~USB_OTG_HCCHAR_CHDIS;
            tmpreg |= USB_OTG_HCCHAR_CHENA;
            USBx_HC(chnum)->HCCHAR = tmpreg;
          }
        }
      }
      else
      {
        hhcd->hc[chnum].urb_state = URB_NOTREADY;

        if ((hhcd->hc[chnum].ep_type == EP_TYPE_CTRL) ||
            (hhcd->hc[chnum].ep_type == EP_TYPE_BULK))
        {
          /* re-activate the channel */
          tmpreg = USBx_HC(chnum)->HCCHAR;
          tmpreg &= ~USB_OTG_HCCHAR_CHDIS;
          tmpreg |= USB_OTG_HCCHAR_CHENA;
          USBx_HC(chnum)->HCCHAR = tmpreg;
        }
      }
    }
    else if (hhcd->hc[chnum].state == HC_NYET)
    {
      hhcd->hc[chnum].state = HC_HALTED;

      if (hhcd->hc[chnum].do_csplit == 1U)
      {
        if (hhcd->hc[chnum].ep_type == EP_TYPE_INTR)
        {
          hhcd->hc[chnum].NyetErrCnt++;
          if (hhcd->hc[chnum].NyetErrCnt > 2U)
          {
            hhcd->hc[chnum].NyetErrCnt = 0U;
            hhcd->hc[chnum].do_csplit = 0U;

            if (hhcd->hc[chnum].ErrCnt < 3U)
            {
              hhcd->hc[chnum].ep_ss_schedule = 1U;
            }
            __HAL_HCD_CLEAR_HC_CSPLT(chnum);
            hhcd->hc[chnum].urb_state = URB_ERROR;
          }
          else
          {
            hhcd->hc[chnum].urb_state = URB_NOTREADY;
          }
        }
        else
        {
          hhcd->hc[chnum].urb_state = URB_NOTREADY;
        }

        if ((hhcd->hc[chnum].ep_type == EP_TYPE_CTRL) ||
            (hhcd->hc[chnum].ep_type == EP_TYPE_BULK))
        {
          /* re-activate the channel */
          tmpreg = USBx_HC(chnum)->HCCHAR;
          tmpreg &= ~USB_OTG_HCCHAR_CHDIS;
          tmpreg |= USB_OTG_HCCHAR_CHENA;
          USBx_HC(chnum)->HCCHAR = tmpreg;
        }
      }
    }
    else if (hhcd->hc[chnum].state == HC_ACK)
    {
      hhcd->hc[chnum].state = HC_HALTED;

      if (hhcd->hc[chnum].do_csplit == 1U)
      {
        hhcd->hc[chnum].urb_state = URB_NOTREADY;

        /* Set Complete split and re-activate the channel */
        USBx_HC(chnum)->HCSPLT |= USB_OTG_HCSPLT_COMPLSPLT;
        USBx_HC(chnum)->HCINTMSK |= USB_OTG_HCINTMSK_NYET;
        USBx_HC(chnum)->HCINTMSK &= ~USB_OTG_HCINT_ACK;

        if ((hhcd->hc[chnum].ep_type == EP_TYPE_CTRL) ||
            (hhcd->hc[chnum].ep_type == EP_TYPE_BULK))
        {
          /* re-activate the channel */
          tmpreg = USBx_HC(chnum)->HCCHAR;
          tmpreg &= ~USB_OTG_HCCHAR_CHDIS;
          tmpreg |= USB_OTG_HCCHAR_CHENA;
          USBx_HC(chnum)->HCCHAR = tmpreg;
        }
      }
    }
    else if (hhcd->hc[chnum].state == HC_NAK)
    {
      hhcd->hc[chnum].state = HC_HALTED;
      hhcd->hc[chnum].urb_state = URB_NOTREADY;

      if ((hhcd->hc[chnum].ep_type == EP_TYPE_CTRL) ||
          (hhcd->hc[chnum].ep_type == EP_TYPE_BULK))
      {
#if defined (USE_HAL_HCD_IN_NAK_AUTO_ACTIVATE_DISABLE) && (USE_HAL_HCD_IN_NAK_AUTO_ACTIVATE_DISABLE == 1)
        hhcd->hc[chnum].NakCnt++;

        if (hhcd->hc[chnum].NakCnt >= HAL_HCD_CHANNEL_NAK_COUNT)
        {
          hhcd->hc[chnum].state = HC_IDLE;
          hhcd->hc[chnum].urb_state = URB_NAK_WAIT;
          hhcd->hc[chnum].NakCnt = 0U;
        }
        else
#endif /* defined (USE_HAL_HCD_IN_NAK_AUTO_ACTIVATE_DISABLE) && (USE_HAL_HCD_IN_NAK_AUTO_ACTIVATE_DISABLE == 1) */
        {
          /* re-activate the channel */
          tmpreg = USBx_HC(chnum)->HCCHAR;
          tmpreg &= ~USB_OTG_HCCHAR_CHDIS;
          tmpreg |= USB_OTG_HCCHAR_CHENA;
          USBx_HC(chnum)->HCCHAR = tmpreg;
        }
      }
    }
    else if (hhcd->hc[chnum].state == HC_BBLERR)
    {
      hhcd->hc[chnum].state = HC_HALTED;
      hhcd->hc[chnum].ErrCnt++;
      hhcd->hc[chnum].urb_state = URB_ERROR;
    }
    else
    {
      if (hhcd->hc[chnum].state == HC_HALTED)
      {
        return;
      }
    }

#if (USE_HAL_HCD_REGISTER_CALLBACKS == 1U)
    hhcd->HC_NotifyURBChangeCallback(hhcd, chnum, hhcd->hc[chnum].urb_state);
#else
    HAL_HCD_HC_NotifyURBChange_Callback(hhcd, chnum, hhcd->hc[chnum].urb_state);
#endif /* USE_HAL_HCD_REGISTER_CALLBACKS */
  }
  else if (__HAL_HCD_GET_CH_FLAG(hhcd, chnum, USB_OTG_HCINT_NYET))
  {
    __HAL_HCD_CLEAR_HC_INT(chnum, USB_OTG_HCINT_NYET);
    hhcd->hc[chnum].state = HC_NYET;

    if (hhcd->hc[chnum].do_ssplit == 0U)
    {
      hhcd->hc[chnum].ErrCnt = 0U;
    }

    (void)USB_HC_Halt(hhcd->Instance, chnum);
  }
  else if (__HAL_HCD_GET_CH_FLAG(hhcd, chnum, USB_OTG_HCINT_NAK))
  {
    if (hhcd->hc[chnum].ep_type == EP_TYPE_INTR)
    {
      hhcd->hc[chnum].ErrCnt = 0U;
      hhcd->hc[chnum].state = HC_NAK;
      (void)USB_HC_Halt(hhcd->Instance, chnum);
    }
    else if ((hhcd->hc[chnum].ep_type == EP_TYPE_CTRL) ||
             (hhcd->hc[chnum].ep_type == EP_TYPE_BULK))
    {
      hhcd->hc[chnum].ErrCnt = 0U;

      if ((hhcd->Init.dma_enable == 0U) || (hhcd->hc[chnum].do_csplit == 1U))
      {
        hhcd->hc[chnum].state = HC_NAK;
        (void)USB_HC_Halt(hhcd->Instance, chnum);
      }
    }
    else
    {
      /* ... */
    }

    if (hhcd->hc[chnum].do_csplit == 1U)
    {
      hhcd->hc[chnum].do_csplit = 0U;
      __HAL_HCD_CLEAR_HC_CSPLT(chnum);
      __HAL_HCD_UNMASK_ACK_HC_INT(chnum);
    }

    __HAL_HCD_CLEAR_HC_INT(chnum, USB_OTG_HCINT_NAK);
  }
  else
  {
    /* ... */
  }
}
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
static void HCD_HC_OUT_IRQHandler(HCD_HandleTypeDef *hhcd, uint8_t chnum)
{
  const USB_OTG_GlobalTypeDef *USBx = hhcd->Instance;
  uint32_t USBx_BASE = (uint32_t)USBx;
  uint32_t tmpreg;
  uint32_t num_packets;

  if (__HAL_HCD_GET_CH_FLAG(hhcd, chnum, USB_OTG_HCINT_AHBERR))
  {
    __HAL_HCD_CLEAR_HC_INT(chnum, USB_OTG_HCINT_AHBERR);
    hhcd->hc[chnum].state = HC_XACTERR;
    (void)USB_HC_Halt(hhcd->Instance, chnum);
  }
  else if (__HAL_HCD_GET_CH_FLAG(hhcd, chnum, USB_OTG_HCINT_ACK))
  {
    __HAL_HCD_CLEAR_HC_INT(chnum, USB_OTG_HCINT_ACK);

    if (hhcd->hc[chnum].do_ping == 1U)
    {
      hhcd->hc[chnum].do_ping = 0U;
      hhcd->hc[chnum].urb_state = URB_NOTREADY;
      hhcd->hc[chnum].state = HC_ACK;
      (void)USB_HC_Halt(hhcd->Instance, chnum);
    }

    if ((hhcd->hc[chnum].do_ssplit == 1U) && (hhcd->hc[chnum].do_csplit == 0U))
    {
      if (hhcd->hc[chnum].ep_type != EP_TYPE_ISOC)
      {
        hhcd->hc[chnum].do_csplit = 1U;
      }

      hhcd->hc[chnum].state = HC_ACK;
      (void)USB_HC_Halt(hhcd->Instance, chnum);

      /* reset error_count */
      hhcd->hc[chnum].ErrCnt = 0U;
    }
  }
  else if (__HAL_HCD_GET_CH_FLAG(hhcd, chnum, USB_OTG_HCINT_FRMOR))
  {
    __HAL_HCD_CLEAR_HC_INT(chnum, USB_OTG_HCINT_FRMOR);
    (void)USB_HC_Halt(hhcd->Instance, chnum);
  }
  else if (__HAL_HCD_GET_CH_FLAG(hhcd, chnum, USB_OTG_HCINT_XFRC))
  {
    hhcd->hc[chnum].ErrCnt = 0U;

    /* transaction completed with NYET state, update do ping state */
    if (__HAL_HCD_GET_CH_FLAG(hhcd, chnum, USB_OTG_HCINT_NYET))
    {
      hhcd->hc[chnum].do_ping = 1U;
      __HAL_HCD_CLEAR_HC_INT(chnum, USB_OTG_HCINT_NYET);
    }

    if (hhcd->hc[chnum].do_csplit != 0U)
    {
      hhcd->hc[chnum].do_csplit = 0U;
      __HAL_HCD_CLEAR_HC_CSPLT(chnum);
    }

    __HAL_HCD_CLEAR_HC_INT(chnum, USB_OTG_HCINT_XFRC);
    hhcd->hc[chnum].state = HC_XFRC;
    (void)USB_HC_Halt(hhcd->Instance, chnum);
  }
  else if (__HAL_HCD_GET_CH_FLAG(hhcd, chnum, USB_OTG_HCINT_NYET))
  {
    hhcd->hc[chnum].state = HC_NYET;

    if (hhcd->hc[chnum].do_ssplit == 0U)
    {
      hhcd->hc[chnum].do_ping = 1U;
    }

    hhcd->hc[chnum].ErrCnt = 0U;
    (void)USB_HC_Halt(hhcd->Instance, chnum);
    __HAL_HCD_CLEAR_HC_INT(chnum, USB_OTG_HCINT_NYET);
  }
  else if (__HAL_HCD_GET_CH_FLAG(hhcd, chnum, USB_OTG_HCINT_STALL))
  {
    __HAL_HCD_CLEAR_HC_INT(chnum, USB_OTG_HCINT_STALL);
    hhcd->hc[chnum].state = HC_STALL;
    (void)USB_HC_Halt(hhcd->Instance, chnum);
  }
  else if (__HAL_HCD_GET_CH_FLAG(hhcd, chnum, USB_OTG_HCINT_NAK))
  {
    hhcd->hc[chnum].ErrCnt = 0U;
    hhcd->hc[chnum].state = HC_NAK;

    if (hhcd->hc[chnum].do_ping == 0U)
    {
      if (hhcd->hc[chnum].speed == HCD_DEVICE_SPEED_HIGH)
      {
        hhcd->hc[chnum].do_ping = 1U;
      }
    }

    (void)USB_HC_Halt(hhcd->Instance, chnum);
    __HAL_HCD_CLEAR_HC_INT(chnum, USB_OTG_HCINT_NAK);
  }
  else if (__HAL_HCD_GET_CH_FLAG(hhcd, chnum, USB_OTG_HCINT_TXERR))
  {
    if (hhcd->Init.dma_enable == 0U)
    {
      hhcd->hc[chnum].state = HC_XACTERR;
      (void)USB_HC_Halt(hhcd->Instance, chnum);
    }
    else
    {
      hhcd->hc[chnum].ErrCnt++;
      if (hhcd->hc[chnum].ErrCnt > 2U)
      {
        hhcd->hc[chnum].ErrCnt = 0U;
        hhcd->hc[chnum].urb_state = URB_ERROR;

#if (USE_HAL_HCD_REGISTER_CALLBACKS == 1U)
        hhcd->HC_NotifyURBChangeCallback(hhcd, chnum, hhcd->hc[chnum].urb_state);
#else
        HAL_HCD_HC_NotifyURBChange_Callback(hhcd, chnum, hhcd->hc[chnum].urb_state);
#endif /* USE_HAL_HCD_REGISTER_CALLBACKS */
      }
      else
      {
        hhcd->hc[chnum].urb_state = URB_NOTREADY;

        /* Re-activate the channel  */
        tmpreg = USBx_HC(chnum)->HCCHAR;
        tmpreg &= ~USB_OTG_HCCHAR_CHDIS;
        tmpreg |= USB_OTG_HCCHAR_CHENA;
        USBx_HC(chnum)->HCCHAR = tmpreg;
      }
    }
    __HAL_HCD_CLEAR_HC_INT(chnum, USB_OTG_HCINT_TXERR);
  }
  else if (__HAL_HCD_GET_CH_FLAG(hhcd, chnum, USB_OTG_HCINT_DTERR))
  {
    hhcd->hc[chnum].state = HC_DATATGLERR;
    (void)USB_HC_Halt(hhcd->Instance, chnum);
    __HAL_HCD_CLEAR_HC_INT(chnum, USB_OTG_HCINT_DTERR);
  }
  else if (__HAL_HCD_GET_CH_FLAG(hhcd, chnum, USB_OTG_HCINT_CHH))
  {
    __HAL_HCD_CLEAR_HC_INT(chnum, USB_OTG_HCINT_CHH);

    if (hhcd->hc[chnum].state == HC_XFRC)
    {
      hhcd->hc[chnum].state = HC_HALTED;
      hhcd->hc[chnum].urb_state = URB_DONE;

      if (hhcd->hc[chnum].ep_type != EP_TYPE_ISOC)
      {
        if (hhcd->Init.dma_enable == 0U)
        {
          hhcd->hc[chnum].toggle_out ^= 1U;
        }

        if ((hhcd->Init.dma_enable == 1U) && (hhcd->hc[chnum].xfer_len > 0U))
        {
          num_packets = (hhcd->hc[chnum].xfer_len + hhcd->hc[chnum].max_packet - 1U) / hhcd->hc[chnum].max_packet;

          if ((num_packets & 1U) != 0U)
          {
            hhcd->hc[chnum].toggle_out ^= 1U;
          }
        }
      }
    }
    else if (hhcd->hc[chnum].state == HC_ACK)
    {
      hhcd->hc[chnum].state = HC_HALTED;

      if (hhcd->hc[chnum].do_csplit == 1U)
      {
        hhcd->hc[chnum].urb_state = URB_NOTREADY;
      }
    }
    else if (hhcd->hc[chnum].state == HC_NAK)
    {
      hhcd->hc[chnum].state = HC_HALTED;
      hhcd->hc[chnum].urb_state = URB_NOTREADY;

      if (hhcd->hc[chnum].do_csplit == 1U)
      {
        hhcd->hc[chnum].do_csplit = 0U;
        __HAL_HCD_CLEAR_HC_CSPLT(chnum);
      }
    }
    else if (hhcd->hc[chnum].state == HC_NYET)
    {
      hhcd->hc[chnum].state = HC_HALTED;
      hhcd->hc[chnum].urb_state  = URB_NOTREADY;
    }
    else if (hhcd->hc[chnum].state == HC_STALL)
    {
      hhcd->hc[chnum].state = HC_HALTED;
      hhcd->hc[chnum].urb_state  = URB_STALL;
    }
    else if ((hhcd->hc[chnum].state == HC_XACTERR) ||
             (hhcd->hc[chnum].state == HC_DATATGLERR))
    {
      hhcd->hc[chnum].state = HC_HALTED;
      hhcd->hc[chnum].ErrCnt++;
      if (hhcd->hc[chnum].ErrCnt > 2U)
      {
        hhcd->hc[chnum].ErrCnt = 0U;
        hhcd->hc[chnum].urb_state = URB_ERROR;
      }
      else
      {
        hhcd->hc[chnum].urb_state = URB_NOTREADY;

        /* re-activate the channel  */
        tmpreg = USBx_HC(chnum)->HCCHAR;
        tmpreg &= ~USB_OTG_HCCHAR_CHDIS;
        tmpreg |= USB_OTG_HCCHAR_CHENA;
        USBx_HC(chnum)->HCCHAR = tmpreg;
      }
    }
    else
    {
      return;
    }

#if (USE_HAL_HCD_REGISTER_CALLBACKS == 1U)
    hhcd->HC_NotifyURBChangeCallback(hhcd, chnum, hhcd->hc[chnum].urb_state);
#else
    HAL_HCD_HC_NotifyURBChange_Callback(hhcd, chnum, hhcd->hc[chnum].urb_state);
#endif /* USE_HAL_HCD_REGISTER_CALLBACKS */
  }
  else
  {
    return;
  }
}
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
static void HCD_RXQLVL_IRQHandler(HCD_HandleTypeDef *hhcd)
{
  const USB_OTG_GlobalTypeDef *USBx = hhcd->Instance;
  uint32_t USBx_BASE = (uint32_t)USBx;
  uint32_t pktsts;
  uint32_t pktcnt;
  uint32_t GrxstspReg;
  uint32_t xferSizePktCnt;
  uint32_t tmpreg;
  uint32_t chnum;

  GrxstspReg = hhcd->Instance->GRXSTSP;
  chnum = GrxstspReg & USB_OTG_GRXSTSP_EPNUM;
  pktsts = (GrxstspReg & USB_OTG_GRXSTSP_PKTSTS) >> 17;
  pktcnt = (GrxstspReg & USB_OTG_GRXSTSP_BCNT) >> 4;

  switch (pktsts)
  {
    case GRXSTS_PKTSTS_IN:
      /* Read the data into the host buffer. */
      if ((pktcnt > 0U) && (hhcd->hc[chnum].xfer_buff != (void *)0))
      {
        if ((hhcd->hc[chnum].xfer_count + pktcnt) <= hhcd->hc[chnum].xfer_len)
        {
          (void)USB_ReadPacket(hhcd->Instance,
                               hhcd->hc[chnum].xfer_buff, (uint16_t)pktcnt);

          /* manage multiple Xfer */
          hhcd->hc[chnum].xfer_buff += pktcnt;
          hhcd->hc[chnum].xfer_count += pktcnt;

          /* get transfer size packet count */
          xferSizePktCnt = (USBx_HC(chnum)->HCTSIZ & USB_OTG_HCTSIZ_PKTCNT) >> 19;

          if ((hhcd->hc[chnum].max_packet == pktcnt) && (xferSizePktCnt > 0U))
          {
            /* re-activate the channel when more packets are expected */
            tmpreg = USBx_HC(chnum)->HCCHAR;
            tmpreg &= ~USB_OTG_HCCHAR_CHDIS;
            tmpreg |= USB_OTG_HCCHAR_CHENA;
            USBx_HC(chnum)->HCCHAR = tmpreg;
            hhcd->hc[chnum].toggle_in ^= 1U;
          }
        }
        else
        {
          hhcd->hc[chnum].urb_state = URB_ERROR;
        }
      }
      break;

    case GRXSTS_PKTSTS_DATA_TOGGLE_ERR:
      break;

    case GRXSTS_PKTSTS_IN_XFER_COMP:
    case GRXSTS_PKTSTS_CH_HALTED:
    default:
      break;
  }
}
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
static void HCD_Port_IRQHandler(HCD_HandleTypeDef *hhcd)
{
  const USB_OTG_GlobalTypeDef *USBx = hhcd->Instance;
  uint32_t USBx_BASE = (uint32_t)USBx;
  __IO uint32_t hprt0;
  __IO uint32_t hprt0_dup;

  /* Handle Host Port Interrupts */
  hprt0 = USBx_HPRT0;
  hprt0_dup = USBx_HPRT0;

  hprt0_dup &= ~(USB_OTG_HPRT_PENA | USB_OTG_HPRT_PCDET | \
                 USB_OTG_HPRT_PENCHNG | USB_OTG_HPRT_POCCHNG);

  /* Check whether Port Connect detected */
  if ((hprt0 & USB_OTG_HPRT_PCDET) == USB_OTG_HPRT_PCDET)
  {
    if ((hprt0 & USB_OTG_HPRT_PCSTS) == USB_OTG_HPRT_PCSTS)
    {
#if (USE_HAL_HCD_REGISTER_CALLBACKS == 1U)
      hhcd->ConnectCallback(hhcd);
#else
      HAL_HCD_Connect_Callback(hhcd);
#endif /* USE_HAL_HCD_REGISTER_CALLBACKS */
    }
    hprt0_dup |= USB_OTG_HPRT_PCDET;
  }

  /* Check whether Port Enable Changed */
  if ((hprt0 & USB_OTG_HPRT_PENCHNG) == USB_OTG_HPRT_PENCHNG)
  {
    hprt0_dup |= USB_OTG_HPRT_PENCHNG;

    if ((hprt0 & USB_OTG_HPRT_PENA) == USB_OTG_HPRT_PENA)
    {
      if (hhcd->Init.phy_itface == USB_OTG_EMBEDDED_PHY)
      {
        if ((hprt0 & USB_OTG_HPRT_PSPD) == (HPRT0_PRTSPD_LOW_SPEED << 17))
        {
          (void)USB_InitFSLSPClkSel(hhcd->Instance, HCFG_6_MHZ);
        }
        else
        {
          (void)USB_InitFSLSPClkSel(hhcd->Instance, HCFG_48_MHZ);
        }
      }
      else
      {
        if (hhcd->Init.speed == HCD_SPEED_FULL)
        {
          USBx_HOST->HFIR = HFIR_60_MHZ;
        }
      }
#if (USE_HAL_HCD_REGISTER_CALLBACKS == 1U)
      hhcd->PortEnabledCallback(hhcd);
#else
      HAL_HCD_PortEnabled_Callback(hhcd);
#endif /* USE_HAL_HCD_REGISTER_CALLBACKS */

    }
    else
    {
#if (USE_HAL_HCD_REGISTER_CALLBACKS == 1U)
      hhcd->PortDisabledCallback(hhcd);
#else
      HAL_HCD_PortDisabled_Callback(hhcd);
#endif /* USE_HAL_HCD_REGISTER_CALLBACKS */
    }
  }

  /* Check for an overcurrent */
  if ((hprt0 & USB_OTG_HPRT_POCCHNG) == USB_OTG_HPRT_POCCHNG)
  {
    hprt0_dup |= USB_OTG_HPRT_POCCHNG;
  }

  /* Clear Port Interrupts */
  USBx_HPRT0 = hprt0_dup;
}
#endif
#endif
