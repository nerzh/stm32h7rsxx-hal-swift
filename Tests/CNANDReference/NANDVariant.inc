uint32_t F_JOIN(F_VARIANT,_Run)(CNANDState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){switch(op){
case 0:
return HAL_NAND_Init(&s->h,&s->timing[0],&s->timing[1]);
case 1:
return HAL_NAND_DeInit(&s->h);
case 2:
HAL_NAND_IRQHandler(&s->h);return 0;
case 3:
return HAL_NAND_Read_ID(&s->h,&s->id);
case 4:
return HAL_NAND_Reset(&s->h);
case 5:
return HAL_NAND_ConfigDevice(&s->h,&s->device);
case 6:
return HAL_NAND_Read_Page_8b(&s->h,&s->address,(uint8_t *)s->buffer,a);
case 7:
return HAL_NAND_Read_Page_16b(&s->h,&s->address,(uint16_t *)s->buffer,a);
case 8:
return HAL_NAND_Write_Page_8b(&s->h,&s->address,(uint8_t *)s->buffer,a);
case 9:
return HAL_NAND_Write_Page_16b(&s->h,&s->address,(uint16_t *)s->buffer,a);
case 10:
return HAL_NAND_Read_SpareArea_8b(&s->h,&s->address,(uint8_t *)s->buffer,a);
case 11:
return HAL_NAND_Read_SpareArea_16b(&s->h,&s->address,(uint16_t *)s->buffer,a);
case 12:
return HAL_NAND_Write_SpareArea_8b(&s->h,&s->address,(uint8_t *)s->buffer,a);
case 13:
return HAL_NAND_Write_SpareArea_16b(&s->h,&s->address,(uint16_t *)s->buffer,a);
case 14:
return HAL_NAND_Erase_Block(&s->h,&s->address);
case 15:
return HAL_NAND_Address_Inc(&s->h,&s->address);
case 16:
#if USE_HAL_NAND_REGISTER_CALLBACKS
return HAL_NAND_RegisterCallback(&s->h,a,(pNAND_CallbackTypeDef)CNAND_Callback(a,b));
#else
return HAL_ERROR;
#endif
case 17:
#if USE_HAL_NAND_REGISTER_CALLBACKS
return HAL_NAND_UnRegisterCallback(&s->h,a);
#else
return HAL_ERROR;
#endif
case 18:
return HAL_NAND_ECC_Enable(&s->h);
case 19:
return HAL_NAND_ECC_Disable(&s->h);
case 20:
return HAL_NAND_GetECC(&s->h,&s->output,a);
case 21:
return HAL_NAND_GetState(&s->h);
case 22:
return HAL_NAND_Read_Status(&s->h);
case 23:
#if USE_HAL_NAND_REGISTER_CALLBACKS
__HAL_NAND_RESET_HANDLE_STATE(&s->h);
#else
s->h.State=HAL_NAND_STATE_RESET;
#endif
return 0;
default:assert(0);return 0;}}
