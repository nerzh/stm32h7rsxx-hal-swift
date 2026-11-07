/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted unchanged from STM32H7RS HAL at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
#define UART_WORDLENGTH_7B          USART_CR1_M1   /*!< 7-bit long UART frame */
#define UART_WORDLENGTH_8B          0x00000000U    /*!< 8-bit long UART frame */
#define UART_WORDLENGTH_9B          USART_CR1_M0   /*!< 9-bit long UART frame */
#define UART_ADDRESS_DETECT_4B      0x00000000U      /*!< 4-bit long wake-up address */
#define UART_ADDRESS_DETECT_7B      USART_CR2_ADDM7  /*!< 7-bit long wake-up address */
#define UART_FIFOMODE_DISABLE       0x00000000U       /*!< FIFO mode disable */
#define UART_FIFOMODE_ENABLE        USART_CR1_FIFOEN  /*!< FIFO mode enable  */
#define UART_TXFIFO_THRESHOLD_1_8   0x00000000U                               /*!< TX FIFO reaches 1/8 of its depth */
#define UART_TXFIFO_THRESHOLD_1_4   USART_CR3_TXFTCFG_0                       /*!< TX FIFO reaches 1/4 of its depth */
#define UART_TXFIFO_THRESHOLD_1_2   USART_CR3_TXFTCFG_1                       /*!< TX FIFO reaches 1/2 of its depth */
#define UART_TXFIFO_THRESHOLD_3_4   (USART_CR3_TXFTCFG_0|USART_CR3_TXFTCFG_1) /*!< TX FIFO reaches 3/4 of its depth */
#define UART_TXFIFO_THRESHOLD_7_8   USART_CR3_TXFTCFG_2                       /*!< TX FIFO reaches 7/8 of its depth */
#define UART_TXFIFO_THRESHOLD_8_8   (USART_CR3_TXFTCFG_2|USART_CR3_TXFTCFG_0) /*!< TX FIFO becomes empty            */
#define UART_RXFIFO_THRESHOLD_1_8   0x00000000U                               /*!< RX FIFO reaches 1/8 of its depth */
#define UART_RXFIFO_THRESHOLD_1_4   USART_CR3_RXFTCFG_0                       /*!< RX FIFO reaches 1/4 of its depth */
#define UART_RXFIFO_THRESHOLD_1_2   USART_CR3_RXFTCFG_1                       /*!< RX FIFO reaches 1/2 of its depth */
#define UART_RXFIFO_THRESHOLD_3_4   (USART_CR3_RXFTCFG_0|USART_CR3_RXFTCFG_1) /*!< RX FIFO reaches 3/4 of its depth */
#define UART_RXFIFO_THRESHOLD_7_8   USART_CR3_RXFTCFG_2                       /*!< RX FIFO reaches 7/8 of its depth */
#define UART_RXFIFO_THRESHOLD_8_8   (USART_CR3_RXFTCFG_2|USART_CR3_RXFTCFG_0) /*!< RX FIFO becomes full             */
#define UART_GETCLOCKSOURCE(__HANDLE__,__CLOCKSOURCE__)       \
  do {                                                        \
    if((__HANDLE__)->Instance == USART1)                      \
    {                                                         \
      switch(__HAL_RCC_GET_USART1_SOURCE())                   \
      {                                                       \
        case RCC_USART1CLKSOURCE_PCLK2:                       \
          (__CLOCKSOURCE__) = UART_CLOCKSOURCE_PCLK2;         \
          break;                                              \
        case RCC_USART1CLKSOURCE_PLL2Q:                       \
          (__CLOCKSOURCE__) = UART_CLOCKSOURCE_PLL2Q;         \
          break;                                              \
        case RCC_USART1CLKSOURCE_PLL3Q:                       \
          (__CLOCKSOURCE__) = UART_CLOCKSOURCE_PLL3Q;         \
          break;                                              \
        case RCC_USART1CLKSOURCE_HSI:                         \
          (__CLOCKSOURCE__) = UART_CLOCKSOURCE_HSI;           \
          break;                                              \
        case RCC_USART1CLKSOURCE_CSI:                         \
          (__CLOCKSOURCE__) = UART_CLOCKSOURCE_CSI;           \
          break;                                              \
        case RCC_USART1CLKSOURCE_LSE:                         \
          (__CLOCKSOURCE__) = UART_CLOCKSOURCE_LSE;           \
          break;                                              \
        default:                                              \
          (__CLOCKSOURCE__) = UART_CLOCKSOURCE_UNDEFINED;     \
          break;                                              \
      }                                                       \
    }                                                         \
    else if(((__HANDLE__)->Instance == USART2) ||             \
            ((__HANDLE__)->Instance == USART3) ||             \
            ((__HANDLE__)->Instance == UART4) ||              \
            ((__HANDLE__)->Instance == UART5) ||              \
            ((__HANDLE__)->Instance == UART7) ||              \
            ((__HANDLE__)->Instance == UART8))                \
    {                                                         \
      switch(__HAL_RCC_GET_USART234578_SOURCE())              \
      {                                                       \
        case RCC_USART234578CLKSOURCE_PCLK1:                  \
          (__CLOCKSOURCE__) = UART_CLOCKSOURCE_PCLK1;         \
          break;                                              \
        case RCC_USART234578CLKSOURCE_PLL2Q:                  \
          (__CLOCKSOURCE__) = UART_CLOCKSOURCE_PLL2Q;         \
          break;                                              \
        case RCC_USART234578CLKSOURCE_PLL3Q:                  \
          (__CLOCKSOURCE__) = UART_CLOCKSOURCE_PLL3Q;         \
          break;                                              \
        case RCC_USART234578CLKSOURCE_HSI:                    \
          (__CLOCKSOURCE__) = UART_CLOCKSOURCE_HSI;           \
          break;                                              \
        case RCC_USART234578CLKSOURCE_CSI:                    \
          (__CLOCKSOURCE__) = UART_CLOCKSOURCE_CSI;           \
          break;                                              \
        case RCC_USART234578CLKSOURCE_LSE:                    \
          (__CLOCKSOURCE__) = UART_CLOCKSOURCE_LSE;           \
          break;                                              \
        default:                                              \
          (__CLOCKSOURCE__) = UART_CLOCKSOURCE_UNDEFINED;     \
          break;                                              \
      }                                                       \
    }                                                         \
    else if((__HANDLE__)->Instance == LPUART1)                \
    {                                                         \
      switch(__HAL_RCC_GET_LPUART1_SOURCE())                  \
      {                                                       \
        case RCC_LPUART1CLKSOURCE_PCLK4:                      \
          (__CLOCKSOURCE__) = UART_CLOCKSOURCE_PCLK4;         \
          break;                                              \
        case RCC_LPUART1CLKSOURCE_PLL2Q:                      \
          (__CLOCKSOURCE__) = UART_CLOCKSOURCE_PLL2Q;         \
          break;                                              \
        case RCC_LPUART1CLKSOURCE_PLL3Q:                      \
          (__CLOCKSOURCE__) = UART_CLOCKSOURCE_PLL3Q;         \
          break;                                              \
        case RCC_LPUART1CLKSOURCE_HSI:                        \
          (__CLOCKSOURCE__) = UART_CLOCKSOURCE_HSI;           \
          break;                                              \
        case RCC_LPUART1CLKSOURCE_CSI:                        \
          (__CLOCKSOURCE__) = UART_CLOCKSOURCE_CSI;           \
          break;                                              \
        case RCC_LPUART1CLKSOURCE_LSE:                        \
          (__CLOCKSOURCE__) = UART_CLOCKSOURCE_LSE;           \
          break;                                              \
        default:                                              \
          (__CLOCKSOURCE__) = UART_CLOCKSOURCE_UNDEFINED;     \
          break;                                              \
      }                                                       \
    }                                                         \
    else                                                      \
    {                                                         \
      (__CLOCKSOURCE__) = UART_CLOCKSOURCE_UNDEFINED;         \
    }                                                         \
  } while(0U)
#define UART_MASK_COMPUTATION(__HANDLE__)                             \
  do {                                                                \
    if ((__HANDLE__)->Init.WordLength == UART_WORDLENGTH_9B)          \
    {                                                                 \
      if ((__HANDLE__)->Init.Parity == UART_PARITY_NONE)              \
      {                                                               \
        (__HANDLE__)->Mask = 0x01FFU ;                                \
      }                                                               \
      else                                                            \
      {                                                               \
        (__HANDLE__)->Mask = 0x00FFU ;                                \
      }                                                               \
    }                                                                 \
    else if ((__HANDLE__)->Init.WordLength == UART_WORDLENGTH_8B)     \
    {                                                                 \
      if ((__HANDLE__)->Init.Parity == UART_PARITY_NONE)              \
      {                                                               \
        (__HANDLE__)->Mask = 0x00FFU ;                                \
      }                                                               \
      else                                                            \
      {                                                               \
        (__HANDLE__)->Mask = 0x007FU ;                                \
      }                                                               \
    }                                                                 \
    else if ((__HANDLE__)->Init.WordLength == UART_WORDLENGTH_7B)     \
    {                                                                 \
      if ((__HANDLE__)->Init.Parity == UART_PARITY_NONE)              \
      {                                                               \
        (__HANDLE__)->Mask = 0x007FU ;                                \
      }                                                               \
      else                                                            \
      {                                                               \
        (__HANDLE__)->Mask = 0x003FU ;                                \
      }                                                               \
    }                                                                 \
    else                                                              \
    {                                                                 \
      (__HANDLE__)->Mask = 0x0000U;                                   \
    }                                                                 \
  } while(0U)
#define IS_UART_WORD_LENGTH(__LENGTH__) (((__LENGTH__) == UART_WORDLENGTH_7B) || \
                                         ((__LENGTH__) == UART_WORDLENGTH_8B) || \
                                         ((__LENGTH__) == UART_WORDLENGTH_9B))
#define IS_UART_ADDRESSLENGTH_DETECT(__ADDRESS__) (((__ADDRESS__) == UART_ADDRESS_DETECT_4B) || \
                                                   ((__ADDRESS__) == UART_ADDRESS_DETECT_7B))
#define IS_UART_TXFIFO_THRESHOLD(__THRESHOLD__) (((__THRESHOLD__) == UART_TXFIFO_THRESHOLD_1_8) || \
                                                 ((__THRESHOLD__) == UART_TXFIFO_THRESHOLD_1_4) || \
                                                 ((__THRESHOLD__) == UART_TXFIFO_THRESHOLD_1_2) || \
                                                 ((__THRESHOLD__) == UART_TXFIFO_THRESHOLD_3_4) || \
                                                 ((__THRESHOLD__) == UART_TXFIFO_THRESHOLD_7_8) || \
                                                 ((__THRESHOLD__) == UART_TXFIFO_THRESHOLD_8_8))
#define IS_UART_RXFIFO_THRESHOLD(__THRESHOLD__) (((__THRESHOLD__) == UART_RXFIFO_THRESHOLD_1_8) || \
                                                 ((__THRESHOLD__) == UART_RXFIFO_THRESHOLD_1_4) || \
                                                 ((__THRESHOLD__) == UART_RXFIFO_THRESHOLD_1_2) || \
                                                 ((__THRESHOLD__) == UART_RXFIFO_THRESHOLD_3_4) || \
                                                 ((__THRESHOLD__) == UART_RXFIFO_THRESHOLD_7_8) || \
                                                 ((__THRESHOLD__) == UART_RXFIFO_THRESHOLD_8_8))
