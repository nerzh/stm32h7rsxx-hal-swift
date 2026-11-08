// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USART/USARTEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

#define USART_DUMMY_DATA          ((uint16_t) 0xFFFF)
#define USART_TEACK_REACK_TIMEOUT             1000U
#define USART_CR1_FIELDS          ((uint32_t)(USART_CR1_M |  USART_CR1_PCE | USART_CR1_PS    | \
                                              USART_CR1_TE | USART_CR1_RE  | USART_CR1_OVER8 | \
                                              USART_CR1_FIFOEN ))
#define USART_CR2_FIELDS          ((uint32_t)(USART_CR2_CPHA | USART_CR2_CPOL | USART_CR2_CLKEN | \
                                              USART_CR2_LBCL | USART_CR2_STOP | USART_CR2_SLVEN | \
                                              USART_CR2_DIS_NSS))
#define USART_CR3_FIELDS          ((uint32_t)(USART_CR3_TXFTCFG | USART_CR3_RXFTCFG ))
#define USART_BRR_MIN    0x10U
#define USART_BRR_MAX    0xFFFFU
#define RX_FIFO_DEPTH 16U
#define TX_FIFO_DEPTH 16U
