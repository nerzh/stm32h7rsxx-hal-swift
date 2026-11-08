#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_InitProtocol(SAI_HandleTypeDef *hsai, uint32_t protocol, uint32_t datasize, uint32_t nbslot);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_Init(SAI_HandleTypeDef *hsai);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_DeInit(SAI_HandleTypeDef *hsai);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_SAI_RegisterCallback(SAI_HandleTypeDef        *hsai,
                                           HAL_SAI_CallbackIDTypeDef CallbackID,
                                           pSAI_CallbackTypeDef      pCallback);
#endif
#endif

#ifdef HAL_SAI_MODULE_ENABLED
#if (USE_HAL_SAI_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_SAI_UnRegisterCallback(SAI_HandleTypeDef        *hsai,
                                             HAL_SAI_CallbackIDTypeDef CallbackID);
#endif
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_Transmit(SAI_HandleTypeDef *hsai, uint8_t *pData, uint16_t Size, uint32_t Timeout);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_Receive(SAI_HandleTypeDef *hsai, uint8_t *pData, uint16_t Size, uint32_t Timeout);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_Transmit_IT(SAI_HandleTypeDef *hsai, uint8_t *pData, uint16_t Size);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_Receive_IT(SAI_HandleTypeDef *hsai, uint8_t *pData, uint16_t Size);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_DMAPause(SAI_HandleTypeDef *hsai);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_DMAResume(SAI_HandleTypeDef *hsai);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_DMAStop(SAI_HandleTypeDef *hsai);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_Abort(SAI_HandleTypeDef *hsai);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_Transmit_DMA(SAI_HandleTypeDef *hsai, uint8_t *pData, uint16_t Size);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_Receive_DMA(SAI_HandleTypeDef *hsai, uint8_t *pData, uint16_t Size);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_EnableTxMuteMode(SAI_HandleTypeDef *hsai, uint16_t val);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_DisableTxMuteMode(SAI_HandleTypeDef *hsai);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_EnableRxMuteMode(SAI_HandleTypeDef *hsai, SAIcallback callback, uint16_t counter);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAI_DisableRxMuteMode(SAI_HandleTypeDef *hsai);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
void HAL_SAI_IRQHandler(SAI_HandleTypeDef *hsai);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_SAI_StateTypeDef HAL_SAI_GetState(const SAI_HandleTypeDef *hsai);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
uint32_t HAL_SAI_GetError(const SAI_HandleTypeDef *hsai);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static HAL_StatusTypeDef SAI_InitI2S(SAI_HandleTypeDef *hsai, uint32_t protocol, uint32_t datasize, uint32_t nbslot);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static HAL_StatusTypeDef SAI_InitPCM(SAI_HandleTypeDef *hsai, uint32_t protocol, uint32_t datasize, uint32_t nbslot);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static void SAI_FillFifo(SAI_HandleTypeDef *hsai);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static uint32_t SAI_InterruptFlag(const SAI_HandleTypeDef *hsai, SAI_ModeTypedef mode);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static HAL_StatusTypeDef SAI_Disable(SAI_HandleTypeDef *hsai);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static void SAI_Transmit_IT8Bit(SAI_HandleTypeDef *hsai);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static void SAI_Transmit_IT16Bit(SAI_HandleTypeDef *hsai);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static void SAI_Transmit_IT32Bit(SAI_HandleTypeDef *hsai);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static void SAI_Receive_IT8Bit(SAI_HandleTypeDef *hsai);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static void SAI_Receive_IT16Bit(SAI_HandleTypeDef *hsai);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static void SAI_Receive_IT32Bit(SAI_HandleTypeDef *hsai);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static void SAI_DMATxCplt(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static void SAI_DMATxHalfCplt(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static void SAI_DMARxCplt(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static void SAI_DMARxHalfCplt(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static void SAI_DMAError(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
static void SAI_DMAAbort(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_SAI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SAIEx_ConfigPdmMicDelay(const SAI_HandleTypeDef *hsai,
                                              const SAIEx_PdmMicDelayParamTypeDef *pdmMicDelay);
#endif
