#include "include/CRCCReference.h"
#include "Upstream/RCCReferenceShim.h"
#include <assert.h>
#include <string.h>

_Thread_local CRCCReferenceState *CRCCReference_Current;

void CRCCReference_Reset(CRCCReferenceState *state, uint32_t hsi, uint32_t csi, uint32_t hse) {
  memset(state, 0, sizeof(*state));
  state->hsi = hsi;
  state->csi = csi;
  state->hse = hse;
}

void CRCCReference_Set(CRCCReferenceState *state, CRCCReferenceRegister reg, uint32_t value) {
  switch (reg) {
    case CRCCReference_CR: state->registers.CR = value; return;
    case CRCCReference_CFGR: state->registers.CFGR = value; return;
    case CRCCReference_CDCFGR: state->registers.CDCFGR = value; return;
    case CRCCReference_BMCFGR: state->registers.BMCFGR = value; return;
    case CRCCReference_APBCFGR: state->registers.APBCFGR = value; return;
    case CRCCReference_PLLCKSELR: state->registers.PLLCKSELR = value; return;
    case CRCCReference_PLLCFGR: state->registers.PLLCFGR = value; return;
    case CRCCReference_PLL1DIVR1: state->registers.PLL1DIVR1 = value; return;
    case CRCCReference_PLL1FRACR: state->registers.PLL1FRACR = value; return;
    case CRCCReference_PLL2DIVR1: state->registers.PLL2DIVR1 = value; return;
    case CRCCReference_PLL2FRACR: state->registers.PLL2FRACR = value; return;
    case CRCCReference_PLL3DIVR1: state->registers.PLL3DIVR1 = value; return;
    case CRCCReference_PLL3FRACR: state->registers.PLL3FRACR = value; return;
    case CRCCReference_PLL1DIVR2: state->registers.PLL1DIVR2 = value; return;
    case CRCCReference_PLL2DIVR2: state->registers.PLL2DIVR2 = value; return;
    case CRCCReference_PLL3DIVR2: state->registers.PLL3DIVR2 = value; return;
    case CRCCReference_RegisterCount: break;
  }
  assert(!"Invalid reference register");
}

uint32_t CRCCReference_GetFrequency(CRCCReferenceState *state, CRCCReferenceClock clock) {
  CRCCReference_Current = state;
  switch (clock) {
    case CRCCReference_SysClock: return HAL_RCC_GetSysClockFreq();
    case CRCCReference_HCLK: return HAL_RCC_GetHCLKFreq();
    case CRCCReference_PCLK1: return HAL_RCC_GetPCLK1Freq();
    case CRCCReference_PCLK2: return HAL_RCC_GetPCLK2Freq();
    case CRCCReference_PCLK4: return HAL_RCC_GetPCLK4Freq();
    case CRCCReference_PCLK5: return HAL_RCC_GetPCLK5Freq();
    case CRCCReference_PLL1P: return HAL_RCC_GetPLL1PFreq();
    case CRCCReference_PLL1Q: return HAL_RCC_GetPLL1QFreq();
    case CRCCReference_PLL1R: return HAL_RCC_GetPLL1RFreq();
    case CRCCReference_PLL1S: return HAL_RCC_GetPLL1SFreq();
    case CRCCReference_PLL2P: return HAL_RCC_GetPLL2PFreq();
    case CRCCReference_PLL2Q: return HAL_RCC_GetPLL2QFreq();
    case CRCCReference_PLL2R: return HAL_RCC_GetPLL2RFreq();
    case CRCCReference_PLL2S: return HAL_RCC_GetPLL2SFreq();
    case CRCCReference_PLL2T: return HAL_RCC_GetPLL2TFreq();
    case CRCCReference_PLL3P: return HAL_RCC_GetPLL3PFreq();
    case CRCCReference_PLL3Q: return HAL_RCC_GetPLL3QFreq();
    case CRCCReference_PLL3R: return HAL_RCC_GetPLL3RFreq();
    case CRCCReference_PLL3S: return HAL_RCC_GetPLL3SFreq();
    case CRCCReference_ClockCount: break;
  }
  assert(!"Invalid reference clock");
  return 0;
}
