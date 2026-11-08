uint32_t F_JOIN(F_VARIANT,_Run)(CNORState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){switch(op){
case 0:
return HAL_NOR_Init(&s->h,&s->timing[0],s->control[9]?NULL:&s->timing[1]);
case 1:
return HAL_NOR_DeInit(&s->h);
case 2:
return HAL_NOR_Read_ID(&s->h,&s->id);
case 3:
return HAL_NOR_ReturnToReadMode(&s->h);
case 4:
return HAL_NOR_Read(&s->h,(uint32_t *)(uintptr_t)a,s->buffer);
case 5:
return HAL_NOR_Program(&s->h,(uint32_t *)(uintptr_t)a,s->buffer);
case 6:
return HAL_NOR_ReadBuffer(&s->h,a,s->buffer,b);
case 7:
return HAL_NOR_ProgramBuffer(&s->h,a,s->buffer,b);
case 8:
return HAL_NOR_Erase_Block(&s->h,a,b);
case 9:
return HAL_NOR_Erase_Chip(&s->h,a);
case 10:
return HAL_NOR_Read_CFI(&s->h,&s->cfi);
case 11:
#if USE_HAL_NOR_REGISTER_CALLBACKS
return HAL_NOR_RegisterCallback(&s->h,a,(pNOR_CallbackTypeDef)CNOR_Callback(a,b));
#else
return HAL_ERROR;
#endif
case 12:
#if USE_HAL_NOR_REGISTER_CALLBACKS
return HAL_NOR_UnRegisterCallback(&s->h,a);
#else
return HAL_ERROR;
#endif
case 13:
return HAL_NOR_WriteOperation_Enable(&s->h);
case 14:
return HAL_NOR_WriteOperation_Disable(&s->h);
case 15:
return HAL_NOR_GetState(&s->h);
case 16:
return HAL_NOR_GetStatus(&s->h,a,b);
case 17:
#if USE_HAL_NOR_REGISTER_CALLBACKS
__HAL_NOR_RESET_HANDLE_STATE(&s->h);
#else
s->h.State=HAL_NOR_STATE_RESET;
#endif
return 0;
default:assert(0);return 0;}}
