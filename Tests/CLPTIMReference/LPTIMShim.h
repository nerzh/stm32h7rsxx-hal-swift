#define CP_JOIN_INNER(a,b) a##b
#define CP_JOIN(a,b) CP_JOIN_INNER(a,b)
#include "Upstream/LPTIMNamespace.h"
#include "LPTIMInternal.h"
#undef USE_HAL_LPTIM_REGISTER_CALLBACKS
#define USE_HAL_LPTIM_REGISTER_CALLBACKS CP_MODE
#define assert_param(expression) ((void)0)
#define UNUSED(x) ((void)(x))
#define EXTI (&CLPTIM_Active->exti)
#define SystemCoreClock CLPTIM_Clock(CLPTIM_Active)
#define IS_LPTIM_CC2_INSTANCE(x) ((x)==LPTIM1 || (x)==LPTIM2 || (x)==LPTIM3)
/* Register read boundary: permits deterministic flag arrival during polling. */
#undef __HAL_LPTIM_GET_FLAG
#define __HAL_LPTIM_GET_FLAG(h,f) ((CLPTIM_ReadISR(CLPTIM_Active)&(f))==(f))
static HAL_StatusTypeDef HAL_DMA_Start_IT(DMA_HandleTypeDef *d,uint32_t s,uint32_t t,uint32_t n) {
 return CLPTIM_DMAStart(CLPTIM_Active,(uint32_t)(d-CLPTIM_Active->dma),s,t,n,0);
}
static HAL_StatusTypeDef HAL_DMAEx_List_Start_IT(DMA_HandleTypeDef *d) {
 return CLPTIM_DMAStart(CLPTIM_Active,(uint32_t)(d-CLPTIM_Active->dma),0,0,0,1);
}
static HAL_StatusTypeDef HAL_DMA_Abort_IT(DMA_HandleTypeDef *d) {
 return CLPTIM_DMAAbort(CLPTIM_Active,(uint32_t)(d-CLPTIM_Active->dma));
}
#define TIMEOUT                                     1000UL
#define __HAL_LPTIM_WAKEUPTIMER_EXTI_ENABLE_IT(__INSTANCE__) \
  (((__INSTANCE__) == LPTIM1) ? __HAL_LPTIM_LPTIM1_EXTI_ENABLE_IT() :\
   ((__INSTANCE__) == LPTIM2) ? __HAL_LPTIM_LPTIM2_EXTI_ENABLE_IT() :\
   ((__INSTANCE__) == LPTIM3) ? __HAL_LPTIM_LPTIM3_EXTI_ENABLE_IT() :\
   ((__INSTANCE__) == LPTIM4) ? __HAL_LPTIM_LPTIM4_EXTI_ENABLE_IT() : __HAL_LPTIM_LPTIM5_EXTI_ENABLE_IT())
#define __HAL_LPTIM_WAKEUPTIMER_EXTI_DISABLE_IT(__INSTANCE__) \
  (((__INSTANCE__) == LPTIM1) ? __HAL_LPTIM_LPTIM1_EXTI_DISABLE_IT() :\
   ((__INSTANCE__) == LPTIM2) ? __HAL_LPTIM_LPTIM2_EXTI_DISABLE_IT() :\
   ((__INSTANCE__) == LPTIM3) ? __HAL_LPTIM_LPTIM3_EXTI_DISABLE_IT() :\
   ((__INSTANCE__) == LPTIM4) ? __HAL_LPTIM_LPTIM4_EXTI_DISABLE_IT() : __HAL_LPTIM_LPTIM5_EXTI_DISABLE_IT())
static HAL_StatusTypeDef LPTIM_OC1_SetConfig(LPTIM_HandleTypeDef *hlptim, const LPTIM_OC_ConfigTypeDef *sConfig);
static HAL_StatusTypeDef LPTIM_OC2_SetConfig(LPTIM_HandleTypeDef *hlptim, const LPTIM_OC_ConfigTypeDef *sConfig);
static void LPTIM_IC1_SetConfig(LPTIM_HandleTypeDef *hlptim, const LPTIM_IC_ConfigTypeDef *sConfig);
static void LPTIM_IC2_SetConfig(LPTIM_HandleTypeDef *hlptim, const LPTIM_IC_ConfigTypeDef *sConfig);
#if (USE_HAL_LPTIM_REGISTER_CALLBACKS == 1)
static void LPTIM_ResetCallback(LPTIM_HandleTypeDef *lptim);
#endif
static HAL_StatusTypeDef LPTIM_WaitForFlag(const LPTIM_HandleTypeDef *hlptim, uint32_t flag);
void LPTIM_DMAError(DMA_HandleTypeDef *hdma);
void LPTIM_DMACaptureCplt(DMA_HandleTypeDef *hdma);
void LPTIM_DMACaptureHalfCplt(DMA_HandleTypeDef *hdma);
void LPTIM_DMAUpdateEventCplt(DMA_HandleTypeDef *hdma);
void LPTIM_DMAUpdateEventHalfCplt(DMA_HandleTypeDef *hdma);
HAL_StatusTypeDef LPTIM_DMA_Start_IT(DMA_HandleTypeDef *hdma, uint32_t src, uint32_t dst,
                                     uint32_t length);

#if !CP_MODE
#undef __HAL_LPTIM_RESET_HANDLE_STATE
#define __HAL_LPTIM_RESET_HANDLE_STATE(__HANDLE__) do {                                                              \
                                                        (__HANDLE__)->State            = HAL_LPTIM_STATE_RESET;        \
                                                        (__HANDLE__)->ChannelState[0]  = HAL_LPTIM_CHANNEL_STATE_RESET;\
                                                        (__HANDLE__)->ChannelState[1]  = HAL_LPTIM_CHANNEL_STATE_RESET;\
                                                      } while(0)
#endif
