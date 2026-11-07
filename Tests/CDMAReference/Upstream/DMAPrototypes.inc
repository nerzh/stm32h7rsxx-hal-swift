/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Exact declarations/macros/function source from STM32H7RS HAL at
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
HAL_StatusTypeDef HAL_DMA_Init(DMA_HandleTypeDef *const hdma);
HAL_StatusTypeDef HAL_DMA_DeInit(DMA_HandleTypeDef *const hdma);
HAL_StatusTypeDef HAL_DMA_Start(DMA_HandleTypeDef *const hdma,
                                uint32_t SrcAddress,
                                uint32_t DstAddress,
                                uint32_t SrcDataSize);
HAL_StatusTypeDef HAL_DMA_Start_IT(DMA_HandleTypeDef *const hdma,
                                   uint32_t SrcAddress,
                                   uint32_t DstAddress,
                                   uint32_t SrcDataSize);
HAL_StatusTypeDef HAL_DMA_Abort(DMA_HandleTypeDef *const hdma);
HAL_StatusTypeDef HAL_DMA_Abort_IT(DMA_HandleTypeDef *const hdma);
HAL_StatusTypeDef HAL_DMA_PollForTransfer(DMA_HandleTypeDef *const hdma,
                                          HAL_DMA_LevelCompleteTypeDef CompleteLevel,
                                          uint32_t Timeout);
void HAL_DMA_IRQHandler(DMA_HandleTypeDef *const hdma);
HAL_StatusTypeDef HAL_DMA_RegisterCallback(DMA_HandleTypeDef *const hdma,
                                           HAL_DMA_CallbackIDTypeDef CallbackID,
                                           void (*const  pCallback)(DMA_HandleTypeDef *const _hdma));
HAL_StatusTypeDef HAL_DMA_UnRegisterCallback(DMA_HandleTypeDef *const hdma,
                                             HAL_DMA_CallbackIDTypeDef CallbackID);
HAL_DMA_StateTypeDef HAL_DMA_GetState(DMA_HandleTypeDef const *const hdma);
uint32_t             HAL_DMA_GetError(DMA_HandleTypeDef const *const hdma);
HAL_StatusTypeDef HAL_DMA_ConfigChannelAttributes(DMA_HandleTypeDef *const hdma,
                                                  uint32_t ChannelAttributes);
HAL_StatusTypeDef HAL_DMA_GetConfigChannelAttributes(DMA_HandleTypeDef const *const hdma,
                                                     uint32_t *const pChannelAttributes);
HAL_StatusTypeDef HAL_DMA_LockChannelAttributes(DMA_HandleTypeDef const *const hdma);
HAL_StatusTypeDef HAL_DMA_GetLockChannelAttributes(DMA_HandleTypeDef const *const hdma,
                                                   uint32_t *const pLockState);
HAL_StatusTypeDef HAL_DMAEx_List_Init(DMA_HandleTypeDef *const hdma);
HAL_StatusTypeDef HAL_DMAEx_List_DeInit(DMA_HandleTypeDef *const hdma);
HAL_StatusTypeDef HAL_DMAEx_List_Start(DMA_HandleTypeDef *const hdma);
HAL_StatusTypeDef HAL_DMAEx_List_Start_IT(DMA_HandleTypeDef *const hdma);
HAL_StatusTypeDef HAL_DMAEx_List_BuildNode(DMA_NodeConfTypeDef const *const pNodeConfig,
                                           DMA_NodeTypeDef *const pNode);
HAL_StatusTypeDef HAL_DMAEx_List_GetNodeConfig(DMA_NodeConfTypeDef *const pNodeConfig,
                                               DMA_NodeTypeDef const *const pNode);
HAL_StatusTypeDef HAL_DMAEx_List_InsertNode(DMA_QListTypeDef *const pQList,
                                            DMA_NodeTypeDef *const pPrevNode,
                                            DMA_NodeTypeDef *const pNewNode);
HAL_StatusTypeDef HAL_DMAEx_List_InsertNode_Head(DMA_QListTypeDef *const pQList,
                                                 DMA_NodeTypeDef *const pNewNode);
HAL_StatusTypeDef HAL_DMAEx_List_InsertNode_Tail(DMA_QListTypeDef *const pQList,
                                                 DMA_NodeTypeDef *const pNewNode);
HAL_StatusTypeDef HAL_DMAEx_List_RemoveNode(DMA_QListTypeDef *const pQList,
                                            DMA_NodeTypeDef *const pNode);
HAL_StatusTypeDef HAL_DMAEx_List_RemoveNode_Head(DMA_QListTypeDef *const pQList);
HAL_StatusTypeDef HAL_DMAEx_List_RemoveNode_Tail(DMA_QListTypeDef *const pQList);
HAL_StatusTypeDef HAL_DMAEx_List_ReplaceNode(DMA_QListTypeDef *const pQList,
                                             DMA_NodeTypeDef *const pOldNode,
                                             DMA_NodeTypeDef *const pNewNode);
HAL_StatusTypeDef HAL_DMAEx_List_ReplaceNode_Head(DMA_QListTypeDef *const pQList,
                                                  DMA_NodeTypeDef *const pNewNode);
HAL_StatusTypeDef HAL_DMAEx_List_ReplaceNode_Tail(DMA_QListTypeDef *const pQList,
                                                  DMA_NodeTypeDef *const pNewNode);
HAL_StatusTypeDef HAL_DMAEx_List_ResetQ(DMA_QListTypeDef *const pQList);
HAL_StatusTypeDef HAL_DMAEx_List_InsertQ(DMA_QListTypeDef *const pSrcQList,
                                         DMA_NodeTypeDef const *const pPrevNode,
                                         DMA_QListTypeDef *const pDestQList);
HAL_StatusTypeDef HAL_DMAEx_List_InsertQ_Head(DMA_QListTypeDef *const pSrcQList,
                                              DMA_QListTypeDef *const pDestQList);
HAL_StatusTypeDef HAL_DMAEx_List_InsertQ_Tail(DMA_QListTypeDef *const pSrcQList,
                                              DMA_QListTypeDef *const pDestQList);
HAL_StatusTypeDef HAL_DMAEx_List_SetCircularModeConfig(DMA_QListTypeDef *const pQList,
                                                       DMA_NodeTypeDef *const pFirstCircularNode);
HAL_StatusTypeDef HAL_DMAEx_List_SetCircularMode(DMA_QListTypeDef *const pQList);
HAL_StatusTypeDef HAL_DMAEx_List_ClearCircularMode(DMA_QListTypeDef *const pQList);
HAL_StatusTypeDef HAL_DMAEx_List_ConvertQToDynamic(DMA_QListTypeDef *const pQList);
HAL_StatusTypeDef HAL_DMAEx_List_ConvertQToStatic(DMA_QListTypeDef *const pQList);
HAL_StatusTypeDef HAL_DMAEx_List_LinkQ(DMA_HandleTypeDef *const hdma,
                                       DMA_QListTypeDef *const pQList);
HAL_StatusTypeDef HAL_DMAEx_List_UnLinkQ(DMA_HandleTypeDef *const hdma);
HAL_StatusTypeDef HAL_DMAEx_ConfigDataHandling(DMA_HandleTypeDef *const hdma,
                                               DMA_DataHandlingConfTypeDef const *const pConfigDataHandling);
HAL_StatusTypeDef HAL_DMAEx_ConfigTrigger(DMA_HandleTypeDef *const hdma,
                                          DMA_TriggerConfTypeDef const *const pConfigTrigger);
HAL_StatusTypeDef HAL_DMAEx_ConfigRepeatBlock(DMA_HandleTypeDef *const hdma,
                                              DMA_RepeatBlockConfTypeDef const *const pConfigRepeatBlock);
HAL_StatusTypeDef HAL_DMAEx_Suspend(DMA_HandleTypeDef *const hdma);
HAL_StatusTypeDef HAL_DMAEx_Suspend_IT(DMA_HandleTypeDef *const hdma);
HAL_StatusTypeDef HAL_DMAEx_Resume(DMA_HandleTypeDef *const hdma);
uint32_t HAL_DMAEx_GetFifoLevel(DMA_HandleTypeDef const *const hdma);
