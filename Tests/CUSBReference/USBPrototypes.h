#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef USB_CoreInit(USB_OTG_GlobalTypeDef *USBx, USB_OTG_CfgTypeDef cfg);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef USB_SetTurnaroundTime(USB_OTG_GlobalTypeDef *USBx,
                                        uint32_t hclk, uint8_t speed);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef USB_EnableGlobalInt(USB_OTG_GlobalTypeDef *USBx);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef USB_DisableGlobalInt(USB_OTG_GlobalTypeDef *USBx);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef USB_SetCurrentMode(USB_OTG_GlobalTypeDef *USBx, USB_OTG_ModeTypeDef mode);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef USB_DevInit(USB_OTG_GlobalTypeDef *USBx, USB_OTG_CfgTypeDef cfg);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef USB_FlushTxFifo(USB_OTG_GlobalTypeDef *USBx, uint32_t num);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef USB_FlushRxFifo(USB_OTG_GlobalTypeDef *USBx);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef USB_SetDevSpeed(const USB_OTG_GlobalTypeDef *USBx, uint8_t speed);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
uint8_t USB_GetDevSpeed(const USB_OTG_GlobalTypeDef *USBx);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (HAL_PCD_MODULE_ENABLED)
HAL_StatusTypeDef USB_ActivateEndpoint(const USB_OTG_GlobalTypeDef *USBx, const USB_OTG_EPTypeDef *ep);
#endif
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (HAL_PCD_MODULE_ENABLED)
HAL_StatusTypeDef USB_ActivateDedicatedEndpoint(const USB_OTG_GlobalTypeDef *USBx, const USB_OTG_EPTypeDef *ep);
#endif
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (HAL_PCD_MODULE_ENABLED)
HAL_StatusTypeDef USB_DeactivateEndpoint(const USB_OTG_GlobalTypeDef *USBx, const USB_OTG_EPTypeDef *ep);
#endif
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (HAL_PCD_MODULE_ENABLED)
HAL_StatusTypeDef USB_DeactivateDedicatedEndpoint(const USB_OTG_GlobalTypeDef *USBx, const USB_OTG_EPTypeDef *ep);
#endif
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (HAL_PCD_MODULE_ENABLED)
HAL_StatusTypeDef USB_EPStartXfer(USB_OTG_GlobalTypeDef *USBx, USB_OTG_EPTypeDef *ep, uint8_t dma);
#endif
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (HAL_PCD_MODULE_ENABLED)
HAL_StatusTypeDef USB_EPStopXfer(USB_OTG_GlobalTypeDef *USBx, USB_OTG_EPTypeDef *ep);
#endif
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (HAL_PCD_MODULE_ENABLED)
HAL_StatusTypeDef USB_EPSetStall(const USB_OTG_GlobalTypeDef *USBx, const USB_OTG_EPTypeDef *ep);
#endif
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (HAL_PCD_MODULE_ENABLED)
HAL_StatusTypeDef USB_EPClearStall(const USB_OTG_GlobalTypeDef *USBx, const USB_OTG_EPTypeDef *ep);
#endif
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef USB_WritePacket(const USB_OTG_GlobalTypeDef *USBx, uint8_t *src,
                                  uint8_t ch_ep_num, uint16_t len, uint8_t dma);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
void *USB_ReadPacket(const USB_OTG_GlobalTypeDef *USBx, uint8_t *dest, uint16_t len);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef USB_StopDevice(USB_OTG_GlobalTypeDef *USBx);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef USB_SetDevAddress(const USB_OTG_GlobalTypeDef *USBx, uint8_t address);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef USB_DevConnect(const USB_OTG_GlobalTypeDef *USBx);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef USB_DevDisconnect(const USB_OTG_GlobalTypeDef *USBx);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
uint32_t USB_ReadInterrupts(USB_OTG_GlobalTypeDef const *USBx);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
uint32_t USB_ReadChInterrupts(const USB_OTG_GlobalTypeDef *USBx, uint8_t chnum);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
uint32_t USB_ReadDevAllOutEpInterrupt(const USB_OTG_GlobalTypeDef *USBx);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
uint32_t USB_ReadDevAllInEpInterrupt(const USB_OTG_GlobalTypeDef *USBx);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
uint32_t USB_ReadDevOutEPInterrupt(const USB_OTG_GlobalTypeDef *USBx, uint8_t epnum);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
uint32_t USB_ReadDevInEPInterrupt(const USB_OTG_GlobalTypeDef *USBx, uint8_t epnum);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
void  USB_ClearInterrupts(USB_OTG_GlobalTypeDef *USBx, uint32_t interrupt);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
uint32_t USB_GetMode(const USB_OTG_GlobalTypeDef *USBx);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef USB_ActivateSetup(const USB_OTG_GlobalTypeDef *USBx);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef USB_EP0_OutStart(const USB_OTG_GlobalTypeDef *USBx, uint8_t dma, const uint8_t *psetup);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
static HAL_StatusTypeDef USB_CoreReset(USB_OTG_GlobalTypeDef *USBx);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef USB_HostInit(USB_OTG_GlobalTypeDef *USBx, USB_OTG_CfgTypeDef cfg);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef USB_InitFSLSPClkSel(const USB_OTG_GlobalTypeDef *USBx, uint8_t freq);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef USB_ResetPort(const USB_OTG_GlobalTypeDef *USBx);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef USB_DriveVbus(const USB_OTG_GlobalTypeDef *USBx, uint8_t state);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
uint32_t USB_GetHostSpeed(USB_OTG_GlobalTypeDef const *USBx);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
uint32_t USB_GetCurrentFrame(USB_OTG_GlobalTypeDef const *USBx);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (HAL_HCD_MODULE_ENABLED)
HAL_StatusTypeDef USB_HC_Init(USB_OTG_GlobalTypeDef *USBx, uint8_t ch_num,
                              uint8_t epnum, uint8_t dev_address, uint8_t speed,
                              uint8_t ep_type, uint16_t mps);
#endif
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (HAL_HCD_MODULE_ENABLED)
HAL_StatusTypeDef USB_HC_StartXfer(USB_OTG_GlobalTypeDef *USBx, USB_OTG_HCTypeDef *hc, uint8_t dma);
#endif
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (HAL_HCD_MODULE_ENABLED)
uint32_t USB_HC_ReadInterrupt(const USB_OTG_GlobalTypeDef *USBx);
#endif
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (HAL_HCD_MODULE_ENABLED)
HAL_StatusTypeDef USB_HC_Halt(const USB_OTG_GlobalTypeDef *USBx, uint8_t hc_num);
#endif
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (HAL_HCD_MODULE_ENABLED)
HAL_StatusTypeDef USB_HC_Activate(const USB_OTG_GlobalTypeDef *USBx, uint8_t ch_num, uint8_t ch_dir);
#endif
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef USB_DoPing(const USB_OTG_GlobalTypeDef *USBx, uint8_t ch_num);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef USB_StopHost(USB_OTG_GlobalTypeDef *USBx);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef USB_ActivateRemoteWakeup(const USB_OTG_GlobalTypeDef *USBx);
#endif
#endif
#endif

#if defined (HAL_PCD_MODULE_ENABLED) || defined (HAL_HCD_MODULE_ENABLED)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef USB_DeActivateRemoteWakeup(const USB_OTG_GlobalTypeDef *USBx);
#endif
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_PCD_Init(PCD_HandleTypeDef *hpcd);
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_PCD_DeInit(PCD_HandleTypeDef *hpcd);
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if (USE_HAL_PCD_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_PCD_RegisterCallback(PCD_HandleTypeDef *hpcd,
                                           HAL_PCD_CallbackIDTypeDef CallbackID,
                                           pPCD_CallbackTypeDef pCallback);
#endif
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if (USE_HAL_PCD_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_PCD_UnRegisterCallback(PCD_HandleTypeDef *hpcd, HAL_PCD_CallbackIDTypeDef CallbackID);
#endif
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if (USE_HAL_PCD_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_PCD_RegisterDataOutStageCallback(PCD_HandleTypeDef *hpcd,
                                                       pPCD_DataOutStageCallbackTypeDef pCallback);
#endif
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if (USE_HAL_PCD_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_PCD_UnRegisterDataOutStageCallback(PCD_HandleTypeDef *hpcd);
#endif
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if (USE_HAL_PCD_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_PCD_RegisterDataInStageCallback(PCD_HandleTypeDef *hpcd,
                                                      pPCD_DataInStageCallbackTypeDef pCallback);
#endif
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if (USE_HAL_PCD_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_PCD_UnRegisterDataInStageCallback(PCD_HandleTypeDef *hpcd);
#endif
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if (USE_HAL_PCD_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_PCD_RegisterIsoOutIncpltCallback(PCD_HandleTypeDef *hpcd,
                                                       pPCD_IsoOutIncpltCallbackTypeDef pCallback);
#endif
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if (USE_HAL_PCD_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_PCD_UnRegisterIsoOutIncpltCallback(PCD_HandleTypeDef *hpcd);
#endif
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if (USE_HAL_PCD_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_PCD_RegisterIsoInIncpltCallback(PCD_HandleTypeDef *hpcd,
                                                      pPCD_IsoInIncpltCallbackTypeDef pCallback);
#endif
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if (USE_HAL_PCD_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_PCD_UnRegisterIsoInIncpltCallback(PCD_HandleTypeDef *hpcd);
#endif
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if (USE_HAL_PCD_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_PCD_RegisterBcdCallback(PCD_HandleTypeDef *hpcd, pPCD_BcdCallbackTypeDef pCallback);
#endif
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if (USE_HAL_PCD_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_PCD_UnRegisterBcdCallback(PCD_HandleTypeDef *hpcd);
#endif
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if (USE_HAL_PCD_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_PCD_RegisterLpmCallback(PCD_HandleTypeDef *hpcd, pPCD_LpmCallbackTypeDef pCallback);
#endif
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if (USE_HAL_PCD_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_PCD_UnRegisterLpmCallback(PCD_HandleTypeDef *hpcd);
#endif
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_PCD_Start(PCD_HandleTypeDef *hpcd);
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_PCD_Stop(PCD_HandleTypeDef *hpcd);
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
void HAL_PCD_IRQHandler(PCD_HandleTypeDef *hpcd);
#endif
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_PCD_DevConnect(PCD_HandleTypeDef *hpcd);
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_PCD_DevDisconnect(PCD_HandleTypeDef *hpcd);
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_PCD_SetAddress(PCD_HandleTypeDef *hpcd, uint8_t address);
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_PCD_EP_Open(PCD_HandleTypeDef *hpcd, uint8_t ep_addr,
                                  uint16_t ep_mps, uint8_t ep_type);
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_PCD_EP_Close(PCD_HandleTypeDef *hpcd, uint8_t ep_addr);
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_PCD_EP_Receive(PCD_HandleTypeDef *hpcd, uint8_t ep_addr, uint8_t *pBuf, uint32_t len);
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
uint32_t HAL_PCD_EP_GetRxCount(PCD_HandleTypeDef const *hpcd, uint8_t ep_addr);
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_PCD_EP_Transmit(PCD_HandleTypeDef *hpcd, uint8_t ep_addr, uint8_t *pBuf, uint32_t len);
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_PCD_EP_SetStall(PCD_HandleTypeDef *hpcd, uint8_t ep_addr);
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_PCD_EP_ClrStall(PCD_HandleTypeDef *hpcd, uint8_t ep_addr);
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_PCD_EP_Abort(PCD_HandleTypeDef *hpcd, uint8_t ep_addr);
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_PCD_EP_Flush(PCD_HandleTypeDef *hpcd, uint8_t ep_addr);
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_PCD_ActivateRemoteWakeup(PCD_HandleTypeDef *hpcd);
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_PCD_DeActivateRemoteWakeup(PCD_HandleTypeDef *hpcd);
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
PCD_StateTypeDef HAL_PCD_GetState(PCD_HandleTypeDef const *hpcd);
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_PCD_SetTestMode(const PCD_HandleTypeDef *hpcd, uint8_t testmode);
#endif
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
static HAL_StatusTypeDef PCD_WriteEmptyTxFifo(PCD_HandleTypeDef *hpcd, uint32_t epnum);
#endif
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
static HAL_StatusTypeDef PCD_EP_OutXfrComplete_int(PCD_HandleTypeDef *hpcd, uint32_t epnum);
#endif
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
static HAL_StatusTypeDef PCD_EP_OutSetupPacket_int(PCD_HandleTypeDef *hpcd, uint32_t epnum);
#endif
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_PCDEx_SetTxFiFo(PCD_HandleTypeDef *hpcd, uint8_t fifo, uint16_t size);
#endif
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_PCDEx_SetRxFiFo(PCD_HandleTypeDef *hpcd, uint16_t size);
#endif
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_PCDEx_ActivateLPM(PCD_HandleTypeDef *hpcd);
#endif
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_PCDEx_DeActivateLPM(PCD_HandleTypeDef *hpcd);
#endif
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
void HAL_PCDEx_BCD_VBUSDetect(PCD_HandleTypeDef *hpcd);
#endif
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_PCDEx_ActivateBCD(PCD_HandleTypeDef *hpcd);
#endif
#endif
#endif

#ifdef HAL_PCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_PCDEx_DeActivateBCD(PCD_HandleTypeDef *hpcd);
#endif
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_HCD_Init(HCD_HandleTypeDef *hhcd);
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_HCD_HC_Init(HCD_HandleTypeDef *hhcd, uint8_t ch_num, uint8_t epnum,
                                  uint8_t dev_address, uint8_t speed, uint8_t ep_type, uint16_t mps);
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_HCD_HC_Halt(HCD_HandleTypeDef *hhcd, uint8_t ch_num);
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_HCD_DeInit(HCD_HandleTypeDef *hhcd);
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_HCD_HC_SubmitRequest(HCD_HandleTypeDef *hhcd,
                                           uint8_t ch_num,
                                           uint8_t direction,
                                           uint8_t ep_type,
                                           uint8_t token,
                                           uint8_t *pbuff,
                                           uint16_t length,
                                           uint8_t do_ping);
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
void HAL_HCD_IRQHandler(HCD_HandleTypeDef *hhcd);
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if (USE_HAL_HCD_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_HCD_RegisterCallback(HCD_HandleTypeDef *hhcd,
                                           HAL_HCD_CallbackIDTypeDef CallbackID,
                                           pHCD_CallbackTypeDef pCallback);
#endif
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if (USE_HAL_HCD_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_HCD_UnRegisterCallback(HCD_HandleTypeDef *hhcd, HAL_HCD_CallbackIDTypeDef CallbackID);
#endif
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if (USE_HAL_HCD_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_HCD_RegisterHC_NotifyURBChangeCallback(HCD_HandleTypeDef *hhcd,
                                                             pHCD_HC_NotifyURBChangeCallbackTypeDef pCallback);
#endif
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
#if (USE_HAL_HCD_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_HCD_UnRegisterHC_NotifyURBChangeCallback(HCD_HandleTypeDef *hhcd);
#endif
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_HCD_Start(HCD_HandleTypeDef *hhcd);
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_HCD_Stop(HCD_HandleTypeDef *hhcd);
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_HCD_ResetPort(HCD_HandleTypeDef *hhcd);
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HCD_StateTypeDef HAL_HCD_GetState(HCD_HandleTypeDef const *hhcd);
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HCD_URBStateTypeDef HAL_HCD_HC_GetURBState(HCD_HandleTypeDef const *hhcd, uint8_t chnum);
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
uint32_t HAL_HCD_HC_GetXferCount(HCD_HandleTypeDef const *hhcd, uint8_t chnum);
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HCD_HCStateTypeDef  HAL_HCD_HC_GetState(HCD_HandleTypeDef const *hhcd, uint8_t chnum);
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
uint32_t HAL_HCD_GetCurrentFrame(HCD_HandleTypeDef *hhcd);
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
uint32_t HAL_HCD_GetCurrentSpeed(HCD_HandleTypeDef *hhcd);
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_HCD_HC_SetHubInfo(HCD_HandleTypeDef *hhcd, uint8_t ch_num,
                                        uint8_t addr, uint8_t PortNbr);
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_HCD_HC_ClearHubInfo(HCD_HandleTypeDef *hhcd, uint8_t ch_num);
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
HAL_StatusTypeDef HAL_HCD_HC_Activate(HCD_HandleTypeDef *hhcd, uint8_t ch_num);
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
static void HCD_HC_IN_IRQHandler(HCD_HandleTypeDef *hhcd, uint8_t chnum);
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
static void HCD_HC_OUT_IRQHandler(HCD_HandleTypeDef *hhcd, uint8_t chnum);
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
static void HCD_RXQLVL_IRQHandler(HCD_HandleTypeDef *hhcd);
#endif
#endif

#ifdef HAL_HCD_MODULE_ENABLED
#if defined (USB_OTG_FS) || defined (USB_OTG_HS)
static void HCD_Port_IRQHandler(HCD_HandleTypeDef *hhcd);
#endif
#endif
