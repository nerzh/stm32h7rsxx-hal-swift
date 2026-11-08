#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
HAL_StatusTypeDef HAL_CRYP_Init(CRYP_HandleTypeDef *hcryp);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
HAL_StatusTypeDef HAL_CRYP_DeInit(CRYP_HandleTypeDef *hcryp);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
HAL_StatusTypeDef HAL_CRYP_SetConfig(CRYP_HandleTypeDef *hcryp, const CRYP_ConfigTypeDef *pConf);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
HAL_StatusTypeDef HAL_CRYP_GetConfig(CRYP_HandleTypeDef *hcryp, CRYP_ConfigTypeDef *pConf);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_CRYP_RegisterCallback(CRYP_HandleTypeDef *hcryp, HAL_CRYP_CallbackIDTypeDef CallbackID,
                                            pCRYP_CallbackTypeDef pCallback);
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_CRYP_UnRegisterCallback(CRYP_HandleTypeDef *hcryp, HAL_CRYP_CallbackIDTypeDef CallbackID);
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
void HAL_CRYP_ProcessSuspend(CRYP_HandleTypeDef *hcryp);
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
HAL_StatusTypeDef HAL_CRYP_DMAProcessSuspend(CRYP_HandleTypeDef *hcryp);
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
HAL_StatusTypeDef HAL_CRYP_Suspend(CRYP_HandleTypeDef *hcryp);
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
HAL_StatusTypeDef HAL_CRYP_Resume(CRYP_HandleTypeDef *hcryp);
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
HAL_StatusTypeDef HAL_CRYP_Encrypt(CRYP_HandleTypeDef *hcryp, uint32_t *Input, uint16_t Size, uint32_t *Output,
                                   uint32_t Timeout);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
HAL_StatusTypeDef HAL_CRYP_Decrypt(CRYP_HandleTypeDef *hcryp, uint32_t *Input, uint16_t Size, uint32_t *Output,
                                   uint32_t Timeout);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
HAL_StatusTypeDef HAL_CRYP_Encrypt_IT(CRYP_HandleTypeDef *hcryp, uint32_t *Input, uint16_t Size, uint32_t *Output);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
HAL_StatusTypeDef HAL_CRYP_Decrypt_IT(CRYP_HandleTypeDef *hcryp, uint32_t *Input, uint16_t Size, uint32_t *Output);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
HAL_StatusTypeDef HAL_CRYP_Encrypt_DMA(CRYP_HandleTypeDef *hcryp, uint32_t *Input, uint16_t Size, uint32_t *Output);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
HAL_StatusTypeDef HAL_CRYP_Decrypt_DMA(CRYP_HandleTypeDef *hcryp, uint32_t *Input, uint16_t Size, uint32_t *Output);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
void HAL_CRYP_IRQHandler(CRYP_HandleTypeDef *hcryp);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
uint32_t HAL_CRYP_GetError(const CRYP_HandleTypeDef *hcryp);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
HAL_CRYP_STATETypeDef HAL_CRYP_GetState(const CRYP_HandleTypeDef *hcryp);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_AES_Encrypt(CRYP_HandleTypeDef *hcryp, uint32_t Timeout);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_AES_Encrypt_IT(CRYP_HandleTypeDef *hcryp);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_AES_Decrypt(CRYP_HandleTypeDef *hcryp, uint32_t Timeout);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_AES_Decrypt_IT(CRYP_HandleTypeDef *hcryp);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_AES_Decrypt_DMA(CRYP_HandleTypeDef *hcryp);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static void CRYP_DMAInCplt(DMA_HandleTypeDef *hdma);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static void CRYP_DMAOutCplt(DMA_HandleTypeDef *hdma);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static void CRYP_DMAError(DMA_HandleTypeDef *hdma);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static void CRYP_SetDMAConfig(CRYP_HandleTypeDef *hcryp, uint32_t inputaddr, uint16_t Size, uint32_t outputaddr);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static void CRYP_AES_ProcessData(CRYP_HandleTypeDef *hcryp, uint32_t Timeout);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static void CRYP_AES_IT(CRYP_HandleTypeDef *hcryp);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static void CRYP_SetKey(CRYP_HandleTypeDef *hcryp, uint32_t KeySize);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_AESGCM_Process(CRYP_HandleTypeDef *hcryp, uint32_t Timeout);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_AESGCM_Process_IT(CRYP_HandleTypeDef *hcryp);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_AESGCM_Process_DMA(CRYP_HandleTypeDef *hcryp);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_AESCCM_Process(CRYP_HandleTypeDef *hcryp, uint32_t Timeout);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_AESCCM_Process_IT(CRYP_HandleTypeDef *hcryp);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_AESCCM_Process_DMA(CRYP_HandleTypeDef *hcryp);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static void CRYP_GCMCCM_SetPayloadPhase_IT(CRYP_HandleTypeDef *hcryp);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_GCMCCM_SetHeaderPhase(CRYP_HandleTypeDef *hcryp, uint32_t Timeout);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_GCMCCM_SetHeaderPhase_DMA(CRYP_HandleTypeDef *hcryp);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static void CRYP_GCMCCM_SetHeaderPhase_IT(CRYP_HandleTypeDef *hcryp);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
static HAL_StatusTypeDef CRYP_WaitOnIFEMFlag(const CRYP_HandleTypeDef *hcryp, uint32_t Timeout);
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_WaitOnBUSYFlag(const CRYP_HandleTypeDef *hcryp, uint32_t Timeout);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
static HAL_StatusTypeDef CRYP_WaitOnOFNEFlag(const CRYP_HandleTypeDef  *hcryp, uint32_t Timeout);
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
static HAL_StatusTypeDef CRYP_WaitOnCCFlag(const CRYP_HandleTypeDef *hcryp, uint32_t Timeout);
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
static void CRYP_Read_IVRegisters(CRYP_HandleTypeDef *hcryp, uint32_t *Output);
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
static void CRYP_Write_IVRegisters(CRYP_HandleTypeDef *hcryp, uint32_t *Input);
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
static void CRYP_Read_ContextSwapRegisters(CRYP_HandleTypeDef *hcryp, uint32_t *Output, uint32_t Algorithm);
#endif
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
static void CRYP_Write_ContextSwapRegisters(CRYP_HandleTypeDef *hcryp, uint32_t *Input, uint32_t Algorithm);
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
static void CRYP_PhaseProcessingResume(CRYP_HandleTypeDef *hcryp);
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
static uint32_t CRYP_SAES_AlgoConversion(uint32_t algo, uint32_t order);
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
HAL_StatusTypeDef HAL_CRYPEx_AESGCM_GenerateAuthTAG(CRYP_HandleTypeDef *hcryp, const uint32_t *pAuthTag,
                                                    uint32_t Timeout);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
HAL_StatusTypeDef HAL_CRYPEx_AESCCM_GenerateAuthTAG(CRYP_HandleTypeDef *hcryp, const uint32_t *pAuthTag,
                                                    uint32_t Timeout);
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
HAL_StatusTypeDef HAL_CRYPEx_WrapKey(CRYP_HandleTypeDef *hcryp, uint32_t *Input, uint32_t *Output, uint32_t Timeout);
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
HAL_StatusTypeDef HAL_CRYPEx_UnwrapKey(CRYP_HandleTypeDef *hcryp, uint32_t *Input, uint32_t Timeout);
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
HAL_StatusTypeDef HAL_CRYPEx_EncryptSharedKey(CRYP_HandleTypeDef *hcryp, uint32_t *Key, uint32_t *Output, uint32_t ID,
                                              uint32_t Timeout);
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
HAL_StatusTypeDef HAL_CRYPEx_DecryptSharedKey(CRYP_HandleTypeDef *hcryp, uint32_t *Key, uint32_t ID, uint32_t Timeout);
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
static HAL_StatusTypeDef CRYPEx_KeyDecrypt(CRYP_HandleTypeDef *hcryp, uint32_t Timeout);
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
static HAL_StatusTypeDef CRYPEx_KeyEncrypt(CRYP_HandleTypeDef *hcryp, uint32_t Timeout);
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
static void CRYPEx_SetKey(CRYP_HandleTypeDef *hcryp, uint32_t KeySize);
#endif
#endif
#endif
