/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
 * Extracted unchanged from STM32H7RS HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
#ifndef C_FLASH_REFERENCE_TYPES_H
#define C_FLASH_REFERENCE_TYPES_H
#include <stdint.h>
#define __IO volatile
#define __I volatile const
#define __O volatile
typedef enum
{
  HAL_OK       = 0x00,
  HAL_ERROR    = 0x01,
  HAL_BUSY     = 0x02,
  HAL_TIMEOUT  = 0x03
} HAL_StatusTypeDef;
typedef enum
{
  HAL_UNLOCKED = 0x00,
  HAL_LOCKED   = 0x01
} HAL_LockTypeDef;
/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 * Extracted unchanged from CMSIS device 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
 * See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt. */
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
/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted unchanged from STM32H7RS HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
typedef struct
{
  uint32_t TypeErase;   /*!< Mass erase or page erase.
                             This parameter can be a value of @ref FLASH_Type_Erase */
  uint32_t Sector;      /*!< Initial Flash sector to erase when sector erase is enabled
                             This parameter must be a value between 0 and (max number of sector - 1)
                             (eg : 15 for 128KB single bank) */
  uint32_t NbSectors;   /*!< Number of sectors to be erased.
                             This parameter must be a value between 1 and
                             (max number of sectors - value of initial page)*/
} FLASH_EraseInitTypeDef;
typedef struct
{
  uint32_t OptionType;                  /*!< Option byte to be configured.
                                             This parameter can be a combination of the values of @ref FLASH_OB_TYPE */
  uint32_t WRPState;                    /*!< Write protection activation or deactivation (used for OPTIONBYTE_WRP).
                                             This parameter can be value of @ref FLASH_OB_WRP_STATE */
  uint32_t WRPSector;                   /*!< Specifies the sector(s) to be write protected (used for OPTIONBYTE_WRP).
                                             The value of this parameter depend on device used within the same series */
  uint32_t USERType;                    /*!< User option byte(s) to be configured (used for OPTIONBYTE_USER).
                                             This parameter can be a combination of @ref FLASH_OB_USER_TYPE */
  uint32_t USERConfig1;                 /*!< Value of the user option byte (used for OPTIONBYTE_USER).
                                             This parameter can be a combination of @ref FLASH_OB_USER_BOR_LEV,
                                             @ref FLASH_OB_USER_IWDG_SW, @ref FLASH_OB_USER_nRST_STOP,
                                             @ref FLASH_OB_USER_nRST_STDBY, @ref FLASH_OB_USER_XSPI1_HSLV,
                                             @ref FLASH_OB_USER_XSPI2_HSLV, @ref FLASH_OB_USER_IWDG_STOP,
                                             @ref FLASH_OB_USER_IWDG_STANDBY, @ref FLASH_OB_USER_VDDIO_HSLV */
  uint32_t USERConfig2;                 /*!< Value of the user option byte (used for OPTIONBYTE_USER).
                                             This parameter can be a combination of @ref FLASH_OB_USER_ITCM_AXI_SHARE,
                                             @ref FLASH_OB_USER_DTCM_AXI_SHARE, @ref FLASH_OB_USER_ECC_ON_SRAM,
                                             @ref FLASH_OB_USER_I2C_NI3C */
  uint32_t HDPStartPage;                /*!< Start address that contains the first 256-byte block of HDP area (used for OPTIONBYTE_HDP).
                                             This parameter must be a value between 0 or 0xFFF */
  uint32_t HDPEndPage;                  /*!< End address that contains the last 256-byte block of HDP area (used for OPTIONBYTE_HDP).
                                             This parameter must be a value between 0 or 0xFFF */
  uint32_t NVState;                     /*!< Value of the non-volatile state (used for OPTIONBYTE_NV).
                                             This parameter must be a value of @ref FLASH_OB_NVSTATE */
  uint32_t ROTConfig;                   /*!< Value of the RoT status (only used for read configuration).
                                             This parameter can be a combination of @ref FLASH_OB_ROT_OEM_PROVD,
                                             @ref FLASH_OB_ROT_DBG_AUTH, @ref FLASH_OB_ROT_IROT_SELECT */
  uint32_t EPOCH;                       /*!< Value of the epoch (only used for read configuration).
                                             This parameter must be a value between 0x0 and 0xFFFFFF */
} FLASH_OBProgramInitTypeDef;
typedef struct
{
  HAL_LockTypeDef        Lock;              /* FLASH locking object */
  uint32_t               ErrorCode;         /* FLASH error code */
  uint32_t               ProcedureOnGoing;  /* Internal variable to indicate which procedure is ongoing or not in IT
                                               context */
  uint32_t               Address;           /* Internal variable to save address selected for program in IT context */
  uint32_t               Sector;            /* Internal variable to define the current sector which is being erased in
                                               IT context */
  uint32_t               NbSectorsToErase;  /* Internal variable to save the remaining sectors to erase in IT context */
} FLASH_ProcessTypeDef;
typedef struct
{
  uint32_t Index;     /*!< Index of the key.
                           This parameter can be a value between 0 and 31 */
  uint32_t Size;      /*!< Size of the key.
                           This parameter must be a value of @ref FLASH_Key_Size */
  uint32_t HDPLLevel; /*!< HDPL level of the key.
                           This parameter must be a value of @ref FLASH_KEY_Level */
} FLASH_KeyConfigTypeDef;
typedef struct
{
  uint32_t TypeCRC;      /*!< CRC Selection Type.
                              This parameter can be a value of @ref FLASHEx_CRC_Selection_Type */

  uint32_t BurstSize;    /*!< CRC Burst Size.
                              This parameter can be a value of @ref FLASHEx_CRC_Burst_Size */

  uint32_t Sector;       /*!< Initial FLASH sector from which starts the CRC computation
                             This parameter must be a value between 0 and (max number of sector - 1)*/

  uint32_t NbSectors;    /*!< Number of sectors to be computed.
                              This parameter must be a value between 1 and
                              (max number of sectors - value of Initial sector)*/

  uint32_t CRCStartAddr; /*!< CRC Start address.
                              This parameter must be a value between begin address and end address of a bank */

  uint32_t CRCEndAddr;   /*!< CRC End address.
                              This parameter must be a value between CRC Start address and end address of a bank */

} FLASH_CRCInitTypeDef;
typedef struct
{
  uint32_t Area;        /*!< Area from which an ECC was detected.
                             This parameter can be a value of @ref FLASHEx_ECC_Area  */
  uint32_t Address;     /*!< Flash address from which en ECC error was detected.
                             This parameter must be a value between begin address and end address of the Flash */
  uint32_t MasterID;    /*!< Master that initiated transfer on which error was detected
                             This parameter can be a value of @ref FLASHEx_ECC_Master */
} FLASH_EccInfoTypeDef;
#endif
