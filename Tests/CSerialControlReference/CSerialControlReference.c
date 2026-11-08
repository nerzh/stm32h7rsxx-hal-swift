#include "SerialInternal.h"
CSerialState *CSerial_Active;
size_t CSerial_Size(void) { return sizeof(CSerialState); }
void CSerial_Reset(CSerialState *s,uint32_t kind,uint32_t mode) {
 memset(s,0,sizeof(*s));s->kind=kind;s->mode=mode;s->mh.Instance=&s->mdios;s->ch.Instance=&s->cec;
 s->ch.Init.RxBuffer=s->data+65536;s->ch.pTxBuffPtr=s->data+65536;
 for(uint32_t i=0;i<sizeof(s->data);i++)s->data[i]=(uint8_t)(i*17U+3U);
}
static uint32_t *cecWord(CSerialState *s,uint32_t index) {
 switch(index) {
 case 0:return &s->ch.Init.SignalFreeTime;
 case 1:return &s->ch.Init.Tolerance;
 case 2:return &s->ch.Init.BRERxStop;
 case 3:return &s->ch.Init.BREErrorBitGen;
 case 4:return &s->ch.Init.LBPEErrorBitGen;
 case 5:return &s->ch.Init.BroadcastMsgNoErrorBitGen;
 case 6:return &s->ch.Init.SignalFreeTimeOption;
 case 7:return &s->ch.Init.ListenMode;
 case 8:return (uint32_t *)&s->ch.Lock;
 case 9:return &s->ch.gState;
 case 10:return &s->ch.RxState;
 case 11:return &s->ch.ErrorCode;
 default:assert(0);return NULL;
 }
}
void *CSerial_Buffer(CSerialState *s,uint32_t offset) { assert(offset<sizeof(s->data));return s->data+offset; }
void *CSerial_GetPointer(CSerialState *s,uint32_t index) { return index==0?(void *)s->ch.pTxBuffPtr:s->ch.Init.RxBuffer; }
void CSerial_SetPointer(CSerialState *s,uint32_t index,void *value) { if(index==0)s->ch.pTxBuffPtr=value;else s->ch.Init.RxBuffer=value; }
uint32_t CSerial_Get(CSerialState *s,uint32_t area,uint32_t index) {
 if(area==0) { assert(index<(s->kind?6:128));return s->kind?((volatile uint32_t *)&s->cec)[index]:((volatile uint32_t *)&s->mdios)[index]; }
 if(area==1) {
  if(!s->kind) { assert(index<5);return ((volatile uint32_t *)&s->mh.Init)[index]; }
  if(index<12)return *cecWord(s,index);
  switch(index) { case 12:return s->ch.Init.OwnAddress;case 13:return s->ch.TxXferCount;case 14:return s->ch.RxXferSize;default:assert(0); }
 }
 if(area==2) { void *ptr=CSerial_GetPointer(s,index);return ptr?(uint32_t)((uint8_t *)ptr-s->data)+1:0; }
 if(area==3) { assert(index<4);return s->control[index]; }
 if(area==4) { assert(index<5);return ((uint32_t *)&s->exti)[index]; }
 if(area==5) { assert(index<sizeof(s->data));return s->data[index]; }
 assert(area==6 && index==0);return s->traceCount;
}
void CSerial_Set(CSerialState *s,uint32_t area,uint32_t index,uint32_t value) {
 if(area==0) { assert(index<(s->kind?6:128));if(s->kind)((volatile uint32_t *)&s->cec)[index]=value;else ((volatile uint32_t *)&s->mdios)[index]=value;return; }
 if(area==1) {
  if(!s->kind) { assert(index<5);((volatile uint32_t *)&s->mh.Init)[index]=value;return; }
  if(index<12) { *cecWord(s,index)=value;return; }
  switch(index) { case 12:s->ch.Init.OwnAddress=(uint16_t)value;return;case 13:s->ch.TxXferCount=(uint16_t)value;return;case 14:s->ch.RxXferSize=(uint16_t)value;return;default:assert(0); }
 }
 if(area==2) { CSerial_SetPointer(s,index,value?s->data+value-1:NULL);return; }
 if(area==3) { assert(index<4);s->control[index]=value;return; }
 if(area==4) { assert(index<5);((uint32_t *)&s->exti)[index]=value;return; }
 if(area==5) { assert(index<sizeof(s->data));s->data[index]=(uint8_t)value;return; }
 assert(area==6 && index==0);s->traceCount=value;
}
void CSerial_Callback(CSerialState *s,uint32_t id,uint32_t token,uint32_t size) {
 assert(s->traceCount<16);uint32_t *t=s->trace[s->traceCount++];t[0]=1;t[1]=id;t[2]=token;t[3]=size;uint32_t n=4;
 for(uint32_t i=0;i<128;i++)t[n++]=i<(s->kind?6:128)?CSerial_Get(s,0,i):0;
 for(uint32_t i=0;i<15;i++)t[n++]=i<(s->kind?15:5)?CSerial_Get(s,1,i):0;
 for(uint32_t i=0;i<6;i++)t[n++]=i<(s->kind?5:6)?CSerial_GetCallback(s,i):0;
 for(uint32_t i=0;i<5;i++)t[n++]=CSerial_Get(s,4,i);
 for(uint32_t i=0;i<4;i++)t[n++]=s->control[i];
 for(uint32_t i=0;i<2;i++)t[n++]=s->kind?CSerial_Get(s,2,i):0;
 for(uint32_t i=0;i<16;i++)t[n++]=s->data[65536+i];
 assert(n==180);
 if(s->control[0]) {
  if(s->kind) { s->ch.gState=0x24;s->ch.RxState=0x22;s->ch.ErrorCode=0x8000;s->ch.TxXferCount=5;s->ch.RxXferSize=3;s->ch.Init.RxBuffer=s->data+65560;s->cec.ISR=0;s->cec.IER=0; }
  else { s->mh.State=4;s->mh.ErrorCode=0x8000;s->mdios.CR=0;s->mdios.SR=0;s->mdios.WRFR=0;s->mdios.RDFR=0;s->exti.PR2=0; }
  for(uint32_t i=0;i<(s->kind?5:6);i++)CSerial_SetCallback(s,i,2);
 }
 if(s->control[1]) {
  if(s->kind) { s->ch.Init.SignalFreeTime=7;s->ch.Init.OwnAddress=0x1234; }
  else { s->mh.Init.PortAddress=31;s->mh.Init.PreambleCheck=0x80; }
 }
}
uint32_t CSerial_TraceCount(CSerialState *s) { return s->traceCount; }
uint32_t CSerial_TraceWord(CSerialState *s,uint32_t e,uint32_t w) { assert(e<s->traceCount && w<180);return s->trace[e][w]; }
uint32_t CSerial_Run(CSerialState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {
 CSerialState *old=CSerial_Active;CSerial_Active=s;uint32_t result;
 if(s->kind)result=s->mode?CSerialCEC1_Run(s,op,a,b,c):CSerialCEC0_Run(s,op,a,b,c);
 else result=s->mode?CSerialMDIOS1_Run(s,op,a,b,c):CSerialMDIOS0_Run(s,op,a,b,c);
 CSerial_Active=old;return result;
}
