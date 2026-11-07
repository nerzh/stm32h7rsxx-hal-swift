/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted without body changes from STM32H7RS HAL at
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
#ifndef C_WATCHDOG_TYPES_H
#define C_WATCHDOG_TYPES_H
#include <stdint.h>
#define __IO volatile
typedef enum { HAL_OK=0, HAL_ERROR=1, HAL_BUSY=2, HAL_TIMEOUT=3 } HAL_StatusTypeDef;
/* Exact CMSIS declarations at 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
 * Copyright (c) 2022 STMicroelectronics. SPDX-License-Identifier: Apache-2.0
 * See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt. No field adaptations. */
typedef struct
{
  __IO uint32_t KR;            /*!< IWDG Key register,                  Address offset: 0x00 */
  __IO uint32_t PR;            /*!< IWDG Prescaler register,            Address offset: 0x04 */
  __IO uint32_t RLR;           /*!< IWDG Reload register,               Address offset: 0x08 */
  __IO uint32_t SR;            /*!< IWDG Status register,               Address offset: 0x0C */
  __IO uint32_t WINR;          /*!< IWDG Window register,               Address offset: 0x10 */
  __IO uint32_t EWCR;          /*!< IWDG Early Wakeup register,         Address offset: 0x14 */
} IWDG_TypeDef;
typedef struct
{
  __IO uint32_t CR;          /*!< WWDG Control register,              Address offset: 0x00 */
  __IO uint32_t CFR;         /*!< WWDG Configuration register,        Address offset: 0x04 */
  __IO uint32_t SR;          /*!< WWDG Status register,               Address offset: 0x08 */
} WWDG_TypeDef;
typedef struct
{
  uint32_t Prescaler;  /*!< Select the prescaler of the IWDG.
                            This parameter can be a value of @ref IWDG_Prescaler */

  uint32_t Reload;     /*!< Specifies the IWDG down-counter reload value.
                            This parameter must be a number between Min_Data = 0 and Max_Data = 0x0FFF */

  uint32_t Window;     /*!< Specifies the window value to be compared to the down-counter.
                            This parameter must be a number between Min_Data = 0 and Max_Data = 0x0FFF */

  uint32_t EWI;        /*!< Specifies if IWDG Early Wakeup Interrupt is enable or not and the comparator value.
                            This parameter must be a number between Min_Data = 0 and Max_Data = 0x0FFF
                            value 0 means that EWI is disabled */
} IWDG_InitTypeDef;
#define USE_HAL_IWDG_REGISTER_CALLBACKS 0
#define IWDG_HandleTypeDef CWatchdogIWDG0Handle
#define __IWDG_HandleTypeDef __CWatchdogIWDG0Handle
#if (USE_HAL_IWDG_REGISTER_CALLBACKS == 1)
typedef struct __IWDG_HandleTypeDef
#else
typedef struct
#endif /* USE_HAL_IWDG_REGISTER_CALLBACKS */
{
  IWDG_TypeDef                 *Instance;  /*!< Register base address    */

  IWDG_InitTypeDef             Init;       /*!< IWDG required parameters */

#if (USE_HAL_IWDG_REGISTER_CALLBACKS == 1)
  void (* EwiCallback)(struct __IWDG_HandleTypeDef *hiwdg);                  /*!< IWDG Early WakeUp Interrupt callback */
  void (* MspInitCallback)(struct __IWDG_HandleTypeDef *hiwdg);              /*!< IWDG Msp Init callback */
#endif /* USE_HAL_IWDG_REGISTER_CALLBACKS */
} IWDG_HandleTypeDef;
#undef USE_HAL_IWDG_REGISTER_CALLBACKS
#undef IWDG_HandleTypeDef
#undef __IWDG_HandleTypeDef
#define USE_HAL_IWDG_REGISTER_CALLBACKS 1
#define IWDG_HandleTypeDef CWatchdogIWDG1Handle
#define __IWDG_HandleTypeDef __CWatchdogIWDG1Handle
#if (USE_HAL_IWDG_REGISTER_CALLBACKS == 1)
typedef struct __IWDG_HandleTypeDef
#else
typedef struct
#endif /* USE_HAL_IWDG_REGISTER_CALLBACKS */
{
  IWDG_TypeDef                 *Instance;  /*!< Register base address    */

  IWDG_InitTypeDef             Init;       /*!< IWDG required parameters */

#if (USE_HAL_IWDG_REGISTER_CALLBACKS == 1)
  void (* EwiCallback)(struct __IWDG_HandleTypeDef *hiwdg);                  /*!< IWDG Early WakeUp Interrupt callback */
  void (* MspInitCallback)(struct __IWDG_HandleTypeDef *hiwdg);              /*!< IWDG Msp Init callback */
#endif /* USE_HAL_IWDG_REGISTER_CALLBACKS */
} IWDG_HandleTypeDef;
#undef USE_HAL_IWDG_REGISTER_CALLBACKS
#undef IWDG_HandleTypeDef
#undef __IWDG_HandleTypeDef
typedef enum
{
  HAL_IWDG_EWI_CB_ID          = 0x00U,    /*!< IWDG EWI callback ID */
  HAL_IWDG_MSPINIT_CB_ID      = 0x01U,    /*!< IWDG MspInit callback ID */
} HAL_IWDG_CallbackIDTypeDef;
#define IWDG_HandleTypeDef CWatchdogIWDG1Handle
#define pIWDG_CallbackTypeDef CWatchdogIWDG1Callback
typedef void (*pIWDG_CallbackTypeDef)(IWDG_HandleTypeDef *hppp);
#undef IWDG_HandleTypeDef
#undef pIWDG_CallbackTypeDef
typedef struct
{
  uint32_t Prescaler;     /*!< Specifies the prescaler value of the WWDG.
                               This parameter can be a value of @ref WWDG_Prescaler */

  uint32_t Window;        /*!< Specifies the WWDG window value to be compared to the downcounter.
                               This parameter must be a number Min_Data = 0x40 and Max_Data = 0x7F */

  uint32_t Counter;       /*!< Specifies the WWDG free-running downcounter  value.
                               This parameter must be a number between Min_Data = 0x40 and Max_Data = 0x7F */

  uint32_t EWIMode ;      /*!< Specifies if WWDG Early Wakeup Interrupt is enable or not.
                               This parameter can be a value of @ref WWDG_EWI_Mode */

} WWDG_InitTypeDef;
#define USE_HAL_WWDG_REGISTER_CALLBACKS 0
#define WWDG_HandleTypeDef CWatchdogWWDG0Handle
#define __WWDG_HandleTypeDef __CWatchdogWWDG0Handle
#if (USE_HAL_WWDG_REGISTER_CALLBACKS == 1)
typedef struct __WWDG_HandleTypeDef
#else
typedef struct
#endif /* USE_HAL_WWDG_REGISTER_CALLBACKS */
{
  WWDG_TypeDef      *Instance;  /*!< Register base address */

  WWDG_InitTypeDef  Init;       /*!< WWDG required parameters */

#if (USE_HAL_WWDG_REGISTER_CALLBACKS == 1)
  void (* EwiCallback)(struct __WWDG_HandleTypeDef *hwwdg);                  /*!< WWDG Early WakeUp Interrupt callback */

  void (* MspInitCallback)(struct __WWDG_HandleTypeDef *hwwdg);              /*!< WWDG Msp Init callback */
#endif /* USE_HAL_WWDG_REGISTER_CALLBACKS */
} WWDG_HandleTypeDef;
#undef USE_HAL_WWDG_REGISTER_CALLBACKS
#undef WWDG_HandleTypeDef
#undef __WWDG_HandleTypeDef
#define USE_HAL_WWDG_REGISTER_CALLBACKS 1
#define WWDG_HandleTypeDef CWatchdogWWDG1Handle
#define __WWDG_HandleTypeDef __CWatchdogWWDG1Handle
#if (USE_HAL_WWDG_REGISTER_CALLBACKS == 1)
typedef struct __WWDG_HandleTypeDef
#else
typedef struct
#endif /* USE_HAL_WWDG_REGISTER_CALLBACKS */
{
  WWDG_TypeDef      *Instance;  /*!< Register base address */

  WWDG_InitTypeDef  Init;       /*!< WWDG required parameters */

#if (USE_HAL_WWDG_REGISTER_CALLBACKS == 1)
  void (* EwiCallback)(struct __WWDG_HandleTypeDef *hwwdg);                  /*!< WWDG Early WakeUp Interrupt callback */

  void (* MspInitCallback)(struct __WWDG_HandleTypeDef *hwwdg);              /*!< WWDG Msp Init callback */
#endif /* USE_HAL_WWDG_REGISTER_CALLBACKS */
} WWDG_HandleTypeDef;
#undef USE_HAL_WWDG_REGISTER_CALLBACKS
#undef WWDG_HandleTypeDef
#undef __WWDG_HandleTypeDef
typedef enum
{
  HAL_WWDG_EWI_CB_ID          = 0x00U,    /*!< WWDG EWI callback ID */
  HAL_WWDG_MSPINIT_CB_ID      = 0x01U,    /*!< WWDG MspInit callback ID */
} HAL_WWDG_CallbackIDTypeDef;
#define WWDG_HandleTypeDef CWatchdogWWDG1Handle
#define pWWDG_CallbackTypeDef CWatchdogWWDG1Callback
typedef void (*pWWDG_CallbackTypeDef)(WWDG_HandleTypeDef *hppp);
#undef WWDG_HandleTypeDef
#undef pWWDG_CallbackTypeDef
#undef __IO
#endif
