/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted without body changes from STM32H7RS HAL at
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
HAL_StatusTypeDef HAL_WWDG_Init(WWDG_HandleTypeDef *hwwdg);
__weak void HAL_WWDG_MspInit(WWDG_HandleTypeDef *hwwdg);
#if USE_HAL_WWDG_REGISTER_CALLBACKS == 1
HAL_StatusTypeDef HAL_WWDG_RegisterCallback(WWDG_HandleTypeDef *hwwdg, HAL_WWDG_CallbackIDTypeDef CallbackID,
                                            pWWDG_CallbackTypeDef pCallback);
#endif
#if USE_HAL_WWDG_REGISTER_CALLBACKS == 1
HAL_StatusTypeDef HAL_WWDG_UnRegisterCallback(WWDG_HandleTypeDef *hwwdg, HAL_WWDG_CallbackIDTypeDef CallbackID);
#endif
HAL_StatusTypeDef HAL_WWDG_Refresh(WWDG_HandleTypeDef *hwwdg);
void HAL_WWDG_IRQHandler(WWDG_HandleTypeDef *hwwdg);
__weak void HAL_WWDG_EarlyWakeupCallback(WWDG_HandleTypeDef *hwwdg);
