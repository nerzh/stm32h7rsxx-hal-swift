/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Unchanged declarations/functions/macros from STM32H7RS HAL at
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748. Host bindings are in the shim.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
HAL_StatusTypeDef HAL_RCCEx_PeriphCLKConfig(const RCC_PeriphCLKInitTypeDef  *PeriphClkInit);
void HAL_RCCEx_GetPeriphCLKConfig(RCC_PeriphCLKInitTypeDef  *PeriphClkInit);
uint32_t HAL_RCCEx_GetPeriphCLKFreq(uint32_t PeriphClk);
void HAL_RCCEx_EnableClockProtection(uint32_t ProtectClk);
void HAL_RCCEx_DisableClockProtection(uint32_t ProtectClk);
void HAL_RCCEx_EnableLSECSS(void);
void HAL_RCCEx_DisableLSECSS(void);
void HAL_RCCEx_EnableLSECSS_IT(void);
void HAL_RCCEx_WakeUpStopCLKConfig(uint32_t WakeUpClk);
void HAL_RCCEx_KerWakeUpStopCLKConfig(uint32_t WakeUpClk);
void HAL_RCCEx_LSECSS_IRQHandler(void);
void HAL_RCCEx_LSECSS_Callback(void);
void HAL_RCCEx_CRSConfig(const RCC_CRSInitTypeDef *pInit);
void HAL_RCCEx_CRSSoftwareSynchronizationGenerate(void);
void HAL_RCCEx_CRSGetSynchronizationInfo(RCC_CRSSynchroInfoTypeDef *pSynchroInfo);
uint32_t HAL_RCCEx_CRSWaitSynchronization(uint32_t Timeout);
void HAL_RCCEx_CRS_IRQHandler(void);
void HAL_RCCEx_CRS_SyncOkCallback(void);
void HAL_RCCEx_CRS_SyncWarnCallback(void);
void HAL_RCCEx_CRS_ExpectedSyncCallback(void);
void HAL_RCCEx_CRS_ErrorCallback(uint32_t Error);
static uint32_t RCC_GetCLKPFreq(void);
uint32_t HAL_RCC_GetSysClockFreq(void);
uint32_t HAL_RCC_GetHCLKFreq(void);
uint32_t HAL_RCC_GetPCLK1Freq(void);
uint32_t HAL_RCC_GetPCLK2Freq(void);
uint32_t HAL_RCC_GetPCLK4Freq(void);
uint32_t HAL_RCC_GetPCLK5Freq(void);
uint32_t HAL_RCC_GetPLL1PFreq(void);
uint32_t HAL_RCC_GetPLL1QFreq(void);
uint32_t HAL_RCC_GetPLL1RFreq(void);
uint32_t HAL_RCC_GetPLL1SFreq(void);
uint32_t HAL_RCC_GetPLL2PFreq(void);
uint32_t HAL_RCC_GetPLL2QFreq(void);
uint32_t HAL_RCC_GetPLL2RFreq(void);
uint32_t HAL_RCC_GetPLL2SFreq(void);
uint32_t HAL_RCC_GetPLL2TFreq(void);
uint32_t HAL_RCC_GetPLL3PFreq(void);
uint32_t HAL_RCC_GetPLL3QFreq(void);
uint32_t HAL_RCC_GetPLL3RFreq(void);
uint32_t HAL_RCC_GetPLL3SFreq(void);
static uint32_t RCC_PLL1_GetVCOOutputFreq(void);
static uint32_t RCC_PLL2_GetVCOOutputFreq(void);
static uint32_t RCC_PLL3_GetVCOOutputFreq(void);
