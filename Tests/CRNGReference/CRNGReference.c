/* Host-only hardware stimulus and observations for the independent pinned HAL.
 * No RNG algorithm is reimplemented here. See the Upstream function extracts for
 * unchanged ST implementation and its BSD-3-Clause attribution. */
#include "include/CRNGReference.h"
#include "Upstream/RNGBits.h"
#include "Upstream/RNGModelFunctions.h"
#include <assert.h>
#include <limits.h>
#include <stddef.h>
#include <string.h>

_Thread_local CRNGReferenceState *CRNGReference_Current;

static void Bind(CRNGReferenceState *state)
{
  assert(state != NULL);
  CRNGReference_Current = state;
  state->handle0.Instance = &state->registers;
  state->handle1.Instance = &state->registers;
}

static volatile uint32_t *Address(CRNGReferenceState *state, CRNGReferenceRegister reg)
{
  switch (reg) {
    case CRNGReference_CR: return &state->registers.CR;
    case CRNGReference_SR: return &state->registers.SR;
    case CRNGReference_DR: return &state->registers.DR[0];
    case CRNGReference_HTCR: return &state->registers.HTCR;
    default: assert(0); return NULL;
  }
}

static CRNGReferenceRegister RegisterAt(volatile uint32_t *address)
{
  for (uint32_t reg = 0; reg < CRNGReference_RegisterCount; ++reg) {
    if (address == Address(CRNGReference_Current, (CRNGReferenceRegister)reg)) {
      return (CRNGReferenceRegister)reg;
    }
  }
  assert(0);
  return CRNGReference_CR;
}

void CRNGReference_Reset(CRNGReferenceState *state, uint32_t registeredCallbacks)
{
  memset(state, 0, sizeof(*state));
  state->registeredCallbacks = registeredCallbacks != 0;
  state->tickStep = 1;
  state->automaticTransitions = CRNGReference_AutoAll;
  Bind(state);
}

void CRNGReference_Set(CRNGReferenceState *state, CRNGReferenceRegister reg, uint32_t value)
{
  *Address(state, reg) = value;
}

uint32_t CRNGReference_Get(const CRNGReferenceState *state, CRNGReferenceRegister reg)
{
  switch (reg) {
    case CRNGReference_CR: return state->registers.CR;
    case CRNGReference_SR: return state->registers.SR;
    case CRNGReference_DR: return state->registers.DR[0];
    case CRNGReference_HTCR: return state->registers.HTCR;
    default: assert(0); return 0;
  }
}

void CRNGReference_SetHandle(CRNGReferenceState *state, CRNGReferenceHandleWord word, uint32_t value)
{
#define SET_WORD(field, cast) do { if (state->registeredCallbacks) state->handle1.field = (cast)value; else state->handle0.field = (cast)value; } while (0)
  switch (word) {
    case CRNGReference_ClockErrorDetection: SET_WORD(Init.ClockErrorDetection, uint32_t); break;
    case CRNGReference_Lock: SET_WORD(Lock, HAL_LockTypeDef); break;
    case CRNGReference_State: SET_WORD(State, HAL_RNG_StateTypeDef); break;
    case CRNGReference_ErrorCode: SET_WORD(ErrorCode, uint32_t); break;
    case CRNGReference_RandomNumber: SET_WORD(RandomNumber, uint32_t); break;
    default: assert(0);
  }
#undef SET_WORD
}

uint32_t CRNGReference_GetHandle(const CRNGReferenceState *state, CRNGReferenceHandleWord word)
{
#define GET_WORD(field) (state->registeredCallbacks ? state->handle1.field : state->handle0.field)
  switch (word) {
    case CRNGReference_ClockErrorDetection: return GET_WORD(Init.ClockErrorDetection);
    case CRNGReference_Lock: return GET_WORD(Lock);
    case CRNGReference_State: return GET_WORD(State);
    case CRNGReference_ErrorCode: return GET_WORD(ErrorCode);
    case CRNGReference_RandomNumber: return GET_WORD(RandomNumber);
    default: assert(0); return 0;
  }
#undef GET_WORD
}

static uint32_t TriggerCount(CRNGReferenceState *state, CRNGReferenceTrigger trigger)
{
  if (trigger == CRNGReference_OnTick) return state->tickCalls;
  assert(trigger >= CRNGReference_OnCRRead && trigger <= CRNGReference_OnHTCRRead);
  return state->readCalls[trigger - CRNGReference_OnCRRead];
}

static void ApplyEvent(CRNGReferenceState *state, const CRNGReferenceEvent *event)
{
  volatile uint32_t *address = Address(state, event->reg);
  *address = (*address & ~event->clearMask) | event->setMask;
}

static void RunEvents(CRNGReferenceState *state, CRNGReferenceTrigger trigger)
{
  uint32_t count = TriggerCount(state, trigger);
  for (uint32_t i = 0; i < 64; ++i) {
    CRNGReferenceEvent *event = &state->events[i];
    if (event->active && event->trigger == trigger && event->dueCall <= count) {
      ApplyEvent(state, event);
      event->active = 0;
    }
  }
}

void CRNGReference_Schedule(CRNGReferenceState *state, CRNGReferenceTrigger trigger,
                            uint32_t afterCalls, CRNGReferenceRegister reg,
                            uint32_t clearMask, uint32_t setMask)
{
  CRNGReferenceEvent event = {trigger, reg, TriggerCount(state, trigger) + afterCalls,
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
  assert(!"RNG event capacity exceeded");
}

uint32_t CRNGReference_Read(CRNGReferenceState *state, CRNGReferenceRegister reg)
{
  Bind(state);
  assert(reg < CRNGReference_RegisterCount);
  state->readCalls[reg]++;
  if (reg == CRNGReference_DR && state->dataIndex < state->dataCount) {
    state->registers.DR[0] = state->data[state->dataIndex++];
  }
  RunEvents(state, (CRNGReferenceTrigger)(CRNGReference_OnCRRead + reg));
  return *Address(state, reg);
}

void CRNGReference_Write(CRNGReferenceState *state, CRNGReferenceRegister reg, uint32_t value)
{
  Bind(state);
  assert(state->writeCount < 256);
  state->writes[state->writeCount++] = (CRNGReferenceWrite){reg, value, state->tickCalls};
  volatile uint32_t *address = Address(state, reg);
  uint32_t old = *address;
  if (reg == CRNGReference_SR) {
    *address = old & (value | ~(RNG_SR_CEIS | RNG_SR_SEIS));
    return;
  }
  *address = value;
  if (reg != CRNGReference_CR) return;

  if ((old & RNG_CR_CONDRST) && !(value & RNG_CR_CONDRST)) {
    /* The falling-edge request remains asserted until its configured hardware
     * completion. Automatic behavior is explicit and can be disabled. */
    *address |= RNG_CR_CONDRST;
    if (state->automaticTransitions & CRNGReference_AutoConditioning) {
      CRNGReference_Schedule(state, CRNGReference_OnCRRead, state->conditioningReadDelay,
                              CRNGReference_CR, RNG_CR_CONDRST, 0);
      if (state->automaticTransitions & CRNGReference_AutoClearSeedStatus) {
        CRNGReference_Schedule(state, CRNGReference_OnCRRead, state->conditioningReadDelay,
                                CRNGReference_SR, RNG_SR_SECS, 0);
      }
    }
  }
  if (!(old & RNG_CR_RNGEN) && (value & RNG_CR_RNGEN) &&
      (state->automaticTransitions & CRNGReference_AutoDataReady)) {
    CRNGReference_Schedule(state, CRNGReference_OnSRRead, state->dataReadyReadDelay,
                            CRNGReference_SR, 0, RNG_SR_DRDY);
  }
}

uint32_t CRNGReference_Tick(CRNGReferenceState *state)
{
  Bind(state);
  uint32_t result = state->tick;
  state->tick += state->tickStep;
  state->tickCalls++;
  RunEvents(state, CRNGReference_OnTick);
  return result;
}

void CRNGReference_PushData(CRNGReferenceState *state, uint32_t value)
{
  assert(state->dataCount < 64);
  state->data[state->dataCount++] = value;
}

uint32_t CRNGReference_ReadAddress(volatile uint32_t *address)
{
  return CRNGReference_Read(CRNGReference_Current, RegisterAt(address));
}

void CRNGReference_WriteAddress(volatile uint32_t *address, uint32_t value)
{
  CRNGReference_Write(CRNGReference_Current, RegisterAt(address), value);
}

uint32_t CRNGReference_HardwareTick(void)
{
  return CRNGReference_Tick(CRNGReference_Current);
}

uint32_t CRNGReference_PrepareDataRead(void)
{
  (void)CRNGReference_Read(CRNGReference_Current, CRNGReference_DR);
  return 0;
}

CRNGReferenceWrite CRNGReference_GetWrite(const CRNGReferenceState *state, uint32_t index)
{
  assert(index < state->writeCount);
  return state->writes[index];
}

CRNGReferenceCallback CRNGReference_GetCallbackEvent(const CRNGReferenceState *state, uint32_t index)
{
  assert(index < state->callbackCount);
  return state->callbacks[index];
}

uint32_t CRNGReference_ReadCount(const CRNGReferenceState *state, CRNGReferenceRegister reg)
{
  assert(reg < CRNGReference_RegisterCount);
  return state->readCalls[reg];
}

void CRNGReference_SetCallbackAction(CRNGReferenceState *state, uint32_t callbackID, uint32_t action)
{
  assert(callbackID < 4 && action <= 1);
  state->callbackActions[callbackID] = action;
}

uint32_t CRNGReference_GetCallbackAction(const CRNGReferenceState *state, uint32_t callbackID)
{
  assert(callbackID < 4);
  return state->callbackActions[callbackID];
}

void CRNGReference_SetCallbackActionStatus(CRNGReferenceState *state, uint32_t index, uint32_t status)
{
  assert(index < state->callbackCount);
  state->callbacks[index].actionStatus = status;
}

uint32_t CRNGReference_RecordCallback(CRNGReferenceState *state, uint32_t callbackID,
                                      uint32_t implementation, uint32_t argument)
{
  assert(state->callbackCount < 64 && callbackID < 4);
  uint32_t index = state->callbackCount++;
  state->callbacks[index] = (CRNGReferenceCallback){
    callbackID, implementation, argument,
    CRNGReference_GetHandle(state, CRNGReference_Lock),
    CRNGReference_GetHandle(state, CRNGReference_State),
    CRNGReference_GetHandle(state, CRNGReference_ErrorCode),
    CRNGReference_GetHandle(state, CRNGReference_RandomNumber),
    state->registers.CR, state->registers.SR, state->tickCalls, state->writeCount,
    state->readCalls[CRNGReference_DR], UINT32_MAX
  };
  return index;
}

static void RecordCallback(uint32_t callbackID, uint32_t implementation, uint32_t argument)
{
  CRNGReferenceState *state = CRNGReference_Current;
  uint32_t index = CRNGReference_RecordCallback(state, callbackID, implementation, argument);
  if (state->callbackActions[callbackID] == 1) {
    state->callbacks[index].actionStatus = CRNGReference_GenerateInterrupt(state);
  }
}

/* These strong definitions intentionally override the unchanged weak HAL
 * defaults exactly as application callbacks do in the linked firmware. */
#define DEFAULT_CALLBACKS(variant) \
  void CRNG##variant##_HAL_RNG_MspInit(CRNG##variant##Handle *handle) \
  { (void)handle; RecordCallback(CRNGReference_MspInitCallback, 1, 0); } \
  void CRNG##variant##_HAL_RNG_MspDeInit(CRNG##variant##Handle *handle) \
  { (void)handle; RecordCallback(CRNGReference_MspDeInitCallback, 1, 0); } \
  void CRNG##variant##_HAL_RNG_ErrorCallback(CRNG##variant##Handle *handle) \
  { (void)handle; RecordCallback(CRNGReference_ErrorCallback, 1, 0); } \
  void CRNG##variant##_HAL_RNG_ReadyDataCallback(CRNG##variant##Handle *handle, uint32_t value) \
  { (void)handle; RecordCallback(CRNGReference_ReadyCallback, 1, value); }
DEFAULT_CALLBACKS(0)
DEFAULT_CALLBACKS(1)
#undef DEFAULT_CALLBACKS

#define CUSTOM_CALLBACKS(suffix, selector) \
  static void CustomError##suffix(CRNG1Handle *handle) \
  { (void)handle; RecordCallback(CRNGReference_ErrorCallback, selector, 0); } \
  static void CustomMspInit##suffix(CRNG1Handle *handle) \
  { (void)handle; RecordCallback(CRNGReference_MspInitCallback, selector, 0); } \
  static void CustomMspDeInit##suffix(CRNG1Handle *handle) \
  { (void)handle; RecordCallback(CRNGReference_MspDeInitCallback, selector, 0); } \
  static void CustomReady##suffix(CRNG1Handle *handle, uint32_t value) \
  { (void)handle; RecordCallback(CRNGReference_ReadyCallback, selector, value); }
CUSTOM_CALLBACKS(A, 2)
CUSTOM_CALLBACKS(B, 3)
#undef CUSTOM_CALLBACKS

static pRNG_CallbackTypeDef SelectCallback(uint32_t callbackID, uint32_t selector)
{
  assert(selector <= 3);
  if (selector == 0) return NULL;
  switch (callbackID) {
    case CRNGReference_MspInitCallback:
      return selector == 1 ? CRNG1_HAL_RNG_MspInit : selector == 2 ? CustomMspInitA : CustomMspInitB;
    case CRNGReference_MspDeInitCallback:
      return selector == 1 ? CRNG1_HAL_RNG_MspDeInit : selector == 2 ? CustomMspDeInitA : CustomMspDeInitB;
    default:
      return selector == 1 ? CRNG1_HAL_RNG_ErrorCallback : selector == 2 ? CustomErrorA : CustomErrorB;
  }
}

static pRNG_ReadyDataCallbackTypeDef SelectReady(uint32_t selector)
{
  assert(selector <= 3);
  if (selector == 0) return NULL;
  return selector == 1 ? CRNG1_HAL_RNG_ReadyDataCallback : selector == 2 ? CustomReadyA : CustomReadyB;
}

void CRNGReference_SetCallback(CRNGReferenceState *state, uint32_t callbackID, uint32_t selector)
{
  Bind(state);
  switch (callbackID) {
    case CRNGReference_ErrorCallback: state->handle1.ErrorCallback = SelectCallback(callbackID, selector); break;
    case CRNGReference_MspInitCallback: state->handle1.MspInitCallback = SelectCallback(callbackID, selector); break;
    case CRNGReference_MspDeInitCallback: state->handle1.MspDeInitCallback = SelectCallback(callbackID, selector); break;
    case CRNGReference_ReadyCallback: state->handle1.ReadyDataCallback = SelectReady(selector); break;
    default: assert(0);
  }
}

uint32_t CRNGReference_GetCallback(const CRNGReferenceState *state, uint32_t callbackID)
{
  if (!state->registeredCallbacks) return 1;
  for (uint32_t selector = 0; selector <= 3; ++selector) {
    switch (callbackID) {
      case CRNGReference_ErrorCallback:
        if (state->handle1.ErrorCallback == SelectCallback(callbackID, selector)) return selector;
        break;
      case CRNGReference_MspInitCallback:
        if (state->handle1.MspInitCallback == SelectCallback(callbackID, selector)) return selector;
        break;
      case CRNGReference_MspDeInitCallback:
        if (state->handle1.MspDeInitCallback == SelectCallback(callbackID, selector)) return selector;
        break;
      case CRNGReference_ReadyCallback:
        if (state->handle1.ReadyDataCallback == SelectReady(selector)) return selector;
        break;
      default: assert(0);
    }
  }
  assert(!"Unknown callback pointer");
  return UINT32_MAX;
}

uint32_t CRNGReference_RegisterCallback(CRNGReferenceState *state, uint32_t callbackID, uint32_t selector)
{
  Bind(state);
  assert(state->registeredCallbacks);
  return CRNG1_HAL_RNG_RegisterCallback(&state->handle1, (HAL_RNG_CallbackIDTypeDef)callbackID,
                                       SelectCallback(callbackID, selector));
}

uint32_t CRNGReference_UnregisterCallback(CRNGReferenceState *state, uint32_t callbackID)
{
  Bind(state);
  assert(state->registeredCallbacks);
  return CRNG1_HAL_RNG_UnRegisterCallback(&state->handle1, (HAL_RNG_CallbackIDTypeDef)callbackID);
}

uint32_t CRNGReference_RegisterReadyCallback(CRNGReferenceState *state, uint32_t selector)
{
  Bind(state);
  assert(state->registeredCallbacks);
  return CRNG1_HAL_RNG_RegisterReadyDataCallback(&state->handle1, SelectReady(selector));
}

uint32_t CRNGReference_UnregisterReadyCallback(CRNGReferenceState *state)
{
  Bind(state);
  assert(state->registeredCallbacks);
  return CRNG1_HAL_RNG_UnRegisterReadyDataCallback(&state->handle1);
}

#define SIMPLE_WRAPPER(publicName, halName) \
  uint32_t CRNGReference_##publicName(CRNGReferenceState *state) { \
    Bind(state); \
    return state->registeredCallbacks ? CRNG1_##halName(&state->handle1) : CRNG0_##halName(&state->handle0); \
  }
SIMPLE_WRAPPER(Initialize, HAL_RNG_Init)
SIMPLE_WRAPPER(Deinitialize, HAL_RNG_DeInit)
SIMPLE_WRAPPER(GenerateInterrupt, HAL_RNG_GenerateRandomNumber_IT)
SIMPLE_WRAPPER(ReadLast, HAL_RNG_ReadLastRandomNumber)
SIMPLE_WRAPPER(GetState, HAL_RNG_GetState)
SIMPLE_WRAPPER(GetError, HAL_RNG_GetError)
SIMPLE_WRAPPER(Recover, RNG_RecoverSeedError)
SIMPLE_WRAPPER(RecoverExtended, HAL_RNGEx_RecoverSeedError)
SIMPLE_WRAPPER(LockConfig, HAL_RNGEx_LockConfig)
#undef SIMPLE_WRAPPER

uint32_t CRNGReference_Generate(CRNGReferenceState *state, uint32_t *output)
{
  Bind(state);
  return state->registeredCallbacks ? CRNG1_HAL_RNG_GenerateRandomNumber(&state->handle1, output)
                                    : CRNG0_HAL_RNG_GenerateRandomNumber(&state->handle0, output);
}

void CRNGReference_HandleInterrupt(CRNGReferenceState *state)
{
  Bind(state);
  if (state->registeredCallbacks) CRNG1_HAL_RNG_IRQHandler(&state->handle1);
  else CRNG0_HAL_RNG_IRQHandler(&state->handle0);
}

uint32_t CRNGReference_SetConfig(CRNGReferenceState *state, const RNG_ConfigTypeDef *config)
{
  Bind(state);
  return state->registeredCallbacks ? CRNG1_HAL_RNGEx_SetConfig(&state->handle1, config)
                                    : CRNG0_HAL_RNGEx_SetConfig(&state->handle0, config);
}

uint32_t CRNGReference_GetConfig(CRNGReferenceState *state, RNG_ConfigTypeDef *config)
{
  Bind(state);
  return state->registeredCallbacks ? CRNG1_HAL_RNGEx_GetConfig(&state->handle1, config)
                                    : CRNG0_HAL_RNGEx_GetConfig(&state->handle0, config);
}

uint32_t CRNGReference_NullHandle(uint32_t registeredCallbacks, uint32_t operation)
{
#define NULL_CASE(index, name, ...) case index: return registeredCallbacks ? CRNG1_##name(NULL, ##__VA_ARGS__) : CRNG0_##name(NULL, ##__VA_ARGS__)
  RNG_ConfigTypeDef config = {0};
  switch (operation) {
    NULL_CASE(0, HAL_RNG_Init);
    NULL_CASE(1, HAL_RNG_DeInit);
    NULL_CASE(2, HAL_RNGEx_SetConfig, &config);
    NULL_CASE(3, HAL_RNGEx_GetConfig, &config);
    NULL_CASE(4, HAL_RNGEx_LockConfig);
    NULL_CASE(5, HAL_RNGEx_RecoverSeedError);
    default: assert(0); return HAL_ERROR;
  }
#undef NULL_CASE
}
