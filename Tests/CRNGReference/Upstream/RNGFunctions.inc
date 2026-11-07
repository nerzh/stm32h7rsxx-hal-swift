/* Derived from STMicroelectronics STM32H7RSxx HAL Driver, commit
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * Licensed under BSD-3-Clause; see LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.
 * Function bodies below are unchanged; test-only register/OS substitutions and
 * symbol namespaces are supplied by RNGReferenceShim.h.
 */

#define RNG_TIMEOUT_VALUE 10U

HAL_StatusTypeDef HAL_RNG_Init(RNG_HandleTypeDef *hrng)
{
  uint32_t tickstart;
  /* Check the RNG handle allocation */
  if (hrng == NULL)
  {
    return HAL_ERROR;
  }
  /* Check the parameters */
  assert_param(IS_RNG_ALL_INSTANCE(hrng->Instance));
  assert_param(IS_RNG_CED(hrng->Init.ClockErrorDetection));

#if (USE_HAL_RNG_REGISTER_CALLBACKS == 1)
  if (hrng->State == HAL_RNG_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    hrng->Lock = HAL_UNLOCKED;

    hrng->ReadyDataCallback  = HAL_RNG_ReadyDataCallback;  /* Legacy weak ReadyDataCallback  */
    hrng->ErrorCallback      = HAL_RNG_ErrorCallback;      /* Legacy weak ErrorCallback      */

    if (hrng->MspInitCallback == NULL)
    {
      hrng->MspInitCallback = HAL_RNG_MspInit; /* Legacy weak MspInit  */
    }

    /* Init the low level hardware */
    hrng->MspInitCallback(hrng);
  }
#else
  if (hrng->State == HAL_RNG_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    hrng->Lock = HAL_UNLOCKED;

    /* Init the low level hardware */
    HAL_RNG_MspInit(hrng);
  }
#endif /* USE_HAL_RNG_REGISTER_CALLBACKS */

  /* Change RNG peripheral state */
  hrng->State = HAL_RNG_STATE_BUSY;

  /* Disable RNG */
  __HAL_RNG_DISABLE(hrng);

  /* Clock Error Detection Configuration when CONDRT bit is set to 1 */
  MODIFY_REG(hrng->Instance->CR, RNG_CR_CED | RNG_CR_CONDRST, hrng->Init.ClockErrorDetection | RNG_CR_CONDRST);

  /* Writing bit CONDRST=0 */
  CLEAR_BIT(hrng->Instance->CR, RNG_CR_CONDRST);

  /* Get tick */
  tickstart = HAL_GetTick();

  /* Wait for conditioning reset process to be completed */
  while (HAL_IS_BIT_SET(hrng->Instance->CR, RNG_CR_CONDRST))
  {
    if ((HAL_GetTick() - tickstart) > RNG_TIMEOUT_VALUE)
    {
      /* New check to avoid false timeout detection in case of preemption */
      if (HAL_IS_BIT_SET(hrng->Instance->CR, RNG_CR_CONDRST))
      {
        hrng->State = HAL_RNG_STATE_READY;
        hrng->ErrorCode = HAL_RNG_ERROR_TIMEOUT;
        return HAL_ERROR;
      }
    }
  }

  /* Enable the RNG Peripheral */
  __HAL_RNG_ENABLE(hrng);

  /* verify that no seed error */
  if (__HAL_RNG_GET_IT(hrng, RNG_IT_SEI) != RESET)
  {
    hrng->State = HAL_RNG_STATE_ERROR;
    return HAL_ERROR;
  }
  /* Get tick */
  tickstart = HAL_GetTick();
  /* Check if data register contains valid random data */
  while (__HAL_RNG_GET_FLAG(hrng, RNG_FLAG_DRDY) != SET)
  {
    if ((HAL_GetTick() - tickstart) > RNG_TIMEOUT_VALUE)
    {
      /* New check to avoid false timeout detection in case of preemption */
      if (__HAL_RNG_GET_FLAG(hrng, RNG_FLAG_DRDY) != SET)
      {
        hrng->State = HAL_RNG_STATE_ERROR;
        hrng->ErrorCode = HAL_RNG_ERROR_TIMEOUT;
        return HAL_ERROR;
      }
    }
  }

  /* Initialize the RNG state */
  hrng->State = HAL_RNG_STATE_READY;

  /* Initialise the error code */
  hrng->ErrorCode = HAL_RNG_ERROR_NONE;

  /* Return function status */
  return HAL_OK;
}

HAL_StatusTypeDef HAL_RNG_DeInit(RNG_HandleTypeDef *hrng)
{
  uint32_t tickstart;

  /* Check the RNG handle allocation */
  if (hrng == NULL)
  {
    return HAL_ERROR;
  }

  /* Clear Clock Error Detection bit when CONDRT bit is set to 1 */
  MODIFY_REG(hrng->Instance->CR, RNG_CR_CED | RNG_CR_CONDRST, RNG_CED_ENABLE | RNG_CR_CONDRST);

  /* Writing bit CONDRST=0 */
  CLEAR_BIT(hrng->Instance->CR, RNG_CR_CONDRST);

  /* Get tick */
  tickstart = HAL_GetTick();

  /* Wait for conditioning reset process to be completed */
  while (HAL_IS_BIT_SET(hrng->Instance->CR, RNG_CR_CONDRST))
  {
    if ((HAL_GetTick() - tickstart) > RNG_TIMEOUT_VALUE)
    {
      /* New check to avoid false timeout detection in case of preemption */
      if (HAL_IS_BIT_SET(hrng->Instance->CR, RNG_CR_CONDRST))
      {
        hrng->State = HAL_RNG_STATE_READY;
        hrng->ErrorCode = HAL_RNG_ERROR_TIMEOUT;
        /* Process Unlocked */
        __HAL_UNLOCK(hrng);
        return HAL_ERROR;
      }
    }
  }

  /* Disable the RNG Peripheral */
  CLEAR_BIT(hrng->Instance->CR, RNG_CR_IE | RNG_CR_RNGEN);

  /* Clear RNG interrupt status flags */
  CLEAR_BIT(hrng->Instance->SR, RNG_SR_CEIS | RNG_SR_SEIS);

#if (USE_HAL_RNG_REGISTER_CALLBACKS == 1)
  if (hrng->MspDeInitCallback == NULL)
  {
    hrng->MspDeInitCallback = HAL_RNG_MspDeInit; /* Legacy weak MspDeInit  */
  }

  /* DeInit the low level hardware */
  hrng->MspDeInitCallback(hrng);
#else
  /* DeInit the low level hardware */
  HAL_RNG_MspDeInit(hrng);
#endif /* USE_HAL_RNG_REGISTER_CALLBACKS */

  /* Update the RNG state */
  hrng->State = HAL_RNG_STATE_RESET;

  /* Initialise the error code */
  hrng->ErrorCode = HAL_RNG_ERROR_NONE;

  /* Release Lock */
  __HAL_UNLOCK(hrng);

  /* Return the function status */
  return HAL_OK;
}

__weak void HAL_RNG_MspInit(RNG_HandleTypeDef *hrng)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrng);
  /* NOTE : This function should not be modified. When the callback is needed,
            function HAL_RNG_MspInit must be implemented in the user file.
   */
}

__weak void HAL_RNG_MspDeInit(RNG_HandleTypeDef *hrng)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrng);
  /* NOTE : This function should not be modified. When the callback is needed,
            function HAL_RNG_MspDeInit must be implemented in the user file.
   */
}

#if USE_HAL_RNG_REGISTER_CALLBACKS == 1

HAL_StatusTypeDef HAL_RNG_RegisterCallback(RNG_HandleTypeDef *hrng, HAL_RNG_CallbackIDTypeDef CallbackID,
                                           pRNG_CallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hrng->ErrorCode = HAL_RNG_ERROR_INVALID_CALLBACK;
    return HAL_ERROR;
  }

  if (HAL_RNG_STATE_READY == hrng->State)
  {
    switch (CallbackID)
    {
      case HAL_RNG_ERROR_CB_ID :
        hrng->ErrorCallback = pCallback;
        break;

      case HAL_RNG_MSPINIT_CB_ID :
        hrng->MspInitCallback = pCallback;
        break;

      case HAL_RNG_MSPDEINIT_CB_ID :
        hrng->MspDeInitCallback = pCallback;
        break;

      default :
        /* Update the error code */
        hrng->ErrorCode = HAL_RNG_ERROR_INVALID_CALLBACK;
        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (HAL_RNG_STATE_RESET == hrng->State)
  {
    switch (CallbackID)
    {
      case HAL_RNG_MSPINIT_CB_ID :
        hrng->MspInitCallback = pCallback;
        break;

      case HAL_RNG_MSPDEINIT_CB_ID :
        hrng->MspDeInitCallback = pCallback;
        break;

      default :
        /* Update the error code */
        hrng->ErrorCode = HAL_RNG_ERROR_INVALID_CALLBACK;
        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hrng->ErrorCode = HAL_RNG_ERROR_INVALID_CALLBACK;
    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}

#endif

#if USE_HAL_RNG_REGISTER_CALLBACKS == 1

HAL_StatusTypeDef HAL_RNG_UnRegisterCallback(RNG_HandleTypeDef *hrng, HAL_RNG_CallbackIDTypeDef CallbackID)
{
  HAL_StatusTypeDef status = HAL_OK;


  if (HAL_RNG_STATE_READY == hrng->State)
  {
    switch (CallbackID)
    {
      case HAL_RNG_ERROR_CB_ID :
        hrng->ErrorCallback = HAL_RNG_ErrorCallback;          /* Legacy weak ErrorCallback  */
        break;

      case HAL_RNG_MSPINIT_CB_ID :
        hrng->MspInitCallback = HAL_RNG_MspInit;              /* Legacy weak MspInit  */
        break;

      case HAL_RNG_MSPDEINIT_CB_ID :
        hrng->MspDeInitCallback = HAL_RNG_MspDeInit;          /* Legacy weak MspDeInit  */
        break;

      default :
        /* Update the error code */
        hrng->ErrorCode = HAL_RNG_ERROR_INVALID_CALLBACK;
        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (HAL_RNG_STATE_RESET == hrng->State)
  {
    switch (CallbackID)
    {
      case HAL_RNG_MSPINIT_CB_ID :
        hrng->MspInitCallback = HAL_RNG_MspInit;              /* Legacy weak MspInit  */
        break;

      case HAL_RNG_MSPDEINIT_CB_ID :
        hrng->MspDeInitCallback = HAL_RNG_MspDeInit;          /* Legacy weak MspInit  */
        break;

      default :
        /* Update the error code */
        hrng->ErrorCode = HAL_RNG_ERROR_INVALID_CALLBACK;
        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hrng->ErrorCode = HAL_RNG_ERROR_INVALID_CALLBACK;
    /* Return error status */
    status =  HAL_ERROR;
  }

  return status;
}

#endif

#if USE_HAL_RNG_REGISTER_CALLBACKS == 1

HAL_StatusTypeDef HAL_RNG_RegisterReadyDataCallback(RNG_HandleTypeDef *hrng, pRNG_ReadyDataCallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hrng->ErrorCode = HAL_RNG_ERROR_INVALID_CALLBACK;
    return HAL_ERROR;
  }
  /* Process locked */
  __HAL_LOCK(hrng);

  if (HAL_RNG_STATE_READY == hrng->State)
  {
    hrng->ReadyDataCallback = pCallback;
  }
  else
  {
    /* Update the error code */
    hrng->ErrorCode = HAL_RNG_ERROR_INVALID_CALLBACK;
    /* Return error status */
    status =  HAL_ERROR;
  }

  /* Release Lock */
  __HAL_UNLOCK(hrng);
  return status;
}

#endif

#if USE_HAL_RNG_REGISTER_CALLBACKS == 1

HAL_StatusTypeDef HAL_RNG_UnRegisterReadyDataCallback(RNG_HandleTypeDef *hrng)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Process locked */
  __HAL_LOCK(hrng);

  if (HAL_RNG_STATE_READY == hrng->State)
  {
    hrng->ReadyDataCallback = HAL_RNG_ReadyDataCallback; /* Legacy weak ReadyDataCallback  */
  }
  else
  {
    /* Update the error code */
    hrng->ErrorCode = HAL_RNG_ERROR_INVALID_CALLBACK;
    /* Return error status */
    status =  HAL_ERROR;
  }

  /* Release Lock */
  __HAL_UNLOCK(hrng);
  return status;
}

#endif

HAL_StatusTypeDef HAL_RNG_GenerateRandomNumber(RNG_HandleTypeDef *hrng, uint32_t *random32bit)
{
  uint32_t tickstart;
  HAL_StatusTypeDef status = HAL_OK;

  /* Process Locked */
  __HAL_LOCK(hrng);

  /* Check RNG peripheral state */
  if (hrng->State == HAL_RNG_STATE_READY)
  {
    /* Change RNG peripheral state */
    hrng->State = HAL_RNG_STATE_BUSY;
    /* Check if there is a seed error */
    if (__HAL_RNG_GET_IT(hrng, RNG_IT_SEI) != RESET)
    {
      /* Update the error code */
      hrng->ErrorCode = HAL_RNG_ERROR_SEED;
      /* Reset from seed error */
      status = RNG_RecoverSeedError(hrng);
      if (status == HAL_ERROR)
      {
        /* Update the error code */
        hrng->ErrorCode = HAL_RNG_ERROR_RECOVERSEED;
        return status;
      }
    }

    /* Get tick */
    tickstart = HAL_GetTick();

    /* Check if data register contains valid random data */
    while (__HAL_RNG_GET_FLAG(hrng, RNG_FLAG_DRDY) == RESET)
    {
      if ((HAL_GetTick() - tickstart) > RNG_TIMEOUT_VALUE)
      {
        /* New check to avoid false timeout detection in case of preemption */
        if (__HAL_RNG_GET_FLAG(hrng, RNG_FLAG_DRDY) == RESET)
        {
          hrng->State = HAL_RNG_STATE_READY;
          hrng->ErrorCode = HAL_RNG_ERROR_TIMEOUT;
          /* Process Unlocked */
          __HAL_UNLOCK(hrng);
          return HAL_ERROR;
        }
      }
    }

    /* Get a 32bit Random number */
    hrng->RandomNumber = hrng->Instance->DR;
    /* In case of seed error, the value available in the RNG_DR register must not
       be used as it may not have enough entropy */
    if (__HAL_RNG_GET_IT(hrng, RNG_IT_SEI) != RESET)
    {
      /* Update the error code and status */
      hrng->ErrorCode = HAL_RNG_ERROR_SEED;
      status = HAL_ERROR;
    }
    else /* No seed error */
    {
      *random32bit = hrng->RandomNumber;
    }
    hrng->State = HAL_RNG_STATE_READY;
  }
  else
  {
    hrng->ErrorCode = HAL_RNG_ERROR_BUSY;
    status = HAL_ERROR;
  }

  /* Process Unlocked */
  __HAL_UNLOCK(hrng);

  return status;
}

HAL_StatusTypeDef HAL_RNG_GenerateRandomNumber_IT(RNG_HandleTypeDef *hrng)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Process Locked */
  __HAL_LOCK(hrng);

  /* Check RNG peripheral state */
  if (hrng->State == HAL_RNG_STATE_READY)
  {
    /* Change RNG peripheral state */
    hrng->State = HAL_RNG_STATE_BUSY;

    /* Enable the RNG Interrupts: Data Ready, Clock error, Seed error */
    __HAL_RNG_ENABLE_IT(hrng);
  }
  else
  {
    /* Process Unlocked */
    __HAL_UNLOCK(hrng);

    hrng->ErrorCode = HAL_RNG_ERROR_BUSY;
    status = HAL_ERROR;
  }

  return status;
}

void HAL_RNG_IRQHandler(RNG_HandleTypeDef *hrng)
{
  uint32_t rngclockerror = 0U;
  uint32_t itflag   = hrng->Instance->SR;

  /* RNG clock error interrupt occurred */
  if ((itflag & RNG_IT_CEI) == RNG_IT_CEI)
  {
    /* Update the error code */
    hrng->ErrorCode = HAL_RNG_ERROR_CLOCK;
    rngclockerror = 1U;
  }
  else if ((itflag & RNG_IT_SEI) == RNG_IT_SEI)
  {
    /* Check if Seed Error Current Status (SECS) is set */
    if ((itflag & RNG_FLAG_SECS) != RNG_FLAG_SECS)
    {
      /* RNG IP performed the reset automatically (auto-reset) */
      /* Clear bit SEIS */
      CLEAR_BIT(hrng->Instance->SR, RNG_IT_SEI);
    }
    else
    {
      /* Seed Error has not been recovered : Update the error code */
      hrng->ErrorCode = HAL_RNG_ERROR_SEED;
      rngclockerror = 1U;
      /* Disable the IT */
      __HAL_RNG_DISABLE_IT(hrng);
    }
  }
  else
  {
    /* Nothing to do */
  }

  if (rngclockerror == 1U)
  {
    /* Change RNG peripheral state */
    hrng->State = HAL_RNG_STATE_ERROR;

#if (USE_HAL_RNG_REGISTER_CALLBACKS == 1)
    /* Call registered Error callback */
    hrng->ErrorCallback(hrng);
#else
    /* Call legacy weak Error callback */
    HAL_RNG_ErrorCallback(hrng);
#endif /* USE_HAL_RNG_REGISTER_CALLBACKS */

    /* Clear the clock error flag */
    __HAL_RNG_CLEAR_IT(hrng, RNG_IT_CEI | RNG_IT_SEI);

    return;
  }

  /* Check RNG data ready interrupt occurred */
  if ((itflag & RNG_IT_DRDY) == RNG_IT_DRDY)
  {
    /* Generate random number once, so disable the IT */
    __HAL_RNG_DISABLE_IT(hrng);

    /* Get the 32bit Random number (DRDY flag automatically cleared) */
    hrng->RandomNumber = hrng->Instance->DR;

    if (hrng->State != HAL_RNG_STATE_ERROR)
    {
      /* Change RNG peripheral state */
      hrng->State = HAL_RNG_STATE_READY;
      /* Process Unlocked */
      __HAL_UNLOCK(hrng);

#if (USE_HAL_RNG_REGISTER_CALLBACKS == 1)
      /* Call registered Data Ready callback */
      hrng->ReadyDataCallback(hrng, hrng->RandomNumber);
#else
      /* Call legacy weak Data Ready callback */
      HAL_RNG_ReadyDataCallback(hrng, hrng->RandomNumber);
#endif /* USE_HAL_RNG_REGISTER_CALLBACKS */
    }
  }
}

uint32_t HAL_RNG_ReadLastRandomNumber(const RNG_HandleTypeDef *hrng)
{
  return (hrng->RandomNumber);
}

__weak void HAL_RNG_ReadyDataCallback(RNG_HandleTypeDef *hrng, uint32_t random32bit)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrng);
  UNUSED(random32bit);
  /* NOTE : This function should not be modified. When the callback is needed,
            function HAL_RNG_ReadyDataCallback must be implemented in the user file.
   */
}

__weak void HAL_RNG_ErrorCallback(RNG_HandleTypeDef *hrng)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hrng);
  /* NOTE : This function should not be modified. When the callback is needed,
            function HAL_RNG_ErrorCallback must be implemented in the user file.
   */
}

HAL_RNG_StateTypeDef HAL_RNG_GetState(const RNG_HandleTypeDef *hrng)
{
  return hrng->State;
}

uint32_t HAL_RNG_GetError(const RNG_HandleTypeDef *hrng)
{
  /* Return RNG Error Code */
  return hrng->ErrorCode;
}

HAL_StatusTypeDef RNG_RecoverSeedError(RNG_HandleTypeDef *hrng)
{
  __IO uint32_t count = 0U;

  /*Check if seed error current status (SECS)is set */
  if (__HAL_RNG_GET_FLAG(hrng, RNG_FLAG_SECS) == RESET)
  {
    /* RNG performed the reset automatically (auto-reset) */
    /* Clear bit SEIS */
    CLEAR_BIT(hrng->Instance->SR, RNG_IT_SEI);
  }
  else  /* Sequence to fully recover from a seed error*/
  {
    /* Writing bit CONDRST=1*/
    SET_BIT(hrng->Instance->CR, RNG_CR_CONDRST);
    /* Writing bit CONDRST=0*/
    CLEAR_BIT(hrng->Instance->CR, RNG_CR_CONDRST);

    /* Wait for conditioning reset process to be completed */
    count = RNG_TIMEOUT_VALUE;
    do
    {
      count-- ;
      if (count == 0U)
      {
        hrng->State = HAL_RNG_STATE_READY;
        hrng->ErrorCode |= HAL_RNG_ERROR_TIMEOUT;
        /* Process Unlocked */
        __HAL_UNLOCK(hrng);
#if (USE_HAL_RNG_REGISTER_CALLBACKS == 1)
        /* Call registered Error callback */
        hrng->ErrorCallback(hrng);
#else
        /* Call legacy weak Error callback */
        HAL_RNG_ErrorCallback(hrng);
#endif /* USE_HAL_RNG_REGISTER_CALLBACKS */
        return HAL_ERROR;
      }
    } while (HAL_IS_BIT_SET(hrng->Instance->CR, RNG_CR_CONDRST));

    if (__HAL_RNG_GET_IT(hrng, RNG_IT_SEI) != RESET)
    {
      /* Clear bit SEIS */
      CLEAR_BIT(hrng->Instance->SR, RNG_IT_SEI);
    }

    /* Wait for SECS to be cleared */
    count = RNG_TIMEOUT_VALUE;
    do
    {
      count-- ;
      if (count == 0U)
      {
        hrng->State = HAL_RNG_STATE_READY;
        hrng->ErrorCode |= HAL_RNG_ERROR_TIMEOUT;
        /* Process Unlocked */
        __HAL_UNLOCK(hrng);
#if (USE_HAL_RNG_REGISTER_CALLBACKS == 1)
        /* Call registered Error callback */
        hrng->ErrorCallback(hrng);
#else
        /* Call legacy weak Error callback */
        HAL_RNG_ErrorCallback(hrng);
#endif /* USE_HAL_RNG_REGISTER_CALLBACKS */
        return HAL_ERROR;
      }
    } while (HAL_IS_BIT_SET(hrng->Instance->SR, RNG_FLAG_SECS));
  }
  /* Update the error code */
  hrng->ErrorCode &= ~ HAL_RNG_ERROR_SEED;
  return HAL_OK;
}
