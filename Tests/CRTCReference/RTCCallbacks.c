#include "RTCInternal.h"
void HAL_RTC_AlarmAEventCallback(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),0,1); }
static void custom0(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),0,2); }
void HAL_RTCEx_AlarmBEventCallback(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),1,1); }
static void custom1(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),1,2); }
void HAL_RTCEx_TimeStampEventCallback(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),2,1); }
static void custom2(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),2,2); }
void HAL_RTCEx_WakeUpTimerEventCallback(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),3,1); }
static void custom3(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),3,2); }
void HAL_RTCEx_SSRUEventCallback(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),4,1); }
static void custom4(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),4,2); }
void HAL_RTCEx_Tamper1EventCallback(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),5,1); }
static void custom5(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),5,2); }
void HAL_RTCEx_Tamper2EventCallback(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),6,1); }
static void custom6(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),6,2); }
void HAL_RTCEx_Tamper3EventCallback(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),7,1); }
static void custom7(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),7,2); }
void HAL_RTCEx_Tamper4EventCallback(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),8,1); }
static void custom8(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),8,2); }
void HAL_RTCEx_Tamper5EventCallback(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),9,1); }
static void custom9(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),9,2); }
void HAL_RTCEx_Tamper6EventCallback(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),10,1); }
static void custom10(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),10,2); }
void HAL_RTCEx_Tamper7EventCallback(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),11,1); }
static void custom11(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),11,2); }
void HAL_RTCEx_Tamper8EventCallback(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),12,1); }
static void custom12(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),12,2); }
void HAL_RTCEx_InternalTamper1EventCallback(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),13,1); }
static void custom13(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),13,2); }
void HAL_RTCEx_InternalTamper2EventCallback(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),14,1); }
static void custom14(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),14,2); }
void HAL_RTCEx_InternalTamper3EventCallback(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),15,1); }
static void custom15(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),15,2); }
void HAL_RTCEx_InternalTamper4EventCallback(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),16,1); }
static void custom16(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),16,2); }
void HAL_RTCEx_InternalTamper5EventCallback(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),17,1); }
static void custom17(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),17,2); }
void HAL_RTCEx_InternalTamper6EventCallback(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),18,1); }
static void custom18(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),18,2); }
void HAL_RTCEx_InternalTamper7EventCallback(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),19,1); }
static void custom19(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),19,2); }
void HAL_RTCEx_InternalTamper8EventCallback(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),20,1); }
static void custom20(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),20,2); }
void HAL_RTCEx_InternalTamper9EventCallback(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),21,1); }
static void custom21(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),21,2); }
void HAL_RTCEx_InternalTamper11EventCallback(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),22,1); }
static void custom22(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),22,2); }
void HAL_RTCEx_InternalTamper15EventCallback(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),23,1); }
static void custom23(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),23,2); }
void HAL_RTC_MspInit(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),24,1); }
static void custom24(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),24,2); }
void HAL_RTC_MspDeInit(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),25,1); }
static void custom25(RTC_HandleTypeDef *h) { CRTC_Callback((CRTCState*)((char*)h - offsetof(CRTCState,h)),25,2); }
pRTC_CallbackTypeDef CRTC_CallbackPointer(uint32_t id,uint32_t token) { if(!token)return NULL; switch(id) {
 case 0:return token==1?HAL_RTC_AlarmAEventCallback:custom0;
 case 1:return token==1?HAL_RTCEx_AlarmBEventCallback:custom1;
 case 2:return token==1?HAL_RTCEx_TimeStampEventCallback:custom2;
 case 3:return token==1?HAL_RTCEx_WakeUpTimerEventCallback:custom3;
 case 4:return token==1?HAL_RTCEx_SSRUEventCallback:custom4;
 case 5:return token==1?HAL_RTCEx_Tamper1EventCallback:custom5;
 case 6:return token==1?HAL_RTCEx_Tamper2EventCallback:custom6;
 case 7:return token==1?HAL_RTCEx_Tamper3EventCallback:custom7;
 case 8:return token==1?HAL_RTCEx_Tamper4EventCallback:custom8;
 case 9:return token==1?HAL_RTCEx_Tamper5EventCallback:custom9;
 case 10:return token==1?HAL_RTCEx_Tamper6EventCallback:custom10;
 case 11:return token==1?HAL_RTCEx_Tamper7EventCallback:custom11;
 case 12:return token==1?HAL_RTCEx_Tamper8EventCallback:custom12;
 case 13:return token==1?HAL_RTCEx_InternalTamper1EventCallback:custom13;
 case 14:return token==1?HAL_RTCEx_InternalTamper2EventCallback:custom14;
 case 15:return token==1?HAL_RTCEx_InternalTamper3EventCallback:custom15;
 case 16:return token==1?HAL_RTCEx_InternalTamper4EventCallback:custom16;
 case 17:return token==1?HAL_RTCEx_InternalTamper5EventCallback:custom17;
 case 18:return token==1?HAL_RTCEx_InternalTamper6EventCallback:custom18;
 case 19:return token==1?HAL_RTCEx_InternalTamper7EventCallback:custom19;
 case 20:return token==1?HAL_RTCEx_InternalTamper8EventCallback:custom20;
 case 21:return token==1?HAL_RTCEx_InternalTamper9EventCallback:custom21;
 case 22:return token==1?HAL_RTCEx_InternalTamper11EventCallback:custom22;
 case 23:return token==1?HAL_RTCEx_InternalTamper15EventCallback:custom23;
 case 24:return token==1?HAL_RTC_MspInit:custom24;
 case 25:return token==1?HAL_RTC_MspDeInit:custom25;
 default:return NULL;} }
uint32_t CRTC_GetCallback(CRTCState *s,uint32_t id) {pRTC_CallbackTypeDef p; switch(id) {
 case 0:p=s->h.AlarmAEventCallback;break;
 case 1:p=s->h.AlarmBEventCallback;break;
 case 2:p=s->h.TimeStampEventCallback;break;
 case 3:p=s->h.WakeUpTimerEventCallback;break;
 case 4:p=s->h.SSRUEventCallback;break;
 case 5:p=s->h.Tamper1EventCallback;break;
 case 6:p=s->h.Tamper2EventCallback;break;
 case 7:p=s->h.Tamper3EventCallback;break;
 case 8:p=s->h.Tamper4EventCallback;break;
 case 9:p=s->h.Tamper5EventCallback;break;
 case 10:p=s->h.Tamper6EventCallback;break;
 case 11:p=s->h.Tamper7EventCallback;break;
 case 12:p=s->h.Tamper8EventCallback;break;
 case 13:p=s->h.InternalTamper1EventCallback;break;
 case 14:p=s->h.InternalTamper2EventCallback;break;
 case 15:p=s->h.InternalTamper3EventCallback;break;
 case 16:p=s->h.InternalTamper4EventCallback;break;
 case 17:p=s->h.InternalTamper5EventCallback;break;
 case 18:p=s->h.InternalTamper6EventCallback;break;
 case 19:p=s->h.InternalTamper7EventCallback;break;
 case 20:p=s->h.InternalTamper8EventCallback;break;
 case 21:p=s->h.InternalTamper9EventCallback;break;
 case 22:p=s->h.InternalTamper11EventCallback;break;
 case 23:p=s->h.InternalTamper15EventCallback;break;
 case 24:p=s->h.MspInitCallback;break;
 case 25:p=s->h.MspDeInitCallback;break;
 default:assert(0);return 0;} return p==NULL?0:p==CRTC_CallbackPointer(id,1)?1:2; }
void CRTC_SetCallback(CRTCState *s,uint32_t id,uint32_t token) { switch(id) {
 case 0:s->h.AlarmAEventCallback=CRTC_CallbackPointer(id,token);break;
 case 1:s->h.AlarmBEventCallback=CRTC_CallbackPointer(id,token);break;
 case 2:s->h.TimeStampEventCallback=CRTC_CallbackPointer(id,token);break;
 case 3:s->h.WakeUpTimerEventCallback=CRTC_CallbackPointer(id,token);break;
 case 4:s->h.SSRUEventCallback=CRTC_CallbackPointer(id,token);break;
 case 5:s->h.Tamper1EventCallback=CRTC_CallbackPointer(id,token);break;
 case 6:s->h.Tamper2EventCallback=CRTC_CallbackPointer(id,token);break;
 case 7:s->h.Tamper3EventCallback=CRTC_CallbackPointer(id,token);break;
 case 8:s->h.Tamper4EventCallback=CRTC_CallbackPointer(id,token);break;
 case 9:s->h.Tamper5EventCallback=CRTC_CallbackPointer(id,token);break;
 case 10:s->h.Tamper6EventCallback=CRTC_CallbackPointer(id,token);break;
 case 11:s->h.Tamper7EventCallback=CRTC_CallbackPointer(id,token);break;
 case 12:s->h.Tamper8EventCallback=CRTC_CallbackPointer(id,token);break;
 case 13:s->h.InternalTamper1EventCallback=CRTC_CallbackPointer(id,token);break;
 case 14:s->h.InternalTamper2EventCallback=CRTC_CallbackPointer(id,token);break;
 case 15:s->h.InternalTamper3EventCallback=CRTC_CallbackPointer(id,token);break;
 case 16:s->h.InternalTamper4EventCallback=CRTC_CallbackPointer(id,token);break;
 case 17:s->h.InternalTamper5EventCallback=CRTC_CallbackPointer(id,token);break;
 case 18:s->h.InternalTamper6EventCallback=CRTC_CallbackPointer(id,token);break;
 case 19:s->h.InternalTamper7EventCallback=CRTC_CallbackPointer(id,token);break;
 case 20:s->h.InternalTamper8EventCallback=CRTC_CallbackPointer(id,token);break;
 case 21:s->h.InternalTamper9EventCallback=CRTC_CallbackPointer(id,token);break;
 case 22:s->h.InternalTamper11EventCallback=CRTC_CallbackPointer(id,token);break;
 case 23:s->h.InternalTamper15EventCallback=CRTC_CallbackPointer(id,token);break;
 case 24:s->h.MspInitCallback=CRTC_CallbackPointer(id,token);break;
 case 25:s->h.MspDeInitCallback=CRTC_CallbackPointer(id,token);break;
default:assert(0);} }
