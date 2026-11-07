/* Test-only scripted data/ready stimuli and DMA transaction observations. */
#include "CORDICInternal.h"
#include <assert.h>
#include <string.h>
_Thread_local CCORDICState *CCORDIC_Active;
static volatile uint32_t *address(const CCORDICState *s,CCORDICRegister reg){switch(reg){
case CCORDIC_CSR:return (volatile uint32_t *)&s->registers.CSR;
case CCORDIC_WDATA:return (volatile uint32_t *)&s->registers.WDATA;
case CCORDIC_RDATA:return (volatile uint32_t *)&s->registers.RDATA;
default:assert(0);return NULL;}}
static void *handleAddress(const CCORDICState *s,uint32_t h){assert(h<2);return s->registeredCallbacks ? (void *)&s->handles1[h] : (void *)&s->handles0[h];}
static uint32_t findHandle(const CCORDICState *s,const void *h){for(uint32_t i=0;i<2;i++)if(h==handleAddress(s,i))return i;assert(0);return 0;}
static uint32_t findDMA(const CCORDICState *s,const DMA_HandleTypeDef *h){for(uint32_t i=0;i<4;i++)if(h==&s->dma[i])return i;assert(0);return 0;}
static uint32_t bufferBase(uint32_t h,uint32_t output){return 0x10000000U+h*0x1000U+output*0x01000000U;}
int32_t *CCORDIC_Buffer(CCORDICState *s,uint32_t h,uint32_t output){assert(h<2 && output<2);return output ? s->output[h] : s->input[h];}
uint32_t CCORDIC_NormalizeAddress(const CCORDICState *s,uintptr_t value){
 if(!value)return 0;
 for(uint32_t r=0;r<3;r++){
  uintptr_t base=(uintptr_t)address(s,(CCORDICRegister)r);
  if(value==base || (value<=UINT32_MAX && (uint32_t)value==(uint32_t)base))return 0x48004400U+r*4;
 }
 for(uint32_t h=0;h<2;h++)for(uint32_t d=0;d<2;d++){
  uintptr_t base=(uintptr_t)(d ? s->output[h] : s->input[h]);
  uintptr_t delta=value-base;
  if(value<=UINT32_MAX)delta=(uint32_t)value-(uint32_t)base;
  if(delta<128)return bufferBase(h,d)+(uint32_t)delta;
 }
 return (uint32_t)value;
}
static void *decodePointer(CCORDICState *s,uint32_t value){
 if(!value)return NULL;
 for(uint32_t h=0;h<2;h++)for(uint32_t d=0;d<2;d++){
  uint32_t base=bufferBase(h,d);
  if(value>=base && value<=base+128)return (uint8_t *)CCORDIC_Buffer(s,h,d)+(value-base);
 }
 assert(!"Unknown CORDIC pointer");return NULL;
}
void CCORDIC_Reset(CCORDICState *s,uint32_t registered){
 memset(s,0,sizeof(*s));s->registeredCallbacks=registered!=0;s->tickStep=1;
 s->registers.CSR=0x80000000U;s->configuration.Precision=0x10;s->resultCount=64;
 for(uint32_t i=0;i<64;i++)s->results[i]=0x80000000U+i*0x12345U;
 for(uint32_t h=0;h<2;h++){
  s->handles0[h].Instance=&s->registers;s->handles1[h].Instance=&s->registers;
  for(uint32_t i=0;i<32;i++){s->input[h][i]=(int32_t)(0x10000000U+h*0x100000U+i*0x10203U);s->output[h][i]=(int32_t)0xA5A5A5A5U;}
  CCORDIC_SetLink(s,h,0,(int32_t)(h*2));CCORDIC_SetLink(s,h,1,(int32_t)(h*2+1));
  CCORDIC_SetDMAParent(s,h*2,(int32_t)h);CCORDIC_SetDMAParent(s,h*2+1,(int32_t)h);
 }
}
uint32_t CCORDIC_Get(const CCORDICState *s,CCORDICRegister reg){return *address(s,reg);}
void CCORDIC_Set(CCORDICState *s,CCORDICRegister reg,uint32_t value){*address(s,reg)=value;}
static void event(CCORDICState *s,uint32_t kind,uint32_t trigger,uint32_t count){
 for(uint32_t i=0;i<32;i++){CCORDICEvent *e=&s->events[i];if(e->active && e->kind==kind && e->trigger==trigger && e->due==count){CCORDICAction action=e->action;e->active=0;CCORDIC_ApplyAction(s,action);}}
}
static void access(CCORDICState *s,CCORDICRegister reg,uint32_t value,uint32_t kind){assert(s->accessCount<512);s->accesses[s->accessCount++]=(CCORDICAccess){reg,value,kind,s->tickCalls};}
uint32_t CCORDIC_Read(CCORDICState *s,CCORDICRegister reg){
 uint32_t value=CCORDIC_Get(s,reg);
 if(reg==CCORDIC_RDATA && s->resultIndex<s->resultCount){value=s->results[s->resultIndex++];CCORDIC_Set(s,reg,value);}
 access(s,reg,value,0);event(s,1,(uint32_t)reg,++s->readCounts[reg]);return value;
}
void CCORDIC_Write(CCORDICState *s,CCORDICRegister reg,uint32_t value){CCORDIC_Set(s,reg,value);access(s,reg,value,1);event(s,2,(uint32_t)reg,++s->writeCounts[reg]);}
static int findAddress(volatile uint32_t *p,CCORDICRegister *reg){assert(CCORDIC_Active);for(uint32_t i=0;i<3;i++)if(p==address(CCORDIC_Active,(CCORDICRegister)i)){*reg=(CCORDICRegister)i;return 1;}return 0;}
uint32_t CCORDIC_ReadAddress(volatile uint32_t *p){CCORDICRegister reg;return findAddress(p,&reg) ? CCORDIC_Read(CCORDIC_Active,reg) : *p;}
void CCORDIC_WriteAddress(volatile uint32_t *p,uint32_t value){CCORDICRegister reg;if(findAddress(p,&reg))CCORDIC_Write(CCORDIC_Active,reg,value);else *p=value;}
uint32_t CCORDIC_GetWord(const CCORDICState *s,uint32_t h,uint32_t word){assert(h<2 && word<6);return s->registeredCallbacks ? CCORDIC1_GetWordInternal(&s->handles1[h],word) : CCORDIC0_GetWordInternal(&s->handles0[h],word);}
void CCORDIC_SetWord(CCORDICState *s,uint32_t h,uint32_t word,uint32_t value){assert(h<2 && word<6);if(s->registeredCallbacks)CCORDIC1_SetWordInternal(&s->handles1[h],word,value);else CCORDIC0_SetWordInternal(&s->handles0[h],word,value);}
uint32_t CCORDIC_GetPointer(const CCORDICState *s,uint32_t h,uint32_t output){
 assert(h<2 && output<2);uintptr_t pointer;
 if(s->registeredCallbacks)pointer=(uintptr_t)(output ? s->handles1[h].pOutBuff : s->handles1[h].pInBuff);
 else pointer=(uintptr_t)(output ? s->handles0[h].pOutBuff : s->handles0[h].pInBuff);
 if(!pointer)return 0;
 uintptr_t base=(uintptr_t)(output ? s->output[h] : s->input[h]);
 if(pointer>=base && pointer<=base+128)return bufferBase(h,output)+(uint32_t)(pointer-base);
 return CCORDIC_NormalizeAddress(s,pointer);
}
void CCORDIC_SetPointer(CCORDICState *s,uint32_t h,uint32_t output,uint32_t value){
 assert(h<2 && output<2);void *p=decodePointer(s,value);
 if(s->registeredCallbacks){if(output)s->handles1[h].pOutBuff=p;else s->handles1[h].pInBuff=p;}
 else{if(output)s->handles0[h].pOutBuff=p;else s->handles0[h].pInBuff=p;}
}
uint32_t CCORDIC_GetCallback(const CCORDICState *s,uint32_t h,uint32_t id){assert(h<2 && id<4);return s->registeredCallbacks ? CCORDIC1_GetCallbackInternal(&s->handles1[h],id) : CCORDIC0_GetCallbackInternal(&s->handles0[h],id);}
void CCORDIC_SetCallback(CCORDICState *s,uint32_t h,uint32_t id,uint32_t value){assert(h<2 && id<4 && value<4);if(s->registeredCallbacks)CCORDIC1_SetCallbackInternal(&s->handles1[h],id,value);else CCORDIC0_SetCallbackInternal(&s->handles0[h],id,value);}
int32_t CCORDIC_GetLink(const CCORDICState *s,uint32_t h,uint32_t output){
 assert(h<2 && output<2);DMA_HandleTypeDef *p;
 if(s->registeredCallbacks)p=output ? s->handles1[h].hdmaOut : s->handles1[h].hdmaIn;
 else p=output ? s->handles0[h].hdmaOut : s->handles0[h].hdmaIn;
 return p ? (int32_t)findDMA(s,p) : -1;
}
void CCORDIC_SetLink(CCORDICState *s,uint32_t h,uint32_t output,int32_t channel){
 assert(h<2 && output<2 && channel>=-1 && channel<4);DMA_HandleTypeDef *p=channel<0 ? NULL : &s->dma[channel];
 if(s->registeredCallbacks){if(output)s->handles1[h].hdmaOut=p;else s->handles1[h].hdmaIn=p;}
 else{if(output)s->handles0[h].hdmaOut=p;else s->handles0[h].hdmaIn=p;}
}
int32_t CCORDIC_GetDMAParent(const CCORDICState *s,uint32_t channel){assert(channel<4);return s->dma[channel].Parent ? (int32_t)findHandle(s,s->dma[channel].Parent) : -1;}
void CCORDIC_SetDMAParent(CCORDICState *s,uint32_t channel,int32_t h){assert(channel<4 && h>=-1 && h<2);s->dma[channel].Parent=h<0 ? NULL : handleAddress(s,(uint32_t)h);}
uint32_t CCORDIC_GetDMACallback(const CCORDICState *s,uint32_t channel,uint32_t slot){assert(channel<4 && slot<2);return s->registeredCallbacks ? CCORDIC1_GetDMACallbackInternal(&s->dma[channel],slot) : CCORDIC0_GetDMACallbackInternal(&s->dma[channel],slot);}
void CCORDIC_SetDMACallback(CCORDICState *s,uint32_t channel,uint32_t slot,uint32_t value){assert(channel<4 && slot<2 && value<4);if(s->registeredCallbacks)CCORDIC1_SetDMACallbackInternal(&s->dma[channel],slot,value);else CCORDIC0_SetDMACallbackInternal(&s->dma[channel],slot,value);}
void CCORDIC_InvokeDMA(CCORDICState *s,uint32_t channel,uint32_t kind){
 assert(channel<4 && kind<3);CCORDICState *previous=CCORDIC_Active;CCORDIC_Active=s;
 if(s->registeredCallbacks)CCORDIC1_InvokeDMAInternal(&s->dma[channel],kind);else CCORDIC0_InvokeDMAInternal(&s->dma[channel],kind);
 CCORDIC_Active=previous;
}
CCORDICSnapshot CCORDIC_GetSnapshot(const CCORDICState *s){
 CCORDICSnapshot result;
 for(uint32_t i=0;i<3;i++)result.registers[i]=CCORDIC_Get(s,(CCORDICRegister)i);
 for(uint32_t h=0;h<2;h++){
  for(uint32_t i=0;i<6;i++)result.words[h][i]=CCORDIC_GetWord(s,h,i);
  for(uint32_t i=0;i<2;i++){result.pointers[h][i]=CCORDIC_GetPointer(s,h,i);result.links[h][i]=(uint32_t)CCORDIC_GetLink(s,h,i);}
  for(uint32_t i=0;i<4;i++)result.callbacks[h][i]=CCORDIC_GetCallback(s,h,i);
 }
 for(uint32_t i=0;i<4;i++){result.dmaParents[i]=(uint32_t)CCORDIC_GetDMAParent(s,i);for(uint32_t j=0;j<2;j++)result.dmaCallbacks[i][j]=CCORDIC_GetDMACallback(s,i,j);}
 memcpy(result.input,s->input,sizeof(result.input));memcpy(result.output,s->output,sizeof(result.output));return result;
}
void CCORDIC_SetCallbackAction(CCORDICState *s,uint32_t h,uint32_t id,uint32_t slot,CCORDICAction action){assert(h<2 && id<4 && slot<4);s->callbackActions[h][id][slot]=action;}
void CCORDIC_EmitCallback(CCORDICState *s,uint32_t h,uint32_t id,uint32_t implementation){
 assert(h<2 && id<4 && s->callbackCount<32);CCORDICCallbackEvent *e=&s->callbacks[s->callbackCount++];
 e->handle=h;e->id=id;e->implementation=implementation;e->tickCalls=s->tickCalls;e->snapshot=CCORDIC_GetSnapshot(s);
 CCORDICAction actions[4];memcpy(actions,s->callbackActions[h][id],sizeof(actions));memset(s->callbackActions[h][id],0,sizeof(actions));
 for(uint32_t i=0;i<4;i++)CCORDIC_ApplyAction(s,actions[i]);
}
void CCORDIC_DispatchCallback(const void *h,uint32_t id,uint32_t implementation){CCORDIC_EmitCallback(CCORDIC_Active,findHandle(CCORDIC_Active,h),id,implementation);}
CCORDICCallbackEvent CCORDIC_GetCallbackEvent(const CCORDICState *s,uint32_t i){assert(i<s->callbackCount);return s->callbacks[i];}
void CCORDIC_SetDMAAction(CCORDICState *s,uint32_t channel,uint32_t slot,CCORDICAction action){assert(channel<4 && slot<4);s->dmaActions[channel][slot]=action;}
uint32_t CCORDIC_DMAStartModel(CCORDICState *s,uint32_t channel,uint32_t source,uint32_t destination,uint32_t size){
 assert(channel<4 && s->dmaCount<32);CCORDICDMAEvent *e=&s->dmaEvents[s->dmaCount++];
 uint32_t status=s->dmaStatus[channel];e->channel=channel;e->source=source;e->destination=destination;e->size=size;e->status=status;e->tickCalls=s->tickCalls;e->snapshot=CCORDIC_GetSnapshot(s);
 CCORDICAction actions[4];memcpy(actions,s->dmaActions[channel],sizeof(actions));memset(s->dmaActions[channel],0,sizeof(actions));
 for(uint32_t i=0;i<4;i++)CCORDIC_ApplyAction(s,actions[i]);return status;
}
HAL_StatusTypeDef CCORDIC_DMAStart(DMA_HandleTypeDef *h,uint32_t source,uint32_t destination,uint32_t size){
 return (HAL_StatusTypeDef)CCORDIC_DMAStartModel(CCORDIC_Active,findDMA(CCORDIC_Active,h),CCORDIC_NormalizeAddress(CCORDIC_Active,(uintptr_t)source),CCORDIC_NormalizeAddress(CCORDIC_Active,(uintptr_t)destination),size);
}
CCORDICDMAEvent CCORDIC_GetDMAEvent(const CCORDICState *s,uint32_t i){assert(i<s->dmaCount);return s->dmaEvents[i];}
CCORDICAccess CCORDIC_GetAccess(const CCORDICState *s,uint32_t i){assert(i<s->accessCount);return s->accesses[i];}
uint32_t CCORDIC_Tick(CCORDICState *s){uint32_t value=s->tick;s->tick+=s->tickStep;s->tickCalls++;event(s,0,0,s->tickCalls);return value;}
static void schedule(CCORDICState *s,uint32_t kind,uint32_t trigger,uint32_t due,CCORDICAction action){
 for(uint32_t i=0;i<32;i++)if(!s->events[i].active){s->events[i]=(CCORDICEvent){1,kind,trigger,due,action};return;}assert(!"CORDIC event capacity exceeded");
}
void CCORDIC_ScheduleTick(CCORDICState *s,uint32_t after,CCORDICAction action){assert(after);schedule(s,0,0,s->tickCalls+after,action);}
void CCORDIC_ScheduleRead(CCORDICState *s,CCORDICRegister reg,uint32_t after,CCORDICAction action){assert(after);schedule(s,1,(uint32_t)reg,s->readCounts[reg]+after,action);}
void CCORDIC_ScheduleWrite(CCORDICState *s,CCORDICRegister reg,uint32_t after,CCORDICAction action){assert(after);schedule(s,2,(uint32_t)reg,s->writeCounts[reg]+after,action);}
void CCORDIC_SetExecutionHook(CCORDICState *s,void *context,CCORDICActionHandler handler){s->executionContext=context;s->actionHandler=handler;}
void CCORDIC_ApplyAction(CCORDICState *s,CCORDICAction action){
 if(action.kind==CCORDIC_ActionNone)return;if(s->actionHandler){s->actionHandler(s->executionContext,action);return;}
 switch(action.kind){
 case CCORDIC_ActionNone:return;
 case CCORDIC_ActionRegister:CCORDIC_Set(s,(CCORDICRegister)action.index,action.value);return;
 case CCORDIC_ActionWord:CCORDIC_SetWord(s,action.target,action.index,action.value);return;
 case CCORDIC_ActionPointer:CCORDIC_SetPointer(s,action.target,action.index,action.value);return;
 case CCORDIC_ActionCall:(void)CCORDIC_Run(s,action.target,(CCORDICOperation)action.index,action.a,action.b,action.c,action.d);return;
 case CCORDIC_ActionDMAParent:CCORDIC_SetDMAParent(s,action.target,(int32_t)action.value);return;
 case CCORDIC_ActionDMAEvent:CCORDIC_InvokeDMA(s,action.target,action.index);return;
 }
 assert(0);
}
uint32_t CCORDIC_Run(CCORDICState *s,uint32_t h,CCORDICOperation operation,uint32_t a,uint32_t b,uint32_t c,uint32_t d){
 assert(h<2);CCORDICState *previous=CCORDIC_Active;CCORDIC_Active=s;
 uint32_t result=s->registeredCallbacks ? CCORDIC1_RunInternal(&s->handles1[h],operation,a,b,c,d) : CCORDIC0_RunInternal(&s->handles0[h],operation,a,b,c,d);
 CCORDIC_Active=previous;return result;
}
uint32_t CCORDIC_RunNull(CCORDICState *s,CCORDICOperation operation){
 assert(operation==CCORDIC_Initialize || operation==CCORDIC_Deinitialize);CCORDICState *previous=CCORDIC_Active;CCORDIC_Active=s;
 uint32_t result=s->registeredCallbacks ? CCORDIC1_RunInternal(NULL,operation,0,0,0,0) : CCORDIC0_RunInternal(NULL,operation,0,0,0,0);
 CCORDIC_Active=previous;return result;
}
