/* Test-only raw hardware storage and scheduled stimuli. */
#include "FLASHShim.h"
#include <string.h>
#if defined(CFLASH_REFERENCE_ARM)
CFLASHState *CFLASH_Active;
#else
_Thread_local CFLASHState *CFLASH_Active;
#endif
static volatile uint32_t *address(const CFLASHState *s,CFLASHRegister reg) {
 switch(reg) {
#include "RegisterAddresses.inc"
 default:assert(!"Unknown FLASH register");return NULL;
 }
}
uint32_t CFLASH_PhysicalAddress(uint32_t value) {
#if defined(CFLASH_REFERENCE_ARM)
 if(value>=0x08000000U && value<0x08000400U)return CFLASH_ARM_MAIN_BASE+value-0x08000000U;
 if(value>=0x08FFF000U && value<0x08FFF400U)return CFLASH_ARM_OTP_BASE+value-0x08FFF000U;
 if(value>=0x20000000U && value<0x20000400U)return CFLASH_ARM_SOURCE_BASE+value-0x20000000U;
#endif
 return value;
}
uint32_t CFLASH_LogicalAddress(uint32_t value) {
#if defined(CFLASH_REFERENCE_ARM)
 if(value>=CFLASH_ARM_MAIN_BASE && value<CFLASH_ARM_MAIN_BASE+CFLASH_ARM_AREA_SIZE)return 0x08000000U+value-CFLASH_ARM_MAIN_BASE;
 if(value>=CFLASH_ARM_OTP_BASE && value<CFLASH_ARM_OTP_BASE+CFLASH_ARM_AREA_SIZE)return 0x08FFF000U+value-CFLASH_ARM_OTP_BASE;
 if(value>=CFLASH_ARM_SOURCE_BASE && value<CFLASH_ARM_SOURCE_BASE+CFLASH_ARM_AREA_SIZE)return 0x20000000U+value-CFLASH_ARM_SOURCE_BASE;
#endif
 return value;
}
void CFLASH_Reset(CFLASHState *s) {
 memset(s,0,sizeof(*s));s->tickStep=1;
 s->erase.TypeErase=FLASH_TYPEERASE_SECTORS;s->erase.NbSectors=1;
 s->crc.TypeCRC=FLASH_CRC_BANK;s->crc.NbSectors=1;
 s->crc.CRCStartAddr=0x08000000U;s->crc.CRCEndAddr=0x0800000FU;
 s->options.NVState=OB_NVSTATE_OPEN;
 s->sectorError=0xA5A5A5A5U;s->crcResult=0x5A5A5A5AU;
 for(uint32_t i=0;i<8;i++)s->keys[i]=0x12345678U+i*0x11111111U;
}
uint32_t CFLASH_Get(const CFLASHState *s,CFLASHRegister reg) {
 uint32_t value=*address(s,reg);
 return (reg==CFLASH_ECCSFADDR || reg==CFLASH_ECCDFADDR) ? CFLASH_LogicalAddress(value) : value;
}
void CFLASH_Set(CFLASHState *s,CFLASHRegister reg,uint32_t value) {
 *address(s,reg)=(reg==CFLASH_ECCSFADDR || reg==CFLASH_ECCDFADDR) ? CFLASH_PhysicalAddress(value) : value;
}
static void record(CFLASHState *s,CFLASHRegister reg,uint32_t value,uint32_t kind) {
 assert(s->accessCount<512);s->accesses[s->accessCount++]=(CFLASHAccess){reg,value,kind,s->tickCalls};
}
uint32_t CFLASH_Read(CFLASHState *s,CFLASHRegister reg) {
 uint32_t value=CFLASH_Get(s,reg);record(s,reg,value,0);return value;
}
static void dispatchEvents(CFLASHState *s,uint32_t kind,uint32_t trigger,uint32_t count) {
 for(uint32_t i=0;i<32;i++) {
  CFLASHEvent *event=&s->events[i];
  if(event->active && event->kind==kind && event->trigger==trigger && event->due==count) {
   CFLASHAction action=event->action;event->active=0;CFLASH_ApplyAction(s,action);
  }
 }
}
void CFLASH_Write(CFLASHState *s,CFLASHRegister reg,uint32_t value) {
 CFLASH_Set(s,reg,value);record(s,reg,value,1);
 dispatchEvents(s,1,(uint32_t)reg,++s->writeCounts[reg]);
}
static int findAddress(volatile uint32_t *p,CFLASHRegister *reg) {
 assert(CFLASH_Active);
 for(uint32_t i=0;i<CFLASH_RegisterCount;i++)if(p==address(CFLASH_Active,(CFLASHRegister)i)){*reg=(CFLASHRegister)i;return 1;}
 return 0;
}
uint32_t CFLASH_ReadAddress(volatile uint32_t *p) {
 CFLASHRegister reg;return findAddress(p,&reg) ? CFLASH_Read(CFLASH_Active,reg) : *p;
}
void CFLASH_WriteAddress(volatile uint32_t *p,uint32_t value) {
 CFLASHRegister reg;if(findAddress(p,&reg))CFLASH_Write(CFLASH_Active,reg,value);else *p=value;
}
uint32_t CFLASH_GetProcess(const CFLASHState *s,uint32_t word) {
 switch(word) {
 case 0:return s->process.Lock;case 1:return s->process.ErrorCode;
 case 2:return s->process.ProcedureOnGoing;case 3:return CFLASH_LogicalAddress(s->process.Address);
 case 4:return s->process.Sector;case 5:return s->process.NbSectorsToErase;
 default:assert(0);return 0;
 }
}
void CFLASH_SetProcess(CFLASHState *s,uint32_t word,uint32_t value) {
 switch(word) {
 case 0:s->process.Lock=(HAL_LockTypeDef)value;break;case 1:s->process.ErrorCode=value;break;
 case 2:s->process.ProcedureOnGoing=value;break;case 3:s->process.Address=CFLASH_PhysicalAddress(value);break;
 case 4:s->process.Sector=value;break;case 5:s->process.NbSectorsToErase=value;break;
 default:assert(0);break;
 }
}
CFLASHSnapshot CFLASH_GetSnapshot(const CFLASHState *s) {
 CFLASHSnapshot result;
 for(uint32_t i=0;i<CFLASH_RegisterCount;i++)result.registers[i]=CFLASH_Get(s,(CFLASHRegister)i);
 for(uint32_t i=0;i<6;i++)result.process[i]=CFLASH_GetProcess(s,i);
 result.sectorError=s->sectorError;result.crcResult=s->crcResult;
 memcpy(result.keys,s->keys,sizeof(result.keys));result.options=s->options;result.ecc=s->ecc;
 return result;
}
void CFLASH_SetCallbackAction(CFLASHState *s,uint32_t id,uint32_t slot,CFLASHAction action) {
 assert(id<4 && slot<4);s->callbackActions[id][slot]=action;
}
void CFLASH_EmitCallback(CFLASHState *s,uint32_t id,uint32_t argument) {
 assert(id<4 && s->callbackCount<32);
 CFLASHCallbackEvent *event=&s->callbacks[s->callbackCount++];
 event->id=id;event->argument=CFLASH_LogicalAddress(argument);event->tickCall=s->tickCalls;event->snapshot=CFLASH_GetSnapshot(s);
 CFLASHAction actions[4];memcpy(actions,s->callbackActions[id],sizeof(actions));memset(s->callbackActions[id],0,sizeof(actions));
 for(uint32_t i=0;i<4;i++)CFLASH_ApplyAction(s,actions[i]);
}
void CFLASH_DispatchCallback(uint32_t id,uint32_t argument){CFLASH_EmitCallback(CFLASH_Active,id,argument);}
CFLASHCallbackEvent CFLASH_GetCallbackEvent(const CFLASHState *s,uint32_t i){assert(i<s->callbackCount);return s->callbacks[i];}
CFLASHAccess CFLASH_GetAccess(const CFLASHState *s,uint32_t i){assert(i<s->accessCount);return s->accesses[i];}
CFLASHIntrinsicEvent CFLASH_GetIntrinsic(const CFLASHState *s,uint32_t i){assert(i<s->intrinsicCount);return s->intrinsics[i];}
uint32_t CFLASH_Intrinsic(CFLASHState *s,uint32_t kind,uint32_t value) {
#if !defined(CFLASH_REFERENCE_ARM)
 /* A successful original memory helper must never dereference a truncated
  * native pointer on a 64-bit host, even in a build with assertions disabled. */
 __builtin_trap();
#endif
 assert(kind<5 && s->intrinsicCount<64);
 if(kind==0)value=s->primask;
 if(kind==1){s->primask=1;value=1;}
 if(kind==4)s->primask=value;
 s->intrinsics[s->intrinsicCount++]=(CFLASHIntrinsicEvent){kind,value};return value;
}
uint32_t CFLASH_Tick(CFLASHState *s) {
 uint32_t result=s->tick;s->tick+=s->tickStep;s->tickCalls++;
 dispatchEvents(s,0,0,s->tickCalls);return result;
}
static void schedule(CFLASHState *s,uint32_t kind,uint32_t trigger,uint32_t due,CFLASHAction action) {
 for(uint32_t i=0;i<32;i++)if(!s->events[i].active){s->events[i]=(CFLASHEvent){1,kind,trigger,due,action};return;}
 assert(!"FLASH event capacity exceeded");
}
void CFLASH_ScheduleTick(CFLASHState *s,uint32_t after,CFLASHAction action){assert(after);schedule(s,0,0,s->tickCalls+after,action);}
void CFLASH_ScheduleWrite(CFLASHState *s,CFLASHRegister reg,uint32_t after,CFLASHAction action){assert(after);schedule(s,1,(uint32_t)reg,s->writeCounts[reg]+after,action);}
void CFLASH_SetExecutionHook(CFLASHState *s,void *context,CFLASHActionHandler handler){s->executionContext=context;s->actionHandler=handler;}
void CFLASH_ApplyAction(CFLASHState *s,CFLASHAction action) {
 if(action.kind==CFLASH_ActionNone)return;
 if(s->actionHandler){s->actionHandler(s->executionContext,action);return;}
 switch(action.kind) {
 case CFLASH_ActionNone:return;
 case CFLASH_ActionRegister:CFLASH_Set(s,(CFLASHRegister)action.index,action.value);return;
 case CFLASH_ActionProcess:CFLASH_SetProcess(s,action.index,action.value);return;
 case CFLASH_ActionCall:(void)CFLASH_Run(s,(CFLASHOperation)action.index,action.a,action.b,action.c);return;
 }
 assert(!"Unknown FLASH action");
}
uint32_t CFLASH_Run(CFLASHState *s,CFLASHOperation operation,uint32_t a,uint32_t b,uint32_t c) {
 CFLASHState *previous=CFLASH_Active;CFLASH_Active=s;uint32_t result=0;
 switch(operation) {
 case CFLASH_Program:result=HAL_FLASH_Program(a,CFLASH_PhysicalAddress(b),CFLASH_PhysicalAddress(c));break;
 case CFLASH_ProgramInterrupt:result=HAL_FLASH_Program_IT(a,CFLASH_PhysicalAddress(b),CFLASH_PhysicalAddress(c));break;
 case CFLASH_HandleInterrupt:HAL_FLASH_IRQHandler();break;
 case CFLASH_Unlock:result=HAL_FLASH_Unlock();break;
 case CFLASH_Lock:result=HAL_FLASH_Lock();break;
 case CFLASH_UnlockOptionBytes:result=HAL_FLASH_OB_Unlock();break;
 case CFLASH_LockOptionBytes:result=HAL_FLASH_OB_Lock();break;
 case CFLASH_GetError:result=HAL_FLASH_GetError();break;
 case CFLASH_Wait:result=FLASH_WaitForLastOperation(a);break;
 case CFLASH_Erase:result=HAL_FLASHEx_Erase(&s->erase,&s->sectorError);break;
 case CFLASH_EraseInterrupt:result=HAL_FLASHEx_Erase_IT(&s->erase);break;
 case CFLASH_ProgramOptionBytes:result=HAL_FLASHEx_OBProgram(&s->options);break;
 case CFLASH_GetOptionBytes:HAL_FLASHEx_OBGetConfig(&s->options);break;
 case CFLASH_ConfigureOTPLock:result=HAL_FLASHEx_OTPLockConfig(a);break;
 case CFLASH_GetOTPLock:result=HAL_FLASHEx_GetOTPLock();break;
 case CFLASH_ConfigureKey:result=HAL_FLASHEx_KeyConfig(&s->key,s->keys);break;
 case CFLASH_GetKey:result=HAL_FLASHEx_GetKey(&s->key,a ? NULL : s->keys);break;
 case CFLASH_ComputeCRC:{FLASH_CRCInitTypeDef config=s->crc;config.CRCStartAddr=CFLASH_PhysicalAddress(config.CRCStartAddr);config.CRCEndAddr=CFLASH_PhysicalAddress(config.CRCEndAddr);result=HAL_FLASHEx_ComputeCRC(&config,&s->crcResult);break;}
 case CFLASH_EnableECCCorrection:HAL_FLASHEx_EnableEccCorrectionInterrupt();break;
 case CFLASH_DisableECCCorrection:HAL_FLASHEx_DisableEccCorrectionInterrupt();break;
 case CFLASH_EnableECCDetection:HAL_FLASHEx_EnableEccDetectionInterrupt();break;
 case CFLASH_DisableECCDetection:HAL_FLASHEx_DisableEccDetectionInterrupt();break;
 case CFLASH_GetECCInfo:HAL_FLASHEx_GetEccInfo(&s->ecc);s->ecc.Address=CFLASH_LogicalAddress(s->ecc.Address);break;
 case CFLASH_HandleECCDetection:HAL_FLASHEx_ECCD_IRQHandler();break;
 case CFLASH_EnableInterrupts:__HAL_FLASH_ENABLE_IT(a);break;
 case CFLASH_DisableInterrupts:__HAL_FLASH_DISABLE_IT(a);break;
 case CFLASH_GetFlag:result=__HAL_FLASH_GET_FLAG(a);break;
 case CFLASH_ClearFlag:__HAL_FLASH_CLEAR_FLAG(a);break;
 case CFLASH_SetLatency:__HAL_FLASH_SET_LATENCY(a);break;
 case CFLASH_GetLatency:result=__HAL_FLASH_GET_LATENCY();break;
 default:assert(!"Unknown FLASH operation");result=UINT32_MAX;break;
 }
 CFLASH_Active=previous;return result;
}
