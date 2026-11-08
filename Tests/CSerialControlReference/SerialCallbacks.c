#include "SerialInternal.h"
void HAL_MDIOS_MspInit(MDIOS_HandleTypeDef *h) { (void)h;CSerial_Callback(CSerial_Active,0,1,0); }
static void MDIOScb0(MDIOS_HandleTypeDef *h) { (void)h;CSerial_Callback(CSerial_Active,0,2,0); }
void HAL_MDIOS_MspDeInit(MDIOS_HandleTypeDef *h) { (void)h;CSerial_Callback(CSerial_Active,1,1,0); }
static void MDIOScb1(MDIOS_HandleTypeDef *h) { (void)h;CSerial_Callback(CSerial_Active,1,2,0); }
void HAL_MDIOS_WriteCpltCallback(MDIOS_HandleTypeDef *h) { (void)h;CSerial_Callback(CSerial_Active,2,1,0); }
static void MDIOScb2(MDIOS_HandleTypeDef *h) { (void)h;CSerial_Callback(CSerial_Active,2,2,0); }
void HAL_MDIOS_ReadCpltCallback(MDIOS_HandleTypeDef *h) { (void)h;CSerial_Callback(CSerial_Active,3,1,0); }
static void MDIOScb3(MDIOS_HandleTypeDef *h) { (void)h;CSerial_Callback(CSerial_Active,3,2,0); }
void HAL_MDIOS_ErrorCallback(MDIOS_HandleTypeDef *h) { (void)h;CSerial_Callback(CSerial_Active,4,1,0); }
static void MDIOScb4(MDIOS_HandleTypeDef *h) { (void)h;CSerial_Callback(CSerial_Active,4,2,0); }
void HAL_MDIOS_WakeUpCallback(MDIOS_HandleTypeDef *h) { (void)h;CSerial_Callback(CSerial_Active,5,1,0); }
static void MDIOScb5(MDIOS_HandleTypeDef *h) { (void)h;CSerial_Callback(CSerial_Active,5,2,0); }
pMDIOS_CallbackTypeDef CSerial_MDIOScallback(uint32_t id,uint32_t token) {
 if(!token)return NULL;
 switch(id) {
 case 0:return token==1?HAL_MDIOS_MspInit:MDIOScb0;
 case 1:return token==1?HAL_MDIOS_MspDeInit:MDIOScb1;
 case 2:return token==1?HAL_MDIOS_WriteCpltCallback:MDIOScb2;
 case 3:return token==1?HAL_MDIOS_ReadCpltCallback:MDIOScb3;
 case 4:return token==1?HAL_MDIOS_ErrorCallback:MDIOScb4;
 case 5:return token==1?HAL_MDIOS_WakeUpCallback:MDIOScb5;
 default:return MDIOScb0;
 }
}
void HAL_CEC_TxCpltCallback(CEC_HandleTypeDef *h) { (void)h;CSerial_Callback(CSerial_Active,0,1,0); }
static void CECcb0(CEC_HandleTypeDef *h) { (void)h;CSerial_Callback(CSerial_Active,0,2,0); }
void HAL_CEC_RxCpltCallback(CEC_HandleTypeDef *h,uint32_t size) { (void)h;CSerial_Callback(CSerial_Active,1,1,size); }
static void CECcb1(CEC_HandleTypeDef *h,uint32_t size) { (void)h;CSerial_Callback(CSerial_Active,1,2,size); }
void HAL_CEC_ErrorCallback(CEC_HandleTypeDef *h) { (void)h;CSerial_Callback(CSerial_Active,2,1,0); }
static void CECcb2(CEC_HandleTypeDef *h) { (void)h;CSerial_Callback(CSerial_Active,2,2,0); }
void HAL_CEC_MspInit(CEC_HandleTypeDef *h) { (void)h;CSerial_Callback(CSerial_Active,3,1,0); }
static void CECcb3(CEC_HandleTypeDef *h) { (void)h;CSerial_Callback(CSerial_Active,3,2,0); }
void HAL_CEC_MspDeInit(CEC_HandleTypeDef *h) { (void)h;CSerial_Callback(CSerial_Active,4,1,0); }
static void CECcb4(CEC_HandleTypeDef *h) { (void)h;CSerial_Callback(CSerial_Active,4,2,0); }
pCEC_CallbackTypeDef CSerial_CECcallback(uint32_t id,uint32_t token) {
 if(!token)return NULL;
 switch(id) {
 case 0:return token==1?HAL_CEC_TxCpltCallback:CECcb0;
 case 2:return token==1?HAL_CEC_ErrorCallback:CECcb2;
 case 3:return token==1?HAL_CEC_MspInit:CECcb3;
 case 4:return token==1?HAL_CEC_MspDeInit:CECcb4;
 default:return CECcb0;
 }
}
pCEC_RxCallbackTypeDef CSerial_CECrxCallback(uint32_t token) { return !token?NULL:token==1?HAL_CEC_RxCpltCallback:CECcb1; }
void CSerial_SetCallback(CSerialState *s,uint32_t id,uint32_t token) {
 if(s->kind==0) {
 switch(id) {
 case 0:s->mh.MspInitCallback=CSerial_MDIOScallback(id,token);break;
 case 1:s->mh.MspDeInitCallback=CSerial_MDIOScallback(id,token);break;
 case 2:s->mh.WriteCpltCallback=CSerial_MDIOScallback(id,token);break;
 case 3:s->mh.ReadCpltCallback=CSerial_MDIOScallback(id,token);break;
 case 4:s->mh.ErrorCallback=CSerial_MDIOScallback(id,token);break;
 case 5:s->mh.WakeUpCallback=CSerial_MDIOScallback(id,token);break;
 default:assert(0);
 }
 } else {
 switch(id) {
 case 0:s->ch.TxCpltCallback=CSerial_CECcallback(id,token);break;
 case 1:s->ch.RxCpltCallback=CSerial_CECrxCallback(token);break;
 case 2:s->ch.ErrorCallback=CSerial_CECcallback(id,token);break;
 case 3:s->ch.MspInitCallback=CSerial_CECcallback(id,token);break;
 case 4:s->ch.MspDeInitCallback=CSerial_CECcallback(id,token);break;
 default:assert(0);
 }
 }
}
uint32_t CSerial_GetCallback(CSerialState *s,uint32_t id) {
 if(s->kind==0) {
 pMDIOS_CallbackTypeDef cb=NULL;switch(id) {
 case 0:cb=s->mh.MspInitCallback;break;
 case 1:cb=s->mh.MspDeInitCallback;break;
 case 2:cb=s->mh.WriteCpltCallback;break;
 case 3:cb=s->mh.ReadCpltCallback;break;
 case 4:cb=s->mh.ErrorCallback;break;
 case 5:cb=s->mh.WakeUpCallback;break;
 default:assert(0);
 }
 return !cb?0:cb==CSerial_MDIOScallback(id,1)?1:2;
 }
 if(id==1)return !s->ch.RxCpltCallback?0:s->ch.RxCpltCallback==CSerial_CECrxCallback(1)?1:2;
 pCEC_CallbackTypeDef cb=NULL;switch(id) {
 case 0:cb=s->ch.TxCpltCallback;break;
 case 2:cb=s->ch.ErrorCallback;break;
 case 3:cb=s->ch.MspInitCallback;break;
 case 4:cb=s->ch.MspDeInitCallback;break;
 default:assert(0);
 }
 return !cb?0:cb==CSerial_CECcallback(id,1)?1:2;
}
