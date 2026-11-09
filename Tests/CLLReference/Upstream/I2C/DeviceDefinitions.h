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
  __IO uint32_t CR1;         /*!< I2C Control register 1,            Address offset: 0x00 */
  __IO uint32_t CR2;         /*!< I2C Control register 2,            Address offset: 0x04 */
  __IO uint32_t OAR1;        /*!< I2C Own address 1 register,        Address offset: 0x08 */
  __IO uint32_t OAR2;        /*!< I2C Own address 2 register,        Address offset: 0x0C */
  __IO uint32_t TIMINGR;     /*!< I2C Timing register,               Address offset: 0x10 */
  __IO uint32_t TIMEOUTR;    /*!< I2C Timeout register,              Address offset: 0x14 */
  __IO uint32_t ISR;         /*!< I2C Interrupt and status register, Address offset: 0x18 */
  __IO uint32_t ICR;         /*!< I2C Interrupt clear register,      Address offset: 0x1C */
  __IO uint32_t PECR;        /*!< I2C PEC register,                  Address offset: 0x20 */
  __IO uint32_t RXDR;        /*!< I2C Receive data register,         Address offset: 0x24 */
  __IO uint32_t TXDR;        /*!< I2C Transmit data register,        Address offset: 0x28 */
} I2C_TypeDef;
typedef struct
{
  __IO uint32_t CR;             /*!< I3C Control register,                      Address offset: 0x00      */
  __IO uint32_t CFGR;           /*!< I3C Controller Configuration register,     Address offset: 0x04      */
  uint32_t      RESERVED1[2];   /*!< Reserved,                                  Address offset: 0x08-0x0C */
  __IO uint32_t RDR;            /*!< I3C Received Data register,                Address offset: 0x10      */
  __IO uint32_t RDWR;           /*!< I3C Received Data Word register,           Address offset: 0x14      */
  __IO uint32_t TDR;            /*!< I3C Transmit Data register,                Address offset: 0x18      */
  __IO uint32_t TDWR;           /*!< I3C Transmit Data Word register,           Address offset: 0x1C      */
  __IO uint32_t IBIDR;          /*!< I3C IBI payload Data register,             Address offset: 0x20      */
  __IO uint32_t TGTTDR;         /*!< I3C Target Transmit register,              Address offset: 0x24      */
  uint32_t      RESERVED2[2];   /*!< Reserved,                                  Address offset: 0x28-0x2C */
  __IO uint32_t SR;             /*!< I3C Status register,                       Address offset: 0x30      */
  __IO uint32_t SER;            /*!< I3C Status Error register,                 Address offset: 0x34      */
  uint32_t      RESERVED3[2];   /*!< Reserved,                                  Address offset: 0x38-0x3C */
  __IO uint32_t RMR;            /*!< I3C Received Message register,             Address offset: 0x40      */
  uint32_t      RESERVED4[3];   /*!< Reserved,                                  Address offset: 0x44-0x4C */
  __IO uint32_t EVR;            /*!< I3C Event register,                        Address offset: 0x50      */
  __IO uint32_t IER;            /*!< I3C Interrupt Enable register,             Address offset: 0x54      */
  __IO uint32_t CEVR;           /*!< I3C Clear Event register,                  Address offset: 0x58      */
  uint32_t RESERVED5;           /*!< Reserved,                                  Address offset: 0x5C      */
  __IO uint32_t DEVR0;          /*!< I3C own Target characteristics register,   Address offset: 0x60      */
  __IO uint32_t DEVRX[4];       /*!< I3C Target x (1<=x<=4) register,           Address offset: 0x64-0x70 */
  uint32_t      RESERVED6[7];   /*!< Reserved,                                  Address offset: 0x74-0x8C */
  __IO uint32_t MAXRLR;         /*!< I3C Maximum Read Length register,          Address offset: 0x90      */
  __IO uint32_t MAXWLR;         /*!< I3C Maximum Write Length register,         Address offset: 0x94      */
  uint32_t      RESERVED7[2];   /*!< Reserved,                                  Address offset: 0x98-0x9C */
  __IO uint32_t TIMINGR0;       /*!< I3C Timing 0 register,                     Address offset: 0xA0      */
  __IO uint32_t TIMINGR1;       /*!< I3C Timing 1 register,                     Address offset: 0xA4      */
  __IO uint32_t TIMINGR2;       /*!< I3C Timing 2 register,                     Address offset: 0xA8      */
  uint32_t      RESERVED9[5];   /*!< Reserved,                                  Address offset: 0xAC-0xBC */
  __IO uint32_t BCR;            /*!< I3C Bus Characteristics register,          Address offset: 0xC0      */
  __IO uint32_t DCR;            /*!< I3C Device Characteristics register,       Address offset: 0xC4      */
  __IO uint32_t GETCAPR;        /*!< I3C GET CAPabilities register,             Address offset: 0xC8      */
  __IO uint32_t CRCAPR;         /*!< I3C Controller CAPabilities register,      Address offset: 0xCC      */
  __IO uint32_t GETMXDSR;       /*!< I3C GET Max Data Speed register,           Address offset: 0xD0      */
  __IO uint32_t EPIDR;          /*!< I3C Extended Provisioned ID register,      Address offset: 0xD4      */
} I3C_TypeDef;
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
#define I2C1_BASE                       (APB1PERIPH_BASE + 0x5400UL)
#define I2C2_BASE                       (APB1PERIPH_BASE + 0x5800UL)
#define I2C3_BASE                       (APB1PERIPH_BASE + 0x5C00UL)
#define I2C_CR1_ADDRACLR             I2C_CR1_ADDRACLR_Msk                      /*!< ADDRACLR enable */
#define I2C_CR1_ADDRACLR_Msk         (0x1UL << I2C_CR1_ADDRACLR_Pos)           /*!< 0x40000000 */
#define I2C_CR1_ADDRACLR_Pos         (30U)
#define I2C_CR1_ADDRIE               I2C_CR1_ADDRIE_Msk                        /*!< Address match interrupt enable */
#define I2C_CR1_ADDRIE_Msk           (0x1UL << I2C_CR1_ADDRIE_Pos)             /*!< 0x00000008 */
#define I2C_CR1_ADDRIE_Pos           (3U)
#define I2C_CR1_ALERTEN              I2C_CR1_ALERTEN_Msk                       /*!< SMBus alert enable */
#define I2C_CR1_ALERTEN_Msk          (0x1UL << I2C_CR1_ALERTEN_Pos)            /*!< 0x00400000 */
#define I2C_CR1_ALERTEN_Pos          (22U)
#define I2C_CR1_ANFOFF               I2C_CR1_ANFOFF_Msk                        /*!< Analog noise filter OFF */
#define I2C_CR1_ANFOFF_Msk           (0x1UL << I2C_CR1_ANFOFF_Pos)             /*!< 0x00001000 */
#define I2C_CR1_ANFOFF_Pos           (12U)
#define I2C_CR1_DNF                  I2C_CR1_DNF_Msk                           /*!< Digital noise filter */
#define I2C_CR1_DNF_Msk              (0xFUL << I2C_CR1_DNF_Pos)                /*!< 0x00000F00 */
#define I2C_CR1_DNF_Pos              (8U)
#define I2C_CR1_ERRIE                I2C_CR1_ERRIE_Msk                         /*!< Errors interrupt enable */
#define I2C_CR1_ERRIE_Msk            (0x1UL << I2C_CR1_ERRIE_Pos)              /*!< 0x00000080 */
#define I2C_CR1_ERRIE_Pos            (7U)
#define I2C_CR1_FMP                  I2C_CR1_FMP_Msk                           /*!< FMP enable */
#define I2C_CR1_FMP_Msk              (0x1UL << I2C_CR1_FMP_Pos)                /*!< 0x01000000 */
#define I2C_CR1_FMP_Pos              (24U)
#define I2C_CR1_GCEN                 I2C_CR1_GCEN_Msk                          /*!< General call enable */
#define I2C_CR1_GCEN_Msk             (0x1UL << I2C_CR1_GCEN_Pos)               /*!< 0x00080000 */
#define I2C_CR1_GCEN_Pos             (19U)
#define I2C_CR1_NACKIE               I2C_CR1_NACKIE_Msk                        /*!< NACK received interrupt enable */
#define I2C_CR1_NACKIE_Msk           (0x1UL << I2C_CR1_NACKIE_Pos)             /*!< 0x00000010 */
#define I2C_CR1_NACKIE_Pos           (4U)
#define I2C_CR1_NOSTRETCH            I2C_CR1_NOSTRETCH_Msk                     /*!< Clock stretching disable */
#define I2C_CR1_NOSTRETCH_Msk        (0x1UL << I2C_CR1_NOSTRETCH_Pos)          /*!< 0x00020000 */
#define I2C_CR1_NOSTRETCH_Pos        (17U)
#define I2C_CR1_PE                   I2C_CR1_PE_Msk                            /*!< Peripheral enable */
#define I2C_CR1_PECEN                I2C_CR1_PECEN_Msk                         /*!< PEC enable */
#define I2C_CR1_PECEN_Msk            (0x1UL << I2C_CR1_PECEN_Pos)              /*!< 0x00800000 */
#define I2C_CR1_PECEN_Pos            (23U)
#define I2C_CR1_PE_Msk               (0x1UL << I2C_CR1_PE_Pos)                 /*!< 0x00000001 */
#define I2C_CR1_PE_Pos               (0U)
#define I2C_CR1_RXDMAEN              I2C_CR1_RXDMAEN_Msk                       /*!< DMA reception requests enable */
#define I2C_CR1_RXDMAEN_Msk          (0x1UL << I2C_CR1_RXDMAEN_Pos)            /*!< 0x00008000 */
#define I2C_CR1_RXDMAEN_Pos          (15U)
#define I2C_CR1_RXIE                 I2C_CR1_RXIE_Msk                          /*!< RX interrupt enable */
#define I2C_CR1_RXIE_Msk             (0x1UL << I2C_CR1_RXIE_Pos)               /*!< 0x00000004 */
#define I2C_CR1_RXIE_Pos             (2U)
#define I2C_CR1_SBC                  I2C_CR1_SBC_Msk                           /*!< Slave byte control */
#define I2C_CR1_SBC_Msk              (0x1UL << I2C_CR1_SBC_Pos)                /*!< 0x00010000 */
#define I2C_CR1_SBC_Pos              (16U)
#define I2C_CR1_SMBDEN               I2C_CR1_SMBDEN_Msk                        /*!< SMBus device default address enable */
#define I2C_CR1_SMBDEN_Msk           (0x1UL << I2C_CR1_SMBDEN_Pos)             /*!< 0x00200000 */
#define I2C_CR1_SMBDEN_Pos           (21U)
#define I2C_CR1_SMBHEN               I2C_CR1_SMBHEN_Msk                        /*!< SMBus host address enable */
#define I2C_CR1_SMBHEN_Msk           (0x1UL << I2C_CR1_SMBHEN_Pos)             /*!< 0x00100000 */
#define I2C_CR1_SMBHEN_Pos           (20U)
#define I2C_CR1_STOPFACLR            I2C_CR1_STOPFACLR_Msk                     /*!< STOPFACLR enable */
#define I2C_CR1_STOPFACLR_Msk        (0x1UL << I2C_CR1_STOPFACLR_Pos)          /*!< 0x80000000 */
#define I2C_CR1_STOPFACLR_Pos        (31U)
#define I2C_CR1_STOPIE               I2C_CR1_STOPIE_Msk                        /*!< STOP detection interrupt enable */
#define I2C_CR1_STOPIE_Msk           (0x1UL << I2C_CR1_STOPIE_Pos)             /*!< 0x00000020 */
#define I2C_CR1_STOPIE_Pos           (5U)
#define I2C_CR1_TCIE                 I2C_CR1_TCIE_Msk                          /*!< Transfer complete interrupt enable */
#define I2C_CR1_TCIE_Msk             (0x1UL << I2C_CR1_TCIE_Pos)               /*!< 0x00000040 */
#define I2C_CR1_TCIE_Pos             (6U)
#define I2C_CR1_TXDMAEN              I2C_CR1_TXDMAEN_Msk                       /*!< DMA transmission requests enable */
#define I2C_CR1_TXDMAEN_Msk          (0x1UL << I2C_CR1_TXDMAEN_Pos)            /*!< 0x00004000 */
#define I2C_CR1_TXDMAEN_Pos          (14U)
#define I2C_CR1_TXIE                 I2C_CR1_TXIE_Msk                          /*!< TX interrupt enable */
#define I2C_CR1_TXIE_Msk             (0x1UL << I2C_CR1_TXIE_Pos)               /*!< 0x00000002 */
#define I2C_CR1_TXIE_Pos             (1U)
#define I2C_CR1_WUPEN                I2C_CR1_WUPEN_Msk                         /*!< Wakeup from STOP enable */
#define I2C_CR1_WUPEN_Msk            (0x1UL << I2C_CR1_WUPEN_Pos)              /*!< 0x00040000 */
#define I2C_CR1_WUPEN_Pos            (18U)
#define I2C_CR2_ADD10                I2C_CR2_ADD10_Msk                         /*!< 10-bit addressing mode (master mode) */
#define I2C_CR2_ADD10_Msk            (0x1UL << I2C_CR2_ADD10_Pos)              /*!< 0x00000800 */
#define I2C_CR2_ADD10_Pos            (11U)
#define I2C_CR2_AUTOEND              I2C_CR2_AUTOEND_Msk                       /*!< Automatic end mode (master mode) */
#define I2C_CR2_AUTOEND_Msk          (0x1UL << I2C_CR2_AUTOEND_Pos)            /*!< 0x02000000 */
#define I2C_CR2_AUTOEND_Pos          (25U)
#define I2C_CR2_HEAD10R              I2C_CR2_HEAD10R_Msk                       /*!< 10-bit address header only read direction (master mode) */
#define I2C_CR2_HEAD10R_Msk          (0x1UL << I2C_CR2_HEAD10R_Pos)            /*!< 0x00001000 */
#define I2C_CR2_HEAD10R_Pos          (12U)
#define I2C_CR2_NACK                 I2C_CR2_NACK_Msk                          /*!< NACK generation (slave mode) */
#define I2C_CR2_NACK_Msk             (0x1UL << I2C_CR2_NACK_Pos)               /*!< 0x00008000 */
#define I2C_CR2_NACK_Pos             (15U)
#define I2C_CR2_NBYTES               I2C_CR2_NBYTES_Msk                        /*!< Number of bytes */
#define I2C_CR2_NBYTES_Msk           (0xFFUL << I2C_CR2_NBYTES_Pos)            /*!< 0x00FF0000 */
#define I2C_CR2_NBYTES_Pos           (16U)
#define I2C_CR2_PECBYTE              I2C_CR2_PECBYTE_Msk                       /*!< Packet error checking byte */
#define I2C_CR2_PECBYTE_Msk          (0x1UL << I2C_CR2_PECBYTE_Pos)            /*!< 0x04000000 */
#define I2C_CR2_PECBYTE_Pos          (26U)
#define I2C_CR2_RD_WRN               I2C_CR2_RD_WRN_Msk                        /*!< Transfer direction (master mode) */
#define I2C_CR2_RD_WRN_Msk           (0x1UL << I2C_CR2_RD_WRN_Pos)             /*!< 0x00000400 */
#define I2C_CR2_RD_WRN_Pos           (10U)
#define I2C_CR2_RELOAD               I2C_CR2_RELOAD_Msk                        /*!< NBYTES reload mode */
#define I2C_CR2_RELOAD_Msk           (0x1UL << I2C_CR2_RELOAD_Pos)             /*!< 0x01000000 */
#define I2C_CR2_RELOAD_Pos           (24U)
#define I2C_CR2_SADD                 I2C_CR2_SADD_Msk                          /*!< Slave address (master mode) */
#define I2C_CR2_SADD_Msk             (0x3FFUL << I2C_CR2_SADD_Pos)             /*!< 0x000003FF */
#define I2C_CR2_SADD_Pos             (0U)
#define I2C_CR2_START                I2C_CR2_START_Msk                         /*!< START generation */
#define I2C_CR2_START_Msk            (0x1UL << I2C_CR2_START_Pos)              /*!< 0x00002000 */
#define I2C_CR2_START_Pos            (13U)
#define I2C_CR2_STOP                 I2C_CR2_STOP_Msk                          /*!< STOP generation (master mode) */
#define I2C_CR2_STOP_Msk             (0x1UL << I2C_CR2_STOP_Pos)               /*!< 0x00004000 */
#define I2C_CR2_STOP_Pos             (14U)
#define I2C_ICR_ADDRCF               I2C_ICR_ADDRCF_Msk                        /*!< Address matched clear flag */
#define I2C_ICR_ADDRCF_Msk           (0x1UL << I2C_ICR_ADDRCF_Pos)             /*!< 0x00000008 */
#define I2C_ICR_ADDRCF_Pos           (3U)
#define I2C_ICR_ALERTCF              I2C_ICR_ALERTCF_Msk                       /*!< Alert clear flag */
#define I2C_ICR_ALERTCF_Msk          (0x1UL << I2C_ICR_ALERTCF_Pos)            /*!< 0x00002000 */
#define I2C_ICR_ALERTCF_Pos          (13U)
#define I2C_ICR_ARLOCF               I2C_ICR_ARLOCF_Msk                        /*!< Arbitration lost clear flag */
#define I2C_ICR_ARLOCF_Msk           (0x1UL << I2C_ICR_ARLOCF_Pos)             /*!< 0x00000200 */
#define I2C_ICR_ARLOCF_Pos           (9U)
#define I2C_ICR_BERRCF               I2C_ICR_BERRCF_Msk                        /*!< Bus error clear flag */
#define I2C_ICR_BERRCF_Msk           (0x1UL << I2C_ICR_BERRCF_Pos)             /*!< 0x00000100 */
#define I2C_ICR_BERRCF_Pos           (8U)
#define I2C_ICR_NACKCF               I2C_ICR_NACKCF_Msk                        /*!< NACK clear flag */
#define I2C_ICR_NACKCF_Msk           (0x1UL << I2C_ICR_NACKCF_Pos)             /*!< 0x00000010 */
#define I2C_ICR_NACKCF_Pos           (4U)
#define I2C_ICR_OVRCF                I2C_ICR_OVRCF_Msk                         /*!< Overrun/Underrun clear flag */
#define I2C_ICR_OVRCF_Msk            (0x1UL << I2C_ICR_OVRCF_Pos)              /*!< 0x00000400 */
#define I2C_ICR_OVRCF_Pos            (10U)
#define I2C_ICR_PECCF                I2C_ICR_PECCF_Msk                         /*!< PAC error clear flag */
#define I2C_ICR_PECCF_Msk            (0x1UL << I2C_ICR_PECCF_Pos)              /*!< 0x00000800 */
#define I2C_ICR_PECCF_Pos            (11U)
#define I2C_ICR_STOPCF               I2C_ICR_STOPCF_Msk                        /*!< STOP detection clear flag */
#define I2C_ICR_STOPCF_Msk           (0x1UL << I2C_ICR_STOPCF_Pos)             /*!< 0x00000020 */
#define I2C_ICR_STOPCF_Pos           (5U)
#define I2C_ICR_TIMOUTCF             I2C_ICR_TIMOUTCF_Msk                      /*!< Timeout clear flag */
#define I2C_ICR_TIMOUTCF_Msk         (0x1UL << I2C_ICR_TIMOUTCF_Pos)           /*!< 0x00001000 */
#define I2C_ICR_TIMOUTCF_Pos         (12U)
#define I2C_ISR_ADDCODE              I2C_ISR_ADDCODE_Msk                       /*!< Address match code (slave mode) */
#define I2C_ISR_ADDCODE_Msk          (0x7FUL << I2C_ISR_ADDCODE_Pos)           /*!< 0x00FE0000 */
#define I2C_ISR_ADDCODE_Pos          (17U)
#define I2C_ISR_ADDR                 I2C_ISR_ADDR_Msk                          /*!< Address matched (slave mode)*/
#define I2C_ISR_ADDR_Msk             (0x1UL << I2C_ISR_ADDR_Pos)               /*!< 0x00000008 */
#define I2C_ISR_ADDR_Pos             (3U)
#define I2C_ISR_ALERT                I2C_ISR_ALERT_Msk                         /*!< SMBus alert */
#define I2C_ISR_ALERT_Msk            (0x1UL << I2C_ISR_ALERT_Pos)              /*!< 0x00002000 */
#define I2C_ISR_ALERT_Pos            (13U)
#define I2C_ISR_ARLO                 I2C_ISR_ARLO_Msk                          /*!< Arbitration lost */
#define I2C_ISR_ARLO_Msk             (0x1UL << I2C_ISR_ARLO_Pos)               /*!< 0x00000200 */
#define I2C_ISR_ARLO_Pos             (9U)
#define I2C_ISR_BERR                 I2C_ISR_BERR_Msk                          /*!< Bus error */
#define I2C_ISR_BERR_Msk             (0x1UL << I2C_ISR_BERR_Pos)               /*!< 0x00000100 */
#define I2C_ISR_BERR_Pos             (8U)
#define I2C_ISR_BUSY                 I2C_ISR_BUSY_Msk                          /*!< Bus busy */
#define I2C_ISR_BUSY_Msk             (0x1UL << I2C_ISR_BUSY_Pos)               /*!< 0x00008000 */
#define I2C_ISR_BUSY_Pos             (15U)
#define I2C_ISR_DIR                  I2C_ISR_DIR_Msk                           /*!< Transfer direction (slave mode) */
#define I2C_ISR_DIR_Msk              (0x1UL << I2C_ISR_DIR_Pos)                /*!< 0x00010000 */
#define I2C_ISR_DIR_Pos              (16U)
#define I2C_ISR_NACKF                I2C_ISR_NACKF_Msk                         /*!< NACK received flag */
#define I2C_ISR_NACKF_Msk            (0x1UL << I2C_ISR_NACKF_Pos)              /*!< 0x00000010 */
#define I2C_ISR_NACKF_Pos            (4U)
#define I2C_ISR_OVR                  I2C_ISR_OVR_Msk                           /*!< Overrun/Underrun */
#define I2C_ISR_OVR_Msk              (0x1UL << I2C_ISR_OVR_Pos)                /*!< 0x00000400 */
#define I2C_ISR_OVR_Pos              (10U)
#define I2C_ISR_PECERR               I2C_ISR_PECERR_Msk                        /*!< PEC error in reception */
#define I2C_ISR_PECERR_Msk           (0x1UL << I2C_ISR_PECERR_Pos)             /*!< 0x00000800 */
#define I2C_ISR_PECERR_Pos           (11U)
#define I2C_ISR_RXNE                 I2C_ISR_RXNE_Msk                          /*!< Receive data register not empty */
#define I2C_ISR_RXNE_Msk             (0x1UL << I2C_ISR_RXNE_Pos)               /*!< 0x00000004 */
#define I2C_ISR_RXNE_Pos             (2U)
#define I2C_ISR_STOPF                I2C_ISR_STOPF_Msk                         /*!< STOP detection flag */
#define I2C_ISR_STOPF_Msk            (0x1UL << I2C_ISR_STOPF_Pos)              /*!< 0x00000020 */
#define I2C_ISR_STOPF_Pos            (5U)
#define I2C_ISR_TC                   I2C_ISR_TC_Msk                            /*!< Transfer complete (master mode) */
#define I2C_ISR_TCR                  I2C_ISR_TCR_Msk                           /*!< Transfer complete reload */
#define I2C_ISR_TCR_Msk              (0x1UL << I2C_ISR_TCR_Pos)                /*!< 0x00000080 */
#define I2C_ISR_TCR_Pos              (7U)
#define I2C_ISR_TC_Msk               (0x1UL << I2C_ISR_TC_Pos)                 /*!< 0x00000040 */
#define I2C_ISR_TC_Pos               (6U)
#define I2C_ISR_TIMEOUT              I2C_ISR_TIMEOUT_Msk                       /*!< Timeout or Tlow detection flag */
#define I2C_ISR_TIMEOUT_Msk          (0x1UL << I2C_ISR_TIMEOUT_Pos)            /*!< 0x00001000 */
#define I2C_ISR_TIMEOUT_Pos          (12U)
#define I2C_ISR_TXE                  I2C_ISR_TXE_Msk                           /*!< Transmit data register empty */
#define I2C_ISR_TXE_Msk              (0x1UL << I2C_ISR_TXE_Pos)                /*!< 0x00000001 */
#define I2C_ISR_TXE_Pos              (0U)
#define I2C_ISR_TXIS                 I2C_ISR_TXIS_Msk                          /*!< Transmit interrupt status */
#define I2C_ISR_TXIS_Msk             (0x1UL << I2C_ISR_TXIS_Pos)               /*!< 0x00000002 */
#define I2C_ISR_TXIS_Pos             (1U)
#define I2C_OAR1_OA1                 I2C_OAR1_OA1_Msk                          /*!< Interface own address 1 */
#define I2C_OAR1_OA1EN               I2C_OAR1_OA1EN_Msk                        /*!< Own address 1 enable */
#define I2C_OAR1_OA1EN_Msk           (0x1UL << I2C_OAR1_OA1EN_Pos)             /*!< 0x00008000 */
#define I2C_OAR1_OA1EN_Pos           (15U)
#define I2C_OAR1_OA1MODE             I2C_OAR1_OA1MODE_Msk                      /*!< Own address 1 10-bit mode */
#define I2C_OAR1_OA1MODE_Msk         (0x1UL << I2C_OAR1_OA1MODE_Pos)           /*!< 0x00000400 */
#define I2C_OAR1_OA1MODE_Pos         (10U)
#define I2C_OAR1_OA1_Msk             (0x3FFUL << I2C_OAR1_OA1_Pos)             /*!< 0x000003FF */
#define I2C_OAR1_OA1_Pos             (0U)
#define I2C_OAR2_OA2                 I2C_OAR2_OA2_Msk                          /*!< Interface own address 2 */
#define I2C_OAR2_OA2EN               I2C_OAR2_OA2EN_Msk                        /*!< Own address 2 enable */
#define I2C_OAR2_OA2EN_Msk           (0x1UL << I2C_OAR2_OA2EN_Pos)             /*!< 0x00008000 */
#define I2C_OAR2_OA2EN_Pos           (15U)
#define I2C_OAR2_OA2MASK01           I2C_OAR2_OA2MASK01_Msk                    /*!< OA2[1] is masked, Only OA2[7:2] are compared   */
#define I2C_OAR2_OA2MASK01_Msk       (0x1UL << I2C_OAR2_OA2MASK01_Pos)         /*!< 0x00000100 */
#define I2C_OAR2_OA2MASK01_Pos       (8U)
#define I2C_OAR2_OA2MASK02           I2C_OAR2_OA2MASK02_Msk                    /*!< OA2[2:1] is masked, Only OA2[7:3] are compared */
#define I2C_OAR2_OA2MASK02_Msk       (0x1UL << I2C_OAR2_OA2MASK02_Pos)         /*!< 0x00000200 */
#define I2C_OAR2_OA2MASK02_Pos       (9U)
#define I2C_OAR2_OA2MASK03           I2C_OAR2_OA2MASK03_Msk                    /*!< OA2[3:1] is masked, Only OA2[7:4] are compared */
#define I2C_OAR2_OA2MASK03_Msk       (0x3UL << I2C_OAR2_OA2MASK03_Pos)         /*!< 0x00000300 */
#define I2C_OAR2_OA2MASK03_Pos       (8U)
#define I2C_OAR2_OA2MASK04           I2C_OAR2_OA2MASK04_Msk                    /*!< OA2[4:1] is masked, Only OA2[7:5] are compared */
#define I2C_OAR2_OA2MASK04_Msk       (0x1UL << I2C_OAR2_OA2MASK04_Pos)         /*!< 0x00000400 */
#define I2C_OAR2_OA2MASK04_Pos       (10U)
#define I2C_OAR2_OA2MASK05           I2C_OAR2_OA2MASK05_Msk                    /*!< OA2[5:1] is masked, Only OA2[7:6] are compared */
#define I2C_OAR2_OA2MASK05_Msk       (0x5UL << I2C_OAR2_OA2MASK05_Pos)         /*!< 0x00000500 */
#define I2C_OAR2_OA2MASK05_Pos       (8U)
#define I2C_OAR2_OA2MASK06           I2C_OAR2_OA2MASK06_Msk                    /*!< OA2[6:1] is masked, Only OA2[7] are compared   */
#define I2C_OAR2_OA2MASK06_Msk       (0x3UL << I2C_OAR2_OA2MASK06_Pos)         /*!< 0x00000600 */
#define I2C_OAR2_OA2MASK06_Pos       (9U)
#define I2C_OAR2_OA2MASK07           I2C_OAR2_OA2MASK07_Msk                    /*!< OA2[7:1] is masked, No comparison is done      */
#define I2C_OAR2_OA2MASK07_Msk       (0x7UL << I2C_OAR2_OA2MASK07_Pos)         /*!< 0x00000700 */
#define I2C_OAR2_OA2MASK07_Pos       (8U)
#define I2C_OAR2_OA2MSK              I2C_OAR2_OA2MSK_Msk                       /*!< Own address 2 masks */
#define I2C_OAR2_OA2MSK_Msk          (0x7UL << I2C_OAR2_OA2MSK_Pos)            /*!< 0x00000700 */
#define I2C_OAR2_OA2MSK_Pos          (8U)
#define I2C_OAR2_OA2NOMASK           (0x00000000UL)                            /*!< No mask                                        */
#define I2C_OAR2_OA2_Msk             (0x7FUL << I2C_OAR2_OA2_Pos)              /*!< 0x000000FE */
#define I2C_OAR2_OA2_Pos             (1U)
#define I2C_PECR_PEC                 I2C_PECR_PEC_Msk                          /*!< PEC register */
#define I2C_PECR_PEC_Msk             (0xFFUL << I2C_PECR_PEC_Pos)              /*!< 0x000000FF */
#define I2C_PECR_PEC_Pos             (0U)
#define I2C_RXDR_RXDATA              I2C_RXDR_RXDATA_Msk                       /*!< 8-bit receive data */
#define I2C_RXDR_RXDATA_Msk          (0xFFUL << I2C_RXDR_RXDATA_Pos)           /*!< 0x000000FF */
#define I2C_RXDR_RXDATA_Pos          (0U)
#define I2C_TIMEOUTR_TEXTEN          I2C_TIMEOUTR_TEXTEN_Msk                   /*!< Extended clock timeout enable */
#define I2C_TIMEOUTR_TEXTEN_Msk      (0x1UL << I2C_TIMEOUTR_TEXTEN_Pos)        /*!< 0x80000000 */
#define I2C_TIMEOUTR_TEXTEN_Pos      (31U)
#define I2C_TIMEOUTR_TIDLE           I2C_TIMEOUTR_TIDLE_Msk                    /*!< Idle clock timeout detection */
#define I2C_TIMEOUTR_TIDLE_Msk       (0x1UL << I2C_TIMEOUTR_TIDLE_Pos)         /*!< 0x00001000 */
#define I2C_TIMEOUTR_TIDLE_Pos       (12U)
#define I2C_TIMEOUTR_TIMEOUTA        I2C_TIMEOUTR_TIMEOUTA_Msk                 /*!< Bus timeout A */
#define I2C_TIMEOUTR_TIMEOUTA_Msk    (0xFFFUL << I2C_TIMEOUTR_TIMEOUTA_Pos)    /*!< 0x00000FFF */
#define I2C_TIMEOUTR_TIMEOUTA_Pos    (0U)
#define I2C_TIMEOUTR_TIMEOUTB        I2C_TIMEOUTR_TIMEOUTB_Msk                 /*!< Bus timeout B*/
#define I2C_TIMEOUTR_TIMEOUTB_Msk    (0xFFFUL << I2C_TIMEOUTR_TIMEOUTB_Pos)    /*!< 0x0FFF0000 */
#define I2C_TIMEOUTR_TIMEOUTB_Pos    (16U)
#define I2C_TIMEOUTR_TIMOUTEN        I2C_TIMEOUTR_TIMOUTEN_Msk                 /*!< Clock timeout enable */
#define I2C_TIMEOUTR_TIMOUTEN_Msk    (0x1UL << I2C_TIMEOUTR_TIMOUTEN_Pos)      /*!< 0x00008000 */
#define I2C_TIMEOUTR_TIMOUTEN_Pos    (15U)
#define I2C_TIMINGR_PRESC            I2C_TIMINGR_PRESC_Msk                     /*!< Timings prescaler */
#define I2C_TIMINGR_PRESC_Msk        (0xFUL << I2C_TIMINGR_PRESC_Pos)          /*!< 0xF0000000 */
#define I2C_TIMINGR_PRESC_Pos        (28U)
#define I2C_TIMINGR_SCLDEL           I2C_TIMINGR_SCLDEL_Msk                    /*!< Data setup time */
#define I2C_TIMINGR_SCLDEL_Msk       (0xFUL << I2C_TIMINGR_SCLDEL_Pos)         /*!< 0x00F00000 */
#define I2C_TIMINGR_SCLDEL_Pos       (20U)
#define I2C_TIMINGR_SCLH             I2C_TIMINGR_SCLH_Msk                      /*!< SCL high period (master mode) */
#define I2C_TIMINGR_SCLH_Msk         (0xFFUL << I2C_TIMINGR_SCLH_Pos)          /*!< 0x0000FF00 */
#define I2C_TIMINGR_SCLH_Pos         (8U)
#define I2C_TIMINGR_SCLL             I2C_TIMINGR_SCLL_Msk                      /*!< SCL low period (master mode) */
#define I2C_TIMINGR_SCLL_Msk         (0xFFUL << I2C_TIMINGR_SCLL_Pos)          /*!< 0x000000FF */
#define I2C_TIMINGR_SCLL_Pos         (0U)
#define I2C_TIMINGR_SDADEL           I2C_TIMINGR_SDADEL_Msk                    /*!< Data hold time */
#define I2C_TIMINGR_SDADEL_Msk       (0xFUL << I2C_TIMINGR_SDADEL_Pos)         /*!< 0x000F0000 */
#define I2C_TIMINGR_SDADEL_Pos       (16U)
#define I3C1_BASE                       (APB1PERIPH_BASE + 0x5400UL)
#define I3C_BCR_BCR                         I3C_BCR_BCR_Msk                         /*!< Bus Characteristics */
#define I3C_BCR_BCR0                        I3C_BCR_BCR0_Msk                        /*!< Max Data Speed Limitation */
#define I3C_BCR_BCR0_Msk                    (0x1UL << I3C_BCR_BCR0_Pos)             /*!< 0x00000001 */
#define I3C_BCR_BCR0_Pos                    (0U)
#define I3C_BCR_BCR1_Msk                    (0x1UL << I3C_BCR_BCR1_Pos)             /*!< 0x00000002 */
#define I3C_BCR_BCR1_Pos                    (1U)
#define I3C_BCR_BCR2                        I3C_BCR_BCR2_Msk                        /*!< IBI Payload additional Mandatory Data Byte */
#define I3C_BCR_BCR2_Msk                    (0x1UL << I3C_BCR_BCR2_Pos)             /*!< 0x00000004 */
#define I3C_BCR_BCR2_Pos                    (2U)
#define I3C_BCR_BCR6                        I3C_BCR_BCR6_Msk                        /*!< Device Role shared during Dynamic Address Assignment */
#define I3C_BCR_BCR6_Msk                    (0x1UL << I3C_BCR_BCR6_Pos)             /*!< 0x00000040 */
#define I3C_BCR_BCR6_Pos                    (6U)
#define I3C_BCR_BCR_Msk                     (0xFFUL << I3C_BCR_BCR_Pos)             /*!< 0x000000FF */
#define I3C_BCR_BCR_Pos                     (0U)
#define I3C_CEVR_CASUPDF                    I3C_CEVR_CASUPDF_Msk                    /*!< Activity State Clear Flag */
#define I3C_CEVR_CASUPDF_Msk                (0x1UL << I3C_CEVR_CASUPDF_Pos)         /*!< 0x10000000 */
#define I3C_CEVR_CASUPDF_Pos                (28U)
#define I3C_CEVR_CCRF                       I3C_CEVR_CCRF_Msk                       /*!< Controller-role Clear Flag */
#define I3C_CEVR_CCRF_Msk                   (0x1UL << I3C_CEVR_CCRF_Pos)            /*!< 0x00020000 */
#define I3C_CEVR_CCRF_Pos                   (17U)
#define I3C_CEVR_CCRUPDF                    I3C_CEVR_CCRUPDF_Msk                    /*!< Controller-role Update Clear Flag */
#define I3C_CEVR_CCRUPDF_Msk                (0x1UL << I3C_CEVR_CCRUPDF_Pos)         /*!< 0x00040000 */
#define I3C_CEVR_CCRUPDF_Pos                (18U)
#define I3C_CEVR_CDAUPDF                    I3C_CEVR_CDAUPDF_Msk                    /*!< Dynamic Address Update Clear Flag */
#define I3C_CEVR_CDAUPDF_Msk                (0x1UL << I3C_CEVR_CDAUPDF_Pos)         /*!< 0x01000000 */
#define I3C_CEVR_CDAUPDF_Pos                (24U)
#define I3C_CEVR_CDEFF                      I3C_CEVR_CDEFF_Msk                      /*!< List of Targets Command Received Clear Flag */
#define I3C_CEVR_CDEFF_Msk                  (0x1UL << I3C_CEVR_CDEFF_Pos)           /*!< 0x40000000 */
#define I3C_CEVR_CDEFF_Pos                  (30U)
#define I3C_CEVR_CERRF                      I3C_CEVR_CERRF_Msk                      /*!< Error Clear Flag */
#define I3C_CEVR_CERRF_Msk                  (0x1UL << I3C_CEVR_CERRF_Pos)           /*!< 0x00000800 */
#define I3C_CEVR_CERRF_Pos                  (11U)
#define I3C_CEVR_CFCF                       I3C_CEVR_CFCF_Msk                       /*!< Frame Complete Clear Flag */
#define I3C_CEVR_CFCF_Msk                   (0x1UL << I3C_CEVR_CFCF_Pos)            /*!< 0x00000200 */
#define I3C_CEVR_CFCF_Pos                   (9U)
#define I3C_CEVR_CGETF                      I3C_CEVR_CGETF_Msk                      /*!< Get type CCC received Clear Flag */
#define I3C_CEVR_CGETF_Msk                  (0x1UL << I3C_CEVR_CGETF_Pos)           /*!< 0x00400000 */
#define I3C_CEVR_CGETF_Pos                  (22U)
#define I3C_CEVR_CGRPF                      I3C_CEVR_CGRPF_Msk                      /*!< List of Group Addresses Command Received Clear Flag */
#define I3C_CEVR_CGRPF_Msk                  (0x1UL << I3C_CEVR_CGRPF_Pos)           /*!< 0x80000000 */
#define I3C_CEVR_CGRPF_Pos                  (31U)
#define I3C_CEVR_CHJF                       I3C_CEVR_CHJF_Msk                       /*!< Hot Join Clear Flag */
#define I3C_CEVR_CHJF_Msk                   (0x1UL << I3C_CEVR_CHJF_Pos)            /*!< 0x00080000 */
#define I3C_CEVR_CHJF_Pos                   (19U)
#define I3C_CEVR_CIBIENDF                   I3C_CEVR_CIBIENDF_Msk                   /*!< IBI End Clear Flag */
#define I3C_CEVR_CIBIENDF_Msk               (0x1UL << I3C_CEVR_CIBIENDF_Pos)        /*!< 0x00010000 */
#define I3C_CEVR_CIBIENDF_Pos               (16U)
#define I3C_CEVR_CIBIF                      I3C_CEVR_CIBIF_Msk                      /*!< IBI Clear Flag */
#define I3C_CEVR_CIBIF_Msk                  (0x1UL << I3C_CEVR_CIBIF_Pos)           /*!< 0x00008000 */
#define I3C_CEVR_CIBIF_Pos                  (15U)
#define I3C_CEVR_CINTUPDF                   I3C_CEVR_CINTUPDF_Msk                   /*!< Interrupt Update Clear Flag */
#define I3C_CEVR_CINTUPDF_Msk               (0x1UL << I3C_CEVR_CINTUPDF_Pos)        /*!< 0x20000000 */
#define I3C_CEVR_CINTUPDF_Pos               (29U)
#define I3C_CEVR_CMRLUPDF                   I3C_CEVR_CMRLUPDF_Msk                   /*!< Max Read Length Update Clear Flag */
#define I3C_CEVR_CMRLUPDF_Msk               (0x1UL << I3C_CEVR_CMRLUPDF_Pos)        /*!< 0x04000000 */
#define I3C_CEVR_CMRLUPDF_Pos               (26U)
#define I3C_CEVR_CMWLUPDF                   I3C_CEVR_CMWLUPDF_Msk                   /*!< Max Write Length Update Clear Flag */
#define I3C_CEVR_CMWLUPDF_Msk               (0x1UL << I3C_CEVR_CMWLUPDF_Pos)        /*!< 0x02000000 */
#define I3C_CEVR_CMWLUPDF_Pos               (25U)
#define I3C_CEVR_CRSTF                      I3C_CEVR_CRSTF_Msk                      /*!< Reset Flag, due to Reset pattern received */
#define I3C_CEVR_CRSTF_Msk                  (0x1UL << I3C_CEVR_CRSTF_Pos)           /*!< 0x08000000 */
#define I3C_CEVR_CRSTF_Pos                  (27U)
#define I3C_CEVR_CRXTGTENDF                 I3C_CEVR_CRXTGTENDF_Msk                 /*!< Reception Target End Clear Flag */
#define I3C_CEVR_CRXTGTENDF_Msk             (0x1UL << I3C_CEVR_CRXTGTENDF_Pos)      /*!< 0x00000400 */
#define I3C_CEVR_CRXTGTENDF_Pos             (10U)
#define I3C_CEVR_CSTAF                      I3C_CEVR_CSTAF_Msk                      /*!< Get Status Clear Flag */
#define I3C_CEVR_CSTAF_Msk                  (0x1UL << I3C_CEVR_CSTAF_Pos)           /*!< 0x00800000 */
#define I3C_CEVR_CSTAF_Pos                  (23U)
#define I3C_CEVR_CWKPF                      I3C_CEVR_CWKPF_Msk                      /*!< Wake Up Clear Flag */
#define I3C_CEVR_CWKPF_Msk                  (0x1UL << I3C_CEVR_CWKPF_Pos)           /*!< 0x00200000 */
#define I3C_CEVR_CWKPF_Pos                  (21U)
#define I3C_CFGR_CDMAEN                     I3C_CFGR_CDMAEN_Msk                     /*!< Control FIFO DMA mode Enable */
#define I3C_CFGR_CDMAEN_Msk                 (0x1UL << I3C_CFGR_CDMAEN_Pos)          /*!< 0x00100000 */
#define I3C_CFGR_CDMAEN_Pos                 (20U)
#define I3C_CFGR_CFLUSH                     I3C_CFGR_CFLUSH_Msk                     /*!< Control FIFO Flush */
#define I3C_CFGR_CFLUSH_Msk                 (0x1UL << I3C_CFGR_CFLUSH_Pos)          /*!< 0x00200000 */
#define I3C_CFGR_CFLUSH_Pos                 (21U)
#define I3C_CFGR_CRINIT                     I3C_CFGR_CRINIT_Msk                     /*!< Peripheral Init mode (Target/Controller) */
#define I3C_CFGR_CRINIT_Msk                 (0x1UL << I3C_CFGR_CRINIT_Pos)          /*!< 0x00000002 */
#define I3C_CFGR_CRINIT_Pos                 (1U)
#define I3C_CFGR_EN                         I3C_CFGR_EN_Msk                         /*!< Peripheral Enable */
#define I3C_CFGR_EN_Msk                     (0x1UL << I3C_CFGR_EN_Pos)              /*!< 0x00000001 */
#define I3C_CFGR_EN_Pos                     (0U)
#define I3C_CFGR_EXITPTRN                   I3C_CFGR_EXITPTRN_Msk                   /*!< Exit Pattern enable */
#define I3C_CFGR_EXITPTRN_Msk               (0x1UL << I3C_CFGR_EXITPTRN_Pos)        /*!< 0x00000010 */
#define I3C_CFGR_EXITPTRN_Pos               (4U)
#define I3C_CFGR_HJACK                      I3C_CFGR_HJACK_Msk                      /*!< Hot Join Acknowledgment */
#define I3C_CFGR_HJACK_Msk                  (0x1UL << I3C_CFGR_HJACK_Pos)           /*!< 0x00000080 */
#define I3C_CFGR_HJACK_Pos                  (7U)
#define I3C_CFGR_HKSDAEN                    I3C_CFGR_HKSDAEN_Msk                    /*!< High-Keeper on SDA Enable */
#define I3C_CFGR_HKSDAEN_Msk                (0x1UL << I3C_CFGR_HKSDAEN_Pos)         /*!< 0x00000020 */
#define I3C_CFGR_HKSDAEN_Pos                (5U)
#define I3C_CFGR_NOARBH                     I3C_CFGR_NOARBH_Msk                     /*!< No Arbitration Header (7'h7E)*/
#define I3C_CFGR_NOARBH_Msk                 (0x1UL << I3C_CFGR_NOARBH_Pos)          /*!< 0x00000004 */
#define I3C_CFGR_NOARBH_Pos                 (2U)
#define I3C_CFGR_RSTPTRN                    I3C_CFGR_RSTPTRN_Msk                    /*!< Reset Pattern enable */
#define I3C_CFGR_RSTPTRN_Msk                (0x1UL << I3C_CFGR_RSTPTRN_Pos)         /*!< 0x00000008 */
#define I3C_CFGR_RSTPTRN_Pos                (3U)
#define I3C_CFGR_RXDMAEN                    I3C_CFGR_RXDMAEN_Msk                    /*!< RX FIFO DMA mode Enable */
#define I3C_CFGR_RXDMAEN_Msk                (0x1UL << I3C_CFGR_RXDMAEN_Pos)         /*!< 0x00000100 */
#define I3C_CFGR_RXDMAEN_Pos                (8U)
#define I3C_CFGR_RXFLUSH                    I3C_CFGR_RXFLUSH_Msk                    /*!< RX FIFO Flush */
#define I3C_CFGR_RXFLUSH_Msk                (0x1UL << I3C_CFGR_RXFLUSH_Pos)         /*!< 0x00000200 */
#define I3C_CFGR_RXFLUSH_Pos                (9U)
#define I3C_CFGR_RXTHRES                    I3C_CFGR_RXTHRES_Msk                    /*!< RX FIFO Threshold */
#define I3C_CFGR_RXTHRES_Msk                (0x1UL << I3C_CFGR_RXTHRES_Pos)         /*!< 0x00000400 */
#define I3C_CFGR_RXTHRES_Pos                (10U)
#define I3C_CFGR_SDMAEN                     I3C_CFGR_SDMAEN_Msk                     /*!< Status FIFO DMA mode Enable */
#define I3C_CFGR_SDMAEN_Msk                 (0x1UL << I3C_CFGR_SDMAEN_Pos)          /*!< 0x00010000 */
#define I3C_CFGR_SDMAEN_Pos                 (16U)
#define I3C_CFGR_SFLUSH                     I3C_CFGR_SFLUSH_Msk                     /*!< Status FIFO Flush */
#define I3C_CFGR_SFLUSH_Msk                 (0x1UL << I3C_CFGR_SFLUSH_Pos)          /*!< 0x00020000 */
#define I3C_CFGR_SFLUSH_Pos                 (17U)
#define I3C_CFGR_SMODE                      I3C_CFGR_SMODE_Msk                      /*!< Status FIFO mode Enable */
#define I3C_CFGR_SMODE_Msk                  (0x1UL << I3C_CFGR_SMODE_Pos)           /*!< 0x00040000 */
#define I3C_CFGR_SMODE_Pos                  (18U)
#define I3C_CFGR_TMODE                      I3C_CFGR_TMODE_Msk                      /*!< Control FIFO mode Enable */
#define I3C_CFGR_TMODE_Msk                  (0x1UL << I3C_CFGR_TMODE_Pos)           /*!< 0x00080000 */
#define I3C_CFGR_TMODE_Pos                  (19U)
#define I3C_CFGR_TSFSET                     I3C_CFGR_TSFSET_Msk                     /*!< Transfer Set */
#define I3C_CFGR_TSFSET_Msk                 (0x1UL << I3C_CFGR_TSFSET_Pos)          /*!< 0x40000000 */
#define I3C_CFGR_TSFSET_Pos                 (30U)
#define I3C_CFGR_TXDMAEN                    I3C_CFGR_TXDMAEN_Msk                    /*!< TX FIFO DMA mode Enable */
#define I3C_CFGR_TXDMAEN_Msk                (0x1UL << I3C_CFGR_TXDMAEN_Pos)         /*!< 0x00001000 */
#define I3C_CFGR_TXDMAEN_Pos                (12U)
#define I3C_CFGR_TXFLUSH                    I3C_CFGR_TXFLUSH_Msk                    /*!< TX FIFO Flush */
#define I3C_CFGR_TXFLUSH_Msk                (0x1UL << I3C_CFGR_TXFLUSH_Pos)         /*!< 0x00002000 */
#define I3C_CFGR_TXFLUSH_Pos                (13U)
#define I3C_CFGR_TXTHRES                    I3C_CFGR_TXTHRES_Msk                    /*!< TX FIFO Threshold */
#define I3C_CFGR_TXTHRES_Msk                (0x1UL << I3C_CFGR_TXTHRES_Pos)         /*!< 0x00004000 */
#define I3C_CFGR_TXTHRES_Pos                (14U)
#define I3C_CRCAPR_CAPDHOFF                 I3C_CRCAPR_CAPDHOFF_Msk                 /*!< Controller-role handoff needed */
#define I3C_CRCAPR_CAPDHOFF_Msk             (0x1UL << I3C_CRCAPR_CAPDHOFF_Pos)      /*!< 0x00000008 */
#define I3C_CRCAPR_CAPDHOFF_Pos             (3U)
#define I3C_CRCAPR_CAPGRP                   I3C_CRCAPR_CAPGRP_Msk                   /*!< Group Address handoff supported */
#define I3C_CRCAPR_CAPGRP_Msk               (0x1UL << I3C_CRCAPR_CAPGRP_Pos)        /*!< 0x00000200 */
#define I3C_CRCAPR_CAPGRP_Pos               (9U)
#define I3C_CR_ADD                          I3C_CR_ADD_Msk                          /*!< Target Address */
#define I3C_CR_ADD_Msk                      (0x7FUL << I3C_CR_ADD_Pos)              /*!< 0x00FE0000 */
#define I3C_CR_ADD_Pos                      (17U)
#define I3C_CR_CCC                          I3C_CR_CCC_Msk                          /*!< 8-Bit CCC code */
#define I3C_CR_CCC_Msk                      (0xFFUL << I3C_CR_CCC_Pos)              /*!< 0x00FF0000 */
#define I3C_CR_CCC_Pos                      (16U)
#define I3C_CR_DCNT                         I3C_CR_DCNT_Msk                         /*!< Data Byte Count */
#define I3C_CR_DCNT_Msk                     (0xFFFFUL << I3C_CR_DCNT_Pos)           /*!< 0x0000FFFF */
#define I3C_CR_DCNT_Pos                     (0U)
#define I3C_CR_MEND                         I3C_CR_MEND_Msk                         /*!< Message End */
#define I3C_CR_MEND_Msk                     (0x1UL << I3C_CR_MEND_Pos)              /*!< 0x80000000 */
#define I3C_CR_MEND_Pos                     (31U)
#define I3C_CR_MTYPE                        I3C_CR_MTYPE_Msk                        /*!< Message Type */
#define I3C_CR_MTYPE_0                      (0x1UL << I3C_CR_MTYPE_Pos)             /*!< 0x08000000 */
#define I3C_CR_MTYPE_1                      (0x2UL << I3C_CR_MTYPE_Pos)             /*!< 0x10000000 */
#define I3C_CR_MTYPE_2                      (0x4UL << I3C_CR_MTYPE_Pos)             /*!< 0x20000000 */
#define I3C_CR_MTYPE_3                      (0x8UL << I3C_CR_MTYPE_Pos)             /*!< 0x40000000 */
#define I3C_CR_MTYPE_Msk                    (0xFUL << I3C_CR_MTYPE_Pos)             /*!< 0xF8000000 */
#define I3C_CR_MTYPE_Pos                    (27U)
#define I3C_CR_RNW                          I3C_CR_RNW_Msk                          /*!< Read Not Write */
#define I3C_CR_RNW_Msk                      (0x1UL << I3C_CR_RNW_Pos)               /*!< 0x00010000 */
#define I3C_CR_RNW_Pos                      (16U)
#define I3C_DCR_DCR                         I3C_DCR_DCR_Msk                         /*!< Devices Characteristics */
#define I3C_DCR_DCR_Msk                     (0xFFUL << I3C_DCR_DCR_Pos)             /*!< 0x000000FF */
#define I3C_DCR_DCR_Pos                     (0U)
#define I3C_DEVR0_AS                        I3C_DEVR0_AS_Msk                        /*!< Activity State value update after ENTAx received */
#define I3C_DEVR0_AS_0                      (0x1UL << I3C_DEVR0_AS_Pos)             /*!< 0x00100000 */
#define I3C_DEVR0_AS_1                      (0x2UL << I3C_DEVR0_AS_Pos)             /*!< 0x00200000 */
#define I3C_DEVR0_AS_Msk                    (0x3UL << I3C_DEVR0_AS_Pos)             /*!< 0x00300000 */
#define I3C_DEVR0_AS_Pos                    (20U)
#define I3C_DEVR0_CREN                      I3C_DEVR0_CREN_Msk                      /*!< Controller-role Enable */
#define I3C_DEVR0_CREN_Msk                  (0x1UL << I3C_DEVR0_CREN_Pos)           /*!< 0x00020000 */
#define I3C_DEVR0_CREN_Pos                  (17U)
#define I3C_DEVR0_DA                        I3C_DEVR0_DA_Msk                        /*!< Own Target Device Address */
#define I3C_DEVR0_DAVAL                     I3C_DEVR0_DAVAL_Msk                     /*!< Dynamic Address Validity */
#define I3C_DEVR0_DAVAL_Msk                 (0x1UL << I3C_DEVR0_DAVAL_Pos)          /*!< 0x00000001 */
#define I3C_DEVR0_DAVAL_Pos                 (0U)
#define I3C_DEVR0_DA_Msk                    (0x7FUL << I3C_DEVR0_DA_Pos)            /*!< 0x000000FE */
#define I3C_DEVR0_DA_Pos                    (1U)
#define I3C_DEVR0_HJEN                      I3C_DEVR0_HJEN_Msk                      /*!< Hot Join Enable */
#define I3C_DEVR0_HJEN_Msk                  (0x1UL << I3C_DEVR0_HJEN_Pos)           /*!< 0x00080000 */
#define I3C_DEVR0_HJEN_Pos                  (19U)
#define I3C_DEVR0_IBIEN                     I3C_DEVR0_IBIEN_Msk                     /*!< IBI Enable */
#define I3C_DEVR0_IBIEN_Msk                 (0x1UL << I3C_DEVR0_IBIEN_Pos)          /*!< 0x00010000 */
#define I3C_DEVR0_IBIEN_Pos                 (16U)
#define I3C_DEVR0_RSTACT                    I3C_DEVR0_RSTACT_Msk                    /*!< Reset Action value update after RSTACT received */
#define I3C_DEVR0_RSTACT_0                  (0x1UL << I3C_DEVR0_RSTACT_Pos)         /*!< 0x00400000 */
#define I3C_DEVR0_RSTACT_1                  (0x2UL << I3C_DEVR0_RSTACT_Pos)         /*!< 0x00800000 */
#define I3C_DEVR0_RSTACT_Msk                (0x3UL << I3C_DEVR0_RSTACT_Pos)         /*!< 0x00C000000 */
#define I3C_DEVR0_RSTACT_Pos                (22U)
#define I3C_DEVR0_RSTVAL                    I3C_DEVR0_RSTVAL_Msk                    /*!< Reset Action Valid */
#define I3C_DEVR0_RSTVAL_Msk                (0x1UL << I3C_DEVR0_RSTVAL_Pos)         /*!< 0x01000000 */
#define I3C_DEVR0_RSTVAL_Pos                (24U)
#define I3C_DEVRX_CRACK                     I3C_DEVRX_CRACK_Msk                     /*!< Controller-role Acknowledge from Target x */
#define I3C_DEVRX_CRACK_Msk                 (0x1UL << I3C_DEVRX_CRACK_Pos)          /*!< 0x00020000 */
#define I3C_DEVRX_CRACK_Pos                 (17U)
#define I3C_DEVRX_DA                        I3C_DEVRX_DA_Msk                        /*!< Dynamic Address Target x */
#define I3C_DEVRX_DA_Msk                    (0x7FUL << I3C_DEVRX_DA_Pos)            /*!< 0x000000FE */
#define I3C_DEVRX_DA_Pos                    (1U)
#define I3C_DEVRX_DIS                       I3C_DEVRX_DIS_Msk                       /*!< Disable Register access */
#define I3C_DEVRX_DIS_Msk                   (0x1UL << I3C_DEVRX_DIS_Pos)            /*!< 0x80000000 */
#define I3C_DEVRX_DIS_Pos                   (31U)
#define I3C_DEVRX_IBIACK                    I3C_DEVRX_IBIACK_Msk                    /*!< IBI Acknowledge from Target x */
#define I3C_DEVRX_IBIACK_Msk                (0x1UL << I3C_DEVRX_IBIACK_Pos)         /*!< 0x00010000 */
#define I3C_DEVRX_IBIACK_Pos                (16U)
#define I3C_DEVRX_IBIDEN                    I3C_DEVRX_IBIDEN_Msk                    /*!< IBI Additional Data Enable */
#define I3C_DEVRX_IBIDEN_Msk                (0x1UL << I3C_DEVRX_IBIDEN_Pos)         /*!< 0x00040000 */
#define I3C_DEVRX_IBIDEN_Pos                (18U)
#define I3C_DEVRX_SUSP                      I3C_DEVRX_SUSP_Msk                      /*!< Suspended Transfer */
#define I3C_DEVRX_SUSP_Msk                  (0x1UL << I3C_DEVRX_SUSP_Pos)           /*!< 0x00080000 */
#define I3C_DEVRX_SUSP_Pos                  (19U)
#define I3C_EPIDR_IDTSEL                    I3C_EPIDR_IDTSEL_Msk                    /*!< ID Type Selector */
#define I3C_EPIDR_IDTSEL_Msk                (0x1UL << I3C_EPIDR_IDTSEL_Pos)         /*!< 0x00010000 */
#define I3C_EPIDR_IDTSEL_Pos                (16U)
#define I3C_EPIDR_MIPIID                    I3C_EPIDR_MIPIID_Msk                    /*!< MIPI Instance ID */
#define I3C_EPIDR_MIPIID_Msk                (0xFUL << I3C_EPIDR_MIPIID_Pos)         /*!< 0x0000F000 */
#define I3C_EPIDR_MIPIID_Pos                (12U)
#define I3C_EPIDR_MIPIMID                   I3C_EPIDR_MIPIMID_Msk                   /*!< MIPI Manufacturer ID */
#define I3C_EPIDR_MIPIMID_Msk               (0x7FFFUL << I3C_EPIDR_MIPIMID_Pos)     /*!< 0xFFFE0000 */
#define I3C_EPIDR_MIPIMID_Pos               (17U)
#define I3C_EVR_ASUPDF                      I3C_EVR_ASUPDF_Msk                      /*!< Activity State Flag */
#define I3C_EVR_ASUPDF_Msk                  (0x1UL << I3C_EVR_ASUPDF_Pos)           /*!< 0x10000000 */
#define I3C_EVR_ASUPDF_Pos                  (28U)
#define I3C_EVR_CFEF                        I3C_EVR_CFEF_Msk                        /*!< Control FIFO Empty Flag */
#define I3C_EVR_CFEF_Msk                    (0x1UL << I3C_EVR_CFEF_Pos)             /*!< 0x00000001 */
#define I3C_EVR_CFEF_Pos                    (0U)
#define I3C_EVR_CFNFF                       I3C_EVR_CFNFF_Msk                       /*!< Control FIFO Not Full Flag */
#define I3C_EVR_CFNFF_Msk                   (0x1UL << I3C_EVR_CFNFF_Pos)            /*!< 0x00000004 */
#define I3C_EVR_CFNFF_Pos                   (2U)
#define I3C_EVR_CRF                         I3C_EVR_CRF_Msk                         /*!< Controller-role Request Flag */
#define I3C_EVR_CRF_Msk                     (0x1UL << I3C_EVR_CRF_Pos)              /*!< 0x00020000 */
#define I3C_EVR_CRF_Pos                     (17U)
#define I3C_EVR_CRUPDF                      I3C_EVR_CRUPDF_Msk                      /*!< Controller-role Update Flag */
#define I3C_EVR_CRUPDF_Msk                  (0x1UL << I3C_EVR_CRUPDF_Pos)           /*!< 0x00040000 */
#define I3C_EVR_CRUPDF_Pos                  (18U)
#define I3C_EVR_DAUPDF                      I3C_EVR_DAUPDF_Msk                      /*!< Dynamic Address Update Flag */
#define I3C_EVR_DAUPDF_Msk                  (0x1UL << I3C_EVR_DAUPDF_Pos)           /*!< 0x01000000 */
#define I3C_EVR_DAUPDF_Pos                  (24U)
#define I3C_EVR_DEFF                        I3C_EVR_DEFF_Msk                        /*!< List of Targets Command Received Flag */
#define I3C_EVR_DEFF_Msk                    (0x1UL << I3C_EVR_DEFF_Pos)             /*!< 0x40000000 */
#define I3C_EVR_DEFF_Pos                    (30U)
#define I3C_EVR_ERRF                        I3C_EVR_ERRF_Msk                        /*!< Error Flag */
#define I3C_EVR_ERRF_Msk                    (0x1UL << I3C_EVR_ERRF_Pos)             /*!< 0x00000800 */
#define I3C_EVR_ERRF_Pos                    (11U)
#define I3C_EVR_FCF                         I3C_EVR_FCF_Msk                         /*!< Frame Complete Flag */
#define I3C_EVR_FCF_Msk                     (0x1UL << I3C_EVR_FCF_Pos)              /*!< 0x00000200 */
#define I3C_EVR_FCF_Pos                     (9U)
#define I3C_EVR_GETF                        I3C_EVR_GETF_Msk                        /*!< Get type CCC received Flag */
#define I3C_EVR_GETF_Msk                    (0x1UL << I3C_EVR_GETF_Pos)             /*!< 0x00400000 */
#define I3C_EVR_GETF_Pos                    (22U)
#define I3C_EVR_GRPF                        I3C_EVR_GRPF_Msk                        /*!< List of Group Addresses Command Received Flag */
#define I3C_EVR_GRPF_Msk                    (0x1UL << I3C_EVR_GRPF_Pos)             /*!< 0x80000000 */
#define I3C_EVR_GRPF_Pos                    (31U)
#define I3C_EVR_HJF                         I3C_EVR_HJF_Msk                         /*!< Hot Join Flag */
#define I3C_EVR_HJF_Msk                     (0x1UL << I3C_EVR_HJF_Pos)              /*!< 0x00080000 */
#define I3C_EVR_HJF_Pos                     (19U)
#define I3C_EVR_IBIENDF                     I3C_EVR_IBIENDF_Msk                     /*!< IBI End Flag */
#define I3C_EVR_IBIENDF_Msk                 (0x1UL << I3C_EVR_IBIENDF_Pos)          /*!< 0x00010000 */
#define I3C_EVR_IBIENDF_Pos                 (16U)
#define I3C_EVR_IBIF                        I3C_EVR_IBIF_Msk                        /*!< IBI Flag */
#define I3C_EVR_IBIF_Msk                    (0x1UL << I3C_EVR_IBIF_Pos)             /*!< 0x00008000 */
#define I3C_EVR_IBIF_Pos                    (15U)
#define I3C_EVR_INTUPDF                     I3C_EVR_INTUPDF_Msk                     /*!< Interrupt Update Flag */
#define I3C_EVR_INTUPDF_Msk                 (0x1UL << I3C_EVR_INTUPDF_Pos)          /*!< 0x20000000 */
#define I3C_EVR_INTUPDF_Pos                 (29U)
#define I3C_EVR_MRLUPDF                     I3C_EVR_MRLUPDF_Msk                     /*!< Max Read Length Update Flag */
#define I3C_EVR_MRLUPDF_Msk                 (0x1UL << I3C_EVR_MRLUPDF_Pos)          /*!< 0x04000000 */
#define I3C_EVR_MRLUPDF_Pos                 (26U)
#define I3C_EVR_MWLUPDF                     I3C_EVR_MWLUPDF_Msk                     /*!< Max Write Length Update Flag */
#define I3C_EVR_MWLUPDF_Msk                 (0x1UL << I3C_EVR_MWLUPDF_Pos)          /*!< 0x02000000 */
#define I3C_EVR_MWLUPDF_Pos                 (25U)
#define I3C_EVR_RSTF                        I3C_EVR_RSTF_Msk                        /*!< Reset Flag, due to Reset pattern received */
#define I3C_EVR_RSTF_Msk                    (0x1UL << I3C_EVR_RSTF_Pos)             /*!< 0x08000000 */
#define I3C_EVR_RSTF_Pos                    (27U)
#define I3C_EVR_RXFNEF                      I3C_EVR_RXFNEF_Msk                      /*!< RX FIFO Not Empty Flag */
#define I3C_EVR_RXFNEF_Msk                  (0x1UL << I3C_EVR_RXFNEF_Pos)           /*!< 0x00000020 */
#define I3C_EVR_RXFNEF_Pos                  (5U)
#define I3C_EVR_RXLASTF                     I3C_EVR_RXLASTF_Msk                     /*!< Last RX byte read from FIFO */
#define I3C_EVR_RXLASTF_Msk                 (0x1UL << I3C_EVR_RXLASTF_Pos)          /*!< 0x00000080 */
#define I3C_EVR_RXLASTF_Pos                 (7U)
#define I3C_EVR_RXTGTENDF                   I3C_EVR_RXTGTENDF_Msk                   /*!< Reception Target End Flag */
#define I3C_EVR_RXTGTENDF_Msk               (0x1UL << I3C_EVR_RXTGTENDF_Pos)        /*!< 0x00000400 */
#define I3C_EVR_RXTGTENDF_Pos               (10U)
#define I3C_EVR_SFNEF                       I3C_EVR_SFNEF_Msk                       /*!< Status FIFO Not Empty Flag */
#define I3C_EVR_SFNEF_Msk                   (0x1UL << I3C_EVR_SFNEF_Pos)            /*!< 0x00000008 */
#define I3C_EVR_SFNEF_Pos                   (3U)
#define I3C_EVR_STAF                        I3C_EVR_STAF_Msk                        /*!< Get Status Flag */
#define I3C_EVR_STAF_Msk                    (0x1UL << I3C_EVR_STAF_Pos)             /*!< 0x00800000 */
#define I3C_EVR_STAF_Pos                    (23U)
#define I3C_EVR_TXFEF                       I3C_EVR_TXFEF_Msk                       /*!< TX FIFO Empty Flag */
#define I3C_EVR_TXFEF_Msk                   (0x1UL << I3C_EVR_TXFEF_Pos)            /*!< 0x00000002 */
#define I3C_EVR_TXFEF_Pos                   (1U)
#define I3C_EVR_TXFNFF                      I3C_EVR_TXFNFF_Msk                      /*!< TX FIFO Not Full Flag */
#define I3C_EVR_TXFNFF_Msk                  (0x1UL << I3C_EVR_TXFNFF_Pos)           /*!< 0x00000010 */
#define I3C_EVR_TXFNFF_Pos                  (4U)
#define I3C_EVR_TXLASTF                     I3C_EVR_TXLASTF_Msk                     /*!< Last TX byte available in FIFO */
#define I3C_EVR_TXLASTF_Msk                 (0x1UL << I3C_EVR_TXLASTF_Pos)          /*!< 0x00000040 */
#define I3C_EVR_TXLASTF_Pos                 (6U)
#define I3C_EVR_WKPF                        I3C_EVR_WKPF_Msk                        /*!< Wake Up Flag */
#define I3C_EVR_WKPF_Msk                    (0x1UL << I3C_EVR_WKPF_Pos)             /*!< 0x00200000 */
#define I3C_EVR_WKPF_Pos                    (21U)
#define I3C_GETCAPR_CAPPEND                 I3C_GETCAPR_CAPPEND_Msk                 /*!< IBI Request with Mandatory Data Byte */
#define I3C_GETCAPR_CAPPEND_Msk             (0x1UL << I3C_GETCAPR_CAPPEND_Pos)      /*!< 0x00004000 */
#define I3C_GETCAPR_CAPPEND_Pos             (14U)
#define I3C_GETMXDSR_FMT                    I3C_GETMXDSR_FMT_Msk                    /*!< Get Max Data Speed response in format 2 */
#define I3C_GETMXDSR_FMT_0                  (0x1UL << I3C_GETMXDSR_FMT_Pos)         /*!< 0x00000100 */
#define I3C_GETMXDSR_FMT_1                  (0x2UL << I3C_GETMXDSR_FMT_Pos)         /*!< 0x00000200 */
#define I3C_GETMXDSR_FMT_Msk                (0x3UL << I3C_GETMXDSR_FMT_Pos)         /*!< 0x00000300 */
#define I3C_GETMXDSR_FMT_Pos                (8U)
#define I3C_GETMXDSR_HOFFAS                 I3C_GETMXDSR_HOFFAS_Msk                 /*!< Handoff Activity State */
#define I3C_GETMXDSR_HOFFAS_0               (0x1UL << I3C_GETMXDSR_HOFFAS_Pos)      /*!< 0x00000001 */
#define I3C_GETMXDSR_HOFFAS_1               (0x2UL << I3C_GETMXDSR_HOFFAS_Pos)      /*!< 0x00000002 */
#define I3C_GETMXDSR_HOFFAS_Msk             (0x3UL << I3C_GETMXDSR_HOFFAS_Pos)      /*!< 0x00000003 */
#define I3C_GETMXDSR_HOFFAS_Pos             (0U)
#define I3C_GETMXDSR_RDTURN                 I3C_GETMXDSR_RDTURN_Msk                 /*!< Max Read Turnaround Middle Byte  */
#define I3C_GETMXDSR_RDTURN_Msk             (0xFFUL << I3C_GETMXDSR_RDTURN_Pos)     /*!< 0x00FF0000 */
#define I3C_GETMXDSR_RDTURN_Pos             (16U)
#define I3C_GETMXDSR_TSCO                   I3C_GETMXDSR_TSCO_Msk                   /*!< Clock-to-data Turnaround time */
#define I3C_GETMXDSR_TSCO_Msk               (0x1UL << I3C_GETMXDSR_TSCO_Pos)        /*!< 0x01000000 */
#define I3C_GETMXDSR_TSCO_Pos               (24U)
#define I3C_IER_ASUPDIE                     I3C_IER_ASUPDIE_Msk                     /*!< Activity State Interrupt Enable */
#define I3C_IER_ASUPDIE_Msk                 (0x1UL << I3C_IER_ASUPDIE_Pos)          /*!< 0x10000000 */
#define I3C_IER_ASUPDIE_Pos                 (28U)
#define I3C_IER_CFNFIE                      I3C_IER_CFNFIE_Msk                      /*!< Control FIFO Not Full Interrupt Enable */
#define I3C_IER_CFNFIE_Msk                  (0x1UL << I3C_IER_CFNFIE_Pos)           /*!< 0x00000004 */
#define I3C_IER_CFNFIE_Pos                  (2U)
#define I3C_IER_CRIE                        I3C_IER_CRIE_Msk                        /*!< Controller-role Interrupt Enable */
#define I3C_IER_CRIE_Msk                    (0x1UL << I3C_IER_CRIE_Pos)             /*!< 0x00020000 */
#define I3C_IER_CRIE_Pos                    (17U)
#define I3C_IER_CRUPDIE                     I3C_IER_CRUPDIE_Msk                     /*!< Controller-role Update Interrupt Enable */
#define I3C_IER_CRUPDIE_Msk                 (0x1UL << I3C_IER_CRUPDIE_Pos)          /*!< 0x00040000 */
#define I3C_IER_CRUPDIE_Pos                 (18U)
#define I3C_IER_DAUPDIE                     I3C_IER_DAUPDIE_Msk                     /*!< Dynamic Address Update Interrupt Enable */
#define I3C_IER_DAUPDIE_Msk                 (0x1UL << I3C_IER_DAUPDIE_Pos)          /*!< 0x01000000 */
#define I3C_IER_DAUPDIE_Pos                 (24U)
#define I3C_IER_DEFIE                       I3C_IER_DEFIE_Msk                       /*!< List of Targets Command Received Interrupt Enable */
#define I3C_IER_DEFIE_Msk                   (0x1UL << I3C_IER_DEFIE_Pos)            /*!< 0x40000000 */
#define I3C_IER_DEFIE_Pos                   (30U)
#define I3C_IER_ERRIE                       I3C_IER_ERRIE_Msk                       /*!< Error Interrupt Enable */
#define I3C_IER_ERRIE_Msk                   (0x1UL << I3C_IER_ERRIE_Pos)            /*!< 0x00000800 */
#define I3C_IER_ERRIE_Pos                   (11U)
#define I3C_IER_FCIE                        I3C_IER_FCIE_Msk                        /*!< Frame Complete Interrupt Enable */
#define I3C_IER_FCIE_Msk                    (0x1UL << I3C_IER_FCIE_Pos)             /*!< 0x00000200 */
#define I3C_IER_FCIE_Pos                    (9U)
#define I3C_IER_GETIE                       I3C_IER_GETIE_Msk                       /*!< Get type CCC received Interrupt Enable */
#define I3C_IER_GETIE_Msk                   (0x1UL << I3C_IER_GETIE_Pos)            /*!< 0x00400000 */
#define I3C_IER_GETIE_Pos                   (22U)
#define I3C_IER_GRPIE                       I3C_IER_GRPIE_Msk                       /*!< List of Group Addresses Command Received Interrupt Enable */
#define I3C_IER_GRPIE_Msk                   (0x1UL << I3C_IER_GRPIE_Pos)            /*!< 0x80000000 */
#define I3C_IER_GRPIE_Pos                   (31U)
#define I3C_IER_HJIE                        I3C_IER_HJIE_Msk                        /*!< Hot Join Interrupt Enable */
#define I3C_IER_HJIE_Msk                    (0x1UL << I3C_IER_HJIE_Pos)             /*!< 0x00080000 */
#define I3C_IER_HJIE_Pos                    (19U)
#define I3C_IER_IBIENDIE                    I3C_IER_IBIENDIE_Msk                    /*!< IBI End Interrupt Enable */
#define I3C_IER_IBIENDIE_Msk                (0x1UL << I3C_IER_IBIENDIE_Pos)         /*!< 0x00010000 */
#define I3C_IER_IBIENDIE_Pos                (16U)
#define I3C_IER_IBIIE                       I3C_IER_IBIIE_Msk                       /*!< IBI Interrupt Enable */
#define I3C_IER_IBIIE_Msk                   (0x1UL << I3C_IER_IBIIE_Pos)            /*!< 0x00008000 */
#define I3C_IER_IBIIE_Pos                   (15U)
#define I3C_IER_INTUPDIE                    I3C_IER_INTUPDIE_Msk                    /*!< Interrupt Update Interrupt Enable */
#define I3C_IER_INTUPDIE_Msk                (0x1UL << I3C_IER_INTUPDIE_Pos)         /*!< 0x20000000 */
#define I3C_IER_INTUPDIE_Pos                (29U)
#define I3C_IER_MRLUPDIE                    I3C_IER_MRLUPDIE_Msk                    /*!< Max Read Length Update Interrupt Enable */
#define I3C_IER_MRLUPDIE_Msk                (0x1UL << I3C_IER_MRLUPDIE_Pos)         /*!< 0x04000000 */
#define I3C_IER_MRLUPDIE_Pos                (26U)
#define I3C_IER_MWLUPDIE                    I3C_IER_MWLUPDIE_Msk                    /*!< Max Write Length Update Interrupt Enable */
#define I3C_IER_MWLUPDIE_Msk                (0x1UL << I3C_IER_MWLUPDIE_Pos)         /*!< 0x02000000 */
#define I3C_IER_MWLUPDIE_Pos                (25U)
#define I3C_IER_RSTIE                       I3C_IER_RSTIE_Msk                       /*!< Reset Interrupt Enabled, due to Reset pattern received */
#define I3C_IER_RSTIE_Msk                   (0x1UL << I3C_IER_RSTIE_Pos)            /*!< 0x08000000 */
#define I3C_IER_RSTIE_Pos                   (27U)
#define I3C_IER_RXFNEIE                     I3C_IER_RXFNEIE_Msk                     /*!< RX FIFO Not Empty Interrupt Enable */
#define I3C_IER_RXFNEIE_Msk                 (0x1UL << I3C_IER_RXFNEIE_Pos)          /*!< 0x00000020 */
#define I3C_IER_RXFNEIE_Pos                 (5U)
#define I3C_IER_RXTGTENDIE                  I3C_IER_RXTGTENDIE_Msk                  /*!< Reception Target End Interrupt Enable */
#define I3C_IER_RXTGTENDIE_Msk              (0x1UL << I3C_IER_RXTGTENDIE_Pos)       /*!< 0x00000400 */
#define I3C_IER_RXTGTENDIE_Pos              (10U)
#define I3C_IER_SFNEIE                      I3C_IER_SFNEIE_Msk                      /*!< Status FIFO Not Empty Interrupt Enable */
#define I3C_IER_SFNEIE_Msk                  (0x1UL << I3C_IER_SFNEIE_Pos)           /*!< 0x00000008 */
#define I3C_IER_SFNEIE_Pos                  (3U)
#define I3C_IER_STAIE                       I3C_IER_STAIE_Msk                       /*!< Get Status Interrupt Enable */
#define I3C_IER_STAIE_Msk                   (0x1UL << I3C_IER_STAIE_Pos)            /*!< 0x00800000 */
#define I3C_IER_STAIE_Pos                   (23U)
#define I3C_IER_TXFNFIE                     I3C_IER_TXFNFIE_Msk                     /*!< TX FIFO Not Full Interrupt Enable */
#define I3C_IER_TXFNFIE_Msk                 (0x1UL << I3C_IER_TXFNFIE_Pos)          /*!< 0x00000010 */
#define I3C_IER_TXFNFIE_Pos                 (4U)
#define I3C_IER_WKPIE                       I3C_IER_WKPIE_Msk                       /*!< Wake Up Interrupt Enable */
#define I3C_IER_WKPIE_Msk                   (0x1UL << I3C_IER_WKPIE_Pos)            /*!< 0x00200000 */
#define I3C_IER_WKPIE_Pos                   (21U)
#define I3C_MAXRLR_IBIP                     I3C_MAXRLR_IBIP_Msk                     /*!< IBI Payload size */
#define I3C_MAXRLR_IBIP_0                   (0x1UL << I3C_MAXRLR_IBIP_Pos)          /*!< 0x00010000 */
#define I3C_MAXRLR_IBIP_1                   (0x2UL << I3C_MAXRLR_IBIP_Pos)          /*!< 0x00020000 */
#define I3C_MAXRLR_IBIP_2                   (0x4UL << I3C_MAXRLR_IBIP_Pos)          /*!< 0x00040000 */
#define I3C_MAXRLR_IBIP_Msk                 (0x7UL << I3C_MAXRLR_IBIP_Pos)          /*!< 0x00070000 */
#define I3C_MAXRLR_IBIP_Pos                 (16U)
#define I3C_MAXRLR_MRL                      I3C_MAXRLR_MRL_Msk                      /*!< Maximum Read Length */
#define I3C_MAXRLR_MRL_Msk                  (0xFFFFUL << I3C_MAXRLR_MRL_Pos)        /*!< 0x0000FFFF */
#define I3C_MAXRLR_MRL_Pos                  (0U)
#define I3C_MAXWLR_MWL                      I3C_MAXWLR_MWL_Msk                      /*!< Maximum Write Length */
#define I3C_MAXWLR_MWL_Msk                  (0xFFFFUL << I3C_MAXWLR_MWL_Pos)        /*!< 0x0000FFFF */
#define I3C_MAXWLR_MWL_Pos                  (0U)
#define I3C_RDR_RDB0                        I3C_RDR_RDB0_Msk                        /*!< Receive Data Byte */
#define I3C_RDR_RDB0_Msk                    (0xFFUL << I3C_RDR_RDB0_Pos)            /*!< 0x000000FF */
#define I3C_RDR_RDB0_Pos                    (0U)
#define I3C_RMR_IBIRDCNT                    I3C_RMR_IBIRDCNT_Msk                    /*!< Data Count when reading IBI data */
#define I3C_RMR_IBIRDCNT_Msk                (0x7UL << I3C_RMR_IBIRDCNT_Pos)         /*!< 0x00000007 */
#define I3C_RMR_IBIRDCNT_Pos                (0U)
#define I3C_RMR_RADD                        I3C_RMR_RADD_Msk                        /*!< Target Address Received during accepted IBI or Controller-role request */
#define I3C_RMR_RADD_Msk                    (0x7FUL << I3C_RMR_RADD_Pos)            /*!< 0x00FE0000 */
#define I3C_RMR_RADD_Pos                    (17U)
#define I3C_RMR_RCODE                       I3C_RMR_RCODE_Msk                       /*!< CCC code of received command */
#define I3C_RMR_RCODE_Msk                   (0xFFUL << I3C_RMR_RCODE_Pos)           /*!< 0x0000FF00 */
#define I3C_RMR_RCODE_Pos                   (8U)
#define I3C_SER_ANACK                       I3C_SER_ANACK_Msk                       /*!< Address Not Acknowledged */
#define I3C_SER_ANACK_Msk                   (0x1UL << I3C_SER_ANACK_Pos)            /*!< 0x00000100 */
#define I3C_SER_ANACK_Pos                   (8U)
#define I3C_SER_CODERR                      I3C_SER_CODERR_Msk                      /*!< Protocol Error Code */
#define I3C_SER_CODERR_0                    (0x1UL << I3C_SER_CODERR_Pos)           /*!< 0x00000001 */
#define I3C_SER_CODERR_1                    (0x2UL << I3C_SER_CODERR_Pos)           /*!< 0x00000002 */
#define I3C_SER_CODERR_2                    (0x4UL << I3C_SER_CODERR_Pos)           /*!< 0x00000004 */
#define I3C_SER_CODERR_3                    (0x8UL << I3C_SER_CODERR_Pos)           /*!< 0x00000008 */
#define I3C_SER_CODERR_Msk                  (0xFUL << I3C_SER_CODERR_Pos)           /*!< 0x0000000F */
#define I3C_SER_CODERR_Pos                  (0U)
#define I3C_SER_COVR                        I3C_SER_COVR_Msk                        /*!< Status/Control FIFO Overrun */
#define I3C_SER_COVR_Msk                    (0x1UL << I3C_SER_COVR_Pos)             /*!< 0x00000080 */
#define I3C_SER_COVR_Pos                    (7U)
#define I3C_SER_DERR                        I3C_SER_DERR_Msk                        /*!< Data Error during the controller-role hand-off procedure */
#define I3C_SER_DERR_Msk                    (0x1UL << I3C_SER_DERR_Pos)             /*!< 0x00000400 */
#define I3C_SER_DERR_Pos                    (10U)
#define I3C_SER_DNACK                       I3C_SER_DNACK_Msk                       /*!< Data Not Acknowledged */
#define I3C_SER_DNACK_Msk                   (0x1UL << I3C_SER_DNACK_Pos)            /*!< 0x00000200 */
#define I3C_SER_DNACK_Pos                   (9U)
#define I3C_SER_DOVR                        I3C_SER_DOVR_Msk                        /*!< RX/TX FIFO Overrun */
#define I3C_SER_DOVR_Msk                    (0x1UL << I3C_SER_DOVR_Pos)             /*!< 0x00000040 */
#define I3C_SER_DOVR_Pos                    (6U)
#define I3C_SER_PERR                        I3C_SER_PERR_Msk                        /*!< Protocol Error */
#define I3C_SER_PERR_Msk                    (0x1UL << I3C_SER_PERR_Pos)             /*!< 0x00000010 */
#define I3C_SER_PERR_Pos                    (4U)
#define I3C_SER_STALL                       I3C_SER_STALL_Msk                       /*!< SCL Stall Error */
#define I3C_SER_STALL_Msk                   (0x1UL << I3C_SER_STALL_Pos)            /*!< 0x00000020 */
#define I3C_SER_STALL_Pos                   (5U)
#define I3C_SR_ABT                          I3C_SR_ABT_Msk                          /*!< Target Abort Indication */
#define I3C_SR_ABT_Msk                      (0x1UL << I3C_SR_ABT_Pos)               /*!< 0x00020000 */
#define I3C_SR_ABT_Pos                      (17U)
#define I3C_SR_DIR                          I3C_SR_DIR_Msk                          /*!< Message Direction */
#define I3C_SR_DIR_Msk                      (0x1UL << I3C_SR_DIR_Pos)               /*!< 0x00040000 */
#define I3C_SR_DIR_Pos                      (18U)
#define I3C_SR_MID                          I3C_SR_MID_Msk                          /*!< Message Identifier */
#define I3C_SR_MID_Msk                      (0xFFUL << I3C_SR_MID_Pos)              /*!< 0xFF000000 */
#define I3C_SR_MID_Pos                      (24U)
#define I3C_SR_XDCNT                        I3C_SR_XDCNT_Msk                        /*!< Transfer Data Byte Count status */
#define I3C_SR_XDCNT_Msk                    (0xFFFFUL << I3C_SR_XDCNT_Pos)          /*!< 0x0000FFFF */
#define I3C_SR_XDCNT_Pos                    (0U)
#define I3C_TGTTDR_PRELOAD                  I3C_TGTTDR_PRELOAD_Msk                  /*!< Transmit FIFO Preload Enable/Status */
#define I3C_TGTTDR_PRELOAD_Msk              (0x1UL << I3C_TGTTDR_PRELOAD_Pos)       /*!< 0x00010000 */
#define I3C_TGTTDR_PRELOAD_Pos              (16U)
#define I3C_TGTTDR_TGTTDCNT                 I3C_TGTTDR_TGTTDCNT_Msk                 /*!< Target Transmit Data Counter */
#define I3C_TGTTDR_TGTTDCNT_Msk             (0xFFFFUL << I3C_TGTTDR_TGTTDCNT_Pos)   /*!< 0x0000FFFF */
#define I3C_TGTTDR_TGTTDCNT_Pos             (0U)
#define I3C_TIMINGR0_SCLH_I2C               I3C_TIMINGR0_SCLH_I2C_Msk               /*!< SCL High duration during I2C transfer */
#define I3C_TIMINGR0_SCLH_I2C_Msk           (0xFFUL << I3C_TIMINGR0_SCLH_I2C_Pos)   /*!< 0xFF000000 */
#define I3C_TIMINGR0_SCLH_I2C_Pos           (24U)
#define I3C_TIMINGR0_SCLH_I3C               I3C_TIMINGR0_SCLH_I3C_Msk               /*!< SCL High duration during I3C Open-drain and Push-Pull phases */
#define I3C_TIMINGR0_SCLH_I3C_Msk           (0xFFUL << I3C_TIMINGR0_SCLH_I3C_Pos)   /*!< 0x0000FF00 */
#define I3C_TIMINGR0_SCLH_I3C_Pos           (8U)
#define I3C_TIMINGR0_SCLL_OD                I3C_TIMINGR0_SCLL_OD_Msk                /*!< SCL Low duration during  I3C Open-drain phases and I2C transfer */
#define I3C_TIMINGR0_SCLL_OD_Msk            (0xFFUL << I3C_TIMINGR0_SCLL_OD_Pos)    /*!< 0x00FF0000 */
#define I3C_TIMINGR0_SCLL_OD_Pos            (16U)
#define I3C_TIMINGR0_SCLL_PP                I3C_TIMINGR0_SCLL_PP_Msk                /*!< SCL Low duration during I3C Push-Pull phases */
#define I3C_TIMINGR0_SCLL_PP_Msk            (0xFFUL << I3C_TIMINGR0_SCLL_PP_Pos)    /*!< 0x000000FF */
#define I3C_TIMINGR0_SCLL_PP_Pos            (0U)
#define I3C_TIMINGR1_ASNCR                  I3C_TIMINGR1_ASNCR_Msk                  /*!< Activity State of the New Controller */
#define I3C_TIMINGR1_ASNCR_0                (0x1UL << I3C_TIMINGR1_ASNCR_Pos)       /*!< 0x00000100 */
#define I3C_TIMINGR1_ASNCR_1                (0x2UL << I3C_TIMINGR1_ASNCR_Pos)       /*!< 0x00000200 */
#define I3C_TIMINGR1_ASNCR_Msk              (0x3UL << I3C_TIMINGR1_ASNCR_Pos)       /*!< 0x00000300 */
#define I3C_TIMINGR1_ASNCR_Pos              (8U)
#define I3C_TIMINGR1_AVAL                   I3C_TIMINGR1_AVAL_Msk                   /*!< Timing for I3C Bus Idle or Available condition */
#define I3C_TIMINGR1_AVAL_Msk               (0xFFUL << I3C_TIMINGR1_AVAL_Pos)       /*!< 0x000000FF */
#define I3C_TIMINGR1_AVAL_Pos               (0U)
#define I3C_TIMINGR1_FREE                   I3C_TIMINGR1_FREE_Msk                   /*!< Timing for I3C Bus Free condition */
#define I3C_TIMINGR1_FREE_Msk               (0x7FUL << I3C_TIMINGR1_FREE_Pos)       /*!< 0x007F0000 */
#define I3C_TIMINGR1_FREE_Pos               (16U)
#define I3C_TIMINGR1_SDA_HD                 I3C_TIMINGR1_SDA_HD_Msk                 /*!< SDA Hold Duration */
#define I3C_TIMINGR1_SDA_HD_Msk             (0x1UL << I3C_TIMINGR1_SDA_HD_Pos)      /*!< 0x00010000 */
#define I3C_TIMINGR1_SDA_HD_Pos             (28U)
#define I3C_TIMINGR2_STALL                  I3C_TIMINGR2_STALL_Msk                  /*!< Controller Stall duration */
#define I3C_TIMINGR2_STALLA                 I3C_TIMINGR2_STALLA_Msk                 /*!< Stall on ACK bit */
#define I3C_TIMINGR2_STALLA_Msk             (0x1UL << I3C_TIMINGR2_STALLA_Pos)      /*!< 0x00000008 */
#define I3C_TIMINGR2_STALLA_Pos             (3U)
#define I3C_TIMINGR2_STALLC                 I3C_TIMINGR2_STALLC_Msk                 /*!< Stall on PAR bit of CCC byte */
#define I3C_TIMINGR2_STALLC_Msk             (0x1UL << I3C_TIMINGR2_STALLC_Pos)      /*!< 0x00000004 */
#define I3C_TIMINGR2_STALLC_Pos             (2U)
#define I3C_TIMINGR2_STALLD                 I3C_TIMINGR2_STALLD_Msk                 /*!< Stall on PAR bit of data bytes */
#define I3C_TIMINGR2_STALLD_Msk             (0x1UL << I3C_TIMINGR2_STALLD_Pos)      /*!< 0x00000002 */
#define I3C_TIMINGR2_STALLD_Pos             (1U)
#define I3C_TIMINGR2_STALLT                 I3C_TIMINGR2_STALLT_Msk                 /*!< Stall on T bit */
#define I3C_TIMINGR2_STALLT_Msk             (0x1UL << I3C_TIMINGR2_STALLT_Pos)      /*!< 0x00000001 */
#define I3C_TIMINGR2_STALLT_Pos             (0U)
#define I3C_TIMINGR2_STALL_Msk              (0xFFUL << I3C_TIMINGR2_STALL_Pos)      /*!< 0x0000FF00 */
#define I3C_TIMINGR2_STALL_Pos              (8U)
#define IS_I2C_ALL_INSTANCE(INSTANCE) (((INSTANCE) == I2C1) ||                                         ((INSTANCE) == I2C2) ||                                         ((INSTANCE) == I2C3))
#define IS_I3C_ALL_INSTANCE(INSTANCE) ((INSTANCE) == I3C1)
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
