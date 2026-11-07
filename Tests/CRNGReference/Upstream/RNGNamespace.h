/* Namespacing does not alter the extracted function bodies. */
#define CRNG_JOIN_(a, b) a##b
#define CRNG_JOIN(a, b) CRNG_JOIN_(a, b)
#if CRNG_VARIANT == 0
#define CRNG_NAME(name) CRNG_JOIN(CRNG0_,name)
#define RNG_HandleTypeDef CRNG0Handle
#else
#define CRNG_NAME(name) CRNG_JOIN(CRNG1_,name)
#define RNG_HandleTypeDef CRNG1Handle
#endif
#define HAL_RNG_Init CRNG_NAME(HAL_RNG_Init)
#define HAL_RNG_DeInit CRNG_NAME(HAL_RNG_DeInit)
#define HAL_RNG_MspInit CRNG_NAME(HAL_RNG_MspInit)
#define HAL_RNG_MspDeInit CRNG_NAME(HAL_RNG_MspDeInit)
#define HAL_RNG_RegisterCallback CRNG_NAME(HAL_RNG_RegisterCallback)
#define HAL_RNG_UnRegisterCallback CRNG_NAME(HAL_RNG_UnRegisterCallback)
#define HAL_RNG_RegisterReadyDataCallback CRNG_NAME(HAL_RNG_RegisterReadyDataCallback)
#define HAL_RNG_UnRegisterReadyDataCallback CRNG_NAME(HAL_RNG_UnRegisterReadyDataCallback)
#define HAL_RNG_GenerateRandomNumber CRNG_NAME(HAL_RNG_GenerateRandomNumber)
#define HAL_RNG_GenerateRandomNumber_IT CRNG_NAME(HAL_RNG_GenerateRandomNumber_IT)
#define HAL_RNG_IRQHandler CRNG_NAME(HAL_RNG_IRQHandler)
#define HAL_RNG_ReadLastRandomNumber CRNG_NAME(HAL_RNG_ReadLastRandomNumber)
#define HAL_RNG_ReadyDataCallback CRNG_NAME(HAL_RNG_ReadyDataCallback)
#define HAL_RNG_ErrorCallback CRNG_NAME(HAL_RNG_ErrorCallback)
#define HAL_RNG_GetState CRNG_NAME(HAL_RNG_GetState)
#define HAL_RNG_GetError CRNG_NAME(HAL_RNG_GetError)
#define RNG_RecoverSeedError CRNG_NAME(RNG_RecoverSeedError)
#define HAL_RNGEx_SetConfig CRNG_NAME(HAL_RNGEx_SetConfig)
#define HAL_RNGEx_GetConfig CRNG_NAME(HAL_RNGEx_GetConfig)
#define HAL_RNGEx_LockConfig CRNG_NAME(HAL_RNGEx_LockConfig)
#define HAL_RNGEx_RecoverSeedError CRNG_NAME(HAL_RNGEx_RecoverSeedError)
