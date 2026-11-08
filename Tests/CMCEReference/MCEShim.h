#define M_JOIN_I(a,b) a##b
#define M_JOIN(a,b) M_JOIN_I(a,b)
#include "Upstream/MCENamespace.h"
#include "MCEInternal.h"
#undef USE_HAL_MCE_REGISTER_CALLBACKS
#define USE_HAL_MCE_REGISTER_CALLBACKS M_MODE
#undef MCE1
#define MCE1 ((MCE_TypeDef *)(CMCE_Active->instance==1 ? CMCE_Active->regs : (void*)1))
#define MCE2 ((MCE_TypeDef *)(CMCE_Active->instance==2 ? CMCE_Active->regs : (void*)2))
#define MCE3 ((MCE_TypeDef *)(CMCE_Active->instance==3 ? CMCE_Active->regs : (void*)3))
#define MCE_TIMEOUT_VALUE 255U
#define MCE1_CONTEXT_NB 2U
#define assert_param(x) ((void)0)
#define READ_REG(reg) (reg)
#define READ_BIT(reg,mask) ((reg)&(mask))
#define WRITE_REG(reg,val) CMCE_Write(CMCE_Active,(uint32_t)((uintptr_t)&(reg)-(uintptr_t)CMCE_Active->regs),(val))
#define SET_BIT(reg,mask) WRITE_REG(reg,(reg)|(mask))
#define CLEAR_BIT(reg,mask) WRITE_REG(reg,(reg)&~(mask))
#define MODIFY_REG(reg,clear,set) WRITE_REG(reg,((reg)&~(clear))|(set))
#define HAL_IS_BIT_CLR(reg,mask) (((reg)&(mask))==0U)
#define HAL_GetTick() CMCE_Tick(CMCE_Active)
#if !M_MODE
#undef __HAL_MCE_RESET_HANDLE_STATE
#define __HAL_MCE_RESET_HANDLE_STATE(h) ((h)->State=HAL_MCE_STATE_RESET)
#endif
