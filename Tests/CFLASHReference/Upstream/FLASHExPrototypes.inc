/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted unchanged from STM32H7RS HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
HAL_StatusTypeDef HAL_FLASHEx_Erase(const FLASH_EraseInitTypeDef *pEraseInit, uint32_t *SectorError);
HAL_StatusTypeDef HAL_FLASHEx_Erase_IT(const FLASH_EraseInitTypeDef *pEraseInit);
HAL_StatusTypeDef HAL_FLASHEx_OBProgram(const FLASH_OBProgramInitTypeDef *pOBInit);
void HAL_FLASHEx_OBGetConfig(FLASH_OBProgramInitTypeDef *pOBInit);
HAL_StatusTypeDef HAL_FLASHEx_OTPLockConfig(uint32_t OTPLBlock);
uint32_t HAL_FLASHEx_GetOTPLock(void);
HAL_StatusTypeDef HAL_FLASHEx_KeyConfig(const FLASH_KeyConfigTypeDef *pKeyConfig, const uint32_t *pKey);
HAL_StatusTypeDef HAL_FLASHEx_GetKey(const FLASH_KeyConfigTypeDef *pKeyConfig, uint32_t *pKey);
HAL_StatusTypeDef HAL_FLASHEx_ComputeCRC(const FLASH_CRCInitTypeDef *pCRCInit, uint32_t *CRC_Result);
void HAL_FLASHEx_EnableEccCorrectionInterrupt(void);
void HAL_FLASHEx_DisableEccCorrectionInterrupt(void);
void HAL_FLASHEx_EnableEccDetectionInterrupt(void);
void HAL_FLASHEx_DisableEccDetectionInterrupt(void);
void HAL_FLASHEx_GetEccInfo(FLASH_EccInfoTypeDef *pData);
void HAL_FLASHEx_ECCD_IRQHandler(void);
void HAL_FLASHEx_EccCorrectionCallback(void);
void HAL_FLASHEx_EccDetectionCallback(void);
static void FLASH_MassErase(void);
void FLASH_SectorErase(uint32_t Sector);
static void FLASH_OB_WRPConfig(uint32_t WRPState, uint32_t WRPSector);
static void FLASH_OB_UserConfig(uint32_t UserType, uint32_t UserConfig1, uint32_t UserConfig2);
static void FLASH_OB_HDPConfig(uint32_t HDPStartPage, uint32_t HDPEndPage);
static void FLASH_OB_NVConfig(uint32_t NVState);
static void FLASH_OB_GetWRP(uint32_t *WRPState, uint32_t *WRPSector);
static void FLASH_OB_GetUser(uint32_t *UserConfig1, uint32_t *UserConfig2);
static void FLASH_OB_GetHDP(uint32_t *HDPStartPage, uint32_t *HDPEndPage);
static uint32_t FLASH_OB_GetNV(void);
static uint32_t FLASH_OB_GetRoT(void);
static uint32_t FLASH_OB_GetEpoch(void);
static void FLASH_CRC_AddSector(uint32_t Sector);
static void FLASH_CRC_SelectAddress(uint32_t CRCStartAddr, uint32_t CRCEndAddr);
static HAL_StatusTypeDef FLASH_CRC_WaitForLastOperation(uint32_t Timeout);
