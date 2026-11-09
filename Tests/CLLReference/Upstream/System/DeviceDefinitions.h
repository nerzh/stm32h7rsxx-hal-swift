// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// Copyright (c) 2009-2025 Arm Limited. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// Exact device/core extracts; pinned revisions are recorded in LICENSES/NOTICE.txt.
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
  __IM  uint32_t CPUID;                  /*!< Offset: 0x000 (R/ )  CPUID Base Register */
  __IOM uint32_t ICSR;                   /*!< Offset: 0x004 (R/W)  Interrupt Control and State Register */
  __IOM uint32_t VTOR;                   /*!< Offset: 0x008 (R/W)  Vector Table Offset Register */
  __IOM uint32_t AIRCR;                  /*!< Offset: 0x00C (R/W)  Application Interrupt and Reset Control Register */
  __IOM uint32_t SCR;                    /*!< Offset: 0x010 (R/W)  System Control Register */
  __IOM uint32_t CCR;                    /*!< Offset: 0x014 (R/W)  Configuration Control Register */
  __IOM uint8_t  SHPR[12U];              /*!< Offset: 0x018 (R/W)  System Handlers Priority Registers (4-7, 8-11, 12-15) */
  __IOM uint32_t SHCSR;                  /*!< Offset: 0x024 (R/W)  System Handler Control and State Register */
  __IOM uint32_t CFSR;                   /*!< Offset: 0x028 (R/W)  Configurable Fault Status Register */
  __IOM uint32_t HFSR;                   /*!< Offset: 0x02C (R/W)  HardFault Status Register */
  __IOM uint32_t DFSR;                   /*!< Offset: 0x030 (R/W)  Debug Fault Status Register */
  __IOM uint32_t MMFAR;                  /*!< Offset: 0x034 (R/W)  MemManage Fault Address Register */
  __IOM uint32_t BFAR;                   /*!< Offset: 0x038 (R/W)  BusFault Address Register */
  __IOM uint32_t AFSR;                   /*!< Offset: 0x03C (R/W)  Auxiliary Fault Status Register */
  __IM  uint32_t ID_PFR[2U];             /*!< Offset: 0x040 (R/ )  Processor Feature Register */
  __IM  uint32_t ID_DFR;                 /*!< Offset: 0x048 (R/ )  Debug Feature Register */
  __IM  uint32_t ID_AFR;                 /*!< Offset: 0x04C (R/ )  Auxiliary Feature Register */
  __IM  uint32_t ID_MMFR[4U];            /*!< Offset: 0x050 (R/ )  Memory Model Feature Register */
  __IM  uint32_t ID_ISAR[5U];            /*!< Offset: 0x060 (R/ )  Instruction Set Attributes Register */
        uint32_t RESERVED0[1U];
  __IM  uint32_t CLIDR;                  /*!< Offset: 0x078 (R/ )  Cache Level ID register */
  __IM  uint32_t CTR;                    /*!< Offset: 0x07C (R/ )  Cache Type register */
  __IM  uint32_t CCSIDR;                 /*!< Offset: 0x080 (R/ )  Cache Size ID Register */
  __IOM uint32_t CSSELR;                 /*!< Offset: 0x084 (R/W)  Cache Size Selection Register */
  __IOM uint32_t CPACR;                  /*!< Offset: 0x088 (R/W)  Coprocessor Access Control Register */
        uint32_t RESERVED3[93U];
  __OM  uint32_t STIR;                   /*!< Offset: 0x200 ( /W)  Software Triggered Interrupt Register */
        uint32_t RESERVED4[15U];
  __IM  uint32_t MVFR0;                  /*!< Offset: 0x240 (R/ )  Media and VFP Feature Register 0 */
  __IM  uint32_t MVFR1;                  /*!< Offset: 0x244 (R/ )  Media and VFP Feature Register 1 */
  __IM  uint32_t MVFR2;                  /*!< Offset: 0x248 (R/ )  Media and VFP Feature Register 2 */
        uint32_t RESERVED5[1U];
  __OM  uint32_t ICIALLU;                /*!< Offset: 0x250 ( /W)  I-Cache Invalidate All to PoU */
        uint32_t RESERVED6[1U];
  __OM  uint32_t ICIMVAU;                /*!< Offset: 0x258 ( /W)  I-Cache Invalidate by MVA to PoU */
  __OM  uint32_t DCIMVAC;                /*!< Offset: 0x25C ( /W)  D-Cache Invalidate by MVA to PoC */
  __OM  uint32_t DCISW;                  /*!< Offset: 0x260 ( /W)  D-Cache Invalidate by Set-way */
  __OM  uint32_t DCCMVAU;                /*!< Offset: 0x264 ( /W)  D-Cache Clean by MVA to PoU */
  __OM  uint32_t DCCMVAC;                /*!< Offset: 0x268 ( /W)  D-Cache Clean by MVA to PoC */
  __OM  uint32_t DCCSW;                  /*!< Offset: 0x26C ( /W)  D-Cache Clean by Set-way */
  __OM  uint32_t DCCIMVAC;               /*!< Offset: 0x270 ( /W)  D-Cache Clean and Invalidate by MVA to PoC */
  __OM  uint32_t DCCISW;                 /*!< Offset: 0x274 ( /W)  D-Cache Clean and Invalidate by Set-way */
  __OM  uint32_t BPIALL;                 /*!< Offset: 0x278 ( /W)  Branch Predictor Invalidate All */
        uint32_t RESERVED7[5U];
  __IOM uint32_t ITCMCR;                 /*!< Offset: 0x290 (R/W)  Instruction Tightly-Coupled Memory Control Register */
  __IOM uint32_t DTCMCR;                 /*!< Offset: 0x294 (R/W)  Data Tightly-Coupled Memory Control Registers */
  __IOM uint32_t AHBPCR;                 /*!< Offset: 0x298 (R/W)  AHBP Control Register */
  __IOM uint32_t CACR;                   /*!< Offset: 0x29C (R/W)  L1 Cache Control Register */
  __IOM uint32_t AHBSCR;                 /*!< Offset: 0x2A0 (R/W)  AHB Slave Control Register */
        uint32_t RESERVED8[1U];
  __IOM uint32_t ABFSR;                  /*!< Offset: 0x2A8 (R/W)  Auxiliary Bus Fault Status Register */
} SCB_Type;
typedef struct
{
  __IOM uint32_t CTRL;                   /*!< Offset: 0x000 (R/W)  SysTick Control and Status Register */
  __IOM uint32_t LOAD;                   /*!< Offset: 0x004 (R/W)  SysTick Reload Value Register */
  __IOM uint32_t VAL;                    /*!< Offset: 0x008 (R/W)  SysTick Current Value Register */
  __IM  uint32_t CALIB;                  /*!< Offset: 0x00C (R/ )  SysTick Calibration Register */
} SysTick_Type;
typedef struct
{
  __IM  uint32_t TYPE;                   /*!< Offset: 0x000 (R/ )  MPU Type Register */
  __IOM uint32_t CTRL;                   /*!< Offset: 0x004 (R/W)  MPU Control Register */
  __IOM uint32_t RNR;                    /*!< Offset: 0x008 (R/W)  MPU Region Number Register */
  __IOM uint32_t RBAR;                   /*!< Offset: 0x00C (R/W)  MPU Region Base Address Register */
  __IOM uint32_t RASR;                   /*!< Offset: 0x010 (R/W)  MPU Region Attribute and Size Register */
  __IOM uint32_t RBAR_A1;                /*!< Offset: 0x014 (R/W)  MPU Alias 1 Region Base Address Register */
  __IOM uint32_t RASR_A1;                /*!< Offset: 0x018 (R/W)  MPU Alias 1 Region Attribute and Size Register */
  __IOM uint32_t RBAR_A2;                /*!< Offset: 0x01C (R/W)  MPU Alias 2 Region Base Address Register */
  __IOM uint32_t RASR_A2;                /*!< Offset: 0x020 (R/W)  MPU Alias 2 Region Attribute and Size Register */
  __IOM uint32_t RBAR_A3;                /*!< Offset: 0x024 (R/W)  MPU Alias 3 Region Base Address Register */
  __IOM uint32_t RASR_A3;                /*!< Offset: 0x028 (R/W)  MPU Alias 3 Region Attribute and Size Register */
} MPU_Type;
typedef enum
{
  SUCCESS = 0,
  ERROR = !SUCCESS
} ErrorStatus;
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
#define MPU_CTRL_ENABLE_Msk                (1UL /*<< MPU_CTRL_ENABLE_Pos*/)               /*!< MPU CTRL: ENABLE Mask */
#define MPU_CTRL_HFNMIENA_Msk              (1UL << MPU_CTRL_HFNMIENA_Pos)                 /*!< MPU CTRL: HFNMIENA Mask */
#define MPU_CTRL_HFNMIENA_Pos               1U                                            /*!< MPU CTRL: HFNMIENA Position */
#define MPU_CTRL_PRIVDEFENA_Msk            (1UL << MPU_CTRL_PRIVDEFENA_Pos)               /*!< MPU CTRL: PRIVDEFENA Mask */
#define MPU_CTRL_PRIVDEFENA_Pos             2U                                            /*!< MPU CTRL: PRIVDEFENA Position */
#define MPU_RASR_AP_Pos                    24U                                            /*!< MPU RASR: ATTRS.AP Position */
#define MPU_RASR_B_Msk                     (1UL << MPU_RASR_B_Pos)                        /*!< MPU RASR: ATTRS.B Mask */
#define MPU_RASR_B_Pos                     16U                                            /*!< MPU RASR: ATTRS.B Position */
#define MPU_RASR_C_Msk                     (1UL << MPU_RASR_C_Pos)                        /*!< MPU RASR: ATTRS.C Mask */
#define MPU_RASR_C_Pos                     17U                                            /*!< MPU RASR: ATTRS.C Position */
#define MPU_RASR_ENABLE_Msk                (1UL /*<< MPU_RASR_ENABLE_Pos*/)               /*!< MPU RASR: Region enable bit Disable Mask */
#define MPU_RASR_SIZE_Pos                   1U                                            /*!< MPU RASR: Region Size Field Position */
#define MPU_RASR_SRD_Pos                    8U                                            /*!< MPU RASR: Sub-Region Disable Position */
#define MPU_RASR_S_Msk                     (1UL << MPU_RASR_S_Pos)                        /*!< MPU RASR: ATTRS.S Mask */
#define MPU_RASR_S_Pos                     18U                                            /*!< MPU RASR: ATTRS.S Position */
#define MPU_RASR_TEX_Pos                   19U                                            /*!< MPU RASR: ATTRS.TEX Position */
#define MPU_RASR_XN_Msk                    (1UL << MPU_RASR_XN_Pos)                       /*!< MPU RASR: ATTRS.XN Mask */
#define MPU_RASR_XN_Pos                    28U                                            /*!< MPU RASR: ATTRS.XN Position */
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
#define SCB_CPUID_ARCHITECTURE_Msk         (0xFUL << SCB_CPUID_ARCHITECTURE_Pos)          /*!< SCB CPUID: ARCHITECTURE Mask */
#define SCB_CPUID_ARCHITECTURE_Pos         16U                                            /*!< SCB CPUID: ARCHITECTURE Position */
#define SCB_CPUID_IMPLEMENTER_Msk          (0xFFUL << SCB_CPUID_IMPLEMENTER_Pos)          /*!< SCB CPUID: IMPLEMENTER Mask */
#define SCB_CPUID_IMPLEMENTER_Pos          24U                                            /*!< SCB CPUID: IMPLEMENTER Position */
#define SCB_CPUID_PARTNO_Msk               (0xFFFUL << SCB_CPUID_PARTNO_Pos)              /*!< SCB CPUID: PARTNO Mask */
#define SCB_CPUID_PARTNO_Pos                4U                                            /*!< SCB CPUID: PARTNO Position */
#define SCB_CPUID_REVISION_Msk             (0xFUL /*<< SCB_CPUID_REVISION_Pos*/)          /*!< SCB CPUID: REVISION Mask */
#define SCB_CPUID_REVISION_Pos              0U                                            /*!< SCB CPUID: REVISION Position */
#define SCB_CPUID_VARIANT_Msk              (0xFUL << SCB_CPUID_VARIANT_Pos)               /*!< SCB CPUID: VARIANT Mask */
#define SCB_CPUID_VARIANT_Pos              20U                                            /*!< SCB CPUID: VARIANT Position */
#define SCB_SCR_SEVONPEND_Msk              (1UL << SCB_SCR_SEVONPEND_Pos)                 /*!< SCB SCR: SEVONPEND Mask */
#define SCB_SCR_SEVONPEND_Pos               4U                                            /*!< SCB SCR: SEVONPEND Position */
#define SCB_SCR_SLEEPDEEP_Msk              (1UL << SCB_SCR_SLEEPDEEP_Pos)                 /*!< SCB SCR: SLEEPDEEP Mask */
#define SCB_SCR_SLEEPDEEP_Pos               2U                                            /*!< SCB SCR: SLEEPDEEP Position */
#define SCB_SCR_SLEEPONEXIT_Msk            (1UL << SCB_SCR_SLEEPONEXIT_Pos)               /*!< SCB SCR: SLEEPONEXIT Mask */
#define SCB_SCR_SLEEPONEXIT_Pos             1U                                            /*!< SCB SCR: SLEEPONEXIT Position */
#define SCB_SHCSR_BUSFAULTENA_Msk          (1UL << SCB_SHCSR_BUSFAULTENA_Pos)             /*!< SCB SHCSR: BUSFAULTENA Mask */
#define SCB_SHCSR_BUSFAULTENA_Pos          17U                                            /*!< SCB SHCSR: BUSFAULTENA Position */
#define SCB_SHCSR_MEMFAULTENA_Msk          (1UL << SCB_SHCSR_MEMFAULTENA_Pos)             /*!< SCB SHCSR: MEMFAULTENA Mask */
#define SCB_SHCSR_MEMFAULTENA_Pos          16U                                            /*!< SCB SHCSR: MEMFAULTENA Position */
#define SCB_SHCSR_USGFAULTENA_Msk          (1UL << SCB_SHCSR_USGFAULTENA_Pos)             /*!< SCB SHCSR: USGFAULTENA Mask */
#define SCB_SHCSR_USGFAULTENA_Pos          18U                                            /*!< SCB SHCSR: USGFAULTENA Position */
#define SysTick_CTRL_CLKSOURCE_Msk         (1UL << SysTick_CTRL_CLKSOURCE_Pos)            /*!< SysTick CTRL: CLKSOURCE Mask */
#define SysTick_CTRL_CLKSOURCE_Pos          2U                                            /*!< SysTick CTRL: CLKSOURCE Position */
#define SysTick_CTRL_COUNTFLAG_Msk         (1UL << SysTick_CTRL_COUNTFLAG_Pos)            /*!< SysTick CTRL: COUNTFLAG Mask */
#define SysTick_CTRL_COUNTFLAG_Pos         16U                                            /*!< SysTick CTRL: COUNTFLAG Position */
#define SysTick_CTRL_TICKINT_Msk           (1UL << SysTick_CTRL_TICKINT_Pos)              /*!< SysTick CTRL: TICKINT Mask */
#define SysTick_CTRL_TICKINT_Pos            1U                                            /*!< SysTick CTRL: TICKINT Position */
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
