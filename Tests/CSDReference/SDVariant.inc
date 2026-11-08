uint32_t F_JOIN(F_VARIANT,_Run)(CSDState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){switch(op){
case 0:
return HAL_SD_Init(&s->h);
case 1:
return HAL_SD_InitCard(&s->h);
case 2:
return HAL_SD_DeInit(&s->h);
case 3:
return HAL_SD_ReadBlocks(&s->h, s->control[9]?NULL:(uint8_t *)s->buffers[1], a, b, c);
case 4:
return HAL_SD_WriteBlocks(&s->h, s->control[9]?NULL:(uint8_t *)s->buffers[0], a, b, c);
case 5:
return HAL_SD_ReadBlocks_IT(&s->h, s->control[9]?NULL:(uint8_t *)s->buffers[1], a, b);
case 6:
return HAL_SD_WriteBlocks_IT(&s->h, s->control[9]?NULL:(uint8_t *)s->buffers[0], a, b);
case 7:
return HAL_SD_ReadBlocks_DMA(&s->h, s->control[9]?NULL:(uint8_t *)s->buffers[1], a, b);
case 8:
return HAL_SD_WriteBlocks_DMA(&s->h, s->control[9]?NULL:(uint8_t *)s->buffers[0], a, b);
case 9:
return HAL_SD_Erase(&s->h, a, b);
case 10:
HAL_SD_IRQHandler(&s->h);return 0;
case 11:
return HAL_SD_GetState(&s->h);
case 12:
return HAL_SD_GetError(&s->h);
case 13:
#if USE_HAL_SD_REGISTER_CALLBACKS
return HAL_SD_RegisterCallback(&s->h, a, (pSD_CallbackTypeDef)CSD_Callback(a,b));
#else
return HAL_ERROR;
#endif
case 14:
#if USE_HAL_SD_REGISTER_CALLBACKS
return HAL_SD_UnRegisterCallback(&s->h, a);
#else
return HAL_ERROR;
#endif
case 15:
#if USE_HAL_SD_REGISTER_CALLBACKS && USE_SD_TRANSCEIVER
return HAL_SD_RegisterTransceiverCallback(&s->h, (pSD_TransceiverCallbackTypeDef)CSD_Callback(18,b));
#else
return HAL_ERROR;
#endif
case 16:
#if USE_HAL_SD_REGISTER_CALLBACKS && USE_SD_TRANSCEIVER
return HAL_SD_UnRegisterTransceiverCallback(&s->h);
#else
return HAL_ERROR;
#endif
case 17:
return HAL_SD_GetCardCID(&s->h, s->control[10]?NULL:&s->cardCID);
case 18:
return HAL_SD_GetCardCSD(&s->h, s->control[10]?NULL:&s->cardCSD);
case 19:
return HAL_SD_GetCardStatus(&s->h, s->control[10]?NULL:&s->cardStatus);
case 20:
return HAL_SD_GetCardInfo(&s->h, s->control[10]?NULL:&s->cardInfo);
case 21:
return HAL_SD_ConfigWideBusOperation(&s->h, a);
case 22:
return HAL_SD_ConfigSpeedBusOperation(&s->h, a);
case 23:
return HAL_SD_GetCardState(&s->h);
case 24:
return HAL_SD_Abort(&s->h);
case 25:
return HAL_SD_Abort_IT(&s->h);
case 39:
return HAL_SDEx_DMALinkedList_BuildNode((a?&s->ll.nodes[(a-0x24030100U)/12]:NULL), s->control[11]?NULL:&s->ll.nodeConfiguration);
case 40:
return HAL_SDEx_DMALinkedList_InsertNode(a?&s->ll.list:NULL, (b?&s->ll.nodes[(b-0x24030100U)/12]:NULL), (c?&s->ll.nodes[(c-0x24030100U)/12]:NULL));
case 41:
return HAL_SDEx_DMALinkedList_RemoveNode(a?&s->ll.list:NULL, (b?&s->ll.nodes[(b-0x24030100U)/12]:NULL));
case 42:
return HAL_SDEx_DMALinkedList_LockNode((a?&s->ll.nodes[(a-0x24030100U)/12]:NULL));
case 43:
return HAL_SDEx_DMALinkedList_UnlockNode((a?&s->ll.nodes[(a-0x24030100U)/12]:NULL));
case 44:
return HAL_SDEx_DMALinkedList_EnableCircularMode(a?&s->ll.list:NULL);
case 45:
return HAL_SDEx_DMALinkedList_DisableCircularMode(a?&s->ll.list:NULL);
case 46:
return HAL_SDEx_DMALinkedList_ReadBlocks(&s->h, s->control[12]?NULL:&s->ll.list, a, b);
case 47:
return HAL_SDEx_DMALinkedList_WriteBlocks(&s->h, s->control[12]?NULL:&s->ll.list, a, b);
default:assert(0);return 0;}}
