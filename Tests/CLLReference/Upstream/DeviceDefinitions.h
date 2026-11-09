// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// Extracted from CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
#pragma once
#include <stdint.h>
#define __IO volatile
#define __I volatile const
#define __O volatile
typedef struct
{
  __IO uint32_t MODER;         /*!< GPIO port mode register,               Address offset: 0x00      */
  __IO uint32_t OTYPER;        /*!< GPIO port output type register,        Address offset: 0x04      */
  __IO uint32_t OSPEEDR;       /*!< GPIO port output speed register,       Address offset: 0x08      */
  __IO uint32_t PUPDR;         /*!< GPIO port pull-up/pull-down register,  Address offset: 0x0C      */
  __IO uint32_t IDR;           /*!< GPIO port input data register,         Address offset: 0x10      */
  __IO uint32_t ODR;           /*!< GPIO port output data register,        Address offset: 0x14      */
  __IO uint32_t BSRR;          /*!< GPIO port bit set/reset  register,     Address offset: 0x18      */
  __IO uint32_t LCKR;          /*!< GPIO port configuration lock register, Address offset: 0x1C      */
  __IO uint32_t AFR[2];        /*!< GPIO alternate function registers,     Address offset: 0x20-0x24 */
  __IO uint32_t BRR;           /*!< GPIO Bit Reset register,               Address offset: 0x28      */
} GPIO_TypeDef;
typedef struct
{
  __IO uint32_t RTSR1;         /*!< EXTI Rising trigger selection register 1,         Address offset: 0x00 */
  __IO uint32_t FTSR1;         /*!< EXTI Falling trigger selection register 1,        Address offset: 0x04 */
  __IO uint32_t SWIER1;        /*!< EXTI Software interrupt event register 1,         Address offset: 0x08 */
       uint32_t RESERVED1[5];  /*!< Reserved 1,                                  Address offset: 0x0C-0x1C */
  __IO uint32_t RTSR2;         /*!< EXTI Rising trigger selection register 2,         Address offset: 0x20 */
  __IO uint32_t FTSR2;         /*!< EXTI Falling trigger selection register 2,        Address offset: 0x24 */
  __IO uint32_t SWIER2;        /*!< EXTI Software interrupt event register 2,         Address offset: 0x28 */
       uint32_t RESERVED2[21]; /*!< Reserved 2,                                  Address offset: 0x2C-0x7C */
  __IO uint32_t IMR1;          /*!< EXTI Interrupt mask register 1,                   Address offset: 0x80 */
  __IO uint32_t EMR1;          /*!< EXTI Event mask register 1,                       Address offset: 0x84 */
  __IO uint32_t PR1;           /*!< EXTI Pending register 1,                          Address offset: 0x88 */
       uint32_t RESERVED3;     /*!< Reserved 3,                                       Address offset: 0x8C */
  __IO uint32_t IMR2;          /*!< EXTI Interrupt mask register 2,                   Address offset: 0x90 */
  __IO uint32_t EMR2;          /*!< EXTI Event mask register 2,                       Address offset: 0x94 */
  __IO uint32_t PR2;           /*!< EXTI Pending register 2,                          Address offset: 0x98 */
       uint32_t RESERVED4;     /*!< Reserved 4,                                       Address offset: 0x9C */
  __IO uint32_t IMR3;          /*!< EXTI Interrupt mask register 3,                   Address offset: 0xA0 */
  __IO uint32_t EMR3;          /*!< EXTI Event mask register 3,                       Address offset: 0xA4 */
} EXTI_TypeDef;
typedef struct
{
  __IO uint32_t CR;            /*!< RCC clock control register,                                              Address offset: 0x00 */
  __IO uint32_t HSICFGR;       /*!< HSI clock calibration register,                                          Address offset: 0x04 */
  __IO uint32_t CRRCR;         /*!< Clock recovery RC register,                                              Address offset: 0x08 */
  __IO uint32_t CSICFGR;       /*!< CSI clock calibration register,                                          Address offset: 0x0C */
  __IO uint32_t CFGR;          /*!< RCC clock configuration register,                                        Address offset: 0x10 */
  uint32_t      RESERVED0;     /*!< Reserved,                                                                Address offset: 0x14 */
  __IO uint32_t CDCFGR;        /*!< RCC CPU domain configuration register,                                   Address offset: 0x18 */
  __IO uint32_t BMCFGR;        /*!< RCC Bus matrix configuration register,                                   Address offset: 0x1C */
  __IO uint32_t APBCFGR;       /*!< RCC APB clock configuration register,                                    Address offset: 0x20 */
  uint32_t      RESERVED1;     /*!< Reserved,                                                                Address offset: 0x24 */
  __IO uint32_t PLLCKSELR;     /*!< RCC PLLs clock source selection register,                                Address offset: 0x28 */
  __IO uint32_t PLLCFGR;       /*!< RCC PLLs configuration register,                                         Address offset: 0x2C */
  __IO uint32_t PLL1DIVR1;     /*!< RCC PLL1 dividers configuration register 1,                              Address offset: 0x30 */
  __IO uint32_t PLL1FRACR;     /*!< RCC PLL1 fractional divider configuration register,                      Address offset: 0x34 */
  __IO uint32_t PLL2DIVR1;     /*!< RCC PLL2 dividers configuration register 1,                              Address offset: 0x38 */
  __IO uint32_t PLL2FRACR;     /*!< RCC PLL2 fractional divider configuration register,                      Address offset: 0x3C */
  __IO uint32_t PLL3DIVR1;     /*!< RCC PLL3 dividers configuration register 1,                              Address offset: 0x40 */
  __IO uint32_t PLL3FRACR;     /*!< RCC PLL3 fractional divider configuration register,                      Address offset: 0x44 */
  uint32_t      RESERVED2;     /*!< Reserved,                                                                Address offset: 0x48 */
  __IO uint32_t CCIPR1;        /*!< RCC AHB peripherals kernel clock configuration register                  Address offset: 0x4C */
  __IO uint32_t CCIPR2;        /*!< RCC APB1 peripherals kernel clock configuration register                 Address offset: 0x50 */
  __IO uint32_t CCIPR3;        /*!< RCC APB2 peripherals kernel clock configuration register                 Address offset: 0x54 */
  __IO uint32_t CCIPR4;        /*!< RCC APB4/APB5 peripherals kernel clock configuration register            Address offset: 0x58 */
  uint32_t      RESERVED3;     /*!< Reserved,                                                                Address offset: 0x5C */
  __IO uint32_t CIER;          /*!< RCC clock interrupt enable register,                                     Address offset: 0x60 */
  __IO uint32_t CIFR;          /*!< RCC clock interrupt flag register,                                       Address offset: 0x64 */
  __IO uint32_t CICR;          /*!< RCC clock interrupt clear register,                                      Address offset: 0x68 */
  uint32_t      RESERVED4;     /*!< Reserved,                                                                Address offset: 0x6C */
  __IO uint32_t BDCR;          /*!< RCC backup domain control register,                                      Address offset: 0x70 */
  __IO uint32_t CSR;           /*!< RCC clock control & status register,                                     Address offset: 0x74 */
  uint32_t      RESERVED5;     /*!< Reserved,                                                                Address offset: 0x78 */
  __IO uint32_t AHB5RSTR;      /*!< RCC AHB5 peripheral reset register,                                      Address offset: 0x7C */
  __IO uint32_t AHB1RSTR;      /*!< RCC AHB1 peripheral reset register,                                      Address offset: 0x80 */
  __IO uint32_t AHB2RSTR;      /*!< RCC AHB2 peripheral reset register,                                      Address offset: 0x84 */
  __IO uint32_t AHB4RSTR;      /*!< RCC AHB4 peripheral reset register,                                      Address offset: 0x88 */
  __IO uint32_t APB5RSTR;      /*!< RCC APB5 peripheral reset register,                                      Address offset: 0x8C */
  __IO uint32_t APB1RSTR1;     /*!< RCC APB1 peripheral reset register 1,                                    Address offset: 0x90 */
  __IO uint32_t APB1RSTR2;     /*!< RCC APB1 peripheral reset register 2,                                    Address offset: 0x94 */
  __IO uint32_t APB2RSTR;      /*!< RCC APB2 peripheral reset register,                                      Address offset: 0x98 */
  __IO uint32_t APB4RSTR;      /*!< RCC APB4 peripheral reset register,                                      Address offset: 0x9C */
  uint32_t      RESERVED6;     /*!< Reserved,                                                                Address offset: 0xA0 */
  __IO uint32_t AHB3RSTR;      /*!< RCC AHB3 peripheral reset register,                                      Address offset: 0xA4 */
  uint32_t      RESERVED7[2];  /*!< Reserved,                                                                Address offset: 0xA8-0xAC */
  __IO uint32_t CKGDISR  ;     /*!< RCC AXI clocks gating disable register,                                  Address offset: 0xB0 */
  uint32_t      RESERVED8[3];  /*!< Reserved,                                                                Address offset: 0xB4-0xBC */
  __IO uint32_t PLL1DIVR2;     /*!< RCC PLL1 dividers configuration register 2,                              Address offset: 0xC0 */
  __IO uint32_t PLL2DIVR2;     /*!< RCC PLL2 dividers configuration register 2,                              Address offset: 0xC4 */
  __IO uint32_t PLL3DIVR2;     /*!< RCC PLL3 dividers configuration register 2,                              Address offset: 0xC8 */
  __IO uint32_t PLL1SSCGR;     /*!< RCC PLL1 spread spectrum clock generator register,                       Address offset: 0xCC */
  __IO uint32_t PLL2SSCGR;     /*!< RCC PLL2 spread spectrum clock generator register,                       Address offset: 0xD0 */
  __IO uint32_t PLL3SSCGR;     /*!< RCC PLL3 spread spectrum clock generator register,                       Address offset: 0xD4 */
  uint32_t      RESERVED9[10]; /*!< Reserved,                                                                Address offset: 0xD8-0xFC */
  __IO uint32_t CKPROTR;       /*!< RCC clock protection register,                                           Address offset: 0x100 */
  uint32_t      RESERVED10[11]; /*!< Reserved,                                                               Address offset: 0x104-0x12C */
  __IO uint32_t RSR;           /*!< RCC reset status register,                                               Address offset: 0x130 */
  __IO uint32_t AHB5ENR;       /*!< RCC AHB5 peripheral clocks enable register,                              Address offset: 0x134 */
  __IO uint32_t AHB1ENR;       /*!< RCC AHB1 peripheral clocks enable register,                              Address offset: 0x138 */
  __IO uint32_t AHB2ENR;       /*!< RCC AHB2 peripheral clocks enable register,                              Address offset: 0x13C */
  __IO uint32_t AHB4ENR;       /*!< RCC AHB4 peripheral clocks enable register,                              Address offset: 0x140 */
  __IO uint32_t APB5ENR;       /*!< RCC APB5 peripheral clocks enable register,                              Address offset: 0x144 */
  __IO uint32_t APB1ENR1;      /*!< RCC APB1 peripheral clocks enable register 1,                            Address offset: 0x148 */
  __IO uint32_t APB1ENR2;      /*!< RCC APB1 peripheral clocks enable register 2,                            Address offset: 0x14C */
  __IO uint32_t APB2ENR;       /*!< RCC APB2 peripheral clocks enable register,                              Address offset: 0x150 */
  __IO uint32_t APB4ENR;       /*!< RCC APB4 peripheral clocks enable register,                              Address offset: 0x154 */
  __IO uint32_t AHB3ENR;       /*!< RCC AHB3 peripheral clocks enable register,                              Address offset: 0x158 */
  __IO uint32_t AHB5LPENR;     /*!< RCC AHB5 peripheral sleep clocks enable register,                        Address offset: 0x15C */
  __IO uint32_t AHB1LPENR;     /*!< RCC AHB1 peripheral sleep clocks enable register,                        Address offset: 0x160 */
  __IO uint32_t AHB2LPENR;     /*!< RCC AHB2 peripheral sleep clocks enable register,                        Address offset: 0x164 */
  __IO uint32_t AHB4LPENR;     /*!< RCC AHB4 peripheral sleep clocks enable register,                        Address offset: 0x168 */
  __IO uint32_t AHB3LPENR;     /*!< RCC AHB3 peripheral sleep clocks enable register,                        Address offset: 0x16C */
  __IO uint32_t APB1LPENR1;    /*!< RCC APB1 peripheral sleep clocks enable register 1,                      Address offset: 0x170 */
  __IO uint32_t APB1LPENR2;    /*!< RCC APB1 peripheral sleep clocks enable register 2,                      Address offset: 0x174 */
  __IO uint32_t APB2LPENR;     /*!< RCC APB2 peripheral sleep clocks enable register,                        Address offset: 0x178 */
  __IO uint32_t APB4LPENR;     /*!< RCC APB4 peripheral sleep clocks enable register,                        Address offset: 0x17C */
  __IO uint32_t APB5LPENR;     /*!< RCC APB5 peripheral sleep clocks enable register,                        Address offset: 0x180 */
} RCC_TypeDef;
typedef enum
{
  SUCCESS = 0,
  ERROR = !SUCCESS
} ErrorStatus;
typedef enum
{
  DISABLE = 0,
  ENABLE = !DISABLE
} FunctionalState;
#define EXTI_IMR1_IM0                EXTI_IMR1_IM0_Msk                         /*!< Interrupt Mask on line 0 */
#define EXTI_IMR1_IM0_Msk            (0x1UL << EXTI_IMR1_IM0_Pos)              /*!< 0x00000001 */
#define EXTI_IMR1_IM0_Pos            (0U)
#define EXTI_IMR1_IM1                EXTI_IMR1_IM1_Msk                         /*!< Interrupt Mask on line 1 */
#define EXTI_IMR1_IM10               EXTI_IMR1_IM10_Msk                        /*!< Interrupt Mask on line 10 */
#define EXTI_IMR1_IM10_Msk           (0x1UL << EXTI_IMR1_IM10_Pos)             /*!< 0x00000400 */
#define EXTI_IMR1_IM10_Pos           (10U)
#define EXTI_IMR1_IM11               EXTI_IMR1_IM11_Msk                        /*!< Interrupt Mask on line 11 */
#define EXTI_IMR1_IM11_Msk           (0x1UL << EXTI_IMR1_IM11_Pos)             /*!< 0x00000800 */
#define EXTI_IMR1_IM11_Pos           (11U)
#define EXTI_IMR1_IM12               EXTI_IMR1_IM12_Msk                        /*!< Interrupt Mask on line 12 */
#define EXTI_IMR1_IM12_Msk           (0x1UL << EXTI_IMR1_IM12_Pos)             /*!< 0x00001000 */
#define EXTI_IMR1_IM12_Pos           (12U)
#define EXTI_IMR1_IM13               EXTI_IMR1_IM13_Msk                        /*!< Interrupt Mask on line 13 */
#define EXTI_IMR1_IM13_Msk           (0x1UL << EXTI_IMR1_IM13_Pos)             /*!< 0x00002000 */
#define EXTI_IMR1_IM13_Pos           (13U)
#define EXTI_IMR1_IM14               EXTI_IMR1_IM14_Msk                        /*!< Interrupt Mask on line 14 */
#define EXTI_IMR1_IM14_Msk           (0x1UL << EXTI_IMR1_IM14_Pos)             /*!< 0x00004000 */
#define EXTI_IMR1_IM14_Pos           (14U)
#define EXTI_IMR1_IM15               EXTI_IMR1_IM15_Msk                        /*!< Interrupt Mask on line 15 */
#define EXTI_IMR1_IM15_Msk           (0x1UL << EXTI_IMR1_IM15_Pos)             /*!< 0x00008000 */
#define EXTI_IMR1_IM15_Pos           (15U)
#define EXTI_IMR1_IM16               EXTI_IMR1_IM16_Msk                        /*!< Interrupt Mask on line 16 */
#define EXTI_IMR1_IM16_Msk           (0x1UL << EXTI_IMR1_IM16_Pos)             /*!< 0x00010000 */
#define EXTI_IMR1_IM16_Pos           (16U)
#define EXTI_IMR1_IM17               EXTI_IMR1_IM17_Msk                        /*!< Interrupt Mask on line 17 */
#define EXTI_IMR1_IM17_Msk           (0x1UL << EXTI_IMR1_IM17_Pos)             /*!< 0x00020000 */
#define EXTI_IMR1_IM17_Pos           (17U)
#define EXTI_IMR1_IM18               EXTI_IMR1_IM18_Msk                        /*!< Interrupt Mask on line 18 */
#define EXTI_IMR1_IM18_Msk           (0x1UL << EXTI_IMR1_IM18_Pos)             /*!< 0x00040000 */
#define EXTI_IMR1_IM18_Pos           (18U)
#define EXTI_IMR1_IM19               EXTI_IMR1_IM19_Msk                        /*!< Interrupt Mask on line 19 */
#define EXTI_IMR1_IM19_Msk           (0x1UL << EXTI_IMR1_IM19_Pos)             /*!< 0x00080000 */
#define EXTI_IMR1_IM19_Pos           (19U)
#define EXTI_IMR1_IM1_Msk            (0x1UL << EXTI_IMR1_IM1_Pos)              /*!< 0x00000002 */
#define EXTI_IMR1_IM1_Pos            (1U)
#define EXTI_IMR1_IM2                EXTI_IMR1_IM2_Msk                         /*!< Interrupt Mask on line 2 */
#define EXTI_IMR1_IM20               EXTI_IMR1_IM20_Msk                        /*!< Interrupt Mask on line 20 */
#define EXTI_IMR1_IM20_Msk           (0x1UL << EXTI_IMR1_IM20_Pos)             /*!< 0x00100000 */
#define EXTI_IMR1_IM20_Pos           (20U)
#define EXTI_IMR1_IM21               EXTI_IMR1_IM21_Msk                        /*!< Interrupt Mask on line 21 */
#define EXTI_IMR1_IM21_Msk           (0x1UL << EXTI_IMR1_IM21_Pos)             /*!< 0x00200000 */
#define EXTI_IMR1_IM21_Pos           (21U)
#define EXTI_IMR1_IM22               EXTI_IMR1_IM22_Msk                        /*!< Interrupt Mask on line 22 */
#define EXTI_IMR1_IM22_Msk           (0x1UL << EXTI_IMR1_IM22_Pos)             /*!< 0x00400000 */
#define EXTI_IMR1_IM22_Pos           (22U)
#define EXTI_IMR1_IM23               EXTI_IMR1_IM23_Msk                        /*!< Interrupt Mask on line 23 */
#define EXTI_IMR1_IM23_Msk           (0x1UL << EXTI_IMR1_IM23_Pos)             /*!< 0x00800000 */
#define EXTI_IMR1_IM23_Pos           (23U)
#define EXTI_IMR1_IM24               EXTI_IMR1_IM24_Msk                        /*!< Interrupt Mask on line 24 */
#define EXTI_IMR1_IM24_Msk           (0x1UL << EXTI_IMR1_IM24_Pos)             /*!< 0x01000000 */
#define EXTI_IMR1_IM24_Pos           (24U)
#define EXTI_IMR1_IM25               EXTI_IMR1_IM25_Msk                        /*!< Interrupt Mask on line 25 */
#define EXTI_IMR1_IM25_Msk           (0x1UL << EXTI_IMR1_IM25_Pos)             /*!< 0x02000000 */
#define EXTI_IMR1_IM25_Pos           (25U)
#define EXTI_IMR1_IM26               EXTI_IMR1_IM26_Msk                        /*!< Interrupt Mask on line 26 */
#define EXTI_IMR1_IM26_Msk           (0x1UL << EXTI_IMR1_IM26_Pos)             /*!< 0x04000000 */
#define EXTI_IMR1_IM26_Pos           (26U)
#define EXTI_IMR1_IM27               EXTI_IMR1_IM27_Msk                        /*!< Interrupt Mask on line 27 */
#define EXTI_IMR1_IM27_Msk           (0x1UL << EXTI_IMR1_IM27_Pos)             /*!< 0x08000000 */
#define EXTI_IMR1_IM27_Pos           (27U)
#define EXTI_IMR1_IM28               EXTI_IMR1_IM28_Msk                        /*!< Interrupt Mask on line 28 */
#define EXTI_IMR1_IM28_Msk           (0x1UL << EXTI_IMR1_IM28_Pos)             /*!< 0x10000000 */
#define EXTI_IMR1_IM28_Pos           (28U)
#define EXTI_IMR1_IM29               EXTI_IMR1_IM29_Msk                        /*!< Interrupt Mask on line 29 */
#define EXTI_IMR1_IM29_Msk           (0x1UL << EXTI_IMR1_IM29_Pos)             /*!< 0x20000000 */
#define EXTI_IMR1_IM29_Pos           (29U)
#define EXTI_IMR1_IM2_Msk            (0x1UL << EXTI_IMR1_IM2_Pos)              /*!< 0x00000004 */
#define EXTI_IMR1_IM2_Pos            (2U)
#define EXTI_IMR1_IM3                EXTI_IMR1_IM3_Msk                         /*!< Interrupt Mask on line 3 */
#define EXTI_IMR1_IM30               EXTI_IMR1_IM30_Msk                        /*!< Interrupt Mask on line 30 */
#define EXTI_IMR1_IM30_Msk           (0x1UL << EXTI_IMR1_IM30_Pos)             /*!< 0x40000000 */
#define EXTI_IMR1_IM30_Pos           (30U)
#define EXTI_IMR1_IM31               EXTI_IMR1_IM31_Msk                        /*!< Interrupt Mask on line 31 */
#define EXTI_IMR1_IM31_Msk           (0x1UL << EXTI_IMR1_IM31_Pos)             /*!< 0x80000000 */
#define EXTI_IMR1_IM31_Pos           (31U)
#define EXTI_IMR1_IM3_Msk            (0x1UL << EXTI_IMR1_IM3_Pos)              /*!< 0x00000008 */
#define EXTI_IMR1_IM3_Pos            (3U)
#define EXTI_IMR1_IM4                EXTI_IMR1_IM4_Msk                         /*!< Interrupt Mask on line 4 */
#define EXTI_IMR1_IM4_Msk            (0x1UL << EXTI_IMR1_IM4_Pos)              /*!< 0x00000010 */
#define EXTI_IMR1_IM4_Pos            (4U)
#define EXTI_IMR1_IM5                EXTI_IMR1_IM5_Msk                         /*!< Interrupt Mask on line 5 */
#define EXTI_IMR1_IM5_Msk            (0x1UL << EXTI_IMR1_IM5_Pos)              /*!< 0x00000020 */
#define EXTI_IMR1_IM5_Pos            (5U)
#define EXTI_IMR1_IM6                EXTI_IMR1_IM6_Msk                         /*!< Interrupt Mask on line 6 */
#define EXTI_IMR1_IM6_Msk            (0x1UL << EXTI_IMR1_IM6_Pos)              /*!< 0x00000040 */
#define EXTI_IMR1_IM6_Pos            (6U)
#define EXTI_IMR1_IM7                EXTI_IMR1_IM7_Msk                         /*!< Interrupt Mask on line 7 */
#define EXTI_IMR1_IM7_Msk            (0x1UL << EXTI_IMR1_IM7_Pos)              /*!< 0x00000080 */
#define EXTI_IMR1_IM7_Pos            (7U)
#define EXTI_IMR1_IM8                EXTI_IMR1_IM8_Msk                         /*!< Interrupt Mask on line 8 */
#define EXTI_IMR1_IM8_Msk            (0x1UL << EXTI_IMR1_IM8_Pos)              /*!< 0x00000100 */
#define EXTI_IMR1_IM8_Pos            (8U)
#define EXTI_IMR1_IM9                EXTI_IMR1_IM9_Msk                         /*!< Interrupt Mask on line 9 */
#define EXTI_IMR1_IM9_Msk            (0x1UL << EXTI_IMR1_IM9_Pos)              /*!< 0x00000200 */
#define EXTI_IMR1_IM9_Pos            (9U)
#define EXTI_IMR2_IM32               EXTI_IMR2_IM32_Msk                        /*!< Interrupt Mask on line 32 */
#define EXTI_IMR2_IM32_Msk           (0x1UL << EXTI_IMR2_IM32_Pos)             /*!< 0x00000001 */
#define EXTI_IMR2_IM32_Pos           (0U)
#define EXTI_IMR2_IM33               EXTI_IMR2_IM33_Msk                        /*!< Interrupt Mask on line 33 */
#define EXTI_IMR2_IM33_Msk           (0x1UL << EXTI_IMR2_IM33_Pos)             /*!< 0x00000002 */
#define EXTI_IMR2_IM33_Pos           (1U)
#define EXTI_IMR2_IM34               EXTI_IMR2_IM34_Msk                        /*!< Interrupt Mask on line 34 */
#define EXTI_IMR2_IM34_Msk           (0x1UL << EXTI_IMR2_IM34_Pos)             /*!< 0x00000004 */
#define EXTI_IMR2_IM34_Pos           (2U)
#define EXTI_IMR2_IM35               EXTI_IMR2_IM35_Msk                        /*!< Interrupt Mask on line 35 */
#define EXTI_IMR2_IM35_Msk           (0x1UL << EXTI_IMR2_IM35_Pos)             /*!< 0x00000008 */
#define EXTI_IMR2_IM35_Pos           (3U)
#define EXTI_IMR2_IM36               EXTI_IMR2_IM36_Msk                        /*!< Interrupt Mask on line 36 */
#define EXTI_IMR2_IM36_Msk           (0x1UL << EXTI_IMR2_IM36_Pos)             /*!< 0x00000010 */
#define EXTI_IMR2_IM36_Pos           (4U)
#define EXTI_IMR2_IM37               EXTI_IMR2_IM37_Msk                        /*!< Interrupt Mask on line 37 */
#define EXTI_IMR2_IM37_Msk           (0x1UL << EXTI_IMR2_IM37_Pos)             /*!< 0x00000020 */
#define EXTI_IMR2_IM37_Pos           (5U)
#define EXTI_IMR2_IM38               EXTI_IMR2_IM38_Msk                        /*!< Interrupt Mask on line 38 */
#define EXTI_IMR2_IM38_Msk           (0x1UL << EXTI_IMR2_IM38_Pos)             /*!< 0x00000040 */
#define EXTI_IMR2_IM38_Pos           (6U)
#define EXTI_IMR2_IM39               EXTI_IMR2_IM39_Msk                        /*!< Interrupt Mask on line 39 */
#define EXTI_IMR2_IM39_Msk           (0x1UL << EXTI_IMR2_IM39_Pos)             /*!< 0x00000080 */
#define EXTI_IMR2_IM39_Pos           (7U)
#define EXTI_IMR2_IM40               EXTI_IMR2_IM40_Msk                        /*!< Interrupt Mask on line 40 */
#define EXTI_IMR2_IM40_Msk           (0x1UL << EXTI_IMR2_IM40_Pos)             /*!< 0x00000100 */
#define EXTI_IMR2_IM40_Pos           (8U)
#define EXTI_IMR2_IM41               EXTI_IMR2_IM41_Msk                        /*!< Interrupt Mask on line 41 */
#define EXTI_IMR2_IM41_Msk           (0x1UL << EXTI_IMR2_IM41_Pos)             /*!< 0x00000200 */
#define EXTI_IMR2_IM41_Pos           (9U)
#define EXTI_IMR2_IM42               EXTI_IMR2_IM42_Msk                        /*!< Interrupt Mask on line 42 */
#define EXTI_IMR2_IM42_Msk           (0x1UL << EXTI_IMR2_IM42_Pos)             /*!< 0x00000400 */
#define EXTI_IMR2_IM42_Pos           (10U)
#define EXTI_IMR2_IM43               EXTI_IMR2_IM43_Msk                        /*!< Interrupt Mask on line 43 */
#define EXTI_IMR2_IM43_Msk           (0x1UL << EXTI_IMR2_IM43_Pos)             /*!< 0x00000800 */
#define EXTI_IMR2_IM43_Pos           (11U)
#define EXTI_IMR2_IM44               EXTI_IMR2_IM44_Msk                        /*!< Interrupt Mask on line 44 */
#define EXTI_IMR2_IM44_Msk           (0x1UL << EXTI_IMR2_IM44_Pos)             /*!< 0x00001000 */
#define EXTI_IMR2_IM44_Pos           (12U)
#define EXTI_IMR2_IM45               EXTI_IMR2_IM45_Msk                        /*!< Interrupt Mask on line 45 */
#define EXTI_IMR2_IM45_Msk           (0x1UL << EXTI_IMR2_IM45_Pos)             /*!< 0x00002000 */
#define EXTI_IMR2_IM45_Pos           (13U)
#define EXTI_IMR2_IM46               EXTI_IMR2_IM46_Msk                        /*!< Interrupt Mask on line 46 */
#define EXTI_IMR2_IM46_Msk           (0x1UL << EXTI_IMR2_IM46_Pos)             /*!< 0x00004000 */
#define EXTI_IMR2_IM46_Pos           (14U)
#define EXTI_IMR2_IM47               EXTI_IMR2_IM47_Msk                        /*!< Interrupt Mask on line 47 */
#define EXTI_IMR2_IM47_Msk           (0x1UL << EXTI_IMR2_IM47_Pos)             /*!< 0x00008000 */
#define EXTI_IMR2_IM47_Pos           (15U)
#define EXTI_IMR2_IM48               EXTI_IMR2_IM48_Msk                        /*!< Interrupt Mask on line 48 */
#define EXTI_IMR2_IM48_Msk           (0x1UL << EXTI_IMR2_IM48_Pos)             /*!< 0x00010000 */
#define EXTI_IMR2_IM48_Pos           (16U)
#define EXTI_IMR2_IM49               EXTI_IMR2_IM49_Msk                        /*!< Interrupt Mask on line 49 */
#define EXTI_IMR2_IM49_Msk           (0x1UL << EXTI_IMR2_IM49_Pos)             /*!< 0x00020000 */
#define EXTI_IMR2_IM49_Pos           (17U)
#define EXTI_IMR2_IM50               EXTI_IMR2_IM50_Msk                        /*!< Interrupt Mask on line 50 */
#define EXTI_IMR2_IM50_Msk           (0x1UL << EXTI_IMR2_IM50_Pos)             /*!< 0x00040000 */
#define EXTI_IMR2_IM50_Pos           (18U)
#define EXTI_IMR2_IM51               EXTI_IMR2_IM51_Msk                        /*!< Interrupt Mask on line 51 */
#define EXTI_IMR2_IM51_Msk           (0x1UL << EXTI_IMR2_IM51_Pos)             /*!< 0x00080000 */
#define EXTI_IMR2_IM51_Pos           (19U)
#define EXTI_IMR2_IM52               EXTI_IMR2_IM52_Msk                        /*!< Interrupt Mask on line 52 */
#define EXTI_IMR2_IM52_Msk           (0x1UL << EXTI_IMR2_IM52_Pos)             /*!< 0x00100000 */
#define EXTI_IMR2_IM52_Pos           (20U)
#define EXTI_IMR2_IM53               EXTI_IMR2_IM53_Msk                        /*!< Interrupt Mask on line 53 */
#define EXTI_IMR2_IM53_Msk           (0x1UL << EXTI_IMR2_IM53_Pos)             /*!< 0x00200000 */
#define EXTI_IMR2_IM53_Pos           (21U)
#define EXTI_IMR2_IM54               EXTI_IMR2_IM54_Msk                        /*!< Interrupt Mask on line 54 */
#define EXTI_IMR2_IM54_Msk           (0x1UL << EXTI_IMR2_IM54_Pos)             /*!< 0x00400000 */
#define EXTI_IMR2_IM54_Pos           (22U)
#define EXTI_IMR2_IM55               EXTI_IMR2_IM55_Msk                        /*!< Interrupt Mask on line 55 */
#define EXTI_IMR2_IM55_Msk           (0x1UL << EXTI_IMR2_IM55_Pos)             /*!< 0x00800000 */
#define EXTI_IMR2_IM55_Pos           (23U)
#define EXTI_IMR2_IM56               EXTI_IMR2_IM56_Msk                        /*!< Interrupt Mask on line 56 */
#define EXTI_IMR2_IM56_Msk           (0x1UL << EXTI_IMR2_IM56_Pos)             /*!< 0x01000000 */
#define EXTI_IMR2_IM56_Pos           (24U)
#define EXTI_IMR2_IM57               EXTI_IMR2_IM57_Msk                        /*!< Interrupt Mask on line 57 */
#define EXTI_IMR2_IM57_Msk           (0x1UL << EXTI_IMR2_IM57_Pos)             /*!< 0x02000000 */
#define EXTI_IMR2_IM57_Pos           (25U)
#define EXTI_IMR2_IM58               EXTI_IMR2_IM58_Msk                        /*!< Interrupt Mask on line 58 */
#define EXTI_IMR2_IM58_Msk           (0x1UL << EXTI_IMR2_IM58_Pos)             /*!< 0x04000000 */
#define EXTI_IMR2_IM58_Pos           (26U)
#define EXTI_IMR2_IM59               EXTI_IMR2_IM59_Msk                        /*!< Interrupt Mask on line 59 */
#define EXTI_IMR2_IM59_Msk           (0x1UL << EXTI_IMR2_IM59_Pos)             /*!< 0x08000000 */
#define EXTI_IMR2_IM59_Pos           (27U)
#define EXTI_IMR3_IM77               EXTI_IMR3_IM77_Msk                        /*!< Interrupt Mask on line 77 */
#define EXTI_IMR3_IM77_Msk           (0x1UL << EXTI_IMR3_IM77_Pos)             /*!< 0x00002000 */
#define EXTI_IMR3_IM77_Pos           (13U)
#define GPIO_AFRH_AFSEL8               GPIO_AFRH_AFSEL8_Msk
#define GPIO_AFRH_AFSEL8_Msk           (0xFUL << GPIO_AFRH_AFSEL8_Pos)         /*!< 0x0000000F */
#define GPIO_AFRH_AFSEL8_Pos           (0U)
#define GPIO_AFRH_AFSEL9_Pos           (4U)
#define GPIO_AFRL_AFSEL0               GPIO_AFRL_AFSEL0_Msk
#define GPIO_AFRL_AFSEL0_Msk           (0xFUL << GPIO_AFRL_AFSEL0_Pos)         /*!< 0x0000000F */
#define GPIO_AFRL_AFSEL0_Pos           (0U)
#define GPIO_AFRL_AFSEL1_Pos           (4U)
#define GPIO_BSRR_BS0                  GPIO_BSRR_BS0_Msk
#define GPIO_BSRR_BS0_Msk              (0x1UL << GPIO_BSRR_BS0_Pos)            /*!< 0x00000001 */
#define GPIO_BSRR_BS0_Pos              (0U)
#define GPIO_BSRR_BS1                  GPIO_BSRR_BS1_Msk
#define GPIO_BSRR_BS10                 GPIO_BSRR_BS10_Msk
#define GPIO_BSRR_BS10_Msk             (0x1UL << GPIO_BSRR_BS10_Pos)           /*!< 0x00000400 */
#define GPIO_BSRR_BS10_Pos             (10U)
#define GPIO_BSRR_BS11                 GPIO_BSRR_BS11_Msk
#define GPIO_BSRR_BS11_Msk             (0x1UL << GPIO_BSRR_BS11_Pos)           /*!< 0x00000800 */
#define GPIO_BSRR_BS11_Pos             (11U)
#define GPIO_BSRR_BS12                 GPIO_BSRR_BS12_Msk
#define GPIO_BSRR_BS12_Msk             (0x1UL << GPIO_BSRR_BS12_Pos)           /*!< 0x00001000 */
#define GPIO_BSRR_BS12_Pos             (12U)
#define GPIO_BSRR_BS13                 GPIO_BSRR_BS13_Msk
#define GPIO_BSRR_BS13_Msk             (0x1UL << GPIO_BSRR_BS13_Pos)           /*!< 0x00002000 */
#define GPIO_BSRR_BS13_Pos             (13U)
#define GPIO_BSRR_BS14                 GPIO_BSRR_BS14_Msk
#define GPIO_BSRR_BS14_Msk             (0x1UL << GPIO_BSRR_BS14_Pos)           /*!< 0x00004000 */
#define GPIO_BSRR_BS14_Pos             (14U)
#define GPIO_BSRR_BS15                 GPIO_BSRR_BS15_Msk
#define GPIO_BSRR_BS15_Msk             (0x1UL << GPIO_BSRR_BS15_Pos)           /*!< 0x00008000 */
#define GPIO_BSRR_BS15_Pos             (15U)
#define GPIO_BSRR_BS1_Msk              (0x1UL << GPIO_BSRR_BS1_Pos)            /*!< 0x00000002 */
#define GPIO_BSRR_BS1_Pos              (1U)
#define GPIO_BSRR_BS2                  GPIO_BSRR_BS2_Msk
#define GPIO_BSRR_BS2_Msk              (0x1UL << GPIO_BSRR_BS2_Pos)            /*!< 0x00000004 */
#define GPIO_BSRR_BS2_Pos              (2U)
#define GPIO_BSRR_BS3                  GPIO_BSRR_BS3_Msk
#define GPIO_BSRR_BS3_Msk              (0x1UL << GPIO_BSRR_BS3_Pos)            /*!< 0x00000008 */
#define GPIO_BSRR_BS3_Pos              (3U)
#define GPIO_BSRR_BS4                  GPIO_BSRR_BS4_Msk
#define GPIO_BSRR_BS4_Msk              (0x1UL << GPIO_BSRR_BS4_Pos)            /*!< 0x00000010 */
#define GPIO_BSRR_BS4_Pos              (4U)
#define GPIO_BSRR_BS5                  GPIO_BSRR_BS5_Msk
#define GPIO_BSRR_BS5_Msk              (0x1UL << GPIO_BSRR_BS5_Pos)            /*!< 0x00000020 */
#define GPIO_BSRR_BS5_Pos              (5U)
#define GPIO_BSRR_BS6                  GPIO_BSRR_BS6_Msk
#define GPIO_BSRR_BS6_Msk              (0x1UL << GPIO_BSRR_BS6_Pos)            /*!< 0x00000040 */
#define GPIO_BSRR_BS6_Pos              (6U)
#define GPIO_BSRR_BS7                  GPIO_BSRR_BS7_Msk
#define GPIO_BSRR_BS7_Msk              (0x1UL << GPIO_BSRR_BS7_Pos)            /*!< 0x00000080 */
#define GPIO_BSRR_BS7_Pos              (7U)
#define GPIO_BSRR_BS8                  GPIO_BSRR_BS8_Msk
#define GPIO_BSRR_BS8_Msk              (0x1UL << GPIO_BSRR_BS8_Pos)            /*!< 0x00000100 */
#define GPIO_BSRR_BS8_Pos              (8U)
#define GPIO_BSRR_BS9                  GPIO_BSRR_BS9_Msk
#define GPIO_BSRR_BS9_Msk              (0x1UL << GPIO_BSRR_BS9_Pos)            /*!< 0x00000200 */
#define GPIO_BSRR_BS9_Pos              (9U)
#define GPIO_LCKR_LCKK                 GPIO_LCKR_LCKK_Msk
#define GPIO_LCKR_LCKK_Msk             (0x1UL << GPIO_LCKR_LCKK_Pos)           /*!< 0x00010000 */
#define GPIO_LCKR_LCKK_Pos             (16U)
#define GPIO_MODER_MODE0               GPIO_MODER_MODE0_Msk
#define GPIO_MODER_MODE0_0             (0x1UL << GPIO_MODER_MODE0_Pos)         /*!< 0x00000001 */
#define GPIO_MODER_MODE0_1             (0x2UL << GPIO_MODER_MODE0_Pos)         /*!< 0x00000002 */
#define GPIO_MODER_MODE0_Msk           (0x3UL << GPIO_MODER_MODE0_Pos)         /*!< 0x00000003 */
#define GPIO_MODER_MODE0_Pos           (0U)
#define GPIO_MODER_MODE1_Pos           (2U)
#define GPIO_OSPEEDR_OSPEED0           GPIO_OSPEEDR_OSPEED0_Msk
#define GPIO_OSPEEDR_OSPEED0_0         (0x1UL << GPIO_OSPEEDR_OSPEED0_Pos)     /*!< 0x00000001 */
#define GPIO_OSPEEDR_OSPEED0_1         (0x2UL << GPIO_OSPEEDR_OSPEED0_Pos)     /*!< 0x00000002 */
#define GPIO_OSPEEDR_OSPEED0_Msk       (0x3UL << GPIO_OSPEEDR_OSPEED0_Pos)     /*!< 0x00000003 */
#define GPIO_OSPEEDR_OSPEED0_Pos       (0U)
#define GPIO_OSPEEDR_OSPEED1_Pos       (2U)
#define GPIO_OTYPER_OT0                GPIO_OTYPER_OT0_Msk
#define GPIO_OTYPER_OT0_Msk            (0x1UL << GPIO_OTYPER_OT0_Pos)          /*!< 0x00000001 */
#define GPIO_OTYPER_OT0_Pos            (0U)
#define GPIO_PUPDR_PUPD0               GPIO_PUPDR_PUPD0_Msk
#define GPIO_PUPDR_PUPD0_0             (0x1UL << GPIO_PUPDR_PUPD0_Pos)         /*!< 0x00000001 */
#define GPIO_PUPDR_PUPD0_1             (0x2UL << GPIO_PUPDR_PUPD0_Pos)         /*!< 0x00000002 */
#define GPIO_PUPDR_PUPD0_Msk           (0x3UL << GPIO_PUPDR_PUPD0_Pos)         /*!< 0x00000003 */
#define GPIO_PUPDR_PUPD0_Pos           (0U)
#define GPIO_PUPDR_PUPD1_Pos           (2U)
#define RCC_AHB1ENR_ADC12EN            RCC_AHB1ENR_ADC12EN_Msk
#define RCC_AHB1ENR_ADC12EN_Msk        (0x1UL << RCC_AHB1ENR_ADC12EN_Pos)      /*!< 0x00000020 */
#define RCC_AHB1ENR_ADC12EN_Pos        (5U)
#define RCC_AHB1ENR_ADF1EN             RCC_AHB1ENR_ADF1EN_Msk
#define RCC_AHB1ENR_ADF1EN_Msk         (0x1UL << RCC_AHB1ENR_ADF1EN_Pos)       /*!< 0x80000000 */
#define RCC_AHB1ENR_ADF1EN_Pos         (31U)
#define RCC_AHB1ENR_ETH1MACEN          RCC_AHB1ENR_ETH1MACEN_Msk
#define RCC_AHB1ENR_ETH1MACEN_Msk      (0x1UL << RCC_AHB1ENR_ETH1MACEN_Pos)    /*!< 0x00008000 */
#define RCC_AHB1ENR_ETH1MACEN_Pos      (15U)
#define RCC_AHB1ENR_ETH1RXEN           RCC_AHB1ENR_ETH1RXEN_Msk
#define RCC_AHB1ENR_ETH1RXEN_Msk       (0x1UL << RCC_AHB1ENR_ETH1RXEN_Pos)     /*!< 0x00020000 */
#define RCC_AHB1ENR_ETH1RXEN_Pos       (17U)
#define RCC_AHB1ENR_ETH1TXEN           RCC_AHB1ENR_ETH1TXEN_Msk
#define RCC_AHB1ENR_ETH1TXEN_Msk       (0x1UL << RCC_AHB1ENR_ETH1TXEN_Pos)     /*!< 0x00010000 */
#define RCC_AHB1ENR_ETH1TXEN_Pos       (16U)
#define RCC_AHB1ENR_GPDMA1EN           RCC_AHB1ENR_GPDMA1EN_Msk
#define RCC_AHB1ENR_GPDMA1EN_Msk       (0x1UL << RCC_AHB1ENR_GPDMA1EN_Pos)     /*!< 0x00000010 */
#define RCC_AHB1ENR_GPDMA1EN_Pos       (4U)
#define RCC_AHB1ENR_OTGFSEN            RCC_AHB1ENR_OTGFSEN_Msk
#define RCC_AHB1ENR_OTGFSEN_Msk        (0x1UL << RCC_AHB1ENR_OTGFSEN_Pos)      /*!< 0x08000000 */
#define RCC_AHB1ENR_OTGFSEN_Pos        (27U)
#define RCC_AHB1ENR_OTGHSEN            RCC_AHB1ENR_OTGHSEN_Msk
#define RCC_AHB1ENR_OTGHSEN_Msk        (0x1UL << RCC_AHB1ENR_OTGHSEN_Pos)      /*!< 0x02000000 */
#define RCC_AHB1ENR_OTGHSEN_Pos        (25U)
#define RCC_AHB1ENR_USBPHYCEN          RCC_AHB1ENR_USBPHYCEN_Msk
#define RCC_AHB1ENR_USBPHYCEN_Msk      (0x1UL << RCC_AHB1ENR_USBPHYCEN_Pos)    /*!< 0x04000000 */
#define RCC_AHB1ENR_USBPHYCEN_Pos      (26U)
#define RCC_AHB2ENR_CORDICEN           RCC_AHB2ENR_CORDICEN_Msk
#define RCC_AHB2ENR_CORDICEN_Msk       (0x1UL << RCC_AHB2ENR_CORDICEN_Pos)     /*!< 0x00004000 */
#define RCC_AHB2ENR_CORDICEN_Pos       (14U)
#define RCC_AHB2ENR_PSSIEN             RCC_AHB2ENR_PSSIEN_Msk
#define RCC_AHB2ENR_PSSIEN_Msk         (0x1UL << RCC_AHB2ENR_PSSIEN_Pos)       /*!< 0x00000002 */
#define RCC_AHB2ENR_PSSIEN_Pos         (1U)
#define RCC_AHB2ENR_SDMMC2EN           RCC_AHB2ENR_SDMMC2EN_Msk
#define RCC_AHB2ENR_SDMMC2EN_Msk       (0x1UL << RCC_AHB2ENR_SDMMC2EN_Pos)     /*!< 0x00000200 */
#define RCC_AHB2ENR_SDMMC2EN_Pos       (9U)
#define RCC_AHB2ENR_SRAM1EN            RCC_AHB2ENR_SRAM1EN_Msk
#define RCC_AHB2ENR_SRAM1EN_Msk        (0x1UL << RCC_AHB2ENR_SRAM1EN_Pos)      /*!< 0x20000000 */
#define RCC_AHB2ENR_SRAM1EN_Pos        (29U)
#define RCC_AHB2ENR_SRAM2EN            RCC_AHB2ENR_SRAM2EN_Msk
#define RCC_AHB2ENR_SRAM2EN_Msk        (0x1UL << RCC_AHB2ENR_SRAM2EN_Pos)      /*!< 0x40000000 */
#define RCC_AHB2ENR_SRAM2EN_Pos        (30U)
#define RCC_AHB3ENR_CRYPEN             RCC_AHB3ENR_CRYPEN_Msk
#define RCC_AHB3ENR_CRYPEN_Msk         (0x1UL << RCC_AHB3ENR_CRYPEN_Pos)       /*!< 0x00000004 */
#define RCC_AHB3ENR_CRYPEN_Pos         (2U)
#define RCC_AHB3ENR_HASHEN             RCC_AHB3ENR_HASHEN_Msk
#define RCC_AHB3ENR_HASHEN_Msk         (0x1UL << RCC_AHB3ENR_HASHEN_Pos)       /*!< 0x00000002 */
#define RCC_AHB3ENR_HASHEN_Pos         (1U)
#define RCC_AHB3ENR_PKAEN              RCC_AHB3ENR_PKAEN_Msk
#define RCC_AHB3ENR_PKAEN_Msk          (0x1UL << RCC_AHB3ENR_PKAEN_Pos)        /*!< 0x00000040 */
#define RCC_AHB3ENR_PKAEN_Pos          (6U)
#define RCC_AHB3ENR_RNGEN              RCC_AHB3ENR_RNGEN_Msk
#define RCC_AHB3ENR_RNGEN_Msk          (0x1UL << RCC_AHB3ENR_RNGEN_Pos)        /*!< 0x00000001 */
#define RCC_AHB3ENR_RNGEN_Pos          (0U)
#define RCC_AHB3ENR_SAESEN             RCC_AHB3ENR_SAESEN_Msk
#define RCC_AHB3ENR_SAESEN_Msk         (0x1UL << RCC_AHB3ENR_SAESEN_Pos)       /*!< 0x00000010 */
#define RCC_AHB3ENR_SAESEN_Pos         (4U)
#define RCC_AHB4ENR_BKPRAMEN           RCC_AHB4ENR_BKPRAMEN_Msk
#define RCC_AHB4ENR_BKPRAMEN_Msk       (0x1UL << RCC_AHB4ENR_BKPRAMEN_Pos)     /*!< 0x10000000 */
#define RCC_AHB4ENR_BKPRAMEN_Pos       (28U)
#define RCC_AHB4ENR_CRCEN              RCC_AHB4ENR_CRCEN_Msk
#define RCC_AHB4ENR_CRCEN_Msk          (0x1UL << RCC_AHB4ENR_CRCEN_Pos)        /*!< 0x00080000 */
#define RCC_AHB4ENR_CRCEN_Pos          (19U)
#define RCC_AHB4ENR_GPIOAEN            RCC_AHB4ENR_GPIOAEN_Msk
#define RCC_AHB4ENR_GPIOAEN_Msk        (0x1UL << RCC_AHB4ENR_GPIOAEN_Pos)      /*!< 0x00000001 */
#define RCC_AHB4ENR_GPIOAEN_Pos        (0U)
#define RCC_AHB4ENR_GPIOBEN            RCC_AHB4ENR_GPIOBEN_Msk
#define RCC_AHB4ENR_GPIOBEN_Msk        (0x1UL << RCC_AHB4ENR_GPIOBEN_Pos)      /*!< 0x00000002 */
#define RCC_AHB4ENR_GPIOBEN_Pos        (1U)
#define RCC_AHB4ENR_GPIOCEN            RCC_AHB4ENR_GPIOCEN_Msk
#define RCC_AHB4ENR_GPIOCEN_Msk        (0x1UL << RCC_AHB4ENR_GPIOCEN_Pos)      /*!< 0x00000004 */
#define RCC_AHB4ENR_GPIOCEN_Pos        (2U)
#define RCC_AHB4ENR_GPIODEN            RCC_AHB4ENR_GPIODEN_Msk
#define RCC_AHB4ENR_GPIODEN_Msk        (0x1UL << RCC_AHB4ENR_GPIODEN_Pos)      /*!< 0x00000008 */
#define RCC_AHB4ENR_GPIODEN_Pos        (3U)
#define RCC_AHB4ENR_GPIOEEN            RCC_AHB4ENR_GPIOEEN_Msk
#define RCC_AHB4ENR_GPIOEEN_Msk        (0x1UL << RCC_AHB4ENR_GPIOEEN_Pos)      /*!< 0x00000010 */
#define RCC_AHB4ENR_GPIOEEN_Pos        (4U)
#define RCC_AHB4ENR_GPIOFEN            RCC_AHB4ENR_GPIOFEN_Msk
#define RCC_AHB4ENR_GPIOFEN_Msk        (0x1UL << RCC_AHB4ENR_GPIOFEN_Pos)      /*!< 0x00000020 */
#define RCC_AHB4ENR_GPIOFEN_Pos        (5U)
#define RCC_AHB4ENR_GPIOGEN            RCC_AHB4ENR_GPIOGEN_Msk
#define RCC_AHB4ENR_GPIOGEN_Msk        (0x1UL << RCC_AHB4ENR_GPIOGEN_Pos)      /*!< 0x00000040 */
#define RCC_AHB4ENR_GPIOGEN_Pos        (6U)
#define RCC_AHB4ENR_GPIOHEN            RCC_AHB4ENR_GPIOHEN_Msk
#define RCC_AHB4ENR_GPIOHEN_Msk        (0x1UL << RCC_AHB4ENR_GPIOHEN_Pos)      /*!< 0x00000080 */
#define RCC_AHB4ENR_GPIOHEN_Pos        (7U)
#define RCC_AHB4ENR_GPIOMEN            RCC_AHB4ENR_GPIOMEN_Msk
#define RCC_AHB4ENR_GPIOMEN_Msk        (0x1UL << RCC_AHB4ENR_GPIOMEN_Pos)      /*!< 0x00001000 */
#define RCC_AHB4ENR_GPIOMEN_Pos        (12U)
#define RCC_AHB4ENR_GPIONEN            RCC_AHB4ENR_GPIONEN_Msk
#define RCC_AHB4ENR_GPIONEN_Msk        (0x1UL << RCC_AHB4ENR_GPIONEN_Pos)      /*!< 0x00002000 */
#define RCC_AHB4ENR_GPIONEN_Pos        (13U)
#define RCC_AHB4ENR_GPIOOEN            RCC_AHB4ENR_GPIOOEN_Msk
#define RCC_AHB4ENR_GPIOOEN_Msk        (0x1UL << RCC_AHB4ENR_GPIOOEN_Pos)      /*!< 0x00004000 */
#define RCC_AHB4ENR_GPIOOEN_Pos        (14U)
#define RCC_AHB4ENR_GPIOPEN            RCC_AHB4ENR_GPIOPEN_Msk
#define RCC_AHB4ENR_GPIOPEN_Msk        (0x1UL << RCC_AHB4ENR_GPIOPEN_Pos)      /*!< 0x00008000 */
#define RCC_AHB4ENR_GPIOPEN_Pos        (15U)
#define RCC_AHB5ENR_DMA2DEN            RCC_AHB5ENR_DMA2DEN_Msk
#define RCC_AHB5ENR_DMA2DEN_Msk        (0x1UL << RCC_AHB5ENR_DMA2DEN_Pos)      /*!< 0x00000002 */
#define RCC_AHB5ENR_DMA2DEN_Pos        (1U)
#define RCC_AHB5ENR_FMCEN              RCC_AHB5ENR_FMCEN_Msk
#define RCC_AHB5ENR_FMCEN_Msk          (0x1UL << RCC_AHB5ENR_FMCEN_Pos)        /*!< 0x00000010 */
#define RCC_AHB5ENR_FMCEN_Pos          (4U)
#define RCC_AHB5ENR_GFXMMUEN           RCC_AHB5ENR_GFXMMUEN_Msk
#define RCC_AHB5ENR_GFXMMUEN_Msk       (0x1UL << RCC_AHB5ENR_GFXMMUEN_Pos)     /*!< 0x00080000 */
#define RCC_AHB5ENR_GFXMMUEN_Pos       (19U)
#define RCC_AHB5ENR_GPU2DEN            RCC_AHB5ENR_GPU2DEN_Msk
#define RCC_AHB5ENR_GPU2DEN_Msk        (0x1UL << RCC_AHB5ENR_GPU2DEN_Pos)      /*!< 0x00100000 */
#define RCC_AHB5ENR_GPU2DEN_Pos        (20U)
#define RCC_AHB5ENR_HPDMA1EN           RCC_AHB5ENR_HPDMA1EN_Msk
#define RCC_AHB5ENR_HPDMA1EN_Msk       (0x1UL << RCC_AHB5ENR_HPDMA1EN_Pos)     /*!< 0x00000001 */
#define RCC_AHB5ENR_HPDMA1EN_Pos       (0U)
#define RCC_AHB5ENR_JPEGEN             RCC_AHB5ENR_JPEGEN_Msk
#define RCC_AHB5ENR_JPEGEN_Msk         (0x1UL << RCC_AHB5ENR_JPEGEN_Pos)       /*!< 0x00000008 */
#define RCC_AHB5ENR_JPEGEN_Pos         (3U)
#define RCC_AHB5ENR_SDMMC1EN           RCC_AHB5ENR_SDMMC1EN_Msk
#define RCC_AHB5ENR_SDMMC1EN_Msk       (0x1UL << RCC_AHB5ENR_SDMMC1EN_Pos)     /*!< 0x00000100 */
#define RCC_AHB5ENR_SDMMC1EN_Pos       (8U)
#define RCC_AHB5ENR_XSPI1EN            RCC_AHB5ENR_XSPI1EN_Msk
#define RCC_AHB5ENR_XSPI1EN_Msk        (0x1UL << RCC_AHB5ENR_XSPI1EN_Pos)      /*!< 0x00000020 */
#define RCC_AHB5ENR_XSPI1EN_Pos        (5U)
#define RCC_AHB5ENR_XSPI2EN            RCC_AHB5ENR_XSPI2EN_Msk
#define RCC_AHB5ENR_XSPI2EN_Msk        (0x1UL << RCC_AHB5ENR_XSPI2EN_Pos)      /*!< 0x00001000 */
#define RCC_AHB5ENR_XSPI2EN_Pos        (12U)
#define RCC_AHB5ENR_XSPIMEN            RCC_AHB5ENR_XSPIMEN_Msk
#define RCC_AHB5ENR_XSPIMEN_Msk        (0x1UL << RCC_AHB5ENR_XSPIMEN_Pos)     /*!< 0x00004000 */
#define RCC_AHB5ENR_XSPIMEN_Pos        (14U)
#define RCC_AHB5LPENR_AXISRAMLPEN      RCC_AHB5LPENR_AXISRAMLPEN_Msk
#define RCC_AHB5LPENR_AXISRAMLPEN_Msk  (0x1UL << RCC_AHB5LPENR_AXISRAMLPEN_Pos) /*!< 0x80000000 */
#define RCC_AHB5LPENR_AXISRAMLPEN_Pos  (31U)
#define RCC_AHB5LPENR_DTCM1LPEN        RCC_AHB5LPENR_DTCM1LPEN_Msk
#define RCC_AHB5LPENR_DTCM1LPEN_Msk    (0x1UL << RCC_AHB5LPENR_DTCM1LPEN_Pos)  /*!< 0x10000000 */
#define RCC_AHB5LPENR_DTCM1LPEN_Pos    (28U)
#define RCC_AHB5LPENR_DTCM2LPEN        RCC_AHB5LPENR_DTCM2LPEN_Msk
#define RCC_AHB5LPENR_DTCM2LPEN_Msk    (0x1UL << RCC_AHB5LPENR_DTCM2LPEN_Pos)  /*!< 0x20000000 */
#define RCC_AHB5LPENR_DTCM2LPEN_Pos    (29U)
#define RCC_AHB5LPENR_FLASHLPEN        RCC_AHB5LPENR_FLASHLPEN_Msk
#define RCC_AHB5LPENR_FLASHLPEN_Msk    (0x1UL << RCC_AHB5LPENR_FLASHLPEN_Pos)  /*!< 0x00000004 */
#define RCC_AHB5LPENR_FLASHLPEN_Pos    (2U)
#define RCC_AHB5LPENR_ITCMLPEN         RCC_AHB5LPENR_ITCMLPEN_Msk
#define RCC_AHB5LPENR_ITCMLPEN_Msk     (0x1UL << RCC_AHB5LPENR_ITCMLPEN_Pos)   /*!< 0x40000000 */
#define RCC_AHB5LPENR_ITCMLPEN_Pos     (30U)
#define RCC_APB1ENR1_CECEN             RCC_APB1ENR1_CECEN_Msk
#define RCC_APB1ENR1_CECEN_Msk         (0x1UL << RCC_APB1ENR1_CECEN_Pos)       /*!< 0x08000000 */
#define RCC_APB1ENR1_CECEN_Pos         (27U)
#define RCC_APB1ENR1_I2C1_I3C1EN       RCC_APB1ENR1_I2C1_I3C1EN_Msk
#define RCC_APB1ENR1_I2C1_I3C1EN_Msk   (0x1UL << RCC_APB1ENR1_I2C1_I3C1EN_Pos) /*!< 0x00200000 */
#define RCC_APB1ENR1_I2C1_I3C1EN_Pos   (21U)
#define RCC_APB1ENR1_I2C2EN            RCC_APB1ENR1_I2C2EN_Msk
#define RCC_APB1ENR1_I2C2EN_Msk        (0x1UL << RCC_APB1ENR1_I2C2EN_Pos)      /*!< 0x00400000 */
#define RCC_APB1ENR1_I2C2EN_Pos        (22U)
#define RCC_APB1ENR1_I2C3EN            RCC_APB1ENR1_I2C3EN_Msk
#define RCC_APB1ENR1_I2C3EN_Msk        (0x1UL << RCC_APB1ENR1_I2C3EN_Pos)      /*!< 0x00800000 */
#define RCC_APB1ENR1_I2C3EN_Pos        (23U)
#define RCC_APB1ENR1_LPTIM1EN          RCC_APB1ENR1_LPTIM1EN_Msk
#define RCC_APB1ENR1_LPTIM1EN_Msk      (0x1UL << RCC_APB1ENR1_LPTIM1EN_Pos)    /*!< 0x00000200 */
#define RCC_APB1ENR1_LPTIM1EN_Pos      (9U)
#define RCC_APB1ENR1_SPDIFRXEN         RCC_APB1ENR1_SPDIFRXEN_Msk
#define RCC_APB1ENR1_SPDIFRXEN_Msk     (0x1UL << RCC_APB1ENR1_SPDIFRXEN_Pos)   /*!< 0x00010000 */
#define RCC_APB1ENR1_SPDIFRXEN_Pos     (16U)
#define RCC_APB1ENR1_SPI2EN            RCC_APB1ENR1_SPI2EN_Msk
#define RCC_APB1ENR1_SPI2EN_Msk        (0x1UL << RCC_APB1ENR1_SPI2EN_Pos)      /*!< 0x00004000 */
#define RCC_APB1ENR1_SPI2EN_Pos        (14U)
#define RCC_APB1ENR1_SPI3EN            RCC_APB1ENR1_SPI3EN_Msk
#define RCC_APB1ENR1_SPI3EN_Msk        (0x1UL << RCC_APB1ENR1_SPI3EN_Pos)      /*!< 0x00008000 */
#define RCC_APB1ENR1_SPI3EN_Pos        (15U)
#define RCC_APB1ENR1_TIM12EN           RCC_APB1ENR1_TIM12EN_Msk
#define RCC_APB1ENR1_TIM12EN_Msk       (0x1UL << RCC_APB1ENR1_TIM12EN_Pos)     /*!< 0x00000040 */
#define RCC_APB1ENR1_TIM12EN_Pos       (6U)
#define RCC_APB1ENR1_TIM13EN           RCC_APB1ENR1_TIM13EN_Msk
#define RCC_APB1ENR1_TIM13EN_Msk       (0x1UL << RCC_APB1ENR1_TIM13EN_Pos)     /*!< 0x00000080 */
#define RCC_APB1ENR1_TIM13EN_Pos       (7U)
#define RCC_APB1ENR1_TIM14EN           RCC_APB1ENR1_TIM14EN_Msk
#define RCC_APB1ENR1_TIM14EN_Msk       (0x1UL << RCC_APB1ENR1_TIM14EN_Pos)     /*!< 0x00000100 */
#define RCC_APB1ENR1_TIM14EN_Pos       (8U)
#define RCC_APB1ENR1_TIM2EN            RCC_APB1ENR1_TIM2EN_Msk
#define RCC_APB1ENR1_TIM2EN_Msk        (0x1UL << RCC_APB1ENR1_TIM2EN_Pos)      /*!< 0x00000001 */
#define RCC_APB1ENR1_TIM2EN_Pos        (0U)
#define RCC_APB1ENR1_TIM3EN            RCC_APB1ENR1_TIM3EN_Msk
#define RCC_APB1ENR1_TIM3EN_Msk        (0x1UL << RCC_APB1ENR1_TIM3EN_Pos)      /*!< 0x00000002 */
#define RCC_APB1ENR1_TIM3EN_Pos        (1U)
#define RCC_APB1ENR1_TIM4EN            RCC_APB1ENR1_TIM4EN_Msk
#define RCC_APB1ENR1_TIM4EN_Msk        (0x1UL << RCC_APB1ENR1_TIM4EN_Pos)      /*!< 0x00000004 */
#define RCC_APB1ENR1_TIM4EN_Pos        (2U)
#define RCC_APB1ENR1_TIM5EN            RCC_APB1ENR1_TIM5EN_Msk
#define RCC_APB1ENR1_TIM5EN_Msk        (0x1UL << RCC_APB1ENR1_TIM5EN_Pos)      /*!< 0x00000008 */
#define RCC_APB1ENR1_TIM5EN_Pos        (3U)
#define RCC_APB1ENR1_TIM6EN            RCC_APB1ENR1_TIM6EN_Msk
#define RCC_APB1ENR1_TIM6EN_Msk        (0x1UL << RCC_APB1ENR1_TIM6EN_Pos)      /*!< 0x00000010 */
#define RCC_APB1ENR1_TIM6EN_Pos        (4U)
#define RCC_APB1ENR1_TIM7EN            RCC_APB1ENR1_TIM7EN_Msk
#define RCC_APB1ENR1_TIM7EN_Msk        (0x1UL << RCC_APB1ENR1_TIM7EN_Pos)      /*!< 0x00000020 */
#define RCC_APB1ENR1_TIM7EN_Pos        (5U)
#define RCC_APB1ENR1_UART4EN           RCC_APB1ENR1_UART4EN_Msk
#define RCC_APB1ENR1_UART4EN_Msk       (0x1UL << RCC_APB1ENR1_UART4EN_Pos)     /*!< 0x00080000 */
#define RCC_APB1ENR1_UART4EN_Pos       (19U)
#define RCC_APB1ENR1_UART5EN           RCC_APB1ENR1_UART5EN_Msk
#define RCC_APB1ENR1_UART5EN_Msk       (0x1UL << RCC_APB1ENR1_UART5EN_Pos)     /*!< 0x00100000 */
#define RCC_APB1ENR1_UART5EN_Pos       (20U)
#define RCC_APB1ENR1_UART7EN           RCC_APB1ENR1_UART7EN_Msk
#define RCC_APB1ENR1_UART7EN_Msk       (0x1UL << RCC_APB1ENR1_UART7EN_Pos)     /*!< 0x40000000 */
#define RCC_APB1ENR1_UART7EN_Pos       (30U)
#define RCC_APB1ENR1_UART8EN           RCC_APB1ENR1_UART8EN_Msk
#define RCC_APB1ENR1_UART8EN_Msk       (0x1UL << RCC_APB1ENR1_UART8EN_Pos)     /*!< 0x80000000 */
#define RCC_APB1ENR1_UART8EN_Pos       (31U)
#define RCC_APB1ENR1_USART2EN          RCC_APB1ENR1_USART2EN_Msk
#define RCC_APB1ENR1_USART2EN_Msk      (0x1UL << RCC_APB1ENR1_USART2EN_Pos)    /*!< 0x00020000 */
#define RCC_APB1ENR1_USART2EN_Pos      (17U)
#define RCC_APB1ENR1_USART3EN          RCC_APB1ENR1_USART3EN_Msk
#define RCC_APB1ENR1_USART3EN_Msk      (0x1UL << RCC_APB1ENR1_USART3EN_Pos)    /*!< 0x00040000 */
#define RCC_APB1ENR1_USART3EN_Pos      (18U)
#define RCC_APB1ENR1_WWDGEN            RCC_APB1ENR1_WWDGEN_Msk
#define RCC_APB1ENR1_WWDGEN_Msk        (0x1UL << RCC_APB1ENR1_WWDGEN_Pos)      /*!< 0x00000800 */
#define RCC_APB1ENR1_WWDGEN_Pos        (11U)
#define RCC_APB1ENR2_CRSEN             RCC_APB1ENR2_CRSEN_Msk
#define RCC_APB1ENR2_CRSEN_Msk         (0x1UL << RCC_APB1ENR2_CRSEN_Pos)       /*!< 0x00000002 */
#define RCC_APB1ENR2_CRSEN_Pos         (1U)
#define RCC_APB1ENR2_FDCANEN           RCC_APB1ENR2_FDCANEN_Msk
#define RCC_APB1ENR2_FDCANEN_Msk       (0x1UL << RCC_APB1ENR2_FDCANEN_Pos)     /*!< 0x00000100 */
#define RCC_APB1ENR2_FDCANEN_Pos       (8U)
#define RCC_APB1ENR2_MDIOSEN           RCC_APB1ENR2_MDIOSEN_Msk
#define RCC_APB1ENR2_MDIOSEN_Msk       (0x1UL << RCC_APB1ENR2_MDIOSEN_Pos)     /*!< 0x00000020 */
#define RCC_APB1ENR2_MDIOSEN_Pos       (5U)
#define RCC_APB1ENR2_UCPD1EN           RCC_APB1ENR2_UCPD1EN_Msk
#define RCC_APB1ENR2_UCPD1EN_Msk       (0x1UL << RCC_APB1ENR2_UCPD1EN_Pos)     /*!< 0x08000000 */
#define RCC_APB1ENR2_UCPD1EN_Pos       (27U)
#define RCC_APB2ENR_SAI1EN             RCC_APB2ENR_SAI1EN_Msk
#define RCC_APB2ENR_SAI1EN_Msk         (0x1UL << RCC_APB2ENR_SAI1EN_Pos)       /*!< 0x00400000 */
#define RCC_APB2ENR_SAI1EN_Pos         (22U)
#define RCC_APB2ENR_SAI2EN             RCC_APB2ENR_SAI2EN_Msk
#define RCC_APB2ENR_SAI2EN_Msk         (0x1UL << RCC_APB2ENR_SAI2EN_Pos)       /*!< 0x00800000 */
#define RCC_APB2ENR_SAI2EN_Pos         (23U)
#define RCC_APB2ENR_SPI1EN             RCC_APB2ENR_SPI1EN_Msk
#define RCC_APB2ENR_SPI1EN_Msk         (0x1UL << RCC_APB2ENR_SPI1EN_Pos)       /*!< 0x00001000 */
#define RCC_APB2ENR_SPI1EN_Pos         (12U)
#define RCC_APB2ENR_SPI4EN             RCC_APB2ENR_SPI4EN_Msk
#define RCC_APB2ENR_SPI4EN_Msk         (0x1UL << RCC_APB2ENR_SPI4EN_Pos)       /*!< 0x00002000 */
#define RCC_APB2ENR_SPI4EN_Pos         (13U)
#define RCC_APB2ENR_SPI5EN             RCC_APB2ENR_SPI5EN_Msk
#define RCC_APB2ENR_SPI5EN_Msk         (0x1UL << RCC_APB2ENR_SPI5EN_Pos)       /*!< 0x00100000 */
#define RCC_APB2ENR_SPI5EN_Pos         (20U)
#define RCC_APB2ENR_TIM15EN            RCC_APB2ENR_TIM15EN_Msk
#define RCC_APB2ENR_TIM15EN_Msk        (0x1UL << RCC_APB2ENR_TIM15EN_Pos)      /*!< 0x00010000 */
#define RCC_APB2ENR_TIM15EN_Pos        (16U)
#define RCC_APB2ENR_TIM16EN            RCC_APB2ENR_TIM16EN_Msk
#define RCC_APB2ENR_TIM16EN_Msk        (0x1UL << RCC_APB2ENR_TIM16EN_Pos)      /*!< 0x00020000 */
#define RCC_APB2ENR_TIM16EN_Pos        (17U)
#define RCC_APB2ENR_TIM17EN            RCC_APB2ENR_TIM17EN_Msk
#define RCC_APB2ENR_TIM17EN_Msk        (0x1UL << RCC_APB2ENR_TIM17EN_Pos)      /*!< 0x00040000 */
#define RCC_APB2ENR_TIM17EN_Pos        (18U)
#define RCC_APB2ENR_TIM1EN             RCC_APB2ENR_TIM1EN_Msk
#define RCC_APB2ENR_TIM1EN_Msk         (0x1UL << RCC_APB2ENR_TIM1EN_Pos)       /*!< 0x00000001 */
#define RCC_APB2ENR_TIM1EN_Pos         (0U)
#define RCC_APB2ENR_TIM9EN             RCC_APB2ENR_TIM9EN_Msk
#define RCC_APB2ENR_TIM9EN_Msk         (0x1UL << RCC_APB2ENR_TIM9EN_Pos)       /*!< 0x00080000 */
#define RCC_APB2ENR_TIM9EN_Pos         (19U)
#define RCC_APB2ENR_USART1EN           RCC_APB2ENR_USART1EN_Msk
#define RCC_APB2ENR_USART1EN_Msk       (0x1UL << RCC_APB2ENR_USART1EN_Pos)     /*!< 0x00000010 */
#define RCC_APB2ENR_USART1EN_Pos       (4U)
#define RCC_APB4ENR_DTSEN              RCC_APB4ENR_DTSEN_Msk
#define RCC_APB4ENR_DTSEN_Msk          (0x1UL << RCC_APB4ENR_DTSEN_Pos)        /*!< 0x04000000 */
#define RCC_APB4ENR_DTSEN_Pos          (26U)
#define RCC_APB4ENR_LPTIM2EN           RCC_APB4ENR_LPTIM2EN_Msk
#define RCC_APB4ENR_LPTIM2EN_Msk       (0x1UL << RCC_APB4ENR_LPTIM2EN_Pos)     /*!< 0x00000200 */
#define RCC_APB4ENR_LPTIM2EN_Pos       (9U)
#define RCC_APB4ENR_LPTIM3EN           RCC_APB4ENR_LPTIM3EN_Msk
#define RCC_APB4ENR_LPTIM3EN_Msk       (0x1UL << RCC_APB4ENR_LPTIM3EN_Pos)     /*!< 0x00000400 */
#define RCC_APB4ENR_LPTIM3EN_Pos       (10U)
#define RCC_APB4ENR_LPTIM4EN           RCC_APB4ENR_LPTIM4EN_Msk
#define RCC_APB4ENR_LPTIM4EN_Msk       (0x1UL << RCC_APB4ENR_LPTIM4EN_Pos)     /*!< 0x00000800 */
#define RCC_APB4ENR_LPTIM4EN_Pos       (11U)
#define RCC_APB4ENR_LPTIM5EN           RCC_APB4ENR_LPTIM5EN_Msk
#define RCC_APB4ENR_LPTIM5EN_Msk       (0x1UL << RCC_APB4ENR_LPTIM5EN_Pos)     /*!< 0x00001000 */
#define RCC_APB4ENR_LPTIM5EN_Pos       (12U)
#define RCC_APB4ENR_LPUART1EN          RCC_APB4ENR_LPUART1EN_Msk
#define RCC_APB4ENR_LPUART1EN_Msk      (0x1UL << RCC_APB4ENR_LPUART1EN_Pos)    /*!< 0x00000008 */
#define RCC_APB4ENR_LPUART1EN_Pos      (3U)
#define RCC_APB4ENR_RTCAPBEN           RCC_APB4ENR_RTCAPBEN_Msk
#define RCC_APB4ENR_RTCAPBEN_Msk       (0x1UL << RCC_APB4ENR_RTCAPBEN_Pos)     /*!< 0x00010000 */
#define RCC_APB4ENR_RTCAPBEN_Pos       (16U)
#define RCC_APB4ENR_SBSEN              RCC_APB4ENR_SBSEN_Msk
#define RCC_APB4ENR_SBSEN_Msk          (0x1UL << RCC_APB4ENR_SBSEN_Pos)        /*!< 0x00000002 */
#define RCC_APB4ENR_SBSEN_Pos          (1U)
#define RCC_APB4ENR_SPI6EN             RCC_APB4ENR_SPI6EN_Msk
#define RCC_APB4ENR_SPI6EN_Msk         (0x1UL << RCC_APB4ENR_SPI6EN_Pos)       /*!< 0x00000020 */
#define RCC_APB4ENR_SPI6EN_Pos         (5U)
#define RCC_APB4ENR_VREFEN             RCC_APB4ENR_VREFEN_Msk
#define RCC_APB4ENR_VREFEN_Msk         (0x1UL << RCC_APB4ENR_VREFEN_Pos)       /*!< 0x00008000 */
#define RCC_APB4ENR_VREFEN_Pos         (15U)
#define RCC_APB5ENR_DCMIPPEN           RCC_APB5ENR_DCMIPPEN_Msk
#define RCC_APB5ENR_DCMIPPEN_Msk       (0x1UL << RCC_APB5ENR_DCMIPPEN_Pos)     /*!< 0x00000004 */
#define RCC_APB5ENR_DCMIPPEN_Pos       (2U)
#define RCC_APB5ENR_GFXTIMEN           RCC_APB5ENR_GFXTIMEN_Msk
#define RCC_APB5ENR_GFXTIMEN_Msk       (0x1UL << RCC_APB5ENR_GFXTIMEN_Pos)     /*!< 0x00000010 */
#define RCC_APB5ENR_GFXTIMEN_Pos       (4U)
#define RCC_APB5ENR_LTDCEN             RCC_APB5ENR_LTDCEN_Msk
#define RCC_APB5ENR_LTDCEN_Msk         (0x1UL << RCC_APB5ENR_LTDCEN_Pos)       /*!< 0x00000002 */
#define RCC_APB5ENR_LTDCEN_Pos         (1U)
#define RCC_CKGDISR_AHBMCKG            RCC_CKGDISR_AHBMCKG_Msk
#define RCC_CKGDISR_AHBMCKG_Msk        (0x1UL << RCC_CKGDISR_AHBMCKG_Pos)      /*!< 0x00000002 */
#define RCC_CKGDISR_AHBMCKG_Pos        (1U)
#define RCC_CKGDISR_AHBSCKG            RCC_CKGDISR_AHBSCKG_Msk
#define RCC_CKGDISR_AHBSCKG_Msk        (0x1UL << RCC_CKGDISR_AHBSCKG_Pos)      /*!< 0x00002000 */
#define RCC_CKGDISR_AHBSCKG_Pos        (13U)
#define RCC_CKGDISR_AXICKG             RCC_CKGDISR_AXICKG_Msk
#define RCC_CKGDISR_AXICKG_Msk         (0x1UL << RCC_CKGDISR_AXICKG_Pos)       /*!< 0x00000001 */
#define RCC_CKGDISR_AXICKG_Pos         (0U)
#define RCC_CKGDISR_AXISRAM1CKG        RCC_CKGDISR_AXISRAM1CKG_Msk
#define RCC_CKGDISR_AXISRAM1CKG_Msk    (0x1UL << RCC_CKGDISR_AXISRAM1CKG_Pos)  /*!< 0x00100000 */
#define RCC_CKGDISR_AXISRAM1CKG_Pos    (20U)
#define RCC_CKGDISR_AXISRAM2CKG        RCC_CKGDISR_AXISRAM2CKG_Msk
#define RCC_CKGDISR_AXISRAM2CKG_Msk    (0x1UL << RCC_CKGDISR_AXISRAM2CKG_Pos)  /*!< 0x00080000 */
#define RCC_CKGDISR_AXISRAM2CKG_Pos    (19U)
#define RCC_CKGDISR_AXISRAM3CKG        RCC_CKGDISR_AXISRAM3CKG_Msk
#define RCC_CKGDISR_AXISRAM3CKG_Msk    (0x1UL << RCC_CKGDISR_AXISRAM3CKG_Pos)  /*!< 0x00040000 */
#define RCC_CKGDISR_AXISRAM3CKG_Pos    (18U)
#define RCC_CKGDISR_AXISRAM4CKG        RCC_CKGDISR_AXISRAM4CKG_Msk
#define RCC_CKGDISR_AXISRAM4CKG_Msk    (0x1UL << RCC_CKGDISR_AXISRAM4CKG_Pos)  /*!< 0x00020000 */
#define RCC_CKGDISR_AXISRAM4CKG_Pos    (17U)
#define RCC_CKGDISR_CPUCKG             RCC_CKGDISR_CPUCKG_Msk
#define RCC_CKGDISR_CPUCKG_Msk         (0x1UL << RCC_CKGDISR_CPUCKG_Pos)       /*!< 0x00000010 */
#define RCC_CKGDISR_CPUCKG_Pos         (4U)
#define RCC_CKGDISR_DCMIPPCKG          RCC_CKGDISR_DCMIPPCKG_Msk
#define RCC_CKGDISR_DCMIPPCKG_Msk      (0x1UL << RCC_CKGDISR_DCMIPPCKG_Pos)    /*!< 0x00000100 */
#define RCC_CKGDISR_DCMIPPCKG_Pos      (8U)
#define RCC_CKGDISR_DMA2DCKG           RCC_CKGDISR_DMA2DCKG_Msk
#define RCC_CKGDISR_DMA2DCKG_Msk       (0x1UL << RCC_CKGDISR_DMA2DCKG_Pos)     /*!< 0x00000200 */
#define RCC_CKGDISR_DMA2DCKG_Pos       (9U)
#define RCC_CKGDISR_EXTICKG            RCC_CKGDISR_EXTICKG_Msk
#define RCC_CKGDISR_EXTICKG_Msk        (0x1UL << RCC_CKGDISR_EXTICKG_Pos)      /*!< 0x40000000 */
#define RCC_CKGDISR_EXTICKG_Pos        (30U)
#define RCC_CKGDISR_FLASHCKG           RCC_CKGDISR_FLASHCKG_Msk
#define RCC_CKGDISR_FLASHCKG_Msk       (0x1UL << RCC_CKGDISR_FLASHCKG_Pos)     /*!< 0x00200000 */
#define RCC_CKGDISR_FLASHCKG_Pos       (21U)
#define RCC_CKGDISR_FMCCKG             RCC_CKGDISR_FMCCKG_Msk
#define RCC_CKGDISR_FMCCKG_Msk         (0x1UL << RCC_CKGDISR_FMCCKG_Pos)       /*!< 0x00004000 */
#define RCC_CKGDISR_FMCCKG_Pos         (14U)
#define RCC_CKGDISR_GFXMMUMCKG         RCC_CKGDISR_GFXMMUMCKG_Msk
#define RCC_CKGDISR_GFXMMUMCKG_Msk     (0x1UL << RCC_CKGDISR_GFXMMUMCKG_Pos)   /*!< 0x00001000 */
#define RCC_CKGDISR_GFXMMUMCKG_Pos     (12U)
#define RCC_CKGDISR_GFXMMUSCKG         RCC_CKGDISR_GFXMMUSCKG_Msk
#define RCC_CKGDISR_GFXMMUSCKG_Msk     (0x1UL << RCC_CKGDISR_GFXMMUSCKG_Pos)   /*!< 0x00000400 */
#define RCC_CKGDISR_GFXMMUSCKG_Pos     (10U)
#define RCC_CKGDISR_GPU2DCLCKG         RCC_CKGDISR_GPU2DCLCKG_Msk
#define RCC_CKGDISR_GPU2DCLCKG_Msk     (0x1UL << RCC_CKGDISR_GPU2DCLCKG_Pos)   /*!< 0x00000080 */
#define RCC_CKGDISR_GPU2DCLCKG_Pos     (7U)
#define RCC_CKGDISR_GPU2DS0CKG         RCC_CKGDISR_GPU2DS0CKG_Msk
#define RCC_CKGDISR_GPU2DS0CKG_Msk     (0x1UL << RCC_CKGDISR_GPU2DS0CKG_Pos)   /*!< 0x00000020 */
#define RCC_CKGDISR_GPU2DS0CKG_Pos     (5U)
#define RCC_CKGDISR_GPU2DS1CKG         RCC_CKGDISR_GPU2DS1CKG_Msk
#define RCC_CKGDISR_GPU2DS1CKG_Msk     (0x1UL << RCC_CKGDISR_GPU2DS1CKG_Pos)   /*!< 0x00000040 */
#define RCC_CKGDISR_GPU2DS1CKG_Pos     (6U)
#define RCC_CKGDISR_HPDMA1CKG          RCC_CKGDISR_HPDMA1CKG_Msk
#define RCC_CKGDISR_HPDMA1CKG_Msk      (0x1UL << RCC_CKGDISR_HPDMA1CKG_Pos)    /*!< 0x00000008 */
#define RCC_CKGDISR_HPDMA1CKG_Pos      (3U)
#define RCC_CKGDISR_JTAGCKG            RCC_CKGDISR_JTAGCKG_Msk
#define RCC_CKGDISR_JTAGCKG_Msk        (0x1UL << RCC_CKGDISR_JTAGCKG_Pos)      /*!< 0x80000000 */
#define RCC_CKGDISR_JTAGCKG_Pos        (31U)
#define RCC_CKGDISR_LTDCCKG            RCC_CKGDISR_LTDCCKG_Msk
#define RCC_CKGDISR_LTDCCKG_Msk        (0x1UL << RCC_CKGDISR_LTDCCKG_Pos)      /*!< 0x00000800 */
#define RCC_CKGDISR_LTDCCKG_Pos        (11U)
#define RCC_CKGDISR_SDMMC1CKG           RCC_CKGDISR_SDMMC1CKG_Msk
#define RCC_CKGDISR_SDMMC1CKG_Msk      (0x1UL << RCC_CKGDISR_SDMMC1CKG_Pos)    /*!< 0x00000004 */
#define RCC_CKGDISR_SDMMC1CKG_Pos      (2U)
#define RCC_CKGDISR_XSPI1CKG           RCC_CKGDISR_XSPI1CKG_Msk
#define RCC_CKGDISR_XSPI1CKG_Msk       (0x1UL << RCC_CKGDISR_XSPI1CKG_Pos)     /*!< 0x00008000 */
#define RCC_CKGDISR_XSPI1CKG_Pos       (15U)
#define RCC_CKGDISR_XSPI2CKG           RCC_CKGDISR_XSPI2CKG_Msk
#define RCC_CKGDISR_XSPI2CKG_Msk       (0x1UL << RCC_CKGDISR_XSPI2CKG_Pos)     /*!< 0x00010000 */
#define RCC_CKGDISR_XSPI2CKG_Pos       (16U)
