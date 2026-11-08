uint32_t F_JOIN(F_VARIANT,_Run)(CMMCState *s,uint32_t op,uint32_t a,uint32_t b,uint32_t c){switch(op){
case 0:
return HAL_MMC_Init(&s->h);
case 1:
return HAL_MMC_InitCard(&s->h);
case 2:
return HAL_MMC_DeInit(&s->h);
case 3:
return HAL_MMC_ReadBlocks(&s->h, s->control[9]?NULL:(uint8_t *)s->buffers[1], a, b, c);
case 4:
return HAL_MMC_WriteBlocks(&s->h, s->control[9]?NULL:(uint8_t *)s->buffers[0], a, b, c);
case 5:
return HAL_MMC_ReadBlocks_IT(&s->h, s->control[9]?NULL:(uint8_t *)s->buffers[1], a, b);
case 6:
return HAL_MMC_WriteBlocks_IT(&s->h, s->control[9]?NULL:(uint8_t *)s->buffers[0], a, b);
case 7:
return HAL_MMC_ReadBlocks_DMA(&s->h, s->control[9]?NULL:(uint8_t *)s->buffers[1], a, b);
case 8:
return HAL_MMC_WriteBlocks_DMA(&s->h, s->control[9]?NULL:(uint8_t *)s->buffers[0], a, b);
case 9:
return HAL_MMC_Erase(&s->h, a, b);
case 10:
HAL_MMC_IRQHandler(&s->h);return 0;
case 11:
return HAL_MMC_GetState(&s->h);
case 12:
return HAL_MMC_GetError(&s->h);
case 13:
#if USE_HAL_MMC_REGISTER_CALLBACKS
return HAL_MMC_RegisterCallback(&s->h, a, (pMMC_CallbackTypeDef)CMMC_Callback(a,b));
#else
return HAL_ERROR;
#endif
case 14:
#if USE_HAL_MMC_REGISTER_CALLBACKS
return HAL_MMC_UnRegisterCallback(&s->h, a);
#else
return HAL_ERROR;
#endif
case 15:
return HAL_MMC_GetCardCID(&s->h, s->control[10]?NULL:&s->cardCID);
case 16:
return HAL_MMC_GetCardCSD(&s->h, s->control[10]?NULL:&s->cardCSD);
case 17:
return HAL_MMC_GetCardInfo(&s->h, s->control[10]?NULL:&s->cardInfo);
case 18:
return HAL_MMC_GetCardExtCSD(&s->h, s->control[10]?NULL:s->extendedOutput, a);
case 19:
return HAL_MMC_ConfigWideBusOperation(&s->h, a);
case 20:
return HAL_MMC_ConfigSpeedBusOperation(&s->h, a);
case 21:
return HAL_MMC_GetCardState(&s->h);
case 22:
return HAL_MMC_Abort(&s->h);
case 23:
return HAL_MMC_Abort_IT(&s->h);
case 24:
return HAL_MMC_EraseSequence(&s->h, a, b, c);
case 25:
return HAL_MMC_Sanitize(&s->h);
case 26:
return HAL_MMC_ConfigSecRemovalType(&s->h, a);
case 27:
return HAL_MMC_GetSupportedSecRemovalType(&s->h, s->control[10]?NULL:s->output);
case 28:
return HAL_MMC_SleepDevice(&s->h);
case 29:
return HAL_MMC_AwakeDevice(&s->h);
case 40:
return HAL_MMC_SwitchPartition(&s->h, a);
case 41:
return HAL_MMC_RPMB_ProgramAuthenticationKey(&s->h, s->control[9]?NULL:(uint8_t *)s->buffers[2], a);
case 42:
return HAL_MMC_RPMB_GetWriteCounter(&s->h, s->control[9]?NULL:(uint8_t *)s->buffers[2], a);
case 43:
return HAL_MMC_RPMB_WriteBlocks(&s->h, s->control[9]?NULL:(uint8_t *)s->buffers[0], a, b, s->control[9]?NULL:(uint8_t *)s->buffers[3], c);
case 44:
return HAL_MMC_RPMB_ReadBlocks(&s->h, s->control[9]?NULL:(uint8_t *)s->buffers[1], a, b, s->control[9]?NULL:(uint8_t *)s->buffers[2], s->control[9]?NULL:(uint8_t *)s->buffers[3], c);
case 45:
return HAL_MMCEx_DMALinkedList_BuildNode((a?&s->ll.nodes[(a-0x24030100U)/12]:NULL), s->control[11]?NULL:&s->ll.nodeConfiguration);
case 46:
return HAL_MMCEx_DMALinkedList_InsertNode(a?&s->ll.list:NULL, (b?&s->ll.nodes[(b-0x24030100U)/12]:NULL), (c?&s->ll.nodes[(c-0x24030100U)/12]:NULL));
case 47:
return HAL_MMCEx_DMALinkedList_RemoveNode(a?&s->ll.list:NULL, (b?&s->ll.nodes[(b-0x24030100U)/12]:NULL));
case 48:
return HAL_MMCEx_DMALinkedList_LockNode((a?&s->ll.nodes[(a-0x24030100U)/12]:NULL));
case 49:
return HAL_MMCEx_DMALinkedList_UnlockNode((a?&s->ll.nodes[(a-0x24030100U)/12]:NULL));
case 50:
return HAL_MMCEx_DMALinkedList_EnableCircularMode(a?&s->ll.list:NULL);
case 51:
return HAL_MMCEx_DMALinkedList_DisableCircularMode(a?&s->ll.list:NULL);
case 52:
return HAL_MMCEx_DMALinkedList_ReadBlocks(&s->h, s->control[12]?NULL:&s->ll.list, a, b);
case 53:
return HAL_MMCEx_DMALinkedList_WriteBlocks(&s->h, s->control[12]?NULL:&s->ll.list, a, b);
default:assert(0);return 0;}}
