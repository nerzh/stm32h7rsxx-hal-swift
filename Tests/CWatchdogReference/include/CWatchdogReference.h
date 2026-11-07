/* Host-only stimuli and observations for unchanged IWDG/WWDG HAL bodies. */
#ifndef C_WATCHDOG_REFERENCE_H
#define C_WATCHDOG_REFERENCE_H
#include "WatchdogReferenceTypes.h"

typedef enum { CWatchdog_IWDG, CWatchdog_WWDG } CWatchdogDevice;
typedef enum {
  CWatchdog_IWDG_KR, CWatchdog_IWDG_PR, CWatchdog_IWDG_RLR,
  CWatchdog_IWDG_SR, CWatchdog_IWDG_WINR, CWatchdog_IWDG_EWCR,
  CWatchdog_WWDG_CR, CWatchdog_WWDG_CFR, CWatchdog_WWDG_SR,
  CWatchdog_RegisterCount
} CWatchdogRegister;
typedef struct { CWatchdogRegister reg; uint32_t value, tickCall; } CWatchdogWrite;
typedef struct {
  CWatchdogRegister reg;
  uint32_t dueCall, clearMask, setMask, active;
} CWatchdogEvent;
typedef struct {
  CWatchdogDevice device;
  uint32_t callbackID, implementation, tickCall, writeCount, actionStatus;
  uint32_t configuration[4], callbackSlots[2], registers[CWatchdog_RegisterCount];
} CWatchdogCallbackEvent;
typedef struct {
  IWDG_TypeDef iwdg;
  WWDG_TypeDef wwdg;
  CWatchdogIWDG0Handle iwdg0;
  CWatchdogIWDG1Handle iwdg1;
  CWatchdogWWDG0Handle wwdg0;
  CWatchdogWWDG1Handle wwdg1;
  uint32_t registeredCallbacks, lsi, lsiStartupTime;
  uint32_t tick, tickStep, tickCalls;
  CWatchdogEvent events[32];
  uint32_t writeCount;
  CWatchdogWrite writes[256];
  uint32_t callbackCount;
  CWatchdogCallbackEvent callbacks[64];
  /* Indexed by device * 2 + callbackID. Action 1 refreshes the same device;
   * action 2 replaces its four configuration words after the callback snapshot. */
  uint32_t callbackActions[4], callbackMutations[4][4];
} CWatchdogState;

/* Exact CMSIS register and HAL handle declarations, with both callback modes.
 * Reset initializes raw registers to zero except IWDG RLR/WINR=0xFFF,
 * WWDG CR/CFR=0x7F, LSI=32000, startup=130 us, tickStep=1 and nil callbacks.
 * IWDG Init defaults: prescaler=0, reload/window=0xFFF, EWI=0.
 * WWDG Init defaults: prescaler=0, window/counter=0x7F, EWI=0.
 * Set/Get are raw storage operations, with no register-width substitutions.
 * Write records only macro-mediated writes. The original C directly accesses
 * IWDG PR/RLR/SR/WINR/EWCR and WWDG IRQ CFR/SR, so those accesses deliberately
 * use raw memory on both sides: no hidden ready-bit, W1C, W0C or WDGA behavior.
 * Final registers and callback snapshots compare those direct accesses; full
 * access order and peripheral write side effects are covered by Swift trace
 * tests and the board. Tick events provide delayed update-flag transitions.
 */
void CWatchdog_Reset(CWatchdogState *state, uint32_t registeredCallbacks);
void CWatchdog_Set(CWatchdogState *state, CWatchdogRegister reg, uint32_t value);
uint32_t CWatchdog_Get(const CWatchdogState *state, CWatchdogRegister reg);
void CWatchdog_Write(CWatchdogState *state, CWatchdogRegister reg, uint32_t value);
uint32_t CWatchdog_Tick(CWatchdogState *state);
uint32_t CWatchdog_GetUpdateTimeout(const CWatchdogState *state);
void CWatchdog_ScheduleTick(CWatchdogState *state, uint32_t afterCalls, CWatchdogRegister reg,
                            uint32_t clearMask, uint32_t setMask);
CWatchdogWrite CWatchdog_GetWrite(const CWatchdogState *state, uint32_t index);
uint32_t CWatchdog_GetConfiguration(const CWatchdogState *state, CWatchdogDevice device, uint32_t word);
void CWatchdog_SetConfiguration(CWatchdogState *state, CWatchdogDevice device, uint32_t word, uint32_t value);

/* Callback IDs: early wakeup=0, MSP initialize=1. Implementations: nil=0,
 * upstream weak override=1, two distinct user callbacks=2/3. These slot helpers
 * bypass registration logic and also work for the inactive callback-1 handle. */
uint32_t CWatchdog_GetCallback(const CWatchdogState *state, CWatchdogDevice device, uint32_t callbackID);
void CWatchdog_SetCallback(CWatchdogState *state, CWatchdogDevice device, uint32_t callbackID, uint32_t implementation);
void CWatchdog_SetCallbackAction(CWatchdogState *state, CWatchdogDevice device, uint32_t callbackID, uint32_t action);
uint32_t CWatchdog_GetCallbackAction(const CWatchdogState *state, CWatchdogDevice device, uint32_t callbackID);
void CWatchdog_SetCallbackMutation(CWatchdogState *state, CWatchdogDevice device, uint32_t callbackID, const uint32_t values[4]);
void CWatchdog_ApplyCallbackMutation(CWatchdogState *state, CWatchdogDevice device, uint32_t callbackID);
/* Record only: these helpers never invoke a C HAL operation for the Swift side. */
uint32_t CWatchdog_RecordCallback(CWatchdogState *state, CWatchdogDevice device, uint32_t callbackID, uint32_t implementation);
void CWatchdog_SetCallbackActionStatus(CWatchdogState *state, uint32_t index, uint32_t status);
CWatchdogCallbackEvent CWatchdog_GetCallbackEvent(const CWatchdogState *state, uint32_t index);

uint32_t CWatchdog_Initialize(CWatchdogState *state, CWatchdogDevice device, uint32_t nullHandle);
uint32_t CWatchdog_Refresh(CWatchdogState *state, CWatchdogDevice device);
uint32_t CWatchdog_GetActiveStatus(CWatchdogState *state);
void CWatchdog_HandleInterrupt(CWatchdogState *state, CWatchdogDevice device);
uint32_t CWatchdog_RegisterCallback(CWatchdogState *state, CWatchdogDevice device, uint32_t callbackID, uint32_t implementation);
uint32_t CWatchdog_UnregisterCallback(CWatchdogState *state, CWatchdogDevice device, uint32_t callbackID);
#endif
