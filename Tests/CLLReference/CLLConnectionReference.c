#include "include/CLLConnectionReference.h"
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "Upstream/Connection/Trace/stm32h7rsxx_ll_ucpd.h"
#include "Upstream/Connection/Trace/stm32h7rsxx_ll_dlyb.h"
#include "Upstream/Connection/Trace/stm32h7rsxx_ll_ucpd.inc"
#include "Upstream/Connection/Trace/stm32h7rsxx_ll_dlyb.inc"

struct CL59State {uint32_t cells[512],count,reads,salt,instance,measure,cfgrReads,tickValue,readyAfter,targetUnit,length,tickStep;CL59Access trace[2048];};
_Thread_local uint32_t *CL59_Cells;
static _Thread_local CL59State *current;
CL59State *CL59_Create(void){return calloc(1,sizeof(CL59State));}
void CL59_Destroy(CL59State *s){free(s);}
void CL59_Reset(CL59State *s,uint32_t seed,uint32_t salt,uint32_t instance){current=s;CL59_Cells=s->cells;for(uint32_t i=0;i<512;i++)s->cells[i]=seed^(i*0x9E3779B9U);s->count=0;s->reads=0;s->salt=salt;s->instance=instance;s->measure=0;s->cfgrReads=0;s->tickValue=0;}
static void record(uint32_t i,uint32_t v,uint32_t k){assert(i<512&&current->count<2048);current->trace[current->count++]=(CL59Access){i,v,k};}
static uint32_t indexOf(volatile const uint32_t *p){uintptr_t d=(uintptr_t)p-(uintptr_t)CL59_Cells;assert(d<2048&&d%4==0);return (uint32_t)d/4;}
uint32_t CL59_Read(volatile const uint32_t *p){uint32_t i=indexOf(p),v=*p^(current->salt*current->reads++);if(current->measure && i==(current->instance?49U:33U)){current->cfgrReads++;v=*p&0x7F0FU;if(current->cfgrReads>=current->readyAfter){v|=0x80000000U;if(((*p>>8)&0x7FU)>=current->targetUnit)v|=current->length<<16;}}record(i,v,0);return v;}
void CL59_Write(volatile uint32_t *p,uint32_t v){uint32_t i=indexOf(p);record(i,v,1);*p=v;if(i==(current->instance?49U:33U))current->cfgrReads=0;}
uint32_t CL59_Tick(void){uint32_t v=current->tickValue;current->tickValue+=current->tickStep;record(511,v,2);return v;}
uint32_t *CL59_GetCells(CL59State *s){return s->cells;}
const CL59Access *CL59_GetTrace(CL59State *s){return s->trace;}
uint32_t CL59_GetTraceCount(CL59State *s){return s->count;}
uint32_t CL59_Run(CL59State *s,uint32_t op,const uint32_t *args){current=s;CL59_Cells=s->cells;if(op==134){s->measure=1;s->readyAfter=args[2];s->targetUnit=args[3];s->length=args[4]&0xFFFU;s->tickStep=args[5]?args[5]:1;s->tickValue=args[6];}switch(op){
case 0:{LL_UCPD_Enable((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 1:{LL_UCPD_Disable((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 2:{uint32_t result=LL_UCPD_IsEnabled((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 3:{LL_UCPD_SetRxOrderSet((UCPD_TypeDef *)(s->cells+(s->instance?128:0)), (uint32_t)args[0]); return 0;}
case 4:{LL_UCPD_SetPSCClk((UCPD_TypeDef *)(s->cells+(s->instance?128:0)), (uint32_t)args[0]); return 0;}
case 5:{LL_UCPD_SetTransWin((UCPD_TypeDef *)(s->cells+(s->instance?128:0)), (uint32_t)args[0]); return 0;}
case 6:{LL_UCPD_SetIfrGap((UCPD_TypeDef *)(s->cells+(s->instance?128:0)), (uint32_t)args[0]); return 0;}
case 7:{LL_UCPD_SetHbitClockDiv((UCPD_TypeDef *)(s->cells+(s->instance?128:0)), (uint32_t)args[0]); return 0;}
case 8:{LL_UCPD_RxAnalogFilterEnable((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 9:{LL_UCPD_RxAnalogFilterDisable((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 10:{LL_UCPD_WakeUpEnable((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 11:{LL_UCPD_WakeUpDisable((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 12:{LL_UCPD_ForceClockEnable((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 13:{LL_UCPD_ForceClockDisable((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 14:{LL_UCPD_RxFilterEnable((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 15:{LL_UCPD_RxFilterDisable((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 16:{LL_UCPD_TypeCDetectionCC2Enable((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 17:{LL_UCPD_TypeCDetectionCC2Disable((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 18:{LL_UCPD_TypeCDetectionCC1Enable((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 19:{LL_UCPD_TypeCDetectionCC1Disable((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 20:{LL_UCPD_VconnDischargeEnable((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 21:{LL_UCPD_VconnDischargeDisable((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 22:{LL_UCPD_SignalFRSTX((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 23:{LL_UCPD_FRSDetectionEnable((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 24:{LL_UCPD_FRSDetectionDisable((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 25:{LL_UCPD_SetccEnable((UCPD_TypeDef *)(s->cells+(s->instance?128:0)), (uint32_t)args[0]); return 0;}
case 26:{LL_UCPD_SetSNKRole((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 27:{LL_UCPD_SetSRCRole((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 28:{uint32_t result=LL_UCPD_GetRole((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 29:{LL_UCPD_SetRpResistor((UCPD_TypeDef *)(s->cells+(s->instance?128:0)), (uint32_t)args[0]); return 0;}
case 30:{LL_UCPD_SetCCPin((UCPD_TypeDef *)(s->cells+(s->instance?128:0)), (uint32_t)args[0]); return 0;}
case 31:{LL_UCPD_RxEnable((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 32:{LL_UCPD_RxDisable((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 33:{LL_UCPD_SetRxMode((UCPD_TypeDef *)(s->cells+(s->instance?128:0)), (uint32_t)args[0]); return 0;}
case 34:{LL_UCPD_SendHardReset((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 35:{LL_UCPD_SendMessage((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 36:{LL_UCPD_SetTxMode((UCPD_TypeDef *)(s->cells+(s->instance?128:0)), (uint32_t)args[0]); return 0;}
case 37:{LL_UCPD_EnableIT_FRS((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 38:{LL_UCPD_EnableIT_TypeCEventCC2((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 39:{LL_UCPD_EnableIT_TypeCEventCC1((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 40:{LL_UCPD_EnableIT_RxMsgEnd((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 41:{LL_UCPD_EnableIT_RxOvr((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 42:{LL_UCPD_EnableIT_RxHRST((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 43:{LL_UCPD_EnableIT_RxOrderSet((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 44:{LL_UCPD_EnableIT_RxNE((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 45:{LL_UCPD_EnableIT_TxUND((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 46:{LL_UCPD_EnableIT_TxHRSTSENT((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 47:{LL_UCPD_EnableIT_TxHRSTDISC((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 48:{LL_UCPD_EnableIT_TxMSGABT((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 49:{LL_UCPD_EnableIT_TxMSGSENT((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 50:{LL_UCPD_EnableIT_TxMSGDISC((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 51:{LL_UCPD_EnableIT_TxIS((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 52:{LL_UCPD_DisableIT_FRS((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 53:{LL_UCPD_DisableIT_TypeCEventCC2((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 54:{LL_UCPD_DisableIT_TypeCEventCC1((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 55:{LL_UCPD_DisableIT_RxMsgEnd((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 56:{LL_UCPD_DisableIT_RxOvr((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 57:{LL_UCPD_DisableIT_RxHRST((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 58:{LL_UCPD_DisableIT_RxOrderSet((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 59:{LL_UCPD_DisableIT_RxNE((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 60:{LL_UCPD_DisableIT_TxUND((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 61:{LL_UCPD_DisableIT_TxHRSTSENT((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 62:{LL_UCPD_DisableIT_TxHRSTDISC((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 63:{LL_UCPD_DisableIT_TxMSGABT((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 64:{LL_UCPD_DisableIT_TxMSGSENT((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 65:{LL_UCPD_DisableIT_TxMSGDISC((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 66:{LL_UCPD_DisableIT_TxIS((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 67:{uint32_t result=LL_UCPD_IsEnableIT_FRS((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 68:{uint32_t result=LL_UCPD_IsEnableIT_TypeCEventCC2((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 69:{uint32_t result=LL_UCPD_IsEnableIT_TypeCEventCC1((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 70:{uint32_t result=LL_UCPD_IsEnableIT_RxMsgEnd((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 71:{uint32_t result=LL_UCPD_IsEnableIT_RxOvr((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 72:{uint32_t result=LL_UCPD_IsEnableIT_RxHRST((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 73:{uint32_t result=LL_UCPD_IsEnableIT_RxOrderSet((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 74:{uint32_t result=LL_UCPD_IsEnableIT_RxNE((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 75:{uint32_t result=LL_UCPD_IsEnableIT_TxUND((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 76:{uint32_t result=LL_UCPD_IsEnableIT_TxHRSTSENT((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 77:{uint32_t result=LL_UCPD_IsEnableIT_TxHRSTDISC((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 78:{uint32_t result=LL_UCPD_IsEnableIT_TxMSGABT((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 79:{uint32_t result=LL_UCPD_IsEnableIT_TxMSGSENT((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 80:{uint32_t result=LL_UCPD_IsEnableIT_TxMSGDISC((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 81:{uint32_t result=LL_UCPD_IsEnableIT_TxIS((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 82:{LL_UCPD_ClearFlag_FRS((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 83:{LL_UCPD_ClearFlag_TypeCEventCC2((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 84:{LL_UCPD_ClearFlag_TypeCEventCC1((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 85:{LL_UCPD_ClearFlag_RxMsgEnd((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 86:{LL_UCPD_ClearFlag_RxOvr((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 87:{LL_UCPD_ClearFlag_RxHRST((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 88:{LL_UCPD_ClearFlag_RxOrderSet((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 89:{LL_UCPD_ClearFlag_TxUND((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 90:{LL_UCPD_ClearFlag_TxHRSTSENT((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 91:{LL_UCPD_ClearFlag_TxHRSTDISC((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 92:{LL_UCPD_ClearFlag_TxMSGABT((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 93:{LL_UCPD_ClearFlag_TxMSGSENT((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 94:{LL_UCPD_ClearFlag_TxMSGDISC((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 95:{uint32_t result=LL_UCPD_IsActiveFlag_FRS((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 96:{uint32_t result=LL_UCPD_IsActiveFlag_TypeCEventCC2((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 97:{uint32_t result=LL_UCPD_IsActiveFlag_TypeCEventCC1((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 98:{uint32_t result=LL_UCPD_IsActiveFlag_RxErr((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 99:{uint32_t result=LL_UCPD_IsActiveFlag_RxMsgEnd((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 100:{uint32_t result=LL_UCPD_IsActiveFlag_RxOvr((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 101:{uint32_t result=LL_UCPD_IsActiveFlag_RxHRST((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 102:{uint32_t result=LL_UCPD_IsActiveFlag_RxOrderSet((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 103:{uint32_t result=LL_UCPD_IsActiveFlag_RxNE((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 104:{uint32_t result=LL_UCPD_IsActiveFlag_TxUND((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 105:{uint32_t result=LL_UCPD_IsActiveFlag_TxHRSTSENT((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 106:{uint32_t result=LL_UCPD_IsActiveFlag_TxHRSTDISC((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 107:{uint32_t result=LL_UCPD_IsActiveFlag_TxMSGABT((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 108:{uint32_t result=LL_UCPD_IsActiveFlag_TxMSGSENT((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 109:{uint32_t result=LL_UCPD_IsActiveFlag_TxMSGDISC((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 110:{uint32_t result=LL_UCPD_IsActiveFlag_TxIS((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 111:{uint32_t result=LL_UCPD_GetTypeCVstateCC2((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 112:{uint32_t result=LL_UCPD_GetTypeCVstateCC1((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 113:{LL_UCPD_RxDMAEnable((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 114:{LL_UCPD_RxDMADisable((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 115:{LL_UCPD_TxDMAEnable((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 116:{LL_UCPD_TxDMADisable((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return 0;}
case 117:{uint32_t result=LL_UCPD_IsEnabledTxDMA((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 118:{uint32_t result=LL_UCPD_IsEnabledRxDMA((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 119:{LL_UCPD_WriteTxOrderSet((UCPD_TypeDef *)(s->cells+(s->instance?128:0)), (uint32_t)args[0]); return 0;}
case 120:{LL_UCPD_WriteTxPaySize((UCPD_TypeDef *)(s->cells+(s->instance?128:0)), (uint32_t)args[0]); return 0;}
case 121:{LL_UCPD_WriteData((UCPD_TypeDef *)(s->cells+(s->instance?128:0)), (uint8_t)args[0]); return 0;}
case 122:{uint32_t result=LL_UCPD_ReadRxOrderSet((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 123:{uint32_t result=LL_UCPD_ReadRxPaySize((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 124:{uint32_t result=LL_UCPD_ReadData((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 125:{LL_UCPD_SetRxOrdExt1((UCPD_TypeDef *)(s->cells+(s->instance?128:0)), (uint32_t)args[0]); return 0;}
case 126:{LL_UCPD_SetRxOrdExt2((UCPD_TypeDef *)(s->cells+(s->instance?128:0)), (uint32_t)args[0]); return 0;}
case 127:{uint32_t result=LL_UCPD_DeInit((UCPD_TypeDef *)(s->cells+(s->instance?128:0))); return result;}
case 128:{LL_UCPD_InitTypeDef v1={0}; v1.psc_ucpdclk=(uint32_t)args[0]; v1.transwin=(uint32_t)args[1]; v1.IfrGap=(uint32_t)args[2]; v1.HbitClockDiv=(uint32_t)args[3]; uint32_t result=LL_UCPD_Init((UCPD_TypeDef *)(s->cells+(s->instance?128:0)), &v1); s->cells[384]=v1.psc_ucpdclk; s->cells[385]=v1.transwin; s->cells[386]=v1.IfrGap; s->cells[387]=v1.HbitClockDiv; return result;}
case 129:{LL_UCPD_InitTypeDef v0={0}; v0.psc_ucpdclk=(uint32_t)args[0]; v0.transwin=(uint32_t)args[1]; v0.IfrGap=(uint32_t)args[2]; v0.HbitClockDiv=(uint32_t)args[3]; LL_UCPD_StructInit(&v0); s->cells[384]=v0.psc_ucpdclk; s->cells[385]=v0.transwin; s->cells[386]=v0.IfrGap; s->cells[387]=v0.HbitClockDiv; return 0;}
case 130:{LL_DLYB_Enable(s->instance?DLYB_SDMMC2:DLYB_SDMMC1); return 0;}
case 131:{LL_DLYB_Disable(s->instance?DLYB_SDMMC2:DLYB_SDMMC1); return 0;}
case 132:{LL_DLYB_CfgTypeDef v1={0}; v1.Units=(uint32_t)args[0]; v1.PhaseSel=(uint32_t)args[1]; LL_DLYB_SetDelay(s->instance?DLYB_SDMMC2:DLYB_SDMMC1, &v1); s->cells[384]=v1.Units; s->cells[385]=v1.PhaseSel; return 0;}
case 133:{LL_DLYB_CfgTypeDef v1={0}; v1.Units=(uint32_t)args[0]; v1.PhaseSel=(uint32_t)args[1]; LL_DLYB_GetDelay(s->instance?DLYB_SDMMC2:DLYB_SDMMC1, &v1); s->cells[384]=v1.Units; s->cells[385]=v1.PhaseSel; return 0;}
case 134:{LL_DLYB_CfgTypeDef v1={0}; v1.Units=(uint32_t)args[0]; v1.PhaseSel=(uint32_t)args[1]; uint32_t result=LL_DLYB_GetClockPeriod(s->instance?DLYB_SDMMC2:DLYB_SDMMC1, &v1); s->cells[384]=v1.Units; s->cells[385]=v1.PhaseSel; return result;}
case 135:{LL_UCPD_WriteReg((UCPD_TypeDef *)(s->cells+(s->instance?128:0)),CFG1,args[0]);return LL_UCPD_ReadReg((UCPD_TypeDef *)(s->cells+(s->instance?128:0)),CFG1);}default:abort();}}
uint32_t CL59_Constant(uint32_t i){switch(i){
case 0:return LL_UCPD_SR_TXIS;
case 1:return LL_UCPD_SR_TXMSGDISC;
case 2:return LL_UCPD_SR_TXMSGSENT;
case 3:return LL_UCPD_SR_TXMSGABT;
case 4:return LL_UCPD_SR_HRSTDISC;
case 5:return LL_UCPD_SR_HRSTSENT;
case 6:return LL_UCPD_SR_TXUND;
case 7:return LL_UCPD_SR_RXNE;
case 8:return LL_UCPD_SR_RXORDDET;
case 9:return LL_UCPD_SR_RXHRSTDET;
case 10:return LL_UCPD_SR_RXOVR;
case 11:return LL_UCPD_SR_RXMSGEND;
case 12:return LL_UCPD_SR_RXERR;
case 13:return LL_UCPD_SR_TYPECEVT1;
case 14:return LL_UCPD_SR_TYPECEVT2;
case 15:return LL_UCPD_SR_TYPEC_VSTATE_CC1;
case 16:return LL_UCPD_SR_TYPEC_VSTATE_CC2;
case 17:return LL_UCPD_SR_FRSEVT;
case 18:return LL_UCPD_IMR_TXIS;
case 19:return LL_UCPD_IMR_TXMSGDISC;
case 20:return LL_UCPD_IMR_TXMSGSENT;
case 21:return LL_UCPD_IMR_TXMSGABT;
case 22:return LL_UCPD_IMR_HRSTDISC;
case 23:return LL_UCPD_IMR_HRSTSENT;
case 24:return LL_UCPD_IMR_TXUND;
case 25:return LL_UCPD_IMR_RXNE;
case 26:return LL_UCPD_IMR_RXORDDET;
case 27:return LL_UCPD_IMR_RXHRSTDET;
case 28:return LL_UCPD_IMR_RXOVR;
case 29:return LL_UCPD_IMR_RXMSGEND;
case 30:return LL_UCPD_IMR_TYPECEVT1;
case 31:return LL_UCPD_IMR_TYPECEVT2;
case 32:return LL_UCPD_IMR_FRSEVT;
case 33:return LL_UCPD_SYNC1;
case 34:return LL_UCPD_SYNC2;
case 35:return LL_UCPD_SYNC3;
case 36:return LL_UCPD_RST1;
case 37:return LL_UCPD_RST2;
case 38:return LL_UCPD_EOP;
case 39:return LL_UCPD_ORDERED_SET_SOP;
case 40:return LL_UCPD_ORDERED_SET_SOP1;
case 41:return LL_UCPD_ORDERED_SET_SOP2;
case 42:return LL_UCPD_ORDERED_SET_HARD_RESET;
case 43:return LL_UCPD_ORDERED_SET_CABLE_RESET;
case 44:return LL_UCPD_ORDERED_SET_SOP1_DEBUG;
case 45:return LL_UCPD_ORDERED_SET_SOP2_DEBUG;
case 46:return LL_UCPD_ROLE_SNK;
case 47:return LL_UCPD_ROLE_SRC;
case 48:return LL_UCPD_RESISTOR_DEFAULT;
case 49:return LL_UCPD_RESISTOR_1_5A;
case 50:return LL_UCPD_RESISTOR_3_0A;
case 51:return LL_UCPD_RESISTOR_NONE;
case 52:return LL_UCPD_ORDERSET_SOP;
case 53:return LL_UCPD_ORDERSET_SOP1;
case 54:return LL_UCPD_ORDERSET_SOP2;
case 55:return LL_UCPD_ORDERSET_HARDRST;
case 56:return LL_UCPD_ORDERSET_CABLERST;
case 57:return LL_UCPD_ORDERSET_SOP1_DEBUG;
case 58:return LL_UCPD_ORDERSET_SOP2_DEBUG;
case 59:return LL_UCPD_ORDERSET_SOP_EXT1;
case 60:return LL_UCPD_ORDERSET_SOP_EXT2;
case 61:return LL_UCPD_SNK_CC1_VOPEN;
case 62:return LL_UCPD_SNK_CC1_VRP;
case 63:return LL_UCPD_SNK_CC1_VRP15A;
case 64:return LL_UCPD_SNK_CC1_VRP30A;
case 65:return LL_UCPD_SNK_CC2_VOPEN;
case 66:return LL_UCPD_SNK_CC2_VRP;
case 67:return LL_UCPD_SNK_CC2_VRP15A;
case 68:return LL_UCPD_SNK_CC2_VRP30A;
case 69:return LL_UCPD_SRC_CC1_VRA;
case 70:return LL_UCPD_SRC_CC1_VRD;
case 71:return LL_UCPD_SRC_CC1_OPEN;
case 72:return LL_UCPD_SRC_CC2_VRA;
case 73:return LL_UCPD_SRC_CC2_VRD;
case 74:return LL_UCPD_SRC_CC2_OPEN;
case 75:return LL_UCPD_PSC_DIV1;
case 76:return LL_UCPD_PSC_DIV2;
case 77:return LL_UCPD_PSC_DIV4;
case 78:return LL_UCPD_PSC_DIV8;
case 79:return LL_UCPD_PSC_DIV16;
case 80:return LL_UCPD_CCENABLE_NONE;
case 81:return LL_UCPD_CCENABLE_CC1;
case 82:return LL_UCPD_CCENABLE_CC2;
case 83:return LL_UCPD_CCENABLE_CC1CC2;
case 84:return LL_UCPD_CCPIN_CC1;
case 85:return LL_UCPD_CCPIN_CC2;
case 86:return LL_UCPD_RXMODE_NORMAL;
case 87:return LL_UCPD_RXMODE_BIST_TEST_DATA;
case 88:return LL_UCPD_TXMODE_NORMAL;
case 89:return LL_UCPD_TXMODE_CABLE_RESET;
case 90:return LL_UCPD_TXMODE_BIST_CARRIER2;
case 91:return LL_UCPD_RXORDSET_SOP;
case 92:return LL_UCPD_RXORDSET_SOP1;
case 93:return LL_UCPD_RXORDSET_SOP2;
case 94:return LL_UCPD_RXORDSET_SOP1_DEBUG;
case 95:return LL_UCPD_RXORDSET_SOP2_DEBUG;
case 96:return LL_UCPD_RXORDSET_CABLE_RESET;
case 97:return LL_UCPD_RXORDSET_SOPEXT1;
case 98:return LL_UCPD_RXORDSET_SOPEXT2;
case 99:return DLYB_MAX_UNIT;
case 100:return DLYB_MAX_SELECT;
case 101:return DLYB_FLAG_LNGF;
default:abort();}}
