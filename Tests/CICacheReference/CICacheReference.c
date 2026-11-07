#include "Upstream/ICacheReferenceShim.h"
#include "Upstream/ICacheMacros.h"
#include "Upstream/ICacheNamespace.h"
#include "Upstream/ICachePrototypes.inc"
#include <string.h>

_Thread_local CICacheState *CICache_Current;

static volatile uint32_t *Address(CICacheState *state, CICacheRegister reg)
{
  switch (reg)
  {
    case CICache_CR: return &state->registers.CR;
    case CICache_SR: return &state->registers.SR;
    case CICache_IER: return &state->registers.IER;
    case CICache_FCR: return &state->registers.FCR;
    case CICache_HMONR: return &state->registers.HMONR;
    case CICache_MMONR: return &state->registers.MMONR;
    default: assert(0); return NULL;
  }
}

static CICacheRegister Register(volatile uint32_t *address)
{
  for (uint32_t i = 0; i < CICache_RegisterCount; ++i)
    if (address == Address(CICache_Current, (CICacheRegister)i)) return (CICacheRegister)i;
  assert(0);
  return CICache_RegisterCount;
}

static void Trace(CICacheState *state, CICacheAccessKind kind, CICacheRegister reg, uint32_t value)
{
  assert(state->accessCount < 256);
  state->accesses[state->accessCount++] = (CICacheAccess){kind, reg, value, state->tickCalls};
}

void CICache_Reset(CICacheState *state)
{
  memset(state, 0, sizeof(*state));
  state->registers.CR = 4;
  state->tickStep = 1;
}

void CICache_Set(CICacheState *state, CICacheRegister reg, uint32_t value)
{
  *Address(state, reg) = value;
}

uint32_t CICache_Get(const CICacheState *state, CICacheRegister reg)
{
  return *Address((CICacheState *)state, reg);
}

static void Apply(CICacheState *state, const CICacheEvent *event)
{
  CICache_Set(state, event->reg, (CICache_Get(state, event->reg) & ~event->clearMask) | event->setMask);
}

static void ApplyDue(CICacheState *state, uint32_t kind, CICacheRegister reg, uint32_t count)
{
  for (uint32_t i = 0; i < 32; ++i)
  {
    CICacheEvent *event = &state->events[i];
    if (event->active && event->kind == kind && (kind == 1 || event->reg == reg) && event->dueCall == count)
    {
      Apply(state, event);
      event->active = 0;
    }
  }
}

uint32_t CICache_Read(CICacheState *state, CICacheRegister reg)
{
  assert(reg < CICache_RegisterCount);
  ++state->readCounts[reg];
  ApplyDue(state, 0, reg, state->readCounts[reg]);
  uint32_t value = CICache_Get(state, reg);
  Trace(state, CICache_ReadAccess, reg, value);
  return value;
}

void CICache_Write(CICacheState *state, CICacheRegister reg, uint32_t value)
{
  CICache_Set(state, reg, value);
  Trace(state, CICache_WriteAccess, reg, value);
}

uint32_t CICache_GetReadCount(const CICacheState *state, CICacheRegister reg)
{
  assert(reg < CICache_RegisterCount);
  return state->readCounts[reg];
}

uint32_t CICache_Tick(CICacheState *state)
{
  uint32_t value = state->tick;
  state->tick += state->tickStep;
  ++state->tickCalls;
  ApplyDue(state, 1, CICache_RegisterCount, state->tickCalls);
  Trace(state, CICache_TickAccess, CICache_RegisterCount, value);
  return value;
}

static void Schedule(CICacheState *state, uint32_t kind, uint32_t afterCalls,
                     CICacheRegister reg, uint32_t clearMask, uint32_t setMask)
{
  uint32_t count = kind == 0 ? CICache_GetReadCount(state, reg) : state->tickCalls;
  CICacheEvent event = {kind, count + afterCalls, 1, reg, clearMask, setMask};
  if (afterCalls == 0) { Apply(state, &event); return; }
  for (uint32_t i = 0; i < 32; ++i)
  {
    if (!state->events[i].active) { state->events[i] = event; return; }
  }
  assert(0);
}

void CICache_ScheduleRead(CICacheState *state, uint32_t afterCalls, CICacheRegister reg,
                          uint32_t clearMask, uint32_t setMask)
{
  Schedule(state, 0, afterCalls, reg, clearMask, setMask);
}

void CICache_ScheduleTick(CICacheState *state, uint32_t afterCalls, CICacheRegister reg,
                          uint32_t clearMask, uint32_t setMask)
{
  Schedule(state, 1, afterCalls, reg, clearMask, setMask);
}

CICacheAccess CICache_GetAccess(const CICacheState *state, uint32_t index)
{
  assert(index < state->accessCount);
  return state->accesses[index];
}

uint32_t CICache_ReadAddress(volatile uint32_t *address)
{
  return CICache_Read(CICache_Current, Register(address));
}

void CICache_WriteAddress(volatile uint32_t *address, uint32_t value)
{
  CICache_Write(CICache_Current, Register(address), value);
}

uint32_t CICache_HardwareTick(void) { return CICache_Tick(CICache_Current); }

void CICache_SetCallbackAction(CICacheState *state, uint32_t callbackID, uint32_t action,
                               uint32_t argument0, uint32_t argument1)
{
  assert(callbackID < 2 && action <= 6);
  state->callbackActions[callbackID] = (CICacheCallbackAction){action, argument0, argument1};
}

CICacheCallbackAction CICache_GetCallbackAction(const CICacheState *state, uint32_t callbackID)
{
  assert(callbackID < 2);
  return state->callbackActions[callbackID];
}

uint32_t CICache_RecordCallback(CICacheState *state, uint32_t callbackID)
{
  assert(callbackID < 2 && state->callbackCount < 32);
  uint32_t index = state->callbackCount++;
  Trace(state, CICache_CallbackAccess, CICache_RegisterCount, callbackID);
  CICacheCallbackEvent *event = &state->callbacks[index];
  event->callbackID = callbackID;
  event->tickCall = state->tickCalls;
  event->accessCount = state->accessCount;
  for (uint32_t i = 0; i < CICache_RegisterCount; ++i)
    event->registers[i] = CICache_Get(state, (CICacheRegister)i);
  return index;
}

void CICache_SetCallbackActionStatus(CICacheState *state, uint32_t index, uint32_t status)
{
  assert(index < state->callbackCount);
  state->callbacks[index].actionStatus = status;
}

CICacheCallbackEvent CICache_GetCallbackEvent(const CICacheState *state, uint32_t index)
{
  assert(index < state->callbackCount);
  return state->callbacks[index];
}

uint32_t CICache_GetCallbackRegister(const CICacheState *state, uint32_t index, CICacheRegister reg)
{
  assert(index < state->callbackCount && reg < CICache_RegisterCount);
  return state->callbacks[index].registers[reg];
}

static void Callback(uint32_t callbackID)
{
  CICacheState *state = CICache_Current;
  uint32_t index = CICache_RecordCallback(state, callbackID);
  CICacheCallbackAction action = CICache_GetCallbackAction(state, callbackID);
  uint32_t status = HAL_OK;
  switch (action.action)
  {
    case 0: break;
    case 1: status = HAL_ICACHE_Invalidate_IT(); break;
    case 2:
      WRITE_REG(ICACHE->SR, action.argument0);
      WRITE_REG(ICACHE->IER, action.argument1);
      break;
    case 3: __HAL_ICACHE_CLEAR_FLAG(action.argument0); break;
    case 4: __HAL_ICACHE_ENABLE_IT(action.argument0); break;
    case 5: __HAL_ICACHE_DISABLE_IT(action.argument0); break;
    case 6: status = HAL_ICACHE_DeInit(); break;
    default: assert(0);
  }
  CICache_SetCallbackActionStatus(state, index, status);
}

/* Application overrides of the unchanged weak functions in the other TU. */
void HAL_ICACHE_ErrorCallback(void) { Callback(0); }
void HAL_ICACHE_InvalidateCompleteCallback(void) { Callback(1); }

uint32_t CICache_Call(CICacheState *state, CICacheOperation operation, uint32_t argument)
{
  CICache_Current = state;
  switch (operation)
  {
    case CICache_ConfigureAssociativity: return HAL_ICACHE_ConfigAssociativityMode(argument);
    case CICache_Deinitialize: return HAL_ICACHE_DeInit();
    case CICache_Enable: return HAL_ICACHE_Enable();
    case CICache_Disable: return HAL_ICACHE_Disable();
    case CICache_IsEnabled: return HAL_ICACHE_IsEnabled();
    case CICache_Invalidate: return HAL_ICACHE_Invalidate();
    case CICache_InvalidateInterrupt: return HAL_ICACHE_Invalidate_IT();
    case CICache_WaitForInvalidateComplete: return HAL_ICACHE_WaitForInvalidateComplete();
    case CICache_StartMonitor: return HAL_ICACHE_Monitor_Start(argument);
    case CICache_StopMonitor: return HAL_ICACHE_Monitor_Stop(argument);
    case CICache_ResetMonitor: return HAL_ICACHE_Monitor_Reset(argument);
    case CICache_GetHitValue: return HAL_ICACHE_Monitor_GetHitValue();
    case CICache_GetMissValue: return HAL_ICACHE_Monitor_GetMissValue();
    case CICache_HandleInterrupt: HAL_ICACHE_IRQHandler(); return HAL_OK;
    case CICache_EnableInterrupts: __HAL_ICACHE_ENABLE_IT(argument); return HAL_OK;
    case CICache_DisableInterrupts: __HAL_ICACHE_DISABLE_IT(argument); return HAL_OK;
    case CICache_GetInterruptSource: return __HAL_ICACHE_GET_IT_SOURCE(argument);
    case CICache_GetFlag: return __HAL_ICACHE_GET_FLAG(argument);
    case CICache_ClearFlag: __HAL_ICACHE_CLEAR_FLAG(argument); return HAL_OK;
    default: assert(0); return HAL_ERROR;
  }
}
