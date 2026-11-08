// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// From stm32h7s3xx.h at 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

typedef struct
{
  __IO uint32_t CR;             /*!< XSPI Control Register,                                Address offset: 0x000         */
       uint32_t RESERVED1;      /*!< Reserved,                                             Address offset: 0x004         */
  __IO uint32_t DCR1;           /*!< XSPI Device Configuration Register 1,                 Address offset: 0x008         */
  __IO uint32_t DCR2;           /*!< XSPI Device Configuration Register 2,                 Address offset: 0x00C         */
  __IO uint32_t DCR3;           /*!< XSPI Device Configuration Register 3,                 Address offset: 0x010         */
  __IO uint32_t DCR4;           /*!< XSPI Device Configuration Register 4,                 Address offset: 0x014         */
       uint32_t RESERVED2[2];   /*!< Reserved,                                             Address offset: 0x018 - 0x01C */
  __IO uint32_t SR;             /*!< XSPI Status Register,                                 Address offset: 0x020         */
  __IO uint32_t FCR;            /*!< XSPI Flag Clear Register,                             Address offset: 0x024         */
       uint32_t RESERVED3[6];   /*!< Reserved,                                             Address offset: 0x028 - 0x03C */
  __IO uint32_t DLR;            /*!< XSPI Data Length Register,                            Address offset: 0x040         */
       uint32_t RESERVED4;      /*!< Reserved,                                             Address offset: 0x044         */
  __IO uint32_t AR;             /*!< XSPI Address Register,                                Address offset: 0x048         */
       uint32_t RESERVED5;      /*!< Reserved,                                             Address offset: 0x04C         */
  __IO uint32_t DR;             /*!< XSPI Data Register,                                   Address offset: 0x050         */
       uint32_t RESERVED6[11];  /*!< Reserved,                                             Address offset: 0x054 - 0x07C */
  __IO uint32_t PSMKR;          /*!< XSPI Polling Status Mask Register,                    Address offset: 0x080         */
       uint32_t RESERVED7;      /*!< Reserved,                                             Address offset: 0x084         */
  __IO uint32_t PSMAR;          /*!< XSPI Polling Status Match Register,                   Address offset: 0x088         */
       uint32_t RESERVED8;      /*!< Reserved,                                             Address offset: 0x08C         */
  __IO uint32_t PIR;            /*!< XSPI Polling Interval Register,                       Address offset: 0x090         */
       uint32_t RESERVED9[27];  /*!< Reserved,                                             Address offset: 0x094 - 0x0FC */
  __IO uint32_t CCR;            /*!< XSPI Communication Configuration Register,            Address offset: 0x100         */
       uint32_t RESERVED10;     /*!< Reserved,                                             Address offset: 0x104         */
  __IO uint32_t TCR;            /*!< XSPI Timing Configuration Register,                   Address offset: 0x108         */
       uint32_t RESERVED11;     /*!< Reserved,                                             Address offset: 0x10C         */
  __IO uint32_t IR;             /*!< XSPI Instruction Register,                            Address offset: 0x110         */
       uint32_t RESERVED12[3];  /*!< Reserved,                                             Address offset: 0x114 - 0x11C */
  __IO uint32_t ABR;            /*!< XSPI Alternate Bytes Register,                        Address offset: 0x120         */
       uint32_t RESERVED13[3];  /*!< Reserved,                                             Address offset: 0x124 - 0x12C */
  __IO uint32_t LPTR;           /*!< XSPI Low-Power Timeout Register,                      Address offset: 0x130         */
       uint32_t RESERVED14[3];  /*!< Reserved,                                             Address offset: 0x134 - 0x13C */
  __IO uint32_t WPCCR;          /*!< XSPI Wrap Communication Configuration Register,       Address offset: 0x140         */
       uint32_t RESERVED15;     /*!< Reserved,                                             Address offset: 0x144         */
  __IO uint32_t WPTCR;          /*!< XSPI Wrap Timing Configuration Register,              Address offset: 0x148         */
       uint32_t RESERVED16;     /*!< Reserved,                                             Address offset: 0x14C         */
  __IO uint32_t WPIR;           /*!< XSPI Wrap Instruction Register,                       Address offset: 0x150         */
       uint32_t RESERVED17[3];  /*!< Reserved,                                             Address offset: 0x154 - 0x15C */
  __IO uint32_t WPABR;          /*!< XSPI Wrap Alternate Bytes Register,                   Address offset: 0x160         */
       uint32_t RESERVED18[7];  /*!< Reserved,                                             Address offset: 0x164 - 0x17C */
  __IO uint32_t WCCR;           /*!< XSPI Write Communication Configuration Register,      Address offset: 0x180         */
       uint32_t RESERVED19;     /*!< Reserved,                                             Address offset: 0x184         */
  __IO uint32_t WTCR;           /*!< XSPI Write Timing Configuration Register,             Address offset: 0x188         */
       uint32_t RESERVED20;     /*!< Reserved,                                             Address offset: 0x18C         */
  __IO uint32_t WIR;            /*!< XSPI Write Instruction Register,                      Address offset: 0x190         */
       uint32_t RESERVED21[3];  /*!< Reserved,                                             Address offset: 0x194 - 0x19C */
  __IO uint32_t WABR;           /*!< XSPI Write Alternate Bytes Register,                  Address offset: 0x1A0         */
       uint32_t RESERVED22[23]; /*!< Reserved,                                             Address offset: 0x1A4 - 0x1FC */
  __IO uint32_t HLCR;           /*!< XSPI HyperBus Latency Configuration Register,         Address offset: 0x200         */
       uint32_t RESERVED23[3];  /*!< Reserved,                                             Address offset: 0x204 - 0x20C */
  __IO uint32_t CALFCR;         /*!< XSPI Full-Cycle Calibration Configuration Register,   Address offset: 0x210         */
       uint32_t RESERVED24;     /*!< Reserved,                                             Address offset: 0x214         */
  __IO uint32_t CALMR;          /*!< XSPI DLL Master Calibration Configuration Register,   Address offset: 0x218         */
       uint32_t RESERVED25;     /*!< Reserved,                                             Address offset: 0x21C         */
  __IO uint32_t CALSOR;         /*!< XSPI Slave Output Calibration Configuration Register, Address offset: 0x220         */
       uint32_t RESERVED26;     /*!< Reserved,                                             Address offset: 0x224         */
  __IO uint32_t CALSIR;         /*!< XSPI Slave Input Calibration Configuration Register,  Address offset: 0x228         */
} XSPI_TypeDef;
typedef struct
{
  __IO uint32_t CR;     /*!< XSPIM IO Manager Control Register,                  Address offset: 0x00        */
} XSPIM_TypeDef;
