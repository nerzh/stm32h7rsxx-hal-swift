/* Test-only register, address, DMA, and callback boundary for unchanged C. */
#include "HASHInternal.h"
#include <assert.h>
#include <string.h>
CHASH_THREAD_LOCAL CHASHState *CHASH_Active;
#define DISPATCH(s,name,...) ((s)->registeredCallbacks ? ((s)->suspendResume ? CHASH11_##name(__VA_ARGS__) : CHASH10_##name(__VA_ARGS__)) : ((s)->suspendResume ? CHASH01_##name(__VA_ARGS__) : CHASH00_##name(__VA_ARGS__)))
#if defined(__arm__) || defined(__thumb__)
_Static_assert(sizeof(CHASHState) <= 24576, "HASH reference must fit the reserved RAM arena");
#endif
_Static_assert(sizeof(HASH_TypeDef)==0x294,"Original HASH register layout");
_Static_assert(offsetof(HASH_TypeDef,CSR)==0xF8,"Original HASH CSR offset");
_Static_assert(sizeof(HASH_DIGEST_TypeDef)==64,"Original digest register layout");
static volatile uint32_t *address(const CHASHState *s,CHASHRegister r){
 switch(r){case CHASH_CR:return (volatile uint32_t *)&s->registers.CR;case CHASH_DIN:return (volatile uint32_t *)&s->registers.DIN;case CHASH_STR:return (volatile uint32_t *)&s->registers.STR;case CHASH_IMR:return (volatile uint32_t *)&s->registers.IMR;case CHASH_SR:return (volatile uint32_t *)&s->registers.SR;default:break;}
 if(r>=CHASH_HR0 && r<=CHASH_HR4)return (volatile uint32_t *)&s->registers.HR[r-CHASH_HR0];
 if(r>=CHASH_CSR0 && r<=CHASH_CSR102)return (volatile uint32_t *)&s->registers.CSR[r-CHASH_CSR0];
 if(r>=CHASH_DIGEST0 && r<=CHASH_DIGEST15)return (volatile uint32_t *)&s->digest.HR[r-CHASH_DIGEST0];
 assert(0);return NULL;
}
static uint32_t registerAddress(CHASHRegister r){
 if(r<=CHASH_SR)return 0x48020400U+(uint32_t)r*4U;
 if(r<=CHASH_CSR102)return 0x480204F8U+((uint32_t)r-CHASH_CSR0)*4U;
 return 0x48020710U+((uint32_t)r-CHASH_DIGEST0)*4U;
}
void *CHASH_Handle(const CHASHState *s,uint32_t h){assert(h<2);if(s->registeredCallbacks)return s->suspendResume ? (void *)&s->handles11[h] : (void *)&s->handles10[h];return s->suspendResume ? (void *)&s->handles01[h] : (void *)&s->handles00[h];}
static uint32_t findHandle(const CHASHState *s,const void *h){for(uint32_t i=0;i<2;i++)if(h==CHASH_Handle(s,i))return i;assert(0);return 0;}
static uint32_t findDMA(const CHASHState *s,const DMA_HandleTypeDef *h){for(uint32_t i=0;i<2;i++)if(h==&s->dma[i])return i;assert(0);return 0;}
static uint32_t bufferBase(uint32_t h,uint32_t k){static const uint32_t offsets[]={0,0x400,0x800,0x900};assert(h<2 && k<4);return 0x20000000U+h*0x1000U+offsets[k];}
static uint32_t bufferSize(uint32_t k){static const uint32_t sizes[]={512,512,64,424};assert(k<4);return sizes[k];}
void *CHASH_Buffer(CHASHState *s,uint32_t h,uint32_t k){assert(h<2 && k<4);switch(k){case 0:return s->input[h];case 1:return s->key[h];case 2:return s->output[h];default:return s->context[h];}}
void *CHASH_Resolve(CHASHState *s,uint32_t value){
 if(!value)return NULL;
 for(uint32_t h=0;h<2;h++)for(uint32_t k=0;k<4;k++){uint32_t base=bufferBase(h,k);if(value>=base && value<=base+bufferSize(k))return (uint8_t *)CHASH_Buffer(s,h,k)+(value-base);}
 for(uint32_t r=0;r<CHASH_RegisterCount;r++)if(value==registerAddress((CHASHRegister)r))return (void *)address(s,(CHASHRegister)r);
 return (void *)(uintptr_t)value;
}
uint32_t CHASH_NormalizeAddress(const CHASHState *s,uintptr_t value){
 if(!value)return 0;
 for(uint32_t r=0;r<CHASH_RegisterCount;r++){uintptr_t native=(uintptr_t)address(s,(CHASHRegister)r);if(value==native || (value<=UINT32_MAX && (uint32_t)value==(uint32_t)native))return registerAddress((CHASHRegister)r);}
 for(uint32_t h=0;h<2;h++)for(uint32_t k=0;k<4;k++){uintptr_t native=(uintptr_t)CHASH_Buffer((CHASHState *)s,h,k);uintptr_t delta=value-native;if(value<=UINT32_MAX)delta=(uint32_t)value-(uint32_t)native;if(delta<=bufferSize(k))return bufferBase(h,k)+(uint32_t)delta;}
 return (uint32_t)value;
}
uint32_t CHASH_GetNode(const CHASHState *s,uint32_t channel,uint32_t word){assert(channel<2 && word<9);uint32_t v=word<8 ? s->nodes[channel].LinkRegisters[word] : s->nodes[channel].NodeInfo;return word==3 || word==4 ? CHASH_NormalizeAddress(s,v) : v;}
void CHASH_SetNode(CHASHState *s,uint32_t channel,uint32_t word,uint32_t value){assert(channel<2 && word<9);if(word<8)s->nodes[channel].LinkRegisters[word]=value;else s->nodes[channel].NodeInfo=value;}
static int memoryLocation(CHASHState *s,uint32_t addr,uint32_t width,void **p){
 for(uint32_t h=0;h<2;h++)for(uint32_t k=0;k<4;k++){uint32_t base=bufferBase(h,k);if(addr>=base && addr-base<=bufferSize(k) && width<=bufferSize(k)-(addr-base)){*p=(uint8_t *)CHASH_Buffer(s,h,k)+(addr-base);return 1;}}
 return 0;
}
uint32_t CHASH_ReadMemory(CHASHState *s,uint32_t addr,uint32_t width){
 assert(width==1 || width==2 || width==4);void *p;if(memoryLocation(s,addr,width,&p)){uint32_t v=0;memcpy(&v,p,width);return v;}
 assert(width==4 && (addr&3U)==0);
 for(uint32_t ch=0;ch<2;ch++){
  uint32_t node=0x20004000U+ch*0x100U;if(addr>=node && addr<node+36)return CHASH_GetNode(s,ch,(addr-node)/4);
  uint32_t queue=0x20003000U+ch*0x100U;if(addr>=queue && addr<queue+24){switch((addr-queue)/4){case 0:return s->queues[ch].Head ? node : 0;case 1:return s->queues[ch].FirstCircularNode ? node : 0;case 2:return s->queues[ch].NodeNumber;case 3:return s->queues[ch].State;case 4:return s->queues[ch].ErrorCode;default:return s->queues[ch].Type;}}
 }
 assert(!"Unmapped logical HASH memory address");return 0;
}
void CHASH_WriteMemory(CHASHState *s,uint32_t addr,uint32_t value,uint32_t width){
 assert(width==1 || width==2 || width==4);void *p;if(memoryLocation(s,addr,width,&p)){memcpy(p,&value,width);return;}
 assert(width==4 && (addr&3U)==0);for(uint32_t ch=0;ch<2;ch++){uint32_t node=0x20004000U+ch*0x100U;if(addr>=node && addr<node+36){CHASH_SetNode(s,ch,(addr-node)/4,value);return;}}
 assert(!"Unmapped logical HASH memory write");
}
void CHASH_Reset(CHASHState *s,uint32_t registered,uint32_t suspend){
 memset(s,0,sizeof(*s));s->registeredCallbacks=registered!=0;s->suspendResume=suspend!=0;s->tickStep=1;
 for(uint32_t h=0;h<2;h++){
  s->handles00[h].Instance=&s->registers;s->handles01[h].Instance=&s->registers;s->handles10[h].Instance=&s->registers;s->handles11[h].Instance=&s->registers;
  CHASH_SetLink(s,h,(int32_t)h);s->dma[h].Instance=&s->channels[h];s->dma[h].Parent=CHASH_Handle(s,h);s->dma[h].LinkedListQueue=&s->queues[h];s->queues[h].Head=&s->nodes[h];s->queues[h].NodeNumber=1;
  for(uint32_t i=0;i<128;i++){s->input[h][i]=0x10203040U+h*0x1000000U+i*0x10203U;s->key[h][i]=0x55667788U+h*0x1000000U+i*0x10203U;}
  for(uint32_t i=0;i<16;i++)s->output[h][i]=0xA5A5A5A5U;
  for(uint32_t i=0;i<106;i++)s->context[h][i]=0xC0C00000U+i;
  CHASH_SetWord(s,h,CHASH_keyAddress,bufferBase(h,1));
 }
 for(uint32_t i=0;i<5;i++)s->registers.HR[i]=0x12345678U+i*0x1020304U;
 for(uint32_t i=0;i<16;i++)s->digest.HR[i]=0xAABBCCDDU+i*0x1020304U;
}
uint32_t CHASH_Get(const CHASHState *s,CHASHRegister r){return *address(s,r);}
void CHASH_Set(CHASHState *s,CHASHRegister r,uint32_t v){*address(s,r)=v;}
static void event(CHASHState *s,uint32_t kind,uint32_t trigger,uint32_t count){for(uint32_t i=0;i<32;i++){CHASHEvent *e=&s->events[i];if(e->active && e->kind==kind && e->trigger==trigger && e->due==count){CHASHAction a=e->action;e->active=0;CHASH_ApplyAction(s,a);}}}
static void access(CHASHState *s,CHASHRegister r,uint32_t value,uint32_t kind){assert(s->accessCount<192);s->accesses[s->accessCount++]=(CHASHAccess){r,kind,value,s->tickCalls};}
uint32_t CHASH_Read(CHASHState *s,CHASHRegister r){uint32_t value=CHASH_Get(s,r);access(s,r,value,0);event(s,1,r,++s->readCounts[r]);return value;}
void CHASH_Write(CHASHState *s,CHASHRegister r,uint32_t value){CHASH_Set(s,r,value);access(s,r,value,1);event(s,2,r,++s->writeCounts[r]);}
static int findAddress(volatile uint32_t *p,CHASHRegister *r){assert(CHASH_Active);for(uint32_t i=0;i<CHASH_RegisterCount;i++)if(p==address(CHASH_Active,(CHASHRegister)i)){*r=(CHASHRegister)i;return 1;}return 0;}
uint32_t CHASH_ReadAddress(volatile uint32_t *p){CHASHRegister r;return findAddress(p,&r) ? CHASH_Read(CHASH_Active,r) : *p;}
void CHASH_WriteAddress(volatile uint32_t *p,uint32_t v){CHASHRegister r;if(findAddress(p,&r))CHASH_Write(CHASH_Active,r,v);else *p=v;}
uint32_t CHASH_GetWord(const CHASHState *s,uint32_t h,uint32_t w){assert(h<2 && w<25);return DISPATCH(s,GetWordInternal,s,CHASH_Handle(s,h),w);}
void CHASH_SetWord(CHASHState *s,uint32_t h,uint32_t w,uint32_t v){assert(h<2 && w<25);DISPATCH(s,SetWordInternal,s,CHASH_Handle(s,h),w,v);}
uint32_t CHASH_GetCallback(const CHASHState *s,uint32_t h,uint32_t id){assert(h<2 && id<5);return DISPATCH(s,GetCallbackInternal,CHASH_Handle(s,h),id);}
void CHASH_SetCallback(CHASHState *s,uint32_t h,uint32_t id,uint32_t v){assert(h<2 && id<5 && v<4);DISPATCH(s,SetCallbackInternal,CHASH_Handle(s,h),id,v);}
int32_t CHASH_GetLink(const CHASHState *s,uint32_t h){assert(h<2);DMA_HandleTypeDef *p=s->registeredCallbacks ? (s->suspendResume ? s->handles11[h].hdmain : s->handles10[h].hdmain) : (s->suspendResume ? s->handles01[h].hdmain : s->handles00[h].hdmain);return p ? (int32_t)findDMA(s,p) : -1;}
void CHASH_SetLink(CHASHState *s,uint32_t h,int32_t ch){assert(h<2 && ch>=-1 && ch<2);DMA_HandleTypeDef *p=ch<0 ? NULL : &s->dma[ch];if(s->registeredCallbacks){if(s->suspendResume)s->handles11[h].hdmain=p;else s->handles10[h].hdmain=p;}else{if(s->suspendResume)s->handles01[h].hdmain=p;else s->handles00[h].hdmain=p;}}
uint32_t CHASH_GetDMAWord(const CHASHState *s,uint32_t ch,uint32_t w){assert(ch<2);switch(w){case 0:return s->dma[ch].Parent ? findHandle(s,s->dma[ch].Parent) : UINT32_MAX;case 1:return s->dma[ch].Mode;case 2:return s->channels[ch].CBR1;case 3:return s->channels[ch].CSR;case 4:return s->dma[ch].LinkedListQueue!=NULL;case 5:return s->queues[ch].Head!=NULL;case 6:return s->dma[ch].ErrorCode;default:assert(0);return 0;}}
void CHASH_SetDMAWord(CHASHState *s,uint32_t ch,uint32_t w,uint32_t v){assert(ch<2);switch(w){case 0:assert(v<2 || v==UINT32_MAX);s->dma[ch].Parent=v==UINT32_MAX ? NULL : CHASH_Handle(s,v);break;case 1:s->dma[ch].Mode=v;break;case 2:s->channels[ch].CBR1=v;break;case 3:s->channels[ch].CSR=v;break;case 4:s->dma[ch].LinkedListQueue=v ? &s->queues[ch] : NULL;break;case 5:s->queues[ch].Head=v ? &s->nodes[ch] : NULL;break;case 6:s->dma[ch].ErrorCode=v;break;default:assert(0);}}
uint32_t CHASH_GetDMACallback(const CHASHState *s,uint32_t ch,uint32_t slot){assert(ch<2 && slot<2);return DISPATCH(s,GetDMACallbackInternal,&s->dma[ch],slot);}
void CHASH_SetDMACallback(CHASHState *s,uint32_t ch,uint32_t slot,uint32_t v){assert(ch<2 && slot<2 && v<3);DISPATCH(s,SetDMACallbackInternal,&s->dma[ch],slot,v);}
void CHASH_InvokeDMA(CHASHState *s,uint32_t ch,uint32_t kind){assert(ch<2 && kind<2);CHASHState *previous=CHASH_Active;CHASH_Active=s;DISPATCH(s,InvokeDMAInternal,&s->dma[ch],kind);CHASH_Active=previous;}
CHASHSnapshot CHASH_GetSnapshot(const CHASHState *s){CHASHSnapshot result;memset(&result,0,sizeof(result));const CHASHRegister regs[]={CHASH_CR,CHASH_DIN,CHASH_STR,CHASH_IMR,CHASH_SR};for(uint32_t i=0;i<5;i++)result.registers[i]=CHASH_Get(s,regs[i]);for(uint32_t h=0;h<2;h++){for(uint32_t i=0;i<25;i++)result.words[h][i]=CHASH_GetWord(s,h,i);for(uint32_t i=0;i<5;i++)result.callbacks[h][i]=CHASH_GetCallback(s,h,i);result.links[h]=(uint32_t)CHASH_GetLink(s,h);for(uint32_t i=0;i<7;i++)result.dma[h][i]=CHASH_GetDMAWord(s,h,i);for(uint32_t i=0;i<2;i++)result.dma[h][i+7]=CHASH_GetDMACallback(s,h,i);for(uint32_t i=0;i<9;i++)result.nodes[h][i]=CHASH_GetNode(s,h,i);memcpy(result.output[h],s->output[h],64);}return result;}
void CHASH_EmitCallback(CHASHState *s,uint32_t h,uint32_t id,uint32_t impl){assert(h<2 && id<5 && s->callbackCount<8);CHASHCallbackEvent *e=&s->callbacks[s->callbackCount++];e->handle=h;e->id=id;e->implementation=impl;e->tickCalls=s->tickCalls;e->snapshot=CHASH_GetSnapshot(s);CHASHAction actions[4];memcpy(actions,s->callbackActions[h][id],sizeof(actions));memset(s->callbackActions[h][id],0,sizeof(actions));for(uint32_t i=0;i<4;i++)CHASH_ApplyAction(s,actions[i]);}
void CHASH_DispatchCallback(const void *h,uint32_t id,uint32_t impl){assert(CHASH_Active);CHASH_EmitCallback(CHASH_Active,findHandle(CHASH_Active,h),id,impl);}
void CHASH_SetCallbackAction(CHASHState *s,uint32_t h,uint32_t id,uint32_t slot,CHASHAction a){assert(h<2 && id<5 && slot<4);s->callbackActions[h][id][slot]=a;}
CHASHCallbackEvent CHASH_GetCallbackEvent(const CHASHState *s,uint32_t index){assert(index<s->callbackCount);return s->callbacks[index];}
void CHASH_SetDMAAction(CHASHState *s,uint32_t ch,uint32_t op,uint32_t slot,CHASHAction a){assert(ch<2 && op<3 && slot<4);s->dmaActions[ch][op][slot]=a;}
uint32_t CHASH_DMAOperation(CHASHState *s,uint32_t ch,uint32_t op,uint32_t src,uint32_t dst,uint32_t size){assert(ch<2 && op<3 && s->dmaCount<8);uint32_t status=s->dmaStatus[ch][op];if(op==1 && s->dma[ch].LinkedListQueue && s->dma[ch].LinkedListQueue->Head){DMA_NodeTypeDef *n=s->dma[ch].LinkedListQueue->Head;size=n->LinkRegisters[2];src=n->LinkRegisters[3];dst=n->LinkRegisters[4];}CHASHDMAEvent *e=&s->dmaEvents[s->dmaCount++];e->channel=ch;e->operation=op;e->source=CHASH_NormalizeAddress(s,src);e->destination=CHASH_NormalizeAddress(s,dst);e->size=size;e->status=status;e->tickCalls=s->tickCalls;e->snapshot=CHASH_GetSnapshot(s);CHASHAction actions[4];memcpy(actions,s->dmaActions[ch][op],sizeof(actions));memset(s->dmaActions[ch][op],0,sizeof(actions));for(uint32_t i=0;i<4;i++)CHASH_ApplyAction(s,actions[i]);return status;}
HAL_StatusTypeDef CHASH_DMAStart(DMA_HandleTypeDef *h,uint32_t src,uint32_t dst,uint32_t size){assert(CHASH_Active);return CHASH_DMAOperation(CHASH_Active,findDMA(CHASH_Active,h),0,src,dst,size);}
HAL_StatusTypeDef CHASH_DMAListStart(DMA_HandleTypeDef *h){assert(CHASH_Active);return CHASH_DMAOperation(CHASH_Active,findDMA(CHASH_Active,h),1,0,0,0);}
HAL_StatusTypeDef CHASH_DMAAbort(DMA_HandleTypeDef *h){assert(CHASH_Active);return CHASH_DMAOperation(CHASH_Active,findDMA(CHASH_Active,h),2,0,0,0);}
CHASHDMAEvent CHASH_GetDMAEvent(const CHASHState *s,uint32_t i){assert(i<s->dmaCount);return s->dmaEvents[i];}
CHASHAccess CHASH_GetAccess(const CHASHState *s,uint32_t i){assert(i<s->accessCount);return s->accesses[i];}
uint32_t CHASH_Tick(CHASHState *s){uint32_t value=s->tick;s->tick+=s->tickStep;event(s,0,0,++s->tickCalls);return value;}
static void schedule(CHASHState *s,uint32_t kind,uint32_t trigger,uint32_t due,CHASHAction a){for(uint32_t i=0;i<32;i++)if(!s->events[i].active){s->events[i]=(CHASHEvent){1,kind,trigger,due,a};return;}assert(!"Too many HASH events");}
void CHASH_ScheduleTick(CHASHState *s,uint32_t n,CHASHAction a){assert(n);schedule(s,0,0,s->tickCalls+n,a);}
void CHASH_ScheduleRead(CHASHState *s,CHASHRegister r,uint32_t n,CHASHAction a){assert(n);schedule(s,1,r,s->readCounts[r]+n,a);}
void CHASH_ScheduleWrite(CHASHState *s,CHASHRegister r,uint32_t n,CHASHAction a){assert(n);schedule(s,2,r,s->writeCounts[r]+n,a);}
void CHASH_SetExecutionHook(CHASHState *s,void *context,CHASHActionHandler fn){s->executionContext=context;s->actionHandler=fn;}
void CHASH_ApplyAction(CHASHState *s,CHASHAction a){switch(a.kind){case CHASH_ActionNone:break;case CHASH_ActionRegister:CHASH_Set(s,(CHASHRegister)a.index,a.value);break;case CHASH_ActionWord:CHASH_SetWord(s,a.target,a.index,a.value);break;case CHASH_ActionDMAWord:CHASH_SetDMAWord(s,a.target,a.index,a.value);break;case CHASH_ActionCall:if(s->actionHandler)s->actionHandler(s->executionContext,a);else(void)CHASH_Run(s,a.target,(CHASHOperation)a.index,a.a,a.b,a.c,a.d);break;case CHASH_ActionDMAEvent:if(s->actionHandler)s->actionHandler(s->executionContext,a);else CHASH_InvokeDMA(s,a.target,a.index);break;default:assert(0);}}
uint32_t CHASH_Run(CHASHState *s,uint32_t h,CHASHOperation op,uint32_t a,uint32_t b,uint32_t c,uint32_t d){assert(h<2);CHASHState *previous=CHASH_Active;CHASH_Active=s;uint32_t result=DISPATCH(s,RunInternal,CHASH_Handle(s,h),op,a,b,c,d);CHASH_Active=previous;return result;}
uint32_t CHASH_RunNull(CHASHState *s,CHASHOperation op){CHASHState *previous=CHASH_Active;CHASH_Active=s;uint32_t result=DISPATCH(s,RunInternal,NULL,op,0,0,0,0);CHASH_Active=previous;return result;}
