#include "RTCInternal.h"
CRTCState *CRTC_Active;
RTC_TypeDef *CRTC_RTC;
TAMP_TypeDef *CRTC_TAMP;
size_t CRTC_Size(void) { return sizeof(CRTCState); }
static uint32_t area2Get(CRTCState *s,uint32_t i) { switch(i) {
 case 0:return s->h.Init.HourFormat;
 case 1:return s->h.Init.AsynchPrediv;
 case 2:return s->h.Init.SynchPrediv;
 case 3:return s->h.Init.OutPut;
 case 4:return s->h.Init.OutPutRemap;
 case 5:return s->h.Init.OutPutPolarity;
 case 6:return s->h.Init.OutPutType;
 case 7:return s->h.Init.OutPutPullUp;
 case 8:return s->h.Init.BinMode;
 case 9:return s->h.Init.BinMixBcdU;
 case 10:return s->h.Lock;
 case 11:return s->h.State;
 default:assert(0);return 0;} }
static void area2Set(CRTCState *s,uint32_t i,uint32_t v) { switch(i) {
 case 0:s->h.Init.HourFormat=v;break;
 case 1:s->h.Init.AsynchPrediv=v;break;
 case 2:s->h.Init.SynchPrediv=v;break;
 case 3:s->h.Init.OutPut=v;break;
 case 4:s->h.Init.OutPutRemap=v;break;
 case 5:s->h.Init.OutPutPolarity=v;break;
 case 6:s->h.Init.OutPutType=v;break;
 case 7:s->h.Init.OutPutPullUp=v;break;
 case 8:s->h.Init.BinMode=v;break;
 case 9:s->h.Init.BinMixBcdU=v;break;
 case 10:s->h.Lock=v;break;
 case 11:s->h.State=v;break;
 default:assert(0);} }
static uint32_t area3Get(CRTCState *s,uint32_t i) { switch(i) {
 case 0:return s->time.Hours;
 case 1:return s->time.Minutes;
 case 2:return s->time.Seconds;
 case 3:return s->time.TimeFormat;
 case 4:return s->time.SubSeconds;
 case 5:return s->time.SecondFraction;
 case 6:return s->time.DayLightSaving;
 case 7:return s->time.StoreOperation;
 default:assert(0);return 0;} }
static void area3Set(CRTCState *s,uint32_t i,uint32_t v) { switch(i) {
 case 0:s->time.Hours=v;break;
 case 1:s->time.Minutes=v;break;
 case 2:s->time.Seconds=v;break;
 case 3:s->time.TimeFormat=v;break;
 case 4:s->time.SubSeconds=v;break;
 case 5:s->time.SecondFraction=v;break;
 case 6:s->time.DayLightSaving=v;break;
 case 7:s->time.StoreOperation=v;break;
 default:assert(0);} }
static uint32_t area4Get(CRTCState *s,uint32_t i) { switch(i) {
 case 0:return s->date.WeekDay;
 case 1:return s->date.Month;
 case 2:return s->date.Date;
 case 3:return s->date.Year;
 default:assert(0);return 0;} }
static void area4Set(CRTCState *s,uint32_t i,uint32_t v) { switch(i) {
 case 0:s->date.WeekDay=v;break;
 case 1:s->date.Month=v;break;
 case 2:s->date.Date=v;break;
 case 3:s->date.Year=v;break;
 default:assert(0);} }
static uint32_t area5Get(CRTCState *s,uint32_t i) { switch(i) {
 case 0:return s->alarm.AlarmTime.Hours;
 case 1:return s->alarm.AlarmTime.Minutes;
 case 2:return s->alarm.AlarmTime.Seconds;
 case 3:return s->alarm.AlarmTime.TimeFormat;
 case 4:return s->alarm.AlarmTime.SubSeconds;
 case 5:return s->alarm.AlarmTime.SecondFraction;
 case 6:return s->alarm.AlarmTime.DayLightSaving;
 case 7:return s->alarm.AlarmTime.StoreOperation;
 case 8:return s->alarm.AlarmMask;
 case 9:return s->alarm.AlarmSubSecondMask;
 case 10:return s->alarm.BinaryAutoClr;
 case 11:return s->alarm.AlarmDateWeekDaySel;
 case 12:return s->alarm.AlarmDateWeekDay;
 case 13:return s->alarm.FlagAutoClr;
 case 14:return s->alarm.Alarm;
 default:assert(0);return 0;} }
static void area5Set(CRTCState *s,uint32_t i,uint32_t v) { switch(i) {
 case 0:s->alarm.AlarmTime.Hours=v;break;
 case 1:s->alarm.AlarmTime.Minutes=v;break;
 case 2:s->alarm.AlarmTime.Seconds=v;break;
 case 3:s->alarm.AlarmTime.TimeFormat=v;break;
 case 4:s->alarm.AlarmTime.SubSeconds=v;break;
 case 5:s->alarm.AlarmTime.SecondFraction=v;break;
 case 6:s->alarm.AlarmTime.DayLightSaving=v;break;
 case 7:s->alarm.AlarmTime.StoreOperation=v;break;
 case 8:s->alarm.AlarmMask=v;break;
 case 9:s->alarm.AlarmSubSecondMask=v;break;
 case 10:s->alarm.BinaryAutoClr=v;break;
 case 11:s->alarm.AlarmDateWeekDaySel=v;break;
 case 12:s->alarm.AlarmDateWeekDay=v;break;
 case 13:s->alarm.FlagAutoClr=v;break;
 case 14:s->alarm.Alarm=v;break;
 default:assert(0);} }
static uint32_t area6Get(CRTCState *s,uint32_t i) { switch(i) {
 case 0:return s->tamper.Tamper;
 case 1:return s->tamper.Trigger;
 case 2:return s->tamper.NoErase;
 case 3:return s->tamper.MaskFlag;
 case 4:return s->tamper.Filter;
 case 5:return s->tamper.SamplingFrequency;
 case 6:return s->tamper.PrechargeDuration;
 case 7:return s->tamper.TamperPullUp;
 case 8:return s->tamper.TimeStampOnTamperDetection;
 default:assert(0);return 0;} }
static void area6Set(CRTCState *s,uint32_t i,uint32_t v) { switch(i) {
 case 0:s->tamper.Tamper=v;break;
 case 1:s->tamper.Trigger=v;break;
 case 2:s->tamper.NoErase=v;break;
 case 3:s->tamper.MaskFlag=v;break;
 case 4:s->tamper.Filter=v;break;
 case 5:s->tamper.SamplingFrequency=v;break;
 case 6:s->tamper.PrechargeDuration=v;break;
 case 7:s->tamper.TamperPullUp=v;break;
 case 8:s->tamper.TimeStampOnTamperDetection=v;break;
 default:assert(0);} }
static uint32_t area7Get(CRTCState *s,uint32_t i) { switch(i) {
 case 0:return s->active.ActiveFilter;
 case 1:return s->active.ActiveAsyncPrescaler;
 case 2:return s->active.TimeStampOnTamperDetection;
 case 3:return s->active.ActiveOutputChangePeriod;
 case 4:return s->active.Seed[0];
 case 5:return s->active.Seed[1];
 case 6:return s->active.Seed[2];
 case 7:return s->active.Seed[3];
 case 8:return s->active.TampInput[0].Enable;
 case 9:return s->active.TampInput[0].Interrupt;
 case 10:return s->active.TampInput[0].Output;
 case 11:return s->active.TampInput[0].NoErase;
 case 12:return s->active.TampInput[0].MaskFlag;
 case 13:return s->active.TampInput[1].Enable;
 case 14:return s->active.TampInput[1].Interrupt;
 case 15:return s->active.TampInput[1].Output;
 case 16:return s->active.TampInput[1].NoErase;
 case 17:return s->active.TampInput[1].MaskFlag;
 case 18:return s->active.TampInput[2].Enable;
 case 19:return s->active.TampInput[2].Interrupt;
 case 20:return s->active.TampInput[2].Output;
 case 21:return s->active.TampInput[2].NoErase;
 case 22:return s->active.TampInput[2].MaskFlag;
 case 23:return s->active.TampInput[3].Enable;
 case 24:return s->active.TampInput[3].Interrupt;
 case 25:return s->active.TampInput[3].Output;
 case 26:return s->active.TampInput[3].NoErase;
 case 27:return s->active.TampInput[3].MaskFlag;
 case 28:return s->active.TampInput[4].Enable;
 case 29:return s->active.TampInput[4].Interrupt;
 case 30:return s->active.TampInput[4].Output;
 case 31:return s->active.TampInput[4].NoErase;
 case 32:return s->active.TampInput[4].MaskFlag;
 case 33:return s->active.TampInput[5].Enable;
 case 34:return s->active.TampInput[5].Interrupt;
 case 35:return s->active.TampInput[5].Output;
 case 36:return s->active.TampInput[5].NoErase;
 case 37:return s->active.TampInput[5].MaskFlag;
 case 38:return s->active.TampInput[6].Enable;
 case 39:return s->active.TampInput[6].Interrupt;
 case 40:return s->active.TampInput[6].Output;
 case 41:return s->active.TampInput[6].NoErase;
 case 42:return s->active.TampInput[6].MaskFlag;
 case 43:return s->active.TampInput[7].Enable;
 case 44:return s->active.TampInput[7].Interrupt;
 case 45:return s->active.TampInput[7].Output;
 case 46:return s->active.TampInput[7].NoErase;
 case 47:return s->active.TampInput[7].MaskFlag;
 default:assert(0);return 0;} }
static void area7Set(CRTCState *s,uint32_t i,uint32_t v) { switch(i) {
 case 0:s->active.ActiveFilter=v;break;
 case 1:s->active.ActiveAsyncPrescaler=v;break;
 case 2:s->active.TimeStampOnTamperDetection=v;break;
 case 3:s->active.ActiveOutputChangePeriod=v;break;
 case 4:s->active.Seed[0]=v;break;
 case 5:s->active.Seed[1]=v;break;
 case 6:s->active.Seed[2]=v;break;
 case 7:s->active.Seed[3]=v;break;
 case 8:s->active.TampInput[0].Enable=v;break;
 case 9:s->active.TampInput[0].Interrupt=v;break;
 case 10:s->active.TampInput[0].Output=v;break;
 case 11:s->active.TampInput[0].NoErase=v;break;
 case 12:s->active.TampInput[0].MaskFlag=v;break;
 case 13:s->active.TampInput[1].Enable=v;break;
 case 14:s->active.TampInput[1].Interrupt=v;break;
 case 15:s->active.TampInput[1].Output=v;break;
 case 16:s->active.TampInput[1].NoErase=v;break;
 case 17:s->active.TampInput[1].MaskFlag=v;break;
 case 18:s->active.TampInput[2].Enable=v;break;
 case 19:s->active.TampInput[2].Interrupt=v;break;
 case 20:s->active.TampInput[2].Output=v;break;
 case 21:s->active.TampInput[2].NoErase=v;break;
 case 22:s->active.TampInput[2].MaskFlag=v;break;
 case 23:s->active.TampInput[3].Enable=v;break;
 case 24:s->active.TampInput[3].Interrupt=v;break;
 case 25:s->active.TampInput[3].Output=v;break;
 case 26:s->active.TampInput[3].NoErase=v;break;
 case 27:s->active.TampInput[3].MaskFlag=v;break;
 case 28:s->active.TampInput[4].Enable=v;break;
 case 29:s->active.TampInput[4].Interrupt=v;break;
 case 30:s->active.TampInput[4].Output=v;break;
 case 31:s->active.TampInput[4].NoErase=v;break;
 case 32:s->active.TampInput[4].MaskFlag=v;break;
 case 33:s->active.TampInput[5].Enable=v;break;
 case 34:s->active.TampInput[5].Interrupt=v;break;
 case 35:s->active.TampInput[5].Output=v;break;
 case 36:s->active.TampInput[5].NoErase=v;break;
 case 37:s->active.TampInput[5].MaskFlag=v;break;
 case 38:s->active.TampInput[6].Enable=v;break;
 case 39:s->active.TampInput[6].Interrupt=v;break;
 case 40:s->active.TampInput[6].Output=v;break;
 case 41:s->active.TampInput[6].NoErase=v;break;
 case 42:s->active.TampInput[6].MaskFlag=v;break;
 case 43:s->active.TampInput[7].Enable=v;break;
 case 44:s->active.TampInput[7].Interrupt=v;break;
 case 45:s->active.TampInput[7].Output=v;break;
 case 46:s->active.TampInput[7].NoErase=v;break;
 case 47:s->active.TampInput[7].MaskFlag=v;break;
 default:assert(0);} }
static uint32_t area8Get(CRTCState *s,uint32_t i) { switch(i) {
 case 0:return s->internal.IntTamper;
 case 1:return s->internal.TimeStampOnTamperDetection;
 case 2:return s->internal.NoErase;
 default:assert(0);return 0;} }
static void area8Set(CRTCState *s,uint32_t i,uint32_t v) { switch(i) {
 case 0:s->internal.IntTamper=v;break;
 case 1:s->internal.TimeStampOnTamperDetection=v;break;
 case 2:s->internal.NoErase=v;break;
 default:assert(0);} }
static uint32_t area9Get(CRTCState *s,uint32_t i) { switch(i) {
 case 0:return s->priv.rtcPrivilegeFull;
 case 1:return s->priv.rtcPrivilegeFeatures;
 case 2:return s->priv.tampPrivilegeFull;
 case 3:return s->priv.backupRegisterPrivZone;
 case 4:return s->priv.backupRegisterStartZone2;
 case 5:return s->priv.backupRegisterStartZone3;
 case 6:return s->priv.MonotonicCounterPrivilege;
 default:assert(0);return 0;} }
static void area9Set(CRTCState *s,uint32_t i,uint32_t v) { switch(i) {
 case 0:s->priv.rtcPrivilegeFull=v;break;
 case 1:s->priv.rtcPrivilegeFeatures=v;break;
 case 2:s->priv.tampPrivilegeFull=v;break;
 case 3:s->priv.backupRegisterPrivZone=v;break;
 case 4:s->priv.backupRegisterStartZone2=v;break;
 case 5:s->priv.backupRegisterStartZone3=v;break;
 case 6:s->priv.MonotonicCounterPrivilege=v;break;
 default:assert(0);} }
void CRTC_Reset(CRTCState *s,uint32_t mode) {
 memset(s,0,sizeof(*s));s->mode=mode;s->h.Instance=(RTC_TypeDef*)s->regs;
 s->h.State=HAL_RTC_STATE_READY;s->control[0]=1001;s->control[1]=0x64;
 s->date.Month=1;s->date.Date=1;s->date.WeekDay=1;s->alarm.Alarm=RTC_ALARM_A;s->alarm.AlarmDateWeekDay=1;
 s->tamper.Tamper=1;s->internal.IntTamper=RTC_INT_TAMPER_1;
 for(uint32_t i=0;i<26;i++)CRTC_SetCallback(s,i,1);
}
uint32_t CRTC_Get(CRTCState *s,uint32_t area,uint32_t i) { switch(area) {
 case 0:assert(i<32);return s->regs[i];case 1:assert(i<96);return s->tamp[i];
 case 2:return area2Get(s,i);
 case 3:return area3Get(s,i);
 case 4:return area4Get(s,i);
 case 5:return area5Get(s,i);
 case 6:return area6Get(s,i);
 case 7:return area7Get(s,i);
 case 8:return area8Get(s,i);
 case 9:return area9Get(s,i);
 case 10:assert(i<8);return s->control[i];case 11:return i?s->tickCalls:s->tick;
 case 12:return s->output;case 13:return s->traceCount;case 14:return s->mode;
 case 15:assert(i<32);return s->legacy[i];default:assert(0);return 0;
} }
void CRTC_Set(CRTCState *s,uint32_t area,uint32_t i,uint32_t v) { switch(area) {
 case 0:assert(i<32);s->regs[i]=v;break;case 1:assert(i<96);s->tamp[i]=v;break;
 case 2:area2Set(s,i,v);break;
 case 3:area3Set(s,i,v);break;
 case 4:area4Set(s,i,v);break;
 case 5:area5Set(s,i,v);break;
 case 6:area6Set(s,i,v);break;
 case 7:area7Set(s,i,v);break;
 case 8:area8Set(s,i,v);break;
 case 9:area9Set(s,i,v);break;
 case 10:assert(i<8);s->control[i]=v;if(i==7)s->h.Instance=(RTC_TypeDef*)(v?s->legacy:s->regs);break;
 case 11:if(i)s->tickCalls=v;else s->tick=v;break;case 12:s->output=v;break;case 13:s->traceCount=v;break;
 case 15:assert(i<32);s->legacy[i]=v;break;default:assert(0);
} }
uint32_t CRTC_TickFor(CRTCState *s) {
 uint32_t value=s->tick;s->tick+=s->control[0];s->tickCalls++;
 s->regs[3]|=s->control[1];
 if(s->control[2] && s->tickCalls==s->control[2])CRTC_Set(s,s->control[3],s->control[4],s->control[5]);
 return value;
}
uint32_t CRTC_Tick(void) { return CRTC_TickFor(CRTC_Active); }
void CRTC_Callback(CRTCState *s,uint32_t id,uint32_t token) {
 assert(s->traceCount<32);uint32_t *out=s->trace[s->traceCount++],n=0;
 out[n++]=id;out[n++]=token;
 for(uint32_t i=0;i<32;i++)out[n++]=s->regs[i];
 for(uint32_t i=0;i<96;i++)out[n++]=s->tamp[i];
 for(uint32_t i=0;i<12;i++)out[n++]=area2Get(s,i);
 for(uint32_t i=0;i<26;i++)out[n++]=CRTC_GetCallback(s,i);
 while(n<192)out[n++]=0;
 if(s->control[6]&1) {s->h.State=255;s->regs[0x54/4]=0;s->tamp[0x34/4]=0;for(uint32_t i=0;i<26;i++)CRTC_SetCallback(s,i,2);}
 if((s->control[6]&2) && id==24)s->h.Init.HourFormat=RTC_HOURFORMAT_12;
}
uint32_t CRTC_TraceWord(CRTCState *s,uint32_t e,uint32_t i) { assert(e<32&&i<192);return s->trace[e][i]; }
uint32_t CRTC_Run(CRTCState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {
 CRTC_Active=s;CRTC_RTC=(RTC_TypeDef*)s->regs;CRTC_TAMP=(TAMP_TypeDef*)s->tamp;
 return s->mode?CRTC1_Run(s,op,a,b,c):CRTC0_Run(s,op,a,b,c);
}
