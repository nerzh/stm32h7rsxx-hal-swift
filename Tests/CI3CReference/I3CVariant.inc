#include "I3CPrototypes.h"
static HAL_StatusTypeDef (*ISRPointer(uint32_t i))(I3C_HandleTypeDef *,uint32_t) {switch(i){case 0:return NULL;
case 1:return I3C_Tgt_Event_ISR;
case 2:return I3C_Ctrl_Event_ISR;
case 3:return I3C_Tgt_HotJoin_ISR;
case 4:return I3C_Tgt_CtrlRole_ISR;
case 5:return I3C_Tgt_IBI_ISR;
case 6:return I3C_Tgt_Tx_ISR;
case 7:return I3C_Tgt_Rx_ISR;
case 8:return I3C_Tgt_Tx_DMA_ISR;
case 9:return I3C_Tgt_Rx_DMA_ISR;
case 10:return I3C_Ctrl_Tx_ISR;
case 11:return I3C_Ctrl_Rx_ISR;
case 12:return I3C_Ctrl_Multiple_Xfer_ISR;
case 13:return I3C_Ctrl_Tx_Listen_Event_ISR;
case 14:return I3C_Ctrl_Rx_Listen_Event_ISR;
case 15:return I3C_Ctrl_Multiple_Xfer_Listen_Event_ISR;
case 16:return I3C_Ctrl_DAA_ISR;
case 17:return I3C_Ctrl_Tx_DMA_ISR;
case 18:return I3C_Ctrl_Rx_DMA_ISR;
case 19:return I3C_Ctrl_Multiple_Xfer_DMA_ISR;
case 20:return I3C_Abort_ISR;
default:assert(0);return NULL;}}
static void (*TxPointer(uint32_t i))(I3C_HandleTypeDef *) {switch(i){case 0:return NULL;case 1:return I3C_TransmitByteTreatment;case 2:return I3C_TransmitWordTreatment;default:assert(0);return NULL;}}
static void (*RxPointer(uint32_t i))(I3C_HandleTypeDef *) {switch(i){case 0:return NULL;case 1:return I3C_ReceiveByteTreatment;case 2:return I3C_ReceiveWordTreatment;default:assert(0);return NULL;}}
uint32_t F_JOIN(F_VARIANT,_GetWord)(CI3CState *s,uint32_t i){switch(i){
case 0:return s->h.Init.CtrlBusCharacteristic.SDAHoldTime;
case 1:return s->h.Init.CtrlBusCharacteristic.WaitTime;
case 2:return s->h.Init.CtrlBusCharacteristic.SCLPPLowDuration;
case 3:return s->h.Init.CtrlBusCharacteristic.SCLI3CHighDuration;
case 4:return s->h.Init.CtrlBusCharacteristic.SCLODLowDuration;
case 5:return s->h.Init.CtrlBusCharacteristic.SCLI2CHighDuration;
case 6:return s->h.Init.CtrlBusCharacteristic.BusFreeDuration;
case 7:return s->h.Init.CtrlBusCharacteristic.BusIdleDuration;
case 8:return s->h.Init.TgtBusCharacteristic.BusAvailableDuration;
case 9:return s->h.Mode;
case 10:return s->h.ControlXferCount;
case 11:return s->h.RxXferCount;
case 12:return s->h.TxXferCount;
case 13:return s->h.Lock;
case 14:return s->h.State;
case 15:return s->h.PreviousState;
case 16:return s->h.ErrorCode;
case 17:for(uint32_t k=0;k<=20;k++)if(s->h.XferISR==ISRPointer(k))return k;assert(0);return 0;
case 18:for(uint32_t k=0;k<=2;k++)if(s->h.ptrTxFunc==TxPointer(k))return k;assert(0);return 0;
case 19:for(uint32_t k=0;k<=2;k++)if(s->h.ptrRxFunc==RxPointer(k))return k;assert(0);return 0;
default:assert(0);return 0;}}
void F_JOIN(F_VARIANT,_SetWord)(CI3CState *s,uint32_t i,uint32_t v){switch(i){
case 0:s->h.Init.CtrlBusCharacteristic.SDAHoldTime=v;break;
case 1:s->h.Init.CtrlBusCharacteristic.WaitTime=v;break;
case 2:s->h.Init.CtrlBusCharacteristic.SCLPPLowDuration=v;break;
case 3:s->h.Init.CtrlBusCharacteristic.SCLI3CHighDuration=v;break;
case 4:s->h.Init.CtrlBusCharacteristic.SCLODLowDuration=v;break;
case 5:s->h.Init.CtrlBusCharacteristic.SCLI2CHighDuration=v;break;
case 6:s->h.Init.CtrlBusCharacteristic.BusFreeDuration=v;break;
case 7:s->h.Init.CtrlBusCharacteristic.BusIdleDuration=v;break;
case 8:s->h.Init.TgtBusCharacteristic.BusAvailableDuration=v;break;
case 9:s->h.Mode=v;break;
case 10:s->h.ControlXferCount=v;break;
case 11:s->h.RxXferCount=v;break;
case 12:s->h.TxXferCount=v;break;
case 13:s->h.Lock=v;break;
case 14:s->h.State=v;break;
case 15:s->h.PreviousState=v;break;
case 16:s->h.ErrorCode=v;break;
case 17:s->h.XferISR=ISRPointer(v);break;
case 18:s->h.ptrTxFunc=TxPointer(v);break;
case 19:s->h.ptrRxFunc=RxPointer(v);break;
default:assert(0);}}
static void (*DMAPointer(uint32_t i))(DMA_HandleTypeDef *){switch(i){case 0:return NULL;case 1:return I3C_DMAControlTransmitCplt;case 2:return I3C_DMADataTransmitCplt;case 3:return I3C_DMADataReceiveCplt;case 4:return I3C_DMAError;case 5:return I3C_DMAAbort;default:assert(0);return NULL;}}
uint32_t F_JOIN(F_VARIANT,_GetDMA)(CI3CState *s,uint32_t d,uint32_t id){void (*f)(DMA_HandleTypeDef *)=NULL;switch(id){case 0:f=s->dma[d].XferCpltCallback;break;case 1:f=s->dma[d].XferHalfCpltCallback;break;case 2:f=s->dma[d].XferErrorCallback;break;case 3:f=s->dma[d].XferAbortCallback;break;default:assert(0);}for(uint32_t k=0;k<=5;k++)if(f==DMAPointer(k))return k;assert(0);return 0;}
void F_JOIN(F_VARIANT,_SetDMA)(CI3CState *s,uint32_t d,uint32_t id,uint32_t v){switch(id){case 0:s->dma[d].XferCpltCallback=DMAPointer(v);break;case 1:s->dma[d].XferHalfCpltCallback=DMAPointer(v);break;case 2:s->dma[d].XferErrorCallback=DMAPointer(v);break;case 3:s->dma[d].XferAbortCallback=DMAPointer(v);break;default:assert(0);}}
uint32_t F_JOIN(F_VARIANT,_Run)(CI3CState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c,uint32_t d){switch(op){
case 0:return HAL_I3C_Init(&s->h);
case 1:return HAL_I3C_DeInit(&s->h);
#if F_MODE
case 2:return HAL_I3C_RegisterCallback(&s->h,a,(pI3C_CallbackTypeDef)CI3C_Callback(a<13?a:0,b));
#endif
#if F_MODE
case 3:return HAL_I3C_RegisterNotifyCallback(&s->h,(pI3C_NotifyCallbackTypeDef)CI3C_Callback(8,b));
#endif
#if F_MODE
case 4:return HAL_I3C_RegisterTgtReqDynamicAddrCallback(&s->h,(pI3C_TgtReqDynamicAddrCallbackTypeDef)CI3C_Callback(4,b));
#endif
#if F_MODE
case 5:return HAL_I3C_RegisterTgtHotJoinCallback(&s->h,(pI3C_TgtHotJoinCallbackTypeDef)CI3C_Callback(7,b));
#endif
#if F_MODE
case 6:return HAL_I3C_UnRegisterCallback(&s->h,a);
#endif
case 7:return HAL_I3C_ActivateNotification(&s->h,s->control[10]?NULL:&s->transfer,a);
case 8:return HAL_I3C_DeactivateNotification(&s->h,a);
case 9:HAL_I3C_ER_IRQHandler(&s->h);return 0;
case 10:HAL_I3C_EV_IRQHandler(&s->h);return 0;
case 11:return HAL_I3C_Ctrl_BusCharacteristicConfig(&s->h,s->control[13]?NULL:&s->controllerBus);
case 12:return HAL_I3C_Tgt_BusCharacteristicConfig(&s->h,s->control[13]?NULL:&s->targetBus);
case 13:return HAL_I3C_SetConfigFifo(&s->h,s->control[13]?NULL:&s->fifo);
case 14:return HAL_I3C_Ctrl_Config(&s->h,s->control[13]?NULL:&s->controller);
case 15:return HAL_I3C_Tgt_Config(&s->h,s->control[13]?NULL:&s->target);
case 16:return HAL_I3C_Ctrl_ConfigBusDevices(&s->h,s->control[13]?NULL:s->devices,a);
case 17:return HAL_I3C_AddDescToFrame(&s->h,s->control[11]?NULL:s->ccc,s->control[12]?NULL:s->private,s->control[10]?NULL:&s->transfer,a,b);
case 18:return HAL_I3C_Ctrl_SetConfigResetPattern(&s->h,a);
case 19:return HAL_I3C_Ctrl_GetConfigResetPattern(&s->h,s->control[13]?NULL:&s->outputReset);
case 20:return HAL_I3C_FlushAllFifo(&s->h);
case 21:return HAL_I3C_FlushTxFifo(&s->h);
case 22:return HAL_I3C_FlushRxFifo(&s->h);
case 23:return HAL_I3C_FlushControlFifo(&s->h);
case 24:return HAL_I3C_FlushStatusFifo(&s->h);
case 25:return HAL_I3C_ClearConfigFifo(&s->h);
case 26:return HAL_I3C_GetConfigFifo(&s->h,s->control[13]?NULL:&s->fifo);
case 27:return HAL_I3C_Ctrl_TransmitCCC(&s->h,s->control[10]?NULL:&s->transfer,a);
case 28:return HAL_I3C_Ctrl_TransmitCCC_IT(&s->h,s->control[10]?NULL:&s->transfer);
case 29:return HAL_I3C_Ctrl_TransmitCCC_DMA(&s->h,s->control[10]?NULL:&s->transfer);
case 30:return HAL_I3C_Ctrl_ReceiveCCC(&s->h,s->control[10]?NULL:&s->transfer,a);
case 31:return HAL_I3C_Ctrl_ReceiveCCC_IT(&s->h,s->control[10]?NULL:&s->transfer);
case 32:return HAL_I3C_Ctrl_ReceiveCCC_DMA(&s->h,s->control[10]?NULL:&s->transfer);
case 33:return HAL_I3C_Ctrl_Transmit(&s->h,s->control[10]?NULL:&s->transfer,a);
case 34:return HAL_I3C_Ctrl_Transmit_IT(&s->h,s->control[10]?NULL:&s->transfer);
case 35:return HAL_I3C_Ctrl_Transmit_DMA(&s->h,s->control[10]?NULL:&s->transfer);
case 36:return HAL_I3C_Ctrl_Receive(&s->h,s->control[10]?NULL:&s->transfer,a);
case 37:return HAL_I3C_Ctrl_Receive_IT(&s->h,s->control[10]?NULL:&s->transfer);
case 38:return HAL_I3C_Ctrl_Receive_DMA(&s->h,s->control[10]?NULL:&s->transfer);
case 39:return HAL_I3C_Ctrl_MultipleTransfer_IT(&s->h,s->control[10]?NULL:&s->transfer);
case 40:return HAL_I3C_Ctrl_MultipleTransfer_DMA(&s->h,s->control[10]?NULL:&s->transfer);
case 41:return HAL_I3C_Ctrl_DynAddrAssign(&s->h,s->control[13]?NULL:&s->outputPayload,a,b);
case 42:return HAL_I3C_Ctrl_DynAddrAssign_IT(&s->h,a);
case 43:return HAL_I3C_Ctrl_SetDynAddr(&s->h,a);
case 44:return HAL_I3C_Ctrl_IsDeviceI3C_Ready(&s->h,a,b,c);
case 45:return HAL_I3C_Ctrl_IsDeviceI2C_Ready(&s->h,a,b,c);
case 46:return HAL_I3C_Ctrl_GenerateArbitration(&s->h,a);
case 47:return HAL_I3C_Tgt_Transmit(&s->h,s->control[10]?NULL:&s->transfer,a);
case 48:return HAL_I3C_Tgt_Transmit_IT(&s->h,s->control[10]?NULL:&s->transfer);
case 49:return HAL_I3C_Tgt_Transmit_DMA(&s->h,s->control[10]?NULL:&s->transfer);
case 50:return HAL_I3C_Tgt_Receive(&s->h,s->control[10]?NULL:&s->transfer,a);
case 51:return HAL_I3C_Tgt_Receive_IT(&s->h,s->control[10]?NULL:&s->transfer);
case 52:return HAL_I3C_Tgt_Receive_DMA(&s->h,s->control[10]?NULL:&s->transfer);
case 53:return HAL_I3C_Tgt_ControlRoleReq(&s->h,a);
case 54:return HAL_I3C_Tgt_ControlRoleReq_IT(&s->h);
case 55:return HAL_I3C_Tgt_HotJoinReq(&s->h,s->control[13]?NULL:&s->outputAddress,a);
case 56:return HAL_I3C_Tgt_HotJoinReq_IT(&s->h);
case 57:return HAL_I3C_Tgt_IBIReq(&s->h,s->control[13]?NULL:(uint8_t *)s->buffers[7],a,b);
case 58:return HAL_I3C_Tgt_IBIReq_IT(&s->h,s->control[13]?NULL:(uint8_t *)s->buffers[7],a);
case 59:return HAL_I3C_Abort_IT(&s->h);
case 60:return HAL_I3C_GetState(&s->h);
case 61:return HAL_I3C_GetMode(&s->h);
case 62:return HAL_I3C_GetError(&s->h);
case 63:return HAL_I3C_GetCCCInfo(&s->h,a,s->control[13]?NULL:&s->cccInfo);
case 64:return HAL_I3C_Get_ENTDAA_Payload_Info(&s->h,((uint64_t)b<<32)|a,s->control[13]?NULL:&s->payload);
case 65:return I3C_Tgt_Event_ISR(&s->h,a);
case 66:return I3C_Ctrl_Event_ISR(&s->h,a);
case 67:return I3C_Tgt_HotJoin_ISR(&s->h,a);
case 68:return I3C_Tgt_CtrlRole_ISR(&s->h,a);
case 69:return I3C_Tgt_IBI_ISR(&s->h,a);
case 70:return I3C_Tgt_Tx_ISR(&s->h,a);
case 71:return I3C_Tgt_Rx_ISR(&s->h,a);
case 72:return I3C_Tgt_Tx_DMA_ISR(&s->h,a);
case 73:return I3C_Tgt_Rx_DMA_ISR(&s->h,a);
case 74:return I3C_Ctrl_Tx_ISR(&s->h,a);
case 75:return I3C_Ctrl_Rx_ISR(&s->h,a);
case 76:return I3C_Ctrl_Multiple_Xfer_ISR(&s->h,a);
case 77:return I3C_Ctrl_Tx_Listen_Event_ISR(&s->h,a);
case 78:return I3C_Ctrl_Rx_Listen_Event_ISR(&s->h,a);
case 79:return I3C_Ctrl_Multiple_Xfer_Listen_Event_ISR(&s->h,a);
case 80:return I3C_Ctrl_DAA_ISR(&s->h,a);
case 81:return I3C_Ctrl_Tx_DMA_ISR(&s->h,a);
case 82:return I3C_Ctrl_Rx_DMA_ISR(&s->h,a);
case 83:return I3C_Ctrl_Multiple_Xfer_DMA_ISR(&s->h,a);
case 84:return I3C_Abort_ISR(&s->h,a);
case 85:I3C_DMAControlTransmitCplt(&s->dma[a%3]);return 0;
case 86:I3C_DMADataTransmitCplt(&s->dma[a%3]);return 0;
case 87:I3C_DMADataReceiveCplt(&s->dma[a%3]);return 0;
case 88:I3C_DMAError(&s->dma[a%3]);return 0;
case 89:I3C_DMAAbort(&s->dma[a%3]);return 0;
case 90:return I3C_WaitOnFlagUntilTimeout(&s->h,a,b,c,d);
case 91:return I3C_WaitOnDAAUntilTimeout(&s->h,a,b);
case 92:I3C_TransmitByteTreatment(&s->h);return 0;
case 93:I3C_TransmitWordTreatment(&s->h);return 0;
case 94:I3C_ReceiveByteTreatment(&s->h);return 0;
case 95:I3C_ReceiveWordTreatment(&s->h);return 0;
case 96:I3C_ControlDataTreatment(&s->h);return 0;
case 97:I3C_StateUpdate(&s->h);return 0;
case 98:I3C_GetErrorSources(&s->h);return 0;
case 99:return I3C_Xfer_PriorPreparation(&s->h,a,b);
case 100:return I3C_FillTxBuffer_CCC(&s->h,a,b,c);
case 101:return I3C_FillTxBuffer_Private(&s->h,a,b,c);
case 102:return I3C_ControlBuffer_PriorPreparation(&s->h,a,b);
case 103:return I3C_Ctrl_IsDevice_Ready(&s->h,NULL,a,b);
case 104:I3C_Enable_IRQ(&s->h,a);return 0;
case 105:I3C_Disable_IRQ(&s->h,a);return 0;
case 106:I3C_ErrorTreatment(&s->h);return 0;
case 107:I3C_TreatErrorCallback(&s->h);return 0;
default:assert(0);return 0;}}
