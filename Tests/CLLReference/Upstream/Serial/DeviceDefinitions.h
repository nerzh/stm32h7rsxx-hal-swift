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
  __IO uint32_t CR1;         /*!< USART Control register 1,                    Address offset: 0x00 */
  __IO uint32_t CR2;         /*!< USART Control register 2,                    Address offset: 0x04 */
  __IO uint32_t CR3;         /*!< USART Control register 3,                    Address offset: 0x08 */
  __IO uint32_t BRR;         /*!< USART Baud rate register,                    Address offset: 0x0C */
  __IO uint32_t GTPR;        /*!< USART Guard time and prescaler register,     Address offset: 0x10 */
  __IO uint32_t RTOR;        /*!< USART Receiver Time Out register,            Address offset: 0x14 */
  __IO uint32_t RQR;         /*!< USART Request register,                      Address offset: 0x18 */
  __IO uint32_t ISR;         /*!< USART Interrupt and status register,         Address offset: 0x1C */
  __IO uint32_t ICR;         /*!< USART Interrupt flag Clear register,         Address offset: 0x20 */
  __IO uint32_t RDR;         /*!< USART Receive Data register,                 Address offset: 0x24 */
  __IO uint32_t TDR;         /*!< USART Transmit Data register,                Address offset: 0x28 */
  __IO uint32_t PRESC;       /*!< USART Prescaler register,                    Address offset: 0x2C */
} USART_TypeDef;
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
typedef enum
{
  SUCCESS = 0,
  ERROR = !SUCCESS
} ErrorStatus;
#define APB1PERIPH_BASE                 PERIPH_BASE
#define APB2PERIPH_BASE                 (PERIPH_BASE + 0x02000000UL)
#define APB4PERIPH_BASE                 (PERIPH_BASE + 0x18000000UL)
#define FLASH_ACR_LATENCY                    FLASH_ACR_LATENCY_Msk                               /*!< Read Latency */
#define FLASH_ACR_LATENCY_0                  (0x1UL << FLASH_ACR_LATENCY_Pos)                    /*!< 0x00000001 */
#define FLASH_ACR_LATENCY_1                  (0x2UL << FLASH_ACR_LATENCY_Pos)                    /*!< 0x00000002 */
#define FLASH_ACR_LATENCY_Msk                (0xFUL << FLASH_ACR_LATENCY_Pos)                    /*!< 0x0000000F */
#define FLASH_ACR_LATENCY_Pos                (0U)
#define FLASH_LATENCY_DEFAULT                (FLASH_ACR_LATENCY_1 | FLASH_ACR_LATENCY_0) /* default flash latency 3WS ) */
#define IS_LPUART_INSTANCE(INSTANCE)    ((INSTANCE) == LPUART1)
#define IS_UART_INSTANCE(INSTANCE) (((INSTANCE) == USART1) ||                                      ((INSTANCE) == USART2) ||                                      ((INSTANCE) == USART3) ||                                      ((INSTANCE) == UART4)  ||                                      ((INSTANCE) == UART5)  ||                                      ((INSTANCE) == UART7)  ||                                      ((INSTANCE) == UART8))
#define IS_USART_INSTANCE(INSTANCE) (((INSTANCE) == USART1) ||                                       ((INSTANCE) == USART2) ||                                       ((INSTANCE) == USART3))
#define LPUART1_BASE                    (APB4PERIPH_BASE + 0x0C00UL)
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
#define UART4_BASE                      (APB1PERIPH_BASE + 0x4C00UL)
#define UART5_BASE                      (APB1PERIPH_BASE + 0x5000UL)
#define UART7_BASE                      (APB1PERIPH_BASE + 0x7800UL)
#define UART8_BASE                      (APB1PERIPH_BASE + 0x7C00UL)
#define USART1_BASE                     (APB2PERIPH_BASE + 0x1000UL)
#define USART2_BASE                     (APB1PERIPH_BASE + 0x4400UL)
#define USART3_BASE                     (APB1PERIPH_BASE + 0x4800UL)
#define USART_CR1_CMIE                  USART_CR1_CMIE_Msk                      /*!< Character match interrupt enable */
#define USART_CR1_CMIE_Msk              (0x1UL << USART_CR1_CMIE_Pos)           /*!< 0x00004000 */
#define USART_CR1_CMIE_Pos              (14U)
#define USART_CR1_DEAT                  USART_CR1_DEAT_Msk                      /*!< DEAT[4:0] bits (Driver Enable Assertion Time) */
#define USART_CR1_DEAT_Msk              (0x1FUL << USART_CR1_DEAT_Pos)          /*!< 0x03E00000 */
#define USART_CR1_DEAT_Pos              (21U)
#define USART_CR1_DEDT                  USART_CR1_DEDT_Msk                      /*!< DEDT[4:0] bits (Driver Enable Deassertion Time) */
#define USART_CR1_DEDT_Msk              (0x1FUL << USART_CR1_DEDT_Pos)          /*!< 0x001F0000 */
#define USART_CR1_DEDT_Pos              (16U)
#define USART_CR1_EOBIE                 USART_CR1_EOBIE_Msk                     /*!< End of Block Interrupt Enable */
#define USART_CR1_EOBIE_Msk             (0x1UL << USART_CR1_EOBIE_Pos)          /*!< 0x08000000 */
#define USART_CR1_EOBIE_Pos             (27U)
#define USART_CR1_FIFOEN                USART_CR1_FIFOEN_Msk                    /*!< FIFO mode enable */
#define USART_CR1_FIFOEN_Msk            (0x1UL << USART_CR1_FIFOEN_Pos)         /*!< 0x20000000 */
#define USART_CR1_FIFOEN_Pos            (29U)
#define USART_CR1_IDLEIE                USART_CR1_IDLEIE_Msk                    /*!< IDLE Interrupt Enable */
#define USART_CR1_IDLEIE_Msk            (0x1UL << USART_CR1_IDLEIE_Pos)         /*!< 0x00000010 */
#define USART_CR1_IDLEIE_Pos            (4U)
#define USART_CR1_M                     USART_CR1_M_Msk                        /*!< Word length */
#define USART_CR1_M0                    USART_CR1_M0_Msk                        /*!< Word length - Bit 0 */
#define USART_CR1_M0_Msk                (0x1UL << USART_CR1_M0_Pos)             /*!< 0x00001000 */
#define USART_CR1_M0_Pos                (12U)
#define USART_CR1_M1                    USART_CR1_M1_Msk                        /*!< Word length - Bit 1 */
#define USART_CR1_M1_Msk                (0x1UL << USART_CR1_M1_Pos)             /*!< 0x10000000 */
#define USART_CR1_M1_Pos                (28U)
#define USART_CR1_MME                   USART_CR1_MME_Msk                       /*!< Mute Mode Enable */
#define USART_CR1_MME_Msk               (0x1UL << USART_CR1_MME_Pos)            /*!< 0x00002000 */
#define USART_CR1_MME_Pos               (13U)
#define USART_CR1_M_Msk                 (0x10001UL << USART_CR1_M_Pos)         /*!< 0x10001000 */
#define USART_CR1_M_Pos                 (12U)
#define USART_CR1_OVER8                 USART_CR1_OVER8_Msk                     /*!< Oversampling by 8-bit or 16-bit mode */
#define USART_CR1_OVER8_Msk             (0x1UL << USART_CR1_OVER8_Pos)          /*!< 0x00008000 */
#define USART_CR1_OVER8_Pos             (15U)
#define USART_CR1_PCE                   USART_CR1_PCE_Msk                       /*!< Parity Control Enable */
#define USART_CR1_PCE_Msk               (0x1UL << USART_CR1_PCE_Pos)            /*!< 0x00000400 */
#define USART_CR1_PCE_Pos               (10U)
#define USART_CR1_PEIE                  USART_CR1_PEIE_Msk                      /*!< PE Interrupt Enable */
#define USART_CR1_PEIE_Msk              (0x1UL << USART_CR1_PEIE_Pos)           /*!< 0x00000100 */
#define USART_CR1_PEIE_Pos              (8U)
#define USART_CR1_PS                    USART_CR1_PS_Msk                        /*!< Parity Selection */
#define USART_CR1_PS_Msk                (0x1UL << USART_CR1_PS_Pos)             /*!< 0x00000200 */
#define USART_CR1_PS_Pos                (9U)
#define USART_CR1_RE                    USART_CR1_RE_Msk                        /*!< Receiver Enable */
#define USART_CR1_RE_Msk                (0x1UL << USART_CR1_RE_Pos)             /*!< 0x00000004 */
#define USART_CR1_RE_Pos                (2U)
#define USART_CR1_RTOIE                 USART_CR1_RTOIE_Msk                     /*!< Receive Time Out Interrupt Enable */
#define USART_CR1_RTOIE_Msk             (0x1UL << USART_CR1_RTOIE_Pos)          /*!< 0x04000000 */
#define USART_CR1_RTOIE_Pos             (26U)
#define USART_CR1_RXFFIE                USART_CR1_RXFFIE_Msk                    /*!< RX FIFO Full Interrupt Enable */
#define USART_CR1_RXFFIE_Msk            (0x1UL << USART_CR1_RXFFIE_Pos)         /*!< 0x80000000 */
#define USART_CR1_RXFFIE_Pos            (31U)
#define USART_CR1_RXNEIE_Msk            (0x1UL << USART_CR1_RXNEIE_Pos)         /*!< 0x00000020 */
#define USART_CR1_RXNEIE_Pos            (5U)
#define USART_CR1_RXNEIE_RXFNEIE        USART_CR1_RXNEIE_Msk                    /*!< RXNE and RX FIFO Not Empty Interrupt Enable */
#define USART_CR1_TCIE                  USART_CR1_TCIE_Msk                      /*!< Transmission Complete Interrupt Enable */
#define USART_CR1_TCIE_Msk              (0x1UL << USART_CR1_TCIE_Pos)           /*!< 0x00000040 */
#define USART_CR1_TCIE_Pos              (6U)
#define USART_CR1_TE                    USART_CR1_TE_Msk                        /*!< Transmitter Enable */
#define USART_CR1_TE_Msk                (0x1UL << USART_CR1_TE_Pos)             /*!< 0x00000008 */
#define USART_CR1_TE_Pos                (3U)
#define USART_CR1_TXEIE                 USART_CR1_TXEIE_Msk                     /*!< TXE Interrupt Enable */
#define USART_CR1_TXEIE_Msk             (0x1UL << USART_CR1_TXEIE_Pos)          /*!< 0x00000080 */
#define USART_CR1_TXEIE_Pos             (7U)
#define USART_CR1_TXEIE_TXFNFIE         USART_CR1_TXEIE                         /*!< TXE and TX FIFO Not Full Interrupt Enable */
#define USART_CR1_TXFEIE                USART_CR1_TXFEIE_Msk                    /*!< TX FIFO Empty Interrupt Enable */
#define USART_CR1_TXFEIE_Msk            (0x1UL << USART_CR1_TXFEIE_Pos)         /*!< 0x40000000 */
#define USART_CR1_TXFEIE_Pos            (30U)
#define USART_CR1_UE                    USART_CR1_UE_Msk                        /*!< USART Enable */
#define USART_CR1_UESM                  USART_CR1_UESM_Msk                      /*!< USART Enable in STOP Mode */
#define USART_CR1_UESM_Msk              (0x1UL << USART_CR1_UESM_Pos)           /*!< 0x00000002 */
#define USART_CR1_UESM_Pos              (1U)
#define USART_CR1_UE_Msk                (0x1UL << USART_CR1_UE_Pos)             /*!< 0x00000001 */
#define USART_CR1_UE_Pos                (0U)
#define USART_CR1_WAKE                  USART_CR1_WAKE_Msk                      /*!< Receiver Wakeup method */
#define USART_CR1_WAKE_Msk              (0x1UL << USART_CR1_WAKE_Pos)           /*!< 0x00000800 */
#define USART_CR1_WAKE_Pos              (11U)
#define USART_CR2_ABREN                 USART_CR2_ABREN_Msk                     /*!< Auto Baud-Rate Enable*/
#define USART_CR2_ABREN_Msk             (0x1UL << USART_CR2_ABREN_Pos)          /*!< 0x00100000 */
#define USART_CR2_ABREN_Pos             (20U)
#define USART_CR2_ABRMODE               USART_CR2_ABRMODE_Msk                   /*!< ABRMOD[1:0] bits (Auto Baud-Rate Mode) */
#define USART_CR2_ABRMODE_0             (0x1UL << USART_CR2_ABRMODE_Pos)        /*!< 0x00200000 */
#define USART_CR2_ABRMODE_1             (0x2UL << USART_CR2_ABRMODE_Pos)        /*!< 0x00400000 */
#define USART_CR2_ABRMODE_Msk           (0x3UL << USART_CR2_ABRMODE_Pos)        /*!< 0x00600000 */
#define USART_CR2_ABRMODE_Pos           (21U)
#define USART_CR2_ADD                   USART_CR2_ADD_Msk                       /*!< Address of the USART node */
#define USART_CR2_ADDM7                 USART_CR2_ADDM7_Msk                     /*!< 7-bit or 4-bit Address Detection */
#define USART_CR2_ADDM7_Msk             (0x1UL << USART_CR2_ADDM7_Pos)          /*!< 0x00000010 */
#define USART_CR2_ADDM7_Pos             (4U)
#define USART_CR2_ADD_Msk               (0xFFUL << USART_CR2_ADD_Pos)           /*!< 0xFF000000 */
#define USART_CR2_ADD_Pos               (24U)
#define USART_CR2_CLKEN                 USART_CR2_CLKEN_Msk                     /*!< Clock Enable */
#define USART_CR2_CLKEN_Msk             (0x1UL << USART_CR2_CLKEN_Pos)          /*!< 0x00000800 */
#define USART_CR2_CLKEN_Pos             (11U)
#define USART_CR2_CPHA                  USART_CR2_CPHA_Msk                      /*!< Clock Phase */
#define USART_CR2_CPHA_Msk              (0x1UL << USART_CR2_CPHA_Pos)           /*!< 0x00000200 */
#define USART_CR2_CPHA_Pos              (9U)
#define USART_CR2_CPOL                  USART_CR2_CPOL_Msk                      /*!< Clock Polarity */
#define USART_CR2_CPOL_Msk              (0x1UL << USART_CR2_CPOL_Pos)           /*!< 0x00000400 */
#define USART_CR2_CPOL_Pos              (10U)
#define USART_CR2_DATAINV               USART_CR2_DATAINV_Msk                   /*!< Binary data inversion */
#define USART_CR2_DATAINV_Msk           (0x1UL << USART_CR2_DATAINV_Pos)        /*!< 0x00040000 */
#define USART_CR2_DATAINV_Pos           (18U)
#define USART_CR2_DIS_NSS               USART_CR2_DIS_NSS_Msk                   /*!< Slave Select (NSS) pin management */
#define USART_CR2_DIS_NSS_Msk           (0x1UL << USART_CR2_DIS_NSS_Pos)        /*!< 0x00000008 */
#define USART_CR2_DIS_NSS_Pos           (3U)
#define USART_CR2_LBCL                  USART_CR2_LBCL_Msk                      /*!< Last Bit Clock pulse */
#define USART_CR2_LBCL_Msk              (0x1UL << USART_CR2_LBCL_Pos)           /*!< 0x00000100 */
#define USART_CR2_LBCL_Pos              (8U)
#define USART_CR2_LBDIE                 USART_CR2_LBDIE_Msk                     /*!< LIN Break Detection Interrupt Enable */
#define USART_CR2_LBDIE_Msk             (0x1UL << USART_CR2_LBDIE_Pos)          /*!< 0x00000040 */
#define USART_CR2_LBDIE_Pos             (6U)
#define USART_CR2_LBDL                  USART_CR2_LBDL_Msk                      /*!< LIN Break Detection Length */
#define USART_CR2_LBDL_Msk              (0x1UL << USART_CR2_LBDL_Pos)           /*!< 0x00000020 */
#define USART_CR2_LBDL_Pos              (5U)
#define USART_CR2_LINEN                 USART_CR2_LINEN_Msk                     /*!< LIN mode enable */
#define USART_CR2_LINEN_Msk             (0x1UL << USART_CR2_LINEN_Pos)          /*!< 0x00004000 */
#define USART_CR2_LINEN_Pos             (14U)
#define USART_CR2_MSBFIRST              USART_CR2_MSBFIRST_Msk                  /*!< Most Significant Bit First */
#define USART_CR2_MSBFIRST_Msk          (0x1UL << USART_CR2_MSBFIRST_Pos)       /*!< 0x00080000 */
#define USART_CR2_MSBFIRST_Pos          (19U)
#define USART_CR2_RTOEN                 USART_CR2_RTOEN_Msk                     /*!< Receiver Time-Out enable */
#define USART_CR2_RTOEN_Msk             (0x1UL << USART_CR2_RTOEN_Pos)          /*!< 0x00800000 */
#define USART_CR2_RTOEN_Pos             (23U)
#define USART_CR2_RXINV                 USART_CR2_RXINV_Msk                     /*!< RX pin active level inversion */
#define USART_CR2_RXINV_Msk             (0x1UL << USART_CR2_RXINV_Pos)          /*!< 0x00010000 */
#define USART_CR2_RXINV_Pos             (16U)
#define USART_CR2_SLVEN                 USART_CR2_SLVEN_Msk                     /*!< Synchronous Slave mode enable */
#define USART_CR2_SLVEN_Msk             (0x1UL << USART_CR2_SLVEN_Pos)          /*!< 0x00000001 */
#define USART_CR2_SLVEN_Pos             (0U)
#define USART_CR2_STOP                  USART_CR2_STOP_Msk                      /*!< STOP[1:0] bits (STOP bits) */
#define USART_CR2_STOP_0                (0x1UL << USART_CR2_STOP_Pos)           /*!< 0x00001000 */
#define USART_CR2_STOP_1                (0x2UL << USART_CR2_STOP_Pos)           /*!< 0x00002000 */
#define USART_CR2_STOP_Msk              (0x3UL << USART_CR2_STOP_Pos)           /*!< 0x00003000 */
#define USART_CR2_STOP_Pos              (12U)
#define USART_CR2_SWAP                  USART_CR2_SWAP_Msk                      /*!< SWAP TX/RX pins */
#define USART_CR2_SWAP_Msk              (0x1UL << USART_CR2_SWAP_Pos)           /*!< 0x00008000 */
#define USART_CR2_SWAP_Pos              (15U)
#define USART_CR2_TXINV                 USART_CR2_TXINV_Msk                     /*!< TX pin active level inversion */
#define USART_CR2_TXINV_Msk             (0x1UL << USART_CR2_TXINV_Pos)          /*!< 0x00020000 */
#define USART_CR2_TXINV_Pos             (17U)
#define USART_CR3_CTSE                  USART_CR3_CTSE_Msk
#define USART_CR3_CTSE_Msk              (0x1UL << USART_CR3_CTSE_Pos)           /*!< 0x00000200 */
#define USART_CR3_CTSE_Pos              (9U)
#define USART_CR3_CTSIE                 USART_CR3_CTSIE_Msk                     /*!< CTS Interrupt Enable */
#define USART_CR3_CTSIE_Msk             (0x1UL << USART_CR3_CTSIE_Pos)          /*!< 0x00000400 */
#define USART_CR3_CTSIE_Pos             (10U)
#define USART_CR3_DDRE                  USART_CR3_DDRE_Msk                      /*!< DMA Disable on Reception Error */
#define USART_CR3_DDRE_Msk              (0x1UL << USART_CR3_DDRE_Pos)           /*!< 0x00002000 */
#define USART_CR3_DDRE_Pos              (13U)
#define USART_CR3_DEM                   USART_CR3_DEM_Msk                       /*!< Driver Enable Mode */
#define USART_CR3_DEM_Msk               (0x1UL << USART_CR3_DEM_Pos)            /*!< 0x00004000 */
#define USART_CR3_DEM_Pos               (14U)
#define USART_CR3_DEP                   USART_CR3_DEP_Msk                       /*!< Driver Enable Polarity Selection */
#define USART_CR3_DEP_Msk               (0x1UL << USART_CR3_DEP_Pos)            /*!< 0x00008000 */
#define USART_CR3_DEP_Pos               (15U)
#define USART_CR3_DMAR                  USART_CR3_DMAR_Msk                      /*!< DMA Enable Receiver */
#define USART_CR3_DMAR_Msk              (0x1UL << USART_CR3_DMAR_Pos)           /*!< 0x00000040 */
#define USART_CR3_DMAR_Pos              (6U)
#define USART_CR3_DMAT                  USART_CR3_DMAT_Msk                      /*!< DMA Enable Transmitter */
#define USART_CR3_DMAT_Msk              (0x1UL << USART_CR3_DMAT_Pos)           /*!< 0x00000080 */
#define USART_CR3_DMAT_Pos              (7U)
#define USART_CR3_EIE                   USART_CR3_EIE_Msk                       /*!< Error Interrupt Enable */
#define USART_CR3_EIE_Msk               (0x1UL << USART_CR3_EIE_Pos)            /*!< 0x00000001 */
#define USART_CR3_EIE_Pos               (0U)
#define USART_CR3_HDSEL                 USART_CR3_HDSEL_Msk                     /*!< Half-Duplex Selection */
#define USART_CR3_HDSEL_Msk             (0x1UL << USART_CR3_HDSEL_Pos)          /*!< 0x00000008 */
#define USART_CR3_HDSEL_Pos             (3U)
#define USART_CR3_IREN                  USART_CR3_IREN_Msk                      /*!< IrDA mode Enable */
#define USART_CR3_IREN_Msk              (0x1UL << USART_CR3_IREN_Pos)           /*!< 0x00000002 */
#define USART_CR3_IREN_Pos              (1U)
#define USART_CR3_IRLP                  USART_CR3_IRLP_Msk                      /*!< IrDA Low-Power */
#define USART_CR3_IRLP_Msk              (0x1UL << USART_CR3_IRLP_Pos)           /*!< 0x00000004 */
#define USART_CR3_IRLP_Pos              (2U)
#define USART_CR3_NACK                  USART_CR3_NACK_Msk                      /*!< SmartCard NACK enable */
#define USART_CR3_NACK_Msk              (0x1UL << USART_CR3_NACK_Pos)           /*!< 0x00000010 */
#define USART_CR3_NACK_Pos              (4U)
#define USART_CR3_ONEBIT                USART_CR3_ONEBIT_Msk                    /*!< One sample bit method enable */
#define USART_CR3_ONEBIT_Msk            (0x1UL << USART_CR3_ONEBIT_Pos)         /*!< 0x00000800 */
#define USART_CR3_ONEBIT_Pos            (11U)
#define USART_CR3_OVRDIS                USART_CR3_OVRDIS_Msk                    /*!< Overrun Disable */
#define USART_CR3_OVRDIS_Msk            (0x1UL << USART_CR3_OVRDIS_Pos)         /*!< 0x00001000 */
#define USART_CR3_OVRDIS_Pos            (12U)
#define USART_CR3_RTSE                  USART_CR3_RTSE_Msk                      /*!< RTS Enable */
#define USART_CR3_RTSE_Msk              (0x1UL << USART_CR3_RTSE_Pos)           /*!< 0x00000100 */
#define USART_CR3_RTSE_Pos              (8U)
#define USART_CR3_RXFTCFG               USART_CR3_RXFTCFG_Msk                   /*!< RX FIFO Threshold Configuration */
#define USART_CR3_RXFTCFG_Msk           (0x7UL << USART_CR3_RXFTCFG_Pos)        /*!< 0x0E000000 */
#define USART_CR3_RXFTCFG_Pos           (25U)
#define USART_CR3_RXFTIE                USART_CR3_RXFTIE_Msk                    /*!< RX FIFO Threshold Interrupt Enable */
#define USART_CR3_RXFTIE_Msk            (0x1UL << USART_CR3_RXFTIE_Pos)         /*!< 0x10000000 */
#define USART_CR3_RXFTIE_Pos            (28U)
#define USART_CR3_SCARCNT               USART_CR3_SCARCNT_Msk                   /*!< SCARCNT[2:0] bits (SmartCard Auto-Retry Count) */
#define USART_CR3_SCARCNT_Msk           (0x7UL << USART_CR3_SCARCNT_Pos)        /*!< 0x000E0000 */
#define USART_CR3_SCARCNT_Pos           (17U)
#define USART_CR3_SCEN                  USART_CR3_SCEN_Msk                      /*!< SmartCard mode enable */
#define USART_CR3_SCEN_Msk              (0x1UL << USART_CR3_SCEN_Pos)           /*!< 0x00000020 */
#define USART_CR3_SCEN_Pos              (5U)
#define USART_CR3_TCBGTIE               USART_CR3_TCBGTIE_Msk                   /*!< Transmission Complete Before Guard Time Interrupt Enable */
#define USART_CR3_TCBGTIE_Msk           (0x1UL << USART_CR3_TCBGTIE_Pos)        /*!< 0x01000000 */
#define USART_CR3_TCBGTIE_Pos           (24U)
#define USART_CR3_TXFTCFG               USART_CR3_TXFTCFG_Msk                   /*!< TX FIFO Threshold configuration */
#define USART_CR3_TXFTCFG_Msk           (0x7UL << USART_CR3_TXFTCFG_Pos)        /*!< 0xE0000000 */
#define USART_CR3_TXFTCFG_Pos           (29U)
#define USART_CR3_TXFTIE                USART_CR3_TXFTIE_Msk                    /*!< TX FIFO Threshold Interrupt Enable */
#define USART_CR3_TXFTIE_Msk            (0x1UL << USART_CR3_TXFTIE_Pos)         /*!< 0x00800000 */
#define USART_CR3_TXFTIE_Pos            (23U)
#define USART_CR3_WUFIE                 USART_CR3_WUFIE_Msk                     /*!< Wake Up Interrupt Enable */
#define USART_CR3_WUFIE_Msk             (0x1UL << USART_CR3_WUFIE_Pos)          /*!< 0x00400000 */
#define USART_CR3_WUFIE_Pos             (22U)
#define USART_CR3_WUS                   USART_CR3_WUS_Msk                       /*!< WUS[1:0] bits (Wake UP Interrupt Flag Selection) */
#define USART_CR3_WUS_0                 (0x1UL << USART_CR3_WUS_Pos)            /*!< 0x00100000 */
#define USART_CR3_WUS_1                 (0x2UL << USART_CR3_WUS_Pos)            /*!< 0x00200000 */
#define USART_CR3_WUS_Msk               (0x3UL << USART_CR3_WUS_Pos)            /*!< 0x00300000 */
#define USART_CR3_WUS_Pos               (20U)
#define USART_GTPR_GT                   USART_GTPR_GT_Msk                       /*!< GT[7:0] bits (Guard time value) */
#define USART_GTPR_GT_Msk               (0xFFUL << USART_GTPR_GT_Pos)           /*!< 0x0000FF00 */
#define USART_GTPR_GT_Pos               (8U)
#define USART_GTPR_PSC                  USART_GTPR_PSC_Msk                      /*!< PSC[7:0] bits (Prescaler value) */
#define USART_GTPR_PSC_Msk              (0xFFUL << USART_GTPR_PSC_Pos)          /*!< 0x000000FF */
#define USART_GTPR_PSC_Pos              (0U)
#define USART_ICR_CMCF                  USART_ICR_CMCF_Msk                      /*!< Character Match Clear Flag */
#define USART_ICR_CMCF_Msk              (0x1UL << USART_ICR_CMCF_Pos)           /*!< 0x00020000 */
#define USART_ICR_CMCF_Pos              (17U)
#define USART_ICR_CTSCF                 USART_ICR_CTSCF_Msk                     /*!< CTS Interrupt Clear Flag */
#define USART_ICR_CTSCF_Msk             (0x1UL << USART_ICR_CTSCF_Pos)          /*!< 0x00000200 */
#define USART_ICR_CTSCF_Pos             (9U)
#define USART_ICR_EOBCF                 USART_ICR_EOBCF_Msk                     /*!< End Of Block Clear Flag */
#define USART_ICR_EOBCF_Msk             (0x1UL << USART_ICR_EOBCF_Pos)          /*!< 0x00001000 */
#define USART_ICR_EOBCF_Pos             (12U)
#define USART_ICR_FECF                  USART_ICR_FECF_Msk                      /*!< Framing Error Clear Flag */
#define USART_ICR_FECF_Msk              (0x1UL << USART_ICR_FECF_Pos)           /*!< 0x00000002 */
#define USART_ICR_FECF_Pos              (1U)
#define USART_ICR_IDLECF                USART_ICR_IDLECF_Msk                    /*!< IDLE line detected Clear Flag */
#define USART_ICR_IDLECF_Msk            (0x1UL << USART_ICR_IDLECF_Pos)         /*!< 0x00000010 */
#define USART_ICR_IDLECF_Pos            (4U)
#define USART_ICR_LBDCF                 USART_ICR_LBDCF_Msk                     /*!< LIN Break Detection Clear Flag */
#define USART_ICR_LBDCF_Msk             (0x1UL << USART_ICR_LBDCF_Pos)          /*!< 0x00000100 */
#define USART_ICR_LBDCF_Pos             (8U)
#define USART_ICR_NECF                  USART_ICR_NECF_Msk                      /*!< Noise Error detected Clear Flag */
#define USART_ICR_NECF_Msk              (0x1UL << USART_ICR_NECF_Pos)           /*!< 0x00000004 */
#define USART_ICR_NECF_Pos              (2U)
#define USART_ICR_ORECF                 USART_ICR_ORECF_Msk                     /*!< OverRun Error Clear Flag */
#define USART_ICR_ORECF_Msk             (0x1UL << USART_ICR_ORECF_Pos)          /*!< 0x00000008 */
#define USART_ICR_ORECF_Pos             (3U)
#define USART_ICR_PECF                  USART_ICR_PECF_Msk                      /*!< Parity Error Clear Flag */
#define USART_ICR_PECF_Msk              (0x1UL << USART_ICR_PECF_Pos)           /*!< 0x00000001 */
#define USART_ICR_PECF_Pos              (0U)
#define USART_ICR_RTOCF                 USART_ICR_RTOCF_Msk                     /*!< Receiver Time Out Clear Flag */
#define USART_ICR_RTOCF_Msk             (0x1UL << USART_ICR_RTOCF_Pos)          /*!< 0x00000800 */
#define USART_ICR_RTOCF_Pos             (11U)
#define USART_ICR_TCBGTCF               USART_ICR_TCBGTCF_Msk                   /*!< Transmission Complete Before Guard Time Clear Flag */
#define USART_ICR_TCBGTCF_Msk           (0x1UL << USART_ICR_TCBGTCF_Pos)        /*!< 0x00000080 */
#define USART_ICR_TCBGTCF_Pos           (7U)
#define USART_ICR_TCCF                  USART_ICR_TCCF_Msk                      /*!< Transmission Complete Clear Flag */
#define USART_ICR_TCCF_Msk              (0x1UL << USART_ICR_TCCF_Pos)           /*!< 0x00000040 */
#define USART_ICR_TCCF_Pos              (6U)
#define USART_ICR_TXFECF                USART_ICR_TXFECF_Msk                    /*!< TX FIFO Empty Clear Flag */
#define USART_ICR_TXFECF_Msk            (0x1UL << USART_ICR_TXFECF_Pos)         /*!< 0x00000020 */
#define USART_ICR_TXFECF_Pos            (5U)
#define USART_ICR_UDRCF                 USART_ICR_UDRCF_Msk                     /*!< SPI Slave Underrun Clear Flag */
#define USART_ICR_UDRCF_Msk             (0x1UL << USART_ICR_UDRCF_Pos)          /*!< 0x00002000 */
#define USART_ICR_UDRCF_Pos             (13U)
#define USART_ICR_WUCF                  USART_ICR_WUCF_Msk                      /*!< Wake Up from stop mode Clear Flag */
#define USART_ICR_WUCF_Msk              (0x1UL << USART_ICR_WUCF_Pos)           /*!< 0x00100000 */
#define USART_ICR_WUCF_Pos              (20U)
#define USART_ISR_ABRE                  USART_ISR_ABRE_Msk                      /*!< Auto-Baud Rate Error */
#define USART_ISR_ABRE_Msk              (0x1UL << USART_ISR_ABRE_Pos)           /*!< 0x00004000 */
#define USART_ISR_ABRE_Pos              (14U)
#define USART_ISR_ABRF                  USART_ISR_ABRF_Msk                      /*!< Auto-Baud Rate Flag */
#define USART_ISR_ABRF_Msk              (0x1UL << USART_ISR_ABRF_Pos)           /*!< 0x00008000 */
#define USART_ISR_ABRF_Pos              (15U)
#define USART_ISR_BUSY                  USART_ISR_BUSY_Msk                      /*!< Busy Flag */
#define USART_ISR_BUSY_Msk              (0x1UL << USART_ISR_BUSY_Pos)           /*!< 0x00010000 */
#define USART_ISR_BUSY_Pos              (16U)
#define USART_ISR_CMF                   USART_ISR_CMF_Msk                       /*!< Character Match Flag */
#define USART_ISR_CMF_Msk               (0x1UL << USART_ISR_CMF_Pos)            /*!< 0x00020000 */
#define USART_ISR_CMF_Pos               (17U)
#define USART_ISR_CTS                   USART_ISR_CTS_Msk                       /*!< CTS Flag */
#define USART_ISR_CTSIF                 USART_ISR_CTSIF_Msk                     /*!< CTS interrupt Flag */
#define USART_ISR_CTSIF_Msk             (0x1UL << USART_ISR_CTSIF_Pos)          /*!< 0x00000200 */
#define USART_ISR_CTSIF_Pos             (9U)
#define USART_ISR_CTS_Msk               (0x1UL << USART_ISR_CTS_Pos)            /*!< 0x00000400 */
#define USART_ISR_CTS_Pos               (10U)
#define USART_ISR_EOBF                  USART_ISR_EOBF_Msk                      /*!< End Of Block Flag */
#define USART_ISR_EOBF_Msk              (0x1UL << USART_ISR_EOBF_Pos)           /*!< 0x00001000 */
#define USART_ISR_EOBF_Pos              (12U)
#define USART_ISR_FE                    USART_ISR_FE_Msk                        /*!< Framing Error */
#define USART_ISR_FE_Msk                (0x1UL << USART_ISR_FE_Pos)             /*!< 0x00000002 */
#define USART_ISR_FE_Pos                (1U)
#define USART_ISR_IDLE                  USART_ISR_IDLE_Msk                      /*!< IDLE line detected */
#define USART_ISR_IDLE_Msk              (0x1UL << USART_ISR_IDLE_Pos)           /*!< 0x00000010 */
#define USART_ISR_IDLE_Pos              (4U)
#define USART_ISR_LBDF                  USART_ISR_LBDF_Msk                      /*!< LIN Break Detection Flag */
#define USART_ISR_LBDF_Msk              (0x1UL << USART_ISR_LBDF_Pos)           /*!< 0x00000100 */
#define USART_ISR_LBDF_Pos              (8U)
#define USART_ISR_NE                    USART_ISR_NE_Msk                        /*!< START bit Noise Error detection Flag */
#define USART_ISR_NE_Msk                (0x1UL << USART_ISR_NE_Pos)             /*!< 0x00000004 */
#define USART_ISR_NE_Pos                (2U)
#define USART_ISR_ORE                   USART_ISR_ORE_Msk                       /*!< OverRun Error */
#define USART_ISR_ORE_Msk               (0x1UL << USART_ISR_ORE_Pos)            /*!< 0x00000008 */
#define USART_ISR_ORE_Pos               (3U)
#define USART_ISR_PE                    USART_ISR_PE_Msk                        /*!< Parity Error */
#define USART_ISR_PE_Msk                (0x1UL << USART_ISR_PE_Pos)             /*!< 0x00000001 */
#define USART_ISR_PE_Pos                (0U)
#define USART_ISR_REACK                 USART_ISR_REACK_Msk                     /*!< Receive Enable Acknowledge Flag */
#define USART_ISR_REACK_Msk             (0x1UL << USART_ISR_REACK_Pos)          /*!< 0x00400000 */
#define USART_ISR_REACK_Pos             (22U)
#define USART_ISR_RTOF                  USART_ISR_RTOF_Msk                      /*!< Receiver Timeout */
#define USART_ISR_RTOF_Msk              (0x1UL << USART_ISR_RTOF_Pos)           /*!< 0x00000800 */
#define USART_ISR_RTOF_Pos              (11U)
#define USART_ISR_RWU                   USART_ISR_RWU_Msk                       /*!< Receive Wake Up from mute mode Flag */
#define USART_ISR_RWU_Msk               (0x1UL << USART_ISR_RWU_Pos)            /*!< 0x00080000 */
#define USART_ISR_RWU_Pos               (19U)
#define USART_ISR_RXFF                  USART_ISR_RXFF_Msk                      /*!< RX FIFO Full Flag */
#define USART_ISR_RXFF_Msk              (0x1UL << USART_ISR_RXFF_Pos)           /*!< 0x01000000 */
#define USART_ISR_RXFF_Pos              (24U)
#define USART_ISR_RXFT                  USART_ISR_RXFT_Msk                      /*!< RX FIFO Threshold Flag */
#define USART_ISR_RXFT_Msk              (0x1UL << USART_ISR_RXFT_Pos)           /*!< 0x04000000 */
#define USART_ISR_RXFT_Pos              (26U)
#define USART_ISR_RXNE_Msk              (0x1UL << USART_ISR_RXNE_Pos)           /*!< 0x00000020 */
#define USART_ISR_RXNE_Pos              (5U)
#define USART_ISR_RXNE_RXFNE            USART_ISR_RXNE_Msk                      /*!< Read Data Register or RX FIFO Not Empty */
#define USART_ISR_SBKF                  USART_ISR_SBKF_Msk                      /*!< Send Break Flag */
#define USART_ISR_SBKF_Msk              (0x1UL << USART_ISR_SBKF_Pos)           /*!< 0x00040000 */
#define USART_ISR_SBKF_Pos              (18U)
#define USART_ISR_TC                    USART_ISR_TC_Msk                        /*!< Transmission Complete */
#define USART_ISR_TCBGT                 USART_ISR_TCBGT_Msk                     /*!< Transmission Complete Before Guard Time completion */
#define USART_ISR_TCBGT_Msk             (0x1UL << USART_ISR_TCBGT_Pos)          /*!< 0x02000000 */
#define USART_ISR_TCBGT_Pos             (25U)
#define USART_ISR_TC_Msk                (0x1UL << USART_ISR_TC_Pos)             /*!< 0x00000040 */
#define USART_ISR_TC_Pos                (6U)
#define USART_ISR_TEACK                 USART_ISR_TEACK_Msk                     /*!< Transmit Enable Acknowledge Flag */
#define USART_ISR_TEACK_Msk             (0x1UL << USART_ISR_TEACK_Pos)          /*!< 0x00200000 */
#define USART_ISR_TEACK_Pos             (21U)
#define USART_ISR_TXE_Msk               (0x1UL << USART_ISR_TXE_Pos)            /*!< 0x00000080 */
#define USART_ISR_TXE_Pos               (7U)
#define USART_ISR_TXE_TXFNF             USART_ISR_TXE_Msk                       /*!< Transmit Data Register Empty or TX FIFO Not Full Flag */
#define USART_ISR_TXFE                  USART_ISR_TXFE_Msk                      /*!< TX FIFO Empty Flag */
#define USART_ISR_TXFE_Msk              (0x1UL << USART_ISR_TXFE_Pos)           /*!< 0x00800000 */
#define USART_ISR_TXFE_Pos              (23U)
#define USART_ISR_TXFT                  USART_ISR_TXFT_Msk                      /*!< TX FIFO Threshold Flag */
#define USART_ISR_TXFT_Msk              (0x1UL << USART_ISR_TXFT_Pos)           /*!< 0x08000000 */
#define USART_ISR_TXFT_Pos              (27U)
#define USART_ISR_UDR                   USART_ISR_UDR_Msk                       /*!< SPI Slave Underrun error Flag */
#define USART_ISR_UDR_Msk               (0x1UL << USART_ISR_UDR_Pos)            /*!< 0x00002000 */
#define USART_ISR_UDR_Pos               (13U)
#define USART_ISR_WUF                   USART_ISR_WUF_Msk                       /*!< Wake Up from stop mode Flag */
#define USART_ISR_WUF_Msk               (0x1UL << USART_ISR_WUF_Pos)            /*!< 0x00100000 */
#define USART_ISR_WUF_Pos               (20U)
#define USART_PRESC_PRESCALER           USART_PRESC_PRESCALER_Msk               /*!< PRESCALER[3:0] bits (Clock prescaler) */
#define USART_PRESC_PRESCALER_0         (0x1UL << USART_PRESC_PRESCALER_Pos)    /*!< 0x00000001 */
#define USART_PRESC_PRESCALER_1         (0x2UL << USART_PRESC_PRESCALER_Pos)    /*!< 0x00000002 */
#define USART_PRESC_PRESCALER_2         (0x4UL << USART_PRESC_PRESCALER_Pos)    /*!< 0x00000004 */
#define USART_PRESC_PRESCALER_3         (0x8UL << USART_PRESC_PRESCALER_Pos)    /*!< 0x00000008 */
#define USART_PRESC_PRESCALER_Msk       (0xFUL << USART_PRESC_PRESCALER_Pos)    /*!< 0x0000000F */
#define USART_PRESC_PRESCALER_Pos       (0U)
#define USART_RDR_RDR                   USART_RDR_RDR_Msk                       /*!< RDR[8:0] bits (Receive Data value) */
#define USART_RDR_RDR_Msk               (0x01FFUL << USART_RDR_RDR_Pos)         /*!< 0x000001FF */
#define USART_RDR_RDR_Pos               (0U)
#define USART_RQR_ABRRQ                 USART_RQR_ABRRQ_Msk                     /*!< Auto-Baud Rate Request */
#define USART_RQR_ABRRQ_Msk             (0x1UL << USART_RQR_ABRRQ_Pos)          /*!< 0x00000001 */
#define USART_RQR_ABRRQ_Pos             (0U)
#define USART_RQR_MMRQ                  USART_RQR_MMRQ_Msk                      /*!< Mute Mode Request */
#define USART_RQR_MMRQ_Msk              (0x1UL << USART_RQR_MMRQ_Pos)           /*!< 0x00000004 */
#define USART_RQR_MMRQ_Pos              (2U)
#define USART_RQR_RXFRQ                 USART_RQR_RXFRQ_Msk                     /*!< Receive Data flush Request */
#define USART_RQR_RXFRQ_Msk             (0x1UL << USART_RQR_RXFRQ_Pos)          /*!< 0x00000008 */
#define USART_RQR_RXFRQ_Pos             (3U)
#define USART_RQR_SBKRQ                 USART_RQR_SBKRQ_Msk                     /*!< Send Break Request */
#define USART_RQR_SBKRQ_Msk             (0x1UL << USART_RQR_SBKRQ_Pos)          /*!< 0x00000002 */
#define USART_RQR_SBKRQ_Pos             (1U)
#define USART_RQR_TXFRQ                 USART_RQR_TXFRQ_Msk                     /*!< Transmit Data flush Request */
#define USART_RQR_TXFRQ_Msk             (0x1UL << USART_RQR_TXFRQ_Pos)          /*!< 0x00000010 */
#define USART_RQR_TXFRQ_Pos             (4U)
#define USART_RTOR_BLEN                 USART_RTOR_BLEN_Msk                     /*!< Block Length */
#define USART_RTOR_BLEN_Msk             (0xFFUL << USART_RTOR_BLEN_Pos)         /*!< 0xFF000000 */
#define USART_RTOR_BLEN_Pos             (24U)
#define USART_RTOR_RTO                  USART_RTOR_RTO_Msk                      /*!< Receiver Timeout Value */
#define USART_RTOR_RTO_Msk              (0xFFFFFFUL << USART_RTOR_RTO_Pos)      /*!< 0x00FFFFFF */
#define USART_RTOR_RTO_Pos              (0U)
#define ATOMIC_SET_BIT(REG, BIT)                                do {                                                            uint32_t val;                                                 do {                                                            val = __LDREXW((__IO uint32_t *)&(REG)) | (BIT);            } while ((__STREXW(val,(__IO uint32_t *)&(REG))) != 0U);    } while(0)
#define ATOMIC_CLEAR_BIT(REG, BIT)                              do {                                                            uint32_t val;                                                 do {                                                            val = __LDREXW((__IO uint32_t *)&(REG)) & ~(BIT);           } while ((__STREXW(val,(__IO uint32_t *)&(REG))) != 0U);    } while(0)
#define ATOMIC_MODIFY_REG(REG, CLEARMSK, SETMASK)                             do {                                                                          uint32_t val;                                                               do {                                                                          val = (__LDREXW((__IO uint32_t *)&(REG)) & ~(CLEARMSK)) | (SETMASK);      } while ((__STREXW(val,(__IO uint32_t *)&(REG))) != 0U);                  } while(0)
