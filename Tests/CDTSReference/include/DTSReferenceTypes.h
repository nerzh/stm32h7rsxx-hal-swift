/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
 * Extracted unchanged from STM32H7RS HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
#ifndef C_DTS_REFERENCE_TYPES_H
#define C_DTS_REFERENCE_TYPES_H
#include <stdint.h>
#define __IO volatile
typedef enum
{
  HAL_OK       = 0x00,
  HAL_ERROR    = 0x01,
  HAL_BUSY     = 0x02,
  HAL_TIMEOUT  = 0x03
} HAL_StatusTypeDef;
typedef enum
{
  HAL_UNLOCKED = 0x00,
  HAL_LOCKED   = 0x01
} HAL_LockTypeDef;
/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 * Exact CMSIS declarations at 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
 * See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt. */
typedef struct
{
  __IO uint32_t CFGR1;         /*!< DTS configuration register,                     Address offset: 0x00 */
  uint32_t RESERVED0;          /*!< Reserved,                                       Address offset: 0x04 */
  __IO uint32_t T0VALR1;       /*!< DTS T0 Value register,                          Address offset: 0x08 */
  uint32_t RESERVED1;          /*!< Reserved,                                       Address offset: 0x0C */
  __IO uint32_t RAMPVALR;      /*!< DTS Ramp value register,                        Address offset: 0x10 */
  __IO uint32_t ITR1;          /*!< DTS Interrupt threshold register,               Address offset: 0x14 */
  uint32_t RESERVED2;          /*!< Reserved,                                       Address offset: 0x18 */
  __IO uint32_t DR;            /*!< DTS data register,                              Address offset: 0x1C */
  __IO uint32_t SR;            /*!< DTS status register                             Address offset: 0x20 */
  __IO uint32_t ITENR;         /*!< DTS Interrupt enable register,                  Address offset: 0x24 */
  __IO uint32_t ICIFR;         /*!< DTS Clear Interrupt flag register,              Address offset: 0x28 */
  __IO uint32_t OR;            /*!< DTS option register 1,                          Address offset: 0x2C */
} DTS_TypeDef;
typedef struct
{
  __IO uint32_t RTSR1;         /*!< EXTI Rising trigger selection register 1,         Address offset: 0x00 */
  __IO uint32_t FTSR1;         /*!< EXTI Falling trigger selection register 1,        Address offset: 0x04 */
  __IO uint32_t SWIER1;        /*!< EXTI Software interrupt event register 1,         Address offset: 0x08 */
       uint32_t RESERVED1[5];  /*!< Reserved 1,                                  Address offset: 0x0C-0x1C */
  __IO uint32_t RTSR2;         /*!< EXTI Rising trigger selection register 2,         Address offset: 0x20 */
  __IO uint32_t FTSR2;         /*!< EXTI Falling trigger selection register 2,        Address offset: 0x24 */
  __IO uint32_t SWIER2;        /*!< EXTI Software interrupt event register 2,         Address offset: 0x28 */
       uint32_t RESERVED2[21]; /*!< Reserved 2,                                  Address offset: 0x2C-0x7C */
  __IO uint32_t IMR1;          /*!< EXTI Interrupt mask register 1,                   Address offset: 0x80 */
  __IO uint32_t EMR1;          /*!< EXTI Event mask register 1,                       Address offset: 0x84 */
  __IO uint32_t PR1;           /*!< EXTI Pending register 1,                          Address offset: 0x88 */
       uint32_t RESERVED3;     /*!< Reserved 3,                                       Address offset: 0x8C */
  __IO uint32_t IMR2;          /*!< EXTI Interrupt mask register 2,                   Address offset: 0x90 */
  __IO uint32_t EMR2;          /*!< EXTI Event mask register 2,                       Address offset: 0x94 */
  __IO uint32_t PR2;           /*!< EXTI Pending register 2,                          Address offset: 0x98 */
       uint32_t RESERVED4;     /*!< Reserved 4,                                       Address offset: 0x9C */
  __IO uint32_t IMR3;          /*!< EXTI Interrupt mask register 3,                   Address offset: 0xA0 */
  __IO uint32_t EMR3;          /*!< EXTI Event mask register 3,                       Address offset: 0xA4 */
} EXTI_TypeDef;
/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted unchanged from STM32H7RS HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
typedef struct
{
  uint32_t QuickMeasure;  /*!< Specifies the quick measure option selection of the DTS sensor.
                               This parameter can be a value of @ref DTS_Quick_Measurement         */

  uint32_t RefClock;      /*!< Specifies the reference clock selection of the DTS sensor.
                               This parameter can be a value of @ref DTS_Reference_Clock_Selection */

  uint32_t TriggerInput;  /*!< Specifies the trigger input of the DTS sensor.
                               This parameter can be a value of @ref DTS_TriggerConfig             */

  uint32_t SamplingTime;  /*!< Specifies the sampling time configuration.
                               This parameter can be a value of @ref DTS_Sampling_Time             */

  uint32_t Divider;       /*!< Specifies the high speed clock divider ratio.
                               This parameter can be a value from 0 to 127                         */

  uint32_t HighThreshold; /*!< Specifies the high threshold of the DTS sensor                      */

  uint32_t LowThreshold;  /*!< Specifies the low threshold of the DTS sensor                       */

} DTS_InitTypeDef;
typedef enum
{
  HAL_DTS_STATE_RESET   = 0x00UL,     /*!< DTS not yet initialized or disabled */
  HAL_DTS_STATE_READY   = 0x01UL,     /*!< DTS initialized and ready for use   */
  HAL_DTS_STATE_BUSY    = 0x02UL,     /*!< DTS is running                      */
  HAL_DTS_STATE_TIMEOUT = 0x03UL,     /*!< Timeout state                       */
  HAL_DTS_STATE_ERROR   = 0x04UL      /*!< Internal Process error              */

} HAL_DTS_StateTypeDef;
#define USE_HAL_DTS_REGISTER_CALLBACKS 0
#define DTS_HandleTypeDef CDTS0Handle
#define __DTS_HandleTypeDef __CDTS0Handle
#if (USE_HAL_DTS_REGISTER_CALLBACKS == 1U)
typedef struct __DTS_HandleTypeDef
#else
typedef struct
#endif /* USE_HAL_DTS_REGISTER_CALLBACKS */
{
  DTS_TypeDef                *Instance;                               /*!< Register base address                      */
  DTS_InitTypeDef            Init;                                    /*!< DTS required parameters                    */
  HAL_LockTypeDef            Lock;                                    /*!< DTS Locking object                         */
  __IO HAL_DTS_StateTypeDef  State;                                   /*!< DTS peripheral state                       */

#if (USE_HAL_DTS_REGISTER_CALLBACKS == 1U)
  void (* MspInitCallback)(struct __DTS_HandleTypeDef *hdts);         /*!< DTS Base Msp Init Callback                 */
  void (* MspDeInitCallback)(struct __DTS_HandleTypeDef *hdts);       /*!< DTS Base Msp DeInit Callback               */
  void (* EndCallback)(struct __DTS_HandleTypeDef *hdts);             /*!< End measure Callback                       */
  void (* LowCallback)(struct __DTS_HandleTypeDef *hdts);             /*!< low threshold Callback                     */
  void (* HighCallback)(struct __DTS_HandleTypeDef *hdts);            /*!< high threshold Callback                    */
  void (* AsyncEndCallback)(struct __DTS_HandleTypeDef *hdts);        /*!< Asynchronous end of measure Callback       */
  void (* AsyncLowCallback)(struct __DTS_HandleTypeDef *hdts);        /*!< Asynchronous low threshold Callback        */
  void (* AsyncHighCallback)(struct __DTS_HandleTypeDef *hdts);       /*!< Asynchronous high threshold Callback       */
#endif /* USE_HAL_DTS_REGISTER_CALLBACKS */
} DTS_HandleTypeDef;
#undef USE_HAL_DTS_REGISTER_CALLBACKS
#undef DTS_HandleTypeDef
#undef __DTS_HandleTypeDef
#define USE_HAL_DTS_REGISTER_CALLBACKS 1
#define DTS_HandleTypeDef CDTS1Handle
#define __DTS_HandleTypeDef __CDTS1Handle
#if (USE_HAL_DTS_REGISTER_CALLBACKS == 1U)
typedef struct __DTS_HandleTypeDef
#else
typedef struct
#endif /* USE_HAL_DTS_REGISTER_CALLBACKS */
{
  DTS_TypeDef                *Instance;                               /*!< Register base address                      */
  DTS_InitTypeDef            Init;                                    /*!< DTS required parameters                    */
  HAL_LockTypeDef            Lock;                                    /*!< DTS Locking object                         */
  __IO HAL_DTS_StateTypeDef  State;                                   /*!< DTS peripheral state                       */

#if (USE_HAL_DTS_REGISTER_CALLBACKS == 1U)
  void (* MspInitCallback)(struct __DTS_HandleTypeDef *hdts);         /*!< DTS Base Msp Init Callback                 */
  void (* MspDeInitCallback)(struct __DTS_HandleTypeDef *hdts);       /*!< DTS Base Msp DeInit Callback               */
  void (* EndCallback)(struct __DTS_HandleTypeDef *hdts);             /*!< End measure Callback                       */
  void (* LowCallback)(struct __DTS_HandleTypeDef *hdts);             /*!< low threshold Callback                     */
  void (* HighCallback)(struct __DTS_HandleTypeDef *hdts);            /*!< high threshold Callback                    */
  void (* AsyncEndCallback)(struct __DTS_HandleTypeDef *hdts);        /*!< Asynchronous end of measure Callback       */
  void (* AsyncLowCallback)(struct __DTS_HandleTypeDef *hdts);        /*!< Asynchronous low threshold Callback        */
  void (* AsyncHighCallback)(struct __DTS_HandleTypeDef *hdts);       /*!< Asynchronous high threshold Callback       */
#endif /* USE_HAL_DTS_REGISTER_CALLBACKS */
} DTS_HandleTypeDef;
#undef USE_HAL_DTS_REGISTER_CALLBACKS
#undef DTS_HandleTypeDef
#undef __DTS_HandleTypeDef
typedef enum
{
  HAL_DTS_MEAS_COMPLETE_CB_ID        = 0x00U, /*!< Measure complete callback ID */
  HAL_DTS_ASYNC_MEAS_COMPLETE_CB_ID  = 0x01U, /*!< Asynchronous measure complete callback ID */
  HAL_DTS_LOW_THRESHOLD_CB_ID        = 0x02U, /*!< Low threshold detection callback ID */
  HAL_DTS_ASYNC_LOW_THRESHOLD_CB_ID  = 0x03U, /*!< Asynchronous low threshold detection callback ID */
  HAL_DTS_HIGH_THRESHOLD_CB_ID       = 0x04U, /*!< High threshold detection callback ID */
  HAL_DTS_ASYNC_HIGH_THRESHOLD_CB_ID = 0x05U, /*!< Asynchronous high threshold detection callback ID */
  HAL_DTS_MSPINIT_CB_ID              = 0x06U, /*!< MSP init callback ID */
  HAL_DTS_MSPDEINIT_CB_ID            = 0x07U  /*!< MSP de-init callback ID */
} HAL_DTS_CallbackIDTypeDef;
typedef void (*CDTS1Callback)(CDTS1Handle *);
#endif
