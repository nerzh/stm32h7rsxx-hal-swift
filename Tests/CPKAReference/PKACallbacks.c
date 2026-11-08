#include "PKAInternal.h"
void HAL_PKA_OperationCpltCallback(PKA_HandleTypeDef *h) { (void)h;CPKA_Callback(CPKA_Active,0,1);}
void cb0custom(PKA_HandleTypeDef *h) { (void)h;CPKA_Callback(CPKA_Active,0,2);}
void HAL_PKA_ErrorCallback(PKA_HandleTypeDef *h) { (void)h;CPKA_Callback(CPKA_Active,1,1);}
void cb1custom(PKA_HandleTypeDef *h) { (void)h;CPKA_Callback(CPKA_Active,1,2);}
void HAL_PKA_MspInit(PKA_HandleTypeDef *h) { (void)h;CPKA_Callback(CPKA_Active,2,1);}
void cb2custom(PKA_HandleTypeDef *h) { (void)h;CPKA_Callback(CPKA_Active,2,2);}
void HAL_PKA_MspDeInit(PKA_HandleTypeDef *h) { (void)h;CPKA_Callback(CPKA_Active,3,1);CPKA_DefaultMSP(CPKA_Active);}
void cb3custom(PKA_HandleTypeDef *h) { (void)h;CPKA_Callback(CPKA_Active,3,2);}
pPKA_CallbackTypeDef CPKA_CallbackPointer(uint32_t id,uint32_t token) { if(!token)return NULL;switch(id) {
case 0:return token==1?HAL_PKA_OperationCpltCallback:cb0custom;
case 1:return token==1?HAL_PKA_ErrorCallback:cb1custom;
case 2:return token==1?HAL_PKA_MspInit:cb2custom;
case 3:return token==1?HAL_PKA_MspDeInit:cb3custom;
default:assert(0);return NULL;}}
uint32_t CPKA_GetCallback(CPKAState *s,uint32_t id) { pPKA_CallbackTypeDef p=NULL;switch(id) {
case 0:p=s->h.OperationCpltCallback;break;
case 1:p=s->h.ErrorCallback;break;
case 2:p=s->h.MspInitCallback;break;
case 3:p=s->h.MspDeInitCallback;break;
default:assert(0);}return !p?0:(p==CPKA_CallbackPointer(id,1)?1:2);}
void CPKA_SetCallback(CPKAState *s,uint32_t id,uint32_t token) {pPKA_CallbackTypeDef p=CPKA_CallbackPointer(id,token);switch(id) {
case 0:s->h.OperationCpltCallback=p;break;
case 1:s->h.ErrorCallback=p;break;
case 2:s->h.MspInitCallback=p;break;
case 3:s->h.MspDeInitCallback=p;break;
default:assert(0);}}
