// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SMBUS/SMBUSEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUSEx_EnableWakeUp(SMBUS_HandleTypeDef *hsmbus)
{
  /* Check the parameters */
  assert_param(IS_I2C_WAKEUP_FROMSTOP_INSTANCE(hsmbus->Instance));

  if (hsmbus->State == HAL_SMBUS_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hsmbus);

    hsmbus->State = HAL_SMBUS_STATE_BUSY;

    /* Disable the selected SMBUS peripheral */
    __HAL_SMBUS_DISABLE(hsmbus);

    /* Enable wakeup from stop mode */
    hsmbus->Instance->CR1 |= I2C_CR1_WUPEN;

    __HAL_SMBUS_ENABLE(hsmbus);

    hsmbus->State = HAL_SMBUS_STATE_READY;

    /* Process Unlocked */
    __HAL_UNLOCK(hsmbus);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUSEx_DisableWakeUp(SMBUS_HandleTypeDef *hsmbus)
{
  /* Check the parameters */
  assert_param(IS_I2C_WAKEUP_FROMSTOP_INSTANCE(hsmbus->Instance));

  if (hsmbus->State == HAL_SMBUS_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hsmbus);

    hsmbus->State = HAL_SMBUS_STATE_BUSY;

    /* Disable the selected SMBUS peripheral */
    __HAL_SMBUS_DISABLE(hsmbus);

    /* Disable wakeup from stop mode */
    hsmbus->Instance->CR1 &= ~(I2C_CR1_WUPEN);

    __HAL_SMBUS_ENABLE(hsmbus);

    hsmbus->State = HAL_SMBUS_STATE_READY;

    /* Process Unlocked */
    __HAL_UNLOCK(hsmbus);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUSEx_ConfigFastModePlus(SMBUS_HandleTypeDef *hsmbus, uint32_t FastModePlus)
{
  /* Check the parameters */
  assert_param(IS_SMBUS_ALL_INSTANCE(hsmbus->Instance));
  assert_param(IS_SMBUS_FASTMODEPLUS(FastModePlus));

  if (hsmbus->State == HAL_SMBUS_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hsmbus);

    hsmbus->State = HAL_SMBUS_STATE_BUSY;

    /* Disable the selected SMBUS peripheral */
    __HAL_SMBUS_DISABLE(hsmbus);

    if (FastModePlus == SMBUS_FASTMODEPLUS_ENABLE)
    {
      /* Set SMBUSx FMP bit */
      hsmbus->Instance->CR1 |= (I2C_CR1_FMP);
    }
    else
    {
      /* Reset SMBUSx FMP bit */
      hsmbus->Instance->CR1 &= ~(I2C_CR1_FMP);
    }

    __HAL_SMBUS_ENABLE(hsmbus);

    hsmbus->State = HAL_SMBUS_STATE_READY;

    /* Process Unlocked */
    __HAL_UNLOCK(hsmbus);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}
#endif
