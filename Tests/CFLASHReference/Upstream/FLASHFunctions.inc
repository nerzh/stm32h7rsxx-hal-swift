/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted unchanged from STM32H7RS HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
HAL_StatusTypeDef HAL_FLASH_Program(uint32_t TypeProgram, uint32_t Address, uint32_t DataAddress)
{
  HAL_StatusTypeDef status;

  /* Check the parameters */
  assert_param(IS_FLASH_TYPEPROGRAM(TypeProgram));

  /* Process Locked */
  __HAL_LOCK(&pFlash);

  /* Reset error code */
  pFlash.ErrorCode = HAL_FLASH_ERROR_NONE;

  /* Wait for last operation to be completed */
  status = FLASH_WaitForLastOperation(FLASH_TIMEOUT_VALUE);

  if (status == HAL_OK)
  {
    switch (TypeProgram)
    {
      case FLASH_TYPEPROGRAM_BYTE:
        /* Program a byte (8-bit) at a specified address */
        FLASH_Program_Byte(Address, DataAddress);
        break;

      case FLASH_TYPEPROGRAM_HALFWORD:
        /* Program a half-word (16-bit) at a specified address */
        FLASH_Program_HalfWord(Address, DataAddress);
        break;

      case FLASH_TYPEPROGRAM_WORD:
        /* Program a word (32-bit) at a specified address */
        FLASH_Program_Word(Address, DataAddress);
        break;

      case FLASH_TYPEPROGRAM_DOUBLEWORD:
        /* Program a double-word (64-bit) at a specified address */
        FLASH_Program_DoubleWord(Address, DataAddress);
        break;

      case FLASH_TYPEPROGRAM_QUADWORD:
        /* Program a quad-word (128-bit) at a specified address */
        FLASH_Program_QuadWord(Address, DataAddress);
        break;

      case FLASH_TYPEPROGRAM_OTP_HALFWORD:
        /* Program a half-word (16-bit) at a OTP address */
        FLASH_Program_OTPHalfWord(Address, DataAddress);
        break;

      case FLASH_TYPEPROGRAM_OTP_WORD:
        /* Program a word (32-bit) at a OTP address */
        FLASH_Program_OTPWord(Address, DataAddress);
        break;

      default:
        status = HAL_ERROR;
        break;
    }

    if (status != HAL_ERROR)
    {
      /* Wait for last operation to be completed */
      status = FLASH_WaitForLastOperation(FLASH_TIMEOUT_VALUE);

      /* If the program operation is completed, disable the PG (and FW Bit in non quad-word mode) */
      CLEAR_BIT(FLASH->CR, (TypeProgram & ~(FLASH_WORD_SIZE_MASK)));
    }
  }

  /* Process Unlocked */
  __HAL_UNLOCK(&pFlash);

  /* return status */
  return status;
}

HAL_StatusTypeDef HAL_FLASH_Program_IT(uint32_t TypeProgram, uint32_t Address, uint32_t DataAddress)
{
  HAL_StatusTypeDef status;

  /* Check the parameters */
  assert_param(IS_FLASH_TYPEPROGRAM(TypeProgram));

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
    pFlash.ProcedureOnGoing = TypeProgram;
    pFlash.Address = Address;

    /* Enable End of Operation and Error interrupts */
    SET_BIT(FLASH->IER, (FLASH_IT_EOP | FLASH_IT_WRPERR | FLASH_IT_PGSERR | FLASH_IT_STRBERR | FLASH_IT_INCERR));

    switch (TypeProgram)
    {
      case FLASH_TYPEPROGRAM_BYTE:
        /* Program a byte (8-bit) at a specified address */
        FLASH_Program_Byte(Address, DataAddress);
        break;

      case FLASH_TYPEPROGRAM_HALFWORD:
        /* Program a half-word (16-bit) at a specified address */
        FLASH_Program_HalfWord(Address, DataAddress);
        break;

      case FLASH_TYPEPROGRAM_WORD:
        /* Program a word (32-bit) at a specified address */
        FLASH_Program_Word(Address, DataAddress);
        break;

      case FLASH_TYPEPROGRAM_DOUBLEWORD:
        /* Program a double-word (64-bit) at a specified address */
        FLASH_Program_DoubleWord(Address, DataAddress);
        break;

      case FLASH_TYPEPROGRAM_QUADWORD:
        /* Program a quad-word (128-bit) at a specified address */
        FLASH_Program_QuadWord(Address, DataAddress);
        break;

      case FLASH_TYPEPROGRAM_OTP_HALFWORD:
        /* Program a half-word (16-bit) at a OTP address */
        FLASH_Program_OTPHalfWord(Address, DataAddress);
        break;

      case FLASH_TYPEPROGRAM_OTP_WORD:
        /* Program a word (32-bit) at a OTP address */
        FLASH_Program_OTPWord(Address, DataAddress);
        break;

      default:
        status = HAL_ERROR;

        /* Process Unlocked */
        __HAL_UNLOCK(&pFlash);
        break;
    }
  }

  return status;
}

void HAL_FLASH_IRQHandler(void)
{
  uint32_t param = 0U;
  uint32_t error;

  /* Save Flash errors */
  error = FLASH->ISR & FLASH_FLAG_ISR_ERRORS;
  error |= (FLASH->OPTISR & FLASH_FLAG_OPTISR_ERRORS);

  /* Set parameter of the callback */
  if (pFlash.ProcedureOnGoing == FLASH_TYPEERASE_SECTORS)
  {
    param = pFlash.Sector;
  }
  else if ((pFlash.ProcedureOnGoing & FLASH_CR_PG) != 0U)
  {
    param = pFlash.Address;
  }
  else
  {
    /* Empty statement (to be compliant MISRA 15.7) */
  }

  /* Clear operation bit on the on-going procedure */
  CLEAR_BIT(FLASH->CR, (pFlash.ProcedureOnGoing & ~(FLASH_WORD_SIZE_MASK)));

  /* Check FLASH operation error flags */
  if (error != 0U)
  {
    /* Save the error code */
    pFlash.ErrorCode |= error;

    /* Clear error programming flags */
    FLASH->ICR = (error & FLASH_FLAG_ISR_ERRORS);
    FLASH->OPTICR = (error & FLASH_FLAG_OPTISR_ERRORS);

    /* Stop the procedure ongoing */
    pFlash.ProcedureOnGoing = 0U;

    /* FLASH error interrupt user callback */
    HAL_FLASH_OperationErrorCallback(param);
  }

  /* Check FLASH End of Operation flag  */
  if ((FLASH->ISR & FLASH_FLAG_EOP) != 0U)
  {
    /* Clear FLASH End of Operation pending bit */
    FLASH->ICR = FLASH_FLAG_EOP;

    if (pFlash.ProcedureOnGoing == FLASH_TYPEERASE_SECTORS)
    {
      /* Nb of sectors to erase can be decreased */
      pFlash.NbSectorsToErase--;

      /* Check if there are still sectors to erase */
      if (pFlash.NbSectorsToErase != 0U)
      {
        /* Increment sector number */
        pFlash.Sector++;
        FLASH_SectorErase(pFlash.Sector);
      }
      else
      {
        /* No more sectors to Erase */
        pFlash.ProcedureOnGoing = 0U;
        param = 0xFFFFFFFFU;
      }
    }
    else
    {
      /*Clear the procedure ongoing*/
      pFlash.ProcedureOnGoing = 0U;
    }

    /* FLASH EOP interrupt user callback */
    HAL_FLASH_EndOfOperationCallback(param);
  }

  if (pFlash.ProcedureOnGoing == 0U)
  {
    /* Disable End of Operation and Error interrupts */
    CLEAR_BIT(FLASH->IER, (FLASH_IT_EOP | FLASH_IT_WRPERR | FLASH_IT_PGSERR | FLASH_IT_STRBERR | FLASH_IT_INCERR));

    /* Process Unlocked */
    __HAL_UNLOCK(&pFlash);
  }

  /* Check ECC Correction Error */
  if ((FLASH->IER & FLASH_IT_SNECCERR) != 0U)
  {
    if ((FLASH->ISR & FLASH_FLAG_SNECCERR) != 0U)
    {
      /* Call User callback */
      HAL_FLASHEx_EccCorrectionCallback();

      /* Clear ECC correction flag in order to allow new ECC error record */
      FLASH->ICR = FLASH_FLAG_SNECCERR;
    }
  }

  /* Check ECC Detection Error */
  if ((FLASH->IER & FLASH_IT_DBECCERR) != 0U)
  {
    if ((FLASH->ISR & FLASH_FLAG_DBECCERR) != 0U)
    {
      /* Call User callback */
      HAL_FLASHEx_EccDetectionCallback();

      /* Clear ECC detection flag in order to allow new ECC error record */
      FLASH->ICR = FLASH_FLAG_DBECCERR;
    }
  }
}

__weak void HAL_FLASH_EndOfOperationCallback(uint32_t ReturnValue)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(ReturnValue);

  /* NOTE : This function should not be modified, when the callback is needed,
            the HAL_FLASH_EndOfOperationCallback could be implemented in the user file
   */
}

__weak void HAL_FLASH_OperationErrorCallback(uint32_t ReturnValue)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(ReturnValue);

  /* NOTE : This function should not be modified, when the callback is needed,
            the HAL_FLASH_OperationErrorCallback could be implemented in the user file
   */
}

HAL_StatusTypeDef HAL_FLASH_Unlock(void)
{
  if (READ_BIT(FLASH->CR, FLASH_CR_LOCK) != 0U)
  {
    /* Authorize the FLASH Registers access */
    WRITE_REG(FLASH->KEYR, FLASH_KEY1);
    WRITE_REG(FLASH->KEYR, FLASH_KEY2);

    /* verify Flash is unlocked */
    if (READ_BIT(FLASH->CR, FLASH_CR_LOCK) != 0U)
    {
      return HAL_ERROR;
    }
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_FLASH_Lock(void)
{
  /* Set the LOCK Bit to lock the FLASH Registers access */
  SET_BIT(FLASH->CR, FLASH_CR_LOCK);

  /* verify Flash is locked */
  if (READ_BIT(FLASH->CR, FLASH_CR_LOCK) != 0U)
  {
    return HAL_OK;
  }

  return HAL_ERROR;
}

HAL_StatusTypeDef HAL_FLASH_OB_Unlock(void)
{
  if (READ_BIT(FLASH->OPTCR, FLASH_OPTCR_OPTLOCK) != 0U)
  {
    /* Authorizes the Option Byte register programming */
    WRITE_REG(FLASH->OPTKEYR, FLASH_OPT_KEY1);
    WRITE_REG(FLASH->OPTKEYR, FLASH_OPT_KEY2);

    /* Verify that the Option Bytes are unlocked */
    if (READ_BIT(FLASH->OPTCR, FLASH_OPTCR_OPTLOCK) != 0U)
    {
      return HAL_ERROR;
    }
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_FLASH_OB_Lock(void)
{
  /* Set the OPTLOCK Bit to lock the FLASH Option Byte Registers access */
  SET_BIT(FLASH->OPTCR, FLASH_OPTCR_OPTLOCK);

  /* Verify that the Option Bytes are locked */
  if (READ_BIT(FLASH->OPTCR, FLASH_OPTCR_OPTLOCK) != 0U)
  {
    return HAL_OK;
  }

  return HAL_ERROR;
}

uint32_t HAL_FLASH_GetError(void)
{
  return pFlash.ErrorCode;
}

HAL_StatusTypeDef FLASH_WaitForLastOperation(uint32_t Timeout)
{
  /* Wait for the FLASH operation to complete by polling on BUSY flag to be reset.
     Even if the FLASH operation fails, the BUSY flag will be reset and an error
     flag will be set */

  uint32_t tickstart = HAL_GetTick();
  uint32_t error;

  while ((FLASH->SR & FLASH_SR_QW) != 0U)
  {
    if (Timeout != HAL_MAX_DELAY)
    {
      if(((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
      {
        return HAL_TIMEOUT;
      }
    }
  }

  /* Check FLASH operation error flags */
  error = (FLASH->ISR & FLASH_FLAG_ISR_ERRORS);
  error |= (FLASH->OPTISR & FLASH_FLAG_OPTISR_ERRORS);

  if (error != 0U)
  {
    /*Save the error code*/
    pFlash.ErrorCode |= error;

    /* Clear error programming flags */
    FLASH->ICR = (error & FLASH_FLAG_ISR_ERRORS);
    FLASH->OPTICR = (error & FLASH_FLAG_OPTISR_ERRORS);

    return HAL_ERROR;
  }

  /* Check FLASH End of Operation flag  */
  if ((FLASH->ISR & FLASH_FLAG_EOP) != 0U)
  {
    /* Clear FLASH End of Operation pending bit */
    FLASH->ICR = FLASH_FLAG_EOP;
  }

  /* If there is no error flag set */
  return HAL_OK;
}

static void FLASH_Program_Byte(uint32_t Address, uint32_t DataAddress)
{
  uint8_t *dest_addr = (uint8_t *)Address;
  uint8_t *src_addr  = (uint8_t *)DataAddress;
  uint32_t primask_bit;

  /* Check the parameters */
  assert_param(IS_FLASH_MAIN_MEM_ADDRESS(Address));

  /* Set PG bit */
  SET_BIT(FLASH->CR, FLASH_CR_PG);

  /* Enter critical section: Disable interrupts to avoid any interruption during the loop */
  primask_bit = __get_PRIMASK();
  __disable_irq();

  /* Program the byte */
  *dest_addr = *src_addr;

  __ISB();
  __DSB();

  /* Set FW bit */
  SET_BIT(FLASH->CR, FLASH_CR_FW);

  /* Exit critical section: restore previous priority mask */
  __set_PRIMASK(primask_bit);
}

static void FLASH_Program_HalfWord(uint32_t Address, uint32_t DataAddress)
{
  uint16_t *dest_addr = (uint16_t *)Address;
  uint16_t *src_addr  = (uint16_t *)DataAddress;
  uint32_t primask_bit;

  /* Check the parameters */
  assert_param(IS_FLASH_MAIN_MEM_ADDRESS(Address));

  /* Set PG bit */
  SET_BIT(FLASH->CR, FLASH_CR_PG);

  /* Enter critical section: Disable interrupts to avoid any interruption during the loop */
  primask_bit = __get_PRIMASK();
  __disable_irq();

  /* Program the half-word */
  *dest_addr = *src_addr;

  __ISB();
  __DSB();

  /* Set FW bit */
  SET_BIT(FLASH->CR, FLASH_CR_FW);

  /* Exit critical section: restore previous priority mask */
  __set_PRIMASK(primask_bit);
}

static void FLASH_Program_Word(uint32_t Address, uint32_t DataAddress)
{
  uint8_t index = 2;
  uint16_t *dest_addr = (uint16_t *)Address;
  uint16_t *src_addr  = (uint16_t *)DataAddress;
  uint32_t primask_bit;

  /* Check the parameters */
  assert_param(IS_FLASH_MAIN_MEM_ADDRESS(Address));

  /* Set PG bit */
  SET_BIT(FLASH->CR, FLASH_CR_PG);

  /* Enter critical section: Disable interrupts to avoid any interruption during the loop */
  primask_bit = __get_PRIMASK();
  __disable_irq();

  /* Program the word */
  do
  {
    *dest_addr = *src_addr;
    dest_addr++;
    src_addr++;
    index--;
  } while (index != 0U);

  __ISB();
  __DSB();

  /* Set FW bit */
  SET_BIT(FLASH->CR, FLASH_CR_FW);

  /* Exit critical section: restore previous priority mask */
  __set_PRIMASK(primask_bit);
}

static void FLASH_Program_DoubleWord(uint32_t Address, uint32_t DataAddress)
{
  uint8_t index = 4;
  uint16_t *dest_addr = (uint16_t *)Address;
  uint16_t *src_addr  = (uint16_t *)DataAddress;
  uint32_t primask_bit;

  /* Check the parameters */
  assert_param(IS_FLASH_MAIN_MEM_ADDRESS(Address));

  /* Set PG bit */
  SET_BIT(FLASH->CR, FLASH_CR_PG);

  /* Enter critical section: Disable interrupts to avoid any interruption during the loop */
  primask_bit = __get_PRIMASK();
  __disable_irq();

  /* Program the double-word */
  do
  {
    *dest_addr = *src_addr;
    dest_addr++;
    src_addr++;
    index--;
  } while (index != 0U);

  __ISB();
  __DSB();

  /* Set FW bit */
  SET_BIT(FLASH->CR, FLASH_CR_FW);

  /* Exit critical section: restore previous priority mask */
  __set_PRIMASK(primask_bit);
}

static void FLASH_Program_QuadWord(uint32_t Address, uint32_t DataAddress)
{
  uint8_t index = 8;
  uint16_t *dest_addr = (uint16_t *)Address;
  uint16_t *src_addr  = (uint16_t *)DataAddress;
  uint32_t primask_bit;

  /* Check the parameters */
  assert_param(IS_FLASH_MAIN_MEM_ADDRESS(Address));

  /* Set PG bit */
  SET_BIT(FLASH->CR, FLASH_CR_PG);

  /* Enter critical section: Disable interrupts to avoid any interruption during the loop */
  primask_bit = __get_PRIMASK();
  __disable_irq();

  /* Program the quad-word */
  do
  {
    *dest_addr = *src_addr;
    dest_addr++;
    src_addr++;
    index--;
  } while (index != 0U);

  __ISB();
  __DSB();

  /* Exit critical section: restore previous priority mask */
  __set_PRIMASK(primask_bit);
}

static void FLASH_Program_OTPHalfWord(uint32_t Address, uint32_t DataAddress)
{
  uint16_t *dest_addr = (uint16_t *)Address;
  uint16_t *src_addr  = (uint16_t *)DataAddress;
  uint32_t primask_bit;

  /* Check the parameters */
  assert_param(IS_FLASH_OTP_ADDRESS(Address));

  /* Set PG_OTP bit */
  SET_BIT(FLASH->CR, FLASH_CR_PG_OTP);

  /* Enter critical section: Disable interrupts to avoid any interruption during the loop */
  primask_bit = __get_PRIMASK();
  __disable_irq();

  /* Program the half-word */
  *dest_addr = *src_addr;

  __ISB();
  __DSB();

  /* Set FW bit */
  SET_BIT(FLASH->CR, FLASH_CR_FW);

  /* Exit critical section: restore previous priority mask */
  __set_PRIMASK(primask_bit);
}

static void FLASH_Program_OTPWord(uint32_t Address, uint32_t DataAddress)
{
  uint8_t index = 2;
  uint16_t *dest_addr = (uint16_t *)Address;
  uint16_t *src_addr  = (uint16_t *)DataAddress;
  uint32_t primask_bit;

  /* Check the parameters */
  assert_param(IS_FLASH_OTP_ADDRESS(Address));

  /* Set PG_OTP bit */
  SET_BIT(FLASH->CR, FLASH_CR_PG_OTP);

  /* Enter critical section: Disable interrupts to avoid any interruption during the loop */
  primask_bit = __get_PRIMASK();
  __disable_irq();

  /* Program the word */
  do
  {
    *dest_addr = *src_addr;
    dest_addr++;
    src_addr++;
    index--;
  } while (index != 0U);

  __ISB();
  __DSB();

  /* Set FW bit */
  SET_BIT(FLASH->CR, FLASH_CR_FW);

  /* Exit critical section: restore previous priority mask */
  __set_PRIMASK(primask_bit);
}
