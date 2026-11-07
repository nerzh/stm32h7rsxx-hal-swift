/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Exact declarations/macros/function source from STM32H7RS HAL at
 * 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
static void DMA_List_Init(DMA_HandleTypeDef const *const hdma);
static void DMA_List_BuildNode(DMA_NodeConfTypeDef const *const pNodeConfig,
                               DMA_NodeTypeDef *const pNode);
static void DMA_List_GetNodeConfig(DMA_NodeConfTypeDef *const pNodeConfig,
                                   DMA_NodeTypeDef const *const pNode);
#if defined ( __GNUC__ ) && !defined (__CC_ARM)
static __attribute__((noinline)) uint32_t DMA_List_CheckNodesBaseAddresses(DMA_NodeTypeDef const *const pNode1,  \
                                                                           DMA_NodeTypeDef const *const pNode2,  \
                                                                           DMA_NodeTypeDef const *const pNode3);
#else
static uint32_t DMA_List_CheckNodesBaseAddresses(DMA_NodeTypeDef const *const pNode1,
                                                 DMA_NodeTypeDef const *const pNode2,
                                                 DMA_NodeTypeDef const *const pNode3);
#endif /* __GNUC__ && !__CC_ARM */
static uint32_t DMA_List_CheckNodesTypes(DMA_NodeTypeDef const *const pNode1,
                                         DMA_NodeTypeDef const *const pNode2,
                                         DMA_NodeTypeDef const *const pNode3);
static void DMA_List_GetCLLRNodeInfo(DMA_NodeTypeDef const *const pNode,
                                     uint32_t *const cllr_mask,
                                     uint32_t *const cllr_offset);
static uint32_t DMA_List_FindNode(DMA_QListTypeDef const *const pQList,
                                  DMA_NodeTypeDef const *const pNode,
                                  DMA_NodeInQInfoTypeDef *const NodeInfo);
static void DMA_List_ResetQueueNodes(DMA_QListTypeDef const *const pQList,
                                     DMA_NodeInQInfoTypeDef const *const NodeInfo);
static void DMA_List_FillNode(DMA_NodeTypeDef const *const pSrcNode,
                              DMA_NodeTypeDef *const pDestNode);
static void DMA_List_ConvertNodeToDynamic(uint32_t ContextNodeAddr,
                                          uint32_t CurrentNodeAddr,
                                          uint32_t RegisterNumber);
static void DMA_List_ConvertNodeToStatic(uint32_t ContextNodeAddr,
                                         uint32_t CurrentNodeAddr,
                                         uint32_t RegisterNumber);
static void DMA_List_UpdateDynamicQueueNodesCLLR(DMA_QListTypeDef const *const pQList,
                                                 uint32_t LastNode_IsCircular);
static void DMA_List_UpdateStaticQueueNodesCLLR(DMA_QListTypeDef const *const pQList,
                                                uint32_t operation);
static void DMA_List_FormatNode(DMA_NodeTypeDef *const pNode,
                                uint32_t RegisterIdx,
                                uint32_t RegisterNumber,
                                uint32_t Format);
static void DMA_List_ClearUnusedFields(DMA_NodeTypeDef *const pNode,
                                       uint32_t FirstUnusedField);
static void DMA_List_CleanQueue(DMA_QListTypeDef *const pQList);

/* Exported functions ------------------------------------------------------------------------------------------------*/

/** @addtogroup DMAEx_Exported_Functions
  * @{
  */

/** @addtogroup DMAEx_Exported_Functions_Group1
  *
@verbatim
  ======================================================================================================================
                 ##### Linked-List Initialization and De-Initialization Functions #####
  ======================================================================================================================
    [..]
      This section provides functions allowing to initialize and de-initialize the DMA channel in linked-list mode.
    [..]
      (+) The HAL_DMAEx_List_Init() function follows the DMA channel linked-list mode configuration procedures as
          described in reference manual.
      (+) The HAL_DMAEx_List_DeInit() function allows to de-initialize the DMA channel in linked-list mode.

@endverbatim
  * @{
  */

/**
  * @brief  Initialize the DMA channel in linked-list mode according to the specified parameters in the
  *         DMA_InitLinkedListTypeDef and create the associated handle.
  * @param  hdma : Pointer to a DMA_HandleTypeDef structure that contains the configuration information for the
  *                specified DMA Channel.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_List_Init(DMA_HandleTypeDef *const hdma)
{
  /* Get tick number */
  uint32_t tickstart = HAL_GetTick();

  /* Check the DMA channel handle parameter */
  if (hdma == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_DMA_ALL_INSTANCE(hdma->Instance));
  assert_param(IS_DMA_PRIORITY(hdma->InitLinkedList.Priority));
  assert_param(IS_DMA_LINK_STEP_MODE(hdma->InitLinkedList.LinkStepMode));
  assert_param(IS_DMA_TCEM_LINKEDLIST_EVENT_MODE(hdma->InitLinkedList.TransferEventMode));
  assert_param(IS_DMA_LINKEDLIST_MODE(hdma->InitLinkedList.LinkedListMode));
  /* Check DMA channel instance */
  if ((IS_HPDMA_INSTANCE(hdma->Instance) != 0U) || (IS_GPDMA_INSTANCE(hdma->Instance) != 0U))
  {
    assert_param(IS_DMA_LINK_ALLOCATED_PORT(hdma->InitLinkedList.LinkAllocatedPort));
  }

  /* Allocate lock resource */
  __HAL_UNLOCK(hdma);

  /* Change DMA peripheral state */
  hdma->State = HAL_DMA_STATE_BUSY;

  /* Disable the DMA channel */
  __HAL_DMA_DISABLE(hdma);

  /* Check if the DMA channel is effectively disabled */
  while ((hdma->Instance->CCR & DMA_CCR_EN) != 0U)
  {
    /* Check for the Timeout */
    if ((HAL_GetTick() - tickstart) > HAL_TIMEOUT_DMA_ABORT)
    {
      /* Update error code */
      hdma->ErrorCode = HAL_DMA_ERROR_TIMEOUT;

      /* Change the DMA state */
      hdma->State = HAL_DMA_STATE_ERROR;

      return HAL_ERROR;
    }
  }

  /* Initialize the DMA channel registers */
  DMA_List_Init(hdma);

  /* Update DMA channel operation mode */
  hdma->Mode = hdma->InitLinkedList.LinkedListMode;

  /* Update the DMA channel error code */
  hdma->ErrorCode = HAL_DMA_ERROR_NONE;

  /* Update the DMA channel state */
  hdma->State = HAL_DMA_STATE_READY;

  return HAL_OK;
}

/**
  * @brief  DeInitialize the DMA channel when it is configured in linked-list mode.
  * @param  hdma : Pointer to a DMA_HandleTypeDef structure that contains the configuration information for the
  *                specified DMA Channel.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_List_DeInit(DMA_HandleTypeDef *const hdma)
{
  /* Get tick number */
  uint32_t tickstart = HAL_GetTick();

  /* Check the DMA peripheral handle parameter */
  if (hdma == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_DMA_ALL_INSTANCE(hdma->Instance));

  /* Disable the selected DMA Channel */
  __HAL_DMA_DISABLE(hdma);

  /* Check if the DMA channel is effectively disabled */
  while ((hdma->Instance->CCR & DMA_CCR_EN) != 0U)
  {
    /* Check for the Timeout */
    if ((HAL_GetTick() - tickstart) > HAL_TIMEOUT_DMA_ABORT)
    {
      /* Update error code */
      hdma->ErrorCode = HAL_DMA_ERROR_TIMEOUT;

      /* Change the DMA state */
      hdma->State = HAL_DMA_STATE_ERROR;

      return HAL_ERROR;
    }
  }

  /* Reset DMA Channel registers */
  hdma->Instance->CCR   = 0U;
  hdma->Instance->CLBAR = 0U;
  hdma->Instance->CTR1  = 0U;
  hdma->Instance->CTR2  = 0U;
  hdma->Instance->CBR1  = 0U;
  hdma->Instance->CSAR  = 0U;
  hdma->Instance->CDAR  = 0U;
  hdma->Instance->CLLR  = 0U;

  /* Reset 2D Addressing registers */
  if (IS_DMA_2D_ADDRESSING_INSTANCE(hdma->Instance) != 0U)
  {
    hdma->Instance->CTR3 = 0U;
    hdma->Instance->CBR2 = 0U;
  }

  /* Clear all flags */
  __HAL_DMA_CLEAR_FLAG(hdma, (DMA_FLAG_TC | DMA_FLAG_HT | DMA_FLAG_DTE | DMA_FLAG_ULE | DMA_FLAG_USE | DMA_FLAG_SUSP |
                              DMA_FLAG_TO));

  /* Clean all callbacks */
  hdma->XferCpltCallback     = NULL;
  hdma->XferHalfCpltCallback = NULL;
  hdma->XferErrorCallback    = NULL;
  hdma->XferAbortCallback    = NULL;
  hdma->XferSuspendCallback  = NULL;

  /* Check the linked-list queue */
  if (hdma->LinkedListQueue != NULL)
  {
    /* Update the queue state and error code */
    hdma->LinkedListQueue->State     = HAL_DMA_QUEUE_STATE_READY;
    hdma->LinkedListQueue->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

    /* Clean DMA queue */
    hdma->LinkedListQueue = NULL;
  }

  /* Clean DMA parent */
  if (hdma->Parent != NULL)
  {
    hdma->Parent = NULL;
  }

  /* Update DMA channel operation mode */
  hdma->Mode = DMA_NORMAL;

  /* Update the DMA channel error code */
  hdma->ErrorCode = HAL_DMA_ERROR_NONE;

  /* Update the DMA channel state */
  hdma->State = HAL_DMA_STATE_RESET;

  /* Release Lock */
  __HAL_UNLOCK(hdma);

  return HAL_OK;
}
/**
  * @}
  */

/** @addtogroup DMAEx_Exported_Functions_Group2
  *
@verbatim
  ======================================================================================================================
                         ##### Linked-List IO Operation Functions #####
  ======================================================================================================================
    [..]
      This section provides functions allowing to :
      (+) Configure to start DMA transfer in linked-list mode.

    [..]
      (+) The HAL_DMAEx_List_Start() function allows to start the DMA channel transfer in linked-list mode (Blocking
          mode).
      (+) The HAL_DMAEx_List_Start_IT() function allows to start the DMA channel transfer in linked-list mode
          (Non-blocking mode).
              (++) It is mandatory to register a linked-list queue to be executed by a DMA channel before starting
                   transfer otherwise a HAL_ERROR will be returned.

@endverbatim
  * @{
  */

/**
  * @brief  Start the DMA channel transfer in linked-list mode (Blocking mode).
  * @param  hdma : Pointer to a DMA_HandleTypeDef structure that contains the configuration information for the
  *                specified DMA Channel.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_List_Start(DMA_HandleTypeDef *const hdma)
{
  HAL_DMA_StateTypeDef dma_state;
  uint32_t ccr_value;
  uint32_t cllr_mask;

  /* Check the DMA peripheral handle and the linked-list queue parameters */
  if ((hdma == NULL) || (hdma->LinkedListQueue == NULL))
  {
    return HAL_ERROR;
  }

  /* Check DMA channel state */
  dma_state = hdma->State;
  ccr_value = hdma->Instance->CCR & DMA_CCR_LSM;
  if ((dma_state == HAL_DMA_STATE_READY) || ((dma_state == HAL_DMA_STATE_BUSY) && (ccr_value != 0U)))
  {
    /* Check DMA channel state is ready */
    if (hdma->State == HAL_DMA_STATE_READY)
    {
      /* Process locked */
      __HAL_LOCK(hdma);

      /* Update the DMA channel and the queue states */
      hdma->State                  = HAL_DMA_STATE_BUSY;
      hdma->LinkedListQueue->State = HAL_DMA_QUEUE_STATE_BUSY;

      /* Update the DMA channel and the queue error codes */
      hdma->ErrorCode                  = HAL_DMA_ERROR_NONE;
      hdma->LinkedListQueue->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

      /* Get CLLR register mask and offset */
      DMA_List_GetCLLRNodeInfo(hdma->LinkedListQueue->Head, &cllr_mask, NULL);

      /* Update DMA registers for linked-list transfer */
      hdma->Instance->CLBAR = ((uint32_t)hdma->LinkedListQueue->Head & DMA_CLBAR_LBA);
      hdma->Instance->CLLR  = ((uint32_t)hdma->LinkedListQueue->Head & DMA_CLLR_LA) | cllr_mask;
    }

    /* Enable DMA channel */
    __HAL_DMA_ENABLE(hdma);
  }
  else
  {
    /* Update the DMA channel error code */
    hdma->ErrorCode = HAL_DMA_ERROR_BUSY;

    /* Process unlocked */
    __HAL_UNLOCK(hdma);

    return HAL_ERROR;
  }

  return HAL_OK;
}

/**
  * @brief  Starts the DMA channel transfer in linked-list mode with interrupts enabled (Non-blocking mode).
  * @param  hdma : Pointer to a DMA_HandleTypeDef structure that contains the configuration information for the
  *                specified DMA Channel.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_List_Start_IT(DMA_HandleTypeDef *const hdma)
{
  HAL_DMA_StateTypeDef dma_state;
  uint32_t ccr_value;
  uint32_t cllr_mask;

  /* Check the DMA peripheral handle and the linked-list queue parameters */
  if ((hdma == NULL) || (hdma->LinkedListQueue == NULL))
  {
    return HAL_ERROR;
  }

  /* Check DMA channel state */
  dma_state = hdma->State;
  ccr_value = hdma->Instance->CCR & DMA_CCR_LSM;
  if ((dma_state == HAL_DMA_STATE_READY) || ((dma_state == HAL_DMA_STATE_BUSY) && (ccr_value != 0U)))
  {
    /* Check DMA channel state is ready */
    if (hdma->State == HAL_DMA_STATE_READY)
    {
      /* Process locked */
      __HAL_LOCK(hdma);

      /* Update the DMA channel and the queue states */
      hdma->State                  = HAL_DMA_STATE_BUSY;
      hdma->LinkedListQueue->State = HAL_DMA_QUEUE_STATE_BUSY;

      /* Update the DMA channel and the queue error codes */
      hdma->ErrorCode                  = HAL_DMA_ERROR_NONE;
      hdma->LinkedListQueue->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

      /* Enable common interrupts: Transfer Complete and Transfer Errors ITs */
      __HAL_DMA_ENABLE_IT(hdma, (DMA_IT_TC | DMA_IT_DTE | DMA_IT_ULE | DMA_IT_USE | DMA_IT_TO));

      /* Check half transfer complete callback */
      if (hdma->XferHalfCpltCallback != NULL)
      {
        /* If half transfer complete callback is set, enable the corresponding IT */
        __HAL_DMA_ENABLE_IT(hdma, DMA_IT_HT);
      }

      /* Check suspend callback */
      if (hdma->XferSuspendCallback != NULL)
      {
        /* If transfer suspend callback is set, enable the corresponding IT */
        __HAL_DMA_ENABLE_IT(hdma, DMA_IT_SUSP);
      }

      /* Get CLLR register mask and offset */
      DMA_List_GetCLLRNodeInfo(hdma->LinkedListQueue->Head, &cllr_mask, NULL);

      /* Update DMA registers for linked-list transfer */
      hdma->Instance->CLBAR = ((uint32_t)hdma->LinkedListQueue->Head & DMA_CLBAR_LBA);
      hdma->Instance->CLLR  = ((uint32_t)hdma->LinkedListQueue->Head & DMA_CLLR_LA) | cllr_mask;
    }

    /* Enable DMA channel */
    __HAL_DMA_ENABLE(hdma);
  }
  else
  {
    /* Change the error code */
    hdma->ErrorCode = HAL_DMA_ERROR_BUSY;

    /* Process unlocked */
    __HAL_UNLOCK(hdma);

    return HAL_ERROR;
  }

  return HAL_OK;
}
/**
  * @}
  */

/** @addtogroup DMAEx_Exported_Functions_Group3
  *
@verbatim
  ======================================================================================================================
                         ##### Linked-List Management Functions #####
  ======================================================================================================================
    [..]
      This section provides functions allowing to :
      (+) Build linked-list node.
      (+) Get linked-list node configuration.
      (+) Insert node to linked-list queue in any queue position.
      (+) Remove any node from linked-list queue.
      (+) Replace any node from linked-list queue.
      (+) Reset linked-list queue.
      (+) Insert linked-list queue in any queue position.
      (+) Set circular mode configuration to linked-list queue.
      (+) Clear circular mode configuration from linked-list queue.
      (+) Convert static linked-list queue to dynamic format.
      (+) Convert dynamic linked-list queue to static format.
      (+) Link linked-list queue to DMA channel.
      (+) Unlink linked-list queue from DMA channel.

    [..]
      (+) The HAL_DMAEx_List_BuildNode() function allows to build linked-list node.
          Node type can be :
              (++) 2 dimensions addressing node.
              (++) Linear addressing node.

      (+) The HAL_DMAEx_List_GetNodeConfig() function allows to get the linked-list node configuration from built node.

      (+) The HAL_DMAEx_List_InsertNode() function allows to insert built linked-list node to static linked-list queue
          according to selected position.

      (+) The HAL_DMAEx_List_InsertNode_Head() and HAL_DMAEx_List_InsertNode_Tail() functions allow to insert built
          linked-list node to the head (respectively the tail) of static linked-list queue.

      (+) The HAL_DMAEx_List_RemoveNode() function allows to remove selected built linked-list node from static
          linked-list queue.

      (+) The HAL_DMAEx_List_RemoveNode_Head() and HAL_DMAEx_List_RemoveNode_Tail() functions allow to remove the head
          (respectively the tail) built linked-list node from static linked-list queue.

      (+) The HAL_DMAEx_List_ReplaceNode() function allows to replace selected built linked-list node from static
          linked-list queue.

      (+) The HAL_DMAEx_List_ReplaceNode_Head() and HAL_DMAEx_List_ReplaceNode_Tail() functions allow to replace the
          head (respectively the tail) built linked-list node of static linked-list queue.

      (+) The HAL_DMAEx_List_ResetQ() function allows to reset static linked-list queue and unlink all built linked-list
          nodes.

      (+) The HAL_DMAEx_List_InsertQ() function allows to insert static linked-list source queue to static linked-list
          destination queue according to selected position.

      (+) The HAL_DMAEx_List_InsertQ_Head() and HAL_DMAEx_List_InsertQ_Tail() functions allow to insert static
          linked-list source queue to the head (respectively the tail) of static linked-list destination queue.

      (+) The HAL_DMAEx_List_SetCircularModeConfig() function allows to link the last static linked-list queue node to
          the selected first circular node.

      (+) The HAL_DMAEx_List_SetCircularMode() function allows to link the last static linked-list queue node to the
          first static linked-list queue node.

      (+) The HAL_DMAEx_List_ClearCircularMode() function allows to unlink the last static linked-list queue node from
          any first circular node position.

      (+) The HAL_DMAEx_List_ConvertQToDynamic() function allows to convert the static linked-list queue to dynamic
          format. (Optimized queue execution)

      (+) The HAL_DMAEx_List_ConvertQToStatic() function allows to convert the dynamic linked-list queue to static
          format. (Not optimized queue execution)

      (+) The HAL_DMAEx_List_LinkQ() function allows to link the (Dynamic / Static) linked-list queue to DMA channel to
          be executed.

      (+) The HAL_DMAEx_List_UnLinkQ() function allows to unlink the (Dynamic / Static) linked-list queue from DMA
          channel when execution is completed.

@endverbatim
  * @{
  */

/**
  * @brief  Build a DMA channel node according to the specified parameters in the DMA_NodeConfTypeDef.
  * @param  pNodeConfig : Pointer to a DMA_NodeConfTypeDef structure that contains the configuration information for the
  *                       specified DMA linked-list Node.
  * @param  pNode       : Pointer to a DMA_NodeTypeDef structure that contains linked-list node registers
  *                       configurations.
  * @note   The DMA linked-list node parameter address should be 32bit aligned and should not exceed the 64 KByte
  *         addressable space.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_List_BuildNode(DMA_NodeConfTypeDef const *const pNodeConfig,
                                           DMA_NodeTypeDef *const pNode)
{
  /* Check the node configuration and physical node parameters */
  if ((pNodeConfig == NULL) || (pNode == NULL))
  {
    return HAL_ERROR;
  }

  /* Check node type parameter */
  assert_param(IS_DMA_NODE_TYPE(pNodeConfig->NodeType));

  /* Check DMA channel basic transfer parameters */
  assert_param(IS_DMA_SOURCE_INC(pNodeConfig->Init.SrcInc));
  assert_param(IS_DMA_DESTINATION_INC(pNodeConfig->Init.DestInc));
  assert_param(IS_DMA_SOURCE_DATA_WIDTH(pNodeConfig->Init.SrcDataWidth));
  assert_param(IS_DMA_DESTINATION_DATA_WIDTH(pNodeConfig->Init.DestDataWidth));
  assert_param(IS_DMA_DATA_ALIGNMENT(pNodeConfig->DataHandlingConfig.DataAlignment));
  assert_param(IS_DMA_REQUEST(pNodeConfig->Init.Request));
  assert_param(IS_DMA_DIRECTION(pNodeConfig->Init.Direction));
  assert_param(IS_DMA_TCEM_EVENT_MODE(pNodeConfig->Init.TransferEventMode));
  assert_param(IS_DMA_BLOCK_HW_REQUEST(pNodeConfig->Init.BlkHWRequest));
  assert_param(IS_DMA_MODE(pNodeConfig->Init.Mode));

  /* Check DMA channel parameters */
  if ((pNodeConfig->NodeType & (DMA_CHANNEL_TYPE_GPDMA | DMA_CHANNEL_TYPE_HPDMA)) != 0U)
  {
    assert_param(IS_DMA_BURST_LENGTH(pNodeConfig->Init.SrcBurstLength));
    assert_param(IS_DMA_BURST_LENGTH(pNodeConfig->Init.DestBurstLength));
    assert_param(IS_DMA_DATA_EXCHANGE(pNodeConfig->DataHandlingConfig.DataExchange));
    assert_param(IS_DMA_TRANSFER_ALLOCATED_PORT(pNodeConfig->Init.TransferAllocatedPort));
  }

  /* Check DMA channel trigger parameters */
  assert_param(IS_DMA_TRIGGER_POLARITY(pNodeConfig->TriggerConfig.TriggerPolarity));
  if (pNodeConfig->TriggerConfig.TriggerPolarity != DMA_TRIG_POLARITY_MASKED)
  {
    assert_param(IS_DMA_TRIGGER_MODE(pNodeConfig->TriggerConfig.TriggerMode));
    assert_param(IS_DMA_TRIGGER_SELECTION(pNodeConfig->TriggerConfig.TriggerSelection));
  }

  /* Check DMA channel repeated block parameters */
  if ((pNodeConfig->NodeType & DMA_CHANNEL_TYPE_2D_ADDR) == DMA_CHANNEL_TYPE_2D_ADDR)
  {
    assert_param(IS_DMA_REPEAT_COUNT(pNodeConfig->RepeatBlockConfig.RepeatCount));
    assert_param(IS_DMA_BURST_ADDR_OFFSET(pNodeConfig->RepeatBlockConfig.SrcAddrOffset));
    assert_param(IS_DMA_BURST_ADDR_OFFSET(pNodeConfig->RepeatBlockConfig.DestAddrOffset));
    assert_param(IS_DMA_BLOCK_ADDR_OFFSET(pNodeConfig->RepeatBlockConfig.BlkSrcAddrOffset));
    assert_param(IS_DMA_BLOCK_ADDR_OFFSET(pNodeConfig->RepeatBlockConfig.BlkDestAddrOffset));
  }

  /* Build the DMA channel node */
  DMA_List_BuildNode(pNodeConfig, pNode);

  return HAL_OK;
}

/**
  * @brief  Get a DMA channel node configuration.
  * @param  pNodeConfig : Pointer to a DMA_NodeConfTypeDef structure that contains the configuration information for the
  *                       specified DMA linked-list Node.
  * @param  pNode       : Pointer to a DMA_NodeTypeDef structure that contains linked-list node registers
  *                       configurations.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_List_GetNodeConfig(DMA_NodeConfTypeDef *const pNodeConfig,
                                               DMA_NodeTypeDef const *const pNode)
{
  /* Check the node configuration and physical node parameters */
  if ((pNodeConfig == NULL) || (pNode == NULL))
  {
    return HAL_ERROR;
  }

  /* Get the DMA channel node configuration */
  DMA_List_GetNodeConfig(pNodeConfig, pNode);

  return HAL_OK;
}

/**
  * @brief  Insert new node in any queue position of linked-list queue according to selecting previous node.
  * @param  pQList    : Pointer to a DMA_QListTypeDef structure that contains queue information.
  * @param  pPrevNode : Pointer to a DMA_NodeTypeDef structure that contains linked-list previous node registers
  *                     configurations.
  * @param  pNewNode  : Pointer to a DMA_NodeTypeDef structure that contains linked-list new node registers
  *                     configurations.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_List_InsertNode(DMA_QListTypeDef *const pQList,
                                            DMA_NodeTypeDef *const pPrevNode,
                                            DMA_NodeTypeDef *const pNewNode)
{
  uint32_t cllr_mask;
  uint32_t cllr_offset;
  DMA_NodeInQInfoTypeDef node_info;

  /* Check the queue and the new node parameters */
  if ((pQList == NULL) || (pNewNode == NULL))
  {
    return HAL_ERROR;
  }

  /* Check queue type */
  if (pQList->Type == QUEUE_TYPE_DYNAMIC)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Check nodes base addresses */
  if (DMA_List_CheckNodesBaseAddresses(pQList->Head, pPrevNode, pNewNode) != 0U)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_OUTOFRANGE;

    return HAL_ERROR;
  }

  /* Check nodes types compatibility */
  if (DMA_List_CheckNodesTypes(pQList->Head, pPrevNode, pNewNode) != 0U)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Update the queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_BUSY;

  /* Update the queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Get CLLR register mask and offset */
  DMA_List_GetCLLRNodeInfo(pNewNode, &cllr_mask, &cllr_offset);

  /* Empty queue */
  if (pQList->Head == NULL)
  {
    /* Add only new node to queue */
    if (pPrevNode == NULL)
    {
      pQList->Head       = pNewNode;
      pQList->NodeNumber = 1U;
    }
    /* Add previous node then new node to queue */
    else
    {
      pQList->Head                          = pPrevNode;
      pPrevNode->LinkRegisters[cllr_offset] = ((uint32_t)pNewNode & DMA_CLLR_LA) | cllr_mask;
      pQList->NodeNumber                    = 2U;
    }
  }
  /* Not empty queue */
  else
  {
    /* Add new node at the head of queue */
    if (pPrevNode == NULL)
    {
      pNewNode->LinkRegisters[cllr_offset] = ((uint32_t)pQList->Head & DMA_CLLR_LA) | cllr_mask;
      pQList->Head                         = pNewNode;
    }
    /* Add new node according to selected position */
    else
    {
      /* Find node and get its position in selected queue */
      node_info.cllr_offset = cllr_offset;
      if (DMA_List_FindNode(pQList, pPrevNode, &node_info) == 0U)
      {
        /* Selected node is the last queue node */
        if (node_info.currentnode_pos == pQList->NodeNumber)
        {
          /* Check if queue is circular */
          if (pQList->FirstCircularNode != NULL)
          {
            pNewNode->LinkRegisters[cllr_offset] = ((uint32_t)pQList->FirstCircularNode & DMA_CLLR_LA) | cllr_mask;
          }

          pPrevNode->LinkRegisters[cllr_offset] = ((uint32_t)pNewNode & DMA_CLLR_LA) | cllr_mask;
        }
        /* Selected node is not the last queue node */
        else
        {
          pNewNode->LinkRegisters[cllr_offset] = pPrevNode->LinkRegisters[cllr_offset];
          pPrevNode->LinkRegisters[cllr_offset] = ((uint32_t)pNewNode & DMA_CLLR_LA) | cllr_mask;
        }
      }
      else
      {
        /* Update the queue error code */
        pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NOTFOUND;

        return HAL_ERROR;
      }
    }

    /* Increment queue node number */
    pQList->NodeNumber++;
  }

  /* Update the queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Update the queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_READY;

  return HAL_OK;
}

/**
  * @brief  Insert new node at the head of linked-list queue.
  * @param  pQList    : Pointer to a DMA_QListTypeDef structure that contains queue information.
  * @param  pNewNode  : Pointer to a DMA_NodeTypeDef structure that contains linked-list new node registers
  *                     configurations.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_List_InsertNode_Head(DMA_QListTypeDef *const pQList,
                                                 DMA_NodeTypeDef *const pNewNode)
{
  uint32_t cllr_mask;
  uint32_t cllr_offset;

  /* Check the queue and the new node parameters */
  if ((pQList == NULL) || (pNewNode == NULL))
  {
    return HAL_ERROR;
  }

  /* Check queue type */
  if (pQList->Type == QUEUE_TYPE_DYNAMIC)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Check nodes base addresses */
  if (DMA_List_CheckNodesBaseAddresses(pQList->Head, pNewNode, NULL) != 0U)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_OUTOFRANGE;

    return HAL_ERROR;
  }

  /* Check nodes types compatibility */
  if (DMA_List_CheckNodesTypes(pQList->Head, pNewNode, NULL) != 0U)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Update the queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_BUSY;

  /* Update the queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Empty queue */
  if (pQList->Head == NULL)
  {
    pQList->Head = pNewNode;
  }
  /* Not empty queue */
  else
  {
    /* Get CLLR register mask and offset */
    DMA_List_GetCLLRNodeInfo(pNewNode, &cllr_mask, &cllr_offset);

    pNewNode->LinkRegisters[cllr_offset] = ((uint32_t)pQList->Head & DMA_CLLR_LA) | cllr_mask;
    pQList->Head                         = pNewNode;
  }

  /* Increment queue node number */
  pQList->NodeNumber++;

  /* Update the queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Update the queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_READY;

  return HAL_OK;
}

/**
  * @brief  Insert new node at the tail of linked-list queue.
  * @param  pQList    : Pointer to a DMA_QListTypeDef structure that contains queue information.
  * @param  pNewNode  : Pointer to a DMA_NodeTypeDef structure that contains linked-list new node registers
  *                     configurations.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_List_InsertNode_Tail(DMA_QListTypeDef *const pQList,
                                                 DMA_NodeTypeDef *const pNewNode)
{
  uint32_t cllr_mask;
  uint32_t cllr_offset;
  DMA_NodeInQInfoTypeDef node_info;

  /* Check the queue and the new node parameters */
  if ((pQList == NULL) || (pNewNode == NULL))
  {
    return HAL_ERROR;
  }

  /* Check queue type */
  if (pQList->Type == QUEUE_TYPE_DYNAMIC)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Check nodes base addresses */
  if (DMA_List_CheckNodesBaseAddresses(pQList->Head, pNewNode, NULL) != 0U)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_OUTOFRANGE;

    return HAL_ERROR;
  }

  /* Check nodes types compatibility */
  if (DMA_List_CheckNodesTypes(pQList->Head, pNewNode, NULL) != 0U)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Empty queue */
  if (pQList->Head == NULL)
  {
    pQList->Head = pNewNode;
  }
  /* Not empty queue */
  else
  {
    /* Get CLLR register mask and offset */
    DMA_List_GetCLLRNodeInfo(pNewNode, &cllr_mask, &cllr_offset);

    /* Find node and get its position in selected queue */
    node_info.cllr_offset = cllr_offset;
    (void)DMA_List_FindNode(pQList, NULL, &node_info);

    /* Check if queue is circular */
    if (pQList->FirstCircularNode != NULL)
    {
      pNewNode->LinkRegisters[cllr_offset] = ((uint32_t)pQList->FirstCircularNode & DMA_CLLR_LA) | cllr_mask;
    }

    ((DMA_NodeTypeDef *)node_info.currentnode_addr)->LinkRegisters[cllr_offset] =
      ((uint32_t)pNewNode & DMA_CLLR_LA) | cllr_mask;
  }

  /* Increment queue node number */
  pQList->NodeNumber++;

  /* Update the queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Update the queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_READY;

  /* Prevent MISRA-C2012-Rule-2.2_b */
  UNUSED(node_info);

  return HAL_OK;
}

/**
  * @brief  Remove node from any linked-list queue position.
  * @param  pQList : Pointer to a DMA_QListTypeDef structure that contains queue information.
  * @param  pNode  : Pointer to a DMA_NodeTypeDef structure that contains linked-list previous node registers
  *                  configurations.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_List_RemoveNode(DMA_QListTypeDef *const pQList,
                                            DMA_NodeTypeDef *const pNode)
{
  uint32_t previousnode_addr;
  uint32_t cllr_offset;
  DMA_NodeInQInfoTypeDef node_info;

  /* Check the queue and the node parameters */
  if ((pQList == NULL) || (pNode == NULL))
  {
    return HAL_ERROR;
  }

  /* Check the queue */
  if (pQList->Head == NULL)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_EMPTY;

    return HAL_ERROR;
  }

  /* Check queue type */
  if (pQList->Type == QUEUE_TYPE_DYNAMIC)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Update the queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_BUSY;

  /* Update the queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Get CLLR register mask and offset */
  DMA_List_GetCLLRNodeInfo(pNode, NULL, &cllr_offset);

  /* Find node and get its position in selected queue */
  node_info.cllr_offset = cllr_offset;
  if (DMA_List_FindNode(pQList, pNode, &node_info) == 0U)
  {
    /* Removed node is the head node */
    if (node_info.currentnode_pos == 1U)
    {
      /* Check if first circular node queue is the first node */
      if (pQList->FirstCircularNode == ((DMA_NodeTypeDef *)node_info.currentnode_addr))
      {
        /* Find last queue node */
        (void)DMA_List_FindNode(pQList, NULL, &node_info);

        /* Clear last node link */
        ((DMA_NodeTypeDef *)(node_info.currentnode_addr))->LinkRegisters[cllr_offset] = 0U;

        /* Clear first circular node */
        pQList->FirstCircularNode = NULL;
      }

      /* Update the queue head node */
      pQList->Head = (DMA_NodeTypeDef *)(((uint32_t)pQList->Head & DMA_CLBAR_LBA) +
                                         (pNode->LinkRegisters[cllr_offset] & DMA_CLLR_LA));
      /* Unlink node to be removed */
      pNode->LinkRegisters[cllr_offset] = 0U;
    }
    /* Removed node is the last node */
    else if (node_info.currentnode_pos == pQList->NodeNumber)
    {
      /* Clear CLLR for previous node */
      ((DMA_NodeTypeDef *)(node_info.previousnode_addr))->LinkRegisters[cllr_offset] = 0U;

      /* Clear CLLR for last node */
      ((DMA_NodeTypeDef *)(node_info.currentnode_addr))->LinkRegisters[cllr_offset] = 0U;

      /* Clear first circular node */
      pQList->FirstCircularNode = NULL;
    }
    /* Removed node is in the middle */
    else
    {
      /* Store previous node address to be updated later */
      previousnode_addr = node_info.previousnode_addr;

      /* Check if first circular node queue is the current node */
      if (pQList->FirstCircularNode == ((DMA_NodeTypeDef *)node_info.currentnode_addr))
      {
        /* Find last queue node */
        (void)DMA_List_FindNode(pQList, NULL, &node_info);

        /* Clear last node link */
        ((DMA_NodeTypeDef *)(node_info.currentnode_addr))->LinkRegisters[cllr_offset] = 0U;

        /* Clear first circular node */
        pQList->FirstCircularNode = NULL;
      }

      /* Link previous node */
      ((DMA_NodeTypeDef *)(previousnode_addr))->LinkRegisters[cllr_offset] = pNode->LinkRegisters[cllr_offset];

      /* Unlink node to be removed */
      pNode->LinkRegisters[cllr_offset] = 0U;
    }

    /* Decrement node number */
    pQList->NodeNumber--;
  }
  else
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NOTFOUND;

    return HAL_ERROR;
  }

  /* Check if queue is empty */
  if (pQList->NodeNumber == 0U)
  {
    /* Clean empty queue parameter */
    DMA_List_CleanQueue(pQList);
  }
  else
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

    /* Update the queue state */
    pQList->State = HAL_DMA_QUEUE_STATE_READY;
  }

  /* Prevent MISRA-C2012-Rule-2.2_b */
  UNUSED(node_info);

  return HAL_OK;
}

/**
  * @brief  Remove the head node from linked-list queue.
  * @param  pQList : Pointer to a DMA_QListTypeDef structure that contains queue information.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_List_RemoveNode_Head(DMA_QListTypeDef *const pQList)
{
  uint32_t cllr_offset;
  uint32_t current_addr;
  DMA_NodeInQInfoTypeDef node_info;

  /* Check the queue parameter */
  if (pQList == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the queue */
  if (pQList->Head == NULL)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_EMPTY;

    return HAL_ERROR;
  }

  /* Check queue type */
  if (pQList->Type == QUEUE_TYPE_DYNAMIC)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Update the queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_BUSY;

  /* Update the queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Get CLLR register mask and offset */
  DMA_List_GetCLLRNodeInfo(pQList->Head, NULL, &cllr_offset);

  /* Queue contains only one node */
  if (pQList->NodeNumber == 1U)
  {
    pQList->Head->LinkRegisters[cllr_offset] = 0U;
    pQList->FirstCircularNode = 0U;
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;
  }
  /* Queue contains more then one node */
  else
  {
    /* Check if first circular node queue is the first node */
    if (pQList->FirstCircularNode == pQList->Head)
    {
      /* Find last queue node */
      node_info.cllr_offset = cllr_offset;
      (void)DMA_List_FindNode(pQList, NULL, &node_info);

      /* Clear last node link */
      ((DMA_NodeTypeDef *)(node_info.currentnode_addr))->LinkRegisters[cllr_offset] = 0U;

      /* Clear first circular node */
      pQList->FirstCircularNode = NULL;
    }

    current_addr = pQList->Head->LinkRegisters[cllr_offset] & DMA_CLLR_LA;
    pQList->Head->LinkRegisters[cllr_offset] = 0U;
    pQList->Head = ((DMA_NodeTypeDef *)(current_addr + ((uint32_t)pQList->Head & DMA_CLBAR_LBA)));
  }

  /* Decrement node number */
  pQList->NodeNumber--;

  /* Check if queue is empty */
  if (pQList->NodeNumber == 0U)
  {
    /* Clean empty queue parameter */
    DMA_List_CleanQueue(pQList);
  }
  else
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

    /* Update the queue state */
    pQList->State = HAL_DMA_QUEUE_STATE_READY;
  }

  /* Prevent MISRA-C2012-Rule-2.2_b */
  UNUSED(node_info);

  return HAL_OK;
}

/**
  * @brief  Remove the tail node from linked-list queue.
  * @param  pQList : Pointer to a DMA_QListTypeDef structure that contains queue information.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_List_RemoveNode_Tail(DMA_QListTypeDef *const pQList)
{
  uint32_t cllr_offset;
  DMA_NodeInQInfoTypeDef node_info;

  /* Check the queue parameter */
  if (pQList == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the queue */
  if (pQList->Head == NULL)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_EMPTY;

    return HAL_ERROR;
  }

  /* Check queue type */
  if (pQList->Type == QUEUE_TYPE_DYNAMIC)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Update the queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_BUSY;

  /* Update the queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Get CLLR register mask and offset */
  DMA_List_GetCLLRNodeInfo(pQList->Head, NULL, &cllr_offset);

  /* Queue contains only one node */
  if (pQList->NodeNumber == 1U)
  {
    pQList->Head->LinkRegisters[cllr_offset] = 0U;
    pQList->FirstCircularNode = 0U;
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;
  }
  /* Queue contains more then one node */
  else
  {
    /* Find node and get its position in selected queue */
    node_info.cllr_offset = cllr_offset;
    (void)DMA_List_FindNode(pQList, NULL, &node_info);

    /* Clear CLLR for previous node */
    ((DMA_NodeTypeDef *)(node_info.previousnode_addr))->LinkRegisters[cllr_offset] = 0U;

    /* Clear CLLR for last node */
    ((DMA_NodeTypeDef *)(node_info.currentnode_addr))->LinkRegisters[cllr_offset] = 0U;

    /* Clear first circular node */
    pQList->FirstCircularNode = NULL;
  }

  /* Decrement node number */
  pQList->NodeNumber--;

  /* Check if queue is empty */
  if (pQList->NodeNumber == 0U)
  {
    /* Clean empty queue parameter */
    DMA_List_CleanQueue(pQList);
  }
  else
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

    /* Update the queue state */
    pQList->State = HAL_DMA_QUEUE_STATE_READY;
  }

  /* Prevent MISRA-C2012-Rule-2.2_b */
  UNUSED(node_info);

  return HAL_OK;
}

/**
  * @brief  Replace node in linked-list queue.
  * @param  pQList   : Pointer to a DMA_QListTypeDef structure that contains queue information.
  * @param  pOldNode : Pointer to a DMA_NodeTypeDef structure that contains linked-list old node registers
  *                    configurations.
  * @param  pNewNode : Pointer to a DMA_NodeTypeDef structure that contains linked-list new node registers
  *                    configurations.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_List_ReplaceNode(DMA_QListTypeDef *const pQList,
                                             DMA_NodeTypeDef *const pOldNode,
                                             DMA_NodeTypeDef *const pNewNode)
{
  uint32_t cllr_mask;
  uint32_t cllr_offset;
  DMA_NodeInQInfoTypeDef node_info;

  /* Check the queue and the nodes parameters */
  if ((pQList == NULL) || (pOldNode == NULL) || (pNewNode == NULL))
  {
    return HAL_ERROR;
  }

  /* Check the queue */
  if (pQList->Head == NULL)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_EMPTY;

    return HAL_ERROR;
  }

  /* Check queue type */
  if (pQList->Type == QUEUE_TYPE_DYNAMIC)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Check nodes base addresses */
  if (DMA_List_CheckNodesBaseAddresses(pQList->Head, pOldNode, pNewNode) != 0U)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_OUTOFRANGE;

    return HAL_ERROR;
  }

  /* Check nodes types compatibility */
  if (DMA_List_CheckNodesTypes(pQList->Head, pOldNode, pNewNode) != 0U)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Update the queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_BUSY;

  /* Update the queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Get CLLR register mask and offset */
  DMA_List_GetCLLRNodeInfo(pNewNode, &cllr_mask, &cllr_offset);

  /* Find node and get its position in selected queue */
  node_info.cllr_offset = cllr_offset;
  if (DMA_List_FindNode(pQList, pOldNode, &node_info) == 0U)
  {
    /* Replaced node is the head node */
    if (node_info.currentnode_pos == 1U)
    {
      pNewNode->LinkRegisters[cllr_offset] =
        ((DMA_NodeTypeDef *)(node_info.currentnode_addr))->LinkRegisters[cllr_offset];
      pQList->Head = pNewNode;
      ((DMA_NodeTypeDef *)(node_info.currentnode_addr))->LinkRegisters[cllr_offset] = 0U;

      /* Check if first circular node queue is the first node */
      if (pQList->FirstCircularNode == ((DMA_NodeTypeDef *)node_info.currentnode_addr))
      {
        /* Find last queue node */
        (void)DMA_List_FindNode(pQList, NULL, &node_info);

        /* Clear last node link */
        ((DMA_NodeTypeDef *)(node_info.currentnode_addr))->LinkRegisters[cllr_offset] =
          ((uint32_t)pNewNode & DMA_CLLR_LA) | cllr_mask;

        /* Set new node as first circular node */
        pQList->FirstCircularNode = pNewNode;
      }
    }
    /* Replaced node is the last */
    else if (node_info.currentnode_pos == pQList->NodeNumber)
    {
      ((DMA_NodeTypeDef *)(node_info.previousnode_addr))->LinkRegisters[cllr_offset] =
        ((uint32_t)pNewNode & DMA_CLLR_LA) | cllr_mask;
      ((DMA_NodeTypeDef *)(node_info.currentnode_addr))->LinkRegisters[cllr_offset] = 0U;

      /* Check if first circular node queue is the last node */
      if (pQList->FirstCircularNode == ((DMA_NodeTypeDef *)(node_info.currentnode_addr)))
      {
        /* Link first circular node to new node */
        pNewNode->LinkRegisters[cllr_offset] = ((uint32_t)pNewNode & DMA_CLLR_LA) | cllr_mask;

        /* Set new node as first circular node */
        pQList->FirstCircularNode = pNewNode;
      }
      /* Check if first circular node queue is not the last node */
      else if (pQList->FirstCircularNode != NULL)
      {
        /* Link first circular node to new node */
        pNewNode->LinkRegisters[cllr_offset] = ((uint32_t)pQList->FirstCircularNode & DMA_CLLR_LA) | cllr_mask;
      }
      else
      {
        /* Prevent MISRA-C2012-Rule-15.7 */
      }
    }
    /* Replaced node is in the middle */
    else
    {
      ((DMA_NodeTypeDef *)(node_info.previousnode_addr))->LinkRegisters[cllr_offset] =
        ((uint32_t)pNewNode & DMA_CLLR_LA) | cllr_mask;
      pNewNode->LinkRegisters[cllr_offset] =
        ((DMA_NodeTypeDef *)(node_info.currentnode_addr))->LinkRegisters[cllr_offset];
      ((DMA_NodeTypeDef *)(node_info.currentnode_addr))->LinkRegisters[cllr_offset] = 0U;

      /* Check if first circular node queue is the current node */
      if (pQList->FirstCircularNode == ((DMA_NodeTypeDef *)(node_info.currentnode_addr)))
      {
        /* Find last node and get its position in selected queue */
        (void)DMA_List_FindNode(pQList, NULL, &node_info);

        /* Link last queue node to new node */
        ((DMA_NodeTypeDef *)(node_info.currentnode_addr))->LinkRegisters[cllr_offset] =
          ((uint32_t)pNewNode & DMA_CLLR_LA) | cllr_mask;

        /* Set new node as first circular node */
        pQList->FirstCircularNode = pNewNode;
      }
    }
  }
  else
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NOTFOUND;

    return HAL_ERROR;
  }

  /* Update the queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Update the queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_READY;

  /* Prevent MISRA-C2012-Rule-2.2_b */
  UNUSED(node_info);

  return HAL_OK;
}

/**
  * @brief  Replace the head node of linked-list queue.
  * @param  pQList   : Pointer to a DMA_QListTypeDef structure that contains queue information.
  * @param  pNewNode : Pointer to a DMA_NodeTypeDef structure that contains linked-list new node registers
  *                    configurations.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_List_ReplaceNode_Head(DMA_QListTypeDef *const pQList,
                                                  DMA_NodeTypeDef *const pNewNode)
{
  uint32_t cllr_offset;
  uint32_t cllr_mask;
  DMA_NodeInQInfoTypeDef node_info;

  /* Check the queue and the new node parameters */
  if ((pQList == NULL) || (pNewNode == NULL))
  {
    return HAL_ERROR;
  }

  /* Check the queue */
  if (pQList->Head == NULL)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_EMPTY;

    return HAL_ERROR;
  }

  /* Check queue type */
  if (pQList->Type == QUEUE_TYPE_DYNAMIC)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Check nodes base addresses */
  if (DMA_List_CheckNodesBaseAddresses(pQList->Head, pNewNode, NULL) != 0U)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_OUTOFRANGE;

    return HAL_ERROR;
  }

  /* Check nodes types compatibility */
  if (DMA_List_CheckNodesTypes(pQList->Head, pNewNode, NULL) != 0U)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Update the queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_BUSY;

  /* Update the queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Get CLLR register mask and offset */
  DMA_List_GetCLLRNodeInfo(pNewNode, &cllr_mask, &cllr_offset);

  /* Check if first circular node queue is the first node */
  if (pQList->FirstCircularNode == pQList->Head)
  {
    /* Find last queue node */
    node_info.cllr_offset = cllr_offset;
    (void)DMA_List_FindNode(pQList, NULL, &node_info);

    /* Clear last node link */
    ((DMA_NodeTypeDef *)(node_info.currentnode_addr))->LinkRegisters[cllr_offset] =
      ((uint32_t)pNewNode & DMA_CLLR_LA) | cllr_mask;

    /* Set new node as first circular node */
    pQList->FirstCircularNode = pNewNode;
  }

  /* Replace head node */
  pNewNode->LinkRegisters[cllr_offset] = pQList->Head->LinkRegisters[cllr_offset];
  pQList->Head->LinkRegisters[cllr_offset] = 0U;
  pQList->Head = pNewNode;

  /* Update the queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Update the queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_READY;

  /* Prevent MISRA-C2012-Rule-2.2_b */
  UNUSED(node_info);

  return HAL_OK;
}

/**
  * @brief  Replace the tail node of linked-list queue.
  * @param  pQList   : Pointer to a DMA_QListTypeDef structure that contains queue information.
  * @param  pNewNode : Pointer to a DMA_NodeTypeDef structure that contains linked-list new node registers
  *                    configurations.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_List_ReplaceNode_Tail(DMA_QListTypeDef *const pQList,
                                                  DMA_NodeTypeDef *const pNewNode)
{
  uint32_t cllr_mask;
  uint32_t cllr_offset;
  DMA_NodeInQInfoTypeDef node_info;

  /* Check the queue and the new node parameters */
  if ((pQList == NULL) || (pNewNode == NULL))
  {
    return HAL_ERROR;
  }

  /* Check the queue */
  if (pQList->Head == NULL)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_EMPTY;

    return HAL_ERROR;
  }

  /* Check queue type */
  if (pQList->Type == QUEUE_TYPE_DYNAMIC)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Update the queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_BUSY;

  /* Update the queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Get CLLR register mask and offset */
  DMA_List_GetCLLRNodeInfo(pNewNode, &cllr_mask, &cllr_offset);

  /* Find last node and get its position in selected queue */
  node_info.cllr_offset = cllr_offset;
  (void)DMA_List_FindNode(pQList, NULL, &node_info);

  /* Link previous node to new node */
  ((DMA_NodeTypeDef *)(node_info.previousnode_addr))->LinkRegisters[cllr_offset] =
    ((uint32_t)pNewNode & DMA_CLLR_LA) | cllr_mask;

  /* Clear CLLR for current node */
  ((DMA_NodeTypeDef *)(node_info.currentnode_addr))->LinkRegisters[cllr_offset] = 0U;

  /* Check if first circular node queue is the last node */
  if (pQList->FirstCircularNode == ((DMA_NodeTypeDef *)(node_info.currentnode_addr)))
  {
    /* Link first circular node to new node */
    pNewNode->LinkRegisters[cllr_offset] = ((uint32_t)pNewNode & DMA_CLLR_LA) | cllr_mask;

    /* Set new node as first circular node */
    pQList->FirstCircularNode = pNewNode;
  }
  /* Check if first circular node queue is not the last node */
  else if (pQList->FirstCircularNode != NULL)
  {
    /* Link first circular node to new node */
    pNewNode->LinkRegisters[cllr_offset] = ((uint32_t)pQList->FirstCircularNode & DMA_CLLR_LA) | cllr_mask;
  }
  else
  {
    /* Prevent MISRA-C2012-Rule-15.7 */
  }

  /* Check if queue contains one node */
  if (pQList->NodeNumber == 1U)
  {
    pQList->Head = pNewNode;
  }

  /* Update the queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Update the queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_READY;

  return HAL_OK;
}

/**
  * @brief  Reset the linked-list queue and unlink queue nodes.
  * @param  pQList : Pointer to a DMA_QListTypeDef structure that contains queue information.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_List_ResetQ(DMA_QListTypeDef *const pQList)
{
  uint32_t cllr_offset;
  DMA_NodeInQInfoTypeDef node_info;

  /* Check the queue parameter */
  if (pQList == NULL)
  {
    return HAL_ERROR;
  }

  /* Check queue state */
  if (pQList->State == HAL_DMA_QUEUE_STATE_BUSY)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_BUSY;

    return HAL_ERROR;
  }

  /* Check queue type */
  if (pQList->Type == QUEUE_TYPE_DYNAMIC)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Update the queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_BUSY;

  /* Update the queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Check the queue */
  if (pQList->Head != NULL)
  {
    /* Get CLLR register mask and offset */
    DMA_List_GetCLLRNodeInfo(pQList->Head, NULL, &cllr_offset);

    /* Reset selected queue nodes */
    node_info.cllr_offset = cllr_offset;
    DMA_List_ResetQueueNodes(pQList, &node_info);
  }

  /* Reset head node address */
  pQList->Head = NULL;

  /* Reset node number */
  pQList->NodeNumber = 0U;

  /* Reset first circular node */
  pQList->FirstCircularNode = NULL;

  /* Update the queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Update the queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_RESET;

  return HAL_OK;
}

/**
  * @brief  Insert a source linked-list queue to a destination linked-list queue according to selecting previous node.
  * @param  pSrcQList  : Pointer to a DMA_QListTypeDef structure that contains source queue information.
  * @param  pPrevNode  : Pointer to a DMA_NodeTypeDef structure that contains linked-list previous node registers
  *                      configurations.
  * @param  pDestQList : Pointer to a DMA_QListTypeDef structure that contains destination queue information.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_List_InsertQ(DMA_QListTypeDef *const pSrcQList,
                                         DMA_NodeTypeDef const *const pPrevNode,
                                         DMA_QListTypeDef *const pDestQList)
{
  uint32_t cllr_mask;
  uint32_t cllr_offset;
  DMA_NodeInQInfoTypeDef src_q_node_info;
  DMA_NodeInQInfoTypeDef dest_q_node_info;

  /* Check the source and destination queues and the previous node parameters */
  if ((pSrcQList == NULL) || (pDestQList == NULL))
  {
    return HAL_ERROR;
  }

  /* Check the source queue */
  if (pSrcQList->Head == NULL)
  {
    /* Update the queue error code */
    pSrcQList->ErrorCode = HAL_DMA_QUEUE_ERROR_EMPTY;

    return HAL_ERROR;
  }

  /* Check the source queue type */
  if (pSrcQList->Type == QUEUE_TYPE_DYNAMIC)
  {
    /* Update the queue error code */
    pSrcQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Check the destination queue type */
  if (pDestQList->Type == QUEUE_TYPE_DYNAMIC)
  {
    /* Update the queue error code */
    pDestQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Check the source queue circularity */
  if (pSrcQList->FirstCircularNode != NULL)
  {
    /* Update the source queue error code */
    pSrcQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Check nodes base addresses */
  if (DMA_List_CheckNodesBaseAddresses(pSrcQList->Head, pPrevNode, pDestQList->Head) != 0U)
  {
    /* Update the source queue error code */
    pSrcQList->ErrorCode = HAL_DMA_QUEUE_ERROR_OUTOFRANGE;

    /* Update the destination queue error code */
    pDestQList->ErrorCode = HAL_DMA_QUEUE_ERROR_OUTOFRANGE;

    return HAL_ERROR;
  }

  /* Check nodes types compatibility */
  if (DMA_List_CheckNodesTypes(pSrcQList->Head, pPrevNode, pDestQList->Head) != 0U)
  {
    /* Update the source queue error code */
    pSrcQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    /* Update the destination queue error code */
    pDestQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Update the source queue state */
  pSrcQList->State = HAL_DMA_QUEUE_STATE_BUSY;

  /* Update the source queue error code */
  pSrcQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Update the destination queue state */
  pDestQList->State = HAL_DMA_QUEUE_STATE_BUSY;

  /* Update the destination queue error code */
  pDestQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Get CLLR register mask and offset */
  DMA_List_GetCLLRNodeInfo(pSrcQList->Head, &cllr_mask, &cllr_offset);

  /* Empty destination queue */
  if (pDestQList->Head == NULL)
  {
    pDestQList->Head       = pSrcQList->Head;
    pDestQList->NodeNumber = pSrcQList->NodeNumber;
  }
  /* Not empty destination queue */
  else
  {
    /* Previous node is empty */
    if (pPrevNode == NULL)
    {
      /* Find node and get its position in selected queue */
      src_q_node_info.cllr_offset = cllr_offset;
      (void)DMA_List_FindNode(pSrcQList, NULL, &src_q_node_info);

      /* Check if first circular node queue is the first node */
      if (pDestQList->FirstCircularNode == pDestQList->Head)
      {
        /* Find node and get its position in selected queue */
        dest_q_node_info.cllr_offset = cllr_offset;
        (void)DMA_List_FindNode(pDestQList, NULL, &dest_q_node_info);

        /* Link destination queue tail node to new first circular node */
        ((DMA_NodeTypeDef *)dest_q_node_info.currentnode_addr)->LinkRegisters[cllr_offset] =
          ((uint32_t)pSrcQList->Head & DMA_CLLR_LA) | cllr_mask;

        /* Set the head node of source queue as the first circular node */
        pDestQList->FirstCircularNode = pSrcQList->Head;
      }

      /* Link the last node of source queue to the fist node of destination queue */
      ((DMA_NodeTypeDef *)(src_q_node_info.currentnode_addr))->LinkRegisters[cllr_offset] =
        ((uint32_t)pDestQList->Head & DMA_CLLR_LA) | cllr_mask;
      pDestQList->Head        = pSrcQList->Head;
      pDestQList->NodeNumber += pSrcQList->NodeNumber;
    }
    /* Previous node is not empty */
    else
    {
      /* Find node and get its position in selected queue */
      dest_q_node_info.cllr_offset = cllr_offset;
      if (DMA_List_FindNode(pDestQList, pPrevNode, &dest_q_node_info) == 0U)
      {
        /* Selected node is the last destination queue node */
        if (dest_q_node_info.currentnode_pos == pDestQList->NodeNumber)
        {
          /* Link the first node of source queue to the last node of destination queue */
          ((DMA_NodeTypeDef *)(dest_q_node_info.currentnode_addr))->LinkRegisters[cllr_offset] =
            ((uint32_t)pSrcQList->Head & DMA_CLLR_LA) | cllr_mask;
          pDestQList->NodeNumber += pSrcQList->NodeNumber;

          /* Check if first circular node queue is not empty */
          if (pDestQList->FirstCircularNode != NULL)
          {
            /* Find node and get its position in selected queue */
            src_q_node_info.cllr_offset = cllr_offset;
            (void)DMA_List_FindNode(pSrcQList, NULL, &src_q_node_info);

            /* Find first circular node */
            (void)DMA_List_FindNode(pDestQList, pDestQList->FirstCircularNode, &dest_q_node_info);

            /* Link last source queue node to first destination queue */
            ((DMA_NodeTypeDef *)src_q_node_info.currentnode_addr)->LinkRegisters[cllr_offset] =
              (dest_q_node_info.currentnode_addr & DMA_CLLR_LA) | cllr_mask;
          }
        }
        /* Selected node is not the last destination queue node */
        else
        {
          /* Link the first node of source queue to the previous node of destination queue */
          ((DMA_NodeTypeDef *)(dest_q_node_info.currentnode_addr))->LinkRegisters[cllr_offset] =
            ((uint32_t)pSrcQList->Head & DMA_CLLR_LA) | cllr_mask;

          /* Find node and get its position in selected queue */
          src_q_node_info.cllr_offset = cllr_offset;
          (void)DMA_List_FindNode(pSrcQList, NULL, &src_q_node_info);

          /* Link the last node of source queue to the next node of destination queue */
          ((DMA_NodeTypeDef *)(src_q_node_info.currentnode_addr))->LinkRegisters[cllr_offset] =
            (dest_q_node_info.nextnode_addr & DMA_CLLR_LA) | cllr_mask;

          /* Update queues counter */
          pDestQList->NodeNumber += pSrcQList->NodeNumber;
        }
      }
      else
      {
        /* Update the destination queue error code */
        pDestQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NOTFOUND;

        return HAL_ERROR;
      }
    }
  }

  /* Clean the source queue variable as it is obsolete */
  DMA_List_CleanQueue(pSrcQList);

  /* Update the destination queue error code */
  pDestQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Update the destination queue state */
  pDestQList->State = HAL_DMA_QUEUE_STATE_READY;

  /* Prevent MISRA-C2012-Rule-2.2_b */
  UNUSED(src_q_node_info);
  UNUSED(dest_q_node_info);

  return HAL_OK;
}

/**
  * @brief  Insert a source linked-list queue at the head of destination queue.
  * @param  pSrcQList  : Pointer to a DMA_QListTypeDef structure that contains source queue information.
  * @param  pDestQList : Pointer to a DMA_QListTypeDef structure that contains destination queue information.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_List_InsertQ_Head(DMA_QListTypeDef *const pSrcQList,
                                              DMA_QListTypeDef *const pDestQList)
{
  uint32_t cllr_mask;
  uint32_t cllr_offset;
  DMA_NodeInQInfoTypeDef src_q_node_info;
  DMA_NodeInQInfoTypeDef dest_q_node_info;

  /* Check the source and destination queues and the previous node parameters */
  if ((pSrcQList == NULL) || (pDestQList == NULL))
  {
    return HAL_ERROR;
  }

  /* Check the source queue */
  if (pSrcQList->Head == NULL)
  {
    /* Update the queue error code */
    pSrcQList->ErrorCode = HAL_DMA_QUEUE_ERROR_EMPTY;

    return HAL_ERROR;
  }

  /* Check the source queue type */
  if (pSrcQList->Type == QUEUE_TYPE_DYNAMIC)
  {
    /* Update the queue error code */
    pSrcQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Check the destination queue type */
  if (pDestQList->Type == QUEUE_TYPE_DYNAMIC)
  {
    /* Update the queue error code */
    pDestQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Check nodes base addresses */
  if (DMA_List_CheckNodesBaseAddresses(pSrcQList->Head, pDestQList->Head, NULL) != 0U)
  {
    /* Update the source queue error code */
    pSrcQList->ErrorCode = HAL_DMA_QUEUE_ERROR_OUTOFRANGE;

    /* Update the destination queue error code */
    pDestQList->ErrorCode = HAL_DMA_QUEUE_ERROR_OUTOFRANGE;

    return HAL_ERROR;
  }

  /* Check nodes types compatibility */
  if (DMA_List_CheckNodesTypes(pSrcQList->Head, pDestQList->Head, NULL) != 0U)
  {
    /* Update the source queue error code */
    pSrcQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    /* Update the destination queue error code */
    pDestQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Update the source queue state */
  pSrcQList->State = HAL_DMA_QUEUE_STATE_BUSY;

  /* Update the source queue error code */
  pSrcQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Update the destination queue state */
  pDestQList->State = HAL_DMA_QUEUE_STATE_BUSY;

  /* Update the destination queue error code */
  pDestQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Get CLLR register mask and offset */
  DMA_List_GetCLLRNodeInfo(pSrcQList->Head, &cllr_mask, &cllr_offset);

  /* Empty destination queue */
  if (pDestQList->Head == NULL)
  {
    pDestQList->Head       = pSrcQList->Head;
    pDestQList->NodeNumber = pSrcQList->NodeNumber;
  }
  /* Not empty destination queue */
  else
  {
    /* Find node and get its position in selected queue */
    src_q_node_info.cllr_offset = cllr_offset;
    (void)DMA_List_FindNode(pSrcQList, NULL, &src_q_node_info);

    /* Check if first circular node queue is the first node */
    if (pDestQList->FirstCircularNode == pDestQList->Head)
    {
      /* Find node and get its position in selected queue */
      dest_q_node_info.cllr_offset = cllr_offset;
      (void)DMA_List_FindNode(pDestQList, NULL, &dest_q_node_info);

      /* Link destination queue tail node to new first circular node */
      ((DMA_NodeTypeDef *)dest_q_node_info.currentnode_addr)->LinkRegisters[cllr_offset] =
        ((uint32_t)pSrcQList->Head & DMA_CLLR_LA) | cllr_mask;

      /* Set the head node of source queue as the first circular node */
      pDestQList->FirstCircularNode = pSrcQList->Head;
    }

    /* Link the last node of source queue to the fist node of destination queue */
    ((DMA_NodeTypeDef *)(src_q_node_info.currentnode_addr))->LinkRegisters[cllr_offset] =
      ((uint32_t)pDestQList->Head & DMA_CLLR_LA) | cllr_mask;
    pDestQList->Head        = pSrcQList->Head;
    pDestQList->NodeNumber += pSrcQList->NodeNumber;
  }

  /* Clean the source queue variable as it is obsolete */
  DMA_List_CleanQueue(pSrcQList);

  /* Update the destination queue error code */
  pDestQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Update the destination queue state */
  pDestQList->State = HAL_DMA_QUEUE_STATE_READY;

  /* Prevent MISRA-C2012-Rule-2.2_b */
  UNUSED(src_q_node_info);
  UNUSED(dest_q_node_info);

  return HAL_OK;
}

/**
  * @brief  Insert a source linked-list queue at the tail of destination queue.
  * @param  pSrcQList  : Pointer to a DMA_QListTypeDef structure that contains source queue information.
  * @param  pDestQList : Pointer to a DMA_QListTypeDef structure that contains destination queue information.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_List_InsertQ_Tail(DMA_QListTypeDef *const pSrcQList,
                                              DMA_QListTypeDef *const pDestQList)
{
  uint32_t cllr_mask;
  uint32_t cllr_offset;
  DMA_NodeInQInfoTypeDef src_q_node_info;
  DMA_NodeInQInfoTypeDef dest_q_node_info;

  /* Check the source and destination queues and the previous node parameters */
  if ((pSrcQList == NULL) || (pDestQList == NULL))
  {
    return HAL_ERROR;
  }

  /* Check the source queue */
  if (pSrcQList->Head == NULL)
  {
    /* Update the queue error code */
    pSrcQList->ErrorCode = HAL_DMA_QUEUE_ERROR_EMPTY;

    return HAL_ERROR;
  }

  /* Check the source queue type */
  if (pSrcQList->Type == QUEUE_TYPE_DYNAMIC)
  {
    /* Update the queue error code */
    pSrcQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Check the destination queue type */
  if (pDestQList->Type == QUEUE_TYPE_DYNAMIC)
  {
    /* Update the queue error code */
    pDestQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Check nodes base addresses */
  if (DMA_List_CheckNodesBaseAddresses(pSrcQList->Head, pDestQList->Head, NULL) != 0U)
  {
    /* Update the source queue error code */
    pSrcQList->ErrorCode = HAL_DMA_QUEUE_ERROR_OUTOFRANGE;

    /* Update the destination queue error code */
    pDestQList->ErrorCode = HAL_DMA_QUEUE_ERROR_OUTOFRANGE;

    return HAL_ERROR;
  }

  /* Check nodes types compatibility */
  if (DMA_List_CheckNodesTypes(pSrcQList->Head, pDestQList->Head, NULL) != 0U)
  {
    /* Update the source queue error code */
    pSrcQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    /* Update the destination queue error code */
    pDestQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Update the source queue state */
  pSrcQList->State = HAL_DMA_QUEUE_STATE_BUSY;

  /* Update the source queue error code */
  pSrcQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Update the destination queue state */
  pDestQList->State = HAL_DMA_QUEUE_STATE_BUSY;

  /* Update the destination queue error code */
  pDestQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Get CLLR register mask and offset */
  DMA_List_GetCLLRNodeInfo(pSrcQList->Head, &cllr_mask, &cllr_offset);

  /* Empty destination queue */
  if (pDestQList->Head == NULL)
  {
    pDestQList->Head       = pSrcQList->Head;
    pDestQList->NodeNumber = pSrcQList->NodeNumber;
  }
  /* Not empty destination queue */
  else
  {
    /* Find node and get its position in selected queue */
    dest_q_node_info.cllr_offset = cllr_offset;
    (void)DMA_List_FindNode(pDestQList, NULL, &dest_q_node_info);

    /* Update source queue last node CLLR to link it with destination first node */
    ((DMA_NodeTypeDef *)(dest_q_node_info.currentnode_addr))->LinkRegisters[cllr_offset] =
      ((uint32_t)pSrcQList->Head & DMA_CLLR_LA) | cllr_mask;
    pDestQList->NodeNumber += pSrcQList->NodeNumber;

    /* Check if first circular node queue is not empty */
    if (pDestQList->FirstCircularNode != NULL)
    {
      /* Find node and get its position in selected queue */
      src_q_node_info.cllr_offset = cllr_offset;
      (void)DMA_List_FindNode(pSrcQList, NULL, &src_q_node_info);

      /* Find first circular node */
      (void)DMA_List_FindNode(pDestQList, pDestQList->FirstCircularNode, &dest_q_node_info);

      /* Link last source queue node to first destination queue */
      ((DMA_NodeTypeDef *)src_q_node_info.currentnode_addr)->LinkRegisters[cllr_offset] =
        (dest_q_node_info.currentnode_addr & DMA_CLLR_LA) | cllr_mask;
    }
  }

  /* Clean the source queue variable as it is obsolete */
  DMA_List_CleanQueue(pSrcQList);

  /* Update the destination queue error code */
  pDestQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Update the destination queue state */
  pDestQList->State = HAL_DMA_QUEUE_STATE_READY;

  /* Prevent MISRA-C2012-Rule-2.2_b */
  UNUSED(src_q_node_info);

  return HAL_OK;
}

/**
  * @brief  Set circular mode configuration for linked-list queue.
  * @param  pQList             : Pointer to a DMA_QListTypeDef structure that contains queue information.
  * @param  pFirstCircularNode : Pointer to a DMA_NodeTypeDef structure that contains linked-list first circular node
  *                              registers configurations.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_List_SetCircularModeConfig(DMA_QListTypeDef *const pQList,
                                                       DMA_NodeTypeDef *const pFirstCircularNode)
{
  uint32_t cllr_mask;
  uint32_t cllr_offset;
  DMA_NodeInQInfoTypeDef node_info;

  /* Check the queue and the first circular node parameters */
  if ((pQList == NULL) || (pFirstCircularNode == NULL))
  {
    return HAL_ERROR;
  }

  /* Check the queue */
  if (pQList->Head == NULL)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_EMPTY;

    return HAL_ERROR;
  }

  /* Check queue circular mode */
  if (pQList->FirstCircularNode != NULL)
  {
    if (pQList->FirstCircularNode == pFirstCircularNode)
    {
      return HAL_OK;
    }
    else
    {
      /* Update the queue error code */
      pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

      return HAL_ERROR;
    }
  }

  /* Check queue type */
  if (pQList->Type == QUEUE_TYPE_DYNAMIC)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Update the queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_BUSY;

  /* Update the queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Get CLLR register mask and offset */
  DMA_List_GetCLLRNodeInfo(pFirstCircularNode, &cllr_mask, &cllr_offset);

  /* Find the first circular node and get its position in selected queue */
  node_info.cllr_offset = cllr_offset;
  if (DMA_List_FindNode(pQList, pFirstCircularNode, &node_info) == 0U)
  {
    /* Find the last queue node and get its position in selected queue */
    (void)DMA_List_FindNode(pQList, NULL, &node_info);

    /* Set circular mode */
    ((DMA_NodeTypeDef *)(node_info.currentnode_addr))->LinkRegisters[cllr_offset] =
      ((uint32_t)pFirstCircularNode & DMA_CLLR_LA) | cllr_mask;

    /* Update first circular node in queue */
    pQList->FirstCircularNode = pFirstCircularNode;
  }
  else
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NOTFOUND;

    return HAL_ERROR;
  }

  /* Update the queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Update the queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_READY;

  /* Prevent MISRA-C2012-Rule-2.2_b */
  UNUSED(node_info);

  return HAL_OK;
}

/**
  * @brief  Set circular mode for linked-list queue.
  * @param  pQList : Pointer to a DMA_QListTypeDef structure that contains queue information.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_List_SetCircularMode(DMA_QListTypeDef *const pQList)
{
  uint32_t cllr_mask;
  uint32_t cllr_offset;
  DMA_NodeInQInfoTypeDef node_info;

  /* Check the queue parameter */
  if (pQList == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the queue */
  if (pQList->Head == NULL)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_EMPTY;

    return HAL_ERROR;
  }

  /* Check queue circular mode */
  if (pQList->FirstCircularNode != NULL)
  {
    if (pQList->FirstCircularNode == pQList->Head)
    {
      return HAL_OK;
    }
    else
    {
      /* Update the queue error code */
      pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

      return HAL_ERROR;
    }
  }

  /* Check queue type */
  if (pQList->Type == QUEUE_TYPE_DYNAMIC)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Update the queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_BUSY;

  /* Update the queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Get CLLR register mask and offset */
  DMA_List_GetCLLRNodeInfo(pQList->Head, &cllr_mask, &cllr_offset);

  /* Find the last queue node and get its position in selected queue */
  node_info.cllr_offset = cllr_offset;
  (void)DMA_List_FindNode(pQList, NULL, &node_info);

  /* Set circular mode */
  ((DMA_NodeTypeDef *)(node_info.currentnode_addr))->LinkRegisters[cllr_offset] =
    ((uint32_t)pQList->Head & DMA_CLLR_LA) | cllr_mask;

  /* Update linked-list circular state */
  pQList->FirstCircularNode = pQList->Head;

  /* Update the queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Update the queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_READY;

  /* Prevent MISRA-C2012-Rule-2.2_b */
  UNUSED(node_info);

  return HAL_OK;
}

/**
  * @brief  Clear circular mode for linked-list queue.
  * @param  pQList : Pointer to a DMA_QListTypeDef structure that contains queue information.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_List_ClearCircularMode(DMA_QListTypeDef *const pQList)
{
  uint32_t cllr_offset;
  DMA_NodeInQInfoTypeDef node_info;

  /* Check the queue parameter */
  if (pQList == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the queue */
  if (pQList->Head == NULL)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_EMPTY;

    return HAL_ERROR;
  }

  /* Check queue circular mode */
  if (pQList->FirstCircularNode == NULL)
  {
    return HAL_OK;
  }

  /* Check queue type */
  if (pQList->Type == QUEUE_TYPE_DYNAMIC)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

    return HAL_ERROR;
  }

  /* Update the queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_BUSY;

  /* Update the queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Get CLLR register offset */
  DMA_List_GetCLLRNodeInfo(pQList->Head, NULL, &cllr_offset);

  /* Find the last queue node and get its position in selected queue */
  node_info.cllr_offset = cllr_offset;
  (void)DMA_List_FindNode(pQList, NULL, &node_info);

  /* Clear circular mode */
  ((DMA_NodeTypeDef *)(node_info.currentnode_addr))->LinkRegisters[cllr_offset] = 0U;

  /* Update linked-list circular configuration */
  pQList->FirstCircularNode = NULL;

  /* Update the queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Update the queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_READY;

  /* Prevent MISRA-C2012-Rule-2.2_b */
  UNUSED(node_info);

  return HAL_OK;
}

/**
  * @brief  Convert a linked-list queue to dynamic (Optimized DMA queue execution).
  * @param  pQList : Pointer to a DMA_QListTypeDef structure that contains queue information.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_List_ConvertQToDynamic(DMA_QListTypeDef *const pQList)
{
  uint32_t cllr_offset;
  uint32_t currentnode_addr;
  DMA_NodeTypeDef context_node;
  DMA_NodeInQInfoTypeDef node_info;

  /* Check the queue parameter */
  if (pQList == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the queue */
  if (pQList->Head == NULL)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_EMPTY;

    return HAL_ERROR;
  }

  /* Check if queue is dynamic */
  if (pQList->Type == QUEUE_TYPE_DYNAMIC)
  {
    return HAL_OK;
  }

  /* Update the queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_BUSY;

  /* Update the queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Get CLLR register mask and offset */
  DMA_List_GetCLLRNodeInfo(pQList->Head, NULL, &cllr_offset);

  /* Check queue circularity */
  if (pQList->FirstCircularNode != 0U)
  {
    /* Find the last queue node and get its position in selected queue */
    node_info.cllr_offset = cllr_offset;
    (void)DMA_List_FindNode(pQList, NULL, &node_info);
  }

  /* Set current node address */
  currentnode_addr = (uint32_t)pQList->Head;

  /* Store register value */
  DMA_List_FillNode(pQList->Head, &context_node);

  /* Convert all nodes to dyncamic (Bypass head node) */
  for (uint32_t node_count = 1U; node_count < pQList->NodeNumber; node_count++)
  {
    /* Update node address */
    MODIFY_REG(currentnode_addr, DMA_CLLR_LA, (context_node.LinkRegisters[cllr_offset] & DMA_CLLR_LA));

    /* Bypass the first circular node when first circular node isn't the last queue node */
    if (((uint32_t)pQList->FirstCircularNode != 0U)                         &&
        ((uint32_t)pQList->FirstCircularNode != node_info.currentnode_addr) &&
        ((uint32_t)pQList->FirstCircularNode == currentnode_addr))
    {
      /* Copy first circular node to context node */
      DMA_List_FillNode(pQList->FirstCircularNode, &context_node);
    }
    else
    {
      /* Convert current node to dynamic */
      DMA_List_ConvertNodeToDynamic((uint32_t)&context_node, currentnode_addr, (cllr_offset + 1U));
    }
  }

  /* Check if first circular node is the last node queue */
  if (((uint32_t)pQList->FirstCircularNode != 0U) &&
      ((uint32_t)pQList->FirstCircularNode != node_info.currentnode_addr))
  {
    /* Update all queue nodes CLLR */
    DMA_List_UpdateDynamicQueueNodesCLLR(pQList, LASTNODE_ISNOT_CIRCULAR);
  }
  else
  {
    /* Update all queue nodes CLLR */
    DMA_List_UpdateDynamicQueueNodesCLLR(pQList, LASTNODE_IS_CIRCULAR);
  }

  /* Set queue type */
  pQList->Type = QUEUE_TYPE_DYNAMIC;

  /* Update the queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Update the queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_READY;

  return HAL_OK;
}

/**
  * @brief  Convert a linked-list queue to static (Not optimized DMA queue execution).
  * @param  pQList : Pointer to a DMA_QListTypeDef structure that contains queue information.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_List_ConvertQToStatic(DMA_QListTypeDef *const pQList)
{
  uint32_t cllr_offset;
  uint32_t currentnode_addr;
  DMA_NodeTypeDef context_node;

  /* Check the queue parameter */
  if (pQList == NULL)
  {
    return HAL_ERROR;
  }

  /* Check the queue */
  if (pQList->Head == NULL)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_EMPTY;

    return HAL_ERROR;
  }

  /* Check if queue is static */
  if (pQList->Type == QUEUE_TYPE_STATIC)
  {
    return HAL_OK;
  }

  /* Set current node address */
  currentnode_addr = (uint32_t)pQList->Head;

  /* Update the queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_BUSY;

  /* Update the queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Get CLLR register mask and offset */
  DMA_List_GetCLLRNodeInfo(pQList->Head, NULL, &cllr_offset);

  /* Set all CLLR queue nodes to their default positions */
  DMA_List_UpdateStaticQueueNodesCLLR(pQList, UPDATE_CLLR_POSITION);

  /* Convert all nodes to static (Bypass head node) */
  for (uint32_t node_count = 1U; node_count < pQList->NodeNumber; node_count++)
  {
    /* Update context node register values */
    DMA_List_FillNode((DMA_NodeTypeDef *)currentnode_addr, &context_node);

    /* Update node address */
    MODIFY_REG(currentnode_addr, DMA_CLLR_LA, (context_node.LinkRegisters[cllr_offset] & DMA_CLLR_LA));

    /* Convert current node to static */
    DMA_List_ConvertNodeToStatic((uint32_t)&context_node, currentnode_addr, (cllr_offset + 1U));
  }

  /* Set all CLLR queue nodes to their default values */
  DMA_List_UpdateStaticQueueNodesCLLR(pQList, UPDATE_CLLR_VALUE);

  /* Set queue type */
  pQList->Type = QUEUE_TYPE_STATIC;

  /* Update the queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Update the queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_READY;

  return HAL_OK;
}

/**
  * @brief  Link linked-list queue to a DMA channel.
  * @param  hdma   : Pointer to a DMA_HandleTypeDef structure that contains the configuration information for the
  *                  specified DMA Channel.
  * @param  pQList : Pointer to a DMA_QListTypeDef structure that contains queue information.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_List_LinkQ(DMA_HandleTypeDef *const hdma,
                                       DMA_QListTypeDef *const pQList)
{
  HAL_DMA_StateTypeDef state;

  /* Check the DMA channel handle and the queue parameters */
  if ((hdma == NULL) || (pQList == NULL))
  {
    return HAL_ERROR;
  }

  /* Get DMA state */
  state = hdma->State;

  /* Check DMA channel state */
  if ((hdma->State == HAL_DMA_STATE_BUSY) || (state == HAL_DMA_STATE_SUSPEND))
  {
    /* Update the DMA channel error code */
    hdma->ErrorCode = HAL_DMA_ERROR_BUSY;

    /* Process unlocked */
    __HAL_UNLOCK(hdma);

    return HAL_ERROR;
  }

  /* Check queue state */
  if (pQList->State == HAL_DMA_QUEUE_STATE_BUSY)
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_BUSY;

    return HAL_ERROR;
  }

  /* Check linearity compatibility */
  if ((IS_DMA_2D_ADDRESSING_INSTANCE(hdma->Instance) == 0U) &&
      ((pQList->Head->NodeInfo & DMA_CHANNEL_TYPE_2D_ADDR) == DMA_CHANNEL_TYPE_2D_ADDR))
  {
    /* Update the queue error code */
    pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_UNSUPPORTED;

    return HAL_ERROR;
  }

  /* Check circularity compatibility */
  if (hdma->Mode == DMA_LINKEDLIST_CIRCULAR)
  {
    /* Check first circular node */
    if (pQList->FirstCircularNode == NULL)
    {
      /* Update the queue error code */
      pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

      return HAL_ERROR;
    }
  }
  else
  {
    /* Check first circular node */
    if (pQList->FirstCircularNode != NULL)
    {
      /* Update the queue error code */
      pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_INVALIDTYPE;

      return HAL_ERROR;
    }
  }

  /* Register queue to DMA handle */
  hdma->LinkedListQueue = pQList;

  return HAL_OK;
}

/**
  * @brief  Unlink linked-list queue from a DMA channel.
  * @param  hdma : Pointer to a DMA_HandleTypeDef structure that contains the configuration information for the
  *                specified DMA Channel.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_List_UnLinkQ(DMA_HandleTypeDef *const hdma)
{
  HAL_DMA_StateTypeDef state;

  /* Check the DMA channel parameter */
  if (hdma == NULL)
  {
    return HAL_ERROR;
  }

  /* Get DMA state */
  state = hdma->State;

  /* Check DMA channel state */
  if ((hdma->State == HAL_DMA_STATE_BUSY) || (state == HAL_DMA_STATE_SUSPEND))
  {
    /* Update the DMA channel error code */
    hdma->ErrorCode = HAL_DMA_ERROR_BUSY;

    /* Process unlocked */
    __HAL_UNLOCK(hdma);

    return HAL_ERROR;
  }

  /* Clear queue information from DMA channel handle */
  hdma->LinkedListQueue = NULL;

  return HAL_OK;
}
/**
  * @}
  */

/** @addtogroup DMAEx_Exported_Functions_Group4
  *
@verbatim
  ======================================================================================================================
             ##### Data handling, repeated block and trigger configuration functions #####
  ======================================================================================================================
    [..]
      This section provides functions allowing to :
      (+) Configure DMA channel data handling.
      (+) Configure DMA channel repeated block.
      (+) Configure DMA channel trigger.

    [..]
      (+) The HAL_DMAEx_ConfigDataHandling() function allows to configure DMA channel data handling.
              (++) GPDMA or HPDMA data handling : byte-based reordering, packing/unpacking, padding/truncation,
                                                  sign extension and left/right alignment.

      (+) The HAL_DMAEx_ConfigTrigger() function allows to configure DMA channel HW triggers.

      (+) The HAL_DMAEx_ConfigRepeatBlock() function allows to configure DMA channel repeated block.
              (++) This feature is available only for channel that supports 2 dimensions addressing capability.

@endverbatim
  * @{
  */

/**
  * @brief  Configure the DMA channel data handling according to the specified parameters in the
  *         DMA_DataHandlingConfTypeDef.
  * @param  hdma                : Pointer to a DMA_HandleTypeDef structure that contains the configuration information
  *                               for the specified DMA Channel.
  * @param  pConfigDataHandling : Pointer to a DMA_DataHandlingConfTypeDef structure that contains the data handling
  *                               configuration.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_ConfigDataHandling(DMA_HandleTypeDef *const hdma,
                                               DMA_DataHandlingConfTypeDef const *const pConfigDataHandling)
{
  /* Check the DMA peripheral handle and data handling parameters */
  if ((hdma == NULL) || (pConfigDataHandling == NULL))
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_DMA_DATA_ALIGNMENT(pConfigDataHandling->DataAlignment));
  assert_param(IS_DMA_DATA_EXCHANGE(pConfigDataHandling->DataExchange));

  /* Check DMA channel state */
  if (hdma->State == HAL_DMA_STATE_READY)
  {
    MODIFY_REG(hdma->Instance->CTR1, (DMA_CTR1_DWX | DMA_CTR1_DHX | DMA_CTR1_DBX | DMA_CTR1_SBX | DMA_CTR1_PAM),
               (pConfigDataHandling->DataAlignment | pConfigDataHandling->DataExchange));
  }
  else
  {
    /* Update the DMA channel error code */
    hdma->ErrorCode = HAL_DMA_ERROR_BUSY;

    /* Process unlocked */
    __HAL_UNLOCK(hdma);

    return HAL_ERROR;
  }

  return HAL_OK;
}

/**
  * @brief  Configure the DMA channel trigger according to the specified parameters in the DMA_TriggerConfTypeDef.
  * @param  hdma           : Pointer to a DMA_HandleTypeDef structure that contains the configuration information for
  *                          the specified DMA Channel.
  * @param  pConfigTrigger : Pointer to a DMA_TriggerConfTypeDef structure that contains the trigger configuration.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_ConfigTrigger(DMA_HandleTypeDef *const hdma,
                                          DMA_TriggerConfTypeDef const *const pConfigTrigger)
{
  /* Check the DMA peripheral handle and trigger parameters */
  if ((hdma == NULL) || (pConfigTrigger == NULL))
  {
    return HAL_ERROR;
  }

  /* Check the parameters */
  assert_param(IS_DMA_ALL_INSTANCE(hdma->Instance));
  assert_param(IS_DMA_TRIGGER_POLARITY(pConfigTrigger->TriggerPolarity));
  assert_param(IS_DMA_TRIGGER_MODE(pConfigTrigger->TriggerMode));
  assert_param(IS_DMA_TRIGGER_SELECTION(pConfigTrigger->TriggerSelection));

  /* Check DMA channel state */
  if (hdma->State == HAL_DMA_STATE_READY)
  {
    MODIFY_REG(hdma->Instance->CTR2, (DMA_CTR2_TRIGPOL | DMA_CTR2_TRIGSEL | DMA_CTR2_TRIGM),
               (pConfigTrigger->TriggerPolarity | pConfigTrigger->TriggerMode |
                (pConfigTrigger->TriggerSelection << DMA_CTR2_TRIGSEL_Pos)));
  }
  else
  {
    /* Update the DMA channel error code */
    hdma->ErrorCode = HAL_DMA_ERROR_BUSY;

    /* Process unlocked */
    __HAL_UNLOCK(hdma);

    return HAL_ERROR;
  }

  return HAL_OK;
}

/**
  * @brief  Configure the DMA channel repeated block according to the specified parameters in the
  *         DMA_RepeatBlockConfTypeDef.
  * @param  hdma               : Pointer to a DMA_HandleTypeDef structure that contains the configuration information
  *                              for the specified DMA Channel.
  * @param  pConfigRepeatBlock : Pointer to a DMA_RepeatBlockConfTypeDef structure that contains the repeated block
  *                              configuration.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_ConfigRepeatBlock(DMA_HandleTypeDef *const hdma,
                                              DMA_RepeatBlockConfTypeDef const *const pConfigRepeatBlock)
{
  uint32_t tmpreg1;
  uint32_t tmpreg2;

  /* Check the DMA peripheral handle and repeated block parameters */
  if ((hdma == NULL) || (pConfigRepeatBlock == NULL))
  {
    return HAL_ERROR;
  }

  /* Check parameters */
  assert_param(IS_DMA_2D_ADDRESSING_INSTANCE(hdma->Instance));
  assert_param(IS_DMA_REPEAT_COUNT(pConfigRepeatBlock->RepeatCount));
  assert_param(IS_DMA_BURST_ADDR_OFFSET(pConfigRepeatBlock->SrcAddrOffset));
  assert_param(IS_DMA_BURST_ADDR_OFFSET(pConfigRepeatBlock->DestAddrOffset));
  assert_param(IS_DMA_BLOCK_ADDR_OFFSET(pConfigRepeatBlock->BlkSrcAddrOffset));
  assert_param(IS_DMA_BLOCK_ADDR_OFFSET(pConfigRepeatBlock->BlkDestAddrOffset));

  /* Check DMA channel state */
  if (hdma->State == HAL_DMA_STATE_READY)
  {
    /* Store repeat block count */
    tmpreg1 = ((pConfigRepeatBlock->RepeatCount - 1U) << DMA_CBR1_BRC_Pos);

    /* Check the sign of single/burst destination address offset value */
    if (pConfigRepeatBlock->DestAddrOffset < 0)
    {
      /* Store single/burst destination address offset configuration (signed case) */
      tmpreg1 |= DMA_CBR1_DDEC;
      tmpreg2 = (uint32_t)(- pConfigRepeatBlock->DestAddrOffset);
      tmpreg2 = tmpreg2 << DMA_CTR3_DAO_Pos;
    }
    else
    {
      /* Store single/burst destination address offset configuration (unsigned case) */
      tmpreg2 = ((uint32_t)pConfigRepeatBlock->DestAddrOffset << DMA_CTR3_DAO_Pos);
    }

    /* Check the sign of single/burst source address offset value */
    if (pConfigRepeatBlock->SrcAddrOffset < 0)
    {
      /* Store single/burst source address offset configuration (signed case) */
      tmpreg1 |= DMA_CBR1_SDEC;
      tmpreg2 |= (uint32_t)(- pConfigRepeatBlock->SrcAddrOffset);
    }
    else
    {
      /* Store single/burst source address offset configuration (unsigned case) */
      tmpreg2 |= (uint32_t)pConfigRepeatBlock->SrcAddrOffset;
    }

    /* Write DMA Channel Transfer Register 3 (CTR3) */
    WRITE_REG(hdma->Instance->CTR3, tmpreg2);

    /* Check the sign of block destination address offset value */
    if (pConfigRepeatBlock->BlkDestAddrOffset < 0)
    {
      /* Store block destination address offset configuration (signed case) */
      tmpreg1 |= DMA_CBR1_BRDDEC;
      tmpreg2 = (uint32_t)(- pConfigRepeatBlock->BlkDestAddrOffset);
      tmpreg2 = tmpreg2 << DMA_CBR2_BRDAO_Pos;
    }
    else
    {
      /* Store block destination address offset configuration (unsigned case) */
      tmpreg2 = ((uint32_t)pConfigRepeatBlock->BlkDestAddrOffset << DMA_CBR2_BRDAO_Pos);
    }

    /* Check the sign of block source address offset value */
    if (pConfigRepeatBlock->BlkSrcAddrOffset < 0)
    {
      /* Store block source address offset configuration (signed case) */
      tmpreg1 |= DMA_CBR1_BRSDEC;
      tmpreg2 |= (uint32_t)(- pConfigRepeatBlock->BlkSrcAddrOffset);
    }
    else
    {
      /* Store block source address offset configuration (unsigned case) */
      tmpreg2 |= (uint32_t)pConfigRepeatBlock->BlkSrcAddrOffset;
    }

    /* Write DMA Channel block register 2 (CBR2) */
    WRITE_REG(hdma->Instance->CBR2, tmpreg2);

    /* Write DMA Channel block register 1 (CBR1) */
    WRITE_REG(hdma->Instance->CBR1, tmpreg1);
  }
  else
  {
    /* Update the DMA channel error code */
    hdma->ErrorCode = HAL_DMA_ERROR_BUSY;

    /* Process unlocked */
    __HAL_UNLOCK(hdma);

    return HAL_ERROR;
  }

  return HAL_OK;
}
/**
  * @}
  */

/** @addtogroup DMAEx_Exported_Functions_Group5
  *
@verbatim
  ======================================================================================================================
                         ##### Suspend and resume operation functions #####
  ======================================================================================================================
    [..]
      This section provides functions allowing to :
      (+) Suspend any ongoing DMA channel transfer.
      (+) Resume any suspended DMA channel transfer.

    [..]
      (+) The HAL_DMAEx_Suspend() function allows to suspend any ongoing DMA channel transfer in polling mode (Blocking
          mode).

      (+) The HAL_DMAEx_Suspend_IT() function allows to suspend any ongoing DMA channel transfer in interrupt mode
         (Non-blocking mode).

      (+) The HAL_DMAEx_Resume() function allows to resume any suspended DMA channel transfer.

@endverbatim
  * @{
  */

/**
  * @brief  Suspend any ongoing DMA channel transfer in polling mode (Blocking mode).
  * @param  hdma : Pointer to a DMA_HandleTypeDef structure that contains the configuration information for the
  *                specified DMA channel.
  * @note   After suspending a DMA channel, a check for wait until the DMA channel is effectively suspended is added. If
  *         a channel is suspended while a data transfer is ongoing, the current data will be transferred and the
  *         channel will be effectively suspended only after the transfer of this single/burst data is finished.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_Suspend(DMA_HandleTypeDef *const hdma)
{
  /* Get tick number */
  uint32_t tickstart = HAL_GetTick();

  /* Check the DMA peripheral handle */
  if (hdma == NULL)
  {
    return HAL_ERROR;
  }

  /* Check DMA channel state */
  if (hdma->State != HAL_DMA_STATE_BUSY)
  {
    /* Update the DMA channel error code */
    hdma->ErrorCode = HAL_DMA_ERROR_NO_XFER;

    /* Process unlocked */
    __HAL_UNLOCK(hdma);

    return HAL_ERROR;
  }
  else
  {
    /* Suspend the channel */
    hdma->Instance->CCR |= DMA_CCR_SUSP;

    /* Check if the DMA channel is suspended */
    while ((hdma->Instance->CSR & DMA_CSR_SUSPF) == 0U)
    {
      /* Check for the timeout */
      if ((HAL_GetTick() - tickstart) > HAL_TIMEOUT_DMA_ABORT)
      {
        /* Update the DMA channel error code */
        hdma->ErrorCode |= HAL_DMA_ERROR_TIMEOUT;

        /* Update the DMA channel state */
        hdma->State = HAL_DMA_STATE_ERROR;

        /* Process Unlocked */
        __HAL_UNLOCK(hdma);

        return HAL_ERROR;
      }
    }

    /* Update the DMA channel state */
    hdma->State = HAL_DMA_STATE_SUSPEND;
  }

  return HAL_OK;
}

/**
  * @brief  Suspend any ongoing DMA channel transfer in polling mode (Non-blocking mode).
  * @param  hdma : Pointer to a DMA_HandleTypeDef structure that contains the configuration information for the
  *                specified DMA Channel.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_Suspend_IT(DMA_HandleTypeDef *const hdma)
{
  /* Check the DMA peripheral handle parameter */
  if (hdma == NULL)
  {
    return HAL_ERROR;
  }

  /* Check DMA channel state */
  if (hdma->State != HAL_DMA_STATE_BUSY)
  {
    /* Update the DMA channel error code */
    hdma->ErrorCode = HAL_DMA_ERROR_NO_XFER;

    /* Process unlocked */
    __HAL_UNLOCK(hdma);

    return HAL_ERROR;
  }
  else
  {
    /* Suspend the DMA channel and activate suspend interrupt */
    hdma->Instance->CCR |= (DMA_CCR_SUSP | DMA_CCR_SUSPIE);
  }

  return HAL_OK;
}

/**
  * @brief  Resume any suspended DMA channel transfer.
  * @param  hdma : Pointer to a DMA_HandleTypeDef structure that contains the configuration information for the
  *                specified DMA Channel.
  * @retval HAL status.
  */
HAL_StatusTypeDef HAL_DMAEx_Resume(DMA_HandleTypeDef *const hdma)
{
  /* Check the DMA peripheral handle parameter */
  if (hdma == NULL)
  {
    return HAL_ERROR;
  }

  /* Check DMA channel state */
  if (hdma->State != HAL_DMA_STATE_SUSPEND)
  {
    /* Update the DMA channel error code */
    hdma->ErrorCode = HAL_DMA_ERROR_NO_XFER;

    /* Process unlocked */
    __HAL_UNLOCK(hdma);

    return HAL_ERROR;
  }
  else
  {
    /* Resume the DMA channel */
    hdma->Instance->CCR &= (~DMA_CCR_SUSP);

    /* Clear the suspend flag */
    hdma->Instance->CFCR |= DMA_CFCR_SUSPF;

    /* Update the DMA channel state */
    hdma->State = HAL_DMA_STATE_BUSY;
  }

  return HAL_OK;
}
/**
  * @}
  */

/** @addtogroup DMAEx_Exported_Functions_Group6
  *
@verbatim
  ======================================================================================================================
                               ##### Fifo status function #####
  ======================================================================================================================
    [..]
      This section provides function allowing to get DMA channel FIFO level.

    [..]
      (+) The HAL_DMAEx_GetFifoLevel() function allows to return the number of available write beats in the FIFO, in
          units of the programmed destination data.
              (++) This API is available only for DMA channels that supports FIFO.

@endverbatim
  * @{
  */

/**
  * @brief  Get and returns the DMA channel FIFO level.
  * @param  hdma : Pointer to a DMA_HandleTypeDef structure that contains the configuration information for the
  *                specified DMA Channel.
  * @retval Returns the number of available beats in FIFO.
  */
uint32_t HAL_DMAEx_GetFifoLevel(DMA_HandleTypeDef const *const hdma)
{
  return ((hdma->Instance->CSR & DMA_CSR_FIFOL) >> DMA_CSR_FIFOL_Pos);
}
/**
  * @}
  */

/**
  * @}
  */

/* Private functions -------------------------------------------------------------------------------------------------*/
/** @defgroup DMAEx_Private_Functions DMAEx Private Functions
  * @brief    DMAEx Private Functions
  * @{
  */

/**
  * @brief  Initialize the DMA handle according to the specified parameters in the DMA_InitTypeDef.
  * @param  hdma : pointer to a DMA_HandleTypeDef structure that contains the configuration information for the
  *                specified DMA Channel.
  * @retval None.
  */
static void DMA_List_Init(DMA_HandleTypeDef const *const hdma)
{
  uint32_t tmpreg;

  /* Prepare DMA Channel Control Register (CCR) value */
  tmpreg = hdma->InitLinkedList.Priority | hdma->InitLinkedList.LinkStepMode;

  /* Check DMA channel instance */
  if ((IS_HPDMA_INSTANCE(hdma->Instance) != 0U) || (IS_GPDMA_INSTANCE(hdma->Instance) != 0U))
  {
    tmpreg |= hdma->InitLinkedList.LinkAllocatedPort;
  }

  /* Write DMA Channel Control Register (CCR) */
  MODIFY_REG(hdma->Instance->CCR, DMA_CCR_PRIO | DMA_CCR_LAP | DMA_CCR_LSM, tmpreg);

  /* Write DMA Channel Control Register (CTR1) */
  WRITE_REG(hdma->Instance->CTR1, 0U);

  /* Write DMA Channel Control Register (CTR2) */
  WRITE_REG(hdma->Instance->CTR2, hdma->InitLinkedList.TransferEventMode);

  /* Write DMA Channel Control Register (CBR1) */
  WRITE_REG(hdma->Instance->CBR1, 0U);

  /* Write DMA Channel Control Register (CSAR) */
  WRITE_REG(hdma->Instance->CSAR, 0U);

  /* Write DMA Channel Control Register (CDAR) */
  WRITE_REG(hdma->Instance->CDAR, 0U);

  /* If 2D Addressing is supported by current channel */
  if (IS_DMA_2D_ADDRESSING_INSTANCE(hdma->Instance) != 0U)
  {
    /* Write DMA Channel Control Register (CTR3) */
    WRITE_REG(hdma->Instance->CTR3, 0U);

    /* Write DMA Channel Control Register (CBR2) */
    WRITE_REG(hdma->Instance->CBR2, 0U);
  }

  /* Write DMA Channel linked-list address register (CLLR) */
  WRITE_REG(hdma->Instance->CLLR, 0U);
}

/**
  * @brief  Build a DMA channel node according to the specified parameters in the DMA_NodeConfTypeDef.
  * @param  pNodeConfig : Pointer to a DMA_NodeConfTypeDef structure that contains the configuration information for the
  *                       specified DMA linked-list Node.
  * @param  pNode       : Pointer to a DMA_NodeTypeDef structure that contains linked-list node registers
  *                       configurations.
  * @retval None.
  */
static void DMA_List_BuildNode(DMA_NodeConfTypeDef const *const pNodeConfig,
                               DMA_NodeTypeDef *const pNode)
{
  int32_t blockoffset;

  /* Update CTR1 register value ***************************************************************************************/
  /* Prepare DMA channel transfer register (CTR1) value */
  pNode->LinkRegisters[NODE_CTR1_DEFAULT_OFFSET] = pNodeConfig->Init.DestInc                     |
                                                   pNodeConfig->Init.DestDataWidth               |
                                                   pNodeConfig->DataHandlingConfig.DataAlignment |
                                                   pNodeConfig->Init.SrcInc                      |
                                                   pNodeConfig->Init.SrcDataWidth;


  /* Add parameters related to DMA configuration */
  if ((pNodeConfig->NodeType & (DMA_CHANNEL_TYPE_GPDMA | DMA_CHANNEL_TYPE_HPDMA)) != 0U)
  {
    /* Prepare DMA channel transfer register (CTR1) value */
    pNode->LinkRegisters[NODE_CTR1_DEFAULT_OFFSET] |=
      (pNodeConfig->Init.TransferAllocatedPort | pNodeConfig->DataHandlingConfig.DataExchange |
       (((pNodeConfig->Init.DestBurstLength - 1U) << DMA_CTR1_DBL_1_Pos) & DMA_CTR1_DBL_1)    |
       (((pNodeConfig->Init.SrcBurstLength - 1U) << DMA_CTR1_SBL_1_Pos) & DMA_CTR1_SBL_1));
  }
  /*********************************************************************************** CTR1 register value is updated */


  /* Update CTR2 register value ***************************************************************************************/
  /* Prepare DMA channel transfer register 2 (CTR2) value */
  pNode->LinkRegisters[NODE_CTR2_DEFAULT_OFFSET] = pNodeConfig->Init.TransferEventMode |
                                                   (pNodeConfig->Init.Request & (DMA_CTR2_REQSEL | DMA_CTR2_SWREQ));

  /* Check for memory to peripheral transfer */
  if ((pNodeConfig->Init.Direction) == DMA_MEMORY_TO_PERIPH)
  {
    /* Check for GPDMA OR HPDMA */
    if ((pNodeConfig->NodeType & (DMA_CHANNEL_TYPE_GPDMA | DMA_CHANNEL_TYPE_HPDMA)) != 0U)
    {
      pNode->LinkRegisters[NODE_CTR2_DEFAULT_OFFSET] |= DMA_CTR2_DREQ;
    }
  }
  /* Memory to memory transfer */
  else if ((pNodeConfig->Init.Direction) == DMA_MEMORY_TO_MEMORY)
  {
    pNode->LinkRegisters[NODE_CTR2_DEFAULT_OFFSET] |= DMA_CTR2_SWREQ;
  }
  else
  {
    /* Prevent MISRA-C2012-Rule-15.7 */
  }

  /* Configure HW Peripheral flow control selection */
  pNode->LinkRegisters[NODE_CTR2_DEFAULT_OFFSET] |= pNodeConfig->Init.Mode;

  /* Check if trigger feature is active */
  if (pNodeConfig->TriggerConfig.TriggerPolarity != DMA_TRIG_POLARITY_MASKED)
  {
    /* Prepare DMA channel transfer register 2 (CTR2) value */
    pNode->LinkRegisters[NODE_CTR2_DEFAULT_OFFSET] |=
      pNodeConfig->TriggerConfig.TriggerMode | pNodeConfig->TriggerConfig.TriggerPolarity |
      ((pNodeConfig->TriggerConfig.TriggerSelection << DMA_CTR2_TRIGSEL_Pos) & DMA_CTR2_TRIGSEL);
  }
  /*********************************************************************************** CTR2 register value is updated */


  /* Update CBR1 register value ***************************************************************************************/
  /* Prepare DMA channel block register 1 (CBR1) value */
  pNode->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = (pNodeConfig->DataSize & DMA_CBR1_BNDT);

  /* If 2D addressing is supported by the selected DMA channel */
  if ((pNodeConfig->NodeType & DMA_CHANNEL_TYPE_2D_ADDR) == DMA_CHANNEL_TYPE_2D_ADDR)
  {
    /* Set the new CBR1 Register value */
    pNode->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] |=
      (((pNodeConfig->RepeatBlockConfig.RepeatCount - 1U) << DMA_CBR1_BRC_Pos) & DMA_CBR1_BRC);

    /* If the source address offset is negative, set SDEC bit */
    if (pNodeConfig->RepeatBlockConfig.SrcAddrOffset < 0)
    {
      pNode->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] |= DMA_CBR1_SDEC;
    }
    else
    {
      pNode->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] &= (~DMA_CBR1_SDEC);
    }

    /* If the destination address offset is negative, set DDEC bit */
    if (pNodeConfig->RepeatBlockConfig.DestAddrOffset < 0)
    {
      pNode->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] |= DMA_CBR1_DDEC;
    }
    else
    {
      pNode->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] &= (~DMA_CBR1_DDEC);
    }

    /* If the repeated block source address offset is negative, set BRSEC bit */
    if (pNodeConfig->RepeatBlockConfig.BlkSrcAddrOffset < 0)
    {
      pNode->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] |= DMA_CBR1_BRSDEC;
    }
    else
    {
      pNode->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] &= (~DMA_CBR1_BRSDEC);
    }

    /* if the repeated block destination address offset is negative, set BRDEC bit */
    if (pNodeConfig->RepeatBlockConfig.BlkDestAddrOffset < 0)
    {
      pNode->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] |= DMA_CBR1_BRDDEC;
    }
    else
    {
      pNode->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] &= (~DMA_CBR1_BRDDEC);
    }
  }
  /*********************************************************************************** CBR1 register value is updated */


  /* Update CSAR register value ***************************************************************************************/
  pNode->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = pNodeConfig->SrcAddress;
  /*********************************************************************************** CSAR register value is updated */


  /* Update CDAR register value ***************************************************************************************/
  pNode->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = pNodeConfig->DstAddress;
  /*********************************************************************************** CDAR register value is updated */

  /* Check if the selected channel is 2D addressing */
  if ((pNodeConfig->NodeType & DMA_CHANNEL_TYPE_2D_ADDR) == DMA_CHANNEL_TYPE_2D_ADDR)
  {
    /* Update CTR3 register value *************************************************************************************/
    /* Write new CTR3 Register value : source address offset */
    if (pNodeConfig->RepeatBlockConfig.SrcAddrOffset < 0)
    {
      blockoffset = (- pNodeConfig->RepeatBlockConfig.SrcAddrOffset);
      pNode->LinkRegisters[NODE_CTR3_DEFAULT_OFFSET] = ((uint32_t)blockoffset & DMA_CTR3_SAO);
    }
    else
    {
      pNode->LinkRegisters[NODE_CTR3_DEFAULT_OFFSET] =
        ((uint32_t)pNodeConfig->RepeatBlockConfig.SrcAddrOffset & DMA_CTR3_SAO);
    }

    /* Write new CTR3 Register value : destination address offset */
    if (pNodeConfig->RepeatBlockConfig.DestAddrOffset < 0)
    {
      blockoffset = (- pNodeConfig->RepeatBlockConfig.DestAddrOffset);
      pNode->LinkRegisters[NODE_CTR3_DEFAULT_OFFSET] |= (((uint32_t)blockoffset << DMA_CTR3_DAO_Pos) & DMA_CTR3_DAO);
    }
    else
    {
      pNode->LinkRegisters[NODE_CTR3_DEFAULT_OFFSET] |=
        (((uint32_t)pNodeConfig->RepeatBlockConfig.DestAddrOffset << DMA_CTR3_DAO_Pos) & DMA_CTR3_DAO);
    }
    /********************************************************************************* CTR3 register value is updated */


    /* Update CBR2 register value *************************************************************************************/
    /* Write new CBR2 Register value : repeated block source address offset */
    if (pNodeConfig->RepeatBlockConfig.BlkSrcAddrOffset < 0)
    {
      blockoffset = (- pNodeConfig->RepeatBlockConfig.BlkSrcAddrOffset);
      pNode->LinkRegisters[NODE_CBR2_DEFAULT_OFFSET] = ((uint32_t)blockoffset & DMA_CBR2_BRSAO);
    }
    else
    {
      pNode->LinkRegisters[NODE_CBR2_DEFAULT_OFFSET] =
        ((uint32_t)pNodeConfig->RepeatBlockConfig.BlkSrcAddrOffset & DMA_CBR2_BRSAO);
    }

    /* Write new CBR2 Register value : repeated block destination address offset */
    if (pNodeConfig->RepeatBlockConfig.BlkDestAddrOffset < 0)
    {
      blockoffset = (- pNodeConfig->RepeatBlockConfig.BlkDestAddrOffset);
      pNode->LinkRegisters[NODE_CBR2_DEFAULT_OFFSET] |=
        (((uint32_t)blockoffset & DMA_CBR2_BRSAO) << DMA_CBR2_BRDAO_Pos);
    }
    else
    {
      pNode->LinkRegisters[NODE_CBR2_DEFAULT_OFFSET] |=
        (((uint32_t)pNodeConfig->RepeatBlockConfig.BlkDestAddrOffset << DMA_CBR2_BRDAO_Pos) & DMA_CBR2_BRDAO);
    }
    /********************************************************************************* CBR2 register value is updated */

    /* Update CLLR register value *************************************************************************************/
    /* Reset CLLR Register value : channel linked-list address register offset */
    pNode->LinkRegisters[NODE_CLLR_2D_DEFAULT_OFFSET] = 0U;
    /********************************************************************************* CLLR register value is cleared */
  }
  else
  {
    /* Update CLLR register value *************************************************************************************/
    /* Reset CLLR Register value : channel linked-list address register offset */
    pNode->LinkRegisters[NODE_CLLR_LINEAR_DEFAULT_OFFSET] = 0U;
    /********************************************************************************* CLLR register value is cleared */
  }

  /* Update node information value ************************************************************************************/
  /* Set node information */
  pNode->NodeInfo = pNodeConfig->NodeType;
  if ((pNodeConfig->NodeType & DMA_CHANNEL_TYPE_2D_ADDR) == DMA_CHANNEL_TYPE_2D_ADDR)
  {
    pNode->NodeInfo |= (NODE_CLLR_2D_DEFAULT_OFFSET << NODE_CLLR_IDX_POS);
  }
  else
  {
    pNode->NodeInfo |= (NODE_CLLR_LINEAR_DEFAULT_OFFSET << NODE_CLLR_IDX_POS);
  }
  /******************************************************************************** Node information value is updated */
}

/**
  * @brief  Get a DMA channel node configuration.
  * @param  pNodeConfig : Pointer to a DMA_NodeConfTypeDef structure that contains the configuration information for the
  *                       specified DMA linked-list Node.
  * @param  pNode       : Pointer to a DMA_NodeTypeDef structure that contains linked-list node registers
  *                       configurations.
  * @retval None.
  */
static void DMA_List_GetNodeConfig(DMA_NodeConfTypeDef *const pNodeConfig,
                                   DMA_NodeTypeDef const *const pNode)
{
  uint16_t offset;

  /* Get node information *********************************************************************************************/
  pNodeConfig->NodeType = (pNode->NodeInfo & NODE_TYPE_MASK);
  /*************************************************************************************** Node type value is updated */


  /* Get CTR1 fields values *******************************************************************************************/
  pNodeConfig->Init.SrcInc                      = pNode->LinkRegisters[NODE_CTR1_DEFAULT_OFFSET]   & DMA_CTR1_SINC;
  pNodeConfig->Init.DestInc                     = pNode->LinkRegisters[NODE_CTR1_DEFAULT_OFFSET]   & DMA_CTR1_DINC;
  pNodeConfig->Init.SrcDataWidth                = pNode->LinkRegisters[NODE_CTR1_DEFAULT_OFFSET]   & DMA_CTR1_SDW_LOG2;
  pNodeConfig->Init.DestDataWidth               = pNode->LinkRegisters[NODE_CTR1_DEFAULT_OFFSET]   & DMA_CTR1_DDW_LOG2;
  pNodeConfig->Init.SrcBurstLength              = ((pNode->LinkRegisters[NODE_CTR1_DEFAULT_OFFSET] &
                                                    DMA_CTR1_SBL_1) >> DMA_CTR1_SBL_1_Pos) + 1U;
  pNodeConfig->Init.DestBurstLength             = ((pNode->LinkRegisters[NODE_CTR1_DEFAULT_OFFSET] &
                                                    DMA_CTR1_DBL_1) >> DMA_CTR1_DBL_1_Pos) + 1U;
  pNodeConfig->Init.TransferAllocatedPort       = pNode->LinkRegisters[NODE_CTR1_DEFAULT_OFFSET]   &
                                                  (DMA_CTR1_SAP | DMA_CTR1_DAP);
  pNodeConfig->DataHandlingConfig.DataExchange  = pNode->LinkRegisters[NODE_CTR1_DEFAULT_OFFSET]   &
                                                  (DMA_CTR1_SBX | DMA_CTR1_DBX | DMA_CTR1_DHX | DMA_CTR1_DWX);
  pNodeConfig->DataHandlingConfig.DataAlignment = pNode->LinkRegisters[NODE_CTR1_DEFAULT_OFFSET]   & DMA_CTR1_PAM;
  /*********************************************************************************** CTR1 fields values are updated */


  /* Get CTR2 fields values *******************************************************************************************/
  if ((pNode->LinkRegisters[NODE_CTR2_DEFAULT_OFFSET] & DMA_CTR2_SWREQ) != 0U)
  {
    pNodeConfig->Init.Request   = DMA_REQUEST_SW;
    pNodeConfig->Init.Direction = DMA_MEMORY_TO_MEMORY;
  }
  else
  {
    pNodeConfig->Init.Request   = pNode->LinkRegisters[NODE_CTR2_DEFAULT_OFFSET] & DMA_CTR2_REQSEL;

    if ((pNode->LinkRegisters[NODE_CTR2_DEFAULT_OFFSET] & DMA_CTR2_DREQ) != 0U)
    {
      pNodeConfig->Init.Direction = DMA_MEMORY_TO_PERIPH;
    }
    else
    {
      pNodeConfig->Init.Direction = DMA_PERIPH_TO_MEMORY;
    }
  }

  pNodeConfig->Init.BlkHWRequest              = (pNode->LinkRegisters[NODE_CTR2_DEFAULT_OFFSET] & DMA_CTR2_BREQ);
  pNodeConfig->TriggerConfig.TriggerMode      = pNode->LinkRegisters[NODE_CTR2_DEFAULT_OFFSET]  & DMA_CTR2_TRIGM;
  pNodeConfig->TriggerConfig.TriggerPolarity  = pNode->LinkRegisters[NODE_CTR2_DEFAULT_OFFSET]  & DMA_CTR2_TRIGPOL;
  pNodeConfig->TriggerConfig.TriggerSelection = (pNode->LinkRegisters[NODE_CTR2_DEFAULT_OFFSET] &
                                                 DMA_CTR2_TRIGSEL) >> DMA_CTR2_TRIGSEL_Pos;
  pNodeConfig->Init.TransferEventMode         = pNode->LinkRegisters[NODE_CTR2_DEFAULT_OFFSET]  & DMA_CTR2_TCEM;
  /*********************************************************************************** CTR2 fields values are updated */


  /* Get CBR1 fields **************************************************************************************************/
  pNodeConfig->DataSize = pNode->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] & DMA_CBR1_BNDT;

  if ((pNodeConfig->NodeType & DMA_CHANNEL_TYPE_2D_ADDR) == DMA_CHANNEL_TYPE_2D_ADDR)
  {
    pNodeConfig->RepeatBlockConfig.RepeatCount =
      ((pNode->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] & DMA_CBR1_BRC) >> DMA_CBR1_BRC_Pos) + 1U;
  }
  else
  {
    pNodeConfig->RepeatBlockConfig.RepeatCount = 1U;
  }
  /*********************************************************************************** CBR1 fields values are updated */


  /* Get CSAR field ***************************************************************************************************/
  pNodeConfig->SrcAddress = pNode->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET];
  /************************************************************************************** CSAR field value is updated */


  /* Get CDAR field ***************************************************************************************************/
  pNodeConfig->DstAddress = pNode->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET];
  /************************************************************************************** CDAR field value is updated */

  /* Check if the selected channel is 2D addressing */
  if ((pNodeConfig->NodeType & DMA_CHANNEL_TYPE_2D_ADDR) == DMA_CHANNEL_TYPE_2D_ADDR)
  {
    /* Get CTR3 field *************************************************************************************************/
    offset = (uint16_t)(pNode->LinkRegisters[NODE_CTR3_DEFAULT_OFFSET] & DMA_CTR3_SAO);
    pNodeConfig->RepeatBlockConfig.SrcAddrOffset  = (int32_t)offset;

    offset = (uint16_t)((pNode->LinkRegisters[NODE_CTR3_DEFAULT_OFFSET] & DMA_CTR3_DAO) >> DMA_CTR3_DAO_Pos);
    pNodeConfig->RepeatBlockConfig.DestAddrOffset = (int32_t)offset;

    if ((pNode->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] & DMA_CBR1_SDEC) != 0U)
    {
      pNodeConfig->RepeatBlockConfig.SrcAddrOffset *= (-1);
    }

    if ((pNode->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] & DMA_CBR1_DDEC) != 0U)
    {
      pNodeConfig->RepeatBlockConfig.DestAddrOffset *= (-1);
    }
    /************************************************************************************ CTR3 field value is updated */


    /* Get CBR2 fields ************************************************************************************************/
    offset = (uint16_t)(pNode->LinkRegisters[NODE_CBR2_DEFAULT_OFFSET] & DMA_CBR2_BRSAO);
    pNodeConfig->RepeatBlockConfig.BlkSrcAddrOffset = (int32_t)offset;

    offset = (uint16_t)((pNode->LinkRegisters[NODE_CBR2_DEFAULT_OFFSET] & DMA_CBR2_BRDAO) >> DMA_CBR2_BRDAO_Pos);
    pNodeConfig->RepeatBlockConfig.BlkDestAddrOffset = (int32_t)offset;

    if ((pNode->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] & DMA_CBR1_BRSDEC) != 0U)
    {
      pNodeConfig->RepeatBlockConfig.BlkSrcAddrOffset *= (-1);
    }

    if ((pNode->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] & DMA_CBR1_BRDDEC) != 0U)
    {
      pNodeConfig->RepeatBlockConfig.BlkDestAddrOffset *= (-1);
    }
    /************************************************************************************ CBR2 field value is updated */
  }
  else
  {
    /* Get CTR3 field *************************************************************************************************/
    pNodeConfig->RepeatBlockConfig.SrcAddrOffset     = 0;
    pNodeConfig->RepeatBlockConfig.DestAddrOffset    = 0;
    /************************************************************************************ CTR3 field value is updated */


    /* Get CBR2 fields ************************************************************************************************/
    pNodeConfig->RepeatBlockConfig.BlkSrcAddrOffset  = 0;
    pNodeConfig->RepeatBlockConfig.BlkDestAddrOffset = 0;
    /************************************************************************************ CBR2 field value is updated */
  }
}

/**
  * @brief  Check nodes base addresses compatibility.
  * @param  pNode1 : Pointer to a DMA_NodeTypeDef structure that contains linked-list node 1 registers configurations.
  * @param  pNode2 : Pointer to a DMA_NodeTypeDef structure that contains linked-list node 2 registers configurations.
  * @param  pNode3 : Pointer to a DMA_NodeTypeDef structure that contains linked-list node 3 registers configurations.
  * @retval Return 0 when nodes addresses are compatible, 1 otherwise.
  */
#if defined ( __GNUC__ ) && !defined (__CC_ARM)
static __attribute__((noinline)) uint32_t DMA_List_CheckNodesBaseAddresses(DMA_NodeTypeDef const *const pNode1,  \
                                                                           DMA_NodeTypeDef const *const pNode2,  \
                                                                           DMA_NodeTypeDef const *const pNode3)
#else
static uint32_t DMA_List_CheckNodesBaseAddresses(DMA_NodeTypeDef const *const pNode1,
                                                 DMA_NodeTypeDef const *const pNode2,
                                                 DMA_NodeTypeDef const *const pNode3)
#endif /* __GNUC__ && !__CC_ARM */
{
  uint32_t temp = (((uint32_t)pNode1 | (uint32_t)pNode2 | (uint32_t)pNode3) & DMA_CLBAR_LBA);
  uint32_t ref  = 0U;

  /* Check node 1 address */
  if ((uint32_t)pNode1 != 0U)
  {
    ref = (uint32_t)pNode1;
  }
  /* Check node 2 address */
  else if ((uint32_t)pNode2 != 0U)
  {
    ref = (uint32_t)pNode2;
  }
  /* Check node 3 address */
  else if ((uint32_t)pNode3 != 0U)
  {
    ref = (uint32_t)pNode3;
  }
  else
  {
    /* Prevent MISRA-C2012-Rule-15.7 */
  }

  /* Check addresses compatibility */
  if (temp != ((uint32_t)ref & DMA_CLBAR_LBA))
  {
    return 1U;
  }

  return 0U;
}

/**
  * @brief  Check nodes types compatibility.
  * @param  pNode1 : Pointer to a DMA_NodeTypeDef structure that contains linked-list node 1 registers configurations.
  * @param  pNode2 : Pointer to a DMA_NodeTypeDef structure that contains linked-list node 2 registers configurations.
  * @param  pNode3 : Pointer to a DMA_NodeTypeDef structure that contains linked-list node 3 registers configurations.
  * @retval Return 0 when nodes types are compatible, otherwise nodes types are not compatible.
  */
static uint32_t DMA_List_CheckNodesTypes(DMA_NodeTypeDef const *const pNode1,
                                         DMA_NodeTypeDef const *const pNode2,
                                         DMA_NodeTypeDef const *const pNode3)
{
  uint32_t ref = 0U;

  /* Check node 1 parameter */
  if (pNode1 != NULL)
  {
    ref = pNode1->NodeInfo & NODE_TYPE_MASK;
  }
  /* Check node 2 parameter */
  else if (pNode2 != NULL)
  {
    ref = pNode2->NodeInfo & NODE_TYPE_MASK;
  }
  /* Check node 3 parameter */
  else if (pNode3 != NULL)
  {
    ref = pNode3->NodeInfo & NODE_TYPE_MASK;
  }
  else
  {
    /* Prevent MISRA-C2012-Rule-15.7 */
  }

  /* Check node 2 parameter */
  if (pNode2 != NULL)
  {
    /* Check node type compatibility */
    if (ref != (pNode2->NodeInfo & NODE_TYPE_MASK))
    {
      return 2U;
    }
  }

  /* Check node 3 parameter */
  if (pNode3 != NULL)
  {
    /* Check node type compatibility */
    if (ref != (pNode3->NodeInfo & NODE_TYPE_MASK))
    {
      return 3U;
    }
  }

  return 0U;
}

/**
  * @brief  Check nodes types compatibility.
  * @param  pNode       : Pointer to a DMA_NodeTypeDef structure that contains linked-list node registers
  *                       configurations.
  * @param  cllr_mask   : Pointer to CLLR register mask value.
  * @param  cllr_offset : Pointer to CLLR register offset value.
  * @retval None.
  */
static void DMA_List_GetCLLRNodeInfo(DMA_NodeTypeDef const *const pNode,
                                     uint32_t *const cllr_mask,
                                     uint32_t *const cllr_offset)
{
  /* Check node type */
  if ((pNode->NodeInfo & DMA_CHANNEL_TYPE_2D_ADDR) == DMA_CHANNEL_TYPE_2D_ADDR)
  {
    /* Update CLLR register mask value */
    if (cllr_mask != NULL)
    {
      *cllr_mask = DMA_CLLR_UT1 | DMA_CLLR_UT2 | DMA_CLLR_UB1 | DMA_CLLR_USA | DMA_CLLR_UDA | DMA_CLLR_UT3 |
                   DMA_CLLR_UB2 | DMA_CLLR_ULL;
    }

    /* Update CLLR register offset */
    if (cllr_offset != NULL)
    {
      *cllr_offset = NODE_CLLR_2D_DEFAULT_OFFSET;
    }
  }
  /* Update CLLR and register number for linear addressing node */
  else
  {
    /* Update CLLR register mask value */
    if (cllr_mask != NULL)
    {
      *cllr_mask = DMA_CLLR_UT1 | DMA_CLLR_UT2 | DMA_CLLR_UB1 | DMA_CLLR_USA | DMA_CLLR_UDA | DMA_CLLR_ULL;
    }

    /* Update CLLR register offset */
    if (cllr_offset != NULL)
    {
      *cllr_offset = NODE_CLLR_LINEAR_DEFAULT_OFFSET;
    }
  }
}

/**
  * @brief  Find node in queue.
  * @param  pQList   : Pointer to a DMA_QListTypeDef structure that contains queue information.
  * @param  pNode    : Pointer to a DMA_NodeTypeDef structure that contains linked-list node registers configurations.
  * @param  NodeInfo : Pointer to a DMA_NodeInQInfoTypeDef structure that contains node linked to queue information.
  * @retval Return 0 when node is found in selected queue, otherwise node is not found.
  */
static uint32_t DMA_List_FindNode(DMA_QListTypeDef const *const pQList,
                                  DMA_NodeTypeDef const *const pNode,
                                  DMA_NodeInQInfoTypeDef *const NodeInfo)
{
  uint32_t node_idx = 0U;
  uint32_t currentnode_address  = 0U;
  uint32_t previousnode_address  = 0U;
  uint32_t cllr_offset = NodeInfo->cllr_offset;

  /* Find last node in queue */
  if (pNode ==  NULL)
  {
    /* Check that previous node is linked to the selected queue */
    while (node_idx < pQList->NodeNumber)
    {
      /* Get head node address */
      if (node_idx == 0U)
      {
        currentnode_address = (uint32_t)pQList->Head & DMA_CLLR_LA;
      }
      /* Calculate nodes addresses */
      else
      {
        previousnode_address = currentnode_address;
        currentnode_address =
          ((DMA_NodeTypeDef *)(currentnode_address +
                               ((uint32_t)pQList->Head & DMA_CLBAR_LBA)))->LinkRegisters[cllr_offset] & DMA_CLLR_LA;
      }

      /* Increment node index */
      node_idx++;
    }
  }
  /* Find selected node node in queue */
  else
  {
    /* Check that previous node is linked to the selected queue */
    while ((node_idx < pQList->NodeNumber) && (currentnode_address != ((uint32_t)pNode & DMA_CLLR_LA)))
    {
      /* Get head node address */
      if (node_idx == 0U)
      {
        currentnode_address = (uint32_t)pQList->Head & DMA_CLLR_LA;
      }
      /* Calculate nodes addresses */
      else
      {
        previousnode_address = currentnode_address;
        currentnode_address =
          ((DMA_NodeTypeDef *)(currentnode_address +
                               ((uint32_t)pQList->Head & DMA_CLBAR_LBA)))->LinkRegisters[cllr_offset] & DMA_CLLR_LA;
      }

      /* Increment node index */
      node_idx++;
    }
  }

  /* Check stored address */
  if (pNode != NULL)
  {
    if (currentnode_address != ((uint32_t)pNode & DMA_CLLR_LA))
    {
      return 1U;
    }
  }

  /* Update current node position */
  NodeInfo->currentnode_pos = node_idx;

  /* Update previous node address */
  NodeInfo->previousnode_addr = previousnode_address | ((uint32_t)pQList->Head & DMA_CLBAR_LBA);

  /* Update current node address */
  NodeInfo->currentnode_addr = currentnode_address | ((uint32_t)pQList->Head & DMA_CLBAR_LBA);

  /* Update next node address */
  if (((DMA_NodeTypeDef *)NodeInfo->currentnode_addr)->LinkRegisters[cllr_offset] != 0U)
  {
    NodeInfo->nextnode_addr = (((DMA_NodeTypeDef *)NodeInfo->currentnode_addr)->LinkRegisters[cllr_offset] &
                               DMA_CLLR_LA) | ((uint32_t)pQList->Head & DMA_CLBAR_LBA);
  }

  return 0U;
}

/**
  * @brief  Reset queue nodes.
  * @param  pQList   : Pointer to a DMA_QListTypeDef structure that contains queue information.
  * @param  NodeInfo : Pointer to a DMA_NodeInQInfoTypeDef structure that contains node linked to queue information.
  * @retval None.
  */
static void DMA_List_ResetQueueNodes(DMA_QListTypeDef const *const pQList,
                                     DMA_NodeInQInfoTypeDef const *const NodeInfo)
{
  uint32_t node_idx = 0U;
  uint32_t currentnode_address  = 0U;
  uint32_t previousnode_address;
  uint32_t cllr_offset = NodeInfo->cllr_offset;

  /* Check that previous node is linked to the selected queue */
  while (node_idx < pQList->NodeNumber)
  {
    /* Get head node address */
    if (node_idx == 0U)
    {
      previousnode_address = (uint32_t)pQList->Head & DMA_CLLR_LA;
      currentnode_address  = (pQList->Head->LinkRegisters[cllr_offset] & DMA_CLLR_LA);
    }
    /* Calculate nodes addresses */
    else
    {
      previousnode_address = currentnode_address;
      currentnode_address =
        ((DMA_NodeTypeDef *)(currentnode_address +
                             ((uint32_t)pQList->Head & DMA_CLBAR_LBA)))->LinkRegisters[cllr_offset] & DMA_CLLR_LA;
    }

    /* Reset node */
    ((DMA_NodeTypeDef *)(previousnode_address +
                         ((uint32_t)pQList->Head & DMA_CLBAR_LBA)))->LinkRegisters[cllr_offset] = 0U;

    /* Increment node index */
    node_idx++;
  }
}

/**
  * @brief  Fill source node registers values by destination nodes registers values.
  * @param  pSrcNode  : Pointer to a DMA_NodeTypeDef structure that contains linked-list source node registers
  *                     configurations.
  * @param  pDestNode : Pointer to a DMA_NodeTypeDef structure that contains linked-list destination node registers
  *                     configurations.
  * @retval None.
  */
static void DMA_List_FillNode(DMA_NodeTypeDef const *const pSrcNode,
                              DMA_NodeTypeDef *const pDestNode)
{
  /* Repeat for all register nodes */
  for (uint32_t reg_idx = 0U; reg_idx < NODE_MAXIMUM_SIZE; reg_idx++)
  {
    pDestNode->LinkRegisters[reg_idx] = pSrcNode->LinkRegisters[reg_idx];
  }

  /* Fill node information */
  pDestNode->NodeInfo = pSrcNode->NodeInfo;
}

/**
  * @brief  Convert node to dynamic.
  * @param  ContextNodeAddr : The context node address.
  * @param  CurrentNodeAddr : The current node address to be converted.
  * @param  RegisterNumber  : The register number to be converted.
  * @retval None.
  */
static void DMA_List_ConvertNodeToDynamic(uint32_t ContextNodeAddr,
                                          uint32_t CurrentNodeAddr,
                                          uint32_t RegisterNumber)
{
  uint32_t currentnode_reg_counter = 0U;
  uint32_t contextnode_reg_counter = 0U;
  uint32_t cllr_idx = RegisterNumber - 1U;
  DMA_NodeTypeDef *context_node = (DMA_NodeTypeDef *)ContextNodeAddr;
  DMA_NodeTypeDef *current_node = (DMA_NodeTypeDef *)CurrentNodeAddr;
  uint32_t update_link[NODE_MAXIMUM_SIZE] = {DMA_CLLR_UT1, DMA_CLLR_UT2, DMA_CLLR_UB1, DMA_CLLR_USA,
                                             DMA_CLLR_UDA, DMA_CLLR_UT3, DMA_CLLR_UB2, DMA_CLLR_ULL
                                            };

  /* Update ULL position according to register number */
  update_link[cllr_idx] = update_link[NODE_MAXIMUM_SIZE - 1U];

  /* Repeat for all node registers */
  while (contextnode_reg_counter != RegisterNumber)
  {
    /* Check if register values are equal (exception for CSAR, CDAR and CLLR registers) */
    if ((context_node->LinkRegisters[contextnode_reg_counter]  ==
         current_node->LinkRegisters[currentnode_reg_counter]) &&
        (contextnode_reg_counter != NODE_CSAR_DEFAULT_OFFSET)  &&
        (contextnode_reg_counter != NODE_CDAR_DEFAULT_OFFSET)  &&
        (contextnode_reg_counter != (RegisterNumber - 1U)))
    {
      /* Format the node according to unused registers */
      DMA_List_FormatNode(current_node, currentnode_reg_counter, RegisterNumber, NODE_DYNAMIC_FORMAT);

      /* Update CLLR index */
      cllr_idx --;

      /* Update CLLR fields */
      current_node->LinkRegisters[cllr_idx] &= ~update_link[contextnode_reg_counter];
    }
    else
    {
      /* Update context node register fields with new values */
      context_node->LinkRegisters[contextnode_reg_counter] = current_node->LinkRegisters[currentnode_reg_counter];

      /* Update CLLR fields */
      current_node->LinkRegisters[cllr_idx] |= update_link[contextnode_reg_counter];

      /* Increment current node number register counter */
      currentnode_reg_counter++;
    }

    /* Increment context node number register counter */
    contextnode_reg_counter++;
  }

  /* Update node information */
  MODIFY_REG(current_node->NodeInfo, NODE_CLLR_IDX, ((currentnode_reg_counter - 1U) << NODE_CLLR_IDX_POS));

  /* Clear unused node fields */
  DMA_List_ClearUnusedFields(current_node, currentnode_reg_counter);
}

/**
  * @brief  Convert node to static.
  * @param  ContextNodeAddr : The context node address.
  * @param  CurrentNodeAddr : The current node address to be converted.
  * @param  RegisterNumber  : The register number to be converted.
  * @retval None.
  */
static void DMA_List_ConvertNodeToStatic(uint32_t ContextNodeAddr,
                                         uint32_t CurrentNodeAddr,
                                         uint32_t RegisterNumber)
{
  uint32_t contextnode_reg_counter = 0U;
  uint32_t cllr_idx;
  uint32_t cllr_mask;
  const DMA_NodeTypeDef *context_node = (DMA_NodeTypeDef *)ContextNodeAddr;
  DMA_NodeTypeDef *current_node = (DMA_NodeTypeDef *)CurrentNodeAddr;
  uint32_t update_link[NODE_MAXIMUM_SIZE] = {DMA_CLLR_UT1, DMA_CLLR_UT2, DMA_CLLR_UB1, DMA_CLLR_USA,
                                             DMA_CLLR_UDA, DMA_CLLR_UT3, DMA_CLLR_UB2, DMA_CLLR_ULL
                                            };

  /* Update ULL position according to register number */
  update_link[RegisterNumber - 1U] = update_link[NODE_MAXIMUM_SIZE - 1U];

  /* Get context node CLLR information */
  cllr_idx  = (context_node->NodeInfo & NODE_CLLR_IDX) >> NODE_CLLR_IDX_POS;
  cllr_mask = context_node->LinkRegisters[cllr_idx];

  /* Repeat for all node registers */
  while (contextnode_reg_counter != RegisterNumber)
  {
    /* Check if node field is dynamic */
    if ((cllr_mask & update_link[contextnode_reg_counter]) == 0U)
    {
      /* Format the node according to unused registers */
      DMA_List_FormatNode(current_node, contextnode_reg_counter, RegisterNumber, NODE_STATIC_FORMAT);

      /* Update node field */
      current_node->LinkRegisters[contextnode_reg_counter] = context_node->LinkRegisters[contextnode_reg_counter];
    }

    /* Increment context node number register counter */
    contextnode_reg_counter++;
  }

  /* Update node information */
  MODIFY_REG(current_node->NodeInfo, NODE_CLLR_IDX, ((RegisterNumber - 1U) << NODE_CLLR_IDX_POS));
}

/**
  * @brief  Format the node according to unused registers.
  * @param  pNode           : Pointer to a DMA_NodeTypeDef structure that contains linked-list node registers
  *                           configurations.
  * @param  RegisterIdx     : The first register index to be formatted.
  * @param  RegisterNumber  : The number of node registers.
  * @param  Format          : The format type.
  * @retval None.
  */
static void DMA_List_FormatNode(DMA_NodeTypeDef *const pNode,
                                uint32_t RegisterIdx,
                                uint32_t RegisterNumber,
                                uint32_t Format)
{
  if (Format == NODE_DYNAMIC_FORMAT)
  {
    /* Repeat for all registers to be formatted */
    for (uint32_t reg_idx = RegisterIdx; reg_idx < (RegisterNumber - 1U); reg_idx++)
    {
      pNode->LinkRegisters[reg_idx] = pNode->LinkRegisters[reg_idx + 1U];
    }
  }
  else
  {
    /* Repeat for all registers to be formatted */
    for (uint32_t reg_idx = (RegisterNumber - 2U); reg_idx > RegisterIdx; reg_idx--)
    {
      pNode->LinkRegisters[reg_idx] = pNode->LinkRegisters[reg_idx - 1U];
    }
  }
}

/**
  * @brief  Clear unused register fields.
  * @param  pNode            : Pointer to a DMA_NodeTypeDef structure that contains linked-list node registers
  *                            configurations.
  * @param  FirstUnusedField : The first unused field to be cleared.
  * @retval None.
  */
static void DMA_List_ClearUnusedFields(DMA_NodeTypeDef *const pNode,
                                       uint32_t FirstUnusedField)
{
  /* Repeat for all unused fields */
  for (uint32_t reg_idx = FirstUnusedField; reg_idx < NODE_MAXIMUM_SIZE; reg_idx++)
  {
    pNode->LinkRegisters[reg_idx] = 0U;
  }
}

/**
  * @brief  Update CLLR for all dynamic queue nodes.
  * @param  pQList :              Pointer to a DMA_QListTypeDef structure that contains queue information.
  * @param  LastNode_IsCircular : The first circular node is the last queue node or not.
  * @retval None.
  */
static void DMA_List_UpdateDynamicQueueNodesCLLR(DMA_QListTypeDef const *const pQList,
                                                 uint32_t LastNode_IsCircular)
{
  uint32_t previous_cllr_offset;
  uint32_t current_cllr_offset = 0U;
  uint32_t previousnode_addr;
  uint32_t currentnode_addr = (uint32_t)pQList->Head;
  uint32_t cllr_mask;
  uint32_t node_idx = 0U;

  /*  Repeat for all register nodes */
  while (node_idx < pQList->NodeNumber)
  {
    /* Get head node address */
    if (node_idx == 0U)
    {
      /* Get current node information */
      current_cllr_offset = (((DMA_NodeTypeDef *)currentnode_addr)->NodeInfo & NODE_CLLR_IDX) >> NODE_CLLR_IDX_POS;
    }
    /* Calculate nodes addresses */
    else
    {
      /* Get previous node information */
      previousnode_addr = currentnode_addr;
      previous_cllr_offset = current_cllr_offset;

      /* Get current node information */
      currentnode_addr = (((DMA_NodeTypeDef *)(previousnode_addr))->LinkRegisters[previous_cllr_offset] & DMA_CLLR_LA) +
                         ((uint32_t)pQList->Head & DMA_CLBAR_LBA);
      current_cllr_offset = (((DMA_NodeTypeDef *)currentnode_addr)->NodeInfo & NODE_CLLR_IDX) >> NODE_CLLR_IDX_POS;

      /* Calculate CLLR register value to be updated */
      cllr_mask = (((DMA_NodeTypeDef *)currentnode_addr)->LinkRegisters[current_cllr_offset] & ~DMA_CLLR_LA) |
                  (((DMA_NodeTypeDef *)(previousnode_addr))->LinkRegisters[previous_cllr_offset] & DMA_CLLR_LA);

      /* Set new CLLR value to previous node */
      ((DMA_NodeTypeDef *)(previousnode_addr))->LinkRegisters[previous_cllr_offset] = cllr_mask;
    }

    /* Increment node index */
    node_idx++;
  }

  /* Check queue circularity */
  if (pQList->FirstCircularNode != 0U)
  {
    /* First circular queue is not last queue node */
    if (LastNode_IsCircular == 0U)
    {
      /* Get CLLR node information */
      DMA_List_GetCLLRNodeInfo(((DMA_NodeTypeDef *)currentnode_addr), &cllr_mask, NULL);

      /* Update CLLR register for last circular node */
      ((DMA_NodeTypeDef *)currentnode_addr)->LinkRegisters[current_cllr_offset] =
        ((uint32_t)pQList->Head & DMA_CLLR_LA) | cllr_mask;
    }
    /* First circular queue is last queue node */
    else
    {
      /* Disable CLLR updating */
      ((DMA_NodeTypeDef *)currentnode_addr)->LinkRegisters[current_cllr_offset] &= ~DMA_CLLR_ULL;
    }
  }
  else
  {
    /* Clear CLLR register for last node */
    ((DMA_NodeTypeDef *)currentnode_addr)->LinkRegisters[current_cllr_offset] = 0U;
  }
}

/**
  * @brief  Update CLLR for all static queue nodes.
  * @param  pQList    : Pointer to a DMA_QListTypeDef structure that contains queue information.
  * @param  operation : The operation type.
  * @retval None.
  */
static void DMA_List_UpdateStaticQueueNodesCLLR(DMA_QListTypeDef const *const pQList,
                                                uint32_t operation)
{
  uint32_t currentnode_addr = (uint32_t)pQList->Head;
  uint32_t current_cllr_offset = ((uint32_t)pQList->Head->NodeInfo & NODE_CLLR_IDX) >> NODE_CLLR_IDX_POS;
  uint32_t cllr_default_offset;
  uint32_t cllr_default_mask;
  uint32_t cllr_mask;
  uint32_t node_idx = 0U;

  /* Get CLLR node information */
  DMA_List_GetCLLRNodeInfo(pQList->Head, &cllr_default_mask, &cllr_default_offset);

  /*  Repeat for all register nodes (Bypass last queue node) */
  while (node_idx < pQList->NodeNumber)
  {
    if (operation == UPDATE_CLLR_POSITION)
    {
      /* Get CLLR value */
      cllr_mask = ((DMA_NodeTypeDef *)currentnode_addr)->LinkRegisters[current_cllr_offset];
    }
    else
    {
      /* Calculate CLLR value */
      cllr_mask = (((DMA_NodeTypeDef *)currentnode_addr)->LinkRegisters[current_cllr_offset] & DMA_CLLR_LA) |
                  cllr_default_mask;
    }

    /* Set new CLLR value to default position */
    if ((node_idx == (pQList->NodeNumber - 1U)) && (pQList->FirstCircularNode == NULL))
    {
      ((DMA_NodeTypeDef *)(currentnode_addr))->LinkRegisters[cllr_default_offset] = 0U;
    }
    else
    {
      ((DMA_NodeTypeDef *)(currentnode_addr))->LinkRegisters[cllr_default_offset] = cllr_mask;
    }

    /* Update current node address with next node address */
    currentnode_addr = (currentnode_addr & DMA_CLBAR_LBA) | (cllr_mask & DMA_CLLR_LA);

    /* Update current CLLR offset with next CLLR offset */
    current_cllr_offset = (((DMA_NodeTypeDef *)currentnode_addr)->NodeInfo & NODE_CLLR_IDX) >> NODE_CLLR_IDX_POS;

    /* Increment node index */
    node_idx++;
  }
}

/**
  * @brief  Clean linked-list queue variable.
  * @param  pQList    : Pointer to a DMA_QListTypeDef structure that contains queue information.
  * @retval None.
  */
static void DMA_List_CleanQueue(DMA_QListTypeDef *const pQList)
{
  /* Clear head node */
  pQList->Head = NULL;

  /* Clear first circular queue node */
  pQList->FirstCircularNode = NULL;

  /* Reset node number */
  pQList->NodeNumber = 0U;

  /* Reset queue state */
  pQList->State = HAL_DMA_QUEUE_STATE_RESET;

  /* Reset queue error code */
  pQList->ErrorCode = HAL_DMA_QUEUE_ERROR_NONE;

  /* Reset queue type */
  pQList->Type = QUEUE_TYPE_STATIC;
}
/**
  * @}
  */
