#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_Init(ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_DeInit(ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
#if (USE_HAL_ETH_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_ETH_RegisterCallback(ETH_HandleTypeDef *heth, HAL_ETH_CallbackIDTypeDef CallbackID,
                                           pETH_CallbackTypeDef pCallback);
#endif
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
#if (USE_HAL_ETH_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_ETH_UnRegisterCallback(ETH_HandleTypeDef *heth, HAL_ETH_CallbackIDTypeDef CallbackID);
#endif
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_Start(ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_Start_IT(ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_Stop(ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_Stop_IT(ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_Transmit(ETH_HandleTypeDef *heth, ETH_TxPacketConfigTypeDef *pTxConfig, uint32_t Timeout);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_Transmit_IT(ETH_HandleTypeDef *heth, ETH_TxPacketConfigTypeDef *pTxConfig);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_ReadData(ETH_HandleTypeDef *heth, void **pAppBuff);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
static void ETH_UpdateDescriptor(ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_RegisterRxAllocateCallback(ETH_HandleTypeDef *heth,
                                                     pETH_rxAllocateCallbackTypeDef rxAllocateCallback);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_UnRegisterRxAllocateCallback(ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_RegisterRxLinkCallback(ETH_HandleTypeDef *heth, pETH_rxLinkCallbackTypeDef rxLinkCallback);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_UnRegisterRxLinkCallback(ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_GetRxDataErrorCode(const ETH_HandleTypeDef *heth, uint32_t *pErrorCode);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_RegisterTxFreeCallback(ETH_HandleTypeDef *heth, pETH_txFreeCallbackTypeDef txFreeCallback);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_UnRegisterTxFreeCallback(ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_ReleaseTxPacket(ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
#ifdef HAL_ETH_USE_PTP
HAL_StatusTypeDef HAL_ETH_PTP_SetConfig(ETH_HandleTypeDef *heth, ETH_PTP_ConfigTypeDef *ptpconfig);
#endif
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
#ifdef HAL_ETH_USE_PTP
HAL_StatusTypeDef HAL_ETH_PTP_GetConfig(ETH_HandleTypeDef *heth, ETH_PTP_ConfigTypeDef *ptpconfig);
#endif
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
#ifdef HAL_ETH_USE_PTP
HAL_StatusTypeDef HAL_ETH_PTP_SetTime(ETH_HandleTypeDef *heth, ETH_TimeTypeDef *time);
#endif
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
#ifdef HAL_ETH_USE_PTP
HAL_StatusTypeDef HAL_ETH_PTP_GetTime(ETH_HandleTypeDef *heth, ETH_TimeTypeDef *time);
#endif
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
#ifdef HAL_ETH_USE_PTP
HAL_StatusTypeDef HAL_ETH_PTP_AddTimeOffset(ETH_HandleTypeDef *heth, ETH_PtpUpdateTypeDef ptpoffsettype,
                                            ETH_TimeTypeDef *timeoffset);
#endif
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
#ifdef HAL_ETH_USE_PTP
static HAL_StatusTypeDef HAL_ETH_PTP_AddendUpdate(ETH_HandleTypeDef *heth, int32_t timeoffset);
#endif
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
#ifdef HAL_ETH_USE_PTP
HAL_StatusTypeDef HAL_ETH_PTP_InsertTxTimestamp(ETH_HandleTypeDef *heth);
#endif
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
#ifdef HAL_ETH_USE_PTP
HAL_StatusTypeDef HAL_ETH_PTP_GetTxTimestamp(ETH_HandleTypeDef *heth, ETH_TimeStampTypeDef *timestamp);
#endif
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
#ifdef HAL_ETH_USE_PTP
HAL_StatusTypeDef HAL_ETH_PTP_GetRxTimestamp(ETH_HandleTypeDef *heth, ETH_TimeStampTypeDef *timestamp);
#endif
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
#ifdef HAL_ETH_USE_PTP
HAL_StatusTypeDef HAL_ETH_RegisterTxPtpCallback(ETH_HandleTypeDef *heth, pETH_txPtpCallbackTypeDef txPtpCallback);
#endif
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
#ifdef HAL_ETH_USE_PTP
HAL_StatusTypeDef HAL_ETH_UnRegisterTxPtpCallback(ETH_HandleTypeDef *heth);
#endif
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETH_IRQHandler(ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_ReadPHYRegister(ETH_HandleTypeDef *heth, uint32_t PHYAddr, uint32_t PHYReg,
                                          uint32_t *pRegValue);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_WritePHYRegister(const ETH_HandleTypeDef *heth, uint32_t PHYAddr, uint32_t PHYReg,
                                           uint32_t RegValue);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_GetMACConfig(const ETH_HandleTypeDef *heth, ETH_MACConfigTypeDef *macconf);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_GetDMAConfig(const ETH_HandleTypeDef *heth, ETH_DMAConfigTypeDef *dmaconf);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_SetMACConfig(ETH_HandleTypeDef *heth,  ETH_MACConfigTypeDef *macconf);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_SetDMAConfig(ETH_HandleTypeDef *heth,  ETH_DMAConfigTypeDef *dmaconf);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETH_SetMDIOClockRange(ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_SetMACFilterConfig(ETH_HandleTypeDef *heth, const ETH_MACFilterConfigTypeDef *pFilterConfig);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_GetMACFilterConfig(const ETH_HandleTypeDef *heth, ETH_MACFilterConfigTypeDef *pFilterConfig);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_SetSourceMACAddrMatch(const ETH_HandleTypeDef *heth, uint32_t AddrNbr,
                                                const uint8_t *pMACAddr);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_SetHashTable(ETH_HandleTypeDef *heth, uint32_t *pHashTable);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETH_SetRxVLANIdentifier(ETH_HandleTypeDef *heth, uint32_t ComparisonBits, uint32_t VLANIdentifier);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETH_EnterPowerDownMode(ETH_HandleTypeDef *heth, const ETH_PowerDownConfigTypeDef *pPowerDownConfig);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETH_ExitPowerDownMode(ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETH_SetWakeUpFilter(ETH_HandleTypeDef *heth, uint32_t *pFilter, uint32_t Count);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_ETH_StateTypeDef HAL_ETH_GetState(const ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
uint32_t HAL_ETH_GetError(const ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
uint32_t HAL_ETH_GetDMAError(const ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
uint32_t HAL_ETH_GetMACError(const ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
uint32_t HAL_ETH_GetMACWakeUpSource(const ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
uint32_t HAL_ETH_GetTxBuffersNumber(const ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
static void ETH_SetMACConfig(ETH_HandleTypeDef *heth, const ETH_MACConfigTypeDef *macconf);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
static void ETH_SetDMAConfig(ETH_HandleTypeDef *heth, const ETH_DMAConfigTypeDef *dmaconf);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
static void ETH_MACDMAConfig(ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
static void ETH_DMATxDescListInit(ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
static void ETH_DMARxDescListInit(ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
static uint32_t ETH_Prepare_Tx_Descriptors(ETH_HandleTypeDef *heth, const ETH_TxPacketConfigTypeDef *pTxConfig,
                                           uint32_t ItMode);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
#if (USE_HAL_ETH_REGISTER_CALLBACKS == 1)
static void ETH_InitCallbacksToDefault(ETH_HandleTypeDef *heth);
#endif
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETHEx_EnableARPOffload(ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETHEx_DisableARPOffload(ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETHEx_SetARPAddressMatch(ETH_HandleTypeDef *heth, uint32_t IpAddress);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETHEx_SetL4FilterConfig(ETH_HandleTypeDef *heth, uint32_t Filter,
                                              const ETH_L4FilterConfigTypeDef *pL4FilterConfig);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETHEx_GetL4FilterConfig(const ETH_HandleTypeDef *heth, uint32_t Filter,
                                              ETH_L4FilterConfigTypeDef *pL4FilterConfig);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETHEx_SetL3FilterConfig(ETH_HandleTypeDef *heth, uint32_t Filter,
                                              const ETH_L3FilterConfigTypeDef *pL3FilterConfig);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETHEx_GetL3FilterConfig(const ETH_HandleTypeDef *heth, uint32_t Filter,
                                              ETH_L3FilterConfigTypeDef *pL3FilterConfig);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETHEx_EnableL3L4Filtering(ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETHEx_DisableL3L4Filtering(ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETHEx_GetRxVLANConfig(const ETH_HandleTypeDef *heth, ETH_RxVLANConfigTypeDef *pVlanConfig);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETHEx_SetRxVLANConfig(ETH_HandleTypeDef *heth, const ETH_RxVLANConfigTypeDef *pVlanConfig);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETHEx_SetVLANHashTable(ETH_HandleTypeDef *heth, uint32_t VLANHashTable);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETHEx_GetTxVLANConfig(const ETH_HandleTypeDef *heth, uint32_t VLANTag,
                                            ETH_TxVLANConfigTypeDef *pVlanConfig);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
HAL_StatusTypeDef HAL_ETHEx_SetTxVLANConfig(ETH_HandleTypeDef *heth, uint32_t VLANTag,
                                            const ETH_TxVLANConfigTypeDef *pVlanConfig);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETHEx_SetTxVLANIdentifier(ETH_HandleTypeDef *heth, uint32_t VLANTag, uint32_t VLANIdentifier);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETHEx_EnableVLANProcessing(ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETHEx_DisableVLANProcessing(ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETHEx_EnterLPIMode(ETH_HandleTypeDef *heth, FunctionalState TxAutomate, FunctionalState TxClockStop);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
void HAL_ETHEx_ExitLPIMode(ETH_HandleTypeDef *heth);
#endif
#endif

#ifdef HAL_ETH_MODULE_ENABLED
#if defined(ETH)
uint32_t HAL_ETHEx_GetMACLPIEvent(const ETH_HandleTypeDef *heth);
#endif
#endif
