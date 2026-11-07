/* ARM-only hardware fixture and callback recorder. This file contains no
 * RAMECC driver algorithm; RAMECC0.c/RAMECC1.c include unchanged upstream bodies. */
#include <stdint.h>
#if defined(__arm__) && UINTPTR_MAX == UINT32_MAX
#include "include/CRAMECCReference.h"
#include "Upstream/RAMECC0Prototypes.h"
#include "Upstream/RAMECC1Prototypes.h"
#include <stddef.h>

typedef void (*CRAMECC1Callback)(CRAMECC1Handle *);
struct CRAMECCContext {
    CRAMECC0Handle handle0;
    CRAMECC1Handle handle1;
    uint32_t variant;
    uint32_t actions[4];
    uint32_t eventCount;
    uint32_t events[32][12];
};
static CRAMECCContext *currentContext;
_Static_assert(sizeof(CRAMECCContext) <= 0x1000, "RAMECC harness context reservation");

static volatile uint32_t *registerAddress(CRAMECCContext *context, uint32_t index) {
    uintptr_t address = CRAMECC_MonitorAddress(context);
    if (index > CRAMECC_FECR) __builtin_trap();
    if (index == CRAMECC_IER) address &= 0xFFFFFF00U;
    else address += (index - 1U) * 4U;
    return (volatile uint32_t *)address;
}
RAMECC_MonitorTypeDef *CRAMECC_CurrentMonitor(void) {
    return (RAMECC_MonitorTypeDef *)CRAMECC_MonitorAddress(currentContext);
}
uint32_t CRAMECC_ContextSize(void) { return sizeof(CRAMECCContext); }
CRAMECCContext *CRAMECC_Prepare(uintptr_t storage, uintptr_t monitorAddress,
                              uint32_t registeredCallbacks, uint32_t state, uint32_t error) {
    if ((storage & 3U) != 0U || registeredCallbacks > 1U || (monitorAddress & 0x1FU) != 0U ||
        (monitorAddress & 0xFFU) < 0x20U || (monitorAddress & 0xFFU) > 0xA0U) __builtin_trap();
    CRAMECCContext *context = (CRAMECCContext *)storage;
    volatile uint8_t *bytes = (volatile uint8_t *)context;
    for (uint32_t index = 0; index < sizeof(*context); index++) bytes[index] = 0;
    context->variant = registeredCallbacks;
    context->handle0.Instance = (RAMECC_MonitorTypeDef *)monitorAddress;
    context->handle1.Instance = (RAMECC_MonitorTypeDef *)monitorAddress;
    context->handle0.State = (HAL_RAMECC_StateTypeDef)state;
    context->handle1.State = (HAL_RAMECC_StateTypeDef)state;
    context->handle0.ErrorCode = error;
    context->handle1.ErrorCode = error;
    return context;
}
uintptr_t CRAMECC_StateAddress(CRAMECCContext *context) {
    return context->variant ? (uintptr_t)&context->handle1.State : (uintptr_t)&context->handle0.State;
}
uintptr_t CRAMECC_MonitorAddress(CRAMECCContext *context) {
    return context->variant ? (uintptr_t)context->handle1.Instance : (uintptr_t)context->handle0.Instance;
}
uint32_t CRAMECC_Variant(CRAMECCContext *context) { return context->variant; }
uint32_t CRAMECC_ReadRegister(CRAMECCContext *context, uint32_t index) { return *registerAddress(context, index); }
void CRAMECC_WriteRegister(CRAMECCContext *context, uint32_t index, uint32_t value) { *registerAddress(context, index) = value; }

void CRAMECC_SetAction(CRAMECCContext *context, uint32_t id, uint32_t action) {
    if (id >= 4 || action > 2) __builtin_trap();
    context->actions[id] = action;
}
uint32_t CRAMECC_ActionMask(CRAMECCContext *context) {
    uint32_t mask = 0;
    for (uint32_t index = 0; index < 4; index++) mask |= context->actions[index] << (index * 2U);
    return mask;
}
uint32_t CRAMECC_RecordCallback(CRAMECCContext *context, uint32_t id, uint32_t selector, uint32_t callbackMask) {
    if (id >= 4 || context->eventCount >= 32) __builtin_trap();
    uint32_t *event = context->events[context->eventCount++];
    volatile uint32_t *state = (volatile uint32_t *)CRAMECC_StateAddress(context);
    event[0] = id;
    event[1] = selector;
    for (uint32_t index = 0; index < 7; index++) event[2 + index] = CRAMECC_ReadRegister(context, index);
    event[9] = state[0];
    event[10] = state[1];
    event[11] = callbackMask;
    uint32_t action = context->actions[id];
    context->actions[id] = 0;
    return action;
}
void CRAMECC_ApplyMutation(CRAMECCContext *context, uint32_t id) {
    /* Deliberate callback-owned fixture changes, shared by the C and Swift
     * harnesses. They exercise cached IRQ enables and lifecycle ordering. */
    CRAMECC_WriteRegister(context, CRAMECC_IER, CRAMECC_ReadRegister(context, CRAMECC_IER) ^ 0xFU);
    CRAMECC_WriteRegister(context, CRAMECC_CR, CRAMECC_ReadRegister(context, CRAMECC_CR) ^ 0x3CU);
    CRAMECC_WriteRegister(context, CRAMECC_SR, CRAMECC_ReadRegister(context, CRAMECC_SR) ^ 6U);
    volatile uint32_t *state = (volatile uint32_t *)CRAMECC_StateAddress(context);
    state[0] = HAL_RAMECC_STATE_ERROR;
    state[1] = 0xA5000000U | id;
}
static void callback(uint32_t id, uint32_t selector) {
    CRAMECCContext *context = currentContext;
    uint32_t action = CRAMECC_RecordCallback(context, id, selector, CRAMECC_CallbackMask(context));
    if (action == 1) CRAMECC_ApplyMutation(context, id);
    else if (action == 2) {
        if (context->variant) CRAMECC1_HAL_RAMECC_IRQHandler(&context->handle1);
        else CRAMECC0_HAL_RAMECC_IRQHandler(&context->handle0);
    }
}
void CRAMECC0_HAL_RAMECC_MspInit(CRAMECC0Handle *handle) { (void)handle; callback(0U, 1U); }
void CRAMECC0_HAL_RAMECC_MspDeInit(CRAMECC0Handle *handle) { (void)handle; callback(1U, 1U); }
void CRAMECC0_HAL_RAMECC_DetectSingleErrorCallback(CRAMECC0Handle *handle) { (void)handle; callback(2U, 1U); }
void CRAMECC0_HAL_RAMECC_DetectDoubleErrorCallback(CRAMECC0Handle *handle) { (void)handle; callback(3U, 1U); }
void CRAMECC1_HAL_RAMECC_MspInit(CRAMECC1Handle *handle) { (void)handle; callback(0U, 1U); }
void CRAMECC1_HAL_RAMECC_MspDeInit(CRAMECC1Handle *handle) { (void)handle; callback(1U, 1U); }
void CRAMECC1_HAL_RAMECC_DetectSingleErrorCallback(CRAMECC1Handle *handle) { (void)handle; callback(2U, 1U); }
void CRAMECC1_HAL_RAMECC_DetectDoubleErrorCallback(CRAMECC1Handle *handle) { (void)handle; callback(3U, 1U); }
static void user0_2(CRAMECC1Handle *handle) { (void)handle; callback(0U, 2U); }
static void user0_3(CRAMECC1Handle *handle) { (void)handle; callback(0U, 3U); }
static void user1_2(CRAMECC1Handle *handle) { (void)handle; callback(1U, 2U); }
static void user1_3(CRAMECC1Handle *handle) { (void)handle; callback(1U, 3U); }
static void user2_2(CRAMECC1Handle *handle) { (void)handle; callback(2U, 2U); }
static void user2_3(CRAMECC1Handle *handle) { (void)handle; callback(2U, 3U); }
static void user3_2(CRAMECC1Handle *handle) { (void)handle; callback(3U, 2U); }
static void user3_3(CRAMECC1Handle *handle) { (void)handle; callback(3U, 3U); }

static CRAMECC1Callback selectCallback(uint32_t id, uint32_t selector) {
    if (selector == 0) return NULL;
    if (id > 3) id = 0; /* Unknown registration IDs still receive a nonnil callback. */
    switch (id) {
    case 0: if (selector == 1) return CRAMECC1_HAL_RAMECC_MspInit; return selector == 2 ? user0_2 : user0_3;
    case 1: if (selector == 1) return CRAMECC1_HAL_RAMECC_MspDeInit; return selector == 2 ? user1_2 : user1_3;
    case 2: if (selector == 1) return CRAMECC1_HAL_RAMECC_DetectSingleErrorCallback; return selector == 2 ? user2_2 : user2_3;
    case 3: if (selector == 1) return CRAMECC1_HAL_RAMECC_DetectDoubleErrorCallback; return selector == 2 ? user3_2 : user3_3;
    default: __builtin_trap();
    }
}
static CRAMECC1Callback *callbackSlot(CRAMECCContext *context, uint32_t id) {
    switch (id) {
    case 0: return &context->handle1.MspInitCallback;
    case 1: return &context->handle1.MspDeInitCallback;
    case 2: return &context->handle1.DetectSingleErrorCallback;
    case 3: return &context->handle1.DetectDoubleErrorCallback;
    default: __builtin_trap();
    }
}
void CRAMECC_SetCallback(CRAMECCContext *context, uint32_t id, uint32_t selector) {
    if (id > 3 || selector > 3) __builtin_trap();
    if (context->variant) *callbackSlot(context, id) = selectCallback(id, selector);
}
uint32_t CRAMECC_CallbackMask(CRAMECCContext *context) {
    if (!context->variant) return 0;
    uint32_t mask = 0;
    for (uint32_t id = 0; id < 4; id++) {
        CRAMECC1Callback function = *callbackSlot(context, id);
        if (function == NULL) continue;
        uint32_t selector;
        for (selector = 1; selector <= 3; selector++) if (function == selectCallback(id, selector)) break;
        if (selector > 3) __builtin_trap();
        mask |= selector << (id * 2U);
    }
    return mask;
}
uint32_t CRAMECC_Run(CRAMECCContext *context, uint32_t operation, uint32_t argument, uint32_t selector) {
    CRAMECCContext *saved = currentContext;
    currentContext = context;
    uint32_t result = 0;
    if (context->variant) {
        CRAMECC1Handle *handle = &context->handle1;
        switch (operation) {
        case CRAMECC_INIT: result = CRAMECC1_HAL_RAMECC_Init(handle); break;
        case CRAMECC_DEINIT: result = CRAMECC1_HAL_RAMECC_DeInit(handle); break;
        case CRAMECC_START: result = CRAMECC1_HAL_RAMECC_StartMonitor(handle); break;
        case CRAMECC_STOP: result = CRAMECC1_HAL_RAMECC_StopMonitor(handle); break;
        case CRAMECC_ENABLE_NOTIFICATION: result = CRAMECC1_HAL_RAMECC_EnableNotification(handle, argument); break;
        case CRAMECC_DISABLE_NOTIFICATION: result = CRAMECC1_HAL_RAMECC_DisableNotification(handle, argument); break;
        case CRAMECC_IRQ: CRAMECC1_HAL_RAMECC_IRQHandler(handle); break;
        case CRAMECC_GET_FAR: result = CRAMECC1_HAL_RAMECC_GetFailingAddress(handle); break;
        case CRAMECC_GET_FDRL: result = CRAMECC1_HAL_RAMECC_GetFailingDataLow(handle); break;
        case CRAMECC_GET_FDRH: result = CRAMECC1_HAL_RAMECC_GetFailingDataHigh(handle); break;
        case CRAMECC_GET_FECR: result = CRAMECC1_HAL_RAMECC_GetHammingErrorCode(handle); break;
        case CRAMECC_IS_SINGLE: result = CRAMECC1_HAL_RAMECC_IsECCSingleErrorDetected(handle); break;
        case CRAMECC_IS_DOUBLE: result = CRAMECC1_HAL_RAMECC_IsECCDoubleErrorDetected(handle); break;
        case CRAMECC_GET_STATE: result = CRAMECC1_HAL_RAMECC_GetState(handle); break;
        case CRAMECC_GET_ERROR: result = CRAMECC1_HAL_RAMECC_GetError(handle); break;
        case CRAMECC_REGISTER_CALLBACK:
            result = CRAMECC1_HAL_RAMECC_RegisterCallback(handle, (HAL_RAMECC_CallbackIDTypeDef)argument,
                                                          selectCallback(argument, selector)); break;
        case CRAMECC_UNREGISTER_CALLBACK:
            result = CRAMECC1_HAL_RAMECC_UnRegisterCallback(handle, (HAL_RAMECC_CallbackIDTypeDef)argument); break;
        default: __builtin_trap();
        }
    } else {
        CRAMECC0Handle *handle = &context->handle0;
        switch (operation) {
        case CRAMECC_INIT: result = CRAMECC0_HAL_RAMECC_Init(handle); break;
        case CRAMECC_DEINIT: result = CRAMECC0_HAL_RAMECC_DeInit(handle); break;
        case CRAMECC_START: result = CRAMECC0_HAL_RAMECC_StartMonitor(handle); break;
        case CRAMECC_STOP: result = CRAMECC0_HAL_RAMECC_StopMonitor(handle); break;
        case CRAMECC_ENABLE_NOTIFICATION: result = CRAMECC0_HAL_RAMECC_EnableNotification(handle, argument); break;
        case CRAMECC_DISABLE_NOTIFICATION: result = CRAMECC0_HAL_RAMECC_DisableNotification(handle, argument); break;
        case CRAMECC_IRQ: CRAMECC0_HAL_RAMECC_IRQHandler(handle); break;
        case CRAMECC_GET_FAR: result = CRAMECC0_HAL_RAMECC_GetFailingAddress(handle); break;
        case CRAMECC_GET_FDRL: result = CRAMECC0_HAL_RAMECC_GetFailingDataLow(handle); break;
        case CRAMECC_GET_FDRH: result = CRAMECC0_HAL_RAMECC_GetFailingDataHigh(handle); break;
        case CRAMECC_GET_FECR: result = CRAMECC0_HAL_RAMECC_GetHammingErrorCode(handle); break;
        case CRAMECC_IS_SINGLE: result = CRAMECC0_HAL_RAMECC_IsECCSingleErrorDetected(handle); break;
        case CRAMECC_IS_DOUBLE: result = CRAMECC0_HAL_RAMECC_IsECCDoubleErrorDetected(handle); break;
        case CRAMECC_GET_STATE: result = CRAMECC0_HAL_RAMECC_GetState(handle); break;
        case CRAMECC_GET_ERROR: result = CRAMECC0_HAL_RAMECC_GetError(handle); break;
        default: __builtin_trap();
        }
    }
    currentContext = saved;
    return result;
}
uint32_t CRAMECC_SnapshotWordCount(CRAMECCContext *context) { return 11U + context->eventCount * 12U; }
uint32_t CRAMECC_SnapshotWord(CRAMECCContext *context, uint32_t callbackMask, uint32_t index) {
    if (index < 7) return CRAMECC_ReadRegister(context, index);
    volatile uint32_t *state = (volatile uint32_t *)CRAMECC_StateAddress(context);
    if (index < 9) return state[index - 7];
    if (index == 9) return callbackMask;
    if (index == 10) return context->eventCount;
    index -= 11;
    if (index >= context->eventCount * 12U) __builtin_trap();
    return context->events[index / 12U][index % 12U];
}
#endif
