/* Copyright (c) 2022 STMicroelectronics.
 * SPDX-License-Identifier: Apache-2.0
 * Unchanged CMSIS constants at 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
 * See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt. */

#define ADF1                   ((MDF_TypeDef *) ADF1_BASE)
#define ADF1_BASE                       (AHB1PERIPH_BASE + 0xF000UL)
#define AHB1PERIPH_BASE                 (PERIPH_BASE + 0x00020000UL)
#define AHB2PERIPH_BASE                 (PERIPH_BASE + 0x08000000UL)
#define AHB5PERIPH_BASE                 (PERIPH_BASE + 0x12000000UL)
#define APB1PERIPH_BASE                 PERIPH_BASE
#define APB2PERIPH_BASE                 (PERIPH_BASE + 0x02000000UL)
#define APB4PERIPH_BASE                 (PERIPH_BASE + 0x18000000UL)
#define CEC                    ((CEC_TypeDef *) CEC_BASE)
#define CEC_BASE                        (APB1PERIPH_BASE + 0x6C00UL)
#define CRS_CFGR_FELIM             CRS_CFGR_FELIM_Msk                          /*!< Frequency error limit */
#define CRS_CFGR_FELIM_Msk         (0xFFUL << CRS_CFGR_FELIM_Pos)              /*!< 0x00FF0000 */
#define CRS_CFGR_FELIM_Pos         (16U)
#define CRS_CFGR_RELOAD            CRS_CFGR_RELOAD_Msk                         /*!< Counter reload value */
#define CRS_CFGR_RELOAD_Msk        (0xFFFFUL << CRS_CFGR_RELOAD_Pos)           /*!< 0x0000FFFF */
#define CRS_CFGR_RELOAD_Pos        (0U)
#define CRS_CFGR_SYNCDIV           CRS_CFGR_SYNCDIV_Msk                        /*!< SYNC divider */
#define CRS_CFGR_SYNCDIV_0         (0x1UL << CRS_CFGR_SYNCDIV_Pos)             /*!< 0x01000000 */
#define CRS_CFGR_SYNCDIV_1         (0x2UL << CRS_CFGR_SYNCDIV_Pos)             /*!< 0x02000000 */
#define CRS_CFGR_SYNCDIV_2         (0x4UL << CRS_CFGR_SYNCDIV_Pos)             /*!< 0x04000000 */
#define CRS_CFGR_SYNCDIV_Msk       (0x7UL << CRS_CFGR_SYNCDIV_Pos)             /*!< 0x07000000 */
#define CRS_CFGR_SYNCDIV_Pos       (24U)
#define CRS_CFGR_SYNCPOL           CRS_CFGR_SYNCPOL_Msk                        /*!< SYNC polarity selection */
#define CRS_CFGR_SYNCPOL_Msk       (0x1UL << CRS_CFGR_SYNCPOL_Pos)             /*!< 0x80000000 */
#define CRS_CFGR_SYNCPOL_Pos       (31U)
#define CRS_CFGR_SYNCSRC_0         (0x1UL << CRS_CFGR_SYNCSRC_Pos)             /*!< 0x10000000 */
#define CRS_CFGR_SYNCSRC_1         (0x2UL << CRS_CFGR_SYNCSRC_Pos)             /*!< 0x20000000 */
#define CRS_CFGR_SYNCSRC_Pos       (28U)
#define CRS_CR_AUTOTRIMEN          CRS_CR_AUTOTRIMEN_Msk                       /*!< Automatic trimming enable */
#define CRS_CR_AUTOTRIMEN_Msk      (0x1UL << CRS_CR_AUTOTRIMEN_Pos)            /*!< 0x00000040 */
#define CRS_CR_AUTOTRIMEN_Pos      (6U)
#define CRS_CR_CEN                 CRS_CR_CEN_Msk                              /*!< Frequency error counter enable */
#define CRS_CR_CEN_Msk             (0x1UL << CRS_CR_CEN_Pos)                   /*!< 0x00000020 */
#define CRS_CR_CEN_Pos             (5U)
#define CRS_CR_ERRIE               CRS_CR_ERRIE_Msk                            /*!< SYNC error or trimming error interrupt enable */
#define CRS_CR_ERRIE_Msk           (0x1UL << CRS_CR_ERRIE_Pos)                 /*!< 0x00000004 */
#define CRS_CR_ERRIE_Pos           (2U)
#define CRS_CR_ESYNCIE             CRS_CR_ESYNCIE_Msk                          /*!< Expected SYNC interrupt enable */
#define CRS_CR_ESYNCIE_Msk         (0x1UL << CRS_CR_ESYNCIE_Pos)               /*!< 0x00000008 */
#define CRS_CR_ESYNCIE_Pos         (3U)
#define CRS_CR_SWSYNC              CRS_CR_SWSYNC_Msk                           /*!< Generate software SYNC event */
#define CRS_CR_SWSYNC_Msk          (0x1UL << CRS_CR_SWSYNC_Pos)                /*!< 0x00000080 */
#define CRS_CR_SWSYNC_Pos          (7U)
#define CRS_CR_SYNCOKIE            CRS_CR_SYNCOKIE_Msk                         /*!< SYNC event OK interrupt enable */
#define CRS_CR_SYNCOKIE_Msk        (0x1UL << CRS_CR_SYNCOKIE_Pos)              /*!< 0x00000001 */
#define CRS_CR_SYNCOKIE_Pos        (0U)
#define CRS_CR_SYNCWARNIE          CRS_CR_SYNCWARNIE_Msk                       /*!< SYNC warning interrupt enable */
#define CRS_CR_SYNCWARNIE_Msk      (0x1UL << CRS_CR_SYNCWARNIE_Pos)            /*!< 0x00000002 */
#define CRS_CR_SYNCWARNIE_Pos      (1U)
#define CRS_CR_TRIM                CRS_CR_TRIM_Msk                             /*!< HSI48 oscillator smooth trimming */
#define CRS_CR_TRIM_Msk            (0x3FUL << CRS_CR_TRIM_Pos)                 /*!< 0x00003F00 */
#define CRS_CR_TRIM_Pos            (8U)
#define CRS_ICR_ERRC               CRS_ICR_ERRC_Msk                            /*!< Error clear flag */
#define CRS_ICR_ERRC_Msk           (0x1UL << CRS_ICR_ERRC_Pos)                 /*!< 0x00000004 */
#define CRS_ICR_ERRC_Pos           (2U)
#define CRS_ICR_ESYNCC             CRS_ICR_ESYNCC_Msk                          /*!< Expected SYNC clear flag */
#define CRS_ICR_ESYNCC_Msk         (0x1UL << CRS_ICR_ESYNCC_Pos)               /*!< 0x00000008 */
#define CRS_ICR_ESYNCC_Pos         (3U)
#define CRS_ICR_SYNCOKC            CRS_ICR_SYNCOKC_Msk                         /*!< SYNC event OK clear flag */
#define CRS_ICR_SYNCOKC_Msk        (0x1UL << CRS_ICR_SYNCOKC_Pos)              /*!< 0x00000001 */
#define CRS_ICR_SYNCOKC_Pos        (0U)
#define CRS_ICR_SYNCWARNC          CRS_ICR_SYNCWARNC_Msk                       /*!< SYNC warning clear flag */
#define CRS_ICR_SYNCWARNC_Msk      (0x1UL << CRS_ICR_SYNCWARNC_Pos)            /*!< 0x00000002 */
#define CRS_ICR_SYNCWARNC_Pos      (1U)
#define CRS_ISR_ERRF               CRS_ISR_ERRF_Msk                            /*!< Error flag */
#define CRS_ISR_ERRF_Msk           (0x1UL << CRS_ISR_ERRF_Pos)                 /*!< 0x00000004 */
#define CRS_ISR_ERRF_Pos           (2U)
#define CRS_ISR_ESYNCF             CRS_ISR_ESYNCF_Msk                          /*!< Expected SYNC flag */
#define CRS_ISR_ESYNCF_Msk         (0x1UL << CRS_ISR_ESYNCF_Pos)               /*!< 0x00000008 */
#define CRS_ISR_ESYNCF_Pos         (3U)
#define CRS_ISR_FECAP              CRS_ISR_FECAP_Msk                           /*!< Frequency error capture */
#define CRS_ISR_FECAP_Msk          (0xFFFFUL << CRS_ISR_FECAP_Pos)             /*!< 0xFFFF0000 */
#define CRS_ISR_FECAP_Pos          (16U)
#define CRS_ISR_FEDIR              CRS_ISR_FEDIR_Msk                           /*!< Frequency error direction */
#define CRS_ISR_FEDIR_Msk          (0x1UL << CRS_ISR_FEDIR_Pos)                /*!< 0x00008000 */
#define CRS_ISR_FEDIR_Pos          (15U)
#define CRS_ISR_SYNCERR            CRS_ISR_SYNCERR_Msk                         /*!< SYNC error */
#define CRS_ISR_SYNCERR_Msk        (0x1UL << CRS_ISR_SYNCERR_Pos)              /*!< 0x00000100 */
#define CRS_ISR_SYNCERR_Pos        (8U)
#define CRS_ISR_SYNCMISS           CRS_ISR_SYNCMISS_Msk                        /*!< SYNC missed */
#define CRS_ISR_SYNCMISS_Msk       (0x1UL << CRS_ISR_SYNCMISS_Pos)             /*!< 0x00000200 */
#define CRS_ISR_SYNCMISS_Pos       (9U)
#define CRS_ISR_SYNCOKF            CRS_ISR_SYNCOKF_Msk                         /*!< SYNC event OK flag */
#define CRS_ISR_SYNCOKF_Msk        (0x1UL << CRS_ISR_SYNCOKF_Pos)              /*!< 0x00000001 */
#define CRS_ISR_SYNCOKF_Pos        (0U)
#define CRS_ISR_SYNCWARNF          CRS_ISR_SYNCWARNF_Msk                       /*!< SYNC warning flag */
#define CRS_ISR_SYNCWARNF_Msk      (0x1UL << CRS_ISR_SYNCWARNF_Pos)            /*!< 0x00000002 */
#define CRS_ISR_SYNCWARNF_Pos      (1U)
#define CRS_ISR_TRIMOVF            CRS_ISR_TRIMOVF_Msk                         /*!< Trimming overflow or underflow */
#define CRS_ISR_TRIMOVF_Msk        (0x1UL << CRS_ISR_TRIMOVF_Pos)              /*!< 0x00000400 */
#define CRS_ISR_TRIMOVF_Pos        (10U)
#define ETH                    ((ETH_TypeDef *)ETH_BASE)
#define ETH_BASE                        (AHB1PERIPH_BASE + 0x8000UL)
#define EXTI_IMR1_IM18               EXTI_IMR1_IM18_Msk                        /*!< Interrupt Mask on line 18 */
#define EXTI_IMR1_IM18_Msk           (0x1UL << EXTI_IMR1_IM18_Pos)             /*!< 0x00040000 */
#define EXTI_IMR1_IM18_Pos           (18U)
#define I2C1                   ((I2C_TypeDef *) I2C1_BASE)
#define I2C1_BASE                       (APB1PERIPH_BASE + 0x5400UL)
#define I2C2                   ((I2C_TypeDef *) I2C2_BASE)
#define I2C2_BASE                       (APB1PERIPH_BASE + 0x5800UL)
#define I2C3                   ((I2C_TypeDef *) I2C3_BASE)
#define I2C3_BASE                       (APB1PERIPH_BASE + 0x5C00UL)
#define I3C1                   ((I3C_TypeDef *) I3C1_BASE)
#define I3C1_BASE                       (APB1PERIPH_BASE + 0x5400UL)
#define LPTIM1                 ((LPTIM_TypeDef *) LPTIM1_BASE)
#define LPTIM1_BASE                     (APB1PERIPH_BASE + 0x2400UL)
#define LPTIM2                 ((LPTIM_TypeDef *) LPTIM2_BASE)
#define LPTIM2_BASE                     (APB4PERIPH_BASE + 0x2400UL)
#define LPTIM3                 ((LPTIM_TypeDef *) LPTIM3_BASE)
#define LPTIM3_BASE                     (APB4PERIPH_BASE + 0x2800UL)
#define LPTIM4                 ((LPTIM_TypeDef *) LPTIM4_BASE)
#define LPTIM4_BASE                     (APB4PERIPH_BASE + 0x2C00UL)
#define LPTIM5                 ((LPTIM_TypeDef *) LPTIM5_BASE)
#define LPTIM5_BASE                     (APB4PERIPH_BASE + 0x3000UL)
#define LPUART1                ((USART_TypeDef *) LPUART1_BASE)
#define LPUART1_BASE                    (APB4PERIPH_BASE + 0x0C00UL)
#define PERIPH_BASE                     0x40000000UL  /*!< AHB and APB Peripherals base address */
#define PSSI                   ((PSSI_TypeDef *) PSSI_BASE)
#define PSSI_BASE                       (AHB2PERIPH_BASE + 0x0400UL)
#define PWR_CR1_DBP                    PWR_CR1_DBP_Msk                         /*!< Disable Back-up domain Protection */
#define PWR_CR1_DBP_Msk                (0x1UL << PWR_CR1_DBP_Pos)              /*!< 0x00000100 */
#define PWR_CR1_DBP_Pos                (8U)
#define RCC_APB1RSTR2_CRSRST           RCC_APB1RSTR2_CRSRST_Msk
#define RCC_APB1RSTR2_CRSRST_Msk       (0x1UL << RCC_APB1RSTR2_CRSRST_Pos)     /*!< 0x00000002 */
#define RCC_APB1RSTR2_CRSRST_Pos       (1U)
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
#define RCC_BDCR_LSECSSON              RCC_BDCR_LSECSSON_Msk
#define RCC_BDCR_LSECSSON_Msk          (0x1UL << RCC_BDCR_LSECSSON_Pos)        /*!< 0x00000020 */
#define RCC_BDCR_LSECSSON_Pos          (5U)
#define RCC_BDCR_LSERDY                RCC_BDCR_LSERDY_Msk
#define RCC_BDCR_LSERDY_Msk            (0x1UL << RCC_BDCR_LSERDY_Pos)          /*!< 0x00000002 */
#define RCC_BDCR_LSERDY_Pos            (1U)
#define RCC_BDCR_RTCEN                 RCC_BDCR_RTCEN_Msk
#define RCC_BDCR_RTCEN_Msk             (0x1UL << RCC_BDCR_RTCEN_Pos)           /*!< 0x00008000 */
#define RCC_BDCR_RTCEN_Pos             (15U)
#define RCC_BDCR_RTCSEL                RCC_BDCR_RTCSEL_Msk
#define RCC_BDCR_RTCSEL_0              (0x1UL << RCC_BDCR_RTCSEL_Pos)          /*!< 0x00000100 */
#define RCC_BDCR_RTCSEL_1              (0x2UL << RCC_BDCR_RTCSEL_Pos)          /*!< 0x00000200 */
#define RCC_BDCR_RTCSEL_Msk            (0x3UL << RCC_BDCR_RTCSEL_Pos)          /*!< 0x00000300 */
#define RCC_BDCR_RTCSEL_Pos            (8U)
#define RCC_BDCR_VSWRST                RCC_BDCR_VSWRST_Msk
#define RCC_BDCR_VSWRST_Msk            (0x1UL << RCC_BDCR_VSWRST_Pos)          /*!< 0x00010000 */
#define RCC_BDCR_VSWRST_Pos            (16U)
#define RCC_BMCFGR_BMPRE               RCC_BMCFGR_BMPRE_Msk                    /*!< BMPRE[3:0] bits */
#define RCC_BMCFGR_BMPRE_Msk           (0xFUL << RCC_BMCFGR_BMPRE_Pos)         /*!< 0x0000000F */
#define RCC_BMCFGR_BMPRE_Pos           (0U)
#define RCC_CCIPR1_ADCSEL            RCC_CCIPR1_ADCSEL_Msk
#define RCC_CCIPR1_ADCSEL_0          (0x1UL << RCC_CCIPR1_ADCSEL_Pos)        /*!< 0x01000000 */
#define RCC_CCIPR1_ADCSEL_1          (0x2UL << RCC_CCIPR1_ADCSEL_Pos)        /*!< 0x02000000 */
#define RCC_CCIPR1_ADCSEL_Msk        (0x3UL << RCC_CCIPR1_ADCSEL_Pos)        /*!< 0x03000000 */
#define RCC_CCIPR1_ADCSEL_Pos        (24U)
#define RCC_CCIPR1_ADF1SEL           RCC_CCIPR1_ADF1SEL_Msk
#define RCC_CCIPR1_ADF1SEL_0         (0x1UL << RCC_CCIPR1_ADF1SEL_Pos)       /*!< 0x00100000 */
#define RCC_CCIPR1_ADF1SEL_1         (0x2UL << RCC_CCIPR1_ADF1SEL_Pos)       /*!< 0x00200000 */
#define RCC_CCIPR1_ADF1SEL_2         (0x4UL << RCC_CCIPR1_ADF1SEL_Pos)       /*!< 0x00400000 */
#define RCC_CCIPR1_ADF1SEL_Msk       (0x7UL << RCC_CCIPR1_ADF1SEL_Pos)       /*!< 0x00700000 */
#define RCC_CCIPR1_ADF1SEL_Pos       (20U)
#define RCC_CCIPR1_CKPERSEL          RCC_CCIPR1_CKPERSEL_Msk
#define RCC_CCIPR1_CKPERSEL_0        (0x1UL << RCC_CCIPR1_CKPERSEL_Pos)      /*!< 0x10000000 */
#define RCC_CCIPR1_CKPERSEL_1        (0x2UL << RCC_CCIPR1_CKPERSEL_Pos)      /*!< 0x20000000 */
#define RCC_CCIPR1_CKPERSEL_Msk      (0x3UL << RCC_CCIPR1_CKPERSEL_Pos)      /*!< 0x30000000 */
#define RCC_CCIPR1_CKPERSEL_Pos      (28U)
#define RCC_CCIPR1_ETH1PHYCKSEL      RCC_CCIPR1_ETH1PHYCKSEL_Msk
#define RCC_CCIPR1_ETH1PHYCKSEL_Msk  (0x1UL << RCC_CCIPR1_ETH1PHYCKSEL_Pos)  /*!< 0x00040000 */
#define RCC_CCIPR1_ETH1PHYCKSEL_Pos  (18U)
#define RCC_CCIPR1_ETH1REFCKSEL       RCC_CCIPR1_ETH1REFCKSEL_Msk
#define RCC_CCIPR1_ETH1REFCKSEL_0    (0x1UL << RCC_CCIPR1_ETH1REFCKSEL_Pos)  /*!< 0x00010000 */
#define RCC_CCIPR1_ETH1REFCKSEL_1    (0x2UL << RCC_CCIPR1_ETH1REFCKSEL_Pos)  /*!< 0x00020000 */
#define RCC_CCIPR1_ETH1REFCKSEL_Msk  (0x3UL << RCC_CCIPR1_ETH1REFCKSEL_Pos)  /*!< 0x00030000 */
#define RCC_CCIPR1_ETH1REFCKSEL_Pos  (16U)
#define RCC_CCIPR1_FMCSEL            RCC_CCIPR1_FMCSEL_Msk
#define RCC_CCIPR1_FMCSEL_0          (0x1UL << RCC_CCIPR1_FMCSEL_Pos)        /*!< 0x00000001 */
#define RCC_CCIPR1_FMCSEL_1          (0x2UL << RCC_CCIPR1_FMCSEL_Pos)        /*!< 0x00000002 */
#define RCC_CCIPR1_FMCSEL_Msk        (0x3UL << RCC_CCIPR1_FMCSEL_Pos)        /*!< 0x00000003 */
#define RCC_CCIPR1_FMCSEL_Pos        (0U)
#define RCC_CCIPR1_OTGFSSEL          RCC_CCIPR1_OTGFSSEL_Msk
#define RCC_CCIPR1_OTGFSSEL_0        (0x1UL << RCC_CCIPR1_OTGFSSEL_Pos)      /*!< 0x00004000 */
#define RCC_CCIPR1_OTGFSSEL_1        (0x2UL << RCC_CCIPR1_OTGFSSEL_Pos)      /*!< 0x00008000 */
#define RCC_CCIPR1_OTGFSSEL_Msk      (0x3UL << RCC_CCIPR1_OTGFSSEL_Pos)      /*!< 0x0000C000 */
#define RCC_CCIPR1_OTGFSSEL_Pos      (14U)
#define RCC_CCIPR1_PSSISEL           RCC_CCIPR1_PSSISEL_Msk
#define RCC_CCIPR1_PSSISEL_Msk       (0x1UL << RCC_CCIPR1_PSSISEL_Pos)       /*!< 0x08000000 */
#define RCC_CCIPR1_PSSISEL_Pos       (27U)
#define RCC_CCIPR1_SDMMC12SEL        RCC_CCIPR1_SDMMC12SEL_Msk
#define RCC_CCIPR1_SDMMC12SEL_Msk    (0x1UL << RCC_CCIPR1_SDMMC12SEL_Pos)      /*!< 0x00000004 */
#define RCC_CCIPR1_SDMMC12SEL_Pos    (2U)
#define RCC_CCIPR1_USBPHYCSEL        RCC_CCIPR1_USBPHYCSEL_Msk
#define RCC_CCIPR1_USBPHYCSEL_0      (0x1UL << RCC_CCIPR1_USBPHYCSEL_Pos)    /*!< 0x00001000 */
#define RCC_CCIPR1_USBPHYCSEL_1      (0x2UL << RCC_CCIPR1_USBPHYCSEL_Pos)    /*!< 0x00002000 */
#define RCC_CCIPR1_USBPHYCSEL_Msk    (0x3UL << RCC_CCIPR1_USBPHYCSEL_Pos)    /*!< 0x00003000 */
#define RCC_CCIPR1_USBPHYCSEL_Pos    (12U)
#define RCC_CCIPR1_USBREFCKSEL       RCC_CCIPR1_USBREFCKSEL_Msk
#define RCC_CCIPR1_USBREFCKSEL_0     (0x1UL << RCC_CCIPR1_USBREFCKSEL_Pos)   /*!< 0x00000100 */
#define RCC_CCIPR1_USBREFCKSEL_1     (0x2UL << RCC_CCIPR1_USBREFCKSEL_Pos)   /*!< 0x00000200 */
#define RCC_CCIPR1_USBREFCKSEL_2     (0x4UL << RCC_CCIPR1_USBREFCKSEL_Pos)   /*!< 0x00000400 */
#define RCC_CCIPR1_USBREFCKSEL_3     (0x8UL << RCC_CCIPR1_USBREFCKSEL_Pos)   /*!< 0x00000800 */
#define RCC_CCIPR1_USBREFCKSEL_Msk   (0xFUL << RCC_CCIPR1_USBREFCKSEL_Pos)   /*!< 0x00000F00 */
#define RCC_CCIPR1_USBREFCKSEL_Pos   (8U)
#define RCC_CCIPR1_XSPI1SEL          RCC_CCIPR1_XSPI1SEL_Msk
#define RCC_CCIPR1_XSPI1SEL_0        (0x1UL << RCC_CCIPR1_XSPI1SEL_Pos)      /*!< 0x00000010 */
#define RCC_CCIPR1_XSPI1SEL_1        (0x2UL << RCC_CCIPR1_XSPI1SEL_Pos)      /*!< 0x00000020 */
#define RCC_CCIPR1_XSPI1SEL_Msk      (0x3UL << RCC_CCIPR1_XSPI1SEL_Pos)      /*!< 0x00000030 */
#define RCC_CCIPR1_XSPI1SEL_Pos      (4U)
#define RCC_CCIPR1_XSPI2SEL          RCC_CCIPR1_XSPI2SEL_Msk
#define RCC_CCIPR1_XSPI2SEL_0        (0x1UL << RCC_CCIPR1_XSPI2SEL_Pos)      /*!< 0x00000040 */
#define RCC_CCIPR1_XSPI2SEL_1        (0x2UL << RCC_CCIPR1_XSPI2SEL_Pos)      /*!< 0x00000080 */
#define RCC_CCIPR1_XSPI2SEL_Msk      (0x3UL << RCC_CCIPR1_XSPI2SEL_Pos)      /*!< 0x000000C0 */
#define RCC_CCIPR1_XSPI2SEL_Pos      (6U)
#define RCC_CCIPR2_CECSEL            RCC_CCIPR2_CECSEL_Msk
#define RCC_CCIPR2_CECSEL_0          (0x1UL << RCC_CCIPR2_CECSEL_Pos)       /*!< 0x01000000 */
#define RCC_CCIPR2_CECSEL_1          (0x2UL << RCC_CCIPR2_CECSEL_Pos)       /*!< 0x02000000 */
#define RCC_CCIPR2_CECSEL_Msk        (0x3UL << RCC_CCIPR2_CECSEL_Pos)       /*!< 0x03000000 */
#define RCC_CCIPR2_CECSEL_Pos        (28U)
#define RCC_CCIPR2_FDCANSEL          RCC_CCIPR2_FDCANSEL_Msk
#define RCC_CCIPR2_FDCANSEL_0        (0x1UL << RCC_CCIPR2_FDCANSEL_Pos)     /*!< 0x00400000 */
#define RCC_CCIPR2_FDCANSEL_1        (0x2UL << RCC_CCIPR2_FDCANSEL_Pos)     /*!< 0x00800000 */
#define RCC_CCIPR2_FDCANSEL_Msk      (0x3UL << RCC_CCIPR2_FDCANSEL_Pos)     /*!< 0x00C00000 */
#define RCC_CCIPR2_FDCANSEL_Pos      (22U)
#define RCC_CCIPR2_I2C1_I3C1SEL      RCC_CCIPR2_I2C1_I3C1SEL_Msk
#define RCC_CCIPR2_I2C1_I3C1SEL_0    (0x1UL << RCC_CCIPR2_I2C1_I3C1SEL_Pos)  /*!< 0x00001000 */
#define RCC_CCIPR2_I2C1_I3C1SEL_1    (0x2UL << RCC_CCIPR2_I2C1_I3C1SEL_Pos)  /*!< 0x00002000 */
#define RCC_CCIPR2_I2C1_I3C1SEL_Msk  (0x3UL << RCC_CCIPR2_I2C1_I3C1SEL_Pos)  /*!< 0x00003000 */
#define RCC_CCIPR2_I2C1_I3C1SEL_Pos  (12U)
#define RCC_CCIPR2_I2C23SEL          RCC_CCIPR2_I2C23SEL_Msk
#define RCC_CCIPR2_I2C23SEL_0        (0x1UL << RCC_CCIPR2_I2C23SEL_Pos)      /*!< 0x00000100 */
#define RCC_CCIPR2_I2C23SEL_1        (0x2UL << RCC_CCIPR2_I2C23SEL_Pos)      /*!< 0x00000200 */
#define RCC_CCIPR2_I2C23SEL_Msk      (0x3UL << RCC_CCIPR2_I2C23SEL_Pos)      /*!< 0x00000300 */
#define RCC_CCIPR2_I2C23SEL_Pos      (8U)
#define RCC_CCIPR2_LPTIM1SEL         RCC_CCIPR2_LPTIM1SEL_Msk
#define RCC_CCIPR2_LPTIM1SEL_0       (0x1UL << RCC_CCIPR2_LPTIM1SEL_Pos)     /*!< 0x00010000 */
#define RCC_CCIPR2_LPTIM1SEL_1       (0x2UL << RCC_CCIPR2_LPTIM1SEL_Pos)     /*!< 0x00020000 */
#define RCC_CCIPR2_LPTIM1SEL_2       (0x4UL << RCC_CCIPR2_LPTIM1SEL_Pos)     /*!< 0x00040000 */
#define RCC_CCIPR2_LPTIM1SEL_Msk     (0x7UL << RCC_CCIPR2_LPTIM1SEL_Pos)     /*!< 0x00070000 */
#define RCC_CCIPR2_LPTIM1SEL_Pos     (16U)
#define RCC_CCIPR2_SPDIFRXSEL        RCC_CCIPR2_SPDIFRXSEL_Msk
#define RCC_CCIPR2_SPDIFRXSEL_0      (0x1UL << RCC_CCIPR2_SPDIFRXSEL_Pos)   /*!< 0x01000000 */
#define RCC_CCIPR2_SPDIFRXSEL_1      (0x2UL << RCC_CCIPR2_SPDIFRXSEL_Pos)   /*!< 0x02000000 */
#define RCC_CCIPR2_SPDIFRXSEL_Msk    (0x3UL << RCC_CCIPR2_SPDIFRXSEL_Pos)   /*!< 0x03000000 */
#define RCC_CCIPR2_SPDIFRXSEL_Pos    (24U)
#define RCC_CCIPR2_SPI23SEL          RCC_CCIPR2_SPI23SEL_Msk
#define RCC_CCIPR2_SPI23SEL_0        (0x1UL << RCC_CCIPR2_SPI23SEL_Pos)      /*!< 0x00000010 */
#define RCC_CCIPR2_SPI23SEL_1        (0x2UL << RCC_CCIPR2_SPI23SEL_Pos)      /*!< 0x00000020 */
#define RCC_CCIPR2_SPI23SEL_2        (0x4UL << RCC_CCIPR2_SPI23SEL_Pos)      /*!< 0x00000040 */
#define RCC_CCIPR2_SPI23SEL_Msk      (0x7UL << RCC_CCIPR2_SPI23SEL_Pos)      /*!< 0x00000070 */
#define RCC_CCIPR2_SPI23SEL_Pos      (4U)
#define RCC_CCIPR2_UART234578SEL     RCC_CCIPR2_UART234578SEL_Msk
#define RCC_CCIPR2_UART234578SEL_0   (0x1UL << RCC_CCIPR2_UART234578SEL_Pos) /*!< 0x00000001 */
#define RCC_CCIPR2_UART234578SEL_1   (0x2UL << RCC_CCIPR2_UART234578SEL_Pos) /*!< 0x00000002 */
#define RCC_CCIPR2_UART234578SEL_2   (0x4UL << RCC_CCIPR2_UART234578SEL_Pos) /*!< 0x00000004 */
#define RCC_CCIPR2_UART234578SEL_Msk (0x7UL << RCC_CCIPR2_UART234578SEL_Pos) /*!< 0x00000007 */
#define RCC_CCIPR2_UART234578SEL_Pos (0U)
#define RCC_CCIPR3_SAI1SEL           RCC_CCIPR3_SAI1SEL_Msk
#define RCC_CCIPR3_SAI1SEL_0         (0x1UL << RCC_CCIPR3_SAI1SEL_Pos)      /*!< 0x00010000 */
#define RCC_CCIPR3_SAI1SEL_1         (0x2UL << RCC_CCIPR3_SAI1SEL_Pos)      /*!< 0x00020000 */
#define RCC_CCIPR3_SAI1SEL_2         (0x4UL << RCC_CCIPR3_SAI1SEL_Pos)      /*!< 0x00040000 */
#define RCC_CCIPR3_SAI1SEL_Msk       (0x7UL << RCC_CCIPR3_SAI1SEL_Pos)      /*!< 0x00070000 */
#define RCC_CCIPR3_SAI1SEL_Pos       (16U)
#define RCC_CCIPR3_SAI2SEL           RCC_CCIPR3_SAI2SEL_Msk
#define RCC_CCIPR3_SAI2SEL_0         (0x1UL << RCC_CCIPR3_SAI2SEL_Pos)      /*!< 0x00100000 */
#define RCC_CCIPR3_SAI2SEL_1         (0x2UL << RCC_CCIPR3_SAI2SEL_Pos)      /*!< 0x00200000 */
#define RCC_CCIPR3_SAI2SEL_2         (0x4UL << RCC_CCIPR3_SAI2SEL_Pos)      /*!< 0x00400000 */
#define RCC_CCIPR3_SAI2SEL_Msk       (0x7UL << RCC_CCIPR3_SAI2SEL_Pos)      /*!< 0x00700000 */
#define RCC_CCIPR3_SAI2SEL_Pos       (20U)
#define RCC_CCIPR3_SPI1SEL           RCC_CCIPR3_SPI1SEL_Msk
#define RCC_CCIPR3_SPI1SEL_0         (0x1UL << RCC_CCIPR3_SPI1SEL_Pos)      /*!< 0x00000100 */
#define RCC_CCIPR3_SPI1SEL_1         (0x2UL << RCC_CCIPR3_SPI1SEL_Pos)      /*!< 0x00000200 */
#define RCC_CCIPR3_SPI1SEL_2         (0x4UL << RCC_CCIPR3_SPI1SEL_Pos)      /*!< 0x00000400 */
#define RCC_CCIPR3_SPI1SEL_Msk       (0x7UL << RCC_CCIPR3_SPI1SEL_Pos)      /*!< 0x00000700 */
#define RCC_CCIPR3_SPI1SEL_Pos       (8U)
#define RCC_CCIPR3_SPI45SEL          RCC_CCIPR3_SPI45SEL_Msk
#define RCC_CCIPR3_SPI45SEL_0        (0x1UL << RCC_CCIPR3_SPI45SEL_Pos)     /*!< 0x00000010 */
#define RCC_CCIPR3_SPI45SEL_1        (0x2UL << RCC_CCIPR3_SPI45SEL_Pos)     /*!< 0x00000020 */
#define RCC_CCIPR3_SPI45SEL_2        (0x4UL << RCC_CCIPR3_SPI45SEL_Pos)     /*!< 0x00000040 */
#define RCC_CCIPR3_SPI45SEL_Msk      (0x7UL << RCC_CCIPR3_SPI45SEL_Pos)     /*!< 0x00000070 */
#define RCC_CCIPR3_SPI45SEL_Pos      (4U)
#define RCC_CCIPR3_USART1SEL         RCC_CCIPR3_USART1SEL_Msk
#define RCC_CCIPR3_USART1SEL_0       (0x1UL << RCC_CCIPR3_USART1SEL_Pos)    /*!< 0x00000001 */
#define RCC_CCIPR3_USART1SEL_1       (0x2UL << RCC_CCIPR3_USART1SEL_Pos)    /*!< 0x00000002 */
#define RCC_CCIPR3_USART1SEL_2       (0x4UL << RCC_CCIPR3_USART1SEL_Pos)    /*!< 0x00000004 */
#define RCC_CCIPR3_USART1SEL_Msk     (0x7UL << RCC_CCIPR3_USART1SEL_Pos)    /*!< 0x00000007 */
#define RCC_CCIPR3_USART1SEL_Pos     (0U)
#define RCC_CCIPR4_LPTIM23SEL        RCC_CCIPR4_LPTIM23SEL_Msk
#define RCC_CCIPR4_LPTIM23SEL_0      (0x1UL << RCC_CCIPR4_LPTIM23SEL_Pos)   /*!< 0x00000100 */
#define RCC_CCIPR4_LPTIM23SEL_1      (0x2UL << RCC_CCIPR4_LPTIM23SEL_Pos)   /*!< 0x00000200 */
#define RCC_CCIPR4_LPTIM23SEL_2      (0x4UL << RCC_CCIPR4_LPTIM23SEL_Pos)   /*!< 0x00000400 */
#define RCC_CCIPR4_LPTIM23SEL_Msk    (0x7UL << RCC_CCIPR4_LPTIM23SEL_Pos)   /*!< 0x00000700 */
#define RCC_CCIPR4_LPTIM23SEL_Pos    (8U)
#define RCC_CCIPR4_LPTIM45SEL        RCC_CCIPR4_LPTIM45SEL_Msk
#define RCC_CCIPR4_LPTIM45SEL_0      (0x1UL << RCC_CCIPR4_LPTIM45SEL_Pos)   /*!< 0x00001000 */
#define RCC_CCIPR4_LPTIM45SEL_1      (0x2UL << RCC_CCIPR4_LPTIM45SEL_Pos)   /*!< 0x00002000 */
#define RCC_CCIPR4_LPTIM45SEL_2      (0x4UL << RCC_CCIPR4_LPTIM45SEL_Pos)   /*!< 0x00004000 */
#define RCC_CCIPR4_LPTIM45SEL_Msk    (0x7UL << RCC_CCIPR4_LPTIM45SEL_Pos)   /*!< 0x00007000 */
#define RCC_CCIPR4_LPTIM45SEL_Pos    (12U)
#define RCC_CCIPR4_LPUART1SEL        RCC_CCIPR4_LPUART1SEL_Msk
#define RCC_CCIPR4_LPUART1SEL_0      (0x1UL << RCC_CCIPR4_LPUART1SEL_Pos)   /*!< 0x00000001 */
#define RCC_CCIPR4_LPUART1SEL_1      (0x2UL << RCC_CCIPR4_LPUART1SEL_Pos)   /*!< 0x00000002 */
#define RCC_CCIPR4_LPUART1SEL_2      (0x4UL << RCC_CCIPR4_LPUART1SEL_Pos)   /*!< 0x00000004 */
#define RCC_CCIPR4_LPUART1SEL_Msk    (0x7UL << RCC_CCIPR4_LPUART1SEL_Pos)   /*!< 0x00000007 */
#define RCC_CCIPR4_LPUART1SEL_Pos    (0U)
#define RCC_CCIPR4_SPI6SEL           RCC_CCIPR4_SPI6SEL_Msk
#define RCC_CCIPR4_SPI6SEL_0         (0x1UL << RCC_CCIPR4_SPI6SEL_Pos)      /*!< 0x00000010 */
#define RCC_CCIPR4_SPI6SEL_1         (0x2UL << RCC_CCIPR4_SPI6SEL_Pos)      /*!< 0x00000020 */
#define RCC_CCIPR4_SPI6SEL_2         (0x4UL << RCC_CCIPR4_SPI6SEL_Pos)      /*!< 0x00000040 */
#define RCC_CCIPR4_SPI6SEL_Msk       (0x7UL << RCC_CCIPR4_SPI6SEL_Pos)      /*!< 0x00000070 */
#define RCC_CCIPR4_SPI6SEL_Pos       (4U)
#define RCC_CDCFGR_CPRE                RCC_CDCFGR_CPRE_Msk                     /*!< CPRE[3:0] bits */
#define RCC_CDCFGR_CPRE_3              (0x8UL << RCC_CDCFGR_CPRE_Pos)          /*!< 0x00000008 */
#define RCC_CDCFGR_CPRE_Msk            (0xFUL << RCC_CDCFGR_CPRE_Pos)          /*!< 0x0000000F */
#define RCC_CDCFGR_CPRE_Pos            (0U)
#define RCC_CFGR_RTCPRE                RCC_CFGR_RTCPRE_Msk                     /*!< RTCPRE[5:0] bits (HSE division factor for RTC clock) */
#define RCC_CFGR_RTCPRE_Msk            (0x3FUL << RCC_CFGR_RTCPRE_Pos)         /*!< 0x00003F00 */
#define RCC_CFGR_RTCPRE_Pos            (8U)
#define RCC_CFGR_STOPKERWUCK           RCC_CFGR_STOPKERWUCK_Msk                /*!< Kernel Clock Selection after a Wake Up from Stop */
#define RCC_CFGR_STOPKERWUCK_Msk       (0x1UL << RCC_CFGR_STOPKERWUCK_Pos)     /*!< 0x00000080 */
#define RCC_CFGR_STOPKERWUCK_Pos       (7U)
#define RCC_CFGR_STOPWUCK              RCC_CFGR_STOPWUCK_Msk                   /*!< Wake Up from stop and CSS backup clock selection */
#define RCC_CFGR_STOPWUCK_Msk          (0x1UL << RCC_CFGR_STOPWUCK_Pos)        /*!< 0x00000040 */
#define RCC_CFGR_STOPWUCK_Pos          (6U)
#define RCC_CFGR_SWS                   RCC_CFGR_SWS_Msk                        /*!< SWS[2:0] bits (System clock switch status) */
#define RCC_CFGR_SWS_0                 (0x1UL << RCC_CFGR_SWS_Pos)             /*!< 0x00000008 */
#define RCC_CFGR_SWS_1                 (0x2UL << RCC_CFGR_SWS_Pos)             /*!< 0x00000010 */
#define RCC_CFGR_SWS_Msk               (0x7UL << RCC_CFGR_SWS_Pos)             /*!< 0x00000038 */
#define RCC_CFGR_SWS_Pos               (3U)
#define RCC_CFGR_TIMPRE                RCC_CFGR_TIMPRE_Msk                     /*!< TIMPRE configuration */
#define RCC_CFGR_TIMPRE_Msk            (0x1UL << RCC_CFGR_TIMPRE_Pos)          /*!< 0x00008000 */
#define RCC_CFGR_TIMPRE_Pos            (15U)
#define RCC_CIFR_LSECSSF               RCC_CIFR_LSECSSF_Msk
#define RCC_CIFR_LSECSSF_Msk           (0x1UL << RCC_CIFR_LSECSSF_Pos)         /*!< 0x00000200 */
#define RCC_CIFR_LSECSSF_Pos           (9U)
#define RCC_CKPROTR_FMCCKP             RCC_CKPROTR_FMCCKP_Msk
#define RCC_CKPROTR_FMCCKP_Msk         (0x1UL << RCC_CKPROTR_FMCCKP_Pos)       /*!< 0x00000002 */
#define RCC_CKPROTR_FMCCKP_Pos         (1U)
#define RCC_CKPROTR_FMCSWP             RCC_CKPROTR_FMCSWP_Msk
#define RCC_CKPROTR_FMCSWP_0           (0x1UL << RCC_CKPROTR_FMCSWP_Pos)       /*!< 0x00001000 */
#define RCC_CKPROTR_FMCSWP_2           (0x4UL << RCC_CKPROTR_FMCSWP_Pos)       /*!< 0x00004000 */
#define RCC_CKPROTR_FMCSWP_Msk         (0x7UL << RCC_CKPROTR_FMCSWP_Pos)       /*!< 0x00007000 */
#define RCC_CKPROTR_FMCSWP_Pos         (12U)
#define RCC_CKPROTR_XSPI1SWP           RCC_CKPROTR_XSPI1SWP_Msk
#define RCC_CKPROTR_XSPI1SWP_2         (0x4UL << RCC_CKPROTR_XSPI1SWP_Pos)     /*!< 0x00000040 */
#define RCC_CKPROTR_XSPI1SWP_Msk       (0x7UL << RCC_CKPROTR_XSPI1SWP_Pos)     /*!< 0x00000070 */
#define RCC_CKPROTR_XSPI1SWP_Pos       (4U)
#define RCC_CKPROTR_XSPI2SWP           RCC_CKPROTR_XSPI2SWP_Msk
#define RCC_CKPROTR_XSPI2SWP_2         (0x4UL << RCC_CKPROTR_XSPI2SWP_Pos)     /*!< 0x00000400 */
#define RCC_CKPROTR_XSPI2SWP_Msk       (0x7UL << RCC_CKPROTR_XSPI2SWP_Pos)     /*!< 0x00000700 */
#define RCC_CKPROTR_XSPI2SWP_Pos       (8U)
#define RCC_CKPROTR_XSPICKP            RCC_CKPROTR_XSPICKP_Msk
#define RCC_CKPROTR_XSPICKP_Msk        (0x1UL << RCC_CKPROTR_XSPICKP_Pos)      /*!< 0x00000001 */
#define RCC_CKPROTR_XSPICKP_Pos        (0U)
#define RCC_CR_CSIRDY                  RCC_CR_CSIRDY_Msk                       /*!< The Internal RC 4MHz oscillator clock ready */
#define RCC_CR_CSIRDY_Msk              (0x1UL << RCC_CR_CSIRDY_Pos)            /*!< 0x00000100 */
#define RCC_CR_CSIRDY_Pos              (8U)
#define RCC_CR_HSERDY                  RCC_CR_HSERDY_Msk                       /*!< External High Speed clock ready flag */
#define RCC_CR_HSERDY_Msk              (0x1UL << RCC_CR_HSERDY_Pos)            /*!< 0x00020000 */
#define RCC_CR_HSERDY_Pos              (17U)
#define RCC_CR_HSI48RDY                RCC_CR_HSI48RDY_Msk                     /*!< HSI48 clock ready flag */
#define RCC_CR_HSI48RDY_Msk            (0x1UL << RCC_CR_HSI48RDY_Pos)          /*!< 0x00002000 */
#define RCC_CR_HSI48RDY_Pos            (13U)
#define RCC_CR_HSIDIV                  RCC_CR_HSIDIV_Msk                       /*!< Internal High Speed clock divider selection */
#define RCC_CR_HSIDIVF                 RCC_CR_HSIDIVF_Msk                      /*!< HSI Divider flag */
#define RCC_CR_HSIDIVF_Msk             (0x1UL << RCC_CR_HSIDIVF_Pos)           /*!< 0x00000020 */
#define RCC_CR_HSIDIVF_Pos             (5U)
#define RCC_CR_HSIDIV_Msk              (0x3UL << RCC_CR_HSIDIV_Pos)            /*!< 0x00000018 */
#define RCC_CR_HSIDIV_Pos              (3U)
#define RCC_CR_HSIRDY                  RCC_CR_HSIRDY_Msk                       /*!< Internal High Speed clock ready flag */
#define RCC_CR_HSIRDY_Msk              (0x1UL << RCC_CR_HSIRDY_Pos)            /*!< 0x00000004 */
#define RCC_CR_HSIRDY_Pos              (2U)
#define RCC_CSR_LSIRDY                 RCC_CSR_LSIRDY_Msk
#define RCC_CSR_LSIRDY_Msk             (0x1UL << RCC_CSR_LSIRDY_Pos)           /*!< 0x00000002 */
#define RCC_CSR_LSIRDY_Pos             (1U)
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
#define RCC_PLLCFGR_PLL1PEN            RCC_PLLCFGR_PLL1PEN_Msk                 /*!< PLL1 DIVP divider output enable */
#define RCC_PLLCFGR_PLL1PEN_Msk        (0x1UL << RCC_PLLCFGR_PLL1PEN_Pos)      /*!< 0x00000020 */
#define RCC_PLLCFGR_PLL1PEN_Pos        (5U)
#define RCC_PLLCFGR_PLL1QEN            RCC_PLLCFGR_PLL1QEN_Msk                 /*!< PLL1 DIVQ divider output enable */
#define RCC_PLLCFGR_PLL1QEN_Msk        (0x1UL << RCC_PLLCFGR_PLL1QEN_Pos)      /*!< 0x00000040 */
#define RCC_PLLCFGR_PLL1QEN_Pos        (6U)
#define RCC_PLLCFGR_PLL1REN            RCC_PLLCFGR_PLL1REN_Msk                 /*!< PLL1 DIVR divider output enable */
#define RCC_PLLCFGR_PLL1REN_Msk        (0x1UL << RCC_PLLCFGR_PLL1REN_Pos)      /*!< 0x00000080 */
#define RCC_PLLCFGR_PLL1REN_Pos        (7U)
#define RCC_PLLCFGR_PLL1SEN            RCC_PLLCFGR_PLL1SEN_Msk                 /*!< PLL1 DIVS divider output enable */
#define RCC_PLLCFGR_PLL1SEN_Msk        (0x1UL << RCC_PLLCFGR_PLL1SEN_Pos)      /*!< 0x00000100 */
#define RCC_PLLCFGR_PLL1SEN_Pos        (8U)
#define RCC_PLLCFGR_PLL2FRACEN         RCC_PLLCFGR_PLL2FRACEN_Msk              /*!< PLL2 fractional latch enable */
#define RCC_PLLCFGR_PLL2FRACEN_Msk     (0x1UL << RCC_PLLCFGR_PLL2FRACEN_Pos)   /*!< 0x00000800 */
#define RCC_PLLCFGR_PLL2FRACEN_Pos     (11U)
#define RCC_PLLCFGR_PLL2PEN_Pos        (16U)
#define RCC_PLLCFGR_PLL3FRACEN         RCC_PLLCFGR_PLL3FRACEN_Msk              /*!< PLL3 fractional latch enable */
#define RCC_PLLCFGR_PLL3FRACEN_Msk     (0x1UL << RCC_PLLCFGR_PLL3FRACEN_Pos)   /*!< 0x00400000 */
#define RCC_PLLCFGR_PLL3FRACEN_Pos     (22U)
#define RCC_PLLCFGR_PLL3PEN_Pos        (27U)
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
#define RTC                    ((RTC_TypeDef *) RTC_BASE)
#define RTC_BASE                        (APB4PERIPH_BASE + 0x4000UL)
#define SAI1                   ((SAI_TypeDef *) SAI1_BASE)
#define SAI1_BASE                       (APB2PERIPH_BASE + 0x5800UL)
#define SAI2                   ((SAI_TypeDef *) SAI2_BASE)
#define SAI2_BASE                       (APB2PERIPH_BASE + 0x5C00UL)
#define SDMMC1                 ((SDMMC_TypeDef *) SDMMC1_BASE)
#define SDMMC1_BASE                     (AHB5PERIPH_BASE + 0x7000UL)
#define SDMMC2                 ((SDMMC_TypeDef *) SDMMC2_BASE)
#define SDMMC2_BASE                     (AHB2PERIPH_BASE + 0x2400UL)
#define SPDIFRX                ((SPDIFRX_TypeDef *) SPDIFRX_BASE)
#define SPDIFRX_BASE                    (APB1PERIPH_BASE + 0x4000UL)
#define SPI1                   ((SPI_TypeDef *) SPI1_BASE)
#define SPI1_BASE                       (APB2PERIPH_BASE + 0x3000UL)
#define SPI2                   ((SPI_TypeDef *) SPI2_BASE)
#define SPI2_BASE                       (APB1PERIPH_BASE + 0x3800UL)
#define SPI3                   ((SPI_TypeDef *) SPI3_BASE)
#define SPI3_BASE                       (APB1PERIPH_BASE + 0x3C00UL)
#define SPI4                   ((SPI_TypeDef *) SPI4_BASE)
#define SPI4_BASE                       (APB2PERIPH_BASE + 0x3400UL)
#define SPI5                   ((SPI_TypeDef *) SPI5_BASE)
#define SPI5_BASE                       (APB2PERIPH_BASE + 0x5000UL)
#define SPI6                   ((SPI_TypeDef *) SPI6_BASE)
#define SPI6_BASE                       (APB4PERIPH_BASE + 0x1400UL)
#define UART4                  ((USART_TypeDef *) UART4_BASE)
#define UART4_BASE                      (APB1PERIPH_BASE + 0x4C00UL)
#define UART5                  ((USART_TypeDef *) UART5_BASE)
#define UART5_BASE                      (APB1PERIPH_BASE + 0x5000UL)
#define UART7                  ((USART_TypeDef *) UART7_BASE)
#define UART7_BASE                      (APB1PERIPH_BASE + 0x7800UL)
#define UART8                  ((USART_TypeDef *) UART8_BASE)
#define UART8_BASE                      (APB1PERIPH_BASE + 0x7C00UL)
#define USART1                 ((USART_TypeDef *) USART1_BASE)
#define USART1_BASE                     (APB2PERIPH_BASE + 0x1000UL)
#define USART2                 ((USART_TypeDef *) USART2_BASE)
#define USART2_BASE                     (APB1PERIPH_BASE + 0x4400UL)
#define USART3                 ((USART_TypeDef *) USART3_BASE)
#define USART3_BASE                     (APB1PERIPH_BASE + 0x4800UL)
#define XSPI1                  ((XSPI_TypeDef *) XSPI1_R_BASE)
#define XSPI1_R_BASE                    (AHB5PERIPH_BASE + 0x5000UL)
#define XSPI2                  ((XSPI_TypeDef *) XSPI2_R_BASE)
#define XSPI2_R_BASE                    (AHB5PERIPH_BASE + 0xA000UL)

/* Additional unchanged CMSIS definitions used by the hardware-only model. */
#define RCC_BDCR_LSECSSD               RCC_BDCR_LSECSSD_Msk
#define RCC_BDCR_LSECSSD_Msk           (0x1UL << RCC_BDCR_LSECSSD_Pos)         /*!< 0x00000040 */
#define RCC_BDCR_LSECSSD_Pos           (6U)
#define RCC_BDCR_LSEON                 RCC_BDCR_LSEON_Msk
#define RCC_BDCR_LSEON_Msk             (0x1UL << RCC_BDCR_LSEON_Pos)           /*!< 0x00000001 */
#define RCC_BDCR_LSEON_Pos             (0U)
