static void (*CRYP_DMAFunction(uint32_t value))(DMA_HandleTypeDef *) {switch(value){case 0:return NULL;case 1:return CRYP_DMAInCplt;case 2:return CRYP_DMAOutCplt;case 3:return CRYP_DMAError;default:assert(0);return NULL;}}
uint32_t F_JOIN(F_VARIANT,_GetDMACallback)(CCRYPState *s,uint32_t ch,uint32_t id){void (*f)(DMA_HandleTypeDef *)=NULL;switch(id){case 0:f=s->dma[ch].XferCpltCallback;break;case 1:f=s->dma[ch].XferHalfCpltCallback;break;case 2:f=s->dma[ch].XferErrorCallback;break;case 3:f=s->dma[ch].XferAbortCallback;break;case 4:f=s->dma[ch].XferSuspendCallback;break;default:assert(0);}for(uint32_t k=0;k<=3;k++)if(f==CRYP_DMAFunction(k))return k;assert(0);return 0;}
void F_JOIN(F_VARIANT,_SetDMACallback)(CCRYPState *s,uint32_t ch,uint32_t id,uint32_t v){switch(id){case 0:s->dma[ch].XferCpltCallback=CRYP_DMAFunction(v);break;case 1:s->dma[ch].XferHalfCpltCallback=CRYP_DMAFunction(v);break;case 2:s->dma[ch].XferErrorCallback=CRYP_DMAFunction(v);break;case 3:s->dma[ch].XferAbortCallback=CRYP_DMAFunction(v);break;case 4:s->dma[ch].XferSuspendCallback=CRYP_DMAFunction(v);break;default:assert(0);}}
uint32_t F_JOIN(F_VARIANT,_Run)(CCRYPState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {
switch(op) {

case 0:return HAL_CRYP_Init(c?NULL:&s->h);

case 1:return HAL_CRYP_DeInit(c?NULL:&s->h);

case 2:return HAL_CRYP_SetConfig(&s->h,c?NULL:&s->configuration);

case 3:return HAL_CRYP_GetConfig(&s->h,c?NULL:&s->configuration);
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
case 4:return HAL_CRYP_RegisterCallback(&s->h,(HAL_CRYP_CallbackIDTypeDef)a,CCRYP_CallbackPointer(a>=1&&a<=5?a:1,b));
#endif
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
case 5:return HAL_CRYP_UnRegisterCallback(&s->h,(HAL_CRYP_CallbackIDTypeDef)a);
#endif
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
case 6:HAL_CRYP_ProcessSuspend(&s->h);return 0;
#endif
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
case 7:return HAL_CRYP_DMAProcessSuspend(&s->h);
#endif
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
case 8:return HAL_CRYP_Suspend(&s->h);
#endif
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
case 9:return HAL_CRYP_Resume(&s->h);
#endif

case 10:return HAL_CRYP_Encrypt(&s->h,s->buffers[0],(uint16_t)a,s->buffers[1],b);

case 11:return HAL_CRYP_Decrypt(&s->h,s->buffers[0],(uint16_t)a,s->buffers[1],b);

case 12:return HAL_CRYP_Encrypt_IT(&s->h,s->buffers[0],(uint16_t)a,s->buffers[1]);

case 13:return HAL_CRYP_Decrypt_IT(&s->h,s->buffers[0],(uint16_t)a,s->buffers[1]);

case 14:return HAL_CRYP_Encrypt_DMA(&s->h,s->buffers[0],(uint16_t)a,s->buffers[1]);

case 15:return HAL_CRYP_Decrypt_DMA(&s->h,s->buffers[0],(uint16_t)a,s->buffers[1]);

case 16:HAL_CRYP_IRQHandler(&s->h);return 0;

case 17:return HAL_CRYP_GetError(&s->h);

case 18:return HAL_CRYP_GetState(&s->h);

case 19:return CRYP_AES_Encrypt(&s->h,a);

case 20:return CRYP_AES_Encrypt_IT(&s->h);

case 21:return CRYP_AES_Decrypt(&s->h,a);

case 22:return CRYP_AES_Decrypt_IT(&s->h);

case 23:return CRYP_AES_Decrypt_DMA(&s->h);

case 24:CRYP_DMAInCplt(&s->dma[a]);return 0;

case 25:CRYP_DMAOutCplt(&s->dma[a]);return 0;

case 26:CRYP_DMAError(&s->dma[a]);return 0;

case 27:CRYP_SetDMAConfig(&s->h,a,(uint16_t)b,c);return 0;

case 28:CRYP_AES_ProcessData(&s->h,a);return 0;

case 29:CRYP_AES_IT(&s->h);return 0;

case 30:CRYP_SetKey(&s->h,a);return 0;

case 31:return CRYP_AESGCM_Process(&s->h,a);

case 32:return CRYP_AESGCM_Process_IT(&s->h);

case 33:return CRYP_AESGCM_Process_DMA(&s->h);

case 34:return CRYP_AESCCM_Process(&s->h,a);

case 35:return CRYP_AESCCM_Process_IT(&s->h);

case 36:return CRYP_AESCCM_Process_DMA(&s->h);

case 37:CRYP_GCMCCM_SetPayloadPhase_IT(&s->h);return 0;

case 38:return CRYP_GCMCCM_SetHeaderPhase(&s->h,a);

case 39:return CRYP_GCMCCM_SetHeaderPhase_DMA(&s->h);

case 40:CRYP_GCMCCM_SetHeaderPhase_IT(&s->h);return 0;
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
case 41:return CRYP_WaitOnIFEMFlag(&s->h,a);
#endif

case 42:return CRYP_WaitOnBUSYFlag(&s->h,a);
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
case 43:return CRYP_WaitOnOFNEFlag(&s->h,a);
#endif
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
case 44:return CRYP_WaitOnCCFlag(&s->h,a);
#endif
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
case 45:CRYP_Read_IVRegisters(&s->h,s->buffers[6]);return 0;
#endif
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
case 46:CRYP_Write_IVRegisters(&s->h,s->buffers[6]);return 0;
#endif
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
case 47:CRYP_Read_ContextSwapRegisters(&s->h,s->buffers[6],a);return 0;
#endif
#endif
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
case 48:CRYP_Write_ContextSwapRegisters(&s->h,s->buffers[6],a);return 0;
#endif
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
case 49:CRYP_PhaseProcessingResume(&s->h);return 0;
#endif
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
case 50:return CRYP_SAES_AlgoConversion(a,b);
#endif

case 51:return HAL_CRYPEx_AESGCM_GenerateAuthTAG(&s->h,s->buffers[1],b);

case 52:return HAL_CRYPEx_AESCCM_GenerateAuthTAG(&s->h,s->buffers[1],b);
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
case 53:return HAL_CRYPEx_WrapKey(&s->h,s->buffers[0],s->buffers[1],b);
#endif
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
case 54:return HAL_CRYPEx_UnwrapKey(&s->h,s->buffers[0],b);
#endif
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
case 55:return HAL_CRYPEx_EncryptSharedKey(&s->h,s->buffers[0],s->buffers[1],a,b);
#endif
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
case 56:return HAL_CRYPEx_DecryptSharedKey(&s->h,s->buffers[0],a,b);
#endif
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
case 57:return CRYPEx_KeyDecrypt(&s->h,a);
#endif
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
case 58:return CRYPEx_KeyEncrypt(&s->h,a);
#endif
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
case 59:CRYPEx_SetKey(&s->h,a);return 0;
#endif
case 100:__HAL_CRYP_ENABLE(&s->h);return 0;
case 101:__HAL_CRYP_DISABLE(&s->h);return 0;
case 102:return __HAL_CRYP_GET_FLAG(&s->h,a);
case 103:__HAL_CRYP_ENABLE_IT(&s->h,a);return 0;
case 104:__HAL_CRYP_DISABLE_IT(&s->h,a);return 0;
case 105:__HAL_CRYP_RESET_HANDLE_STATE(&s->h);return 0;
#if !defined(USE_HAL_CRYP_ONLY) || USE_HAL_CRYP_ONLY==1
case 106:return __HAL_CRYP_GET_IT(&s->h,a);
#endif
#if !defined(USE_HAL_SAES_ONLY) || USE_HAL_SAES_ONLY==1
case 107:return __HAL_CRYP_GET_IT_SOURCE(&s->h,a);
case 108:__HAL_CRYP_CLEAR_FLAG(&s->h,a);return 0;
case 109:return SAES_CONV_DATATYPE(a);
case 110:return SAES_CONV_KEYSIZE(a);
case 111:return SAES_CONV_ALGO(a);
#endif
case 112:return CRYP_CONV_ALGODIR(a);
default:assert(0);return 0;} }
