uint32_t F_JOIN(F_VARIANT,_Run)(CSDRAMState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){switch(op){
case 0:
return HAL_SDRAM_Init(&s->h,&s->timing[0]);
case 1:
return HAL_SDRAM_DeInit(&s->h);
case 2:
HAL_SDRAM_IRQHandler(&s->h);return 0;
case 3:
return HAL_SDRAM_Read_8b(&s->h,(uint32_t *)(uintptr_t)a,s->control[5]?NULL:(uint8_t *)s->buffer,b);
case 4:
return HAL_SDRAM_Write_8b(&s->h,(uint32_t *)(uintptr_t)a,s->control[5]?NULL:(uint8_t *)s->buffer,b);
case 5:
return HAL_SDRAM_Read_16b(&s->h,(uint32_t *)(uintptr_t)a,s->control[5]?NULL:(uint16_t *)s->buffer,b);
case 6:
return HAL_SDRAM_Write_16b(&s->h,(uint32_t *)(uintptr_t)a,s->control[5]?NULL:(uint16_t *)s->buffer,b);
case 7:
return HAL_SDRAM_Read_32b(&s->h,(uint32_t *)(uintptr_t)a,s->control[5]?NULL:(uint32_t *)s->buffer,b);
case 8:
return HAL_SDRAM_Write_32b(&s->h,(uint32_t *)(uintptr_t)a,s->control[5]?NULL:(uint32_t *)s->buffer,b);
case 9:
return HAL_SDRAM_Read_DMA(&s->h,(uint32_t *)(uintptr_t)a,s->control[5]?NULL:(uint32_t *)s->buffer,b);
case 10:
return HAL_SDRAM_Write_DMA(&s->h,(uint32_t *)(uintptr_t)a,s->control[5]?NULL:(uint32_t *)s->buffer,b);
case 11:
#if USE_HAL_SDRAM_REGISTER_CALLBACKS
return HAL_SDRAM_RegisterCallback(&s->h,a,(pSDRAM_CallbackTypeDef)CSDRAM_Callback(a,b));
#else
return HAL_ERROR;
#endif
case 12:
#if USE_HAL_SDRAM_REGISTER_CALLBACKS
return HAL_SDRAM_UnRegisterCallback(&s->h,a);
#else
return HAL_ERROR;
#endif
case 13:
#if USE_HAL_SDRAM_REGISTER_CALLBACKS
return HAL_SDRAM_RegisterDmaCallback(&s->h,a,(pSDRAM_DmaCallbackTypeDef)CSDRAM_Callback(a,b));
#else
return HAL_ERROR;
#endif
case 14:
return HAL_SDRAM_WriteProtection_Enable(&s->h);
case 15:
return HAL_SDRAM_WriteProtection_Disable(&s->h);
case 16:
return HAL_SDRAM_SendCommand(&s->h,&s->command,a);
case 17:
return HAL_SDRAM_ProgramRefreshRate(&s->h,a);
case 18:
return HAL_SDRAM_SetAutoRefreshNumber(&s->h,a);
case 19:
return HAL_SDRAM_GetModeStatus(&s->h);
case 20:
return HAL_SDRAM_GetState(&s->h);
case 50:
#if USE_HAL_SDRAM_REGISTER_CALLBACKS
__HAL_SDRAM_RESET_HANDLE_STATE(&s->h);
#else
s->h.State=HAL_SDRAM_STATE_RESET;
#endif
return 0;
case 51:switch(a){case 0:SDRAM_DMACplt(&s->dma[b].h);break;case 1:SDRAM_DMACpltProt(&s->dma[b].h);break;case 2:SDRAM_DMAError(&s->dma[b].h);break;default:assert(0);}return 0;
default:assert(0);return 0;}}
void *F_JOIN(F_VARIANT,_Callback)(uint32_t kind){switch(kind){case 0:return SDRAM_DMACplt;case 1:return SDRAM_DMACpltProt;case 2:return SDRAM_DMAError;}assert(0);return NULL;}
