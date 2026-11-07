// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Unchanged function bodies from HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.

HAL_StatusTypeDef HAL_GPU2D_Init(GPU2D_HandleTypeDef *hgpu2d)
{
  /* Check the GPU2D handle validity */
  if (hgpu2d == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_GPU2D_ALL_INSTANCE(hgpu2d->Instance));

  if (hgpu2d->State == HAL_GPU2D_STATE_RESET)
  {
#if (USE_HAL_GPU2D_REGISTER_CALLBACKS == 1)
    /* Reset Callback pointers in HAL_GPU2D_STATE_RESET only */
    hgpu2d->CommandListCpltCallback = HAL_GPU2D_CommandListCpltCallback;
    if (hgpu2d->MspInitCallback == NULL)
    {
      hgpu2d->MspInitCallback = HAL_GPU2D_MspInit;
    }

    /* Init the low level hardware */
    hgpu2d->MspInitCallback(hgpu2d);
#else /* USE_HAL_GPU2D_REGISTER_CALLBACKS = 0 */
    /* Init the low level hardware */
    HAL_GPU2D_MspInit(hgpu2d);
#endif /* USE_HAL_GPU2D_REGISTER_CALLBACKS = 1 */

    /* Allocate lock resource and initialize it */
    hgpu2d->Lock = HAL_UNLOCKED;
  }

  /* Process locked */
  __HAL_LOCK(hgpu2d);

#if (USE_HAL_GPU2D_REGISTER_CALLBACKS == 1)
  /* Reset the CommandListCpltCallback handler */
  hgpu2d->CommandListCpltCallback = NULL;
#endif /* USE_HAL_GPU2D_REGISTER_CALLBACKS = 1 */

  /* Update error code */
  hgpu2d->ErrorCode = HAL_GPU2D_ERROR_NONE;

  /* Initialize the GPU2D state*/
  hgpu2d->State = HAL_GPU2D_STATE_READY;

  /* Release Lock */
  __HAL_UNLOCK(hgpu2d);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_GPU2D_DeInit(GPU2D_HandleTypeDef *hgpu2d)
{
  /* Check the GPU2D handle validity */
  if (hgpu2d == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_GPU2D_ALL_INSTANCE(hgpu2d->Instance));

  /* Process locked */
  __HAL_LOCK(hgpu2d);

  if (hgpu2d->State == HAL_GPU2D_STATE_READY)
  {
#if (USE_HAL_GPU2D_REGISTER_CALLBACKS == 1)
    if (hgpu2d->MspDeInitCallback == NULL)
    {
      hgpu2d->MspDeInitCallback = HAL_GPU2D_MspDeInit;
    }

    /* DeInit the low level hardware */
    hgpu2d->MspDeInitCallback(hgpu2d);
#else /* USE_HAL_GPU2D_REGISTER_CALLBACKS = 0 */
    /* Carry on with de-initialization of low level hardware */
    HAL_GPU2D_MspDeInit(hgpu2d);
#endif /* USE_HAL_GPU2D_REGISTER_CALLBACKS = 1 */
  }

#if (USE_HAL_GPU2D_REGISTER_CALLBACKS == 1)
  /* Reset the CommandListCpltCallback handler */
  hgpu2d->CommandListCpltCallback = NULL;
#endif /* USE_HAL_GPU2D_REGISTER_CALLBACKS = 1 */

  /* Update error code */
  hgpu2d->ErrorCode = HAL_GPU2D_ERROR_NONE;

  /* Reset the GPU2D state*/
  hgpu2d->State = HAL_GPU2D_STATE_RESET;

  /* Release Lock */
  __HAL_UNLOCK(hgpu2d);

  return HAL_OK;
}

#if USE_HAL_GPU2D_REGISTER_CALLBACKS
HAL_StatusTypeDef HAL_GPU2D_RegisterCallback(GPU2D_HandleTypeDef *hgpu2d, HAL_GPU2D_CallbackIDTypeDef CallbackID,
                                             pGPU2D_CallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the GPU2D handle validity */
  if (hgpu2d == NULL)
  {
    return HAL_ERROR;
  }

  /* Process locked */
  __HAL_LOCK(hgpu2d);

  /* Check the pCallback parameter is valid or not */
  if (pCallback == NULL)
  {
    /* Update the error code */
    hgpu2d->ErrorCode |= HAL_GPU2D_ERROR_INVALID_CALLBACK;
    status = HAL_ERROR;
  }
  else
  {
    if ((hgpu2d->State == HAL_GPU2D_STATE_READY)
        || (hgpu2d->State == HAL_GPU2D_STATE_RESET))
    {
      switch (CallbackID)
      {
        case HAL_GPU2D_MSPINIT_CB_ID:
          hgpu2d->MspInitCallback = pCallback;
          break;

        case HAL_GPU2D_MSPDEINIT_CB_ID:
          hgpu2d->MspDeInitCallback = pCallback;
          break;

        default :
          /* Update the error code */
          hgpu2d->ErrorCode |= HAL_GPU2D_ERROR_INVALID_CALLBACK;
          status = HAL_ERROR;
          break;
      }
    }
    else
    {
      status = HAL_ERROR;
    }
  }

  /* Release lock */
  __HAL_UNLOCK(hgpu2d);

  return status;
}
#endif

#if USE_HAL_GPU2D_REGISTER_CALLBACKS
HAL_StatusTypeDef HAL_GPU2D_UnRegisterCallback(GPU2D_HandleTypeDef *hgpu2d, HAL_GPU2D_CallbackIDTypeDef CallbackID)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the GPU2D handle validity */
  if (hgpu2d == NULL)
  {
    return HAL_ERROR;
  }

  /* Process locked */
  __HAL_LOCK(hgpu2d);

  if ((HAL_GPU2D_STATE_READY == hgpu2d->State)
      || (HAL_GPU2D_STATE_RESET == hgpu2d->State))
  {
    switch (CallbackID)
    {
      case HAL_GPU2D_MSPINIT_CB_ID:
        hgpu2d->MspInitCallback = HAL_GPU2D_MspInit; /* Legacy weak Msp Init */
        break;

      case HAL_GPU2D_MSPDEINIT_CB_ID:
        hgpu2d->MspDeInitCallback = HAL_GPU2D_MspDeInit; /* Legacy weak Msp DeInit */
        break;

      default :
        /* Update the error code */
        hgpu2d->ErrorCode |= HAL_GPU2D_ERROR_INVALID_CALLBACK;
        status = HAL_ERROR;
        break;
    }
  }
  else
  {
    status = HAL_ERROR;
  }

  /* Release lock */
  __HAL_UNLOCK(hgpu2d);

  return status;
}
#endif

#if USE_HAL_GPU2D_REGISTER_CALLBACKS
HAL_StatusTypeDef HAL_GPU2D_RegisterCommandListCpltCallback(GPU2D_HandleTypeDef *hgpu2d,
                                                            pGPU2D_CommandListCpltCallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the GPU2D handle validity */
  if (hgpu2d == NULL)
  {
    return HAL_ERROR;
  }

  /* Process locked */
  __HAL_LOCK(hgpu2d);

  /* Check the CallbackID is valid or not */
  if (pCallback == NULL)
  {
    /* Update the error code */
    hgpu2d->ErrorCode |= HAL_GPU2D_ERROR_INVALID_CALLBACK;
    status = HAL_ERROR;
  }
  else
  {
    if ((HAL_GPU2D_STATE_READY == hgpu2d->State)
        || (HAL_GPU2D_STATE_RESET == hgpu2d->State))
    {
      hgpu2d->CommandListCpltCallback = pCallback;
    }
    else
    {
      status = HAL_ERROR;
    }
  }

  /* Release lock */
  __HAL_UNLOCK(hgpu2d);

  return status;
}
#endif

#if USE_HAL_GPU2D_REGISTER_CALLBACKS
HAL_StatusTypeDef HAL_GPU2D_UnRegisterCommandListCpltCallback(GPU2D_HandleTypeDef *hgpu2d)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the GPU2D handle validity */
  if (hgpu2d == NULL)
  {
    return HAL_ERROR;
  }

  /* Process locked */
  __HAL_LOCK(hgpu2d);

  if ((hgpu2d->State == HAL_GPU2D_STATE_READY)
      || (hgpu2d->State == HAL_GPU2D_STATE_RESET))
  {
    hgpu2d->CommandListCpltCallback = NULL; /* Invalidate the Callback pointer */
  }
  else
  {
    status =  HAL_ERROR;
  }

  /* Release Lock */
  __HAL_UNLOCK(hgpu2d);

  return status;
}
#endif

uint32_t HAL_GPU2D_ReadRegister(const GPU2D_HandleTypeDef *hgpu2d, uint32_t offset)
{
  uint32_t value;

  /* Check the GPU2D handle validity */
  assert_param(hgpu2d != NULL);

  /* Check the parameters */
  assert_param(IS_GPU2D_ALL_INSTANCE(hgpu2d->Instance));
  assert_param(IS_GPU2D_OFFSET(offset));

  /* No locking is required since reading a register is an atomic operation
   * and doesn't incur a state change in hal_gpu2d. */
  value = GPU2D_ReadReg(hgpu2d->Instance, offset);

  return value;
}

HAL_StatusTypeDef HAL_GPU2D_WriteRegister(GPU2D_HandleTypeDef *hgpu2d, uint32_t offset, uint32_t value)
{
  /* Check the GPU2D handle validity */
  assert_param(hgpu2d != NULL);

  /* Check the parameters */
  assert_param(IS_GPU2D_ALL_INSTANCE(hgpu2d->Instance));
  assert_param(IS_GPU2D_OFFSET(offset));

  /* No locking is required since writing a register is an atomic operation
   * and doesn't incur a state change in hal_gpu2d. */
  GPU2D_WriteReg(hgpu2d->Instance, offset, value);

  return HAL_OK;
}

void HAL_GPU2D_IRQHandler(GPU2D_HandleTypeDef *hgpu2d)
{
  uint32_t isr_flags = GPU2D_ReadReg(hgpu2d->Instance, GPU2D_ITCTRL);

  /* Command List Complete Interrupt management */
  if ((isr_flags & GPU2D_FLAG_CLC) != 0U)
  {
    uint32_t last_cl_id;

    /* Clear the completion flag */
    __HAL_GPU2D_CLEAR_FLAG(hgpu2d, GPU2D_FLAG_CLC);

    last_cl_id = GPU2D_ReadReg(hgpu2d->Instance, GPU2D_CLID);

    /* Command List Complete Callback */
#if (USE_HAL_GPU2D_REGISTER_CALLBACKS == 1)
    if (hgpu2d->CommandListCpltCallback != NULL)
    {
      hgpu2d->CommandListCpltCallback(hgpu2d, last_cl_id);
    }
#else /* USE_HAL_GPU2D_REGISTER_CALLBACKS = 0 */
    HAL_GPU2D_CommandListCpltCallback(hgpu2d, last_cl_id);
#endif /* USE_HAL_GPU2D_REGISTER_CALLBACKS = 1 */
  }
}

void HAL_GPU2D_ER_IRQHandler(GPU2D_HandleTypeDef *hgpu2d)
{
  HAL_GPU2D_ErrorCallback(hgpu2d);
}

HAL_GPU2D_StateTypeDef HAL_GPU2D_GetState(GPU2D_HandleTypeDef const *const hgpu2d)
{
  return hgpu2d->State;
}

uint32_t HAL_GPU2D_GetError(GPU2D_HandleTypeDef const *const hgpu2d)
{
  return hgpu2d->ErrorCode;
}
