#define SC_JOIN_INNER(a,b) a##b
#define SC_JOIN(a,b) SC_JOIN_INNER(a,b)
#include "Upstream/CECNamespace.h"
#include "SerialInternal.h"
#undef USE_HAL_CEC_REGISTER_CALLBACKS
#define USE_HAL_CEC_REGISTER_CALLBACKS SC_MODE
#define assert_param(expression) ((void)0)
#define UNUSED(x) ((void)(x))
#define READ_REG(reg) (reg)
#define SET_BIT(reg,mask) ((reg)|=(mask))
#define CLEAR_BIT(reg,mask) ((reg)&=~(mask))
#define HAL_IS_BIT_SET(reg,mask) (((reg)&(mask))==(mask))
#define EXTI (&CSerial_Active->exti)
#if !SC_MODE
#undef __HAL_CEC_RESET_HANDLE_STATE
#define __HAL_CEC_RESET_HANDLE_STATE(__HANDLE__) do{                                                   \
                                                       (__HANDLE__)->gState = HAL_CEC_STATE_RESET;     \
                                                       (__HANDLE__)->RxState = HAL_CEC_STATE_RESET;    \
                                                     } while(0)
#endif
