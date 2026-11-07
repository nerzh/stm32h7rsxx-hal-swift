/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 * Unchanged layouts/bits extracted from CMSIS stm32h7s3xx.h at
 * 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
 * See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt. */
#ifndef C_RCC_CONTROL_LAYOUTS_H
#define C_RCC_CONTROL_LAYOUTS_H
#include <stdint.h>
#ifndef __IO
#define __IO volatile
#endif
#ifndef __I
#define __I volatile const
#endif
#ifndef __O
#define __O volatile
#endif
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
#endif
