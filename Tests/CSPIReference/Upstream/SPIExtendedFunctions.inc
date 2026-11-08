// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SPI/SPIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

#ifdef HAL_SPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SPIEx_FlushRxFifo(const SPI_HandleTypeDef *hspi)
{
  uint8_t  count  = 0;
  uint32_t itflag = hspi->Instance->SR;
  __IO uint32_t tmpreg;

  while (((hspi->Instance->SR & SPI_FLAG_FRLVL) !=  SPI_RX_FIFO_0PACKET) || ((itflag & SPI_FLAG_RXWNE) !=  0UL))
  {
    count += (uint8_t)4UL;
    tmpreg = hspi->Instance->RXDR;
    UNUSED(tmpreg); /* To avoid GCC warning */

    if (IS_SPI_FULL_INSTANCE(hspi->Instance))
    {
      if (count > SPI_HIGHEND_FIFO_SIZE)
      {
        return HAL_TIMEOUT;
      }
    }
    else
    {
      if (count > SPI_LOWEND_FIFO_SIZE)
      {
        return HAL_TIMEOUT;
      }
    }
  }
  return HAL_OK;
}
#endif

#ifdef HAL_SPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SPIEx_EnableLockConfiguration(SPI_HandleTypeDef *hspi)
{
  HAL_StatusTypeDef errorcode = HAL_OK;

  /* Process Locked */
  __HAL_LOCK(hspi);

  if (hspi->State != HAL_SPI_STATE_READY)
  {
    errorcode = HAL_BUSY;
    hspi->State = HAL_SPI_STATE_READY;
    /* Process Unlocked */
    __HAL_UNLOCK(hspi);
    return errorcode;
  }

  /* Check if the SPI is disabled to edit IOLOCK bit */
  if ((hspi->Instance->CR1 & SPI_CR1_SPE) != SPI_CR1_SPE)
  {
    SET_BIT(hspi->Instance->CR1, SPI_CR1_IOLOCK);
  }
  else
  {
    /* Disable SPI peripheral */
    __HAL_SPI_DISABLE(hspi);

    SET_BIT(hspi->Instance->CR1, SPI_CR1_IOLOCK);

    /* Enable SPI peripheral */
    __HAL_SPI_ENABLE(hspi);
  }

  hspi->State = HAL_SPI_STATE_READY;
  /* Process Unlocked */
  __HAL_UNLOCK(hspi);
  return errorcode;
}
#endif

#ifdef HAL_SPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SPIEx_ConfigureUnderrun(SPI_HandleTypeDef *hspi, uint32_t UnderrunDetection,
                                              uint32_t UnderrunBehaviour)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(UnderrunDetection);

  HAL_StatusTypeDef errorcode = HAL_OK;

  /* Process Locked */
  __HAL_LOCK(hspi);

  /* Check State and Insure that Underrun configuration is managed only by Salve */
  if ((hspi->State != HAL_SPI_STATE_READY) || (hspi->Init.Mode != SPI_MODE_SLAVE))
  {
    errorcode = HAL_BUSY;
    hspi->State = HAL_SPI_STATE_READY;
    /* Process Unlocked */
    __HAL_UNLOCK(hspi);
    return errorcode;
  }

  /* Check the parameters */
  assert_param(IS_SPI_UNDERRUN_BEHAVIOUR(UnderrunBehaviour));

  /* Check if the SPI is disabled to edit CFG1 register */
  if ((hspi->Instance->CR1 & SPI_CR1_SPE) != SPI_CR1_SPE)
  {
    /* Configure Underrun fields */
    MODIFY_REG(hspi->Instance->CFG1, SPI_CFG1_UDRCFG, UnderrunBehaviour);
  }
  else
  {
    /* Disable SPI peripheral */
    __HAL_SPI_DISABLE(hspi);

    /* Configure Underrun fields */
    MODIFY_REG(hspi->Instance->CFG1, SPI_CFG1_UDRCFG, UnderrunBehaviour);

    /* Enable SPI peripheral */
    __HAL_SPI_ENABLE(hspi);
  }


  hspi->State = HAL_SPI_STATE_READY;
  /* Process Unlocked */
  __HAL_UNLOCK(hspi);
  return errorcode;
}
#endif
