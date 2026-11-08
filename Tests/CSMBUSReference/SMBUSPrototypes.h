#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_Init(SMBUS_HandleTypeDef *hsmbus);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_DeInit(SMBUS_HandleTypeDef *hsmbus);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_ConfigAnalogFilter(SMBUS_HandleTypeDef *hsmbus, uint32_t AnalogFilter);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_ConfigDigitalFilter(SMBUS_HandleTypeDef *hsmbus, uint32_t DigitalFilter);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
#if (USE_HAL_SMBUS_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_SMBUS_RegisterCallback(SMBUS_HandleTypeDef *hsmbus,
                                             HAL_SMBUS_CallbackIDTypeDef CallbackID,
                                             pSMBUS_CallbackTypeDef pCallback);
#endif
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
#if (USE_HAL_SMBUS_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_SMBUS_UnRegisterCallback(SMBUS_HandleTypeDef *hsmbus,
                                               HAL_SMBUS_CallbackIDTypeDef CallbackID);
#endif
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
#if (USE_HAL_SMBUS_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_SMBUS_RegisterAddrCallback(SMBUS_HandleTypeDef *hsmbus,
                                                 pSMBUS_AddrCallbackTypeDef pCallback);
#endif
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
#if (USE_HAL_SMBUS_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_SMBUS_UnRegisterAddrCallback(SMBUS_HandleTypeDef *hsmbus);
#endif
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_Master_Transmit_IT(SMBUS_HandleTypeDef *hsmbus, uint16_t DevAddress,
                                               uint8_t *pData, uint16_t Size, uint32_t XferOptions);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_Master_Receive_IT(SMBUS_HandleTypeDef *hsmbus, uint16_t DevAddress, uint8_t *pData,
                                              uint16_t Size, uint32_t XferOptions);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_Master_Abort_IT(SMBUS_HandleTypeDef *hsmbus, uint16_t DevAddress);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_Slave_Transmit_IT(SMBUS_HandleTypeDef *hsmbus, uint8_t *pData, uint16_t Size,
                                              uint32_t XferOptions);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_Slave_Receive_IT(SMBUS_HandleTypeDef *hsmbus, uint8_t *pData, uint16_t Size,
                                             uint32_t XferOptions);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_EnableListen_IT(SMBUS_HandleTypeDef *hsmbus);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_DisableListen_IT(SMBUS_HandleTypeDef *hsmbus);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_EnableAlert_IT(SMBUS_HandleTypeDef *hsmbus);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_DisableAlert_IT(SMBUS_HandleTypeDef *hsmbus);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUS_IsDeviceReady(SMBUS_HandleTypeDef *hsmbus, uint16_t DevAddress, uint32_t Trials,
                                          uint32_t Timeout);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
void HAL_SMBUS_EV_IRQHandler(SMBUS_HandleTypeDef *hsmbus);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
void HAL_SMBUS_ER_IRQHandler(SMBUS_HandleTypeDef *hsmbus);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
uint32_t HAL_SMBUS_GetState(const SMBUS_HandleTypeDef *hsmbus);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
uint32_t HAL_SMBUS_GetError(const SMBUS_HandleTypeDef *hsmbus);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
static HAL_StatusTypeDef SMBUS_Master_ISR(SMBUS_HandleTypeDef *hsmbus, uint32_t StatusFlags);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
static HAL_StatusTypeDef SMBUS_Slave_ISR(SMBUS_HandleTypeDef *hsmbus, uint32_t StatusFlags);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
static void SMBUS_Enable_IRQ(SMBUS_HandleTypeDef *hsmbus, uint32_t InterruptRequest);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
static void SMBUS_Disable_IRQ(SMBUS_HandleTypeDef *hsmbus, uint32_t InterruptRequest);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
static void SMBUS_ITErrorHandler(SMBUS_HandleTypeDef *hsmbus);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
static HAL_StatusTypeDef SMBUS_WaitOnFlagUntilTimeout(SMBUS_HandleTypeDef *hsmbus, uint32_t Flag,
                                                      FlagStatus Status, uint32_t Timeout);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
static void SMBUS_Flush_TXDR(SMBUS_HandleTypeDef *hsmbus);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
static void SMBUS_TransferConfig(SMBUS_HandleTypeDef *hsmbus,  uint16_t DevAddress, uint8_t Size,
                                 uint32_t Mode, uint32_t Request);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
static void SMBUS_ConvertOtherXferOptions(SMBUS_HandleTypeDef *hsmbus);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUSEx_EnableWakeUp(SMBUS_HandleTypeDef *hsmbus);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUSEx_DisableWakeUp(SMBUS_HandleTypeDef *hsmbus);
#endif

#ifdef HAL_SMBUS_MODULE_ENABLED
HAL_StatusTypeDef HAL_SMBUSEx_ConfigFastModePlus(SMBUS_HandleTypeDef *hsmbus, uint32_t FastModePlus);
#endif
