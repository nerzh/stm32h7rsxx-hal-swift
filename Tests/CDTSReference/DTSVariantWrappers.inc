/* Test-only storage accessors and entry points. */
#define LOCAL(name) CDTS_JOIN(CDTS_VARIANT,name)
static void UserCallback0_2(DTS_HandleTypeDef *h) { (void)h; CDTS_DispatchCallback(0,2); }
static void UserCallback0_3(DTS_HandleTypeDef *h) { (void)h; CDTS_DispatchCallback(0,3); }
static void UserCallback1_2(DTS_HandleTypeDef *h) { (void)h; CDTS_DispatchCallback(1,2); }
static void UserCallback1_3(DTS_HandleTypeDef *h) { (void)h; CDTS_DispatchCallback(1,3); }
static void UserCallback2_2(DTS_HandleTypeDef *h) { (void)h; CDTS_DispatchCallback(2,2); }
static void UserCallback2_3(DTS_HandleTypeDef *h) { (void)h; CDTS_DispatchCallback(2,3); }
static void UserCallback3_2(DTS_HandleTypeDef *h) { (void)h; CDTS_DispatchCallback(3,2); }
static void UserCallback3_3(DTS_HandleTypeDef *h) { (void)h; CDTS_DispatchCallback(3,3); }
static void UserCallback4_2(DTS_HandleTypeDef *h) { (void)h; CDTS_DispatchCallback(4,2); }
static void UserCallback4_3(DTS_HandleTypeDef *h) { (void)h; CDTS_DispatchCallback(4,3); }
static void UserCallback5_2(DTS_HandleTypeDef *h) { (void)h; CDTS_DispatchCallback(5,2); }
static void UserCallback5_3(DTS_HandleTypeDef *h) { (void)h; CDTS_DispatchCallback(5,3); }
static void UserCallback6_2(DTS_HandleTypeDef *h) { (void)h; CDTS_DispatchCallback(6,2); }
static void UserCallback6_3(DTS_HandleTypeDef *h) { (void)h; CDTS_DispatchCallback(6,3); }
static void UserCallback7_2(DTS_HandleTypeDef *h) { (void)h; CDTS_DispatchCallback(7,2); }
static void UserCallback7_3(DTS_HandleTypeDef *h) { (void)h; CDTS_DispatchCallback(7,3); }
static pDTS_CallbackTypeDef CallbackPointer(uint32_t id,uint32_t implementation) { if(!implementation)return NULL;switch(id) {
case 0:return implementation==1 ? HAL_DTS_EndCallback : implementation==2 ? UserCallback0_2 : UserCallback0_3;
case 1:return implementation==1 ? HAL_DTS_AsyncEndCallback : implementation==2 ? UserCallback1_2 : UserCallback1_3;
case 2:return implementation==1 ? HAL_DTS_LowCallback : implementation==2 ? UserCallback2_2 : UserCallback2_3;
case 3:return implementation==1 ? HAL_DTS_AsyncLowCallback : implementation==2 ? UserCallback3_2 : UserCallback3_3;
case 4:return implementation==1 ? HAL_DTS_HighCallback : implementation==2 ? UserCallback4_2 : UserCallback4_3;
case 5:return implementation==1 ? HAL_DTS_AsyncHighCallback : implementation==2 ? UserCallback5_2 : UserCallback5_3;
case 6:return implementation==1 ? HAL_DTS_MspInit : implementation==2 ? UserCallback6_2 : UserCallback6_3;
case 7:return implementation==1 ? HAL_DTS_MspDeInit : implementation==2 ? UserCallback7_2 : UserCallback7_3;
default:return UserCallback0_2;}}
uint32_t LOCAL(_GetCallbackInternal)(const DTS_HandleTypeDef *h,uint32_t id) {
#if CDTS_CALLBACK_MODE
 pDTS_CallbackTypeDef callback=NULL;switch(id) {
case 0:callback=h->EndCallback;break;
case 1:callback=h->AsyncEndCallback;break;
case 2:callback=h->LowCallback;break;
case 3:callback=h->AsyncLowCallback;break;
case 4:callback=h->HighCallback;break;
case 5:callback=h->AsyncHighCallback;break;
case 6:callback=h->MspInitCallback;break;
case 7:callback=h->MspDeInitCallback;break;
default:assert(0);break;}if(!callback)return 0;for(uint32_t n=1;n<=3;n++)if(callback==CallbackPointer(id,n))return n;return UINT32_MAX;
#else
(void)h;(void)id;return 0;
#endif
}
void LOCAL(_SetCallbackInternal)(DTS_HandleTypeDef *h,uint32_t id,uint32_t implementation) {
#if CDTS_CALLBACK_MODE
switch(id) {
case 0:h->EndCallback=CallbackPointer(id,implementation);break;
case 1:h->AsyncEndCallback=CallbackPointer(id,implementation);break;
case 2:h->LowCallback=CallbackPointer(id,implementation);break;
case 3:h->AsyncLowCallback=CallbackPointer(id,implementation);break;
case 4:h->HighCallback=CallbackPointer(id,implementation);break;
case 5:h->AsyncHighCallback=CallbackPointer(id,implementation);break;
case 6:h->MspInitCallback=CallbackPointer(id,implementation);break;
case 7:h->MspDeInitCallback=CallbackPointer(id,implementation);break;
default:assert(0);break;}
#else
(void)h;(void)id;(void)implementation;
#endif
}
uint32_t LOCAL(_GetWordInternal)(const DTS_HandleTypeDef *h,uint32_t word) {switch(word){
case 0:return (uint32_t)h->Init.QuickMeasure;
case 1:return (uint32_t)h->Init.RefClock;
case 2:return (uint32_t)h->Init.TriggerInput;
case 3:return (uint32_t)h->Init.SamplingTime;
case 4:return (uint32_t)h->Init.Divider;
case 5:return (uint32_t)h->Init.HighThreshold;
case 6:return (uint32_t)h->Init.LowThreshold;
case 7:return (uint32_t)h->Lock;
case 8:return (uint32_t)h->State;
default:assert(0);return 0;}}
void LOCAL(_SetWordInternal)(DTS_HandleTypeDef *h,uint32_t word,uint32_t value) {switch(word){
case 0:h->Init.QuickMeasure=value;break;
case 1:h->Init.RefClock=value;break;
case 2:h->Init.TriggerInput=value;break;
case 3:h->Init.SamplingTime=value;break;
case 4:h->Init.Divider=value;break;
case 5:h->Init.HighThreshold=value;break;
case 6:h->Init.LowThreshold=value;break;
case 7:h->Lock=value;break;
case 8:h->State=value;break;
default:assert(0);break;}}
uint32_t LOCAL(_RunInternal)(DTS_HandleTypeDef *h,CDTSOperation operation,uint32_t argument,uint32_t implementation) {switch(operation) {
case CDTS_Initialize:return (uint32_t)HAL_DTS_Init(h);
case CDTS_Deinitialize:return (uint32_t)HAL_DTS_DeInit(h);
case CDTS_Start:return (uint32_t)HAL_DTS_Start(h);
case CDTS_Stop:return (uint32_t)HAL_DTS_Stop(h);
case CDTS_StartInterrupt:return (uint32_t)HAL_DTS_Start_IT(h);
case CDTS_StopInterrupt:return (uint32_t)HAL_DTS_Stop_IT(h);
case CDTS_GetTemperature:return (uint32_t)HAL_DTS_GetTemperature(h,&CDTS_Active->temperature);
case CDTS_GetState:return (uint32_t)HAL_DTS_GetState(h);
case CDTS_GetFlag:return (uint32_t)__HAL_DTS_GET_FLAG(h,argument);
case CDTS_GetInterruptSource:return (uint32_t)__HAL_DTS_GET_IT_SOURCE(h,argument);
case CDTS_GetReferenceClock:return (uint32_t)__HAL_DTS_GET_REFCLK(h,argument);
case CDTS_GetTrigger:return (uint32_t)__HAL_DTS_GET_TRIGGER(h);
case CDTS_HandleInterrupt:HAL_DTS_IRQHandler(h);return 0;
case CDTS_ResetHandleState:__HAL_DTS_RESET_HANDLE_STATE(h);return 0;
case CDTS_Enable:__HAL_DTS_ENABLE(h);return 0;
case CDTS_Disable:__HAL_DTS_DISABLE(h);return 0;
case CDTS_EnableInterrupts:__HAL_DTS_ENABLE_IT(h,argument);return 0;
case CDTS_DisableInterrupts:__HAL_DTS_DISABLE_IT(h,argument);return 0;
case CDTS_ClearFlag:__HAL_DTS_CLEAR_FLAG(h,argument);return 0;
case CDTS_EnableWakeupInterrupt:__HAL_DTS_EXTI_WAKEUP_ENABLE_IT();return 0;
case CDTS_DisableWakeupInterrupt:__HAL_DTS_EXTI_WAKEUP_DISABLE_IT();return 0;
case CDTS_EnableWakeupEvent:__HAL_DTS_EXTI_WAKEUP_ENABLE_EVENT();return 0;
case CDTS_DisableWakeupEvent:__HAL_DTS_EXTI_WAKEUP_DISABLE_EVENT();return 0;
#if CDTS_CALLBACK_MODE
case CDTS_RegisterCallback:return HAL_DTS_RegisterCallback(h,(HAL_DTS_CallbackIDTypeDef)argument,CallbackPointer(argument,implementation));
case CDTS_UnregisterCallback:return HAL_DTS_UnRegisterCallback(h,(HAL_DTS_CallbackIDTypeDef)argument);
#endif
default:assert(0);return UINT32_MAX;}}
