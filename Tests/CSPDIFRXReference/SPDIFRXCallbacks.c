#include "SPDIFRXInternal.h"
void HAL_SPDIFRX_RxHalfCpltCallback(SPDIFRX_HandleTypeDef *h) { CSPDIFRX_Callback((CSPDIFRXState*)((char*)h - offsetof(CSPDIFRXState,h)),0,1); }
static void custom0(SPDIFRX_HandleTypeDef *h) { CSPDIFRX_Callback((CSPDIFRXState*)((char*)h - offsetof(CSPDIFRXState,h)),0,2); }
void HAL_SPDIFRX_RxCpltCallback(SPDIFRX_HandleTypeDef *h) { CSPDIFRX_Callback((CSPDIFRXState*)((char*)h - offsetof(CSPDIFRXState,h)),1,1); }
static void custom1(SPDIFRX_HandleTypeDef *h) { CSPDIFRX_Callback((CSPDIFRXState*)((char*)h - offsetof(CSPDIFRXState,h)),1,2); }
void HAL_SPDIFRX_CxHalfCpltCallback(SPDIFRX_HandleTypeDef *h) { CSPDIFRX_Callback((CSPDIFRXState*)((char*)h - offsetof(CSPDIFRXState,h)),2,1); }
static void custom2(SPDIFRX_HandleTypeDef *h) { CSPDIFRX_Callback((CSPDIFRXState*)((char*)h - offsetof(CSPDIFRXState,h)),2,2); }
void HAL_SPDIFRX_CxCpltCallback(SPDIFRX_HandleTypeDef *h) { CSPDIFRX_Callback((CSPDIFRXState*)((char*)h - offsetof(CSPDIFRXState,h)),3,1); }
static void custom3(SPDIFRX_HandleTypeDef *h) { CSPDIFRX_Callback((CSPDIFRXState*)((char*)h - offsetof(CSPDIFRXState,h)),3,2); }
void HAL_SPDIFRX_ErrorCallback(SPDIFRX_HandleTypeDef *h) { CSPDIFRX_Callback((CSPDIFRXState*)((char*)h - offsetof(CSPDIFRXState,h)),4,1); }
static void custom4(SPDIFRX_HandleTypeDef *h) { CSPDIFRX_Callback((CSPDIFRXState*)((char*)h - offsetof(CSPDIFRXState,h)),4,2); }
void HAL_SPDIFRX_MspInit(SPDIFRX_HandleTypeDef *h) { CSPDIFRX_Callback((CSPDIFRXState*)((char*)h - offsetof(CSPDIFRXState,h)),5,1); }
static void custom5(SPDIFRX_HandleTypeDef *h) { CSPDIFRX_Callback((CSPDIFRXState*)((char*)h - offsetof(CSPDIFRXState,h)),5,2); }
void HAL_SPDIFRX_MspDeInit(SPDIFRX_HandleTypeDef *h) { CSPDIFRX_Callback((CSPDIFRXState*)((char*)h - offsetof(CSPDIFRXState,h)),6,1); }
static void custom6(SPDIFRX_HandleTypeDef *h) { CSPDIFRX_Callback((CSPDIFRXState*)((char*)h - offsetof(CSPDIFRXState,h)),6,2); }
pSPDIFRX_CallbackTypeDef CSPDIFRX_CallbackPointer(uint32_t i,uint32_t t) {if(!t)return NULL;switch(i) {case 0:return t==1?HAL_SPDIFRX_RxHalfCpltCallback:custom0;case 1:return t==1?HAL_SPDIFRX_RxCpltCallback:custom1;case 2:return t==1?HAL_SPDIFRX_CxHalfCpltCallback:custom2;case 3:return t==1?HAL_SPDIFRX_CxCpltCallback:custom3;case 4:return t==1?HAL_SPDIFRX_ErrorCallback:custom4;case 5:return t==1?HAL_SPDIFRX_MspInit:custom5;case 6:return t==1?HAL_SPDIFRX_MspDeInit:custom6;default:return custom0;} }
void CSPDIFRX_SetCallback(CSPDIFRXState *s,uint32_t i,uint32_t t) { switch(i) {case 0:s->h.RxHalfCpltCallback=CSPDIFRX_CallbackPointer(i,t);break;case 1:s->h.RxCpltCallback=CSPDIFRX_CallbackPointer(i,t);break;case 2:s->h.CxHalfCpltCallback=CSPDIFRX_CallbackPointer(i,t);break;case 3:s->h.CxCpltCallback=CSPDIFRX_CallbackPointer(i,t);break;case 4:s->h.ErrorCallback=CSPDIFRX_CallbackPointer(i,t);break;case 5:s->h.MspInitCallback=CSPDIFRX_CallbackPointer(i,t);break;case 6:s->h.MspDeInitCallback=CSPDIFRX_CallbackPointer(i,t);break;default:assert(0);} }
uint32_t CSPDIFRX_GetCallback(CSPDIFRXState *s,uint32_t i) {pSPDIFRX_CallbackTypeDef p=NULL;switch(i) {case 0:p=s->h.RxHalfCpltCallback;break;case 1:p=s->h.RxCpltCallback;break;case 2:p=s->h.CxHalfCpltCallback;break;case 3:p=s->h.CxCpltCallback;break;case 4:p=s->h.ErrorCallback;break;case 5:p=s->h.MspInitCallback;break;case 6:p=s->h.MspDeInitCallback;break;default:assert(0);}return !p?0:p==CSPDIFRX_CallbackPointer(i,1)?1:2;}
