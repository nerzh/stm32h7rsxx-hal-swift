/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted from STM32H7RS HAL at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
HAL_StatusTypeDef CRAMECC1_HAL_RAMECC_Init(CRAMECC1Handle *hramecc);
HAL_StatusTypeDef CRAMECC1_HAL_RAMECC_DeInit(CRAMECC1Handle *hramecc);
void CRAMECC1_HAL_RAMECC_MspInit(CRAMECC1Handle *hramecc);
void CRAMECC1_HAL_RAMECC_MspDeInit(CRAMECC1Handle *hramecc);
HAL_StatusTypeDef CRAMECC1_HAL_RAMECC_StartMonitor(CRAMECC1Handle *hramecc);
HAL_StatusTypeDef CRAMECC1_HAL_RAMECC_StopMonitor(CRAMECC1Handle *hramecc);
HAL_StatusTypeDef CRAMECC1_HAL_RAMECC_EnableNotification(CRAMECC1Handle *hramecc, uint32_t Notifications);
HAL_StatusTypeDef CRAMECC1_HAL_RAMECC_DisableNotification(CRAMECC1Handle *hramecc, uint32_t Notifications);
void CRAMECC1_HAL_RAMECC_IRQHandler(CRAMECC1Handle *hramecc);
void CRAMECC1_HAL_RAMECC_DetectSingleErrorCallback(CRAMECC1Handle *hramecc);
void CRAMECC1_HAL_RAMECC_DetectDoubleErrorCallback(CRAMECC1Handle *hramecc);
HAL_StatusTypeDef CRAMECC1_HAL_RAMECC_RegisterCallback(CRAMECC1Handle *hramecc,
                                              HAL_RAMECC_CallbackIDTypeDef CallbackID,
                                              void (* pCallback)(CRAMECC1Handle *_hramecc));
HAL_StatusTypeDef CRAMECC1_HAL_RAMECC_UnRegisterCallback(CRAMECC1Handle *hramecc, HAL_RAMECC_CallbackIDTypeDef CallbackID);
uint32_t CRAMECC1_HAL_RAMECC_GetFailingAddress(const CRAMECC1Handle *hramecc);
uint32_t CRAMECC1_HAL_RAMECC_GetFailingDataLow(const CRAMECC1Handle *hramecc);
uint32_t CRAMECC1_HAL_RAMECC_GetFailingDataHigh(const CRAMECC1Handle *hramecc);
uint32_t CRAMECC1_HAL_RAMECC_GetHammingErrorCode(const CRAMECC1Handle *hramecc);
uint32_t CRAMECC1_HAL_RAMECC_IsECCSingleErrorDetected(const CRAMECC1Handle *hramecc);
uint32_t CRAMECC1_HAL_RAMECC_IsECCDoubleErrorDetected(const CRAMECC1Handle *hramecc);
HAL_RAMECC_StateTypeDef CRAMECC1_HAL_RAMECC_GetState(const CRAMECC1Handle *hramecc);
uint32_t CRAMECC1_HAL_RAMECC_GetError(const CRAMECC1Handle *hramecc);
