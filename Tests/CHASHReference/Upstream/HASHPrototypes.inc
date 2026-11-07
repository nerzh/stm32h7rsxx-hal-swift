/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted unchanged from HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
HAL_StatusTypeDef HAL_HASH_Init(HASH_HandleTypeDef *hhash);

HAL_StatusTypeDef HAL_HASH_DeInit(HASH_HandleTypeDef *hhash);

HAL_StatusTypeDef HAL_HASH_SetConfig(HASH_HandleTypeDef *hhash, const HASH_ConfigTypeDef *pConf);

HAL_StatusTypeDef HAL_HASH_GetConfig(HASH_HandleTypeDef *hhash, HASH_ConfigTypeDef *pConf);

void HAL_HASH_MspInit(HASH_HandleTypeDef *hhash);

void HAL_HASH_MspDeInit(HASH_HandleTypeDef *hhash);

#if USE_HAL_HASH_REGISTER_CALLBACKS == 1
HAL_StatusTypeDef HAL_HASH_RegisterCallback(HASH_HandleTypeDef *hhash, HAL_HASH_CallbackIDTypeDef CallbackID,
                                            pHASH_CallbackTypeDef pCallback);
#endif

#if USE_HAL_HASH_REGISTER_CALLBACKS == 1
HAL_StatusTypeDef HAL_HASH_UnRegisterCallback(HASH_HandleTypeDef *hhash, HAL_HASH_CallbackIDTypeDef CallbackID);
#endif

#if USE_HAL_HASH_SUSPEND_RESUME == 1U
void HAL_HASH_Suspend(HASH_HandleTypeDef *hhash, uint8_t *pMemBuffer);
#endif

#if USE_HAL_HASH_SUSPEND_RESUME == 1U
void HAL_HASH_Resume(HASH_HandleTypeDef *hhash, uint8_t *pMemBuffer);
#endif

#if USE_HAL_HASH_SUSPEND_RESUME == 1U
HAL_StatusTypeDef HAL_HASH_ProcessSuspend(HASH_HandleTypeDef *hhash);
#endif

HAL_StatusTypeDef HAL_HASH_Start(HASH_HandleTypeDef *hhash, const uint8_t *const pInBuffer, uint32_t Size,
                                 uint8_t *const pOutBuffer, uint32_t Timeout);

HAL_StatusTypeDef HAL_HASH_Start_IT(HASH_HandleTypeDef *hhash, const uint8_t *const pInBuffer, uint32_t Size,
                                    uint8_t *const pOutBuffer);

HAL_StatusTypeDef HAL_HASH_Start_DMA(HASH_HandleTypeDef *hhash, const uint8_t *const pInBuffer, uint32_t Size,
                                     uint8_t *const pOutBuffer);

HAL_StatusTypeDef HAL_HASH_Accumulate(HASH_HandleTypeDef *hhash, const uint8_t *const pInBuffer, uint32_t Size,
                                      uint32_t Timeout);

HAL_StatusTypeDef HAL_HASH_AccumulateLast(HASH_HandleTypeDef *hhash, const uint8_t *const pInBuffer, uint32_t Size,
                                          uint8_t *const pOutBuffer, uint32_t Timeout);

HAL_StatusTypeDef HAL_HASH_Accumulate_IT(HASH_HandleTypeDef *hhash, const uint8_t *const pInBuffer, uint32_t Size);

HAL_StatusTypeDef HAL_HASH_AccumulateLast_IT(HASH_HandleTypeDef *hhash, const uint8_t *const pInBuffer, uint32_t Size,
                                             uint8_t *const pOutBuffer);

HAL_StatusTypeDef HAL_HASH_HMAC_Start(HASH_HandleTypeDef *hhash, const uint8_t *const pInBuffer, uint32_t Size,
                                      uint8_t *const pOutBuffer, uint32_t Timeout);

HAL_StatusTypeDef HAL_HASH_HMAC_Accumulate(HASH_HandleTypeDef *hhash, const uint8_t *const pInBuffer, uint32_t Size,
                                           uint32_t Timeout);

HAL_StatusTypeDef HAL_HASH_HMAC_AccumulateLast(HASH_HandleTypeDef *hhash, const uint8_t *const pInBuffer, uint32_t Size,
                                               uint8_t *const pOutBuffer, uint32_t Timeout);

HAL_StatusTypeDef HAL_HASH_HMAC_Start_IT(HASH_HandleTypeDef *hhash, const uint8_t *const pInBuffer, uint32_t Size,
                                         uint8_t *const pOutBuffer);

HAL_StatusTypeDef HAL_HASH_HMAC_Accumulate_IT(HASH_HandleTypeDef *hhash, const uint8_t *const pInBuffer, uint32_t Size);

HAL_StatusTypeDef HAL_HASH_HMAC_AccumulateLast_IT(HASH_HandleTypeDef *hhash, const uint8_t *const pInBuffer,
                                                  uint32_t Size, uint8_t *const pOutBuffer);

HAL_StatusTypeDef HAL_HASH_HMAC_Start_DMA(HASH_HandleTypeDef *hhash, const uint8_t *const pInBuffer, uint32_t Size,
                                          uint8_t *const pOutBuffer);

void HAL_HASH_IRQHandler(HASH_HandleTypeDef *hhash);

void HAL_HASH_InCpltCallback(HASH_HandleTypeDef *hhash);

void HAL_HASH_DgstCpltCallback(HASH_HandleTypeDef *hhash);

void HAL_HASH_ErrorCallback(HASH_HandleTypeDef *hhash);

HAL_HASH_StateTypeDef HAL_HASH_GetState(const HASH_HandleTypeDef *hhash);

uint32_t HAL_HASH_GetError(const HASH_HandleTypeDef *hhash);

static void HASH_DMAXferCplt(DMA_HandleTypeDef *hdma);

static void HASH_DMAError(DMA_HandleTypeDef *hdma);

static void HASH_WriteData(HASH_HandleTypeDef *hhash, const uint8_t *pInBuffer, uint32_t Size);

static HAL_StatusTypeDef HASH_WriteData_IT(HASH_HandleTypeDef *hhash);

static void HASH_GetDigest(const HASH_HandleTypeDef *hhash, const uint8_t *pMsgDigest, uint8_t Size);

static HAL_StatusTypeDef HASH_WaitOnFlagUntilTimeout(HASH_HandleTypeDef *hhash, uint32_t Flag, FlagStatus Status,
                                                     uint32_t Timeout);
