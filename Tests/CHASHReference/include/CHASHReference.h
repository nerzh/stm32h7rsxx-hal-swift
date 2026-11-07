/* Test fixtures for unchanged STM32H7RS HASH source; no hash algorithm engine. */
#ifndef C_HASH_REFERENCE_H
#define C_HASH_REFERENCE_H
#include "HASHReferenceTypes.h"
#include <stddef.h>
typedef enum { CHASH_CR, CHASH_DIN, CHASH_STR, CHASH_HR0, CHASH_HR1, CHASH_HR2, CHASH_HR3, CHASH_HR4, CHASH_IMR, CHASH_SR, CHASH_CSR0, CHASH_CSR1, CHASH_CSR2, CHASH_CSR3, CHASH_CSR4, CHASH_CSR5, CHASH_CSR6, CHASH_CSR7, CHASH_CSR8, CHASH_CSR9, CHASH_CSR10, CHASH_CSR11, CHASH_CSR12, CHASH_CSR13, CHASH_CSR14, CHASH_CSR15, CHASH_CSR16, CHASH_CSR17, CHASH_CSR18, CHASH_CSR19, CHASH_CSR20, CHASH_CSR21, CHASH_CSR22, CHASH_CSR23, CHASH_CSR24, CHASH_CSR25, CHASH_CSR26, CHASH_CSR27, CHASH_CSR28, CHASH_CSR29, CHASH_CSR30, CHASH_CSR31, CHASH_CSR32, CHASH_CSR33, CHASH_CSR34, CHASH_CSR35, CHASH_CSR36, CHASH_CSR37, CHASH_CSR38, CHASH_CSR39, CHASH_CSR40, CHASH_CSR41, CHASH_CSR42, CHASH_CSR43, CHASH_CSR44, CHASH_CSR45, CHASH_CSR46, CHASH_CSR47, CHASH_CSR48, CHASH_CSR49, CHASH_CSR50, CHASH_CSR51, CHASH_CSR52, CHASH_CSR53, CHASH_CSR54, CHASH_CSR55, CHASH_CSR56, CHASH_CSR57, CHASH_CSR58, CHASH_CSR59, CHASH_CSR60, CHASH_CSR61, CHASH_CSR62, CHASH_CSR63, CHASH_CSR64, CHASH_CSR65, CHASH_CSR66, CHASH_CSR67, CHASH_CSR68, CHASH_CSR69, CHASH_CSR70, CHASH_CSR71, CHASH_CSR72, CHASH_CSR73, CHASH_CSR74, CHASH_CSR75, CHASH_CSR76, CHASH_CSR77, CHASH_CSR78, CHASH_CSR79, CHASH_CSR80, CHASH_CSR81, CHASH_CSR82, CHASH_CSR83, CHASH_CSR84, CHASH_CSR85, CHASH_CSR86, CHASH_CSR87, CHASH_CSR88, CHASH_CSR89, CHASH_CSR90, CHASH_CSR91, CHASH_CSR92, CHASH_CSR93, CHASH_CSR94, CHASH_CSR95, CHASH_CSR96, CHASH_CSR97, CHASH_CSR98, CHASH_CSR99, CHASH_CSR100, CHASH_CSR101, CHASH_CSR102, CHASH_DIGEST0, CHASH_DIGEST1, CHASH_DIGEST2, CHASH_DIGEST3, CHASH_DIGEST4, CHASH_DIGEST5, CHASH_DIGEST6, CHASH_DIGEST7, CHASH_DIGEST8, CHASH_DIGEST9, CHASH_DIGEST10, CHASH_DIGEST11, CHASH_DIGEST12, CHASH_DIGEST13, CHASH_DIGEST14, CHASH_DIGEST15, CHASH_RegisterCount } CHASHRegister;
typedef enum { CHASH_Initialize, CHASH_Deinitialize, CHASH_SetConfiguration, CHASH_GetConfiguration, CHASH_RegisterCallback, CHASH_UnregisterCallback, CHASH_Suspend, CHASH_Resume, CHASH_ProcessSuspend, CHASH_Start, CHASH_StartInterrupt, CHASH_StartDMA, CHASH_Accumulate, CHASH_AccumulateLast, CHASH_AccumulateInterrupt, CHASH_AccumulateLastInterrupt, CHASH_HMACStart, CHASH_HMACAccumulate, CHASH_HMACAccumulateLast, CHASH_HMACStartInterrupt, CHASH_HMACAccumulateInterrupt, CHASH_HMACAccumulateLastInterrupt, CHASH_HMACStartDMA, CHASH_HandleInterrupt, CHASH_GetState, CHASH_GetError, CHASH_ResetHandleState, CHASH_EnableInterrupts, CHASH_DisableInterrupts, CHASH_GetFlag, CHASH_ClearFlag, CHASH_GetInterruptSource, CHASH_SetMDMAT, CHASH_ResetMDMAT, CHASH_DigestLength, CHASH_WriteData, CHASH_WriteDataInterrupt, CHASH_GetDigest, CHASH_Wait } CHASHOperation;
typedef enum { CHASH_dataType, CHASH_keySize, CHASH_keyAddress, CHASH_algorithm, CHASH_inputAddress, CHASH_outputAddress, CHASH_inputCount, CHASH_size, CHASH_keyBufferAddress, CHASH_phase, CHASH_lock, CHASH_errorCode, CHASH_state, CHASH_accumulation, CHASH_suspendRequest, CHASH_savedDataType, CHASH_savedKeySize, CHASH_savedKeyAddress, CHASH_savedAlgorithm, CHASH_savedInputAddress, CHASH_savedOutputAddress, CHASH_savedInputCount, CHASH_savedSize, CHASH_savedKeyBufferAddress, CHASH_savedPhase } CHASHWord;
typedef enum { CHASH_ActionNone, CHASH_ActionRegister, CHASH_ActionWord,
 CHASH_ActionCall, CHASH_ActionDMAWord, CHASH_ActionDMAEvent } CHASHActionKind;
typedef struct { CHASHActionKind kind; uint32_t target,index,value,a,b,c,d; } CHASHAction;
typedef struct {
 uint32_t registers[5],words[2][25],callbacks[2][5],links[2];
 uint32_t dma[2][9],nodes[2][9]; uint8_t output[2][64];
} CHASHSnapshot;
typedef struct { uint32_t handle,id,implementation,tickCalls; CHASHSnapshot snapshot; } CHASHCallbackEvent;
typedef struct { uint32_t channel,operation,source,destination,size,status,tickCalls; CHASHSnapshot snapshot; } CHASHDMAEvent;
typedef struct { CHASHRegister reg; uint32_t kind,value,tickCalls; } CHASHAccess;
typedef struct { uint32_t active,kind,trigger,due; CHASHAction action; } CHASHEvent;
typedef void (*CHASHActionHandler)(void *,CHASHAction);
typedef struct {
 HASH_TypeDef registers; HASH_DIGEST_TypeDef digest;
 CHASH00Handle handles00[2]; CHASH01Handle handles01[2];
 CHASH10Handle handles10[2]; CHASH11Handle handles11[2];
 DMA_HandleTypeDef dma[2]; DMA_Channel_TypeDef channels[2];
 DMA_QListTypeDef queues[2]; DMA_NodeTypeDef nodes[2];
 /* Padding separates one-past pointers from the next native test buffer. */
 uint32_t input[2][132],key[2][132],output[2][20],context[2][110];
 uint32_t registeredCallbacks,suspendResume,configuration[4];
 uint32_t tick,tickStep,tickCalls,readCounts[CHASH_RegisterCount],writeCounts[CHASH_RegisterCount];
 uint32_t accessCount; CHASHAccess accesses[192];
 uint32_t callbackCount; CHASHCallbackEvent callbacks[8];
 uint32_t dmaCount; CHASHDMAEvent dmaEvents[8];
 uint32_t dmaStatus[2][3]; CHASHAction dmaActions[2][3][4];
 CHASHAction callbackActions[2][5][4]; CHASHEvent events[32];
 void *executionContext; CHASHActionHandler actionHandler;
} CHASHState;
/* Original direct DIN/HR/SR accesses, buffer dereferences, and UInt32 pointer
 * casts remain unchanged. Only macro MMIO accesses are traced/scriptable.
 * Host calls must stop before data/context dereferences; successful data and
 * context operations execute the same source on ARM using native RAM buffers.
 * All 25 public handle words use logical addresses. Input/key/output/context
 * buffers map to 0x20000000 + handle*0x1000 + {0,0x400,0x800,0x900}; widths and
 * pointer narrowing inside the C algorithm are never rewritten.
 * No implicit hashing, INIT, DCAL, W1C, security or DMA transfer effects. Set
 * explicit status/digest values or scheduled actions. HAL_IS_BIT_* and direct
 * flag reads are original and do not invoke macro-read scheduled events.
 */
void CHASH_Reset(CHASHState *,uint32_t registeredCallbacks,uint32_t suspendResume);
uint32_t CHASH_Get(const CHASHState *,CHASHRegister);
void CHASH_Set(CHASHState *,CHASHRegister,uint32_t);
uint32_t CHASH_Read(CHASHState *,CHASHRegister);
void CHASH_Write(CHASHState *,CHASHRegister,uint32_t);
uint32_t CHASH_GetWord(const CHASHState *,uint32_t handle,uint32_t word);
void CHASH_SetWord(CHASHState *,uint32_t handle,uint32_t word,uint32_t);
void *CHASH_Buffer(CHASHState *,uint32_t handle,uint32_t kind);
void *CHASH_Resolve(CHASHState *,uint32_t logicalAddress);
uint32_t CHASH_NormalizeAddress(const CHASHState *,uintptr_t nativeAddress);
uint32_t CHASH_ReadMemory(CHASHState *,uint32_t address,uint32_t width);
void CHASH_WriteMemory(CHASHState *,uint32_t address,uint32_t value,uint32_t width);
uint32_t CHASH_GetCallback(const CHASHState *,uint32_t handle,uint32_t id);
void CHASH_SetCallback(CHASHState *,uint32_t handle,uint32_t id,uint32_t implementation);
void CHASH_SetCallbackAction(CHASHState *,uint32_t handle,uint32_t id,uint32_t slot,CHASHAction);
void CHASH_EmitCallback(CHASHState *,uint32_t handle,uint32_t id,uint32_t implementation);
CHASHCallbackEvent CHASH_GetCallbackEvent(const CHASHState *,uint32_t index);
int32_t CHASH_GetLink(const CHASHState *,uint32_t handle);
void CHASH_SetLink(CHASHState *,uint32_t handle,int32_t channel);
/* DMA words: parent0 (-1 none), mode1, CBR1 2, CSR 3, queuePresent4,
 * headPresent5, error6. Callback slots complete0/error1: nil0/complete1/error2. */
uint32_t CHASH_GetNode(const CHASHState *,uint32_t channel,uint32_t word);
void CHASH_SetNode(CHASHState *,uint32_t channel,uint32_t word,uint32_t value);
uint32_t CHASH_GetDMAWord(const CHASHState *,uint32_t channel,uint32_t word);
void CHASH_SetDMAWord(CHASHState *,uint32_t channel,uint32_t word,uint32_t value);
uint32_t CHASH_GetDMACallback(const CHASHState *,uint32_t channel,uint32_t slot);
void CHASH_SetDMACallback(CHASHState *,uint32_t channel,uint32_t slot,uint32_t value);
void CHASH_InvokeDMA(CHASHState *,uint32_t originalChannel,uint32_t kind);
void CHASH_SetDMAAction(CHASHState *,uint32_t channel,uint32_t operation,uint32_t slot,CHASHAction);
/* Operation start0/listStart1/abort2. No peripheral data transfer is performed. */
uint32_t CHASH_DMAOperation(CHASHState *,uint32_t channel,uint32_t operation,uint32_t source,uint32_t destination,uint32_t size);
CHASHDMAEvent CHASH_GetDMAEvent(const CHASHState *,uint32_t index);
CHASHSnapshot CHASH_GetSnapshot(const CHASHState *);
CHASHAccess CHASH_GetAccess(const CHASHState *,uint32_t index);
uint32_t CHASH_Tick(CHASHState *);
void CHASH_ScheduleTick(CHASHState *,uint32_t afterCalls,CHASHAction);
void CHASH_ScheduleRead(CHASHState *,CHASHRegister,uint32_t afterReads,CHASHAction);
void CHASH_ScheduleWrite(CHASHState *,CHASHRegister,uint32_t afterWrites,CHASHAction);
void CHASH_SetExecutionHook(CHASHState *,void *,CHASHActionHandler);
void CHASH_ApplyAction(CHASHState *,CHASHAction);
/* Data operations a=inputAddress,b=Size,c=outputAddress,d=Timeout. Configure
 * uses configuration[DataType,KeySize,keyAddress,Algorithm]; a!=0 passes NULL.
 * Suspend/resume a=contextAddress. Callback a=id,b=implementation0..3.
 * Private WriteData a=input,b=Size; GetDigest a=output,b=byteCount;
 * Wait a=flag,b=status,c=Timeout. Macro a=mask. Void operations return zero. */
uint32_t CHASH_Run(CHASHState *,uint32_t handle,CHASHOperation,uint32_t a,uint32_t b,uint32_t c,uint32_t d);
uint32_t CHASH_RunNull(CHASHState *,CHASHOperation);
#endif
