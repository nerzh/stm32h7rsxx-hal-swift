/* Test-only symbol namespace; function bodies are unchanged. */
#if CWATCHDOG_VARIANT == 0
#define IWDG_HandleTypeDef CWatchdogIWDG0Handle
#define CWATCHDOG_NAME(name) CWATCHDOG_JOIN(CWatchdogIWDG0_, name)
#else
#define IWDG_HandleTypeDef CWatchdogIWDG1Handle
#define CWATCHDOG_NAME(name) CWATCHDOG_JOIN(CWatchdogIWDG1_, name)
#define pIWDG_CallbackTypeDef CWatchdogIWDG1Callback
#endif
#define HAL_IWDG_Init CWATCHDOG_NAME(HAL_IWDG_Init)
#define HAL_IWDG_MspInit CWATCHDOG_NAME(HAL_IWDG_MspInit)
#define HAL_IWDG_RegisterCallback CWATCHDOG_NAME(HAL_IWDG_RegisterCallback)
#define HAL_IWDG_UnRegisterCallback CWATCHDOG_NAME(HAL_IWDG_UnRegisterCallback)
#define HAL_IWDG_Refresh CWATCHDOG_NAME(HAL_IWDG_Refresh)
#define HAL_IWDG_GetActiveStatus CWATCHDOG_NAME(HAL_IWDG_GetActiveStatus)
#define HAL_IWDG_IRQHandler CWATCHDOG_NAME(HAL_IWDG_IRQHandler)
#define HAL_IWDG_EarlyWakeupCallback CWATCHDOG_NAME(HAL_IWDG_EarlyWakeupCallback)
