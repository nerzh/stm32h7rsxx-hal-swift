#include "include/CLLClockReference.h"
#include <stdlib.h>
#include <assert.h>
#include "Upstream/Clock/Trace/stm32h7rsxx_ll_rcc.h"
#include "Upstream/Clock/Trace/stm32h7rsxx_ll_crs.h"
#include "Upstream/Clock/Trace/stm32h7rsxx_ll_utils.h"
#include "Upstream/Clock/Trace/stm32h7rsxx_ll_rcc.inc"
#include "Upstream/Clock/Trace/stm32h7rsxx_ll_crs.inc"
#include "Upstream/Clock/Trace/stm32h7rsxx_ll_utils.inc"
struct CL50State { uint32_t cells[2304], count, reads, salt, mode; CL50Access trace[1024]; };
_Thread_local uint32_t *CL50_Cells;
static _Thread_local CL50State *current;
CL50State *CL50_Create(void) { return calloc(1, sizeof(CL50State)); }
void CL50_Destroy(CL50State *s) { free(s); }
void CL50_Reset(CL50State *s, uint32_t seed, uint32_t salt, uint32_t mode) {
  current = s; CL50_Cells = s->cells;
  for (uint32_t i=0; i<2304; i++) s->cells[i] = seed ^ (i * 0x9E3779B9U);
  s->count = 0; s->reads = 0; s->salt = salt; s->mode = mode;
}
static void record(uint32_t index, uint32_t value, uint32_t kind) {
  assert(index < 2304 && current->count < 1024);
  current->trace[current->count++] = (CL50Access){index, value, kind};
}
uint32_t CL50_Read(volatile const uint32_t *p) {
  uint32_t index = (uint32_t)(p - CL50_Cells);
  assert(index < 2304);
  if ((current->mode & 1U) && current->reads % 3U == 2U) {
    if (index == 0) {
      uint32_t v = CL50_Cells[0];
      CL50_Cells[0] = (v & ~0x2A022124U) | ((v & 0x15011080U) << 1U) | ((v & 1U) << 2U) | 0x20U;
      /* HSI ready is two bits above enable; CSI/HSI48 and PLL ready are one. */

    }
    if (index == 4) CL50_Cells[4] = (CL50_Cells[4] & ~0x38U) | ((CL50_Cells[4] & 7U) << 3U);
  }
  uint32_t value = *p ^ (current->salt * current->reads);
  if ((current->mode & 1U) && index == 1024) {
    value = (value & ~0x10000U) | ((current->reads % 3U == 2U) ? 0x10000U : 0U);
    CL50_Cells[1024] &= ~0x10000U;
  }
  current->reads++;
  record(index, value, 0); return value;
}
void CL50_Write(volatile uint32_t *p, uint32_t value) {
  uint32_t index = (uint32_t)(p - CL50_Cells);
  record(index, value, 1);
  if ((current->mode & 2U) && index == 512) value = (value & ~15U) | (*p & 15U);
  *p = value;
}
uint32_t CL50_Oscillator(uint32_t index) {
  static const uint32_t values[7] = {64000000, 4000000, 24000000, 32768, 32000, 48000000, 12288000};
  assert(index < 7); return values[index] + ((current->mode & 4U) ? 17U : 0U);
}
uint32_t *CL50_CoreClockPointer(void) { return CL50_Cells + 2100; }
uint32_t CL50_ReadCoreClock(void) { uint32_t value = CL50_Cells[2100]; record(2100, value, 2); return value; }
void CL50_WriteCoreClock(uint32_t value) { record(2100, value, 3); CL50_Cells[2100] = value; }
uint32_t *CL50_GetCells(CL50State *s) { return s->cells; }
const CL50Access *CL50_GetTrace(CL50State *s) { return s->trace; }
uint32_t CL50_GetTraceCount(CL50State *s) { return s->count; }
uint32_t CL50_Run(CL50State *s, uint32_t operation, const uint32_t *args) {
  current = s; CL50_Cells = s->cells;
  switch(operation) {
    case 0: { LL_RCC_HSE_EnableCSS(); return 0; }
    case 1: { LL_RCC_HSE_EnableBypass(); return 0; }
    case 2: { LL_RCC_HSE_DisableBypass(); return 0; }
    case 3: { LL_RCC_HSE_SelectAnalogClock(); return 0; }
    case 4: { LL_RCC_HSE_SelectDigitalClock(); return 0; }
    case 5: { LL_RCC_HSE_Enable(); return 0; }
    case 6: { LL_RCC_HSE_Disable(); return 0; }
    case 7: { uint32_t result = LL_RCC_HSE_IsReady(); return result; }
    case 8: { LL_RCC_HSI_Enable(); return 0; }
    case 9: { LL_RCC_HSI_Disable(); return 0; }
    case 10: { uint32_t result = LL_RCC_HSI_IsReady(); return result; }
    case 11: { uint32_t result = LL_RCC_HSI_IsDividerReady(); return result; }
    case 12: { LL_RCC_HSI_SetDivider(args[0]); return 0; }
    case 13: { uint32_t result = LL_RCC_HSI_GetDivider(); return result; }
    case 14: { LL_RCC_HSI_EnableStopMode(); return 0; }
    case 15: { LL_RCC_HSI_DisableStopMode(); return 0; }
    case 16: { uint32_t result = LL_RCC_HSI_IsEnabledStopMode(); return result; }
    case 17: { LL_RCC_EnableXSPIClockProtection(); return 0; }
    case 18: { LL_RCC_DisableXSPIClockProtection(); return 0; }
    case 19: { uint32_t result = LL_RCC_IsEnabledXSPIClockProtection(); return result; }
    case 20: { LL_RCC_EnableFMCClockProtection(); return 0; }
    case 21: { LL_RCC_DisableFMCClockProtection(); return 0; }
    case 22: { uint32_t result = LL_RCC_IsEnabledFMCClockProtection(); return result; }
    case 23: { uint32_t result = LL_RCC_GetXSPI2SwitchPosition(); return result; }
    case 24: { uint32_t result = LL_RCC_GetXSPI1SwitchPosition(); return result; }
    case 25: { uint32_t result = LL_RCC_GetFMCSwitchPosition(); return result; }
    case 26: { uint32_t result = LL_RCC_HSI_GetCalibration(); return result; }
    case 27: { LL_RCC_HSI_SetCalibTrimming(args[0]); return 0; }
    case 28: { uint32_t result = LL_RCC_HSI_GetCalibTrimming(); return result; }
    case 29: { LL_RCC_CSI_Enable(); return 0; }
    case 30: { LL_RCC_CSI_Disable(); return 0; }
    case 31: { uint32_t result = LL_RCC_CSI_IsReady(); return result; }
    case 32: { LL_RCC_CSI_EnableStopMode(); return 0; }
    case 33: { LL_RCC_CSI_DisableStopMode(); return 0; }
    case 34: { uint32_t result = LL_RCC_CSI_IsEnabledStopMode(); return result; }
    case 35: { uint32_t result = LL_RCC_CSI_GetCalibration(); return result; }
    case 36: { LL_RCC_CSI_SetCalibTrimming(args[0]); return 0; }
    case 37: { uint32_t result = LL_RCC_CSI_GetCalibTrimming(); return result; }
    case 38: { LL_RCC_HSI48_Enable(); return 0; }
    case 39: { LL_RCC_HSI48_Disable(); return 0; }
    case 40: { uint32_t result = LL_RCC_HSI48_IsReady(); return result; }
    case 41: { uint32_t result = LL_RCC_HSI48_GetCalibration(); return result; }
    case 42: { LL_RCC_LSE_EnableCSS(); return 0; }
    case 43: { LL_RCC_LSE_DisableCSS(); return 0; }
    case 44: { uint32_t result = LL_RCC_LSE_IsFailureDetected(); return result; }
    case 45: { LL_RCC_LSE_ReArmCSS(); return 0; }
    case 46: { LL_RCC_LSE_Enable(); return 0; }
    case 47: { LL_RCC_LSE_Disable(); return 0; }
    case 48: { LL_RCC_LSE_EnableBypass(); return 0; }
    case 49: { LL_RCC_LSE_DisableBypass(); return 0; }
    case 50: { LL_RCC_LSE_SelectDigitalClock(); return 0; }
    case 51: { LL_RCC_LSE_SelectAnalogClock(); return 0; }
    case 52: { LL_RCC_LSE_SetDriveCapability(args[0]); return 0; }
    case 53: { uint32_t result = LL_RCC_LSE_GetDriveCapability(); return result; }
    case 54: { uint32_t result = LL_RCC_LSE_IsReady(); return result; }
    case 55: { LL_RCC_LSI_Enable(); return 0; }
    case 56: { LL_RCC_LSI_Disable(); return 0; }
    case 57: { uint32_t result = LL_RCC_LSI_IsReady(); return result; }
    case 58: { LL_RCC_SetSysClkSource(args[0]); return 0; }
    case 59: { uint32_t result = LL_RCC_GetSysClkSource(); return result; }
    case 60: { LL_RCC_SetSysWakeUpClkSource(args[0]); return 0; }
    case 61: { uint32_t result = LL_RCC_GetSysWakeUpClkSource(); return result; }
    case 62: { LL_RCC_SetKerWakeUpClkSource(args[0]); return 0; }
    case 63: { uint32_t result = LL_RCC_GetKerWakeUpClkSource(); return result; }
    case 64: { LL_RCC_SetSysPrescaler(args[0]); return 0; }
    case 65: { LL_RCC_SetAHBPrescaler(args[0]); return 0; }
    case 66: { LL_RCC_SetAPB1Prescaler(args[0]); return 0; }
    case 67: { LL_RCC_SetAPB2Prescaler(args[0]); return 0; }
    case 68: { LL_RCC_SetAPB4Prescaler(args[0]); return 0; }
    case 69: { LL_RCC_SetAPB5Prescaler(args[0]); return 0; }
    case 70: { uint32_t result = LL_RCC_GetSysPrescaler(); return result; }
    case 71: { uint32_t result = LL_RCC_GetAHBPrescaler(); return result; }
    case 72: { uint32_t result = LL_RCC_GetAPB1Prescaler(); return result; }
    case 73: { uint32_t result = LL_RCC_GetAPB2Prescaler(); return result; }
    case 74: { uint32_t result = LL_RCC_GetAPB4Prescaler(); return result; }
    case 75: { uint32_t result = LL_RCC_GetAPB5Prescaler(); return result; }
    case 76: { LL_RCC_ConfigMCO(args[0], args[1]); return 0; }
    case 77: { LL_RCC_SetClockSource(args[0]); return 0; }
    case 78: { LL_RCC_SetADCClockSource(args[0]); return 0; }
    case 79: { LL_RCC_SetADFClockSource(args[0]); return 0; }
    case 80: { LL_RCC_SetCECClockSource(args[0]); return 0; }
    case 81: { LL_RCC_SetCLKPClockSource(args[0]); return 0; }
    case 82: { LL_RCC_SetETHPHYClockSource(args[0]); return 0; }
    case 83: { LL_RCC_SetETHREFClockSource(args[0]); return 0; }
    case 84: { LL_RCC_SetFDCANClockSource(args[0]); return 0; }
    case 85: { LL_RCC_SetFMCClockSource(args[0]); return 0; }
    case 86: { LL_RCC_SetI2CClockSource(args[0]); return 0; }
    case 87: { LL_RCC_SetI3CClockSource(args[0]); return 0; }
    case 88: { LL_RCC_SetLPTIMClockSource(args[0]); return 0; }
    case 89: { LL_RCC_SetLPUARTClockSource(args[0]); return 0; }
    case 90: { LL_RCC_SetOTGFSClockSource(args[0]); return 0; }
    case 91: { LL_RCC_SetXSPIClockSource(args[0]); return 0; }
    case 92: { LL_RCC_SetPSSIClockSource(args[0]); return 0; }
    case 93: { LL_RCC_SetSAIClockSource(args[0]); return 0; }
    case 94: { LL_RCC_SetSDMMCClockSource(args[0]); return 0; }
    case 95: { LL_RCC_SetSPDIFRXClockSource(args[0]); return 0; }
    case 96: { LL_RCC_SetSPIClockSource(args[0]); return 0; }
    case 97: { LL_RCC_SetUSARTClockSource(args[0]); return 0; }
    case 98: { LL_RCC_SetUSBPHYCClockSource(args[0]); return 0; }
    case 99: { LL_RCC_SetUSBREFClockSource(args[0]); return 0; }
    case 100: { uint32_t result = LL_RCC_GetClockSource(args[0]); return result; }
    case 101: { uint32_t result = LL_RCC_GetADCClockSource(args[0]); return result; }
    case 102: { uint32_t result = LL_RCC_GetADFClockSource(args[0]); return result; }
    case 103: { uint32_t result = LL_RCC_GetCECClockSource(args[0]); return result; }
    case 104: { uint32_t result = LL_RCC_GetCLKPClockSource(args[0]); return result; }
    case 105: { uint32_t result = LL_RCC_GetETHPHYClockSource(args[0]); return result; }
    case 106: { uint32_t result = LL_RCC_GetETHREFClockSource(args[0]); return result; }
    case 107: { uint32_t result = LL_RCC_GetFDCANClockSource(args[0]); return result; }
    case 108: { uint32_t result = LL_RCC_GetFMCClockSource(args[0]); return result; }
    case 109: { uint32_t result = LL_RCC_GetI2CClockSource(args[0]); return result; }
    case 110: { uint32_t result = LL_RCC_GetI3CClockSource(args[0]); return result; }
    case 111: { uint32_t result = LL_RCC_GetLPTIMClockSource(args[0]); return result; }
    case 112: { uint32_t result = LL_RCC_GetLPUARTClockSource(args[0]); return result; }
    case 113: { uint32_t result = LL_RCC_GetOTGFSClockSource(args[0]); return result; }
    case 114: { uint32_t result = LL_RCC_GetXSPIClockSource(args[0]); return result; }
    case 115: { uint32_t result = LL_RCC_GetPSSIClockSource(args[0]); return result; }
    case 116: { uint32_t result = LL_RCC_GetSAIClockSource(args[0]); return result; }
    case 117: { uint32_t result = LL_RCC_GetSDMMCClockSource(args[0]); return result; }
    case 118: { uint32_t result = LL_RCC_GetSPDIFRXClockSource(args[0]); return result; }
    case 119: { uint32_t result = LL_RCC_GetSPIClockSource(args[0]); return result; }
    case 120: { uint32_t result = LL_RCC_GetUSARTClockSource(args[0]); return result; }
    case 121: { uint32_t result = LL_RCC_GetUSBPHYCClockSource(args[0]); return result; }
    case 122: { uint32_t result = LL_RCC_GetUSBREFClockSource(args[0]); return result; }
    case 123: { LL_RCC_SetRTCClockSource(args[0]); return 0; }
    case 124: { uint32_t result = LL_RCC_GetRTCClockSource(); return result; }
    case 125: { LL_RCC_EnableRTC(); return 0; }
    case 126: { LL_RCC_DisableRTC(); return 0; }
    case 127: { uint32_t result = LL_RCC_IsEnabledRTC(); return result; }
    case 128: { LL_RCC_ForceBackupDomainReset(); return 0; }
    case 129: { LL_RCC_ReleaseBackupDomainReset(); return 0; }
    case 130: { LL_RCC_SetRTC_HSEPrescaler(args[0]); return 0; }
    case 131: { uint32_t result = LL_RCC_GetRTC_HSEPrescaler(); return result; }
    case 132: { LL_RCC_SetTIMPrescaler(args[0]); return 0; }
    case 133: { uint32_t result = LL_RCC_GetTIMPrescaler(); return result; }
    case 134: { LL_RCC_USBPHYC_EnablePowerDown(); return 0; }
    case 135: { LL_RCC_USBPHYC_DisablePowerDown(); return 0; }
    case 136: { uint32_t result = LL_RCC_USBPHYC_IsEnabledPowerDown(); return result; }
    case 137: { LL_RCC_PLL_SetSource(args[0]); return 0; }
    case 138: { uint32_t result = LL_RCC_PLL_GetSource(); return result; }
    case 139: { LL_RCC_PLL1_Enable(); return 0; }
    case 140: { LL_RCC_PLL1_Disable(); return 0; }
    case 141: { uint32_t result = LL_RCC_PLL1_IsReady(); return result; }
    case 142: { LL_RCC_PLL1_ConfigDomain_SYS(args[0], args[1], args[2], args[3]); return 0; }
    case 143: { LL_RCC_PLL1P_Enable(); return 0; }
    case 144: { LL_RCC_PLL1Q_Enable(); return 0; }
    case 145: { LL_RCC_PLL1R_Enable(); return 0; }
    case 146: { LL_RCC_PLL1S_Enable(); return 0; }
    case 147: { LL_RCC_PLL1FRACN_Enable(); return 0; }
    case 148: { uint32_t result = LL_RCC_PLL1P_IsEnabled(); return result; }
    case 149: { uint32_t result = LL_RCC_PLL1Q_IsEnabled(); return result; }
    case 150: { uint32_t result = LL_RCC_PLL1R_IsEnabled(); return result; }
    case 151: { uint32_t result = LL_RCC_PLL1S_IsEnabled(); return result; }
    case 152: { uint32_t result = LL_RCC_PLL1FRACN_IsEnabled(); return result; }
    case 153: { LL_RCC_PLL1P_Disable(); return 0; }
    case 154: { LL_RCC_PLL1Q_Disable(); return 0; }
    case 155: { LL_RCC_PLL1R_Disable(); return 0; }
    case 156: { LL_RCC_PLL1S_Disable(); return 0; }
    case 157: { LL_RCC_PLL1FRACN_Disable(); return 0; }
    case 158: { uint32_t result = LL_RCC_PLL1_GetVCOInputRange(); return result; }
    case 159: { uint32_t result = LL_RCC_PLL1_GetVCOOutputRange(); return result; }
    case 160: { LL_RCC_PLL1_SetVCOInputRange(args[0]); return 0; }
    case 161: { LL_RCC_PLL1_SetVCOOutputRange(args[0]); return 0; }
    case 162: { uint32_t result = LL_RCC_PLL1_GetN(); return result; }
    case 163: { uint32_t result = LL_RCC_PLL1_GetM(); return result; }
    case 164: { uint32_t result = LL_RCC_PLL1_GetP(); return result; }
    case 165: { uint32_t result = LL_RCC_PLL1_GetQ(); return result; }
    case 166: { uint32_t result = LL_RCC_PLL1_GetR(); return result; }
    case 167: { uint32_t result = LL_RCC_PLL1_GetS(); return result; }
    case 168: { uint32_t result = LL_RCC_PLL1_GetFRACN(); return result; }
    case 169: { LL_RCC_PLL1_SetN(args[0]); return 0; }
    case 170: { LL_RCC_PLL1_SetM(args[0]); return 0; }
    case 171: { LL_RCC_PLL1_SetP(args[0]); return 0; }
    case 172: { LL_RCC_PLL1_SetQ(args[0]); return 0; }
    case 173: { LL_RCC_PLL1_SetR(args[0]); return 0; }
    case 174: { LL_RCC_PLL1_SetS(args[0]); return 0; }
    case 175: { LL_RCC_PLL1_SetFRACN(args[0]); return 0; }
    case 176: { LL_RCC_PLL1_EnableSpreadSpectrum(); return 0; }
    case 177: { LL_RCC_PLL1_DisableSpreadSpectrum(); return 0; }
    case 178: { uint32_t result = LL_RCC_PLL1_IsEnabledSpreadSpectrum(); return result; }
    case 179: { uint32_t result = LL_RCC_PLL1_GetModulationPeriod(); return result; }
    case 180: { uint32_t result = LL_RCC_PLL1_GetIncrementStep(); return result; }
    case 181: { uint32_t result = LL_RCC_PLL1_GetSpreadSelection(); return result; }
    case 182: { uint32_t result = LL_RCC_PLL1_IsEnabledRPDFNDithering(); return result; }
    case 183: { uint32_t result = LL_RCC_PLL1_IsEnabledTPDFNDithering(); return result; }
    case 184: { LL_RCC_PLL2_Enable(); return 0; }
    case 185: { LL_RCC_PLL2_Disable(); return 0; }
    case 186: { uint32_t result = LL_RCC_PLL2_IsReady(); return result; }
    case 187: { LL_RCC_PLL2P_Enable(); return 0; }
    case 188: { LL_RCC_PLL2Q_Enable(); return 0; }
    case 189: { LL_RCC_PLL2R_Enable(); return 0; }
    case 190: { LL_RCC_PLL2S_Enable(); return 0; }
    case 191: { LL_RCC_PLL2T_Enable(); return 0; }
    case 192: { LL_RCC_PLL2FRACN_Enable(); return 0; }
    case 193: { uint32_t result = LL_RCC_PLL2P_IsEnabled(); return result; }
    case 194: { uint32_t result = LL_RCC_PLL2Q_IsEnabled(); return result; }
    case 195: { uint32_t result = LL_RCC_PLL2R_IsEnabled(); return result; }
    case 196: { uint32_t result = LL_RCC_PLL2S_IsEnabled(); return result; }
    case 197: { uint32_t result = LL_RCC_PLL2T_IsEnabled(); return result; }
    case 198: { uint32_t result = LL_RCC_PLL2FRACN_IsEnabled(); return result; }
    case 199: { LL_RCC_PLL2P_Disable(); return 0; }
    case 200: { LL_RCC_PLL2Q_Disable(); return 0; }
    case 201: { LL_RCC_PLL2R_Disable(); return 0; }
    case 202: { LL_RCC_PLL2S_Disable(); return 0; }
    case 203: { LL_RCC_PLL2T_Disable(); return 0; }
    case 204: { LL_RCC_PLL2FRACN_Disable(); return 0; }
    case 205: { uint32_t result = LL_RCC_PLL2_GetVCOInputRange(); return result; }
    case 206: { uint32_t result = LL_RCC_PLL2_GetVCOOutputRange(); return result; }
    case 207: { LL_RCC_PLL2_SetVCOInputRange(args[0]); return 0; }
    case 208: { LL_RCC_PLL2_SetVCOOutputRange(args[0]); return 0; }
    case 209: { uint32_t result = LL_RCC_PLL2_GetN(); return result; }
    case 210: { uint32_t result = LL_RCC_PLL2_GetM(); return result; }
    case 211: { uint32_t result = LL_RCC_PLL2_GetP(); return result; }
    case 212: { uint32_t result = LL_RCC_PLL2_GetQ(); return result; }
    case 213: { uint32_t result = LL_RCC_PLL2_GetR(); return result; }
    case 214: { uint32_t result = LL_RCC_PLL2_GetS(); return result; }
    case 215: { uint32_t result = LL_RCC_PLL2_GetT(); return result; }
    case 216: { uint32_t result = LL_RCC_PLL2_GetFRACN(); return result; }
    case 217: { LL_RCC_PLL2_SetN(args[0]); return 0; }
    case 218: { LL_RCC_PLL2_SetM(args[0]); return 0; }
    case 219: { LL_RCC_PLL2_SetP(args[0]); return 0; }
    case 220: { LL_RCC_PLL2_SetQ(args[0]); return 0; }
    case 221: { LL_RCC_PLL2_SetR(args[0]); return 0; }
    case 222: { LL_RCC_PLL2_SetS(args[0]); return 0; }
    case 223: { LL_RCC_PLL2_SetT(args[0]); return 0; }
    case 224: { LL_RCC_PLL2_SetFRACN(args[0]); return 0; }
    case 225: { LL_RCC_PLL2_EnableSpreadSpectrum(); return 0; }
    case 226: { LL_RCC_PLL2_DisableSpreadSpectrum(); return 0; }
    case 227: { uint32_t result = LL_RCC_PLL2_IsEnabledSpreadSpectrum(); return result; }
    case 228: { uint32_t result = LL_RCC_PLL2_GetModulationPeriod(); return result; }
    case 229: { uint32_t result = LL_RCC_PLL2_GetIncrementStep(); return result; }
    case 230: { uint32_t result = LL_RCC_PLL2_GetSpreadSelection(); return result; }
    case 231: { uint32_t result = LL_RCC_PLL2_IsEnabledRPDFNDithering(); return result; }
    case 232: { uint32_t result = LL_RCC_PLL2_IsEnabledTPDFNDithering(); return result; }
    case 233: { LL_RCC_PLL3_Enable(); return 0; }
    case 234: { LL_RCC_PLL3_Disable(); return 0; }
    case 235: { uint32_t result = LL_RCC_PLL3_IsReady(); return result; }
    case 236: { LL_RCC_PLL3P_Enable(); return 0; }
    case 237: { LL_RCC_PLL3Q_Enable(); return 0; }
    case 238: { LL_RCC_PLL3R_Enable(); return 0; }
    case 239: { LL_RCC_PLL3S_Enable(); return 0; }
    case 240: { LL_RCC_PLL3FRACN_Enable(); return 0; }
    case 241: { uint32_t result = LL_RCC_PLL3P_IsEnabled(); return result; }
    case 242: { uint32_t result = LL_RCC_PLL3Q_IsEnabled(); return result; }
    case 243: { uint32_t result = LL_RCC_PLL3R_IsEnabled(); return result; }
    case 244: { uint32_t result = LL_RCC_PLL3S_IsEnabled(); return result; }
    case 245: { uint32_t result = LL_RCC_PLL3FRACN_IsEnabled(); return result; }
    case 246: { LL_RCC_PLL3P_Disable(); return 0; }
    case 247: { LL_RCC_PLL3Q_Disable(); return 0; }
    case 248: { LL_RCC_PLL3R_Disable(); return 0; }
    case 249: { LL_RCC_PLL3S_Disable(); return 0; }
    case 250: { LL_RCC_PLL3FRACN_Disable(); return 0; }
    case 251: { uint32_t result = LL_RCC_PLL3_GetVCOInputRange(); return result; }
    case 252: { uint32_t result = LL_RCC_PLL3_GetVCOOutputRange(); return result; }
    case 253: { LL_RCC_PLL3_SetVCOInputRange(args[0]); return 0; }
    case 254: { LL_RCC_PLL3_SetVCOOutputRange(args[0]); return 0; }
    case 255: { uint32_t result = LL_RCC_PLL3_GetN(); return result; }
    case 256: { uint32_t result = LL_RCC_PLL3_GetM(); return result; }
    case 257: { uint32_t result = LL_RCC_PLL3_GetP(); return result; }
    case 258: { uint32_t result = LL_RCC_PLL3_GetQ(); return result; }
    case 259: { uint32_t result = LL_RCC_PLL3_GetR(); return result; }
    case 260: { uint32_t result = LL_RCC_PLL3_GetS(); return result; }
    case 261: { uint32_t result = LL_RCC_PLL3_GetFRACN(); return result; }
    case 262: { LL_RCC_PLL3_SetN(args[0]); return 0; }
    case 263: { LL_RCC_PLL3_SetM(args[0]); return 0; }
    case 264: { LL_RCC_PLL3_SetP(args[0]); return 0; }
    case 265: { LL_RCC_PLL3_SetQ(args[0]); return 0; }
    case 266: { LL_RCC_PLL3_SetR(args[0]); return 0; }
    case 267: { LL_RCC_PLL3_SetS(args[0]); return 0; }
    case 268: { LL_RCC_PLL3_SetFRACN(args[0]); return 0; }
    case 269: { LL_RCC_PLL3_EnableSpreadSpectrum(); return 0; }
    case 270: { LL_RCC_PLL3_DisableSpreadSpectrum(); return 0; }
    case 271: { uint32_t result = LL_RCC_PLL3_IsEnabledSpreadSpectrum(); return result; }
    case 272: { uint32_t result = LL_RCC_PLL3_GetModulationPeriod(); return result; }
    case 273: { uint32_t result = LL_RCC_PLL3_GetIncrementStep(); return result; }
    case 274: { uint32_t result = LL_RCC_PLL3_GetSpreadSelection(); return result; }
    case 275: { uint32_t result = LL_RCC_PLL3_IsEnabledRPDFNDithering(); return result; }
    case 276: { uint32_t result = LL_RCC_PLL3_IsEnabledTPDFNDithering(); return result; }
    case 277: { LL_RCC_ClearFlag_LSIRDY(); return 0; }
    case 278: { LL_RCC_ClearFlag_LSERDY(); return 0; }
    case 279: { LL_RCC_ClearFlag_HSIRDY(); return 0; }
    case 280: { LL_RCC_ClearFlag_HSERDY(); return 0; }
    case 281: { LL_RCC_ClearFlag_CSIRDY(); return 0; }
    case 282: { LL_RCC_ClearFlag_HSI48RDY(); return 0; }
    case 283: { LL_RCC_ClearFlag_PLL1RDY(); return 0; }
    case 284: { LL_RCC_ClearFlag_PLL2RDY(); return 0; }
    case 285: { LL_RCC_ClearFlag_PLL3RDY(); return 0; }
    case 286: { LL_RCC_ClearFlag_LSECSS(); return 0; }
    case 287: { LL_RCC_ClearFlag_HSECSS(); return 0; }
    case 288: { uint32_t result = LL_RCC_IsActiveFlag_LSIRDY(); return result; }
    case 289: { uint32_t result = LL_RCC_IsActiveFlag_LSERDY(); return result; }
    case 290: { uint32_t result = LL_RCC_IsActiveFlag_HSIRDY(); return result; }
    case 291: { uint32_t result = LL_RCC_IsActiveFlag_HSERDY(); return result; }
    case 292: { uint32_t result = LL_RCC_IsActiveFlag_CSIRDY(); return result; }
    case 293: { uint32_t result = LL_RCC_IsActiveFlag_HSI48RDY(); return result; }
    case 294: { uint32_t result = LL_RCC_IsActiveFlag_PLL1RDY(); return result; }
    case 295: { uint32_t result = LL_RCC_IsActiveFlag_PLL2RDY(); return result; }
    case 296: { uint32_t result = LL_RCC_IsActiveFlag_PLL3RDY(); return result; }
    case 297: { uint32_t result = LL_RCC_IsActiveFlag_LSECSS(); return result; }
    case 298: { uint32_t result = LL_RCC_IsActiveFlag_HSECSS(); return result; }
    case 299: { uint32_t result = LL_RCC_IsActiveFlag_LPWRRST(); return result; }
    case 300: { uint32_t result = LL_RCC_IsActiveFlag_WWDGRST(); return result; }
    case 301: { uint32_t result = LL_RCC_IsActiveFlag_IWDGRST(); return result; }
    case 302: { uint32_t result = LL_RCC_IsActiveFlag_SFTRST(); return result; }
    case 303: { uint32_t result = LL_RCC_IsActiveFlag_PORRST(); return result; }
    case 304: { uint32_t result = LL_RCC_IsActiveFlag_PINRST(); return result; }
    case 305: { uint32_t result = LL_RCC_IsActiveFlag_BORRST(); return result; }
    case 306: { LL_RCC_ClearResetFlags(); return 0; }
    case 307: { LL_RCC_EnableIT_LSIRDY(); return 0; }
    case 308: { LL_RCC_EnableIT_LSERDY(); return 0; }
    case 309: { LL_RCC_EnableIT_HSIRDY(); return 0; }
    case 310: { LL_RCC_EnableIT_HSERDY(); return 0; }
    case 311: { LL_RCC_EnableIT_CSIRDY(); return 0; }
    case 312: { LL_RCC_EnableIT_HSI48RDY(); return 0; }
    case 313: { LL_RCC_EnableIT_PLL1RDY(); return 0; }
    case 314: { LL_RCC_EnableIT_PLL2RDY(); return 0; }
    case 315: { LL_RCC_EnableIT_PLL3RDY(); return 0; }
    case 316: { LL_RCC_EnableIT_LSECSS(); return 0; }
    case 317: { LL_RCC_DisableIT_LSIRDY(); return 0; }
    case 318: { LL_RCC_DisableIT_LSERDY(); return 0; }
    case 319: { LL_RCC_DisableIT_HSIRDY(); return 0; }
    case 320: { LL_RCC_DisableIT_HSERDY(); return 0; }
    case 321: { LL_RCC_DisableIT_CSIRDY(); return 0; }
    case 322: { LL_RCC_DisableIT_HSI48RDY(); return 0; }
    case 323: { LL_RCC_DisableIT_PLL1RDY(); return 0; }
    case 324: { LL_RCC_DisableIT_PLL2RDY(); return 0; }
    case 325: { LL_RCC_DisableIT_PLL3RDY(); return 0; }
    case 326: { LL_RCC_DisableIT_LSECSS(); return 0; }
    case 327: { uint32_t result = LL_RCC_IsEnableIT_LSIRDY(); return result; }
    case 328: { uint32_t result = LL_RCC_IsEnableIT_LSERDY(); return result; }
    case 329: { uint32_t result = LL_RCC_IsEnableIT_HSIRDY(); return result; }
    case 330: { uint32_t result = LL_RCC_IsEnableIT_HSERDY(); return result; }
    case 331: { uint32_t result = LL_RCC_IsEnableIT_CSIRDY(); return result; }
    case 332: { uint32_t result = LL_RCC_IsEnableIT_HSI48RDY(); return result; }
    case 333: { uint32_t result = LL_RCC_IsEnableIT_PLL1RDY(); return result; }
    case 334: { uint32_t result = LL_RCC_IsEnableIT_PLL2RDY(); return result; }
    case 335: { uint32_t result = LL_RCC_IsEnableIT_PLL3RDY(); return result; }
    case 336: { uint32_t result = LL_RCC_IsEnableIT_LSECSS(); return result; }
    case 337: { uint32_t result = LL_RCC_CalcPLLClockFreq(args[0], args[1], args[2], args[3], args[4]); return result; }
    case 338: { LL_RCC_DeInit(); return 0; }
    case 339: { LL_RCC_ClocksTypeDef v0 = {args[0], args[1], args[2], args[3], args[4], args[5], args[6]}; LL_RCC_GetSystemClocksFreq(&v0); s->cells[2200] = v0.SYSCLK_Frequency; s->cells[2201] = v0.CPUCLK_Frequency; s->cells[2202] = v0.HCLK_Frequency; s->cells[2203] = v0.PCLK1_Frequency; s->cells[2204] = v0.PCLK2_Frequency; s->cells[2205] = v0.PCLK4_Frequency; s->cells[2206] = v0.PCLK5_Frequency; return 0; }
    case 340: { LL_PLL_ClocksTypeDef v0 = {args[0], args[1], args[2], args[3], args[4]}; LL_RCC_GetPLL1ClockFreq(&v0); s->cells[2200] = v0.PLL_P_Frequency; s->cells[2201] = v0.PLL_Q_Frequency; s->cells[2202] = v0.PLL_R_Frequency; s->cells[2203] = v0.PLL_S_Frequency; s->cells[2204] = v0.PLL_T_Frequency; return 0; }
    case 341: { LL_PLL_ClocksTypeDef v0 = {args[0], args[1], args[2], args[3], args[4]}; LL_RCC_GetPLL2ClockFreq(&v0); s->cells[2200] = v0.PLL_P_Frequency; s->cells[2201] = v0.PLL_Q_Frequency; s->cells[2202] = v0.PLL_R_Frequency; s->cells[2203] = v0.PLL_S_Frequency; s->cells[2204] = v0.PLL_T_Frequency; return 0; }
    case 342: { LL_PLL_ClocksTypeDef v0 = {args[0], args[1], args[2], args[3], args[4]}; LL_RCC_GetPLL3ClockFreq(&v0); s->cells[2200] = v0.PLL_P_Frequency; s->cells[2201] = v0.PLL_Q_Frequency; s->cells[2202] = v0.PLL_R_Frequency; s->cells[2203] = v0.PLL_S_Frequency; s->cells[2204] = v0.PLL_T_Frequency; return 0; }
    case 343: { LL_PLL_SpreadSpectrumTypeDef v0 = {(uint16_t)args[0], (uint16_t)args[1], (uint16_t)args[2], (uint16_t)args[3], (uint16_t)args[4]}; LL_RCC_PLL1_ConfigSpreadSpectrum(&v0); s->cells[2200] = v0.ModulationPeriod; s->cells[2201] = v0.IncrementStep; s->cells[2202] = v0.SpreadMode; s->cells[2203] = v0.DitheringRPDFN; s->cells[2204] = v0.DitheringTPDFN; return 0; }
    case 344: { LL_PLL_SpreadSpectrumTypeDef v0 = {(uint16_t)args[0], (uint16_t)args[1], (uint16_t)args[2], (uint16_t)args[3], (uint16_t)args[4]}; LL_RCC_PLL2_ConfigSpreadSpectrum(&v0); s->cells[2200] = v0.ModulationPeriod; s->cells[2201] = v0.IncrementStep; s->cells[2202] = v0.SpreadMode; s->cells[2203] = v0.DitheringRPDFN; s->cells[2204] = v0.DitheringTPDFN; return 0; }
    case 345: { LL_PLL_SpreadSpectrumTypeDef v0 = {(uint16_t)args[0], (uint16_t)args[1], (uint16_t)args[2], (uint16_t)args[3], (uint16_t)args[4]}; LL_RCC_PLL3_ConfigSpreadSpectrum(&v0); s->cells[2200] = v0.ModulationPeriod; s->cells[2201] = v0.IncrementStep; s->cells[2202] = v0.SpreadMode; s->cells[2203] = v0.DitheringRPDFN; s->cells[2204] = v0.DitheringTPDFN; return 0; }
    case 346: { uint32_t result = LL_RCC_GetUSARTClockFreq(args[0]); return result; }
    case 347: { uint32_t result = LL_RCC_GetUARTClockFreq(args[0]); return result; }
    case 348: { uint32_t result = LL_RCC_GetLPUARTClockFreq(args[0]); return result; }
    case 349: { uint32_t result = LL_RCC_GetI2CClockFreq(args[0]); return result; }
    case 350: { uint32_t result = LL_RCC_GetI3CClockFreq(args[0]); return result; }
    case 351: { uint32_t result = LL_RCC_GetLPTIMClockFreq(args[0]); return result; }
    case 352: { uint32_t result = LL_RCC_GetSAIClockFreq(args[0]); return result; }
    case 353: { uint32_t result = LL_RCC_GetADCClockFreq(args[0]); return result; }
    case 354: { uint32_t result = LL_RCC_GetSDMMCClockFreq(args[0]); return result; }
    case 355: { uint32_t result = LL_RCC_GetCECClockFreq(args[0]); return result; }
    case 356: { uint32_t result = LL_RCC_GetPSSIClockFreq(args[0]); return result; }
    case 357: { uint32_t result = LL_RCC_GetUSBPHYCClockFreq(args[0]); return result; }
    case 358: { uint32_t result = LL_RCC_GetADFClockFreq(args[0]); return result; }
    case 359: { uint32_t result = LL_RCC_GetSPDIFRXClockFreq(args[0]); return result; }
    case 360: { uint32_t result = LL_RCC_GetSPIClockFreq(args[0]); return result; }
    case 361: { uint32_t result = LL_RCC_GetETHPHYClockFreq(args[0]); return result; }
    case 362: { uint32_t result = LL_RCC_GetFDCANClockFreq(args[0]); return result; }
    case 363: { uint32_t result = LL_RCC_GetFMCClockFreq(args[0]); return result; }
    case 364: { uint32_t result = LL_RCC_GetXSPIClockFreq(args[0]); return result; }
    case 365: { uint32_t result = LL_RCC_GetCLKPClockFreq(args[0]); return result; }
    case 366: { LL_CRS_EnableFreqErrorCounter(); return 0; }
    case 367: { LL_CRS_DisableFreqErrorCounter(); return 0; }
    case 368: { uint32_t result = LL_CRS_IsEnabledFreqErrorCounter(); return result; }
    case 369: { LL_CRS_EnableAutoTrimming(); return 0; }
    case 370: { LL_CRS_DisableAutoTrimming(); return 0; }
    case 371: { uint32_t result = LL_CRS_IsEnabledAutoTrimming(); return result; }
    case 372: { LL_CRS_SetHSI48SmoothTrimming(args[0]); return 0; }
    case 373: { uint32_t result = LL_CRS_GetHSI48SmoothTrimming(); return result; }
    case 374: { LL_CRS_SetReloadCounter(args[0]); return 0; }
    case 375: { uint32_t result = LL_CRS_GetReloadCounter(); return result; }
    case 376: { LL_CRS_SetFreqErrorLimit(args[0]); return 0; }
    case 377: { uint32_t result = LL_CRS_GetFreqErrorLimit(); return result; }
    case 378: { LL_CRS_SetSyncDivider(args[0]); return 0; }
    case 379: { uint32_t result = LL_CRS_GetSyncDivider(); return result; }
    case 380: { LL_CRS_SetSyncSignalSource(args[0]); return 0; }
    case 381: { uint32_t result = LL_CRS_GetSyncSignalSource(); return result; }
    case 382: { LL_CRS_SetSyncPolarity(args[0]); return 0; }
    case 383: { uint32_t result = LL_CRS_GetSyncPolarity(); return result; }
    case 384: { LL_CRS_ConfigSynchronization(args[0], args[1], args[2], args[3]); return 0; }
    case 385: { LL_CRS_GenerateEvent_SWSYNC(); return 0; }
    case 386: { uint32_t result = LL_CRS_GetFreqErrorDirection(); return result; }
    case 387: { uint32_t result = LL_CRS_GetFreqErrorCapture(); return result; }
    case 388: { uint32_t result = LL_CRS_IsActiveFlag_SYNCOK(); return result; }
    case 389: { uint32_t result = LL_CRS_IsActiveFlag_SYNCWARN(); return result; }
    case 390: { uint32_t result = LL_CRS_IsActiveFlag_ERR(); return result; }
    case 391: { uint32_t result = LL_CRS_IsActiveFlag_ESYNC(); return result; }
    case 392: { uint32_t result = LL_CRS_IsActiveFlag_SYNCERR(); return result; }
    case 393: { uint32_t result = LL_CRS_IsActiveFlag_SYNCMISS(); return result; }
    case 394: { uint32_t result = LL_CRS_IsActiveFlag_TRIMOVF(); return result; }
    case 395: { LL_CRS_ClearFlag_SYNCOK(); return 0; }
    case 396: { LL_CRS_ClearFlag_SYNCWARN(); return 0; }
    case 397: { LL_CRS_ClearFlag_ERR(); return 0; }
    case 398: { LL_CRS_ClearFlag_ESYNC(); return 0; }
    case 399: { LL_CRS_EnableIT_SYNCOK(); return 0; }
    case 400: { LL_CRS_DisableIT_SYNCOK(); return 0; }
    case 401: { uint32_t result = LL_CRS_IsEnabledIT_SYNCOK(); return result; }
    case 402: { LL_CRS_EnableIT_SYNCWARN(); return 0; }
    case 403: { LL_CRS_DisableIT_SYNCWARN(); return 0; }
    case 404: { uint32_t result = LL_CRS_IsEnabledIT_SYNCWARN(); return result; }
    case 405: { LL_CRS_EnableIT_ERR(); return 0; }
    case 406: { LL_CRS_DisableIT_ERR(); return 0; }
    case 407: { uint32_t result = LL_CRS_IsEnabledIT_ERR(); return result; }
    case 408: { LL_CRS_EnableIT_ESYNC(); return 0; }
    case 409: { LL_CRS_DisableIT_ESYNC(); return 0; }
    case 410: { uint32_t result = LL_CRS_IsEnabledIT_ESYNC(); return result; }
    case 411: { uint32_t result = LL_CRS_DeInit(); return result; }
    case 412: { uint32_t result = LL_GetUID_Word0(); return result; }
    case 413: { uint32_t result = LL_GetUID_Word1(); return result; }
    case 414: { uint32_t result = LL_GetUID_Word2(); return result; }
    case 415: { uint32_t result = LL_GetPackageType(); return result; }
    case 416: { LL_InitTick(args[0], args[1]); return 0; }
    case 417: { LL_Init1msTick(args[0]); return 0; }
    case 418: { LL_mDelay(args[0]); return 0; }
    case 419: { LL_SetSystemCoreClock(args[0]); return 0; }
    case 420: { LL_UTILS_PLLInitTypeDef v0 = {args[0], args[1], args[2], args[3], args[4], args[5]}; LL_UTILS_ClkInitTypeDef v1 = {args[6], args[7], args[8], args[9], args[10], args[11]}; uint32_t result = LL_PLL_ConfigSystemClock_HSI(&v0, &v1); s->cells[2200] = v0.PLLM; s->cells[2201] = v0.PLLN; s->cells[2202] = v0.PLLP; s->cells[2203] = v0.FRACN; s->cells[2204] = v0.VCO_Input; s->cells[2205] = v0.VCO_Output; s->cells[2206] = v1.SYSCLKDivider; s->cells[2207] = v1.AHBCLKDivider; s->cells[2208] = v1.APB1CLKDivider; s->cells[2209] = v1.APB2CLKDivider; s->cells[2210] = v1.APB4CLKDivider; s->cells[2211] = v1.APB5CLKDivider; return result; }
    case 421: { LL_UTILS_PLLInitTypeDef v0 = {args[0], args[1], args[2], args[3], args[4], args[5]}; LL_UTILS_ClkInitTypeDef v1 = {args[6], args[7], args[8], args[9], args[10], args[11]}; uint32_t result = LL_PLL_ConfigSystemClock_CSI(&v0, &v1); s->cells[2200] = v0.PLLM; s->cells[2201] = v0.PLLN; s->cells[2202] = v0.PLLP; s->cells[2203] = v0.FRACN; s->cells[2204] = v0.VCO_Input; s->cells[2205] = v0.VCO_Output; s->cells[2206] = v1.SYSCLKDivider; s->cells[2207] = v1.AHBCLKDivider; s->cells[2208] = v1.APB1CLKDivider; s->cells[2209] = v1.APB2CLKDivider; s->cells[2210] = v1.APB4CLKDivider; s->cells[2211] = v1.APB5CLKDivider; return result; }
    case 422: { LL_UTILS_PLLInitTypeDef v2 = {args[2], args[3], args[4], args[5], args[6], args[7]}; LL_UTILS_ClkInitTypeDef v3 = {args[8], args[9], args[10], args[11], args[12], args[13]}; uint32_t result = LL_PLL_ConfigSystemClock_HSE(args[0], args[1], &v2, &v3); s->cells[2200] = v2.PLLM; s->cells[2201] = v2.PLLN; s->cells[2202] = v2.PLLP; s->cells[2203] = v2.FRACN; s->cells[2204] = v2.VCO_Input; s->cells[2205] = v2.VCO_Output; s->cells[2206] = v3.SYSCLKDivider; s->cells[2207] = v3.AHBCLKDivider; s->cells[2208] = v3.APB1CLKDivider; s->cells[2209] = v3.APB2CLKDivider; s->cells[2210] = v3.APB4CLKDivider; s->cells[2211] = v3.APB5CLKDivider; return result; }
    case 423: { uint32_t result = LL_SetFlashLatency(args[0]); return result; }
    case 424: return LL_RCC_CALC_SYSCLK_FREQ(args[0], args[1]);
    case 425: return LL_RCC_CALC_HCLK_FREQ(args[0], args[1]);
    case 426: return LL_RCC_CALC_PCLK1_FREQ(args[0], args[1]);
    case 427: return LL_RCC_CALC_PCLK2_FREQ(args[0], args[1]);
    case 428: return LL_RCC_CALC_PCLK4_FREQ(args[0], args[1]);
    case 429: return LL_RCC_CALC_PCLK5_FREQ(args[0], args[1]);
    case 430: return LL_CLKSOURCE_SHIFT(args[0]);
    case 431: return LL_CLKSOURCE_MASK(args[0]);
    case 432: return LL_CLKSOURCE_CONFIG(args[0]);
    case 433: return LL_CLKSOURCE_REG(args[0]);
    case 434: return LL_CLKSOURCE(args[0], args[1], args[2], args[3]);
    case 435: return __LL_CRS_CALC_CALCULATE_RELOADVALUE(args[0], args[1]);
    case 436: LL_RCC_WriteReg(CR, args[0]); return LL_RCC_ReadReg(CR);
    case 437: LL_CRS_WriteReg(CRS, CFGR, args[0]); return LL_CRS_ReadReg(CRS, CFGR);
    default: abort();
  }
}
uint32_t CL50_Constant(uint32_t index) {
  switch(index) {
    case 0: return LL_RCC_REG_SHIFT;
    case 1: return LL_RCC_POS_SHIFT;
    case 2: return LL_RCC_CONFIG_SHIFT;
    case 3: return LL_RCC_MASK_SHIFT;
    case 4: return LL_RCC_HSI_DIV_1;
    case 5: return LL_RCC_HSI_DIV_2;
    case 6: return LL_RCC_HSI_DIV_4;
    case 7: return LL_RCC_HSI_DIV_8;
    case 8: return LL_RCC_SWP_XSPI1_NEUTRAL;
    case 9: return LL_RCC_SWP_XSPI1_HCLK5;
    case 10: return LL_RCC_SWP_XSPI1_PLL2S;
    case 11: return LL_RCC_SWP_XSPI1_PLL2T;
    case 12: return LL_RCC_SWP_XSPI1_HCLK_DIV4;
    case 13: return LL_RCC_SWP_XSPI2_NEUTRAL;
    case 14: return LL_RCC_SWP_XSPI2_HCLK5;
    case 15: return LL_RCC_SWP_XSPI2_PLL2S;
    case 16: return LL_RCC_SWP_XSPI2_PLL2T;
    case 17: return LL_RCC_SWP_XSPI2_HCLK_DIV4;
    case 18: return LL_RCC_SWP_FMC_NEUTRAL;
    case 19: return LL_RCC_SWP_FMC_HCLK5;
    case 20: return LL_RCC_SWP_FMC_PLL1Q;
    case 21: return LL_RCC_SWP_FMC_PLL2R;
    case 22: return LL_RCC_SWP_FMC_HSI;
    case 23: return LL_RCC_SWP_FMC_HCLK_DIV4;
    case 24: return LL_RCC_LSEDRIVE_LOW;
    case 25: return LL_RCC_LSEDRIVE_MEDIUMLOW;
    case 26: return LL_RCC_LSEDRIVE_MEDIUMHIGH;
    case 27: return LL_RCC_LSEDRIVE_HIGH;
    case 28: return LL_RCC_SYS_CLKSOURCE_HSI;
    case 29: return LL_RCC_SYS_CLKSOURCE_CSI;
    case 30: return LL_RCC_SYS_CLKSOURCE_HSE;
    case 31: return LL_RCC_SYS_CLKSOURCE_PLL1;
    case 32: return LL_RCC_SYS_CLKSOURCE_STATUS_HSI;
    case 33: return LL_RCC_SYS_CLKSOURCE_STATUS_CSI;
    case 34: return LL_RCC_SYS_CLKSOURCE_STATUS_HSE;
    case 35: return LL_RCC_SYS_CLKSOURCE_STATUS_PLL1;
    case 36: return LL_RCC_SYSWAKEUP_CLKSOURCE_HSI;
    case 37: return LL_RCC_SYSWAKEUP_CLKSOURCE_CSI;
    case 38: return LL_RCC_KERWAKEUP_CLKSOURCE_HSI;
    case 39: return LL_RCC_KERWAKEUP_CLKSOURCE_CSI;
    case 40: return LL_RCC_SYSCLK_DIV_1;
    case 41: return LL_RCC_SYSCLK_DIV_2;
    case 42: return LL_RCC_SYSCLK_DIV_4;
    case 43: return LL_RCC_SYSCLK_DIV_8;
    case 44: return LL_RCC_SYSCLK_DIV_16;
    case 45: return LL_RCC_SYSCLK_DIV_64;
    case 46: return LL_RCC_SYSCLK_DIV_128;
    case 47: return LL_RCC_SYSCLK_DIV_256;
    case 48: return LL_RCC_SYSCLK_DIV_512;
    case 49: return LL_RCC_AHB_DIV_1;
    case 50: return LL_RCC_AHB_DIV_2;
    case 51: return LL_RCC_AHB_DIV_4;
    case 52: return LL_RCC_AHB_DIV_8;
    case 53: return LL_RCC_AHB_DIV_16;
    case 54: return LL_RCC_AHB_DIV_64;
    case 55: return LL_RCC_AHB_DIV_128;
    case 56: return LL_RCC_AHB_DIV_256;
    case 57: return LL_RCC_AHB_DIV_512;
    case 58: return LL_RCC_APB1_DIV_1;
    case 59: return LL_RCC_APB1_DIV_2;
    case 60: return LL_RCC_APB1_DIV_4;
    case 61: return LL_RCC_APB1_DIV_8;
    case 62: return LL_RCC_APB1_DIV_16;
    case 63: return LL_RCC_APB2_DIV_1;
    case 64: return LL_RCC_APB2_DIV_2;
    case 65: return LL_RCC_APB2_DIV_4;
    case 66: return LL_RCC_APB2_DIV_8;
    case 67: return LL_RCC_APB2_DIV_16;
    case 68: return LL_RCC_APB4_DIV_1;
    case 69: return LL_RCC_APB4_DIV_2;
    case 70: return LL_RCC_APB4_DIV_4;
    case 71: return LL_RCC_APB4_DIV_8;
    case 72: return LL_RCC_APB4_DIV_16;
    case 73: return LL_RCC_APB5_DIV_1;
    case 74: return LL_RCC_APB5_DIV_2;
    case 75: return LL_RCC_APB5_DIV_4;
    case 76: return LL_RCC_APB5_DIV_8;
    case 77: return LL_RCC_APB5_DIV_16;
    case 78: return LL_RCC_MCO1SOURCE_HSI;
    case 79: return LL_RCC_MCO1SOURCE_LSE;
    case 80: return LL_RCC_MCO1SOURCE_HSE;
    case 81: return LL_RCC_MCO1SOURCE_PLL1Q;
    case 82: return LL_RCC_MCO1SOURCE_HSI48;
    case 83: return LL_RCC_MCO2SOURCE_SYSCLK;
    case 84: return LL_RCC_MCO2SOURCE_PLL2P;
    case 85: return LL_RCC_MCO2SOURCE_HSE;
    case 86: return LL_RCC_MCO2SOURCE_PLL1P;
    case 87: return LL_RCC_MCO2SOURCE_CSI;
    case 88: return LL_RCC_MCO2SOURCE_LSI;
    case 89: return LL_RCC_MCO1_DIV_1;
    case 90: return LL_RCC_MCO1_DIV_2;
    case 91: return LL_RCC_MCO1_DIV_3;
    case 92: return LL_RCC_MCO1_DIV_4;
    case 93: return LL_RCC_MCO1_DIV_5;
    case 94: return LL_RCC_MCO1_DIV_6;
    case 95: return LL_RCC_MCO1_DIV_7;
    case 96: return LL_RCC_MCO1_DIV_8;
    case 97: return LL_RCC_MCO1_DIV_9;
    case 98: return LL_RCC_MCO1_DIV_10;
    case 99: return LL_RCC_MCO1_DIV_11;
    case 100: return LL_RCC_MCO1_DIV_12;
    case 101: return LL_RCC_MCO1_DIV_13;
    case 102: return LL_RCC_MCO1_DIV_14;
    case 103: return LL_RCC_MCO1_DIV_15;
    case 104: return LL_RCC_MCO2_DIV_1;
    case 105: return LL_RCC_MCO2_DIV_2;
    case 106: return LL_RCC_MCO2_DIV_3;
    case 107: return LL_RCC_MCO2_DIV_4;
    case 108: return LL_RCC_MCO2_DIV_5;
    case 109: return LL_RCC_MCO2_DIV_6;
    case 110: return LL_RCC_MCO2_DIV_7;
    case 111: return LL_RCC_MCO2_DIV_8;
    case 112: return LL_RCC_MCO2_DIV_9;
    case 113: return LL_RCC_MCO2_DIV_10;
    case 114: return LL_RCC_MCO2_DIV_11;
    case 115: return LL_RCC_MCO2_DIV_12;
    case 116: return LL_RCC_MCO2_DIV_13;
    case 117: return LL_RCC_MCO2_DIV_14;
    case 118: return LL_RCC_MCO2_DIV_15;
    case 119: return LL_RCC_RTC_NOCLOCK;
    case 120: return LL_RCC_RTC_HSE_DIV_2;
    case 121: return LL_RCC_RTC_HSE_DIV_3;
    case 122: return LL_RCC_RTC_HSE_DIV_4;
    case 123: return LL_RCC_RTC_HSE_DIV_5;
    case 124: return LL_RCC_RTC_HSE_DIV_6;
    case 125: return LL_RCC_RTC_HSE_DIV_7;
    case 126: return LL_RCC_RTC_HSE_DIV_8;
    case 127: return LL_RCC_RTC_HSE_DIV_9;
    case 128: return LL_RCC_RTC_HSE_DIV_10;
    case 129: return LL_RCC_RTC_HSE_DIV_11;
    case 130: return LL_RCC_RTC_HSE_DIV_12;
    case 131: return LL_RCC_RTC_HSE_DIV_13;
    case 132: return LL_RCC_RTC_HSE_DIV_14;
    case 133: return LL_RCC_RTC_HSE_DIV_15;
    case 134: return LL_RCC_RTC_HSE_DIV_16;
    case 135: return LL_RCC_RTC_HSE_DIV_17;
    case 136: return LL_RCC_RTC_HSE_DIV_18;
    case 137: return LL_RCC_RTC_HSE_DIV_19;
    case 138: return LL_RCC_RTC_HSE_DIV_20;
    case 139: return LL_RCC_RTC_HSE_DIV_21;
    case 140: return LL_RCC_RTC_HSE_DIV_22;
    case 141: return LL_RCC_RTC_HSE_DIV_23;
    case 142: return LL_RCC_RTC_HSE_DIV_24;
    case 143: return LL_RCC_RTC_HSE_DIV_25;
    case 144: return LL_RCC_RTC_HSE_DIV_26;
    case 145: return LL_RCC_RTC_HSE_DIV_27;
    case 146: return LL_RCC_RTC_HSE_DIV_28;
    case 147: return LL_RCC_RTC_HSE_DIV_29;
    case 148: return LL_RCC_RTC_HSE_DIV_30;
    case 149: return LL_RCC_RTC_HSE_DIV_31;
    case 150: return LL_RCC_RTC_HSE_DIV_32;
    case 151: return LL_RCC_RTC_HSE_DIV_33;
    case 152: return LL_RCC_RTC_HSE_DIV_34;
    case 153: return LL_RCC_RTC_HSE_DIV_35;
    case 154: return LL_RCC_RTC_HSE_DIV_36;
    case 155: return LL_RCC_RTC_HSE_DIV_37;
    case 156: return LL_RCC_RTC_HSE_DIV_38;
    case 157: return LL_RCC_RTC_HSE_DIV_39;
    case 158: return LL_RCC_RTC_HSE_DIV_40;
    case 159: return LL_RCC_RTC_HSE_DIV_41;
    case 160: return LL_RCC_RTC_HSE_DIV_42;
    case 161: return LL_RCC_RTC_HSE_DIV_43;
    case 162: return LL_RCC_RTC_HSE_DIV_44;
    case 163: return LL_RCC_RTC_HSE_DIV_45;
    case 164: return LL_RCC_RTC_HSE_DIV_46;
    case 165: return LL_RCC_RTC_HSE_DIV_47;
    case 166: return LL_RCC_RTC_HSE_DIV_48;
    case 167: return LL_RCC_RTC_HSE_DIV_49;
    case 168: return LL_RCC_RTC_HSE_DIV_50;
    case 169: return LL_RCC_RTC_HSE_DIV_51;
    case 170: return LL_RCC_RTC_HSE_DIV_52;
    case 171: return LL_RCC_RTC_HSE_DIV_53;
    case 172: return LL_RCC_RTC_HSE_DIV_54;
    case 173: return LL_RCC_RTC_HSE_DIV_55;
    case 174: return LL_RCC_RTC_HSE_DIV_56;
    case 175: return LL_RCC_RTC_HSE_DIV_57;
    case 176: return LL_RCC_RTC_HSE_DIV_58;
    case 177: return LL_RCC_RTC_HSE_DIV_59;
    case 178: return LL_RCC_RTC_HSE_DIV_60;
    case 179: return LL_RCC_RTC_HSE_DIV_61;
    case 180: return LL_RCC_RTC_HSE_DIV_62;
    case 181: return LL_RCC_RTC_HSE_DIV_63;
    case 182: return LL_RCC_ADC_CLKSOURCE_PLL2P;
    case 183: return LL_RCC_ADC_CLKSOURCE_PLL3R;
    case 184: return LL_RCC_ADC_CLKSOURCE_CLKP;
    case 185: return LL_RCC_ADF1_CLKSOURCE_HCLK;
    case 186: return LL_RCC_ADF1_CLKSOURCE_PLL2P;
    case 187: return LL_RCC_ADF1_CLKSOURCE_PLL3P;
    case 188: return LL_RCC_ADF1_CLKSOURCE_I2S_CKIN;
    case 189: return LL_RCC_ADF1_CLKSOURCE_CSI;
    case 190: return LL_RCC_ADF1_CLKSOURCE_HSI;
    case 191: return LL_RCC_CEC_CLKSOURCE_LSE;
    case 192: return LL_RCC_CEC_CLKSOURCE_LSI;
    case 193: return LL_RCC_CEC_CLKSOURCE_CSI_DIV_122;
    case 194: return LL_RCC_CLKP_CLKSOURCE_HSI;
    case 195: return LL_RCC_CLKP_CLKSOURCE_CSI;
    case 196: return LL_RCC_CLKP_CLKSOURCE_HSE;
    case 197: return LL_RCC_ETH1PHY_CLKSOURCE_HSE;
    case 198: return LL_RCC_ETH1PHY_CLKSOURCE_PLL3S;
    case 199: return LL_RCC_ETH1REF_CLKSOURCE_RMII;
    case 200: return LL_RCC_ETH1REF_CLKSOURCE_HSE;
    case 201: return LL_RCC_ETH1REF_CLKSOURCE_FB;
    case 202: return LL_RCC_FDCAN_CLKSOURCE_HSE;
    case 203: return LL_RCC_FDCAN_CLKSOURCE_PLL1Q;
    case 204: return LL_RCC_FDCAN_CLKSOURCE_PLL2Q;
    case 205: return LL_RCC_FMC_CLKSOURCE_HCLK;
    case 206: return LL_RCC_FMC_CLKSOURCE_PLL1Q;
    case 207: return LL_RCC_FMC_CLKSOURCE_PLL2R;
    case 208: return LL_RCC_FMC_CLKSOURCE_HSI;
    case 209: return LL_RCC_FMC_CLKSOURCE_HCLK_DIV4;
    case 210: return LL_RCC_I2C1_CLKSOURCE_PCLK1;
    case 211: return LL_RCC_I2C1_CLKSOURCE_PLL3R;
    case 212: return LL_RCC_I2C1_CLKSOURCE_HSI;
    case 213: return LL_RCC_I2C1_CLKSOURCE_CSI;
    case 214: return LL_RCC_I2C23_CLKSOURCE_PCLK1;
    case 215: return LL_RCC_I2C23_CLKSOURCE_PLL3R;
    case 216: return LL_RCC_I2C23_CLKSOURCE_HSI;
    case 217: return LL_RCC_I2C23_CLKSOURCE_CSI;
    case 218: return LL_RCC_I3C1_CLKSOURCE_PCLK1;
    case 219: return LL_RCC_I3C1_CLKSOURCE_PLL3R;
    case 220: return LL_RCC_I3C1_CLKSOURCE_HSI;
    case 221: return LL_RCC_I3C1_CLKSOURCE_CSI;
    case 222: return LL_RCC_LPTIM1_CLKSOURCE_PCLK1;
    case 223: return LL_RCC_LPTIM1_CLKSOURCE_PLL2P;
    case 224: return LL_RCC_LPTIM1_CLKSOURCE_PLL3R;
    case 225: return LL_RCC_LPTIM1_CLKSOURCE_LSE;
    case 226: return LL_RCC_LPTIM1_CLKSOURCE_LSI;
    case 227: return LL_RCC_LPTIM1_CLKSOURCE_CLKP;
    case 228: return LL_RCC_LPTIM23_CLKSOURCE_PCLK4;
    case 229: return LL_RCC_LPTIM23_CLKSOURCE_PLL2P;
    case 230: return LL_RCC_LPTIM23_CLKSOURCE_PLL3R;
    case 231: return LL_RCC_LPTIM23_CLKSOURCE_LSE;
    case 232: return LL_RCC_LPTIM23_CLKSOURCE_LSI;
    case 233: return LL_RCC_LPTIM23_CLKSOURCE_CLKP;
    case 234: return LL_RCC_LPTIM45_CLKSOURCE_PCLK4;
    case 235: return LL_RCC_LPTIM45_CLKSOURCE_PLL2P;
    case 236: return LL_RCC_LPTIM45_CLKSOURCE_PLL3R;
    case 237: return LL_RCC_LPTIM45_CLKSOURCE_LSE;
    case 238: return LL_RCC_LPTIM45_CLKSOURCE_LSI;
    case 239: return LL_RCC_LPTIM45_CLKSOURCE_CLKP;
    case 240: return LL_RCC_LPUART1_CLKSOURCE_PCLK4;
    case 241: return LL_RCC_LPUART1_CLKSOURCE_PLL2Q;
    case 242: return LL_RCC_LPUART1_CLKSOURCE_PLL3Q;
    case 243: return LL_RCC_LPUART1_CLKSOURCE_HSI;
    case 244: return LL_RCC_LPUART1_CLKSOURCE_CSI;
    case 245: return LL_RCC_LPUART1_CLKSOURCE_LSE;
    case 246: return LL_RCC_LTDC_CLKSOURCE_PLL3R;
    case 247: return LL_RCC_PSSI_CLKSOURCE_PLL3R;
    case 248: return LL_RCC_PSSI_CLKSOURCE_CLKP;
    case 249: return LL_RCC_SAI1_CLKSOURCE_PLL1Q;
    case 250: return LL_RCC_SAI1_CLKSOURCE_PLL2P;
    case 251: return LL_RCC_SAI1_CLKSOURCE_PLL3P;
    case 252: return LL_RCC_SAI1_CLKSOURCE_I2S_CKIN;
    case 253: return LL_RCC_SAI1_CLKSOURCE_CLKP;
    case 254: return LL_RCC_SAI2_CLKSOURCE_PLL1Q;
    case 255: return LL_RCC_SAI2_CLKSOURCE_PLL2P;
    case 256: return LL_RCC_SAI2_CLKSOURCE_PLL3P;
    case 257: return LL_RCC_SAI2_CLKSOURCE_I2S_CKIN;
    case 258: return LL_RCC_SAI2_CLKSOURCE_CLKP;
    case 259: return LL_RCC_SAI2_CLKSOURCE_SPDIFRX;
    case 260: return LL_RCC_SDMMC_CLKSOURCE_PLL2S;
    case 261: return LL_RCC_SDMMC_CLKSOURCE_PLL2T;
    case 262: return LL_RCC_SPDIFRX_CLKSOURCE_PLL1Q;
    case 263: return LL_RCC_SPDIFRX_CLKSOURCE_PLL2R;
    case 264: return LL_RCC_SPDIFRX_CLKSOURCE_PLL3R;
    case 265: return LL_RCC_SPDIFRX_CLKSOURCE_HSI;
    case 266: return LL_RCC_SPI1_CLKSOURCE_PLL1Q;
    case 267: return LL_RCC_SPI1_CLKSOURCE_PLL2P;
    case 268: return LL_RCC_SPI1_CLKSOURCE_PLL3P;
    case 269: return LL_RCC_SPI1_CLKSOURCE_I2S_CKIN;
    case 270: return LL_RCC_SPI1_CLKSOURCE_CLKP;
    case 271: return LL_RCC_SPI23_CLKSOURCE_PLL1Q;
    case 272: return LL_RCC_SPI23_CLKSOURCE_PLL2P;
    case 273: return LL_RCC_SPI23_CLKSOURCE_PLL3P;
    case 274: return LL_RCC_SPI23_CLKSOURCE_I2S_CKIN;
    case 275: return LL_RCC_SPI23_CLKSOURCE_CLKP;
    case 276: return LL_RCC_SPI45_CLKSOURCE_PCLK2;
    case 277: return LL_RCC_SPI45_CLKSOURCE_PLL2Q;
    case 278: return LL_RCC_SPI45_CLKSOURCE_PLL3Q;
    case 279: return LL_RCC_SPI45_CLKSOURCE_HSI;
    case 280: return LL_RCC_SPI45_CLKSOURCE_CSI;
    case 281: return LL_RCC_SPI45_CLKSOURCE_HSE;
    case 282: return LL_RCC_SPI6_CLKSOURCE_PCLK4;
    case 283: return LL_RCC_SPI6_CLKSOURCE_PLL2Q;
    case 284: return LL_RCC_SPI6_CLKSOURCE_PLL3Q;
    case 285: return LL_RCC_SPI6_CLKSOURCE_HSI;
    case 286: return LL_RCC_SPI6_CLKSOURCE_CSI;
    case 287: return LL_RCC_SPI6_CLKSOURCE_HSE;
    case 288: return LL_RCC_USART1_CLKSOURCE_PCLK2;
    case 289: return LL_RCC_USART1_CLKSOURCE_PLL2Q;
    case 290: return LL_RCC_USART1_CLKSOURCE_PLL3Q;
    case 291: return LL_RCC_USART1_CLKSOURCE_HSI;
    case 292: return LL_RCC_USART1_CLKSOURCE_CSI;
    case 293: return LL_RCC_USART1_CLKSOURCE_LSE;
    case 294: return LL_RCC_USART234578_CLKSOURCE_PCLK1;
    case 295: return LL_RCC_USART234578_CLKSOURCE_PLL2Q;
    case 296: return LL_RCC_USART234578_CLKSOURCE_PLL3Q;
    case 297: return LL_RCC_USART234578_CLKSOURCE_HSI;
    case 298: return LL_RCC_USART234578_CLKSOURCE_CSI;
    case 299: return LL_RCC_USART234578_CLKSOURCE_LSE;
    case 300: return LL_RCC_OTGFS_CLKSOURCE_HSI48;
    case 301: return LL_RCC_OTGFS_CLKSOURCE_PLL3Q;
    case 302: return LL_RCC_OTGFS_CLKSOURCE_HSE;
    case 303: return LL_RCC_OTGFS_CLKSOURCE_CLK48;
    case 304: return LL_RCC_USBPHYC_CLKSOURCE_HSE;
    case 305: return LL_RCC_USBPHYC_CLKSOURCE_HSE_DIV_2;
    case 306: return LL_RCC_USBPHYC_CLKSOURCE_PLL3Q;
    case 307: return LL_RCC_USBPHYC_CLKSOURCE_DISABLE;
    case 308: return LL_RCC_USBREF_CLKSOURCE_16M;
    case 309: return LL_RCC_USBREF_CLKSOURCE_19_2M;
    case 310: return LL_RCC_USBREF_CLKSOURCE_20M;
    case 311: return LL_RCC_USBREF_CLKSOURCE_24M;
    case 312: return LL_RCC_USBREF_CLKSOURCE_26M;
    case 313: return LL_RCC_USBREF_CLKSOURCE_32M;
    case 314: return LL_RCC_XSPI1_CLKSOURCE_HCLK;
    case 315: return LL_RCC_XSPI1_CLKSOURCE_PLL2S;
    case 316: return LL_RCC_XSPI1_CLKSOURCE_PLL2T;
    case 317: return LL_RCC_XSPI1_CLKSOURCE_HCLK_DIV4;
    case 318: return LL_RCC_XSPI2_CLKSOURCE_HCLK;
    case 319: return LL_RCC_XSPI2_CLKSOURCE_PLL2S;
    case 320: return LL_RCC_XSPI2_CLKSOURCE_PLL2T;
    case 321: return LL_RCC_XSPI2_CLKSOURCE_HCLK_DIV4;
    case 322: return LL_RCC_ADC_CLKSOURCE;
    case 323: return LL_RCC_ADF1_CLKSOURCE;
    case 324: return LL_RCC_CEC_CLKSOURCE;
    case 325: return LL_RCC_CLKP_CLKSOURCE;
    case 326: return LL_RCC_ETH1PHY_CLKSOURCE;
    case 327: return LL_RCC_ETH1REF_CLKSOURCE;
    case 328: return LL_RCC_FDCAN_CLKSOURCE;
    case 329: return LL_RCC_FMC_CLKSOURCE;
    case 330: return LL_RCC_I2C1_CLKSOURCE;
    case 331: return LL_RCC_I2C23_CLKSOURCE;
    case 332: return LL_RCC_I3C1_CLKSOURCE;
    case 333: return LL_RCC_LPTIM1_CLKSOURCE;
    case 334: return LL_RCC_LPTIM23_CLKSOURCE;
    case 335: return LL_RCC_LPTIM45_CLKSOURCE;
    case 336: return LL_RCC_LPUART1_CLKSOURCE;
    case 337: return LL_RCC_OTGFS_CLKSOURCE;
    case 338: return LL_RCC_PSSI_CLKSOURCE;
    case 339: return LL_RCC_SAI1_CLKSOURCE;
    case 340: return LL_RCC_SAI2_CLKSOURCE;
    case 341: return LL_RCC_SDMMC_CLKSOURCE;
    case 342: return LL_RCC_SPDIFRX_CLKSOURCE;
    case 343: return LL_RCC_SPI1_CLKSOURCE;
    case 344: return LL_RCC_SPI23_CLKSOURCE;
    case 345: return LL_RCC_SPI45_CLKSOURCE;
    case 346: return LL_RCC_SPI6_CLKSOURCE;
    case 347: return LL_RCC_USART1_CLKSOURCE;
    case 348: return LL_RCC_USART234578_CLKSOURCE;
    case 349: return LL_RCC_USBPHYC_CLKSOURCE;
    case 350: return LL_RCC_USBREF_CLKSOURCE;
    case 351: return LL_RCC_XSPI1_CLKSOURCE;
    case 352: return LL_RCC_XSPI2_CLKSOURCE;
    case 353: return LL_RCC_RTC_CLKSOURCE_NONE;
    case 354: return LL_RCC_RTC_CLKSOURCE_LSE;
    case 355: return LL_RCC_RTC_CLKSOURCE_LSI;
    case 356: return LL_RCC_RTC_CLKSOURCE_HSE;
    case 357: return LL_RCC_TIM_PRESCALER_TWICE;
    case 358: return LL_RCC_TIM_PRESCALER_FOUR_TIMES;
    case 359: return LL_RCC_TIM_PRESCALER_DISABLE;
    case 360: return LL_RCC_TIM_PRESCALER_ENABLE;
    case 361: return LL_RCC_PLLSOURCE_HSI;
    case 362: return LL_RCC_PLLSOURCE_CSI;
    case 363: return LL_RCC_PLLSOURCE_HSE;
    case 364: return LL_RCC_PLLSOURCE_NONE;
    case 365: return LL_RCC_PLLINPUTRANGE_1_2;
    case 366: return LL_RCC_PLLINPUTRANGE_2_4;
    case 367: return LL_RCC_PLLINPUTRANGE_4_8;
    case 368: return LL_RCC_PLLINPUTRANGE_8_16;
    case 369: return LL_RCC_PLLVCORANGE_WIDE;
    case 370: return LL_RCC_PLLVCORANGE_MEDIUM;
    case 371: return LL_RCC_PLL_SPREAD_CENTER;
    case 372: return LL_RCC_PLL_SPREAD_DOWN;
    case 373: return LL_RCC_PLL_DITHERING_TPDFN_ENABLE;
    case 374: return LL_RCC_PLL_DITHERING_TPDFN_DISABLE;
    case 375: return LL_RCC_PLL_DITHERING_RPDFN_ENABLE;
    case 376: return LL_RCC_PLL_DITHERING_RPDFN_DISABLE;
    case 377: return LL_RCC_PERIPH_FREQUENCY_NO;
    case 378: return LL_RCC_PERIPH_FREQUENCY_NA;
    case 379: return LL_CRS_ISR_SYNCOKF;
    case 380: return LL_CRS_ISR_SYNCWARNF;
    case 381: return LL_CRS_ISR_ERRF;
    case 382: return LL_CRS_ISR_ESYNCF;
    case 383: return LL_CRS_ISR_SYNCERR;
    case 384: return LL_CRS_ISR_SYNCMISS;
    case 385: return LL_CRS_ISR_TRIMOVF;
    case 386: return LL_CRS_CR_SYNCOKIE;
    case 387: return LL_CRS_CR_SYNCWARNIE;
    case 388: return LL_CRS_CR_ERRIE;
    case 389: return LL_CRS_CR_ESYNCIE;
    case 390: return LL_CRS_SYNC_DIV_1;
    case 391: return LL_CRS_SYNC_DIV_2;
    case 392: return LL_CRS_SYNC_DIV_4;
    case 393: return LL_CRS_SYNC_DIV_8;
    case 394: return LL_CRS_SYNC_DIV_16;
    case 395: return LL_CRS_SYNC_DIV_32;
    case 396: return LL_CRS_SYNC_DIV_64;
    case 397: return LL_CRS_SYNC_DIV_128;
    case 398: return LL_CRS_SYNC_SOURCE_GPIO;
    case 399: return LL_CRS_SYNC_SOURCE_LSE;
    case 400: return LL_CRS_SYNC_SOURCE_OTG_FS;
    case 401: return LL_CRS_SYNC_SOURCE_OTG_HS;
    case 402: return LL_CRS_SYNC_POLARITY_RISING;
    case 403: return LL_CRS_SYNC_POLARITY_FALLING;
    case 404: return LL_CRS_FREQ_ERROR_DIR_UP;
    case 405: return LL_CRS_FREQ_ERROR_DIR_DOWN;
    case 406: return LL_CRS_RELOADVALUE_DEFAULT;
    case 407: return LL_CRS_ERRORLIMIT_DEFAULT;
    case 408: return LL_CRS_HSI48CALIBRATION_DEFAULT;
    case 409: return LL_MAX_DELAY;
    case 410: return LL_UTILS_HSEBYPASS_OFF;
    case 411: return LL_UTILS_HSEBYPASS_ON;
    case 412: return LL_UTILS_PACKAGETYPE_VFQFPN68_GP;
    case 413: return LL_UTILS_PACKAGETYPE_TFBGA100_SMPS_GP;
    case 414: return LL_UTILS_PACKAGETYPE_LQFP100_GP;
    case 415: return LL_UTILS_PACKAGETYPE_LQFP144_GP;
    case 416: return LL_UTILS_PACKAGETYPE_UFBGA144_SMPS_GP;
    case 417: return LL_UTILS_PACKAGETYPE_UFBGA144_SMPS_GFX;
    case 418: return LL_UTILS_PACKAGETYPE_UFBGA169_SMPS_GFX;
    case 419: return LL_UTILS_PACKAGETYPE_UFBGA169_SMPS_GP;
    case 420: return LL_UTILS_PACKAGETYPE_UFBGA176_25_SMPS_GP;
    case 421: return LL_UTILS_PACKAGETYPE_LQFP176_SMPS_GP;
    case 422: return LL_UTILS_PACKAGETYPE_LQFP176_SMPS_GFX;
    case 423: return LL_UTILS_PACKAGETYPE_UFBGA176_25_SMPS_GFX;
    case 424: return LL_UTILS_PACKAGETYPE_TFBGA225_OCTO;
    case 425: return LL_UTILS_PACKAGETYPE_TFBGA225_HEXA;
    case 426: return LL_UTILS_PACKAGETYPE_WLCSP_SMPS_GP;
    case 427: return LL_RCC_PrescTable[0];
    case 428: return LL_RCC_PrescTable[1];
    case 429: return LL_RCC_PrescTable[2];
    case 430: return LL_RCC_PrescTable[3];
    case 431: return LL_RCC_PrescTable[4];
    case 432: return LL_RCC_PrescTable[5];
    case 433: return LL_RCC_PrescTable[6];
    case 434: return LL_RCC_PrescTable[7];
    case 435: return LL_RCC_PrescTable[8];
    case 436: return LL_RCC_PrescTable[9];
    case 437: return LL_RCC_PrescTable[10];
    case 438: return LL_RCC_PrescTable[11];
    case 439: return LL_RCC_PrescTable[12];
    case 440: return LL_RCC_PrescTable[13];
    case 441: return LL_RCC_PrescTable[14];
    case 442: return LL_RCC_PrescTable[15];
    default: abort();
  }
}
