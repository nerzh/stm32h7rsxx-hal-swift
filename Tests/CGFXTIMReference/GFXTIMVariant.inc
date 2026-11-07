uint32_t CGFX_JOIN(CGFX_VARIANT,_Run)(CGFXTIMState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t nulls) {
    GFXTIM_HandleTypeDef *h=(nulls&1)?NULL:&s->handle;
    void *config=(nulls&2)?NULL:s->configuration;
    switch(op) {
    case 0:return HAL_GFXTIM_Init(h);
    case 1:return HAL_GFXTIM_DeInit(h);
    case 2:return HAL_GFXTIM_ClockGenerator_Config(h,config);
    case 3:return HAL_GFXTIM_ClockGenerator_Reload(h,a);
    case 4:return HAL_GFXTIM_AbsoluteTimer_Config(h,config);
    case 5:return HAL_GFXTIM_AbsoluteTimer_Start(h);
    case 6:return HAL_GFXTIM_AbsoluteTimer_Stop(h);
    case 7:return HAL_GFXTIM_AbsoluteTimer_Reset(h);
    case 8:return HAL_GFXTIM_AbsoluteTimer_GetCounter(h,a,CGFXTIM_Output(s,b));
    case 9:return HAL_GFXTIM_AbsoluteTimer_SetFrameCompare(h,a);
    case 10:return HAL_GFXTIM_AbsoluteTimer_SetLineCompare(h,a,b);
    case 11:return HAL_GFXTIM_RelativeTimer_Config(h,config,a);
    case 12:return HAL_GFXTIM_RelativeTimer_Start(h,a);
    case 13:return HAL_GFXTIM_RelativeTimer_Stop(h,a);
    case 14:return HAL_GFXTIM_RelativeTimer_ForceReload(h,a);
    case 15:return HAL_GFXTIM_RelativeTimer_SetReload(h,a,b);
    case 16:return HAL_GFXTIM_RelativeTimer_GetCounter(h,a,CGFXTIM_Output(s,b));
    case 17:return HAL_GFXTIM_EventGenerator_Config(h,a,config);
    case 18:return HAL_GFXTIM_EventGenerator_Enable(h,a);
    case 19:return HAL_GFXTIM_EventGenerator_Disable(h,a);
    case 20:return HAL_GFXTIM_WatchdogTimer_Config(h,config);
    case 21:return HAL_GFXTIM_WatchdogTimer_Enable(h);
    case 22:return HAL_GFXTIM_WatchdogTimer_Disable(h);
    case 23:return HAL_GFXTIM_WatchdogTimer_Refresh(h);
    case 24:HAL_GFXTIM_IRQHandler(h);return 0;
    case 25:return HAL_GFXTIM_GetState(h);
    case 26:return HAL_GFXTIM_GetError(h);
    case 27:
#if CGFX_MODE
        __HAL_GFXTIM_RESET_HANDLE_STATE(h);
#else
        h->State=HAL_GFXTIM_STATE_RESET;
#endif
        return 0;
    case 28:{uint32_t result=__HAL_GFXTIM_GET_FLAG(h,a);(void)CGFXTIM_Read(s,0x30);return result;}
    case 29:__HAL_GFXTIM_CLEAR_FLAG(h,a);CGFXTIM_Write(s,0x34,a);return 0;
#if CGFX_MODE
    case 30:return HAL_GFXTIM_RegisterCallback(h,a,CGFXTIM_CallbackPointer(a,b));
    case 31:return HAL_GFXTIM_UnRegisterCallback(h,a);
#endif
    default:assert(!"Invalid GFXTIM operation");return UINT32_MAX;
    }
}
