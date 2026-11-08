uint32_t F_JOIN(F_VARIANT,_GetWord)(CIRDAState *s,uint32_t i) { switch(i) {
case 0:return s->h.Init.BaudRate;
case 1:return s->h.Init.WordLength;
case 2:return s->h.Init.Parity;
case 3:return s->h.Init.Mode;
case 4:return s->h.Init.Prescaler;
case 5:return s->h.Init.PowerMode;
case 6:return s->h.Init.ClockPrescaler;
case 7:return s->h.TxXferSize;
case 8:return s->h.TxXferCount;
case 9:return s->h.RxXferSize;
case 10:return s->h.RxXferCount;
case 11:return s->h.Mask;
case 12:return s->h.Lock;
case 13:return s->h.gState;
case 14:return s->h.RxState;
case 15:return s->h.ErrorCode;
default:assert(0);return 0;} }
void F_JOIN(F_VARIANT,_SetWord)(CIRDAState *s,uint32_t i,uint32_t v) {switch(i) {
case 0:s->h.Init.BaudRate=v;break;
case 1:s->h.Init.WordLength=v;break;
case 2:s->h.Init.Parity=v;break;
case 3:s->h.Init.Mode=v;break;
case 4:s->h.Init.Prescaler=v;break;
case 5:s->h.Init.PowerMode=v;break;
case 6:s->h.Init.ClockPrescaler=v;break;
case 7:s->h.TxXferSize=v;break;
case 8:s->h.TxXferCount=v;break;
case 9:s->h.RxXferSize=v;break;
case 10:s->h.RxXferCount=v;break;
case 11:s->h.Mask=v;break;
case 12:s->h.Lock=v;break;
case 13:s->h.gState=v;break;
case 14:s->h.RxState=v;break;
case 15:s->h.ErrorCode=v;break;
default:assert(0);break;} }
static void (*IRDA_DMAFunction(uint32_t k))(DMA_HandleTypeDef *) {switch(k) {
case 0:return NULL;
case 1:return IRDA_DMATransmitCplt;
case 2:return IRDA_DMATransmitHalfCplt;
case 3:return IRDA_DMAReceiveCplt;
case 4:return IRDA_DMAReceiveHalfCplt;
case 5:return IRDA_DMAError;
case 6:return IRDA_DMAAbortOnError;
case 7:return IRDA_DMATxAbortCallback;
case 8:return IRDA_DMARxAbortCallback;
case 9:return IRDA_DMATxOnlyAbortCallback;
case 10:return IRDA_DMARxOnlyAbortCallback;
default:assert(0);return NULL;} }
uint32_t F_JOIN(F_VARIANT,_GetDMA)(CIRDAState *s,uint32_t d,uint32_t id) { void (*f)(DMA_HandleTypeDef *)=NULL;switch(id) {
case 0:f=s->dma[d].XferCpltCallback;break;
case 1:f=s->dma[d].XferHalfCpltCallback;break;
case 2:f=s->dma[d].XferErrorCallback;break;
case 3:f=s->dma[d].XferAbortCallback;break;
case 4:f=s->dma[d].XferSuspendCallback;break;
default:assert(0);break;}for(uint32_t k=0;k<=10;k++)if(1&&f==IRDA_DMAFunction(k))return k;assert(0);return 0;}
void F_JOIN(F_VARIANT,_SetDMA)(CIRDAState *s,uint32_t d,uint32_t id,uint32_t v) {switch(id) {
case 0:s->dma[d].XferCpltCallback=IRDA_DMAFunction(v);break;
case 1:s->dma[d].XferHalfCpltCallback=IRDA_DMAFunction(v);break;
case 2:s->dma[d].XferErrorCallback=IRDA_DMAFunction(v);break;
case 3:s->dma[d].XferAbortCallback=IRDA_DMAFunction(v);break;
case 4:s->dma[d].XferSuspendCallback=IRDA_DMAFunction(v);break;
default:assert(0);break;} }
uint32_t F_JOIN(F_VARIANT,_Run)(CIRDAState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {
uint8_t *tx=c&1?NULL:(uint8_t *)s->buffers[0];uint8_t *rx=c&2?NULL:(uint8_t *)s->buffers[1];switch(op) {
case 0:return HAL_IRDA_Init(&s->h);
case 1:return HAL_IRDA_DeInit(&s->h);
#if F_MODE
case 2:return HAL_IRDA_RegisterCallback(&s->h,(HAL_IRDA_CallbackIDTypeDef)a,CIRDA_CallbackPointer(a<10?a:0,b));
#endif
#if F_MODE
case 3:return HAL_IRDA_UnRegisterCallback(&s->h,(HAL_IRDA_CallbackIDTypeDef)a);
#endif
case 4:return HAL_IRDA_Transmit(&s->h,tx,(uint16_t)a,b);
case 5:return HAL_IRDA_Receive(&s->h,rx,(uint16_t)a,b);
case 6:return HAL_IRDA_Transmit_IT(&s->h,tx,(uint16_t)a);
case 7:return HAL_IRDA_Receive_IT(&s->h,rx,(uint16_t)a);
case 8:return HAL_IRDA_Transmit_DMA(&s->h,tx,(uint16_t)a);
case 9:return HAL_IRDA_Receive_DMA(&s->h,rx,(uint16_t)a);
case 10:return HAL_IRDA_DMAPause(&s->h);
case 11:return HAL_IRDA_DMAResume(&s->h);
case 12:return HAL_IRDA_DMAStop(&s->h);
case 13:return HAL_IRDA_Abort(&s->h);
case 14:return HAL_IRDA_AbortTransmit(&s->h);
case 15:return HAL_IRDA_AbortReceive(&s->h);
case 16:return HAL_IRDA_Abort_IT(&s->h);
case 17:return HAL_IRDA_AbortTransmit_IT(&s->h);
case 18:return HAL_IRDA_AbortReceive_IT(&s->h);
case 19:HAL_IRDA_IRQHandler(&s->h);return 0;
case 20:return HAL_IRDA_GetState(&s->h);
case 21:return HAL_IRDA_GetError(&s->h);
#if F_MODE
case 22:IRDA_InitCallbacksToDefault(&s->h);return 0;
#endif
case 23:return IRDA_SetConfig(&s->h);
case 24:return IRDA_CheckIdleState(&s->h);
case 25:return IRDA_WaitOnFlagUntilTimeout(&s->h,a,(FlagStatus)b,s->control[12],c);
case 26:IRDA_EndTxTransfer(&s->h);return 0;
case 27:IRDA_EndRxTransfer(&s->h);return 0;
case 28:IRDA_DMATransmitCplt(&s->dma[a]);return 0;
case 29:IRDA_DMATransmitHalfCplt(&s->dma[a]);return 0;
case 30:IRDA_DMAReceiveCplt(&s->dma[a]);return 0;
case 31:IRDA_DMAReceiveHalfCplt(&s->dma[a]);return 0;
case 32:IRDA_DMAError(&s->dma[a]);return 0;
case 33:IRDA_DMAAbortOnError(&s->dma[a]);return 0;
case 34:IRDA_DMATxAbortCallback(&s->dma[a]);return 0;
case 35:IRDA_DMARxAbortCallback(&s->dma[a]);return 0;
case 36:IRDA_DMATxOnlyAbortCallback(&s->dma[a]);return 0;
case 37:IRDA_DMARxOnlyAbortCallback(&s->dma[a]);return 0;
case 38:IRDA_Transmit_IT(&s->h);return 0;
case 39:IRDA_EndTransmit_IT(&s->h);return 0;
case 40:IRDA_Receive_IT(&s->h);return 0;
case 100:return __HAL_IRDA_GET_FLAG(&s->h,a);
case 101:__HAL_IRDA_CLEAR_FLAG(&s->h,a);return 0;
case 102:__HAL_IRDA_ENABLE_IT(&s->h,a);return 0;
case 103:__HAL_IRDA_DISABLE_IT(&s->h,a);return 0;
case 104:return __HAL_IRDA_GET_IT(&s->h,a);
case 105:return __HAL_IRDA_GET_IT_SOURCE(&s->h,a);
case 106:__HAL_IRDA_SEND_REQ(&s->h,a);return 0;
case 107:__HAL_IRDA_ONE_BIT_SAMPLE_ENABLE(&s->h);return 0;
case 108:__HAL_IRDA_ONE_BIT_SAMPLE_DISABLE(&s->h);return 0;
case 109:__HAL_IRDA_ENABLE(&s->h);return 0;
case 110:__HAL_IRDA_DISABLE(&s->h);return 0;
case 111:
#if F_MODE
__HAL_IRDA_RESET_HANDLE_STATE(&s->h);
#else
s->h.gState=HAL_IRDA_STATE_RESET;s->h.RxState=HAL_IRDA_STATE_RESET;
#endif
return 0;
case 112:__HAL_IRDA_FLUSH_DRREGISTER(&s->h);return 0;
case 113:__HAL_IRDA_CLEAR_IT(&s->h,a);return 0;
case 114:IRDA_MASK_COMPUTATION(&s->h);return 0;
default:assert(0);return 0;} }
