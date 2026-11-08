#include "LPTIMInternal.h"
void HAL_LPTIM_MspInit(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,0,1); }
static void cb0(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,0,2); }
void HAL_LPTIM_MspDeInit(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,1,1); }
static void cb1(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,1,2); }
void HAL_LPTIM_CompareMatchCallback(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,2,1); }
static void cb2(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,2,2); }
void HAL_LPTIM_AutoReloadMatchCallback(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,3,1); }
static void cb3(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,3,2); }
void HAL_LPTIM_TriggerCallback(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,4,1); }
static void cb4(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,4,2); }
void HAL_LPTIM_CompareWriteCallback(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,5,1); }
static void cb5(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,5,2); }
void HAL_LPTIM_AutoReloadWriteCallback(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,6,1); }
static void cb6(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,6,2); }
void HAL_LPTIM_DirectionUpCallback(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,7,1); }
static void cb7(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,7,2); }
void HAL_LPTIM_DirectionDownCallback(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,8,1); }
static void cb8(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,8,2); }
void HAL_LPTIM_UpdateEventCallback(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,9,1); }
static void cb9(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,9,2); }
void HAL_LPTIM_RepCounterWriteCallback(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,10,1); }
static void cb10(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,10,2); }
void HAL_LPTIM_UpdateEventHalfCpltCallback(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,11,1); }
static void cb11(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,11,2); }
void HAL_LPTIM_ErrorCallback(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,12,1); }
static void cb12(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,12,2); }
void HAL_LPTIM_IC_CaptureCallback(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,13,1); }
static void cb13(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,13,2); }
void HAL_LPTIM_IC_CaptureHalfCpltCallback(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,14,1); }
static void cb14(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,14,2); }
void HAL_LPTIM_IC_OverCaptureCallback(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,15,1); }
static void cb15(LPTIM_HandleTypeDef *h) { (void)h;CLPTIM_Callback(CLPTIM_Active,15,2); }
pLPTIM_CallbackTypeDef CLPTIM_CallbackPointer(uint32_t id,uint32_t token) {
 if(!token)return NULL;
 switch(id) {
 case 0:return token==1?HAL_LPTIM_MspInit:cb0;
 case 1:return token==1?HAL_LPTIM_MspDeInit:cb1;
 case 2:return token==1?HAL_LPTIM_CompareMatchCallback:cb2;
 case 3:return token==1?HAL_LPTIM_AutoReloadMatchCallback:cb3;
 case 4:return token==1?HAL_LPTIM_TriggerCallback:cb4;
 case 5:return token==1?HAL_LPTIM_CompareWriteCallback:cb5;
 case 6:return token==1?HAL_LPTIM_AutoReloadWriteCallback:cb6;
 case 7:return token==1?HAL_LPTIM_DirectionUpCallback:cb7;
 case 8:return token==1?HAL_LPTIM_DirectionDownCallback:cb8;
 case 9:return token==1?HAL_LPTIM_UpdateEventCallback:cb9;
 case 10:return token==1?HAL_LPTIM_RepCounterWriteCallback:cb10;
 case 11:return token==1?HAL_LPTIM_UpdateEventHalfCpltCallback:cb11;
 case 12:return token==1?HAL_LPTIM_ErrorCallback:cb12;
 case 13:return token==1?HAL_LPTIM_IC_CaptureCallback:cb13;
 case 14:return token==1?HAL_LPTIM_IC_CaptureHalfCpltCallback:cb14;
 case 15:return token==1?HAL_LPTIM_IC_OverCaptureCallback:cb15;
 default:return cb0;
 }
}
void CLPTIM_SetCallback(CLPTIMState *s,uint32_t id,uint32_t token) {
 switch(id) {
 case 0:s->handle.MspInitCallback=CLPTIM_CallbackPointer(id,token);break;
 case 1:s->handle.MspDeInitCallback=CLPTIM_CallbackPointer(id,token);break;
 case 2:s->handle.CompareMatchCallback=CLPTIM_CallbackPointer(id,token);break;
 case 3:s->handle.AutoReloadMatchCallback=CLPTIM_CallbackPointer(id,token);break;
 case 4:s->handle.TriggerCallback=CLPTIM_CallbackPointer(id,token);break;
 case 5:s->handle.CompareWriteCallback=CLPTIM_CallbackPointer(id,token);break;
 case 6:s->handle.AutoReloadWriteCallback=CLPTIM_CallbackPointer(id,token);break;
 case 7:s->handle.DirectionUpCallback=CLPTIM_CallbackPointer(id,token);break;
 case 8:s->handle.DirectionDownCallback=CLPTIM_CallbackPointer(id,token);break;
 case 9:s->handle.UpdateEventCallback=CLPTIM_CallbackPointer(id,token);break;
 case 10:s->handle.RepCounterWriteCallback=CLPTIM_CallbackPointer(id,token);break;
 case 11:s->handle.UpdateEventHalfCpltCallback=CLPTIM_CallbackPointer(id,token);break;
 case 12:s->handle.ErrorCallback=CLPTIM_CallbackPointer(id,token);break;
 case 13:s->handle.IC_CaptureCallback=CLPTIM_CallbackPointer(id,token);break;
 case 14:s->handle.IC_CaptureHalfCpltCallback=CLPTIM_CallbackPointer(id,token);break;
 case 15:s->handle.IC_OverCaptureCallback=CLPTIM_CallbackPointer(id,token);break;
 default:assert(0);
 }
}
uint32_t CLPTIM_GetCallback(CLPTIMState *s,uint32_t id) {
 pLPTIM_CallbackTypeDef cb=NULL;
 switch(id) {
 case 0:cb=s->handle.MspInitCallback;break;
 case 1:cb=s->handle.MspDeInitCallback;break;
 case 2:cb=s->handle.CompareMatchCallback;break;
 case 3:cb=s->handle.AutoReloadMatchCallback;break;
 case 4:cb=s->handle.TriggerCallback;break;
 case 5:cb=s->handle.CompareWriteCallback;break;
 case 6:cb=s->handle.AutoReloadWriteCallback;break;
 case 7:cb=s->handle.DirectionUpCallback;break;
 case 8:cb=s->handle.DirectionDownCallback;break;
 case 9:cb=s->handle.UpdateEventCallback;break;
 case 10:cb=s->handle.RepCounterWriteCallback;break;
 case 11:cb=s->handle.UpdateEventHalfCpltCallback;break;
 case 12:cb=s->handle.ErrorCallback;break;
 case 13:cb=s->handle.IC_CaptureCallback;break;
 case 14:cb=s->handle.IC_CaptureHalfCpltCallback;break;
 case 15:cb=s->handle.IC_OverCaptureCallback;break;
 default:assert(0);
 }
 return !cb?0:cb==CLPTIM_CallbackPointer(id,1)?1:2;
}
