#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Init(I3C_HandleTypeDef *hi3c);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_DeInit(I3C_HandleTypeDef *hi3c);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
#if (USE_HAL_I3C_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_I3C_RegisterCallback(I3C_HandleTypeDef *hi3c,
                                           HAL_I3C_CallbackIDTypeDef callbackID,
                                           pI3C_CallbackTypeDef pCallback);
#endif
#endif

#ifdef HAL_I3C_MODULE_ENABLED
#if (USE_HAL_I3C_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_I3C_RegisterNotifyCallback(I3C_HandleTypeDef *hi3c, pI3C_NotifyCallbackTypeDef pNotifyCallback);
#endif
#endif

#ifdef HAL_I3C_MODULE_ENABLED
#if (USE_HAL_I3C_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_I3C_RegisterTgtReqDynamicAddrCallback(I3C_HandleTypeDef *hi3c,
                                                            pI3C_TgtReqDynamicAddrCallbackTypeDef pTgtReqAddrCallback);
#endif
#endif

#ifdef HAL_I3C_MODULE_ENABLED
#if (USE_HAL_I3C_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_I3C_RegisterTgtHotJoinCallback(I3C_HandleTypeDef *hi3c,
                                                     pI3C_TgtHotJoinCallbackTypeDef pTgtHotJoinCallback);
#endif
#endif

#ifdef HAL_I3C_MODULE_ENABLED
#if (USE_HAL_I3C_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_I3C_UnRegisterCallback(I3C_HandleTypeDef *hi3c, HAL_I3C_CallbackIDTypeDef callbackID);
#endif
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_ActivateNotification(I3C_HandleTypeDef *hi3c, I3C_XferTypeDef *pXferData,
                                               uint32_t interruptMask);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_DeactivateNotification(I3C_HandleTypeDef *hi3c, uint32_t interruptMask);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
void HAL_I3C_ER_IRQHandler(I3C_HandleTypeDef *hi3c);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
void HAL_I3C_EV_IRQHandler(I3C_HandleTypeDef *hi3c) /* Derogation MISRAC2012-Rule-8.13 */;
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Ctrl_BusCharacteristicConfig(I3C_HandleTypeDef *hi3c,
                                                       const LL_I3C_CtrlBusConfTypeDef *pConfig);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Tgt_BusCharacteristicConfig(I3C_HandleTypeDef *hi3c,
                                                      const LL_I3C_TgtBusConfTypeDef *pConfig);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_SetConfigFifo(I3C_HandleTypeDef *hi3c, const I3C_FifoConfTypeDef *pConfig);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Ctrl_Config(I3C_HandleTypeDef *hi3c, const I3C_CtrlConfTypeDef *pConfig);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Tgt_Config(I3C_HandleTypeDef *hi3c, const I3C_TgtConfTypeDef *pConfig);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Ctrl_ConfigBusDevices(I3C_HandleTypeDef           *hi3c,
                                                const I3C_DeviceConfTypeDef *pDesc,
                                                uint8_t                      nbDevice);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_AddDescToFrame(I3C_HandleTypeDef         *hi3c,
                                         const I3C_CCCTypeDef      *pCCCDesc,
                                         const I3C_PrivateTypeDef  *pPrivateDesc,
                                         I3C_XferTypeDef           *pXferData,
                                         uint8_t                    nbFrame,
                                         uint32_t                   option);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Ctrl_SetConfigResetPattern(I3C_HandleTypeDef *hi3c, uint32_t resetPattern);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Ctrl_GetConfigResetPattern(I3C_HandleTypeDef *hi3c, uint32_t *pResetPattern);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_FlushAllFifo(I3C_HandleTypeDef *hi3c);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_FlushTxFifo(I3C_HandleTypeDef *hi3c);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_FlushRxFifo(I3C_HandleTypeDef *hi3c);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_FlushControlFifo(I3C_HandleTypeDef *hi3c);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_FlushStatusFifo(I3C_HandleTypeDef *hi3c);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_ClearConfigFifo(I3C_HandleTypeDef *hi3c);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_GetConfigFifo(I3C_HandleTypeDef *hi3c, I3C_FifoConfTypeDef *pConfig);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Ctrl_TransmitCCC(I3C_HandleTypeDef *hi3c,
                                           I3C_XferTypeDef   *pXferData,
                                           uint32_t           timeout);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Ctrl_TransmitCCC_IT(I3C_HandleTypeDef *hi3c,
                                              I3C_XferTypeDef   *pXferData);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I3C_Ctrl_TransmitCCC_DMA(I3C_HandleTypeDef *hi3c,
                                               I3C_XferTypeDef   *pXferData);
#endif
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Ctrl_ReceiveCCC(I3C_HandleTypeDef *hi3c,
                                          I3C_XferTypeDef   *pXferData,
                                          uint32_t           timeout);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Ctrl_ReceiveCCC_IT(I3C_HandleTypeDef *hi3c,
                                             I3C_XferTypeDef   *pXferData);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I3C_Ctrl_ReceiveCCC_DMA(I3C_HandleTypeDef *hi3c,
                                              I3C_XferTypeDef   *pXferData);
#endif
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Ctrl_Transmit(I3C_HandleTypeDef   *hi3c,
                                        I3C_XferTypeDef     *pXferData,
                                        uint32_t             timeout);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Ctrl_Transmit_IT(I3C_HandleTypeDef   *hi3c,
                                           I3C_XferTypeDef     *pXferData);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I3C_Ctrl_Transmit_DMA(I3C_HandleTypeDef   *hi3c,
                                            I3C_XferTypeDef     *pXferData);
#endif
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Ctrl_Receive(I3C_HandleTypeDef   *hi3c,
                                       I3C_XferTypeDef     *pXferData,
                                       uint32_t             timeout);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Ctrl_Receive_IT(I3C_HandleTypeDef   *hi3c,
                                          I3C_XferTypeDef     *pXferData);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I3C_Ctrl_Receive_DMA(I3C_HandleTypeDef   *hi3c,
                                           I3C_XferTypeDef     *pXferData);
#endif
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Ctrl_MultipleTransfer_IT(I3C_HandleTypeDef   *hi3c,
                                                   I3C_XferTypeDef     *pXferData);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I3C_Ctrl_MultipleTransfer_DMA(I3C_HandleTypeDef   *hi3c, I3C_XferTypeDef     *pXferData);
#endif
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Ctrl_DynAddrAssign(I3C_HandleTypeDef  *hi3c,
                                             uint64_t           *target_payload,
                                             uint32_t            dynOption,
                                             uint32_t            timeout);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Ctrl_DynAddrAssign_IT(I3C_HandleTypeDef *hi3c, uint32_t dynOption);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Ctrl_SetDynAddr(I3C_HandleTypeDef *hi3c, uint8_t devAddress);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Ctrl_IsDeviceI3C_Ready(I3C_HandleTypeDef *hi3c,
                                                 uint8_t            devAddress,
                                                 uint32_t           trials,
                                                 uint32_t           timeout);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Ctrl_IsDeviceI2C_Ready(I3C_HandleTypeDef *hi3c,
                                                 uint8_t            devAddress,
                                                 uint32_t           trials,
                                                 uint32_t           timeout);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Ctrl_GenerateArbitration(I3C_HandleTypeDef *hi3c, uint32_t timeout);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Tgt_Transmit(I3C_HandleTypeDef *hi3c, I3C_XferTypeDef *pXferData, uint32_t timeout);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Tgt_Transmit_IT(I3C_HandleTypeDef *hi3c, I3C_XferTypeDef *pXferData);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I3C_Tgt_Transmit_DMA(I3C_HandleTypeDef *hi3c, I3C_XferTypeDef *pXferData);
#endif
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Tgt_Receive(I3C_HandleTypeDef *hi3c, I3C_XferTypeDef *pXferData, uint32_t timeout);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Tgt_Receive_IT(I3C_HandleTypeDef *hi3c, I3C_XferTypeDef *pXferData);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
HAL_StatusTypeDef HAL_I3C_Tgt_Receive_DMA(I3C_HandleTypeDef *hi3c, I3C_XferTypeDef *pXferData);
#endif
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Tgt_ControlRoleReq(I3C_HandleTypeDef *hi3c, uint32_t timeout);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Tgt_ControlRoleReq_IT(I3C_HandleTypeDef *hi3c);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Tgt_HotJoinReq(I3C_HandleTypeDef *hi3c, uint8_t *pAddress, uint32_t timeout);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Tgt_HotJoinReq_IT(I3C_HandleTypeDef *hi3c);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Tgt_IBIReq(I3C_HandleTypeDef *hi3c, const uint8_t *pPayload,
                                     uint8_t payloadSize, uint32_t timeout);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Tgt_IBIReq_IT(I3C_HandleTypeDef *hi3c, const uint8_t *pPayload, uint8_t payloadSize);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Abort_IT(I3C_HandleTypeDef *hi3c);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_I3C_StateTypeDef HAL_I3C_GetState(const I3C_HandleTypeDef *hi3c);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_I3C_ModeTypeDef HAL_I3C_GetMode(const I3C_HandleTypeDef *hi3c);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
uint32_t HAL_I3C_GetError(const I3C_HandleTypeDef *hi3c);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_GetCCCInfo(I3C_HandleTypeDef *hi3c,
                                     uint32_t notifyId,
                                     I3C_CCCInfoTypeDef *pCCCInfo);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
HAL_StatusTypeDef HAL_I3C_Get_ENTDAA_Payload_Info(I3C_HandleTypeDef *hi3c,
                                                  uint64_t ENTDAA_payload,
                                                  I3C_ENTDAAPayloadTypeDef *pENTDAA_payload);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static HAL_StatusTypeDef I3C_Tgt_Event_ISR(struct __I3C_HandleTypeDef *hi3c, uint32_t itMasks);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static HAL_StatusTypeDef I3C_Ctrl_Event_ISR(struct __I3C_HandleTypeDef *hi3c, uint32_t itMasks);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static HAL_StatusTypeDef I3C_Tgt_HotJoin_ISR(struct __I3C_HandleTypeDef *hi3c, uint32_t itMasks);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static HAL_StatusTypeDef I3C_Tgt_CtrlRole_ISR(struct __I3C_HandleTypeDef *hi3c, uint32_t itMasks);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static HAL_StatusTypeDef I3C_Tgt_IBI_ISR(struct __I3C_HandleTypeDef *hi3c, uint32_t itMasks);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static HAL_StatusTypeDef I3C_Tgt_Tx_ISR(struct __I3C_HandleTypeDef *hi3c, uint32_t itMasks);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static HAL_StatusTypeDef I3C_Tgt_Rx_ISR(struct __I3C_HandleTypeDef *hi3c, uint32_t itMasks);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static HAL_StatusTypeDef I3C_Tgt_Tx_DMA_ISR(struct __I3C_HandleTypeDef *hi3c, uint32_t itMasks);
#endif
#endif

#ifdef HAL_I3C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static HAL_StatusTypeDef I3C_Tgt_Rx_DMA_ISR(struct __I3C_HandleTypeDef *hi3c, uint32_t itMasks);
#endif
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static HAL_StatusTypeDef I3C_Ctrl_Tx_ISR(struct __I3C_HandleTypeDef *hi3c, uint32_t itMasks);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static HAL_StatusTypeDef I3C_Ctrl_Rx_ISR(struct __I3C_HandleTypeDef *hi3c, uint32_t itMasks);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static HAL_StatusTypeDef I3C_Ctrl_Multiple_Xfer_ISR(struct __I3C_HandleTypeDef *hi3c, uint32_t itMasks);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static HAL_StatusTypeDef I3C_Ctrl_Tx_Listen_Event_ISR(struct __I3C_HandleTypeDef *hi3c, uint32_t itMasks);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static HAL_StatusTypeDef I3C_Ctrl_Rx_Listen_Event_ISR(struct __I3C_HandleTypeDef *hi3c, uint32_t itMasks);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static HAL_StatusTypeDef I3C_Ctrl_Multiple_Xfer_Listen_Event_ISR(struct __I3C_HandleTypeDef *hi3c, uint32_t itMasks);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static HAL_StatusTypeDef I3C_Ctrl_DAA_ISR(struct __I3C_HandleTypeDef *hi3c, uint32_t itMasks);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static HAL_StatusTypeDef I3C_Ctrl_Tx_DMA_ISR(struct __I3C_HandleTypeDef *hi3c, uint32_t itMasks);
#endif
#endif

#ifdef HAL_I3C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static HAL_StatusTypeDef I3C_Ctrl_Rx_DMA_ISR(struct __I3C_HandleTypeDef *hi3c, uint32_t itMasks);
#endif
#endif

#ifdef HAL_I3C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static HAL_StatusTypeDef I3C_Ctrl_Multiple_Xfer_DMA_ISR(struct __I3C_HandleTypeDef *hi3c, uint32_t itMasks);
#endif
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static HAL_StatusTypeDef I3C_Abort_ISR(struct __I3C_HandleTypeDef *hi3c, uint32_t itMasks);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static void I3C_DMAControlTransmitCplt(DMA_HandleTypeDef *hdma);
#endif
#endif

#ifdef HAL_I3C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static void I3C_DMADataTransmitCplt(DMA_HandleTypeDef *hdma);
#endif
#endif

#ifdef HAL_I3C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static void I3C_DMADataReceiveCplt(DMA_HandleTypeDef *hdma);
#endif
#endif

#ifdef HAL_I3C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static void I3C_DMAError(DMA_HandleTypeDef *hdma);
#endif
#endif

#ifdef HAL_I3C_MODULE_ENABLED
#if defined(HAL_DMA_MODULE_ENABLED)
static void I3C_DMAAbort(DMA_HandleTypeDef *hdma);
#endif
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static HAL_StatusTypeDef I3C_WaitOnFlagUntilTimeout(I3C_HandleTypeDef *hi3c, uint32_t flag, FlagStatus flagstatus,
                                                    uint32_t timeout, uint32_t tickstart);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static HAL_StatusTypeDef I3C_WaitOnDAAUntilTimeout(I3C_HandleTypeDef *hi3c, uint32_t timeout, uint32_t tickstart);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static void I3C_TransmitByteTreatment(I3C_HandleTypeDef *hi3c);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static void I3C_TransmitWordTreatment(I3C_HandleTypeDef *hi3c);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static void I3C_ReceiveByteTreatment(I3C_HandleTypeDef *hi3c);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static void I3C_ReceiveWordTreatment(I3C_HandleTypeDef *hi3c);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static void I3C_ControlDataTreatment(I3C_HandleTypeDef *hi3c);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static void I3C_StateUpdate(I3C_HandleTypeDef *hi3c);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static void I3C_GetErrorSources(I3C_HandleTypeDef *hi3c);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static HAL_StatusTypeDef I3C_Xfer_PriorPreparation(I3C_HandleTypeDef *hi3c, uint8_t counter, uint32_t option);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static uint32_t I3C_FillTxBuffer_CCC(I3C_HandleTypeDef *hi3c,
                                     uint32_t           indexDesc,
                                     uint32_t           txSize,
                                     uint32_t           txCurrentIndex);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static uint32_t I3C_FillTxBuffer_Private(I3C_HandleTypeDef *hi3c,
                                         uint32_t           indexDesc,
                                         uint32_t           txSize,
                                         uint32_t           txCurrentIndex);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static HAL_StatusTypeDef I3C_ControlBuffer_PriorPreparation(I3C_HandleTypeDef *hi3c,
                                                            uint8_t            counter,
                                                            uint32_t           option);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static HAL_StatusTypeDef I3C_Ctrl_IsDevice_Ready(I3C_HandleTypeDef *hi3c,
                                                 const I3C_DeviceTypeDef *pDevice,
                                                 uint32_t           trials,
                                                 uint32_t           timeout);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static void I3C_Enable_IRQ(I3C_HandleTypeDef *hi3c, uint32_t InterruptRequest);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static void I3C_Disable_IRQ(I3C_HandleTypeDef *hi3c, uint32_t InterruptRequest);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static void I3C_ErrorTreatment(I3C_HandleTypeDef *hi3c);
#endif

#ifdef HAL_I3C_MODULE_ENABLED
static void I3C_TreatErrorCallback(I3C_HandleTypeDef *hi3c);
#endif
