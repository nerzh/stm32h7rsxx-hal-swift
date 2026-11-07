/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted without body changes from STM32H7RS HAL at
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
#define HAL_IWDG_DEFAULT_TIMEOUT        (((1UL * 1024UL * 1000UL) / (LSI_VALUE / 128U)) + \
                                         ((LSI_STARTUP_TIME / 1000UL) + 1UL))
#define IWDG_KERNEL_UPDATE_FLAGS        (IWDG_SR_EWU | IWDG_SR_WVU | IWDG_SR_RVU | IWDG_SR_PVU)
HAL_StatusTypeDef HAL_IWDG_Init(IWDG_HandleTypeDef *hiwdg)
{
  uint32_t tickstart;

  /* Check the IWDG handle allocation */
  if (hiwdg == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_IWDG_ALL_INSTANCE(hiwdg->Instance));
  assert_param(IS_IWDG_PRESCALER(hiwdg->Init.Prescaler));
  assert_param(IS_IWDG_RELOAD(hiwdg->Init.Reload));
  assert_param(IS_IWDG_WINDOW(hiwdg->Init.Window));
  assert_param(IS_IWDG_EWI(hiwdg->Init.EWI));

#if (USE_HAL_IWDG_REGISTER_CALLBACKS == 1)
  /* Reset Callback pointers */
  if (hiwdg->EwiCallback == NULL)
  {
    hiwdg->EwiCallback = HAL_IWDG_EarlyWakeupCallback;
  }
  if (hiwdg->MspInitCallback == NULL)
  {
    hiwdg->MspInitCallback = HAL_IWDG_MspInit;
  }

  /* Init the low level hardware */
  hiwdg->MspInitCallback(hiwdg);
#else
  /* Init the low level hardware */
  HAL_IWDG_MspInit(hiwdg);
#endif /* USE_HAL_IWDG_REGISTER_CALLBACKS */

  /* Enable IWDG. LSI is turned on automatically */
  __HAL_IWDG_START(hiwdg);

  /* Enable write access to IWDG_PR, IWDG_RLR, IWDG_WINR and EWCR registers by writing
  0x5555 in KR */
  IWDG_ENABLE_WRITE_ACCESS(hiwdg);

  /* Write to IWDG registers the Prescaler & Reload values to work with */
  hiwdg->Instance->PR = hiwdg->Init.Prescaler;
  hiwdg->Instance->RLR = hiwdg->Init.Reload;

  /* Check Reload update flag, before performing any reload of the counter, else previous value
  will be taken. */
  tickstart = HAL_GetTick();

  /* Wait for register to be updated */
  while ((hiwdg->Instance->SR & IWDG_SR_RVU) != 0x00u)
  {
    if ((HAL_GetTick() - tickstart) > HAL_IWDG_DEFAULT_TIMEOUT)
    {
      if ((hiwdg->Instance->SR & IWDG_SR_RVU) != 0x00u)
      {
        return HAL_TIMEOUT;
      }
    }
  }

  if (hiwdg->Init.EWI == IWDG_EWI_DISABLE)
  {
    /* EWI comparator value equal 0, disable the early wakeup interrupt
     * acknowledge the early wakeup interrupt in any cases. it clears the EWIF flag in SR register
     * Set Watchdog Early Wakeup Comparator to 0x00 */
    hiwdg->Instance->EWCR = IWDG_EWCR_EWIC;
  }
  else
  {
    /* EWI comparator value different from 0, enable the early wakeup interrupt,
     * acknowledge the early wakeup interrupt in any cases. it clears the EWIF flag in SR register
     * Set Watchdog Early Wakeup Comparator value */
    hiwdg->Instance->EWCR = IWDG_EWCR_EWIE | IWDG_EWCR_EWIC | hiwdg->Init.EWI;
  }

  /* Check pending flag, if previous update not done, return timeout */
  tickstart = HAL_GetTick();

  /* Wait for register to be updated */
  while ((hiwdg->Instance->SR & IWDG_KERNEL_UPDATE_FLAGS) != 0x00u)
  {
    if ((HAL_GetTick() - tickstart) > HAL_IWDG_DEFAULT_TIMEOUT)
    {
      if ((hiwdg->Instance->SR & IWDG_KERNEL_UPDATE_FLAGS) != 0x00u)
      {
        return HAL_TIMEOUT;
      }
    }
  }

  /* If window parameter is different than current value, modify window
  register */
  if (hiwdg->Instance->WINR != hiwdg->Init.Window)
  {
    /* Write to IWDG WINR the IWDG_Window value to compare with. In any case,
    even if window feature is disabled, Watchdog will be reloaded by writing
    windows register */
    hiwdg->Instance->WINR = hiwdg->Init.Window;
  }
  else
  {
    /* Reload IWDG counter with value defined in the reload register */
    __HAL_IWDG_RELOAD_COUNTER(hiwdg);
  }

  /* Return function status */
  return HAL_OK;
}

__weak void HAL_IWDG_MspInit(IWDG_HandleTypeDef *hiwdg)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hiwdg);

  /* NOTE: This function should not be modified, when the callback is needed,
           the HAL_IWDG_MspInit could be implemented in the user file
   */
}

#if USE_HAL_IWDG_REGISTER_CALLBACKS == 1
HAL_StatusTypeDef HAL_IWDG_RegisterCallback(IWDG_HandleTypeDef *hiwdg, HAL_IWDG_CallbackIDTypeDef CallbackID,
                                            pIWDG_CallbackTypeDef pCallback)
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
      case HAL_IWDG_EWI_CB_ID:
        hiwdg->EwiCallback = pCallback;
        break;
      case HAL_IWDG_MSPINIT_CB_ID:
        hiwdg->MspInitCallback = pCallback;
        break;

      default:
        status = HAL_ERROR;
        break;
    }
  }

  return status;
}
#endif

#if USE_HAL_IWDG_REGISTER_CALLBACKS == 1
HAL_StatusTypeDef HAL_IWDG_UnRegisterCallback(IWDG_HandleTypeDef *hiwdg, HAL_IWDG_CallbackIDTypeDef CallbackID)
{
  HAL_StatusTypeDef status = HAL_OK;

  switch (CallbackID)
  {
    case HAL_IWDG_EWI_CB_ID:
      hiwdg->EwiCallback = HAL_IWDG_EarlyWakeupCallback;
      break;
    case HAL_IWDG_MSPINIT_CB_ID:
      hiwdg->MspInitCallback = HAL_IWDG_MspInit;
      break;

    default:
      status = HAL_ERROR;
      break;
  }

  return status;
}
#endif

HAL_StatusTypeDef HAL_IWDG_Refresh(IWDG_HandleTypeDef *hiwdg)
{
  /* Reload IWDG counter with value defined in the reload register */
  __HAL_IWDG_RELOAD_COUNTER(hiwdg);

  /* Return function status */
  return HAL_OK;
}

uint32_t HAL_IWDG_GetActiveStatus(const IWDG_HandleTypeDef *hiwdg)
{
  uint32_t status;

  /* Get back ONF flag */
  status = (hiwdg->Instance->SR & IWDG_SR_ONF);

  /* Return status */
  return status;
}

void HAL_IWDG_IRQHandler(IWDG_HandleTypeDef *hiwdg)
{
  /* Check if IWDG Early Wakeup Interrupt occurred */
  if ((hiwdg->Instance->SR & IWDG_SR_EWIF) != 0x00u)
  {
    /* Clear the IWDG Early Wakeup flag */
    hiwdg->Instance->EWCR |= IWDG_EWCR_EWIC;

#if (USE_HAL_IWDG_REGISTER_CALLBACKS == 1)
    /* Early Wakeup registered callback */
    hiwdg->EwiCallback(hiwdg);
#else
    /* Early Wakeup callback */
    HAL_IWDG_EarlyWakeupCallback(hiwdg);
#endif /* USE_HAL_IWDG_REGISTER_CALLBACKS */
  }
}

__weak void HAL_IWDG_EarlyWakeupCallback(IWDG_HandleTypeDef *hiwdg)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(hiwdg);

  /* NOTE: This function should not be modified, when the callback is needed,
           the HAL_IWDG_EarlyWakeupCallback could be implemented in the user file
   */
}
