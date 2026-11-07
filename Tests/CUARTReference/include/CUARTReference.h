/* Host-only fixtures for unchanged UART/UARTEx HAL bodies. */
#ifndef C_UART_REFERENCE_H
#define C_UART_REFERENCE_H
#include "UARTReferenceTypes.h"
#include <stddef.h>

typedef enum { CUART_CR1, CUART_CR2, CUART_CR3, CUART_BRR, CUART_GTPR, CUART_RTOR,
 CUART_RQR, CUART_ISR, CUART_ICR, CUART_RDR, CUART_TDR, CUART_PRESC } CUARTRegister;
typedef enum {
 CUART_Initialize, CUART_InitializeHalfDuplex, CUART_InitializeLIN, CUART_InitializeMultiProcessor,
 CUART_InitializeRS485, CUART_Deinitialize, CUART_Transmit, CUART_Receive,
 CUART_TransmitInterrupt, CUART_ReceiveInterrupt, CUART_HandleInterrupt,
 CUART_TransmitDMA, CUART_ReceiveDMA, CUART_PauseDMA, CUART_ResumeDMA, CUART_StopDMA,
 CUART_Abort, CUART_AbortTransmit, CUART_AbortReceive, CUART_AbortInterrupt,
 CUART_AbortTransmitInterrupt, CUART_AbortReceiveInterrupt,
 CUART_ConfigureReceiverTimeout, CUART_EnableReceiverTimeout, CUART_DisableReceiverTimeout,
 CUART_EnableMuteMode, CUART_DisableMuteMode, CUART_EnterMuteMode,
 CUART_EnableTransmitter, CUART_EnableReceiver, CUART_SendBreak, CUART_GetState, CUART_GetError,
 CUART_SetAddressLength, CUART_ConfigureStopModeWakeup, CUART_EnableStopMode, CUART_DisableStopMode,
 CUART_EnableFIFOMode, CUART_DisableFIFOMode, CUART_SetTransmitFIFOThreshold, CUART_SetReceiveFIFOThreshold,
 CUART_ReceiveToIdle, CUART_ReceiveToIdleInterrupt, CUART_ReceiveToIdleDMA, CUART_GetRxEventType,
 CUART_RegisterCallback, CUART_UnregisterCallback, CUART_RegisterRxEventCallback, CUART_UnregisterRxEventCallback,
 CUART_SetConfiguration, CUART_CheckIdleState, CUART_WaitOnFlag
} CUARTOperation;
typedef enum { CUART_DMAStartInterrupt, CUART_DMAStartLinkedListInterrupt, CUART_DMAAbort,
 CUART_DMAAbortInterrupt, CUART_DMASuspend, CUART_DMAResume } CUARTDMAOperation;
/* DMA words: mode/state/error/lock/counter/parentUART/queuePresent/queueState.
 * Parent UART uses 0/1, UINT32_MAX means NULL. Callback slots use the DMA enum
 * complete=0, half=1, error=2, abort=3, suspend=4; values 0=NULL, 1...10=UART
 * DMA event kind + 1. Queue and node memory use the logical addresses below. */
typedef enum { CUART_DMAMode, CUART_DMAState, CUART_DMAError, CUART_DMALock,
 CUART_DMACounter, CUART_DMAParent, CUART_DMAQueuePresent, CUART_DMAQueueState } CUARTDMAWord;
typedef enum { CUART_ActionNone, CUART_ActionRegister, CUART_ActionWord, CUART_ActionPointer,
 CUART_ActionCall, CUART_ActionDMAWord, CUART_ActionDMAEvent } CUARTActionKind;
typedef struct { CUARTActionKind kind; uint32_t target, index, value, args[4]; } CUARTAction;
typedef struct { uint32_t uart, reg, value, kind, tickCall; } CUARTAccess;
typedef struct {
 uint32_t words[2][35], pointers[2][2], registers[2][12], callbacks[2][14];
 uint32_t dmaWords[4][8], dmaCallbacks[4][5], nodes[4][9];
} CUARTSnapshot;
typedef struct {
 uint32_t uart, callbackID, implementation, position, tickCall, accessCount, dmaCallCount;
 CUARTSnapshot snapshot;
} CUARTCallbackEvent;
typedef struct {
 uint32_t channel, operation, args[3], tickCall, accessCount, callbackCount;
 CUARTSnapshot snapshot;
} CUARTDMAEvent;
typedef struct {
 USART_TypeDef registers;
 CUART0Handle handle0;
 CUART1Handle handle1;
 uint32_t instance, txBuffer[128], rxBuffer[128];
 uint16_t receivedCount;
} CUARTDevice;
typedef struct {
 DMA_Channel_TypeDef registers;
 DMA_HandleTypeDef handle;
 DMA_QListTypeDef queue;
 DMA_NodeTypeDef node;
 uint32_t statuses[6];
 CUARTAction actions[6];
} CUARTDMADevice;
typedef struct { uint32_t trigger, uart, reg, due, active; CUARTAction action; } CUARTScheduledAction;
typedef struct { uint32_t uart, reg, value, active; } CUARTScriptedRead;
typedef void (*CUARTActionHandler)(void *, CUARTAction);
typedef void (*CUARTDMAEventHandler)(void *, uint32_t, uint32_t);
typedef struct {
 CUARTDevice uart[2]; CUARTDMADevice dma[4];
 uint32_t registeredCallbacks, tick, tickStep, tickCalls;
 /* Normalized RCC kernel selections 0...5 for USART1, USART234578, LPUART1 respectively.
  * Frequencies: PCLK1/PCLK2/PCLK4/PLL2Q/PLL3Q/HSI/CSI/LSE. */
 uint32_t clockSelections[3], clockFrequencies[8], hsiDividerReady, hsiDivider;
 uint32_t readCounts[2][12], atomicCalls, exclusiveFailures;
 uint32_t accessCount; CUARTAccess accesses[2048];
 uint32_t callbackCount; CUARTCallbackEvent callbackEvents[64];
 uint32_t dmaCallCount; CUARTDMAEvent dmaEvents[128];
 CUARTAction callbackActions[2][14][4];
 CUARTScheduledAction events[64]; CUARTScriptedRead reads[512];
 void *executionContext; CUARTActionHandler actionHandler; CUARTDMAEventHandler dmaEventHandler;
} CUARTState;

/* Keep the state at a stable native address. Reset uses zero raw registers,
 * ready state 0x20, 115200/8N1/TX+RX, normal DMA, nil callback slots, tickStep=1,
 * and 48 MHz clock inputs (HSI64M/CSI4M/LSE32768). Devices default USART3/USART2.
 * No implicit W1C, FIFO, ready-flag or DMA side effects are invented. The exact C
 * uses direct ISR/RDR/TDR/ICR accesses in several paths; only READ_REG/WRITE_REG
 * and exclusive accesses are recorded. Tick actions cover direct-read polling.
 */
void CUART_Reset(CUARTState *, uint32_t registeredCallbacks);
void CUART_SetInstance(CUARTState *, uint32_t uart, uint32_t physicalAddress);
uint32_t CUART_GetRegister(const CUARTState *, uint32_t uart, CUARTRegister);
void CUART_SetRegister(CUARTState *, uint32_t uart, CUARTRegister, uint32_t value);
uint32_t CUART_Read(CUARTState *, uint32_t uart, CUARTRegister);
void CUART_Write(CUARTState *, uint32_t uart, CUARTRegister, uint32_t value);
void CUART_AtomicModify(CUARTState *, uint32_t uart, CUARTRegister, uint32_t clearMask, uint32_t setMask);
uint32_t CUART_Tick(CUARTState *);
CUARTAccess CUART_GetAccess(const CUARTState *, uint32_t index);
uint32_t CUART_GetWord(const CUARTState *, uint32_t uart, uint32_t word);
void CUART_SetWord(CUARTState *, uint32_t uart, uint32_t word, uint32_t value);
/* Logical buffer addresses are 0x24010000 + uart*0x2000 + direction*0x1000;
 * direction TX=0/RX=1. NULL remains zero, cursor offsets remain byte offsets. */
uint32_t CUART_GetPointer(const CUARTState *, uint32_t uart, uint32_t direction);
void CUART_SetPointer(CUARTState *, uint32_t uart, uint32_t direction, uint32_t logicalAddress);
void *CUART_Buffer(CUARTState *, uint32_t uart, uint32_t direction);
uint32_t CUART_BufferAddress(uint32_t uart, uint32_t direction);
uint32_t CUART_NormalizeAddress(const CUARTState *, uintptr_t address);
void CUART_SetBufferByte(CUARTState *, uint32_t uart, uint32_t direction, uint32_t offset, uint8_t value);
uint8_t CUART_GetBufferByte(const CUARTState *, uint32_t uart, uint32_t direction, uint32_t offset);
uint32_t CUART_GetCallback(const CUARTState *, uint32_t uart, uint32_t callbackID);
void CUART_SetCallback(CUARTState *, uint32_t uart, uint32_t callbackID, uint32_t implementation);
/* Callback IDs 0...12 match Swift; RxEvent=13. Implementations nil=0,
 * weak/default=1, two different user callbacks=2/3. */
/* All scripted actions are consumed before execution, including callback actions. */
void CUART_SetCallbackAction(CUARTState *, uint32_t uart, uint32_t callbackID, uint32_t slot, CUARTAction);
CUARTAction CUART_GetCallbackAction(const CUARTState *, uint32_t uart, uint32_t callbackID, uint32_t slot);
void CUART_EmitCallback(CUARTState *, uint32_t uart, uint32_t callbackID, uint32_t implementation, uint32_t position);
CUARTCallbackEvent CUART_GetCallbackEvent(const CUARTState *, uint32_t index);
CUARTSnapshot CUART_GetSnapshot(const CUARTState *);
/* C uses the default action dispatcher. Swift installs these two noncapturing
 * hooks so identical scripted stimuli reenter the Swift implementation. */
void CUART_SetExecutionHooks(CUARTState *, void *context, CUARTActionHandler, CUARTDMAEventHandler);
uint32_t CUART_ApplyAction(CUARTState *, CUARTAction);
void CUART_ScheduleTick(CUARTState *, uint32_t afterCalls, CUARTAction);
void CUART_ScheduleRead(CUARTState *, uint32_t uart, CUARTRegister, uint32_t afterCalls, CUARTAction);
void CUART_ScheduleAtomic(CUARTState *, uint32_t afterCalls, CUARTAction);
void CUART_AppendRead(CUARTState *, uint32_t uart, CUARTRegister, uint32_t value);
int32_t CUART_GetLinkedDMA(const CUARTState *, uint32_t uart, uint32_t direction);
uint16_t *CUART_ReceivedCount(CUARTState *, uint32_t uart);
void CUART_LinkDMA(CUARTState *, uint32_t uart, uint32_t direction, int32_t channel);
uint32_t CUART_GetDMAWord(const CUARTState *, uint32_t channel, CUARTDMAWord);
void CUART_SetDMAWord(CUARTState *, uint32_t channel, CUARTDMAWord, uint32_t value);
uint32_t CUART_GetDMACallback(const CUARTState *, uint32_t channel, uint32_t callbackID);
void CUART_SetDMACallback(CUARTState *, uint32_t channel, uint32_t callbackID, uint32_t eventPlusOne);
/* Queue base 0x24030000 + channel*0x100; node base queue+0x40. */
uint32_t CUART_DMAReadMemory32(const CUARTState *, uint32_t channel, uint32_t address);
void CUART_DMAWriteMemory32(CUARTState *, uint32_t channel, uint32_t address, uint32_t value);
void CUART_SetDMAStatus(CUARTState *, uint32_t channel, CUARTDMAOperation, uint32_t status);
void CUART_SetDMAAction(CUARTState *, uint32_t channel, CUARTDMAOperation, CUARTAction);
uint32_t CUART_PerformDMA(CUARTState *, uint32_t channel, CUARTDMAOperation, uint32_t a, uint32_t b, uint32_t c);
CUARTDMAEvent CUART_GetDMAEvent(const CUARTState *, uint32_t index);
void CUART_InvokeDMAEvent(CUARTState *, uint32_t originalChannel, uint32_t eventKind);
uint32_t CUART_GetClockSource(const CUARTState *, uint32_t uart);
uint32_t CUART_GetClockFrequency(const CUARTState *, uint32_t source);
/* Data operations: args=(size,timeout,byteOffset,nullData). Initialize LIN uses
 * a=breakLength; MultiProcessor a=address,b=wakeup; RS485 a=polarity,b=assert,c=deassert.
 * Wakeup a=event,b=addressLength,c=address. Register callback a=id,b=implementation;
 * RxEvent registration a=implementation. WaitOnFlag a=flag,b=status,c=start,d=timeout.
 * Other single-value operations use a. Null handle cases use CUART_CallNull. */
uint32_t CUART_Call(CUARTState *, uint32_t uart, CUARTOperation, uint32_t a, uint32_t b, uint32_t c, uint32_t d);
uint32_t CUART_CallNull(CUARTState *, CUARTOperation);
#endif
