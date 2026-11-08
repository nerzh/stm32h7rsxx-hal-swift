uint32_t M_JOIN(M_VARIANT,_Run)(CMCEState *s,uint32_t op,uint32_t a,uint32_t b) {
 CMCE_Active=s;MCE_HandleTypeDef *h=&s->h;
 MCE_AESConfigTypeDef aes={{s->config[6],s->config[7]},s->config[8],s->control[0]?s->key:NULL};
 MCE_NoekeonConfigTypeDef noekeon={a,s->control[0]?s->key:NULL};
 MCE_RegionConfigTypeDef region={s->config[0],s->config[1],s->config[2],s->config[3],s->config[4],s->config[5]};
 switch(op) {
 case 0:return HAL_MCE_Init(h);
 case 1:return HAL_MCE_DeInit(h);
 case 2:return HAL_MCE_ConfigNoekeon(h,&noekeon);
 case 3:return HAL_MCE_ConfigAESContext(h,s->control[1]?&aes:NULL,a);
 case 4:return HAL_MCE_ConfigRegion(h,a,s->control[1]?&region:NULL);
 case 5:return HAL_MCE_SetRegionAESContext(h,a,b);
 case 6:return HAL_MCE_EnableAESContext(h,a);
 case 7:return HAL_MCE_DisableAESContext(h,a);
 case 8:return HAL_MCE_EnableRegion(h,a);
 case 9:return HAL_MCE_DisableRegion(h,a);
 case 10:return HAL_MCE_LockGlobalConfig(h);
 case 11:return HAL_MCE_LockAESContextConfig(h,a);
 case 12:return HAL_MCE_LockAESContextKey(h,a);
 case 13:return HAL_MCE_LockNoekeonMasterKeys(h);
 case 14:return HAL_MCE_GetAESContextCRCKey(h,&s->config[9],a);
 case 15:return HAL_MCE_KeyCRCComputation(s->key);
 case 16:HAL_MCE_IRQHandler(h);return 0;
 case 17:return HAL_MCE_GetState(h);
 case 18:return HAL_MCE_GetError(h);
 case 19:__HAL_MCE_RESET_HANDLE_STATE(h);return 0;
 case 20:__HAL_MCE_ENABLE_IT(h,a);return 0;
 case 21:__HAL_MCE_DISABLE_IT(h,a);return 0;
 case 22:return __HAL_MCE_GET_FLAG(h,a);
 case 23:__HAL_MCE_CLEAR_FLAG(h,a);return 0;
 default:assert(0);return UINT32_MAX;
 }
}
#if !M_MODE
uint32_t CMCE_KeyCRC(const uint32_t *key) { return HAL_MCE_KeyCRCComputation(key); }
#endif
