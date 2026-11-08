#include "PSSIInternal.h"
CPSSIState *CPSSI_Active;
size_t CPSSI_Size(void) { return sizeof(CPSSIState); }
static volatile uint32_t *handleWord(CPSSIState *s,uint32_t i) {
 switch(i) { case 0:return &s->h.Init.DataWidth;case 1:return &s->h.Init.BusWidth;case 2:return &s->h.Init.ControlSignal;case 3:return &s->h.Init.ClockPolarity;case 4:return &s->h.Init.DataEnablePolarity;case 5:return &s->h.Init.ReadyPolarity;case 6:return &s->h.XferCount;case 7:return &s->h.XferSize;case 8:return (uint32_t*)&s->h.Lock;case 9:return (uint32_t*)&s->h.State;case 10:return (uint32_t*)&s->h.ErrorCode;default:assert(0);return NULL; }
}
static uint32_t normalize(CPSSIState *s,uint32_t a) {
 uint32_t data=(uint32_t)(uintptr_t)s->data,dr=(uint32_t)(uintptr_t)&s->regs.DR;
 if(a-data<256)return 0x24001000U+(a-data);
 if(a==dr)return 0x48000428U;
 return a;
}
static void setDMA(CPSSIState *s,uint32_t d,uint32_t i,uint32_t v) {
 if(s->mode) { if(s->dmaEnabled)CPSSI11_SetDMA(s,d,i,v);else CPSSI10_SetDMA(s,d,i,v); }
 else { if(s->dmaEnabled)CPSSI01_SetDMA(s,d,i,v);else CPSSI00_SetDMA(s,d,i,v); }
}
static uint32_t getDMA(CPSSIState *s,uint32_t d,uint32_t i) {
 if(s->mode)return s->dmaEnabled?CPSSI11_GetDMA(s,d,i):CPSSI10_GetDMA(s,d,i);
 return s->dmaEnabled?CPSSI01_GetDMA(s,d,i):CPSSI00_GetDMA(s,d,i);
}
void CPSSI_Reset(CPSSIState *s,uint32_t mode,uint32_t dma) {
 memset(s,0,sizeof(*s));s->mode=mode;s->dmaEnabled=dma;s->h.Instance=&s->regs;s->h.pBuffPtr=(uint32_t*)s->data;
 s->control[1]=1;
 for(uint32_t i=0;i<256;i++)s->data[i]=(uint8_t)(i*17+3);
 for(uint32_t d=0;d<2;d++) { s->dma[d].Parent=&s->h;s->dma[d].LinkedListQueue=&s->queues[d];s->queues[d].Head=&s->nodes[d];s->meta[d][0]=1;s->meta[d][3]=1;s->meta[d][4]=1; }
 s->h.hdmatx=&s->dma[0];s->h.hdmarx=&s->dma[1];
 for(uint32_t i=0;i<7;i++)if(i!=2)CPSSI_SetCallback(s,i,1);
}
uint32_t CPSSI_Get(CPSSIState *s,uint32_t area,uint32_t index) {
 switch(area) {
 case 0:assert(index<11);return ((uint32_t*)&s->regs)[index];
 case 1:return *handleWord(s,index);
 case 2:{uint32_t d=index/15,i=index%15;switch(i) {
 case 0:return d?s->h.hdmarx!=NULL:s->h.hdmatx!=NULL;
 case 1:return s->dma[d].Mode;
 case 2:return d?s->dma[d].Init.SrcDataWidth:s->dma[d].Init.DestDataWidth;
 case 3:return s->dma[d].LinkedListQueue!=NULL;
 case 4:return s->queues[d].Head!=NULL;
 case 5:return s->nodes[d].LinkRegisters[2];
 case 6:return normalize(s,s->nodes[d].LinkRegisters[3]);
 case 7:return normalize(s,s->nodes[d].LinkRegisters[4]);
 case 8:case 9:case 10:case 11:return getDMA(s,d,i-8);
 default:return s->meta[d][i];}}
 case 3:assert(index<12);return s->control[index];
 case 4:assert(index<256);return s->data[index];
 case 5:assert(index<8);return s->calls[index];
 case 6:return index?s->tickCalls:s->tick;
 case 7:return s->traceCount;
 case 9:return index?s->dmaEnabled:s->mode;
 case 8:return s->h.pBuffPtr?(uint32_t)((uintptr_t)s->h.pBuffPtr-(uintptr_t)s->data)+1:0;
 default:assert(0);return 0;
 }
}
void CPSSI_Set(CPSSIState *s,uint32_t area,uint32_t index,uint32_t value) {
 switch(area) {
 case 0:assert(index<11);((uint32_t*)&s->regs)[index]=value;break;
 case 1:*handleWord(s,index)=value;break;
 case 2:{uint32_t d=index/15,i=index%15;s->meta[d][i]=value;switch(i) {
 case 0:if(d)s->h.hdmarx=value?&s->dma[d]:NULL;else s->h.hdmatx=value?&s->dma[d]:NULL;break;
 case 1:s->dma[d].Mode=value;break;
 case 2:if(d)s->dma[d].Init.SrcDataWidth=value;else s->dma[d].Init.DestDataWidth=value;break;
 case 3:s->dma[d].LinkedListQueue=value?&s->queues[d]:NULL;break;
 case 4:s->queues[d].Head=value?&s->nodes[d]:NULL;break;
 case 5:s->nodes[d].LinkRegisters[2]=value;break;
 case 6:s->nodes[d].LinkRegisters[3]=value;break;
 case 7:s->nodes[d].LinkRegisters[4]=value;break;
 case 8:case 9:case 10:case 11:setDMA(s,d,i-8,value);break;
 }break;}
 case 3:assert(index<12);s->control[index]=value;break;
 case 4:assert(index<256);s->data[index]=(uint8_t)value;break;
 case 5:assert(index<8);s->calls[index]=value;break;
 case 6:if(index)s->tickCalls=value;else s->tick=value;break;
 case 7:s->traceCount=value;break;
 case 8:s->h.pBuffPtr=value?(uint32_t*)(s->data+value-1):NULL;break;
 default:assert(0);
 }
}
void *CPSSI_Buffer(CPSSIState *s,uint32_t offset) { assert(offset<256);return s->data+offset; }
void *CPSSI_GetBuffer(CPSSIState *s) { return s->h.pBuffPtr; }
void CPSSI_SetBuffer(CPSSIState *s,void *p) { s->h.pBuffPtr=p; }
static void trace(CPSSIState *s,uint32_t id,uint32_t token) {
 assert(s->traceCount<32);uint32_t *out=s->trace[s->traceCount++],n=0;
 out[n++]=id;out[n++]=token;
 const uint32_t areas[]={0,1,2,3,5,6,8},counts[]={11,11,30,12,8,2,1};
 for(uint32_t a=0;a<7;a++)for(uint32_t i=0;i<counts[a];i++)out[n++]=CPSSI_Get(s,areas[a],i);
 for(uint32_t i=0;i<7;i++)out[n++]=CPSSI_GetCallback(s,i);
 for(uint32_t i=0;i<32;i++)out[n++]=s->data[i];
 while(n<128)out[n++]=0;
}
void CPSSI_Callback(CPSSIState *s,uint32_t id,uint32_t token) {
 trace(s,id,token);
 if(s->control[4]) { s->h.State=HAL_PSSI_STATE_ABORT;s->h.ErrorCode=0x8000;s->h.Lock=HAL_LOCKED;s->regs.CR=0;s->regs.IER=0;for(uint32_t i=0;i<7;i++)if(i!=2)CPSSI_SetCallback(s,i,2); }
 if(s->control[5] && id==5) { s->h.Init.ControlSignal=0x1C0000;s->h.Init.BusWidth=0xC00;s->h.Init.DataEnablePolarity=0x40;s->h.Init.ReadyPolarity=0x100; }
}
uint32_t CPSSI_Tick(CPSSIState *s) {
 uint32_t result=s->tick;s->tick+=s->control[1];s->tickCalls++;
 if(s->control[2] && s->tickCalls>=s->control[2])s->regs.SR=s->control[3];
 if(s->control[9])s->regs.DR=s->control[9]+s->tickCalls;
 return result;
}
uint32_t CPSSI_Start(CPSSIState *s,uint32_t dir,uint32_t linked,uint32_t source,uint32_t destination,uint32_t size) {
 s->calls[0]++;s->calls[1]=dir;s->calls[2]=linked;s->calls[3]=normalize(s,source);s->calls[4]=normalize(s,destination);s->calls[5]=size;
 trace(s,20+dir,linked);return s->meta[dir][12];
}
uint32_t CPSSI_Abort(CPSSIState *s,uint32_t dir) { s->calls[6]++;s->calls[7]=dir;trace(s,30+dir,0);return s->meta[dir][13]; }
uint32_t CPSSI_Run(CPSSIState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {
 if(s->mode)return s->dmaEnabled?CPSSI11_Run(s,op,a,b,c):CPSSI10_Run(s,op,a,b,c);
 return s->dmaEnabled?CPSSI01_Run(s,op,a,b,c):CPSSI00_Run(s,op,a,b,c);
}
uint32_t CPSSI_TraceCount(CPSSIState *s) { return s->traceCount; }
uint32_t CPSSI_TraceWord(CPSSIState *s,uint32_t e,uint32_t w) { assert(e<32 && w<128);return s->trace[e][w]; }
