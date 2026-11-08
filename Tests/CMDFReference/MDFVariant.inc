static void (*callback(uint32_t t))(DMA_HandleTypeDef *) {switch(t) {case 1:return MDF_DmaXferCpltCallback;case 2:return MDF_DmaXferHalfCpltCallback;case 3:return MDF_DmaErrorCallback;default:return NULL;}}
void F_JOIN(F_VARIANT,_SetDMA)(CMDFState *s,uint32_t i,uint32_t t) {switch(i) {case 0:s->dma.XferCpltCallback=callback(t);break;case 1:s->dma.XferHalfCpltCallback=callback(t);break;case 2:s->dma.XferErrorCallback=callback(t);break;}}
uint32_t F_JOIN(F_VARIANT,_GetDMA)(CMDFState *s,uint32_t i) {void (*cb)(DMA_HandleTypeDef *)=NULL;switch(i) {case 0:cb=s->dma.XferCpltCallback;break;case 1:cb=s->dma.XferHalfCpltCallback;break;case 2:cb=s->dma.XferErrorCallback;break;}if(!cb)return 0;for(uint32_t t=1;t<=3;t++)if(callback(t)==cb)return t;return 99;}
static uint32_t run(CMDFState *s,uint32_t op,uint32_t a,uint32_t b) {
 MDF_HandleTypeDef *h=&s->h;const MDF_FilterConfigTypeDef *f=s->control[0]?&s->config:NULL;
 switch(op) {
 case 0:return HAL_MDF_Init(h);
 case 1:return HAL_MDF_DeInit(h);
#if F_MODE
 case 2:return HAL_MDF_RegisterCallback(h,a,CMDF_CallbackPointer(a,b));
 case 3:return HAL_MDF_UnRegisterCallback(h,a);
 case 4:return HAL_MDF_RegisterSndLvlCallback(h,CMDF_SoundPointer(a));
 case 5:return HAL_MDF_UnRegisterSndLvlCallback(h);
#endif
 case 6:return HAL_MDF_AcqStart(h,f);
 case 7:return HAL_MDF_PollForAcq(h,a);
 case 8:return HAL_MDF_GetAcqValue(h,a?(int32_t*)&s->output[0]:NULL);
 case 9:return HAL_MDF_AcqStop(h);
 case 10:return HAL_MDF_AcqStart_IT(h,f);
 case 11:return HAL_MDF_AcqStop_IT(h);
 case 12:return HAL_MDF_AcqStart_DMA(h,f,s->control[1]?&s->dmaConfig:NULL);
 case 13:return HAL_MDF_AcqStop_DMA(h);
 case 14:return HAL_MDF_GenerateTrgo(h);
 case 15:return HAL_MDF_SetDelay(h,a);
 case 16:return HAL_MDF_GetDelay(h,a?&s->output[0]:NULL);
 case 17:return HAL_MDF_SetGain(h,(int32_t)a);
 case 18:return HAL_MDF_GetGain(h,a?(int32_t*)&s->output[0]:NULL);
 case 19:return HAL_MDF_PollForSndLvl(h,a,(b&1)?&s->output[0]:NULL,(b&2)?&s->output[1]:NULL);
 case 20:return HAL_MDF_PollForSad(h,a);
 case 21:return HAL_MDF_PollForCkab(h,a);
 case 22:return HAL_MDF_CkabStart_IT(h);
 case 23:return HAL_MDF_CkabStop_IT(h);
 case 24:HAL_MDF_IRQHandler(h);return 0;
 case 25:return HAL_MDF_GetState(h);
 case 26:return HAL_MDF_GetError(h);
 case 27:__HAL_MDF_RESET_HANDLE_STATE(h);return 0;
 case 28:case 29:case 30:callback(op-27)(&s->dma);return 0;
 default:assert(0);return UINT32_MAX;
 }
}
uint32_t F_JOIN(F_VARIANT,_Run)(CMDFState *s,uint32_t op,uint32_t a,uint32_t b) {
 CMDF_Active=s;v_mdfHandle=s->owner;
 uint32_t result=run(s,op,a,b);s->owner=v_mdfHandle;return result;
}
