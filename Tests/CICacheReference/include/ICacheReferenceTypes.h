/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted without body changes from STM32H7RS HAL at
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
#ifndef C_ICACHE_REFERENCE_TYPES_H
#define C_ICACHE_REFERENCE_TYPES_H
#include <stdint.h>
#define __IO volatile
typedef enum
{
  HAL_OK       = 0x00,
  HAL_ERROR    = 0x01,
  HAL_BUSY     = 0x02,
  HAL_TIMEOUT  = 0x03
} HAL_StatusTypeDef;
/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 * Exact CMSIS definitions from stm32h7s7xx.h at
 * 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
 * See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt. */
typedef struct
{
  __IO uint32_t CR;             /*!< ICACHE control register,                Address offset: 0x00 */
  __IO uint32_t SR;             /*!< ICACHE status register,                 Address offset: 0x04 */
  __IO uint32_t IER;            /*!< ICACHE interrupt enable register,       Address offset: 0x08 */
  __IO uint32_t FCR;            /*!< ICACHE flag clear register,             Address offset: 0x0C */
  __IO uint32_t HMONR;          /*!< ICACHE hit monitor register,            Address offset: 0x10 */
  __IO uint32_t MMONR;          /*!< ICACHE miss monitor register,           Address offset: 0x14 */
} ICACHE_TypeDef;
#endif
