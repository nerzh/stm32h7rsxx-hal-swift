/* Host-only hardware stimulus for unchanged STM32 RCCEx and frequency bodies.
 * The Swift implementation can use Read/Write/Tick without calling a HAL body. */
#ifndef C_RCC_EXTENDED_REFERENCE_H
#define C_RCC_EXTENDED_REFERENCE_H
#include <stdint.h>
#include "RCCExtendedTypes.h"
#include "RCCExtendedLayouts.h"

typedef enum {
  CRCCExtended_CR, CRCCExtended_CFGR, CRCCExtended_CDCFGR,
  CRCCExtended_BMCFGR, CRCCExtended_APBCFGR,
  CRCCExtended_PLLCKSELR, CRCCExtended_PLLCFGR,
  CRCCExtended_PLL1DIVR1, CRCCExtended_PLL1FRACR,
  CRCCExtended_PLL2DIVR1, CRCCExtended_PLL2FRACR,
  CRCCExtended_PLL3DIVR1, CRCCExtended_PLL3FRACR,
  CRCCExtended_PLL1DIVR2, CRCCExtended_PLL2DIVR2, CRCCExtended_PLL3DIVR2,
  CRCCExtended_CCIPR1, CRCCExtended_CCIPR2, CRCCExtended_CCIPR3, CRCCExtended_CCIPR4,
  CRCCExtended_CIER, CRCCExtended_CIFR, CRCCExtended_CICR,
  CRCCExtended_BDCR, CRCCExtended_CSR, CRCCExtended_APB1RSTR2, CRCCExtended_CKPROTR,
  CRCCExtended_PWR_CR1,
  CRCCExtended_EXTI_IMR1, CRCCExtended_EXTI_EMR1,
  CRCCExtended_EXTI_RTSR1, CRCCExtended_EXTI_FTSR1,
  CRCCExtended_EXTI_SWIER1, CRCCExtended_EXTI_PR1,
  CRCCExtended_CRS_CR, CRCCExtended_CRS_CFGR, CRCCExtended_CRS_ISR, CRCCExtended_CRS_ICR,
  CRCCExtended_RegisterCount
} CRCCExtendedRegister;

typedef enum {
  CRCCExtended_LSECSSCallback,
  CRCCExtended_CRSSyncOKCallback,
  CRCCExtended_CRSSyncWarningCallback,
  CRCCExtended_CRSExpectedSyncCallback,
  CRCCExtended_CRSErrorCallback
} CRCCExtendedCallbackID;

typedef struct {
  CRCCExtendedRegister reg;
  uint32_t value, tickCall;
} CRCCExtendedWrite;

typedef struct {
  /* RegisterCount denotes a tick trigger; other values denote register reads. */
  CRCCExtendedRegister trigger, reg;
  uint32_t dueCall, clearMask, setMask, active;
} CRCCExtendedEvent;

typedef struct {
  CRCCExtendedCallbackID callbackID;
  uint32_t argument, tickCall, writeCount;
  uint32_t crsCR, crsCFGR, crsISR, crsICR;
  uint32_t rccBDCR, rccCIER, rccCIFR, rccCICR, extiPR1;
} CRCCExtendedCallback;

typedef struct {
  RCC_TypeDef rcc;
  PWR_TypeDef pwr;
  EXTI_TypeDef exti;
  CRS_TypeDef crs;
  uint32_t hsi, csi, hse, hsi48, lse, lsi, externalClock;
  uint32_t lseStartupTimeout;
  uint32_t tick, tickStep, tickCalls;
  uint32_t totalReadCalls, readCalls[CRCCExtended_RegisterCount];
  /* Automatic LSE readiness follows an enable edge, after lseReadyDelay future
   * ticks. Zero means immediate. Set automaticLSE=0 to model a stuck oscillator.
   * rejectBackupAccess makes software writes unable to change PWR.CR1.DBP. */
  uint32_t automaticLSE, lseReadyDelay, rejectBackupAccess;
  uint32_t lseReadyPending, lseReadyDueCall;
  uint32_t backupResetCount, crsResetCount;
  CRCCExtendedEvent events[64];
  uint32_t writeCount;
  CRCCExtendedWrite writes[512];
  uint32_t callbackCount;
  CRCCExtendedCallback callbacks[64];
  /* Bit (1 << callbackID) requests one nested CRS IRQ after that callback's
   * snapshot. The bit clears before dispatch. RecordCallback never dispatches;
   * the independent Swift callback must perform the equivalent Swift action. */
  uint32_t crsIRQReentryMask;
} CRCCExtendedState;

/* Reset establishes zero RCC/PWR/EXTI registers, CRS hardware reset defaults,
 * 64/4/24/48 MHz HSI/CSI/HSE/HSI48, LSE=32768, LSI=32000, external=48000,
 * LSE timeout=5000, tickStep=1 and immediate automatic LSE readiness.
 * Set/Get bypass hardware behavior, scripted events and observations.
 * BDCR backup reset uses its SVD reset value 0x10, clears oscillator status and
 * cancels pending automatic readiness. LSERDY/LSECSSD are read-only; RTCSEL is
 * write-once until backup reset. Initial Set bypasses these restrictions.
 * CICR and CRS.ICR retain the last software write for observation while clearing
 * their status registers. Other unmodeled fields use raw storage; this is test
 * stimulus, not a complete emulator of the RCC/EXTI/CRS peripherals.
 * Read counts cover macro-mediated C accesses only: the unchanged core RCC
 * frequency functions also contain direct volatile reads, which are not hooked.
 * Use static clock fixtures for frequency comparisons and Swift trace tests to
 * verify the complete frequency-query read order.
 */
void CRCCExtended_Reset(CRCCExtendedState *state);
void CRCCExtended_Set(CRCCExtendedState *state, CRCCExtendedRegister reg, uint32_t value);
uint32_t CRCCExtended_Get(const CRCCExtendedState *state, CRCCExtendedRegister reg);
uint32_t CRCCExtended_Read(CRCCExtendedState *state, CRCCExtendedRegister reg);
void CRCCExtended_Write(CRCCExtendedState *state, CRCCExtendedRegister reg, uint32_t value);
uint32_t CRCCExtended_Tick(CRCCExtendedState *state);
uint32_t CRCCExtended_ReadCount(const CRCCExtendedState *state, CRCCExtendedRegister reg);

/* Events apply immediately before the selected read returns, or after the tick
 * advances its call count. afterCalls=0 applies raw stimulus immediately.
 * Tick returns the old tick value; addition wraps as uint32_t in the HAL. */
void CRCCExtended_ScheduleRead(CRCCExtendedState *state, CRCCExtendedRegister trigger,
                               uint32_t afterCalls, CRCCExtendedRegister reg,
                               uint32_t clearMask, uint32_t setMask);
void CRCCExtended_ScheduleTick(CRCCExtendedState *state, uint32_t afterCalls,
                               CRCCExtendedRegister reg, uint32_t clearMask, uint32_t setMask);
CRCCExtendedWrite CRCCExtended_GetWrite(const CRCCExtendedState *state, uint32_t index);
/* Snapshot only; this function never dispatches a C HAL implementation. */
void CRCCExtended_RecordCallback(CRCCExtendedState *state, CRCCExtendedCallbackID callbackID,
                                 uint32_t argument);
CRCCExtendedCallback CRCCExtended_GetCallback(const CRCCExtendedState *state, uint32_t index);

uint32_t CRCCExtended_ConfigurePeripheralClocks(CRCCExtendedState *state,
                                                const RCC_PeriphCLKInitTypeDef *configuration);
void CRCCExtended_GetPeripheralClockConfiguration(CRCCExtendedState *state,
                                                   RCC_PeriphCLKInitTypeDef *configuration);
uint32_t CRCCExtended_GetPeripheralClockFrequency(CRCCExtendedState *state, uint32_t clock);
void CRCCExtended_EnableClockProtection(CRCCExtendedState *state, uint32_t clocks);
void CRCCExtended_DisableClockProtection(CRCCExtendedState *state, uint32_t clocks);
void CRCCExtended_EnableLSECSS(CRCCExtendedState *state);
void CRCCExtended_DisableLSECSS(CRCCExtendedState *state);
void CRCCExtended_EnableLSECSSInterrupt(CRCCExtendedState *state);
void CRCCExtended_ConfigureWakeupStopClock(CRCCExtendedState *state, uint32_t clock);
void CRCCExtended_ConfigureKernelWakeupStopClock(CRCCExtendedState *state, uint32_t clock);
void CRCCExtended_HandleLSECSSInterrupt(CRCCExtendedState *state);
void CRCCExtended_ConfigureCRS(CRCCExtendedState *state, const RCC_CRSInitTypeDef *configuration);
void CRCCExtended_GenerateCRSSoftwareSync(CRCCExtendedState *state);
void CRCCExtended_GetCRSInfo(CRCCExtendedState *state, RCC_CRSSynchroInfoTypeDef *information);
uint32_t CRCCExtended_WaitCRSSynchronization(CRCCExtendedState *state, uint32_t timeout);
void CRCCExtended_HandleCRSInterrupt(CRCCExtendedState *state);
#endif
