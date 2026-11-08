#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Init(I2C_HandleTypeDef *hi2c);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_DeInit(I2C_HandleTypeDef *hi2c);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_I2C_RegisterCallback(I2C_HandleTypeDef *hi2c, HAL_I2C_CallbackIDTypeDef CallbackID,
                                           pI2C_CallbackTypeDef pCallback);
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_I2C_UnRegisterCallback(I2C_HandleTypeDef *hi2c, HAL_I2C_CallbackIDTypeDef CallbackID);
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_I2C_RegisterAddrCallback(I2C_HandleTypeDef *hi2c, pI2C_AddrCallbackTypeDef pCallback);
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if (USE_HAL_I2C_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_I2C_UnRegisterAddrCallback(I2C_HandleTypeDef *hi2c);
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Master_Transmit(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint8_t *pData,
                                          uint16_t Size, uint32_t Timeout);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Master_Receive(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint8_t *pData,
                                         uint16_t Size, uint32_t Timeout);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Slave_Transmit(I2C_HandleTypeDef *hi2c, uint8_t *pData, uint16_t Size,
                                         uint32_t Timeout);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Slave_Receive(I2C_HandleTypeDef *hi2c, uint8_t *pData, uint16_t Size,
                                        uint32_t Timeout);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Master_Transmit_IT(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint8_t *pData,
                                             uint16_t Size);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Master_Receive_IT(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint8_t *pData,
                                            uint16_t Size);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Slave_Transmit_IT(I2C_HandleTypeDef *hi2c, uint8_t *pData, uint16_t Size);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Slave_Receive_IT(I2C_HandleTypeDef *hi2c, uint8_t *pData, uint16_t Size);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I2C_Master_Transmit_DMA(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint8_t *pData,
                                              uint16_t Size);
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I2C_Master_Receive_DMA(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint8_t *pData,
                                             uint16_t Size);
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I2C_Slave_Transmit_DMA(I2C_HandleTypeDef *hi2c, uint8_t *pData, uint16_t Size);
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I2C_Slave_Receive_DMA(I2C_HandleTypeDef *hi2c, uint8_t *pData, uint16_t Size);
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Mem_Write(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint16_t MemAddress,
                                    uint16_t MemAddSize, uint8_t *pData, uint16_t Size, uint32_t Timeout);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Mem_Read(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint16_t MemAddress,
                                   uint16_t MemAddSize, uint8_t *pData, uint16_t Size, uint32_t Timeout);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Mem_Write_IT(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint16_t MemAddress,
                                       uint16_t MemAddSize, uint8_t *pData, uint16_t Size);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Mem_Read_IT(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint16_t MemAddress,
                                      uint16_t MemAddSize, uint8_t *pData, uint16_t Size);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I2C_Mem_Write_DMA(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint16_t MemAddress,
                                        uint16_t MemAddSize, uint8_t *pData, uint16_t Size);
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I2C_Mem_Read_DMA(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint16_t MemAddress,
                                       uint16_t MemAddSize, uint8_t *pData, uint16_t Size);
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_IsDeviceReady(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint32_t Trials,
                                        uint32_t Timeout);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Master_Seq_Transmit_IT(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint8_t *pData,
                                                 uint16_t Size, uint32_t XferOptions);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I2C_Master_Seq_Transmit_DMA(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint8_t *pData,
                                                  uint16_t Size, uint32_t XferOptions);
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Master_Seq_Receive_IT(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint8_t *pData,
                                                uint16_t Size, uint32_t XferOptions);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I2C_Master_Seq_Receive_DMA(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint8_t *pData,
                                                 uint16_t Size, uint32_t XferOptions);
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Slave_Seq_Transmit_IT(I2C_HandleTypeDef *hi2c, uint8_t *pData, uint16_t Size,
                                                uint32_t XferOptions);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I2C_Slave_Seq_Transmit_DMA(I2C_HandleTypeDef *hi2c, uint8_t *pData, uint16_t Size,
                                                 uint32_t XferOptions);
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Slave_Seq_Receive_IT(I2C_HandleTypeDef *hi2c, uint8_t *pData, uint16_t Size,
                                               uint32_t XferOptions);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I2C_Slave_Seq_Receive_DMA(I2C_HandleTypeDef *hi2c, uint8_t *pData, uint16_t Size,
                                                uint32_t XferOptions);
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_EnableListen_IT(I2C_HandleTypeDef *hi2c);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_DisableListen_IT(I2C_HandleTypeDef *hi2c);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2C_Master_Abort_IT(I2C_HandleTypeDef *hi2c, uint16_t DevAddress);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
void HAL_I2C_EV_IRQHandler(I2C_HandleTypeDef *hi2c) /* Derogation MISRAC2012-Rule-8.13 */;
#endif

#ifdef HAL_I2C_MODULE_ENABLED
void HAL_I2C_ER_IRQHandler(I2C_HandleTypeDef *hi2c);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_I2C_StateTypeDef HAL_I2C_GetState(const I2C_HandleTypeDef *hi2c);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_I2C_ModeTypeDef HAL_I2C_GetMode(const I2C_HandleTypeDef *hi2c);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
uint32_t HAL_I2C_GetError(const I2C_HandleTypeDef *hi2c);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static HAL_StatusTypeDef I2C_Master_ISR_IT(struct __I2C_HandleTypeDef *hi2c, uint32_t ITFlags,
                                           uint32_t ITSources);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static HAL_StatusTypeDef I2C_Mem_ISR_IT(struct __I2C_HandleTypeDef *hi2c, uint32_t ITFlags,
                                        uint32_t ITSources);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static HAL_StatusTypeDef I2C_Slave_ISR_IT(struct __I2C_HandleTypeDef *hi2c, uint32_t ITFlags,
                                          uint32_t ITSources);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static HAL_StatusTypeDef I2C_Master_ISR_DMA(struct __I2C_HandleTypeDef *hi2c, uint32_t ITFlags,
                                            uint32_t ITSources);
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static HAL_StatusTypeDef I2C_Mem_ISR_DMA(struct __I2C_HandleTypeDef *hi2c, uint32_t ITFlags,
                                         uint32_t ITSources);
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static HAL_StatusTypeDef I2C_Slave_ISR_DMA(struct __I2C_HandleTypeDef *hi2c, uint32_t ITFlags,
                                           uint32_t ITSources);
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static HAL_StatusTypeDef I2C_RequestMemoryWrite(I2C_HandleTypeDef *hi2c, uint16_t DevAddress,
                                                uint16_t MemAddress, uint16_t MemAddSize, uint32_t Timeout,
                                                uint32_t Tickstart);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static HAL_StatusTypeDef I2C_RequestMemoryRead(I2C_HandleTypeDef *hi2c, uint16_t DevAddress,
                                               uint16_t MemAddress, uint16_t MemAddSize, uint32_t Timeout,
                                               uint32_t Tickstart);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static void I2C_ITAddrCplt(I2C_HandleTypeDef *hi2c, uint32_t ITFlags);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static void I2C_ITMasterSeqCplt(I2C_HandleTypeDef *hi2c);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static void I2C_ITSlaveSeqCplt(I2C_HandleTypeDef *hi2c);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static void I2C_ITMasterCplt(I2C_HandleTypeDef *hi2c, uint32_t ITFlags);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static void I2C_ITSlaveCplt(I2C_HandleTypeDef *hi2c, uint32_t ITFlags);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static void I2C_ITListenCplt(I2C_HandleTypeDef *hi2c, uint32_t ITFlags);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static void I2C_ITError(I2C_HandleTypeDef *hi2c, uint32_t ErrorCode);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static void I2C_TreatErrorCallback(I2C_HandleTypeDef *hi2c);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static void I2C_Flush_TXDR(I2C_HandleTypeDef *hi2c);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static void I2C_DMAMasterTransmitCplt(DMA_HandleTypeDef *hdma);
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static void I2C_DMASlaveTransmitCplt(DMA_HandleTypeDef *hdma);
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static void I2C_DMAMasterReceiveCplt(DMA_HandleTypeDef *hdma);
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static void I2C_DMASlaveReceiveCplt(DMA_HandleTypeDef *hdma);
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static void I2C_DMAError(DMA_HandleTypeDef *hdma);
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static void I2C_DMAAbort(DMA_HandleTypeDef *hdma);
#endif
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static HAL_StatusTypeDef I2C_WaitOnFlagUntilTimeout(I2C_HandleTypeDef *hi2c, uint32_t Flag, FlagStatus Status,
                                                    uint32_t Timeout, uint32_t Tickstart);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static HAL_StatusTypeDef I2C_WaitOnTXISFlagUntilTimeout(I2C_HandleTypeDef *hi2c, uint32_t Timeout,
                                                        uint32_t Tickstart);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static HAL_StatusTypeDef I2C_WaitOnSTOPFlagUntilTimeout(I2C_HandleTypeDef *hi2c, uint32_t Timeout,
                                                        uint32_t Tickstart);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static HAL_StatusTypeDef I2C_WaitOnRXNEFlagUntilTimeout(I2C_HandleTypeDef *hi2c, uint32_t Timeout,
                                                        uint32_t Tickstart);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static HAL_StatusTypeDef I2C_IsErrorOccurred(I2C_HandleTypeDef *hi2c, uint32_t Timeout, uint32_t Tickstart);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static void I2C_TransferConfig(I2C_HandleTypeDef *hi2c, uint16_t DevAddress, uint8_t Size, uint32_t Mode,
                               uint32_t Request);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static void I2C_Enable_IRQ(I2C_HandleTypeDef *hi2c, uint16_t InterruptRequest);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static void I2C_Disable_IRQ(I2C_HandleTypeDef *hi2c, uint16_t InterruptRequest);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
static void I2C_ConvertOtherXferOptions(I2C_HandleTypeDef *hi2c);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2CEx_ConfigAnalogFilter(I2C_HandleTypeDef *hi2c, uint32_t AnalogFilter);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2CEx_ConfigDigitalFilter(I2C_HandleTypeDef *hi2c, uint32_t DigitalFilter);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2CEx_EnableWakeUp(I2C_HandleTypeDef *hi2c);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2CEx_DisableWakeUp(I2C_HandleTypeDef *hi2c);
#endif

#ifdef HAL_I2C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I2CEx_ConfigFastModePlus(I2C_HandleTypeDef *hi2c, uint32_t FastModePlus);
#endif
