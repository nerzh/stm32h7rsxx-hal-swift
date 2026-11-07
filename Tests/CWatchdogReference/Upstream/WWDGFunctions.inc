/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted without body changes from STM32H7RS HAL at
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
HAL_StatusTypeDef HAL_WWDG_Init(WWDG_HandleTypeDef *hwwdg)
{
  /* Check the WWDG handle allocation */
  if (hwwdg == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_WWDG_ALL_INSTANCE(hwwdg->Instance));
  assert_param(IS_WWDG_PRESCALER(hwwdg->Init.Prescaler));
  assert_param(IS_WWDG_WINDOW(hwwdg->Init.Window));
  assert_param(IS_WWDG_COUNTER(hwwdg->Init.Counter));
  assert_param(IS_WWDG_EWI_MODE(hwwdg->Init.EWIMode));

#if (USE_HAL_WWDG_REGISTER_CALLBACKS == 1)
  /* Reset Callback pointers */
  if (hwwdg->EwiCallback == NULL)
  {
    hwwdg->EwiCallback = HAL_WWDG_EarlyWakeupCallback;
  }

  if (hwwdg->MspInitCallback == NULL)
  {
    hwwdg->MspInitCallback = HAL_WWDG_MspInit;
  }

  /* Init the low level hardware */
  hwwdg->MspInitCallback(hwwdg);
#else
  /* Init the low level hardware */
  HAL_WWDG_MspInit(hwwdg);
#endif /* USE_HAL_WWDG_REGISTER_CALLBACKS */

  /* Set WWDG Counter */
  WRITE_REG(hwwdg->Instance->CR, (WWDG_CR_WDGA | hwwdg->Init.Counter));

  /* Set WWDG Prescaler and Window */
  WRITE_REG(hwwdg->Instance->CFR, (hwwdg->Init.EWIMode | hwwdg->Init.Prescaler | hwwdg->Init.Window));

  /* Return function status */
  return HAL_OK;
}

__weak void HAL_WWDG_MspInit(WWDG_HandleTypeDef *hwwdg)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hwwdg);

  /* NOTE: This function should not be modified, when the callback is needed,
           the HAL_WWDG_MspInit could be implemented in the user file
   */
}

#if USE_HAL_WWDG_REGISTER_CALLBACKS == 1
HAL_StatusTypeDef HAL_WWDG_RegisterCallback(WWDG_HandleTypeDef *hwwdg, HAL_WWDG_CallbackIDTypeDef CallbackID,
                                            pWWDG_CallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    status = HAL_ERROR;
  }
  else
  {
    switch (CallbackID)
    {
      case HAL_WWDG_EWI_CB_ID:
        hwwdg->EwiCallback = pCallback;
        break;

      case HAL_WWDG_MSPINIT_CB_ID:
        hwwdg->MspInitCallback = pCallback;
        break;

      default:
        status = HAL_ERROR;
        break;
    }
  }

  return status;
}
#endif

#if USE_HAL_WWDG_REGISTER_CALLBACKS == 1
HAL_StatusTypeDef HAL_WWDG_UnRegisterCallback(WWDG_HandleTypeDef *hwwdg, HAL_WWDG_CallbackIDTypeDef CallbackID)
{
  HAL_StatusTypeDef status = HAL_OK;

  switch (CallbackID)
  {
    case HAL_WWDG_EWI_CB_ID:
      hwwdg->EwiCallback = HAL_WWDG_EarlyWakeupCallback;
      break;

    case HAL_WWDG_MSPINIT_CB_ID:
      hwwdg->MspInitCallback = HAL_WWDG_MspInit;
      break;

    default:
      status = HAL_ERROR;
      break;
  }

  return status;
}
#endif

HAL_StatusTypeDef HAL_WWDG_Refresh(WWDG_HandleTypeDef *hwwdg)
{
  /* Write to WWDG CR the WWDG Counter value to refresh with */
  WRITE_REG(hwwdg->Instance->CR, (hwwdg->Init.Counter));

  /* Return function status */
  return HAL_OK;
}

void HAL_WWDG_IRQHandler(WWDG_HandleTypeDef *hwwdg)
{
  /* Check if Early Wakeup Interrupt is enable */
  if (__HAL_WWDG_GET_IT_SOURCE(hwwdg, WWDG_IT_EWI) != RESET)
  {
    /* Check if WWDG Early Wakeup Interrupt occurred */
    if (__HAL_WWDG_GET_FLAG(hwwdg, WWDG_FLAG_EWIF) != RESET)
    {
      /* Clear the WWDG Early Wakeup flag */
      __HAL_WWDG_CLEAR_FLAG(hwwdg, WWDG_FLAG_EWIF);

#if (USE_HAL_WWDG_REGISTER_CALLBACKS == 1)
      /* Early Wakeup registered callback */
      hwwdg->EwiCallback(hwwdg);
#else
      /* Early Wakeup callback */
      HAL_WWDG_EarlyWakeupCallback(hwwdg);
#endif /* USE_HAL_WWDG_REGISTER_CALLBACKS */
    }
  }
}

__weak void HAL_WWDG_EarlyWakeupCallback(WWDG_HandleTypeDef *hwwdg)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hwwdg);

  /* NOTE: This function should not be modified, when the callback is needed,
           the HAL_WWDG_EarlyWakeupCallback could be implemented in the user file
   */
}
