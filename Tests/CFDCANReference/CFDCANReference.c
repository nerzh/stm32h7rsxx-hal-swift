#include "FDCANInternal.h"
#include <stdlib.h>
#include <assert.h>
FDCAN_GlobalTypeDef *CFDCAN_Instances[2];
FDCAN_Config_TypeDef *CFDCAN_Config;
uint32_t *CFDCAN_RAM;
static CFDCANState *active;
uint32_t CFDCAN0_Run(CFDCANState*,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CFDCAN1_Run(CFDCANState*,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t);
void CFDCAN_Reset(CFDCANState *s,uint32_t instance) {
 uint32_t mode=s->meta[4]; memset(s,0,sizeof(*s));s->meta[4]=mode;s->meta[2]=instance;s->control[0]=3;
 s->h.Instance=&s->regs[instance];for(uint32_t i=0;i<13;i++)CFDCAN_SetCallback(s,i,1);
}
CFDCANState *CFDCAN_Create(uint32_t mode,uint32_t instance) {CFDCANState *s=calloc(1,sizeof(*s));assert(s);s->meta[4]=mode;CFDCAN_Reset(s,instance);return s;}
void CFDCAN_Destroy(CFDCANState *s) {free(s);}
uint32_t CFDCAN_ModelTick(CFDCANState *s) {
 uint32_t value=s->meta[0];s->meta[0]+=s->control[0];s->meta[1]++;
 if(s->control[1] && s->meta[1]>=s->control[1]) {s->h.Instance->CCCR&=~s->control[2];s->h.Instance->CCCR|=s->control[3];}
 return value;
}
uint32_t CFDCAN_Tick(void) {return CFDCAN_ModelTick(active);}
uint8_t *CFDCAN_Data(CFDCANState *s,uint32_t output) {return s->data[output];}
void CFDCAN_Callback(CFDCANState *s,uint32_t id,uint32_t token,uint32_t arg) {
 uint32_t *r=s->trace[s->meta[3]++%32];r[0]=id;r[1]=token;r[2]=arg;r[3]=s->h.Instance->IR;r[4]=s->h.Instance->IE;r[5]=s->h.State;r[6]=s->h.ErrorCode;r[7]=s->h.Instance->TXBTIE;
 uint32_t m=s->control[4];if(m&1)s->h.Instance->IR=0;if(m&2)s->h.Instance->IE=0;
 if(m&4)s->h.ErrorCode|=128;if(m&8)s->h.ErrorCode=0;if(m&16)CFDCAN_SetCallback(s,4,2);
}
uint32_t CFDCAN_Get(CFDCANState *s,uint32_t area,uint32_t i) {
 switch(area) {
 case 0:return ((uint32_t*)s->regs)[i];case 1:return s->common.CKDIV;
 case 2:switch(i) {
case 0:return s->h.Init.ClockDivider;
case 1:return s->h.Init.FrameFormat;
case 2:return s->h.Init.Mode;
case 3:return s->h.Init.AutoRetransmission;
case 4:return s->h.Init.TransmitPause;
case 5:return s->h.Init.ProtocolException;
case 6:return s->h.Init.NominalPrescaler;
case 7:return s->h.Init.NominalSyncJumpWidth;
case 8:return s->h.Init.NominalTimeSeg1;
case 9:return s->h.Init.NominalTimeSeg2;
case 10:return s->h.Init.DataPrescaler;
case 11:return s->h.Init.DataSyncJumpWidth;
case 12:return s->h.Init.DataTimeSeg1;
case 13:return s->h.Init.DataTimeSeg2;
case 14:return s->h.Init.StdFiltersNbr;
case 15:return s->h.Init.ExtFiltersNbr;
case 16:return s->h.Init.TxFifoQueueMode;
case 17:return s->h.msgRam.StandardFilterSA?0x4000AC00U+(uint32_t)(s->h.msgRam.StandardFilterSA-(uintptr_t)s->ram):0;
case 18:return s->h.msgRam.ExtendedFilterSA?0x4000AC00U+(uint32_t)(s->h.msgRam.ExtendedFilterSA-(uintptr_t)s->ram):0;
case 19:return s->h.msgRam.RxFIFO0SA?0x4000AC00U+(uint32_t)(s->h.msgRam.RxFIFO0SA-(uintptr_t)s->ram):0;
case 20:return s->h.msgRam.RxFIFO1SA?0x4000AC00U+(uint32_t)(s->h.msgRam.RxFIFO1SA-(uintptr_t)s->ram):0;
case 21:return s->h.msgRam.TxEventFIFOSA?0x4000AC00U+(uint32_t)(s->h.msgRam.TxEventFIFOSA-(uintptr_t)s->ram):0;
case 22:return s->h.msgRam.TxFIFOQSA?0x4000AC00U+(uint32_t)(s->h.msgRam.TxFIFOQSA-(uintptr_t)s->ram):0;
case 23:return s->h.LatestTxFifoQRequest;
case 24:return s->h.State;
case 25:return s->h.Lock;
case 26:return s->h.ErrorCode;
}break;
 case 3:return ((uint32_t*)s->params)[i];case 4:return s->control[i];case 5:return s->meta[i];
 case 6:return s->ram[i];case 7:return ((uint32_t*)s->trace)[i];case 8:return ((uint8_t*)s->data)[i];
 }assert(0);return 0;
}
void CFDCAN_Set(CFDCANState *s,uint32_t area,uint32_t i,uint32_t value) {
 switch(area) {
 case 0:((uint32_t*)s->regs)[i]=value;return;case 1:s->common.CKDIV=value;return;
 case 2:switch(i) {
case 0:s->h.Init.ClockDivider=value;return;
case 1:s->h.Init.FrameFormat=value;return;
case 2:s->h.Init.Mode=value;return;
case 3:s->h.Init.AutoRetransmission=value;return;
case 4:s->h.Init.TransmitPause=value;return;
case 5:s->h.Init.ProtocolException=value;return;
case 6:s->h.Init.NominalPrescaler=value;return;
case 7:s->h.Init.NominalSyncJumpWidth=value;return;
case 8:s->h.Init.NominalTimeSeg1=value;return;
case 9:s->h.Init.NominalTimeSeg2=value;return;
case 10:s->h.Init.DataPrescaler=value;return;
case 11:s->h.Init.DataSyncJumpWidth=value;return;
case 12:s->h.Init.DataTimeSeg1=value;return;
case 13:s->h.Init.DataTimeSeg2=value;return;
case 14:s->h.Init.StdFiltersNbr=value;return;
case 15:s->h.Init.ExtFiltersNbr=value;return;
case 16:s->h.Init.TxFifoQueueMode=value;return;
case 17:s->h.msgRam.StandardFilterSA=value?(uintptr_t)s->ram+(value-0x4000AC00U):0;return;
case 18:s->h.msgRam.ExtendedFilterSA=value?(uintptr_t)s->ram+(value-0x4000AC00U):0;return;
case 19:s->h.msgRam.RxFIFO0SA=value?(uintptr_t)s->ram+(value-0x4000AC00U):0;return;
case 20:s->h.msgRam.RxFIFO1SA=value?(uintptr_t)s->ram+(value-0x4000AC00U):0;return;
case 21:s->h.msgRam.TxEventFIFOSA=value?(uintptr_t)s->ram+(value-0x4000AC00U):0;return;
case 22:s->h.msgRam.TxFIFOQSA=value?(uintptr_t)s->ram+(value-0x4000AC00U):0;return;
case 23:s->h.LatestTxFifoQRequest=value;return;
case 24:s->h.State=value;return;
case 25:s->h.Lock=value;return;
case 26:s->h.ErrorCode=value;return;
}break;
 case 3:((uint32_t*)s->params)[i]=value;return;case 4:s->control[i]=value;return;case 5:s->meta[i]=value;return;
 case 6:s->ram[i]=value;return;case 7:((uint32_t*)s->trace)[i]=value;return;case 8:((uint8_t*)s->data)[i]=(uint8_t)value;return;
 }assert(0);
}
uint32_t CFDCAN_Run(CFDCANState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c,uint32_t d) {
 active=s;CFDCAN_Instances[0]=&s->regs[0];CFDCAN_Instances[1]=&s->regs[1];CFDCAN_Config=&s->common;CFDCAN_RAM=s->ram;
 return s->meta[4]?CFDCAN1_Run(s,op,a,b,c,d):CFDCAN0_Run(s,op,a,b,c,d);
}
