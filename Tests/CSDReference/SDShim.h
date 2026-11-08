// The extracted IRQ body instruments its two direct CMD stores with WRITE_REG.
// This preserves the original read/modify/write expressions and updates the command model.
#define F_JOIN_I(a,b) a##b
#define F_JOIN(a,b) F_JOIN_I(a,b)
#define HAL_SD_Init F_JOIN(F_VARIANT,_HAL_SD_Init)
#define HAL_SD_InitCard F_JOIN(F_VARIANT,_HAL_SD_InitCard)
#define HAL_SD_DeInit F_JOIN(F_VARIANT,_HAL_SD_DeInit)
#define HAL_SD_ReadBlocks F_JOIN(F_VARIANT,_HAL_SD_ReadBlocks)
#define HAL_SD_WriteBlocks F_JOIN(F_VARIANT,_HAL_SD_WriteBlocks)
#define HAL_SD_ReadBlocks_IT F_JOIN(F_VARIANT,_HAL_SD_ReadBlocks_IT)
#define HAL_SD_WriteBlocks_IT F_JOIN(F_VARIANT,_HAL_SD_WriteBlocks_IT)
#define HAL_SD_ReadBlocks_DMA F_JOIN(F_VARIANT,_HAL_SD_ReadBlocks_DMA)
#define HAL_SD_WriteBlocks_DMA F_JOIN(F_VARIANT,_HAL_SD_WriteBlocks_DMA)
#define HAL_SD_Erase F_JOIN(F_VARIANT,_HAL_SD_Erase)
#define HAL_SD_IRQHandler F_JOIN(F_VARIANT,_HAL_SD_IRQHandler)
#define HAL_SD_GetState F_JOIN(F_VARIANT,_HAL_SD_GetState)
#define HAL_SD_GetError F_JOIN(F_VARIANT,_HAL_SD_GetError)
#define HAL_SD_RegisterCallback F_JOIN(F_VARIANT,_HAL_SD_RegisterCallback)
#define HAL_SD_UnRegisterCallback F_JOIN(F_VARIANT,_HAL_SD_UnRegisterCallback)
#define HAL_SD_RegisterTransceiverCallback F_JOIN(F_VARIANT,_HAL_SD_RegisterTransceiverCallback)
#define HAL_SD_UnRegisterTransceiverCallback F_JOIN(F_VARIANT,_HAL_SD_UnRegisterTransceiverCallback)
#define HAL_SD_GetCardCID F_JOIN(F_VARIANT,_HAL_SD_GetCardCID)
#define HAL_SD_GetCardCSD F_JOIN(F_VARIANT,_HAL_SD_GetCardCSD)
#define HAL_SD_GetCardStatus F_JOIN(F_VARIANT,_HAL_SD_GetCardStatus)
#define HAL_SD_GetCardInfo F_JOIN(F_VARIANT,_HAL_SD_GetCardInfo)
#define HAL_SD_ConfigWideBusOperation F_JOIN(F_VARIANT,_HAL_SD_ConfigWideBusOperation)
#define HAL_SD_ConfigSpeedBusOperation F_JOIN(F_VARIANT,_HAL_SD_ConfigSpeedBusOperation)
#define HAL_SD_GetCardState F_JOIN(F_VARIANT,_HAL_SD_GetCardState)
#define HAL_SD_Abort F_JOIN(F_VARIANT,_HAL_SD_Abort)
#define HAL_SD_Abort_IT F_JOIN(F_VARIANT,_HAL_SD_Abort_IT)
#define SD_InitCard F_JOIN(F_VARIANT,_SD_InitCard)
#define SD_PowerON F_JOIN(F_VARIANT,_SD_PowerON)
#define SD_PowerOFF F_JOIN(F_VARIANT,_SD_PowerOFF)
#define SD_SendSDStatus F_JOIN(F_VARIANT,_SD_SendSDStatus)
#define SD_SendStatus F_JOIN(F_VARIANT,_SD_SendStatus)
#define SD_WideBus_Enable F_JOIN(F_VARIANT,_SD_WideBus_Enable)
#define SD_WideBus_Disable F_JOIN(F_VARIANT,_SD_WideBus_Disable)
#define SD_FindSCR F_JOIN(F_VARIANT,_SD_FindSCR)
#define SD_Read_IT F_JOIN(F_VARIANT,_SD_Read_IT)
#define SD_Write_IT F_JOIN(F_VARIANT,_SD_Write_IT)
#define SD_SwitchSpeed F_JOIN(F_VARIANT,_SD_SwitchSpeed)
#define SD_UltraHighSpeed F_JOIN(F_VARIANT,_SD_UltraHighSpeed)
#define SD_DDR_Mode F_JOIN(F_VARIANT,_SD_DDR_Mode)
#define HAL_SDEx_DMALinkedList_BuildNode F_JOIN(F_VARIANT,_HAL_SDEx_DMALinkedList_BuildNode)
#define HAL_SDEx_DMALinkedList_InsertNode F_JOIN(F_VARIANT,_HAL_SDEx_DMALinkedList_InsertNode)
#define HAL_SDEx_DMALinkedList_RemoveNode F_JOIN(F_VARIANT,_HAL_SDEx_DMALinkedList_RemoveNode)
#define HAL_SDEx_DMALinkedList_LockNode F_JOIN(F_VARIANT,_HAL_SDEx_DMALinkedList_LockNode)
#define HAL_SDEx_DMALinkedList_UnlockNode F_JOIN(F_VARIANT,_HAL_SDEx_DMALinkedList_UnlockNode)
#define HAL_SDEx_DMALinkedList_EnableCircularMode F_JOIN(F_VARIANT,_HAL_SDEx_DMALinkedList_EnableCircularMode)
#define HAL_SDEx_DMALinkedList_DisableCircularMode F_JOIN(F_VARIANT,_HAL_SDEx_DMALinkedList_DisableCircularMode)
#define HAL_SDEx_DMALinkedList_ReadBlocks F_JOIN(F_VARIANT,_HAL_SDEx_DMALinkedList_ReadBlocks)
#define HAL_SDEx_DMALinkedList_WriteBlocks F_JOIN(F_VARIANT,_HAL_SDEx_DMALinkedList_WriteBlocks)
#define HAL_SD_TxCpltCallback CSD_Default0
#define HAL_SD_RxCpltCallback CSD_Default1
#define HAL_SD_ErrorCallback CSD_Default2
#define HAL_SD_AbortCallback CSD_Default3
#define HAL_SDEx_Read_DMALnkLstBufCpltCallback CSD_Default4
#define HAL_SDEx_Write_DMALnkLstBufCpltCallback CSD_Default5
#define HAL_SD_MspInit CSD_Default16
#define HAL_SD_MspDeInit CSD_Default17
#define HAL_SD_DriveTransceiver_1_8V_Callback CSD_Default18
#define HAL_GetTick() CSD_TickFor(CSD_Active)
#define HAL_Delay(x) CSD_DelayFor(CSD_Active,(x))
#define HAL_RCCEx_GetPeriphCLKFreq(x) CSD_FrequencyFor(CSD_Active,(x))
#define RCC_PERIPHCLK_SDMMC12 0x00200000U
#define __HAL_LOCK(h) do{if((h)->Lock==HAL_LOCKED)return HAL_BUSY;(h)->Lock=HAL_LOCKED;}while(0)
#define __HAL_UNLOCK(h) ((h)->Lock=HAL_UNLOCKED)
#undef SDMMC1
#undef SDMMC2
#undef DLYB_SDMMC1
#undef DLYB_SDMMC2
#define SDMMC1 (CSD_Active->control[1]==1?&CSD_Active->ll.regs:&CSD_Active->unusedRegs)
#define SDMMC2 (CSD_Active->control[1]==2?&CSD_Active->ll.regs:&CSD_Active->unusedRegs)
#define DLYB_SDMMC1 (&CSD_Active->delay[0])
#define DLYB_SDMMC2 (&CSD_Active->delay[1])
