#include "FDCANInternal.h"
void HAL_FDCAN_TxFifoEmptyCallback(FDCAN_HandleTypeDef *h) { CFDCAN_Callback((CFDCANState*)((char*)h - offsetof(CFDCANState,h)),0,1,0); }
void CFDCAN_CustomTxFifoEmptyCallback(FDCAN_HandleTypeDef *h) { CFDCAN_Callback((CFDCANState*)((char*)h - offsetof(CFDCANState,h)),0,2,0); }
void HAL_FDCAN_HighPriorityMessageCallback(FDCAN_HandleTypeDef *h) { CFDCAN_Callback((CFDCANState*)((char*)h - offsetof(CFDCANState,h)),1,1,0); }
void CFDCAN_CustomHighPriorityMessageCallback(FDCAN_HandleTypeDef *h) { CFDCAN_Callback((CFDCANState*)((char*)h - offsetof(CFDCANState,h)),1,2,0); }
void HAL_FDCAN_TimestampWraparoundCallback(FDCAN_HandleTypeDef *h) { CFDCAN_Callback((CFDCANState*)((char*)h - offsetof(CFDCANState,h)),2,1,0); }
void CFDCAN_CustomTimestampWraparoundCallback(FDCAN_HandleTypeDef *h) { CFDCAN_Callback((CFDCANState*)((char*)h - offsetof(CFDCANState,h)),2,2,0); }
void HAL_FDCAN_TimeoutOccurredCallback(FDCAN_HandleTypeDef *h) { CFDCAN_Callback((CFDCANState*)((char*)h - offsetof(CFDCANState,h)),3,1,0); }
void CFDCAN_CustomTimeoutOccurredCallback(FDCAN_HandleTypeDef *h) { CFDCAN_Callback((CFDCANState*)((char*)h - offsetof(CFDCANState,h)),3,2,0); }
void HAL_FDCAN_ErrorCallback(FDCAN_HandleTypeDef *h) { CFDCAN_Callback((CFDCANState*)((char*)h - offsetof(CFDCANState,h)),4,1,0); }
void CFDCAN_CustomErrorCallback(FDCAN_HandleTypeDef *h) { CFDCAN_Callback((CFDCANState*)((char*)h - offsetof(CFDCANState,h)),4,2,0); }
void HAL_FDCAN_MspInit(FDCAN_HandleTypeDef *h) { CFDCAN_Callback((CFDCANState*)((char*)h - offsetof(CFDCANState,h)),5,1,0); }
void CFDCAN_CustomMspInitCallback(FDCAN_HandleTypeDef *h) { CFDCAN_Callback((CFDCANState*)((char*)h - offsetof(CFDCANState,h)),5,2,0); }
void HAL_FDCAN_MspDeInit(FDCAN_HandleTypeDef *h) { CFDCAN_Callback((CFDCANState*)((char*)h - offsetof(CFDCANState,h)),6,1,0); }
void CFDCAN_CustomMspDeInitCallback(FDCAN_HandleTypeDef *h) { CFDCAN_Callback((CFDCANState*)((char*)h - offsetof(CFDCANState,h)),6,2,0); }
void HAL_FDCAN_TxEventFifoCallback(FDCAN_HandleTypeDef *h,uint32_t argument) { CFDCAN_Callback((CFDCANState*)((char*)h - offsetof(CFDCANState,h)),7,1,argument); }
void CFDCAN_CustomTxEventFifoCallback(FDCAN_HandleTypeDef *h,uint32_t argument) { CFDCAN_Callback((CFDCANState*)((char*)h - offsetof(CFDCANState,h)),7,2,argument); }
void HAL_FDCAN_RxFifo0Callback(FDCAN_HandleTypeDef *h,uint32_t argument) { CFDCAN_Callback((CFDCANState*)((char*)h - offsetof(CFDCANState,h)),8,1,argument); }
void CFDCAN_CustomRxFifo0Callback(FDCAN_HandleTypeDef *h,uint32_t argument) { CFDCAN_Callback((CFDCANState*)((char*)h - offsetof(CFDCANState,h)),8,2,argument); }
void HAL_FDCAN_RxFifo1Callback(FDCAN_HandleTypeDef *h,uint32_t argument) { CFDCAN_Callback((CFDCANState*)((char*)h - offsetof(CFDCANState,h)),9,1,argument); }
void CFDCAN_CustomRxFifo1Callback(FDCAN_HandleTypeDef *h,uint32_t argument) { CFDCAN_Callback((CFDCANState*)((char*)h - offsetof(CFDCANState,h)),9,2,argument); }
void HAL_FDCAN_TxBufferCompleteCallback(FDCAN_HandleTypeDef *h,uint32_t argument) { CFDCAN_Callback((CFDCANState*)((char*)h - offsetof(CFDCANState,h)),10,1,argument); }
void CFDCAN_CustomTxBufferCompleteCallback(FDCAN_HandleTypeDef *h,uint32_t argument) { CFDCAN_Callback((CFDCANState*)((char*)h - offsetof(CFDCANState,h)),10,2,argument); }
void HAL_FDCAN_TxBufferAbortCallback(FDCAN_HandleTypeDef *h,uint32_t argument) { CFDCAN_Callback((CFDCANState*)((char*)h - offsetof(CFDCANState,h)),11,1,argument); }
void CFDCAN_CustomTxBufferAbortCallback(FDCAN_HandleTypeDef *h,uint32_t argument) { CFDCAN_Callback((CFDCANState*)((char*)h - offsetof(CFDCANState,h)),11,2,argument); }
void HAL_FDCAN_ErrorStatusCallback(FDCAN_HandleTypeDef *h,uint32_t argument) { CFDCAN_Callback((CFDCANState*)((char*)h - offsetof(CFDCANState,h)),12,1,argument); }
void CFDCAN_CustomErrorStatusCallback(FDCAN_HandleTypeDef *h,uint32_t argument) { CFDCAN_Callback((CFDCANState*)((char*)h - offsetof(CFDCANState,h)),12,2,argument); }
void *CFDCAN_CallbackPointer(uint32_t id,uint32_t token) { if(token==0)return NULL;switch(id) {
case 0:return token==1?(void*)HAL_FDCAN_TxFifoEmptyCallback:(void*)CFDCAN_CustomTxFifoEmptyCallback;
case 1:return token==1?(void*)HAL_FDCAN_HighPriorityMessageCallback:(void*)CFDCAN_CustomHighPriorityMessageCallback;
case 2:return token==1?(void*)HAL_FDCAN_TimestampWraparoundCallback:(void*)CFDCAN_CustomTimestampWraparoundCallback;
case 3:return token==1?(void*)HAL_FDCAN_TimeoutOccurredCallback:(void*)CFDCAN_CustomTimeoutOccurredCallback;
case 4:return token==1?(void*)HAL_FDCAN_ErrorCallback:(void*)CFDCAN_CustomErrorCallback;
case 5:return token==1?(void*)HAL_FDCAN_MspInit:(void*)CFDCAN_CustomMspInitCallback;
case 6:return token==1?(void*)HAL_FDCAN_MspDeInit:(void*)CFDCAN_CustomMspDeInitCallback;
case 7:return token==1?(void*)HAL_FDCAN_TxEventFifoCallback:(void*)CFDCAN_CustomTxEventFifoCallback;
case 8:return token==1?(void*)HAL_FDCAN_RxFifo0Callback:(void*)CFDCAN_CustomRxFifo0Callback;
case 9:return token==1?(void*)HAL_FDCAN_RxFifo1Callback:(void*)CFDCAN_CustomRxFifo1Callback;
case 10:return token==1?(void*)HAL_FDCAN_TxBufferCompleteCallback:(void*)CFDCAN_CustomTxBufferCompleteCallback;
case 11:return token==1?(void*)HAL_FDCAN_TxBufferAbortCallback:(void*)CFDCAN_CustomTxBufferAbortCallback;
case 12:return token==1?(void*)HAL_FDCAN_ErrorStatusCallback:(void*)CFDCAN_CustomErrorStatusCallback;
default:return NULL;}}
uint32_t CFDCAN_GetCallback(CFDCANState *s,uint32_t id) {void *p=NULL;switch(id) {
case 0:p=(void*)s->h.TxFifoEmptyCallback;break;
case 1:p=(void*)s->h.HighPriorityMessageCallback;break;
case 2:p=(void*)s->h.TimestampWraparoundCallback;break;
case 3:p=(void*)s->h.TimeoutOccurredCallback;break;
case 4:p=(void*)s->h.ErrorCallback;break;
case 5:p=(void*)s->h.MspInitCallback;break;
case 6:p=(void*)s->h.MspDeInitCallback;break;
case 7:p=(void*)s->h.TxEventFifoCallback;break;
case 8:p=(void*)s->h.RxFifo0Callback;break;
case 9:p=(void*)s->h.RxFifo1Callback;break;
case 10:p=(void*)s->h.TxBufferCompleteCallback;break;
case 11:p=(void*)s->h.TxBufferAbortCallback;break;
case 12:p=(void*)s->h.ErrorStatusCallback;break;
}return p==NULL?0:(p==CFDCAN_CallbackPointer(id,1)?1:2);}
void CFDCAN_SetCallback(CFDCANState *s,uint32_t id,uint32_t token) {void *p=CFDCAN_CallbackPointer(id,token);switch(id) {
case 0:s->h.TxFifoEmptyCallback=p;break;
case 1:s->h.HighPriorityMessageCallback=p;break;
case 2:s->h.TimestampWraparoundCallback=p;break;
case 3:s->h.TimeoutOccurredCallback=p;break;
case 4:s->h.ErrorCallback=p;break;
case 5:s->h.MspInitCallback=p;break;
case 6:s->h.MspDeInitCallback=p;break;
case 7:s->h.TxEventFifoCallback=p;break;
case 8:s->h.RxFifo0Callback=p;break;
case 9:s->h.RxFifo1Callback=p;break;
case 10:s->h.TxBufferCompleteCallback=p;break;
case 11:s->h.TxBufferAbortCallback=p;break;
case 12:s->h.ErrorStatusCallback=p;break;
}}
