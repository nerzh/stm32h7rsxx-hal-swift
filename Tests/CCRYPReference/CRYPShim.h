#define F_JOIN_I(a,b) a##b
#define F_JOIN(a,b) F_JOIN_I(a,b)
#include "Upstream/CRYPNamespace.h"
#include "CRYPInternal.h"
#undef USE_HAL_CRYP_REGISTER_CALLBACKS
#define USE_HAL_CRYP_REGISTER_CALLBACKS F_CALLBACKS
#undef USE_HAL_CRYP_SUSPEND_RESUME
#define USE_HAL_CRYP_SUSPEND_RESUME F_SUSPEND
#if F_ENGINES == 1
#define USE_HAL_CRYP_ONLY 1
#define USE_HAL_SAES_ONLY 0
#elif F_ENGINES == 2
#define USE_HAL_CRYP_ONLY 0
#define USE_HAL_SAES_ONLY 1
#endif
#undef CRYP
#undef SAES
#define CRYP ((CRYP_TypeDef *)(CCRYP_Active->control[3]==0 ? CCRYP_Active->registers : NULL))
#define SAES ((SAES_TypeDef *)(CCRYP_Active->control[3]==1 ? CCRYP_Active->registers : NULL))
#define assert_param(x) ((void)0)
#define READ_REG(r) (r)
#define WRITE_REG(r,v) ((r)=(v))
#define READ_BIT(r,m) ((r)&(m))
#define SET_BIT(r,m) ((r)|=(m))
#define CLEAR_BIT(r,m) ((r)&=~(m))
#define MODIFY_REG(r,c,s) WRITE_REG(r,(READ_REG(r)&~(c))|(s))
#define HAL_IS_BIT_SET(r,m) (((r)&(m))==(m))
#define HAL_IS_BIT_CLR(r,m) (((r)&(m))==0U)
#define UNUSED(x) ((void)(x))
#define HAL_GetTick() CCRYP_Tick()
#define HAL_GetREVID() (CCRYP_Active->control[7])
#define HAL_DMA_Start_IT CCRYP_DMAStart
#define HAL_DMAEx_List_Start_IT CCRYP_DMAList
#define HAL_DMA_Abort CCRYP_DMAAbort
#if !F_CALLBACKS
#undef __HAL_CRYP_RESET_HANDLE_STATE
#define __HAL_CRYP_RESET_HANDLE_STATE(h) ((h)->State=HAL_CRYP_STATE_RESET)
#endif
#include "CRYPPrivate.h"
#include "CRYPPrototypes.h"
#if defined(__clang__)
#pragma clang diagnostic ignored "-Wpointer-to-int-cast"
#pragma clang diagnostic ignored "-Wint-to-pointer-cast"
#endif
