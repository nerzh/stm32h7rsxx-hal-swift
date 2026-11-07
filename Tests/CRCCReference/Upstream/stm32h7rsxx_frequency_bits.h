/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 * Unmodified selected definitions from stm32h7s3xx.h at
 * 7e6e213ddc397c76622a0aca2f623ccc3b34c010, identical for H7R3/H7R7/H7S7.
 * See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt. */
#ifndef C_RCC_REFERENCE_CMSIS_BITS_H
#define C_RCC_REFERENCE_CMSIS_BITS_H

#define RCC_APBCFGR_PPRE1              RCC_APBCFGR_PPRE1_Msk                   /*!< PPRE1[2:0] bits */
#define RCC_APBCFGR_PPRE1_Msk          (0x7UL << RCC_APBCFGR_PPRE1_Pos)        /*!< 0x00000007 */
#define RCC_APBCFGR_PPRE1_Pos          (0U)
#define RCC_APBCFGR_PPRE2              RCC_APBCFGR_PPRE2_Msk                   /*!< PPRE2[2:0] bits */
#define RCC_APBCFGR_PPRE2_Msk          (0x7UL << RCC_APBCFGR_PPRE2_Pos)        /*!< 0x00000070 */
#define RCC_APBCFGR_PPRE2_Pos          (4U)
#define RCC_APBCFGR_PPRE4              RCC_APBCFGR_PPRE4_Msk                   /*!< PPRE4[2:0] bits */
#define RCC_APBCFGR_PPRE4_Msk          (0x7UL << RCC_APBCFGR_PPRE4_Pos)        /*!< 0x00000700 */
#define RCC_APBCFGR_PPRE4_Pos          (8U)
#define RCC_APBCFGR_PPRE5              RCC_APBCFGR_PPRE5_Msk                   /*!< PPRE5[2:0] bits */
#define RCC_APBCFGR_PPRE5_Msk          (0x7UL << RCC_APBCFGR_PPRE5_Pos)        /*!< 0x00007000 */
#define RCC_APBCFGR_PPRE5_Pos          (12U)
#define RCC_BMCFGR_BMPRE               RCC_BMCFGR_BMPRE_Msk                    /*!< BMPRE[3:0] bits */
#define RCC_BMCFGR_BMPRE_Msk           (0xFUL << RCC_BMCFGR_BMPRE_Pos)         /*!< 0x0000000F */
#define RCC_BMCFGR_BMPRE_Pos           (0U)
#define RCC_CDCFGR_CPRE                RCC_CDCFGR_CPRE_Msk                     /*!< CPRE[3:0] bits */
#define RCC_CDCFGR_CPRE_3              (0x8UL << RCC_CDCFGR_CPRE_Pos)          /*!< 0x00000008 */
#define RCC_CDCFGR_CPRE_Msk            (0xFUL << RCC_CDCFGR_CPRE_Pos)          /*!< 0x0000000F */
#define RCC_CDCFGR_CPRE_Pos            (0U)
#define RCC_CFGR_SWS                   RCC_CFGR_SWS_Msk                        /*!< SWS[2:0] bits (System clock switch status) */
#define RCC_CFGR_SWS_0                 (0x1UL << RCC_CFGR_SWS_Pos)             /*!< 0x00000008 */
#define RCC_CFGR_SWS_1                 (0x2UL << RCC_CFGR_SWS_Pos)             /*!< 0x00000010 */
#define RCC_CFGR_SWS_Msk               (0x7UL << RCC_CFGR_SWS_Pos)             /*!< 0x00000038 */
#define RCC_CFGR_SWS_Pos               (3U)
#define RCC_CR_HSIDIV                  RCC_CR_HSIDIV_Msk                       /*!< Internal High Speed clock divider selection */
#define RCC_CR_HSIDIVF                 RCC_CR_HSIDIVF_Msk                      /*!< HSI Divider flag */
#define RCC_CR_HSIDIVF_Msk             (0x1UL << RCC_CR_HSIDIVF_Pos)           /*!< 0x00000020 */
#define RCC_CR_HSIDIVF_Pos             (5U)
#define RCC_CR_HSIDIV_Msk              (0x3UL << RCC_CR_HSIDIV_Pos)            /*!< 0x00000018 */
#define RCC_CR_HSIDIV_Pos              (3U)
#define RCC_PLL1DIVR1_DIVN            RCC_PLL1DIVR1_DIVN_Msk                 /*!< DIVN1[8:0] bits: PLL1 DIVN division factor */
#define RCC_PLL1DIVR1_DIVN_Msk        (0x1FFUL << RCC_PLL1DIVR1_DIVN_Pos)    /*!< 0x000001FF */
#define RCC_PLL1DIVR1_DIVN_Pos        (0U)
#define RCC_PLL1DIVR1_DIVP            RCC_PLL1DIVR1_DIVP_Msk                 /*!< DIVP1[6:0] bits: PLL1 DIVP division factor */
#define RCC_PLL1DIVR1_DIVP_Msk        (0x7FUL << RCC_PLL1DIVR1_DIVP_Pos)     /*!< 0x0000FE00 */
#define RCC_PLL1DIVR1_DIVP_Pos        (9U)
#define RCC_PLL1DIVR1_DIVQ            RCC_PLL1DIVR1_DIVQ_Msk                 /*!< DIVQ1[6:0] bits: PLL1 DIVQ division factor */
#define RCC_PLL1DIVR1_DIVQ_Msk        (0x7FUL << RCC_PLL1DIVR1_DIVQ_Pos)     /*!< 0x007F0000 */
#define RCC_PLL1DIVR1_DIVQ_Pos        (16U)
#define RCC_PLL1DIVR1_DIVR            RCC_PLL1DIVR1_DIVR_Msk                 /*!< DIVR1[6:0] bits: PLL1 DIVR division factor */
#define RCC_PLL1DIVR1_DIVR_Msk        (0x7FUL << RCC_PLL1DIVR1_DIVR_Pos)     /*!< 0x7F000000 */
#define RCC_PLL1DIVR1_DIVR_Pos        (24U)
#define RCC_PLL1DIVR2_DIVS            RCC_PLL1DIVR2_DIVS_Msk                 /*!< DIVS1[2:0] bits: PLL1 DIVS division factor */
#define RCC_PLL1DIVR2_DIVS_Msk        (0x7UL << RCC_PLL1DIVR2_DIVS_Pos)      /*!< 0x00000007 */
#define RCC_PLL1DIVR2_DIVS_Pos        (0U)
#define RCC_PLL1FRACR_FRACN            RCC_PLL1FRACR_FRACN_Msk               /*!< FRACN[12:0] bits */
#define RCC_PLL1FRACR_FRACN_Msk        (0x1FFFUL << RCC_PLL1FRACR_FRACN_Pos) /*!< 0x0000FFF8 */
#define RCC_PLL1FRACR_FRACN_Pos        (3U)
#define RCC_PLL2DIVR1_DIVN            RCC_PLL2DIVR1_DIVN_Msk                 /*!< DIVN2[8:0] bits: PLL2 DIVN division factor */
#define RCC_PLL2DIVR1_DIVN_Msk        (0x1FFUL << RCC_PLL2DIVR1_DIVN_Pos)    /*!< 0x000001FF */
#define RCC_PLL2DIVR1_DIVN_Pos        (0U)
#define RCC_PLL2DIVR1_DIVP            RCC_PLL2DIVR1_DIVP_Msk                 /*!< DIVP2[6:0] bits: PLL2 DIVP division factor */
#define RCC_PLL2DIVR1_DIVP_Msk        (0x7FUL << RCC_PLL2DIVR1_DIVP_Pos)     /*!< 0x0000FE00 */
#define RCC_PLL2DIVR1_DIVP_Pos        (9U)
#define RCC_PLL2DIVR1_DIVQ            RCC_PLL2DIVR1_DIVQ_Msk                 /*!< DIVQ2[6:0] bits: PLL2 DIVQ division factor */
#define RCC_PLL2DIVR1_DIVQ_Msk        (0x7FUL << RCC_PLL2DIVR1_DIVQ_Pos)     /*!< 0x007F0000 */
#define RCC_PLL2DIVR1_DIVQ_Pos        (16U)
#define RCC_PLL2DIVR1_DIVR            RCC_PLL2DIVR1_DIVR_Msk                 /*!< DIVR2[6:0] bits: PLL2 DIVR division factor */
#define RCC_PLL2DIVR1_DIVR_Msk        (0x7FUL << RCC_PLL2DIVR1_DIVR_Pos)     /*!< 0x7F000000 */
#define RCC_PLL2DIVR1_DIVR_Pos        (24U)
#define RCC_PLL2DIVR2_DIVS            RCC_PLL2DIVR2_DIVS_Msk                 /*!< DIVS2[2:0] bits: PLL2 DIVS division factor */
#define RCC_PLL2DIVR2_DIVS_Msk        (0x7UL << RCC_PLL2DIVR2_DIVS_Pos)      /*!< 0x00000007 */
#define RCC_PLL2DIVR2_DIVS_Pos        (0U)
#define RCC_PLL2DIVR2_DIVT            RCC_PLL2DIVR2_DIVT_Msk                 /*!< DIVT2[2:0] bits: PLL2 DIVT division factor */
#define RCC_PLL2DIVR2_DIVT_Msk        (0x7UL << RCC_PLL2DIVR2_DIVT_Pos)      /*!< 0x00000700 */
#define RCC_PLL2DIVR2_DIVT_Pos        (8U)
#define RCC_PLL2FRACR_FRACN            RCC_PLL2FRACR_FRACN_Msk               /*!< FRACN[12:0] bits */
#define RCC_PLL2FRACR_FRACN_Msk        (0x1FFFUL << RCC_PLL2FRACR_FRACN_Pos) /*!< 0x0000FFF8 */
#define RCC_PLL2FRACR_FRACN_Pos        (3U)
#define RCC_PLL3DIVR1_DIVN            RCC_PLL3DIVR1_DIVN_Msk                 /*!< DIVN3[8:0] bits: PLL3 DIVN division factor */
#define RCC_PLL3DIVR1_DIVN_Msk        (0x1FFUL << RCC_PLL3DIVR1_DIVN_Pos)    /*!< 0x000001FF */
#define RCC_PLL3DIVR1_DIVN_Pos        (0U)
#define RCC_PLL3DIVR1_DIVP            RCC_PLL3DIVR1_DIVP_Msk                 /*!< DIVP3[6:0] bits: PLL3 DIVP division factor */
#define RCC_PLL3DIVR1_DIVP_Msk        (0x7FUL << RCC_PLL3DIVR1_DIVP_Pos)     /*!< 0x0000FE00 */
#define RCC_PLL3DIVR1_DIVP_Pos        (9U)
#define RCC_PLL3DIVR1_DIVQ            RCC_PLL3DIVR1_DIVQ_Msk                 /*!< DIVQ3[6:0] bits: PLL3 DIVQ division factor */
#define RCC_PLL3DIVR1_DIVQ_Msk        (0x7FUL << RCC_PLL3DIVR1_DIVQ_Pos)     /*!< 0x007F0000 */
#define RCC_PLL3DIVR1_DIVQ_Pos        (16U)
#define RCC_PLL3DIVR1_DIVR            RCC_PLL3DIVR1_DIVR_Msk                 /*!< DIVR3[6:0] bits: PLL3 DIVR division factor */
#define RCC_PLL3DIVR1_DIVR_Msk        (0x7FUL << RCC_PLL3DIVR1_DIVR_Pos)     /*!< 0x7F000000 */
#define RCC_PLL3DIVR1_DIVR_Pos        (24U)
#define RCC_PLL3DIVR2_DIVS            RCC_PLL3DIVR2_DIVS_Msk                 /*!< DIVS3[2:0] bits: PLL3 DIVS division factor */
#define RCC_PLL3DIVR2_DIVS_Msk        (0x7UL << RCC_PLL3DIVR2_DIVS_Pos)      /*!< 0x00000007 */
#define RCC_PLL3DIVR2_DIVS_Pos        (0U)
#define RCC_PLL3FRACR_FRACN            RCC_PLL3FRACR_FRACN_Msk               /*!< FRACN[12:0] bits */
#define RCC_PLL3FRACR_FRACN_Msk        (0x1FFFUL << RCC_PLL3FRACR_FRACN_Pos) /*!< 0x0000FFF8 */
#define RCC_PLL3FRACR_FRACN_Pos        (3U)
#define RCC_PLLCFGR_PLL1FRACEN         RCC_PLLCFGR_PLL1FRACEN_Msk              /*!< PLL1 fractional latch enable */
#define RCC_PLLCFGR_PLL1FRACEN_Msk     (0x1UL << RCC_PLLCFGR_PLL1FRACEN_Pos)   /*!< 0x00000001 */
#define RCC_PLLCFGR_PLL1FRACEN_Pos     (0U)
#define RCC_PLLCFGR_PLL2FRACEN         RCC_PLLCFGR_PLL2FRACEN_Msk              /*!< PLL2 fractional latch enable */
#define RCC_PLLCFGR_PLL2FRACEN_Msk     (0x1UL << RCC_PLLCFGR_PLL2FRACEN_Pos)   /*!< 0x00000800 */
#define RCC_PLLCFGR_PLL2FRACEN_Pos     (11U)
#define RCC_PLLCFGR_PLL3FRACEN         RCC_PLLCFGR_PLL3FRACEN_Msk              /*!< PLL3 fractional latch enable */
#define RCC_PLLCFGR_PLL3FRACEN_Msk     (0x1UL << RCC_PLLCFGR_PLL3FRACEN_Pos)   /*!< 0x00400000 */
#define RCC_PLLCFGR_PLL3FRACEN_Pos     (22U)
#define RCC_PLLCKSELR_DIVM1            RCC_PLLCKSELR_DIVM1_Msk                 /*!< DIVM1[5:0] bits */
#define RCC_PLLCKSELR_DIVM1_Msk        (0x3FUL << RCC_PLLCKSELR_DIVM1_Pos)     /*!< 0x000003F0 */
#define RCC_PLLCKSELR_DIVM1_Pos        (4U)
#define RCC_PLLCKSELR_DIVM2            RCC_PLLCKSELR_DIVM2_Msk                 /*!< DIVM2[5:0] bits */
#define RCC_PLLCKSELR_DIVM2_Msk        (0x3FUL << RCC_PLLCKSELR_DIVM2_Pos)     /*!< 0x0003F000 */
#define RCC_PLLCKSELR_DIVM2_Pos        (12U)
#define RCC_PLLCKSELR_DIVM3            RCC_PLLCKSELR_DIVM3_Msk                 /*!< DIVM3[5:0] bits */
#define RCC_PLLCKSELR_DIVM3_Msk        (0x3FUL << RCC_PLLCKSELR_DIVM3_Pos)     /*!< 0x03F00000 */
#define RCC_PLLCKSELR_DIVM3_Pos        (20U)
#define RCC_PLLCKSELR_PLLSRC           RCC_PLLCKSELR_PLLSRC_Msk                /*!< DIVMx and PLLs clock source selection */
#define RCC_PLLCKSELR_PLLSRC_0         (0x01UL << RCC_PLLCKSELR_PLLSRC_Pos)    /*!< 0x00000010 */
#define RCC_PLLCKSELR_PLLSRC_1         (0x02UL << RCC_PLLCKSELR_PLLSRC_Pos)    /*!< 0x00000020 */
#define RCC_PLLCKSELR_PLLSRC_Msk       (0x3UL << RCC_PLLCKSELR_PLLSRC_Pos)     /*!< 0x00000003 */
#define RCC_PLLCKSELR_PLLSRC_Pos       (0U)

#endif
