#include "PKAInternal.h"
CPKAState *CPKA_Active;
size_t CPKA_Size(void) { return sizeof(CPKAState); }
uint32_t *CPKA_Buffer(CPKAState *s,uint32_t i) { assert(i<20);return s->buffers[i]; }
uint32_t CPKA_Get(CPKAState *s,uint32_t area,uint32_t i) {
 switch(area) {
 case 0:assert(i<3);return ((volatile uint32_t *)&s->regs)[i];
 case 1:assert(i<1334);return s->regs.RAM[i];
 case 2:switch(i) {
case 0:return s->h.State;
case 1:return s->h.ErrorCode;
case 2:return s->h.primeordersize;
case 3:return s->h.opsize;
case 4:return s->h.modulussize;
default:assert(0);return 0;}
 case 3:assert(i<400);return s->params[i/20][i%20];
 case 4:assert(i<12);return s->control[i];
 case 5:switch(i) {case 0:return s->tick;case 1:return s->tickCalls;case 2:return s->mode;case 3:return s->traceCount;default:assert(0);return 0;}
 case 6:assert(i<2560);return s->buffers[i/128][i%128];
 case 7:assert(i<384);return s->trace[i/12][i%12];
 default:assert(0);return 0;
 }
}
void CPKA_Set(CPKAState *s,uint32_t area,uint32_t i,uint32_t v) {
 switch(area) {
 case 0:assert(i<3);((volatile uint32_t *)&s->regs)[i]=v;break;
 case 1:assert(i<1334);s->regs.RAM[i]=v;break;
 case 2:switch(i) {
case 0:s->h.State=v;break;
case 1:s->h.ErrorCode=v;break;
case 2:s->h.primeordersize=v;break;
case 3:s->h.opsize=v;break;
case 4:s->h.modulussize=v;break;
default:assert(0);}break;
 case 3:assert(i<400);s->params[i/20][i%20]=v;break;
 case 4:assert(i<12);s->control[i]=v;break;
 case 5:switch(i) {case 0:s->tick=v;break;case 1:s->tickCalls=v;break;case 2:s->mode=v;break;case 3:s->traceCount=v;break;default:assert(0);}break;
 case 6:assert(i<2560);s->buffers[i/128][i%128]=v;break;
 default:assert(0);
 }
}
void CPKA_Reset(CPKAState *s,uint32_t mode,uint32_t seed) {
 memset(s,0,sizeof(*s));s->h.Instance=&s->regs;s->mode=mode;s->h.State=HAL_PKA_STATE_READY;
 s->regs.SR=0x20001;s->regs.CR=1;s->control[0]=1001;
 s->h.primeordersize=8;s->h.opsize=8;s->h.modulussize=8;
 for(uint32_t i=0;i<1334;i++)s->regs.RAM[i]=(seed+i*0x1234567U)^0x76543210U;
 for(uint32_t i=0;i<20;i++)for(uint32_t j=0;j<128;j++)s->buffers[i][j]=(seed+i*0x3457U+j*0x78123U)|0x01010101U;
 for(uint32_t i=0;i<20;i++)for(uint32_t j=0;j<20;j++)s->params[i][j]=8;
 for(uint32_t i=0;i<4;i++)CPKA_SetCallback(s,i,1);
}
uint32_t CPKA_TickFor(CPKAState *s) {
 s->tick+=s->control[0];s->tickCalls++;
 if(s->control[1] && s->tickCalls==s->control[1]) {s->regs.SR|=s->control[2];s->regs.CR&=~s->control[3];}
 if(s->control[8] && s->tickCalls<=s->control[8])s->regs.CR=0;
 assert(s->tickCalls<100000);return s->tick;
}
uint32_t CPKA_Tick(void) { return CPKA_TickFor(CPKA_Active); }
static void trace(CPKAState *s,uint32_t id,uint32_t token) {
 assert(s->traceCount<32);uint32_t *t=s->trace[s->traceCount++];t[0]=id;t[1]=token;
 for(uint32_t i=0;i<3;i++)t[2+i]=CPKA_Get(s,0,i);
 for(uint32_t i=0;i<5;i++)t[5+i]=CPKA_Get(s,2,i);
 t[10]=s->tick;t[11]=s->tickCalls;
}
void CPKA_Callback(CPKAState *s,uint32_t id,uint32_t token) {
 trace(s,id,token);
 if(id==1) {
  if(s->control[4]&1U) {s->regs.SR=0;s->h.State=HAL_PKA_STATE_BUSY;}
  if(s->control[4]&2U)CPKA_SetCallback(s,0,2);
 }
}
void CPKA_System(CPKAState *s,uint32_t action) {
 trace(s,10+action,0);
 if(action==0) {s->regs.CR=0;s->regs.SR=s->control[9]?0:1;for(uint32_t i=0;i<1334;i++)s->regs.RAM[i]=0;}
}
uint32_t CPKA_Run(CPKAState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {
 CPKA_Active=s;return s->mode?CPKA1_Run(s,op,a,b,c):CPKA0_Run(s,op,a,b,c);
}
