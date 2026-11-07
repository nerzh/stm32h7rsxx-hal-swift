/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted from STM32H7RS HAL at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
HAL_StatusTypeDef HAL_RAMECC_Init(RAMECC_HandleTypeDef *hramecc)
{
  /* Check the RAMECC peripheral handle */
  if (hramecc == NULL)
  {
    /* Return HAL status */
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_RAMECC_MONITOR_ALL_INSTANCE(hramecc->Instance));

  /* Change RAMECC peripheral state */
  hramecc->State = HAL_RAMECC_STATE_BUSY;

#if (USE_HAL_RAMECC_REGISTER_CALLBACKS == 1)
  /* Check if a valid MSP API was registered */
  if (hramecc->MspInitCallback == NULL)
  {
    /* Init the low level hardware */
    hramecc->MspInitCallback = HAL_RAMECC_MspInit;
  }

  /* Init the low level hardware */
  hramecc->MspInitCallback(hramecc);
#else
  HAL_RAMECC_MspInit(hramecc);
#endif /* USE_HAL_RAMECC_REGISTER_CALLBACKS */

  /* Disable RAMECC monitor */
  hramecc->Instance->CR &= ~RAMECC_CR_ECCELEN;

  /* Disable all global interrupts */
  ((RAMECC_TypeDef *)((uint32_t)hramecc->Instance & 0xFFFFFF00U))->IER &= \
      ~(RAMECC_IER_GIE | RAMECC_IER_GECCSEIE | RAMECC_IER_GECCDEIE | RAMECC_IER_GECCDEBWIE);

  /* Disable all interrupts monitor */
  hramecc->Instance->CR &= ~(RAMECC_CR_ECCSEIE | RAMECC_CR_ECCDEIE | RAMECC_CR_ECCDEBWIE);

  /* Clear RAMECC monitor flags */
  __HAL_RAMECC_CLEAR_FLAG(hramecc, RAMECC_FLAGS_ALL);

  /* Initialise the RAMECC error code */
  hramecc->ErrorCode = HAL_RAMECC_ERROR_NONE;

  /* Update the RAMECC state */
  hramecc->State = HAL_RAMECC_STATE_READY;

  /* Return HAL status */
  return HAL_OK;
}

HAL_StatusTypeDef HAL_RAMECC_DeInit(RAMECC_HandleTypeDef *hramecc)
{
  /* Check the RAMECC peripheral handle */
  if (hramecc == NULL)
  {
    /* Return HAL status */
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_RAMECC_MONITOR_ALL_INSTANCE(hramecc->Instance));

  /* Disable RAMECC monitor */
  hramecc->Instance->CR &= ~RAMECC_CR_ECCELEN;

  /* Disable all global interrupts */
  ((RAMECC_TypeDef *)((uint32_t)hramecc->Instance & 0xFFFFFF00U))->IER &= \
      ~(RAMECC_IER_GIE | RAMECC_IER_GECCSEIE | RAMECC_IER_GECCDEIE | RAMECC_IER_GECCDEBWIE);

  /* Disable all interrupts monitor  */
  hramecc->Instance->CR &= ~(RAMECC_CR_ECCSEIE | RAMECC_CR_ECCDEIE | RAMECC_CR_ECCDEBWIE);

  /* Clear RAMECC monitor flags */
  __HAL_RAMECC_CLEAR_FLAG(hramecc, RAMECC_FLAGS_ALL);


#if (USE_HAL_RAMECC_REGISTER_CALLBACKS == 1)
  /* Check if a valid MSP API was registered */
  if (hramecc->MspDeInitCallback != NULL)
  {
    /* Init the low level hardware */
    hramecc->MspDeInitCallback(hramecc);
  }

  /* Clean callbacks */
  hramecc->DetectSingleErrorCallback = NULL;
  hramecc->DetectDoubleErrorCallback = NULL;
#else
  HAL_RAMECC_MspDeInit(hramecc);
#endif /* USE_HAL_RAMECC_REGISTER_CALLBACKS */

  /* Initialise the RAMECC error code */
  hramecc->ErrorCode = HAL_RAMECC_ERROR_NONE;

  /* Change RAMECC peripheral state */
  hramecc->State = HAL_RAMECC_STATE_RESET;

  /* Return HAL status */
  return HAL_OK;
}

__weak void HAL_RAMECC_MspInit(RAMECC_HandleTypeDef *hramecc)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hramecc);

  /* NOTE : This function should not be modified, when the callback is needed,
            the HAL_RAMECC_MspInit can be implemented in the user file      */
}

__weak void HAL_RAMECC_MspDeInit(RAMECC_HandleTypeDef *hramecc)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hramecc);

  /* NOTE : This function should not be modified, when the callback is needed,
            the HAL_RAMECC_MspDeInit can be implemented in the user file    */
}

HAL_StatusTypeDef HAL_RAMECC_StartMonitor(RAMECC_HandleTypeDef *hramecc)
{
  /* Check the parameters */
  assert_param(IS_RAMECC_MONITOR_ALL_INSTANCE(hramecc->Instance));

  /* Check RAMECC state */
  if (hramecc->State == HAL_RAMECC_STATE_READY)
  {
    /* Change RAMECC peripheral state */
    hramecc->State = HAL_RAMECC_STATE_BUSY;

    /* Enable RAMECC monitor */
    hramecc->Instance->CR |= RAMECC_CR_ECCELEN;

    /* Change RAMECC peripheral state */
    hramecc->State = HAL_RAMECC_STATE_READY;
  }
  else
  {
    /* Update the error code */
    hramecc->ErrorCode = HAL_RAMECC_ERROR_BUSY;

    /* Return HAL status */
    return HAL_ERROR;
  }

  /* Return HAL status */
  return HAL_OK;
}

HAL_StatusTypeDef HAL_RAMECC_StopMonitor(RAMECC_HandleTypeDef *hramecc)
{
  /* Check the parameters */
  assert_param(IS_RAMECC_MONITOR_ALL_INSTANCE(hramecc->Instance));

  /* Check RAMECC state */
  if (hramecc->State == HAL_RAMECC_STATE_READY)
  {
    /* Change RAMECC peripheral state */
    hramecc->State = HAL_RAMECC_STATE_BUSY;

    /* Disable RAMECC monitor */
    hramecc->Instance->CR &= ~RAMECC_CR_ECCELEN;

    /* Change RAMECC peripheral state */
    hramecc->State = HAL_RAMECC_STATE_READY;
  }
  else
  {
    /* Update the error code */
    hramecc->ErrorCode = HAL_RAMECC_ERROR_BUSY;

    /* Return HAL status */
    return HAL_ERROR;
  }

  /* Return HAL status */
  return HAL_OK;
}

HAL_StatusTypeDef HAL_RAMECC_EnableNotification(RAMECC_HandleTypeDef *hramecc, uint32_t Notifications)
{
  /* Check the parameters */
  assert_param(IS_RAMECC_MONITOR_ALL_INSTANCE(hramecc->Instance));
  assert_param(IS_RAMECC_INTERRUPT(Notifications));

  /* Check RAMECC state */
  if (hramecc->State == HAL_RAMECC_STATE_READY)
  {
    /* Change RAMECC peripheral state */
    hramecc->State = HAL_RAMECC_STATE_BUSY;

    /* Enable RAMECC interrupts */
    __HAL_RAMECC_ENABLE_IT(hramecc, Notifications);

    /* Change RAMECC peripheral state */
    hramecc->State = HAL_RAMECC_STATE_READY;
  }
  else
  {
    /* Update the error code */
    hramecc->ErrorCode = HAL_RAMECC_ERROR_BUSY;

    /* Return HAL status */
    return HAL_ERROR;
  }

  /* Return HAL status */
  return HAL_OK;
}

HAL_StatusTypeDef HAL_RAMECC_DisableNotification(RAMECC_HandleTypeDef *hramecc, uint32_t Notifications)
{
  /* Check the parameters */
  assert_param(IS_RAMECC_MONITOR_ALL_INSTANCE(hramecc->Instance));
  assert_param(IS_RAMECC_INTERRUPT(Notifications));

  /* Check RAMECC state */
  if (hramecc->State == HAL_RAMECC_STATE_READY)
  {
    /* Change RAMECC peripheral state */
    hramecc->State = HAL_RAMECC_STATE_BUSY;

    /* Disable RAMECC interrupts */
    __HAL_RAMECC_DISABLE_IT(hramecc, Notifications);

    /* Change RAMECC peripheral state */
    hramecc->State = HAL_RAMECC_STATE_READY;
  }
  else
  {
    /* Update the error code */
    hramecc->ErrorCode = HAL_RAMECC_ERROR_BUSY;

    /* Return HAL status */
    return HAL_ERROR;
  }

  /* Return HAL status */
  return HAL_OK;
}

void HAL_RAMECC_IRQHandler(RAMECC_HandleTypeDef *hramecc)
{
  uint32_t  monitor_it_source;
  uint32_t  global_it_source;

  monitor_it_source = READ_REG(hramecc->Instance->CR);
  global_it_source  = READ_REG(((RAMECC_TypeDef *)((uint32_t)hramecc->Instance & 0xFFFFFF00U))->IER);

  /* Single Error Interrupt Management ****************************************/
  if (((monitor_it_source & RAMECC_CR_ECCSEIE)   == RAMECC_CR_ECCSEIE)   ||
      ((global_it_source  & RAMECC_IER_GECCSEIE) == RAMECC_IER_GECCSEIE) ||
      ((global_it_source  & RAMECC_IER_GIE)      == RAMECC_IER_GIE))
  {
    if (__HAL_RAMECC_GET_FLAG(hramecc, RAMECC_FLAG_SINGLEERR_R) != 0U)
    {
      /* Clear active flags */
      __HAL_RAMECC_CLEAR_FLAG(hramecc, RAMECC_FLAG_SINGLEERR_R);

#if (USE_HAL_RAMECC_REGISTER_CALLBACKS == 1)
      /* Check if a valid single error callback is registered */
      if (hramecc->DetectSingleErrorCallback != NULL)
      {
        /* Single error detection callback */
        hramecc->DetectSingleErrorCallback(hramecc);
      }
#else
      HAL_RAMECC_DetectSingleErrorCallback(hramecc);
#endif /* USE_HAL_RAMECC_REGISTER_CALLBACKS */
    }
  }

  /* Double Error Interrupt Management ****************************************/
  if (((monitor_it_source & RAMECC_CR_ECCDEIE)     == RAMECC_CR_ECCDEIE)     ||
      ((monitor_it_source & RAMECC_CR_ECCDEBWIE)   == RAMECC_CR_ECCDEBWIE)   ||
      ((global_it_source  & RAMECC_IER_GECCDEIE)   == RAMECC_IER_GECCDEIE)   ||
      ((global_it_source  & RAMECC_IER_GECCDEBWIE) == RAMECC_IER_GECCDEBWIE) ||
      ((global_it_source  & RAMECC_IER_GIE)        == RAMECC_IER_GIE))
  {
    /* ECC double error detected flag */
    if (__HAL_RAMECC_GET_FLAG(hramecc, RAMECC_FLAG_DOUBLEERR_R) != 0U)
    {
      /* Clear active flags */
      __HAL_RAMECC_CLEAR_FLAG(hramecc, RAMECC_FLAG_DOUBLEERR_R);

#if (USE_HAL_RAMECC_REGISTER_CALLBACKS == 1)
      /* Check if a valid Double error callback is registered */
      if (hramecc->DetectDoubleErrorCallback != NULL)
      {
        /* Double error detection callback */
        hramecc->DetectDoubleErrorCallback(hramecc);
      }
#else
      HAL_RAMECC_DetectDoubleErrorCallback(hramecc);
#endif /* USE_HAL_RAMECC_REGISTER_CALLBACKS */
    }

    /* ECC double error on byte write */
    if (__HAL_RAMECC_GET_FLAG(hramecc, RAMECC_FLAG_DOUBLEERR_W) != 0U)
    {
      /* Clear active flags */
      __HAL_RAMECC_CLEAR_FLAG(hramecc, RAMECC_FLAG_DOUBLEERR_W);

#if (USE_HAL_RAMECC_REGISTER_CALLBACKS == 1)
      /* Check if a valid Double error callback is registered */
      if (hramecc->DetectDoubleErrorCallback != NULL)
      {
        /* Double error detection callback */
        hramecc->DetectDoubleErrorCallback(hramecc);
      }
#else
      HAL_RAMECC_DetectDoubleErrorCallback(hramecc);
#endif /* USE_HAL_RAMECC_REGISTER_CALLBACKS */
    }
  }
}

__weak void HAL_RAMECC_DetectSingleErrorCallback(RAMECC_HandleTypeDef *hramecc)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hramecc);

  /* NOTE : This function should not be modified, when the callback is needed,
            the HAL_RAMECC_DetectSingleErrorCallback can be implemented in
            the user file.                                                    */
}

__weak void HAL_RAMECC_DetectDoubleErrorCallback(RAMECC_HandleTypeDef *hramecc)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hramecc);

  /* NOTE : This function should not be modified, when the callback is needed,
            the HAL_RAMECC_DetectDoubleErrorCallback can be implemented in
            the user file.                                                    */
}

#if (USE_HAL_RAMECC_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_RAMECC_RegisterCallback(RAMECC_HandleTypeDef *hramecc,
                                              HAL_RAMECC_CallbackIDTypeDef CallbackID,
                                              void (* pCallback)(RAMECC_HandleTypeDef *_hramecc))
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code and return error */
    hramecc->ErrorCode |= HAL_RAMECC_ERROR_INVALID_CALLBACK;
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_RAMECC_MONITOR_ALL_INSTANCE(hramecc->Instance));

  /* Check RAMECC state */
  if (hramecc->State == HAL_RAMECC_STATE_READY)
  {
    switch (CallbackID)
    {
      case  HAL_RAMECC_SE_DETECT_CB_ID:
        /* Register single error callback */
        hramecc->DetectSingleErrorCallback = pCallback;
        break;

      case  HAL_RAMECC_DE_DETECT_CB_ID:
        /* Register double error callback */
        hramecc->DetectDoubleErrorCallback = pCallback;
        break;

      case HAL_RAMECC_MSPINIT_CB_ID :
        /* Register msp init callback */
        hramecc->MspInitCallback = pCallback;
        break;

      case HAL_RAMECC_MSPDEINIT_CB_ID :
        /* Register msp de-init callback */
        hramecc->MspDeInitCallback = pCallback;
        break;

      default:
        /* Update the error code and return error */
        hramecc->ErrorCode |= HAL_RAMECC_ERROR_INVALID_CALLBACK;
        status = HAL_ERROR;
        break;
    }
  }
  else if (hramecc->State == HAL_RAMECC_STATE_RESET)
  {
    switch (CallbackID)
    {
      case HAL_RAMECC_MSPINIT_CB_ID :
        /* Register msp init callback */
        hramecc->MspInitCallback = pCallback;
        break;

      case HAL_RAMECC_MSPDEINIT_CB_ID :
        /* Register msp de-init callback */
        hramecc->MspDeInitCallback = pCallback;
        break;

      default :
        /* Update the error code and return error */
        hramecc->ErrorCode |= HAL_RAMECC_ERROR_INVALID_CALLBACK;
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code and return error  */
    hramecc->ErrorCode = HAL_RAMECC_ERROR_INVALID_CALLBACK;
    status = HAL_ERROR;
  }

  return status;
}

#endif
#if (USE_HAL_RAMECC_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_RAMECC_UnRegisterCallback(RAMECC_HandleTypeDef *hramecc, HAL_RAMECC_CallbackIDTypeDef CallbackID)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the parameters */
  assert_param(IS_RAMECC_MONITOR_ALL_INSTANCE(hramecc->Instance));

  /* Check RAMECC state */
  if (hramecc->State == HAL_RAMECC_STATE_READY)
  {
    switch (CallbackID)
    {
      case  HAL_RAMECC_SE_DETECT_CB_ID:
        /* UnRegister single error callback */
        hramecc->DetectSingleErrorCallback = NULL;
        break;

      case  HAL_RAMECC_DE_DETECT_CB_ID:
        /* UnRegister double error callback */
        hramecc->DetectDoubleErrorCallback = NULL;
        break;

      case HAL_RAMECC_MSPINIT_CB_ID :
        /* UnRegister msp init callback */
        hramecc->MspInitCallback = NULL;
        break;

      case HAL_RAMECC_MSPDEINIT_CB_ID :
        /* UnRegister msp de-init callback */
        hramecc->MspDeInitCallback = NULL;
        break;

      case  HAL_RAMECC_ALL_CB_ID:
        /* UnRegister all available callbacks */
        hramecc->DetectSingleErrorCallback = NULL;
        hramecc->DetectDoubleErrorCallback = NULL;
        hramecc->MspDeInitCallback         = NULL;
        hramecc->MspInitCallback           = NULL;
        break;

      default:
        /* Return error status */
        status = HAL_ERROR;
        break;
    }
  }
  else if (hramecc->State == HAL_RAMECC_STATE_RESET)
  {
    switch (CallbackID)
    {
      case HAL_RAMECC_MSPINIT_CB_ID :
        /* UnRegister msp init callback */
        hramecc->MspInitCallback = NULL;
        break;

      case HAL_RAMECC_MSPDEINIT_CB_ID :
        /* UnRegister msp de-init callback */
        hramecc->MspDeInitCallback = NULL;
        break;

      case  HAL_RAMECC_ALL_CB_ID:
        /* UnRegister all available callbacks */
        hramecc->MspDeInitCallback = NULL;
        hramecc->MspInitCallback   = NULL;
        break;

      default :
        /* Update the error code */
        hramecc->ErrorCode |= HAL_RAMECC_ERROR_INVALID_CALLBACK;

        /* Update return status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code and return error */
    hramecc->ErrorCode = HAL_RAMECC_ERROR_INVALID_CALLBACK;
    status = HAL_ERROR;
  }

  return status;
}

#endif
uint32_t HAL_RAMECC_GetFailingAddress(const RAMECC_HandleTypeDef *hramecc)
{
  /* Check the parameters */
  assert_param(IS_RAMECC_MONITOR_ALL_INSTANCE(hramecc->Instance));

  /* Return failing address */
  return hramecc->Instance->FAR;
}

uint32_t HAL_RAMECC_GetFailingDataLow(const RAMECC_HandleTypeDef *hramecc)
{
  /* Check the parameters */
  assert_param(IS_RAMECC_MONITOR_ALL_INSTANCE(hramecc->Instance));

  /* Return failing data low */
  return hramecc->Instance->FDRL;
}

uint32_t HAL_RAMECC_GetFailingDataHigh(const RAMECC_HandleTypeDef *hramecc)
{
  /* Check the parameters */
  assert_param(IS_RAMECC_MONITOR_ALL_INSTANCE(hramecc->Instance));

  /* Return failing data high */
  return hramecc->Instance->FDRH;
}

uint32_t HAL_RAMECC_GetHammingErrorCode(const RAMECC_HandleTypeDef *hramecc)
{
  /* Check the parameters */
  assert_param(IS_RAMECC_MONITOR_ALL_INSTANCE(hramecc->Instance));

  /* Return hamming bits injected */
  return hramecc->Instance->FECR;
}

uint32_t HAL_RAMECC_IsECCSingleErrorDetected(const RAMECC_HandleTypeDef *hramecc)
{
  /* Check the parameters */
  assert_param(IS_RAMECC_MONITOR_ALL_INSTANCE(hramecc->Instance));

  /* Return the state of SEDC flag */
  return ((READ_BIT(hramecc->Instance->SR, RAMECC_SR_SEDCF) == (RAMECC_SR_SEDCF)) ? 1UL : 0UL);
}

uint32_t HAL_RAMECC_IsECCDoubleErrorDetected(const RAMECC_HandleTypeDef *hramecc)
{
  /* Check the parameters */
  assert_param(IS_RAMECC_MONITOR_ALL_INSTANCE(hramecc->Instance));

  /* Return the state of DEDF | DEBWDF flags */
  return ((READ_BIT(hramecc->Instance->SR, (RAMECC_SR_DEDF | RAMECC_SR_DEBWDF)) != 0U) ? 1UL : 0UL);
}

HAL_RAMECC_StateTypeDef HAL_RAMECC_GetState(const RAMECC_HandleTypeDef *hramecc)
{
  /* Return the RAMECC state */
  return hramecc->State;
}

uint32_t HAL_RAMECC_GetError(const RAMECC_HandleTypeDef *hramecc)
{
  /* Return the RAMECC error code */
  return hramecc->ErrorCode;
}
