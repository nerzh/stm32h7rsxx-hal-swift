/* Test-only register storage and wrappers; no physical security/MMIO access. */
#ifndef C_SYSTEM_REFERENCE_H
#define C_SYSTEM_REFERENCE_H
#include "SystemReferenceTypes.h"
#include <stddef.h>
typedef enum { CSystem_BOOTSR, CSystem_HDPLCR, CSystem_HDPLSR, CSystem_DBGCR, CSystem_DBGLOCKR, CSystem_RSSCMDR, CSystem_PMCR, CSystem_FPUIMR, CSystem_MESR, CSystem_CCCSR, CSystem_CCVALR, CSystem_CCSWVALR, CSystem_BKLOCKR, CSystem_EXTICR0, CSystem_EXTICR1, CSystem_EXTICR2, CSystem_EXTICR3, CSystem_VREF_CSR, CSystem_VREF_CCR, CSystem_FMC_BCR1, CSystem_ASIB1_FNMOD2, CSystem_ASIB1_READQOS, CSystem_ASIB1_WRITEQOS, CSystem_ASIB1_FNMOD, CSystem_ASIB2_FNMOD2, CSystem_ASIB2_READQOS, CSystem_ASIB2_WRITEQOS, CSystem_ASIB2_FNMOD, CSystem_ASIB3_FNMOD2, CSystem_ASIB3_READQOS, CSystem_ASIB3_WRITEQOS, CSystem_ASIB3_FNMOD, CSystem_ASIB4_FNMOD2, CSystem_ASIB4_READQOS, CSystem_ASIB4_WRITEQOS, CSystem_ASIB4_FNMOD, CSystem_ASIB5_FNMOD2, CSystem_ASIB5_READQOS, CSystem_ASIB5_WRITEQOS, CSystem_ASIB5_FNMOD, CSystem_ASIB6_FNMOD2, CSystem_ASIB6_READQOS, CSystem_ASIB6_WRITEQOS, CSystem_ASIB6_FNMOD, CSystem_ASIB7_FNMOD2, CSystem_ASIB7_READQOS, CSystem_ASIB7_WRITEQOS, CSystem_ASIB7_FNMOD, CSystem_ASIB8_FNMOD2, CSystem_ASIB8_READQOS, CSystem_ASIB8_WRITEQOS, CSystem_ASIB8_FNMOD, CSystem_ASIB9_FNMOD2, CSystem_ASIB9_READQOS, CSystem_ASIB9_WRITEQOS, CSystem_ASIB9_FNMOD, CSystem_ASIB10_FNMOD2, CSystem_ASIB10_READQOS, CSystem_ASIB10_WRITEQOS, CSystem_ASIB10_FNMOD, CSystem_ASIB11_FNMOD2, CSystem_ASIB11_READQOS, CSystem_ASIB11_WRITEQOS, CSystem_ASIB11_FNMOD, CSystem_AMIB1_FNMODBMISS, CSystem_AMIB1_FNMOD2, CSystem_AMIB1_FNMODLB, CSystem_AMIB1_FNMOD, CSystem_AMIB2_FNMODBMISS, CSystem_AMIB2_FNMOD2, CSystem_AMIB2_FNMODLB, CSystem_AMIB2_FNMOD, CSystem_AMIB3_FNMODBMISS, CSystem_AMIB3_FNMOD2, CSystem_AMIB3_FNMODLB, CSystem_AMIB3_FNMOD, CSystem_AMIB4_FNMODBMISS, CSystem_AMIB4_FNMOD2, CSystem_AMIB4_FNMODLB, CSystem_AMIB4_FNMOD, CSystem_AMIB5_FNMODBMISS, CSystem_AMIB5_FNMOD2, CSystem_AMIB5_FNMODLB, CSystem_AMIB5_FNMOD, CSystem_AMIB6_FNMODBMISS, CSystem_AMIB6_FNMOD2, CSystem_AMIB6_FNMODLB, CSystem_AMIB6_FNMOD, CSystem_AMIB7_FNMODBMISS, CSystem_AMIB7_FNMOD2, CSystem_AMIB7_FNMODLB, CSystem_AMIB7_FNMOD, CSystem_AMIB8_FNMODBMISS, CSystem_AMIB8_FNMOD2, CSystem_AMIB8_FNMODLB, CSystem_AMIB8_FNMOD, CSystem_AMIB9_FNMODBMISS, CSystem_AMIB9_FNMOD2, CSystem_AMIB9_FNMODLB, CSystem_AMIB9_FNMOD, CSystem_AMIB10_FNMODBMISS, CSystem_AMIB10_FNMOD2, CSystem_AMIB10_FNMODLB, CSystem_AMIB10_FNMOD, CSystem_RegisterCount } CSystemRegister;
typedef enum { CSystem_SBS_GetBootAddress, CSystem_SBS_IncrementHDPLValue, CSystem_SBS_GetHDPLValue, CSystem_SBS_OpenAccessPort, CSystem_SBS_OpenDebug, CSystem_SBS_ConfigDebugLevel, CSystem_SBS_GetDebugLevel, CSystem_SBS_UnlockDebugConfig, CSystem_SBS_LockDebugConfig, CSystem_SBS_ConfigRSSCommand, CSystem_SBS_GetRSSCommand, CSystem_SBS_EnableIOAnalogBooster, CSystem_SBS_DisableIOAnalogBooster, CSystem_SBS_EnableIOAnalogSwitchVdd, CSystem_SBS_DisableIOAnalogSwitchVdd, CSystem_SBS_ConfigEthernetPHY, CSystem_SBS_ConfigAXISRAMWaitState, CSystem_SBS_EnableCompensationCell, CSystem_SBS_DisableCompensationCell, CSystem_SBS_GetCompensationCellReadyStatus, CSystem_SBS_ConfigCompensationCell, CSystem_SBS_GetCompensationCell, CSystem_SBS_EnableIOSpeedOptimize, CSystem_SBS_DisableIOSpeedOptimize, CSystem_SBS_ConfigTimerBreakInput, CSystem_SBS_GetTimerBreakInputConfig, CSystem_SBS_EXTIConfig, CSystem_SBS_GetEXTIConfig, CSystem_VREFBUF_VoltageScalingConfig, CSystem_VREFBUF_HighImpedanceConfig, CSystem_VREFBUF_TrimmingConfig, CSystem_VREFBUF_Enable, CSystem_VREFBUF_Disable, CSystem_AXIM_ASIB_EnablePacking, CSystem_AXIM_ASIB_DisablePacking, CSystem_AXIM_ASIB_IssuingConfig, CSystem_AXIM_ASIB_ReadQoSConfig, CSystem_AXIM_ASIB_WriteQoSConfig, CSystem_AXIM_AMIB_EnablePacking, CSystem_AXIM_AMIB_DisablePacking, CSystem_AXIM_AMIB_IssuingConfig, CSystem_AXIM_AMIB_IssuingConfigBusMatrix, CSystem_AXIM_AMIB_EnableLongBurst, CSystem_AXIM_AMIB_DisableLongBurst, CSystem_FMC_SetBankSwapConfig, CSystem_FMC_GetBankSwapConfig, CSystem_SBS_EnableFPUInterrupts, CSystem_SBS_DisableFPUInterrupts, CSystem_SBS_GetMemoryEraseStatus } CSystemOperation;
typedef struct { CSystemRegister reg; uint32_t value, kind, tickCalls; } CSystemAccess;
typedef struct { uint32_t active, afterCalls; CSystemRegister reg; uint32_t value; } CSystemEvent;
typedef struct {
 SBS_TypeDef sbs; VREFBUF_TypeDef vref; AXIM_ASIB_TypeDef asib[11]; AXIM_AMIB_TypeDef amib[10]; FMC_Bank1_TypeDef fmc;
 uint32_t outputs[3], tick, tickStep, tickCalls;
 uint32_t accessCount; CSystemAccess accesses[256]; CSystemEvent events[16];
} CSystemState;
/* Plain register memory, with no hardware lock/security side effects. Macro
 * writes are recorded; direct C getters and output-pointer stores remain exact.
 * Pointer selectors: 0=NULL, 1...3=outputs[0...2], 0x100+register=that register.
 * The latter permits independent aliasing tests without rewriting C stores.
 * VREF readiness can be scheduled at a tick call; no final timeout recheck is
 * introduced. Full VREF reads and all macro writes can be compared. */
void CSystem_Reset(CSystemState *);
uint32_t CSystem_Get(const CSystemState *,CSystemRegister);
void CSystem_Set(CSystemState *,CSystemRegister,uint32_t);
uint32_t CSystem_Read(CSystemState *,CSystemRegister);
void CSystem_Write(CSystemState *,CSystemRegister,uint32_t);
uint32_t *CSystem_Pointer(CSystemState *,uint32_t selector);
uint32_t CSystem_Tick(CSystemState *);
void CSystem_ScheduleTick(CSystemState *,uint32_t afterCalls,CSystemRegister,uint32_t value);
CSystemAccess CSystem_GetAccess(const CSystemState *,uint32_t index);
/* Ordinary scalar parameters use a,b,c,d. AXIM a=zero-based instance, b/c are
 * read/write issuing or b=QoS. SBS GetCompensationCell a=selection and b/c/d
 * are the three pointer selectors, including NULL and overlapping addresses. */
uint32_t CSystem_Run(CSystemState *,CSystemOperation,uint32_t a,uint32_t b,uint32_t c,uint32_t d);
#endif
