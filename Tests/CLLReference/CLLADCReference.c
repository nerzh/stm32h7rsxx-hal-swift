#include "include/CLLADCReference.h"
#include <stdlib.h>
#include <assert.h>
#include "Upstream/ADC/Trace/stm32h7rsxx_ll_adc.h"
#include "Upstream/ADC/Trace/stm32h7rsxx_ll_adc.inc"
struct CL53State { uint32_t cells[1024],count,reads,salt,instance,crReads,stopAt,disableAt; CL53Access trace[16384]; };
_Thread_local uint32_t *CL53_Cells;
static _Thread_local CL53State *current;
CL53State *CL53_Create(void){return calloc(1,sizeof(CL53State));}
void CL53_Destroy(CL53State *s){free(s);}
void CL53_Reset(CL53State *s,uint32_t seed,uint32_t salt,uint32_t instance,uint32_t stopAt,uint32_t disableAt){
 current=s;CL53_Cells=s->cells;
 for(uint32_t i=0;i<1024;i++)s->cells[i]=seed^(i*0x9E3779B9U);
 s->count=0;s->reads=0;s->salt=salt;s->instance=instance;s->crReads=0;s->stopAt=stopAt;s->disableAt=disableAt;
}
static void record(uint32_t index,uint32_t value,uint32_t kind){
 assert(index<1024 && current->count<16384);current->trace[current->count++]=(CL53Access){index,value,kind};
}
uint32_t CL53_Read(volatile const uint32_t *p){
 uintptr_t delta=(uintptr_t)p-(uintptr_t)CL53_Cells;assert(delta<4096 && delta%4==0);uint32_t i=(uint32_t)(delta/4);
 if(i==2 || i==66){
  current->crReads++;
  if(current->stopAt && current->crReads>=current->stopAt)current->cells[i]&=~0x3CU;
  if(current->disableAt && current->crReads>=current->disableAt && (current->cells[i]&2U))current->cells[i]&=~3U;
 }
 uint32_t v=*p^(current->salt*current->reads++);record(i,v,0);return v;
}
void CL53_Write(volatile uint32_t *p,uint32_t v){uintptr_t delta=(uintptr_t)p-(uintptr_t)CL53_Cells;assert(delta<4096 && delta%4==0);record((uint32_t)(delta/4),v,1);*p=v;}
uint32_t CL53_Address(volatile const uint32_t *p){uintptr_t d=(uintptr_t)p-(uintptr_t)CL53_Cells;assert(d<1024);return 0x40022000U+(uint32_t)d;}
uint16_t CL53_Factory(uint32_t index){assert(index<3);uint16_t v=(uint16_t)CL53_Cells[600+index];record(600+index,v,2);return v;}
uint32_t *CL53_GetCells(CL53State *s){return s->cells;}
const CL53Access *CL53_GetTrace(CL53State *s){return s->trace;}
uint32_t CL53_GetTraceCount(CL53State *s){return s->count;}
uint32_t CL53_Run(CL53State *s,uint32_t op,const uint32_t *args){
 current=s;CL53_Cells=s->cells;ADC_TypeDef *adc=s->instance?ADC2:ADC1;
 switch(op){
 case 0: { uint32_t result=LL_ADC_DMA_GetRegAddr(adc, args[0]); return result; }
 case 1: { LL_ADC_SetCommonClock(ADC12_COMMON, args[0]); return 0; }
 case 2: { uint32_t result=LL_ADC_GetCommonClock(ADC12_COMMON); return result; }
 case 3: { LL_ADC_SetCommonPathInternalCh(ADC12_COMMON, args[0]); return 0; }
 case 4: { LL_ADC_SetCommonPathInternalChAdd(ADC12_COMMON, args[0]); return 0; }
 case 5: { LL_ADC_SetCommonPathInternalChRem(ADC12_COMMON, args[0]); return 0; }
 case 6: { uint32_t result=LL_ADC_GetCommonPathInternalCh(ADC12_COMMON); return result; }
 case 7: { LL_ADC_SetPathInternalCh(adc, args[0]); return 0; }
 case 8: { LL_ADC_SetPathInternalChAdd(adc, args[0]); return 0; }
 case 9: { LL_ADC_SetPathInternalChRem(adc, args[0]); return 0; }
 case 10: { uint32_t result=LL_ADC_GetPathInternalCh(adc); return result; }
 case 11: { LL_ADC_SetCalibrationFactor(adc, args[0], args[1]); return 0; }
 case 12: { uint32_t result=LL_ADC_GetCalibrationFactor(adc, args[0]); return result; }
 case 13: { LL_ADC_SetResolution(adc, args[0]); return 0; }
 case 14: { uint32_t result=LL_ADC_GetResolution(adc); return result; }
 case 15: { LL_ADC_SetDataAlignment(adc, args[0]); return 0; }
 case 16: { uint32_t result=LL_ADC_GetDataAlignment(adc); return result; }
 case 17: { LL_ADC_SetLowPowerMode(adc, args[0]); return 0; }
 case 18: { uint32_t result=LL_ADC_GetLowPowerMode(adc); return result; }
 case 19: { LL_ADC_SetOffset(adc, args[0], args[1], args[2]); return 0; }
 case 20: { uint32_t result=LL_ADC_GetOffsetChannel(adc, args[0]); return result; }
 case 21: { uint32_t result=LL_ADC_GetOffsetLevel(adc, args[0]); return result; }
 case 22: { LL_ADC_SetOffsetState(adc, args[0], args[1]); return 0; }
 case 23: { uint32_t result=LL_ADC_GetOffsetState(adc, args[0]); return result; }
 case 24: { LL_ADC_SetOffsetSign(adc, args[0], args[1]); return 0; }
 case 25: { uint32_t result=LL_ADC_GetOffsetSign(adc, args[0]); return result; }
 case 26: { LL_ADC_SetOffsetSaturation(adc, args[0], args[1]); return 0; }
 case 27: { uint32_t result=LL_ADC_GetOffsetSaturation(adc, args[0]); return result; }
 case 28: { LL_ADC_SetSamplingTimeCommonConfig(adc, args[0]); return 0; }
 case 29: { uint32_t result=LL_ADC_GetSamplingTimeCommonConfig(adc); return result; }
 case 30: { LL_ADC_REG_SetTriggerSource(adc, args[0]); return 0; }
 case 31: { uint32_t result=LL_ADC_REG_GetTriggerSource(adc); return result; }
 case 32: { uint32_t result=LL_ADC_REG_IsTriggerSourceSWStart(adc); return result; }
 case 33: { LL_ADC_REG_SetTriggerEdge(adc, args[0]); return 0; }
 case 34: { uint32_t result=LL_ADC_REG_GetTriggerEdge(adc); return result; }
 case 35: { LL_ADC_REG_SetSamplingMode(adc, args[0]); return 0; }
 case 36: { uint32_t result=LL_ADC_REG_GetSamplingMode(adc); return result; }
 case 37: { LL_ADC_REG_SetSequencerLength(adc, args[0]); return 0; }
 case 38: { uint32_t result=LL_ADC_REG_GetSequencerLength(adc); return result; }
 case 39: { LL_ADC_REG_SetSequencerDiscont(adc, args[0]); return 0; }
 case 40: { uint32_t result=LL_ADC_REG_GetSequencerDiscont(adc); return result; }
 case 41: { LL_ADC_REG_SetSequencerRanks(adc, args[0], args[1]); return 0; }
 case 42: { uint32_t result=LL_ADC_REG_GetSequencerRanks(adc, args[0]); return result; }
 case 43: { LL_ADC_REG_SetContinuousMode(adc, args[0]); return 0; }
 case 44: { uint32_t result=LL_ADC_REG_GetContinuousMode(adc); return result; }
 case 45: { LL_ADC_REG_SetDMATransfer(adc, args[0]); return 0; }
 case 46: { uint32_t result=LL_ADC_REG_GetDMATransfer(adc); return result; }
 case 47: { LL_ADC_REG_SetMDFTransfer(adc, args[0]); return 0; }
 case 48: { uint32_t result=LL_ADC_REG_GetMDFTransfer(adc); return result; }
 case 49: { LL_ADC_REG_SetOverrun(adc, args[0]); return 0; }
 case 50: { uint32_t result=LL_ADC_REG_GetOverrun(adc); return result; }
 case 51: { LL_ADC_INJ_SetTriggerSource(adc, args[0]); return 0; }
 case 52: { uint32_t result=LL_ADC_INJ_GetTriggerSource(adc); return result; }
 case 53: { uint32_t result=LL_ADC_INJ_IsTriggerSourceSWStart(adc); return result; }
 case 54: { LL_ADC_INJ_SetTriggerEdge(adc, args[0]); return 0; }
 case 55: { uint32_t result=LL_ADC_INJ_GetTriggerEdge(adc); return result; }
 case 56: { LL_ADC_INJ_SetSequencerLength(adc, args[0]); return 0; }
 case 57: { uint32_t result=LL_ADC_INJ_GetSequencerLength(adc); return result; }
 case 58: { LL_ADC_INJ_SetSequencerDiscont(adc, args[0]); return 0; }
 case 59: { uint32_t result=LL_ADC_INJ_GetSequencerDiscont(adc); return result; }
 case 60: { LL_ADC_INJ_SetSequencerRanks(adc, args[0], args[1]); return 0; }
 case 61: { uint32_t result=LL_ADC_INJ_GetSequencerRanks(adc, args[0]); return result; }
 case 62: { LL_ADC_INJ_SetTrigAuto(adc, args[0]); return 0; }
 case 63: { uint32_t result=LL_ADC_INJ_GetTrigAuto(adc); return result; }
 case 64: { LL_ADC_INJ_SetQueueMode(adc, args[0]); return 0; }
 case 65: { uint32_t result=LL_ADC_INJ_GetQueueMode(adc); return result; }
 case 66: { LL_ADC_INJ_ConfigQueueContext(adc, args[0], args[1], args[2], args[3], args[4], args[5], args[6]); return 0; }
 case 67: { LL_ADC_SetChannelSamplingTime(adc, args[0], args[1]); return 0; }
 case 68: { uint32_t result=LL_ADC_GetChannelSamplingTime(adc, args[0]); return result; }
 case 69: { LL_ADC_SetChannelSingleDiff(adc, args[0], args[1]); return 0; }
 case 70: { uint32_t result=LL_ADC_GetChannelSingleDiff(adc, args[0]); return result; }
 case 71: { LL_ADC_SetAnalogWDMonitChannels(adc, args[0], args[1]); return 0; }
 case 72: { uint32_t result=LL_ADC_GetAnalogWDMonitChannels(adc, args[0]); return result; }
 case 73: { LL_ADC_ConfigAnalogWDThresholds(adc, args[0], args[1], args[2]); return 0; }
 case 74: { LL_ADC_SetAnalogWDThresholds(adc, args[0], args[1], args[2]); return 0; }
 case 75: { uint32_t result=LL_ADC_GetAnalogWDThresholds(adc, args[0], args[1]); return result; }
 case 76: { LL_ADC_SetAWDFilteringConfiguration(adc, args[0], args[1]); return 0; }
 case 77: { uint32_t result=LL_ADC_GetAWDFilteringConfiguration(adc, args[0]); return result; }
 case 78: { LL_ADC_SetOverSamplingScope(adc, args[0]); return 0; }
 case 79: { uint32_t result=LL_ADC_GetOverSamplingScope(adc); return result; }
 case 80: { LL_ADC_SetOverSamplingDiscont(adc, args[0]); return 0; }
 case 81: { uint32_t result=LL_ADC_GetOverSamplingDiscont(adc); return result; }
 case 82: { LL_ADC_ConfigOverSamplingRatioShift(adc, args[0], args[1]); return 0; }
 case 83: { uint32_t result=LL_ADC_GetOverSamplingRatio(adc); return result; }
 case 84: { uint32_t result=LL_ADC_GetOverSamplingShift(adc); return result; }
 case 85: { LL_ADC_SetMultimode(ADC12_COMMON, args[0]); return 0; }
 case 86: { uint32_t result=LL_ADC_GetMultimode(ADC12_COMMON); return result; }
 case 87: { LL_ADC_SetMultiDMATransfer(ADC12_COMMON, args[0]); return 0; }
 case 88: { uint32_t result=LL_ADC_GetMultiDMATransfer(ADC12_COMMON); return result; }
 case 89: { LL_ADC_SetMultiTwoSamplingDelay(ADC12_COMMON, args[0]); return 0; }
 case 90: { uint32_t result=LL_ADC_GetMultiTwoSamplingDelay(ADC12_COMMON); return result; }
 case 91: { LL_ADC_EnableDeepPowerDown(adc); return 0; }
 case 92: { LL_ADC_DisableDeepPowerDown(adc); return 0; }
 case 93: { uint32_t result=LL_ADC_IsDeepPowerDownEnabled(adc); return result; }
 case 94: { LL_ADC_EnableInternalRegulator(adc); return 0; }
 case 95: { LL_ADC_DisableInternalRegulator(adc); return 0; }
 case 96: { uint32_t result=LL_ADC_IsInternalRegulatorEnabled(adc); return result; }
 case 97: { LL_ADC_Enable(adc); return 0; }
 case 98: { LL_ADC_Disable(adc); return 0; }
 case 99: { uint32_t result=LL_ADC_IsEnabled(adc); return result; }
 case 100: { uint32_t result=LL_ADC_IsDisableOngoing(adc); return result; }
 case 101: { LL_ADC_StartCalibration(adc, args[0]); return 0; }
 case 102: { uint32_t result=LL_ADC_IsCalibrationOnGoing(adc); return result; }
 case 103: { LL_ADC_REG_StartConversion(adc); return 0; }
 case 104: { LL_ADC_REG_StopConversion(adc); return 0; }
 case 105: { uint32_t result=LL_ADC_REG_IsConversionOngoing(adc); return result; }
 case 106: { uint32_t result=LL_ADC_REG_IsStopConversionOngoing(adc); return result; }
 case 107: { LL_ADC_REG_StartSamplingPhase(adc); return 0; }
 case 108: { LL_ADC_REG_StopSamplingPhase(adc); return 0; }
 case 109: { uint32_t result=LL_ADC_REG_ReadConversionData32(adc); return result; }
 case 110: { uint32_t result=LL_ADC_REG_ReadConversionData12(adc); return result; }
 case 111: { uint32_t result=LL_ADC_REG_ReadConversionData10(adc); return result; }
 case 112: { uint32_t result=LL_ADC_REG_ReadConversionData8(adc); return result; }
 case 113: { uint32_t result=LL_ADC_REG_ReadConversionData6(adc); return result; }
 case 114: { uint32_t result=LL_ADC_REG_ReadMultiConversionData32(ADC12_COMMON, args[0]); return result; }
 case 115: { LL_ADC_INJ_StartConversion(adc); return 0; }
 case 116: { LL_ADC_INJ_StopConversion(adc); return 0; }
 case 117: { uint32_t result=LL_ADC_INJ_IsConversionOngoing(adc); return result; }
 case 118: { uint32_t result=LL_ADC_INJ_IsStopConversionOngoing(adc); return result; }
 case 119: { uint32_t result=LL_ADC_INJ_ReadConversionData32(adc, args[0]); return result; }
 case 120: { uint32_t result=LL_ADC_INJ_ReadConversionData12(adc, args[0]); return result; }
 case 121: { uint32_t result=LL_ADC_INJ_ReadConversionData10(adc, args[0]); return result; }
 case 122: { uint32_t result=LL_ADC_INJ_ReadConversionData8(adc, args[0]); return result; }
 case 123: { uint32_t result=LL_ADC_INJ_ReadConversionData6(adc, args[0]); return result; }
 case 124: { uint32_t result=LL_ADC_IsActiveFlag_ADRDY(adc); return result; }
 case 125: { uint32_t result=LL_ADC_IsActiveFlag_EOC(adc); return result; }
 case 126: { uint32_t result=LL_ADC_IsActiveFlag_EOS(adc); return result; }
 case 127: { uint32_t result=LL_ADC_IsActiveFlag_OVR(adc); return result; }
 case 128: { uint32_t result=LL_ADC_IsActiveFlag_EOSMP(adc); return result; }
 case 129: { uint32_t result=LL_ADC_IsActiveFlag_JEOC(adc); return result; }
 case 130: { uint32_t result=LL_ADC_IsActiveFlag_JEOS(adc); return result; }
 case 131: { uint32_t result=LL_ADC_IsActiveFlag_JQOVF(adc); return result; }
 case 132: { uint32_t result=LL_ADC_IsActiveFlag_AWD1(adc); return result; }
 case 133: { uint32_t result=LL_ADC_IsActiveFlag_AWD2(adc); return result; }
 case 134: { uint32_t result=LL_ADC_IsActiveFlag_AWD3(adc); return result; }
 case 135: { LL_ADC_ClearFlag_ADRDY(adc); return 0; }
 case 136: { LL_ADC_ClearFlag_EOC(adc); return 0; }
 case 137: { LL_ADC_ClearFlag_EOS(adc); return 0; }
 case 138: { LL_ADC_ClearFlag_OVR(adc); return 0; }
 case 139: { LL_ADC_ClearFlag_EOSMP(adc); return 0; }
 case 140: { LL_ADC_ClearFlag_JEOC(adc); return 0; }
 case 141: { LL_ADC_ClearFlag_JEOS(adc); return 0; }
 case 142: { LL_ADC_ClearFlag_JQOVF(adc); return 0; }
 case 143: { LL_ADC_ClearFlag_AWD1(adc); return 0; }
 case 144: { LL_ADC_ClearFlag_AWD2(adc); return 0; }
 case 145: { LL_ADC_ClearFlag_AWD3(adc); return 0; }
 case 146: { uint32_t result=LL_ADC_IsActiveFlag_MST_ADRDY(ADC12_COMMON); return result; }
 case 147: { uint32_t result=LL_ADC_IsActiveFlag_SLV_ADRDY(ADC12_COMMON); return result; }
 case 148: { uint32_t result=LL_ADC_IsActiveFlag_MST_EOC(ADC12_COMMON); return result; }
 case 149: { uint32_t result=LL_ADC_IsActiveFlag_SLV_EOC(ADC12_COMMON); return result; }
 case 150: { uint32_t result=LL_ADC_IsActiveFlag_MST_EOS(ADC12_COMMON); return result; }
 case 151: { uint32_t result=LL_ADC_IsActiveFlag_SLV_EOS(ADC12_COMMON); return result; }
 case 152: { uint32_t result=LL_ADC_IsActiveFlag_MST_OVR(ADC12_COMMON); return result; }
 case 153: { uint32_t result=LL_ADC_IsActiveFlag_SLV_OVR(ADC12_COMMON); return result; }
 case 154: { uint32_t result=LL_ADC_IsActiveFlag_MST_EOSMP(ADC12_COMMON); return result; }
 case 155: { uint32_t result=LL_ADC_IsActiveFlag_SLV_EOSMP(ADC12_COMMON); return result; }
 case 156: { uint32_t result=LL_ADC_IsActiveFlag_MST_JEOC(ADC12_COMMON); return result; }
 case 157: { uint32_t result=LL_ADC_IsActiveFlag_SLV_JEOC(ADC12_COMMON); return result; }
 case 158: { uint32_t result=LL_ADC_IsActiveFlag_MST_JEOS(ADC12_COMMON); return result; }
 case 159: { uint32_t result=LL_ADC_IsActiveFlag_SLV_JEOS(ADC12_COMMON); return result; }
 case 160: { uint32_t result=LL_ADC_IsActiveFlag_MST_JQOVF(ADC12_COMMON); return result; }
 case 161: { uint32_t result=LL_ADC_IsActiveFlag_SLV_JQOVF(ADC12_COMMON); return result; }
 case 162: { uint32_t result=LL_ADC_IsActiveFlag_MST_AWD1(ADC12_COMMON); return result; }
 case 163: { uint32_t result=LL_ADC_IsActiveFlag_SLV_AWD1(ADC12_COMMON); return result; }
 case 164: { uint32_t result=LL_ADC_IsActiveFlag_MST_AWD2(ADC12_COMMON); return result; }
 case 165: { uint32_t result=LL_ADC_IsActiveFlag_SLV_AWD2(ADC12_COMMON); return result; }
 case 166: { uint32_t result=LL_ADC_IsActiveFlag_MST_AWD3(ADC12_COMMON); return result; }
 case 167: { uint32_t result=LL_ADC_IsActiveFlag_SLV_AWD3(ADC12_COMMON); return result; }
 case 168: { LL_ADC_EnableIT_ADRDY(adc); return 0; }
 case 169: { LL_ADC_EnableIT_EOC(adc); return 0; }
 case 170: { LL_ADC_EnableIT_EOS(adc); return 0; }
 case 171: { LL_ADC_EnableIT_OVR(adc); return 0; }
 case 172: { LL_ADC_EnableIT_EOSMP(adc); return 0; }
 case 173: { LL_ADC_EnableIT_JEOC(adc); return 0; }
 case 174: { LL_ADC_EnableIT_JEOS(adc); return 0; }
 case 175: { LL_ADC_EnableIT_JQOVF(adc); return 0; }
 case 176: { LL_ADC_EnableIT_AWD1(adc); return 0; }
 case 177: { LL_ADC_EnableIT_AWD2(adc); return 0; }
 case 178: { LL_ADC_EnableIT_AWD3(adc); return 0; }
 case 179: { LL_ADC_DisableIT_ADRDY(adc); return 0; }
 case 180: { LL_ADC_DisableIT_EOC(adc); return 0; }
 case 181: { LL_ADC_DisableIT_EOS(adc); return 0; }
 case 182: { LL_ADC_DisableIT_OVR(adc); return 0; }
 case 183: { LL_ADC_DisableIT_EOSMP(adc); return 0; }
 case 184: { LL_ADC_DisableIT_JEOC(adc); return 0; }
 case 185: { LL_ADC_DisableIT_JEOS(adc); return 0; }
 case 186: { LL_ADC_DisableIT_JQOVF(adc); return 0; }
 case 187: { LL_ADC_DisableIT_AWD1(adc); return 0; }
 case 188: { LL_ADC_DisableIT_AWD2(adc); return 0; }
 case 189: { LL_ADC_DisableIT_AWD3(adc); return 0; }
 case 190: { uint32_t result=LL_ADC_IsEnabledIT_ADRDY(adc); return result; }
 case 191: { uint32_t result=LL_ADC_IsEnabledIT_EOC(adc); return result; }
 case 192: { uint32_t result=LL_ADC_IsEnabledIT_EOS(adc); return result; }
 case 193: { uint32_t result=LL_ADC_IsEnabledIT_OVR(adc); return result; }
 case 194: { uint32_t result=LL_ADC_IsEnabledIT_EOSMP(adc); return result; }
 case 195: { uint32_t result=LL_ADC_IsEnabledIT_JEOC(adc); return result; }
 case 196: { uint32_t result=LL_ADC_IsEnabledIT_JEOS(adc); return result; }
 case 197: { uint32_t result=LL_ADC_IsEnabledIT_JQOVF(adc); return result; }
 case 198: { uint32_t result=LL_ADC_IsEnabledIT_AWD1(adc); return result; }
 case 199: { uint32_t result=LL_ADC_IsEnabledIT_AWD2(adc); return result; }
 case 200: { uint32_t result=LL_ADC_IsEnabledIT_AWD3(adc); return result; }
 case 201: { uint32_t result=LL_ADC_CommonDeInit(ADC12_COMMON); return result; }
 case 202: { LL_ADC_CommonInitTypeDef v1={args[0], args[1], args[2], args[3]}; uint32_t result=LL_ADC_CommonInit(ADC12_COMMON, &v1); s->cells[512]=v1.CommonClock; s->cells[513]=v1.Multimode; s->cells[514]=v1.MultiDMATransfer; s->cells[515]=v1.MultiTwoSamplingDelay; return result; }
 case 203: { LL_ADC_CommonInitTypeDef v0={args[0], args[1], args[2], args[3]}; LL_ADC_CommonStructInit(&v0); s->cells[512]=v0.CommonClock; s->cells[513]=v0.Multimode; s->cells[514]=v0.MultiDMATransfer; s->cells[515]=v0.MultiTwoSamplingDelay; return 0; }
 case 204: { uint32_t result=LL_ADC_DeInit(adc); return result; }
 case 205: { LL_ADC_InitTypeDef v1={args[0], args[1], args[2]}; uint32_t result=LL_ADC_Init(adc, &v1); s->cells[512]=v1.Resolution; s->cells[513]=v1.DataAlignment; s->cells[514]=v1.LowPowerMode; return result; }
 case 206: { LL_ADC_InitTypeDef v0={args[0], args[1], args[2]}; LL_ADC_StructInit(&v0); s->cells[512]=v0.Resolution; s->cells[513]=v0.DataAlignment; s->cells[514]=v0.LowPowerMode; return 0; }
 case 207: { LL_ADC_REG_InitTypeDef v1={args[0], args[1], args[2], args[3], args[4], args[5]}; uint32_t result=LL_ADC_REG_Init(adc, &v1); s->cells[512]=v1.TriggerSource; s->cells[513]=v1.SequencerLength; s->cells[514]=v1.SequencerDiscont; s->cells[515]=v1.ContinuousMode; s->cells[516]=v1.DMATransfer; s->cells[517]=v1.Overrun; return result; }
 case 208: { LL_ADC_REG_InitTypeDef v0={args[0], args[1], args[2], args[3], args[4], args[5]}; LL_ADC_REG_StructInit(&v0); s->cells[512]=v0.TriggerSource; s->cells[513]=v0.SequencerLength; s->cells[514]=v0.SequencerDiscont; s->cells[515]=v0.ContinuousMode; s->cells[516]=v0.DMATransfer; s->cells[517]=v0.Overrun; return 0; }
 case 209: { LL_ADC_INJ_InitTypeDef v1={args[0], args[1], args[2], args[3]}; uint32_t result=LL_ADC_INJ_Init(adc, &v1); s->cells[512]=v1.TriggerSource; s->cells[513]=v1.SequencerLength; s->cells[514]=v1.SequencerDiscont; s->cells[515]=v1.TrigAuto; return result; }
 case 210: { LL_ADC_INJ_InitTypeDef v0={args[0], args[1], args[2], args[3]}; LL_ADC_INJ_StructInit(&v0); s->cells[512]=v0.TriggerSource; s->cells[513]=v0.SequencerLength; s->cells[514]=v0.SequencerDiscont; s->cells[515]=v0.TrigAuto; return 0; }
 case 211: { LL_ADC_WriteReg(adc,CFGR,args[0]);return LL_ADC_ReadReg(adc,CFGR); }
 case 212: { LL_ADC_WriteReg(ADC12_COMMON,CCR,args[0]);return LL_ADC_ReadReg(ADC12_COMMON,CCR); }
 case 213: { return (uint32_t)__LL_ADC_CHANNEL_TO_DECIMAL_NB(args[0]); }
 case 214: { return (uint32_t)__LL_ADC_DECIMAL_NB_TO_CHANNEL(args[0]); }
 case 215: { return (uint32_t)__LL_ADC_IS_CHANNEL_INTERNAL(args[0]); }
 case 216: { return (uint32_t)__LL_ADC_CHANNEL_INTERNAL_TO_EXTERNAL(args[0]); }
 case 217: { return (uint32_t)__LL_ADC_ANALOGWD_CHANNEL_GROUP(args[0], args[1]); }
 case 218: { return (uint32_t)__LL_ADC_ANALOGWD_SET_THRESHOLD_RESOLUTION(args[0], args[1]); }
 case 219: { return (uint32_t)__LL_ADC_ANALOGWD_GET_THRESHOLD_RESOLUTION(args[0], args[1]); }
 case 220: { return (uint32_t)__LL_ADC_ANALOGWD_THRESHOLDS_HIGH_LOW(args[0], args[1]); }
 case 221: { return (uint32_t)__LL_ADC_CALIB_FACTOR_SINGLE_DIFF(args[0], args[1]); }
 case 222: { return (uint32_t)__LL_ADC_MULTI_CONV_DATA_MASTER_SLAVE(args[0], args[1]); }
 case 223: { return (uint32_t)__LL_ADC_DIGITAL_SCALE(args[0]); }
 case 224: { return (uint32_t)__LL_ADC_CONVERT_DATA_RESOLUTION(args[0], args[1], args[2]); }
 case 225: { return (uint32_t)__LL_ADC_CALC_DATA_TO_VOLTAGE(args[0], args[1], args[2]); }
 case 226: { return (uint32_t)__LL_ADC_CALC_DIFF_DATA_TO_VOLTAGE(args[0], args[1], args[2]); }
 case 227: { return (uint32_t)__LL_ADC_CALC_VREFANALOG_VOLTAGE(args[0], args[1]); }
 case 228: { return (uint32_t)__LL_ADC_CALC_TEMPERATURE(args[0], args[1], args[2]); }
 case 229: { return (uint32_t)__LL_ADC_CALC_TEMPERATURE_TYP_PARAMS(args[0], args[1], (int32_t)args[2], args[3], args[4], args[5]); }
 case 230: { return __LL_ADC_IS_CHANNEL_INTERNAL_AVAILABLE(adc,args[0]); }
 case 231: { return __LL_ADC_MULTI_INSTANCE_MASTER(adc)==ADC2?1:0; }
 case 232: { return CL53_Address(&(__LL_ADC_COMMON_INSTANCE(adc)->CSR)); }
 case 233: { return __LL_ADC_IS_ENABLED_ALL_COMMON_INSTANCE(ADC12_COMMON); }
 default:abort();
 }
}
uint32_t CL53_Constant(uint32_t i){switch(i){
case 0:return LL_ADC_FLAG_ADRDY;
case 1:return LL_ADC_FLAG_EOC;
case 2:return LL_ADC_FLAG_EOS;
case 3:return LL_ADC_FLAG_OVR;
case 4:return LL_ADC_FLAG_EOSMP;
case 5:return LL_ADC_FLAG_JEOC;
case 6:return LL_ADC_FLAG_JEOS;
case 7:return LL_ADC_FLAG_JQOVF;
case 8:return LL_ADC_FLAG_AWD1;
case 9:return LL_ADC_FLAG_AWD2;
case 10:return LL_ADC_FLAG_AWD3;
case 11:return LL_ADC_FLAG_ADRDY_MST;
case 12:return LL_ADC_FLAG_ADRDY_SLV;
case 13:return LL_ADC_FLAG_EOC_MST;
case 14:return LL_ADC_FLAG_EOC_SLV;
case 15:return LL_ADC_FLAG_EOS_MST;
case 16:return LL_ADC_FLAG_EOS_SLV;
case 17:return LL_ADC_FLAG_OVR_MST;
case 18:return LL_ADC_FLAG_OVR_SLV;
case 19:return LL_ADC_FLAG_EOSMP_MST;
case 20:return LL_ADC_FLAG_EOSMP_SLV;
case 21:return LL_ADC_FLAG_JEOC_MST;
case 22:return LL_ADC_FLAG_JEOC_SLV;
case 23:return LL_ADC_FLAG_JEOS_MST;
case 24:return LL_ADC_FLAG_JEOS_SLV;
case 25:return LL_ADC_FLAG_JQOVF_MST;
case 26:return LL_ADC_FLAG_JQOVF_SLV;
case 27:return LL_ADC_FLAG_AWD1_MST;
case 28:return LL_ADC_FLAG_AWD1_SLV;
case 29:return LL_ADC_FLAG_AWD2_MST;
case 30:return LL_ADC_FLAG_AWD2_SLV;
case 31:return LL_ADC_FLAG_AWD3_MST;
case 32:return LL_ADC_FLAG_AWD3_SLV;
case 33:return LL_ADC_IT_ADRDY;
case 34:return LL_ADC_IT_EOC;
case 35:return LL_ADC_IT_EOS;
case 36:return LL_ADC_IT_OVR;
case 37:return LL_ADC_IT_EOSMP;
case 38:return LL_ADC_IT_JEOC;
case 39:return LL_ADC_IT_JEOS;
case 40:return LL_ADC_IT_JQOVF;
case 41:return LL_ADC_IT_AWD1;
case 42:return LL_ADC_IT_AWD2;
case 43:return LL_ADC_IT_AWD3;
case 44:return LL_ADC_DMA_REG_REGULAR_DATA;
case 45:return LL_ADC_DMA_REG_REGULAR_DATA_MULTI;
case 46:return LL_ADC_CLOCK_SYNC_PCLK_DIV1;
case 47:return LL_ADC_CLOCK_SYNC_PCLK_DIV2;
case 48:return LL_ADC_CLOCK_SYNC_PCLK_DIV4;
case 49:return LL_ADC_CLOCK_ASYNC_DIV1;
case 50:return LL_ADC_CLOCK_ASYNC_DIV2;
case 51:return LL_ADC_CLOCK_ASYNC_DIV4;
case 52:return LL_ADC_CLOCK_ASYNC_DIV6;
case 53:return LL_ADC_CLOCK_ASYNC_DIV8;
case 54:return LL_ADC_CLOCK_ASYNC_DIV10;
case 55:return LL_ADC_CLOCK_ASYNC_DIV12;
case 56:return LL_ADC_CLOCK_ASYNC_DIV16;
case 57:return LL_ADC_CLOCK_ASYNC_DIV32;
case 58:return LL_ADC_CLOCK_ASYNC_DIV64;
case 59:return LL_ADC_CLOCK_ASYNC_DIV128;
case 60:return LL_ADC_CLOCK_ASYNC_DIV256;
case 61:return LL_ADC_PATH_INTERNAL_NONE;
case 62:return LL_ADC_PATH_INTERNAL_VREFINT;
case 63:return LL_ADC_PATH_INTERNAL_TEMPSENSOR;
case 64:return LL_ADC_PATH_INTERNAL_VBAT;
case 65:return LL_ADC_PATH_INTERNAL_VDDCORE;
case 66:return LL_ADC_RESOLUTION_12B;
case 67:return LL_ADC_RESOLUTION_10B;
case 68:return LL_ADC_RESOLUTION_8B;
case 69:return LL_ADC_RESOLUTION_6B;
case 70:return LL_ADC_DATA_ALIGN_RIGHT;
case 71:return LL_ADC_DATA_ALIGN_LEFT;
case 72:return LL_ADC_LP_MODE_NONE;
case 73:return LL_ADC_LP_AUTOWAIT;
case 74:return LL_ADC_OFFSET_1;
case 75:return LL_ADC_OFFSET_2;
case 76:return LL_ADC_OFFSET_3;
case 77:return LL_ADC_OFFSET_4;
case 78:return LL_ADC_OFFSET_DISABLE;
case 79:return LL_ADC_OFFSET_ENABLE;
case 80:return LL_ADC_OFFSET_SIGN_NEGATIVE;
case 81:return LL_ADC_OFFSET_SIGN_POSITIVE;
case 82:return LL_ADC_OFFSET_SATURATION_DISABLE;
case 83:return LL_ADC_OFFSET_SATURATION_ENABLE;
case 84:return LL_ADC_GROUP_REGULAR;
case 85:return LL_ADC_GROUP_INJECTED;
case 86:return LL_ADC_GROUP_REGULAR_INJECTED;
case 87:return LL_ADC_CHANNEL_0;
case 88:return LL_ADC_CHANNEL_1;
case 89:return LL_ADC_CHANNEL_2;
case 90:return LL_ADC_CHANNEL_3;
case 91:return LL_ADC_CHANNEL_4;
case 92:return LL_ADC_CHANNEL_5;
case 93:return LL_ADC_CHANNEL_6;
case 94:return LL_ADC_CHANNEL_7;
case 95:return LL_ADC_CHANNEL_8;
case 96:return LL_ADC_CHANNEL_9;
case 97:return LL_ADC_CHANNEL_10;
case 98:return LL_ADC_CHANNEL_11;
case 99:return LL_ADC_CHANNEL_12;
case 100:return LL_ADC_CHANNEL_13;
case 101:return LL_ADC_CHANNEL_14;
case 102:return LL_ADC_CHANNEL_15;
case 103:return LL_ADC_CHANNEL_16;
case 104:return LL_ADC_CHANNEL_17;
case 105:return LL_ADC_CHANNEL_18;
case 106:return LL_ADC_CHANNEL_VREFINT;
case 107:return LL_ADC_CHANNEL_TEMPSENSOR;
case 108:return LL_ADC_CHANNEL_VBAT;
case 109:return LL_ADC_CHANNEL_VDDCORE;
case 110:return LL_ADC_REG_TRIG_SOFTWARE;
case 111:return LL_ADC_REG_TRIG_EXT_TIM1_CH1;
case 112:return LL_ADC_REG_TRIG_EXT_TIM1_CH2;
case 113:return LL_ADC_REG_TRIG_EXT_TIM1_CH3;
case 114:return LL_ADC_REG_TRIG_EXT_TIM2_CH2;
case 115:return LL_ADC_REG_TRIG_EXT_TIM3_TRGO;
case 116:return LL_ADC_REG_TRIG_EXT_TIM4_CH4;
case 117:return LL_ADC_REG_TRIG_EXT_EXTI_LINE11;
case 118:return LL_ADC_REG_TRIG_EXT_TIM12_TRGO;
case 119:return LL_ADC_REG_TRIG_EXT_TIM9_TRGO;
case 120:return LL_ADC_REG_TRIG_EXT_TIM1_TRGO;
case 121:return LL_ADC_REG_TRIG_EXT_TIM1_TRGO2;
case 122:return LL_ADC_REG_TRIG_EXT_TIM2_TRGO;
case 123:return LL_ADC_REG_TRIG_EXT_TIM4_TRGO;
case 124:return LL_ADC_REG_TRIG_EXT_TIM6_TRGO;
case 125:return LL_ADC_REG_TRIG_EXT_TIM15_TRGO;
case 126:return LL_ADC_REG_TRIG_EXT_TIM3_CH4;
case 127:return LL_ADC_REG_TRIG_EXT_LPTIM1_CH1;
case 128:return LL_ADC_REG_TRIG_EXT_LPTIM2_CH1;
case 129:return LL_ADC_REG_TRIG_EXT_LPTIM3_CH1;
case 130:return LL_ADC_REG_TRIG_EXT_RISING;
case 131:return LL_ADC_REG_TRIG_EXT_FALLING;
case 132:return LL_ADC_REG_TRIG_EXT_RISINGFALLING;
case 133:return LL_ADC_REG_SAMPLING_MODE_NORMAL;
case 134:return LL_ADC_REG_SAMPLING_MODE_BULB;
case 135:return LL_ADC_REG_SAMPLING_MODE_TRIGGER_CONTROLED;
case 136:return LL_ADC_REG_CONV_SINGLE;
case 137:return LL_ADC_REG_CONV_CONTINUOUS;
case 138:return LL_ADC_REG_DMA_TRANSFER_NONE;
case 139:return LL_ADC_REG_DMA_TRANSFER_LIMITED;
case 140:return LL_ADC_REG_DMA_TRANSFER_UNLIMITED;
case 141:return LL_ADC_REG_MDF_TRANSFER_NONE;
case 142:return LL_ADC_REG_MDF_TRANSFER_ENABLE;
case 143:return LL_ADC_SAMPLINGTIME_COMMON_DEFAULT;
case 144:return LL_ADC_SAMPLINGTIME_COMMON_3C5_REPL_2C5;
case 145:return LL_ADC_REG_OVR_DATA_PRESERVED;
case 146:return LL_ADC_REG_OVR_DATA_OVERWRITTEN;
case 147:return LL_ADC_REG_SEQ_SCAN_DISABLE;
case 148:return LL_ADC_REG_SEQ_SCAN_ENABLE_2RANKS;
case 149:return LL_ADC_REG_SEQ_SCAN_ENABLE_3RANKS;
case 150:return LL_ADC_REG_SEQ_SCAN_ENABLE_4RANKS;
case 151:return LL_ADC_REG_SEQ_SCAN_ENABLE_5RANKS;
case 152:return LL_ADC_REG_SEQ_SCAN_ENABLE_6RANKS;
case 153:return LL_ADC_REG_SEQ_SCAN_ENABLE_7RANKS;
case 154:return LL_ADC_REG_SEQ_SCAN_ENABLE_8RANKS;
case 155:return LL_ADC_REG_SEQ_SCAN_ENABLE_9RANKS;
case 156:return LL_ADC_REG_SEQ_SCAN_ENABLE_10RANKS;
case 157:return LL_ADC_REG_SEQ_SCAN_ENABLE_11RANKS;
case 158:return LL_ADC_REG_SEQ_SCAN_ENABLE_12RANKS;
case 159:return LL_ADC_REG_SEQ_SCAN_ENABLE_13RANKS;
case 160:return LL_ADC_REG_SEQ_SCAN_ENABLE_14RANKS;
case 161:return LL_ADC_REG_SEQ_SCAN_ENABLE_15RANKS;
case 162:return LL_ADC_REG_SEQ_SCAN_ENABLE_16RANKS;
case 163:return LL_ADC_REG_SEQ_DISCONT_DISABLE;
case 164:return LL_ADC_REG_SEQ_DISCONT_1RANK;
case 165:return LL_ADC_REG_SEQ_DISCONT_2RANKS;
case 166:return LL_ADC_REG_SEQ_DISCONT_3RANKS;
case 167:return LL_ADC_REG_SEQ_DISCONT_4RANKS;
case 168:return LL_ADC_REG_SEQ_DISCONT_5RANKS;
case 169:return LL_ADC_REG_SEQ_DISCONT_6RANKS;
case 170:return LL_ADC_REG_SEQ_DISCONT_7RANKS;
case 171:return LL_ADC_REG_SEQ_DISCONT_8RANKS;
case 172:return LL_ADC_REG_RANK_1;
case 173:return LL_ADC_REG_RANK_2;
case 174:return LL_ADC_REG_RANK_3;
case 175:return LL_ADC_REG_RANK_4;
case 176:return LL_ADC_REG_RANK_5;
case 177:return LL_ADC_REG_RANK_6;
case 178:return LL_ADC_REG_RANK_7;
case 179:return LL_ADC_REG_RANK_8;
case 180:return LL_ADC_REG_RANK_9;
case 181:return LL_ADC_REG_RANK_10;
case 182:return LL_ADC_REG_RANK_11;
case 183:return LL_ADC_REG_RANK_12;
case 184:return LL_ADC_REG_RANK_13;
case 185:return LL_ADC_REG_RANK_14;
case 186:return LL_ADC_REG_RANK_15;
case 187:return LL_ADC_REG_RANK_16;
case 188:return LL_ADC_INJ_TRIG_SOFTWARE;
case 189:return LL_ADC_INJ_TRIG_EXT_TIM1_TRGO;
case 190:return LL_ADC_INJ_TRIG_EXT_TIM1_CH4;
case 191:return LL_ADC_INJ_TRIG_EXT_TIM2_TRGO;
case 192:return LL_ADC_INJ_TRIG_EXT_TIM2_CH1;
case 193:return LL_ADC_INJ_TRIG_EXT_TIM3_CH4;
case 194:return LL_ADC_INJ_TRIG_EXT_TIM4_TRGO;
case 195:return LL_ADC_INJ_TRIG_EXT_EXTI_LINE15;
case 196:return LL_ADC_INJ_TRIG_EXT_TIM9_CH1;
case 197:return LL_ADC_INJ_TRIG_EXT_TIM1_TRGO2;
case 198:return LL_ADC_INJ_TRIG_EXT_TIM12_TRGO;
case 199:return LL_ADC_INJ_TRIG_EXT_TIM9_TRGO;
case 200:return LL_ADC_INJ_TRIG_EXT_TIM3_CH3;
case 201:return LL_ADC_INJ_TRIG_EXT_TIM3_TRGO;
case 202:return LL_ADC_INJ_TRIG_EXT_TIM3_CH1;
case 203:return LL_ADC_INJ_TRIG_EXT_TIM6_TRGO;
case 204:return LL_ADC_INJ_TRIG_EXT_TIM15_TRGO;
case 205:return LL_ADC_INJ_TRIG_EXT_LPTIM1_CH2;
case 206:return LL_ADC_INJ_TRIG_EXT_LPTIM2_CH2;
case 207:return LL_ADC_INJ_TRIG_EXT_LPTIM3_CH1;
case 208:return LL_ADC_INJ_TRIG_EXT_RISING;
case 209:return LL_ADC_INJ_TRIG_EXT_FALLING;
case 210:return LL_ADC_INJ_TRIG_EXT_RISINGFALLING;
case 211:return LL_ADC_INJ_TRIG_INDEPENDENT;
case 212:return LL_ADC_INJ_TRIG_FROM_GRP_REGULAR;
case 213:return LL_ADC_INJ_QUEUE_2CONTEXTS_LAST_ACTIVE;
case 214:return LL_ADC_INJ_QUEUE_2CONTEXTS_END_EMPTY;
case 215:return LL_ADC_INJ_QUEUE_DISABLE;
case 216:return LL_ADC_INJ_SEQ_SCAN_DISABLE;
case 217:return LL_ADC_INJ_SEQ_SCAN_ENABLE_2RANKS;
case 218:return LL_ADC_INJ_SEQ_SCAN_ENABLE_3RANKS;
case 219:return LL_ADC_INJ_SEQ_SCAN_ENABLE_4RANKS;
case 220:return LL_ADC_INJ_SEQ_DISCONT_DISABLE;
case 221:return LL_ADC_INJ_SEQ_DISCONT_1RANK;
case 222:return LL_ADC_INJ_RANK_1;
case 223:return LL_ADC_INJ_RANK_2;
case 224:return LL_ADC_INJ_RANK_3;
case 225:return LL_ADC_INJ_RANK_4;
case 226:return LL_ADC_SAMPLINGTIME_2CYCLES_5;
case 227:return LL_ADC_SAMPLINGTIME_6CYCLES_5;
case 228:return LL_ADC_SAMPLINGTIME_12CYCLES_5;
case 229:return LL_ADC_SAMPLINGTIME_24CYCLES_5;
case 230:return LL_ADC_SAMPLINGTIME_47CYCLES_5;
case 231:return LL_ADC_SAMPLINGTIME_92CYCLES_5;
case 232:return LL_ADC_SAMPLINGTIME_247CYCLES_5;
case 233:return LL_ADC_SAMPLINGTIME_640CYCLES_5;
case 234:return LL_ADC_SINGLE_ENDED;
case 235:return LL_ADC_DIFFERENTIAL_ENDED;
case 236:return LL_ADC_BOTH_SINGLE_DIFF_ENDED;
case 237:return LL_ADC_AWD1;
case 238:return LL_ADC_AWD2;
case 239:return LL_ADC_AWD3;
case 240:return LL_ADC_AWD_DISABLE;
case 241:return LL_ADC_AWD_ALL_CHANNELS_REG;
case 242:return LL_ADC_AWD_ALL_CHANNELS_INJ;
case 243:return LL_ADC_AWD_ALL_CHANNELS_REG_INJ;
case 244:return LL_ADC_AWD_CHANNEL_0_REG;
case 245:return LL_ADC_AWD_CHANNEL_0_INJ;
case 246:return LL_ADC_AWD_CHANNEL_0_REG_INJ;
case 247:return LL_ADC_AWD_CHANNEL_1_REG;
case 248:return LL_ADC_AWD_CHANNEL_1_INJ;
case 249:return LL_ADC_AWD_CHANNEL_1_REG_INJ;
case 250:return LL_ADC_AWD_CHANNEL_2_REG;
case 251:return LL_ADC_AWD_CHANNEL_2_INJ;
case 252:return LL_ADC_AWD_CHANNEL_2_REG_INJ;
case 253:return LL_ADC_AWD_CHANNEL_3_REG;
case 254:return LL_ADC_AWD_CHANNEL_3_INJ;
case 255:return LL_ADC_AWD_CHANNEL_3_REG_INJ;
case 256:return LL_ADC_AWD_CHANNEL_4_REG;
case 257:return LL_ADC_AWD_CHANNEL_4_INJ;
case 258:return LL_ADC_AWD_CHANNEL_4_REG_INJ;
case 259:return LL_ADC_AWD_CHANNEL_5_REG;
case 260:return LL_ADC_AWD_CHANNEL_5_INJ;
case 261:return LL_ADC_AWD_CHANNEL_5_REG_INJ;
case 262:return LL_ADC_AWD_CHANNEL_6_REG;
case 263:return LL_ADC_AWD_CHANNEL_6_INJ;
case 264:return LL_ADC_AWD_CHANNEL_6_REG_INJ;
case 265:return LL_ADC_AWD_CHANNEL_7_REG;
case 266:return LL_ADC_AWD_CHANNEL_7_INJ;
case 267:return LL_ADC_AWD_CHANNEL_7_REG_INJ;
case 268:return LL_ADC_AWD_CHANNEL_8_REG;
case 269:return LL_ADC_AWD_CHANNEL_8_INJ;
case 270:return LL_ADC_AWD_CHANNEL_8_REG_INJ;
case 271:return LL_ADC_AWD_CHANNEL_9_REG;
case 272:return LL_ADC_AWD_CHANNEL_9_INJ;
case 273:return LL_ADC_AWD_CHANNEL_9_REG_INJ;
case 274:return LL_ADC_AWD_CHANNEL_10_REG;
case 275:return LL_ADC_AWD_CHANNEL_10_INJ;
case 276:return LL_ADC_AWD_CHANNEL_10_REG_INJ;
case 277:return LL_ADC_AWD_CHANNEL_11_REG;
case 278:return LL_ADC_AWD_CHANNEL_11_INJ;
case 279:return LL_ADC_AWD_CHANNEL_11_REG_INJ;
case 280:return LL_ADC_AWD_CHANNEL_12_REG;
case 281:return LL_ADC_AWD_CHANNEL_12_INJ;
case 282:return LL_ADC_AWD_CHANNEL_12_REG_INJ;
case 283:return LL_ADC_AWD_CHANNEL_13_REG;
case 284:return LL_ADC_AWD_CHANNEL_13_INJ;
case 285:return LL_ADC_AWD_CHANNEL_13_REG_INJ;
case 286:return LL_ADC_AWD_CHANNEL_14_REG;
case 287:return LL_ADC_AWD_CHANNEL_14_INJ;
case 288:return LL_ADC_AWD_CHANNEL_14_REG_INJ;
case 289:return LL_ADC_AWD_CHANNEL_15_REG;
case 290:return LL_ADC_AWD_CHANNEL_15_INJ;
case 291:return LL_ADC_AWD_CHANNEL_15_REG_INJ;
case 292:return LL_ADC_AWD_CHANNEL_16_REG;
case 293:return LL_ADC_AWD_CHANNEL_16_INJ;
case 294:return LL_ADC_AWD_CHANNEL_16_REG_INJ;
case 295:return LL_ADC_AWD_CHANNEL_17_REG;
case 296:return LL_ADC_AWD_CHANNEL_17_INJ;
case 297:return LL_ADC_AWD_CHANNEL_17_REG_INJ;
case 298:return LL_ADC_AWD_CHANNEL_18_REG;
case 299:return LL_ADC_AWD_CHANNEL_18_INJ;
case 300:return LL_ADC_AWD_CHANNEL_18_REG_INJ;
case 301:return LL_ADC_AWD_CH_VREFINT_REG;
case 302:return LL_ADC_AWD_CH_VREFINT_INJ;
case 303:return LL_ADC_AWD_CH_VREFINT_REG_INJ;
case 304:return LL_ADC_AWD_CH_TEMPSENSOR_REG;
case 305:return LL_ADC_AWD_CH_TEMPSENSOR_INJ;
case 306:return LL_ADC_AWD_CH_TEMPSENSOR_REG_INJ;
case 307:return LL_ADC_AWD_CH_VBAT_REG;
case 308:return LL_ADC_AWD_CH_VBAT_INJ;
case 309:return LL_ADC_AWD_CH_VBAT_REG_INJ;
case 310:return LL_ADC_AWD_CH_VDDCORE_REG;
case 311:return LL_ADC_AWD_CH_VDDCORE_INJ;
case 312:return LL_ADC_AWD_CH_VDDCORE_REG_INJ;
case 313:return LL_ADC_AWD_THRESHOLD_HIGH;
case 314:return LL_ADC_AWD_THRESHOLD_LOW;
case 315:return LL_ADC_AWD_THRESHOLDS_HIGH_LOW;
case 316:return LL_ADC_AWD_FILTERING_NONE;
case 317:return LL_ADC_AWD_FILTERING_2SAMPLES;
case 318:return LL_ADC_AWD_FILTERING_3SAMPLES;
case 319:return LL_ADC_AWD_FILTERING_4SAMPLES;
case 320:return LL_ADC_AWD_FILTERING_5SAMPLES;
case 321:return LL_ADC_AWD_FILTERING_6SAMPLES;
case 322:return LL_ADC_AWD_FILTERING_7SAMPLES;
case 323:return LL_ADC_AWD_FILTERING_8SAMPLES;
case 324:return LL_ADC_OVS_DISABLE;
case 325:return LL_ADC_OVS_GRP_REGULAR_CONTINUED;
case 326:return LL_ADC_OVS_GRP_REGULAR_RESUMED;
case 327:return LL_ADC_OVS_GRP_INJECTED;
case 328:return LL_ADC_OVS_GRP_INJ_REG_RESUMED;
case 329:return LL_ADC_OVS_REG_CONT;
case 330:return LL_ADC_OVS_REG_DISCONT;
case 331:return LL_ADC_OVS_RATIO_2;
case 332:return LL_ADC_OVS_RATIO_4;
case 333:return LL_ADC_OVS_RATIO_8;
case 334:return LL_ADC_OVS_RATIO_16;
case 335:return LL_ADC_OVS_RATIO_32;
case 336:return LL_ADC_OVS_RATIO_64;
case 337:return LL_ADC_OVS_RATIO_128;
case 338:return LL_ADC_OVS_RATIO_256;
case 339:return LL_ADC_OVS_SHIFT_NONE;
case 340:return LL_ADC_OVS_SHIFT_RIGHT_1;
case 341:return LL_ADC_OVS_SHIFT_RIGHT_2;
case 342:return LL_ADC_OVS_SHIFT_RIGHT_3;
case 343:return LL_ADC_OVS_SHIFT_RIGHT_4;
case 344:return LL_ADC_OVS_SHIFT_RIGHT_5;
case 345:return LL_ADC_OVS_SHIFT_RIGHT_6;
case 346:return LL_ADC_OVS_SHIFT_RIGHT_7;
case 347:return LL_ADC_OVS_SHIFT_RIGHT_8;
case 348:return LL_ADC_MULTI_INDEPENDENT;
case 349:return LL_ADC_MULTI_DUAL_REG_SIMULT;
case 350:return LL_ADC_MULTI_DUAL_REG_INTERL;
case 351:return LL_ADC_MULTI_DUAL_INJ_SIMULT;
case 352:return LL_ADC_MULTI_DUAL_INJ_ALTERN;
case 353:return LL_ADC_MULTI_DUAL_REG_SIM_INJ_SIM;
case 354:return LL_ADC_MULTI_DUAL_REG_SIM_INJ_ALT;
case 355:return LL_ADC_MULTI_DUAL_REG_INT_INJ_SIM;
case 356:return LL_ADC_MULTI_REG_DMA_EACH_ADC;
case 357:return LL_ADC_MULTI_REG_DMA_LIMIT_RES12_10B;
case 358:return LL_ADC_MULTI_REG_DMA_LIMIT_RES8_6B;
case 359:return LL_ADC_MULTI_REG_DMA_UNLMT_RES12_10B;
case 360:return LL_ADC_MULTI_REG_DMA_UNLMT_RES8_6B;
case 361:return LL_ADC_MULTI_TWOSMP_DELAY_1CYCLE;
case 362:return LL_ADC_MULTI_TWOSMP_DELAY_2CYCLES;
case 363:return LL_ADC_MULTI_TWOSMP_DELAY_3CYCLES;
case 364:return LL_ADC_MULTI_TWOSMP_DELAY_4CYCLES;
case 365:return LL_ADC_MULTI_TWOSMP_DELAY_5CYCLES;
case 366:return LL_ADC_MULTI_TWOSMP_DELAY_6CYCLES;
case 367:return LL_ADC_MULTI_TWOSMP_DELAY_7CYCLES;
case 368:return LL_ADC_MULTI_TWOSMP_DELAY_8CYCLES;
case 369:return LL_ADC_MULTI_TWOSMP_DELAY_9CYCLES;
case 370:return LL_ADC_MULTI_TWOSMP_DELAY_10CYCLES;
case 371:return LL_ADC_MULTI_TWOSMP_DELAY_11CYCLES;
case 372:return LL_ADC_MULTI_TWOSMP_DELAY_12CYCLES;
case 373:return LL_ADC_MULTI_MASTER;
case 374:return LL_ADC_MULTI_SLAVE;
case 375:return LL_ADC_MULTI_MASTER_SLAVE;
case 376:return LL_ADC_TEMPERATURE_CALC_ERROR;
case 377:return LL_ADC_DELAY_INTERNAL_REGUL_STAB_US;
case 378:return LL_ADC_DELAY_VREFINT_STAB_US;
case 379:return LL_ADC_DELAY_TEMPSENSOR_STAB_US;
case 380:return LL_ADC_DELAY_TEMPSENSOR_BUFFER_STAB_US;
case 381:return LL_ADC_DELAY_CALIB_ENABLE_ADC_CYCLES;
default:abort();}}
