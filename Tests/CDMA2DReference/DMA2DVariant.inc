uint32_t CD2_JOIN(CD2_VARIANT,_Run)(CDMA2DState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c,uint32_t d,uint32_t e) {
    DMA2D_HandleTypeDef *h=&s->handle;
    DMA2D_CLUTCfgTypeDef clut={(uint32_t *)(uintptr_t)b,c,d};
    switch(op) {
    case 0:return HAL_DMA2D_Init(a?NULL:h);
    case 1:return HAL_DMA2D_DeInit(a?NULL:h);
    case 2:return HAL_DMA2D_Start(h,a,b,c,d);
    case 3:return HAL_DMA2D_Start_IT(h,a,b,c,d);
    case 4:return HAL_DMA2D_BlendingStart(h,a,b,c,d,e);
    case 5:return HAL_DMA2D_BlendingStart_IT(h,a,b,c,d,e);
    case 6:return HAL_DMA2D_Abort(h);
    case 7:return HAL_DMA2D_Suspend(h);
    case 8:return HAL_DMA2D_Resume(h);
    case 9:return HAL_DMA2D_EnableCLUT(h,a);
    case 10:return HAL_DMA2D_CLUTStartLoad(h,&clut,a);
    case 11:return HAL_DMA2D_CLUTStartLoad_IT(h,&clut,a);
    case 12:return HAL_DMA2D_CLUTLoad(h,clut,a);
    case 13:return HAL_DMA2D_CLUTLoad_IT(h,clut,a);
    case 14:return HAL_DMA2D_CLUTLoading_Abort(h,a);
    case 15:return HAL_DMA2D_CLUTLoading_Suspend(h,a);
    case 16:return HAL_DMA2D_CLUTLoading_Resume(h,a);
    case 17:return HAL_DMA2D_PollForTransfer(h,a);
    case 18:HAL_DMA2D_IRQHandler(h);return 0;
    case 19:return HAL_DMA2D_ConfigLayer(h,a);
    case 20:return HAL_DMA2D_ConfigCLUT(h,clut,a);
    case 21:return HAL_DMA2D_ProgramLineEvent(h,a);
    case 22:return HAL_DMA2D_EnableDeadTime(h);
    case 23:return HAL_DMA2D_DisableDeadTime(h);
    case 24:return HAL_DMA2D_ConfigDeadTime(h,(uint8_t)a);
    case 25:return HAL_DMA2D_GetState(h);
    case 26:return HAL_DMA2D_GetError(h);
    case 27:
#if CD2_MODE
        __HAL_DMA2D_RESET_HANDLE_STATE(h);
#else
        h->State=HAL_DMA2D_STATE_RESET;
#endif
        return 0;
    case 28:__HAL_DMA2D_ENABLE(h);return 0;
    case 29:return __HAL_DMA2D_GET_FLAG(h,a);
    case 30:__HAL_DMA2D_CLEAR_FLAG(h,a);return 0;
    case 31:__HAL_DMA2D_ENABLE_IT(h,a);return 0;
    case 32:__HAL_DMA2D_DISABLE_IT(h,a);return 0;
    case 33:return __HAL_DMA2D_GET_IT_SOURCE(h,a);
#if CD2_MODE
    case 34:return HAL_DMA2D_RegisterCallback(h,a,CDMA2D_CallbackPointer(a,b));
    case 35:return HAL_DMA2D_UnRegisterCallback(h,a);
#endif
    default:assert(0);return UINT32_MAX;
    }
}
