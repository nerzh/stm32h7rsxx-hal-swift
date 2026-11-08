// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// NOR operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

HAL_StatusTypeDef HAL_NOR_Init(NOR_HandleTypeDef *hnor, FMC_NORSRAM_TimingTypeDef *Timing,
                               FMC_NORSRAM_TimingTypeDef *ExtTiming)
{
  uint32_t deviceaddress;
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the NOR handle parameter */
  if (hnor == NULL)
  {
    return HAL_ERROR;
  }

  if (hnor->State == HAL_NOR_STATE_RESET)
  {
    /* Allocate lock resource and initialize it */
    hnor->Lock = HAL_UNLOCKED;

#if (USE_HAL_NOR_REGISTER_CALLBACKS == 1)
    if (hnor->MspInitCallback == NULL)
    {
      hnor->MspInitCallback = HAL_NOR_MspInit;
    }

    /* Init the low level hardware */
    hnor->MspInitCallback(hnor);
#else
    /* Initialize the low level hardware (MSP) */
    HAL_NOR_MspInit(hnor);
#endif /* (USE_HAL_NOR_REGISTER_CALLBACKS) */
  }

  /* Initialize NOR control Interface */
  (void)FMC_NORSRAM_Init(hnor->Instance, &(hnor->Init));

  /* Initialize NOR timing Interface */
  (void)FMC_NORSRAM_Timing_Init(hnor->Instance, Timing, hnor->Init.NSBank);

  /* Initialize NOR extended mode timing Interface */
  (void)FMC_NORSRAM_Extended_Timing_Init(hnor->Extended, ExtTiming,
                                         hnor->Init.NSBank, hnor->Init.ExtendedMode);

  /* Enable the NORSRAM device */
  __FMC_NORSRAM_ENABLE(hnor->Instance, hnor->Init.NSBank);

  /* Initialize NOR Memory Data Width*/
  if (hnor->Init.MemoryDataWidth == FMC_NORSRAM_MEM_BUS_WIDTH_8)
  {
    uwNORMemoryDataWidth = NOR_MEMORY_8B;
  }
  else
  {
    uwNORMemoryDataWidth = NOR_MEMORY_16B;
  }

  /* Enable FMC Peripheral */
  __FMC_ENABLE();

  /* Initialize the NOR controller state */
  hnor->State = HAL_NOR_STATE_READY;

  /* Select the NOR device address */
  if (hnor->Init.NSBank == FMC_NORSRAM_BANK1)
  {
    deviceaddress = NOR_MEMORY_ADRESS1;
  }
  else if (hnor->Init.NSBank == FMC_NORSRAM_BANK2)
  {
    deviceaddress = NOR_MEMORY_ADRESS2;
  }
  else if (hnor->Init.NSBank == FMC_NORSRAM_BANK3)
  {
    deviceaddress = NOR_MEMORY_ADRESS3;
  }
  else /* FMC_NORSRAM_BANK4 */
  {
    deviceaddress = NOR_MEMORY_ADRESS4;
  }

  if (hnor->Init.WriteOperation == FMC_WRITE_OPERATION_DISABLE)
  {
    (void)FMC_NORSRAM_WriteOperation_Disable(hnor->Instance, hnor->Init.NSBank);

    /* Update the NOR controller state */
    hnor->State = HAL_NOR_STATE_PROTECTED;
  }
  else
  {
    /* Get the value of the command set */
    if (uwNORMemoryDataWidth == NOR_MEMORY_8B)
    {
      NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_FIRST_CFI_BYTE),
                NOR_CMD_DATA_CFI);
    }
    else
    {
      NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_FIRST_CFI), NOR_CMD_DATA_CFI);
    }

    hnor->CommandSet = FMC_MEMORY_READ16(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_ADDRESS_COMMAND_SET));

    status = HAL_NOR_ReturnToReadMode(hnor);
  }

  return status;
}

HAL_StatusTypeDef HAL_NOR_DeInit(NOR_HandleTypeDef *hnor)
{
#if (USE_HAL_NOR_REGISTER_CALLBACKS == 1)
  if (hnor->MspDeInitCallback == NULL)
  {
    hnor->MspDeInitCallback = HAL_NOR_MspDeInit;
  }

  /* DeInit the low level hardware */
  hnor->MspDeInitCallback(hnor);
#else
  /* De-Initialize the low level hardware (MSP) */
  HAL_NOR_MspDeInit(hnor);
#endif /* (USE_HAL_NOR_REGISTER_CALLBACKS) */

  /* Configure the NOR registers with their reset values */
  (void)FMC_NORSRAM_DeInit(hnor->Instance, hnor->Extended, hnor->Init.NSBank);

  /* Reset the NOR controller state */
  hnor->State = HAL_NOR_STATE_RESET;

  /* Release Lock */
  __HAL_UNLOCK(hnor);

  return HAL_OK;
}

HAL_StatusTypeDef HAL_NOR_Read_ID(NOR_HandleTypeDef *hnor, NOR_IDTypeDef *pNOR_ID)
{
  uint32_t deviceaddress;
  HAL_NOR_StateTypeDef state;
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the NOR controller state */
  state = hnor->State;
  if (state == HAL_NOR_STATE_BUSY)
  {
    return HAL_BUSY;
  }
  else if (state == HAL_NOR_STATE_PROTECTED)
  {
    return HAL_ERROR;
  }
  else if (state == HAL_NOR_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hnor);

    /* Update the NOR controller state */
    hnor->State = HAL_NOR_STATE_BUSY;

    /* Select the NOR device address */
    if (hnor->Init.NSBank == FMC_NORSRAM_BANK1)
    {
      deviceaddress = NOR_MEMORY_ADRESS1;
    }
    else if (hnor->Init.NSBank == FMC_NORSRAM_BANK2)
    {
      deviceaddress = NOR_MEMORY_ADRESS2;
    }
    else if (hnor->Init.NSBank == FMC_NORSRAM_BANK3)
    {
      deviceaddress = NOR_MEMORY_ADRESS3;
    }
    else /* FMC_NORSRAM_BANK4 */
    {
      deviceaddress = NOR_MEMORY_ADRESS4;
    }

    /* Send read ID command */
    if (hnor->CommandSet == NOR_AMD_FUJITSU_COMMAND_SET)
    {
      if (uwNORMemoryDataWidth == NOR_MEMORY_8B)
      {
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_FIRST_BYTE),
                  NOR_CMD_DATA_FIRST);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_SECOND_BYTE),
                  NOR_CMD_DATA_SECOND);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_THIRD_BYTE),
                  NOR_CMD_DATA_AUTO_SELECT);
      }
      else
      {
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_FIRST), NOR_CMD_DATA_FIRST);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_SECOND), NOR_CMD_DATA_SECOND);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_THIRD),
                  NOR_CMD_DATA_AUTO_SELECT);
      }
    }
    else if (hnor->CommandSet == NOR_INTEL_SHARP_EXT_COMMAND_SET)
    {
      NOR_WRITE(deviceaddress, NOR_CMD_DATA_AUTO_SELECT);
    }
    else
    {
      /* Primary command set not supported by the driver */
      status = HAL_ERROR;
    }

    if (status != HAL_ERROR)
    {
      /* Read the NOR IDs */
      pNOR_ID->Manufacturer_Code = FMC_MEMORY_READ16(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, MC_ADDRESS));
      pNOR_ID->Device_Code1      = FMC_MEMORY_READ16(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth,
                                                                     DEVICE_CODE1_ADDR));
      pNOR_ID->Device_Code2      = FMC_MEMORY_READ16(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth,
                                                                     DEVICE_CODE2_ADDR));
      pNOR_ID->Device_Code3      = FMC_MEMORY_READ16(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth,
                                                                     DEVICE_CODE3_ADDR));
    }

    /* Check the NOR controller state */
    hnor->State = state;

    /* Process unlocked */
    __HAL_UNLOCK(hnor);
  }
  else
  {
    return HAL_ERROR;
  }

  return status;
}

HAL_StatusTypeDef HAL_NOR_ReturnToReadMode(NOR_HandleTypeDef *hnor)
{
  uint32_t deviceaddress;
  HAL_NOR_StateTypeDef state;
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the NOR controller state */
  state = hnor->State;
  if (state == HAL_NOR_STATE_BUSY)
  {
    return HAL_BUSY;
  }
  else if (state == HAL_NOR_STATE_PROTECTED)
  {
    return HAL_ERROR;
  }
  else if (state == HAL_NOR_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hnor);

    /* Update the NOR controller state */
    hnor->State = HAL_NOR_STATE_BUSY;

    /* Select the NOR device address */
    if (hnor->Init.NSBank == FMC_NORSRAM_BANK1)
    {
      deviceaddress = NOR_MEMORY_ADRESS1;
    }
    else if (hnor->Init.NSBank == FMC_NORSRAM_BANK2)
    {
      deviceaddress = NOR_MEMORY_ADRESS2;
    }
    else if (hnor->Init.NSBank == FMC_NORSRAM_BANK3)
    {
      deviceaddress = NOR_MEMORY_ADRESS3;
    }
    else /* FMC_NORSRAM_BANK4 */
    {
      deviceaddress = NOR_MEMORY_ADRESS4;
    }

    if (hnor->CommandSet == NOR_AMD_FUJITSU_COMMAND_SET)
    {
      NOR_WRITE(deviceaddress, NOR_CMD_DATA_READ_RESET);
    }
    else if (hnor->CommandSet == NOR_INTEL_SHARP_EXT_COMMAND_SET)
    {
      NOR_WRITE(deviceaddress, NOR_CMD_READ_ARRAY);
    }
    else
    {
      /* Primary command set not supported by the driver */
      status = HAL_ERROR;
    }

    /* Check the NOR controller state */
    hnor->State = state;

    /* Process unlocked */
    __HAL_UNLOCK(hnor);
  }
  else
  {
    return HAL_ERROR;
  }

  return status;
}

HAL_StatusTypeDef HAL_NOR_Read(NOR_HandleTypeDef *hnor, uint32_t *pAddress, uint16_t *pData)
{
  uint32_t deviceaddress;
  HAL_NOR_StateTypeDef state;
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the NOR controller state */
  state = hnor->State;
  if (state == HAL_NOR_STATE_BUSY)
  {
    return HAL_BUSY;
  }
  else if (state == HAL_NOR_STATE_PROTECTED)
  {
    return HAL_ERROR;
  }
  else if (state == HAL_NOR_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hnor);

    /* Update the NOR controller state */
    hnor->State = HAL_NOR_STATE_BUSY;

    /* Select the NOR device address */
    if (hnor->Init.NSBank == FMC_NORSRAM_BANK1)
    {
      deviceaddress = NOR_MEMORY_ADRESS1;
    }
    else if (hnor->Init.NSBank == FMC_NORSRAM_BANK2)
    {
      deviceaddress = NOR_MEMORY_ADRESS2;
    }
    else if (hnor->Init.NSBank == FMC_NORSRAM_BANK3)
    {
      deviceaddress = NOR_MEMORY_ADRESS3;
    }
    else /* FMC_NORSRAM_BANK4 */
    {
      deviceaddress = NOR_MEMORY_ADRESS4;
    }

    /* Send read data command */
    if (hnor->CommandSet == NOR_AMD_FUJITSU_COMMAND_SET)
    {
      if (uwNORMemoryDataWidth == NOR_MEMORY_8B)
      {
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_FIRST_BYTE),
                  NOR_CMD_DATA_FIRST);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_SECOND_BYTE),
                  NOR_CMD_DATA_SECOND);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_THIRD_BYTE),
                  NOR_CMD_DATA_READ_RESET);
      }
      else
      {
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_FIRST), NOR_CMD_DATA_FIRST);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_SECOND), NOR_CMD_DATA_SECOND);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_THIRD),
                  NOR_CMD_DATA_READ_RESET);
      }
    }
    else if (hnor->CommandSet == NOR_INTEL_SHARP_EXT_COMMAND_SET)
    {
      NOR_WRITE(pAddress, NOR_CMD_READ_ARRAY);
    }
    else
    {
      /* Primary command set not supported by the driver */
      status = HAL_ERROR;
    }

    if (status != HAL_ERROR)
    {
      /* Read the data */
      *pData = (uint16_t)(FMC_MEMORY_READ32(pAddress));
    }

    /* Check the NOR controller state */
    hnor->State = state;

    /* Process unlocked */
    __HAL_UNLOCK(hnor);
  }
  else
  {
    return HAL_ERROR;
  }

  return status;
}

HAL_StatusTypeDef HAL_NOR_Program(NOR_HandleTypeDef *hnor, uint32_t *pAddress, uint16_t *pData)
{
  uint32_t deviceaddress;
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the NOR controller state */
  if (hnor->State == HAL_NOR_STATE_BUSY)
  {
    return HAL_BUSY;
  }
  else if (hnor->State == HAL_NOR_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hnor);

    /* Update the NOR controller state */
    hnor->State = HAL_NOR_STATE_BUSY;

    /* Select the NOR device address */
    if (hnor->Init.NSBank == FMC_NORSRAM_BANK1)
    {
      deviceaddress = NOR_MEMORY_ADRESS1;
    }
    else if (hnor->Init.NSBank == FMC_NORSRAM_BANK2)
    {
      deviceaddress = NOR_MEMORY_ADRESS2;
    }
    else if (hnor->Init.NSBank == FMC_NORSRAM_BANK3)
    {
      deviceaddress = NOR_MEMORY_ADRESS3;
    }
    else /* FMC_NORSRAM_BANK4 */
    {
      deviceaddress = NOR_MEMORY_ADRESS4;
    }

    /* Send program data command */
    if (hnor->CommandSet == NOR_AMD_FUJITSU_COMMAND_SET)
    {
      if (uwNORMemoryDataWidth == NOR_MEMORY_8B)
      {
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_FIRST_BYTE),
                  NOR_CMD_DATA_FIRST);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_SECOND_BYTE),
                  NOR_CMD_DATA_SECOND);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_THIRD_BYTE),
                  NOR_CMD_DATA_PROGRAM);
      }
      else
      {
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_FIRST), NOR_CMD_DATA_FIRST);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_SECOND), NOR_CMD_DATA_SECOND);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_THIRD), NOR_CMD_DATA_PROGRAM);
      }
    }
    else if (hnor->CommandSet == NOR_INTEL_SHARP_EXT_COMMAND_SET)
    {
      NOR_WRITE(pAddress, NOR_CMD_WORD_PROGRAM);
    }
    else
    {
      /* Primary command set not supported by the driver */
      status = HAL_ERROR;
    }

    if (status != HAL_ERROR)
    {
      /* Write the data */
      NOR_WRITE(pAddress, *pData);
    }

    /* Check the NOR controller state */
    hnor->State = HAL_NOR_STATE_READY;

    /* Process unlocked */
    __HAL_UNLOCK(hnor);
  }
  else
  {
    return HAL_ERROR;
  }

  return status;
}

HAL_StatusTypeDef HAL_NOR_ReadBuffer(NOR_HandleTypeDef *hnor, uint32_t uwAddress, uint16_t *pData,
                                     uint32_t uwBufferSize)
{
  uint32_t deviceaddress;
  uint32_t size = uwBufferSize;
  uint32_t address = uwAddress;
  uint16_t *data = pData;
  HAL_NOR_StateTypeDef state;
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the NOR controller state */
  state = hnor->State;
  if (state == HAL_NOR_STATE_BUSY)
  {
    return HAL_BUSY;
  }
  else if (state == HAL_NOR_STATE_PROTECTED)
  {
    return HAL_ERROR;
  }
  else if (state == HAL_NOR_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hnor);

    /* Update the NOR controller state */
    hnor->State = HAL_NOR_STATE_BUSY;

    /* Select the NOR device address */
    if (hnor->Init.NSBank == FMC_NORSRAM_BANK1)
    {
      deviceaddress = NOR_MEMORY_ADRESS1;
    }
    else if (hnor->Init.NSBank == FMC_NORSRAM_BANK2)
    {
      deviceaddress = NOR_MEMORY_ADRESS2;
    }
    else if (hnor->Init.NSBank == FMC_NORSRAM_BANK3)
    {
      deviceaddress = NOR_MEMORY_ADRESS3;
    }
    else /* FMC_NORSRAM_BANK4 */
    {
      deviceaddress = NOR_MEMORY_ADRESS4;
    }

    /* Send read data command */
    if (hnor->CommandSet == NOR_AMD_FUJITSU_COMMAND_SET)
    {
      if (uwNORMemoryDataWidth == NOR_MEMORY_8B)
      {
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_FIRST_BYTE),
                  NOR_CMD_DATA_FIRST);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_SECOND_BYTE),
                  NOR_CMD_DATA_SECOND);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_THIRD_BYTE),
                  NOR_CMD_DATA_READ_RESET);
      }
      else
      {
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_FIRST), NOR_CMD_DATA_FIRST);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_SECOND), NOR_CMD_DATA_SECOND);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_THIRD),
                  NOR_CMD_DATA_READ_RESET);
      }
    }
    else if (hnor->CommandSet == NOR_INTEL_SHARP_EXT_COMMAND_SET)
    {
      NOR_WRITE(deviceaddress, NOR_CMD_READ_ARRAY);
    }
    else
    {
      /* Primary command set not supported by the driver */
      status = HAL_ERROR;
    }

    if (status != HAL_ERROR)
    {
      /* Read buffer */
      while (size > 0U)
      {
        *data = FMC_MEMORY_READ16(address);
        data++;
        address += 2U;
        size--;
      }
    }

    /* Check the NOR controller state */
    hnor->State = state;

    /* Process unlocked */
    __HAL_UNLOCK(hnor);
  }
  else
  {
    return HAL_ERROR;
  }

  return status;
}

HAL_StatusTypeDef HAL_NOR_ProgramBuffer(NOR_HandleTypeDef *hnor, uint32_t uwAddress, uint16_t *pData,
                                        uint32_t uwBufferSize)
{
  uint16_t *p_currentaddress;
  const uint16_t *p_endaddress;
  uint16_t *data = pData;
  uint32_t deviceaddress;
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the NOR controller state */
  if (hnor->State == HAL_NOR_STATE_BUSY)
  {
    return HAL_BUSY;
  }
  else if (hnor->State == HAL_NOR_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hnor);

    /* Update the NOR controller state */
    hnor->State = HAL_NOR_STATE_BUSY;

    /* Select the NOR device address */
    if (hnor->Init.NSBank == FMC_NORSRAM_BANK1)
    {
      deviceaddress = NOR_MEMORY_ADRESS1;
    }
    else if (hnor->Init.NSBank == FMC_NORSRAM_BANK2)
    {
      deviceaddress = NOR_MEMORY_ADRESS2;
    }
    else if (hnor->Init.NSBank == FMC_NORSRAM_BANK3)
    {
      deviceaddress = NOR_MEMORY_ADRESS3;
    }
    else /* FMC_NORSRAM_BANK4 */
    {
      deviceaddress = NOR_MEMORY_ADRESS4;
    }

    /* Initialize variables */
    p_currentaddress  = (uint16_t *)(uintptr_t)(deviceaddress + uwAddress);
    p_endaddress      = (uint16_t *)(uintptr_t)(deviceaddress + uwAddress + (2U * (uwBufferSize - 1U)));

    if (hnor->CommandSet == NOR_AMD_FUJITSU_COMMAND_SET)
    {
      if (uwNORMemoryDataWidth == NOR_MEMORY_8B)
      {
        /* Issue unlock command sequence */
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_FIRST_BYTE),
                  NOR_CMD_DATA_FIRST);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_SECOND_BYTE),
                  NOR_CMD_DATA_SECOND);
      }
      else
      {
        /* Issue unlock command sequence */
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_FIRST), NOR_CMD_DATA_FIRST);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_SECOND), NOR_CMD_DATA_SECOND);
      }
      /* Write Buffer Load Command */
      NOR_WRITE((deviceaddress + uwAddress), NOR_CMD_DATA_BUFFER_AND_PROG);
      NOR_WRITE((deviceaddress + uwAddress), (uint16_t)(uwBufferSize - 1U));
    }
    else if (hnor->CommandSet == NOR_INTEL_SHARP_EXT_COMMAND_SET)
    {
      /* Write Buffer Load Command */
      NOR_WRITE((deviceaddress + uwAddress), NOR_CMD_BUFFERED_PROGRAM);
      NOR_WRITE((deviceaddress + uwAddress), (uint16_t)(uwBufferSize - 1U));
    }
    else
    {
      /* Primary command set not supported by the driver */
      status = HAL_ERROR;
    }

    if (status != HAL_ERROR)
    {
      /* Load Data into NOR Buffer */
      while (p_currentaddress <= p_endaddress)
      {
        NOR_WRITE(p_currentaddress, *data);

        data++;
        p_currentaddress ++;
      }

      if (hnor->CommandSet == NOR_AMD_FUJITSU_COMMAND_SET)
      {
        NOR_WRITE((deviceaddress + uwAddress), NOR_CMD_DATA_BUFFER_AND_PROG_CONFIRM);
      }
      else /* => hnor->CommandSet == NOR_INTEL_SHARP_EXT_COMMAND_SET */
      {
        NOR_WRITE((deviceaddress + uwAddress), NOR_CMD_CONFIRM);
      }
    }

    /* Check the NOR controller state */
    hnor->State = HAL_NOR_STATE_READY;

    /* Process unlocked */
    __HAL_UNLOCK(hnor);
  }
  else
  {
    return HAL_ERROR;
  }

  return status;

}

HAL_StatusTypeDef HAL_NOR_Erase_Block(NOR_HandleTypeDef *hnor, uint32_t BlockAddress, uint32_t Address)
{
  uint32_t deviceaddress;
  HAL_StatusTypeDef status = HAL_OK;

  /* Check the NOR controller state */
  if (hnor->State == HAL_NOR_STATE_BUSY)
  {
    return HAL_BUSY;
  }
  else if (hnor->State == HAL_NOR_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hnor);

    /* Update the NOR controller state */
    hnor->State = HAL_NOR_STATE_BUSY;

    /* Select the NOR device address */
    if (hnor->Init.NSBank == FMC_NORSRAM_BANK1)
    {
      deviceaddress = NOR_MEMORY_ADRESS1;
    }
    else if (hnor->Init.NSBank == FMC_NORSRAM_BANK2)
    {
      deviceaddress = NOR_MEMORY_ADRESS2;
    }
    else if (hnor->Init.NSBank == FMC_NORSRAM_BANK3)
    {
      deviceaddress = NOR_MEMORY_ADRESS3;
    }
    else /* FMC_NORSRAM_BANK4 */
    {
      deviceaddress = NOR_MEMORY_ADRESS4;
    }

    /* Send block erase command sequence */
    if (hnor->CommandSet == NOR_AMD_FUJITSU_COMMAND_SET)
    {
      if (uwNORMemoryDataWidth == NOR_MEMORY_8B)
      {
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_FIRST_BYTE),
                  NOR_CMD_DATA_FIRST);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_SECOND_BYTE),
                  NOR_CMD_DATA_SECOND);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_THIRD_BYTE),
                  NOR_CMD_DATA_CHIP_BLOCK_ERASE_THIRD);
      }
      else
      {
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_FIRST), NOR_CMD_DATA_FIRST);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_SECOND), NOR_CMD_DATA_SECOND);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_THIRD),
                  NOR_CMD_DATA_CHIP_BLOCK_ERASE_THIRD);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_FOURTH),
                  NOR_CMD_DATA_CHIP_BLOCK_ERASE_FOURTH);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_FIFTH),
                  NOR_CMD_DATA_CHIP_BLOCK_ERASE_FIFTH);
      }
      NOR_WRITE((uint32_t)(BlockAddress + Address), NOR_CMD_DATA_BLOCK_ERASE);
    }
    else if (hnor->CommandSet == NOR_INTEL_SHARP_EXT_COMMAND_SET)
    {
      NOR_WRITE((BlockAddress + Address), NOR_CMD_BLOCK_UNLOCK);
      NOR_WRITE((BlockAddress + Address), NOR_CMD_CONFIRM);
      NOR_WRITE((BlockAddress + Address), NOR_CMD_BLOCK_ERASE);
      NOR_WRITE((BlockAddress + Address), NOR_CMD_CONFIRM);
    }
    else
    {
      /* Primary command set not supported by the driver */
      status = HAL_ERROR;
    }

    /* Check the NOR memory status and update the controller state */
    hnor->State = HAL_NOR_STATE_READY;

    /* Process unlocked */
    __HAL_UNLOCK(hnor);
  }
  else
  {
    return HAL_ERROR;
  }

  return status;

}

HAL_StatusTypeDef HAL_NOR_Erase_Chip(NOR_HandleTypeDef *hnor, uint32_t Address)
{
  uint32_t deviceaddress;
  HAL_StatusTypeDef status = HAL_OK;
  UNUSED(Address);

  /* Check the NOR controller state */
  if (hnor->State == HAL_NOR_STATE_BUSY)
  {
    return HAL_BUSY;
  }
  else if (hnor->State == HAL_NOR_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hnor);

    /* Update the NOR controller state */
    hnor->State = HAL_NOR_STATE_BUSY;

    /* Select the NOR device address */
    if (hnor->Init.NSBank == FMC_NORSRAM_BANK1)
    {
      deviceaddress = NOR_MEMORY_ADRESS1;
    }
    else if (hnor->Init.NSBank == FMC_NORSRAM_BANK2)
    {
      deviceaddress = NOR_MEMORY_ADRESS2;
    }
    else if (hnor->Init.NSBank == FMC_NORSRAM_BANK3)
    {
      deviceaddress = NOR_MEMORY_ADRESS3;
    }
    else /* FMC_NORSRAM_BANK4 */
    {
      deviceaddress = NOR_MEMORY_ADRESS4;
    }

    /* Send NOR chip erase command sequence */
    if (hnor->CommandSet == NOR_AMD_FUJITSU_COMMAND_SET)
    {
      if (uwNORMemoryDataWidth == NOR_MEMORY_8B)
      {
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_FIRST_BYTE),
                  NOR_CMD_DATA_FIRST);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_SECOND_BYTE),
                  NOR_CMD_DATA_SECOND);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_THIRD_BYTE),
                  NOR_CMD_DATA_CHIP_BLOCK_ERASE_THIRD);
      }
      else
      {
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_FIRST), NOR_CMD_DATA_FIRST);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_SECOND), NOR_CMD_DATA_SECOND);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_THIRD),
                  NOR_CMD_DATA_CHIP_BLOCK_ERASE_THIRD);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_FOURTH),
                  NOR_CMD_DATA_CHIP_BLOCK_ERASE_FOURTH);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_FIFTH),
                  NOR_CMD_DATA_CHIP_BLOCK_ERASE_FIFTH);
        NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_SIXTH),
                  NOR_CMD_DATA_CHIP_ERASE);
      }
    }
    else
    {
      /* Primary command set not supported by the driver */
      status = HAL_ERROR;
    }

    /* Check the NOR memory status and update the controller state */
    hnor->State = HAL_NOR_STATE_READY;

    /* Process unlocked */
    __HAL_UNLOCK(hnor);
  }
  else
  {
    return HAL_ERROR;
  }

  return status;
}

HAL_StatusTypeDef HAL_NOR_Read_CFI(NOR_HandleTypeDef *hnor, NOR_CFITypeDef *pNOR_CFI)
{
  uint32_t deviceaddress;
  HAL_NOR_StateTypeDef state;

  /* Check the NOR controller state */
  state = hnor->State;
  if (state == HAL_NOR_STATE_BUSY)
  {
    return HAL_BUSY;
  }
  else if (state == HAL_NOR_STATE_PROTECTED)
  {
    return HAL_ERROR;
  }
  else if (state == HAL_NOR_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hnor);

    /* Update the NOR controller state */
    hnor->State = HAL_NOR_STATE_BUSY;

    /* Select the NOR device address */
    if (hnor->Init.NSBank == FMC_NORSRAM_BANK1)
    {
      deviceaddress = NOR_MEMORY_ADRESS1;
    }
    else if (hnor->Init.NSBank == FMC_NORSRAM_BANK2)
    {
      deviceaddress = NOR_MEMORY_ADRESS2;
    }
    else if (hnor->Init.NSBank == FMC_NORSRAM_BANK3)
    {
      deviceaddress = NOR_MEMORY_ADRESS3;
    }
    else /* FMC_NORSRAM_BANK4 */
    {
      deviceaddress = NOR_MEMORY_ADRESS4;
    }

    /* Send read CFI query command */
    if (uwNORMemoryDataWidth == NOR_MEMORY_8B)
    {
      NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_FIRST_CFI_BYTE),
                NOR_CMD_DATA_CFI);
    }
    else
    {
      NOR_WRITE(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, NOR_CMD_ADDRESS_FIRST_CFI), NOR_CMD_DATA_CFI);
    }
    /* read the NOR CFI information */
    pNOR_CFI->CFI_1 = FMC_MEMORY_READ16(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, CFI1_ADDRESS));
    pNOR_CFI->CFI_2 = FMC_MEMORY_READ16(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, CFI2_ADDRESS));
    pNOR_CFI->CFI_3 = FMC_MEMORY_READ16(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, CFI3_ADDRESS));
    pNOR_CFI->CFI_4 = FMC_MEMORY_READ16(NOR_ADDR_SHIFT(deviceaddress, uwNORMemoryDataWidth, CFI4_ADDRESS));

    /* Check the NOR controller state */
    hnor->State = state;

    /* Process unlocked */
    __HAL_UNLOCK(hnor);
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

#if USE_HAL_NOR_REGISTER_CALLBACKS
HAL_StatusTypeDef HAL_NOR_RegisterCallback(NOR_HandleTypeDef *hnor, HAL_NOR_CallbackIDTypeDef CallbackId,
                                           pNOR_CallbackTypeDef pCallback)
{
  HAL_StatusTypeDef status = HAL_OK;
  HAL_NOR_StateTypeDef state;

  if (pCallback == NULL)
  {
    return HAL_ERROR;
  }

  state = hnor->State;
  if ((state == HAL_NOR_STATE_READY) || (state == HAL_NOR_STATE_RESET) || (state == HAL_NOR_STATE_PROTECTED))
  {
    switch (CallbackId)
    {
      case HAL_NOR_MSP_INIT_CB_ID :
        hnor->MspInitCallback = pCallback;
        break;
      case HAL_NOR_MSP_DEINIT_CB_ID :
        hnor->MspDeInitCallback = pCallback;
        break;
      default :
        /* update return status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* update return status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif

#if USE_HAL_NOR_REGISTER_CALLBACKS
HAL_StatusTypeDef HAL_NOR_UnRegisterCallback(NOR_HandleTypeDef *hnor, HAL_NOR_CallbackIDTypeDef CallbackId)
{
  HAL_StatusTypeDef status = HAL_OK;
  HAL_NOR_StateTypeDef state;

  state = hnor->State;
  if ((state == HAL_NOR_STATE_READY) || (state == HAL_NOR_STATE_RESET) || (state == HAL_NOR_STATE_PROTECTED))
  {
    switch (CallbackId)
    {
      case HAL_NOR_MSP_INIT_CB_ID :
        hnor->MspInitCallback = HAL_NOR_MspInit;
        break;
      case HAL_NOR_MSP_DEINIT_CB_ID :
        hnor->MspDeInitCallback = HAL_NOR_MspDeInit;
        break;
      default :
        /* update return status */
        status =  HAL_ERROR;
        break;
    }
  }
  else
  {
    /* update return status */
    status =  HAL_ERROR;
  }

  return status;
}
#endif

HAL_StatusTypeDef HAL_NOR_WriteOperation_Enable(NOR_HandleTypeDef *hnor)
{
  /* Check the NOR controller state */
  if (hnor->State == HAL_NOR_STATE_PROTECTED)
  {
    /* Process Locked */
    __HAL_LOCK(hnor);

    /* Update the NOR controller state */
    hnor->State = HAL_NOR_STATE_BUSY;

    /* Enable write operation */
    (void)FMC_NORSRAM_WriteOperation_Enable(hnor->Instance, hnor->Init.NSBank);

    /* Update the NOR controller state */
    hnor->State = HAL_NOR_STATE_READY;

    /* Process unlocked */
    __HAL_UNLOCK(hnor);
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_StatusTypeDef HAL_NOR_WriteOperation_Disable(NOR_HandleTypeDef *hnor)
{
  /* Check the NOR controller state */
  if (hnor->State == HAL_NOR_STATE_READY)
  {
    /* Process Locked */
    __HAL_LOCK(hnor);

    /* Update the NOR controller state */
    hnor->State = HAL_NOR_STATE_BUSY;

    /* Disable write operation */
    (void)FMC_NORSRAM_WriteOperation_Disable(hnor->Instance, hnor->Init.NSBank);

    /* Update the NOR controller state */
    hnor->State = HAL_NOR_STATE_PROTECTED;

    /* Process unlocked */
    __HAL_UNLOCK(hnor);
  }
  else
  {
    return HAL_ERROR;
  }

  return HAL_OK;
}

HAL_NOR_StateTypeDef HAL_NOR_GetState(const NOR_HandleTypeDef *hnor)
{
  return hnor->State;
}

HAL_NOR_StatusTypeDef HAL_NOR_GetStatus(NOR_HandleTypeDef *hnor, uint32_t Address, uint32_t Timeout)
{
  HAL_NOR_StatusTypeDef status = HAL_NOR_STATUS_ONGOING;
  uint16_t tmpsr1;
  uint16_t tmpsr2;
  uint32_t tickstart;

  /* Poll on NOR memory Ready/Busy signal ------------------------------------*/
  HAL_NOR_MspWait(hnor, Timeout);

  /* Get the NOR memory operation status -------------------------------------*/

  /* Get tick */
  tickstart = HAL_GetTick();

  if (hnor->CommandSet == NOR_AMD_FUJITSU_COMMAND_SET)
  {
    while ((status != HAL_NOR_STATUS_SUCCESS) && (status != HAL_NOR_STATUS_TIMEOUT))
    {
      /* Check for the Timeout */
      if (Timeout != HAL_MAX_DELAY)
      {
        if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
        {
          status = HAL_NOR_STATUS_TIMEOUT;
        }
      }

      /* Read NOR status register (DQ6 and DQ5) */
      tmpsr1 = FMC_MEMORY_READ16(Address);
      tmpsr2 = FMC_MEMORY_READ16(Address);

      /* If DQ6 did not toggle between the two reads then return HAL_NOR_STATUS_SUCCESS  */
      if ((tmpsr1 & NOR_MASK_STATUS_DQ6) == (tmpsr2 & NOR_MASK_STATUS_DQ6))
      {
        return HAL_NOR_STATUS_SUCCESS ;
      }

      if ((tmpsr1 & NOR_MASK_STATUS_DQ5) == NOR_MASK_STATUS_DQ5)
      {
        status = HAL_NOR_STATUS_ONGOING;
      }

      tmpsr1 = FMC_MEMORY_READ16(Address);
      tmpsr2 = FMC_MEMORY_READ16(Address);

      /* If DQ6 did not toggle between the two reads then return HAL_NOR_STATUS_SUCCESS  */
      if ((tmpsr1 & NOR_MASK_STATUS_DQ6) == (tmpsr2 & NOR_MASK_STATUS_DQ6))
      {
        return HAL_NOR_STATUS_SUCCESS;
      }
      if ((tmpsr1 & NOR_MASK_STATUS_DQ5) == NOR_MASK_STATUS_DQ5)
      {
        return HAL_NOR_STATUS_ERROR;
      }
    }
  }
  else if (hnor->CommandSet == NOR_INTEL_SHARP_EXT_COMMAND_SET)
  {
    do
    {
      NOR_WRITE(Address, NOR_CMD_READ_STATUS_REG);
      tmpsr2 = FMC_MEMORY_READ16((Address));

      /* Check for the Timeout */
      if (Timeout != HAL_MAX_DELAY)
      {
        if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
        {
          return HAL_NOR_STATUS_TIMEOUT;
        }
      }
    } while ((tmpsr2 & NOR_MASK_STATUS_DQ7) == 0U);

    NOR_WRITE(Address, NOR_CMD_READ_STATUS_REG);
    tmpsr1 = FMC_MEMORY_READ16((Address));
    if ((tmpsr1  & (NOR_MASK_STATUS_DQ5 | NOR_MASK_STATUS_DQ4)) != 0U)
    {
      /* Clear the Status Register  */
      NOR_WRITE(Address, NOR_CMD_READ_STATUS_REG);
      status = HAL_NOR_STATUS_ERROR;
    }
    else
    {
      status = HAL_NOR_STATUS_SUCCESS;
    }
  }
  else
  {
    /* Primary command set not supported by the driver */
    status = HAL_NOR_STATUS_ERROR;
  }

  /* Return the operation status */
  return status;
}
