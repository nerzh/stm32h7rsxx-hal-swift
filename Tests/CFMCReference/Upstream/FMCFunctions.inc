// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// FMC operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

HAL_StatusTypeDef  FMC_NORSRAM_Init(FMC_NORSRAM_TypeDef *Device,
                                    const FMC_NORSRAM_InitTypeDef *Init)
{
  uint32_t flashaccess;
  uint32_t btcr_reg;
  uint32_t mask;

  /* Check the parameters */
  assert_param(IS_FMC_NORSRAM_DEVICE(Device));
  assert_param(IS_FMC_NORSRAM_BANK(Init->NSBank));
  assert_param(IS_FMC_MUX(Init->DataAddressMux));
  assert_param(IS_FMC_MEMORY(Init->MemoryType));
  assert_param(IS_FMC_NORSRAM_MEMORY_WIDTH(Init->MemoryDataWidth));
  assert_param(IS_FMC_BURSTMODE(Init->BurstAccessMode));
  assert_param(IS_FMC_WAIT_POLARITY(Init->WaitSignalPolarity));
  assert_param(IS_FMC_WAIT_SIGNAL_ACTIVE(Init->WaitSignalActive));
  assert_param(IS_FMC_WRITE_OPERATION(Init->WriteOperation));
  assert_param(IS_FMC_WAITE_SIGNAL(Init->WaitSignal));
  assert_param(IS_FMC_EXTENDED_MODE(Init->ExtendedMode));
  assert_param(IS_FMC_ASYNWAIT(Init->AsynchronousWait));
  assert_param(IS_FMC_WRITE_BURST(Init->WriteBurst));
  assert_param(IS_FMC_CONTINOUS_CLOCK(Init->ContinuousClock));
  assert_param(IS_FMC_WRITE_FIFO(Init->WriteFifo));
  assert_param(IS_FMC_PAGESIZE(Init->PageSize));

  /* Disable NORSRAM Device */
  __FMC_NORSRAM_DISABLE(Device, Init->NSBank);

  /* Set NORSRAM device control parameters */
  if (Init->MemoryType == FMC_MEMORY_TYPE_NOR)
  {
    flashaccess = FMC_NORSRAM_FLASH_ACCESS_ENABLE;
  }
  else
  {
    flashaccess = FMC_NORSRAM_FLASH_ACCESS_DISABLE;
  }

  btcr_reg = (flashaccess                   | \
              Init->DataAddressMux          | \
              Init->MemoryType              | \
              Init->MemoryDataWidth         | \
              Init->BurstAccessMode         | \
              Init->WaitSignalPolarity      | \
              Init->WaitSignalActive        | \
              Init->WriteOperation          | \
              Init->WaitSignal              | \
              Init->ExtendedMode            | \
              Init->AsynchronousWait        | \
              Init->WriteBurst);

  btcr_reg |= Init->ContinuousClock;
  btcr_reg |= Init->WriteFifo;
  btcr_reg |= Init->PageSize;

  mask = (FMC_BCRx_MBKEN                |
          FMC_BCRx_MUXEN                |
          FMC_BCRx_MTYP                 |
          FMC_BCRx_MWID                 |
          FMC_BCRx_FACCEN               |
          FMC_BCRx_BURSTEN              |
          FMC_BCRx_WAITPOL              |
          FMC_BCRx_WAITCFG              |
          FMC_BCRx_WREN                 |
          FMC_BCRx_WAITEN               |
          FMC_BCRx_EXTMOD               |
          FMC_BCRx_ASYNCWAIT            |
          FMC_BCRx_CBURSTRW);

  mask |= FMC_BCR1_CCLKEN;
  mask |= FMC_BCR1_WFDIS;
  mask |= FMC_BCRx_CPSIZE;

  MODIFY_REG(Device->BTCR[Init->NSBank], mask, btcr_reg);

  /* Configure synchronous mode when Continuous clock is enabled for bank2..4 */
  if ((Init->ContinuousClock == FMC_CONTINUOUS_CLOCK_SYNC_ASYNC) && (Init->NSBank != FMC_NORSRAM_BANK1))
  {
    MODIFY_REG(Device->BTCR[FMC_NORSRAM_BANK1], FMC_BCR1_CCLKEN, Init->ContinuousClock);
  }

  if (Init->NSBank != FMC_NORSRAM_BANK1)
  {
    /* Configure Write FIFO mode when Write Fifo is enabled for bank2..4 */
    SET_BIT(Device->BTCR[FMC_NORSRAM_BANK1], (uint32_t)(Init->WriteFifo));
  }

  return HAL_OK;
}

HAL_StatusTypeDef FMC_NORSRAM_DeInit(FMC_NORSRAM_TypeDef *Device,
                                     FMC_NORSRAM_EXTENDED_TypeDef *ExDevice, uint32_t Bank)
{
  /* Check the parameters */
  assert_param(IS_FMC_NORSRAM_DEVICE(Device));
  assert_param(IS_FMC_NORSRAM_EXTENDED_DEVICE(ExDevice));
  assert_param(IS_FMC_NORSRAM_BANK(Bank));

  /* Disable the FMC_NORSRAM device */
  __FMC_NORSRAM_DISABLE(Device, Bank);

  /* De-initialize the FMC_NORSRAM device */
  /* FMC_NORSRAM_BANK1 */
  if (Bank == FMC_NORSRAM_BANK1)
  {
    Device->BTCR[Bank] = 0x000030DBU;
  }
  /* FMC_NORSRAM_BANK2, FMC_NORSRAM_BANK3 or FMC_NORSRAM_BANK4 */
  else
  {
    Device->BTCR[Bank] = 0x000030D2U;
  }

  Device->BTCR[Bank + 1U] = 0x0FFFFFFFU;
  ExDevice->BWTR[Bank]   = 0x0FFFFFFFU;

  return HAL_OK;
}

HAL_StatusTypeDef FMC_NORSRAM_Timing_Init(FMC_NORSRAM_TypeDef *Device,
                                          const FMC_NORSRAM_TimingTypeDef *Timing, uint32_t Bank)
{
  uint32_t tmpr;

  /* Check the parameters */
  assert_param(IS_FMC_NORSRAM_DEVICE(Device));
  assert_param(IS_FMC_ADDRESS_SETUP_TIME(Timing->AddressSetupTime));
  assert_param(IS_FMC_ADDRESS_HOLD_TIME(Timing->AddressHoldTime));
  assert_param(IS_FMC_DATASETUP_TIME(Timing->DataSetupTime));
  assert_param(IS_FMC_TURNAROUND_TIME(Timing->BusTurnAroundDuration));
  assert_param(IS_FMC_CLK_DIV(Timing->CLKDivision));
  assert_param(IS_FMC_DATA_LATENCY(Timing->DataLatency));
  assert_param(IS_FMC_ACCESS_MODE(Timing->AccessMode));
  assert_param(IS_FMC_NORSRAM_BANK(Bank));

  /* Set FMC_NORSRAM device timing parameters */
  Device->BTCR[Bank + 1U] =
    (Timing->AddressSetupTime << FMC_BTRx_ADDSET_Pos) |
    (Timing->AddressHoldTime << FMC_BTRx_ADDHLD_Pos) |
    (Timing->DataSetupTime << FMC_BTRx_DATAST_Pos) |
    (Timing->BusTurnAroundDuration << FMC_BTRx_BUSTURN_Pos) |
    ((Timing->CLKDivision - 1U) << FMC_BTRx_CLKDIV_Pos) |
    ((Timing->DataLatency - 2U) << FMC_BTRx_DATLAT_Pos) |
    Timing->AccessMode;

  /* Configure Clock division value (in NORSRAM bank 1) when continuous clock is enabled */
  if (HAL_IS_BIT_SET(Device->BTCR[FMC_NORSRAM_BANK1], FMC_BCR1_CCLKEN))
  {
    tmpr = (uint32_t)(Device->BTCR[FMC_NORSRAM_BANK1 + 1U] & ~((0x0FUL) << FMC_BTRx_CLKDIV_Pos));
    tmpr |= (uint32_t)(((Timing->CLKDivision) - 1U) << FMC_BTRx_CLKDIV_Pos);
    MODIFY_REG(Device->BTCR[FMC_NORSRAM_BANK1 + 1U], FMC_BTRx_CLKDIV, tmpr);
  }

  return HAL_OK;
}

HAL_StatusTypeDef FMC_NORSRAM_Extended_Timing_Init(FMC_NORSRAM_EXTENDED_TypeDef *Device,
                                                   const FMC_NORSRAM_TimingTypeDef *Timing, uint32_t Bank,
                                                   uint32_t ExtendedMode)
{
  /* Check the parameters */
  assert_param(IS_FMC_EXTENDED_MODE(ExtendedMode));

  /* Set NORSRAM device timing register for write configuration, if extended mode is used */
  if (ExtendedMode == FMC_EXTENDED_MODE_ENABLE)
  {
    /* Check the parameters */
    assert_param(IS_FMC_NORSRAM_EXTENDED_DEVICE(Device));
    assert_param(IS_FMC_ADDRESS_SETUP_TIME(Timing->AddressSetupTime));
    assert_param(IS_FMC_ADDRESS_HOLD_TIME(Timing->AddressHoldTime));
    assert_param(IS_FMC_DATASETUP_TIME(Timing->DataSetupTime));
#if defined(FMC_BWTRx_BUSTURN)
    assert_param(IS_FMC_TURNAROUND_TIME(Timing->BusTurnAroundDuration));
#endif /* FMC_BWTRx_BUSTURN */
    assert_param(IS_FMC_ACCESS_MODE(Timing->AccessMode));
    assert_param(IS_FMC_NORSRAM_BANK(Bank));

    /* Set NORSRAM device timing register for write configuration, if extended mode is used */
#if defined(FMC_BWTRx_BUSTURN)
    MODIFY_REG(Device->BWTR[Bank], BWTR_CLEAR_MASK, (Timing->AddressSetupTime                                    |
                                                     ((Timing->AddressHoldTime)        << FMC_BWTRx_ADDHLD_Pos)  |
                                                     ((Timing->DataSetupTime)          << FMC_BWTRx_DATAST_Pos)  |
                                                     Timing->AccessMode                                          |
                                                     ((Timing->BusTurnAroundDuration)  << FMC_BWTRx_BUSTURN_Pos)));
#else /* FMC_BWTRx_BUSTURN */
    MODIFY_REG(Device->BWTR[Bank], BWTR_CLEAR_MASK, (Timing->AddressSetupTime                                    |
                                                     ((Timing->AddressHoldTime)        << FMC_BWTRx_ADDHLD_Pos)  |
                                                     ((Timing->DataSetupTime)          << FMC_BWTRx_DATAST_Pos)  |
                                                     Timing->AccessMode));
#endif /* FMC_BWTRx_BUSTURN */
  }
  else
  {
    Device->BWTR[Bank] = 0x0FFFFFFFU;
  }

  return HAL_OK;
}

HAL_StatusTypeDef FMC_NORSRAM_WriteOperation_Enable(FMC_NORSRAM_TypeDef *Device, uint32_t Bank)
{
  /* Check the parameters */
  assert_param(IS_FMC_NORSRAM_DEVICE(Device));
  assert_param(IS_FMC_NORSRAM_BANK(Bank));

  /* Enable write operation */
  SET_BIT(Device->BTCR[Bank], FMC_WRITE_OPERATION_ENABLE);

  return HAL_OK;
}

HAL_StatusTypeDef FMC_NORSRAM_WriteOperation_Disable(FMC_NORSRAM_TypeDef *Device, uint32_t Bank)
{
  /* Check the parameters */
  assert_param(IS_FMC_NORSRAM_DEVICE(Device));
  assert_param(IS_FMC_NORSRAM_BANK(Bank));

  /* Disable write operation */
  CLEAR_BIT(Device->BTCR[Bank], FMC_WRITE_OPERATION_ENABLE);

  return HAL_OK;
}

HAL_StatusTypeDef FMC_NAND_Init(FMC_NAND_TypeDef *Device, const FMC_NAND_InitTypeDef *Init)
{
  /* Check the parameters */
  assert_param(IS_FMC_NAND_DEVICE(Device));
  assert_param(IS_FMC_NAND_BANK(Init->NandBank));
  assert_param(IS_FMC_WAIT_FEATURE(Init->Waitfeature));
  assert_param(IS_FMC_NAND_MEMORY_WIDTH(Init->MemoryDataWidth));
  assert_param(IS_FMC_ECC_STATE(Init->EccComputation));
  assert_param(IS_FMC_ECCPAGE_SIZE(Init->ECCPageSize));
  assert_param(IS_FMC_TCLR_TIME(Init->TCLRSetupTime));
  assert_param(IS_FMC_TAR_TIME(Init->TARSetupTime));

  /* NAND bank 3 registers configuration */
  MODIFY_REG(Device->PCR, PCR_CLEAR_MASK, (Init->Waitfeature                            |
                                           FMC_PCR_MEMORY_TYPE_NAND                     |
                                           Init->MemoryDataWidth                        |
                                           Init->EccComputation                         |
                                           Init->ECCPageSize                            |
                                           ((Init->TCLRSetupTime) << FMC_PCR_TCLR_Pos)  |
                                           ((Init->TARSetupTime)  << FMC_PCR_TAR_Pos)));

  return HAL_OK;
}

HAL_StatusTypeDef FMC_NAND_CommonSpace_Timing_Init(FMC_NAND_TypeDef *Device,
                                                   const FMC_NAND_PCC_TimingTypeDef *Timing, uint32_t Bank)
{
  /* Check the parameters */
  assert_param(IS_FMC_NAND_DEVICE(Device));
  assert_param(IS_FMC_SETUP_TIME(Timing->SetupTime));
  assert_param(IS_FMC_WAIT_TIME(Timing->WaitSetupTime));
  assert_param(IS_FMC_HOLD_TIME(Timing->HoldSetupTime));
  assert_param(IS_FMC_HIZ_TIME(Timing->HiZSetupTime));
  assert_param(IS_FMC_NAND_BANK(Bank));

  /* Prevent unused argument(s) compilation warning if no assert_param check */
  UNUSED(Bank);

  /* NAND bank 3 registers configuration */
  Device->PMEM = (Timing->SetupTime |
                  ((Timing->WaitSetupTime) << FMC_PMEM_MEMWAIT_Pos) |
                  ((Timing->HoldSetupTime) << FMC_PMEM_MEMHOLD_Pos) |
                  ((Timing->HiZSetupTime) << FMC_PMEM_MEMHIZ_Pos));

  return HAL_OK;
}

HAL_StatusTypeDef FMC_NAND_AttributeSpace_Timing_Init(FMC_NAND_TypeDef *Device,
                                                      const FMC_NAND_PCC_TimingTypeDef *Timing, uint32_t Bank)
{
  /* Check the parameters */
  assert_param(IS_FMC_NAND_DEVICE(Device));
  assert_param(IS_FMC_SETUP_TIME(Timing->SetupTime));
  assert_param(IS_FMC_WAIT_TIME(Timing->WaitSetupTime));
  assert_param(IS_FMC_HOLD_TIME(Timing->HoldSetupTime));
  assert_param(IS_FMC_HIZ_TIME(Timing->HiZSetupTime));
  assert_param(IS_FMC_NAND_BANK(Bank));

  /* Prevent unused argument(s) compilation warning if no assert_param check */
  UNUSED(Bank);

  /* NAND bank 3 registers configuration */
  Device->PATT = (Timing->SetupTime |
                  ((Timing->WaitSetupTime) << FMC_PATT_ATTWAIT_Pos) |
                  ((Timing->HoldSetupTime) << FMC_PATT_ATTHOLD_Pos) |
                  ((Timing->HiZSetupTime)  << FMC_PATT_ATTHIZ_Pos));

  return HAL_OK;
}

HAL_StatusTypeDef FMC_NAND_DeInit(FMC_NAND_TypeDef *Device, uint32_t Bank)
{
  /* Check the parameters */
  assert_param(IS_FMC_NAND_DEVICE(Device));
  assert_param(IS_FMC_NAND_BANK(Bank));

  /* Disable the NAND Bank */
  __FMC_NAND_DISABLE(Device, Bank);

  /* De-initialize the NAND Bank */
  /* Prevent unused argument(s) compilation warning if no assert_param check */
  UNUSED(Bank);

  /* Set the FMC_NAND_BANK3 registers to their reset values */
  WRITE_REG(Device->PCR,  0x00000018U);
  WRITE_REG(Device->SR,   0x00000040U);
  WRITE_REG(Device->PMEM, 0xFCFCFCFCU);
  WRITE_REG(Device->PATT, 0xFCFCFCFCU);

  return HAL_OK;
}

HAL_StatusTypeDef FMC_NAND_ECC_Enable(FMC_NAND_TypeDef *Device, uint32_t Bank)
{
  /* Check the parameters */
  assert_param(IS_FMC_NAND_DEVICE(Device));
  assert_param(IS_FMC_NAND_BANK(Bank));

  /* Enable ECC feature */
  /* Prevent unused argument(s) compilation warning if no assert_param check */
  UNUSED(Bank);

  SET_BIT(Device->PCR, FMC_PCR_ECCEN);

  return HAL_OK;
}

HAL_StatusTypeDef FMC_NAND_ECC_Disable(FMC_NAND_TypeDef *Device, uint32_t Bank)
{
  /* Check the parameters */
  assert_param(IS_FMC_NAND_DEVICE(Device));
  assert_param(IS_FMC_NAND_BANK(Bank));

  /* Disable ECC feature */
  /* Prevent unused argument(s) compilation warning if no assert_param check */
  UNUSED(Bank);

  CLEAR_BIT(Device->PCR, FMC_PCR_ECCEN);

  return HAL_OK;
}

HAL_StatusTypeDef FMC_NAND_GetECC(const FMC_NAND_TypeDef *Device, uint32_t *ECCval, uint32_t Bank,
                                  uint32_t Timeout)
{
  uint32_t tickstart;

  /* Check the parameters */
  assert_param(IS_FMC_NAND_DEVICE(Device));
  assert_param(IS_FMC_NAND_BANK(Bank));

  /* Get tick */
  tickstart = HAL_GetTick();

  /* Wait until FIFO is empty */
  while (__FMC_NAND_GET_FLAG(Device, Bank, FMC_FLAG_FEMPT) == RESET)
  {
    /* Check for the Timeout */
    if (Timeout != HAL_MAX_DELAY)
    {
      if (((HAL_GetTick() - tickstart) > Timeout) || (Timeout == 0U))
      {
        return HAL_TIMEOUT;
      }
    }
  }

  /* Prevent unused argument(s) compilation warning if no assert_param check */
  UNUSED(Bank);

  /* Get the ECCR register value */
  *ECCval = (uint32_t)Device->ECCR;

  return HAL_OK;
}

HAL_StatusTypeDef FMC_SDRAM_Init(FMC_SDRAM_TypeDef *Device, const FMC_SDRAM_InitTypeDef *Init)
{
  /* Check the parameters */
  assert_param(IS_FMC_SDRAM_DEVICE(Device));
  assert_param(IS_FMC_SDRAM_BANK(Init->SDBank));
  assert_param(IS_FMC_COLUMNBITS_NUMBER(Init->ColumnBitsNumber));
  assert_param(IS_FMC_ROWBITS_NUMBER(Init->RowBitsNumber));
  assert_param(IS_FMC_SDMEMORY_WIDTH(Init->MemoryDataWidth));
  assert_param(IS_FMC_INTERNALBANK_NUMBER(Init->InternalBankNumber));
  assert_param(IS_FMC_CAS_LATENCY(Init->CASLatency));
  assert_param(IS_FMC_WRITE_PROTECTION(Init->WriteProtection));
  assert_param(IS_FMC_SDCLOCK_PERIOD(Init->SDClockPeriod));
  assert_param(IS_FMC_READ_BURST(Init->ReadBurst));
  assert_param(IS_FMC_READPIPE_DELAY(Init->ReadPipeDelay));

  /* Set SDRAM bank configuration parameters */
  if (Init->SDBank == FMC_SDRAM_BANK1)
  {
    MODIFY_REG(Device->SDCR[FMC_SDRAM_BANK1],
               SDCR_CLEAR_MASK,
               (Init->ColumnBitsNumber   |
                Init->RowBitsNumber      |
                Init->MemoryDataWidth    |
                Init->InternalBankNumber |
                Init->CASLatency         |
                Init->WriteProtection    |
                Init->SDClockPeriod      |
                Init->ReadBurst          |
                Init->ReadPipeDelay));
  }
  else /* FMC_Bank2_SDRAM */
  {
    MODIFY_REG(Device->SDCR[FMC_SDRAM_BANK1],
               FMC_SDCRx_SDCLK           |
               FMC_SDCRx_RBURST          |
               FMC_SDCRx_RPIPE,
               (Init->SDClockPeriod      |
                Init->ReadBurst          |
                Init->ReadPipeDelay));

    MODIFY_REG(Device->SDCR[FMC_SDRAM_BANK2],
               SDCR_CLEAR_MASK,
               (Init->ColumnBitsNumber   |
                Init->RowBitsNumber      |
                Init->MemoryDataWidth    |
                Init->InternalBankNumber |
                Init->CASLatency         |
                Init->WriteProtection));
  }

  return HAL_OK;
}

HAL_StatusTypeDef FMC_SDRAM_Timing_Init(FMC_SDRAM_TypeDef *Device,
                                        const FMC_SDRAM_TimingTypeDef *Timing, uint32_t Bank)
{
  /* Check the parameters */
  assert_param(IS_FMC_SDRAM_DEVICE(Device));
  assert_param(IS_FMC_LOADTOACTIVE_DELAY(Timing->LoadToActiveDelay));
  assert_param(IS_FMC_EXITSELFREFRESH_DELAY(Timing->ExitSelfRefreshDelay));
  assert_param(IS_FMC_SELFREFRESH_TIME(Timing->SelfRefreshTime));
  assert_param(IS_FMC_ROWCYCLE_DELAY(Timing->RowCycleDelay));
  assert_param(IS_FMC_WRITE_RECOVERY_TIME(Timing->WriteRecoveryTime));
  assert_param(IS_FMC_RP_DELAY(Timing->RPDelay));
  assert_param(IS_FMC_RCD_DELAY(Timing->RCDDelay));
  assert_param(IS_FMC_SDRAM_BANK(Bank));

  /* Set SDRAM device timing parameters */
  if (Bank == FMC_SDRAM_BANK1)
  {
    MODIFY_REG(Device->SDTR[FMC_SDRAM_BANK1],
               SDTR_CLEAR_MASK,
               (((Timing->LoadToActiveDelay) - 1U)                                      |
                (((Timing->ExitSelfRefreshDelay) - 1U) << FMC_SDTRx_TXSR_Pos) |
                (((Timing->SelfRefreshTime) - 1U)      << FMC_SDTRx_TRAS_Pos) |
                (((Timing->RowCycleDelay) - 1U)        << FMC_SDTRx_TRC_Pos)  |
                (((Timing->WriteRecoveryTime) - 1U)    << FMC_SDTRx_TWR_Pos)  |
                (((Timing->RPDelay) - 1U)              << FMC_SDTRx_TRP_Pos)  |
                (((Timing->RCDDelay) - 1U)             << FMC_SDTRx_TRCD_Pos)));
  }
  else /* FMC_Bank2_SDRAM */
  {
    MODIFY_REG(Device->SDTR[FMC_SDRAM_BANK1],
               FMC_SDTRx_TRC |
               FMC_SDTRx_TRP,
               (((Timing->RowCycleDelay) - 1U)         << FMC_SDTRx_TRC_Pos)  |
               (((Timing->RPDelay) - 1U)               << FMC_SDTRx_TRP_Pos));

    MODIFY_REG(Device->SDTR[FMC_SDRAM_BANK2],
               SDTR_CLEAR_MASK,
               (((Timing->LoadToActiveDelay) - 1U)                                      |
                (((Timing->ExitSelfRefreshDelay) - 1U) << FMC_SDTRx_TXSR_Pos) |
                (((Timing->SelfRefreshTime) - 1U)      << FMC_SDTRx_TRAS_Pos) |
                (((Timing->WriteRecoveryTime) - 1U)    << FMC_SDTRx_TWR_Pos)  |
                (((Timing->RCDDelay) - 1U)             << FMC_SDTRx_TRCD_Pos)));
  }

  return HAL_OK;
}

HAL_StatusTypeDef FMC_SDRAM_DeInit(FMC_SDRAM_TypeDef *Device, uint32_t Bank)
{
  /* Check the parameters */
  assert_param(IS_FMC_SDRAM_DEVICE(Device));
  assert_param(IS_FMC_SDRAM_BANK(Bank));

  /* De-initialize the SDRAM device */
  Device->SDCR[Bank] = 0x000002D0U;
  Device->SDTR[Bank] = 0x0FFFFFFFU;
  Device->SDCMR      = 0x00000000U;
  Device->SDRTR      = 0x00000000U;
  Device->SDSR       = 0x00000000U;

  return HAL_OK;
}

HAL_StatusTypeDef FMC_SDRAM_WriteProtection_Enable(FMC_SDRAM_TypeDef *Device, uint32_t Bank)
{
  /* Check the parameters */
  assert_param(IS_FMC_SDRAM_DEVICE(Device));
  assert_param(IS_FMC_SDRAM_BANK(Bank));

  /* Enable write protection */
  SET_BIT(Device->SDCR[Bank], FMC_SDRAM_WRITE_PROTECTION_ENABLE);

  return HAL_OK;
}

HAL_StatusTypeDef FMC_SDRAM_WriteProtection_Disable(FMC_SDRAM_TypeDef *Device, uint32_t Bank)
{
  /* Check the parameters */
  assert_param(IS_FMC_SDRAM_DEVICE(Device));
  assert_param(IS_FMC_SDRAM_BANK(Bank));

  /* Disable write protection */
  CLEAR_BIT(Device->SDCR[Bank], FMC_SDRAM_WRITE_PROTECTION_ENABLE);

  return HAL_OK;
}

HAL_StatusTypeDef FMC_SDRAM_SendCommand(FMC_SDRAM_TypeDef *Device,
                                        const FMC_SDRAM_CommandTypeDef *Command, uint32_t Timeout)
{
  /* Check the parameters */
  assert_param(IS_FMC_SDRAM_DEVICE(Device));
  assert_param(IS_FMC_COMMAND_MODE(Command->CommandMode));
  assert_param(IS_FMC_COMMAND_TARGET(Command->CommandTarget));
  assert_param(IS_FMC_AUTOREFRESH_NUMBER(Command->AutoRefreshNumber));
  assert_param(IS_FMC_MODE_REGISTER(Command->ModeRegisterDefinition));

  /* Set command register */
  MODIFY_REG(Device->SDCMR, (FMC_SDCMR_MODE | FMC_SDCMR_CTB2 | FMC_SDCMR_CTB1 | FMC_SDCMR_NRFS | FMC_SDCMR_MRD),
             ((Command->CommandMode) | (Command->CommandTarget) |
              (((Command->AutoRefreshNumber) - 1U) << FMC_SDCMR_NRFS_Pos) |
              ((Command->ModeRegisterDefinition) << FMC_SDCMR_MRD_Pos)));
  /* Prevent unused argument(s) compilation warning */
  UNUSED(Timeout);
  return HAL_OK;
}

HAL_StatusTypeDef FMC_SDRAM_ProgramRefreshRate(FMC_SDRAM_TypeDef *Device, uint32_t RefreshRate)
{
  /* Check the parameters */
  assert_param(IS_FMC_SDRAM_DEVICE(Device));
  assert_param(IS_FMC_REFRESH_RATE(RefreshRate));

  /* Set the refresh rate in command register */
  MODIFY_REG(Device->SDRTR, FMC_SDRTR_COUNT, (RefreshRate << FMC_SDRTR_COUNT_Pos));

  return HAL_OK;
}

HAL_StatusTypeDef FMC_SDRAM_SetAutoRefreshNumber(FMC_SDRAM_TypeDef *Device,
                                                 uint32_t AutoRefreshNumber)
{
  /* Check the parameters */
  assert_param(IS_FMC_SDRAM_DEVICE(Device));
  assert_param(IS_FMC_AUTOREFRESH_NUMBER(AutoRefreshNumber));

  /* Set the Auto-refresh number in command register */
  MODIFY_REG(Device->SDCMR, FMC_SDCMR_NRFS, ((AutoRefreshNumber - 1U) << FMC_SDCMR_NRFS_Pos));

  return HAL_OK;
}

uint32_t FMC_SDRAM_GetModeStatus(const FMC_SDRAM_TypeDef *Device, uint32_t Bank)
{
  uint32_t tmpreg;

  /* Check the parameters */
  assert_param(IS_FMC_SDRAM_DEVICE(Device));
  assert_param(IS_FMC_SDRAM_BANK(Bank));

  /* Get the corresponding bank mode */
  if (Bank == FMC_SDRAM_BANK1)
  {
    tmpreg = (uint32_t)(Device->SDSR & FMC_SDSR_MODES1);
  }
  else
  {
    tmpreg = ((uint32_t)(Device->SDSR & FMC_SDSR_MODES2) >> 2U);
  }

  /* Return the mode status */
  return tmpreg;
}
