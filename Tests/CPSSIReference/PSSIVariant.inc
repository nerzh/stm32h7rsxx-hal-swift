static void (*pCallback(uint32_t token))(DMA_HandleTypeDef *) {
#if P_DMA
 switch(token) { case 1:return PSSI_DMATransmitCplt;case 2:return PSSI_DMAReceiveCplt;case 3:return PSSI_DMAError;case 4:return PSSI_DMAAbort;default:return NULL; }
#else
 (void)token;return NULL;
#endif
}
void P_JOIN(P_VARIANT,_SetDMA)(CPSSIState *s,uint32_t dir,uint32_t id,uint32_t token) {
 void (*cb)(DMA_HandleTypeDef *)=pCallback(token);
 switch(id) { case 0:s->dma[dir].XferCpltCallback=cb;break;case 1:s->dma[dir].XferHalfCpltCallback=cb;break;case 2:s->dma[dir].XferErrorCallback=cb;break;case 3:s->dma[dir].XferAbortCallback=cb;break; }
}
uint32_t P_JOIN(P_VARIANT,_GetDMA)(CPSSIState *s,uint32_t dir,uint32_t id) {
 void (*cb)(DMA_HandleTypeDef *)=NULL;
 switch(id) { case 0:cb=s->dma[dir].XferCpltCallback;break;case 1:cb=s->dma[dir].XferHalfCpltCallback;break;case 2:cb=s->dma[dir].XferErrorCallback;break;case 3:cb=s->dma[dir].XferAbortCallback;break; }
 if(!cb)return 0;
 for(uint32_t i=1;i<=4;i++)if(cb==pCallback(i))return i;
 return 99;
}
uint32_t P_JOIN(P_VARIANT,_Run)(CPSSIState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {
 CPSSI_Active=s;
 PSSI_HandleTypeDef *h=&s->h;
 switch(op) {
 case 0:return HAL_PSSI_Init(h);
 case 1:return HAL_PSSI_DeInit(h);
 case 2:return HAL_PSSI_Transmit(h,a?s->data+a-1:NULL,b,c);
 case 3:return HAL_PSSI_Receive(h,a?s->data+a-1:NULL,b,c);
#if P_DMA
 case 4:return HAL_PSSI_Transmit_DMA(h,a?(uint32_t*)(s->data+a-1):NULL,b);
 case 5:return HAL_PSSI_Receive_DMA(h,a?(uint32_t*)(s->data+a-1):NULL,b);
 case 6:return HAL_PSSI_Abort_DMA(h);
 case 10:PSSI_DMATransmitCplt(&s->dma[a]);return 0;
 case 11:PSSI_DMAReceiveCplt(&s->dma[a]);return 0;
 case 12:PSSI_DMAError(&s->dma[a]);return 0;
 case 13:PSSI_DMAAbort(&s->dma[a]);return 0;
#endif
 case 7:HAL_PSSI_IRQHandler(h);return 0;
 case 8:return HAL_PSSI_GetState(h);
 case 9:return HAL_PSSI_GetError(h);
 case 14:return HAL_PSSI_ClockConfig(h,a);
#if P_MODE
 case 15:return HAL_PSSI_RegisterCallback(h,a,CPSSI_CallbackPointer(a,b));
 case 16:return HAL_PSSI_UnRegisterCallback(h,a);
#endif
 case 17:HAL_PSSI_RESET_HANDLE_STATE(h);return 0;
 case 18:HAL_PSSI_ENABLE(h);return 0;
 case 19:HAL_PSSI_DISABLE(h);return 0;
 case 20:return HAL_PSSI_GET_STATUS(h,a);
 case 21:return HAL_PSSI_GET_FLAG(h,a);
 case 22:HAL_PSSI_CLEAR_FLAG(h,a);return 0;
 case 23:HAL_PSSI_ENABLE_IT(h,a);return 0;
 case 24:HAL_PSSI_DISABLE_IT(h,a);return 0;
 case 25:return HAL_PSSI_GET_IT_SOURCE(h,a);
 default:return UINT32_MAX;
 }
}
