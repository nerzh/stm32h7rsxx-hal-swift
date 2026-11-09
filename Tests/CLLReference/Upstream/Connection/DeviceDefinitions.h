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
  __IO uint32_t CFG1;        /*!< UCPD configuration register 1,            Address offset: 0x00 */
  __IO uint32_t CFG2;        /*!< UCPD configuration register 2,            Address offset: 0x04 */
  __IO uint32_t CFG3;        /*!< UCPD configuration register 3,            Address offset: 0x08 */
  __IO uint32_t CR;          /*!< UCPD control register,                    Address offset: 0x0C */
  __IO uint32_t IMR;         /*!< UCPD interrupt mask register,             Address offset: 0x10 */
  __IO uint32_t SR;          /*!< UCPD status register,                     Address offset: 0x14 */
  __IO uint32_t ICR;         /*!< UCPD interrupt flag clear register        Address offset: 0x18 */
  __IO uint32_t TX_ORDSET;   /*!< UCPD Tx ordered set type register,        Address offset: 0x1C */
  __IO uint32_t TX_PAYSZ;    /*!< UCPD Tx payload size register,            Address offset: 0x20 */
  __IO uint32_t TXDR;        /*!< UCPD Tx data register,                    Address offset: 0x24 */
  __IO uint32_t RX_ORDSET;   /*!< UCPD Rx ordered set type register,        Address offset: 0x28 */
  __IO uint32_t RX_PAYSZ;    /*!< UCPD Rx payload size register,            Address offset: 0x2C */
  __IO uint32_t RXDR;        /*!< UCPD Rx data register,                    Address offset: 0x30 */
  __IO uint32_t RX_ORDEXT1;  /*!< UCPD Rx ordered set extension 1 register, Address offset: 0x34 */
  __IO uint32_t RX_ORDEXT2;  /*!< UCPD Rx ordered set extension 2 register, Address offset: 0x38 */
} UCPD_TypeDef;
typedef struct
{
  __IO uint32_t CR;   /*!< Delay Block Control Register,       Address offset: 0x00 */
  __IO uint32_t CFGR; /*!< Delay Block Configuration Register, Address offset: 0x04 */
} DLYB_TypeDef;
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
#define AHB5PERIPH_BASE                 (PERIPH_BASE + 0x12000000UL)
#define APB1PERIPH_BASE                 PERIPH_BASE
#define DLYB_CFGR_LNG                       DLYB_CFGR_LNG_Msk                       /*!<Delay line length value[11:0] */
#define DLYB_CFGR_LNGF                      DLYB_CFGR_LNGF_Msk                       /*!<Length valid flag */
#define DLYB_CFGR_LNGF_Msk                  (0x1UL << DLYB_CFGR_LNGF_Pos)            /*!< 0x80000000 */
#define DLYB_CFGR_LNGF_Pos                  (31U)
#define DLYB_CFGR_LNG_10                    (0x400UL << DLYB_CFGR_LNG_Pos)          /*!< 0x04000000 */
#define DLYB_CFGR_LNG_11                    (0x800UL << DLYB_CFGR_LNG_Pos)          /*!< 0x08000000 */
#define DLYB_CFGR_LNG_Msk                   (0xFFFUL << DLYB_CFGR_LNG_Pos)          /*!< 0x0FFF0000 */
#define DLYB_CFGR_LNG_Pos                   (16U)
#define DLYB_CFGR_SEL                       DLYB_CFGR_SEL_Msk                       /*!<Select the phase for the Output clock[3:0] */
#define DLYB_CFGR_SEL_Msk                   (0xFUL << DLYB_CFGR_SEL_Pos)            /*!< 0x0000000F */
#define DLYB_CFGR_SEL_Pos                   (0U)
#define DLYB_CFGR_UNIT                      DLYB_CFGR_UNIT_Msk                      /*!<Delay Defines the delay of a Unit delay cell[6:0] */
#define DLYB_CFGR_UNIT_Msk                  (0x7FUL << DLYB_CFGR_UNIT_Pos)          /*!< 0x00007F00 */
#define DLYB_CFGR_UNIT_Pos                  (8U)
#define DLYB_CR_DEN                         DLYB_CR_DEN_Msk                         /*!<Delay Block enable */
#define DLYB_CR_DEN_Msk                     (0x1UL << DLYB_CR_DEN_Pos)              /*!< 0x00000001 */
#define DLYB_CR_DEN_Pos                     (0U)
#define DLYB_CR_SEN                         DLYB_CR_SEN_Msk                         /*!<Sampler length enable */
#define DLYB_CR_SEN_Msk                     (0x1UL << DLYB_CR_SEN_Pos)              /*!< 0x00000002 */
#define DLYB_CR_SEN_Pos                     (1U)
#define DLYB_SDMMC1_BASE                (AHB5PERIPH_BASE + 0x8000UL)
#define DLYB_SDMMC2_BASE                (AHB2PERIPH_BASE + 0x2800UL)
#define IS_DLYB_ALL_INSTANCE(INSTANCE) (((INSTANCE) == DLYB_SDMMC1)   ||                                          ((INSTANCE) == DLYB_SDMMC2))
#define IS_UCPD_ALL_INSTANCE(INSTANCE) ((INSTANCE) == UCPD1)
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
#define UCPD1_BASE                      (APB1PERIPH_BASE + 0xEC00UL)
#define UCPD_CFG1_HBITCLKDIV                UCPD_CFG1_HBITCLKDIV_Msk             /*!< Number of cycles (minus 1) for a half bit clock */
#define UCPD_CFG1_HBITCLKDIV_Msk            (0x3FUL << UCPD_CFG1_HBITCLKDIV_Pos) /*!< 0x0000003F */
#define UCPD_CFG1_HBITCLKDIV_Pos            (0U)
#define UCPD_CFG1_IFRGAP                    UCPD_CFG1_IFRGAP_Msk                 /*!< Clock divider value to generates Interframe gap */
#define UCPD_CFG1_IFRGAP_Msk                (0x1FUL << UCPD_CFG1_IFRGAP_Pos)     /*!< 0x000007C0 */
#define UCPD_CFG1_IFRGAP_Pos                (6U)
#define UCPD_CFG1_PSC_UCPDCLK               UCPD_CFG1_PSC_UCPDCLK_Msk            /*!< Prescaler for UCPDCLK */
#define UCPD_CFG1_PSC_UCPDCLK_0             (0x1UL << UCPD_CFG1_PSC_UCPDCLK_Pos) /*!< 0x00020000 */
#define UCPD_CFG1_PSC_UCPDCLK_1             (0x2UL << UCPD_CFG1_PSC_UCPDCLK_Pos) /*!< 0x00040000 */
#define UCPD_CFG1_PSC_UCPDCLK_2             (0x4UL << UCPD_CFG1_PSC_UCPDCLK_Pos) /*!< 0x00080000 */
#define UCPD_CFG1_PSC_UCPDCLK_Msk           (0x7UL << UCPD_CFG1_PSC_UCPDCLK_Pos) /*!< 0x000E0000 */
#define UCPD_CFG1_PSC_UCPDCLK_Pos           (17U)
#define UCPD_CFG1_RXDMAEN                   UCPD_CFG1_RXDMAEN_Msk                /*!< DMA reception requests enable   */
#define UCPD_CFG1_RXDMAEN_Msk               (0x1UL << UCPD_CFG1_RXDMAEN_Pos)     /*!< 0x40000000 */
#define UCPD_CFG1_RXDMAEN_Pos               (30U)
#define UCPD_CFG1_RXORDSETEN                UCPD_CFG1_RXORDSETEN_Msk             /*!< Receiver ordered set detection enable */
#define UCPD_CFG1_RXORDSETEN_0              (0x001UL << UCPD_CFG1_RXORDSETEN_Pos)/*!< 0x00100000 */
#define UCPD_CFG1_RXORDSETEN_1              (0x002UL << UCPD_CFG1_RXORDSETEN_Pos)/*!< 0x00200000 */
#define UCPD_CFG1_RXORDSETEN_2              (0x004UL << UCPD_CFG1_RXORDSETEN_Pos)/*!< 0x00400000 */
#define UCPD_CFG1_RXORDSETEN_3              (0x008UL << UCPD_CFG1_RXORDSETEN_Pos)/*!< 0x00800000 */
#define UCPD_CFG1_RXORDSETEN_4              (0x010UL << UCPD_CFG1_RXORDSETEN_Pos)/*!< 0x01000000 */
#define UCPD_CFG1_RXORDSETEN_5              (0x020UL << UCPD_CFG1_RXORDSETEN_Pos)/*!< 0x02000000 */
#define UCPD_CFG1_RXORDSETEN_6              (0x040UL << UCPD_CFG1_RXORDSETEN_Pos)/*!< 0x04000000 */
#define UCPD_CFG1_RXORDSETEN_7              (0x080UL << UCPD_CFG1_RXORDSETEN_Pos)/*!< 0x08000000 */
#define UCPD_CFG1_RXORDSETEN_8              (0x100UL << UCPD_CFG1_RXORDSETEN_Pos)/*!< 0x10000000 */
#define UCPD_CFG1_RXORDSETEN_Msk            (0x1FFUL << UCPD_CFG1_RXORDSETEN_Pos)/*!< 0x1FF00000 */
#define UCPD_CFG1_RXORDSETEN_Pos            (20U)
#define UCPD_CFG1_TRANSWIN                  UCPD_CFG1_TRANSWIN_Msk               /*!< Number of cycles (minus 1) of the half bit clock */
#define UCPD_CFG1_TRANSWIN_Msk              (0x1FUL << UCPD_CFG1_TRANSWIN_Pos)   /*!< 0x0000F800 */
#define UCPD_CFG1_TRANSWIN_Pos              (11U)
#define UCPD_CFG1_TXDMAEN                   UCPD_CFG1_TXDMAEN_Msk                /*!< DMA transmission requests enable   */
#define UCPD_CFG1_TXDMAEN_Msk               (0x1UL << UCPD_CFG1_TXDMAEN_Pos)     /*!< 0x20000000 */
#define UCPD_CFG1_TXDMAEN_Pos               (29U)
#define UCPD_CFG1_UCPDEN                    UCPD_CFG1_UCPDEN_Msk                 /*!< USB Power Delivery Block Enable */
#define UCPD_CFG1_UCPDEN_Msk                (0x1UL << UCPD_CFG1_UCPDEN_Pos)      /*!< 0x80000000 */
#define UCPD_CFG1_UCPDEN_Pos                (31U)
#define UCPD_CFG2_FORCECLK                  UCPD_CFG2_FORCECLK_Msk               /*!< Controls forcing of the clock request UCPDCLK_REQ */
#define UCPD_CFG2_FORCECLK_Msk              (0x1UL << UCPD_CFG2_FORCECLK_Pos)    /*!< 0x00000004 */
#define UCPD_CFG2_FORCECLK_Pos              (2U)
#define UCPD_CFG2_RXAFILTEN                 UCPD_CFG2_RXAFILTEN_Msk              /*!< Rx analog filter enable */
#define UCPD_CFG2_RXAFILTEN_Msk             (0x1UL << UCPD_CFG2_RXAFILTEN_Pos)   /*!< 0x00000100 */
#define UCPD_CFG2_RXAFILTEN_Pos             (8U)
#define UCPD_CFG2_RXFILTDIS                 UCPD_CFG2_RXFILTDIS_Msk              /*!< Enables an Rx pre-filter for the BMC decoder */
#define UCPD_CFG2_RXFILTDIS_Msk             (0x1UL << UCPD_CFG2_RXFILTDIS_Pos)   /*!< 0x00000001 */
#define UCPD_CFG2_RXFILTDIS_Pos             (0U)
#define UCPD_CFG2_WUPEN                     UCPD_CFG2_WUPEN_Msk                  /*!< Wakeup from STOP enable */
#define UCPD_CFG2_WUPEN_Msk                 (0x1UL << UCPD_CFG2_WUPEN_Pos)       /*!< 0x00000008 */
#define UCPD_CFG2_WUPEN_Pos                 (3U)
#define UCPD_CR_ANAMODE                     UCPD_CR_ANAMODE_Msk                  /*!< Analog PHY working mode   */
#define UCPD_CR_ANAMODE_Msk                 (0x1UL << UCPD_CR_ANAMODE_Pos)       /*!< 0x00000200 */
#define UCPD_CR_ANAMODE_Pos                 (9U)
#define UCPD_CR_ANASUBMODE                  UCPD_CR_ANASUBMODE_Msk               /*!< Analog PHY sub-mode   */
#define UCPD_CR_ANASUBMODE_0                (0x1UL << UCPD_CR_ANASUBMODE_Pos)    /*!< 0x00000080 */
#define UCPD_CR_ANASUBMODE_1                (0x2UL << UCPD_CR_ANASUBMODE_Pos)    /*!< 0x00000100 */
#define UCPD_CR_ANASUBMODE_Msk              (0x3UL << UCPD_CR_ANASUBMODE_Pos)    /*!< 0x00000180 */
#define UCPD_CR_ANASUBMODE_Pos              (7U)
#define UCPD_CR_CC1TCDIS                    UCPD_CR_CC1TCDIS_Msk                 /*!< The bit allows the Type-C detector for CC0 to be disabled. */
#define UCPD_CR_CC1TCDIS_Msk                (0x1UL << UCPD_CR_CC1TCDIS_Pos)      /*!< 0x00100000 */
#define UCPD_CR_CC1TCDIS_Pos                (20U)
#define UCPD_CR_CC2TCDIS                    UCPD_CR_CC2TCDIS_Msk                 /*!< The bit allows the Type-C detector for CC2 to be disabled. */
#define UCPD_CR_CC2TCDIS_Msk                (0x1UL << UCPD_CR_CC2TCDIS_Pos)      /*!< 0x00200000 */
#define UCPD_CR_CC2TCDIS_Pos                (21U)
#define UCPD_CR_CCENABLE                    UCPD_CR_CCENABLE_Msk                 /*!<  */
#define UCPD_CR_CCENABLE_0                  (0x1UL << UCPD_CR_CCENABLE_Pos)      /*!< 0x00000400 */
#define UCPD_CR_CCENABLE_1                  (0x2UL << UCPD_CR_CCENABLE_Pos)      /*!< 0x00000800 */
#define UCPD_CR_CCENABLE_Msk                (0x3UL << UCPD_CR_CCENABLE_Pos)      /*!< 0x00000C00 */
#define UCPD_CR_CCENABLE_Pos                (10U)
#define UCPD_CR_FRSRXEN                     UCPD_CR_FRSRXEN_Msk                  /*!< Enable FRS request detection function */
#define UCPD_CR_FRSRXEN_Msk                 (0x1UL << UCPD_CR_FRSRXEN_Pos)       /*!< 0x00010000 */
#define UCPD_CR_FRSRXEN_Pos                 (16U)
#define UCPD_CR_FRSTX                       UCPD_CR_FRSTX_Msk                    /*!< Signal Fast Role Swap request */
#define UCPD_CR_FRSTX_Msk                   (0x1UL << UCPD_CR_FRSTX_Pos)         /*!< 0x00020000 */
#define UCPD_CR_FRSTX_Pos                   (17U)
#define UCPD_CR_PHYCCSEL                    UCPD_CR_PHYCCSEL_Msk                 /*!<  */
#define UCPD_CR_PHYCCSEL_Msk                (0x1UL << UCPD_CR_PHYCCSEL_Pos)      /*!< 0x00000040 */
#define UCPD_CR_PHYCCSEL_Pos                (6U)
#define UCPD_CR_PHYRXEN                     UCPD_CR_PHYRXEN_Msk                  /*!< Controls enable of USB Power Delivery receiver  */
#define UCPD_CR_PHYRXEN_Msk                 (0x1UL << UCPD_CR_PHYRXEN_Pos)       /*!< 0x00000020 */
#define UCPD_CR_PHYRXEN_Pos                 (5U)
#define UCPD_CR_RDCH                        UCPD_CR_RDCH_Msk                     /*!<  */
#define UCPD_CR_RDCH_Msk                    (0x1UL << UCPD_CR_RDCH_Pos)          /*!< 0x00040000 */
#define UCPD_CR_RDCH_Pos                    (18U)
#define UCPD_CR_RXMODE                      UCPD_CR_RXMODE_Msk                   /*!< Receiver mode  */
#define UCPD_CR_RXMODE_Msk                  (0x1UL << UCPD_CR_RXMODE_Pos)        /*!< 0x00000010 */
#define UCPD_CR_RXMODE_Pos                  (4U)
#define UCPD_CR_TXHRST                      UCPD_CR_TXHRST_Msk                   /*!< Command to send a Tx Hard Reset  */
#define UCPD_CR_TXHRST_Msk                  (0x1UL << UCPD_CR_TXHRST_Pos)        /*!< 0x00000008 */
#define UCPD_CR_TXHRST_Pos                  (3U)
#define UCPD_CR_TXMODE                      UCPD_CR_TXMODE_Msk                   /*!< Type of Tx packet  */
#define UCPD_CR_TXMODE_0                    (0x1UL << UCPD_CR_TXMODE_Pos)        /*!< 0x00000001 */
#define UCPD_CR_TXMODE_1                    (0x2UL << UCPD_CR_TXMODE_Pos)        /*!< 0x00000002 */
#define UCPD_CR_TXMODE_Msk                  (0x3UL << UCPD_CR_TXMODE_Pos)        /*!< 0x00000003 */
#define UCPD_CR_TXMODE_Pos                  (0U)
#define UCPD_CR_TXSEND                      UCPD_CR_TXSEND_Msk                   /*!< Type of Tx packet  */
#define UCPD_CR_TXSEND_Msk                  (0x1UL << UCPD_CR_TXSEND_Pos)        /*!< 0x00000004 */
#define UCPD_CR_TXSEND_Pos                  (2U)
#define UCPD_ICR_FRSEVTCF                   UCPD_ICR_FRSEVTCF_Msk                /*!< Fast Role Swap event flag clear  */
#define UCPD_ICR_FRSEVTCF_Msk               (0x1UL << UCPD_ICR_FRSEVTCF_Pos)     /*!< 0x00100000 */
#define UCPD_ICR_FRSEVTCF_Pos               (20U)
#define UCPD_ICR_HRSTDISCCF                 UCPD_ICR_HRSTDISCCF_Msk              /*!< Hard reset discarded flag (HRSTDISC) clear  */
#define UCPD_ICR_HRSTDISCCF_Msk             (0x1UL << UCPD_ICR_HRSTDISCCF_Pos)   /*!< 0x00000010 */
#define UCPD_ICR_HRSTDISCCF_Pos             (4U)
#define UCPD_ICR_HRSTSENTCF                 UCPD_ICR_HRSTSENTCF_Msk              /*!< Hard reset sent flag (HRSTSENT) clear  */
#define UCPD_ICR_HRSTSENTCF_Msk             (0x1UL << UCPD_ICR_HRSTSENTCF_Pos)   /*!< 0x00000020 */
#define UCPD_ICR_HRSTSENTCF_Pos             (5U)
#define UCPD_ICR_RXHRSTDETCF                UCPD_ICR_RXHRSTDETCF_Msk             /*!< Rx Hard Reset detected flag (RXHRSTDET) clear  */
#define UCPD_ICR_RXHRSTDETCF_Msk            (0x1UL << UCPD_ICR_RXHRSTDETCF_Pos)  /*!< 0x00000400 */
#define UCPD_ICR_RXHRSTDETCF_Pos            (10U)
#define UCPD_ICR_RXMSGENDCF                 UCPD_ICR_RXMSGENDCF_Msk              /*!< Rx message received flag (RXMSGEND) clear  */
#define UCPD_ICR_RXMSGENDCF_Msk             (0x1UL << UCPD_ICR_RXMSGENDCF_Pos)   /*!< 0x00001000 */
#define UCPD_ICR_RXMSGENDCF_Pos             (12U)
#define UCPD_ICR_RXORDDETCF                 UCPD_ICR_RXORDDETCF_Msk              /*!< Rx ordered set detect flag (RXORDDET) clear  */
#define UCPD_ICR_RXORDDETCF_Msk             (0x1UL << UCPD_ICR_RXORDDETCF_Pos)   /*!< 0x00000200 */
#define UCPD_ICR_RXORDDETCF_Pos             (9U)
#define UCPD_ICR_RXOVRCF                    UCPD_ICR_RXOVRCF_Msk                 /*!< Rx overflow flag (RXOVR) clear  */
#define UCPD_ICR_RXOVRCF_Msk                (0x1UL << UCPD_ICR_RXOVRCF_Pos)      /*!< 0x00000800 */
#define UCPD_ICR_RXOVRCF_Pos                (11U)
#define UCPD_ICR_TXMSGABTCF                 UCPD_ICR_TXMSGABTCF_Msk              /*!< Tx message abort flag (TXMSGABT) clear  */
#define UCPD_ICR_TXMSGABTCF_Msk             (0x1UL << UCPD_ICR_TXMSGABTCF_Pos)   /*!< 0x00000008 */
#define UCPD_ICR_TXMSGABTCF_Pos             (3U)
#define UCPD_ICR_TXMSGDISCCF                UCPD_ICR_TXMSGDISCCF_Msk             /*!< Tx message discarded flag (TXMSGDISC) clear  */
#define UCPD_ICR_TXMSGDISCCF_Msk            (0x1UL << UCPD_ICR_TXMSGDISCCF_Pos)  /*!< 0x00000002 */
#define UCPD_ICR_TXMSGDISCCF_Pos            (1U)
#define UCPD_ICR_TXMSGSENTCF                UCPD_ICR_TXMSGSENTCF_Msk             /*!< Tx message sent flag (TXMSGSENT) clear  */
#define UCPD_ICR_TXMSGSENTCF_Msk            (0x1UL << UCPD_ICR_TXMSGSENTCF_Pos)  /*!< 0x00000004 */
#define UCPD_ICR_TXMSGSENTCF_Pos            (2U)
#define UCPD_ICR_TXUNDCF                    UCPD_ICR_TXUNDCF_Msk                 /*!< Tx underflow flag (TXUND) clear  */
#define UCPD_ICR_TXUNDCF_Msk                (0x1UL << UCPD_ICR_TXUNDCF_Pos)      /*!< 0x00000040 */
#define UCPD_ICR_TXUNDCF_Pos                (6U)
#define UCPD_ICR_TYPECEVT1CF                UCPD_ICR_TYPECEVT1CF_Msk             /*!< TypeC event (CC1) flag (TYPECEVT1) clear  */
#define UCPD_ICR_TYPECEVT1CF_Msk            (0x1UL << UCPD_ICR_TYPECEVT1CF_Pos)  /*!< 0x00004000 */
#define UCPD_ICR_TYPECEVT1CF_Pos            (14U)
#define UCPD_ICR_TYPECEVT2CF                UCPD_ICR_TYPECEVT2CF_Msk             /*!< TypeC event (CC2) flag (TYPECEVT2) clear  */
#define UCPD_ICR_TYPECEVT2CF_Msk            (0x1UL << UCPD_ICR_TYPECEVT2CF_Pos)  /*!< 0x00008000 */
#define UCPD_ICR_TYPECEVT2CF_Pos            (15U)
#define UCPD_IMR_FRSEVTIE                   UCPD_IMR_FRSEVTIE_Msk                /*!< Fast Role Swap interrupt  */
#define UCPD_IMR_FRSEVTIE_Msk               (0x1UL << UCPD_IMR_FRSEVTIE_Pos)     /*!< 0x00100000 */
#define UCPD_IMR_FRSEVTIE_Pos               (20U)
#define UCPD_IMR_HRSTDISCIE                 UCPD_IMR_HRSTDISCIE_Msk              /*!< Enable HRSTDISC interrupt  */
#define UCPD_IMR_HRSTDISCIE_Msk             (0x1UL << UCPD_IMR_HRSTDISCIE_Pos)   /*!< 0x00000010 */
#define UCPD_IMR_HRSTDISCIE_Pos             (4U)
#define UCPD_IMR_HRSTSENTIE                 UCPD_IMR_HRSTSENTIE_Msk              /*!< Enable HRSTSENT interrupt  */
#define UCPD_IMR_HRSTSENTIE_Msk             (0x1UL << UCPD_IMR_HRSTSENTIE_Pos)   /*!< 0x00000020 */
#define UCPD_IMR_HRSTSENTIE_Pos             (5U)
#define UCPD_IMR_RXHRSTDETIE                UCPD_IMR_RXHRSTDETIE_Msk             /*!< Enable RXHRSTDET interrupt  */
#define UCPD_IMR_RXHRSTDETIE_Msk            (0x1UL << UCPD_IMR_RXHRSTDETIE_Pos)  /*!< 0x00000400 */
#define UCPD_IMR_RXHRSTDETIE_Pos            (10U)
#define UCPD_IMR_RXMSGENDIE                 UCPD_IMR_RXMSGENDIE_Msk              /*!< Enable RXMSGEND interrupt  */
#define UCPD_IMR_RXMSGENDIE_Msk             (0x1UL << UCPD_IMR_RXMSGENDIE_Pos)   /*!< 0x00001000 */
#define UCPD_IMR_RXMSGENDIE_Pos             (12U)
#define UCPD_IMR_RXNEIE                     UCPD_IMR_RXNEIE_Msk                  /*!< Enable RXNE interrupt  */
#define UCPD_IMR_RXNEIE_Msk                 (0x1UL << UCPD_IMR_RXNEIE_Pos)       /*!< 0x00000100 */
#define UCPD_IMR_RXNEIE_Pos                 (8U)
#define UCPD_IMR_RXORDDETIE                 UCPD_IMR_RXORDDETIE_Msk              /*!< Enable RXORDDET interrupt  */
#define UCPD_IMR_RXORDDETIE_Msk             (0x1UL << UCPD_IMR_RXORDDETIE_Pos)   /*!< 0x00000200 */
#define UCPD_IMR_RXORDDETIE_Pos             (9U)
#define UCPD_IMR_RXOVRIE                    UCPD_IMR_RXOVRIE_Msk                 /*!< Enable RXOVR interrupt  */
#define UCPD_IMR_RXOVRIE_Msk                (0x1UL << UCPD_IMR_RXOVRIE_Pos)      /*!< 0x00000800 */
#define UCPD_IMR_RXOVRIE_Pos                (11U)
#define UCPD_IMR_TXISIE                     UCPD_IMR_TXISIE_Msk                  /*!< Enable TXIS interrupt  */
#define UCPD_IMR_TXISIE_Msk                 (0x1UL << UCPD_IMR_TXISIE_Pos)       /*!< 0x00000001 */
#define UCPD_IMR_TXISIE_Pos                 (0U)
#define UCPD_IMR_TXMSGABTIE                 UCPD_IMR_TXMSGABTIE_Msk              /*!< Enable TXMSGABT interrupt  */
#define UCPD_IMR_TXMSGABTIE_Msk             (0x1UL << UCPD_IMR_TXMSGABTIE_Pos)   /*!< 0x00000008 */
#define UCPD_IMR_TXMSGABTIE_Pos             (3U)
#define UCPD_IMR_TXMSGDISCIE                UCPD_IMR_TXMSGDISCIE_Msk             /*!< Enable TXMSGDISC interrupt  */
#define UCPD_IMR_TXMSGDISCIE_Msk            (0x1UL << UCPD_IMR_TXMSGDISCIE_Pos)  /*!< 0x00000002 */
#define UCPD_IMR_TXMSGDISCIE_Pos            (1U)
#define UCPD_IMR_TXMSGSENTIE                UCPD_IMR_TXMSGSENTIE_Msk             /*!< Enable TXMSGSENT interrupt  */
#define UCPD_IMR_TXMSGSENTIE_Msk            (0x1UL << UCPD_IMR_TXMSGSENTIE_Pos)  /*!< 0x00000004 */
#define UCPD_IMR_TXMSGSENTIE_Pos            (2U)
#define UCPD_IMR_TXUNDIE                    UCPD_IMR_TXUNDIE_Msk                 /*!< Enable TXUND interrupt  */
#define UCPD_IMR_TXUNDIE_Msk                (0x1UL << UCPD_IMR_TXUNDIE_Pos)      /*!< 0x00000040 */
#define UCPD_IMR_TXUNDIE_Pos                (6U)
#define UCPD_IMR_TYPECEVT1IE                UCPD_IMR_TYPECEVT1IE_Msk             /*!< Enable TYPECEVT1IE interrupt  */
#define UCPD_IMR_TYPECEVT1IE_Msk            (0x1UL << UCPD_IMR_TYPECEVT1IE_Pos)  /*!< 0x00004000 */
#define UCPD_IMR_TYPECEVT1IE_Pos            (14U)
#define UCPD_IMR_TYPECEVT2IE                UCPD_IMR_TYPECEVT2IE_Msk             /*!< Enable TYPECEVT2IE interrupt  */
#define UCPD_IMR_TYPECEVT2IE_Msk            (0x1UL << UCPD_IMR_TYPECEVT2IE_Pos)  /*!< 0x00008000 */
#define UCPD_IMR_TYPECEVT2IE_Pos            (15U)
#define UCPD_RX_ORDSET_RXORDSET             UCPD_RX_ORDSET_RXORDSET_Msk            /*!< Rx Ordered Set Code detected  */
#define UCPD_RX_ORDSET_RXORDSET_0           (0x1UL << UCPD_RX_ORDSET_RXORDSET_Pos) /*!< 0x00000001 */
#define UCPD_RX_ORDSET_RXORDSET_1           (0x2UL << UCPD_RX_ORDSET_RXORDSET_Pos) /*!< 0x00000002 */
#define UCPD_RX_ORDSET_RXORDSET_2           (0x4UL << UCPD_RX_ORDSET_RXORDSET_Pos) /*!< 0x00000004 */
#define UCPD_RX_ORDSET_RXORDSET_Msk         (0x7UL << UCPD_RX_ORDSET_RXORDSET_Pos) /*!< 0x00000007 */
#define UCPD_RX_ORDSET_RXORDSET_Pos         (0U)
#define UCPD_RX_PAYSZ_RXPAYSZ               UCPD_RX_PAYSZ_RXPAYSZ_Msk             /*!< Rx payload size in bytes  */
#define UCPD_RX_PAYSZ_RXPAYSZ_Msk           (0x3FFUL << UCPD_RX_PAYSZ_RXPAYSZ_Pos)/*!< 0x000003FF */
#define UCPD_RX_PAYSZ_RXPAYSZ_Pos           (0U)
#define UCPD_SR_FRSEVT                      UCPD_SR_FRSEVT_Msk                   /*!< Fast Role Swap detection event  */
#define UCPD_SR_FRSEVT_Msk                  (0x1UL << UCPD_SR_FRSEVT_Pos)        /*!< 0x00100000 */
#define UCPD_SR_FRSEVT_Pos                  (20U)
#define UCPD_SR_HRSTDISC                    UCPD_SR_HRSTDISC_Msk                 /*!< HRST discarded interrupt  */
#define UCPD_SR_HRSTDISC_Msk                (0x1UL << UCPD_SR_HRSTDISC_Pos)      /*!< 0x00000010 */
#define UCPD_SR_HRSTDISC_Pos                (4U)
#define UCPD_SR_HRSTSENT                    UCPD_SR_HRSTSENT_Msk                 /*!< HRST sent interrupt  */
#define UCPD_SR_HRSTSENT_Msk                (0x1UL << UCPD_SR_HRSTSENT_Pos)      /*!< 0x00000020 */
#define UCPD_SR_HRSTSENT_Pos                (5U)
#define UCPD_SR_RXERR                       UCPD_SR_RXERR_Msk                    /*!< RX Error */
#define UCPD_SR_RXERR_Msk                   (0x1UL << UCPD_SR_RXERR_Pos)         /*!< 0x00002000 */
#define UCPD_SR_RXERR_Pos                   (13U)
#define UCPD_SR_RXHRSTDET                   UCPD_SR_RXHRSTDET_Msk                /*!< Rx Hard Reset detect interrupt  */
#define UCPD_SR_RXHRSTDET_Msk               (0x1UL << UCPD_SR_RXHRSTDET_Pos)     /*!< 0x00000400 */
#define UCPD_SR_RXHRSTDET_Pos               (10U)
#define UCPD_SR_RXMSGEND                    UCPD_SR_RXMSGEND_Msk                 /*!< Rx message received  */
#define UCPD_SR_RXMSGEND_Msk                (0x1UL << UCPD_SR_RXMSGEND_Pos)      /*!< 0x00001000 */
#define UCPD_SR_RXMSGEND_Pos                (12U)
#define UCPD_SR_RXNE                        UCPD_SR_RXNE_Msk                     /*!< Receive data register not empty interrupt  */
#define UCPD_SR_RXNE_Msk                    (0x1UL << UCPD_SR_RXNE_Pos)          /*!< 0x00000100 */
#define UCPD_SR_RXNE_Pos                    (8U)
#define UCPD_SR_RXORDDET                    UCPD_SR_RXORDDET_Msk                 /*!< Rx ordered set (4 K-codes) detected interrupt  */
#define UCPD_SR_RXORDDET_Msk                (0x1UL << UCPD_SR_RXORDDET_Pos)      /*!< 0x00000200 */
#define UCPD_SR_RXORDDET_Pos                (9U)
#define UCPD_SR_RXOVR                       UCPD_SR_RXOVR_Msk                    /*!< Rx data overflow interrupt  */
#define UCPD_SR_RXOVR_Msk                   (0x1UL << UCPD_SR_RXOVR_Pos)         /*!< 0x00000800 */
#define UCPD_SR_RXOVR_Pos                   (11U)
#define UCPD_SR_TXIS                        UCPD_SR_TXIS_Msk                     /*!< Transmit interrupt status  */
#define UCPD_SR_TXIS_Msk                    (0x1UL << UCPD_SR_TXIS_Pos)          /*!< 0x00000001 */
#define UCPD_SR_TXIS_Pos                    (0U)
#define UCPD_SR_TXMSGABT                    UCPD_SR_TXMSGABT_Msk                 /*!< Transmit message abort interrupt  */
#define UCPD_SR_TXMSGABT_Msk                (0x1UL << UCPD_SR_TXMSGABT_Pos)      /*!< 0x00000008 */
#define UCPD_SR_TXMSGABT_Pos                (3U)
#define UCPD_SR_TXMSGDISC                   UCPD_SR_TXMSGDISC_Msk                /*!< Transmit message discarded interrupt  */
#define UCPD_SR_TXMSGDISC_Msk               (0x1UL << UCPD_SR_TXMSGDISC_Pos)     /*!< 0x00000002 */
#define UCPD_SR_TXMSGDISC_Pos               (1U)
#define UCPD_SR_TXMSGSENT                   UCPD_SR_TXMSGSENT_Msk                /*!< Transmit message sent interrupt  */
#define UCPD_SR_TXMSGSENT_Msk               (0x1UL << UCPD_SR_TXMSGSENT_Pos)     /*!< 0x00000004 */
#define UCPD_SR_TXMSGSENT_Pos               (2U)
#define UCPD_SR_TXUND                       UCPD_SR_TXUND_Msk                    /*!< Tx data underrun condition interrupt  */
#define UCPD_SR_TXUND_Msk                   (0x1UL << UCPD_SR_TXUND_Pos)         /*!< 0x00000040 */
#define UCPD_SR_TXUND_Pos                   (6U)
#define UCPD_SR_TYPECEVT1                   UCPD_SR_TYPECEVT1_Msk                /*!< Type C voltage level event on CC1  */
#define UCPD_SR_TYPECEVT1_Msk               (0x1UL << UCPD_SR_TYPECEVT1_Pos)     /*!< 0x00004000 */
#define UCPD_SR_TYPECEVT1_Pos               (14U)
#define UCPD_SR_TYPECEVT2                   UCPD_SR_TYPECEVT2_Msk                /*!< Type C voltage level event on CC2  */
#define UCPD_SR_TYPECEVT2_Msk               (0x1UL << UCPD_SR_TYPECEVT2_Pos)     /*!< 0x00008000 */
#define UCPD_SR_TYPECEVT2_Pos               (15U)
#define UCPD_SR_TYPEC_VSTATE_CC1            UCPD_SR_TYPEC_VSTATE_CC1_Msk           /*!< Status of DC level on CC1 pin  */
#define UCPD_SR_TYPEC_VSTATE_CC1_0          (0x1UL << UCPD_SR_TYPEC_VSTATE_CC1_Pos)/*!< 0x00010000 */
#define UCPD_SR_TYPEC_VSTATE_CC1_1          (0x2UL << UCPD_SR_TYPEC_VSTATE_CC1_Pos)/*!< 0x00020000 */
#define UCPD_SR_TYPEC_VSTATE_CC1_Msk        (0x3UL << UCPD_SR_TYPEC_VSTATE_CC1_Pos)/*!< 0x00030000 */
#define UCPD_SR_TYPEC_VSTATE_CC1_Pos        (16U)
#define UCPD_SR_TYPEC_VSTATE_CC2            UCPD_SR_TYPEC_VSTATE_CC2_Msk           /*!<Status of DC level on CC2 pin  */
#define UCPD_SR_TYPEC_VSTATE_CC2_0          (0x1UL << UCPD_SR_TYPEC_VSTATE_CC2_Pos)/*!< 0x00040000 */
#define UCPD_SR_TYPEC_VSTATE_CC2_1          (0x2UL << UCPD_SR_TYPEC_VSTATE_CC2_Pos)/*!< 0x00080000 */
#define UCPD_SR_TYPEC_VSTATE_CC2_Msk        (0x3UL << UCPD_SR_TYPEC_VSTATE_CC2_Pos)/*!< 0x000C0000 */
#define UCPD_SR_TYPEC_VSTATE_CC2_Pos        (18U)
