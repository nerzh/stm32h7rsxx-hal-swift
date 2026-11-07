/* Test-only raw MMIO storage. No physical security or protection is modified. */
#include "SystemShim.h"
#include <string.h>
_Thread_local CSystemState *CSystem_Active;
static volatile uint32_t *address(const CSystemState *s,CSystemRegister reg){switch(reg){
#include "SystemRegisterAddresses.inc"
default:assert(!"Unknown system register");return NULL;}}
void CSystem_Reset(CSystemState *s){memset(s,0,sizeof(*s));s->tickStep=1;for(uint32_t i=0;i<3;i++)s->outputs[i]=0xA5A50000U+i;}
uint32_t CSystem_Get(const CSystemState *s,CSystemRegister reg){return *address(s,reg);}
void CSystem_Set(CSystemState *s,CSystemRegister reg,uint32_t value){*address(s,reg)=value;}
static void access(CSystemState *s,CSystemRegister reg,uint32_t value,uint32_t kind){assert(s->accessCount<256);s->accesses[s->accessCount++]=(CSystemAccess){reg,value,kind,s->tickCalls};}
uint32_t CSystem_Read(CSystemState *s,CSystemRegister reg){uint32_t value=CSystem_Get(s,reg);access(s,reg,value,0);return value;}
void CSystem_Write(CSystemState *s,CSystemRegister reg,uint32_t value){CSystem_Set(s,reg,value);access(s,reg,value,1);}
static int findAddress(volatile uint32_t *p,CSystemRegister *reg){assert(CSystem_Active);for(uint32_t i=0;i<CSystem_RegisterCount;i++)if(p==address(CSystem_Active,(CSystemRegister)i)){*reg=(CSystemRegister)i;return 1;}return 0;}
uint32_t CSystem_ReadAddress(volatile uint32_t *p){CSystemRegister reg;return findAddress(p,&reg) ? CSystem_Read(CSystem_Active,reg) : *p;}
void CSystem_WriteAddress(volatile uint32_t *p,uint32_t value){CSystemRegister reg;if(findAddress(p,&reg))CSystem_Write(CSystem_Active,reg,value);else *p=value;}
uint32_t *CSystem_Pointer(CSystemState *s,uint32_t selector){
 if(selector==0)return NULL;
 if(selector<=3)return &s->outputs[selector-1];
 assert(selector>=0x100 && selector<0x100+CSystem_RegisterCount);
 return (uint32_t *)address(s,(CSystemRegister)(selector-0x100));
}
uint32_t CSystem_Tick(CSystemState *s){
 uint32_t value=s->tick;s->tick+=s->tickStep;s->tickCalls++;
 for(uint32_t i=0;i<16;i++)if(s->events[i].active && s->events[i].afterCalls==s->tickCalls){s->events[i].active=0;CSystem_Set(s,s->events[i].reg,s->events[i].value);}
 return value;
}
void CSystem_ScheduleTick(CSystemState *s,uint32_t afterCalls,CSystemRegister reg,uint32_t value){
 assert(afterCalls);for(uint32_t i=0;i<16;i++)if(!s->events[i].active){s->events[i]=(CSystemEvent){1,s->tickCalls+afterCalls,reg,value};return;}assert(!"System event capacity exceeded");
}
CSystemAccess CSystem_GetAccess(const CSystemState *s,uint32_t index){assert(index<s->accessCount);return s->accesses[index];}
uint32_t CSystem_Run(CSystemState *s,CSystemOperation operation,uint32_t a,uint32_t b,uint32_t c,uint32_t d){
 CSystemState *previous=CSystem_Active;CSystem_Active=s;uint32_t result=0;
 if(operation>=CSystem_AXIM_ASIB_EnablePacking && operation<=CSystem_AXIM_ASIB_WriteQoSConfig)assert(a<11);
 if(operation>=CSystem_AXIM_AMIB_EnablePacking && operation<=CSystem_AXIM_AMIB_DisableLongBurst)assert(a<10);
 switch(operation){
#include "SystemDispatch.inc"
 default:assert(!"Unknown system operation");result=UINT32_MAX;break;
 }
 CSystem_Active=previous;return result;
}
