// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CRYP/SAES and CRYPEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
HAL_StatusTypeDef HAL_CRYP_Init(CRYP_HandleTypeDef *hcryp)
{
  /* Check the CRYP handle allocation */
  if (hcryp == NULL)
  {
    return HAL_ERROR;
  }

#if ((USE_HAL_CRYP_ONLY == 1) && (USE_HAL_SAES_ONLY == 0))
  if (IS_SAES_INSTANCE(hcryp->Instance))
  {
    return HAL_ERROR;
  }
#endif /* USE_HAL_CRYP_ONLY */

#if ((USE_HAL_CRYP_ONLY == 0) && (USE_HAL_SAES_ONLY == 1))
  if (IS_CRYP_INSTANCE(hcryp->Instance))
  {
    return HAL_ERROR;
  }
#endif /* USE_HAL_SAES_ONLY */

  /* Check parameters */
#ifdef USE_FULL_ASSERT
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  if (IS_CRYP_INSTANCE(hcryp->Instance))
  {
    assert_param(IS_CRYP_KEYSIZE(hcryp->Init.KeySize));
    assert_param(IS_CRYP_ALGORITHM(hcryp->Init.Algorithm));
    assert_param(IS_CRYP_KEYMODE(hcryp->Init.KeyMode));
    if (hcryp->Init.HeaderWidthUnit == CRYP_HEADERWIDTHUNIT_BYTE)
    {
      return HAL_ERROR; /* CRYP does not support BYTE as header width unit */
    }
  }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
  if (IS_SAES_INSTANCE(hcryp->Instance))
  {
    assert_param(IS_SAES_KEYSIZE(hcryp->Init.KeySize));
    assert_param(IS_SAES_ALGORITHM(hcryp->Init.Algorithm));
    assert_param(IS_SAES_KEYMODE(hcryp->Init.KeyMode));
    assert_param(IS_SAES_KEYSEL(hcryp->Init.KeySelect));
  }
#endif /* USE_HAL_SAES_ONLY */
  assert_param(IS_CRYP_DATATYPE(hcryp->Init.DataType));
  assert_param(IS_CRYP_INIT(hcryp->Init.KeyIVConfigSkip));
#endif /* USE_FULL_ASSERT */

#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
  if (hcryp->State == HAL_CRYP_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    hcryp->Lock = HAL_UNLOCKED;

    hcryp->InCpltCallback  = HAL_CRYP_InCpltCallback;  /* Legacy InCpltCallback  */
    hcryp->OutCpltCallback = HAL_CRYP_OutCpltCallback; /* Legacy OutCpltCallback */
    hcryp->ErrorCallback   = HAL_CRYP_ErrorCallback;   /* Legacy ErrorCallback   */

    if (hcryp->MspInitCallback == NULL)
    {
      hcryp->MspInitCallback = HAL_CRYP_MspInit; /* Legacy MspInit  */
    }

    /* Init the low level hardware */
    hcryp->MspInitCallback(hcryp);
  }
#else
  if (hcryp->State == HAL_CRYP_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    hcryp->Lock = HAL_UNLOCKED;

    /* Init the low level hardware */
    HAL_CRYP_MspInit(hcryp);
  }
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */

  /* Set the key size, data type and algorithm */
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  if (IS_CRYP_INSTANCE(hcryp->Instance))
  {
    MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR,
               CRYP_CR_KMOD | CRYP_CR_DATATYPE | CRYP_CR_KEYSIZE | CRYP_CR_ALGOMODE,
               hcryp->Init.KeyMode | hcryp->Init.DataType | hcryp->Init.KeySize | hcryp->Init.Algorithm);
  }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
  if (IS_SAES_INSTANCE(hcryp->Instance))
  {
    /* Reset of SAES */
    SAES_IP_RESET(hcryp);

    /* Wait for BUSY flag to go to 0 */
    if (CRYP_WaitOnBUSYFlag(hcryp, CRYP_GENERAL_TIMEOUT) != HAL_OK)
    {
      /* Disable the CRYP peripheral clock */
      __HAL_CRYP_DISABLE(hcryp);

      /* Change state */
      hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
      hcryp->State = HAL_CRYP_STATE_READY;

      /* Process unlocked */
      __HAL_UNLOCK(hcryp);
      return HAL_ERROR;
    }

    MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR,
               SAES_CR_KEYSEL | SAES_CR_KMOD | SAES_CR_DATATYPE | SAES_CR_KEYSIZE | SAES_CR_CHMOD,
               hcryp->Init.KeySelect | hcryp->Init.KeyMode | SAES_CONV_DATATYPE(hcryp->Init.DataType) | \
               SAES_CONV_KEYSIZE(hcryp->Init.KeySize) | CRYP_SAES_AlgoConversion(hcryp->Init.Algorithm,
                                                                                 ALGOMODE_CRYP_TO_CHMOD_SAES));
  }
#endif /* USE_HAL_CRYP_ONLY */

  /* Read Device ID to indicate CRYP1 IP Version */
  hcryp->Version = HAL_GetREVID();

  /* Reset Error Code field */
  hcryp->ErrorCode = HAL_CRYP_ERROR_NONE;

  /* Reset peripheral Key and IV configuration flag */
  hcryp->KeyIVConfig = 0U;

  /* Change the CRYP state */
  hcryp->State = HAL_CRYP_STATE_READY;

  /* Set the default CRYP phase */
  hcryp->Phase = CRYP_PHASE_READY;

  /* Return function status */
  return HAL_OK;
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
HAL_StatusTypeDef HAL_CRYP_DeInit(CRYP_HandleTypeDef *hcryp)
{
  /* Check the CRYP handle allocation */
  if (hcryp == NULL)
  {
    return HAL_ERROR;
  }

#if ((USE_HAL_CRYP_ONLY == 1) && (USE_HAL_SAES_ONLY == 0))
  if (IS_SAES_INSTANCE(hcryp->Instance))
  {
    return HAL_ERROR;
  }
#endif /* USE_HAL_CRYP_ONLY */

#if ((USE_HAL_CRYP_ONLY == 0) && (USE_HAL_SAES_ONLY == 1))
  if (IS_CRYP_INSTANCE(hcryp->Instance))
  {
    return HAL_ERROR;
  }
#endif /* USE_HAL_SAES_ONLY */

  /* Set the default CRYP phase */
  hcryp->Phase = CRYP_PHASE_READY;

  /* Reset CrypInCount and CrypOutCount */
  hcryp->CrypInCount = 0;
  hcryp->CrypOutCount = 0;
  hcryp->CrypHeaderCount = 0;

  /* Disable the CRYP peripheral clock */
  __HAL_CRYP_DISABLE(hcryp);

#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
  if (hcryp->MspDeInitCallback == NULL)
  {
    hcryp->MspDeInitCallback = HAL_CRYP_MspDeInit; /* Legacy MspDeInit  */
  }
  /* DeInit the low level hardware */
  hcryp->MspDeInitCallback(hcryp);

#else
  /* DeInit the low level hardware: CLOCK, NVIC.*/
  HAL_CRYP_MspDeInit(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */

  /* Change the CRYP state */
  hcryp->State = HAL_CRYP_STATE_RESET;

  /* Release Lock */
  __HAL_UNLOCK(hcryp);

  /* Return function status */
  return HAL_OK;
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
HAL_StatusTypeDef HAL_CRYP_SetConfig(CRYP_HandleTypeDef *hcryp, const CRYP_ConfigTypeDef *pConf)
{
  /* Check the CRYP handle allocation */
  if ((hcryp == NULL) || (pConf == NULL))
  {
    return HAL_ERROR;
  }

  /* Check parameters */
#ifdef USE_FULL_ASSERT
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  if (IS_CRYP_INSTANCE(hcryp->Instance))
  {
    assert_param(IS_CRYP_KEYSIZE(pConf->KeySize));
    assert_param(IS_CRYP_ALGORITHM(pConf->Algorithm));
    assert_param(IS_CRYP_KEYMODE(pConf->KeyMode));
    if (pConf->HeaderWidthUnit == CRYP_HEADERWIDTHUNIT_BYTE)
    {
      return HAL_ERROR; /* CRYP does not support BYTE as header width unit */
    }
  }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
  if (IS_SAES_INSTANCE(hcryp->Instance))
  {
    assert_param(IS_SAES_KEYSIZE(pConf->KeySize));
    assert_param(IS_SAES_ALGORITHM(pConf->Algorithm));
    assert_param(IS_SAES_KEYMODE(pConf->KeyMode));
    assert_param(IS_SAES_KEYSEL(pConf->KeySelect));
  }
#endif /* USE_HAL_SAES_ONLY */
  assert_param(IS_CRYP_DATATYPE(pConf->DataType));
  assert_param(IS_CRYP_INIT(pConf->KeyIVConfigSkip));
#endif /* USE_FULL_ASSERT */


  if (hcryp->State == HAL_CRYP_STATE_READY)
  {
    /* Change the CRYP state */
    hcryp->State = HAL_CRYP_STATE_BUSY;

    /* Process locked */
    __HAL_LOCK(hcryp);

    /* Set  CRYP parameters  */
    hcryp->Init.DataType        = pConf->DataType;
    hcryp->Init.pKey            = pConf->pKey;
    hcryp->Init.Algorithm       = pConf->Algorithm;
    hcryp->Init.KeySize         = pConf->KeySize;
    hcryp->Init.pInitVect       = pConf->pInitVect;
    hcryp->Init.Header          = pConf->Header;
    hcryp->Init.HeaderSize      = pConf->HeaderSize;
    hcryp->Init.B0              = pConf->B0;
    hcryp->Init.DataWidthUnit   = pConf->DataWidthUnit;
    hcryp->Init.HeaderWidthUnit = pConf->HeaderWidthUnit;
    hcryp->Init.KeyMode         = pConf->KeyMode;
    hcryp->Init.KeyIVConfigSkip = pConf->KeyIVConfigSkip;
    hcryp->Init.KeySelect       = pConf->KeySelect;

    /* Set the key size, data type, algo Mode and operating mode*/
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_DATATYPE | CRYP_CR_KEYSIZE | CRYP_CR_ALGOMODE,
                 hcryp->Init.DataType | hcryp->Init.KeySize | hcryp->Init.Algorithm);
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      /*in case of HSW, HW, SW or AHK key selection, we should specify Key mode selection (SAES_CR_KMOD) */
      if ((hcryp->Init.KeySelect != CRYP_KEYSEL_NORMAL) && (hcryp->Init.KeyMode == CRYP_KEYMODE_WRAPPED))
      {
        /* Set key mode selection (Normal, Wrapped or Shared key )*/
        MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_KMOD, CRYP_KEYMODE_WRAPPED);
      }

      MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, \
                 SAES_CR_KEYSEL | SAES_CR_KMOD | SAES_CR_DATATYPE | SAES_CR_KEYSIZE | SAES_CR_CHMOD,
                 hcryp->Init.KeySelect | hcryp->Init.KeyMode | SAES_CONV_DATATYPE(hcryp->Init.DataType) | \
                 SAES_CONV_KEYSIZE(hcryp->Init.KeySize) | CRYP_SAES_AlgoConversion(hcryp->Init.Algorithm,
                                                                                   ALGOMODE_CRYP_TO_CHMOD_SAES));
    }
#endif /* USE_HAL_SAES_ONLY */

    /* Process Unlocked */
    __HAL_UNLOCK(hcryp);

    /* Reset Error Code field */
    hcryp->ErrorCode = HAL_CRYP_ERROR_NONE;

    /* Change the CRYP state */
    hcryp->State = HAL_CRYP_STATE_READY;

    /* Set the default CRYP phase */
    hcryp->Phase = CRYP_PHASE_READY;

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Process Unlocked */
    __HAL_UNLOCK(hcryp);

    /* Busy error code field */
    hcryp->ErrorCode |= HAL_CRYP_ERROR_BUSY;
    return HAL_ERROR;
  }
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
HAL_StatusTypeDef HAL_CRYP_GetConfig(CRYP_HandleTypeDef *hcryp, CRYP_ConfigTypeDef *pConf)
{
  /* Check the CRYP handle allocation */
  if ((hcryp == NULL) || (pConf == NULL))
  {
    return HAL_ERROR;
  }

  if (hcryp->State == HAL_CRYP_STATE_READY)
  {
    /* Change the CRYP state */
    hcryp->State = HAL_CRYP_STATE_BUSY;

    /* Process locked */
    __HAL_LOCK(hcryp);

    /* Get  CRYP parameters  */
    pConf->DataType        = hcryp->Init.DataType;
    pConf->pKey            = hcryp->Init.pKey;
    pConf->Algorithm       = hcryp->Init.Algorithm;
    pConf->KeySize         = hcryp->Init.KeySize ;
    pConf->pInitVect       = hcryp->Init.pInitVect;
    pConf->Header          = hcryp->Init.Header ;
    pConf->HeaderSize      = hcryp->Init.HeaderSize;
    pConf->B0              = hcryp->Init.B0;
    pConf->DataWidthUnit   = hcryp->Init.DataWidthUnit;
    pConf->HeaderWidthUnit = hcryp->Init.HeaderWidthUnit;
    pConf->KeyMode         = hcryp->Init.KeyMode;
    pConf->KeySelect       = hcryp->Init.KeySelect;
    pConf->KeyIVConfigSkip = hcryp->Init.KeyIVConfigSkip;

    /* Process Unlocked */
    __HAL_UNLOCK(hcryp);

    /* Change the CRYP state */
    hcryp->State = HAL_CRYP_STATE_READY;

    /* Return function status */
    return HAL_OK;
  }
  else
  {
    /* Process Unlocked */
    __HAL_UNLOCK(hcryp);

    /* Busy error code field */
    hcryp->ErrorCode |= HAL_CRYP_ERROR_BUSY;
    return HAL_ERROR;
  }
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_CRYP_RegisterCallback(CRYP_HandleTypeDef *hcryp, HAL_CRYP_CallbackIDTypeDef CallbackID,
                                            pCRYP_CallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;

  if (pCallback == NULL)
  {
    /* Update the error code */
    hcryp->ErrorCode |= HAL_CRYP_ERROR_INVALID_CALLBACK;

    return HAL_ERROR;
  }
  /* Process locked */
  __HAL_LOCK(hcryp);

  if (hcryp->State == HAL_CRYP_STATE_READY)
  {
    switch (CallbackID)
    {
      case HAL_CRYP_INPUT_COMPLETE_CB_ID :
        hcryp->InCpltCallback = pCallback;
        break;

      case HAL_CRYP_OUTPUT_COMPLETE_CB_ID :
        hcryp->OutCpltCallback = pCallback;
        break;

      case HAL_CRYP_ERROR_CB_ID :
        hcryp->ErrorCallback = pCallback;
        break;

      case HAL_CRYP_MSPINIT_CB_ID :
        hcryp->MspInitCallback = pCallback;
        break;

      case HAL_CRYP_MSPDEINIT_CB_ID :
        hcryp->MspDeInitCallback = pCallback;
        break;

      default :
        /* Update the error code */
        hcryp->ErrorCode |= HAL_CRYP_ERROR_INVALID_CALLBACK;
        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (hcryp->State == HAL_CRYP_STATE_RESET)
  {
    switch (CallbackID)
    {
      case HAL_CRYP_MSPINIT_CB_ID :
        hcryp->MspInitCallback = pCallback;
        break;

      case HAL_CRYP_MSPDEINIT_CB_ID :
        hcryp->MspDeInitCallback = pCallback;
        break;

      default :
        /* Update the error code */
        hcryp->ErrorCode |= HAL_CRYP_ERROR_INVALID_CALLBACK;
        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hcryp->ErrorCode |= HAL_CRYP_ERROR_INVALID_CALLBACK;
    /* Return error status */
    status =  HAL_ERROR;
  }

  /* Release Lock */
  __HAL_UNLOCK(hcryp);

  return status;
}
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
HAL_StatusTypeDef HAL_CRYP_UnRegisterCallback(CRYP_HandleTypeDef *hcryp, HAL_CRYP_CallbackIDTypeDef CallbackID)
{
  HAL_StatusTypeDef status = HAL_OK;

  /* Process locked */
  __HAL_LOCK(hcryp);

  if (hcryp->State == HAL_CRYP_STATE_READY)
  {
    switch (CallbackID)
    {
      case HAL_CRYP_INPUT_COMPLETE_CB_ID :
        hcryp->InCpltCallback = HAL_CRYP_InCpltCallback;    /* Legacy InCpltCallback */
        break;

      case HAL_CRYP_OUTPUT_COMPLETE_CB_ID :
        hcryp->OutCpltCallback = HAL_CRYP_OutCpltCallback;  /* Legacy OutCpltCallback */
        break;

      case HAL_CRYP_ERROR_CB_ID :
        hcryp->ErrorCallback = HAL_CRYP_ErrorCallback;      /* Legacy ErrorCallback */
        break;

      case HAL_CRYP_MSPINIT_CB_ID :
        hcryp->MspInitCallback = HAL_CRYP_MspInit;
        break;

      case HAL_CRYP_MSPDEINIT_CB_ID :
        hcryp->MspDeInitCallback = HAL_CRYP_MspDeInit;
        break;

      default :
        /* Update the error code */
        hcryp->ErrorCode |= HAL_CRYP_ERROR_INVALID_CALLBACK;
        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else if (hcryp->State == HAL_CRYP_STATE_RESET)
  {
    switch (CallbackID)
    {
      case HAL_CRYP_MSPINIT_CB_ID :
        hcryp->MspInitCallback = HAL_CRYP_MspInit;
        break;

      case HAL_CRYP_MSPDEINIT_CB_ID :
        hcryp->MspDeInitCallback = HAL_CRYP_MspDeInit;
        break;

      default :
        /* Update the error code */
        hcryp->ErrorCode |= HAL_CRYP_ERROR_INVALID_CALLBACK;
        /* Return error status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Update the error code */
    hcryp->ErrorCode |= HAL_CRYP_ERROR_INVALID_CALLBACK;;
    /* Return error status */
    status =  HAL_ERROR;
  }

  /* Release Lock */
  __HAL_UNLOCK(hcryp);

  return status;
}
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
void HAL_CRYP_ProcessSuspend(CRYP_HandleTypeDef *hcryp)
{
  /* Set Handle SuspendRequest field */
  hcryp->SuspendRequest = HAL_CRYP_SUSPEND;
}
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
HAL_StatusTypeDef HAL_CRYP_DMAProcessSuspend(CRYP_HandleTypeDef *hcryp)
{
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
  uint32_t Timeout = CRYP_GENERAL_TIMEOUT;
#endif /* USE_HAL_SAES_ONLY */
  uint32_t tmp_remaining_DMATransferSize_inWords;
  uint32_t tmp_initial_DMATransferSize_inWords;

#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  if (IS_CRYP_INSTANCE(hcryp->Instance))
  {
    /* Stop the DMA transfers to the IN FIFO by clearing to 0 the DIEN bit in
       the CRYP_DMACR register */
    ((CRYP_TypeDef *)(hcryp->Instance))->DMACR &= (~CRYP_DMACR_DIEN);

    /* Wait until both the IN and the OUT FIFOs are empty (IFEM=1 and OFNE=0 in the
       CRYP_SR) and the BUSY bit is cleared */
    while (((((CRYP_TypeDef *)(hcryp->Instance))->SR) & (CRYP_SR_IFEM | CRYP_SR_OFNE | CRYP_SR_BUSY)) != CRYP_SR_IFEM)
    {
      /* nothing todo */
    }

    /* Stop the DMA transfers from the OUT FIFO by clearing to 0 the DOEN
      bit in the CRYP_DMACR register */
    ((CRYP_TypeDef *)(hcryp->Instance))->DMACR &= (~CRYP_DMACR_DOEN);

    /* Disable the CRYP peripheral */
    __HAL_CRYP_DISABLE(hcryp);
  }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
  if (IS_SAES_INSTANCE(hcryp->Instance))
  {
    /* Stop the DMA transfer to the IN FIFO by clearing the DMAINEN bit of the SAES_CR register */
    (((SAES_TypeDef *)(hcryp->Instance)))->CR &= (~SAES_CR_DMAINEN);

    /* Wait for CCF flag to be raised */
    if (CRYP_WaitOnCCFlag(hcryp, Timeout) != HAL_OK)
    {
      /* Disable the CRYP peripheral clock */
      __HAL_CRYP_DISABLE(hcryp);

      /* Change state */
      hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
      hcryp->State = HAL_CRYP_STATE_READY;

      /* Process unlocked */
      __HAL_UNLOCK(hcryp);
      /*Call registered error callback*/
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
      hcryp->ErrorCallback(hcryp);
#else
      /*Call legacy error callback*/
      HAL_CRYP_ErrorCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
    }

    /* Stop the DMA transfer from the OUT FIFO by clearing the DMAOUTEN bit of the SAES_CR register */
    ((SAES_TypeDef *)(hcryp->Instance))->CR &= (~SAES_CR_DMAOUTEN);

    /* Clear the CCF flag by setting the CCF bit of the SAES_ICR register */
    __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);
  }
#endif /* USE_HAL_SAES_ONLY */

  /* At this point, DMA interface is disabled and no transfer is on-going */
  /* Retrieve from the DMA handle how many words remain to be read and written */
  /* DMA3 used, DMA_CBR1_BNDT in bytes, DMA_CSR_FIFOL in words */
  tmp_remaining_DMATransferSize_inWords = ((((DMA_Channel_TypeDef *)hcryp->hdmain->Instance)->CBR1) & \
                                           DMA_CBR1_BNDT) / 4U;
  tmp_remaining_DMATransferSize_inWords += ((((DMA_Channel_TypeDef *)hcryp->hdmain->Instance)->CSR) & \
                                            DMA_CSR_FIFOL) >> DMA_CSR_FIFOL_Pos;

  /* Disable DMA channels */
  /* Note that the Abort function will
    - Clear the transfer error flags
    - Unlock
    - Set the State
  */
  if (HAL_DMA_Abort(hcryp->hdmain) != HAL_OK)
  {
    return HAL_ERROR;
  }
  if (HAL_DMA_Abort(hcryp->hdmaout) != HAL_OK)
  {
    return HAL_ERROR;
  }

  /* Compute how many words were supposed to be transferred by DMA */
  /* hcryp->CrypInCount is in bytes, must be a multiple of 4 (no padding handled for ECB or CBC) */
  tmp_initial_DMATransferSize_inWords = ((uint32_t) hcryp->Size / 4U);

  /* Accordingly, update the input and output pointers that points at the next word to be
     transferred to the Peripheral by DMA or read from the Peripheral by the DMA */
  hcryp->pCrypInBuffPtr  += (tmp_initial_DMATransferSize_inWords - tmp_remaining_DMATransferSize_inWords) ;
  hcryp->pCrypOutBuffPtr += (tmp_initial_DMATransferSize_inWords - tmp_remaining_DMATransferSize_inWords) ;

  /* And store in CrypInCount the remaining size to transfer (in words) */
  hcryp->CrypInCount  = (uint16_t)tmp_remaining_DMATransferSize_inWords;
  hcryp->CrypOutCount = (uint16_t)tmp_remaining_DMATransferSize_inWords;
  hcryp->State =  HAL_CRYP_STATE_SUSPENDED;

  return HAL_OK;

}
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
HAL_StatusTypeDef HAL_CRYP_Suspend(CRYP_HandleTypeDef *hcryp)
{
  HAL_CRYP_STATETypeDef state;
  uint32_t tmp_SAES_CR_DMAIN_bit;

  /* Request suspension */
  /* Check whether the processing is in DMA mode or not */
  tmp_SAES_CR_DMAIN_bit = (((SAES_TypeDef *)(hcryp->Instance))->CR & SAES_CR_DMAINEN);
  if ((((((CRYP_TypeDef *)(hcryp->Instance))->DMACR & CRYP_DMACR_DIEN) == CRYP_DMACR_DIEN) \
       && (IS_CRYP_INSTANCE(hcryp->Instance))) || \
      ((tmp_SAES_CR_DMAIN_bit == SAES_CR_DMAINEN) && (IS_SAES_INSTANCE(hcryp->Instance))))
  {
    if (HAL_CRYP_DMAProcessSuspend(hcryp) != HAL_OK)
    {
      return HAL_ERROR;
    }
    hcryp->SuspendedProcessing = DMA_SUSPENDED;
  }
  else
  {
    HAL_CRYP_ProcessSuspend(hcryp);
    hcryp->SuspendedProcessing = IT_SUSPENDED;
  }

  do
  {
    state = HAL_CRYP_GetState(hcryp);
  } while ((state != HAL_CRYP_STATE_SUSPENDED) && (state != HAL_CRYP_STATE_READY));

  /* Make sure there is no unwanted suspension */
  hcryp->SuspendRequest = HAL_CRYP_SUSPEND_NONE;

  if (HAL_CRYP_GetState(hcryp) == HAL_CRYP_STATE_READY)
  {
    /* Processing was already over or was about to end. No suspension done */
    return HAL_ERROR;
  }
  else
  {
    if ((hcryp->Init.Algorithm == CRYP_AES_CBC) || \
        (hcryp->Init.Algorithm == CRYP_AES_CTR) || \
        (hcryp->Init.Algorithm == CRYP_AES_GCM) || \
        (hcryp->Init.Algorithm == CRYP_AES_CCM))
    {
      /* Save Initialisation Vector registers */
      CRYP_Read_IVRegisters(hcryp, hcryp->IV_saved);
    }

#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      /* Save Control register */
      hcryp->CR_saved = ((CRYP_TypeDef *)(hcryp->Instance))->CR;

      /* Save context swap registers */
      if ((hcryp->Init.Algorithm == CRYP_AES_GCM) || (hcryp->Init.Algorithm == CRYP_AES_CCM))
      {
        CRYP_Read_ContextSwapRegisters(hcryp, hcryp->SUSPxR_saved, hcryp->Init.Algorithm);
      }
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      /* Disable AES */
      __HAL_CRYP_DISABLE(hcryp);

      /* Clear keys */
      ((SAES_TypeDef *)(hcryp->Instance))->KEYR7 = 0x0U;
      ((SAES_TypeDef *)(hcryp->Instance))->KEYR6 = 0x0U;
      ((SAES_TypeDef *)(hcryp->Instance))->KEYR5 = 0x0U;
      ((SAES_TypeDef *)(hcryp->Instance))->KEYR4 = 0x0U;
      ((SAES_TypeDef *)(hcryp->Instance))->KEYR3 = 0x0U;
      ((SAES_TypeDef *)(hcryp->Instance))->KEYR2 = 0x0U;
      ((SAES_TypeDef *)(hcryp->Instance))->KEYR1 = 0x0U;
      ((SAES_TypeDef *)(hcryp->Instance))->KEYR0 = 0x0U;

      /* Save Control register */
      hcryp->CR_saved = ((SAES_TypeDef *)(hcryp->Instance))->CR;
    }
#endif /* USE_HAL_SAES_ONLY */

    /* Save low-priority block CRYP handle parameters */
    hcryp->Init_saved              = hcryp->Init;
    hcryp->pCrypInBuffPtr_saved    = hcryp->pCrypInBuffPtr;
    hcryp->pCrypOutBuffPtr_saved   = hcryp->pCrypOutBuffPtr;
    hcryp->CrypInCount_saved       = hcryp->CrypInCount;
    hcryp->CrypOutCount_saved      = hcryp->CrypOutCount;
    hcryp->Phase_saved             = hcryp->Phase;
    hcryp->State_saved             = hcryp->State;
    hcryp->Size_saved              = ((hcryp->Init.DataWidthUnit == CRYP_DATAWIDTHUNIT_WORD) ? \
                                      (hcryp->Size / 4U) : hcryp->Size);
    hcryp->SizesSum_saved          = hcryp->SizesSum;
    hcryp->CrypHeaderCount_saved   = hcryp->CrypHeaderCount;
    hcryp->SuspendRequest          = HAL_CRYP_SUSPEND_NONE;
  }
  return HAL_OK;
}
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
HAL_StatusTypeDef HAL_CRYP_Resume(CRYP_HandleTypeDef *hcryp)
{
  /* Check the CRYP handle allocation */
  if (hcryp == NULL)
  {
    return HAL_ERROR;
  }

  if (hcryp->State_saved != HAL_CRYP_STATE_SUSPENDED)
  {
    /* CRYP was not suspended */
    return HAL_ERROR;
  }
  else
  {
    /* Restore low-priority block CRYP handle parameters */
    hcryp->Init            = hcryp->Init_saved;
    hcryp->State           = hcryp->State_saved;
    hcryp->Phase           = hcryp->Phase_saved;
    hcryp->CrypHeaderCount = hcryp->CrypHeaderCount_saved;

    /* Restore low-priority block CRYP handle parameters */
    if (hcryp->Init.Algorithm != CRYP_AES_ECB)
    {
      hcryp->Init.pInitVect = hcryp->IV_saved;
    }
    /* Set State to reset to trigger a HAL_CRYP_MspInit() call in HAL_CRYP_Init() */
    __HAL_CRYP_RESET_HANDLE_STATE(hcryp);
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      ((CRYP_TypeDef *)(hcryp->Instance))->CR |= CRYP_CR_IPRST;
      ((CRYP_TypeDef *)(hcryp->Instance))->CR &= (~CRYP_CR_IPRST);
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      ((SAES_TypeDef *)(hcryp->Instance))->CR |= SAES_CR_IPRST;
      ((SAES_TypeDef *)(hcryp->Instance))->CR &= (~SAES_CR_IPRST);
    }
#endif /* USE_HAL_SAES_ONLY */

    /* Peripheral must be disabled */
    __HAL_CRYP_DISABLE(hcryp);

    if ((hcryp->Init.Algorithm == CRYP_AES_ECB) || \
        (hcryp->Init.Algorithm == CRYP_AES_CBC) || \
        (hcryp->Init.Algorithm == CRYP_AES_CTR))
    {
      (void) HAL_CRYP_Init(hcryp);
    }
    else
    {
      /* The following lines are applicable to CRYP peripheral only */

      /* Configure again the cryptographic processor with the initial setting in CRYP_CR */
      ((CRYP_TypeDef *)(hcryp->Instance))->CR = hcryp->CR_saved;

      /* Configure again the key registers */
      CRYP_SetKey(hcryp, hcryp->Init.KeySize);

      /* Restore context swap registers */
      CRYP_Write_ContextSwapRegisters(hcryp, hcryp->SUSPxR_saved, hcryp->Init.Algorithm);

      /* Restore IV registers */
      CRYP_Write_IVRegisters(hcryp, hcryp->IV_saved);

      /* At the same time, set handle state back to READY to be able to resume the AES calculations
      without the processing APIs returning HAL_BUSY when called. */
      hcryp->State = HAL_CRYP_STATE_READY;
    }

    if (hcryp->SuspendedProcessing == DMA_SUSPENDED)
    {
      if (((IS_CRYP_INSTANCE(hcryp->Instance)) && \
           (READ_BIT(hcryp->CR_saved, CRYP_CR_ALGODIR) == CRYP_OPERATINGMODE_ENCRYPT)) || \
          ((IS_SAES_INSTANCE(hcryp->Instance)) && \
           (READ_BIT(hcryp->CR_saved, SAES_CR_MODE) == CRYP_OPERATINGMODE_ENCRYPT)))
      {
        if (HAL_CRYP_Encrypt_DMA(hcryp, hcryp->pCrypInBuffPtr_saved, (uint16_t) hcryp->CrypInCount_saved,
                                 hcryp->pCrypOutBuffPtr_saved) != HAL_OK)
        {
          return HAL_ERROR;
        }
      }
      else
      {
        if (HAL_CRYP_Decrypt_DMA(hcryp, hcryp->pCrypInBuffPtr_saved, (uint16_t) hcryp->CrypInCount_saved,
                                 hcryp->pCrypOutBuffPtr_saved) != HAL_OK)
        {
          return HAL_ERROR;
        }
      }
    }
    else
    {
      /* Resume low-priority block processing under IT */
      hcryp->ResumingFlag = 1U;

      if (((IS_CRYP_INSTANCE(hcryp->Instance)) &&
           (READ_BIT(hcryp->CR_saved, CRYP_CR_ALGODIR) == CRYP_OPERATINGMODE_ENCRYPT)) || \
          ((IS_SAES_INSTANCE(hcryp->Instance)) && \
           (READ_BIT(hcryp->CR_saved, SAES_CR_MODE) == CRYP_OPERATINGMODE_ENCRYPT)))
      {
        if (HAL_CRYP_Encrypt_IT(hcryp, hcryp->pCrypInBuffPtr_saved,
                                hcryp->Size_saved, hcryp->pCrypOutBuffPtr_saved) != HAL_OK)
        {
          return HAL_ERROR;
        }
      }
      else
      {
        if (HAL_CRYP_Decrypt_IT(hcryp, hcryp->pCrypInBuffPtr_saved,
                                hcryp->Size_saved, hcryp->pCrypOutBuffPtr_saved) != HAL_OK)
        {
          return HAL_ERROR;
        }
      }
    }
  }
  return HAL_OK;
}
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
HAL_StatusTypeDef HAL_CRYP_Encrypt(CRYP_HandleTypeDef *hcryp, uint32_t *Input, uint16_t Size, uint32_t *Output,
                                   uint32_t Timeout)
{
  uint32_t algo = 0U;
  HAL_StatusTypeDef status;

  if (hcryp->State == HAL_CRYP_STATE_READY)
  {
    /* Change state Busy */
    hcryp->State = HAL_CRYP_STATE_BUSY;

    /* Process locked */
    __HAL_LOCK(hcryp);

    /*  Reset CrypInCount, CrypOutCount and Initialize pCrypInBuffPtr, pCrypOutBuffPtr and Size parameters*/
    hcryp->CrypInCount = 0U;
    hcryp->CrypOutCount = 0U;
    hcryp->pCrypInBuffPtr = Input;
    hcryp->pCrypOutBuffPtr = Output;

    /*  Calculate Size parameter in Byte*/
    if (hcryp->Init.DataWidthUnit == CRYP_DATAWIDTHUNIT_WORD)
    {
      hcryp->Size = Size * 4U;
    }
    else
    {
      hcryp->Size = Size;
    }

    /* Set Encryption operating mode*/
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_ALGODIR, CRYP_OPERATINGMODE_ENCRYPT);

      /* algo get algorithm selected */
      algo = ((CRYP_TypeDef *)(hcryp->Instance))->CR & CRYP_CR_ALGOMODE;
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_MODE, CRYP_MODE_ENCRYPT);

      /* algo get algorithm selected */
      algo = CRYP_SAES_AlgoConversion((((SAES_TypeDef *)(hcryp->Instance))->CR & SAES_CR_CHMOD),
                                      ALGOMODE_SAES_TO_CHMOD_CRYP);
    }
#endif /* USE_HAL_SAES_ONLY */

    switch (algo)
    {
      case CRYP_AES_ECB:
      case CRYP_AES_CBC:
      case CRYP_AES_CTR:

        /* AES encryption */
        status = CRYP_AES_Encrypt(hcryp, Timeout);
        break;

      case CRYP_AES_GCM:

        /* AES GCM encryption */
        status = CRYP_AESGCM_Process(hcryp, Timeout);
        break;

      case CRYP_AES_CCM:

        /* AES CCM encryption */
        status = CRYP_AESCCM_Process(hcryp, Timeout);
        break;

      default:
        hcryp->ErrorCode |= HAL_CRYP_ERROR_NOT_SUPPORTED;
        status = HAL_ERROR;
        break;
    }

    if (status == HAL_OK)
    {
      /* Change the CRYP peripheral state */
      hcryp->State = HAL_CRYP_STATE_READY;

      /* Process unlocked */
      __HAL_UNLOCK(hcryp);
    }
  }
  else
  {
    /* Process unlocked */
    __HAL_UNLOCK(hcryp);

    /* Busy error code field */
    hcryp->ErrorCode |= HAL_CRYP_ERROR_BUSY;
    status = HAL_ERROR;
  }

  /* Return function status */
  return status ;
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
HAL_StatusTypeDef HAL_CRYP_Decrypt(CRYP_HandleTypeDef *hcryp, uint32_t *Input, uint16_t Size, uint32_t *Output,
                                   uint32_t Timeout)
{
  HAL_StatusTypeDef status;
  uint32_t algo = 0U;

  if (hcryp->State == HAL_CRYP_STATE_READY)
  {
    /* Change state Busy */
    hcryp->State = HAL_CRYP_STATE_BUSY;

    /* Process locked */
    __HAL_LOCK(hcryp);

    /*  Reset CrypInCount, CrypOutCount and Initialize pCrypInBuffPtr, pCrypOutBuffPtr and Size parameters*/
    hcryp->CrypInCount = 0U;
    hcryp->CrypOutCount = 0U;
    hcryp->pCrypInBuffPtr = Input;
    hcryp->pCrypOutBuffPtr = Output;

    /*  Calculate Size parameter in Byte*/
    if (hcryp->Init.DataWidthUnit == CRYP_DATAWIDTHUNIT_WORD)
    {
      hcryp->Size = Size * 4U;
    }
    else
    {
      hcryp->Size = Size;
    }

    /* Set Decryption operating mode*/
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_ALGODIR, CRYP_OPERATINGMODE_DECRYPT);

      /* algo get algorithm selected */
      algo = ((CRYP_TypeDef *)(hcryp->Instance))->CR & CRYP_CR_ALGOMODE;
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_MODE, CRYP_MODE_DECRYPT);

      /* algo get algorithm selected */
      algo = CRYP_SAES_AlgoConversion((((SAES_TypeDef *)(hcryp->Instance))->CR & SAES_CR_CHMOD),
                                      ALGOMODE_SAES_TO_CHMOD_CRYP);
    }
#endif /* USE_HAL_SAES_ONLY */

    switch (algo)
    {
      case CRYP_AES_ECB:
      case CRYP_AES_CBC:
      case CRYP_AES_CTR:

        /* AES decryption */
        status = CRYP_AES_Decrypt(hcryp, Timeout);
        break;

      case CRYP_AES_GCM:

        /* AES GCM decryption */
        status = CRYP_AESGCM_Process(hcryp, Timeout) ;
        break;

      case CRYP_AES_CCM:

        /* AES CCM decryption */
        status = CRYP_AESCCM_Process(hcryp, Timeout);
        break;

      default:
        hcryp->ErrorCode |= HAL_CRYP_ERROR_NOT_SUPPORTED;
        status = HAL_ERROR;
        break;
    }

    if (status == HAL_OK)
    {
      /* Change the CRYP peripheral state */
      hcryp->State = HAL_CRYP_STATE_READY;

      /* Process unlocked */
      __HAL_UNLOCK(hcryp);
    }
  }
  else
  {
    /* Process unlocked */
    __HAL_UNLOCK(hcryp);

    /* Busy error code field */
    hcryp->ErrorCode |= HAL_CRYP_ERROR_BUSY;
    status = HAL_ERROR;
  }

  /* Return function status */
  return status;
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
HAL_StatusTypeDef HAL_CRYP_Encrypt_IT(CRYP_HandleTypeDef *hcryp, uint32_t *Input, uint16_t Size, uint32_t *Output)
{
  uint32_t algo = 0U;
  HAL_StatusTypeDef status;

  if (hcryp->State == HAL_CRYP_STATE_READY)
  {
    /* Change state Busy */
    hcryp->State = HAL_CRYP_STATE_BUSY;

    /* Process locked */
    __HAL_LOCK(hcryp);

    /*  Reset CrypInCount, CrypOutCount and Initialize pCrypInBuffPtr, pCrypOutBuffPtr and Size parameters*/
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
    if (hcryp->ResumingFlag == 1U)
    {
      hcryp->ResumingFlag = 0U;
      hcryp->CrypInCount = (uint16_t) hcryp->CrypInCount_saved;
      hcryp->CrypOutCount = (uint16_t) hcryp->CrypOutCount_saved;
    }
    else
#endif  /* USE_HAL_CRYP_SUSPEND_RESUME */
    {
      hcryp->CrypInCount = 0U;
      hcryp->CrypOutCount = 0U;
    }

    hcryp->pCrypInBuffPtr = Input;
    hcryp->pCrypOutBuffPtr = Output;

    /*  Calculate Size parameter in Byte*/
    if (hcryp->Init.DataWidthUnit == CRYP_DATAWIDTHUNIT_WORD)
    {
      hcryp->Size = Size * 4U;
    }
    else
    {
      hcryp->Size = Size;
    }

    /* Set encryption operating mode*/
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_ALGODIR, CRYP_OPERATINGMODE_ENCRYPT);

      /* algo get algorithm selected */
      algo = ((CRYP_TypeDef *)(hcryp->Instance))->CR & CRYP_CR_ALGOMODE;
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_MODE, CRYP_MODE_ENCRYPT);

      /* algo get algorithm selected */
      algo = CRYP_SAES_AlgoConversion((((SAES_TypeDef *)(hcryp->Instance))->CR & SAES_CR_CHMOD),
                                      ALGOMODE_SAES_TO_CHMOD_CRYP);
    }
#endif /* USE_HAL_SAES_ONLY */

    switch (algo)
    {
      case CRYP_AES_ECB:
      case CRYP_AES_CBC:
      case CRYP_AES_CTR:

        status = CRYP_AES_Encrypt_IT(hcryp);
        break;

      case CRYP_AES_GCM:

        status = CRYP_AESGCM_Process_IT(hcryp) ;
        break;

      case CRYP_AES_CCM:

        status = CRYP_AESCCM_Process_IT(hcryp);
        break;

      default:
        hcryp->ErrorCode |= HAL_CRYP_ERROR_NOT_SUPPORTED;
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Busy error code field */
    hcryp->ErrorCode |= HAL_CRYP_ERROR_BUSY;
    status = HAL_ERROR;
  }

  /* Return function status */
  return status ;
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
HAL_StatusTypeDef HAL_CRYP_Decrypt_IT(CRYP_HandleTypeDef *hcryp, uint32_t *Input, uint16_t Size, uint32_t *Output)
{
  uint32_t algo = 0U;
  HAL_StatusTypeDef status;

  if (hcryp->State == HAL_CRYP_STATE_READY)
  {
    /* Change state Busy */
    hcryp->State = HAL_CRYP_STATE_BUSY;

    /* Process locked */
    __HAL_LOCK(hcryp);

    /*  Reset CrypInCount, CrypOutCount and Initialize pCrypInBuffPtr, pCrypOutBuffPtr and Size parameters*/
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
    if (hcryp->ResumingFlag == 1U)
    {
      hcryp->ResumingFlag = 0U;
      hcryp->CrypInCount = (uint16_t) hcryp->CrypInCount_saved;
      hcryp->CrypOutCount = (uint16_t) hcryp->CrypOutCount_saved;
    }
    else
#endif  /* USE_HAL_CRYP_SUSPEND_RESUME */
    {
      hcryp->CrypInCount = 0U;
      hcryp->CrypOutCount = 0U;
    }
    hcryp->pCrypInBuffPtr = Input;
    hcryp->pCrypOutBuffPtr = Output;

    /*  Calculate Size parameter in Byte*/
    if (hcryp->Init.DataWidthUnit == CRYP_DATAWIDTHUNIT_WORD)
    {
      hcryp->Size = Size * 4U;
    }
    else
    {
      hcryp->Size = Size;
    }

    /* Set decryption operating mode*/
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_ALGODIR, CRYP_OPERATINGMODE_DECRYPT);

      /* algo get algorithm selected */
      algo = ((CRYP_TypeDef *)(hcryp->Instance))->CR & CRYP_CR_ALGOMODE;
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_MODE, CRYP_MODE_DECRYPT);

      /* algo get algorithm selected */
      algo = CRYP_SAES_AlgoConversion((((SAES_TypeDef *)(hcryp->Instance))->CR & SAES_CR_CHMOD),
                                      ALGOMODE_SAES_TO_CHMOD_CRYP);
    }
#endif /* USE_HAL_SAES_ONLY */

    switch (algo)
    {
      case CRYP_AES_ECB:
      case CRYP_AES_CBC:
      case CRYP_AES_CTR:

        /* AES decryption */
        status = CRYP_AES_Decrypt_IT(hcryp);
        break;

      case CRYP_AES_GCM:

        /* AES GCM decryption */
        status = CRYP_AESGCM_Process_IT(hcryp) ;
        break;

      case CRYP_AES_CCM:

        /* AES CCMdecryption */
        status = CRYP_AESCCM_Process_IT(hcryp);
        break;

      default:
        hcryp->ErrorCode |= HAL_CRYP_ERROR_NOT_SUPPORTED;
        status = HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Busy error code field */
    hcryp->ErrorCode |= HAL_CRYP_ERROR_BUSY;
    status = HAL_ERROR;
  }

  /* Return function status */
  return status;
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
HAL_StatusTypeDef HAL_CRYP_Encrypt_DMA(CRYP_HandleTypeDef *hcryp, uint32_t *Input, uint16_t Size, uint32_t *Output)
{
  HAL_StatusTypeDef status = HAL_OK;
  uint32_t algo = 0U;
  uint32_t DoKeyIVConfig = 1U; /* By default, carry out peripheral Key and IV configuration */
  uint32_t tickstart;

  if (hcryp->State == HAL_CRYP_STATE_READY)
  {
    /* Change state Busy */
    hcryp->State = HAL_CRYP_STATE_BUSY;

    /* Process locked */
    __HAL_LOCK(hcryp);

    /*  Reset CrypInCount, CrypOutCount and Initialize pCrypInBuffPtr, pCrypOutBuffPtr and Size parameters*/
    hcryp->CrypInCount = 0U;
    hcryp->CrypOutCount = 0U;
    hcryp->pCrypInBuffPtr = Input;
    hcryp->pCrypOutBuffPtr = Output;

    /*  Calculate Size parameter in Byte*/
    if (hcryp->Init.DataWidthUnit == CRYP_DATAWIDTHUNIT_WORD)
    {
      hcryp->Size = Size * 4U;
    }
    else
    {
      hcryp->Size = Size;
    }

    /* Set Encryption operating mode*/
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_ALGODIR, CRYP_OPERATINGMODE_ENCRYPT);

      /* algo get algorithm selected */
      algo = ((CRYP_TypeDef *)(hcryp->Instance))->CR & CRYP_CR_ALGOMODE;
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_MODE, CRYP_MODE_ENCRYPT);

      /* algo get algorithm selected */
      algo = CRYP_SAES_AlgoConversion((((SAES_TypeDef *)(hcryp->Instance))->CR & SAES_CR_CHMOD),
                                      ALGOMODE_SAES_TO_CHMOD_CRYP);
    }
#endif /* USE_HAL_SAES_ONLY */

    switch (algo)
    {
      case CRYP_AES_ECB:
      case CRYP_AES_CBC:
      case CRYP_AES_CTR:

        if (hcryp->Init.KeyIVConfigSkip == CRYP_KEYIVCONFIG_ONCE)
        {
          if (hcryp->KeyIVConfig == 1U)
          {
            /* If the Key and IV configuration has to be done only once
               and if it has already been done, skip it */
            DoKeyIVConfig = 0U;
          }
          else
          {
            /* If the Key and IV configuration has to be done only once
               and if it has not been done already, do it and set KeyIVConfig
               to keep track it won't have to be done again next time */
            hcryp->KeyIVConfig = 1U;
          }
        }

        if (DoKeyIVConfig == 1U)
        {
          /* Set the Key */
          if ((hcryp->Init.KeySelect == CRYP_KEYSEL_NORMAL) && (hcryp->Init.KeyMode == CRYP_KEYMODE_NORMAL))
          {
            CRYP_SetKey(hcryp, hcryp->Init.KeySize);
          }

          /* Get tick */
          tickstart = HAL_GetTick();

          while (__HAL_CRYP_GET_FLAG(hcryp, CRYP_FLAG_KEYVALID) == 0x0U)
          {
            /* Check for the Timeout */
            if ((HAL_GetTick() - tickstart) > CRYP_GENERAL_TIMEOUT)
            {
              /* Disable the CRYP peripheral clock */
              __HAL_CRYP_DISABLE(hcryp);

              /* Change state */
              hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
              hcryp->State = HAL_CRYP_STATE_READY;

              /* Process unlocked */
              __HAL_UNLOCK(hcryp);
              return HAL_ERROR;
            }
          }

          /* Set the Initialization Vector*/
          if (hcryp->Init.Algorithm != CRYP_AES_ECB)
          {
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
            if (IS_CRYP_INSTANCE(hcryp->Instance))
            {
              ((CRYP_TypeDef *)(hcryp->Instance))->IV0LR = *(uint32_t *)(hcryp->Init.pInitVect);
              ((CRYP_TypeDef *)(hcryp->Instance))->IV0RR = *(uint32_t *)(hcryp->Init.pInitVect + 1U);
              ((CRYP_TypeDef *)(hcryp->Instance))->IV1LR = *(uint32_t *)(hcryp->Init.pInitVect + 2U);
              ((CRYP_TypeDef *)(hcryp->Instance))->IV1RR = *(uint32_t *)(hcryp->Init.pInitVect + 3U);
            }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
            if (IS_SAES_INSTANCE(hcryp->Instance))
            {
              ((SAES_TypeDef *)(hcryp->Instance))->IVR3 = *(uint32_t *)(hcryp->Init.pInitVect);
              ((SAES_TypeDef *)(hcryp->Instance))->IVR2 = *(uint32_t *)(hcryp->Init.pInitVect + 1U);
              ((SAES_TypeDef *)(hcryp->Instance))->IVR1 = *(uint32_t *)(hcryp->Init.pInitVect + 2U);
              ((SAES_TypeDef *)(hcryp->Instance))->IVR0 = *(uint32_t *)(hcryp->Init.pInitVect + 3U);
            }
#endif /* USE_HAL_SAES_ONLY */
          }

        } /* if (DoKeyIVConfig == 1U) */

        /* Set the phase */
        hcryp->Phase = CRYP_PHASE_PROCESS;

        /* Start DMA process transfer for AES */
        CRYP_SetDMAConfig(hcryp, (uint32_t)(hcryp->pCrypInBuffPtr), hcryp->Size, (uint32_t)(hcryp->pCrypOutBuffPtr));
        break;

      case CRYP_AES_GCM:

        /* AES GCM encryption */
        status = CRYP_AESGCM_Process_DMA(hcryp);
        break;

      case CRYP_AES_CCM:

        /* AES CCM encryption */
        status = CRYP_AESCCM_Process_DMA(hcryp);
        break;

      default:
        hcryp->ErrorCode |= HAL_CRYP_ERROR_NOT_SUPPORTED;
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Busy error code field */
    hcryp->ErrorCode |= HAL_CRYP_ERROR_BUSY;
    status =  HAL_ERROR;
  }

  /* Return function status */
  return status;
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
HAL_StatusTypeDef HAL_CRYP_Decrypt_DMA(CRYP_HandleTypeDef *hcryp, uint32_t *Input, uint16_t Size, uint32_t *Output)
{
  uint32_t algo = 0U;
  HAL_StatusTypeDef status;

  if (hcryp->State == HAL_CRYP_STATE_READY)
  {
    /* Change state Busy */
    hcryp->State = HAL_CRYP_STATE_BUSY;

    /* Process locked */
    __HAL_LOCK(hcryp);

    /*  Reset CrypInCount, CrypOutCount and Initialize pCrypInBuffPtr, pCrypOutBuffPtr and Size parameters*/
    hcryp->CrypInCount = 0U;
    hcryp->CrypOutCount = 0U;
    hcryp->pCrypInBuffPtr = Input;
    hcryp->pCrypOutBuffPtr = Output;

    /*  Calculate Size parameter in Byte*/
    if (hcryp->Init.DataWidthUnit == CRYP_DATAWIDTHUNIT_WORD)
    {
      hcryp->Size = Size * 4U;
    }
    else
    {
      hcryp->Size = Size;
    }

    /* Set decryption operating mode*/
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_ALGODIR, CRYP_OPERATINGMODE_DECRYPT);

      /* algo get algorithm selected */
      algo = ((CRYP_TypeDef *)(hcryp->Instance))->CR & CRYP_CR_ALGOMODE;
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_MODE, CRYP_MODE_DECRYPT);

      /* algo get algorithm selected */
      algo = CRYP_SAES_AlgoConversion((((SAES_TypeDef *)(hcryp->Instance))->CR & SAES_CR_CHMOD),
                                      ALGOMODE_SAES_TO_CHMOD_CRYP);
    }
#endif /* USE_HAL_SAES_ONLY */

    switch (algo)
    {
      case CRYP_AES_ECB:
      case CRYP_AES_CBC:
      case CRYP_AES_CTR:

        /* AES decryption */
        status = CRYP_AES_Decrypt_DMA(hcryp);
        break;

      case CRYP_AES_GCM:

        /* AES GCM decryption */
        status = CRYP_AESGCM_Process_DMA(hcryp);

        break;

      case CRYP_AES_CCM:

        /* AES CCM decryption */
        status = CRYP_AESCCM_Process_DMA(hcryp);
        break;

      default:
        hcryp->ErrorCode |= HAL_CRYP_ERROR_NOT_SUPPORTED;
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* Busy error code field */
    hcryp->ErrorCode |= HAL_CRYP_ERROR_BUSY;
    status = HAL_ERROR;
  }

  /* Return function status */
  return status;
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
void HAL_CRYP_IRQHandler(CRYP_HandleTypeDef *hcryp)
{
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  if (IS_CRYP_INSTANCE(hcryp->Instance))
  {
    uint32_t itstatus = ((CRYP_TypeDef *)(hcryp->Instance))->MISR;

    if ((itstatus & (CRYP_IT_INI | CRYP_IT_OUTI)) != 0U)
    {
      if ((hcryp->Init.Algorithm == CRYP_AES_ECB) || (hcryp->Init.Algorithm == CRYP_AES_CBC)
          || (hcryp->Init.Algorithm == CRYP_AES_CTR))
      {
        CRYP_AES_IT(hcryp); /*AES*/
      }

      else if ((hcryp->Init.Algorithm == CRYP_AES_GCM) || (hcryp->Init.Algorithm == CRYP_AES_CCM))
      {
        /* if header phase */
        if ((((CRYP_TypeDef *)(hcryp->Instance))->CR & CRYP_PHASE_HEADER) == CRYP_PHASE_HEADER)
        {
          CRYP_GCMCCM_SetHeaderPhase_IT(hcryp);
        }
        else  /* if payload phase */
        {
          CRYP_GCMCCM_SetPayloadPhase_IT(hcryp);
        }
      }
      else
      {
        /* Nothing to do */
      }
    }
  }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
  if (IS_SAES_INSTANCE(hcryp->Instance))
  {
    /* Check if Read or write error occurred */
    if (__HAL_CRYP_GET_IT_SOURCE(hcryp, CRYP_IT_RWEIE) != RESET)
    {
      /* If write Error occurred */
      if (__HAL_CRYP_GET_FLAG(hcryp, CRYP_FLAG_WRERR) != RESET)
      {
        hcryp->ErrorCode |= HAL_CRYP_ERROR_WRITE;
        __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_RWEIF);
      }
      /* If read Error occurred */
      if (__HAL_CRYP_GET_FLAG(hcryp, CRYP_FLAG_RDERR) != RESET)
      {
        hcryp->ErrorCode |= HAL_CRYP_ERROR_READ;
        __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_RWEIF);
      }
      /*Call error callback*/
      HAL_CRYP_ErrorCallback(hcryp);
    }
    /* Check if Key error occurred */
    if (__HAL_CRYP_GET_IT_SOURCE(hcryp, CRYP_IT_KEIE) != RESET)
    {
      if (__HAL_CRYP_GET_FLAG(hcryp, CRYP_FLAG_KEIF) != RESET)
      {
        hcryp->ErrorCode |= HAL_CRYP_ERROR_KEY;
        __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_KEIF);
        /*Call error callback*/
        HAL_CRYP_ErrorCallback(hcryp);
      }
    }
    /* Check if RNG error occurred */
    if (__HAL_CRYP_GET_IT_SOURCE(hcryp, CRYP_IT_RNGEIE) != RESET)
    {
      if (__HAL_CRYP_GET_FLAG(hcryp, CRYP_FLAG_RNGEIF) != RESET)
      {
        hcryp->ErrorCode |= HAL_CRYP_ERROR_RNG;
        /*Call error callback*/
        HAL_CRYP_ErrorCallback(hcryp);
        __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_RNGEIF);
      }
    }
    if (__HAL_CRYP_GET_FLAG(hcryp, CRYP_FLAG_CCF) != RESET)
    {
      if (__HAL_CRYP_GET_IT_SOURCE(hcryp, CRYP_IT_CCFIE) != RESET)
      {
        /* Clear computation complete flag */
        __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);

        if ((hcryp->Init.Algorithm == CRYP_AES_GCM) || (hcryp->Init.Algorithm == CRYP_AES_CCM))
        {
          /* if header phase */
          if ((((SAES_TypeDef *)(hcryp->Instance))->CR & SAES_PHASE_HEADER) == SAES_PHASE_HEADER)
          {
            CRYP_GCMCCM_SetHeaderPhase_IT(hcryp);
          }
          else  /* if payload phase */
          {
            CRYP_GCMCCM_SetPayloadPhase_IT(hcryp);
          }
        }
        else  /* AES Algorithm ECB,CBC or CTR*/
        {
          CRYP_AES_IT(hcryp);
        }
      }
    }
  }  /* if (IS_SAES_INSTANCE(hcryp->Instance)) */
#endif /* USE_HAL_SAES_ONLY */
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
uint32_t HAL_CRYP_GetError(const CRYP_HandleTypeDef *hcryp)
{
  return hcryp->ErrorCode;
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
HAL_CRYP_STATETypeDef HAL_CRYP_GetState(const CRYP_HandleTypeDef *hcryp)
{
  return hcryp->State;
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_AES_Encrypt(CRYP_HandleTypeDef *hcryp, uint32_t Timeout)
{
  uint16_t outcount;  /* Temporary CrypOutCount Value */
  uint32_t DoKeyIVConfig = 1U; /* By default, carry out peripheral Key and IV configuration */
  uint32_t tickstart;

  if (hcryp->Init.KeyIVConfigSkip == CRYP_KEYIVCONFIG_ONCE)
  {
    if (hcryp->KeyIVConfig == 1U)
    {
      /* If the Key and IV configuration has to be done only once
         and if it has already been done, skip it */
      DoKeyIVConfig = 0U;
    }
    else
    {
      /* If the Key and IV configuration has to be done only once
         and if it has not been done already, do it and set KeyIVConfig
         to keep track it won't have to be done again next time */
      hcryp->KeyIVConfig = 1U;
    }
  }

  if (DoKeyIVConfig == 1U)
  {
    /* Set the Key */
    if ((hcryp->Init.KeySelect == CRYP_KEYSEL_NORMAL) && (hcryp->Init.KeyMode == CRYP_KEYMODE_NORMAL))
    {
      CRYP_SetKey(hcryp, hcryp->Init.KeySize);
    }

    /* Get tick */
    tickstart = HAL_GetTick();

    while (__HAL_CRYP_GET_FLAG(hcryp, CRYP_FLAG_KEYVALID) == 0x0U)
    {
      /* Check for the Timeout */
      if (Timeout != HAL_MAX_DELAY)
      {
        if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
        {
          /* Disable the CRYP peripheral clock */
          __HAL_CRYP_DISABLE(hcryp);

          /* Change state */
          hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
          hcryp->State = HAL_CRYP_STATE_READY;

          /* Process unlocked */
          __HAL_UNLOCK(hcryp);
          return HAL_ERROR;
        }
      }
    }

#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      if (hcryp->Init.KeyMode == CRYP_KEYMODE_SHARED)
      {
        /* As KEYVALID is set, the key share target peripheral is initialized with a valid, shared key.
          The application can proceed with the processing of data, setting KMOD[1:0]to 00 */
        CLEAR_BIT(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_KMOD);
      }
    }
#endif /* USE_HAL_CRYP_ONLY */

    if (hcryp->Init.Algorithm != CRYP_AES_ECB)
    {
      /* Set the Initialization Vector*/
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
      if (IS_CRYP_INSTANCE(hcryp->Instance))
      {
        ((CRYP_TypeDef *)(hcryp->Instance))->IV0LR = *(uint32_t *)(hcryp->Init.pInitVect);
        ((CRYP_TypeDef *)(hcryp->Instance))->IV0RR = *(uint32_t *)(hcryp->Init.pInitVect + 1U);
        ((CRYP_TypeDef *)(hcryp->Instance))->IV1LR = *(uint32_t *)(hcryp->Init.pInitVect + 2U);
        ((CRYP_TypeDef *)(hcryp->Instance))->IV1RR = *(uint32_t *)(hcryp->Init.pInitVect + 3U);
      }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
      if (IS_SAES_INSTANCE(hcryp->Instance))
      {
        ((SAES_TypeDef *)(hcryp->Instance))->IVR3 = *(uint32_t *)(hcryp->Init.pInitVect);
        ((SAES_TypeDef *)(hcryp->Instance))->IVR2 = *(uint32_t *)(hcryp->Init.pInitVect + 1U);
        ((SAES_TypeDef *)(hcryp->Instance))->IVR1 = *(uint32_t *)(hcryp->Init.pInitVect + 2U);
        ((SAES_TypeDef *)(hcryp->Instance))->IVR0 = *(uint32_t *)(hcryp->Init.pInitVect + 3U);
      }
#endif /* USE_HAL_SAES_ONLY */
    }
  } /* if (DoKeyIVConfig == 1U) */

  /* Set the phase */
  hcryp->Phase = CRYP_PHASE_PROCESS;

  /* Enable CRYP */
  __HAL_CRYP_ENABLE(hcryp);
  /*Temporary CrypOutCount Value */
  outcount = hcryp->CrypOutCount;

  while ((hcryp->CrypInCount < (hcryp->Size / 4U)) && (outcount < (hcryp->Size / 4U)))
  {
    /* Write plain Ddta and get cipher data */
    CRYP_AES_ProcessData(hcryp, Timeout);
    /*Temporary CrypOutCount Value */
    outcount = hcryp->CrypOutCount;
  }

  /* Disable CRYP */
  __HAL_CRYP_DISABLE(hcryp);

  /* Change the CRYP state */
  hcryp->State = HAL_CRYP_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_AES_Encrypt_IT(CRYP_HandleTypeDef *hcryp)
{
  uint32_t DoKeyIVConfig = 1U; /* By default, carry out peripheral Key and IV configuration */
  uint32_t tickstart;

  if (hcryp->Init.KeyIVConfigSkip == CRYP_KEYIVCONFIG_ONCE)
  {
    if (hcryp->KeyIVConfig == 1U)
    {
      /* If the Key and IV configuration has to be done only once
         and if it has already been done, skip it */
      DoKeyIVConfig = 0U;
    }
    else
    {
      /* If the Key and IV configuration has to be done only once
         and if it has not been done already, do it and set KeyIVConfig
         to keep track it won't have to be done again next time */
      hcryp->KeyIVConfig = 1U;
    }
  }

  if (DoKeyIVConfig == 1U)
  {
    /* Set the Key */
    if ((hcryp->Init.KeySelect == CRYP_KEYSEL_NORMAL) && (hcryp->Init.KeyMode == CRYP_KEYMODE_NORMAL))
    {
      CRYP_SetKey(hcryp, hcryp->Init.KeySize);
    }

    /* Get tick */
    tickstart = HAL_GetTick();

    while (__HAL_CRYP_GET_FLAG(hcryp, CRYP_FLAG_KEYVALID) == 0x0U)
    {
      /* Check for the Timeout */
      if ((HAL_GetTick() - tickstart) > CRYP_GENERAL_TIMEOUT)
      {
        /* Disable the CRYP peripheral clock */
        __HAL_CRYP_DISABLE(hcryp);

        /* Change state */
        hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
        hcryp->State = HAL_CRYP_STATE_READY;

        /* Process unlocked */
        __HAL_UNLOCK(hcryp);
        return HAL_ERROR;
      }
    }

#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      if (hcryp->Init.KeyMode == CRYP_KEYMODE_SHARED)
      {
        /* As KEYVALID is set, the key share target peripheral is initialized with a valid, shared key.
           The application can proceed with the processing of data, setting KMOD[1:0]to 00 */
        CLEAR_BIT(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_KMOD);
      }
    }
#endif /* USE_HAL_CRYP_ONLY */

    if (hcryp->Init.Algorithm != CRYP_AES_ECB)
    {
      /* Set the Initialization Vector*/
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
      if (IS_CRYP_INSTANCE(hcryp->Instance))
      {
        ((CRYP_TypeDef *)(hcryp->Instance))->IV0LR = *(uint32_t *)(hcryp->Init.pInitVect);
        ((CRYP_TypeDef *)(hcryp->Instance))->IV0RR = *(uint32_t *)(hcryp->Init.pInitVect + 1U);
        ((CRYP_TypeDef *)(hcryp->Instance))->IV1LR = *(uint32_t *)(hcryp->Init.pInitVect + 2U);
        ((CRYP_TypeDef *)(hcryp->Instance))->IV1RR = *(uint32_t *)(hcryp->Init.pInitVect + 3U);
      }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
      if (IS_SAES_INSTANCE(hcryp->Instance))
      {
        ((SAES_TypeDef *)(hcryp->Instance))->IVR3 = *(uint32_t *)(hcryp->Init.pInitVect);
        ((SAES_TypeDef *)(hcryp->Instance))->IVR2 = *(uint32_t *)(hcryp->Init.pInitVect + 1U);
        ((SAES_TypeDef *)(hcryp->Instance))->IVR1 = *(uint32_t *)(hcryp->Init.pInitVect + 2U);
        ((SAES_TypeDef *)(hcryp->Instance))->IVR0 = *(uint32_t *)(hcryp->Init.pInitVect + 3U);
      }
#endif /* USE_HAL_SAES_ONLY */
    }
  } /* if (DoKeyIVConfig == 1U) */

  /* Set the phase */
  hcryp->Phase = CRYP_PHASE_PROCESS;

  if (hcryp->Size != 0U)
  {
    /* Enable CRYP */
    __HAL_CRYP_ENABLE(hcryp);

#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      /* Write the input block in the IN FIFO */
      ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
      hcryp->CrypInCount++;
      ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
      hcryp->CrypInCount++;
      ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
      hcryp->CrypInCount++;
      ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
      hcryp->CrypInCount++;
    }
#endif /* USE_HAL_SAES_ONLY */

    /* Enable interrupts */
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      __HAL_CRYP_ENABLE_IT(hcryp, CRYP_IT_INI | CRYP_IT_OUTI);
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      __HAL_CRYP_ENABLE_IT(hcryp, CRYP_IT_CCFIE | CRYP_IT_RWEIE | CRYP_IT_KEIE | CRYP_IT_RNGEIE);
    }
#endif /* USE_HAL_SAES_ONLY */
  }
  else
  {
    /* Change the CRYP state */
    hcryp->State = HAL_CRYP_STATE_READY;

    /* Process unlocked */
    __HAL_UNLOCK(hcryp);
  }

  /* Return function status */
  return HAL_OK;
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_AES_Decrypt(CRYP_HandleTypeDef *hcryp, uint32_t Timeout)
{
  uint16_t outcount;  /* Temporary CrypOutCount Value */
  uint32_t DoKeyIVConfig = 1U; /* By default, carry out peripheral Key and IV configuration */

  if (hcryp->Init.KeyIVConfigSkip == CRYP_KEYIVCONFIG_ONCE)
  {
    if (hcryp->KeyIVConfig == 1U)
    {
      /* If the Key and IV configuration has to be done only once
         and if it has already been done, skip it */
      DoKeyIVConfig = 0U;
    }
    else
    {
      /* If the Key and IV configuration has to be done only once
         and if it has not been done already, do it and set KeyIVConfig
         to keep track it won't have to be done again next time */
      hcryp->KeyIVConfig = 1U;
    }
  }

  if (DoKeyIVConfig == 1U)
  {
    /*  Key preparation for ECB/CBC */
    if (hcryp->Init.Algorithm != CRYP_AES_CTR)   /*ECB or CBC*/
    {
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
      if (IS_CRYP_INSTANCE(hcryp->Instance))
      {
        /* change ALGOMODE to key preparation for decryption*/
        MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_ALGOMODE, CRYP_AES_KEY);

        /* Set the Key */
        if (hcryp->Init.KeyIVConfigSkip != CRYP_KEYNOCONFIG)
        {
          if (hcryp->Init.KeyMode != CRYP_KEYMODE_SHARED)
          {
            CRYP_SetKey(hcryp, hcryp->Init.KeySize);
          }
        }

        /* Enable CRYP */
        __HAL_CRYP_ENABLE(hcryp);

        /* Wait for BUSY flag go to 0 */
        if (CRYP_WaitOnBUSYFlag(hcryp, Timeout) != HAL_OK)
        {
          /* Disable the CRYP peripheral clock */
          __HAL_CRYP_DISABLE(hcryp);

          /* Change state */
          hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
          hcryp->State = HAL_CRYP_STATE_READY;

          /* Process unlocked */
          __HAL_UNLOCK(hcryp);
          return HAL_ERROR;
        }
        /* Turn back to ALGOMODE of the configuration */
        MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_ALGOMODE, hcryp->Init.Algorithm);
      }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
      if (IS_SAES_INSTANCE(hcryp->Instance))
      {
        /* When KMOD[1:0] = 01 (wrapped key) or  KMOD[1:0] = 01 (shared key)
           and MODE[1:0] = 10 (decryption), then a read access to
          SAES_DOUTR register triggers a read error (RDERR). So, clear KMOD for the upcoming deciphering */
        if (((((SAES_TypeDef *)(hcryp->Instance))->CR) & (CRYP_KEYMODE_WRAPPED | CRYP_KEYMODE_SHARED)) != 0U)
        {
          MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_KMOD, CRYP_KEYMODE_NORMAL);
        }
        /* key preparation for decryption, operating mode 2*/
        MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_MODE, CRYP_MODE_KEY_DERIVATION);

        /* we should re-write Key, in the case where we change key after first operation*/
        if ((hcryp->Init.KeySelect == CRYP_KEYSEL_NORMAL) && (hcryp->Init.KeyMode == CRYP_KEYMODE_NORMAL))
        {
          if (hcryp->Init.KeyIVConfigSkip != CRYP_KEYNOCONFIG)
          {
            CRYP_SetKey(hcryp, hcryp->Init.KeySize);
          }
        }

        /* Enable SAES */
        __HAL_CRYP_ENABLE(hcryp);

        /* Wait for CCF flag to be raised */
        if (CRYP_WaitOnCCFlag(hcryp, Timeout) != HAL_OK)
        {
          /* Disable the CRYP peripheral clock */
          __HAL_CRYP_DISABLE(hcryp);

          /* Change state & update error code */
          hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
          hcryp->State = HAL_CRYP_STATE_READY;

          /* Process unlocked */
          __HAL_UNLOCK(hcryp);
          return HAL_ERROR;
        }
        /* Clear CCF Flag */
        __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);

        /*  End of Key preparation for ECB/CBC */
        /* Return to decryption operating mode(Mode 3)*/
        MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_MODE, CRYP_MODE_DECRYPT);
      } /* if (IS_SAES_INSTANCE(hcryp->Instance)) */
#endif /* USE_HAL_SAES_ONLY */
    }
    else  /*Algorithm CTR */
    {
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
      if (IS_CRYP_INSTANCE(hcryp->Instance))
      {
        /* Set the Key */
        if (hcryp->Init.KeyIVConfigSkip != CRYP_KEYNOCONFIG)
        {
          if (hcryp->Init.KeyMode != CRYP_KEYMODE_SHARED)
          {
            CRYP_SetKey(hcryp, hcryp->Init.KeySize);
          }
          else /*after sharing the key, AES should set KMOD[1:0] to 00.*/
          {
            ((CRYP_TypeDef *)(hcryp->Instance))->CR &=  ~CRYP_KEYMODE_SHARED;
          }
        }
      }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
      if (IS_SAES_INSTANCE(hcryp->Instance))
      {
        /* Set the Key */
        CRYP_SetKey(hcryp, hcryp->Init.KeySize);
      }
#endif /* USE_HAL_SAES_ONLY */
    }

    /* Set IV */
    if (hcryp->Init.Algorithm != CRYP_AES_ECB)
    {
      /* Set the Initialization Vector*/
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
      if (IS_CRYP_INSTANCE(hcryp->Instance))
      {
        ((CRYP_TypeDef *)(hcryp->Instance))->IV0LR = *(uint32_t *)(hcryp->Init.pInitVect);
        ((CRYP_TypeDef *)(hcryp->Instance))->IV0RR = *(uint32_t *)(hcryp->Init.pInitVect + 1U);
        ((CRYP_TypeDef *)(hcryp->Instance))->IV1LR = *(uint32_t *)(hcryp->Init.pInitVect + 2U);
        ((CRYP_TypeDef *)(hcryp->Instance))->IV1RR = *(uint32_t *)(hcryp->Init.pInitVect + 3U);
      }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
      if (IS_SAES_INSTANCE(hcryp->Instance))
      {
        ((SAES_TypeDef *)(hcryp->Instance))->IVR3 = *(uint32_t *)(hcryp->Init.pInitVect);
        ((SAES_TypeDef *)(hcryp->Instance))->IVR2 = *(uint32_t *)(hcryp->Init.pInitVect + 1U);
        ((SAES_TypeDef *)(hcryp->Instance))->IVR1 = *(uint32_t *)(hcryp->Init.pInitVect + 2U);
        ((SAES_TypeDef *)(hcryp->Instance))->IVR0 = *(uint32_t *)(hcryp->Init.pInitVect + 3U);
      }
#endif /* USE_HAL_SAES_ONLY */
    }
  } /* if (DoKeyIVConfig == 1U) */

  /* Set the phase */
  hcryp->Phase = CRYP_PHASE_PROCESS;

  /* Enable CRYP */
  __HAL_CRYP_ENABLE(hcryp);

  /*Temporary CrypOutCount Value */
  outcount = hcryp->CrypOutCount;

  while ((hcryp->CrypInCount < (hcryp->Size / 4U)) && (outcount < (hcryp->Size / 4U)))
  {
    /* Write plain data and get cipher data */
    CRYP_AES_ProcessData(hcryp, Timeout);
    /*Temporary CrypOutCount Value */
    outcount = hcryp->CrypOutCount;
  }

  /* Disable CRYP */
  __HAL_CRYP_DISABLE(hcryp);

  /* Change the CRYP state */
  hcryp->State = HAL_CRYP_STATE_READY;

  /* Return function status */
  return HAL_OK;
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_AES_Decrypt_IT(CRYP_HandleTypeDef *hcryp)
{
  uint32_t DoKeyIVConfig = 1U; /* By default, carry out peripheral Key and IV configuration */
  uint32_t Timeout = CRYP_GENERAL_TIMEOUT;

  if (hcryp->Init.KeyIVConfigSkip == CRYP_KEYIVCONFIG_ONCE)
  {
    if (hcryp->KeyIVConfig == 1U)
    {
      /* If the Key and IV configuration has to be done only once
         and if it has already been done, skip it */
      DoKeyIVConfig = 0U;
    }
    else
    {
      /* If the Key and IV configuration has to be done only once
         and if it has not been done already, do it and set KeyIVConfig
         to keep track it won't have to be done again next time */
      hcryp->KeyIVConfig = 1U;
    }
  }

  if (DoKeyIVConfig == 1U)
  {
    /*  Key preparation for ECB/CBC */
    if (hcryp->Init.Algorithm != CRYP_AES_CTR)
    {
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
      if (IS_CRYP_INSTANCE(hcryp->Instance))
      {
        /* change ALGOMODE to key preparation for decryption*/
        MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_ALGOMODE, CRYP_AES_KEY);

        /* Set the Key */
        if (hcryp->Init.KeyIVConfigSkip != CRYP_KEYNOCONFIG)
        {
          if (hcryp->Init.KeyMode != CRYP_KEYMODE_SHARED)
          {
            CRYP_SetKey(hcryp, hcryp->Init.KeySize);
          }
          else /*after sharing the key, AES should set KMOD[1:0] to 00.*/
          {
            ((CRYP_TypeDef *)(hcryp->Instance))->CR &=  ~CRYP_KEYMODE_SHARED;
          }
        }

        /* Enable CRYP */
        __HAL_CRYP_ENABLE(hcryp);

        /* Wait for BUSY flag go to 0 */
        if (CRYP_WaitOnBUSYFlag(hcryp, Timeout) != HAL_OK)
        {
          /* Disable the CRYP peripheral clock */
          __HAL_CRYP_DISABLE(hcryp);

          /* Change state */
          hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
          hcryp->State = HAL_CRYP_STATE_READY;

          /* Process unlocked */
          __HAL_UNLOCK(hcryp);
          return HAL_ERROR;
        }

        /* Turn back to ALGOMODE of the configuration */
        MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_ALGOMODE, hcryp->Init.Algorithm);
      }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
      if (IS_SAES_INSTANCE(hcryp->Instance))
      {
        /* When KMOD[1:0] = 01 (wrapped key) or  KMOD[1:0] = 01 (shared key)
           and MODE[1:0] = 10 (decryption), then a read access to
          SAES_DOUTR register triggers a read error (RDERR). So, clear KMOD for the upcoming deciphering */
        if (((((SAES_TypeDef *)(hcryp->Instance))->CR) & (CRYP_KEYMODE_WRAPPED | CRYP_KEYMODE_SHARED)) != 0U)
        {
          MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_KMOD, CRYP_KEYMODE_NORMAL);
        }
        /* key preparation for decryption, operating mode 2*/
        MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_MODE, CRYP_MODE_KEY_DERIVATION);

        /* we should re-write Key, in the case where we change key after first operation*/
        if ((hcryp->Init.KeySelect == CRYP_KEYSEL_NORMAL) && (hcryp->Init.KeyMode == CRYP_KEYMODE_NORMAL))
        {
          if (hcryp->Init.KeyIVConfigSkip != CRYP_KEYNOCONFIG)
          {
            CRYP_SetKey(hcryp, hcryp->Init.KeySize);
          }
        }

        /* Enable SAES */
        __HAL_CRYP_ENABLE(hcryp);

        /* Wait for CCF flag to be raised */
        if (CRYP_WaitOnCCFlag(hcryp, Timeout) != HAL_OK)
        {
          /* Disable the CRYP peripheral clock */
          __HAL_CRYP_DISABLE(hcryp);

          /* Change state & update error code */
          hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
          hcryp->State = HAL_CRYP_STATE_READY;

          /* Process unlocked */
          __HAL_UNLOCK(hcryp);
          return HAL_ERROR;
        }
        /* Clear CCF Flag */
        __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);

        /*  End of Key preparation for ECB/CBC */
        /* Return to decryption operating mode(Mode 3)*/
        MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_MODE, CRYP_MODE_DECRYPT);
      } /* if (IS_SAES_INSTANCE(hcryp->Instance)) */
#endif /* USE_HAL_SAES_ONLY */
    }
    else  /*Algorithm CTR */
    {
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
      if (IS_CRYP_INSTANCE(hcryp->Instance))
      {
        /* Set the Key */
        if (hcryp->Init.KeyIVConfigSkip != CRYP_KEYNOCONFIG)
        {
          if (hcryp->Init.KeyMode != CRYP_KEYMODE_SHARED)
          {
            CRYP_SetKey(hcryp, hcryp->Init.KeySize);
          }
          else /*after sharing the key, AES should set KMOD[1:0] to 00.*/
          {
            ((CRYP_TypeDef *)(hcryp->Instance))->CR &=  ~CRYP_KEYMODE_SHARED;
          }
        }
      }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
      if (IS_SAES_INSTANCE(hcryp->Instance))
      {
        /* Set the Key */
        CRYP_SetKey(hcryp, hcryp->Init.KeySize);
      }
#endif /* USE_HAL_SAES_ONLY */
    } /* if (hcryp->Init.Algorithm != CRYP_AES_CTR) */

    /* Set IV */
    if (hcryp->Init.Algorithm != CRYP_AES_ECB)
    {
      /* Set the Initialization Vector*/
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
      if (IS_CRYP_INSTANCE(hcryp->Instance))
      {
        ((CRYP_TypeDef *)(hcryp->Instance))->IV0LR = *(uint32_t *)(hcryp->Init.pInitVect);
        ((CRYP_TypeDef *)(hcryp->Instance))->IV0RR = *(uint32_t *)(hcryp->Init.pInitVect + 1U);
        ((CRYP_TypeDef *)(hcryp->Instance))->IV1LR = *(uint32_t *)(hcryp->Init.pInitVect + 2U);
        ((CRYP_TypeDef *)(hcryp->Instance))->IV1RR = *(uint32_t *)(hcryp->Init.pInitVect + 3U);
      }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
      if (IS_SAES_INSTANCE(hcryp->Instance))
      {
        ((SAES_TypeDef *)(hcryp->Instance))->IVR3 = *(uint32_t *)(hcryp->Init.pInitVect);
        ((SAES_TypeDef *)(hcryp->Instance))->IVR2 = *(uint32_t *)(hcryp->Init.pInitVect + 1U);
        ((SAES_TypeDef *)(hcryp->Instance))->IVR1 = *(uint32_t *)(hcryp->Init.pInitVect + 2U);
        ((SAES_TypeDef *)(hcryp->Instance))->IVR0 = *(uint32_t *)(hcryp->Init.pInitVect + 3U);
      }
#endif /* USE_HAL_SAES_ONLY */
    }
  } /* if (DoKeyIVConfig == 1U) */

  /* Set the phase */
  hcryp->Phase = CRYP_PHASE_PROCESS;
  if (hcryp->Size != 0U)
  {
    /* Enable CRYP */
    __HAL_CRYP_ENABLE(hcryp);

#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      /* Write the input block in the IN FIFO */
      ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
      hcryp->CrypInCount++;
      ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
      hcryp->CrypInCount++;
      ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
      hcryp->CrypInCount++;
      ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
      hcryp->CrypInCount++;
    }
#endif /* USE_HAL_SAES_ONLY */

    /* Enable interrupts */
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      __HAL_CRYP_ENABLE_IT(hcryp, CRYP_IT_INI | CRYP_IT_OUTI);
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      __HAL_CRYP_ENABLE_IT(hcryp, CRYP_IT_CCFIE | CRYP_IT_RWEIE | CRYP_IT_KEIE | CRYP_IT_RNGEIE);
    }
#endif /* USE_HAL_SAES_ONLY */
  }
  else
  {
    /* Process locked */
    __HAL_UNLOCK(hcryp);

    /* Change the CRYP state */
    hcryp->State = HAL_CRYP_STATE_READY;
  }
  /* Return function status */
  return HAL_OK;
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_AES_Decrypt_DMA(CRYP_HandleTypeDef *hcryp)
{
  uint32_t DoKeyIVConfig = 1U; /* By default, carry out peripheral Key and IV configuration */
  uint32_t Timeout = CRYP_GENERAL_TIMEOUT;

  if (hcryp->Init.KeyIVConfigSkip == CRYP_KEYIVCONFIG_ONCE)
  {
    if (hcryp->KeyIVConfig == 1U)
    {
      /* If the Key and IV configuration has to be done only once
         and if it has already been done, skip it */
      DoKeyIVConfig = 0U;
    }
    else
    {
      /* If the Key and IV configuration has to be done only once
         and if it has not been done already, do it and set KeyIVConfig
         to keep track it won't have to be done again next time */
      hcryp->KeyIVConfig = 1U;
    }
  }

  if (DoKeyIVConfig == 1U)
  {
    if (hcryp->Init.Algorithm != CRYP_AES_CTR)   /*ECB or CBC*/
    {
      /*  Key preparation for ECB/CBC */
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
      if (IS_CRYP_INSTANCE(hcryp->Instance))
      {
        /* change ALGOMODE to key preparation for decryption*/
        MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_ALGOMODE, CRYP_AES_KEY);

        /* Set the Key */
        if (hcryp->Init.KeyIVConfigSkip != CRYP_KEYNOCONFIG)
        {
          if (hcryp->Init.KeyMode != CRYP_KEYMODE_SHARED)
          {
            CRYP_SetKey(hcryp, hcryp->Init.KeySize);
          }
          else /*after sharing the key, AES should set KMOD[1:0] to 00.*/
          {
            ((CRYP_TypeDef *)(hcryp->Instance))->CR &=  ~CRYP_KEYMODE_SHARED;
          }
        }

        /* Enable CRYP */
        __HAL_CRYP_ENABLE(hcryp);

        /* Wait for BUSY flag go to 0 */
        if (CRYP_WaitOnBUSYFlag(hcryp, Timeout) != HAL_OK)
        {
          /* Disable the CRYP peripheral clock */
          __HAL_CRYP_DISABLE(hcryp);

          /* Change state */
          hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
          hcryp->State = HAL_CRYP_STATE_READY;

          /* Process unlocked */
          __HAL_UNLOCK(hcryp);
          return HAL_ERROR;
        }
        /* Turn back to ALGOMODE of the configuration */
        MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_ALGOMODE, hcryp->Init.Algorithm);
      }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
      if (IS_SAES_INSTANCE(hcryp->Instance))
      {
        /* When KMOD[1:0] = 01 (wrapped key) or  KMOD[1:0] = 01 (shared key)
           and MODE[1:0] = 10 (decryption), then a read access to
          SAES_DOUTR register triggers a read error (RDERR). So, clear KMOD for the upcoming deciphering */
        if (((((SAES_TypeDef *)(hcryp->Instance))->CR) & (CRYP_KEYMODE_WRAPPED | CRYP_KEYMODE_SHARED)) != 0U)
        {
          MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_KMOD, CRYP_KEYMODE_NORMAL);
        }
        /* key preparation for decryption, operating mode 2*/
        MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_MODE, CRYP_MODE_KEY_DERIVATION);

        /* we should re-write Key, in the case where we change key after first operation*/
        if ((hcryp->Init.KeySelect == CRYP_KEYSEL_NORMAL) && (hcryp->Init.KeyMode == CRYP_KEYMODE_NORMAL))
        {
          if (hcryp->Init.KeyIVConfigSkip != CRYP_KEYNOCONFIG)
          {
            CRYP_SetKey(hcryp, hcryp->Init.KeySize);
          }
        }

        /* Enable SAES */
        __HAL_CRYP_ENABLE(hcryp);

        /* Wait for CCF flag to be raised */
        if (CRYP_WaitOnCCFlag(hcryp, Timeout) != HAL_OK)
        {
          /* Disable the CRYP peripheral clock */
          __HAL_CRYP_DISABLE(hcryp);

          /* Change state & update error code */
          hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
          hcryp->State = HAL_CRYP_STATE_READY;

          /* Process unlocked */
          __HAL_UNLOCK(hcryp);
          return HAL_ERROR;
        }
        /* Clear CCF Flag */
        __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);

        /*  End of Key preparation for ECB/CBC */
        /* Return to decryption operating mode(Mode 3) */
        MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_MODE, CRYP_MODE_DECRYPT);

      } /* if (IS_SAES_INSTANCE(hcryp->Instance)) */
#endif /* USE_HAL_SAES_ONLY */
    }
    else  /*Algorithm CTR */
    {
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
      if (IS_CRYP_INSTANCE(hcryp->Instance))
      {
        /* Set the Key */
        if (hcryp->Init.KeyIVConfigSkip != CRYP_KEYNOCONFIG)
        {
          if (hcryp->Init.KeyMode != CRYP_KEYMODE_SHARED)
          {
            CRYP_SetKey(hcryp, hcryp->Init.KeySize);
          }
          else /*after sharing the key, AES should set KMOD[1:0] to 00.*/
          {
            ((CRYP_TypeDef *)(hcryp->Instance))->CR &= ~CRYP_KEYMODE_SHARED;
          }
        }
      }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
      if (IS_SAES_INSTANCE(hcryp->Instance))
      {
        /* Set the Key */
        CRYP_SetKey(hcryp, hcryp->Init.KeySize);
      }
#endif /* USE_HAL_SAES_ONLY */
    }

    if (hcryp->Init.Algorithm != CRYP_AES_ECB)
    {
      /* Set the Initialization Vector*/
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
      if (IS_CRYP_INSTANCE(hcryp->Instance))
      {
        ((CRYP_TypeDef *)(hcryp->Instance))->IV0LR = *(uint32_t *)(hcryp->Init.pInitVect);
        ((CRYP_TypeDef *)(hcryp->Instance))->IV0RR = *(uint32_t *)(hcryp->Init.pInitVect + 1U);
        ((CRYP_TypeDef *)(hcryp->Instance))->IV1LR = *(uint32_t *)(hcryp->Init.pInitVect + 2U);
        ((CRYP_TypeDef *)(hcryp->Instance))->IV1RR = *(uint32_t *)(hcryp->Init.pInitVect + 3U);
      }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
      if (IS_SAES_INSTANCE(hcryp->Instance))
      {
        ((SAES_TypeDef *)(hcryp->Instance))->IVR3 = *(uint32_t *)(hcryp->Init.pInitVect);
        ((SAES_TypeDef *)(hcryp->Instance))->IVR2 = *(uint32_t *)(hcryp->Init.pInitVect + 1U);
        ((SAES_TypeDef *)(hcryp->Instance))->IVR1 = *(uint32_t *)(hcryp->Init.pInitVect + 2U);
        ((SAES_TypeDef *)(hcryp->Instance))->IVR0 = *(uint32_t *)(hcryp->Init.pInitVect + 3U);
      }
#endif /* IS_SAES_INSTANCE */
    }
  } /* if (DoKeyIVConfig == 1U) */

  /* Set the phase */
  hcryp->Phase = CRYP_PHASE_PROCESS;

  if (hcryp->Size != 0U)
  {
    /* Start DMA process transfer for AES */
    CRYP_SetDMAConfig(hcryp, (uint32_t)(hcryp->pCrypInBuffPtr), hcryp->Size, (uint32_t)(hcryp->pCrypOutBuffPtr));
  }
  else
  {
    /* Process unlocked */
    __HAL_UNLOCK(hcryp);

    /* Change the CRYP state */
    hcryp->State = HAL_CRYP_STATE_READY;
  }

  /* Return function status */
  return HAL_OK;
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static void CRYP_DMAInCplt(DMA_HandleTypeDef *hdma)
{
  CRYP_HandleTypeDef *hcryp = (CRYP_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  if (IS_CRYP_INSTANCE(hcryp->Instance))
  {
    /* Disable the DMA transfer for input FIFO request by resetting the DIEN bit
       in the DMACR register */
    ((CRYP_TypeDef *)(hcryp->Instance))->DMACR &= (uint32_t)(~CRYP_DMACR_DIEN);
  }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
  if (IS_SAES_INSTANCE(hcryp->Instance))
  {
    /* Disable the DMA transfer for input FIFO request by resetting the DMAINEN bit
       in the CR register */
    ((SAES_TypeDef *)(hcryp->Instance))->CR &= (uint32_t)(~SAES_CR_DMAINEN);
  }
#endif /* USE_HAL_SAES_ONLY */

  /* Call input data transfer complete callback */
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
  /*Call registered Input complete callback*/
  hcryp->InCpltCallback(hcryp);
#else
  /*Call legacy Input complete callback*/
  HAL_CRYP_InCpltCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static void CRYP_DMAOutCplt(DMA_HandleTypeDef *hdma)
{
  uint32_t count;
  uint32_t npblb;
  uint32_t lastwordsize;
  uint32_t temp;            /* Temporary CrypOutBuff */
  uint32_t mode;

  CRYP_HandleTypeDef *hcryp = (CRYP_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;


  /* Disable the DMA transfer for output FIFO */
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  if (IS_CRYP_INSTANCE(hcryp->Instance))
  {
    ((CRYP_TypeDef *)(hcryp->Instance))->DMACR &= (uint32_t)(~CRYP_DMACR_DOEN);
  }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
  if (IS_SAES_INSTANCE(hcryp->Instance))
  {
    ((SAES_TypeDef *)(hcryp->Instance))->CR &= (uint32_t)(~SAES_CR_DMAOUTEN);

    /* Disable the DMA transfer for output FIFO request by resetting
    the DOEN bit in the DMACR register */
    CLEAR_BIT(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_DMAOUTEN);
  }
#endif /* USE_HAL_SAES_ONLY */

  /* Last block transfer in case of GCM or CCM with Size not %16 */
  /* Applicable to CRYP peripheral only */
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  if (IS_CRYP_INSTANCE(hcryp->Instance))
  {
    if (((hcryp->Size) % 16U) != 0U)
    {
      /* set CrypInCount and CrypOutCount to exact number of word already computed via DMA  */
      hcryp->CrypInCount = (hcryp->Size / 16U) * 4U;
      hcryp->CrypOutCount = hcryp->CrypInCount;

      /* Compute the number of padding bytes in last block of payload */
      npblb = ((((uint32_t)(hcryp->Size) / 16U) + 1U) * 16U) - (uint32_t)(hcryp->Size);

      /* Case of AES GCM payload encryption or AES CCM payload decryption to get right tag */
      mode = CRYP_CONV_ALGODIR(((SAES_TypeDef *)(hcryp->Instance))->CR & SAES_CR_MODE);
      if (((mode == CRYP_OPERATINGMODE_ENCRYPT) && (hcryp->Init.Algorithm == CRYP_AES_GCM)) ||
          ((mode == CRYP_OPERATINGMODE_DECRYPT) && (hcryp->Init.Algorithm == CRYP_AES_CCM)))
      {
        /* Disable the CRYP */
        __HAL_CRYP_DISABLE(hcryp);

        /* Specify the number of non-valid bytes using NPBLB register*/
        MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_NPBLB, npblb << 20);

        /* Enable CRYP to start the final phase */
        __HAL_CRYP_ENABLE(hcryp);
      }

      /* Number of valid words (lastwordsize) in last block */
      if ((npblb % 4U) == 0U)
      {
        lastwordsize = (16U - npblb) / 4U;
      }
      else
      {
        lastwordsize = ((16U - npblb) / 4U) + 1U;
      }
      /* Write the last input block in the IN FIFO */
      for (count = 0U; count < lastwordsize; count ++)
      {
        ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
        hcryp->CrypInCount++;
      }
      /* Pad the data with zeros to have a complete block */
      while (count < 4U)
      {
        ((CRYP_TypeDef *)(hcryp->Instance))->DIN = 0U;
        count++;
      }
      /* Wait for OFNE flag to be raised */
      count = CRYP_TIMEOUT_GCMCCMHEADERPHASE;
      do
      {
        count-- ;
        if (count == 0U)
        {
          /* Disable the CRYP peripheral clock */
          __HAL_CRYP_DISABLE(hcryp);

          /* Change state */
          hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
          hcryp->State = HAL_CRYP_STATE_READY;

          /* Process unlocked */
          __HAL_UNLOCK(hcryp);
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
          /*Call registered error callback*/
          hcryp->ErrorCallback(hcryp);
#else
          /*Call legacy error callback*/
          HAL_CRYP_ErrorCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
        }
      } while (HAL_IS_BIT_CLR(((CRYP_TypeDef *)(hcryp->Instance))->SR, CRYP_FLAG_OFNE));

      /*Read the output block from the output FIFO */
      for (count = 0U; count < 4U; count++)
      {
        /* Read the output block from the output FIFO and put them in temporary buffer then get CrypOutBuff from
           temporary buffer */
        temp = ((CRYP_TypeDef *)(hcryp->Instance))->DOUT;

        *(uint32_t *)(hcryp->pCrypOutBuffPtr + (hcryp->CrypOutCount)) = temp;
        hcryp->CrypOutCount++;
      }
    } /*End of last block transfer in case of GCM or CCM */
  }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
  if (IS_SAES_INSTANCE(hcryp->Instance))
  {
    temp = 0;
    /* Last block transfer in case of GCM or CCM with Size not %16*/
    if (((hcryp->Size) % 16U) != 0U)
    {
      /* set CrypInCount and CrypOutCount to exact number of words already computed via DMA */
      hcryp->CrypInCount = (hcryp->Size / 16U) * 4U;
      hcryp->CrypOutCount = hcryp->CrypInCount;

      /* Compute the number of padding bytes in last block of payload */
      npblb = ((((uint32_t)hcryp->Size / 16U) + 1U) * 16U) - ((uint32_t)hcryp->Size);

      mode = CRYP_CONV_ALGODIR(((SAES_TypeDef *)(hcryp->Instance))->CR & SAES_CR_MODE);
      if (((mode == CRYP_OPERATINGMODE_ENCRYPT) && (hcryp->Init.Algorithm == CRYP_AES_GCM)) ||
          ((mode == CRYP_OPERATINGMODE_DECRYPT) && (hcryp->Init.Algorithm == CRYP_AES_CCM)))
      {
        /* Specify the number of non-valid bytes using NPBLB register*/
        MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_NPBLB, npblb << 20U);
      }

      /* Number of valid words (lastwordsize) in last block */
      if ((npblb % 4U) == 0U)
      {
        lastwordsize = (16U - npblb) / 4U;
      }
      else
      {
        lastwordsize = ((16U - npblb) / 4U) + 1U;
      }

      /*  Last block optionally pad the data with zeros*/
      for (count = 0U; count < lastwordsize; count++)
      {
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
        hcryp->CrypInCount++;
      }
      while (count < 4U)
      {
        /* Pad the data with zeros to have a complete block */
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = 0x0U;
        count++;
      }

      /* Clear CCF flag */
      __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);

      /*Read the output block from the output FIFO */
      for (count = 0U; count < 4U; count++)
      {
        /* Read the output block from the output FIFO and put them in temporary buffer
           then get CrypOutBuff from temporary buffer */
        temp = ((SAES_TypeDef *)(hcryp->Instance))->DOUTR;
      }

      count = 0U;
      while ((hcryp->CrypOutCount < ((hcryp->Size + 3U) / 4U)) && (count < 4U))
      {
        *(uint32_t *)(hcryp->pCrypOutBuffPtr + hcryp->CrypOutCount) = temp;
        hcryp->CrypOutCount++;
        count++;
      }
    }
  } /* if (IS_SAES_INSTANCE(hcryp->Instance)) */
#endif /* USE_HAL_SAES_ONLY */

  if (((hcryp->Init.Algorithm & CRYP_AES_GCM) != CRYP_AES_GCM)
      && ((hcryp->Init.Algorithm & CRYP_AES_CCM) != CRYP_AES_CCM))
  {
    /* Disable CRYP  (not allowed in GCM) */
    __HAL_CRYP_DISABLE(hcryp);
  }

  /* Change the CRYP state to ready */
  hcryp->State = HAL_CRYP_STATE_READY;

  /* Process unlocked */
  __HAL_UNLOCK(hcryp);

  /* Call output data transfer complete callback */
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
  /*Call registered Output complete callback*/
  hcryp->OutCpltCallback(hcryp);
#else
  /*Call legacy Output complete callback*/
  HAL_CRYP_OutCpltCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static void CRYP_DMAError(DMA_HandleTypeDef *hdma)
{
  CRYP_HandleTypeDef *hcryp = (CRYP_HandleTypeDef *)((DMA_HandleTypeDef *)hdma)->Parent;

  /* Change the CRYP peripheral state */
  hcryp->State = HAL_CRYP_STATE_READY;

  /* DMA error code field */
  hcryp->ErrorCode |= HAL_CRYP_ERROR_DMA;

  /* Call error callback */
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
  /*Call registered error callback*/
  hcryp->ErrorCallback(hcryp);
#else
  /*Call legacy error callback*/
  HAL_CRYP_ErrorCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static void CRYP_SetDMAConfig(CRYP_HandleTypeDef *hcryp, uint32_t inputaddr, uint16_t Size, uint32_t outputaddr)
{
  HAL_StatusTypeDef status;
  uint32_t peripheral_in_address = 0U;
  uint32_t peripheral_out_address = 0U;

  /* Set the CRYP DMA transfer complete callback */
  hcryp->hdmain->XferCpltCallback = CRYP_DMAInCplt;

  /* Set the DMA input error callback */
  hcryp->hdmain->XferErrorCallback = CRYP_DMAError;

  /* Set the CRYP DMA transfer complete callback */
  hcryp->hdmaout->XferCpltCallback = CRYP_DMAOutCplt;

  /* Set the DMA output error callback */
  hcryp->hdmaout->XferErrorCallback = CRYP_DMAError;

  /* Enable CRYP */
  __HAL_CRYP_ENABLE(hcryp);

#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  if (IS_CRYP_INSTANCE(hcryp->Instance))
  {
    peripheral_in_address  = (uint32_t) &((CRYP_TypeDef *)(hcryp->Instance))->DIN;
    peripheral_out_address = (uint32_t) &((CRYP_TypeDef *)(hcryp->Instance))->DOUT;
  }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
  if (IS_SAES_INSTANCE(hcryp->Instance))
  {
    peripheral_in_address  = (uint32_t) &((SAES_TypeDef *)(hcryp->Instance))->DINR;
    peripheral_out_address = (uint32_t) &((SAES_TypeDef *)(hcryp->Instance))->DOUTR;
  }
#endif /* USE_HAL_SAES_ONLY */

  /* Enable the DMA input channel */
  if ((hcryp->hdmain->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
  {
    if ((hcryp->hdmain->LinkedListQueue != NULL) && (hcryp->hdmain->LinkedListQueue->Head != NULL))
    {
      /* Enable the DMA channel */
      hcryp->hdmain->LinkedListQueue->Head->\
      LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = Size; /* Set DMA data size */
      hcryp->hdmain->LinkedListQueue->Head->\
      LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = inputaddr; /* Set DMA source address */
      hcryp->hdmain->LinkedListQueue->Head->\
      LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = peripheral_in_address; /* Set DMA destination address */

      status = HAL_DMAEx_List_Start_IT(hcryp->hdmain);
    }
    else
    {
      /* Return error status */
      status = HAL_ERROR;
    }
  }
  else
  {
    status = HAL_DMA_Start_IT(hcryp->hdmain, inputaddr, peripheral_in_address, Size);
  }

  if (status != HAL_OK)
  {
    /* DMA error code field */
    hcryp->ErrorCode |= HAL_CRYP_ERROR_DMA;

    /* Call error callback */
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
    /*Call registered error callback*/
    hcryp->ErrorCallback(hcryp);
#else
    /*Call legacy error callback*/
    HAL_CRYP_ErrorCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
  }

  /* Enable the DMA output channel */
  if ((hcryp->hdmaout->Mode & DMA_LINKEDLIST) == DMA_LINKEDLIST)
  {
    if ((hcryp->hdmaout->LinkedListQueue != NULL) && (hcryp->hdmaout->LinkedListQueue->Head != NULL))
    {
      /* Enable the DMA channel */
      hcryp->hdmaout->LinkedListQueue->Head->LinkRegisters[NODE_CBR1_DEFAULT_OFFSET] = \
          Size; /* Set DMA data size           */
      hcryp->hdmaout->LinkedListQueue->Head->LinkRegisters[NODE_CSAR_DEFAULT_OFFSET] = \
          peripheral_out_address;    /* Set DMA source address      */
      hcryp->hdmaout->LinkedListQueue->Head->LinkRegisters[NODE_CDAR_DEFAULT_OFFSET] = \
          outputaddr;   /* Set DMA destination address */

      status = HAL_DMAEx_List_Start_IT(hcryp->hdmaout);
    }
    else
    {
      /* Return error status */
      status = HAL_ERROR;
    }
  }
  else
  {
    status = HAL_DMA_Start_IT(hcryp->hdmaout, peripheral_out_address, outputaddr, Size);
  }

  if (status != HAL_OK)
  {
    /* DMA error code field */
    hcryp->ErrorCode |= HAL_CRYP_ERROR_DMA;

    /* Call error callback */
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
    /*Call registered error callback*/
    hcryp->ErrorCallback(hcryp);
#else
    /*Call legacy error callback*/
    HAL_CRYP_ErrorCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
  }

  /* Enable In/Out DMA request */
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  if (IS_CRYP_INSTANCE(hcryp->Instance))
  {
    ((CRYP_TypeDef *)(hcryp->Instance))->DMACR = (CRYP_DMACR_DOEN | CRYP_DMACR_DIEN);
  }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
  if (IS_SAES_INSTANCE(hcryp->Instance))
  {
    ((SAES_TypeDef *)(hcryp->Instance))->CR |= (SAES_CR_DMAINEN | SAES_CR_DMAOUTEN);
  }
#endif /* USE_HAL_SAES_ONLY */
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static void CRYP_AES_ProcessData(CRYP_HandleTypeDef *hcryp, uint32_t Timeout)
{
  uint32_t temp[4] = {0};/* Temporary CrypOutBuff */
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  uint16_t incount;  /* Temporary CrypInCount Value */
  uint16_t outcount;  /* Temporary CrypOutCount Value */
#endif /* USE_HAL_CRYP_ONLY */
  uint32_t i;

#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  if (IS_CRYP_INSTANCE(hcryp->Instance))
  {
    /*Temporary CrypOutCount Value */
    incount = hcryp->CrypInCount;

    if (((((CRYP_TypeDef *)(hcryp->Instance))->SR & CRYP_FLAG_IFNF) != 0x0U) && (incount < ((hcryp->Size) / 4U)))
    {
      /* Write the input block in the IN FIFO */
      ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
      hcryp->CrypInCount++;
      ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
      hcryp->CrypInCount++;
      ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
      hcryp->CrypInCount++;
      ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
      hcryp->CrypInCount++;
    }

    /* Wait for OFNE flag to be raised */
    if (CRYP_WaitOnOFNEFlag(hcryp, Timeout) != HAL_OK)
    {
      /* Disable the CRYP peripheral clock */
      __HAL_CRYP_DISABLE(hcryp);

      /* Change state & update error code */
      hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
      hcryp->State = HAL_CRYP_STATE_READY;

      /* Process unlocked */
      __HAL_UNLOCK(hcryp);
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
      /*Call registered error callback*/
      hcryp->ErrorCallback(hcryp);
#else
      /*Call legacy error callback*/
      HAL_CRYP_ErrorCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
    }
    /*Temporary CrypOutCount Value */
    outcount = hcryp->CrypOutCount;

    if (((((CRYP_TypeDef *)(hcryp->Instance))->SR & CRYP_FLAG_OFNE) != 0x0U) && (outcount < ((hcryp->Size) / 4U)))
    {
      /* Read the output block from the Output FIFO and put them in temporary buffer then get CrypOutBuff from
         temporary buffer  */
      for (i = 0U; i < 4U; i++)
      {
        temp[i] = ((CRYP_TypeDef *)(hcryp->Instance))->DOUT;
      }
      i = 0U;
      while (((hcryp->CrypOutCount < ((hcryp->Size) / 4U))) && (i < 4U))
      {
        *(uint32_t *)(hcryp->pCrypOutBuffPtr + hcryp->CrypOutCount) = temp[i];
        hcryp->CrypOutCount++;
        i++;
      }
    }
  }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
  if (IS_SAES_INSTANCE(hcryp->Instance))
  {
    /* Write the input block in the IN FIFO */
    ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
    hcryp->CrypInCount++;
    ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
    hcryp->CrypInCount++;
    ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
    hcryp->CrypInCount++;
    ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
    hcryp->CrypInCount++;

    /* Wait for CCF flag to be raised */
    if (CRYP_WaitOnCCFlag(hcryp, Timeout) != HAL_OK)
    {
      /* Disable the CRYP peripheral clock */
      __HAL_CRYP_DISABLE(hcryp);

      /* Change state */
      hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
      hcryp->State = HAL_CRYP_STATE_READY;

      /* Process unlocked */
      __HAL_UNLOCK(hcryp);
      /*Call registered error callback*/
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
      hcryp->ErrorCallback(hcryp);
#else
      /*Call legacy error callback*/
      HAL_CRYP_ErrorCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
    }

    /* Clear CCF Flag */
    __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);

    /* Read the output block from the output FIFO and put them in temporary buffer then
       get CrypOutBuff from temporary buffer*/

    for (i = 0U; i < 4U; i++)
    {
      temp[i] = ((SAES_TypeDef *)(hcryp->Instance))->DOUTR;
    }
    i = 0U;
    while ((hcryp->CrypOutCount < ((hcryp->Size + 3U) / 4U)) && (i < 4U))
    {
      *(uint32_t *)(hcryp->pCrypOutBuffPtr + hcryp->CrypOutCount) = temp[i];
      hcryp->CrypOutCount++;
      i++;
    }
  } /* if (IS_SAES_INSTANCE(hcryp->Instance)) */
#endif /* USE_HAL_SAES_ONLY */
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static void CRYP_AES_IT(CRYP_HandleTypeDef *hcryp)
{
  uint32_t temp[4] = {0};/* Temporary CrypOutBuff */

#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  uint16_t incount;  /* Temporary CrypInCount Value */
  uint16_t outcount;  /* Temporary CrypOutCount Value */
#endif /* USE_HAL_CRYP_ONLY */
  uint32_t i;

  if (hcryp->State == HAL_CRYP_STATE_BUSY)
  {
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
      /* If suspension flag has been raised, suspend processing
         only if not already at the end of the payload */
      if (hcryp->SuspendRequest == HAL_CRYP_SUSPEND)
      {
        /* Wait until both the IN and the OUT FIFOs are empty (IFEM=1 and OFNE=0 in the
           CRYP_SR) and the BUSY bit is cleared */
        while (((((CRYP_TypeDef *)(hcryp->Instance))->SR) & (CRYP_SR_IFEM | CRYP_SR_OFNE | \
                                                             CRYP_SR_BUSY)) != CRYP_SR_IFEM)
        {
          /* Nothing to do */
        }

        /* Disable interrupts */
        __HAL_CRYP_DISABLE_IT(hcryp, CRYP_IT_INI | CRYP_IT_OUTI);

        /* Disable CRYP */
        __HAL_CRYP_DISABLE(hcryp);

        /* reset SuspendRequest */
        hcryp->SuspendRequest = HAL_CRYP_SUSPEND_NONE;

        /* Change the CRYP state */
        hcryp->State = HAL_CRYP_STATE_SUSPENDED;

        /* Process Unlocked */
        __HAL_UNLOCK(hcryp);
      }
      else
#endif /* USE_HAL_CRYP_SUSPEND_RESUME */
      {
        /*Temporary CrypOutCount Value */
        incount = hcryp->CrypInCount;

        if (((((CRYP_TypeDef *)(hcryp->Instance))->SR & CRYP_FLAG_IFNF) != 0x0U) && (incount < (hcryp->Size / 4U)))
        {
          /* Write the input block in the IN FIFO */
          ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
          hcryp->CrypInCount++;
          ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
          hcryp->CrypInCount++;
          ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
          hcryp->CrypInCount++;
          ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
          hcryp->CrypInCount++;
          if (hcryp->CrypInCount == (hcryp->Size / 4U))
          {
            /* Disable interrupts */
            __HAL_CRYP_DISABLE_IT(hcryp, CRYP_IT_INI);

            /* Call the input data transfer complete callback */
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
            /*Call registered Input complete callback*/
            hcryp->InCpltCallback(hcryp);
#else
            /*Call legacy Input complete callback*/
            HAL_CRYP_InCpltCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
          }
        }

        /*Temporary CrypOutCount Value */
        outcount = hcryp->CrypOutCount;

        if (((((CRYP_TypeDef *)(hcryp->Instance))->SR & CRYP_FLAG_OFNE) != 0x0U) && (outcount < (hcryp->Size / 4U)))
        {
          /* Read the output block from the output FIFO and put them in temporary buffer then get CrypOutBuff from
             temporary buffer  */
          for (i = 0U; i < 4U; i++)
          {
            temp[i] = ((CRYP_TypeDef *)(hcryp->Instance))->DOUT;
          }
          i = 0U;
          while (((hcryp->CrypOutCount < ((hcryp->Size) / 4U))) && (i < 4U))
          {
            *(uint32_t *)(hcryp->pCrypOutBuffPtr + hcryp->CrypOutCount) = temp[i];
            hcryp->CrypOutCount++;
            i++;
          }
          if (hcryp->CrypOutCount == (hcryp->Size / 4U))
          {
            /* Disable interrupts */
            __HAL_CRYP_DISABLE_IT(hcryp, CRYP_IT_OUTI);

            /* Change the CRYP state */
            hcryp->State = HAL_CRYP_STATE_READY;

            /* Disable CRYP */
            __HAL_CRYP_DISABLE(hcryp);

            /* Process unlocked */
            __HAL_UNLOCK(hcryp);

            /* Call output transfer complete callback */
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
            /*Call registered Output complete callback*/
            hcryp->OutCpltCallback(hcryp);
#else
            /*Call legacy Output complete callback*/
            HAL_CRYP_OutCpltCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
          }
        }
      } /* if (hcryp->SuspendRequest == HAL_CRYP_SUSPEND) */
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      /* Read the output block from the output FIFO and put them in temporary buffer then
      get CrypOutBuff from temporary buffer*/
      for (i = 0U; i < 4U; i++)
      {
        temp[i] = ((SAES_TypeDef *)(hcryp->Instance))->DOUTR;
      }
      i = 0U;
      while ((hcryp->CrypOutCount < ((hcryp->Size + 3U) / 4U)) && (i < 4U))
      {
        *(uint32_t *)(hcryp->pCrypOutBuffPtr + hcryp->CrypOutCount) = temp[i];
        hcryp->CrypOutCount++;
        i++;
      }
      if (hcryp->CrypOutCount == (hcryp->Size / 4U))
      {
        /* Disable Computation Complete flag and errors interrupts */
        __HAL_CRYP_DISABLE_IT(hcryp, CRYP_IT_CCFIE | CRYP_IT_RWEIE | CRYP_IT_KEIE);

        /* Change the CRYP state */
        hcryp->State = HAL_CRYP_STATE_READY;

        /* Disable CRYP */
        __HAL_CRYP_DISABLE(hcryp);
        __HAL_UNLOCK(hcryp);

        /* Call Output transfer complete callback */
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
        /*Call registered Output complete callback*/
        hcryp->OutCpltCallback(hcryp);
#else
        /*Call legacy Output complete callback*/
        HAL_CRYP_OutCpltCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
      }
      else
      {
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
        /* If suspension flag has been raised, suspend processing
           only if not already at the end of the payload */
        if (hcryp->SuspendRequest == HAL_CRYP_SUSPEND)
        {
          /* Clear CCF Flag */
          __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);

          /* reset SuspendRequest */
          hcryp->SuspendRequest = HAL_CRYP_SUSPEND_NONE;

          /* Disable Computation Complete Flag and Errors Interrupts */
          __HAL_CRYP_DISABLE_IT(hcryp, CRYP_IT_CCFIE | CRYP_IT_RWEIE | CRYP_IT_KEIE);

          /* Change the CRYP state */
          hcryp->State = HAL_CRYP_STATE_SUSPENDED;

          /* Mark that the payload phase is suspended */
          hcryp->Phase = CRYP_PHASE_PAYLOAD_SUSPENDED;

          __HAL_UNLOCK(hcryp);
        }
        else
#endif /* USE_HAL_CRYP_SUSPEND_RESUME */
        {
          /* Write the input block in the IN FIFO */
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
          hcryp->CrypInCount++;
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
          hcryp->CrypInCount++;
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
          hcryp->CrypInCount++;
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
          hcryp->CrypInCount++;

          if (hcryp->CrypInCount == (hcryp->Size / 4U))
          {
            /* Call Input transfer complete callback */
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
            /*Call registered Input complete callback*/
            hcryp->InCpltCallback(hcryp);
#else
            /*Call legacy Input complete callback*/
            HAL_CRYP_InCpltCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
          }
        }
      } /* if (hcryp->CrypOutCount == (hcryp->Size / 4U)) */
    } /* if (IS_SAES_INSTANCE(hcryp->Instance)) */
#endif /* USE_HAL_SAES_ONLY */
  }
  else
  {
    /* Process unlocked */
    __HAL_UNLOCK(hcryp);
    /* Busy error code field */
    hcryp->ErrorCode |= HAL_CRYP_ERROR_BUSY;
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
    /*Call registered error callback*/
    hcryp->ErrorCallback(hcryp);
#else
    /*Call legacy error callback*/
    HAL_CRYP_ErrorCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
  }
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static void CRYP_SetKey(CRYP_HandleTypeDef *hcryp, uint32_t KeySize)
{
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  if (IS_CRYP_INSTANCE(hcryp->Instance))
  {
    switch (KeySize)
    {
      case CRYP_KEYSIZE_256B:
        ((CRYP_TypeDef *)(hcryp->Instance))->K0LR = *(uint32_t *)(hcryp->Init.pKey);
        ((CRYP_TypeDef *)(hcryp->Instance))->K0RR = *(uint32_t *)(hcryp->Init.pKey + 1);
        ((CRYP_TypeDef *)(hcryp->Instance))->K1LR = *(uint32_t *)(hcryp->Init.pKey + 2);
        ((CRYP_TypeDef *)(hcryp->Instance))->K1RR = *(uint32_t *)(hcryp->Init.pKey + 3);
        ((CRYP_TypeDef *)(hcryp->Instance))->K2LR = *(uint32_t *)(hcryp->Init.pKey + 4);
        ((CRYP_TypeDef *)(hcryp->Instance))->K2RR = *(uint32_t *)(hcryp->Init.pKey + 5);
        ((CRYP_TypeDef *)(hcryp->Instance))->K3LR = *(uint32_t *)(hcryp->Init.pKey + 6);
        ((CRYP_TypeDef *)(hcryp->Instance))->K3RR = *(uint32_t *)(hcryp->Init.pKey + 7);
        break;

      case CRYP_KEYSIZE_192B:
        ((CRYP_TypeDef *)(hcryp->Instance))->K1LR = *(uint32_t *)(hcryp->Init.pKey);
        ((CRYP_TypeDef *)(hcryp->Instance))->K1RR = *(uint32_t *)(hcryp->Init.pKey + 1);
        ((CRYP_TypeDef *)(hcryp->Instance))->K2LR = *(uint32_t *)(hcryp->Init.pKey + 2);
        ((CRYP_TypeDef *)(hcryp->Instance))->K2RR = *(uint32_t *)(hcryp->Init.pKey + 3);
        ((CRYP_TypeDef *)(hcryp->Instance))->K3LR = *(uint32_t *)(hcryp->Init.pKey + 4);
        ((CRYP_TypeDef *)(hcryp->Instance))->K3RR = *(uint32_t *)(hcryp->Init.pKey + 5);
        break;

      case CRYP_KEYSIZE_128B:
        ((CRYP_TypeDef *)(hcryp->Instance))->K2LR = *(uint32_t *)(hcryp->Init.pKey);
        ((CRYP_TypeDef *)(hcryp->Instance))->K2RR = *(uint32_t *)(hcryp->Init.pKey + 1);
        ((CRYP_TypeDef *)(hcryp->Instance))->K3LR = *(uint32_t *)(hcryp->Init.pKey + 2);
        ((CRYP_TypeDef *)(hcryp->Instance))->K3RR = *(uint32_t *)(hcryp->Init.pKey + 3);
        break;

      default:
        break;
    }
  }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
  if (IS_SAES_INSTANCE(hcryp->Instance))
  {
    if (hcryp->Init.pKey != NULL)
    {
      switch (KeySize)
      {
        case CRYP_KEYSIZE_256B:
          ((SAES_TypeDef *)(hcryp->Instance))->KEYR7 = *(uint32_t *)(hcryp->Init.pKey);
          ((SAES_TypeDef *)(hcryp->Instance))->KEYR6 = *(uint32_t *)(hcryp->Init.pKey + 1U);
          ((SAES_TypeDef *)(hcryp->Instance))->KEYR5 = *(uint32_t *)(hcryp->Init.pKey + 2U);
          ((SAES_TypeDef *)(hcryp->Instance))->KEYR4 = *(uint32_t *)(hcryp->Init.pKey + 3U);
          ((SAES_TypeDef *)(hcryp->Instance))->KEYR3 = *(uint32_t *)(hcryp->Init.pKey + 4U);
          ((SAES_TypeDef *)(hcryp->Instance))->KEYR2 = *(uint32_t *)(hcryp->Init.pKey + 5U);
          ((SAES_TypeDef *)(hcryp->Instance))->KEYR1 = *(uint32_t *)(hcryp->Init.pKey + 6U);
          ((SAES_TypeDef *)(hcryp->Instance))->KEYR0 = *(uint32_t *)(hcryp->Init.pKey + 7U);
          break;
        case CRYP_KEYSIZE_128B:
          ((SAES_TypeDef *)(hcryp->Instance))->KEYR3 = *(uint32_t *)(hcryp->Init.pKey);
          ((SAES_TypeDef *)(hcryp->Instance))->KEYR2 = *(uint32_t *)(hcryp->Init.pKey + 1U);
          ((SAES_TypeDef *)(hcryp->Instance))->KEYR1 = *(uint32_t *)(hcryp->Init.pKey + 2U);
          ((SAES_TypeDef *)(hcryp->Instance))->KEYR0 = *(uint32_t *)(hcryp->Init.pKey + 3U);

          break;
        default:
          break;
      }
    } /*  if (hcryp->Init.pKey != NULL) */
  } /* if (IS_SAES_INSTANCE(hcryp->Instance)) */
#endif /* USE_HAL_SAES_ONLY */
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_AESGCM_Process(CRYP_HandleTypeDef *hcryp, uint32_t Timeout)
{
  uint32_t tickstart;
  uint32_t wordsize = (uint32_t)(hcryp->Size) / 4U;
  uint32_t npblb ;
  uint32_t temp[4] = {0};/* Temporary CrypOutBuff */
  uint32_t index ;
  uint32_t lastwordsize ;
  uint32_t outcount;  /* Temporary CrypOutCount Value */
  uint32_t DoKeyIVConfig = 1U; /* By default, carry out peripheral Key and IV configuration */
  uint32_t mode;

  if (hcryp->Init.KeyIVConfigSkip == CRYP_KEYIVCONFIG_ONCE)
  {
    if (hcryp->KeyIVConfig == 1U)
    {
      /* If the Key and IV configuration has to be done only once
         and if it has already been done, skip it */
      DoKeyIVConfig = 0U;
      hcryp->SizesSum += hcryp->Size; /* Compute message total payload length */
    }
    else
    {
      /* If the Key and IV configuration has to be done only once
         and if it has not been done already, do it and set KeyIVConfig
         to keep track it won't have to be done again next time */
      hcryp->KeyIVConfig = 1U;
      hcryp->SizesSum = hcryp->Size; /* Merely store payload length */
    }
  }
  else
  {
    hcryp->SizesSum = hcryp->Size;
  }

  if (DoKeyIVConfig == 1U)
  {
    /*  Reset CrypHeaderCount */
    hcryp->CrypHeaderCount = 0U;

    /****************************** Init phase **********************************/
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      CRYP_SET_PHASE(hcryp, CRYP_PHASE_INIT);

      /* Set the Key */
      if (hcryp->Init.KeyIVConfigSkip != CRYP_KEYNOCONFIG)
      {
        if (hcryp->Init.KeyMode != CRYP_KEYMODE_SHARED)
        {
          CRYP_SetKey(hcryp, hcryp->Init.KeySize);
        }
        else /*after sharing the key, AES should set KMOD[1:0] to 00.*/
        {
          ((CRYP_TypeDef *)(hcryp->Instance))->CR &=  ~CRYP_KEYMODE_SHARED;
        }
      }

      /* Set the initialization vector and the counter : Initial Counter Block (ICB)*/
      ((CRYP_TypeDef *)(hcryp->Instance))->IV0LR = *(uint32_t *)(hcryp->Init.pInitVect);
      ((CRYP_TypeDef *)(hcryp->Instance))->IV0RR = *(uint32_t *)(hcryp->Init.pInitVect + 1);
      ((CRYP_TypeDef *)(hcryp->Instance))->IV1LR = *(uint32_t *)(hcryp->Init.pInitVect + 2);
      ((CRYP_TypeDef *)(hcryp->Instance))->IV1RR = *(uint32_t *)(hcryp->Init.pInitVect + 3);

      /* Enable the CRYP peripheral */
      __HAL_CRYP_ENABLE(hcryp);

      /* Get tick */
      tickstart = HAL_GetTick();

      /*Wait for the CRYPEN bit to be cleared*/
      while ((((CRYP_TypeDef *)(hcryp->Instance))->CR & CRYP_CR_CRYPEN) == CRYP_CR_CRYPEN)
      {
        /* Check for the Timeout */
        if (Timeout != HAL_MAX_DELAY)
        {
          if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
          {
            /* Disable the CRYP peripheral clock */
            __HAL_CRYP_DISABLE(hcryp);

            /* Change state */
            hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
            hcryp->State = HAL_CRYP_STATE_READY;

            /* Process unlocked */
            __HAL_UNLOCK(hcryp);
            return HAL_ERROR;
          }
        }
      }
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      SAES_SET_PHASE(hcryp, SAES_PHASE_INIT);

      /* We should re-write Key, in the case where we change key after first operation */
      if ((hcryp->Init.KeySelect == CRYP_KEYSEL_NORMAL) && (hcryp->Init.KeyMode == CRYP_KEYMODE_NORMAL))
      {
        /* Set the Key */
        CRYP_SetKey(hcryp, hcryp->Init.KeySize);
      }

      /* Set the initialization vector and the counter : Initial Counter Block (ICB)*/
      ((SAES_TypeDef *)(hcryp->Instance))->IVR3 = *(uint32_t *)(hcryp->Init.pInitVect);
      ((SAES_TypeDef *)(hcryp->Instance))->IVR2 = *(uint32_t *)(hcryp->Init.pInitVect + 1);
      ((SAES_TypeDef *)(hcryp->Instance))->IVR1 = *(uint32_t *)(hcryp->Init.pInitVect + 2);
      ((SAES_TypeDef *)(hcryp->Instance))->IVR0 = *(uint32_t *)(hcryp->Init.pInitVect + 3);

      /* Enable the CRYP peripheral */
      __HAL_CRYP_ENABLE(hcryp);

      /* just wait for hash computation */
      if (CRYP_WaitOnCCFlag(hcryp, Timeout) != HAL_OK)
      {
        /* Disable the CRYP peripheral clock */
        __HAL_CRYP_DISABLE(hcryp);

        /* Change state */
        hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
        hcryp->State = HAL_CRYP_STATE_READY;

        /* Process unlocked */
        __HAL_UNLOCK(hcryp);
        return HAL_ERROR;
      }
      /* Clear CCF flag */
      __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);
    }
#endif /* USE_HAL_SAES_ONLY */

    /************************ Header phase *************************************/

    if (CRYP_GCMCCM_SetHeaderPhase(hcryp,  Timeout) != HAL_OK)
    {
      return HAL_ERROR;
    }

    /*************************Payload phase ************************************/

    /* Set the phase */
    hcryp->Phase = CRYP_PHASE_PROCESS;

    /* Select payload phase once the header phase is performed */
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      /* Disable the CRYP peripheral */
      __HAL_CRYP_DISABLE(hcryp);

      /* Select payload phase once the header phase is performed */
      CRYP_SET_PHASE(hcryp, CRYP_PHASE_PAYLOAD);

      /* Set to 0 the number of non-valid bytes using NPBLB register*/
      MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_NPBLB, 0U);

      /* Enable the CRYP peripheral */
      __HAL_CRYP_ENABLE(hcryp);
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      /* Select payload phase once the header phase is performed */
      SAES_SET_PHASE(hcryp, SAES_PHASE_PAYLOAD);

      /* Set to 0 the number of non-valid bytes using NPBLB register*/
      MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_NPBLB, 0U);
    }
#endif /* USE_HAL_SAES_ONLY */

  } /* if (DoKeyIVConfig == 1U) */

  if ((hcryp->Size % 16U) != 0U)
  {
    /* recalculate  wordsize */
    wordsize = ((wordsize / 4U) * 4U) ;
  }

  /* Get tick */
  tickstart = HAL_GetTick();

  /*Temporary CrypOutCount Value */
  outcount = hcryp->CrypOutCount;
  /* Write input data and get output data */
  while ((hcryp->CrypInCount < wordsize) && (outcount < wordsize))
  {
    /* Write plain data and get cipher data */
    CRYP_AES_ProcessData(hcryp, Timeout);

    /*Temporary CrypOutCount Value */
    outcount = hcryp->CrypOutCount;

    /* Check for the Timeout */
    if (Timeout != HAL_MAX_DELAY)
    {
      if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
      {
        /* Disable the CRYP peripheral clock */
        __HAL_CRYP_DISABLE(hcryp);

        /* Change state */
        hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
        hcryp->State = HAL_CRYP_STATE_READY;

        /* Process unlocked */
        __HAL_UNLOCK(hcryp);
        return HAL_ERROR;
      }
    }
  }

  if ((hcryp->Size % 16U) != 0U)
  {
    /* Compute the number of padding bytes in last block of payload */
    npblb = ((((uint32_t)(hcryp->Size) / 16U) + 1U) * 16U) - (uint32_t)(hcryp->Size);

    /*  Set Npblb in case of AES GCM payload encryption to get right tag */
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      mode = ((CRYP_TypeDef *)(hcryp->Instance))->CR & CRYP_CR_ALGODIR;
      if (mode == CRYP_OPERATINGMODE_ENCRYPT)
      {
        /* Disable the CRYP */
        __HAL_CRYP_DISABLE(hcryp);

        /* Specify the number of non-valid bytes using NPBLB register */
        MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_NPBLB, npblb << 20U);

        /* Enable CRYP to start the final phase */
        __HAL_CRYP_ENABLE(hcryp);
      }
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      mode = CRYP_CONV_ALGODIR(((SAES_TypeDef *)(hcryp->Instance))->CR & SAES_CR_MODE);
      if (mode == CRYP_OPERATINGMODE_ENCRYPT)
      {
        /* Specify the number of non-valid bytes using NPBLB register */
        MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_NPBLB, npblb << 20U);
      }
    }
#endif /* USE_HAL_SAES_ONLY */

    /* Number of valid words (lastwordsize) in last block */
    if ((npblb % 4U) == 0U)
    {
      lastwordsize = (16U - npblb) / 4U;
    }
    else
    {
      lastwordsize = ((16U - npblb) / 4U) + 1U;
    }
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      /* Write the last input block in the IN FIFO */
      for (index = 0U; index < lastwordsize; index ++)
      {
        ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
        hcryp->CrypInCount++;
      }

      /* Pad the data with zeros to have a complete block */
      while (index < 4U)
      {
        ((CRYP_TypeDef *)(hcryp->Instance))->DIN = 0U;
        index++;
      }

      /* Wait for OFNE flag to be raised */
      if (CRYP_WaitOnOFNEFlag(hcryp, Timeout) != HAL_OK)
      {
        /* Disable the CRYP peripheral clock */
        __HAL_CRYP_DISABLE(hcryp);

        /* Change state */
        hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
        hcryp->State = HAL_CRYP_STATE_READY;

        /* Process Unlocked */
        __HAL_UNLOCK(hcryp);
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
        /*Call registered error callback*/
        hcryp->ErrorCallback(hcryp);
#else
        /*Call legacy error callback*/
        HAL_CRYP_ErrorCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
      }

      /*Read the output block from the output FIFO */
      if ((((CRYP_TypeDef *)(hcryp->Instance))->SR & CRYP_FLAG_OFNE) != 0x0U)
      {
        for (index = 0U; index < 4U; index++)
        {
          /* Read the output block from the output FIFO and put them in temporary buffer then get CrypOutBuff from
             temporary buffer */
          temp[index] = ((CRYP_TypeDef *)(hcryp->Instance))->DOUT;
        }
      }
      else
      {
        /* Disable the CRYP peripheral clock */
        __HAL_CRYP_DISABLE(hcryp);

        /* Change state */
        hcryp->ErrorCode |= HAL_CRYP_ERROR_READ;
        hcryp->State = HAL_CRYP_STATE_READY;

        /* Process unlocked */
        __HAL_UNLOCK(hcryp);
        return HAL_ERROR;
      }
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      /* Write the last input block in the IN FIFO */
      for (index = 0U; index < lastwordsize; index ++)
      {
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
        hcryp->CrypInCount++;
      }
      while (index < 4U)
      {
        /* pad the data with zeros to have a complete block */
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = 0U;
        index++;
      }
      /* Wait for CCF flag to be raised */
      if (CRYP_WaitOnCCFlag(hcryp, Timeout) != HAL_OK)
      {
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
        /*Call registered error callback*/
        hcryp->ErrorCallback(hcryp);
#else
        /*Call legacy error callback*/
        HAL_CRYP_ErrorCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
      }

      /* Clear CCF Flag */
      __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);

      /*Read the output block from the output FIFO */
      for (index = 0U; index < 4U; index++)
      {
        /* Read the output block from the output FIFO and put them in temporary buffer then
           get CrypOutBuff from temporary buffer */
        temp[index] = ((SAES_TypeDef *)(hcryp->Instance))->DOUTR;
      }
    }
#endif /* USE_HAL_SAES_ONLY */
    for (index = 0U; index < lastwordsize; index++)
    {
      *(uint32_t *)(hcryp->pCrypOutBuffPtr + (hcryp->CrypOutCount)) = temp[index];
      hcryp->CrypOutCount++;
    }
  }

  /* Return function status */
  return HAL_OK;
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_AESGCM_Process_IT(CRYP_HandleTypeDef *hcryp)
{
  uint32_t DoKeyIVConfig = 1U; /* By default, carry out peripheral Key and IV configuration */
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  uint32_t Timeout = CRYP_GENERAL_TIMEOUT;
  uint32_t tickstart;
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
  uint32_t count;
  uint32_t loopcounter;
  uint32_t lastwordsize;
  uint32_t headersize_in_bytes;
  uint32_t tmp;
  uint32_t npblb;
  const uint32_t mask[16] = {0x0U, 0xFF000000U, 0xFFFF0000U, 0xFFFFFF00U,  /* 32-bit data type */
                             0x0U, 0x0000FF00U, 0x0000FFFFU, 0xFF00FFFFU,  /* 16-bit data type */
                             0x0U, 0x000000FFU, 0x0000FFFFU, 0x00FFFFFFU,  /*  8-bit data type */
                             0x0U, 0x000000FFU, 0x0000FFFFU, 0x00FFFFFFU   /*  1-bit data type */
                            };
#endif /* USE_HAL_SAES_ONLY */

#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
  if ((hcryp->Phase == CRYP_PHASE_HEADER_SUSPENDED) || (hcryp->Phase == CRYP_PHASE_PAYLOAD_SUSPENDED))
  {
    CRYP_PhaseProcessingResume(hcryp);
    return HAL_OK;
  }
#endif /* USE_HAL_CRYP_SUSPEND_RESUME */

#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
  /* Manage header size given in bytes to handle cases where
     header size is not a multiple of 4 bytes */
  if (hcryp->Init.HeaderWidthUnit == CRYP_HEADERWIDTHUNIT_WORD)
  {
    headersize_in_bytes = hcryp->Init.HeaderSize * 4U;
  }
  else
  {
    headersize_in_bytes = hcryp->Init.HeaderSize;
  }
#endif /* USE_HAL_SAES_ONLY */

  if (hcryp->Init.KeyIVConfigSkip == CRYP_KEYIVCONFIG_ONCE)
  {
    if (hcryp->KeyIVConfig == 1U)
    {
      /* If the Key and IV configuration has to be done only once
      and if it has already been done, skip it */
      DoKeyIVConfig = 0U;
      hcryp->SizesSum += hcryp->Size; /* Compute message total payload length */
    }
    else
    {
      /* If the Key and IV configuration has to be done only once
      and if it has not been done already, do it and set KeyIVConfig
      to keep track it won't have to be done again next time */
      hcryp->KeyIVConfig = 1U;
      hcryp->SizesSum = hcryp->Size; /* Merely store payload length */
    }
  }
  else
  {
    hcryp->SizesSum = hcryp->Size;
  }

  /* Configure Key, IV and process message (header and payload) */
  if (DoKeyIVConfig == 1U)
  {
    /*  Reset CrypHeaderCount */
    hcryp->CrypHeaderCount = 0U;

    /******************************* Init phase *********************************/
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      CRYP_SET_PHASE(hcryp, CRYP_PHASE_INIT);

      /* Set the Key */
      if (hcryp->Init.KeyIVConfigSkip != CRYP_KEYNOCONFIG)
      {
        if (hcryp->Init.KeyMode != CRYP_KEYMODE_SHARED)
        {
          CRYP_SetKey(hcryp, hcryp->Init.KeySize);
        }
        else /*after sharing the key, AES should set KMOD[1:0] to 00.*/
        {
          ((CRYP_TypeDef *)(hcryp->Instance))->CR &= ~CRYP_KEYMODE_SHARED;
        }
      }
      /* Set the initialization vector and the counter : Initial Counter Block (ICB)*/
      ((CRYP_TypeDef *)(hcryp->Instance))->IV0LR = *(uint32_t *)(hcryp->Init.pInitVect);
      ((CRYP_TypeDef *)(hcryp->Instance))->IV0RR = *(uint32_t *)(hcryp->Init.pInitVect + 1);
      ((CRYP_TypeDef *)(hcryp->Instance))->IV1LR = *(uint32_t *)(hcryp->Init.pInitVect + 2);
      ((CRYP_TypeDef *)(hcryp->Instance))->IV1RR = *(uint32_t *)(hcryp->Init.pInitVect + 3);

      /* Enable the CRYP peripheral */
      __HAL_CRYP_ENABLE(hcryp);

      /* Get tick */
      tickstart = HAL_GetTick();
      /*Wait for the CRYPEN bit to be cleared */
      while ((((CRYP_TypeDef *)(hcryp->Instance))->CR & CRYP_CR_CRYPEN) == CRYP_CR_CRYPEN)
      {
        /* Check for the Timeout */
        if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
        {
          /* Disable the CRYP peripheral clock */
          __HAL_CRYP_DISABLE(hcryp);

          /* Change state */
          hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
          hcryp->State = HAL_CRYP_STATE_READY;

          /* Process unlocked */
          __HAL_UNLOCK(hcryp);
          return HAL_ERROR;
        }
      }
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      SAES_SET_PHASE(hcryp, SAES_PHASE_INIT);

      /* We should re-write Key, in the case where we change key after first operation */
      if ((hcryp->Init.KeySelect == CRYP_KEYSEL_NORMAL) && (hcryp->Init.KeyMode == CRYP_KEYMODE_NORMAL))
      {
        /* Set the Key */
        CRYP_SetKey(hcryp, hcryp->Init.KeySize);
      }
      else /*after sharing the key, AES should set KMOD[1:0] to 00.*/
      {
        ((SAES_TypeDef *)(hcryp->Instance))->CR &= ~CRYP_KEYMODE_SHARED;
      }

      /* Set the initialization vector and the counter : Initial Counter Block (ICB)*/
      ((SAES_TypeDef *)(hcryp->Instance))->IVR3 = *(uint32_t *)(hcryp->Init.pInitVect);
      ((SAES_TypeDef *)(hcryp->Instance))->IVR2 = *(uint32_t *)(hcryp->Init.pInitVect + 1);
      ((SAES_TypeDef *)(hcryp->Instance))->IVR1 = *(uint32_t *)(hcryp->Init.pInitVect + 2);
      ((SAES_TypeDef *)(hcryp->Instance))->IVR0 = *(uint32_t *)(hcryp->Init.pInitVect + 3);

      /* Enable the CRYP peripheral */
      __HAL_CRYP_ENABLE(hcryp);

      /* Wait for KEYVALID flag to be set */
      count = CRYP_TIMEOUT_KEYPREPARATION;
      do
      {
        count--;
        if (count == 0U)
        {
          /* Disable the SAES peripheral clock */
          __HAL_CRYP_DISABLE(hcryp);

          /* Change state */
          hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
          hcryp->State = HAL_CRYP_STATE_READY;
          __HAL_UNLOCK(hcryp);
          return HAL_ERROR;
        }
      } while (HAL_IS_BIT_CLR(((SAES_TypeDef *)(hcryp->Instance))->SR, CRYP_FLAG_KEYVALID));

      /* just wait for hash computation */
      count = CRYP_TIMEOUT_GCMCCMINITPHASE;
      do
      {
        count--;
        if (count == 0U)
        {
          /* Disable the CRYP peripheral clock */
          __HAL_CRYP_DISABLE(hcryp);

          /* Change state */
          hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
          hcryp->State = HAL_CRYP_STATE_READY;
          __HAL_UNLOCK(hcryp);
          return HAL_ERROR;
        }
      } while (HAL_IS_BIT_CLR(((SAES_TypeDef *)(hcryp->Instance))->SR, SAES_SR_CCF));

      /* Clear CCF flag */
      __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);
    }
#endif /* USE_HAL_SAES_ONLY */

    /***************************** Header phase *********************************/

    /* Select header phase */
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      CRYP_SET_PHASE(hcryp, CRYP_PHASE_HEADER);
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      SAES_SET_PHASE(hcryp, SAES_PHASE_HEADER);

      /* Enable the CRYP peripheral */
      __HAL_CRYP_ENABLE(hcryp);

      if (headersize_in_bytes == 0U) /*header phase is skipped*/
      {
        /* Set the phase */
        hcryp->Phase = CRYP_PHASE_PROCESS;

        /* Select payload phase once the header phase is performed */
        MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_GCMPH, SAES_PHASE_PAYLOAD);

        /* Set to 0 the number of non-valid bytes using NPBLB register*/
        MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_NPBLB, 0U);

        /* Write the payload Input block in the IN FIFO */
        if (hcryp->Size == 0U)
        {
          /* Disable interrupts */
          __HAL_CRYP_DISABLE_IT(hcryp, CRYP_IT_CCFIE | CRYP_IT_RWEIE | CRYP_IT_KEIE);

          /* Change the CRYP state */
          hcryp->State = HAL_CRYP_STATE_READY;
          __HAL_UNLOCK(hcryp);
        }
        else if (hcryp->Size >= 16U)
        {
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
          hcryp->CrypInCount++;
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
          hcryp->CrypInCount++;
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
          hcryp->CrypInCount++;
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
          hcryp->CrypInCount++;
          if ((hcryp->CrypInCount == (hcryp->Size / 4U)) && ((hcryp->Size % 16U) == 0U))
          {
            /* Call Input transfer complete callback */
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
            /*Call registered Input complete callback*/
            hcryp->InCpltCallback(hcryp);
#else
            /*Call legacy Input complete callback*/
            HAL_CRYP_InCpltCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
          }

          /* Enable computation complete flag and error interrupts */
          __HAL_CRYP_ENABLE_IT(hcryp, CRYP_IT_CCFIE | CRYP_IT_RWEIE | CRYP_IT_KEIE);
        }
        else /* Size < 16Bytes  : first block is the last block*/
        {
          /* Size should be %4  otherwise Tag will  be incorrectly generated for GCM Encryption:
          Workaround is implemented in polling mode, so if last block of
          payload <128bit do not use CRYP_Encrypt_IT otherwise TAG is incorrectly generated for GCM Encryption. */


          /* Compute the number of padding bytes in last block of payload */
          npblb = 16U - ((uint32_t)hcryp->Size);

          if ((((SAES_TypeDef *)(hcryp->Instance))->CR & SAES_CR_MODE) == CRYP_OPERATINGMODE_ENCRYPT)
          {
            /* Set to 0 the number of non-valid bytes using NPBLB register*/
            MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_NPBLB, npblb << 20U);
          }

          /* Number of valid words (lastwordsize) in last block */
          if ((npblb % 4U) == 0U)
          {
            lastwordsize = (16U - npblb) / 4U;
          }
          else
          {
            lastwordsize = ((16U - npblb) / 4U) + 1U;
          }

          /*  last block optionally pad the data with zeros*/
          for (loopcounter = 0U; loopcounter < lastwordsize ; loopcounter++)
          {
            ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
            hcryp->CrypInCount++;
          }
          while (loopcounter < 4U)
          {
            /* pad the data with zeros to have a complete block */
            ((SAES_TypeDef *)(hcryp->Instance))->DINR = 0x0U;
            loopcounter++;
          }
          /* Call Input transfer complete callback */
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
          /*Call registered Input complete callback*/
          hcryp->InCpltCallback(hcryp);
#else
          /*Call legacy Input complete callback*/
          HAL_CRYP_InCpltCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */

          /* Enable computation complete flag and error interrupts */
          __HAL_CRYP_ENABLE_IT(hcryp, CRYP_IT_CCFIE | CRYP_IT_RWEIE | CRYP_IT_KEIE);
        }
      }
      /* Enter header data */
      /* Cher first whether header length is small enough to enter the full header in one shot */
      else if (headersize_in_bytes <= 16U)
      {
        /* Write header data, padded with zeros if need be */
        for (loopcounter = 0U; (loopcounter < (headersize_in_bytes / 4U)); loopcounter++)
        {
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
          hcryp->CrypHeaderCount++ ;
        }
        /* If the header size is a multiple of words */
        if ((headersize_in_bytes % 4U) == 0U)
        {
          /* Pad the data with zeros to have a complete block */
          while (loopcounter < 4U)
          {
            ((SAES_TypeDef *)(hcryp->Instance))->DINR = 0x0U;
            loopcounter++;
            hcryp->CrypHeaderCount++;
          }
        }
        else
        {
          /* Enter last bytes, padded with zeros */
          tmp =  *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
          tmp &= mask[(hcryp->Init.DataType * 2U) + (headersize_in_bytes % 4U)];
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = tmp;
          loopcounter++;
          hcryp->CrypHeaderCount++ ;
          /* Pad the data with zeros to have a complete block */
          while (loopcounter < 4U)
          {
            ((SAES_TypeDef *)(hcryp->Instance))->DINR = 0x0U;
            loopcounter++;
            hcryp->CrypHeaderCount++;
          }
        }
        /* Call Input transfer complete callback */
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
        /*Call registered Input complete callback*/
        hcryp->InCpltCallback(hcryp);
#else
        /*Call legacy Input complete callback*/
        HAL_CRYP_InCpltCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
      }
      else
      {
        /* Write the first input header block in the Input FIFO,
           the following header data will be fed after interrupt occurrence */
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++;
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++;
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++;
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++;
      }
    }
#endif /* USE_HAL_SAES_ONLY */
  } /* end of if (DoKeyIVConfig == 1U) */
  else  /* Key and IV have already been configured,
          header has already been processed;
          only process here message payload */
  {
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      /* Enable computation complete flag and error interrupts */
      __HAL_CRYP_ENABLE_IT(hcryp, CRYP_IT_CCFIE | CRYP_IT_RWEIE | CRYP_IT_KEIE);

      /* Set to 0 the number of non-valid bytes using NPBLB register*/
      MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_NPBLB, 0U);

      /* Write the payload Input block in the IN FIFO */
      if (hcryp->Size == 0U)
      {
        /* Disable interrupts */
        __HAL_CRYP_DISABLE_IT(hcryp, CRYP_IT_CCFIE | CRYP_IT_RWEIE | CRYP_IT_KEIE);

        /* Change the CRYP state */
        hcryp->State = HAL_CRYP_STATE_READY;
        __HAL_UNLOCK(hcryp);
      }
      else if (hcryp->Size >= 16U)
      {
        ((SAES_TypeDef *)(hcryp->Instance))->DINR  = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
        hcryp->CrypInCount++;
        ((SAES_TypeDef *)(hcryp->Instance))->DINR  = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
        hcryp->CrypInCount++;
        ((SAES_TypeDef *)(hcryp->Instance))->DINR  = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
        hcryp->CrypInCount++;
        ((SAES_TypeDef *)(hcryp->Instance))->DINR  = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
        hcryp->CrypInCount++;
        if (hcryp->CrypInCount == (hcryp->Size / 4U))
        {
          /* Call Input transfer complete callback */
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
          /*Call registered Input complete callback*/
          hcryp->InCpltCallback(hcryp);
#else
          /*Call legacy Input complete callback*/
          HAL_CRYP_InCpltCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
        }
      }
      else /* Size < 16Bytes  : first block is the last block*/
      {
        /* Size should be %4  otherwise Tag will  be incorrectly generated for GCM Encryption:
        Workaround is implemented in polling mode, so if last block of
        payload <128bit do not use CRYP_Encrypt_IT otherwise TAG is incorrectly generated for GCM Encryption. */

        /* Compute the number of padding bytes in last block of payload */
        npblb = 16U - ((uint32_t)hcryp->Size);

        if ((((SAES_TypeDef *)(hcryp->Instance))->CR & SAES_CR_MODE) == CRYP_OPERATINGMODE_ENCRYPT)
        {
          /* Set to 0 the number of non-valid bytes using NPBLB register*/
          MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_NPBLB, npblb << 20U);
        }

        /* Number of valid words (lastwordsize) in last block */
        if ((npblb % 4U) == 0U)
        {
          lastwordsize = (16U - npblb) / 4U;
        }
        else
        {
          lastwordsize = ((16U - npblb) / 4U) + 1U;
        }

        /*  last block optionally pad the data with zeros*/
        for (loopcounter = 0U; loopcounter < lastwordsize ; loopcounter++)
        {
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
          hcryp->CrypInCount++;
        }
        while (loopcounter < 4U)
        {
          /* pad the data with zeros to have a complete block */
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = 0x0U;
          loopcounter++;
        }
      }
    } /* if (IS_SAES_INSTANCE(hcryp->Instance)) */
#endif /* USE_HAL_SAES_ONLY */
  } /* if (DoKeyIVConfig != 1U) */

#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  if (IS_CRYP_INSTANCE(hcryp->Instance))
  {
    CRYP_SET_PHASE(hcryp, CRYP_PHASE_HEADER);

    /* Enable interrupts */
    __HAL_CRYP_ENABLE_IT(hcryp, CRYP_IT_INI);

    /* Enable CRYP */
    __HAL_CRYP_ENABLE(hcryp);
  }
#endif /* USE_HAL_CRYP_ONLY */

  /* Return function status */
  return HAL_OK;
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_AESGCM_Process_DMA(CRYP_HandleTypeDef *hcryp)
{
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  __IO uint32_t count = 0U;
#endif /* USE_HAL_CRYP_ONLY */
  uint32_t wordsize = (uint32_t)(hcryp->Size) / 4U ;
  uint32_t index;
  uint32_t npblb;
  uint32_t lastwordsize = 0U;
  uint32_t temp[4] = {0};/* Temporary CrypOutBuff */
  uint32_t DoKeyIVConfig = 1U; /* By default, carry out peripheral Key and IV configuration */
  uint32_t mode;
  uint32_t Timeout = CRYP_GENERAL_TIMEOUT;
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  uint32_t tickstart;
#endif /* USE_HAL_CRYP_ONLY */

  if (hcryp->Init.KeyIVConfigSkip == CRYP_KEYIVCONFIG_ONCE)
  {
    if (hcryp->KeyIVConfig == 1U)
    {
      /* If the Key and IV configuration has to be done only once
         and if it has already been done, skip it */
      DoKeyIVConfig = 0U;
      hcryp->SizesSum += hcryp->Size; /* Compute message total payload length */
    }
    else
    {
      /* If the Key and IV configuration has to be done only once
         and if it has not been done already, do it and set KeyIVConfig
         to keep track it won't have to be done again next time */
      hcryp->KeyIVConfig = 1U;
      hcryp->SizesSum = hcryp->Size; /* Merely store payload length */
    }
  }
  else
  {
    hcryp->SizesSum = hcryp->Size;
  }

  if (DoKeyIVConfig == 1U)
  {
    /*  Reset CrypHeaderCount */
    hcryp->CrypHeaderCount = 0U;

    /*************************** Init phase ************************************/
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      CRYP_SET_PHASE(hcryp, CRYP_PHASE_INIT);

      /* Set the Key */
      if (hcryp->Init.KeyIVConfigSkip != CRYP_KEYNOCONFIG)
      {
        if (hcryp->Init.KeyMode != CRYP_KEYMODE_SHARED)
        {
          CRYP_SetKey(hcryp, hcryp->Init.KeySize);
        }
        else /*after sharing the key, AES should set KMOD[1:0] to 00.*/
        {
          ((CRYP_TypeDef *)(hcryp->Instance))->CR &= ~CRYP_KEYMODE_SHARED;
        }
      }

      /* Set the initialization vector and the counter : Initial Counter Block (ICB)*/
      ((CRYP_TypeDef *)(hcryp->Instance))->IV0LR = *(uint32_t *)(hcryp->Init.pInitVect);
      ((CRYP_TypeDef *)(hcryp->Instance))->IV0RR = *(uint32_t *)(hcryp->Init.pInitVect + 1);
      ((CRYP_TypeDef *)(hcryp->Instance))->IV1LR = *(uint32_t *)(hcryp->Init.pInitVect + 2);
      ((CRYP_TypeDef *)(hcryp->Instance))->IV1RR = *(uint32_t *)(hcryp->Init.pInitVect + 3);

      /* Enable the CRYP peripheral */
      __HAL_CRYP_ENABLE(hcryp);

      /* Get tick */
      tickstart = HAL_GetTick();
      /*Wait for the CRYPEN bit to be cleared */
      while ((((CRYP_TypeDef *)(hcryp->Instance))->CR & CRYP_CR_CRYPEN) == CRYP_CR_CRYPEN)
      {
        /* Check for the Timeout */
        if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
        {
          /* Disable the CRYP peripheral clock */
          __HAL_CRYP_DISABLE(hcryp);

          /* Change state */
          hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
          hcryp->State = HAL_CRYP_STATE_READY;

          /* Process unlocked */
          __HAL_UNLOCK(hcryp);
        }
      }
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      SAES_SET_PHASE(hcryp, SAES_PHASE_INIT);

      /* Set the Key */
      CRYP_SetKey(hcryp, hcryp->Init.KeySize);

      /* Set the initialization vector and the counter : Initial Counter Block (ICB)*/
      ((SAES_TypeDef *)(hcryp->Instance))->IVR3 = *(uint32_t *)(hcryp->Init.pInitVect);
      ((SAES_TypeDef *)(hcryp->Instance))->IVR2 = *(uint32_t *)(hcryp->Init.pInitVect + 1);
      ((SAES_TypeDef *)(hcryp->Instance))->IVR1 = *(uint32_t *)(hcryp->Init.pInitVect + 2);
      ((SAES_TypeDef *)(hcryp->Instance))->IVR0 = *(uint32_t *)(hcryp->Init.pInitVect + 3);

      /* Enable the CRYP peripheral */
      __HAL_CRYP_ENABLE(hcryp);

      /* Wait for CCF to be raised */
      if (CRYP_WaitOnCCFlag(hcryp, Timeout) != HAL_OK)
      {
        /* Disable the CRYP peripheral clock */
        __HAL_CRYP_DISABLE(hcryp);

        /* Change state */
        hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
        hcryp->State = HAL_CRYP_STATE_READY;

        /* Process unlocked */
        __HAL_UNLOCK(hcryp);
        return HAL_ERROR;
      }
      /* Clear CCF flag */
      __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);
    }
#endif /* USE_HAL_SAES_ONLY */
    /************************ Header phase *************************************/

    if (CRYP_GCMCCM_SetHeaderPhase_DMA(hcryp) != HAL_OK)
    {
      return HAL_ERROR;
    }

    /************************ Payload phase ************************************/

    /* Set the phase */
    hcryp->Phase = CRYP_PHASE_PROCESS;

    /* Select payload phase once the header phase is performed */
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      /* Disable the CRYP peripheral */
      __HAL_CRYP_DISABLE(hcryp);

      CRYP_SET_PHASE(hcryp, CRYP_PHASE_PAYLOAD);

      /* Set to 0 the number of non-valid bytes using NPBLB register*/
      MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_NPBLB, 0U);

      /* Enable the CRYP peripheral */
      __HAL_CRYP_ENABLE(hcryp);
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      SAES_SET_PHASE(hcryp, SAES_PHASE_PAYLOAD);

      /* Set to 0 the number of non-valid bytes using NPBLB register*/
      MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_NPBLB, 0U);
    }
#endif /* USE_HAL_SAES_ONLY */

  } /* if (DoKeyIVConfig == 1U) */

  if (hcryp->Size == 0U)
  {
    /* Process unLocked */
    __HAL_UNLOCK(hcryp);

    /* Change the CRYP state and phase */
    hcryp->State = HAL_CRYP_STATE_READY;
  }
  else if (hcryp->Size >= 16U)
  {
    /* DMA transfer must not include the last block in case of Size is not %16 */
    wordsize = wordsize - (wordsize % 4U);

    /* DMA transfer */
    CRYP_SetDMAConfig(hcryp, (uint32_t)(hcryp->pCrypInBuffPtr), (uint16_t)wordsize * 4U,
                      (uint32_t)(hcryp->pCrypOutBuffPtr));
  }
  else /* length of input data is < 16 */
  {
    /* Compute the number of padding bytes in last block of payload */
    npblb = 16U - (uint32_t)hcryp->Size;

    /* Set Npblb in case of AES GCM payload encryption to get right tag*/
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      mode = ((CRYP_TypeDef *)(hcryp->Instance))->CR & CRYP_CR_ALGODIR;

      if (mode == CRYP_OPERATINGMODE_ENCRYPT)
      {
        /* Specify the number of non-valid bytes using NPBLB register*/
        MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_NPBLB, npblb << 20);
      }

      /* Enable CRYP to start the final phase */
      __HAL_CRYP_ENABLE(hcryp);

      /* Number of valid words (lastwordsize) in last block */
      if ((npblb % 4U) == 0U)
      {
        lastwordsize = (16U - npblb) / 4U;
      }
      else
      {
        lastwordsize = ((16U - npblb) / 4U) + 1U;
      }

      /* Write the last input block in the IN FIFO */
      for (index = 0; index < lastwordsize; index ++)
      {
        ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
        hcryp->CrypInCount++;
      }

      /* Pad the data with zeros to have a complete block */
      while (index < 4U)
      {
        ((CRYP_TypeDef *)(hcryp->Instance))->DIN = 0U;
        index++;
      }

      /* Wait for OFNE flag to be raised */
      count = CRYP_TIMEOUT_GCMCCMHEADERPHASE;
      do
      {
        count-- ;
        if (count == 0U)
        {
          /* Disable the CRYP peripheral clock */
          __HAL_CRYP_DISABLE(hcryp);

          /* Change state */
          hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
          hcryp->State = HAL_CRYP_STATE_READY;

          /* Process unlocked */
          __HAL_UNLOCK(hcryp);
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
          /*Call registered error callback*/
          hcryp->ErrorCallback(hcryp);
#else
          /*Call legacy error callback*/
          HAL_CRYP_ErrorCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
        }
      } while (HAL_IS_BIT_CLR(((CRYP_TypeDef *)(hcryp->Instance))->SR, CRYP_FLAG_OFNE));

      /*Read the output block from the output FIFO */
      for (index = 0U; index < 4U; index++)
      {
        /* Read the output block from the output FIFO and put them in temporary buffer then get CrypOutBuff from
           temporary buffer */
        temp[index] = ((CRYP_TypeDef *)(hcryp->Instance))->DOUT;
      }
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {

      mode = CRYP_CONV_ALGODIR(((SAES_TypeDef *)(hcryp->Instance))->CR & SAES_CR_MODE);
      if (((mode == CRYP_OPERATINGMODE_ENCRYPT) && (hcryp->Init.Algorithm == CRYP_AES_GCM)) ||
          ((mode == CRYP_OPERATINGMODE_DECRYPT) && (hcryp->Init.Algorithm == CRYP_AES_CCM)))
      {
        /* Specify the number of non-valid bytes using NPBLB register*/
        MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_NPBLB, npblb << 20);
      }

      /* Number of valid words (lastwordsize) in last block */
      if ((npblb % 4U) == 0U)
      {
        lastwordsize = (16U - npblb) / 4U;
      }
      else
      {
        lastwordsize = ((16U - npblb) / 4U) + 1U;
      }

      /* Write the last input block in the IN FIFO */
      for (index = 0; index < lastwordsize; index ++)
      {
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
        hcryp->CrypInCount++;
      }

      /* Pad the data with zeros to have a complete block */
      while (index < 4U)
      {
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = 0U;
        index++;
      }

      /* Wait for CCF flag to be raised */
      if (CRYP_WaitOnCCFlag(hcryp, Timeout) != HAL_OK)
      {
        /* Disable the CRYP peripheral clock */
        __HAL_CRYP_DISABLE(hcryp);

        /* Change state */
        hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
        hcryp->State = HAL_CRYP_STATE_READY;

        /* Process unlocked */
        __HAL_UNLOCK(hcryp);
        /*Call registered error callback*/
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
        hcryp->ErrorCallback(hcryp);
#else
        /*Call legacy error callback*/
        HAL_CRYP_ErrorCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
      }
      /* Clear the CCF flag by setting the CCF bit of the SAES_ICR register */
      __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);

      /*Read the output block from the output FIFO */
      for (index = 0U; index < 4U; index++)
      {
        /* Read the output block from the output FIFO and put them in temporary buffer then get CrypOutBuff from
           temporary buffer */
        temp[index] = ((SAES_TypeDef *)(hcryp->Instance))->DOUTR;
      }
    }
#endif /* USE_HAL_SAES_ONLY */

    for (index = 0; index < lastwordsize; index++)
    {
      *(uint32_t *)(hcryp->pCrypOutBuffPtr + hcryp->CrypOutCount) = temp[index];
      hcryp->CrypOutCount++;
    }

    /* Change the CRYP state to ready */
    hcryp->State = HAL_CRYP_STATE_READY;

    /* Process unlocked */
    __HAL_UNLOCK(hcryp);
  }

  /* Return function status */
  return HAL_OK;
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_AESCCM_Process(CRYP_HandleTypeDef *hcryp, uint32_t Timeout)
{
  uint32_t tickstart;
  uint32_t wordsize = (uint32_t)(hcryp->Size) / 4U;
  uint32_t npblb ;
  uint32_t lastwordsize ;
  uint32_t temp[4] = {0};/* Temporary CrypOutBuff */
  uint32_t index ;
  uint32_t outcount;  /* Temporary CrypOutCount Value */
  uint32_t DoKeyIVConfig = 1U; /* By default, carry out peripheral Key and IV configuration */
  uint32_t mode;

  if (hcryp->Init.KeyIVConfigSkip == CRYP_KEYIVCONFIG_ONCE)
  {
    if (hcryp->KeyIVConfig == 1U)
    {
      /* If the Key and IV configuration has to be done only once
      and if it has already been done, skip it */
      DoKeyIVConfig = 0U;
      hcryp->SizesSum += hcryp->Size; /* Compute message total payload length */
    }
    else
    {
      /* If the Key and IV configuration has to be done only once
      and if it has not been done already, do it and set KeyIVConfig
      to keep track it won't have to be done again next time */
      hcryp->KeyIVConfig = 1U;
      hcryp->SizesSum = hcryp->Size; /* Merely store payload length */
    }
  }
  else
  {
    hcryp->SizesSum = hcryp->Size;
  }

  if (DoKeyIVConfig == 1U)
  {
    /*  Reset CrypHeaderCount */
    hcryp->CrypHeaderCount = 0U;

    /********************** Init phase ******************************************/
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      CRYP_SET_PHASE(hcryp, CRYP_PHASE_INIT);

      /* Set the Key */
      if (hcryp->Init.KeyIVConfigSkip != CRYP_KEYNOCONFIG)
      {
        if (hcryp->Init.KeyMode != CRYP_KEYMODE_SHARED)
        {
          CRYP_SetKey(hcryp, hcryp->Init.KeySize);
        }
        else /*after sharing the key, AES should set KMOD[1:0] to 00.*/
        {
          ((CRYP_TypeDef *)(hcryp->Instance))->CR &=  ~CRYP_KEYMODE_SHARED;
        }
      }
      /* Set the initialization vector (IV) with CTR1 information */
      ((CRYP_TypeDef *)(hcryp->Instance))->IV0LR = (hcryp->Init.B0[0]) & CRYP_CCM_CTR1_0;
      ((CRYP_TypeDef *)(hcryp->Instance))->IV0RR = hcryp->Init.B0[1];
      ((CRYP_TypeDef *)(hcryp->Instance))->IV1LR = hcryp->Init.B0[2];
      ((CRYP_TypeDef *)(hcryp->Instance))->IV1RR = (hcryp->Init.B0[3] & CRYP_CCM_CTR1_1) |  CRYP_CCM_CTR1_2;

      /* Enable the CRYP peripheral */
      __HAL_CRYP_ENABLE(hcryp);

      /* Set the initialization vector (IV) with B0 */
      ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.B0);
      ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.B0 + 1);
      ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.B0 + 2);
      ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.B0 + 3);

      /* Get tick */
      tickstart = HAL_GetTick();

      /*Wait for the CRYPEN bit to be cleared*/
      while ((((CRYP_TypeDef *)(hcryp->Instance))->CR & CRYP_CR_CRYPEN) == CRYP_CR_CRYPEN)
      {
        /* Check for the Timeout */
        if (Timeout != HAL_MAX_DELAY)
        {
          if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
          {
            /* Disable the CRYP peripheral clock */
            __HAL_CRYP_DISABLE(hcryp);

            /* Change state */
            hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
            hcryp->State = HAL_CRYP_STATE_READY;

            /* Process unlocked */
            __HAL_UNLOCK(hcryp);
            return HAL_ERROR;
          }
        }
      }
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      SAES_SET_PHASE(hcryp, SAES_PHASE_INIT);

      /* We should re-write Key, in the case where we change key after first operation */
      if ((hcryp->Init.KeySelect == CRYP_KEYSEL_NORMAL) && (hcryp->Init.KeyMode == CRYP_KEYMODE_NORMAL))
      {
        /* Set the Key */
        CRYP_SetKey(hcryp, hcryp->Init.KeySize);
      }

      /* Set the initialization vector (IV) with B0 */
      ((SAES_TypeDef *)(hcryp->Instance))->IVR3 = *(uint32_t *)(hcryp->Init.B0);
      ((SAES_TypeDef *)(hcryp->Instance))->IVR2 = *(uint32_t *)(hcryp->Init.B0 + 1U);
      ((SAES_TypeDef *)(hcryp->Instance))->IVR1 = *(uint32_t *)(hcryp->Init.B0 + 2U);
      ((SAES_TypeDef *)(hcryp->Instance))->IVR0 = *(uint32_t *)(hcryp->Init.B0 + 3U);

      /* Enable the CRYP peripheral */
      __HAL_CRYP_ENABLE(hcryp);

      /* just wait for hash computation */
      if (CRYP_WaitOnCCFlag(hcryp, Timeout) != HAL_OK)
      {
        /* Disable the CRYP peripheral clock */
        __HAL_CRYP_DISABLE(hcryp);

        /* Change state */
        hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
        hcryp->State = HAL_CRYP_STATE_READY;

        /* Process unlocked */
        __HAL_UNLOCK(hcryp);
        return HAL_ERROR;
      }
      /* Clear CCF flag */
      __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);
    }
#endif /* USE_HAL_SAES_ONLY */

    /************************* Header phase *************************************/
    /* Header block(B1) : associated data length expressed in bytes concatenated
    with Associated Data (A)*/

    if (CRYP_GCMCCM_SetHeaderPhase(hcryp, Timeout) != HAL_OK)
    {
      return HAL_ERROR;
    }
    /********************** Payload phase ***************************************/

    /* Set the phase */
    hcryp->Phase = CRYP_PHASE_PROCESS;

#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    /* Select payload phase once the header phase is performed */
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      /* Disable the CRYP peripheral */
      __HAL_CRYP_DISABLE(hcryp);

      /* Set to 0 the number of non-valid bytes using NPBLB register*/
      MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_NPBLB, 0U);

      /* Select payload phase once the header phase is performed */
      CRYP_SET_PHASE(hcryp, CRYP_PHASE_PAYLOAD);

      /* Enable the CRYP peripheral */
      __HAL_CRYP_ENABLE(hcryp);
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      /* Set to 0 the number of non-valid bytes using NPBLB register*/
      MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_NPBLB, 0U);

      /* Select payload phase once the header phase is performed */
      SAES_SET_PHASE(hcryp, SAES_PHASE_PAYLOAD);
    }
#endif /* USE_HAL_SAES_ONLY */

  } /* if (DoKeyIVConfig == 1U) */

  if ((hcryp->Size % 16U) != 0U)
  {
    /* recalculate  wordsize */
    wordsize = ((wordsize / 4U) * 4U) ;
  }
  /* Get tick */
  tickstart = HAL_GetTick();

  /*Temporary CrypOutCount Value */
  outcount = hcryp->CrypOutCount;
  /* Write input data and get output data */
  while ((hcryp->CrypInCount < wordsize) && (outcount < wordsize))
  {
    /* Write plain data and get cipher data */
    CRYP_AES_ProcessData(hcryp, Timeout);

    /*Temporary CrypOutCount Value */
    outcount = hcryp->CrypOutCount;

    /* Check for the Timeout */
    if (Timeout != HAL_MAX_DELAY)
    {
      if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
      {
        /* Disable the CRYP peripheral clock */
        __HAL_CRYP_DISABLE(hcryp);

        /* Change state */
        hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
        hcryp->State = HAL_CRYP_STATE_READY;

        /* Process unlocked */
        __HAL_UNLOCK(hcryp);
        return HAL_ERROR;
      }
    }
  }

#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  if (IS_CRYP_INSTANCE(hcryp->Instance))
  {
    if ((hcryp->Size % 16U) != 0U)
    {
      /* Compute the number of padding bytes in last block of payload */
      npblb = ((((uint32_t)(hcryp->Size) / 16U) + 1U) * 16U) - (uint32_t)(hcryp->Size);

      mode = ((CRYP_TypeDef *)(hcryp->Instance))->CR & CRYP_CR_ALGODIR;
      if (mode == CRYP_OPERATINGMODE_DECRYPT)
      {
        /* Disable the CRYP */
        __HAL_CRYP_DISABLE(hcryp);

        /* Set Npblb in case of AES CCM payload decryption to get right tag  */
        MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_NPBLB, npblb << 20);

        /* Enable CRYP to start the final phase */
        __HAL_CRYP_ENABLE(hcryp);
      }

      /* Number of valid words (lastwordsize) in last block */
      if ((npblb % 4U) == 0U)
      {
        lastwordsize = (16U - npblb) / 4U;
      }
      else
      {
        lastwordsize = ((16U - npblb) / 4U) + 1U;
      }

      /* Write the last input block in the IN FIFO */
      for (index = 0U; index < lastwordsize; index ++)
      {
        ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
        hcryp->CrypInCount++;
      }

      /* Pad the data with zeros to have a complete block */
      while (index < 4U)
      {
        ((CRYP_TypeDef *)(hcryp->Instance))->DIN = 0U;
        index++;
      }

      /* Wait for OFNE flag to be raised */
      if (CRYP_WaitOnOFNEFlag(hcryp, Timeout) != HAL_OK)
      {
        /* Disable the CRYP peripheral clock */
        __HAL_CRYP_DISABLE(hcryp);

        /* Change state */
        hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
        hcryp->State = HAL_CRYP_STATE_READY;

        /* Process Unlocked */
        __HAL_UNLOCK(hcryp);
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
        /*Call registered error callback*/
        hcryp->ErrorCallback(hcryp);
#else
        /*Call legacy error callback*/
        HAL_CRYP_ErrorCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
      }

      /*Read the output block from the output FIFO */
      if ((((CRYP_TypeDef *)(hcryp->Instance))->SR & CRYP_FLAG_OFNE) != 0x0U)
      {
        for (index = 0U; index < 4U; index++)
        {
          /* Read the output block from the output FIFO and put them in temporary buffer then get CrypOutBuff from
             temporary buffer */
          temp[index] = ((CRYP_TypeDef *)(hcryp->Instance))->DOUT;
        }
        for (index = 0; index < lastwordsize; index++)
        {
          *(uint32_t *)(hcryp->pCrypOutBuffPtr + hcryp->CrypOutCount) = temp[index];
          hcryp->CrypOutCount++;
        }
      }
    }
  }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
  if (IS_SAES_INSTANCE(hcryp->Instance))
  {

    if ((hcryp->Size % 16U) != 0U)
    {
      /* Compute the number of padding bytes in last block of payload */
      npblb = ((((uint32_t)hcryp->Size / 16U) + 1U) * 16U) - ((uint32_t)hcryp->Size);

      mode = CRYP_CONV_ALGODIR(((SAES_TypeDef *)(hcryp->Instance))->CR & SAES_CR_MODE);
      if (mode == CRYP_OPERATINGMODE_DECRYPT)
      {
        /* Set Npblb in case of AES CCM payload decryption to get right tag  */
        MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_NPBLB, npblb << 20);
      }
      /* Number of valid words (lastwordsize) in last block */
      if ((npblb % 4U) == 0U)
      {
        lastwordsize = (16U - npblb) / 4U;
      }
      else
      {
        lastwordsize = ((16U - npblb) / 4U) + 1U;
      }

      /* Write the last input block in the IN FIFO */
      for (index = 0U; index < lastwordsize; index ++)
      {
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
        hcryp->CrypInCount++;
      }

      /* Pad the data with zeros to have a complete block */
      while (index < 4U)
      {
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = 0U;
        index++;
      }
      /* just wait for hash computation */
      if (CRYP_WaitOnCCFlag(hcryp, Timeout) != HAL_OK)
      {
        /* Disable the CRYP peripheral clock */
        __HAL_CRYP_DISABLE(hcryp);

        /* Change state */
        hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
        hcryp->State = HAL_CRYP_STATE_READY;

        /* Process Unlocked */
        __HAL_UNLOCK(hcryp);
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
        /*Call registered error callback*/
        hcryp->ErrorCallback(hcryp);
#else
        /*Call legacy error callback*/
        HAL_CRYP_ErrorCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
      }
      /* Clear CCF flag */
      __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);

      for (index = 0U; index < 4U; index++)
      {
        /* Read the output block from the output FIFO and put them in temporary buffer then
           get CrypOutBuff from temporary buffer */
        temp[index] = ((SAES_TypeDef *)(hcryp->Instance))->DOUTR;
      }
      for (index = 0U; index < lastwordsize; index++)
      {
        *(uint32_t *)(hcryp->pCrypOutBuffPtr + hcryp->CrypOutCount) = temp[index];
        hcryp->CrypOutCount++;
      }
    }
  }
#endif /* USE_HAL_SAES_ONLY */
  /* Wait until the complete message has been processed */
  if (CRYP_WaitOnBUSYFlag(hcryp, Timeout) != HAL_OK)
  {
    /* Disable the CRYP peripheral clock */
    __HAL_CRYP_DISABLE(hcryp);

    /* Change state */
    hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
    hcryp->State = HAL_CRYP_STATE_READY;

    /* Process unlocked & return error */
    __HAL_UNLOCK(hcryp);
    return HAL_ERROR;
  }

  /* Return function status */
  return HAL_OK;
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_AESCCM_Process_IT(CRYP_HandleTypeDef *hcryp)
{
  uint32_t DoKeyIVConfig = 1U; /* By default, carry out peripheral Key and IV configuration */
  uint32_t Timeout = CRYP_GENERAL_TIMEOUT;
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  uint32_t tickstart;
#endif /* USE_HAL_CRYP_ONLY */
  uint32_t loopcounter;
  uint32_t lastwordsize;
  uint32_t npblb;
  uint32_t mode;
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
  uint32_t headersize_in_bytes;
  uint32_t tmp;
  const uint32_t mask[16] = {0x0U, 0xFF000000U, 0xFFFF0000U, 0xFFFFFF00U,  /* 32-bit data type */
                             0x0U, 0x0000FF00U, 0x0000FFFFU, 0xFF00FFFFU,  /* 16-bit data type */
                             0x0U, 0x000000FFU, 0x0000FFFFU, 0x00FFFFFFU,  /*  8-bit data type */
                             0x0U, 0x000000FFU, 0x0000FFFFU, 0x00FFFFFFU   /*  1-bit data type */
                            };
#endif /* USE_HAL_SAES_ONLY */

#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
  if ((hcryp->Phase == CRYP_PHASE_HEADER_SUSPENDED) || (hcryp->Phase == CRYP_PHASE_PAYLOAD_SUSPENDED))
  {
    CRYP_PhaseProcessingResume(hcryp);
    return HAL_OK;
  }
#endif /* USE_HAL_CRYP_SUSPEND_RESUME */

  if (hcryp->Init.KeyIVConfigSkip == CRYP_KEYIVCONFIG_ONCE)
  {
    if (hcryp->KeyIVConfig == 1U)
    {
      /* If the Key and IV configuration has to be done only once
      and if it has already been done, skip it */
      DoKeyIVConfig = 0U;
      hcryp->SizesSum += hcryp->Size; /* Compute message total payload length */
    }
    else
    {
      /* If the Key and IV configuration has to be done only once
      and if it has not been done already, do it and set KeyIVConfig
      to keep track it won't have to be done again next time */
      hcryp->KeyIVConfig = 1U;
      hcryp->SizesSum = hcryp->Size; /* Merely store payload length */
    }
  }
  else
  {
    hcryp->SizesSum = hcryp->Size;
  }

  /* Configure Key, IV and process message (header and payload) */
  if (DoKeyIVConfig == 1U)
  {
    /*  Reset CrypHeaderCount */
    hcryp->CrypHeaderCount = 0U;

    /************ Init phase ************/
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      CRYP_SET_PHASE(hcryp, CRYP_PHASE_INIT);

      /* Set the Key */
      if (hcryp->Init.KeyIVConfigSkip != CRYP_KEYNOCONFIG)
      {
        if (hcryp->Init.KeyMode != CRYP_KEYMODE_SHARED)
        {
          CRYP_SetKey(hcryp, hcryp->Init.KeySize);
        }
        else /*after sharing the key, AES should set KMOD[1:0] to 00.*/
        {
          ((CRYP_TypeDef *)(hcryp->Instance))->CR &= ~CRYP_KEYMODE_SHARED;
        }
      }

      /* Set the initialization vector (IV) with CTR1 information */
      ((CRYP_TypeDef *)(hcryp->Instance))->IV0LR = (hcryp->Init.B0[0]) & CRYP_CCM_CTR1_0;
      ((CRYP_TypeDef *)(hcryp->Instance))->IV0RR = hcryp->Init.B0[1];
      ((CRYP_TypeDef *)(hcryp->Instance))->IV1LR = hcryp->Init.B0[2];
      ((CRYP_TypeDef *)(hcryp->Instance))->IV1RR = (hcryp->Init.B0[3] & CRYP_CCM_CTR1_1) | CRYP_CCM_CTR1_2;

      /* Enable the CRYP peripheral */
      __HAL_CRYP_ENABLE(hcryp);

      /*Write the B0 packet into CRYP_DR*/
      ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.B0);
      ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.B0 + 1);
      ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.B0 + 2);
      ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.B0 + 3);

      /* Get tick */
      tickstart = HAL_GetTick();

      /*Wait for the CRYPEN bit to be cleared */
      while ((((CRYP_TypeDef *)(hcryp->Instance))->CR & CRYP_CR_CRYPEN) == CRYP_CR_CRYPEN)
      {
        /* Check for the Timeout */
        if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
        {
          /* Disable the CRYP peripheral clock */
          __HAL_CRYP_DISABLE(hcryp);

          /* Change state */
          hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
          hcryp->State = HAL_CRYP_STATE_READY;

          /* Process unlocked */
          __HAL_UNLOCK(hcryp);
          return HAL_ERROR;
        }
      }
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      SAES_SET_PHASE(hcryp, SAES_PHASE_INIT);

      /* We should re-write Key, in the case where we change key after first operation */
      if ((hcryp->Init.KeySelect == CRYP_KEYSEL_NORMAL) && (hcryp->Init.KeyMode == CRYP_KEYMODE_NORMAL))
      {
        /* Set the Key */
        CRYP_SetKey(hcryp, hcryp->Init.KeySize);
      }

      /* Set the initialization vector (IV) with B0 */
      ((SAES_TypeDef *)(hcryp->Instance))->IVR3 = *(uint32_t *)(hcryp->Init.B0);
      ((SAES_TypeDef *)(hcryp->Instance))->IVR2 = *(uint32_t *)(hcryp->Init.B0 + 1U);
      ((SAES_TypeDef *)(hcryp->Instance))->IVR1 = *(uint32_t *)(hcryp->Init.B0 + 2U);
      ((SAES_TypeDef *)(hcryp->Instance))->IVR0 = *(uint32_t *)(hcryp->Init.B0 + 3U);

      /* Enable the CRYP peripheral */
      __HAL_CRYP_ENABLE(hcryp);

      /* just wait for hash computation */
      if (CRYP_WaitOnCCFlag(hcryp, Timeout) != HAL_OK)
      {
        /* Disable the CRYP peripheral clock */
        __HAL_CRYP_DISABLE(hcryp);

        /* Change state */
        hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
        hcryp->State = HAL_CRYP_STATE_READY;

        /* Process unlocked */
        __HAL_UNLOCK(hcryp);
        return HAL_ERROR;
      }
      /* Clear CCF flag */
      __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);
    }
#endif /* USE_HAL_SAES_ONLY */

    /***************************** Header phase *********************************/

    /* Select header phase */
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      CRYP_SET_PHASE(hcryp, CRYP_PHASE_HEADER);

      /* Enable interrupts */
      __HAL_CRYP_ENABLE_IT(hcryp, CRYP_IT_INI);

      /* Enable CRYP */
      __HAL_CRYP_ENABLE(hcryp);
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      /* Select header phase */
      SAES_SET_PHASE(hcryp, SAES_PHASE_HEADER);

      /* Enable computation complete flag and error interrupts */
      __HAL_CRYP_ENABLE_IT(hcryp, CRYP_IT_CCFIE | CRYP_IT_RWEIE | CRYP_IT_KEIE);

      /* Enable the CRYP peripheral */
      __HAL_CRYP_ENABLE(hcryp);

      if (hcryp->Init.HeaderWidthUnit == CRYP_HEADERWIDTHUNIT_WORD)
      {
        headersize_in_bytes = hcryp->Init.HeaderSize * 4U;
      }
      else
      {
        headersize_in_bytes = hcryp->Init.HeaderSize;
      }
      if (headersize_in_bytes == 0U) /* Header phase is  skipped */
      {
        /* Set the phase */
        hcryp->Phase = CRYP_PHASE_PROCESS;

        /* Select payload phase once the header phase is performed */
        SAES_SET_PHASE(hcryp, SAES_PHASE_PAYLOAD);

        /* Set to 0 the number of non-valid bytes using NPBLB register*/
        MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_NPBLB, 0U);

        if (hcryp->Init.Algorithm == CRYP_AES_CCM)
        {
          /* Increment CrypHeaderCount to pass in CRYP_GCMCCM_SetPayloadPhase_IT */
          hcryp->CrypHeaderCount++;
        }
        /* Write the payload Input block in the IN FIFO */
        if (hcryp->Size == 0U)
        {
          /* Disable interrupts */
          __HAL_CRYP_DISABLE_IT(hcryp, CRYP_IT_CCFIE | CRYP_IT_RWEIE | CRYP_IT_KEIE);

          /* Change the CRYP state */
          hcryp->State = HAL_CRYP_STATE_READY;
          __HAL_UNLOCK(hcryp);
        }
        else if (hcryp->Size >= 16U)
        {
          hcryp->CrypInCount++;
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount - 1U);
          hcryp->CrypInCount++;
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount - 1U);
          hcryp->CrypInCount++;
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount - 1U);
          hcryp->CrypInCount++;
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount - 1U);

          if ((hcryp->CrypInCount == (hcryp->Size / 4U)) && ((hcryp->Size % 16U) == 0U))
          {
            /* Call Input transfer complete callback */
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
            /*Call registered Input complete callback*/
            hcryp->InCpltCallback(hcryp);
#else
            /*Call legacy Input complete callback*/
            HAL_CRYP_InCpltCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
          }
        }
        else /* Size < 4 words  : first block is the last block*/
        {
          /* Compute the number of padding bytes in last block of payload */
          npblb = 16U - (uint32_t)hcryp->Size;

          mode = CRYP_CONV_ALGODIR(((SAES_TypeDef *)(hcryp->Instance))->CR & SAES_CR_MODE);
          if (((mode == CRYP_OPERATINGMODE_ENCRYPT) && (hcryp->Init.Algorithm == CRYP_AES_GCM)) ||
              ((mode == CRYP_OPERATINGMODE_DECRYPT) && (hcryp->Init.Algorithm == CRYP_AES_CCM)))
          {
            /* Specify the number of non-valid bytes using NPBLB register*/
            MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_NPBLB, npblb << 20U);
          }

          /* Number of valid words (lastwordsize) in last block */
          if ((npblb % 4U) == 0U)
          {
            lastwordsize = (16U - npblb) / 4U;
          }
          else
          {
            lastwordsize = ((16U - npblb) / 4U) + 1U;
          }

          /*  Last block optionally pad the data with zeros*/
          for (loopcounter = 0U; loopcounter < lastwordsize; loopcounter++)
          {
            ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
            hcryp->CrypInCount++;
          }
          while (loopcounter < 4U)
          {
            /* Pad the data with zeros to have a complete block */
            ((SAES_TypeDef *)(hcryp->Instance))->DINR = 0x0U;
            loopcounter++;
          }
          /* Call Input transfer complete callback */
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
          /*Call registered Input complete callback*/
          hcryp->InCpltCallback(hcryp);
#else
          /*Call legacy Input complete callback*/
          HAL_CRYP_InCpltCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
        }
      }
      /* Enter header data */
      /* Check first whether header length is small enough to enter the full header in one shot */
      else if (headersize_in_bytes <= 16U)
      {
        for (loopcounter = 0U; (loopcounter < (headersize_in_bytes / 4U)); loopcounter++)
        {
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
          hcryp->CrypHeaderCount++;
        }
        /* If the header size is a multiple of words */
        if ((headersize_in_bytes % 4U) == 0U)
        {
          /* Pad the data with zeros to have a complete block */
          while (loopcounter < 4U)
          {
            ((SAES_TypeDef *)(hcryp->Instance))->DINR = 0x0U;
            loopcounter++;
          }
        }
        else
        {
          /* Enter last bytes, padded with zeros */
          tmp =  *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
          tmp &= mask[(hcryp->Init.DataType * 2U) + (headersize_in_bytes % 4U)];
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = tmp;
          hcryp->CrypHeaderCount++;
          loopcounter++;
          /* Pad the data with zeros to have a complete block */
          while (loopcounter < 4U)
          {
            ((SAES_TypeDef *)(hcryp->Instance))->DINR = 0x0U;
            loopcounter++;
          }
        }
        /* Call Input transfer complete callback */
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
        /*Call registered Input complete callback*/
        hcryp->InCpltCallback(hcryp);
#else
        /*Call legacy Input complete callback*/
        HAL_CRYP_InCpltCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
      }
      else
      {
        /* Write the first input header block in the Input FIFO,
           the following header data will be fed after interrupt occurrence */
        hcryp->CrypHeaderCount++;
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount - 1U);
        hcryp->CrypHeaderCount++;
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount - 1U);
        hcryp->CrypHeaderCount++;
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount - 1U);
        hcryp->CrypHeaderCount++;
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount - 1U);
      } /* if (hcryp->Init.HeaderSize == 0U) */ /* Header phase is  skipped*/
    } /* if (IS_SAES_INSTANCE(hcryp->Instance)) */
#endif /* USE_HAL_SAES_ONLY */
  } /* end of if (dokeyivconfig == 1U) */
  else  /* Key and IV have already been configured,
          header has already been processed;
          only process here message payload */
  {
    /* Write the payload Input block in the IN FIFO */
    if (hcryp->Size == 0U)
    {
      /* Disable interrupts */
      __HAL_CRYP_DISABLE_IT(hcryp, CRYP_IT_CCFIE | CRYP_IT_RWEIE | CRYP_IT_KEIE);

      /* Change the CRYP state */
      hcryp->State = HAL_CRYP_STATE_READY;
      __HAL_UNLOCK(hcryp);
    }
    else if (hcryp->Size >= 16U)
    {
      hcryp->CrypInCount++;
      ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount - 1U);
      hcryp->CrypInCount++;
      ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount - 1U);
      hcryp->CrypInCount++;
      ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount - 1U);
      hcryp->CrypInCount++;
      ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount - 1U);

      if ((hcryp->CrypInCount == (hcryp->Size / 4U)) && ((hcryp->Size % 16U) == 0U))
      {
        /* Call Input transfer complete callback */
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
        /*Call registered Input complete callback*/
        hcryp->InCpltCallback(hcryp);
#else
        /*Call legacy Input complete callback*/
        HAL_CRYP_InCpltCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
      }
    }
    else /* Size < 4 words  : first block is the last block*/
    {
      /* Compute the number of padding bytes in last block of payload */
      npblb = 16U - (uint32_t)hcryp->Size;

      mode = CRYP_CONV_ALGODIR(((SAES_TypeDef *)(hcryp->Instance))->CR & SAES_CR_MODE);
      if (((mode == CRYP_OPERATINGMODE_ENCRYPT) && (hcryp->Init.Algorithm == CRYP_AES_GCM)) ||
          ((mode == CRYP_OPERATINGMODE_DECRYPT) && (hcryp->Init.Algorithm == CRYP_AES_CCM)))
      {
        /* Specify the number of non-valid bytes using NPBLB register*/
        MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_NPBLB, npblb << 20U);
      }

      /* Number of valid words (lastwordsize) in last block */
      if ((npblb % 4U) == 0U)
      {
        lastwordsize = (16U - npblb) / 4U;
      }
      else
      {
        lastwordsize = ((16U - npblb) / 4U) + 1U;
      }

      /*  Last block optionally pad the data with zeros*/
      for (loopcounter = 0U; loopcounter < lastwordsize; loopcounter++)
      {
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
        hcryp->CrypInCount++;
      }
      while (loopcounter < 4U)
      {
        /* Pad the data with zeros to have a complete block */
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = 0x0U;
        loopcounter++;
      }
      /* Call Input transfer complete callback */
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
      /*Call registered Input complete callback*/
      hcryp->InCpltCallback(hcryp);
#else
      /*Call legacy Input complete callback*/
      HAL_CRYP_InCpltCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
    }
  } /* end of if (DoKeyIVConfig == 1U) */

  /* Return function status */
  return HAL_OK;
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_AESCCM_Process_DMA(CRYP_HandleTypeDef *hcryp)
{
  uint32_t wordsize = (uint32_t)(hcryp->Size) / 4U ;
  uint32_t index;
  uint32_t npblb;
  uint32_t lastwordsize = 0U;
  uint32_t temp[4] = {0};/* Temporary CrypOutBuff */
  uint32_t DoKeyIVConfig = 1U; /* By default, carry out peripheral Key and IV configuration */
  uint32_t mode;
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  uint32_t tickstart;
#endif /* USE_HAL_CRYP_ONLY */

  if (hcryp->Init.KeyIVConfigSkip == CRYP_KEYIVCONFIG_ONCE)
  {
    if (hcryp->KeyIVConfig == 1U)
    {
      /* If the Key and IV configuration has to be done only once
      and if it has already been done, skip it */
      DoKeyIVConfig = 0U;
      hcryp->SizesSum += hcryp->Size; /* Compute message total payload length */
    }
    else
    {
      /* If the Key and IV configuration has to be done only once
      and if it has not been done already, do it and set KeyIVConfig
      to keep track it won't have to be done again next time */
      hcryp->KeyIVConfig = 1U;
      hcryp->SizesSum = hcryp->Size; /* Merely store payload length */
    }
  }
  else
  {
    hcryp->SizesSum = hcryp->Size;
  }

  if (DoKeyIVConfig == 1U)
  {
    /*  Reset CrypHeaderCount */
    hcryp->CrypHeaderCount = 0U;

    /************************** Init phase **************************************/
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      CRYP_SET_PHASE(hcryp, CRYP_PHASE_INIT);

      /* Set the Key */
      if (hcryp->Init.KeyIVConfigSkip != CRYP_KEYNOCONFIG)
      {
        if (hcryp->Init.KeyMode != CRYP_KEYMODE_SHARED)
        {
          CRYP_SetKey(hcryp, hcryp->Init.KeySize);
        }
        else /*after sharing the key, AES should set KMOD[1:0] to 00.*/
        {
          ((CRYP_TypeDef *)(hcryp->Instance))->CR &=  ~CRYP_KEYMODE_SHARED;
        }
      }
      /* Set the initialization vector (IV) with CTR1 information */
      ((CRYP_TypeDef *)(hcryp->Instance))->IV0LR = (hcryp->Init.B0[0]) & CRYP_CCM_CTR1_0;
      ((CRYP_TypeDef *)(hcryp->Instance))->IV0RR = hcryp->Init.B0[1];
      ((CRYP_TypeDef *)(hcryp->Instance))->IV1LR = hcryp->Init.B0[2];
      ((CRYP_TypeDef *)(hcryp->Instance))->IV1RR = (hcryp->Init.B0[3] & CRYP_CCM_CTR1_1) |  CRYP_CCM_CTR1_2;

      /* Enable the CRYP peripheral */
      __HAL_CRYP_ENABLE(hcryp);

      /*Write the B0 packet into CRYP_DR*/
      ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.B0);
      ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.B0 + 1);
      ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.B0 + 2);
      ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.B0 + 3);

      /* Get tick */
      tickstart = HAL_GetTick();

      /*Wait for the CRYPEN bit to be cleared*/
      while ((((CRYP_TypeDef *)(hcryp->Instance))->CR & CRYP_CR_CRYPEN) == CRYP_CR_CRYPEN)
      {
        /* Check for the Timeout */
        if ((HAL_GetTick() - tickstart) > CRYP_TIMEOUT_GCMCCMINITPHASE)
        {
          /* Disable the CRYP peripheral clock */
          __HAL_CRYP_DISABLE(hcryp);

          /* Change state */
          hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
          hcryp->State = HAL_CRYP_STATE_READY;

          /* Process unlocked */
          __HAL_UNLOCK(hcryp);
          return HAL_ERROR;
        }
      }
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      SAES_SET_PHASE(hcryp, SAES_PHASE_INIT);

      /* We should re-write Key, in the case where we change key after first operation */
      if ((hcryp->Init.KeySelect == CRYP_KEYSEL_NORMAL) && (hcryp->Init.KeyMode == CRYP_KEYMODE_NORMAL))
      {
        /* Set the Key */
        CRYP_SetKey(hcryp, hcryp->Init.KeySize);
      };

      /* Set the initialization vector (IV) with B0 */
      ((SAES_TypeDef *)(hcryp->Instance))->IVR3 = *(uint32_t *)(hcryp->Init.B0);
      ((SAES_TypeDef *)(hcryp->Instance))->IVR2 = *(uint32_t *)(hcryp->Init.B0 + 1U);
      ((SAES_TypeDef *)(hcryp->Instance))->IVR1 = *(uint32_t *)(hcryp->Init.B0 + 2U);
      ((SAES_TypeDef *)(hcryp->Instance))->IVR0 = *(uint32_t *)(hcryp->Init.B0 + 3U);

      /* Enable the CRYP peripheral */
      __HAL_CRYP_ENABLE(hcryp);

      /* just wait for hash computation */
      if (CRYP_WaitOnCCFlag(hcryp, CRYP_TIMEOUT_GCMCCMINITPHASE) != HAL_OK)
      {
        /* Disable the CRYP peripheral clock */
        __HAL_CRYP_DISABLE(hcryp);

        /* Change state */
        hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
        hcryp->State = HAL_CRYP_STATE_READY;

        /* Process unlocked */
        __HAL_UNLOCK(hcryp);
        return HAL_ERROR;
      }
      /* Clear CCF flag */
      __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);
    }
#endif /* USE_HAL_SAES_ONLY */

    /********************* Header phase *****************************************/

    if (CRYP_GCMCCM_SetHeaderPhase_DMA(hcryp) != HAL_OK)
    {
      return HAL_ERROR;
    }

    /******************** Payload phase *****************************************/

    /* Set the phase */
    hcryp->Phase = CRYP_PHASE_PROCESS;

    /* Select payload phase once the header phase is performed */
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      /* Disable the CRYP peripheral */
      __HAL_CRYP_DISABLE(hcryp);

      CRYP_SET_PHASE(hcryp, CRYP_PHASE_PAYLOAD);

      /* Set to 0 the number of non-valid bytes using NPBLB register*/
      MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_NPBLB, 0U);

      /* Enable the CRYP peripheral */
      __HAL_CRYP_ENABLE(hcryp);
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      SAES_SET_PHASE(hcryp, SAES_PHASE_PAYLOAD);

      /* Set to 0 the number of non-valid bytes using NPBLB register*/
      MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_NPBLB, 0U);
    }
#endif /* USE_CRYP_INSTANCE */
  } /* if (DoKeyIVConfig == 1U) */

  if (hcryp->Size == 0U)
  {
    /* Process unLocked */
    __HAL_UNLOCK(hcryp);

    /* Change the CRYP state and phase */
    hcryp->State = HAL_CRYP_STATE_READY;
  }
  else if (hcryp->Size >= 16U)
  {
    wordsize = wordsize - (wordsize % 4U);
    /* DMA transfer */
    CRYP_SetDMAConfig(hcryp, (uint32_t)(hcryp->pCrypInBuffPtr), (uint16_t) wordsize * 4U,
                      (uint32_t)(hcryp->pCrypOutBuffPtr));
  }
  else /* length of input data is  < 16U */
  {
    /* Compute the number of padding bytes in last block of payload */
    npblb = 16U - (uint32_t)(hcryp->Size);

    /* Set Npblb in case of AES CCM payload decryption to get right tag*/
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      mode = ((CRYP_TypeDef *)(hcryp->Instance))->CR & CRYP_CR_ALGODIR;

      if (mode == CRYP_OPERATINGMODE_DECRYPT)
      {
        /* Specify the number of non-valid bytes using NPBLB register*/
        MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_NPBLB, npblb << 20);
      }

      /* Enable CRYP to start the final phase */
      __HAL_CRYP_ENABLE(hcryp);

      /* Number of valid words (lastwordsize) in last block */
      if ((npblb % 4U) == 0U)
      {
        lastwordsize = (16U - npblb) / 4U;
      }
      else
      {
        lastwordsize = ((16U - npblb) / 4U) + 1U;
      }

      /* Write the last input block in the IN FIFO */
      for (index = 0U; index < lastwordsize; index ++)
      {
        ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
        hcryp->CrypInCount++;
      }

      /* Pad the data with zeros to have a complete block */
      while (index < 4U)
      {
        ((CRYP_TypeDef *)(hcryp->Instance))->DIN = 0U;
        index++;
      }

      /* Wait for OFNE flag to be raised */
      if (CRYP_WaitOnOFNEFlag(hcryp, CRYP_TIMEOUT_GCMCCMINITPHASE) != HAL_OK)
      {
        /* Disable the CRYP peripheral clock */
        __HAL_CRYP_DISABLE(hcryp);

        /* Change state & update error code */
        hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
        hcryp->State = HAL_CRYP_STATE_READY;

        /* Process unlocked */
        __HAL_UNLOCK(hcryp);
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
        /*Call registered error callback*/
        hcryp->ErrorCallback(hcryp);
#else
        /*Call legacy error callback*/
        HAL_CRYP_ErrorCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
      }

      /*Read the output block from the output FIFO */
      for (index = 0U; index < 4U; index++)
      {
        /* Read the output block from the output FIFO and put them in temporary buffer then get CrypOutBuff from
           temporary buffer */
        temp[index] = ((CRYP_TypeDef *)(hcryp->Instance))->DOUT;
      }
    } /* SAES peripheral */
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      mode = CRYP_CONV_ALGODIR(((SAES_TypeDef *)(hcryp->Instance))->CR & SAES_CR_MODE);

      if (mode == CRYP_OPERATINGMODE_DECRYPT)
      {
        /* Specify the number of non-valid bytes using NPBLB register*/
        MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_NPBLB, npblb << 20);
      }

      /* Number of valid words (lastwordsize) in last block */
      if ((npblb % 4U) == 0U)
      {
        lastwordsize = (16U - npblb) / 4U;
      }
      else
      {
        lastwordsize = ((16U - npblb) / 4U) + 1U;
      }

      /* Write the last input block in the IN FIFO */
      for (index = 0U; index < lastwordsize; index ++)
      {
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
        hcryp->CrypInCount++;
      }

      /* Pad the data with zeros to have a complete block */
      while (index < 4U)
      {
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = 0U;
        index++;
      }
      /* just wait for hash computation */
      if (CRYP_WaitOnCCFlag(hcryp, CRYP_TIMEOUT_GCMCCMINITPHASE) != HAL_OK)
      {
        /* Disable the CRYP peripheral clock */
        __HAL_CRYP_DISABLE(hcryp);

        /* Change state & update error code */
        hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
        hcryp->State = HAL_CRYP_STATE_READY;

        /* Process unlocked */
        __HAL_UNLOCK(hcryp);
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
        /*Call registered error callback*/
        hcryp->ErrorCallback(hcryp);
#else
        /*Call legacy error callback*/
        HAL_CRYP_ErrorCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
      }
      /* Clear CCF flag */
      __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);

      /*Read the output block from the output FIFO */
      for (index = 0U; index < 4U; index++)
      {
        /* Read the output block from the output FIFO and put them in temporary buffer then get CrypOutBuff from
           temporary buffer */
        temp[index] = ((SAES_TypeDef *)(hcryp->Instance))->DOUTR;
      }
    }
#endif /* USE_HAL_SAES_ONLY */

    for (index = 0; index < lastwordsize; index++)
    {
      *(uint32_t *)(hcryp->pCrypOutBuffPtr + hcryp->CrypOutCount) = temp[index];
      hcryp->CrypOutCount++;
    }

    /* Change the CRYP state to ready */
    hcryp->State = HAL_CRYP_STATE_READY;

    /* Process unlocked */
    __HAL_UNLOCK(hcryp);
  }

  /* Return function status */
  return HAL_OK;
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static void CRYP_GCMCCM_SetPayloadPhase_IT(CRYP_HandleTypeDef *hcryp)
{
  uint32_t loopcounter;
  uint32_t temp[4] = {0};/* Temporary CrypOutBuff */
  uint32_t lastwordsize;
  uint32_t npblb;
  uint32_t mode;
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  uint8_t negative = 0U;
#endif /* USE_HAL_CRYP_ONLY */
  uint32_t i;

  /***************************** Payload phase *******************************/
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  if (IS_CRYP_INSTANCE(hcryp->Instance))
  {
    if ((hcryp->Size / 4U) < hcryp->CrypInCount)
    {
      negative = 1U;
    }

    if (hcryp->Size == 0U)
    {
      /* Disable interrupts */
      __HAL_CRYP_DISABLE_IT(hcryp, CRYP_IT_INI | CRYP_IT_OUTI);

      /* Process unlocked */
      __HAL_UNLOCK(hcryp);

      /* Change the CRYP state */
      hcryp->State = HAL_CRYP_STATE_READY;
    }

    else if ((((hcryp->Size / 4U) - (hcryp->CrypInCount)) >= 4U) &&
             (negative == 0U))
    {
      if ((((CRYP_TypeDef *)(hcryp->Instance))->IMSCR & CRYP_IMSCR_INIM) != 0x0U)
      {

#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
        /* If suspension flag has been raised, suspend processing
           only if not already at the end of the payload */
        if (hcryp->SuspendRequest == HAL_CRYP_SUSPEND)
        {
          /* Wait until both the IN and the OUT FIFOs are empty (IFEM=1 and OFNE=0 in the
             CRYP_SR) and the BUSY bit is cleared */
          while (((((CRYP_TypeDef *)(hcryp->Instance))->SR) & (CRYP_SR_IFEM | CRYP_SR_OFNE | \
                                                               CRYP_SR_BUSY)) != CRYP_SR_IFEM)
          {
            /* Nothing to do */
          }

          /* Disable interrupts */
          __HAL_CRYP_DISABLE_IT(hcryp, CRYP_IT_INI | CRYP_IT_OUTI);

          /* Disable CRYP */
          __HAL_CRYP_DISABLE(hcryp);

          /* reset SuspendRequest */
          hcryp->SuspendRequest = HAL_CRYP_SUSPEND_NONE;

          /* Change the CRYP state */
          hcryp->State = HAL_CRYP_STATE_SUSPENDED;

          /* Mark that the payload phase is suspended */
          hcryp->Phase = CRYP_PHASE_PAYLOAD_SUSPENDED;

          /* Process Unlocked */
          __HAL_UNLOCK(hcryp);
        }
        else
#endif /* USE_HAL_CRYP_SUSPEND_RESUME */
        {
          /* Write the input block in the IN FIFO */
          ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
          hcryp->CrypInCount++;
          ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
          hcryp->CrypInCount++;
          ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
          hcryp->CrypInCount++;
          ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
          hcryp->CrypInCount++;
          if (((hcryp->Size / 4U) == hcryp->CrypInCount) && ((hcryp->Size % 16U) == 0U))
          {
            /* Disable interrupts */
            __HAL_CRYP_DISABLE_IT(hcryp, CRYP_IT_INI);
            /* Call the input data transfer complete callback */
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
            /*Call registered Input complete callback*/
            hcryp->InCpltCallback(hcryp);
#else
            /*Call legacy Input complete callback*/
            HAL_CRYP_InCpltCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
          }

          if (hcryp->CrypOutCount < (hcryp->Size / 4U))
          {
            if ((((CRYP_TypeDef *)(hcryp->Instance))->SR & CRYP_FLAG_OFNE) != 0x0U)
            {
              /* Read the output block from the Output FIFO and put them in temporary buffer then get CrypOutBuff from
                 temporary buffer  */
              for (i = 0U; i < 4U; i++)
              {
                temp[i] = ((CRYP_TypeDef *)(hcryp->Instance))->DOUT;
              }
              i = 0U;
              while (((hcryp->CrypOutCount < ((hcryp->Size) / 4U))) && (i < 4U))
              {
                *(uint32_t *)(hcryp->pCrypOutBuffPtr + hcryp->CrypOutCount) = temp[i];
                hcryp->CrypOutCount++;
                i++;
              }
              if (((hcryp->Size / 4U) == hcryp->CrypOutCount) && ((hcryp->Size % 16U) == 0U))
              {
                /* Disable interrupts */
                __HAL_CRYP_DISABLE_IT(hcryp, CRYP_IT_OUTI);

                /* Change the CRYP state */
                hcryp->State = HAL_CRYP_STATE_READY;

                /* Disable CRYP */
                __HAL_CRYP_DISABLE(hcryp);

                /* Process unlocked */
                __HAL_UNLOCK(hcryp);

                /* Call output transfer complete callback */
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
                /*Call registered Output complete callback*/
                hcryp->OutCpltCallback(hcryp);
#else
                /*Call legacy Output complete callback*/
                HAL_CRYP_OutCpltCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
              }
            }
          }
        } /* if (hcryp->SuspendRequest == HAL_CRYP_SUSPEND) */
      }
    }
    else if ((hcryp->Size % 16U) != 0U)
    {
      /* Set padding only in case of input fifo interrupt */
      if ((((CRYP_TypeDef *)(hcryp->Instance))->IMSCR & CRYP_IMSCR_INIM) != 0x0U)
      {
        /* Compute the number of padding bytes in last block of payload */
        npblb = ((((uint32_t)hcryp->Size / 16U) + 1U) * 16U) - (uint32_t)(hcryp->Size);

        mode = ((CRYP_TypeDef *)(hcryp->Instance))->CR & CRYP_CR_ALGODIR;
        if (((mode == CRYP_OPERATINGMODE_ENCRYPT) && (hcryp->Init.Algorithm == CRYP_AES_GCM)) ||
            ((mode == CRYP_OPERATINGMODE_DECRYPT) && (hcryp->Init.Algorithm == CRYP_AES_CCM)))
        {
          /* Disable the CRYP */
          __HAL_CRYP_DISABLE(hcryp);

          /* Specify the number of non-valid bytes using NPBLB register*/
          MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_NPBLB, npblb << 20);

          /* Enable CRYP to start the final phase */
          __HAL_CRYP_ENABLE(hcryp);
        }


        /* Number of valid words (lastwordsize) in last block */
        if ((npblb % 4U) == 0U)
        {
          lastwordsize = (16U - npblb) / 4U;
        }
        else
        {
          lastwordsize = ((16U - npblb) / 4U) + 1U;
        }

        /* Write the last input block in the IN FIFO */
        for (loopcounter = 0U; loopcounter < lastwordsize; loopcounter++)
        {
          ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
          hcryp->CrypInCount++;
        }
        /* Pad the data with zeros to have a complete block */
        while (loopcounter < 4U)
        {
          ((CRYP_TypeDef *)(hcryp->Instance))->DIN = 0U;
          loopcounter++;
        }

        /* Disable the input FIFO Interrupt */
        __HAL_CRYP_DISABLE_IT(hcryp, CRYP_IT_INI);
      }

      /*Read the output block from the output FIFO */
      if ((((CRYP_TypeDef *)(hcryp->Instance))->SR & CRYP_FLAG_OFNE) != 0x0U)
      {
        for (i = 0U; i < 4U; i++)
        {
          temp[i] = ((CRYP_TypeDef *)(hcryp->Instance))->DOUT;
        }
        if (((hcryp->Size) / 4U) == 0U)
        {
          for (i = 0U; (uint16_t)i < ((hcryp->Size) % 4U); i++)
          {
            *(uint32_t *)(hcryp->pCrypOutBuffPtr + hcryp->CrypOutCount) = temp[i];
            hcryp->CrypOutCount++;
          }
        }
        i = 0U;
        while (((hcryp->CrypOutCount < ((hcryp->Size) / 4U))) && (i < 4U))
        {
          *(uint32_t *)(hcryp->pCrypOutBuffPtr + hcryp->CrypOutCount) = temp[i];
          hcryp->CrypOutCount++;
          i++;
        }
      }

      /* Disable the output FIFO Interrupt */
      if (hcryp->CrypOutCount >= ((hcryp->Size) / 4U))
      {
        /* Disable interrupts */
        __HAL_CRYP_DISABLE_IT(hcryp, CRYP_IT_OUTI | CRYP_IT_INI);

        /* Change the CRYP peripheral state */
        hcryp->State = HAL_CRYP_STATE_READY;

        /* Process unlocked */
        __HAL_UNLOCK(hcryp);

        /* Call output transfer complete callback */
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
        /*Call registered Output complete callback*/
        hcryp->OutCpltCallback(hcryp);
#else
        /*Call legacy Output complete callback*/
        HAL_CRYP_OutCpltCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
      }
    }
    else
    {
      /* Nothing to do */
    }
  }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
  if (IS_SAES_INSTANCE(hcryp->Instance))
  {
    uint32_t incount;
    uint32_t outcount;

    /* Read the output block from the output FIFO and put them in temporary buffer then
       get CrypOutBuff from temporary buffer*/
    for (i = 0U; i < 4U; i++)
    {
      temp[i] = ((SAES_TypeDef *)(hcryp->Instance))->DOUTR;
    }
    i = 0U;
    while ((hcryp->CrypOutCount < ((hcryp->Size + 3U) / 4U)) && (i < 4U))
    {
      *(uint32_t *)(hcryp->pCrypOutBuffPtr + hcryp->CrypOutCount) = temp[i];
      hcryp->CrypOutCount++;
      i++;
    }
    incount = hcryp->CrypInCount;
    outcount = hcryp->CrypOutCount;
    if ((outcount >= ((uint32_t)(hcryp->Size) / 4U)) && ((incount * 4U) >= (uint32_t)(hcryp->Size)))
    {

      /* When in CCM with Key and IV configuration skipped, don't disable interruptions */
      if (!((hcryp->Init.Algorithm == CRYP_AES_CCM) && (hcryp->KeyIVConfig == 1U)))
      {
        /* Disable computation complete flag and errors interrupts */
        __HAL_CRYP_DISABLE_IT(hcryp, CRYP_IT_CCFIE | CRYP_IT_RWEIE | CRYP_IT_KEIE);
      }

      /* Change the CRYP state */
      hcryp->State = HAL_CRYP_STATE_READY;
      __HAL_UNLOCK(hcryp);

      /* Call output transfer complete callback */
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
      /*Call registered Output complete callback*/
      hcryp->OutCpltCallback(hcryp);
#else
      /*Call legacy Output complete callback*/
      HAL_CRYP_OutCpltCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
    }

    else if (((hcryp->Size / 4U) - (hcryp->CrypInCount)) >= 4U)
    {

#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
      /* If suspension flag has been raised, suspend processing
         only if not already at the end of the payload */
      if (hcryp->SuspendRequest == HAL_CRYP_SUSPEND)
      {
        /* Clear CCF Flag */
        __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);

        /* reset SuspendRequest */
        hcryp->SuspendRequest = HAL_CRYP_SUSPEND_NONE;
        /* Disable Computation Complete Flag and Errors Interrupts */
        __HAL_CRYP_DISABLE_IT(hcryp, CRYP_IT_CCFIE | CRYP_IT_RWEIE | CRYP_IT_KEIE);
        /* Change the CRYP state */
        hcryp->State = HAL_CRYP_STATE_SUSPENDED;
        /* Mark that the payload phase is suspended */
        hcryp->Phase = CRYP_PHASE_PAYLOAD_SUSPENDED;
        __HAL_UNLOCK(hcryp);
      }
      else
#endif /* USE_HAL_CRYP_SUSPEND_RESUME */
      {
        /* Write the input block in the IN FIFO */
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
        hcryp->CrypInCount++;
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
        hcryp->CrypInCount++;
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
        hcryp->CrypInCount++;
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
        hcryp->CrypInCount++;
        if ((hcryp->CrypInCount ==  hcryp->Size) && (hcryp->Init.Algorithm == CRYP_AES_GCM))
        {
          /* Call output transfer complete callback */
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
          /*Call registered Input complete callback*/
          hcryp->InCpltCallback(hcryp);
#else
          /*Call legacy Input complete callback*/
          HAL_CRYP_InCpltCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
        }
      }
    }
    else /* Last block of payload < 128bit*/
    {
      /* Compute the number of padding bytes in last block of payload */
      npblb = ((((uint32_t)hcryp->Size / 16U) + 1U) * 16U) - ((uint32_t)hcryp->Size);

      mode = CRYP_CONV_ALGODIR(((SAES_TypeDef *)(hcryp->Instance))->CR & SAES_CR_MODE);
      if (((mode == CRYP_OPERATINGMODE_ENCRYPT) && (hcryp->Init.Algorithm == CRYP_AES_GCM)) ||
          ((mode == CRYP_OPERATINGMODE_DECRYPT) && (hcryp->Init.Algorithm == CRYP_AES_CCM)))
      {
        /* Specify the number of non-valid bytes using NPBLB register*/
        MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_NPBLB, npblb << 20);
      }

      /* Number of valid words (lastwordsize) in last block */
      if ((npblb % 4U) == 0U)
      {
        lastwordsize = (16U - npblb) / 4U;
      }
      else
      {
        lastwordsize = ((16U - npblb) / 4U) + 1U;
      }

      /*  Last block optionally pad the data with zeros*/
      for (loopcounter = 0U; loopcounter < lastwordsize; loopcounter++)
      {
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
        hcryp->CrypInCount++;
      }
      while (loopcounter < 4U)
      {
        /* pad the data with zeros to have a complete block */
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = 0x0U;
        loopcounter++;
      }
    }
  } /* if (IS_SAES_INSTANCE(hcryp->Instance)) */
#endif /* USE_HAL_SAES_ONLY */
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_GCMCCM_SetHeaderPhase(CRYP_HandleTypeDef *hcryp, uint32_t Timeout)
{
  uint32_t loopcounter;
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
  uint32_t headersize_in_bytes;
  uint32_t tmp;
  const uint32_t mask[16] = {0x0U, 0xFF000000U, 0xFFFF0000U, 0xFFFFFF00U,  /* 32-bit data type */
                             0x0U, 0x0000FF00U, 0x0000FFFFU, 0xFF00FFFFU,  /* 16-bit data type */
                             0x0U, 0x000000FFU, 0x0000FFFFU, 0x00FFFFFFU,  /*  8-bit data type */
                             0x0U, 0x000000FFU, 0x0000FFFFU, 0x00FFFFFFU   /*  1-bit data type */
                            };
#endif /* USE_HAL_SAES_ONLY */

  /***************************** Header phase for GCM/GMAC or CCM *********************************/

  /* Select header phase */
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  if (IS_CRYP_INSTANCE(hcryp->Instance))
  {
    CRYP_SET_PHASE(hcryp, CRYP_PHASE_HEADER);
    /* Enable the CRYP peripheral */
    __HAL_CRYP_ENABLE(hcryp);

    if ((hcryp->Init.HeaderSize % 4U) == 0U)
    {
      /* HeaderSize %4, no padding */
      for (loopcounter = 0U; (loopcounter < hcryp->Init.HeaderSize); loopcounter += 4U)
      {
        ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++ ;
        ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++ ;
        ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++ ;
        ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++ ;

        /* Wait for IFEM to be raised */
        if (CRYP_WaitOnIFEMFlag(hcryp, Timeout) != HAL_OK)
        {
          /* Disable the CRYP peripheral clock */
          __HAL_CRYP_DISABLE(hcryp);

          /* Change state */
          hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
          hcryp->State = HAL_CRYP_STATE_READY;

          /* Process unlocked */
          __HAL_UNLOCK(hcryp);
          return HAL_ERROR;
        }
      }
    }
    else
    {
      /*Write header block in the IN FIFO without last block */
      for (loopcounter = 0U; (loopcounter < ((hcryp->Init.HeaderSize) - (hcryp->Init.HeaderSize % 4U)));
           loopcounter += 4U)
      {
        ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++ ;
        ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++ ;
        ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++ ;
        ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++ ;

        /* Wait for IFEM to be raised */
        if (CRYP_WaitOnIFEMFlag(hcryp, Timeout) != HAL_OK)
        {
          /* Disable the CRYP peripheral clock */
          __HAL_CRYP_DISABLE(hcryp);

          /* Change state */
          hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
          hcryp->State = HAL_CRYP_STATE_READY;

          /* Process unlocked */
          __HAL_UNLOCK(hcryp);
          return HAL_ERROR;
        }
      }
      /*  Last block optionally pad the data with zeros*/
      for (loopcounter = 0U; (loopcounter < (hcryp->Init.HeaderSize % 4U)); loopcounter++)
      {
        ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++ ;
      }
      while (loopcounter < 4U)
      {
        /* pad the data with zeros to have a complete block */
        ((CRYP_TypeDef *)(hcryp->Instance))->DIN = 0x0U;
        loopcounter++;
      }
      /* Wait for IFEM to be raised */
      if (CRYP_WaitOnIFEMFlag(hcryp, Timeout) != HAL_OK)
      {
        /* Disable the CRYP peripheral clock */
        __HAL_CRYP_DISABLE(hcryp);

        /* Change state */
        hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
        hcryp->State = HAL_CRYP_STATE_READY;

        /* Process unlocked */
        __HAL_UNLOCK(hcryp);
        return HAL_ERROR;
      }
    }
  }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
  if (IS_SAES_INSTANCE(hcryp->Instance))
  {
    if (hcryp->Init.HeaderWidthUnit == CRYP_HEADERWIDTHUNIT_WORD)
    {
      headersize_in_bytes = hcryp->Init.HeaderSize * 4U;
    }
    else
    {
      headersize_in_bytes = hcryp->Init.HeaderSize;
    }

    /* Set Header phase */
    SAES_SET_PHASE(hcryp, SAES_PHASE_HEADER);

    /* Enable the CRYP peripheral */
    __HAL_CRYP_ENABLE(hcryp);

    if ((headersize_in_bytes % 16U) == 0U)
    {
      /* HeaderSize %4, no padding */
      for (loopcounter = 0U; (loopcounter < (headersize_in_bytes / 4U)); loopcounter += 4U)
      {
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++ ;
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++ ;
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++ ;
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++ ;

        /* Wait for CCF to be raised */
        if (CRYP_WaitOnCCFlag(hcryp, Timeout) != HAL_OK)
        {
          /* Disable the CRYP peripheral clock */
          __HAL_CRYP_DISABLE(hcryp);

          /* Change state */
          hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
          hcryp->State = HAL_CRYP_STATE_READY;

          /* Process unlocked */
          __HAL_UNLOCK(hcryp);
          return HAL_ERROR;
        }
        /* Clear CCF flag */
        __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);
      }
    }
    else
    {
      /*Write header block in the IN FIFO without last block */
      for (loopcounter = 0U; (loopcounter < ((headersize_in_bytes / 16U) * 4U)); loopcounter += 4U)
      {
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++ ;
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++ ;
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++ ;
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++ ;

        /* Wait for CCF to be raised */
        if (CRYP_WaitOnCCFlag(hcryp, Timeout) != HAL_OK)
        {
          /* Disable the CRYP peripheral clock */
          __HAL_CRYP_DISABLE(hcryp);

          /* Change state */
          hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
          hcryp->State = HAL_CRYP_STATE_READY;

          /* Process unlocked */
          __HAL_UNLOCK(hcryp);
          return HAL_ERROR;
        }
        /* Clear CCF flag */
        __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);
      }
      /* Write last complete words */
      for (loopcounter = 0U; (loopcounter < ((headersize_in_bytes / 4U) % 4U)); loopcounter++)
      {
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++ ;
      }
      /* If the header size is a multiple of words */
      if ((headersize_in_bytes % 4U) == 0U)
      {
        /* Pad the data with zeros to have a complete block */
        while (loopcounter < 4U)
        {
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = 0x0U;
          loopcounter++;
        }
      }
      else
      {
        /* Enter last bytes, padded with zeros */
        tmp =  *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        tmp &= mask[(SAES_CONV_DATATYPE(hcryp->Init.DataType) * 2U) + (headersize_in_bytes % 4U)];
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = tmp;
        loopcounter++;
        /* Pad the data with zeros to have a complete block */
        while (loopcounter < 4U)
        {
          /* pad the data with zeros to have a complete block */
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = 0x0U;
          loopcounter++;
        }
      }

      /* Wait for CCF to be raised */
      if (CRYP_WaitOnCCFlag(hcryp, Timeout) != HAL_OK)
      {
        /* Disable the CRYP peripheral clock */
        __HAL_CRYP_DISABLE(hcryp);

        /* Change state */
        hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
        hcryp->State = HAL_CRYP_STATE_READY;

        /* Process unlocked */
        __HAL_UNLOCK(hcryp);
        return HAL_ERROR;
      }
      /* Clear CCF flag */
      __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);
    }
  }
#endif /* USE_HAL_SAES_ONLY */
  /* Wait until the complete message has been processed */
  if (CRYP_WaitOnBUSYFlag(hcryp, Timeout) != HAL_OK)
  {
    /* Disable the CRYP peripheral clock */
    __HAL_CRYP_DISABLE(hcryp);

    /* Change state */
    hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
    hcryp->State = HAL_CRYP_STATE_READY;

    /* Process unlocked & return error */
    __HAL_UNLOCK(hcryp);
    return HAL_ERROR;
  }
  /* Return function status */
  return HAL_OK;
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_GCMCCM_SetHeaderPhase_DMA(CRYP_HandleTypeDef *hcryp)
{
  uint32_t loopcounter;
  uint32_t Timeout = CRYP_TIMEOUT_GCMCCMHEADERPHASE;
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
  uint32_t headersize_in_bytes;
  uint32_t tmp;
  const uint32_t mask[16] = {0x0U, 0xFF000000U, 0xFFFF0000U, 0xFFFFFF00U,  /* 32-bit data type */
                             0x0U, 0x0000FF00U, 0x0000FFFFU, 0xFF00FFFFU,  /* 16-bit data type */
                             0x0U, 0x000000FFU, 0x0000FFFFU, 0x00FFFFFFU,  /*  8-bit data type */
                             0x0U, 0x000000FFU, 0x0000FFFFU, 0x00FFFFFFU   /*  1-bit data type */
                            };
#endif /* USE_HAL_SAES_ONLY */

  /***************************** Header phase for GCM/GMAC or CCM *********************************/
  if ((hcryp->Init.HeaderSize != 0U))
  {
    /* Select header phase */
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      CRYP_SET_PHASE(hcryp, CRYP_PHASE_HEADER);
      /* Enable the CRYP peripheral */
      __HAL_CRYP_ENABLE(hcryp);

      if ((hcryp->Init.HeaderSize % 4U) == 0U)
      {
        /* HeaderSize %4, no padding */
        for (loopcounter = 0U; (loopcounter < hcryp->Init.HeaderSize); loopcounter += 4U)
        {
          ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
          hcryp->CrypHeaderCount++ ;
          ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
          hcryp->CrypHeaderCount++ ;
          ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
          hcryp->CrypHeaderCount++ ;
          ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
          hcryp->CrypHeaderCount++ ;

          /* Wait for IFEM to be raised */
          if (CRYP_WaitOnIFEMFlag(hcryp, Timeout) != HAL_OK)
          {
            /* Disable the CRYP peripheral clock */
            __HAL_CRYP_DISABLE(hcryp);

            /* Change state */
            hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
            hcryp->State = HAL_CRYP_STATE_READY;

            /* Process unlocked */
            __HAL_UNLOCK(hcryp);
            return HAL_ERROR;
          }
        }
      }
      else
      {
        /*Write header block in the IN FIFO without last block */
        for (loopcounter = 0U; (loopcounter < ((hcryp->Init.HeaderSize) - (hcryp->Init.HeaderSize % 4U)));
             loopcounter += 4U)
        {
          ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
          hcryp->CrypHeaderCount++ ;
          ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
          hcryp->CrypHeaderCount++ ;
          ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
          hcryp->CrypHeaderCount++ ;
          ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
          hcryp->CrypHeaderCount++ ;

          /* Wait for IFEM to be raised */
          if (CRYP_WaitOnIFEMFlag(hcryp, Timeout) != HAL_OK)
          {
            /* Disable the CRYP peripheral clock */
            __HAL_CRYP_DISABLE(hcryp);

            /* Change state */
            hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
            hcryp->State = HAL_CRYP_STATE_READY;

            /* Process unlocked */
            __HAL_UNLOCK(hcryp);
            return HAL_ERROR;
          }
        }
        /*  Last block optionally pad the data with zeros*/
        for (loopcounter = 0U; (loopcounter < (hcryp->Init.HeaderSize % 4U)); loopcounter++)
        {
          ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
          hcryp->CrypHeaderCount++ ;
        }
        while (loopcounter < 4U)
        {
          /* Pad the data with zeros to have a complete block */
          ((CRYP_TypeDef *)(hcryp->Instance))->DIN = 0x0U;
          loopcounter++;
        }

        /* Wait for IFEM to be raised */
        if (CRYP_WaitOnIFEMFlag(hcryp, Timeout) != HAL_OK)
        {
          /* Disable the CRYP peripheral clock */
          __HAL_CRYP_DISABLE(hcryp);

          /* Change state */
          hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
          hcryp->State = HAL_CRYP_STATE_READY;

          /* Process unlocked */
          __HAL_UNLOCK(hcryp);
          return HAL_ERROR;
        }
      }
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      if (hcryp->Init.HeaderWidthUnit == CRYP_HEADERWIDTHUNIT_WORD)
      {
        headersize_in_bytes = hcryp->Init.HeaderSize * 4U;
      }
      else
      {
        headersize_in_bytes = hcryp->Init.HeaderSize;
      }
      /* Set header phase*/
      SAES_SET_PHASE(hcryp, SAES_PHASE_HEADER);

      /* Enable the CRYP peripheral */
      __HAL_CRYP_ENABLE(hcryp);

      if ((headersize_in_bytes % 16U) == 0U)
      {
        /* HeaderSize %4, no padding */
        for (loopcounter = 0U; (loopcounter < hcryp->Init.HeaderSize); loopcounter += 4U)
        {
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
          hcryp->CrypHeaderCount++ ;
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
          hcryp->CrypHeaderCount++ ;
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
          hcryp->CrypHeaderCount++ ;
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
          hcryp->CrypHeaderCount++ ;

          /* Wait for CCF to be raised */
          if (CRYP_WaitOnCCFlag(hcryp, Timeout) != HAL_OK)
          {
            /* Disable the CRYP peripheral clock */
            __HAL_CRYP_DISABLE(hcryp);

            /* Change state */
            hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
            hcryp->State = HAL_CRYP_STATE_READY;

            /* Process unlocked */
            __HAL_UNLOCK(hcryp);
            return HAL_ERROR;
          }
        }
      }
      else
      {
        /*Write header block in the IN FIFO without last block */
        for (loopcounter = 0U; (loopcounter < ((headersize_in_bytes / 16U) * 4U)); loopcounter += 4U)
        {
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
          hcryp->CrypHeaderCount++ ;
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
          hcryp->CrypHeaderCount++ ;
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
          hcryp->CrypHeaderCount++ ;
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
          hcryp->CrypHeaderCount++ ;

          /* Wait for CCF to be raised */
          if (CRYP_WaitOnCCFlag(hcryp, Timeout) != HAL_OK)
          {
            /* Disable the CRYP peripheral clock */
            __HAL_CRYP_DISABLE(hcryp);

            /* Change state */
            hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
            hcryp->State = HAL_CRYP_STATE_READY;

            /* Process unlocked */
            __HAL_UNLOCK(hcryp);
            return HAL_ERROR;
          }
        }
        /* Write last complete words */
        for (loopcounter = 0U; (loopcounter < ((headersize_in_bytes / 4U) % 4U)); loopcounter++)
        {
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
          hcryp->CrypHeaderCount++;
        }
        /* If the header size is a multiple of words */
        if ((headersize_in_bytes % 4U) == 0U)
        {
          /* Pad the data with zeros to have a complete block */
          while (loopcounter < 4U)
          {
            ((SAES_TypeDef *)(hcryp->Instance))->DINR = 0x0U;
            loopcounter++;
          }
        }
        else
        {
          /* Enter last bytes, padded with zeros */
          tmp =  *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
          tmp &= mask[(SAES_CONV_DATATYPE(hcryp->Init.DataType) * 2U) + (headersize_in_bytes % 4U)];
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = tmp;
          loopcounter++;
          /* Pad the data with zeros to have a complete block */
          while (loopcounter < 4U)
          {
            ((SAES_TypeDef *)(hcryp->Instance))->DINR = 0x0U;
            loopcounter++;
          }
        }

        /* Wait for CCF to be raised */
        if (CRYP_WaitOnCCFlag(hcryp, Timeout) != HAL_OK)
        {
          /* Disable the CRYP peripheral clock */
          __HAL_CRYP_DISABLE(hcryp);

          /* Change state */
          hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
          hcryp->State = HAL_CRYP_STATE_READY;

          /* Process unlocked */
          __HAL_UNLOCK(hcryp);
          return HAL_ERROR;
        }
      }
    }
#endif /* USE_HAL_SAES_ONLY */
    /* Wait until the complete message has been processed */
    Timeout = CRYP_GENERAL_TIMEOUT;
    if (CRYP_WaitOnBUSYFlag(hcryp, Timeout) != HAL_OK)
    {
      /* Disable the CRYP peripheral clock */
      __HAL_CRYP_DISABLE(hcryp);

      /* Change state */
      hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
      hcryp->State = HAL_CRYP_STATE_READY;

      /* Process unlocked */
      __HAL_UNLOCK(hcryp);
      return HAL_ERROR;
    }
  }

  /* Return function status */
  return HAL_OK;
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static void CRYP_GCMCCM_SetHeaderPhase_IT(CRYP_HandleTypeDef *hcryp)
{
  uint32_t loopcounter;
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
  uint32_t lastwordsize;
  uint32_t npblb;
  uint32_t mode;
  uint32_t headersize_in_bytes;
  uint32_t tmp;
  const uint32_t mask[16] = {0x0U, 0xFF000000U, 0xFFFF0000U, 0xFFFFFF00U,  /* 32-bit data type */
                             0x0U, 0x0000FF00U, 0x0000FFFFU, 0xFF00FFFFU,  /* 16-bit data type */
                             0x0U, 0x000000FFU, 0x0000FFFFU, 0x00FFFFFFU,  /*  8-bit data type */
                             0x0U, 0x000000FFU, 0x0000FFFFU, 0x00FFFFFFU   /*  1-bit data type */
                            };
#endif /* USE_HAL_SAES_ONLY */

  /***************************** Header phase *********************************/
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  if (IS_CRYP_INSTANCE(hcryp->Instance))
  {
    if (hcryp->Init.HeaderSize == hcryp->CrypHeaderCount)
    {
      /* Disable interrupts */
      __HAL_CRYP_DISABLE_IT(hcryp, CRYP_IT_INI);

      /* Disable the CRYP peripheral */
      __HAL_CRYP_DISABLE(hcryp);

      /* Set to 0 the number of non-valid bytes using NPBLB register*/
      MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_NPBLB, 0U);

      /* Set the phase */
      hcryp->Phase = CRYP_PHASE_PROCESS;

      /* Select payload phase once the header phase is performed */
      CRYP_SET_PHASE(hcryp, CRYP_PHASE_PAYLOAD);

      /* Enable Interrupts */
      __HAL_CRYP_ENABLE_IT(hcryp, CRYP_IT_INI | CRYP_IT_OUTI);

      /* Enable the CRYP peripheral */
      __HAL_CRYP_ENABLE(hcryp);
    }
    else if (((hcryp->Init.HeaderSize) - (hcryp->CrypHeaderCount)) >= 4U)

    {
      /* HeaderSize %4, no padding */
      ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
      hcryp->CrypHeaderCount++ ;
      ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
      hcryp->CrypHeaderCount++ ;
      ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
      hcryp->CrypHeaderCount++ ;
      ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
      hcryp->CrypHeaderCount++ ;
    }
    else
    {
      /*  Last block optionally pad the data with zeros*/
      for (loopcounter = 0U; loopcounter < (hcryp->Init.HeaderSize % 4U); loopcounter++)
      {
        ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++ ;
      }
      while (loopcounter < 4U)
      {
        /* Pad the data with zeros to have a complete block */
        ((CRYP_TypeDef *)(hcryp->Instance))->DIN = 0x0U;
        loopcounter++ ;
      }
    }
  }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
  if (IS_SAES_INSTANCE(hcryp->Instance))
  {
    if (hcryp->Init.HeaderWidthUnit == CRYP_HEADERWIDTHUNIT_WORD)
    {
      headersize_in_bytes = hcryp->Init.HeaderSize * 4U;
    }
    else
    {
      headersize_in_bytes = hcryp->Init.HeaderSize;
    }
    /***************************** Header phase *********************************/
    /* Test whether or not the header phase is over.
       If the test below is true, move to payload phase */
    if (headersize_in_bytes <= ((uint32_t)(hcryp->CrypHeaderCount) * 4U))
    {
      /* Set the phase */
      hcryp->Phase = CRYP_PHASE_PROCESS;
      /* Select payload phase */
      MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_GCMPH, SAES_PHASE_PAYLOAD);
      /* Set to 0 the number of non-valid bytes using NPBLB register*/
      MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_NPBLB, 0U);

      if (hcryp->Init.Algorithm == CRYP_AES_CCM)
      {
        /* Increment CrypHeaderCount to pass in CRYP_GCMCCM_SetPayloadPhase_IT */
        hcryp->CrypHeaderCount++;
      }
      /* Write the payload Input block in the IN FIFO */
      if (hcryp->Size == 0U)
      {
        /* Disable interrupts */
        __HAL_CRYP_DISABLE_IT(hcryp, CRYP_IT_CCFIE | CRYP_IT_RWEIE | CRYP_IT_KEIE);

        /* Change the CRYP state */
        hcryp->State = HAL_CRYP_STATE_READY;
        __HAL_UNLOCK(hcryp);
      }
      else if (hcryp->Size >= 16U)
      {
        ((SAES_TypeDef *)(hcryp->Instance))->DINR  = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
        hcryp->CrypInCount++;
        ((SAES_TypeDef *)(hcryp->Instance))->DINR  = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
        hcryp->CrypInCount++;
        ((SAES_TypeDef *)(hcryp->Instance))->DINR  = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
        hcryp->CrypInCount++;
        ((SAES_TypeDef *)(hcryp->Instance))->DINR  = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
        hcryp->CrypInCount++;

        if ((hcryp->CrypInCount == (hcryp->Size / 4U)) && ((hcryp->Size % 16U) == 0U))
        {
          /* Call the input data transfer complete callback */
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
          /*Call registered Input complete callback*/
          hcryp->InCpltCallback(hcryp);
#else
          /*Call legacy Input complete callback*/
          HAL_CRYP_InCpltCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
        }
      }
      else /* Size < 4 words  : first block is the last block*/
      {
        /* Compute the number of padding bytes in last block of payload */
        npblb = 16U - ((uint32_t)hcryp->Size);
        mode = CRYP_CONV_ALGODIR(((SAES_TypeDef *)(hcryp->Instance))->CR & SAES_CR_MODE);
        if (((mode == CRYP_OPERATINGMODE_ENCRYPT) && (hcryp->Init.Algorithm == CRYP_AES_GCM)) ||
            ((mode == CRYP_OPERATINGMODE_DECRYPT) && (hcryp->Init.Algorithm == CRYP_AES_CCM)))
        {
          /* Specify the number of non-valid bytes using NPBLB register*/
          MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, SAES_CR_NPBLB, npblb << 20U);
        }

        /* Number of valid words (lastwordsize) in last block */
        if ((npblb % 4U) == 0U)
        {
          lastwordsize = (16U - npblb) / 4U;
        }
        else
        {
          lastwordsize = ((16U - npblb) / 4U) + 1U;
        }

        /*  Last block optionally pad the data with zeros*/
        for (loopcounter = 0U; loopcounter < lastwordsize; loopcounter++)
        {
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
          hcryp->CrypInCount++;
        }
        while (loopcounter < 4U)
        {
          /* Pad the data with zeros to have a complete block */
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = 0x0U;
          loopcounter++;
        }
        /* Call the input data transfer complete callback */
#if (USE_HAL_CRYP_REGISTER_CALLBACKS == 1U)
        /*Call registered Input complete callback*/
        hcryp->InCpltCallback(hcryp);
#else
        /*Call legacy Input complete callback*/
        HAL_CRYP_InCpltCallback(hcryp);
#endif /* USE_HAL_CRYP_REGISTER_CALLBACKS */
      }
    }
    else if (((headersize_in_bytes / 4U) - (hcryp->CrypHeaderCount)) >= 4U)
    {
      /* Can enter full 4 header words */
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
      /* If suspension flag has been raised, suspend processing
         only if not already at the end of the header */
      if (hcryp->SuspendRequest == HAL_CRYP_SUSPEND)
      {
        /* Clear CCF Flag */
        __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);

        /* reset SuspendRequest */
        hcryp->SuspendRequest = HAL_CRYP_SUSPEND_NONE;
        /* Disable Computation Complete Flag and Errors Interrupts */
        __HAL_CRYP_DISABLE_IT(hcryp, CRYP_IT_CCFIE | CRYP_IT_RWEIE | CRYP_IT_KEIE);
        /* Change the CRYP state */
        hcryp->State = HAL_CRYP_STATE_SUSPENDED;
        /* Mark that the payload phase is suspended */
        hcryp->Phase = CRYP_PHASE_HEADER_SUSPENDED;
        __HAL_UNLOCK(hcryp);
      }
      else
#endif /* USE_HAL_CRYP_SUSPEND_RESUME */
      {
        /* Write the input block in the IN FIFO */
        ((SAES_TypeDef *)(hcryp->Instance))->DINR  = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++;
        ((SAES_TypeDef *)(hcryp->Instance))->DINR  = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++;
        ((SAES_TypeDef *)(hcryp->Instance))->DINR  = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++;
        ((SAES_TypeDef *)(hcryp->Instance))->DINR  = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++;
      }
    }
    else /* Write last header block (4 words), padded with zeros if needed */
    {
      for (loopcounter = 0U; (loopcounter < ((headersize_in_bytes / 4U) % 4U)); loopcounter++)
      {
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        hcryp->CrypHeaderCount++ ;
      }
      /* If the header size is a multiple of words */
      if ((headersize_in_bytes % 4U) == 0U)
      {
        /* Pad the data with zeros to have a complete block */
        while (loopcounter < 4U)
        {
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = 0x0U;
          loopcounter++;
          hcryp->CrypHeaderCount++;
        }
      }
      else
      {
        /* Enter last bytes, padded with zeros */
        tmp =  *(uint32_t *)(hcryp->Init.Header + hcryp->CrypHeaderCount);
        tmp &= mask[(SAES_CONV_DATATYPE(hcryp->Init.DataType) * 2U) + (headersize_in_bytes % 4U)];
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = tmp;
        loopcounter++;
        hcryp->CrypHeaderCount++;
        /* Pad the data with zeros to have a complete block */
        while (loopcounter < 4U)
        {
          ((SAES_TypeDef *)(hcryp->Instance))->DINR = 0x0U;
          loopcounter++;
          hcryp->CrypHeaderCount++;
        }
      }
    }
  } /* if (IS_SAES_INSTANCE(hcryp->Instance)) */
#endif /* USE_HAL_SAES_ONLY */
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
static HAL_StatusTypeDef CRYP_WaitOnIFEMFlag(const CRYP_HandleTypeDef *hcryp, uint32_t Timeout)
{
  uint32_t tickstart;

  /* Get timeout */
  tickstart = HAL_GetTick();

  while (HAL_IS_BIT_CLR(((CRYP_TypeDef *)(hcryp->Instance))->SR, CRYP_FLAG_IFEM))
  {
    /* Check for the Timeout */
    if (Timeout != HAL_MAX_DELAY)
    {
      if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
      {
        return HAL_ERROR;
      }
    }
  }
  return HAL_OK;
}
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
static HAL_StatusTypeDef CRYP_WaitOnBUSYFlag(const CRYP_HandleTypeDef *hcryp, uint32_t Timeout)
{
  uint32_t tickstart;
  uint32_t flag_busy = 0U;

  /* Get timeout */
  tickstart = HAL_GetTick();

#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  if (IS_CRYP_INSTANCE(hcryp->Instance))
  {
    flag_busy = CRYP_FLAG_BUSY;
  }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
  if (IS_SAES_INSTANCE(hcryp->Instance))
  {
    flag_busy = SAES_FLAG_BUSY;
  }
#endif /* USE_HAL_SAES_ONLY */
  while (HAL_IS_BIT_SET(((CRYP_TypeDef *)(hcryp->Instance))->SR, flag_busy))
  {
    /* Check for the Timeout */
    if (Timeout != HAL_MAX_DELAY)
    {
      if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
      {
        return HAL_ERROR;
      }
    }
  }
  return HAL_OK;
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
static HAL_StatusTypeDef CRYP_WaitOnOFNEFlag(const CRYP_HandleTypeDef  *hcryp, uint32_t Timeout)
{
  uint32_t tickstart;

  /* Get timeout */
  tickstart = HAL_GetTick();

  while (HAL_IS_BIT_CLR(((CRYP_TypeDef *)(hcryp->Instance))->SR, CRYP_FLAG_OFNE))
  {
    /* Check for the Timeout */
    if (Timeout != HAL_MAX_DELAY)
    {
      if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
      {
        return HAL_ERROR;
      }
    }
  }
  return HAL_OK;
}
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
static HAL_StatusTypeDef CRYP_WaitOnCCFlag(const CRYP_HandleTypeDef *hcryp, uint32_t Timeout)
{
  uint32_t tickstart;

  /* Get timeout */
  tickstart = HAL_GetTick();

  while (HAL_IS_BIT_CLR(((SAES_TypeDef *)(hcryp->Instance))->SR, SAES_SR_CCF))
  {
    /* Check for the Timeout */
    if (Timeout != HAL_MAX_DELAY)
    {
      if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
      {
        return HAL_ERROR;
      }
    }
  }
  return HAL_OK;
}
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
static void CRYP_Read_IVRegisters(CRYP_HandleTypeDef *hcryp, uint32_t *Output)
{
  uint32_t outputaddr = (uint32_t)Output;

#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  if (IS_CRYP_INSTANCE(hcryp->Instance))
  {
    *(uint32_t *)(outputaddr) = ((CRYP_TypeDef *)(hcryp->Instance))->IV0LR;
    outputaddr += 4U;
    *(uint32_t *)(outputaddr) = ((CRYP_TypeDef *)(hcryp->Instance))->IV0RR;
    outputaddr += 4U;
    *(uint32_t *)(outputaddr) = ((CRYP_TypeDef *)(hcryp->Instance))->IV1LR;
    outputaddr += 4U;
    *(uint32_t *)(outputaddr) = ((CRYP_TypeDef *)(hcryp->Instance))->IV1RR;
  }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
  if (IS_SAES_INSTANCE(hcryp->Instance))
  {
    *(uint32_t *)(outputaddr) = ((SAES_TypeDef *)(hcryp->Instance))->IVR3;
    outputaddr += 4U;
    *(uint32_t *)(outputaddr) = ((SAES_TypeDef *)(hcryp->Instance))->IVR2;
    outputaddr += 4U;
    *(uint32_t *)(outputaddr) = ((SAES_TypeDef *)(hcryp->Instance))->IVR1;
    outputaddr += 4U;
    *(uint32_t *)(outputaddr) = ((SAES_TypeDef *)(hcryp->Instance))->IVR0;
  }
#endif /* USE_HAL_SAES_ONLY */
}
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
static void CRYP_Write_IVRegisters(CRYP_HandleTypeDef *hcryp, uint32_t *Input)
{
  uint32_t ivaddr = (uint32_t)Input;
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
  if (IS_CRYP_INSTANCE(hcryp->Instance))
  {
    ((CRYP_TypeDef *)(hcryp->Instance))->IV0LR = *(uint32_t *)(ivaddr);
    ivaddr += 4U;
    ((CRYP_TypeDef *)(hcryp->Instance))->IV0RR = *(uint32_t *)(ivaddr);
    ivaddr += 4U;
    ((CRYP_TypeDef *)(hcryp->Instance))->IV1LR = *(uint32_t *)(ivaddr);
    ivaddr += 4U;
    ((CRYP_TypeDef *)(hcryp->Instance))->IV1RR = *(uint32_t *)(ivaddr);
  }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
  if (IS_SAES_INSTANCE(hcryp->Instance))
  {
    ((SAES_TypeDef *)(hcryp->Instance))->IVR3 = *(uint32_t *)(ivaddr);
    ivaddr += 4U;
    ((SAES_TypeDef *)(hcryp->Instance))->IVR2 = *(uint32_t *)(ivaddr);
    ivaddr += 4U;
    ((SAES_TypeDef *)(hcryp->Instance))->IVR1 = *(uint32_t *)(ivaddr);
    ivaddr += 4U;
    ((SAES_TypeDef *)(hcryp->Instance))->IVR0 = *(uint32_t *)(ivaddr);
  }
#endif /* USE_HAL_SAES_ONLY */
}
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
static void CRYP_Read_ContextSwapRegisters(CRYP_HandleTypeDef *hcryp, uint32_t *Output, uint32_t Algorithm)
{
  uint32_t outputaddr = (uint32_t)Output;
  uint32_t inputaddr = (uint32_t)(&((CRYP_TypeDef *)(hcryp->Instance))->CSGCMCCM0R);
  uint32_t i;

  for (i = 0; i < 8U; i++)
  {
    *(uint32_t *)(outputaddr) = *(uint32_t *)(inputaddr);
    outputaddr += 4U;
    inputaddr  += 4U;
  }
  if (Algorithm == CRYP_AES_GCM)
  {
    for (i = 0; i < 8U; i++)
    {
      *(uint32_t *)(outputaddr) = *(uint32_t *)(inputaddr);
      outputaddr += 4U;
      inputaddr  += 4U;
    }
  }
}
#endif
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
static void CRYP_Write_ContextSwapRegisters(CRYP_HandleTypeDef *hcryp, uint32_t *Input, uint32_t Algorithm)
{
  uint32_t inputaddr = (uint32_t)Input;
  uint32_t outputaddr = (uint32_t)(&((CRYP_TypeDef *)(hcryp->Instance))->CSGCMCCM0R);
  uint32_t i;

  for (i = 0; i < 8U; i++)
  {
    *(uint32_t *)(outputaddr) = *(uint32_t *)(inputaddr);
    outputaddr += 4U;
    inputaddr  += 4U;
  }
  if (Algorithm == CRYP_AES_GCM)
  {
    for (i = 0; i < 8U; i++)
    {
      *(uint32_t *)(outputaddr) = *(uint32_t *)(inputaddr);
      outputaddr += 4U;
      inputaddr  += 4U;
    }
  }
}
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if (USE_HAL_CRYP_SUSPEND_RESUME == 1U)
static void CRYP_PhaseProcessingResume(CRYP_HandleTypeDef *hcryp)
{
  /* Case of header phase resumption =================================================*/
  if (hcryp->Phase == CRYP_PHASE_HEADER_SUSPENDED)
  {
    /* Set the phase */
    hcryp->Phase = CRYP_PHASE_PROCESS;

    /* Select header phase */
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      CRYP_SET_PHASE(hcryp, CRYP_PHASE_HEADER);
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      SAES_SET_PHASE(hcryp, SAES_PHASE_HEADER);
    }
#endif /* USE_HAL_SAES_ONLY */

    /* Enable interrupts */
    __HAL_CRYP_ENABLE_IT(hcryp, CRYP_IT_INI);

    /* Enable CRYP */
    __HAL_CRYP_ENABLE(hcryp);

  }
  /* Case of payload phase resumption =================================================*/
  else
  {
    /* Set the phase */
    hcryp->Phase = CRYP_PHASE_PROCESS;

    /* Select payload phase once the header phase is performed */
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      CRYP_SET_PHASE(hcryp, CRYP_PHASE_PAYLOAD);
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      SAES_SET_PHASE(hcryp, SAES_PHASE_PAYLOAD);
    }
#endif /* USE_HAL_SAES_ONLY */

    /* Enable Interrupts */
    __HAL_CRYP_ENABLE_IT(hcryp, CRYP_IT_INI | CRYP_IT_OUTI);

    /* Enable the CRYP peripheral */
    __HAL_CRYP_ENABLE(hcryp);

  }
}
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
static uint32_t CRYP_SAES_AlgoConversion(uint32_t algo, uint32_t order)
{
  uint32_t new_algo = 0x0;

  if (order == 0U) /* from algomode CRYP to chmod SAES */
  {
    switch (algo)
    {
      case CRYP_AES_ECB :
        new_algo = SAES_CR_CHMOD_AES_ECB;
        break;
      case CRYP_AES_CBC :
        new_algo = SAES_CR_CHMOD_AES_CBC;
        break;
      case CRYP_AES_CTR :
        new_algo = SAES_CR_CHMOD_AES_CTR;
        break;
      case CRYP_AES_GCM :
        new_algo = SAES_CR_CHMOD_AES_GCM;
        break;
      case CRYP_AES_CCM :
        new_algo = SAES_CR_CHMOD_AES_CCM;
        break;
      default :
        break;
    }

  }
  else /* order == 1 , from chmod SAES to algomode CRYP */
  {
    switch (algo)
    {
      case SAES_CR_CHMOD_AES_ECB :
        new_algo = CRYP_AES_ECB;
        break;
      case SAES_CR_CHMOD_AES_CBC :
        new_algo = CRYP_AES_CBC;
        break;
      case SAES_CR_CHMOD_AES_CTR :
        new_algo = CRYP_AES_CTR;
        break;
      case SAES_CR_CHMOD_AES_GCM :
        new_algo = CRYP_AES_GCM;
        break;
      case SAES_CR_CHMOD_AES_CCM :
        new_algo = CRYP_AES_CCM;
        break;
      default :
        break;
    }
  }

  return new_algo;
}
#endif
#endif
#endif
