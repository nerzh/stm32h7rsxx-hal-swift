/* Test-only storage and stimuli for the unchanged ST UART/UARTEx functions.
 * DMA calls are scripted boundaries; the DMA implementation has its own oracle.
 */
#include "UARTInternal.h"
#include <assert.h>
#include <string.h>

_Thread_local CUARTState *CUART_Active;

#define FIELD(s,u,f) ((s)->registeredCallbacks ? (s)->uart[u].handle1.f : (s)->uart[u].handle0.f)
#define SET_FIELD(s,u,f,v) do { if ((s)->registeredCallbacks) (s)->uart[u].handle1.f = (v); \
                              else (s)->uart[u].handle0.f = (v); } while (0)

static void *handleAddress(const CUARTState *s, uint32_t u) {
  assert(u < 2);
  return s->registeredCallbacks ? (void *)&s->uart[u].handle1 : (void *)&s->uart[u].handle0;
}
static volatile uint32_t *registerAddress(const CUARTState *s, uint32_t u, CUARTRegister r) {
  assert(u < 2 && (uint32_t)r < 12);
  return (volatile uint32_t *)((uintptr_t)&s->uart[u].registers + (uint32_t)r * 4U);
}
static uint32_t dmaIndex(const CUARTState *s, const DMA_HandleTypeDef *h) {
  if (!h) return UINT32_MAX;
  for (uint32_t i = 0; i < 4; ++i) if (h == &s->dma[i].handle) return i;
  assert(!"Unknown DMA handle"); return UINT32_MAX;
}
static uint32_t uartIndex(const CUARTState *s, const void *h) {
  if (!h) return UINT32_MAX;
  for (uint32_t i = 0; i < 2; ++i)
    if (h == &s->uart[i].handle0 || h == &s->uart[i].handle1) return i;
  assert(!"Unknown UART handle"); return UINT32_MAX;
}

void CUART_Reset(CUARTState *s, uint32_t registered) {
  memset(s, 0, sizeof(*s));
  s->registeredCallbacks = registered != 0;
  s->tickStep = 1;
  for (uint32_t i = 0; i < 5; ++i) s->clockFrequencies[i] = 48000000;
  s->clockFrequencies[5] = 64000000;
  s->clockFrequencies[6] = 4000000;
  s->clockFrequencies[7] = 32768;
  for (uint32_t u = 0; u < 2; ++u) {
    CUART_SetInstance(s, u, u == 0 ? 0x40004800 : 0x40004400);
    CUART_SetWord(s, u, 0, 115200);
    CUART_SetWord(s, u, 4, 12);
    CUART_SetWord(s, u, 30, 0x20);
    CUART_SetWord(s, u, 31, 0x20);
  }
  for (uint32_t i = 0; i < 4; ++i) {
    s->dma[i].handle.Instance = &s->dma[i].registers;
    s->dma[i].handle.State = HAL_DMA_STATE_READY;
    s->dma[i].queue.Head = &s->dma[i].node;
    s->dma[i].queue.NodeNumber = 1;
    s->dma[i].queue.State = HAL_DMA_QUEUE_STATE_READY;
  }
}
void CUART_SetInstance(CUARTState *s, uint32_t u, uint32_t address) {
  assert(u < 2);
  s->uart[u].instance = address;
  s->uart[u].handle0.Instance = &s->uart[u].registers;
  s->uart[u].handle1.Instance = &s->uart[u].registers;
}
USART_TypeDef *CUART_InstanceAddress(uint32_t address) {
  assert(CUART_Active);
  for (uint32_t u = 0; u < 2; ++u)
    if (CUART_Active->uart[u].instance == address) return &CUART_Active->uart[u].registers;
  return (USART_TypeDef *)(uintptr_t)address;
}
uint32_t CUART_FindUART(const void *h) { return uartIndex(CUART_Active, h); }
uint32_t CUART_FindDMA(const DMA_HandleTypeDef *h) { return dmaIndex(CUART_Active, h); }

uint32_t CUART_GetRegister(const CUARTState *s, uint32_t u, CUARTRegister r) {
  return *registerAddress(s, u, r);
}
void CUART_SetRegister(CUARTState *s, uint32_t u, CUARTRegister r, uint32_t value) {
  *registerAddress(s, u, r) = value;
}
static void recordAccess(CUARTState *s, uint32_t u, CUARTRegister r, uint32_t value, uint32_t kind) {
  assert(s->accessCount < 2048);
  s->accesses[s->accessCount++] = (CUARTAccess){u, (uint32_t)r, value, kind, s->tickCalls};
}
static void fireScheduled(CUARTState *s, uint32_t trigger, uint32_t u, uint32_t r, uint32_t count) {
  for (uint32_t i = 0; i < 64; ++i) {
    CUARTScheduledAction *e = &s->events[i];
    if (e->active && e->trigger == trigger && e->due == count &&
        (trigger != 1 || (e->uart == u && e->reg == r))) {
      CUARTAction action = e->action;
      e->active = 0;
      CUART_ApplyAction(s, action);
    }
  }
}
uint32_t CUART_Read(CUARTState *s, uint32_t u, CUARTRegister r) {
  assert(u < 2 && (uint32_t)r < 12);
  uint32_t count = ++s->readCounts[u][r];
  fireScheduled(s, 1, u, (uint32_t)r, count);
  for (uint32_t i = 0; i < 512; ++i) {
    CUARTScriptedRead *v = &s->reads[i];
    if (v->active && v->uart == u && v->reg == (uint32_t)r) {
      v->active = 0;
      CUART_SetRegister(s, u, r, v->value);
      break;
    }
  }
  uint32_t value = CUART_GetRegister(s, u, r);
  recordAccess(s, u, r, value, 0);
  return value;
}
void CUART_Write(CUARTState *s, uint32_t u, CUARTRegister r, uint32_t value) {
  CUART_SetRegister(s, u, r, value);
  recordAccess(s, u, r, value, 1);
}
static int locateRegister(volatile uint32_t *address, uint32_t *u, CUARTRegister *r) {
  assert(CUART_Active);
  for (uint32_t i = 0; i < 2; ++i) {
    uintptr_t offset = (uintptr_t)address - (uintptr_t)&CUART_Active->uart[i].registers;
    if (offset < sizeof(USART_TypeDef) && (offset & 3U) == 0) {
      *u = i; *r = (CUARTRegister)(offset / 4); return 1;
    }
  }
  return 0;
}
uint32_t CUART_ReadAddress(volatile uint32_t *address) {
  uint32_t u = 0; CUARTRegister r = CUART_CR1;
  /* ST also applies register macros to local temporary words. */
  if (!locateRegister(address, &u, &r)) return *address;
  return CUART_Read(CUART_Active, u, r);
}
void CUART_WriteAddress(volatile uint32_t *address, uint32_t value) {
  uint32_t u = 0; CUARTRegister r = CUART_CR1;
  if (!locateRegister(address, &u, &r)) { *address = value; return; }
  CUART_Write(CUART_Active, u, r, value);
}
uint32_t CUART_ExclusiveLoad(volatile uint32_t *address) {
  uint32_t u = 0; CUARTRegister r = CUART_CR1;
  int found = locateRegister(address, &u, &r);
  assert(found); (void)found;
  ++CUART_Active->atomicCalls;
  uint32_t value = *address;
  recordAccess(CUART_Active, u, r, value, 2);
  return value;
}
uint32_t CUART_ExclusiveStore(uint32_t value, volatile uint32_t *address) {
  uint32_t u = 0; CUARTRegister r = CUART_CR1;
  int found = locateRegister(address, &u, &r);
  assert(found); (void)found;
  CUARTState *s = CUART_Active;
  fireScheduled(s, 2, u, (uint32_t)r, s->atomicCalls);
  if (s->exclusiveFailures) {
    --s->exclusiveFailures;
    recordAccess(s, u, r, value, 4);
    return 1;
  }
  *address = value;
  recordAccess(s, u, r, value, 3);
  return 0;
}
void CUART_AtomicModify(CUARTState *s, uint32_t u, CUARTRegister r, uint32_t clear, uint32_t set) {
  CUARTState *previous = CUART_Active;
  CUART_Active = s;
  volatile uint32_t *address = registerAddress(s, u, r);
  uint32_t value;
  do { value = CUART_ExclusiveLoad(address); value = (value & ~clear) | set; }
  while (CUART_ExclusiveStore(value, address) != 0);
  CUART_Active = previous;
}
uint32_t CUART_Tick(CUARTState *s) {
  uint32_t tick = s->tick;
  s->tick += s->tickStep;
  ++s->tickCalls;
  fireScheduled(s, 0, 0, 0, s->tickCalls);
  return tick;
}
CUARTAccess CUART_GetAccess(const CUARTState *s, uint32_t i) {
  assert(i < s->accessCount); return s->accesses[i];
}

uint32_t CUART_GetWord(const CUARTState *s, uint32_t u, uint32_t word) {
  assert(u < 2 && word < 35);
  return s->registeredCallbacks ? CUART1_GetWordInternal(&s->uart[u].handle1, word)
                               : CUART0_GetWordInternal(&s->uart[u].handle0, word);
}
void CUART_SetWord(CUARTState *s, uint32_t u, uint32_t word, uint32_t value) {
  assert(u < 2 && word < 35);
  if (s->registeredCallbacks) CUART1_SetWordInternal(&s->uart[u].handle1, word, value);
  else CUART0_SetWordInternal(&s->uart[u].handle0, word, value);
}
uint32_t CUART_BufferAddress(uint32_t u, uint32_t direction) {
  assert(u < 2 && direction < 2); return 0x24010000U + u * 0x2000U + direction * 0x1000U;
}
void *CUART_Buffer(CUARTState *s, uint32_t u, uint32_t direction) {
  assert(u < 2 && direction < 2);
  return direction == 0 ? s->uart[u].txBuffer : s->uart[u].rxBuffer;
}
uint32_t CUART_NormalizeAddress(const CUARTState *s, uintptr_t address) {
  if (address == 0) return 0;
  for (uint32_t u = 0; u < 2; ++u) {
    for (uint32_t d = 0; d < 2; ++d) {
      uintptr_t base = (uintptr_t)CUART_Buffer((CUARTState *)s, u, d);
      uintptr_t offset = address <= UINT32_MAX ? (uint32_t)address - (uint32_t)base : address - base;
      if (offset < sizeof(s->uart[u].txBuffer)) return CUART_BufferAddress(u, d) + (uint32_t)offset;
    }
    uintptr_t base = (uintptr_t)&s->uart[u].registers;
    uintptr_t offset = address <= UINT32_MAX ? (uint32_t)address - (uint32_t)base : address - base;
    if (offset < sizeof(USART_TypeDef)) return s->uart[u].instance + (uint32_t)offset;
  }
  return (uint32_t)address;
}
static void *nativeBufferAddress(CUARTState *s, uint32_t logical) {
  if (logical == 0) return NULL;
  for (uint32_t u = 0; u < 2; ++u) for (uint32_t d = 0; d < 2; ++d) {
    uint32_t offset = logical - CUART_BufferAddress(u, d);
    if (offset <= sizeof(s->uart[u].txBuffer)) return (uint8_t *)CUART_Buffer(s, u, d) + offset;
  }
  return (void *)(uintptr_t)logical;
}
uint32_t CUART_GetPointer(const CUARTState *s, uint32_t u, uint32_t direction) {
  assert(u < 2 && direction < 2);
  uintptr_t value = direction == 0 ? (uintptr_t)FIELD(s,u,pTxBuffPtr) : (uintptr_t)FIELD(s,u,pRxBuffPtr);
  uintptr_t offset = value - (uintptr_t)CUART_Buffer((CUARTState *)s,u,direction);
  /* TX's one-past pointer equals RX's start in the native fixture layout. */
  if (offset <= sizeof(s->uart[u].txBuffer)) return CUART_BufferAddress(u,direction) + (uint32_t)offset;
  return CUART_NormalizeAddress(s, value);
}
void CUART_SetPointer(CUARTState *s, uint32_t u, uint32_t direction, uint32_t logical) {
  assert(u < 2 && direction < 2);
  void *p = nativeBufferAddress(s, logical);
  if (direction == 0) SET_FIELD(s,u,pTxBuffPtr,p); else SET_FIELD(s,u,pRxBuffPtr,p);
}
void CUART_SetBufferByte(CUARTState *s, uint32_t u, uint32_t d, uint32_t offset, uint8_t value) {
  assert(offset < sizeof(s->uart[u].txBuffer)); ((uint8_t *)CUART_Buffer(s,u,d))[offset] = value;
}
uint8_t CUART_GetBufferByte(const CUARTState *s, uint32_t u, uint32_t d, uint32_t offset) {
  assert(offset < sizeof(s->uart[u].txBuffer)); return ((uint8_t *)CUART_Buffer((CUARTState *)s,u,d))[offset];
}
uint16_t *CUART_ReceivedCount(CUARTState *s, uint32_t u) { assert(u < 2); return &s->uart[u].receivedCount; }

uint32_t CUART_GetCallback(const CUARTState *s, uint32_t u, uint32_t id) {
  assert(u < 2 && id < 14);
  return s->registeredCallbacks ? CUART1_GetCallbackInternal(&s->uart[u].handle1, id)
                               : CUART0_GetCallbackInternal(&s->uart[u].handle0, id);
}
void CUART_SetCallback(CUARTState *s, uint32_t u, uint32_t id, uint32_t implementation) {
  assert(u < 2 && id < 14);
  if (s->registeredCallbacks) CUART1_SetCallbackInternal(&s->uart[u].handle1, id, implementation);
  else CUART0_SetCallbackInternal(&s->uart[u].handle0, id, implementation);
}
void CUART_SetCallbackAction(CUARTState *s, uint32_t u, uint32_t id, uint32_t slot, CUARTAction action) {
  assert(u < 2 && id < 14 && slot < 4); s->callbackActions[u][id][slot] = action;
}
CUARTAction CUART_GetCallbackAction(const CUARTState *s, uint32_t u, uint32_t id, uint32_t slot) {
  assert(u < 2 && id < 14 && slot < 4); return s->callbackActions[u][id][slot];
}
void CUART_EmitCallback(CUARTState *s, uint32_t u, uint32_t id, uint32_t implementation, uint32_t position) {
  assert(u < 2 && id < 14 && s->callbackCount < 64);
  CUARTCallbackEvent *e = &s->callbackEvents[s->callbackCount++];
  e->uart = u; e->callbackID = id; e->implementation = implementation; e->position = position;
  e->tickCall = s->tickCalls; e->accessCount = s->accessCount; e->dmaCallCount = s->dmaCallCount;
  e->snapshot = CUART_GetSnapshot(s);
  CUARTAction actions[4];
  memcpy(actions, s->callbackActions[u][id], sizeof(actions));
  memset(s->callbackActions[u][id], 0, sizeof(actions));
  for (uint32_t i = 0; i < 4; ++i) CUART_ApplyAction(s, actions[i]);
}
void CUART_DispatchCallback(const void *handle, uint32_t id, uint32_t implementation, uint32_t position) {
  CUART_EmitCallback(CUART_Active, CUART_FindUART(handle), id, implementation, position);
}
CUARTCallbackEvent CUART_GetCallbackEvent(const CUARTState *s, uint32_t i) {
  assert(i < s->callbackCount); return s->callbackEvents[i];
}

void CUART_LinkDMA(CUARTState *s, uint32_t u, uint32_t d, int32_t channel) {
  assert(u < 2 && d < 2 && channel >= -1 && channel < 4);
  DMA_HandleTypeDef *h = channel < 0 ? NULL : &s->dma[channel].handle;
  if (d == 0) SET_FIELD(s,u,hdmatx,h); else SET_FIELD(s,u,hdmarx,h);
}
int32_t CUART_GetLinkedDMA(const CUARTState *s, uint32_t u, uint32_t d) {
  assert(u < 2 && d < 2);
  return (int32_t)dmaIndex(s, d == 0 ? FIELD(s,u,hdmatx) : FIELD(s,u,hdmarx));
}
uint32_t CUART_GetDMAWord(const CUARTState *s, uint32_t i, CUARTDMAWord word) {
  assert(i < 4); const CUARTDMADevice *d = &s->dma[i];
  switch (word) {
  case CUART_DMAMode: return d->handle.Mode;
  case CUART_DMAState: return d->handle.State;
  case CUART_DMAError: return d->handle.ErrorCode;
  case CUART_DMALock: return d->handle.Lock;
  case CUART_DMACounter: return d->registers.CBR1 & 0xFFFF;
  case CUART_DMAParent: return uartIndex(s, d->handle.Parent);
  case CUART_DMAQueuePresent: return d->handle.LinkedListQueue != NULL;
  case CUART_DMAQueueState: return d->queue.State;
  }
  assert(!"Unknown DMA word"); return 0;
}
void CUART_SetDMAWord(CUARTState *s, uint32_t i, CUARTDMAWord word, uint32_t value) {
  assert(i < 4); CUARTDMADevice *d = &s->dma[i];
  switch (word) {
  case CUART_DMAMode: d->handle.Mode = value; break;
  case CUART_DMAState: d->handle.State = (HAL_DMA_StateTypeDef)value; break;
  case CUART_DMAError: d->handle.ErrorCode = value; break;
  case CUART_DMALock: d->handle.Lock = (HAL_LockTypeDef)value; break;
  case CUART_DMACounter: d->registers.CBR1 = value; break;
  case CUART_DMAParent: d->handle.Parent = value == UINT32_MAX ? NULL : handleAddress(s,value); break;
  case CUART_DMAQueuePresent: d->handle.LinkedListQueue = value ? &d->queue : NULL; break;
  case CUART_DMAQueueState: d->queue.State = (HAL_DMA_QStateTypeDef)value; break;
  }
}
uint32_t CUART_GetDMACallback(const CUARTState *s, uint32_t i, uint32_t id) {
  assert(i < 4 && id < 5);
  return s->registeredCallbacks ? CUART1_GetDMACallbackInternal(&s->dma[i].handle,id)
                               : CUART0_GetDMACallbackInternal(&s->dma[i].handle,id);
}
void CUART_SetDMACallback(CUARTState *s, uint32_t i, uint32_t id, uint32_t event) {
  assert(i < 4 && id < 5);
  if (s->registeredCallbacks) CUART1_SetDMACallbackInternal(&s->dma[i].handle,id,event);
  else CUART0_SetDMACallbackInternal(&s->dma[i].handle,id,event);
}
uint32_t CUART_DMAReadMemory32(const CUARTState *s, uint32_t i, uint32_t address) {
  assert(i < 4 && (address & 3U) == 0);
  const CUARTDMADevice *d = &s->dma[i];
  uint32_t offset = address - (0x24030000U + i * 0x100U);
  switch (offset) {
  case 0: return d->queue.Head ? 0x24030040U + i * 0x100U : 0;
  case 4: return d->queue.FirstCircularNode ? 0x24030040U + i * 0x100U : 0;
  case 8: return d->queue.NodeNumber;
  case 12: return d->queue.State;
  case 16: return d->queue.ErrorCode;
  case 20: return d->queue.Type;
  default:
    assert(offset >= 0x40 && offset < 0x64);
    if (offset == 0x60) return d->node.NodeInfo;
    uint32_t word = (offset - 0x40) / 4;
    uint32_t value = d->node.LinkRegisters[word];
    return word == 3 || word == 4 ? CUART_NormalizeAddress(s,value) : value;
  }
}
void CUART_DMAWriteMemory32(CUARTState *s, uint32_t i, uint32_t address, uint32_t value) {
  assert(i < 4 && (address & 3U) == 0);
  CUARTDMADevice *d = &s->dma[i];
  uint32_t offset = address - (0x24030000U + i * 0x100U);
  switch (offset) {
  case 0: assert(value == 0 || value == 0x24030040U+i*0x100U); d->queue.Head = value ? &d->node : NULL; break;
  case 4: assert(value == 0 || value == 0x24030040U+i*0x100U); d->queue.FirstCircularNode = value ? &d->node : NULL; break;
  case 8: d->queue.NodeNumber = value; break;
  case 12: d->queue.State = (HAL_DMA_QStateTypeDef)value; break;
  case 16: d->queue.ErrorCode = value; break;
  case 20: d->queue.Type = value; break;
  default:
    assert(offset >= 0x40 && offset < 0x64);
    if (offset == 0x60) d->node.NodeInfo = value;
    else d->node.LinkRegisters[(offset - 0x40)/4] = value;
    break;
  }
}
void CUART_SetDMAStatus(CUARTState *s, uint32_t i, CUARTDMAOperation op, uint32_t status) {
  assert(i < 4 && (uint32_t)op < 6 && status < 4); s->dma[i].statuses[op] = status;
}
void CUART_SetDMAAction(CUARTState *s, uint32_t i, CUARTDMAOperation op, CUARTAction action) {
  assert(i < 4 && (uint32_t)op < 6); s->dma[i].actions[op] = action;
}
uint32_t CUART_PerformDMA(CUARTState *s, uint32_t i, CUARTDMAOperation op, uint32_t a, uint32_t b, uint32_t c) {
  assert(i < 4 && (uint32_t)op < 6 && s->dmaCallCount < 128);
  CUARTDMAEvent *e = &s->dmaEvents[s->dmaCallCount++];
  e->channel = i; e->operation = op; e->args[0] = CUART_NormalizeAddress(s,a);
  e->args[1] = CUART_NormalizeAddress(s,b); e->args[2] = c;
  e->tickCall = s->tickCalls; e->accessCount = s->accessCount; e->callbackCount = s->callbackCount;
  e->snapshot = CUART_GetSnapshot(s);
  CUARTAction action = s->dma[i].actions[op];
  memset(&s->dma[i].actions[op],0,sizeof(action));
  CUART_ApplyAction(s, action);
  return s->dma[i].statuses[op];
}
CUARTDMAEvent CUART_GetDMAEvent(const CUARTState *s, uint32_t i) {
  assert(i < s->dmaCallCount); return s->dmaEvents[i];
}
void CUART_InvokeDMAEvent(CUARTState *s, uint32_t original, uint32_t kind) {
  assert(original < 4 && kind < 10);
  if (s->dmaEventHandler) { s->dmaEventHandler(s->executionContext, original, kind); return; }
  CUARTState *previous = CUART_Active; CUART_Active = s;
  if (s->registeredCallbacks) CUART1_InvokeDMAInternal(&s->dma[original].handle,kind);
  else CUART0_InvokeDMAInternal(&s->dma[original].handle,kind);
  CUART_Active = previous;
}
HAL_StatusTypeDef CUART_DMAStart(DMA_HandleTypeDef *h, uint32_t a, uint32_t b, uint32_t c) {
  return (HAL_StatusTypeDef)CUART_PerformDMA(CUART_Active,CUART_FindDMA(h),CUART_DMAStartInterrupt,a,b,c);
}
#define DMA_BOUNDARY(name,op) HAL_StatusTypeDef name(DMA_HandleTypeDef *h) { \
  return (HAL_StatusTypeDef)CUART_PerformDMA(CUART_Active,CUART_FindDMA(h),op,0,0,0); }
DMA_BOUNDARY(CUART_DMAListStart,CUART_DMAStartLinkedListInterrupt)
DMA_BOUNDARY(CUART_DMAAbortCall,CUART_DMAAbort)
DMA_BOUNDARY(CUART_DMAAbortITCall,CUART_DMAAbortInterrupt)
DMA_BOUNDARY(CUART_DMASuspendCall,CUART_DMASuspend)
DMA_BOUNDARY(CUART_DMAResumeCall,CUART_DMAResume)
uint32_t CUART_DMAGetError(DMA_HandleTypeDef *h) { return h->ErrorCode; }

CUARTSnapshot CUART_GetSnapshot(const CUARTState *s) {
  CUARTSnapshot out; memset(&out,0,sizeof(out));
  for (uint32_t u = 0; u < 2; ++u) {
    for (uint32_t w = 0; w < 35; ++w) out.words[u][w] = CUART_GetWord(s,u,w);
    for (uint32_t d = 0; d < 2; ++d) out.pointers[u][d] = CUART_GetPointer(s,u,d);
    for (uint32_t r = 0; r < 12; ++r) out.registers[u][r] = CUART_GetRegister(s,u,(CUARTRegister)r);
    for (uint32_t id = 0; id < 14; ++id) out.callbacks[u][id] = CUART_GetCallback(s,u,id);
  }
  for (uint32_t i = 0; i < 4; ++i) {
    for (uint32_t w = 0; w < 8; ++w) out.dmaWords[i][w] = CUART_GetDMAWord(s,i,(CUARTDMAWord)w);
    for (uint32_t id = 0; id < 5; ++id) out.dmaCallbacks[i][id] = CUART_GetDMACallback(s,i,id);
    for (uint32_t w = 0; w < 9; ++w) out.nodes[i][w] = CUART_DMAReadMemory32(s,i,0x24030040U+i*0x100U+w*4U);
  }
  return out;
}

void CUART_SetExecutionHooks(CUARTState *s, void *context, CUARTActionHandler action, CUARTDMAEventHandler event) {
  s->executionContext = context; s->actionHandler = action; s->dmaEventHandler = event;
}
uint32_t CUART_ApplyAction(CUARTState *s, CUARTAction action) {
  if (action.kind == CUART_ActionNone) return 0;
  if (s->actionHandler) { s->actionHandler(s->executionContext,action); return 0; }
  switch (action.kind) {
  case CUART_ActionNone: return 0;
  case CUART_ActionRegister: CUART_SetRegister(s,action.target,(CUARTRegister)action.index,action.value); break;
  case CUART_ActionWord: CUART_SetWord(s,action.target,action.index,action.value); break;
  case CUART_ActionPointer: CUART_SetPointer(s,action.target,action.index,action.value); break;
  case CUART_ActionCall: return CUART_Call(s,action.target,(CUARTOperation)action.index,
    action.args[0],action.args[1],action.args[2],action.args[3]);
  case CUART_ActionDMAWord: CUART_SetDMAWord(s,action.target,(CUARTDMAWord)action.index,action.value); break;
  case CUART_ActionDMAEvent: CUART_InvokeDMAEvent(s,action.target,action.index); break;
  }
  return 0;
}
static void schedule(CUARTState *s, uint32_t trigger, uint32_t u, uint32_t r, uint32_t due, CUARTAction action) {
  for (uint32_t i = 0; i < 64; ++i) if (!s->events[i].active) {
    s->events[i] = (CUARTScheduledAction){trigger,u,r,due,1,action}; return;
  }
  assert(!"Scheduled action capacity exceeded");
}
void CUART_ScheduleTick(CUARTState *s, uint32_t after, CUARTAction action) {
  assert(after != 0); schedule(s,0,0,0,s->tickCalls+after,action);
}
void CUART_ScheduleRead(CUARTState *s, uint32_t u, CUARTRegister r, uint32_t after, CUARTAction action) {
  assert(u < 2 && (uint32_t)r < 12 && after != 0); schedule(s,1,u,r,s->readCounts[u][r]+after,action);
}
void CUART_ScheduleAtomic(CUARTState *s, uint32_t after, CUARTAction action) {
  assert(after != 0); schedule(s,2,0,0,s->atomicCalls+after,action);
}
void CUART_AppendRead(CUARTState *s, uint32_t u, CUARTRegister r, uint32_t value) {
  assert(u < 2 && (uint32_t)r < 12);
  for (uint32_t i = 0; i < 512; ++i) if (!s->reads[i].active) {
    s->reads[i] = (CUARTScriptedRead){u,(uint32_t)r,value,1}; return;
  }
  assert(!"Scripted read capacity exceeded");
}
uint32_t CUART_GetClockSource(const CUARTState *s, uint32_t u) {
  assert(u < 2);
  uint32_t group = s->uart[u].instance == 0x42001000U ? 0 : s->uart[u].instance == 0x58000C00U ? 2 : 1;
  switch (s->clockSelections[group]) {
  case 0: return group == 0 ? 1 : group == 2 ? 2 : 0;
  case 1: return 4; case 2: return 8; case 3: return 0x10;
  case 4: return 0x20; case 5: return 0x40; default: return 0x80;
  }
}
uint32_t CUART_GetClockFrequency(const CUARTState *s, uint32_t source) {
  switch (source) {
  case 0: case 1: case 2: return s->clockFrequencies[source];
  case 4: return s->clockFrequencies[3]; case 8: return s->clockFrequencies[4];
  case 0x10: return s->clockFrequencies[5] >> (s->hsiDividerReady ? s->hsiDivider >> 3 : 0);
  case 0x20: return s->clockFrequencies[6]; case 0x40: return s->clockFrequencies[7];
  default: return 0;
  }
}
uint32_t CUART_Call(CUARTState *s, uint32_t u, CUARTOperation op, uint32_t a, uint32_t b, uint32_t c, uint32_t d) {
  assert(u < 2);
  CUARTState *previous = CUART_Active; CUART_Active = s;
  uint32_t result = s->registeredCallbacks ? CUART1_CallInternal(&s->uart[u].handle1,op,a,b,c,d)
                                         : CUART0_CallInternal(&s->uart[u].handle0,op,a,b,c,d);
  CUART_Active = previous; return result;
}
uint32_t CUART_CallNull(CUARTState *s, CUARTOperation op) {
  CUARTState *previous = CUART_Active; CUART_Active = s;
  uint32_t result = s->registeredCallbacks ? CUART1_CallInternal(NULL,op,0,0,0,0)
                                         : CUART0_CallInternal(NULL,op,0,0,0,0);
  CUART_Active = previous; return result;
}
