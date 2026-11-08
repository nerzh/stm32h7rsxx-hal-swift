#include "JPEGInternal.h"
void HAL_JPEG_EncodeCpltCallback(JPEG_HandleTypeDef *h) {CJPEG_Callback((CJPEGState*)((char*)h - offsetof(CJPEGState,h)),1,1,0,0);}
static void custom1(JPEG_HandleTypeDef *h) {CJPEG_Callback((CJPEGState*)((char*)h - offsetof(CJPEGState,h)),1,2,0,0);}
void HAL_JPEG_DecodeCpltCallback(JPEG_HandleTypeDef *h) {CJPEG_Callback((CJPEGState*)((char*)h - offsetof(CJPEGState,h)),2,1,0,0);}
static void custom2(JPEG_HandleTypeDef *h) {CJPEG_Callback((CJPEGState*)((char*)h - offsetof(CJPEGState,h)),2,2,0,0);}
void HAL_JPEG_ErrorCallback(JPEG_HandleTypeDef *h) {CJPEG_Callback((CJPEGState*)((char*)h - offsetof(CJPEGState,h)),3,1,0,0);}
static void custom3(JPEG_HandleTypeDef *h) {CJPEG_Callback((CJPEGState*)((char*)h - offsetof(CJPEGState,h)),3,2,0,0);}
void HAL_JPEG_MspInit(JPEG_HandleTypeDef *h) {CJPEG_Callback((CJPEGState*)((char*)h - offsetof(CJPEGState,h)),4,1,0,0);}
static void custom4(JPEG_HandleTypeDef *h) {CJPEG_Callback((CJPEGState*)((char*)h - offsetof(CJPEGState,h)),4,2,0,0);}
void HAL_JPEG_MspDeInit(JPEG_HandleTypeDef *h) {CJPEG_Callback((CJPEGState*)((char*)h - offsetof(CJPEGState,h)),5,1,0,0);}
static void custom5(JPEG_HandleTypeDef *h) {CJPEG_Callback((CJPEGState*)((char*)h - offsetof(CJPEGState,h)),5,2,0,0);}
void HAL_JPEG_InfoReadyCallback(JPEG_HandleTypeDef *h,JPEG_ConfTypeDef *info) {CJPEG_Callback((CJPEGState*)((char*)h - offsetof(CJPEGState,h)),6,1,info==&h->Conf?1:0,0);}
void HAL_JPEG_GetDataCallback(JPEG_HandleTypeDef *h,uint32_t count) {CJPEG_Callback((CJPEGState*)((char*)h - offsetof(CJPEGState,h)),7,1,count,0);}
void HAL_JPEG_DataReadyCallback(JPEG_HandleTypeDef *h,uint8_t *data,uint32_t count) {CJPEGState *s=(CJPEGState*)((char*)h - offsetof(CJPEGState,h));CJPEG_Callback(s,8,1,data?(uint32_t)(data-s->data)+1:0,count);}
static void customInfo(JPEG_HandleTypeDef *h,JPEG_ConfTypeDef *info) {CJPEG_Callback((CJPEGState*)((char*)h - offsetof(CJPEGState,h)),6,2,info==&h->Conf?1:0,0);}
static void customGet(JPEG_HandleTypeDef *h,uint32_t count) {CJPEG_Callback((CJPEGState*)((char*)h - offsetof(CJPEGState,h)),7,2,count,0);}
static void customData(JPEG_HandleTypeDef *h,uint8_t *data,uint32_t count) {CJPEGState *s=(CJPEGState*)((char*)h - offsetof(CJPEGState,h));CJPEG_Callback(s,8,2,data?(uint32_t)(data-s->data)+1:0,count);}
pJPEG_CallbackTypeDef CJPEG_CallbackPointer(uint32_t id,uint32_t token) {if(!token)return NULL;switch(id){case 1:return token==1?HAL_JPEG_EncodeCpltCallback:custom1;case 2:return token==1?HAL_JPEG_DecodeCpltCallback:custom2;case 3:return token==1?HAL_JPEG_ErrorCallback:custom3;case 4:return token==1?HAL_JPEG_MspInit:custom4;case 5:return token==1?HAL_JPEG_MspDeInit:custom5;default:return custom1;}}
pJPEG_InfoReadyCallbackTypeDef CJPEG_InfoPointer(uint32_t token) {return token==0?NULL:token==1?HAL_JPEG_InfoReadyCallback:customInfo;}
pJPEG_GetDataCallbackTypeDef CJPEG_GetPointer(uint32_t token) {return token==0?NULL:token==1?HAL_JPEG_GetDataCallback:customGet;}
pJPEG_DataReadyCallbackTypeDef CJPEG_DataPointer(uint32_t token) {return token==0?NULL:token==1?HAL_JPEG_DataReadyCallback:customData;}
uint32_t CJPEG_GetCallback(CJPEGState *s,uint32_t id) {switch(id){case 1:return !s->h.EncodeCpltCallback?0:s->h.EncodeCpltCallback==HAL_JPEG_EncodeCpltCallback?1:2;case 2:return !s->h.DecodeCpltCallback?0:s->h.DecodeCpltCallback==HAL_JPEG_DecodeCpltCallback?1:2;case 3:return !s->h.ErrorCallback?0:s->h.ErrorCallback==HAL_JPEG_ErrorCallback?1:2;case 4:return !s->h.MspInitCallback?0:s->h.MspInitCallback==HAL_JPEG_MspInit?1:2;case 5:return !s->h.MspDeInitCallback?0:s->h.MspDeInitCallback==HAL_JPEG_MspDeInit?1:2;case 6:return !s->h.InfoReadyCallback?0:s->h.InfoReadyCallback==HAL_JPEG_InfoReadyCallback?1:2;case 7:return !s->h.GetDataCallback?0:s->h.GetDataCallback==HAL_JPEG_GetDataCallback?1:2;case 8:return !s->h.DataReadyCallback?0:s->h.DataReadyCallback==HAL_JPEG_DataReadyCallback?1:2;default:assert(0);return 0;}}
void CJPEG_SetCallback(CJPEGState *s,uint32_t id,uint32_t token) {switch(id){case 1:s->h.EncodeCpltCallback=CJPEG_CallbackPointer(id,token);break;case 2:s->h.DecodeCpltCallback=CJPEG_CallbackPointer(id,token);break;case 3:s->h.ErrorCallback=CJPEG_CallbackPointer(id,token);break;case 4:s->h.MspInitCallback=CJPEG_CallbackPointer(id,token);break;case 5:s->h.MspDeInitCallback=CJPEG_CallbackPointer(id,token);break;case 6:s->h.InfoReadyCallback=CJPEG_InfoPointer(token);break;case 7:s->h.GetDataCallback=CJPEG_GetPointer(token);break;case 8:s->h.DataReadyCallback=CJPEG_DataPointer(token);break;default:assert(0);}}
