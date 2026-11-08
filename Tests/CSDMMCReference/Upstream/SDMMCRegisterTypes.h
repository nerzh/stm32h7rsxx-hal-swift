// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// From stm32h7s3xx.h at 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

typedef struct
{
  __IO uint32_t POWER;        /*!< SDMMC Power control register,                Address offset : 0x000         */
  __IO uint32_t CLKCR;        /*!< SDMMC Clock control register,                Address offset : 0x004         */
  __IO uint32_t ARG;          /*!< SDMMC Argument register,                     Address offset : 0x008         */
  __IO uint32_t CMD;          /*!< SDMMC Command register,                      Address offset : 0x00C         */
  __IO uint32_t RESPCMD;      /*!< SDMMC Command response register,             Address offset : 0x010         */
  __IO uint32_t RESP1;        /*!< SDMMC Response 1 register,                   Address offset : 0x014         */
  __IO uint32_t RESP2;        /*!< SDMMC Response 2 register,                   Address offset : 0x018         */
  __IO uint32_t RESP3;        /*!< SDMMC Response 3 register,                   Address offset : 0x01C         */
  __IO uint32_t RESP4;        /*!< SDMMC Response 4 register,                   Address offset : 0x020         */
  __IO uint32_t DTIMER;       /*!< SDMMC Data timer register,                   Address offset : 0x024         */
  __IO uint32_t DLEN;         /*!< SDMMC Data length register,                  Address offset : 0x028         */
  __IO uint32_t DCTRL;        /*!< SDMMC Data control register,                 Address offset : 0x02C         */
  __IO uint32_t DCOUNT;       /*!< SDMMC Data counter register,                 Address offset : 0x030         */
  __IO uint32_t STA;          /*!< SDMMC Status register,                       Address offset : 0x034         */
  __IO uint32_t ICR;          /*!< SDMMC Interrupt clear register,              Address offset : 0x038         */
  __IO uint32_t MASK;         /*!< SDMMC Mask register,                         Address offset : 0x03C         */
  __IO uint32_t ACKTIME;      /*!< SDMMC Acknowledgement timer register,        Address offset : 0x040         */
       uint32_t RESERVED0[3]; /*!< Reserved,                                    Address offset : 0x044 - 0x04C */
  __IO uint32_t IDMACTRL;     /*!< SDMMC IDMA control register,                 Address offset : 0x050         */
  __IO uint32_t IDMABSIZE;    /*!< SDMMC IDMA buffer size register,             Address offset : 0x054         */
  __IO uint32_t IDMABASER;    /*!< SDMMC IDMA buffer base address register,     Address offset : 0x058         */
       uint32_t RESERVED1[2]; /*!< Reserved,                                    Address offset : 0x05C - 0x060 */
  __IO uint32_t IDMALAR;      /*!< SDMMC IDMA linked list address register,     Address offset : 0x064         */
  __IO uint32_t IDMABAR;      /*!< SDMMC IDMA linked list memory base register, Address offset : 0x068         */
       uint32_t RESERVED2[5]; /*!< Reserved,                                    Address offset : 0x06C - 0x07C */
  __IO uint32_t FIFO;         /*!< SDMMC data FIFO register,                    Address offset : 0x080         */
} SDMMC_TypeDef;
typedef struct
{
  __IO uint32_t CR;   /*!< Delay Block Control Register,       Address offset: 0x00 */
  __IO uint32_t CFGR; /*!< Delay Block Configuration Register, Address offset: 0x04 */
} DLYB_TypeDef;
