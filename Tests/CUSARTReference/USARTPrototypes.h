HAL_StatusTypeDef HAL_USART_Init(USART_HandleTypeDef *husart);
HAL_StatusTypeDef HAL_USART_DeInit(USART_HandleTypeDef *husart);
HAL_StatusTypeDef HAL_USART_RegisterCallback(USART_HandleTypeDef *husart, HAL_USART_CallbackIDTypeDef CallbackID,
                                             pUSART_CallbackTypeDef pCallback);
HAL_StatusTypeDef HAL_USART_UnRegisterCallback(USART_HandleTypeDef *husart, HAL_USART_CallbackIDTypeDef CallbackID);
HAL_StatusTypeDef HAL_USART_Transmit(USART_HandleTypeDef *husart, const uint8_t *pTxData, uint16_t Size,
                                     uint32_t Timeout);
HAL_StatusTypeDef HAL_USART_Receive(USART_HandleTypeDef *husart, uint8_t *pRxData, uint16_t Size, uint32_t Timeout);
HAL_StatusTypeDef HAL_USART_TransmitReceive(USART_HandleTypeDef *husart, const uint8_t *pTxData, uint8_t *pRxData,
                                            uint16_t Size, uint32_t Timeout);
HAL_StatusTypeDef HAL_USART_Transmit_IT(USART_HandleTypeDef *husart, const uint8_t *pTxData, uint16_t Size);
HAL_StatusTypeDef HAL_USART_Receive_IT(USART_HandleTypeDef *husart, uint8_t *pRxData, uint16_t Size);
HAL_StatusTypeDef HAL_USART_TransmitReceive_IT(USART_HandleTypeDef *husart, const uint8_t *pTxData, uint8_t *pRxData,
                                               uint16_t Size);
HAL_StatusTypeDef HAL_USART_Transmit_DMA(USART_HandleTypeDef *husart, const uint8_t *pTxData, uint16_t Size);
HAL_StatusTypeDef HAL_USART_Receive_DMA(USART_HandleTypeDef *husart, uint8_t *pRxData, uint16_t Size);
HAL_StatusTypeDef HAL_USART_TransmitReceive_DMA(USART_HandleTypeDef *husart, const uint8_t *pTxData, uint8_t *pRxData,
                                                uint16_t Size);
HAL_StatusTypeDef HAL_USART_DMAPause(USART_HandleTypeDef *husart);
HAL_StatusTypeDef HAL_USART_DMAResume(USART_HandleTypeDef *husart);
HAL_StatusTypeDef HAL_USART_DMAStop(USART_HandleTypeDef *husart);
HAL_StatusTypeDef HAL_USART_Abort(USART_HandleTypeDef *husart);
HAL_StatusTypeDef HAL_USART_Abort_IT(USART_HandleTypeDef *husart);
void HAL_USART_IRQHandler(USART_HandleTypeDef *husart);
HAL_USART_StateTypeDef HAL_USART_GetState(const USART_HandleTypeDef *husart);
uint32_t HAL_USART_GetError(const USART_HandleTypeDef *husart);
void USART_InitCallbacksToDefault(USART_HandleTypeDef *husart);
static void USART_EndTransfer(USART_HandleTypeDef *husart);
static void USART_DMATransmitCplt(DMA_HandleTypeDef *hdma);
static void USART_DMATxHalfCplt(DMA_HandleTypeDef *hdma);
static void USART_DMAReceiveCplt(DMA_HandleTypeDef *hdma);
static void USART_DMARxHalfCplt(DMA_HandleTypeDef *hdma);
static void USART_DMAError(DMA_HandleTypeDef *hdma);
static void USART_DMAAbortOnError(DMA_HandleTypeDef *hdma);
static void USART_DMATxAbortCallback(DMA_HandleTypeDef *hdma);
static void USART_DMARxAbortCallback(DMA_HandleTypeDef *hdma);
static HAL_StatusTypeDef USART_WaitOnFlagUntilTimeout(USART_HandleTypeDef *husart, uint32_t Flag, FlagStatus Status,
                                                      uint32_t Tickstart, uint32_t Timeout);
static HAL_StatusTypeDef USART_SetConfig(USART_HandleTypeDef *husart);
static HAL_StatusTypeDef USART_CheckIdleState(USART_HandleTypeDef *husart);
static void USART_TxISR_8BIT(USART_HandleTypeDef *husart);
static void USART_TxISR_16BIT(USART_HandleTypeDef *husart);
static void USART_TxISR_8BIT_FIFOEN(USART_HandleTypeDef *husart);
static void USART_TxISR_16BIT_FIFOEN(USART_HandleTypeDef *husart);
static void USART_EndTransmit_IT(USART_HandleTypeDef *husart);
static void USART_RxISR_8BIT(USART_HandleTypeDef *husart);
static void USART_RxISR_16BIT(USART_HandleTypeDef *husart);
static void USART_RxISR_8BIT_FIFOEN(USART_HandleTypeDef *husart);
static void USART_RxISR_16BIT_FIFOEN(USART_HandleTypeDef *husart);
HAL_StatusTypeDef HAL_USARTEx_EnableSlaveMode(USART_HandleTypeDef *husart);
HAL_StatusTypeDef HAL_USARTEx_DisableSlaveMode(USART_HandleTypeDef *husart);
HAL_StatusTypeDef HAL_USARTEx_ConfigNSS(USART_HandleTypeDef *husart, uint32_t NSSConfig);
HAL_StatusTypeDef HAL_USARTEx_EnableFifoMode(USART_HandleTypeDef *husart);
HAL_StatusTypeDef HAL_USARTEx_DisableFifoMode(USART_HandleTypeDef *husart);
HAL_StatusTypeDef HAL_USARTEx_SetTxFifoThreshold(USART_HandleTypeDef *husart, uint32_t Threshold);
HAL_StatusTypeDef HAL_USARTEx_SetRxFifoThreshold(USART_HandleTypeDef *husart, uint32_t Threshold);
static void USARTEx_SetNbDataToProcess(USART_HandleTypeDef *husart);
