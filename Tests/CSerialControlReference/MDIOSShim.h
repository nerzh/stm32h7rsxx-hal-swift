#define SC_JOIN_INNER(a,b) a##b
#define SC_JOIN(a,b) SC_JOIN_INNER(a,b)
#include "Upstream/MDIOSNamespace.h"
#include "SerialInternal.h"
#undef USE_HAL_MDIOS_REGISTER_CALLBACKS
#define USE_HAL_MDIOS_REGISTER_CALLBACKS SC_MODE
#define assert_param(expression) ((void)0)
#define UNUSED(x) ((void)(x))
#define READ_REG(reg) (reg)
#define SET_BIT(reg,mask) ((reg)|=(mask))
#define CLEAR_BIT(reg,mask) ((reg)&=~(mask))
#define HAL_IS_BIT_SET(reg,mask) (((reg)&(mask))==(mask))
#define EXTI (&CSerial_Active->exti)
#define MDIOS_PORT_ADDRESS_SHIFT 8U
#define MDIOS_ALL_REG_FLAG 0xFFFFFFFFU
#define MDIOS_ALL_ERRORS_FLAG (MDIOS_SR_PERF | MDIOS_SR_SERF | MDIOS_SR_TERF)
#define MDIOS_DIN_BASE_ADDR ((uintptr_t)&CSerial_Active->mdios.DINR0)
#define MDIOS_DOUT_BASE_ADDR ((uintptr_t)&CSerial_Active->mdios.DOUTR0)
#if SC_MODE
static void MDIOS_InitCallbacksToDefault(MDIOS_HandleTypeDef *);
#endif
#if !SC_MODE
#undef __HAL_MDIOS_RESET_HANDLE_STATE
#define __HAL_MDIOS_RESET_HANDLE_STATE(__HANDLE__) ((__HANDLE__)->State = HAL_MDIOS_STATE_RESET)
#endif
