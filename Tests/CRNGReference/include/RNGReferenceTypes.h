/* Derived from STMicroelectronics STM32H7RSxx HAL Driver, commit
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * Licensed under BSD-3-Clause; see LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.
 * HAL types retain their field declarations; handle names are instantiated for
 * both callback modes. The test-only CMSIS register adaptation is marked below.
 */
#ifndef C_RNG_REFERENCE_TYPES_H
#define C_RNG_REFERENCE_TYPES_H
#include <stdint.h>
#define __IO volatile
typedef enum { HAL_OK=0, HAL_ERROR=1, HAL_BUSY=2, HAL_TIMEOUT=3 } HAL_StatusTypeDef;
typedef enum { HAL_UNLOCKED=0, HAL_LOCKED=1 } HAL_LockTypeDef;
/* CMSIS device declaration from commit 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
 * Copyright (c) 2022 STMicroelectronics. Licensed under Apache-2.0; see
 * LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.
 * The sole CMSIS layout adaptation is DR[1] in place of DR. The array has
 * exactly the same size/alignment/offset and permits a read hook in test TUs.
 * All other fields are the pinned stm32h7s3xx.h declaration. */
typedef struct {
  __IO uint32_t CR;
  __IO uint32_t SR;
  __IO uint32_t DR[1];
  uint32_t RESERVED;
  __IO uint32_t HTCR;
} RNG_TypeDef;
typedef struct
{
  uint32_t                    ClockErrorDetection; /*!< CED Clock error detection */
} RNG_InitTypeDef;
typedef enum
{
  HAL_RNG_STATE_RESET     = 0x00U,  /*!< RNG not yet initialized or disabled */
  HAL_RNG_STATE_READY     = 0x01U,  /*!< RNG initialized and ready for use   */
  HAL_RNG_STATE_BUSY      = 0x02U,  /*!< RNG internal process is ongoing     */
  HAL_RNG_STATE_TIMEOUT   = 0x03U,  /*!< RNG timeout state                   */
  HAL_RNG_STATE_ERROR     = 0x04U   /*!< RNG error state                     */

} HAL_RNG_StateTypeDef;
typedef struct
{
  uint32_t        Config1;           /*!< Config1 must be a value between 0 and 0x3F */
  uint32_t        Config2;           /*!< Config2 must be a value between 0 and 0x7 */
  uint32_t        Config3;           /*!< Config3 must be a value between 0 and 0xF */
  uint32_t        ClockDivider;      /*!< Clock Divider factor.This parameter can
                                          be a value of @ref RNGEx_Clock_Divider_Factor   */
  uint32_t        NistCompliance;    /*!< NIST compliance.This parameter can be a
                                          value of @ref RNGEx_NIST_Compliance   */
  uint32_t        AutoReset;         /*!< automatic reset When a noise source error occurs
                                          value of @ref RNGEx_Auto_Reset   */
  uint32_t        HealthTest;           /*!< RNG health test control must be a value
                                             between 0x0FFCABFF and 0x00005200 */
} RNG_ConfigTypeDef;
#define USE_HAL_RNG_REGISTER_CALLBACKS 0
#define RNG_HandleTypeDef CRNG0Handle
#define __RNG_HandleTypeDef __CRNG0Handle
#if (USE_HAL_RNG_REGISTER_CALLBACKS == 1)
typedef struct  __RNG_HandleTypeDef
#else
typedef struct
#endif /* USE_HAL_RNG_REGISTER_CALLBACKS */
{
  RNG_TypeDef                 *Instance;    /*!< Register base address   */

  RNG_InitTypeDef             Init;         /*!< RNG configuration parameters */

  HAL_LockTypeDef             Lock;         /*!< RNG locking object      */

  __IO HAL_RNG_StateTypeDef   State;        /*!< RNG communication state */

  __IO  uint32_t              ErrorCode;    /*!< RNG Error code          */

  uint32_t                    RandomNumber; /*!< Last Generated RNG Data */

#if (USE_HAL_RNG_REGISTER_CALLBACKS == 1)
  void (* ReadyDataCallback)(struct __RNG_HandleTypeDef *hrng, uint32_t random32bit);  /*!< RNG Data Ready Callback    */
  void (* ErrorCallback)(struct __RNG_HandleTypeDef *hrng);                            /*!< RNG Error Callback         */

  void (* MspInitCallback)(struct __RNG_HandleTypeDef *hrng);                          /*!< RNG Msp Init callback      */
  void (* MspDeInitCallback)(struct __RNG_HandleTypeDef *hrng);                        /*!< RNG Msp DeInit callback    */
#endif  /* USE_HAL_RNG_REGISTER_CALLBACKS */

} RNG_HandleTypeDef;
#undef RNG_HandleTypeDef
#undef __RNG_HandleTypeDef
#undef USE_HAL_RNG_REGISTER_CALLBACKS
#define USE_HAL_RNG_REGISTER_CALLBACKS 1
#define RNG_HandleTypeDef CRNG1Handle
#define __RNG_HandleTypeDef __CRNG1Handle
#if (USE_HAL_RNG_REGISTER_CALLBACKS == 1)
typedef struct  __RNG_HandleTypeDef
#else
typedef struct
#endif /* USE_HAL_RNG_REGISTER_CALLBACKS */
{
  RNG_TypeDef                 *Instance;    /*!< Register base address   */

  RNG_InitTypeDef             Init;         /*!< RNG configuration parameters */

  HAL_LockTypeDef             Lock;         /*!< RNG locking object      */

  __IO HAL_RNG_StateTypeDef   State;        /*!< RNG communication state */

  __IO  uint32_t              ErrorCode;    /*!< RNG Error code          */

  uint32_t                    RandomNumber; /*!< Last Generated RNG Data */

#if (USE_HAL_RNG_REGISTER_CALLBACKS == 1)
  void (* ReadyDataCallback)(struct __RNG_HandleTypeDef *hrng, uint32_t random32bit);  /*!< RNG Data Ready Callback    */
  void (* ErrorCallback)(struct __RNG_HandleTypeDef *hrng);                            /*!< RNG Error Callback         */

  void (* MspInitCallback)(struct __RNG_HandleTypeDef *hrng);                          /*!< RNG Msp Init callback      */
  void (* MspDeInitCallback)(struct __RNG_HandleTypeDef *hrng);                        /*!< RNG Msp DeInit callback    */
#endif  /* USE_HAL_RNG_REGISTER_CALLBACKS */

} RNG_HandleTypeDef;
typedef enum
{
  HAL_RNG_ERROR_CB_ID                   = 0x00U,     /*!< RNG Error Callback ID          */

  HAL_RNG_MSPINIT_CB_ID                 = 0x01U,     /*!< RNG MspInit callback ID        */
  HAL_RNG_MSPDEINIT_CB_ID               = 0x02U      /*!< RNG MspDeInit callback ID      */

} HAL_RNG_CallbackIDTypeDef;

/**
  * @brief  HAL RNG Callback pointer definition
  */
typedef  void (*pRNG_CallbackTypeDef)(RNG_HandleTypeDef *hrng);                                  /*!< pointer to a common RNG callback function */
typedef  void (*pRNG_ReadyDataCallbackTypeDef)(RNG_HandleTypeDef *hrng, uint32_t random32bit);
#undef RNG_HandleTypeDef
#undef __RNG_HandleTypeDef
#undef USE_HAL_RNG_REGISTER_CALLBACKS
#undef __IO
#endif
