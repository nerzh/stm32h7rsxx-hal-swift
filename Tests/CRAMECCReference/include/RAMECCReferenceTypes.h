/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted from STM32H7RS HAL at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
#ifndef C_RAMECC_TYPES_H
#define C_RAMECC_TYPES_H
#include <stdint.h>
#define __IO volatile
typedef enum { HAL_OK = 0, HAL_ERROR = 1, HAL_BUSY = 2, HAL_TIMEOUT = 3 } HAL_StatusTypeDef;
/* Copyright (c) 2022 STMicroelectronics. SPDX-License-Identifier: Apache-2.0
 * Exact CMSIS register declarations/bits at 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
 * See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt. */
typedef struct
{
  __IO uint32_t CR;           /*!< RAMECC monitor configuration register          */
  __IO uint32_t SR;           /*!< RAMECC monitor status register                 */
  __IO uint32_t FAR;          /*!< RAMECC monitor failing address register        */
  __IO uint32_t FDRL;         /*!< RAMECC monitor failing data low register       */
  __IO uint32_t FDRH;         /*!< RAMECC monitor failing data high register      */
  __IO uint32_t FECR;         /*!< RAMECC monitor failing ECC error code register */
} RAMECC_MonitorTypeDef;
typedef struct
{
  __IO uint32_t IER;          /*!< RAMECC interrupt enable register */
} RAMECC_TypeDef;
typedef enum
{
  HAL_RAMECC_STATE_RESET             = 0x00U,  /*!< RAMECC not yet initialized or disabled */
  HAL_RAMECC_STATE_READY             = 0x01U,  /*!< RAMECC initialized and ready for use   */
  HAL_RAMECC_STATE_BUSY              = 0x02U,  /*!< RAMECC process is ongoing              */
  HAL_RAMECC_STATE_ERROR             = 0x03U,  /*!< RAMECC error state                     */
} HAL_RAMECC_StateTypeDef;
typedef enum
{
  HAL_RAMECC_MSPINIT_CB_ID           = 0x00U,  /*!< RAMECC MSP Init Callback ID            */
  HAL_RAMECC_MSPDEINIT_CB_ID         = 0x01U,  /*!< RAMECC MSP DeInit Callback ID          */
  HAL_RAMECC_SE_DETECT_CB_ID         = 0x02U,  /*!< RAMECC Single Error Detect Callback ID */
  HAL_RAMECC_DE_DETECT_CB_ID         = 0x03U,  /*!< RAMECC Double Error Detect Callback ID */
  HAL_RAMECC_ALL_CB_ID               = 0x04U,  /*!< RAMECC All callback ID                 */
} HAL_RAMECC_CallbackIDTypeDef;
#define USE_HAL_RAMECC_REGISTER_CALLBACKS 0
#define RAMECC_HandleTypeDef CRAMECC0Handle
#define __RAMECC_HandleTypeDef __CRAMECC0Handle
#if (USE_HAL_RAMECC_REGISTER_CALLBACKS == 1)
typedef struct __RAMECC_HandleTypeDef
#else
typedef struct
#endif /* (USE_HAL_RAMECC_REGISTER_CALLBACKS) */
{
  RAMECC_MonitorTypeDef           *Instance;                                                            /*!< Register base address        */
  __IO HAL_RAMECC_StateTypeDef    State;                                                                /*!< RAMECC state                 */
  __IO uint32_t                   ErrorCode;                                                            /*!< RAMECC Error Code            */
#if (USE_HAL_RAMECC_REGISTER_CALLBACKS == 1)
  void (* MspInitCallback)(struct __RAMECC_HandleTypeDef *hramecc);                                     /*!< RAMECC MSP Init Callback            */
  void (* MspDeInitCallback)(struct __RAMECC_HandleTypeDef *hramecc);                                   /*!< RAMECC MSP DeInit Callback          */
  void (* DetectSingleErrorCallback)(struct __RAMECC_HandleTypeDef *hramecc);                           /*!< RAMECC Single Error Detect Callback */
  void (* DetectDoubleErrorCallback)(struct __RAMECC_HandleTypeDef *hramecc);                           /*!< RAMECC Double Error Detect Callback */
#endif  /* USE_HAL_RAMECC_REGISTER_CALLBACKS */
} RAMECC_HandleTypeDef;
#undef USE_HAL_RAMECC_REGISTER_CALLBACKS
#undef RAMECC_HandleTypeDef
#undef __RAMECC_HandleTypeDef
#define USE_HAL_RAMECC_REGISTER_CALLBACKS 1
#define RAMECC_HandleTypeDef CRAMECC1Handle
#define __RAMECC_HandleTypeDef __CRAMECC1Handle
#if (USE_HAL_RAMECC_REGISTER_CALLBACKS == 1)
typedef struct __RAMECC_HandleTypeDef
#else
typedef struct
#endif /* (USE_HAL_RAMECC_REGISTER_CALLBACKS) */
{
  RAMECC_MonitorTypeDef           *Instance;                                                            /*!< Register base address        */
  __IO HAL_RAMECC_StateTypeDef    State;                                                                /*!< RAMECC state                 */
  __IO uint32_t                   ErrorCode;                                                            /*!< RAMECC Error Code            */
#if (USE_HAL_RAMECC_REGISTER_CALLBACKS == 1)
  void (* MspInitCallback)(struct __RAMECC_HandleTypeDef *hramecc);                                     /*!< RAMECC MSP Init Callback            */
  void (* MspDeInitCallback)(struct __RAMECC_HandleTypeDef *hramecc);                                   /*!< RAMECC MSP DeInit Callback          */
  void (* DetectSingleErrorCallback)(struct __RAMECC_HandleTypeDef *hramecc);                           /*!< RAMECC Single Error Detect Callback */
  void (* DetectDoubleErrorCallback)(struct __RAMECC_HandleTypeDef *hramecc);                           /*!< RAMECC Double Error Detect Callback */
#endif  /* USE_HAL_RAMECC_REGISTER_CALLBACKS */
} RAMECC_HandleTypeDef;
#undef USE_HAL_RAMECC_REGISTER_CALLBACKS
#undef RAMECC_HandleTypeDef
#undef __RAMECC_HandleTypeDef
#undef __IO
#endif
