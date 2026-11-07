/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted unchanged from HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
#define UNUSED(X) (void)X      /* To avoid gcc/g++ warnings */

#define HAL_MAX_DELAY      0xFFFFFFFFU

#define HAL_IS_BIT_SET(REG, BIT)         (((REG) & (BIT)) == (BIT))

#define HAL_IS_BIT_CLR(REG, BIT)         (((REG) & (BIT)) == 0U)

#define __HAL_LOCK(__HANDLE__)            \
  do{                                     \
    if((__HANDLE__)->Lock == HAL_LOCKED)  \
    {                                     \
      return HAL_BUSY;                    \
    }                                     \
    else                                  \
    {                                     \
      (__HANDLE__)->Lock = HAL_LOCKED;    \
    }                                     \
  }while (0)

#define __HAL_UNLOCK(__HANDLE__)          \
  do{                                     \
    (__HANDLE__)->Lock = HAL_UNLOCKED;    \
  }while (0)
