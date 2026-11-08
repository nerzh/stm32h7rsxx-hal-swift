// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// IRDA operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

#define IRDA_TEACK_REACK_TIMEOUT            1000U
#define IRDA_CR1_FIELDS  ((uint32_t)(USART_CR1_M | USART_CR1_PCE \
                                     | USART_CR1_PS | USART_CR1_TE | USART_CR1_RE))
#define USART_BRR_MIN    0x10U
#define USART_BRR_MAX    0x0000FFFFU
#define IRDA_DIV_SAMPLING16(__PCLK__, __BAUD__, __PRESCALER__)  ((((__PCLK__)/IRDAPrescTable[(__PRESCALER__)])\
                                                                  + ((__BAUD__)/2U)) / (__BAUD__))
