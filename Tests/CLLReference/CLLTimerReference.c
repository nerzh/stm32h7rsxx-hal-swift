#include "include/CLLTimerReference.h"
#include <stdlib.h>
#include <assert.h>
#include "Upstream/Timer/Trace/stm32h7rsxx_ll_tim.h"
#include "Upstream/Timer/stm32h7rsxx_ll_lptim.h"
#include "Upstream/Timer/Trace/stm32h7rsxx_ll_tim.inc"
#include "Upstream/Timer/stm32h7rsxx_ll_lptim.inc"
struct CL52State { uint32_t cells[6144], count, reads, salt, instance; CL52Access trace[512]; };
_Thread_local uint32_t *CL52_Cells;
static _Thread_local CL52State *current;
CL52State *CL52_Create(void) { return calloc(1, sizeof(CL52State)); }
void CL52_Destroy(CL52State *s) { free(s); }
void CL52_Reset(CL52State *s, uint32_t seed, uint32_t salt, uint32_t instance) {
  current=s; CL52_Cells=s->cells;
  for(uint32_t i=0;i<6144;i++)s->cells[i]=seed ^ (i*0x9E3779B9U);
  s->count=0;s->reads=0;s->salt=salt;s->instance=instance;
}
static void record(uint32_t index,uint32_t value,uint32_t kind) {
  assert(index<6144 && current->count<512);
  current->trace[current->count++]=(CL52Access){index,value,kind};
}
uint32_t CL52_Read(volatile const uint32_t *p) {
  uintptr_t offset=(uintptr_t)p-(uintptr_t)CL52_Cells;
  if(offset>=sizeof(current->cells))return *p; /* Local arithmetic is not peripheral IO. */
  assert(offset%4==0);uint32_t index=(uint32_t)(offset/4);
  uint32_t value=*p ^ (current->salt*current->reads++);
  record(index,value,0);return value;
}
void CL52_Write(volatile uint32_t *p,uint32_t value) {
  uintptr_t offset=(uintptr_t)p-(uintptr_t)CL52_Cells;
  if(offset>=sizeof(current->cells)){*p=value;return;}
  assert(offset%4==0);record((uint32_t)(offset/4),value,1);*p=value;
}
uint32_t *CL52_GetCells(CL52State *s){return s->cells;}
const CL52Access *CL52_GetTrace(CL52State *s){return s->trace;}
uint32_t CL52_GetTraceCount(CL52State *s){return s->count;}
/* Calculation macros operate on ordinary scalar arguments. Header function bodies above retain traced IO. */
#undef READ_BIT
#define READ_BIT(reg,mask) ((reg)&(mask))
uint32_t CL52_Run(CL52State *s,uint32_t operation,const uint32_t *args) {
  current=s;CL52_Cells=s->cells;
  TIM_TypeDef *tim=(void *)(s->cells+(s->instance<14?s->instance*256:5888));
  LPTIM_TypeDef *lptim=(void *)(s->cells+(s->instance<5?3584+s->instance*16:5904));
  switch(operation) {
    case 0: { LL_TIM_EnableCounter(tim); return 0; }
    case 1: { LL_TIM_DisableCounter(tim); return 0; }
    case 2: { uint32_t result=LL_TIM_IsEnabledCounter(tim); return result; }
    case 3: { LL_TIM_EnableUpdateEvent(tim); return 0; }
    case 4: { LL_TIM_DisableUpdateEvent(tim); return 0; }
    case 5: { uint32_t result=LL_TIM_IsEnabledUpdateEvent(tim); return result; }
    case 6: { LL_TIM_SetUpdateSource(tim, args[0]); return 0; }
    case 7: { uint32_t result=LL_TIM_GetUpdateSource(tim); return result; }
    case 8: { LL_TIM_SetOnePulseMode(tim, args[0]); return 0; }
    case 9: { uint32_t result=LL_TIM_GetOnePulseMode(tim); return result; }
    case 10: { LL_TIM_SetCounterMode(tim, args[0]); return 0; }
    case 11: { uint32_t result=LL_TIM_GetCounterMode(tim); return result; }
    case 12: { LL_TIM_EnableARRPreload(tim); return 0; }
    case 13: { LL_TIM_DisableARRPreload(tim); return 0; }
    case 14: { uint32_t result=LL_TIM_IsEnabledARRPreload(tim); return result; }
    case 15: { LL_TIM_SetClockDivision(tim, args[0]); return 0; }
    case 16: { uint32_t result=LL_TIM_GetClockDivision(tim); return result; }
    case 17: { LL_TIM_SetCounter(tim, args[0]); return 0; }
    case 18: { uint32_t result=LL_TIM_GetCounter(tim); return result; }
    case 19: { uint32_t result=LL_TIM_GetDirection(tim); return result; }
    case 20: { LL_TIM_SetPrescaler(tim, args[0]); return 0; }
    case 21: { uint32_t result=LL_TIM_GetPrescaler(tim); return result; }
    case 22: { LL_TIM_SetAutoReload(tim, args[0]); return 0; }
    case 23: { uint32_t result=LL_TIM_GetAutoReload(tim); return result; }
    case 24: { LL_TIM_SetRepetitionCounter(tim, args[0]); return 0; }
    case 25: { uint32_t result=LL_TIM_GetRepetitionCounter(tim); return result; }
    case 26: { LL_TIM_EnableUIFRemap(tim); return 0; }
    case 27: { LL_TIM_DisableUIFRemap(tim); return 0; }
    case 28: { uint32_t result=LL_TIM_IsActiveUIFCPY(args[0]); return result; }
    case 29: { LL_TIM_EnableDithering(tim); return 0; }
    case 30: { LL_TIM_DisableDithering(tim); return 0; }
    case 31: { uint32_t result=LL_TIM_IsEnabledDithering(tim); return result; }
    case 32: { LL_TIM_CC_EnablePreload(tim); return 0; }
    case 33: { LL_TIM_CC_DisablePreload(tim); return 0; }
    case 34: { uint32_t result=LL_TIM_CC_IsEnabledPreload(tim); return result; }
    case 35: { LL_TIM_CC_SetUpdate(tim, args[0]); return 0; }
    case 36: { LL_TIM_CC_SetDMAReqTrigger(tim, args[0]); return 0; }
    case 37: { uint32_t result=LL_TIM_CC_GetDMAReqTrigger(tim); return result; }
    case 38: { LL_TIM_CC_SetLockLevel(tim, args[0]); return 0; }
    case 39: { LL_TIM_CC_EnableChannel(tim, args[0]); return 0; }
    case 40: { LL_TIM_CC_DisableChannel(tim, args[0]); return 0; }
    case 41: { uint32_t result=LL_TIM_CC_IsEnabledChannel(tim, args[0]); return result; }
    case 42: { LL_TIM_OC_ConfigOutput(tim, args[0], args[1]); return 0; }
    case 43: { LL_TIM_OC_SetMode(tim, args[0], args[1]); return 0; }
    case 44: { uint32_t result=LL_TIM_OC_GetMode(tim, args[0]); return result; }
    case 45: { LL_TIM_OC_SetPolarity(tim, args[0], args[1]); return 0; }
    case 46: { uint32_t result=LL_TIM_OC_GetPolarity(tim, args[0]); return result; }
    case 47: { LL_TIM_OC_SetIdleState(tim, args[0], args[1]); return 0; }
    case 48: { uint32_t result=LL_TIM_OC_GetIdleState(tim, args[0]); return result; }
    case 49: { LL_TIM_OC_EnableFast(tim, args[0]); return 0; }
    case 50: { LL_TIM_OC_DisableFast(tim, args[0]); return 0; }
    case 51: { uint32_t result=LL_TIM_OC_IsEnabledFast(tim, args[0]); return result; }
    case 52: { LL_TIM_OC_EnablePreload(tim, args[0]); return 0; }
    case 53: { LL_TIM_OC_DisablePreload(tim, args[0]); return 0; }
    case 54: { uint32_t result=LL_TIM_OC_IsEnabledPreload(tim, args[0]); return result; }
    case 55: { LL_TIM_OC_EnableClear(tim, args[0]); return 0; }
    case 56: { LL_TIM_OC_DisableClear(tim, args[0]); return 0; }
    case 57: { uint32_t result=LL_TIM_OC_IsEnabledClear(tim, args[0]); return result; }
    case 58: { LL_TIM_OC_SetDeadTime(tim, args[0]); return 0; }
    case 59: { LL_TIM_OC_SetCompareCH1(tim, args[0]); return 0; }
    case 60: { LL_TIM_OC_SetCompareCH2(tim, args[0]); return 0; }
    case 61: { LL_TIM_OC_SetCompareCH3(tim, args[0]); return 0; }
    case 62: { LL_TIM_OC_SetCompareCH4(tim, args[0]); return 0; }
    case 63: { LL_TIM_OC_SetCompareCH5(tim, args[0]); return 0; }
    case 64: { LL_TIM_OC_SetCompareCH6(tim, args[0]); return 0; }
    case 65: { uint32_t result=LL_TIM_OC_GetCompareCH1(tim); return result; }
    case 66: { uint32_t result=LL_TIM_OC_GetCompareCH2(tim); return result; }
    case 67: { uint32_t result=LL_TIM_OC_GetCompareCH3(tim); return result; }
    case 68: { uint32_t result=LL_TIM_OC_GetCompareCH4(tim); return result; }
    case 69: { uint32_t result=LL_TIM_OC_GetCompareCH5(tim); return result; }
    case 70: { uint32_t result=LL_TIM_OC_GetCompareCH6(tim); return result; }
    case 71: { LL_TIM_SetCH5CombinedChannels(tim, args[0]); return 0; }
    case 72: { LL_TIM_OC_SetPulseWidthPrescaler(tim, args[0]); return 0; }
    case 73: { uint32_t result=LL_TIM_OC_GetPulseWidthPrescaler(tim); return result; }
    case 74: { LL_TIM_OC_SetPulseWidth(tim, args[0]); return 0; }
    case 75: { uint32_t result=LL_TIM_OC_GetPulseWidth(tim); return result; }
    case 76: { LL_TIM_IC_Config(tim, args[0], args[1]); return 0; }
    case 77: { LL_TIM_IC_SetActiveInput(tim, args[0], args[1]); return 0; }
    case 78: { uint32_t result=LL_TIM_IC_GetActiveInput(tim, args[0]); return result; }
    case 79: { LL_TIM_IC_SetPrescaler(tim, args[0], args[1]); return 0; }
    case 80: { uint32_t result=LL_TIM_IC_GetPrescaler(tim, args[0]); return result; }
    case 81: { LL_TIM_IC_SetFilter(tim, args[0], args[1]); return 0; }
    case 82: { uint32_t result=LL_TIM_IC_GetFilter(tim, args[0]); return result; }
    case 83: { LL_TIM_IC_SetPolarity(tim, args[0], args[1]); return 0; }
    case 84: { uint32_t result=LL_TIM_IC_GetPolarity(tim, args[0]); return result; }
    case 85: { LL_TIM_IC_EnableXORCombination(tim); return 0; }
    case 86: { LL_TIM_IC_DisableXORCombination(tim); return 0; }
    case 87: { uint32_t result=LL_TIM_IC_IsEnabledXORCombination(tim); return result; }
    case 88: { uint32_t result=LL_TIM_IC_GetCaptureCH1(tim); return result; }
    case 89: { uint32_t result=LL_TIM_IC_GetCaptureCH2(tim); return result; }
    case 90: { uint32_t result=LL_TIM_IC_GetCaptureCH3(tim); return result; }
    case 91: { uint32_t result=LL_TIM_IC_GetCaptureCH4(tim); return result; }
    case 92: { LL_TIM_EnableExternalClock(tim); return 0; }
    case 93: { LL_TIM_DisableExternalClock(tim); return 0; }
    case 94: { uint32_t result=LL_TIM_IsEnabledExternalClock(tim); return result; }
    case 95: { LL_TIM_SetClockSource(tim, args[0]); return 0; }
    case 96: { LL_TIM_SetEncoderMode(tim, args[0]); return 0; }
    case 97: { LL_TIM_SetTriggerOutput(tim, args[0]); return 0; }
    case 98: { LL_TIM_SetTriggerOutput2(tim, args[0]); return 0; }
    case 99: { LL_TIM_SetSlaveMode(tim, args[0]); return 0; }
    case 100: { LL_TIM_SetTriggerInput(tim, args[0]); return 0; }
    case 101: { LL_TIM_EnableMasterSlaveMode(tim); return 0; }
    case 102: { LL_TIM_DisableMasterSlaveMode(tim); return 0; }
    case 103: { uint32_t result=LL_TIM_IsEnabledMasterSlaveMode(tim); return result; }
    case 104: { LL_TIM_ConfigETR(tim, args[0], args[1], args[2]); return 0; }
    case 105: { LL_TIM_SetETRSource(tim, args[0]); return 0; }
    case 106: { LL_TIM_EnableSMSPreload(tim); return 0; }
    case 107: { LL_TIM_DisableSMSPreload(tim); return 0; }
    case 108: { uint32_t result=LL_TIM_IsEnabledSMSPreload(tim); return result; }
    case 109: { LL_TIM_SetSMSPreloadSource(tim, args[0]); return 0; }
    case 110: { uint32_t result=LL_TIM_GetSMSPreloadSource(tim); return result; }
    case 111: { LL_TIM_EnableBRK(tim); return 0; }
    case 112: { LL_TIM_DisableBRK(tim); return 0; }
    case 113: { LL_TIM_ConfigBRK(tim, args[0], args[1], args[2]); return 0; }
    case 114: { LL_TIM_DisarmBRK(tim); return 0; }
    case 115: { LL_TIM_EnableBRK2(tim); return 0; }
    case 116: { LL_TIM_DisableBRK2(tim); return 0; }
    case 117: { LL_TIM_ConfigBRK2(tim, args[0], args[1], args[2]); return 0; }
    case 118: { LL_TIM_DisarmBRK2(tim); return 0; }
    case 119: { LL_TIM_SetOffStates(tim, args[0], args[1]); return 0; }
    case 120: { LL_TIM_EnableAutomaticOutput(tim); return 0; }
    case 121: { LL_TIM_DisableAutomaticOutput(tim); return 0; }
    case 122: { uint32_t result=LL_TIM_IsEnabledAutomaticOutput(tim); return result; }
    case 123: { LL_TIM_EnableAllOutputs(tim); return 0; }
    case 124: { LL_TIM_DisableAllOutputs(tim); return 0; }
    case 125: { uint32_t result=LL_TIM_IsEnabledAllOutputs(tim); return result; }
    case 126: { LL_TIM_EnableBreakInputSource(tim, args[0], args[1]); return 0; }
    case 127: { LL_TIM_DisableBreakInputSource(tim, args[0], args[1]); return 0; }
    case 128: { LL_TIM_SetBreakInputSourcePolarity(tim, args[0], args[1], args[2]); return 0; }
    case 129: { LL_TIM_EnableAsymmetricalDeadTime(tim); return 0; }
    case 130: { LL_TIM_DisableAsymmetricalDeadTime(tim); return 0; }
    case 131: { uint32_t result=LL_TIM_IsEnabledAsymmetricalDeadTime(tim); return result; }
    case 132: { LL_TIM_SetFallingDeadTime(tim, args[0]); return 0; }
    case 133: { uint32_t result=LL_TIM_GetFallingDeadTime(tim); return result; }
    case 134: { LL_TIM_EnableDeadTimePreload(tim); return 0; }
    case 135: { LL_TIM_DisableDeadTimePreload(tim); return 0; }
    case 136: { uint32_t result=LL_TIM_IsEnabledDeadTimePreload(tim); return result; }
    case 137: { LL_TIM_ConfigDMABurst(tim, args[0], args[1], args[2]); return 0; }
    case 138: { LL_TIM_EnableEncoderIndex(tim); return 0; }
    case 139: { LL_TIM_DisableEncoderIndex(tim); return 0; }
    case 140: { uint32_t result=LL_TIM_IsEnabledEncoderIndex(tim); return result; }
    case 141: { LL_TIM_SetIndexDirection(tim, args[0]); return 0; }
    case 142: { uint32_t result=LL_TIM_GetIndexDirection(tim); return result; }
    case 143: { LL_TIM_SetIndexblanking(tim, args[0]); return 0; }
    case 144: { uint32_t result=LL_TIM_GetIndexblanking(tim); return result; }
    case 145: { LL_TIM_EnableFirstIndex(tim); return 0; }
    case 146: { LL_TIM_DisableFirstIndex(tim); return 0; }
    case 147: { uint32_t result=LL_TIM_IsEnabledFirstIndex(tim); return result; }
    case 148: { LL_TIM_SetIndexPositionning(tim, args[0]); return 0; }
    case 149: { uint32_t result=LL_TIM_GetIndexPositionning(tim); return result; }
    case 150: { LL_TIM_ConfigIDX(tim, args[0]); return 0; }
    case 151: { LL_TIM_SetRemap(tim, args[0]); return 0; }
    case 152: { LL_TIM_ClearFlag_UPDATE(tim); return 0; }
    case 153: { uint32_t result=LL_TIM_IsActiveFlag_UPDATE(tim); return result; }
    case 154: { LL_TIM_ClearFlag_CC1(tim); return 0; }
    case 155: { uint32_t result=LL_TIM_IsActiveFlag_CC1(tim); return result; }
    case 156: { LL_TIM_ClearFlag_CC2(tim); return 0; }
    case 157: { uint32_t result=LL_TIM_IsActiveFlag_CC2(tim); return result; }
    case 158: { LL_TIM_ClearFlag_CC3(tim); return 0; }
    case 159: { uint32_t result=LL_TIM_IsActiveFlag_CC3(tim); return result; }
    case 160: { LL_TIM_ClearFlag_CC4(tim); return 0; }
    case 161: { uint32_t result=LL_TIM_IsActiveFlag_CC4(tim); return result; }
    case 162: { LL_TIM_ClearFlag_CC5(tim); return 0; }
    case 163: { uint32_t result=LL_TIM_IsActiveFlag_CC5(tim); return result; }
    case 164: { LL_TIM_ClearFlag_CC6(tim); return 0; }
    case 165: { uint32_t result=LL_TIM_IsActiveFlag_CC6(tim); return result; }
    case 166: { LL_TIM_ClearFlag_COM(tim); return 0; }
    case 167: { uint32_t result=LL_TIM_IsActiveFlag_COM(tim); return result; }
    case 168: { LL_TIM_ClearFlag_TRIG(tim); return 0; }
    case 169: { uint32_t result=LL_TIM_IsActiveFlag_TRIG(tim); return result; }
    case 170: { LL_TIM_ClearFlag_BRK(tim); return 0; }
    case 171: { uint32_t result=LL_TIM_IsActiveFlag_BRK(tim); return result; }
    case 172: { LL_TIM_ClearFlag_BRK2(tim); return 0; }
    case 173: { uint32_t result=LL_TIM_IsActiveFlag_BRK2(tim); return result; }
    case 174: { LL_TIM_ClearFlag_CC1OVR(tim); return 0; }
    case 175: { uint32_t result=LL_TIM_IsActiveFlag_CC1OVR(tim); return result; }
    case 176: { LL_TIM_ClearFlag_CC2OVR(tim); return 0; }
    case 177: { uint32_t result=LL_TIM_IsActiveFlag_CC2OVR(tim); return result; }
    case 178: { LL_TIM_ClearFlag_CC3OVR(tim); return 0; }
    case 179: { uint32_t result=LL_TIM_IsActiveFlag_CC3OVR(tim); return result; }
    case 180: { LL_TIM_ClearFlag_CC4OVR(tim); return 0; }
    case 181: { uint32_t result=LL_TIM_IsActiveFlag_CC4OVR(tim); return result; }
    case 182: { LL_TIM_ClearFlag_SYSBRK(tim); return 0; }
    case 183: { uint32_t result=LL_TIM_IsActiveFlag_SYSBRK(tim); return result; }
    case 184: { LL_TIM_ClearFlag_TERR(tim); return 0; }
    case 185: { uint32_t result=LL_TIM_IsActiveFlag_TERR(tim); return result; }
    case 186: { LL_TIM_ClearFlag_IERR(tim); return 0; }
    case 187: { uint32_t result=LL_TIM_IsActiveFlag_IERR(tim); return result; }
    case 188: { LL_TIM_ClearFlag_DIR(tim); return 0; }
    case 189: { uint32_t result=LL_TIM_IsActiveFlag_DIR(tim); return result; }
    case 190: { LL_TIM_ClearFlag_IDX(tim); return 0; }
    case 191: { uint32_t result=LL_TIM_IsActiveFlag_IDX(tim); return result; }
    case 192: { LL_TIM_EnableIT_UPDATE(tim); return 0; }
    case 193: { LL_TIM_DisableIT_UPDATE(tim); return 0; }
    case 194: { uint32_t result=LL_TIM_IsEnabledIT_UPDATE(tim); return result; }
    case 195: { LL_TIM_EnableIT_CC1(tim); return 0; }
    case 196: { LL_TIM_DisableIT_CC1(tim); return 0; }
    case 197: { uint32_t result=LL_TIM_IsEnabledIT_CC1(tim); return result; }
    case 198: { LL_TIM_EnableIT_CC2(tim); return 0; }
    case 199: { LL_TIM_DisableIT_CC2(tim); return 0; }
    case 200: { uint32_t result=LL_TIM_IsEnabledIT_CC2(tim); return result; }
    case 201: { LL_TIM_EnableIT_CC3(tim); return 0; }
    case 202: { LL_TIM_DisableIT_CC3(tim); return 0; }
    case 203: { uint32_t result=LL_TIM_IsEnabledIT_CC3(tim); return result; }
    case 204: { LL_TIM_EnableIT_CC4(tim); return 0; }
    case 205: { LL_TIM_DisableIT_CC4(tim); return 0; }
    case 206: { uint32_t result=LL_TIM_IsEnabledIT_CC4(tim); return result; }
    case 207: { LL_TIM_EnableIT_COM(tim); return 0; }
    case 208: { LL_TIM_DisableIT_COM(tim); return 0; }
    case 209: { uint32_t result=LL_TIM_IsEnabledIT_COM(tim); return result; }
    case 210: { LL_TIM_EnableIT_TRIG(tim); return 0; }
    case 211: { LL_TIM_DisableIT_TRIG(tim); return 0; }
    case 212: { uint32_t result=LL_TIM_IsEnabledIT_TRIG(tim); return result; }
    case 213: { LL_TIM_EnableIT_BRK(tim); return 0; }
    case 214: { LL_TIM_DisableIT_BRK(tim); return 0; }
    case 215: { uint32_t result=LL_TIM_IsEnabledIT_BRK(tim); return result; }
    case 216: { LL_TIM_EnableIT_TERR(tim); return 0; }
    case 217: { LL_TIM_DisableIT_TERR(tim); return 0; }
    case 218: { uint32_t result=LL_TIM_IsEnabledIT_TERR(tim); return result; }
    case 219: { LL_TIM_EnableIT_IERR(tim); return 0; }
    case 220: { LL_TIM_DisableIT_IERR(tim); return 0; }
    case 221: { uint32_t result=LL_TIM_IsEnabledIT_IERR(tim); return result; }
    case 222: { LL_TIM_EnableIT_DIR(tim); return 0; }
    case 223: { LL_TIM_DisableIT_DIR(tim); return 0; }
    case 224: { uint32_t result=LL_TIM_IsEnabledIT_DIR(tim); return result; }
    case 225: { LL_TIM_EnableIT_IDX(tim); return 0; }
    case 226: { LL_TIM_DisableIT_IDX(tim); return 0; }
    case 227: { uint32_t result=LL_TIM_IsEnabledIT_IDX(tim); return result; }
    case 228: { LL_TIM_EnableDMAReq_UPDATE(tim); return 0; }
    case 229: { LL_TIM_DisableDMAReq_UPDATE(tim); return 0; }
    case 230: { uint32_t result=LL_TIM_IsEnabledDMAReq_UPDATE(tim); return result; }
    case 231: { LL_TIM_EnableDMAReq_CC1(tim); return 0; }
    case 232: { LL_TIM_DisableDMAReq_CC1(tim); return 0; }
    case 233: { uint32_t result=LL_TIM_IsEnabledDMAReq_CC1(tim); return result; }
    case 234: { LL_TIM_EnableDMAReq_CC2(tim); return 0; }
    case 235: { LL_TIM_DisableDMAReq_CC2(tim); return 0; }
    case 236: { uint32_t result=LL_TIM_IsEnabledDMAReq_CC2(tim); return result; }
    case 237: { LL_TIM_EnableDMAReq_CC3(tim); return 0; }
    case 238: { LL_TIM_DisableDMAReq_CC3(tim); return 0; }
    case 239: { uint32_t result=LL_TIM_IsEnabledDMAReq_CC3(tim); return result; }
    case 240: { LL_TIM_EnableDMAReq_CC4(tim); return 0; }
    case 241: { LL_TIM_DisableDMAReq_CC4(tim); return 0; }
    case 242: { uint32_t result=LL_TIM_IsEnabledDMAReq_CC4(tim); return result; }
    case 243: { LL_TIM_EnableDMAReq_COM(tim); return 0; }
    case 244: { LL_TIM_DisableDMAReq_COM(tim); return 0; }
    case 245: { uint32_t result=LL_TIM_IsEnabledDMAReq_COM(tim); return result; }
    case 246: { LL_TIM_EnableDMAReq_TRIG(tim); return 0; }
    case 247: { LL_TIM_DisableDMAReq_TRIG(tim); return 0; }
    case 248: { uint32_t result=LL_TIM_IsEnabledDMAReq_TRIG(tim); return result; }
    case 249: { LL_TIM_GenerateEvent_UPDATE(tim); return 0; }
    case 250: { LL_TIM_GenerateEvent_CC1(tim); return 0; }
    case 251: { LL_TIM_GenerateEvent_CC2(tim); return 0; }
    case 252: { LL_TIM_GenerateEvent_CC3(tim); return 0; }
    case 253: { LL_TIM_GenerateEvent_CC4(tim); return 0; }
    case 254: { LL_TIM_GenerateEvent_COM(tim); return 0; }
    case 255: { LL_TIM_GenerateEvent_TRIG(tim); return 0; }
    case 256: { LL_TIM_GenerateEvent_BRK(tim); return 0; }
    case 257: { LL_TIM_GenerateEvent_BRK2(tim); return 0; }
    case 258: { uint32_t result=LL_TIM_DeInit(tim); return result; }
    case 259: { LL_TIM_InitTypeDef v0 = {(uint16_t)args[0], (uint32_t)args[1], (uint32_t)args[2], (uint32_t)args[3], (uint32_t)args[4]}; LL_TIM_StructInit(&v0); s->cells[5000]=v0.Prescaler; s->cells[5001]=v0.CounterMode; s->cells[5002]=v0.Autoreload; s->cells[5003]=v0.ClockDivision; s->cells[5004]=v0.RepetitionCounter; return 0; }
    case 260: { LL_TIM_InitTypeDef v1 = {(uint16_t)args[0], (uint32_t)args[1], (uint32_t)args[2], (uint32_t)args[3], (uint32_t)args[4]}; uint32_t result=LL_TIM_Init(tim, &v1); s->cells[5000]=v1.Prescaler; s->cells[5001]=v1.CounterMode; s->cells[5002]=v1.Autoreload; s->cells[5003]=v1.ClockDivision; s->cells[5004]=v1.RepetitionCounter; return result; }
    case 261: { LL_TIM_OC_InitTypeDef v0 = {(uint32_t)args[0], (uint32_t)args[1], (uint32_t)args[2], (uint32_t)args[3], (uint32_t)args[4], (uint32_t)args[5], (uint32_t)args[6], (uint32_t)args[7]}; LL_TIM_OC_StructInit(&v0); s->cells[5000]=v0.OCMode; s->cells[5001]=v0.OCState; s->cells[5002]=v0.OCNState; s->cells[5003]=v0.CompareValue; s->cells[5004]=v0.OCPolarity; s->cells[5005]=v0.OCNPolarity; s->cells[5006]=v0.OCIdleState; s->cells[5007]=v0.OCNIdleState; return 0; }
    case 262: { LL_TIM_OC_InitTypeDef v2 = {(uint32_t)args[1], (uint32_t)args[2], (uint32_t)args[3], (uint32_t)args[4], (uint32_t)args[5], (uint32_t)args[6], (uint32_t)args[7], (uint32_t)args[8]}; uint32_t result=LL_TIM_OC_Init(tim, args[0], &v2); s->cells[5000]=v2.OCMode; s->cells[5001]=v2.OCState; s->cells[5002]=v2.OCNState; s->cells[5003]=v2.CompareValue; s->cells[5004]=v2.OCPolarity; s->cells[5005]=v2.OCNPolarity; s->cells[5006]=v2.OCIdleState; s->cells[5007]=v2.OCNIdleState; return result; }
    case 263: { LL_TIM_IC_InitTypeDef v0 = {(uint32_t)args[0], (uint32_t)args[1], (uint32_t)args[2], (uint32_t)args[3]}; LL_TIM_IC_StructInit(&v0); s->cells[5000]=v0.ICPolarity; s->cells[5001]=v0.ICActiveInput; s->cells[5002]=v0.ICPrescaler; s->cells[5003]=v0.ICFilter; return 0; }
    case 264: { LL_TIM_IC_InitTypeDef v2 = {(uint32_t)args[1], (uint32_t)args[2], (uint32_t)args[3], (uint32_t)args[4]}; uint32_t result=LL_TIM_IC_Init(tim, args[0], &v2); s->cells[5000]=v2.ICPolarity; s->cells[5001]=v2.ICActiveInput; s->cells[5002]=v2.ICPrescaler; s->cells[5003]=v2.ICFilter; return result; }
    case 265: { LL_TIM_ENCODER_InitTypeDef v0 = {(uint32_t)args[0], (uint32_t)args[1], (uint32_t)args[2], (uint32_t)args[3], (uint32_t)args[4], (uint32_t)args[5], (uint32_t)args[6], (uint32_t)args[7], (uint32_t)args[8]}; LL_TIM_ENCODER_StructInit(&v0); s->cells[5000]=v0.EncoderMode; s->cells[5001]=v0.IC1Polarity; s->cells[5002]=v0.IC1ActiveInput; s->cells[5003]=v0.IC1Prescaler; s->cells[5004]=v0.IC1Filter; s->cells[5005]=v0.IC2Polarity; s->cells[5006]=v0.IC2ActiveInput; s->cells[5007]=v0.IC2Prescaler; s->cells[5008]=v0.IC2Filter; return 0; }
    case 266: { LL_TIM_ENCODER_InitTypeDef v1 = {(uint32_t)args[0], (uint32_t)args[1], (uint32_t)args[2], (uint32_t)args[3], (uint32_t)args[4], (uint32_t)args[5], (uint32_t)args[6], (uint32_t)args[7], (uint32_t)args[8]}; uint32_t result=LL_TIM_ENCODER_Init(tim, &v1); s->cells[5000]=v1.EncoderMode; s->cells[5001]=v1.IC1Polarity; s->cells[5002]=v1.IC1ActiveInput; s->cells[5003]=v1.IC1Prescaler; s->cells[5004]=v1.IC1Filter; s->cells[5005]=v1.IC2Polarity; s->cells[5006]=v1.IC2ActiveInput; s->cells[5007]=v1.IC2Prescaler; s->cells[5008]=v1.IC2Filter; return result; }
    case 267: { LL_TIM_HALLSENSOR_InitTypeDef v0 = {(uint32_t)args[0], (uint32_t)args[1], (uint32_t)args[2], (uint32_t)args[3]}; LL_TIM_HALLSENSOR_StructInit(&v0); s->cells[5000]=v0.IC1Polarity; s->cells[5001]=v0.IC1Prescaler; s->cells[5002]=v0.IC1Filter; s->cells[5003]=v0.CommutationDelay; return 0; }
    case 268: { LL_TIM_HALLSENSOR_InitTypeDef v1 = {(uint32_t)args[0], (uint32_t)args[1], (uint32_t)args[2], (uint32_t)args[3]}; uint32_t result=LL_TIM_HALLSENSOR_Init(tim, &v1); s->cells[5000]=v1.IC1Polarity; s->cells[5001]=v1.IC1Prescaler; s->cells[5002]=v1.IC1Filter; s->cells[5003]=v1.CommutationDelay; return result; }
    case 269: { LL_TIM_BDTR_InitTypeDef v0 = {(uint32_t)args[0], (uint32_t)args[1], (uint32_t)args[2], (uint8_t)args[3], (uint16_t)args[4], (uint32_t)args[5], (uint32_t)args[6], (uint32_t)args[7], (uint32_t)args[8], (uint32_t)args[9], (uint32_t)args[10], (uint32_t)args[11], (uint32_t)args[12]}; LL_TIM_BDTR_StructInit(&v0); s->cells[5000]=v0.OSSRState; s->cells[5001]=v0.OSSIState; s->cells[5002]=v0.LockLevel; s->cells[5003]=v0.DeadTime; s->cells[5004]=v0.BreakState; s->cells[5005]=v0.BreakPolarity; s->cells[5006]=v0.BreakFilter; s->cells[5007]=v0.BreakAFMode; s->cells[5008]=v0.Break2State; s->cells[5009]=v0.Break2Polarity; s->cells[5010]=v0.Break2Filter; s->cells[5011]=v0.Break2AFMode; s->cells[5012]=v0.AutomaticOutput; return 0; }
    case 270: { LL_TIM_BDTR_InitTypeDef v1 = {(uint32_t)args[0], (uint32_t)args[1], (uint32_t)args[2], (uint8_t)args[3], (uint16_t)args[4], (uint32_t)args[5], (uint32_t)args[6], (uint32_t)args[7], (uint32_t)args[8], (uint32_t)args[9], (uint32_t)args[10], (uint32_t)args[11], (uint32_t)args[12]}; uint32_t result=LL_TIM_BDTR_Init(tim, &v1); s->cells[5000]=v1.OSSRState; s->cells[5001]=v1.OSSIState; s->cells[5002]=v1.LockLevel; s->cells[5003]=v1.DeadTime; s->cells[5004]=v1.BreakState; s->cells[5005]=v1.BreakPolarity; s->cells[5006]=v1.BreakFilter; s->cells[5007]=v1.BreakAFMode; s->cells[5008]=v1.Break2State; s->cells[5009]=v1.Break2Polarity; s->cells[5010]=v1.Break2Filter; s->cells[5011]=v1.Break2AFMode; s->cells[5012]=v1.AutomaticOutput; return result; }
    case 271: { LL_LPTIM_Enable(lptim); return 0; }
    case 272: { LL_LPTIM_Disable(lptim); return 0; }
    case 273: { uint32_t result=LL_LPTIM_IsEnabled(lptim); return result; }
    case 274: { LL_LPTIM_StartCounter(lptim, args[0]); return 0; }
    case 275: { LL_LPTIM_EnableResetAfterRead(lptim); return 0; }
    case 276: { LL_LPTIM_DisableResetAfterRead(lptim); return 0; }
    case 277: { uint32_t result=LL_LPTIM_IsEnabledResetAfterRead(lptim); return result; }
    case 278: { LL_LPTIM_ResetCounter(lptim); return 0; }
    case 279: { LL_LPTIM_SetUpdateMode(lptim, args[0]); return 0; }
    case 280: { uint32_t result=LL_LPTIM_GetUpdateMode(lptim); return result; }
    case 281: { LL_LPTIM_SetAutoReload(lptim, args[0]); return 0; }
    case 282: { uint32_t result=LL_LPTIM_GetAutoReload(lptim); return result; }
    case 283: { LL_LPTIM_SetRepetition(lptim, args[0]); return 0; }
    case 284: { uint32_t result=LL_LPTIM_GetRepetition(lptim); return result; }
    case 285: { LL_LPTIM_CC_EnableChannel(lptim, args[0]); return 0; }
    case 286: { LL_LPTIM_CC_DisableChannel(lptim, args[0]); return 0; }
    case 287: { uint32_t result=LL_LPTIM_CC_IsEnabledChannel(lptim, args[0]); return result; }
    case 288: { LL_LPTIM_OC_SetCompareCH1(lptim, args[0]); return 0; }
    case 289: { uint32_t result=LL_LPTIM_OC_GetCompareCH1(lptim); return result; }
    case 290: { LL_LPTIM_OC_SetCompareCH2(lptim, args[0]); return 0; }
    case 291: { uint32_t result=LL_LPTIM_OC_GetCompareCH2(lptim); return result; }
    case 292: { uint32_t result=LL_LPTIM_GetCounter(lptim); return result; }
    case 293: { LL_LPTIM_SetCounterMode(lptim, args[0]); return 0; }
    case 294: { uint32_t result=LL_LPTIM_GetCounterMode(lptim); return result; }
    case 295: { LL_LPTIM_SetWaveform(lptim, args[0]); return 0; }
    case 296: { uint32_t result=LL_LPTIM_GetWaveform(lptim); return result; }
    case 297: { LL_LPTIM_OC_SetPolarity(lptim, args[0], args[1]); return 0; }
    case 298: { uint32_t result=LL_LPTIM_OC_GetPolarity(lptim, args[0]); return result; }
    case 299: { LL_LPTIM_SetPrescaler(lptim, args[0]); return 0; }
    case 300: { uint32_t result=LL_LPTIM_GetPrescaler(lptim); return result; }
    case 301: { LL_LPTIM_SetInput1Src(lptim, args[0]); return 0; }
    case 302: { LL_LPTIM_SetInput2Src(lptim, args[0]); return 0; }
    case 303: { LL_LPTIM_SetRemap(lptim, args[0]); return 0; }
    case 304: { LL_LPTIM_IC_SetPolarity(lptim, args[0], args[1]); return 0; }
    case 305: { uint32_t result=LL_LPTIM_IC_GetPolarity(lptim, args[0]); return result; }
    case 306: { LL_LPTIM_IC_SetFilter(lptim, args[0], args[1]); return 0; }
    case 307: { uint32_t result=LL_LPTIM_IC_GetFilter(lptim, args[0]); return result; }
    case 308: { LL_LPTIM_IC_SetPrescaler(lptim, args[0], args[1]); return 0; }
    case 309: { uint32_t result=LL_LPTIM_IC_GetPrescaler(lptim, args[0]); return result; }
    case 310: { LL_LPTIM_CC_SetChannelMode(lptim, args[0], args[1]); return 0; }
    case 311: { uint32_t result=LL_LPTIM_CC_GetChannelMode(lptim, args[0]); return result; }
    case 312: { uint32_t result=LL_LPTIM_IC_GetCaptureCH1(lptim); return result; }
    case 313: { uint32_t result=LL_LPTIM_IC_GetCaptureCH2(lptim); return result; }
    case 314: { LL_LPTIM_EnableTimeout(lptim); return 0; }
    case 315: { LL_LPTIM_DisableTimeout(lptim); return 0; }
    case 316: { uint32_t result=LL_LPTIM_IsEnabledTimeout(lptim); return result; }
    case 317: { LL_LPTIM_TrigSw(lptim); return 0; }
    case 318: { LL_LPTIM_ConfigTrigger(lptim, args[0], args[1], args[2]); return 0; }
    case 319: { uint32_t result=LL_LPTIM_GetTriggerSource(lptim); return result; }
    case 320: { uint32_t result=LL_LPTIM_GetTriggerFilter(lptim); return result; }
    case 321: { uint32_t result=LL_LPTIM_GetTriggerPolarity(lptim); return result; }
    case 322: { LL_LPTIM_SetClockSource(lptim, args[0]); return 0; }
    case 323: { uint32_t result=LL_LPTIM_GetClockSource(lptim); return result; }
    case 324: { LL_LPTIM_ConfigClock(lptim, args[0], args[1]); return 0; }
    case 325: { uint32_t result=LL_LPTIM_GetClockPolarity(lptim); return result; }
    case 326: { uint32_t result=LL_LPTIM_GetClockFilter(lptim); return result; }
    case 327: { LL_LPTIM_SetEncoderMode(lptim, args[0]); return 0; }
    case 328: { uint32_t result=LL_LPTIM_GetEncoderMode(lptim); return result; }
    case 329: { LL_LPTIM_EnableEncoderMode(lptim); return 0; }
    case 330: { LL_LPTIM_DisableEncoderMode(lptim); return 0; }
    case 331: { uint32_t result=LL_LPTIM_IsEnabledEncoderMode(lptim); return result; }
    case 332: { LL_LPTIM_ClearFlag_CC1(lptim); return 0; }
    case 333: { uint32_t result=LL_LPTIM_IsActiveFlag_CC1(lptim); return result; }
    case 334: { LL_LPTIM_ClearFlag_CC2(lptim); return 0; }
    case 335: { uint32_t result=LL_LPTIM_IsActiveFlag_CC2(lptim); return result; }
    case 336: { LL_LPTIM_ClearFlag_CC1O(lptim); return 0; }
    case 337: { uint32_t result=LL_LPTIM_IsActiveFlag_CC1O(lptim); return result; }
    case 338: { LL_LPTIM_ClearFlag_CC2O(lptim); return 0; }
    case 339: { uint32_t result=LL_LPTIM_IsActiveFlag_CC2O(lptim); return result; }
    case 340: { LL_LPTIM_ClearFlag_ARRM(lptim); return 0; }
    case 341: { uint32_t result=LL_LPTIM_IsActiveFlag_ARRM(lptim); return result; }
    case 342: { LL_LPTIM_ClearFlag_EXTTRIG(lptim); return 0; }
    case 343: { uint32_t result=LL_LPTIM_IsActiveFlag_EXTTRIG(lptim); return result; }
    case 344: { LL_LPTIM_ClearFlag_CMP1OK(lptim); return 0; }
    case 345: { uint32_t result=LL_LPTIM_IsActiveFlag_CMP1OK(lptim); return result; }
    case 346: { LL_LPTIM_ClearFlag_CMP2OK(lptim); return 0; }
    case 347: { uint32_t result=LL_LPTIM_IsActiveFlag_CMP2OK(lptim); return result; }
    case 348: { LL_LPTIM_ClearFlag_DIEROK(lptim); return 0; }
    case 349: { uint32_t result=LL_LPTIM_IsActiveFlag_DIEROK(lptim); return result; }
    case 350: { LL_LPTIM_ClearFlag_ARROK(lptim); return 0; }
    case 351: { uint32_t result=LL_LPTIM_IsActiveFlag_ARROK(lptim); return result; }
    case 352: { LL_LPTIM_ClearFlag_UP(lptim); return 0; }
    case 353: { uint32_t result=LL_LPTIM_IsActiveFlag_UP(lptim); return result; }
    case 354: { LL_LPTIM_ClearFlag_DOWN(lptim); return 0; }
    case 355: { uint32_t result=LL_LPTIM_IsActiveFlag_DOWN(lptim); return result; }
    case 356: { LL_LPTIM_ClearFlag_REPOK(lptim); return 0; }
    case 357: { uint32_t result=LL_LPTIM_IsActiveFlag_REPOK(lptim); return result; }
    case 358: { LL_LPTIM_ClearFlag_UE(lptim); return 0; }
    case 359: { uint32_t result=LL_LPTIM_IsActiveFlag_UE(lptim); return result; }
    case 360: { LL_LPTIM_EnableIT_CC1(lptim); return 0; }
    case 361: { LL_LPTIM_DisableIT_CC1(lptim); return 0; }
    case 362: { uint32_t result=LL_LPTIM_IsEnabledIT_CC1(lptim); return result; }
    case 363: { LL_LPTIM_EnableIT_CC2(lptim); return 0; }
    case 364: { LL_LPTIM_DisableIT_CC2(lptim); return 0; }
    case 365: { uint32_t result=LL_LPTIM_IsEnabledIT_CC2(lptim); return result; }
    case 366: { LL_LPTIM_EnableIT_CC1O(lptim); return 0; }
    case 367: { LL_LPTIM_DisableIT_CC1O(lptim); return 0; }
    case 368: { uint32_t result=LL_LPTIM_IsEnabledIT_CC1O(lptim); return result; }
    case 369: { LL_LPTIM_EnableIT_CC2O(lptim); return 0; }
    case 370: { LL_LPTIM_DisableIT_CC2O(lptim); return 0; }
    case 371: { uint32_t result=LL_LPTIM_IsEnabledIT_CC2O(lptim); return result; }
    case 372: { LL_LPTIM_EnableIT_ARRM(lptim); return 0; }
    case 373: { LL_LPTIM_DisableIT_ARRM(lptim); return 0; }
    case 374: { uint32_t result=LL_LPTIM_IsEnabledIT_ARRM(lptim); return result; }
    case 375: { LL_LPTIM_EnableIT_EXTTRIG(lptim); return 0; }
    case 376: { LL_LPTIM_DisableIT_EXTTRIG(lptim); return 0; }
    case 377: { uint32_t result=LL_LPTIM_IsEnabledIT_EXTTRIG(lptim); return result; }
    case 378: { LL_LPTIM_EnableIT_CMP1OK(lptim); return 0; }
    case 379: { LL_LPTIM_DisableIT_CMP1OK(lptim); return 0; }
    case 380: { uint32_t result=LL_LPTIM_IsEnabledIT_CMP1OK(lptim); return result; }
    case 381: { LL_LPTIM_EnableIT_CMP2OK(lptim); return 0; }
    case 382: { LL_LPTIM_DisableIT_CMP2OK(lptim); return 0; }
    case 383: { uint32_t result=LL_LPTIM_IsEnabledIT_CMP2OK(lptim); return result; }
    case 384: { LL_LPTIM_EnableIT_ARROK(lptim); return 0; }
    case 385: { LL_LPTIM_DisableIT_ARROK(lptim); return 0; }
    case 386: { uint32_t result=LL_LPTIM_IsEnabledIT_ARROK(lptim); return result; }
    case 387: { LL_LPTIM_EnableIT_UP(lptim); return 0; }
    case 388: { LL_LPTIM_DisableIT_UP(lptim); return 0; }
    case 389: { uint32_t result=LL_LPTIM_IsEnabledIT_UP(lptim); return result; }
    case 390: { LL_LPTIM_EnableIT_DOWN(lptim); return 0; }
    case 391: { LL_LPTIM_DisableIT_DOWN(lptim); return 0; }
    case 392: { uint32_t result=LL_LPTIM_IsEnabledIT_DOWN(lptim); return result; }
    case 393: { LL_LPTIM_EnableIT_REPOK(lptim); return 0; }
    case 394: { LL_LPTIM_DisableIT_REPOK(lptim); return 0; }
    case 395: { uint32_t result=LL_LPTIM_IsEnabledIT_REPOK(lptim); return result; }
    case 396: { LL_LPTIM_EnableIT_UE(lptim); return 0; }
    case 397: { LL_LPTIM_DisableIT_UE(lptim); return 0; }
    case 398: { uint32_t result=LL_LPTIM_IsEnabledIT_UE(lptim); return result; }
    case 399: { LL_LPTIM_EnableDMAReq_UPDATE(lptim); return 0; }
    case 400: { LL_LPTIM_DisableDMAReq_UPDATE(lptim); return 0; }
    case 401: { uint32_t result=LL_LPTIM_IsEnabledDMAReq_UPDATE(lptim); return result; }
    case 402: { LL_LPTIM_EnableDMAReq_CC1(lptim); return 0; }
    case 403: { LL_LPTIM_DisableDMAReq_CC1(lptim); return 0; }
    case 404: { uint32_t result=LL_LPTIM_IsEnabledDMAReq_CC1(lptim); return result; }
    case 405: { LL_LPTIM_EnableDMAReq_CC2(lptim); return 0; }
    case 406: { LL_LPTIM_DisableDMAReq_CC2(lptim); return 0; }
    case 407: { uint32_t result=LL_LPTIM_IsEnabledDMAReq_CC2(lptim); return result; }
    case 408: { uint32_t result=LL_LPTIM_DeInit(lptim); return result; }
    case 409: { LL_LPTIM_InitTypeDef v0 = {(uint32_t)args[0], (uint32_t)args[1], (uint32_t)args[2]}; LL_LPTIM_StructInit(&v0); s->cells[5000]=v0.ClockSource; s->cells[5001]=v0.Prescaler; s->cells[5002]=v0.Waveform; return 0; }
    case 410: { LL_LPTIM_InitTypeDef v1 = {(uint32_t)args[0], (uint32_t)args[1], (uint32_t)args[2]}; uint32_t result=LL_LPTIM_Init(lptim, &v1); s->cells[5000]=v1.ClockSource; s->cells[5001]=v1.Prescaler; s->cells[5002]=v1.Waveform; return result; }
    case 411: { LL_LPTIM_ClearFLAG_CC1(lptim);return 0; }
    case 412: { LL_LPTIM_ClearFLAG_CC2(lptim);return 0; }
    case 413: { LL_LPTIM_ClearFLAG_CC1O(lptim);return 0; }
    case 414: { LL_LPTIM_ClearFLAG_CC2O(lptim);return 0; }
    case 415: { LL_LPTIM_ClearFLAG_ARRM(lptim);return 0; }
    case 416: { LL_TIM_ReArmBRK(tim);return 0; }
    case 417: { LL_TIM_ReArmBRK2(tim);return 0; }
    case 418: { LL_TIM_WriteReg(tim,CR1,args[0]);return LL_TIM_ReadReg(tim,CR1); }
    case 419: { LL_LPTIM_WriteReg(lptim,CFGR,args[0]);return LL_LPTIM_ReadReg(lptim,CFGR); }
    case 420: { return __LL_TIM_GETFLAG_UIFCPY(args[0]); }
    case 421: { return __LL_TIM_CALC_DEADTIME(args[0], args[1], args[2]); }
    case 422: { return __LL_TIM_CALC_PSC(args[0], args[1]); }
    case 423: { return __LL_TIM_CALC_ARR(args[0], args[1], args[2]); }
    case 424: { return __LL_TIM_CALC_ARR_DITHER(args[0], args[1], args[2]); }
    case 425: { return __LL_TIM_CALC_DELAY(args[0], args[1], args[2]); }
    case 426: { return __LL_TIM_CALC_DELAY_DITHER(args[0], args[1], args[2]); }
    case 427: { return __LL_TIM_CALC_PULSE(args[0], args[1], args[2], args[3]); }
    case 428: { return __LL_TIM_CALC_PULSE_DITHER(args[0], args[1], args[2], args[3]); }
    case 429: { return __LL_TIM_GET_ICPSC_RATIO(args[0]); }
    case 430: { return LL_LPTIM_IC_GET_OFFSET(args[0], args[1]); }
    default:abort();
  }
}
uint32_t CL52_Constant(uint32_t index) {
  switch(index) {
    case 0:return LL_TIM_SR_UIF;
    case 1:return LL_TIM_SR_CC1IF;
    case 2:return LL_TIM_SR_CC2IF;
    case 3:return LL_TIM_SR_CC3IF;
    case 4:return LL_TIM_SR_CC4IF;
    case 5:return LL_TIM_SR_CC5IF;
    case 6:return LL_TIM_SR_CC6IF;
    case 7:return LL_TIM_SR_COMIF;
    case 8:return LL_TIM_SR_TIF;
    case 9:return LL_TIM_SR_BIF;
    case 10:return LL_TIM_SR_B2IF;
    case 11:return LL_TIM_SR_CC1OF;
    case 12:return LL_TIM_SR_CC2OF;
    case 13:return LL_TIM_SR_CC3OF;
    case 14:return LL_TIM_SR_CC4OF;
    case 15:return LL_TIM_SR_SBIF;
    case 16:return LL_TIM_SR_IDXF;
    case 17:return LL_TIM_SR_DIRF;
    case 18:return LL_TIM_SR_IERRF;
    case 19:return LL_TIM_SR_TERRF;
    case 20:return LL_TIM_BREAK_DISABLE;
    case 21:return LL_TIM_BREAK_ENABLE;
    case 22:return LL_TIM_BREAK2_DISABLE;
    case 23:return LL_TIM_BREAK2_ENABLE;
    case 24:return LL_TIM_AUTOMATICOUTPUT_DISABLE;
    case 25:return LL_TIM_AUTOMATICOUTPUT_ENABLE;
    case 26:return LL_TIM_DIER_UIE;
    case 27:return LL_TIM_DIER_CC1IE;
    case 28:return LL_TIM_DIER_CC2IE;
    case 29:return LL_TIM_DIER_CC3IE;
    case 30:return LL_TIM_DIER_CC4IE;
    case 31:return LL_TIM_DIER_COMIE;
    case 32:return LL_TIM_DIER_TIE;
    case 33:return LL_TIM_DIER_BIE;
    case 34:return LL_TIM_DIER_IDXIE;
    case 35:return LL_TIM_DIER_DIRIE;
    case 36:return LL_TIM_DIER_IERRIE;
    case 37:return LL_TIM_DIER_TERRIE;
    case 38:return LL_TIM_UPDATESOURCE_REGULAR;
    case 39:return LL_TIM_UPDATESOURCE_COUNTER;
    case 40:return LL_TIM_ONEPULSEMODE_SINGLE;
    case 41:return LL_TIM_ONEPULSEMODE_REPETITIVE;
    case 42:return LL_TIM_COUNTERMODE_UP;
    case 43:return LL_TIM_COUNTERMODE_DOWN;
    case 44:return LL_TIM_COUNTERMODE_CENTER_DOWN;
    case 45:return LL_TIM_COUNTERMODE_CENTER_UP;
    case 46:return LL_TIM_COUNTERMODE_CENTER_UP_DOWN;
    case 47:return LL_TIM_CLOCKDIVISION_DIV1;
    case 48:return LL_TIM_CLOCKDIVISION_DIV2;
    case 49:return LL_TIM_CLOCKDIVISION_DIV4;
    case 50:return LL_TIM_COUNTERDIRECTION_UP;
    case 51:return LL_TIM_COUNTERDIRECTION_DOWN;
    case 52:return LL_TIM_CCUPDATESOURCE_COMG_ONLY;
    case 53:return LL_TIM_CCUPDATESOURCE_COMG_AND_TRGI;
    case 54:return LL_TIM_CCDMAREQUEST_CC;
    case 55:return LL_TIM_CCDMAREQUEST_UPDATE;
    case 56:return LL_TIM_LOCKLEVEL_OFF;
    case 57:return LL_TIM_LOCKLEVEL_1;
    case 58:return LL_TIM_LOCKLEVEL_2;
    case 59:return LL_TIM_LOCKLEVEL_3;
    case 60:return LL_TIM_CHANNEL_CH1;
    case 61:return LL_TIM_CHANNEL_CH1N;
    case 62:return LL_TIM_CHANNEL_CH2;
    case 63:return LL_TIM_CHANNEL_CH2N;
    case 64:return LL_TIM_CHANNEL_CH3;
    case 65:return LL_TIM_CHANNEL_CH3N;
    case 66:return LL_TIM_CHANNEL_CH4;
    case 67:return LL_TIM_CHANNEL_CH4N;
    case 68:return LL_TIM_CHANNEL_CH5;
    case 69:return LL_TIM_CHANNEL_CH6;
    case 70:return LL_TIM_OCSTATE_DISABLE;
    case 71:return LL_TIM_OCSTATE_ENABLE;
    case 72:return LL_TIM_OCMODE_ASSYMETRIC_PWM1;
    case 73:return LL_TIM_OCMODE_ASSYMETRIC_PWM2;
    case 74:return LL_TIM_OCMODE_FROZEN;
    case 75:return LL_TIM_OCMODE_ACTIVE;
    case 76:return LL_TIM_OCMODE_INACTIVE;
    case 77:return LL_TIM_OCMODE_TOGGLE;
    case 78:return LL_TIM_OCMODE_FORCED_INACTIVE;
    case 79:return LL_TIM_OCMODE_FORCED_ACTIVE;
    case 80:return LL_TIM_OCMODE_PWM1;
    case 81:return LL_TIM_OCMODE_PWM2;
    case 82:return LL_TIM_OCMODE_RETRIG_OPM1;
    case 83:return LL_TIM_OCMODE_RETRIG_OPM2;
    case 84:return LL_TIM_OCMODE_COMBINED_PWM1;
    case 85:return LL_TIM_OCMODE_COMBINED_PWM2;
    case 86:return LL_TIM_OCMODE_ASYMMETRIC_PWM1;
    case 87:return LL_TIM_OCMODE_ASYMMETRIC_PWM2;
    case 88:return LL_TIM_OCMODE_PULSE_ON_COMPARE;
    case 89:return LL_TIM_OCMODE_DIRECTION_OUTPUT;
    case 90:return LL_TIM_OCPOLARITY_HIGH;
    case 91:return LL_TIM_OCPOLARITY_LOW;
    case 92:return LL_TIM_OCIDLESTATE_LOW;
    case 93:return LL_TIM_OCIDLESTATE_HIGH;
    case 94:return LL_TIM_GROUPCH5_NONE;
    case 95:return LL_TIM_GROUPCH5_OC1REFC;
    case 96:return LL_TIM_GROUPCH5_OC2REFC;
    case 97:return LL_TIM_GROUPCH5_OC3REFC;
    case 98:return LL_TIM_ACTIVEINPUT_DIRECTTI;
    case 99:return LL_TIM_ACTIVEINPUT_INDIRECTTI;
    case 100:return LL_TIM_ACTIVEINPUT_TRC;
    case 101:return LL_TIM_ICPSC_DIV1;
    case 102:return LL_TIM_ICPSC_DIV2;
    case 103:return LL_TIM_ICPSC_DIV4;
    case 104:return LL_TIM_ICPSC_DIV8;
    case 105:return LL_TIM_IC_FILTER_FDIV1;
    case 106:return LL_TIM_IC_FILTER_FDIV1_N2;
    case 107:return LL_TIM_IC_FILTER_FDIV1_N4;
    case 108:return LL_TIM_IC_FILTER_FDIV1_N8;
    case 109:return LL_TIM_IC_FILTER_FDIV2_N6;
    case 110:return LL_TIM_IC_FILTER_FDIV2_N8;
    case 111:return LL_TIM_IC_FILTER_FDIV4_N6;
    case 112:return LL_TIM_IC_FILTER_FDIV4_N8;
    case 113:return LL_TIM_IC_FILTER_FDIV8_N6;
    case 114:return LL_TIM_IC_FILTER_FDIV8_N8;
    case 115:return LL_TIM_IC_FILTER_FDIV16_N5;
    case 116:return LL_TIM_IC_FILTER_FDIV16_N6;
    case 117:return LL_TIM_IC_FILTER_FDIV16_N8;
    case 118:return LL_TIM_IC_FILTER_FDIV32_N5;
    case 119:return LL_TIM_IC_FILTER_FDIV32_N6;
    case 120:return LL_TIM_IC_FILTER_FDIV32_N8;
    case 121:return LL_TIM_IC_POLARITY_RISING;
    case 122:return LL_TIM_IC_POLARITY_FALLING;
    case 123:return LL_TIM_IC_POLARITY_BOTHEDGE;
    case 124:return LL_TIM_CLOCKSOURCE_INTERNAL;
    case 125:return LL_TIM_CLOCKSOURCE_EXT_MODE1;
    case 126:return LL_TIM_CLOCKSOURCE_EXT_MODE2;
    case 127:return LL_TIM_ENCODERMODE_X2_TI1;
    case 128:return LL_TIM_ENCODERMODE_X2_TI2;
    case 129:return LL_TIM_ENCODERMODE_X4_TI12;
    case 130:return LL_TIM_ENCODERMODE_CLOCKPLUSDIRECTION_X2;
    case 131:return LL_TIM_ENCODERMODE_CLOCKPLUSDIRECTION_X1;
    case 132:return LL_TIM_ENCODERMODE_DIRECTIONALCLOCK_X2;
    case 133:return LL_TIM_ENCODERMODE_DIRECTIONALCLOCK_X1_TI12;
    case 134:return LL_TIM_ENCODERMODE_X1_TI1;
    case 135:return LL_TIM_ENCODERMODE_X1_TI2;
    case 136:return LL_TIM_TRGO_RESET;
    case 137:return LL_TIM_TRGO_ENABLE;
    case 138:return LL_TIM_TRGO_UPDATE;
    case 139:return LL_TIM_TRGO_CC1IF;
    case 140:return LL_TIM_TRGO_OC1REF;
    case 141:return LL_TIM_TRGO_OC2REF;
    case 142:return LL_TIM_TRGO_OC3REF;
    case 143:return LL_TIM_TRGO_OC4REF;
    case 144:return LL_TIM_TRGO_ENCODERCLK;
    case 145:return LL_TIM_TRGO2_RESET;
    case 146:return LL_TIM_TRGO2_ENABLE;
    case 147:return LL_TIM_TRGO2_UPDATE;
    case 148:return LL_TIM_TRGO2_CC1F;
    case 149:return LL_TIM_TRGO2_OC1;
    case 150:return LL_TIM_TRGO2_OC2;
    case 151:return LL_TIM_TRGO2_OC3;
    case 152:return LL_TIM_TRGO2_OC4;
    case 153:return LL_TIM_TRGO2_OC5;
    case 154:return LL_TIM_TRGO2_OC6;
    case 155:return LL_TIM_TRGO2_OC4_RISINGFALLING;
    case 156:return LL_TIM_TRGO2_OC6_RISINGFALLING;
    case 157:return LL_TIM_TRGO2_OC4_RISING_OC6_RISING;
    case 158:return LL_TIM_TRGO2_OC4_RISING_OC6_FALLING;
    case 159:return LL_TIM_TRGO2_OC5_RISING_OC6_RISING;
    case 160:return LL_TIM_TRGO2_OC5_RISING_OC6_FALLING;
    case 161:return LL_TIM_SLAVEMODE_DISABLED;
    case 162:return LL_TIM_SLAVEMODE_RESET;
    case 163:return LL_TIM_SLAVEMODE_GATED;
    case 164:return LL_TIM_SLAVEMODE_TRIGGER;
    case 165:return LL_TIM_SLAVEMODE_COMBINED_RESETTRIGGER;
    case 166:return LL_TIM_SLAVEMODE_COMBINED_GATEDRESET;
    case 167:return LL_TIM_SMSPS_TIMUPDATE;
    case 168:return LL_TIM_SMSPS_INDEX;
    case 169:return LL_TIM_TS_ITR0;
    case 170:return LL_TIM_TS_ITR1;
    case 171:return LL_TIM_TS_ITR2;
    case 172:return LL_TIM_TS_ITR3;
    case 173:return LL_TIM_TS_ITR4;
    case 174:return LL_TIM_TS_ITR5;
    case 175:return LL_TIM_TS_ITR6;
    case 176:return LL_TIM_TS_ITR7;
    case 177:return LL_TIM_TS_ITR8;
    case 178:return LL_TIM_TS_ITR9;
    case 179:return LL_TIM_TS_ITR10;
    case 180:return LL_TIM_TS_ITR11;
    case 181:return LL_TIM_TS_ITR12;
    case 182:return LL_TIM_TS_ITR13;
    case 183:return LL_TIM_TS_ITR14;
    case 184:return LL_TIM_TS_TI1F_ED;
    case 185:return LL_TIM_TS_TI1FP1;
    case 186:return LL_TIM_TS_TI2FP2;
    case 187:return LL_TIM_TS_ETRF;
    case 188:return LL_TIM_ETR_POLARITY_NONINVERTED;
    case 189:return LL_TIM_ETR_POLARITY_INVERTED;
    case 190:return LL_TIM_ETR_PRESCALER_DIV1;
    case 191:return LL_TIM_ETR_PRESCALER_DIV2;
    case 192:return LL_TIM_ETR_PRESCALER_DIV4;
    case 193:return LL_TIM_ETR_PRESCALER_DIV8;
    case 194:return LL_TIM_ETR_FILTER_FDIV1;
    case 195:return LL_TIM_ETR_FILTER_FDIV1_N2;
    case 196:return LL_TIM_ETR_FILTER_FDIV1_N4;
    case 197:return LL_TIM_ETR_FILTER_FDIV1_N8;
    case 198:return LL_TIM_ETR_FILTER_FDIV2_N6;
    case 199:return LL_TIM_ETR_FILTER_FDIV2_N8;
    case 200:return LL_TIM_ETR_FILTER_FDIV4_N6;
    case 201:return LL_TIM_ETR_FILTER_FDIV4_N8;
    case 202:return LL_TIM_ETR_FILTER_FDIV8_N6;
    case 203:return LL_TIM_ETR_FILTER_FDIV8_N8;
    case 204:return LL_TIM_ETR_FILTER_FDIV16_N5;
    case 205:return LL_TIM_ETR_FILTER_FDIV16_N6;
    case 206:return LL_TIM_ETR_FILTER_FDIV16_N8;
    case 207:return LL_TIM_ETR_FILTER_FDIV32_N5;
    case 208:return LL_TIM_ETR_FILTER_FDIV32_N6;
    case 209:return LL_TIM_ETR_FILTER_FDIV32_N8;
    case 210:return LL_TIM_TIM1_ETRSOURCE_GPIO;
    case 211:return LL_TIM_TIM1_ETRSOURCE_ADC1_AWD1;
    case 212:return LL_TIM_TIM1_ETRSOURCE_ADC1_AWD2;
    case 213:return LL_TIM_TIM1_ETRSOURCE_ADC1_AWD3;
    case 214:return LL_TIM_TIM1_ETRSOURCE_ADC2_AWD1;
    case 215:return LL_TIM_TIM1_ETRSOURCE_ADC2_AWD2;
    case 216:return LL_TIM_TIM1_ETRSOURCE_ADC2_AWD3;
    case 217:return LL_TIM_TIM2_ETRSOURCE_GPIO;
    case 218:return LL_TIM_TIM2_ETRSOURCE_DCMIPP_HSYNC;
    case 219:return LL_TIM_TIM2_ETRSOURCE_LTDC_HSYNC;
    case 220:return LL_TIM_TIM2_ETRSOURCE_SAI1_FSA;
    case 221:return LL_TIM_TIM2_ETRSOURCE_SAI1_FSB;
    case 222:return LL_TIM_TIM2_ETRSOURCE_GFXTIM_TE;
    case 223:return LL_TIM_TIM2_ETRSOURCE_DCMIPP_VSYNC;
    case 224:return LL_TIM_TIM2_ETRSOURCE_LTDC_VSYNC;
    case 225:return LL_TIM_TIM2_ETRSOURCE_TIM3_ETR;
    case 226:return LL_TIM_TIM2_ETRSOURCE_TIM4_ETR;
    case 227:return LL_TIM_TIM2_ETRSOURCE_TIM5_ETR;
    case 228:return LL_TIM_TIM2_ETRSOURCE_ETH_PPS;
    case 229:return LL_TIM_TIM3_ETRSOURCE_GPIO;
    case 230:return LL_TIM_TIM3_ETRSOURCE_DCMIPP_HSYNC;
    case 231:return LL_TIM_TIM3_ETRSOURCE_LTDC_HSYNC;
    case 232:return LL_TIM_TIM3_ETRSOURCE_GFXTIM_TE;
    case 233:return LL_TIM_TIM3_ETRSOURCE_DCMIPP_VSYNC;
    case 234:return LL_TIM_TIM3_ETRSOURCE_LTDC_VSYNC;
    case 235:return LL_TIM_TIM3_ETRSOURCE_TIM2_ETR;
    case 236:return LL_TIM_TIM3_ETRSOURCE_TIM4_ETR;
    case 237:return LL_TIM_TIM3_ETRSOURCE_TIM5_ETR;
    case 238:return LL_TIM_TIM3_ETRSOURCE_ETH_PPS;
    case 239:return LL_TIM_TIM4_ETRSOURCE_GPIO;
    case 240:return LL_TIM_TIM4_ETRSOURCE_DCMIPP_HSYNC;
    case 241:return LL_TIM_TIM4_ETRSOURCE_LTDC_HSYNC;
    case 242:return LL_TIM_TIM4_ETRSOURCE_GFXTIM_TE;
    case 243:return LL_TIM_TIM4_ETRSOURCE_DCMIPP_VSYNC;
    case 244:return LL_TIM_TIM4_ETRSOURCE_LTDC_VSYNC;
    case 245:return LL_TIM_TIM4_ETRSOURCE_TIM2_ETR;
    case 246:return LL_TIM_TIM4_ETRSOURCE_TIM3_ETR;
    case 247:return LL_TIM_TIM4_ETRSOURCE_TIM5_ETR;
    case 248:return LL_TIM_TIM5_ETRSOURCE_GPIO;
    case 249:return LL_TIM_TIM5_ETRSOURCE_SAI2_FSA;
    case 250:return LL_TIM_TIM5_ETRSOURCE_SAI2_FSB;
    case 251:return LL_TIM_TIM5_ETRSOURCE_DCMIPP_HSYNC;
    case 252:return LL_TIM_TIM5_ETRSOURCE_LTDC_HSYNC;
    case 253:return LL_TIM_TIM5_ETRSOURCE_GFXTIM_TE;
    case 254:return LL_TIM_TIM5_ETRSOURCE_DCMIPP_VSYNC;
    case 255:return LL_TIM_TIM5_ETRSOURCE_LTDC_VSYNC;
    case 256:return LL_TIM_TIM5_ETRSOURCE_TIM2_ETR;
    case 257:return LL_TIM_TIM5_ETRSOURCE_TIM3_ETR;
    case 258:return LL_TIM_TIM5_ETRSOURCE_TIM4_ETR;
    case 259:return LL_TIM_BREAK_POLARITY_LOW;
    case 260:return LL_TIM_BREAK_POLARITY_HIGH;
    case 261:return LL_TIM_BREAK_FILTER_FDIV1;
    case 262:return LL_TIM_BREAK_FILTER_FDIV1_N2;
    case 263:return LL_TIM_BREAK_FILTER_FDIV1_N4;
    case 264:return LL_TIM_BREAK_FILTER_FDIV1_N8;
    case 265:return LL_TIM_BREAK_FILTER_FDIV2_N6;
    case 266:return LL_TIM_BREAK_FILTER_FDIV2_N8;
    case 267:return LL_TIM_BREAK_FILTER_FDIV4_N6;
    case 268:return LL_TIM_BREAK_FILTER_FDIV4_N8;
    case 269:return LL_TIM_BREAK_FILTER_FDIV8_N6;
    case 270:return LL_TIM_BREAK_FILTER_FDIV8_N8;
    case 271:return LL_TIM_BREAK_FILTER_FDIV16_N5;
    case 272:return LL_TIM_BREAK_FILTER_FDIV16_N6;
    case 273:return LL_TIM_BREAK_FILTER_FDIV16_N8;
    case 274:return LL_TIM_BREAK_FILTER_FDIV32_N5;
    case 275:return LL_TIM_BREAK_FILTER_FDIV32_N6;
    case 276:return LL_TIM_BREAK_FILTER_FDIV32_N8;
    case 277:return LL_TIM_BREAK2_POLARITY_LOW;
    case 278:return LL_TIM_BREAK2_POLARITY_HIGH;
    case 279:return LL_TIM_BREAK2_FILTER_FDIV1;
    case 280:return LL_TIM_BREAK2_FILTER_FDIV1_N2;
    case 281:return LL_TIM_BREAK2_FILTER_FDIV1_N4;
    case 282:return LL_TIM_BREAK2_FILTER_FDIV1_N8;
    case 283:return LL_TIM_BREAK2_FILTER_FDIV2_N6;
    case 284:return LL_TIM_BREAK2_FILTER_FDIV2_N8;
    case 285:return LL_TIM_BREAK2_FILTER_FDIV4_N6;
    case 286:return LL_TIM_BREAK2_FILTER_FDIV4_N8;
    case 287:return LL_TIM_BREAK2_FILTER_FDIV8_N6;
    case 288:return LL_TIM_BREAK2_FILTER_FDIV8_N8;
    case 289:return LL_TIM_BREAK2_FILTER_FDIV16_N5;
    case 290:return LL_TIM_BREAK2_FILTER_FDIV16_N6;
    case 291:return LL_TIM_BREAK2_FILTER_FDIV16_N8;
    case 292:return LL_TIM_BREAK2_FILTER_FDIV32_N5;
    case 293:return LL_TIM_BREAK2_FILTER_FDIV32_N6;
    case 294:return LL_TIM_BREAK2_FILTER_FDIV32_N8;
    case 295:return LL_TIM_OSSI_DISABLE;
    case 296:return LL_TIM_OSSI_ENABLE;
    case 297:return LL_TIM_OSSR_DISABLE;
    case 298:return LL_TIM_OSSR_ENABLE;
    case 299:return LL_TIM_BREAK_INPUT_BKIN;
    case 300:return LL_TIM_BREAK_INPUT_BKIN2;
    case 301:return LL_TIM_BKIN_SOURCE_BKIN;
    case 302:return LL_TIM_BKIN_POLARITY_LOW;
    case 303:return LL_TIM_BKIN_POLARITY_HIGH;
    case 304:return LL_TIM_BREAK_AFMODE_INPUT;
    case 305:return LL_TIM_BREAK_AFMODE_BIDIRECTIONAL;
    case 306:return LL_TIM_BREAK2_AFMODE_INPUT;
    case 307:return LL_TIM_BREAK2_AFMODE_BIDIRECTIONAL;
    case 308:return LL_TIM_DMABURST_BASEADDR_CR1;
    case 309:return LL_TIM_DMABURST_BASEADDR_CR2;
    case 310:return LL_TIM_DMABURST_BASEADDR_SMCR;
    case 311:return LL_TIM_DMABURST_BASEADDR_DIER;
    case 312:return LL_TIM_DMABURST_BASEADDR_SR;
    case 313:return LL_TIM_DMABURST_BASEADDR_EGR;
    case 314:return LL_TIM_DMABURST_BASEADDR_CCMR1;
    case 315:return LL_TIM_DMABURST_BASEADDR_CCMR2;
    case 316:return LL_TIM_DMABURST_BASEADDR_CCER;
    case 317:return LL_TIM_DMABURST_BASEADDR_CNT;
    case 318:return LL_TIM_DMABURST_BASEADDR_PSC;
    case 319:return LL_TIM_DMABURST_BASEADDR_ARR;
    case 320:return LL_TIM_DMABURST_BASEADDR_RCR;
    case 321:return LL_TIM_DMABURST_BASEADDR_CCR1;
    case 322:return LL_TIM_DMABURST_BASEADDR_CCR2;
    case 323:return LL_TIM_DMABURST_BASEADDR_CCR3;
    case 324:return LL_TIM_DMABURST_BASEADDR_CCR4;
    case 325:return LL_TIM_DMABURST_BASEADDR_BDTR;
    case 326:return LL_TIM_DMABURST_BASEADDR_CCR5;
    case 327:return LL_TIM_DMABURST_BASEADDR_CCR6;
    case 328:return LL_TIM_DMABURST_BASEADDR_CCMR3;
    case 329:return LL_TIM_DMABURST_BASEADDR_DTR2;
    case 330:return LL_TIM_DMABURST_BASEADDR_ECR;
    case 331:return LL_TIM_DMABURST_BASEADDR_TISEL;
    case 332:return LL_TIM_DMABURST_BASEADDR_AF1;
    case 333:return LL_TIM_DMABURST_BASEADDR_AF2;
    case 334:return LL_TIM_DMABURST_LENGTH_1TRANSFER;
    case 335:return LL_TIM_DMABURST_LENGTH_2TRANSFERS;
    case 336:return LL_TIM_DMABURST_LENGTH_3TRANSFERS;
    case 337:return LL_TIM_DMABURST_LENGTH_4TRANSFERS;
    case 338:return LL_TIM_DMABURST_LENGTH_5TRANSFERS;
    case 339:return LL_TIM_DMABURST_LENGTH_6TRANSFERS;
    case 340:return LL_TIM_DMABURST_LENGTH_7TRANSFERS;
    case 341:return LL_TIM_DMABURST_LENGTH_8TRANSFERS;
    case 342:return LL_TIM_DMABURST_LENGTH_9TRANSFERS;
    case 343:return LL_TIM_DMABURST_LENGTH_10TRANSFERS;
    case 344:return LL_TIM_DMABURST_LENGTH_11TRANSFERS;
    case 345:return LL_TIM_DMABURST_LENGTH_12TRANSFERS;
    case 346:return LL_TIM_DMABURST_LENGTH_13TRANSFERS;
    case 347:return LL_TIM_DMABURST_LENGTH_14TRANSFERS;
    case 348:return LL_TIM_DMABURST_LENGTH_15TRANSFERS;
    case 349:return LL_TIM_DMABURST_LENGTH_16TRANSFERS;
    case 350:return LL_TIM_DMABURST_LENGTH_17TRANSFERS;
    case 351:return LL_TIM_DMABURST_LENGTH_18TRANSFERS;
    case 352:return LL_TIM_DMABURST_LENGTH_19TRANSFERS;
    case 353:return LL_TIM_DMABURST_LENGTH_20TRANSFERS;
    case 354:return LL_TIM_DMABURST_LENGTH_21TRANSFERS;
    case 355:return LL_TIM_DMABURST_LENGTH_22TRANSFERS;
    case 356:return LL_TIM_DMABURST_LENGTH_23TRANSFERS;
    case 357:return LL_TIM_DMABURST_LENGTH_24TRANSFERS;
    case 358:return LL_TIM_DMABURST_LENGTH_25TRANSFERS;
    case 359:return LL_TIM_DMABURST_LENGTH_26TRANSFERS;
    case 360:return LL_TIM_DMA_UPDATE;
    case 361:return LL_TIM_DMA_CC1;
    case 362:return LL_TIM_DMA_CC2;
    case 363:return LL_TIM_DMA_CC3;
    case 364:return LL_TIM_DMA_CC4;
    case 365:return LL_TIM_DMA_COM;
    case 366:return LL_TIM_DMA_TRIGGER;
    case 367:return LL_TIM_TIM2_TI1_RMP_GPIO;
    case 368:return LL_TIM_TIM2_TI1_RMP_ETH_PPS;
    case 369:return LL_TIM_TIM3_TI1_RMP_GPIO;
    case 370:return LL_TIM_TIM3_TI1_RMP_ETH_PPS;
    case 371:return LL_TIM_TIM9_TI1_RMP_GPIO;
    case 372:return LL_TIM_TIM9_TI1_RMP_MCO1;
    case 373:return LL_TIM_TIM9_TI1_RMP_MCO2;
    case 374:return LL_TIM_TIM12_TI1_RMP_GPIO;
    case 375:return LL_TIM_TIM12_TI1_RMP_SPDIF_FS;
    case 376:return LL_TIM_TIM12_TI1_RMP_HSI_1024;
    case 377:return LL_TIM_TIM12_TI1_RMP_CSI_128;
    case 378:return LL_TIM_TIM12_TI1_RMP_MCO1;
    case 379:return LL_TIM_TIM12_TI1_RMP_MCO2;
    case 380:return LL_TIM_TIM15_TI1_RMP_GPIO;
    case 381:return LL_TIM_TIM15_TI1_RMP_TIM2_CH1;
    case 382:return LL_TIM_TIM15_TI1_RMP_TIM3_CH1;
    case 383:return LL_TIM_TIM15_TI1_RMP_TIM4_CH1;
    case 384:return LL_TIM_TIM15_TI1_RMP_MCO1;
    case 385:return LL_TIM_TIM15_TI1_RMP_MCO2;
    case 386:return LL_TIM_TIM15_TI2_RMP_GPIO;
    case 387:return LL_TIM_TIM15_TI2_RMP_TIM2_CH2;
    case 388:return LL_TIM_TIM15_TI2_RMP_TIM3_CH2;
    case 389:return LL_TIM_TIM15_TI2_RMP_TIM4_CH2;
    case 390:return LL_TIM_TIM16_TI1_RMP_GPIO;
    case 391:return LL_TIM_TIM16_TI1_RMP_RTC_WKUP;
    case 392:return LL_TIM_TIM17_TI1_RMP_GPIO;
    case 393:return LL_TIM_TIM17_TI1_RMP_SPDIF_FS;
    case 394:return LL_TIM_INDEX_UP_DOWN;
    case 395:return LL_TIM_INDEX_UP;
    case 396:return LL_TIM_INDEX_DOWN;
    case 397:return LL_TIM_INDEX_BLANK_ALWAYS;
    case 398:return LL_TIM_INDEX_BLANK_TI3;
    case 399:return LL_TIM_INDEX_BLANK_TI4;
    case 400:return LL_TIM_INDEX_POSITION_DOWN_DOWN;
    case 401:return LL_TIM_INDEX_POSITION_DOWN_UP;
    case 402:return LL_TIM_INDEX_POSITION_UP_DOWN;
    case 403:return LL_TIM_INDEX_POSITION_UP_UP;
    case 404:return LL_TIM_INDEX_POSITION_DOWN;
    case 405:return LL_TIM_INDEX_POSITION_UP;
    case 406:return LL_TIM_INDEX_ALL;
    case 407:return LL_TIM_INDEX_FIRST_ONLY;
    case 408:return LL_TIM_PWPRSC_X1;
    case 409:return LL_TIM_PWPRSC_X2;
    case 410:return LL_TIM_PWPRSC_X4;
    case 411:return LL_TIM_PWPRSC_X8;
    case 412:return LL_TIM_PWPRSC_X16;
    case 413:return LL_TIM_PWPRSC_X32;
    case 414:return LL_TIM_PWPRSC_X64;
    case 415:return LL_TIM_PWPRSC_X128;
    case 416:return LL_LPTIM_ISR_CMP1OK;
    case 417:return LL_LPTIM_ISR_CMP2OK;
    case 418:return LL_LPTIM_ISR_CC1IF;
    case 419:return LL_LPTIM_ISR_CC2IF;
    case 420:return LL_LPTIM_ISR_CC1OF;
    case 421:return LL_LPTIM_ISR_CC2OF;
    case 422:return LL_LPTIM_ISR_DIEROK;
    case 423:return LL_LPTIM_ISR_ARRM;
    case 424:return LL_LPTIM_ISR_EXTTRIG;
    case 425:return LL_LPTIM_ISR_ARROK;
    case 426:return LL_LPTIM_ISR_UP;
    case 427:return LL_LPTIM_ISR_DOWN;
    case 428:return LL_LPTIM_ISR_UE;
    case 429:return LL_LPTIM_ISR_REPOK;
    case 430:return LL_LPTIM_DIER_CMP1OKIE;
    case 431:return LL_LPTIM_DIER_CMP2OKIE;
    case 432:return LL_LPTIM_DIER_CC1IFIE;
    case 433:return LL_LPTIM_DIER_CC2IFIE;
    case 434:return LL_LPTIM_DIER_CC1OFIE;
    case 435:return LL_LPTIM_DIER_CC2OFIE;
    case 436:return LL_LPTIM_DIER_ARRMIE;
    case 437:return LL_LPTIM_DIER_EXTTRIGIE;
    case 438:return LL_LPTIM_DIER_ARROKIE;
    case 439:return LL_LPTIM_DIER_UPIE;
    case 440:return LL_LPTIM_DIER_DOWNIE;
    case 441:return LL_LPTIM_DIER_UEIE;
    case 442:return LL_LPTIM_DIER_REPOKIE;
    case 443:return LL_LPTIM_OPERATING_MODE_CONTINUOUS;
    case 444:return LL_LPTIM_OPERATING_MODE_ONESHOT;
    case 445:return LL_LPTIM_UPDATE_MODE_IMMEDIATE;
    case 446:return LL_LPTIM_UPDATE_MODE_ENDOFPERIOD;
    case 447:return LL_LPTIM_COUNTER_MODE_INTERNAL;
    case 448:return LL_LPTIM_COUNTER_MODE_EXTERNAL;
    case 449:return LL_LPTIM_OUTPUT_WAVEFORM_PWM;
    case 450:return LL_LPTIM_OUTPUT_WAVEFORM_SETONCE;
    case 451:return LL_LPTIM_OUTPUT_POLARITY_REGULAR;
    case 452:return LL_LPTIM_OUTPUT_POLARITY_INVERSE;
    case 453:return LL_LPTIM_CHANNEL_CH1;
    case 454:return LL_LPTIM_CHANNEL_CH2;
    case 455:return LL_LPTIM_ICPSC_DIV1;
    case 456:return LL_LPTIM_ICPSC_DIV2;
    case 457:return LL_LPTIM_ICPSC_DIV4;
    case 458:return LL_LPTIM_ICPSC_DIV8;
    case 459:return LL_LPTIM_ICFLT_CLOCK_DIV1;
    case 460:return LL_LPTIM_ICFLT_CLOCK_DIV2;
    case 461:return LL_LPTIM_ICFLT_CLOCK_DIV4;
    case 462:return LL_LPTIM_ICFLT_CLOCK_DIV8;
    case 463:return LL_LPTIM_ICPOLARITY_RISING;
    case 464:return LL_LPTIM_ICPOLARITY_FALLING;
    case 465:return LL_LPTIM_ICPOLARITY_RISING_FALLING;
    case 466:return LL_LPTIM_CCMODE_OUTPUT_PWM;
    case 467:return LL_LPTIM_CCMODE_INPUTCAPTURE;
    case 468:return LL_LPTIM_PRESCALER_DIV1;
    case 469:return LL_LPTIM_PRESCALER_DIV2;
    case 470:return LL_LPTIM_PRESCALER_DIV4;
    case 471:return LL_LPTIM_PRESCALER_DIV8;
    case 472:return LL_LPTIM_PRESCALER_DIV16;
    case 473:return LL_LPTIM_PRESCALER_DIV32;
    case 474:return LL_LPTIM_PRESCALER_DIV64;
    case 475:return LL_LPTIM_PRESCALER_DIV128;
    case 476:return LL_LPTIM_TRIG_SOURCE_GPIO;
    case 477:return LL_LPTIM_TRIG_SOURCE_RTCALARMA;
    case 478:return LL_LPTIM_TRIG_SOURCE_RTCALARMB;
    case 479:return LL_LPTIM_TRIG_SOURCE_RTCTAMP1;
    case 480:return LL_LPTIM_TRIG_SOURCE_RTCTAMP2;
    case 481:return LL_LPTIM_TRIG_SOURCE_RTCTAMP3;
    case 482:return LL_LPTIM_TRIG_SOURCE_SAI1_FS_A;
    case 483:return LL_LPTIM_TRIG_SOURCE_SAI1_FS_B;
    case 484:return LL_LPTIM_TRIG_SOURCE_SAI2_FS_A;
    case 485:return LL_LPTIM_TRIG_SOURCE_SAI2_FS_B;
    case 486:return LL_LPTIM3_TRIG_SOURCE_LPTIM2_CH1;
    case 487:return LL_LPTIM3_TRIG_SOURCE_LPTIM4;
    case 488:return LL_LPTIM3_TRIG_SOURCE_LPTIM5;
    case 489:return LL_LPTIM4_TRIG_SOURCE_LPTIM2_CH1;
    case 490:return LL_LPTIM4_TRIG_SOURCE_LPTIM3_CH1;
    case 491:return LL_LPTIM4_TRIG_SOURCE_LPTIM5;
    case 492:return LL_LPTIM5_TRIG_SOURCE_LPTIM2_CH1;
    case 493:return LL_LPTIM5_TRIG_SOURCE_LPTIM3_CH1;
    case 494:return LL_LPTIM5_TRIG_SOURCE_LPTIM4;
    case 495:return LL_LPTIM_TRIG_FILTER_NONE;
    case 496:return LL_LPTIM_TRIG_FILTER_2;
    case 497:return LL_LPTIM_TRIG_FILTER_4;
    case 498:return LL_LPTIM_TRIG_FILTER_8;
    case 499:return LL_LPTIM_TRIG_POLARITY_RISING;
    case 500:return LL_LPTIM_TRIG_POLARITY_FALLING;
    case 501:return LL_LPTIM_TRIG_POLARITY_RISING_FALLING;
    case 502:return LL_LPTIM_CLK_SOURCE_INTERNAL;
    case 503:return LL_LPTIM_CLK_SOURCE_EXTERNAL;
    case 504:return LL_LPTIM_CLK_FILTER_NONE;
    case 505:return LL_LPTIM_CLK_FILTER_2;
    case 506:return LL_LPTIM_CLK_FILTER_4;
    case 507:return LL_LPTIM_CLK_FILTER_8;
    case 508:return LL_LPTIM_CLK_POLARITY_RISING;
    case 509:return LL_LPTIM_CLK_POLARITY_FALLING;
    case 510:return LL_LPTIM_CLK_POLARITY_RISING_FALLING;
    case 511:return LL_LPTIM_ENCODER_MODE_RISING;
    case 512:return LL_LPTIM_ENCODER_MODE_FALLING;
    case 513:return LL_LPTIM_ENCODER_MODE_RISING_FALLING;
    case 514:return LL_LPTIM_INPUT1_SRC_GPIO;
    case 515:return LL_LPTIM_INPUT2_SRC_GPIO;
    case 516:return LL_LPTIM_LPTIM1_IC1_RMP_GPIO;
    case 517:return LL_LPTIM_LPTIM1_IC2_RMP_GPIO;
    case 518:return LL_LPTIM_LPTIM1_IC2_RMP_LSI;
    case 519:return LL_LPTIM_LPTIM1_IC2_RMP_LSE;
    case 520:return LL_LPTIM_LPTIM2_IC1_RMP_GPIO;
    case 521:return LL_LPTIM_LPTIM2_IC2_RMP_GPIO;
    case 522:return LL_LPTIM_LPTIM2_IC2_RMP_HSI_1024;
    case 523:return LL_LPTIM_LPTIM2_IC2_RMP_CSI_128;
    case 524:return LL_LPTIM_LPTIM3_IC1_RMP_GPIO;
    case 525:return LL_LPTIM_LPTIM3_IC2_RMP_GPIO;
    case 526:return OFFSET_TAB_CCMRx[0];
    case 527:return OFFSET_TAB_CCMRx[1];
    case 528:return OFFSET_TAB_CCMRx[2];
    case 529:return OFFSET_TAB_CCMRx[3];
    case 530:return OFFSET_TAB_CCMRx[4];
    case 531:return OFFSET_TAB_CCMRx[5];
    case 532:return OFFSET_TAB_CCMRx[6];
    case 533:return OFFSET_TAB_CCMRx[7];
    case 534:return OFFSET_TAB_CCMRx[8];
    case 535:return OFFSET_TAB_CCMRx[9];
    case 536:return SHIFT_TAB_OCxx[0];
    case 537:return SHIFT_TAB_OCxx[1];
    case 538:return SHIFT_TAB_OCxx[2];
    case 539:return SHIFT_TAB_OCxx[3];
    case 540:return SHIFT_TAB_OCxx[4];
    case 541:return SHIFT_TAB_OCxx[5];
    case 542:return SHIFT_TAB_OCxx[6];
    case 543:return SHIFT_TAB_OCxx[7];
    case 544:return SHIFT_TAB_OCxx[8];
    case 545:return SHIFT_TAB_OCxx[9];
    case 546:return SHIFT_TAB_ICxx[0];
    case 547:return SHIFT_TAB_ICxx[1];
    case 548:return SHIFT_TAB_ICxx[2];
    case 549:return SHIFT_TAB_ICxx[3];
    case 550:return SHIFT_TAB_ICxx[4];
    case 551:return SHIFT_TAB_ICxx[5];
    case 552:return SHIFT_TAB_ICxx[6];
    case 553:return SHIFT_TAB_ICxx[7];
    case 554:return SHIFT_TAB_ICxx[8];
    case 555:return SHIFT_TAB_ICxx[9];
    case 556:return SHIFT_TAB_CCxP[0];
    case 557:return SHIFT_TAB_CCxP[1];
    case 558:return SHIFT_TAB_CCxP[2];
    case 559:return SHIFT_TAB_CCxP[3];
    case 560:return SHIFT_TAB_CCxP[4];
    case 561:return SHIFT_TAB_CCxP[5];
    case 562:return SHIFT_TAB_CCxP[6];
    case 563:return SHIFT_TAB_CCxP[7];
    case 564:return SHIFT_TAB_CCxP[8];
    case 565:return SHIFT_TAB_CCxP[9];
    case 566:return SHIFT_TAB_OISx[0];
    case 567:return SHIFT_TAB_OISx[1];
    case 568:return SHIFT_TAB_OISx[2];
    case 569:return SHIFT_TAB_OISx[3];
    case 570:return SHIFT_TAB_OISx[4];
    case 571:return SHIFT_TAB_OISx[5];
    case 572:return SHIFT_TAB_OISx[6];
    case 573:return SHIFT_TAB_OISx[7];
    case 574:return SHIFT_TAB_OISx[8];
    case 575:return SHIFT_TAB_OISx[9];
    case 576:return LL_LPTIM_SHIFT_TAB_CCxP[0];
    case 577:return LL_LPTIM_SHIFT_TAB_CCxP[1];
    case 578:return LL_LPTIM_SHIFT_TAB_ICxF[0];
    case 579:return LL_LPTIM_SHIFT_TAB_ICxF[1];
    case 580:return LL_LPTIM_SHIFT_TAB_ICxPSC[0];
    case 581:return LL_LPTIM_SHIFT_TAB_ICxPSC[1];
    case 582:return LL_LPTIM_SHIFT_TAB_CCxSEL[0];
    case 583:return LL_LPTIM_SHIFT_TAB_CCxSEL[1];
    case 584:return LL_LPTIM_SHIFT_TAB_CCxE[0];
    case 585:return LL_LPTIM_SHIFT_TAB_CCxE[1];
    case 586:return LL_LPTIM_OFFSET_TAB_ICx[0][0];
    case 587:return LL_LPTIM_OFFSET_TAB_ICx[0][1];
    case 588:return LL_LPTIM_OFFSET_TAB_ICx[0][2];
    case 589:return LL_LPTIM_OFFSET_TAB_ICx[0][3];
    case 590:return LL_LPTIM_OFFSET_TAB_ICx[1][0];
    case 591:return LL_LPTIM_OFFSET_TAB_ICx[1][1];
    case 592:return LL_LPTIM_OFFSET_TAB_ICx[1][2];
    case 593:return LL_LPTIM_OFFSET_TAB_ICx[1][3];
    case 594:return LL_LPTIM_OFFSET_TAB_ICx[2][0];
    case 595:return LL_LPTIM_OFFSET_TAB_ICx[2][1];
    case 596:return LL_LPTIM_OFFSET_TAB_ICx[2][2];
    case 597:return LL_LPTIM_OFFSET_TAB_ICx[2][3];
    case 598:return LL_LPTIM_OFFSET_TAB_ICx[3][0];
    case 599:return LL_LPTIM_OFFSET_TAB_ICx[3][1];
    case 600:return LL_LPTIM_OFFSET_TAB_ICx[3][2];
    case 601:return LL_LPTIM_OFFSET_TAB_ICx[3][3];
    case 602:return LL_LPTIM_OFFSET_TAB_ICx[4][0];
    case 603:return LL_LPTIM_OFFSET_TAB_ICx[4][1];
    case 604:return LL_LPTIM_OFFSET_TAB_ICx[4][2];
    case 605:return LL_LPTIM_OFFSET_TAB_ICx[4][3];
    case 606:return LL_LPTIM_OFFSET_TAB_ICx[5][0];
    case 607:return LL_LPTIM_OFFSET_TAB_ICx[5][1];
    case 608:return LL_LPTIM_OFFSET_TAB_ICx[5][2];
    case 609:return LL_LPTIM_OFFSET_TAB_ICx[5][3];
    case 610:return LL_LPTIM_OFFSET_TAB_ICx[6][0];
    case 611:return LL_LPTIM_OFFSET_TAB_ICx[6][1];
    case 612:return LL_LPTIM_OFFSET_TAB_ICx[6][2];
    case 613:return LL_LPTIM_OFFSET_TAB_ICx[6][3];
    case 614:return LL_LPTIM_OFFSET_TAB_ICx[7][0];
    case 615:return LL_LPTIM_OFFSET_TAB_ICx[7][1];
    case 616:return LL_LPTIM_OFFSET_TAB_ICx[7][2];
    case 617:return LL_LPTIM_OFFSET_TAB_ICx[7][3];
    default:abort();
  }
}
