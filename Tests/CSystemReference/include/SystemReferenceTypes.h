/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
 * Extracted unchanged from HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
#ifndef C_SYSTEM_REFERENCE_TYPES_H
#define C_SYSTEM_REFERENCE_TYPES_H
#include <stdint.h>
#define __IO volatile
typedef enum
{
  HAL_OK       = 0x00,
  HAL_ERROR    = 0x01,
  HAL_BUSY     = 0x02,
  HAL_TIMEOUT  = 0x03
} HAL_StatusTypeDef;
/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 * Extracted unchanged from CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
 * See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt. */
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
  __IO uint32_t CSR;         /*!< VREFBUF control and status register,         Address offset: 0x00 */
  __IO uint32_t CCR;         /*!< VREFBUF calibration and control register,    Address offset: 0x04 */
} VREFBUF_TypeDef;
typedef struct
{
  uint32_t RESERVED1[9];       /*!< Reserved,                             Address offset: 0x00-0x20 */
  __IO uint32_t FNMOD2;        /*!< AXIM ASIB fn_mod2 register            Address offset: 0x24 */
  uint32_t RESERVED3[54];      /*!< Reserved,                             Address offset: 0x28-0xFC */
  __IO uint32_t READQOS;       /*!< AXIM ASIB read_qos register           Address offset: 0x100 */
  __IO uint32_t WRITEQOS;      /*!< AXIM ASIB write_qos register          Address offset: 0x104 */
  __IO uint32_t FNMOD;         /*!< AXIM ASIB fn_mod register             Address offset: 0x108 */
} AXIM_ASIB_TypeDef;
typedef struct
{
  uint32_t RESERVED1[2];       /*!< Reserved,                             Address offset: 0x00-0x04 */
  __IO uint32_t FNMODBMISS;    /*!< AXIM AMIB fn_mod_bm_iss register      Address offset: 0x08 */
  uint32_t RESERVED2[6];       /*!< Reserved,                             Address offset: 0x0C-0x20 */
  __IO uint32_t FNMOD2;        /*!< AXIM AMIB fn_mod2 register            Address offset: 0x24 */
  uint32_t RESERVED3[1];       /*!< Reserved,                             Address offset: 0x28 */
  __IO uint32_t FNMODLB;       /*!< AXIM AMIB fn_mod_lb register          Address offset: 0x2C */
  uint32_t RESERVED5[54];      /*!< Reserved,                             Address offset: 0x30-0x104 */
  __IO uint32_t FNMOD;         /*!< AXIM AMIB fn_mod register             Address offset: 0x108 */
} AXIM_AMIB_TypeDef;
typedef struct {
  __IO uint32_t BTCR[8];       /*!< NOR/PSRAM chip-select control register(BCR) and chip-select timing register(BTR), Address offset: 0x00-1C */
} FMC_Bank1_TypeDef;
#endif
