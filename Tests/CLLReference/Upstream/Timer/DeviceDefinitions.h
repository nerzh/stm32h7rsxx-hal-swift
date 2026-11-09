// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// Pinned CMSIS definitions; see LICENSES/NOTICE.txt.
#pragma once
#include <stdint.h>
#define __IO volatile
#define __I volatile const
#define __O volatile
typedef enum
{
  RESET = 0,
  SET = !RESET
} FlagStatus, ITStatus;
typedef struct
{
  __IO uint32_t CR1;            /*!< TIM control register 1,                   Address offset: 0x00  */
  __IO uint32_t CR2;            /*!< TIM control register 2,                   Address offset: 0x04  */
  __IO uint32_t SMCR;           /*!< TIM slave mode control register,          Address offset: 0x08  */
  __IO uint32_t DIER;           /*!< TIM DMA/interrupt enable register,        Address offset: 0x0C  */
  __IO uint32_t SR;             /*!< TIM status register,                      Address offset: 0x10  */
  __IO uint32_t EGR;            /*!< TIM event generation register,            Address offset: 0x14  */
  __IO uint32_t CCMR1;          /*!< TIM capture/compare mode register 1,      Address offset: 0x18  */
  __IO uint32_t CCMR2;          /*!< TIM capture/compare mode register 2,      Address offset: 0x1C  */
  __IO uint32_t CCER;           /*!< TIM capture/compare enable register,      Address offset: 0x20  */
  __IO uint32_t CNT;            /*!< TIM counter register,                     Address offset: 0x24  */
  __IO uint32_t PSC;            /*!< TIM prescaler,                            Address offset: 0x28  */
  __IO uint32_t ARR;            /*!< TIM auto-reload register,                 Address offset: 0x2C  */
  __IO uint32_t RCR;            /*!< TIM repetition counter register,          Address offset: 0x30  */
  __IO uint32_t CCR1;           /*!< TIM capture/compare register 1,           Address offset: 0x34  */
  __IO uint32_t CCR2;           /*!< TIM capture/compare register 2,           Address offset: 0x38  */
  __IO uint32_t CCR3;           /*!< TIM capture/compare register 3,           Address offset: 0x3C  */
  __IO uint32_t CCR4;           /*!< TIM capture/compare register 4,           Address offset: 0x40  */
  __IO uint32_t BDTR;           /*!< TIM break and dead-time register,         Address offset: 0x44  */
  __IO uint32_t CCR5;           /*!< TIM capture/compare register 5,           Address offset: 0x48  */
  __IO uint32_t CCR6;           /*!< TIM capture/compare register 6,           Address offset: 0x4C  */
  __IO uint32_t CCMR3;          /*!< TIM capture/compare mode register 3,      Address offset: 0x50  */
  __IO uint32_t DTR2;           /*!< TIM deadtime register 2,                  Address offset: 0x54  */
  __IO uint32_t ECR;            /*!< TIM encoder control register,             Address offset: 0x58  */
  __IO uint32_t TISEL;          /*!< TIM Input Selection register,             Address offset: 0x5C  */
  __IO uint32_t AF1;            /*!< TIM alternate function option register 1, Address offset: 0x60  */
  __IO uint32_t AF2;            /*!< TIM alternate function option register 2, Address offset: 0x64  */
       uint32_t RESERVED0[221]; /*!< Reserved,                                 Address offset: 0x68  */
  __IO uint32_t DCR;            /*!< TIM DMA control register,                 Address offset: 0x3DC */
  __IO uint32_t DMAR;           /*!< TIM DMA address for full transfer,        Address offset: 0x3E0 */
} TIM_TypeDef;
typedef struct
{
  __IO uint32_t ISR;           /*!< LPTIM Interrupt and Status register,    Address offset: 0x00 */
  __IO uint32_t ICR;           /*!< LPTIM Interrupt Clear register,         Address offset: 0x04 */
  __IO uint32_t DIER;          /*!< LPTIM Interrupt Enable register,        Address offset: 0x08 */
  __IO uint32_t CFGR;          /*!< LPTIM Configuration register,           Address offset: 0x0C */
  __IO uint32_t CR;            /*!< LPTIM Control register,                 Address offset: 0x10 */
  __IO uint32_t CCR1;          /*!< LPTIM Capture/Compare register 1,       Address offset: 0x14 */
  __IO uint32_t ARR;           /*!< LPTIM Autoreload register,              Address offset: 0x18 */
  __IO uint32_t CNT;           /*!< LPTIM Counter register,                 Address offset: 0x1C */
  __IO uint32_t RESERVED0;     /*!< Reserved,                               Address offset: 0x20 */
  __IO uint32_t CFGR2;         /*!< LPTIM Configuration register 2,         Address offset: 0x24 */
  __IO uint32_t RCR;           /*!< LPTIM Repetition register,              Address offset: 0x28 */
  __IO uint32_t CCMR1;         /*!< LPTIM Capture/Compare mode register,    Address offset: 0x2C */
  __IO uint32_t RESERVED1;     /*!< Reserved,                               Address offset: 0x30 */
  __IO uint32_t CCR2;          /*!< LPTIM Capture/Compare register 2,       Address offset: 0x34 */
} LPTIM_TypeDef;
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
#define APB1PERIPH_BASE                 PERIPH_BASE
#define APB2PERIPH_BASE                 (PERIPH_BASE + 0x02000000UL)
#define APB4PERIPH_BASE                 (PERIPH_BASE + 0x18000000UL)
#define IS_LPTIM_INSTANCE(INSTANCE)     (((INSTANCE) == LPTIM1) ||                                           ((INSTANCE) == LPTIM2) ||                                           ((INSTANCE) == LPTIM3) ||                                           ((INSTANCE) == LPTIM4) ||                                           ((INSTANCE) == LPTIM5))
#define IS_TIM_BKIN2_INSTANCE(INSTANCE) ((INSTANCE) == TIM1)
#define IS_TIM_BREAK_INSTANCE(INSTANCE)    (((INSTANCE) == TIM1)  ||                                              ((INSTANCE) == TIM15) ||                                              ((INSTANCE) == TIM16) ||                                              ((INSTANCE) == TIM17))
#define IS_TIM_CC1_INSTANCE(INSTANCE)   (((INSTANCE) == TIM1)  ||                                           ((INSTANCE) == TIM2)  ||                                           ((INSTANCE) == TIM3)  ||                                           ((INSTANCE) == TIM4)  ||                                           ((INSTANCE) == TIM5)  ||                                           ((INSTANCE) == TIM9)  ||                                           ((INSTANCE) == TIM12) ||                                           ((INSTANCE) == TIM13) ||                                           ((INSTANCE) == TIM14) ||                                           ((INSTANCE) == TIM15) ||                                           ((INSTANCE) == TIM16) ||                                           ((INSTANCE) == TIM17))
#define IS_TIM_CC2_INSTANCE(INSTANCE)   (((INSTANCE) == TIM1)  ||                                           ((INSTANCE) == TIM2)  ||                                           ((INSTANCE) == TIM3)  ||                                           ((INSTANCE) == TIM4)  ||                                           ((INSTANCE) == TIM5)  ||                                           ((INSTANCE) == TIM9)  ||                                           ((INSTANCE) == TIM12) ||                                           ((INSTANCE) == TIM15))
#define IS_TIM_CC3_INSTANCE(INSTANCE)   (((INSTANCE) == TIM1)  ||                                           ((INSTANCE) == TIM2)  ||                                           ((INSTANCE) == TIM3)  ||                                           ((INSTANCE) == TIM4)  ||                                           ((INSTANCE) == TIM5))
#define IS_TIM_CC4_INSTANCE(INSTANCE)   (((INSTANCE) == TIM1)  ||                                           ((INSTANCE) == TIM2)  ||                                           ((INSTANCE) == TIM3)  ||                                           ((INSTANCE) == TIM4)  ||                                           ((INSTANCE) == TIM5))
#define IS_TIM_CC5_INSTANCE(INSTANCE)   ((INSTANCE) == TIM1)
#define IS_TIM_CC6_INSTANCE(INSTANCE)   ((INSTANCE) == TIM1)
#define IS_TIM_CLOCK_DIVISION_INSTANCE(INSTANCE)   (((INSTANCE) == TIM1)  ||                                                      ((INSTANCE) == TIM2)  ||                                                      ((INSTANCE) == TIM3)  ||                                                      ((INSTANCE) == TIM4)  ||                                                      ((INSTANCE) == TIM5)  ||                                                      ((INSTANCE) == TIM9)  ||                                                      ((INSTANCE) == TIM12) ||                                                      ((INSTANCE) == TIM13) ||                                                      ((INSTANCE) == TIM14) ||                                                      ((INSTANCE) == TIM15) ||                                                      ((INSTANCE) == TIM16) ||                                                      ((INSTANCE) == TIM17))
#define IS_TIM_COUNTER_MODE_SELECT_INSTANCE(INSTANCE)  (((INSTANCE) == TIM1)  ||                                                          ((INSTANCE) == TIM2)  ||                                                          ((INSTANCE) == TIM3)  ||                                                          ((INSTANCE) == TIM4)  ||                                                          ((INSTANCE) == TIM5))
#define IS_TIM_ENCODER_INTERFACE_INSTANCE(INSTANCE)  (((INSTANCE) == TIM1)  ||                                                        ((INSTANCE) == TIM2)  ||                                                        ((INSTANCE) == TIM3)  ||                                                        ((INSTANCE) == TIM4)  ||                                                        ((INSTANCE) == TIM5))
#define IS_TIM_HALL_SENSOR_INTERFACE_INSTANCE(INSTANCE) (((INSTANCE) == TIM1)  ||                                                           ((INSTANCE) == TIM2)  ||                                                           ((INSTANCE) == TIM3)  ||                                                           ((INSTANCE) == TIM4)  ||                                                           ((INSTANCE) == TIM5)  ||                                                           ((INSTANCE) == TIM9)  ||                                                           ((INSTANCE) == TIM12) ||                                                           ((INSTANCE) == TIM15))
#define IS_TIM_INSTANCE(INSTANCE)       (((INSTANCE) == TIM1)  ||                                           ((INSTANCE) == TIM2)  ||                                           ((INSTANCE) == TIM3)  ||                                           ((INSTANCE) == TIM4)  ||                                           ((INSTANCE) == TIM5)  ||                                           ((INSTANCE) == TIM6)  ||                                           ((INSTANCE) == TIM7)  ||                                           ((INSTANCE) == TIM9)  ||                                           ((INSTANCE) == TIM12) ||                                           ((INSTANCE) == TIM13) ||                                           ((INSTANCE) == TIM14) ||                                           ((INSTANCE) == TIM15) ||                                           ((INSTANCE) == TIM16) ||                                           ((INSTANCE) == TIM17))
#define IS_TIM_REPETITION_COUNTER_INSTANCE(INSTANCE)  (((INSTANCE) == TIM1)  ||                                                         ((INSTANCE) == TIM15) ||                                                         ((INSTANCE) == TIM16) ||                                                         ((INSTANCE) == TIM17))
#define LPTIM1_BASE                     (APB1PERIPH_BASE + 0x2400UL)
#define LPTIM2_BASE                     (APB4PERIPH_BASE + 0x2400UL)
#define LPTIM3_BASE                     (APB4PERIPH_BASE + 0x2800UL)
#define LPTIM4_BASE                     (APB4PERIPH_BASE + 0x2C00UL)
#define LPTIM5_BASE                     (APB4PERIPH_BASE + 0x3000UL)
#define LPTIM_ARR_ARR                  LPTIM_ARR_ARR_Msk                       /*!< Auto reload register */
#define LPTIM_ARR_ARR_Msk              (0xFFFFUL << LPTIM_ARR_ARR_Pos)         /*!< 0x0000FFFF */
#define LPTIM_ARR_ARR_Pos              (0U)
#define LPTIM_CCMR1_CC1E_Pos           (1U)
#define LPTIM_CCMR1_CC1P               LPTIM_CCMR1_CC1P_Msk                    /*!< Capture/Compare 1 output polarity */
#define LPTIM_CCMR1_CC1P_0             (0x1UL << LPTIM_CCMR1_CC1P_Pos)         /*!< 0x00000004 */
#define LPTIM_CCMR1_CC1P_1             (0x2UL << LPTIM_CCMR1_CC1P_Pos)         /*!< 0x00000008 */
#define LPTIM_CCMR1_CC1P_Msk           (0x3UL << LPTIM_CCMR1_CC1P_Pos)         /*!< 0x0000000C */
#define LPTIM_CCMR1_CC1P_Pos           (2U)
#define LPTIM_CCMR1_CC1SEL             LPTIM_CCMR1_CC1SEL_Msk                  /*!< Capture/Compare 1 selection */
#define LPTIM_CCMR1_CC1SEL_Msk         (0x1UL << LPTIM_CCMR1_CC1SEL_Pos)       /*!< 0x00000001 */
#define LPTIM_CCMR1_CC1SEL_Pos         (0U)
#define LPTIM_CCMR1_CC2E_Pos           (17U)
#define LPTIM_CCMR1_IC1F               LPTIM_CCMR1_IC1F_Msk                    /*!< Input capture 1 filter */
#define LPTIM_CCMR1_IC1F_0             (0x1UL << LPTIM_CCMR1_IC1F_Pos)         /*!< 0x00001000 */
#define LPTIM_CCMR1_IC1F_1             (0x2UL << LPTIM_CCMR1_IC1F_Pos)         /*!< 0x00002000 */
#define LPTIM_CCMR1_IC1F_Msk           (0x3UL << LPTIM_CCMR1_IC1F_Pos)         /*!< 0x00003000 */
#define LPTIM_CCMR1_IC1F_Pos           (12U)
#define LPTIM_CCMR1_IC1PSC             LPTIM_CCMR1_IC1PSC_Msk                  /*!< Input capture 1 prescaler */
#define LPTIM_CCMR1_IC1PSC_0           (0x1UL << LPTIM_CCMR1_IC1PSC_Pos)       /*!< 0x00000100 */
#define LPTIM_CCMR1_IC1PSC_1           (0x2UL << LPTIM_CCMR1_IC1PSC_Pos)       /*!< 0x00000200 */
#define LPTIM_CCMR1_IC1PSC_Msk         (0x3UL << LPTIM_CCMR1_IC1PSC_Pos)       /*!< 0x00000300 */
#define LPTIM_CCMR1_IC1PSC_Pos         (8U)
#define LPTIM_CCR1_CCR1                LPTIM_CCR1_CCR1_Msk                     /*!< Compare register 1 */
#define LPTIM_CCR1_CCR1_Msk            (0xFFFFUL << LPTIM_CCR1_CCR1_Pos)       /*!< 0x0000FFFF */
#define LPTIM_CCR1_CCR1_Pos            (0U)
#define LPTIM_CCR2_CCR2                LPTIM_CCR2_CCR2_Msk                     /*!< Compare register 2 */
#define LPTIM_CCR2_CCR2_Msk            (0xFFFFUL << LPTIM_CCR2_CCR2_Pos)       /*!< 0x0000FFFF */
#define LPTIM_CCR2_CCR2_Pos            (0U)
#define LPTIM_CFGR2_IC1SEL             LPTIM_CFGR2_IC1SEL_Msk                  /*!< IC1SEL[17:16] bits */
#define LPTIM_CFGR2_IC1SEL_Msk         (0x3UL << LPTIM_CFGR2_IC1SEL_Pos)       /*!< 0x00000003 */
#define LPTIM_CFGR2_IC1SEL_Pos         (16U)
#define LPTIM_CFGR2_IC2SEL             LPTIM_CFGR2_IC2SEL_Msk                  /*!< IC2SEL[21:20] bits */
#define LPTIM_CFGR2_IC2SEL_0           (0x1UL << LPTIM_CFGR2_IC2SEL_Pos)       /*!< 0x00100000 */
#define LPTIM_CFGR2_IC2SEL_1           (0x2UL << LPTIM_CFGR2_IC2SEL_Pos)       /*!< 0x00200000 */
#define LPTIM_CFGR2_IC2SEL_Msk         (0x3UL << LPTIM_CFGR2_IC2SEL_Pos)       /*!< 0x00000030 */
#define LPTIM_CFGR2_IC2SEL_Pos         (20U)
#define LPTIM_CFGR2_IN1SEL             LPTIM_CFGR2_IN1SEL_Msk                  /*!< IN1SEL[1:0] bits (Remap selection) */
#define LPTIM_CFGR2_IN1SEL_Msk         (0x3UL << LPTIM_CFGR2_IN1SEL_Pos)       /*!< 0x00000003 */
#define LPTIM_CFGR2_IN1SEL_Pos         (0U)
#define LPTIM_CFGR2_IN2SEL             LPTIM_CFGR2_IN2SEL_Msk                  /*!< IN2SEL[5:4] bits (Remap selection) */
#define LPTIM_CFGR2_IN2SEL_Msk         (0x3UL << LPTIM_CFGR2_IN2SEL_Pos)       /*!< 0x00000030 */
#define LPTIM_CFGR2_IN2SEL_Pos         (4U)
#define LPTIM_CFGR_CKFLT               LPTIM_CFGR_CKFLT_Msk                    /*!< CKFLT[1:0] bits (Configurable digital filter for external clock) */
#define LPTIM_CFGR_CKFLT_0             (0x1UL << LPTIM_CFGR_CKFLT_Pos)         /*!< 0x00000008 */
#define LPTIM_CFGR_CKFLT_1             (0x2UL << LPTIM_CFGR_CKFLT_Pos)         /*!< 0x00000010 */
#define LPTIM_CFGR_CKFLT_Msk           (0x3UL << LPTIM_CFGR_CKFLT_Pos)         /*!< 0x00000018 */
#define LPTIM_CFGR_CKFLT_Pos           (3U)
#define LPTIM_CFGR_CKPOL               LPTIM_CFGR_CKPOL_Msk                    /*!< CKPOL[1:0] bits (Clock polarity) */
#define LPTIM_CFGR_CKPOL_0             (0x1UL << LPTIM_CFGR_CKPOL_Pos)         /*!< 0x00000002 */
#define LPTIM_CFGR_CKPOL_1             (0x2UL << LPTIM_CFGR_CKPOL_Pos)         /*!< 0x00000004 */
#define LPTIM_CFGR_CKPOL_Msk           (0x3UL << LPTIM_CFGR_CKPOL_Pos)         /*!< 0x00000006 */
#define LPTIM_CFGR_CKPOL_Pos           (1U)
#define LPTIM_CFGR_CKSEL               LPTIM_CFGR_CKSEL_Msk                    /*!< Clock selector */
#define LPTIM_CFGR_CKSEL_Msk           (0x1UL << LPTIM_CFGR_CKSEL_Pos)         /*!< 0x00000001 */
#define LPTIM_CFGR_CKSEL_Pos           (0U)
#define LPTIM_CFGR_COUNTMODE           LPTIM_CFGR_COUNTMODE_Msk                /*!< Counter mode enable */
#define LPTIM_CFGR_COUNTMODE_Msk       (0x1UL << LPTIM_CFGR_COUNTMODE_Pos)     /*!< 0x00800000 */
#define LPTIM_CFGR_COUNTMODE_Pos       (23U)
#define LPTIM_CFGR_ENC                 LPTIM_CFGR_ENC_Msk                      /*!< Encoder mode enable */
#define LPTIM_CFGR_ENC_Msk             (0x1UL << LPTIM_CFGR_ENC_Pos)           /*!< 0x01000000 */
#define LPTIM_CFGR_ENC_Pos             (24U)
#define LPTIM_CFGR_PRELOAD             LPTIM_CFGR_PRELOAD_Msk                  /*!< Reg update mode */
#define LPTIM_CFGR_PRELOAD_Msk         (0x1UL << LPTIM_CFGR_PRELOAD_Pos)       /*!< 0x00400000 */
#define LPTIM_CFGR_PRELOAD_Pos         (22U)
#define LPTIM_CFGR_PRESC               LPTIM_CFGR_PRESC_Msk                    /*!< PRESC[2:0] bits (Clock prescaler) */
#define LPTIM_CFGR_PRESC_0             (0x1UL << LPTIM_CFGR_PRESC_Pos)         /*!< 0x00000200 */
#define LPTIM_CFGR_PRESC_1             (0x2UL << LPTIM_CFGR_PRESC_Pos)         /*!< 0x00000400 */
#define LPTIM_CFGR_PRESC_2             (0x4UL << LPTIM_CFGR_PRESC_Pos)         /*!< 0x00000800 */
#define LPTIM_CFGR_PRESC_Msk           (0x7UL << LPTIM_CFGR_PRESC_Pos)         /*!< 0x00000E00 */
#define LPTIM_CFGR_PRESC_Pos           (9U)
#define LPTIM_CFGR_TIMOUT              LPTIM_CFGR_TIMOUT_Msk                   /*!< Timout enable */
#define LPTIM_CFGR_TIMOUT_Msk          (0x1UL << LPTIM_CFGR_TIMOUT_Pos)        /*!< 0x00080000 */
#define LPTIM_CFGR_TIMOUT_Pos          (19U)
#define LPTIM_CFGR_TRGFLT              LPTIM_CFGR_TRGFLT_Msk                   /*!< TRGFLT[1:0] bits (Configurable digital filter for trigger) */
#define LPTIM_CFGR_TRGFLT_0            (0x1UL << LPTIM_CFGR_TRGFLT_Pos)        /*!< 0x00000040 */
#define LPTIM_CFGR_TRGFLT_1            (0x2UL << LPTIM_CFGR_TRGFLT_Pos)        /*!< 0x00000080 */
#define LPTIM_CFGR_TRGFLT_Msk          (0x3UL << LPTIM_CFGR_TRGFLT_Pos)        /*!< 0x000000C0 */
#define LPTIM_CFGR_TRGFLT_Pos          (6U)
#define LPTIM_CFGR_TRIGEN              LPTIM_CFGR_TRIGEN_Msk                   /*!< TRIGEN[1:0] bits (Trigger enable and polarity) */
#define LPTIM_CFGR_TRIGEN_0            (0x1UL << LPTIM_CFGR_TRIGEN_Pos)        /*!< 0x00020000 */
#define LPTIM_CFGR_TRIGEN_1            (0x2UL << LPTIM_CFGR_TRIGEN_Pos)        /*!< 0x00040000 */
#define LPTIM_CFGR_TRIGEN_Msk          (0x3UL << LPTIM_CFGR_TRIGEN_Pos)        /*!< 0x00060000 */
#define LPTIM_CFGR_TRIGEN_Pos          (17U)
#define LPTIM_CFGR_TRIGSEL             LPTIM_CFGR_TRIGSEL_Msk                  /*!< TRIGSEL[2:0]] bits (Trigger selector) */
#define LPTIM_CFGR_TRIGSEL_0           (0x1UL << LPTIM_CFGR_TRIGSEL_Pos)       /*!< 0x00002000 */
#define LPTIM_CFGR_TRIGSEL_1           (0x2UL << LPTIM_CFGR_TRIGSEL_Pos)       /*!< 0x00004000 */
#define LPTIM_CFGR_TRIGSEL_2           (0x4UL << LPTIM_CFGR_TRIGSEL_Pos)       /*!< 0x00008000 */
#define LPTIM_CFGR_TRIGSEL_Msk         (0x7UL << LPTIM_CFGR_TRIGSEL_Pos)       /*!< 0x0000E000 */
#define LPTIM_CFGR_TRIGSEL_Pos         (13U)
#define LPTIM_CFGR_WAVE                LPTIM_CFGR_WAVE_Msk                     /*!< Waveform shape */
#define LPTIM_CFGR_WAVE_Msk            (0x1UL << LPTIM_CFGR_WAVE_Pos)          /*!< 0x00100000 */
#define LPTIM_CFGR_WAVE_Pos            (20U)
#define LPTIM_CFGR_WAVPOL              LPTIM_CFGR_WAVPOL_Msk                   /*!< Waveform shape */
#define LPTIM_CFGR_WAVPOL_Msk          (0x1UL << LPTIM_CFGR_WAVPOL_Pos)        /*!< 0x00200000 */
#define LPTIM_CFGR_WAVPOL_Pos          (21U)
#define LPTIM_CNT_CNT                  LPTIM_CNT_CNT_Msk                       /*!< Counter register */
#define LPTIM_CNT_CNT_Msk              (0xFFFFUL << LPTIM_CNT_CNT_Pos)         /*!< 0x0000FFFF */
#define LPTIM_CNT_CNT_Pos              (0U)
#define LPTIM_CR_CNTSTRT               LPTIM_CR_CNTSTRT_Msk                    /*!< Timer start in continuous mode */
#define LPTIM_CR_CNTSTRT_Msk           (0x1UL << LPTIM_CR_CNTSTRT_Pos)         /*!< 0x00000004 */
#define LPTIM_CR_CNTSTRT_Pos           (2U)
#define LPTIM_CR_COUNTRST              LPTIM_CR_COUNTRST_Msk                   /*!< Timer Counter reset in synchronous mode*/
#define LPTIM_CR_COUNTRST_Msk          (0x1UL << LPTIM_CR_COUNTRST_Pos)        /*!< 0x00000008 */
#define LPTIM_CR_COUNTRST_Pos          (3U)
#define LPTIM_CR_ENABLE                LPTIM_CR_ENABLE_Msk                     /*!< LPTIMer enable */
#define LPTIM_CR_ENABLE_Msk            (0x1UL << LPTIM_CR_ENABLE_Pos)          /*!< 0x00000001 */
#define LPTIM_CR_ENABLE_Pos            (0U)
#define LPTIM_CR_RSTARE                LPTIM_CR_RSTARE_Msk                     /*!< Timer Counter reset after read enable (asynchronously)*/
#define LPTIM_CR_RSTARE_Msk            (0x1UL << LPTIM_CR_RSTARE_Pos)          /*!< 0x00000010 */
#define LPTIM_CR_RSTARE_Pos            (4U)
#define LPTIM_CR_SNGSTRT               LPTIM_CR_SNGSTRT_Msk                    /*!< Timer start in single mode */
#define LPTIM_CR_SNGSTRT_Msk           (0x1UL << LPTIM_CR_SNGSTRT_Pos)         /*!< 0x00000002 */
#define LPTIM_CR_SNGSTRT_Pos           (1U)
#define LPTIM_DIER_ARRMIE              LPTIM_DIER_ARRMIE_Msk                   /*!< Autoreload match interrupt enable */
#define LPTIM_DIER_ARRMIE_Msk          (0x1UL << LPTIM_DIER_ARRMIE_Pos)        /*!< 0x00000002 */
#define LPTIM_DIER_ARRMIE_Pos          (1U)
#define LPTIM_DIER_ARROKIE             LPTIM_DIER_ARROKIE_Msk                  /*!< Autoreload register update OK interrupt enable */
#define LPTIM_DIER_ARROKIE_Msk         (0x1UL << LPTIM_DIER_ARROKIE_Pos)       /*!< 0x00000010 */
#define LPTIM_DIER_ARROKIE_Pos         (4U)
#define LPTIM_DIER_CC1DE               LPTIM_DIER_CC1DE_Msk                    /*!< Capture/Compare 1 DMA request enable */
#define LPTIM_DIER_CC1DE_Msk           (0x1UL << LPTIM_DIER_CC1DE_Pos)         /*!< 0x00010000 */
#define LPTIM_DIER_CC1DE_Pos           (16U)
#define LPTIM_DIER_CC1IE               LPTIM_DIER_CC1IE_Msk                    /*!< Compare/Compare 1 interrupt enable */
#define LPTIM_DIER_CC1IE_Msk           (0x1UL << LPTIM_DIER_CC1IE_Pos)         /*!< 0x00000001 */
#define LPTIM_DIER_CC1IE_Pos           (0U)
#define LPTIM_DIER_CC1OIE              LPTIM_DIER_CC1OIE_Msk                   /*!< Capture/Compare 1 over-capture interrupt enable */
#define LPTIM_DIER_CC1OIE_Msk          (0x1UL << LPTIM_DIER_CC1OIE_Pos)        /*!< 0x00001000 */
#define LPTIM_DIER_CC1OIE_Pos          (12U)
#define LPTIM_DIER_CC2DE               LPTIM_DIER_CC2DE_Msk                    /*!< Capture/Compare 2 DMA request enable */
#define LPTIM_DIER_CC2DE_Msk           (0x1UL << LPTIM_DIER_CC2DE_Pos)         /*!< 0x02000000 */
#define LPTIM_DIER_CC2DE_Pos           (25U)
#define LPTIM_DIER_CC2IE               LPTIM_DIER_CC2IE_Msk                    /*!< Capture/Compare 2 interrupt interrupt enable */
#define LPTIM_DIER_CC2IE_Msk           (0x1UL << LPTIM_DIER_CC2IE_Pos)         /*!< 0x00000200 */
#define LPTIM_DIER_CC2IE_Pos           (9U)
#define LPTIM_DIER_CC2OIE              LPTIM_DIER_CC2OIE_Msk                   /*!< Capture/Compare 2 over-capture interrupt enable */
#define LPTIM_DIER_CC2OIE_Msk          (0x1UL << LPTIM_DIER_CC2OIE_Pos)        /*!< 0x00002000 */
#define LPTIM_DIER_CC2OIE_Pos          (13U)
#define LPTIM_DIER_CMP1OKIE            LPTIM_DIER_CMP1OKIE_Msk                 /*!< Compare register 1 update OK interrupt enable */
#define LPTIM_DIER_CMP1OKIE_Msk        (0x1UL << LPTIM_DIER_CMP1OKIE_Pos)      /*!< 0x00000008 */
#define LPTIM_DIER_CMP1OKIE_Pos        (3U)
#define LPTIM_DIER_CMP2OKIE            LPTIM_DIER_CMP2OKIE_Msk                 /*!< Compare register 2 update OK interrupt enable */
#define LPTIM_DIER_CMP2OKIE_Msk        (0x1UL << LPTIM_DIER_CMP2OKIE_Pos)      /*!< 0x00080000 */
#define LPTIM_DIER_CMP2OKIE_Pos        (19U)
#define LPTIM_DIER_DOWNIE              LPTIM_DIER_DOWNIE_Msk                   /*!< Counter direction change up to down interrupt enable */
#define LPTIM_DIER_DOWNIE_Msk          (0x1UL << LPTIM_DIER_DOWNIE_Pos)        /*!< 0x00000040 */
#define LPTIM_DIER_DOWNIE_Pos          (6U)
#define LPTIM_DIER_EXTTRIGIE           LPTIM_DIER_EXTTRIGIE_Msk                /*!< External trigger edge event interrupt enable */
#define LPTIM_DIER_EXTTRIGIE_Msk       (0x1UL << LPTIM_DIER_EXTTRIGIE_Pos)     /*!< 0x00000004 */
#define LPTIM_DIER_EXTTRIGIE_Pos       (2U)
#define LPTIM_DIER_REPOKIE             LPTIM_DIER_REPOKIE_Msk                  /*!< Repetition register update OK interrupt enable */
#define LPTIM_DIER_REPOKIE_Msk         (0x1UL << LPTIM_DIER_REPOKIE_Pos)       /*!< 0x00000100 */
#define LPTIM_DIER_REPOKIE_Pos         (8U)
#define LPTIM_DIER_UEDE                LPTIM_DIER_UEDE_Msk                     /*!< Update event DMA request enable */
#define LPTIM_DIER_UEDE_Msk            (0x1UL << LPTIM_DIER_UEDE_Pos)          /*!< 0x00800000 */
#define LPTIM_DIER_UEDE_Pos            (23U)
#define LPTIM_DIER_UEIE                LPTIM_DIER_UEIE_Msk                     /*!< Update event interrupt enable */
#define LPTIM_DIER_UEIE_Msk            (0x1UL << LPTIM_DIER_UEIE_Pos)          /*!< 0x00000080 */
#define LPTIM_DIER_UEIE_Pos            (7U)
#define LPTIM_DIER_UPIE                LPTIM_DIER_UPIE_Msk                     /*!< Counter direction change down to up interrupt enable */
#define LPTIM_DIER_UPIE_Msk            (0x1UL << LPTIM_DIER_UPIE_Pos)          /*!< 0x00000020 */
#define LPTIM_DIER_UPIE_Pos            (5U)
#define LPTIM_ICR_ARRMCF               LPTIM_ICR_ARRMCF_Msk                    /*!< Autoreload match clear flag */
#define LPTIM_ICR_ARRMCF_Msk           (0x1UL << LPTIM_ICR_ARRMCF_Pos)         /*!< 0x00000002 */
#define LPTIM_ICR_ARRMCF_Pos           (1U)
#define LPTIM_ICR_ARROKCF              LPTIM_ICR_ARROKCF_Msk                   /*!< Autoreload register update OK clear flag */
#define LPTIM_ICR_ARROKCF_Msk          (0x1UL << LPTIM_ICR_ARROKCF_Pos)        /*!< 0x00000010 */
#define LPTIM_ICR_ARROKCF_Pos          (4U)
#define LPTIM_ICR_CC1CF                LPTIM_ICR_CC1CF_Msk                     /*!< Capture/Compare 1 clear flag  */
#define LPTIM_ICR_CC1CF_Msk            (0x1UL << LPTIM_ICR_CC1CF_Pos)          /*!< 0x00000001 */
#define LPTIM_ICR_CC1CF_Pos            (0U)
#define LPTIM_ICR_CC1OCF               LPTIM_ICR_CC1OCF_Msk                    /*!< Capture/Compare 1 over-capture clear flag */
#define LPTIM_ICR_CC1OCF_Msk           (0x1UL << LPTIM_ICR_CC1OCF_Pos)         /*!< 0x00001000 */
#define LPTIM_ICR_CC1OCF_Pos           (12U)
#define LPTIM_ICR_CC2CF                LPTIM_ICR_CC2CF_Msk                     /*!< Capture/Compare 2 clear flag  */
#define LPTIM_ICR_CC2CF_Msk            (0x1UL << LPTIM_ICR_CC2CF_Pos)          /*!< 0x00000200 */
#define LPTIM_ICR_CC2CF_Pos            (9U)
#define LPTIM_ICR_CC2OCF               LPTIM_ICR_CC2OCF_Msk                    /*!< Capture/Compare 2 over-capture clear flag */
#define LPTIM_ICR_CC2OCF_Msk           (0x1UL << LPTIM_ICR_CC2OCF_Pos)         /*!< 0x00002000 */
#define LPTIM_ICR_CC2OCF_Pos           (13U)
#define LPTIM_ICR_CMP1OKCF             LPTIM_ICR_CMP1OKCF_Msk                  /*!< Compare register 1 update OK clear flag */
#define LPTIM_ICR_CMP1OKCF_Msk         (0x1UL << LPTIM_ICR_CMP1OKCF_Pos)       /*!< 0x00000008 */
#define LPTIM_ICR_CMP1OKCF_Pos         (3U)
#define LPTIM_ICR_CMP2OKCF             LPTIM_ICR_CMP2OKCF_Msk                  /*!< Compare register 2 update OK clear flag */
#define LPTIM_ICR_CMP2OKCF_Msk         (0x1UL << LPTIM_ICR_CMP2OKCF_Pos)       /*!< 0x00080000 */
#define LPTIM_ICR_CMP2OKCF_Pos         (19U)
#define LPTIM_ICR_DIEROKCF             LPTIM_ICR_DIEROKCF_Msk                  /*!< Interrupt enable register update OK clear flag */
#define LPTIM_ICR_DIEROKCF_Msk         (0x1UL << LPTIM_ICR_DIEROKCF_Pos)       /*!< 0x01000000 */
#define LPTIM_ICR_DIEROKCF_Pos         (24U)
#define LPTIM_ICR_DOWNCF               LPTIM_ICR_DOWNCF_Msk                    /*!< Counter direction change up to down clear flag */
#define LPTIM_ICR_DOWNCF_Msk           (0x1UL << LPTIM_ICR_DOWNCF_Pos)         /*!< 0x00000040 */
#define LPTIM_ICR_DOWNCF_Pos           (6U)
#define LPTIM_ICR_EXTTRIGCF            LPTIM_ICR_EXTTRIGCF_Msk                 /*!< External trigger edge event clear flag */
#define LPTIM_ICR_EXTTRIGCF_Msk        (0x1UL << LPTIM_ICR_EXTTRIGCF_Pos)      /*!< 0x00000004 */
#define LPTIM_ICR_EXTTRIGCF_Pos        (2U)
#define LPTIM_ICR_REPOKCF              LPTIM_ICR_REPOKCF_Msk                   /*!< Repetition register update OK clear flag */
#define LPTIM_ICR_REPOKCF_Msk          (0x1UL << LPTIM_ICR_REPOKCF_Pos)        /*!< 0x00000100 */
#define LPTIM_ICR_REPOKCF_Pos          (8U)
#define LPTIM_ICR_UECF                 LPTIM_ICR_UECF_Msk                      /*!< Update event clear flag */
#define LPTIM_ICR_UECF_Msk             (0x1UL << LPTIM_ICR_UECF_Pos)           /*!< 0x00000080 */
#define LPTIM_ICR_UECF_Pos             (7U)
#define LPTIM_ICR_UPCF                 LPTIM_ICR_UPCF_Msk                      /*!< Counter direction change down to up clear flag */
#define LPTIM_ICR_UPCF_Msk             (0x1UL << LPTIM_ICR_UPCF_Pos)           /*!< 0x00000020 */
#define LPTIM_ICR_UPCF_Pos             (5U)
#define LPTIM_ISR_ARRM                 LPTIM_ISR_ARRM_Msk                      /*!< Autoreload match */
#define LPTIM_ISR_ARRM_Msk             (0x1UL << LPTIM_ISR_ARRM_Pos)           /*!< 0x00000002 */
#define LPTIM_ISR_ARRM_Pos             (1U)
#define LPTIM_ISR_ARROK                LPTIM_ISR_ARROK_Msk                     /*!< Autoreload register update OK */
#define LPTIM_ISR_ARROK_Msk            (0x1UL << LPTIM_ISR_ARROK_Pos)          /*!< 0x00000010 */
#define LPTIM_ISR_ARROK_Pos            (4U)
#define LPTIM_ISR_CC1IF                LPTIM_ISR_CC1IF_Msk                     /*!< Capture/Compare 1 interrupt flag */
#define LPTIM_ISR_CC1IF_Msk            (0x1UL << LPTIM_ISR_CC1IF_Pos)          /*!< 0x00000001 */
#define LPTIM_ISR_CC1IF_Pos            (0U)
#define LPTIM_ISR_CC1OF                LPTIM_ISR_CC1OF_Msk                     /*!< Capture/Compare 1 over-capture flag */
#define LPTIM_ISR_CC1OF_Msk            (0x1UL << LPTIM_ISR_CC1OF_Pos)          /*!< 0x00001000 */
#define LPTIM_ISR_CC1OF_Pos            (12U)
#define LPTIM_ISR_CC2IF                LPTIM_ISR_CC2IF_Msk                     /*!< Capture/Compare 2 interrupt flag */
#define LPTIM_ISR_CC2IF_Msk            (0x1UL << LPTIM_ISR_CC2IF_Pos)          /*!< 0x00000200 */
#define LPTIM_ISR_CC2IF_Pos            (9U)
#define LPTIM_ISR_CC2OF                LPTIM_ISR_CC2OF_Msk                     /*!< Capture/Compare 2 over-capture flag */
#define LPTIM_ISR_CC2OF_Msk            (0x1UL << LPTIM_ISR_CC2OF_Pos)          /*!< 0x00002000 */
#define LPTIM_ISR_CC2OF_Pos            (13U)
#define LPTIM_ISR_CMP1OK               LPTIM_ISR_CMP1OK_Msk                    /*!< Compare register 1 update OK */
#define LPTIM_ISR_CMP1OK_Msk           (0x1UL << LPTIM_ISR_CMP1OK_Pos)         /*!< 0x00000008 */
#define LPTIM_ISR_CMP1OK_Pos           (3U)
#define LPTIM_ISR_CMP2OK               LPTIM_ISR_CMP2OK_Msk                    /*!< Compare register 2 update OK */
#define LPTIM_ISR_CMP2OK_Msk           (0x1UL << LPTIM_ISR_CMP2OK_Pos)         /*!< 0x00080000 */
#define LPTIM_ISR_CMP2OK_Pos           (19U)
#define LPTIM_ISR_DIEROK               LPTIM_ISR_DIEROK_Msk                    /*!< Interrupt enable register update OK */
#define LPTIM_ISR_DIEROK_Msk           (0x1UL << LPTIM_ISR_DIEROK_Pos)         /*!< 0x01000000 */
#define LPTIM_ISR_DIEROK_Pos           (24U)
#define LPTIM_ISR_DOWN                 LPTIM_ISR_DOWN_Msk                      /*!< Counter direction change up to down */
#define LPTIM_ISR_DOWN_Msk             (0x1UL << LPTIM_ISR_DOWN_Pos)           /*!< 0x00000040 */
#define LPTIM_ISR_DOWN_Pos             (6U)
#define LPTIM_ISR_EXTTRIG              LPTIM_ISR_EXTTRIG_Msk                   /*!< External trigger edge event */
#define LPTIM_ISR_EXTTRIG_Msk          (0x1UL << LPTIM_ISR_EXTTRIG_Pos)        /*!< 0x00000004 */
#define LPTIM_ISR_EXTTRIG_Pos          (2U)
#define LPTIM_ISR_REPOK                LPTIM_ISR_REPOK_Msk                     /*!< Repetition register update OK */
#define LPTIM_ISR_REPOK_Msk            (0x1UL << LPTIM_ISR_REPOK_Pos)          /*!< 0x00000100 */
#define LPTIM_ISR_REPOK_Pos            (8U)
#define LPTIM_ISR_UE                   LPTIM_ISR_UE_Msk                        /*!< Update event */
#define LPTIM_ISR_UE_Msk               (0x1UL << LPTIM_ISR_UE_Pos)             /*!< 0x00000080 */
#define LPTIM_ISR_UE_Pos               (7U)
#define LPTIM_ISR_UP                   LPTIM_ISR_UP_Msk                        /*!< Counter direction change down to up */
#define LPTIM_ISR_UP_Msk               (0x1UL << LPTIM_ISR_UP_Pos)             /*!< 0x00000020 */
#define LPTIM_ISR_UP_Pos               (5U)
#define LPTIM_RCR_REP                  LPTIM_RCR_REP_Msk                       /*!< Repetition register value */
#define LPTIM_RCR_REP_Msk              (0xFFUL << LPTIM_RCR_REP_Pos)           /*!< 0x000000FF */
#define LPTIM_RCR_REP_Pos              (0U)
#define PERIPH_BASE                     0x40000000UL  /*!< AHB and APB Peripherals base address */
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
#define TIM12_BASE                      (APB1PERIPH_BASE + 0x1800UL)
#define TIM13_BASE                      (APB1PERIPH_BASE + 0x1C00UL)
#define TIM14_BASE                      (APB1PERIPH_BASE + 0x2000UL)
#define TIM15_BASE                      (APB2PERIPH_BASE + 0x4000UL)
#define TIM16_BASE                      (APB2PERIPH_BASE + 0x4400UL)
#define TIM17_BASE                      (APB2PERIPH_BASE + 0x4800UL)
#define TIM1_BASE                       (APB2PERIPH_BASE + 0x0000UL)
#define TIM2_BASE                       (APB1PERIPH_BASE + 0x0000UL)
#define TIM3_BASE                       (APB1PERIPH_BASE + 0x0400UL)
#define TIM4_BASE                       (APB1PERIPH_BASE + 0x0800UL)
#define TIM5_BASE                       (APB1PERIPH_BASE + 0x0C00UL)
#define TIM6_BASE                       (APB1PERIPH_BASE + 0x1000UL)
#define TIM7_BASE                       (APB1PERIPH_BASE + 0x1400UL)
#define TIM9_BASE                       (APB2PERIPH_BASE + 0x4C00UL)
#define TIM_AF1_BKINE                      TIM_AF1_BKINE_Msk                      /*!<BRK BKIN input enable */
#define TIM_AF1_BKINE_Msk                  (0x1UL << TIM_AF1_BKINE_Pos)           /*!< 0x00000001 */
#define TIM_AF1_BKINE_Pos                  (0U)
#define TIM_AF1_BKINP                      TIM_AF1_BKINP_Msk                      /*!<BRK BKIN input polarity */
#define TIM_AF1_BKINP_Msk                  (0x1UL << TIM_AF1_BKINP_Pos)           /*!< 0x00000200 */
#define TIM_AF1_BKINP_Pos                  (9U)
#define TIM_AF1_ETRSEL                     TIM_AF1_ETRSEL_Msk                     /*!<ETRSEL[3:0] bits (TIM1 ETR source selection) */
#define TIM_AF1_ETRSEL_0                   (0x1UL << TIM_AF1_ETRSEL_Pos)          /*!< 0x00004000 */
#define TIM_AF1_ETRSEL_1                   (0x2UL << TIM_AF1_ETRSEL_Pos)          /*!< 0x00008000 */
#define TIM_AF1_ETRSEL_2                   (0x4UL << TIM_AF1_ETRSEL_Pos)          /*!< 0x00010000 */
#define TIM_AF1_ETRSEL_3                   (0x8UL << TIM_AF1_ETRSEL_Pos)          /*!< 0x00020000 */
#define TIM_AF1_ETRSEL_Msk                 (0xFUL << TIM_AF1_ETRSEL_Pos)          /*!< 0x0003C000 */
#define TIM_AF1_ETRSEL_Pos                 (14U)
#define TIM_BDTR_AOE                        TIM_BDTR_AOE_Msk                        /*!<Automatic Output enable */
#define TIM_BDTR_AOE_Msk                    (0x1UL << TIM_BDTR_AOE_Pos)             /*!< 0x00004000 */
#define TIM_BDTR_AOE_Pos                    (14U)
#define TIM_BDTR_BK2BID                     TIM_BDTR_BK2BID_Msk                     /*!<Break2 BIDirectional */
#define TIM_BDTR_BK2BID_Msk                 (0x1UL << TIM_BDTR_BK2BID_Pos)          /*!< 0x20000000 */
#define TIM_BDTR_BK2BID_Pos                 (29U)
#define TIM_BDTR_BK2DSRM                    TIM_BDTR_BK2DSRM_Msk                    /*!<Break2 disarming/re-arming */
#define TIM_BDTR_BK2DSRM_Msk                (0x1UL << TIM_BDTR_BK2DSRM_Pos)         /*!< 0x08000000 */
#define TIM_BDTR_BK2DSRM_Pos                (27U)
#define TIM_BDTR_BK2E                       TIM_BDTR_BK2E_Msk                       /*!<Break enable for Break 2 */
#define TIM_BDTR_BK2E_Msk                   (0x1UL << TIM_BDTR_BK2E_Pos)            /*!< 0x01000000 */
#define TIM_BDTR_BK2E_Pos                   (24U)
#define TIM_BDTR_BK2F                       TIM_BDTR_BK2F_Msk                       /*!<Break Filter for Break 2 */
#define TIM_BDTR_BK2F_Msk                   (0xFUL << TIM_BDTR_BK2F_Pos)            /*!< 0x00F00000 */
#define TIM_BDTR_BK2F_Pos                   (20U)
#define TIM_BDTR_BK2P                       TIM_BDTR_BK2P_Msk                       /*!<Break Polarity for Break 2 */
#define TIM_BDTR_BK2P_Msk                   (0x1UL << TIM_BDTR_BK2P_Pos)            /*!< 0x02000000 */
#define TIM_BDTR_BK2P_Pos                   (25U)
#define TIM_BDTR_BKBID                      TIM_BDTR_BKBID_Msk                      /*!<Break BIDirectional */
#define TIM_BDTR_BKBID_Msk                  (0x1UL << TIM_BDTR_BKBID_Pos)           /*!< 0x10000000 */
#define TIM_BDTR_BKBID_Pos                  (28U)
#define TIM_BDTR_BKDSRM                     TIM_BDTR_BKDSRM_Msk                     /*!<Break disarming/re-arming */
#define TIM_BDTR_BKDSRM_Msk                 (0x1UL << TIM_BDTR_BKDSRM_Pos)          /*!< 0x04000000 */
#define TIM_BDTR_BKDSRM_Pos                 (26U)
#define TIM_BDTR_BKE                        TIM_BDTR_BKE_Msk                        /*!<Break enable for Break 1 */
#define TIM_BDTR_BKE_Msk                    (0x1UL << TIM_BDTR_BKE_Pos)             /*!< 0x00001000 */
#define TIM_BDTR_BKE_Pos                    (12U)
#define TIM_BDTR_BKF                        TIM_BDTR_BKF_Msk                        /*!<Break Filter for Break 1 */
#define TIM_BDTR_BKF_Msk                    (0xFUL << TIM_BDTR_BKF_Pos)             /*!< 0x000F0000 */
#define TIM_BDTR_BKF_Pos                    (16U)
#define TIM_BDTR_BKP                        TIM_BDTR_BKP_Msk                        /*!<Break Polarity for Break 1 */
#define TIM_BDTR_BKP_Msk                    (0x1UL << TIM_BDTR_BKP_Pos)             /*!< 0x00002000 */
#define TIM_BDTR_BKP_Pos                    (13U)
#define TIM_BDTR_DTG                        TIM_BDTR_DTG_Msk                        /*!<DTG[0:7] bits (Dead-Time Generator set-up) */
#define TIM_BDTR_DTG_Msk                    (0xFFUL << TIM_BDTR_DTG_Pos)            /*!< 0x000000FF */
#define TIM_BDTR_DTG_Pos                    (0U)
#define TIM_BDTR_LOCK                       TIM_BDTR_LOCK_Msk                       /*!<LOCK[1:0] bits (Lock Configuration) */
#define TIM_BDTR_LOCK_0                     (0x1UL << TIM_BDTR_LOCK_Pos)            /*!< 0x00000100 */
#define TIM_BDTR_LOCK_1                     (0x2UL << TIM_BDTR_LOCK_Pos)            /*!< 0x00000200 */
#define TIM_BDTR_LOCK_Msk                   (0x3UL << TIM_BDTR_LOCK_Pos)            /*!< 0x00000300 */
#define TIM_BDTR_LOCK_Pos                   (8U)
#define TIM_BDTR_MOE                        TIM_BDTR_MOE_Msk                        /*!<Main Output enable */
#define TIM_BDTR_MOE_Msk                    (0x1UL << TIM_BDTR_MOE_Pos)             /*!< 0x00008000 */
#define TIM_BDTR_MOE_Pos                    (15U)
#define TIM_BDTR_OSSI                       TIM_BDTR_OSSI_Msk                       /*!<Off-State Selection for Idle mode */
#define TIM_BDTR_OSSI_Msk                   (0x1UL << TIM_BDTR_OSSI_Pos)            /*!< 0x00000400 */
#define TIM_BDTR_OSSI_Pos                   (10U)
#define TIM_BDTR_OSSR                       TIM_BDTR_OSSR_Msk                       /*!<Off-State Selection for Run mode */
#define TIM_BDTR_OSSR_Msk                   (0x1UL << TIM_BDTR_OSSR_Pos)            /*!< 0x00000800 */
#define TIM_BDTR_OSSR_Pos                   (11U)
#define TIM_CCER_CC1E                       TIM_CCER_CC1E_Msk                       /*!<Capture/Compare 1 output enable */
#define TIM_CCER_CC1E_Msk                   (0x1UL << TIM_CCER_CC1E_Pos)            /*!< 0x00000001 */
#define TIM_CCER_CC1E_Pos                   (0U)
#define TIM_CCER_CC1NE                      TIM_CCER_CC1NE_Msk                      /*!<Capture/Compare 1 Complementary output enable */
#define TIM_CCER_CC1NE_Msk                  (0x1UL << TIM_CCER_CC1NE_Pos)           /*!< 0x00000004 */
#define TIM_CCER_CC1NE_Pos                  (2U)
#define TIM_CCER_CC1NP                      TIM_CCER_CC1NP_Msk                      /*!<Capture/Compare 1 Complementary output Polarity */
#define TIM_CCER_CC1NP_Msk                  (0x1UL << TIM_CCER_CC1NP_Pos)           /*!< 0x00000008 */
#define TIM_CCER_CC1NP_Pos                  (3U)
#define TIM_CCER_CC1P                       TIM_CCER_CC1P_Msk                       /*!<Capture/Compare 1 output Polarity */
#define TIM_CCER_CC1P_Msk                   (0x1UL << TIM_CCER_CC1P_Pos)            /*!< 0x00000002 */
#define TIM_CCER_CC1P_Pos                   (1U)
#define TIM_CCER_CC2E                       TIM_CCER_CC2E_Msk                       /*!<Capture/Compare 2 output enable */
#define TIM_CCER_CC2E_Msk                   (0x1UL << TIM_CCER_CC2E_Pos)            /*!< 0x00000010 */
#define TIM_CCER_CC2E_Pos                   (4U)
#define TIM_CCER_CC2NE                      TIM_CCER_CC2NE_Msk                      /*!<Capture/Compare 2 Complementary output enable */
#define TIM_CCER_CC2NE_Msk                  (0x1UL << TIM_CCER_CC2NE_Pos)           /*!< 0x00000040 */
#define TIM_CCER_CC2NE_Pos                  (6U)
#define TIM_CCER_CC2NP                      TIM_CCER_CC2NP_Msk                      /*!<Capture/Compare 2 Complementary output Polarity */
#define TIM_CCER_CC2NP_Msk                  (0x1UL << TIM_CCER_CC2NP_Pos)           /*!< 0x00000080 */
#define TIM_CCER_CC2NP_Pos                  (7U)
#define TIM_CCER_CC2P                       TIM_CCER_CC2P_Msk                       /*!<Capture/Compare 2 output Polarity */
#define TIM_CCER_CC2P_Msk                   (0x1UL << TIM_CCER_CC2P_Pos)            /*!< 0x00000020 */
#define TIM_CCER_CC2P_Pos                   (5U)
#define TIM_CCER_CC3E                       TIM_CCER_CC3E_Msk                       /*!<Capture/Compare 3 output enable */
#define TIM_CCER_CC3E_Msk                   (0x1UL << TIM_CCER_CC3E_Pos)            /*!< 0x00000100 */
#define TIM_CCER_CC3E_Pos                   (8U)
#define TIM_CCER_CC3NE                      TIM_CCER_CC3NE_Msk                      /*!<Capture/Compare 3 Complementary output enable */
#define TIM_CCER_CC3NE_Msk                  (0x1UL << TIM_CCER_CC3NE_Pos)           /*!< 0x00000400 */
#define TIM_CCER_CC3NE_Pos                  (10U)
#define TIM_CCER_CC3NP                      TIM_CCER_CC3NP_Msk                      /*!<Capture/Compare 3 Complementary output Polarity */
#define TIM_CCER_CC3NP_Msk                  (0x1UL << TIM_CCER_CC3NP_Pos)           /*!< 0x00000800 */
#define TIM_CCER_CC3NP_Pos                  (11U)
#define TIM_CCER_CC3P                       TIM_CCER_CC3P_Msk                       /*!<Capture/Compare 3 output Polarity */
#define TIM_CCER_CC3P_Msk                   (0x1UL << TIM_CCER_CC3P_Pos)            /*!< 0x00000200 */
#define TIM_CCER_CC3P_Pos                   (9U)
#define TIM_CCER_CC4E                       TIM_CCER_CC4E_Msk                       /*!<Capture/Compare 4 output enable */
#define TIM_CCER_CC4E_Msk                   (0x1UL << TIM_CCER_CC4E_Pos)            /*!< 0x00001000 */
#define TIM_CCER_CC4E_Pos                   (12U)
#define TIM_CCER_CC4NE                      TIM_CCER_CC4NE_Msk                      /*!<Capture/Compare 4 Complementary output enable */
#define TIM_CCER_CC4NE_Msk                  (0x1UL << TIM_CCER_CC4NE_Pos)           /*!< 0x00004000 */
#define TIM_CCER_CC4NE_Pos                  (14U)
#define TIM_CCER_CC4NP                      TIM_CCER_CC4NP_Msk                      /*!<Capture/Compare 4 Complementary output Polarity */
#define TIM_CCER_CC4NP_Msk                  (0x1UL << TIM_CCER_CC4NP_Pos)           /*!< 0x00008000 */
#define TIM_CCER_CC4NP_Pos                  (15U)
#define TIM_CCER_CC4P                       TIM_CCER_CC4P_Msk                       /*!<Capture/Compare 4 output Polarity */
#define TIM_CCER_CC4P_Msk                   (0x1UL << TIM_CCER_CC4P_Pos)            /*!< 0x00002000 */
#define TIM_CCER_CC4P_Pos                   (13U)
#define TIM_CCER_CC5E                       TIM_CCER_CC5E_Msk                       /*!<Capture/Compare 5 output enable */
#define TIM_CCER_CC5E_Msk                   (0x1UL << TIM_CCER_CC5E_Pos)            /*!< 0x00010000 */
#define TIM_CCER_CC5E_Pos                   (16U)
#define TIM_CCER_CC5P                       TIM_CCER_CC5P_Msk                       /*!<Capture/Compare 5 output Polarity */
#define TIM_CCER_CC5P_Msk                   (0x1UL << TIM_CCER_CC5P_Pos)            /*!< 0x00020000 */
#define TIM_CCER_CC5P_Pos                   (17U)
#define TIM_CCER_CC6E                       TIM_CCER_CC6E_Msk                       /*!<Capture/Compare 6 output enable */
#define TIM_CCER_CC6E_Msk                   (0x1UL << TIM_CCER_CC6E_Pos)            /*!< 0x00100000 */
#define TIM_CCER_CC6E_Pos                   (20U)
#define TIM_CCER_CC6P                       TIM_CCER_CC6P_Msk                       /*!<Capture/Compare 6 output Polarity */
#define TIM_CCER_CC6P_Msk                   (0x1UL << TIM_CCER_CC6P_Pos)            /*!< 0x00200000 */
#define TIM_CCER_CC6P_Pos                   (21U)
#define TIM_CCMR1_CC1S                      TIM_CCMR1_CC1S_Msk                      /*!<CC1S[1:0] bits (Capture/Compare 1 Selection) */
#define TIM_CCMR1_CC1S_0                    (0x1UL << TIM_CCMR1_CC1S_Pos)           /*!< 0x00000001 */
#define TIM_CCMR1_CC1S_1                    (0x2UL << TIM_CCMR1_CC1S_Pos)           /*!< 0x00000002 */
#define TIM_CCMR1_CC1S_Msk                  (0x3UL << TIM_CCMR1_CC1S_Pos)           /*!< 0x00000003 */
#define TIM_CCMR1_CC1S_Pos                  (0U)
#define TIM_CCMR1_CC2S                      TIM_CCMR1_CC2S_Msk                      /*!<CC2S[1:0] bits (Capture/Compare 2 Selection) */
#define TIM_CCMR1_CC2S_Msk                  (0x3UL << TIM_CCMR1_CC2S_Pos)           /*!< 0x00000300 */
#define TIM_CCMR1_CC2S_Pos                  (8U)
#define TIM_CCMR1_IC1F                      TIM_CCMR1_IC1F_Msk                      /*!<IC1F[3:0] bits (Input Capture 1 Filter) */
#define TIM_CCMR1_IC1F_0                    (0x1UL << TIM_CCMR1_IC1F_Pos)           /*!< 0x00000010 */
#define TIM_CCMR1_IC1F_1                    (0x2UL << TIM_CCMR1_IC1F_Pos)           /*!< 0x00000020 */
#define TIM_CCMR1_IC1F_2                    (0x4UL << TIM_CCMR1_IC1F_Pos)           /*!< 0x00000040 */
#define TIM_CCMR1_IC1F_3                    (0x8UL << TIM_CCMR1_IC1F_Pos)           /*!< 0x00000080 */
#define TIM_CCMR1_IC1F_Msk                  (0xFUL << TIM_CCMR1_IC1F_Pos)           /*!< 0x000000F0 */
#define TIM_CCMR1_IC1F_Pos                  (4U)
#define TIM_CCMR1_IC1PSC                    TIM_CCMR1_IC1PSC_Msk                    /*!<IC1PSC[1:0] bits (Input Capture 1 Prescaler) */
#define TIM_CCMR1_IC1PSC_0                  (0x1UL << TIM_CCMR1_IC1PSC_Pos)         /*!< 0x00000004 */
#define TIM_CCMR1_IC1PSC_1                  (0x2UL << TIM_CCMR1_IC1PSC_Pos)         /*!< 0x00000008 */
#define TIM_CCMR1_IC1PSC_Msk                (0x3UL << TIM_CCMR1_IC1PSC_Pos)         /*!< 0x0000000C */
#define TIM_CCMR1_IC1PSC_Pos                (2U)
#define TIM_CCMR1_IC2F                      TIM_CCMR1_IC2F_Msk                      /*!<IC2F[3:0] bits (Input Capture 2 Filter) */
#define TIM_CCMR1_IC2F_Msk                  (0xFUL << TIM_CCMR1_IC2F_Pos)           /*!< 0x0000F000 */
#define TIM_CCMR1_IC2F_Pos                  (12U)
#define TIM_CCMR1_IC2PSC                    TIM_CCMR1_IC2PSC_Msk                    /*!<IC2PSC[1:0] bits (Input Capture 2 Prescaler) */
#define TIM_CCMR1_IC2PSC_Msk                (0x3UL << TIM_CCMR1_IC2PSC_Pos)         /*!< 0x00000C00 */
#define TIM_CCMR1_IC2PSC_Pos                (10U)
#define TIM_CCMR1_OC1CE                     TIM_CCMR1_OC1CE_Msk                     /*!<Output Compare 1 Clear Enable */
#define TIM_CCMR1_OC1CE_Msk                 (0x1UL << TIM_CCMR1_OC1CE_Pos)          /*!< 0x00000080 */
#define TIM_CCMR1_OC1CE_Pos                 (7U)
#define TIM_CCMR1_OC1FE                     TIM_CCMR1_OC1FE_Msk                     /*!<Output Compare 1 Fast enable */
#define TIM_CCMR1_OC1FE_Msk                 (0x1UL << TIM_CCMR1_OC1FE_Pos)          /*!< 0x00000004 */
#define TIM_CCMR1_OC1FE_Pos                 (2U)
#define TIM_CCMR1_OC1M                      TIM_CCMR1_OC1M_Msk                      /*!<OC1M[2:0] bits (Output Compare 1 Mode) */
#define TIM_CCMR1_OC1M_0                    (0x0001UL << TIM_CCMR1_OC1M_Pos)        /*!< 0x00000010 */
#define TIM_CCMR1_OC1M_1                    (0x0002UL << TIM_CCMR1_OC1M_Pos)        /*!< 0x00000020 */
#define TIM_CCMR1_OC1M_2                    (0x0004UL << TIM_CCMR1_OC1M_Pos)        /*!< 0x00000040 */
#define TIM_CCMR1_OC1M_3                    (0x1000UL << TIM_CCMR1_OC1M_Pos)        /*!< 0x00010000 */
#define TIM_CCMR1_OC1M_Msk                  (0x1007UL << TIM_CCMR1_OC1M_Pos)        /*!< 0x00010070 */
#define TIM_CCMR1_OC1M_Pos                  (4U)
#define TIM_CCMR1_OC1PE                     TIM_CCMR1_OC1PE_Msk                     /*!<Output Compare 1 Preload enable */
#define TIM_CCMR1_OC1PE_Msk                 (0x1UL << TIM_CCMR1_OC1PE_Pos)          /*!< 0x00000008 */
#define TIM_CCMR1_OC1PE_Pos                 (3U)
#define TIM_CCMR1_OC2CE                     TIM_CCMR1_OC2CE_Msk                     /*!<Output Compare 2 Clear Enable */
#define TIM_CCMR1_OC2CE_Msk                 (0x1UL << TIM_CCMR1_OC2CE_Pos)          /*!< 0x00008000 */
#define TIM_CCMR1_OC2CE_Pos                 (15U)
#define TIM_CCMR1_OC2FE                     TIM_CCMR1_OC2FE_Msk                     /*!<Output Compare 2 Fast enable */
#define TIM_CCMR1_OC2FE_Msk                 (0x1UL << TIM_CCMR1_OC2FE_Pos)          /*!< 0x00000400 */
#define TIM_CCMR1_OC2FE_Pos                 (10U)
#define TIM_CCMR1_OC2M                      TIM_CCMR1_OC2M_Msk                      /*!<OC2M[2:0] bits (Output Compare 2 Mode) */
#define TIM_CCMR1_OC2M_Msk                  (0x1007UL << TIM_CCMR1_OC2M_Pos)        /*!< 0x01007000 */
#define TIM_CCMR1_OC2M_Pos                  (12U)
#define TIM_CCMR1_OC2PE                     TIM_CCMR1_OC2PE_Msk                     /*!<Output Compare 2 Preload enable */
#define TIM_CCMR1_OC2PE_Msk                 (0x1UL << TIM_CCMR1_OC2PE_Pos)          /*!< 0x00000800 */
#define TIM_CCMR1_OC2PE_Pos                 (11U)
#define TIM_CCMR2_CC3S                      TIM_CCMR2_CC3S_Msk                      /*!<CC3S[1:0] bits (Capture/Compare 3 Selection) */
#define TIM_CCMR2_CC3S_Msk                  (0x3UL << TIM_CCMR2_CC3S_Pos)           /*!< 0x00000003 */
#define TIM_CCMR2_CC3S_Pos                  (0U)
#define TIM_CCMR2_CC4S                      TIM_CCMR2_CC4S_Msk                      /*!<CC4S[1:0] bits (Capture/Compare 4 Selection) */
#define TIM_CCMR2_CC4S_Msk                  (0x3UL << TIM_CCMR2_CC4S_Pos)           /*!< 0x00000300 */
#define TIM_CCMR2_CC4S_Pos                  (8U)
#define TIM_CCMR2_IC3F                      TIM_CCMR2_IC3F_Msk                      /*!<IC3F[3:0] bits (Input Capture 3 Filter) */
#define TIM_CCMR2_IC3F_Msk                  (0xFUL << TIM_CCMR2_IC3F_Pos)           /*!< 0x000000F0 */
#define TIM_CCMR2_IC3F_Pos                  (4U)
#define TIM_CCMR2_IC3PSC                    TIM_CCMR2_IC3PSC_Msk                    /*!<IC3PSC[1:0] bits (Input Capture 3 Prescaler) */
#define TIM_CCMR2_IC3PSC_Msk                (0x3UL << TIM_CCMR2_IC3PSC_Pos)         /*!< 0x0000000C */
#define TIM_CCMR2_IC3PSC_Pos                (2U)
#define TIM_CCMR2_IC4F                      TIM_CCMR2_IC4F_Msk                      /*!<IC4F[3:0] bits (Input Capture 4 Filter) */
#define TIM_CCMR2_IC4F_Msk                  (0xFUL << TIM_CCMR2_IC4F_Pos)           /*!< 0x0000F000 */
#define TIM_CCMR2_IC4F_Pos                  (12U)
#define TIM_CCMR2_IC4PSC                    TIM_CCMR2_IC4PSC_Msk                    /*!<IC4PSC[1:0] bits (Input Capture 4 Prescaler) */
#define TIM_CCMR2_IC4PSC_Msk                (0x3UL << TIM_CCMR2_IC4PSC_Pos)         /*!< 0x00000C00 */
#define TIM_CCMR2_IC4PSC_Pos                (10U)
#define TIM_CCMR2_OC3M                      TIM_CCMR2_OC3M_Msk                      /*!<OC3M[2:0] bits (Output Compare 3 Mode) */
#define TIM_CCMR2_OC3M_0                    (0x0001UL << TIM_CCMR2_OC3M_Pos)        /*!< 0x00000010 */
#define TIM_CCMR2_OC3M_1                    (0x0002UL << TIM_CCMR2_OC3M_Pos)        /*!< 0x00000020 */
#define TIM_CCMR2_OC3M_3                    (0x1000UL << TIM_CCMR2_OC3M_Pos)        /*!< 0x00010000 */
#define TIM_CCMR2_OC3M_Msk                  (0x1007UL << TIM_CCMR2_OC3M_Pos)        /*!< 0x00010070 */
#define TIM_CCMR2_OC3M_Pos                  (4U)
#define TIM_CCMR2_OC4M                      TIM_CCMR2_OC4M_Msk                      /*!<OC4M[2:0] bits (Output Compare 4 Mode) */
#define TIM_CCMR2_OC4M_Msk                  (0x1007UL << TIM_CCMR2_OC4M_Pos)        /*!< 0x01007000 */
#define TIM_CCMR2_OC4M_Pos                  (12U)
#define TIM_CCMR3_OC5M                      TIM_CCMR3_OC5M_Msk                      /*!<OC5M[3:0] bits (Output Compare 5 Mode) */
#define TIM_CCMR3_OC5M_Msk                  (0x1007UL << TIM_CCMR3_OC5M_Pos)        /*!< 0x00010070 */
#define TIM_CCMR3_OC5M_Pos                  (4U)
#define TIM_CCMR3_OC6M                      TIM_CCMR3_OC6M_Msk                      /*!<OC6M[3:0] bits (Output Compare 6 Mode) */
#define TIM_CCMR3_OC6M_Msk                  (0x1007UL << TIM_CCMR3_OC6M_Pos)        /*!< 0x01007000 */
#define TIM_CCMR3_OC6M_Pos                  (12U)
#define TIM_CCR5_CCR5                       TIM_CCR5_CCR5_Msk                       /*!<Capture/Compare 5 Value */
#define TIM_CCR5_CCR5_Msk                   (0xFFFFFUL << TIM_CCR5_CCR5_Pos)        /*!< 0x000FFFFF */
#define TIM_CCR5_CCR5_Pos                   (0U)
#define TIM_CCR5_GC5C1                      TIM_CCR5_GC5C1_Msk                      /*!<Group Channel 5 and Channel 1 */
#define TIM_CCR5_GC5C1_Msk                  (0x1UL << TIM_CCR5_GC5C1_Pos)           /*!< 0x20000000 */
#define TIM_CCR5_GC5C1_Pos                  (29U)
#define TIM_CCR5_GC5C2                      TIM_CCR5_GC5C2_Msk                      /*!<Group Channel 5 and Channel 2 */
#define TIM_CCR5_GC5C2_Msk                  (0x1UL << TIM_CCR5_GC5C2_Pos)           /*!< 0x40000000 */
#define TIM_CCR5_GC5C2_Pos                  (30U)
#define TIM_CCR5_GC5C3                      TIM_CCR5_GC5C3_Msk                      /*!<Group Channel 5 and Channel 3 */
#define TIM_CCR5_GC5C3_Msk                  (0x1UL << TIM_CCR5_GC5C3_Pos)           /*!< 0x80000000 */
#define TIM_CCR5_GC5C3_Pos                  (31U)
#define TIM_CNT_UIFCPY                      TIM_CNT_UIFCPY_Msk                      /*!<Update interrupt flag copy (if UIFREMAP=1) */
#define TIM_CNT_UIFCPY_Msk                  (0x1UL << TIM_CNT_UIFCPY_Pos)           /*!< 0x80000000 */
#define TIM_CNT_UIFCPY_Pos                  (31U)
#define TIM_CR1_ARPE                        TIM_CR1_ARPE_Msk                        /*!<Auto-reload preload enable */
#define TIM_CR1_ARPE_Msk                    (0x1UL << TIM_CR1_ARPE_Pos)             /*!< 0x00000080 */
#define TIM_CR1_ARPE_Pos                    (7U)
#define TIM_CR1_CEN                         TIM_CR1_CEN_Msk                         /*!<Counter enable */
#define TIM_CR1_CEN_Msk                     (0x1UL << TIM_CR1_CEN_Pos)              /*!< 0x00000001 */
#define TIM_CR1_CEN_Pos                     (0U)
#define TIM_CR1_CKD                         TIM_CR1_CKD_Msk                         /*!<CKD[1:0] bits (clock division) */
#define TIM_CR1_CKD_0                       (0x1UL << TIM_CR1_CKD_Pos)              /*!< 0x00000100 */
#define TIM_CR1_CKD_1                       (0x2UL << TIM_CR1_CKD_Pos)              /*!< 0x00000200 */
#define TIM_CR1_CKD_Msk                     (0x3UL << TIM_CR1_CKD_Pos)              /*!< 0x00000300 */
#define TIM_CR1_CKD_Pos                     (8U)
#define TIM_CR1_CMS                         TIM_CR1_CMS_Msk                         /*!<CMS[1:0] bits (Center-aligned mode selection) */
#define TIM_CR1_CMS_0                       (0x1UL << TIM_CR1_CMS_Pos)              /*!< 0x00000020 */
#define TIM_CR1_CMS_1                       (0x2UL << TIM_CR1_CMS_Pos)              /*!< 0x00000040 */
#define TIM_CR1_CMS_Msk                     (0x3UL << TIM_CR1_CMS_Pos)              /*!< 0x00000060 */
#define TIM_CR1_CMS_Pos                     (5U)
#define TIM_CR1_DIR                         TIM_CR1_DIR_Msk                         /*!<Direction */
#define TIM_CR1_DIR_Msk                     (0x1UL << TIM_CR1_DIR_Pos)              /*!< 0x00000010 */
#define TIM_CR1_DIR_Pos                     (4U)
#define TIM_CR1_DITHEN                      TIM_CR1_DITHEN_Msk                      /*!<Dithering enable */
#define TIM_CR1_DITHEN_Msk                  (0x1UL << TIM_CR1_DITHEN_Pos)           /*!< 0x00001000 */
#define TIM_CR1_DITHEN_Pos                  (12U)
#define TIM_CR1_OPM                         TIM_CR1_OPM_Msk                         /*!<One pulse mode */
#define TIM_CR1_OPM_Msk                     (0x1UL << TIM_CR1_OPM_Pos)              /*!< 0x00000008 */
#define TIM_CR1_OPM_Pos                     (3U)
#define TIM_CR1_UDIS                        TIM_CR1_UDIS_Msk                        /*!<Update disable */
#define TIM_CR1_UDIS_Msk                    (0x1UL << TIM_CR1_UDIS_Pos)             /*!< 0x00000002 */
#define TIM_CR1_UDIS_Pos                    (1U)
#define TIM_CR1_UIFREMAP                    TIM_CR1_UIFREMAP_Msk                    /*!<Update interrupt flag remap */
#define TIM_CR1_UIFREMAP_Msk                (0x1UL << TIM_CR1_UIFREMAP_Pos)         /*!< 0x00000800 */
#define TIM_CR1_UIFREMAP_Pos                (11U)
#define TIM_CR1_URS                         TIM_CR1_URS_Msk                         /*!<Update request source */
#define TIM_CR1_URS_Msk                     (0x1UL << TIM_CR1_URS_Pos)              /*!< 0x00000004 */
#define TIM_CR1_URS_Pos                     (2U)
#define TIM_CR2_CCDS                        TIM_CR2_CCDS_Msk                        /*!<Capture/Compare DMA Selection */
#define TIM_CR2_CCDS_Msk                    (0x1UL << TIM_CR2_CCDS_Pos)             /*!< 0x00000008 */
#define TIM_CR2_CCDS_Pos                    (3U)
#define TIM_CR2_CCPC                        TIM_CR2_CCPC_Msk                        /*!<Capture/Compare Preloaded Control */
#define TIM_CR2_CCPC_Msk                    (0x1UL << TIM_CR2_CCPC_Pos)             /*!< 0x00000001 */
#define TIM_CR2_CCPC_Pos                    (0U)
#define TIM_CR2_CCUS                        TIM_CR2_CCUS_Msk                        /*!<Capture/Compare Control Update Selection */
#define TIM_CR2_CCUS_Msk                    (0x1UL << TIM_CR2_CCUS_Pos)             /*!< 0x00000004 */
#define TIM_CR2_CCUS_Pos                    (2U)
#define TIM_CR2_MMS                         TIM_CR2_MMS_Msk                         /*!<MMS[3:0] bits (Master Mode Selection) */
#define TIM_CR2_MMS2                        TIM_CR2_MMS2_Msk                        /*!<MMS[2:0] bits (Master Mode Selection) */
#define TIM_CR2_MMS2_0                      (0x1UL << TIM_CR2_MMS2_Pos)             /*!< 0x00100000 */
#define TIM_CR2_MMS2_1                      (0x2UL << TIM_CR2_MMS2_Pos)             /*!< 0x00200000 */
#define TIM_CR2_MMS2_2                      (0x4UL << TIM_CR2_MMS2_Pos)             /*!< 0x00400000 */
#define TIM_CR2_MMS2_3                      (0x8UL << TIM_CR2_MMS2_Pos)             /*!< 0x00800000 */
#define TIM_CR2_MMS2_Msk                    (0xFUL << TIM_CR2_MMS2_Pos)             /*!< 0x00F00000 */
#define TIM_CR2_MMS2_Pos                    (20U)
#define TIM_CR2_MMS_0                       (0x000001UL << TIM_CR2_MMS_Pos)         /*!< 0x00000010 */
#define TIM_CR2_MMS_1                       (0x000002UL << TIM_CR2_MMS_Pos)         /*!< 0x00000020 */
#define TIM_CR2_MMS_2                       (0x000004UL << TIM_CR2_MMS_Pos)         /*!< 0x00000040 */
#define TIM_CR2_MMS_3                       (0x200000UL << TIM_CR2_MMS_Pos)         /*!< 0x02000000 */
#define TIM_CR2_MMS_Msk                     (0x200007UL << TIM_CR2_MMS_Pos)         /*!< 0x02000070 */
#define TIM_CR2_MMS_Pos                     (4U)
#define TIM_CR2_OIS1                        TIM_CR2_OIS1_Msk                        /*!<Output Idle state 1 (OC1 output) */
#define TIM_CR2_OIS1N                       TIM_CR2_OIS1N_Msk                       /*!<Output Idle state 1 (OC1N output) */
#define TIM_CR2_OIS1N_Msk                   (0x1UL << TIM_CR2_OIS1N_Pos)            /*!< 0x00000200 */
#define TIM_CR2_OIS1N_Pos                   (9U)
#define TIM_CR2_OIS1_Msk                    (0x1UL << TIM_CR2_OIS1_Pos)             /*!< 0x00000100 */
#define TIM_CR2_OIS1_Pos                    (8U)
#define TIM_CR2_OIS2                        TIM_CR2_OIS2_Msk                        /*!<Output Idle state 2 (OC2 output) */
#define TIM_CR2_OIS2N                       TIM_CR2_OIS2N_Msk                       /*!<Output Idle state 2 (OC2N output) */
#define TIM_CR2_OIS2N_Msk                   (0x1UL << TIM_CR2_OIS2N_Pos)            /*!< 0x00000800 */
#define TIM_CR2_OIS2N_Pos                   (11U)
#define TIM_CR2_OIS2_Msk                    (0x1UL << TIM_CR2_OIS2_Pos)             /*!< 0x00000400 */
#define TIM_CR2_OIS2_Pos                    (10U)
#define TIM_CR2_OIS3                        TIM_CR2_OIS3_Msk                        /*!<Output Idle state 3 (OC3 output) */
#define TIM_CR2_OIS3N                       TIM_CR2_OIS3N_Msk                       /*!<Output Idle state 3 (OC3N output) */
#define TIM_CR2_OIS3N_Msk                   (0x1UL << TIM_CR2_OIS3N_Pos)            /*!< 0x00002000 */
#define TIM_CR2_OIS3N_Pos                   (13U)
#define TIM_CR2_OIS3_Msk                    (0x1UL << TIM_CR2_OIS3_Pos)             /*!< 0x00001000 */
#define TIM_CR2_OIS3_Pos                    (12U)
#define TIM_CR2_OIS4                        TIM_CR2_OIS4_Msk                        /*!<Output Idle state 4 (OC4 output) */
#define TIM_CR2_OIS4N                       TIM_CR2_OIS4N_Msk                       /*!<Output Idle state 4 (OC4N output) */
#define TIM_CR2_OIS4N_Msk                   (0x1UL << TIM_CR2_OIS4N_Pos)            /*!< 0x00008000 */
#define TIM_CR2_OIS4N_Pos                   (15U)
#define TIM_CR2_OIS4_Msk                    (0x1UL << TIM_CR2_OIS4_Pos)             /*!< 0x00004000 */
#define TIM_CR2_OIS4_Pos                    (14U)
#define TIM_CR2_OIS5                        TIM_CR2_OIS5_Msk                        /*!<Output Idle state 5 (OC5 output) */
#define TIM_CR2_OIS5_Msk                    (0x1UL << TIM_CR2_OIS5_Pos)             /*!< 0x00010000 */
#define TIM_CR2_OIS5_Pos                    (16U)
#define TIM_CR2_OIS6                        TIM_CR2_OIS6_Msk                        /*!<Output Idle state 6 (OC6 output) */
#define TIM_CR2_OIS6_Msk                    (0x1UL << TIM_CR2_OIS6_Pos)             /*!< 0x00040000 */
#define TIM_CR2_OIS6_Pos                    (18U)
#define TIM_CR2_TI1S                        TIM_CR2_TI1S_Msk                        /*!<TI1 Selection */
#define TIM_CR2_TI1S_Msk                    (0x1UL << TIM_CR2_TI1S_Pos)             /*!< 0x00000080 */
#define TIM_CR2_TI1S_Pos                    (7U)
#define TIM_DCR_DBA                         TIM_DCR_DBA_Msk                         /*!<DBA[4:0] bits (DMA Base Address) */
#define TIM_DCR_DBA_0                       (0x01UL << TIM_DCR_DBA_Pos)             /*!< 0x00000001 */
#define TIM_DCR_DBA_1                       (0x02UL << TIM_DCR_DBA_Pos)             /*!< 0x00000002 */
#define TIM_DCR_DBA_2                       (0x04UL << TIM_DCR_DBA_Pos)             /*!< 0x00000004 */
#define TIM_DCR_DBA_3                       (0x08UL << TIM_DCR_DBA_Pos)             /*!< 0x00000008 */
#define TIM_DCR_DBA_4                       (0x10UL << TIM_DCR_DBA_Pos)             /*!< 0x00000010 */
#define TIM_DCR_DBA_Msk                     (0x1FUL << TIM_DCR_DBA_Pos)             /*!< 0x0000001F */
#define TIM_DCR_DBA_Pos                     (0U)
#define TIM_DCR_DBL                         TIM_DCR_DBL_Msk                         /*!<DBL[4:0] bits (DMA Burst Length) */
#define TIM_DCR_DBL_0                       (0x01UL << TIM_DCR_DBL_Pos)             /*!< 0x00000100 */
#define TIM_DCR_DBL_1                       (0x02UL << TIM_DCR_DBL_Pos)             /*!< 0x00000200 */
#define TIM_DCR_DBL_2                       (0x04UL << TIM_DCR_DBL_Pos)             /*!< 0x00000400 */
#define TIM_DCR_DBL_3                       (0x08UL << TIM_DCR_DBL_Pos)             /*!< 0x00000800 */
#define TIM_DCR_DBL_4                       (0x10UL << TIM_DCR_DBL_Pos)             /*!< 0x00001000 */
#define TIM_DCR_DBL_Msk                     (0x1FUL << TIM_DCR_DBL_Pos)             /*!< 0x00001F00 */
#define TIM_DCR_DBL_Pos                     (8U)
#define TIM_DCR_DBSS                        TIM_DCR_DBSS_Msk                        /*!<DBSS[19:16] bits (DMA Burst Source Selection) */
#define TIM_DCR_DBSS_0                      (0x01UL << TIM_DCR_DBSS_Pos)            /*!< 0x00010000 */
#define TIM_DCR_DBSS_1                      (0x02UL << TIM_DCR_DBSS_Pos)            /*!< 0x00020000 */
#define TIM_DCR_DBSS_2                      (0x04UL << TIM_DCR_DBSS_Pos)            /*!< 0x00040000 */
#define TIM_DCR_DBSS_Msk                    (0xFUL << TIM_DCR_DBSS_Pos)             /*!< 0x000F0000 */
#define TIM_DCR_DBSS_Pos                    (16U)
#define TIM_DIER_BIE                        TIM_DIER_BIE_Msk                        /*!<Break interrupt enable */
#define TIM_DIER_BIE_Msk                    (0x1UL << TIM_DIER_BIE_Pos)             /*!< 0x00000080 */
#define TIM_DIER_BIE_Pos                    (7U)
#define TIM_DIER_CC1DE                      TIM_DIER_CC1DE_Msk                      /*!<Capture/Compare 1 DMA request enable */
#define TIM_DIER_CC1DE_Msk                  (0x1UL << TIM_DIER_CC1DE_Pos)           /*!< 0x00000200 */
#define TIM_DIER_CC1DE_Pos                  (9U)
#define TIM_DIER_CC1IE                      TIM_DIER_CC1IE_Msk                      /*!<Capture/Compare 1 interrupt enable */
#define TIM_DIER_CC1IE_Msk                  (0x1UL << TIM_DIER_CC1IE_Pos)           /*!< 0x00000002 */
#define TIM_DIER_CC1IE_Pos                  (1U)
#define TIM_DIER_CC2DE                      TIM_DIER_CC2DE_Msk                      /*!<Capture/Compare 2 DMA request enable */
#define TIM_DIER_CC2DE_Msk                  (0x1UL << TIM_DIER_CC2DE_Pos)           /*!< 0x00000400 */
#define TIM_DIER_CC2DE_Pos                  (10U)
#define TIM_DIER_CC2IE                      TIM_DIER_CC2IE_Msk                      /*!<Capture/Compare 2 interrupt enable */
#define TIM_DIER_CC2IE_Msk                  (0x1UL << TIM_DIER_CC2IE_Pos)           /*!< 0x00000004 */
#define TIM_DIER_CC2IE_Pos                  (2U)
#define TIM_DIER_CC3DE                      TIM_DIER_CC3DE_Msk                      /*!<Capture/Compare 3 DMA request enable */
#define TIM_DIER_CC3DE_Msk                  (0x1UL << TIM_DIER_CC3DE_Pos)           /*!< 0x00000800 */
#define TIM_DIER_CC3DE_Pos                  (11U)
#define TIM_DIER_CC3IE                      TIM_DIER_CC3IE_Msk                      /*!<Capture/Compare 3 interrupt enable */
#define TIM_DIER_CC3IE_Msk                  (0x1UL << TIM_DIER_CC3IE_Pos)           /*!< 0x00000008 */
#define TIM_DIER_CC3IE_Pos                  (3U)
#define TIM_DIER_CC4DE                      TIM_DIER_CC4DE_Msk                      /*!<Capture/Compare 4 DMA request enable */
#define TIM_DIER_CC4DE_Msk                  (0x1UL << TIM_DIER_CC4DE_Pos)           /*!< 0x00001000 */
#define TIM_DIER_CC4DE_Pos                  (12U)
#define TIM_DIER_CC4IE                      TIM_DIER_CC4IE_Msk                      /*!<Capture/Compare 4 interrupt enable */
#define TIM_DIER_CC4IE_Msk                  (0x1UL << TIM_DIER_CC4IE_Pos)           /*!< 0x00000010 */
#define TIM_DIER_CC4IE_Pos                  (4U)
#define TIM_DIER_COMDE                      TIM_DIER_COMDE_Msk                      /*!<COM DMA request enable */
#define TIM_DIER_COMDE_Msk                  (0x1UL << TIM_DIER_COMDE_Pos)           /*!< 0x00002000 */
#define TIM_DIER_COMDE_Pos                  (13U)
#define TIM_DIER_COMIE                      TIM_DIER_COMIE_Msk                      /*!<COM interrupt enable */
#define TIM_DIER_COMIE_Msk                  (0x1UL << TIM_DIER_COMIE_Pos)           /*!< 0x00000020 */
#define TIM_DIER_COMIE_Pos                  (5U)
#define TIM_DIER_DIRIE                      TIM_DIER_DIRIE_Msk                      /*!<Encoder direction change interrupt enable */
#define TIM_DIER_DIRIE_Msk                  (0x1UL << TIM_DIER_DIRIE_Pos)           /*!< 0x00200000 */
#define TIM_DIER_DIRIE_Pos                  (21U)
#define TIM_DIER_IDXIE                      TIM_DIER_IDXIE_Msk                      /*!<Encoder index interrupt enable */
#define TIM_DIER_IDXIE_Msk                  (0x1UL << TIM_DIER_IDXIE_Pos)           /*!< 0x00100000 */
#define TIM_DIER_IDXIE_Pos                  (20U)
#define TIM_DIER_IERRIE                     TIM_DIER_IERRIE_Msk                     /*!<Encoder index error enable */
#define TIM_DIER_IERRIE_Msk                 (0x1UL << TIM_DIER_IERRIE_Pos)          /*!< 0x00400000 */
#define TIM_DIER_IERRIE_Pos                 (22U)
#define TIM_DIER_TDE                        TIM_DIER_TDE_Msk                        /*!<Trigger DMA request enable */
#define TIM_DIER_TDE_Msk                    (0x1UL << TIM_DIER_TDE_Pos)             /*!< 0x00004000 */
#define TIM_DIER_TDE_Pos                    (14U)
#define TIM_DIER_TERRIE                     TIM_DIER_TERRIE_Msk                     /*!<Encoder transition error enable */
#define TIM_DIER_TERRIE_Msk                 (0x1UL << TIM_DIER_TERRIE_Pos)          /*!< 0x00800000 */
#define TIM_DIER_TERRIE_Pos                 (23U)
#define TIM_DIER_TIE                        TIM_DIER_TIE_Msk                        /*!<Trigger interrupt enable */
#define TIM_DIER_TIE_Msk                    (0x1UL << TIM_DIER_TIE_Pos)             /*!< 0x00000040 */
#define TIM_DIER_TIE_Pos                    (6U)
#define TIM_DIER_UDE                        TIM_DIER_UDE_Msk                        /*!<Update DMA request enable */
#define TIM_DIER_UDE_Msk                    (0x1UL << TIM_DIER_UDE_Pos)             /*!< 0x00000100 */
#define TIM_DIER_UDE_Pos                    (8U)
#define TIM_DIER_UIE                        TIM_DIER_UIE_Msk                        /*!<Update interrupt enable */
#define TIM_DIER_UIE_Msk                    (0x1UL << TIM_DIER_UIE_Pos)             /*!< 0x00000001 */
#define TIM_DIER_UIE_Pos                    (0U)
#define TIM_DTR2_DTAE                       TIM_DTR2_DTAE_Msk                       /*!<Deadtime asymmetric enable */
#define TIM_DTR2_DTAE_Msk                   (0x1UL << TIM_DTR2_DTAE_Pos)            /*!< 0x00004000 */
#define TIM_DTR2_DTAE_Pos                   (16U)
#define TIM_DTR2_DTGF                       TIM_DTR2_DTGF_Msk                       /*!<DTGF[7:0] bits (Deadtime falling edge generator setup)*/
#define TIM_DTR2_DTGF_Msk                   (0xFFUL << TIM_DTR2_DTGF_Pos)           /*!< 0x0000000F */
#define TIM_DTR2_DTGF_Pos                   (0U)
#define TIM_DTR2_DTPE                       TIM_DTR2_DTPE_Msk                       /*!<Deadtime prelaod enable */
#define TIM_DTR2_DTPE_Msk                   (0x1UL << TIM_DTR2_DTPE_Pos)            /*!< 0x00008000 */
#define TIM_DTR2_DTPE_Pos                   (17U)
#define TIM_ECR_FIDX                        TIM_ECR_FIDX_Msk                        /*!<First index enable */
#define TIM_ECR_FIDX_Msk                    (0x1UL << TIM_ECR_FIDX_Pos)             /*!< 0x00000020 */
#define TIM_ECR_FIDX_Pos                    (5U)
#define TIM_ECR_IBLK                        TIM_ECR_IBLK_Msk                        /*!<IBLK[1:0] bits (Index blanking)*/
#define TIM_ECR_IBLK_0                      (0x01UL << TIM_ECR_IBLK_Pos)            /*!< 0x00000008 */
#define TIM_ECR_IBLK_1                      (0x02UL << TIM_ECR_IBLK_Pos)            /*!< 0x00000010 */
#define TIM_ECR_IBLK_Msk                    (0x3UL << TIM_ECR_IBLK_Pos)             /*!< 0x00000018 */
#define TIM_ECR_IBLK_Pos                    (3U)
#define TIM_ECR_IDIR                        TIM_ECR_IDIR_Msk                        /*!<IDIR[1:0] bits (Index direction)*/
#define TIM_ECR_IDIR_0                      (0x01UL << TIM_ECR_IDIR_Pos)            /*!< 0x00000001 */
#define TIM_ECR_IDIR_1                      (0x02UL << TIM_ECR_IDIR_Pos)            /*!< 0x00000002 */
#define TIM_ECR_IDIR_Msk                    (0x3UL << TIM_ECR_IDIR_Pos)             /*!< 0x00000006 */
#define TIM_ECR_IDIR_Pos                    (1U)
#define TIM_ECR_IE                          TIM_ECR_IE_Msk                          /*!<Index enable */
#define TIM_ECR_IE_Msk                      (0x1UL << TIM_ECR_IE_Pos)               /*!< 0x00000001 */
#define TIM_ECR_IE_Pos                      (0U)
#define TIM_ECR_IPOS                        TIM_ECR_IPOS_Msk                        /*!<IPOS[1:0] bits (Index positioning)*/
#define TIM_ECR_IPOS_0                      (0x01UL << TIM_ECR_IPOS_Pos)            /*!< 0x00000040 */
#define TIM_ECR_IPOS_1                      (0x02UL << TIM_ECR_IPOS_Pos)            /*!< 0x00000080 */
#define TIM_ECR_IPOS_Msk                    (0x3UL << TIM_ECR_IPOS_Pos)             /*!< 0x000000C0 */
#define TIM_ECR_IPOS_Pos                    (6U)
#define TIM_ECR_PW                          TIM_ECR_PW_Msk                          /*!<PW[7:0] bits (Pulse width)*/
#define TIM_ECR_PWPRSC                      TIM_ECR_PWPRSC_Msk                      /*!<PWPRSC[2:0] bits (Pulse width prescaler)*/
#define TIM_ECR_PWPRSC_0                    (0x01UL << TIM_ECR_PWPRSC_Pos)          /*!< 0x01000000 */
#define TIM_ECR_PWPRSC_1                    (0x02UL << TIM_ECR_PWPRSC_Pos)          /*!< 0x02000000 */
#define TIM_ECR_PWPRSC_2                    (0x04UL << TIM_ECR_PWPRSC_Pos)          /*!< 0x04000000 */
#define TIM_ECR_PWPRSC_Msk                  (0x7UL << TIM_ECR_PWPRSC_Pos)           /*!< 0x07000000 */
#define TIM_ECR_PWPRSC_Pos                  (24U)
#define TIM_ECR_PW_Msk                      (0xFFUL << TIM_ECR_PW_Pos)              /*!< 0x00FF0000 */
#define TIM_ECR_PW_Pos                      (16U)
#define TIM_EGR_B2G                         TIM_EGR_B2G_Msk                         /*!<Break 2 Generation */
#define TIM_EGR_B2G_Msk                     (0x1UL << TIM_EGR_B2G_Pos)              /*!< 0x00000100 */
#define TIM_EGR_B2G_Pos                     (8U)
#define TIM_EGR_BG                          TIM_EGR_BG_Msk                          /*!<Break Generation */
#define TIM_EGR_BG_Msk                      (0x1UL << TIM_EGR_BG_Pos)               /*!< 0x00000080 */
#define TIM_EGR_BG_Pos                      (7U)
#define TIM_EGR_CC1G                        TIM_EGR_CC1G_Msk                        /*!<Capture/Compare 1 Generation */
#define TIM_EGR_CC1G_Msk                    (0x1UL << TIM_EGR_CC1G_Pos)             /*!< 0x00000002 */
#define TIM_EGR_CC1G_Pos                    (1U)
#define TIM_EGR_CC2G                        TIM_EGR_CC2G_Msk                        /*!<Capture/Compare 2 Generation */
#define TIM_EGR_CC2G_Msk                    (0x1UL << TIM_EGR_CC2G_Pos)             /*!< 0x00000004 */
#define TIM_EGR_CC2G_Pos                    (2U)
#define TIM_EGR_CC3G                        TIM_EGR_CC3G_Msk                        /*!<Capture/Compare 3 Generation */
#define TIM_EGR_CC3G_Msk                    (0x1UL << TIM_EGR_CC3G_Pos)             /*!< 0x00000008 */
#define TIM_EGR_CC3G_Pos                    (3U)
#define TIM_EGR_CC4G                        TIM_EGR_CC4G_Msk                        /*!<Capture/Compare 4 Generation */
#define TIM_EGR_CC4G_Msk                    (0x1UL << TIM_EGR_CC4G_Pos)             /*!< 0x00000010 */
#define TIM_EGR_CC4G_Pos                    (4U)
#define TIM_EGR_COMG                        TIM_EGR_COMG_Msk                        /*!<Capture/Compare Control Update Generation */
#define TIM_EGR_COMG_Msk                    (0x1UL << TIM_EGR_COMG_Pos)             /*!< 0x00000020 */
#define TIM_EGR_COMG_Pos                    (5U)
#define TIM_EGR_TG                          TIM_EGR_TG_Msk                          /*!<Trigger Generation */
#define TIM_EGR_TG_Msk                      (0x1UL << TIM_EGR_TG_Pos)               /*!< 0x00000040 */
#define TIM_EGR_TG_Pos                      (6U)
#define TIM_EGR_UG                          TIM_EGR_UG_Msk                          /*!<Update Generation */
#define TIM_EGR_UG_Msk                      (0x1UL << TIM_EGR_UG_Pos)               /*!< 0x00000001 */
#define TIM_EGR_UG_Pos                      (0U)
#define TIM_SMCR_ECE                        TIM_SMCR_ECE_Msk                        /*!<External clock enable */
#define TIM_SMCR_ECE_Msk                    (0x1UL << TIM_SMCR_ECE_Pos)             /*!< 0x00004000 */
#define TIM_SMCR_ECE_Pos                    (14U)
#define TIM_SMCR_ETF                        TIM_SMCR_ETF_Msk                        /*!<ETF[3:0] bits (External trigger filter) */
#define TIM_SMCR_ETF_0                      (0x1UL << TIM_SMCR_ETF_Pos)             /*!< 0x00000100 */
#define TIM_SMCR_ETF_1                      (0x2UL << TIM_SMCR_ETF_Pos)             /*!< 0x00000200 */
#define TIM_SMCR_ETF_2                      (0x4UL << TIM_SMCR_ETF_Pos)             /*!< 0x00000400 */
#define TIM_SMCR_ETF_3                      (0x8UL << TIM_SMCR_ETF_Pos)             /*!< 0x00000800 */
#define TIM_SMCR_ETF_Msk                    (0xFUL << TIM_SMCR_ETF_Pos)             /*!< 0x00000F00 */
#define TIM_SMCR_ETF_Pos                    (8U)
#define TIM_SMCR_ETP                        TIM_SMCR_ETP_Msk                        /*!<External trigger polarity */
#define TIM_SMCR_ETPS                       TIM_SMCR_ETPS_Msk                       /*!<ETPS[1:0] bits (External trigger prescaler) */
#define TIM_SMCR_ETPS_0                     (0x1UL << TIM_SMCR_ETPS_Pos)            /*!< 0x00001000 */
#define TIM_SMCR_ETPS_1                     (0x2UL << TIM_SMCR_ETPS_Pos)            /*!< 0x00002000 */
#define TIM_SMCR_ETPS_Msk                   (0x3UL << TIM_SMCR_ETPS_Pos)            /*!< 0x00003000 */
#define TIM_SMCR_ETPS_Pos                   (12U)
#define TIM_SMCR_ETP_Msk                    (0x1UL << TIM_SMCR_ETP_Pos)             /*!< 0x00008000 */
#define TIM_SMCR_ETP_Pos                    (15U)
#define TIM_SMCR_MSM                        TIM_SMCR_MSM_Msk                        /*!<Master/slave mode */
#define TIM_SMCR_MSM_Msk                    (0x1UL << TIM_SMCR_MSM_Pos)             /*!< 0x00000080 */
#define TIM_SMCR_MSM_Pos                    (7U)
#define TIM_SMCR_SMS                        TIM_SMCR_SMS_Msk                        /*!<SMS[2:0] bits (Slave mode selection) */
#define TIM_SMCR_SMSPE                      TIM_SMCR_SMSPE_Msk                      /*!<SMS preload enable */
#define TIM_SMCR_SMSPE_Msk                  (0x1UL << TIM_SMCR_SMSPE_Pos)           /*!< 0x02000000 */
#define TIM_SMCR_SMSPE_Pos                  (24U)
#define TIM_SMCR_SMSPS                      TIM_SMCR_SMSPS_Msk                      /*!<SMS preload source */
#define TIM_SMCR_SMSPS_Msk                  (0x1UL << TIM_SMCR_SMSPS_Pos)           /*!< 0x04000000 */
#define TIM_SMCR_SMSPS_Pos                  (25U)
#define TIM_SMCR_SMS_0                      (0x00001UL << TIM_SMCR_SMS_Pos)         /*!< 0x00000001 */
#define TIM_SMCR_SMS_1                      (0x00002UL << TIM_SMCR_SMS_Pos)         /*!< 0x00000002 */
#define TIM_SMCR_SMS_2                      (0x00004UL << TIM_SMCR_SMS_Pos)         /*!< 0x00000004 */
#define TIM_SMCR_SMS_3                      (0x10000UL << TIM_SMCR_SMS_Pos)         /*!< 0x00010000 */
#define TIM_SMCR_SMS_Msk                    (0x10007UL << TIM_SMCR_SMS_Pos)         /*!< 0x00010007 */
#define TIM_SMCR_SMS_Pos                    (0U)
#define TIM_SMCR_TS                         TIM_SMCR_TS_Msk                         /*!<TS[2:0] bits (Trigger selection) */
#define TIM_SMCR_TS_0                       (0x00001UL << TIM_SMCR_TS_Pos)          /*!< 0x00000010 */
#define TIM_SMCR_TS_1                       (0x00002UL << TIM_SMCR_TS_Pos)          /*!< 0x00000020 */
#define TIM_SMCR_TS_2                       (0x00004UL << TIM_SMCR_TS_Pos)          /*!< 0x00000040 */
#define TIM_SMCR_TS_3                       (0x10000UL << TIM_SMCR_TS_Pos)          /*!< 0x00100000 */
#define TIM_SMCR_TS_4                       (0x20000UL << TIM_SMCR_TS_Pos)          /*!< 0x00200000 */
#define TIM_SMCR_TS_Msk                     (0x30007UL << TIM_SMCR_TS_Pos)          /*!< 0x00300070 */
#define TIM_SMCR_TS_Pos                     (4U)
#define TIM_SR_B2IF                         TIM_SR_B2IF_Msk                         /*!<Break 2 interrupt Flag */
#define TIM_SR_B2IF_Msk                     (0x1UL << TIM_SR_B2IF_Pos)              /*!< 0x00000100 */
#define TIM_SR_B2IF_Pos                     (8U)
#define TIM_SR_BIF                          TIM_SR_BIF_Msk                          /*!<Break interrupt Flag */
#define TIM_SR_BIF_Msk                      (0x1UL << TIM_SR_BIF_Pos)               /*!< 0x00000080 */
#define TIM_SR_BIF_Pos                      (7U)
#define TIM_SR_CC1IF                        TIM_SR_CC1IF_Msk                        /*!<Capture/Compare 1 interrupt Flag */
#define TIM_SR_CC1IF_Msk                    (0x1UL << TIM_SR_CC1IF_Pos)             /*!< 0x00000002 */
#define TIM_SR_CC1IF_Pos                    (1U)
#define TIM_SR_CC1OF                        TIM_SR_CC1OF_Msk                        /*!<Capture/Compare 1 Overcapture Flag */
#define TIM_SR_CC1OF_Msk                    (0x1UL << TIM_SR_CC1OF_Pos)             /*!< 0x00000200 */
#define TIM_SR_CC1OF_Pos                    (9U)
#define TIM_SR_CC2IF                        TIM_SR_CC2IF_Msk                        /*!<Capture/Compare 2 interrupt Flag */
#define TIM_SR_CC2IF_Msk                    (0x1UL << TIM_SR_CC2IF_Pos)             /*!< 0x00000004 */
#define TIM_SR_CC2IF_Pos                    (2U)
#define TIM_SR_CC2OF                        TIM_SR_CC2OF_Msk                        /*!<Capture/Compare 2 Overcapture Flag */
#define TIM_SR_CC2OF_Msk                    (0x1UL << TIM_SR_CC2OF_Pos)             /*!< 0x00000400 */
#define TIM_SR_CC2OF_Pos                    (10U)
#define TIM_SR_CC3IF                        TIM_SR_CC3IF_Msk                        /*!<Capture/Compare 3 interrupt Flag */
#define TIM_SR_CC3IF_Msk                    (0x1UL << TIM_SR_CC3IF_Pos)             /*!< 0x00000008 */
#define TIM_SR_CC3IF_Pos                    (3U)
#define TIM_SR_CC3OF                        TIM_SR_CC3OF_Msk                        /*!<Capture/Compare 3 Overcapture Flag */
#define TIM_SR_CC3OF_Msk                    (0x1UL << TIM_SR_CC3OF_Pos)             /*!< 0x00000800 */
#define TIM_SR_CC3OF_Pos                    (11U)
#define TIM_SR_CC4IF                        TIM_SR_CC4IF_Msk                        /*!<Capture/Compare 4 interrupt Flag */
#define TIM_SR_CC4IF_Msk                    (0x1UL << TIM_SR_CC4IF_Pos)             /*!< 0x00000010 */
#define TIM_SR_CC4IF_Pos                    (4U)
#define TIM_SR_CC4OF                        TIM_SR_CC4OF_Msk                        /*!<Capture/Compare 4 Overcapture Flag */
#define TIM_SR_CC4OF_Msk                    (0x1UL << TIM_SR_CC4OF_Pos)             /*!< 0x00001000 */
#define TIM_SR_CC4OF_Pos                    (12U)
#define TIM_SR_CC5IF                        TIM_SR_CC5IF_Msk                        /*!<Capture/Compare 5 interrupt Flag */
#define TIM_SR_CC5IF_Msk                    (0x1UL << TIM_SR_CC5IF_Pos)             /*!< 0x00010000 */
#define TIM_SR_CC5IF_Pos                    (16U)
#define TIM_SR_CC6IF                        TIM_SR_CC6IF_Msk                        /*!<Capture/Compare 6 interrupt Flag */
#define TIM_SR_CC6IF_Msk                    (0x1UL << TIM_SR_CC6IF_Pos)             /*!< 0x00020000 */
#define TIM_SR_CC6IF_Pos                    (17U)
#define TIM_SR_COMIF                        TIM_SR_COMIF_Msk                        /*!<COM interrupt Flag */
#define TIM_SR_COMIF_Msk                    (0x1UL << TIM_SR_COMIF_Pos)             /*!< 0x00000020 */
#define TIM_SR_COMIF_Pos                    (5U)
#define TIM_SR_DIRF                         TIM_SR_DIRF_Msk                         /*!<Encoder direction change interrupt flag */
#define TIM_SR_DIRF_Msk                     (0x1UL << TIM_SR_DIRF_Pos)              /*!< 0x00200000 */
#define TIM_SR_DIRF_Pos                     (21U)
#define TIM_SR_IDXF                         TIM_SR_IDXF_Msk                         /*!<Encoder index interrupt flag */
#define TIM_SR_IDXF_Msk                     (0x1UL << TIM_SR_IDXF_Pos)              /*!< 0x00100000 */
#define TIM_SR_IDXF_Pos                     (20U)
#define TIM_SR_IERRF                        TIM_SR_IERRF_Msk                        /*!<Encoder index error flag */
#define TIM_SR_IERRF_Msk                    (0x1UL << TIM_SR_IERRF_Pos)             /*!< 0x00400000 */
#define TIM_SR_IERRF_Pos                    (22U)
#define TIM_SR_SBIF                         TIM_SR_SBIF_Msk                         /*!<System Break interrupt Flag */
#define TIM_SR_SBIF_Msk                     (0x1UL << TIM_SR_SBIF_Pos)              /*!< 0x00002000 */
#define TIM_SR_SBIF_Pos                     (13U)
#define TIM_SR_TERRF                        TIM_SR_TERRF_Msk                        /*!<Encoder transition error flag */
#define TIM_SR_TERRF_Msk                    (0x1UL << TIM_SR_TERRF_Pos)             /*!< 0x00800000 */
#define TIM_SR_TERRF_Pos                    (23U)
#define TIM_SR_TIF                          TIM_SR_TIF_Msk                          /*!<Trigger interrupt Flag */
#define TIM_SR_TIF_Msk                      (0x1UL << TIM_SR_TIF_Pos)               /*!< 0x00000040 */
#define TIM_SR_TIF_Pos                      (6U)
#define TIM_SR_UIF                          TIM_SR_UIF_Msk                          /*!<Update interrupt Flag */
#define TIM_SR_UIF_Msk                      (0x1UL << TIM_SR_UIF_Pos)               /*!< 0x00000001 */
#define TIM_SR_UIF_Pos                      (0U)
#define TIM_TISEL_TI1SEL                    TIM_TISEL_TI1SEL_Msk                    /*!<TI1SEL[3:0] bits (TIM1 TI1 SEL)*/
#define TIM_TISEL_TI1SEL_0                  (0x1UL << TIM_TISEL_TI1SEL_Pos)         /*!< 0x00000001 */
#define TIM_TISEL_TI1SEL_1                  (0x2UL << TIM_TISEL_TI1SEL_Pos)         /*!< 0x00000002 */
#define TIM_TISEL_TI1SEL_2                  (0x4UL << TIM_TISEL_TI1SEL_Pos)         /*!< 0x00000004 */
#define TIM_TISEL_TI1SEL_Msk                (0xFUL << TIM_TISEL_TI1SEL_Pos)         /*!< 0x0000000F */
#define TIM_TISEL_TI1SEL_Pos                (0U)
#define TIM_TISEL_TI2SEL                    TIM_TISEL_TI2SEL_Msk                    /*!<TI2SEL[3:0] bits (TIM1 TI2 SEL)*/
#define TIM_TISEL_TI2SEL_0                  (0x1UL << TIM_TISEL_TI2SEL_Pos)         /*!< 0x00000100 */
#define TIM_TISEL_TI2SEL_1                  (0x2UL << TIM_TISEL_TI2SEL_Pos)         /*!< 0x00000200 */
#define TIM_TISEL_TI2SEL_Msk                (0xFUL << TIM_TISEL_TI2SEL_Pos)         /*!< 0x00000F00 */
#define TIM_TISEL_TI2SEL_Pos                (8U)
#define TIM_TISEL_TI3SEL                    TIM_TISEL_TI3SEL_Msk                    /*!<TI3SEL[3:0] bits (TIM1 TI3 SEL)*/
#define TIM_TISEL_TI3SEL_Msk                (0xFUL << TIM_TISEL_TI3SEL_Pos)         /*!< 0x000F0000 */
#define TIM_TISEL_TI3SEL_Pos                (16U)
#define TIM_TISEL_TI4SEL                    TIM_TISEL_TI4SEL_Msk                    /*!<TI4SEL[3:0] bits (TIM1 TI4 SEL)*/
#define TIM_TISEL_TI4SEL_Msk                (0xFUL << TIM_TISEL_TI4SEL_Pos)         /*!< 0x0F000000 */
#define TIM_TISEL_TI4SEL_Pos                (24U)
