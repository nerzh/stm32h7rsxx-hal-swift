HAL_StatusTypeDef  HAL_NAND_Init(NAND_HandleTypeDef *hnand, FMC_NAND_PCC_TimingTypeDef *ComSpace_Timing,
                                 FMC_NAND_PCC_TimingTypeDef *AttSpace_Timing);

HAL_StatusTypeDef HAL_NAND_DeInit(NAND_HandleTypeDef *hnand);

void HAL_NAND_IRQHandler(NAND_HandleTypeDef *hnand);

HAL_StatusTypeDef HAL_NAND_Read_ID(NAND_HandleTypeDef *hnand, NAND_IDTypeDef *pNAND_ID);

HAL_StatusTypeDef HAL_NAND_Reset(NAND_HandleTypeDef *hnand);

HAL_StatusTypeDef  HAL_NAND_ConfigDevice(NAND_HandleTypeDef *hnand, const NAND_DeviceConfigTypeDef *pDeviceConfig);

HAL_StatusTypeDef HAL_NAND_Read_Page_8b(NAND_HandleTypeDef *hnand, const NAND_AddressTypeDef *pAddress,
                                        uint8_t *pBuffer, uint32_t NumPageToRead);

HAL_StatusTypeDef HAL_NAND_Read_Page_16b(NAND_HandleTypeDef *hnand, const NAND_AddressTypeDef *pAddress,
                                         uint16_t *pBuffer, uint32_t NumPageToRead);

HAL_StatusTypeDef HAL_NAND_Write_Page_8b(NAND_HandleTypeDef *hnand, const NAND_AddressTypeDef *pAddress,
                                         const uint8_t *pBuffer, uint32_t NumPageToWrite);

HAL_StatusTypeDef HAL_NAND_Write_Page_16b(NAND_HandleTypeDef *hnand, const NAND_AddressTypeDef *pAddress,
                                          const uint16_t *pBuffer, uint32_t NumPageToWrite);

HAL_StatusTypeDef HAL_NAND_Read_SpareArea_8b(NAND_HandleTypeDef *hnand, const NAND_AddressTypeDef *pAddress,
                                             uint8_t *pBuffer, uint32_t NumSpareAreaToRead);

HAL_StatusTypeDef HAL_NAND_Read_SpareArea_16b(NAND_HandleTypeDef *hnand, const NAND_AddressTypeDef *pAddress,
                                              uint16_t *pBuffer, uint32_t NumSpareAreaToRead);

HAL_StatusTypeDef HAL_NAND_Write_SpareArea_8b(NAND_HandleTypeDef *hnand, const NAND_AddressTypeDef *pAddress,
                                              const uint8_t *pBuffer, uint32_t NumSpareAreaTowrite);

HAL_StatusTypeDef HAL_NAND_Write_SpareArea_16b(NAND_HandleTypeDef *hnand, const NAND_AddressTypeDef *pAddress,
                                               const uint16_t *pBuffer, uint32_t NumSpareAreaTowrite);

HAL_StatusTypeDef HAL_NAND_Erase_Block(NAND_HandleTypeDef *hnand, const NAND_AddressTypeDef *pAddress);

uint32_t HAL_NAND_Address_Inc(const NAND_HandleTypeDef *hnand, NAND_AddressTypeDef *pAddress);

#if USE_HAL_NAND_REGISTER_CALLBACKS == 1
HAL_StatusTypeDef HAL_NAND_RegisterCallback(NAND_HandleTypeDef *hnand, HAL_NAND_CallbackIDTypeDef CallbackId,
                                            pNAND_CallbackTypeDef pCallback);
#endif

#if USE_HAL_NAND_REGISTER_CALLBACKS == 1
HAL_StatusTypeDef HAL_NAND_UnRegisterCallback(NAND_HandleTypeDef *hnand, HAL_NAND_CallbackIDTypeDef CallbackId);
#endif

HAL_StatusTypeDef  HAL_NAND_ECC_Enable(NAND_HandleTypeDef *hnand);

HAL_StatusTypeDef  HAL_NAND_ECC_Disable(NAND_HandleTypeDef *hnand);

HAL_StatusTypeDef  HAL_NAND_GetECC(NAND_HandleTypeDef *hnand, uint32_t *ECCval, uint32_t Timeout);

HAL_NAND_StateTypeDef HAL_NAND_GetState(const NAND_HandleTypeDef *hnand);

uint32_t HAL_NAND_Read_Status(const NAND_HandleTypeDef *hnand);
