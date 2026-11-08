#define F_JOIN_I(a,b) a##b
#define F_JOIN(a,b) F_JOIN_I(a,b)
#include "Upstream/RTCNamespace.h"
#include "RTCDefinitions.h"
#undef USE_HAL_RTC_REGISTER_CALLBACKS
#define USE_HAL_RTC_REGISTER_CALLBACKS F_MODE
extern RTC_TypeDef *CRTC_RTC;
extern TAMP_TypeDef *CRTC_TAMP;
uint32_t CRTC_Tick(void);
#define RTC CRTC_RTC
#define TAMP CRTC_TAMP
#define TAMP_ALL RTC_TAMPER_ALL
#define HAL_GetTick() CRTC_Tick()
#define HAL_MAX_DELAY UINT32_MAX
#define assert_param(x) ((void)0)
#define UNUSED(x) ((void)(x))
#define READ_REG(r) (r)
#define WRITE_REG(r,v) ((r)=(v))
#define CLEAR_REG(r) ((r)=0U)
#define READ_BIT(r,m) ((r)&(m))
#define SET_BIT(r,m) ((r)|=(m))
#define CLEAR_BIT(r,m) ((r)&=~(m))
#define MODIFY_REG(r,c,s) ((r)=(((r)&~(c))|(s)))
#if !F_MODE
#undef __HAL_RTC_RESET_HANDLE_STATE
#define __HAL_RTC_RESET_HANDLE_STATE(h) ((h)->State=HAL_RTC_STATE_RESET)
#endif
