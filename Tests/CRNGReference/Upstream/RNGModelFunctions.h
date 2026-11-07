/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * BSD-3-Clause; see LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
/* Namespaced declarations for both independent HAL callback modes. */
HAL_StatusTypeDef CRNG0_HAL_RNG_Init(CRNG0Handle *hrng);
HAL_StatusTypeDef CRNG0_HAL_RNG_DeInit(CRNG0Handle *hrng);
void CRNG0_HAL_RNG_MspInit(CRNG0Handle *hrng);
void CRNG0_HAL_RNG_MspDeInit(CRNG0Handle *hrng);




HAL_StatusTypeDef CRNG0_HAL_RNG_GenerateRandomNumber(CRNG0Handle *hrng, uint32_t *random32bit);
HAL_StatusTypeDef CRNG0_HAL_RNG_GenerateRandomNumber_IT(CRNG0Handle *hrng);
void CRNG0_HAL_RNG_IRQHandler(CRNG0Handle *hrng);
uint32_t CRNG0_HAL_RNG_ReadLastRandomNumber(const CRNG0Handle *hrng);
void CRNG0_HAL_RNG_ReadyDataCallback(CRNG0Handle *hrng, uint32_t random32bit);
void CRNG0_HAL_RNG_ErrorCallback(CRNG0Handle *hrng);
HAL_RNG_StateTypeDef CRNG0_HAL_RNG_GetState(const CRNG0Handle *hrng);
uint32_t CRNG0_HAL_RNG_GetError(const CRNG0Handle *hrng);
HAL_StatusTypeDef CRNG0_RNG_RecoverSeedError(CRNG0Handle *hrng);

HAL_StatusTypeDef CRNG0_HAL_RNGEx_SetConfig(CRNG0Handle *hrng, const RNG_ConfigTypeDef *pConf);
HAL_StatusTypeDef CRNG0_HAL_RNGEx_GetConfig(CRNG0Handle *hrng, RNG_ConfigTypeDef *pConf);
HAL_StatusTypeDef CRNG0_HAL_RNGEx_LockConfig(CRNG0Handle *hrng);
HAL_StatusTypeDef CRNG0_HAL_RNGEx_RecoverSeedError(CRNG0Handle *hrng);

HAL_StatusTypeDef CRNG1_HAL_RNG_Init(CRNG1Handle *hrng);
HAL_StatusTypeDef CRNG1_HAL_RNG_DeInit(CRNG1Handle *hrng);
void CRNG1_HAL_RNG_MspInit(CRNG1Handle *hrng);
void CRNG1_HAL_RNG_MspDeInit(CRNG1Handle *hrng);
HAL_StatusTypeDef CRNG1_HAL_RNG_RegisterCallback(CRNG1Handle *hrng, HAL_RNG_CallbackIDTypeDef CallbackID,
                                           pRNG_CallbackTypeDef pCallback);

HAL_StatusTypeDef CRNG1_HAL_RNG_UnRegisterCallback(CRNG1Handle *hrng, HAL_RNG_CallbackIDTypeDef CallbackID);

HAL_StatusTypeDef CRNG1_HAL_RNG_RegisterReadyDataCallback(CRNG1Handle *hrng, pRNG_ReadyDataCallbackTypeDef pCallback);

HAL_StatusTypeDef CRNG1_HAL_RNG_UnRegisterReadyDataCallback(CRNG1Handle *hrng);

HAL_StatusTypeDef CRNG1_HAL_RNG_GenerateRandomNumber(CRNG1Handle *hrng, uint32_t *random32bit);
HAL_StatusTypeDef CRNG1_HAL_RNG_GenerateRandomNumber_IT(CRNG1Handle *hrng);
void CRNG1_HAL_RNG_IRQHandler(CRNG1Handle *hrng);
uint32_t CRNG1_HAL_RNG_ReadLastRandomNumber(const CRNG1Handle *hrng);
void CRNG1_HAL_RNG_ReadyDataCallback(CRNG1Handle *hrng, uint32_t random32bit);
void CRNG1_HAL_RNG_ErrorCallback(CRNG1Handle *hrng);
HAL_RNG_StateTypeDef CRNG1_HAL_RNG_GetState(const CRNG1Handle *hrng);
uint32_t CRNG1_HAL_RNG_GetError(const CRNG1Handle *hrng);
HAL_StatusTypeDef CRNG1_RNG_RecoverSeedError(CRNG1Handle *hrng);

HAL_StatusTypeDef CRNG1_HAL_RNGEx_SetConfig(CRNG1Handle *hrng, const RNG_ConfigTypeDef *pConf);
HAL_StatusTypeDef CRNG1_HAL_RNGEx_GetConfig(CRNG1Handle *hrng, RNG_ConfigTypeDef *pConf);
HAL_StatusTypeDef CRNG1_HAL_RNGEx_LockConfig(CRNG1Handle *hrng);
HAL_StatusTypeDef CRNG1_HAL_RNGEx_RecoverSeedError(CRNG1Handle *hrng);
