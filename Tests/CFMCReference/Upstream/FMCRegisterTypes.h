// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// From stm32h7s3xx.h at 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

typedef struct {
  __IO uint32_t BTCR[8];       /*!< NOR/PSRAM chip-select control register(BCR) and chip-select timing register(BTR), Address offset: 0x00-1C */
} FMC_Bank1_TypeDef;
typedef struct {
  __IO uint32_t BWTR[7];       /*!< NOR/PSRAM write timing registers, Address offset: 0x104-0x11C */
} FMC_Bank1E_TypeDef;
typedef struct {
  __IO uint32_t PCR;           /*!< NAND Flash control register,                       Address offset: 0x80 */
  __IO uint32_t SR;            /*!< NAND Flash FIFO status and interrupt register,     Address offset: 0x84 */
  __IO uint32_t PMEM;          /*!< NAND Flash Common memory space timing register,    Address offset: 0x88 */
  __IO uint32_t PATT;          /*!< NAND Flash Attribute memory space timing register, Address offset: 0x8C */
       uint32_t RESERVED0;     /*!< Reserved,                                          Address offset: 0x90 */
  __IO uint32_t ECCR;          /*!< NAND Flash ECC result registers,                   Address offset: 0x94 */
} FMC_Bank3_TypeDef;
typedef struct
{
  __IO uint32_t SDCR[2];       /*!< SDRAM Control registers ,     Address offset: 0x140 - 0x144 */
  __IO uint32_t SDTR[2];       /*!< SDRAM Timing registers ,      Address offset: 0x148 - 0x14C */
  __IO uint32_t SDCMR;         /*!< SDRAM Command Mode register,  Address offset: 0x150         */
  __IO uint32_t SDRTR;         /*!< SDRAM Refresh Timer register, Address offset: 0x154         */
  __IO uint32_t SDSR;          /*!< SDRAM Status register,        Address offset: 0x158         */
} FMC_Bank5_6_TypeDef;
