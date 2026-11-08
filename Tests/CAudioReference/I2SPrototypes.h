#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2S_Init(I2S_HandleTypeDef *hi2s);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2S_DeInit(I2S_HandleTypeDef *hi2s);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
#if (USE_HAL_I2S_REGISTER_CALLBACKS == 1UL)
HAL_StatusTypeDef HAL_I2S_RegisterCallback(I2S_HandleTypeDef *hi2s, HAL_I2S_CallbackIDTypeDef CallbackID,
                                           pI2S_CallbackTypeDef pCallback);
#endif
#endif

#ifdef HAL_I2S_MODULE_ENABLED
#if (USE_HAL_I2S_REGISTER_CALLBACKS == 1UL)
HAL_StatusTypeDef HAL_I2S_UnRegisterCallback(I2S_HandleTypeDef *hi2s, HAL_I2S_CallbackIDTypeDef CallbackID);
#endif
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2S_Transmit(I2S_HandleTypeDef *hi2s, const uint16_t *pData, uint16_t Size, uint32_t Timeout);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2S_Receive(I2S_HandleTypeDef *hi2s, uint16_t *pData, uint16_t Size, uint32_t Timeout);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2SEx_TransmitReceive(I2S_HandleTypeDef *hi2s, const uint16_t *pTxData, uint16_t *pRxData,
                                            uint16_t Size, uint32_t Timeout);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2S_Transmit_IT(I2S_HandleTypeDef *hi2s, const uint16_t *pData, uint16_t Size);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2S_Receive_IT(I2S_HandleTypeDef *hi2s, uint16_t *pData, uint16_t Size);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2SEx_TransmitReceive_IT(I2S_HandleTypeDef *hi2s, const uint16_t *pTxData, uint16_t *pRxData,
                                               uint16_t Size);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2S_Transmit_DMA(I2S_HandleTypeDef *hi2s, const uint16_t *pData, uint16_t Size);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2S_Receive_DMA(I2S_HandleTypeDef *hi2s, uint16_t *pData, uint16_t Size);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2SEx_TransmitReceive_DMA(I2S_HandleTypeDef *hi2s, const uint16_t *pTxData, uint16_t *pRxData,
                                                uint16_t Size);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2S_DMAPause(I2S_HandleTypeDef *hi2s);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2S_DMAResume(I2S_HandleTypeDef *hi2s);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2S_DMAStop(I2S_HandleTypeDef *hi2s);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2S_EnableIOSwap(I2S_HandleTypeDef *hi2s);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2S_DisableIOSwap(I2S_HandleTypeDef *hi2s);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
uint32_t HAL_I2S_IsEnabledIOSwap(const I2S_HandleTypeDef *hi2s);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
void HAL_I2S_IRQHandler(I2S_HandleTypeDef *hi2s);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
HAL_I2S_StateTypeDef HAL_I2S_GetState(const I2S_HandleTypeDef *hi2s);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
uint32_t HAL_I2S_GetError(const I2S_HandleTypeDef *hi2s);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
static void I2S_DMATxCplt(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
static void I2S_DMATxHalfCplt(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
static void I2S_DMARxCplt(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
static void I2S_DMARxHalfCplt(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
static void I2SEx_DMATxRxCplt(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
static void I2SEx_DMATxRxHalfCplt(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
static void I2S_DMAError(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
static void I2S_Transmit_16Bit_IT(I2S_HandleTypeDef *hi2s);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
static void I2S_Transmit_32Bit_IT(I2S_HandleTypeDef *hi2s);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
static void I2S_Receive_16Bit_IT(I2S_HandleTypeDef *hi2s);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
static void I2S_Receive_32Bit_IT(I2S_HandleTypeDef *hi2s);
#endif

#ifdef HAL_I2S_MODULE_ENABLED
static HAL_StatusTypeDef I2S_WaitFlagStateUntilTimeout(I2S_HandleTypeDef *hi2s, uint32_t Flag, FlagStatus State,
                                                       uint32_t Tickstart, uint32_t Timeout);
#endif
