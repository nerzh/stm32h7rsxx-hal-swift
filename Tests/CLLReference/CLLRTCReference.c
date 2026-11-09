#include "include/CLLRTCReference.h"
#include <stdlib.h>
#include <assert.h>
#include "Upstream/RTC/Trace/stm32h7rsxx_ll_rtc.h"
#include "Upstream/RTC/Trace/stm32h7rsxx_ll_iwdg.h"
#include "Upstream/RTC/Trace/stm32h7rsxx_ll_wwdg.h"
#include "Upstream/RTC/Trace/stm32h7rsxx_ll_rtc.inc"
struct CL57State {uint32_t cells[512],count,reads,salt,instance,statusReads,ticks;CL57Access trace[16384];};
_Thread_local uint32_t *CL57_Cells;
static _Thread_local CL57State *current;
CL57State *CL57_Create(void){return calloc(1,sizeof(CL57State));}
void CL57_Destroy(CL57State *s){free(s);}
void CL57_Reset(CL57State *s,uint32_t seed,uint32_t salt,uint32_t instance){current=s;CL57_Cells=s->cells;for(uint32_t i=0;i<512;i++)s->cells[i]=seed^(i*0x9E3779B9U);s->count=0;s->reads=0;s->salt=salt;s->instance=instance;s->statusReads=0;s->ticks=0;}
static void record(uint32_t i,uint32_t v,uint32_t k){assert(i<512&&current->count<16384);current->trace[current->count++]=(CL57Access){i,v,k};}
static uint32_t indexOf(volatile const uint32_t *p){uintptr_t d=(uintptr_t)p-(uintptr_t)CL57_Cells;assert(d<2048&&d%4==0);return (uint32_t)d/4;}
uint32_t CL57_Read(volatile const uint32_t *p){uint32_t i=indexOf(p),v=*p^(current->salt*current->reads++);if(i==3){current->statusReads++;v&=~0x60U;switch(current->instance){case 0:v|=0x60;break;case 1:if(current->statusReads>=3)v|=0x40;if(current->statusReads>=6)v|=0x20;break;case 2:break;case 3:v|=0x40;break;case 4:if(current->ticks>=1000)v|=0x60;break;case 5:if(current->statusReads>=10)v|=0x60;break;default:abort();}}if(i==224){current->ticks++;v=current->instance==5&&current->ticks%4!=0?0:0x10000;}record(i,v,0);return v;}
void CL57_Write(volatile uint32_t *p,uint32_t v){record(indexOf(p),v,1);*p=v;}
uint32_t *CL57_GetCells(CL57State *s){return s->cells;}
const CL57Access *CL57_GetTrace(CL57State *s){return s->trace;}
uint32_t CL57_GetTraceCount(CL57State *s){return s->count;}
uint32_t CL57_Run(CL57State *s,uint32_t op,const uint32_t *args){current=s;CL57_Cells=s->cells;switch(op){
case 0:{LL_RTC_SetHourFormat(RTC, (uint32_t)args[0]); return 0;}
case 1:{uint32_t result=LL_RTC_GetHourFormat(RTC); return result;}
case 2:{LL_RTC_SetAlarmOutEvent(RTC, (uint32_t)args[0]); return 0;}
case 3:{uint32_t result=LL_RTC_GetAlarmOutEvent(RTC); return result;}
case 4:{LL_RTC_SetAlarmOutputType(RTC, (uint32_t)args[0]); return 0;}
case 5:{uint32_t result=LL_RTC_GetAlarmOutputType(RTC); return result;}
case 6:{LL_RTC_EnableInitMode(RTC); return 0;}
case 7:{LL_RTC_DisableInitMode(RTC); return 0;}
case 8:{LL_RTC_SetBinaryMode(RTC, (uint32_t)args[0]); return 0;}
case 9:{uint32_t result=LL_RTC_GetBinaryMode(RTC); return result;}
case 10:{LL_RTC_SetBinMixBCDU(RTC, (uint32_t)args[0]); return 0;}
case 11:{uint32_t result=LL_RTC_GetBinMixBCDU(RTC); return result;}
case 12:{LL_RTC_SetOutputPolarity(RTC, (uint32_t)args[0]); return 0;}
case 13:{uint32_t result=LL_RTC_GetOutputPolarity(RTC); return result;}
case 14:{LL_RTC_EnableShadowRegBypass(RTC); return 0;}
case 15:{LL_RTC_DisableShadowRegBypass(RTC); return 0;}
case 16:{uint32_t result=LL_RTC_IsShadowRegBypassEnabled(RTC); return result;}
case 17:{LL_RTC_EnableRefClock(RTC); return 0;}
case 18:{LL_RTC_DisableRefClock(RTC); return 0;}
case 19:{LL_RTC_SetAsynchPrescaler(RTC, (uint32_t)args[0]); return 0;}
case 20:{LL_RTC_SetSynchPrescaler(RTC, (uint32_t)args[0]); return 0;}
case 21:{uint32_t result=LL_RTC_GetAsynchPrescaler(RTC); return result;}
case 22:{uint32_t result=LL_RTC_GetSynchPrescaler(RTC); return result;}
case 23:{LL_RTC_EnableWriteProtection(RTC); return 0;}
case 24:{LL_RTC_DisableWriteProtection(RTC); return 0;}
case 25:{LL_RTC_EnableTamperOutput(RTC); return 0;}
case 26:{LL_RTC_DisableTamperOutput(RTC); return 0;}
case 27:{uint32_t result=LL_RTC_IsTamperOutputEnabled(RTC); return result;}
case 28:{LL_RTC_EnableAlarmPullUp(RTC); return 0;}
case 29:{LL_RTC_DisableAlarmPullUp(RTC); return 0;}
case 30:{uint32_t result=LL_RTC_IsAlarmPullUpEnabled(RTC); return result;}
case 31:{LL_RTC_EnableOutput2(RTC); return 0;}
case 32:{LL_RTC_DisableOutput2(RTC); return 0;}
case 33:{uint32_t result=LL_RTC_IsOutput2Enabled(RTC); return result;}
case 34:{LL_RTC_TIME_SetFormat(RTC, (uint32_t)args[0]); return 0;}
case 35:{uint32_t result=LL_RTC_TIME_GetFormat(RTC); return result;}
case 36:{LL_RTC_TIME_SetHour(RTC, (uint32_t)args[0]); return 0;}
case 37:{uint32_t result=LL_RTC_TIME_GetHour(RTC); return result;}
case 38:{LL_RTC_TIME_SetMinute(RTC, (uint32_t)args[0]); return 0;}
case 39:{uint32_t result=LL_RTC_TIME_GetMinute(RTC); return result;}
case 40:{LL_RTC_TIME_SetSecond(RTC, (uint32_t)args[0]); return 0;}
case 41:{uint32_t result=LL_RTC_TIME_GetSecond(RTC); return result;}
case 42:{LL_RTC_TIME_Config(RTC, (uint32_t)args[0], (uint32_t)args[1], (uint32_t)args[2], (uint32_t)args[3]); return 0;}
case 43:{uint32_t result=LL_RTC_TIME_Get(RTC); return result;}
case 44:{LL_RTC_TIME_EnableDayLightStore(RTC); return 0;}
case 45:{LL_RTC_TIME_DisableDayLightStore(RTC); return 0;}
case 46:{uint32_t result=LL_RTC_TIME_IsDayLightStoreEnabled(RTC); return result;}
case 47:{LL_RTC_TIME_DecHour(RTC); return 0;}
case 48:{LL_RTC_TIME_IncHour(RTC); return 0;}
case 49:{uint32_t result=LL_RTC_TIME_GetSubSecond(RTC); return result;}
case 50:{LL_RTC_TIME_Synchronize(RTC, (uint32_t)args[0], (uint32_t)args[1]); return 0;}
case 51:{LL_RTC_DATE_SetYear(RTC, (uint32_t)args[0]); return 0;}
case 52:{uint32_t result=LL_RTC_DATE_GetYear(RTC); return result;}
case 53:{LL_RTC_DATE_SetWeekDay(RTC, (uint32_t)args[0]); return 0;}
case 54:{uint32_t result=LL_RTC_DATE_GetWeekDay(RTC); return result;}
case 55:{LL_RTC_DATE_SetMonth(RTC, (uint32_t)args[0]); return 0;}
case 56:{uint32_t result=LL_RTC_DATE_GetMonth(RTC); return result;}
case 57:{LL_RTC_DATE_SetDay(RTC, (uint32_t)args[0]); return 0;}
case 58:{uint32_t result=LL_RTC_DATE_GetDay(RTC); return result;}
case 59:{LL_RTC_DATE_Config(RTC, (uint32_t)args[0], (uint32_t)args[1], (uint32_t)args[2], (uint32_t)args[3]); return 0;}
case 60:{uint32_t result=LL_RTC_DATE_Get(RTC); return result;}
case 61:{LL_RTC_ALMA_Enable(RTC); return 0;}
case 62:{LL_RTC_ALMA_Disable(RTC); return 0;}
case 63:{LL_RTC_ALMA_SetMask(RTC, (uint32_t)args[0]); return 0;}
case 64:{uint32_t result=LL_RTC_ALMA_GetMask(RTC); return result;}
case 65:{LL_RTC_ALMA_EnableWeekday(RTC); return 0;}
case 66:{LL_RTC_ALMA_DisableWeekday(RTC); return 0;}
case 67:{LL_RTC_ALMA_SetDay(RTC, (uint32_t)args[0]); return 0;}
case 68:{uint32_t result=LL_RTC_ALMA_GetDay(RTC); return result;}
case 69:{LL_RTC_ALMA_SetWeekDay(RTC, (uint32_t)args[0]); return 0;}
case 70:{uint32_t result=LL_RTC_ALMA_GetWeekDay(RTC); return result;}
case 71:{LL_RTC_ALMA_SetTimeFormat(RTC, (uint32_t)args[0]); return 0;}
case 72:{uint32_t result=LL_RTC_ALMA_GetTimeFormat(RTC); return result;}
case 73:{LL_RTC_ALMA_SetHour(RTC, (uint32_t)args[0]); return 0;}
case 74:{uint32_t result=LL_RTC_ALMA_GetHour(RTC); return result;}
case 75:{LL_RTC_ALMA_SetMinute(RTC, (uint32_t)args[0]); return 0;}
case 76:{uint32_t result=LL_RTC_ALMA_GetMinute(RTC); return result;}
case 77:{LL_RTC_ALMA_SetSecond(RTC, (uint32_t)args[0]); return 0;}
case 78:{uint32_t result=LL_RTC_ALMA_GetSecond(RTC); return result;}
case 79:{LL_RTC_ALMA_ConfigTime(RTC, (uint32_t)args[0], (uint32_t)args[1], (uint32_t)args[2], (uint32_t)args[3]); return 0;}
case 80:{uint32_t result=LL_RTC_ALMA_GetTime(RTC); return result;}
case 81:{LL_RTC_ALMA_SetSubSecondMask(RTC, (uint32_t)args[0]); return 0;}
case 82:{uint32_t result=LL_RTC_ALMA_GetSubSecondMask(RTC); return result;}
case 83:{LL_RTC_ALMA_SetBinAutoClr(RTC, (uint32_t)args[0]); return 0;}
case 84:{uint32_t result=LL_RTC_ALMA_GetBinAutoClr(RTC); return result;}
case 85:{LL_RTC_ALMA_SetSubSecond(RTC, (uint32_t)args[0]); return 0;}
case 86:{uint32_t result=LL_RTC_ALMA_GetSubSecond(RTC); return result;}
case 87:{LL_RTC_ALMB_Enable(RTC); return 0;}
case 88:{LL_RTC_ALMB_Disable(RTC); return 0;}
case 89:{LL_RTC_ALMB_SetMask(RTC, (uint32_t)args[0]); return 0;}
case 90:{uint32_t result=LL_RTC_ALMB_GetMask(RTC); return result;}
case 91:{LL_RTC_ALMB_EnableWeekday(RTC); return 0;}
case 92:{LL_RTC_ALMB_DisableWeekday(RTC); return 0;}
case 93:{LL_RTC_ALMB_SetDay(RTC, (uint32_t)args[0]); return 0;}
case 94:{uint32_t result=LL_RTC_ALMB_GetDay(RTC); return result;}
case 95:{LL_RTC_ALMB_SetWeekDay(RTC, (uint32_t)args[0]); return 0;}
case 96:{uint32_t result=LL_RTC_ALMB_GetWeekDay(RTC); return result;}
case 97:{LL_RTC_ALMB_SetTimeFormat(RTC, (uint32_t)args[0]); return 0;}
case 98:{uint32_t result=LL_RTC_ALMB_GetTimeFormat(RTC); return result;}
case 99:{LL_RTC_ALMB_SetHour(RTC, (uint32_t)args[0]); return 0;}
case 100:{uint32_t result=LL_RTC_ALMB_GetHour(RTC); return result;}
case 101:{LL_RTC_ALMB_SetMinute(RTC, (uint32_t)args[0]); return 0;}
case 102:{uint32_t result=LL_RTC_ALMB_GetMinute(RTC); return result;}
case 103:{LL_RTC_ALMB_SetSecond(RTC, (uint32_t)args[0]); return 0;}
case 104:{uint32_t result=LL_RTC_ALMB_GetSecond(RTC); return result;}
case 105:{LL_RTC_ALMB_ConfigTime(RTC, (uint32_t)args[0], (uint32_t)args[1], (uint32_t)args[2], (uint32_t)args[3]); return 0;}
case 106:{uint32_t result=LL_RTC_ALMB_GetTime(RTC); return result;}
case 107:{LL_RTC_ALMB_SetSubSecondMask(RTC, (uint32_t)args[0]); return 0;}
case 108:{uint32_t result=LL_RTC_ALMB_GetSubSecondMask(RTC); return result;}
case 109:{LL_RTC_ALMB_SetBinAutoClr(RTC, (uint32_t)args[0]); return 0;}
case 110:{uint32_t result=LL_RTC_ALMB_GetBinAutoClr(RTC); return result;}
case 111:{LL_RTC_ALMB_SetSubSecond(RTC, (uint32_t)args[0]); return 0;}
case 112:{uint32_t result=LL_RTC_ALMB_GetSubSecond(RTC); return result;}
case 113:{LL_RTC_TS_EnableInternalEvent(RTC); return 0;}
case 114:{LL_RTC_TS_DisableInternalEvent(RTC); return 0;}
case 115:{LL_RTC_TS_Enable(RTC); return 0;}
case 116:{LL_RTC_TS_Disable(RTC); return 0;}
case 117:{LL_RTC_TS_SetActiveEdge(RTC, (uint32_t)args[0]); return 0;}
case 118:{uint32_t result=LL_RTC_TS_GetActiveEdge(RTC); return result;}
case 119:{uint32_t result=LL_RTC_TS_GetTimeFormat(RTC); return result;}
case 120:{uint32_t result=LL_RTC_TS_GetHour(RTC); return result;}
case 121:{uint32_t result=LL_RTC_TS_GetMinute(RTC); return result;}
case 122:{uint32_t result=LL_RTC_TS_GetSecond(RTC); return result;}
case 123:{uint32_t result=LL_RTC_TS_GetTime(RTC); return result;}
case 124:{uint32_t result=LL_RTC_TS_GetWeekDay(RTC); return result;}
case 125:{uint32_t result=LL_RTC_TS_GetMonth(RTC); return result;}
case 126:{uint32_t result=LL_RTC_TS_GetDay(RTC); return result;}
case 127:{uint32_t result=LL_RTC_TS_GetDate(RTC); return result;}
case 128:{uint32_t result=LL_RTC_TS_GetSubSecond(RTC); return result;}
case 129:{LL_RTC_TS_EnableOnTamper(RTC); return 0;}
case 130:{LL_RTC_TS_DisableOnTamper(RTC); return 0;}
case 131:{LL_RTC_TAMPER_Enable(RTC, (uint32_t)args[0]); return 0;}
case 132:{LL_RTC_TAMPER_Disable(RTC, (uint32_t)args[0]); return 0;}
case 133:{LL_RTC_TAMPER_EnableMask(RTC, (uint32_t)args[0]); return 0;}
case 134:{LL_RTC_TAMPER_DisableMask(RTC, (uint32_t)args[0]); return 0;}
case 135:{LL_RTC_TAMPER_EnableEraseBKP(RTC, (uint32_t)args[0]); return 0;}
case 136:{LL_RTC_TAMPER_DisableEraseBKP(RTC, (uint32_t)args[0]); return 0;}
case 137:{LL_RTC_TAMPER_DisablePullUp(RTC); return 0;}
case 138:{LL_RTC_TAMPER_EnablePullUp(RTC); return 0;}
case 139:{LL_RTC_TAMPER_SetPrecharge(RTC, (uint32_t)args[0]); return 0;}
case 140:{uint32_t result=LL_RTC_TAMPER_GetPrecharge(RTC); return result;}
case 141:{LL_RTC_TAMPER_SetFilterCount(RTC, (uint32_t)args[0]); return 0;}
case 142:{uint32_t result=LL_RTC_TAMPER_GetFilterCount(RTC); return result;}
case 143:{LL_RTC_TAMPER_SetSamplingFreq(RTC, (uint32_t)args[0]); return 0;}
case 144:{uint32_t result=LL_RTC_TAMPER_GetSamplingFreq(RTC); return result;}
case 145:{LL_RTC_TAMPER_EnableActiveLevel(RTC, (uint32_t)args[0]); return 0;}
case 146:{LL_RTC_TAMPER_DisableActiveLevel(RTC, (uint32_t)args[0]); return 0;}
case 147:{LL_RTC_TAMPER_ITAMP_Enable(RTC, (uint32_t)args[0]); return 0;}
case 148:{LL_RTC_TAMPER_ITAMP_Disable(RTC, (uint32_t)args[0]); return 0;}
case 149:{LL_RTC_TAMPER_ITAMP_EnableEraseBKP(RTC, (uint32_t)args[0]); return 0;}
case 150:{LL_RTC_TAMPER_ITAMP_DisableEraseBKP(RTC, (uint32_t)args[0]); return 0;}
case 151:{LL_RTC_TAMPER_ATAMP_EnableActiveMode((uint32_t)args[0]); return 0;}
case 152:{LL_RTC_TAMPER_ATAMP_DisableActiveMode((uint32_t)args[0]); return 0;}
case 153:{LL_RTC_TAMPER_ATAMP_EnableFilter(); return 0;}
case 154:{LL_RTC_TAMPER_ATAMP_DisableFilter(); return 0;}
case 155:{LL_RTC_TAMPER_ATAMP_SetOutputChangePeriod((uint32_t)args[0]); return 0;}
case 156:{uint32_t result=LL_RTC_TAMPER_ATAMP_GetOutputChangePeriod(); return result;}
case 157:{LL_RTC_TAMPER_ATAMP_SetAsyncPrescaler((uint32_t)args[0]); return 0;}
case 158:{uint32_t result=LL_RTC_TAMPER_ATAMP_GetAsyncPrescaler(); return result;}
case 159:{LL_RTC_TAMPER_ATAMP_EnableOutputSharing(); return 0;}
case 160:{LL_RTC_TAMPER_ATAMP_DisableOutputSharing(); return 0;}
case 161:{LL_RTC_TAMPER_ATAMP_SetSharedOuputSelection((uint32_t)args[0]); return 0;}
case 162:{uint32_t result=LL_RTC_TAMPER_ATAMP_GetSharedOuputSelection(); return result;}
case 163:{LL_RTC_TAMPER_ATAMP_WriteSeed((uint32_t)args[0]); return 0;}
case 164:{uint32_t result=LL_RTC_IsActiveFlag_ATAMP_INITS(); return result;}
case 165:{uint32_t result=LL_RTC_IsActiveFlag_ATAMP_SEEDF(); return result;}
case 166:{LL_RTC_WAKEUP_Enable(RTC); return 0;}
case 167:{LL_RTC_WAKEUP_Disable(RTC); return 0;}
case 168:{uint32_t result=LL_RTC_WAKEUP_IsEnabled(RTC); return result;}
case 169:{LL_RTC_WAKEUP_SetClock(RTC, (uint32_t)args[0]); return 0;}
case 170:{uint32_t result=LL_RTC_WAKEUP_GetClock(RTC); return result;}
case 171:{LL_RTC_WAKEUP_SetAutoReload(RTC, (uint32_t)args[0]); return 0;}
case 172:{uint32_t result=LL_RTC_WAKEUP_GetAutoReload(RTC); return result;}
case 173:{LL_RTC_BKP_SetRegister(RTC, (uint32_t)args[0], (uint32_t)args[1]); return 0;}
case 174:{uint32_t result=LL_RTC_BKP_GetRegister(RTC, (uint32_t)args[0]); return result;}
case 175:{LL_RTC_CAL_SetOutputFreq(RTC, (uint32_t)args[0]); return 0;}
case 176:{uint32_t result=LL_RTC_CAL_GetOutputFreq(RTC); return result;}
case 177:{LL_RTC_CAL_SetPulse(RTC, (uint32_t)args[0]); return 0;}
case 178:{uint32_t result=LL_RTC_CAL_IsPulseInserted(RTC); return result;}
case 179:{LL_RTC_CAL_SetPeriod(RTC, (uint32_t)args[0]); return 0;}
case 180:{uint32_t result=LL_RTC_CAL_GetPeriod(RTC); return result;}
case 181:{LL_RTC_CAL_SetMinus(RTC, (uint32_t)args[0]); return 0;}
case 182:{uint32_t result=LL_RTC_CAL_GetMinus(RTC); return result;}
case 183:{LL_RTC_CAL_LowPower_Enable(RTC); return 0;}
case 184:{LL_RTC_CAL_LowPower_Disable(RTC); return 0;}
case 185:{uint32_t result=LL_RTC_CAL_LowPower_IsEnabled(RTC); return result;}
case 186:{uint32_t result=LL_RTC_IsActiveFlag_ITS(RTC); return result;}
case 187:{uint32_t result=LL_RTC_IsActiveFlag_RECALP(RTC); return result;}
case 188:{uint32_t result=LL_RTC_IsActiveFlag_TSOV(RTC); return result;}
case 189:{uint32_t result=LL_RTC_IsActiveFlag_TS(RTC); return result;}
case 190:{uint32_t result=LL_RTC_IsActiveFlag_WUT(RTC); return result;}
case 191:{uint32_t result=LL_RTC_IsActiveFlag_ALRB(RTC); return result;}
case 192:{uint32_t result=LL_RTC_IsActiveFlag_ALRA(RTC); return result;}
case 193:{uint32_t result=LL_RTC_IsActiveFlag_SSRU(RTC); return result;}
case 194:{LL_RTC_ClearFlag_ITS(RTC); return 0;}
case 195:{LL_RTC_ClearFlag_TSOV(RTC); return 0;}
case 196:{LL_RTC_ClearFlag_TS(RTC); return 0;}
case 197:{LL_RTC_ClearFlag_WUT(RTC); return 0;}
case 198:{LL_RTC_ClearFlag_ALRB(RTC); return 0;}
case 199:{LL_RTC_ClearFlag_ALRA(RTC); return 0;}
case 200:{LL_RTC_ClearFlag_SSRU(RTC); return 0;}
case 201:{uint32_t result=LL_RTC_IsActiveFlag_INIT(RTC); return result;}
case 202:{uint32_t result=LL_RTC_IsActiveFlag_RS(RTC); return result;}
case 203:{LL_RTC_ClearFlag_RS(RTC); return 0;}
case 204:{uint32_t result=LL_RTC_IsActiveFlag_INITS(RTC); return result;}
case 205:{uint32_t result=LL_RTC_IsActiveFlag_SHP(RTC); return result;}
case 206:{uint32_t result=LL_RTC_IsActiveFlag_WUTW(RTC); return result;}
case 207:{uint32_t result=LL_RTC_IsActiveFlag_ALRAM(RTC); return result;}
case 208:{uint32_t result=LL_RTC_IsActiveFlag_SSRUM(RTC); return result;}
case 209:{uint32_t result=LL_RTC_IsActiveFlag_ALRBM(RTC); return result;}
case 210:{uint32_t result=LL_RTC_IsActiveFlag_WUTM(RTC); return result;}
case 211:{uint32_t result=LL_RTC_IsActiveFlag_TSM(RTC); return result;}
case 212:{uint32_t result=LL_RTC_IsActiveFlag_TSOVM(RTC); return result;}
case 213:{uint32_t result=LL_RTC_IsActiveFlag_ITSM(RTC); return result;}
case 214:{uint32_t result=LL_RTC_IsActiveFlag_TAMP1(RTC); return result;}
case 215:{uint32_t result=LL_RTC_IsActiveFlag_TAMP2(RTC); return result;}
case 216:{uint32_t result=LL_RTC_IsActiveFlag_TAMP3(RTC); return result;}
case 217:{uint32_t result=LL_RTC_IsActiveFlag_TAMP4(RTC); return result;}
case 218:{uint32_t result=LL_RTC_IsActiveFlag_TAMP5(RTC); return result;}
case 219:{uint32_t result=LL_RTC_IsActiveFlag_TAMP6(RTC); return result;}
case 220:{uint32_t result=LL_RTC_IsActiveFlag_TAMP7(RTC); return result;}
case 221:{uint32_t result=LL_RTC_IsActiveFlag_TAMP8(RTC); return result;}
case 222:{uint32_t result=LL_RTC_IsActiveFlag_ITAMP1(RTC); return result;}
case 223:{uint32_t result=LL_RTC_IsActiveFlag_ITAMP2(RTC); return result;}
case 224:{uint32_t result=LL_RTC_IsActiveFlag_ITAMP3(RTC); return result;}
case 225:{uint32_t result=LL_RTC_IsActiveFlag_ITAMP4(RTC); return result;}
case 226:{uint32_t result=LL_RTC_IsActiveFlag_ITAMP5(RTC); return result;}
case 227:{uint32_t result=LL_RTC_IsActiveFlag_ITAMP6(RTC); return result;}
case 228:{uint32_t result=LL_RTC_IsActiveFlag_ITAMP7(RTC); return result;}
case 229:{uint32_t result=LL_RTC_IsActiveFlag_ITAMP8(RTC); return result;}
case 230:{uint32_t result=LL_RTC_IsActiveFlag_ITAMP9(RTC); return result;}
case 231:{uint32_t result=LL_RTC_IsActiveFlag_ITAMP11(RTC); return result;}
case 232:{uint32_t result=LL_RTC_IsActiveFlag_ITAMP15(RTC); return result;}
case 233:{uint32_t result=LL_RTC_IsActiveFlag_TAMP1M(RTC); return result;}
case 234:{uint32_t result=LL_RTC_IsActiveFlag_TAMP2M(RTC); return result;}
case 235:{uint32_t result=LL_RTC_IsActiveFlag_TAMP3M(RTC); return result;}
case 236:{uint32_t result=LL_RTC_IsActiveFlag_TAMP4M(RTC); return result;}
case 237:{uint32_t result=LL_RTC_IsActiveFlag_TAMP5M(RTC); return result;}
case 238:{uint32_t result=LL_RTC_IsActiveFlag_TAMP6M(RTC); return result;}
case 239:{uint32_t result=LL_RTC_IsActiveFlag_TAMP7M(RTC); return result;}
case 240:{uint32_t result=LL_RTC_IsActiveFlag_TAMP8M(RTC); return result;}
case 241:{uint32_t result=LL_RTC_IsActiveFlag_ITAMP1M(RTC); return result;}
case 242:{uint32_t result=LL_RTC_IsActiveFlag_ITAMP2M(RTC); return result;}
case 243:{uint32_t result=LL_RTC_IsActiveFlag_ITAMP3M(RTC); return result;}
case 244:{uint32_t result=LL_RTC_IsActiveFlag_ITAMP4M(RTC); return result;}
case 245:{uint32_t result=LL_RTC_IsActiveFlag_ITAMP5M(RTC); return result;}
case 246:{uint32_t result=LL_RTC_IsActiveFlag_ITAMP6M(RTC); return result;}
case 247:{uint32_t result=LL_RTC_IsActiveFlag_ITAMP7M(RTC); return result;}
case 248:{uint32_t result=LL_RTC_IsActiveFlag_ITAMP8M(RTC); return result;}
case 249:{uint32_t result=LL_RTC_IsActiveFlag_ITAMP9M(RTC); return result;}
case 250:{uint32_t result=LL_RTC_IsActiveFlag_ITAMP11M(RTC); return result;}
case 251:{uint32_t result=LL_RTC_IsActiveFlag_ITAMP15M(RTC); return result;}
case 252:{LL_RTC_ClearFlag_TAMP1(RTC); return 0;}
case 253:{LL_RTC_ClearFlag_TAMP2(RTC); return 0;}
case 254:{LL_RTC_ClearFlag_TAMP3(RTC); return 0;}
case 255:{LL_RTC_ClearFlag_TAMP4(RTC); return 0;}
case 256:{LL_RTC_ClearFlag_TAMP5(RTC); return 0;}
case 257:{LL_RTC_ClearFlag_TAMP6(RTC); return 0;}
case 258:{LL_RTC_ClearFlag_TAMP7(RTC); return 0;}
case 259:{LL_RTC_ClearFlag_TAMP8(RTC); return 0;}
case 260:{LL_RTC_ClearFlag_ITAMP1(RTC); return 0;}
case 261:{LL_RTC_ClearFlag_ITAMP2(RTC); return 0;}
case 262:{LL_RTC_ClearFlag_ITAMP3(RTC); return 0;}
case 263:{LL_RTC_ClearFlag_ITAMP4(RTC); return 0;}
case 264:{LL_RTC_ClearFlag_ITAMP5(RTC); return 0;}
case 265:{LL_RTC_ClearFlag_ITAMP6(RTC); return 0;}
case 266:{LL_RTC_ClearFlag_ITAMP7(RTC); return 0;}
case 267:{LL_RTC_ClearFlag_ITAMP8(RTC); return 0;}
case 268:{LL_RTC_ClearFlag_ITAMP9(RTC); return 0;}
case 269:{LL_RTC_ClearFlag_ITAMP11(RTC); return 0;}
case 270:{LL_RTC_ClearFlag_ITAMP15(RTC); return 0;}
case 271:{LL_RTC_SetRtcPrivilege(RTC, (uint32_t)args[0]); return 0;}
case 272:{uint32_t result=LL_RTC_GetRtcPrivilege(RTC); return result;}
case 273:{LL_RTC_SetTampPrivilege(RTC, (uint32_t)args[0]); return 0;}
case 274:{uint32_t result=LL_RTC_GetTampPrivilege(RTC); return result;}
case 275:{LL_RTC_SetBackupRegisterPrivilege(RTC, (uint32_t)args[0]); return 0;}
case 276:{uint32_t result=LL_RTC_GetBackupRegisterPrivilege(RTC); return result;}
case 277:{LL_RTC_SetBackupRegProtection(RTC, (uint32_t)args[0], (uint32_t)args[1]); return 0;}
case 278:{uint32_t result=LL_RTC_GetBackupRegProtectionStartZone2(RTC); return result;}
case 279:{uint32_t result=LL_RTC_GetBackupRegProtectionStartZone3(RTC); return result;}
case 280:{LL_RTC_EnableIT_TS(RTC); return 0;}
case 281:{LL_RTC_DisableIT_TS(RTC); return 0;}
case 282:{LL_RTC_EnableIT_WUT(RTC); return 0;}
case 283:{LL_RTC_DisableIT_WUT(RTC); return 0;}
case 284:{LL_RTC_EnableIT_ALRB(RTC); return 0;}
case 285:{LL_RTC_DisableIT_ALRB(RTC); return 0;}
case 286:{LL_RTC_EnableIT_ALRA(RTC); return 0;}
case 287:{LL_RTC_DisableIT_ALRA(RTC); return 0;}
case 288:{LL_RTC_EnableIT_SSRU(RTC); return 0;}
case 289:{LL_RTC_DisableIT_SSRU(RTC); return 0;}
case 290:{uint32_t result=LL_RTC_IsEnabledIT_TS(RTC); return result;}
case 291:{uint32_t result=LL_RTC_IsEnabledIT_WUT(RTC); return result;}
case 292:{uint32_t result=LL_RTC_IsEnabledIT_ALRB(RTC); return result;}
case 293:{uint32_t result=LL_RTC_IsEnabledIT_ALRA(RTC); return result;}
case 294:{uint32_t result=LL_RTC_IsEnabledIT_SSRU(RTC); return result;}
case 295:{LL_RTC_EnableIT_TAMP1(RTC); return 0;}
case 296:{LL_RTC_DisableIT_TAMP1(RTC); return 0;}
case 297:{LL_RTC_EnableIT_TAMP2(RTC); return 0;}
case 298:{LL_RTC_DisableIT_TAMP2(RTC); return 0;}
case 299:{LL_RTC_EnableIT_TAMP3(RTC); return 0;}
case 300:{LL_RTC_DisableIT_TAMP3(RTC); return 0;}
case 301:{LL_RTC_EnableIT_TAMP4(RTC); return 0;}
case 302:{LL_RTC_DisableIT_TAMP4(RTC); return 0;}
case 303:{LL_RTC_EnableIT_TAMP5(RTC); return 0;}
case 304:{LL_RTC_DisableIT_TAMP5(RTC); return 0;}
case 305:{LL_RTC_EnableIT_TAMP6(RTC); return 0;}
case 306:{LL_RTC_DisableIT_TAMP6(RTC); return 0;}
case 307:{LL_RTC_EnableIT_TAMP7(RTC); return 0;}
case 308:{LL_RTC_DisableIT_TAMP7(RTC); return 0;}
case 309:{LL_RTC_EnableIT_TAMP8(RTC); return 0;}
case 310:{LL_RTC_DisableIT_TAMP8(RTC); return 0;}
case 311:{LL_RTC_EnableIT_ITAMP1(RTC); return 0;}
case 312:{LL_RTC_DisableIT_ITAMP1(RTC); return 0;}
case 313:{LL_RTC_EnableIT_ITAMP2(RTC); return 0;}
case 314:{LL_RTC_DisableIT_ITAMP2(RTC); return 0;}
case 315:{LL_RTC_EnableIT_ITAMP3(RTC); return 0;}
case 316:{LL_RTC_DisableIT_ITAMP3(RTC); return 0;}
case 317:{LL_RTC_EnableIT_ITAMP4(RTC); return 0;}
case 318:{LL_RTC_DisableIT_ITAMP4(RTC); return 0;}
case 319:{LL_RTC_EnableIT_ITAMP5(RTC); return 0;}
case 320:{LL_RTC_DisableIT_ITAMP5(RTC); return 0;}
case 321:{LL_RTC_EnableIT_ITAMP6(RTC); return 0;}
case 322:{LL_RTC_DisableIT_ITAMP6(RTC); return 0;}
case 323:{LL_RTC_EnableIT_ITAMP7(RTC); return 0;}
case 324:{LL_RTC_DisableIT_ITAMP7(RTC); return 0;}
case 325:{LL_RTC_EnableIT_ITAMP8(RTC); return 0;}
case 326:{LL_RTC_DisableIT_ITAMP8(RTC); return 0;}
case 327:{LL_RTC_EnableIT_ITAMP9(RTC); return 0;}
case 328:{LL_RTC_DisableIT_ITAMP9(RTC); return 0;}
case 329:{LL_RTC_EnableIT_ITAMP11(RTC); return 0;}
case 330:{LL_RTC_DisableIT_ITAMP11(RTC); return 0;}
case 331:{LL_RTC_EnableIT_ITAMP15(RTC); return 0;}
case 332:{LL_RTC_DisableIT_ITAMP15(RTC); return 0;}
case 333:{uint32_t result=LL_RTC_IsEnabledIT_TAMP1(RTC); return result;}
case 334:{uint32_t result=LL_RTC_IsEnabledIT_TAMP2(RTC); return result;}
case 335:{uint32_t result=LL_RTC_IsEnabledIT_TAMP3(RTC); return result;}
case 336:{uint32_t result=LL_RTC_IsEnabledIT_TAMP4(RTC); return result;}
case 337:{uint32_t result=LL_RTC_IsEnabledIT_TAMP5(RTC); return result;}
case 338:{uint32_t result=LL_RTC_IsEnabledIT_TAMP6(RTC); return result;}
case 339:{uint32_t result=LL_RTC_IsEnabledIT_TAMP7(RTC); return result;}
case 340:{uint32_t result=LL_RTC_IsEnabledIT_TAMP8(RTC); return result;}
case 341:{uint32_t result=LL_RTC_IsEnabledIT_ITAMP1(RTC); return result;}
case 342:{uint32_t result=LL_RTC_IsEnabledIT_ITAMP2(RTC); return result;}
case 343:{uint32_t result=LL_RTC_IsEnabledIT_ITAMP3(RTC); return result;}
case 344:{uint32_t result=LL_RTC_IsEnabledIT_ITAMP4(RTC); return result;}
case 345:{uint32_t result=LL_RTC_IsEnabledIT_ITAMP5(RTC); return result;}
case 346:{uint32_t result=LL_RTC_IsEnabledIT_ITAMP6(RTC); return result;}
case 347:{uint32_t result=LL_RTC_IsEnabledIT_ITAMP7(RTC); return result;}
case 348:{uint32_t result=LL_RTC_IsEnabledIT_ITAMP8(RTC); return result;}
case 349:{uint32_t result=LL_RTC_IsEnabledIT_ITAMP9(RTC); return result;}
case 350:{uint32_t result=LL_RTC_IsEnabledIT_ITAMP11(RTC); return result;}
case 351:{uint32_t result=LL_RTC_IsEnabledIT_ITAMP15(RTC); return result;}
case 352:{LL_RTC_IncrementMonotonicCounter(RTC); return 0;}
case 353:{uint32_t result=LL_RTC_GetMonotonicCounter(RTC); return result;}
case 354:{uint32_t result=LL_RTC_DeInit(RTC); return result;}
case 355:{LL_RTC_InitTypeDef v1={0}; v1.HourFormat=(uint32_t)args[0]; v1.AsynchPrescaler=(uint32_t)args[1]; v1.SynchPrescaler=(uint32_t)args[2]; uint32_t result=LL_RTC_Init(RTC, &v1); s->cells[384]=v1.HourFormat; s->cells[385]=v1.AsynchPrescaler; s->cells[386]=v1.SynchPrescaler; return result;}
case 356:{LL_RTC_InitTypeDef v0={0}; v0.HourFormat=(uint32_t)args[0]; v0.AsynchPrescaler=(uint32_t)args[1]; v0.SynchPrescaler=(uint32_t)args[2]; LL_RTC_StructInit(&v0); s->cells[384]=v0.HourFormat; s->cells[385]=v0.AsynchPrescaler; s->cells[386]=v0.SynchPrescaler; return 0;}
case 357:{LL_RTC_TimeTypeDef v2={0}; v2.TimeFormat=(uint32_t)args[1]; v2.Hours=(uint8_t)args[2]; v2.Minutes=(uint8_t)args[3]; v2.Seconds=(uint8_t)args[4]; uint32_t result=LL_RTC_TIME_Init(RTC, (uint32_t)args[0], &v2); s->cells[384]=v2.TimeFormat; s->cells[385]=v2.Hours; s->cells[386]=v2.Minutes; s->cells[387]=v2.Seconds; return result;}
case 358:{LL_RTC_TimeTypeDef v0={0}; v0.TimeFormat=(uint32_t)args[0]; v0.Hours=(uint8_t)args[1]; v0.Minutes=(uint8_t)args[2]; v0.Seconds=(uint8_t)args[3]; LL_RTC_TIME_StructInit(&v0); s->cells[384]=v0.TimeFormat; s->cells[385]=v0.Hours; s->cells[386]=v0.Minutes; s->cells[387]=v0.Seconds; return 0;}
case 359:{LL_RTC_DateTypeDef v2={0}; v2.WeekDay=(uint8_t)args[1]; v2.Month=(uint8_t)args[2]; v2.Day=(uint8_t)args[3]; v2.Year=(uint8_t)args[4]; uint32_t result=LL_RTC_DATE_Init(RTC, (uint32_t)args[0], &v2); s->cells[384]=v2.WeekDay; s->cells[385]=v2.Month; s->cells[386]=v2.Day; s->cells[387]=v2.Year; return result;}
case 360:{LL_RTC_DateTypeDef v0={0}; v0.WeekDay=(uint8_t)args[0]; v0.Month=(uint8_t)args[1]; v0.Day=(uint8_t)args[2]; v0.Year=(uint8_t)args[3]; LL_RTC_DATE_StructInit(&v0); s->cells[384]=v0.WeekDay; s->cells[385]=v0.Month; s->cells[386]=v0.Day; s->cells[387]=v0.Year; return 0;}
case 361:{LL_RTC_AlarmTypeDef v2={0}; v2.AlarmTime.TimeFormat=(uint32_t)args[1]; v2.AlarmTime.Hours=(uint8_t)args[2]; v2.AlarmTime.Minutes=(uint8_t)args[3]; v2.AlarmTime.Seconds=(uint8_t)args[4]; v2.AlarmMask=(uint32_t)args[5]; v2.AlarmDateWeekDaySel=(uint32_t)args[6]; v2.AlarmDateWeekDay=(uint8_t)args[7]; uint32_t result=LL_RTC_ALMA_Init(RTC, (uint32_t)args[0], &v2); s->cells[384]=v2.AlarmTime.TimeFormat; s->cells[385]=v2.AlarmTime.Hours; s->cells[386]=v2.AlarmTime.Minutes; s->cells[387]=v2.AlarmTime.Seconds; s->cells[388]=v2.AlarmMask; s->cells[389]=v2.AlarmDateWeekDaySel; s->cells[390]=v2.AlarmDateWeekDay; return result;}
case 362:{LL_RTC_AlarmTypeDef v2={0}; v2.AlarmTime.TimeFormat=(uint32_t)args[1]; v2.AlarmTime.Hours=(uint8_t)args[2]; v2.AlarmTime.Minutes=(uint8_t)args[3]; v2.AlarmTime.Seconds=(uint8_t)args[4]; v2.AlarmMask=(uint32_t)args[5]; v2.AlarmDateWeekDaySel=(uint32_t)args[6]; v2.AlarmDateWeekDay=(uint8_t)args[7]; uint32_t result=LL_RTC_ALMB_Init(RTC, (uint32_t)args[0], &v2); s->cells[384]=v2.AlarmTime.TimeFormat; s->cells[385]=v2.AlarmTime.Hours; s->cells[386]=v2.AlarmTime.Minutes; s->cells[387]=v2.AlarmTime.Seconds; s->cells[388]=v2.AlarmMask; s->cells[389]=v2.AlarmDateWeekDaySel; s->cells[390]=v2.AlarmDateWeekDay; return result;}
case 363:{LL_RTC_AlarmTypeDef v0={0}; v0.AlarmTime.TimeFormat=(uint32_t)args[0]; v0.AlarmTime.Hours=(uint8_t)args[1]; v0.AlarmTime.Minutes=(uint8_t)args[2]; v0.AlarmTime.Seconds=(uint8_t)args[3]; v0.AlarmMask=(uint32_t)args[4]; v0.AlarmDateWeekDaySel=(uint32_t)args[5]; v0.AlarmDateWeekDay=(uint8_t)args[6]; LL_RTC_ALMA_StructInit(&v0); s->cells[384]=v0.AlarmTime.TimeFormat; s->cells[385]=v0.AlarmTime.Hours; s->cells[386]=v0.AlarmTime.Minutes; s->cells[387]=v0.AlarmTime.Seconds; s->cells[388]=v0.AlarmMask; s->cells[389]=v0.AlarmDateWeekDaySel; s->cells[390]=v0.AlarmDateWeekDay; return 0;}
case 364:{LL_RTC_AlarmTypeDef v0={0}; v0.AlarmTime.TimeFormat=(uint32_t)args[0]; v0.AlarmTime.Hours=(uint8_t)args[1]; v0.AlarmTime.Minutes=(uint8_t)args[2]; v0.AlarmTime.Seconds=(uint8_t)args[3]; v0.AlarmMask=(uint32_t)args[4]; v0.AlarmDateWeekDaySel=(uint32_t)args[5]; v0.AlarmDateWeekDay=(uint8_t)args[6]; LL_RTC_ALMB_StructInit(&v0); s->cells[384]=v0.AlarmTime.TimeFormat; s->cells[385]=v0.AlarmTime.Hours; s->cells[386]=v0.AlarmTime.Minutes; s->cells[387]=v0.AlarmTime.Seconds; s->cells[388]=v0.AlarmMask; s->cells[389]=v0.AlarmDateWeekDaySel; s->cells[390]=v0.AlarmDateWeekDay; return 0;}
case 365:{uint32_t result=LL_RTC_EnterInitMode(RTC); return result;}
case 366:{uint32_t result=LL_RTC_ExitInitMode(RTC); return result;}
case 367:{uint32_t result=LL_RTC_WaitForSynchro(RTC); return result;}
case 368:{LL_IWDG_Enable(IWDG); return 0;}
case 369:{LL_IWDG_ReloadCounter(IWDG); return 0;}
case 370:{LL_IWDG_EnableWriteAccess(IWDG); return 0;}
case 371:{LL_IWDG_DisableWriteAccess(IWDG); return 0;}
case 372:{LL_IWDG_SetPrescaler(IWDG, (uint32_t)args[0]); return 0;}
case 373:{uint32_t result=LL_IWDG_GetPrescaler(IWDG); return result;}
case 374:{LL_IWDG_SetReloadCounter(IWDG, (uint32_t)args[0]); return 0;}
case 375:{uint32_t result=LL_IWDG_GetReloadCounter(IWDG); return result;}
case 376:{LL_IWDG_SetWindow(IWDG, (uint32_t)args[0]); return 0;}
case 377:{uint32_t result=LL_IWDG_GetWindow(IWDG); return result;}
case 378:{LL_IWDG_SetEwiTime(IWDG, (uint32_t)args[0]); return 0;}
case 379:{uint32_t result=LL_IWDG_GetEwiTime(IWDG); return result;}
case 380:{LL_IWDG_EnableIT_EWI(IWDG); return 0;}
case 381:{LL_IWDG_DisableIT_EWI(IWDG); return 0;}
case 382:{uint32_t result=LL_IWDG_IsEnabledIT_EWI(IWDG); return result;}
case 383:{uint32_t result=LL_IWDG_IsActiveFlag_PVU(IWDG); return result;}
case 384:{uint32_t result=LL_IWDG_IsActiveFlag_RVU(IWDG); return result;}
case 385:{uint32_t result=LL_IWDG_IsActiveFlag_WVU(IWDG); return result;}
case 386:{uint32_t result=LL_IWDG_IsActiveFlag_EWU(IWDG); return result;}
case 387:{uint32_t result=LL_IWDG_IsReady(IWDG); return result;}
case 388:{uint32_t result=LL_IWDG_IsActiveFlag_ONF(IWDG); return result;}
case 389:{uint32_t result=LL_IWDG_IsActiveFlag_EWIF(IWDG); return result;}
case 390:{LL_IWDG_ClearFlag_EWIF(IWDG); return 0;}
case 391:{LL_WWDG_Enable(WWDG); return 0;}
case 392:{uint32_t result=LL_WWDG_IsEnabled(WWDG); return result;}
case 393:{LL_WWDG_SetCounter(WWDG, (uint32_t)args[0]); return 0;}
case 394:{uint32_t result=LL_WWDG_GetCounter(WWDG); return result;}
case 395:{LL_WWDG_SetPrescaler(WWDG, (uint32_t)args[0]); return 0;}
case 396:{uint32_t result=LL_WWDG_GetPrescaler(WWDG); return result;}
case 397:{LL_WWDG_SetWindow(WWDG, (uint32_t)args[0]); return 0;}
case 398:{uint32_t result=LL_WWDG_GetWindow(WWDG); return result;}
case 399:{uint32_t result=LL_WWDG_IsActiveFlag_EWKUP(WWDG); return result;}
case 400:{LL_WWDG_ClearFlag_EWKUP(WWDG); return 0;}
case 401:{LL_WWDG_EnableIT_EWKUP(WWDG); return 0;}
case 402:{uint32_t result=LL_WWDG_IsEnabledIT_EWKUP(WWDG); return result;}
case 403:{LL_RTC_WriteReg(RTC,CR,args[0]);return LL_RTC_ReadReg(RTC,CR);}
case 404:{LL_IWDG_WriteReg(IWDG,PR,args[0]);return LL_IWDG_ReadReg(IWDG,PR);}
case 405:{LL_WWDG_WriteReg(WWDG,CFR,args[0]);return LL_WWDG_ReadReg(WWDG,CFR);}
case 406:return __LL_RTC_CONVERT_BIN2BCD(args[0]);
case 407:return __LL_RTC_CONVERT_BCD2BIN(args[0]);
case 408:return __LL_RTC_GET_WEEKDAY(args[0]);
case 409:return __LL_RTC_GET_YEAR(args[0]);
case 410:return __LL_RTC_GET_MONTH(args[0]);
case 411:return __LL_RTC_GET_DAY(args[0]);
case 412:return __LL_RTC_GET_HOUR(args[0]);
case 413:return __LL_RTC_GET_MINUTE(args[0]);
case 414:return __LL_RTC_GET_SECOND(args[0]);
default:abort();}}
uint32_t CL57_Constant(uint32_t i){switch(i){
case 0:return LL_RTC_FORMAT_BIN;
case 1:return LL_RTC_FORMAT_BCD;
case 2:return LL_RTC_ALMA_DATEWEEKDAYSEL_DATE;
case 3:return LL_RTC_ALMA_DATEWEEKDAYSEL_WEEKDAY;
case 4:return LL_RTC_ALMB_DATEWEEKDAYSEL_DATE;
case 5:return LL_RTC_ALMB_DATEWEEKDAYSEL_WEEKDAY;
case 6:return LL_RTC_SCR_SSRUF;
case 7:return LL_RTC_SCR_ITSF;
case 8:return LL_RTC_SCR_TSOVF;
case 9:return LL_RTC_SCR_TSF;
case 10:return LL_RTC_SCR_WUTF;
case 11:return LL_RTC_SCR_ALRBF;
case 12:return LL_RTC_SCR_ALRAF;
case 13:return LL_RTC_ICSR_RECALPF;
case 14:return LL_RTC_ICSR_BCDU_2;
case 15:return LL_RTC_ICSR_BCDU_1;
case 16:return LL_RTC_ICSR_BCDU_0;
case 17:return LL_RTC_ICSR_BIN_1;
case 18:return LL_RTC_ICSR_BIN_0;
case 19:return LL_RTC_ICSR_INITF;
case 20:return LL_RTC_ICSR_RSF;
case 21:return LL_RTC_ICSR_INITS;
case 22:return LL_RTC_ICSR_SHPF;
case 23:return LL_RTC_ICSR_WUTWF;
case 24:return LL_RTC_CR_TSIE;
case 25:return LL_RTC_CR_WUTIE;
case 26:return LL_RTC_CR_ALRBIE;
case 27:return LL_RTC_CR_ALRAIE;
case 28:return LL_RTC_WEEKDAY_MONDAY;
case 29:return LL_RTC_WEEKDAY_TUESDAY;
case 30:return LL_RTC_WEEKDAY_WEDNESDAY;
case 31:return LL_RTC_WEEKDAY_THURSDAY;
case 32:return LL_RTC_WEEKDAY_FRIDAY;
case 33:return LL_RTC_WEEKDAY_SATURDAY;
case 34:return LL_RTC_WEEKDAY_SUNDAY;
case 35:return LL_RTC_MONTH_JANUARY;
case 36:return LL_RTC_MONTH_FEBRUARY;
case 37:return LL_RTC_MONTH_MARCH;
case 38:return LL_RTC_MONTH_APRIL;
case 39:return LL_RTC_MONTH_MAY;
case 40:return LL_RTC_MONTH_JUNE;
case 41:return LL_RTC_MONTH_JULY;
case 42:return LL_RTC_MONTH_AUGUST;
case 43:return LL_RTC_MONTH_SEPTEMBER;
case 44:return LL_RTC_MONTH_OCTOBER;
case 45:return LL_RTC_MONTH_NOVEMBER;
case 46:return LL_RTC_MONTH_DECEMBER;
case 47:return LL_RTC_HOURFORMAT_24HOUR;
case 48:return LL_RTC_HOURFORMAT_AMPM;
case 49:return LL_RTC_ALARMOUT_DISABLE;
case 50:return LL_RTC_ALARMOUT_ALMA;
case 51:return LL_RTC_ALARMOUT_ALMB;
case 52:return LL_RTC_ALARMOUT_WAKEUP;
case 53:return LL_RTC_ALARM_OUTPUTTYPE_PUSHPULL;
case 54:return LL_RTC_ALARM_OUTPUTTYPE_OPENDRAIN;
case 55:return LL_RTC_OUTPUTPOLARITY_PIN_HIGH;
case 56:return LL_RTC_OUTPUTPOLARITY_PIN_LOW;
case 57:return LL_RTC_TIME_FORMAT_AM_OR_24;
case 58:return LL_RTC_TIME_FORMAT_PM;
case 59:return LL_RTC_SHIFT_SECOND_DELAY;
case 60:return LL_RTC_SHIFT_SECOND_ADVANCE;
case 61:return LL_RTC_ALMA_MASK_NONE;
case 62:return LL_RTC_ALMA_MASK_DATEWEEKDAY;
case 63:return LL_RTC_ALMA_MASK_HOURS;
case 64:return LL_RTC_ALMA_MASK_MINUTES;
case 65:return LL_RTC_ALMA_MASK_SECONDS;
case 66:return LL_RTC_ALMA_MASK_ALL;
case 67:return LL_RTC_ALMA_TIME_FORMAT_AM;
case 68:return LL_RTC_ALMA_TIME_FORMAT_PM;
case 69:return LL_RTC_ALMA_SUBSECONDBIN_AUTOCLR_NO;
case 70:return LL_RTC_ALMA_SUBSECONDBIN_AUTOCLR_YES;
case 71:return LL_RTC_ALMB_MASK_NONE;
case 72:return LL_RTC_ALMB_MASK_DATEWEEKDAY;
case 73:return LL_RTC_ALMB_MASK_HOURS;
case 74:return LL_RTC_ALMB_MASK_MINUTES;
case 75:return LL_RTC_ALMB_MASK_SECONDS;
case 76:return LL_RTC_ALMB_MASK_ALL;
case 77:return LL_RTC_ALMB_TIME_FORMAT_AM;
case 78:return LL_RTC_ALMB_TIME_FORMAT_PM;
case 79:return LL_RTC_ALMB_SUBSECONDBIN_AUTOCLR_NO;
case 80:return LL_RTC_ALMB_SUBSECONDBIN_AUTOCLR_YES;
case 81:return LL_RTC_TIMESTAMP_EDGE_RISING;
case 82:return LL_RTC_TIMESTAMP_EDGE_FALLING;
case 83:return LL_RTC_TS_TIME_FORMAT_AM;
case 84:return LL_RTC_TS_TIME_FORMAT_PM;
case 85:return LL_RTC_TAMPER_1;
case 86:return LL_RTC_TAMPER_2;
case 87:return LL_RTC_TAMPER_3;
case 88:return LL_RTC_TAMPER_4;
case 89:return LL_RTC_TAMPER_5;
case 90:return LL_RTC_TAMPER_6;
case 91:return LL_RTC_TAMPER_7;
case 92:return LL_RTC_TAMPER_8;
case 93:return LL_RTC_TAMPER_MASK_TAMPER1;
case 94:return LL_RTC_TAMPER_MASK_TAMPER2;
case 95:return LL_RTC_TAMPER_MASK_TAMPER3;
case 96:return LL_RTC_TAMPER_NOERASE_TAMPER1;
case 97:return LL_RTC_TAMPER_NOERASE_TAMPER2;
case 98:return LL_RTC_TAMPER_NOERASE_TAMPER3;
case 99:return LL_RTC_TAMPER_NOERASE_TAMPER4;
case 100:return LL_RTC_TAMPER_NOERASE_TAMPER5;
case 101:return LL_RTC_TAMPER_NOERASE_TAMPER6;
case 102:return LL_RTC_TAMPER_NOERASE_TAMPER7;
case 103:return LL_RTC_TAMPER_NOERASE_TAMPER8;
case 104:return LL_RTC_TAMPER_DURATION_1RTCCLK;
case 105:return LL_RTC_TAMPER_DURATION_2RTCCLK;
case 106:return LL_RTC_TAMPER_DURATION_4RTCCLK;
case 107:return LL_RTC_TAMPER_DURATION_8RTCCLK;
case 108:return LL_RTC_TAMPER_FILTER_DISABLE;
case 109:return LL_RTC_TAMPER_FILTER_2SAMPLE;
case 110:return LL_RTC_TAMPER_FILTER_4SAMPLE;
case 111:return LL_RTC_TAMPER_FILTER_8SAMPLE;
case 112:return LL_RTC_TAMPER_SAMPLFREQDIV_32768;
case 113:return LL_RTC_TAMPER_SAMPLFREQDIV_16384;
case 114:return LL_RTC_TAMPER_SAMPLFREQDIV_8192;
case 115:return LL_RTC_TAMPER_SAMPLFREQDIV_4096;
case 116:return LL_RTC_TAMPER_SAMPLFREQDIV_2048;
case 117:return LL_RTC_TAMPER_SAMPLFREQDIV_1024;
case 118:return LL_RTC_TAMPER_SAMPLFREQDIV_512;
case 119:return LL_RTC_TAMPER_SAMPLFREQDIV_256;
case 120:return LL_RTC_TAMPER_ACTIVELEVEL_TAMP1;
case 121:return LL_RTC_TAMPER_ACTIVELEVEL_TAMP2;
case 122:return LL_RTC_TAMPER_ACTIVELEVEL_TAMP3;
case 123:return LL_RTC_TAMPER_ACTIVELEVEL_TAMP4;
case 124:return LL_RTC_TAMPER_ACTIVELEVEL_TAMP5;
case 125:return LL_RTC_TAMPER_ACTIVELEVEL_TAMP6;
case 126:return LL_RTC_TAMPER_ACTIVELEVEL_TAMP7;
case 127:return LL_RTC_TAMPER_ACTIVELEVEL_TAMP8;
case 128:return LL_RTC_TAMPER_ITAMP1;
case 129:return LL_RTC_TAMPER_ITAMP2;
case 130:return LL_RTC_TAMPER_ITAMP3;
case 131:return LL_RTC_TAMPER_ITAMP4;
case 132:return LL_RTC_TAMPER_ITAMP5;
case 133:return LL_RTC_TAMPER_ITAMP6;
case 134:return LL_RTC_TAMPER_ITAMP7;
case 135:return LL_RTC_TAMPER_ITAMP8;
case 136:return LL_RTC_TAMPER_ITAMP9;
case 137:return LL_RTC_TAMPER_ITAMP11;
case 138:return LL_RTC_TAMPER_ITAMP15;
case 139:return LL_RTC_TAMPER_NOERASE_ITAMPER1;
case 140:return LL_RTC_TAMPER_NOERASE_ITAMPER2;
case 141:return LL_RTC_TAMPER_NOERASE_ITAMPER3;
case 142:return LL_RTC_TAMPER_NOERASE_ITAMPER4;
case 143:return LL_RTC_TAMPER_NOERASE_ITAMPER5;
case 144:return LL_RTC_TAMPER_NOERASE_ITAMPER6;
case 145:return LL_RTC_TAMPER_NOERASE_ITAMPER7;
case 146:return LL_RTC_TAMPER_NOERASE_ITAMPER8;
case 147:return LL_RTC_TAMPER_NOERASE_ITAMPER9;
case 148:return LL_RTC_TAMPER_NOERASE_ITAMPER11;
case 149:return LL_RTC_TAMPER_NOERASE_ITAMPER15;
case 150:return LL_RTC_TAMPER_ATAMP_TAMP1AM;
case 151:return LL_RTC_TAMPER_ATAMP_TAMP2AM;
case 152:return LL_RTC_TAMPER_ATAMP_TAMP3AM;
case 153:return LL_RTC_TAMPER_ATAMP_TAMP4AM;
case 154:return LL_RTC_TAMPER_ATAMP_TAMP5AM;
case 155:return LL_RTC_TAMPER_ATAMP_TAMP6AM;
case 156:return LL_RTC_TAMPER_ATAMP_TAMP7AM;
case 157:return LL_RTC_TAMPER_ATAMP_TAMP8AM;
case 158:return LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK;
case 159:return LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK_2;
case 160:return LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK_4;
case 161:return LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK_8;
case 162:return LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK_16;
case 163:return LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK_32;
case 164:return LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK_64;
case 165:return LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK_128;
case 166:return LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK_2048;
case 167:return LL_RTC_TAMPER_ATAMP1IN_ATAMP1OUT;
case 168:return LL_RTC_TAMPER_ATAMP1IN_ATAMP2OUT;
case 169:return LL_RTC_TAMPER_ATAMP1IN_ATAMP3OUT;
case 170:return LL_RTC_TAMPER_ATAMP1IN_ATAMP4OUT;
case 171:return LL_RTC_TAMPER_ATAMP1IN_ATAMP5OUT;
case 172:return LL_RTC_TAMPER_ATAMP1IN_ATAMP6OUT;
case 173:return LL_RTC_TAMPER_ATAMP1IN_ATAMP7OUT;
case 174:return LL_RTC_TAMPER_ATAMP1IN_ATAMP8OUT;
case 175:return LL_RTC_TAMPER_ATAMP2IN_ATAMP1OUT;
case 176:return LL_RTC_TAMPER_ATAMP2IN_ATAMP2OUT;
case 177:return LL_RTC_TAMPER_ATAMP2IN_ATAMP3OUT;
case 178:return LL_RTC_TAMPER_ATAMP2IN_ATAMP4OUT;
case 179:return LL_RTC_TAMPER_ATAMP2IN_ATAMP5OUT;
case 180:return LL_RTC_TAMPER_ATAMP2IN_ATAMP6OUT;
case 181:return LL_RTC_TAMPER_ATAMP2IN_ATAMP7OUT;
case 182:return LL_RTC_TAMPER_ATAMP2IN_ATAMP8OUT;
case 183:return LL_RTC_TAMPER_ATAMP3IN_ATAMP1OUT;
case 184:return LL_RTC_TAMPER_ATAMP3IN_ATAMP2OUT;
case 185:return LL_RTC_TAMPER_ATAMP3IN_ATAMP3OUT;
case 186:return LL_RTC_TAMPER_ATAMP3IN_ATAMP4OUT;
case 187:return LL_RTC_TAMPER_ATAMP3IN_ATAMP5OUT;
case 188:return LL_RTC_TAMPER_ATAMP3IN_ATAMP6OUT;
case 189:return LL_RTC_TAMPER_ATAMP3IN_ATAMP7OUT;
case 190:return LL_RTC_TAMPER_ATAMP3IN_ATAMP8OUT;
case 191:return LL_RTC_TAMPER_ATAMP4IN_ATAMP1OUT;
case 192:return LL_RTC_TAMPER_ATAMP4IN_ATAMP2OUT;
case 193:return LL_RTC_TAMPER_ATAMP4IN_ATAMP3OUT;
case 194:return LL_RTC_TAMPER_ATAMP4IN_ATAMP4OUT;
case 195:return LL_RTC_TAMPER_ATAMP4IN_ATAMP5OUT;
case 196:return LL_RTC_TAMPER_ATAMP4IN_ATAMP6OUT;
case 197:return LL_RTC_TAMPER_ATAMP4IN_ATAMP7OUT;
case 198:return LL_RTC_TAMPER_ATAMP4IN_ATAMP8OUT;
case 199:return LL_RTC_TAMPER_ATAMP5IN_ATAMP1OUT;
case 200:return LL_RTC_TAMPER_ATAMP5IN_ATAMP2OUT;
case 201:return LL_RTC_TAMPER_ATAMP5IN_ATAMP3OUT;
case 202:return LL_RTC_TAMPER_ATAMP5IN_ATAMP4OUT;
case 203:return LL_RTC_TAMPER_ATAMP5IN_ATAMP5OUT;
case 204:return LL_RTC_TAMPER_ATAMP5IN_ATAMP6OUT;
case 205:return LL_RTC_TAMPER_ATAMP5IN_ATAMP7OUT;
case 206:return LL_RTC_TAMPER_ATAMP5IN_ATAMP8OUT;
case 207:return LL_RTC_TAMPER_ATAMP6IN_ATAMP1OUT;
case 208:return LL_RTC_TAMPER_ATAMP6IN_ATAMP2OUT;
case 209:return LL_RTC_TAMPER_ATAMP6IN_ATAMP3OUT;
case 210:return LL_RTC_TAMPER_ATAMP6IN_ATAMP4OUT;
case 211:return LL_RTC_TAMPER_ATAMP6IN_ATAMP5OUT;
case 212:return LL_RTC_TAMPER_ATAMP6IN_ATAMP6OUT;
case 213:return LL_RTC_TAMPER_ATAMP6IN_ATAMP7OUT;
case 214:return LL_RTC_TAMPER_ATAMP6IN_ATAMP8OUT;
case 215:return LL_RTC_TAMPER_ATAMP7IN_ATAMP1OUT;
case 216:return LL_RTC_TAMPER_ATAMP7IN_ATAMP2OUT;
case 217:return LL_RTC_TAMPER_ATAMP7IN_ATAMP3OUT;
case 218:return LL_RTC_TAMPER_ATAMP7IN_ATAMP4OUT;
case 219:return LL_RTC_TAMPER_ATAMP7IN_ATAMP5OUT;
case 220:return LL_RTC_TAMPER_ATAMP7IN_ATAMP6OUT;
case 221:return LL_RTC_TAMPER_ATAMP7IN_ATAMP7OUT;
case 222:return LL_RTC_TAMPER_ATAMP7IN_ATAMP8OUT;
case 223:return LL_RTC_TAMPER_ATAMP8IN_ATAMP1OUT;
case 224:return LL_RTC_TAMPER_ATAMP8IN_ATAMP2OUT;
case 225:return LL_RTC_TAMPER_ATAMP8IN_ATAMP3OUT;
case 226:return LL_RTC_TAMPER_ATAMP8IN_ATAMP4OUT;
case 227:return LL_RTC_TAMPER_ATAMP8IN_ATAMP5OUT;
case 228:return LL_RTC_TAMPER_ATAMP8IN_ATAMP6OUT;
case 229:return LL_RTC_TAMPER_ATAMP8IN_ATAMP7OUT;
case 230:return LL_RTC_TAMPER_ATAMP8IN_ATAMP8OUT;
case 231:return LL_RTC_BKP_DR0;
case 232:return LL_RTC_BKP_DR1;
case 233:return LL_RTC_BKP_DR2;
case 234:return LL_RTC_BKP_DR3;
case 235:return LL_RTC_BKP_DR4;
case 236:return LL_RTC_BKP_DR5;
case 237:return LL_RTC_BKP_DR6;
case 238:return LL_RTC_BKP_DR7;
case 239:return LL_RTC_BKP_DR8;
case 240:return LL_RTC_BKP_DR9;
case 241:return LL_RTC_BKP_DR10;
case 242:return LL_RTC_BKP_DR11;
case 243:return LL_RTC_BKP_DR12;
case 244:return LL_RTC_BKP_DR13;
case 245:return LL_RTC_BKP_DR14;
case 246:return LL_RTC_BKP_DR15;
case 247:return LL_RTC_BKP_DR16;
case 248:return LL_RTC_BKP_DR17;
case 249:return LL_RTC_BKP_DR18;
case 250:return LL_RTC_BKP_DR19;
case 251:return LL_RTC_BKP_DR20;
case 252:return LL_RTC_BKP_DR21;
case 253:return LL_RTC_BKP_DR22;
case 254:return LL_RTC_BKP_DR23;
case 255:return LL_RTC_BKP_DR24;
case 256:return LL_RTC_BKP_DR25;
case 257:return LL_RTC_BKP_DR26;
case 258:return LL_RTC_BKP_DR27;
case 259:return LL_RTC_BKP_DR28;
case 260:return LL_RTC_BKP_DR29;
case 261:return LL_RTC_BKP_DR30;
case 262:return LL_RTC_BKP_DR31;
case 263:return LL_RTC_WAKEUPCLOCK_DIV_16;
case 264:return LL_RTC_WAKEUPCLOCK_DIV_8;
case 265:return LL_RTC_WAKEUPCLOCK_DIV_4;
case 266:return LL_RTC_WAKEUPCLOCK_DIV_2;
case 267:return LL_RTC_WAKEUPCLOCK_CKSPRE;
case 268:return LL_RTC_WAKEUPCLOCK_CKSPRE_WUT;
case 269:return LL_RTC_CALIB_OUTPUT_NONE;
case 270:return LL_RTC_CALIB_OUTPUT_1HZ;
case 271:return LL_RTC_CALIB_OUTPUT_512HZ;
case 272:return LL_RTC_CALIB_INSERTPULSE_NONE;
case 273:return LL_RTC_CALIB_INSERTPULSE_SET;
case 274:return LL_RTC_CALIB_PERIOD_32SEC;
case 275:return LL_RTC_CALIB_PERIOD_16SEC;
case 276:return LL_RTC_CALIB_PERIOD_8SEC;
case 277:return LL_RTC_CALIB_LOWPOWER_NONE;
case 278:return LL_RTC_CALIB_LOWPOWER_SET;
case 279:return LL_RTC_BINARY_NONE;
case 280:return LL_RTC_BINARY_ONLY;
case 281:return LL_RTC_BINARY_MIX;
case 282:return LL_RTC_BINARY_MIX_BCDU_0;
case 283:return LL_RTC_BINARY_MIX_BCDU_1;
case 284:return LL_RTC_BINARY_MIX_BCDU_2;
case 285:return LL_RTC_BINARY_MIX_BCDU_3;
case 286:return LL_RTC_BINARY_MIX_BCDU_4;
case 287:return LL_RTC_BINARY_MIX_BCDU_5;
case 288:return LL_RTC_BINARY_MIX_BCDU_6;
case 289:return LL_RTC_BINARY_MIX_BCDU_7;
case 290:return LL_RTC_PRIVILEGE_FULL_YES;
case 291:return LL_RTC_PRIVILEGE_FULL_NO;
case 292:return LL_RTC_PRIVILEGE_FEATURE_INIT;
case 293:return LL_RTC_PRIVILEGE_FEATURE_CAL;
case 294:return LL_RTC_PRIVILEGE_FEATURE_TS;
case 295:return LL_RTC_PRIVILEGE_FEATURE_WUT;
case 296:return LL_RTC_PRIVILEGE_FEATURE_ALRA;
case 297:return LL_RTC_PRIVILEGE_FEATURE_ALRB;
case 298:return LL_TAMP_PRIVILEGE_FULL_YES;
case 299:return LL_TAMP_PRIVILEGE_FULL_NO;
case 300:return LL_RTC_PRIVILEGE_BKUP_ZONE_NONE;
case 301:return LL_RTC_PRIVILEGE_BKUP_ZONE_1;
case 302:return LL_RTC_PRIVILEGE_BKUP_ZONE_2;
case 303:return LL_RTC_PRIVILEGE_BKUP_ZONE_ALL;
case 304:return LL_IWDG_KEY_RELOAD;
case 305:return LL_IWDG_KEY_ENABLE;
case 306:return LL_IWDG_KEY_WR_ACCESS_ENABLE;
case 307:return LL_IWDG_KEY_WR_ACCESS_DISABLE;
case 308:return LL_IWDG_SR_PVU;
case 309:return LL_IWDG_SR_RVU;
case 310:return LL_IWDG_SR_WVU;
case 311:return LL_IWDG_PRESCALER_4;
case 312:return LL_IWDG_PRESCALER_8;
case 313:return LL_IWDG_PRESCALER_16;
case 314:return LL_IWDG_PRESCALER_32;
case 315:return LL_IWDG_PRESCALER_64;
case 316:return LL_IWDG_PRESCALER_128;
case 317:return LL_IWDG_PRESCALER_256;
case 318:return LL_IWDG_PRESCALER_512;
case 319:return LL_IWDG_PRESCALER_1024;
case 320:return LL_WWDG_CFR_EWI;
case 321:return LL_WWDG_PRESCALER_1;
case 322:return LL_WWDG_PRESCALER_2;
case 323:return LL_WWDG_PRESCALER_4;
case 324:return LL_WWDG_PRESCALER_8;
case 325:return LL_WWDG_PRESCALER_16;
case 326:return LL_WWDG_PRESCALER_32;
case 327:return LL_WWDG_PRESCALER_64;
case 328:return LL_WWDG_PRESCALER_128;
default:abort();}}
