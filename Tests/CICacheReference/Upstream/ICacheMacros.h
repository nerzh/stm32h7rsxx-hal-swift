/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted without body changes from STM32H7RS HAL at
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
#define ICACHE_1WAY                    0UL               /*!< 1-way cache (direct mapped cache) */
#define ICACHE_4WAYS                   ICACHE_CR_WAYSEL  /*!< 4-ways set associative cache (default) */
#define ICACHE_MONITOR_HIT_MISS        (ICACHE_CR_HITMEN | ICACHE_CR_MISSMEN) /*!< Hit & Miss monitoring */
#define ICACHE_MONITOR_HIT             ICACHE_CR_HITMEN                       /*!< Hit monitoring */
#define ICACHE_MONITOR_MISS            ICACHE_CR_MISSMEN                      /*!< Miss monitoring */
#define ICACHE_IT_BUSYEND              ICACHE_IER_BSYENDIE /*!< Busy end interrupt */
#define ICACHE_IT_ERROR                ICACHE_IER_ERRIE    /*!< Cache error interrupt */
#define ICACHE_FLAG_BUSY               ICACHE_SR_BUSYF     /*!< Busy flag */
#define ICACHE_FLAG_BUSYEND            ICACHE_SR_BSYENDF   /*!< Busy end flag */
#define ICACHE_FLAG_ERROR              ICACHE_SR_ERRF      /*!< Cache error flag */
#define __HAL_ICACHE_ENABLE_IT(__INTERRUPT__) SET_BIT(ICACHE->IER, (__INTERRUPT__))
#define __HAL_ICACHE_DISABLE_IT(__INTERRUPT__) CLEAR_BIT(ICACHE->IER, (__INTERRUPT__))
#define __HAL_ICACHE_GET_IT_SOURCE(__INTERRUPT__)  \
  ((READ_BIT(ICACHE->IER, (__INTERRUPT__)) == (__INTERRUPT__)) ? 1U : 0U)
#define __HAL_ICACHE_GET_FLAG(__FLAG__) ((READ_BIT(ICACHE->SR, (__FLAG__)) != 0U) ? 1U : 0U)
#define __HAL_ICACHE_CLEAR_FLAG(__FLAG__) WRITE_REG(ICACHE->FCR, (__FLAG__))
