/* Test-only raw storage, timed stimuli and callback observations. */
#include "DTSInternal.h"
#include <assert.h>
#include <string.h>
_Thread_local CDTSState *CDTS_Active;

static volatile uint32_t *address(const CDTSState *s, CDTSRegister reg) {
  switch(reg) {
  case CDTS_CFGR1: return (volatile uint32_t *)&s->registers.CFGR1;
  case CDTS_T0VALR1: return (volatile uint32_t *)&s->registers.T0VALR1;
  case CDTS_RAMPVALR: return (volatile uint32_t *)&s->registers.RAMPVALR;
  case CDTS_ITR1: return (volatile uint32_t *)&s->registers.ITR1;
  case CDTS_DR: return (volatile uint32_t *)&s->registers.DR;
  case CDTS_SR: return (volatile uint32_t *)&s->registers.SR;
  case CDTS_ITENR: return (volatile uint32_t *)&s->registers.ITENR;
  case CDTS_ICIFR: return (volatile uint32_t *)&s->registers.ICIFR;
  case CDTS_EXTI_IMR2: return (volatile uint32_t *)&s->exti.IMR2;
  case CDTS_EXTI_EMR2: return (volatile uint32_t *)&s->exti.EMR2;
  default: assert(!"Unknown DTS register"); return NULL;
  }
}
void CDTS_Reset(CDTSState *s,uint32_t registered) {
  memset(s,0,sizeof(*s));
  s->registeredCallbacks=registered!=0;
  s->handle0.Instance=&s->registers; s->handle1.Instance=&s->registers;
  s->pclk1=48000000; s->lse=32768; s->tickStep=1;
  s->registers.T0VALR1=6000; s->registers.RAMPVALR=1000; s->registers.DR=80;
  CDTS_SetWord(s,3,0x10000);
}
uint32_t CDTS_Get(const CDTSState *s,CDTSRegister reg) {return *address(s,reg);}
void CDTS_Set(CDTSState *s,CDTSRegister reg,uint32_t value) {*address(s,reg)=value;}
static void recordAccess(CDTSState *s,CDTSRegister reg,uint32_t value,uint32_t kind) {
  assert(s->accessCount<512);
  s->accesses[s->accessCount++]=(CDTSAccess){reg,value,kind,s->tickCalls};
}
uint32_t CDTS_Read(CDTSState *s,CDTSRegister reg) {
  uint32_t value=CDTS_Get(s,reg);recordAccess(s,reg,value,0);return value;
}
void CDTS_Write(CDTSState *s,CDTSRegister reg,uint32_t value) {
  CDTS_Set(s,reg,value);recordAccess(s,reg,value,1);
}
static int findAddress(volatile uint32_t *pointer,CDTSRegister *reg) {
  assert(CDTS_Active);
  for(uint32_t i=0;i<CDTS_RegisterCount;i++)if(pointer==address(CDTS_Active,(CDTSRegister)i)) {
    *reg=(CDTSRegister)i;return 1;
  }
  return 0;
}
uint32_t CDTS_ReadAddress(volatile uint32_t *pointer) {
  CDTSRegister reg;
  return findAddress(pointer,&reg) ? CDTS_Read(CDTS_Active,reg) : *pointer;
}
void CDTS_WriteAddress(volatile uint32_t *pointer,uint32_t value) {
  CDTSRegister reg;
  if(findAddress(pointer,&reg))CDTS_Write(CDTS_Active,reg,value);else *pointer=value;
}
CDTSAccess CDTS_GetAccess(const CDTSState *s,uint32_t index) {
  assert(index<s->accessCount);return s->accesses[index];
}
uint32_t CDTS_GetWord(const CDTSState *s,uint32_t word) {
  assert(word<9);
  return s->registeredCallbacks ? CDTS1_GetWordInternal(&s->handle1,word) : CDTS0_GetWordInternal(&s->handle0,word);
}
void CDTS_SetWord(CDTSState *s,uint32_t word,uint32_t value) {
  assert(word<9);
  if(s->registeredCallbacks)CDTS1_SetWordInternal(&s->handle1,word,value);else CDTS0_SetWordInternal(&s->handle0,word,value);
}
uint32_t CDTS_GetCallback(const CDTSState *s,uint32_t id) {
  assert(id<8);
  return s->registeredCallbacks ? CDTS1_GetCallbackInternal(&s->handle1,id) : CDTS0_GetCallbackInternal(&s->handle0,id);
}
void CDTS_SetCallback(CDTSState *s,uint32_t id,uint32_t implementation) {
  assert(id<8 && implementation<4);
  if(s->registeredCallbacks)CDTS1_SetCallbackInternal(&s->handle1,id,implementation);else CDTS0_SetCallbackInternal(&s->handle0,id,implementation);
}
void CDTS_SetCallbackAction(CDTSState *s,uint32_t id,uint32_t slot,CDTSAction action) {
  assert(id<8 && slot<4);s->callbackActions[id][slot]=action;
}
CDTSSnapshot CDTS_GetSnapshot(const CDTSState *s) {
  CDTSSnapshot result;
  for(uint32_t i=0;i<10;i++)result.registers[i]=CDTS_Get(s,(CDTSRegister)i);
  for(uint32_t i=0;i<9;i++)result.words[i]=CDTS_GetWord(s,i);
  for(uint32_t i=0;i<8;i++)result.callbacks[i]=CDTS_GetCallback(s,i);
  result.temperature=s->temperature;
  return result;
}
void CDTS_EmitCallback(CDTSState *s,uint32_t id,uint32_t implementation) {
  assert(id<8 && s->callbackCount<64);
  CDTSCallbackEvent *event=&s->callbacks[s->callbackCount++];
  event->callbackID=id;event->implementation=implementation;event->tickCall=s->tickCalls;
  event->delayCount=s->delayCount;event->snapshot=CDTS_GetSnapshot(s);
  CDTSAction actions[4];memcpy(actions,s->callbackActions[id],sizeof(actions));
  memset(s->callbackActions[id],0,sizeof(actions));
  for(uint32_t i=0;i<4;i++)CDTS_ApplyAction(s,actions[i]);
}
void CDTS_DispatchCallback(uint32_t id,uint32_t implementation) {CDTS_EmitCallback(CDTS_Active,id,implementation);}
CDTSCallbackEvent CDTS_GetCallbackEvent(const CDTSState *s,uint32_t index) {
  assert(index<s->callbackCount);return s->callbacks[index];
}
uint32_t CDTS_Tick(CDTSState *s) {
  uint32_t value=s->tick;s->tick+=s->tickStep;s->tickCalls++;
  for(uint32_t i=0;i<32;i++)if(s->events[i].active && s->events[i].due==s->tickCalls) {
    CDTSAction action=s->events[i].action;s->events[i].active=0;CDTS_ApplyAction(s,action);
  }
  return value;
}
void CDTS_Delay(CDTSState *s,uint32_t duration) {
  assert(s->delayCount<16);
  CDTSDelayEvent *event=&s->delays[s->delayCount++];
  event->duration=duration;event->tickCall=s->tickCalls;event->snapshot=CDTS_GetSnapshot(s);
  CDTSAction action=s->delayAction;memset(&s->delayAction,0,sizeof(action));CDTS_ApplyAction(s,action);
}
CDTSDelayEvent CDTS_GetDelayEvent(const CDTSState *s,uint32_t index) {
  assert(index<s->delayCount);return s->delays[index];
}
void CDTS_ScheduleTick(CDTSState *s,uint32_t after,CDTSAction action) {
  assert(after!=0);
  for(uint32_t i=0;i<32;i++)if(!s->events[i].active) {
    s->events[i]=(CDTSTickEvent){s->tickCalls+after,1,action};return;
  }
  assert(!"DTS event capacity exceeded");
}
void CDTS_SetDelayAction(CDTSState *s,CDTSAction action) {s->delayAction=action;}
void CDTS_SetExecutionHook(CDTSState *s,void *context,CDTSActionHandler handler) {
  s->executionContext=context;s->actionHandler=handler;
}
uint32_t CDTS_ApplyAction(CDTSState *s,CDTSAction action) {
  if(action.kind==CDTS_ActionNone)return 0;
  if(s->actionHandler){s->actionHandler(s->executionContext,action);return 0;}
  switch(action.kind) {
  case CDTS_ActionNone:return 0;
  case CDTS_ActionRegister:CDTS_Set(s,(CDTSRegister)action.index,action.value);return 0;
  case CDTS_ActionWord:CDTS_SetWord(s,action.index,action.value);return 0;
  case CDTS_ActionCall:return CDTS_Run(s,(CDTSOperation)action.index,action.argument,action.implementation);
  }
  assert(!"Unknown DTS action");return UINT32_MAX;
}
uint32_t CDTS_Run(CDTSState *s,CDTSOperation operation,uint32_t argument,uint32_t implementation) {
  CDTSState *previous=CDTS_Active;CDTS_Active=s;
  uint32_t result=s->registeredCallbacks ? CDTS1_RunInternal(&s->handle1,operation,argument,implementation)
                                       : CDTS0_RunInternal(&s->handle0,operation,argument,implementation);
  CDTS_Active=previous;return result;
}
uint32_t CDTS_RunNull(CDTSState *s,CDTSOperation operation) {
  CDTSState *previous=CDTS_Active;CDTS_Active=s;
  uint32_t result=s->registeredCallbacks ? CDTS1_RunInternal(NULL,operation,0,0) : CDTS0_RunInternal(NULL,operation,0,0);
  CDTS_Active=previous;return result;
}
