/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * STM32H7RS HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
/* Only the two local address temporaries in ReadReg/WriteReg are widened
 * to uintptr_t for native 64-bit host pointers. Their operations are unchanged. */
HAL_StatusTypeDef HAL_MDIOS_Init(MDIOS_HandleTypeDef *hmdios)
{
  uint32_t tmpcr;

  /* Check the MDIOS handle allocation */
  if (hmdios == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_MDIOS_ALL_INSTANCE(hmdios->Instance));
  assert_param(IS_MDIOS_PORTADDRESS(hmdios->Init.PortAddress));
  assert_param(IS_MDIOS_PREAMBLECHECK(hmdios->Init.PreambleCheck));

#if (USE_HAL_MDIOS_REGISTER_CALLBACKS == 1)

  if (hmdios->State == HAL_MDIOS_STATE_RESET)
  {
    MDIOS_InitCallbacksToDefault(hmdios);

    if (hmdios->MspInitCallback == NULL)
    {
      hmdios->MspInitCallback = HAL_MDIOS_MspInit;
    }

    /* Init the low level hardware */
    hmdios->MspInitCallback(hmdios);
  }

#else

  if (hmdios->State == HAL_MDIOS_STATE_RESET)
  {
    /* Init the low level hardware */
    HAL_MDIOS_MspInit(hmdios);
  }

#endif /* (USE_HAL_MDIOS_REGISTER_CALLBACKS) */

  /* Change the MDIOS state */
  hmdios->State = HAL_MDIOS_STATE_BUSY;

  /* Get the MDIOS CR value */
  tmpcr = hmdios->Instance->CR;

  /* Clear PORT_ADDRESS, DPC and EN bits */
  tmpcr &= ((uint32_t)~(MDIOS_CR_EN | MDIOS_CR_DPC | MDIOS_CR_PORT_ADDRESS));

  /* Set MDIOS control parameters and enable the peripheral */
  tmpcr |= (uint32_t)(((hmdios->Init.PortAddress) << MDIOS_PORT_ADDRESS_SHIFT)    | \
                      (hmdios->Init.PreambleCheck) | \
                      (MDIOS_CR_EN));

  /* Write the MDIOS CR */
  hmdios->Instance->CR = tmpcr;

  hmdios->ErrorCode = HAL_MDIOS_ERROR_NONE;

  /* Change the MDIOS state */
  hmdios->State = HAL_MDIOS_STATE_READY;

  /* Release Lock */
  __HAL_UNLOCK(hmdios);

  /* Return function status */
  return HAL_OK;

}
HAL_StatusTypeDef HAL_MDIOS_DeInit(MDIOS_HandleTypeDef *hmdios)
{
  /* Check the MDIOS handle allocation */
  if (hmdios == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_MDIOS_ALL_INSTANCE(hmdios->Instance));

  /* Change the MDIOS state */
  hmdios->State = HAL_MDIOS_STATE_BUSY;

  /* Disable the Peripheral */
  __HAL_MDIOS_DISABLE(hmdios);

#if (USE_HAL_MDIOS_REGISTER_CALLBACKS == 1)

  if (hmdios->MspDeInitCallback == NULL)
  {
    hmdios->MspDeInitCallback = HAL_MDIOS_MspDeInit;
  }
  /* DeInit the low level hardware */
  hmdios->MspDeInitCallback(hmdios);
#else

  /* DeInit the low level hardware */
  HAL_MDIOS_MspDeInit(hmdios);

#endif /* (USE_HAL_MDIOS_REGISTER_CALLBACKS) */

  /* Change the MDIOS state */
  hmdios->State = HAL_MDIOS_STATE_RESET;

  /* Release Lock */
  __HAL_UNLOCK(hmdios);

  /* Return function status */
  return HAL_OK;
}
#if SC_MODE
HAL_StatusTypeDef HAL_MDIOS_RegisterCallback(MDIOS_HandleTypeDef *hmdios, HAL_MDIOS_CallbackIDTypeDef CallbackID,
                                             pMDIOS_CallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hmdios->ErrorCode |= HAL_MDIOS_ERROR_INVALID_CALLBACK;

    return HAL_ERROR;
  }
  /* Process locked */
  __HAL_LOCK(hmdios);

  if (hmdios->State == HAL_MDIOS_STATE_READY)
  {
    switch (CallbackID)
    {
      case HAL_MDIOS_WRITE_COMPLETE_CB_ID :
        hmdios->WriteCpltCallback = pCallback;
        break;

      case HAL_MDIOS_READ_COMPLETE_CB_ID :
        hmdios->ReadCpltCallback = pCallback;
        break;

      case HAL_MDIOS_ERROR_CB_ID :
        hmdios->ErrorCallback = pCallback;
        break;

      case HAL_MDIOS_WAKEUP_CB_ID :
        hmdios->WakeUpCallback = pCallback;
        break;

      case HAL_MDIOS_MSPINIT_CB_ID :
        hmdios->MspInitCallback = pCallback;
        break;

      case HAL_MDIOS_MSPDEINIT_CB_ID :
        hmdios->MspDeInitCallback = pCallback;
        break;

      default :
        /* Update the error code */
        hmdios->ErrorCode |= HAL_MDIOS_ERROR_INVALID_CALLBACK;
        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (hmdios->State == HAL_MDIOS_STATE_RESET)
  {
    switch (CallbackID)
    {
      case HAL_MDIOS_MSPINIT_CB_ID :
        hmdios->MspInitCallback = pCallback;
        break;

      case HAL_MDIOS_MSPDEINIT_CB_ID :
        hmdios->MspDeInitCallback = pCallback;
        break;

      default :
        /* Update the error code */
        hmdios->ErrorCode |= HAL_MDIOS_ERROR_INVALID_CALLBACK;
        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hmdios->ErrorCode |= HAL_MDIOS_ERROR_INVALID_CALLBACK;
    /* Return error status */
    status =  HAL_ERROR;
  }

  /* Release Lock */
  __HAL_UNLOCK(hmdios);

  return status;
}
#endif
#if SC_MODE
HAL_StatusTypeDef HAL_MDIOS_UnRegisterCallback(MDIOS_HandleTypeDef *hmdios, HAL_MDIOS_CallbackIDTypeDef CallbackID)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Process locked */
  __HAL_LOCK(hmdios);

  if (hmdios->State == HAL_MDIOS_STATE_READY)
  {
    switch (CallbackID)
    {
      case HAL_MDIOS_WRITE_COMPLETE_CB_ID :
        hmdios->WriteCpltCallback = HAL_MDIOS_WriteCpltCallback;
        break;

      case HAL_MDIOS_READ_COMPLETE_CB_ID :
        hmdios->ReadCpltCallback = HAL_MDIOS_ReadCpltCallback;
        break;

      case HAL_MDIOS_ERROR_CB_ID :
        hmdios->ErrorCallback = HAL_MDIOS_ErrorCallback;
        break;

      case HAL_MDIOS_WAKEUP_CB_ID :
        hmdios->WakeUpCallback = HAL_MDIOS_WakeUpCallback;
        break;

      case HAL_MDIOS_MSPINIT_CB_ID :
        hmdios->MspInitCallback = HAL_MDIOS_MspInit;
        break;

      case HAL_MDIOS_MSPDEINIT_CB_ID :
        hmdios->MspDeInitCallback = HAL_MDIOS_MspDeInit;
        break;

      default :
        /* Update the error code */
        hmdios->ErrorCode |= HAL_MDIOS_ERROR_INVALID_CALLBACK;
        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (hmdios->State == HAL_MDIOS_STATE_RESET)
  {
    switch (CallbackID)
    {
      case HAL_MDIOS_MSPINIT_CB_ID :
        hmdios->MspInitCallback = HAL_MDIOS_MspInit;
        break;

      case HAL_MDIOS_MSPDEINIT_CB_ID :
        hmdios->MspDeInitCallback = HAL_MDIOS_MspDeInit;
        break;

      default :
        /* Update the error code */
        hmdios->ErrorCode |= HAL_MDIOS_ERROR_INVALID_CALLBACK;
        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hmdios->ErrorCode |= HAL_MDIOS_ERROR_INVALID_CALLBACK;
    /* Return error status */
    status =  HAL_ERROR;
  }

  /* Release Lock */
  __HAL_UNLOCK(hmdios);

  return status;
}
#endif
HAL_StatusTypeDef HAL_MDIOS_WriteReg(MDIOS_HandleTypeDef *hmdios, uint32_t RegNum, uint16_t Data)
{
  uintptr_t tmpreg;

  /* Check the parameters */
  assert_param(IS_MDIOS_REGISTER(RegNum));

  /* Process Locked */
  __HAL_LOCK(hmdios);

  /* Get the addr of output register to be written by the MDIOS */
  tmpreg = MDIOS_DOUT_BASE_ADDR + (4U * RegNum);

  /* Write to DOUTn register */
  *((uint32_t *)tmpreg) = Data;

  /* Process Unlocked */
  __HAL_UNLOCK(hmdios);

  return HAL_OK;
}
HAL_StatusTypeDef HAL_MDIOS_ReadReg(MDIOS_HandleTypeDef *hmdios, uint32_t RegNum, uint16_t *pData)
{
  uintptr_t tmpreg;

  /* Check the parameters */
  assert_param(IS_MDIOS_REGISTER(RegNum));

  /* Process Locked */
  __HAL_LOCK(hmdios);

  /* Get the addr of input register to be read by the MDIOS */
  tmpreg = MDIOS_DIN_BASE_ADDR + (4U * RegNum);

  /* Read DINn register */
  *pData = (uint16_t)(*((uint32_t *)tmpreg));

  /* Process Unlocked */
  __HAL_UNLOCK(hmdios);

  return HAL_OK;
}
uint32_t HAL_MDIOS_GetWrittenRegAddress(MDIOS_HandleTypeDef *hmdios)
{
  return hmdios->Instance->WRFR;
}
uint32_t HAL_MDIOS_GetReadRegAddress(MDIOS_HandleTypeDef *hmdios)
{
  return hmdios->Instance->RDFR;
}
HAL_StatusTypeDef HAL_MDIOS_ClearWriteRegAddress(MDIOS_HandleTypeDef *hmdios, uint32_t RegNum)
{
  /* Check the parameters */
  assert_param(IS_MDIOS_REGISTER(RegNum));

  /* Process Locked */
  __HAL_LOCK(hmdios);

  /* Clear write registers flags */
  hmdios->Instance->CWRFR |= (RegNum);

  /* Release Lock */
  __HAL_UNLOCK(hmdios);

  return HAL_OK;
}
HAL_StatusTypeDef HAL_MDIOS_ClearReadRegAddress(MDIOS_HandleTypeDef *hmdios, uint32_t RegNum)
{
  /* Check the parameters */
  assert_param(IS_MDIOS_REGISTER(RegNum));

  /* Process Locked */
  __HAL_LOCK(hmdios);

  /* Clear read registers flags */
  hmdios->Instance->CRDFR |= (RegNum);

  /* Release Lock */
  __HAL_UNLOCK(hmdios);

  return HAL_OK;
}
HAL_StatusTypeDef HAL_MDIOS_EnableEvents(MDIOS_HandleTypeDef *hmdios)
{
  /* Process Locked */
  __HAL_LOCK(hmdios);

  /* Enable MDIOS interrupts: Register Write, Register Read and Error ITs */
  __HAL_MDIOS_ENABLE_IT(hmdios, (MDIOS_IT_WRITE | MDIOS_IT_READ | MDIOS_IT_ERROR));

  /* Process Unlocked */
  __HAL_UNLOCK(hmdios);

  return HAL_OK;
}
void HAL_MDIOS_IRQHandler(MDIOS_HandleTypeDef *hmdios)
{
  uint32_t itsource = READ_REG(hmdios->Instance->CR);
  uint32_t itflag = READ_REG(hmdios->Instance->SR);
  uint32_t exti_flag = READ_REG(EXTI->PR2);

  /* Write Register Interrupt enabled ? */
  if ((itsource & MDIOS_IT_WRITE) != 0U)
  {
    /* Write register flag */
    if (HAL_MDIOS_GetWrittenRegAddress(hmdios) != (uint32_t)RESET)
    {
#if (USE_HAL_MDIOS_REGISTER_CALLBACKS == 1)
      /*Call registered Write complete callback*/
      hmdios->WriteCpltCallback(hmdios);
#else
      /* Write callback function */
      HAL_MDIOS_WriteCpltCallback(hmdios);
#endif  /* USE_HAL_MDIOS_REGISTER_CALLBACKS */

      /* Clear write register flag */
      hmdios->Instance->CWRFR |= MDIOS_ALL_REG_FLAG;
    }
  }

  /* Read Register Interrupt enabled ? */
  if ((itsource & MDIOS_IT_READ) != 0U)
  {
    /* Read register flag */
    if (HAL_MDIOS_GetReadRegAddress(hmdios) != (uint32_t)RESET)
    {
#if (USE_HAL_MDIOS_REGISTER_CALLBACKS == 1)
      /*Call registered Read complete callback*/
      hmdios->ReadCpltCallback(hmdios);
#else
      /* Read callback function  */
      HAL_MDIOS_ReadCpltCallback(hmdios);
#endif  /* USE_HAL_MDIOS_REGISTER_CALLBACKS */

      /* Clear read register flag */
      hmdios->Instance->CRDFR |= MDIOS_ALL_REG_FLAG;
    }
  }

  /* Error Interrupt enabled ? */
  if ((itsource & MDIOS_IT_ERROR) != 0U)
  {
    /* All Errors Flag */
    if ((itflag & MDIOS_ALL_ERRORS_FLAG) != 0U)
    {
      hmdios->ErrorCode |= HAL_MDIOS_ERROR_DATA;

#if (USE_HAL_MDIOS_REGISTER_CALLBACKS == 1)
      /*Call registered Error callback*/
      hmdios->ErrorCallback(hmdios);
#else
      /* Error Callback */
      HAL_MDIOS_ErrorCallback(hmdios);
#endif  /* USE_HAL_MDIOS_REGISTER_CALLBACKS */

      /* Clear errors flag */
      __HAL_MDIOS_CLEAR_ERROR_FLAG(hmdios, MDIOS_ALL_ERRORS_FLAG);
    }
    hmdios->ErrorCode = HAL_MDIOS_ERROR_NONE;
  }
  /* check MDIOS WAKEUP exti flag */
  if ((exti_flag & MDIOS_WAKEUP_EXTI_LINE) != 0U)
  {
    /* Clear MDIOS WAKEUP Exti pending bit */
    __HAL_MDIOS_WAKEUP_EXTI_CLEAR_FLAG(MDIOS_WAKEUP_EXTI_LINE);
#if (USE_HAL_MDIOS_REGISTER_CALLBACKS == 1)
    /*Call registered WakeUp callback*/
    hmdios->WakeUpCallback(hmdios);
#else
    /* MDIOS WAKEUP callback */
    HAL_MDIOS_WakeUpCallback(hmdios);
#endif  /* USE_HAL_MDIOS_REGISTER_CALLBACKS */
  }

}
uint32_t HAL_MDIOS_GetError(MDIOS_HandleTypeDef *hmdios)
{
  /* return the error code */
  return hmdios->ErrorCode;
}
HAL_MDIOS_StateTypeDef HAL_MDIOS_GetState(MDIOS_HandleTypeDef *hmdios)
{
  /* Return MDIOS state */
  return hmdios->State;
}
#if SC_MODE
static void MDIOS_InitCallbacksToDefault(MDIOS_HandleTypeDef *hmdios)
{
  /* Init the MDIOS Callback settings */
  hmdios->WriteCpltCallback  = HAL_MDIOS_WriteCpltCallback;   /* Legacy weak WriteCpltCallback   */
  hmdios->ReadCpltCallback   = HAL_MDIOS_ReadCpltCallback;    /* Legacy weak ReadCpltCallback   */
  hmdios->ErrorCallback      = HAL_MDIOS_ErrorCallback;       /* Legacy weak ErrorCallback */
  hmdios->WakeUpCallback     = HAL_MDIOS_WakeUpCallback;        /* Legacy weak WakeUpCallback   */
}
#endif
