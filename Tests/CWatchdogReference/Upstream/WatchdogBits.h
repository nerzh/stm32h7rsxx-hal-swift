/* Register definitions unchanged from CMSIS device at
 * 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
 * Copyright (c) 2022 STMicroelectronics. SPDX-License-Identifier: Apache-2.0
 * See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt. */
#define WWDG_BASE                       (APB1PERIPH_BASE + 0x2C00UL)
#define IWDG_BASE                       (APB4PERIPH_BASE + 0x4800UL)
#define IWDG_KR_KEY_Pos                (0U)
#define IWDG_KR_KEY_Msk                (0xFFFFUL << IWDG_KR_KEY_Pos)           /*!< 0x0000FFFF */
#define IWDG_KR_KEY                    IWDG_KR_KEY_Msk                         /*!<Key value (write only, read 0000h)  */
#define IWDG_PR_PR_Pos                 (0U)
#define IWDG_PR_PR_Msk                 (0xFUL << IWDG_PR_PR_Pos)               /*!< 0x0000000F */
#define IWDG_PR_PR                     IWDG_PR_PR_Msk                          /*!<PR[3:0] (Prescaler divider)         */
#define IWDG_PR_PR_0                   (0x1UL << IWDG_PR_PR_Pos)               /*!< 0x00000001 */
#define IWDG_PR_PR_1                   (0x2UL << IWDG_PR_PR_Pos)               /*!< 0x00000002 */
#define IWDG_PR_PR_2                   (0x4UL << IWDG_PR_PR_Pos)               /*!< 0x00000004 */
#define IWDG_PR_PR_3                   (0x8UL << IWDG_PR_PR_Pos)               /*!< 0x00000008 */
#define IWDG_RLR_RL_Pos                (0U)
#define IWDG_RLR_RL_Msk                (0xFFFUL << IWDG_RLR_RL_Pos)            /*!< 0x00000FFF */
#define IWDG_RLR_RL                    IWDG_RLR_RL_Msk                         /*!<Watchdog counter reload value        */
#define IWDG_SR_PVU_Pos                (0U)
#define IWDG_SR_PVU_Msk                (0x1UL << IWDG_SR_PVU_Pos)              /*!< 0x00000001 */
#define IWDG_SR_PVU                    IWDG_SR_PVU_Msk                         /*!< Watchdog prescaler value update */
#define IWDG_SR_RVU_Pos                (1U)
#define IWDG_SR_RVU_Msk                (0x1UL << IWDG_SR_RVU_Pos)              /*!< 0x00000002 */
#define IWDG_SR_RVU                    IWDG_SR_RVU_Msk                         /*!< Watchdog counter reload value update */
#define IWDG_SR_WVU_Pos                (2U)
#define IWDG_SR_WVU_Msk                (0x1UL << IWDG_SR_WVU_Pos)              /*!< 0x00000004 */
#define IWDG_SR_WVU                    IWDG_SR_WVU_Msk                         /*!< Watchdog counter window value update */
#define IWDG_SR_EWU_Pos                (3U)
#define IWDG_SR_EWU_Msk                (0x1UL << IWDG_SR_EWU_Pos)              /*!< 0x00000008 */
#define IWDG_SR_EWU                    IWDG_SR_EWU_Msk                         /*!< Watchdog interrupt comparator value update */
#define IWDG_SR_ONF_Pos                (8U)
#define IWDG_SR_ONF_Msk                (0x1UL << IWDG_SR_ONF_Pos)              /*!< 0x00000100 */
#define IWDG_SR_ONF                    IWDG_SR_ONF_Msk                         /*!< Watchdog enable flag */
#define IWDG_SR_EWIF_Pos               (14U)
#define IWDG_SR_EWIF_Msk               (0x1UL << IWDG_SR_EWIF_Pos)             /*!< 0x00004000 */
#define IWDG_SR_EWIF                   IWDG_SR_EWIF_Msk                        /*!< Watchdog early interrupt flag */
#define IWDG_WINR_WIN_Pos              (0U)
#define IWDG_WINR_WIN_Msk              (0xFFFUL << IWDG_WINR_WIN_Pos)          /*!< 0x00000FFF */
#define IWDG_WINR_WIN                  IWDG_WINR_WIN_Msk                       /*!< Watchdog counter window value */
#define IWDG_EWCR_EWIT_Pos             (0U)
#define IWDG_EWCR_EWIT_Msk             (0xFFFUL << IWDG_EWCR_EWIT_Pos)         /*!< 0x00000FFF */
#define IWDG_EWCR_EWIT                 IWDG_EWCR_EWIT_Msk                      /*!< Watchdog early wakeup comparator value */
#define IWDG_EWCR_EWIC_Pos             (14U)
#define IWDG_EWCR_EWIC_Msk             (0x1UL << IWDG_EWCR_EWIC_Pos)           /*!< 0x00004000 */
#define IWDG_EWCR_EWIC                 IWDG_EWCR_EWIC_Msk                      /*!< Watchdog early interrupt acknowledge */
#define IWDG_EWCR_EWIE_Pos             (15U)
#define IWDG_EWCR_EWIE_Msk             (0x1UL << IWDG_EWCR_EWIE_Pos)           /*!< 0x00008000 */
#define IWDG_EWCR_EWIE                 IWDG_EWCR_EWIE_Msk                      /*!< Watchdog early interrupt enable */
#define WWDG_CR_T_Pos                  (0U)
#define WWDG_CR_T_Msk                  (0x7FUL << WWDG_CR_T_Pos)               /*!< 0x0000007F */
#define WWDG_CR_T                      WWDG_CR_T_Msk                           /*!<T[6:0] bits (7-Bit counter (MSB to LSB)) */
#define WWDG_CR_T_0                    (0x01UL << WWDG_CR_T_Pos)               /*!< 0x00000001 */
#define WWDG_CR_T_1                    (0x02UL << WWDG_CR_T_Pos)               /*!< 0x00000002 */
#define WWDG_CR_T_2                    (0x04UL << WWDG_CR_T_Pos)               /*!< 0x00000004 */
#define WWDG_CR_T_3                    (0x08UL << WWDG_CR_T_Pos)               /*!< 0x00000008 */
#define WWDG_CR_T_4                    (0x10UL << WWDG_CR_T_Pos)               /*!< 0x00000010 */
#define WWDG_CR_T_5                    (0x20UL << WWDG_CR_T_Pos)               /*!< 0x00000020 */
#define WWDG_CR_T_6                    (0x40UL << WWDG_CR_T_Pos)               /*!< 0x00000040 */
#define WWDG_CR_WDGA_Pos               (7U)
#define WWDG_CR_WDGA_Msk               (0x1UL << WWDG_CR_WDGA_Pos)             /*!< 0x00000080 */
#define WWDG_CR_WDGA                   WWDG_CR_WDGA_Msk                        /*!<Activation bit */
#define WWDG_CFR_W_Pos                 (0U)
#define WWDG_CFR_W_Msk                 (0x7FUL << WWDG_CFR_W_Pos)              /*!< 0x0000007F */
#define WWDG_CFR_W                     WWDG_CFR_W_Msk                          /*!<W[6:0] bits (7-bit window value) */
#define WWDG_CFR_W_0                   (0x01UL << WWDG_CFR_W_Pos)              /*!< 0x00000001 */
#define WWDG_CFR_W_1                   (0x02UL << WWDG_CFR_W_Pos)              /*!< 0x00000002 */
#define WWDG_CFR_W_2                   (0x04UL << WWDG_CFR_W_Pos)              /*!< 0x00000004 */
#define WWDG_CFR_W_3                   (0x08UL << WWDG_CFR_W_Pos)              /*!< 0x00000008 */
#define WWDG_CFR_W_4                   (0x10UL << WWDG_CFR_W_Pos)              /*!< 0x00000010 */
#define WWDG_CFR_W_5                   (0x20UL << WWDG_CFR_W_Pos)              /*!< 0x00000020 */
#define WWDG_CFR_W_6                   (0x40UL << WWDG_CFR_W_Pos)              /*!< 0x00000040 */
#define WWDG_CFR_WDGTB_Pos             (11U)
#define WWDG_CFR_WDGTB_Msk             (0x7UL << WWDG_CFR_WDGTB_Pos)           /*!< 0x00003800 */
#define WWDG_CFR_WDGTB                 WWDG_CFR_WDGTB_Msk                      /*!<WDGTB[2:0] bits (Timer Base) */
#define WWDG_CFR_WDGTB_0               (0x1UL << WWDG_CFR_WDGTB_Pos)           /*!< 0x00000800 */
#define WWDG_CFR_WDGTB_1               (0x2UL << WWDG_CFR_WDGTB_Pos)           /*!< 0x00001000 */
#define WWDG_CFR_WDGTB_2               (0x4UL << WWDG_CFR_WDGTB_Pos)           /*!< 0x00002000 */
#define WWDG_CFR_EWI_Pos               (9U)
#define WWDG_CFR_EWI_Msk               (0x1UL << WWDG_CFR_EWI_Pos)             /*!< 0x00000200 */
#define WWDG_CFR_EWI                   WWDG_CFR_EWI_Msk                        /*!<Early Wakeup Interrupt */
#define WWDG_SR_EWIF_Pos               (0U)
#define WWDG_SR_EWIF_Msk               (0x1UL << WWDG_SR_EWIF_Pos)             /*!< 0x00000001 */
#define WWDG_SR_EWIF                   WWDG_SR_EWIF_Msk                        /*!<Early Wakeup Interrupt Flag */
