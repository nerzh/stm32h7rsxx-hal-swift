/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted unchanged from HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
HAL_StatusTypeDef HAL_CORDIC_Init(CORDIC_HandleTypeDef *hcordic);
HAL_StatusTypeDef HAL_CORDIC_DeInit(CORDIC_HandleTypeDef *hcordic);
void HAL_CORDIC_MspInit(CORDIC_HandleTypeDef *hcordic);
void HAL_CORDIC_MspDeInit(CORDIC_HandleTypeDef *hcordic);
#if USE_HAL_CORDIC_REGISTER_CALLBACKS == 1
HAL_StatusTypeDef HAL_CORDIC_RegisterCallback(CORDIC_HandleTypeDef *hcordic, HAL_CORDIC_CallbackIDTypeDef CallbackID,
                                              void (* pCallback)(CORDIC_HandleTypeDef *_hcordic));
#endif
#if USE_HAL_CORDIC_REGISTER_CALLBACKS == 1
HAL_StatusTypeDef HAL_CORDIC_UnRegisterCallback(CORDIC_HandleTypeDef *hcordic, HAL_CORDIC_CallbackIDTypeDef CallbackID);
#endif
HAL_StatusTypeDef HAL_CORDIC_Configure(CORDIC_HandleTypeDef *hcordic, const CORDIC_ConfigTypeDef *sConfig);
HAL_StatusTypeDef HAL_CORDIC_Calculate(CORDIC_HandleTypeDef *hcordic, const int32_t *pInBuff, int32_t *pOutBuff,
                                       uint32_t NbCalc, uint32_t Timeout);
HAL_StatusTypeDef HAL_CORDIC_CalculateZO(CORDIC_HandleTypeDef *hcordic, const int32_t *pInBuff, int32_t *pOutBuff,
                                         uint32_t NbCalc, uint32_t Timeout);
HAL_StatusTypeDef HAL_CORDIC_Calculate_IT(CORDIC_HandleTypeDef *hcordic, const int32_t *pInBuff, int32_t *pOutBuff,
                                          uint32_t NbCalc);
HAL_StatusTypeDef HAL_CORDIC_Calculate_DMA(CORDIC_HandleTypeDef *hcordic, const int32_t *pInBuff, int32_t *pOutBuff,
                                           uint32_t NbCalc, uint32_t DMADirection);
void HAL_CORDIC_ErrorCallback(CORDIC_HandleTypeDef *hcordic);
void HAL_CORDIC_CalculateCpltCallback(CORDIC_HandleTypeDef *hcordic);
void HAL_CORDIC_IRQHandler(CORDIC_HandleTypeDef *hcordic);
HAL_CORDIC_StateTypeDef HAL_CORDIC_GetState(const CORDIC_HandleTypeDef *hcordic);
uint32_t HAL_CORDIC_GetError(const CORDIC_HandleTypeDef *hcordic);
static void CORDIC_WriteInDataIncrementPtr(const CORDIC_HandleTypeDef *hcordic, const int32_t **ppInBuff);
static void CORDIC_ReadOutDataIncrementPtr(const CORDIC_HandleTypeDef *hcordic, int32_t **ppOutBuff);
static void CORDIC_DMAInCplt(DMA_HandleTypeDef *hdma);
static void CORDIC_DMAOutCplt(DMA_HandleTypeDef *hdma);
static void CORDIC_DMAError(DMA_HandleTypeDef *hdma);
