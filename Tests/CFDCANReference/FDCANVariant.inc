#include "FDCANInternal.h"
uint32_t F_JOIN(F_VARIANT,_Run)(CFDCANState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c,uint32_t d) {
FDCAN_FilterTypeDef p0;
p0.IdType=s->params[0][0];
p0.FilterIndex=s->params[0][1];
p0.FilterType=s->params[0][2];
p0.FilterConfig=s->params[0][3];
p0.FilterID1=s->params[0][4];
p0.FilterID2=s->params[0][5];
FDCAN_TxHeaderTypeDef p1;
p1.Identifier=s->params[1][0];
p1.IdType=s->params[1][1];
p1.TxFrameType=s->params[1][2];
p1.DataLength=s->params[1][3];
p1.ErrorStateIndicator=s->params[1][4];
p1.BitRateSwitch=s->params[1][5];
p1.FDFormat=s->params[1][6];
p1.TxEventFifoControl=s->params[1][7];
p1.MessageMarker=s->params[1][8];
FDCAN_RxHeaderTypeDef p2;
p2.Identifier=s->params[2][0];
p2.IdType=s->params[2][1];
p2.RxFrameType=s->params[2][2];
p2.DataLength=s->params[2][3];
p2.ErrorStateIndicator=s->params[2][4];
p2.BitRateSwitch=s->params[2][5];
p2.FDFormat=s->params[2][6];
p2.RxTimestamp=s->params[2][7];
p2.FilterIndex=s->params[2][8];
p2.IsFilterMatchingFrame=s->params[2][9];
FDCAN_TxEventFifoTypeDef p3;
p3.Identifier=s->params[3][0];
p3.IdType=s->params[3][1];
p3.TxFrameType=s->params[3][2];
p3.DataLength=s->params[3][3];
p3.ErrorStateIndicator=s->params[3][4];
p3.BitRateSwitch=s->params[3][5];
p3.FDFormat=s->params[3][6];
p3.TxTimestamp=s->params[3][7];
p3.MessageMarker=s->params[3][8];
p3.EventType=s->params[3][9];
FDCAN_HpMsgStatusTypeDef p4;
p4.FilterList=s->params[4][0];
p4.FilterIndex=s->params[4][1];
p4.MessageStorage=s->params[4][2];
p4.MessageIndex=s->params[4][3];
FDCAN_ProtocolStatusTypeDef p5;
p5.LastErrorCode=s->params[5][0];
p5.DataLastErrorCode=s->params[5][1];
p5.Activity=s->params[5][2];
p5.ErrorPassive=s->params[5][3];
p5.Warning=s->params[5][4];
p5.BusOff=s->params[5][5];
p5.RxESIflag=s->params[5][6];
p5.RxBRSflag=s->params[5][7];
p5.RxFDFflag=s->params[5][8];
p5.ProtocolException=s->params[5][9];
p5.TDCvalue=s->params[5][10];
FDCAN_ErrorCountersTypeDef p6;
p6.TxErrorCnt=s->params[6][0];
p6.RxErrorCnt=s->params[6][1];
p6.RxErrorPassive=s->params[6][2];
p6.ErrorLogging=s->params[6][3];
uint32_t result=0;switch(op) {
case 0:
result=HAL_FDCAN_Init(&s->h);
break;
case 1:
result=HAL_FDCAN_DeInit(&s->h);
break;
case 2:
result=HAL_FDCAN_EnterPowerDownMode(&s->h);
break;
case 3:
result=HAL_FDCAN_ExitPowerDownMode(&s->h);
break;
case 4:
#if F_MODE
result=HAL_FDCAN_RegisterCallback(&s->h,(HAL_FDCAN_CallbackIDTypeDef)a,CFDCAN_CallbackPointer(a,b));
#else
result=UINT32_MAX;
#endif
break;
case 5:
#if F_MODE
result=HAL_FDCAN_UnRegisterCallback(&s->h,(HAL_FDCAN_CallbackIDTypeDef)a);
#else
result=UINT32_MAX;
#endif
break;
case 6:
#if F_MODE
result=HAL_FDCAN_RegisterTxEventFifoCallback(&s->h,CFDCAN_CallbackPointer(7,a));
#else
result=UINT32_MAX;
#endif
break;
case 7:
#if F_MODE
result=HAL_FDCAN_UnRegisterTxEventFifoCallback(&s->h);
#else
result=UINT32_MAX;
#endif
break;
case 8:
#if F_MODE
result=HAL_FDCAN_RegisterRxFifo0Callback(&s->h,CFDCAN_CallbackPointer(8,a));
#else
result=UINT32_MAX;
#endif
break;
case 9:
#if F_MODE
result=HAL_FDCAN_UnRegisterRxFifo0Callback(&s->h);
#else
result=UINT32_MAX;
#endif
break;
case 10:
#if F_MODE
result=HAL_FDCAN_RegisterRxFifo1Callback(&s->h,CFDCAN_CallbackPointer(9,a));
#else
result=UINT32_MAX;
#endif
break;
case 11:
#if F_MODE
result=HAL_FDCAN_UnRegisterRxFifo1Callback(&s->h);
#else
result=UINT32_MAX;
#endif
break;
case 12:
#if F_MODE
result=HAL_FDCAN_RegisterTxBufferCompleteCallback(&s->h,CFDCAN_CallbackPointer(10,a));
#else
result=UINT32_MAX;
#endif
break;
case 13:
#if F_MODE
result=HAL_FDCAN_UnRegisterTxBufferCompleteCallback(&s->h);
#else
result=UINT32_MAX;
#endif
break;
case 14:
#if F_MODE
result=HAL_FDCAN_RegisterTxBufferAbortCallback(&s->h,CFDCAN_CallbackPointer(11,a));
#else
result=UINT32_MAX;
#endif
break;
case 15:
#if F_MODE
result=HAL_FDCAN_UnRegisterTxBufferAbortCallback(&s->h);
#else
result=UINT32_MAX;
#endif
break;
case 16:
#if F_MODE
result=HAL_FDCAN_RegisterErrorStatusCallback(&s->h,CFDCAN_CallbackPointer(12,a));
#else
result=UINT32_MAX;
#endif
break;
case 17:
#if F_MODE
result=HAL_FDCAN_UnRegisterErrorStatusCallback(&s->h);
#else
result=UINT32_MAX;
#endif
break;
case 18:
result=HAL_FDCAN_ConfigFilter(&s->h,&p0);
break;
case 19:
result=HAL_FDCAN_ConfigGlobalFilter(&s->h,a,b,c,d);
break;
case 20:
result=HAL_FDCAN_ConfigExtendedIdMask(&s->h,a);
break;
case 21:
result=HAL_FDCAN_ConfigRxFifoOverwrite(&s->h,a,b);
break;
case 22:
result=HAL_FDCAN_ConfigRamWatchdog(&s->h,a);
break;
case 23:
result=HAL_FDCAN_ConfigTimestampCounter(&s->h,a);
break;
case 24:
result=HAL_FDCAN_EnableTimestampCounter(&s->h,a);
break;
case 25:
result=HAL_FDCAN_DisableTimestampCounter(&s->h);
break;
case 26:
result=HAL_FDCAN_GetTimestampCounter(&s->h);
break;
case 27:
result=HAL_FDCAN_ResetTimestampCounter(&s->h);
break;
case 28:
result=HAL_FDCAN_ConfigTimeoutCounter(&s->h,a,b);
break;
case 29:
result=HAL_FDCAN_EnableTimeoutCounter(&s->h);
break;
case 30:
result=HAL_FDCAN_DisableTimeoutCounter(&s->h);
break;
case 31:
result=HAL_FDCAN_GetTimeoutCounter(&s->h);
break;
case 32:
result=HAL_FDCAN_ResetTimeoutCounter(&s->h);
break;
case 33:
result=HAL_FDCAN_ConfigTxDelayCompensation(&s->h,a,b);
break;
case 34:
result=HAL_FDCAN_EnableTxDelayCompensation(&s->h);
break;
case 35:
result=HAL_FDCAN_DisableTxDelayCompensation(&s->h);
break;
case 36:
result=HAL_FDCAN_EnableISOMode(&s->h);
break;
case 37:
result=HAL_FDCAN_DisableISOMode(&s->h);
break;
case 38:
result=HAL_FDCAN_EnableEdgeFiltering(&s->h);
break;
case 39:
result=HAL_FDCAN_DisableEdgeFiltering(&s->h);
break;
case 40:
result=HAL_FDCAN_Start(&s->h);
break;
case 41:
result=HAL_FDCAN_Stop(&s->h);
break;
case 42:
result=HAL_FDCAN_AddMessageToTxFifoQ(&s->h,&p1,s->data[0]);
break;
case 43:
result=HAL_FDCAN_GetLatestTxFifoQRequestBuffer(&s->h);
break;
case 44:
result=HAL_FDCAN_AbortTxRequest(&s->h,a);
break;
case 45:
result=HAL_FDCAN_GetRxMessage(&s->h,a,&p2,s->data[1]);
break;
case 46:
result=HAL_FDCAN_GetTxEvent(&s->h,&p3);
break;
case 47:
result=HAL_FDCAN_GetHighPriorityMessageStatus(&s->h,&p4);
break;
case 48:
result=HAL_FDCAN_GetProtocolStatus(&s->h,&p5);
break;
case 49:
result=HAL_FDCAN_GetErrorCounters(&s->h,&p6);
break;
case 50:
result=HAL_FDCAN_IsTxBufferMessagePending(&s->h,a);
break;
case 51:
result=HAL_FDCAN_GetRxFifoFillLevel(&s->h,a);
break;
case 52:
result=HAL_FDCAN_GetTxFifoFreeLevel(&s->h);
break;
case 53:
result=HAL_FDCAN_IsRestrictedOperationMode(&s->h);
break;
case 54:
result=HAL_FDCAN_ExitRestrictedOperationMode(&s->h);
break;
case 55:
result=HAL_FDCAN_ConfigInterruptLines(&s->h,a,b);
break;
case 56:
result=HAL_FDCAN_ActivateNotification(&s->h,a,b);
break;
case 57:
result=HAL_FDCAN_DeactivateNotification(&s->h,a);
break;
case 58:
HAL_FDCAN_IRQHandler(&s->h);
break;
case 59:
result=HAL_FDCAN_GetState(&s->h);
break;
case 60:
result=HAL_FDCAN_GetError(&s->h);
break;
case 61:
FDCAN_CalcultateRamBlockAddresses(&s->h);
break;
case 62:
FDCAN_CopyMessageToRAM(&s->h,&p1,s->data[0],a);
break;
default:result=0xBAD;break;}
s->params[0][0]=p0.IdType;
s->params[0][1]=p0.FilterIndex;
s->params[0][2]=p0.FilterType;
s->params[0][3]=p0.FilterConfig;
s->params[0][4]=p0.FilterID1;
s->params[0][5]=p0.FilterID2;
s->params[1][0]=p1.Identifier;
s->params[1][1]=p1.IdType;
s->params[1][2]=p1.TxFrameType;
s->params[1][3]=p1.DataLength;
s->params[1][4]=p1.ErrorStateIndicator;
s->params[1][5]=p1.BitRateSwitch;
s->params[1][6]=p1.FDFormat;
s->params[1][7]=p1.TxEventFifoControl;
s->params[1][8]=p1.MessageMarker;
s->params[2][0]=p2.Identifier;
s->params[2][1]=p2.IdType;
s->params[2][2]=p2.RxFrameType;
s->params[2][3]=p2.DataLength;
s->params[2][4]=p2.ErrorStateIndicator;
s->params[2][5]=p2.BitRateSwitch;
s->params[2][6]=p2.FDFormat;
s->params[2][7]=p2.RxTimestamp;
s->params[2][8]=p2.FilterIndex;
s->params[2][9]=p2.IsFilterMatchingFrame;
s->params[3][0]=p3.Identifier;
s->params[3][1]=p3.IdType;
s->params[3][2]=p3.TxFrameType;
s->params[3][3]=p3.DataLength;
s->params[3][4]=p3.ErrorStateIndicator;
s->params[3][5]=p3.BitRateSwitch;
s->params[3][6]=p3.FDFormat;
s->params[3][7]=p3.TxTimestamp;
s->params[3][8]=p3.MessageMarker;
s->params[3][9]=p3.EventType;
s->params[4][0]=p4.FilterList;
s->params[4][1]=p4.FilterIndex;
s->params[4][2]=p4.MessageStorage;
s->params[4][3]=p4.MessageIndex;
s->params[5][0]=p5.LastErrorCode;
s->params[5][1]=p5.DataLastErrorCode;
s->params[5][2]=p5.Activity;
s->params[5][3]=p5.ErrorPassive;
s->params[5][4]=p5.Warning;
s->params[5][5]=p5.BusOff;
s->params[5][6]=p5.RxESIflag;
s->params[5][7]=p5.RxBRSflag;
s->params[5][8]=p5.RxFDFflag;
s->params[5][9]=p5.ProtocolException;
s->params[5][10]=p5.TDCvalue;
s->params[6][0]=p6.TxErrorCnt;
s->params[6][1]=p6.RxErrorCnt;
s->params[6][2]=p6.RxErrorPassive;
s->params[6][3]=p6.ErrorLogging;
return result;}
