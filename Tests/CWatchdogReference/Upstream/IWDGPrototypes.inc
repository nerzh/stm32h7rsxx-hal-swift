/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted without body changes from STM32H7RS HAL at
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
HAL_StatusTypeDef HAL_IWDG_Init(IWDG_HandleTypeDef *hiwdg);
__weak void HAL_IWDG_MspInit(IWDG_HandleTypeDef *hiwdg);
#if USE_HAL_IWDG_REGISTER_CALLBACKS == 1
HAL_StatusTypeDef HAL_IWDG_RegisterCallback(IWDG_HandleTypeDef *hiwdg, HAL_IWDG_CallbackIDTypeDef CallbackID,
                                            pIWDG_CallbackTypeDef pCallback);
#endif
#if USE_HAL_IWDG_REGISTER_CALLBACKS == 1
HAL_StatusTypeDef HAL_IWDG_UnRegisterCallback(IWDG_HandleTypeDef *hiwdg, HAL_IWDG_CallbackIDTypeDef CallbackID);
#endif
HAL_StatusTypeDef HAL_IWDG_Refresh(IWDG_HandleTypeDef *hiwdg);
uint32_t HAL_IWDG_GetActiveStatus(const IWDG_HandleTypeDef *hiwdg);
void HAL_IWDG_IRQHandler(IWDG_HandleTypeDef *hiwdg);
__weak void HAL_IWDG_EarlyWakeupCallback(IWDG_HandleTypeDef *hiwdg);
