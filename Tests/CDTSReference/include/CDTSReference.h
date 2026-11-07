/* Host fixtures around unchanged DTS functions and exported macros. */
#ifndef C_DTS_REFERENCE_H
#define C_DTS_REFERENCE_H
#include "DTSReferenceTypes.h"
#include <stddef.h>
typedef enum { CDTS_CFGR1, CDTS_T0VALR1, CDTS_RAMPVALR, CDTS_ITR1, CDTS_DR,
 CDTS_SR, CDTS_ITENR, CDTS_ICIFR, CDTS_EXTI_IMR2, CDTS_EXTI_EMR2, CDTS_RegisterCount } CDTSRegister;
typedef enum { CDTS_Initialize, CDTS_Deinitialize, CDTS_Start, CDTS_Stop,
 CDTS_StartInterrupt, CDTS_StopInterrupt, CDTS_GetTemperature, CDTS_HandleInterrupt,
 CDTS_GetState, CDTS_RegisterCallback, CDTS_UnregisterCallback,
 CDTS_ResetHandleState, CDTS_Enable, CDTS_Disable, CDTS_EnableInterrupts, CDTS_DisableInterrupts,
 CDTS_GetFlag, CDTS_ClearFlag, CDTS_GetInterruptSource, CDTS_GetReferenceClock, CDTS_GetTrigger,
 CDTS_EnableWakeupInterrupt, CDTS_DisableWakeupInterrupt, CDTS_EnableWakeupEvent, CDTS_DisableWakeupEvent } CDTSOperation;
typedef enum { CDTS_ActionNone, CDTS_ActionRegister, CDTS_ActionWord, CDTS_ActionCall } CDTSActionKind;
typedef struct { CDTSActionKind kind; uint32_t index, value, argument, implementation; } CDTSAction;
typedef struct { uint32_t registers[10], words[9], callbacks[8]; int32_t temperature; } CDTSSnapshot;
typedef struct { CDTSRegister reg; uint32_t value, kind, tickCall; } CDTSAccess;
typedef struct { uint32_t callbackID, implementation, tickCall, delayCount; CDTSSnapshot snapshot; } CDTSCallbackEvent;
typedef struct { uint32_t duration, tickCall; CDTSSnapshot snapshot; } CDTSDelayEvent;
typedef struct { uint32_t due, active; CDTSAction action; } CDTSTickEvent;
typedef void (*CDTSActionHandler)(void *, CDTSAction);
typedef struct {
 DTS_TypeDef registers;
 EXTI_TypeDef exti;
 CDTS0Handle handle0;
 CDTS1Handle handle1;
 uint32_t registeredCallbacks, pclk1, lse, tick, tickStep, tickCalls;
 int32_t temperature;
 uint32_t accessCount; CDTSAccess accesses[512];
 uint32_t callbackCount; CDTSCallbackEvent callbacks[64];
 uint32_t delayCount; CDTSDelayEvent delays[16];
 CDTSAction callbackActions[8][4], delayAction;
 CDTSTickEvent events[32];
 void *executionContext; CDTSActionHandler actionHandler;
} CDTSState;
/* Reset initializes raw storage, RESET handle, sampling=1 cycle, factory
 * T0VALR1=6000/RAMPVALR=1000, DR=80, PCLK1=48M/LSE=32768, tickStep=1.
 * There are no implicit ready or W1C effects. Direct source reads (temperature,
 * flag/trigger getters) and ICIFR writes intentionally remain raw memory.
 * Full register read ordering is checked by Swift trace tests. Fresh IRQ SR
 * reads are compared through callback mutations and recursive IRQ actions.
 * LSE_VALUE is a uint32_t fixture expression, preserving the Cortex-M unsigned
 * multiplication width even on LP64 hosts. Signed-overflow input domains are
 * excluded: C's final signed subtraction/addition is undefined for those.
 */
void CDTS_Reset(CDTSState *, uint32_t registeredCallbacks);
uint32_t CDTS_Get(const CDTSState *, CDTSRegister);
void CDTS_Set(CDTSState *, CDTSRegister, uint32_t value);
uint32_t CDTS_Read(CDTSState *, CDTSRegister);
void CDTS_Write(CDTSState *, CDTSRegister, uint32_t value);
CDTSAccess CDTS_GetAccess(const CDTSState *, uint32_t index);
/* Words 0...6 are Init fields, 7=Lock and 8=State. */
uint32_t CDTS_GetWord(const CDTSState *, uint32_t word);
void CDTS_SetWord(CDTSState *, uint32_t word, uint32_t value);
/* IDs match HAL: complete0,asyncComplete1,low2,asyncLow3,high4,asyncHigh5,
 * MSPinit6,MSPdeinit7; selectors nil0,weak/default1,user2/3. */
uint32_t CDTS_GetCallback(const CDTSState *, uint32_t id);
void CDTS_SetCallback(CDTSState *, uint32_t id, uint32_t implementation);
void CDTS_SetCallbackAction(CDTSState *, uint32_t id, uint32_t slot, CDTSAction);
void CDTS_EmitCallback(CDTSState *, uint32_t id, uint32_t implementation);
CDTSCallbackEvent CDTS_GetCallbackEvent(const CDTSState *, uint32_t index);
CDTSSnapshot CDTS_GetSnapshot(const CDTSState *);
uint32_t CDTS_Tick(CDTSState *);
void CDTS_Delay(CDTSState *, uint32_t duration);
CDTSDelayEvent CDTS_GetDelayEvent(const CDTSState *, uint32_t index);
void CDTS_ScheduleTick(CDTSState *, uint32_t afterCalls, CDTSAction);
void CDTS_SetDelayAction(CDTSState *, CDTSAction);
/* Actions are consumed before execution. Register/word use index+value;
 * Call uses index=operation,argument,implementation. Swift installs a hook to
 * execute the same actions with its driver, never by calling the C HAL. */
void CDTS_SetExecutionHook(CDTSState *, void *, CDTSActionHandler);
uint32_t CDTS_ApplyAction(CDTSState *, CDTSAction);
uint32_t CDTS_Run(CDTSState *, CDTSOperation, uint32_t argument, uint32_t implementation);
/* Only Init/DeInit/Start/Stop/StartIT/StopIT check a NULL handle. */
uint32_t CDTS_RunNull(CDTSState *, CDTSOperation);
#endif
