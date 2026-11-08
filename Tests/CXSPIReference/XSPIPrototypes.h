#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_Init(XSPI_HandleTypeDef *hxspi);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_DeInit(XSPI_HandleTypeDef *hxspi);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
void HAL_XSPI_IRQHandler(XSPI_HandleTypeDef *hxspi);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_Command(XSPI_HandleTypeDef *hxspi, const XSPI_RegularCmdTypeDef *pCmd, uint32_t Timeout);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_Command_IT(XSPI_HandleTypeDef *hxspi, const XSPI_RegularCmdTypeDef *pCmd);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_HyperbusCfg(XSPI_HandleTypeDef *hxspi, const XSPI_HyperbusCfgTypeDef *pCfg,
                                       uint32_t Timeout);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_HyperbusCmd(XSPI_HandleTypeDef *hxspi, const XSPI_HyperbusCmdTypeDef *pCmd,
                                       uint32_t Timeout);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_Transmit(XSPI_HandleTypeDef *hxspi, const uint8_t *pData, uint32_t Timeout);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_Receive(XSPI_HandleTypeDef *hxspi, uint8_t *pData, uint32_t Timeout);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_Transmit_IT(XSPI_HandleTypeDef *hxspi, const uint8_t *pData);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_Receive_IT(XSPI_HandleTypeDef *hxspi, uint8_t *pData);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_Transmit_DMA(XSPI_HandleTypeDef *hxspi, const uint8_t *pData);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_Receive_DMA(XSPI_HandleTypeDef *hxspi, uint8_t *pData);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_AutoPolling(XSPI_HandleTypeDef *hxspi, const XSPI_AutoPollingTypeDef *pCfg,
                                       uint32_t Timeout);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_AutoPolling_IT(XSPI_HandleTypeDef *hxspi, const XSPI_AutoPollingTypeDef *pCfg);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_MemoryMapped(XSPI_HandleTypeDef *hxspi, const XSPI_MemoryMappedTypeDef *pCfg);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
uint32_t HAL_XSPI_IsMemoryMapped(XSPI_HandleTypeDef *hxspi);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
#if defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_XSPI_RegisterCallback(XSPI_HandleTypeDef *hxspi, HAL_XSPI_CallbackIDTypeDef CallbackID,
                                            pXSPI_CallbackTypeDef pCallback);
#endif
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
#if defined (USE_HAL_XSPI_REGISTER_CALLBACKS) && (USE_HAL_XSPI_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_XSPI_UnRegisterCallback(XSPI_HandleTypeDef *hxspi, HAL_XSPI_CallbackIDTypeDef CallbackID);
#endif
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_Abort(XSPI_HandleTypeDef *hxspi);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_Abort_IT(XSPI_HandleTypeDef *hxspi);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_SetFifoThreshold(XSPI_HandleTypeDef *hxspi, uint32_t Threshold);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
uint32_t HAL_XSPI_GetFifoThreshold(const XSPI_HandleTypeDef *hxspi);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_SetMemoryType(XSPI_HandleTypeDef *hxspi, uint32_t Type);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_SetDeviceSize(XSPI_HandleTypeDef *hxspi, uint32_t Size);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_SetClockPrescaler(XSPI_HandleTypeDef *hxspi, uint32_t Prescaler);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_SetTimeout(XSPI_HandleTypeDef *hxspi, uint32_t Timeout);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
uint32_t HAL_XSPI_GetError(const XSPI_HandleTypeDef *hxspi);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
uint32_t HAL_XSPI_GetState(const XSPI_HandleTypeDef *hxspi);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPIM_Config(XSPI_HandleTypeDef *hxspi, const XSPIM_CfgTypeDef *pCfg, uint32_t Timeout);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_GetDelayValue(XSPI_HandleTypeDef *hxspi, XSPI_HSCalTypeDef *pCfg);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
HAL_StatusTypeDef HAL_XSPI_SetDelayValue(XSPI_HandleTypeDef *hxspi, const XSPI_HSCalTypeDef *pCfg);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
static void XSPI_DMACplt(DMA_HandleTypeDef *hdma);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
static void XSPI_DMAHalfCplt(DMA_HandleTypeDef *hdma);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
static void XSPI_DMAError(DMA_HandleTypeDef *hdma);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
static void XSPI_DMAAbortCplt(DMA_HandleTypeDef *hdma);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
static HAL_StatusTypeDef XSPI_WaitFlagStateUntilTimeout(XSPI_HandleTypeDef *hxspi, uint32_t Flag,
                                                        FlagStatus State, uint32_t Tickstart, uint32_t Timeout);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
static HAL_StatusTypeDef XSPI_ConfigCmd(XSPI_HandleTypeDef *hxspi, const XSPI_RegularCmdTypeDef *pCmd);
#endif
#endif

#if defined(XSPI) || defined(XSPI1) || defined(XSPI2)
#ifdef HAL_XSPI_MODULE_ENABLED
static void XSPIM_GetConfig(uint8_t instance_nb, XSPIM_CfgTypeDef *pCfg);
#endif
#endif
