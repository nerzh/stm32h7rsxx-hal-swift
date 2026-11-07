/* Host stimuli and observations for unchanged H7R7/H7S7 ICACHE HAL bodies. */
#ifndef C_ICACHE_REFERENCE_H
#define C_ICACHE_REFERENCE_H
#include "ICacheReferenceTypes.h"

typedef enum {
  CICache_CR, CICache_SR, CICache_IER, CICache_FCR, CICache_HMONR, CICache_MMONR,
  CICache_RegisterCount
} CICacheRegister;
typedef enum {
  CICache_ConfigureAssociativity, CICache_Deinitialize, CICache_Enable,
  CICache_Disable, CICache_IsEnabled, CICache_Invalidate,
  CICache_InvalidateInterrupt, CICache_WaitForInvalidateComplete,
  CICache_StartMonitor, CICache_StopMonitor, CICache_ResetMonitor,
  CICache_GetHitValue, CICache_GetMissValue, CICache_HandleInterrupt,
  CICache_EnableInterrupts, CICache_DisableInterrupts,
  CICache_GetInterruptSource, CICache_GetFlag, CICache_ClearFlag
} CICacheOperation;
typedef enum { CICache_ReadAccess, CICache_WriteAccess, CICache_TickAccess, CICache_CallbackAccess } CICacheAccessKind;
typedef struct {
  CICacheAccessKind kind;
  CICacheRegister reg;
  uint32_t value, tickCall;
} CICacheAccess;
typedef struct {
  uint32_t kind, dueCall, active;
  CICacheRegister reg;
  uint32_t clearMask, setMask;
} CICacheEvent;
typedef struct { uint32_t action, argument0, argument1; } CICacheCallbackAction;
typedef struct {
  uint32_t callbackID, tickCall, accessCount, actionStatus;
  uint32_t registers[CICache_RegisterCount];
} CICacheCallbackEvent;
typedef struct {
  ICACHE_TypeDef registers;
  uint32_t tick, tickStep, tickCalls, readCounts[CICache_RegisterCount];
  CICacheEvent events[32];
  uint32_t accessCount;
  CICacheAccess accesses[256];
  uint32_t callbackCount;
  CICacheCallbackEvent callbacks[32];
  CICacheCallbackAction callbackActions[2];
} CICacheState;

/* Reset uses CR=4, other registers=0 and tickStep=1. This model intentionally
 * uses raw register memory: no synthetic invalidate engine, FCR W1C, monitor
 * counter reset or CR self-clear. Read/tick events provide explicit stimuli.
 * Every original macro-mediated read/write, tick and callback is traced.
 * HMONR/MMONR getters read their original direct volatile fields; Swift uses
 * Get for these two getters so their uninstrumented C reads are not invented.
 * Separate Swift trace tests cover those reads and peripheral side effects.
 * This host oracle must not access ICACHE on the connected H7S3 board.
 */
void CICache_Reset(CICacheState *state);
void CICache_Set(CICacheState *state, CICacheRegister reg, uint32_t value);
uint32_t CICache_Get(const CICacheState *state, CICacheRegister reg);
uint32_t CICache_Read(CICacheState *state, CICacheRegister reg);
void CICache_Write(CICacheState *state, CICacheRegister reg, uint32_t value);
uint32_t CICache_GetReadCount(const CICacheState *state, CICacheRegister reg);
uint32_t CICache_Tick(CICacheState *state);
/* Changes occur before the due read returns, or after the due tick obtains its
 * return value. afterCalls=0 applies immediately; otherwise counts are relative
 * to the register's current read count / current global tick call count. */
void CICache_ScheduleRead(CICacheState *state, uint32_t afterCalls, CICacheRegister reg,
                          uint32_t clearMask, uint32_t setMask);
void CICache_ScheduleTick(CICacheState *state, uint32_t afterCalls, CICacheRegister reg,
                          uint32_t clearMask, uint32_t setMask);
CICacheAccess CICache_GetAccess(const CICacheState *state, uint32_t index);

/* Callback IDs: error=0, invalidate complete=1. Actions: 0 none; 1 calls
 * Invalidate_IT; 2 writes SR=argument0 then IER=argument1; 3 clears argument0
 * flags; 4 enables argument0 interrupts; 5 disables argument0 interrupts;
 * 6 calls DeInit. RecordCallback only observes: it never calls a C HAL function,
 * allowing the Swift test side to execute its own callback action. */
void CICache_SetCallbackAction(CICacheState *state, uint32_t callbackID, uint32_t action,
                               uint32_t argument0, uint32_t argument1);
CICacheCallbackAction CICache_GetCallbackAction(const CICacheState *state, uint32_t callbackID);
uint32_t CICache_RecordCallback(CICacheState *state, uint32_t callbackID);
void CICache_SetCallbackActionStatus(CICacheState *state, uint32_t index, uint32_t status);
CICacheCallbackEvent CICache_GetCallbackEvent(const CICacheState *state, uint32_t index);
uint32_t CICache_GetCallbackRegister(const CICacheState *state, uint32_t index, CICacheRegister reg);
uint32_t CICache_Call(CICacheState *state, CICacheOperation operation, uint32_t argument);
#endif
