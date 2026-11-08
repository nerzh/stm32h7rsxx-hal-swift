uint32_t F_JOIN(F_VARIANT,_Run)(CSRAMState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){switch(op){
case 0:
return HAL_SRAM_Init(&s->h,&s->timing[0],s->control[6]?NULL:&s->timing[1]);
case 1:
return HAL_SRAM_DeInit(&s->h);
case 2:
return HAL_SRAM_Read_8b(&s->h,(uint32_t *)(uintptr_t)a,s->control[5]?NULL:(uint8_t *)s->buffer,b);
case 3:
return HAL_SRAM_Write_8b(&s->h,(uint32_t *)(uintptr_t)a,s->control[5]?NULL:(uint8_t *)s->buffer,b);
case 4:
return HAL_SRAM_Read_16b(&s->h,(uint32_t *)(uintptr_t)a,s->control[5]?NULL:(uint16_t *)s->buffer,b);
case 5:
return HAL_SRAM_Write_16b(&s->h,(uint32_t *)(uintptr_t)a,s->control[5]?NULL:(uint16_t *)s->buffer,b);
case 6:
return HAL_SRAM_Read_32b(&s->h,(uint32_t *)(uintptr_t)a,s->control[5]?NULL:(uint32_t *)s->buffer,b);
case 7:
return HAL_SRAM_Write_32b(&s->h,(uint32_t *)(uintptr_t)a,s->control[5]?NULL:(uint32_t *)s->buffer,b);
case 8:
return HAL_SRAM_Read_DMA(&s->h,(uint32_t *)(uintptr_t)a,s->control[5]?NULL:(uint32_t *)s->buffer,b);
case 9:
return HAL_SRAM_Write_DMA(&s->h,(uint32_t *)(uintptr_t)a,s->control[5]?NULL:(uint32_t *)s->buffer,b);
case 10:
#if USE_HAL_SRAM_REGISTER_CALLBACKS
return HAL_SRAM_RegisterCallback(&s->h,a,(pSRAM_CallbackTypeDef)CSRAM_Callback(a,b));
#else
return HAL_ERROR;
#endif
case 11:
#if USE_HAL_SRAM_REGISTER_CALLBACKS
return HAL_SRAM_UnRegisterCallback(&s->h,a);
#else
return HAL_ERROR;
#endif
case 12:
#if USE_HAL_SRAM_REGISTER_CALLBACKS
return HAL_SRAM_RegisterDmaCallback(&s->h,a,(pSRAM_DmaCallbackTypeDef)CSRAM_Callback(a,b));
#else
return HAL_ERROR;
#endif
case 13:
return HAL_SRAM_WriteOperation_Enable(&s->h);
case 14:
return HAL_SRAM_WriteOperation_Disable(&s->h);
case 15:
return HAL_SRAM_GetState(&s->h);
case 50:
#if USE_HAL_SRAM_REGISTER_CALLBACKS
__HAL_SRAM_RESET_HANDLE_STATE(&s->h);
#else
s->h.State=HAL_SRAM_STATE_RESET;
#endif
return 0;
case 51:switch(a){case 0:SRAM_DMACplt(&s->dma[b].h);break;case 1:SRAM_DMACpltProt(&s->dma[b].h);break;case 2:SRAM_DMAError(&s->dma[b].h);break;default:assert(0);}return 0;
default:assert(0);return 0;}}
void *F_JOIN(F_VARIANT,_Callback)(uint32_t kind){switch(kind){case 0:return SRAM_DMACplt;case 1:return SRAM_DMACpltProt;case 2:return SRAM_DMAError;}assert(0);return NULL;}
