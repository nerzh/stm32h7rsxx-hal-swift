#include "DMA2DInternal.h"
void HAL_DMA2D_MspInit(DMA2D_HandleTypeDef *h) { (void)h;CDMA2D_Callback(CDMA2D_Active,0,1); }
static void custom0(DMA2D_HandleTypeDef *h) { (void)h;CDMA2D_Callback(CDMA2D_Active,0,2); }
void HAL_DMA2D_MspDeInit(DMA2D_HandleTypeDef *h) { (void)h;CDMA2D_Callback(CDMA2D_Active,1,1); }
static void custom1(DMA2D_HandleTypeDef *h) { (void)h;CDMA2D_Callback(CDMA2D_Active,1,2); }
static void default2(DMA2D_HandleTypeDef *h) { (void)h;CDMA2D_Callback(CDMA2D_Active,2,1); }
static void custom2(DMA2D_HandleTypeDef *h) { (void)h;CDMA2D_Callback(CDMA2D_Active,2,2); }
static void default3(DMA2D_HandleTypeDef *h) { (void)h;CDMA2D_Callback(CDMA2D_Active,3,1); }
static void custom3(DMA2D_HandleTypeDef *h) { (void)h;CDMA2D_Callback(CDMA2D_Active,3,2); }
void HAL_DMA2D_LineEventCallback(DMA2D_HandleTypeDef *h) { (void)h;CDMA2D_Callback(CDMA2D_Active,4,1); }
static void custom4(DMA2D_HandleTypeDef *h) { (void)h;CDMA2D_Callback(CDMA2D_Active,4,2); }
void HAL_DMA2D_CLUTLoadingCpltCallback(DMA2D_HandleTypeDef *h) { (void)h;CDMA2D_Callback(CDMA2D_Active,5,1); }
static void custom5(DMA2D_HandleTypeDef *h) { (void)h;CDMA2D_Callback(CDMA2D_Active,5,2); }
pDMA2D_CallbackTypeDef CDMA2D_CallbackPointer(uint32_t id,uint32_t token) {
    if(!token)return NULL;
    switch(id) {
    case 0:return token==1?HAL_DMA2D_MspInit:custom0;
    case 1:return token==1?HAL_DMA2D_MspDeInit:custom1;
    case 2:return token==1?default2:custom2;
    case 3:return token==1?default3:custom3;
    case 4:return token==1?HAL_DMA2D_LineEventCallback:custom4;
    case 5:return token==1?HAL_DMA2D_CLUTLoadingCpltCallback:custom5;
    default:return custom0;
    }
}
static pDMA2D_CallbackTypeDef *slot(CDMA2DState *s,uint32_t id) {
    switch(id) {
    case 0:return &s->handle.MspInitCallback;
    case 1:return &s->handle.MspDeInitCallback;
    case 2:return &s->handle.XferCpltCallback;
    case 3:return &s->handle.XferErrorCallback;
    case 4:return &s->handle.LineEventCallback;
    case 5:return &s->handle.CLUTLoadingCpltCallback;
    default:assert(0);return NULL;
    }
}
void CDMA2D_SetCallback(CDMA2DState *s,uint32_t id,uint32_t token) { *slot(s,id)=CDMA2D_CallbackPointer(id,token); }
uint32_t CDMA2D_GetCallback(CDMA2DState *s,uint32_t id) { pDMA2D_CallbackTypeDef cb=*slot(s,id);return !cb?0:cb==CDMA2D_CallbackPointer(id,1)?1:2; }
