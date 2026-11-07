/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 * Exact CMSIS definitions at 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
 * See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt. */
#define IS_USART_INSTANCE(INSTANCE) (((INSTANCE) == USART1) || \
                                     ((INSTANCE) == USART2) || \
                                     ((INSTANCE) == USART3))
#define IS_UART_INSTANCE(INSTANCE) (((INSTANCE) == USART1) || \
                                    ((INSTANCE) == USART2) || \
                                    ((INSTANCE) == USART3) || \
                                    ((INSTANCE) == UART4)  || \
                                    ((INSTANCE) == UART5)  || \
                                    ((INSTANCE) == UART7)  || \
                                    ((INSTANCE) == UART8))
#define IS_UART_FIFO_INSTANCE(INSTANCE) (((INSTANCE) == USART1)  || \
                                         ((INSTANCE) == USART2)  || \
                                         ((INSTANCE) == USART3)  || \
                                         ((INSTANCE) == UART4)   || \
                                         ((INSTANCE) == UART5)   || \
                                         ((INSTANCE) == UART7)   || \
                                         ((INSTANCE) == UART8)   || \
                                         ((INSTANCE) == LPUART1))
#define IS_UART_SPI_SLAVE_INSTANCE(INSTANCE) (((INSTANCE) == USART1) || \
                                              ((INSTANCE) == USART2) || \
                                              ((INSTANCE) == USART3))
#define IS_USART_AUTOBAUDRATE_DETECTION_INSTANCE(INSTANCE) (((INSTANCE) == USART1) || \
                                                            ((INSTANCE) == USART2) || \
                                                            ((INSTANCE) == USART3) || \
                                                            ((INSTANCE) == UART4)  || \
                                                            ((INSTANCE) == UART5)  || \
                                                            ((INSTANCE) == UART7)  || \
                                                            ((INSTANCE) == UART8))
#define IS_UART_DRIVER_ENABLE_INSTANCE(INSTANCE)     (((INSTANCE) == USART1)  || \
                                                      ((INSTANCE) == USART2)  || \
                                                      ((INSTANCE) == USART3)  || \
                                                      ((INSTANCE) == UART4)   || \
                                                      ((INSTANCE) == UART5)   || \
                                                      ((INSTANCE) == UART7)   || \
                                                      ((INSTANCE) == UART8)   || \
                                                      ((INSTANCE) == LPUART1))
#define IS_UART_HALFDUPLEX_INSTANCE(INSTANCE)   (((INSTANCE) == USART1)  || \
                                                 ((INSTANCE) == USART2)  || \
                                                 ((INSTANCE) == USART3)  || \
                                                 ((INSTANCE) == UART4)   || \
                                                 ((INSTANCE) == UART5)   || \
                                                 ((INSTANCE) == UART7)   || \
                                                 ((INSTANCE) == UART8)   || \
                                                 ((INSTANCE) == LPUART1))
#define IS_UART_HWFLOW_INSTANCE(INSTANCE) (((INSTANCE) == USART1)  || \
                                           ((INSTANCE) == USART2)  || \
                                           ((INSTANCE) == USART3)  || \
                                           ((INSTANCE) == UART4)   || \
                                           ((INSTANCE) == UART5)   || \
                                           ((INSTANCE) == UART7)   || \
                                           ((INSTANCE) == UART8)   || \
                                           ((INSTANCE) == LPUART1))
#define IS_UART_LIN_INSTANCE(INSTANCE)   (((INSTANCE) == USART1) || \
                                          ((INSTANCE) == USART2) || \
                                          ((INSTANCE) == USART3) || \
                                          ((INSTANCE) == UART4)  || \
                                          ((INSTANCE) == UART5)  || \
                                          ((INSTANCE) == UART7)  || \
                                          ((INSTANCE) == UART8))
#define IS_UART_WAKEUP_FROMSTOP_INSTANCE(INSTANCE)   (((INSTANCE) == USART1)  || \
                                                      ((INSTANCE) == USART2)  || \
                                                      ((INSTANCE) == USART3)  || \
                                                      ((INSTANCE) == UART4)   || \
                                                      ((INSTANCE) == UART5)   || \
                                                      ((INSTANCE) == UART7)   || \
                                                      ((INSTANCE) == UART8)   || \
                                                      ((INSTANCE) == LPUART1))
#define IS_LPUART_INSTANCE(INSTANCE)    ((INSTANCE) == LPUART1)
