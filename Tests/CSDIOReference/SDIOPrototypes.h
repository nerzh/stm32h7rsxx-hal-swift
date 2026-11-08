#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDIO_Init(SDIO_HandleTypeDef *hsdio);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDIO_DeInit(SDIO_HandleTypeDef *hsdio);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDIO_SetDataBusWidth(SDIO_HandleTypeDef *hsdio, uint32_t BusWide);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDIO_ConfigFrequency(SDIO_HandleTypeDef *hsdio, uint32_t ClockSpeed);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDIO_SetBlockSize(SDIO_HandleTypeDef *hsdio, uint8_t function_nbr, uint16_t BlockSize);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDIO_SetSpeedMode(SDIO_HandleTypeDef *hsdio, uint32_t DataRate);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDIO_CardReset(SDIO_HandleTypeDef *hsdio);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDIO_GetCardCommonControlRegister(SDIO_HandleTypeDef *hsdio, HAL_SDIO_CCCR_TypeDef *pCccr);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDIO_GetCardFBRRegister(SDIO_HandleTypeDef *hsdio, HAL_SDIO_FBR_t *pFbr);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDIO_ReadDirect(SDIO_HandleTypeDef *hsdio, const HAL_SDIO_DirectCmd_TypeDef *Argument,
                                      uint8_t *pData);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDIO_WriteDirect(SDIO_HandleTypeDef *hsdio, const HAL_SDIO_DirectCmd_TypeDef *Argument,
                                       uint8_t Data);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDIO_ReadExtended(SDIO_HandleTypeDef *hsdio, const HAL_SDIO_ExtendedCmd_TypeDef *Argument,
                                        uint8_t *pData, uint32_t Size_byte, uint32_t Timeout_Ms);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDIO_WriteExtended(SDIO_HandleTypeDef *hsdio, const HAL_SDIO_ExtendedCmd_TypeDef *Argument,
                                         uint8_t *pData, uint32_t Size_byte, uint32_t Timeout_Ms);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDIO_ReadExtended_DMA(SDIO_HandleTypeDef *hsdio, const HAL_SDIO_ExtendedCmd_TypeDef *Argument,
                                            uint8_t *pData, uint32_t Size_byte);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDIO_WriteExtended_DMA(SDIO_HandleTypeDef *hsdio, const HAL_SDIO_ExtendedCmd_TypeDef *Argument,
                                             uint8_t *pData, uint32_t Size_byte);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
void HAL_SDIO_IRQHandler(SDIO_HandleTypeDef *hsdio);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
#if defined (USE_HAL_SDIO_REGISTER_CALLBACKS) && (USE_HAL_SDIO_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_SDIO_RegisterCallback(SDIO_HandleTypeDef *hsdio, HAL_SDIO_CallbackIDTypeDef CallbackID,
                                            pSDIO_CallbackTypeDef pCallback);
#endif
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
#if defined (USE_HAL_SDIO_REGISTER_CALLBACKS) && (USE_HAL_SDIO_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_SDIO_UnRegisterCallback(SDIO_HandleTypeDef *hsdio, HAL_SDIO_CallbackIDTypeDef CallbackID);
#endif
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
#if (USE_SDIO_TRANSCEIVER != 0U)
HAL_StatusTypeDef HAL_SDIO_RegisterTransceiverCallback(SDIO_HandleTypeDef *hsdio,
                                                       pSDIO_TransceiverCallbackTypeDef pCallback);
#endif
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
#if (USE_SDIO_TRANSCEIVER != 0U)
HAL_StatusTypeDef HAL_SDIO_UnRegisterTransceiverCallback(SDIO_HandleTypeDef *hsdio);
#endif
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDIO_RegisterIdentifyCardCallback(SDIO_HandleTypeDef *hsdio,
                                                        pSDIO_IdentifyCardCallbackTypeDef pCallback);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
HAL_SDIO_StateTypeDef HAL_SDIO_GetState(const SDIO_HandleTypeDef *hsdio);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
uint32_t HAL_SDIO_GetError(const SDIO_HandleTypeDef *hsdio);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDIO_EnableIOFunctionInterrupt(SDIO_HandleTypeDef *hsdio, uint32_t IOFunction);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDIO_DisableIOFunctionInterrupt(SDIO_HandleTypeDef *hsdio, uint32_t IOFunction);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDIO_EnableIOFunction(SDIO_HandleTypeDef *hsdio, uint32_t IOFunction);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDIO_DisableIOFunction(SDIO_HandleTypeDef *hsdio, uint32_t IOFunction);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDIO_SelectIOFunction(SDIO_HandleTypeDef *hsdio, uint32_t IOFunction);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDIO_AbortIOFunction(SDIO_HandleTypeDef *hsdio, uint32_t IOFunction);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDIO_EnableIOAsynInterrupt(SDIO_HandleTypeDef *hsdio);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDIO_DisableIOAsynInterrupt(SDIO_HandleTypeDef *hsdio);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDIO_RegisterIOFunctionCallback(SDIO_HandleTypeDef *hsdio, uint32_t IOFunction,
                                                      HAL_SDIO_IOFunction_CallbackTypeDef pCallback);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
static HAL_StatusTypeDef SDIO_InitCard(SDIO_HandleTypeDef *hsdio);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
static HAL_StatusTypeDef SDIO_ReadDirect(SDIO_HandleTypeDef *hsdio, uint32_t addr, uint32_t raw,
                                         uint32_t function_nbr, uint8_t *pData);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
static HAL_StatusTypeDef SDIO_WriteDirect(SDIO_HandleTypeDef *hsdio, uint32_t addr, uint32_t raw,
                                          uint32_t function_nbr, const uint8_t *pData);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
static HAL_StatusTypeDef SDIO_WriteExtended(SDIO_HandleTypeDef *hsdio, const HAL_SDIO_ExtendedCmd_TypeDef *cmd_arg,
                                            uint8_t *pData, uint16_t Size_byte);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
static uint8_t SDIO_Convert_Block_Size(const SDIO_HandleTypeDef *hsdio, uint32_t block_size);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SDIO_MODULE_ENABLED
static HAL_StatusTypeDef SDIO_IOFunction_IRQHandler(SDIO_HandleTypeDef *hsdio);
#endif
#endif
