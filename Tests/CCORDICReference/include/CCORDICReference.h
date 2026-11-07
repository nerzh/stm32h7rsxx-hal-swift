/* Test-only fixtures for the unchanged CORDIC driver, callback modes 0 and 1. */
#ifndef C_CORDIC_REFERENCE_H
#define C_CORDIC_REFERENCE_H
#include "CORDICReferenceTypes.h"
#include <stddef.h>
typedef enum { CCORDIC_CSR, CCORDIC_WDATA, CCORDIC_RDATA } CCORDICRegister;
typedef enum { CCORDIC_Initialize, CCORDIC_Deinitialize, CCORDIC_Configure,
 CCORDIC_Calculate, CCORDIC_CalculateZeroOverhead, CCORDIC_CalculateInterrupt,
 CCORDIC_CalculateDMA, CCORDIC_HandleInterrupt, CCORDIC_GetState, CCORDIC_GetError,
 CCORDIC_RegisterCallback, CCORDIC_UnregisterCallback, CCORDIC_ResetHandleState,
 CCORDIC_EnableInterrupts, CCORDIC_DisableInterrupts, CCORDIC_GetFlag,
 CCORDIC_GetInterruptSource } CCORDICOperation;
typedef enum { CCORDIC_ActionNone, CCORDIC_ActionRegister, CCORDIC_ActionWord,
 CCORDIC_ActionPointer, CCORDIC_ActionCall, CCORDIC_ActionDMAParent, CCORDIC_ActionDMAEvent } CCORDICActionKind;
typedef struct { CCORDICActionKind kind; uint32_t target, index, value, a, b, c, d; } CCORDICAction;
typedef struct {
 uint32_t registers[3], words[2][6], pointers[2][2], callbacks[2][4];
 uint32_t dmaParents[4], dmaCallbacks[4][2], links[2][2];
 int32_t input[2][32], output[2][32];
} CCORDICSnapshot;
typedef struct { uint32_t handle, id, implementation, tickCalls; CCORDICSnapshot snapshot; } CCORDICCallbackEvent;
typedef struct { uint32_t channel, source, destination, size, status, tickCalls; CCORDICSnapshot snapshot; } CCORDICDMAEvent;
typedef struct { CCORDICRegister reg; uint32_t value, kind, tickCalls; } CCORDICAccess;
typedef struct { uint32_t active, kind, trigger, due; CCORDICAction action; } CCORDICEvent;
typedef void (*CCORDICActionHandler)(void *, CCORDICAction);
typedef struct {
 CORDIC_TypeDef registers;
 CCORDIC0Handle handles0[2]; CCORDIC1Handle handles1[2];
 DMA_HandleTypeDef dma[4];
 CORDIC_ConfigTypeDef configuration;
 int32_t input[2][32], output[2][32];
 uint32_t registeredCallbacks, tick, tickStep, tickCalls;
 uint32_t results[64], resultCount, resultIndex;
 uint32_t readCounts[3], writeCounts[3];
 uint32_t accessCount; CCORDICAccess accesses[512];
 uint32_t callbackCount; CCORDICCallbackEvent callbacks[32];
 uint32_t dmaCount; CCORDICDMAEvent dmaEvents[32];
 uint32_t dmaStatus[4]; CCORDICAction dmaActions[4][4];
 CCORDICAction callbackActions[2][4][4]; CCORDICEvent events[32];
 void *executionContext; CCORDICActionHandler actionHandler;
} CCORDICState;
/* Native input/output buffers retain the C pointer ABI. Only the original DMA
 * start arguments narrow pointers to uint32_t; the stub maps those low 32 bits
 * to logical buffer addresses, without dereferencing truncated pointers.
 * Both handles share one mock CORDIC peripheral. No trigonometric engine is
 * invented: RDATA returns scripted 32-bit words, readiness is explicitly set
 * by register/tick/data-access stimuli. Original direct CSR reads and direct
 * interrupt macros stay untouched; compare final storage and data accesses,
 * not a purported complete CSR read/write trace.
 */
void CCORDIC_Reset(CCORDICState *, uint32_t registeredCallbacks);
uint32_t CCORDIC_Get(const CCORDICState *, CCORDICRegister);
void CCORDIC_Set(CCORDICState *, CCORDICRegister, uint32_t);
uint32_t CCORDIC_Read(CCORDICState *, CCORDICRegister);
void CCORDIC_Write(CCORDICState *, CCORDICRegister, uint32_t);
/* Words: calculationsToOrder0,calculationsToGet1,dmaDirection2,lock3,state4,error5. */
uint32_t CCORDIC_GetWord(const CCORDICState *, uint32_t handle, uint32_t word);
void CCORDIC_SetWord(CCORDICState *, uint32_t handle, uint32_t word, uint32_t value);
int32_t *CCORDIC_Buffer(CCORDICState *, uint32_t handle, uint32_t output);
uint32_t CCORDIC_GetPointer(const CCORDICState *, uint32_t handle, uint32_t output);
void CCORDIC_SetPointer(CCORDICState *, uint32_t handle, uint32_t output, uint32_t logicalAddress);
uint32_t CCORDIC_NormalizeAddress(const CCORDICState *, uintptr_t address);
uint32_t CCORDIC_GetCallback(const CCORDICState *, uint32_t handle, uint32_t id);
void CCORDIC_SetCallback(CCORDICState *, uint32_t handle, uint32_t id, uint32_t implementation);
void CCORDIC_SetCallbackAction(CCORDICState *, uint32_t handle, uint32_t id, uint32_t slot, CCORDICAction);
void CCORDIC_EmitCallback(CCORDICState *, uint32_t handle, uint32_t id, uint32_t implementation);
CCORDICCallbackEvent CCORDIC_GetCallbackEvent(const CCORDICState *, uint32_t index);
int32_t CCORDIC_GetLink(const CCORDICState *, uint32_t handle, uint32_t output);
void CCORDIC_SetLink(CCORDICState *, uint32_t handle, uint32_t output, int32_t channel);
int32_t CCORDIC_GetDMAParent(const CCORDICState *, uint32_t channel);
void CCORDIC_SetDMAParent(CCORDICState *, uint32_t channel, int32_t handle);
/* DMA callback slots complete0/error1; values nil0/inputComplete1/outputComplete2/error3. */
uint32_t CCORDIC_GetDMACallback(const CCORDICState *, uint32_t channel, uint32_t slot);
void CCORDIC_SetDMACallback(CCORDICState *, uint32_t channel, uint32_t slot, uint32_t value);
void CCORDIC_InvokeDMA(CCORDICState *, uint32_t channel, uint32_t kind);
void CCORDIC_SetDMAAction(CCORDICState *, uint32_t channel, uint32_t slot, CCORDICAction);
uint32_t CCORDIC_DMAStartModel(CCORDICState *, uint32_t channel, uint32_t source, uint32_t destination, uint32_t size);
CCORDICDMAEvent CCORDIC_GetDMAEvent(const CCORDICState *, uint32_t index);
CCORDICSnapshot CCORDIC_GetSnapshot(const CCORDICState *);
CCORDICAccess CCORDIC_GetAccess(const CCORDICState *, uint32_t index);
uint32_t CCORDIC_Tick(CCORDICState *);
void CCORDIC_ScheduleTick(CCORDICState *, uint32_t afterCalls, CCORDICAction);
void CCORDIC_ScheduleRead(CCORDICState *, CCORDICRegister, uint32_t afterReads, CCORDICAction);
void CCORDIC_ScheduleWrite(CCORDICState *, CCORDICRegister, uint32_t afterWrites, CCORDICAction);
void CCORDIC_SetExecutionHook(CCORDICState *, void *, CCORDICActionHandler);
void CCORDIC_ApplyAction(CCORDICState *, CCORDICAction);
/* Calculation args a=count,b=timeout or DMA direction,c=null-input,d=null-output.
 * Callback registration a=id,b=selector(nil0/default1/user2/user3). Macro a=mask.
 * Configure uses state.configuration. Other operations ignore arguments. */
uint32_t CCORDIC_Run(CCORDICState *, uint32_t handle, CCORDICOperation, uint32_t a, uint32_t b, uint32_t c, uint32_t d);
uint32_t CCORDIC_RunNull(CCORDICState *, CCORDICOperation);
#endif
