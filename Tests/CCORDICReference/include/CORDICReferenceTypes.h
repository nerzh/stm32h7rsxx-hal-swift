/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
 * Extracted unchanged from HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
#ifndef C_CORDIC_REFERENCE_TYPES_H
#define C_CORDIC_REFERENCE_TYPES_H
#include "CORDICDMAReferenceTypes.h"
#define __IO volatile
/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 * Extracted unchanged from CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
 * See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt. */
typedef struct
{
  __IO uint32_t CSR;           /*!< CORDIC Control and Status register,             Address offset: 0x00 */
  __IO uint32_t WDATA;         /*!< CORDIC argument register,                       Address offset: 0x04 */
  __IO uint32_t RDATA;         /*!< CORDIC result register,                         Address offset: 0x08 */
} CORDIC_TypeDef;
/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted unchanged from HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
typedef enum
{
  HAL_CORDIC_STATE_RESET     = 0x00U,  /*!< CORDIC not yet initialized or disabled */
  HAL_CORDIC_STATE_READY     = 0x01U,  /*!< CORDIC initialized and ready for use   */
  HAL_CORDIC_STATE_BUSY      = 0x02U,  /*!< CORDIC internal process is ongoing     */
  HAL_CORDIC_STATE_ERROR     = 0x03U   /*!< CORDIC error state                     */
} HAL_CORDIC_StateTypeDef;
typedef struct
{
  uint32_t   Function;     /*!< Function
                                This parameter can be a value of @ref CORDIC_Function */

  uint32_t   Scale;        /*!< Scaling factor
                                This parameter can be a value of @ref CORDIC_Scale */

  uint32_t   InSize;       /*!< Width of input data
                                This parameter can be a value of @ref CORDIC_In_Size */

  uint32_t   OutSize;      /*!< Width of output data
                                This parameter can be a value of @ref CORDIC_Out_Size */

  uint32_t   NbWrite;      /*!< Number of 32-bit write expected for one calculation
                                This parameter can be a value of @ref CORDIC_Nb_Write */

  uint32_t   NbRead;       /*!< Number of 32-bit read expected after one calculation
                                This parameter can be a value of @ref CORDIC_Nb_Read */

  uint32_t   Precision;    /*!< Number of cycles for calculation
                                This parameter can be a value of @ref CORDIC_Precision_In_Cycles_Number */

} CORDIC_ConfigTypeDef;
typedef enum
{
  HAL_CORDIC_ERROR_CB_ID             = 0x00U,    /*!< CORDIC error callback ID */
  HAL_CORDIC_CALCULATE_CPLT_CB_ID    = 0x01U,    /*!< CORDIC calculate complete callback ID */

  HAL_CORDIC_MSPINIT_CB_ID           = 0x02U,    /*!< CORDIC MspInit callback ID */
  HAL_CORDIC_MSPDEINIT_CB_ID         = 0x03U,    /*!< CORDIC MspDeInit callback ID */

} HAL_CORDIC_CallbackIDTypeDef;
#define USE_HAL_CORDIC_REGISTER_CALLBACKS 0
#define CORDIC_HandleTypeDef CCORDIC0Handle
#define __CORDIC_HandleTypeDef __CCORDIC0Handle
#if USE_HAL_CORDIC_REGISTER_CALLBACKS == 1
typedef struct __CORDIC_HandleTypeDef
#else
typedef struct
#endif /* USE_HAL_CORDIC_REGISTER_CALLBACKS */
{
  CORDIC_TypeDef                *Instance;   /*!< Register base address */

  const int32_t                 *pInBuff;    /*!< Pointer to CORDIC input data buffer */

  int32_t                       *pOutBuff;   /*!< Pointer to CORDIC output data buffer */

  uint32_t                      NbCalcToOrder; /*!< Remaining number of calculation to order */

  uint32_t                      NbCalcToGet; /*!< Remaining number of calculation result to get */

  uint32_t                      DMADirection; /*!< Direction of CORDIC DMA transfers */

  DMA_HandleTypeDef             *hdmaIn;     /*!< CORDIC peripheral input data DMA handle parameters */

  DMA_HandleTypeDef             *hdmaOut;    /*!< CORDIC peripheral output data DMA handle parameters */

  HAL_LockTypeDef               Lock;        /*!< CORDIC locking object */

  __IO HAL_CORDIC_StateTypeDef  State;       /*!< CORDIC state */

  __IO uint32_t                 ErrorCode;   /*!< CORDIC peripheral error code
                                                  This parameter can be a value of @ref CORDIC_Error_Code */

#if USE_HAL_CORDIC_REGISTER_CALLBACKS == 1
  void (* ErrorCallback)(struct __CORDIC_HandleTypeDef *hcordic);          /*!< CORDIC error callback */
  void (* CalculateCpltCallback)(struct __CORDIC_HandleTypeDef *hcordic);  /*!< CORDIC calculate complete callback */

  void (* MspInitCallback)(struct __CORDIC_HandleTypeDef *hcordic);        /*!< CORDIC Msp Init callback */
  void (* MspDeInitCallback)(struct __CORDIC_HandleTypeDef *hcordic);      /*!< CORDIC Msp DeInit callback */

#endif /* (USE_HAL_CORDIC_REGISTER_CALLBACKS) */

} CORDIC_HandleTypeDef;
#undef USE_HAL_CORDIC_REGISTER_CALLBACKS
#undef CORDIC_HandleTypeDef
#undef __CORDIC_HandleTypeDef
#define USE_HAL_CORDIC_REGISTER_CALLBACKS 1
#define CORDIC_HandleTypeDef CCORDIC1Handle
#define __CORDIC_HandleTypeDef __CCORDIC1Handle
#if USE_HAL_CORDIC_REGISTER_CALLBACKS == 1
typedef struct __CORDIC_HandleTypeDef
#else
typedef struct
#endif /* USE_HAL_CORDIC_REGISTER_CALLBACKS */
{
  CORDIC_TypeDef                *Instance;   /*!< Register base address */

  const int32_t                 *pInBuff;    /*!< Pointer to CORDIC input data buffer */

  int32_t                       *pOutBuff;   /*!< Pointer to CORDIC output data buffer */

  uint32_t                      NbCalcToOrder; /*!< Remaining number of calculation to order */

  uint32_t                      NbCalcToGet; /*!< Remaining number of calculation result to get */

  uint32_t                      DMADirection; /*!< Direction of CORDIC DMA transfers */

  DMA_HandleTypeDef             *hdmaIn;     /*!< CORDIC peripheral input data DMA handle parameters */

  DMA_HandleTypeDef             *hdmaOut;    /*!< CORDIC peripheral output data DMA handle parameters */

  HAL_LockTypeDef               Lock;        /*!< CORDIC locking object */

  __IO HAL_CORDIC_StateTypeDef  State;       /*!< CORDIC state */

  __IO uint32_t                 ErrorCode;   /*!< CORDIC peripheral error code
                                                  This parameter can be a value of @ref CORDIC_Error_Code */

#if USE_HAL_CORDIC_REGISTER_CALLBACKS == 1
  void (* ErrorCallback)(struct __CORDIC_HandleTypeDef *hcordic);          /*!< CORDIC error callback */
  void (* CalculateCpltCallback)(struct __CORDIC_HandleTypeDef *hcordic);  /*!< CORDIC calculate complete callback */

  void (* MspInitCallback)(struct __CORDIC_HandleTypeDef *hcordic);        /*!< CORDIC Msp Init callback */
  void (* MspDeInitCallback)(struct __CORDIC_HandleTypeDef *hcordic);      /*!< CORDIC Msp DeInit callback */

#endif /* (USE_HAL_CORDIC_REGISTER_CALLBACKS) */

} CORDIC_HandleTypeDef;
#undef USE_HAL_CORDIC_REGISTER_CALLBACKS
#undef CORDIC_HandleTypeDef
#undef __CORDIC_HandleTypeDef
#endif
