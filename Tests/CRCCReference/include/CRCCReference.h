#ifndef C_RCC_REFERENCE_H
#define C_RCC_REFERENCE_H
#include <stdint.h>

/* Host-only register storage; this does not model clock transitions. */
typedef struct {
  volatile uint32_t CR;
  volatile uint32_t CFGR;
  volatile uint32_t CDCFGR;
  volatile uint32_t BMCFGR;
  volatile uint32_t APBCFGR;
  volatile uint32_t PLLCKSELR;
  volatile uint32_t PLLCFGR;
  volatile uint32_t PLL1DIVR1;
  volatile uint32_t PLL1FRACR;
  volatile uint32_t PLL2DIVR1;
  volatile uint32_t PLL2FRACR;
  volatile uint32_t PLL3DIVR1;
  volatile uint32_t PLL3FRACR;
  volatile uint32_t PLL1DIVR2;
  volatile uint32_t PLL2DIVR2;
  volatile uint32_t PLL3DIVR2;
} CRCCReferenceRegisters;

typedef struct {
  CRCCReferenceRegisters registers;
  uint32_t hsi, csi, hse;
} CRCCReferenceState;

typedef enum {
  CRCCReference_CR,
  CRCCReference_CFGR,
  CRCCReference_CDCFGR,
  CRCCReference_BMCFGR,
  CRCCReference_APBCFGR,
  CRCCReference_PLLCKSELR,
  CRCCReference_PLLCFGR,
  CRCCReference_PLL1DIVR1,
  CRCCReference_PLL1FRACR,
  CRCCReference_PLL2DIVR1,
  CRCCReference_PLL2FRACR,
  CRCCReference_PLL3DIVR1,
  CRCCReference_PLL3FRACR,
  CRCCReference_PLL1DIVR2,
  CRCCReference_PLL2DIVR2,
  CRCCReference_PLL3DIVR2,
  CRCCReference_RegisterCount
} CRCCReferenceRegister;

typedef enum {
  CRCCReference_SysClock,
  CRCCReference_HCLK,
  CRCCReference_PCLK1,
  CRCCReference_PCLK2,
  CRCCReference_PCLK4,
  CRCCReference_PCLK5,
  CRCCReference_PLL1P,
  CRCCReference_PLL1Q,
  CRCCReference_PLL1R,
  CRCCReference_PLL1S,
  CRCCReference_PLL2P,
  CRCCReference_PLL2Q,
  CRCCReference_PLL2R,
  CRCCReference_PLL2S,
  CRCCReference_PLL2T,
  CRCCReference_PLL3P,
  CRCCReference_PLL3Q,
  CRCCReference_PLL3R,
  CRCCReference_PLL3S,
  CRCCReference_ClockCount
} CRCCReferenceClock;

void CRCCReference_Reset(CRCCReferenceState *state, uint32_t hsi, uint32_t csi, uint32_t hse);
void CRCCReference_Set(CRCCReferenceState *state, CRCCReferenceRegister reg, uint32_t value);
uint32_t CRCCReference_GetFrequency(CRCCReferenceState *state, CRCCReferenceClock clock);
#endif
