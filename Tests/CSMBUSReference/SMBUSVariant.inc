uint32_t F_JOIN(F_VARIANT,_Run)(CSMBUSState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){
 uint8_t *data=s->control[13]?NULL:s->buffer+s->control[14];
 switch(op){
case 0:return HAL_SMBUS_Init(&s->h);
case 1:return HAL_SMBUS_DeInit(&s->h);
case 2:return HAL_SMBUS_ConfigAnalogFilter(&s->h,a);
case 3:return HAL_SMBUS_ConfigDigitalFilter(&s->h,a);
#if F_MODE
case 4:return HAL_SMBUS_RegisterCallback(&s->h,(HAL_SMBUS_CallbackIDTypeDef)a,(pSMBUS_CallbackTypeDef)CSMBUS_Callback(a<8?a:0,b));
#endif
#if F_MODE
case 5:return HAL_SMBUS_UnRegisterCallback(&s->h,(HAL_SMBUS_CallbackIDTypeDef)a);
#endif
#if F_MODE
case 6:return HAL_SMBUS_RegisterAddrCallback(&s->h,(pSMBUS_AddrCallbackTypeDef)CSMBUS_Callback(8,b));
#endif
#if F_MODE
case 7:return HAL_SMBUS_UnRegisterAddrCallback(&s->h);
#endif
case 8:return HAL_SMBUS_Master_Transmit_IT(&s->h,a,data,b,s->control[17]);
case 9:return HAL_SMBUS_Master_Receive_IT(&s->h,a,data,b,s->control[17]);
case 10:return HAL_SMBUS_Master_Abort_IT(&s->h,a);
case 11:return HAL_SMBUS_Slave_Transmit_IT(&s->h,data,b,s->control[17]);
case 12:return HAL_SMBUS_Slave_Receive_IT(&s->h,data,b,s->control[17]);
case 13:return HAL_SMBUS_EnableListen_IT(&s->h);
case 14:return HAL_SMBUS_DisableListen_IT(&s->h);
case 15:return HAL_SMBUS_EnableAlert_IT(&s->h);
case 16:return HAL_SMBUS_DisableAlert_IT(&s->h);
case 17:return HAL_SMBUS_IsDeviceReady(&s->h,a,b,c);
case 18:HAL_SMBUS_EV_IRQHandler(&s->h);return 0;
case 19:HAL_SMBUS_ER_IRQHandler(&s->h);return 0;
case 20:return HAL_SMBUS_GetState(&s->h);
case 21:return HAL_SMBUS_GetError(&s->h);
case 22:return SMBUS_Master_ISR(&s->h,a);
case 23:return SMBUS_Slave_ISR(&s->h,a);
case 24:SMBUS_Enable_IRQ(&s->h,a);return 0;
case 25:SMBUS_Disable_IRQ(&s->h,a);return 0;
case 26:SMBUS_ITErrorHandler(&s->h);return 0;
case 27:return SMBUS_WaitOnFlagUntilTimeout(&s->h,a,(FlagStatus)b,c);
case 28:SMBUS_Flush_TXDR(&s->h);return 0;
case 29:SMBUS_TransferConfig(&s->h,a,b,s->control[19],c);return 0;
case 30:SMBUS_ConvertOtherXferOptions(&s->h);return 0;
case 31:return HAL_SMBUSEx_EnableWakeUp(&s->h);
case 32:return HAL_SMBUSEx_DisableWakeUp(&s->h);
case 33:return HAL_SMBUSEx_ConfigFastModePlus(&s->h,a);
case 100:return __HAL_SMBUS_GET_FLAG(&s->h,a);
case 101:__HAL_SMBUS_CLEAR_FLAG(&s->h,a);return 0;
case 102:__HAL_SMBUS_ENABLE_IT(&s->h,a);return 0;
case 103:__HAL_SMBUS_DISABLE_IT(&s->h,a);return 0;
case 104:return __HAL_SMBUS_GET_IT_SOURCE(&s->h,a);
case 105:__HAL_SMBUS_ENABLE(&s->h);return 0;
case 106:__HAL_SMBUS_DISABLE(&s->h);return 0;
case 107:__HAL_SMBUS_GENERATE_NACK(&s->h);return 0;
case 108:
#if F_MODE
__HAL_SMBUS_RESET_HANDLE_STATE(&s->h);
#else
s->h.State=HAL_SMBUS_STATE_RESET;
#endif
return 0;
case 109:SMBUS_RESET_CR1(&s->h);return 0;
case 110:SMBUS_RESET_CR2(&s->h);return 0;
case 111:return SMBUS_GET_ADDR_MATCH(&s->h);
case 112:return SMBUS_GET_DIR(&s->h);
case 113:return SMBUS_GET_STOP_MODE(&s->h);
case 114:return SMBUS_GET_PEC_MODE(&s->h);
case 115:return SMBUS_GET_ALERT_ENABLED(&s->h);
case 116:return SMBUS_CHECK_FLAG(a,b);
case 117:return SMBUS_CHECK_IT_SOURCE(a,b);
case 118:return SMBUS_GENERATE_START(a,b);
case 119:return IS_SMBUS_TRANSFER_OTHER_OPTIONS_REQUEST(a);
default:return HAL_ERROR;}}
