#include "MDFInternal.h"
void HAL_MDF_AcqCpltCallback(MDF_HandleTypeDef *h) { CMDF_Callback((CMDFState*)((char*)h - offsetof(CMDFState,h)),1,1,0,0); }
static void custom1(MDF_HandleTypeDef *h) { CMDF_Callback((CMDFState*)((char*)h - offsetof(CMDFState,h)),1,2,0,0); }
void HAL_MDF_AcqHalfCpltCallback(MDF_HandleTypeDef *h) { CMDF_Callback((CMDFState*)((char*)h - offsetof(CMDFState,h)),2,1,0,0); }
static void custom2(MDF_HandleTypeDef *h) { CMDF_Callback((CMDFState*)((char*)h - offsetof(CMDFState,h)),2,2,0,0); }
void HAL_MDF_SadCallback(MDF_HandleTypeDef *h) { CMDF_Callback((CMDFState*)((char*)h - offsetof(CMDFState,h)),4,1,0,0); }
static void custom4(MDF_HandleTypeDef *h) { CMDF_Callback((CMDFState*)((char*)h - offsetof(CMDFState,h)),4,2,0,0); }
void HAL_MDF_ErrorCallback(MDF_HandleTypeDef *h) { CMDF_Callback((CMDFState*)((char*)h - offsetof(CMDFState,h)),5,1,0,0); }
static void custom5(MDF_HandleTypeDef *h) { CMDF_Callback((CMDFState*)((char*)h - offsetof(CMDFState,h)),5,2,0,0); }
void HAL_MDF_MspInit(MDF_HandleTypeDef *h) { CMDF_Callback((CMDFState*)((char*)h - offsetof(CMDFState,h)),6,1,0,0); }
static void custom6(MDF_HandleTypeDef *h) { CMDF_Callback((CMDFState*)((char*)h - offsetof(CMDFState,h)),6,2,0,0); }
void HAL_MDF_MspDeInit(MDF_HandleTypeDef *h) { CMDF_Callback((CMDFState*)((char*)h - offsetof(CMDFState,h)),7,1,0,0); }
static void custom7(MDF_HandleTypeDef *h) { CMDF_Callback((CMDFState*)((char*)h - offsetof(CMDFState,h)),7,2,0,0); }
void HAL_MDF_SndLvlCallback(MDF_HandleTypeDef *h,uint32_t sound,uint32_t ambient) { CMDF_Callback((CMDFState*)((char*)h - offsetof(CMDFState,h)),3,1,sound,ambient); }
static void customSound(MDF_HandleTypeDef *h,uint32_t sound,uint32_t ambient) { CMDF_Callback((CMDFState*)((char*)h - offsetof(CMDFState,h)),3,2,sound,ambient); }
pMDF_CallbackTypeDef CMDF_CallbackPointer(uint32_t id,uint32_t token) {if(!token)return NULL;switch(id) {case 1:return token==1?HAL_MDF_AcqCpltCallback:custom1;case 2:return token==1?HAL_MDF_AcqHalfCpltCallback:custom2;case 4:return token==1?HAL_MDF_SadCallback:custom4;case 5:return token==1?HAL_MDF_ErrorCallback:custom5;case 6:return token==1?HAL_MDF_MspInit:custom6;case 7:return token==1?HAL_MDF_MspDeInit:custom7;default:return custom1;}}
pMDF_SndLvlCallbackTypeDef CMDF_SoundPointer(uint32_t token) {return token==0?NULL:token==1?HAL_MDF_SndLvlCallback:customSound;}
uint32_t CMDF_GetCallback(CMDFState *s,uint32_t id) {if(id==3)return !s->h.SndLvCallback?0:s->h.SndLvCallback==HAL_MDF_SndLvlCallback?1:2;pMDF_CallbackTypeDef cb=NULL;switch(id){case 1:cb=s->h.AcqCpltCallback;break;case 2:cb=s->h.AcqHalfCpltCallback;break;case 4:cb=s->h.SadCallback;break;case 5:cb=s->h.ErrorCallback;break;case 6:cb=s->h.MspInitCallback;break;case 7:cb=s->h.MspDeInitCallback;break;default:assert(0);}return !cb?0:cb==CMDF_CallbackPointer(id,1)?1:2;}
void CMDF_SetCallback(CMDFState *s,uint32_t id,uint32_t token) {switch(id){case 3:s->h.SndLvCallback=CMDF_SoundPointer(token);break;case 1:s->h.AcqCpltCallback=CMDF_CallbackPointer(id,token);break;case 2:s->h.AcqHalfCpltCallback=CMDF_CallbackPointer(id,token);break;case 4:s->h.SadCallback=CMDF_CallbackPointer(id,token);break;case 5:s->h.ErrorCallback=CMDF_CallbackPointer(id,token);break;case 6:s->h.MspInitCallback=CMDF_CallbackPointer(id,token);break;case 7:s->h.MspDeInitCallback=CMDF_CallbackPointer(id,token);break;default:assert(0);}}
