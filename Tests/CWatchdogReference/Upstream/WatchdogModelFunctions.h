/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted without body changes from STM32H7RS HAL at
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
HAL_StatusTypeDef CWatchdogIWDG0_HAL_IWDG_Init(CWatchdogIWDG0Handle *hiwdg);
void CWatchdogIWDG0_HAL_IWDG_MspInit(CWatchdogIWDG0Handle *hiwdg);
HAL_StatusTypeDef CWatchdogIWDG0_HAL_IWDG_Refresh(CWatchdogIWDG0Handle *hiwdg);
uint32_t CWatchdogIWDG0_HAL_IWDG_GetActiveStatus(const CWatchdogIWDG0Handle *hiwdg);
void CWatchdogIWDG0_HAL_IWDG_IRQHandler(CWatchdogIWDG0Handle *hiwdg);
void CWatchdogIWDG0_HAL_IWDG_EarlyWakeupCallback(CWatchdogIWDG0Handle *hiwdg);
HAL_StatusTypeDef CWatchdogIWDG1_HAL_IWDG_Init(CWatchdogIWDG1Handle *hiwdg);
void CWatchdogIWDG1_HAL_IWDG_MspInit(CWatchdogIWDG1Handle *hiwdg);
HAL_StatusTypeDef CWatchdogIWDG1_HAL_IWDG_RegisterCallback(CWatchdogIWDG1Handle *hiwdg, HAL_IWDG_CallbackIDTypeDef CallbackID,
                                            CWatchdogIWDG1Callback pCallback);
HAL_StatusTypeDef CWatchdogIWDG1_HAL_IWDG_UnRegisterCallback(CWatchdogIWDG1Handle *hiwdg, HAL_IWDG_CallbackIDTypeDef CallbackID);
HAL_StatusTypeDef CWatchdogIWDG1_HAL_IWDG_Refresh(CWatchdogIWDG1Handle *hiwdg);
uint32_t CWatchdogIWDG1_HAL_IWDG_GetActiveStatus(const CWatchdogIWDG1Handle *hiwdg);
void CWatchdogIWDG1_HAL_IWDG_IRQHandler(CWatchdogIWDG1Handle *hiwdg);
void CWatchdogIWDG1_HAL_IWDG_EarlyWakeupCallback(CWatchdogIWDG1Handle *hiwdg);
HAL_StatusTypeDef CWatchdogWWDG0_HAL_WWDG_Init(CWatchdogWWDG0Handle *hwwdg);
void CWatchdogWWDG0_HAL_WWDG_MspInit(CWatchdogWWDG0Handle *hwwdg);
HAL_StatusTypeDef CWatchdogWWDG0_HAL_WWDG_Refresh(CWatchdogWWDG0Handle *hwwdg);
void CWatchdogWWDG0_HAL_WWDG_IRQHandler(CWatchdogWWDG0Handle *hwwdg);
void CWatchdogWWDG0_HAL_WWDG_EarlyWakeupCallback(CWatchdogWWDG0Handle *hwwdg);
HAL_StatusTypeDef CWatchdogWWDG1_HAL_WWDG_Init(CWatchdogWWDG1Handle *hwwdg);
void CWatchdogWWDG1_HAL_WWDG_MspInit(CWatchdogWWDG1Handle *hwwdg);
HAL_StatusTypeDef CWatchdogWWDG1_HAL_WWDG_RegisterCallback(CWatchdogWWDG1Handle *hwwdg, HAL_WWDG_CallbackIDTypeDef CallbackID,
                                            CWatchdogWWDG1Callback pCallback);
HAL_StatusTypeDef CWatchdogWWDG1_HAL_WWDG_UnRegisterCallback(CWatchdogWWDG1Handle *hwwdg, HAL_WWDG_CallbackIDTypeDef CallbackID);
HAL_StatusTypeDef CWatchdogWWDG1_HAL_WWDG_Refresh(CWatchdogWWDG1Handle *hwwdg);
void CWatchdogWWDG1_HAL_WWDG_IRQHandler(CWatchdogWWDG1Handle *hwwdg);
void CWatchdogWWDG1_HAL_WWDG_EarlyWakeupCallback(CWatchdogWWDG1Handle *hwwdg);
