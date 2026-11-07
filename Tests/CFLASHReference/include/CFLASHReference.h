/* Host/ARM fixtures around unchanged STM32H7RS FLASH/FLASHEx functions. */
#ifndef C_FLASH_REFERENCE_H
#define C_FLASH_REFERENCE_H
#include "FLASHReferenceTypes.h"
#include <stddef.h>
typedef enum { CFLASH_ACR, CFLASH_KEYR, CFLASH_CR, CFLASH_SR, CFLASH_IER, CFLASH_ISR, CFLASH_ICR, CFLASH_CRCCR, CFLASH_CRCSADDR, CFLASH_CRCEADDR, CFLASH_CRCDATAR, CFLASH_ECCSFADDR, CFLASH_ECCDFADDR, CFLASH_OPTKEYR, CFLASH_OPTCR, CFLASH_OPTISR, CFLASH_OPTICR, CFLASH_OBKCR, CFLASH_OBKDR0, CFLASH_OBKDR1, CFLASH_OBKDR2, CFLASH_OBKDR3, CFLASH_OBKDR4, CFLASH_OBKDR5, CFLASH_OBKDR6, CFLASH_OBKDR7, CFLASH_NVSR, CFLASH_NVSRP, CFLASH_ROTSR, CFLASH_ROTSRP, CFLASH_OTPLSR, CFLASH_OTPLSRP, CFLASH_WRPSR, CFLASH_WRPSRP, CFLASH_HDPSR, CFLASH_HDPSRP, CFLASH_EPOCHSR, CFLASH_EPOCHSRP, CFLASH_OBW1SR, CFLASH_OBW1SRP, CFLASH_OBW2SR, CFLASH_OBW2SRP, CFLASH_RegisterCount } CFLASHRegister;
typedef enum {
 CFLASH_Program, CFLASH_ProgramInterrupt, CFLASH_HandleInterrupt,
 CFLASH_Unlock, CFLASH_Lock, CFLASH_UnlockOptionBytes, CFLASH_LockOptionBytes,
 CFLASH_GetError, CFLASH_Wait, CFLASH_Erase, CFLASH_EraseInterrupt,
 CFLASH_ProgramOptionBytes, CFLASH_GetOptionBytes, CFLASH_ConfigureOTPLock,
 CFLASH_GetOTPLock, CFLASH_ConfigureKey, CFLASH_GetKey, CFLASH_ComputeCRC,
 CFLASH_EnableECCCorrection, CFLASH_DisableECCCorrection,
 CFLASH_EnableECCDetection, CFLASH_DisableECCDetection, CFLASH_GetECCInfo,
 CFLASH_HandleECCDetection, CFLASH_EnableInterrupts, CFLASH_DisableInterrupts,
 CFLASH_GetFlag, CFLASH_ClearFlag, CFLASH_SetLatency, CFLASH_GetLatency
} CFLASHOperation;
typedef enum { CFLASH_ActionNone, CFLASH_ActionRegister, CFLASH_ActionProcess, CFLASH_ActionCall } CFLASHActionKind;
typedef struct { CFLASHActionKind kind; uint32_t index, value, a, b, c; } CFLASHAction;
typedef struct { uint32_t registers[CFLASH_RegisterCount], process[6], sectorError, crcResult, keys[8]; FLASH_OBProgramInitTypeDef options; FLASH_EccInfoTypeDef ecc; } CFLASHSnapshot;
typedef struct { CFLASHRegister reg; uint32_t value, kind, tickCall; } CFLASHAccess;
typedef struct { uint32_t id, argument, tickCall; CFLASHSnapshot snapshot; } CFLASHCallbackEvent;
typedef struct { uint32_t kind, value; } CFLASHIntrinsicEvent;
typedef struct { uint32_t active, kind, trigger, due; CFLASHAction action; } CFLASHEvent;
typedef void (*CFLASHActionHandler)(void *, CFLASHAction);
typedef struct {
 FLASH_TypeDef registers;
 FLASH_ProcessTypeDef process;
 FLASH_EraseInitTypeDef erase;
 FLASH_OBProgramInitTypeDef options;
 FLASH_KeyConfigTypeDef key;
 FLASH_CRCInitTypeDef crc;
 FLASH_EccInfoTypeDef ecc;
 uint32_t keys[8], sectorError, crcResult, primask;
 uint32_t tick, tickStep, tickCalls;
 uint32_t accessCount; CFLASHAccess accesses[512];
 uint32_t writeCounts[CFLASH_RegisterCount];
 uint32_t callbackCount; CFLASHCallbackEvent callbacks[32];
 uint32_t intrinsicCount; CFLASHIntrinsicEvent intrinsics[64];
 CFLASHAction callbackActions[4][4]; CFLASHEvent events[32];
 void *executionContext; CFLASHActionHandler actionHandler;
} CFLASHState;
/* Raw register storage: direct source reads/writes are deliberately unmodified.
 * No implicit W1C, key-unlock, erase, option-byte, key-storage or CRC effects.
 * Script tick events or macro-write events to choose hardware completion/error
 * outcomes. Compare final storage and callback snapshots; only macro accesses
 * appear in the access trace, so this is not a complete MMIO-order oracle.
 * Host Program calls must return before a memory helper; successful programming
 * is ARM-only, retaining every original uint32_t-to-pointer cast.
 * Six process words: Lock, ErrorCode, ProcedureOnGoing, Address, Sector,
 * NbSectorsToErase. Public addresses are logical and normalized on ARM.
 */
void CFLASH_Reset(CFLASHState *);
uint32_t CFLASH_Get(const CFLASHState *, CFLASHRegister);
void CFLASH_Set(CFLASHState *, CFLASHRegister, uint32_t);
uint32_t CFLASH_Read(CFLASHState *, CFLASHRegister);
void CFLASH_Write(CFLASHState *, CFLASHRegister, uint32_t);
uint32_t CFLASH_GetProcess(const CFLASHState *, uint32_t word);
void CFLASH_SetProcess(CFLASHState *, uint32_t word, uint32_t value);
uint32_t CFLASH_Tick(CFLASHState *);
void CFLASH_ScheduleTick(CFLASHState *, uint32_t afterCalls, CFLASHAction);
void CFLASH_ScheduleWrite(CFLASHState *, CFLASHRegister, uint32_t afterWrites, CFLASHAction);
void CFLASH_SetCallbackAction(CFLASHState *, uint32_t id, uint32_t slot, CFLASHAction);
void CFLASH_SetExecutionHook(CFLASHState *, void *, CFLASHActionHandler);
void CFLASH_ApplyAction(CFLASHState *, CFLASHAction);
/* IDs: end-of-operation0, operation-error1, ECC-correction2, ECC-detection3. */
void CFLASH_EmitCallback(CFLASHState *, uint32_t id, uint32_t argument);
CFLASHCallbackEvent CFLASH_GetCallbackEvent(const CFLASHState *, uint32_t index);
CFLASHAccess CFLASH_GetAccess(const CFLASHState *, uint32_t index);
CFLASHIntrinsicEvent CFLASH_GetIntrinsic(const CFLASHState *, uint32_t index);
CFLASHSnapshot CFLASH_GetSnapshot(const CFLASHState *);
/* Intrinsic kinds: getPRIMASK0, disableIRQ1, ISB2, DSB3, setPRIMASK4. */
uint32_t CFLASH_Intrinsic(CFLASHState *, uint32_t kind, uint32_t value);
/* Program args: a=type,b=logical destination,c=logical source;
 * Wait/OTP/macros: a=value; GetKey a!=0 selects NULL output. Other operations
 * use the explicit configuration/output fields above. Keys are host native
 * pointers; Swift maps its key memory at logical address 0x20000000. */
uint32_t CFLASH_Run(CFLASHState *, CFLASHOperation, uint32_t a, uint32_t b, uint32_t c);
/* ARM-only test geometry. Never uses physical FLASH, OTP or protection MMIO.
 * Main [0x24038000,+0x400), OTP [0x24038400,+0x400), source 0x24039000.
 * FLASH_SIZE is narrowed to the test arena; real-device address validation is
 * exercised separately by production tests. All instruction helpers are model
 * events and do not alter the physical CPU interrupt mask. */
#define CFLASH_ARM_MAIN_BASE 0x24038000U
#define CFLASH_ARM_OTP_BASE 0x24038400U
#define CFLASH_ARM_SOURCE_BASE 0x24039000U
#define CFLASH_ARM_AREA_SIZE 0x400U
uint32_t CFLASH_PhysicalAddress(uint32_t logical);
uint32_t CFLASH_LogicalAddress(uint32_t physical);
#endif
