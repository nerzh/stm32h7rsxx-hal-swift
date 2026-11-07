/* Test-only accessors and entry points. */
#define LOCAL(name) CCORDIC_JOIN(CCORDIC_VARIANT,name)
typedef void (*Callback)(CORDIC_HandleTypeDef *);
static void User0_2(CORDIC_HandleTypeDef *h){CCORDIC_DispatchCallback(h,0,2);}
static void User0_3(CORDIC_HandleTypeDef *h){CCORDIC_DispatchCallback(h,0,3);}
static void User1_2(CORDIC_HandleTypeDef *h){CCORDIC_DispatchCallback(h,1,2);}
static void User1_3(CORDIC_HandleTypeDef *h){CCORDIC_DispatchCallback(h,1,3);}
static void User2_2(CORDIC_HandleTypeDef *h){CCORDIC_DispatchCallback(h,2,2);}
static void User2_3(CORDIC_HandleTypeDef *h){CCORDIC_DispatchCallback(h,2,3);}
static void User3_2(CORDIC_HandleTypeDef *h){CCORDIC_DispatchCallback(h,3,2);}
static void User3_3(CORDIC_HandleTypeDef *h){CCORDIC_DispatchCallback(h,3,3);}
static Callback pointer(uint32_t id,uint32_t implementation){if(!implementation)return NULL;switch(id){
case 0:return implementation==1 ? HAL_CORDIC_ErrorCallback : implementation==2 ? User0_2 : User0_3;
case 1:return implementation==1 ? HAL_CORDIC_CalculateCpltCallback : implementation==2 ? User1_2 : User1_3;
case 2:return implementation==1 ? HAL_CORDIC_MspInit : implementation==2 ? User2_2 : User2_3;
case 3:return implementation==1 ? HAL_CORDIC_MspDeInit : implementation==2 ? User3_2 : User3_3;
default:return User0_2;}}
uint32_t LOCAL(_GetCallbackInternal)(const CORDIC_HandleTypeDef *h,uint32_t id){
#if CCORDIC_CALLBACK_MODE
Callback cb=NULL;switch(id){
case 0:cb=h->ErrorCallback;break;
case 1:cb=h->CalculateCpltCallback;break;
case 2:cb=h->MspInitCallback;break;
case 3:cb=h->MspDeInitCallback;break;
default:assert(0);}if(!cb)return 0;for(uint32_t n=1;n<4;n++)if(cb==pointer(id,n))return n;return UINT32_MAX;
#else
(void)h;(void)id;return 0;
#endif
}
void LOCAL(_SetCallbackInternal)(CORDIC_HandleTypeDef *h,uint32_t id,uint32_t value){
#if CCORDIC_CALLBACK_MODE
switch(id){
case 0:h->ErrorCallback=pointer(id,value);break;
case 1:h->CalculateCpltCallback=pointer(id,value);break;
case 2:h->MspInitCallback=pointer(id,value);break;
case 3:h->MspDeInitCallback=pointer(id,value);break;
default:assert(0);}
#else
(void)h;(void)id;(void)value;
#endif
}
uint32_t LOCAL(_GetWordInternal)(const CORDIC_HandleTypeDef *h,uint32_t word){switch(word){
case 0:return (uint32_t)h->NbCalcToOrder;
case 1:return (uint32_t)h->NbCalcToGet;
case 2:return (uint32_t)h->DMADirection;
case 3:return (uint32_t)h->Lock;
case 4:return (uint32_t)h->State;
case 5:return (uint32_t)h->ErrorCode;
default:assert(0);return 0;}}
void LOCAL(_SetWordInternal)(CORDIC_HandleTypeDef *h,uint32_t word,uint32_t value){switch(word){
case 0:h->NbCalcToOrder=value;break;
case 1:h->NbCalcToGet=value;break;
case 2:h->DMADirection=value;break;
case 3:h->Lock=value;break;
case 4:h->State=value;break;
case 5:h->ErrorCode=value;break;
default:assert(0);}}
static void (*dmaPointer(uint32_t value))(DMA_HandleTypeDef *){switch(value){case 0:return NULL;case 1:return CORDIC_DMAInCplt;case 2:return CORDIC_DMAOutCplt;case 3:return CORDIC_DMAError;default:assert(0);return NULL;}}
uint32_t LOCAL(_GetDMACallbackInternal)(const DMA_HandleTypeDef *h,uint32_t slot){void (*cb)(DMA_HandleTypeDef *)=slot ? h->XferErrorCallback : h->XferCpltCallback;for(uint32_t i=0;i<4;i++)if(cb==dmaPointer(i))return i;return UINT32_MAX;}
void LOCAL(_SetDMACallbackInternal)(DMA_HandleTypeDef *h,uint32_t slot,uint32_t value){if(slot)h->XferErrorCallback=dmaPointer(value);else h->XferCpltCallback=dmaPointer(value);}
void LOCAL(_InvokeDMAInternal)(DMA_HandleTypeDef *h,uint32_t kind){dmaPointer(kind+1)(h);}
uint32_t LOCAL(_RunInternal)(CORDIC_HandleTypeDef *h,CCORDICOperation operation,uint32_t a,uint32_t b,uint32_t c,uint32_t d){
uint32_t handle=0;
#if CCORDIC_CALLBACK_MODE
if(h==&CCORDIC_Active->handles1[1])handle=1;
#else
if(h==&CCORDIC_Active->handles0[1])handle=1;
#endif
const int32_t *input=c ? NULL : CCORDIC_Active->input[handle];
int32_t *output=d ? NULL : CCORDIC_Active->output[handle];
switch(operation){
case CCORDIC_Initialize:return HAL_CORDIC_Init(h);
case CCORDIC_Deinitialize:return HAL_CORDIC_DeInit(h);
case CCORDIC_Configure:return HAL_CORDIC_Configure(h,&CCORDIC_Active->configuration);
case CCORDIC_Calculate:return HAL_CORDIC_Calculate(h,input,output,a,b);
case CCORDIC_CalculateZeroOverhead:return HAL_CORDIC_CalculateZO(h,input,output,a,b);
case CCORDIC_CalculateInterrupt:return HAL_CORDIC_Calculate_IT(h,input,output,a);
case CCORDIC_CalculateDMA:return HAL_CORDIC_Calculate_DMA(h,input,output,a,b);
case CCORDIC_HandleInterrupt:HAL_CORDIC_IRQHandler(h);return 0;
case CCORDIC_GetState:return (uint32_t)HAL_CORDIC_GetState(h);
case CCORDIC_GetError:return HAL_CORDIC_GetError(h);
case CCORDIC_ResetHandleState:__HAL_CORDIC_RESET_HANDLE_STATE(h);return 0;
case CCORDIC_EnableInterrupts:__HAL_CORDIC_ENABLE_IT(h,a);return 0;
case CCORDIC_DisableInterrupts:__HAL_CORDIC_DISABLE_IT(h,a);return 0;
case CCORDIC_GetFlag:return __HAL_CORDIC_GET_FLAG(h,a);
case CCORDIC_GetInterruptSource:return __HAL_CORDIC_GET_IT_SOURCE(h,a);
#if CCORDIC_CALLBACK_MODE
case CCORDIC_RegisterCallback:return HAL_CORDIC_RegisterCallback(h,(HAL_CORDIC_CallbackIDTypeDef)a,pointer(a,b));
case CCORDIC_UnregisterCallback:return HAL_CORDIC_UnRegisterCallback(h,(HAL_CORDIC_CallbackIDTypeDef)a);
#endif
default:assert(0);return UINT32_MAX;
}}
