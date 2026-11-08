static void (*SMARTCARD_ISRPointer(uint32_t tx,uint32_t value))(SMARTCARD_HandleTypeDef *) {
    if(!value)return NULL;
    if(tx) { if(value==1)return SMARTCARD_TxISR;if(value==3)return SMARTCARD_TxISR_FIFOEN; }
    else { if(value==1)return SMARTCARD_RxISR;if(value==3)return SMARTCARD_RxISR_FIFOEN; }
    assert(0);return NULL;
}
uint32_t F_JOIN(F_VARIANT,_GetWord)(CSMARTCARDState *s,uint32_t i) { switch(i) {
case 0:return s->h.Init.BaudRate;
case 1:return s->h.Init.WordLength;
case 2:return s->h.Init.StopBits;
case 3:return s->h.Init.Parity;
case 4:return s->h.Init.Mode;
case 5:return s->h.Init.CLKPolarity;
case 6:return s->h.Init.CLKPhase;
case 7:return s->h.Init.CLKLastBit;
case 8:return s->h.Init.OneBitSampling;
case 9:return s->h.Init.Prescaler;
case 10:return s->h.Init.GuardTime;
case 11:return s->h.Init.NACKEnable;
case 12:return s->h.Init.TimeOutEnable;
case 13:return s->h.Init.TimeOutValue;
case 14:return s->h.Init.BlockLength;
case 15:return s->h.Init.AutoRetryCount;
case 16:return s->h.Init.ClockPrescaler;
case 17:return s->h.AdvancedInit.AdvFeatureInit;
case 18:return s->h.AdvancedInit.TxPinLevelInvert;
case 19:return s->h.AdvancedInit.RxPinLevelInvert;
case 20:return s->h.AdvancedInit.DataInvert;
case 21:return s->h.AdvancedInit.Swap;
case 22:return s->h.AdvancedInit.OverrunDisable;
case 23:return s->h.AdvancedInit.DMADisableonRxError;
case 24:return s->h.AdvancedInit.MSBFirst;
case 25:return s->h.AdvancedInit.TxCompletionIndication;
case 26:return s->h.TxXferSize;
case 27:return s->h.TxXferCount;
case 28:return s->h.RxXferSize;
case 29:return s->h.RxXferCount;
case 30:return s->h.NbRxDataToProcess;
case 31:return s->h.NbTxDataToProcess;
case 32:return s->h.FifoMode;
case 33:for(uint32_t k=0;k<=3;k++)if(k!=2&&s->h.RxISR==SMARTCARD_ISRPointer(0,k))return k;assert(0);return 0;
case 34:for(uint32_t k=0;k<=3;k++)if(k!=2&&s->h.TxISR==SMARTCARD_ISRPointer(1,k))return k;assert(0);return 0;
case 35:return s->h.Lock;
case 36:return s->h.gState;
case 37:return s->h.RxState;
case 38:return s->h.ErrorCode;
default:assert(0);return 0;} }
void F_JOIN(F_VARIANT,_SetWord)(CSMARTCARDState *s,uint32_t i,uint32_t v) {switch(i) {
case 0:s->h.Init.BaudRate=v;break;
case 1:s->h.Init.WordLength=v;break;
case 2:s->h.Init.StopBits=v;break;
case 3:s->h.Init.Parity=v;break;
case 4:s->h.Init.Mode=v;break;
case 5:s->h.Init.CLKPolarity=v;break;
case 6:s->h.Init.CLKPhase=v;break;
case 7:s->h.Init.CLKLastBit=v;break;
case 8:s->h.Init.OneBitSampling=v;break;
case 9:s->h.Init.Prescaler=v;break;
case 10:s->h.Init.GuardTime=v;break;
case 11:s->h.Init.NACKEnable=v;break;
case 12:s->h.Init.TimeOutEnable=v;break;
case 13:s->h.Init.TimeOutValue=v;break;
case 14:s->h.Init.BlockLength=v;break;
case 15:s->h.Init.AutoRetryCount=v;break;
case 16:s->h.Init.ClockPrescaler=v;break;
case 17:s->h.AdvancedInit.AdvFeatureInit=v;break;
case 18:s->h.AdvancedInit.TxPinLevelInvert=v;break;
case 19:s->h.AdvancedInit.RxPinLevelInvert=v;break;
case 20:s->h.AdvancedInit.DataInvert=v;break;
case 21:s->h.AdvancedInit.Swap=v;break;
case 22:s->h.AdvancedInit.OverrunDisable=v;break;
case 23:s->h.AdvancedInit.DMADisableonRxError=v;break;
case 24:s->h.AdvancedInit.MSBFirst=v;break;
case 25:s->h.AdvancedInit.TxCompletionIndication=v;break;
case 26:s->h.TxXferSize=v;break;
case 27:s->h.TxXferCount=v;break;
case 28:s->h.RxXferSize=v;break;
case 29:s->h.RxXferCount=v;break;
case 30:s->h.NbRxDataToProcess=v;break;
case 31:s->h.NbTxDataToProcess=v;break;
case 32:s->h.FifoMode=v;break;
case 33:s->h.RxISR=SMARTCARD_ISRPointer(0,v);break;
case 34:s->h.TxISR=SMARTCARD_ISRPointer(1,v);break;
case 35:s->h.Lock=v;break;
case 36:s->h.gState=v;break;
case 37:s->h.RxState=v;break;
case 38:s->h.ErrorCode=v;break;
default:assert(0);break;} }
static void (*SMARTCARD_DMAFunction(uint32_t k))(DMA_HandleTypeDef *) {switch(k) {
case 0:return NULL;
case 1:return SMARTCARD_DMATransmitCplt;
case 3:return SMARTCARD_DMAReceiveCplt;
case 5:return SMARTCARD_DMAError;
case 6:return SMARTCARD_DMAAbortOnError;
case 7:return SMARTCARD_DMATxAbortCallback;
case 8:return SMARTCARD_DMARxAbortCallback;
case 9:return SMARTCARD_DMATxOnlyAbortCallback;
case 10:return SMARTCARD_DMARxOnlyAbortCallback;
default:assert(0);return NULL;} }
uint32_t F_JOIN(F_VARIANT,_GetDMA)(CSMARTCARDState *s,uint32_t d,uint32_t id) { void (*f)(DMA_HandleTypeDef *)=NULL;switch(id) {
case 0:f=s->dma[d].XferCpltCallback;break;
case 1:f=s->dma[d].XferHalfCpltCallback;break;
case 2:f=s->dma[d].XferErrorCallback;break;
case 3:f=s->dma[d].XferAbortCallback;break;
case 4:f=s->dma[d].XferSuspendCallback;break;
default:assert(0);break;}for(uint32_t k=0;k<=10;k++)if(k!=2&&k!=4&&f==SMARTCARD_DMAFunction(k))return k;assert(0);return 0;}
void F_JOIN(F_VARIANT,_SetDMA)(CSMARTCARDState *s,uint32_t d,uint32_t id,uint32_t v) {switch(id) {
case 0:s->dma[d].XferCpltCallback=SMARTCARD_DMAFunction(v);break;
case 1:s->dma[d].XferHalfCpltCallback=SMARTCARD_DMAFunction(v);break;
case 2:s->dma[d].XferErrorCallback=SMARTCARD_DMAFunction(v);break;
case 3:s->dma[d].XferAbortCallback=SMARTCARD_DMAFunction(v);break;
case 4:s->dma[d].XferSuspendCallback=SMARTCARD_DMAFunction(v);break;
default:assert(0);break;} }
uint32_t F_JOIN(F_VARIANT,_Run)(CSMARTCARDState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {
uint8_t *tx=c&1?NULL:(uint8_t *)s->buffers[0];uint8_t *rx=c&2?NULL:(uint8_t *)s->buffers[1];switch(op) {
case 0:return HAL_SMARTCARD_Init(&s->h);
case 1:return HAL_SMARTCARD_DeInit(&s->h);
#if F_MODE
case 2:return HAL_SMARTCARD_RegisterCallback(&s->h,(HAL_SMARTCARD_CallbackIDTypeDef)a,CSMARTCARD_CallbackPointer(a<10?a:0,b));
#endif
#if F_MODE
case 3:return HAL_SMARTCARD_UnRegisterCallback(&s->h,(HAL_SMARTCARD_CallbackIDTypeDef)a);
#endif
case 4:return HAL_SMARTCARD_Transmit(&s->h,tx,(uint16_t)a,b);
case 5:return HAL_SMARTCARD_Receive(&s->h,rx,(uint16_t)a,b);
case 6:return HAL_SMARTCARD_Transmit_IT(&s->h,tx,(uint16_t)a);
case 7:return HAL_SMARTCARD_Receive_IT(&s->h,rx,(uint16_t)a);
case 8:return HAL_SMARTCARD_Transmit_DMA(&s->h,tx,(uint16_t)a);
case 9:return HAL_SMARTCARD_Receive_DMA(&s->h,rx,(uint16_t)a);
case 10:return HAL_SMARTCARD_Abort(&s->h);
case 11:return HAL_SMARTCARD_AbortTransmit(&s->h);
case 12:return HAL_SMARTCARD_AbortReceive(&s->h);
case 13:return HAL_SMARTCARD_Abort_IT(&s->h);
case 14:return HAL_SMARTCARD_AbortTransmit_IT(&s->h);
case 15:return HAL_SMARTCARD_AbortReceive_IT(&s->h);
case 16:HAL_SMARTCARD_IRQHandler(&s->h);return 0;
case 17:return HAL_SMARTCARD_GetState(&s->h);
case 18:return HAL_SMARTCARD_GetError(&s->h);
#if F_MODE
case 19:SMARTCARD_InitCallbacksToDefault(&s->h);return 0;
#endif
case 20:return SMARTCARD_SetConfig(&s->h);
case 21:SMARTCARD_AdvFeatureConfig(&s->h);return 0;
case 22:return SMARTCARD_CheckIdleState(&s->h);
case 23:return SMARTCARD_WaitOnFlagUntilTimeout(&s->h,a,(FlagStatus)b,s->control[12],c);
case 24:SMARTCARD_EndTxTransfer(&s->h);return 0;
case 25:SMARTCARD_EndRxTransfer(&s->h);return 0;
case 26:SMARTCARD_DMATransmitCplt(&s->dma[a]);return 0;
case 27:SMARTCARD_DMAReceiveCplt(&s->dma[a]);return 0;
case 28:SMARTCARD_DMAError(&s->dma[a]);return 0;
case 29:SMARTCARD_DMAAbortOnError(&s->dma[a]);return 0;
case 30:SMARTCARD_DMATxAbortCallback(&s->dma[a]);return 0;
case 31:SMARTCARD_DMARxAbortCallback(&s->dma[a]);return 0;
case 32:SMARTCARD_DMATxOnlyAbortCallback(&s->dma[a]);return 0;
case 33:SMARTCARD_DMARxOnlyAbortCallback(&s->dma[a]);return 0;
case 34:SMARTCARD_TxISR(&s->h);return 0;
case 35:SMARTCARD_TxISR_FIFOEN(&s->h);return 0;
case 36:SMARTCARD_EndTransmit_IT(&s->h);return 0;
case 37:SMARTCARD_RxISR(&s->h);return 0;
case 38:SMARTCARD_RxISR_FIFOEN(&s->h);return 0;
case 39:HAL_SMARTCARDEx_BlockLength_Config(&s->h,(uint8_t)a);return 0;
case 40:HAL_SMARTCARDEx_TimeOut_Config(&s->h,a);return 0;
case 41:return HAL_SMARTCARDEx_EnableReceiverTimeOut(&s->h);
case 42:return HAL_SMARTCARDEx_DisableReceiverTimeOut(&s->h);
case 43:return HAL_SMARTCARDEx_EnableFifoMode(&s->h);
case 44:return HAL_SMARTCARDEx_DisableFifoMode(&s->h);
case 45:return HAL_SMARTCARDEx_SetTxFifoThreshold(&s->h,a);
case 46:return HAL_SMARTCARDEx_SetRxFifoThreshold(&s->h,a);
case 47:SMARTCARDEx_SetNbDataToProcess(&s->h);return 0;
case 100:return __HAL_SMARTCARD_GET_FLAG(&s->h,a);
case 101:__HAL_SMARTCARD_CLEAR_FLAG(&s->h,a);return 0;
case 102:__HAL_SMARTCARD_ENABLE_IT(&s->h,a);return 0;
case 103:__HAL_SMARTCARD_DISABLE_IT(&s->h,a);return 0;
case 104:return __HAL_SMARTCARD_GET_IT(&s->h,a);
case 105:return __HAL_SMARTCARD_GET_IT_SOURCE(&s->h,a);
case 106:__HAL_SMARTCARD_SEND_REQ(&s->h,a);return 0;
case 107:__HAL_SMARTCARD_ONE_BIT_SAMPLE_ENABLE(&s->h);return 0;
case 108:__HAL_SMARTCARD_ONE_BIT_SAMPLE_DISABLE(&s->h);return 0;
case 109:__HAL_SMARTCARD_ENABLE(&s->h);return 0;
case 110:__HAL_SMARTCARD_DISABLE(&s->h);return 0;
case 111:
#if F_MODE
__HAL_SMARTCARD_RESET_HANDLE_STATE(&s->h);
#else
s->h.gState=HAL_SMARTCARD_STATE_RESET;s->h.RxState=HAL_SMARTCARD_STATE_RESET;
#endif
return 0;
case 112:__HAL_SMARTCARD_FLUSH_DRREGISTER(&s->h);return 0;
case 113:__HAL_SMARTCARD_CLEAR_IT(&s->h,a);return 0;
case 114:SMARTCARD_TRANSMISSION_COMPLETION_SETTING(&s->h);return 0;
case 115:return SMARTCARD_TRANSMISSION_COMPLETION_FLAG(&s->h);
default:assert(0);return 0;} }
