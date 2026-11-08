uint32_t SC_JOIN(SC_VARIANT,_Run)(CSerialState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c) {
 CEC_HandleTypeDef *h=&s->ch;
 switch(op) {
 case 0:return HAL_CEC_Init(h);
 case 1:return HAL_CEC_DeInit(h);
 case 2:return HAL_CEC_SetDeviceAddress(h,(uint16_t)a);
 case 3:return HAL_CEC_Transmit_IT(h,(uint8_t)a,(uint8_t)b,c?s->data+c-1:NULL,s->control[2]);
 case 4:HAL_CEC_IRQHandler(h);return 0;
 case 5:return HAL_CEC_GetLastReceivedFrameSize(h);
 case 6:HAL_CEC_ChangeRxBuffer(h,a?s->data+a-1:NULL);return 0;
 case 7:return HAL_CEC_GetState(h);
 case 8:return HAL_CEC_GetError(h);
#if SC_MODE
 case 9:return HAL_CEC_RegisterCallback(h,a,CSerial_CECcallback(a,b));
 case 10:return HAL_CEC_UnRegisterCallback(h,a);
 case 11:return HAL_CEC_RegisterRxCpltCallback(h,CSerial_CECrxCallback(a));
 case 12:return HAL_CEC_UnRegisterRxCpltCallback(h);
#endif
 case 13:__HAL_CEC_RESET_HANDLE_STATE(h);return 0;
 case 14:return __HAL_CEC_GET_FLAG(h,a);
 case 15:__HAL_CEC_CLEAR_FLAG(h,a);return 0;
 case 16:__HAL_CEC_ENABLE_IT(h,a);return 0;
 case 17:__HAL_CEC_DISABLE_IT(h,a);return 0;
 case 18:return __HAL_CEC_GET_IT_SOURCE(h,a);
 case 19:__HAL_CEC_ENABLE(h);return 0;
 case 20:__HAL_CEC_DISABLE(h);return 0;
 case 21:__HAL_CEC_FIRST_BYTE_TX_SET(h);return 0;
 case 22:__HAL_CEC_LAST_BYTE_TX_SET(h);return 0;
 case 23:return __HAL_CEC_GET_TRANSMISSION_START_FLAG(h);
 case 24:return __HAL_CEC_GET_TRANSMISSION_END_FLAG(h);
 case 25:__HAL_CEC_CLEAR_OAR(h);return 0;
 case 26:__HAL_CEC_SET_OAR(h,a);return 0;
 default:assert(0);return UINT32_MAX;
 }
}
