// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CRYP/SAES and CRYPEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
HAL_StatusTypeDef HAL_CRYPEx_AESGCM_GenerateAuthTAG(CRYP_HandleTypeDef *hcryp, const uint32_t *pAuthTag,
                                                    uint32_t Timeout)
{
  uint32_t tickstart;
  uint64_t headerlength;
  uint64_t inputlength = (uint64_t)hcryp->SizesSum * 8U; /* input length in bits */
  uint32_t tagaddr = (uint32_t)pAuthTag;
  uint8_t i;


  if (hcryp->Init.HeaderWidthUnit == CRYP_HEADERWIDTHUNIT_WORD)
  {
    headerlength = (uint64_t)(hcryp->Init.HeaderSize) * 32U; /* Header length in bits */
  }
  else
  {
    headerlength = (uint64_t)(hcryp->Init.HeaderSize) * 8U;  /* Header length in bits */
  }


  if (hcryp->State == HAL_CRYP_STATE_READY)
  {
    /* Process locked */
    __HAL_LOCK(hcryp);

    /* Change the CRYP peripheral state */
    hcryp->State = HAL_CRYP_STATE_BUSY;

    /* Check if initialization phase has already been performed */
    if (hcryp->Phase == CRYPEx_PHASE_PROCESS)
    {
      /* Change the CRYP phase */
      hcryp->Phase = CRYPEx_PHASE_FINAL;
    }
    else /* Initialization phase has not been performed*/
    {
      /* Disable the Peripheral */
      __HAL_CRYP_DISABLE(hcryp);

      /* Sequence error code field */
      hcryp->ErrorCode |= HAL_CRYP_ERROR_AUTH_TAG_SEQUENCE;

      /* Change the CRYP peripheral state */
      hcryp->State = HAL_CRYP_STATE_READY;

      /* Process unlocked */
      __HAL_UNLOCK(hcryp);
      return HAL_ERROR;
    }

    /* Select final phase */
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      /* Disable CRYP to start the final phase */
      __HAL_CRYP_DISABLE(hcryp);

      /* ALGODIR bit must be set to '0'. */
      MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_GCM_CCMPH, CRYP_PHASE_FINAL);
      ((CRYP_TypeDef *)(hcryp->Instance))->CR &= ~CRYP_CR_ALGODIR;

      /* Enable the CRYP peripheral */
      __HAL_CRYP_ENABLE(hcryp);

      /* Write the number of bits in header (64 bits) followed by the number of bits
      in the payload */
      ((CRYP_TypeDef *)(hcryp->Instance))->DIN = 0U;
      ((CRYP_TypeDef *)(hcryp->Instance))->DIN = (uint32_t)(headerlength);
      ((CRYP_TypeDef *)(hcryp->Instance))->DIN = 0U;
      ((CRYP_TypeDef *)(hcryp->Instance))->DIN = (uint32_t)(inputlength);

      /* Wait for OFNE flag to be raised */
      tickstart = HAL_GetTick();
      while (HAL_IS_BIT_CLR(((CRYP_TypeDef *)(hcryp->Instance))->SR, CRYP_FLAG_OFNE))
      {
        /* Check for the Timeout */
        if (Timeout != HAL_MAX_DELAY)
        {
          if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
          {
            /* Disable the CRYP Peripheral Clock */
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
      /* Read the authentication TAG in the output FIFO */
      for (i = 0U; i < 4U; i++)
      {
        *(uint32_t *)(tagaddr) = ((CRYP_TypeDef *)(hcryp->Instance))->DOUT;
        tagaddr += 4U;
      }
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      /* Select final phase */
      MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_GCMPH, SAES_PHASE_FINAL);

      /* Write the number of bits in header (64 bits) followed by the number of bits
      in the payload */
      ((SAES_TypeDef *)(hcryp->Instance))->DINR = 0U;
      ((SAES_TypeDef *)(hcryp->Instance))->DINR = (uint32_t)(headerlength);
      ((SAES_TypeDef *)(hcryp->Instance))->DINR = 0U;
      ((SAES_TypeDef *)(hcryp->Instance))->DINR = (uint32_t)(inputlength);

      /* Wait for CCF flag to be raised */
      tickstart = HAL_GetTick();
      while (HAL_IS_BIT_CLR(((SAES_TypeDef *)(hcryp->Instance))->SR, SAES_SR_CCF))
      {
        /* Check for the Timeout */
        if (Timeout != HAL_MAX_DELAY)
        {
          if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
          {
            /* Disable the CRYP peripheral Clock */
            __HAL_CRYP_DISABLE(hcryp);

            /* Change state */
            hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
            hcryp->State = HAL_CRYP_STATE_READY;
            __HAL_UNLOCK(hcryp);
            return HAL_ERROR;
          }
        }
      }

      /* Read the authentication TAG in the output FIFO */
      for (i = 0U; i < 4U; i++)
      {
        *(uint32_t *)(tagaddr) = ((SAES_TypeDef *)(hcryp->Instance))->DOUTR;
        tagaddr += 4U;
      }

      /* Clear CCF Flag */
      __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);
    }
#endif /* USE_HAL_SAES_ONLY */

    /* Disable the peripheral */
    __HAL_CRYP_DISABLE(hcryp);

    /* Change the CRYP peripheral state */
    hcryp->State = HAL_CRYP_STATE_READY;

    /* Process unlocked */
    __HAL_UNLOCK(hcryp);
  }
  else
  {
    /* Busy error code field */
    hcryp->ErrorCode |= HAL_CRYP_ERROR_BUSY;
    return HAL_ERROR;
  }
  /* Return function status */
  return HAL_OK;
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
HAL_StatusTypeDef HAL_CRYPEx_AESCCM_GenerateAuthTAG(CRYP_HandleTypeDef *hcryp, const uint32_t *pAuthTag,
                                                    uint32_t Timeout)
{
  uint32_t tagaddr = (uint32_t)pAuthTag;
  uint32_t ctr0 [4] = {0};
  uint32_t ctr0addr = (uint32_t)ctr0;
  uint32_t tickstart;
  uint8_t i;

  if (hcryp->State == HAL_CRYP_STATE_READY)
  {
    /* Process locked */
    __HAL_LOCK(hcryp);
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      /* Disable interrupts, we are now in polling mode to TAG generation */
      __HAL_CRYP_DISABLE_IT(hcryp, CRYP_IT_CCFIE | CRYP_IT_RWEIE | CRYP_IT_KEIE);
    }
#endif /* USE_HAL_SAES_ONLY */
    /* Change the CRYP peripheral state */
    hcryp->State = HAL_CRYP_STATE_BUSY;

    /* Check if initialization phase has already been performed */
    if (hcryp->Phase == CRYPEx_PHASE_PROCESS)
    {
      /* Change the CRYP phase */
      hcryp->Phase = CRYPEx_PHASE_FINAL;
    }
    else /* Initialization phase has not been performed*/
    {
      /* Disable the peripheral */
      __HAL_CRYP_DISABLE(hcryp);

      /* Sequence error code field */
      hcryp->ErrorCode |= HAL_CRYP_ERROR_AUTH_TAG_SEQUENCE;

      /* Change the CRYP peripheral state */
      hcryp->State = HAL_CRYP_STATE_READY;

      /* Process unlocked */
      __HAL_UNLOCK(hcryp);
      return HAL_ERROR;
    }

    /* Select final phase */
#if !defined(USE_HAL_CRYP_ONLY) || (USE_HAL_CRYP_ONLY == 1)
    if (IS_CRYP_INSTANCE(hcryp->Instance))
    {
      /* Disable CRYP to start the final phase */
      __HAL_CRYP_DISABLE(hcryp);

      /* ALGODIR bit must be set to '0' */
      MODIFY_REG(((CRYP_TypeDef *)(hcryp->Instance))->CR, CRYP_CR_GCM_CCMPH, CRYP_PHASE_FINAL);
      ((CRYP_TypeDef *)(hcryp->Instance))->CR &= ~CRYP_CR_ALGODIR;

      /* Write the counter block in the IN FIFO, CTR0 information from B0
      data has to be swapped according to the DATATYPE*/
      ctr0[0] = hcryp->Init.B0[0] & CRYP_CCM_CTR0_0;
      ctr0[1] = hcryp->Init.B0[1];
      ctr0[2] = hcryp->Init.B0[2];
      ctr0[3] = hcryp->Init.B0[3] & CRYP_CCM_CTR0_3;

      for (i = 0U; i < 4U; i++)
      {
        ((CRYP_TypeDef *)(hcryp->Instance))->DIN = *(uint32_t *)(ctr0addr);
        ctr0addr += 4U;
      }
      /* Enable the CRYP peripheral */
      __HAL_CRYP_ENABLE(hcryp);

      /* Wait for OFNE flag to be raised */
      tickstart = HAL_GetTick();
      while (HAL_IS_BIT_CLR(((CRYP_TypeDef *)((hcryp->Instance)))->SR, CRYP_FLAG_OFNE))
      {
        /* Check for the Timeout */
        if (Timeout != HAL_MAX_DELAY)
        {
          if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
          {
            /* Disable the CRYP peripheral Clock */
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
      /* Read the authentication TAG in the output FIFO */
      for (i = 0U; i < 4U; i++)
      {
        *(uint32_t *)(tagaddr) = ((CRYP_TypeDef *)(hcryp->Instance))->DOUT;
        tagaddr += 4U;
      }
    }
#endif /* USE_HAL_CRYP_ONLY */
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
    if (IS_SAES_INSTANCE(hcryp->Instance))
    {
      /* Change SAES final phase */
      MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_GCMPH, SAES_PHASE_FINAL);

      for (i = 0U; i < 4U; i++)
      {
        ((SAES_TypeDef *)(hcryp->Instance))->DINR = *(uint32_t *)(ctr0addr);
        ctr0addr += 4U;
      }

      /* Wait for CCF flag to be raised */
      tickstart = HAL_GetTick();
      while (HAL_IS_BIT_CLR(((SAES_TypeDef *)(hcryp->Instance))->SR, CRYP_FLAG_CCF))
      {
        /* Check for the Timeout */
        if (Timeout != HAL_MAX_DELAY)
        {
          if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
          {
            /* Disable the CRYP peripheral Clock */
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
      /* Read the authentication TAG in the output FIFO */
      for (i = 0U; i < 4U; i++)
      {
        *(uint32_t *)(tagaddr) = ((SAES_TypeDef *)(hcryp->Instance))->DOUTR;
        tagaddr += 4U;
      }
      /* Clear CCF flag */
      __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);
    }
#endif /* USE_HAL_SAES_ONLY */

    /* Change the CRYP peripheral state */
    hcryp->State = HAL_CRYP_STATE_READY;

    /* Process unlocked */
    __HAL_UNLOCK(hcryp);

    /* Disable CRYP  */
    __HAL_CRYP_DISABLE(hcryp);
  }
  else
  {
    /* Busy error code field */
    hcryp->ErrorCode = HAL_CRYP_ERROR_BUSY;
    return HAL_ERROR;
  }
  /* Return function status */
  return HAL_OK;
}
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
HAL_StatusTypeDef HAL_CRYPEx_WrapKey(CRYP_HandleTypeDef *hcryp, uint32_t *Input, uint32_t *Output, uint32_t Timeout)
{
  HAL_StatusTypeDef status;

  if (hcryp->State == HAL_CRYP_STATE_READY)
  {
    /* Change state Busy */
    hcryp->State = HAL_CRYP_STATE_BUSY;

    /* Process locked */
    __HAL_LOCK(hcryp);

    /*  Reset CrypInCount, CrypOutCount and Initialize pCrypInBuffPtr and pCrypOutBuffPtr parameters*/
    hcryp->CrypInCount = 0U;
    hcryp->CrypOutCount = 0U;
    hcryp->pCrypInBuffPtr = Input;
    hcryp->pCrypOutBuffPtr = Output;

    /* Disable the CRYP peripheral clock */
    __HAL_CRYP_DISABLE(hcryp);

    /* Set the operating mode*/
    MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_KMOD, CRYP_KEYMODE_WRAPPED);

    status = CRYPEx_KeyEncrypt(hcryp, Timeout);

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
    /* Busy error code field */
    hcryp->ErrorCode |= HAL_CRYP_ERROR_BUSY;
    status = HAL_ERROR;
  }
  /* Return function status */
  return status;
}
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
HAL_StatusTypeDef HAL_CRYPEx_UnwrapKey(CRYP_HandleTypeDef *hcryp, uint32_t *Input, uint32_t Timeout)
{
  HAL_StatusTypeDef status;

  if (hcryp->State == HAL_CRYP_STATE_READY)
  {
    /* Change state Busy */
    hcryp->State = HAL_CRYP_STATE_BUSY;

    /* Process locked */
    __HAL_LOCK(hcryp);

    /*  Reset CrypInCount, CrypOutCount and Initialize pCrypInBuffPtr and pCrypOutBuffPtr parameters*/
    hcryp->CrypInCount = 0U;
    hcryp->CrypOutCount = 0U;
    hcryp->pCrypInBuffPtr = Input;

    /* Disable the CRYP peripheral clock */
    __HAL_CRYP_DISABLE(hcryp);

    /* Set the operating mode*/
    MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_KMOD, CRYP_KEYMODE_WRAPPED);

    status = CRYPEx_KeyDecrypt(hcryp, Timeout);

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
    /* Busy error code field */
    hcryp->ErrorCode |= HAL_CRYP_ERROR_BUSY;
    status = HAL_ERROR;
  }
  /* Return function status */
  return status;
}
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
HAL_StatusTypeDef HAL_CRYPEx_EncryptSharedKey(CRYP_HandleTypeDef *hcryp, uint32_t *Key, uint32_t *Output, uint32_t ID,
                                              uint32_t Timeout)
{
  HAL_StatusTypeDef status;

  if (hcryp->State == HAL_CRYP_STATE_READY)
  {
    /* Change state Busy */
    hcryp->State = HAL_CRYP_STATE_BUSY;

    /* Process locked */
    __HAL_LOCK(hcryp);

    /* Reset CrypInCount, CrypOutCount and Initialize pCrypInBuffPtr and pCrypOutBuffPtr parameters*/
    hcryp->CrypInCount = 0U;
    hcryp->CrypOutCount = 0U;
    hcryp->pCrypInBuffPtr = Key;
    hcryp->pCrypOutBuffPtr = Output;

    /* Disable the CRYP peripheral clock */
    __HAL_CRYP_DISABLE(hcryp);

    /* Set the operating mode*/
    MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_KMOD | SAES_CR_KSHAREID, CRYP_KEYMODE_SHARED | ID);

    status = CRYPEx_KeyEncrypt(hcryp, Timeout);

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
    /* Busy error code field */
    hcryp->ErrorCode |= HAL_CRYP_ERROR_BUSY;
    status = HAL_ERROR;
  }
  /* Return function status */
  return status;
}
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
HAL_StatusTypeDef HAL_CRYPEx_DecryptSharedKey(CRYP_HandleTypeDef *hcryp, uint32_t *Key, uint32_t ID, uint32_t Timeout)
{
  HAL_StatusTypeDef status;

  if (hcryp->State == HAL_CRYP_STATE_READY)
  {
    /* Change state Busy */
    hcryp->State = HAL_CRYP_STATE_BUSY;

    /* Process locked */
    __HAL_LOCK(hcryp);

    /*  Reset CrypInCount, CrypOutCount and Initialize pCrypInBuffPtr and pCrypOutBuffPtr parameters*/
    hcryp->CrypInCount = 0U;
    hcryp->CrypOutCount = 0U;
    hcryp->pCrypInBuffPtr = Key;

    /* Disable the CRYP peripheral clock */
    __HAL_CRYP_DISABLE(hcryp);

    /* Set the operating mode*/
    MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_KMOD | SAES_CR_KSHAREID, CRYP_KEYMODE_SHARED | ID);

    status = CRYPEx_KeyDecrypt(hcryp, Timeout);

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
    /* Busy error code field */
    hcryp->ErrorCode |= HAL_CRYP_ERROR_BUSY;
    status = HAL_ERROR;
  }
  /* Return function status */
  return status;
}
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
static HAL_StatusTypeDef CRYPEx_KeyDecrypt(CRYP_HandleTypeDef *hcryp, uint32_t Timeout)
{
  uint32_t incount;  /* Temporary CrypInCount Value */
  uint32_t tickstart;

  /* key preparation for decryption, operating mode 2*/
  MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_MODE, CRYP_MODE_KEY_DERIVATION);

  /*It is strongly recommended to select hardware secret keys*/
  if (hcryp->Init.KeySelect == CRYP_KEYSEL_NORMAL)
  {
    /*  Set the Key*/
    CRYPEx_SetKey(hcryp, hcryp->Init.KeySize);
  }
  /* Enable CRYP */
  __HAL_CRYP_ENABLE(hcryp);

  /* Wait for CCF flag to be raised */
  tickstart = HAL_GetTick();
  while (HAL_IS_BIT_CLR(((SAES_TypeDef *)(hcryp->Instance))->SR, SAES_SR_CCF))
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
  /* Clear CCF Flag */
  __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);

  /*  End of Key preparation for ECB/CBC */
  /* Return to decryption operating mode(Mode 3)*/
  MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_MODE, CRYP_MODE_DECRYPT);


  if (hcryp->Init.Algorithm != CRYP_AES_ECB)
  {
    /* Set the Initialization Vector*/
    ((SAES_TypeDef *)(hcryp->Instance))->IVR3 = *(uint32_t *)(hcryp->Init.pInitVect);
    ((SAES_TypeDef *)(hcryp->Instance))->IVR2 = *(uint32_t *)(hcryp->Init.pInitVect + 1U);
    ((SAES_TypeDef *)(hcryp->Instance))->IVR1 = *(uint32_t *)(hcryp->Init.pInitVect + 2U);
    ((SAES_TypeDef *)(hcryp->Instance))->IVR0 = *(uint32_t *)(hcryp->Init.pInitVect + 3U);
  }
  /* Enable CRYP */
  __HAL_CRYP_ENABLE(hcryp);

  /* Set the phase */
  hcryp->Phase = CRYPEx_PHASE_PROCESS;

  if (hcryp->Init.KeySize == CRYP_KEYSIZE_128B)
  {
    incount = 4;
  }
  else
  {
    incount = 8;
  }
  while (hcryp->CrypInCount < incount)
  {
    /* Write four times to input the key to encrypt */
    ((SAES_TypeDef *)(hcryp->Instance))->DINR  = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
    hcryp->CrypInCount++;
    ((SAES_TypeDef *)(hcryp->Instance))->DINR  = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
    hcryp->CrypInCount++;
    ((SAES_TypeDef *)(hcryp->Instance))->DINR  = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
    hcryp->CrypInCount++;
    ((SAES_TypeDef *)(hcryp->Instance))->DINR  = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
    hcryp->CrypInCount++;

    /* Wait for CCF flag to be raised */
    tickstart = HAL_GetTick();
    while (HAL_IS_BIT_CLR(((SAES_TypeDef *)(hcryp->Instance))->SR, SAES_SR_CCF))
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

    /* Clear CCF Flag */
    __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);
  }

  /* Disable the CRYP peripheral clock */
  __HAL_CRYP_DISABLE(hcryp);

  return HAL_OK;
}
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
static HAL_StatusTypeDef CRYPEx_KeyEncrypt(CRYP_HandleTypeDef *hcryp, uint32_t Timeout)
{
  uint32_t incount;  /* Temporary CrypInCount Value */
  uint32_t tickstart;
  uint32_t temp;  /* Temporary CrypOutBuff */

  MODIFY_REG(((SAES_TypeDef *)(hcryp->Instance))->CR, SAES_CR_MODE, CRYP_OPERATINGMODE_ENCRYPT);

  if (hcryp->Init.Algorithm != CRYP_AES_ECB)
  {
    /* Set the Initialization Vector*/
    ((SAES_TypeDef *)(hcryp->Instance))->IVR3 = *(uint32_t *)(hcryp->Init.pInitVect);
    ((SAES_TypeDef *)(hcryp->Instance))->IVR2 = *(uint32_t *)(hcryp->Init.pInitVect + 1U);
    ((SAES_TypeDef *)(hcryp->Instance))->IVR1 = *(uint32_t *)(hcryp->Init.pInitVect + 2U);
    ((SAES_TypeDef *)(hcryp->Instance))->IVR0 = *(uint32_t *)(hcryp->Init.pInitVect + 3U);
  }
  /*It is strongly recommended to select hardware secret keys*/
  if (hcryp->Init.KeySelect == CRYP_KEYSEL_NORMAL)
  {
    /*  Set the Key*/
    CRYPEx_SetKey(hcryp, hcryp->Init.KeySize);
  }
  /* Get tick */
  tickstart = HAL_GetTick();

  /* Wait for Valid KEY flag to set  */
  while (HAL_IS_BIT_CLR(((SAES_TypeDef *)(hcryp->Instance))->SR, SAES_SR_KEYVALID))
  {
    /* Check for the Timeout */
    if (Timeout != HAL_MAX_DELAY)
    {
      if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
      {
        /* Change state */
        hcryp->ErrorCode |= HAL_CRYP_ERROR_TIMEOUT;
        hcryp->State = HAL_CRYP_STATE_READY;
        /* Process unlocked */
        return HAL_ERROR;
      }
    }
  }

  /* Enable CRYP */
  __HAL_CRYP_ENABLE(hcryp);

  /* Set the phase */
  hcryp->Phase = CRYPEx_PHASE_PROCESS;

  if (hcryp->Init.KeySize == CRYP_KEYSIZE_128B)
  {
    incount = 4;
  }
  else
  {
    incount = 8;
  }
  while (hcryp->CrypInCount < incount)
  {
    /* Write four times to input the key to encrypt */
    ((SAES_TypeDef *)(hcryp->Instance))->DINR  = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
    hcryp->CrypInCount++;
    ((SAES_TypeDef *)(hcryp->Instance))->DINR  = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
    hcryp->CrypInCount++;
    ((SAES_TypeDef *)(hcryp->Instance))->DINR  = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
    hcryp->CrypInCount++;
    ((SAES_TypeDef *)(hcryp->Instance))->DINR  = *(uint32_t *)(hcryp->pCrypInBuffPtr + hcryp->CrypInCount);
    hcryp->CrypInCount++;

    /* Wait for CCF flag to be raised */
    tickstart = HAL_GetTick();
    while (HAL_IS_BIT_CLR(((SAES_TypeDef *)(hcryp->Instance))->SR, SAES_SR_CCF))
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

    /* Clear CCF Flag */
    __HAL_CRYP_CLEAR_FLAG(hcryp, CRYP_CLEAR_CCF);

    /* Read the output block from the output FIFO and put them in temporary buffer then
       get CrypOutBuff from temporary buffer*/
    temp  = ((SAES_TypeDef *)(hcryp->Instance))->DOUTR;
    *(uint32_t *)(hcryp->pCrypOutBuffPtr + (hcryp->CrypOutCount)) = temp;
    hcryp->CrypOutCount++;
    temp  = ((SAES_TypeDef *)(hcryp->Instance))->DOUTR;
    *(uint32_t *)(hcryp->pCrypOutBuffPtr + hcryp->CrypOutCount)   = temp;
    hcryp->CrypOutCount++;
    temp  = ((SAES_TypeDef *)(hcryp->Instance))->DOUTR;
    *(uint32_t *)(hcryp->pCrypOutBuffPtr + (hcryp->CrypOutCount)) = temp;
    hcryp->CrypOutCount++;
    temp  = ((SAES_TypeDef *)(hcryp->Instance))->DOUTR;
    *(uint32_t *)(hcryp->pCrypOutBuffPtr + hcryp->CrypOutCount)   = temp;
    hcryp->CrypOutCount++;
  }

  /* Disable the CRYP peripheral clock */
  __HAL_CRYP_DISABLE(hcryp);

  return HAL_OK;
}
#endif
#endif
#endif

#if defined (CRYP)
#ifdef HAL_CRYP_MODULE_ENABLED
#if !defined(USE_HAL_SAES_ONLY) || (USE_HAL_SAES_ONLY == 1)
static void CRYPEx_SetKey(CRYP_HandleTypeDef *hcryp, uint32_t KeySize)
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
  }
}
#endif
#endif
#endif
