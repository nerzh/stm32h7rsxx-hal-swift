static void (*callback(uint32_t t))(DMA_HandleTypeDef *) {
 switch(t) {case 1:return SPDIFRX_DMARxCplt;case 2:return SPDIFRX_DMARxHalfCplt;case 3:return SPDIFRX_DMACxCplt;case 4:return SPDIFRX_DMACxHalfCplt;case 5:return SPDIFRX_DMAError;default:return NULL;}
}
void S_JOIN(S_VARIANT,_SetDMA)(CSPDIFRXState *s,uint32_t dir,uint32_t i,uint32_t t) {
 switch(i) {case 0:s->dma[dir].XferHalfCpltCallback=callback(t);break;case 1:s->dma[dir].XferCpltCallback=callback(t);break;case 2:s->dma[dir].XferErrorCallback=callback(t);break;case 3:s->dma[dir].XferAbortCallback=callback(t);break;}
}
uint32_t S_JOIN(S_VARIANT,_GetDMA)(CSPDIFRXState *s,uint32_t dir,uint32_t i) {
 void (*cb)(DMA_HandleTypeDef *)=NULL;
 switch(i) {case 0:cb=s->dma[dir].XferHalfCpltCallback;break;case 1:cb=s->dma[dir].XferCpltCallback;break;case 2:cb=s->dma[dir].XferErrorCallback;break;case 3:cb=s->dma[dir].XferAbortCallback;break;}
 if(!cb)return 0;for(uint32_t t=1;t<=5;t++)if(callback(t)==cb)return t;return 99;
}
uint32_t S_JOIN(S_VARIANT,_Run)(CSPDIFRXState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {
 CSPDIFRX_Active=s;SPDIFRX_HandleTypeDef *h=&s->h;
 SPDIFRX_SetDataFormatTypeDef format={s->format[0],s->format[1],s->format[2],s->format[3],s->format[4],s->format[5]};
 switch(op) {
 case 0:return HAL_SPDIFRX_Init(h);
 case 1:return HAL_SPDIFRX_DeInit(h);
 case 2:return HAL_SPDIFRX_SetDataFormat(h,format);
 case 3:return HAL_SPDIFRX_ReceiveDataFlow(h,a?s->data+a-1:NULL,b,c);
 case 4:return HAL_SPDIFRX_ReceiveCtrlFlow(h,a?s->data+a-1:NULL,b,c);
 case 5:return HAL_SPDIFRX_ReceiveDataFlow_IT(h,a?s->data+a-1:NULL,b);
 case 6:return HAL_SPDIFRX_ReceiveCtrlFlow_IT(h,a?s->data+a-1:NULL,b);
 case 7:return HAL_SPDIFRX_ReceiveDataFlow_DMA(h,a?s->data+a-1:NULL,b);
 case 8:return HAL_SPDIFRX_ReceiveCtrlFlow_DMA(h,a?s->data+a-1:NULL,b);
 case 9:return HAL_SPDIFRX_DMAStop(h);
 case 10:HAL_SPDIFRX_IRQHandler(h);return 0;
 case 11:return HAL_SPDIFRX_GetState(h);
 case 12:return HAL_SPDIFRX_GetError(h);
 case 13:case 14:case 15:case 16:case 17:callback(op-12)(&s->dma[a]);return 0;
#if S_MODE
 case 18:return HAL_SPDIFRX_RegisterCallback(h,a,CSPDIFRX_CallbackPointer(a,b));
 case 19:return HAL_SPDIFRX_UnRegisterCallback(h,a);
#endif
 case 20:__HAL_SPDIFRX_RESET_HANDLE_STATE(h);return 0;
 case 21:__HAL_SPDIFRX_IDLE(h);return 0;
 case 22:__HAL_SPDIFRX_SYNC(h);return 0;
 case 23:__HAL_SPDIFRX_RCV(h);return 0;
 case 24:__HAL_SPDIFRX_ENABLE_IT(h,a);return 0;
 case 25:__HAL_SPDIFRX_DISABLE_IT(h,a);return 0;
 case 26:return __HAL_SPDIFRX_GET_IT_SOURCE(h,a);
 case 27:return __HAL_SPDIFRX_GET_FLAG(h,a);
 case 28:__HAL_SPDIFRX_CLEAR_IT(h,a);return 0;
 default:assert(0);return UINT32_MAX;
 }
}
