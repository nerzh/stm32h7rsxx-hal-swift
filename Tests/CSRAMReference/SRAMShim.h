#define F_JOIN_(a,b) a##b
#define F_JOIN(a,b) F_JOIN_(a,b)
#define __HAL_LOCK(h) do {if((h)->Lock==HAL_LOCKED)return HAL_BUSY;(h)->Lock=HAL_LOCKED;}while(0)
#define __HAL_UNLOCK(h) ((h)->Lock=HAL_UNLOCKED)
#define FMC_MEMORY_READ8(a) ((uint8_t)CSRAM_ReadMemory(CSRAM_Active(),8,(uint32_t)(uintptr_t)(a)))
#define FMC_MEMORY_READ16(a) ((uint16_t)CSRAM_ReadMemory(CSRAM_Active(),16,(uint32_t)(uintptr_t)(a)))
#define FMC_MEMORY_READ32(a) CSRAM_ReadMemory(CSRAM_Active(),32,(uint32_t)(uintptr_t)(a))
#define FMC_MEMORY_WRITE8(a,v) CSRAM_WriteMemory(CSRAM_Active(),8,(uint32_t)(uintptr_t)(a),(uint8_t)(v))
#define FMC_MEMORY_WRITE16(a,v) CSRAM_WriteMemory(CSRAM_Active(),16,(uint32_t)(uintptr_t)(a),(uint16_t)(v))
#define FMC_MEMORY_WRITE32(a,v) CSRAM_WriteMemory(CSRAM_Active(),32,(uint32_t)(uintptr_t)(a),(uint32_t)(v))
#undef __HAL_DMA_DISABLE
#define __HAL_DMA_DISABLE(h) CSRAM_DisableDMA(h)
static HAL_StatusTypeDef HAL_DMA_Start_IT(DMA_HandleTypeDef *d,uint32_t source,uint32_t dest,uint32_t size){
CSRAMDMA *record=(CSRAMDMA *)d;return CSRAM_Start(record->owner,0,source,dest,size);
}
static HAL_StatusTypeDef HAL_DMAEx_List_Start_IT(DMA_HandleTypeDef *d){
CSRAMDMA *record=(CSRAMDMA *)d;return CSRAM_Start(record->owner,1,d->LinkedListQueue->Head->LinkRegisters[3],d->LinkedListQueue->Head->LinkRegisters[4],d->LinkedListQueue->Head->LinkRegisters[2]);
}
#define HAL_SRAM_Init F_JOIN(F_VARIANT,_HAL_SRAM_Init)
#define HAL_SRAM_DeInit F_JOIN(F_VARIANT,_HAL_SRAM_DeInit)
#define HAL_SRAM_Read_8b F_JOIN(F_VARIANT,_HAL_SRAM_Read_8b)
#define HAL_SRAM_Write_8b F_JOIN(F_VARIANT,_HAL_SRAM_Write_8b)
#define HAL_SRAM_Read_16b F_JOIN(F_VARIANT,_HAL_SRAM_Read_16b)
#define HAL_SRAM_Write_16b F_JOIN(F_VARIANT,_HAL_SRAM_Write_16b)
#define HAL_SRAM_Read_32b F_JOIN(F_VARIANT,_HAL_SRAM_Read_32b)
#define HAL_SRAM_Write_32b F_JOIN(F_VARIANT,_HAL_SRAM_Write_32b)
#define HAL_SRAM_Read_DMA F_JOIN(F_VARIANT,_HAL_SRAM_Read_DMA)
#define HAL_SRAM_Write_DMA F_JOIN(F_VARIANT,_HAL_SRAM_Write_DMA)
#define HAL_SRAM_RegisterCallback F_JOIN(F_VARIANT,_HAL_SRAM_RegisterCallback)
#define HAL_SRAM_UnRegisterCallback F_JOIN(F_VARIANT,_HAL_SRAM_UnRegisterCallback)
#define HAL_SRAM_RegisterDmaCallback F_JOIN(F_VARIANT,_HAL_SRAM_RegisterDmaCallback)
#define HAL_SRAM_WriteOperation_Enable F_JOIN(F_VARIANT,_HAL_SRAM_WriteOperation_Enable)
#define HAL_SRAM_WriteOperation_Disable F_JOIN(F_VARIANT,_HAL_SRAM_WriteOperation_Disable)
#define HAL_SRAM_GetState F_JOIN(F_VARIANT,_HAL_SRAM_GetState)
#define SRAM_DMACplt F_JOIN(F_VARIANT,_SRAM_DMACplt)
#define SRAM_DMACpltProt F_JOIN(F_VARIANT,_SRAM_DMACpltProt)
#define SRAM_DMAError F_JOIN(F_VARIANT,_SRAM_DMAError)
#define HAL_SRAM_MspInit ((pSRAM_CallbackTypeDef)CSRAM_Callback(0,1))
#define HAL_SRAM_MspDeInit ((pSRAM_CallbackTypeDef)CSRAM_Callback(1,1))
#define HAL_SRAM_DMA_XferCpltCallback ((pSRAM_DmaCallbackTypeDef)CSRAM_Callback(2,1))
#define HAL_SRAM_DMA_XferErrorCallback ((pSRAM_DmaCallbackTypeDef)CSRAM_Callback(3,1))
