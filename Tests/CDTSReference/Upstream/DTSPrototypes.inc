/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted unchanged from STM32H7RS HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
HAL_StatusTypeDef HAL_DTS_Init(DTS_HandleTypeDef *hdts);
HAL_StatusTypeDef HAL_DTS_DeInit(DTS_HandleTypeDef *hdts);
void              HAL_DTS_MspInit(DTS_HandleTypeDef *hdts);
void              HAL_DTS_MspDeInit(DTS_HandleTypeDef *hdts);
HAL_StatusTypeDef HAL_DTS_RegisterCallback(DTS_HandleTypeDef        *hdts,
                                           HAL_DTS_CallbackIDTypeDef CallbackID,
                                           pDTS_CallbackTypeDef      pCallback);
HAL_StatusTypeDef HAL_DTS_UnRegisterCallback(DTS_HandleTypeDef        *hdts,
                                             HAL_DTS_CallbackIDTypeDef CallbackID);
HAL_StatusTypeDef HAL_DTS_Start(DTS_HandleTypeDef *hdts);
HAL_StatusTypeDef HAL_DTS_Stop(DTS_HandleTypeDef *hdts);
HAL_StatusTypeDef HAL_DTS_GetTemperature(DTS_HandleTypeDef *hdts, int32_t *Temperature);
HAL_StatusTypeDef HAL_DTS_Start_IT(DTS_HandleTypeDef *hdts);
HAL_StatusTypeDef HAL_DTS_Stop_IT(DTS_HandleTypeDef *hdts);
void              HAL_DTS_IRQHandler(DTS_HandleTypeDef *hdts);
void HAL_DTS_EndCallback(DTS_HandleTypeDef *hdts);
void HAL_DTS_LowCallback(DTS_HandleTypeDef *hdts);
void HAL_DTS_HighCallback(DTS_HandleTypeDef *hdts);
void HAL_DTS_AsyncEndCallback(DTS_HandleTypeDef *hdts);
void HAL_DTS_AsyncLowCallback(DTS_HandleTypeDef *hdts);
void HAL_DTS_AsyncHighCallback(DTS_HandleTypeDef *hdts);
HAL_DTS_StateTypeDef HAL_DTS_GetState(const DTS_HandleTypeDef *hdts);
