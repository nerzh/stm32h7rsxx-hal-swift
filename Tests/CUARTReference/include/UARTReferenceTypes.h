/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
 * Extracted unchanged from STM32H7RS HAL at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
#ifndef C_UART_REFERENCE_TYPES_H
#define C_UART_REFERENCE_TYPES_H
#include "UARTDMAReferenceTypes.h"
#define __IO volatile
#define HAL_DMA_MODULE_ENABLED
/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 * Exact CMSIS definitions at 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
 * See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt. */
typedef struct
{
  __IO uint32_t CR1;         /*!< USART Control register 1,                    Address offset: 0x00 */
  __IO uint32_t CR2;         /*!< USART Control register 2,                    Address offset: 0x04 */
  __IO uint32_t CR3;         /*!< USART Control register 3,                    Address offset: 0x08 */
  __IO uint32_t BRR;         /*!< USART Baud rate register,                    Address offset: 0x0C */
  __IO uint32_t GTPR;        /*!< USART Guard time and prescaler register,     Address offset: 0x10 */
  __IO uint32_t RTOR;        /*!< USART Receiver Time Out register,            Address offset: 0x14 */
  __IO uint32_t RQR;         /*!< USART Request register,                      Address offset: 0x18 */
  __IO uint32_t ISR;         /*!< USART Interrupt and status register,         Address offset: 0x1C */
  __IO uint32_t ICR;         /*!< USART Interrupt flag Clear register,         Address offset: 0x20 */
  __IO uint32_t RDR;         /*!< USART Receive Data register,                 Address offset: 0x24 */
  __IO uint32_t TDR;         /*!< USART Transmit Data register,                Address offset: 0x28 */
  __IO uint32_t PRESC;       /*!< USART Prescaler register,                    Address offset: 0x2C */
} USART_TypeDef;
typedef struct
{
  uint32_t BaudRate;                /*!< This member configures the UART communication baud rate.
                                         The baud rate register is computed using the following formula:
                                         @note For LPUART :
                                         Baud Rate Register = ((256 * lpuart_ker_ckpres) / ((huart->Init.BaudRate)))
                                         where lpuart_ker_ck_pres is the UART input clock divided by a prescaler.
                                         @note For UART :
                                         - If oversampling is 16 or in LIN mode,
                                            Baud Rate Register = ((uart_ker_ckpres) / ((huart->Init.BaudRate)))
                                         - If oversampling is 8,
                                            Baud Rate Register[15:4] = ((2 * uart_ker_ckpres) /
                                            ((huart->Init.BaudRate)))[15:4]
                                            Baud Rate Register[3] =  0
                                            Baud Rate Register[2:0] =  (((2 * uart_ker_ckpres) /
                                            ((huart->Init.BaudRate)))[3:0]) >> 1
                                         where uart_ker_ck_pres is the UART input clock divided by a prescaler */

  uint32_t WordLength;              /*!< Specifies the number of data bits transmitted or received in a frame.
                                         This parameter can be a value of @ref UARTEx_Word_Length. */

  uint32_t StopBits;                /*!< Specifies the number of stop bits transmitted.
                                         This parameter can be a value of @ref UART_Stop_Bits. */

  uint32_t Parity;                  /*!< Specifies the parity mode.
                                         This parameter can be a value of @ref UART_Parity
                                         @note When parity is enabled, the computed parity is inserted
                                               at the MSB position of the transmitted data (9th bit when
                                               the word length is set to 9 data bits; 8th bit when the
                                               word length is set to 8 data bits). */

  uint32_t Mode;                    /*!< Specifies whether the Receive or Transmit mode is enabled or disabled.
                                         This parameter can be a value of @ref UART_Mode. */

  uint32_t HwFlowCtl;               /*!< Specifies whether the hardware flow control mode is enabled
                                         or disabled.
                                         This parameter can be a value of @ref UART_Hardware_Flow_Control. */

  uint32_t OverSampling;            /*!< Specifies whether the Over sampling 8 is enabled or disabled,
                                         to achieve higher speed (up to f_PCLK/8).
                                         This parameter can be a value of @ref UART_Over_Sampling. */

  uint32_t OneBitSampling;          /*!< Specifies whether a single sample or three samples' majority vote is selected.
                                         Selecting the single sample method increases the receiver tolerance to clock
                                         deviations. This parameter can be a value of @ref UART_OneBit_Sampling. */

  uint32_t ClockPrescaler;          /*!< Specifies the prescaler value used to divide the UART clock source.
                                         This parameter can be a value of @ref UART_ClockPrescaler. */

} UART_InitTypeDef;
typedef struct
{
  uint32_t AdvFeatureInit;        /*!< Specifies which advanced UART features is initialized. Several
                                       Advanced Features may be initialized at the same time .
                                       This parameter can be a value of
                                       @ref UART_Advanced_Features_Initialization_Type. */

  uint32_t TxPinLevelInvert;      /*!< Specifies whether the TX pin active level is inverted.
                                       This parameter can be a value of @ref UART_Tx_Inv. */

  uint32_t RxPinLevelInvert;      /*!< Specifies whether the RX pin active level is inverted.
                                       This parameter can be a value of @ref UART_Rx_Inv. */

  uint32_t DataInvert;            /*!< Specifies whether data are inverted (positive/direct logic
                                       vs negative/inverted logic).
                                       This parameter can be a value of @ref UART_Data_Inv. */

  uint32_t Swap;                  /*!< Specifies whether TX and RX pins are swapped.
                                       This parameter can be a value of @ref UART_Rx_Tx_Swap. */

  uint32_t OverrunDisable;        /*!< Specifies whether the reception overrun detection is disabled.
                                       This parameter can be a value of @ref UART_Overrun_Disable. */

#if defined(HAL_DMA_MODULE_ENABLED)
  uint32_t DMADisableonRxError;   /*!< Specifies whether the DMA is disabled in case of reception error.
                                       This parameter can be a value of @ref UART_DMA_Disable_on_Rx_Error. */

#endif /* HAL_DMA_MODULE_ENABLED */
  uint32_t AutoBaudRateEnable;    /*!< Specifies whether auto Baud rate detection is enabled.
                                       This parameter can be a value of @ref UART_AutoBaudRate_Enable. */

  uint32_t AutoBaudRateMode;      /*!< If auto Baud rate detection is enabled, specifies how the rate
                                       detection is carried out.
                                       This parameter can be a value of @ref UART_AutoBaud_Rate_Mode. */

  uint32_t MSBFirst;              /*!< Specifies whether MSB is sent first on UART line.
                                       This parameter can be a value of @ref UART_MSB_First. */
} UART_AdvFeatureInitTypeDef;
typedef uint32_t HAL_UART_StateTypeDef;
typedef uint32_t HAL_UART_RxTypeTypeDef;
typedef uint32_t HAL_UART_RxEventTypeTypeDef;
typedef enum
{
  UART_CLOCKSOURCE_PCLK1      = 0x00U,    /*!< PCLK1 clock source */
  UART_CLOCKSOURCE_PCLK2      = 0x01U,    /*!< PCLK2 clock source */
  UART_CLOCKSOURCE_PCLK4      = 0x02U,    /*!< PCLK4 clock source (only used by LPUART1) */
  UART_CLOCKSOURCE_PLL2Q      = 0x04U,    /*!< PLL2Q clock source         */
  UART_CLOCKSOURCE_PLL3Q      = 0x08U,    /*!< PLL3Q clock source         */
  UART_CLOCKSOURCE_HSI        = 0x10U,    /*!< HSI clock source           */
  UART_CLOCKSOURCE_CSI        = 0x20U,    /*!< CSI clock source           */
  UART_CLOCKSOURCE_LSE        = 0x40U,    /*!< LSE clock source           */
  UART_CLOCKSOURCE_UNDEFINED  = 0x80U     /*!< Undefined clock source     */
} UART_ClockSourceTypeDef;
typedef struct
{
  uint32_t WakeUpEvent;        /*!< Specifies which event will activate the Wakeup from Stop mode flag (WUF).
                                    This parameter can be a value of @ref UART_WakeUp_from_Stop_Selection.
                                    If set to UART_WAKEUP_ON_ADDRESS, the two other fields below must
                                    be filled up. */

  uint16_t AddressLength;      /*!< Specifies whether the address is 4 or 7-bit long.
                                    This parameter can be a value of @ref UARTEx_WakeUp_Address_Length.  */

  uint8_t Address;             /*!< UART/USART node address (7-bit long max). */
} UART_WakeUpTypeDef;
#define USE_HAL_UART_REGISTER_CALLBACKS 0
#define UART_HandleTypeDef CUART0Handle
#define __UART_HandleTypeDef __CUART0Handle
typedef struct __UART_HandleTypeDef
{
  USART_TypeDef            *Instance;                /*!< UART registers base address        */

  UART_InitTypeDef         Init;                     /*!< UART communication parameters      */

  UART_AdvFeatureInitTypeDef AdvancedInit;           /*!< UART Advanced Features initialization parameters */

  const uint8_t            *pTxBuffPtr;              /*!< Pointer to UART Tx transfer Buffer */

  uint16_t                 TxXferSize;               /*!< UART Tx Transfer size              */

  __IO uint16_t            TxXferCount;              /*!< UART Tx Transfer Counter           */

  uint8_t                  *pRxBuffPtr;              /*!< Pointer to UART Rx transfer Buffer */

  uint16_t                 RxXferSize;               /*!< UART Rx Transfer size              */

  __IO uint16_t            RxXferCount;              /*!< UART Rx Transfer Counter           */

  uint16_t                 Mask;                     /*!< UART Rx RDR register mask          */

  uint32_t                 FifoMode;                 /*!< Specifies if the FIFO mode is being used.
                                                          This parameter can be a value of @ref UARTEx_FIFO_mode. */

  uint16_t                 NbRxDataToProcess;        /*!< Number of data to process during RX ISR execution */

  uint16_t                 NbTxDataToProcess;        /*!< Number of data to process during TX ISR execution */

  __IO HAL_UART_RxTypeTypeDef ReceptionType;         /*!< Type of ongoing reception          */

  __IO HAL_UART_RxEventTypeTypeDef RxEventType;      /*!< Type of Rx Event                   */

  void (*RxISR)(struct __UART_HandleTypeDef *huart); /*!< Function pointer on Rx IRQ handler */

  void (*TxISR)(struct __UART_HandleTypeDef *huart); /*!< Function pointer on Tx IRQ handler */

#if defined(HAL_DMA_MODULE_ENABLED)
  DMA_HandleTypeDef        *hdmatx;                  /*!< UART Tx DMA Handle parameters      */

  DMA_HandleTypeDef        *hdmarx;                  /*!< UART Rx DMA Handle parameters      */

#endif /* HAL_DMA_MODULE_ENABLED */
  HAL_LockTypeDef           Lock;                    /*!< Locking object                     */

  __IO HAL_UART_StateTypeDef    gState;              /*!< UART state information related to global Handle management
                                                          and also related to Tx operations. This parameter
                                                          can be a value of @ref HAL_UART_StateTypeDef */

  __IO HAL_UART_StateTypeDef    RxState;             /*!< UART state information related to Rx operations. This
                                                          parameter can be a value of @ref HAL_UART_StateTypeDef */

  __IO uint32_t                 ErrorCode;           /*!< UART Error code                    */

#if (USE_HAL_UART_REGISTER_CALLBACKS == 1)
  void (* TxHalfCpltCallback)(struct __UART_HandleTypeDef *huart);        /*!< UART Tx Half Complete Callback        */
  void (* TxCpltCallback)(struct __UART_HandleTypeDef *huart);            /*!< UART Tx Complete Callback             */
  void (* RxHalfCpltCallback)(struct __UART_HandleTypeDef *huart);        /*!< UART Rx Half Complete Callback        */
  void (* RxCpltCallback)(struct __UART_HandleTypeDef *huart);            /*!< UART Rx Complete Callback             */
  void (* ErrorCallback)(struct __UART_HandleTypeDef *huart);             /*!< UART Error Callback                   */
  void (* AbortCpltCallback)(struct __UART_HandleTypeDef *huart);         /*!< UART Abort Complete Callback          */
  void (* AbortTransmitCpltCallback)(struct __UART_HandleTypeDef *huart); /*!< UART Abort Transmit Complete Callback */
  void (* AbortReceiveCpltCallback)(struct __UART_HandleTypeDef *huart);  /*!< UART Abort Receive Complete Callback  */
  void (* WakeupCallback)(struct __UART_HandleTypeDef *huart);            /*!< UART Wakeup Callback                  */
  void (* RxFifoFullCallback)(struct __UART_HandleTypeDef *huart);        /*!< UART Rx Fifo Full Callback            */
  void (* TxFifoEmptyCallback)(struct __UART_HandleTypeDef *huart);       /*!< UART Tx Fifo Empty Callback           */
  void (* RxEventCallback)(struct __UART_HandleTypeDef *huart, uint16_t Pos); /*!< UART Reception Event Callback     */

  void (* MspInitCallback)(struct __UART_HandleTypeDef *huart);           /*!< UART Msp Init callback                */
  void (* MspDeInitCallback)(struct __UART_HandleTypeDef *huart);         /*!< UART Msp DeInit callback              */
#endif  /* USE_HAL_UART_REGISTER_CALLBACKS */

} UART_HandleTypeDef;
#undef USE_HAL_UART_REGISTER_CALLBACKS
#undef UART_HandleTypeDef
#undef __UART_HandleTypeDef
#define USE_HAL_UART_REGISTER_CALLBACKS 1
#define UART_HandleTypeDef CUART1Handle
#define __UART_HandleTypeDef __CUART1Handle
typedef struct __UART_HandleTypeDef
{
  USART_TypeDef            *Instance;                /*!< UART registers base address        */

  UART_InitTypeDef         Init;                     /*!< UART communication parameters      */

  UART_AdvFeatureInitTypeDef AdvancedInit;           /*!< UART Advanced Features initialization parameters */

  const uint8_t            *pTxBuffPtr;              /*!< Pointer to UART Tx transfer Buffer */

  uint16_t                 TxXferSize;               /*!< UART Tx Transfer size              */

  __IO uint16_t            TxXferCount;              /*!< UART Tx Transfer Counter           */

  uint8_t                  *pRxBuffPtr;              /*!< Pointer to UART Rx transfer Buffer */

  uint16_t                 RxXferSize;               /*!< UART Rx Transfer size              */

  __IO uint16_t            RxXferCount;              /*!< UART Rx Transfer Counter           */

  uint16_t                 Mask;                     /*!< UART Rx RDR register mask          */

  uint32_t                 FifoMode;                 /*!< Specifies if the FIFO mode is being used.
                                                          This parameter can be a value of @ref UARTEx_FIFO_mode. */

  uint16_t                 NbRxDataToProcess;        /*!< Number of data to process during RX ISR execution */

  uint16_t                 NbTxDataToProcess;        /*!< Number of data to process during TX ISR execution */

  __IO HAL_UART_RxTypeTypeDef ReceptionType;         /*!< Type of ongoing reception          */

  __IO HAL_UART_RxEventTypeTypeDef RxEventType;      /*!< Type of Rx Event                   */

  void (*RxISR)(struct __UART_HandleTypeDef *huart); /*!< Function pointer on Rx IRQ handler */

  void (*TxISR)(struct __UART_HandleTypeDef *huart); /*!< Function pointer on Tx IRQ handler */

#if defined(HAL_DMA_MODULE_ENABLED)
  DMA_HandleTypeDef        *hdmatx;                  /*!< UART Tx DMA Handle parameters      */

  DMA_HandleTypeDef        *hdmarx;                  /*!< UART Rx DMA Handle parameters      */

#endif /* HAL_DMA_MODULE_ENABLED */
  HAL_LockTypeDef           Lock;                    /*!< Locking object                     */

  __IO HAL_UART_StateTypeDef    gState;              /*!< UART state information related to global Handle management
                                                          and also related to Tx operations. This parameter
                                                          can be a value of @ref HAL_UART_StateTypeDef */

  __IO HAL_UART_StateTypeDef    RxState;             /*!< UART state information related to Rx operations. This
                                                          parameter can be a value of @ref HAL_UART_StateTypeDef */

  __IO uint32_t                 ErrorCode;           /*!< UART Error code                    */

#if (USE_HAL_UART_REGISTER_CALLBACKS == 1)
  void (* TxHalfCpltCallback)(struct __UART_HandleTypeDef *huart);        /*!< UART Tx Half Complete Callback        */
  void (* TxCpltCallback)(struct __UART_HandleTypeDef *huart);            /*!< UART Tx Complete Callback             */
  void (* RxHalfCpltCallback)(struct __UART_HandleTypeDef *huart);        /*!< UART Rx Half Complete Callback        */
  void (* RxCpltCallback)(struct __UART_HandleTypeDef *huart);            /*!< UART Rx Complete Callback             */
  void (* ErrorCallback)(struct __UART_HandleTypeDef *huart);             /*!< UART Error Callback                   */
  void (* AbortCpltCallback)(struct __UART_HandleTypeDef *huart);         /*!< UART Abort Complete Callback          */
  void (* AbortTransmitCpltCallback)(struct __UART_HandleTypeDef *huart); /*!< UART Abort Transmit Complete Callback */
  void (* AbortReceiveCpltCallback)(struct __UART_HandleTypeDef *huart);  /*!< UART Abort Receive Complete Callback  */
  void (* WakeupCallback)(struct __UART_HandleTypeDef *huart);            /*!< UART Wakeup Callback                  */
  void (* RxFifoFullCallback)(struct __UART_HandleTypeDef *huart);        /*!< UART Rx Fifo Full Callback            */
  void (* TxFifoEmptyCallback)(struct __UART_HandleTypeDef *huart);       /*!< UART Tx Fifo Empty Callback           */
  void (* RxEventCallback)(struct __UART_HandleTypeDef *huart, uint16_t Pos); /*!< UART Reception Event Callback     */

  void (* MspInitCallback)(struct __UART_HandleTypeDef *huart);           /*!< UART Msp Init callback                */
  void (* MspDeInitCallback)(struct __UART_HandleTypeDef *huart);         /*!< UART Msp DeInit callback              */
#endif  /* USE_HAL_UART_REGISTER_CALLBACKS */

} UART_HandleTypeDef;
#undef USE_HAL_UART_REGISTER_CALLBACKS
#undef UART_HandleTypeDef
#undef __UART_HandleTypeDef
typedef enum
{
  HAL_UART_TX_HALFCOMPLETE_CB_ID         = 0x00U,    /*!< UART Tx Half Complete Callback ID        */
  HAL_UART_TX_COMPLETE_CB_ID             = 0x01U,    /*!< UART Tx Complete Callback ID             */
  HAL_UART_RX_HALFCOMPLETE_CB_ID         = 0x02U,    /*!< UART Rx Half Complete Callback ID        */
  HAL_UART_RX_COMPLETE_CB_ID             = 0x03U,    /*!< UART Rx Complete Callback ID             */
  HAL_UART_ERROR_CB_ID                   = 0x04U,    /*!< UART Error Callback ID                   */
  HAL_UART_ABORT_COMPLETE_CB_ID          = 0x05U,    /*!< UART Abort Complete Callback ID          */
  HAL_UART_ABORT_TRANSMIT_COMPLETE_CB_ID = 0x06U,    /*!< UART Abort Transmit Complete Callback ID */
  HAL_UART_ABORT_RECEIVE_COMPLETE_CB_ID  = 0x07U,    /*!< UART Abort Receive Complete Callback ID  */
  HAL_UART_WAKEUP_CB_ID                  = 0x08U,    /*!< UART Wakeup Callback ID                  */
  HAL_UART_RX_FIFO_FULL_CB_ID            = 0x09U,    /*!< UART Rx Fifo Full Callback ID            */
  HAL_UART_TX_FIFO_EMPTY_CB_ID           = 0x0AU,    /*!< UART Tx Fifo Empty Callback ID           */

  HAL_UART_MSPINIT_CB_ID                 = 0x0BU,    /*!< UART MspInit callback ID                 */
  HAL_UART_MSPDEINIT_CB_ID               = 0x0CU     /*!< UART MspDeInit callback ID               */

} HAL_UART_CallbackIDTypeDef;
typedef void (*CUART1Callback)(CUART1Handle *);
typedef void (*CUART1RxEventCallback)(CUART1Handle *, uint16_t);
typedef enum { RESET = 0, SET = !RESET } FlagStatus, ITStatus;
#endif
