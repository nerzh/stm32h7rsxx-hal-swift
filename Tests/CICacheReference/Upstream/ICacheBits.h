/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 * Exact CMSIS definitions from stm32h7s7xx.h at
 * 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
 * See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt. */
#define ICACHE_BASE                     (AHB5PERIPH_BASE + 0x015000UL)
#define ICACHE_CR_EN_Pos               (0U)
#define ICACHE_CR_EN_Msk               (0x1UL << ICACHE_CR_EN_Pos)             /*!< 0x00000001 */
#define ICACHE_CR_EN                   ICACHE_CR_EN_Msk                        /*!< Enable */
#define ICACHE_CR_CACHEINV_Pos         (1U)
#define ICACHE_CR_CACHEINV_Msk         (0x1UL << ICACHE_CR_CACHEINV_Pos)       /*!< 0x00000002 */
#define ICACHE_CR_CACHEINV             ICACHE_CR_CACHEINV_Msk                  /*!< Cache invalidation */
#define ICACHE_CR_WAYSEL_Pos           (2U)
#define ICACHE_CR_WAYSEL_Msk           (0x1UL << ICACHE_CR_WAYSEL_Pos)         /*!< 0x00000004 */
#define ICACHE_CR_WAYSEL               ICACHE_CR_WAYSEL_Msk                    /*!< Ways selection */
#define ICACHE_CR_HITMEN_Pos           (16U)
#define ICACHE_CR_HITMEN_Msk           (0x1UL << ICACHE_CR_HITMEN_Pos)         /*!< 0x00010000 */
#define ICACHE_CR_HITMEN               ICACHE_CR_HITMEN_Msk                    /*!< Hit monitor enable */
#define ICACHE_CR_MISSMEN_Pos          (17U)
#define ICACHE_CR_MISSMEN_Msk          (0x1UL << ICACHE_CR_MISSMEN_Pos)        /*!< 0x00020000 */
#define ICACHE_CR_MISSMEN              ICACHE_CR_MISSMEN_Msk                   /*!< Miss monitor enable */
#define ICACHE_CR_HITMRST_Pos          (18U)
#define ICACHE_CR_HITMRST_Msk          (0x1UL << ICACHE_CR_HITMRST_Pos)        /*!< 0x00040000 */
#define ICACHE_CR_HITMRST              ICACHE_CR_HITMRST_Msk                   /*!< Hit monitor reset */
#define ICACHE_CR_MISSMRST_Pos         (19U)
#define ICACHE_CR_MISSMRST_Msk         (0x1UL << ICACHE_CR_MISSMRST_Pos)       /*!< 0x00080000 */
#define ICACHE_CR_MISSMRST             ICACHE_CR_MISSMRST_Msk                  /*!< Miss monitor reset */
#define ICACHE_SR_BUSYF_Pos            (0U)
#define ICACHE_SR_BUSYF_Msk            (0x1UL << ICACHE_SR_BUSYF_Pos)          /*!< 0x00000001 */
#define ICACHE_SR_BUSYF                ICACHE_SR_BUSYF_Msk                     /*!< Busy flag */
#define ICACHE_SR_BSYENDF_Pos          (1U)
#define ICACHE_SR_BSYENDF_Msk          (0x1UL << ICACHE_SR_BSYENDF_Pos)        /*!< 0x00000002 */
#define ICACHE_SR_BSYENDF              ICACHE_SR_BSYENDF_Msk                   /*!< Busy end flag */
#define ICACHE_SR_ERRF_Pos             (2U)
#define ICACHE_SR_ERRF_Msk             (0x1UL << ICACHE_SR_ERRF_Pos)           /*!< 0x00000004 */
#define ICACHE_SR_ERRF                 ICACHE_SR_ERRF_Msk                      /*!< Cache error flag */
#define ICACHE_IER_BSYENDIE_Pos        (1U)
#define ICACHE_IER_BSYENDIE_Msk        (0x1UL << ICACHE_IER_BSYENDIE_Pos)      /*!< 0x00000002 */
#define ICACHE_IER_BSYENDIE            ICACHE_IER_BSYENDIE_Msk                 /*!< Busy end interrupt enable */
#define ICACHE_IER_ERRIE_Pos           (2U)
#define ICACHE_IER_ERRIE_Msk           (0x1UL << ICACHE_IER_ERRIE_Pos)         /*!< 0x00000004 */
#define ICACHE_IER_ERRIE               ICACHE_IER_ERRIE_Msk                    /*!< Cache error interrupt enable */
#define ICACHE_FCR_CBSYENDF_Pos        (1U)
#define ICACHE_FCR_CBSYENDF_Msk        (0x1UL << ICACHE_FCR_CBSYENDF_Pos)      /*!< 0x00000002 */
#define ICACHE_FCR_CBSYENDF            ICACHE_FCR_CBSYENDF_Msk                 /*!< Busy end flag clear */
#define ICACHE_FCR_CERRF_Pos           (2U)
#define ICACHE_FCR_CERRF_Msk           (0x1UL << ICACHE_FCR_CERRF_Pos)         /*!< 0x00000004 */
#define ICACHE_FCR_CERRF               ICACHE_FCR_CERRF_Msk                    /*!< Cache error flag clear */
#define ICACHE_HMONR_HITMON_Pos         (0U)
#define ICACHE_HMONR_HITMON_Msk         (0xFFFFFFFFUL << ICACHE_HMONR_HITMON_Pos)/*!< 0xFFFFFFFF */
#define ICACHE_HMONR_HITMON             ICACHE_HMONR_HITMON_Msk                /*!< Cache hit monitor register */
#define ICACHE_MMONR_MISSMON_Pos        (0U)
#define ICACHE_MMONR_MISSMON_Msk        (0xFFFFUL << ICACHE_MMONR_MISSMON_Pos) /*!< 0x0000FFFF */
#define ICACHE_MMONR_MISSMON            ICACHE_MMONR_MISSMON_Msk               /*!< Cache miss monitor register */
