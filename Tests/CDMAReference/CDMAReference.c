/* Host-only stimulus and callback overrides. Original algorithms are in the
 * unchanged DMAFunctions/DMA_EXFunctions includes. This file is not used by
 * the ARM harness, which supplies CDMA_HardwareTick itself. */
#if !defined(CDMA_REFERENCE_ARM)
#include "include/CDMAReference.h"
#include <assert.h>
#include <stddef.h>
#include <string.h>

_Thread_local CDMAState *CDMA_Current;
typedef void (*CDMACallbackFunction)(DMA_HandleTypeDef *);

static void Bind(CDMAState *state)
{
  assert(state->controller < 2 && state->channel < 16);
  CDMA_Current = state;
  state->handle.Instance = &state->channels[state->controller][state->channel];
  /* Rebind copied model storage without recreating pointers cleared by HAL. */
  if (state->handle.LinkedListQueue) state->handle.LinkedListQueue = &state->queue;
  if (state->queue.Head) state->queue.Head = &state->node;
  if (state->queue.FirstCircularNode) state->queue.FirstCircularNode = &state->node;
}

DMA_TypeDef *CDMA_ControllerFor(const DMA_Channel_TypeDef *channel)
{
  for (uint32_t controller = 0; controller < 2; controller++) {
    for (uint32_t index = 0; index < 16; index++) {
      if (channel == &CDMA_Current->channels[controller][index]) return &CDMA_Current->controllers[controller];
    }
  }
  assert(0 && "Unknown DMA controller"); return NULL;
}
uint32_t CDMA_ChannelFor(const DMA_Channel_TypeDef *channel)
{
  for (uint32_t controller = 0; controller < 2; controller++) {
    for (uint32_t index = 0; index < 16; index++) {
      if (channel == &CDMA_Current->channels[controller][index]) return index;
    }
  }
  assert(0 && "Unknown DMA channel"); return 0;
}

static volatile uint32_t *Address(CDMAState *state, CDMARegister reg)
{
  DMA_Channel_TypeDef *channel = &state->channels[state->controller][state->channel];
  DMA_TypeDef *controller = &state->controllers[state->controller];
  switch (reg) {
  case CDMA_CLBAR: return &channel->CLBAR;
  case CDMA_CFCR: return &channel->CFCR;
  case CDMA_CSR: return &channel->CSR;
  case CDMA_CCR: return &channel->CCR;
  case CDMA_CTR1: return &channel->CTR1;
  case CDMA_CTR2: return &channel->CTR2;
  case CDMA_CBR1: return &channel->CBR1;
  case CDMA_CSAR: return &channel->CSAR;
  case CDMA_CDAR: return &channel->CDAR;
  case CDMA_CTR3: return &channel->CTR3;
  case CDMA_CBR2: return &channel->CBR2;
  case CDMA_CLLR: return &channel->CLLR;
  case CDMA_PRIVCFGR: return &controller->PRIVCFGR;
  case CDMA_RCFGLOCKR: return &controller->RCFGLOCKR;
  case CDMA_MISR: return &controller->MISR;
  default: assert(0 && "Unknown DMA register"); return NULL;
  }
}

void CDMA_Reset(CDMAState *state, uint32_t controller, uint32_t channel)
{
  assert(controller < 2 && channel < 16);
  memset(state, 0, sizeof(*state));
  state->controller = controller; state->channel = channel;
  state->queueAddress = 0x20001000; state->nodeAddress = 0x20002000;
  state->tickStep = 1;
  state->handle.Init.SrcBurstLength = 1; state->handle.Init.DestBurstLength = 1;
  state->handle.InitLinkedList.LinkedListMode = DMA_LINKEDLIST_NORMAL;
  state->nodeConfiguration.Init.SrcBurstLength = 1; state->nodeConfiguration.Init.DestBurstLength = 1;
  state->nodeConfiguration.NodeType = DMA_GPDMA_LINEAR_NODE;
  state->nodeConfiguration.RepeatBlockConfig.RepeatCount = 1;
  state->repeatBlock.RepeatCount = 1;
  Bind(state);
  state->handle.Instance->CSR = DMA_CSR_IDLEF;
}

void CDMA_Set(CDMAState *state, CDMARegister reg, uint32_t value) { *Address(state, reg) = value; }
uint32_t CDMA_Get(const CDMAState *state, CDMARegister reg) { return *Address((CDMAState *)state, reg); }

void CDMA_SetHandle(CDMAState *state, uint32_t word, uint32_t value)
{
  switch (word) {
  case 0: state->handle.Lock = (HAL_LockTypeDef)value; break;
  case 1: state->handle.Mode = value; break;
  case 2: state->handle.State = (HAL_DMA_StateTypeDef)value; break;
  case 3: state->handle.ErrorCode = value; break;
  case 4:
    state->handle.LinkedListQueue = value ? &state->queue : NULL;
    if (value) state->queueAddress = value;
    break;
  default: assert(0 && "Unknown DMA handle word");
  }
}
uint32_t CDMA_GetHandle(const CDMAState *state, uint32_t word)
{
  switch (word) {
  case 0: return state->handle.Lock;
  case 1: return state->handle.Mode;
  case 2: return state->handle.State;
  case 3: return state->handle.ErrorCode;
  case 4: return state->handle.LinkedListQueue ? state->queueAddress : 0;
  default: assert(0 && "Unknown DMA handle word"); return 0;
  }
}
void CDMA_SetQueue(CDMAState *state, uint32_t word, uint32_t value)
{
  switch (word) {
  case 0:
    assert(value == 0 || value == state->nodeAddress);
    state->queue.Head = value ? &state->node : NULL; break;
  case 1:
    assert(value == 0 || value == state->nodeAddress);
    state->queue.FirstCircularNode = value ? &state->node : NULL; break;
  case 2: state->queue.NodeNumber = value; break;
  case 3: state->queue.State = (HAL_DMA_QStateTypeDef)value; break;
  case 4: state->queue.ErrorCode = value; break;
  case 5: state->queue.Type = value; break;
  default: assert(0 && "Unknown DMA queue word");
  }
}
uint32_t CDMA_GetQueue(const CDMAState *state, uint32_t word)
{
  switch (word) {
  case 0: return state->queue.Head ? state->nodeAddress : 0;
  case 1: return state->queue.FirstCircularNode ? state->nodeAddress : 0;
  case 2: return state->queue.NodeNumber;
  case 3: return state->queue.State;
  case 4: return state->queue.ErrorCode;
  case 5: return state->queue.Type;
  default: assert(0 && "Unknown DMA queue word"); return 0;
  }
}
void CDMA_SetParent(CDMAState *state, uintptr_t parent) { state->handle.Parent = (void *)parent; }
uintptr_t CDMA_GetParent(const CDMAState *state) { return (uintptr_t)state->handle.Parent; }

static CDMASnapshot Snapshot(const CDMAState *state)
{
  CDMASnapshot result;
  memset(&result, 0, sizeof(result));
  result.tick = state->tick; result.tickCall = state->tickCalls;
  for (uint32_t index = 0; index < 5; index++) result.handle[index] = CDMA_GetHandle(state, index);
  for (uint32_t index = 0; index < 6; index++) result.queue[index] = CDMA_GetQueue(state, index);
  for (uint32_t index = 0; index < CDMA_RegisterCount; index++) result.registers[index] = CDMA_Get(state, (CDMARegister)index);
  return result;
}

void CDMA_ScheduleTick(CDMAState *state, uint32_t afterCalls, CDMARegister reg, uint32_t clearMask, uint32_t setMask)
{
  if (afterCalls == 0) {
    CDMA_Set(state, reg, (CDMA_Get(state, reg) & ~clearMask) | setMask); return;
  }
  for (uint32_t index = 0; index < 64; index++) {
    if (!state->events[index].active) {
      state->events[index] = (CDMAEvent){reg, state->tickCalls + afterCalls, clearMask, setMask, 1}; return;
    }
  }
  assert(0 && "Too many DMA events");
}
uint32_t CDMA_Tick(CDMAState *state)
{
  Bind(state);
  assert(state->snapshotCount < 256 && "DMA fixture exceeded its bounded tick budget");
  state->snapshots[state->snapshotCount++] = Snapshot(state);
  uint32_t result = state->tick;
  state->tick += state->tickStep; state->tickCalls++;
  for (uint32_t index = 0; index < 64; index++) {
    CDMAEvent *event = &state->events[index];
    if (event->active && event->dueCall <= state->tickCalls) {
      CDMA_Set(state, event->reg, (CDMA_Get(state, event->reg) & ~event->clearMask) | event->setMask);
      event->active = 0;
    }
  }
  return result;
}
uint32_t CDMA_HardwareTick(void) { return CDMA_Tick(CDMA_Current); }
CDMASnapshot CDMA_GetSnapshot(const CDMAState *state, uint32_t index)
{
  assert(index < state->snapshotCount); return state->snapshots[index];
}

static void Dispatch(uint32_t callbackID, uint32_t implementation)
{
  CDMAState *state = CDMA_Current;
  uint32_t index = CDMA_RecordCallback(state, callbackID, implementation);
  uint32_t action = state->callbackActions[callbackID];
  uint32_t *args = state->callbackArguments[callbackID];
  if (action >= 1 && action <= 4) {
    CDMAOperation operation = action == 1 ? CDMA_Start : action == 2 ? CDMA_StartInterrupt : action == 3 ? CDMA_AbortInterrupt : CDMA_Resume;
    uint32_t result = CDMA_Call(state, operation, args[0], args[1], args[2]);
    CDMA_SetCallbackActionStatus(state, index, result);
  } else if (action == 5) {
    state->handle.ErrorCode = args[0];
  }
}
#define DEFINE_CALLBACK(id, implementation) \
  static void Callback##id##implementation(DMA_HandleTypeDef *handle) { (void)handle; Dispatch(id, implementation); }
DEFINE_CALLBACK(0, 1) DEFINE_CALLBACK(0, 2) DEFINE_CALLBACK(0, 3)
DEFINE_CALLBACK(1, 1) DEFINE_CALLBACK(1, 2) DEFINE_CALLBACK(1, 3)
DEFINE_CALLBACK(2, 1) DEFINE_CALLBACK(2, 2) DEFINE_CALLBACK(2, 3)
DEFINE_CALLBACK(3, 1) DEFINE_CALLBACK(3, 2) DEFINE_CALLBACK(3, 3)
DEFINE_CALLBACK(4, 1) DEFINE_CALLBACK(4, 2) DEFINE_CALLBACK(4, 3)
#undef DEFINE_CALLBACK

static CDMACallbackFunction Select(uint32_t callbackID, uint32_t implementation)
{
  if (!implementation) return NULL;
  assert(implementation <= 3);
#define SELECT_CALLBACK(id) case id: return implementation == 1 ? Callback##id##1 : implementation == 2 ? Callback##id##2 : Callback##id##3;
  switch (callbackID) {
    SELECT_CALLBACK(0) SELECT_CALLBACK(1) SELECT_CALLBACK(2) SELECT_CALLBACK(3) SELECT_CALLBACK(4)
    default: return implementation == 1 ? Callback01 : implementation == 2 ? Callback02 : Callback03;
  }
#undef SELECT_CALLBACK
}
static CDMACallbackFunction *Slot(CDMAState *state, uint32_t callbackID)
{
  switch (callbackID) {
  case 0: return &state->handle.XferCpltCallback;
  case 1: return &state->handle.XferHalfCpltCallback;
  case 2: return &state->handle.XferErrorCallback;
  case 3: return &state->handle.XferAbortCallback;
  case 4: return &state->handle.XferSuspendCallback;
  default: assert(0 && "Unknown DMA callback slot"); return NULL;
  }
}
void CDMA_SetCallback(CDMAState *state, uint32_t callbackID, uint32_t implementation)
{
  *Slot(state, callbackID) = Select(callbackID, implementation);
}
uint32_t CDMA_GetCallback(const CDMAState *state, uint32_t callbackID)
{
  CDMACallbackFunction callback = *Slot((CDMAState *)state, callbackID);
  for (uint32_t implementation = 0; implementation <= 3; implementation++) {
    if (callback == Select(callbackID, implementation)) return implementation;
  }
  assert(0 && "Unknown DMA callback implementation"); return 0;
}
void CDMA_SetCallbackAction(CDMAState *state, uint32_t callbackID, uint32_t action,
                            uint32_t argument0, uint32_t argument1, uint32_t argument2)
{
  assert(callbackID < 5 && action <= 5);
  state->callbackActions[callbackID] = action;
  state->callbackArguments[callbackID][0] = argument0;
  state->callbackArguments[callbackID][1] = argument1;
  state->callbackArguments[callbackID][2] = argument2;
}
uint32_t CDMA_GetCallbackAction(const CDMAState *state, uint32_t callbackID)
{
  assert(callbackID < 5); return state->callbackActions[callbackID];
}
uint32_t CDMA_GetCallbackArgument(const CDMAState *state, uint32_t callbackID, uint32_t argument)
{
  assert(callbackID < 5 && argument < 3); return state->callbackArguments[callbackID][argument];
}
uint32_t CDMA_RecordCallback(CDMAState *state, uint32_t callbackID, uint32_t implementation)
{
  assert(state->callbackCount < 64);
  uint32_t index = state->callbackCount++;
  CDMACallbackEvent *event = &state->callbacks[index];
  memset(event, 0, sizeof(*event));
  event->callbackID = callbackID; event->implementation = implementation; event->actionStatus = UINT32_MAX;
  event->parent = CDMA_GetParent(state); event->snapshot = Snapshot(state);
  for (uint32_t slot = 0; slot < 5; slot++) event->slots[slot] = CDMA_GetCallback(state, slot);
  return index;
}
void CDMA_SetCallbackActionStatus(CDMAState *state, uint32_t index, uint32_t status)
{
  assert(index < state->callbackCount); state->callbacks[index].actionStatus = status;
}
CDMACallbackEvent CDMA_GetCallbackEvent(const CDMAState *state, uint32_t index)
{
  assert(index < state->callbackCount); return state->callbacks[index];
}

uint32_t CDMA_Call(CDMAState *state, CDMAOperation operation, uint32_t argument0, uint32_t argument1, uint32_t argument2)
{
  Bind(state);
  DMA_HandleTypeDef *handle = (state->nullMask & 1) ? NULL : &state->handle;
  uint32_t *output = (state->nullMask & 4) ? NULL : &state->output;
  switch (operation) {
  case CDMA_Initialize: return HAL_DMA_Init(handle);
  case CDMA_Deinitialize: return HAL_DMA_DeInit(handle);
  case CDMA_Start: return HAL_DMA_Start(handle, argument0, argument1, argument2);
  case CDMA_StartInterrupt: return HAL_DMA_Start_IT(handle, argument0, argument1, argument2);
  case CDMA_Abort: return HAL_DMA_Abort(handle);
  case CDMA_AbortInterrupt: return HAL_DMA_Abort_IT(handle);
  case CDMA_Poll: return HAL_DMA_PollForTransfer(handle, (HAL_DMA_LevelCompleteTypeDef)argument0, argument1);
  case CDMA_Interrupt: HAL_DMA_IRQHandler(handle); return HAL_OK;
  case CDMA_GetState: return HAL_DMA_GetState(handle);
  case CDMA_GetError: return HAL_DMA_GetError(handle);
  case CDMA_ConfigureAttributes: return HAL_DMA_ConfigChannelAttributes(handle, argument0);
  case CDMA_GetAttributes: return HAL_DMA_GetConfigChannelAttributes(handle, output);
  case CDMA_LockAttributes: return HAL_DMA_LockChannelAttributes(handle);
  case CDMA_GetAttributeLock: return HAL_DMA_GetLockChannelAttributes(handle, output);
  case CDMA_RegisterCallback: return HAL_DMA_RegisterCallback(handle, (HAL_DMA_CallbackIDTypeDef)argument0, Select(argument0, argument1));
  case CDMA_UnregisterCallback: return HAL_DMA_UnRegisterCallback(handle, (HAL_DMA_CallbackIDTypeDef)argument0);
  case CDMA_ConfigureDataHandling: return HAL_DMAEx_ConfigDataHandling(handle, (state->nullMask & 2) ? NULL : &state->dataHandling);
  case CDMA_ConfigureTrigger: return HAL_DMAEx_ConfigTrigger(handle, (state->nullMask & 2) ? NULL : &state->trigger);
  case CDMA_ConfigureRepeatBlock: return HAL_DMAEx_ConfigRepeatBlock(handle, (state->nullMask & 2) ? NULL : &state->repeatBlock);
  case CDMA_Suspend: return HAL_DMAEx_Suspend(handle);
  case CDMA_SuspendInterrupt: return HAL_DMAEx_Suspend_IT(handle);
  case CDMA_Resume: return HAL_DMAEx_Resume(handle);
  case CDMA_GetFifoLevel: return HAL_DMAEx_GetFifoLevel(handle);
  case CDMA_InitializeLinkedList: return HAL_DMAEx_List_Init(handle);
  case CDMA_DeinitializeLinkedList: return HAL_DMAEx_List_DeInit(handle);
  case CDMA_BuildNode: return HAL_DMAEx_List_BuildNode((state->nullMask & 2) ? NULL : &state->nodeConfiguration, (state->nullMask & 4) ? NULL : &state->node);
  case CDMA_GetNodeConfiguration: return HAL_DMAEx_List_GetNodeConfig((state->nullMask & 2) ? NULL : &state->nodeConfiguration, (state->nullMask & 4) ? NULL : &state->node);
  default: assert(0 && "Unsupported DMA host operation"); return HAL_ERROR;
  }
}
#endif
