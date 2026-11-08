// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SMARTCARD/SMARTCARDEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

void HAL_SMARTCARDEx_BlockLength_Config(SMARTCARD_HandleTypeDef *hsmartcard, uint8_t BlockLength)
{
  MODIFY_REG(hsmartcard->Instance->RTOR, USART_RTOR_BLEN, ((uint32_t)BlockLength << USART_RTOR_BLEN_Pos));
}

void HAL_SMARTCARDEx_TimeOut_Config(SMARTCARD_HandleTypeDef *hsmartcard, uint32_t TimeOutValue)
{
  assert_param(IS_SMARTCARD_TIMEOUT_VALUE(hsmartcard->Init.TimeOutValue));
  MODIFY_REG(hsmartcard->Instance->RTOR, USART_RTOR_RTO, TimeOutValue);
}

HAL_StatusTypeDef HAL_SMARTCARDEx_EnableReceiverTimeOut(SMARTCARD_HandleTypeDef *hsmartcard)
{
  if (hsmartcard->gState == HAL_SMARTCARD_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hsmartcard);

    hsmartcard->gState = HAL_SMARTCARD_STATE_BUSY;

    /* Set the USART RTOEN bit */
    SET_BIT(hsmartcard->Instance->CR2, USART_CR2_RTOEN);

    hsmartcard->gState = HAL_SMARTCARD_STATE_READY;

    /* Process Unlocked */
    __HAL_UNLOCK(hsmartcard);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}

HAL_StatusTypeDef HAL_SMARTCARDEx_DisableReceiverTimeOut(SMARTCARD_HandleTypeDef *hsmartcard)
{
  if (hsmartcard->gState == HAL_SMARTCARD_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hsmartcard);

    hsmartcard->gState = HAL_SMARTCARD_STATE_BUSY;

    /* Clear the USART RTOEN bit */
    CLEAR_BIT(hsmartcard->Instance->CR2, USART_CR2_RTOEN);

    hsmartcard->gState = HAL_SMARTCARD_STATE_READY;

    /* Process Unlocked */
    __HAL_UNLOCK(hsmartcard);

    return HAL_OK;
  }
  else
  {
    return HAL_BUSY;
  }
}

HAL_StatusTypeDef HAL_SMARTCARDEx_EnableFifoMode(SMARTCARD_HandleTypeDef *hsmartcard)
{
  uint32_t tmpcr1;

  /* Check parameters */
  assert_param(IS_UART_FIFO_INSTANCE(hsmartcard->Instance));

  /* Process Locked */
  __HAL_LOCK(hsmartcard);

  hsmartcard->gState = HAL_SMARTCARD_STATE_BUSY;

  /* Save actual SMARTCARD configuration */
  tmpcr1 = READ_REG(hsmartcard->Instance->CR1);

  /* Disable SMARTCARD */
  __HAL_SMARTCARD_DISABLE(hsmartcard);

  /* Enable FIFO mode */
  SET_BIT(tmpcr1, USART_CR1_FIFOEN);
  hsmartcard->FifoMode = SMARTCARD_FIFOMODE_ENABLE;

  /* Restore SMARTCARD configuration */
  WRITE_REG(hsmartcard->Instance->CR1, tmpcr1);

  /* Determine the number of data to process during RX/TX ISR execution */
  SMARTCARDEx_SetNbDataToProcess(hsmartcard);

  hsmartcard->gState = HAL_SMARTCARD_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(hsmartcard);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_SMARTCARDEx_DisableFifoMode(SMARTCARD_HandleTypeDef *hsmartcard)
{
  uint32_t tmpcr1;

  /* Check parameters */
  assert_param(IS_UART_FIFO_INSTANCE(hsmartcard->Instance));

  /* Process Locked */
  __HAL_LOCK(hsmartcard);

  hsmartcard->gState = HAL_SMARTCARD_STATE_BUSY;

  /* Save actual SMARTCARD configuration */
  tmpcr1 = READ_REG(hsmartcard->Instance->CR1);

  /* Disable SMARTCARD */
  __HAL_SMARTCARD_DISABLE(hsmartcard);

  /* Enable FIFO mode */
  CLEAR_BIT(tmpcr1, USART_CR1_FIFOEN);
  hsmartcard->FifoMode = SMARTCARD_FIFOMODE_DISABLE;

  /* Restore SMARTCARD configuration */
  WRITE_REG(hsmartcard->Instance->CR1, tmpcr1);

  hsmartcard->gState = HAL_SMARTCARD_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(hsmartcard);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_SMARTCARDEx_SetTxFifoThreshold(SMARTCARD_HandleTypeDef *hsmartcard, uint32_t Threshold)
{
  uint32_t tmpcr1;

  /* Check parameters */
  assert_param(IS_UART_FIFO_INSTANCE(hsmartcard->Instance));
  assert_param(IS_SMARTCARD_TXFIFO_THRESHOLD(Threshold));

  /* Process Locked */
  __HAL_LOCK(hsmartcard);

  hsmartcard->gState = HAL_SMARTCARD_STATE_BUSY;

  /* Save actual SMARTCARD configuration */
  tmpcr1 = READ_REG(hsmartcard->Instance->CR1);

  /* Disable SMARTCARD */
  __HAL_SMARTCARD_DISABLE(hsmartcard);

  /* Update TX threshold configuration */
  MODIFY_REG(hsmartcard->Instance->CR3, USART_CR3_TXFTCFG, Threshold);

  /* Determine the number of data to process during RX/TX ISR execution */
  SMARTCARDEx_SetNbDataToProcess(hsmartcard);

  /* Restore SMARTCARD configuration */
  MODIFY_REG(hsmartcard->Instance->CR1, USART_CR1_UE, tmpcr1);

  hsmartcard->gState = HAL_SMARTCARD_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(hsmartcard);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_SMARTCARDEx_SetRxFifoThreshold(SMARTCARD_HandleTypeDef *hsmartcard, uint32_t Threshold)
{
  uint32_t tmpcr1;

  /* Check parameters */
  assert_param(IS_UART_FIFO_INSTANCE(hsmartcard->Instance));
  assert_param(IS_SMARTCARD_RXFIFO_THRESHOLD(Threshold));

  /* Process Locked */
  __HAL_LOCK(hsmartcard);

  hsmartcard->gState = HAL_SMARTCARD_STATE_BUSY;

  /* Save actual SMARTCARD configuration */
  tmpcr1 = READ_REG(hsmartcard->Instance->CR1);

  /* Disable SMARTCARD */
  __HAL_SMARTCARD_DISABLE(hsmartcard);

  /* Update RX threshold configuration */
  MODIFY_REG(hsmartcard->Instance->CR3, USART_CR3_RXFTCFG, Threshold);

  /* Determine the number of data to process during RX/TX ISR execution */
  SMARTCARDEx_SetNbDataToProcess(hsmartcard);

  /* Restore SMARTCARD configuration */
  MODIFY_REG(hsmartcard->Instance->CR1, USART_CR1_UE, tmpcr1);

  hsmartcard->gState = HAL_SMARTCARD_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(hsmartcard);

  return HAL_OK;
}

static void SMARTCARDEx_SetNbDataToProcess(SMARTCARD_HandleTypeDef *hsmartcard)
{
  uint8_t rx_fifo_depth;
  uint8_t tx_fifo_depth;
  uint8_t rx_fifo_threshold;
  uint8_t tx_fifo_threshold;
  /* 2 0U/1U added for MISRAC2012-Rule-18.1_b and MISRAC2012-Rule-18.1_d */
  static const uint8_t numerator[]   = {1U, 1U, 1U, 3U, 7U, 1U, 0U, 0U};
  static const uint8_t denominator[] = {8U, 4U, 2U, 4U, 8U, 1U, 1U, 1U};

  if (hsmartcard->FifoMode == SMARTCARD_FIFOMODE_DISABLE)
  {
    hsmartcard->NbTxDataToProcess = 1U;
    hsmartcard->NbRxDataToProcess = 1U;
  }
  else
  {
    rx_fifo_depth = RX_FIFO_DEPTH;
    tx_fifo_depth = TX_FIFO_DEPTH;
    rx_fifo_threshold = (uint8_t)(READ_BIT(hsmartcard->Instance->CR3, USART_CR3_RXFTCFG) >> USART_CR3_RXFTCFG_Pos);
    tx_fifo_threshold = (uint8_t)(READ_BIT(hsmartcard->Instance->CR3, USART_CR3_TXFTCFG) >> USART_CR3_TXFTCFG_Pos);
    hsmartcard->NbTxDataToProcess = ((uint16_t)tx_fifo_depth * numerator[tx_fifo_threshold]) / \
                                    (uint16_t)denominator[tx_fifo_threshold];
    hsmartcard->NbRxDataToProcess = ((uint16_t)rx_fifo_depth * numerator[rx_fifo_threshold]) / \
                                    (uint16_t)denominator[rx_fifo_threshold];
  }
}
