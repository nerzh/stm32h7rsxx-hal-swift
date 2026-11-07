/* Test-only symbol namespace; function bodies are unchanged. */
#if CWATCHDOG_VARIANT == 0
#define WWDG_HandleTypeDef CWatchdogWWDG0Handle
#define CWATCHDOG_NAME(name) CWATCHDOG_JOIN(CWatchdogWWDG0_, name)
#else
#define WWDG_HandleTypeDef CWatchdogWWDG1Handle
#define CWATCHDOG_NAME(name) CWATCHDOG_JOIN(CWatchdogWWDG1_, name)
#define pWWDG_CallbackTypeDef CWatchdogWWDG1Callback
#endif
#define HAL_WWDG_Init CWATCHDOG_NAME(HAL_WWDG_Init)
#define HAL_WWDG_MspInit CWATCHDOG_NAME(HAL_WWDG_MspInit)
#define HAL_WWDG_RegisterCallback CWATCHDOG_NAME(HAL_WWDG_RegisterCallback)
#define HAL_WWDG_UnRegisterCallback CWATCHDOG_NAME(HAL_WWDG_UnRegisterCallback)
#define HAL_WWDG_Refresh CWATCHDOG_NAME(HAL_WWDG_Refresh)
#define HAL_WWDG_IRQHandler CWATCHDOG_NAME(HAL_WWDG_IRQHandler)
#define HAL_WWDG_EarlyWakeupCallback CWATCHDOG_NAME(HAL_WWDG_EarlyWakeupCallback)
