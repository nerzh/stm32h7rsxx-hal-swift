/* Hardware-only stimulus and observations. HAL algorithms remain in the
 * unchanged, namespaced upstream bodies in the other translation unit. */
#include "include/CRCCExtendedReference.h"
#include "Upstream/RCCExtendedBits.h"
#include "Upstream/RCCExtendedModelFunctions.h"
#include <assert.h>
#include <stddef.h>
#include <string.h>

_Thread_local CRCCExtendedState *CRCCExtended_Current;

static void Bind(CRCCExtendedState *state)
{
  assert(state != NULL);
  CRCCExtended_Current = state;
}

static volatile uint32_t *Address(CRCCExtendedState *state, CRCCExtendedRegister reg)
{
  switch (reg) {
#define RCC_REGISTER(name) case CRCCExtended_##name: return &state->rcc.name
    RCC_REGISTER(CR); RCC_REGISTER(CFGR); RCC_REGISTER(CDCFGR);
    RCC_REGISTER(BMCFGR); RCC_REGISTER(APBCFGR);
    RCC_REGISTER(PLLCKSELR); RCC_REGISTER(PLLCFGR);
    RCC_REGISTER(PLL1DIVR1); RCC_REGISTER(PLL1FRACR);
    RCC_REGISTER(PLL2DIVR1); RCC_REGISTER(PLL2FRACR);
    RCC_REGISTER(PLL3DIVR1); RCC_REGISTER(PLL3FRACR);
    RCC_REGISTER(PLL1DIVR2); RCC_REGISTER(PLL2DIVR2); RCC_REGISTER(PLL3DIVR2);
    RCC_REGISTER(CCIPR1); RCC_REGISTER(CCIPR2); RCC_REGISTER(CCIPR3); RCC_REGISTER(CCIPR4);
    RCC_REGISTER(CIER); RCC_REGISTER(CIFR); RCC_REGISTER(CICR);
    RCC_REGISTER(BDCR); RCC_REGISTER(CSR); RCC_REGISTER(APB1RSTR2); RCC_REGISTER(CKPROTR);
#undef RCC_REGISTER
    case CRCCExtended_PWR_CR1: return &state->pwr.CR1;
#define EXTI_REGISTER(name) case CRCCExtended_EXTI_##name: return &state->exti.name
    EXTI_REGISTER(IMR1); EXTI_REGISTER(EMR1); EXTI_REGISTER(RTSR1);
    EXTI_REGISTER(FTSR1); EXTI_REGISTER(SWIER1); EXTI_REGISTER(PR1);
#undef EXTI_REGISTER
#define CRS_REGISTER(name) case CRCCExtended_CRS_##name: return &state->crs.name
    CRS_REGISTER(CR); CRS_REGISTER(CFGR); CRS_REGISTER(ISR); CRS_REGISTER(ICR);
#undef CRS_REGISTER
    default: assert(!"Unknown RCCEx model register"); return NULL;
  }
}

static CRCCExtendedRegister RegisterAt(volatile uint32_t *address)
{
  for (uint32_t reg = 0; reg < CRCCExtended_RegisterCount; ++reg) {
    if (address == Address(CRCCExtended_Current, (CRCCExtendedRegister)reg)) {
      return (CRCCExtendedRegister)reg;
    }
  }
  assert(!"Unexpected upstream MMIO address");
  return CRCCExtended_RegisterCount;
}

static void ResetCRS(CRCCExtendedState *state)
{
  /* Register reset values in both pinned STM32H7R and STM32H7S SVDs. */
  state->crs.CR = 0x00002000U;
  state->crs.CFGR = 0x2022BB7FU;
  state->crs.ISR = 0;
  state->crs.ICR = 0;
}

void CRCCExtended_Reset(CRCCExtendedState *state)
{
  memset(state, 0, sizeof(*state));
  ResetCRS(state);
  state->hsi = 64000000U;
  state->csi = 4000000U;
  state->hse = 24000000U;
  state->hsi48 = 48000000U;
  state->lse = 32768U;
  state->lsi = 32000U;
  state->externalClock = 48000U;
  state->lseStartupTimeout = 5000U;
  state->tickStep = 1;
  state->automaticLSE = 1;
  Bind(state);
}

void CRCCExtended_Set(CRCCExtendedState *state, CRCCExtendedRegister reg, uint32_t value)
{
  *Address(state, reg) = value;
}

uint32_t CRCCExtended_Get(const CRCCExtendedState *state, CRCCExtendedRegister reg)
{
  return *Address((CRCCExtendedState *)state, reg);
}

static uint32_t TriggerCount(const CRCCExtendedState *state, CRCCExtendedRegister trigger)
{
  assert(trigger <= CRCCExtended_RegisterCount);
  return trigger == CRCCExtended_RegisterCount ? state->tickCalls : state->readCalls[trigger];
}

static void ApplyEvent(CRCCExtendedState *state, const CRCCExtendedEvent *event)
{
  volatile uint32_t *address = Address(state, event->reg);
  *address = (*address & ~event->clearMask) | event->setMask;
}

static void RunEvents(CRCCExtendedState *state, CRCCExtendedRegister trigger)
{
  uint32_t count = TriggerCount(state, trigger);
  for (uint32_t i = 0; i < 64; ++i) {
    CRCCExtendedEvent *event = &state->events[i];
    if (event->active && event->trigger == trigger && event->dueCall <= count) {
      ApplyEvent(state, event);
      event->active = 0;
    }
  }
}

static void Schedule(CRCCExtendedState *state, CRCCExtendedRegister trigger,
                     uint32_t afterCalls, CRCCExtendedRegister reg,
                     uint32_t clearMask, uint32_t setMask)
{
  assert(reg < CRCCExtended_RegisterCount);
  CRCCExtendedEvent event = {trigger, reg, TriggerCount(state, trigger) + afterCalls,
                             clearMask, setMask, 1};
  if (afterCalls == 0) {
    ApplyEvent(state, &event);
    return;
  }
  for (uint32_t i = 0; i < 64; ++i) {
    if (!state->events[i].active) {
      state->events[i] = event;
      return;
    }
  }
  assert(!"RCCEx hardware event capacity exceeded");
}

void CRCCExtended_ScheduleRead(CRCCExtendedState *state, CRCCExtendedRegister trigger,
                               uint32_t afterCalls, CRCCExtendedRegister reg,
                               uint32_t clearMask, uint32_t setMask)
{
  assert(trigger < CRCCExtended_RegisterCount);
  Schedule(state, trigger, afterCalls, reg, clearMask, setMask);
}

void CRCCExtended_ScheduleTick(CRCCExtendedState *state, uint32_t afterCalls,
                               CRCCExtendedRegister reg, uint32_t clearMask, uint32_t setMask)
{
  Schedule(state, CRCCExtended_RegisterCount, afterCalls, reg, clearMask, setMask);
}

uint32_t CRCCExtended_Read(CRCCExtendedState *state, CRCCExtendedRegister reg)
{
  Bind(state);
  assert(reg < CRCCExtended_RegisterCount);
  assert(state->totalReadCalls < 1000000U && "RCCEx fixture did not terminate");
  state->totalReadCalls++;
  state->readCalls[reg]++;
  RunEvents(state, reg);
  return *Address(state, reg);
}

uint32_t CRCCExtended_ReadCount(const CRCCExtendedState *state, CRCCExtendedRegister reg)
{
  assert(reg < CRCCExtended_RegisterCount);
  return state->readCalls[reg];
}

void CRCCExtended_Write(CRCCExtendedState *state, CRCCExtendedRegister reg, uint32_t value)
{
  Bind(state);
  assert(state->writeCount < 512);
  state->writes[state->writeCount++] = (CRCCExtendedWrite){reg, value, state->tickCalls};
  volatile uint32_t *address = Address(state, reg);
  uint32_t old = *address;

  if (reg == CRCCExtended_PWR_CR1 && state->rejectBackupAccess) {
    value = (value & ~PWR_CR1_DBP) | (old & PWR_CR1_DBP);
  }
  if (reg == CRCCExtended_EXTI_PR1) {
    *address = old & ~value;
    return;
  }
  if (reg == CRCCExtended_BDCR) {
    if (value & RCC_BDCR_VSWRST) {
      if (!(old & RCC_BDCR_VSWRST)) state->backupResetCount++;
      *address = RCC_BDCR_VSWRST | 0x10U;
      state->lseReadyPending = 0;
      return;
    }
    /* Status flags cannot be restored by the HAL's saved BDCR write after reset. */
    uint32_t readOnly = RCC_BDCR_LSERDY | RCC_BDCR_LSECSSD;
    *address = (value & ~readOnly) | (old & readOnly);
    if (old & RCC_BDCR_RTCSEL) {
      *address = (*address & ~RCC_BDCR_RTCSEL) | (old & RCC_BDCR_RTCSEL);
    }
    if (!(value & RCC_BDCR_LSEON)) {
      *address &= ~RCC_BDCR_LSERDY;
      state->lseReadyPending = 0;
    } else if (!(old & RCC_BDCR_LSEON) && state->automaticLSE) {
      if (state->lseReadyDelay == 0) {
        *address |= RCC_BDCR_LSERDY;
      } else {
        state->lseReadyPending = 1;
        state->lseReadyDueCall = state->tickCalls + state->lseReadyDelay;
      }
    }
    return;
  }

  *address = value;
  if (reg == CRCCExtended_CICR) {
    state->rcc.CIFR &= ~value;
  } else if (reg == CRCCExtended_CRS_ICR) {
    uint32_t clear = value & (CRS_ICR_SYNCOKC | CRS_ICR_SYNCWARNC | CRS_ICR_ESYNCC);
    if (value & CRS_ICR_ERRC) {
      clear |= CRS_ISR_ERRF | CRS_ISR_SYNCERR | CRS_ISR_SYNCMISS | CRS_ISR_TRIMOVF;
    }
    state->crs.ISR &= ~clear;
  } else if (reg == CRCCExtended_APB1RSTR2 && (value & RCC_APB1RSTR2_CRSRST)) {
    if (!(old & RCC_APB1RSTR2_CRSRST)) state->crsResetCount++;
    ResetCRS(state);
  }
}

uint32_t CRCCExtended_Tick(CRCCExtendedState *state)
{
  Bind(state);
  assert(state->tickCalls < 1000000U && "RCCEx fixture did not terminate");
  uint32_t result = state->tick;
  state->tick += state->tickStep;
  state->tickCalls++;
  if (state->lseReadyPending && state->lseReadyDueCall <= state->tickCalls) {
    if ((state->rcc.BDCR & RCC_BDCR_LSEON) && !(state->rcc.BDCR & RCC_BDCR_VSWRST)) {
      state->rcc.BDCR |= RCC_BDCR_LSERDY;
    }
    state->lseReadyPending = 0;
  }
  RunEvents(state, CRCCExtended_RegisterCount);
  return result;
}

uint32_t CRCCExtended_ReadAddress(volatile uint32_t *address)
{
  return CRCCExtended_Read(CRCCExtended_Current, RegisterAt(address));
}

void CRCCExtended_WriteAddress(volatile uint32_t *address, uint32_t value)
{
  CRCCExtended_Write(CRCCExtended_Current, RegisterAt(address), value);
}

uint32_t CRCCExtended_HardwareTick(void)
{
  return CRCCExtended_Tick(CRCCExtended_Current);
}

CRCCExtendedWrite CRCCExtended_GetWrite(const CRCCExtendedState *state, uint32_t index)
{
  assert(index < state->writeCount);
  return state->writes[index];
}

void CRCCExtended_RecordCallback(CRCCExtendedState *state, CRCCExtendedCallbackID callbackID,
                                 uint32_t argument)
{
  assert(state->callbackCount < 64);
  state->callbacks[state->callbackCount++] = (CRCCExtendedCallback){
    callbackID, argument, state->tickCalls, state->writeCount,
    state->crs.CR, state->crs.CFGR, state->crs.ISR, state->crs.ICR,
    state->rcc.BDCR, state->rcc.CIER, state->rcc.CIFR, state->rcc.CICR, state->exti.PR1
  };
}

CRCCExtendedCallback CRCCExtended_GetCallback(const CRCCExtendedState *state, uint32_t index)
{
  assert(index < state->callbackCount);
  return state->callbacks[index];
}

static void RecordCRSCallback(CRCCExtendedCallbackID callbackID, uint32_t argument)
{
  CRCCExtendedState *state = CRCCExtended_Current;
  CRCCExtended_RecordCallback(state, callbackID, argument);
  uint32_t bit = 1U << callbackID;
  if (state->crsIRQReentryMask & bit) {
    state->crsIRQReentryMask &= ~bit;
    CRCCExtended_HandleCRSInterrupt(state);
  }
}

/* These strong definitions override the untouched upstream weak defaults. */
void HAL_RCCEx_LSECSS_Callback(void)
{ CRCCExtended_RecordCallback(CRCCExtended_Current, CRCCExtended_LSECSSCallback, 0); }
void HAL_RCCEx_CRS_SyncOkCallback(void)
{ RecordCRSCallback(CRCCExtended_CRSSyncOKCallback, 0); }
void HAL_RCCEx_CRS_SyncWarnCallback(void)
{ RecordCRSCallback(CRCCExtended_CRSSyncWarningCallback, 0); }
void HAL_RCCEx_CRS_ExpectedSyncCallback(void)
{ RecordCRSCallback(CRCCExtended_CRSExpectedSyncCallback, 0); }
void HAL_RCCEx_CRS_ErrorCallback(uint32_t error)
{ RecordCRSCallback(CRCCExtended_CRSErrorCallback, error); }

uint32_t CRCCExtended_ConfigurePeripheralClocks(CRCCExtendedState *state,
                                                const RCC_PeriphCLKInitTypeDef *configuration)
{
  Bind(state);
  return HAL_RCCEx_PeriphCLKConfig(configuration);
}

void CRCCExtended_GetPeripheralClockConfiguration(CRCCExtendedState *state,
                                                   RCC_PeriphCLKInitTypeDef *configuration)
{
  Bind(state);
  HAL_RCCEx_GetPeriphCLKConfig(configuration);
}

uint32_t CRCCExtended_GetPeripheralClockFrequency(CRCCExtendedState *state, uint32_t clock)
{
  Bind(state);
  return HAL_RCCEx_GetPeriphCLKFreq(clock);
}

#define NO_ARGUMENT_WRAPPER(publicName, upstreamName) \
  void CRCCExtended_##publicName(CRCCExtendedState *state) { \
    Bind(state); upstreamName(); \
  }
NO_ARGUMENT_WRAPPER(EnableLSECSS, HAL_RCCEx_EnableLSECSS)
NO_ARGUMENT_WRAPPER(DisableLSECSS, HAL_RCCEx_DisableLSECSS)
NO_ARGUMENT_WRAPPER(EnableLSECSSInterrupt, HAL_RCCEx_EnableLSECSS_IT)
NO_ARGUMENT_WRAPPER(HandleLSECSSInterrupt, HAL_RCCEx_LSECSS_IRQHandler)
NO_ARGUMENT_WRAPPER(GenerateCRSSoftwareSync, HAL_RCCEx_CRSSoftwareSynchronizationGenerate)
NO_ARGUMENT_WRAPPER(HandleCRSInterrupt, HAL_RCCEx_CRS_IRQHandler)
#undef NO_ARGUMENT_WRAPPER

#define ONE_ARGUMENT_WRAPPER(publicName, upstreamName) \
  void CRCCExtended_##publicName(CRCCExtendedState *state, uint32_t value) { \
    Bind(state); upstreamName(value); \
  }
ONE_ARGUMENT_WRAPPER(EnableClockProtection, HAL_RCCEx_EnableClockProtection)
ONE_ARGUMENT_WRAPPER(DisableClockProtection, HAL_RCCEx_DisableClockProtection)
ONE_ARGUMENT_WRAPPER(ConfigureWakeupStopClock, HAL_RCCEx_WakeUpStopCLKConfig)
ONE_ARGUMENT_WRAPPER(ConfigureKernelWakeupStopClock, HAL_RCCEx_KerWakeUpStopCLKConfig)
#undef ONE_ARGUMENT_WRAPPER

void CRCCExtended_ConfigureCRS(CRCCExtendedState *state, const RCC_CRSInitTypeDef *configuration)
{
  Bind(state);
  HAL_RCCEx_CRSConfig(configuration);
}

void CRCCExtended_GetCRSInfo(CRCCExtendedState *state, RCC_CRSSynchroInfoTypeDef *information)
{
  Bind(state);
  HAL_RCCEx_CRSGetSynchronizationInfo(information);
}

uint32_t CRCCExtended_WaitCRSSynchronization(CRCCExtendedState *state, uint32_t timeout)
{
  Bind(state);
  return HAL_RCCEx_CRSWaitSynchronization(timeout);
}
