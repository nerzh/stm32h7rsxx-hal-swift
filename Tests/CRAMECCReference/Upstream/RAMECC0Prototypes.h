/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted from STM32H7RS HAL at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
HAL_StatusTypeDef CRAMECC0_HAL_RAMECC_Init(CRAMECC0Handle *hramecc);
HAL_StatusTypeDef CRAMECC0_HAL_RAMECC_DeInit(CRAMECC0Handle *hramecc);
void CRAMECC0_HAL_RAMECC_MspInit(CRAMECC0Handle *hramecc);
void CRAMECC0_HAL_RAMECC_MspDeInit(CRAMECC0Handle *hramecc);
HAL_StatusTypeDef CRAMECC0_HAL_RAMECC_StartMonitor(CRAMECC0Handle *hramecc);
HAL_StatusTypeDef CRAMECC0_HAL_RAMECC_StopMonitor(CRAMECC0Handle *hramecc);
HAL_StatusTypeDef CRAMECC0_HAL_RAMECC_EnableNotification(CRAMECC0Handle *hramecc, uint32_t Notifications);
HAL_StatusTypeDef CRAMECC0_HAL_RAMECC_DisableNotification(CRAMECC0Handle *hramecc, uint32_t Notifications);
void CRAMECC0_HAL_RAMECC_IRQHandler(CRAMECC0Handle *hramecc);
void CRAMECC0_HAL_RAMECC_DetectSingleErrorCallback(CRAMECC0Handle *hramecc);
void CRAMECC0_HAL_RAMECC_DetectDoubleErrorCallback(CRAMECC0Handle *hramecc);
uint32_t CRAMECC0_HAL_RAMECC_GetFailingAddress(const CRAMECC0Handle *hramecc);
uint32_t CRAMECC0_HAL_RAMECC_GetFailingDataLow(const CRAMECC0Handle *hramecc);
uint32_t CRAMECC0_HAL_RAMECC_GetFailingDataHigh(const CRAMECC0Handle *hramecc);
uint32_t CRAMECC0_HAL_RAMECC_GetHammingErrorCode(const CRAMECC0Handle *hramecc);
uint32_t CRAMECC0_HAL_RAMECC_IsECCSingleErrorDetected(const CRAMECC0Handle *hramecc);
uint32_t CRAMECC0_HAL_RAMECC_IsECCDoubleErrorDetected(const CRAMECC0Handle *hramecc);
HAL_RAMECC_StateTypeDef CRAMECC0_HAL_RAMECC_GetState(const CRAMECC0Handle *hramecc);
uint32_t CRAMECC0_HAL_RAMECC_GetError(const CRAMECC0Handle *hramecc);
