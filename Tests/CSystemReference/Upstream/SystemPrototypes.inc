/* Copyright (c) 2022 STMicroelectronics. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * Extracted unchanged from HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748.
 * See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt. */
uint32_t HAL_SBS_GetBootAddress(void);
void HAL_SBS_IncrementHDPLValue(void);
uint32_t HAL_SBS_GetHDPLValue(void);
void HAL_SBS_OpenAccessPort(void);
void HAL_SBS_OpenDebug(void);
HAL_StatusTypeDef HAL_SBS_ConfigDebugLevel(uint32_t Level);
uint32_t HAL_SBS_GetDebugLevel(void);
void HAL_SBS_UnlockDebugConfig(void);
void HAL_SBS_LockDebugConfig(void);
void HAL_SBS_ConfigRSSCommand(uint32_t Cmd);
uint32_t HAL_SBS_GetRSSCommand(void);
void HAL_SBS_EnableIOAnalogBooster(void);
void HAL_SBS_DisableIOAnalogBooster(void);
void HAL_SBS_EnableIOAnalogSwitchVdd(void);
void HAL_SBS_DisableIOAnalogSwitchVdd(void);
void HAL_SBS_ConfigEthernetPHY(uint32_t Config);
void HAL_SBS_ConfigAXISRAMWaitState(uint32_t Config);
void HAL_SBS_EnableCompensationCell(uint32_t Selection);
void HAL_SBS_DisableCompensationCell(uint32_t Selection);
uint32_t HAL_SBS_GetCompensationCellReadyStatus(uint32_t Selection);
void HAL_SBS_ConfigCompensationCell(uint32_t Selection, uint32_t Code, uint32_t NmosValue, uint32_t PmosValue);
HAL_StatusTypeDef HAL_SBS_GetCompensationCell(uint32_t Selection, uint32_t *pCode, uint32_t *pNmosValue,
                                              uint32_t *pPmosValue);
void HAL_SBS_EnableIOSpeedOptimize(uint32_t Selection);
void HAL_SBS_DisableIOSpeedOptimize(uint32_t Selection);
void HAL_SBS_ConfigTimerBreakInput(uint32_t Input);
uint32_t HAL_SBS_GetTimerBreakInputConfig(void);
void HAL_SBS_EXTIConfig(uint32_t Exti, uint32_t Port);
uint32_t HAL_SBS_GetEXTIConfig(uint32_t Exti);
void HAL_VREFBUF_VoltageScalingConfig(uint32_t VoltageScaling);
void HAL_VREFBUF_HighImpedanceConfig(uint32_t Mode);
void HAL_VREFBUF_TrimmingConfig(uint32_t TrimmingValue);
HAL_StatusTypeDef HAL_VREFBUF_Enable(void);
void HAL_VREFBUF_Disable(void);
void HAL_AXIM_ASIB_EnablePacking(AXIM_ASIB_TypeDef *AsibInstance);
void HAL_AXIM_ASIB_DisablePacking(AXIM_ASIB_TypeDef *AsibInstance);
void HAL_AXIM_ASIB_IssuingConfig(AXIM_ASIB_TypeDef *AsibInstance, uint32_t ReadIssuing, uint32_t WriteIssuing);
void HAL_AXIM_ASIB_ReadQoSConfig(AXIM_ASIB_TypeDef *AsibInstance, uint32_t QosPriority);
void HAL_AXIM_ASIB_WriteQoSConfig(AXIM_ASIB_TypeDef *AsibInstance, uint32_t QosPriority);
void HAL_AXIM_AMIB_EnablePacking(AXIM_AMIB_TypeDef *AmibInstance);
void HAL_AXIM_AMIB_DisablePacking(AXIM_AMIB_TypeDef *AmibInstance);
void HAL_AXIM_AMIB_IssuingConfig(AXIM_AMIB_TypeDef *AmibInstance, uint32_t ReadIssuing, uint32_t WriteIssuing);
void HAL_AXIM_AMIB_IssuingConfigBusMatrix(AXIM_AMIB_TypeDef *AmibInstance, uint32_t ReadIssuing, uint32_t WriteIssuing);
void HAL_AXIM_AMIB_EnableLongBurst(AXIM_AMIB_TypeDef *AmibInstance);
void HAL_AXIM_AMIB_DisableLongBurst(AXIM_AMIB_TypeDef *AmibInstance);
void HAL_FMC_SetBankSwapConfig(uint32_t BankMapConfig);
uint32_t HAL_FMC_GetBankSwapConfig(void);
