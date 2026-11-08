#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_Init(SD_HandleTypeDef *hsd);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_InitCard(SD_HandleTypeDef *hsd);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_DeInit(SD_HandleTypeDef *hsd);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_ReadBlocks(SD_HandleTypeDef *hsd, uint8_t *pData, uint32_t BlockAdd, uint32_t NumberOfBlocks,
                                    uint32_t Timeout);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_WriteBlocks(SD_HandleTypeDef *hsd, const uint8_t *pData, uint32_t BlockAdd,
                                     uint32_t NumberOfBlocks, uint32_t Timeout);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_ReadBlocks_IT(SD_HandleTypeDef *hsd, uint8_t *pData, uint32_t BlockAdd,
                                       uint32_t NumberOfBlocks);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_WriteBlocks_IT(SD_HandleTypeDef *hsd, const uint8_t *pData, uint32_t BlockAdd,
                                        uint32_t NumberOfBlocks);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_ReadBlocks_DMA(SD_HandleTypeDef *hsd, uint8_t *pData, uint32_t BlockAdd,
                                        uint32_t NumberOfBlocks);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_WriteBlocks_DMA(SD_HandleTypeDef *hsd, const uint8_t *pData, uint32_t BlockAdd,
                                         uint32_t NumberOfBlocks);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_Erase(SD_HandleTypeDef *hsd, uint32_t BlockStartAdd, uint32_t BlockEndAdd);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
void HAL_SD_IRQHandler(SD_HandleTypeDef *hsd);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_SD_StateTypeDef HAL_SD_GetState(const SD_HandleTypeDef *hsd);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
uint32_t HAL_SD_GetError(const SD_HandleTypeDef *hsd);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
#if defined (USE_HAL_SD_REGISTER_CALLBACKS) && (USE_HAL_SD_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_SD_RegisterCallback(SD_HandleTypeDef *hsd, HAL_SD_CallbackIDTypeDef CallbackID,
                                          pSD_CallbackTypeDef pCallback);
#endif
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
#if defined (USE_HAL_SD_REGISTER_CALLBACKS) && (USE_HAL_SD_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_SD_UnRegisterCallback(SD_HandleTypeDef *hsd, HAL_SD_CallbackIDTypeDef CallbackID);
#endif
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
#if defined (USE_HAL_SD_REGISTER_CALLBACKS) && (USE_HAL_SD_REGISTER_CALLBACKS == 1U)
#if (USE_SD_TRANSCEIVER != 0U)
HAL_StatusTypeDef HAL_SD_RegisterTransceiverCallback(SD_HandleTypeDef *hsd, pSD_TransceiverCallbackTypeDef pCallback);
#endif
#endif
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
#if defined (USE_HAL_SD_REGISTER_CALLBACKS) && (USE_HAL_SD_REGISTER_CALLBACKS == 1U)
#if (USE_SD_TRANSCEIVER != 0U)
HAL_StatusTypeDef HAL_SD_UnRegisterTransceiverCallback(SD_HandleTypeDef *hsd);
#endif
#endif
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_GetCardCID(const SD_HandleTypeDef *hsd, HAL_SD_CardCIDTypeDef *pCID);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_GetCardCSD(SD_HandleTypeDef *hsd, HAL_SD_CardCSDTypeDef *pCSD);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_GetCardStatus(SD_HandleTypeDef *hsd, HAL_SD_CardStatusTypeDef *pStatus);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_GetCardInfo(const SD_HandleTypeDef *hsd, HAL_SD_CardInfoTypeDef *pCardInfo);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_ConfigWideBusOperation(SD_HandleTypeDef *hsd, uint32_t WideMode);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_ConfigSpeedBusOperation(SD_HandleTypeDef *hsd, uint32_t SpeedMode);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_SD_CardStateTypeDef HAL_SD_GetCardState(SD_HandleTypeDef *hsd);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_Abort(SD_HandleTypeDef *hsd);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SD_Abort_IT(SD_HandleTypeDef *hsd);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
static uint32_t SD_InitCard(SD_HandleTypeDef *hsd);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
static uint32_t SD_PowerON(SD_HandleTypeDef *hsd);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
static void SD_PowerOFF(SD_HandleTypeDef *hsd);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
static uint32_t SD_SendSDStatus(SD_HandleTypeDef *hsd, uint32_t *pSDstatus);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
static uint32_t SD_SendStatus(SD_HandleTypeDef *hsd, uint32_t *pCardStatus);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
static uint32_t SD_WideBus_Enable(SD_HandleTypeDef *hsd);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
static uint32_t SD_WideBus_Disable(SD_HandleTypeDef *hsd);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
static uint32_t SD_FindSCR(SD_HandleTypeDef *hsd, uint32_t *pSCR);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
static void SD_Read_IT(SD_HandleTypeDef *hsd);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
static void SD_Write_IT(SD_HandleTypeDef *hsd);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
uint32_t SD_SwitchSpeed(SD_HandleTypeDef *hsd, uint32_t SwitchSpeedMode);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
#if (USE_SD_TRANSCEIVER != 0U)
static uint32_t SD_UltraHighSpeed(SD_HandleTypeDef *hsd, uint32_t UltraHighSpeedMode);
#endif
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
#if (USE_SD_TRANSCEIVER != 0U)
static uint32_t SD_DDR_Mode(SD_HandleTypeDef *hsd);
#endif
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDEx_DMALinkedList_BuildNode(SD_DMALinkNodeTypeDef *pNode, SD_DMALinkNodeConfTypeDef *pNodeConf);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDEx_DMALinkedList_InsertNode(SD_DMALinkedListTypeDef *pLinkedList,
                                                    SD_DMALinkNodeTypeDef *pPrevNode, SD_DMALinkNodeTypeDef *pNewNode);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDEx_DMALinkedList_RemoveNode(SD_DMALinkedListTypeDef *pLinkedList, SD_DMALinkNodeTypeDef *pNode);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDEx_DMALinkedList_LockNode(SD_DMALinkNodeTypeDef *pNode);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDEx_DMALinkedList_UnlockNode(SD_DMALinkNodeTypeDef *pNode);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDEx_DMALinkedList_EnableCircularMode(SD_DMALinkedListTypeDef *pLinkedList);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDEx_DMALinkedList_DisableCircularMode(SD_DMALinkedListTypeDef *pLinkedList);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDEx_DMALinkedList_ReadBlocks(SD_HandleTypeDef *hsd,
                                                    const SDMMC_DMALinkedListTypeDef *pLinkedList,
                                                    uint32_t BlockAdd, uint32_t NumberOfBlocks);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_SD_MODULE_ENABLED
HAL_StatusTypeDef HAL_SDEx_DMALinkedList_WriteBlocks(SD_HandleTypeDef *hsd,
                                                     const SDMMC_DMALinkedListTypeDef *pLinkedList,
                                                     uint32_t BlockAdd, uint32_t NumberOfBlocks);
#endif
#endif
