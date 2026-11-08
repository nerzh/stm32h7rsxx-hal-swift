#include "SPDIFRXInternal.h"
CSPDIFRXState *CSPDIFRX_Active;
size_t CSPDIFRX_Size(void) { return sizeof(CSPDIFRXState); }
static uint32_t handleGet(CSPDIFRXState *s,uint32_t i) { switch(i) {case 0:return s->h.Init.InputSelection;case 1:return s->h.Init.Retries;case 2:return s->h.Init.WaitForActivity;case 3:return s->h.Init.ChannelSelection;case 4:return s->h.Init.DataFormat;case 5:return s->h.Init.StereoMode;case 6:return s->h.Init.PreambleTypeMask;case 7:return s->h.Init.ChannelStatusMask;case 8:return s->h.Init.ValidityBitMask;case 9:return s->h.Init.ParityErrorMask;case 10:return s->h.Init.SymbolClockGen;case 11:return s->h.Init.BackupSymbolClockGen;case 12:return s->h.RxXferSize;case 13:return s->h.RxXferCount;case 14:return s->h.CsXferSize;case 15:return s->h.CsXferCount;case 16:return s->h.Lock;case 17:return s->h.State;case 18:return s->h.ErrorCode;default:assert(0);return 0;} }
static void handleSet(CSPDIFRXState *s,uint32_t i,uint32_t v) { switch(i) {case 0:s->h.Init.InputSelection=v;break;case 1:s->h.Init.Retries=v;break;case 2:s->h.Init.WaitForActivity=v;break;case 3:s->h.Init.ChannelSelection=v;break;case 4:s->h.Init.DataFormat=v;break;case 5:s->h.Init.StereoMode=v;break;case 6:s->h.Init.PreambleTypeMask=v;break;case 7:s->h.Init.ChannelStatusMask=v;break;case 8:s->h.Init.ValidityBitMask=v;break;case 9:s->h.Init.ParityErrorMask=v;break;case 10:s->h.Init.SymbolClockGen=v;break;case 11:s->h.Init.BackupSymbolClockGen=v;break;case 12:s->h.RxXferSize=v;break;case 13:s->h.RxXferCount=v;break;case 14:s->h.CsXferSize=v;break;case 15:s->h.CsXferCount=v;break;case 16:s->h.Lock=v;break;case 17:s->h.State=v;break;case 18:s->h.ErrorCode=v;break;default:assert(0);} }
static uint32_t normalize(CSPDIFRXState *s,uint32_t address) {
 uint32_t base=(uint32_t)(uintptr_t)s->data;
 if(address-base<sizeof(s->data))return 0x24001000U+(address-base);
 if(address==(uint32_t)(uintptr_t)&s->regs.DR)return 0x40004010U;
 if(address==(uint32_t)(uintptr_t)&s->regs.CSR)return 0x40004014U;
 return address;
}
static uint32_t dmaGet(CSPDIFRXState *s,uint32_t d,uint32_t i) { return s->mode?CSPDIFRX1_GetDMA(s,d,i):CSPDIFRX0_GetDMA(s,d,i); }
static void dmaSet(CSPDIFRXState *s,uint32_t d,uint32_t i,uint32_t v) { if(s->mode)CSPDIFRX1_SetDMA(s,d,i,v);else CSPDIFRX0_SetDMA(s,d,i,v); }
void CSPDIFRX_Reset(CSPDIFRXState *s,uint32_t mode) {
 memset(s,0,sizeof(*s));s->mode=mode;s->h.Instance=&s->regs;s->h.pRxBuffPtr=s->data;s->h.pCsBuffPtr=s->data+64;
 s->h.hdmaDrRx=&s->dma[0];s->h.hdmaCsRx=&s->dma[1];s->control[0]=24000;s->control[1]=1;
 for(uint32_t d=0;d<2;d++) {s->dma[d].Parent=&s->h;s->dma[d].LinkedListQueue=&s->queue[d];s->queue[d].Head=&s->node[d];s->meta[d][0]=1;s->meta[d][2]=1;s->meta[d][3]=1;}
 for(uint32_t i=0;i<128;i++)s->data[i]=0xABC00000U+i;
 for(uint32_t i=0;i<7;i++)CSPDIFRX_SetCallback(s,i,1);
}
uint32_t CSPDIFRX_Get(CSPDIFRXState *s,uint32_t area,uint32_t i) {
 switch(area) {
 case 0:assert(i<7);return ((uint32_t*)&s->regs)[i];
 case 1:return handleGet(s,i);
 case 2:{uint32_t d=i/13,n=i%13;switch(n) {
 case 0:return d?s->h.hdmaCsRx!=NULL:s->h.hdmaDrRx!=NULL;
 case 1:return s->dma[d].Mode;case 2:return s->dma[d].LinkedListQueue!=NULL;case 3:return s->queue[d].Head!=NULL;
 case 4:return s->node[d].LinkRegisters[2];case 5:return normalize(s,s->node[d].LinkRegisters[3]);case 6:return normalize(s,s->node[d].LinkRegisters[4]);
 case 7:case 8:case 9:case 10:return dmaGet(s,d,n-7);default:return s->meta[d][n];}}
 case 3:assert(i<12);return s->control[i];
 case 4:assert(i<128);return s->data[i];
 case 5:assert(i<8);return s->calls[i];
 case 6:return i?s->tickCalls:s->tick;
 case 7:return s->traceCount;
 case 8:{uint32_t *p=i?s->h.pCsBuffPtr:s->h.pRxBuffPtr;return p?(uint32_t)(p-s->data)+1:0;}
 case 9:return s->mode;
 case 10:assert(i<6);return s->format[i];
 case 11:return s->global.CR;
 default:assert(0);return 0;
 }
}
void CSPDIFRX_Set(CSPDIFRXState *s,uint32_t area,uint32_t i,uint32_t v) {
 switch(area) {
 case 0:assert(i<7);((uint32_t*)&s->regs)[i]=v;break;
 case 1:handleSet(s,i,v);break;
 case 2:{uint32_t d=i/13,n=i%13;s->meta[d][n]=v;switch(n) {
 case 0:if(d)s->h.hdmaCsRx=v?&s->dma[d]:NULL;else s->h.hdmaDrRx=v?&s->dma[d]:NULL;break;
 case 1:s->dma[d].Mode=v;break;case 2:s->dma[d].LinkedListQueue=v?&s->queue[d]:NULL;break;case 3:s->queue[d].Head=v?&s->node[d]:NULL;break;
 case 4:s->node[d].LinkRegisters[2]=v;break;case 5:s->node[d].LinkRegisters[3]=v;break;case 6:s->node[d].LinkRegisters[4]=v;break;
 case 7:case 8:case 9:case 10:dmaSet(s,d,n-7,v);break;}break;}
 case 3:assert(i<12);s->control[i]=v;break;
 case 4:assert(i<128);s->data[i]=v;break;
 case 5:assert(i<8);s->calls[i]=v;break;
 case 6:if(i)s->tickCalls=v;else s->tick=v;break;
 case 7:s->traceCount=v;break;
 case 8:if(i)s->h.pCsBuffPtr=v?s->data+v-1:NULL;else s->h.pRxBuffPtr=v?s->data+v-1:NULL;break;
 case 10:assert(i<6);s->format[i]=v;break;
 case 11:s->global.CR=v;break;
 default:assert(0);
 }
}
uint32_t *CSPDIFRX_Buffer(CSPDIFRXState *s,uint32_t offset) { assert(offset<128);return s->data+offset; }
uint32_t *CSPDIFRX_GetBuffer(CSPDIFRXState *s,uint32_t d) {return d?s->h.pCsBuffPtr:s->h.pRxBuffPtr;}
void CSPDIFRX_SetBuffer(CSPDIFRXState *s,uint32_t d,uint32_t *p) {if(d)s->h.pCsBuffPtr=p;else s->h.pRxBuffPtr=p;}
static void trace(CSPDIFRXState *s,uint32_t id,uint32_t token) {
 assert(s->traceCount<32);uint32_t *out=s->trace[s->traceCount++],n=0;out[n++]=id;out[n++]=token;
 const uint32_t areas[]={0,1,2,3,4,5,6,8},counts[]={7,19,26,12,128,8,2,2};
 for(uint32_t a=0;a<8;a++)for(uint32_t i=0;i<counts[a];i++)out[n++]=CSPDIFRX_Get(s,areas[a],i);
 for(uint32_t i=0;i<7;i++)out[n++]=CSPDIFRX_GetCallback(s,i);
 assert(n<=224);while(n<224)out[n++]=0;
}
void CSPDIFRX_Callback(CSPDIFRXState *s,uint32_t id,uint32_t token) {
 trace(s,id,token);
 if(s->control[4]) {s->h.State=7;s->h.ErrorCode=0x8000;s->h.Lock=1;s->regs.CR=0;s->regs.IMR=0;for(uint32_t i=0;i<7;i++)CSPDIFRX_SetCallback(s,i,2);}
 if(s->control[5] && id==5) {s->h.Init.StereoMode=8;s->h.Init.InputSelection=0x30000;s->h.Init.SymbolClockGen=1;}
}
uint32_t CSPDIFRX_Tick(CSPDIFRXState *s) {
 uint32_t result=s->tick;s->tick+=s->control[1];s->tickCalls++;
 if(s->control[2] && s->tickCalls>=s->control[2])s->regs.SR=s->control[3];
 if(s->control[6]) {s->regs.DR=s->control[6]+s->tickCalls;s->regs.CSR=s->control[6]+0x100+s->tickCalls;}
 return result;
}
uint32_t CSPDIFRX_Start(CSPDIFRXState *s,uint32_t d,uint32_t linked,uint32_t src,uint32_t dst,uint32_t size) {
 s->calls[0]++;s->calls[1]=d;s->calls[2]=linked;s->calls[3]=normalize(s,src);s->calls[4]=normalize(s,dst);s->calls[5]=size;
 trace(s,20+d,linked);return s->meta[d][11];
}
void CSPDIFRX_Disable(CSPDIFRXState *s,uint32_t d) {s->meta[d][12]|=6;s->calls[6+d]++;trace(s,30+d,0);}
uint32_t CSPDIFRX_Run(CSPDIFRXState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {return s->mode?CSPDIFRX1_Run(s,op,a,b,c):CSPDIFRX0_Run(s,op,a,b,c);}
uint32_t CSPDIFRX_TraceWord(CSPDIFRXState *s,uint32_t e,uint32_t w) {assert(e<32 && w<224);return s->trace[e][w];}
