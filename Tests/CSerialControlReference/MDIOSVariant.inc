uint32_t SC_JOIN(SC_VARIANT,_Run)(CSerialState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {
 (void)c;MDIOS_HandleTypeDef *h=&s->mh;
 switch(op) {
 case 0:return HAL_MDIOS_Init(h);
 case 1:return HAL_MDIOS_DeInit(h);
 case 2:return HAL_MDIOS_WriteReg(h,a,(uint16_t)b);
 case 3:{uint16_t data=(uint16_t)s->control[2];uint32_t status=HAL_MDIOS_ReadReg(h,a,&data);s->control[2]=data;return status;}
 case 4:return HAL_MDIOS_GetWrittenRegAddress(h);
 case 5:return HAL_MDIOS_GetReadRegAddress(h);
 case 6:return HAL_MDIOS_ClearWriteRegAddress(h,a);
 case 7:return HAL_MDIOS_ClearReadRegAddress(h,a);
 case 8:return HAL_MDIOS_EnableEvents(h);
 case 9:HAL_MDIOS_IRQHandler(h);return 0;
 case 10:return HAL_MDIOS_GetState(h);
 case 11:return HAL_MDIOS_GetError(h);
#if SC_MODE
 case 12:return HAL_MDIOS_RegisterCallback(h,a,CSerial_MDIOScallback(a,b));
 case 13:return HAL_MDIOS_UnRegisterCallback(h,a);
#endif
 case 14:__HAL_MDIOS_RESET_HANDLE_STATE(h);return 0;
 case 15:__HAL_MDIOS_ENABLE(h);return 0;
 case 16:__HAL_MDIOS_DISABLE(h);return 0;
 case 17:__HAL_MDIOS_ENABLE_IT(h,a);return 0;
 case 18:__HAL_MDIOS_DISABLE_IT(h,a);return 0;
 case 19:return __HAL_MDIOS_GET_WRITE_FLAG(h,a);
 case 20:return __HAL_MDIOS_GET_READ_FLAG(h,a);
 case 21:return __HAL_MDIOS_GET_ERROR_FLAG(h,a);
 case 22:__HAL_MDIOS_CLEAR_ERROR_FLAG(h,a);return 0;
 case 23:return __HAL_MDIOS_GET_IT_SOURCE(h,a);
 case 24:__HAL_MDIOS_WAKEUP_EXTI_ENABLE_IT(a);return 0;
 case 25:return __HAL_MDIOS_WAKEUP_EXTI_GET_FLAG(a);
 case 26:__HAL_MDIOS_WAKEUP_EXTI_CLEAR_FLAG(a);return 0;
 case 27:__HAL_MDIOS_WAKEUP_EXTI_ENABLE_RISING_EDGE(a);return 0;
 case 28:__HAL_MDIOS_WAKEUP_EXTI_ENABLE_FALLING_EDGE(a);return 0;
 case 29:__HAL_MDIOS_WAKEUP_EXTI_ENABLE_RISING_FALLING_EDGE(a);return 0;
 case 30:__HAL_MDIOS_WAKEUP_EXTI_GENERATE_SWIT(a);return 0;
 default:assert(0);return UINT32_MAX;
 }
}
