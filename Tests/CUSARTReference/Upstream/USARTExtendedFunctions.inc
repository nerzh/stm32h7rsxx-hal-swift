// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USART/USARTEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

HAL_StatusTypeDef HAL_USARTEx_EnableSlaveMode(USART_HandleTypeDef *husart)
{
  uint32_t tmpcr1;

  /* Check parameters */
  assert_param(IS_UART_SPI_SLAVE_INSTANCE(husart->Instance));

  /* Process Locked */
  __HAL_LOCK(husart);

  husart->State = HAL_USART_STATE_BUSY;

  /* Save actual USART configuration */
  tmpcr1 = READ_REG(husart->Instance->CR1);

  /* Disable USART */
  __HAL_USART_DISABLE(husart);

  /* In SPI slave mode mode, the following bits must be kept cleared:
  - LINEN and CLKEN bit in the USART_CR2 register
  - HDSEL, SCEN and IREN bits in the USART_CR3 register.*/
  CLEAR_BIT(husart->Instance->CR2, (USART_CR2_LINEN | USART_CR2_CLKEN));
  CLEAR_BIT(husart->Instance->CR3, (USART_CR3_SCEN | USART_CR3_HDSEL | USART_CR3_IREN));

  /* Enable SPI slave mode */
  SET_BIT(husart->Instance->CR2, USART_CR2_SLVEN);

  /* Restore USART configuration */
  WRITE_REG(husart->Instance->CR1, tmpcr1);

  husart->SlaveMode = USART_SLAVEMODE_ENABLE;

  husart->State = HAL_USART_STATE_READY;

  /* Enable USART */
  __HAL_USART_ENABLE(husart);

  /* Process Unlocked */
  __HAL_UNLOCK(husart);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_USARTEx_DisableSlaveMode(USART_HandleTypeDef *husart)
{
  uint32_t tmpcr1;

  /* Check parameters */
  assert_param(IS_UART_SPI_SLAVE_INSTANCE(husart->Instance));

  /* Process Locked */
  __HAL_LOCK(husart);

  husart->State = HAL_USART_STATE_BUSY;

  /* Save actual USART configuration */
  tmpcr1 = READ_REG(husart->Instance->CR1);

  /* Disable USART */
  __HAL_USART_DISABLE(husart);

  /* Disable SPI slave mode */
  CLEAR_BIT(husart->Instance->CR2, USART_CR2_SLVEN);

  /* Restore USART configuration */
  WRITE_REG(husart->Instance->CR1, tmpcr1);

  husart->SlaveMode = USART_SLAVEMODE_DISABLE;

  husart->State = HAL_USART_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(husart);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_USARTEx_ConfigNSS(USART_HandleTypeDef *husart, uint32_t NSSConfig)
{
  uint32_t tmpcr1;

  /* Check parameters */
  assert_param(IS_UART_SPI_SLAVE_INSTANCE(husart->Instance));
  assert_param(IS_USART_NSS(NSSConfig));

  /* Process Locked */
  __HAL_LOCK(husart);

  husart->State = HAL_USART_STATE_BUSY;

  /* Save actual USART configuration */
  tmpcr1 = READ_REG(husart->Instance->CR1);

  /* Disable USART */
  __HAL_USART_DISABLE(husart);

  /* Program DIS_NSS bit in the USART_CR2 register */
  MODIFY_REG(husart->Instance->CR2, USART_CR2_DIS_NSS, NSSConfig);

  /* Restore USART configuration */
  WRITE_REG(husart->Instance->CR1, tmpcr1);

  husart->State = HAL_USART_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(husart);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_USARTEx_EnableFifoMode(USART_HandleTypeDef *husart)
{
  uint32_t tmpcr1;

  /* Check parameters */
  assert_param(IS_UART_FIFO_INSTANCE(husart->Instance));

  /* Process Locked */
  __HAL_LOCK(husart);

  husart->State = HAL_USART_STATE_BUSY;

  /* Save actual USART configuration */
  tmpcr1 = READ_REG(husart->Instance->CR1);

  /* Disable USART */
  __HAL_USART_DISABLE(husart);

  /* Enable FIFO mode */
  SET_BIT(tmpcr1, USART_CR1_FIFOEN);
  husart->FifoMode = USART_FIFOMODE_ENABLE;

  /* Restore USART configuration */
  WRITE_REG(husart->Instance->CR1, tmpcr1);

  /* Determine the number of data to process during RX/TX ISR execution */
  USARTEx_SetNbDataToProcess(husart);

  husart->State = HAL_USART_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(husart);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_USARTEx_DisableFifoMode(USART_HandleTypeDef *husart)
{
  uint32_t tmpcr1;

  /* Check parameters */
  assert_param(IS_UART_FIFO_INSTANCE(husart->Instance));

  /* Process Locked */
  __HAL_LOCK(husart);

  husart->State = HAL_USART_STATE_BUSY;

  /* Save actual USART configuration */
  tmpcr1 = READ_REG(husart->Instance->CR1);

  /* Disable USART */
  __HAL_USART_DISABLE(husart);

  /* Disable FIFO mode */
  CLEAR_BIT(tmpcr1, USART_CR1_FIFOEN);
  husart->FifoMode = USART_FIFOMODE_DISABLE;

  /* Restore USART configuration */
  WRITE_REG(husart->Instance->CR1, tmpcr1);

  husart->State = HAL_USART_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(husart);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_USARTEx_SetTxFifoThreshold(USART_HandleTypeDef *husart, uint32_t Threshold)
{
  uint32_t tmpcr1;

  /* Check parameters */
  assert_param(IS_UART_FIFO_INSTANCE(husart->Instance));
  assert_param(IS_USART_TXFIFO_THRESHOLD(Threshold));

  /* Process Locked */
  __HAL_LOCK(husart);

  husart->State = HAL_USART_STATE_BUSY;

  /* Save actual USART configuration */
  tmpcr1 = READ_REG(husart->Instance->CR1);

  /* Disable USART */
  __HAL_USART_DISABLE(husart);

  /* Update TX threshold configuration */
  MODIFY_REG(husart->Instance->CR3, USART_CR3_TXFTCFG, Threshold);

  /* Determine the number of data to process during RX/TX ISR execution */
  USARTEx_SetNbDataToProcess(husart);

  /* Restore USART configuration */
  WRITE_REG(husart->Instance->CR1, tmpcr1);

  husart->State = HAL_USART_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(husart);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_USARTEx_SetRxFifoThreshold(USART_HandleTypeDef *husart, uint32_t Threshold)
{
  uint32_t tmpcr1;

  /* Check the parameters */
  assert_param(IS_UART_FIFO_INSTANCE(husart->Instance));
  assert_param(IS_USART_RXFIFO_THRESHOLD(Threshold));

  /* Process Locked */
  __HAL_LOCK(husart);

  husart->State = HAL_USART_STATE_BUSY;

  /* Save actual USART configuration */
  tmpcr1 = READ_REG(husart->Instance->CR1);

  /* Disable USART */
  __HAL_USART_DISABLE(husart);

  /* Update RX threshold configuration */
  MODIFY_REG(husart->Instance->CR3, USART_CR3_RXFTCFG, Threshold);

  /* Determine the number of data to process during RX/TX ISR execution */
  USARTEx_SetNbDataToProcess(husart);

  /* Restore USART configuration */
  WRITE_REG(husart->Instance->CR1, tmpcr1);

  husart->State = HAL_USART_STATE_READY;

  /* Process Unlocked */
  __HAL_UNLOCK(husart);

  return HAL_OK;
}

static void USARTEx_SetNbDataToProcess(USART_HandleTypeDef *husart)
{
  uint8_t rx_fifo_depth;
  uint8_t tx_fifo_depth;
  uint8_t rx_fifo_threshold;
  uint8_t tx_fifo_threshold;
  /* 2 0U/1U added for MISRAC2012-Rule-18.1_b and MISRAC2012-Rule-18.1_d */
  static const uint8_t numerator[]   = {1U, 1U, 1U, 3U, 7U, 1U, 0U, 0U};
  static const uint8_t denominator[] = {8U, 4U, 2U, 4U, 8U, 1U, 1U, 1U};

  if (husart->FifoMode == USART_FIFOMODE_DISABLE)
  {
    husart->NbTxDataToProcess = 1U;
    husart->NbRxDataToProcess = 1U;
  }
  else
  {
    rx_fifo_depth = RX_FIFO_DEPTH;
    tx_fifo_depth = TX_FIFO_DEPTH;
    rx_fifo_threshold = (uint8_t)((READ_BIT(husart->Instance->CR3,
                                            USART_CR3_RXFTCFG) >> USART_CR3_RXFTCFG_Pos) & 0xFFU);
    tx_fifo_threshold = (uint8_t)((READ_BIT(husart->Instance->CR3,
                                            USART_CR3_TXFTCFG) >> USART_CR3_TXFTCFG_Pos) & 0xFFU);
    husart->NbTxDataToProcess = ((uint16_t)tx_fifo_depth * numerator[tx_fifo_threshold]) /
                                (uint16_t)denominator[tx_fifo_threshold];
    husart->NbRxDataToProcess = ((uint16_t)rx_fifo_depth * numerator[rx_fifo_threshold]) /
                                (uint16_t)denominator[rx_fifo_threshold];
  }
}
