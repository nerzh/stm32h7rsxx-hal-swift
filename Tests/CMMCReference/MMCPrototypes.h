#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_Init(MMC_HandleTypeDef *hmmc);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_InitCard(MMC_HandleTypeDef *hmmc);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_DeInit(MMC_HandleTypeDef *hmmc);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_ReadBlocks(MMC_HandleTypeDef *hmmc, uint8_t *pData, uint32_t BlockAdd,
                                     uint32_t NumberOfBlocks,
                                     uint32_t Timeout);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_WriteBlocks(MMC_HandleTypeDef *hmmc, const uint8_t *pData, uint32_t BlockAdd,
                                      uint32_t NumberOfBlocks, uint32_t Timeout);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_ReadBlocks_IT(MMC_HandleTypeDef *hmmc, uint8_t *pData, uint32_t BlockAdd,
                                        uint32_t NumberOfBlocks);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_WriteBlocks_IT(MMC_HandleTypeDef *hmmc, const uint8_t *pData,
                                         uint32_t BlockAdd, uint32_t NumberOfBlocks);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_ReadBlocks_DMA(MMC_HandleTypeDef *hmmc, uint8_t *pData, uint32_t BlockAdd,
                                         uint32_t NumberOfBlocks);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_WriteBlocks_DMA(MMC_HandleTypeDef *hmmc, const uint8_t *pData,
                                          uint32_t BlockAdd, uint32_t NumberOfBlocks);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_Erase(MMC_HandleTypeDef *hmmc, uint32_t BlockStartAdd, uint32_t BlockEndAdd);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
void HAL_MMC_IRQHandler(MMC_HandleTypeDef *hmmc);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_MMC_StateTypeDef HAL_MMC_GetState(const MMC_HandleTypeDef *hmmc);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
uint32_t HAL_MMC_GetError(const MMC_HandleTypeDef *hmmc);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
#if defined (USE_HAL_MMC_REGISTER_CALLBACKS) && (USE_HAL_MMC_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_MMC_RegisterCallback(MMC_HandleTypeDef *hmmc, HAL_MMC_CallbackIDTypeDef CallbackId,
                                           pMMC_CallbackTypeDef pCallback);
#endif
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
#if defined (USE_HAL_MMC_REGISTER_CALLBACKS) && (USE_HAL_MMC_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_MMC_UnRegisterCallback(MMC_HandleTypeDef *hmmc, HAL_MMC_CallbackIDTypeDef CallbackId);
#endif
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_GetCardCID(const MMC_HandleTypeDef *hmmc, HAL_MMC_CardCIDTypeDef *pCID);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_GetCardCSD(MMC_HandleTypeDef *hmmc, HAL_MMC_CardCSDTypeDef *pCSD);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_GetCardInfo(const MMC_HandleTypeDef *hmmc, HAL_MMC_CardInfoTypeDef *pCardInfo);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_GetCardExtCSD(MMC_HandleTypeDef *hmmc, uint32_t *pExtCSD, uint32_t Timeout);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_ConfigWideBusOperation(MMC_HandleTypeDef *hmmc, uint32_t WideMode);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_ConfigSpeedBusOperation(MMC_HandleTypeDef *hmmc, uint32_t SpeedMode);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_MMC_CardStateTypeDef HAL_MMC_GetCardState(MMC_HandleTypeDef *hmmc);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_Abort(MMC_HandleTypeDef *hmmc);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_Abort_IT(MMC_HandleTypeDef *hmmc);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_EraseSequence(MMC_HandleTypeDef *hmmc, uint32_t EraseType,
                                        uint32_t BlockStartAdd, uint32_t BlockEndAdd);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_Sanitize(MMC_HandleTypeDef *hmmc);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_ConfigSecRemovalType(MMC_HandleTypeDef *hmmc, uint32_t SRTMode);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_GetSupportedSecRemovalType(MMC_HandleTypeDef *hmmc, uint32_t *SupportedSRT);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_SleepDevice(MMC_HandleTypeDef *hmmc);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_AwakeDevice(MMC_HandleTypeDef *hmmc);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
static uint32_t MMC_InitCard(MMC_HandleTypeDef *hmmc);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
static uint32_t MMC_PowerON(MMC_HandleTypeDef *hmmc);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
static void MMC_PowerOFF(MMC_HandleTypeDef *hmmc);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
static uint32_t MMC_SendStatus(MMC_HandleTypeDef *hmmc, uint32_t *pCardStatus);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
static HAL_StatusTypeDef MMC_ReadExtCSD(MMC_HandleTypeDef *hmmc, uint32_t *pFieldData,
                                        uint16_t FieldIndex, uint32_t Timeout);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
static void MMC_Read_IT(MMC_HandleTypeDef *hmmc);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
static void MMC_Write_IT(MMC_HandleTypeDef *hmmc);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
static uint32_t MMC_HighSpeed(MMC_HandleTypeDef *hmmc, FunctionalState state);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
static uint32_t MMC_DDR_Mode(MMC_HandleTypeDef *hmmc, FunctionalState state);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
static uint32_t MMC_PwrClassUpdate(MMC_HandleTypeDef *hmmc, uint32_t Wide, uint32_t Speed);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_SwitchPartition(MMC_HandleTypeDef *hmmc, HAL_MMC_PartitionTypeDef Partition);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_RPMB_ProgramAuthenticationKey(MMC_HandleTypeDef *hmmc, const uint8_t *pKey, uint32_t Timeout);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
uint32_t HAL_MMC_RPMB_GetWriteCounter(MMC_HandleTypeDef *hmmc, uint8_t *pNonce, uint32_t Timeout);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_RPMB_WriteBlocks(MMC_HandleTypeDef *hmmc, const uint8_t *pData, uint16_t BlockAdd,
                                           uint16_t NumberOfBlocks, const uint8_t *pMAC, uint32_t Timeout);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMC_RPMB_ReadBlocks(MMC_HandleTypeDef *hmmc, uint8_t *pData, uint16_t BlockAdd,
                                          uint16_t NumberOfBlocks, const uint8_t *pNonce, uint8_t *pMAC,
                                          uint32_t Timeout);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMCEx_DMALinkedList_BuildNode(MMC_DMALinkNodeTypeDef *pNode,
                                                    MMC_DMALinkNodeConfTypeDef *pNodeConf);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMCEx_DMALinkedList_InsertNode(MMC_DMALinkedListTypeDef *pLinkedList,
                                                     MMC_DMALinkNodeTypeDef *pPrevNode,
                                                     MMC_DMALinkNodeTypeDef *pNewNode);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMCEx_DMALinkedList_RemoveNode(MMC_DMALinkedListTypeDef *pLinkedList,
                                                     MMC_DMALinkNodeTypeDef *pNode);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMCEx_DMALinkedList_LockNode(MMC_DMALinkNodeTypeDef *pNode);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMCEx_DMALinkedList_UnlockNode(MMC_DMALinkNodeTypeDef *pNode);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMCEx_DMALinkedList_EnableCircularMode(MMC_DMALinkedListTypeDef *pLinkedList);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMCEx_DMALinkedList_DisableCircularMode(MMC_DMALinkedListTypeDef *pLinkedList);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMCEx_DMALinkedList_ReadBlocks(MMC_HandleTypeDef *hmmc,
                                                     const MMC_DMALinkedListTypeDef *pLinkedList,
                                                     uint32_t BlockAdd, uint32_t NumberOfBlocks);
#endif
#endif

#if defined (SDMMC1) || defined (SDMMC2)
#ifdef HAL_MMC_MODULE_ENABLED
HAL_StatusTypeDef HAL_MMCEx_DMALinkedList_WriteBlocks(MMC_HandleTypeDef *hmmc,
                                                      const MMC_DMALinkedListTypeDef *pLinkedList,
                                                      uint32_t BlockAdd, uint32_t NumberOfBlocks);
#endif
#endif
