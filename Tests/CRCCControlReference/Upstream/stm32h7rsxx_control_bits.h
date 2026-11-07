/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 * Unchanged layouts/bits extracted from CMSIS stm32h7s3xx.h at
 * 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
 * See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt. */
#pragma once
#define PERIPH_BASE                     0x40000000UL  /*!< AHB and APB Peripherals base address */
#define AHB5PERIPH_BASE                 (PERIPH_BASE + 0x12000000UL)
#define AHB4PERIPH_BASE                 (PERIPH_BASE + 0x18020000UL)
#define FLASH_R_BASE                    (AHB5PERIPH_BASE + 0x2000UL)
#define GPIOA_BASE                      AHB4PERIPH_BASE
#define GPIOC_BASE                      (AHB4PERIPH_BASE + 0x0800UL)
#define RCC_BASE                        (AHB4PERIPH_BASE + 0x4400UL)
#define PWR_BASE                        (AHB4PERIPH_BASE + 0x4800UL)
#define FLASH                  ((FLASH_TypeDef *) FLASH_R_BASE)
#define GPIOA                  ((GPIO_TypeDef *) GPIOA_BASE)
#define GPIOC                  ((GPIO_TypeDef *) GPIOC_BASE)
#define PWR                    ((PWR_TypeDef *) PWR_BASE)
#define RCC                    ((RCC_TypeDef *) RCC_BASE)
#define FLASH_ACR_LATENCY_Pos                (0U)
#define FLASH_ACR_LATENCY_Msk                (0xFUL << FLASH_ACR_LATENCY_Pos)                    /*!< 0x0000000F */
#define FLASH_ACR_LATENCY                    FLASH_ACR_LATENCY_Msk                               /*!< Read Latency */
#define FLASH_ACR_LATENCY_0                  (0x1UL << FLASH_ACR_LATENCY_Pos)                    /*!< 0x00000001 */
#define FLASH_ACR_LATENCY_1                  (0x2UL << FLASH_ACR_LATENCY_Pos)                    /*!< 0x00000002 */
#define FLASH_ACR_LATENCY_2                  (0x4UL << FLASH_ACR_LATENCY_Pos)                    /*!< 0x00000004 */
#define FLASH_ACR_WRHIGHFREQ_Pos             (4U)
#define FLASH_ACR_WRHIGHFREQ_Msk             (0x3UL << FLASH_ACR_WRHIGHFREQ_Pos)                 /*!< 0x00000030 */
#define FLASH_ACR_WRHIGHFREQ                 FLASH_ACR_WRHIGHFREQ_Msk                            /*!< Flash signal delay */
#define FLASH_ACR_WRHIGHFREQ_0               (0x1UL << FLASH_ACR_WRHIGHFREQ_Pos)                 /*!< 0x00000010 */
#define FLASH_ACR_WRHIGHFREQ_1               (0x2UL << FLASH_ACR_WRHIGHFREQ_Pos)                 /*!< 0x00000020 */
#define PWR_CR1_DBP_Pos                (8U)
#define PWR_CR1_DBP_Msk                (0x1UL << PWR_CR1_DBP_Pos)              /*!< 0x00000100 */
#define PWR_CR1_DBP                    PWR_CR1_DBP_Msk                         /*!< Disable Back-up domain Protection */
#define RCC_CR_HSION_Pos               (0U)
#define RCC_CR_HSION_Msk               (0x1UL << RCC_CR_HSION_Pos)             /*!< 0x00000001 */
#define RCC_CR_HSION                   RCC_CR_HSION_Msk                        /*!< Internal High Speed clock enable */
#define RCC_CR_HSIKERON_Pos            (1U)
#define RCC_CR_HSIKERON_Msk            (0x1UL << RCC_CR_HSIKERON_Pos)          /*!< 0x00000002 */
#define RCC_CR_HSIKERON                RCC_CR_HSIKERON_Msk                     /*!< Internal High Speed clock enable in Stop mode */
#define RCC_CR_HSIRDY_Pos              (2U)
#define RCC_CR_HSIRDY_Msk              (0x1UL << RCC_CR_HSIRDY_Pos)            /*!< 0x00000004 */
#define RCC_CR_HSIRDY                  RCC_CR_HSIRDY_Msk                       /*!< Internal High Speed clock ready flag */
#define RCC_CR_HSIDIV_Pos              (3U)
#define RCC_CR_HSIDIV_Msk              (0x3UL << RCC_CR_HSIDIV_Pos)            /*!< 0x00000018 */
#define RCC_CR_HSIDIV                  RCC_CR_HSIDIV_Msk                       /*!< Internal High Speed clock divider selection */
#define RCC_CR_HSIDIV_0                (0x1UL << RCC_CR_HSIDIV_Pos)            /*!< 0x00000008 */
#define RCC_CR_HSIDIV_1                (0x2UL << RCC_CR_HSIDIV_Pos)            /*!< 0x00000010 */
#define RCC_CR_HSIDIVF_Pos             (5U)
#define RCC_CR_HSIDIVF_Msk             (0x1UL << RCC_CR_HSIDIVF_Pos)           /*!< 0x00000020 */
#define RCC_CR_HSIDIVF                 RCC_CR_HSIDIVF_Msk                      /*!< HSI Divider flag */
#define RCC_CR_CSION_Pos               (7U)
#define RCC_CR_CSION_Msk               (0x1UL << RCC_CR_CSION_Pos)             /*!< 0x00000080 */
#define RCC_CR_CSION                   RCC_CR_CSION_Msk                        /*!< The Internal RC 4MHz oscillator clock enable */
#define RCC_CR_CSIRDY_Pos              (8U)
#define RCC_CR_CSIRDY_Msk              (0x1UL << RCC_CR_CSIRDY_Pos)            /*!< 0x00000100 */
#define RCC_CR_CSIRDY                  RCC_CR_CSIRDY_Msk                       /*!< The Internal RC 4MHz oscillator clock ready */
#define RCC_CR_CSIKERON_Pos            (9U)
#define RCC_CR_CSIKERON_Msk            (0x1UL << RCC_CR_CSIKERON_Pos)          /*!< 0x00000200 */
#define RCC_CR_CSIKERON                RCC_CR_CSIKERON_Msk                     /*!< Internal RC 4MHz oscillator clock enable in Stop mode */
#define RCC_CR_HSI48ON_Pos             (12U)
#define RCC_CR_HSI48ON_Msk             (0x1UL << RCC_CR_HSI48ON_Pos)           /*!< 0x00001000 */
#define RCC_CR_HSI48ON                 RCC_CR_HSI48ON_Msk                      /*!< HSI48 clock enable clock enable  */
#define RCC_CR_HSI48RDY_Pos            (13U)
#define RCC_CR_HSI48RDY_Msk            (0x1UL << RCC_CR_HSI48RDY_Pos)          /*!< 0x00002000 */
#define RCC_CR_HSI48RDY                RCC_CR_HSI48RDY_Msk                     /*!< HSI48 clock ready flag */
#define RCC_CR_HSEON_Pos               (16U)
#define RCC_CR_HSEON_Msk               (0x1UL << RCC_CR_HSEON_Pos)             /*!< 0x00010000 */
#define RCC_CR_HSEON                   RCC_CR_HSEON_Msk                        /*!< External High Speed clock enable */
#define RCC_CR_HSERDY_Pos              (17U)
#define RCC_CR_HSERDY_Msk              (0x1UL << RCC_CR_HSERDY_Pos)            /*!< 0x00020000 */
#define RCC_CR_HSERDY                  RCC_CR_HSERDY_Msk                       /*!< External High Speed clock ready flag */
#define RCC_CR_HSEBYP_Pos              (18U)
#define RCC_CR_HSEBYP_Msk              (0x1UL << RCC_CR_HSEBYP_Pos)            /*!< 0x00040000 */
#define RCC_CR_HSEBYP                  RCC_CR_HSEBYP_Msk                       /*!< External High Speed clock bypass */
#define RCC_CR_HSEEXT_Pos              (19U)
#define RCC_CR_HSEEXT_Msk              (0x1UL << RCC_CR_HSEEXT_Pos)            /*!< 0x00100000 */
#define RCC_CR_HSEEXT                  RCC_CR_HSEEXT_Msk                       /*!< External High Speed clock type in bypass mode */
#define RCC_CR_HSECSSON_Pos            (20U)
#define RCC_CR_HSECSSON_Msk            (0x1UL << RCC_CR_HSECSSON_Pos)          /*!< 0x00080000 */
#define RCC_CR_HSECSSON                RCC_CR_HSECSSON_Msk                     /*!< HSE Clock security System enable */
#define RCC_CR_PLL1ON_Pos              (24U)
#define RCC_CR_PLL1ON_Msk              (0x1UL << RCC_CR_PLL1ON_Pos)            /*!< 0x01000000 */
#define RCC_CR_PLL1ON                  RCC_CR_PLL1ON_Msk                       /*!< System PLL1 clock enable */
#define RCC_CR_PLL1RDY_Pos             (25U)
#define RCC_CR_PLL1RDY_Msk             (0x1UL << RCC_CR_PLL1RDY_Pos)           /*!< 0x02000000 */
#define RCC_CR_PLL1RDY                 RCC_CR_PLL1RDY_Msk                      /*!< System PLL1 clock ready flag */
#define RCC_CR_PLL2ON_Pos              (26U)
#define RCC_CR_PLL2ON_Msk              (0x1UL << RCC_CR_PLL2ON_Pos)            /*!< 0x04000000 */
#define RCC_CR_PLL2ON                  RCC_CR_PLL2ON_Msk                       /*!< System PLL2 clock enable */
#define RCC_CR_PLL2RDY_Pos             (27U)
#define RCC_CR_PLL2RDY_Msk             (0x1UL << RCC_CR_PLL2RDY_Pos)           /*!< 0x08000000 */
#define RCC_CR_PLL2RDY                 RCC_CR_PLL2RDY_Msk                      /*!< System PLL2 clock ready flag */
#define RCC_CR_PLL3ON_Pos              (28U)
#define RCC_CR_PLL3ON_Msk              (0x1UL << RCC_CR_PLL3ON_Pos)            /*!< 0x10000000 */
#define RCC_CR_PLL3ON                  RCC_CR_PLL3ON_Msk                       /*!< System PLL3 clock enable */
#define RCC_CR_PLL3RDY_Pos             (29U)
#define RCC_CR_PLL3RDY_Msk             (0x1UL << RCC_CR_PLL3RDY_Pos)           /*!< 0x20000000 */
#define RCC_CR_PLL3RDY                 RCC_CR_PLL3RDY_Msk                      /*!< System PLL3 clock ready flag */
#define RCC_HSICFGR_HSITRIM_Pos        (24U)
#define RCC_HSICFGR_HSITRIM_Msk        (0x7FUL << RCC_HSICFGR_HSITRIM_Pos)     /*!< 0x7F000000 */
#define RCC_HSICFGR_HSITRIM            RCC_HSICFGR_HSITRIM_Msk                 /*!< HSITRIM[6:0] bits */
#define RCC_HSICFGR_HSITRIM_6          (0x40UL << RCC_HSICFGR_HSITRIM_Pos)     /*!< 0x40000000 */
#define RCC_CFGR_SW_Pos                (0U)
#define RCC_CFGR_SW_Msk                (0x7UL << RCC_CFGR_SW_Pos)              /*!< 0x00000007 */
#define RCC_CFGR_SW                    RCC_CFGR_SW_Msk                         /*!< SW[2:0] bits (System clock switch) */
#define RCC_CFGR_SW_0                  (0x1UL << RCC_CFGR_SW_Pos)              /*!< 0x00000001 */
#define RCC_CFGR_SW_1                  (0x2UL << RCC_CFGR_SW_Pos)              /*!< 0x00000002 */
#define RCC_CFGR_SWS_Pos               (3U)
#define RCC_CFGR_SWS_Msk               (0x7UL << RCC_CFGR_SWS_Pos)             /*!< 0x00000038 */
#define RCC_CFGR_SWS                   RCC_CFGR_SWS_Msk                        /*!< SWS[2:0] bits (System clock switch status) */
#define RCC_CFGR_SWS_0                 (0x1UL << RCC_CFGR_SWS_Pos)             /*!< 0x00000008 */
#define RCC_CFGR_SWS_1                 (0x2UL << RCC_CFGR_SWS_Pos)             /*!< 0x00000010 */
#define RCC_CFGR_MCO1PRE_Pos           (18U)
#define RCC_CFGR_MCO1PRE_Msk           (0xFUL << RCC_CFGR_MCO1PRE_Pos)         /*!< 0x003C0000 */
#define RCC_CFGR_MCO1PRE               RCC_CFGR_MCO1PRE_Msk                    /*!< MCO1 configuration */
#define RCC_CFGR_MCO1PRE_0             (0x1UL << RCC_CFGR_MCO1PRE_Pos)         /*!< 0x00040000 */
#define RCC_CFGR_MCO1PRE_1             (0x2UL << RCC_CFGR_MCO1PRE_Pos)         /*!< 0x00080000 */
#define RCC_CFGR_MCO1PRE_2             (0x4UL << RCC_CFGR_MCO1PRE_Pos)         /*!< 0x00100000 */
#define RCC_CFGR_MCO1PRE_3             (0x8UL << RCC_CFGR_MCO1PRE_Pos)         /*!< 0x00200000 */
#define RCC_CFGR_MCO1SEL_Pos           (22U)
#define RCC_CFGR_MCO1SEL_Msk           (0x7UL << RCC_CFGR_MCO1SEL_Pos)         /*!< 0x01C00000 */
#define RCC_CFGR_MCO1SEL               RCC_CFGR_MCO1SEL_Msk                    /*!< MCO1SEL [2:0] bits (MCO1 clock output selection) */
#define RCC_CFGR_MCO1SEL_0             (0x1UL <<  RCC_CFGR_MCO1SEL_Pos)        /*!< 0x00400000 */
#define RCC_CFGR_MCO1SEL_1             (0x2UL <<  RCC_CFGR_MCO1SEL_Pos)        /*!< 0x00800000 */
#define RCC_CFGR_MCO1SEL_2             (0x4UL <<  RCC_CFGR_MCO1SEL_Pos)        /*!< 0x01000000 */
#define RCC_CFGR_MCO2PRE_Pos           (25U)
#define RCC_CFGR_MCO2PRE_Msk           (0xFUL << RCC_CFGR_MCO2PRE_Pos)         /*!< 0x1E000000 */
#define RCC_CFGR_MCO2PRE               RCC_CFGR_MCO2PRE_Msk                    /*!< MCO2 configuration */
#define RCC_CFGR_MCO2SEL_Pos           (29U)
#define RCC_CFGR_MCO2SEL_Msk           (0x7UL << RCC_CFGR_MCO2SEL_Pos)         /*!< 0xE0000000 */
#define RCC_CFGR_MCO2SEL               RCC_CFGR_MCO2SEL_Msk                    /*!< MCO2SEL [2:0] bits (MCO2 clock output selection) */
#define RCC_CFGR_MCO2SEL_0             (0x1UL << RCC_CFGR_MCO2SEL_Pos)         /*!< 0x20000000 */
#define RCC_CFGR_MCO2SEL_1             (0x2UL << RCC_CFGR_MCO2SEL_Pos)         /*!< 0x40000000 */
#define RCC_CFGR_MCO2SEL_2             (0x4UL << RCC_CFGR_MCO2SEL_Pos)         /*!< 0x80000000 */
#define RCC_CDCFGR_CPRE_Pos            (0U)
#define RCC_CDCFGR_CPRE_Msk            (0xFUL << RCC_CDCFGR_CPRE_Pos)          /*!< 0x0000000F */
#define RCC_CDCFGR_CPRE                RCC_CDCFGR_CPRE_Msk                     /*!< CPRE[3:0] bits */
#define RCC_CDCFGR_CPRE_0              (0x1UL << RCC_CDCFGR_CPRE_Pos)          /*!< 0x00000001 */
#define RCC_CDCFGR_CPRE_1              (0x2UL << RCC_CDCFGR_CPRE_Pos)          /*!< 0x00000002 */
#define RCC_CDCFGR_CPRE_2              (0x4UL << RCC_CDCFGR_CPRE_Pos)          /*!< 0x00000004 */
#define RCC_CDCFGR_CPRE_3              (0x8UL << RCC_CDCFGR_CPRE_Pos)          /*!< 0x00000008 */
#define RCC_BMCFGR_BMPRE_Pos           (0U)
#define RCC_BMCFGR_BMPRE_Msk           (0xFUL << RCC_BMCFGR_BMPRE_Pos)         /*!< 0x0000000F */
#define RCC_BMCFGR_BMPRE               RCC_BMCFGR_BMPRE_Msk                    /*!< BMPRE[3:0] bits */
#define RCC_BMCFGR_BMPRE_0             (0x1UL << RCC_BMCFGR_BMPRE_Pos)         /*!< 0x00000001 */
#define RCC_BMCFGR_BMPRE_1             (0x2UL << RCC_BMCFGR_BMPRE_Pos)         /*!< 0x00000002 */
#define RCC_BMCFGR_BMPRE_2             (0x4UL << RCC_BMCFGR_BMPRE_Pos)         /*!< 0x00000004 */
#define RCC_BMCFGR_BMPRE_3             (0x8UL << RCC_BMCFGR_BMPRE_Pos)         /*!< 0x00000008 */
#define RCC_APBCFGR_PPRE1_Pos          (0U)
#define RCC_APBCFGR_PPRE1_Msk          (0x7UL << RCC_APBCFGR_PPRE1_Pos)        /*!< 0x00000007 */
#define RCC_APBCFGR_PPRE1              RCC_APBCFGR_PPRE1_Msk                   /*!< PPRE1[2:0] bits */
#define RCC_APBCFGR_PPRE1_0            (0x1UL << RCC_APBCFGR_PPRE1_Pos)        /*!< 0x00000001 */
#define RCC_APBCFGR_PPRE1_1            (0x2UL << RCC_APBCFGR_PPRE1_Pos)        /*!< 0x00000002 */
#define RCC_APBCFGR_PPRE1_2            (0x4UL << RCC_APBCFGR_PPRE1_Pos)        /*!< 0x00000004 */
#define RCC_APBCFGR_PPRE2_Pos          (4U)
#define RCC_APBCFGR_PPRE2_Msk          (0x7UL << RCC_APBCFGR_PPRE2_Pos)        /*!< 0x00000070 */
#define RCC_APBCFGR_PPRE2              RCC_APBCFGR_PPRE2_Msk                   /*!< PPRE2[2:0] bits */
#define RCC_APBCFGR_PPRE2_0            (0x1UL << RCC_APBCFGR_PPRE2_Pos)        /*!< 0x00000010 */
#define RCC_APBCFGR_PPRE2_1            (0x2UL << RCC_APBCFGR_PPRE2_Pos)        /*!< 0x00000020 */
#define RCC_APBCFGR_PPRE2_2            (0x4UL << RCC_APBCFGR_PPRE2_Pos)        /*!< 0x00000040 */
#define RCC_APBCFGR_PPRE4_Pos          (8U)
#define RCC_APBCFGR_PPRE4_Msk          (0x7UL << RCC_APBCFGR_PPRE4_Pos)        /*!< 0x00000700 */
#define RCC_APBCFGR_PPRE4              RCC_APBCFGR_PPRE4_Msk                   /*!< PPRE4[2:0] bits */
#define RCC_APBCFGR_PPRE4_0            (0x1UL << RCC_APBCFGR_PPRE4_Pos)        /*!< 0x00000100 */
#define RCC_APBCFGR_PPRE4_1            (0x2UL << RCC_APBCFGR_PPRE4_Pos)        /*!< 0x00000200 */
#define RCC_APBCFGR_PPRE4_2            (0x4UL << RCC_APBCFGR_PPRE4_Pos)        /*!< 0x00000400 */
#define RCC_APBCFGR_PPRE5_Pos          (12U)
#define RCC_APBCFGR_PPRE5_Msk          (0x7UL << RCC_APBCFGR_PPRE5_Pos)        /*!< 0x00007000 */
#define RCC_APBCFGR_PPRE5              RCC_APBCFGR_PPRE5_Msk                   /*!< PPRE5[2:0] bits */
#define RCC_APBCFGR_PPRE5_0            (0x1UL << RCC_APBCFGR_PPRE5_Pos)        /*!< 0x00001000 */
#define RCC_APBCFGR_PPRE5_1            (0x2UL << RCC_APBCFGR_PPRE5_Pos)        /*!< 0x00002000 */
#define RCC_APBCFGR_PPRE5_2            (0x4UL << RCC_APBCFGR_PPRE5_Pos)        /*!< 0x00004000 */
#define RCC_PLLCKSELR_PLLSRC_Pos       (0U)
#define RCC_PLLCKSELR_PLLSRC_Msk       (0x3UL << RCC_PLLCKSELR_PLLSRC_Pos)     /*!< 0x00000003 */
#define RCC_PLLCKSELR_PLLSRC           RCC_PLLCKSELR_PLLSRC_Msk                /*!< DIVMx and PLLs clock source selection */
#define RCC_PLLCKSELR_PLLSRC_0         (0x01UL << RCC_PLLCKSELR_PLLSRC_Pos)    /*!< 0x00000010 */
#define RCC_PLLCKSELR_PLLSRC_1         (0x02UL << RCC_PLLCKSELR_PLLSRC_Pos)    /*!< 0x00000020 */
#define RCC_PLLCKSELR_DIVM1_Pos        (4U)
#define RCC_PLLCKSELR_DIVM1_Msk        (0x3FUL << RCC_PLLCKSELR_DIVM1_Pos)     /*!< 0x000003F0 */
#define RCC_PLLCKSELR_DIVM1            RCC_PLLCKSELR_DIVM1_Msk                 /*!< DIVM1[5:0] bits */
#define RCC_PLLCKSELR_DIVM2_Pos        (12U)
#define RCC_PLLCKSELR_DIVM2_Msk        (0x3FUL << RCC_PLLCKSELR_DIVM2_Pos)     /*!< 0x0003F000 */
#define RCC_PLLCKSELR_DIVM2            RCC_PLLCKSELR_DIVM2_Msk                 /*!< DIVM2[5:0] bits */
#define RCC_PLLCKSELR_DIVM3_Pos        (20U)
#define RCC_PLLCKSELR_DIVM3_Msk        (0x3FUL << RCC_PLLCKSELR_DIVM3_Pos)     /*!< 0x03F00000 */
#define RCC_PLLCKSELR_DIVM3            RCC_PLLCKSELR_DIVM3_Msk                 /*!< DIVM3[5:0] bits */
#define RCC_PLLCFGR_PLL1FRACEN_Pos     (0U)
#define RCC_PLLCFGR_PLL1FRACEN_Msk     (0x1UL << RCC_PLLCFGR_PLL1FRACEN_Pos)   /*!< 0x00000001 */
#define RCC_PLLCFGR_PLL1FRACEN         RCC_PLLCFGR_PLL1FRACEN_Msk              /*!< PLL1 fractional latch enable */
#define RCC_PLLCFGR_PLL1VCOSEL_Pos     (1U)
#define RCC_PLLCFGR_PLL1VCOSEL_Msk     (0x1UL << RCC_PLLCFGR_PLL1VCOSEL_Pos)   /*!< 0x00000002 */
#define RCC_PLLCFGR_PLL1VCOSEL         RCC_PLLCFGR_PLL1VCOSEL_Msk              /*!< PLL1 VCO selection */
#define RCC_PLLCFGR_PLL1RGE_Pos        (3U)
#define RCC_PLLCFGR_PLL1RGE_Msk        (0x3UL << RCC_PLLCFGR_PLL1RGE_Pos)      /*!< 0x00000018 */
#define RCC_PLLCFGR_PLL1RGE            RCC_PLLCFGR_PLL1RGE_Msk                 /*!< PLL1RGE[1:0] bits: PLL1 input frequency range */
#define RCC_PLLCFGR_PLL1RGE_0          (0x1UL << RCC_PLLCFGR_PLL1RGE_Pos)      /*!< 0x00000008 */
#define RCC_PLLCFGR_PLL1RGE_1          (0x2UL << RCC_PLLCFGR_PLL1RGE_Pos)      /*!< 0x00000010 */
#define RCC_PLLCFGR_PLL1PEN_Pos        (5U)
#define RCC_PLLCFGR_PLL1PEN_Msk        (0x1UL << RCC_PLLCFGR_PLL1PEN_Pos)      /*!< 0x00000020 */
#define RCC_PLLCFGR_PLL1PEN            RCC_PLLCFGR_PLL1PEN_Msk                 /*!< PLL1 DIVP divider output enable */
#define RCC_PLLCFGR_PLL1QEN_Pos        (6U)
#define RCC_PLLCFGR_PLL1QEN_Msk        (0x1UL << RCC_PLLCFGR_PLL1QEN_Pos)      /*!< 0x00000040 */
#define RCC_PLLCFGR_PLL1QEN            RCC_PLLCFGR_PLL1QEN_Msk                 /*!< PLL1 DIVQ divider output enable */
#define RCC_PLLCFGR_PLL1REN_Pos        (7U)
#define RCC_PLLCFGR_PLL1REN_Msk        (0x1UL << RCC_PLLCFGR_PLL1REN_Pos)      /*!< 0x00000080 */
#define RCC_PLLCFGR_PLL1REN            RCC_PLLCFGR_PLL1REN_Msk                 /*!< PLL1 DIVR divider output enable */
#define RCC_PLLCFGR_PLL1SEN_Pos        (8U)
#define RCC_PLLCFGR_PLL1SEN_Msk        (0x1UL << RCC_PLLCFGR_PLL1SEN_Pos)      /*!< 0x00000100 */
#define RCC_PLLCFGR_PLL1SEN            RCC_PLLCFGR_PLL1SEN_Msk                 /*!< PLL1 DIVS divider output enable */
#define RCC_PLLCFGR_PLL2FRACEN_Pos     (11U)
#define RCC_PLLCFGR_PLL2FRACEN_Msk     (0x1UL << RCC_PLLCFGR_PLL2FRACEN_Pos)   /*!< 0x00000800 */
#define RCC_PLLCFGR_PLL2FRACEN         RCC_PLLCFGR_PLL2FRACEN_Msk              /*!< PLL2 fractional latch enable */
#define RCC_PLLCFGR_PLL2RGE_Pos        (14U)
#define RCC_PLLCFGR_PLL2PEN_Pos        (16U)
#define RCC_PLLCFGR_PLL3FRACEN_Pos     (22U)
#define RCC_PLLCFGR_PLL3FRACEN_Msk     (0x1UL << RCC_PLLCFGR_PLL3FRACEN_Pos)   /*!< 0x00400000 */
#define RCC_PLLCFGR_PLL3FRACEN         RCC_PLLCFGR_PLL3FRACEN_Msk              /*!< PLL3 fractional latch enable */
#define RCC_PLL1DIVR1_DIVN_Pos        (0U)
#define RCC_PLL1DIVR1_DIVN_Msk        (0x1FFUL << RCC_PLL1DIVR1_DIVN_Pos)    /*!< 0x000001FF */
#define RCC_PLL1DIVR1_DIVN            RCC_PLL1DIVR1_DIVN_Msk                 /*!< DIVN1[8:0] bits: PLL1 DIVN division factor */
#define RCC_PLL1DIVR1_DIVP_Pos        (9U)
#define RCC_PLL1DIVR1_DIVP_Msk        (0x7FUL << RCC_PLL1DIVR1_DIVP_Pos)     /*!< 0x0000FE00 */
#define RCC_PLL1DIVR1_DIVP            RCC_PLL1DIVR1_DIVP_Msk                 /*!< DIVP1[6:0] bits: PLL1 DIVP division factor */
#define RCC_PLL1DIVR1_DIVQ_Pos        (16U)
#define RCC_PLL1DIVR1_DIVQ_Msk        (0x7FUL << RCC_PLL1DIVR1_DIVQ_Pos)     /*!< 0x007F0000 */
#define RCC_PLL1DIVR1_DIVQ            RCC_PLL1DIVR1_DIVQ_Msk                 /*!< DIVQ1[6:0] bits: PLL1 DIVQ division factor */
#define RCC_PLL1DIVR1_DIVR_Pos        (24U)
#define RCC_PLL1DIVR1_DIVR_Msk        (0x7FUL << RCC_PLL1DIVR1_DIVR_Pos)     /*!< 0x7F000000 */
#define RCC_PLL1DIVR1_DIVR            RCC_PLL1DIVR1_DIVR_Msk                 /*!< DIVR1[6:0] bits: PLL1 DIVR division factor */
#define RCC_PLL1FRACR_FRACN_Pos        (3U)
#define RCC_PLL1FRACR_FRACN_Msk        (0x1FFFUL << RCC_PLL1FRACR_FRACN_Pos) /*!< 0x0000FFF8 */
#define RCC_PLL1FRACR_FRACN            RCC_PLL1FRACR_FRACN_Msk               /*!< FRACN[12:0] bits */
#define RCC_PLL2DIVR1_DIVN_Pos        (0U)
#define RCC_PLL2DIVR1_DIVN_Msk        (0x1FFUL << RCC_PLL2DIVR1_DIVN_Pos)    /*!< 0x000001FF */
#define RCC_PLL2DIVR1_DIVN            RCC_PLL2DIVR1_DIVN_Msk                 /*!< DIVN2[8:0] bits: PLL2 DIVN division factor */
#define RCC_PLL2DIVR1_DIVP_Pos        (9U)
#define RCC_PLL2DIVR1_DIVP_Msk        (0x7FUL << RCC_PLL2DIVR1_DIVP_Pos)     /*!< 0x0000FE00 */
#define RCC_PLL2DIVR1_DIVP            RCC_PLL2DIVR1_DIVP_Msk                 /*!< DIVP2[6:0] bits: PLL2 DIVP division factor */
#define RCC_PLL2DIVR1_DIVQ_Pos        (16U)
#define RCC_PLL2DIVR1_DIVQ_Msk        (0x7FUL << RCC_PLL2DIVR1_DIVQ_Pos)     /*!< 0x007F0000 */
#define RCC_PLL2DIVR1_DIVQ            RCC_PLL2DIVR1_DIVQ_Msk                 /*!< DIVQ2[6:0] bits: PLL2 DIVQ division factor */
#define RCC_PLL2DIVR1_DIVR_Pos        (24U)
#define RCC_PLL2DIVR1_DIVR_Msk        (0x7FUL << RCC_PLL2DIVR1_DIVR_Pos)     /*!< 0x7F000000 */
#define RCC_PLL2DIVR1_DIVR            RCC_PLL2DIVR1_DIVR_Msk                 /*!< DIVR2[6:0] bits: PLL2 DIVR division factor */
#define RCC_PLL2FRACR_FRACN_Pos        (3U)
#define RCC_PLL2FRACR_FRACN_Msk        (0x1FFFUL << RCC_PLL2FRACR_FRACN_Pos) /*!< 0x0000FFF8 */
#define RCC_PLL2FRACR_FRACN            RCC_PLL2FRACR_FRACN_Msk               /*!< FRACN[12:0] bits */
#define RCC_PLL3DIVR1_DIVN_Pos        (0U)
#define RCC_PLL3DIVR1_DIVN_Msk        (0x1FFUL << RCC_PLL3DIVR1_DIVN_Pos)    /*!< 0x000001FF */
#define RCC_PLL3DIVR1_DIVN            RCC_PLL3DIVR1_DIVN_Msk                 /*!< DIVN3[8:0] bits: PLL3 DIVN division factor */
#define RCC_PLL3DIVR1_DIVP_Pos        (9U)
#define RCC_PLL3DIVR1_DIVP_Msk        (0x7FUL << RCC_PLL3DIVR1_DIVP_Pos)     /*!< 0x0000FE00 */
#define RCC_PLL3DIVR1_DIVP            RCC_PLL3DIVR1_DIVP_Msk                 /*!< DIVP3[6:0] bits: PLL3 DIVP division factor */
#define RCC_PLL3DIVR1_DIVQ_Pos        (16U)
#define RCC_PLL3DIVR1_DIVQ_Msk        (0x7FUL << RCC_PLL3DIVR1_DIVQ_Pos)     /*!< 0x007F0000 */
#define RCC_PLL3DIVR1_DIVQ            RCC_PLL3DIVR1_DIVQ_Msk                 /*!< DIVQ3[6:0] bits: PLL3 DIVQ division factor */
#define RCC_PLL3DIVR1_DIVR_Pos        (24U)
#define RCC_PLL3DIVR1_DIVR_Msk        (0x7FUL << RCC_PLL3DIVR1_DIVR_Pos)     /*!< 0x7F000000 */
#define RCC_PLL3DIVR1_DIVR            RCC_PLL3DIVR1_DIVR_Msk                 /*!< DIVR3[6:0] bits: PLL3 DIVR division factor */
#define RCC_PLL3FRACR_FRACN_Pos        (3U)
#define RCC_PLL3FRACR_FRACN_Msk        (0x1FFFUL << RCC_PLL3FRACR_FRACN_Pos) /*!< 0x0000FFF8 */
#define RCC_PLL3FRACR_FRACN            RCC_PLL3FRACR_FRACN_Msk               /*!< FRACN[12:0] bits */
#define RCC_CIFR_HSECSSF_Pos           (10U)
#define RCC_CIFR_HSECSSF_Msk           (0x1UL << RCC_CIFR_HSECSSF_Pos)         /*!< 0x00000400 */
#define RCC_CIFR_HSECSSF               RCC_CIFR_HSECSSF_Msk
#define RCC_BDCR_LSEON_Pos             (0U)
#define RCC_BDCR_LSEON_Msk             (0x1UL << RCC_BDCR_LSEON_Pos)           /*!< 0x00000001 */
#define RCC_BDCR_LSEON                 RCC_BDCR_LSEON_Msk
#define RCC_BDCR_LSERDY_Pos            (1U)
#define RCC_BDCR_LSERDY_Msk            (0x1UL << RCC_BDCR_LSERDY_Pos)          /*!< 0x00000002 */
#define RCC_BDCR_LSERDY                RCC_BDCR_LSERDY_Msk
#define RCC_BDCR_LSEBYP_Pos            (2U)
#define RCC_BDCR_LSEBYP_Msk            (0x1UL << RCC_BDCR_LSEBYP_Pos)          /*!< 0x00000004 */
#define RCC_BDCR_LSEBYP                RCC_BDCR_LSEBYP_Msk
#define RCC_BDCR_LSEEXT_Pos            (7U)
#define RCC_BDCR_LSEEXT_Msk            (0x1UL << RCC_BDCR_LSEEXT_Pos)          /*!< 0x00000080 */
#define RCC_BDCR_LSEEXT                RCC_BDCR_LSEEXT_Msk
#define RCC_CSR_LSION_Pos              (0U)
#define RCC_CSR_LSION_Msk              (0x1UL << RCC_CSR_LSION_Pos)            /*!< 0x00000001 */
#define RCC_CSR_LSION                  RCC_CSR_LSION_Msk
#define RCC_CSR_LSIRDY_Pos             (1U)
#define RCC_CSR_LSIRDY_Msk             (0x1UL << RCC_CSR_LSIRDY_Pos)           /*!< 0x00000002 */
#define RCC_CSR_LSIRDY                 RCC_CSR_LSIRDY_Msk
#define RCC_PLL1DIVR2_DIVS_Pos        (0U)
#define RCC_PLL1DIVR2_DIVS_Msk        (0x7UL << RCC_PLL1DIVR2_DIVS_Pos)      /*!< 0x00000007 */
#define RCC_PLL1DIVR2_DIVS            RCC_PLL1DIVR2_DIVS_Msk                 /*!< DIVS1[2:0] bits: PLL1 DIVS division factor */
#define RCC_PLL2DIVR2_DIVS_Pos        (0U)
#define RCC_PLL2DIVR2_DIVS_Msk        (0x7UL << RCC_PLL2DIVR2_DIVS_Pos)      /*!< 0x00000007 */
#define RCC_PLL2DIVR2_DIVS            RCC_PLL2DIVR2_DIVS_Msk                 /*!< DIVS2[2:0] bits: PLL2 DIVS division factor */
#define RCC_PLL2DIVR2_DIVT_Pos        (8U)
#define RCC_PLL2DIVR2_DIVT_Msk        (0x7UL << RCC_PLL2DIVR2_DIVT_Pos)      /*!< 0x00000700 */
#define RCC_PLL2DIVR2_DIVT            RCC_PLL2DIVR2_DIVT_Msk                 /*!< DIVT2[2:0] bits: PLL2 DIVT division factor */
#define RCC_PLL3DIVR2_DIVS_Pos        (0U)
#define RCC_PLL3DIVR2_DIVS_Msk        (0x7UL << RCC_PLL3DIVR2_DIVS_Pos)      /*!< 0x00000007 */
#define RCC_PLL3DIVR2_DIVS            RCC_PLL3DIVR2_DIVS_Msk                 /*!< DIVS3[2:0] bits: PLL3 DIVS division factor */
#define RCC_RSR_RMVF_Pos               (16U)
#define RCC_RSR_RMVF_Msk               (0x1UL << RCC_RSR_RMVF_Pos)             /*!< 0x00010000 */
#define RCC_RSR_RMVF                   RCC_RSR_RMVF_Msk
#define RCC_RSR_OBLRSTF_Pos            (17U)
#define RCC_RSR_OBLRSTF_Msk            (0x1UL << RCC_RSR_OBLRSTF_Pos)          /*!< 0x00020000 */
#define RCC_RSR_OBLRSTF                RCC_RSR_OBLRSTF_Msk
#define RCC_RSR_BORRSTF_Pos            (21U)
#define RCC_RSR_BORRSTF_Msk            (0x1UL << RCC_RSR_BORRSTF_Pos)          /*!< 0x00200000 */
#define RCC_RSR_BORRSTF                RCC_RSR_BORRSTF_Msk
#define RCC_RSR_PINRSTF_Pos            (22U)
#define RCC_RSR_PINRSTF_Msk            (0x1UL << RCC_RSR_PINRSTF_Pos)          /*!< 0x00400000 */
#define RCC_RSR_PINRSTF                RCC_RSR_PINRSTF_Msk
#define RCC_RSR_SFTRSTF_Pos            (24U)
#define RCC_RSR_SFTRSTF_Msk            (0x1UL << RCC_RSR_SFTRSTF_Pos)          /*!< 0x01000000 */
#define RCC_RSR_SFTRSTF                RCC_RSR_SFTRSTF_Msk
#define RCC_RSR_IWDGRSTF_Pos           (26U)
#define RCC_RSR_IWDGRSTF_Msk           (0x1UL << RCC_RSR_IWDGRSTF_Pos)         /*!< 0x04000000 */
#define RCC_RSR_IWDGRSTF               RCC_RSR_IWDGRSTF_Msk
#define RCC_RSR_WWDGRSTF_Pos           (28U)
#define RCC_RSR_WWDGRSTF_Msk           (0x1UL << RCC_RSR_WWDGRSTF_Pos)         /*!< 0x10000000 */
#define RCC_RSR_WWDGRSTF               RCC_RSR_WWDGRSTF_Msk
#define RCC_RSR_LPWRRSTF_Pos           (30U)
#define RCC_RSR_LPWRRSTF_Msk           (0x1UL << RCC_RSR_LPWRRSTF_Pos)         /*!< 0x40000000 */
#define RCC_RSR_LPWRRSTF               RCC_RSR_LPWRRSTF_Msk
