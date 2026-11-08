// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I3C operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

#include "I3CInternal.h"
CI3C_THREAD_LOCAL CI3CState *CI3C_Active;
size_t CI3C_Size(void){return sizeof(CI3CState);}
void CI3C_Activate(CI3CState *s){CI3C_Active=s;}
uint8_t *CI3C_Buffer(CI3CState *s,uint32_t i){assert(i<8);return (uint8_t *)s->buffers[i];}
uint32_t CI3C_Normalize(CI3CState *s,uintptr_t value){
uint32_t v=(uint32_t)value;
if(!value)return 0;
for(uint32_t i=0;i<8;i++){uint32_t b=(uint32_t)(uintptr_t)s->buffers[i];if(v-b<1024)return 0xABC00000U+i*0x10000U+v-b;}
uint32_t r=(uint32_t)(uintptr_t)&s->regs;if(v-r<sizeof(s->regs))return 0x40005400U+v-r;
return v;
}
uintptr_t CI3C_Decode(CI3CState *s,uint32_t value){
if(!value)return 0;
for(uint32_t i=0;i<8;i++){uint32_t b=0xABC00000U+i*0x10000U;if(value-b<1024)return (uintptr_t)s->buffers[i]+value-b;}
assert(0);return 0;
}
uint32_t CI3C_GetPointer(CI3CState *s,uint32_t i){switch(i){case 0:return s->h.pXferData!=NULL;case 1:return s->h.pCCCDesc!=NULL;case 2:return s->h.pPrivateDesc!=NULL;default:assert(0);return 0;}}
void CI3C_SetPointer(CI3CState *s,uint32_t i,uint32_t v){switch(i){case 0:s->h.pXferData=v?&s->transfer:NULL;break;case 1:s->h.pCCCDesc=v?s->ccc:NULL;break;case 2:s->h.pPrivateDesc=v?s->private:NULL;break;default:assert(0);}}
uint32_t CI3C_TickFor(CI3CState *s){uint32_t v=s->control[1];s->control[1]+=s->control[2];s->control[3]++;if(s->control[17]&&s->control[3]==s->control[17])s->regs.EVR=s->control[18];return v;}
uint32_t CI3C_Tick(void){return CI3C_TickFor(CI3C_Active);}
static void access(CI3CState *s,uint32_t op,uint32_t off,uint32_t value){
if(s->control[30]){uint32_t *n=&s->control[31];assert(*n+3<=4096);s->accessTrace[(*n)++]=op;s->accessTrace[(*n)++]=off;s->accessTrace[(*n)++]=value;}}
uint32_t CI3C_Read(CI3CState *s,uint32_t off){
assert(off<sizeof(s->regs)&&off%4==0);
if(off==0x50){s->control[5]++;if(s->control[4]&&s->control[5]==s->control[4])s->regs.EVR=s->control[6];}
uint32_t value=((volatile uint32_t *)&s->regs)[off/4];access(s,0,off,value);
if((off==0x10||off==0x14)&&s->control[8]){if(--s->control[8]==0)s->regs.EVR&=~I3C_EVR_RXFNEF;}
return value;
}
void CI3C_Write(CI3CState *s,uint32_t off,uint32_t value){
assert(off<sizeof(s->regs)&&off%4==0);access(s,1,off,value);((volatile uint32_t *)&s->regs)[off/4]=value;
if((off==0x18||off==0x1C)&&s->control[7]){if(--s->control[7]==0)s->regs.EVR&=~I3C_EVR_TXFNFF;}
if(off==0&&s->control[9]){if(--s->control[9]==0)s->regs.EVR&=~I3C_EVR_CFNFF;}
}
uint32_t CI3C_ReadVolatile(volatile const uint32_t *r){return CI3C_Read(CI3C_Active,(uintptr_t)r-(uintptr_t)&CI3C_Active->regs);}
void CI3C_WriteVolatile(volatile uint32_t *r,uint32_t v){CI3C_Write(CI3C_Active,(uintptr_t)r-(uintptr_t)&CI3C_Active->regs,v);}
uint32_t CI3C_Run(CI3CState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c,uint32_t d){CI3C_Activate(s);return s->control[0]?CI3C1_Run(s,op,a,b,c,d):CI3C0_Run(s,op,a,b,c,d);}
uint32_t CI3C_Get(CI3CState *s,uint32_t g,uint32_t i){switch(g){
case 0:assert(i<54);return ((volatile uint32_t *)&s->regs)[i];
case 1:return s->control[0]?CI3C1_GetWord(s,i):CI3C0_GetWord(s,i);
case 2:assert(i<64);return s->control[i];
case 3:case 4:case 5:{uint32_t d=g-3;assert(i<16);if(i==1)return s->dma[d].State;return s->settings[d][i];}
case 6:case 7:case 8:return s->control[0]?CI3C1_GetDMA(s,g-6,i):CI3C0_GetDMA(s,g-6,i);
case 9:assert(i<1024);return s->trace[i];
case 10:assert(i<1024);return s->dmaTrace[i];
case 11:assert(i<4096);return s->accessTrace[i];
case 12:switch(i){case 0:return (uint32_t)s->outputPayload;case 1:return s->outputPayload>>32;case 2:return s->outputReset;case 3:return s->outputAddress;default:assert(0);}
case 20:assert(i<8);switch(i%8){
case 0:return s->controllerBus.SDAHoldTime;
case 1:return s->controllerBus.WaitTime;
case 2:return s->controllerBus.SCLPPLowDuration;
case 3:return s->controllerBus.SCLI3CHighDuration;
case 4:return s->controllerBus.SCLODLowDuration;
case 5:return s->controllerBus.SCLI2CHighDuration;
case 6:return s->controllerBus.BusFreeDuration;
case 7:return s->controllerBus.BusIdleDuration;
default:assert(0);return 0;}
case 21:assert(i<1);switch(i%1){
case 0:return s->targetBus.BusAvailableDuration;
default:assert(0);return 0;}
case 22:assert(i<4);switch(i%4){
case 0:return s->fifo.RxFifoThreshold;
case 1:return s->fifo.TxFifoThreshold;
case 2:return s->fifo.ControlFifo;
case 3:return s->fifo.StatusFifo;
default:assert(0);return 0;}
case 23:assert(i<8);switch(i%8){
case 0:return s->controller.DynamicAddr;
case 1:return s->controller.StallTime;
case 2:return s->controller.HotJoinAllowed;
case 3:return s->controller.ACKStallState;
case 4:return s->controller.CCCStallState;
case 5:return s->controller.TxStallState;
case 6:return s->controller.RxStallState;
case 7:return s->controller.HighKeeperSDA;
default:assert(0);return 0;}
case 24:assert(i<18);switch(i%18){
case 0:return s->target.Identifier;
case 1:return s->target.MIPIIdentifier;
case 2:return s->target.CtrlRoleRequest;
case 3:return s->target.HotJoinRequest;
case 4:return s->target.IBIRequest;
case 5:return s->target.IBIPayload;
case 6:return s->target.IBIPayloadSize;
case 7:return s->target.MaxReadDataSize;
case 8:return s->target.MaxWriteDataSize;
case 9:return s->target.CtrlCapability;
case 10:return s->target.GroupAddrCapability;
case 11:return s->target.DataTurnAroundDuration;
case 12:return s->target.MaxReadTurnAround;
case 13:return s->target.MaxDataSpeed;
case 14:return s->target.MaxSpeedLimitation;
case 15:return s->target.HandOffActivityState;
case 16:return s->target.HandOffDelay;
case 17:return s->target.PendingReadMDB;
default:assert(0);return 0;}
case 25:assert(i<24);switch(i%6){
case 0:return s->devices[i/6].DeviceIndex;
case 1:return s->devices[i/6].TargetDynamicAddr;
case 2:return s->devices[i/6].IBIAck;
case 3:return s->devices[i/6].IBIPayload;
case 4:return s->devices[i/6].CtrlRoleReqAck;
case 5:return s->devices[i/6].CtrlStopTransfer;
default:assert(0);return 0;}
case 26:assert(i<12);switch(i%12){
case 0:return s->cccInfo.DynamicAddrValid;
case 1:return s->cccInfo.DynamicAddr;
case 2:return s->cccInfo.MaxWriteLength;
case 3:return s->cccInfo.MaxReadLength;
case 4:return s->cccInfo.ResetAction;
case 5:return s->cccInfo.ActivityState;
case 6:return s->cccInfo.HotJoinAllowed;
case 7:return s->cccInfo.InBandAllowed;
case 8:return s->cccInfo.CtrlRoleAllowed;
case 9:return s->cccInfo.IBICRTgtAddr;
case 10:return s->cccInfo.IBITgtNbPayload;
case 11:return s->cccInfo.IBITgtPayload;
default:assert(0);return 0;}
case 27:assert(i<12);switch(i%12){
case 0:return s->payload.BCR.MaxDataSpeedLimitation;
case 1:return s->payload.BCR.IBIRequestCapable;
case 2:return s->payload.BCR.IBIPayload;
case 3:return s->payload.BCR.OfflineCapable;
case 4:return s->payload.BCR.VirtualTargetSupport;
case 5:return s->payload.BCR.AdvancedCapabilities;
case 6:return s->payload.BCR.DeviceRole;
case 7:return s->payload.DCR;
case 8:return s->payload.PID.MIPIMID;
case 9:return s->payload.PID.IDTSEL;
case 10:return s->payload.PID.PartID;
case 11:return s->payload.PID.MIPIID;
default:assert(0);return 0;}
case 28:assert(i<40);switch(i%5){
case 0:return s->ccc[i/5].TargetAddr;
case 1:return s->ccc[i/5].CCC;
case 2:return CI3C_Normalize(s,(uintptr_t)s->ccc[i/5].CCCBuf.pBuffer);
case 3:return s->ccc[i/5].CCCBuf.Size;
case 4:return s->ccc[i/5].Direction;
default:assert(0);return 0;}
case 29:assert(i<48);switch(i%6){
case 0:return s->private[i/6].TargetAddr;
case 1:return CI3C_Normalize(s,(uintptr_t)s->private[i/6].TxBuf.pBuffer);
case 2:return s->private[i/6].TxBuf.Size;
case 3:return CI3C_Normalize(s,(uintptr_t)s->private[i/6].RxBuf.pBuffer);
case 4:return s->private[i/6].RxBuf.Size;
case 5:return s->private[i/6].Direction;
default:assert(0);return 0;}
case 30:assert(i<8);switch(i%8){
case 0:return CI3C_Normalize(s,(uintptr_t)s->transfer.CtrlBuf.pBuffer);
case 1:return s->transfer.CtrlBuf.Size;
case 2:return CI3C_Normalize(s,(uintptr_t)s->transfer.StatusBuf.pBuffer);
case 3:return s->transfer.StatusBuf.Size;
case 4:return CI3C_Normalize(s,(uintptr_t)s->transfer.TxBuf.pBuffer);
case 5:return s->transfer.TxBuf.Size;
case 6:return CI3C_Normalize(s,(uintptr_t)s->transfer.RxBuf.pBuffer);
case 7:return s->transfer.RxBuf.Size;
default:assert(0);return 0;}
default:assert(0);return 0;}}
void CI3C_Set(CI3CState *s,uint32_t g,uint32_t i,uint32_t v){switch(g){
case 0:assert(i<54);((volatile uint32_t *)&s->regs)[i]=v;break;
case 1:if(s->control[0])CI3C1_SetWord(s,i,v);else CI3C0_SetWord(s,i,v);break;
case 2:assert(i<64);s->control[i]=v;break;
case 3:case 4:case 5:{uint32_t d=g-3;assert(i<16);s->settings[d][i]=v;if(i==1)s->dma[d].State=v;if(i==0){if(d==0)s->h.hdmacr=v?&s->dma[d]:NULL;if(d==1)s->h.hdmatx=v?&s->dma[d]:NULL;if(d==2)s->h.hdmarx=v?&s->dma[d]:NULL;}break;}
case 6:case 7:case 8:if(s->control[0])CI3C1_SetDMA(s,g-6,i,v);else CI3C0_SetDMA(s,g-6,i,v);break;
case 9:assert(i<1024);s->trace[i]=v;break;
case 10:assert(i<1024);s->dmaTrace[i]=v;break;
case 11:assert(i<4096);s->accessTrace[i]=v;break;
case 12:switch(i){case 0:s->outputPayload=(s->outputPayload&0xFFFFFFFF00000000ULL)|v;break;case 1:s->outputPayload=(s->outputPayload&0xFFFFFFFFULL)|((uint64_t)v<<32);break;case 2:s->outputReset=v;break;case 3:s->outputAddress=v;break;default:assert(0);}break;
case 20:assert(i<8);switch(i%8){
case 0:s->controllerBus.SDAHoldTime=v;break;
case 1:s->controllerBus.WaitTime=v;break;
case 2:s->controllerBus.SCLPPLowDuration=v;break;
case 3:s->controllerBus.SCLI3CHighDuration=v;break;
case 4:s->controllerBus.SCLODLowDuration=v;break;
case 5:s->controllerBus.SCLI2CHighDuration=v;break;
case 6:s->controllerBus.BusFreeDuration=v;break;
case 7:s->controllerBus.BusIdleDuration=v;break;
default:assert(0);}break;
case 21:assert(i<1);switch(i%1){
case 0:s->targetBus.BusAvailableDuration=v;break;
default:assert(0);}break;
case 22:assert(i<4);switch(i%4){
case 0:s->fifo.RxFifoThreshold=v;break;
case 1:s->fifo.TxFifoThreshold=v;break;
case 2:s->fifo.ControlFifo=v;break;
case 3:s->fifo.StatusFifo=v;break;
default:assert(0);}break;
case 23:assert(i<8);switch(i%8){
case 0:s->controller.DynamicAddr=v;break;
case 1:s->controller.StallTime=v;break;
case 2:s->controller.HotJoinAllowed=v;break;
case 3:s->controller.ACKStallState=v;break;
case 4:s->controller.CCCStallState=v;break;
case 5:s->controller.TxStallState=v;break;
case 6:s->controller.RxStallState=v;break;
case 7:s->controller.HighKeeperSDA=v;break;
default:assert(0);}break;
case 24:assert(i<18);switch(i%18){
case 0:s->target.Identifier=v;break;
case 1:s->target.MIPIIdentifier=v;break;
case 2:s->target.CtrlRoleRequest=v;break;
case 3:s->target.HotJoinRequest=v;break;
case 4:s->target.IBIRequest=v;break;
case 5:s->target.IBIPayload=v;break;
case 6:s->target.IBIPayloadSize=v;break;
case 7:s->target.MaxReadDataSize=v;break;
case 8:s->target.MaxWriteDataSize=v;break;
case 9:s->target.CtrlCapability=v;break;
case 10:s->target.GroupAddrCapability=v;break;
case 11:s->target.DataTurnAroundDuration=v;break;
case 12:s->target.MaxReadTurnAround=v;break;
case 13:s->target.MaxDataSpeed=v;break;
case 14:s->target.MaxSpeedLimitation=v;break;
case 15:s->target.HandOffActivityState=v;break;
case 16:s->target.HandOffDelay=v;break;
case 17:s->target.PendingReadMDB=v;break;
default:assert(0);}break;
case 25:assert(i<24);switch(i%6){
case 0:s->devices[i/6].DeviceIndex=v;break;
case 1:s->devices[i/6].TargetDynamicAddr=v;break;
case 2:s->devices[i/6].IBIAck=v;break;
case 3:s->devices[i/6].IBIPayload=v;break;
case 4:s->devices[i/6].CtrlRoleReqAck=v;break;
case 5:s->devices[i/6].CtrlStopTransfer=v;break;
default:assert(0);}break;
case 26:assert(i<12);switch(i%12){
case 0:s->cccInfo.DynamicAddrValid=v;break;
case 1:s->cccInfo.DynamicAddr=v;break;
case 2:s->cccInfo.MaxWriteLength=v;break;
case 3:s->cccInfo.MaxReadLength=v;break;
case 4:s->cccInfo.ResetAction=v;break;
case 5:s->cccInfo.ActivityState=v;break;
case 6:s->cccInfo.HotJoinAllowed=v;break;
case 7:s->cccInfo.InBandAllowed=v;break;
case 8:s->cccInfo.CtrlRoleAllowed=v;break;
case 9:s->cccInfo.IBICRTgtAddr=v;break;
case 10:s->cccInfo.IBITgtNbPayload=v;break;
case 11:s->cccInfo.IBITgtPayload=v;break;
default:assert(0);}break;
case 27:assert(i<12);switch(i%12){
case 0:s->payload.BCR.MaxDataSpeedLimitation=v;break;
case 1:s->payload.BCR.IBIRequestCapable=v;break;
case 2:s->payload.BCR.IBIPayload=v;break;
case 3:s->payload.BCR.OfflineCapable=v;break;
case 4:s->payload.BCR.VirtualTargetSupport=v;break;
case 5:s->payload.BCR.AdvancedCapabilities=v;break;
case 6:s->payload.BCR.DeviceRole=v;break;
case 7:s->payload.DCR=v;break;
case 8:s->payload.PID.MIPIMID=v;break;
case 9:s->payload.PID.IDTSEL=v;break;
case 10:s->payload.PID.PartID=v;break;
case 11:s->payload.PID.MIPIID=v;break;
default:assert(0);}break;
case 28:assert(i<40);switch(i%5){
case 0:s->ccc[i/5].TargetAddr=v;break;
case 1:s->ccc[i/5].CCC=v;break;
case 2:s->ccc[i/5].CCCBuf.pBuffer=(void *)CI3C_Decode(s,v);break;
case 3:s->ccc[i/5].CCCBuf.Size=v;break;
case 4:s->ccc[i/5].Direction=v;break;
default:assert(0);}break;
case 29:assert(i<48);switch(i%6){
case 0:s->private[i/6].TargetAddr=v;break;
case 1:s->private[i/6].TxBuf.pBuffer=(void *)CI3C_Decode(s,v);break;
case 2:s->private[i/6].TxBuf.Size=v;break;
case 3:s->private[i/6].RxBuf.pBuffer=(void *)CI3C_Decode(s,v);break;
case 4:s->private[i/6].RxBuf.Size=v;break;
case 5:s->private[i/6].Direction=v;break;
default:assert(0);}break;
case 30:assert(i<8);switch(i%8){
case 0:s->transfer.CtrlBuf.pBuffer=(void *)CI3C_Decode(s,v);break;
case 1:s->transfer.CtrlBuf.Size=v;break;
case 2:s->transfer.StatusBuf.pBuffer=(void *)CI3C_Decode(s,v);break;
case 3:s->transfer.StatusBuf.Size=v;break;
case 4:s->transfer.TxBuf.pBuffer=(void *)CI3C_Decode(s,v);break;
case 5:s->transfer.TxBuf.Size=v;break;
case 6:s->transfer.RxBuf.pBuffer=(void *)CI3C_Decode(s,v);break;
case 7:s->transfer.RxBuf.Size=v;break;
default:assert(0);}break;
default:assert(0);}}
static void traceCallback(I3C_HandleTypeDef *h,uint32_t id,uint32_t custom,uint64_t payload){
CI3CState *s=(CI3CState *)h;uint32_t *n=&s->control[14];assert(*n+12<=1024);
uint32_t values[12]={id,custom,(uint32_t)payload,payload>>32,h->State,h->PreviousState,h->ErrorCode,h->Mode,h->TxXferCount,h->RxXferCount,h->ControlXferCount,h->Instance->CFGR};
for(uint32_t i=0;i<12;i++)s->trace[(*n)++]=values[i];
if(s->control[20]&&s->control[20]-1==id){CI3C_Set(s,1,s->control[21],s->control[22]);s->control[20]=0;}}
void HAL_I3C_CtrlTxCpltCallback(I3C_HandleTypeDef *h){traceCallback(h,0,0,0);}
static void Custom0(I3C_HandleTypeDef *h){traceCallback(h,0,1,0);}
void HAL_I3C_CtrlRxCpltCallback(I3C_HandleTypeDef *h){traceCallback(h,1,0,0);}
static void Custom1(I3C_HandleTypeDef *h){traceCallback(h,1,1,0);}
void HAL_I3C_CtrlMultipleXferCpltCallback(I3C_HandleTypeDef *h){traceCallback(h,2,0,0);}
static void Custom2(I3C_HandleTypeDef *h){traceCallback(h,2,1,0);}
void HAL_I3C_CtrlDAACpltCallback(I3C_HandleTypeDef *h){traceCallback(h,3,0,0);}
static void Custom3(I3C_HandleTypeDef *h){traceCallback(h,3,1,0);}
void HAL_I3C_TgtReqDynamicAddrCallback(I3C_HandleTypeDef *h, uint64_t value){traceCallback(h,4,0,value);}
static void Custom4(I3C_HandleTypeDef *h, uint64_t value){traceCallback(h,4,1,value);}
void HAL_I3C_TgtTxCpltCallback(I3C_HandleTypeDef *h){traceCallback(h,5,0,0);}
static void Custom5(I3C_HandleTypeDef *h){traceCallback(h,5,1,0);}
void HAL_I3C_TgtRxCpltCallback(I3C_HandleTypeDef *h){traceCallback(h,6,0,0);}
static void Custom6(I3C_HandleTypeDef *h){traceCallback(h,6,1,0);}
void HAL_I3C_TgtHotJoinCallback(I3C_HandleTypeDef *h, uint8_t value){traceCallback(h,7,0,value);}
static void Custom7(I3C_HandleTypeDef *h, uint8_t value){traceCallback(h,7,1,value);}
void HAL_I3C_NotifyCallback(I3C_HandleTypeDef *h, uint32_t value){traceCallback(h,8,0,value);}
static void Custom8(I3C_HandleTypeDef *h, uint32_t value){traceCallback(h,8,1,value);}
void HAL_I3C_ErrorCallback(I3C_HandleTypeDef *h){traceCallback(h,9,0,0);}
static void Custom9(I3C_HandleTypeDef *h){traceCallback(h,9,1,0);}
void HAL_I3C_AbortCpltCallback(I3C_HandleTypeDef *h){traceCallback(h,10,0,0);}
static void Custom10(I3C_HandleTypeDef *h){traceCallback(h,10,1,0);}
void HAL_I3C_MspInit(I3C_HandleTypeDef *h){traceCallback(h,11,0,0);}
static void Custom11(I3C_HandleTypeDef *h){traceCallback(h,11,1,0);}
void HAL_I3C_MspDeInit(I3C_HandleTypeDef *h){traceCallback(h,12,0,0);}
static void Custom12(I3C_HandleTypeDef *h){traceCallback(h,12,1,0);}
uintptr_t CI3C_Callback(uint32_t id,uint32_t custom){if(!custom)return 0;switch(id){case 0:return (uintptr_t)(custom==1?HAL_I3C_CtrlTxCpltCallback:Custom0);case 1:return (uintptr_t)(custom==1?HAL_I3C_CtrlRxCpltCallback:Custom1);case 2:return (uintptr_t)(custom==1?HAL_I3C_CtrlMultipleXferCpltCallback:Custom2);case 3:return (uintptr_t)(custom==1?HAL_I3C_CtrlDAACpltCallback:Custom3);case 4:return (uintptr_t)(custom==1?HAL_I3C_TgtReqDynamicAddrCallback:Custom4);case 5:return (uintptr_t)(custom==1?HAL_I3C_TgtTxCpltCallback:Custom5);case 6:return (uintptr_t)(custom==1?HAL_I3C_TgtRxCpltCallback:Custom6);case 7:return (uintptr_t)(custom==1?HAL_I3C_TgtHotJoinCallback:Custom7);case 8:return (uintptr_t)(custom==1?HAL_I3C_NotifyCallback:Custom8);case 9:return (uintptr_t)(custom==1?HAL_I3C_ErrorCallback:Custom9);case 10:return (uintptr_t)(custom==1?HAL_I3C_AbortCpltCallback:Custom10);case 11:return (uintptr_t)(custom==1?HAL_I3C_MspInit:Custom11);case 12:return (uintptr_t)(custom==1?HAL_I3C_MspDeInit:Custom12);default:assert(0);return 0;}}
uintptr_t CI3C_GetCallback(CI3CState *s,uint32_t i){switch(i){case 0:return (uintptr_t)s->h.CtrlTxCpltCallback;case 1:return (uintptr_t)s->h.CtrlRxCpltCallback;case 2:return (uintptr_t)s->h.CtrlMultipleXferCpltCallback;case 3:return (uintptr_t)s->h.CtrlDAACpltCallback;case 4:return (uintptr_t)s->h.TgtReqDynamicAddrCallback;case 5:return (uintptr_t)s->h.TgtTxCpltCallback;case 6:return (uintptr_t)s->h.TgtRxCpltCallback;case 7:return (uintptr_t)s->h.TgtHotJoinCallback;case 8:return (uintptr_t)s->h.NotifyCallback;case 9:return (uintptr_t)s->h.ErrorCallback;case 10:return (uintptr_t)s->h.AbortCpltCallback;case 11:return (uintptr_t)s->h.MspInitCallback;case 12:return (uintptr_t)s->h.MspDeInitCallback;default:assert(0);return 0;}}
void CI3C_SetCallback(CI3CState *s,uint32_t i,uintptr_t v){switch(i){case 0:s->h.CtrlTxCpltCallback=(pI3C_CallbackTypeDef)v;break;case 1:s->h.CtrlRxCpltCallback=(pI3C_CallbackTypeDef)v;break;case 2:s->h.CtrlMultipleXferCpltCallback=(pI3C_CallbackTypeDef)v;break;case 3:s->h.CtrlDAACpltCallback=(pI3C_CallbackTypeDef)v;break;case 4:s->h.TgtReqDynamicAddrCallback=(pI3C_TgtReqDynamicAddrCallbackTypeDef)v;break;case 5:s->h.TgtTxCpltCallback=(pI3C_CallbackTypeDef)v;break;case 6:s->h.TgtRxCpltCallback=(pI3C_CallbackTypeDef)v;break;case 7:s->h.TgtHotJoinCallback=(pI3C_TgtHotJoinCallbackTypeDef)v;break;case 8:s->h.NotifyCallback=(pI3C_NotifyCallbackTypeDef)v;break;case 9:s->h.ErrorCallback=(pI3C_CallbackTypeDef)v;break;case 10:s->h.AbortCpltCallback=(pI3C_CallbackTypeDef)v;break;case 11:s->h.MspInitCallback=(pI3C_CallbackTypeDef)v;break;case 12:s->h.MspDeInitCallback=(pI3C_CallbackTypeDef)v;break;default:assert(0);}}
uint32_t CI3C_RecordDMA(CI3CState *s,uint32_t d,uint32_t op,uint32_t a,uint32_t b,uint32_t size){
uint32_t *n=&s->control[15];assert(*n+9<=1024);
uint32_t values[9]={d,op,CI3C_Normalize(s,a),CI3C_Normalize(s,b),size,s->h.State,s->h.ErrorCode,s->h.Instance->CFGR,s->h.TxXferCount};
for(uint32_t i=0;i<9;i++)s->dmaTrace[(*n)++]=values[i];return s->settings[d][4+op];}
static uint32_t dmaIndex(DMA_HandleTypeDef *h){for(uint32_t i=0;i<3;i++)if(h==&CI3C_Active->dma[i])return i;assert(0);return 0;}
HAL_StatusTypeDef CI3C_DMAStart(DMA_HandleTypeDef *h,uint32_t a,uint32_t b,uint32_t n){return (HAL_StatusTypeDef)CI3C_RecordDMA(CI3C_Active,dmaIndex(h),0,a,b,n);}
HAL_StatusTypeDef CI3C_DMAAbort(DMA_HandleTypeDef *h){return (HAL_StatusTypeDef)CI3C_RecordDMA(CI3C_Active,dmaIndex(h),1,0,0,0);}
HAL_StatusTypeDef CI3C_DMAAbortIT(DMA_HandleTypeDef *h){CI3CState *s=CI3C_Active;uint32_t d=dmaIndex(h),v=CI3C_RecordDMA(s,d,2,0,0,0);if(s->settings[d][7]&&h->XferAbortCallback)h->XferAbortCallback(h);return (HAL_StatusTypeDef)v;}
uint32_t CI3C_DMACounter(DMA_HandleTypeDef *h){return CI3C_Active->settings[dmaIndex(h)][2];}
uint32_t CI3C_DMAFIFO(DMA_HandleTypeDef *h){return CI3C_Active->settings[dmaIndex(h)][3];}
uint32_t CI3C_DMAState(DMA_HandleTypeDef *h){return h->State;}
void CI3C_Reset(CI3CState *s,uint32_t callbacks){memset(s,0,sizeof(*s));s->h.Instance=&s->regs;s->control[0]=callbacks;s->control[2]=1;
for(uint32_t i=0;i<13;i++)CI3C_SetCallback(s,i,CI3C_Callback(i,1));
for(uint32_t d=0;d<3;d++){s->dma[d].Instance=&s->dmaRegs[d];s->dma[d].Parent=&s->h;}
}
uint32_t CI3C_Compare(CI3CState *a,CI3CState *b){
for(uint32_t i=0;i<54;i++)if(CI3C_Get(a,0,i)!=CI3C_Get(b,0,i))return 0x010000+i;
for(uint32_t i=0;i<20;i++)if(CI3C_Get(a,1,i)!=CI3C_Get(b,1,i))return 0x020000+i;
for(uint32_t i=0;i<64;i++)if(CI3C_Get(a,2,i)!=CI3C_Get(b,2,i))return 0x030000+i;
for(uint32_t i=0;i<16;i++)if(CI3C_Get(a,3,i)!=CI3C_Get(b,3,i))return 0x040000+i;
for(uint32_t i=0;i<16;i++)if(CI3C_Get(a,4,i)!=CI3C_Get(b,4,i))return 0x050000+i;
for(uint32_t i=0;i<16;i++)if(CI3C_Get(a,5,i)!=CI3C_Get(b,5,i))return 0x060000+i;
for(uint32_t i=0;i<4;i++)if(CI3C_Get(a,6,i)!=CI3C_Get(b,6,i))return 0x070000+i;
for(uint32_t i=0;i<4;i++)if(CI3C_Get(a,7,i)!=CI3C_Get(b,7,i))return 0x080000+i;
for(uint32_t i=0;i<4;i++)if(CI3C_Get(a,8,i)!=CI3C_Get(b,8,i))return 0x090000+i;
for(uint32_t i=0;i<1024;i++)if(CI3C_Get(a,9,i)!=CI3C_Get(b,9,i))return 0x0a0000+i;
for(uint32_t i=0;i<1024;i++)if(CI3C_Get(a,10,i)!=CI3C_Get(b,10,i))return 0x0b0000+i;
for(uint32_t i=0;i<4096;i++)if(CI3C_Get(a,11,i)!=CI3C_Get(b,11,i))return 0x0c0000+i;
for(uint32_t i=0;i<4;i++)if(CI3C_Get(a,12,i)!=CI3C_Get(b,12,i))return 0x0d0000+i;
for(uint32_t i=0;i<8;i++)if(CI3C_Get(a,20,i)!=CI3C_Get(b,20,i))return 0x150000+i;
for(uint32_t i=0;i<1;i++)if(CI3C_Get(a,21,i)!=CI3C_Get(b,21,i))return 0x160000+i;
for(uint32_t i=0;i<4;i++)if(CI3C_Get(a,22,i)!=CI3C_Get(b,22,i))return 0x170000+i;
for(uint32_t i=0;i<8;i++)if(CI3C_Get(a,23,i)!=CI3C_Get(b,23,i))return 0x180000+i;
for(uint32_t i=0;i<18;i++)if(CI3C_Get(a,24,i)!=CI3C_Get(b,24,i))return 0x190000+i;
for(uint32_t i=0;i<24;i++)if(CI3C_Get(a,25,i)!=CI3C_Get(b,25,i))return 0x1a0000+i;
for(uint32_t i=0;i<12;i++)if(CI3C_Get(a,26,i)!=CI3C_Get(b,26,i))return 0x1b0000+i;
for(uint32_t i=0;i<12;i++)if(CI3C_Get(a,27,i)!=CI3C_Get(b,27,i))return 0x1c0000+i;
for(uint32_t i=0;i<40;i++)if(CI3C_Get(a,28,i)!=CI3C_Get(b,28,i))return 0x1d0000+i;
for(uint32_t i=0;i<48;i++)if(CI3C_Get(a,29,i)!=CI3C_Get(b,29,i))return 0x1e0000+i;
for(uint32_t i=0;i<8;i++)if(CI3C_Get(a,30,i)!=CI3C_Get(b,30,i))return 0x1f0000+i;
for(uint32_t i=0;i<3;i++)if(CI3C_GetPointer(a,i)!=CI3C_GetPointer(b,i))return 0x400000+i;
for(uint32_t i=0;i<13;i++)if(CI3C_GetCallback(a,i)!=CI3C_GetCallback(b,i))return 0x410000+i;
for(uint32_t i=0;i<2048;i++)if(((uint32_t *)a->buffers)[i]!=((uint32_t *)b->buffers)[i])return 0x420000+i;
return 0;}
uint32_t CI3C_Constant(uint32_t i){switch(i){case 0:return EVENT_ID_CR;case 1:return EVENT_ID_DAU;case 2:return EVENT_ID_DEFGRPA;case 3:return EVENT_ID_DEFTGTS;case 4:return EVENT_ID_ENEC_DISEC;case 5:return EVENT_ID_ENTASx;case 6:return EVENT_ID_GETACCCR;case 7:return EVENT_ID_GETSTATUS;case 8:return EVENT_ID_GETx;case 9:return EVENT_ID_HJ;case 10:return EVENT_ID_IBI;case 11:return EVENT_ID_IBIEND;case 12:return EVENT_ID_RSTACT;case 13:return EVENT_ID_SETMRL;case 14:return EVENT_ID_SETMWL;case 15:return EVENT_ID_WKP;case 16:return HAL_I3C_ABORT_CB_ID;case 17:return HAL_I3C_ALL_COMMON_ITS;case 18:return HAL_I3C_ALL_CTRL_ITS;case 19:return HAL_I3C_ALL_TGT_ITS;case 20:return HAL_I3C_BCR_IN_PAYLOAD_SHIFT;case 21:return HAL_I3C_CONTROLFIFO_DISABLE;case 22:return HAL_I3C_CONTROLFIFO_ENABLE;case 23:return HAL_I3C_CTRL_DAA_COMPLETE_CB_ID;case 24:return HAL_I3C_CTRL_MULTIPLE_XFER_COMPLETE_CB_ID;case 25:return HAL_I3C_CTRL_RX_COMPLETE_CB_ID;case 26:return HAL_I3C_CTRL_TX_COMPLETE_CB_ID;case 27:return HAL_I3C_DIRECTION_BOTH;case 28:return HAL_I3C_DIRECTION_READ;case 29:return HAL_I3C_DIRECTION_WRITE;case 30:return HAL_I3C_ERROR_ADDRESS_NACK;case 31:return HAL_I3C_ERROR_CB_ID;case 32:return HAL_I3C_ERROR_CE0;case 33:return HAL_I3C_ERROR_CE1;case 34:return HAL_I3C_ERROR_CE2;case 35:return HAL_I3C_ERROR_CE3;case 36:return HAL_I3C_ERROR_COVR;case 37:return HAL_I3C_ERROR_DATA_HAND_OFF;case 38:return HAL_I3C_ERROR_DATA_NACK;case 39:return HAL_I3C_ERROR_DMA;case 40:return HAL_I3C_ERROR_DMA_PARAM;case 41:return HAL_I3C_ERROR_DOVR;case 42:return HAL_I3C_ERROR_DYNAMIC_ADDR;case 43:return HAL_I3C_ERROR_INVALID_CALLBACK;case 44:return HAL_I3C_ERROR_INVALID_PARAM;case 45:return HAL_I3C_ERROR_NONE;case 46:return HAL_I3C_ERROR_NOT_ALLOWED;case 47:return HAL_I3C_ERROR_SIZE;case 48:return HAL_I3C_ERROR_STALL;case 49:return HAL_I3C_ERROR_TE0;case 50:return HAL_I3C_ERROR_TE1;case 51:return HAL_I3C_ERROR_TE2;case 52:return HAL_I3C_ERROR_TE3;case 53:return HAL_I3C_ERROR_TE4;case 54:return HAL_I3C_ERROR_TE5;case 55:return HAL_I3C_ERROR_TE6;case 56:return HAL_I3C_ERROR_TIMEOUT;case 57:return HAL_I3C_FLAG_ASUPDF;case 58:return HAL_I3C_FLAG_CFEF;case 59:return HAL_I3C_FLAG_CFNFF;case 60:return HAL_I3C_FLAG_CRF;case 61:return HAL_I3C_FLAG_CRUPDF;case 62:return HAL_I3C_FLAG_DAUPDF;case 63:return HAL_I3C_FLAG_DEFF;case 64:return HAL_I3C_FLAG_ERRF;case 65:return HAL_I3C_FLAG_FCF;case 66:return HAL_I3C_FLAG_GETF;case 67:return HAL_I3C_FLAG_GRPF;case 68:return HAL_I3C_FLAG_HJF;case 69:return HAL_I3C_FLAG_IBIENDF;case 70:return HAL_I3C_FLAG_IBIF;case 71:return HAL_I3C_FLAG_INTUPDF;case 72:return HAL_I3C_FLAG_MRLUPDF;case 73:return HAL_I3C_FLAG_MWLUPDF;case 74:return HAL_I3C_FLAG_RSTF;case 75:return HAL_I3C_FLAG_RXFNEF;case 76:return HAL_I3C_FLAG_RXLASTF;case 77:return HAL_I3C_FLAG_RXTGTENDF;case 78:return HAL_I3C_FLAG_SFNEF;case 79:return HAL_I3C_FLAG_STAF;case 80:return HAL_I3C_FLAG_TXFEF;case 81:return HAL_I3C_FLAG_TXFNFF;case 82:return HAL_I3C_FLAG_TXLASTF;case 83:return HAL_I3C_FLAG_WKPF;case 84:return HAL_I3C_GETMXDS_FORMAT_1;case 85:return HAL_I3C_GETMXDS_FORMAT_2_LSB;case 86:return HAL_I3C_GETMXDS_FORMAT_2_MID;case 87:return HAL_I3C_GETMXDS_FORMAT_2_MSB;case 88:return HAL_I3C_HANDOFF_ACTIVITY_STATE_0;case 89:return HAL_I3C_HANDOFF_ACTIVITY_STATE_1;case 90:return HAL_I3C_HANDOFF_ACTIVITY_STATE_2;case 91:return HAL_I3C_HANDOFF_ACTIVITY_STATE_3;case 92:return HAL_I3C_HDR_EXIT_PATTERN;case 93:return HAL_I3C_IT_ASUPDIE;case 94:return HAL_I3C_IT_CFNFIE;case 95:return HAL_I3C_IT_CRIE;case 96:return HAL_I3C_IT_CRUPDIE;case 97:return HAL_I3C_IT_DAUPDIE;case 98:return HAL_I3C_IT_DEFIE;case 99:return HAL_I3C_IT_ERRIE;case 100:return HAL_I3C_IT_FCIE;case 101:return HAL_I3C_IT_GETIE;case 102:return HAL_I3C_IT_GRPIE;case 103:return HAL_I3C_IT_HJIE;case 104:return HAL_I3C_IT_IBIENDIE;case 105:return HAL_I3C_IT_IBIIE;case 106:return HAL_I3C_IT_INTUPDIE;case 107:return HAL_I3C_IT_MRLUPDIE;case 108:return HAL_I3C_IT_MWLUPDIE;case 109:return HAL_I3C_IT_RSTIE;case 110:return HAL_I3C_IT_RXFNEIE;case 111:return HAL_I3C_IT_RXTGTENDIE;case 112:return HAL_I3C_IT_SFNEIE;case 113:return HAL_I3C_IT_STAIE;case 114:return HAL_I3C_IT_TXFNFIE;case 115:return HAL_I3C_IT_WKPIE;case 116:return HAL_I3C_MODE_CONTROLLER;case 117:return HAL_I3C_MODE_NONE;case 118:return HAL_I3C_MODE_TARGET;case 119:return HAL_I3C_MSPDEINIT_CB_ID;case 120:return HAL_I3C_MSPINIT_CB_ID;case 121:return HAL_I3C_NOTIFY_CB_ID;case 122:return HAL_I3C_OWN_ACTIVITY_STATE_0;case 123:return HAL_I3C_OWN_ACTIVITY_STATE_1;case 124:return HAL_I3C_OWN_ACTIVITY_STATE_2;case 125:return HAL_I3C_OWN_ACTIVITY_STATE_3;case 126:return HAL_I3C_PAYLOAD_1_BYTE;case 127:return HAL_I3C_PAYLOAD_2_BYTES;case 128:return HAL_I3C_PAYLOAD_3_BYTES;case 129:return HAL_I3C_PAYLOAD_4_BYTES;case 130:return HAL_I3C_PAYLOAD_EMPTY;case 131:return HAL_I3C_RESET_PATTERN_DISABLE;case 132:return HAL_I3C_RESET_PATTERN_ENABLE;case 133:return HAL_I3C_RXFIFO_THRESHOLD_1_4;case 134:return HAL_I3C_RXFIFO_THRESHOLD_4_4;case 135:return HAL_I3C_SDA_HOLD_TIME_0_5;case 136:return HAL_I3C_SDA_HOLD_TIME_1_5;case 137:return HAL_I3C_STATE_ABORT;case 138:return HAL_I3C_STATE_BUSY;case 139:return HAL_I3C_STATE_BUSY_DAA;case 140:return HAL_I3C_STATE_BUSY_RX;case 141:return HAL_I3C_STATE_BUSY_TX;case 142:return HAL_I3C_STATE_BUSY_TX_RX;case 143:return HAL_I3C_STATE_ERROR;case 144:return HAL_I3C_STATE_LISTEN;case 145:return HAL_I3C_STATE_READY;case 146:return HAL_I3C_STATE_RESET;case 147:return HAL_I3C_STATUSFIFO_DISABLE;case 148:return HAL_I3C_STATUSFIFO_ENABLE;case 149:return HAL_I3C_TARGET_RESET_PATTERN;case 150:return HAL_I3C_TGT_HOTJOIN_CB_ID;case 151:return HAL_I3C_TGT_REQ_DYNAMIC_ADDR_CB_ID;case 152:return HAL_I3C_TGT_RX_COMPLETE_CB_ID;case 153:return HAL_I3C_TGT_TX_COMPLETE_CB_ID;case 154:return HAL_I3C_TURNAROUND_TIME_TSCO_GREATER_12NS;case 155:return HAL_I3C_TURNAROUND_TIME_TSCO_LESS_12NS;case 156:return HAL_I3C_TXFIFO_THRESHOLD_1_4;case 157:return HAL_I3C_TXFIFO_THRESHOLD_4_4;case 158:return I2C_PRIVATE_WITHOUT_ARB_RESTART;case 159:return I2C_PRIVATE_WITHOUT_ARB_STOP;case 160:return I2C_PRIVATE_WITH_ARB_RESTART;case 161:return I2C_PRIVATE_WITH_ARB_STOP;case 162:return I3C_BROADCAST_WITHOUT_DEFBYTE_RESTART;case 163:return I3C_BROADCAST_WITHOUT_DEFBYTE_STOP;case 164:return I3C_BROADCAST_WITH_DEFBYTE_RESTART;case 165:return I3C_BROADCAST_WITH_DEFBYTE_STOP;case 166:return I3C_DIRECT_WITHOUT_DEFBYTE_RESTART;case 167:return I3C_DIRECT_WITHOUT_DEFBYTE_STOP;case 168:return I3C_DIRECT_WITH_DEFBYTE_RESTART;case 169:return I3C_DIRECT_WITH_DEFBYTE_STOP;case 170:return I3C_ONLY_ENTDAA;case 171:return I3C_PRIVATE_WITHOUT_ARB_RESTART;case 172:return I3C_PRIVATE_WITHOUT_ARB_STOP;case 173:return I3C_PRIVATE_WITH_ARB_RESTART;case 174:return I3C_PRIVATE_WITH_ARB_STOP;case 175:return I3C_RSTDAA_THEN_ENTDAA;default:assert(0);return 0;}}
