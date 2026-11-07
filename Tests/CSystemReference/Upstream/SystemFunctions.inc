/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted unchanged from HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
uint32_t HAL_SBS_GetBootAddress(void)
{
  return SBS->BOOTSR;
}

void HAL_SBS_IncrementHDPLValue(void)
{
  MODIFY_REG(SBS->HDPLCR, SBS_HDPLCR_INCR_HDPL, SBS_HDPL_INCREMENT_VALUE);
}

uint32_t HAL_SBS_GetHDPLValue(void)
{
  return (SBS->HDPLSR & SBS_HDPLSR_HDPL);
}

void HAL_SBS_OpenAccessPort(void)
{
  MODIFY_REG(SBS->DBGCR, SBS_DBGCR_AP_UNLOCK, SBS_DEBUG_UNLOCK_VALUE);
}

void HAL_SBS_OpenDebug(void)
{
  MODIFY_REG(SBS->DBGCR, SBS_DBGCR_DBG_UNLOCK, ((uint32_t)SBS_DEBUG_UNLOCK_VALUE << SBS_DBGCR_DBG_UNLOCK_Pos));
}

HAL_StatusTypeDef HAL_SBS_ConfigDebugLevel(uint32_t Level)
{
  /* Check the parameter */
  assert_param(IS_SBS_HDPL(Level));

  if (Level != SBS_HDPL_VALUE_0)
  {
    MODIFY_REG(SBS->DBGCR, SBS_DBGCR_DBG_AUTH_HDPL, (Level << SBS_DBGCR_DBG_AUTH_HDPL_Pos));
    return HAL_OK;
  }
  else
  {
    return HAL_ERROR;
  }
}

uint32_t HAL_SBS_GetDebugLevel(void)
{
  return ((SBS->DBGCR & SBS_DBGCR_DBG_AUTH_HDPL) >> SBS_DBGCR_DBG_AUTH_HDPL_Pos);
}

void HAL_SBS_UnlockDebugConfig(void)
{
  MODIFY_REG(SBS->DBGLOCKR, SBS_DBGLOCKR_DBGCFG_LOCK, SBS_DEBUG_UNLOCK_VALUE);
}

void HAL_SBS_LockDebugConfig(void)
{
  MODIFY_REG(SBS->DBGLOCKR, SBS_DBGLOCKR_DBGCFG_LOCK, SBS_DEBUG_LOCK_VALUE);
}

void HAL_SBS_ConfigRSSCommand(uint32_t Cmd)
{
  MODIFY_REG(SBS->RSSCMDR, SBS_RSSCMDR_RSSCMD, Cmd);
}

uint32_t HAL_SBS_GetRSSCommand(void)
{
  return (SBS->RSSCMDR & SBS_RSSCMDR_RSSCMD);
}

void HAL_SBS_EnableIOAnalogBooster(void)
{
  MODIFY_REG(SBS->PMCR, (SBS_PMCR_BOOSTEN | SBS_PMCR_BOOSTVDDSEL), SBS_PMCR_BOOSTEN);
}

void HAL_SBS_DisableIOAnalogBooster(void)
{
  CLEAR_BIT(SBS->PMCR, SBS_PMCR_BOOSTEN);
}

void HAL_SBS_EnableIOAnalogSwitchVdd(void)
{
  MODIFY_REG(SBS->PMCR, (SBS_PMCR_BOOSTEN | SBS_PMCR_BOOSTVDDSEL), SBS_PMCR_BOOSTVDDSEL);
}

void HAL_SBS_DisableIOAnalogSwitchVdd(void)
{
  CLEAR_BIT(SBS->PMCR, SBS_PMCR_BOOSTVDDSEL);
}

void HAL_SBS_ConfigEthernetPHY(uint32_t Config)
{
  /* Check the parameter */
  assert_param(IS_SBS_ETHERNET_PHY(Config));

  MODIFY_REG(SBS->PMCR, SBS_PMCR_ETH_PHYSEL, Config);
}

void HAL_SBS_ConfigAXISRAMWaitState(uint32_t Config)
{
  /* Check the parameter */
  assert_param(IS_SBS_AXISRAM_WS(Config));

  MODIFY_REG(SBS->PMCR, SBS_PMCR_AXISRAM_WS, Config);
}

void HAL_SBS_EnableCompensationCell(uint32_t Selection)
{
  /* Check the parameter */
  assert_param(IS_SBS_COMPENSATION_CELL(Selection));

  SET_BIT(SBS->CCCSR, Selection);
}

void HAL_SBS_DisableCompensationCell(uint32_t Selection)
{
  /* Check the parameter */
  assert_param(IS_SBS_COMPENSATION_CELL(Selection));

  MODIFY_REG(SBS->CCCSR, Selection, 0U);
}

uint32_t HAL_SBS_GetCompensationCellReadyStatus(uint32_t Selection)
{
  /* Check the parameter */
  assert_param(IS_SBS_COMPENSATION_CELL_READY(Selection));

  return (((SBS->CCCSR & Selection) == 0U) ? 0UL : 1UL);
}

void HAL_SBS_ConfigCompensationCell(uint32_t Selection, uint32_t Code, uint32_t NmosValue, uint32_t PmosValue)
{
  uint32_t offset;

  /* Check the parameters */
  assert_param(IS_SBS_COMPENSATION_CELL(Selection));
  assert_param(IS_SBS_IO_COMPENSATION_CODE(Code));

  if (Code == SBS_IO_REGISTER_CODE)
  {
    /* Check the parameters */
    assert_param(IS_SBS_IO_COMPENSATION_CELL_NMOS_VALUE(NmosValue));
    assert_param(IS_SBS_IO_COMPENSATION_CELL_PMOS_VALUE(PmosValue));

    offset = ((Selection == SBS_IO_ANALOG_CELL) ? 0U : ((Selection == SBS_IO_XSPI1_CELL) ? 8U : 16U));

    MODIFY_REG(SBS->CCSWVALR, (0xFFUL << offset), ((NmosValue << offset) | (PmosValue << (offset + 4U))));
  }

  MODIFY_REG(SBS->CCCSR, (Selection << 1U), (Code << (POSITION_VAL(Selection) + 1U)));
}

HAL_StatusTypeDef HAL_SBS_GetCompensationCell(uint32_t Selection, uint32_t *pCode, uint32_t *pNmosValue,
                                              uint32_t *pPmosValue)
{
  uint32_t reg;
  uint32_t offset;
  HAL_StatusTypeDef status = HAL_ERROR;

  /* Check parameters */
  if ((pCode != NULL) && (pNmosValue != NULL) && (pPmosValue != NULL))
  {
    *pCode = ((SBS->CCCSR & (Selection << 1U)) == 0U) ? SBS_IO_CELL_CODE : SBS_IO_REGISTER_CODE;

    reg = (*pCode == SBS_IO_CELL_CODE) ? (SBS->CCVALR) : (SBS->CCSWVALR);
    offset = ((Selection == SBS_IO_ANALOG_CELL) ? 0U : ((Selection == SBS_IO_XSPI1_CELL) ? 8U : 16U));

    *pNmosValue = ((reg >> offset) & 0xFU);
    *pPmosValue = ((reg >> (offset + 4U)) & 0xFU);

    status = HAL_OK;
  }
  return status;
}

void HAL_SBS_EnableIOSpeedOptimize(uint32_t Selection)
{
  /* Check the parameter */
  assert_param(IS_SBS_IOHSLV(Selection));

  SET_BIT(SBS->CCCSR, Selection);
}

void HAL_SBS_DisableIOSpeedOptimize(uint32_t Selection)
{
  /* Check the parameter */
  assert_param(IS_SBS_IOHSLV(Selection));

  MODIFY_REG(SBS->CCCSR, Selection, 0U);
}

void HAL_SBS_ConfigTimerBreakInput(uint32_t Input)
{
  /* Check the parameter */
  assert_param(IS_SBS_TIMER_BREAK_INPUT(Input));

  SET_BIT(SBS->BKLOCKR, Input);
}

uint32_t HAL_SBS_GetTimerBreakInputConfig(void)
{
  return (SBS->BKLOCKR & SBS_BKLOCKR_MASK);
}

void HAL_SBS_EXTIConfig(uint32_t Exti, uint32_t Port)
{
  uint32_t reg;
  uint32_t offset;

  /* Check the parameters */
  assert_param(IS_SBS_EXTI_INPUT(Exti));
  assert_param(IS_SBS_EXTI_PIN(Port));

  reg = (Exti / 4U);
  offset = (4U * (Exti % 4U));

  MODIFY_REG(SBS->EXTICR[reg], (0xFUL << offset), (Port << offset));
}

uint32_t HAL_SBS_GetEXTIConfig(uint32_t Exti)
{
  uint32_t reg;
  uint32_t offset;

  /* Check the parameters */
  assert_param(IS_SBS_EXTI_INPUT(Exti));

  reg = (Exti / 4U);
  offset = (4U * (Exti % 4U));

  return ((SBS->EXTICR[reg] & (0xFUL << offset)) >> offset);
}

void HAL_VREFBUF_VoltageScalingConfig(uint32_t VoltageScaling)
{
  /* Check the parameters */
  assert_param(IS_VREFBUF_VOLTAGE_SCALE(VoltageScaling));

  MODIFY_REG(VREFBUF->CSR, VREFBUF_CSR_VRS, VoltageScaling);
}

void HAL_VREFBUF_HighImpedanceConfig(uint32_t Mode)
{
  /* Check the parameters */
  assert_param(IS_VREFBUF_HIGH_IMPEDANCE(Mode));

  MODIFY_REG(VREFBUF->CSR, VREFBUF_CSR_HIZ, Mode);
}

void HAL_VREFBUF_TrimmingConfig(uint32_t TrimmingValue)
{
  /* Check the parameters */
  assert_param(IS_VREFBUF_TRIMMING(TrimmingValue));

  MODIFY_REG(VREFBUF->CCR, VREFBUF_CCR_TRIM, TrimmingValue);
}

HAL_StatusTypeDef HAL_VREFBUF_Enable(void)
{
  uint32_t  tickstart;

  SET_BIT(VREFBUF->CSR, VREFBUF_CSR_ENVR);

  /* Get Start Tick*/
  tickstart = HAL_GetTick();

  /* Wait for VRR bit  */
  while (READ_BIT(VREFBUF->CSR, VREFBUF_CSR_VRR) == 0UL)
  {
    if ((HAL_GetTick() - tickstart) > VREFBUF_TIMEOUT_VALUE)
    {
      return HAL_TIMEOUT;
    }
  }

  return HAL_OK;
}

void HAL_VREFBUF_Disable(void)
{
  CLEAR_BIT(VREFBUF->CSR, VREFBUF_CSR_ENVR);
}

void HAL_AXIM_ASIB_EnablePacking(AXIM_ASIB_TypeDef *AsibInstance)
{
  /* Check the parameters */
  assert_param(IS_AXIM_ASIB_ALL_INSTANCE(AsibInstance));

  /* Apply packing configuration for the selected ASIB */
  WRITE_REG(AsibInstance->FNMOD2, 0U);
}

void HAL_AXIM_ASIB_DisablePacking(AXIM_ASIB_TypeDef *AsibInstance)
{
  /* Check the parameters */
  assert_param(IS_AXIM_ASIB_ALL_INSTANCE(AsibInstance));

  /* Apply packing configuration for the selected ASIB */
  WRITE_REG(AsibInstance->FNMOD2, AXIM_ASIB_FNMOD2_BYPASS_MERGE);
}

void HAL_AXIM_ASIB_IssuingConfig(AXIM_ASIB_TypeDef *AsibInstance, uint32_t ReadIssuing, uint32_t WriteIssuing)
{
  /* Check the parameters */
  assert_param(IS_AXIM_ASIB_ALL_INSTANCE(AsibInstance));
  assert_param(IS_AXIM_ASIB_READ_ISS(ReadIssuing));
  assert_param(IS_AXIM_ASIB_WRITE_ISS(WriteIssuing));

  /* Apply read/write issuing configuration for the selected ASIB */
  WRITE_REG(AsibInstance->FNMOD, (ReadIssuing | WriteIssuing));
}

void HAL_AXIM_ASIB_ReadQoSConfig(AXIM_ASIB_TypeDef *AsibInstance, uint32_t QosPriority)
{
  /* Check the parameters */
  assert_param(IS_AXIM_ASIB_ALL_INSTANCE(AsibInstance));
  assert_param(IS_AXIM_QOS(QosPriority));

  /* Apply read QOS priority setting for the selected ASIB */
  WRITE_REG(AsibInstance->READQOS, QosPriority);
}

void HAL_AXIM_ASIB_WriteQoSConfig(AXIM_ASIB_TypeDef *AsibInstance, uint32_t QosPriority)
{
  /* Check the parameters */
  assert_param(IS_AXIM_ASIB_ALL_INSTANCE(AsibInstance));
  assert_param(IS_AXIM_QOS(QosPriority));

  /* Apply write QOS priority setting for the selected ASIB */
  WRITE_REG(AsibInstance->WRITEQOS, QosPriority);
}

void HAL_AXIM_AMIB_EnablePacking(AXIM_AMIB_TypeDef *AmibInstance)
{
  /* Check the parameters */
  assert_param(IS_AXIM_AMIB_ALL_INSTANCE(AmibInstance));

  /* Apply packing configuration for the selected AMIB */
  WRITE_REG(AmibInstance->FNMOD2, 0U);
}

void HAL_AXIM_AMIB_DisablePacking(AXIM_AMIB_TypeDef *AmibInstance)
{
  /* Check the parameters */
  assert_param(IS_AXIM_AMIB_ALL_INSTANCE(AmibInstance));

  /* Apply packing configuration for the selected AMIB */
  WRITE_REG(AmibInstance->FNMOD2, AXIM_AMIB_FNMOD2_BYPASS_MERGE);
}

void HAL_AXIM_AMIB_IssuingConfig(AXIM_AMIB_TypeDef *AmibInstance, uint32_t ReadIssuing, uint32_t WriteIssuing)
{
  /* Check the parameters */
  assert_param(IS_AXIM_AMIB_ALL_INSTANCE(AmibInstance));
  assert_param(IS_AXIM_AMIB_READ_ISS(ReadIssuing));
  assert_param(IS_AXIM_AMIB_WRITE_ISS(WriteIssuing));

  /* Apply read/write issuing configuration for the selected AMIB */
  WRITE_REG(AmibInstance->FNMOD, (ReadIssuing | WriteIssuing));
}

void HAL_AXIM_AMIB_IssuingConfigBusMatrix(AXIM_AMIB_TypeDef *AmibInstance, uint32_t ReadIssuing, uint32_t WriteIssuing)
{
  /* Check the parameters */
  assert_param(IS_AXIM_AMIB_ALL_INSTANCE(AmibInstance));
  assert_param(IS_AXIM_AMIB_READ_ISS_BM(ReadIssuing));
  assert_param(IS_AXIM_AMIB_WRITE_ISS_BM(WriteIssuing));

  /* Apply read/write issuing configuration for the selected AMIB */
  WRITE_REG(AmibInstance->FNMODBMISS, (ReadIssuing | WriteIssuing));
}

void HAL_AXIM_AMIB_EnableLongBurst(AXIM_AMIB_TypeDef *AmibInstance)
{
  /* Check the parameters */
  assert_param(IS_AXIM_AMIB_ALL_INSTANCE(AmibInstance));

  /* Apply Long burst configuration for the selected AMIB */
  WRITE_REG(AmibInstance->FNMODLB, AXIM_AMIB_FNMODLB_LONG_BURST);
}

void HAL_AXIM_AMIB_DisableLongBurst(AXIM_AMIB_TypeDef *AmibInstance)
{
  /* Check the parameters */
  assert_param(IS_AXIM_AMIB_ALL_INSTANCE(AmibInstance));

  /* Apply Long burst configuration for the selected AMIB */
  WRITE_REG(AmibInstance->FNMODLB, 0U);
}

void HAL_FMC_SetBankSwapConfig(uint32_t BankMapConfig)
{
  /* Check the parameter */
  assert_param(IS_FMC_SWAPBANK_MODE(BankMapConfig));

  /* Apply Memory Bank Swapping configuration */
  MODIFY_REG(FMC_Bank1_R->BTCR[0], FMC_BCR1_BMAP, BankMapConfig);
}

uint32_t HAL_FMC_GetBankSwapConfig(void)
{
  return READ_BIT(FMC_Bank1_R->BTCR[0], FMC_BCR1_BMAP);
}
