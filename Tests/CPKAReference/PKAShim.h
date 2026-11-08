#define F_JOIN_I(a,b) a##b
#define F_JOIN(a,b) F_JOIN_I(a,b)
#include "Upstream/PKANamespace.h"
#include "PKADefinitions.h"
#undef USE_HAL_PKA_REGISTER_CALLBACKS
#define USE_HAL_PKA_REGISTER_CALLBACKS F_MODE
uint32_t CPKA_Tick(void);
#define HAL_GetTick() CPKA_Tick()
#define HAL_MAX_DELAY UINT32_MAX
#define PKA_RAM_SIZE 1334U
#define PKA_RAM_ERASE_TIMEOUT 1000U
#define __PKA_RAM_PARAM_END(tab,i) do { (tab)[i]=0U; (tab)[(i)+1U]=0U; } while(0)
#define __CLZ(x) ((uint32_t)(x)==0U?32U:(uint32_t)__builtin_clz((uint32_t)(x)))
#define assert_param(x) ((void)0)
#define UNUSED(x) ((void)(x))
#define READ_REG(r) (r)
#define WRITE_REG(r,v) ((r)=(v))
#define READ_BIT(r,m) ((r)&(m))
#define SET_BIT(r,m) ((r)|=(m))
#define CLEAR_BIT(r,m) ((r)&=~(m))
#define MODIFY_REG(r,c,s) ((r)=(((r)&~(c))|(s)))
#include "PKAPrototypes.h"
#if !F_MODE
#undef __HAL_PKA_RESET_HANDLE_STATE
#define __HAL_PKA_RESET_HANDLE_STATE(h) ((h)->State=HAL_PKA_STATE_RESET)
#endif
