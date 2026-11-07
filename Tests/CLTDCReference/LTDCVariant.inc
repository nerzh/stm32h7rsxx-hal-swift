uint32_t CL_JOIN(CL_VARIANT,_Run)(CLTDCState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {
    LTDC_HandleTypeDef *h=&s->handle;
    switch(op) {
    case 0:return HAL_LTDC_Init(a?NULL:h);
    case 1:return HAL_LTDC_DeInit(a?NULL:h);
    case 2:HAL_LTDC_IRQHandler(h);return 0;
    case 3:return HAL_LTDC_ConfigLayer(h,&s->configuration,a);
    case 4:return HAL_LTDC_ConfigLayer_NoReload(h,&s->configuration,a);
    case 5:return HAL_LTDC_ConfigCLUT(h,b?s->colors:NULL,b,a);
    case 6:return HAL_LTDC_SetWindowSize(h,b,c,a);
    case 7:return HAL_LTDC_SetWindowSize_NoReload(h,b,c,a);
    case 8:return HAL_LTDC_SetWindowPosition(h,b,c,a);
    case 9:return HAL_LTDC_SetWindowPosition_NoReload(h,b,c,a);
    case 10:return HAL_LTDC_SetPixelFormat(h,b,a);
    case 11:return HAL_LTDC_SetPixelFormat_NoReload(h,b,a);
    case 12:return HAL_LTDC_SetAlpha(h,b,a);
    case 13:return HAL_LTDC_SetAlpha_NoReload(h,b,a);
    case 14:return HAL_LTDC_SetAddress(h,b,a);
    case 15:return HAL_LTDC_SetAddress_NoReload(h,b,a);
    case 16:return HAL_LTDC_SetPitch(h,b,a);
    case 17:return HAL_LTDC_SetPitch_NoReload(h,b,a);
    case 18:return HAL_LTDC_ConfigColorKeying(h,b,a);
    case 19:return HAL_LTDC_ConfigColorKeying_NoReload(h,b,a);
    case 20:return HAL_LTDC_EnableColorKeying(h,a);
    case 21:return HAL_LTDC_EnableColorKeying_NoReload(h,a);
    case 22:return HAL_LTDC_DisableColorKeying(h,a);
    case 23:return HAL_LTDC_DisableColorKeying_NoReload(h,a);
    case 24:return HAL_LTDC_EnableCLUT(h,a);
    case 25:return HAL_LTDC_EnableCLUT_NoReload(h,a);
    case 26:return HAL_LTDC_DisableCLUT(h,a);
    case 27:return HAL_LTDC_DisableCLUT_NoReload(h,a);
    case 28:return HAL_LTDC_EnableDither(h);
    case 29:return HAL_LTDC_DisableDither(h);
    case 30:return HAL_LTDC_ProgramLineEvent(h,a);
    case 31:return HAL_LTDC_Reload(h,a);
    case 32:return HAL_LTDC_GetState(h);
    case 33:return HAL_LTDC_GetError(h);
    case 34:
#if CL_MODE
        __HAL_LTDC_RESET_HANDLE_STATE(h);
#else
        h->State=HAL_LTDC_STATE_RESET;
#endif
        return 0;
    case 35:__HAL_LTDC_ENABLE(h);return 0;
    case 36:__HAL_LTDC_DISABLE(h);return 0;
    case 37:__HAL_LTDC_LAYER_ENABLE(h,a);return 0;
    case 38:__HAL_LTDC_LAYER_DISABLE(h,a);return 0;
    case 39:__HAL_LTDC_RELOAD_IMMEDIATE_CONFIG(h);return 0;
    case 40:__HAL_LTDC_VERTICAL_BLANKING_RELOAD_CONFIG(h);return 0;
    case 41:return __HAL_LTDC_GET_FLAG(h,a);
    case 42:__HAL_LTDC_CLEAR_FLAG(h,a);return 0;
    case 43:__HAL_LTDC_ENABLE_IT(h,a);return 0;
    case 44:__HAL_LTDC_DISABLE_IT(h,a);return 0;
    case 45:return __HAL_LTDC_GET_IT_SOURCE(h,a);
#if CL_MODE
    case 46:return HAL_LTDC_RegisterCallback(h,a,CLTDC_CallbackPointer(a,b));
    case 47:return HAL_LTDC_UnRegisterCallback(h,a);
#endif
    default:assert(0);return UINT32_MAX;
    }
}
