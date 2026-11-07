/* Test-only namespace entry points; no HASH algorithm is duplicated here. */
#define LOCAL(name) CHASH_JOIN(CHASH_VARIANT,name)
typedef void (*Callback)(HASH_HandleTypeDef *);
static void User0_2(HASH_HandleTypeDef *h){CHASH_DispatchCallback(h,0,2);}
static void User0_3(HASH_HandleTypeDef *h){CHASH_DispatchCallback(h,0,3);}
static void User1_2(HASH_HandleTypeDef *h){CHASH_DispatchCallback(h,1,2);}
static void User1_3(HASH_HandleTypeDef *h){CHASH_DispatchCallback(h,1,3);}
static void User2_2(HASH_HandleTypeDef *h){CHASH_DispatchCallback(h,2,2);}
static void User2_3(HASH_HandleTypeDef *h){CHASH_DispatchCallback(h,2,3);}
static void User3_2(HASH_HandleTypeDef *h){CHASH_DispatchCallback(h,3,2);}
static void User3_3(HASH_HandleTypeDef *h){CHASH_DispatchCallback(h,3,3);}
static void User4_2(HASH_HandleTypeDef *h){CHASH_DispatchCallback(h,4,2);}
static void User4_3(HASH_HandleTypeDef *h){CHASH_DispatchCallback(h,4,3);}
static Callback pointer(uint32_t id,uint32_t implementation){if(!implementation)return NULL;switch(id){
case 0:return implementation==1 ? HAL_HASH_MspInit : implementation==2 ? User0_2 : User0_3;
case 1:return implementation==1 ? HAL_HASH_MspDeInit : implementation==2 ? User1_2 : User1_3;
case 2:return implementation==1 ? HAL_HASH_InCpltCallback : implementation==2 ? User2_2 : User2_3;
case 3:return implementation==1 ? HAL_HASH_DgstCpltCallback : implementation==2 ? User3_2 : User3_3;
case 4:return implementation==1 ? HAL_HASH_ErrorCallback : implementation==2 ? User4_2 : User4_3;
default:return User0_2;}}
uint32_t LOCAL(_GetCallbackInternal)(const HASH_HandleTypeDef *h,uint32_t id){
#if CHASH_CALLBACK_MODE
Callback cb=NULL;switch(id){
case 0:cb=h->MspInitCallback;break;
case 1:cb=h->MspDeInitCallback;break;
case 2:cb=h->InCpltCallback;break;
case 3:cb=h->DgstCpltCallback;break;
case 4:cb=h->ErrorCallback;break;
default:assert(0);}if(!cb)return 0;for(uint32_t n=1;n<4;n++)if(cb==pointer(id,n))return n;return UINT32_MAX;
#else
(void)h;(void)id;return 0;
#endif
}
void LOCAL(_SetCallbackInternal)(HASH_HandleTypeDef *h,uint32_t id,uint32_t value){
#if CHASH_CALLBACK_MODE
switch(id){
case 0:h->MspInitCallback=pointer(id,value);break;
case 1:h->MspDeInitCallback=pointer(id,value);break;
case 2:h->InCpltCallback=pointer(id,value);break;
case 3:h->DgstCpltCallback=pointer(id,value);break;
case 4:h->ErrorCallback=pointer(id,value);break;
default:assert(0);}
#else
(void)h;(void)id;(void)value;
#endif
}
uint32_t LOCAL(_GetWordInternal)(const CHASHState *s,const HASH_HandleTypeDef *h,uint32_t word){switch(word){
case 0:return (uint32_t)h->Init.DataType;
case 1:return (uint32_t)h->Init.KeySize;
case 2:return CHASH_NormalizeAddress(s,(uintptr_t)h->Init.pKey);
case 3:return (uint32_t)h->Init.Algorithm;
case 4:return CHASH_NormalizeAddress(s,(uintptr_t)h->pHashInBuffPtr);
case 5:return CHASH_NormalizeAddress(s,(uintptr_t)h->pHashOutBuffPtr);
case 6:return (uint32_t)h->HashInCount;
case 7:return (uint32_t)h->Size;
case 8:return CHASH_NormalizeAddress(s,(uintptr_t)h->pHashKeyBuffPtr);
case 9:return (uint32_t)h->Phase;
case 10:return (uint32_t)h->Lock;
case 11:return (uint32_t)h->ErrorCode;
case 12:return (uint32_t)h->State;
case 13:return (uint32_t)h->Accumulation;
#if CHASH_SUSPEND_MODE
case 14:return (uint32_t)h->SuspendRequest;
case 15:return (uint32_t)h->Init_saved.DataType;
case 16:return (uint32_t)h->Init_saved.KeySize;
case 17:return CHASH_NormalizeAddress(s,(uintptr_t)h->Init_saved.pKey);
case 18:return (uint32_t)h->Init_saved.Algorithm;
case 19:return CHASH_NormalizeAddress(s,(uintptr_t)h->pHashInBuffPtr_saved);
case 20:return CHASH_NormalizeAddress(s,(uintptr_t)h->pHashOutBuffPtr_saved);
case 21:return (uint32_t)h->HashInCount_saved;
case 22:return (uint32_t)h->Size_saved;
case 23:return CHASH_NormalizeAddress(s,(uintptr_t)h->pHashKeyBuffPtr_saved);
case 24:return (uint32_t)h->Phase_saved;
#endif
default:assert(word<25);return 0;}}
void LOCAL(_SetWordInternal)(CHASHState *s,HASH_HandleTypeDef *h,uint32_t word,uint32_t value){switch(word){
case 0:h->Init.DataType=value;break;
case 1:h->Init.KeySize=value;break;
case 2:h->Init.pKey=CHASH_Resolve(s,value);break;
case 3:h->Init.Algorithm=value;break;
case 4:h->pHashInBuffPtr=CHASH_Resolve(s,value);break;
case 5:h->pHashOutBuffPtr=CHASH_Resolve(s,value);break;
case 6:h->HashInCount=value;break;
case 7:h->Size=value;break;
case 8:h->pHashKeyBuffPtr=CHASH_Resolve(s,value);break;
case 9:h->Phase=value;break;
case 10:h->Lock=value;break;
case 11:h->ErrorCode=value;break;
case 12:h->State=value;break;
case 13:h->Accumulation=value;break;
#if CHASH_SUSPEND_MODE
case 14:h->SuspendRequest=value;break;
case 15:h->Init_saved.DataType=value;break;
case 16:h->Init_saved.KeySize=value;break;
case 17:h->Init_saved.pKey=CHASH_Resolve(s,value);break;
case 18:h->Init_saved.Algorithm=value;break;
case 19:h->pHashInBuffPtr_saved=CHASH_Resolve(s,value);break;
case 20:h->pHashOutBuffPtr_saved=CHASH_Resolve(s,value);break;
case 21:h->HashInCount_saved=value;break;
case 22:h->Size_saved=value;break;
case 23:h->pHashKeyBuffPtr_saved=CHASH_Resolve(s,value);break;
case 24:h->Phase_saved=value;break;
#endif
default:assert(word<25);break;}}
static void (*dmaPointer(uint32_t value))(DMA_HandleTypeDef *){switch(value){case 0:return NULL;case 1:return HASH_DMAXferCplt;case 2:return HASH_DMAError;default:assert(0);return NULL;}}
uint32_t LOCAL(_GetDMACallbackInternal)(const DMA_HandleTypeDef *h,uint32_t slot){void (*cb)(DMA_HandleTypeDef *)=slot ? h->XferErrorCallback : h->XferCpltCallback;for(uint32_t i=0;i<3;i++)if(cb==dmaPointer(i))return i;return UINT32_MAX;}
void LOCAL(_SetDMACallbackInternal)(DMA_HandleTypeDef *h,uint32_t slot,uint32_t value){if(slot)h->XferErrorCallback=dmaPointer(value);else h->XferCpltCallback=dmaPointer(value);}
void LOCAL(_InvokeDMAInternal)(DMA_HandleTypeDef *h,uint32_t kind){dmaPointer(kind+1)(h);}
uint32_t LOCAL(_RunInternal)(HASH_HandleTypeDef *h,CHASHOperation op,uint32_t a,uint32_t b,uint32_t c,uint32_t d){
CHASHState *s=CHASH_Active;const uint8_t *input=CHASH_Resolve(s,a);uint8_t *output=CHASH_Resolve(s,c);
HASH_ConfigTypeDef config={s->configuration[0],s->configuration[1],CHASH_Resolve(s,s->configuration[2]),s->configuration[3]};
uint32_t result;switch(op){
case CHASH_Initialize:return HAL_HASH_Init(h);
case CHASH_Deinitialize:return HAL_HASH_DeInit(h);
case CHASH_SetConfiguration:return HAL_HASH_SetConfig(h,a ? NULL : &config);
case CHASH_GetConfiguration:result=HAL_HASH_GetConfig(h,a ? NULL : &config);s->configuration[0]=config.DataType;s->configuration[1]=config.KeySize;s->configuration[2]=CHASH_NormalizeAddress(s,(uintptr_t)config.pKey);s->configuration[3]=config.Algorithm;return result;
case CHASH_Start:return HAL_HASH_Start(h,input,b,output,d);
case CHASH_StartInterrupt:return HAL_HASH_Start_IT(h,input,b,output);
case CHASH_StartDMA:return HAL_HASH_Start_DMA(h,input,b,output);
case CHASH_Accumulate:return HAL_HASH_Accumulate(h,input,b,d);
case CHASH_AccumulateLast:return HAL_HASH_AccumulateLast(h,input,b,output,d);
case CHASH_AccumulateInterrupt:return HAL_HASH_Accumulate_IT(h,input,b);
case CHASH_AccumulateLastInterrupt:return HAL_HASH_AccumulateLast_IT(h,input,b,output);
case CHASH_HMACStart:return HAL_HASH_HMAC_Start(h,input,b,output,d);
case CHASH_HMACAccumulate:return HAL_HASH_HMAC_Accumulate(h,input,b,d);
case CHASH_HMACAccumulateLast:return HAL_HASH_HMAC_AccumulateLast(h,input,b,output,d);
case CHASH_HMACStartInterrupt:return HAL_HASH_HMAC_Start_IT(h,input,b,output);
case CHASH_HMACAccumulateInterrupt:return HAL_HASH_HMAC_Accumulate_IT(h,input,b);
case CHASH_HMACAccumulateLastInterrupt:return HAL_HASH_HMAC_AccumulateLast_IT(h,input,b,output);
case CHASH_HMACStartDMA:return HAL_HASH_HMAC_Start_DMA(h,input,b,output);
case CHASH_HandleInterrupt:HAL_HASH_IRQHandler(h);return 0;
case CHASH_GetState:return HAL_HASH_GetState(h);
case CHASH_GetError:return HAL_HASH_GetError(h);
case CHASH_ResetHandleState:__HAL_HASH_RESET_HANDLE_STATE(h);return 0;
case CHASH_EnableInterrupts:__HAL_HASH_ENABLE_IT(h,a);return 0;
case CHASH_DisableInterrupts:__HAL_HASH_DISABLE_IT(h,a);return 0;
case CHASH_GetFlag:return __HAL_HASH_GET_FLAG(h,a);
case CHASH_ClearFlag:__HAL_HASH_CLEAR_FLAG(h,a);return 0;
case CHASH_GetInterruptSource:return __HAL_HASH_GET_IT_SOURCE(h,a);
case CHASH_SetMDMAT:__HAL_HASH_SET_MDMAT();return 0;
case CHASH_ResetMDMAT:__HAL_HASH_RESET_MDMAT();return 0;
case CHASH_DigestLength:return HASH_DIGEST_LENGTH(h);
case CHASH_WriteData:HASH_WriteData(h,input,b);return 0;
case CHASH_WriteDataInterrupt:return HASH_WriteData_IT(h);
case CHASH_GetDigest:HASH_GetDigest(h,(uint8_t *)input,(uint8_t)b);return 0;
case CHASH_Wait:return HASH_WaitOnFlagUntilTimeout(h,a,(FlagStatus)b,c);
#if CHASH_CALLBACK_MODE
case CHASH_RegisterCallback:return HAL_HASH_RegisterCallback(h,(HAL_HASH_CallbackIDTypeDef)a,pointer(a,b));
case CHASH_UnregisterCallback:return HAL_HASH_UnRegisterCallback(h,(HAL_HASH_CallbackIDTypeDef)a);
#endif
#if CHASH_SUSPEND_MODE
case CHASH_Suspend:HAL_HASH_Suspend(h,(uint8_t *)input);return 0;
case CHASH_Resume:HAL_HASH_Resume(h,(uint8_t *)input);return 0;
case CHASH_ProcessSuspend:return HAL_HASH_ProcessSuspend(h);
#endif
default:assert(0);return UINT32_MAX;}}
