#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Base_Init(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Base_DeInit(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Base_Start(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Base_Stop(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Base_Start_IT(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Base_Stop_IT(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Base_Start_DMA(TIM_HandleTypeDef *htim, const uint32_t *pData, uint16_t Length);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Base_Stop_DMA(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OC_Init(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OC_DeInit(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OC_Start(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OC_Stop(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OC_Start_IT(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OC_Stop_IT(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OC_Start_DMA(TIM_HandleTypeDef *htim, uint32_t Channel, const uint32_t *pData,
                                       uint16_t Length);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OC_Stop_DMA(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_PWM_Init(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_PWM_DeInit(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_PWM_Start(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_PWM_Stop(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_PWM_Start_IT(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_PWM_Stop_IT(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_PWM_Start_DMA(TIM_HandleTypeDef *htim, uint32_t Channel, const uint32_t *pData,
                                        uint16_t Length);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_PWM_Stop_DMA(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_IC_Init(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_IC_DeInit(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_IC_Start(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_IC_Stop(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_IC_Start_IT(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_IC_Stop_IT(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_IC_Start_DMA(TIM_HandleTypeDef *htim, uint32_t Channel, uint32_t *pData, uint16_t Length);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_IC_Stop_DMA(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OnePulse_Init(TIM_HandleTypeDef *htim, uint32_t OnePulseMode);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OnePulse_DeInit(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OnePulse_Start(TIM_HandleTypeDef *htim, uint32_t OutputChannel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OnePulse_Stop(TIM_HandleTypeDef *htim, uint32_t OutputChannel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OnePulse_Start_IT(TIM_HandleTypeDef *htim, uint32_t OutputChannel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OnePulse_Stop_IT(TIM_HandleTypeDef *htim, uint32_t OutputChannel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Encoder_Init(TIM_HandleTypeDef *htim, const TIM_Encoder_InitTypeDef *sConfig);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Encoder_DeInit(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Encoder_Start(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Encoder_Stop(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Encoder_Start_IT(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Encoder_Stop_IT(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Encoder_Start_DMA(TIM_HandleTypeDef *htim, uint32_t Channel, uint32_t *pData1,
                                            uint32_t *pData2, uint16_t Length);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_Encoder_Stop_DMA(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
void HAL_TIM_IRQHandler(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OC_ConfigChannel(TIM_HandleTypeDef *htim,
                                           const TIM_OC_InitTypeDef *sConfig,
                                           uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_IC_ConfigChannel(TIM_HandleTypeDef *htim, const TIM_IC_InitTypeDef *sConfig, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_PWM_ConfigChannel(TIM_HandleTypeDef *htim,
                                            const TIM_OC_InitTypeDef *sConfig,
                                            uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_OnePulse_ConfigChannel(TIM_HandleTypeDef *htim,  TIM_OnePulse_InitTypeDef *sConfig,
                                                 uint32_t OutputChannel,  uint32_t InputChannel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_DMABurst_WriteStart(TIM_HandleTypeDef *htim, uint32_t BurstBaseAddress,
                                              uint32_t BurstRequestSrc, const uint32_t *BurstBuffer,
                                              uint32_t  BurstLength);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_DMABurst_MultiWriteStart(TIM_HandleTypeDef *htim, uint32_t BurstBaseAddress,
                                                   uint32_t BurstRequestSrc, const uint32_t *BurstBuffer,
                                                   uint32_t  BurstLength,  uint32_t  DataLength);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_DMABurst_WriteStop(TIM_HandleTypeDef *htim, uint32_t BurstRequestSrc);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_DMABurst_ReadStart(TIM_HandleTypeDef *htim, uint32_t BurstBaseAddress,
                                             uint32_t BurstRequestSrc, uint32_t  *BurstBuffer, uint32_t  BurstLength);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_DMABurst_MultiReadStart(TIM_HandleTypeDef *htim, uint32_t BurstBaseAddress,
                                                  uint32_t BurstRequestSrc, uint32_t  *BurstBuffer,
                                                  uint32_t  BurstLength, uint32_t  DataLength);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_DMABurst_ReadStop(TIM_HandleTypeDef *htim, uint32_t BurstRequestSrc);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_GenerateEvent(TIM_HandleTypeDef *htim, uint32_t EventSource);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_ConfigOCrefClear(TIM_HandleTypeDef *htim,
                                           const TIM_ClearInputConfigTypeDef *sClearInputConfig,
                                           uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_ConfigClockSource(TIM_HandleTypeDef *htim, const TIM_ClockConfigTypeDef *sClockSourceConfig);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_ConfigTI1Input(TIM_HandleTypeDef *htim, uint32_t TI1_Selection);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_SlaveConfigSynchro(TIM_HandleTypeDef *htim, const TIM_SlaveConfigTypeDef *sSlaveConfig);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIM_SlaveConfigSynchro_IT(TIM_HandleTypeDef *htim,
                                                const TIM_SlaveConfigTypeDef *sSlaveConfig);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
uint32_t HAL_TIM_ReadCapturedValue(const TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef TIM_DMA_Start_IT(DMA_HandleTypeDef *hdma, uint32_t src, uint32_t dst,
                                   uint32_t length);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_TIM_RegisterCallback(TIM_HandleTypeDef *htim, HAL_TIM_CallbackIDTypeDef CallbackID,
                                           pTIM_CallbackTypeDef pCallback);
#endif
#endif

#ifdef HAL_TIM_MODULE_ENABLED
#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
HAL_StatusTypeDef HAL_TIM_UnRegisterCallback(TIM_HandleTypeDef *htim, HAL_TIM_CallbackIDTypeDef CallbackID);
#endif
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_TIM_StateTypeDef HAL_TIM_Base_GetState(const TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_TIM_StateTypeDef HAL_TIM_OC_GetState(const TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_TIM_StateTypeDef HAL_TIM_PWM_GetState(const TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_TIM_StateTypeDef HAL_TIM_IC_GetState(const TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_TIM_StateTypeDef HAL_TIM_OnePulse_GetState(const TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_TIM_StateTypeDef HAL_TIM_Encoder_GetState(const TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_TIM_ActiveChannel HAL_TIM_GetActiveChannel(const TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_TIM_ChannelStateTypeDef HAL_TIM_GetChannelState(const TIM_HandleTypeDef *htim,  uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_TIM_DMABurstStateTypeDef HAL_TIM_DMABurstState(const TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
void TIM_DMAError(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_DMADelayPulseCplt(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
void TIM_DMADelayPulseHalfCplt(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
void TIM_DMACaptureCplt(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
void TIM_DMACaptureHalfCplt(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_DMAPeriodElapsedCplt(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_DMAPeriodElapsedHalfCplt(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_DMATriggerCplt(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_DMATriggerHalfCplt(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
void TIM_Base_SetConfig(TIM_TypeDef *TIMx, const TIM_Base_InitTypeDef *Structure);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_OC1_SetConfig(TIM_TypeDef *TIMx, const TIM_OC_InitTypeDef *OC_Config);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
void TIM_OC2_SetConfig(TIM_TypeDef *TIMx, const TIM_OC_InitTypeDef *OC_Config);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_OC3_SetConfig(TIM_TypeDef *TIMx, const TIM_OC_InitTypeDef *OC_Config);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_OC4_SetConfig(TIM_TypeDef *TIMx, const TIM_OC_InitTypeDef *OC_Config);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_OC5_SetConfig(TIM_TypeDef *TIMx,
                              const TIM_OC_InitTypeDef *OC_Config);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_OC6_SetConfig(TIM_TypeDef *TIMx,
                              const TIM_OC_InitTypeDef *OC_Config);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static HAL_StatusTypeDef TIM_SlaveTimer_SetConfig(TIM_HandleTypeDef *htim,
                                                  const TIM_SlaveConfigTypeDef *sSlaveConfig);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
void TIM_TI1_SetConfig(TIM_TypeDef *TIMx, uint32_t TIM_ICPolarity, uint32_t TIM_ICSelection,
                       uint32_t TIM_ICFilter);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_TI1_ConfigInputStage(TIM_TypeDef *TIMx, uint32_t TIM_ICPolarity, uint32_t TIM_ICFilter);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_TI2_SetConfig(TIM_TypeDef *TIMx, uint32_t TIM_ICPolarity, uint32_t TIM_ICSelection,
                              uint32_t TIM_ICFilter);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_TI2_ConfigInputStage(TIM_TypeDef *TIMx, uint32_t TIM_ICPolarity, uint32_t TIM_ICFilter);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_TI3_SetConfig(TIM_TypeDef *TIMx, uint32_t TIM_ICPolarity, uint32_t TIM_ICSelection,
                              uint32_t TIM_ICFilter);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_TI4_SetConfig(TIM_TypeDef *TIMx, uint32_t TIM_ICPolarity, uint32_t TIM_ICSelection,
                              uint32_t TIM_ICFilter);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_ITRx_SetConfig(TIM_TypeDef *TIMx, uint32_t InputTriggerSource);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
void TIM_ETR_SetConfig(TIM_TypeDef *TIMx, uint32_t TIM_ExtTRGPrescaler,
                       uint32_t TIM_ExtTRGPolarity, uint32_t ExtTRGFilter);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
void TIM_CCxChannelCmd(TIM_TypeDef *TIMx, uint32_t Channel, uint32_t ChannelState);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
#if (USE_HAL_TIM_REGISTER_CALLBACKS == 1)
void TIM_ResetCallback(TIM_HandleTypeDef *htim);
#endif
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_HallSensor_Init(TIM_HandleTypeDef *htim, const TIM_HallSensor_InitTypeDef *sConfig);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_HallSensor_DeInit(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_HallSensor_Start(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_HallSensor_Stop(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_HallSensor_Start_IT(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_HallSensor_Stop_IT(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_HallSensor_Start_DMA(TIM_HandleTypeDef *htim, uint32_t *pData, uint16_t Length);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_HallSensor_Stop_DMA(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_OCN_Start(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_OCN_Stop(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_OCN_Start_IT(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_OCN_Stop_IT(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_OCN_Start_DMA(TIM_HandleTypeDef *htim, uint32_t Channel, const uint32_t *pData,
                                          uint16_t Length);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_OCN_Stop_DMA(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_PWMN_Start(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_PWMN_Stop(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_PWMN_Start_IT(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_PWMN_Stop_IT(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_PWMN_Start_DMA(TIM_HandleTypeDef *htim, uint32_t Channel, const uint32_t *pData,
                                           uint16_t Length);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_PWMN_Stop_DMA(TIM_HandleTypeDef *htim, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_OnePulseN_Start(TIM_HandleTypeDef *htim, uint32_t OutputChannel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_OnePulseN_Stop(TIM_HandleTypeDef *htim, uint32_t OutputChannel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_OnePulseN_Start_IT(TIM_HandleTypeDef *htim, uint32_t OutputChannel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_OnePulseN_Stop_IT(TIM_HandleTypeDef *htim, uint32_t OutputChannel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_ConfigCommutEvent(TIM_HandleTypeDef *htim, uint32_t  InputTrigger,
                                              uint32_t  CommutationSource);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_ConfigCommutEvent_IT(TIM_HandleTypeDef *htim, uint32_t  InputTrigger,
                                                 uint32_t  CommutationSource);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_ConfigCommutEvent_DMA(TIM_HandleTypeDef *htim, uint32_t  InputTrigger,
                                                  uint32_t  CommutationSource);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_MasterConfigSynchronization(TIM_HandleTypeDef *htim,
                                                        const TIM_MasterConfigTypeDef *sMasterConfig);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_ConfigBreakDeadTime(TIM_HandleTypeDef *htim,
                                                const TIM_BreakDeadTimeConfigTypeDef *sBreakDeadTimeConfig);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_ConfigBreakInput(TIM_HandleTypeDef *htim,
                                             uint32_t BreakInput,
                                             const TIMEx_BreakInputConfigTypeDef *sBreakInputConfig);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_RemapConfig(TIM_HandleTypeDef *htim, uint32_t Remap);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef  HAL_TIMEx_TISelection(TIM_HandleTypeDef *htim, uint32_t TISelection, uint32_t Channel);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_GroupChannel5(TIM_HandleTypeDef *htim, uint32_t Channels);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_DisarmBreakInput(TIM_HandleTypeDef *htim, uint32_t BreakInput);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_ReArmBreakInput(const TIM_HandleTypeDef *htim, uint32_t BreakInput);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_DitheringEnable(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_DitheringDisable(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_OC_ConfigPulseOnCompare(TIM_HandleTypeDef *htim,
                                                    uint32_t PulseWidthPrescaler,
                                                    uint32_t PulseWidth);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_ConfigSlaveModePreload(TIM_HandleTypeDef *htim, uint32_t Source);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_EnableSlaveModePreload(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_DisableSlaveModePreload(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_EnableDeadTimePreload(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_DisableDeadTimePreload(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_ConfigDeadTime(TIM_HandleTypeDef *htim, uint32_t Deadtime);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_ConfigAsymmetricalDeadTime(TIM_HandleTypeDef *htim, uint32_t FallingDeadtime);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_EnableAsymmetricalDeadTime(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_DisableAsymmetricalDeadTime(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_ConfigEncoderIndex(TIM_HandleTypeDef *htim,
                                               TIMEx_EncoderIndexConfigTypeDef *sEncoderIndexConfig);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_EnableEncoderIndex(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_DisableEncoderIndex(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_EnableEncoderFirstIndex(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_StatusTypeDef HAL_TIMEx_DisableEncoderFirstIndex(TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_TIM_StateTypeDef HAL_TIMEx_HallSensor_GetState(const TIM_HandleTypeDef *htim);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
HAL_TIM_ChannelStateTypeDef HAL_TIMEx_GetChannelNState(const TIM_HandleTypeDef *htim,  uint32_t ChannelN);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
void TIMEx_DMACommutationCplt(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
void TIMEx_DMACommutationHalfCplt(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_DMADelayPulseNCplt(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_DMAErrorCCxN(DMA_HandleTypeDef *hdma);
#endif

#ifdef HAL_TIM_MODULE_ENABLED
static void TIM_CCxNChannelCmd(TIM_TypeDef *TIMx, uint32_t Channel, uint32_t ChannelNState);
#endif
