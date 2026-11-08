#include "PSSIInternal.h"
void HAL_PSSI_TxCpltCallback(PSSI_HandleTypeDef *h) { (void)h;CPSSI_Callback(CPSSI_Active,0,1); }
static void cb0(PSSI_HandleTypeDef *h) { (void)h;CPSSI_Callback(CPSSI_Active,0,2); }
void HAL_PSSI_RxCpltCallback(PSSI_HandleTypeDef *h) { (void)h;CPSSI_Callback(CPSSI_Active,1,1); }
static void cb1(PSSI_HandleTypeDef *h) { (void)h;CPSSI_Callback(CPSSI_Active,1,2); }
void HAL_PSSI_ErrorCallback(PSSI_HandleTypeDef *h) { (void)h;CPSSI_Callback(CPSSI_Active,3,1); }
static void cb3(PSSI_HandleTypeDef *h) { (void)h;CPSSI_Callback(CPSSI_Active,3,2); }
void HAL_PSSI_AbortCpltCallback(PSSI_HandleTypeDef *h) { (void)h;CPSSI_Callback(CPSSI_Active,4,1); }
static void cb4(PSSI_HandleTypeDef *h) { (void)h;CPSSI_Callback(CPSSI_Active,4,2); }
void HAL_PSSI_MspInit(PSSI_HandleTypeDef *h) { (void)h;CPSSI_Callback(CPSSI_Active,5,1); }
static void cb5(PSSI_HandleTypeDef *h) { (void)h;CPSSI_Callback(CPSSI_Active,5,2); }
void HAL_PSSI_MspDeInit(PSSI_HandleTypeDef *h) { (void)h;CPSSI_Callback(CPSSI_Active,6,1); }
static void cb6(PSSI_HandleTypeDef *h) { (void)h;CPSSI_Callback(CPSSI_Active,6,2); }
pPSSI_CallbackTypeDef CPSSI_CallbackPointer(uint32_t id,uint32_t token) { if(!token)return NULL;switch(id) {
case 0:return token==1?HAL_PSSI_TxCpltCallback:cb0;
case 1:return token==1?HAL_PSSI_RxCpltCallback:cb1;
case 3:return token==1?HAL_PSSI_ErrorCallback:cb3;
case 4:return token==1?HAL_PSSI_AbortCpltCallback:cb4;
case 5:return token==1?HAL_PSSI_MspInit:cb5;
case 6:return token==1?HAL_PSSI_MspDeInit:cb6;
default:return cb0;}}
static pPSSI_CallbackTypeDef *slot(CPSSIState *s,uint32_t id) { switch(id) {
case 0:return &s->h.TxCpltCallback;case 1:return &s->h.RxCpltCallback;case 3:return &s->h.ErrorCallback;case 4:return &s->h.AbortCpltCallback;case 5:return &s->h.MspInitCallback;case 6:return &s->h.MspDeInitCallback;default:return NULL;
}}
void CPSSI_SetCallback(CPSSIState *s,uint32_t id,uint32_t token) { pPSSI_CallbackTypeDef *p=slot(s,id);if(p)*p=CPSSI_CallbackPointer(id,token); }
uint32_t CPSSI_GetCallback(CPSSIState *s,uint32_t id) { pPSSI_CallbackTypeDef *p=slot(s,id);return !p||!*p?0:*p==CPSSI_CallbackPointer(id,1)?1:2; }
