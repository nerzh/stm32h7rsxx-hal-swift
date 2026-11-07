uint32_t CP_JOIN(CP_VARIANT,_Run)(CDCMIPPState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {
    DCMIPP_HandleTypeDef *h=&s->handle;
    switch(op) {
    case 0:return HAL_DCMIPP_Init(h);
    case 1:return HAL_DCMIPP_DeInit(h);
    case 2:return HAL_DCMIPP_PARALLEL_SetConfig(h,&s->parameters.parallel);
    case 3:return HAL_DCMIPP_PIPE_SetConfig(h,0,&s->parameters.pipe);
    case 4:return HAL_DCMIPP_SetIPPlugConfig(h,&s->parameters.ipplug);
    case 5:return HAL_DCMIPP_PIPE_Start(h,0,a,b);
    case 6:return HAL_DCMIPP_PIPE_DoubleBufferStart(h,0,a,b,c);
    case 7:return HAL_DCMIPP_PIPE_Stop(h,0);
    case 8:return HAL_DCMIPP_PIPE_Suspend(h,0);
    case 9:return HAL_DCMIPP_PIPE_Resume(h,0);
    case 10:HAL_DCMIPP_IRQHandler(h);return 0;
    case 11:return HAL_DCMIPP_PIPE_SetCropConfig(h,0,&s->parameters.crop);
    case 12:return HAL_DCMIPP_PIPE_EnableCrop(h,0);
    case 13:return HAL_DCMIPP_PIPE_DisableCrop(h,0);
    case 14:return HAL_DCMIPP_PIPE_SetBytesDecimationConfig(h,0,a,b);
    case 15:return HAL_DCMIPP_PIPE_SetLinesDecimationConfig(h,0,a,b);
    case 16:return HAL_DCMIPP_PIPE_EnableLimitEvent(h,0,a);
    case 17:return HAL_DCMIPP_PIPE_DisableLimitEvent(h,0);
    case 18:return HAL_DCMIPP_PIPE_SetFrameRate(h,0,a);
    case 19:return HAL_DCMIPP_PIPE_SetCaptureMode(h,0,a);
    case 20:return HAL_DCMIPP_PIPE_EnableCapture(h,a);
    case 21:return HAL_DCMIPP_PIPE_SetMemoryAddress(h,0,a,b);
    case 22:return HAL_DCMIPP_PIPE_PARALLEL_SetInputPixelFormat(h,0,a);
    case 23:return HAL_DCMIPP_PARALLEL_SetSyncUnmask(h,&s->parameters.sync);
    case 24:return HAL_DCMIPP_PIPE_EnableLineEvent(h,0,a);
    case 25:return HAL_DCMIPP_PIPE_DisableLineEvent(h,0);
    case 26:return HAL_DCMIPP_PIPE_ResetFrameCounter(h,0);
    case 27:return HAL_DCMIPP_PIPE_ReadFrameCounter(h,0,&s->parameters.counter);
    case 28:return HAL_DCMIPP_PIPE_GetDataCounter(h,0,&s->parameters.counter);
    case 29:return HAL_DCMIPP_GetState(h);
    case 30:return HAL_DCMIPP_GetError(h);
    case 31:return HAL_DCMIPP_PIPE_GetState(h,0);
    case 32:__HAL_DCMIPP_ENABLE_IT(h,a);return 0;
    case 33:__HAL_DCMIPP_DISABLE_IT(h,a);return 0;
    case 34:return __HAL_DCMIPP_GET_FLAG(h,a);
    case 35:__HAL_DCMIPP_CLEAR_FLAG(h,a);return 0;
    case 36:return __HAL_DCMIPP_GET_IT_SOURCE(h,a);
#if CP_MODE
    case 37:return HAL_DCMIPP_RegisterCallback(h,a,CDCMIPP_CallbackPointer(a,b));
    case 38:return HAL_DCMIPP_UnRegisterCallback(h,a);
    case 39:return HAL_DCMIPP_PIPE_RegisterCallback(h,a,CDCMIPP_PipeCallbackPointer(a,b));
    case 40:return HAL_DCMIPP_PIPE_UnRegisterCallback(h,a);
#endif
    default:assert(0);return UINT32_MAX;
    }
}
