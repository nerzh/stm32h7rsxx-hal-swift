#include "MCEInternal.h"
void HAL_MCE_ErrorCallback(MCE_HandleTypeDef *h) { CMCE_Callback((CMCEState*)((char*)h - offsetof(CMCEState,h)),0,1); }
void custom0(MCE_HandleTypeDef *h) { CMCE_Callback((CMCEState*)((char*)h - offsetof(CMCEState,h)),0,2); }
void HAL_MCE_MspInit(MCE_HandleTypeDef *h) { CMCE_Callback((CMCEState*)((char*)h - offsetof(CMCEState,h)),1,1); }
void custom1(MCE_HandleTypeDef *h) { CMCE_Callback((CMCEState*)((char*)h - offsetof(CMCEState,h)),1,2); }
void HAL_MCE_MspDeInit(MCE_HandleTypeDef *h) { CMCE_Callback((CMCEState*)((char*)h - offsetof(CMCEState,h)),2,1); }
void custom2(MCE_HandleTypeDef *h) { CMCE_Callback((CMCEState*)((char*)h - offsetof(CMCEState,h)),2,2); }
static pMCE_CallbackTypeDef pointer(uint32_t i,uint32_t t) { if(!t)return NULL;switch(i) {case 0:return t==1?HAL_MCE_ErrorCallback:custom0;case 1:return t==1?HAL_MCE_MspInit:custom1;case 2:return t==1?HAL_MCE_MspDeInit:custom2;default:assert(0);return NULL;} }
void CMCE_SetCallback(CMCEState *s,uint32_t i,uint32_t t) { switch(i) {case 0:s->h.ErrorCallback=pointer(i,t);break;case 1:s->h.MspInitCallback=pointer(i,t);break;case 2:s->h.MspDeInitCallback=pointer(i,t);break;default:assert(0);} }
uint32_t CMCE_GetCallback(CMCEState *s,uint32_t i) { pMCE_CallbackTypeDef p=NULL; switch(i) {case 0:p=s->h.ErrorCallback;break;case 1:p=s->h.MspInitCallback;break;case 2:p=s->h.MspDeInitCallback;break;default:assert(0);} return !p?0:(p==pointer(i,1)?1:2); }
