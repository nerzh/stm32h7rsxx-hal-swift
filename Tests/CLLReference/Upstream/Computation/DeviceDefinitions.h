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
  __IO uint32_t DR;            /*!< CRC Data register,                              Address offset: 0x00 */
  __IO uint32_t IDR;           /*!< CRC Independent data register,                  Address offset: 0x04 */
  __IO uint32_t CR;            /*!< CRC Control register,                           Address offset: 0x08 */
       uint32_t RESERVED1;     /*!< Reserved,                                                       0x0C */
  __IO uint32_t INIT;          /*!< Initial CRC value register,                     Address offset: 0x10 */
  __IO uint32_t POL;           /*!< CRC polynomial register,                        Address offset: 0x14 */
} CRC_TypeDef;
typedef struct
{
  __IO uint32_t CSR;           /*!< CORDIC Control and Status register,             Address offset: 0x00 */
  __IO uint32_t WDATA;         /*!< CORDIC argument register,                       Address offset: 0x04 */
  __IO uint32_t RDATA;         /*!< CORDIC result register,                         Address offset: 0x08 */
} CORDIC_TypeDef;
typedef struct
{
  __IO uint32_t CR;      /*!< RNG control register, Address offset: 0x00 */
  __IO uint32_t SR;      /*!< RNG status register,  Address offset: 0x04 */
  __IO uint32_t DR;      /*!< RNG data register,    Address offset: 0x08 */
  uint32_t RESERVED;
  __IO uint32_t HTCR;    /*!< RNG health test configuration register, Address offset: 0x10 */
} RNG_TypeDef;
typedef struct
{
  __IO uint32_t CR;          /*!< PKA control register,                 Address offset: 0x00 */
  __IO uint32_t SR;          /*!< PKA status register,                  Address offset: 0x04 */
  __IO uint32_t CLRFR;       /*!< PKA clear flag register,              Address offset: 0x08 */
  uint32_t Reserved1[253];   /*!< Reserved,                             Address offset: 0x000C-0x03FC */
  __IO uint32_t RAM[1334];   /*!< PKA RAM                               Address offset: 0x0400-0x18D8 */
} PKA_TypeDef;
typedef struct
{
  __IO uint32_t CR;             /*!< ICACHE control register,                Address offset: 0x00 */
  __IO uint32_t SR;             /*!< ICACHE status register,                 Address offset: 0x04 */
  __IO uint32_t IER;            /*!< ICACHE interrupt enable register,       Address offset: 0x08 */
  __IO uint32_t FCR;            /*!< ICACHE flag clear register,             Address offset: 0x0C */
  __IO uint32_t HMONR;          /*!< ICACHE hit monitor register,            Address offset: 0x10 */
  __IO uint32_t MMONR;          /*!< ICACHE miss monitor register,           Address offset: 0x14 */
} ICACHE_TypeDef;
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
#define AHB2PERIPH_BASE                 (PERIPH_BASE + 0x08000000UL)
#define AHB3PERIPH_BASE                 (PERIPH_BASE + 0x08020000UL)
#define AHB4PERIPH_BASE                 (PERIPH_BASE + 0x18020000UL)
#define CORDIC_BASE                     (AHB2PERIPH_BASE + 0x4400UL)
#define CORDIC_CSR_ARGSIZE                  CORDIC_CSR_ARGSIZE_Msk                  /*!< Width of input data */
#define CORDIC_CSR_ARGSIZE_Msk              (0x1UL << CORDIC_CSR_ARGSIZE_Pos)       /*!< 0x00400000 */
#define CORDIC_CSR_ARGSIZE_Pos              (22U)
#define CORDIC_CSR_DMAREN                   CORDIC_CSR_DMAREN_Msk                   /*!< DMA Read channel Enable */
#define CORDIC_CSR_DMAREN_Msk               (0x1UL << CORDIC_CSR_DMAREN_Pos)        /*!< 0x00020000 */
#define CORDIC_CSR_DMAREN_Pos               (17U)
#define CORDIC_CSR_DMAWEN                   CORDIC_CSR_DMAWEN_Msk                   /*!< DMA Write channel Enable */
#define CORDIC_CSR_DMAWEN_Msk               (0x1UL << CORDIC_CSR_DMAWEN_Pos)        /*!< 0x00040000 */
#define CORDIC_CSR_DMAWEN_Pos               (18U)
#define CORDIC_CSR_FUNC                     CORDIC_CSR_FUNC_Msk                     /*!< Function */
#define CORDIC_CSR_FUNC_0                   (0x1UL << CORDIC_CSR_FUNC_Pos)          /*!< 0x00000001 */
#define CORDIC_CSR_FUNC_1                   (0x2UL << CORDIC_CSR_FUNC_Pos)          /*!< 0x00000002 */
#define CORDIC_CSR_FUNC_2                   (0x4UL << CORDIC_CSR_FUNC_Pos)          /*!< 0x00000004 */
#define CORDIC_CSR_FUNC_3                   (0x8UL << CORDIC_CSR_FUNC_Pos)          /*!< 0x00000008 */
#define CORDIC_CSR_FUNC_Msk                 (0xFUL << CORDIC_CSR_FUNC_Pos)          /*!< 0x0000000F */
#define CORDIC_CSR_FUNC_Pos                 (0U)
#define CORDIC_CSR_IEN                      CORDIC_CSR_IEN_Msk                      /*!< Interrupt Enable */
#define CORDIC_CSR_IEN_Msk                  (0x1UL << CORDIC_CSR_IEN_Pos)           /*!< 0x00010000 */
#define CORDIC_CSR_IEN_Pos                  (16U)
#define CORDIC_CSR_NARGS                    CORDIC_CSR_NARGS_Msk                    /*!< Number of arguments in RDATA register */
#define CORDIC_CSR_NARGS_Msk                (0x1UL << CORDIC_CSR_NARGS_Pos)         /*!< 0x00100000 */
#define CORDIC_CSR_NARGS_Pos                (20U)
#define CORDIC_CSR_NRES                     CORDIC_CSR_NRES_Msk                     /*!< Number of results in WDATA register */
#define CORDIC_CSR_NRES_Msk                 (0x1UL << CORDIC_CSR_NRES_Pos)          /*!< 0x00080000 */
#define CORDIC_CSR_NRES_Pos                 (19U)
#define CORDIC_CSR_PRECISION                CORDIC_CSR_PRECISION_Msk                /*!< Precision */
#define CORDIC_CSR_PRECISION_0              (0x1UL << CORDIC_CSR_PRECISION_Pos)     /*!< 0x00000010 */
#define CORDIC_CSR_PRECISION_1              (0x2UL << CORDIC_CSR_PRECISION_Pos)     /*!< 0x00000020 */
#define CORDIC_CSR_PRECISION_2              (0x4UL << CORDIC_CSR_PRECISION_Pos)     /*!< 0x00000040 */
#define CORDIC_CSR_PRECISION_3              (0x8UL << CORDIC_CSR_PRECISION_Pos)     /*!< 0x00000080 */
#define CORDIC_CSR_PRECISION_Msk            (0xFUL << CORDIC_CSR_PRECISION_Pos)     /*!< 0x000000F0 */
#define CORDIC_CSR_PRECISION_Pos            (4U)
#define CORDIC_CSR_RESSIZE                  CORDIC_CSR_RESSIZE_Msk                  /*!< Width of output data */
#define CORDIC_CSR_RESSIZE_Msk              (0x1UL << CORDIC_CSR_RESSIZE_Pos)       /*!< 0x00200000 */
#define CORDIC_CSR_RESSIZE_Pos              (21U)
#define CORDIC_CSR_RRDY                     CORDIC_CSR_RRDY_Msk                     /*!< Result Ready Flag */
#define CORDIC_CSR_RRDY_Msk                 (0x1UL << CORDIC_CSR_RRDY_Pos)          /*!< 0x80000000 */
#define CORDIC_CSR_RRDY_Pos                 (31U)
#define CORDIC_CSR_SCALE                    CORDIC_CSR_SCALE_Msk                    /*!< Scaling factor */
#define CORDIC_CSR_SCALE_0                  (0x1UL << CORDIC_CSR_SCALE_Pos)         /*!< 0x00000100 */
#define CORDIC_CSR_SCALE_1                  (0x2UL << CORDIC_CSR_SCALE_Pos)         /*!< 0x00000200 */
#define CORDIC_CSR_SCALE_2                  (0x4UL << CORDIC_CSR_SCALE_Pos)         /*!< 0x00000400 */
#define CORDIC_CSR_SCALE_Msk                (0x7UL << CORDIC_CSR_SCALE_Pos)         /*!< 0x00000700 */
#define CORDIC_CSR_SCALE_Pos                (8U)
#define CRC_BASE                        (AHB4PERIPH_BASE + 0x4C00UL)
#define CRC_CR_POLYSIZE            CRC_CR_POLYSIZE_Msk                         /*!< Polynomial size bits */
#define CRC_CR_POLYSIZE_0          (0x1UL << CRC_CR_POLYSIZE_Pos)              /*!< 0x00000008 */
#define CRC_CR_POLYSIZE_1          (0x2UL << CRC_CR_POLYSIZE_Pos)              /*!< 0x00000010 */
#define CRC_CR_POLYSIZE_Msk        (0x3UL << CRC_CR_POLYSIZE_Pos)              /*!< 0x00000018 */
#define CRC_CR_POLYSIZE_Pos        (3U)
#define CRC_CR_RESET               CRC_CR_RESET_Msk                            /*!< RESET the CRC computation unit bit */
#define CRC_CR_RESET_Msk           (0x1UL << CRC_CR_RESET_Pos)                 /*!< 0x00000001 */
#define CRC_CR_RESET_Pos           (0U)
#define CRC_CR_REV_IN              CRC_CR_REV_IN_Msk                           /*!< REV_IN Reverse Input Data bits */
#define CRC_CR_REV_IN_0            (0x1UL << CRC_CR_REV_IN_Pos)                /*!< 0x00000020 */
#define CRC_CR_REV_IN_1            (0x2UL << CRC_CR_REV_IN_Pos)                /*!< 0x00000040 */
#define CRC_CR_REV_IN_Msk          (0x3UL << CRC_CR_REV_IN_Pos)                /*!< 0x00000060 */
#define CRC_CR_REV_IN_Pos          (5U)
#define CRC_CR_REV_OUT             CRC_CR_REV_OUT_Msk                          /*!< REV_OUT Reverse Output Data bits */
#define CRC_CR_REV_OUT_Msk         (0x1UL << CRC_CR_REV_OUT_Pos)               /*!< 0x00000080 */
#define CRC_CR_REV_OUT_Pos         (7U)
#define ICACHE_CR_CACHEINV             ICACHE_CR_CACHEINV_Msk                  /*!< Cache invalidation */
#define ICACHE_CR_CACHEINV_Msk         (0x1UL << ICACHE_CR_CACHEINV_Pos)       /*!< 0x00000002 */
#define ICACHE_CR_CACHEINV_Pos         (1U)
#define ICACHE_CR_EN                   ICACHE_CR_EN_Msk                        /*!< Enable */
#define ICACHE_CR_EN_Msk               (0x1UL << ICACHE_CR_EN_Pos)             /*!< 0x00000001 */
#define ICACHE_CR_EN_Pos               (0U)
#define ICACHE_CR_HITMEN               ICACHE_CR_HITMEN_Msk                    /*!< Hit monitor enable */
#define ICACHE_CR_HITMEN_Msk           (0x1UL << ICACHE_CR_HITMEN_Pos)         /*!< 0x00010000 */
#define ICACHE_CR_HITMEN_Pos           (16U)
#define ICACHE_CR_MISSMEN              ICACHE_CR_MISSMEN_Msk                   /*!< Miss monitor enable */
#define ICACHE_CR_MISSMEN_Msk          (0x1UL << ICACHE_CR_MISSMEN_Pos)        /*!< 0x00020000 */
#define ICACHE_CR_MISSMEN_Pos          (17U)
#define ICACHE_CR_WAYSEL               ICACHE_CR_WAYSEL_Msk                    /*!< Ways selection */
#define ICACHE_CR_WAYSEL_Msk           (0x1UL << ICACHE_CR_WAYSEL_Pos)         /*!< 0x00000004 */
#define ICACHE_CR_WAYSEL_Pos           (2U)
#define ICACHE_FCR_CBSYENDF            ICACHE_FCR_CBSYENDF_Msk                 /*!< Busy end flag clear */
#define ICACHE_FCR_CBSYENDF_Msk        (0x1UL << ICACHE_FCR_CBSYENDF_Pos)      /*!< 0x00000002 */
#define ICACHE_FCR_CBSYENDF_Pos        (1U)
#define ICACHE_FCR_CERRF               ICACHE_FCR_CERRF_Msk                    /*!< Cache error flag clear */
#define ICACHE_FCR_CERRF_Msk           (0x1UL << ICACHE_FCR_CERRF_Pos)         /*!< 0x00000004 */
#define ICACHE_FCR_CERRF_Pos           (2U)
#define ICACHE_IER_BSYENDIE            ICACHE_IER_BSYENDIE_Msk                 /*!< Busy end interrupt enable */
#define ICACHE_IER_BSYENDIE_Msk        (0x1UL << ICACHE_IER_BSYENDIE_Pos)      /*!< 0x00000002 */
#define ICACHE_IER_BSYENDIE_Pos        (1U)
#define ICACHE_IER_ERRIE               ICACHE_IER_ERRIE_Msk                    /*!< Cache error interrupt enable */
#define ICACHE_IER_ERRIE_Msk           (0x1UL << ICACHE_IER_ERRIE_Pos)         /*!< 0x00000004 */
#define ICACHE_IER_ERRIE_Pos           (2U)
#define ICACHE_SR_BSYENDF              ICACHE_SR_BSYENDF_Msk                   /*!< Busy end flag */
#define ICACHE_SR_BSYENDF_Msk          (0x1UL << ICACHE_SR_BSYENDF_Pos)        /*!< 0x00000002 */
#define ICACHE_SR_BSYENDF_Pos          (1U)
#define ICACHE_SR_BUSYF                ICACHE_SR_BUSYF_Msk                     /*!< Busy flag */
#define ICACHE_SR_BUSYF_Msk            (0x1UL << ICACHE_SR_BUSYF_Pos)          /*!< 0x00000001 */
#define ICACHE_SR_BUSYF_Pos            (0U)
#define ICACHE_SR_ERRF                 ICACHE_SR_ERRF_Msk                      /*!< Cache error flag */
#define ICACHE_SR_ERRF_Msk             (0x1UL << ICACHE_SR_ERRF_Pos)           /*!< 0x00000004 */
#define ICACHE_SR_ERRF_Pos             (2U)
#define IS_CORDIC_ALL_INSTANCE(INSTANCE) ((INSTANCE) == CORDIC)
#define IS_CRC_ALL_INSTANCE(INSTANCE) ((INSTANCE) == CRC)
#define IS_PKA_ALL_INSTANCE(INSTANCE)  ((INSTANCE) == PKA)
#define IS_RNG_ALL_INSTANCE(INSTANCE)  ((INSTANCE) == RNG)
#define PERIPH_BASE                     0x40000000UL  /*!< AHB and APB Peripherals base address */
#define PKA_BASE                        (AHB3PERIPH_BASE + 0x2000UL)
#define PKA_CLRFR_ADDRERRFC                 PKA_CLRFR_ADDRERRFC_Msk                 /*!< Clear address error flag */
#define PKA_CLRFR_ADDRERRFC_Msk             (0x1UL << PKA_CLRFR_ADDRERRFC_Pos)      /*!< 0x00100000 */
#define PKA_CLRFR_ADDRERRFC_Pos             (20U)
#define PKA_CLRFR_OPERRFC                   PKA_CLRFR_OPERRFC_Msk                   /*!< Clear PKA operation Error flag*/
#define PKA_CLRFR_OPERRFC_Msk               (0x1UL << PKA_CLRFR_OPERRFC_Pos)        /*!< 0x00200000 */
#define PKA_CLRFR_OPERRFC_Pos               (21U)
#define PKA_CLRFR_PROCENDFC                 PKA_CLRFR_PROCENDFC_Msk                 /*!< Clear PKA end of operation flag */
#define PKA_CLRFR_PROCENDFC_Msk             (0x1UL << PKA_CLRFR_PROCENDFC_Pos)      /*!< 0x00020000 */
#define PKA_CLRFR_PROCENDFC_Pos             (17U)
#define PKA_CLRFR_RAMERRFC                  PKA_CLRFR_RAMERRFC_Msk                  /*!< Clear PKA RAM error flag */
#define PKA_CLRFR_RAMERRFC_Msk              (0x1UL << PKA_CLRFR_RAMERRFC_Pos)       /*!< 0x00080000 */
#define PKA_CLRFR_RAMERRFC_Pos              (19U)
#define PKA_CR_ADDRERRIE                    PKA_CR_ADDRERRIE_Msk                    /*!< Address error interrupt enable */
#define PKA_CR_ADDRERRIE_Msk                (0x1UL << PKA_CR_ADDRERRIE_Pos)         /*!< 0x00100000 */
#define PKA_CR_ADDRERRIE_Pos                (20U)
#define PKA_CR_EN                           PKA_CR_EN_Msk                           /*!< PKA enable */
#define PKA_CR_EN_Msk                       (0x1UL << PKA_CR_EN_Pos)                /*!< 0x00000001 */
#define PKA_CR_EN_Pos                       (0U)
#define PKA_CR_MODE                         PKA_CR_MODE_Msk                         /*!< MODE[5:0] PKA operation code */
#define PKA_CR_MODE_Msk                     (0x3FUL << PKA_CR_MODE_Pos)             /*!< 0x00003F00 */
#define PKA_CR_MODE_Pos                     (8U)
#define PKA_CR_OPERRIE                      PKA_CR_OPERRIE_Msk                      /*!< Operation Error interrupt enable */
#define PKA_CR_OPERRIE_Msk                  (0x1UL << PKA_CR_OPERRIE_Pos)           /*!< 0x00200000 */
#define PKA_CR_OPERRIE_Pos                  (21U)
#define PKA_CR_PROCENDIE                    PKA_CR_PROCENDIE_Msk                    /*!< End of operation interrupt enable */
#define PKA_CR_PROCENDIE_Msk                (0x1UL << PKA_CR_PROCENDIE_Pos)         /*!< 0x00020000 */
#define PKA_CR_PROCENDIE_Pos                (17U)
#define PKA_CR_RAMERRIE                     PKA_CR_RAMERRIE_Msk                     /*!< RAM error interrupt enable */
#define PKA_CR_RAMERRIE_Msk                 (0x1UL << PKA_CR_RAMERRIE_Pos)          /*!< 0x00080000 */
#define PKA_CR_RAMERRIE_Pos                 (19U)
#define PKA_CR_START                        PKA_CR_START_Msk                        /*!< Start operation */
#define PKA_CR_START_Msk                    (0x1UL << PKA_CR_START_Pos)             /*!< 0x00000002 */
#define PKA_CR_START_Pos                    (1U)
#define PKA_SR_ADDRERRF                     PKA_SR_ADDRERRF_Msk                     /*!< Address error flag */
#define PKA_SR_ADDRERRF_Msk                 (0x1UL << PKA_SR_ADDRERRF_Pos)          /*!< 0x00100000 */
#define PKA_SR_ADDRERRF_Pos                 (20U)
#define PKA_SR_BUSY                         PKA_SR_BUSY_Msk                         /*!< PKA operation is in progress */
#define PKA_SR_BUSY_Msk                     (0x1UL << PKA_SR_BUSY_Pos)              /*!< 0x00010000 */
#define PKA_SR_BUSY_Pos                     (16U)
#define PKA_SR_INITOK                       PKA_SR_INITOK_Msk                       /*!< PKA initialisation flag */
#define PKA_SR_INITOK_Msk                   (0x1UL << PKA_SR_INITOK_Pos)            /*!< 0x00000001 */
#define PKA_SR_INITOK_Pos                   (0U)
#define PKA_SR_OPERRF                       PKA_SR_OPERRF_Msk                       /*!< PKA operation Error flag*/
#define PKA_SR_OPERRF_Msk                   (0x1UL << PKA_SR_OPERRF_Pos)            /*!< 0x00200000 */
#define PKA_SR_OPERRF_Pos                   (21U)
#define PKA_SR_PROCENDF                     PKA_SR_PROCENDF_Msk                     /*!< PKA end of operation flag */
#define PKA_SR_PROCENDF_Msk                 (0x1UL << PKA_SR_PROCENDF_Pos)          /*!< 0x00020000 */
#define PKA_SR_PROCENDF_Pos                 (17U)
#define PKA_SR_RAMERRF                      PKA_SR_RAMERRF_Msk                      /*!< PKA RAM error flag */
#define PKA_SR_RAMERRF_Msk                  (0x1UL << PKA_SR_RAMERRF_Pos)           /*!< 0x00080000 */
#define PKA_SR_RAMERRF_Pos                  (19U)
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
#define RNG_BASE                        AHB3PERIPH_BASE
#define RNG_CR_ARDIS                   RNG_CR_ARDIS_Msk
#define RNG_CR_ARDIS_Msk               (0x1UL << RNG_CR_ARDIS_Pos)
#define RNG_CR_ARDIS_Pos               (7U)
#define RNG_CR_CED                     RNG_CR_CED_Msk
#define RNG_CR_CED_Msk                 (0x1UL << RNG_CR_CED_Pos)               /*!< 0x00000020 */
#define RNG_CR_CED_Pos                 (5U)
#define RNG_CR_CLKDIV                  RNG_CR_CLKDIV_Msk
#define RNG_CR_CLKDIV_0                (0x1UL << RNG_CR_CLKDIV_Pos)            /*!< 0x00010000 */
#define RNG_CR_CLKDIV_1                (0x2UL << RNG_CR_CLKDIV_Pos)            /*!< 0x00020000 */
#define RNG_CR_CLKDIV_2                (0x4UL << RNG_CR_CLKDIV_Pos)            /*!< 0x00040000 */
#define RNG_CR_CLKDIV_3                (0x8UL << RNG_CR_CLKDIV_Pos)            /*!< 0x00080000 */
#define RNG_CR_CLKDIV_Msk              (0xFUL << RNG_CR_CLKDIV_Pos)
#define RNG_CR_CLKDIV_Pos              (16U)
#define RNG_CR_CONDRST                 RNG_CR_CONDRST_Msk
#define RNG_CR_CONDRST_Msk             (0x1UL << RNG_CR_CONDRST_Pos)
#define RNG_CR_CONDRST_Pos             (30U)
#define RNG_CR_CONFIGLOCK              RNG_CR_CONFIGLOCK_Msk
#define RNG_CR_CONFIGLOCK_Msk          (0x1UL << RNG_CR_CONFIGLOCK_Pos)
#define RNG_CR_CONFIGLOCK_Pos          (31U)
#define RNG_CR_IE                      RNG_CR_IE_Msk
#define RNG_CR_IE_Msk                  (0x1UL << RNG_CR_IE_Pos)                /*!< 0x00000008 */
#define RNG_CR_IE_Pos                  (3U)
#define RNG_CR_NISTC                   RNG_CR_NISTC_Msk
#define RNG_CR_NISTC_Msk               (0x1UL << RNG_CR_NISTC_Pos)
#define RNG_CR_NISTC_Pos               (12U)
#define RNG_CR_RNGEN                   RNG_CR_RNGEN_Msk
#define RNG_CR_RNGEN_Msk               (0x1UL << RNG_CR_RNGEN_Pos)             /*!< 0x00000004 */
#define RNG_CR_RNGEN_Pos               (2U)
#define RNG_CR_RNG_CONFIG1             RNG_CR_RNG_CONFIG1_Msk
#define RNG_CR_RNG_CONFIG1_Msk         (0x3FUL << RNG_CR_RNG_CONFIG1_Pos)
#define RNG_CR_RNG_CONFIG1_Pos         (20U)
#define RNG_CR_RNG_CONFIG2             RNG_CR_RNG_CONFIG2_Msk
#define RNG_CR_RNG_CONFIG2_Msk         (0x7UL << RNG_CR_RNG_CONFIG2_Pos)
#define RNG_CR_RNG_CONFIG2_Pos         (13U)
#define RNG_CR_RNG_CONFIG3             RNG_CR_RNG_CONFIG3_Msk
#define RNG_CR_RNG_CONFIG3_Msk         (0xFUL << RNG_CR_RNG_CONFIG3_Pos)
#define RNG_CR_RNG_CONFIG3_Pos         (8U)
#define RNG_SR_CECS                    RNG_SR_CECS_Msk
#define RNG_SR_CECS_Msk                (0x1UL << RNG_SR_CECS_Pos)              /*!< 0x00000002 */
#define RNG_SR_CECS_Pos                (1U)
#define RNG_SR_CEIS                    RNG_SR_CEIS_Msk
#define RNG_SR_CEIS_Msk                (0x1UL << RNG_SR_CEIS_Pos)              /*!< 0x00000020 */
#define RNG_SR_CEIS_Pos                (5U)
#define RNG_SR_DRDY                    RNG_SR_DRDY_Msk
#define RNG_SR_DRDY_Msk                (0x1UL << RNG_SR_DRDY_Pos)              /*!< 0x00000001 */
#define RNG_SR_DRDY_Pos                (0U)
#define RNG_SR_SECS                    RNG_SR_SECS_Msk
#define RNG_SR_SECS_Msk                (0x1UL << RNG_SR_SECS_Pos)              /*!< 0x00000004 */
#define RNG_SR_SECS_Pos                (2U)
#define RNG_SR_SEIS                    RNG_SR_SEIS_Msk
#define RNG_SR_SEIS_Msk                (0x1UL << RNG_SR_SEIS_Pos)              /*!< 0x00000040 */
#define RNG_SR_SEIS_Pos                (6U)
