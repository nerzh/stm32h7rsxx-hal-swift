#ifndef C_RCC_CONTROL_REFERENCE_H
#define C_RCC_CONTROL_REFERENCE_H
#include <stdint.h>
#include "RCCControlTypes.h"
#include "RCCControlLayouts.h"

typedef enum {
  CRCCControl_CR, CRCCControl_HSICFGR, CRCCControl_CFGR,
  CRCCControl_CDCFGR, CRCCControl_BMCFGR, CRCCControl_APBCFGR,
  CRCCControl_PLLCKSELR, CRCCControl_PLLCFGR,
  CRCCControl_PLL1DIVR1, CRCCControl_PLL1FRACR,
  CRCCControl_PLL2DIVR1, CRCCControl_PLL2FRACR,
  CRCCControl_PLL3DIVR1, CRCCControl_PLL3FRACR,
  CRCCControl_PLL1DIVR2, CRCCControl_PLL2DIVR2, CRCCControl_PLL3DIVR2,
  CRCCControl_BDCR, CRCCControl_CSR, CRCCControl_CIER, CRCCControl_CIFR,
  CRCCControl_CICR, CRCCControl_RSR, CRCCControl_AHB4ENR,
  CRCCControl_PWR_CR1, CRCCControl_FLASH_ACR,
  CRCCControl_RegisterCount
} CRCCControlRegister;

typedef enum {
  CRCCControl_AutoHSI = 1u << 0, CRCCControl_AutoHSE = 1u << 1,
  CRCCControl_AutoCSI = 1u << 2, CRCCControl_AutoHSI48 = 1u << 3,
  CRCCControl_AutoLSI = 1u << 4, CRCCControl_AutoLSE = 1u << 5,
  CRCCControl_AutoPLL1 = 1u << 6, CRCCControl_AutoPLL2 = 1u << 7,
  CRCCControl_AutoPLL3 = 1u << 8, CRCCControl_AutoSystemClock = 1u << 9,
  CRCCControl_AutoHSIDivider = 1u << 10,
  CRCCControl_AutoAll = 0x7FF
} CRCCControlAutomaticTransition;

typedef struct {
  CRCCControlRegister reg;
  uint32_t value;
  uint32_t tickCall;
} CRCCControlWrite;

typedef struct {
  CRCCControlRegister reg;
  uint32_t clearMask, setMask, dueTickCall, active;
} CRCCControlEvent;

typedef struct {
  uint32_t priority, coreClock, tickCall, writeCount;
} CRCCControlInitTickCall;

typedef struct {
  RCC_TypeDef rcc;
  PWR_TypeDef pwr;
  FLASH_TypeDef flash;
  uint32_t hsi, csi, hse;
  uint32_t tick, tickStep, tickCalls;
  uint32_t systemCoreClock, tickPriority;
  uint32_t initTickStatus, initTickCalls;
  CRCCControlInitTickCall initTickHistory[32];
  /* Automatic transitions run on register writes. Delay is measured in future
   * HAL_GetTick calls; zero applies the flag immediately. Disable selected mask
   * bits to model a stuck flag, or schedule explicit events for finer control.
   * CR ready flags and CFGR.SWS are read-only under macro-mediated writes.
   */
  uint32_t automaticTransitions, transitionDelay;
  uint32_t rejectFlashLatency, lockPLLSource;
  CRCCControlEvent events[64];
  uint32_t writeCount;
  CRCCControlWrite writes[512];
  uint32_t hseCSSCallbacks;
  uint32_t gpioCalls, gpioPort, gpioPin, gpioMode, gpioSpeed, gpioPull, gpioAlternate;
} CRCCControlState;

/* Reset zeroes simulated registers and observations, sets oscillator defaults,
 * tickStep=1, priority=15, SystemCoreClock=64 MHz and immediate auto transitions.
 * Set bypasses all hardware behavior and tracing, for test initial conditions.
 * RSR is raw memory: RMVF remains set after a write. CICR writes clear matching
 * CIFR bits but retain the actual CICR written value for inspection.
 * Writes trace macro-mediated writes only; original direct PWR/RSR assignments
 * remain untouched and are observable in the final register snapshot.
 */
void CRCCControl_Reset(CRCCControlState *state);
void CRCCControl_Set(CRCCControlState *state, CRCCControlRegister reg, uint32_t value);
uint32_t CRCCControl_Get(const CRCCControlState *state, CRCCControlRegister reg);
/* Expose the same hardware-only model to the independent Swift implementation.
 * Each call binds the passed state for that operation; no pointer is used later
 * without rebinding. These do not call any RCC algorithm under test.
 */
void CRCCControl_Write(CRCCControlState *state, CRCCControlRegister reg, uint32_t value);
uint32_t CRCCControl_Tick(CRCCControlState *state);
uint32_t CRCCControl_InitTick(CRCCControlState *state, uint32_t priority);
/* Schedule after N future HAL_GetTick calls (zero applies immediately). */
void CRCCControl_ScheduleEvent(CRCCControlState *state, CRCCControlRegister reg,
                              uint32_t clearMask, uint32_t setMask, uint32_t afterTickCalls);
CRCCControlWrite CRCCControl_GetWrite(const CRCCControlState *state, uint32_t index);
CRCCControlInitTickCall CRCCControl_GetInitTickCall(const CRCCControlState *state, uint32_t index);
uint32_t CRCCControl_DeInit(CRCCControlState *state);
uint32_t CRCCControl_OscConfig(CRCCControlState *state, RCC_OscInitTypeDef *configuration);
uint32_t CRCCControl_ClockConfig(CRCCControlState *state, const RCC_ClkInitTypeDef *configuration, uint32_t latency);
void CRCCControl_GetOscConfig(CRCCControlState *state, RCC_OscInitTypeDef *configuration);
void CRCCControl_GetClockConfig(CRCCControlState *state, RCC_ClkInitTypeDef *configuration, uint32_t *latency);
void CRCCControl_EnableCSS(CRCCControlState *state);
void CRCCControl_DisableCSS(CRCCControlState *state);
void CRCCControl_NMI(CRCCControlState *state);
uint32_t CRCCControl_GetResetSource(CRCCControlState *state);
uint32_t CRCCControl_PLLConfig(CRCCControlState *state, uint32_t index, const RCC_PLLInitTypeDef *configuration);
void CRCCControl_MCOConfig(CRCCControlState *state, uint32_t output, uint32_t source, uint32_t divider);
/* Frequency index order matches the existing CRCCReferenceClock enum. */
uint32_t CRCCControl_GetFrequency(CRCCControlState *state, uint32_t clock);
#endif
