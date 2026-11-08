#include "LPTIMInternal.h"
CLPTIMState *CLPTIM_Active;
size_t CLPTIM_Size(void) { return sizeof(CLPTIMState); }
void CLPTIM_Reset(CLPTIMState *s,uint32_t mode,uint32_t instance) {
 memset(s,0,sizeof(*s));s->mode=mode;s->instance=instance;s->handle.Instance=&s->registers[instance-1];
 for(uint32_t i=0;i<3;i++) { s->handle.hdma[i]=&s->dma[i];s->dma[i].Parent=&s->handle;s->dma[i].LinkedListQueue=&s->queues[i];s->queues[i].Head=&s->nodes[i]; }
}
static volatile uint32_t *word(CLPTIMState *s,uint32_t area,uint32_t index) {
 if(area==0) { assert(index<sizeof(LPTIM_TypeDef)/4);return (volatile uint32_t *)s->handle.Instance+index; }
 if(area==1) {
  assert(index<19);
  if(index<13)return (uint32_t *)&s->handle.Init+index;
  if(index==13)return (uint32_t *)&s->handle.Channel;
  return (volatile uint32_t *)&s->handle.Status+index-14;
 }
 if(area==2) { assert(index<10);return s->control+index; }
 if(area==3) { assert(index==0);return &s->traceCount; }
 if(area==4) { assert(index<6);return index<2?(uint32_t *)&s->oc+index:(uint32_t *)&s->ic+index-2; }
 if(area==5) { assert(index==0);return &s->exti.IMR2; }
 assert(area==6 && index<24);return s->nodes[index/8].LinkRegisters+index%8;
}
static uint32_t normalize(CLPTIMState *s,uint32_t address) {
 uint32_t base=(uint32_t)(uintptr_t)s->handle.Instance;
 return address-base<sizeof(LPTIM_TypeDef)?0x50000000U+(address-base):address;
}
uint32_t CLPTIM_Get(CLPTIMState *s,uint32_t area,uint32_t index) {
 if(area==7) {
  DMA_HandleTypeDef *d=&s->dma[index/3];
  switch(index%3) { case 0:return d->Mode;case 1:return d->LinkedListQueue?0x1000:0;default:return d->LinkedListQueue && d->LinkedListQueue->Head?0x2000:0; }
 }
 uint32_t v=*word(s,area,index);return area==6?normalize(s,v):v;
}
void CLPTIM_Set(CLPTIMState *s,uint32_t area,uint32_t index,uint32_t value) {
 if(area==7) {
  DMA_HandleTypeDef *d=&s->dma[index/3];
  switch(index%3) { case 0:d->Mode=value;break;case 1:d->LinkedListQueue=value?&s->queues[index/3]:NULL;break;default:s->queues[index/3].Head=value?&s->nodes[index/3]:NULL;break; }
  return;
 }
 *word(s,area,index)=value;
}
uint32_t CLPTIM_Address(CLPTIMState *s,uint32_t offset) { return (uint32_t)(uintptr_t)s->handle.Instance+offset; }
uint32_t CLPTIM_ReadISR(CLPTIMState *s) {
 s->control[1]++;
 if(s->control[2] && s->control[1]==s->control[2])s->handle.Instance->ISR|=s->control[3];
 return s->handle.Instance->ISR;
}
static void event(CLPTIMState *s,uint32_t kind,uint32_t a,uint32_t b,uint32_t c,uint32_t d) {
 assert(s->traceCount<32);uint32_t *t=s->trace[s->traceCount++];t[0]=kind;t[1]=a;t[2]=b;t[3]=c;t[4]=d;
 uint32_t n=5;
 for(uint32_t i=0;i<14;i++)t[n++]=CLPTIM_Get(s,0,i);
 for(uint32_t i=0;i<19;i++)t[n++]=CLPTIM_Get(s,1,i);
 for(uint32_t i=0;i<16;i++)t[n++]=CLPTIM_GetCallback(s,i);
 for(uint32_t i=0;i<10;i++)t[n++]=s->control[i];
 t[n++]=s->exti.IMR2;
 for(uint32_t i=0;i<24;i++)t[n++]=CLPTIM_Get(s,6,i);
 for(uint32_t ch=1;ch<=2;ch++)for(uint32_t i=0;i<3;i++)t[n++]=CLPTIM_GetDMACallback(s,ch,i);
 assert(n==95);
}
uint32_t CLPTIM_Clock(CLPTIMState *s) { s->control[8]++;event(s,0,s->control[0],0,0,0);return s->control[0]; }
void CLPTIM_Callback(CLPTIMState *s,uint32_t id,uint32_t token) {
 event(s,1,id,token,0,0);
 if(s->control[4]) { s->handle.State=HAL_LPTIM_STATE_ERROR;s->handle.Channel=0x55;s->handle.Instance->DIER=0;s->handle.Instance->ISR=0; }
}
void CLPTIM_SetDMACallback(CLPTIMState *s,uint32_t ch,uint32_t id,uint32_t token) {
 assert(ch<3 && id<3);
 void (*f)(DMA_HandleTypeDef *)=s->mode?CLPTIM1_DMACallback(token):CLPTIM0_DMACallback(token);
 switch(id) { case 0:s->dma[ch].XferCpltCallback=f;break;case 1:s->dma[ch].XferHalfCpltCallback=f;break;case 2:s->dma[ch].XferErrorCallback=f;break; }
}
uint32_t CLPTIM_GetDMACallback(CLPTIMState *s,uint32_t ch,uint32_t id) {
 void (*f)(DMA_HandleTypeDef *)=id==0?s->dma[ch].XferCpltCallback:id==1?s->dma[ch].XferHalfCpltCallback:s->dma[ch].XferErrorCallback;
 for(uint32_t i=0;i<5;i++)if(f==(s->mode?CLPTIM1_DMACallback(i):CLPTIM0_DMACallback(i)))return i;
 return 0xFFFFFFFFU;
}
uint32_t CLPTIM_DMAStart(CLPTIMState *s,uint32_t ch,uint32_t src,uint32_t dst,uint32_t length,uint32_t linked) {
 event(s,2+linked,ch,normalize(s,src),normalize(s,dst),length);return s->control[5];
}
uint32_t CLPTIM_DMAAbort(CLPTIMState *s,uint32_t ch) { event(s,4,ch,0,0,0);return s->control[6]; }
uint32_t CLPTIM_TraceCount(CLPTIMState *s) { return s->traceCount; }
uint32_t CLPTIM_TraceWord(CLPTIMState *s,uint32_t e,uint32_t w) { assert(e<s->traceCount && w<95);return s->trace[e][w]; }
uint32_t CLPTIM_Run(CLPTIMState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {
 CLPTIMState *old=CLPTIM_Active;CLPTIM_Active=s;
 uint32_t result=s->mode?CLPTIM1_Run(s,op,a,b,c):CLPTIM0_Run(s,op,a,b,c);
 CLPTIM_Active=old;return result;
}
