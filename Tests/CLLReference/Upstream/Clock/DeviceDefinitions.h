// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// Copyright (c) 2009-2025 Arm Limited. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// Pinned device/core definitions; see LICENSES/NOTICE.txt.
#pragma once
#include <stdint.h>
#define __IO volatile
#define __I volatile const
#define __O volatile
#define __IOM volatile
#define __IM volatile const
#define __OM volatile
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
typedef struct
{
  __IO uint32_t CR;            /*!< CRS ccontrol register,                          Address offset: 0x00 */
  __IO uint32_t CFGR;          /*!< CRS configuration register,                     Address offset: 0x04 */
  __IO uint32_t ISR;           /*!< CRS interrupt and status register,              Address offset: 0x08 */
  __IO uint32_t ICR;           /*!< CRS interrupt flag clear register,              Address offset: 0x0C */
} CRS_TypeDef;
typedef struct
{
  __IO uint32_t CR1;           /*!< PWR power control register 1,                 Address offset: 0x00 */
  __IO uint32_t SR1;           /*!< PWR power status register 1,                  Address offset: 0x04 */
  __IO uint32_t CSR1;          /*!< PWR power control status register 1,          Address offset: 0x08 */
  __IO uint32_t CSR2;          /*!< PWR power control status register 2,          Address offset: 0x0C */
  __IO uint32_t CSR3;          /*!< PWR power control status register 3,          Address offset: 0x10 */
  __IO uint32_t CSR4;          /*!< PWR power control status register 4,          Address offset: 0x14 */
  uint32_t      RESERVED0[2];  /*!< Reserved */
  __IO uint32_t WKUPCR;        /*!< PWR wakeup clear register,                    Address offset: 0x20 */
  __IO uint32_t WKUPFR;        /*!< PWR wakeup flag register,                     Address offset: 0x24 */
  __IO uint32_t WKUPEPR;       /*!< PWR wakeup enable and polarity register,      Address offset: 0x28 */
  __IO uint32_t UCPDR;         /*!< PWR USB Type-C and power delivery register,   Address offset: 0x2C */
  __IO uint32_t APCR;          /*!< PWR apply pull configuration register,        Address offset: 0x30 */
  __IO uint32_t PUCRN;         /*!< PWR port N pull-up control register,          Address offset: 0x34 */
  __IO uint32_t PDCRN;         /*!< PWR port N pull-down control register,        Address offset: 0x38 */
  __IO uint32_t PUCRO;         /*!< PWR port O pull-up control register,          Address offset: 0x3C */
  __IO uint32_t PDCRO;         /*!< PWR port O pull-down control register,        Address offset: 0x40 */
  __IO uint32_t PDCRP;         /*!< PWR port P pull-down control register,        Address offset: 0x44 */
  uint32_t      RESERVED2[2];  /*!< Reserved */
  __IO uint32_t PDR1;          /*!< PWR debug register 1,                         Address offset: 0x50 */
} PWR_TypeDef;
typedef struct
{
  __IO uint32_t ACR;           /*!< FLASH access control register,                          Address offset: 0x000         */
  __IO uint32_t KEYR;          /*!< FLASH control key register,                             Address offset: 0x004         */
       uint32_t RESERVED1[2];  /*!< Reserved,                                               Address offset: 0x008 - 0x00C */
  __IO uint32_t CR;            /*!< FLASH control register,                                 Address offset: 0x010         */
  __IO uint32_t SR;            /*!< FLASH status register,                                  Address offset: 0x014         */
       uint32_t RESERVED2[2];  /*!< Reserved,                                               Address offset: 0x018 - 0x01C */
  __IO uint32_t IER;           /*!< FLASH interrupt enable register,                        Address offset: 0x020         */
  __IO uint32_t ISR;           /*!< FLASH interrupt status register,                        Address offset: 0x024         */
  __IO uint32_t ICR;           /*!< FLASH interrupt clear register,                         Address offset: 0x028         */
       uint32_t RESERVED3;     /*!< Reserved,                                               Address offset: 0x02C         */
  __IO uint32_t CRCCR;         /*!< FLASH CRC control register,                             Address offset: 0x030         */
  __IO uint32_t CRCSADDR;      /*!< FLASH CRC start address register,                       Address offset: 0x034         */
  __IO uint32_t CRCEADDR;      /*!< FLASH CRC end address register,                         Address offset: 0x038         */
  __IO uint32_t CRCDATAR;      /*!< FLASH CRC data register,                                Address offset: 0x03C         */
  __IO uint32_t ECCSFADDR;     /*!< FLASH ECC single fail address register,                 Address offset: 0x040         */
  __IO uint32_t ECCDFADDR;     /*!< FLASH ECC double fail address register,                 Address offset: 0x044         */
       uint32_t RESERVED4[46]; /*!< Reserved,                                               Address offset: 0x048 - 0x0FC */
  __IO uint32_t OPTKEYR;       /*!< FLASH options key register,                             Address offset: 0x100         */
  __IO uint32_t OPTCR;         /*!< FLASH options control register,                         Address offset: 0x104         */
  __IO uint32_t OPTISR;        /*!< FLASH options interrupt status register,                Address offset: 0x108         */
  __IO uint32_t OPTICR;        /*!< FLASH options interrupt clear register,                 Address offset: 0x10C         */
  __IO uint32_t OBKCR;         /*!< FLASH option byte key control register,                 Address offset: 0x110         */
       uint32_t RESERVED5;     /*!< Reserved,                                               Address offset: 0x114         */
  __IO uint32_t OBKDR[8];      /*!< FLASH option bytes key data register,                   Address offset: 0x118 - 0x134 */
       uint32_t RESERVED6[50]; /*!< Reserved,                                               Address offset: 0x138 - 0x1FC */
  __IO uint32_t NVSR;          /*!< FLASH non-volatile status register,                     Address offset: 0x200         */
  __IO uint32_t NVSRP;         /*!< FLASH security status register programming,             Address offset: 0x204         */
  __IO uint32_t ROTSR;         /*!< FLASH RoT status register,                              Address offset: 0x208         */
  __IO uint32_t ROTSRP;        /*!< FLASH RoT status register programming,                  Address offset: 0x20C         */
  __IO uint32_t OTPLSR;        /*!< FLASH OTP lock status register,                         Address offset: 0x210         */
  __IO uint32_t OTPLSRP;       /*!< FLASH OTP lock status programming register,             Address offset: 0x214         */
  __IO uint32_t WRPSR;         /*!< FLASH write protection status register,                 Address offset: 0x218         */
  __IO uint32_t WRPSRP;        /*!< FLASH write protection status register programming,     Address offset: 0x21C         */
       uint32_t RESERVED7[4];  /*!< Reserved,                                               Address offset: 0x220 - 0x22C */
  __IO uint32_t HDPSR;         /*!< FLASH hide protection status register,                  Address offset: 0x230         */
  __IO uint32_t HDPSRP;        /*!< FLASH hide protection status register programming,      Address offset: 0x234         */
       uint32_t RESERVED8[6];  /*!< Reserved,                                               Address offset: 0x238 - 0x24C */
  __IO uint32_t EPOCHSR;       /*!< FLASH epoch status register,                            Address offset: 0x250         */
  __IO uint32_t EPOCHSRP;      /*!< FLASH epoch status register programming,                Address offset: 0x254         */
       uint32_t RESERVED9[2];  /*!< Reserved,                                               Address offset: 0x258 - 0x25C */
  __IO uint32_t OBW1SR;        /*!< FLASH option byte word 1 status register,               Address offset: 0x260         */
  __IO uint32_t OBW1SRP;       /*!< FLASH option byte word 1 status register programming,   Address offset: 0x264         */
  __IO uint32_t OBW2SR;        /*!< FLASH option byte word 2 status register,               Address offset: 0x268         */
  __IO uint32_t OBW2SRP;       /*!< FLASH option byte word 2 status register programming,   Address offset: 0x26C         */
} FLASH_TypeDef;
typedef struct
{
  __IO uint32_t BOOTSR;        /*!< SBS Boot Status register,                             Address offset: 0x00 */
  uint32_t      RESERVED1[3];  /*!< Reserved,                                             Address offset: 0x04-0x0C */
  __IO uint32_t HDPLCR;        /*!< SBS Hide Protection Control register,                 Address offset: 0x10 */
  __IO uint32_t HDPLSR;        /*!< SBS Hide Protection Status register,                  Address offset: 0x14 */
  uint32_t      RESERVED2[2];  /*!< Reserved,                                             Address offset: 0x18-0x1C */
  __IO uint32_t DBGCR;         /*!< SBS Debug Control register,                           Address offset: 0x20 */
  __IO uint32_t DBGLOCKR;      /*!< SBS Debug Lock register,                              Address offset: 0x24 */
  uint32_t      RESERVED3[3];  /*!< Reserved,                                             Address offset: 0x28-0x30 */
  __IO uint32_t RSSCMDR;       /*!< SBS RSS Command register,                             Address offset: 0x34 */
  uint32_t      RESERVED4[50]; /*!< Reserved,                                             Address offset: 0x38-0xFC */
  __IO uint32_t PMCR;          /*!< SBS Product Mode & Config register,                   Address offset: 0x100 */
  __IO uint32_t FPUIMR;        /*!< SBS FPU Interrupt Mask register,                      Address offset: 0x104 */
  __IO uint32_t MESR;          /*!< SBS Memory Erase Status register,                     Address offset: 0x108 */
  uint32_t      RESERVED5;     /*!< Reserved,                                             Address offset: 0x10C */
  __IO uint32_t CCCSR;         /*!< SBS IO Compensation Cell Control and Status register, Address offset: 0x110 */
  __IO uint32_t CCVALR;        /*!< SBS IO Compensation Cell Value register,              Address offset: 0x114 */
  __IO uint32_t CCSWVALR;      /*!< SBS IO Compensation Cell Software Value register,     Address offset: 0x118 */
  uint32_t      RESERVED6;     /*!< Reserved,                                             Address offset: 0x11C */
  __IO uint32_t BKLOCKR;       /*!< SBS Break Lockup register,                            Address offset: 0x120 */
  uint32_t      RESERVED7[3];  /*!< Reserved,                                             Address offset: 0x124-0x12C */
  __IO uint32_t EXTICR[4];     /*!< SBS External Interrupt Configuration registers,       Address offset: 0x130-0x13C */
} SBS_TypeDef;
typedef struct
{
  __IO uint32_t IDCODE;        /*!< MCU device ID code,                             Address offset: 0x00 */
  __IO uint32_t CR;            /*!< Debug MCU configuration register,               Address offset: 0x04 */
  uint32_t RESERVED1[5];       /*!< Reserved,                                       Address offset: 0x08-0x18 */
  __IO uint32_t AHB5FZR;       /*!< Debug MCU AHB5FZR freeze register,              Address offset: 0x1C */
  uint32_t RESERVED2;          /*!< Reserved,                                       Address offset: 0x20 */
  __IO uint32_t AHB1FZR;       /*!< Debug MCU AHB1FZR freeze register,              Address offset: 0x24 */
  uint32_t RESERVED3[5];       /*!< Reserved,                                       Address offset: 0x28-0x38 */
  __IO uint32_t APB1FZR;       /*!< Debug MCU APB1FZR freeze register,              Address offset: 0x3C */
  uint32_t RESERVED4[3];       /*!< Reserved,                                       Address offset: 0x40-0x48 */
  __IO uint32_t APB2FZR;       /*!< Debug MCU APB2FZR freeze register,              Address offset: 0x4C */
  uint32_t RESERVED5;          /*!< Reserved,                                       Address offset: 0x50 */
  __IO uint32_t APB4FZR;       /*!< Debug MCU APB4FZR freeze register,              Address offset: 0x54 */
  uint32_t RESERVED6[41];      /*!< Reserved,                                       Address offset: 0x58-0xF8 */
  __IO uint32_t SR;            /*!< Debug MCU status register,                      Address offset: 0xFC */
  __IO uint32_t DBG_AUTH_HOST; /*!< Debug MCU Authentication Host register,         Address offset: 0x100 */
  __IO uint32_t DBG_AUTH_DEV;  /*!< Debug MCU Authentication Device register,       Address offset: 0x104 */
  __IO uint32_t DBG_AUTH_ACK;  /*!< Debug MCU Authentication Ack register,          Address offset: 0x108 */
  uint32_t RESERVED7[945];     /*!< Reserved,                                       Address offset: 0x10C-0xFCC */
  __IO uint32_t PIDR4;         /*!< Debug MCU peripheral identity register 4,       Address offset: 0xFD0 */
  uint32_t RESERVED8[3];       /*!< Reserved,                                       Address offset: 0xFD4-0xFDC */
  __IO uint32_t PIDR0;         /*!< Debug MCU peripheral identity register 0,       Address offset: 0xFE0 */
  __IO uint32_t PIDR1;         /*!< Debug MCU peripheral identity register 1,       Address offset: 0xFE4 */
  __IO uint32_t PIDR2;         /*!< Debug MCU peripheral identity register 2,       Address offset: 0xFE8 */
  __IO uint32_t PIDR3;         /*!< Debug MCU peripheral identity register 3,       Address offset: 0xFEC */
  __IO uint32_t CIDR0;         /*!< Debug MCU component identity register 0,        Address offset: 0xFF0 */
  __IO uint32_t CIDR1;         /*!< Debug MCU component identity register 1,        Address offset: 0xFF4 */
  __IO uint32_t CIDR2;         /*!< Debug MCU component identity register 2,        Address offset: 0xFF8 */
  __IO uint32_t CIDR3;         /*!< Debug MCU component identity register 3,        Address offset: 0xFFC */
} DBGMCU_TypeDef;
typedef struct
{
  __IO uint32_t CSR;         /*!< VREFBUF control and status register,         Address offset: 0x00 */
  __IO uint32_t CCR;         /*!< VREFBUF calibration and control register,    Address offset: 0x04 */
} VREFBUF_TypeDef;
typedef struct
{
  __IOM uint32_t CTRL;                   /*!< Offset: 0x000 (R/W)  SysTick Control and Status Register */
  __IOM uint32_t LOAD;                   /*!< Offset: 0x004 (R/W)  SysTick Reload Value Register */
  __IOM uint32_t VAL;                    /*!< Offset: 0x008 (R/W)  SysTick Current Value Register */
  __IM  uint32_t CALIB;                  /*!< Offset: 0x00C (R/ )  SysTick Calibration Register */
} SysTick_Type;
typedef enum
{
  SUCCESS = 0,
  ERROR = !SUCCESS
} ErrorStatus;
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
#define CRS_CFGR_SYNCSRC           CRS_CFGR_SYNCSRC_Msk                        /*!< SYNC signal source selection */
#define CRS_CFGR_SYNCSRC_0         (0x1UL << CRS_CFGR_SYNCSRC_Pos)             /*!< 0x10000000 */
#define CRS_CFGR_SYNCSRC_1         (0x2UL << CRS_CFGR_SYNCSRC_Pos)             /*!< 0x20000000 */
#define CRS_CFGR_SYNCSRC_Msk       (0x3UL << CRS_CFGR_SYNCSRC_Pos)             /*!< 0x30000000 */
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
#define DBGMCU_AHB1FZR_GPDMA_0               DBGMCU_AHB1FZR_GPDMA_0_Msk                           /*!< GPDMA channel 0 stop in debug */
#define DBGMCU_AHB1FZR_GPDMA_0_Msk           (0x1UL << DBGMCU_AHB1FZR_GPDMA_0_Pos)                /*!< 0x00000001 */
#define DBGMCU_AHB1FZR_GPDMA_0_Pos           (0U)
#define DBGMCU_AHB1FZR_GPDMA_1               DBGMCU_AHB1FZR_GPDMA_1_Msk                           /*!< GPDMA channel 1 stop in debug */
#define DBGMCU_AHB1FZR_GPDMA_10              DBGMCU_AHB1FZR_GPDMA_10_Msk                          /*!< GPDMA channel 10 stop in debug */
#define DBGMCU_AHB1FZR_GPDMA_10_Msk          (0x1UL << DBGMCU_AHB1FZR_GPDMA_10_Pos)               /*!< 0x00000400 */
#define DBGMCU_AHB1FZR_GPDMA_10_Pos          (10U)
#define DBGMCU_AHB1FZR_GPDMA_11              DBGMCU_AHB1FZR_GPDMA_11_Msk                          /*!< GPDMA channel 11 stop in debug */
#define DBGMCU_AHB1FZR_GPDMA_11_Msk          (0x1UL << DBGMCU_AHB1FZR_GPDMA_11_Pos)               /*!< 0x00000800 */
#define DBGMCU_AHB1FZR_GPDMA_11_Pos          (11U)
#define DBGMCU_AHB1FZR_GPDMA_12              DBGMCU_AHB1FZR_GPDMA_12_Msk                          /*!< GPDMA channel 12 stop in debug */
#define DBGMCU_AHB1FZR_GPDMA_12_Msk          (0x1UL << DBGMCU_AHB1FZR_GPDMA_12_Pos)               /*!< 0x00001000 */
#define DBGMCU_AHB1FZR_GPDMA_12_Pos          (12U)
#define DBGMCU_AHB1FZR_GPDMA_13              DBGMCU_AHB1FZR_GPDMA_13_Msk                          /*!< GPDMA channel 13 stop in debug */
#define DBGMCU_AHB1FZR_GPDMA_13_Msk          (0x1UL << DBGMCU_AHB1FZR_GPDMA_13_Pos)               /*!< 0x00002000 */
#define DBGMCU_AHB1FZR_GPDMA_13_Pos          (13U)
#define DBGMCU_AHB1FZR_GPDMA_14              DBGMCU_AHB1FZR_GPDMA_14_Msk                          /*!< GPDMA channel 14 stop in debug */
#define DBGMCU_AHB1FZR_GPDMA_14_Msk          (0x1UL << DBGMCU_AHB1FZR_GPDMA_14_Pos)               /*!< 0x00004000 */
#define DBGMCU_AHB1FZR_GPDMA_14_Pos          (14U)
#define DBGMCU_AHB1FZR_GPDMA_15              DBGMCU_AHB1FZR_GPDMA_15_Msk                          /*!< GPDMA channel 15 stop in debug */
#define DBGMCU_AHB1FZR_GPDMA_15_Msk          (0x1UL << DBGMCU_AHB1FZR_GPDMA_15_Pos)               /*!< 0x00008000 */
#define DBGMCU_AHB1FZR_GPDMA_15_Pos          (15U)
#define DBGMCU_AHB1FZR_GPDMA_1_Msk           (0x1UL << DBGMCU_AHB1FZR_GPDMA_1_Pos)                /*!< 0x00000002 */
#define DBGMCU_AHB1FZR_GPDMA_1_Pos           (1U)
#define DBGMCU_AHB1FZR_GPDMA_2               DBGMCU_AHB1FZR_GPDMA_2_Msk                           /*!< GPDMA channel 2 stop in debug */
#define DBGMCU_AHB1FZR_GPDMA_2_Msk           (0x1UL << DBGMCU_AHB1FZR_GPDMA_2_Pos)                /*!< 0x00000004 */
#define DBGMCU_AHB1FZR_GPDMA_2_Pos           (2U)
#define DBGMCU_AHB1FZR_GPDMA_3               DBGMCU_AHB1FZR_GPDMA_3_Msk                           /*!< GPDMA channel 3 stop in debug */
#define DBGMCU_AHB1FZR_GPDMA_3_Msk           (0x1UL << DBGMCU_AHB1FZR_GPDMA_3_Pos)                /*!< 0x00000008 */
#define DBGMCU_AHB1FZR_GPDMA_3_Pos           (3U)
#define DBGMCU_AHB1FZR_GPDMA_4               DBGMCU_AHB1FZR_GPDMA_4_Msk                           /*!< GPDMA channel 4 stop in debug */
#define DBGMCU_AHB1FZR_GPDMA_4_Msk           (0x1UL << DBGMCU_AHB1FZR_GPDMA_4_Pos)                /*!< 0x00000010 */
#define DBGMCU_AHB1FZR_GPDMA_4_Pos           (4U)
#define DBGMCU_AHB1FZR_GPDMA_5               DBGMCU_AHB1FZR_GPDMA_5_Msk                           /*!< GPDMA channel 5 stop in debug */
#define DBGMCU_AHB1FZR_GPDMA_5_Msk           (0x1UL << DBGMCU_AHB1FZR_GPDMA_5_Pos)                /*!< 0x00000020 */
#define DBGMCU_AHB1FZR_GPDMA_5_Pos           (5U)
#define DBGMCU_AHB1FZR_GPDMA_6               DBGMCU_AHB1FZR_GPDMA_6_Msk                           /*!< GPDMA channel 6 stop in debug */
#define DBGMCU_AHB1FZR_GPDMA_6_Msk           (0x1UL << DBGMCU_AHB1FZR_GPDMA_6_Pos)                /*!< 0x00000040 */
#define DBGMCU_AHB1FZR_GPDMA_6_Pos           (6U)
#define DBGMCU_AHB1FZR_GPDMA_7               DBGMCU_AHB1FZR_GPDMA_7_Msk                           /*!< GPDMA channel 7 stop in debug */
#define DBGMCU_AHB1FZR_GPDMA_7_Msk           (0x1UL << DBGMCU_AHB1FZR_GPDMA_7_Pos)                /*!< 0x00000080 */
#define DBGMCU_AHB1FZR_GPDMA_7_Pos           (7U)
#define DBGMCU_AHB1FZR_GPDMA_8               DBGMCU_AHB1FZR_GPDMA_8_Msk                           /*!< GPDMA channel 8 stop in debug */
#define DBGMCU_AHB1FZR_GPDMA_8_Msk           (0x1UL << DBGMCU_AHB1FZR_GPDMA_8_Pos)                /*!< 0x00000100 */
#define DBGMCU_AHB1FZR_GPDMA_8_Pos           (8U)
#define DBGMCU_AHB1FZR_GPDMA_9               DBGMCU_AHB1FZR_GPDMA_9_Msk                           /*!< GPDMA channel 9 stop in debug */
#define DBGMCU_AHB1FZR_GPDMA_9_Msk           (0x1UL << DBGMCU_AHB1FZR_GPDMA_9_Pos)                /*!< 0x00000200 */
#define DBGMCU_AHB1FZR_GPDMA_9_Pos           (9U)
#define DBGMCU_AHB5FZR_HPDMA_0               DBGMCU_AHB5FZR_HPDMA_0_Msk                           /*!< HPDMA channel 0 stop in debug */
#define DBGMCU_AHB5FZR_HPDMA_0_Msk           (0x1UL << DBGMCU_AHB5FZR_HPDMA_0_Pos)                /*!< 0x00000001 */
#define DBGMCU_AHB5FZR_HPDMA_0_Pos           (0U)
#define DBGMCU_AHB5FZR_HPDMA_1               DBGMCU_AHB5FZR_HPDMA_1_Msk                           /*!< HPDMA channel 1 stop in debug */
#define DBGMCU_AHB5FZR_HPDMA_10              DBGMCU_AHB5FZR_HPDMA_10_Msk                          /*!< HPDMA channel 10 stop in debug */
#define DBGMCU_AHB5FZR_HPDMA_10_Msk          (0x1UL << DBGMCU_AHB5FZR_HPDMA_10_Pos)               /*!< 0x00000400 */
#define DBGMCU_AHB5FZR_HPDMA_10_Pos          (10U)
#define DBGMCU_AHB5FZR_HPDMA_11              DBGMCU_AHB5FZR_HPDMA_11_Msk                          /*!< HPDMA channel 11 stop in debug */
#define DBGMCU_AHB5FZR_HPDMA_11_Msk          (0x1UL << DBGMCU_AHB5FZR_HPDMA_11_Pos)               /*!< 0x00000800 */
#define DBGMCU_AHB5FZR_HPDMA_11_Pos          (11U)
#define DBGMCU_AHB5FZR_HPDMA_12              DBGMCU_AHB5FZR_HPDMA_12_Msk                          /*!< HPDMA channel 12 stop in debug */
#define DBGMCU_AHB5FZR_HPDMA_12_Msk          (0x1UL << DBGMCU_AHB5FZR_HPDMA_12_Pos)               /*!< 0x00001000 */
#define DBGMCU_AHB5FZR_HPDMA_12_Pos          (12U)
#define DBGMCU_AHB5FZR_HPDMA_13              DBGMCU_AHB5FZR_HPDMA_13_Msk                          /*!< HPDMA channel 13 stop in debug */
#define DBGMCU_AHB5FZR_HPDMA_13_Msk          (0x1UL << DBGMCU_AHB5FZR_HPDMA_13_Pos)               /*!< 0x00002000 */
#define DBGMCU_AHB5FZR_HPDMA_13_Pos          (13U)
#define DBGMCU_AHB5FZR_HPDMA_14              DBGMCU_AHB5FZR_HPDMA_14_Msk                          /*!< HPDMA channel 14 stop in debug */
#define DBGMCU_AHB5FZR_HPDMA_14_Msk          (0x1UL << DBGMCU_AHB5FZR_HPDMA_14_Pos)               /*!< 0x00004000 */
#define DBGMCU_AHB5FZR_HPDMA_14_Pos          (14U)
#define DBGMCU_AHB5FZR_HPDMA_15              DBGMCU_AHB5FZR_HPDMA_15_Msk                          /*!< HPDMA channel 15 stop in debug */
#define DBGMCU_AHB5FZR_HPDMA_15_Msk          (0x1UL << DBGMCU_AHB5FZR_HPDMA_15_Pos)               /*!< 0x00008000 */
#define DBGMCU_AHB5FZR_HPDMA_15_Pos          (15U)
#define DBGMCU_AHB5FZR_HPDMA_1_Msk           (0x1UL << DBGMCU_AHB5FZR_HPDMA_1_Pos)                /*!< 0x00000002 */
#define DBGMCU_AHB5FZR_HPDMA_1_Pos           (1U)
#define DBGMCU_AHB5FZR_HPDMA_2               DBGMCU_AHB5FZR_HPDMA_2_Msk                           /*!< HPDMA channel 2 stop in debug */
#define DBGMCU_AHB5FZR_HPDMA_2_Msk           (0x1UL << DBGMCU_AHB5FZR_HPDMA_2_Pos)                /*!< 0x00000004 */
#define DBGMCU_AHB5FZR_HPDMA_2_Pos           (2U)
#define DBGMCU_AHB5FZR_HPDMA_3               DBGMCU_AHB5FZR_HPDMA_3_Msk                           /*!< HPDMA channel 3 stop in debug */
#define DBGMCU_AHB5FZR_HPDMA_3_Msk           (0x1UL << DBGMCU_AHB5FZR_HPDMA_3_Pos)                /*!< 0x00000008 */
#define DBGMCU_AHB5FZR_HPDMA_3_Pos           (3U)
#define DBGMCU_AHB5FZR_HPDMA_4               DBGMCU_AHB5FZR_HPDMA_4_Msk                           /*!< HPDMA channel 4 stop in debug */
#define DBGMCU_AHB5FZR_HPDMA_4_Msk           (0x1UL << DBGMCU_AHB5FZR_HPDMA_4_Pos)                /*!< 0x00000010 */
#define DBGMCU_AHB5FZR_HPDMA_4_Pos           (4U)
#define DBGMCU_AHB5FZR_HPDMA_5               DBGMCU_AHB5FZR_HPDMA_5_Msk                           /*!< HPDMA channel 5 stop in debug */
#define DBGMCU_AHB5FZR_HPDMA_5_Msk           (0x1UL << DBGMCU_AHB5FZR_HPDMA_5_Pos)                /*!< 0x00000020 */
#define DBGMCU_AHB5FZR_HPDMA_5_Pos           (5U)
#define DBGMCU_AHB5FZR_HPDMA_6               DBGMCU_AHB5FZR_HPDMA_6_Msk                           /*!< HPDMA channel 6 stop in debug */
#define DBGMCU_AHB5FZR_HPDMA_6_Msk           (0x1UL << DBGMCU_AHB5FZR_HPDMA_6_Pos)                /*!< 0x00000040 */
#define DBGMCU_AHB5FZR_HPDMA_6_Pos           (6U)
#define DBGMCU_AHB5FZR_HPDMA_7               DBGMCU_AHB5FZR_HPDMA_7_Msk                           /*!< HPDMA channel 7 stop in debug */
#define DBGMCU_AHB5FZR_HPDMA_7_Msk           (0x1UL << DBGMCU_AHB5FZR_HPDMA_7_Pos)                /*!< 0x00000080 */
#define DBGMCU_AHB5FZR_HPDMA_7_Pos           (7U)
#define DBGMCU_AHB5FZR_HPDMA_8               DBGMCU_AHB5FZR_HPDMA_8_Msk                           /*!< HPDMA channel 8 stop in debug */
#define DBGMCU_AHB5FZR_HPDMA_8_Msk           (0x1UL << DBGMCU_AHB5FZR_HPDMA_8_Pos)                /*!< 0x00000100 */
#define DBGMCU_AHB5FZR_HPDMA_8_Pos           (8U)
#define DBGMCU_AHB5FZR_HPDMA_9               DBGMCU_AHB5FZR_HPDMA_9_Msk                           /*!< HPDMA channel 9 stop in debug */
#define DBGMCU_AHB5FZR_HPDMA_9_Msk           (0x1UL << DBGMCU_AHB5FZR_HPDMA_9_Pos)                /*!< 0x00000200 */
#define DBGMCU_AHB5FZR_HPDMA_9_Pos           (9U)
#define DBGMCU_APB1FZR_I2C1                  DBGMCU_APB1FZR_I2C1_Msk                              /*!< I2C1 SMBUS timeout stop in debug */
#define DBGMCU_APB1FZR_I2C1_Msk              (0x1UL << DBGMCU_APB1FZR_I2C1_Pos)                   /*!< 0x00200000 */
#define DBGMCU_APB1FZR_I2C1_Pos              (21U)
#define DBGMCU_APB1FZR_I2C2                  DBGMCU_APB1FZR_I2C2_Msk                              /*!< I2C2 SMBUS timeout stop in debug */
#define DBGMCU_APB1FZR_I2C2_Msk              (0x1UL << DBGMCU_APB1FZR_I2C2_Pos)                   /*!< 0x00400000 */
#define DBGMCU_APB1FZR_I2C2_Pos              (22U)
#define DBGMCU_APB1FZR_I2C3                  DBGMCU_APB1FZR_I2C3_Msk                              /*!< I2C3 SMBUS timeout stop in debug */
#define DBGMCU_APB1FZR_I2C3_Msk              (0x1UL << DBGMCU_APB1FZR_I2C3_Pos)                   /*!< 0x00800000 */
#define DBGMCU_APB1FZR_I2C3_Pos              (23U)
#define DBGMCU_APB1FZR_LPTIM1                DBGMCU_APB1FZR_LPTIM1_Msk                            /*!< LPTIM1 stop in debug */
#define DBGMCU_APB1FZR_LPTIM1_Msk            (0x1UL << DBGMCU_APB1FZR_LPTIM1_Pos)                 /*!< 0x00000200 */
#define DBGMCU_APB1FZR_LPTIM1_Pos            (9U)
#define DBGMCU_APB1FZR_TIM12                 DBGMCU_APB1FZR_TIM12_Msk                             /*!< TIM12 stop in debug */
#define DBGMCU_APB1FZR_TIM12_Msk             (0x1UL << DBGMCU_APB1FZR_TIM12_Pos)                  /*!< 0x00000040 */
#define DBGMCU_APB1FZR_TIM12_Pos             (6U)
#define DBGMCU_APB1FZR_TIM13                 DBGMCU_APB1FZR_TIM13_Msk                             /*!< TIM13 stop in debug */
#define DBGMCU_APB1FZR_TIM13_Msk             (0x1UL << DBGMCU_APB1FZR_TIM13_Pos)                  /*!< 0x00000080 */
#define DBGMCU_APB1FZR_TIM13_Pos             (7U)
#define DBGMCU_APB1FZR_TIM14                 DBGMCU_APB1FZR_TIM14_Msk                             /*!< TIM14 stop in debug */
#define DBGMCU_APB1FZR_TIM14_Msk             (0x1UL << DBGMCU_APB1FZR_TIM14_Pos)                  /*!< 0x00000100 */
#define DBGMCU_APB1FZR_TIM14_Pos             (8U)
#define DBGMCU_APB1FZR_TIM2                  DBGMCU_APB1FZR_TIM2_Msk                              /*!< TIM2 stop in debug */
#define DBGMCU_APB1FZR_TIM2_Msk              (0x1UL << DBGMCU_APB1FZR_TIM2_Pos)                   /*!< 0x00000001 */
#define DBGMCU_APB1FZR_TIM2_Pos              (0U)
#define DBGMCU_APB1FZR_TIM3                  DBGMCU_APB1FZR_TIM3_Msk                              /*!< TIM3 stop in debug */
#define DBGMCU_APB1FZR_TIM3_Msk              (0x1UL << DBGMCU_APB1FZR_TIM3_Pos)                   /*!< 0x00000002 */
#define DBGMCU_APB1FZR_TIM3_Pos              (1U)
#define DBGMCU_APB1FZR_TIM4                  DBGMCU_APB1FZR_TIM4_Msk                              /*!< TIM4 stop in debug */
#define DBGMCU_APB1FZR_TIM4_Msk              (0x1UL << DBGMCU_APB1FZR_TIM4_Pos)                   /*!< 0x00000004 */
#define DBGMCU_APB1FZR_TIM4_Pos              (2U)
#define DBGMCU_APB1FZR_TIM5                  DBGMCU_APB1FZR_TIM5_Msk                              /*!< TIM5 stop in debug */
#define DBGMCU_APB1FZR_TIM5_Msk              (0x1UL << DBGMCU_APB1FZR_TIM5_Pos)                   /*!< 0x00000008 */
#define DBGMCU_APB1FZR_TIM5_Pos              (3U)
#define DBGMCU_APB1FZR_TIM6                  DBGMCU_APB1FZR_TIM6_Msk                              /*!< TIM6 stop in debug */
#define DBGMCU_APB1FZR_TIM6_Msk              (0x1UL << DBGMCU_APB1FZR_TIM6_Pos)                   /*!< 0x00000010 */
#define DBGMCU_APB1FZR_TIM6_Pos              (4U)
#define DBGMCU_APB1FZR_TIM7                  DBGMCU_APB1FZR_TIM7_Msk                              /*!< TIM7 stop in debug */
#define DBGMCU_APB1FZR_TIM7_Msk              (0x1UL << DBGMCU_APB1FZR_TIM7_Pos)                   /*!< 0x00000020 */
#define DBGMCU_APB1FZR_TIM7_Pos              (5U)
#define DBGMCU_APB1FZR_WWDG                  DBGMCU_APB1FZR_WWDG_Msk                              /*!< WWDG stop in debug */
#define DBGMCU_APB1FZR_WWDG_Msk              (0x1UL << DBGMCU_APB1FZR_WWDG_Pos)                   /*!< 0x00000800 */
#define DBGMCU_APB1FZR_WWDG_Pos              (11U)
#define DBGMCU_APB2FZR_TIM1                  DBGMCU_APB2FZR_TIM1_Msk                              /*!< TIM1 stop in debug */
#define DBGMCU_APB2FZR_TIM15                 DBGMCU_APB2FZR_TIM15_Msk                             /*!< TIM15 stop in debug */
#define DBGMCU_APB2FZR_TIM15_Msk             (0x1UL << DBGMCU_APB2FZR_TIM15_Pos)                  /*!< 0x00010000 */
#define DBGMCU_APB2FZR_TIM15_Pos             (16U)
#define DBGMCU_APB2FZR_TIM16                 DBGMCU_APB2FZR_TIM16_Msk                             /*!< TIM16 stop in debug */
#define DBGMCU_APB2FZR_TIM16_Msk             (0x1UL << DBGMCU_APB2FZR_TIM16_Pos)                  /*!< 0x00020000 */
#define DBGMCU_APB2FZR_TIM16_Pos             (17U)
#define DBGMCU_APB2FZR_TIM17                 DBGMCU_APB2FZR_TIM17_Msk                             /*!< TIM17 stop in debug */
#define DBGMCU_APB2FZR_TIM17_Msk             (0x1UL << DBGMCU_APB2FZR_TIM17_Pos)                  /*!< 0x00040000 */
#define DBGMCU_APB2FZR_TIM17_Pos             (18U)
#define DBGMCU_APB2FZR_TIM1_Msk              (0x1UL << DBGMCU_APB2FZR_TIM1_Pos)                   /*!< 0x00000001 */
#define DBGMCU_APB2FZR_TIM1_Pos              (0U)
#define DBGMCU_APB2FZR_TIM9                  DBGMCU_APB2FZR_TIM9_Msk                              /*!< TIM9 stop in debug */
#define DBGMCU_APB2FZR_TIM9_Msk              (0x1UL << DBGMCU_APB2FZR_TIM9_Pos)                   /*!< 0x00080000 */
#define DBGMCU_APB2FZR_TIM9_Pos              (19U)
#define DBGMCU_APB4FZR_IWDG                  DBGMCU_APB4FZR_IWDG_Msk                              /*!< Independent watchdog for stop in debug */
#define DBGMCU_APB4FZR_IWDG_Msk              (0x1UL << DBGMCU_APB4FZR_IWDG_Pos)                   /*!< 0x00040000 */
#define DBGMCU_APB4FZR_IWDG_Pos              (18U)
#define DBGMCU_APB4FZR_LPTIM2                DBGMCU_APB4FZR_LPTIM2_Msk                            /*!< LPTIM2 stop in debug */
#define DBGMCU_APB4FZR_LPTIM2_Msk            (0x1UL << DBGMCU_APB4FZR_LPTIM2_Pos)                 /*!< 0x00000200 */
#define DBGMCU_APB4FZR_LPTIM2_Pos            (9U)
#define DBGMCU_APB4FZR_LPTIM3                DBGMCU_APB4FZR_LPTIM3_Msk                            /*!< LPTIM3 stop in debug */
#define DBGMCU_APB4FZR_LPTIM3_Msk            (0x1UL << DBGMCU_APB4FZR_LPTIM3_Pos)                 /*!< 0x00000400 */
#define DBGMCU_APB4FZR_LPTIM3_Pos            (10U)
#define DBGMCU_APB4FZR_LPTIM4                DBGMCU_APB4FZR_LPTIM4_Msk                            /*!< LPTIM4 stop in debug */
#define DBGMCU_APB4FZR_LPTIM4_Msk            (0x1UL << DBGMCU_APB4FZR_LPTIM4_Pos)                 /*!< 0x00000800 */
#define DBGMCU_APB4FZR_LPTIM4_Pos            (11U)
#define DBGMCU_APB4FZR_LPTIM5                DBGMCU_APB4FZR_LPTIM5_Msk                            /*!< LPTIM5 stop in debug */
#define DBGMCU_APB4FZR_LPTIM5_Msk            (0x1UL << DBGMCU_APB4FZR_LPTIM5_Pos)                 /*!< 0x00001000 */
#define DBGMCU_APB4FZR_LPTIM5_Pos            (12U)
#define DBGMCU_APB4FZR_RTC                   DBGMCU_APB4FZR_RTC_Msk                               /*!< RTC stop in debug */
#define DBGMCU_APB4FZR_RTC_Msk               (0x1UL << DBGMCU_APB4FZR_RTC_Pos)                    /*!< 0x00010000 */
#define DBGMCU_APB4FZR_RTC_Pos               (16U)
#define DBGMCU_CR_DBGCKEN                    DBGMCU_CR_DBGCKEN_Msk                                /*!< Debug clock enable */
#define DBGMCU_CR_DBGCKEN_Msk                (0x1UL << DBGMCU_CR_DBGCKEN_Pos )                    /*!< 0x00200000 */
#define DBGMCU_CR_DBGCKEN_Pos                (21U)
#define DBGMCU_CR_DBG_SLEEP                  DBGMCU_CR_DBG_SLEEP_Msk                              /*!< Debug in Sleep mode enable */
#define DBGMCU_CR_DBG_SLEEP_Msk              (0x1UL << DBGMCU_CR_DBG_SLEEP_Pos)                   /*!< 0x00000001 */
#define DBGMCU_CR_DBG_SLEEP_Pos              (0U)
#define DBGMCU_CR_DBG_STANDBY                DBGMCU_CR_DBG_STANDBY_Msk                            /*!< Debug in Standby mode enable */
#define DBGMCU_CR_DBG_STANDBY_Msk            (0x1UL << DBGMCU_CR_DBG_STANDBY_Pos)                 /*!< 0x00000004 */
#define DBGMCU_CR_DBG_STANDBY_Pos            (2U)
#define DBGMCU_CR_DBG_STOP                   DBGMCU_CR_DBG_STOP_Msk                               /*!< Debug in Stop mode enable */
#define DBGMCU_CR_DBG_STOP_Msk               (0x1UL << DBGMCU_CR_DBG_STOP_Pos)                    /*!< 0x00000002 */
#define DBGMCU_CR_DBG_STOP_Pos               (1U)
#define DBGMCU_CR_DCRT                       DBGMCU_CR_DCRT_Msk                                   /*!< Debug credentials reset type */
#define DBGMCU_CR_DCRT_Msk                   (0x1UL << DBGMCU_CR_DCRT_Pos)                        /*!< 0x00010000 */
#define DBGMCU_CR_DCRT_Pos                   (16U)
#define DBGMCU_CR_TRACECLKEN                 DBGMCU_CR_TRACECLKEN_Msk                             /*!< Trace port clock enable */
#define DBGMCU_CR_TRACECLKEN_Msk             (0x1UL << DBGMCU_CR_TRACECLKEN_Pos)                  /*!< 0x00100000 */
#define DBGMCU_CR_TRACECLKEN_Pos             (20U)
#define DBGMCU_CR_TRGOEN                     DBGMCU_CR_TRGOEN_Msk                                 /*!< External trigger output enable */
#define DBGMCU_CR_TRGOEN_Msk                 (0x1UL << DBGMCU_CR_TRGOEN_Pos)                      /*!< 0x10000000 */
#define DBGMCU_CR_TRGOEN_Pos                 (28U)
#define DBGMCU_IDCODE_DEV_ID                 DBGMCU_IDCODE_DEV_ID_Msk                             /*!< Device ID */
#define DBGMCU_IDCODE_DEV_ID_Msk             (0xFFFUL << DBGMCU_IDCODE_DEV_ID_Pos)                /*!< 0x00000FFF */
#define DBGMCU_IDCODE_DEV_ID_Pos             (0U)
#define DBGMCU_IDCODE_REV_ID                 DBGMCU_IDCODE_REV_ID_Msk                             /*!< Revision */
#define DBGMCU_IDCODE_REV_ID_Msk             (0xFFFFUL << DBGMCU_IDCODE_REV_ID_Pos)               /*!< 0xFFFF0000 */
#define DBGMCU_IDCODE_REV_ID_Pos             (16U)
#define FLASH_ACR_LATENCY                    FLASH_ACR_LATENCY_Msk                               /*!< Read Latency */
#define FLASH_ACR_LATENCY_0                  (0x1UL << FLASH_ACR_LATENCY_Pos)                    /*!< 0x00000001 */
#define FLASH_ACR_LATENCY_1                  (0x2UL << FLASH_ACR_LATENCY_Pos)                    /*!< 0x00000002 */
#define FLASH_ACR_LATENCY_2                  (0x4UL << FLASH_ACR_LATENCY_Pos)                    /*!< 0x00000004 */
#define FLASH_ACR_LATENCY_Msk                (0xFUL << FLASH_ACR_LATENCY_Pos)                    /*!< 0x0000000F */
#define FLASH_ACR_LATENCY_Pos                (0U)
#define FLASH_CR_LOCK                        FLASH_CR_LOCK_Msk                                   /*!< Configuration lock bit */
#define FLASH_CR_LOCK_Msk                    (0x1UL << FLASH_CR_LOCK_Pos)                        /*!< 0x00000001 */
#define FLASH_CR_LOCK_Pos                    (0U)
#define FLASH_LATENCY_DEFAULT                (FLASH_ACR_LATENCY_1 | FLASH_ACR_LATENCY_0) /* default flash latency 3WS ) */
#define FLASH_OBW2SRP_I2C_NI3C               FLASH_OBW2SRP_I2C_NI3C_Msk                          /*!< I2C Not I3C */
#define FLASH_OBW2SRP_I2C_NI3C_Msk           (0x1UL << FLASH_OBW2SRP_I2C_NI3C_Pos)               /*!< 0x00000200 */
#define FLASH_OBW2SRP_I2C_NI3C_Pos           (9U)
#define FLASH_OBW2SR_I2C_NI3C                FLASH_OBW2SR_I2C_NI3C_Msk                           /*!< I2C Not I3C */
#define FLASH_OBW2SR_I2C_NI3C_Msk            (0x1UL << FLASH_OBW2SR_I2C_NI3C_Pos)                /*!< 0x00000200 */
#define FLASH_OBW2SR_I2C_NI3C_Pos            (9U)
#define FLASH_OPTCR_OPTLOCK                  FLASH_OPTCR_OPTLOCK_Msk                             /*!< Options lock */
#define FLASH_OPTCR_OPTLOCK_Msk              (0x1UL << FLASH_OPTCR_OPTLOCK_Pos)                  /*!< 0x00000001 */
#define FLASH_OPTCR_OPTLOCK_Pos              (0U)
#define FLASH_OPTCR_PG_OPT                   FLASH_OPTCR_PG_OPT_Msk                              /*!< Program options */
#define FLASH_OPTCR_PG_OPT_Msk               (0x1UL << FLASH_OPTCR_PG_OPT_Pos)                   /*!< 0x00000002 */
#define FLASH_OPTCR_PG_OPT_Pos               (1U)
#define FLASH_SR_QW                          FLASH_SR_QW_Msk                                     /*!< Wait queue flag */
#define FLASH_SR_QW_Msk                      (0x1UL << FLASH_SR_QW_Pos)                          /*!< 0x00000004 */
#define FLASH_SR_QW_Pos                      (2U)
#define PWR_APCR_APC                   PWR_APCR_APC_Msk                        /*!< Apply pull configuration register */
#define PWR_APCR_APC_Msk               (0x1UL << PWR_APCR_APC_Pos)             /*!< 0x00000001 */
#define PWR_APCR_APC_Pos               (0U)
#define PWR_APCR_I3CPB6_PU             PWR_APCR_I3CPB6_PU_Msk                 /*!< Port PB6 I3C pull-up bit configuration */
#define PWR_APCR_I3CPB6_PU_Msk         (0x1UL << PWR_APCR_I3CPB6_PU_Pos)      /*!< 0x10000000 */
#define PWR_APCR_I3CPB6_PU_Pos         (28U)
#define PWR_APCR_I3CPB7_PU             PWR_APCR_I3CPB7_PU_Msk                 /*!< Port PB7 I3C pull-up bit configuration */
#define PWR_APCR_I3CPB7_PU_Msk         (0x1UL << PWR_APCR_I3CPB7_PU_Pos)      /*!< 0x20000000 */
#define PWR_APCR_I3CPB7_PU_Pos         (29U)
#define PWR_APCR_I3CPB8_PU             PWR_APCR_I3CPB8_PU_Msk                 /*!< Port PB8 I3C pull-up bit configuration */
#define PWR_APCR_I3CPB8_PU_Msk         (0x1UL << PWR_APCR_I3CPB8_PU_Pos)      /*!< 0x40000000 */
#define PWR_APCR_I3CPB8_PU_Pos         (30U)
#define PWR_APCR_I3CPB9_PU             PWR_APCR_I3CPB9_PU_Msk                 /*!< Port PB9 I3C pull-up bit configuration */
#define PWR_APCR_I3CPB9_PU_Msk         (0x1UL << PWR_APCR_I3CPB9_PU_Pos)      /*!< 0x80000000 */
#define PWR_APCR_I3CPB9_PU_Pos         (31U)
#define PWR_CR1_ALS                    PWR_CR1_ALS_Msk                         /*!< Analog Voltage Detector level selection */
#define PWR_CR1_ALS_0                  (0x1UL << PWR_CR1_ALS_Pos)              /*!< 0x00004000 */
#define PWR_CR1_ALS_1                  (0x2UL << PWR_CR1_ALS_Pos)              /*!< 0x00008000 */
#define PWR_CR1_ALS_Msk                (0x3UL << PWR_CR1_ALS_Pos)              /*!< 0x0000A000 */
#define PWR_CR1_ALS_Pos                (14U)
#define PWR_CR1_AVDEN                  PWR_CR1_AVDEN_Msk                       /*!< Analog Voltage Detector Enable       */
#define PWR_CR1_AVDEN_Msk              (0x1UL << PWR_CR1_AVDEN_Pos)            /*!< 0x00002000 */
#define PWR_CR1_AVDEN_Pos              (13U)
#define PWR_CR1_AVDREADY               PWR_CR1_AVDREADY_Msk                    /*!< Analog Voltage Ready. */
#define PWR_CR1_AVDREADY_Msk           (0x1UL << PWR_CR1_AVDREADY_Pos)         /*!< 0x00001000 */
#define PWR_CR1_AVDREADY_Pos           (12)
#define PWR_CR1_BOOSTE                 PWR_CR1_BOOSTE_Msk                      /*!< Analog Switch VBoost control. */
#define PWR_CR1_BOOSTE_Msk             (0x1UL << PWR_CR1_BOOSTE_Pos)           /*!< 0x00000800 */
#define PWR_CR1_BOOSTE_Pos             (11U)
#define PWR_CR1_DBP                    PWR_CR1_DBP_Msk                         /*!< Disable Back-up domain Protection */
#define PWR_CR1_DBP_Msk                (0x1UL << PWR_CR1_DBP_Pos)              /*!< 0x00000100 */
#define PWR_CR1_DBP_Pos                (8U)
#define PWR_CR1_FLPS                   PWR_CR1_FLPS_Msk                        /*!< Flash low power mode in STOP */
#define PWR_CR1_FLPS_Msk               (0x1UL << PWR_CR1_FLPS_Pos)             /*!< 0x00000200 */
#define PWR_CR1_FLPS_Pos               (9U)
#define PWR_CR1_PLS                    PWR_CR1_PLS_Msk                         /*!< Programmable Voltage Detector level selection */
#define PWR_CR1_PLS_0                  (0x1UL << PWR_CR1_PLS_Pos)              /*!< 0x00000020 */
#define PWR_CR1_PLS_1                  (0x2UL << PWR_CR1_PLS_Pos)              /*!< 0x00000040 */
#define PWR_CR1_PLS_2                  (0x4UL << PWR_CR1_PLS_Pos)              /*!< 0x00000080 */
#define PWR_CR1_PLS_Msk                (0x7UL << PWR_CR1_PLS_Pos)              /*!< 0x000000E0 */
#define PWR_CR1_PLS_Pos                (5U)
#define PWR_CR1_PVDE                   PWR_CR1_PVDE_Msk                        /*!< Programmable Voltage detector enable. */
#define PWR_CR1_PVDE_Msk               (0x1UL << PWR_CR1_PVDE_Pos)             /*!< 0x00000010 */
#define PWR_CR1_PVDE_Pos               (4U)
#define PWR_CR1_SVOS                   PWR_CR1_SVOS_Msk                        /*!< System STOP mode Voltage Scaling selection. */
#define PWR_CR1_SVOS_Msk               (0x1UL << PWR_CR1_SVOS_Pos)             /*!< 0x00000001 */
#define PWR_CR1_SVOS_Pos               (0U)
#define PWR_CSR1_BREN                  PWR_CSR1_BREN_Msk                       /*!< Backup regulator enable */
#define PWR_CSR1_BREN_Msk              (0x1UL << PWR_CSR1_BREN_Pos)            /*!< 0x00000001 */
#define PWR_CSR1_BREN_Pos              (0U)
#define PWR_CSR1_BRRDY                 PWR_CSR1_BRRDY_Msk                       /*!< Backup regulator ready */
#define PWR_CSR1_BRRDY_Msk             (0x1UL << PWR_CSR1_BRRDY_Pos)            /*!< 0x00010000 */
#define PWR_CSR1_BRRDY_Pos             (16U)
#define PWR_CSR1_MONEN                 PWR_CSR1_MONEN_Msk                      /*!< VBAT and temperature monitoring enable */
#define PWR_CSR1_MONEN_Msk             (0x1UL << PWR_CSR1_MONEN_Pos)           /*!< 0x00000010 */
#define PWR_CSR1_MONEN_Pos             (4U)
#define PWR_CSR1_TEMPH                 PWR_CSR1_TEMPH_Msk                      /*!< Monitored temperature level above high threshold */
#define PWR_CSR1_TEMPH_Msk             (0x1UL << PWR_CSR1_TEMPH_Pos)           /*!< 0x00800000 */
#define PWR_CSR1_TEMPH_Pos             (23U)
#define PWR_CSR1_TEMPL                 PWR_CSR1_TEMPL_Msk                      /*!< Monitored temperature level above low threshold */
#define PWR_CSR1_TEMPL_Msk             (0x1UL << PWR_CSR1_TEMPL_Pos)           /*!< 0x00400000 */
#define PWR_CSR1_TEMPL_Pos             (22U)
#define PWR_CSR1_VBATH                 PWR_CSR1_VBATH_Msk                      /*!< Monitored VBAT level above high threshold */
#define PWR_CSR1_VBATH_Msk             (0x1UL << PWR_CSR1_VBATH_Pos)           /*!< 0x00200000 */
#define PWR_CSR1_VBATH_Pos             (21U)
#define PWR_CSR1_VBATL                 PWR_CSR1_VBATL_Msk                      /*!< Monitored VBAT level above low threshold */
#define PWR_CSR1_VBATL_Msk             (0x1UL << PWR_CSR1_VBATL_Pos)           /*!< 0x00100000 */
#define PWR_CSR1_VBATL_Pos             (20U)
#define PWR_CSR2_BYPASS                PWR_CSR2_BYPASS_Msk                      /*!< Power Management Unit bypass */
#define PWR_CSR2_BYPASS_Msk            (0x1UL << PWR_CSR2_BYPASS_Pos)           /*!< 0x00000001 */
#define PWR_CSR2_BYPASS_Pos            (0U)
#define PWR_CSR2_EN_XSPIM1             PWR_CSR2_EN_XSPIM1_Msk                   /*!< XSPIM1 external supply enable */
#define PWR_CSR2_EN_XSPIM1_Msk         (0x1UL << PWR_CSR2_EN_XSPIM1_Pos)        /*!< 0x00004000 */
#define PWR_CSR2_EN_XSPIM1_Pos         (14U)
#define PWR_CSR2_EN_XSPIM2             PWR_CSR2_EN_XSPIM2_Msk                    /*!< XSPIM2 external supply enable */
#define PWR_CSR2_EN_XSPIM2_Msk         (0x1UL << PWR_CSR2_EN_XSPIM2_Pos)         /*!< 0x00008000 */
#define PWR_CSR2_EN_XSPIM2_Pos         (15U)
#define PWR_CSR2_LDOEN                 PWR_CSR2_LDOEN_Msk                       /*!< Low Drop-Out regulator enable */
#define PWR_CSR2_LDOEN_Msk             (0x1UL << PWR_CSR2_LDOEN_Pos)            /*!< 0x00000002 */
#define PWR_CSR2_LDOEN_Pos             (1U)
#define PWR_CSR2_SDEN                  PWR_CSR2_SDEN_Msk                       /*!< SMPS Step-down converter enable */
#define PWR_CSR2_SDEN_Msk              (0x1UL << PWR_CSR2_SDEN_Pos)            /*!< 0x00000004 */
#define PWR_CSR2_SDEN_Pos              (2U)
#define PWR_CSR2_SDEXTRDY              PWR_CSR2_SDEXTRDY_Msk                    /*!< SMPS External supply ready */
#define PWR_CSR2_SDEXTRDY_Msk          (0x1UL << PWR_CSR2_SDEXTRDY_Pos)         /*!< 0x00010000 */
#define PWR_CSR2_SDEXTRDY_Pos          (16U)
#define PWR_CSR2_SDHILEVEL             PWR_CSR2_SDHILEVEL_Msk                   /*!< SMPS step-down converter voltage output for LDO or external supply */
#define PWR_CSR2_SDHILEVEL_Msk         (0x1UL << PWR_CSR2_SDHILEVEL_Pos)        /*!< 0x00000030 */
#define PWR_CSR2_SDHILEVEL_Pos         (4U)
#define PWR_CSR2_SMPSEXTHP             PWR_CSR2_SMPSEXTHP_Msk                   /*!< SMPS external power delivery selection */
#define PWR_CSR2_SMPSEXTHP_Msk         (0x1UL << PWR_CSR2_SMPSEXTHP_Pos)        /*!< 0x00000008 */
#define PWR_CSR2_SMPSEXTHP_Pos         (3U)
#define PWR_CSR2_USB33DEN              PWR_CSR2_USB33DEN_Msk                    /*!< VDD33_USB voltage level detector enable */
#define PWR_CSR2_USB33DEN_Msk          (0x1UL << PWR_CSR2_USB33DEN_Pos)         /*!< 0x01000000 */
#define PWR_CSR2_USB33DEN_Pos          (24U)
#define PWR_CSR2_USB33RDY              PWR_CSR2_USB33RDY_Msk                    /*!< USB supply ready */
#define PWR_CSR2_USB33RDY_Msk          (0x1UL << PWR_CSR2_USB33RDY_Pos)         /*!< 0x04000000 */
#define PWR_CSR2_USB33RDY_Pos          (26U)
#define PWR_CSR2_USBHSREGEN            PWR_CSR2_USBHSREGEN_Msk                  /*!< USB HS regulator enable */
#define PWR_CSR2_USBHSREGEN_Msk        (0x1UL << PWR_CSR2_USBHSREGEN_Pos)       /*!< 0x08000000 */
#define PWR_CSR2_USBHSREGEN_Pos        (27U)
#define PWR_CSR2_USBREGEN              PWR_CSR2_USBREGEN_Msk                    /*!< USB regulator enable */
#define PWR_CSR2_USBREGEN_Msk          (0x1UL << PWR_CSR2_USBREGEN_Pos)         /*!< 0x02000000 */
#define PWR_CSR2_USBREGEN_Pos          (25U)
#define PWR_CSR2_VBE                   PWR_CSR2_VBE_Msk                         /*!< VBAT charging enable */
#define PWR_CSR2_VBE_Msk               (0x1UL << PWR_CSR2_VBE_Pos)              /*!< 0x00000100 */
#define PWR_CSR2_VBE_Pos               (8U)
#define PWR_CSR2_VBRS                  PWR_CSR2_VBRS_Msk                        /*!< VBAT charging resistor selection */
#define PWR_CSR2_VBRS_Msk              (0x1UL << PWR_CSR2_VBRS_Pos)             /*!< 0x00000200 */
#define PWR_CSR2_VBRS_Pos              (9U)
#define PWR_CSR2_XSPICAP1              PWR_CSR2_XSPICAP1_Msk                    /*!< XSPI port 1 capacitor control bits */
#define PWR_CSR2_XSPICAP1_0            (0x1UL << PWR_CSR2_XSPICAP1_Pos)         /*!< 0x00000400 */
#define PWR_CSR2_XSPICAP1_1            (0x2UL << PWR_CSR2_XSPICAP1_Pos)         /*!< 0x00000800 */
#define PWR_CSR2_XSPICAP1_Msk          (0x3UL << PWR_CSR2_XSPICAP1_Pos)         /*!< 0x00000C00 */
#define PWR_CSR2_XSPICAP1_Pos          (10U)
#define PWR_CSR2_XSPICAP2              PWR_CSR2_XSPICAP2_Msk                    /*!< XSPI port 2 capacitor control bits */
#define PWR_CSR2_XSPICAP2_0            (0x1UL << PWR_CSR2_XSPICAP2_Pos)         /*!< 0x00001000 */
#define PWR_CSR2_XSPICAP2_1            (0x2UL << PWR_CSR2_XSPICAP2_Pos)         /*!< 0x00002000 */
#define PWR_CSR2_XSPICAP2_Msk          (0x3UL << PWR_CSR2_XSPICAP2_Pos)         /*!< 0x00003000 */
#define PWR_CSR2_XSPICAP2_Pos          (12U)
#define PWR_CSR3_CSSF                  PWR_CSR3_CSSF_Msk                       /*!< Clear Standby and Stop flag */
#define PWR_CSR3_CSSF_Msk              (0x1UL << PWR_CSR3_CSSF_Pos)            /*!< 0x00000002 */
#define PWR_CSR3_CSSF_Pos              (1U)
#define PWR_CSR3_PDDS                  PWR_CSR3_PDDS_Msk                       /*!< D1 domain Power Down Deepsleep  */
#define PWR_CSR3_PDDS_Msk              (0x1UL << PWR_CSR3_PDDS_Pos)            /*!< 0x00000001 */
#define PWR_CSR3_PDDS_Pos              (0U)
#define PWR_CSR3_SBF                   PWR_CSR3_SBF_Msk                         /*!< System STANDBY Flag */
#define PWR_CSR3_SBF_Msk               (0x1UL << PWR_CSR3_SBF_Pos)              /*!< 0x00000100 */
#define PWR_CSR3_SBF_Pos               (9U)
#define PWR_CSR3_STOPF                 PWR_CSR3_STOPF_Msk                       /*!< STOP Flag */
#define PWR_CSR3_STOPF_Msk             (0x1UL << PWR_CSR3_STOPF_Pos)            /*!< 0x00000080 */
#define PWR_CSR3_STOPF_Pos             (8U)
#define PWR_CSR4_VOS                   PWR_CSR4_VOS_Msk                       /*!< Voltage Scaling selection according performance */
#define PWR_CSR4_VOSRDY                PWR_CSR4_VOSRDY_Msk                    /*!< VOSRDY: VOS Ready bit for VCORE voltage scaling output selection. */
#define PWR_CSR4_VOSRDY_Msk            (0x1UL << PWR_CSR4_VOSRDY_Pos)         /*!< 0x00000002 */
#define PWR_CSR4_VOSRDY_Pos            (1U)
#define PWR_CSR4_VOS_Msk               (0x1UL << PWR_CSR4_VOS_Pos)            /*!< 0x00000001 */
#define PWR_CSR4_VOS_Pos               (0U)
#define PWR_SR1_ACTVOSRDY              PWR_SR1_ACTVOSRDY_Msk                    /*!< Ready bit for current actual used VOS for VDD11 Voltage Scaling  */
#define PWR_SR1_ACTVOSRDY_Msk          (0x1UL << PWR_SR1_ACTVOSRDY_Pos)         /*!< 0x00000002 */
#define PWR_SR1_ACTVOSRDY_Pos          (1U)
#define PWR_SR1_AVDO                   PWR_SR1_AVDO_Msk                         /*!< Analog Voltage Detect Output on VDDA */
#define PWR_SR1_AVDO_Msk               (0x1UL << PWR_SR1_AVDO_Pos)              /*!< 0x00002000 */
#define PWR_SR1_AVDO_Pos               (13U)
#define PWR_SR1_PVDO                   PWR_SR1_PVDO_Msk                         /*!< Programmable Voltage Detect Output */
#define PWR_SR1_PVDO_Msk               (0x1UL << PWR_SR1_PVDO_Pos)              /*!< 0x00000010 */
#define PWR_SR1_PVDO_Pos               (4U)
#define PWR_UCPDR_UCPD_DBDIS           PWR_UCPDR_UCPD_DBDIS_Msk                /*!< UCPD dead battery disable */
#define PWR_UCPDR_UCPD_DBDIS_Msk       (0x1UL << PWR_UCPDR_UCPD_DBDIS_Pos)     /*!< 0x00000001 */
#define PWR_UCPDR_UCPD_DBDIS_Pos       (0U)
#define PWR_UCPDR_UCPD_STBY            PWR_UCPDR_UCPD_STBY_Msk                 /*!< UCPD Standby mode */
#define PWR_UCPDR_UCPD_STBY_Msk        (0x1UL << PWR_UCPDR_UCPD_STBY_Pos)      /*!< 0x00000002 */
#define PWR_UCPDR_UCPD_STBY_Pos        (1U)
#define PWR_WKUPCR_WKUPC               PWR_WKUPCR_WKUPC_Msk                    /*!< Clear Wakeup Pin Flag 1 to 4 */
#define PWR_WKUPCR_WKUPC1              PWR_WKUPCR_WKUPC1_Msk                   /*!< Clear Wakeup Pin Flag 1 */
#define PWR_WKUPCR_WKUPC1_Msk          (0x1UL << PWR_WKUPCR_WKUPC1_Pos)        /*!< 0x00000001 */
#define PWR_WKUPCR_WKUPC1_Pos          (0U)
#define PWR_WKUPCR_WKUPC2              PWR_WKUPCR_WKUPC2_Msk                   /*!< Clear Wakeup Pin Flag 2 */
#define PWR_WKUPCR_WKUPC2_Msk          (0x1UL << PWR_WKUPCR_WKUPC2_Pos)        /*!< 0x00000002 */
#define PWR_WKUPCR_WKUPC2_Pos          (1U)
#define PWR_WKUPCR_WKUPC3              PWR_WKUPCR_WKUPC3_Msk                   /*!< Clear Wakeup Pin Flag 3 */
#define PWR_WKUPCR_WKUPC3_Msk          (0x1UL << PWR_WKUPCR_WKUPC3_Pos)        /*!< 0x00000004 */
#define PWR_WKUPCR_WKUPC3_Pos          (2U)
#define PWR_WKUPCR_WKUPC4              PWR_WKUPCR_WKUPC4_Msk                   /*!< Clear Wakeup Pin Flag 4 */
#define PWR_WKUPCR_WKUPC4_Msk          (0x1UL << PWR_WKUPCR_WKUPC4_Pos)        /*!< 0x00000008 */
#define PWR_WKUPCR_WKUPC4_Pos          (3U)
#define PWR_WKUPCR_WKUPC_Msk           (0xFUL << PWR_WKUPCR_WKUPC_Pos)         /*!< 0x0000000F */
#define PWR_WKUPCR_WKUPC_Pos           (0U)
#define PWR_WKUPEPR_WKUPEN1            PWR_WKUPEPR_WKUPEN1_Msk                 /*!< Enable Wakeup Pin WKUP1 */
#define PWR_WKUPEPR_WKUPEN1_Msk        (0x1UL << PWR_WKUPEPR_WKUPEN1_Pos)      /*!< 0x00000001 */
#define PWR_WKUPEPR_WKUPEN1_Pos        (0U)
#define PWR_WKUPEPR_WKUPEN2            PWR_WKUPEPR_WKUPEN2_Msk                 /*!< Enable Wakeup Pin WKUP2 */
#define PWR_WKUPEPR_WKUPEN2_Msk        (0x1UL << PWR_WKUPEPR_WKUPEN2_Pos)      /*!< 0x00000002 */
#define PWR_WKUPEPR_WKUPEN2_Pos        (1U)
#define PWR_WKUPEPR_WKUPEN3            PWR_WKUPEPR_WKUPEN3_Msk                 /*!< Enable Wakeup Pin WKUP3 */
#define PWR_WKUPEPR_WKUPEN3_Msk        (0x1UL << PWR_WKUPEPR_WKUPEN3_Pos)      /*!< 0x00000004 */
#define PWR_WKUPEPR_WKUPEN3_Pos        (2U)
#define PWR_WKUPEPR_WKUPEN4            PWR_WKUPEPR_WKUPEN4_Msk                 /*!< Enable Wakeup Pin WKUP4 */
#define PWR_WKUPEPR_WKUPEN4_Msk        (0x1UL << PWR_WKUPEPR_WKUPEN4_Pos)      /*!< 0x00000008 */
#define PWR_WKUPEPR_WKUPEN4_Pos        (3U)
#define PWR_WKUPEPR_WKUPP1_Pos         (8U)
#define PWR_WKUPEPR_WKUPPUPD1          PWR_WKUPEPR_WKUPPUPD1_Msk               /*!< Wakeup Pin pull configuration for WKUP1 */
#define PWR_WKUPEPR_WKUPPUPD1_Msk      (0x3UL << PWR_WKUPEPR_WKUPPUPD1_Pos)    /*!< 0x00030000 */
#define PWR_WKUPEPR_WKUPPUPD1_Pos      (16U)
#define PWR_WKUPFR_WKUPF1              PWR_WKUPFR_WKUPF1_Msk                   /*!< Wakeup Pin Flag 1 */
#define PWR_WKUPFR_WKUPF1_Msk          (0x1UL << PWR_WKUPFR_WKUPF1_Pos)        /*!< 0x00000001 */
#define PWR_WKUPFR_WKUPF1_Pos          (0U)
#define PWR_WKUPFR_WKUPF2              PWR_WKUPFR_WKUPF2_Msk                   /*!< Wakeup Pin Flag 2 */
#define PWR_WKUPFR_WKUPF2_Msk          (0x1UL << PWR_WKUPFR_WKUPF2_Pos)        /*!< 0x00000002 */
#define PWR_WKUPFR_WKUPF2_Pos          (1U)
#define PWR_WKUPFR_WKUPF3              PWR_WKUPFR_WKUPF3_Msk                   /*!< Wakeup Pin Flag 3 */
#define PWR_WKUPFR_WKUPF3_Msk          (0x1UL << PWR_WKUPFR_WKUPF3_Pos)        /*!< 0x00000004 */
#define PWR_WKUPFR_WKUPF3_Pos          (2U)
#define PWR_WKUPFR_WKUPF4              PWR_WKUPFR_WKUPF4_Msk                   /*!< Wakeup Pin Flag 4 */
#define PWR_WKUPFR_WKUPF4_Msk          (0x1UL << PWR_WKUPFR_WKUPF4_Pos)        /*!< 0x00000008 */
#define PWR_WKUPFR_WKUPF4_Pos          (3U)
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
#define RCC_AHB1LPENR_UCPDCTRL         RCC_AHB1LPENR_UCPDCTRL_Msk
#define RCC_AHB1LPENR_UCPDCTRL_Msk     (0x1UL << RCC_AHB1LPENR_UCPDCTRL_Pos)  /*!< 0x01000000 */
#define RCC_AHB1LPENR_UCPDCTRL_Pos     (24U)
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
#define RCC_APBCFGR_PPRE1              RCC_APBCFGR_PPRE1_Msk                   /*!< PPRE1[2:0] bits */
#define RCC_APBCFGR_PPRE1_0            (0x1UL << RCC_APBCFGR_PPRE1_Pos)        /*!< 0x00000001 */
#define RCC_APBCFGR_PPRE1_1            (0x2UL << RCC_APBCFGR_PPRE1_Pos)        /*!< 0x00000002 */
#define RCC_APBCFGR_PPRE1_2            (0x4UL << RCC_APBCFGR_PPRE1_Pos)        /*!< 0x00000004 */
#define RCC_APBCFGR_PPRE1_Msk          (0x7UL << RCC_APBCFGR_PPRE1_Pos)        /*!< 0x00000007 */
#define RCC_APBCFGR_PPRE1_Pos          (0U)
#define RCC_APBCFGR_PPRE2              RCC_APBCFGR_PPRE2_Msk                   /*!< PPRE2[2:0] bits */
#define RCC_APBCFGR_PPRE2_0            (0x1UL << RCC_APBCFGR_PPRE2_Pos)        /*!< 0x00000010 */
#define RCC_APBCFGR_PPRE2_1            (0x2UL << RCC_APBCFGR_PPRE2_Pos)        /*!< 0x00000020 */
#define RCC_APBCFGR_PPRE2_2            (0x4UL << RCC_APBCFGR_PPRE2_Pos)        /*!< 0x00000040 */
#define RCC_APBCFGR_PPRE2_Msk          (0x7UL << RCC_APBCFGR_PPRE2_Pos)        /*!< 0x00000070 */
#define RCC_APBCFGR_PPRE2_Pos          (4U)
#define RCC_APBCFGR_PPRE4              RCC_APBCFGR_PPRE4_Msk                   /*!< PPRE4[2:0] bits */
#define RCC_APBCFGR_PPRE4_0            (0x1UL << RCC_APBCFGR_PPRE4_Pos)        /*!< 0x00000100 */
#define RCC_APBCFGR_PPRE4_1            (0x2UL << RCC_APBCFGR_PPRE4_Pos)        /*!< 0x00000200 */
#define RCC_APBCFGR_PPRE4_2            (0x4UL << RCC_APBCFGR_PPRE4_Pos)        /*!< 0x00000400 */
#define RCC_APBCFGR_PPRE4_Msk          (0x7UL << RCC_APBCFGR_PPRE4_Pos)        /*!< 0x00000700 */
#define RCC_APBCFGR_PPRE4_Pos          (8U)
#define RCC_APBCFGR_PPRE5              RCC_APBCFGR_PPRE5_Msk                   /*!< PPRE5[2:0] bits */
#define RCC_APBCFGR_PPRE5_0            (0x1UL << RCC_APBCFGR_PPRE5_Pos)        /*!< 0x00001000 */
#define RCC_APBCFGR_PPRE5_1            (0x2UL << RCC_APBCFGR_PPRE5_Pos)        /*!< 0x00002000 */
#define RCC_APBCFGR_PPRE5_2            (0x4UL << RCC_APBCFGR_PPRE5_Pos)        /*!< 0x00004000 */
#define RCC_APBCFGR_PPRE5_Msk          (0x7UL << RCC_APBCFGR_PPRE5_Pos)        /*!< 0x00007000 */
#define RCC_APBCFGR_PPRE5_Pos          (12U)
#define RCC_BDCR_LSEBYP                RCC_BDCR_LSEBYP_Msk
#define RCC_BDCR_LSEBYP_Msk            (0x1UL << RCC_BDCR_LSEBYP_Pos)          /*!< 0x00000004 */
#define RCC_BDCR_LSEBYP_Pos            (2U)
#define RCC_BDCR_LSECSSD               RCC_BDCR_LSECSSD_Msk
#define RCC_BDCR_LSECSSD_Msk           (0x1UL << RCC_BDCR_LSECSSD_Pos)         /*!< 0x00000040 */
#define RCC_BDCR_LSECSSD_Pos           (6U)
#define RCC_BDCR_LSECSSON              RCC_BDCR_LSECSSON_Msk
#define RCC_BDCR_LSECSSON_Msk          (0x1UL << RCC_BDCR_LSECSSON_Pos)        /*!< 0x00000020 */
#define RCC_BDCR_LSECSSON_Pos          (5U)
#define RCC_BDCR_LSECSSRA              RCC_BDCR_LSECSSRA_Msk
#define RCC_BDCR_LSECSSRA_Msk          (0x1UL << RCC_BDCR_LSECSSRA_Pos)        /*!< 0x00001000 */
#define RCC_BDCR_LSECSSRA_Pos          (12U)
#define RCC_BDCR_LSEDRV                RCC_BDCR_LSEDRV_Msk
#define RCC_BDCR_LSEDRV_0              (0x1UL << RCC_BDCR_LSEDRV_Pos)          /*!< 0x00000008 */
#define RCC_BDCR_LSEDRV_1              (0x2UL << RCC_BDCR_LSEDRV_Pos)          /*!< 0x00000010 */
#define RCC_BDCR_LSEDRV_Msk            (0x3UL << RCC_BDCR_LSEDRV_Pos)          /*!< 0x00000018 */
#define RCC_BDCR_LSEDRV_Pos            (3U)
#define RCC_BDCR_LSEEXT                RCC_BDCR_LSEEXT_Msk
#define RCC_BDCR_LSEEXT_Msk            (0x1UL << RCC_BDCR_LSEEXT_Pos)          /*!< 0x00000080 */
#define RCC_BDCR_LSEEXT_Pos            (7U)
#define RCC_BDCR_LSEON                 RCC_BDCR_LSEON_Msk
#define RCC_BDCR_LSEON_Msk             (0x1UL << RCC_BDCR_LSEON_Pos)           /*!< 0x00000001 */
#define RCC_BDCR_LSEON_Pos             (0U)
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
#define RCC_BMCFGR_BMPRE_0             (0x1UL << RCC_BMCFGR_BMPRE_Pos)         /*!< 0x00000001 */
#define RCC_BMCFGR_BMPRE_1             (0x2UL << RCC_BMCFGR_BMPRE_Pos)         /*!< 0x00000002 */
#define RCC_BMCFGR_BMPRE_2             (0x4UL << RCC_BMCFGR_BMPRE_Pos)         /*!< 0x00000004 */
#define RCC_BMCFGR_BMPRE_3             (0x8UL << RCC_BMCFGR_BMPRE_Pos)         /*!< 0x00000008 */
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
#define RCC_CDCFGR_CPRE_0              (0x1UL << RCC_CDCFGR_CPRE_Pos)          /*!< 0x00000001 */
#define RCC_CDCFGR_CPRE_1              (0x2UL << RCC_CDCFGR_CPRE_Pos)          /*!< 0x00000002 */
#define RCC_CDCFGR_CPRE_2              (0x4UL << RCC_CDCFGR_CPRE_Pos)          /*!< 0x00000004 */
#define RCC_CDCFGR_CPRE_3              (0x8UL << RCC_CDCFGR_CPRE_Pos)          /*!< 0x00000008 */
#define RCC_CDCFGR_CPRE_Msk            (0xFUL << RCC_CDCFGR_CPRE_Pos)          /*!< 0x0000000F */
#define RCC_CDCFGR_CPRE_Pos            (0U)
#define RCC_CFGR_MCO1PRE               RCC_CFGR_MCO1PRE_Msk                    /*!< MCO1 configuration */
#define RCC_CFGR_MCO1PRE_0             (0x1UL << RCC_CFGR_MCO1PRE_Pos)         /*!< 0x00040000 */
#define RCC_CFGR_MCO1PRE_1             (0x2UL << RCC_CFGR_MCO1PRE_Pos)         /*!< 0x00080000 */
#define RCC_CFGR_MCO1PRE_2             (0x4UL << RCC_CFGR_MCO1PRE_Pos)         /*!< 0x00100000 */
#define RCC_CFGR_MCO1PRE_3             (0x8UL << RCC_CFGR_MCO1PRE_Pos)         /*!< 0x00200000 */
#define RCC_CFGR_MCO1PRE_Msk           (0xFUL << RCC_CFGR_MCO1PRE_Pos)         /*!< 0x003C0000 */
#define RCC_CFGR_MCO1PRE_Pos           (18U)
#define RCC_CFGR_MCO1SEL               RCC_CFGR_MCO1SEL_Msk                    /*!< MCO1SEL [2:0] bits (MCO1 clock output selection) */
#define RCC_CFGR_MCO1SEL_0             (0x1UL <<  RCC_CFGR_MCO1SEL_Pos)        /*!< 0x00400000 */
#define RCC_CFGR_MCO1SEL_1             (0x2UL <<  RCC_CFGR_MCO1SEL_Pos)        /*!< 0x00800000 */
#define RCC_CFGR_MCO1SEL_2             (0x4UL <<  RCC_CFGR_MCO1SEL_Pos)        /*!< 0x01000000 */
#define RCC_CFGR_MCO1SEL_Msk           (0x7UL << RCC_CFGR_MCO1SEL_Pos)         /*!< 0x01C00000 */
#define RCC_CFGR_MCO1SEL_Pos           (22U)
#define RCC_CFGR_MCO2PRE               RCC_CFGR_MCO2PRE_Msk                    /*!< MCO2 configuration */
#define RCC_CFGR_MCO2PRE_0             (0x1UL << RCC_CFGR_MCO2PRE_Pos)         /*!< 0x02000000 */
#define RCC_CFGR_MCO2PRE_1             (0x2UL << RCC_CFGR_MCO2PRE_Pos)         /*!< 0x04000000 */
#define RCC_CFGR_MCO2PRE_2             (0x4UL << RCC_CFGR_MCO2PRE_Pos)         /*!< 0x08000000 */
#define RCC_CFGR_MCO2PRE_3             (0x8UL << RCC_CFGR_MCO2PRE_Pos)         /*!< 0x10000000 */
#define RCC_CFGR_MCO2PRE_Msk           (0xFUL << RCC_CFGR_MCO2PRE_Pos)         /*!< 0x1E000000 */
#define RCC_CFGR_MCO2PRE_Pos           (25U)
#define RCC_CFGR_MCO2SEL               RCC_CFGR_MCO2SEL_Msk                    /*!< MCO2SEL [2:0] bits (MCO2 clock output selection) */
#define RCC_CFGR_MCO2SEL_0             (0x1UL << RCC_CFGR_MCO2SEL_Pos)         /*!< 0x20000000 */
#define RCC_CFGR_MCO2SEL_1             (0x2UL << RCC_CFGR_MCO2SEL_Pos)         /*!< 0x40000000 */
#define RCC_CFGR_MCO2SEL_2             (0x4UL << RCC_CFGR_MCO2SEL_Pos)         /*!< 0x80000000 */
#define RCC_CFGR_MCO2SEL_Msk           (0x7UL << RCC_CFGR_MCO2SEL_Pos)         /*!< 0xE0000000 */
#define RCC_CFGR_MCO2SEL_Pos           (29U)
#define RCC_CFGR_RTCPRE                RCC_CFGR_RTCPRE_Msk                     /*!< RTCPRE[5:0] bits (HSE division factor for RTC clock) */
#define RCC_CFGR_RTCPRE_0              (0x01UL << RCC_CFGR_RTCPRE_Pos)         /*!< 0x00000100 */
#define RCC_CFGR_RTCPRE_1              (0x02UL << RCC_CFGR_RTCPRE_Pos)         /*!< 0x00000200 */
#define RCC_CFGR_RTCPRE_2              (0x04UL << RCC_CFGR_RTCPRE_Pos)         /*!< 0x00000400 */
#define RCC_CFGR_RTCPRE_3              (0x08UL << RCC_CFGR_RTCPRE_Pos)         /*!< 0x00000800 */
#define RCC_CFGR_RTCPRE_4              (0x10UL << RCC_CFGR_RTCPRE_Pos)         /*!< 0x00001000 */
#define RCC_CFGR_RTCPRE_5              (0x20UL << RCC_CFGR_RTCPRE_Pos)         /*!< 0x00002000 */
#define RCC_CFGR_RTCPRE_Msk            (0x3FUL << RCC_CFGR_RTCPRE_Pos)         /*!< 0x00003F00 */
#define RCC_CFGR_RTCPRE_Pos            (8U)
#define RCC_CFGR_STOPKERWUCK           RCC_CFGR_STOPKERWUCK_Msk                /*!< Kernel Clock Selection after a Wake Up from Stop */
#define RCC_CFGR_STOPKERWUCK_Msk       (0x1UL << RCC_CFGR_STOPKERWUCK_Pos)     /*!< 0x00000080 */
#define RCC_CFGR_STOPKERWUCK_Pos       (7U)
#define RCC_CFGR_STOPWUCK              RCC_CFGR_STOPWUCK_Msk                   /*!< Wake Up from stop and CSS backup clock selection */
#define RCC_CFGR_STOPWUCK_Msk          (0x1UL << RCC_CFGR_STOPWUCK_Pos)        /*!< 0x00000040 */
#define RCC_CFGR_STOPWUCK_Pos          (6U)
#define RCC_CFGR_SW                    RCC_CFGR_SW_Msk                         /*!< SW[2:0] bits (System clock switch) */
#define RCC_CFGR_SWS                   RCC_CFGR_SWS_Msk                        /*!< SWS[2:0] bits (System clock switch status) */
#define RCC_CFGR_SWS_0                 (0x1UL << RCC_CFGR_SWS_Pos)             /*!< 0x00000008 */
#define RCC_CFGR_SWS_1                 (0x2UL << RCC_CFGR_SWS_Pos)             /*!< 0x00000010 */
#define RCC_CFGR_SWS_Msk               (0x7UL << RCC_CFGR_SWS_Pos)             /*!< 0x00000038 */
#define RCC_CFGR_SWS_Pos               (3U)
#define RCC_CFGR_SW_0                  (0x1UL << RCC_CFGR_SW_Pos)              /*!< 0x00000001 */
#define RCC_CFGR_SW_1                  (0x2UL << RCC_CFGR_SW_Pos)              /*!< 0x00000002 */
#define RCC_CFGR_SW_Msk                (0x7UL << RCC_CFGR_SW_Pos)              /*!< 0x00000007 */
#define RCC_CFGR_SW_Pos                (0U)
#define RCC_CFGR_TIMPRE                RCC_CFGR_TIMPRE_Msk                     /*!< TIMPRE configuration */
#define RCC_CFGR_TIMPRE_Msk            (0x1UL << RCC_CFGR_TIMPRE_Pos)          /*!< 0x00008000 */
#define RCC_CFGR_TIMPRE_Pos            (15U)
#define RCC_CICR_CSIRDYC               RCC_CICR_CSIRDYC_Msk
#define RCC_CICR_CSIRDYC_Msk           (0x1UL << RCC_CICR_CSIRDYC_Pos)         /*!< 0x00000010 */
#define RCC_CICR_CSIRDYC_Pos           (4U)
#define RCC_CICR_HSECSSC               RCC_CICR_HSECSSC_Msk
#define RCC_CICR_HSECSSC_Msk           (0x1UL << RCC_CICR_HSECSSC_Pos)         /*!< 0x00000400 */
#define RCC_CICR_HSECSSC_Pos           (10U)
#define RCC_CICR_HSERDYC               RCC_CICR_HSERDYC_Msk
#define RCC_CICR_HSERDYC_Msk           (0x1UL << RCC_CICR_HSERDYC_Pos)         /*!< 0x00000008 */
#define RCC_CICR_HSERDYC_Pos           (3U)
#define RCC_CICR_HSI48RDYC             RCC_CICR_HSI48RDYC_Msk
#define RCC_CICR_HSI48RDYC_Msk         (0x1UL << RCC_CICR_HSI48RDYC_Pos)       /*!< 0x00000020 */
#define RCC_CICR_HSI48RDYC_Pos         (5U)
#define RCC_CICR_HSIRDYC               RCC_CICR_HSIRDYC_Msk
#define RCC_CICR_HSIRDYC_Msk           (0x1UL << RCC_CICR_HSIRDYC_Pos)         /*!< 0x00000004 */
#define RCC_CICR_HSIRDYC_Pos           (2U)
#define RCC_CICR_LSECSSC               RCC_CICR_LSECSSC_Msk
#define RCC_CICR_LSECSSC_Msk           (0x1UL << RCC_CICR_LSECSSC_Pos)         /*!< 0x00000200 */
#define RCC_CICR_LSECSSC_Pos           (9U)
#define RCC_CICR_LSERDYC               RCC_CICR_LSERDYC_Msk
#define RCC_CICR_LSERDYC_Msk           (0x1UL << RCC_CICR_LSERDYC_Pos)         /*!< 0x00000002 */
#define RCC_CICR_LSERDYC_Pos           (1U)
#define RCC_CICR_LSIRDYC               RCC_CICR_LSIRDYC_Msk
#define RCC_CICR_LSIRDYC_Msk           (0x1UL << RCC_CICR_LSIRDYC_Pos)         /*!< 0x00000001 */
#define RCC_CICR_LSIRDYC_Pos           (0U)
#define RCC_CICR_PLL1RDYC              RCC_CICR_PLL1RDYC_Msk
#define RCC_CICR_PLL1RDYC_Msk          (0x1UL << RCC_CICR_PLL1RDYC_Pos)        /*!< 0x00000040 */
#define RCC_CICR_PLL1RDYC_Pos          (6U)
#define RCC_CICR_PLL2RDYC              RCC_CICR_PLL2RDYC_Msk
#define RCC_CICR_PLL2RDYC_Msk          (0x1UL << RCC_CICR_PLL2RDYC_Pos)        /*!< 0x00000080 */
#define RCC_CICR_PLL2RDYC_Pos          (7U)
#define RCC_CICR_PLL3RDYC              RCC_CICR_PLL3RDYC_Msk
#define RCC_CICR_PLL3RDYC_Msk          (0x1UL << RCC_CICR_PLL3RDYC_Pos)        /*!< 0x00000100 */
#define RCC_CICR_PLL3RDYC_Pos          (8U)
#define RCC_CIER_CSIRDYIE              RCC_CIER_CSIRDYIE_Msk
#define RCC_CIER_CSIRDYIE_Msk          (0x1UL << RCC_CIER_CSIRDYIE_Pos)        /*!< 0x00000010 */
#define RCC_CIER_CSIRDYIE_Pos          (4U)
#define RCC_CIER_HSERDYIE              RCC_CIER_HSERDYIE_Msk
#define RCC_CIER_HSERDYIE_Msk          (0x1UL << RCC_CIER_HSERDYIE_Pos)        /*!< 0x00000008 */
#define RCC_CIER_HSERDYIE_Pos          (3U)
#define RCC_CIER_HSI48RDYIE            RCC_CIER_HSI48RDYIE_Msk
#define RCC_CIER_HSI48RDYIE_Msk        (0x1UL << RCC_CIER_HSI48RDYIE_Pos)      /*!< 0x00000020 */
#define RCC_CIER_HSI48RDYIE_Pos        (5U)
#define RCC_CIER_HSIRDYIE              RCC_CIER_HSIRDYIE_Msk
#define RCC_CIER_HSIRDYIE_Msk          (0x1UL << RCC_CIER_HSIRDYIE_Pos)        /*!< 0x00000004 */
#define RCC_CIER_HSIRDYIE_Pos          (2U)
#define RCC_CIER_LSECSSIE              RCC_CIER_LSECSSIE_Msk
#define RCC_CIER_LSECSSIE_Msk          (0x1UL << RCC_CIER_LSECSSIE_Pos)        /*!< 0x00000200 */
#define RCC_CIER_LSECSSIE_Pos          (9U)
#define RCC_CIER_LSERDYIE              RCC_CIER_LSERDYIE_Msk
#define RCC_CIER_LSERDYIE_Msk          (0x1UL << RCC_CIER_LSERDYIE_Pos)        /*!< 0x00000002 */
#define RCC_CIER_LSERDYIE_Pos          (1U)
#define RCC_CIER_LSIRDYIE              RCC_CIER_LSIRDYIE_Msk
#define RCC_CIER_LSIRDYIE_Msk          (0x1UL << RCC_CIER_LSIRDYIE_Pos)        /*!< 0x00000001 */
#define RCC_CIER_LSIRDYIE_Pos          (0U)
#define RCC_CIER_PLL1RDYIE             RCC_CIER_PLL1RDYIE_Msk
#define RCC_CIER_PLL1RDYIE_Msk         (0x1UL << RCC_CIER_PLL1RDYIE_Pos)       /*!< 0x00000040 */
#define RCC_CIER_PLL1RDYIE_Pos         (6U)
#define RCC_CIER_PLL2RDYIE             RCC_CIER_PLL2RDYIE_Msk
#define RCC_CIER_PLL2RDYIE_Msk         (0x1UL << RCC_CIER_PLL2RDYIE_Pos)       /*!< 0x00000080 */
#define RCC_CIER_PLL2RDYIE_Pos         (7U)
#define RCC_CIER_PLL3RDYIE             RCC_CIER_PLL3RDYIE_Msk
#define RCC_CIER_PLL3RDYIE_Msk         (0x1UL << RCC_CIER_PLL3RDYIE_Pos)       /*!< 0x00000100 */
#define RCC_CIER_PLL3RDYIE_Pos         (8U)
#define RCC_CIFR_CSIRDYF               RCC_CIFR_CSIRDYF_Msk
#define RCC_CIFR_CSIRDYF_Msk           (0x1UL << RCC_CIFR_CSIRDYF_Pos)         /*!< 0x00000010 */
#define RCC_CIFR_CSIRDYF_Pos           (4U)
#define RCC_CIFR_HSECSSF               RCC_CIFR_HSECSSF_Msk
#define RCC_CIFR_HSECSSF_Msk           (0x1UL << RCC_CIFR_HSECSSF_Pos)         /*!< 0x00000400 */
#define RCC_CIFR_HSECSSF_Pos           (10U)
#define RCC_CIFR_HSERDYF               RCC_CIFR_HSERDYF_Msk
#define RCC_CIFR_HSERDYF_Msk           (0x1UL << RCC_CIFR_HSERDYF_Pos)         /*!< 0x00000008 */
#define RCC_CIFR_HSERDYF_Pos           (3U)
#define RCC_CIFR_HSI48RDYF             RCC_CIFR_HSI48RDYF_Msk
#define RCC_CIFR_HSI48RDYF_Msk         (0x1UL << RCC_CIFR_HSI48RDYF_Pos)       /*!< 0x00000020 */
#define RCC_CIFR_HSI48RDYF_Pos         (5U)
#define RCC_CIFR_HSIRDYF               RCC_CIFR_HSIRDYF_Msk
#define RCC_CIFR_HSIRDYF_Msk           (0x1UL << RCC_CIFR_HSIRDYF_Pos)         /*!< 0x00000004 */
#define RCC_CIFR_HSIRDYF_Pos           (2U)
#define RCC_CIFR_LSECSSF               RCC_CIFR_LSECSSF_Msk
#define RCC_CIFR_LSECSSF_Msk           (0x1UL << RCC_CIFR_LSECSSF_Pos)         /*!< 0x00000200 */
#define RCC_CIFR_LSECSSF_Pos           (9U)
#define RCC_CIFR_LSERDYF               RCC_CIFR_LSERDYF_Msk
#define RCC_CIFR_LSERDYF_Msk           (0x1UL << RCC_CIFR_LSERDYF_Pos)         /*!< 0x00000002 */
#define RCC_CIFR_LSERDYF_Pos           (1U)
#define RCC_CIFR_LSIRDYF               RCC_CIFR_LSIRDYF_Msk
#define RCC_CIFR_LSIRDYF_Msk           (0x1UL << RCC_CIFR_LSIRDYF_Pos)         /*!< 0x00000001 */
#define RCC_CIFR_LSIRDYF_Pos           (0U)
#define RCC_CIFR_PLL1RDYF              RCC_CIFR_PLL1RDYF_Msk
#define RCC_CIFR_PLL1RDYF_Msk          (0x1UL << RCC_CIFR_PLL1RDYF_Pos)        /*!< 0x00000040 */
#define RCC_CIFR_PLL1RDYF_Pos          (6U)
#define RCC_CIFR_PLL2RDYF              RCC_CIFR_PLL2RDYF_Msk
#define RCC_CIFR_PLL2RDYF_Msk          (0x1UL << RCC_CIFR_PLL2RDYF_Pos)        /*!< 0x00000080 */
#define RCC_CIFR_PLL2RDYF_Pos          (7U)
#define RCC_CIFR_PLL3RDYF              RCC_CIFR_PLL3RDYF_Msk
#define RCC_CIFR_PLL3RDYF_Msk          (0x1UL << RCC_CIFR_PLL3RDYF_Pos)        /*!< 0x00000100 */
#define RCC_CIFR_PLL3RDYF_Pos          (8U)
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
#define RCC_CKPROTR_FMCCKP             RCC_CKPROTR_FMCCKP_Msk
#define RCC_CKPROTR_FMCCKP_Msk         (0x1UL << RCC_CKPROTR_FMCCKP_Pos)       /*!< 0x00000002 */
#define RCC_CKPROTR_FMCCKP_Pos         (1U)
#define RCC_CKPROTR_FMCSWP             RCC_CKPROTR_FMCSWP_Msk
#define RCC_CKPROTR_FMCSWP_0           (0x1UL << RCC_CKPROTR_FMCSWP_Pos)       /*!< 0x00001000 */
#define RCC_CKPROTR_FMCSWP_1           (0x2UL << RCC_CKPROTR_FMCSWP_Pos)       /*!< 0x00002000 */
#define RCC_CKPROTR_FMCSWP_2           (0x4UL << RCC_CKPROTR_FMCSWP_Pos)       /*!< 0x00004000 */
#define RCC_CKPROTR_FMCSWP_Msk         (0x7UL << RCC_CKPROTR_FMCSWP_Pos)       /*!< 0x00007000 */
#define RCC_CKPROTR_FMCSWP_Pos         (12U)
#define RCC_CKPROTR_XSPI1SWP           RCC_CKPROTR_XSPI1SWP_Msk
#define RCC_CKPROTR_XSPI1SWP_0         (0x1UL << RCC_CKPROTR_XSPI1SWP_Pos)     /*!< 0x00000010 */
#define RCC_CKPROTR_XSPI1SWP_1         (0x2UL << RCC_CKPROTR_XSPI1SWP_Pos)     /*!< 0x00000020 */
#define RCC_CKPROTR_XSPI1SWP_2         (0x4UL << RCC_CKPROTR_XSPI1SWP_Pos)     /*!< 0x00000040 */
#define RCC_CKPROTR_XSPI1SWP_Msk       (0x7UL << RCC_CKPROTR_XSPI1SWP_Pos)     /*!< 0x00000070 */
#define RCC_CKPROTR_XSPI1SWP_Pos       (4U)
#define RCC_CKPROTR_XSPI2SWP           RCC_CKPROTR_XSPI2SWP_Msk
#define RCC_CKPROTR_XSPI2SWP_0         (0x1UL << RCC_CKPROTR_XSPI2SWP_Pos)     /*!< 0x00000100 */
#define RCC_CKPROTR_XSPI2SWP_1         (0x2UL << RCC_CKPROTR_XSPI2SWP_Pos)     /*!< 0x00000200 */
#define RCC_CKPROTR_XSPI2SWP_2         (0x4UL << RCC_CKPROTR_XSPI2SWP_Pos)     /*!< 0x00000400 */
#define RCC_CKPROTR_XSPI2SWP_Msk       (0x7UL << RCC_CKPROTR_XSPI2SWP_Pos)     /*!< 0x00000700 */
#define RCC_CKPROTR_XSPI2SWP_Pos       (8U)
#define RCC_CKPROTR_XSPICKP            RCC_CKPROTR_XSPICKP_Msk
#define RCC_CKPROTR_XSPICKP_Msk        (0x1UL << RCC_CKPROTR_XSPICKP_Pos)      /*!< 0x00000001 */
#define RCC_CKPROTR_XSPICKP_Pos        (0U)
#define RCC_CRRCR_HSI48CAL             RCC_CRRCR_HSI48CAL_Msk                  /*!< HSI48CAL[9:0] bits */
#define RCC_CRRCR_HSI48CAL_Msk         (0x3FFUL << RCC_CRRCR_HSI48CAL_Pos)     /*!< 0x000003FF */
#define RCC_CRRCR_HSI48CAL_Pos         (0U)
#define RCC_CR_CSIKERON                RCC_CR_CSIKERON_Msk                     /*!< Internal RC 4MHz oscillator clock enable in Stop mode */
#define RCC_CR_CSIKERON_Msk            (0x1UL << RCC_CR_CSIKERON_Pos)          /*!< 0x00000200 */
#define RCC_CR_CSIKERON_Pos            (9U)
#define RCC_CR_CSION                   RCC_CR_CSION_Msk                        /*!< The Internal RC 4MHz oscillator clock enable */
#define RCC_CR_CSION_Msk               (0x1UL << RCC_CR_CSION_Pos)             /*!< 0x00000080 */
#define RCC_CR_CSION_Pos               (7U)
#define RCC_CR_CSIRDY                  RCC_CR_CSIRDY_Msk                       /*!< The Internal RC 4MHz oscillator clock ready */
#define RCC_CR_CSIRDY_Msk              (0x1UL << RCC_CR_CSIRDY_Pos)            /*!< 0x00000100 */
#define RCC_CR_CSIRDY_Pos              (8U)
#define RCC_CR_HSEBYP                  RCC_CR_HSEBYP_Msk                       /*!< External High Speed clock bypass */
#define RCC_CR_HSEBYP_Msk              (0x1UL << RCC_CR_HSEBYP_Pos)            /*!< 0x00040000 */
#define RCC_CR_HSEBYP_Pos              (18U)
#define RCC_CR_HSECSSON                RCC_CR_HSECSSON_Msk                     /*!< HSE Clock security System enable */
#define RCC_CR_HSECSSON_Msk            (0x1UL << RCC_CR_HSECSSON_Pos)          /*!< 0x00080000 */
#define RCC_CR_HSECSSON_Pos            (20U)
#define RCC_CR_HSEEXT                  RCC_CR_HSEEXT_Msk                       /*!< External High Speed clock type in bypass mode */
#define RCC_CR_HSEEXT_Msk              (0x1UL << RCC_CR_HSEEXT_Pos)            /*!< 0x00100000 */
#define RCC_CR_HSEEXT_Pos              (19U)
#define RCC_CR_HSEON                   RCC_CR_HSEON_Msk                        /*!< External High Speed clock enable */
#define RCC_CR_HSEON_Msk               (0x1UL << RCC_CR_HSEON_Pos)             /*!< 0x00010000 */
#define RCC_CR_HSEON_Pos               (16U)
#define RCC_CR_HSERDY                  RCC_CR_HSERDY_Msk                       /*!< External High Speed clock ready flag */
#define RCC_CR_HSERDY_Msk              (0x1UL << RCC_CR_HSERDY_Pos)            /*!< 0x00020000 */
#define RCC_CR_HSERDY_Pos              (17U)
#define RCC_CR_HSI48ON                 RCC_CR_HSI48ON_Msk                      /*!< HSI48 clock enable clock enable  */
#define RCC_CR_HSI48ON_Msk             (0x1UL << RCC_CR_HSI48ON_Pos)           /*!< 0x00001000 */
#define RCC_CR_HSI48ON_Pos             (12U)
#define RCC_CR_HSI48RDY                RCC_CR_HSI48RDY_Msk                     /*!< HSI48 clock ready flag */
#define RCC_CR_HSI48RDY_Msk            (0x1UL << RCC_CR_HSI48RDY_Pos)          /*!< 0x00002000 */
#define RCC_CR_HSI48RDY_Pos            (13U)
#define RCC_CR_HSIDIV                  RCC_CR_HSIDIV_Msk                       /*!< Internal High Speed clock divider selection */
#define RCC_CR_HSIDIVF                 RCC_CR_HSIDIVF_Msk                      /*!< HSI Divider flag */
#define RCC_CR_HSIDIVF_Msk             (0x1UL << RCC_CR_HSIDIVF_Pos)           /*!< 0x00000020 */
#define RCC_CR_HSIDIVF_Pos             (5U)
#define RCC_CR_HSIDIV_0                (0x1UL << RCC_CR_HSIDIV_Pos)            /*!< 0x00000008 */
#define RCC_CR_HSIDIV_1                (0x2UL << RCC_CR_HSIDIV_Pos)            /*!< 0x00000010 */
#define RCC_CR_HSIDIV_Msk              (0x3UL << RCC_CR_HSIDIV_Pos)            /*!< 0x00000018 */
#define RCC_CR_HSIDIV_Pos              (3U)
#define RCC_CR_HSIKERON                RCC_CR_HSIKERON_Msk                     /*!< Internal High Speed clock enable in Stop mode */
#define RCC_CR_HSIKERON_Msk            (0x1UL << RCC_CR_HSIKERON_Pos)          /*!< 0x00000002 */
#define RCC_CR_HSIKERON_Pos            (1U)
#define RCC_CR_HSION                   RCC_CR_HSION_Msk                        /*!< Internal High Speed clock enable */
#define RCC_CR_HSION_Msk               (0x1UL << RCC_CR_HSION_Pos)             /*!< 0x00000001 */
#define RCC_CR_HSION_Pos               (0U)
#define RCC_CR_HSIRDY                  RCC_CR_HSIRDY_Msk                       /*!< Internal High Speed clock ready flag */
#define RCC_CR_HSIRDY_Msk              (0x1UL << RCC_CR_HSIRDY_Pos)            /*!< 0x00000004 */
#define RCC_CR_HSIRDY_Pos              (2U)
#define RCC_CR_PLL1ON                  RCC_CR_PLL1ON_Msk                       /*!< System PLL1 clock enable */
#define RCC_CR_PLL1ON_Msk              (0x1UL << RCC_CR_PLL1ON_Pos)            /*!< 0x01000000 */
#define RCC_CR_PLL1ON_Pos              (24U)
#define RCC_CR_PLL1RDY                 RCC_CR_PLL1RDY_Msk                      /*!< System PLL1 clock ready flag */
#define RCC_CR_PLL1RDY_Msk             (0x1UL << RCC_CR_PLL1RDY_Pos)           /*!< 0x02000000 */
#define RCC_CR_PLL1RDY_Pos             (25U)
#define RCC_CR_PLL2ON                  RCC_CR_PLL2ON_Msk                       /*!< System PLL2 clock enable */
#define RCC_CR_PLL2ON_Msk              (0x1UL << RCC_CR_PLL2ON_Pos)            /*!< 0x04000000 */
#define RCC_CR_PLL2ON_Pos              (26U)
#define RCC_CR_PLL2RDY                 RCC_CR_PLL2RDY_Msk                      /*!< System PLL2 clock ready flag */
#define RCC_CR_PLL2RDY_Msk             (0x1UL << RCC_CR_PLL2RDY_Pos)           /*!< 0x08000000 */
#define RCC_CR_PLL2RDY_Pos             (27U)
#define RCC_CR_PLL3ON                  RCC_CR_PLL3ON_Msk                       /*!< System PLL3 clock enable */
#define RCC_CR_PLL3ON_Msk              (0x1UL << RCC_CR_PLL3ON_Pos)            /*!< 0x10000000 */
#define RCC_CR_PLL3ON_Pos              (28U)
#define RCC_CR_PLL3RDY                 RCC_CR_PLL3RDY_Msk                      /*!< System PLL3 clock ready flag */
#define RCC_CR_PLL3RDY_Msk             (0x1UL << RCC_CR_PLL3RDY_Pos)           /*!< 0x20000000 */
#define RCC_CR_PLL3RDY_Pos             (29U)
#define RCC_CSICFGR_CSICAL             RCC_CSICFGR_CSICAL_Msk                  /*!< CSICAL[7:0] bits */
#define RCC_CSICFGR_CSICAL_Msk         (0xFFUL << RCC_CSICFGR_CSICAL_Pos)      /*!< 0x000000FF */
#define RCC_CSICFGR_CSICAL_Pos         (0U)
#define RCC_CSICFGR_CSITRIM            RCC_CSICFGR_CSITRIM_Msk                 /*!< CSITRIM[5:0] bits */
#define RCC_CSICFGR_CSITRIM_Msk        (0x3FUL << RCC_CSICFGR_CSITRIM_Pos)     /*!< 0x3F000000 */
#define RCC_CSICFGR_CSITRIM_Pos        (24U)
#define RCC_CSR_LSION                  RCC_CSR_LSION_Msk
#define RCC_CSR_LSION_Msk              (0x1UL << RCC_CSR_LSION_Pos)            /*!< 0x00000001 */
#define RCC_CSR_LSION_Pos              (0U)
#define RCC_CSR_LSIRDY                 RCC_CSR_LSIRDY_Msk
#define RCC_CSR_LSIRDY_Msk             (0x1UL << RCC_CSR_LSIRDY_Pos)           /*!< 0x00000002 */
#define RCC_CSR_LSIRDY_Pos             (1U)
#define RCC_HSICFGR_HSICAL             RCC_HSICFGR_HSICAL_Msk                  /*!< HSICAL[11:0] bits */
#define RCC_HSICFGR_HSICAL_Msk         (0xFFFUL << RCC_HSICFGR_HSICAL_Pos)     /*!< 0x00000FFF */
#define RCC_HSICFGR_HSICAL_Pos         (0U)
#define RCC_HSICFGR_HSITRIM            RCC_HSICFGR_HSITRIM_Msk                 /*!< HSITRIM[6:0] bits */
#define RCC_HSICFGR_HSITRIM_Msk        (0x7FUL << RCC_HSICFGR_HSITRIM_Pos)     /*!< 0x7F000000 */
#define RCC_HSICFGR_HSITRIM_Pos        (24U)
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
#define RCC_PLL1SSCGR_INCSTEP         RCC_PLL1SSCGR_INCSTEP_Msk               /*!< INCSTEP[14:0] bits: Modulation Depth Adjustment */
#define RCC_PLL1SSCGR_INCSTEP_Msk     (0x7FFFUL << RCC_PLL1SSCGR_INCSTEP_Pos) /*!< 0x7FFF0000 */
#define RCC_PLL1SSCGR_INCSTEP_Pos     (16U)
#define RCC_PLL1SSCGR_MODPER          RCC_PLL1SSCGR_MODPER_Msk                /*!< MODPER[12:0] bits: Modulation Period Adjustment */
#define RCC_PLL1SSCGR_MODPER_Msk      (0x1FFFUL << RCC_PLL1SSCGR_MODPER_Pos)  /*!< 0x00001FFF */
#define RCC_PLL1SSCGR_MODPER_Pos      (0U)
#define RCC_PLL1SSCGR_RPDFNDIS        RCC_PLL1SSCGR_RPDFNDIS_Msk
#define RCC_PLL1SSCGR_RPDFNDIS_Msk    (0x1UL << RCC_PLL1SSCGR_RPDFNDIS_Pos)   /*!< 0x00004000 */
#define RCC_PLL1SSCGR_RPDFNDIS_Pos    (14U)
#define RCC_PLL1SSCGR_SPREADSEL       RCC_PLL1SSCGR_SPREADSEL_Msk
#define RCC_PLL1SSCGR_SPREADSEL_Msk   (0x1UL << RCC_PLL1SSCGR_SPREADSEL_Pos)  /*!< 0x00008000 */
#define RCC_PLL1SSCGR_SPREADSEL_Pos   (15U)
#define RCC_PLL1SSCGR_TPDFNDIS        RCC_PLL1SSCGR_TPDFNDIS_Msk
#define RCC_PLL1SSCGR_TPDFNDIS_Msk    (0x1UL << RCC_PLL1SSCGR_TPDFNDIS_Pos)   /*!< 0x00002000 */
#define RCC_PLL1SSCGR_TPDFNDIS_Pos    (13U)
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
#define RCC_PLL2SSCGR_INCSTEP         RCC_PLL2SSCGR_INCSTEP_Msk               /*!< INCSTEP[14:0] bits: Modulation Depth Adjustment */
#define RCC_PLL2SSCGR_INCSTEP_Msk     (0x7FFFUL << RCC_PLL2SSCGR_INCSTEP_Pos) /*!< 0x7FFF0000 */
#define RCC_PLL2SSCGR_INCSTEP_Pos     (16U)
#define RCC_PLL2SSCGR_MODPER          RCC_PLL2SSCGR_MODPER_Msk                /*!< MODPER[12:0] bits: Modulation Period Adjustment */
#define RCC_PLL2SSCGR_MODPER_Msk      (0x1FFFUL << RCC_PLL2SSCGR_MODPER_Pos)  /*!< 0x00001FFF */
#define RCC_PLL2SSCGR_MODPER_Pos      (0U)
#define RCC_PLL2SSCGR_RPDFNDIS        RCC_PLL2SSCGR_RPDFNDIS_Msk
#define RCC_PLL2SSCGR_RPDFNDIS_Msk    (0x1UL << RCC_PLL2SSCGR_RPDFNDIS_Pos)   /*!< 0x00004000 */
#define RCC_PLL2SSCGR_RPDFNDIS_Pos    (14U)
#define RCC_PLL2SSCGR_SPREADSEL       RCC_PLL2SSCGR_SPREADSEL_Msk
#define RCC_PLL2SSCGR_SPREADSEL_Msk   (0x1UL << RCC_PLL2SSCGR_SPREADSEL_Pos)  /*!< 0x00008000 */
#define RCC_PLL2SSCGR_SPREADSEL_Pos   (15U)
#define RCC_PLL2SSCGR_TPDFNDIS        RCC_PLL2SSCGR_TPDFNDIS_Msk
#define RCC_PLL2SSCGR_TPDFNDIS_Msk    (0x1UL << RCC_PLL2SSCGR_TPDFNDIS_Pos)   /*!< 0x00002000 */
#define RCC_PLL2SSCGR_TPDFNDIS_Pos    (13U)
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
#define RCC_PLL3SSCGR_INCSTEP         RCC_PLL3SSCGR_INCSTEP_Msk               /*!< INCSTEP[14:0] bits: Modulation Depth Adjustment */
#define RCC_PLL3SSCGR_INCSTEP_Msk     (0x7FFFUL << RCC_PLL3SSCGR_INCSTEP_Pos) /*!< 0x7FFF0000 */
#define RCC_PLL3SSCGR_INCSTEP_Pos     (16U)
#define RCC_PLL3SSCGR_MODPER          RCC_PLL3SSCGR_MODPER_Msk                /*!< MODPER[12:0] bits: Modulation Period Adjustment */
#define RCC_PLL3SSCGR_MODPER_Msk      (0x1FFFUL << RCC_PLL3SSCGR_MODPER_Pos)  /*!< 0x00001FFF */
#define RCC_PLL3SSCGR_MODPER_Pos      (0U)
#define RCC_PLL3SSCGR_RPDFNDIS        RCC_PLL3SSCGR_RPDFNDIS_Msk
#define RCC_PLL3SSCGR_RPDFNDIS_Msk    (0x1UL << RCC_PLL3SSCGR_RPDFNDIS_Pos)   /*!< 0x00004000 */
#define RCC_PLL3SSCGR_RPDFNDIS_Pos    (14U)
#define RCC_PLL3SSCGR_SPREADSEL       RCC_PLL3SSCGR_SPREADSEL_Msk
#define RCC_PLL3SSCGR_SPREADSEL_Msk   (0x1UL << RCC_PLL3SSCGR_SPREADSEL_Pos)  /*!< 0x00008000 */
#define RCC_PLL3SSCGR_SPREADSEL_Pos   (15U)
#define RCC_PLL3SSCGR_TPDFNDIS        RCC_PLL3SSCGR_TPDFNDIS_Msk
#define RCC_PLL3SSCGR_TPDFNDIS_Msk    (0x1UL << RCC_PLL3SSCGR_TPDFNDIS_Pos)   /*!< 0x00002000 */
#define RCC_PLL3SSCGR_TPDFNDIS_Pos    (13U)
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
#define RCC_PLLCFGR_PLL1RGE            RCC_PLLCFGR_PLL1RGE_Msk                 /*!< PLL1RGE[1:0] bits: PLL1 input frequency range */
#define RCC_PLLCFGR_PLL1RGE_0          (0x1UL << RCC_PLLCFGR_PLL1RGE_Pos)      /*!< 0x00000008 */
#define RCC_PLLCFGR_PLL1RGE_1          (0x2UL << RCC_PLLCFGR_PLL1RGE_Pos)      /*!< 0x00000010 */
#define RCC_PLLCFGR_PLL1RGE_Msk        (0x3UL << RCC_PLLCFGR_PLL1RGE_Pos)      /*!< 0x00000018 */
#define RCC_PLLCFGR_PLL1RGE_Pos        (3U)
#define RCC_PLLCFGR_PLL1SEN            RCC_PLLCFGR_PLL1SEN_Msk                 /*!< PLL1 DIVS divider output enable */
#define RCC_PLLCFGR_PLL1SEN_Msk        (0x1UL << RCC_PLLCFGR_PLL1SEN_Pos)      /*!< 0x00000100 */
#define RCC_PLLCFGR_PLL1SEN_Pos        (8U)
#define RCC_PLLCFGR_PLL1SSCGEN         RCC_PLLCFGR_PLL1SSCGEN_Msk              /*!< PLL1 Spread Spectrum Clock Generator enable */
#define RCC_PLLCFGR_PLL1SSCGEN_Msk     (0x1UL << RCC_PLLCFGR_PLL1SSCGEN_Pos)   /*!< 0x00000004 */
#define RCC_PLLCFGR_PLL1SSCGEN_Pos     (2U)
#define RCC_PLLCFGR_PLL1VCOSEL         RCC_PLLCFGR_PLL1VCOSEL_Msk              /*!< PLL1 VCO selection */
#define RCC_PLLCFGR_PLL1VCOSEL_Msk     (0x1UL << RCC_PLLCFGR_PLL1VCOSEL_Pos)   /*!< 0x00000002 */
#define RCC_PLLCFGR_PLL1VCOSEL_Pos     (1U)
#define RCC_PLLCFGR_PLL2FRACEN         RCC_PLLCFGR_PLL2FRACEN_Msk              /*!< PLL2 fractional latch enable */
#define RCC_PLLCFGR_PLL2FRACEN_Msk     (0x1UL << RCC_PLLCFGR_PLL2FRACEN_Pos)   /*!< 0x00000800 */
#define RCC_PLLCFGR_PLL2FRACEN_Pos     (11U)
#define RCC_PLLCFGR_PLL2PEN            RCC_PLLCFGR_PLL2PEN_Msk                 /*!< PLL2 DIVP divider output enable */
#define RCC_PLLCFGR_PLL2PEN_Msk        (0x1UL << RCC_PLLCFGR_PLL2PEN_Pos)      /*!< 0x00010000 */
#define RCC_PLLCFGR_PLL2PEN_Pos        (16U)
#define RCC_PLLCFGR_PLL2QEN            RCC_PLLCFGR_PLL2QEN_Msk                 /*!< PLL2 DIVQ divider output enable */
#define RCC_PLLCFGR_PLL2QEN_Msk        (0x1UL << RCC_PLLCFGR_PLL2QEN_Pos)      /*!< 0x00020000 */
#define RCC_PLLCFGR_PLL2QEN_Pos        (17U)
#define RCC_PLLCFGR_PLL2REN            RCC_PLLCFGR_PLL2REN_Msk                 /*!< PLL2 DIVR divider output enable */
#define RCC_PLLCFGR_PLL2REN_Msk        (0x1UL << RCC_PLLCFGR_PLL2REN_Pos)      /*!< 0x00040000 */
#define RCC_PLLCFGR_PLL2REN_Pos        (18U)
#define RCC_PLLCFGR_PLL2RGE            RCC_PLLCFGR_PLL2RGE_Msk                 /*!< PLL2RGE[1:0] bits: PLL2 input frequency range */
#define RCC_PLLCFGR_PLL2RGE_Msk        (0x3UL << RCC_PLLCFGR_PLL2RGE_Pos)      /*!< 0x0000C000 */
#define RCC_PLLCFGR_PLL2RGE_Pos        (14U)
#define RCC_PLLCFGR_PLL2SEN            RCC_PLLCFGR_PLL2SEN_Msk                 /*!< PLL2 DIVS divider output enable */
#define RCC_PLLCFGR_PLL2SEN_Msk        (0x1UL << RCC_PLLCFGR_PLL2SEN_Pos)      /*!< 0x00080000 */
#define RCC_PLLCFGR_PLL2SEN_Pos        (19U)
#define RCC_PLLCFGR_PLL2SSCGEN         RCC_PLLCFGR_PLL2SSCGEN_Msk              /*!< PLL2 Spread Spectrum Clock Generator enable */
#define RCC_PLLCFGR_PLL2SSCGEN_Msk     (0x1UL << RCC_PLLCFGR_PLL2SSCGEN_Pos)   /*!< 0x00002000 */
#define RCC_PLLCFGR_PLL2SSCGEN_Pos     (13U)
#define RCC_PLLCFGR_PLL2TEN            RCC_PLLCFGR_PLL2TEN_Msk                 /*!< PLL2 DIVT divider output enable */
#define RCC_PLLCFGR_PLL2TEN_Msk        (0x1UL << RCC_PLLCFGR_PLL2TEN_Pos)      /*!< 0x00100000 */
#define RCC_PLLCFGR_PLL2TEN_Pos        (20U)
#define RCC_PLLCFGR_PLL2VCOSEL         RCC_PLLCFGR_PLL2VCOSEL_Msk              /*!< PLL2 VCO selection */
#define RCC_PLLCFGR_PLL2VCOSEL_Msk     (0x1UL << RCC_PLLCFGR_PLL2VCOSEL_Pos)   /*!< 0x00001000 */
#define RCC_PLLCFGR_PLL2VCOSEL_Pos     (12U)
#define RCC_PLLCFGR_PLL3FRACEN         RCC_PLLCFGR_PLL3FRACEN_Msk              /*!< PLL3 fractional latch enable */
#define RCC_PLLCFGR_PLL3FRACEN_Msk     (0x1UL << RCC_PLLCFGR_PLL3FRACEN_Pos)   /*!< 0x00400000 */
#define RCC_PLLCFGR_PLL3FRACEN_Pos     (22U)
#define RCC_PLLCFGR_PLL3PEN            RCC_PLLCFGR_PLL3PEN_Msk                 /*!< PLL3 DIVP divider output enable */
#define RCC_PLLCFGR_PLL3PEN_Msk        (0x1UL << RCC_PLLCFGR_PLL3PEN_Pos)      /*!< 0x08000000 */
#define RCC_PLLCFGR_PLL3PEN_Pos        (27U)
#define RCC_PLLCFGR_PLL3QEN            RCC_PLLCFGR_PLL3QEN_Msk                 /*!< PLL3 DIVQ divider output enable */
#define RCC_PLLCFGR_PLL3QEN_Msk        (0x1UL << RCC_PLLCFGR_PLL3QEN_Pos)      /*!< 0x10000000 */
#define RCC_PLLCFGR_PLL3QEN_Pos        (28U)
#define RCC_PLLCFGR_PLL3REN            RCC_PLLCFGR_PLL3REN_Msk                 /*!< PLL3 DIVR divider output enable */
#define RCC_PLLCFGR_PLL3REN_Msk        (0x1UL << RCC_PLLCFGR_PLL3REN_Pos)      /*!< 0x20000000 */
#define RCC_PLLCFGR_PLL3REN_Pos        (29U)
#define RCC_PLLCFGR_PLL3RGE            RCC_PLLCFGR_PLL3RGE_Msk                 /*!< PLL3RGE[1:0] bits: PLL3 input frequency range */
#define RCC_PLLCFGR_PLL3RGE_Msk        (0x3UL << RCC_PLLCFGR_PLL3RGE_Pos)      /*!< 0x06000000 */
#define RCC_PLLCFGR_PLL3RGE_Pos        (25U)
#define RCC_PLLCFGR_PLL3SEN            RCC_PLLCFGR_PLL3SEN_Msk                 /*!< PLL3 DIVS divider output enable */
#define RCC_PLLCFGR_PLL3SEN_Msk        (0x1UL << RCC_PLLCFGR_PLL3SEN_Pos)      /*!< 0x40000000 */
#define RCC_PLLCFGR_PLL3SEN_Pos        (30U)
#define RCC_PLLCFGR_PLL3SSCGEN         RCC_PLLCFGR_PLL3SSCGEN_Msk              /*!< PLL3 Spread Spectrum Clock Generator enable */
#define RCC_PLLCFGR_PLL3SSCGEN_Msk     (0x1UL << RCC_PLLCFGR_PLL3SSCGEN_Pos)   /*!< 0x01000000 */
#define RCC_PLLCFGR_PLL3SSCGEN_Pos     (24U)
#define RCC_PLLCFGR_PLL3VCOSEL         RCC_PLLCFGR_PLL3VCOSEL_Msk              /*!< PLL3 VCO selection */
#define RCC_PLLCFGR_PLL3VCOSEL_Msk     (0x1UL << RCC_PLLCFGR_PLL3VCOSEL_Pos)   /*!< 0x00800000 */
#define RCC_PLLCFGR_PLL3VCOSEL_Pos     (23U)
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
#define RCC_RSR_BORRSTF                RCC_RSR_BORRSTF_Msk
#define RCC_RSR_BORRSTF_Msk            (0x1UL << RCC_RSR_BORRSTF_Pos)          /*!< 0x00200000 */
#define RCC_RSR_BORRSTF_Pos            (21U)
#define RCC_RSR_IWDGRSTF               RCC_RSR_IWDGRSTF_Msk
#define RCC_RSR_IWDGRSTF_Msk           (0x1UL << RCC_RSR_IWDGRSTF_Pos)         /*!< 0x04000000 */
#define RCC_RSR_IWDGRSTF_Pos           (26U)
#define RCC_RSR_LPWRRSTF               RCC_RSR_LPWRRSTF_Msk
#define RCC_RSR_LPWRRSTF_Msk           (0x1UL << RCC_RSR_LPWRRSTF_Pos)         /*!< 0x40000000 */
#define RCC_RSR_LPWRRSTF_Pos           (30U)
#define RCC_RSR_PINRSTF                RCC_RSR_PINRSTF_Msk
#define RCC_RSR_PINRSTF_Msk            (0x1UL << RCC_RSR_PINRSTF_Pos)          /*!< 0x00400000 */
#define RCC_RSR_PINRSTF_Pos            (22U)
#define RCC_RSR_PORRSTF                RCC_RSR_PORRSTF_Msk
#define RCC_RSR_PORRSTF_Msk            (0x1UL << RCC_RSR_PORRSTF_Pos)          /*!< 0x00800000 */
#define RCC_RSR_PORRSTF_Pos            (23U)
#define RCC_RSR_RMVF                   RCC_RSR_RMVF_Msk
#define RCC_RSR_RMVF_Msk               (0x1UL << RCC_RSR_RMVF_Pos)             /*!< 0x00010000 */
#define RCC_RSR_RMVF_Pos               (16U)
#define RCC_RSR_SFTRSTF                RCC_RSR_SFTRSTF_Msk
#define RCC_RSR_SFTRSTF_Msk            (0x1UL << RCC_RSR_SFTRSTF_Pos)          /*!< 0x01000000 */
#define RCC_RSR_SFTRSTF_Pos            (24U)
#define RCC_RSR_WWDGRSTF               RCC_RSR_WWDGRSTF_Msk
#define RCC_RSR_WWDGRSTF_Msk           (0x1UL << RCC_RSR_WWDGRSTF_Pos)         /*!< 0x10000000 */
#define RCC_RSR_WWDGRSTF_Pos           (28U)
#define SBS_BKLOCKR_ARAM1ECC_BL          SBS_BKLOCKR_ARAM1ECC_BL_Msk                 /*!< AXIRAM1 ECC error break lock */
#define SBS_BKLOCKR_ARAM1ECC_BL_Msk      (0x1UL << SBS_BKLOCKR_ARAM1ECC_BL_Pos)      /*!< 0x00800000 */
#define SBS_BKLOCKR_ARAM1ECC_BL_Pos      (23U)
#define SBS_BKLOCKR_ARAM3ECC_BL          SBS_BKLOCKR_ARAM3ECC_BL_Msk                 /*!< AXIRAM3 ECC error break lock */
#define SBS_BKLOCKR_ARAM3ECC_BL_Msk      (0x1UL << SBS_BKLOCKR_ARAM3ECC_BL_Pos)      /*!< 0x00200000 */
#define SBS_BKLOCKR_ARAM3ECC_BL_Pos      (21U)
#define SBS_BKLOCKR_BKRAMECC_BL          SBS_BKLOCKR_BKRAMECC_BL_Msk                 /*!< Backup RAM ECC error break lock */
#define SBS_BKLOCKR_BKRAMECC_BL_Msk      (0x1UL << SBS_BKLOCKR_BKRAMECC_BL_Pos)      /*!< 0x00000080 */
#define SBS_BKLOCKR_BKRAMECC_BL_Pos      (7U)
#define SBS_BKLOCKR_CM7LCKUP_BL          SBS_BKLOCKR_CM7LCKUP_BL_Msk                 /*!< Cortex-M7 lockup break lock */
#define SBS_BKLOCKR_CM7LCKUP_BL_Msk      (0x1UL << SBS_BKLOCKR_CM7LCKUP_BL_Pos)      /*!< 0x00000040 */
#define SBS_BKLOCKR_CM7LCKUP_BL_Pos      (6U)
#define SBS_BKLOCKR_DTCMECC_BL           SBS_BKLOCKR_DTCMECC_BL_Msk                  /*!< DTCM ECC error break lock */
#define SBS_BKLOCKR_DTCMECC_BL_Msk       (0x1UL << SBS_BKLOCKR_DTCMECC_BL_Pos)       /*!< 0x00002000 */
#define SBS_BKLOCKR_DTCMECC_BL_Pos       (13U)
#define SBS_BKLOCKR_FLASHECC_BL          SBS_BKLOCKR_FLASHECC_BL_Msk                 /*!< Flash ECC error break lock */
#define SBS_BKLOCKR_FLASHECC_BL_Msk      (0x1UL << SBS_BKLOCKR_FLASHECC_BL_Pos)      /*!< 0x00000008 */
#define SBS_BKLOCKR_FLASHECC_BL_Pos      (3U)
#define SBS_BKLOCKR_ITCMECC_BL           SBS_BKLOCKR_ITCMECC_BL_Msk                  /*!< ITCM ECC error break lock */
#define SBS_BKLOCKR_ITCMECC_BL_Msk       (0x1UL << SBS_BKLOCKR_ITCMECC_BL_Pos)       /*!< 0x00004000 */
#define SBS_BKLOCKR_ITCMECC_BL_Pos       (14U)
#define SBS_BKLOCKR_PVD_BL               SBS_BKLOCKR_PVD_BL_Msk                      /*!< PVD break lock */
#define SBS_BKLOCKR_PVD_BL_Msk           (0x1UL << SBS_BKLOCKR_PVD_BL_Pos)           /*!< 0x00000004 */
#define SBS_BKLOCKR_PVD_BL_Pos           (2U)
#define SBS_BOOTSR_INITVTOR              SBS_BOOTSR_INITVTOR_Msk                     /*!< Initial vector for Cortex-M7 */
#define SBS_BOOTSR_INITVTOR_Msk          (0xFFFFFFFFUL << SBS_BOOTSR_INITVTOR_Pos)   /*!< 0xFFFFFFFF */
#define SBS_BOOTSR_INITVTOR_Pos          (0U)
#define SBS_CCCSR_COMP_CODESEL           SBS_CCCSR_COMP_CODESEL_Msk                  /*!< Compensation cell code selection */
#define SBS_CCCSR_COMP_CODESEL_Msk       (0x1UL << SBS_CCCSR_COMP_CODESEL_Pos)       /*!< 0x00000002 */
#define SBS_CCCSR_COMP_CODESEL_Pos       (1U)
#define SBS_CCCSR_COMP_EN                SBS_CCCSR_COMP_EN_Msk                       /*!< Compensation cell enable */
#define SBS_CCCSR_COMP_EN_Msk            (0x1UL << SBS_CCCSR_COMP_EN_Pos)            /*!< 0x00000001 */
#define SBS_CCCSR_COMP_EN_Pos            (0U)
#define SBS_CCCSR_COMP_RDY               SBS_CCCSR_COMP_RDY_Msk                      /*!< Compensation cell ready */
#define SBS_CCCSR_COMP_RDY_Msk           (0x1UL << SBS_CCCSR_COMP_RDY_Pos)           /*!< 0x00000100 */
#define SBS_CCCSR_COMP_RDY_Pos           (8U)
#define SBS_CCCSR_IOHSLV                 SBS_CCCSR_IOHSLV_Msk                        /*!< I/O high speed at low voltage */
#define SBS_CCCSR_IOHSLV_Msk             (0x1UL << SBS_CCCSR_IOHSLV_Pos)             /*!< 0x00010000 */
#define SBS_CCCSR_IOHSLV_Pos             (16U)
#define SBS_CCCSR_XSPI1_COMP_CODESEL     SBS_CCCSR_XSPI1_COMP_CODESEL_Msk            /*!< XSPIM_P1 compensation cell code selection */
#define SBS_CCCSR_XSPI1_COMP_CODESEL_Msk (0x1UL << SBS_CCCSR_XSPI1_COMP_CODESEL_Pos) /*!< 0x00000008 */
#define SBS_CCCSR_XSPI1_COMP_CODESEL_Pos (3U)
#define SBS_CCCSR_XSPI1_COMP_EN          SBS_CCCSR_XSPI1_COMP_EN_Msk                 /*!< XSPIM_P1 compensation cell enable */
#define SBS_CCCSR_XSPI1_COMP_EN_Msk      (0x1UL << SBS_CCCSR_XSPI1_COMP_EN_Pos)      /*!< 0x00000004 */
#define SBS_CCCSR_XSPI1_COMP_EN_Pos      (2U)
#define SBS_CCCSR_XSPI1_COMP_RDY         SBS_CCCSR_XSPI1_COMP_RDY_Msk                /*!< XSPIM_P1 compensation cell ready */
#define SBS_CCCSR_XSPI1_COMP_RDY_Msk     (0x1UL << SBS_CCCSR_XSPI1_COMP_RDY_Pos)     /*!< 0x00000200 */
#define SBS_CCCSR_XSPI1_COMP_RDY_Pos     (9U)
#define SBS_CCCSR_XSPI1_IOHSLV           SBS_CCCSR_XSPI1_IOHSLV_Msk                  /*!< XSPIM_P1 I/O high speed at low voltage */
#define SBS_CCCSR_XSPI1_IOHSLV_Msk       (0x1UL << SBS_CCCSR_XSPI1_IOHSLV_Pos)       /*!< 0x00020000 */
#define SBS_CCCSR_XSPI1_IOHSLV_Pos       (17U)
#define SBS_CCCSR_XSPI2_COMP_CODESEL     SBS_CCCSR_XSPI2_COMP_CODESEL_Msk            /*!< XSPIM_P2 compensation cell code selection */
#define SBS_CCCSR_XSPI2_COMP_CODESEL_Msk (0x1UL << SBS_CCCSR_XSPI2_COMP_CODESEL_Pos) /*!< 0x00000020 */
#define SBS_CCCSR_XSPI2_COMP_CODESEL_Pos (5U)
#define SBS_CCCSR_XSPI2_COMP_EN          SBS_CCCSR_XSPI2_COMP_EN_Msk                 /*!< XSPIM_P2 compensation cell enable */
#define SBS_CCCSR_XSPI2_COMP_EN_Msk      (0x1UL << SBS_CCCSR_XSPI2_COMP_EN_Pos)      /*!< 0x00000010 */
#define SBS_CCCSR_XSPI2_COMP_EN_Pos      (4U)
#define SBS_CCCSR_XSPI2_COMP_RDY         SBS_CCCSR_XSPI2_COMP_RDY_Msk                /*!< XSPIM_P2 compensation cell ready */
#define SBS_CCCSR_XSPI2_COMP_RDY_Msk     (0x1UL << SBS_CCCSR_XSPI2_COMP_RDY_Pos)     /*!< 0x00000400 */
#define SBS_CCCSR_XSPI2_COMP_RDY_Pos     (10U)
#define SBS_CCCSR_XSPI2_IOHSLV           SBS_CCCSR_XSPI2_IOHSLV_Msk                  /*!< XSPIM_P2 I/O high speed at low voltage */
#define SBS_CCCSR_XSPI2_IOHSLV_Msk       (0x1UL << SBS_CCCSR_XSPI2_IOHSLV_Pos)       /*!< 0x00040000 */
#define SBS_CCCSR_XSPI2_IOHSLV_Pos       (18U)
#define SBS_CCSWVALR_SW_NSRC             SBS_CCSWVALR_SW_NSRC_Msk                    /*!< Software NMOS transistors slew-rate compensation */
#define SBS_CCSWVALR_SW_NSRC_Msk         (0xFUL << SBS_CCSWVALR_SW_NSRC_Pos)         /*!< 0x0000000F */
#define SBS_CCSWVALR_SW_NSRC_Pos         (0U)
#define SBS_CCSWVALR_SW_PSRC             SBS_CCSWVALR_SW_PSRC_Msk                    /*!< Software PMOS transistors slew-rate compensation */
#define SBS_CCSWVALR_SW_PSRC_Msk         (0xFUL << SBS_CCSWVALR_SW_PSRC_Pos)         /*!< 0x000000F0 */
#define SBS_CCSWVALR_SW_PSRC_Pos         (4U)
#define SBS_CCSWVALR_XSPI1_SW_NSRC       SBS_CCSWVALR_XSPI1_SW_NSRC_Msk              /*!< XSPIM_P1 software NMOS transistors slew-rate compensation */
#define SBS_CCSWVALR_XSPI1_SW_NSRC_Msk   (0xFUL << SBS_CCSWVALR_XSPI1_SW_NSRC_Pos)   /*!< 0x00000F00 */
#define SBS_CCSWVALR_XSPI1_SW_NSRC_Pos   (8U)
#define SBS_CCSWVALR_XSPI1_SW_PSRC       SBS_CCSWVALR_XSPI1_SW_PSRC_Msk              /*!< XSPIM_P1 software PMOS transistors slew-rate compensation */
#define SBS_CCSWVALR_XSPI1_SW_PSRC_Msk   (0xFUL << SBS_CCSWVALR_XSPI1_SW_PSRC_Pos)   /*!< 0x0000F000 */
#define SBS_CCSWVALR_XSPI1_SW_PSRC_Pos   (12U)
#define SBS_CCSWVALR_XSPI2_SW_NSRC       SBS_CCSWVALR_XSPI2_SW_NSRC_Msk              /*!< XSPIM_P2 software NMOS transistors slew-rate compensation */
#define SBS_CCSWVALR_XSPI2_SW_NSRC_Msk   (0xFUL << SBS_CCSWVALR_XSPI2_SW_NSRC_Pos)   /*!< 0x000F0000 */
#define SBS_CCSWVALR_XSPI2_SW_NSRC_Pos   (16U)
#define SBS_CCSWVALR_XSPI2_SW_PSRC       SBS_CCSWVALR_XSPI2_SW_PSRC_Msk              /*!< XSPIM_P2 software PMOS transistors slew-rate compensation */
#define SBS_CCSWVALR_XSPI2_SW_PSRC_Msk   (0xFUL << SBS_CCSWVALR_XSPI2_SW_PSRC_Pos)   /*!< 0x00F00000 */
#define SBS_CCSWVALR_XSPI2_SW_PSRC_Pos   (20U)
#define SBS_CCVALR_NSRC                  SBS_CCVALR_NSRC_Msk                         /*!< NMOS transistors slew-rate compensation */
#define SBS_CCVALR_NSRC_Msk              (0xFUL << SBS_CCVALR_NSRC_Pos)              /*!< 0x0000000F */
#define SBS_CCVALR_NSRC_Pos              (0U)
#define SBS_CCVALR_PSRC                  SBS_CCVALR_PSRC_Msk                         /*!< PMOS transistors slew-rate compensation */
#define SBS_CCVALR_PSRC_Msk              (0xFUL << SBS_CCVALR_PSRC_Pos)              /*!< 0x000000F0 */
#define SBS_CCVALR_PSRC_Pos              (4U)
#define SBS_CCVALR_XSPI1_NSRC            SBS_CCVALR_XSPI1_NSRC_Msk                   /*!< XSPIM_P1 NMOS transistors slew-rate compensation */
#define SBS_CCVALR_XSPI1_NSRC_Msk        (0xFUL << SBS_CCVALR_XSPI1_NSRC_Pos)        /*!< 0x00000F00 */
#define SBS_CCVALR_XSPI1_NSRC_Pos        (8U)
#define SBS_CCVALR_XSPI1_PSRC            SBS_CCVALR_XSPI1_PSRC_Msk                   /*!< XSPIM_P1 PMOS transistors slew-rate compensation */
#define SBS_CCVALR_XSPI1_PSRC_Msk        (0xFUL << SBS_CCVALR_XSPI1_PSRC_Pos)        /*!< 0x0000F000 */
#define SBS_CCVALR_XSPI1_PSRC_Pos        (12U)
#define SBS_CCVALR_XSPI2_NSRC            SBS_CCVALR_XSPI2_NSRC_Msk                   /*!< XSPIM_P2 NMOS transistors slew-rate compensation */
#define SBS_CCVALR_XSPI2_NSRC_Msk        (0xFUL << SBS_CCVALR_XSPI2_NSRC_Pos)        /*!< 0x000F0000 */
#define SBS_CCVALR_XSPI2_NSRC_Pos        (16U)
#define SBS_CCVALR_XSPI2_PSRC            SBS_CCVALR_XSPI2_PSRC_Msk                   /*!< XSPIM_P2 PMOS transistors slew-rate compensation */
#define SBS_CCVALR_XSPI2_PSRC_Msk        (0xFUL << SBS_CCVALR_XSPI2_PSRC_Pos)        /*!< 0x00F00000 */
#define SBS_CCVALR_XSPI2_PSRC_Pos        (20U)
#define SBS_DBGCR_AP_UNLOCK              SBS_DBGCR_AP_UNLOCK_Msk                     /*!< Access port unlock */
#define SBS_DBGCR_AP_UNLOCK_Msk          (0xFFUL << SBS_DBGCR_AP_UNLOCK_Pos)         /*!< 0x000000FF */
#define SBS_DBGCR_AP_UNLOCK_Pos          (0U)
#define SBS_DBGCR_DBG_AUTH_HDPL          SBS_DBGCR_DBG_AUTH_HDPL_Msk                 /*!< Authenticated debug hide protection level */
#define SBS_DBGCR_DBG_AUTH_HDPL_Msk      (0xFFUL << SBS_DBGCR_DBG_AUTH_HDPL_Pos)     /*!< 0x00FF0000 */
#define SBS_DBGCR_DBG_AUTH_HDPL_Pos      (16U)
#define SBS_DBGCR_DBG_UNLOCK             SBS_DBGCR_DBG_UNLOCK_Msk                    /*!< Debug unlock */
#define SBS_DBGCR_DBG_UNLOCK_Msk         (0xFFUL << SBS_DBGCR_DBG_UNLOCK_Pos)        /*!< 0x0000FF00 */
#define SBS_DBGCR_DBG_UNLOCK_Pos         (8U)
#define SBS_DBGLOCKR_DBGCFG_LOCK         SBS_DBGLOCKR_DBGCFG_LOCK_Msk                /*!< Debug configuration lock */
#define SBS_DBGLOCKR_DBGCFG_LOCK_Msk     (0xFFUL << SBS_DBGLOCKR_DBGCFG_LOCK_Pos)    /*!< 0x000000FF */
#define SBS_DBGLOCKR_DBGCFG_LOCK_Pos     (0U)
#define SBS_EXTICR1_PC_EXTI0             SBS_EXTICR1_PC_EXTI0_Msk                    /*!< Port configuration EXTI 0 */
#define SBS_EXTICR1_PC_EXTI0_0           (0x1UL << SBS_EXTICR1_PC_EXTI0_Pos)         /*!< 0x00000001 */
#define SBS_EXTICR1_PC_EXTI0_1           (0x2UL << SBS_EXTICR1_PC_EXTI0_Pos)         /*!< 0x00000002 */
#define SBS_EXTICR1_PC_EXTI0_2           (0x4UL << SBS_EXTICR1_PC_EXTI0_Pos)         /*!< 0x00000004 */
#define SBS_EXTICR1_PC_EXTI0_3           (0x8UL << SBS_EXTICR1_PC_EXTI0_Pos)         /*!< 0x00000008 */
#define SBS_EXTICR1_PC_EXTI0_Msk         (0xFUL << SBS_EXTICR1_PC_EXTI0_Pos)         /*!< 0x0000000F */
#define SBS_EXTICR1_PC_EXTI0_Pos         (0U)
#define SBS_FPUIMR_FPU_IE_0              SBS_FPUIMR_FPU_IE_0_Msk                     /*!< Invalid operation Interrupt enable */
#define SBS_FPUIMR_FPU_IE_0_Msk          (0x1UL << SBS_FPUIMR_FPU_IE_0_Pos)          /*!< 0x00000001 */
#define SBS_FPUIMR_FPU_IE_0_Pos          (0U)
#define SBS_FPUIMR_FPU_IE_1              SBS_FPUIMR_FPU_IE_1_Msk                     /*!< Divide-by-zero Interrupt enable */
#define SBS_FPUIMR_FPU_IE_1_Msk          (0x1UL << SBS_FPUIMR_FPU_IE_1_Pos)          /*!< 0x00000002 */
#define SBS_FPUIMR_FPU_IE_1_Pos          (1U)
#define SBS_FPUIMR_FPU_IE_2              SBS_FPUIMR_FPU_IE_2_Msk                     /*!< Underflow Interrupt enable */
#define SBS_FPUIMR_FPU_IE_2_Msk          (0x1UL << SBS_FPUIMR_FPU_IE_2_Pos)          /*!< 0x00000004 */
#define SBS_FPUIMR_FPU_IE_2_Pos          (2U)
#define SBS_FPUIMR_FPU_IE_3              SBS_FPUIMR_FPU_IE_3_Msk                     /*!< Overflow Interrupt enable */
#define SBS_FPUIMR_FPU_IE_3_Msk          (0x1UL << SBS_FPUIMR_FPU_IE_3_Pos)          /*!< 0x00000008 */
#define SBS_FPUIMR_FPU_IE_3_Pos          (3U)
#define SBS_FPUIMR_FPU_IE_4              SBS_FPUIMR_FPU_IE_4_Msk                     /*!< Input denormal Interrupt enable */
#define SBS_FPUIMR_FPU_IE_4_Msk          (0x1UL << SBS_FPUIMR_FPU_IE_4_Pos)          /*!< 0x00000010 */
#define SBS_FPUIMR_FPU_IE_4_Pos          (4U)
#define SBS_FPUIMR_FPU_IE_5              SBS_FPUIMR_FPU_IE_5_Msk                     /*!< Inexact Interrupt enable */
#define SBS_FPUIMR_FPU_IE_5_Msk          (0x1UL << SBS_FPUIMR_FPU_IE_5_Pos)          /*!< 0x00000020 */
#define SBS_FPUIMR_FPU_IE_5_Pos          (5U)
#define SBS_HDPLCR_INCR_HDPL             SBS_HDPLCR_INCR_HDPL_Msk                    /*!< Increment HDPL */
#define SBS_HDPLCR_INCR_HDPL_Msk         (0xFFUL << SBS_HDPLCR_INCR_HDPL_Pos)        /*!< 0x000000FF */
#define SBS_HDPLCR_INCR_HDPL_Pos         (0U)
#define SBS_HDPLSR_HDPL                  SBS_HDPLSR_HDPL_Msk                         /*!< Hide protection level */
#define SBS_HDPLSR_HDPL_Msk              (0xFFUL << SBS_HDPLSR_HDPL_Pos)             /*!< 0x000000FF */
#define SBS_HDPLSR_HDPL_Pos              (0U)
#define SBS_MESR_MEF                     SBS_MESR_MEF_Msk                            /*!< Memory erase flag */
#define SBS_MESR_MEF_Msk                 (0x1UL << SBS_MESR_MEF_Pos)                 /*!< 0x00000001 */
#define SBS_MESR_MEF_Pos                 (0U)
#define SBS_PMCR_AXISRAM_WS              SBS_PMCR_AXISRAM_WS_Msk                     /*!< AXISRAM wait state */
#define SBS_PMCR_AXISRAM_WS_Msk          (0x1UL << SBS_PMCR_AXISRAM_WS_Pos)          /*!< 0x10000000 */
#define SBS_PMCR_AXISRAM_WS_Pos          (28U)
#define SBS_PMCR_BOOSTEN                 SBS_PMCR_BOOSTEN_Msk                        /*!< Booster enable */
#define SBS_PMCR_BOOSTEN_Msk             (0x1UL << SBS_PMCR_BOOSTEN_Pos)             /*!< 0x00000100 */
#define SBS_PMCR_BOOSTEN_Pos             (8U)
#define SBS_PMCR_BOOSTVDDSEL             SBS_PMCR_BOOSTVDDSEL_Msk                    /*!< Booster Vdd selection */
#define SBS_PMCR_BOOSTVDDSEL_Msk         (0x1UL << SBS_PMCR_BOOSTVDDSEL_Pos)         /*!< 0x00000200 */
#define SBS_PMCR_BOOSTVDDSEL_Pos         (9U)
#define SBS_PMCR_ETH_PHYSEL              SBS_PMCR_ETH_PHYSEL_Msk                     /*!< Ethernet PHY interface selection */
#define SBS_PMCR_ETH_PHYSEL_2            (0x4UL << SBS_PMCR_ETH_PHYSEL_Pos)          /*!< 0x00800000 */
#define SBS_PMCR_ETH_PHYSEL_Msk          (0x7UL << SBS_PMCR_ETH_PHYSEL_Pos)          /*!< 0x00E00000 */
#define SBS_PMCR_ETH_PHYSEL_Pos          (21U)
#define SBS_RSSCMDR_RSSCMD               SBS_RSSCMDR_RSSCMD_Msk                      /*!< RSS command */
#define SBS_RSSCMDR_RSSCMD_Msk           (0xFFFFUL << SBS_RSSCMDR_RSSCMD_Pos)        /*!< 0x0000FFFF */
#define SBS_RSSCMDR_RSSCMD_Pos           (0U)
#define SysTick_CTRL_CLKSOURCE_Msk         (1UL << SysTick_CTRL_CLKSOURCE_Pos)            /*!< SysTick CTRL: CLKSOURCE Mask */
#define SysTick_CTRL_CLKSOURCE_Pos          2U                                            /*!< SysTick CTRL: CLKSOURCE Position */
#define SysTick_CTRL_COUNTFLAG_Msk         (1UL << SysTick_CTRL_COUNTFLAG_Pos)            /*!< SysTick CTRL: COUNTFLAG Mask */
#define SysTick_CTRL_COUNTFLAG_Pos         16U                                            /*!< SysTick CTRL: COUNTFLAG Position */
#define SysTick_CTRL_ENABLE_Msk            (1UL /*<< SysTick_CTRL_ENABLE_Pos*/)           /*!< SysTick CTRL: ENABLE Mask */
#define VREFBUF_CCR_TRIM            VREFBUF_CCR_TRIM_Msk                       /*!<TRIM[5:0] bits (Trimming code)  */
#define VREFBUF_CCR_TRIM_Msk        (0x3FUL << VREFBUF_CCR_TRIM_Pos)           /*!< 0x0000003F */
#define VREFBUF_CCR_TRIM_Pos        (0U)
#define VREFBUF_CSR_ENVR            VREFBUF_CSR_ENVR_Msk                       /*!<Voltage reference buffer enable */
#define VREFBUF_CSR_ENVR_Msk        (0x1UL << VREFBUF_CSR_ENVR_Pos)            /*!< 0x00000001 */
#define VREFBUF_CSR_ENVR_Pos        (0U)
#define VREFBUF_CSR_HIZ             VREFBUF_CSR_HIZ_Msk                        /*!<High impedance mode             */
#define VREFBUF_CSR_HIZ_Msk         (0x1UL << VREFBUF_CSR_HIZ_Pos)             /*!< 0x00000002 */
#define VREFBUF_CSR_HIZ_Pos         (1U)
#define VREFBUF_CSR_VRR             VREFBUF_CSR_VRR_Msk                        /*!<Voltage reference buffer ready  */
#define VREFBUF_CSR_VRR_Msk         (0x1UL << VREFBUF_CSR_VRR_Pos)             /*!< 0x00000008 */
#define VREFBUF_CSR_VRR_Pos         (3U)
#define VREFBUF_CSR_VRS             VREFBUF_CSR_VRS_Msk                        /*!<Voltage reference scale         */
#define VREFBUF_CSR_VRS_Msk         (0x7UL << VREFBUF_CSR_VRS_Pos)             /*!< 0x00000070 */
#define VREFBUF_CSR_VRS_OUT1        ((uint32_t)0x00000000)                     /*!<Voltage reference VREF_OUT1     */
#define VREFBUF_CSR_VRS_OUT2        VREFBUF_CSR_VRS_OUT2_Msk                   /*!<Voltage reference VREF_OUT2     */
#define VREFBUF_CSR_VRS_OUT2_Msk    (0x1UL << VREFBUF_CSR_VRS_OUT2_Pos)        /*!< 0x00000010 */
#define VREFBUF_CSR_VRS_OUT2_Pos    (4U)
#define VREFBUF_CSR_VRS_OUT3        VREFBUF_CSR_VRS_OUT3_Msk                   /*!<Voltage reference VREF_OUT3     */
#define VREFBUF_CSR_VRS_OUT3_Msk    (0x1UL << VREFBUF_CSR_VRS_OUT3_Pos)        /*!< 0x00000020 */
#define VREFBUF_CSR_VRS_OUT3_Pos    (5U)
#define VREFBUF_CSR_VRS_OUT4        VREFBUF_CSR_VRS_OUT4_Msk                   /*!<Voltage reference VREF_OUT4     */
#define VREFBUF_CSR_VRS_OUT4_Msk    (0x3UL << VREFBUF_CSR_VRS_OUT4_Pos)        /*!< 0x00000030 */
#define VREFBUF_CSR_VRS_OUT4_Pos    (4U)
#define VREFBUF_CSR_VRS_Pos         (4U)
