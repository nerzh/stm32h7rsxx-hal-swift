/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
 * Extracted unchanged from HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */

#ifndef C_HASH_REFERENCE_TYPES_H
#define C_HASH_REFERENCE_TYPES_H
#include "HASHDMAReferenceTypes.h"

/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 * Extracted unchanged from CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
 * See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt. */

typedef struct
{
  __IO uint32_t CR;               /*!< HASH control register,          Address offset: 0x00        */
  __IO uint32_t DIN;              /*!< HASH data input register,       Address offset: 0x04        */
  __IO uint32_t STR;              /*!< HASH start register,            Address offset: 0x08        */
  __IO uint32_t HR[5];            /*!< HASH digest registers,          Address offset: 0x0C-0x1C   */
  __IO uint32_t IMR;              /*!< HASH interrupt enable register, Address offset: 0x20        */
  __IO uint32_t SR;               /*!< HASH status register,           Address offset: 0x24        */
       uint32_t RESERVED[52];     /*!< Reserved, 0x28-0xF4                                         */
  __IO uint32_t CSR[103];         /*!< HASH context swap registers,    Address offset: 0x0F8-0x290 */
} HASH_TypeDef;
typedef struct
{
  __IO uint32_t HR[16];            /*!< HASH digest registers,          Address offset: 0x310-0x34C */
} HASH_DIGEST_TypeDef;
typedef enum
{
  RESET = 0,
  SET = !RESET
} FlagStatus, ITStatus;
/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted unchanged from HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */

typedef struct
{
  uint32_t DataType;    /*!< no swap (32-bit data), half word swap (16-bit data), byte swap (8-bit data) or bit swap
                             (1-bit data). This parameter can be a value of @ref HASH_Data_Type.       */

  uint32_t KeySize;     /*!< The key size is used only in HMAC operation.                 */

  uint8_t *pKey;        /*!< The key is used only in HMAC operation.                      */

  uint32_t Algorithm;   /*!<  HASH algorithm MD5, SHA1 or SHA2.
                            This parameter can be a value of @ref HASH_Algorithm_Selection */


} HASH_ConfigTypeDef;
typedef enum
{
  HAL_HASH_STATE_RESET             = 0x00U,    /*!< Peripheral is not initialized            */
  HAL_HASH_STATE_READY             = 0x01U,    /*!< Peripheral Initialized and ready for use */
  HAL_HASH_STATE_BUSY              = 0x02U,    /*!< Processing (hashing) is ongoing          */
  HAL_HASH_STATE_SUSPENDED         = 0x03U     /*!< Suspended state                          */
} HAL_HASH_StateTypeDef;
typedef enum
{
  HAL_HASH_PHASE_READY             = 0x01U,    /*!< HASH peripheral is ready to start                  */
  HAL_HASH_PHASE_PROCESS           = 0x02U,    /*!< HASH peripheral is in HASH processing phase        */
  HAL_HASH_PHASE_HMAC_STEP_1       = 0x03U,    /*!< HASH peripheral is in HMAC step 1 processing phase
                                              (step 1 consists in entering the inner hash function key)*/
  HAL_HASH_PHASE_HMAC_STEP_2       = 0x04U,    /*!< HASH peripheral is in HMAC step 2 processing phase
                                              (step 2 consists in entering the message text)           */
  HAL_HASH_PHASE_HMAC_STEP_3       = 0x05U     /*!< HASH peripheral is in HMAC step 3 processing phase
                                              (step 3 consists in entering the outer hash function key)*/

} HAL_HASH_PhaseTypeDef;
typedef enum
{
  HAL_HASH_SUSPEND_NONE            = 0x00U,    /*!< HASH peripheral suspension not requested */
  HAL_HASH_SUSPEND                 = 0x01U     /*!< HASH peripheral suspension is requested  */
} HAL_HASH_SuspendTypeDef;
typedef enum
{
  HAL_HASH_MSPINIT_CB_ID           = 0x00U,    /*!< HASH MspInit callback ID                       */
  HAL_HASH_MSPDEINIT_CB_ID         = 0x01U,    /*!< HASH MspDeInit callback ID                     */
  HAL_HASH_INPUTCPLT_CB_ID         = 0x02U,    /*!< HASH input completion callback ID              */
  HAL_HASH_DGSTCPLT_CB_ID          = 0x03U,    /*!< HASH digest computation completion callback ID */
  HAL_HASH_ERROR_CB_ID             = 0x04U,    /*!< HASH error callback ID                         */
} HAL_HASH_CallbackIDTypeDef;
#define USE_HAL_HASH_REGISTER_CALLBACKS 0
#define USE_HAL_HASH_SUSPEND_RESUME 0
#define HASH_HandleTypeDef CHASH00Handle
#define __HASH_HandleTypeDef __CHASH00Handle
#if (USE_HAL_HASH_REGISTER_CALLBACKS == 1)
typedef struct __HASH_HandleTypeDef
#else
typedef struct
#endif /* (USE_HAL_HASH_REGISTER_CALLBACKS) */
{
  HASH_TypeDef               *Instance;        /*!< HASH Register base address              */

  HASH_ConfigTypeDef           Init;           /*!< HASH required parameters                */

  uint8_t const              *pHashInBuffPtr;  /*!< Pointer to input buffer                 */

  uint8_t                    *pHashOutBuffPtr; /*!< Pointer to output buffer (digest)       */

  __IO uint32_t              HashInCount;      /*!< Counter of inputted data                */

  uint32_t                   Size;             /*!< Size of buffer to be processed in bytes */

  uint8_t                   *pHashKeyBuffPtr;  /*!< Pointer to key buffer (HMAC only)       */

  HAL_HASH_PhaseTypeDef      Phase;            /*!< HASH peripheral phase                   */

  DMA_HandleTypeDef          *hdmain;          /*!< HASH In DMA Handle parameters           */

  HAL_LockTypeDef            Lock;             /*!< Locking object                          */

  __IO  uint32_t             ErrorCode;        /*!< HASH Error code                         */

  __IO HAL_HASH_StateTypeDef State;            /*!< HASH peripheral state                   */

  __IO  uint32_t             Accumulation;     /*!< HASH multi buffers accumulation flag    */

#if (USE_HAL_HASH_REGISTER_CALLBACKS == 1)
  void (* InCpltCallback)(struct __HASH_HandleTypeDef *hhash);         /*!< HASH input completion callback            */

  void (* DgstCpltCallback)(struct __HASH_HandleTypeDef *hhash);       /*!< HASH digest computation complete callback */

  void (* ErrorCallback)(struct __HASH_HandleTypeDef *hhash);          /*!< HASH error callback                       */

  void (* MspInitCallback)(struct __HASH_HandleTypeDef *hhash);        /*!< HASH Msp Init callback                    */

  void (* MspDeInitCallback)(struct __HASH_HandleTypeDef *hhash);      /*!< HASH Msp DeInit callback                  */

#endif /* (USE_HAL_HASH_REGISTER_CALLBACKS) */
#if (USE_HAL_HASH_SUSPEND_RESUME == 1U)
  __IO HAL_HASH_SuspendTypeDef    SuspendRequest;    /*!< HASH peripheral suspension request flag */

  HASH_ConfigTypeDef         Init_saved;             /*!< Saved HASH required parameters          */

  uint8_t const              *pHashInBuffPtr_saved;  /*!< Saved pointer to input buffer           */

  uint8_t                    *pHashOutBuffPtr_saved; /*!< Saved pointer to output buffer (digest) */

  __IO uint32_t              HashInCount_saved;      /*!< Saved counter of inputted data          */

  uint32_t                   Size_saved;             /*!< Saved size of buffer to be processed    */

  uint8_t                    *pHashKeyBuffPtr_saved; /*!< Saved pointer to key buffer (HMAC only) */

  HAL_HASH_PhaseTypeDef      Phase_saved;            /*!< Saved HASH peripheral phase             */
#endif /* USE_HAL_HASH_SUSPEND_RESUME */

} HASH_HandleTypeDef;
#undef USE_HAL_HASH_REGISTER_CALLBACKS
#undef USE_HAL_HASH_SUSPEND_RESUME
#undef HASH_HandleTypeDef
#undef __HASH_HandleTypeDef
#define USE_HAL_HASH_REGISTER_CALLBACKS 0
#define USE_HAL_HASH_SUSPEND_RESUME 1
#define HASH_HandleTypeDef CHASH01Handle
#define __HASH_HandleTypeDef __CHASH01Handle
#if (USE_HAL_HASH_REGISTER_CALLBACKS == 1)
typedef struct __HASH_HandleTypeDef
#else
typedef struct
#endif /* (USE_HAL_HASH_REGISTER_CALLBACKS) */
{
  HASH_TypeDef               *Instance;        /*!< HASH Register base address              */

  HASH_ConfigTypeDef           Init;           /*!< HASH required parameters                */

  uint8_t const              *pHashInBuffPtr;  /*!< Pointer to input buffer                 */

  uint8_t                    *pHashOutBuffPtr; /*!< Pointer to output buffer (digest)       */

  __IO uint32_t              HashInCount;      /*!< Counter of inputted data                */

  uint32_t                   Size;             /*!< Size of buffer to be processed in bytes */

  uint8_t                   *pHashKeyBuffPtr;  /*!< Pointer to key buffer (HMAC only)       */

  HAL_HASH_PhaseTypeDef      Phase;            /*!< HASH peripheral phase                   */

  DMA_HandleTypeDef          *hdmain;          /*!< HASH In DMA Handle parameters           */

  HAL_LockTypeDef            Lock;             /*!< Locking object                          */

  __IO  uint32_t             ErrorCode;        /*!< HASH Error code                         */

  __IO HAL_HASH_StateTypeDef State;            /*!< HASH peripheral state                   */

  __IO  uint32_t             Accumulation;     /*!< HASH multi buffers accumulation flag    */

#if (USE_HAL_HASH_REGISTER_CALLBACKS == 1)
  void (* InCpltCallback)(struct __HASH_HandleTypeDef *hhash);         /*!< HASH input completion callback            */

  void (* DgstCpltCallback)(struct __HASH_HandleTypeDef *hhash);       /*!< HASH digest computation complete callback */

  void (* ErrorCallback)(struct __HASH_HandleTypeDef *hhash);          /*!< HASH error callback                       */

  void (* MspInitCallback)(struct __HASH_HandleTypeDef *hhash);        /*!< HASH Msp Init callback                    */

  void (* MspDeInitCallback)(struct __HASH_HandleTypeDef *hhash);      /*!< HASH Msp DeInit callback                  */

#endif /* (USE_HAL_HASH_REGISTER_CALLBACKS) */
#if (USE_HAL_HASH_SUSPEND_RESUME == 1U)
  __IO HAL_HASH_SuspendTypeDef    SuspendRequest;    /*!< HASH peripheral suspension request flag */

  HASH_ConfigTypeDef         Init_saved;             /*!< Saved HASH required parameters          */

  uint8_t const              *pHashInBuffPtr_saved;  /*!< Saved pointer to input buffer           */

  uint8_t                    *pHashOutBuffPtr_saved; /*!< Saved pointer to output buffer (digest) */

  __IO uint32_t              HashInCount_saved;      /*!< Saved counter of inputted data          */

  uint32_t                   Size_saved;             /*!< Saved size of buffer to be processed    */

  uint8_t                    *pHashKeyBuffPtr_saved; /*!< Saved pointer to key buffer (HMAC only) */

  HAL_HASH_PhaseTypeDef      Phase_saved;            /*!< Saved HASH peripheral phase             */
#endif /* USE_HAL_HASH_SUSPEND_RESUME */

} HASH_HandleTypeDef;
#undef USE_HAL_HASH_REGISTER_CALLBACKS
#undef USE_HAL_HASH_SUSPEND_RESUME
#undef HASH_HandleTypeDef
#undef __HASH_HandleTypeDef
#define USE_HAL_HASH_REGISTER_CALLBACKS 1
#define USE_HAL_HASH_SUSPEND_RESUME 0
#define HASH_HandleTypeDef CHASH10Handle
#define __HASH_HandleTypeDef __CHASH10Handle
#if (USE_HAL_HASH_REGISTER_CALLBACKS == 1)
typedef struct __HASH_HandleTypeDef
#else
typedef struct
#endif /* (USE_HAL_HASH_REGISTER_CALLBACKS) */
{
  HASH_TypeDef               *Instance;        /*!< HASH Register base address              */

  HASH_ConfigTypeDef           Init;           /*!< HASH required parameters                */

  uint8_t const              *pHashInBuffPtr;  /*!< Pointer to input buffer                 */

  uint8_t                    *pHashOutBuffPtr; /*!< Pointer to output buffer (digest)       */

  __IO uint32_t              HashInCount;      /*!< Counter of inputted data                */

  uint32_t                   Size;             /*!< Size of buffer to be processed in bytes */

  uint8_t                   *pHashKeyBuffPtr;  /*!< Pointer to key buffer (HMAC only)       */

  HAL_HASH_PhaseTypeDef      Phase;            /*!< HASH peripheral phase                   */

  DMA_HandleTypeDef          *hdmain;          /*!< HASH In DMA Handle parameters           */

  HAL_LockTypeDef            Lock;             /*!< Locking object                          */

  __IO  uint32_t             ErrorCode;        /*!< HASH Error code                         */

  __IO HAL_HASH_StateTypeDef State;            /*!< HASH peripheral state                   */

  __IO  uint32_t             Accumulation;     /*!< HASH multi buffers accumulation flag    */

#if (USE_HAL_HASH_REGISTER_CALLBACKS == 1)
  void (* InCpltCallback)(struct __HASH_HandleTypeDef *hhash);         /*!< HASH input completion callback            */

  void (* DgstCpltCallback)(struct __HASH_HandleTypeDef *hhash);       /*!< HASH digest computation complete callback */

  void (* ErrorCallback)(struct __HASH_HandleTypeDef *hhash);          /*!< HASH error callback                       */

  void (* MspInitCallback)(struct __HASH_HandleTypeDef *hhash);        /*!< HASH Msp Init callback                    */

  void (* MspDeInitCallback)(struct __HASH_HandleTypeDef *hhash);      /*!< HASH Msp DeInit callback                  */

#endif /* (USE_HAL_HASH_REGISTER_CALLBACKS) */
#if (USE_HAL_HASH_SUSPEND_RESUME == 1U)
  __IO HAL_HASH_SuspendTypeDef    SuspendRequest;    /*!< HASH peripheral suspension request flag */

  HASH_ConfigTypeDef         Init_saved;             /*!< Saved HASH required parameters          */

  uint8_t const              *pHashInBuffPtr_saved;  /*!< Saved pointer to input buffer           */

  uint8_t                    *pHashOutBuffPtr_saved; /*!< Saved pointer to output buffer (digest) */

  __IO uint32_t              HashInCount_saved;      /*!< Saved counter of inputted data          */

  uint32_t                   Size_saved;             /*!< Saved size of buffer to be processed    */

  uint8_t                    *pHashKeyBuffPtr_saved; /*!< Saved pointer to key buffer (HMAC only) */

  HAL_HASH_PhaseTypeDef      Phase_saved;            /*!< Saved HASH peripheral phase             */
#endif /* USE_HAL_HASH_SUSPEND_RESUME */

} HASH_HandleTypeDef;
#undef USE_HAL_HASH_REGISTER_CALLBACKS
#undef USE_HAL_HASH_SUSPEND_RESUME
#undef HASH_HandleTypeDef
#undef __HASH_HandleTypeDef
#define USE_HAL_HASH_REGISTER_CALLBACKS 1
#define USE_HAL_HASH_SUSPEND_RESUME 1
#define HASH_HandleTypeDef CHASH11Handle
#define __HASH_HandleTypeDef __CHASH11Handle
#if (USE_HAL_HASH_REGISTER_CALLBACKS == 1)
typedef struct __HASH_HandleTypeDef
#else
typedef struct
#endif /* (USE_HAL_HASH_REGISTER_CALLBACKS) */
{
  HASH_TypeDef               *Instance;        /*!< HASH Register base address              */

  HASH_ConfigTypeDef           Init;           /*!< HASH required parameters                */

  uint8_t const              *pHashInBuffPtr;  /*!< Pointer to input buffer                 */

  uint8_t                    *pHashOutBuffPtr; /*!< Pointer to output buffer (digest)       */

  __IO uint32_t              HashInCount;      /*!< Counter of inputted data                */

  uint32_t                   Size;             /*!< Size of buffer to be processed in bytes */

  uint8_t                   *pHashKeyBuffPtr;  /*!< Pointer to key buffer (HMAC only)       */

  HAL_HASH_PhaseTypeDef      Phase;            /*!< HASH peripheral phase                   */

  DMA_HandleTypeDef          *hdmain;          /*!< HASH In DMA Handle parameters           */

  HAL_LockTypeDef            Lock;             /*!< Locking object                          */

  __IO  uint32_t             ErrorCode;        /*!< HASH Error code                         */

  __IO HAL_HASH_StateTypeDef State;            /*!< HASH peripheral state                   */

  __IO  uint32_t             Accumulation;     /*!< HASH multi buffers accumulation flag    */

#if (USE_HAL_HASH_REGISTER_CALLBACKS == 1)
  void (* InCpltCallback)(struct __HASH_HandleTypeDef *hhash);         /*!< HASH input completion callback            */

  void (* DgstCpltCallback)(struct __HASH_HandleTypeDef *hhash);       /*!< HASH digest computation complete callback */

  void (* ErrorCallback)(struct __HASH_HandleTypeDef *hhash);          /*!< HASH error callback                       */

  void (* MspInitCallback)(struct __HASH_HandleTypeDef *hhash);        /*!< HASH Msp Init callback                    */

  void (* MspDeInitCallback)(struct __HASH_HandleTypeDef *hhash);      /*!< HASH Msp DeInit callback                  */

#endif /* (USE_HAL_HASH_REGISTER_CALLBACKS) */
#if (USE_HAL_HASH_SUSPEND_RESUME == 1U)
  __IO HAL_HASH_SuspendTypeDef    SuspendRequest;    /*!< HASH peripheral suspension request flag */

  HASH_ConfigTypeDef         Init_saved;             /*!< Saved HASH required parameters          */

  uint8_t const              *pHashInBuffPtr_saved;  /*!< Saved pointer to input buffer           */

  uint8_t                    *pHashOutBuffPtr_saved; /*!< Saved pointer to output buffer (digest) */

  __IO uint32_t              HashInCount_saved;      /*!< Saved counter of inputted data          */

  uint32_t                   Size_saved;             /*!< Saved size of buffer to be processed    */

  uint8_t                    *pHashKeyBuffPtr_saved; /*!< Saved pointer to key buffer (HMAC only) */

  HAL_HASH_PhaseTypeDef      Phase_saved;            /*!< Saved HASH peripheral phase             */
#endif /* USE_HAL_HASH_SUSPEND_RESUME */

} HASH_HandleTypeDef;
#undef USE_HAL_HASH_REGISTER_CALLBACKS
#undef USE_HAL_HASH_SUSPEND_RESUME
#undef HASH_HandleTypeDef
#undef __HASH_HandleTypeDef
#endif
