/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted unchanged from STM32H7RS HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
HAL_StatusTypeDef HAL_FLASHEx_Erase(const FLASH_EraseInitTypeDef *pEraseInit, uint32_t *SectorError)
{
  HAL_StatusTypeDef status;
  uint32_t sector_index;

  /* Check the parameters */
  assert_param(IS_FLASH_TYPEERASE(pEraseInit->TypeErase));

  /* Process Locked */
  __HAL_LOCK(&pFlash);

  /* Reset error code */
  pFlash.ErrorCode = HAL_FLASH_ERROR_NONE;

  /* Wait for last operation to be completed */
  status = FLASH_WaitForLastOperation(FLASH_TIMEOUT_VALUE);

  if (status == HAL_OK)
  {
    if (pEraseInit->TypeErase == FLASH_TYPEERASE_MASSERASE)
    {
      /* Mass erase to be done */
      FLASH_MassErase();

      /* Wait for last operation to be completed */
      status = FLASH_WaitForLastOperation(FLASH_TIMEOUT_VALUE);
    }
    else
    {
      /*Initialization of SectorError variable*/
      *SectorError = 0xFFFFFFFFU;

      for (sector_index = pEraseInit->Sector; sector_index < (pEraseInit->Sector + pEraseInit->NbSectors);
           sector_index++)
      {
        FLASH_SectorErase(sector_index);

        /* Wait for last operation to be completed */
        status = FLASH_WaitForLastOperation(FLASH_TIMEOUT_VALUE);

        if (status != HAL_OK)
        {
          /* In case of error, stop erase procedure and return the faulty sector */
          *SectorError = sector_index;
          break;
        }
      }
    }

    /* If the erase operation is completed, disable the associated bits */
    CLEAR_BIT(FLASH->CR, (pEraseInit->TypeErase | FLASH_CR_SSN));
  }

  /* Process Unlocked */
  __HAL_UNLOCK(&pFlash);

  return status;
}

HAL_StatusTypeDef HAL_FLASHEx_Erase_IT(const FLASH_EraseInitTypeDef *pEraseInit)
{
  HAL_StatusTypeDef status;

  /* Check the parameters */
  assert_param(IS_FLASH_TYPEERASE(pEraseInit->TypeErase));

  /* Process Locked */
  __HAL_LOCK(&pFlash);

  /* Reset error code */
  pFlash.ErrorCode = HAL_FLASH_ERROR_NONE;

  /* Wait for last operation to be completed */
  status = FLASH_WaitForLastOperation(FLASH_TIMEOUT_VALUE);

  if (status != HAL_OK)
  {
    /* Process Unlocked */
    __HAL_UNLOCK(&pFlash);
  }
  else
  {
    /* Set internal variables used by the IRQ handler */
    pFlash.ProcedureOnGoing = pEraseInit->TypeErase;

    /* Enable End of Operation and Error interrupts */
    SET_BIT(FLASH->IER, (FLASH_IT_EOP | FLASH_IT_WRPERR | FLASH_IT_PGSERR | FLASH_IT_STRBERR | FLASH_IT_INCERR));

    if (pEraseInit->TypeErase == FLASH_TYPEERASE_MASSERASE)
    {
      /* Mass erase to be done */
      FLASH_MassErase();
    }
    else
    {
      /* Erase by sector to be done */
      pFlash.NbSectorsToErase = pEraseInit->NbSectors;
      pFlash.Sector = pEraseInit->Sector;

      /* Erase first sector and wait for IT */
      FLASH_SectorErase(pEraseInit->Sector);
    }
  }

  return status;
}

HAL_StatusTypeDef HAL_FLASHEx_OBProgram(const FLASH_OBProgramInitTypeDef *pOBInit)
{
  HAL_StatusTypeDef status;

  /* Check the parameters */
  assert_param(IS_OPTIONBYTE(pOBInit->OptionType));

  /* Process Locked */
  __HAL_LOCK(&pFlash);

  /* Reset error code */
  pFlash.ErrorCode = HAL_FLASH_ERROR_NONE;

  /* Wait for last operation to be completed */
  status = FLASH_WaitForLastOperation(FLASH_TIMEOUT_VALUE);

  if ((status == HAL_OK) && (pOBInit->OptionType != 0U))
  {
    /* Set PG_OPT Bit */
    SET_BIT(FLASH->OPTCR, FLASH_OPTCR_PG_OPT);

    /* Write protection configuration */
    if ((pOBInit->OptionType & OPTIONBYTE_WRP) != 0U)
    {
      /* Configure of Write protection on the selected area */
      FLASH_OB_WRPConfig(pOBInit->WRPState, pOBInit->WRPSector);
    }

    /* User Configuration */
    if ((pOBInit->OptionType & OPTIONBYTE_USER) != 0U)
    {
      /* Configure the user option bytes */
      FLASH_OB_UserConfig(pOBInit->USERType, pOBInit->USERConfig1, pOBInit->USERConfig2);
    }

    /* HDP configuration */
    if ((pOBInit->OptionType & OPTIONBYTE_HDP) != 0U)
    {
      /* Configure the HDP Protection */
      FLASH_OB_HDPConfig(pOBInit->HDPStartPage, pOBInit->HDPEndPage);
    }

    /* Non-volatile state configuration */
    if ((pOBInit->OptionType & OPTIONBYTE_NV) != 0U)
    {
      /* Configure the non-volatile state */
      FLASH_OB_NVConfig(pOBInit->NVState);
    }

    /* Wait for last operation to be completed */
    status = FLASH_WaitForLastOperation(FLASH_TIMEOUT_VALUE);

    /* Clear PG_OPT Bit */
    CLEAR_BIT(FLASH->OPTCR, FLASH_OPTCR_PG_OPT);
  }

  /* Process Unlocked */
  __HAL_UNLOCK(&pFlash);

  return status;
}

void HAL_FLASHEx_OBGetConfig(FLASH_OBProgramInitTypeDef *pOBInit)
{
  /* Get write protection on the selected area */
  FLASH_OB_GetWRP(&(pOBInit->WRPState), &(pOBInit->WRPSector));

  /* Get the user option bytes */
  FLASH_OB_GetUser(&(pOBInit->USERConfig1), &(pOBInit->USERConfig2));

  /* Get the HDP Protection */
  FLASH_OB_GetHDP(&(pOBInit->HDPStartPage), &(pOBInit->HDPEndPage));

  /* Get the non-volatile state */
  pOBInit->NVState = FLASH_OB_GetNV();

  /* Get the Root-Of-Trust configuration */
  pOBInit->ROTConfig = FLASH_OB_GetRoT();

  /* Get the epoch */
  pOBInit->EPOCH = FLASH_OB_GetEpoch();
}

HAL_StatusTypeDef HAL_FLASHEx_OTPLockConfig(uint32_t OTPLBlock)
{
  HAL_StatusTypeDef status;

  /* Check the parameters */
  assert_param(IS_OB_OTP_BLOCK(OTPLBlock));

  /* Process Locked */
  __HAL_LOCK(&pFlash);

  /* Reset error code */
  pFlash.ErrorCode = HAL_FLASH_ERROR_NONE;

  /* Wait for last operation to be completed */
  status = FLASH_WaitForLastOperation(FLASH_TIMEOUT_VALUE);

  if (status == HAL_OK)
  {
    /* Set the bit for the OTP programmation */
    SET_BIT(FLASH->CR, FLASH_CR_PG_OTP);

    /* Set PG_OPT Bit */
    SET_BIT(FLASH->OPTCR, FLASH_OPTCR_PG_OPT);

    /* Configure the write protected area */
    MODIFY_REG(FLASH->OTPLSRP, FLASH_OTPLSRP_OTPL, (OTPLBlock & FLASH_OTPLSRP_OTPL));

    /* Wait for last operation to be completed */
    status = FLASH_WaitForLastOperation(FLASH_TIMEOUT_VALUE);

    /* Clear PG_OPT Bit */
    CLEAR_BIT(FLASH->OPTCR, FLASH_OPTCR_PG_OPT);

    /* Clear the bit for the OTP programmation */
    CLEAR_BIT(FLASH->CR, FLASH_CR_PG_OTP);
  }

  /* Process Unlocked */
  __HAL_UNLOCK(&pFlash);

  return status;
}

uint32_t HAL_FLASHEx_GetOTPLock(void)
{
  return (FLASH->OTPLSR & FLASH_OTPLSR_OTPL);
}

HAL_StatusTypeDef HAL_FLASHEx_KeyConfig(const FLASH_KeyConfigTypeDef *pKeyConfig, const uint32_t *pKey)
{
  uint32_t index;
  uint32_t index_max;
  const uint32_t *pdata;
  HAL_StatusTypeDef status;

  /* Check the parameters */
  assert_param(IS_KEY_INDEX(pKeyConfig->Index));
  assert_param(IS_KEY_SIZE(pKeyConfig->Size));
  assert_param(IS_KEY_HDPL_LEVEL(pKeyConfig->HDPLLevel));

  /* Process Locked */
  __HAL_LOCK(&pFlash);

  /* Reset error code */
  pFlash.ErrorCode = HAL_FLASH_ERROR_NONE;

  /* Wait for last operation to be completed */
  status = FLASH_WaitForLastOperation(FLASH_TIMEOUT_VALUE);

  if (status == HAL_OK)
  {
    /* Set PG_OPT Bit */
    SET_BIT(FLASH->OPTCR, FLASH_OPTCR_PG_OPT);

    switch (pKeyConfig->Size)
    {
      case FLASH_KEY_32_BITS :
        index_max = 1U;
        break;

      case FLASH_KEY_64_BITS :
        index_max = 2U;
        break;

      case FLASH_KEY_128_BITS :
        index_max = 4U;
        break;

      case FLASH_KEY_256_BITS :
        index_max = 8U;
        break;

      default:
        /* This case should not occur */
        index_max = 0U;
        break;
    }

    pdata = pKey;
    for (index = 0U; index < index_max; index++)
    {
      FLASH->OBKDR[index] = pdata[index];
    }

    MODIFY_REG(FLASH->OBKCR, (FLASH_OBKCR_OBKINDEX | FLASH_OBKCR_NEXTKL | FLASH_OBKCR_OBKSIZE),
               (pKeyConfig->Index | pKeyConfig->HDPLLevel | pKeyConfig->Size));

    SET_BIT(FLASH->OBKCR, (FLASH_OBKCR_KEYSTART | FLASH_OBKCR_KEYPROG));

    /* Wait for last operation to be completed */
    status = FLASH_WaitForLastOperation(FLASH_TIMEOUT_VALUE);

    CLEAR_BIT(FLASH->OBKCR, FLASH_OBKCR_KEYPROG);

    /* Clear PG_OPT Bit */
    CLEAR_BIT(FLASH->OPTCR, FLASH_OPTCR_PG_OPT);
  }

  /* Process Unlocked */
  __HAL_UNLOCK(&pFlash);

  return status;
}

HAL_StatusTypeDef HAL_FLASHEx_GetKey(const FLASH_KeyConfigTypeDef *pKeyConfig, uint32_t *pKey)
{
  uint32_t index;
  uint32_t index_max;
  uint32_t *pdata;
  HAL_StatusTypeDef status;

  /* Check the parameters */
  assert_param(IS_KEY_INDEX(pKeyConfig->Index));
  assert_param(IS_KEY_SIZE(pKeyConfig->Size));
  assert_param(IS_KEY_HDPL_LEVEL(pKeyConfig->HDPLLevel));

  /* Process Locked */
  __HAL_LOCK(&pFlash);

  /* Reset error code */
  pFlash.ErrorCode = HAL_FLASH_ERROR_NONE;

  /* Wait for last operation to be completed */
  status = FLASH_WaitForLastOperation(FLASH_TIMEOUT_VALUE);

  if (status == HAL_OK)
  {
    /* Set PG_OPT Bit */
    SET_BIT(FLASH->OPTCR, FLASH_OPTCR_PG_OPT);

    /* Configure index and HDPL level */
    MODIFY_REG(FLASH->OBKCR, (FLASH_OBKCR_OBKINDEX | FLASH_OBKCR_NEXTKL | FLASH_OBKCR_OBKSIZE | FLASH_OBKCR_KEYPROG),
               (pKeyConfig->Index | pKeyConfig->HDPLLevel | pKeyConfig->Size));

    /* Set the start bit to get the key value */
    SET_BIT(FLASH->OBKCR, FLASH_OBKCR_KEYSTART);

    /* Wait for last operation to be completed */
    status = FLASH_WaitForLastOperation(FLASH_TIMEOUT_VALUE);

    if ((status == HAL_OK) && (pKey != NULL))
    {
      switch (pKeyConfig->Size)
      {
        case FLASH_KEY_32_BITS :
          index_max = 1U;
          break;

        case FLASH_KEY_64_BITS :
          index_max = 2U;
          break;

        case FLASH_KEY_128_BITS :
          index_max = 4U;
          break;

        case FLASH_KEY_256_BITS :
          index_max = 8U;
          break;

        default:
          /* This case should not occur */
          index_max = 0U;
          break;
      }

      pdata = pKey;
      for (index = 0U; index < index_max; index++)
      {
        *pdata = FLASH->OBKDR[index];
        pdata++;
      }
    }

    /* Clear PG_OPT Bit */
    CLEAR_BIT(FLASH->OPTCR, FLASH_OPTCR_PG_OPT);
  }

  /* Process Unlocked */
  __HAL_UNLOCK(&pFlash);

  return status;
}

HAL_StatusTypeDef HAL_FLASHEx_ComputeCRC(const FLASH_CRCInitTypeDef *pCRCInit, uint32_t *CRC_Result)
{
  HAL_StatusTypeDef status;
  uint32_t sector_index;

  /* Check the parameters */
  assert_param(IS_FLASH_TYPE_CRC(pCRCInit->TypeCRC));
  assert_param(IS_FLASH_BURST_SIZE_CRC(pCRCInit->BurstSize));

  /* Wait for last operation to be completed */
  status = FLASH_WaitForLastOperation(FLASH_TIMEOUT_VALUE);

  if (status == HAL_OK)
  {
    /* Process Locked */
    __HAL_LOCK(&pFlash);

    /* Reset error code */
    pFlash.ErrorCode = HAL_FLASH_ERROR_NONE;

    /* Enable CRC feature */
    SET_BIT(FLASH->CR, FLASH_CR_CRC_EN);

    /* Clear CRC flags in Status Register: CRC end of calculation and CRC read error */
    FLASH->ICR = (FLASH_ICR_CRCRDERRF | FLASH_ICR_CRCENDF);

    /* Clear current CRC result and program burst size */
    MODIFY_REG(FLASH->CRCCR, (FLASH_CRCCR_CLEAN_CRC | FLASH_CRCCR_CRC_BURST),
               (FLASH_CRCCR_CLEAN_CRC | pCRCInit->BurstSize));

    if (pCRCInit->TypeCRC == FLASH_CRC_SECTORS)
    {
      /* Select CRC by sector and clear sectors list */
      SET_BIT(FLASH->CRCCR, (FLASH_CRCCR_CRC_BY_SECT | FLASH_CRCCR_CLEAN_SECT));

      /* Select CRC sectors */
      for (sector_index = pCRCInit->Sector; sector_index < (pCRCInit->NbSectors + pCRCInit->Sector); sector_index++)
      {
        FLASH_CRC_AddSector(sector_index);
      }
    }
    else if (pCRCInit->TypeCRC == FLASH_CRC_BANK)
    {
      /* Select CRC by sector and all sectors */
      SET_BIT(FLASH->CRCCR, (FLASH_CRCCR_CRC_BY_SECT | FLASH_CRCCR_ALL_SECT));
    }
    else
    {
      /* Select CRC by address */
      CLEAR_BIT(FLASH->CRCCR, FLASH_CRCCR_CRC_BY_SECT);

      /* Select CRC start and end addresses */
      FLASH_CRC_SelectAddress(pCRCInit->CRCStartAddr, pCRCInit->CRCEndAddr);
    }

    /* Start the CRC calculation */
    SET_BIT(FLASH->CRCCR, FLASH_CRCCR_START_CRC);

    /* Wait on CRC busy flag */
    status = FLASH_CRC_WaitForLastOperation((uint32_t)FLASH_TIMEOUT_VALUE);

    /* Return CRC result */
    (*CRC_Result) = FLASH->CRCDATAR;

    /* Disable CRC feature */
    CLEAR_BIT(FLASH->CR, FLASH_CR_CRC_EN);

    /* Clear CRC flags */
    FLASH->ICR = (FLASH_ICR_CRCRDERRF | FLASH_ICR_CRCENDF);

    /* Process Unlocked */
    __HAL_UNLOCK(&pFlash);
  }

  return status;
}

void HAL_FLASHEx_EnableEccCorrectionInterrupt(void)
{
  __HAL_FLASH_ENABLE_IT(FLASH_IT_SNECCERR);
}

void HAL_FLASHEx_DisableEccCorrectionInterrupt(void)
{
  __HAL_FLASH_DISABLE_IT(FLASH_IT_SNECCERR);
}

void HAL_FLASHEx_EnableEccDetectionInterrupt(void)
{
  __HAL_FLASH_ENABLE_IT(FLASH_IT_DBECCERR);
}

void HAL_FLASHEx_DisableEccDetectionInterrupt(void)
{
  __HAL_FLASH_DISABLE_IT(FLASH_IT_DBECCERR);
}

void HAL_FLASHEx_GetEccInfo(FLASH_EccInfoTypeDef *pData)
{
  /* Check Null pointer */
  assert_param(pData != NULL);

  /* Set address which generate ECC error */
  if ((FLASH->ISR & FLASH_FLAG_SNECCERR) != 0U)
  {
    pData->Address = FLASH->ECCSFADDR;
  }
  else
  {
    pData->Address = FLASH->ECCDFADDR;
  }

  /* Set area according address */
  if (IS_FLASH_MAIN_MEM_ADDRESS(pData->Address))
  {
    pData->Area = FLASH_ECC_AREA_USER_BANK1;
  }
  else if (IS_FLASH_OTP_ADDRESS(pData->Address))
  {
    pData->Area = FLASH_ECC_AREA_OTP;
  }
  else if ((pData->Address >= SYSTEM_FLASH_BASE) &&
           (pData->Address < (SYSTEM_FLASH_BASE + SYSTEM_FLASH_SIZE)))
  {
    pData->Area = FLASH_ECC_AREA_SYSTEM;
  }
  else
  {
    pData->Area = FLASH_ECC_AREA_READ_ONLY;
  }

  /* Set Master which initiates transaction. On H7RS, it's necessary CPU1 */
  pData->MasterID = FLASH_ECC_MASTER_CPU1;
}

void HAL_FLASHEx_ECCD_IRQHandler(void)
{
  /* Check ECC Detection Error */
  if ((FLASH->ISR & FLASH_FLAG_DBECCERR) != 0U)
  {
    /* Call User callback */
    HAL_FLASHEx_EccDetectionCallback();

    /* Clear ECC detection flag in order to allow new ECC error record */
    FLASH->ICR = FLASH_FLAG_DBECCERR;
  }
}

__weak void HAL_FLASHEx_EccCorrectionCallback(void)
{
  /* NOTE : This function should not be modified, when the callback is needed,
            the HAL_FLASHEx_EccCorrectionCallback could be implemented in the user file
   */
}

__weak void HAL_FLASHEx_EccDetectionCallback(void)
{
  /* NOTE : This function should not be modified, when the callback is needed,
            the HAL_FLASHEx_EccDetectionCallback could be implemented in the user file
   */
}

static void FLASH_MassErase(void)
{
  /* Set the Mass Erase Bit and proceed to erase */
  SET_BIT(FLASH->CR, (FLASH_CR_BER | FLASH_CR_START));
}

void FLASH_SectorErase(uint32_t Sector)
{
  /* Check the parameters */
  assert_param(IS_FLASH_SECTOR(Sector));

  /* Proceed to erase the page */
  MODIFY_REG(FLASH->CR, (FLASH_CR_SSN | FLASH_CR_SER | FLASH_CR_START), \
             ((Sector << FLASH_CR_SSN_Pos) | FLASH_CR_SER | FLASH_CR_START));
}

static void FLASH_OB_WRPConfig(uint32_t WRPState, uint32_t WRPSector)
{
  /* Check the parameters */
  assert_param(IS_OB_WRPSTATE(WRPState));

  /* Configure the write protected area */
  if (WRPState == OB_WRPSTATE_DISABLE)
  {
    FLASH->WRPSRP |= (WRPSector & FLASH_WRPSRP_WRPS);
  }
  else if (WRPState == OB_WRPSTATE_ENABLE)
  {
    FLASH->WRPSRP &= (~(WRPSector & FLASH_WRPSRP_WRPS));
  }
  else
  {
    /* Empty statement (to be compliant MISRA 15.7) */
  }
}

static void FLASH_OB_UserConfig(uint32_t UserType, uint32_t UserConfig1, uint32_t UserConfig2)
{
  uint32_t optr_reg_val = 0;
  uint32_t optr_reg_mask = 0;

  /* Check the parameters */
  assert_param(IS_OB_USER_TYPE(UserType));

  if ((UserType & OB_USER_BOR_LEV) != 0U)
  {
    /* BOR level option byte should be modified */
    assert_param(IS_OB_USER_BOR_LEVEL(UserConfig1 & FLASH_OBW1SR_BOR_LEVEL));

    /* Set value and mask for BOR level option byte */
    optr_reg_val |= (UserConfig1 & FLASH_OBW1SR_BOR_LEVEL);
    optr_reg_mask |= FLASH_OBW1SR_BOR_LEVEL;
  }

  if ((UserType & OB_USER_IWDG_SW) != 0U)
  {
    /* IWDG1_HW option byte should be modified */
    assert_param(IS_OB_USER_IWDG(UserConfig1 & FLASH_OBW1SR_IWDG_HW));

    /* Set value and mask for IWDG1_HW option byte */
    optr_reg_val |= (UserConfig1 & FLASH_OBW1SR_IWDG_HW);
    optr_reg_mask |= FLASH_OBW1SR_IWDG_HW;
  }

  if ((UserType & OB_USER_NRST_STOP) != 0U)
  {
    /* NRST_STOP_D1 option byte should be modified */
    assert_param(IS_OB_USER_STOP(UserConfig1 & FLASH_OBW1SR_NRST_STOP));

    /* Set value and mask for NRST_STOP_D1 option byte */
    optr_reg_val |= (UserConfig1 & FLASH_OBW1SR_NRST_STOP);
    optr_reg_mask |= FLASH_OBW1SR_NRST_STOP;
  }

  if ((UserType & OB_USER_NRST_STDBY) != 0U)
  {
    /* NRST_STBY_D1 option byte should be modified */
    assert_param(IS_OB_USER_STANDBY(UserConfig1 & FLASH_OBW1SR_NRST_STBY));

    /* Set value and mask for NRST_STBY_D1 option byte */
    optr_reg_val |= (UserConfig1 & FLASH_OBW1SR_NRST_STBY);
    optr_reg_mask |= FLASH_OBW1SR_NRST_STBY;
  }

  if ((UserType & OB_USER_XSPI1_HSLV) != 0U)
  {
    /* XSPI1_HSLV option byte should be modified */
    assert_param(IS_OB_USER_XSPI1_HSLV(UserConfig1 & FLASH_OBW1SR_XSPI1_HSLV));

    /* Set value and mask for XSPI1_HSLV option byte */
    optr_reg_val |= (UserConfig1 & FLASH_OBW1SR_XSPI1_HSLV);
    optr_reg_mask |= FLASH_OBW1SR_XSPI1_HSLV;
  }

  if ((UserType & OB_USER_XSPI2_HSLV) != 0U)
  {
    /* XSPI2_HSLV option byte should be modified */
    assert_param(IS_OB_USER_XSPI2_HSLV(UserConfig1 & FLASH_OBW1SR_XSPI2_HSLV));

    /* Set value and mask for XSPI2_HSLV option byte */
    optr_reg_val |= (UserConfig1 & FLASH_OBW1SR_XSPI2_HSLV);
    optr_reg_mask |= FLASH_OBW1SR_XSPI2_HSLV;
  }

  if ((UserType & OB_USER_IWDG_STOP) != 0U)
  {
    /* IWDG_FZ_STOP option byte should be modified */
    assert_param(IS_OB_USER_IWDG_STOP(UserConfig1 & FLASH_OBW1SR_IWDG_FZ_STOP));

    /* Set value and mask for IWDG_FZ_STOP option byte */
    optr_reg_val |= (UserConfig1 & FLASH_OBW1SR_IWDG_FZ_STOP);
    optr_reg_mask |= FLASH_OBW1SR_IWDG_FZ_STOP;
  }

  if ((UserType & OB_USER_IWDG_STDBY) != 0U)
  {
    /* IWDG_FZ_SDBY option byte should be modified */
    assert_param(IS_OB_USER_IWDG_STDBY(UserConfig1 & FLASH_OBW1SR_IWDG_FZ_STBY));

    /* Set value and mask for IWDG_FZ_SDBY option byte */
    optr_reg_val |= (UserConfig1 & FLASH_OBW1SR_IWDG_FZ_STBY);
    optr_reg_mask |= FLASH_OBW1SR_IWDG_FZ_STBY;
  }

  if ((UserType & OB_USER_VDDIO_HSLV) != 0U)
  {
    /* VDDIO_HSLV option byte should be modified */
    assert_param(IS_OB_USER_VDDIO_HSLV(UserConfig1 & FLASH_OBW1SR_VDDIO_HSLV));

    /* Set value and mask for VDDIO_HSLV option byte */
    optr_reg_val |= (UserConfig1 & FLASH_OBW1SR_VDDIO_HSLV);
    optr_reg_mask |= FLASH_OBW1SR_VDDIO_HSLV;
  }

  /* Configure the option bytes register 1 if necessary */
  if (optr_reg_mask != 0U)
  {
    MODIFY_REG(FLASH->OBW1SRP, optr_reg_mask, optr_reg_val);
  }

  optr_reg_val = 0;
  optr_reg_mask = 0;

  if ((UserType & OB_USER_ITCM_AXI_SHARE) != 0U)
  {
    /* ITCM_AXI_SHARE option byte should be modified */
    assert_param(IS_OB_USER_ITCM_AXI_SHARE(UserConfig2 & FLASH_OBW2SR_ITCM_AXI_SHARE));

    /* Set value and mask for ITCM_AXI_SHARE option byte */
    optr_reg_val |= (UserConfig2 & FLASH_OBW2SR_ITCM_AXI_SHARE);
    optr_reg_mask |= FLASH_OBW2SR_ITCM_AXI_SHARE;
  }

  if ((UserType & OB_USER_DTCM_AXI_SHARE) != 0U)
  {
    /* DTCM_AXI_SHARE option byte should be modified */
    assert_param(IS_OB_USER_DTCM_AXI_SHARE(UserConfig2 & FLASH_OBW2SR_DTCM_AXI_SHARE));

    /* Set value and mask for DTCM_AXI_SHARE option byte */
    optr_reg_val |= (UserConfig2 & FLASH_OBW2SR_DTCM_AXI_SHARE);
    optr_reg_mask |= FLASH_OBW2SR_DTCM_AXI_SHARE;
  }

  if ((UserType & OB_USER_SRAM_ECC) != 0U)
  {
    /* SRAM_ECC option byte should be modified */
    assert_param(IS_OB_USER_AXISRAM_ECC(UserConfig2 & FLASH_OBW2SR_ECC_ON_SRAM));

    /* Set value and mask for SRAM_ECC option byte */
    optr_reg_val |= (UserConfig2 & FLASH_OBW2SR_ECC_ON_SRAM);
    optr_reg_mask |= FLASH_OBW2SR_ECC_ON_SRAM;
  }

  if ((UserType & OB_USER_I2C_NI3C) != 0U)
  {
    /* I2C_NI3C option byte should be modified */
    assert_param(IS_OB_USER_I2C_NI3C(UserConfig2 & FLASH_OBW2SR_I2C_NI3C));

    /* Set value and mask for I2C_NI3C option byte */
    optr_reg_val |= (UserConfig2 & FLASH_OBW2SR_I2C_NI3C);
    optr_reg_mask |= FLASH_OBW2SR_I2C_NI3C;
  }

  /* Configure the option bytes register 2 if necessary */
  if (optr_reg_mask != 0U)
  {
    MODIFY_REG(FLASH->OBW2SRP, optr_reg_mask, optr_reg_val);
  }
}

static void FLASH_OB_HDPConfig(uint32_t HDPStartPage, uint32_t HDPEndPage)
{
  /* Check the parameters */
  assert_param(IS_OB_HDP_PAGE(HDPStartPage));
  assert_param(IS_OB_HDP_PAGE(HDPEndPage));

  MODIFY_REG(FLASH->HDPSRP, (FLASH_HDPSRP_HDP_AREA_START | FLASH_HDPSRP_HDP_AREA_END), \
             (HDPStartPage | (HDPEndPage << FLASH_HDPSRP_HDP_AREA_END_Pos)));
}

static void FLASH_OB_NVConfig(uint32_t NVState)
{
  /* Check the parameter */
  assert_param(IS_OB_NVSTATE(NVState));

  MODIFY_REG(FLASH->NVSRP, FLASH_NVSRP_NVSTATE, NVState);
}

static void FLASH_OB_GetWRP(uint32_t *WRPState, uint32_t *WRPSector)
{
  if ((FLASH->WRPSR & FLASH_WRPSR_WRPS) == FLASH_WRPSR_WRPS)
  {
    /* All sectors aren't write protected */
    *WRPState = OB_WRPSTATE_DISABLE;
  }
  else
  {
    /* Some sectors are write protected */
    *WRPState = OB_WRPSTATE_ENABLE;
    *WRPSector = ((~(FLASH->WRPSR)) & FLASH_WRPSR_WRPS);
  }
}

static void FLASH_OB_GetUser(uint32_t *UserConfig1, uint32_t *UserConfig2)
{
  *UserConfig1 = FLASH->OBW1SR;
  *UserConfig2 = FLASH->OBW2SR;
}

static void FLASH_OB_GetHDP(uint32_t *HDPStartPage, uint32_t *HDPEndPage)
{
  *HDPStartPage = (FLASH->HDPSR & FLASH_HDPSR_HDP_AREA_START);
  *HDPEndPage = ((FLASH->HDPSR & FLASH_HDPSR_HDP_AREA_END) >> FLASH_HDPSR_HDP_AREA_END_Pos);
}

static uint32_t FLASH_OB_GetNV(void)
{
  return (FLASH->NVSR & FLASH_NVSR_NVSTATE);
}

static uint32_t FLASH_OB_GetRoT(void)
{
  return (FLASH->ROTSR & (FLASH_ROTSR_OEM_PROVD | FLASH_ROTSR_DBG_AUTH | FLASH_ROTSR_IROT_SELECT));
}

static uint32_t FLASH_OB_GetEpoch(void)
{
  return (FLASH->EPOCHSR & FLASH_EPOCHSR_EPOCH);
}

static void FLASH_CRC_AddSector(uint32_t Sector)
{
  /* Check the parameters */
  assert_param(IS_FLASH_SECTOR(Sector));

  /* Clear CRC sector */
  MODIFY_REG(FLASH->CRCCR, FLASH_CRCCR_CRC_SECT, Sector);

  /* Activate ADD_SECT bit */
  SET_BIT(FLASH->CRCCR, FLASH_CRCCR_ADD_SECT);
}

static void FLASH_CRC_SelectAddress(uint32_t CRCStartAddr, uint32_t CRCEndAddr)
{
  assert_param(IS_FLASH_MAIN_MEM_ADDRESS(CRCStartAddr));
  assert_param(IS_FLASH_MAIN_MEM_ADDRESS(CRCEndAddr));

  /* Write CRC Start and End addresses */
  FLASH->CRCSADDR = (CRCStartAddr - FLASH_BASE);
  FLASH->CRCEADDR = (CRCEndAddr - FLASH_BASE);
}

static HAL_StatusTypeDef FLASH_CRC_WaitForLastOperation(uint32_t Timeout)
{
  uint32_t tickstart = HAL_GetTick();

  /* Wait for the FLASH CRC computation to complete by polling on CRC_BUSY flag to be reset */
  while ((FLASH->SR & FLASH_SR_CRC_BUSY) != 0U)
  {
    if(((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
    {
      return HAL_TIMEOUT;
    }
  }

  /* Check FLASH CRC calculation error flag  */
  if ((FLASH->ISR & FLASH_FLAG_CRCERR) != 0U)
  {
    /*Save the error code*/
    pFlash.ErrorCode |= HAL_FLASH_ERROR_CRC;

    /* Clear CRC error flag */
    FLASH->ICR = FLASH_FLAG_CRCERR;

    return HAL_ERROR;
  }

  /* Check FLASH CRC End of Calculation flag  */
  if ((FLASH->ISR & FLASH_FLAG_CRCEND) != 0U)
  {
    /* Clear FLASH End of Calculation pending bit */
    FLASH->ICR = FLASH_FLAG_CRCEND;
  }

  /* If there is no error flag set */
  return HAL_OK;
}
