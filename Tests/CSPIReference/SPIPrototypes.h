#ifdef HAL_SPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SPI_Init(SPI_HandleTypeDef *hspi);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SPI_DeInit(SPI_HandleTypeDef *hspi);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
#if (USE_HAL_SPI_REGISTER_CALLBACKS == 1UL)
HAL_StatusTypeDef HAL_SPI_RegisterCallback(SPI_HandleTypeDef *hspi, HAL_SPI_CallbackIDTypeDef CallbackID,
                                           pSPI_CallbackTypeDef pCallback);
#endif
#endif

#ifdef HAL_SPI_MODULE_ENABLED
#if (USE_HAL_SPI_REGISTER_CALLBACKS == 1UL)
HAL_StatusTypeDef HAL_SPI_UnRegisterCallback(SPI_HandleTypeDef *hspi, HAL_SPI_CallbackIDTypeDef CallbackID);
#endif
#endif

#ifdef HAL_SPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SPI_Transmit(SPI_HandleTypeDef *hspi, const uint8_t *pData, uint16_t Size, uint32_t Timeout);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SPI_Receive(SPI_HandleTypeDef *hspi, uint8_t *pData, uint16_t Size, uint32_t Timeout);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SPI_TransmitReceive(SPI_HandleTypeDef *hspi, const uint8_t *pTxData, uint8_t *pRxData,
                                          uint16_t Size, uint32_t Timeout);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SPI_Transmit_IT(SPI_HandleTypeDef *hspi, const uint8_t *pData, uint16_t Size);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SPI_Receive_IT(SPI_HandleTypeDef *hspi, uint8_t *pData, uint16_t Size);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SPI_TransmitReceive_IT(SPI_HandleTypeDef *hspi, const uint8_t *pTxData, uint8_t *pRxData,
                                             uint16_t Size);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SPI_Transmit_DMA(SPI_HandleTypeDef *hspi, const uint8_t *pData, uint16_t Size);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SPI_Receive_DMA(SPI_HandleTypeDef *hspi, uint8_t *pData, uint16_t Size);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SPI_TransmitReceive_DMA(SPI_HandleTypeDef *hspi, const uint8_t *pTxData, uint8_t *pRxData,
                                              uint16_t Size);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SPI_Abort(SPI_HandleTypeDef *hspi);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SPI_Abort_IT(SPI_HandleTypeDef *hspi);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SPI_DMAPause(SPI_HandleTypeDef *hspi);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SPI_DMAResume(SPI_HandleTypeDef *hspi);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SPI_DMAStop(SPI_HandleTypeDef *hspi);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
void HAL_SPI_IRQHandler(SPI_HandleTypeDef *hspi);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
HAL_SPI_StateTypeDef HAL_SPI_GetState(const SPI_HandleTypeDef *hspi);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
uint32_t HAL_SPI_GetError(const SPI_HandleTypeDef *hspi);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
static void SPI_DMATransmitCplt(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
static void SPI_DMAReceiveCplt(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
static void SPI_DMATransmitReceiveCplt(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
static void SPI_DMAHalfTransmitCplt(DMA_HandleTypeDef *hdma) /* Derogation MISRAC2012-Rule-8.13 */;
#endif

#ifdef HAL_SPI_MODULE_ENABLED
static void SPI_DMAHalfReceiveCplt(DMA_HandleTypeDef *hdma) /* Derogation MISRAC2012-Rule-8.13 */;
#endif

#ifdef HAL_SPI_MODULE_ENABLED
static void SPI_DMAHalfTransmitReceiveCplt(DMA_HandleTypeDef *hdma) /* Derogation MISRAC2012-Rule-8.13 */;
#endif

#ifdef HAL_SPI_MODULE_ENABLED
static void SPI_DMAError(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
static void SPI_DMAAbortOnError(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
static void SPI_DMATxAbortCallback(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
static void SPI_DMARxAbortCallback(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
static void SPI_RxISR_8BIT(SPI_HandleTypeDef *hspi);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
static void SPI_RxISR_16BIT(SPI_HandleTypeDef *hspi);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
static void SPI_RxISR_32BIT(SPI_HandleTypeDef *hspi);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
static void SPI_TxISR_8BIT(SPI_HandleTypeDef *hspi);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
static void SPI_TxISR_16BIT(SPI_HandleTypeDef *hspi);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
static void SPI_TxISR_32BIT(SPI_HandleTypeDef *hspi);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
static void SPI_AbortTransfer(SPI_HandleTypeDef *hspi);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
static void SPI_CloseTransfer(SPI_HandleTypeDef *hspi);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
static HAL_StatusTypeDef SPI_WaitOnFlagUntilTimeout(const SPI_HandleTypeDef *hspi, uint32_t Flag, FlagStatus Status,
                                                    uint32_t Timeout, uint32_t Tickstart);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
static uint32_t SPI_GetPacketSize(const SPI_HandleTypeDef *hspi);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SPIEx_FlushRxFifo(const SPI_HandleTypeDef *hspi);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SPIEx_EnableLockConfiguration(SPI_HandleTypeDef *hspi);
#endif

#ifdef HAL_SPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_SPIEx_ConfigureUnderrun(SPI_HandleTypeDef *hspi, uint32_t UnderrunDetection,
                                              uint32_t UnderrunBehaviour);
#endif
