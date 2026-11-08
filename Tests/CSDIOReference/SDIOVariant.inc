uint32_t F_JOIN(F_VARIANT,_Run)(CSDIOState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){switch(op){
case 0:
return HAL_SDIO_Init(&s->h);
case 1:
return HAL_SDIO_DeInit(&s->h);
case 2:
return HAL_SDIO_SetDataBusWidth(&s->h, a);
case 3:
return HAL_SDIO_ConfigFrequency(&s->h, a);
case 4:
return HAL_SDIO_SetBlockSize(&s->h, a, b);
case 5:
return HAL_SDIO_SetSpeedMode(&s->h, a);
case 6:
return HAL_SDIO_CardReset(&s->h);
case 7:
return HAL_SDIO_GetCardCommonControlRegister(&s->h, s->control[10]?NULL:&s->commonControl);
case 8:
return HAL_SDIO_GetCardFBRRegister(&s->h, s->control[10]?NULL:s->functions);
case 9:
return HAL_SDIO_ReadDirect(&s->h, s->control[10]?NULL:&s->directCommand, s->control[9]?NULL:(uint8_t *)s->buffers[1]);
case 10:
return HAL_SDIO_WriteDirect(&s->h, s->control[10]?NULL:&s->directCommand, a);
case 11:
return HAL_SDIO_ReadExtended(&s->h, s->control[10]?NULL:&s->extendedCommand, s->control[9]?NULL:(uint8_t *)s->buffers[1], a, b);
case 12:
return HAL_SDIO_WriteExtended(&s->h, s->control[10]?NULL:&s->extendedCommand, s->control[9]?NULL:(uint8_t *)s->buffers[0], a, b);
case 13:
return HAL_SDIO_ReadExtended_DMA(&s->h, s->control[10]?NULL:&s->extendedCommand, s->control[9]?NULL:(uint8_t *)s->buffers[1], a);
case 14:
return HAL_SDIO_WriteExtended_DMA(&s->h, s->control[10]?NULL:&s->extendedCommand, s->control[9]?NULL:(uint8_t *)s->buffers[0], a);
case 15:
HAL_SDIO_IRQHandler(&s->h);return 0;
case 16:
#if USE_HAL_SDIO_REGISTER_CALLBACKS
return HAL_SDIO_RegisterCallback(&s->h, a, (pSDIO_CallbackTypeDef)CSDIO_Callback(a,b));
#else
return HAL_ERROR;
#endif
case 17:
#if USE_HAL_SDIO_REGISTER_CALLBACKS
return HAL_SDIO_UnRegisterCallback(&s->h, a);
#else
return HAL_ERROR;
#endif
case 18:
#if USE_SDIO_TRANSCEIVER
return HAL_SDIO_RegisterTransceiverCallback(&s->h, (pSDIO_TransceiverCallbackTypeDef)CSDIO_Callback(18,a));
#else
return HAL_ERROR;
#endif
case 19:
#if USE_SDIO_TRANSCEIVER
return HAL_SDIO_UnRegisterTransceiverCallback(&s->h);
#else
return HAL_ERROR;
#endif
case 20:
return HAL_SDIO_RegisterIdentifyCardCallback(&s->h, a?CSDIO_IdentifyCustom:NULL);
case 21:
return HAL_SDIO_GetState(&s->h);
case 22:
return HAL_SDIO_GetError(&s->h);
case 23:
return HAL_SDIO_EnableIOFunctionInterrupt(&s->h, a);
case 24:
return HAL_SDIO_DisableIOFunctionInterrupt(&s->h, a);
case 25:
return HAL_SDIO_EnableIOFunction(&s->h, a);
case 26:
return HAL_SDIO_DisableIOFunction(&s->h, a);
case 27:
return HAL_SDIO_SelectIOFunction(&s->h, a);
case 28:
return HAL_SDIO_AbortIOFunction(&s->h, a);
case 29:
return HAL_SDIO_EnableIOAsynInterrupt(&s->h);
case 30:
return HAL_SDIO_DisableIOAsynInterrupt(&s->h);
case 31:
return HAL_SDIO_RegisterIOFunctionCallback(&s->h, a, b?CSDIO_FunctionCustom:NULL);
default:assert(0);return 0;}}
