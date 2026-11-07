/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 * Exact CMSIS declarations at 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
 * See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt. */
#define DTS_BASE                        (APB4PERIPH_BASE + 0x6800UL)

#define DTS_CFGR1_TS1_EN_Pos               (0U)

#define DTS_CFGR1_TS1_EN_Msk               (0x1UL << DTS_CFGR1_TS1_EN_Pos) /*!< 0x00000001 */

#define DTS_CFGR1_TS1_EN                   DTS_CFGR1_TS1_EN_Msk        /*!< DTS Enable */

#define DTS_CFGR1_TS1_START_Pos            (4U)

#define DTS_CFGR1_TS1_START_Msk            (0x1UL << DTS_CFGR1_TS1_START_Pos) /*!< 0x00000010 */

#define DTS_CFGR1_TS1_START                DTS_CFGR1_TS1_START_Msk     /*!< Proceed to a frequency measurement on DTS */

#define DTS_CFGR1_TS1_INTRIG_SEL_Pos       (8U)

#define DTS_CFGR1_TS1_INTRIG_SEL_Msk       (0xFUL << DTS_CFGR1_TS1_INTRIG_SEL_Pos) /*!< 0x00000F00 */

#define DTS_CFGR1_TS1_INTRIG_SEL           DTS_CFGR1_TS1_INTRIG_SEL_Msk /*!< Input triggers selection bits [3:0] for DTS */

#define DTS_CFGR1_TS1_INTRIG_SEL_0         (0x1UL << DTS_CFGR1_TS1_INTRIG_SEL_Pos) /*!< 0x00000100 */

#define DTS_CFGR1_TS1_INTRIG_SEL_1         (0x2UL << DTS_CFGR1_TS1_INTRIG_SEL_Pos) /*!< 0x00000200 */

#define DTS_CFGR1_TS1_INTRIG_SEL_2         (0x4UL << DTS_CFGR1_TS1_INTRIG_SEL_Pos) /*!< 0x00000400 */

#define DTS_CFGR1_TS1_INTRIG_SEL_3         (0x8UL << DTS_CFGR1_TS1_INTRIG_SEL_Pos) /*!< 0x00000800 */

#define DTS_CFGR1_TS1_SMP_TIME_Pos         (16U)

#define DTS_CFGR1_TS1_SMP_TIME_Msk         (0xFUL << DTS_CFGR1_TS1_SMP_TIME_Pos) /*!< 0x000F0000 */

#define DTS_CFGR1_TS1_SMP_TIME             DTS_CFGR1_TS1_SMP_TIME_Msk  /*!< Sample time [3:0] for DTS */

#define DTS_CFGR1_TS1_SMP_TIME_0           (0x1UL << DTS_CFGR1_TS1_SMP_TIME_Pos) /*!< 0x00010000 */

#define DTS_CFGR1_TS1_SMP_TIME_1           (0x2UL << DTS_CFGR1_TS1_SMP_TIME_Pos) /*!< 0x00020000 */

#define DTS_CFGR1_TS1_SMP_TIME_2           (0x4UL << DTS_CFGR1_TS1_SMP_TIME_Pos) /*!< 0x00040000 */

#define DTS_CFGR1_TS1_SMP_TIME_3           (0x8UL << DTS_CFGR1_TS1_SMP_TIME_Pos) /*!< 0x00080000 */

#define DTS_CFGR1_REFCLK_SEL_Pos           (20U)

#define DTS_CFGR1_REFCLK_SEL_Msk           (0x1UL << DTS_CFGR1_REFCLK_SEL_Pos) /*!< 0x00100000 */

#define DTS_CFGR1_REFCLK_SEL               DTS_CFGR1_REFCLK_SEL_Msk    /*!< Reference Clock Selection */

#define DTS_CFGR1_Q_MEAS_OPT_Pos           (21U)

#define DTS_CFGR1_Q_MEAS_OPT_Msk           (0x1UL << DTS_CFGR1_Q_MEAS_OPT_Pos) /*!< 0x00200000 */

#define DTS_CFGR1_Q_MEAS_OPT               DTS_CFGR1_Q_MEAS_OPT_Msk    /*!< Quick measure option bit  */

#define DTS_CFGR1_HSREF_CLK_DIV_Pos        (24U)

#define DTS_CFGR1_HSREF_CLK_DIV_Msk        (0x7FUL << DTS_CFGR1_HSREF_CLK_DIV_Pos) /*!< 0x7F000000 */

#define DTS_CFGR1_HSREF_CLK_DIV            DTS_CFGR1_HSREF_CLK_DIV_Msk /*!< High Speed Clock Divider Ratio [6:0]*/

#define DTS_T0VALR1_TS1_FMT0_Pos           (0U)

#define DTS_T0VALR1_TS1_FMT0_Msk           (0xFFFFUL << DTS_T0VALR1_TS1_FMT0_Pos) /*!< 0x0000FFFF */

#define DTS_T0VALR1_TS1_FMT0               DTS_T0VALR1_TS1_FMT0_Msk    /*!< Engineering value of the measured frequency at T0 for DTS */

#define DTS_T0VALR1_TS1_T0_Pos             (16U)

#define DTS_T0VALR1_TS1_T0_Msk             (0x3UL << DTS_T0VALR1_TS1_T0_Pos) /*!< 0x00030000 */

#define DTS_T0VALR1_TS1_T0                 DTS_T0VALR1_TS1_T0_Msk      /*!< Engineering value of the DTSerature T0 for DTS */

#define DTS_RAMPVALR_TS1_RAMP_COEFF_Pos    (0U)

#define DTS_RAMPVALR_TS1_RAMP_COEFF_Msk    (0xFFFFUL << DTS_RAMPVALR_TS1_RAMP_COEFF_Pos) /*!< 0x0000FFFF */

#define DTS_RAMPVALR_TS1_RAMP_COEFF        DTS_RAMPVALR_TS1_RAMP_COEFF_Msk /*!< Engineering value of the ramp coefficient for DTS */

#define DTS_ITR1_TS1_LITTHD_Pos            (0U)

#define DTS_ITR1_TS1_LITTHD_Msk            (0xFFFFUL << DTS_ITR1_TS1_LITTHD_Pos) /*!< 0x0000FFFF */

#define DTS_ITR1_TS1_LITTHD                DTS_ITR1_TS1_LITTHD_Msk     /*!< Low interrupt threshold[15:0] for DTS */

#define DTS_ITR1_TS1_HITTHD_Pos            (16U)

#define DTS_ITR1_TS1_HITTHD_Msk            (0xFFFFUL << DTS_ITR1_TS1_HITTHD_Pos) /*!< 0xFFFF0000 */

#define DTS_ITR1_TS1_HITTHD                DTS_ITR1_TS1_HITTHD_Msk     /*!< High interrupt threshold[15:0] for DTS */

#define DTS_DR_TS1_MFREQ_Pos               (0U)

#define DTS_DR_TS1_MFREQ_Msk               (0xFFFFUL << DTS_DR_TS1_MFREQ_Pos) /*!< 0x0000FFFF */

#define DTS_DR_TS1_MFREQ                   DTS_DR_TS1_MFREQ_Msk        /*!< Measured Frequency[15:0] for DTS */

#define DTS_SR_TS1_ITEF_Pos                (0U)

#define DTS_SR_TS1_ITEF_Msk                (0x1UL << DTS_SR_TS1_ITEF_Pos) /*!< 0x00000001 */

#define DTS_SR_TS1_ITEF                    DTS_SR_TS1_ITEF_Msk         /*!< Interrupt flag for end of measure for DTS */

#define DTS_SR_TS1_ITLF_Pos                (1U)

#define DTS_SR_TS1_ITLF_Msk                (0x1UL << DTS_SR_TS1_ITLF_Pos) /*!< 0x00000002 */

#define DTS_SR_TS1_ITLF                    DTS_SR_TS1_ITLF_Msk         /*!< Interrupt flag for low threshold for DTS  */

#define DTS_SR_TS1_ITHF_Pos                (2U)

#define DTS_SR_TS1_ITHF_Msk                (0x1UL << DTS_SR_TS1_ITHF_Pos) /*!< 0x00000004 */

#define DTS_SR_TS1_ITHF                    DTS_SR_TS1_ITHF_Msk         /*!< Interrupt flag for high threshold for DTS */

#define DTS_SR_TS1_AITEF_Pos               (4U)

#define DTS_SR_TS1_AITEF_Msk               (0x1UL << DTS_SR_TS1_AITEF_Pos) /*!< 0x00000010 */

#define DTS_SR_TS1_AITEF                   DTS_SR_TS1_AITEF_Msk        /*!< Asynchronous interrupt flag for end of measure for DTS */

#define DTS_SR_TS1_AITLF_Pos               (5U)

#define DTS_SR_TS1_AITLF_Msk               (0x1UL << DTS_SR_TS1_AITLF_Pos) /*!< 0x00000020 */

#define DTS_SR_TS1_AITLF                   DTS_SR_TS1_AITLF_Msk        /*!< Asynchronous interrupt flag for low threshold for DTS  */

#define DTS_SR_TS1_AITHF_Pos               (6U)

#define DTS_SR_TS1_AITHF_Msk               (0x1UL << DTS_SR_TS1_AITHF_Pos) /*!< 0x00000040 */

#define DTS_SR_TS1_AITHF                   DTS_SR_TS1_AITHF_Msk        /*!< Asynchronous interrupt flag for high threshold for DTS */

#define DTS_SR_TS1_RDY_Pos                 (15U)

#define DTS_SR_TS1_RDY_Msk                 (0x1UL << DTS_SR_TS1_RDY_Pos) /*!< 0x00008000 */

#define DTS_SR_TS1_RDY                     DTS_SR_TS1_RDY_Msk          /*!< DTS ready flag */

#define DTS_ITENR_TS1_ITEEN_Pos            (0U)

#define DTS_ITENR_TS1_ITEEN_Msk            (0x1UL << DTS_ITENR_TS1_ITEEN_Pos) /*!< 0x00000001 */

#define DTS_ITENR_TS1_ITEEN                DTS_ITENR_TS1_ITEEN_Msk     /*!< Enable interrupt flag for end of measure for DTS */

#define DTS_ITENR_TS1_ITLEN_Pos            (1U)

#define DTS_ITENR_TS1_ITLEN_Msk            (0x1UL << DTS_ITENR_TS1_ITLEN_Pos) /*!< 0x00000002 */

#define DTS_ITENR_TS1_ITLEN                DTS_ITENR_TS1_ITLEN_Msk     /*!< Enable interrupt flag for low threshold for DTS  */

#define DTS_ITENR_TS1_ITHEN_Pos            (2U)

#define DTS_ITENR_TS1_ITHEN_Msk            (0x1UL << DTS_ITENR_TS1_ITHEN_Pos) /*!< 0x00000004 */

#define DTS_ITENR_TS1_ITHEN                DTS_ITENR_TS1_ITHEN_Msk     /*!< Enable interrupt flag for high threshold for DTS */

#define DTS_ITENR_TS1_AITEEN_Pos           (4U)

#define DTS_ITENR_TS1_AITEEN_Msk           (0x1UL << DTS_ITENR_TS1_AITEEN_Pos) /*!< 0x00000010 */

#define DTS_ITENR_TS1_AITEEN               DTS_ITENR_TS1_AITEEN_Msk    /*!< Enable asynchronous interrupt flag for end of measure for DTS */

#define DTS_ITENR_TS1_AITLEN_Pos           (5U)

#define DTS_ITENR_TS1_AITLEN_Msk           (0x1UL << DTS_ITENR_TS1_AITLEN_Pos) /*!< 0x00000020 */

#define DTS_ITENR_TS1_AITLEN               DTS_ITENR_TS1_AITLEN_Msk    /*!< Enable Asynchronous interrupt flag for low threshold for DTS  */

#define DTS_ITENR_TS1_AITHEN_Pos           (6U)

#define DTS_ITENR_TS1_AITHEN_Msk           (0x1UL << DTS_ITENR_TS1_AITHEN_Pos) /*!< 0x00000040 */

#define DTS_ITENR_TS1_AITHEN               DTS_ITENR_TS1_AITHEN_Msk    /*!< Enable asynchronous interrupt flag for high threshold for DTS */

#define DTS_ICIFR_TS1_CITEF_Pos            (0U)

#define DTS_ICIFR_TS1_CITEF_Msk            (0x1UL << DTS_ICIFR_TS1_CITEF_Pos) /*!< 0x00000001 */

#define DTS_ICIFR_TS1_CITEF                DTS_ICIFR_TS1_CITEF_Msk     /*!< Clear the IT flag for End Of Measure for DTS */

#define DTS_ICIFR_TS1_CITLF_Pos            (1U)

#define DTS_ICIFR_TS1_CITLF_Msk            (0x1UL << DTS_ICIFR_TS1_CITLF_Pos) /*!< 0x00000002 */

#define DTS_ICIFR_TS1_CITLF                DTS_ICIFR_TS1_CITLF_Msk     /*!< Clear the IT flag for low threshold for DTS  */

#define DTS_ICIFR_TS1_CITHF_Pos            (2U)

#define DTS_ICIFR_TS1_CITHF_Msk            (0x1UL << DTS_ICIFR_TS1_CITHF_Pos) /*!< 0x00000004 */

#define DTS_ICIFR_TS1_CITHF                DTS_ICIFR_TS1_CITHF_Msk     /*!< Clear the IT flag for high threshold on DTS  */

#define DTS_ICIFR_TS1_CAITEF_Pos           (4U)

#define DTS_ICIFR_TS1_CAITEF_Msk           (0x1UL << DTS_ICIFR_TS1_CAITEF_Pos) /*!< 0x00000010 */

#define DTS_ICIFR_TS1_CAITEF               DTS_ICIFR_TS1_CAITEF_Msk    /*!< Clear the asynchronous IT flag for End Of Measure for DTS */

#define DTS_ICIFR_TS1_CAITLF_Pos           (5U)

#define DTS_ICIFR_TS1_CAITLF_Msk           (0x1UL << DTS_ICIFR_TS1_CAITLF_Pos) /*!< 0x00000020 */

#define DTS_ICIFR_TS1_CAITLF               DTS_ICIFR_TS1_CAITLF_Msk    /*!< Clear the asynchronous IT flag for low threshold for DTS  */

#define DTS_ICIFR_TS1_CAITHF_Pos           (6U)

#define DTS_ICIFR_TS1_CAITHF_Msk           (0x1UL << DTS_ICIFR_TS1_CAITHF_Pos) /*!< 0x00000040 */

#define DTS_ICIFR_TS1_CAITHF               DTS_ICIFR_TS1_CAITHF_Msk    /*!< Clear the asynchronous IT flag for high threshold on DTS  */

#define EXTI_IMR3_IM77_Pos           (13U)

#define EXTI_IMR3_IM77_Msk           (0x1UL << EXTI_IMR3_IM77_Pos)             /*!< 0x00002000 */

#define EXTI_IMR3_IM77               EXTI_IMR3_IM77_Msk                        /*!< Interrupt Mask on line 77 */

#define IS_DTS_ALL_INSTANCE(INSTANCE) ((INSTANCE) == DTS)
