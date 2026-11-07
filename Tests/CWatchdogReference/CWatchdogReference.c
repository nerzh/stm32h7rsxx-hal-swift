/* Host-only plain-register stimulus. Driver bodies are in the Upstream includes. */
#include "include/CWatchdogReference.h"
#include "Upstream/WatchdogModelFunctions.h"
#include <assert.h>
#include <stddef.h>
#include <string.h>

_Thread_local CWatchdogState *CWatchdog_Current;

static void Bind(CWatchdogState *state)
{
  CWatchdog_Current = state;
  state->iwdg0.Instance = &state->iwdg;
  state->iwdg1.Instance = &state->iwdg;
  state->wwdg0.Instance = &state->wwdg;
  state->wwdg1.Instance = &state->wwdg;
}

static volatile uint32_t *Address(CWatchdogState *state, CWatchdogRegister reg)
{
  switch (reg) {
  case CWatchdog_IWDG_KR: return &state->iwdg.KR;
  case CWatchdog_IWDG_PR: return &state->iwdg.PR;
  case CWatchdog_IWDG_RLR: return &state->iwdg.RLR;
  case CWatchdog_IWDG_SR: return &state->iwdg.SR;
  case CWatchdog_IWDG_WINR: return &state->iwdg.WINR;
  case CWatchdog_IWDG_EWCR: return &state->iwdg.EWCR;
  case CWatchdog_WWDG_CR: return &state->wwdg.CR;
  case CWatchdog_WWDG_CFR: return &state->wwdg.CFR;
  case CWatchdog_WWDG_SR: return &state->wwdg.SR;
  default: assert(0 && "Unknown watchdog register"); return NULL;
  }
}

static CWatchdogRegister RegisterAt(volatile uint32_t *address)
{
  for (unsigned index = 0; index < CWatchdog_RegisterCount; index++) {
    if (address == Address(CWatchdog_Current, (CWatchdogRegister)index)) return (CWatchdogRegister)index;
  }
  assert(0 && "Unknown watchdog address");
  return CWatchdog_RegisterCount;
}

void CWatchdog_Reset(CWatchdogState *state, uint32_t registeredCallbacks)
{
  memset(state, 0, sizeof(*state));
  state->registeredCallbacks = registeredCallbacks;
  state->lsi = 32000; state->lsiStartupTime = 130; state->tickStep = 1;
  state->iwdg.RLR = 0xFFF; state->iwdg.WINR = 0xFFF;
  state->wwdg.CR = 0x7F; state->wwdg.CFR = 0x7F;
  state->iwdg0.Init = (IWDG_InitTypeDef){0, 0xFFF, 0xFFF, 0};
  state->iwdg1.Init = state->iwdg0.Init;
  state->wwdg0.Init = (WWDG_InitTypeDef){0, 0x7F, 0x7F, 0};
  state->wwdg1.Init = state->wwdg0.Init;
  Bind(state);
}

void CWatchdog_Set(CWatchdogState *state, CWatchdogRegister reg, uint32_t value)
{
  *Address(state, reg) = value;
}

uint32_t CWatchdog_Get(const CWatchdogState *state, CWatchdogRegister reg)
{
  return *Address((CWatchdogState *)state, reg);
}

void CWatchdog_Write(CWatchdogState *state, CWatchdogRegister reg, uint32_t value)
{
  assert(state->writeCount < 256);
  state->writes[state->writeCount++] = (CWatchdogWrite){reg, value, state->tickCalls};
  CWatchdog_Set(state, reg, value);
}

uint32_t CWatchdog_ReadAddress(volatile uint32_t *address) { return *address; }
void CWatchdog_WriteAddress(volatile uint32_t *address, uint32_t value)
{
  CWatchdog_Write(CWatchdog_Current, RegisterAt(address), value);
}

uint32_t CWatchdog_GetUpdateTimeout(const CWatchdogState *state)
{
  assert(state->lsi >= 128);
  /* Same expression as HAL_IWDG_DEFAULT_TIMEOUT, with injected conf values. */
  return (uint32_t)(((1UL * 1024UL * 1000UL) / (state->lsi / 128U)) +
                    ((state->lsiStartupTime / 1000UL) + 1UL));
}

void CWatchdog_ScheduleTick(CWatchdogState *state, uint32_t afterCalls, CWatchdogRegister reg,
                            uint32_t clearMask, uint32_t setMask)
{
  if (afterCalls == 0) {
    CWatchdog_Set(state, reg, (CWatchdog_Get(state, reg) & ~clearMask) | setMask);
    return;
  }
  for (unsigned index = 0; index < 32; index++) {
    if (!state->events[index].active) {
      state->events[index] = (CWatchdogEvent){reg, state->tickCalls + afterCalls, clearMask, setMask, 1};
      return;
    }
  }
  assert(0 && "Too many watchdog events");
}

uint32_t CWatchdog_Tick(CWatchdogState *state)
{
  Bind(state);
  assert(state->tickCalls < 1000000U && "Watchdog fixture did not terminate");
  uint32_t result = state->tick;
  state->tick += state->tickStep;
  state->tickCalls++;
  for (unsigned index = 0; index < 32; index++) {
    CWatchdogEvent *event = &state->events[index];
    if (event->active && event->dueCall <= state->tickCalls) {
      CWatchdog_Set(state, event->reg, (CWatchdog_Get(state, event->reg) & ~event->clearMask) | event->setMask);
      event->active = 0;
    }
  }
  return result;
}
uint32_t CWatchdog_HardwareTick(void) { return CWatchdog_Tick(CWatchdog_Current); }

CWatchdogWrite CWatchdog_GetWrite(const CWatchdogState *state, uint32_t index)
{
  assert(index < state->writeCount); return state->writes[index];
}

static uint32_t *ConfigurationWord(CWatchdogState *state, CWatchdogDevice device, uint32_t word)
{
  assert(word < 4);
  if (device == CWatchdog_IWDG) {
    IWDG_InitTypeDef *configuration = state->registeredCallbacks ? &state->iwdg1.Init : &state->iwdg0.Init;
    switch (word) {
    case 0: return &configuration->Prescaler;
    case 1: return &configuration->Reload;
    case 2: return &configuration->Window;
    default: return &configuration->EWI;
    }
  }
  WWDG_InitTypeDef *configuration = state->registeredCallbacks ? &state->wwdg1.Init : &state->wwdg0.Init;
  switch (word) {
  case 0: return &configuration->Prescaler;
  case 1: return &configuration->Window;
  case 2: return &configuration->Counter;
  default: return &configuration->EWIMode;
  }
}

uint32_t CWatchdog_GetConfiguration(const CWatchdogState *state, CWatchdogDevice device, uint32_t word)
{
  return *ConfigurationWord((CWatchdogState *)state, device, word);
}
void CWatchdog_SetConfiguration(CWatchdogState *state, CWatchdogDevice device, uint32_t word, uint32_t value)
{
  *ConfigurationWord(state, device, word) = value;
}

static void Dispatch(CWatchdogDevice device, uint32_t callbackID, uint32_t implementation)
{
  CWatchdogState *state = CWatchdog_Current;
  uint32_t index = CWatchdog_RecordCallback(state, device, callbackID, implementation);
  uint32_t action = CWatchdog_GetCallbackAction(state, device, callbackID);
  if (action == 1) {
    uint32_t status = CWatchdog_Refresh(state, device);
    CWatchdog_SetCallbackActionStatus(state, index, status);
  } else if (action == 2) {
    CWatchdog_ApplyCallbackMutation(state, device, callbackID);
  }
}

/* Strong application overrides of the unchanged weak callbacks in the TUs. */
#define DEFINE_CALLBACKS(deviceName, variant) \
  void CWatchdog##deviceName##variant##_HAL_##deviceName##_EarlyWakeupCallback(CWatchdog##deviceName##variant##Handle *handle) { \
    (void)handle; Dispatch(CWatchdog_##deviceName, 0, 1); \
  } \
  void CWatchdog##deviceName##variant##_HAL_##deviceName##_MspInit(CWatchdog##deviceName##variant##Handle *handle) { \
    (void)handle; Dispatch(CWatchdog_##deviceName, 1, 1); \
  }
DEFINE_CALLBACKS(IWDG, 0)
DEFINE_CALLBACKS(IWDG, 1)
DEFINE_CALLBACKS(WWDG, 0)
DEFINE_CALLBACKS(WWDG, 1)
#undef DEFINE_CALLBACKS

#define DEFINE_USER(deviceName, callbackID, implementation) \
  static void User##deviceName##callbackID##implementation(CWatchdog##deviceName##1Handle *handle) { \
    (void)handle; Dispatch(CWatchdog_##deviceName, callbackID, implementation); \
  }
DEFINE_USER(IWDG, 0, 2)
DEFINE_USER(IWDG, 0, 3)
DEFINE_USER(IWDG, 1, 2)
DEFINE_USER(IWDG, 1, 3)
DEFINE_USER(WWDG, 0, 2)
DEFINE_USER(WWDG, 0, 3)
DEFINE_USER(WWDG, 1, 2)
DEFINE_USER(WWDG, 1, 3)
#undef DEFINE_USER

#define DEFINE_SELECTOR(deviceName) \
  static CWatchdog##deviceName##1Callback Select##deviceName(uint32_t callbackID, uint32_t implementation) { \
    if (implementation == 0) return NULL; \
    assert(implementation <= 3); \
    if (callbackID == 1) { \
      if (implementation == 1) return CWatchdog##deviceName##1_HAL_##deviceName##_MspInit; \
      return implementation == 2 ? User##deviceName##12 : User##deviceName##13; \
    } \
    if (implementation == 1) return CWatchdog##deviceName##1_HAL_##deviceName##_EarlyWakeupCallback; \
    return implementation == 2 ? User##deviceName##02 : User##deviceName##03; \
  }
DEFINE_SELECTOR(IWDG)
DEFINE_SELECTOR(WWDG)
#undef DEFINE_SELECTOR

uint32_t CWatchdog_GetCallback(const CWatchdogState *state, CWatchdogDevice device, uint32_t callbackID)
{
  assert(callbackID < 2);
  for (uint32_t implementation = 0; implementation <= 3; implementation++) {
    if (device == CWatchdog_IWDG) {
      CWatchdogIWDG1Callback callback = callbackID ? state->iwdg1.MspInitCallback : state->iwdg1.EwiCallback;
      if (callback == SelectIWDG(callbackID, implementation)) return implementation;
    } else {
      CWatchdogWWDG1Callback callback = callbackID ? state->wwdg1.MspInitCallback : state->wwdg1.EwiCallback;
      if (callback == SelectWWDG(callbackID, implementation)) return implementation;
    }
  }
  assert(0 && "Unknown watchdog callback"); return 0;
}

void CWatchdog_SetCallback(CWatchdogState *state, CWatchdogDevice device, uint32_t callbackID, uint32_t implementation)
{
  assert(callbackID < 2);
  if (device == CWatchdog_IWDG) {
    if (callbackID) state->iwdg1.MspInitCallback = SelectIWDG(callbackID, implementation);
    else state->iwdg1.EwiCallback = SelectIWDG(callbackID, implementation);
  } else {
    if (callbackID) state->wwdg1.MspInitCallback = SelectWWDG(callbackID, implementation);
    else state->wwdg1.EwiCallback = SelectWWDG(callbackID, implementation);
  }
}

void CWatchdog_SetCallbackAction(CWatchdogState *state, CWatchdogDevice device, uint32_t callbackID, uint32_t action)
{
  assert(device <= CWatchdog_WWDG && callbackID < 2 && action <= 2);
  state->callbackActions[device * 2 + callbackID] = action;
}
uint32_t CWatchdog_GetCallbackAction(const CWatchdogState *state, CWatchdogDevice device, uint32_t callbackID)
{
  assert(device <= CWatchdog_WWDG && callbackID < 2);
  return state->callbackActions[device * 2 + callbackID];
}
void CWatchdog_SetCallbackMutation(CWatchdogState *state, CWatchdogDevice device, uint32_t callbackID, const uint32_t values[4])
{
  assert(device <= CWatchdog_WWDG && callbackID < 2);
  memcpy(state->callbackMutations[device * 2 + callbackID], values, 4 * sizeof(uint32_t));
}
void CWatchdog_ApplyCallbackMutation(CWatchdogState *state, CWatchdogDevice device, uint32_t callbackID)
{
  assert(device <= CWatchdog_WWDG && callbackID < 2);
  for (uint32_t word = 0; word < 4; word++) {
    CWatchdog_SetConfiguration(state, device, word, state->callbackMutations[device * 2 + callbackID][word]);
  }
}

uint32_t CWatchdog_RecordCallback(CWatchdogState *state, CWatchdogDevice device, uint32_t callbackID, uint32_t implementation)
{
  assert(state->callbackCount < 64);
  uint32_t index = state->callbackCount++;
  CWatchdogCallbackEvent *event = &state->callbacks[index];
  memset(event, 0, sizeof(*event));
  event->device = device; event->callbackID = callbackID; event->implementation = implementation;
  event->tickCall = state->tickCalls; event->writeCount = state->writeCount; event->actionStatus = UINT32_MAX;
  for (uint32_t word = 0; word < 4; word++) event->configuration[word] = CWatchdog_GetConfiguration(state, device, word);
  for (uint32_t slot = 0; slot < 2; slot++) event->callbackSlots[slot] = CWatchdog_GetCallback(state, device, slot);
  for (uint32_t reg = 0; reg < CWatchdog_RegisterCount; reg++) event->registers[reg] = CWatchdog_Get(state, (CWatchdogRegister)reg);
  return index;
}
void CWatchdog_SetCallbackActionStatus(CWatchdogState *state, uint32_t index, uint32_t status)
{
  assert(index < state->callbackCount); state->callbacks[index].actionStatus = status;
}
CWatchdogCallbackEvent CWatchdog_GetCallbackEvent(const CWatchdogState *state, uint32_t index)
{
  assert(index < state->callbackCount); return state->callbacks[index];
}

uint32_t CWatchdog_Initialize(CWatchdogState *state, CWatchdogDevice device, uint32_t nullHandle)
{
  Bind(state);
  if (device == CWatchdog_IWDG) {
    return state->registeredCallbacks ? CWatchdogIWDG1_HAL_IWDG_Init(nullHandle ? NULL : &state->iwdg1) :
                                       CWatchdogIWDG0_HAL_IWDG_Init(nullHandle ? NULL : &state->iwdg0);
  }
  return state->registeredCallbacks ? CWatchdogWWDG1_HAL_WWDG_Init(nullHandle ? NULL : &state->wwdg1) :
                                     CWatchdogWWDG0_HAL_WWDG_Init(nullHandle ? NULL : &state->wwdg0);
}
uint32_t CWatchdog_Refresh(CWatchdogState *state, CWatchdogDevice device)
{
  Bind(state);
  if (device == CWatchdog_IWDG) {
    return state->registeredCallbacks ? CWatchdogIWDG1_HAL_IWDG_Refresh(&state->iwdg1) : CWatchdogIWDG0_HAL_IWDG_Refresh(&state->iwdg0);
  }
  return state->registeredCallbacks ? CWatchdogWWDG1_HAL_WWDG_Refresh(&state->wwdg1) : CWatchdogWWDG0_HAL_WWDG_Refresh(&state->wwdg0);
}
uint32_t CWatchdog_GetActiveStatus(CWatchdogState *state)
{
  Bind(state);
  return state->registeredCallbacks ? CWatchdogIWDG1_HAL_IWDG_GetActiveStatus(&state->iwdg1) : CWatchdogIWDG0_HAL_IWDG_GetActiveStatus(&state->iwdg0);
}
void CWatchdog_HandleInterrupt(CWatchdogState *state, CWatchdogDevice device)
{
  Bind(state);
  if (device == CWatchdog_IWDG) {
    if (state->registeredCallbacks) CWatchdogIWDG1_HAL_IWDG_IRQHandler(&state->iwdg1);
    else CWatchdogIWDG0_HAL_IWDG_IRQHandler(&state->iwdg0);
  } else {
    if (state->registeredCallbacks) CWatchdogWWDG1_HAL_WWDG_IRQHandler(&state->wwdg1);
    else CWatchdogWWDG0_HAL_WWDG_IRQHandler(&state->wwdg0);
  }
}
uint32_t CWatchdog_RegisterCallback(CWatchdogState *state, CWatchdogDevice device, uint32_t callbackID, uint32_t implementation)
{
  Bind(state); assert(state->registeredCallbacks == 1);
  if (device == CWatchdog_IWDG) {
    return CWatchdogIWDG1_HAL_IWDG_RegisterCallback(&state->iwdg1, (HAL_IWDG_CallbackIDTypeDef)callbackID, SelectIWDG(callbackID, implementation));
  }
  return CWatchdogWWDG1_HAL_WWDG_RegisterCallback(&state->wwdg1, (HAL_WWDG_CallbackIDTypeDef)callbackID, SelectWWDG(callbackID, implementation));
}
uint32_t CWatchdog_UnregisterCallback(CWatchdogState *state, CWatchdogDevice device, uint32_t callbackID)
{
  Bind(state); assert(state->registeredCallbacks == 1);
  if (device == CWatchdog_IWDG) {
    return CWatchdogIWDG1_HAL_IWDG_UnRegisterCallback(&state->iwdg1, (HAL_IWDG_CallbackIDTypeDef)callbackID);
  }
  return CWatchdogWWDG1_HAL_WWDG_UnRegisterCallback(&state->wwdg1, (HAL_WWDG_CallbackIDTypeDef)callbackID);
}
