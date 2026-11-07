/* Host-only raw register/state stimuli for the unchanged DMA/DMAEx functions. */
#ifndef C_DMA_REFERENCE_H
#define C_DMA_REFERENCE_H
#include "DMAARMReference.h"

typedef enum {
  CDMA_CLBAR, CDMA_CFCR, CDMA_CSR, CDMA_CCR, CDMA_CTR1, CDMA_CTR2,
  CDMA_CBR1, CDMA_CSAR, CDMA_CDAR, CDMA_CTR3, CDMA_CBR2, CDMA_CLLR,
  CDMA_PRIVCFGR, CDMA_RCFGLOCKR, CDMA_MISR, CDMA_RegisterCount
} CDMARegister;
typedef enum {
  CDMA_Initialize, CDMA_Deinitialize, CDMA_Start, CDMA_StartInterrupt,
  CDMA_Abort, CDMA_AbortInterrupt, CDMA_Poll, CDMA_Interrupt,
  CDMA_GetState, CDMA_GetError, CDMA_ConfigureAttributes, CDMA_GetAttributes,
  CDMA_LockAttributes, CDMA_GetAttributeLock, CDMA_RegisterCallback, CDMA_UnregisterCallback,
  CDMA_ConfigureDataHandling, CDMA_ConfigureTrigger, CDMA_ConfigureRepeatBlock,
  CDMA_Suspend, CDMA_SuspendInterrupt, CDMA_Resume, CDMA_GetFifoLevel,
  CDMA_InitializeLinkedList, CDMA_DeinitializeLinkedList,
  CDMA_BuildNode, CDMA_GetNodeConfiguration
} CDMAOperation;
typedef struct {
  CDMARegister reg;
  uint32_t dueCall, clearMask, setMask, active;
} CDMAEvent;
typedef struct {
  uint32_t tick, tickCall;
  uint32_t handle[5], queue[6], registers[CDMA_RegisterCount];
} CDMASnapshot;
typedef struct {
  uint32_t callbackID, implementation, actionStatus, slots[5];
  uintptr_t parent;
  CDMASnapshot snapshot;
} CDMACallbackEvent;
typedef struct {
  /* Real CMSIS layouts for all channels keep the original IS_* macros valid.
   * Only the two pointer-derived GET_DMA_* macros use host address lookups. */
  DMA_TypeDef controllers[2];
  DMA_Channel_TypeDef channels[2][16];
  DMA_HandleTypeDef handle;
  DMA_QListTypeDef queue;
  DMA_NodeTypeDef node;
  DMA_NodeConfTypeDef nodeConfiguration;
  DMA_DataHandlingConfTypeDef dataHandling;
  DMA_TriggerConfTypeDef trigger;
  DMA_RepeatBlockConfTypeDef repeatBlock;
  uint32_t controller, channel, queueAddress, nodeAddress;
  uint32_t tick, tickStep, tickCalls, output;
  /* Null bits: handle=1, configuration=2, output/node=4. Use only with entry
   * points whose unchanged C implementation checks the corresponding pointer. */
  uint32_t nullMask;
  CDMAEvent events[64];
  uint32_t snapshotCount;
  CDMASnapshot snapshots[256];
  uint32_t callbackCount;
  CDMACallbackEvent callbacks[64];
  /* Actions: 0=none,1=Start,2=Start_IT,3=Abort_IT,4=Resume,5=assign ErrorCode.
   * Start uses the action's three arguments as source/destination/byte count. */
  uint32_t callbackActions[5], callbackArguments[5][3];
} CDMAState;

/* Raw-memory model, not a DMA emulator. All C direct register accesses and
 * __HAL_DMA_* macros remain unchanged, so writes do not synthesize reset,
 * suspend, CFCR/W1C, global interrupt or transfer side effects. The Swift side
 * uses the same raw Set/Get. Tick events provide explicit hardware transitions;
 * snapshots at ticks and callbacks expose intermediate register/handle state.
 * Full volatile access order and real transfer side effects are checked in
 * separate Swift trace and board tests. No uint32_t pointer casts are widened.
 * Host calls cover core, register-only DMAEx, and BuildNode/GetNodeConfig.
 * Queue walks/conversions execute ONLY through DMAARMReference on ARM32.
 */
void CDMA_Reset(CDMAState *state, uint32_t controller, uint32_t channel);
void CDMA_Set(CDMAState *state, CDMARegister reg, uint32_t value);
uint32_t CDMA_Get(const CDMAState *state, CDMARegister reg);
void CDMA_SetHandle(CDMAState *state, uint32_t word, uint32_t value);
uint32_t CDMA_GetHandle(const CDMAState *state, uint32_t word);
void CDMA_SetQueue(CDMAState *state, uint32_t word, uint32_t value);
uint32_t CDMA_GetQueue(const CDMAState *state, uint32_t word);
void CDMA_SetParent(CDMAState *state, uintptr_t parent);
uintptr_t CDMA_GetParent(const CDMAState *state);
void CDMA_SetCallback(CDMAState *state, uint32_t callbackID, uint32_t implementation);
uint32_t CDMA_GetCallback(const CDMAState *state, uint32_t callbackID);
void CDMA_SetCallbackAction(CDMAState *state, uint32_t callbackID, uint32_t action,
                            uint32_t argument0, uint32_t argument1, uint32_t argument2);
uint32_t CDMA_GetCallbackAction(const CDMAState *state, uint32_t callbackID);
uint32_t CDMA_GetCallbackArgument(const CDMAState *state, uint32_t callbackID, uint32_t argument);
void CDMA_ScheduleTick(CDMAState *state, uint32_t afterCalls, CDMARegister reg, uint32_t clearMask, uint32_t setMask);
uint32_t CDMA_Tick(CDMAState *state);
CDMASnapshot CDMA_GetSnapshot(const CDMAState *state, uint32_t index);
/* Observation only: these functions never invoke a C driver from the Swift side. */
uint32_t CDMA_RecordCallback(CDMAState *state, uint32_t callbackID, uint32_t implementation);
void CDMA_SetCallbackActionStatus(CDMAState *state, uint32_t index, uint32_t status);
CDMACallbackEvent CDMA_GetCallbackEvent(const CDMAState *state, uint32_t index);
/* Calls the unchanged C operation. Init configurations are taken from the
 * state's exact HAL structs. Get-attribute operations write state.output.
 * RegisterCallback uses argument0=ID,argument1=implementation (0=nil,1/2/3=user).
 * Poll uses argument0=level,argument1=timeout. Start uses all three arguments.
 * ConfigureAttributes uses argument0. Other operations ignore the arguments. */
uint32_t CDMA_Call(CDMAState *state, CDMAOperation operation,
                   uint32_t argument0, uint32_t argument1, uint32_t argument2);
#endif
