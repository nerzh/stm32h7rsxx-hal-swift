static void (*USART_ISRPointer(uint32_t tx,uint32_t value))(USART_HandleTypeDef *) {
    if(!value)return NULL;
    if(tx) { switch(value) {
    case 1:return USART_TxISR_8BIT;
    case 2:return USART_TxISR_16BIT;
    case 3:return USART_TxISR_8BIT_FIFOEN;
    case 4:return USART_TxISR_16BIT_FIFOEN;
    default:assert(0);return NULL;}}
    switch(value) {
    case 1:return USART_RxISR_8BIT;
    case 2:return USART_RxISR_16BIT;
    case 3:return USART_RxISR_8BIT_FIFOEN;
    case 4:return USART_RxISR_16BIT_FIFOEN;
    default:assert(0);return NULL;}
}
uint32_t F_JOIN(F_VARIANT,_GetWord)(CUSARTState *s,uint32_t i) { switch(i) {
case 0:return s->h.Init.BaudRate;
case 1:return s->h.Init.WordLength;
case 2:return s->h.Init.StopBits;
case 3:return s->h.Init.Parity;
case 4:return s->h.Init.Mode;
case 5:return s->h.Init.CLKPolarity;
case 6:return s->h.Init.CLKPhase;
case 7:return s->h.Init.CLKLastBit;
case 8:return s->h.Init.ClockPrescaler;
case 9:return s->h.TxXferSize;
case 10:return s->h.TxXferCount;
case 11:return s->h.RxXferSize;
case 12:return s->h.RxXferCount;
case 13:return s->h.Mask;
case 14:return s->h.NbRxDataToProcess;
case 15:return s->h.NbTxDataToProcess;
case 16:return s->h.SlaveMode;
case 17:return s->h.FifoMode;
case 18:for(uint32_t k=0;k<=4;k++)if(s->h.RxISR==USART_ISRPointer(0,k))return k;assert(0);return 0;
case 19:for(uint32_t k=0;k<=4;k++)if(s->h.TxISR==USART_ISRPointer(1,k))return k;assert(0);return 0;
case 20:return s->h.Lock;
case 21:return s->h.State;
case 22:return s->h.ErrorCode;
default:assert(0);return 0;} }
void F_JOIN(F_VARIANT,_SetWord)(CUSARTState *s,uint32_t i,uint32_t v) {switch(i) {
case 0:s->h.Init.BaudRate=v;break;
case 1:s->h.Init.WordLength=v;break;
case 2:s->h.Init.StopBits=v;break;
case 3:s->h.Init.Parity=v;break;
case 4:s->h.Init.Mode=v;break;
case 5:s->h.Init.CLKPolarity=v;break;
case 6:s->h.Init.CLKPhase=v;break;
case 7:s->h.Init.CLKLastBit=v;break;
case 8:s->h.Init.ClockPrescaler=v;break;
case 9:s->h.TxXferSize=v;break;
case 10:s->h.TxXferCount=v;break;
case 11:s->h.RxXferSize=v;break;
case 12:s->h.RxXferCount=v;break;
case 13:s->h.Mask=v;break;
case 14:s->h.NbRxDataToProcess=v;break;
case 15:s->h.NbTxDataToProcess=v;break;
case 16:s->h.SlaveMode=v;break;
case 17:s->h.FifoMode=v;break;
case 18:s->h.RxISR=USART_ISRPointer(0,v);break;
case 19:s->h.TxISR=USART_ISRPointer(1,v);break;
case 20:s->h.Lock=v;break;
case 21:s->h.State=v;break;
case 22:s->h.ErrorCode=v;break;
default:assert(0);break;} }
static void (*USART_DMAFunction(uint32_t k))(DMA_HandleTypeDef *) {switch(k) {
case 0:return NULL;
case 1:return USART_DMATransmitCplt;
case 2:return USART_DMATxHalfCplt;
case 3:return USART_DMAReceiveCplt;
case 4:return USART_DMARxHalfCplt;
case 5:return USART_DMAError;
case 6:return USART_DMAAbortOnError;
case 7:return USART_DMATxAbortCallback;
case 8:return USART_DMARxAbortCallback;
default:assert(0);return NULL;} }
uint32_t F_JOIN(F_VARIANT,_GetDMA)(CUSARTState *s,uint32_t d,uint32_t id) { void (*f)(DMA_HandleTypeDef *)=NULL;switch(id) {
case 0:f=s->dma[d].XferCpltCallback;break;
case 1:f=s->dma[d].XferHalfCpltCallback;break;
case 2:f=s->dma[d].XferErrorCallback;break;
case 3:f=s->dma[d].XferAbortCallback;break;
case 4:f=s->dma[d].XferSuspendCallback;break;
default:assert(0);break;}for(uint32_t k=0;k<=8;k++)if(f==USART_DMAFunction(k))return k;assert(0);return 0;}
void F_JOIN(F_VARIANT,_SetDMA)(CUSARTState *s,uint32_t d,uint32_t id,uint32_t v) {switch(id) {
case 0:s->dma[d].XferCpltCallback=USART_DMAFunction(v);break;
case 1:s->dma[d].XferHalfCpltCallback=USART_DMAFunction(v);break;
case 2:s->dma[d].XferErrorCallback=USART_DMAFunction(v);break;
case 3:s->dma[d].XferAbortCallback=USART_DMAFunction(v);break;
case 4:s->dma[d].XferSuspendCallback=USART_DMAFunction(v);break;
default:assert(0);break;} }
uint32_t F_JOIN(F_VARIANT,_Run)(CUSARTState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {
uint8_t *tx=c&1?NULL:(uint8_t *)s->buffers[0];uint8_t *rx=c&2?NULL:(uint8_t *)s->buffers[1];switch(op) {
case 0:return HAL_USART_Init(&s->h);
case 1:return HAL_USART_DeInit(&s->h);
#if F_MODE
case 2:return HAL_USART_RegisterCallback(&s->h,(HAL_USART_CallbackIDTypeDef)a,CUSART_CallbackPointer(a<11?a:0,b));
#endif
#if F_MODE
case 3:return HAL_USART_UnRegisterCallback(&s->h,(HAL_USART_CallbackIDTypeDef)a);
#endif
case 4:return HAL_USART_Transmit(&s->h,tx,(uint16_t)a,b);
case 5:return HAL_USART_Receive(&s->h,rx,(uint16_t)a,b);
case 6:return HAL_USART_TransmitReceive(&s->h,tx,rx,(uint16_t)a,b);
case 7:return HAL_USART_Transmit_IT(&s->h,tx,(uint16_t)a);
case 8:return HAL_USART_Receive_IT(&s->h,rx,(uint16_t)a);
case 9:return HAL_USART_TransmitReceive_IT(&s->h,tx,rx,(uint16_t)a);
case 10:return HAL_USART_Transmit_DMA(&s->h,tx,(uint16_t)a);
case 11:return HAL_USART_Receive_DMA(&s->h,rx,(uint16_t)a);
case 12:return HAL_USART_TransmitReceive_DMA(&s->h,tx,rx,(uint16_t)a);
case 13:return HAL_USART_DMAPause(&s->h);
case 14:return HAL_USART_DMAResume(&s->h);
case 15:return HAL_USART_DMAStop(&s->h);
case 16:return HAL_USART_Abort(&s->h);
case 17:return HAL_USART_Abort_IT(&s->h);
case 18:HAL_USART_IRQHandler(&s->h);return 0;
case 19:return HAL_USART_GetState(&s->h);
case 20:return HAL_USART_GetError(&s->h);
#if F_MODE
case 21:USART_InitCallbacksToDefault(&s->h);return 0;
#endif
case 22:USART_EndTransfer(&s->h);return 0;
case 23:USART_DMATransmitCplt(&s->dma[a]);return 0;
case 24:USART_DMATxHalfCplt(&s->dma[a]);return 0;
case 25:USART_DMAReceiveCplt(&s->dma[a]);return 0;
case 26:USART_DMARxHalfCplt(&s->dma[a]);return 0;
case 27:USART_DMAError(&s->dma[a]);return 0;
case 28:USART_DMAAbortOnError(&s->dma[a]);return 0;
case 29:USART_DMATxAbortCallback(&s->dma[a]);return 0;
case 30:USART_DMARxAbortCallback(&s->dma[a]);return 0;
case 31:return USART_WaitOnFlagUntilTimeout(&s->h,a,(FlagStatus)b,s->control[12],c);
case 32:return USART_SetConfig(&s->h);
case 33:return USART_CheckIdleState(&s->h);
case 34:USART_TxISR_8BIT(&s->h);return 0;
case 35:USART_TxISR_16BIT(&s->h);return 0;
case 36:USART_TxISR_8BIT_FIFOEN(&s->h);return 0;
case 37:USART_TxISR_16BIT_FIFOEN(&s->h);return 0;
case 38:USART_EndTransmit_IT(&s->h);return 0;
case 39:USART_RxISR_8BIT(&s->h);return 0;
case 40:USART_RxISR_16BIT(&s->h);return 0;
case 41:USART_RxISR_8BIT_FIFOEN(&s->h);return 0;
case 42:USART_RxISR_16BIT_FIFOEN(&s->h);return 0;
case 43:return HAL_USARTEx_EnableSlaveMode(&s->h);
case 44:return HAL_USARTEx_DisableSlaveMode(&s->h);
case 45:return HAL_USARTEx_ConfigNSS(&s->h,a);
case 46:return HAL_USARTEx_EnableFifoMode(&s->h);
case 47:return HAL_USARTEx_DisableFifoMode(&s->h);
case 48:return HAL_USARTEx_SetTxFifoThreshold(&s->h,a);
case 49:return HAL_USARTEx_SetRxFifoThreshold(&s->h,a);
case 50:USARTEx_SetNbDataToProcess(&s->h);return 0;
case 100:return __HAL_USART_GET_FLAG(&s->h,a);
case 101:__HAL_USART_CLEAR_FLAG(&s->h,a);return 0;
case 102:__HAL_USART_ENABLE_IT(&s->h,a);return 0;
case 103:__HAL_USART_DISABLE_IT(&s->h,a);return 0;
case 104:return __HAL_USART_GET_IT(&s->h,a);
case 105:return __HAL_USART_GET_IT_SOURCE(&s->h,a);
case 106:__HAL_USART_SEND_REQ(&s->h,a);return 0;
case 107:__HAL_USART_ONE_BIT_SAMPLE_ENABLE(&s->h);return 0;
case 108:__HAL_USART_ONE_BIT_SAMPLE_DISABLE(&s->h);return 0;
case 109:__HAL_USART_ENABLE(&s->h);return 0;
case 110:__HAL_USART_DISABLE(&s->h);return 0;
case 111:
#if F_MODE
__HAL_USART_RESET_HANDLE_STATE(&s->h);
#else
s->h.State=HAL_USART_STATE_RESET;
#endif
return 0;
default:assert(0);return 0;} }
