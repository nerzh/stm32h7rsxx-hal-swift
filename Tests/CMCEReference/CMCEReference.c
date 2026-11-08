#include "MCEInternal.h"
CMCEState *CMCE_Active;
size_t CMCE_Size(void) { return sizeof(CMCEState); }
static volatile uint32_t *word(CMCEState *s,uint32_t i) {
 switch(i) {case 0:return (uint32_t*)&s->h.State;case 1:return (uint32_t*)&s->h.Lock;case 2:return &s->h.ErrorCode;default:assert(0);return NULL;}
}
void CMCE_Reset(CMCEState *s,uint32_t mode,uint32_t instance) {
 memset(s,0,sizeof(*s));s->mode=mode;s->instance=instance;s->h.Instance=(MCE_TypeDef*)s->regs;
 s->control[0]=1;s->control[1]=1;s->control[2]=1;
 for(uint32_t i=0;i<3;i++)CMCE_SetCallback(s,i,1);
}
uint32_t CMCE_Get(CMCEState *s,uint32_t area,uint32_t i) {
 switch(area) {
 case 0:assert(i<192);return s->regs[i];
 case 1:return *word(s,i);
 case 2:assert(i<8);return s->control[i];
 case 3:assert(i<10);return s->config[i];
 case 4:assert(i<4);return s->key[i];
 case 5:return i?s->tickCalls:s->tick;
 case 6:return s->traceCount;
 case 7:return i?s->instance:s->mode;
 default:assert(0);return 0;
 }
}
void CMCE_Set(CMCEState *s,uint32_t area,uint32_t i,uint32_t v) {
 switch(area) {
 case 0:assert(i<192);s->regs[i]=v;break;
 case 1:*word(s,i)=v;break;
 case 2:assert(i<8);s->control[i]=v;break;
 case 3:assert(i<10);s->config[i]=v;break;
 case 4:assert(i<4);s->key[i]=v;break;
 case 5:if(i)s->tickCalls=v;else s->tick=v;break;
 case 6:s->traceCount=v;break;
 default:assert(0);
 }
}
static void trace(CMCEState *s,uint32_t id,uint32_t token) {
 assert(s->traceCount<64);uint32_t *out=s->trace[s->traceCount++],n=0;
 out[n++]=id;out[n++]=token;
 for(uint32_t i=0;i<192;i++)out[n++]=s->regs[i];
 for(uint32_t i=0;i<3;i++)out[n++]=*word(s,i);
 for(uint32_t i=0;i<3;i++)out[n++]=CMCE_GetCallback(s,i);
 out[n++]=s->tick;out[n++]=s->tickCalls;
 while(n<208)out[n++]=0;
}
void CMCE_Write(CMCEState *s,uint32_t offset,uint32_t value) {
 assert(offset<768 && offset%4==0);s->regs[offset/4]=value;trace(s,0x100+offset,value);
 if(offset==12 && s->control[6])s->regs[2]&=~value;
}
uint32_t *CMCE_Key(CMCEState *s) { return s->key; }
uint32_t CMCE_Tick(CMCEState *s) {
 uint32_t result=s->tick;s->tick+=s->control[2];s->tickCalls++;
 if(s->control[3] && s->tickCalls>=s->control[3])s->regs[1]=s->control[4];
 return result;
}
void CMCE_Callback(CMCEState *s,uint32_t id,uint32_t token) {
 trace(s,id,token);
 if(s->control[5]) {s->h.State=2;s->h.ErrorCode=0x8000;s->h.Lock=1;s->regs[4]=0;for(uint32_t i=0;i<3;i++)CMCE_SetCallback(s,i,2);}
}
uint32_t CMCE_Run(CMCEState *s,uint32_t op,uint32_t a,uint32_t b) {return s->mode?CMCE1_Run(s,op,a,b):CMCE0_Run(s,op,a,b);}
uint32_t CMCE_TraceWord(CMCEState *s,uint32_t e,uint32_t w) { assert(e<64 && w<208);return s->trace[e][w]; }
