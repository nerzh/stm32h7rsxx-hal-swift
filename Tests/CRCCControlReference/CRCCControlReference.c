#include "Upstream/RCCControlShim.h"
#include <string.h>

_Thread_local CRCCControlState *CRCCControl_Current;

static volatile uint32_t *registerAddress(CRCCControlState *state, CRCCControlRegister reg) {
  switch (reg) {
#define RCC_REGISTER(name) case CRCCControl_##name: return &state->rcc.name
    RCC_REGISTER(CR); RCC_REGISTER(HSICFGR); RCC_REGISTER(CFGR);
    RCC_REGISTER(CDCFGR); RCC_REGISTER(BMCFGR); RCC_REGISTER(APBCFGR);
    RCC_REGISTER(PLLCKSELR); RCC_REGISTER(PLLCFGR);
    RCC_REGISTER(PLL1DIVR1); RCC_REGISTER(PLL1FRACR);
    RCC_REGISTER(PLL2DIVR1); RCC_REGISTER(PLL2FRACR);
    RCC_REGISTER(PLL3DIVR1); RCC_REGISTER(PLL3FRACR);
    RCC_REGISTER(PLL1DIVR2); RCC_REGISTER(PLL2DIVR2); RCC_REGISTER(PLL3DIVR2);
    RCC_REGISTER(BDCR); RCC_REGISTER(CSR); RCC_REGISTER(CIER); RCC_REGISTER(CIFR);
    RCC_REGISTER(CICR); RCC_REGISTER(RSR); RCC_REGISTER(AHB4ENR);
#undef RCC_REGISTER
    case CRCCControl_PWR_CR1: return &state->pwr.CR1;
    case CRCCControl_FLASH_ACR: return &state->flash.ACR;
    case CRCCControl_RegisterCount: break;
  }
  assert(!"Unknown RCC reference register");
  return NULL;
}

static CRCCControlRegister registerID(volatile uint32_t *address) {
  for (uint32_t index = 0; index < CRCCControl_RegisterCount; ++index) {
    if (registerAddress(CRCCControl_Current, (CRCCControlRegister)index) == address) {
      return (CRCCControlRegister)index;
    }
  }
  assert(!"Unexpected upstream register address (check exact CMSIS layout)");
  return CRCCControl_RegisterCount;
}

void CRCCControl_Reset(CRCCControlState *state) {
  memset(state, 0, sizeof(*state));
  state->hsi = 64000000U;
  state->csi = 4000000U;
  state->hse = 24000000U;
  state->tickStep = 1;
  state->systemCoreClock = 64000000U;
  state->tickPriority = 15;
  state->automaticTransitions = CRCCControl_AutoAll;
}

void CRCCControl_Set(CRCCControlState *state, CRCCControlRegister reg, uint32_t value) {
  *registerAddress(state, reg) = value;
}

uint32_t CRCCControl_Get(const CRCCControlState *state, CRCCControlRegister reg) {
  return *registerAddress((CRCCControlState *)state, reg);
}

void CRCCControl_ScheduleEvent(CRCCControlState *state, CRCCControlRegister reg,
                              uint32_t clearMask, uint32_t setMask, uint32_t afterTickCalls) {
  if (afterTickCalls == 0) {
    volatile uint32_t *address = registerAddress(state, reg);
    *address = (*address & ~clearMask) | setMask;
    return;
  }
  for (uint32_t index = 0; index < 64; ++index) {
    CRCCControlEvent *event = &state->events[index];
    if (!event->active) {
      event->reg = reg;
      event->clearMask = clearMask;
      event->setMask = setMask;
      event->dueTickCall = state->tickCalls + afterTickCalls;
      event->active = 1;
      return;
    }
  }
  assert(!"Reference event capacity exceeded");
}

static void automaticTransition(CRCCControlRegister reg, uint32_t flags,
                                uint32_t value, uint32_t automaticBit) {
  CRCCControlState *state = CRCCControl_Current;
  if ((state->automaticTransitions & automaticBit) == 0) return;
  /* Repeated macro writes must not move an already scheduled transition. */
  for (uint32_t index = 0; index < 64; ++index) {
    CRCCControlEvent *event = &state->events[index];
    if (event->active && event->reg == reg && event->clearMask == flags) {
      if (event->setMask == value) return;
      event->active = 0;
    }
  }
  if ((CRCCControl_Get(state, reg) & flags) == value) return;
  CRCCControl_ScheduleEvent(state, reg, flags, value, state->transitionDelay);
}

uint32_t CRCCControl_Read(volatile uint32_t *address) {
  return *address;
}

void CRCCControl_HardwareWrite(volatile uint32_t *address, uint32_t value) {
  CRCCControlState *state = CRCCControl_Current;
  CRCCControlRegister reg = registerID(address);
  assert(state->writeCount < 512);
  state->writes[state->writeCount++] = (CRCCControlWrite){reg, value, state->tickCalls};
  uint32_t previous = *address;
  if (reg == CRCCControl_CR) {
    const uint32_t ready = RCC_CR_HSIRDY | RCC_CR_HSIDIVF | RCC_CR_HSERDY | RCC_CR_CSIRDY |
                          RCC_CR_HSI48RDY | RCC_CR_PLL1RDY | RCC_CR_PLL2RDY | RCC_CR_PLL3RDY;
    value = (value & ~ready) | (previous & ready);
  } else if (reg == CRCCControl_CFGR) {
    value = (value & ~RCC_CFGR_SWS) | (previous & RCC_CFGR_SWS);
  } else if (reg == CRCCControl_BDCR) {
    value = (value & ~RCC_BDCR_LSERDY) | (previous & RCC_BDCR_LSERDY);
  } else if (reg == CRCCControl_CSR) {
    value = (value & ~RCC_CSR_LSIRDY) | (previous & RCC_CSR_LSIRDY);
  } else if (reg == CRCCControl_PLLCKSELR && state->lockPLLSource) {
    value = (value & ~RCC_PLLCKSELR_PLLSRC) | (previous & RCC_PLLCKSELR_PLLSRC);
  } else if (reg == CRCCControl_FLASH_ACR && state->rejectFlashLatency) {
    const uint32_t latency = FLASH_ACR_LATENCY | FLASH_ACR_WRHIGHFREQ;
    value = (value & ~latency) | (previous & latency);
  }
  *address = value;
  if (reg == CRCCControl_CR) {
#define READY(on, flag, automatic) automaticTransition(CRCCControl_CR, flag, (value & on) ? flag : 0, automatic)
    READY(RCC_CR_HSION, RCC_CR_HSIRDY, CRCCControl_AutoHSI);
    READY(RCC_CR_HSEON, RCC_CR_HSERDY, CRCCControl_AutoHSE);
    READY(RCC_CR_CSION, RCC_CR_CSIRDY, CRCCControl_AutoCSI);
    READY(RCC_CR_HSI48ON, RCC_CR_HSI48RDY, CRCCControl_AutoHSI48);
    READY(RCC_CR_PLL1ON, RCC_CR_PLL1RDY, CRCCControl_AutoPLL1);
    READY(RCC_CR_PLL2ON, RCC_CR_PLL2RDY, CRCCControl_AutoPLL2);
    READY(RCC_CR_PLL3ON, RCC_CR_PLL3RDY, CRCCControl_AutoPLL3);
    if ((previous & RCC_CR_HSIDIV) != (value & RCC_CR_HSIDIV) &&
        (state->automaticTransitions & CRCCControl_AutoHSIDivider)) {
      state->rcc.CR &= ~RCC_CR_HSIDIVF;
    }
    READY(RCC_CR_HSION, RCC_CR_HSIDIVF, CRCCControl_AutoHSIDivider);
#undef READY
  } else if (reg == CRCCControl_CFGR) {
    automaticTransition(reg, RCC_CFGR_SWS, (value & RCC_CFGR_SW) << RCC_CFGR_SWS_Pos,
                        CRCCControl_AutoSystemClock);
  } else if (reg == CRCCControl_BDCR) {
    automaticTransition(reg, RCC_BDCR_LSERDY, (value & RCC_BDCR_LSEON) ? RCC_BDCR_LSERDY : 0,
                        CRCCControl_AutoLSE);
  } else if (reg == CRCCControl_CSR) {
    automaticTransition(reg, RCC_CSR_LSIRDY, (value & RCC_CSR_LSION) ? RCC_CSR_LSIRDY : 0,
                        CRCCControl_AutoLSI);
  } else if (reg == CRCCControl_CICR) {
    state->rcc.CIFR &= ~value;
  }
}

uint32_t CRCCControl_HardwareTick(void) {
  CRCCControlState *state = CRCCControl_Current;
  uint32_t result = state->tick;
  state->tick += state->tickStep;
  state->tickCalls += 1;
  /* A zero tick step with a permanently stuck flag cannot time out in HAL.
   * Abort an invalid test instead of hanging the entire host test process. */
  assert(state->tickCalls < 1000000U);
  for (uint32_t index = 0; index < 64; ++index) {
    CRCCControlEvent *event = &state->events[index];
    if (event->active && event->dueTickCall <= state->tickCalls) {
      volatile uint32_t *address = registerAddress(state, event->reg);
      *address = (*address & ~event->clearMask) | event->setMask;
      event->active = 0;
    }
  }
  return result;
}

uint32_t CRCCControl_HardwareInitTick(uint32_t priority) {
  CRCCControlState *state = CRCCControl_Current;
  assert(state->initTickCalls < 32);
  state->initTickHistory[state->initTickCalls++] = (CRCCControlInitTickCall){
    priority, state->systemCoreClock, state->tickCalls, state->writeCount
  };
  return state->initTickStatus;
}

void CRCCControl_HSECSSCallback(void) {
  CRCCControl_Current->hseCSSCallbacks += 1;
}

void CRCCControl_GPIOInit(GPIO_TypeDef *port, GPIO_InitTypeDef *configuration) {
  CRCCControlState *state = CRCCControl_Current;
  state->gpioCalls += 1;
  state->gpioPort = (uint32_t)(uintptr_t)port;
  state->gpioPin = configuration->Pin;
  state->gpioMode = configuration->Mode;
  state->gpioSpeed = configuration->Speed;
  state->gpioPull = configuration->Pull;
  state->gpioAlternate = configuration->Alternate;
}

void CRCCControl_Write(CRCCControlState *state, CRCCControlRegister reg, uint32_t value) {
  CRCCControl_Current = state;
  CRCCControl_HardwareWrite(registerAddress(state, reg), value);
}

uint32_t CRCCControl_Tick(CRCCControlState *state) {
  CRCCControl_Current = state;
  return CRCCControl_HardwareTick();
}

uint32_t CRCCControl_InitTick(CRCCControlState *state, uint32_t priority) {
  CRCCControl_Current = state;
  return CRCCControl_HardwareInitTick(priority);
}

CRCCControlWrite CRCCControl_GetWrite(const CRCCControlState *state, uint32_t index) {
  assert(index < state->writeCount);
  return state->writes[index];
}

CRCCControlInitTickCall CRCCControl_GetInitTickCall(const CRCCControlState *state, uint32_t index) {
  assert(index < state->initTickCalls);
  return state->initTickHistory[index];
}

uint32_t CRCCControl_DeInit(CRCCControlState *state) {
  CRCCControl_Current = state;
  return HAL_RCC_DeInit();
}

uint32_t CRCCControl_OscConfig(CRCCControlState *state, RCC_OscInitTypeDef *configuration) {
  CRCCControl_Current = state;
  return HAL_RCC_OscConfig(configuration);
}

uint32_t CRCCControl_ClockConfig(CRCCControlState *state, const RCC_ClkInitTypeDef *configuration, uint32_t latency) {
  CRCCControl_Current = state;
  return HAL_RCC_ClockConfig(configuration, latency);
}

void CRCCControl_GetOscConfig(CRCCControlState *state, RCC_OscInitTypeDef *configuration) {
  CRCCControl_Current = state;
  HAL_RCC_GetOscConfig(configuration);
}

void CRCCControl_GetClockConfig(CRCCControlState *state, RCC_ClkInitTypeDef *configuration, uint32_t *latency) {
  CRCCControl_Current = state;
  HAL_RCC_GetClockConfig(configuration, latency);
}

void CRCCControl_EnableCSS(CRCCControlState *state) {
  CRCCControl_Current = state;
  HAL_RCC_EnableCSS();
}

void CRCCControl_DisableCSS(CRCCControlState *state) {
  CRCCControl_Current = state;
  HAL_RCC_DisableCSS();
}

void CRCCControl_NMI(CRCCControlState *state) {
  CRCCControl_Current = state;
  HAL_RCC_NMI_IRQHandler();
}

uint32_t CRCCControl_GetResetSource(CRCCControlState *state) {
  CRCCControl_Current = state;
  return HAL_RCC_GetResetSource();
}

uint32_t CRCCControl_PLLConfig(CRCCControlState *state, uint32_t index, const RCC_PLLInitTypeDef *configuration) {
  assert(index < 3);
  CRCCControl_Current = state;
  return CRCCControl_CallPLL(index, configuration);
}

void CRCCControl_MCOConfig(CRCCControlState *state, uint32_t output, uint32_t source, uint32_t divider) {
  CRCCControl_Current = state;
  HAL_RCC_MCOConfig(output, source, divider);
}

uint32_t CRCCControl_GetFrequency(CRCCControlState *state, uint32_t clock) {
  CRCCControl_Current = state;
  switch (clock) {
    case 0: return HAL_RCC_GetSysClockFreq();
    case 1: return HAL_RCC_GetHCLKFreq();
    case 2: return HAL_RCC_GetPCLK1Freq();
    case 3: return HAL_RCC_GetPCLK2Freq();
    case 4: return HAL_RCC_GetPCLK4Freq();
    case 5: return HAL_RCC_GetPCLK5Freq();
    case 6: return HAL_RCC_GetPLL1PFreq();
    case 7: return HAL_RCC_GetPLL1QFreq();
    case 8: return HAL_RCC_GetPLL1RFreq();
    case 9: return HAL_RCC_GetPLL1SFreq();
    case 10: return HAL_RCC_GetPLL2PFreq();
    case 11: return HAL_RCC_GetPLL2QFreq();
    case 12: return HAL_RCC_GetPLL2RFreq();
    case 13: return HAL_RCC_GetPLL2SFreq();
    case 14: return HAL_RCC_GetPLL2TFreq();
    case 15: return HAL_RCC_GetPLL3PFreq();
    case 16: return HAL_RCC_GetPLL3QFreq();
    case 17: return HAL_RCC_GetPLL3RFreq();
    case 18: return HAL_RCC_GetPLL3SFreq();
  }
  assert(!"Unknown frequency query");
  return 0;
}
