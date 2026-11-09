// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// Pinned CMSIS definitions; see LICENSES/NOTICE.txt.
#pragma once
#include <stdint.h>
#define __IO volatile
#define __I volatile const
#define __O volatile
typedef struct
{
       uint32_t RESERVED1;     /*!< Reserved 1,                                      Address offset: 0x00 */
  __IO uint32_t PRIVCFGR;      /*!< DMA privileged configuration register,           Address offset: 0x04 */
  __IO uint32_t RCFGLOCKR;     /*!< DMA configuration lock register,                 Address offset: 0x08 */
  __IO uint32_t MISR;          /*!< DMA masked interrupt status register,            Address offset: 0x0C */
} DMA_TypeDef;
typedef struct
{
  __IO uint32_t CLBAR;         /*!< DMA channel x linked-list base address register, Address offset: 0x50 + (x * 0x80) */
       uint32_t RESERVED1[2];  /*!< Reserved 1,                                      Address offset: 0x54 -- 0x58      */
  __IO uint32_t CFCR;          /*!< DMA channel x flag clear register,               Address offset: 0x5C + (x * 0x80) */
  __IO uint32_t CSR;           /*!< DMA channel x flag status register,              Address offset: 0x60 + (x * 0x80) */
  __IO uint32_t CCR;           /*!< DMA channel x control register,                  Address offset: 0x64 + (x * 0x80) */
       uint32_t RESERVED2[10]; /*!< Reserved 2,                                      Address offset: 0x68 -- 0x8C      */
  __IO uint32_t CTR1;          /*!< DMA channel x transfer register 1,               Address offset: 0x90 + (x * 0x80) */
  __IO uint32_t CTR2;          /*!< DMA channel x transfer register 2,               Address offset: 0x94 + (x * 0x80) */
  __IO uint32_t CBR1;          /*!< DMA channel x block register 1,                  Address offset: 0x98 + (x * 0x80) */
  __IO uint32_t CSAR;          /*!< DMA channel x source address register,           Address offset: 0x9C + (x * 0x80) */
  __IO uint32_t CDAR;          /*!< DMA channel x destination address register,      Address offset: 0xA0 + (x * 0x80) */
  __IO uint32_t CTR3;          /*!< DMA channel x transfer register 3,               Address offset: 0xA4 + (x * 0x80) */
  __IO uint32_t CBR2;          /*!< DMA channel x block register 2,                  Address offset: 0xA8 + (x * 0x80) */
       uint32_t RESERVED3[8];  /*!< Reserved 3,                                      Address offset: 0xAC -- 0xC8      */
  __IO uint32_t CLLR;          /*!< DMA channel x linked-list address register,      Address offset: 0xCC + (x * 0x80) */
} DMA_Channel_TypeDef;
typedef struct
{
  __IO uint32_t CR;            /*!< DMA2D Control Register,                         Address offset: 0x00 */
  __IO uint32_t ISR;           /*!< DMA2D Interrupt Status Register,                Address offset: 0x04 */
  __IO uint32_t IFCR;          /*!< DMA2D Interrupt Flag Clear Register,            Address offset: 0x08 */
  __IO uint32_t FGMAR;         /*!< DMA2D Foreground Memory Address Register,       Address offset: 0x0C */
  __IO uint32_t FGOR;          /*!< DMA2D Foreground Offset Register,               Address offset: 0x10 */
  __IO uint32_t BGMAR;         /*!< DMA2D Background Memory Address Register,       Address offset: 0x14 */
  __IO uint32_t BGOR;          /*!< DMA2D Background Offset Register,               Address offset: 0x18 */
  __IO uint32_t FGPFCCR;       /*!< DMA2D Foreground PFC Control Register,          Address offset: 0x1C */
  __IO uint32_t FGCOLR;        /*!< DMA2D Foreground Color Register,                Address offset: 0x20 */
  __IO uint32_t BGPFCCR;       /*!< DMA2D Background PFC Control Register,          Address offset: 0x24 */
  __IO uint32_t BGCOLR;        /*!< DMA2D Background Color Register,                Address offset: 0x28 */
  __IO uint32_t FGCMAR;        /*!< DMA2D Foreground CLUT Memory Address Register,  Address offset: 0x2C */
  __IO uint32_t BGCMAR;        /*!< DMA2D Background CLUT Memory Address Register,  Address offset: 0x30 */
  __IO uint32_t OPFCCR;        /*!< DMA2D Output PFC Control Register,              Address offset: 0x34 */
  __IO uint32_t OCOLR;         /*!< DMA2D Output Color Register,                    Address offset: 0x38 */
  __IO uint32_t OMAR;          /*!< DMA2D Output Memory Address Register,           Address offset: 0x3C */
  __IO uint32_t OOR;           /*!< DMA2D Output Offset Register,                   Address offset: 0x40 */
  __IO uint32_t NLR;           /*!< DMA2D Number of Line Register,                  Address offset: 0x44 */
  __IO uint32_t LWR;           /*!< DMA2D Line Watermark Register,                  Address offset: 0x48 */
  __IO uint32_t AMTCR;         /*!< DMA2D AHB Master Timer Configuration Register,  Address offset: 0x4C */
  uint32_t      RESERVED[236]; /*!< Reserved,                                 Address offset: 0x50-0x3FF */
  __IO uint32_t FGCLUT[256];   /*!< DMA2D Foreground CLUT,                    Address offset:0x400-0x7FF */
  __IO uint32_t BGCLUT[256];   /*!< DMA2D Background CLUT,                    Address offset:0x800-0xBFF */
} DMA2D_TypeDef;
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
#define AHB1PERIPH_BASE                 (PERIPH_BASE + 0x00020000UL)
#define AHB5PERIPH_BASE                 (PERIPH_BASE + 0x12000000UL)
#define DMA2D_AMTCR_DT             DMA2D_AMTCR_DT_Msk                          /*!< Dead Time */
#define DMA2D_AMTCR_DT_Msk         (0xFFUL << DMA2D_AMTCR_DT_Pos)              /*!< 0x0000FF00 */
#define DMA2D_AMTCR_DT_Pos         (8U)
#define DMA2D_AMTCR_EN             DMA2D_AMTCR_EN_Msk                          /*!< Enable */
#define DMA2D_AMTCR_EN_Msk         (0x1UL << DMA2D_AMTCR_EN_Pos)               /*!< 0x00000001 */
#define DMA2D_AMTCR_EN_Pos         (0U)
#define DMA2D_BGCOLR_BLUE          DMA2D_BGCOLR_BLUE_Msk                       /*!< Blue Value */
#define DMA2D_BGCOLR_BLUE_Msk      (0xFFUL << DMA2D_BGCOLR_BLUE_Pos)           /*!< 0x000000FF */
#define DMA2D_BGCOLR_BLUE_Pos      (0U)
#define DMA2D_BGCOLR_GREEN         DMA2D_BGCOLR_GREEN_Msk                      /*!< Green Value */
#define DMA2D_BGCOLR_GREEN_Msk     (0xFFUL << DMA2D_BGCOLR_GREEN_Pos)          /*!< 0x0000FF00 */
#define DMA2D_BGCOLR_GREEN_Pos     (8U)
#define DMA2D_BGCOLR_RED           DMA2D_BGCOLR_RED_Msk                        /*!< Red Value */
#define DMA2D_BGCOLR_RED_Msk       (0xFFUL << DMA2D_BGCOLR_RED_Pos)            /*!< 0x00FF0000 */
#define DMA2D_BGCOLR_RED_Pos       (16U)
#define DMA2D_BGOR_LO              DMA2D_BGOR_LO_Msk                           /*!< Line Offset */
#define DMA2D_BGOR_LO_Msk          (0xFFFFUL << DMA2D_BGOR_LO_Pos)             /*!< 0x0000FFFF */
#define DMA2D_BGOR_LO_Pos          (0U)
#define DMA2D_BGPFCCR_AI           DMA2D_BGPFCCR_AI_Msk                        /*!< Alpha Inverted */
#define DMA2D_BGPFCCR_AI_Msk       (0x1UL << DMA2D_BGPFCCR_AI_Pos)             /*!< 0x00100000 */
#define DMA2D_BGPFCCR_AI_Pos       (20U)
#define DMA2D_BGPFCCR_ALPHA        DMA2D_BGPFCCR_ALPHA_Msk                     /*!< Alpha value */
#define DMA2D_BGPFCCR_ALPHA_Msk    (0xFFUL << DMA2D_BGPFCCR_ALPHA_Pos)         /*!< 0xFF000000 */
#define DMA2D_BGPFCCR_ALPHA_Pos    (24U)
#define DMA2D_BGPFCCR_AM           DMA2D_BGPFCCR_AM_Msk                        /*!< Alpha mode AM[1:0] */
#define DMA2D_BGPFCCR_AM_Msk       (0x3UL << DMA2D_BGPFCCR_AM_Pos)             /*!< 0x00030000 */
#define DMA2D_BGPFCCR_AM_Pos       (16U)
#define DMA2D_BGPFCCR_CCM          DMA2D_BGPFCCR_CCM_Msk                       /*!< CLUT Color mode */
#define DMA2D_BGPFCCR_CCM_Msk      (0x1UL << DMA2D_BGPFCCR_CCM_Pos)            /*!< 0x00000010 */
#define DMA2D_BGPFCCR_CCM_Pos      (4U)
#define DMA2D_BGPFCCR_CM           DMA2D_BGPFCCR_CM_Msk                        /*!< Input color mode CM[3:0] */
#define DMA2D_BGPFCCR_CM_Msk       (0xFUL << DMA2D_BGPFCCR_CM_Pos)             /*!< 0x0000000F */
#define DMA2D_BGPFCCR_CM_Pos       (0U)
#define DMA2D_BGPFCCR_CS           DMA2D_BGPFCCR_CS_Msk                        /*!< CLUT size */
#define DMA2D_BGPFCCR_CS_Msk       (0xFFUL << DMA2D_BGPFCCR_CS_Pos)            /*!< 0x0000FF00 */
#define DMA2D_BGPFCCR_CS_Pos       (8U)
#define DMA2D_BGPFCCR_RBS          DMA2D_BGPFCCR_RBS_Msk                       /*!< Red Blue Swap */
#define DMA2D_BGPFCCR_RBS_Msk      (0x1UL << DMA2D_BGPFCCR_RBS_Pos)            /*!< 0x00200000 */
#define DMA2D_BGPFCCR_RBS_Pos      (21U)
#define DMA2D_BGPFCCR_START        DMA2D_BGPFCCR_START_Msk                     /*!< Start */
#define DMA2D_BGPFCCR_START_Msk    (0x1UL << DMA2D_BGPFCCR_START_Pos)          /*!< 0x00000020 */
#define DMA2D_BGPFCCR_START_Pos    (5U)
#define DMA2D_CR_ABORT             DMA2D_CR_ABORT_Msk                          /*!< Abort transfer */
#define DMA2D_CR_ABORT_Msk         (0x1UL << DMA2D_CR_ABORT_Pos)               /*!< 0x00000004 */
#define DMA2D_CR_ABORT_Pos         (2U)
#define DMA2D_CR_CAEIE             DMA2D_CR_CAEIE_Msk                          /*!< CLUT Access Error Interrupt Enable */
#define DMA2D_CR_CAEIE_Msk         (0x1UL << DMA2D_CR_CAEIE_Pos)               /*!< 0x00000800 */
#define DMA2D_CR_CAEIE_Pos         (11U)
#define DMA2D_CR_CEIE              DMA2D_CR_CEIE_Msk                           /*!< Configuration Error Interrupt Enable */
#define DMA2D_CR_CEIE_Msk          (0x1UL << DMA2D_CR_CEIE_Pos)                /*!< 0x00002000 */
#define DMA2D_CR_CEIE_Pos          (13U)
#define DMA2D_CR_CTCIE             DMA2D_CR_CTCIE_Msk                          /*!< CLUT Transfer Complete Interrupt Enable */
#define DMA2D_CR_CTCIE_Msk         (0x1UL << DMA2D_CR_CTCIE_Pos)               /*!< 0x00001000 */
#define DMA2D_CR_CTCIE_Pos         (12U)
#define DMA2D_CR_LOM               DMA2D_CR_LOM_Msk                            /*!< Line Offset Mode */
#define DMA2D_CR_LOM_Msk           (0x1UL << DMA2D_CR_LOM_Pos)                 /*!< 0x00000040 */
#define DMA2D_CR_LOM_Pos           (6U)
#define DMA2D_CR_MODE              DMA2D_CR_MODE_Msk                           /*!< DMA2D Mode[2:0] */
#define DMA2D_CR_MODE_0            (0x1UL << DMA2D_CR_MODE_Pos)                /*!< 0x00010000 */
#define DMA2D_CR_MODE_1            (0x2UL << DMA2D_CR_MODE_Pos)                /*!< 0x00020000 */
#define DMA2D_CR_MODE_2            (0x4UL << DMA2D_CR_MODE_Pos)                /*!< 0x00040000 */
#define DMA2D_CR_MODE_Msk          (0x7UL << DMA2D_CR_MODE_Pos)                /*!< 0x00070000 */
#define DMA2D_CR_MODE_Pos          (16U)
#define DMA2D_CR_START             DMA2D_CR_START_Msk                          /*!< Start transfer */
#define DMA2D_CR_START_Msk         (0x1UL << DMA2D_CR_START_Pos)               /*!< 0x00000001 */
#define DMA2D_CR_START_Pos         (0U)
#define DMA2D_CR_SUSP              DMA2D_CR_SUSP_Msk                           /*!< Suspend transfer */
#define DMA2D_CR_SUSP_Msk          (0x1UL << DMA2D_CR_SUSP_Pos)                /*!< 0x00000002 */
#define DMA2D_CR_SUSP_Pos          (1U)
#define DMA2D_CR_TCIE              DMA2D_CR_TCIE_Msk                           /*!< Transfer Complete Interrupt Enable */
#define DMA2D_CR_TCIE_Msk          (0x1UL << DMA2D_CR_TCIE_Pos)                /*!< 0x00000200 */
#define DMA2D_CR_TCIE_Pos          (9U)
#define DMA2D_CR_TEIE              DMA2D_CR_TEIE_Msk                           /*!< Transfer Error Interrupt Enable */
#define DMA2D_CR_TEIE_Msk          (0x1UL << DMA2D_CR_TEIE_Pos)                /*!< 0x00000100 */
#define DMA2D_CR_TEIE_Pos          (8U)
#define DMA2D_CR_TWIE              DMA2D_CR_TWIE_Msk                           /*!< Transfer Watermark Interrupt Enable */
#define DMA2D_CR_TWIE_Msk          (0x1UL << DMA2D_CR_TWIE_Pos)                /*!< 0x00000400 */
#define DMA2D_CR_TWIE_Pos          (10U)
#define DMA2D_FGCOLR_BLUE          DMA2D_FGCOLR_BLUE_Msk                       /*!< Blue Value */
#define DMA2D_FGCOLR_BLUE_Msk      (0xFFUL << DMA2D_FGCOLR_BLUE_Pos)           /*!< 0x000000FF */
#define DMA2D_FGCOLR_BLUE_Pos      (0U)
#define DMA2D_FGCOLR_GREEN         DMA2D_FGCOLR_GREEN_Msk                      /*!< Green Value */
#define DMA2D_FGCOLR_GREEN_Msk     (0xFFUL << DMA2D_FGCOLR_GREEN_Pos)          /*!< 0x0000FF00 */
#define DMA2D_FGCOLR_GREEN_Pos     (8U)
#define DMA2D_FGCOLR_RED           DMA2D_FGCOLR_RED_Msk                        /*!< Red Value */
#define DMA2D_FGCOLR_RED_Msk       (0xFFUL << DMA2D_FGCOLR_RED_Pos)            /*!< 0x00FF0000 */
#define DMA2D_FGCOLR_RED_Pos       (16U)
#define DMA2D_FGOR_LO              DMA2D_FGOR_LO_Msk                           /*!< Line Offset */
#define DMA2D_FGOR_LO_Msk          (0xFFFFUL << DMA2D_FGOR_LO_Pos)             /*!< 0x0000FFFF */
#define DMA2D_FGOR_LO_Pos          (0U)
#define DMA2D_FGPFCCR_AI           DMA2D_FGPFCCR_AI_Msk                        /*!< Alpha Inverted */
#define DMA2D_FGPFCCR_AI_Msk       (0x1UL << DMA2D_FGPFCCR_AI_Pos)             /*!< 0x00100000 */
#define DMA2D_FGPFCCR_AI_Pos       (20U)
#define DMA2D_FGPFCCR_ALPHA        DMA2D_FGPFCCR_ALPHA_Msk                     /*!< Alpha value */
#define DMA2D_FGPFCCR_ALPHA_Msk    (0xFFUL << DMA2D_FGPFCCR_ALPHA_Pos)         /*!< 0xFF000000 */
#define DMA2D_FGPFCCR_ALPHA_Pos    (24U)
#define DMA2D_FGPFCCR_AM           DMA2D_FGPFCCR_AM_Msk                        /*!< Alpha mode AM[1:0] */
#define DMA2D_FGPFCCR_AM_0         (0x1UL << DMA2D_FGPFCCR_AM_Pos)             /*!< 0x00010000 */
#define DMA2D_FGPFCCR_AM_1         (0x2UL << DMA2D_FGPFCCR_AM_Pos)             /*!< 0x00020000 */
#define DMA2D_FGPFCCR_AM_Msk       (0x3UL << DMA2D_FGPFCCR_AM_Pos)             /*!< 0x00030000 */
#define DMA2D_FGPFCCR_AM_Pos       (16U)
#define DMA2D_FGPFCCR_CCM          DMA2D_FGPFCCR_CCM_Msk                       /*!< CLUT Color mode */
#define DMA2D_FGPFCCR_CCM_Msk      (0x1UL << DMA2D_FGPFCCR_CCM_Pos)            /*!< 0x00000010 */
#define DMA2D_FGPFCCR_CCM_Pos      (4U)
#define DMA2D_FGPFCCR_CM           DMA2D_FGPFCCR_CM_Msk                        /*!< Input color mode CM[3:0] */
#define DMA2D_FGPFCCR_CM_0         (0x1UL << DMA2D_FGPFCCR_CM_Pos)             /*!< 0x00000001 */
#define DMA2D_FGPFCCR_CM_1         (0x2UL << DMA2D_FGPFCCR_CM_Pos)             /*!< 0x00000002 */
#define DMA2D_FGPFCCR_CM_2         (0x4UL << DMA2D_FGPFCCR_CM_Pos)             /*!< 0x00000004 */
#define DMA2D_FGPFCCR_CM_3         (0x8UL << DMA2D_FGPFCCR_CM_Pos)             /*!< 0x00000008 */
#define DMA2D_FGPFCCR_CM_Msk       (0xFUL << DMA2D_FGPFCCR_CM_Pos)             /*!< 0x0000000F */
#define DMA2D_FGPFCCR_CM_Pos       (0U)
#define DMA2D_FGPFCCR_CS           DMA2D_FGPFCCR_CS_Msk                        /*!< CLUT size */
#define DMA2D_FGPFCCR_CSS          DMA2D_FGPFCCR_CSS_Msk                       /*!< Chroma Sub-Sampling */
#define DMA2D_FGPFCCR_CSS_0        (0x1UL << DMA2D_FGPFCCR_CSS_Pos)            /*!< 0x00040000 */
#define DMA2D_FGPFCCR_CSS_1        (0x2UL << DMA2D_FGPFCCR_CSS_Pos)            /*!< 0x00080000 */
#define DMA2D_FGPFCCR_CSS_Msk      (0x3UL << DMA2D_FGPFCCR_CSS_Pos)            /*!< 0x000C0000 */
#define DMA2D_FGPFCCR_CSS_Pos      (18U)
#define DMA2D_FGPFCCR_CS_Msk       (0xFFUL << DMA2D_FGPFCCR_CS_Pos)            /*!< 0x0000FF00 */
#define DMA2D_FGPFCCR_CS_Pos       (8U)
#define DMA2D_FGPFCCR_RBS          DMA2D_FGPFCCR_RBS_Msk                       /*!< Red Blue Swap */
#define DMA2D_FGPFCCR_RBS_Msk      (0x1UL << DMA2D_FGPFCCR_RBS_Pos)            /*!< 0x00200000 */
#define DMA2D_FGPFCCR_RBS_Pos      (21U)
#define DMA2D_FGPFCCR_START        DMA2D_FGPFCCR_START_Msk                     /*!< Start */
#define DMA2D_FGPFCCR_START_Msk    (0x1UL << DMA2D_FGPFCCR_START_Pos)          /*!< 0x00000020 */
#define DMA2D_FGPFCCR_START_Pos    (5U)
#define DMA2D_IFCR_CAECIF          DMA2D_IFCR_CAECIF_Msk                       /*!< Clears CLUT Access Error Interrupt Flag */
#define DMA2D_IFCR_CAECIF_Msk      (0x1UL << DMA2D_IFCR_CAECIF_Pos)            /*!< 0x00000008 */
#define DMA2D_IFCR_CAECIF_Pos      (3U)
#define DMA2D_IFCR_CCEIF           DMA2D_IFCR_CCEIF_Msk                        /*!< Clears Configuration Error Interrupt Flag */
#define DMA2D_IFCR_CCEIF_Msk       (0x1UL << DMA2D_IFCR_CCEIF_Pos)             /*!< 0x00000020 */
#define DMA2D_IFCR_CCEIF_Pos       (5U)
#define DMA2D_IFCR_CCTCIF          DMA2D_IFCR_CCTCIF_Msk                       /*!< Clears CLUT Transfer Complete Interrupt Flag */
#define DMA2D_IFCR_CCTCIF_Msk      (0x1UL << DMA2D_IFCR_CCTCIF_Pos)            /*!< 0x00000010 */
#define DMA2D_IFCR_CCTCIF_Pos      (4U)
#define DMA2D_IFCR_CTCIF           DMA2D_IFCR_CTCIF_Msk                        /*!< Clears Transfer Complete Interrupt Flag */
#define DMA2D_IFCR_CTCIF_Msk       (0x1UL << DMA2D_IFCR_CTCIF_Pos)             /*!< 0x00000002 */
#define DMA2D_IFCR_CTCIF_Pos       (1U)
#define DMA2D_IFCR_CTEIF           DMA2D_IFCR_CTEIF_Msk                        /*!< Clears Transfer Error Interrupt Flag */
#define DMA2D_IFCR_CTEIF_Msk       (0x1UL << DMA2D_IFCR_CTEIF_Pos)             /*!< 0x00000001 */
#define DMA2D_IFCR_CTEIF_Pos       (0U)
#define DMA2D_IFCR_CTWIF           DMA2D_IFCR_CTWIF_Msk                        /*!< Clears Transfer Watermark Interrupt Flag */
#define DMA2D_IFCR_CTWIF_Msk       (0x1UL << DMA2D_IFCR_CTWIF_Pos)             /*!< 0x00000004 */
#define DMA2D_IFCR_CTWIF_Pos       (2U)
#define DMA2D_ISR_CAEIF            DMA2D_ISR_CAEIF_Msk                         /*!< CLUT Access Error Interrupt Flag */
#define DMA2D_ISR_CAEIF_Msk        (0x1UL << DMA2D_ISR_CAEIF_Pos)              /*!< 0x00000008 */
#define DMA2D_ISR_CAEIF_Pos        (3U)
#define DMA2D_ISR_CEIF             DMA2D_ISR_CEIF_Msk                          /*!< Configuration Error Interrupt Flag */
#define DMA2D_ISR_CEIF_Msk         (0x1UL << DMA2D_ISR_CEIF_Pos)               /*!< 0x00000020 */
#define DMA2D_ISR_CEIF_Pos         (5U)
#define DMA2D_ISR_CTCIF            DMA2D_ISR_CTCIF_Msk                         /*!< CLUT Transfer Complete Interrupt Flag */
#define DMA2D_ISR_CTCIF_Msk        (0x1UL << DMA2D_ISR_CTCIF_Pos)              /*!< 0x00000010 */
#define DMA2D_ISR_CTCIF_Pos        (4U)
#define DMA2D_ISR_TCIF             DMA2D_ISR_TCIF_Msk                          /*!< Transfer Complete Interrupt Flag */
#define DMA2D_ISR_TCIF_Msk         (0x1UL << DMA2D_ISR_TCIF_Pos)               /*!< 0x00000002 */
#define DMA2D_ISR_TCIF_Pos         (1U)
#define DMA2D_ISR_TEIF             DMA2D_ISR_TEIF_Msk                          /*!< Transfer Error Interrupt Flag */
#define DMA2D_ISR_TEIF_Msk         (0x1UL << DMA2D_ISR_TEIF_Pos)               /*!< 0x00000001 */
#define DMA2D_ISR_TEIF_Pos         (0U)
#define DMA2D_ISR_TWIF             DMA2D_ISR_TWIF_Msk                          /*!< Transfer Watermark Interrupt Flag */
#define DMA2D_ISR_TWIF_Msk         (0x1UL << DMA2D_ISR_TWIF_Pos)               /*!< 0x00000004 */
#define DMA2D_ISR_TWIF_Pos         (2U)
#define DMA2D_LWR_LW               DMA2D_LWR_LW_Msk                            /*!< Line Watermark */
#define DMA2D_LWR_LW_Msk           (0xFFFFUL << DMA2D_LWR_LW_Pos)              /*!< 0x0000FFFF */
#define DMA2D_LWR_LW_Pos           (0U)
#define DMA2D_NLR_NL               DMA2D_NLR_NL_Msk                            /*!< Number of Lines */
#define DMA2D_NLR_NL_Msk           (0xFFFFUL << DMA2D_NLR_NL_Pos)              /*!< 0x0000FFFF */
#define DMA2D_NLR_NL_Pos           (0U)
#define DMA2D_NLR_PL               DMA2D_NLR_PL_Msk                            /*!< Pixel per Lines */
#define DMA2D_NLR_PL_Msk           (0x3FFFUL << DMA2D_NLR_PL_Pos)              /*!< 0x3FFF0000 */
#define DMA2D_NLR_PL_Pos           (16U)
#define DMA2D_OCOLR_ALPHA_1        (0xFF000000UL)                              /*!< Alpha Channel Value */
#define DMA2D_OCOLR_BLUE_1         (0x000000FFUL)                              /*!< Blue Value */
#define DMA2D_OCOLR_GREEN_1        (0x0000FF00UL)                              /*!< Green Value  */
#define DMA2D_OCOLR_RED_1          (0x00FF0000UL)                              /*!< Red Value */
#define DMA2D_OOR_LO               DMA2D_OOR_LO_Msk                            /*!< Line Offset */
#define DMA2D_OOR_LO_Msk           (0xFFFFUL << DMA2D_OOR_LO_Pos)              /*!< 0x0000FFFF */
#define DMA2D_OOR_LO_Pos           (0U)
#define DMA2D_OPFCCR_AI            DMA2D_OPFCCR_AI_Msk                         /*!< Alpha Inverted */
#define DMA2D_OPFCCR_AI_Msk        (0x1UL << DMA2D_OPFCCR_AI_Pos)              /*!< 0x00100000 */
#define DMA2D_OPFCCR_AI_Pos        (20U)
#define DMA2D_OPFCCR_CM            DMA2D_OPFCCR_CM_Msk                         /*!< Color mode CM[2:0] */
#define DMA2D_OPFCCR_CM_0          (0x1UL << DMA2D_OPFCCR_CM_Pos)              /*!< 0x00000001 */
#define DMA2D_OPFCCR_CM_1          (0x2UL << DMA2D_OPFCCR_CM_Pos)              /*!< 0x00000002 */
#define DMA2D_OPFCCR_CM_2          (0x4UL << DMA2D_OPFCCR_CM_Pos)              /*!< 0x00000004 */
#define DMA2D_OPFCCR_CM_Msk        (0x7UL << DMA2D_OPFCCR_CM_Pos)              /*!< 0x00000007 */
#define DMA2D_OPFCCR_CM_Pos        (0U)
#define DMA2D_OPFCCR_RBS           DMA2D_OPFCCR_RBS_Msk                        /*!< Red Blue Swap */
#define DMA2D_OPFCCR_RBS_Msk       (0x1UL << DMA2D_OPFCCR_RBS_Pos)             /*!< 0x00200000 */
#define DMA2D_OPFCCR_RBS_Pos       (21U)
#define DMA2D_OPFCCR_SB            DMA2D_OPFCCR_SB_Msk                         /*!< Swap Bytes */
#define DMA2D_OPFCCR_SB_Msk        (0x1UL << DMA2D_OPFCCR_SB_Pos)              /*!< 0x00000100 */
#define DMA2D_OPFCCR_SB_Pos        (8U)
#define DMA_CBR1_BNDT                       DMA_CBR1_BNDT_Msk                       /*!< Block number of data bytes to transfer from the source */
#define DMA_CBR1_BNDT_Msk                   (0xFFFFUL << DMA_CBR1_BNDT_Pos)         /*!< 0x0000FFFF */
#define DMA_CBR1_BNDT_Pos                   (0U)
#define DMA_CBR1_BRC                        DMA_CBR1_BRC_Msk                        /*!< Block repeat counter */
#define DMA_CBR1_BRC_Msk                    (0x7FFUL << DMA_CBR1_BRC_Pos)           /*!< 0x07FF0000 */
#define DMA_CBR1_BRC_Pos                    (16U)
#define DMA_CBR1_BRDDEC                     DMA_CBR1_BRDDEC_Msk                     /*!< Block repeat destination address decrement */
#define DMA_CBR1_BRDDEC_Msk                 (0x1UL << DMA_CBR1_BRDDEC_Pos)          /*!< 0x80000000 */
#define DMA_CBR1_BRDDEC_Pos                 (31U)
#define DMA_CBR1_BRSDEC                     DMA_CBR1_BRSDEC_Msk                     /*!< Block repeat source address decrement */
#define DMA_CBR1_BRSDEC_Msk                 (0x1UL << DMA_CBR1_BRSDEC_Pos)          /*!< 0x40000000 */
#define DMA_CBR1_BRSDEC_Pos                 (30U)
#define DMA_CBR1_DDEC                       DMA_CBR1_DDEC_Msk                       /*!< Destination address decrement */
#define DMA_CBR1_DDEC_Msk                   (0x1UL << DMA_CBR1_DDEC_Pos)            /*!< 0x20000000 */
#define DMA_CBR1_DDEC_Pos                   (29U)
#define DMA_CBR1_SDEC                       DMA_CBR1_SDEC_Msk                       /*!< Source address decrement */
#define DMA_CBR1_SDEC_Msk                   (0x1UL << DMA_CBR1_SDEC_Pos)            /*!< 0x10000000 */
#define DMA_CBR1_SDEC_Pos                   (28U)
#define DMA_CBR2_BRDAO                      DMA_CBR2_BRDAO_Msk                      /*!< Block repeated destination address offset */
#define DMA_CBR2_BRDAO_Msk                  (0xFFFFUL << DMA_CBR2_BRDAO_Pos)        /*!< 0xFFFF0000 */
#define DMA_CBR2_BRDAO_Pos                  (16U)
#define DMA_CBR2_BRSAO                      DMA_CBR2_BRSAO_Msk                      /*!< Block repeated source address offset */
#define DMA_CBR2_BRSAO_Msk                  (0xFFFFUL << DMA_CBR2_BRSAO_Pos)        /*!< 0x0000FFFF */
#define DMA_CBR2_BRSAO_Pos                  (0U)
#define DMA_CCR_DTEIE                       DMA_CCR_DTEIE_Msk                       /*!< Data transfer error interrupt enable */
#define DMA_CCR_DTEIE_Msk                   (0x1UL << DMA_CCR_DTEIE_Pos)            /*!< 0x00000400 */
#define DMA_CCR_DTEIE_Pos                   (10U)
#define DMA_CCR_EN                          DMA_CCR_EN_Msk                          /*!< Channel enable */
#define DMA_CCR_EN_Msk                      (0x1UL << DMA_CCR_EN_Pos)               /*!< 0x00000001 */
#define DMA_CCR_EN_Pos                      (0U)
#define DMA_CCR_HTIE                        DMA_CCR_HTIE_Msk                        /*!< Half transfer complete interrupt enable */
#define DMA_CCR_HTIE_Msk                    (0x1UL << DMA_CCR_HTIE_Pos)             /*!< 0x00000200 */
#define DMA_CCR_HTIE_Pos                    (9U)
#define DMA_CCR_LAP                         DMA_CCR_LAP_Msk                         /*!< Linked-list allocated port */
#define DMA_CCR_LAP_Msk                     (0x1UL << DMA_CCR_LAP_Pos)              /*!< 0x00020000 */
#define DMA_CCR_LAP_Pos                     (17U)
#define DMA_CCR_LSM                         DMA_CCR_LSM_Msk                         /*!< Link step mode */
#define DMA_CCR_LSM_Msk                     (0x1UL << DMA_CCR_LSM_Pos)              /*!< 0x00010000 */
#define DMA_CCR_LSM_Pos                     (16U)
#define DMA_CCR_PRIO                        DMA_CCR_PRIO_Msk                        /*!< Priority level */
#define DMA_CCR_PRIO_0                      (0x1UL << DMA_CCR_PRIO_Pos)             /*!< 0x00400000 */
#define DMA_CCR_PRIO_1                      (0x2UL << DMA_CCR_PRIO_Pos)             /*!< 0x00800000 */
#define DMA_CCR_PRIO_Msk                    (0x3UL << DMA_CCR_PRIO_Pos)             /*!< 0x00C00000 */
#define DMA_CCR_PRIO_Pos                    (22U)
#define DMA_CCR_RESET                       DMA_CCR_RESET_Msk                       /*!< Channel reset */
#define DMA_CCR_RESET_Msk                   (0x1UL << DMA_CCR_RESET_Pos)            /*!< 0x00000002 */
#define DMA_CCR_RESET_Pos                   (1U)
#define DMA_CCR_SUSP                        DMA_CCR_SUSP_Msk                        /*!< Channel suspend */
#define DMA_CCR_SUSPIE                      DMA_CCR_SUSPIE_Msk                      /*!< Completed suspension interrupt enable */
#define DMA_CCR_SUSPIE_Msk                  (0x1UL << DMA_CCR_SUSPIE_Pos)           /*!< 0x00002000 */
#define DMA_CCR_SUSPIE_Pos                  (13U)
#define DMA_CCR_SUSP_Msk                    (0x1UL << DMA_CCR_SUSP_Pos)             /*!< 0x00000004 */
#define DMA_CCR_SUSP_Pos                    (2U)
#define DMA_CCR_TCIE                        DMA_CCR_TCIE_Msk                        /*!< Transfer complete interrupt enable */
#define DMA_CCR_TCIE_Msk                    (0x1UL << DMA_CCR_TCIE_Pos)             /*!< 0x00000100 */
#define DMA_CCR_TCIE_Pos                    (8U)
#define DMA_CCR_TOIE                        DMA_CCR_TOIE_Msk                        /*!< Trigger overrun interrupt enable */
#define DMA_CCR_TOIE_Msk                    (0x1UL << DMA_CCR_TOIE_Pos)             /*!< 0x00004000 */
#define DMA_CCR_TOIE_Pos                    (14U)
#define DMA_CCR_ULEIE                       DMA_CCR_ULEIE_Msk                       /*!< Update linked-list item error interrupt enable */
#define DMA_CCR_ULEIE_Msk                   (0x1UL << DMA_CCR_ULEIE_Pos)            /*!< 0x00000800 */
#define DMA_CCR_ULEIE_Pos                   (11U)
#define DMA_CCR_USEIE                       DMA_CCR_USEIE_Msk                       /*!< User setting error interrupt enable */
#define DMA_CCR_USEIE_Msk                   (0x1UL << DMA_CCR_USEIE_Pos)            /*!< 0x00001000 */
#define DMA_CCR_USEIE_Pos                   (12U)
#define DMA_CFCR_DTEF                       DMA_CFCR_DTEF_Msk                       /*!< Data transfer error flag clear */
#define DMA_CFCR_DTEF_Msk                   (0x1UL << DMA_CFCR_DTEF_Pos)            /*!< 0x00000400 */
#define DMA_CFCR_DTEF_Pos                   (10U)
#define DMA_CFCR_HTF                        DMA_CFCR_HTF_Msk                        /*!< Half transfer complete flag clear */
#define DMA_CFCR_HTF_Msk                    (0x1UL << DMA_CFCR_HTF_Pos)             /*!< 0x00000200 */
#define DMA_CFCR_HTF_Pos                    (9U)
#define DMA_CFCR_SUSPF                      DMA_CFCR_SUSPF_Msk                      /*!< Completed suspension flag clear */
#define DMA_CFCR_SUSPF_Msk                  (0x1UL << DMA_CFCR_SUSPF_Pos)           /*!< 0x00002000 */
#define DMA_CFCR_SUSPF_Pos                  (13U)
#define DMA_CFCR_TCF                        DMA_CFCR_TCF_Msk                        /*!< Transfer complete flag clear */
#define DMA_CFCR_TCF_Msk                    (0x1UL << DMA_CFCR_TCF_Pos)             /*!< 0x00000100 */
#define DMA_CFCR_TCF_Pos                    (8U)
#define DMA_CFCR_TOF                        DMA_CFCR_TOF_Msk                        /*!< Trigger overrun clear flag */
#define DMA_CFCR_TOF_Msk                    (0x1UL << DMA_CFCR_TOF_Pos)             /*!< 0x00004000 */
#define DMA_CFCR_TOF_Pos                    (14U)
#define DMA_CFCR_ULEF                       DMA_CFCR_ULEF_Msk                       /*!< Update linked-list item error flag clear */
#define DMA_CFCR_ULEF_Msk                   (0x1UL << DMA_CFCR_ULEF_Pos)            /*!< 0x00000800 */
#define DMA_CFCR_ULEF_Pos                   (11U)
#define DMA_CFCR_USEF                       DMA_CFCR_USEF_Msk                       /*!< User setting error flag clear */
#define DMA_CFCR_USEF_Msk                   (0x1UL << DMA_CFCR_USEF_Pos)            /*!< 0x00001000 */
#define DMA_CFCR_USEF_Pos                   (12U)
#define DMA_CLBAR_LBA                       DMA_CLBAR_LBA_Msk                       /*!< Linked-list Base Address of DMA channel x */
#define DMA_CLBAR_LBA_Msk                   (0xFFFFUL << DMA_CLBAR_LBA_Pos)         /*!< 0xFFFF0000 */
#define DMA_CLBAR_LBA_Pos                   (16U)
#define DMA_CLLR_LA                         DMA_CLLR_LA_Msk                         /*!< Pointer to the next linked-list data structure */
#define DMA_CLLR_LA_Msk                     (0x3FFFUL << DMA_CLLR_LA_Pos)           /*!< 0x0000FFFC */
#define DMA_CLLR_LA_Pos                     (2U)
#define DMA_CLLR_UB1                        DMA_CLLR_UB1_Msk                        /*!< Update block register 1 from SRAM */
#define DMA_CLLR_UB1_Msk                    (0x1UL << DMA_CLLR_UB1_Pos)             /*!< 0x20000000 */
#define DMA_CLLR_UB1_Pos                    (29U)
#define DMA_CLLR_UB2                        DMA_CLLR_UB2_Msk                        /*!< Update block register 2 from memory */
#define DMA_CLLR_UB2_Msk                    (0x1UL << DMA_CLLR_UB2_Pos)             /*!< 0x02000000 */
#define DMA_CLLR_UB2_Pos                    (25U)
#define DMA_CLLR_UDA                        DMA_CLLR_UDA_Msk                        /*!< Update destination address register from SRAM */
#define DMA_CLLR_UDA_Msk                    (0x1UL << DMA_CLLR_UDA_Pos)             /*!< 0x08000000 */
#define DMA_CLLR_UDA_Pos                    (27U)
#define DMA_CLLR_ULL                        DMA_CLLR_ULL_Msk                        /*!< Update link address register from memory */
#define DMA_CLLR_ULL_Msk                    (0x1UL << DMA_CLLR_ULL_Pos)             /*!< 0x00010000 */
#define DMA_CLLR_ULL_Pos                    (16U)
#define DMA_CLLR_USA                        DMA_CLLR_USA_Msk                        /*!< Update source address register from SRAM */
#define DMA_CLLR_USA_Msk                    (0x1UL << DMA_CLLR_USA_Pos)             /*!< 0x10000000 */
#define DMA_CLLR_USA_Pos                    (28U)
#define DMA_CLLR_UT1                        DMA_CLLR_UT1_Msk                        /*!< Update transfer register 1 from SRAM */
#define DMA_CLLR_UT1_Msk                    (0x1UL << DMA_CLLR_UT1_Pos)             /*!< 0x80000000 */
#define DMA_CLLR_UT1_Pos                    (31U)
#define DMA_CLLR_UT2                        DMA_CLLR_UT2_Msk                        /*!< Update transfer register 2 from SRAM */
#define DMA_CLLR_UT2_Msk                    (0x1UL << DMA_CLLR_UT2_Pos)             /*!< 0x40000000 */
#define DMA_CLLR_UT2_Pos                    (30U)
#define DMA_CLLR_UT3                        DMA_CLLR_UT3_Msk                        /*!< Update transfer register 3 from SRAM */
#define DMA_CLLR_UT3_Msk                    (0x1UL << DMA_CLLR_UT3_Pos)             /*!< 0x04000000 */
#define DMA_CLLR_UT3_Pos                    (26U)
#define DMA_CSR_DTEF                        DMA_CSR_DTEF_Msk                        /*!< Data transfer error flag */
#define DMA_CSR_DTEF_Msk                    (0x1UL << DMA_CSR_DTEF_Pos)             /*!< 0x00000400 */
#define DMA_CSR_DTEF_Pos                    (10U)
#define DMA_CSR_FIFOL                       DMA_CSR_FIFOL_Msk                       /*!< Monitored FIFO level in bytes */
#define DMA_CSR_FIFOL_Msk                   (0xFFUL << DMA_CSR_FIFOL_Pos)           /*!< 0x00FF0000 */
#define DMA_CSR_FIFOL_Pos                   (16U)
#define DMA_CSR_HTF                         DMA_CSR_HTF_Msk                         /*!< Half transfer complete flag */
#define DMA_CSR_HTF_Msk                     (0x1UL << DMA_CSR_HTF_Pos)              /*!< 0x00000200 */
#define DMA_CSR_HTF_Pos                     (9U)
#define DMA_CSR_IDLEF                       DMA_CSR_IDLEF_Msk                       /*!< Idle flag */
#define DMA_CSR_IDLEF_Msk                   (0x1UL << DMA_CSR_IDLEF_Pos)            /*!< 0x00000001 */
#define DMA_CSR_IDLEF_Pos                   (0U)
#define DMA_CSR_SUSPF                       DMA_CSR_SUSPF_Msk                       /*!< User setting error flag */
#define DMA_CSR_SUSPF_Msk                   (0x1UL << DMA_CSR_SUSPF_Pos)            /*!< 0x00002000 */
#define DMA_CSR_SUSPF_Pos                   (13U)
#define DMA_CSR_TCF                         DMA_CSR_TCF_Msk                         /*!< Transfer complete flag */
#define DMA_CSR_TCF_Msk                     (0x1UL << DMA_CSR_TCF_Pos)              /*!< 0x00000100 */
#define DMA_CSR_TCF_Pos                     (8U)
#define DMA_CSR_TOF                         DMA_CSR_TOF_Msk                         /*!< Trigger overrun flag */
#define DMA_CSR_TOF_Msk                     (0x1UL << DMA_CSR_TOF_Pos)              /*!< 0x00004000 */
#define DMA_CSR_TOF_Pos                     (14U)
#define DMA_CSR_ULEF                        DMA_CSR_ULEF_Msk                        /*!< Update linked-list item error flag */
#define DMA_CSR_ULEF_Msk                    (0x1UL << DMA_CSR_ULEF_Pos)             /*!< 0x00000800 */
#define DMA_CSR_ULEF_Pos                    (11U)
#define DMA_CSR_USEF                        DMA_CSR_USEF_Msk                        /*!< User setting error flag */
#define DMA_CSR_USEF_Msk                    (0x1UL << DMA_CSR_USEF_Pos)             /*!< 0x00001000 */
#define DMA_CSR_USEF_Pos                    (12U)
#define DMA_CTR1_DAP                        DMA_CTR1_DAP_Msk                        /*!< Destination allocated port */
#define DMA_CTR1_DAP_Msk                    (0x1UL << DMA_CTR1_DAP_Pos)             /*!< 0x40000000 */
#define DMA_CTR1_DAP_Pos                    (30U)
#define DMA_CTR1_DBL_1                      DMA_CTR1_DBL_1_Msk                      /*!< Destination burst length minus 1 */
#define DMA_CTR1_DBL_1_Msk                  (0x3FUL << DMA_CTR1_DBL_1_Pos)          /*!< 0x03F00000 */
#define DMA_CTR1_DBL_1_Pos                  (20U)
#define DMA_CTR1_DBX                        DMA_CTR1_DBX_Msk                        /*!< Destination byte exchange */
#define DMA_CTR1_DBX_Msk                    (0x1UL << DMA_CTR1_DBX_Pos)             /*!< 0x04000000 */
#define DMA_CTR1_DBX_Pos                    (26U)
#define DMA_CTR1_DDW_LOG2                   DMA_CTR1_DDW_LOG2_Msk                   /*!< Binary logarithm of the destination data width of a burst */
#define DMA_CTR1_DDW_LOG2_0                 (0x1UL << DMA_CTR1_DDW_LOG2_Pos)        /*!< Bit 0 */
#define DMA_CTR1_DDW_LOG2_1                 (0x2UL << DMA_CTR1_DDW_LOG2_Pos)        /*!< Bit 1 */
#define DMA_CTR1_DDW_LOG2_Msk               (0x3UL << DMA_CTR1_DDW_LOG2_Pos)        /*!< 0x00030000 */
#define DMA_CTR1_DDW_LOG2_Pos               (16U)
#define DMA_CTR1_DHX                        DMA_CTR1_DHX_Msk                        /*!< Destination half-word exchange */
#define DMA_CTR1_DHX_Msk                    (0x1UL << DMA_CTR1_DHX_Pos)             /*!< 0x08000000 */
#define DMA_CTR1_DHX_Pos                    (27U)
#define DMA_CTR1_DINC                       DMA_CTR1_DINC_Msk                       /*!< Destination incrementing burst */
#define DMA_CTR1_DINC_Msk                   (0x1UL << DMA_CTR1_DINC_Pos)            /*!< 0x00080000 */
#define DMA_CTR1_DINC_Pos                   (19U)
#define DMA_CTR1_DWX                        DMA_CTR1_DWX_Msk                        /*!< Destination word-word exchange */
#define DMA_CTR1_DWX_Msk                    (0x1UL << DMA_CTR1_DWX_Pos)             /*!< 0x10000000 */
#define DMA_CTR1_DWX_Pos                    (28U)
#define DMA_CTR1_PAM                        DMA_CTR1_PAM_Msk                        /*!< Padding / alignment mode */
#define DMA_CTR1_PAM_0                      (0x1UL << DMA_CTR1_PAM_Pos)             /*!< Bit 0 */
#define DMA_CTR1_PAM_1                      (0x2UL << DMA_CTR1_PAM_Pos)             /*!< Bit 1 */
#define DMA_CTR1_PAM_Msk                    (0x3UL << DMA_CTR1_PAM_Pos)             /*!< 0x0001800 */
#define DMA_CTR1_PAM_Pos                    (11U)
#define DMA_CTR1_SAP                        DMA_CTR1_SAP_Msk                        /*!< Source allocated port */
#define DMA_CTR1_SAP_Msk                    (0x1UL << DMA_CTR1_SAP_Pos)             /*!< 0x00004000 */
#define DMA_CTR1_SAP_Pos                    (14U)
#define DMA_CTR1_SBL_1                      DMA_CTR1_SBL_1_Msk                      /*!< Source burst length minus 1 */
#define DMA_CTR1_SBL_1_Msk                  (0x3FUL << DMA_CTR1_SBL_1_Pos)          /*!< 0x000003F0 */
#define DMA_CTR1_SBL_1_Pos                  (4U)
#define DMA_CTR1_SBX                        DMA_CTR1_SBX_Msk                        /*!< Source byte exchange within the unaligned half-word of each source word */
#define DMA_CTR1_SBX_Msk                    (0x1UL << DMA_CTR1_SBX_Pos)             /*!< 0x00002000 */
#define DMA_CTR1_SBX_Pos                    (13U)
#define DMA_CTR1_SDW_LOG2                   DMA_CTR1_SDW_LOG2_Msk                   /*!< Binary logarithm of the source data width of a burst */
#define DMA_CTR1_SDW_LOG2_0                 (0x1UL << DMA_CTR1_SDW_LOG2_Pos)        /*!< Bit 0 */
#define DMA_CTR1_SDW_LOG2_1                 (0x2UL << DMA_CTR1_SDW_LOG2_Pos)        /*!< Bit 1 */
#define DMA_CTR1_SDW_LOG2_Msk               (0x3UL << DMA_CTR1_SDW_LOG2_Pos)        /*!< 0x00000003 */
#define DMA_CTR1_SDW_LOG2_Pos               (0U)
#define DMA_CTR1_SINC                       DMA_CTR1_SINC_Msk                       /*!< Source incrementing burst */
#define DMA_CTR1_SINC_Msk                   (0x1UL << DMA_CTR1_SINC_Pos)            /*!< 0x00000008 */
#define DMA_CTR1_SINC_Pos                   (3U)
#define DMA_CTR2_BREQ                       DMA_CTR2_BREQ_Msk                       /*!< Block hardware request */
#define DMA_CTR2_BREQ_Msk                   (0x1UL << DMA_CTR2_BREQ_Pos)            /*!< 0x00000800 */
#define DMA_CTR2_BREQ_Pos                   (11U)
#define DMA_CTR2_DREQ                       DMA_CTR2_DREQ_Msk                       /*!< Destination hardware request */
#define DMA_CTR2_DREQ_Msk                   (0x1UL << DMA_CTR2_DREQ_Pos)            /*!< 0x00000400 */
#define DMA_CTR2_DREQ_Pos                   (10U)
#define DMA_CTR2_PFREQ                      DMA_CTR2_PFREQ_Msk                      /*!< Hardware request in peripheral flow control mode */
#define DMA_CTR2_PFREQ_Msk                  (0x1UL << DMA_CTR2_PFREQ_Pos)           /*!< 0x00001000 */
#define DMA_CTR2_PFREQ_Pos                  (12U)
#define DMA_CTR2_REQSEL                     DMA_CTR2_REQSEL_Msk                     /*!< DMA hardware request selection */
#define DMA_CTR2_REQSEL_Msk                 (0x7FUL << DMA_CTR2_REQSEL_Pos)         /*!< 0x0000007F */
#define DMA_CTR2_REQSEL_Pos                 (0U)
#define DMA_CTR2_SWREQ                      DMA_CTR2_SWREQ_Msk                      /*!< Software request */
#define DMA_CTR2_SWREQ_Msk                  (0x1UL << DMA_CTR2_SWREQ_Pos)           /*!< 0x00000200 */
#define DMA_CTR2_SWREQ_Pos                  (9U)
#define DMA_CTR2_TCEM                       DMA_CTR2_TCEM_Msk                       /*!< Transfer complete event mode */
#define DMA_CTR2_TCEM_0                     (0x1UL << DMA_CTR2_TCEM_Pos)            /*!< Bit 0 */
#define DMA_CTR2_TCEM_1                     (0x2UL << DMA_CTR2_TCEM_Pos)            /*!< Bit 1 */
#define DMA_CTR2_TCEM_Msk                   (0x3UL << DMA_CTR2_TCEM_Pos)            /*!< 0xC0000000 */
#define DMA_CTR2_TCEM_Pos                   (30U)
#define DMA_CTR2_TRIGM                      DMA_CTR2_TRIGM_Msk                      /*!< Trigger mode */
#define DMA_CTR2_TRIGM_0                    (0x1UL << DMA_CTR2_TRIGM_Pos)           /*!< Bit 0 */
#define DMA_CTR2_TRIGM_1                    (0x2UL << DMA_CTR2_TRIGM_Pos)           /*!< Bit 1 */
#define DMA_CTR2_TRIGM_Msk                  (0x3UL << DMA_CTR2_TRIGM_Pos)           /*!< 0x0000C000 */
#define DMA_CTR2_TRIGM_Pos                  (14U)
#define DMA_CTR2_TRIGPOL                    DMA_CTR2_TRIGPOL_Msk                    /*!< Trigger event polarity */
#define DMA_CTR2_TRIGPOL_0                  (0x1UL << DMA_CTR2_TRIGPOL_Pos)         /*!< Bit 0 */
#define DMA_CTR2_TRIGPOL_1                  (0x2UL << DMA_CTR2_TRIGPOL_Pos)         /*!< Bit 1 */
#define DMA_CTR2_TRIGPOL_Msk                (0x3UL << DMA_CTR2_TRIGPOL_Pos)         /*!< 0x03000000 */
#define DMA_CTR2_TRIGPOL_Pos                (24U)
#define DMA_CTR2_TRIGSEL                    DMA_CTR2_TRIGSEL_Msk                    /*!< Trigger event input selection */
#define DMA_CTR2_TRIGSEL_Msk                (0x3FUL << DMA_CTR2_TRIGSEL_Pos)        /*!< 0x003F0000 */
#define DMA_CTR2_TRIGSEL_Pos                (16U)
#define DMA_CTR3_DAO                        DMA_CTR3_DAO_Msk                        /*!< Destination address offset increment */
#define DMA_CTR3_DAO_Msk                    (0x1FFFUL << DMA_CTR3_DAO_Pos)          /*!< 0x1FFF0000 */
#define DMA_CTR3_DAO_Pos                    (16U)
#define DMA_CTR3_SAO                        DMA_CTR3_SAO_Msk                        /*!< Source address offset increment */
#define DMA_CTR3_SAO_Msk                    (0x1FFFUL << DMA_CTR3_SAO_Pos)          /*!< 0x00001FFF */
#define DMA_CTR3_SAO_Pos                    (0U)
#define DMA_MISR_MIS0                       DMA_MISR_MIS0_Msk                       /*!< Masked Interrupt State of Channel 0 */
#define DMA_MISR_MIS0_Msk                   (0x1UL << DMA_MISR_MIS0_Pos)            /*!< 0x00000001 */
#define DMA_MISR_MIS0_Pos                   (0U)
#define DMA_PRIVCFGR_PRIV0                  DMA_PRIVCFGR_PRIV0_Msk                  /*!< Privileged State of Channel 0 */
#define DMA_PRIVCFGR_PRIV0_Msk              (0x1UL << DMA_PRIVCFGR_PRIV0_Pos)       /*!< 0x00000001 */
#define DMA_PRIVCFGR_PRIV0_Pos              (0U)
#define DMA_RCFGLOCKR_LOCK0                  DMA_RCFGLOCKR_LOCK0_Msk                  /*!< Lock the configuration of Channel 0  */
#define DMA_RCFGLOCKR_LOCK0_Msk              (0x1UL << DMA_RCFGLOCKR_LOCK0_Pos)       /*!< 0x00000001 */
#define DMA_RCFGLOCKR_LOCK0_Pos              (0U)
#define GPDMA1_BASE                     (AHB1PERIPH_BASE + 0x1000UL)
#define GPDMA1_Channel0_BASE            (GPDMA1_BASE + 0x0050UL)
#define GPDMA1_Channel10_BASE           (GPDMA1_BASE + 0x0550UL)
#define GPDMA1_Channel11_BASE           (GPDMA1_BASE + 0x05D0UL)
#define GPDMA1_Channel12_BASE           (GPDMA1_BASE + 0x0650UL)
#define GPDMA1_Channel13_BASE           (GPDMA1_BASE + 0x06D0UL)
#define GPDMA1_Channel14_BASE           (GPDMA1_BASE + 0x0750UL)
#define GPDMA1_Channel15_BASE           (GPDMA1_BASE + 0x07D0UL)
#define GPDMA1_Channel1_BASE            (GPDMA1_BASE + 0x00D0UL)
#define GPDMA1_Channel2_BASE            (GPDMA1_BASE + 0x0150UL)
#define GPDMA1_Channel3_BASE            (GPDMA1_BASE + 0x01D0UL)
#define GPDMA1_Channel4_BASE            (GPDMA1_BASE + 0x0250UL)
#define GPDMA1_Channel5_BASE            (GPDMA1_BASE + 0x02D0UL)
#define GPDMA1_Channel6_BASE            (GPDMA1_BASE + 0x0350UL)
#define GPDMA1_Channel7_BASE            (GPDMA1_BASE + 0x03D0UL)
#define GPDMA1_Channel8_BASE            (GPDMA1_BASE + 0x0450UL)
#define GPDMA1_Channel9_BASE            (GPDMA1_BASE + 0x04D0UL)
#define HPDMA1_BASE                     AHB5PERIPH_BASE
#define HPDMA1_Channel0_BASE            (HPDMA1_BASE + 0x0050UL)
#define HPDMA1_Channel10_BASE           (HPDMA1_BASE + 0x0550UL)
#define HPDMA1_Channel11_BASE           (HPDMA1_BASE + 0x05D0UL)
#define HPDMA1_Channel12_BASE           (HPDMA1_BASE + 0x0650UL)
#define HPDMA1_Channel13_BASE           (HPDMA1_BASE + 0x06D0UL)
#define HPDMA1_Channel14_BASE           (HPDMA1_BASE + 0x0750UL)
#define HPDMA1_Channel15_BASE           (HPDMA1_BASE + 0x07D0UL)
#define HPDMA1_Channel1_BASE            (HPDMA1_BASE + 0x00D0UL)
#define HPDMA1_Channel2_BASE            (HPDMA1_BASE + 0x0150UL)
#define HPDMA1_Channel3_BASE            (HPDMA1_BASE + 0x01D0UL)
#define HPDMA1_Channel4_BASE            (HPDMA1_BASE + 0x0250UL)
#define HPDMA1_Channel5_BASE            (HPDMA1_BASE + 0x02D0UL)
#define HPDMA1_Channel6_BASE            (HPDMA1_BASE + 0x0350UL)
#define HPDMA1_Channel7_BASE            (HPDMA1_BASE + 0x03D0UL)
#define HPDMA1_Channel8_BASE            (HPDMA1_BASE + 0x0450UL)
#define HPDMA1_Channel9_BASE            (HPDMA1_BASE + 0x04D0UL)
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
