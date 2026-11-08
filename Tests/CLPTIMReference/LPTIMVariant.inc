uint32_t CP_JOIN(CP_VARIANT,_Run)(CLPTIMState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {
 LPTIM_HandleTypeDef *h=&s->handle;
 switch(op) {
 case 0:return HAL_LPTIM_Init(h);
 case 1:return HAL_LPTIM_DeInit(h);
 case 2:return HAL_LPTIM_PWM_Start(h,a);
 case 3:return HAL_LPTIM_PWM_Stop(h,a);
 case 4:return HAL_LPTIM_PWM_Start_IT(h,a);
 case 5:return HAL_LPTIM_PWM_Stop_IT(h,a);
 case 6:return HAL_LPTIM_OnePulse_Start(h,a);
 case 7:return HAL_LPTIM_OnePulse_Stop(h,a);
 case 8:return HAL_LPTIM_OnePulse_Start_IT(h,a);
 case 9:return HAL_LPTIM_OnePulse_Stop_IT(h,a);
 case 10:return HAL_LPTIM_SetOnce_Start(h,a);
 case 11:return HAL_LPTIM_SetOnce_Stop(h,a);
 case 12:return HAL_LPTIM_SetOnce_Start_IT(h,a);
 case 13:return HAL_LPTIM_SetOnce_Stop_IT(h,a);
 case 14:return HAL_LPTIM_Encoder_Start(h);
 case 15:return HAL_LPTIM_Encoder_Stop(h);
 case 16:return HAL_LPTIM_Encoder_Start_IT(h);
 case 17:return HAL_LPTIM_Encoder_Stop_IT(h);
 case 18:return HAL_LPTIM_TimeOut_Start(h,a);
 case 19:return HAL_LPTIM_TimeOut_Stop(h);
 case 20:return HAL_LPTIM_TimeOut_Start_IT(h,a);
 case 21:return HAL_LPTIM_TimeOut_Stop_IT(h);
 case 22:return HAL_LPTIM_Counter_Start(h);
 case 23:return HAL_LPTIM_Counter_Stop(h);
 case 24:return HAL_LPTIM_Counter_Start_IT(h);
 case 25:return HAL_LPTIM_Counter_Stop_IT(h);
 case 26:return HAL_LPTIM_IC_Start(h,a);
 case 27:return HAL_LPTIM_IC_Stop(h,a);
 case 28:return HAL_LPTIM_IC_Start_IT(h,a);
 case 29:return HAL_LPTIM_IC_Stop_IT(h,a);
 case 30:return HAL_LPTIM_OC_ConfigChannel(h,&s->oc,a);
 case 31:return HAL_LPTIM_IC_ConfigChannel(h,&s->ic,a);
 case 32:return HAL_LPTIM_PWM_Start_DMA(h,a,(uint32_t *)(uintptr_t)b,c);
 case 33:return HAL_LPTIM_PWM_Stop_DMA(h,a);
 case 34:return HAL_LPTIM_IC_Start_DMA(h,a,(uint32_t *)(uintptr_t)b,c);
 case 35:return HAL_LPTIM_IC_Stop_DMA(h,a);
 case 36:HAL_LPTIM_IRQHandler(h);return 0;
 case 37:return HAL_LPTIM_ReadCounter(h);
 case 38:return HAL_LPTIM_ReadAutoReload(h);
 case 39:return HAL_LPTIM_ReadCapturedValue(h,a);
 case 40:return HAL_LPTIM_IC_GetOffset(h,a);
 case 41:return HAL_LPTIM_GetState(h);
 case 42:__HAL_LPTIM_RESET_HANDLE_STATE(h);return 0;
#if CP_MODE
 case 43:return HAL_LPTIM_RegisterCallback(h,a,CLPTIM_CallbackPointer(a,b));
 case 44:return HAL_LPTIM_UnRegisterCallback(h,a);
#endif
 case 45:__HAL_LPTIM_ENABLE(h);return 0;
 case 46:__HAL_LPTIM_DISABLE(h);return 0;
 case 47:__HAL_LPTIM_START_CONTINUOUS(h);return 0;
 case 48:__HAL_LPTIM_START_SINGLE(h);return 0;
 case 49:__HAL_LPTIM_RESET_COUNTER(h);return 0;
 case 50:__HAL_LPTIM_RESET_COUNTER_AFTERREAD(h);return 0;
 case 51:__HAL_LPTIM_AUTORELOAD_SET(h,a);return 0;
 case 52:__HAL_LPTIM_COMPARE_SET(h,a,b);return 0;
 case 53:__HAL_LPTIM_REPETITIONCOUNTER_SET(h,a);return 0;
 case 54:return __HAL_LPTIM_REPETITIONCOUNTER_GET(h);
 case 55:__HAL_LPTIM_CAPTURE_COMPARE_ENABLE(h,a);return 0;
 case 56:__HAL_LPTIM_CAPTURE_COMPARE_DISABLE(h,a);return 0;
 case 57:return __HAL_LPTIM_GET_FLAG(h,a);
 case 58:__HAL_LPTIM_CLEAR_FLAG(h,a);return 0;
 case 59:__HAL_LPTIM_ENABLE_IT(h,a);return 0;
 case 60:__HAL_LPTIM_DISABLE_IT(h,a);return 0;
 case 61:return __HAL_LPTIM_GET_IT_SOURCE(h,a);
 case 62:__HAL_LPTIM_ENABLE_DMA(h,a);return 0;
 case 63:__HAL_LPTIM_DISABLE_DMA(h,a);return 0;
 case 64:__HAL_LPTIM_WAKEUPTIMER_EXTI_ENABLE_IT(h->Instance);return 0;
 case 65:__HAL_LPTIM_WAKEUPTIMER_EXTI_DISABLE_IT(h->Instance);return 0;
 case 66:CP_JOIN(CP_VARIANT,_DMACallback)(a)(&s->dma[b]);return 0;
 default:assert(0);return UINT32_MAX;
 }
}
void (*CP_JOIN(CP_VARIANT,_DMACallback)(uint32_t token))(DMA_HandleTypeDef *) {
 switch(token) {
 case 0:return LPTIM_DMAError;
 case 1:return LPTIM_DMACaptureCplt;
 case 2:return LPTIM_DMACaptureHalfCplt;
 case 3:return LPTIM_DMAUpdateEventCplt;
 case 4:return LPTIM_DMAUpdateEventHalfCplt;
 default:return NULL;
 }
}
