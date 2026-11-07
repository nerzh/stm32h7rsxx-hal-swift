/* ARM-only differential reference. The upstream global IER expression casts
 * Instance to uint32_t and masks its low byte; it is never changed for a host.
 * Compile all three C files for ARM. Host TUs intentionally define no symbols.
 * Caller-owned storage and a 256-byte aligned RAM register page stay alive for
 * each run. No function here accesses physical RAMECC hardware. */
#ifndef C_RAMECC_REFERENCE_H
#define C_RAMECC_REFERENCE_H
#include <stdint.h>
#include "RAMECCReferenceTypes.h"
typedef struct CRAMECCContext CRAMECCContext;
enum { CRAMECC_IER = 0, CRAMECC_CR, CRAMECC_SR, CRAMECC_FAR, CRAMECC_FDRL, CRAMECC_FDRH, CRAMECC_FECR };
enum { CRAMECC_INIT = 0, CRAMECC_DEINIT, CRAMECC_START, CRAMECC_STOP,
       CRAMECC_ENABLE_NOTIFICATION, CRAMECC_DISABLE_NOTIFICATION, CRAMECC_IRQ,
       CRAMECC_GET_FAR, CRAMECC_GET_FDRL, CRAMECC_GET_FDRH, CRAMECC_GET_FECR,
       CRAMECC_IS_SINGLE, CRAMECC_IS_DOUBLE, CRAMECC_GET_STATE, CRAMECC_GET_ERROR,
       CRAMECC_REGISTER_CALLBACK, CRAMECC_UNREGISTER_CALLBACK };
uint32_t CRAMECC_ContextSize(void);
CRAMECCContext *CRAMECC_Prepare(uintptr_t storage, uintptr_t monitorAddress,
                              uint32_t registeredCallbacks, uint32_t state, uint32_t error);
uintptr_t CRAMECC_StateAddress(CRAMECCContext *context);
uintptr_t CRAMECC_MonitorAddress(CRAMECCContext *context);
uint32_t CRAMECC_Variant(CRAMECCContext *context);
uint32_t CRAMECC_ReadRegister(CRAMECCContext *context, uint32_t index);
void CRAMECC_WriteRegister(CRAMECCContext *context, uint32_t index, uint32_t value);
/* Selectors: 0 nil, 1 weak/default callback, 2/3 distinguishable user callbacks. */
void CRAMECC_SetCallback(CRAMECCContext *context, uint32_t id, uint32_t selector);
uint32_t CRAMECC_CallbackMask(CRAMECCContext *context);
void CRAMECC_SetAction(CRAMECCContext *context, uint32_t id, uint32_t action);
uint32_t CRAMECC_Run(CRAMECCContext *context, uint32_t operation, uint32_t argument, uint32_t selector);
/* Shared harness recorder: snapshots only, not driver logic. Returns action
 * 0 none,1 fixture mutation,2 recursive IRQ. An action is consumed once. */
uint32_t CRAMECC_RecordCallback(CRAMECCContext *context, uint32_t id, uint32_t selector, uint32_t callbackMask);
void CRAMECC_ApplyMutation(CRAMECCContext *context, uint32_t id);
/* Canonical words: seven registers, State, ErrorCode, callback mask, event
 * count, then 12 words/event: id,selector,seven registers,state,error,mask.
 * callbackMask is supplied by Swift (thin-function pointer identities differ)
 * or CRAMECC_CallbackMask for the independent C execution. */
uint32_t CRAMECC_SnapshotWordCount(CRAMECCContext *context);
uint32_t CRAMECC_SnapshotWord(CRAMECCContext *context, uint32_t callbackMask, uint32_t index);
uint32_t CRAMECC_ActionMask(CRAMECCContext *context);
#endif
