// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// From stm32h7s3xx.h at 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

typedef struct
{
  __IO uint32_t CR;         /*!< CRYP control register,                                    Address offset: 0x00 */
  __IO uint32_t SR;         /*!< CRYP status register,                                     Address offset: 0x04 */
  __IO uint32_t DIN;        /*!< CRYP data input register,                                 Address offset: 0x08 */
  __IO uint32_t DOUT;       /*!< CRYP data output register,                                Address offset: 0x0C */
  __IO uint32_t DMACR;      /*!< CRYP DMA control register,                                Address offset: 0x10 */
  __IO uint32_t IMSCR;      /*!< CRYP interrupt mask set/clear register,                   Address offset: 0x14 */
  __IO uint32_t RISR;       /*!< CRYP raw interrupt status register,                       Address offset: 0x18 */
  __IO uint32_t MISR;       /*!< CRYP masked interrupt status register,                    Address offset: 0x1C */
  __IO uint32_t K0LR;       /*!< CRYP key left  register 0,                                Address offset: 0x20 */
  __IO uint32_t K0RR;       /*!< CRYP key right register 0,                                Address offset: 0x24 */
  __IO uint32_t K1LR;       /*!< CRYP key left  register 1,                                Address offset: 0x28 */
  __IO uint32_t K1RR;       /*!< CRYP key right register 1,                                Address offset: 0x2C */
  __IO uint32_t K2LR;       /*!< CRYP key left  register 2,                                Address offset: 0x30 */
  __IO uint32_t K2RR;       /*!< CRYP key right register 2,                                Address offset: 0x34 */
  __IO uint32_t K3LR;       /*!< CRYP key left  register 3,                                Address offset: 0x38 */
  __IO uint32_t K3RR;       /*!< CRYP key right register 3,                                Address offset: 0x3C */
  __IO uint32_t IV0LR;      /*!< CRYP initialization vector left-word  register 0,         Address offset: 0x40 */
  __IO uint32_t IV0RR;      /*!< CRYP initialization vector right-word register 0,         Address offset: 0x44 */
  __IO uint32_t IV1LR;      /*!< CRYP initialization vector left-word  register 1,         Address offset: 0x48 */
  __IO uint32_t IV1RR;      /*!< CRYP initialization vector right-word register 1,         Address offset: 0x4C */
  __IO uint32_t CSGCMCCM0R; /*!< CRYP GCM/GMAC or CCM/CMAC context swap register 0,        Address offset: 0x50 */
  __IO uint32_t CSGCMCCM1R; /*!< CRYP GCM/GMAC or CCM/CMAC context swap register 1,        Address offset: 0x54 */
  __IO uint32_t CSGCMCCM2R; /*!< CRYP GCM/GMAC or CCM/CMAC context swap register 2,        Address offset: 0x58 */
  __IO uint32_t CSGCMCCM3R; /*!< CRYP GCM/GMAC or CCM/CMAC context swap register 3,        Address offset: 0x5C */
  __IO uint32_t CSGCMCCM4R; /*!< CRYP GCM/GMAC or CCM/CMAC context swap register 4,        Address offset: 0x60 */
  __IO uint32_t CSGCMCCM5R; /*!< CRYP GCM/GMAC or CCM/CMAC context swap register 5,        Address offset: 0x64 */
  __IO uint32_t CSGCMCCM6R; /*!< CRYP GCM/GMAC or CCM/CMAC context swap register 6,        Address offset: 0x68 */
  __IO uint32_t CSGCMCCM7R; /*!< CRYP GCM/GMAC or CCM/CMAC context swap register 7,        Address offset: 0x6C */
  __IO uint32_t CSGCM0R;    /*!< CRYP GCM/GMAC context swap register 0,                    Address offset: 0x70 */
  __IO uint32_t CSGCM1R;    /*!< CRYP GCM/GMAC context swap register 1,                    Address offset: 0x74 */
  __IO uint32_t CSGCM2R;    /*!< CRYP GCM/GMAC context swap register 2,                    Address offset: 0x78 */
  __IO uint32_t CSGCM3R;    /*!< CRYP GCM/GMAC context swap register 3,                    Address offset: 0x7C */
  __IO uint32_t CSGCM4R;    /*!< CRYP GCM/GMAC context swap register 4,                    Address offset: 0x80 */
  __IO uint32_t CSGCM5R;    /*!< CRYP GCM/GMAC context swap register 5,                    Address offset: 0x84 */
  __IO uint32_t CSGCM6R;    /*!< CRYP GCM/GMAC context swap register 6,                    Address offset: 0x88 */
  __IO uint32_t CSGCM7R;    /*!< CRYP GCM/GMAC context swap register 7,                    Address offset: 0x8C */
} CRYP_TypeDef;

typedef struct
{
  __IO uint32_t CR;              /*!< SAES control register,                      Address offset: 0x00 */
  __IO uint32_t SR;              /*!< SAES status register,                       Address offset: 0x04 */
  __IO uint32_t DINR;            /*!< SAES data input register,                   Address offset: 0x08 */
  __IO uint32_t DOUTR;           /*!< SAES data output register,                  Address offset: 0x0C */
  __IO uint32_t KEYR0;           /*!< SAES key register 0,                        Address offset: 0x10 */
  __IO uint32_t KEYR1;           /*!< SAES key register 1,                        Address offset: 0x14 */
  __IO uint32_t KEYR2;           /*!< SAES key register 2,                        Address offset: 0x18 */
  __IO uint32_t KEYR3;           /*!< SAES key register 3,                        Address offset: 0x1C */
  __IO uint32_t IVR0;            /*!< SAES initialization vector register 0,      Address offset: 0x20 */
  __IO uint32_t IVR1;            /*!< SAES initialization vector register 1,      Address offset: 0x24 */
  __IO uint32_t IVR2;            /*!< SAES initialization vector register 2,      Address offset: 0x28 */
  __IO uint32_t IVR3;            /*!< SAES initialization vector register 3,      Address offset: 0x2C */
  __IO uint32_t KEYR4;           /*!< SAES key register 4,                        Address offset: 0x30 */
  __IO uint32_t KEYR5;           /*!< SAES key register 5,                        Address offset: 0x34 */
  __IO uint32_t KEYR6;           /*!< SAES key register 6,                        Address offset: 0x38 */
  __IO uint32_t KEYR7;           /*!< SAES key register 7,                        Address offset: 0x3C */
  __IO uint32_t SUSP0R;          /*!< SAES Suspend register 0,                    Address offset: 0x40 */
  __IO uint32_t SUSP1R;          /*!< SAES Suspend register 1,                    Address offset: 0x44 */
  __IO uint32_t SUSP2R;          /*!< SAES Suspend register 2,                    Address offset: 0x48 */
  __IO uint32_t SUSP3R;          /*!< SAES Suspend register 3,                    Address offset: 0x4C */
  __IO uint32_t SUSP4R;          /*!< SAES Suspend register 4,                    Address offset: 0x50 */
  __IO uint32_t SUSP5R;          /*!< SAES Suspend register 5,                    Address offset: 0x54 */
  __IO uint32_t SUSP6R;          /*!< SAES Suspend register 6,                    Address offset: 0x58 */
  __IO uint32_t SUSP7R;          /*!< SAES Suspend register 7,                    Address offset: 0x5C */
       uint32_t RESERVED1[168];  /*!< Reserved,                                   Address offset: 0x60 -- 0x2FC */
  __IO uint32_t IER;             /*!< SAES Interrupt Enable Register,             Address offset: 0x300 */
  __IO uint32_t ISR;             /*!< SAES Interrupt Status Register,             Address offset: 0x304 */
  __IO uint32_t ICR;             /*!< SAES Interrupt Clear Register,              Address offset: 0x308 */
} SAES_TypeDef;
