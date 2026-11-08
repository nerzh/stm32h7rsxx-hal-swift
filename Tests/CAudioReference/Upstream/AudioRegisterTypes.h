// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// From stm32h7s3xx.h at 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

typedef struct
{
  __IO uint32_t CR1;           /*!< SPI/I2S Control register 1,                 Address offset: 0x00 */
  __IO uint32_t CR2;           /*!< SPI Control register 2,                     Address offset: 0x04 */
  __IO uint32_t CFG1;          /*!< SPI Configuration register 1,               Address offset: 0x08 */
  __IO uint32_t CFG2;          /*!< SPI Configuration register 2,               Address offset: 0x0C */
  __IO uint32_t IER;           /*!< SPI/I2S Interrupt Enable register,          Address offset: 0x10 */
  __IO uint32_t SR;            /*!< SPI/I2S Status register,                    Address offset: 0x14 */
  __IO uint32_t IFCR;          /*!< SPI/I2S Interrupt/Status flags clear register, Address offset: 0x18 */
  uint32_t      RESERVED0;     /*!< Reserved,                                   Address offset: 0x1C */
  __IO uint32_t TXDR;          /*!< SPI Transmit data register,                 Address offset: 0x20 */
  uint32_t      RESERVED1[3];  /*!< Reserved,                              Address offset: 0x24-0x2C */
  __IO uint32_t RXDR;          /*!< SPI/I2S data register,                      Address offset: 0x30 */
  uint32_t      RESERVED2[3];  /*!< Reserved,                              Address offset: 0x34-0x3C */
  __IO uint32_t CRCPOLY;       /*!< SPI CRC Polynomial register,                Address offset: 0x40 */
  __IO uint32_t TXCRC;         /*!< SPI Transmitter CRC register,               Address offset: 0x44 */
  __IO uint32_t RXCRC;         /*!< SPI Receiver CRC register,                  Address offset: 0x48 */
  __IO uint32_t UDRDR;         /*!< SPI Underrun data register,                 Address offset: 0x4C */
  __IO uint32_t I2SCFGR;       /*!< I2S Configuration register,                 Address offset: 0x50 */
} SPI_TypeDef;
typedef struct
{
  __IO uint32_t GCR;          /*!< SAI global configuration register,        Address offset: 0x00 */
  uint32_t      RESERVED[16]; /*!< Reserved,                         Address offset: 0x04 to 0x40 */
  __IO uint32_t PDMCR;        /*!< SAI PDM control register,                 Address offset: 0x44 */
  __IO uint32_t PDMDLY;       /*!< SAI PDM delay register,                   Address offset: 0x48 */
} SAI_TypeDef;
typedef struct
{
  __IO uint32_t CR1;         /*!< SAI block x configuration register 1,     Address offset: 0x04 */
  __IO uint32_t CR2;         /*!< SAI block x configuration register 2,     Address offset: 0x08 */
  __IO uint32_t FRCR;        /*!< SAI block x frame configuration register, Address offset: 0x0C */
  __IO uint32_t SLOTR;       /*!< SAI block x slot register,                Address offset: 0x10 */
  __IO uint32_t IMR;         /*!< SAI block x interrupt mask register,      Address offset: 0x14 */
  __IO uint32_t SR;          /*!< SAI block x status register,              Address offset: 0x18 */
  __IO uint32_t CLRFR;       /*!< SAI block x clear flag register,          Address offset: 0x1C */
  __IO uint32_t DR;          /*!< SAI block x data register,                Address offset: 0x20 */
} SAI_Block_TypeDef;
