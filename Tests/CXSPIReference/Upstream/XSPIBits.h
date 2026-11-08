// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// From stm32h7s3xx.h at 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

#define XSPIM_BASE                      (AHB5PERIPH_BASE + 0xB400UL)
#define XSPI_CR_EN_Pos                   (0U)
#define XSPI_CR_EN_Msk                   (0x1UL << XSPI_CR_EN_Pos)            /*!< 0x00000001 */
#define XSPI_CR_EN                       XSPI_CR_EN_Msk                       /*!< Enable */
#define XSPI_CR_ABORT_Pos                (1U)
#define XSPI_CR_ABORT_Msk                (0x1UL << XSPI_CR_ABORT_Pos)         /*!< 0x00000002 */
#define XSPI_CR_ABORT                    XSPI_CR_ABORT_Msk                    /*!< Abort request */
#define XSPI_CR_DMAEN_Pos                (2U)
#define XSPI_CR_DMAEN_Msk                (0x1UL << XSPI_CR_DMAEN_Pos)         /*!< 0x00000004 */
#define XSPI_CR_DMAEN                    XSPI_CR_DMAEN_Msk                    /*!< DMA Enable */
#define XSPI_CR_TCEN_Pos                 (3U)
#define XSPI_CR_TCEN_Msk                 (0x1UL << XSPI_CR_TCEN_Pos)          /*!< 0x00000008 */
#define XSPI_CR_TCEN                     XSPI_CR_TCEN_Msk                     /*!< Timeout Counter Enable */
#define XSPI_CR_DMM_Pos                  (6U)
#define XSPI_CR_DMM_Msk                  (0x1UL << XSPI_CR_DMM_Pos)           /*!< 0x00000040 */
#define XSPI_CR_DMM                      XSPI_CR_DMM_Msk                      /*!< Dual Memory Mode */
#define XSPI_CR_FTHRES_Pos               (8U)
#define XSPI_CR_FTHRES_Msk               (0x1FUL << XSPI_CR_FTHRES_Pos)       /*!< 0x00001F00 */
#define XSPI_CR_FTHRES                   XSPI_CR_FTHRES_Msk                   /*!< FIFO Threshold Level */
#define XSPI_CR_TEIE_Pos                 (16U)
#define XSPI_CR_TEIE_Msk                 (0x1UL << XSPI_CR_TEIE_Pos)          /*!< 0x00010000 */
#define XSPI_CR_TEIE                     XSPI_CR_TEIE_Msk                     /*!< Transfer Error Interrupt Enable */
#define XSPI_CR_TCIE_Pos                 (17U)
#define XSPI_CR_TCIE_Msk                 (0x1UL << XSPI_CR_TCIE_Pos)          /*!< 0x00020000 */
#define XSPI_CR_TCIE                     XSPI_CR_TCIE_Msk                     /*!< Transfer Complete Interrupt Enable */
#define XSPI_CR_FTIE_Pos                 (18U)
#define XSPI_CR_FTIE_Msk                 (0x1UL << XSPI_CR_FTIE_Pos)          /*!< 0x00040000 */
#define XSPI_CR_FTIE                     XSPI_CR_FTIE_Msk                     /*!< FIFO Threshold Interrupt Enable */
#define XSPI_CR_SMIE_Pos                 (19U)
#define XSPI_CR_SMIE_Msk                 (0x1UL << XSPI_CR_SMIE_Pos)          /*!< 0x00080000 */
#define XSPI_CR_SMIE                     XSPI_CR_SMIE_Msk                     /*!< Status Match Interrupt Enable */
#define XSPI_CR_TOIE_Pos                 (20U)
#define XSPI_CR_TOIE_Msk                 (0x1UL << XSPI_CR_TOIE_Pos)          /*!< 0x00100000 */
#define XSPI_CR_TOIE                     XSPI_CR_TOIE_Msk                     /*!< TimeOut Interrupt Enable */
#define XSPI_CR_APMS_Pos                 (22U)
#define XSPI_CR_APMS_Msk                 (0x1UL << XSPI_CR_APMS_Pos)          /*!< 0x00400000 */
#define XSPI_CR_APMS                     XSPI_CR_APMS_Msk                     /*!< Automatic Poll Mode Stop */
#define XSPI_CR_PMM_Pos                  (23U)
#define XSPI_CR_PMM_Msk                  (0x1UL << XSPI_CR_PMM_Pos)           /*!< 0x00800000 */
#define XSPI_CR_PMM                      XSPI_CR_PMM_Msk                      /*!< Polling Match Mode */
#define XSPI_CR_CSSEL_Pos                (24U)
#define XSPI_CR_CSSEL_Msk                (0x1UL << XSPI_CR_CSSEL_Pos)         /*!< 0x01000000 */
#define XSPI_CR_CSSEL                    XSPI_CR_CSSEL_Msk                    /*!< Chip Select Selection */
#define XSPI_CR_FMODE_Pos                (28U)
#define XSPI_CR_FMODE_Msk                (0x3UL << XSPI_CR_FMODE_Pos)         /*!< 0x30000000 */
#define XSPI_CR_FMODE                    XSPI_CR_FMODE_Msk                    /*!< Functional Mode */
#define XSPI_CR_FMODE_0                  (0x1UL << XSPI_CR_FMODE_Pos)         /*!< 0x10000000 */
#define XSPI_CR_FMODE_1                  (0x2UL << XSPI_CR_FMODE_Pos)         /*!< 0x20000000 */
#define XSPI_CR_MSEL_Pos                 (30U)
#define XSPI_CR_MSEL_Msk                 (0x3UL << XSPI_CR_MSEL_Pos)          /*!< 0xC0000000 */
#define XSPI_CR_MSEL                     XSPI_CR_MSEL_Msk                     /*!< Memory Select */
#define XSPI_CR_MSEL_0                   (0x1UL << XSPI_CR_MSEL_Pos)          /*!< 0x40000000 */
#define XSPI_CR_MSEL_1                   (0x2UL << XSPI_CR_MSEL_Pos)          /*!< 0x80000000 */
#define XSPI_DCR1_CKMODE_Pos             (0U)
#define XSPI_DCR1_CKMODE_Msk             (0x1UL << XSPI_DCR1_CKMODE_Pos)      /*!< 0x00000001 */
#define XSPI_DCR1_CKMODE                 XSPI_DCR1_CKMODE_Msk                 /*!< Mode 0 / Mode 3 */
#define XSPI_DCR1_FRCK_Pos               (1U)
#define XSPI_DCR1_FRCK_Msk               (0x1UL << XSPI_DCR1_FRCK_Pos)        /*!< 0x00000002 */
#define XSPI_DCR1_FRCK                   XSPI_DCR1_FRCK_Msk                   /*!< Free Running Clock */
#define XSPI_DCR1_CSHT_Pos               (8U)
#define XSPI_DCR1_CSHT_Msk               (0x3FUL << XSPI_DCR1_CSHT_Pos)       /*!< 0x00003F00 */
#define XSPI_DCR1_CSHT                   XSPI_DCR1_CSHT_Msk                   /*!< Chip Select High Time */
#define XSPI_DCR1_DEVSIZE_Pos            (16U)
#define XSPI_DCR1_DEVSIZE_Msk            (0x1FUL << XSPI_DCR1_DEVSIZE_Pos)    /*!< 0x001F0000 */
#define XSPI_DCR1_DEVSIZE                XSPI_DCR1_DEVSIZE_Msk                /*!< Device Size */
#define XSPI_DCR1_MTYP_Pos               (24U)
#define XSPI_DCR1_MTYP_Msk               (0x7UL << XSPI_DCR1_MTYP_Pos)        /*!< 0x07000000 */
#define XSPI_DCR1_MTYP                   XSPI_DCR1_MTYP_Msk                   /*!< Memory Type */
#define XSPI_DCR1_MTYP_0                 (0x1UL << XSPI_DCR1_MTYP_Pos)        /*!< 0x01000000 */
#define XSPI_DCR1_MTYP_1                 (0x2UL << XSPI_DCR1_MTYP_Pos)        /*!< 0x02000000 */
#define XSPI_DCR1_MTYP_2                 (0x4UL << XSPI_DCR1_MTYP_Pos)        /*!< 0x04000000 */
#define XSPI_DCR2_PRESCALER_Pos          (0U)
#define XSPI_DCR2_PRESCALER_Msk          (0xFFUL << XSPI_DCR2_PRESCALER_Pos)  /*!< 0x000000FF */
#define XSPI_DCR2_PRESCALER              XSPI_DCR2_PRESCALER_Msk              /*!< Clock prescaler */
#define XSPI_DCR2_WRAPSIZE_Pos           (16U)
#define XSPI_DCR2_WRAPSIZE_Msk           (0x7UL << XSPI_DCR2_WRAPSIZE_Pos)    /*!< 0x00070000 */
#define XSPI_DCR2_WRAPSIZE               XSPI_DCR2_WRAPSIZE_Msk               /*!< Wrap Size */
#define XSPI_DCR2_WRAPSIZE_0             (0x1UL << XSPI_DCR2_WRAPSIZE_Pos)    /*!< 0x00010000 */
#define XSPI_DCR2_WRAPSIZE_1             (0x2UL << XSPI_DCR2_WRAPSIZE_Pos)    /*!< 0x00020000 */
#define XSPI_DCR2_WRAPSIZE_2             (0x4UL << XSPI_DCR2_WRAPSIZE_Pos)    /*!< 0x00040000 */
#define XSPI_DCR3_CSBOUND_Pos            (16U)
#define XSPI_DCR3_CSBOUND_Msk            (0x1FUL << XSPI_DCR3_CSBOUND_Pos)    /*!< 0x001F0000 */
#define XSPI_DCR3_CSBOUND                XSPI_DCR3_CSBOUND_Msk                /*!< Maximum transfer */
#define XSPI_DCR3_MAXTRAN_Pos            (0U)
#define XSPI_DCR3_MAXTRAN_Msk            (0xFFUL << XSPI_DCR3_MAXTRAN_Pos)    /*!< 0x000000FF */
#define XSPI_DCR3_MAXTRAN                XSPI_DCR3_MAXTRAN_Msk                /*!< Maximum transfer */
#define XSPI_DCR4_REFRESH_Pos            (0U)
#define XSPI_DCR4_REFRESH_Msk            (0xFFFFFFFFUL << XSPI_DCR4_REFRESH_Pos) /*!< 0xFFFFFFFF */
#define XSPI_DCR4_REFRESH                XSPI_DCR4_REFRESH_Msk                /*!< Refresh rate */
#define XSPI_SR_TEF_Pos                  (0U)
#define XSPI_SR_TEF_Msk                  (0x1UL << XSPI_SR_TEF_Pos)           /*!< 0x00000001 */
#define XSPI_SR_TEF                      XSPI_SR_TEF_Msk                      /*!< Transfer Error Flag */
#define XSPI_SR_TCF_Pos                  (1U)
#define XSPI_SR_TCF_Msk                  (0x1UL << XSPI_SR_TCF_Pos)           /*!< 0x00000002 */
#define XSPI_SR_TCF                      XSPI_SR_TCF_Msk                      /*!< Transfer Complete Flag */
#define XSPI_SR_FTF_Pos                  (2U)
#define XSPI_SR_FTF_Msk                  (0x1UL << XSPI_SR_FTF_Pos)           /*!< 0x00000004 */
#define XSPI_SR_FTF                      XSPI_SR_FTF_Msk                      /*!< FIFO Threshold Flag */
#define XSPI_SR_SMF_Pos                  (3U)
#define XSPI_SR_SMF_Msk                  (0x1UL << XSPI_SR_SMF_Pos)           /*!< 0x00000008 */
#define XSPI_SR_SMF                      XSPI_SR_SMF_Msk                      /*!< Status Match Flag */
#define XSPI_SR_TOF_Pos                  (4U)
#define XSPI_SR_TOF_Msk                  (0x1UL << XSPI_SR_TOF_Pos)           /*!< 0x00000010 */
#define XSPI_SR_TOF                      XSPI_SR_TOF_Msk                      /*!< Timeout Flag */
#define XSPI_SR_BUSY_Pos                 (5U)
#define XSPI_SR_BUSY_Msk                 (0x1UL << XSPI_SR_BUSY_Pos)          /*!< 0x00000020 */
#define XSPI_SR_BUSY                     XSPI_SR_BUSY_Msk                     /*!< Busy */
#define XSPI_SR_FLEVEL_Pos               (8U)
#define XSPI_SR_FLEVEL_Msk               (0x7FUL << XSPI_SR_FLEVEL_Pos)       /*!< 0x00007F00 */
#define XSPI_SR_FLEVEL                   XSPI_SR_FLEVEL_Msk                   /*!< FIFO Level */
#define XSPI_FCR_CTEF_Pos                (0U)
#define XSPI_FCR_CTEF_Msk                (0x1UL << XSPI_FCR_CTEF_Pos)         /*!< 0x00000001 */
#define XSPI_FCR_CTEF                    XSPI_FCR_CTEF_Msk                    /*!< Clear Transfer Error Flag */
#define XSPI_FCR_CTCF_Pos                (1U)
#define XSPI_FCR_CTCF_Msk                (0x1UL << XSPI_FCR_CTCF_Pos)         /*!< 0x00000002 */
#define XSPI_FCR_CTCF                    XSPI_FCR_CTCF_Msk                    /*!< Clear Transfer Complete Flag */
#define XSPI_FCR_CSMF_Pos                (3U)
#define XSPI_FCR_CSMF_Msk                (0x1UL << XSPI_FCR_CSMF_Pos)         /*!< 0x00000008 */
#define XSPI_FCR_CSMF                    XSPI_FCR_CSMF_Msk                    /*!< Clear Status Match Flag */
#define XSPI_FCR_CTOF_Pos                (4U)
#define XSPI_FCR_CTOF_Msk                (0x1UL << XSPI_FCR_CTOF_Pos)         /*!< 0x00000010 */
#define XSPI_FCR_CTOF                    XSPI_FCR_CTOF_Msk                    /*!< Clear Timeout Flag */
#define XSPI_DLR_DL_Pos                  (0U)
#define XSPI_DLR_DL_Msk                  (0xFFFFFFFFUL << XSPI_DLR_DL_Pos)    /*!< 0xFFFFFFFF */
#define XSPI_DLR_DL                      XSPI_DLR_DL_Msk                      /*!< Data Length */
#define XSPI_AR_ADDRESS_Pos              (0U)
#define XSPI_AR_ADDRESS_Msk              (0xFFFFFFFFUL << XSPI_AR_ADDRESS_Pos) /*!< 0xFFFFFFFF */
#define XSPI_AR_ADDRESS                  XSPI_AR_ADDRESS_Msk                  /*!< Address */
#define XSPI_DR_DATA_Pos                 (0U)
#define XSPI_DR_DATA_Msk                 (0xFFFFFFFFUL << XSPI_DR_DATA_Pos)   /*!< 0xFFFFFFFF */
#define XSPI_DR_DATA                     XSPI_DR_DATA_Msk                     /*!< Data */
#define XSPI_PSMKR_MASK_Pos              (0U)
#define XSPI_PSMKR_MASK_Msk              (0xFFFFFFFFUL << XSPI_PSMKR_MASK_Pos) /*!< 0xFFFFFFFF */
#define XSPI_PSMKR_MASK                  XSPI_PSMKR_MASK_Msk                  /*!< Status mask */
#define XSPI_PSMAR_MATCH_Pos             (0U)
#define XSPI_PSMAR_MATCH_Msk             (0xFFFFFFFFUL << XSPI_PSMAR_MATCH_Pos) /*!< 0xFFFFFFFF */
#define XSPI_PSMAR_MATCH                 XSPI_PSMAR_MATCH_Msk                 /*!< Status match */
#define XSPI_PIR_INTERVAL_Pos            (0U)
#define XSPI_PIR_INTERVAL_Msk            (0xFFFFUL << XSPI_PIR_INTERVAL_Pos)  /*!< 0x0000FFFF */
#define XSPI_PIR_INTERVAL                XSPI_PIR_INTERVAL_Msk                /*!< Polling Interval */
#define XSPI_CCR_IMODE_Pos               (0U)
#define XSPI_CCR_IMODE_Msk               (0x7UL << XSPI_CCR_IMODE_Pos)        /*!< 0x00000007 */
#define XSPI_CCR_IMODE                   XSPI_CCR_IMODE_Msk                   /*!< Instruction Mode */
#define XSPI_CCR_IMODE_0                 (0x1UL << XSPI_CCR_IMODE_Pos)        /*!< 0x00000001 */
#define XSPI_CCR_IMODE_1                 (0x2UL << XSPI_CCR_IMODE_Pos)        /*!< 0x00000002 */
#define XSPI_CCR_IMODE_2                 (0x4UL << XSPI_CCR_IMODE_Pos)        /*!< 0x00000004 */
#define XSPI_CCR_IDTR_Pos                (3U)
#define XSPI_CCR_IDTR_Msk                (0x1UL << XSPI_CCR_IDTR_Pos)         /*!< 0x00000008 */
#define XSPI_CCR_IDTR                    XSPI_CCR_IDTR_Msk                    /*!< Instruction Double Transfer Rate */
#define XSPI_CCR_ISIZE_Pos               (4U)
#define XSPI_CCR_ISIZE_Msk               (0x3UL << XSPI_CCR_ISIZE_Pos)        /*!< 0x00000030 */
#define XSPI_CCR_ISIZE                   XSPI_CCR_ISIZE_Msk                   /*!< Instruction Size */
#define XSPI_CCR_ISIZE_0                 (0x1UL << XSPI_CCR_ISIZE_Pos)        /*!< 0x00000010 */
#define XSPI_CCR_ISIZE_1                 (0x2UL << XSPI_CCR_ISIZE_Pos)        /*!< 0x00000020 */
#define XSPI_CCR_ADMODE_Pos              (8U)
#define XSPI_CCR_ADMODE_Msk              (0x7UL << XSPI_CCR_ADMODE_Pos)       /*!< 0x00000700 */
#define XSPI_CCR_ADMODE                  XSPI_CCR_ADMODE_Msk                  /*!< Address Mode */
#define XSPI_CCR_ADMODE_0                (0x1UL << XSPI_CCR_ADMODE_Pos)       /*!< 0x00000100 */
#define XSPI_CCR_ADMODE_1                (0x2UL << XSPI_CCR_ADMODE_Pos)       /*!< 0x00000200 */
#define XSPI_CCR_ADMODE_2                (0x4UL << XSPI_CCR_ADMODE_Pos)       /*!< 0x00000400 */
#define XSPI_CCR_ADDTR_Pos               (11U)
#define XSPI_CCR_ADDTR_Msk               (0x1UL << XSPI_CCR_ADDTR_Pos)        /*!< 0x00000800 */
#define XSPI_CCR_ADDTR                   XSPI_CCR_ADDTR_Msk                   /*!< Address Double Transfer Rate */
#define XSPI_CCR_ADSIZE_Pos              (12U)
#define XSPI_CCR_ADSIZE_Msk              (0x3UL << XSPI_CCR_ADSIZE_Pos)       /*!< 0x00003000 */
#define XSPI_CCR_ADSIZE                  XSPI_CCR_ADSIZE_Msk                  /*!< Address Size */
#define XSPI_CCR_ADSIZE_0                (0x1UL << XSPI_CCR_ADSIZE_Pos)       /*!< 0x00001000 */
#define XSPI_CCR_ADSIZE_1                (0x2UL << XSPI_CCR_ADSIZE_Pos)       /*!< 0x00002000 */
#define XSPI_CCR_ABMODE_Pos              (16U)
#define XSPI_CCR_ABMODE_Msk              (0x7UL << XSPI_CCR_ABMODE_Pos)       /*!< 0x00070000 */
#define XSPI_CCR_ABMODE                  XSPI_CCR_ABMODE_Msk                  /*!< Alternate Bytes Mode */
#define XSPI_CCR_ABMODE_0                (0x1UL << XSPI_CCR_ABMODE_Pos)       /*!< 0x00010000 */
#define XSPI_CCR_ABMODE_1                (0x2UL << XSPI_CCR_ABMODE_Pos)       /*!< 0x00020000 */
#define XSPI_CCR_ABMODE_2                (0x4UL << XSPI_CCR_ABMODE_Pos)       /*!< 0x00040000 */
#define XSPI_CCR_ABDTR_Pos               (19U)
#define XSPI_CCR_ABDTR_Msk               (0x1UL << XSPI_CCR_ABDTR_Pos)        /*!< 0x00080000 */
#define XSPI_CCR_ABDTR                   XSPI_CCR_ABDTR_Msk                   /*!< Alternate Bytes Double Transfer Rate */
#define XSPI_CCR_ABSIZE_Pos              (20U)
#define XSPI_CCR_ABSIZE_Msk              (0x3UL << XSPI_CCR_ABSIZE_Pos)       /*!< 0x00300000 */
#define XSPI_CCR_ABSIZE                  XSPI_CCR_ABSIZE_Msk                  /*!< Alternate Bytes Size */
#define XSPI_CCR_ABSIZE_0                (0x1UL << XSPI_CCR_ABSIZE_Pos)       /*!< 0x00100000 */
#define XSPI_CCR_ABSIZE_1                (0x2UL << XSPI_CCR_ABSIZE_Pos)       /*!< 0x00200000 */
#define XSPI_CCR_DMODE_Pos               (24U)
#define XSPI_CCR_DMODE_Msk               (0x7UL << XSPI_CCR_DMODE_Pos)        /*!< 0x07000000 */
#define XSPI_CCR_DMODE                   XSPI_CCR_DMODE_Msk                   /*!< Data Mode */
#define XSPI_CCR_DMODE_0                 (0x1UL << XSPI_CCR_DMODE_Pos)        /*!< 0x01000000 */
#define XSPI_CCR_DMODE_1                 (0x2UL << XSPI_CCR_DMODE_Pos)        /*!< 0x02000000 */
#define XSPI_CCR_DMODE_2                 (0x4UL << XSPI_CCR_DMODE_Pos)        /*!< 0x04000000 */
#define XSPI_CCR_DDTR_Pos                (27U)
#define XSPI_CCR_DDTR_Msk                (0x1UL << XSPI_CCR_DDTR_Pos)         /*!< 0x08000000 */
#define XSPI_CCR_DDTR                    XSPI_CCR_DDTR_Msk                    /*!< Data Double Transfer Rate */
#define XSPI_CCR_DQSE_Pos                (29U)
#define XSPI_CCR_DQSE_Msk                (0x1UL << XSPI_CCR_DQSE_Pos)         /*!< 0x20000000 */
#define XSPI_CCR_DQSE                    XSPI_CCR_DQSE_Msk                    /*!< DQS Enable */
#define XSPI_TCR_DCYC_Pos                (0U)
#define XSPI_TCR_DCYC_Msk                (0x1FUL << XSPI_TCR_DCYC_Pos)        /*!< 0x0000001F */
#define XSPI_TCR_DCYC                    XSPI_TCR_DCYC_Msk                    /*!< Number of Dummy Cycles */
#define XSPI_TCR_DHQC_Pos                (28U)
#define XSPI_TCR_DHQC_Msk                (0x1UL << XSPI_TCR_DHQC_Pos)         /*!< 0x10000000 */
#define XSPI_TCR_DHQC                    XSPI_TCR_DHQC_Msk                    /*!< Delay Hold Quarter Cycle */
#define XSPI_TCR_SSHIFT_Pos              (30U)
#define XSPI_TCR_SSHIFT_Msk              (0x1UL << XSPI_TCR_SSHIFT_Pos)       /*!< 0x40000000 */
#define XSPI_TCR_SSHIFT                  XSPI_TCR_SSHIFT_Msk                  /*!< Sample Shift */
#define XSPI_IR_INSTRUCTION_Pos          (0U)
#define XSPI_IR_INSTRUCTION_Msk          (0xFFFFFFFFUL << XSPI_IR_INSTRUCTION_Pos) /*!< 0xFFFFFFFF */
#define XSPI_IR_INSTRUCTION              XSPI_IR_INSTRUCTION_Msk              /*!< Instruction */
#define XSPI_ABR_ALTERNATE_Pos           (0U)
#define XSPI_ABR_ALTERNATE_Msk           (0xFFFFFFFFUL << XSPI_ABR_ALTERNATE_Pos) /*!< 0xFFFFFFFF */
#define XSPI_ABR_ALTERNATE               XSPI_ABR_ALTERNATE_Msk               /*!< Alternate Bytes */
#define XSPI_LPTR_TIMEOUT_Pos            (0U)
#define XSPI_LPTR_TIMEOUT_Msk            (0xFFFFUL << XSPI_LPTR_TIMEOUT_Pos)  /*!< 0x0000FFFF */
#define XSPI_LPTR_TIMEOUT                XSPI_LPTR_TIMEOUT_Msk                /*!< Timeout period */
#define XSPI_WPCCR_IMODE_Pos             (0U)
#define XSPI_WPCCR_IMODE_Msk             (0x7UL << XSPI_WPCCR_IMODE_Pos)      /*!< 0x00000007 */
#define XSPI_WPCCR_IMODE                 XSPI_WPCCR_IMODE_Msk                 /*!< Instruction Mode */
#define XSPI_WPCCR_IMODE_0               (0x1UL << XSPI_WPCCR_IMODE_Pos)      /*!< 0x00000001 */
#define XSPI_WPCCR_IMODE_1               (0x2UL << XSPI_WPCCR_IMODE_Pos)      /*!< 0x00000002 */
#define XSPI_WPCCR_IMODE_2               (0x4UL << XSPI_WPCCR_IMODE_Pos)      /*!< 0x00000004 */
#define XSPI_WPCCR_IDTR_Pos              (3U)
#define XSPI_WPCCR_IDTR_Msk              (0x1UL << XSPI_WPCCR_IDTR_Pos)       /*!< 0x00000008 */
#define XSPI_WPCCR_IDTR                  XSPI_WPCCR_IDTR_Msk                  /*!< Instruction Double Transfer Rate */
#define XSPI_WPCCR_ISIZE_Pos             (4U)
#define XSPI_WPCCR_ISIZE_Msk             (0x3UL << XSPI_WPCCR_ISIZE_Pos)      /*!< 0x00000030 */
#define XSPI_WPCCR_ISIZE                 XSPI_WPCCR_ISIZE_Msk                 /*!< Instruction Size */
#define XSPI_WPCCR_ISIZE_0               (0x1UL << XSPI_WPCCR_ISIZE_Pos)      /*!< 0x00000010 */
#define XSPI_WPCCR_ISIZE_1               (0x2UL << XSPI_WPCCR_ISIZE_Pos)      /*!< 0x00000020 */
#define XSPI_WPCCR_ADMODE_Pos            (8U)
#define XSPI_WPCCR_ADMODE_Msk            (0x7UL << XSPI_WPCCR_ADMODE_Pos)     /*!< 0x00000700 */
#define XSPI_WPCCR_ADMODE                XSPI_WPCCR_ADMODE_Msk                /*!< Address Mode */
#define XSPI_WPCCR_ADMODE_0              (0x1UL << XSPI_WPCCR_ADMODE_Pos)     /*!< 0x00000100 */
#define XSPI_WPCCR_ADMODE_1              (0x2UL << XSPI_WPCCR_ADMODE_Pos)     /*!< 0x00000200 */
#define XSPI_WPCCR_ADMODE_2              (0x4UL << XSPI_WPCCR_ADMODE_Pos)     /*!< 0x00000400 */
#define XSPI_WPCCR_ADDTR_Pos             (11U)
#define XSPI_WPCCR_ADDTR_Msk             (0x1UL << XSPI_WPCCR_ADDTR_Pos)      /*!< 0x00000800 */
#define XSPI_WPCCR_ADDTR                 XSPI_WPCCR_ADDTR_Msk                 /*!< Address Double Transfer Rate */
#define XSPI_WPCCR_ADSIZE_Pos            (12U)
#define XSPI_WPCCR_ADSIZE_Msk            (0x3UL << XSPI_WPCCR_ADSIZE_Pos)     /*!< 0x00003000 */
#define XSPI_WPCCR_ADSIZE                XSPI_WPCCR_ADSIZE_Msk                /*!< Address Size */
#define XSPI_WPCCR_ADSIZE_0              (0x1UL << XSPI_WPCCR_ADSIZE_Pos)     /*!< 0x00001000 */
#define XSPI_WPCCR_ADSIZE_1              (0x2UL << XSPI_WPCCR_ADSIZE_Pos)     /*!< 0x00002000 */
#define XSPI_WPCCR_ABMODE_Pos            (16U)
#define XSPI_WPCCR_ABMODE_Msk            (0x7UL << XSPI_WPCCR_ABMODE_Pos)     /*!< 0x00070000 */
#define XSPI_WPCCR_ABMODE                XSPI_WPCCR_ABMODE_Msk                /*!< Alternate Bytes Mode */
#define XSPI_WPCCR_ABMODE_0              (0x1UL << XSPI_WPCCR_ABMODE_Pos)     /*!< 0x00010000 */
#define XSPI_WPCCR_ABMODE_1              (0x2UL << XSPI_WPCCR_ABMODE_Pos)     /*!< 0x00020000 */
#define XSPI_WPCCR_ABMODE_2              (0x4UL << XSPI_WPCCR_ABMODE_Pos)     /*!< 0x00040000 */
#define XSPI_WPCCR_ABDTR_Pos             (19U)
#define XSPI_WPCCR_ABDTR_Msk             (0x1UL << XSPI_WPCCR_ABDTR_Pos)      /*!< 0x00080000 */
#define XSPI_WPCCR_ABDTR                 XSPI_WPCCR_ABDTR_Msk                 /*!< Alternate Bytes Double Transfer Rate */
#define XSPI_WPCCR_ABSIZE_Pos            (20U)
#define XSPI_WPCCR_ABSIZE_Msk            (0x3UL << XSPI_WPCCR_ABSIZE_Pos)     /*!< 0x00300000 */
#define XSPI_WPCCR_ABSIZE                XSPI_WPCCR_ABSIZE_Msk                /*!< Alternate Bytes Size */
#define XSPI_WPCCR_ABSIZE_0              (0x1UL << XSPI_WPCCR_ABSIZE_Pos)     /*!< 0x00100000 */
#define XSPI_WPCCR_ABSIZE_1              (0x2UL << XSPI_WPCCR_ABSIZE_Pos)     /*!< 0x00200000 */
#define XSPI_WPCCR_DMODE_Pos             (24U)
#define XSPI_WPCCR_DMODE_Msk             (0x7UL << XSPI_WPCCR_DMODE_Pos)      /*!< 0x07000000 */
#define XSPI_WPCCR_DMODE                 XSPI_WPCCR_DMODE_Msk                 /*!< Data Mode */
#define XSPI_WPCCR_DMODE_0               (0x1UL << XSPI_WPCCR_DMODE_Pos)      /*!< 0x01000000 */
#define XSPI_WPCCR_DMODE_1               (0x2UL << XSPI_WPCCR_DMODE_Pos)      /*!< 0x02000000 */
#define XSPI_WPCCR_DMODE_2               (0x4UL << XSPI_WPCCR_DMODE_Pos)      /*!< 0x04000000 */
#define XSPI_WPCCR_DDTR_Pos              (27U)
#define XSPI_WPCCR_DDTR_Msk              (0x1UL << XSPI_WPCCR_DDTR_Pos)       /*!< 0x08000000 */
#define XSPI_WPCCR_DDTR                  XSPI_WPCCR_DDTR_Msk                  /*!< Data Double Transfer Rate */
#define XSPI_WPCCR_DQSE_Pos              (29U)
#define XSPI_WPCCR_DQSE_Msk              (0x1UL << XSPI_WPCCR_DQSE_Pos)       /*!< 0x20000000 */
#define XSPI_WPCCR_DQSE                  XSPI_WPCCR_DQSE_Msk                  /*!< DQS Enable */
#define XSPI_WPTCR_DCYC_Pos              (0U)
#define XSPI_WPTCR_DCYC_Msk              (0x1FUL << XSPI_WPTCR_DCYC_Pos)      /*!< 0x0000001F */
#define XSPI_WPTCR_DCYC                  XSPI_WPTCR_DCYC_Msk                  /*!< Number of Dummy Cycles */
#define XSPI_WPTCR_DHQC_Pos              (28U)
#define XSPI_WPTCR_DHQC_Msk              (0x1UL << XSPI_WPTCR_DHQC_Pos)       /*!< 0x10000000 */
#define XSPI_WPTCR_DHQC                  XSPI_WPTCR_DHQC_Msk                  /*!< Delay Hold Quarter Cycle */
#define XSPI_WPTCR_SSHIFT_Pos            (30U)
#define XSPI_WPTCR_SSHIFT_Msk            (0x1UL << XSPI_WPTCR_SSHIFT_Pos)     /*!< 0x40000000 */
#define XSPI_WPTCR_SSHIFT                XSPI_WPTCR_SSHIFT_Msk                /*!< Sample Shift */
#define XSPI_WPIR_INSTRUCTION_Pos        (0U)
#define XSPI_WPIR_INSTRUCTION_Msk        (0xFFFFFFFFUL << XSPI_WPIR_INSTRUCTION_Pos) /*!< 0xFFFFFFFF */
#define XSPI_WPIR_INSTRUCTION            XSPI_WPIR_INSTRUCTION_Msk            /*!< Instruction */
#define XSPI_WPABR_ALTERNATE_Pos         (0U)
#define XSPI_WPABR_ALTERNATE_Msk         (0xFFFFFFFFUL << XSPI_WPABR_ALTERNATE_Pos) /*!< 0xFFFFFFFF */
#define XSPI_WPABR_ALTERNATE             XSPI_WPABR_ALTERNATE_Msk             /*!< Alternate Bytes */
#define XSPI_WCCR_IMODE_Pos              (0U)
#define XSPI_WCCR_IMODE_Msk              (0x7UL << XSPI_WCCR_IMODE_Pos)       /*!< 0x00000007 */
#define XSPI_WCCR_IMODE                  XSPI_WCCR_IMODE_Msk                  /*!< Instruction Mode */
#define XSPI_WCCR_IMODE_0                (0x1UL << XSPI_WCCR_IMODE_Pos)       /*!< 0x00000001 */
#define XSPI_WCCR_IMODE_1                (0x2UL << XSPI_WCCR_IMODE_Pos)       /*!< 0x00000002 */
#define XSPI_WCCR_IMODE_2                (0x4UL << XSPI_WCCR_IMODE_Pos)       /*!< 0x00000004 */
#define XSPI_WCCR_IDTR_Pos               (3U)
#define XSPI_WCCR_IDTR_Msk               (0x1UL << XSPI_WCCR_IDTR_Pos)        /*!< 0x00000008 */
#define XSPI_WCCR_IDTR                   XSPI_WCCR_IDTR_Msk                   /*!< Instruction Double Transfer Rate */
#define XSPI_WCCR_ISIZE_Pos              (4U)
#define XSPI_WCCR_ISIZE_Msk              (0x3UL << XSPI_WCCR_ISIZE_Pos)       /*!< 0x00000030 */
#define XSPI_WCCR_ISIZE                  XSPI_WCCR_ISIZE_Msk                  /*!< Instruction Size */
#define XSPI_WCCR_ISIZE_0                (0x1UL << XSPI_WCCR_ISIZE_Pos)       /*!< 0x00000010 */
#define XSPI_WCCR_ISIZE_1                (0x2UL << XSPI_WCCR_ISIZE_Pos)       /*!< 0x00000020 */
#define XSPI_WCCR_ADMODE_Pos             (8U)
#define XSPI_WCCR_ADMODE_Msk             (0x7UL << XSPI_WCCR_ADMODE_Pos)      /*!< 0x00000700 */
#define XSPI_WCCR_ADMODE                 XSPI_WCCR_ADMODE_Msk                 /*!< Address Mode */
#define XSPI_WCCR_ADMODE_0               (0x1UL << XSPI_WCCR_ADMODE_Pos)      /*!< 0x00000100 */
#define XSPI_WCCR_ADMODE_1               (0x2UL << XSPI_WCCR_ADMODE_Pos)      /*!< 0x00000200 */
#define XSPI_WCCR_ADMODE_2               (0x4UL << XSPI_WCCR_ADMODE_Pos)      /*!< 0x00000400 */
#define XSPI_WCCR_ADDTR_Pos              (11U)
#define XSPI_WCCR_ADDTR_Msk              (0x1UL << XSPI_WCCR_ADDTR_Pos)       /*!< 0x00000800 */
#define XSPI_WCCR_ADDTR                  XSPI_WCCR_ADDTR_Msk                  /*!< Address Double Transfer Rate */
#define XSPI_WCCR_ADSIZE_Pos             (12U)
#define XSPI_WCCR_ADSIZE_Msk             (0x3UL << XSPI_WCCR_ADSIZE_Pos)      /*!< 0x00003000 */
#define XSPI_WCCR_ADSIZE                 XSPI_WCCR_ADSIZE_Msk                 /*!< Address Size */
#define XSPI_WCCR_ADSIZE_0               (0x1UL << XSPI_WCCR_ADSIZE_Pos)      /*!< 0x00001000 */
#define XSPI_WCCR_ADSIZE_1               (0x2UL << XSPI_WCCR_ADSIZE_Pos)      /*!< 0x00002000 */
#define XSPI_WCCR_ABMODE_Pos             (16U)
#define XSPI_WCCR_ABMODE_Msk             (0x7UL << XSPI_WCCR_ABMODE_Pos)      /*!< 0x00070000 */
#define XSPI_WCCR_ABMODE                 XSPI_WCCR_ABMODE_Msk                 /*!< Alternate Bytes Mode */
#define XSPI_WCCR_ABMODE_0               (0x1UL << XSPI_WCCR_ABMODE_Pos)      /*!< 0x00010000 */
#define XSPI_WCCR_ABMODE_1               (0x2UL << XSPI_WCCR_ABMODE_Pos)      /*!< 0x00020000 */
#define XSPI_WCCR_ABMODE_2               (0x4UL << XSPI_WCCR_ABMODE_Pos)      /*!< 0x00040000 */
#define XSPI_WCCR_ABDTR_Pos              (19U)
#define XSPI_WCCR_ABDTR_Msk              (0x1UL << XSPI_WCCR_ABDTR_Pos)       /*!< 0x00080000 */
#define XSPI_WCCR_ABDTR                  XSPI_WCCR_ABDTR_Msk                  /*!< Alternate Bytes Double Transfer Rate */
#define XSPI_WCCR_ABSIZE_Pos             (20U)
#define XSPI_WCCR_ABSIZE_Msk             (0x3UL << XSPI_WCCR_ABSIZE_Pos)      /*!< 0x00300000 */
#define XSPI_WCCR_ABSIZE                 XSPI_WCCR_ABSIZE_Msk                 /*!< Alternate Bytes Size */
#define XSPI_WCCR_ABSIZE_0               (0x1UL << XSPI_WCCR_ABSIZE_Pos)      /*!< 0x00100000 */
#define XSPI_WCCR_ABSIZE_1               (0x2UL << XSPI_WCCR_ABSIZE_Pos)      /*!< 0x00200000 */
#define XSPI_WCCR_DMODE_Pos              (24U)
#define XSPI_WCCR_DMODE_Msk              (0x7UL << XSPI_WCCR_DMODE_Pos)       /*!< 0x07000000 */
#define XSPI_WCCR_DMODE                  XSPI_WCCR_DMODE_Msk                  /*!< Data Mode */
#define XSPI_WCCR_DMODE_0                (0x1UL << XSPI_WCCR_DMODE_Pos)       /*!< 0x01000000 */
#define XSPI_WCCR_DMODE_1                (0x2UL << XSPI_WCCR_DMODE_Pos)       /*!< 0x02000000 */
#define XSPI_WCCR_DMODE_2                (0x4UL << XSPI_WCCR_DMODE_Pos)       /*!< 0x04000000 */
#define XSPI_WCCR_DDTR_Pos               (27U)
#define XSPI_WCCR_DDTR_Msk               (0x1UL << XSPI_WCCR_DDTR_Pos)        /*!< 0x08000000 */
#define XSPI_WCCR_DDTR                   XSPI_WCCR_DDTR_Msk                   /*!< Data Double Transfer Rate */
#define XSPI_WCCR_DQSE_Pos               (29U)
#define XSPI_WCCR_DQSE_Msk               (0x1UL << XSPI_WCCR_DQSE_Pos)        /*!< 0x20000000 */
#define XSPI_WCCR_DQSE                   XSPI_WCCR_DQSE_Msk                   /*!< DQS Enable */
#define XSPI_WTCR_DCYC_Pos               (0U)
#define XSPI_WTCR_DCYC_Msk               (0x1FUL << XSPI_WTCR_DCYC_Pos)       /*!< 0x0000001F */
#define XSPI_WTCR_DCYC                   XSPI_WTCR_DCYC_Msk                   /*!< Number of Dummy Cycles */
#define XSPI_WIR_INSTRUCTION_Pos         (0U)
#define XSPI_WIR_INSTRUCTION_Msk         (0xFFFFFFFFUL << XSPI_WIR_INSTRUCTION_Pos) /*!< 0xFFFFFFFF */
#define XSPI_WIR_INSTRUCTION             XSPI_WIR_INSTRUCTION_Msk             /*!< Instruction */
#define XSPI_WABR_ALTERNATE_Pos          (0U)
#define XSPI_WABR_ALTERNATE_Msk          (0xFFFFFFFFUL << XSPI_WABR_ALTERNATE_Pos) /*!< 0xFFFFFFFF */
#define XSPI_WABR_ALTERNATE              XSPI_WABR_ALTERNATE_Msk              /*!< Alternate Bytes */
#define XSPI_HLCR_LM_Pos                 (0U)
#define XSPI_HLCR_LM_Msk                 (0x1UL << XSPI_HLCR_LM_Pos)          /*!< 0x00000001 */
#define XSPI_HLCR_LM                     XSPI_HLCR_LM_Msk                     /*!< Latency Mode */
#define XSPI_HLCR_WZL_Pos                (1U)
#define XSPI_HLCR_WZL_Msk                (0x1UL << XSPI_HLCR_WZL_Pos)         /*!< 0x00000002 */
#define XSPI_HLCR_WZL                    XSPI_HLCR_WZL_Msk                    /*!< Write Zero Latency */
#define XSPI_HLCR_TACC_Pos               (8U)
#define XSPI_HLCR_TACC_Msk               (0xFFUL << XSPI_HLCR_TACC_Pos)       /*!< 0x0000FF00 */
#define XSPI_HLCR_TACC                   XSPI_HLCR_TACC_Msk                   /*!< Access Time */
#define XSPI_HLCR_TRWR_Pos               (16U)
#define XSPI_HLCR_TRWR_Msk               (0xFFUL << XSPI_HLCR_TRWR_Pos)       /*!< 0x00FF0000 */
#define XSPI_HLCR_TRWR                   XSPI_HLCR_TRWR_Msk                   /*!< Read Write Recovery Time */
#define XSPI_CALFCR_FINE_Pos             (0U)
#define XSPI_CALFCR_FINE_Msk             (0x7FUL << XSPI_CALFCR_FINE_Pos)     /*!< 0x0000007F */
#define XSPI_CALFCR_FINE                 XSPI_CALFCR_FINE_Msk                 /*!< Fine Calibration */
#define XSPI_CALFCR_COARSE_Pos           (16U)
#define XSPI_CALFCR_COARSE_Msk           (0x1FUL << XSPI_CALFCR_COARSE_Pos)   /*!< 0x001F0000 */
#define XSPI_CALFCR_COARSE               XSPI_CALFCR_COARSE_Msk               /*!< Coarse Calibration */
#define XSPI_CALFCR_CALMAX_Pos           (31U)
#define XSPI_CALFCR_CALMAX_Msk           (0x1UL << XSPI_CALFCR_CALMAX_Pos)    /*!< 0x80000000 */
#define XSPI_CALFCR_CALMAX               XSPI_CALFCR_CALMAX_Msk               /*!< Max Value */
#define XSPI_CALMR_FINE_Pos              (0U)
#define XSPI_CALMR_FINE_Msk              (0x7FUL << XSPI_CALMR_FINE_Pos)      /*!< 0x0000007F */
#define XSPI_CALMR_FINE                  XSPI_CALMR_FINE_Msk                  /*!< Fine Calibration */
#define XSPI_CALMR_COARSE_Pos            (16U)
#define XSPI_CALMR_COARSE_Msk            (0x1FUL << XSPI_CALMR_COARSE_Pos)    /*!< 0x001F0000 */
#define XSPI_CALMR_COARSE                XSPI_CALMR_COARSE_Msk                /*!< Coarse Calibration */
#define XSPI_CALSOR_FINE_Pos             (0U)
#define XSPI_CALSOR_FINE_Msk             (0x7FUL << XSPI_CALSOR_FINE_Pos)     /*!< 0x0000007F */
#define XSPI_CALSOR_FINE                 XSPI_CALSOR_FINE_Msk                 /*!< Fine Calibration */
#define XSPI_CALSOR_COARSE_Pos           (16U)
#define XSPI_CALSOR_COARSE_Msk           (0x1FUL << XSPI_CALSOR_COARSE_Pos)   /*!< 0x001F0000 */
#define XSPI_CALSOR_COARSE               XSPI_CALSOR_COARSE_Msk               /*!< Coarse Calibration */
#define XSPI_CALSIR_FINE_Pos             (0U)
#define XSPI_CALSIR_FINE_Msk             (0x7FUL << XSPI_CALSIR_FINE_Pos)     /*!< 0x0000007F */
#define XSPI_CALSIR_FINE                 XSPI_CALSIR_FINE_Msk                 /*!< Fine Calibration */
#define XSPI_CALSIR_COARSE_Pos           (16U)
#define XSPI_CALSIR_COARSE_Msk           (0x1FUL << XSPI_CALSIR_COARSE_Pos)   /*!< 0x001F0000 */
#define XSPI_CALSIR_COARSE               XSPI_CALSIR_COARSE_Msk               /*!< Coarse Calibration */
#define XSPIM_CR_MUXEN_Pos               (0U)
#define XSPIM_CR_MUXEN_Msk               (0x1UL << XSPIM_CR_MUXEN_Pos)        /*!< 0x00000001 */
#define XSPIM_CR_MUXEN                   XSPIM_CR_MUXEN_Msk                   /*!< Multiplexed Mode Enable */
#define XSPIM_CR_MODE_Pos                (1U)
#define XSPIM_CR_MODE_Msk                (0x1UL << XSPIM_CR_MODE_Pos)         /*!< 0x00000002 */
#define XSPIM_CR_MODE                    XSPIM_CR_MODE_Msk                    /*!< Multiplexing Mode */
#define XSPIM_CR_CSSEL_OVR_EN_Pos        (4U)
#define XSPIM_CR_CSSEL_OVR_EN_Msk        (0x1UL << XSPIM_CR_CSSEL_OVR_EN_Pos) /*!< 0x00000010 */
#define XSPIM_CR_CSSEL_OVR_EN            XSPIM_CR_CSSEL_OVR_EN_Msk            /*!< Chip select selector override enable */
#define XSPIM_CR_CSSEL_OVR_O1_Pos        (5U)
#define XSPIM_CR_CSSEL_OVR_O1_Msk        (0x1UL << XSPIM_CR_CSSEL_OVR_O1_Pos) /*!< 0x00000020 */
#define XSPIM_CR_CSSEL_OVR_O1            XSPIM_CR_CSSEL_OVR_O1_Msk            /*!< Chip select selector override setting for XSPI1 */
#define XSPIM_CR_CSSEL_OVR_O2_Pos        (6U)
#define XSPIM_CR_CSSEL_OVR_O2_Msk        (0x1UL << XSPIM_CR_CSSEL_OVR_O2_Pos) /*!< 0x00000040 */
#define XSPIM_CR_CSSEL_OVR_O2            XSPIM_CR_CSSEL_OVR_O2_Msk            /*!< Chip select selector override setting for XSPI2 */
#define XSPIM_CR_REQ2ACK_TIME_Pos        (16U)
#define XSPIM_CR_REQ2ACK_TIME_Msk        (0xFFUL << XSPIM_CR_REQ2ACK_TIME_Pos)/*!< 0x00FF0000 */
#define XSPIM_CR_REQ2ACK_TIME            XSPIM_CR_REQ2ACK_TIME_Msk            /*!< REQ to ACK Time */
