#include "GFXTIMInternal.h"
void HAL_GFXTIM_AbsoluteTimer_AFCC1Callback(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,1,1); }
static void custom1(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,1,2); }
void HAL_GFXTIM_AbsoluteTimer_AFCOFCallback(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,2,1); }
static void custom2(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,2,2); }
void HAL_GFXTIM_AbsoluteTimer_ALCC1Callback(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,3,1); }
static void custom3(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,3,2); }
void HAL_GFXTIM_AbsoluteTimer_ALCC2Callback(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,4,1); }
static void custom4(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,4,2); }
void HAL_GFXTIM_AbsoluteTimer_ALCOFCallback(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,5,1); }
static void custom5(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,5,2); }
void HAL_GFXTIM_RelativeTimer_RFC1RCallback(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,6,1); }
static void custom6(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,6,2); }
void HAL_GFXTIM_RelativeTimer_RFC2RCallback(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,7,1); }
static void custom7(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,7,2); }
void HAL_GFXTIM_TECallback(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,8,1); }
static void custom8(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,8,2); }
void HAL_GFXTIM_EventGenerator_EV1Callback(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,9,1); }
static void custom9(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,9,2); }
void HAL_GFXTIM_EventGenerator_EV2Callback(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,10,1); }
static void custom10(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,10,2); }
void HAL_GFXTIM_EventGenerator_EV3Callback(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,11,1); }
static void custom11(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,11,2); }
void HAL_GFXTIM_EventGenerator_EV4Callback(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,12,1); }
static void custom12(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,12,2); }
void HAL_GFXTIM_WatchdogTimer_AlarmCallback(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,13,1); }
static void custom13(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,13,2); }
void HAL_GFXTIM_WatchdogTimer_PreAlarmCallback(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,14,1); }
static void custom14(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,14,2); }
void HAL_GFXTIM_ErrorCallback(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,15,1); }
static void custom15(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,15,2); }
void HAL_GFXTIM_MspInit(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,16,1); }
static void custom16(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,16,2); }
void HAL_GFXTIM_MspDeInit(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,17,1); }
static void custom17(GFXTIM_HandleTypeDef *h) { (void)h;CGFXTIM_Callback(CGFXTIM_Active,17,2); }
pGFXTIM_CallbackTypeDef CGFXTIM_CallbackPointer(uint32_t id,uint32_t token) {
    if(!token)return NULL;
    switch(id) {
    case 1:return token==1?HAL_GFXTIM_AbsoluteTimer_AFCC1Callback:custom1;
    case 2:return token==1?HAL_GFXTIM_AbsoluteTimer_AFCOFCallback:custom2;
    case 3:return token==1?HAL_GFXTIM_AbsoluteTimer_ALCC1Callback:custom3;
    case 4:return token==1?HAL_GFXTIM_AbsoluteTimer_ALCC2Callback:custom4;
    case 5:return token==1?HAL_GFXTIM_AbsoluteTimer_ALCOFCallback:custom5;
    case 6:return token==1?HAL_GFXTIM_RelativeTimer_RFC1RCallback:custom6;
    case 7:return token==1?HAL_GFXTIM_RelativeTimer_RFC2RCallback:custom7;
    case 8:return token==1?HAL_GFXTIM_TECallback:custom8;
    case 9:return token==1?HAL_GFXTIM_EventGenerator_EV1Callback:custom9;
    case 10:return token==1?HAL_GFXTIM_EventGenerator_EV2Callback:custom10;
    case 11:return token==1?HAL_GFXTIM_EventGenerator_EV3Callback:custom11;
    case 12:return token==1?HAL_GFXTIM_EventGenerator_EV4Callback:custom12;
    case 13:return token==1?HAL_GFXTIM_WatchdogTimer_AlarmCallback:custom13;
    case 14:return token==1?HAL_GFXTIM_WatchdogTimer_PreAlarmCallback:custom14;
    case 15:return token==1?HAL_GFXTIM_ErrorCallback:custom15;
    case 16:return token==1?HAL_GFXTIM_MspInit:custom16;
    case 17:return token==1?HAL_GFXTIM_MspDeInit:custom17;
    default:return custom1;
    }
}
static pGFXTIM_CallbackTypeDef *slot(CGFXTIMState *s,uint32_t id) {
    switch(id) {
    case 1:return &s->handle.HAL_GFXTIM_AbsoluteTimer_AFCC1Callback;
    case 2:return &s->handle.HAL_GFXTIM_AbsoluteTimer_AFCOFCallback;
    case 3:return &s->handle.HAL_GFXTIM_AbsoluteTimer_ALCC1Callback;
    case 4:return &s->handle.HAL_GFXTIM_AbsoluteTimer_ALCC2Callback;
    case 5:return &s->handle.HAL_GFXTIM_AbsoluteTimer_ALCOFCallback;
    case 6:return &s->handle.HAL_GFXTIM_RelativeTimer_RFC1RCallback;
    case 7:return &s->handle.HAL_GFXTIM_RelativeTimer_RFC2RCallback;
    case 8:return &s->handle.HAL_GFXTIM_TECallback;
    case 9:return &s->handle.HAL_GFXTIM_EventGenerator_EV1Callback;
    case 10:return &s->handle.HAL_GFXTIM_EventGenerator_EV2Callback;
    case 11:return &s->handle.HAL_GFXTIM_EventGenerator_EV3Callback;
    case 12:return &s->handle.HAL_GFXTIM_EventGenerator_EV4Callback;
    case 13:return &s->handle.HAL_GFXTIM_WatchdogTimer_AlarmCallback;
    case 14:return &s->handle.HAL_GFXTIM_WatchdogTimer_PreAlarmCallback;
    case 15:return &s->handle.ErrorCallback;
    case 16:return &s->handle.MspInitCallback;
    case 17:return &s->handle.MspDeInitCallback;
    default:assert(0);return NULL;
    }
}
void CGFXTIM_SetCallback(CGFXTIMState *s,uint32_t id,uint32_t token) { *slot(s,id)=CGFXTIM_CallbackPointer(id,token); }
uint32_t CGFXTIM_GetCallback(CGFXTIMState *s,uint32_t id) { pGFXTIM_CallbackTypeDef cb=*slot(s,id);return !cb?0:cb==CGFXTIM_CallbackPointer(id,1)?1:2; }
