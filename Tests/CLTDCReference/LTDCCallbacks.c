#include "LTDCInternal.h"
void HAL_LTDC_MspInit(LTDC_HandleTypeDef *h) { (void)h;CLTDC_Callback(CLTDC_Active,0,1); }
static void custom0(LTDC_HandleTypeDef *h) { (void)h;CLTDC_Callback(CLTDC_Active,0,2); }
void HAL_LTDC_MspDeInit(LTDC_HandleTypeDef *h) { (void)h;CLTDC_Callback(CLTDC_Active,1,1); }
static void custom1(LTDC_HandleTypeDef *h) { (void)h;CLTDC_Callback(CLTDC_Active,1,2); }
void HAL_LTDC_LineEventCallback(LTDC_HandleTypeDef *h) { (void)h;CLTDC_Callback(CLTDC_Active,2,1); }
static void custom2(LTDC_HandleTypeDef *h) { (void)h;CLTDC_Callback(CLTDC_Active,2,2); }
void HAL_LTDC_ReloadEventCallback(LTDC_HandleTypeDef *h) { (void)h;CLTDC_Callback(CLTDC_Active,3,1); }
static void custom3(LTDC_HandleTypeDef *h) { (void)h;CLTDC_Callback(CLTDC_Active,3,2); }
void HAL_LTDC_ErrorCallback(LTDC_HandleTypeDef *h) { (void)h;CLTDC_Callback(CLTDC_Active,4,1); }
static void custom4(LTDC_HandleTypeDef *h) { (void)h;CLTDC_Callback(CLTDC_Active,4,2); }
pLTDC_CallbackTypeDef CLTDC_CallbackPointer(uint32_t id,uint32_t token) {
    if(!token)return NULL;
    switch(id) {
    case 0:return token==1?HAL_LTDC_MspInit:custom0;
    case 1:return token==1?HAL_LTDC_MspDeInit:custom1;
    case 2:return token==1?HAL_LTDC_LineEventCallback:custom2;
    case 3:return token==1?HAL_LTDC_ReloadEventCallback:custom3;
    case 4:return token==1?HAL_LTDC_ErrorCallback:custom4;
    default:return custom0;
    }
}
static pLTDC_CallbackTypeDef *slot(CLTDCState *s,uint32_t id) {
    switch(id) {
    case 0:return &s->handle.MspInitCallback;
    case 1:return &s->handle.MspDeInitCallback;
    case 2:return &s->handle.LineEventCallback;
    case 3:return &s->handle.ReloadEventCallback;
    case 4:return &s->handle.ErrorCallback;
    default:assert(0);return NULL;
    }
}
void CLTDC_SetCallback(CLTDCState *s,uint32_t id,uint32_t token) { *slot(s,id)=CLTDC_CallbackPointer(id,token); }
uint32_t CLTDC_GetCallback(CLTDCState *s,uint32_t id) { pLTDC_CallbackTypeDef cb=*slot(s,id);return !cb?0:cb==CLTDC_CallbackPointer(id,1)?1:2; }
