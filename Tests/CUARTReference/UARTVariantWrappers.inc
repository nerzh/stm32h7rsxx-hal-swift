/* Test-only accessors and entry points around unchanged source bodies. */
#define LOCAL(name) CUART_JOIN(CUART_VARIANT,name)
static void UserCallback0_2(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,0,2,0); }
static void UserCallback0_3(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,0,3,0); }
static void UserCallback1_2(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,1,2,0); }
static void UserCallback1_3(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,1,3,0); }
static void UserCallback2_2(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,2,2,0); }
static void UserCallback2_3(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,2,3,0); }
static void UserCallback3_2(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,3,2,0); }
static void UserCallback3_3(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,3,3,0); }
static void UserCallback4_2(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,4,2,0); }
static void UserCallback4_3(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,4,3,0); }
static void UserCallback5_2(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,5,2,0); }
static void UserCallback5_3(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,5,3,0); }
static void UserCallback6_2(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,6,2,0); }
static void UserCallback6_3(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,6,3,0); }
static void UserCallback7_2(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,7,2,0); }
static void UserCallback7_3(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,7,3,0); }
static void UserCallback8_2(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,8,2,0); }
static void UserCallback8_3(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,8,3,0); }
static void UserCallback9_2(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,9,2,0); }
static void UserCallback9_3(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,9,3,0); }
static void UserCallback10_2(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,10,2,0); }
static void UserCallback10_3(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,10,3,0); }
static void UserCallback11_2(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,11,2,0); }
static void UserCallback11_3(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,11,3,0); }
static void UserCallback12_2(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,12,2,0); }
static void UserCallback12_3(UART_HandleTypeDef *h) { CUART_DispatchCallback(h,12,3,0); }
static void UserCallback13_2(UART_HandleTypeDef *h, uint16_t position) { CUART_DispatchCallback(h,13,2,position); }
static void UserCallback13_3(UART_HandleTypeDef *h, uint16_t position) { CUART_DispatchCallback(h,13,3,position); }
static pUART_CallbackTypeDef CallbackPointer(uint32_t id, uint32_t implementation) {
 if (!implementation) return NULL;
 switch(id) {
 case 0: return implementation==1 ? HAL_UART_TxHalfCpltCallback : implementation==2 ? UserCallback0_2 : UserCallback0_3;
 case 1: return implementation==1 ? HAL_UART_TxCpltCallback : implementation==2 ? UserCallback1_2 : UserCallback1_3;
 case 2: return implementation==1 ? HAL_UART_RxHalfCpltCallback : implementation==2 ? UserCallback2_2 : UserCallback2_3;
 case 3: return implementation==1 ? HAL_UART_RxCpltCallback : implementation==2 ? UserCallback3_2 : UserCallback3_3;
 case 4: return implementation==1 ? HAL_UART_ErrorCallback : implementation==2 ? UserCallback4_2 : UserCallback4_3;
 case 5: return implementation==1 ? HAL_UART_AbortCpltCallback : implementation==2 ? UserCallback5_2 : UserCallback5_3;
 case 6: return implementation==1 ? HAL_UART_AbortTransmitCpltCallback : implementation==2 ? UserCallback6_2 : UserCallback6_3;
 case 7: return implementation==1 ? HAL_UART_AbortReceiveCpltCallback : implementation==2 ? UserCallback7_2 : UserCallback7_3;
 case 8: return implementation==1 ? HAL_UARTEx_WakeupCallback : implementation==2 ? UserCallback8_2 : UserCallback8_3;
 case 9: return implementation==1 ? HAL_UARTEx_RxFifoFullCallback : implementation==2 ? UserCallback9_2 : UserCallback9_3;
 case 10: return implementation==1 ? HAL_UARTEx_TxFifoEmptyCallback : implementation==2 ? UserCallback10_2 : UserCallback10_3;
 case 11: return implementation==1 ? HAL_UART_MspInit : implementation==2 ? UserCallback11_2 : UserCallback11_3;
 case 12: return implementation==1 ? HAL_UART_MspDeInit : implementation==2 ? UserCallback12_2 : UserCallback12_3;
 default: return UserCallback0_2;
 }
}
static pUART_RxEventCallbackTypeDef RxEventPointer(uint32_t implementation) { return !implementation ? NULL : implementation==1 ? HAL_UARTEx_RxEventCallback : implementation==2 ? UserCallback13_2 : UserCallback13_3; }
uint32_t LOCAL(_GetCallbackInternal)(const UART_HandleTypeDef *h, uint32_t id) {
#if CUART_CALLBACK_MODE
 if(id==0) { if(!h->TxHalfCpltCallback)return 0; for(uint32_t n=1;n<=3;n++)if(h->TxHalfCpltCallback==CallbackPointer(id,n))return n; return UINT32_MAX; }
 if(id==1) { if(!h->TxCpltCallback)return 0; for(uint32_t n=1;n<=3;n++)if(h->TxCpltCallback==CallbackPointer(id,n))return n; return UINT32_MAX; }
 if(id==2) { if(!h->RxHalfCpltCallback)return 0; for(uint32_t n=1;n<=3;n++)if(h->RxHalfCpltCallback==CallbackPointer(id,n))return n; return UINT32_MAX; }
 if(id==3) { if(!h->RxCpltCallback)return 0; for(uint32_t n=1;n<=3;n++)if(h->RxCpltCallback==CallbackPointer(id,n))return n; return UINT32_MAX; }
 if(id==4) { if(!h->ErrorCallback)return 0; for(uint32_t n=1;n<=3;n++)if(h->ErrorCallback==CallbackPointer(id,n))return n; return UINT32_MAX; }
 if(id==5) { if(!h->AbortCpltCallback)return 0; for(uint32_t n=1;n<=3;n++)if(h->AbortCpltCallback==CallbackPointer(id,n))return n; return UINT32_MAX; }
 if(id==6) { if(!h->AbortTransmitCpltCallback)return 0; for(uint32_t n=1;n<=3;n++)if(h->AbortTransmitCpltCallback==CallbackPointer(id,n))return n; return UINT32_MAX; }
 if(id==7) { if(!h->AbortReceiveCpltCallback)return 0; for(uint32_t n=1;n<=3;n++)if(h->AbortReceiveCpltCallback==CallbackPointer(id,n))return n; return UINT32_MAX; }
 if(id==8) { if(!h->WakeupCallback)return 0; for(uint32_t n=1;n<=3;n++)if(h->WakeupCallback==CallbackPointer(id,n))return n; return UINT32_MAX; }
 if(id==9) { if(!h->RxFifoFullCallback)return 0; for(uint32_t n=1;n<=3;n++)if(h->RxFifoFullCallback==CallbackPointer(id,n))return n; return UINT32_MAX; }
 if(id==10) { if(!h->TxFifoEmptyCallback)return 0; for(uint32_t n=1;n<=3;n++)if(h->TxFifoEmptyCallback==CallbackPointer(id,n))return n; return UINT32_MAX; }
 if(id==11) { if(!h->MspInitCallback)return 0; for(uint32_t n=1;n<=3;n++)if(h->MspInitCallback==CallbackPointer(id,n))return n; return UINT32_MAX; }
 if(id==12) { if(!h->MspDeInitCallback)return 0; for(uint32_t n=1;n<=3;n++)if(h->MspDeInitCallback==CallbackPointer(id,n))return n; return UINT32_MAX; }
 if(id==13) { if(!h->RxEventCallback)return 0; for(uint32_t n=1;n<=3;n++)if(h->RxEventCallback==RxEventPointer(n))return n; return UINT32_MAX; }
#else
 (void)h;(void)id;
#endif
 return 0;
}
void LOCAL(_SetCallbackInternal)(UART_HandleTypeDef *h, uint32_t id, uint32_t implementation) {
#if CUART_CALLBACK_MODE
 switch(id) {
 case 0:h->TxHalfCpltCallback=CallbackPointer(id,implementation);break;
 case 1:h->TxCpltCallback=CallbackPointer(id,implementation);break;
 case 2:h->RxHalfCpltCallback=CallbackPointer(id,implementation);break;
 case 3:h->RxCpltCallback=CallbackPointer(id,implementation);break;
 case 4:h->ErrorCallback=CallbackPointer(id,implementation);break;
 case 5:h->AbortCpltCallback=CallbackPointer(id,implementation);break;
 case 6:h->AbortTransmitCpltCallback=CallbackPointer(id,implementation);break;
 case 7:h->AbortReceiveCpltCallback=CallbackPointer(id,implementation);break;
 case 8:h->WakeupCallback=CallbackPointer(id,implementation);break;
 case 9:h->RxFifoFullCallback=CallbackPointer(id,implementation);break;
 case 10:h->TxFifoEmptyCallback=CallbackPointer(id,implementation);break;
 case 11:h->MspInitCallback=CallbackPointer(id,implementation);break;
 case 12:h->MspDeInitCallback=CallbackPointer(id,implementation);break;
 case 13:h->RxEventCallback=RxEventPointer(implementation);break;default:break; }
#else
 (void)h;(void)id;(void)implementation;
#endif
}
uint32_t LOCAL(_GetWordInternal)(const UART_HandleTypeDef *h, uint32_t word) { switch(word) {
 case 0:return (uint32_t)h->Init.BaudRate;
 case 1:return (uint32_t)h->Init.WordLength;
 case 2:return (uint32_t)h->Init.StopBits;
 case 3:return (uint32_t)h->Init.Parity;
 case 4:return (uint32_t)h->Init.Mode;
 case 5:return (uint32_t)h->Init.HwFlowCtl;
 case 6:return (uint32_t)h->Init.OverSampling;
 case 7:return (uint32_t)h->Init.OneBitSampling;
 case 8:return (uint32_t)h->Init.ClockPrescaler;
 case 9:return (uint32_t)h->AdvancedInit.AdvFeatureInit;
 case 10:return (uint32_t)h->AdvancedInit.TxPinLevelInvert;
 case 11:return (uint32_t)h->AdvancedInit.RxPinLevelInvert;
 case 12:return (uint32_t)h->AdvancedInit.DataInvert;
 case 13:return (uint32_t)h->AdvancedInit.Swap;
 case 14:return (uint32_t)h->AdvancedInit.OverrunDisable;
 case 15:return (uint32_t)h->AdvancedInit.DMADisableonRxError;
 case 16:return (uint32_t)h->AdvancedInit.AutoBaudRateEnable;
 case 17:return (uint32_t)h->AdvancedInit.AutoBaudRateMode;
 case 18:return (uint32_t)h->AdvancedInit.MSBFirst;
 case 19:return (uint32_t)h->TxXferSize;
 case 20:return (uint32_t)h->TxXferCount;
 case 21:return (uint32_t)h->RxXferSize;
 case 22:return (uint32_t)h->RxXferCount;
 case 23:return (uint32_t)h->Mask;
 case 24:return (uint32_t)h->NbRxDataToProcess;
 case 25:return (uint32_t)h->NbTxDataToProcess;
 case 26:return (uint32_t)h->FifoMode;
 case 27:return (uint32_t)h->ReceptionType;
 case 28:return (uint32_t)h->RxEventType;
 case 29:return (uint32_t)h->Lock;
 case 30:return (uint32_t)h->gState;
 case 31:return (uint32_t)h->RxState;
 case 32:return (uint32_t)h->ErrorCode;
 case 33:if(!h->RxISR)return 0;if(h->RxISR==UART_RxISR_8BIT)return 1;if(h->RxISR==UART_RxISR_16BIT)return 2;if(h->RxISR==UART_RxISR_8BIT_FIFOEN)return 3;if(h->RxISR==UART_RxISR_16BIT_FIFOEN)return 4;return UINT32_MAX;
 case 34:if(!h->TxISR)return 0;if(h->TxISR==UART_TxISR_8BIT)return 1;if(h->TxISR==UART_TxISR_16BIT)return 2;if(h->TxISR==UART_TxISR_8BIT_FIFOEN)return 3;if(h->TxISR==UART_TxISR_16BIT_FIFOEN)return 4;return UINT32_MAX;
 default:return 0; } }
void LOCAL(_SetWordInternal)(UART_HandleTypeDef *h,uint32_t word,uint32_t value) { switch(word) {
 case 0:h->Init.BaudRate=value;break;
 case 1:h->Init.WordLength=value;break;
 case 2:h->Init.StopBits=value;break;
 case 3:h->Init.Parity=value;break;
 case 4:h->Init.Mode=value;break;
 case 5:h->Init.HwFlowCtl=value;break;
 case 6:h->Init.OverSampling=value;break;
 case 7:h->Init.OneBitSampling=value;break;
 case 8:h->Init.ClockPrescaler=value;break;
 case 9:h->AdvancedInit.AdvFeatureInit=value;break;
 case 10:h->AdvancedInit.TxPinLevelInvert=value;break;
 case 11:h->AdvancedInit.RxPinLevelInvert=value;break;
 case 12:h->AdvancedInit.DataInvert=value;break;
 case 13:h->AdvancedInit.Swap=value;break;
 case 14:h->AdvancedInit.OverrunDisable=value;break;
 case 15:h->AdvancedInit.DMADisableonRxError=value;break;
 case 16:h->AdvancedInit.AutoBaudRateEnable=value;break;
 case 17:h->AdvancedInit.AutoBaudRateMode=value;break;
 case 18:h->AdvancedInit.MSBFirst=value;break;
 case 19:h->TxXferSize=(uint16_t)value;break;
 case 20:h->TxXferCount=(uint16_t)value;break;
 case 21:h->RxXferSize=(uint16_t)value;break;
 case 22:h->RxXferCount=(uint16_t)value;break;
 case 23:h->Mask=(uint16_t)value;break;
 case 24:h->NbRxDataToProcess=(uint16_t)value;break;
 case 25:h->NbTxDataToProcess=(uint16_t)value;break;
 case 26:h->FifoMode=value;break;
 case 27:h->ReceptionType=value;break;
 case 28:h->RxEventType=value;break;
 case 29:h->Lock=value;break;
 case 30:h->gState=value;break;
 case 31:h->RxState=value;break;
 case 32:h->ErrorCode=value;break;
 case 33:switch(value) { case 0:h->RxISR=NULL;break;case 1:h->RxISR=UART_RxISR_8BIT;break;case 2:h->RxISR=UART_RxISR_16BIT;break;case 3:h->RxISR=UART_RxISR_8BIT_FIFOEN;break;case 4:h->RxISR=UART_RxISR_16BIT_FIFOEN;break;default:assert(0);break;}break;
 case 34:switch(value) { case 0:h->TxISR=NULL;break;case 1:h->TxISR=UART_TxISR_8BIT;break;case 2:h->TxISR=UART_TxISR_16BIT;break;case 3:h->TxISR=UART_TxISR_8BIT_FIFOEN;break;case 4:h->TxISR=UART_TxISR_16BIT_FIFOEN;break;default:assert(0);break;}break;
 default:assert(0);break; } }
typedef void (*DMACallback)(DMA_HandleTypeDef *);
static DMACallback DMAEventPointer(uint32_t eventPlusOne) { switch(eventPlusOne) { case 0:return NULL;
 case 1:return UART_DMATransmitCplt;
 case 2:return UART_DMATxHalfCplt;
 case 3:return UART_DMAReceiveCplt;
 case 4:return UART_DMARxHalfCplt;
 case 5:return UART_DMAError;
 case 6:return UART_DMAAbortOnError;
 case 7:return UART_DMATxAbortCallback;
 case 8:return UART_DMARxAbortCallback;
 case 9:return UART_DMATxOnlyAbortCallback;
 case 10:return UART_DMARxOnlyAbortCallback;
default:assert(0);return NULL;} }
void LOCAL(_InvokeDMAInternal)(DMA_HandleTypeDef *h,uint32_t kind) { DMAEventPointer(kind+1)(h); }
uint32_t LOCAL(_GetDMACallbackInternal)(const DMA_HandleTypeDef *h,uint32_t id) { DMACallback cb=NULL;switch(id) {
case 0:cb=h->XferCpltCallback;break;
case 1:cb=h->XferHalfCpltCallback;break;
case 2:cb=h->XferErrorCallback;break;
case 3:cb=h->XferAbortCallback;break;
case 4:cb=h->XferSuspendCallback;break;
default:assert(0);break;}if(!cb)return 0;for(uint32_t k=1;k<=10;k++)if(cb==DMAEventPointer(k))return k;return UINT32_MAX;}
void LOCAL(_SetDMACallbackInternal)(DMA_HandleTypeDef *h,uint32_t id,uint32_t eventPlusOne) { switch(id) {
case 0:h->XferCpltCallback=DMAEventPointer(eventPlusOne);break;
case 1:h->XferHalfCpltCallback=DMAEventPointer(eventPlusOne);break;
case 2:h->XferErrorCallback=DMAEventPointer(eventPlusOne);break;
case 3:h->XferAbortCallback=DMAEventPointer(eventPlusOne);break;
case 4:h->XferSuspendCallback=DMAEventPointer(eventPlusOne);break;
default:assert(0);break;}}
uint32_t LOCAL(_CallInternal)(UART_HandleTypeDef *h, CUARTOperation operation, uint32_t a,uint32_t b,uint32_t c,uint32_t d) {
uint32_t u=h ? CUART_FindUART(h) : 0;
uint8_t *tx=d ? NULL : (uint8_t *)((uintptr_t)CUART_Buffer(CUART_Active,u,0)+c);
uint8_t *rx=d ? NULL : (uint8_t *)((uintptr_t)CUART_Buffer(CUART_Active,u,1)+c);
switch(operation) {
 case CUART_Initialize:return (uint32_t)HAL_UART_Init(h);
 case CUART_InitializeHalfDuplex:return (uint32_t)HAL_HalfDuplex_Init(h);
 case CUART_InitializeLIN:return (uint32_t)HAL_LIN_Init(h,a);
 case CUART_InitializeMultiProcessor:return (uint32_t)HAL_MultiProcessor_Init(h,(uint8_t)a,b);
 case CUART_InitializeRS485:return (uint32_t)HAL_RS485Ex_Init(h,a,b,c);
 case CUART_Deinitialize:return (uint32_t)HAL_UART_DeInit(h);
 case CUART_Transmit:return (uint32_t)HAL_UART_Transmit(h,tx,(uint16_t)a,b);
 case CUART_Receive:return (uint32_t)HAL_UART_Receive(h,rx,(uint16_t)a,b);
 case CUART_TransmitInterrupt:return (uint32_t)HAL_UART_Transmit_IT(h,tx,(uint16_t)a);
 case CUART_ReceiveInterrupt:return (uint32_t)HAL_UART_Receive_IT(h,rx,(uint16_t)a);
 case CUART_TransmitDMA:return (uint32_t)HAL_UART_Transmit_DMA(h,tx,(uint16_t)a);
 case CUART_ReceiveDMA:return (uint32_t)HAL_UART_Receive_DMA(h,rx,(uint16_t)a);
 case CUART_PauseDMA:return (uint32_t)HAL_UART_DMAPause(h);
 case CUART_ResumeDMA:return (uint32_t)HAL_UART_DMAResume(h);
 case CUART_StopDMA:return (uint32_t)HAL_UART_DMAStop(h);
 case CUART_Abort:return (uint32_t)HAL_UART_Abort(h);
 case CUART_AbortTransmit:return (uint32_t)HAL_UART_AbortTransmit(h);
 case CUART_AbortReceive:return (uint32_t)HAL_UART_AbortReceive(h);
 case CUART_AbortInterrupt:return (uint32_t)HAL_UART_Abort_IT(h);
 case CUART_AbortTransmitInterrupt:return (uint32_t)HAL_UART_AbortTransmit_IT(h);
 case CUART_AbortReceiveInterrupt:return (uint32_t)HAL_UART_AbortReceive_IT(h);
 case CUART_EnableReceiverTimeout:return (uint32_t)HAL_UART_EnableReceiverTimeout(h);
 case CUART_DisableReceiverTimeout:return (uint32_t)HAL_UART_DisableReceiverTimeout(h);
 case CUART_EnableMuteMode:return (uint32_t)HAL_MultiProcessor_EnableMuteMode(h);
 case CUART_DisableMuteMode:return (uint32_t)HAL_MultiProcessor_DisableMuteMode(h);
 case CUART_EnableTransmitter:return (uint32_t)HAL_HalfDuplex_EnableTransmitter(h);
 case CUART_EnableReceiver:return (uint32_t)HAL_HalfDuplex_EnableReceiver(h);
 case CUART_SendBreak:return (uint32_t)HAL_LIN_SendBreak(h);
 case CUART_GetState:return (uint32_t)HAL_UART_GetState(h);
 case CUART_GetError:return (uint32_t)HAL_UART_GetError(h);
 case CUART_SetAddressLength:return (uint32_t)HAL_MultiProcessorEx_AddressLength_Set(h,a);
 case CUART_ConfigureStopModeWakeup:return (uint32_t)HAL_UARTEx_StopModeWakeUpSourceConfig(h,(UART_WakeUpTypeDef){a,(uint16_t)b,(uint8_t)c});
 case CUART_EnableStopMode:return (uint32_t)HAL_UARTEx_EnableStopMode(h);
 case CUART_DisableStopMode:return (uint32_t)HAL_UARTEx_DisableStopMode(h);
 case CUART_EnableFIFOMode:return (uint32_t)HAL_UARTEx_EnableFifoMode(h);
 case CUART_DisableFIFOMode:return (uint32_t)HAL_UARTEx_DisableFifoMode(h);
 case CUART_SetTransmitFIFOThreshold:return (uint32_t)HAL_UARTEx_SetTxFifoThreshold(h,a);
 case CUART_SetReceiveFIFOThreshold:return (uint32_t)HAL_UARTEx_SetRxFifoThreshold(h,a);
 case CUART_ReceiveToIdle:return (uint32_t)HAL_UARTEx_ReceiveToIdle(h,rx,(uint16_t)a,CUART_ReceivedCount(CUART_Active,u),b);
 case CUART_ReceiveToIdleInterrupt:return (uint32_t)HAL_UARTEx_ReceiveToIdle_IT(h,rx,(uint16_t)a);
 case CUART_ReceiveToIdleDMA:return (uint32_t)HAL_UARTEx_ReceiveToIdle_DMA(h,rx,(uint16_t)a);
 case CUART_GetRxEventType:return (uint32_t)HAL_UARTEx_GetRxEventType(h);
 case CUART_SetConfiguration:return (uint32_t)UART_SetConfig(h);
 case CUART_CheckIdleState:return (uint32_t)UART_CheckIdleState(h);
 case CUART_WaitOnFlag:return (uint32_t)UART_WaitOnFlagUntilTimeout(h,a,(FlagStatus)b,c,d);
 case CUART_HandleInterrupt:HAL_UART_IRQHandler(h);return 0;
 case CUART_ConfigureReceiverTimeout:HAL_UART_ReceiverTimeout_Config(h,a);return 0;
 case CUART_EnterMuteMode:HAL_MultiProcessor_EnterMuteMode(h);return 0;
#if CUART_CALLBACK_MODE
 case CUART_RegisterCallback:return HAL_UART_RegisterCallback(h,(HAL_UART_CallbackIDTypeDef)a,CallbackPointer(a,b));
 case CUART_UnregisterCallback:return HAL_UART_UnRegisterCallback(h,(HAL_UART_CallbackIDTypeDef)a);
 case CUART_RegisterRxEventCallback:return HAL_UART_RegisterRxEventCallback(h,RxEventPointer(a));
 case CUART_UnregisterRxEventCallback:return HAL_UART_UnRegisterRxEventCallback(h);
#endif
 default:assert(0);return UINT32_MAX;
} }
