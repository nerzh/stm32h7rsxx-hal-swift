#ifndef C_RNG_REFERENCE_H
#define C_RNG_REFERENCE_H
#include "RNGReferenceTypes.h"

typedef enum {
  CRNGReference_CR, CRNGReference_SR, CRNGReference_DR, CRNGReference_HTCR,
  CRNGReference_RegisterCount
} CRNGReferenceRegister;

typedef enum {
  CRNGReference_ClockErrorDetection, CRNGReference_Lock, CRNGReference_State,
  CRNGReference_ErrorCode, CRNGReference_RandomNumber
} CRNGReferenceHandleWord;

typedef enum {
  CRNGReference_ErrorCallback, CRNGReference_MspInitCallback,
  CRNGReference_MspDeInitCallback, CRNGReference_ReadyCallback
} CRNGReferenceCallbackID;

typedef enum {
  CRNGReference_OnTick, CRNGReference_OnCRRead, CRNGReference_OnSRRead,
  CRNGReference_OnDRRead, CRNGReference_OnHTCRRead
} CRNGReferenceTrigger;

typedef enum {
  CRNGReference_AutoConditioning = 1,
  CRNGReference_AutoClearSeedStatus = 2,
  CRNGReference_AutoDataReady = 4,
  CRNGReference_AutoAll = 7
} CRNGReferenceAutomaticTransition;

typedef struct {
  CRNGReferenceRegister reg;
  uint32_t value, tickCall;
} CRNGReferenceWrite;

typedef struct {
  CRNGReferenceTrigger trigger;
  CRNGReferenceRegister reg;
  uint32_t dueCall, clearMask, setMask, active;
} CRNGReferenceEvent;

typedef struct {
  uint32_t callbackID, implementation, argument;
  uint32_t lock, state, errorCode, randomNumber;
  uint32_t cr, sr, tickCalls, writeCount, dataReads;
  /* UINT32_MAX means no action. Action 1 invokes the real C Generate_IT. */
  uint32_t actionStatus;
} CRNGReferenceCallback;

typedef struct {
  RNG_TypeDef registers;
  CRNG0Handle handle0;
  CRNG1Handle handle1;
  uint32_t registeredCallbacks;
  uint32_t tick, tickStep, tickCalls;
  uint32_t readCalls[4];
  /* Delays count future macro-mediated reads of CR/SR, respectively. Zero
   * applies immediately. Clearing CONDRST can also clear SECS; enabling RNGEN
   * can set DRDY. Disable individual transitions to model stuck flags.
   * This is an explicit test stimulus model, not a silicon RNG emulator. */
  uint32_t automaticTransitions, conditioningReadDelay, dataReadyReadDelay;
  uint32_t dataCount, dataIndex, data[64];
  uint32_t writeCount;
  CRNGReferenceWrite writes[256];
  CRNGReferenceEvent events[64];
  uint32_t callbackCount, callbackActions[4];
  CRNGReferenceCallback callbacks[64];
} CRNGReferenceState;

/* Reset zeroes registers/handles/observations; tickStep=1 and all immediate
 * automatic transitions are enabled. The callback mode selects an independent
 * compilation of the original C. Each wrapper rebinds register pointers, so
 * moving/copying a state between operations does not retain stale pointers.
 * Set/Get and SetHandle/GetHandle bypass all events and observations.
 * SR writes preserve readonly bits and clear CEIS/SEIS when their written bit
 * is zero. CR/HTCR are raw storage apart from configured CONDRST transitions:
 * CONFIGLOCK write protection and entropy generation are not simulated.
 */
void CRNGReference_Reset(CRNGReferenceState *state, uint32_t registeredCallbacks);
void CRNGReference_Set(CRNGReferenceState *state, CRNGReferenceRegister reg, uint32_t value);
uint32_t CRNGReference_Get(const CRNGReferenceState *state, CRNGReferenceRegister reg);
void CRNGReference_SetHandle(CRNGReferenceState *state, CRNGReferenceHandleWord word, uint32_t value);
uint32_t CRNGReference_GetHandle(const CRNGReferenceState *state, CRNGReferenceHandleWord word);

/* Hardware-only operations usable by Swift differential tests. Direct upstream
 * IRQ SR snapshot/GetConfig reads are uninstrumented. DR uses a layout-preserving
 * array-index hook, so all DR reads consume the script and execute DR events.
 * Read counts therefore must not be compared as a complete MMIO read trace.
 */
uint32_t CRNGReference_Read(CRNGReferenceState *state, CRNGReferenceRegister reg);
void CRNGReference_Write(CRNGReferenceState *state, CRNGReferenceRegister reg, uint32_t value);
uint32_t CRNGReference_Tick(CRNGReferenceState *state);
void CRNGReference_PushData(CRNGReferenceState *state, uint32_t value);
void CRNGReference_Schedule(CRNGReferenceState *state, CRNGReferenceTrigger trigger,
                            uint32_t afterCalls, CRNGReferenceRegister reg,
                            uint32_t clearMask, uint32_t setMask);
CRNGReferenceWrite CRNGReference_GetWrite(const CRNGReferenceState *state, uint32_t index);
CRNGReferenceCallback CRNGReference_GetCallbackEvent(const CRNGReferenceState *state, uint32_t index);
/* Observation-only callback helpers for the independent Swift callback body.
 * RecordCallback never invokes a C algorithm. The Swift callback may perform
 * its own configured action and then record the resulting status. */
uint32_t CRNGReference_RecordCallback(CRNGReferenceState *state, uint32_t callbackID,
                                      uint32_t implementation, uint32_t argument);
void CRNGReference_SetCallbackActionStatus(CRNGReferenceState *state, uint32_t index, uint32_t status);
void CRNGReference_SetCallbackAction(CRNGReferenceState *state, uint32_t callbackID, uint32_t action);
uint32_t CRNGReference_GetCallbackAction(const CRNGReferenceState *state, uint32_t callbackID);
uint32_t CRNGReference_ReadCount(const CRNGReferenceState *state, CRNGReferenceRegister reg);

/* Callback selector: 0=NULL, 1=overridden weak default, 2=custom A, 3=custom B.
 * Direct setters are test setup only; registration wrappers call original HAL.
 * Callback records observe the actual C handle before any configured action.
 */
void CRNGReference_SetCallback(CRNGReferenceState *state, uint32_t callbackID, uint32_t selector);
uint32_t CRNGReference_GetCallback(const CRNGReferenceState *state, uint32_t callbackID);
uint32_t CRNGReference_RegisterCallback(CRNGReferenceState *state, uint32_t callbackID, uint32_t selector);
uint32_t CRNGReference_UnregisterCallback(CRNGReferenceState *state, uint32_t callbackID);
uint32_t CRNGReference_RegisterReadyCallback(CRNGReferenceState *state, uint32_t selector);
uint32_t CRNGReference_UnregisterReadyCallback(CRNGReferenceState *state);

uint32_t CRNGReference_Initialize(CRNGReferenceState *state);
uint32_t CRNGReference_Deinitialize(CRNGReferenceState *state);
uint32_t CRNGReference_Generate(CRNGReferenceState *state, uint32_t *output);
uint32_t CRNGReference_GenerateInterrupt(CRNGReferenceState *state);
void CRNGReference_HandleInterrupt(CRNGReferenceState *state);
uint32_t CRNGReference_ReadLast(CRNGReferenceState *state);
uint32_t CRNGReference_GetState(CRNGReferenceState *state);
uint32_t CRNGReference_GetError(CRNGReferenceState *state);
uint32_t CRNGReference_Recover(CRNGReferenceState *state);
uint32_t CRNGReference_RecoverExtended(CRNGReferenceState *state);
uint32_t CRNGReference_SetConfig(CRNGReferenceState *state, const RNG_ConfigTypeDef *config);
uint32_t CRNGReference_GetConfig(CRNGReferenceState *state, RNG_ConfigTypeDef *config);
uint32_t CRNGReference_LockConfig(CRNGReferenceState *state);
/* Null-handle cases for functions that explicitly check allocation. Operation:
 * 0=Init, 1=DeInit, 2=SetConfig, 3=GetConfig, 4=LockConfig, 5=ExRecover. */
uint32_t CRNGReference_NullHandle(uint32_t registeredCallbacks, uint32_t operation);
#endif
