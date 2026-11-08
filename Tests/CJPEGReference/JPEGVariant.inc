static void (*callback(uint32_t token))(DMA_HandleTypeDef *) {switch(token){case 1:return JPEG_DMAInCpltCallback;case 2:return JPEG_DMAOutCpltCallback;case 3:return JPEG_DMAErrorCallback;case 4:return JPEG_DMAOutAbortCallback;default:return NULL;}}
void F_JOIN(F_VARIANT,_SetDMA)(CJPEGState *s,uint32_t d,uint32_t i,uint32_t token) {switch(i){case 0:s->dma[d].XferCpltCallback=callback(token);break;case 1:s->dma[d].XferErrorCallback=callback(token);break;case 2:s->dma[d].XferAbortCallback=callback(token);break;default:assert(0);}}
uint32_t F_JOIN(F_VARIANT,_GetDMA)(CJPEGState *s,uint32_t d,uint32_t i) {void (*cb)(DMA_HandleTypeDef *)=NULL;switch(i){case 0:cb=s->dma[d].XferCpltCallback;break;case 1:cb=s->dma[d].XferErrorCallback;break;case 2:cb=s->dma[d].XferAbortCallback;break;default:assert(0);}if(!cb)return 0;for(uint32_t t=1;t<=4;t++)if(callback(t)==cb)return t;return 99;}
uint32_t F_JOIN(F_VARIANT,_Run)(CJPEGState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {
 CJPEG_Active=s;JPEG_HandleTypeDef *h=&s->h;
 uint8_t *in=s->control[0]?s->data:NULL,*out=s->control[1]?s->data+128:NULL;
 switch(op) {
 case 0:return HAL_JPEG_Init(h);case 1:return HAL_JPEG_DeInit(h);
 case 2:return HAL_JPEG_ConfigEncoding(h,s->control[2]?&s->config:NULL);
 case 3:return HAL_JPEG_GetInfo(h,a?&s->output:NULL);
 case 4:return HAL_JPEG_EnableHeaderParsing(h);case 5:return HAL_JPEG_DisableHeaderParsing(h);
 case 6:return HAL_JPEG_SetUserQuantTables(h,(a&1)?s->quant[0]:NULL,(a&2)?s->quant[1]:NULL,(a&4)?s->quant[2]:NULL,(a&8)?s->quant[3]:NULL);
 case 7:return HAL_JPEG_Encode(h,in,a,out,b,c);case 8:return HAL_JPEG_Decode(h,in,a,out,b,c);
 case 9:return HAL_JPEG_Encode_IT(h,in,a,out,b);case 10:return HAL_JPEG_Decode_IT(h,in,a,out,b);
 case 11:return HAL_JPEG_Encode_DMA(h,in,a,out,b);case 12:return HAL_JPEG_Decode_DMA(h,in,a,out,b);
 case 13:return HAL_JPEG_Pause(h,a);case 14:return HAL_JPEG_Resume(h,a);
 case 15:HAL_JPEG_ConfigInputBuffer(h,a?s->data+a-1:NULL,b);return 0;
 case 16:HAL_JPEG_ConfigOutputBuffer(h,a?s->data+a-1:NULL,b);return 0;
 case 17:return HAL_JPEG_Abort(h);case 18:HAL_JPEG_IRQHandler(h);return 0;
 case 19:return HAL_JPEG_GetState(h);case 20:return HAL_JPEG_GetError(h);
#if F_MODE
 case 21:return HAL_JPEG_RegisterCallback(h,a,CJPEG_CallbackPointer(a,b));case 22:return HAL_JPEG_UnRegisterCallback(h,a);
 case 23:return HAL_JPEG_RegisterInfoReadyCallback(h,CJPEG_InfoPointer(a));case 24:return HAL_JPEG_UnRegisterInfoReadyCallback(h);
 case 25:return HAL_JPEG_RegisterGetDataCallback(h,CJPEG_GetPointer(a));case 26:return HAL_JPEG_UnRegisterGetDataCallback(h);
 case 27:return HAL_JPEG_RegisterDataReadyCallback(h,CJPEG_DataPointer(a));case 28:return HAL_JPEG_UnRegisterDataReadyCallback(h);
#endif
 case 29:__HAL_JPEG_RESET_HANDLE_STATE(h);return 0;
 case 30:case 31:case 32:case 33:callback(op-29)(&s->dma[a]);return 0;
 case 34:JPEG_ReadInputData(h,a);return 0;case 35:JPEG_StoreOutputData(h,a);return 0;
 case 36:return JPEG_Set_Quantization_Mem(h,s->quant[a],h->Instance->QMEM0);
 case 37:return JPEG_GetQuality(h);
 case 38:__HAL_JPEG_ENABLE(h);return 0;case 39:__HAL_JPEG_DISABLE(h);return 0;
 case 40:return __HAL_JPEG_GET_FLAG(h,a);case 41:__HAL_JPEG_CLEAR_FLAG(h,a);return 0;
 case 42:__HAL_JPEG_ENABLE_IT(h,a);return 0;case 43:__HAL_JPEG_DISABLE_IT(h,a);return 0;
 case 44:return __HAL_JPEG_GET_IT_SOURCE(h,a);
 default:assert(0);return UINT32_MAX;
 }
}
