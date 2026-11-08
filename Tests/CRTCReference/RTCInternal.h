#ifndef CRTC_INTERNAL_H
#define CRTC_INTERNAL_H
#include "include/CRTCReference.h"
#include "RTCDefinitions.h"
#include <assert.h>
struct CRTCState {
 uint32_t regs[32],tamp[96],legacy[32]; RTC_HandleTypeDef h;
 RTC_TimeTypeDef time; RTC_DateTypeDef date; RTC_AlarmTypeDef alarm;
 RTC_TamperTypeDef tamper; RTC_ActiveTampersTypeDef active;
 RTC_InternalTamperTypeDef internal; RTC_PrivilegeStateTypeDef priv;
 uint32_t mode,control[8],tick,tickCalls,output,traceCount,trace[32][192];
};
extern CRTCState *CRTC_Active;
pRTC_CallbackTypeDef CRTC_CallbackPointer(uint32_t,uint32_t);
uint32_t CRTC0_Run(CRTCState *,uint32_t,uint32_t,uint32_t,uint32_t);
uint32_t CRTC1_Run(CRTCState *,uint32_t,uint32_t,uint32_t,uint32_t);
#endif
